<?php
require_once __DIR__ . '/../models/Product.php';
require_once __DIR__ . '/../models/Category.php';
require_once __DIR__ . '/../models/Brand.php';

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
        
        return $products;
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
        return $this->product->getBestSellers($limit);
    }
    
    public function getTrending($data) {
        $limit = $data['limit'] ?? 10;
        return $this->product->getTrending($limit);
    }
    
    public function getDealsOfDay($data) {
        $limit = $data['limit'] ?? 10;
        return $this->product->getDealsOfDay($limit);
    }
    
    public function getFlashSale($data) {
        $limit = $data['limit'] ?? 10;
        return $this->product->getFlashSale($limit);
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
        $required = ['product_name', 'price', 'stock_quantity'];
        foreach ($required as $field) {
            if (!isset($data[$field])) {
                http_response_code(400);
                return ['message' => "Missing field: $field"];
            }
        }
        
        $this->product->category_id = $data['category_id'] ?? null;
        $this->product->brand_id = $data['brand_id'] ?? null;
        $this->product->product_name = $data['product_name'];
        $this->product->description = $data['description'] ?? '';
        $this->product->price = $data['price'];
        $this->product->stock_quantity = $data['stock_quantity'];
        $this->product->image_url = $data['image_url'] ?? '';
        
        if ($this->product->create()) {
            http_response_code(201);
            return [
                'message' => 'Product created',
                'product_id' => $this->product->product_id
            ];
        }
        
        http_response_code(500);
        return ['message' => 'Failed to create product'];
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
?>