# Starting the Backend Server

## Issue Fixed
The database configuration has been corrected. The backend now connects to the correct database: `electrobd`

## Admin Credentials
- Email: `ahnaf@electrocitybd.com`
- Password: `1234@`

## How to Start the Backend Server

### Option 1: Using PHP Built-in Server (Recommended for Development)

Open a terminal in the project root directory and run:

```bash
php -S localhost:8000 -t backend/public backend/router.php
```

This will start the PHP server on `http://localhost:8000`

### Option 2: Using XAMPP/WAMP

1. Copy the `backend` folder to your XAMPP/WAMP `htdocs` directory
2. Access via `http://localhost/backend/public`
3. Update the Flutter app's API URL in `lib/Front-end/utils/constants.dart`

## Verify Backend is Running

Open your browser and go to:
- `http://localhost:8000` - Should show API information
- `http://localhost:8000/api/health` - Should return `{"status":"ok"}`

## Testing Orders

Once the backend is running:

1. Start the Flutter app
2. Login with a user account
3. Add items to cart
4. Place an order
5. Check "My Orders" in the profile page

The orders should now appear in:
- User's "My Orders" page
- Admin panel orders section

## Troubleshooting

### Orders not showing in "My Orders"
1. Make sure the backend server is running
2. Check that you're logged in
3. Verify the API URL in the Flutter app matches your backend URL
4. Check browser console for any API errors

### Database Connection Errors
- Verify MySQL is running
- Check that the database `electrobd` exists
- Verify credentials in `backend/.env` file

### Authentication Errors
- Clear app data/cache
- Login again
- Check that JWT token is being saved properly
