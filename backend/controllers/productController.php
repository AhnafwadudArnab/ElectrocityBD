<?php
require_once __DIR__ . '/../models/product.php';
require_once __DIR__ . '/../models/category.php';
require_once __DIR__ . '/../models/brands.php';

class ProductController {
    private $db;
    private $product;
    
    public function __construct($db) {
        $this->db = $db;
        $this->product = new Product($db);
    }
    
    public function getAll($data) {
        $limit = $data['limit'] ?? 100;
        $page = $data['page'] ?? 1;
        $offset = ($page - 1) * $limit;
        $category = $data['category'] ?? null;
        $brand = $data['brand'] ?? null;
        
        $products = $this->product->getAll($limit, $offset, $category, $brand);
        
        return ['products' => $products];
    }
    
    public function getById($id) {
        $product = $this->product->getById($id);
        
        if (!$product) {
            http_response_code(404);
            return ['message' => 'Product not found'];
        }
        
        return $product;
    }
    
    public function getBestSellers($data) {
        $limit = $data['limit'] ?? 10;
        $products = $this->product->getBestSellers($limit);
        return ['products' => $products];
    }
    
    public function getTrending($data) {
        $limit = $data['limit'] ?? 10;
        $products = $this->product->getTrending($limit);
        return ['products' => $products];
    }
    
    public function getDealsOfDay($data) {
        $limit = $data['limit'] ?? 10;
        $products = $this->product->getDealsOfDay($limit);
        return ['products' => $products];
    }
    
    public function getFlashSale($data) {
        $limit = $data['limit'] ?? 10;
        $products = $this->product->getFlashSale($limit);
        return ['products' => $products];
    }
    
    public function getTechPart($data) {
        $limit = $data['limit'] ?? 10;
        $products = $this->product->getTechPart($limit);
        return ['products' => $products];
    }
    
    public function search($data) {
        if (!isset($data['q']) || empty($data['q'])) {
            return [];
        }
        
        return $this->product->search($data['q']);
    }
    
    public function getCategories() {
        $category = new Category($this->db);
        return $category->getAll();
    }
    
    public function getBrands() {
        $brand = new Brand($this->db);
        return $brand->getAll();
    }
    
    public function create($data) {
        // Validate required fields
        $required = ['product_name', 'price', 'stock_quantity', 'category_id'];
        foreach ($required as $field) {
            if (!isset($data[$field])) {
                http_response_code(400);
                return ['message' => "Missing required field: $field"];
            }
        }
        
        // Validate price
        $price = (float)$data['price'];
        if ($price <= 0) {
            http_response_code(400);
            return ['message' => 'Price must be greater than 0'];
        }
        if ($price > 999999.99) {
            http_response_code(400);
            return ['message' => 'Price is too high'];
        }
        
        // Validate stock quantity
        $stock = (int)$data['stock_quantity'];
        if ($stock < 0) {
            http_response_code(400);
            return ['message' => 'Stock quantity cannot be negative'];
        }
        
        $this->product->category_id = isset($data['category_id']) ? (int)$data['category_id'] : null;
        $this->product->brand_id = isset($data['brand_id']) ? (int)$data['brand_id'] : null;
        $this->product->product_name = $data['product_name'];
        $this->product->description = $data['description'] ?? '';
        $this->product->price = $price;
        $this->product->stock_quantity = $stock;
        $this->product->image_url = $data['image_url'] ?? '';
        
        // Handle specs if provided
        if (isset($data['specs']) && is_array($data['specs'])) {
            $specs = json_encode($data['specs']);
        } else {
            $specs = null;
        }
        
        // Debug log
        error_log("Creating product: " . json_encode([
            'category_id' => $this->product->category_id,
            'brand_id' => $this->product->brand_id,
            'product_name' => $this->product->product_name,
            'price' => $this->product->price,
            'stock_quantity' => $this->product->stock_quantity,
            'image_url' => $this->product->image_url,
            'specs' => $specs
        ]));
        
        if ($this->product->create()) {
            http_response_code(201);
            return [
                'message' => 'Product created',
                'product_id' => (int)$this->product->product_id
            ];
        }
        
        // Return detailed error
        error_log("Failed to create product");
        http_response_code(500);
        return [
            'message' => 'Failed to create product',
            'error' => 'Database insertion failed',
            'data' => [
                'category_id' => $this->product->category_id,
                'brand_id' => $this->product->brand_id,
                'product_name' => $this->product->product_name,
                'price' => $this->product->price,
                'stock_quantity' => $this->product->stock_quantity,
                'image_url' => $this->product->image_url
            ]
        ];
    }
    
    public function update($id, $data) {
        $this->product->product_id = $id;
        $this->product->category_id = $data['category_id'] ?? null;
        $this->product->brand_id = $data['brand_id'] ?? null;
        $this->product->product_name = $data['product_name'] ?? '';
        $this->product->description = $data['description'] ?? '';
        $this->product->price = $data['price'] ?? 0;
        $this->product->stock_quantity = $data['stock_quantity'] ?? 0;
        $this->product->image_url = $data['image_url'] ?? '';
        
        if ($this->product->update()) {
            return ['message' => 'Product updated'];
        }
        
        http_response_code(500);
        return ['message' => 'Failed to update product'];
    }
    
    public function delete($id) {
        $this->product->product_id = $id;
        
        if ($this->product->delete()) {
            return ['message' => 'Product deleted'];
        }
        
        http_response_code(500);
        return ['message' => 'Failed to delete product'];
    }
}
