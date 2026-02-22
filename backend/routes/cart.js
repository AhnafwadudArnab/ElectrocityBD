const express = require('express');
const pool = require('../config/db');
const { authenticateToken, requireAdmin } = require('../middleware/auth');

const router = express.Router();

function imageFullUrl(req, imageUrl) {
  if (!imageUrl || typeof imageUrl !== 'string') return imageUrl || '';
  if (imageUrl.startsWith('asset:')) return imageUrl;
  if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) return imageUrl;
  const base = `${req.protocol}://${req.get('host') || 'localhost:3000'}`;
  return imageUrl.startsWith('/') ? base + imageUrl : base + '/' + imageUrl;
}

// GET /api/cart - get current user's cart (image_url as full URL for Flutter)
router.get('/', authenticateToken, async (req, res) => {
  try {
    const [rows] = await pool.query(
      `SELECT c.cart_id, c.quantity, c.added_at,
       p.product_id, p.product_name, p.price, p.image_url, p.stock_quantity,
       cat.category_name
       FROM cart c
       JOIN products p ON c.product_id = p.product_id
       LEFT JOIN categories cat ON p.category_id = cat.category_id
       WHERE c.user_id = ?
       ORDER BY c.added_at DESC`,
      [req.user.userId]
    );
    const items = rows.map((r) => ({
      ...r,
      image_url: imageFullUrl(req, r.image_url),
    }));
    const total = items.reduce((sum, item) => sum + item.price * item.quantity, 0);
    res.json({ items, total, itemCount: items.reduce((s, i) => s + i.quantity, 0) });
  } catch (err) {
    console.error('Cart get error:', err);
    res.status(500).json({ error: 'Server error.' });
  }
});

// POST /api/cart - add item to cart
router.post('/', authenticateToken, async (req, res) => {
  try {
    const { product_id, quantity } = req.body;
    if (!product_id) return res.status(400).json({ error: 'product_id is required.' });

    const [existing] = await pool.query(
      'SELECT cart_id, quantity FROM cart WHERE user_id = ? AND product_id = ?',
      [req.user.userId, product_id]
    );

    if (existing.length > 0) {
      await pool.query(
        'UPDATE cart SET quantity = quantity + ? WHERE cart_id = ?',
        [quantity || 1, existing[0].cart_id]
      );
    } else {
      await pool.query(
        'INSERT INTO cart (user_id, product_id, quantity) VALUES (?, ?, ?)',
        [req.user.userId, product_id, quantity || 1]
      );
    }

    res.json({ message: 'Item added to cart.' });
  } catch (err) {
    console.error('Cart add error:', err);
    res.status(500).json({ error: 'Server error.' });
  }
});

// PUT /api/cart/:cartId - update quantity
router.put('/:cartId', authenticateToken, async (req, res) => {
  try {
    let quantity = req.body?.quantity;
    if (quantity === undefined || quantity === null) {
      return res.status(400).json({ error: 'quantity is required.' });
    }
    quantity = parseInt(quantity, 10);
    if (isNaN(quantity) || quantity < 0) {
      return res.status(400).json({ error: 'quantity must be a non-negative number.' });
    }
    if (quantity === 0) {
      await pool.query('DELETE FROM cart WHERE cart_id = ? AND user_id = ?',
        [req.params.cartId, req.user.userId]);
    } else {
      await pool.query('UPDATE cart SET quantity = ? WHERE cart_id = ? AND user_id = ?',
        [quantity, req.params.cartId, req.user.userId]);
    }
    res.json({ message: 'Cart updated.' });
  } catch (err) {
    console.error('Cart update error:', err);
    res.status(500).json({ error: 'Server error.' });
  }
});

// DELETE /api/cart/:cartId
router.delete('/:cartId', authenticateToken, async (req, res) => {
  try {
    await pool.query('DELETE FROM cart WHERE cart_id = ? AND user_id = ?',
      [req.params.cartId, req.user.userId]);
    res.json({ message: 'Item removed from cart.' });
  } catch (err) {
    console.error('Cart delete error:', err);
    res.status(500).json({ error: 'Server error.' });
  }
});

// DELETE /api/cart - clear entire cart
router.delete('/', authenticateToken, async (req, res) => {
  try {
    await pool.query('DELETE FROM cart WHERE user_id = ?', [req.user.userId]);
    res.json({ message: 'Cart cleared.' });
  } catch (err) {
    console.error('Cart clear error:', err);
    res.status(500).json({ error: 'Server error.' });
  }
});

// GET /api/cart/admin/all - admin get all carts
router.get('/admin/all', authenticateToken, requireAdmin, async (req, res) => {
  try {
    const [rows] = await pool.query(
      `SELECT c.cart_id, c.quantity, c.added_at,
       u.user_id, u.email, u.full_name,
       p.product_id, p.product_name, p.price, p.image_url
       FROM cart c
       JOIN users u ON c.user_id = u.user_id
       JOIN products p ON c.product_id = p.product_id
       ORDER BY u.user_id, c.added_at DESC`
    );

    const grouped = {};
    for (const row of rows) {
      const key = row.email;
      if (!grouped[key]) {
        grouped[key] = { userId: row.user_id, email: row.email, fullName: row.full_name, items: [] };
      }
      grouped[key].items.push({
        cartId: row.cart_id,
        productId: row.product_id,
        productName: row.product_name,
        price: row.price,
        quantity: row.quantity,
        imageUrl: row.image_url,
        total: row.price * row.quantity,
      });
    }

    res.json(Object.values(grouped));
  } catch (err) {
    console.error('Admin carts error:', err);
    res.status(500).json({ error: 'Server error.' });
  }
});

module.exports = router;
