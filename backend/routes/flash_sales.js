const express = require('express');
const pool = require('../config/db');
const { authenticateToken, requireAdmin } = require('../middleware/auth');

const router = express.Router();

// GET /api/flash-sales - list all flash sales
router.get('/', async (req, res) => {
  try {
    const [rows] = await pool.query(
      'SELECT * FROM flash_sales ORDER BY start_time DESC'
    );
    res.json(rows);
  } catch (err) {
    console.error('Flash sales get error:', err);
    res.status(500).json({ error: 'Server error.' });
  }
});

// POST /api/flash-sales - admin create
router.post('/', authenticateToken, requireAdmin, async (req, res) => {
  try {
    const { title, start_time, end_time, active } = req.body;
    const start = start_time || new Date().toISOString().slice(0, 19).replace('T', ' ');
    const end = end_time || new Date(Date.now() + 12 * 60 * 60 * 1000).toISOString().slice(0, 19).replace('T', ' ');
    const [result] = await pool.query(
      'INSERT INTO flash_sales (title, start_time, end_time, active) VALUES (?, ?, ?, ?)',
      [title || 'Flash Sale', start, end, active !== false ? 1 : 0]
    );
    res.status(201).json({ message: 'Flash sale created.', flashSaleId: result.insertId });
  } catch (err) {
    console.error('Flash sale create error:', err);
    res.status(500).json({ error: 'Server error.' });
  }
});

// PUT /api/flash-sales/:id - admin update (title, timing, active)
router.put('/:id', authenticateToken, requireAdmin, async (req, res) => {
  try {
    const { title, start_time, end_time, active } = req.body;
    const updates = [];
    const params = [];
    if (title !== undefined) { updates.push(' title = ?'); params.push(title); }
    if (start_time !== undefined) { updates.push(' start_time = ?'); params.push(start_time); }
    if (end_time !== undefined) { updates.push(' end_time = ?'); params.push(end_time); }
    if (active !== undefined) { updates.push(' active = ?'); params.push(active ? 1 : 0); }
    if (updates.length === 0) return res.status(400).json({ error: 'Provide title, start_time, end_time or active.' });
    params.push(req.params.id);
    await pool.query(
      'UPDATE flash_sales SET ' + updates.join(',') + ' WHERE flash_sale_id = ?',
      params
    );
    res.json({ message: 'Flash sale updated.' });
  } catch (err) {
    console.error('Flash sale update error:', err);
    res.status(500).json({ error: 'Server error.' });
  }
});

// DELETE /api/flash-sales/:id - admin delete
router.delete('/:id', authenticateToken, requireAdmin, async (req, res) => {
  try {
    await pool.query('DELETE FROM flash_sale_products WHERE flash_sale_id = ?', [req.params.id]);
    await pool.query('DELETE FROM flash_sales WHERE flash_sale_id = ?', [req.params.id]);
    res.json({ message: 'Flash sale deleted.' });
  } catch (err) {
    console.error('Flash sale delete error:', err);
    res.status(500).json({ error: 'Server error.' });
  }
});

module.exports = router;
