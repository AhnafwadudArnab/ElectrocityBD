const express = require('express');
const pool = require('../config/db');
const { authenticateToken, requireAdmin } = require('../middleware/auth');

const router = express.Router();

// GET /api/discounts
router.get('/', async (req, res) => {
  try {
    const [rows] = await pool.query(
      `SELECT d.*, p.product_name, p.price, p.image_url
       FROM discounts d
       JOIN products p ON d.product_id = p.product_id
       ORDER BY d.valid_to DESC`
    );
    res.json(rows);
  } catch (err) {
    console.error('Discounts get error:', err);
    res.status(500).json({ error: 'Server error.' });
  }
});

// POST /api/discounts - admin create
router.post('/', authenticateToken, requireAdmin, async (req, res) => {
  try {
    const { product_id, discount_percent, valid_from, valid_to } = req.body;
    const [result] = await pool.query(
      'INSERT INTO discounts (product_id, discount_percent, valid_from, valid_to) VALUES (?, ?, ?, ?)',
      [product_id, discount_percent, valid_from, valid_to]
    );
    res.status(201).json({ message: 'Discount created.', discountId: result.insertId });
  } catch (err) {
    console.error('Discount create error:', err);
    res.status(500).json({ error: 'Server error.' });
  }
});

// PUT /api/discounts/:id - admin update
router.put('/:id', authenticateToken, requireAdmin, async (req, res) => {
  try {
    const { discount_percent, valid_from, valid_to } = req.body;
    await pool.query(
      `UPDATE discounts SET discount_percent = COALESCE(?, discount_percent),
       valid_from = COALESCE(?, valid_from), valid_to = COALESCE(?, valid_to) WHERE discount_id = ?`,
      [discount_percent, valid_from, valid_to, req.params.id]
    );
    res.json({ message: 'Discount updated.' });
  } catch (err) {
    console.error('Discount update error:', err);
    res.status(500).json({ error: 'Server error.' });
  }
});

// DELETE /api/discounts/:id - admin delete
router.delete('/:id', authenticateToken, requireAdmin, async (req, res) => {
  try {
    await pool.query('DELETE FROM discounts WHERE discount_id = ?', [req.params.id]);
    res.json({ message: 'Discount deleted.' });
  } catch (err) {
    console.error('Discount delete error:', err);
    res.status(500).json({ error: 'Server error.' });
  }
});

module.exports = router;
