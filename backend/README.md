# ElectrocityBD Backend

Node.js + Express + MySQL backend for the ElectrocityBD e-commerce app.

## Setup

### 1. Install Dependencies
```bash
cd backend
npm install
```

### 2. Configure Environment
Edit `.env` file with your MySQL credentials:
```
DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASSWORD=your_mysql_password
DB_NAME=electrocity_db
JWT_SECRET=your_secret_key_here
PORT=3000
```

### 3. Initialize Database
```bash
npm run db:init
```
This creates all tables and seeds sample data including an admin user.

### 4. Start Server
```bash
npm run dev    # Development (auto-restart)
npm start      # Production
```

## Default Admin Credentials
- Email: `ahnaf@electrocitybd.com`
- Password: `1234@`

## API Endpoints

| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| POST | /api/auth/register | No | Register new user |
| POST | /api/auth/login | No | User login |
| POST | /api/auth/admin-login | No | Admin login |
| GET | /api/auth/me | Yes | Get profile |
| PUT | /api/auth/me | Yes | Update profile |
| GET | /api/products | No | List products |
| GET | /api/products/:id | No | Product detail |
| POST | /api/products | Admin | Create product |
| PUT | /api/products/:id | Admin | Update product |
| DELETE | /api/products/:id | Admin | Delete product |
| GET | /api/categories | No | List categories |
| POST | /api/categories | Admin | Create category |
| GET | /api/cart | Yes | Get cart |
| POST | /api/cart | Yes | Add to cart |
| PUT | /api/cart/:id | Yes | Update cart item |
| DELETE | /api/cart/:id | Yes | Remove cart item |
| DELETE | /api/cart | Yes | Clear cart |
| GET | /api/cart/admin/all | Admin | All user carts |
| GET | /api/orders | Yes | User orders / Admin all orders |
| POST | /api/orders | Yes | Place order |
| PUT | /api/orders/:id/status | Admin | Update order status |
| GET | /api/wishlist | Yes | Get wishlist |
| POST | /api/wishlist | Yes | Add to wishlist |
| DELETE | /api/wishlist/:id | Yes | Remove from wishlist |
| GET | /api/discounts | No | List discounts |
| POST | /api/discounts | Admin | Create discount |
| GET | /api/admin/dashboard | Admin | Dashboard stats |
| GET | /api/admin/customers | Admin | Customer list |
| GET | /api/admin/reports | Admin | Sales reports |
