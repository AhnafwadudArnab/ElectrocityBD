const express = require('express');
const jwt = require('jsonwebtoken');
const pool = require('../config/db');
const { authenticateToken } = require('../middleware/auth');

const router = express.Router();

function getJwtSecret() {
  const secret = process.env.JWT_SECRET;
  if (!secret || String(secret).trim() === '') {
    return null;
  }
  return secret;
}

function ensureJwtSecret(req, res, next) {
  if (!getJwtSecret()) {
    return res.status(503).json({
      error: 'Server misconfiguration: JWT_SECRET is not set. Add JWT_SECRET in Vercel Project Settings > Environment Variables.',
    });
  }
  next();
}

// POST /api/auth/register
router.post('/register', ensureJwtSecret, async (req, res) => {
  try {
    const body = req.body || {};
    const { firstName, lastName, email, password, phone, gender } = body;
    if (!firstName || !email || !password) {
      return res.status(400).json({ error: 'firstName, email, and password are required.' });
    }

    const [existing] = await pool.query('SELECT user_id FROM users WHERE email = ?', [email]);
    if (existing.length > 0) {
      return res.status(409).json({ error: 'Email already registered.' });
    }

    const [result] = await pool.query(
      `INSERT INTO users (full_name, last_name, email, password, phone_number, gender, role)
       VALUES (?, ?, ?, ?, ?, ?, 'customer')`,
      [firstName, lastName || '', email, String(password), phone || '', gender || 'Male']
    );
    const userId = result.insertId;
    await pool.query(
      `INSERT INTO user_profile (user_id, full_name, last_name, phone_number, address, gender)
       VALUES (?, ?, ?, ?, '', ?)
       ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), last_name = VALUES(last_name),
         phone_number = VALUES(phone_number), gender = VALUES(gender)`,
      [userId, firstName, lastName || '', phone || '', gender || 'Male']
    );

    const token = jwt.sign(
      { userId, email, role: 'customer' },
      getJwtSecret(),
      { expiresIn: '7d' }
    );

    res.status(201).json({
      message: 'Registration successful',
      token,
      user: {
        userId,
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
    const msg = process.env.NODE_ENV === 'development' ? err.message : 'Server error.';
    res.status(500).json({ error: msg });
  }
});

// POST /api/auth/login
router.post('/login', ensureJwtSecret, async (req, res) => {
  try {
    const body = req.body || {};
    const { email, password } = body;
    if (!email || !password) {
      return res.status(400).json({ error: 'Email and password are required.' });
    }

    const [rows] = await pool.query('SELECT * FROM users WHERE email = ?', [email]);
    if (rows.length === 0) {
      return res.status(401).json({ error: 'Invalid email or password.' });
    }

    const user = rows[0];
    if (user.password !== String(password)) {
      return res.status(401).json({ error: 'Invalid email or password.' });
    }

    const token = jwt.sign(
      { userId: user.user_id, email: user.email, role: user.role },
      getJwtSecret(),
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
    const msg = process.env.NODE_ENV === 'development' ? err.message : 'Server error.';
    res.status(500).json({ error: msg });
  }
});

// POST /api/auth/admin-login (username + password shortcut)
router.post('/admin-login', ensureJwtSecret, async (req, res) => {
  try {
    const body = req.body || {};
    const { username, password } = body;
    if (!username || !password) {
      return res.status(400).json({ error: 'Username and password are required.' });
    }

    const [rows] = await pool.query(
      "SELECT * FROM users WHERE (LOWER(TRIM(email)) = LOWER(TRIM(?)) OR LOWER(TRIM(full_name)) = LOWER(TRIM(?))) AND role = 'admin'",
      [String(username).trim(), String(username).trim()]
    );

    if (rows.length === 0) {
      return res.status(401).json({ error: 'Invalid admin credentials. Run: cd backend && npm run db:init' });
    }

    const admin = rows[0];
    const storedPassword = admin.password || admin.PASSWORD || '';
    if (storedPassword !== String(password)) {
      return res.status(401).json({ error: 'Invalid admin credentials.' });
    }

    const token = jwt.sign(
      { userId: admin.user_id, email: admin.email, role: 'admin' },
      getJwtSecret(),
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

// PUT /api/auth/change-password - plain password update
router.put('/change-password', authenticateToken, async (req, res) => {
  try {
    const { currentPassword, newPassword } = req.body;
    if (!currentPassword || !newPassword) {
      return res.status(400).json({ error: 'Current and new password are required.' });
    }
    const [[row]] = await pool.query('SELECT password FROM users WHERE user_id = ?', [req.user.userId]);
    if (!row || row.password !== String(currentPassword)) {
      return res.status(401).json({ error: 'Current password is wrong.' });
    }
    await pool.query('UPDATE users SET password = ? WHERE user_id = ?', [String(newPassword), req.user.userId]);
    res.json({ message: 'Password updated.' });
  } catch (err) {
    console.error('Change password error:', err);
    res.status(500).json({ error: 'Server error.' });
  }
});

// PUT /api/auth/me - update profile (users + user_profile for orders/display)
router.put('/me', authenticateToken, async (req, res) => {
  try {
    const { firstName, lastName, phone, address, gender } = req.body;
    const uid = req.user.userId;
    const [[current]] = await pool.query(
      'SELECT full_name, last_name, phone_number, address, gender FROM users WHERE user_id = ?',
      [uid]
    );
    const fn = firstName != null ? firstName : (current?.full_name ?? '');
    const ln = lastName != null ? lastName : (current?.last_name ?? '');
    const ph = phone != null ? phone : (current?.phone_number ?? '');
    const adr = address != null ? address : (current?.address ?? '');
    const g = gender != null ? gender : (current?.gender ?? 'Male');

    await pool.query(
      `UPDATE users SET full_name = ?, last_name = ?, phone_number = ?, address = ?, gender = ? WHERE user_id = ?`,
      [fn, ln, ph, adr, g, uid]
    );
    await pool.query(
      `INSERT INTO user_profile (user_id, full_name, last_name, phone_number, address, gender)
       VALUES (?, ?, ?, ?, ?, ?)
       ON DUPLICATE KEY UPDATE
         full_name = VALUES(full_name), last_name = VALUES(last_name),
         phone_number = VALUES(phone_number), address = VALUES(address),
         gender = VALUES(gender)`,
      [uid, fn, ln, ph, adr, g]
    );
    res.json({ message: 'Profile updated.' });
  } catch (err) {
    console.error('Update profile error:', err);
    res.status(500).json({ error: 'Server error.' });
  }
});

module.exports = router;
