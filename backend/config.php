<?php
return [
    'db' => [
        'host' => getenv('DB_HOST') ?: getenv('ECITY_DB_HOST') ?: '127.0.0.1',
        'port' => getenv('DB_PORT') ?: getenv('ECITY_DB_PORT') ?: '3306',
        'name' => getenv('DB_NAME') ?: getenv('ECITY_DB_NAME') ?: 'electrocity_db',
        'user' => getenv('DB_USER') ?: getenv('ECITY_DB_USER') ?: 'root',
        'pass' => getenv('DB_PASSWORD') ?: getenv('ECITY_DB_PASS') ?: '',
        'charset' => 'utf8mb4',
    ],
    'auth' => [
        'jwt_secret' => getenv('JWT_SECRET') ?: getenv('ECITY_JWT_SECRET') ?: 'ElectrocityBD_Secret_Key_2024',
        'jwt_issuer' => 'electrocitybd',
        'jwt_ttl_seconds' => 60 * 60 * 24,
    ],
    'uploads' => [
        'dir' => __DIR__ . '/public/uploads',
        'base_path' => '/uploads',
        'max_size_bytes' => 5 * 1024 * 1024,
        'allowed_exts' => ['jpg','jpeg','png','webp'],
    ],
];
