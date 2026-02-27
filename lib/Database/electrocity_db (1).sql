-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Feb 27, 2026 at 04:45 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";

START TRANSACTION;

SET time_zone = "+00:00";

SET FOREIGN_KEY_CHECKS = 0;

use `if0_41235283_electrocity_bd`;

DROP TABLE IF EXISTS `order_items`;

DROP TABLE IF EXISTS `collection_products`;

DROP TABLE IF EXISTS `flash_sale_products`;

DROP TABLE IF EXISTS `wishlists`;

DROP TABLE IF EXISTS `cart`;

DROP TABLE IF EXISTS `best_sellers`;

DROP TABLE IF EXISTS `tech_part_products`;

DROP TABLE IF EXISTS `trending_products`;

DROP TABLE IF EXISTS `deals_of_the_day`;

DROP TABLE IF EXISTS `discounts`;

DROP TABLE IF EXISTS `customer_support`;

DROP TABLE IF EXISTS `reports`;

DROP TABLE IF EXISTS `orders`;

DROP TABLE IF EXISTS `user_profile`;

DROP TABLE IF EXISTS `products`;

DROP TABLE IF EXISTS `collections`;

DROP TABLE IF EXISTS `flash_sales`;

DROP TABLE IF EXISTS `promotions`;

DROP TABLE IF EXISTS `site_settings`;

DROP TABLE IF EXISTS `categories`;

DROP TABLE IF EXISTS `brands`;

DROP TABLE IF EXISTS `users`;

--
-- Database: `electrocity_db`

-- Table structure for table `best_sellers`
--

CREATE TABLE `best_sellers` (
    `product_id` int(11) NOT NULL,
    `sales_count` int(11) DEFAULT 0,
    `last_updated` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_general_ci;

--
-- Dumping data for table `best_sellers`
--

INSERT INTO
    `best_sellers` (
        `product_id`,
        `sales_count`,
        `last_updated`
    )
VALUES (1, 50, '2026-02-22 11:20:15'),
    (2, 30, '2026-02-22 14:59:17'),
    (3, 20, '2026-02-22 14:59:17'),
    (31, 30, '2026-02-22 15:26:46'),
    (32, 30, '2026-02-22 15:26:46'),
    (33, 30, '2026-02-22 15:26:46'),
    (34, 30, '2026-02-22 15:26:46'),
    (35, 30, '2026-02-22 15:26:46'),
    (36, 30, '2026-02-22 15:26:46'),
    (37, 30, '2026-02-22 15:26:46'),
    (38, 30, '2026-02-22 15:26:46'),
    (39, 30, '2026-02-22 15:26:46'),
    (40, 30, '2026-02-22 15:26:46'),
    (110, 0, '2026-02-24 17:45:21'),
    (240, 1, '2026-02-25 16:12:09'),
    (279, 1, '2026-02-25 17:32:53'),
    (282, 1, '2026-02-26 23:58:56'),
    (283, 1, '2026-02-26 23:59:25');

-- --------------------------------------------------------

--
-- Table structure for table `brands`
--

CREATE TABLE `brands` (
    `brand_id` int(11) NOT NULL,
    `brand_name` varchar(100) NOT NULL,
    `brand_logo` varchar(255) DEFAULT NULL
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_general_ci;

--
-- Dumping data for table `brands`
--

INSERT INTO
    `brands` (
        `brand_id`,
        `brand_name`,
        `brand_logo`
    )
VALUES (
        1,
        'Philips',
        'philips_logo.png'
    ),
    (
        2,
        'Walton',
        'walton_logo.png'
    ),
    (
        3,
        'Samsung',
        'samsung_logo.png'
    ),
    (
        4,
        'Philips',
        'philips_logo.png'
    ),
    (
        5,
        'Walton',
        'walton_logo.png'
    ),
    (
        6,
        'Samsung',
        'samsung_logo.png'
    ),
    (
        7,
        'Philips',
        'philips_logo.png'
    ),
    (
        8,
        'Walton',
        'walton_logo.png'
    ),
    (
        9,
        'Samsung',
        'samsung_logo.png'
    ),
    (
        10,
        'Philips',
        'philips_logo.png'
    ),
    (
        11,
        'Walton',
        'walton_logo.png'
    ),
    (
        12,
        'Samsung',
        'samsung_logo.png'
    ),
    (
        13,
        'Philips',
        'philips_logo.png'
    ),
    (
        14,
        'Walton',
        'walton_logo.png'
    ),
    (
        15,
        'Samsung',
        'samsung_logo.png'
    ),
    (
        16,
        'Philips',
        'philips_logo.png'
    ),
    (
        17,
        'Walton',
        'walton_logo.png'
    ),
    (
        18,
        'Samsung',
        'samsung_logo.png'
    ),
    (
        19,
        'Philips',
        'philips_logo.png'
    ),
    (
        20,
        'Walton',
        'walton_logo.png'
    ),
    (
        21,
        'Samsung',
        'samsung_logo.png'
    ),
    (
        22,
        'Philips',
        'philips_logo.png'
    ),
    (
        23,
        'Walton',
        'walton_logo.png'
    ),
    (
        24,
        'Samsung',
        'samsung_logo.png'
    ),
    (
        25,
        'Philips',
        'philips_logo.png'
    ),
    (
        26,
        'Walton',
        'walton_logo.png'
    ),
    (
        27,
        'Samsung',
        'samsung_logo.png'
    ),
    (
        28,
        'Philips',
        'philips_logo.png'
    ),
    (
        29,
        'Walton',
        'walton_logo.png'
    ),
    (
        30,
        'Samsung',
        'samsung_logo.png'
    ),
    (
        31,
        'Philips',
        'philips_logo.png'
    ),
    (
        32,
        'Walton',
        'walton_logo.png'
    ),
    (
        33,
        'Samsung',
        'samsung_logo.png'
    ),
    (
        34,
        'Philips',
        'philips_logo.png'
    ),
    (
        35,
        'Walton',
        'walton_logo.png'
    ),
    (
        36,
        'Samsung',
        'samsung_logo.png'
    ),
    (
        37,
        'Philips',
        'philips_logo.png'
    ),
    (
        38,
        'Walton',
        'walton_logo.png'
    ),
    (
        39,
        'Samsung',
        'samsung_logo.png'
    ),
    (
        40,
        'Philips',
        'philips_logo.png'
    ),
    (
        41,
        'Walton',
        'walton_logo.png'
    ),
    (
        42,
        'Samsung',
        'samsung_logo.png'
    ),
    (
        43,
        'Philips',
        'philips_logo.png'
    ),
    (
        44,
        'Walton',
        'walton_logo.png'
    ),
    (
        45,
        'Samsung',
        'samsung_logo.png'
    ),
    (
        46,
        'Philips',
        'philips_logo.png'
    ),
    (
        47,
        'Walton',
        'walton_logo.png'
    ),
    (
        48,
        'Samsung',
        'samsung_logo.png'
    ),
    (
        49,
        'Philips',
        'philips_logo.png'
    ),
    (
        50,
        'Walton',
        'walton_logo.png'
    ),
    (
        51,
        'Samsung',
        'samsung_logo.png'
    );

-- --------------------------------------------------------

--
-- Table structure for table `cart`
--

CREATE TABLE `cart` (
    `cart_id` int(11) NOT NULL,
    `user_id` int(11) DEFAULT NULL,
    `product_id` int(11) DEFAULT NULL,
    `quantity` int(11) DEFAULT 1,
    `added_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_general_ci;

--
-- Dumping data for table `cart`
--

INSERT INTO
    `cart` (
        `cart_id`,
        `user_id`,
        `product_id`,
        `quantity`,
        `added_at`
    )
VALUES (
        3,
        1,
        40,
        4,
        '2026-02-22 16:46:23'
    );

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
    `category_id` int(11) NOT NULL,
    `category_name` varchar(50) NOT NULL,
    `category_image` varchar(255) DEFAULT NULL
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_general_ci;

--
-- Dumping data for table `categories`
--

INSERT INTO
    `categories` (
        `category_id`,
        `category_name`,
        `category_image`
    )
VALUES (
        1,
        'Kitchen Appliances',
        'kitchen.png'
    ),
    (
        2,
        'Personal Care & Lifestyle',
        'personalcare.png'
    ),
    (
        3,
        'Home Comfort & Utility',
        'homecomfort.png'
    ),
    (4, 'Lighting', 'lighting.png'),
    (5, 'Wiring', 'wiring.png'),
    (6, 'Tools', 'tools.png'),
    (
        7,
        'Kitchen Appliances',
        'kitchen.png'
    ),
    (
        8,
        'Personal Care & Lifestyle',
        'personalcare.png'
    ),
    (
        9,
        'Home Comfort & Utility',
        'homecomfort.png'
    ),
    (
        10,
        'Lighting',
        'lighting.png'
    ),
    (11, 'Wiring', 'wiring.png'),
    (12, 'Tools', 'tools.png'),
    (
        13,
        'Kitchen Appliances',
        'kitchen.png'
    ),
    (
        14,
        'Personal Care & Lifestyle',
        'personalcare.png'
    ),
    (
        15,
        'Home Comfort & Utility',
        'homecomfort.png'
    ),
    (
        16,
        'Lighting',
        'lighting.png'
    ),
    (17, 'Wiring', 'wiring.png'),
    (18, 'Tools', 'tools.png'),
    (
        19,
        'Kitchen Appliances',
        'kitchen.png'
    ),
    (
        20,
        'Personal Care & Lifestyle',
        'personalcare.png'
    ),
    (
        21,
        'Home Comfort & Utility',
        'homecomfort.png'
    ),
    (
        22,
        'Lighting',
        'lighting.png'
    ),
    (23, 'Wiring', 'wiring.png'),
    (24, 'Tools', 'tools.png'),
    (
        25,
        'Kitchen Appliances',
        'kitchen.png'
    ),
    (
        26,
        'Personal Care & Lifestyle',
        'personalcare.png'
    ),
    (
        27,
        'Home Comfort & Utility',
        'homecomfort.png'
    ),
    (
        28,
        'Lighting',
        'lighting.png'
    ),
    (29, 'Wiring', 'wiring.png'),
    (30, 'Tools', 'tools.png'),
    (
        31,
        'Kitchen Appliances',
        'kitchen.png'
    ),
    (
        32,
        'Personal Care & Lifestyle',
        'personalcare.png'
    ),
    (
        33,
        'Home Comfort & Utility',
        'homecomfort.png'
    ),
    (
        34,
        'Lighting',
        'lighting.png'
    ),
    (35, 'Wiring', 'wiring.png'),
    (36, 'Tools', 'tools.png'),
    (
        37,
        'Kitchen Appliances',
        'kitchen.png'
    ),
    (
        38,
        'Personal Care & Lifestyle',
        'personalcare.png'
    ),
    (
        39,
        'Home Comfort & Utility',
        'homecomfort.png'
    ),
    (
        40,
        'Lighting',
        'lighting.png'
    ),
    (41, 'Wiring', 'wiring.png'),
    (42, 'Tools', 'tools.png'),
    (
        43,
        'Kitchen Appliances',
        'kitchen.png'
    ),
    (
        44,
        'Personal Care & Lifestyle',
        'personalcare.png'
    ),
    (
        45,
        'Home Comfort & Utility',
        'homecomfort.png'
    ),
    (
        46,
        'Lighting',
        'lighting.png'
    ),
    (47, 'Wiring', 'wiring.png'),
    (48, 'Tools', 'tools.png'),
    (
        49,
        'Kitchen Appliances',
        'kitchen.png'
    ),
    (
        50,
        'Personal Care & Lifestyle',
        'personalcare.png'
    ),
    (
        51,
        'Home Comfort & Utility',
        'homecomfort.png'
    ),
    (
        52,
        'Lighting',
        'lighting.png'
    ),
    (53, 'Wiring', 'wiring.png'),
    (54, 'Tools', 'tools.png'),
    (
        55,
        'Kitchen Appliances',
        'kitchen.png'
    ),
    (
        56,
        'Personal Care & Lifestyle',
        'personalcare.png'
    ),
    (
        57,
        'Home Comfort & Utility',
        'homecomfort.png'
    ),
    (
        58,
        'Lighting',
        'lighting.png'
    ),
    (59, 'Wiring', 'wiring.png'),
    (60, 'Tools', 'tools.png'),
    (
        61,
        'Kitchen Appliances',
        'kitchen.png'
    ),
    (
        62,
        'Personal Care & Lifestyle',
        'personalcare.png'
    ),
    (
        63,
        'Home Comfort & Utility',
        'homecomfort.png'
    ),
    (
        64,
        'Lighting',
        'lighting.png'
    ),
    (65, 'Wiring', 'wiring.png'),
    (66, 'Tools', 'tools.png'),
    (
        67,
        'Kitchen Appliances',
        'kitchen.png'
    ),
    (
        68,
        'Personal Care & Lifestyle',
        'personalcare.png'
    ),
    (
        69,
        'Home Comfort & Utility',
        'homecomfort.png'
    ),
    (
        70,
        'Lighting',
        'lighting.png'
    ),
    (71, 'Wiring', 'wiring.png'),
    (72, 'Tools', 'tools.png'),
    (
        73,
        'Kitchen Appliances',
        'kitchen.png'
    ),
    (
        74,
        'Personal Care & Lifestyle',
        'personalcare.png'
    ),
    (
        75,
        'Home Comfort & Utility',
        'homecomfort.png'
    ),
    (
        76,
        'Lighting',
        'lighting.png'
    ),
    (77, 'Wiring', 'wiring.png'),
    (78, 'Tools', 'tools.png'),
    (
        79,
        'Kitchen Appliances',
        'kitchen.png'
    ),
    (
        80,
        'Personal Care & Lifestyle',
        'personalcare.png'
    ),
    (
        81,
        'Home Comfort & Utility',
        'homecomfort.png'
    ),
    (
        82,
        'Lighting',
        'lighting.png'
    ),
    (83, 'Wiring', 'wiring.png'),
    (84, 'Tools', 'tools.png'),
    (
        85,
        'Kitchen Appliances',
        'kitchen.png'
    ),
    (
        86,
        'Personal Care & Lifestyle',
        'personalcare.png'
    ),
    (
        87,
        'Home Comfort & Utility',
        'homecomfort.png'
    ),
    (
        88,
        'Lighting',
        'lighting.png'
    ),
    (89, 'Wiring', 'wiring.png'),
    (90, 'Tools', 'tools.png'),
    (
        91,
        'Kitchen Appliances',
        'kitchen.png'
    ),
    (
        92,
        'Personal Care & Lifestyle',
        'personalcare.png'
    ),
    (
        93,
        'Home Comfort & Utility',
        'homecomfort.png'
    ),
    (
        94,
        'Lighting',
        'lighting.png'
    ),
    (95, 'Wiring', 'wiring.png'),
    (96, 'Tools', 'tools.png'),
    (
        97,
        'Kitchen Appliances',
        'kitchen.png'
    ),
    (
        98,
        'Personal Care & Lifestyle',
        'personalcare.png'
    ),
    (
        99,
        'Home Comfort & Utility',
        'homecomfort.png'
    ),
    (
        100,
        'Lighting',
        'lighting.png'
    ),
    (101, 'Wiring', 'wiring.png'),
    (102, 'Tools', 'tools.png'),
    (
        103,
        'Kitchen Appliances',
        'kitchen.png'
    ),
    (
        104,
        'Personal Care & Lifestyle',
        'personalcare.png'
    ),
    (
        105,
        'Home Comfort & Utility',
        'homecomfort.png'
    ),
    (
        106,
        'Lighting',
        'lighting.png'
    ),
    (107, 'Wiring', 'wiring.png'),
    (108, 'Tools', 'tools.png'),
    (
        109,
        'Kitchen Appliances',
        'kitchen.png'
    ),
    (
        110,
        'Personal Care & Lifestyle',
        'personalcare.png'
    ),
    (
        111,
        'Home Comfort & Utility',
        'homecomfort.png'
    ),
    (
        112,
        'Lighting',
        'lighting.png'
    ),
    (113, 'Wiring', 'wiring.png'),
    (114, 'Tools', 'tools.png'),
    (
        115,
        'Kitchen Appliances',
        'kitchen.png'
    ),
    (
        116,
        'Personal Care & Lifestyle',
        'personalcare.png'
    ),
    (
        117,
        'Home Comfort & Utility',
        'homecomfort.png'
    ),
    (
        118,
        'Lighting',
        'lighting.png'
    ),
    (119, 'Wiring', 'wiring.png'),
    (120, 'Tools', 'tools.png'),
    (
        121,
        'Kitchen Appliances',
        'kitchen.png'
    ),
    (
        122,
        'Personal Care & Lifestyle',
        'personalcare.png'
    ),
    (
        123,
        'Home Comfort & Utility',
        'homecomfort.png'
    ),
    (
        124,
        'Lighting',
        'lighting.png'
    ),
    (125, 'Wiring', 'wiring.png'),
    (126, 'Tools', 'tools.png');

-- --------------------------------------------------------

--
-- Table structure for table `collections`
--

CREATE TABLE `collections` (
    `collection_id` int(11) NOT NULL,
    `name` varchar(100) NOT NULL,
    `description` text DEFAULT NULL,
    `image_url` varchar(255) DEFAULT NULL,
    `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_general_ci;

--
-- Dumping data for table `collections`
--

INSERT INTO
    `collections` (
        `collection_id`,
        `name`,
        `description`,
        `image_url`,
        `created_at`
    )
VALUES (
        1,
        'Home Essentials',
        'Must-have products for every home',
        'home_essentials.png',
        '2026-02-22 11:20:12'
    ),
    (
        2,
        'Home Essentials',
        'Must-have products for every home',
        'home_essentials.png',
        '2026-02-25 00:24:56'
    );

-- --------------------------------------------------------

--
-- Table structure for table `collection_products`
--

CREATE TABLE `collection_products` (
    `collection_id` int(11) NOT NULL,
    `product_id` int(11) NOT NULL
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_general_ci;

--
-- Dumping data for table `collection_products`
--

INSERT INTO
    `collection_products` (`collection_id`, `product_id`)
VALUES (1, 1),
    (1, 4);

-- --------------------------------------------------------

--
-- Table structure for table `customer_support`
--

CREATE TABLE `customer_support` (
    `ticket_id` int(11) NOT NULL,
    `user_id` int(11) DEFAULT NULL,
    `subject` varchar(150) NOT NULL,
    `message` text NOT NULL,
    `status` enum(
        'open',
        'in_progress',
        'resolved',
        'closed'
    ) DEFAULT 'open',
    `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
    `resolved_by` int(11) DEFAULT NULL,
    `resolved_at` timestamp NULL DEFAULT NULL
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `deals_of_the_day`
--

CREATE TABLE `deals_of_the_day` (
    `deal_id` int(11) NOT NULL,
    `product_id` int(11) DEFAULT NULL,
    `deal_price` decimal(10, 2) DEFAULT NULL,
    `start_date` datetime DEFAULT NULL,
    `end_date` datetime DEFAULT NULL
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_general_ci;

--
-- Dumping data for table `deals_of_the_day`
--

INSERT INTO
    `deals_of_the_day` (
        `deal_id`,
        `product_id`,
        `deal_price`,
        `start_date`,
        `end_date`
    )
VALUES (
        1,
        1,
        120.00,
        '2026-02-22 17:20:14',
        '2026-02-23 17:20:14'
    ),
    (
        2,
        1,
        120.00,
        '2026-02-22 20:59:17',
        '2026-02-23 20:59:17'
    ),
    (
        3,
        2,
        200.00,
        '2026-02-22 20:59:17',
        '2026-02-23 20:59:17'
    ),
    (
        4,
        31,
        4950.00,
        '2026-02-22 21:26:47',
        '2026-02-23 21:26:47'
    ),
    (
        5,
        32,
        3780.00,
        '2026-02-22 21:26:47',
        '2026-02-23 21:26:47'
    ),
    (
        6,
        33,
        2880.00,
        '2026-02-22 21:26:47',
        '2026-02-23 21:26:47'
    ),
    (
        7,
        34,
        2250.00,
        '2026-02-22 21:26:47',
        '2026-02-23 21:26:47'
    ),
    (
        8,
        35,
        4050.00,
        '2026-02-22 21:26:47',
        '2026-02-23 21:26:47'
    ),
    (
        11,
        1,
        120.00,
        '2026-02-22 21:27:18',
        '2026-02-23 21:27:18'
    ),
    (
        12,
        2,
        200.00,
        '2026-02-22 21:27:18',
        '2026-02-23 21:27:18'
    ),
    (
        13,
        1,
        120.00,
        '2026-02-22 21:31:49',
        '2026-02-23 21:31:49'
    ),
    (
        14,
        2,
        200.00,
        '2026-02-22 21:31:49',
        '2026-02-23 21:31:49'
    ),
    (
        15,
        1,
        120.00,
        '2026-02-24 20:19:31',
        '2026-02-25 20:19:31'
    ),
    (
        16,
        2,
        200.00,
        '2026-02-24 20:19:31',
        '2026-02-25 20:19:31'
    ),
    (
        17,
        1,
        120.00,
        '2026-02-24 20:19:40',
        '2026-02-25 20:19:40'
    ),
    (
        18,
        2,
        200.00,
        '2026-02-24 20:19:40',
        '2026-02-25 20:19:40'
    ),
    (
        19,
        1,
        120.00,
        '2026-02-24 20:53:47',
        '2026-02-25 20:53:47'
    ),
    (
        20,
        2,
        200.00,
        '2026-02-24 20:53:47',
        '2026-02-25 20:53:47'
    ),
    (
        21,
        1,
        120.00,
        '2026-02-25 00:26:32',
        '2026-02-26 00:26:32'
    ),
    (
        22,
        2,
        200.00,
        '2026-02-25 00:26:32',
        '2026-02-26 00:26:32'
    ),
    (
        23,
        1,
        120.00,
        '2026-02-25 00:55:16',
        '2026-02-26 00:55:16'
    ),
    (
        24,
        2,
        200.00,
        '2026-02-25 00:55:16',
        '2026-02-26 00:55:16'
    ),
    (
        25,
        1,
        120.00,
        '2026-02-25 01:00:35',
        '2026-02-26 01:00:35'
    ),
    (
        26,
        2,
        200.00,
        '2026-02-25 01:00:35',
        '2026-02-26 01:00:35'
    ),
    (
        27,
        1,
        120.00,
        '2026-02-25 01:01:07',
        '2026-02-26 01:01:07'
    ),
    (
        28,
        2,
        200.00,
        '2026-02-25 01:01:07',
        '2026-02-26 01:01:07'
    ),
    (
        29,
        1,
        120.00,
        '2026-02-25 01:02:55',
        '2026-02-26 01:02:55'
    ),
    (
        30,
        2,
        200.00,
        '2026-02-25 01:02:55',
        '2026-02-26 01:02:55'
    ),
    (
        31,
        1,
        120.00,
        '2026-02-25 01:24:27',
        '2026-02-26 01:24:27'
    ),
    (
        32,
        2,
        200.00,
        '2026-02-25 01:24:27',
        '2026-02-26 01:24:27'
    ),
    (
        33,
        1,
        120.00,
        '2026-02-25 02:08:17',
        '2026-02-26 02:08:17'
    ),
    (
        34,
        2,
        200.00,
        '2026-02-25 02:08:17',
        '2026-02-26 02:08:17'
    ),
    (
        35,
        1,
        120.00,
        '2026-02-25 02:09:44',
        '2026-02-26 02:09:44'
    ),
    (
        36,
        2,
        200.00,
        '2026-02-25 02:09:44',
        '2026-02-26 02:09:44'
    ),
    (
        37,
        1,
        120.00,
        '2026-02-25 02:21:04',
        '2026-02-26 02:21:04'
    ),
    (
        38,
        2,
        200.00,
        '2026-02-25 02:21:04',
        '2026-02-26 02:21:04'
    ),
    (
        39,
        1,
        120.00,
        '2026-02-25 02:30:58',
        '2026-02-26 02:30:58'
    ),
    (
        40,
        2,
        200.00,
        '2026-02-25 02:30:58',
        '2026-02-26 02:30:58'
    ),
    (
        41,
        31,
        4950.00,
        '2026-02-25 06:24:46',
        '2026-02-26 06:24:46'
    ),
    (
        42,
        32,
        3780.00,
        '2026-02-25 06:24:46',
        '2026-02-26 06:24:46'
    ),
    (
        43,
        33,
        2880.00,
        '2026-02-25 06:24:46',
        '2026-02-26 06:24:46'
    ),
    (
        44,
        34,
        2250.00,
        '2026-02-25 06:24:46',
        '2026-02-26 06:24:46'
    ),
    (
        45,
        35,
        4050.00,
        '2026-02-25 06:24:46',
        '2026-02-26 06:24:46'
    ),
    (
        48,
        1,
        120.00,
        '2026-02-25 06:24:59',
        '2026-02-26 06:24:59'
    ),
    (
        49,
        2,
        200.00,
        '2026-02-25 06:24:59',
        '2026-02-26 06:24:59'
    );

-- --------------------------------------------------------

--
-- Table structure for table `discounts`
--

CREATE TABLE `discounts` (
    `discount_id` int(11) NOT NULL,
    `product_id` int(11) DEFAULT NULL,
    `discount_percent` decimal(5, 2) DEFAULT NULL,
    `valid_from` date DEFAULT NULL,
    `valid_to` date DEFAULT NULL
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_general_ci;

--
-- Dumping data for table `discounts`
--

INSERT INTO
    `discounts` (
        `discount_id`,
        `product_id`,
        `discount_percent`,
        `valid_from`,
        `valid_to`
    )
VALUES (
        1,
        1,
        15.00,
        '2026-02-10',
        '2026-05-02'
    );

-- --------------------------------------------------------

--
-- Table structure for table `flash_sales`
--

CREATE TABLE `flash_sales` (
    `flash_sale_id` int(11) NOT NULL,
    `title` varchar(100) DEFAULT NULL,
    `start_time` datetime DEFAULT NULL,
    `end_time` datetime DEFAULT NULL,
    `active` tinyint(1) DEFAULT 1
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_general_ci;

--
-- Dumping data for table `flash_sales`
--

INSERT INTO
    `flash_sales` (
        `flash_sale_id`,
        `title`,
        `start_time`,
        `end_time`,
        `active`
    )
VALUES (
        1,
        'Flash Sale',
        '2026-02-22 17:20:09',
        '2026-02-23 05:20:09',
        1
    ),
    (
        2,
        'Flash Sale',
        '2026-02-22 20:59:17',
        '2026-02-23 08:59:17',
        1
    ),
    (
        3,
        'Flash Sale',
        '2026-02-22 21:27:18',
        '2026-02-23 09:27:18',
        1
    ),
    (
        4,
        'Flash Sale',
        '2026-02-22 09:31:49',
        '2026-02-22 21:31:49',
        1
    ),
    (
        5,
        'Flash Sale',
        '2026-02-24 20:19:31',
        '2026-02-25 08:19:31',
        1
    ),
    (
        6,
        'Flash Sale',
        '2026-02-24 20:19:40',
        '2026-02-25 08:19:40',
        1
    ),
    (
        7,
        'Flash Sale',
        '2026-02-24 20:53:47',
        '2026-02-25 08:53:47',
        1
    ),
    (
        8,
        'Flash Sale',
        '2026-02-25 00:26:32',
        '2026-02-25 12:26:32',
        1
    ),
    (
        9,
        'Flash Sale',
        '2026-02-25 00:55:16',
        '2026-02-25 12:55:16',
        1
    ),
    (
        10,
        'Flash Sale',
        '2026-02-25 01:00:35',
        '2026-02-25 13:00:35',
        1
    ),
    (
        11,
        'Flash Sale',
        '2026-02-25 01:01:07',
        '2026-02-25 13:01:07',
        1
    ),
    (
        12,
        'Flash Sale',
        '2026-02-25 01:02:55',
        '2026-02-25 13:02:55',
        1
    ),
    (
        13,
        'Flash Sale',
        '2026-02-25 01:24:27',
        '2026-02-25 13:24:27',
        1
    ),
    (
        14,
        'Flash Sale',
        '2026-02-25 02:08:17',
        '2026-02-25 14:08:17',
        1
    ),
    (
        15,
        'Flash Sale',
        '2026-02-25 02:09:44',
        '2026-02-25 14:09:44',
        1
    ),
    (
        16,
        'Flash Sale',
        '2026-02-25 02:21:04',
        '2026-02-25 14:21:04',
        1
    ),
    (
        17,
        'Flash Sale',
        '2026-02-25 02:30:58',
        '2026-02-25 14:30:58',
        1
    ),
    (
        18,
        'Flash Sale',
        '2026-02-25 06:24:53',
        '2026-02-25 18:24:53',
        1
    );

-- --------------------------------------------------------

--
-- Table structure for table `flash_sale_products`
--

CREATE TABLE `flash_sale_products` (
    `flash_sale_id` int(11) NOT NULL,
    `product_id` int(11) NOT NULL
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_general_ci;

--
-- Dumping data for table `flash_sale_products`
--

INSERT INTO
    `flash_sale_products` (`flash_sale_id`, `product_id`)
VALUES (1, 1),
    (1, 2),
    (1, 31),
    (1, 32),
    (1, 33),
    (1, 34),
    (1, 35),
    (1, 36),
    (1, 37),
    (1, 38);

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
    `order_id` int(11) NOT NULL,
    `user_id` int(11) DEFAULT NULL,
    `total_amount` decimal(10, 2) NOT NULL,
    `order_status` enum(
        'pending',
        'processing',
        'shipped',
        'delivered',
        'cancelled'
    ) DEFAULT 'pending',
    `payment_method` varchar(50) DEFAULT 'Cash on Delivery',
    `payment_status` enum('unpaid', 'paid') DEFAULT 'unpaid',
    `delivery_address` text DEFAULT NULL,
    `transaction_id` varchar(100) DEFAULT NULL,
    `estimated_delivery` varchar(50) DEFAULT NULL,
    `order_date` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_general_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO
    `orders` (
        `order_id`,
        `user_id`,
        `total_amount`,
        `order_status`,
        `payment_method`,
        `payment_status`,
        `delivery_address`,
        `transaction_id`,
        `estimated_delivery`,
        `order_date`
    )
VALUES (
        1,
        3,
        4700.00,
        'delivered',
        'Nagad',
        'unpaid',
        '',
        'NAGAD-1771759740082',
        '27 February 2026',
        '2026-02-22 11:29:00'
    ),
    (
        2,
        3,
        2997.00,
        'cancelled',
        'Nagad',
        'unpaid',
        '',
        'NAGAD-1771759808987',
        '27 February 2026',
        '2026-02-22 11:30:08'
    ),
    (
        3,
        1,
        4800.00,
        'delivered',
        'bKash',
        'unpaid',
        '',
        'BKASH-1771778579209',
        '27 February 2026',
        '2026-02-22 16:42:59'
    ),
    (
        4,
        3,
        3800.00,
        'processing',
        'Nagad',
        'unpaid',
        'badda, dhaka 1212',
        'NAGAD-1771778968236',
        '27 February 2026',
        '2026-02-22 16:49:28'
    );

-- --------------------------------------------------------

--
-- Table structure for table `order_items`
--

CREATE TABLE `order_items` (
    `order_item_id` int(11) NOT NULL,
    `order_id` int(11) DEFAULT NULL,
    `product_id` int(11) DEFAULT NULL,
    `product_name` varchar(150) DEFAULT NULL,
    `quantity` int(11) NOT NULL,
    `price_at_purchase` decimal(10, 2) NOT NULL,
    `color` varchar(50) DEFAULT '',
    `image_url` varchar(255) DEFAULT NULL
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_general_ci;

--
-- Dumping data for table `order_items`
--

INSERT INTO
    `order_items` (
        `order_item_id`,
        `order_id`,
        `product_id`,
        `product_name`,
        `quantity`,
        `price_at_purchase`,
        `color`,
        `image_url`
    )
VALUES (
        1,
        1,
        NULL,
        'Mini hand fan',
        1,
        1200.00,
        '',
        'assets/prod/hFan3.jpg'
    ),
    (
        2,
        1,
        1,
        'Premium Wireless Headphones',
        1,
        3500.00,
        '',
        'https://via.placeholder.com/500x500?text=Headphones+1'
    ),
    (
        3,
        2,
        NULL,
        'Product 1',
        3,
        999.00,
        '',
        'assets/Products/1.png'
    ),
    (
        4,
        3,
        5,
        'Smart LED Strip',
        4,
        1200.00,
        '',
        'http://localhost:3000/led_strip.png'
    ),
    (
        5,
        4,
        40,
        'Curry Cooker',
        1,
        3800.00,
        '',
        'asset:assets/prod/curry_cooker.jpg'
    );

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
    `product_id` int(11) NOT NULL,
    `category_id` int(11) DEFAULT NULL,
    `brand_id` int(11) DEFAULT NULL,
    `product_name` varchar(150) NOT NULL,
    `description` text DEFAULT NULL,
    `price` decimal(10, 2) NOT NULL,
    `stock_quantity` int(11) DEFAULT 0,
    `image_url` varchar(255) DEFAULT NULL,
    `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
    `specs_json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`specs_json`))
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_general_ci;

--
-- Dumping data for table `products`
--

INSERT INTO
    `products` (
        `product_id`,
        `category_id`,
        `brand_id`,
        `product_name`,
        `description`,
        `price`,
        `stock_quantity`,
        `image_url`,
        `created_at`,
        `specs_json`
    )
VALUES (
        1,
        1,
        1,
        'LED Bulb',
        'Energy saving LED bulb',
        150.00,
        99,
        'led_bulb.png',
        '2026-02-22 11:19:43',
        NULL
    ),
    (
        2,
        1,
        1,
        'Tube Light',
        'Bright tube light',
        250.00,
        50,
        'tube_light.png',
        '2026-02-22 11:19:43',
        NULL
    ),
    (
        3,
        5,
        2,
        'Copper Wire',
        'High quality copper wire',
        500.00,
        200,
        'copper_wire.png',
        '2026-02-22 11:19:43',
        NULL
    ),
    (
        4,
        6,
        2,
        'Screwdriver Set',
        'Multi-purpose screwdriver set',
        350.00,
        75,
        'screwdriver_set.png',
        '2026-02-22 11:19:43',
        NULL
    ),
    (
        5,
        1,
        3,
        'Smart LED Strip',
        'RGB Smart LED Strip 5m',
        1200.00,
        26,
        'led_strip.png',
        '2026-02-22 11:19:43',
        NULL
    ),
    (
        6,
        3,
        2,
        'Electric Iron',
        'Walton Electric Iron',
        1500.00,
        40,
        'electric_iron.png',
        '2026-02-22 11:19:43',
        NULL
    ),
    (
        7,
        1,
        1,
        'LED Bulb',
        'Energy saving LED bulb',
        150.00,
        100,
        'led_bulb.png',
        '2026-02-22 11:20:07',
        NULL
    ),
    (
        8,
        1,
        1,
        'Tube Light',
        'Bright tube light',
        250.00,
        50,
        'tube_light.png',
        '2026-02-22 11:20:07',
        NULL
    ),
    (
        9,
        5,
        2,
        'Copper Wire',
        'High quality copper wire',
        500.00,
        200,
        'copper_wire.png',
        '2026-02-22 11:20:07',
        NULL
    ),
    (
        10,
        6,
        2,
        'Screwdriver Set',
        'Multi-purpose screwdriver set',
        350.00,
        75,
        'screwdriver_set.png',
        '2026-02-22 11:20:07',
        NULL
    ),
    (
        11,
        1,
        3,
        'Smart LED Strip',
        'RGB Smart LED Strip 5m',
        1200.00,
        30,
        'led_strip.png',
        '2026-02-22 11:20:07',
        NULL
    ),
    (
        12,
        3,
        2,
        'Electric Iron',
        'Walton Electric Iron',
        1500.00,
        40,
        'electric_iron.png',
        '2026-02-22 11:20:07',
        NULL
    ),
    (
        13,
        1,
        1,
        'LED Bulb',
        'Energy saving LED bulb',
        150.00,
        100,
        'led_bulb.png',
        '2026-02-22 11:20:50',
        NULL
    ),
    (
        14,
        1,
        1,
        'Tube Light',
        'Bright tube light',
        250.00,
        50,
        'tube_light.png',
        '2026-02-22 11:20:50',
        NULL
    ),
    (
        15,
        5,
        2,
        'Copper Wire',
        'High quality copper wire',
        500.00,
        200,
        'copper_wire.png',
        '2026-02-22 11:20:50',
        NULL
    ),
    (
        16,
        6,
        2,
        'Screwdriver Set',
        'Multi-purpose screwdriver set',
        350.00,
        75,
        'screwdriver_set.png',
        '2026-02-22 11:20:50',
        NULL
    ),
    (
        17,
        1,
        3,
        'Smart LED Strip',
        'RGB Smart LED Strip 5m',
        1200.00,
        30,
        'led_strip.png',
        '2026-02-22 11:20:50',
        NULL
    ),
    (
        18,
        3,
        2,
        'Electric Iron',
        'Walton Electric Iron',
        1500.00,
        40,
        'electric_iron.png',
        '2026-02-22 11:20:50',
        NULL
    ),
    (
        19,
        1,
        1,
        'LED Bulb',
        'Energy saving LED bulb',
        150.00,
        100,
        'led_bulb.png',
        '2026-02-22 11:22:48',
        NULL
    ),
    (
        20,
        1,
        1,
        'Tube Light',
        'Bright tube light',
        250.00,
        50,
        'tube_light.png',
        '2026-02-22 11:22:48',
        NULL
    ),
    (
        21,
        5,
        2,
        'Copper Wire',
        'High quality copper wire',
        500.00,
        200,
        'copper_wire.png',
        '2026-02-22 11:22:48',
        NULL
    ),
    (
        22,
        6,
        2,
        'Screwdriver Set',
        'Multi-purpose screwdriver set',
        350.00,
        75,
        'screwdriver_set.png',
        '2026-02-22 11:22:48',
        NULL
    ),
    (
        23,
        1,
        3,
        'Smart LED Strip',
        'RGB Smart LED Strip 5m',
        1200.00,
        30,
        'led_strip.png',
        '2026-02-22 11:22:48',
        NULL
    ),
    (
        24,
        3,
        2,
        'Electric Iron',
        'Walton Electric Iron',
        1500.00,
        40,
        'electric_iron.png',
        '2026-02-22 11:22:48',
        NULL
    ),
    (
        25,
        1,
        1,
        'LED Bulb',
        'Energy saving LED bulb',
        150.00,
        100,
        'led_bulb.png',
        '2026-02-22 14:59:17',
        NULL
    ),
    (
        26,
        1,
        1,
        'Tube Light',
        'Bright tube light',
        250.00,
        50,
        'tube_light.png',
        '2026-02-22 14:59:17',
        NULL
    ),
    (
        27,
        5,
        2,
        'Copper Wire',
        'High quality copper wire',
        500.00,
        200,
        'copper_wire.png',
        '2026-02-22 14:59:17',
        NULL
    ),
    (
        28,
        6,
        2,
        'Screwdriver Set',
        'Multi-purpose screwdriver set',
        350.00,
        75,
        'screwdriver_set.png',
        '2026-02-22 14:59:17',
        NULL
    ),
    (
        29,
        1,
        3,
        'Smart LED Strip',
        'RGB Smart LED Strip 5m',
        1200.00,
        30,
        'led_strip.png',
        '2026-02-22 14:59:17',
        NULL
    ),
    (
        30,
        3,
        2,
        'Electric Iron',
        'Walton Electric Iron',
        1500.00,
        40,
        'electric_iron.png',
        '2026-02-22 14:59:17',
        NULL
    ),
    (
        31,
        1,
        1,
        'Rice Cooker',
        'Auto cook rice cooker',
        5500.00,
        50,
        'asset:assets/prod/rice_cooker.jpg',
        '2026-02-22 15:26:35',
        NULL
    ),
    (
        32,
        1,
        2,
        'Electric Stove',
        'Portable electric stove',
        4200.00,
        40,
        'asset:assets/prod/elec_stove.jpg',
        '2026-02-22 15:26:35',
        NULL
    ),
    (
        33,
        1,
        3,
        'Hand Blender',
        'Corded hand blender',
        3200.00,
        35,
        'asset:assets/prod/hand_blender.jpg',
        '2026-02-22 15:26:35',
        NULL
    ),
    (
        34,
        1,
        1,
        'Chopper',
        'Electric chopper',
        2500.00,
        45,
        'asset:assets/prod/chopper.jpg',
        '2026-02-22 15:26:35',
        NULL
    ),
    (
        35,
        1,
        2,
        'Grinder',
        'Variable speed grinder',
        4500.00,
        30,
        'asset:assets/prod/grinder.jpg',
        '2026-02-22 15:26:35',
        NULL
    ),
    (
        36,
        1,
        3,
        'Blender',
        'Multi-speed blender',
        3800.00,
        40,
        'asset:assets/prod/blender.jpg',
        '2026-02-22 15:26:35',
        NULL
    ),
    (
        37,
        1,
        1,
        'Kettle',
        'Electric kettle',
        2200.00,
        60,
        'asset:assets/prod/catllee.jpg',
        '2026-02-22 15:26:35',
        NULL
    ),
    (
        38,
        1,
        2,
        'Oven',
        'Convection oven',
        15000.00,
        20,
        'asset:assets/prod/oven.jpg',
        '2026-02-22 15:26:35',
        NULL
    ),
    (
        39,
        1,
        3,
        'Air Fryer',
        'Digital air fryer',
        8500.00,
        25,
        'asset:assets/prod/air_fryer.jpg',
        '2026-02-22 15:26:35',
        NULL
    ),
    (
        40,
        1,
        1,
        'Curry Cooker',
        'Non-stick curry cooker',
        3800.00,
        34,
        'asset:assets/prod/curry_cooker.jpg',
        '2026-02-22 15:26:35',
        NULL
    ),
    (
        41,
        1,
        2,
        'Coffee Maker',
        'Auto brew coffee maker',
        6500.00,
        25,
        'asset:assets/prod/catllee.jpg',
        '2026-02-22 15:26:35',
        NULL
    ),
    (
        42,
        1,
        3,
        'Induction Stove',
        'Fast heating induction',
        8500.00,
        20,
        'asset:assets/prod/induction_stove.jpg',
        '2026-02-22 15:26:35',
        NULL
    ),
    (
        43,
        1,
        1,
        'Mini Cooker',
        'Compact mini cooker',
        3500.00,
        40,
        'asset:assets/prod/mini_cooker.jpg',
        '2026-02-22 15:26:35',
        NULL
    ),
    (
        44,
        1,
        2,
        'Mini Cooker Deluxe',
        'Multi-function mini cooker',
        4200.00,
        30,
        'asset:assets/prod/mini2cokker.jpg',
        '2026-02-22 15:26:35',
        NULL
    ),
    (
        45,
        1,
        3,
        'Mini Hand Blender',
        'Lightweight hand blender',
        2500.00,
        50,
        'asset:assets/prod/minihand.jpg',
        '2026-02-22 15:26:35',
        NULL
    ),
    (
        46,
        1,
        1,
        'Rice Cooker Pro',
        'Digital rice cooker',
        7800.00,
        25,
        'asset:assets/prod/riceCooker2.jpg',
        '2026-02-22 15:26:35',
        NULL
    ),
    (
        47,
        1,
        2,
        'Hand Blender Pro',
        'Powerful hand blender',
        7200.00,
        20,
        'asset:assets/prod/hand_blender23.jpg',
        '2026-02-22 15:26:35',
        NULL
    ),
    (
        48,
        2,
        1,
        'Hair Dryer',
        'Multiple heat hair dryer',
        3200.00,
        30,
        'asset:assets/prod/hair_drier.jpg',
        '2026-02-22 15:26:37',
        NULL
    ),
    (
        49,
        2,
        2,
        'Trimmer',
        'Compact electric trimmer',
        2800.00,
        45,
        'asset:assets/prod/trimmer.jpg',
        '2026-02-22 15:26:37',
        NULL
    ),
    (
        50,
        2,
        3,
        'Trimmer Pro',
        'Rechargeable trimmer',
        4500.00,
        25,
        'asset:assets/prod/trimmeer2.jpg',
        '2026-02-22 15:26:37',
        NULL
    ),
    (
        51,
        2,
        1,
        'Head Massager',
        'Vibration head massager',
        3800.00,
        35,
        'asset:assets/prod/head_massager.jpg',
        '2026-02-22 15:26:37',
        NULL
    ),
    (
        52,
        2,
        2,
        'Massage Gun',
        'Portable massage gun',
        6200.00,
        20,
        'asset:assets/prod/massage_gun.jpg',
        '2026-02-22 15:26:37',
        NULL
    ),
    (
        53,
        2,
        3,
        'Hair Styling Tool',
        'Ceramic hair styler',
        3200.00,
        30,
        'asset:assets/prod/tele_sett.jpg',
        '2026-02-22 15:26:37',
        NULL
    ),
    (
        54,
        3,
        1,
        'Iron',
        'Steam electric iron',
        2800.00,
        40,
        'asset:assets/prod/iron.jpg',
        '2026-02-22 15:26:39',
        NULL
    ),
    (
        55,
        3,
        2,
        'Charger Fan',
        'USB charging fan',
        2200.00,
        50,
        'asset:assets/prod/chargerfan.jpg',
        '2026-02-22 15:26:39',
        NULL
    ),
    (
        56,
        3,
        3,
        'Portable Fan',
        'USB powered portable fan',
        4200.00,
        35,
        'asset:assets/prod/hFan3.jpg',
        '2026-02-22 15:26:39',
        NULL
    ),
    (
        57,
        3,
        1,
        'Fan',
        'Variable speed fan',
        13500.00,
        25,
        'asset:assets/prod/fan2.jpg',
        '2026-02-22 15:26:39',
        NULL
    ),
    (
        58,
        6,
        1,
        'Circular Saw',
        'Laser guide circular saw',
        7200.00,
        15,
        'asset:assets/flash/Circular Saw.jpg',
        '2026-02-22 15:26:40',
        NULL
    ),
    (
        59,
        6,
        2,
        'Orbital Sander',
        'LED orbital sander',
        3800.00,
        20,
        'asset:assets/flash/Orbital Sander.jpg',
        '2026-02-22 15:26:40',
        NULL
    ),
    (
        60,
        6,
        3,
        'Rotary Hammer Drill',
        'Heavy-duty hammer drill',
        6500.00,
        18,
        'asset:assets/flash/Rotary Hammer Drill.jpg',
        '2026-02-22 15:26:40',
        NULL
    ),
    (
        61,
        3,
        1,
        'Acer SB220Q Monitor',
        '21.5 Inches Full HD',
        9400.00,
        20,
        'asset:assets/Products/1.png',
        '2026-02-22 15:26:41',
        NULL
    ),
    (
        62,
        3,
        2,
        'Intel Core i7 12th Gen',
        'Desktop processor',
        45999.00,
        10,
        'asset:assets/Products/1.png',
        '2026-02-22 15:26:41',
        NULL
    ),
    (
        63,
        3,
        3,
        'ASUS ROG Strix G15',
        'Gaming laptop',
        120000.00,
        8,
        'asset:assets/Products/2.jpg',
        '2026-02-22 15:26:41',
        NULL
    ),
    (
        64,
        3,
        1,
        'Logitech MX Master 3',
        'Wireless mouse',
        8500.00,
        25,
        'asset:assets/Products/3.jpg',
        '2026-02-22 15:26:41',
        NULL
    ),
    (
        65,
        3,
        2,
        'Samsung T7 Portable SSD',
        '1TB portable SSD',
        12000.00,
        15,
        'asset:assets/Products/4.jpg',
        '2026-02-22 15:26:41',
        NULL
    ),
    (
        66,
        3,
        3,
        'Corsair K95 RGB Keyboard',
        'Mechanical gaming keyboard',
        18000.00,
        12,
        'asset:assets/Products/5.jpg',
        '2026-02-22 15:26:41',
        NULL
    ),
    (
        67,
        3,
        1,
        'Razer DeathAdder V2 Pro',
        'Wireless gaming mouse',
        10500.00,
        18,
        'asset:assets/Products/6.jpg',
        '2026-02-22 15:26:41',
        NULL
    ),
    (
        68,
        3,
        2,
        'Dell UltraSharp U2723QE',
        '27 Inch 4K Monitor',
        35000.00,
        10,
        'asset:assets/Products/7.png',
        '2026-02-22 15:26:41',
        NULL
    ),
    (
        69,
        3,
        2,
        'CCTV Camera',
        'Samsung CCTV camera',
        8500.00,
        20,
        'asset:assets/Deals of the Day/2.png',
        '2026-02-22 15:26:42',
        NULL
    ),
    (
        70,
        1,
        2,
        'Blender 3-in-1 Machine',
        'Walton 3-in-1 blender',
        5500.00,
        30,
        'asset:assets/Deals of the Day/9.png',
        '2026-02-22 15:26:42',
        NULL
    ),
    (
        71,
        1,
        1,
        'Cooker 5L',
        'Panasonic 5L cooker',
        8500.00,
        25,
        'asset:assets/Deals of the Day/3.png',
        '2026-02-22 15:26:42',
        NULL
    ),
    (
        72,
        3,
        1,
        'Fan',
        'Jamuna fan',
        4200.00,
        40,
        'asset:assets/Deals of the Day/5.png',
        '2026-02-22 15:26:42',
        NULL
    ),
    (
        73,
        3,
        2,
        'AC 1.5 Ton',
        'Walton 1.5 ton AC',
        32200.00,
        12,
        'asset:assets/Deals of the Day/6.png',
        '2026-02-22 15:26:42',
        NULL
    ),
    (
        74,
        3,
        2,
        'AC 2 Ton',
        'Walton 2 ton AC',
        46500.00,
        10,
        'asset:assets/Deals of the Day/6.png',
        '2026-02-22 15:26:42',
        NULL
    ),
    (
        75,
        1,
        1,
        'Mixer Grinder',
        'Panasonic mixer grinder',
        2800.00,
        50,
        'asset:assets/Deals of the Day/09.png',
        '2026-02-22 15:26:42',
        NULL
    ),
    (
        76,
        3,
        3,
        'Air Purifier',
        'Hikvision air purifier',
        18500.00,
        15,
        'asset:assets/Deals of the Day/7.png',
        '2026-02-22 15:26:42',
        NULL
    ),
    (
        77,
        3,
        1,
        'Bluetooth Headphones',
        'P9 Max headphones',
        1850.00,
        60,
        'asset:assets/Deals of the Day/1.png',
        '2026-02-22 15:26:42',
        NULL
    ),
    (
        78,
        1,
        1,
        'LED Bulb',
        'Energy saving LED bulb',
        150.00,
        100,
        'led_bulb.png',
        '2026-02-22 15:27:18',
        NULL
    ),
    (
        79,
        1,
        1,
        'Tube Light',
        'Bright tube light',
        250.00,
        50,
        'tube_light.png',
        '2026-02-22 15:27:18',
        NULL
    ),
    (
        80,
        5,
        2,
        'Copper Wire',
        'High quality copper wire',
        500.00,
        200,
        'copper_wire.png',
        '2026-02-22 15:27:18',
        NULL
    ),
    (
        81,
        6,
        2,
        'Screwdriver Set',
        'Multi-purpose screwdriver set',
        350.00,
        75,
        'screwdriver_set.png',
        '2026-02-22 15:27:18',
        NULL
    ),
    (
        82,
        1,
        3,
        'Smart LED Strip',
        'RGB Smart LED Strip 5m',
        1200.00,
        30,
        'led_strip.png',
        '2026-02-22 15:27:18',
        NULL
    ),
    (
        83,
        3,
        2,
        'Electric Iron',
        'Walton Electric Iron',
        1500.00,
        40,
        'electric_iron.png',
        '2026-02-22 15:27:18',
        NULL
    ),
    (
        84,
        1,
        1,
        'LED Bulb',
        'Energy saving LED bulb',
        150.00,
        100,
        'led_bulb.png',
        '2026-02-22 15:31:49',
        NULL
    ),
    (
        85,
        1,
        1,
        'Tube Light',
        'Bright tube light',
        250.00,
        50,
        'tube_light.png',
        '2026-02-22 15:31:49',
        NULL
    ),
    (
        86,
        5,
        2,
        'Copper Wire',
        'High quality copper wire',
        500.00,
        200,
        'copper_wire.png',
        '2026-02-22 15:31:49',
        NULL
    ),
    (
        87,
        6,
        2,
        'Screwdriver Set',
        'Multi-purpose screwdriver set',
        350.00,
        75,
        'screwdriver_set.png',
        '2026-02-22 15:31:49',
        NULL
    ),
    (
        88,
        1,
        3,
        'Smart LED Strip',
        'RGB Smart LED Strip 5m',
        1200.00,
        30,
        'led_strip.png',
        '2026-02-22 15:31:49',
        NULL
    ),
    (
        89,
        3,
        2,
        'Electric Iron',
        'Walton Electric Iron',
        1500.00,
        40,
        'electric_iron.png',
        '2026-02-22 15:31:49',
        NULL
    ),
    (
        90,
        1,
        1,
        'LED Bulb',
        'Energy saving LED bulb',
        150.00,
        100,
        'led_bulb.png',
        '2026-02-24 14:19:31',
        NULL
    ),
    (
        91,
        1,
        1,
        'Tube Light',
        'Bright tube light',
        250.00,
        50,
        'tube_light.png',
        '2026-02-24 14:19:31',
        NULL
    ),
    (
        92,
        5,
        2,
        'Copper Wire',
        'High quality copper wire',
        500.00,
        200,
        'copper_wire.png',
        '2026-02-24 14:19:31',
        NULL
    ),
    (
        93,
        6,
        2,
        'Screwdriver Set',
        'Multi-purpose screwdriver set',
        350.00,
        75,
        'screwdriver_set.png',
        '2026-02-24 14:19:31',
        NULL
    ),
    (
        94,
        1,
        3,
        'Smart LED Strip',
        'RGB Smart LED Strip 5m',
        1200.00,
        30,
        'led_strip.png',
        '2026-02-24 14:19:31',
        NULL
    ),
    (
        95,
        3,
        2,
        'Electric Iron',
        'Walton Electric Iron',
        1500.00,
        40,
        'electric_iron.png',
        '2026-02-24 14:19:31',
        NULL
    ),
    (
        96,
        1,
        1,
        'LED Bulb',
        'Energy saving LED bulb',
        150.00,
        100,
        'led_bulb.png',
        '2026-02-24 14:19:40',
        NULL
    ),
    (
        97,
        1,
        1,
        'Tube Light',
        'Bright tube light',
        250.00,
        50,
        'tube_light.png',
        '2026-02-24 14:19:40',
        NULL
    ),
    (
        98,
        5,
        2,
        'Copper Wire',
        'High quality copper wire',
        500.00,
        200,
        'copper_wire.png',
        '2026-02-24 14:19:40',
        NULL
    ),
    (
        99,
        6,
        2,
        'Screwdriver Set',
        'Multi-purpose screwdriver set',
        350.00,
        75,
        'screwdriver_set.png',
        '2026-02-24 14:19:40',
        NULL
    ),
    (
        100,
        1,
        3,
        'Smart LED Strip',
        'RGB Smart LED Strip 5m',
        1200.00,
        30,
        'led_strip.png',
        '2026-02-24 14:19:40',
        NULL
    ),
    (
        101,
        3,
        2,
        'Electric Iron',
        'Walton Electric Iron',
        1500.00,
        40,
        'electric_iron.png',
        '2026-02-24 14:19:40',
        NULL
    ),
    (
        102,
        1,
        1,
        'CLI Test Product',
        'Uploaded from automated test',
        99.99,
        5,
        '/uploads/1771943118759-ecbd_dummy_1x1.png',
        '2026-02-24 14:25:18',
        NULL
    ),
    (
        103,
        1,
        1,
        'Robust Upload Product',
        'after validations',
        299.50,
        3,
        '/uploads/1771944408728-ecbd_dummy_1x1.png',
        '2026-02-24 14:46:48',
        NULL
    ),
    (
        104,
        1,
        1,
        'LED Bulb',
        'Energy saving LED bulb',
        150.00,
        100,
        'led_bulb.png',
        '2026-02-24 14:53:47',
        NULL
    ),
    (
        105,
        1,
        1,
        'Tube Light',
        'Bright tube light',
        250.00,
        50,
        'tube_light.png',
        '2026-02-24 14:53:47',
        NULL
    ),
    (
        106,
        5,
        2,
        'Copper Wire',
        'High quality copper wire',
        500.00,
        200,
        'copper_wire.png',
        '2026-02-24 14:53:47',
        NULL
    ),
    (
        107,
        6,
        2,
        'Screwdriver Set',
        'Multi-purpose screwdriver set',
        350.00,
        75,
        'screwdriver_set.png',
        '2026-02-24 14:53:47',
        NULL
    ),
    (
        108,
        1,
        3,
        'Smart LED Strip',
        'RGB Smart LED Strip 5m',
        1200.00,
        30,
        'led_strip.png',
        '2026-02-24 14:53:47',
        NULL
    ),
    (
        109,
        3,
        2,
        'Electric Iron',
        'Walton Electric Iron',
        1500.00,
        40,
        'electric_iron.png',
        '2026-02-24 14:53:47',
        NULL
    ),
    (
        110,
        NULL,
        NULL,
        'carrrs',
        'People mover',
        1000000.00,
        0,
        '',
        '2026-02-24 17:45:21',
        NULL
    ),
    (
        111,
        1,
        1,
        'LED Bulb',
        'Energy saving LED bulb',
        150.00,
        100,
        'led_bulb.png',
        '2026-02-24 18:26:32',
        NULL
    ),
    (
        112,
        1,
        1,
        'Tube Light',
        'Bright tube light',
        250.00,
        50,
        'tube_light.png',
        '2026-02-24 18:26:32',
        NULL
    ),
    (
        113,
        5,
        2,
        'Copper Wire',
        'High quality copper wire',
        500.00,
        200,
        'copper_wire.png',
        '2026-02-24 18:26:32',
        NULL
    ),
    (
        114,
        6,
        2,
        'Screwdriver Set',
        'Multi-purpose screwdriver set',
        350.00,
        75,
        'screwdriver_set.png',
        '2026-02-24 18:26:32',
        NULL
    ),
    (
        115,
        1,
        3,
        'Smart LED Strip',
        'RGB Smart LED Strip 5m',
        1200.00,
        30,
        'led_strip.png',
        '2026-02-24 18:26:32',
        NULL
    ),
    (
        116,
        3,
        2,
        'Electric Iron',
        'Walton Electric Iron',
        1500.00,
        40,
        'electric_iron.png',
        '2026-02-24 18:26:32',
        NULL
    ),
    (
        117,
        1,
        1,
        'LED Bulb',
        'Energy saving LED bulb',
        150.00,
        100,
        'led_bulb.png',
        '2026-02-24 18:55:16',
        NULL
    ),
    (
        118,
        1,
        1,
        'Tube Light',
        'Bright tube light',
        250.00,
        50,
        'tube_light.png',
        '2026-02-24 18:55:16',
        NULL
    ),
    (
        119,
        5,
        2,
        'Copper Wire',
        'High quality copper wire',
        500.00,
        200,
        'copper_wire.png',
        '2026-02-24 18:55:16',
        NULL
    ),
    (
        120,
        6,
        2,
        'Screwdriver Set',
        'Multi-purpose screwdriver set',
        350.00,
        75,
        'screwdriver_set.png',
        '2026-02-24 18:55:16',
        NULL
    ),
    (
        121,
        1,
        3,
        'Smart LED Strip',
        'RGB Smart LED Strip 5m',
        1200.00,
        30,
        'led_strip.png',
        '2026-02-24 18:55:16',
        NULL
    ),
    (
        122,
        3,
        2,
        'Electric Iron',
        'Walton Electric Iron',
        1500.00,
        40,
        'electric_iron.png',
        '2026-02-24 18:55:16',
        NULL
    ),
    (
        123,
        1,
        1,
        'LED Bulb',
        'Energy saving LED bulb',
        150.00,
        100,
        'led_bulb.png',
        '2026-02-24 19:00:35',
        NULL
    ),
    (
        124,
        1,
        1,
        'Tube Light',
        'Bright tube light',
        250.00,
        50,
        'tube_light.png',
        '2026-02-24 19:00:35',
        NULL
    ),
    (
        125,
        5,
        2,
        'Copper Wire',
        'High quality copper wire',
        500.00,
        200,
        'copper_wire.png',
        '2026-02-24 19:00:35',
        NULL
    ),
    (
        126,
        6,
        2,
        'Screwdriver Set',
        'Multi-purpose screwdriver set',
        350.00,
        75,
        'screwdriver_set.png',
        '2026-02-24 19:00:35',
        NULL
    ),
    (
        127,
        1,
        3,
        'Smart LED Strip',
        'RGB Smart LED Strip 5m',
        1200.00,
        30,
        'led_strip.png',
        '2026-02-24 19:00:35',
        NULL
    ),
    (
        128,
        3,
        2,
        'Electric Iron',
        'Walton Electric Iron',
        1500.00,
        40,
        'electric_iron.png',
        '2026-02-24 19:00:35',
        NULL
    ),
    (
        129,
        1,
        1,
        'LED Bulb',
        'Energy saving LED bulb',
        150.00,
        100,
        'led_bulb.png',
        '2026-02-24 19:01:07',
        NULL
    ),
    (
        130,
        1,
        1,
        'Tube Light',
        'Bright tube light',
        250.00,
        50,
        'tube_light.png',
        '2026-02-24 19:01:07',
        NULL
    ),
    (
        131,
        5,
        2,
        'Copper Wire',
        'High quality copper wire',
        500.00,
        200,
        'copper_wire.png',
        '2026-02-24 19:01:07',
        NULL
    ),
    (
        132,
        6,
        2,
        'Screwdriver Set',
        'Multi-purpose screwdriver set',
        350.00,
        75,
        'screwdriver_set.png',
        '2026-02-24 19:01:07',
        NULL
    ),
    (
        133,
        1,
        3,
        'Smart LED Strip',
        'RGB Smart LED Strip 5m',
        1200.00,
        30,
        'led_strip.png',
        '2026-02-24 19:01:07',
        NULL
    ),
    (
        134,
        3,
        2,
        'Electric Iron',
        'Walton Electric Iron',
        1500.00,
        40,
        'electric_iron.png',
        '2026-02-24 19:01:07',
        NULL
    ),
    (
        135,
        1,
        1,
        'LED Bulb',
        'Energy saving LED bulb',
        150.00,
        100,
        'led_bulb.png',
        '2026-02-24 19:02:55',
        NULL
    ),
    (
        136,
        1,
        1,
        'Tube Light',
        'Bright tube light',
        250.00,
        50,
        'tube_light.png',
        '2026-02-24 19:02:55',
        NULL
    ),
    (
        137,
        5,
        2,
        'Copper Wire',
        'High quality copper wire',
        500.00,
        200,
        'copper_wire.png',
        '2026-02-24 19:02:55',
        NULL
    ),
    (
        138,
        6,
        2,
        'Screwdriver Set',
        'Multi-purpose screwdriver set',
        350.00,
        75,
        'screwdriver_set.png',
        '2026-02-24 19:02:55',
        NULL
    ),
    (
        139,
        1,
        3,
        'Smart LED Strip',
        'RGB Smart LED Strip 5m',
        1200.00,
        30,
        'led_strip.png',
        '2026-02-24 19:02:55',
        NULL
    ),
    (
        140,
        3,
        2,
        'Electric Iron',
        'Walton Electric Iron',
        1500.00,
        40,
        'electric_iron.png',
        '2026-02-24 19:02:55',
        NULL
    ),
    (
        141,
        1,
        1,
        'LED Bulb',
        'Energy saving LED bulb',
        150.00,
        100,
        'led_bulb.png',
        '2026-02-24 19:24:27',
        NULL
    ),
    (
        142,
        1,
        1,
        'Tube Light',
        'Bright tube light',
        250.00,
        50,
        'tube_light.png',
        '2026-02-24 19:24:27',
        NULL
    ),
    (
        143,
        5,
        2,
        'Copper Wire',
        'High quality copper wire',
        500.00,
        200,
        'copper_wire.png',
        '2026-02-24 19:24:27',
        NULL
    ),
    (
        144,
        6,
        2,
        'Screwdriver Set',
        'Multi-purpose screwdriver set',
        350.00,
        75,
        'screwdriver_set.png',
        '2026-02-24 19:24:27',
        NULL
    ),
    (
        145,
        1,
        3,
        'Smart LED Strip',
        'RGB Smart LED Strip 5m',
        1200.00,
        30,
        'led_strip.png',
        '2026-02-24 19:24:27',
        NULL
    ),
    (
        146,
        3,
        2,
        'Electric Iron',
        'Walton Electric Iron',
        1500.00,
        40,
        'electric_iron.png',
        '2026-02-24 19:24:27',
        NULL
    ),
    (
        147,
        1,
        1,
        'LED Bulb',
        'Energy saving LED bulb',
        150.00,
        100,
        'led_bulb.png',
        '2026-02-24 20:08:17',
        NULL
    ),
    (
        148,
        1,
        1,
        'Tube Light',
        'Bright tube light',
        250.00,
        50,
        'tube_light.png',
        '2026-02-24 20:08:17',
        NULL
    ),
    (
        149,
        5,
        2,
        'Copper Wire',
        'High quality copper wire',
        500.00,
        200,
        'copper_wire.png',
        '2026-02-24 20:08:17',
        NULL
    ),
    (
        150,
        6,
        2,
        'Screwdriver Set',
        'Multi-purpose screwdriver set',
        350.00,
        75,
        'screwdriver_set.png',
        '2026-02-24 20:08:17',
        NULL
    ),
    (
        151,
        1,
        3,
        'Smart LED Strip',
        'RGB Smart LED Strip 5m',
        1200.00,
        30,
        'led_strip.png',
        '2026-02-24 20:08:17',
        NULL
    ),
    (
        152,
        3,
        2,
        'Electric Iron',
        'Walton Electric Iron',
        1500.00,
        40,
        'electric_iron.png',
        '2026-02-24 20:08:17',
        NULL
    ),
    (
        153,
        1,
        1,
        'LED Bulb',
        'Energy saving LED bulb',
        150.00,
        100,
        'led_bulb.png',
        '2026-02-24 20:09:44',
        NULL
    ),
    (
        154,
        1,
        1,
        'Tube Light',
        'Bright tube light',
        250.00,
        50,
        'tube_light.png',
        '2026-02-24 20:09:44',
        NULL
    ),
    (
        155,
        5,
        2,
        'Copper Wire',
        'High quality copper wire',
        500.00,
        200,
        'copper_wire.png',
        '2026-02-24 20:09:44',
        NULL
    ),
    (
        156,
        6,
        2,
        'Screwdriver Set',
        'Multi-purpose screwdriver set',
        350.00,
        75,
        'screwdriver_set.png',
        '2026-02-24 20:09:44',
        NULL
    ),
    (
        157,
        1,
        3,
        'Smart LED Strip',
        'RGB Smart LED Strip 5m',
        1200.00,
        30,
        'led_strip.png',
        '2026-02-24 20:09:44',
        NULL
    ),
    (
        158,
        3,
        2,
        'Electric Iron',
        'Walton Electric Iron',
        1500.00,
        40,
        'electric_iron.png',
        '2026-02-24 20:09:44',
        NULL
    ),
    (
        159,
        1,
        1,
        'LED Bulb',
        'Energy saving LED bulb',
        150.00,
        100,
        'led_bulb.png',
        '2026-02-24 20:21:04',
        NULL
    ),
    (
        160,
        1,
        1,
        'Tube Light',
        'Bright tube light',
        250.00,
        50,
        'tube_light.png',
        '2026-02-24 20:21:04',
        NULL
    ),
    (
        161,
        5,
        2,
        'Copper Wire',
        'High quality copper wire',
        500.00,
        200,
        'copper_wire.png',
        '2026-02-24 20:21:04',
        NULL
    ),
    (
        162,
        6,
        2,
        'Screwdriver Set',
        'Multi-purpose screwdriver set',
        350.00,
        75,
        'screwdriver_set.png',
        '2026-02-24 20:21:04',
        NULL
    ),
    (
        163,
        1,
        3,
        'Smart LED Strip',
        'RGB Smart LED Strip 5m',
        1200.00,
        30,
        'led_strip.png',
        '2026-02-24 20:21:04',
        NULL
    ),
    (
        164,
        3,
        2,
        'Electric Iron',
        'Walton Electric Iron',
        1500.00,
        40,
        'electric_iron.png',
        '2026-02-24 20:21:04',
        NULL
    ),
    (
        165,
        1,
        1,
        'LED Bulb',
        'Energy saving LED bulb',
        150.00,
        100,
        'led_bulb.png',
        '2026-02-24 20:30:58',
        NULL
    ),
    (
        166,
        1,
        1,
        'Tube Light',
        'Bright tube light',
        250.00,
        50,
        'tube_light.png',
        '2026-02-24 20:30:58',
        NULL
    ),
    (
        167,
        5,
        2,
        'Copper Wire',
        'High quality copper wire',
        500.00,
        200,
        'copper_wire.png',
        '2026-02-24 20:30:58',
        NULL
    ),
    (
        168,
        6,
        2,
        'Screwdriver Set',
        'Multi-purpose screwdriver set',
        350.00,
        75,
        'screwdriver_set.png',
        '2026-02-24 20:30:58',
        NULL
    ),
    (
        169,
        1,
        3,
        'Smart LED Strip',
        'RGB Smart LED Strip 5m',
        1200.00,
        30,
        'led_strip.png',
        '2026-02-24 20:30:58',
        NULL
    ),
    (
        170,
        3,
        2,
        'Electric Iron',
        'Walton Electric Iron',
        1500.00,
        40,
        'electric_iron.png',
        '2026-02-24 20:30:58',
        NULL
    ),
    (
        171,
        1,
        1,
        'LED Bulb',
        'Energy saving LED bulb',
        150.00,
        100,
        'led_bulb.png',
        '2026-02-25 00:24:25',
        NULL
    ),
    (
        172,
        1,
        1,
        'Tube Light',
        'Bright tube light',
        250.00,
        50,
        'tube_light.png',
        '2026-02-25 00:24:25',
        NULL
    ),
    (
        173,
        5,
        2,
        'Copper Wire',
        'High quality copper wire',
        500.00,
        200,
        'copper_wire.png',
        '2026-02-25 00:24:25',
        NULL
    ),
    (
        174,
        6,
        2,
        'Screwdriver Set',
        'Multi-purpose screwdriver set',
        350.00,
        75,
        'screwdriver_set.png',
        '2026-02-25 00:24:25',
        NULL
    ),
    (
        175,
        1,
        3,
        'Smart LED Strip',
        'RGB Smart LED Strip 5m',
        1200.00,
        30,
        'led_strip.png',
        '2026-02-25 00:24:25',
        NULL
    ),
    (
        176,
        3,
        2,
        'Electric Iron',
        'Walton Electric Iron',
        1500.00,
        40,
        'electric_iron.png',
        '2026-02-25 00:24:25',
        NULL
    ),
    (
        177,
        1,
        1,
        'Rice Cooker',
        'Auto cook rice cooker',
        5500.00,
        50,
        'asset:assets/prod/rice_cooker.jpg',
        '2026-02-25 00:24:33',
        NULL
    ),
    (
        178,
        1,
        2,
        'Electric Stove',
        'Portable electric stove',
        4200.00,
        40,
        'asset:assets/prod/elec_stove.jpg',
        '2026-02-25 00:24:33',
        NULL
    ),
    (
        179,
        1,
        3,
        'Hand Blender',
        'Corded hand blender',
        3200.00,
        35,
        'asset:assets/prod/hand_blender.jpg',
        '2026-02-25 00:24:33',
        NULL
    ),
    (
        180,
        1,
        1,
        'Chopper',
        'Electric chopper',
        2500.00,
        45,
        'asset:assets/prod/chopper.jpg',
        '2026-02-25 00:24:33',
        NULL
    ),
    (
        181,
        1,
        2,
        'Grinder',
        'Variable speed grinder',
        4500.00,
        30,
        'asset:assets/prod/grinder.jpg',
        '2026-02-25 00:24:33',
        NULL
    ),
    (
        182,
        1,
        3,
        'Blender',
        'Multi-speed blender',
        3800.00,
        40,
        'asset:assets/prod/blender.jpg',
        '2026-02-25 00:24:33',
        NULL
    ),
    (
        183,
        1,
        1,
        'Kettle',
        'Electric kettle',
        2200.00,
        60,
        'asset:assets/prod/catllee.jpg',
        '2026-02-25 00:24:33',
        NULL
    ),
    (
        184,
        1,
        2,
        'Oven',
        'Convection oven',
        15000.00,
        20,
        'asset:assets/prod/oven.jpg',
        '2026-02-25 00:24:33',
        NULL
    ),
    (
        185,
        1,
        3,
        'Air Fryer',
        'Digital air fryer',
        8500.00,
        25,
        'asset:assets/prod/air_fryer.jpg',
        '2026-02-25 00:24:33',
        NULL
    ),
    (
        186,
        1,
        1,
        'Curry Cooker',
        'Non-stick curry cooker',
        3800.00,
        35,
        'asset:assets/prod/curry_cooker.jpg',
        '2026-02-25 00:24:33',
        NULL
    ),
    (
        187,
        1,
        2,
        'Coffee Maker',
        'Auto brew coffee maker',
        6500.00,
        25,
        'asset:assets/prod/catllee.jpg',
        '2026-02-25 00:24:33',
        NULL
    ),
    (
        188,
        1,
        3,
        'Induction Stove',
        'Fast heating induction',
        8500.00,
        20,
        'asset:assets/prod/induction_stove.jpg',
        '2026-02-25 00:24:33',
        NULL
    ),
    (
        189,
        1,
        1,
        'Mini Cooker',
        'Compact mini cooker',
        3500.00,
        40,
        'asset:assets/prod/mini_cooker.jpg',
        '2026-02-25 00:24:33',
        NULL
    ),
    (
        190,
        1,
        2,
        'Mini Cooker Deluxe',
        'Multi-function mini cooker',
        4200.00,
        30,
        'asset:assets/prod/mini2cokker.jpg',
        '2026-02-25 00:24:33',
        NULL
    ),
    (
        191,
        1,
        3,
        'Mini Hand Blender',
        'Lightweight hand blender',
        2500.00,
        50,
        'asset:assets/prod/minihand.jpg',
        '2026-02-25 00:24:33',
        NULL
    ),
    (
        192,
        1,
        1,
        'Rice Cooker Pro',
        'Digital rice cooker',
        7800.00,
        25,
        'asset:assets/prod/riceCooker2.jpg',
        '2026-02-25 00:24:33',
        NULL
    ),
    (
        193,
        1,
        2,
        'Hand Blender Pro',
        'Powerful hand blender',
        7200.00,
        20,
        'asset:assets/prod/hand_blender23.jpg',
        '2026-02-25 00:24:33',
        NULL
    ),
    (
        194,
        2,
        1,
        'Hair Dryer',
        'Multiple heat hair dryer',
        3200.00,
        30,
        'asset:assets/prod/hair_drier.jpg',
        '2026-02-25 00:24:35',
        NULL
    ),
    (
        195,
        2,
        2,
        'Trimmer',
        'Compact electric trimmer',
        2800.00,
        45,
        'asset:assets/prod/trimmer.jpg',
        '2026-02-25 00:24:35',
        NULL
    ),
    (
        196,
        2,
        3,
        'Trimmer Pro',
        'Rechargeable trimmer',
        4500.00,
        25,
        'asset:assets/prod/trimmeer2.jpg',
        '2026-02-25 00:24:35',
        NULL
    ),
    (
        197,
        2,
        1,
        'Head Massager',
        'Vibration head massager',
        3800.00,
        35,
        'asset:assets/prod/head_massager.jpg',
        '2026-02-25 00:24:35',
        NULL
    ),
    (
        198,
        2,
        2,
        'Massage Gun',
        'Portable massage gun',
        6200.00,
        20,
        'asset:assets/prod/massage_gun.jpg',
        '2026-02-25 00:24:35',
        NULL
    ),
    (
        199,
        2,
        3,
        'Hair Styling Tool',
        'Ceramic hair styler',
        3200.00,
        30,
        'asset:assets/prod/tele_sett.jpg',
        '2026-02-25 00:24:35',
        NULL
    ),
    (
        200,
        3,
        1,
        'Iron',
        'Steam electric iron',
        2800.00,
        40,
        'asset:assets/prod/iron.jpg',
        '2026-02-25 00:24:37',
        NULL
    ),
    (
        201,
        3,
        2,
        'Charger Fan',
        'USB charging fan',
        2200.00,
        50,
        'asset:assets/prod/chargerfan.jpg',
        '2026-02-25 00:24:37',
        NULL
    ),
    (
        202,
        3,
        3,
        'Portable Fan',
        'USB powered portable fan',
        4200.00,
        35,
        'asset:assets/prod/hFan3.jpg',
        '2026-02-25 00:24:37',
        NULL
    ),
    (
        203,
        3,
        1,
        'Fan',
        'Variable speed fan',
        13500.00,
        25,
        'asset:assets/prod/fan2.jpg',
        '2026-02-25 00:24:37',
        NULL
    ),
    (
        204,
        6,
        1,
        'Circular Saw',
        'Laser guide circular saw',
        7200.00,
        15,
        'asset:assets/flash/Circular Saw.jpg',
        '2026-02-25 00:24:39',
        NULL
    ),
    (
        205,
        6,
        2,
        'Orbital Sander',
        'LED orbital sander',
        3800.00,
        20,
        'asset:assets/flash/Orbital Sander.jpg',
        '2026-02-25 00:24:39',
        NULL
    ),
    (
        206,
        6,
        3,
        'Rotary Hammer Drill',
        'Heavy-duty hammer drill',
        6500.00,
        18,
        'asset:assets/flash/Rotary Hammer Drill.jpg',
        '2026-02-25 00:24:39',
        NULL
    ),
    (
        207,
        3,
        1,
        'Acer SB220Q Monitor',
        '21.5 Inches Full HD',
        9400.00,
        20,
        'asset:assets/Products/1.png',
        '2026-02-25 00:24:41',
        NULL
    ),
    (
        208,
        3,
        2,
        'Intel Core i7 12th Gen',
        'Desktop processor',
        45999.00,
        10,
        'asset:assets/Products/1.png',
        '2026-02-25 00:24:41',
        NULL
    ),
    (
        209,
        3,
        3,
        'ASUS ROG Strix G15',
        'Gaming laptop',
        120000.00,
        8,
        'asset:assets/Products/2.jpg',
        '2026-02-25 00:24:41',
        NULL
    ),
    (
        210,
        3,
        1,
        'Logitech MX Master 3',
        'Wireless mouse',
        8500.00,
        25,
        'asset:assets/Products/3.jpg',
        '2026-02-25 00:24:41',
        NULL
    ),
    (
        211,
        3,
        2,
        'Samsung T7 Portable SSD',
        '1TB portable SSD',
        12000.00,
        15,
        'asset:assets/Products/4.jpg',
        '2026-02-25 00:24:41',
        NULL
    ),
    (
        212,
        3,
        3,
        'Corsair K95 RGB Keyboard',
        'Mechanical gaming keyboard',
        18000.00,
        12,
        'asset:assets/Products/5.jpg',
        '2026-02-25 00:24:41',
        NULL
    ),
    (
        213,
        3,
        1,
        'Razer DeathAdder V2 Pro',
        'Wireless gaming mouse',
        10500.00,
        18,
        'asset:assets/Products/6.jpg',
        '2026-02-25 00:24:41',
        NULL
    ),
    (
        214,
        3,
        2,
        'Dell UltraSharp U2723QE',
        '27 Inch 4K Monitor',
        35000.00,
        10,
        'asset:assets/Products/7.png',
        '2026-02-25 00:24:41',
        NULL
    ),
    (
        215,
        3,
        2,
        'CCTV Camera',
        'Samsung CCTV camera',
        8500.00,
        20,
        'asset:assets/Deals of the Day/2.png',
        '2026-02-25 00:24:42',
        NULL
    ),
    (
        216,
        1,
        2,
        'Blender 3-in-1 Machine',
        'Walton 3-in-1 blender',
        5500.00,
        30,
        'asset:assets/Deals of the Day/9.png',
        '2026-02-25 00:24:42',
        NULL
    ),
    (
        217,
        1,
        1,
        'Cooker 5L',
        'Panasonic 5L cooker',
        8500.00,
        25,
        'asset:assets/Deals of the Day/3.png',
        '2026-02-25 00:24:42',
        NULL
    ),
    (
        218,
        3,
        1,
        'Fan',
        'Jamuna fan',
        4200.00,
        40,
        'asset:assets/Deals of the Day/5.png',
        '2026-02-25 00:24:42',
        NULL
    ),
    (
        219,
        3,
        2,
        'AC 1.5 Ton',
        'Walton 1.5 ton AC',
        32200.00,
        12,
        'asset:assets/Deals of the Day/6.png',
        '2026-02-25 00:24:42',
        NULL
    ),
    (
        220,
        3,
        2,
        'AC 2 Ton',
        'Walton 2 ton AC',
        46500.00,
        10,
        'asset:assets/Deals of the Day/6.png',
        '2026-02-25 00:24:42',
        NULL
    ),
    (
        221,
        1,
        1,
        'Mixer Grinder',
        'Panasonic mixer grinder',
        2800.00,
        50,
        'asset:assets/Deals of the Day/09.png',
        '2026-02-25 00:24:42',
        NULL
    ),
    (
        222,
        3,
        3,
        'Air Purifier',
        'Hikvision air purifier',
        18500.00,
        15,
        'asset:assets/Deals of the Day/7.png',
        '2026-02-25 00:24:42',
        NULL
    ),
    (
        223,
        3,
        1,
        'Bluetooth Headphones',
        'P9 Max headphones',
        1850.00,
        60,
        'asset:assets/Deals of the Day/1.png',
        '2026-02-25 00:24:42',
        NULL
    ),
    (
        224,
        NULL,
        NULL,
        'roz',
        'hhhd hdddj ddsjs dsmsms sdsds',
        2000.00,
        0,
        '/uploads/img_699f0e3e08cc53.51725000.png',
        '2026-02-25 14:59:10',
        NULL
    ),
    (
        225,
        NULL,
        NULL,
        'roz',
        'hhhd hdddj ddsjs dsmsms sdsds',
        2000.00,
        0,
        '/uploads/img_699f0e3e660b56.67341937.png',
        '2026-02-25 14:59:10',
        NULL
    ),
    (
        226,
        NULL,
        NULL,
        'wad',
        'fidhjgfndgj fgjhfdjgg  dfuh gjddf vdfug fd vsadlhf sdlajsh sdv',
        10000.00,
        0,
        '/uploads/img_699f0f7a2b3277.12810180.jpg',
        '2026-02-25 15:04:26',
        NULL
    ),
    (
        227,
        NULL,
        NULL,
        'wad',
        'fidhjgfndgj fgjhfdjgg  dfuh gjddf vdfug fd vsadlhf sdlajsh sdv',
        10000.00,
        0,
        '/uploads/img_699f0f7a7d2633.02750215.jpg',
        '2026-02-25 15:04:26',
        NULL
    ),
    (
        228,
        NULL,
        NULL,
        'wad',
        'fidhjgfndgj fgjhfdjgg  dfuh gjddf vdfug fd vsadlhf sdlajsh sdv',
        10000.00,
        0,
        '/uploads/img_699f0f7ff26d96.34254858.jpg',
        '2026-02-25 15:04:31',
        NULL
    ),
    (
        229,
        NULL,
        NULL,
        'wad',
        'fidhjgfndgj fgjhfdjgg  dfuh gjddf vdfug fd vsadlhf sdlajsh sdv',
        10000.00,
        0,
        '/uploads/img_699f0f809df900.16602891.jpg',
        '2026-02-25 15:04:32',
        NULL
    ),
    (
        230,
        NULL,
        NULL,
        'wad',
        'fidhjgfndgj fgjhfdjgg  dfuh gjddf vdfug fd vsadlhf sdlajsh sdv',
        10000.00,
        0,
        '/uploads/img_699f104e747f55.17637922.jpg',
        '2026-02-25 15:07:58',
        NULL
    ),
    (
        231,
        NULL,
        NULL,
        'wad',
        'fidhjgfndgj fgjhfdjgg  dfuh gjddf vdfug fd vsadlhf sdlajsh sdv',
        10000.00,
        0,
        '/uploads/img_699f104ecea0d4.44500420.jpg',
        '2026-02-25 15:07:58',
        NULL
    ),
    (
        232,
        NULL,
        NULL,
        'wad',
        'fidhjgfndgj fgjhfdjgg  dfuh gjddf vdfug fd vsadlhf sdlajsh sdv',
        10000.00,
        0,
        '/uploads/img_699f104fce4b96.41591022.jpg',
        '2026-02-25 15:07:59',
        NULL
    ),
    (
        233,
        NULL,
        NULL,
        'wad',
        'fidhjgfndgj fgjhfdjgg  dfuh gjddf vdfug fd vsadlhf sdlajsh sdv',
        10000.00,
        0,
        '/uploads/img_699f105075edf4.80978869.jpg',
        '2026-02-25 15:08:00',
        NULL
    ),
    (
        234,
        NULL,
        NULL,
        'wad',
        'fidhjgfndgj fgjhfdjgg  dfuh gjddf vdfug fd vsadlhf sdlajsh sdv',
        10000.00,
        0,
        '/uploads/img_699f1050a2d365.03935809.jpg',
        '2026-02-25 15:08:00',
        NULL
    ),
    (
        235,
        NULL,
        NULL,
        'wad',
        'fidhjgfndgj fgjhfdjgg  dfuh gjddf vdfug fd vsadlhf sdlajsh sdv',
        10000.00,
        0,
        '/uploads/img_699f1051492169.17784827.jpg',
        '2026-02-25 15:08:01',
        NULL
    ),
    (
        236,
        NULL,
        NULL,
        'wad',
        'fidhjgfndgj fgjhfdjgg  dfuh gjddf vdfug fd vsadlhf sdlajsh sdv',
        10000.00,
        0,
        '/uploads/img_699f1bd39b3042.11716954.jpg',
        '2026-02-25 15:57:07',
        NULL
    ),
    (
        237,
        NULL,
        NULL,
        'wad',
        'fidhjgfndgj fgjhfdjgg  dfuh gjddf vdfug fd vsadlhf sdlajsh sdv',
        10000.00,
        0,
        '/uploads/img_699f1bd4435920.63609459.jpg',
        '2026-02-25 15:57:08',
        NULL
    ),
    (
        238,
        1,
        NULL,
        'roz',
        'test',
        2000.00,
        0,
        '',
        '2026-02-25 15:59:18',
        NULL
    ),
    (
        239,
        1,
        NULL,
        'roz',
        'test',
        2000.00,
        0,
        '',
        '2026-02-25 16:00:55',
        NULL
    ),
    (
        240,
        1,
        NULL,
        'roz',
        'test',
        2000.00,
        0,
        '',
        '2026-02-25 16:08:04',
        NULL
    ),
    (
        241,
        NULL,
        NULL,
        'wad',
        'fidhjgfndgj fgjhfdjgg  dfuh gjddf vdfug fd vsadlhf sdlajsh sdv',
        10000.00,
        0,
        '/uploads/img_699f1e7752fb56.12292117.jpg',
        '2026-02-25 16:08:23',
        NULL
    ),
    (
        242,
        NULL,
        NULL,
        'wad',
        'fidhjgfndgj fgjhfdjgg  dfuh gjddf vdfug fd vsadlhf sdlajsh sdv',
        10000.00,
        0,
        '/uploads/img_699f1e77aee8c4.62801062.jpg',
        '2026-02-25 16:08:23',
        NULL
    ),
    (
        243,
        NULL,
        NULL,
        'cat',
        'diosfsjfn fasdfhbadsf sad f asd f f',
        10000.00,
        0,
        '/uploads/img_699f1eb3af1b64.82962470.jpg',
        '2026-02-25 16:09:23',
        NULL
    ),
    (
        244,
        NULL,
        NULL,
        'cat',
        'diosfsjfn fasdfhbadsf sad f asd f f',
        10000.00,
        0,
        '/uploads/img_699f1eb4599e97.23742123.jpg',
        '2026-02-25 16:09:24',
        NULL
    ),
    (
        245,
        NULL,
        NULL,
        'cat',
        'diosfsjfn fasdfhbadsf sad f asd f f',
        10000.00,
        0,
        '/uploads/img_699f1eb72f3e41.79846750.jpg',
        '2026-02-25 16:09:27',
        NULL
    ),
    (
        246,
        NULL,
        NULL,
        'cat',
        'diosfsjfn fasdfhbadsf sad f asd f f',
        10000.00,
        0,
        '/uploads/img_699f1eb7d35876.04649746.jpg',
        '2026-02-25 16:09:27',
        NULL
    ),
    (
        247,
        1,
        NULL,
        'roz',
        'test',
        2000.00,
        0,
        '',
        '2026-02-25 16:12:05',
        NULL
    ),
    (
        248,
        NULL,
        NULL,
        'cat',
        'diosfsjfn fasdfhbadsf sad f asd f f',
        10000.00,
        0,
        '/uploads/img_699f1f63cca134.03363737.jpg',
        '2026-02-25 16:12:19',
        NULL
    ),
    (
        249,
        NULL,
        NULL,
        'cat',
        'diosfsjfn fasdfhbadsf sad f asd f f',
        10000.00,
        0,
        '/uploads/img_699f1f64342547.67433216.jpg',
        '2026-02-25 16:12:20',
        NULL
    ),
    (
        250,
        NULL,
        NULL,
        'cat',
        'diosfsjfn fasdfhbadsf sad f asd f f',
        10000.00,
        0,
        '/uploads/img_699f1f655a6262.80556819.jpg',
        '2026-02-25 16:12:21',
        NULL
    ),
    (
        251,
        NULL,
        NULL,
        'cat',
        'diosfsjfn fasdfhbadsf sad f asd f f',
        10000.00,
        0,
        '/uploads/img_699f1f66052314.53291305.jpg',
        '2026-02-25 16:12:22',
        NULL
    ),
    (
        252,
        NULL,
        NULL,
        'cat',
        'diosfsjfn fasdfhbadsf sad f asd f f',
        10000.00,
        0,
        '/uploads/img_699f211c761b20.03184130.jpg',
        '2026-02-25 16:19:40',
        NULL
    ),
    (
        253,
        NULL,
        NULL,
        'cat',
        'diosfsjfn fasdfhbadsf sad f asd f f',
        10000.00,
        0,
        '/uploads/img_699f211f780a95.24260136.jpg',
        '2026-02-25 16:19:43',
        NULL
    ),
    (
        254,
        NULL,
        NULL,
        'hand maker',
        'sdfsfsdfd f sdfsdf sdf sdf s fsdfs',
        1000.00,
        0,
        '/uploads/img_699f23a462e296.44977893.jpg',
        '2026-02-25 16:30:28',
        NULL
    ),
    (
        255,
        NULL,
        NULL,
        'hand maker',
        'sdfsfsdfd f sdfsdf sdf sdf s fsdfs',
        1000.00,
        0,
        '/uploads/img_699f23a9645e86.14952032.jpg',
        '2026-02-25 16:30:33',
        NULL
    ),
    (
        256,
        NULL,
        NULL,
        'rated',
        'highjtle',
        400.00,
        0,
        '/uploads/img_699f24ad01c8d9.06636582.png',
        '2026-02-25 16:34:53',
        NULL
    ),
    (
        257,
        NULL,
        NULL,
        'rated',
        'highjtle',
        400.00,
        0,
        '/uploads/img_699f24b2026325.20152427.png',
        '2026-02-25 16:34:58',
        NULL
    ),
    (
        258,
        NULL,
        NULL,
        'rated',
        'highjtle',
        400.00,
        0,
        '/uploads/img_699f24b56cb6c8.80504839.png',
        '2026-02-25 16:35:01',
        NULL
    ),
    (
        259,
        NULL,
        NULL,
        'rated',
        'highjtle',
        400.00,
        0,
        '/uploads/img_699f24b71b0301.63314193.png',
        '2026-02-25 16:35:03',
        NULL
    ),
    (
        260,
        NULL,
        NULL,
        'rated',
        'highjtle',
        400.00,
        0,
        '/uploads/img_699f24b8390761.92318733.png',
        '2026-02-25 16:35:04',
        NULL
    ),
    (
        261,
        NULL,
        NULL,
        'rated',
        'highjtle',
        400.00,
        0,
        '/uploads/img_699f24b8b397f8.99132389.png',
        '2026-02-25 16:35:04',
        NULL
    ),
    (
        262,
        NULL,
        NULL,
        'rated',
        'highjtle',
        400.00,
        0,
        '/uploads/img_699f24b9097033.56799488.png',
        '2026-02-25 16:35:05',
        NULL
    ),
    (
        263,
        NULL,
        NULL,
        'rated',
        'highjtle',
        400.00,
        0,
        '/uploads/img_699f24b94a7879.32846638.png',
        '2026-02-25 16:35:05',
        NULL
    ),
    (
        264,
        NULL,
        NULL,
        'rated',
        'highjtle',
        400.00,
        0,
        '/uploads/img_699f27d22b6319.58889130.png',
        '2026-02-25 16:48:18',
        NULL
    ),
    (
        265,
        NULL,
        NULL,
        'rated',
        'highjtle',
        400.00,
        0,
        '/uploads/img_699f2952686883.23528768.png',
        '2026-02-25 16:54:42',
        NULL
    ),
    (
        266,
        NULL,
        NULL,
        'rated',
        'highjtle',
        400.00,
        0,
        '/uploads/img_699f2955ec2f01.30103077.png',
        '2026-02-25 16:54:45',
        NULL
    ),
    (
        267,
        NULL,
        NULL,
        'fararri',
        'dfajfnmdsfadfsadfa',
        99999999.99,
        0,
        '/uploads/img_699f2e75d9bc03.00506737.png',
        '2026-02-25 17:16:37',
        NULL
    ),
    (
        268,
        NULL,
        NULL,
        'fararri',
        'dfajfnmdsfadfsadfa',
        99999999.99,
        0,
        '/uploads/img_699f2e775ec661.96832930.png',
        '2026-02-25 17:16:39',
        NULL
    ),
    (
        269,
        NULL,
        NULL,
        'fararri',
        'dfajfnmdsfadfsadfa',
        99999999.99,
        0,
        '/uploads/img_699f2e80aa8ee2.65781228.png',
        '2026-02-25 17:16:48',
        NULL
    ),
    (
        270,
        NULL,
        NULL,
        'fararri',
        'dfajfnmdsfadfsadfa',
        99999999.99,
        0,
        '/uploads/img_699f2ede70b477.49715310.png',
        '2026-02-25 17:18:22',
        NULL
    ),
    (
        271,
        NULL,
        NULL,
        'fararri',
        'dfajfnmdsfadfsadfa',
        99999999.99,
        0,
        '/uploads/img_699f2edf8380f3.82734687.png',
        '2026-02-25 17:18:23',
        NULL
    ),
    (
        272,
        NULL,
        NULL,
        'fararri',
        'dfajfnmdsfadfsadfa',
        99999999.99,
        0,
        '/uploads/img_699f2ee06fcc49.44572011.png',
        '2026-02-25 17:18:24',
        NULL
    ),
    (
        273,
        NULL,
        NULL,
        'fararri',
        'dfajfnmdsfadfsadfa',
        99999999.99,
        0,
        '/uploads/img_699f2ee0b54076.09911659.png',
        '2026-02-25 17:18:24',
        NULL
    ),
    (
        274,
        NULL,
        NULL,
        'fararri',
        'dfajfnmdsfadfsadfa',
        99999999.99,
        0,
        '/uploads/img_699f2ee1aeb559.27224708.png',
        '2026-02-25 17:18:25',
        NULL
    ),
    (
        275,
        NULL,
        NULL,
        'fararri',
        'dfajfnmdsfadfsadfa',
        99999999.99,
        0,
        '/uploads/img_699f2ee2577321.72732803.png',
        '2026-02-25 17:18:26',
        NULL
    ),
    (
        276,
        NULL,
        NULL,
        'fararri',
        'dfajfnmdsfadfsadfa',
        99999999.99,
        0,
        '/uploads/img_699f2ee36fe4e4.47620942.png',
        '2026-02-25 17:18:27',
        NULL
    ),
    (
        277,
        NULL,
        NULL,
        'fararri',
        'dfajfnmdsfadfsadfa',
        99999999.99,
        0,
        '/uploads/img_699f2ee44bb040.36610764.png',
        '2026-02-25 17:18:28',
        NULL
    ),
    (
        278,
        NULL,
        NULL,
        'fararri',
        'dfajfnmdsfadfsadfa',
        99999999.99,
        0,
        '/uploads/img_699f2f78bb9811.43135565.png',
        '2026-02-25 17:20:56',
        NULL
    ),
    (
        279,
        NULL,
        NULL,
        'id card',
        'hfdkjfsknfs sdbfjs fads ff sd fsd',
        100.00,
        0,
        '/uploads/img_699f324461ba83.15883878.jpg',
        '2026-02-25 17:32:52',
        NULL
    ),
    (
        280,
        NULL,
        NULL,
        'ko',
        'sdsdfgd gd gd gd gdg dfg',
        1000.00,
        0,
        '/uploads/img_699f347e20dbc0.55420905.png',
        '2026-02-25 17:42:22',
        NULL
    ),
    (
        281,
        NULL,
        NULL,
        'doll',
        'ddd',
        1038.00,
        0,
        '/uploads/img_699f34c234b581.23859980.jpg',
        '2026-02-25 17:43:30',
        NULL
    ),
    (
        282,
        NULL,
        NULL,
        'kjkj',
        'ihkbnj g uyhnjm',
        89000.00,
        0,
        '/uploads/img_69a0de4011ef59.35867813.png',
        '2026-02-26 23:58:56',
        NULL
    ),
    (
        283,
        NULL,
        NULL,
        'rtrt',
        'retwtwe',
        30880.00,
        0,
        '/uploads/img_69a0de5dd2aee9.15376140.jpg',
        '2026-02-26 23:59:25',
        NULL
    ),
    (
        284,
        3,
        1,
        'djhf',
        'shfasjdhf bdsf bahdb fdfhasdfa',
        3000.00,
        0,
        '/uploads/img_69a0df9441b690.95291159.png',
        '2026-02-27 00:04:36',
        NULL
    );

-- --------------------------------------------------------

--
-- Table structure for table `promotions`
--

CREATE TABLE `promotions` (
    `promotion_id` int(11) NOT NULL,
    `title` varchar(100) NOT NULL,
    `description` text DEFAULT NULL,
    `discount_percent` decimal(5, 2) DEFAULT NULL,
    `start_date` date DEFAULT NULL,
    `end_date` date DEFAULT NULL,
    `active` tinyint(1) DEFAULT 1
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_general_ci;

--
-- Dumping data for table `promotions`
--

INSERT INTO
    `promotions` (
        `promotion_id`,
        `title`,
        `description`,
        `discount_percent`,
        `start_date`,
        `end_date`,
        `active`
    )
VALUES (
        1,
        'Winter Sale',
        'Up to 20% off on lighting',
        20.00,
        '2026-02-22',
        '2026-03-24',
        1
    ),
    (
        2,
        'Tools Discount',
        '10% off on tools',
        10.00,
        '2026-02-22',
        '2026-04-23',
        1
    ),
    (
        3,
        'Winter Sale',
        'Up to 20% off on lighting',
        20.00,
        '2026-02-25',
        '2026-03-27',
        1
    ),
    (
        4,
        'Tools Discount',
        '10% off on tools',
        10.00,
        '2026-02-25',
        '2026-04-26',
        1
    );

-- --------------------------------------------------------

--
-- Table structure for table `reports`
--

CREATE TABLE `reports` (
    `report_id` int(11) NOT NULL,
    `admin_id` int(11) DEFAULT NULL,
    `report_type` varchar(100) DEFAULT NULL,
    `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
    `details` text DEFAULT NULL
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `site_settings`
--

CREATE TABLE `site_settings` (
    `setting_key` varchar(100) NOT NULL,
    `setting_value` text NOT NULL,
    `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_general_ci;

--
-- Dumping data for table `site_settings`
--

INSERT INTO
    `site_settings` (
        `setting_key`,
        `setting_value`,
        `updated_at`
    )
VALUES (
        'banners_hero',
        '[{\"label\":\"DEMO\",\"image\":\"\\/uploads\\/test.jpg\"}]',
        '2026-02-26 07:39:54'
    ),
    (
        'banners_mid',
        '[{\"img\":\"\\/uploads\\/m1.jpg\"},{\"img\":\"\\/uploads\\/m2.jpg\"},{\"img\":\"\\/uploads\\/m3.jpg\"}]',
        '2026-02-26 07:39:54'
    ),
    (
        'section_filter_best_sellers',
        '{\"sort\":\"newest\",\"limit\":2,\"min_price\":1000,\"max_price\":2000}',
        '2026-02-24 18:24:54'
    ),
    (
        'section_filter_deals',
        '{\"sort\":\"newest\",\"limit\":20}',
        '2026-02-24 14:53:47'
    ),
    (
        'section_filter_flash_sale',
        '{\"sort\":\"price_desc\",\"limit\":5,\"min_price\":50}',
        '2026-02-24 14:54:11'
    ),
    (
        'section_filter_tech_part',
        '{\"sort\":\"newest\",\"limit\":20}',
        '2026-02-24 14:53:47'
    ),
    (
        'section_filter_trending',
        '{\"sort\":\"newest\",\"limit\":20}',
        '2026-02-24 14:53:47'
    );

-- --------------------------------------------------------

--
-- Table structure for table `tech_part_products`
--

CREATE TABLE `tech_part_products` (
    `product_id` int(11) NOT NULL,
    `display_order` int(11) DEFAULT 0,
    `added_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_general_ci;

--
-- Dumping data for table `tech_part_products`
--

INSERT INTO
    `tech_part_products` (
        `product_id`,
        `display_order`,
        `added_at`
    )
VALUES (1, 0, '2026-02-22 14:59:17'),
    (4, 1, '2026-02-22 14:59:17'),
    (5, 2, '2026-02-22 14:59:17'),
    (6, 3, '2026-02-22 14:59:17'),
    (54, 0, '2026-02-22 15:26:49'),
    (55, 0, '2026-02-22 15:26:49'),
    (56, 0, '2026-02-22 15:26:49'),
    (57, 0, '2026-02-22 15:26:49'),
    (61, 0, '2026-02-22 15:26:49'),
    (62, 0, '2026-02-22 15:26:49');

-- --------------------------------------------------------

--
-- Table structure for table `trending_products`
--

CREATE TABLE `trending_products` (
    `product_id` int(11) NOT NULL,
    `trending_score` int(11) DEFAULT 0,
    `last_updated` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_general_ci;

--
-- Dumping data for table `trending_products`
--

INSERT INTO
    `trending_products` (
        `product_id`,
        `trending_score`,
        `last_updated`
    )
VALUES (1, 80, '2026-02-22 14:59:17'),
    (2, 80, '2026-02-22 11:20:16'),
    (3, 60, '2026-02-22 14:59:17'),
    (4, 50, '2026-02-22 14:59:17'),
    (5, 40, '2026-02-22 14:59:17'),
    (6, 30, '2026-02-22 14:59:17'),
    (31, 50, '2026-02-22 15:26:44'),
    (32, 50, '2026-02-22 15:26:44'),
    (33, 50, '2026-02-22 15:26:44'),
    (34, 50, '2026-02-22 15:26:44'),
    (35, 50, '2026-02-22 15:26:44'),
    (36, 50, '2026-02-22 15:26:44'),
    (37, 50, '2026-02-22 15:26:44'),
    (38, 50, '2026-02-22 15:26:44'),
    (39, 50, '2026-02-22 15:26:44'),
    (40, 50, '2026-02-22 15:26:44'),
    (41, 50, '2026-02-22 15:26:44'),
    (42, 50, '2026-02-22 15:26:44'),
    (43, 50, '2026-02-22 15:26:44'),
    (44, 50, '2026-02-22 15:26:44'),
    (45, 50, '2026-02-22 15:26:44'),
    (46, 50, '2026-02-22 15:26:44'),
    (47, 50, '2026-02-22 15:26:44'),
    (48, 50, '2026-02-22 15:26:44'),
    (49, 50, '2026-02-22 15:26:44'),
    (50, 50, '2026-02-22 15:26:44'),
    (51, 50, '2026-02-22 15:26:44'),
    (52, 50, '2026-02-22 15:26:44'),
    (53, 50, '2026-02-22 15:26:44'),
    (54, 50, '2026-02-22 15:26:44'),
    (55, 50, '2026-02-22 15:26:44'),
    (56, 50, '2026-02-22 15:26:44'),
    (57, 50, '2026-02-22 15:26:44'),
    (58, 50, '2026-02-22 15:26:44'),
    (59, 50, '2026-02-22 15:26:44'),
    (60, 50, '2026-02-22 15:26:44'),
    (61, 50, '2026-02-22 15:26:44'),
    (62, 50, '2026-02-22 15:26:44'),
    (63, 50, '2026-02-22 15:26:44'),
    (64, 50, '2026-02-22 15:26:44'),
    (65, 50, '2026-02-22 15:26:44'),
    (66, 50, '2026-02-22 15:26:44'),
    (67, 50, '2026-02-22 15:26:44'),
    (68, 50, '2026-02-22 15:26:44'),
    (69, 50, '2026-02-22 15:26:44'),
    (70, 50, '2026-02-22 15:26:44'),
    (71, 50, '2026-02-22 15:26:44'),
    (72, 50, '2026-02-22 15:26:44'),
    (73, 50, '2026-02-22 15:26:44'),
    (74, 50, '2026-02-22 15:26:44'),
    (75, 50, '2026-02-22 15:26:44'),
    (76, 50, '2026-02-22 15:26:44'),
    (77, 50, '2026-02-22 15:26:44'),
    (
        177,
        50,
        '2026-02-25 00:24:43'
    ),
    (
        178,
        50,
        '2026-02-25 00:24:43'
    ),
    (
        179,
        50,
        '2026-02-25 00:24:43'
    ),
    (
        180,
        50,
        '2026-02-25 00:24:43'
    ),
    (
        181,
        50,
        '2026-02-25 00:24:43'
    ),
    (
        182,
        50,
        '2026-02-25 00:24:43'
    ),
    (
        183,
        50,
        '2026-02-25 00:24:43'
    ),
    (
        184,
        50,
        '2026-02-25 00:24:43'
    ),
    (
        185,
        50,
        '2026-02-25 00:24:43'
    ),
    (
        186,
        50,
        '2026-02-25 00:24:43'
    ),
    (
        187,
        50,
        '2026-02-25 00:24:43'
    ),
    (
        188,
        50,
        '2026-02-25 00:24:43'
    ),
    (
        189,
        50,
        '2026-02-25 00:24:43'
    ),
    (
        190,
        50,
        '2026-02-25 00:24:43'
    ),
    (
        191,
        50,
        '2026-02-25 00:24:43'
    ),
    (
        192,
        50,
        '2026-02-25 00:24:43'
    ),
    (
        193,
        50,
        '2026-02-25 00:24:43'
    ),
    (
        194,
        50,
        '2026-02-25 00:24:43'
    ),
    (
        195,
        50,
        '2026-02-25 00:24:43'
    ),
    (
        196,
        50,
        '2026-02-25 00:24:43'
    ),
    (
        197,
        50,
        '2026-02-25 00:24:43'
    ),
    (
        198,
        50,
        '2026-02-25 00:24:43'
    ),
    (
        199,
        50,
        '2026-02-25 00:24:43'
    ),
    (
        200,
        50,
        '2026-02-25 00:24:43'
    ),
    (
        201,
        50,
        '2026-02-25 00:24:43'
    ),
    (
        202,
        50,
        '2026-02-25 00:24:43'
    ),
    (
        203,
        50,
        '2026-02-25 00:24:43'
    ),
    (
        204,
        50,
        '2026-02-25 00:24:43'
    ),
    (
        205,
        50,
        '2026-02-25 00:24:43'
    ),
    (
        206,
        50,
        '2026-02-25 00:24:43'
    ),
    (
        207,
        50,
        '2026-02-25 00:24:43'
    ),
    (
        208,
        50,
        '2026-02-25 00:24:43'
    ),
    (
        209,
        50,
        '2026-02-25 00:24:43'
    ),
    (
        210,
        50,
        '2026-02-25 00:24:43'
    ),
    (
        211,
        50,
        '2026-02-25 00:24:43'
    ),
    (
        212,
        50,
        '2026-02-25 00:24:43'
    ),
    (
        213,
        50,
        '2026-02-25 00:24:43'
    ),
    (
        214,
        50,
        '2026-02-25 00:24:43'
    ),
    (
        215,
        50,
        '2026-02-25 00:24:43'
    ),
    (
        216,
        50,
        '2026-02-25 00:24:43'
    ),
    (
        217,
        50,
        '2026-02-25 00:24:43'
    ),
    (
        218,
        50,
        '2026-02-25 00:24:43'
    ),
    (
        219,
        50,
        '2026-02-25 00:24:43'
    ),
    (
        220,
        50,
        '2026-02-25 00:24:43'
    ),
    (
        221,
        50,
        '2026-02-25 00:24:43'
    ),
    (
        222,
        50,
        '2026-02-25 00:24:43'
    ),
    (
        223,
        50,
        '2026-02-25 00:24:43'
    ),
    (240, 1, '2026-02-25 16:08:05'),
    (280, 1, '2026-02-25 17:42:22'),
    (284, 1, '2026-02-27 00:04:36');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
    `user_id` int(11) NOT NULL,
    `full_name` varchar(100) NOT NULL,
    `last_name` varchar(50) NOT NULL DEFAULT '',
    `email` varchar(100) NOT NULL,
    `password` varchar(255) NOT NULL,
    `phone_number` varchar(20) DEFAULT NULL,
    `address` text DEFAULT NULL,
    `gender` varchar(10) DEFAULT 'Male',
    `role` enum('admin', 'customer') DEFAULT 'customer',
    `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO
    `users` (
        `user_id`,
        `full_name`,
        `last_name`,
        `email`,
        `password`,
        `phone_number`,
        `address`,
        `gender`,
        `role`,
        `created_at`
    )
VALUES (
        1,
        'Ahnaf',
        'Admin',
        'ahnaf@electrocitybd.com',
        '$2a$10$TzYhDF5S1ZgMlSoxGBPcU.bUFBwtEkO9pLPmGWtSUFJgqTrZym8Ty',
        '+880 1700-000000',
        NULL,
        'Male',
        'admin',
        '2026-02-22 11:20:50'
    ),
    (
        3,
        'Ahnaf',
        'Arnab',
        'A@gmail.com',
        'aaaaaa',
        '019983838383',
        'badda, 232,zaman tower, Dhaka 1212',
        'Male',
        'customer',
        '2026-02-22 11:27:03'
    ),
    (
        26,
        'as',
        '',
        'As@gmail.com',
        '$2y$10$ceXlVESlVt.AmJMiSf2DG.youdUPxStqYtmh3rzyJRXm/1GJIBKHS',
        '',
        '',
        'Female',
        'customer',
        '2026-02-25 09:19:16'
    ),
    (
        27,
        'Test',
        'User',
        'test_1772011194787@electrocity.local',
        '$2y$10$vQQhYlK8X7/zcELEjlk8Y.5yyVa6JfsUHK8e8oMPxm1RORj8xo9tK',
        '01234567890',
        NULL,
        'Male',
        'customer',
        '2026-02-25 09:19:54'
    ),
    (
        28,
        'Test',
        'User',
        'test_1772011228441@electrocity.local',
        '$2y$10$QiOXLXt7.aJ1zEk.bLx2geNPrTh8G9anWTbolqNynExBsft43wq82',
        '01234567890',
        NULL,
        'Male',
        'customer',
        '2026-02-25 09:20:28'
    ),
    (
        29,
        'Changed',
        'Name',
        'test386115637@electrocity.local',
        '$2y$10$y9XSOUPBZu/qDem04N59bepTVmjlO0ZRXhtMN7VTaNrkGHON2lRxO',
        '01234567890',
        '',
        'Female',
        'customer',
        '2026-02-25 09:23:11'
    ),
    (
        30,
        'Asman',
        'Hasan',
        'asman@gmail.com',
        '$2y$10$f.5LJwWdHaEvUqiheFI6jOcPLVTHYhwJhb6ekBfUkh3rwMeT1Yi3G',
        '01982837452',
        'bashundhara R/A, road -13,house no 23, Dhaka 1229',
        'Male',
        'customer',
        '2026-02-25 09:25:09'
    ),
    (
        31,
        'Test',
        'User',
        'test_1772039092727@electrocity.local',
        '$2y$10$qGJeDz4uQjgTMOdk/0CgKulLIruVX5tfnAWqkeXQCW37b2ZQ6i9/G',
        '01234567890',
        NULL,
        'Male',
        'customer',
        '2026-02-25 17:04:52'
    ),
    (
        32,
        'Test',
        'User',
        'test_1772039142076@electrocity.local',
        '$2y$10$Gz822stxi0/v7idiGnzyXO//glBH.IGjiymUkiEIW..JqWOCrY6me',
        '01234567890',
        NULL,
        'Male',
        'customer',
        '2026-02-25 17:05:42'
    ),
    (
        33,
        'Test',
        'User',
        'test_1772039233509@electrocity.local',
        '$2y$10$mAgCmOB1X2nVXxWR0EIWFul4U14LBMuMxrd5clgl9ZqtGKFQ9yiGO',
        '01234567890',
        NULL,
        'Male',
        'customer',
        '2026-02-25 17:07:13'
    ),
    (
        34,
        'Test',
        'User',
        'test_1772039331282@electrocity.local',
        '$2y$10$.HciUDkZCV9bzxx.3B1Vc.b5OUjTe5RiZwaRpMehEhC/mVt3rylGS',
        '01234567890',
        NULL,
        'Male',
        'customer',
        '2026-02-25 17:08:51'
    ),
    (
        35,
        'Test',
        'User',
        'test_1772039380322@electrocity.local',
        '$2y$10$MDFLIaQy8mHx7zkC2O8rLuSomdcU/O13HzdnOpp9Fx3SZdt4pYFK6',
        '01234567890',
        NULL,
        'Male',
        'customer',
        '2026-02-25 17:09:40'
    ),
    (
        36,
        'Test',
        'User',
        'test_1772091751722@electrocity.local',
        '$2y$10$KhB8A1C3pzVcyWm8ispcx.gimAxYTP10r3YHGJkXbbtyrMGMIH1Ve',
        '01234567890',
        NULL,
        'Male',
        'customer',
        '2026-02-26 07:42:31'
    ),
    (
        37,
        'Test',
        'User',
        'test_1772149757965@electrocity.local',
        '$2y$10$LVRfviq7aTYbxhAzKmAYKu1RGXj/wz0c49FJTXEq3L/7.tk9bKQru',
        '01234567890',
        NULL,
        'Male',
        'customer',
        '2026-02-26 23:49:18'
    ),
    (
        38,
        'Test',
        'User',
        'test_1772149796809@electrocity.local',
        '$2y$10$nXhTr/JSW338dSBCReWOlOkiKi89pab4XzS.U1F1ztFgfjZ8BkZ0.',
        '01234567890',
        NULL,
        'Male',
        'customer',
        '2026-02-26 23:49:56'
    );

-- --------------------------------------------------------

--
-- Table structure for table `user_profile`
--

CREATE TABLE `user_profile` (
    `user_id` int(11) NOT NULL,
    `full_name` varchar(100) NOT NULL,
    `last_name` varchar(50) NOT NULL DEFAULT '',
    `phone_number` varchar(20) DEFAULT NULL,
    `address` text DEFAULT NULL,
    `gender` varchar(10) DEFAULT 'Male',
    `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_general_ci;

--
-- Dumping data for table `user_profile`
--

INSERT INTO
    `user_profile` (
        `user_id`,
        `full_name`,
        `last_name`,
        `phone_number`,
        `address`,
        `gender`,
        `updated_at`
    )
VALUES (
        26,
        'as',
        '',
        '',
        '',
        'Female',
        '2026-02-25 09:20:33'
    ),
    (
        27,
        'Test',
        'User',
        '01234567890',
        NULL,
        'Male',
        '2026-02-25 09:19:54'
    ),
    (
        28,
        'Test',
        'User',
        '01234567890',
        NULL,
        'Male',
        '2026-02-25 09:20:28'
    ),
    (
        29,
        'Changed',
        'Name',
        '01234567890',
        '',
        'Female',
        '2026-02-25 09:23:11'
    ),
    (
        30,
        'Asman',
        'Hasan',
        '01982837452',
        'bashundhara R/A, road -13,house no 23, Dhaka 1229',
        'Male',
        '2026-02-25 09:40:29'
    ),
    (
        31,
        'Test',
        'User',
        '01234567890',
        NULL,
        'Male',
        '2026-02-25 17:04:52'
    ),
    (
        32,
        'Test',
        'User',
        '01234567890',
        NULL,
        'Male',
        '2026-02-25 17:05:42'
    ),
    (
        33,
        'Test',
        'User',
        '01234567890',
        NULL,
        'Male',
        '2026-02-25 17:07:13'
    ),
    (
        34,
        'Test',
        'User',
        '01234567890',
        NULL,
        'Male',
        '2026-02-25 17:08:51'
    ),
    (
        35,
        'Test',
        'User',
        '01234567890',
        NULL,
        'Male',
        '2026-02-25 17:09:40'
    ),
    (
        36,
        'Test',
        'User',
        '01234567890',
        NULL,
        'Male',
        '2026-02-26 07:42:31'
    ),
    (
        37,
        'Test',
        'User',
        '01234567890',
        NULL,
        'Male',
        '2026-02-26 23:49:18'
    ),
    (
        38,
        'Test',
        'User',
        '01234567890',
        NULL,
        'Male',
        '2026-02-26 23:49:56'
    );

-- --------------------------------------------------------

--
-- Table structure for table `wishlists`
--

CREATE TABLE `wishlists` (
    `wishlist_id` int(11) NOT NULL,
    `user_id` int(11) DEFAULT NULL,
    `product_id` int(11) DEFAULT NULL,
    `added_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_general_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `best_sellers`
--
ALTER TABLE `best_sellers` ADD PRIMARY KEY (`product_id`);

--
-- Indexes for table `brands`
--
ALTER TABLE `brands` ADD PRIMARY KEY (`brand_id`);

--
-- Indexes for table `cart`
--
ALTER TABLE `cart`
ADD PRIMARY KEY (`cart_id`),
ADD KEY `product_id` (`product_id`),
ADD KEY `idx_cart_user` (`user_id`);

--
-- Indexes for table `categories`
--
ALTER TABLE `categories` ADD PRIMARY KEY (`category_id`);

--
-- Indexes for table `collections`
--
ALTER TABLE `collections` ADD PRIMARY KEY (`collection_id`);

--
-- Indexes for table `collection_products`
--
ALTER TABLE `collection_products`
ADD PRIMARY KEY (`collection_id`, `product_id`),
ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `customer_support`
--
ALTER TABLE `customer_support`
ADD PRIMARY KEY (`ticket_id`),
ADD KEY `user_id` (`user_id`),
ADD KEY `resolved_by` (`resolved_by`);

--
-- Indexes for table `deals_of_the_day`
--
ALTER TABLE `deals_of_the_day`
ADD PRIMARY KEY (`deal_id`),
ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `discounts`
--
ALTER TABLE `discounts`
ADD PRIMARY KEY (`discount_id`),
ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `flash_sales`
--
ALTER TABLE `flash_sales` ADD PRIMARY KEY (`flash_sale_id`);

--
-- Indexes for table `flash_sale_products`
--
ALTER TABLE `flash_sale_products`
ADD PRIMARY KEY (`flash_sale_id`, `product_id`),
ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
ADD PRIMARY KEY (`order_id`),
ADD KEY `idx_orders_user` (`user_id`);

--
-- Indexes for table `order_items`
--
ALTER TABLE `order_items`
ADD PRIMARY KEY (`order_item_id`),
ADD KEY `product_id` (`product_id`),
ADD KEY `idx_order_items_order` (`order_id`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
ADD PRIMARY KEY (`product_id`),
ADD KEY `brand_id` (`brand_id`),
ADD KEY `idx_products_category` (`category_id`);

--
-- Indexes for table `promotions`
--
ALTER TABLE `promotions` ADD PRIMARY KEY (`promotion_id`);

--
-- Indexes for table `reports`
--
ALTER TABLE `reports`
ADD PRIMARY KEY (`report_id`),
ADD KEY `admin_id` (`admin_id`);

--
-- Indexes for table `site_settings`
--
ALTER TABLE `site_settings` ADD PRIMARY KEY (`setting_key`);

--
-- Indexes for table `tech_part_products`
--
ALTER TABLE `tech_part_products` ADD PRIMARY KEY (`product_id`);

--
-- Indexes for table `trending_products`
--
ALTER TABLE `trending_products` ADD PRIMARY KEY (`product_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
ADD PRIMARY KEY (`user_id`),
ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `user_profile`
--
ALTER TABLE `user_profile` ADD PRIMARY KEY (`user_id`);

--
-- Indexes for table `wishlists`
--
ALTER TABLE `wishlists`
ADD PRIMARY KEY (`wishlist_id`),
ADD KEY `product_id` (`product_id`),
ADD KEY `idx_wishlists_user` (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `brands`
--
ALTER TABLE `brands`
MODIFY `brand_id` int(11) NOT NULL AUTO_INCREMENT,
AUTO_INCREMENT = 52;

--
-- AUTO_INCREMENT for table `cart`
--
ALTER TABLE `cart`
MODIFY `cart_id` int(11) NOT NULL AUTO_INCREMENT,
AUTO_INCREMENT = 5;

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
MODIFY `category_id` int(11) NOT NULL AUTO_INCREMENT,
AUTO_INCREMENT = 127;

--
-- AUTO_INCREMENT for table `collections`
--
ALTER TABLE `collections`
MODIFY `collection_id` int(11) NOT NULL AUTO_INCREMENT,
AUTO_INCREMENT = 3;

--
-- AUTO_INCREMENT for table `customer_support`
--
ALTER TABLE `customer_support`
MODIFY `ticket_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `deals_of_the_day`
--
ALTER TABLE `deals_of_the_day`
MODIFY `deal_id` int(11) NOT NULL AUTO_INCREMENT,
AUTO_INCREMENT = 50;

--
-- AUTO_INCREMENT for table `discounts`
--
ALTER TABLE `discounts`
MODIFY `discount_id` int(11) NOT NULL AUTO_INCREMENT,
AUTO_INCREMENT = 2;

--
-- AUTO_INCREMENT for table `flash_sales`
--
ALTER TABLE `flash_sales`
MODIFY `flash_sale_id` int(11) NOT NULL AUTO_INCREMENT,
AUTO_INCREMENT = 19;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
MODIFY `order_id` int(11) NOT NULL AUTO_INCREMENT,
AUTO_INCREMENT = 39;

--
-- AUTO_INCREMENT for table `order_items`
--
ALTER TABLE `order_items`
MODIFY `order_item_id` int(11) NOT NULL AUTO_INCREMENT,
AUTO_INCREMENT = 6;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
MODIFY `product_id` int(11) NOT NULL AUTO_INCREMENT,
AUTO_INCREMENT = 285;

--
-- AUTO_INCREMENT for table `promotions`
--
ALTER TABLE `promotions`
MODIFY `promotion_id` int(11) NOT NULL AUTO_INCREMENT,
AUTO_INCREMENT = 5;

--
-- AUTO_INCREMENT for table `reports`
--
ALTER TABLE `reports`
MODIFY `report_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT,
AUTO_INCREMENT = 39;

--
-- AUTO_INCREMENT for table `wishlists`
--
ALTER TABLE `wishlists`
MODIFY `wishlist_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `best_sellers`
--
DELETE FROM `best_sellers`
WHERE
    `product_id` NOT IN(
        SELECT `product_id`
        FROM `products`
    );

ALTER TABLE `best_sellers`
ADD CONSTRAINT `best_sellers_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE CASCADE;

--
-- Constraints for table `cart`
--
DELETE c
FROM `cart` c
    LEFT JOIN `users` u ON c.`user_id` = u.`user_id`
WHERE
    c.`user_id` IS NOT NULL
    AND u.`user_id` IS NULL;

DELETE c
FROM `cart` c
    LEFT JOIN `products` p ON c.`product_id` = p.`product_id`
WHERE
    c.`product_id` IS NOT NULL
    AND p.`product_id` IS NULL;

ALTER TABLE `cart`
ADD CONSTRAINT `cart_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
ADD CONSTRAINT `cart_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE CASCADE;

--
-- Constraints for table `collection_products`
--
DELETE cp
FROM
    `collection_products` cp
    LEFT JOIN `collections` c ON cp.`collection_id` = c.`collection_id`
WHERE
    c.`collection_id` IS NULL;

DELETE cp
FROM
    `collection_products` cp
    LEFT JOIN `products` p ON cp.`product_id` = p.`product_id`
WHERE
    p.`product_id` IS NULL;

ALTER TABLE `collection_products`
ADD CONSTRAINT `collection_products_ibfk_1` FOREIGN KEY (`collection_id`) REFERENCES `collections` (`collection_id`) ON DELETE CASCADE,
ADD CONSTRAINT `collection_products_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE CASCADE;

--
-- Constraints for table `customer_support`
--
UPDATE `customer_support` cs
LEFT JOIN `users` u ON cs.`user_id` = u.`user_id`
SET
    cs.`user_id` = NULL
WHERE
    u.`user_id` IS NULL;

UPDATE `customer_support` cs
LEFT JOIN `users` u ON cs.`resolved_by` = u.`user_id`
SET
    cs.`resolved_by` = NULL
WHERE
    u.`user_id` IS NULL;

ALTER TABLE `customer_support`
ADD CONSTRAINT `customer_support_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL,
ADD CONSTRAINT `customer_support_ibfk_2` FOREIGN KEY (`resolved_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL;

--
-- Constraints for table `deals_of_the_day`
--
DELETE d
FROM
    `deals_of_the_day` d
    LEFT JOIN `products` p ON d.`product_id` = p.`product_id`
WHERE
    p.`product_id` IS NULL;

ALTER TABLE `deals_of_the_day`
ADD CONSTRAINT `deals_of_the_day_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE CASCADE;

--
-- Constraints for table `discounts`
--
DELETE d
FROM `discounts` d
    LEFT JOIN `products` p ON d.`product_id` = p.`product_id`
WHERE
    p.`product_id` IS NULL;

ALTER TABLE `discounts`
ADD CONSTRAINT `discounts_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE CASCADE;

--
-- Constraints for table `flash_sale_products`
--
DELETE fsp
FROM
    `flash_sale_products` fsp
    LEFT JOIN `flash_sales` fs ON fsp.`flash_sale_id` = fs.`flash_sale_id`
WHERE
    fs.`flash_sale_id` IS NULL;

DELETE fsp
FROM
    `flash_sale_products` fsp
    LEFT JOIN `products` p ON fsp.`product_id` = p.`product_id`
WHERE
    p.`product_id` IS NULL;

ALTER TABLE `flash_sale_products`
ADD CONSTRAINT `flash_sale_products_ibfk_1` FOREIGN KEY (`flash_sale_id`) REFERENCES `flash_sales` (`flash_sale_id`) ON DELETE CASCADE,
ADD CONSTRAINT `flash_sale_products_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE CASCADE;

--
-- Constraints for table `orders`
--
UPDATE `orders` o
LEFT JOIN `users` u ON o.`user_id` = u.`user_id`
SET
    o.`user_id` = NULL
WHERE
    u.`user_id` IS NULL;

ALTER TABLE `orders`
ADD CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL;

--
-- Constraints for table `order_items`
--
UPDATE `order_items` oi
LEFT JOIN `products` p ON oi.`product_id` = p.`product_id`
SET
    oi.`product_id` = NULL
WHERE
    p.`product_id` IS NULL;

DELETE oi
FROM `order_items` oi
    LEFT JOIN `orders` o ON oi.`order_id` = o.`order_id`
WHERE
    o.`order_id` IS NULL;

ALTER TABLE `order_items`
ADD CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`) ON DELETE CASCADE,
ADD CONSTRAINT `order_items_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE SET NULL;

--
-- Constraints for table `products`
--
UPDATE `products` p
LEFT JOIN `categories` c ON p.`category_id` = c.`category_id`
SET
    p.`category_id` = NULL
WHERE
    p.`category_id` IS NOT NULL
    AND c.`category_id` IS NULL;

UPDATE `products` p
LEFT JOIN `brands` b ON p.`brand_id` = b.`brand_id`
SET
    p.`brand_id` = NULL
WHERE
    p.`brand_id` IS NOT NULL
    AND b.`brand_id` IS NULL;

ALTER TABLE `products`
ADD CONSTRAINT `products_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`category_id`) ON DELETE SET NULL,
ADD CONSTRAINT `products_ibfk_2` FOREIGN KEY (`brand_id`) REFERENCES `brands` (`brand_id`) ON DELETE SET NULL;

--
-- Constraints for table `reports`
--
UPDATE `reports` r
LEFT JOIN `users` u ON r.`admin_id` = u.`user_id`
SET
    r.`admin_id` = NULL
WHERE
    u.`user_id` IS NULL;

ALTER TABLE `reports`
ADD CONSTRAINT `reports_ibfk_1` FOREIGN KEY (`admin_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL;

--
-- Constraints for table `tech_part_products`
--
DELETE tpp
FROM
    `tech_part_products` tpp
    LEFT JOIN `products` p ON tpp.`product_id` = p.`product_id`
WHERE
    p.`product_id` IS NULL;

ALTER TABLE `tech_part_products`
ADD CONSTRAINT `tech_part_products_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE CASCADE;

--
-- Constraints for table `trending_products`
--
DELETE tp
FROM
    `trending_products` tp
    LEFT JOIN `products` p ON tp.`product_id` = p.`product_id`
WHERE
    p.`product_id` IS NULL;

ALTER TABLE `trending_products`
ADD CONSTRAINT `trending_products_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE CASCADE;

--
-- Constraints for table `user_profile`
--
DELETE up
FROM `user_profile` up
    LEFT JOIN `users` u ON up.`user_id` = u.`user_id`
WHERE
    u.`user_id` IS NULL;

ALTER TABLE `user_profile`
ADD CONSTRAINT `user_profile_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `wishlists`
--
DELETE w
FROM `wishlists` w
    LEFT JOIN `users` u ON w.`user_id` = u.`user_id`
WHERE
    u.`user_id` IS NULL;

DELETE w
FROM `wishlists` w
    LEFT JOIN `products` p ON w.`product_id` = p.`product_id`
WHERE
    p.`product_id` IS NULL;

ALTER TABLE `wishlists`
ADD CONSTRAINT `wishlists_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
ADD CONSTRAINT `wishlists_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE CASCADE;

SET FOREIGN_KEY_CHECKS = 1;

COMMIT;
