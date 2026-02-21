# ElectrocityBD Project

## Overview
ElectrocityBD is a comprehensive application designed for managing an online store. It includes functionalities for both users and administrators, allowing for seamless interactions and management of products, orders, and user accounts.

## Project Structure
```
ElectrocityBD
├── lib
│   ├── main.dart                # Entry point of the application
│   ├── Admin Panel              # Admin functionalities (customers, discounts, orders, products, reports)
│   ├── All Pages                # Various application pages (cart, categories, registrations)
│   ├── Dimensions               # Responsive dimensions for the application
│   ├── pages                    # Main application pages (home, user profiles)
│   ├── utils                    # Utility files (auth sessions, constants, navigation helpers)
│   └── widgets                  # Reusable UI components (app drawers, product cards, headers, footers)
├── db
│   └── schema.sql               # SQL schema for the MySQL database
└── README.md                    # Documentation for the project
```

## Setup Instructions
1. **Clone the repository:**
   ```
   git clone <repository-url>
   cd ElectrocityBD
   ```

2. **Install dependencies:**
   Ensure you have Flutter installed and run:
   ```
   flutter pub get
   ```

3. **Set up the database:**
   - Create a MySQL database named `ElectrocityDB`.
   - Execute the SQL schema found in `db/schema.sql` to set up the necessary tables.

4. **Run the application:**
   ```
   flutter run
   ```

## Usage Guidelines
- The application allows users to register, log in, and manage their profiles.
- Admins can manage products, view reports, and handle orders through the admin panel.
- Users can browse products, add them to their cart, and complete purchases.

## SQL Schema
The SQL schema for the MySQL database is defined in `db/schema.sql` and includes the following tables:
- **users**: Stores user information.
- **products**: Contains product details.
- **orders**: Manages order information.
- **order_items**: Links products to orders.
- **discounts**: Stores discount codes.
- **reports**: Contains various reports for admin review.

This documentation provides a comprehensive overview of the ElectrocityBD project, its structure, setup, and usage.