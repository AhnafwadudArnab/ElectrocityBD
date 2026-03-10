<?php
/**
 * Environment Configuration Loader
 * Loads environment variables from .env file
 */

class Env {
    private static $loaded = false;
    private static $vars = [];

    /**
     * Load environment variables from .env file
     */
    public static function load($path = null) {
        if (self::$loaded) {
            return;
        }

        if ($path === null) {
            $path = __DIR__ . '/../../.env';
        }

        if (!file_exists($path)) {
            // Try .env.example as fallback for development
            $examplePath = __DIR__ . '/../../.env.example';
            if (file_exists($examplePath)) {
                error_log("Warning: .env file not found. Using .env.example. Create .env file for production!");
                $path = $examplePath;
            } else {
                throw new Exception('.env file not found. Copy .env.example to .env and configure it.');
            }
        }

        $lines = file($path, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
        foreach ($lines as $line) {
            // Skip comments
            if (strpos(trim($line), '#') === 0) {
                continue;
            }

            // Parse KEY=VALUE
            if (strpos($line, '=') !== false) {
                list($key, $value) = explode('=', $line, 2);
                $key = trim($key);
                $value = trim($value);

                // Remove quotes if present
                if (preg_match('/^(["\'])(.*)\\1$/', $value, $matches)) {
                    $value = $matches[2];
                }

                self::$vars[$key] = $value;
                
                // Also set as environment variable
                if (!getenv($key)) {
                    putenv("$key=$value");
                }
            }
        }

        self::$loaded = true;
    }

    /**
     * Get environment variable
     * @param string $key Variable name
     * @param mixed $default Default value if not found
     * @return mixed
     */
    public static function get($key, $default = null) {
        if (!self::$loaded) {
            self::load();
        }

        if (isset(self::$vars[$key])) {
            return self::$vars[$key];
        }

        $value = getenv($key);
        if ($value !== false) {
            return $value;
        }

        return $default;
    }

    /**
     * Check if environment variable exists
     */
    public static function has($key) {
        if (!self::$loaded) {
            self::load();
        }
        return isset(self::$vars[$key]) || getenv($key) !== false;
    }

    /**
     * Get all environment variables
     */
    public static function all() {
        if (!self::$loaded) {
            self::load();
        }
        return self::$vars;
    }
}

// Auto-load on include
Env::load();
?>
