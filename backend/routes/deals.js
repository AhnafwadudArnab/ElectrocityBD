const express = require('express');
const pool = require('../config/db');
const { authenticateToken, requireAdmin } = require('../middleware/auth');

const router = express.Router();

// GET /api/deals - list all deals (admin) or active only (public)
router.get('/', async (req, res) => {
  try {
    const [rows] = await pool.query(
      `SELECT d.deal_id, d.product_id, d.deal_price, d.start_date, d.end_date,
       p.product_name, p.price as original_price, p.image_url
       FROM deals_of_the_day d
       JOIN products p ON d.product_id = p.product_id
       ORDER BY d.start_date DESC`
    );
    res.json(rows);
  } catch (err) {
    console.error('Deals get error:', err);
    res.status(500).json({ error: 'Server error.' });
  }
});

// POST /api/deals - admin add product to deals
router.post('/', authenticateToken, requireAdmin, async (req, res) => {
  try {
    const { product_id, deal_price, start_date, end_date } = req.body;
    if (!product_id) return res.status(400).json({ error: 'product_id required.' });
    const start = start_date || new Date().toISOString().slice(0, 19).replace('T', ' ');
    const end = end_date || new Date(Date.now() + 24 * 60 * 60 * 1000).toISOString().slice(0, 19).replace('T', ' ');
    const [result] = await pool.query(
      `INSERT INTO deals_of_the_day (product_id, deal_price, start_date, end_date)
       VALUES (?, ?, ?, ?)`,
      [product_id, deal_price != null ? parseFloat(deal_price) : null, start, end]
    );
    res.status(201).json({ message: 'Deal added.', dealId: result.insertId });
  } catch (err) {
    console.error('Deal create error:', err);
    res.status(500).json({ error: 'Server error.' });
  }
});

// PUT /api/deals/:id - admin update deal (timing + price)
router.put('/:id', authenticateToken, requireAdmin, async (req, res) => {
  try {
    const { deal_price, start_date, end_date } = req.body;
    const updates = [];
    const params = [];
    if (deal_price !== undefined) { updates.push(' deal_price = ?'); params.push(parseFloat(deal_price)); }
    if (start_date !== undefined) { updates.push(' start_date = ?'); params.push(start_date); }
    if (end_date !== undefined) { updates.push(' end_date = ?'); params.push(end_date); }
    if (updates.length === 0) return res.status(400).json({ error: 'Provide deal_price, start_date or end_date.' });
    params.push(req.params.id);
    await pool.query(
      `UPDATE deals_of_the_day SET ${updates.join(',')} WHERE deal_id = ?`,
      params
    );
    res.json({ message: 'Deal updated.' });
  } catch (err) {
    console.error('Deal update error:', err);
    res.status(500).json({ error: 'Server error.' });
  }
});

// DELETE /api/deals/:id - admin remove deal
router.delete('/:id', authenticateToken, requireAdmin, async (req, res) => {
  try {
    await pool.query('DELETE FROM deals_of_the_day WHERE deal_id = ?', [req.params.id]);
    res.json({ message: 'Deal removed.' });
  } catch (err) {
    console.error('Deal delete error:', err);
    res.status(500).json({ error: 'Server error.' });
  }
});

module.exports = router;
