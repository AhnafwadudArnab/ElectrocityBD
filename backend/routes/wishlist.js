const express = require('express');
const pool = require('../config/db');
const { authenticateToken } = require('../middleware/auth');

const router = express.Router();

// GET /api/wishlist
router.get('/', authenticateToken, async (req, res) => {
  try {
    const [rows] = await pool.query(
      `SELECT w.wishlist_id, w.added_at,
       p.product_id, p.product_name, p.price, p.image_url, p.stock_quantity,
       c.category_name, b.brand_name
       FROM wishlists w
       JOIN products p ON w.product_id = p.product_id
       LEFT JOIN categories c ON p.category_id = c.category_id
       LEFT JOIN brands b ON p.brand_id = b.brand_id
       WHERE w.user_id = ?
       ORDER BY w.added_at DESC`,
      [req.user.userId]
    );
    res.json(rows);
  } catch (err) {
    console.error('Wishlist get error:', err);
    res.status(500).json({ error: 'Server error.' });
  }
});

// POST /api/wishlist
router.post('/', authenticateToken, async (req, res) => {
  try {
    const { product_id } = req.body;
    if (!product_id) return res.status(400).json({ error: 'product_id is required.' });

    const [existing] = await pool.query(
      'SELECT wishlist_id FROM wishlists WHERE user_id = ? AND product_id = ?',
      [req.user.userId, product_id]
    );

    if (existing.length > 0) {
      return res.json({ message: 'Already in wishlist.', wishlistId: existing[0].wishlist_id });
    }

    const [result] = await pool.query(
      'INSERT INTO wishlists (user_id, product_id) VALUES (?, ?)',
      [req.user.userId, product_id]
    );
    res.status(201).json({ message: 'Added to wishlist.', wishlistId: result.insertId });
  } catch (err) {
    console.error('Wishlist add error:', err);
    res.status(500).json({ error: 'Server error.' });
  }
});

// DELETE /api/wishlist/:productId
router.delete('/:productId', authenticateToken, async (req, res) => {
  try {
    await pool.query(
      'DELETE FROM wishlists WHERE user_id = ? AND product_id = ?',
      [req.user.userId, req.params.productId]
    );
    res.json({ message: 'Removed from wishlist.' });
  } catch (err) {
    console.error('Wishlist remove error:', err);
    res.status(500).json({ error: 'Server error.' });
  }
});

module.exports = router;
