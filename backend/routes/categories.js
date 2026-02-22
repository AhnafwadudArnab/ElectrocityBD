const express = require('express');
const pool = require('../config/db');
const { authenticateToken, requireAdmin } = require('../middleware/auth');

const router = express.Router();

// GET /api/categories
router.get('/', async (req, res) => {
  try {
    const [rows] = await pool.query(
      `SELECT c.*, COUNT(p.product_id) as product_count
       FROM categories c
       LEFT JOIN products p ON c.category_id = p.category_id
       GROUP BY c.category_id
       ORDER BY c.category_name`
    );
    res.json(rows);
  } catch (err) {
    console.error('Categories error:', err);
    res.status(500).json({ error: 'Server error.' });
  }
});

// GET /api/categories/:id/products
router.get('/:id/products', async (req, res) => {
  try {
    const [rows] = await pool.query(
      `SELECT p.*, b.brand_name, d.discount_percent
       FROM products p
       LEFT JOIN brands b ON p.brand_id = b.brand_id
       LEFT JOIN discounts d ON p.product_id = d.product_id
       WHERE p.category_id = ?
       ORDER BY p.created_at DESC`,
      [req.params.id]
    );
    res.json(rows);
  } catch (err) {
    console.error('Category products error:', err);
    res.status(500).json({ error: 'Server error.' });
  }
});

// POST /api/categories - admin create
router.post('/', authenticateToken, requireAdmin, async (req, res) => {
  try {
    const { category_name, category_image } = req.body;
    const [result] = await pool.query(
      'INSERT INTO categories (category_name, category_image) VALUES (?, ?)',
      [category_name, category_image || '']
    );
    res.status(201).json({ message: 'Category created.', categoryId: result.insertId });
  } catch (err) {
    console.error('Category create error:', err);
    res.status(500).json({ error: 'Server error.' });
  }
});

module.exports = router;
