const express = require('express');
const pool = require('../config/db');
const { authenticateToken, requireAdmin } = require('../middleware/auth');

const router = express.Router();

// GET /api/admin/dashboard - dashboard stats
router.get('/dashboard', authenticateToken, requireAdmin, async (req, res) => {
  try {
    const [[{ totalProducts }]] = await pool.query('SELECT COUNT(*) as totalProducts FROM products');
    const [[{ totalOrders }]] = await pool.query('SELECT COUNT(*) as totalOrders FROM orders');
    const [[{ totalCustomers }]] = await pool.query("SELECT COUNT(*) as totalCustomers FROM users WHERE role = 'customer'");
    const [[{ totalRevenue }]] = await pool.query("SELECT COALESCE(SUM(total_amount), 0) as totalRevenue FROM orders WHERE payment_status = 'paid'");
    const [[{ pendingOrders }]] = await pool.query("SELECT COUNT(*) as pendingOrders FROM orders WHERE order_status = 'pending'");
    const [[{ deliveredOrders }]] = await pool.query("SELECT COUNT(*) as deliveredOrders FROM orders WHERE order_status = 'delivered'");

    const [recentOrders] = await pool.query(
      `SELECT o.order_id, o.total_amount, o.order_status, o.order_date, u.email, u.full_name
       FROM orders o JOIN users u ON o.user_id = u.user_id
       ORDER BY o.order_date DESC LIMIT 10`
    );

    const [monthlySales] = await pool.query(
      `SELECT DATE_FORMAT(order_date, '%Y-%m') as month,
       COUNT(*) as order_count, SUM(total_amount) as revenue
       FROM orders WHERE payment_status = 'paid'
       GROUP BY month ORDER BY month DESC LIMIT 12`
    );

    res.json({
      totalProducts,
      totalOrders,
      totalCustomers,
      totalRevenue,
      pendingOrders,
      deliveredOrders,
      recentOrders,
      monthlySales,
    });
  } catch (err) {
    console.error('Dashboard error:', err);
    res.status(500).json({ error: 'Server error.' });
  }
});

// GET /api/admin/customers
router.get('/customers', authenticateToken, requireAdmin, async (req, res) => {
  try {
    const [rows] = await pool.query(
      `SELECT u.user_id, u.full_name, u.last_name, u.email, u.phone_number, u.address,
       u.role, u.created_at,
       COUNT(DISTINCT o.order_id) as order_count,
       COALESCE(SUM(o.total_amount), 0) as total_spent
       FROM users u
       LEFT JOIN orders o ON u.user_id = o.user_id
       WHERE u.role = 'customer'
       GROUP BY u.user_id
       ORDER BY u.created_at DESC`
    );
    res.json(rows);
  } catch (err) {
    console.error('Customers error:', err);
    res.status(500).json({ error: 'Server error.' });
  }
});

// GET /api/admin/reports
router.get('/reports', authenticateToken, requireAdmin, async (req, res) => {
  try {
    const { type, from, to } = req.query;
    let dateFilter = '';
    const params = [];

    if (from && to) {
      dateFilter = ' AND o.order_date BETWEEN ? AND ?';
      params.push(from, to);
    }

    const [salesByCategory] = await pool.query(
      `SELECT c.category_name, COUNT(oi.order_item_id) as items_sold,
       SUM(oi.price_at_purchase * oi.quantity) as revenue
       FROM order_items oi
       JOIN products p ON oi.product_id = p.product_id
       JOIN categories c ON p.category_id = c.category_id
       JOIN orders o ON oi.order_id = o.order_id
       WHERE o.payment_status = 'paid' ${dateFilter}
       GROUP BY c.category_id
       ORDER BY revenue DESC`,
      params
    );

    const [topProducts] = await pool.query(
      `SELECT p.product_name, SUM(oi.quantity) as total_sold,
       SUM(oi.price_at_purchase * oi.quantity) as revenue
       FROM order_items oi
       JOIN products p ON oi.product_id = p.product_id
       JOIN orders o ON oi.order_id = o.order_id
       WHERE o.payment_status = 'paid'
       GROUP BY p.product_id
       ORDER BY total_sold DESC LIMIT 10`
    );

    const [orderStatusBreakdown] = await pool.query(
      `SELECT order_status, COUNT(*) as count FROM orders GROUP BY order_status`
    );

    res.json({ salesByCategory, topProducts, orderStatusBreakdown });
  } catch (err) {
    console.error('Reports error:', err);
    res.status(500).json({ error: 'Server error.' });
  }
});

module.exports = router;
