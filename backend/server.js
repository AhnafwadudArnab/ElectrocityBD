const express = require('express');
const cors = require('cors');
const path = require('path');
const fs = require('fs');
const multer = require('multer');
require('dotenv').config();

const pool = require('./config/db');
const app = express();
const PORT = process.env.PORT || 3000;

app.disable('x-powered-by');
if (process.env.TRUST_PROXY === '1') app.set('trust proxy', 1);

// Ensure uploads directory exists
const uploadsDir = path.join(__dirname, 'uploads');
if (!fs.existsSync(uploadsDir)) {
  fs.mkdirSync(uploadsDir, { recursive: true });
}

app.use(cors());
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true }));
app.use('/uploads', express.static(uploadsDir));

const storage = multer.diskStorage({
  destination: function (_req, _file, cb) {
    cb(null, uploadsDir);
  },
  filename: function (_req, file, cb) {
    const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1e9);
    cb(null, uniqueSuffix + '-' + file.originalname);
  },
});
const upload = multer({ storage });

// POST /upload-image
app.post('/upload-image', upload.single('image'), (req, res) => {
  if (!req.file) {
    return res.status(400).json({ error: 'No file uploaded' });
  }
  const fileUrl = '/uploads/' + req.file.filename;
  res.json({ url: fileUrl });
});

// Routes
app.use('/api/auth', require('./routes/auth'));
app.use('/api/products', require('./routes/products'));
app.use('/api/categories', require('./routes/categories'));
app.use('/api/cart', require('./routes/cart'));
app.use('/api/orders', require('./routes/orders'));
app.use('/api/wishlist', require('./routes/wishlist'));
app.use('/api/discounts', require('./routes/discounts'));
app.use('/api/deals', require('./routes/deals'));
app.use('/api/flash-sales', require('./routes/flash_sales'));
app.use('/api/promotions', require('./routes/promotions'));
app.use('/api/admin', require('./routes/admin'));

// Health check
app.get('/api/health', (_req, res) => {
  res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

// 404 handler
app.use((req, res) => {
  res.status(404).json({ error: `Route ${req.method} ${req.path} not found.` });
});

// Error handler
app.use((err, _req, res, _next) => {
  console.error('Unhandled error:', err);
  res.status(500).json({ error: 'Internal server error.' });
});

pool.getConnection()
  .then((conn) => {
    conn.release();
    console.log('Database connected (electrocity_db)');
    app.listen(PORT, () => {
      console.log(`ElectrocityBD Backend: http://localhost:${PORT}`);
      console.log('Admin login: ahnaf@electrocitybd.com / 1234@ (after npm run db:init)');
    });
  })
  .catch((err) => {
    console.error('Database connection failed:', err.message);
    console.error('Fix: 1) Start MySQL  2) Set DB_PASSWORD in .env if needed  3) Run: npm run db:init');
    process.exit(1);
  });
