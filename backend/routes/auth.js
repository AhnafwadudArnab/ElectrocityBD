const express = require('express');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const pool = require('../config/db');
const { authenticateToken } = require('../middleware/auth');

const router = express.Router();

// POST /api/auth/register
router.post('/register', async (req, res) => {
  try {
    const { firstName, lastName, email, password, phone, gender } = req.body;
    if (!firstName || !email || !password) {
      return res.status(400).json({ error: 'firstName, email, and password are required.' });
    }

    const [existing] = await pool.query('SELECT user_id FROM users WHERE email = ?', [email]);
    if (existing.length > 0) {
      return res.status(409).json({ error: 'Email already registered.' });
    }

    const hashedPassword = await bcrypt.hash(password, 10);
    const [result] = await pool.query(
      `INSERT INTO users (full_name, last_name, email, password, phone_number, gender, role)
       VALUES (?, ?, ?, ?, ?, ?, 'customer')`,
      [firstName, lastName || '', email, hashedPassword, phone || '', gender || 'Male']
    );

    const token = jwt.sign(
      { userId: result.insertId, email, role: 'customer' },
      process.env.JWT_SECRET,
      { expiresIn: '7d' }
    );

    res.status(201).json({
      message: 'Registration successful',
      token,
      user: {
        userId: result.insertId,
        firstName,
        lastName: lastName || '',
        email,
        phone: phone || '',
        gender: gender || 'Male',
        role: 'customer',
      },
    });
  } catch (err) {
    console.error('Register error:', err);
    res.status(500).json({ error: 'Server error.' });
  }
});

// POST /api/auth/login
router.post('/login', async (req, res) => {
  try {
    const { email, password } = req.body;
    if (!email || !password) {
      return res.status(400).json({ error: 'Email and password are required.' });
    }

    const [rows] = await pool.query('SELECT * FROM users WHERE email = ?', [email]);
    if (rows.length === 0) {
      return res.status(401).json({ error: 'Invalid email or password.' });
    }

    const user = rows[0];
    const validPassword = await bcrypt.compare(password, user.password);
    if (!validPassword) {
      return res.status(401).json({ error: 'Invalid email or password.' });
    }

    const token = jwt.sign(
      { userId: user.user_id, email: user.email, role: user.role },
      process.env.JWT_SECRET,
      { expiresIn: '7d' }
    );

    res.json({
      message: 'Login successful',
      token,
      user: {
        userId: user.user_id,
        firstName: user.full_name,
        lastName: user.last_name,
        email: user.email,
        phone: user.phone_number || '',
        gender: user.gender || 'Male',
        role: user.role,
      },
    });
  } catch (err) {
    console.error('Login error:', err);
    res.status(500).json({ error: 'Server error.' });
  }
});

// POST /api/auth/admin-login (username + password shortcut)
router.post('/admin-login', async (req, res) => {
  try {
    const { username, password } = req.body;
    if (!username || !password) {
      return res.status(400).json({ error: 'Username and password are required.' });
    }

    const [rows] = await pool.query(
      "SELECT * FROM users WHERE (email = ? OR full_name = ?) AND role = 'admin'",
      [username, username]
    );

    if (rows.length === 0) {
      return res.status(401).json({ error: 'Invalid admin credentials.' });
    }

    const admin = rows[0];
    const validPassword = await bcrypt.compare(password, admin.password);
    if (!validPassword) {
      return res.status(401).json({ error: 'Invalid admin credentials.' });
    }

    const token = jwt.sign(
      { userId: admin.user_id, email: admin.email, role: 'admin' },
      process.env.JWT_SECRET,
      { expiresIn: '7d' }
    );

    res.json({
      message: 'Admin login successful',
      token,
      user: {
        userId: admin.user_id,
        firstName: admin.full_name,
        lastName: admin.last_name,
        email: admin.email,
        role: 'admin',
      },
    });
  } catch (err) {
    console.error('Admin login error:', err);
    res.status(500).json({ error: 'Server error.' });
  }
});

// GET /api/auth/me - get current user profile
router.get('/me', authenticateToken, async (req, res) => {
  try {
    const [rows] = await pool.query(
      'SELECT user_id, full_name, last_name, email, phone_number, address, gender, role, created_at FROM users WHERE user_id = ?',
      [req.user.userId]
    );
    if (rows.length === 0) return res.status(404).json({ error: 'User not found.' });

    const u = rows[0];
    res.json({
      userId: u.user_id,
      firstName: u.full_name,
      lastName: u.last_name,
      email: u.email,
      phone: u.phone_number || '',
      address: u.address || '',
      gender: u.gender || 'Male',
      role: u.role,
      createdAt: u.created_at,
    });
  } catch (err) {
    console.error('Get profile error:', err);
    res.status(500).json({ error: 'Server error.' });
  }
});

// PUT /api/auth/me - update profile
router.put('/me', authenticateToken, async (req, res) => {
  try {
    const { firstName, lastName, phone, address, gender } = req.body;
    await pool.query(
      `UPDATE users SET full_name = COALESCE(?, full_name), last_name = COALESCE(?, last_name),
       phone_number = COALESCE(?, phone_number), address = COALESCE(?, address),
       gender = COALESCE(?, gender) WHERE user_id = ?`,
      [firstName, lastName, phone, address, gender, req.user.userId]
    );
    res.json({ message: 'Profile updated.' });
  } catch (err) {
    console.error('Update profile error:', err);
    res.status(500).json({ error: 'Server error.' });
  }
});

module.exports = router;
