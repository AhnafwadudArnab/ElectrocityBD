const express = require('express');
const pool = require('../config/db');
const { authenticateToken, requireAdmin } = require('../middleware/auth');

const router = express.Router();

// GET /api/promotions - list all
router.get('/', async (req, res) => {
  try {
    const [rows] = await pool.query(
      'SELECT * FROM promotions ORDER BY start_date DESC'
    );
    res.json(rows);
  } catch (err) {
    console.error('Promotions get error:', err);
    res.status(500).json({ error: 'Server error.' });
  }
});

// POST /api/promotions - admin create
router.post('/', authenticateToken, requireAdmin, async (req, res) => {
  try {
    const { title, description, discount_percent, start_date, end_date, active } = req.body;
    if (!title || String(title).trim() === '') return res.status(400).json({ error: 'Title required.' });
    const [result] = await pool.query(
      `INSERT INTO promotions (title, description, discount_percent, start_date, end_date, active)
       VALUES (?, ?, ?, ?, ?, ?)`,
      [title, description || '', discount_percent != null ? parseFloat(discount_percent) : null,
       start_date || null, end_date || null, active !== false ? 1 : 0]
    );
    res.status(201).json({ message: 'Promotion created.', promotionId: result.insertId });
  } catch (err) {
    console.error('Promotion create error:', err);
    res.status(500).json({ error: 'Server error.' });
  }
});

// PUT /api/promotions/:id - admin update
router.put('/:id', authenticateToken, requireAdmin, async (req, res) => {
  try {
    const { title, description, discount_percent, start_date, end_date, active } = req.body;
    const updates = [];
    const params = [];
    if (title !== undefined) { updates.push(' title = ?'); params.push(title); }
    if (description !== undefined) { updates.push(' description = ?'); params.push(description); }
    if (discount_percent !== undefined) { updates.push(' discount_percent = ?'); params.push(parseFloat(discount_percent)); }
    if (start_date !== undefined) { updates.push(' start_date = ?'); params.push(start_date); }
    if (end_date !== undefined) { updates.push(' end_date = ?'); params.push(end_date); }
    if (active !== undefined) { updates.push(' active = ?'); params.push(active ? 1 : 0); }
    if (updates.length === 0) return res.status(400).json({ error: 'Provide at least one field to update.' });
    params.push(req.params.id);
    await pool.query(
      `UPDATE promotions SET ${updates.join(',')} WHERE promotion_id = ?`,
      params
    );
    res.json({ message: 'Promotion updated.' });
  } catch (err) {
    console.error('Promotion update error:', err);
    res.status(500).json({ error: 'Server error.' });
  }
});

// DELETE /api/promotions/:id - admin delete
router.delete('/:id', authenticateToken, requireAdmin, async (req, res) => {
  try {
    await pool.query('DELETE FROM promotions WHERE promotion_id = ?', [req.params.id]);
    res.json({ message: 'Promotion deleted.' });
  } catch (err) {
    console.error('Promotion delete error:', err);
    res.status(500).json({ error: 'Server error.' });
  }
});

module.exports = router;
