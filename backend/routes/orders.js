const express = require('express');
const pool = require('../config/db');
const { authenticateToken, requireAdmin } = require('../middleware/auth');

const router = express.Router();

// GET /api/orders - get current user's orders (or all for admin)
router.get('/', authenticateToken, async (req, res) => {
  try {
    let sql, params;
    if (req.user.role === 'admin') {
      sql = `SELECT o.*, u.email, u.full_name
             FROM orders o
             JOIN users u ON o.user_id = u.user_id
             ORDER BY o.order_date DESC`;
      params = [];
    } else {
      sql = `SELECT * FROM orders WHERE user_id = ? ORDER BY order_date DESC`;
      params = [req.user.userId];
    }

    const [orders] = await pool.query(sql, params);

    for (const order of orders) {
      const [items] = await pool.query(
        `SELECT oi.*, p.image_url as product_image
         FROM order_items oi
         LEFT JOIN products p ON oi.product_id = p.product_id
         WHERE oi.order_id = ?`,
        [order.order_id]
      );
      order.items = items;
    }

    res.json(orders);
  } catch (err) {
    console.error('Orders get error:', err);
    res.status(500).json({ error: 'Server error.' });
  }
});

// POST /api/orders - place new order
router.post('/', authenticateToken, async (req, res) => {
  try {
    const { total_amount, payment_method, delivery_address, transaction_id, estimated_delivery, items } = req.body;

    if (!items || items.length === 0) {
      return res.status(400).json({ error: 'Order must have at least one item.' });
    }

    const [orderResult] = await pool.query(
      `INSERT INTO orders (user_id, total_amount, payment_method, delivery_address, transaction_id, estimated_delivery)
       VALUES (?, ?, ?, ?, ?, ?)`,
      [req.user.userId, total_amount, payment_method || 'Cash on Delivery',
       delivery_address || '', transaction_id || '', estimated_delivery || '']
    );

    const orderId = orderResult.insertId;

    for (const item of items) {
      await pool.query(
        `INSERT INTO order_items (order_id, product_id, product_name, quantity, price_at_purchase, color, image_url)
         VALUES (?, ?, ?, ?, ?, ?, ?)`,
        [orderId, item.product_id || null, item.product_name || '', item.quantity,
         item.price, item.color || '', item.image_url || '']
      );

      if (item.product_id) {
        await pool.query(
          'UPDATE products SET stock_quantity = GREATEST(0, stock_quantity - ?) WHERE product_id = ?',
          [item.quantity, item.product_id]
        );
      }
    }

    // Clear user's cart after order
    await pool.query('DELETE FROM cart WHERE user_id = ?', [req.user.userId]);

    res.status(201).json({
      message: 'Order placed successfully.',
      orderId,
      transactionId: transaction_id || `TXN-${orderId}-${Date.now()}`,
    });
  } catch (err) {
    console.error('Order create error:', err);
    res.status(500).json({ error: 'Server error.' });
  }
});

// PUT /api/orders/:id/status - admin update order status
router.put('/:id/status', authenticateToken, requireAdmin, async (req, res) => {
  try {
    const { status, payment_status } = req.body;

    let sql = 'UPDATE orders SET';
    const params = [];
    const updates = [];

    if (status) { updates.push(' order_status = ?'); params.push(status); }
    if (payment_status) { updates.push(' payment_status = ?'); params.push(payment_status); }

    if (updates.length === 0) {
      return res.status(400).json({ error: 'Provide status or payment_status.' });
    }

    sql += updates.join(',') + ' WHERE order_id = ?';
    params.push(req.params.id);

    await pool.query(sql, params);
    res.json({ message: 'Order status updated.' });
  } catch (err) {
    console.error('Order status update error:', err);
    res.status(500).json({ error: 'Server error.' });
  }
});

// GET /api/orders/:id - single order detail
router.get('/:id', authenticateToken, async (req, res) => {
  try {
    const [orders] = await pool.query(
      'SELECT * FROM orders WHERE order_id = ?',
      [req.params.id]
    );
    if (orders.length === 0) return res.status(404).json({ error: 'Order not found.' });

    const order = orders[0];
    if (req.user.role !== 'admin' && order.user_id !== req.user.userId) {
      return res.status(403).json({ error: 'Access denied.' });
    }

    const [items] = await pool.query(
      `SELECT oi.*, p.image_url as product_image
       FROM order_items oi
       LEFT JOIN products p ON oi.product_id = p.product_id
       WHERE oi.order_id = ?`,
      [order.order_id]
    );
    order.items = items;

    res.json(order);
  } catch (err) {
    console.error('Order detail error:', err);
    res.status(500).json({ error: 'Server error.' });
  }
});

module.exports = router;
