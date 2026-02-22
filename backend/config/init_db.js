const mysql = require('mysql2/promise');
require('dotenv').config();

async function initDatabase() {
  const connection = await mysql.createConnection({
    host: process.env.DB_HOST || 'localhost',
    port: parseInt(process.env.DB_PORT || '3306'),
    user: process.env.DB_USER || 'root',
    password: process.env.DB_PASSWORD || '',
    multipleStatements: true,
  });

  const dbName = process.env.DB_NAME || 'electrocity_db';

  console.log(`Creating database "${dbName}" if not exists...`);
  await connection.query(`CREATE DATABASE IF NOT EXISTS \`${dbName}\``);
  await connection.query(`USE \`${dbName}\``);

  const schema = `
    CREATE TABLE IF NOT EXISTS users (
      user_id INT AUTO_INCREMENT PRIMARY KEY,
      full_name VARCHAR(100) NOT NULL,
      last_name VARCHAR(50) NOT NULL DEFAULT '',
      email VARCHAR(100) UNIQUE NOT NULL,
      password VARCHAR(255) NOT NULL,
      phone_number VARCHAR(20),
      address TEXT,
      gender VARCHAR(10) DEFAULT 'Male',
      role ENUM('admin','customer') DEFAULT 'customer',
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );

    CREATE TABLE IF NOT EXISTS user_profile (
      user_id INT PRIMARY KEY,
      full_name VARCHAR(100) NOT NULL,
      last_name VARCHAR(50) NOT NULL DEFAULT '',
      phone_number VARCHAR(20),
      address TEXT,
      gender VARCHAR(10) DEFAULT 'Male',
      updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
      FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
    );

    CREATE TABLE IF NOT EXISTS brands (
      brand_id INT AUTO_INCREMENT PRIMARY KEY,
      brand_name VARCHAR(100) NOT NULL,
      brand_logo VARCHAR(255)
    );

    CREATE TABLE IF NOT EXISTS categories (
      category_id INT AUTO_INCREMENT PRIMARY KEY,
      category_name VARCHAR(50) NOT NULL,
      category_image VARCHAR(255)
    );

    CREATE TABLE IF NOT EXISTS products (
      product_id INT AUTO_INCREMENT PRIMARY KEY,
      category_id INT,
      brand_id INT,
      product_name VARCHAR(150) NOT NULL,
      description TEXT,
      price DECIMAL(10,2) NOT NULL,
      stock_quantity INT DEFAULT 0,
      image_url VARCHAR(255),
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      FOREIGN KEY (category_id) REFERENCES categories(category_id) ON DELETE SET NULL,
      FOREIGN KEY (brand_id) REFERENCES brands(brand_id) ON DELETE SET NULL
    );

    CREATE TABLE IF NOT EXISTS discounts (
      discount_id INT AUTO_INCREMENT PRIMARY KEY,
      product_id INT,
      discount_percent DECIMAL(5,2),
      valid_from DATE,
      valid_to DATE,
      FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
    );

    CREATE TABLE IF NOT EXISTS cart (
      cart_id INT AUTO_INCREMENT PRIMARY KEY,
      user_id INT,
      product_id INT,
      quantity INT DEFAULT 1,
      added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
      FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
    );

    CREATE TABLE IF NOT EXISTS orders (
      order_id INT AUTO_INCREMENT PRIMARY KEY,
      user_id INT,
      total_amount DECIMAL(10,2) NOT NULL,
      order_status ENUM('pending','processing','shipped','delivered','cancelled') DEFAULT 'pending',
      payment_method VARCHAR(50) DEFAULT 'Cash on Delivery',
      payment_status ENUM('unpaid','paid') DEFAULT 'unpaid',
      delivery_address TEXT,
      transaction_id VARCHAR(100),
      estimated_delivery VARCHAR(50),
      order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      FOREIGN KEY (user_id) REFERENCES users(user_id)
    );

    CREATE TABLE IF NOT EXISTS order_items (
      order_item_id INT AUTO_INCREMENT PRIMARY KEY,
      order_id INT,
      product_id INT,
      product_name VARCHAR(150),
      quantity INT NOT NULL,
      price_at_purchase DECIMAL(10,2) NOT NULL,
      color VARCHAR(50) DEFAULT '',
      image_url VARCHAR(255),
      FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
      FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE SET NULL
    );

    CREATE TABLE IF NOT EXISTS wishlists (
      wishlist_id INT AUTO_INCREMENT PRIMARY KEY,
      user_id INT,
      product_id INT,
      added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
      FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
    );

    CREATE TABLE IF NOT EXISTS customer_support (
      ticket_id INT AUTO_INCREMENT PRIMARY KEY,
      user_id INT,
      subject VARCHAR(150) NOT NULL,
      message TEXT NOT NULL,
      status ENUM('open','in_progress','resolved','closed') DEFAULT 'open',
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      resolved_by INT NULL,
      resolved_at TIMESTAMP NULL,
      FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE SET NULL,
      FOREIGN KEY (resolved_by) REFERENCES users(user_id) ON DELETE SET NULL
    );

    CREATE TABLE IF NOT EXISTS promotions (
      promotion_id INT AUTO_INCREMENT PRIMARY KEY,
      title VARCHAR(100) NOT NULL,
      description TEXT,
      discount_percent DECIMAL(5,2),
      start_date DATE,
      end_date DATE,
      active BOOLEAN DEFAULT TRUE
    );

    CREATE TABLE IF NOT EXISTS flash_sales (
      flash_sale_id INT AUTO_INCREMENT PRIMARY KEY,
      title VARCHAR(100),
      start_time DATETIME,
      end_time DATETIME,
      active BOOLEAN DEFAULT TRUE
    );

    CREATE TABLE IF NOT EXISTS flash_sale_products (
      flash_sale_id INT,
      product_id INT,
      PRIMARY KEY (flash_sale_id, product_id),
      FOREIGN KEY (flash_sale_id) REFERENCES flash_sales(flash_sale_id) ON DELETE CASCADE,
      FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
    );

    CREATE TABLE IF NOT EXISTS collections (
      collection_id INT AUTO_INCREMENT PRIMARY KEY,
      name VARCHAR(100) NOT NULL,
      description TEXT,
      image_url VARCHAR(255),
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );

    CREATE TABLE IF NOT EXISTS collection_products (
      collection_id INT,
      product_id INT,
      PRIMARY KEY (collection_id, product_id),
      FOREIGN KEY (collection_id) REFERENCES collections(collection_id) ON DELETE CASCADE,
      FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
    );

    CREATE TABLE IF NOT EXISTS deals_of_the_day (
      deal_id INT AUTO_INCREMENT PRIMARY KEY,
      product_id INT,
      deal_price DECIMAL(10,2),
      start_date DATETIME,
      end_date DATETIME,
      FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
    );

    CREATE TABLE IF NOT EXISTS best_sellers (
      product_id INT PRIMARY KEY,
      sales_count INT DEFAULT 0,
      last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
    );

    CREATE TABLE IF NOT EXISTS trending_products (
      product_id INT PRIMARY KEY,
      trending_score INT DEFAULT 0,
      last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
    );

    CREATE TABLE IF NOT EXISTS tech_part_products (
      product_id INT PRIMARY KEY,
      display_order INT DEFAULT 0,
      added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
    );

    CREATE TABLE IF NOT EXISTS reports (
      report_id INT AUTO_INCREMENT PRIMARY KEY,
      admin_id INT,
      report_type VARCHAR(100),
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      details TEXT,
      FOREIGN KEY (admin_id) REFERENCES users(user_id)
    );
  `;

  const statements = schema.split(';').filter(s => s.trim().length > 0);
  for (const stmt of statements) {
    await connection.query(stmt);
  }
  console.log('All tables created successfully.');

  // Seed admin user (plain password; upsert so password is always correct)
  const adminPassword = '1234@';
  const adminEmail = 'ahnaf@electrocitybd.com';
  await connection.query(
    `INSERT INTO users (full_name, last_name, email, password, phone_number, role)
     VALUES (?, ?, ?, ?, ?, ?)
     ON DUPLICATE KEY UPDATE password = VALUES(password), role = 'admin', full_name = VALUES(full_name), last_name = VALUES(last_name)`,
    ['Ahnaf', 'Admin', adminEmail, adminPassword, '+880 1700-000000', 'admin']
  );
  console.log('Admin user ready: email = ahnaf@electrocitybd.com, password = 1234@');

  // Seed sample categories
  const categories = [
    ['Kitchen Appliances', 'kitchen.png'],
    ['Personal Care & Lifestyle', 'personalcare.png'],
    ['Home Comfort & Utility', 'homecomfort.png'],
    ['Lighting', 'lighting.png'],
    ['Wiring', 'wiring.png'],
    ['Tools', 'tools.png'],
  ];
  for (const [name, img] of categories) {
    await connection.query(
      'INSERT IGNORE INTO categories (category_name, category_image) VALUES (?, ?)',
      [name, img]
    );
  }

  // Seed sample brands
  const brands = [['Philips', 'philips_logo.png'], ['Walton', 'walton_logo.png'], ['Samsung', 'samsung_logo.png']];
  for (const [name, logo] of brands) {
    await connection.query(
      'INSERT IGNORE INTO brands (brand_name, brand_logo) VALUES (?, ?)',
      [name, logo]
    );
  }

  // Seed sample products
  const products = [
    [1, 1, 'LED Bulb', 'Energy saving LED bulb', 150.00, 100, 'led_bulb.png'],
    [1, 1, 'Tube Light', 'Bright tube light', 250.00, 50, 'tube_light.png'],
    [5, 2, 'Copper Wire', 'High quality copper wire', 500.00, 200, 'copper_wire.png'],
    [6, 2, 'Screwdriver Set', 'Multi-purpose screwdriver set', 350.00, 75, 'screwdriver_set.png'],
    [1, 3, 'Smart LED Strip', 'RGB Smart LED Strip 5m', 1200.00, 30, 'led_strip.png'],
    [3, 2, 'Electric Iron', 'Walton Electric Iron', 1500.00, 40, 'electric_iron.png'],
  ];
  for (const p of products) {
    await connection.query(
      `INSERT IGNORE INTO products (category_id, brand_id, product_name, description, price, stock_quantity, image_url)
       VALUES (?, ?, ?, ?, ?, ?, ?)`, p
    );
  }

  // Section tables: so products show on homepage (Best Selling, Trending, Deals, Flash Sale, Tech Part)
  await connection.query('INSERT IGNORE INTO deals_of_the_day (product_id, deal_price, start_date, end_date) VALUES (1, 120, NOW(), DATE_ADD(NOW(), INTERVAL 1 DAY)), (2, 200, NOW(), DATE_ADD(NOW(), INTERVAL 1 DAY))');
  await connection.query('INSERT IGNORE INTO best_sellers (product_id, sales_count) VALUES (1, 50), (2, 30), (3, 20)');
  await connection.query('INSERT IGNORE INTO trending_products (product_id, trending_score) VALUES (1, 80), (2, 70), (3, 60), (4, 50), (5, 40), (6, 30)');
  await connection.query("INSERT IGNORE INTO flash_sales (title, start_time, end_time, active) VALUES ('Flash Sale', NOW(), DATE_ADD(NOW(), INTERVAL 12 HOUR), TRUE)");
  await connection.query('INSERT IGNORE INTO flash_sale_products (flash_sale_id, product_id) VALUES (1, 1), (1, 2)');
  await connection.query('INSERT IGNORE INTO tech_part_products (product_id, display_order) VALUES (1, 0), (4, 1), (5, 2), (6, 3)');

  console.log('Sample data seeded successfully.');
  await connection.end();
  console.log('Database initialization complete!');
}

initDatabase().catch(err => {
  console.error('Database init failed:', err);
  process.exit(1);
});
