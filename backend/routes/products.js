const express = require('express');
const multer = require('multer');
const path = require('path');
const pool = require('../config/db');
const { authenticateToken, requireAdmin } = require('../middleware/auth');

const router = express.Router();

const storage = multer.diskStorage({
  destination: (req, file, cb) => cb(null, path.join(__dirname, '..', 'uploads')),
  filename: (req, file, cb) => cb(null, `${Date.now()}-${file.originalname}`),
});
const upload = multer({ storage, limits: { fileSize: 5 * 1024 * 1024 } });

// GET /api/products - list all with optional filters
router.get('/', async (req, res) => {
  try {
    const { category_id, brand_id, search, min_price, max_price, sort, limit, offset } = req.query;
    let sql = `SELECT p.*, c.category_name, b.brand_name,
               d.discount_percent, d.valid_from, d.valid_to
               FROM products p
               LEFT JOIN categories c ON p.category_id = c.category_id
               LEFT JOIN brands b ON p.brand_id = b.brand_id
               LEFT JOIN discounts d ON p.product_id = d.product_id
               WHERE 1=1`;
    const params = [];

    if (category_id) { sql += ' AND p.category_id = ?'; params.push(category_id); }
    if (brand_id) { sql += ' AND p.brand_id = ?'; params.push(brand_id); }
    if (search) { sql += ' AND (p.product_name LIKE ? OR p.description LIKE ?)'; params.push(`%${search}%`, `%${search}%`); }
    if (min_price) { sql += ' AND p.price >= ?'; params.push(min_price); }
    if (max_price) { sql += ' AND p.price <= ?'; params.push(max_price); }

    if (sort === 'price_asc') sql += ' ORDER BY p.price ASC';
    else if (sort === 'price_desc') sql += ' ORDER BY p.price DESC';
    else if (sort === 'newest') sql += ' ORDER BY p.created_at DESC';
    else sql += ' ORDER BY p.product_id DESC';

    sql += ` LIMIT ${parseInt(limit) || 50} OFFSET ${parseInt(offset) || 0}`;

    const [rows] = await pool.query(sql, params);
    const [countResult] = await pool.query('SELECT COUNT(*) as total FROM products');

    res.json({ products: rows, total: countResult[0].total });
  } catch (err) {
    console.error('Products list error:', err);
    res.status(500).json({ error: 'Server error.' });
  }
});

// GET /api/products/:id
router.get('/:id', async (req, res) => {
  try {
    const [rows] = await pool.query(
      `SELECT p.*, c.category_name, b.brand_name,
       d.discount_percent, d.valid_from, d.valid_to
       FROM products p
       LEFT JOIN categories c ON p.category_id = c.category_id
       LEFT JOIN brands b ON p.brand_id = b.brand_id
       LEFT JOIN discounts d ON p.product_id = d.product_id
       WHERE p.product_id = ?`,
      [req.params.id]
    );
    if (rows.length === 0) return res.status(404).json({ error: 'Product not found.' });
    res.json(rows[0]);
  } catch (err) {
    console.error('Product detail error:', err);
    res.status(500).json({ error: 'Server error.' });
  }
});

// POST /api/products - admin create
router.post('/', authenticateToken, requireAdmin, upload.single('image'), async (req, res) => {
  try {
    const { product_name, description, price, stock_quantity, category_id, brand_id, image_url } = req.body;
    const finalImageUrl = req.file ? `/uploads/${req.file.filename}` : (image_url || '');

    const [result] = await pool.query(
      `INSERT INTO products (product_name, description, price, stock_quantity, category_id, brand_id, image_url)
       VALUES (?, ?, ?, ?, ?, ?, ?)`,
      [product_name, description || '', parseFloat(price) || 0, parseInt(stock_quantity) || 0,
       category_id || null, brand_id || null, finalImageUrl]
    );

    res.status(201).json({ message: 'Product created.', productId: result.insertId });
  } catch (err) {
    console.error('Product create error:', err);
    res.status(500).json({ error: 'Server error.' });
  }
});

// PUT /api/products/:id - admin update
router.put('/:id', authenticateToken, requireAdmin, upload.single('image'), async (req, res) => {
  try {
    const { product_name, description, price, stock_quantity, category_id, brand_id, image_url } = req.body;
    const finalImageUrl = req.file ? `/uploads/${req.file.filename}` : image_url;

    let sql = `UPDATE products SET product_name = COALESCE(?, product_name),
               description = COALESCE(?, description),
               price = COALESCE(?, price),
               stock_quantity = COALESCE(?, stock_quantity),
               category_id = COALESCE(?, category_id),
               brand_id = COALESCE(?, brand_id)`;
    const params = [product_name, description, price ? parseFloat(price) : null,
                    stock_quantity ? parseInt(stock_quantity) : null, category_id, brand_id];

    if (finalImageUrl) {
      sql += ', image_url = ?';
      params.push(finalImageUrl);
    }
    sql += ' WHERE product_id = ?';
    params.push(req.params.id);

    await pool.query(sql, params);
    res.json({ message: 'Product updated.' });
  } catch (err) {
    console.error('Product update error:', err);
    res.status(500).json({ error: 'Server error.' });
  }
});

// DELETE /api/products/:id - admin delete
router.delete('/:id', authenticateToken, requireAdmin, async (req, res) => {
  try {
    await pool.query('DELETE FROM products WHERE product_id = ?', [req.params.id]);
    res.json({ message: 'Product deleted.' });
  } catch (err) {
    console.error('Product delete error:', err);
    res.status(500).json({ error: 'Server error.' });
  }
});

module.exports = router;
