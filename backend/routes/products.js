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

// Helper: prepend base URL to image_url so app can load images
function imageFullUrl(req, imageUrl) {
  if (!imageUrl || typeof imageUrl !== 'string') return imageUrl || '';
  if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) return imageUrl;
  const base = `${req.protocol}://${req.get('host') || 'localhost:3000'}`;
  return imageUrl.startsWith('/') ? base + imageUrl : base + '/' + imageUrl;
}

// GET /api/products - list all with optional filters (section = best_sellers | trending | deals | flash_sale | tech_part)
router.get('/', async (req, res) => {
  try {
    const { category_id, brand_id, search, min_price, max_price, sort, limit, offset, section } = req.query;
    let sql = `SELECT p.*, c.category_name, b.brand_name,
               d.discount_percent, d.valid_from, d.valid_to
               FROM products p
               LEFT JOIN categories c ON p.category_id = c.category_id
               LEFT JOIN brands b ON p.brand_id = b.brand_id
               LEFT JOIN discounts d ON p.product_id = d.product_id`;
    const params = [];

    if (section === 'best_sellers') {
      sql += ' INNER JOIN best_sellers bs ON p.product_id = bs.product_id';
    } else if (section === 'trending') {
      sql += ' INNER JOIN trending_products tp ON p.product_id = tp.product_id';
    } else if (section === 'deals') {
      sql += ' INNER JOIN deals_of_the_day dd ON p.product_id = dd.product_id';
    } else if (section === 'flash_sale') {
      sql += ' INNER JOIN flash_sale_products fsp ON p.product_id = fsp.product_id';
    } else if (section === 'tech_part') {
      sql += ' INNER JOIN tech_part_products tpp ON p.product_id = tpp.product_id';
    }

    sql += ' WHERE 1=1';
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
    let total;
    if (!section) {
      const [countResult] = await pool.query('SELECT COUNT(*) as total FROM products');
      total = countResult[0].total;
    } else {
      let countSql = `SELECT COUNT(p.product_id) as total FROM products p`;
      if (section === 'best_sellers') countSql += ' INNER JOIN best_sellers bs ON p.product_id = bs.product_id';
      else if (section === 'trending') countSql += ' INNER JOIN trending_products tp ON p.product_id = tp.product_id';
      else if (section === 'deals') countSql += ' INNER JOIN deals_of_the_day dd ON p.product_id = dd.product_id';
      else if (section === 'flash_sale') countSql += ' INNER JOIN flash_sale_products fsp ON p.product_id = fsp.product_id';
      else if (section === 'tech_part') countSql += ' INNER JOIN tech_part_products tpp ON p.product_id = tpp.product_id';
      countSql += ' WHERE 1=1';
      if (category_id) countSql += ' AND p.category_id = ?';
      if (brand_id) countSql += ' AND p.brand_id = ?';
      if (search) countSql += ' AND (p.product_name LIKE ? OR p.description LIKE ?)';
      if (min_price) countSql += ' AND p.price >= ?';
      if (max_price) countSql += ' AND p.price <= ?';
      const [countResult] = await pool.query(countSql, params);
      total = countResult[0]?.total ?? 0;
    }

    const products = rows.map((r) => ({
      ...r,
      image_url: imageFullUrl(req, r.image_url),
    }));

    res.json({ products, total });
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
    const row = rows[0];
    res.json({ ...row, image_url: imageFullUrl(req, row.image_url) });
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

// PUT /api/products/:id/sections - admin assign product to homepage sections
router.put('/:id/sections', authenticateToken, requireAdmin, async (req, res) => {
  try {
    const id = parseInt(req.params.id, 10);
    const { best_sellers, trending, deals, flash_sale, tech_part } = req.body || {};

    if (best_sellers) await pool.query('INSERT IGNORE INTO best_sellers (product_id, sales_count) VALUES (?, 0)', [id]);
    else await pool.query('DELETE FROM best_sellers WHERE product_id = ?', [id]);

    if (trending) await pool.query('INSERT IGNORE INTO trending_products (product_id, trending_score) VALUES (?, 0)', [id]);
    else await pool.query('DELETE FROM trending_products WHERE product_id = ?', [id]);

    if (deals) await pool.query('INSERT IGNORE INTO deals_of_the_day (product_id, deal_price, start_date, end_date) SELECT ?, price, NOW(), DATE_ADD(NOW(), INTERVAL 1 DAY) FROM products WHERE product_id = ?', [id, id]);
    else await pool.query('DELETE FROM deals_of_the_day WHERE product_id = ?', [id]);

    const [fs] = await pool.query('SELECT flash_sale_id FROM flash_sales WHERE active = 1 LIMIT 1');
    const fsId = fs && fs[0] ? fs[0].flash_sale_id : 1;
    if (flash_sale) await pool.query('INSERT IGNORE INTO flash_sale_products (flash_sale_id, product_id) VALUES (?, ?)', [fsId, id]);
    else await pool.query('DELETE FROM flash_sale_products WHERE product_id = ?', [id]);

    if (tech_part) await pool.query('INSERT IGNORE INTO tech_part_products (product_id, display_order) VALUES (?, 0)', [id]);
    else await pool.query('DELETE FROM tech_part_products WHERE product_id = ?', [id]);

    res.json({ message: 'Sections updated.' });
  } catch (err) {
    console.error('Product sections error:', err);
    res.status(500).json({ error: 'Server error.' });
  }
});

module.exports = router;
