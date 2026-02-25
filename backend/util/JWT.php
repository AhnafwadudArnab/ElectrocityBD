<?php
class JWT {
    private static $secret_key = 'ElectrocityBD_Secret_Key_2024';
    private static $algorithm = 'HS256';
    
    public static function generate($data) {
        $header = json_encode(['typ' => 'JWT', 'alg' => self::$algorithm]);
        $payload = json_encode($data);
        
        $base64UrlHeader = str_replace(['+', '/', '='], ['-', '_', ''], base64_encode($header));
        $base64UrlPayload = str_replace(['+', '/', '='], ['-', '_', ''], base64_encode($payload));
        
        $signature = hash_hmac('sha256', $base64UrlHeader . "." . $base64UrlPayload, self::$secret_key, true);
        $base64UrlSignature = str_replace(['+', '/', '='], ['-', '_', ''], base64_encode($signature));
        
        return $base64UrlHeader . "." . $base64UrlPayload . "." . $base64UrlSignature;
    }
    
    public static function verify($token) {
        $parts = explode('.', $token);
        if (count($parts) != 3) return false;
        
        $header = $parts[0];
        $payload = $parts[1];
        $signature = $parts[2];
        
        $base64UrlHeader = str_replace(['-', '_'], ['+', '/'], $header);
        $base64UrlPayload = str_replace(['-', '_'], ['+', '/'], $payload);
        $base64UrlSignature = str_replace(['-', '_'], ['+', '/'], $signature);
        
        $signature_check = hash_hmac('sha256', $header . "." . $payload, self::$secret_key, true);
        $base64UrlSignature_check = str_replace(['+', '/', '='], ['-', '_', ''], base64_encode($signature_check));
        
        if ($base64UrlSignature_check !== $signature) return false;
        
        $payload_data = json_decode(base64_decode($base64UrlPayload), true);
        if (isset($payload_data['exp']) && $payload_data['exp'] < time()) return false;
        
        return $payload_data;
    }
}
?>