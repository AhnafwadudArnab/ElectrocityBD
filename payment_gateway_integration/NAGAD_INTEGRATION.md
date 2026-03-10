# Nagad Payment Gateway Integration Guide

## 📋 Prerequisites

1. Nagad Merchant Account
2. API Credentials:
   - Merchant ID
   - Public Key
   - Private Key
3. Sandbox credentials for testing

## 🔑 Get Credentials

### Contact Nagad:
- Email: merchant@nagad.com.bd
- Phone: 16167
- Website: https://nagad.com.bd/

### Required Documents:
- Trade License
- TIN Certificate
- Bank Account Details
- NID/Passport

## 🏗️ Architecture

```
User → Flutter App → Your Backend → Nagad API → Nagad Server
                ↓
            Database (Save transaction)
```

## 📝 Implementation Steps

### Step 1: Backend Setup

Add credentials to `backend/.env`:
```env
# Nagad Sandbox
NAGAD_MERCHANT_ID=your_merchant_id
NAGAD_PUBLIC_KEY=your_public_key
NAGAD_PRIVATE_KEY=your_private_key
NAGAD_BASE_URL=http://sandbox.mynagad.com:10080/remote-payment-gateway-1.0/api/dfs

# Nagad Production (when ready)
# NAGAD_MERCHANT_ID=your_production_merchant_id
# NAGAD_PUBLIC_KEY=your_production_public_key
# NAGAD_PRIVATE_KEY=your_production_private_key
# NAGAD_BASE_URL=https://api.mynagad.com/api/dfs
```

### Step 2: Database Table

```sql
CREATE TABLE IF NOT EXISTS nagad_transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    user_id INT NOT NULL,
    payment_ref_id VARCHAR(100) UNIQUE,
    merchant_order_id VARCHAR(100),
    amount DECIMAL(10,2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'BDT',
    status VARCHAR(50) DEFAULT 'pending',
    issuer_payment_ref_no VARCHAR(100),
    payment_date_time DATETIME NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_order_id (order_id),
    INDEX idx_user_id (user_id),
    INDEX idx_payment_ref_id (payment_ref_id),
    INDEX idx_status (status),
    
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

### Step 3: API Flow

#### 3.1 Initialize Payment
```
POST /check-out/initialize/{merchant_id}/{order_id}
Headers:
  - X-KM-Api-Version: v-0.2.0
  - X-KM-IP-V4: {client_ip}
  - X-KM-Client-Type: PC_WEB
Body:
  - dateTime: {timestamp}
  - sensitiveData: {encrypted_data}
  - signature: {signature}

Response:
  - sensitiveData: {encrypted_response}
  - signature: {signature}
```

#### 3.2 Complete Payment
```
POST /check-out/complete/{payment_ref_id}
Headers:
  - X-KM-Api-Version: v-0.2.0
  - X-KM-IP-V4: {client_ip}
  - X-KM-Client-Type: PC_WEB
Body:
  - paymentRefId: {payment_ref_id}
  - sensitiveData: {encrypted_data}
  - signature: {signature}

Response:
  - status: "Success"
  - issuerPaymentRefNo: {transaction_id}
```

#### 3.3 Verify Payment
```
GET /verify/payment/{payment_ref_id}
Headers:
  - X-KM-Api-Version: v-0.2.0
  - X-KM-IP-V4: {client_ip}
  - X-KM-Client-Type: PC_WEB

Response:
  - status: "Success"
  - amount: {amount}
  - issuerPaymentRefNo: {transaction_id}
```

### Step 4: Encryption

Nagad uses RSA encryption for sensitive data:

```php
// Encrypt data with Nagad public key
function encryptData($data, $publicKey) {
    openssl_public_encrypt($data, $encrypted, $publicKey);
    return base64_encode($encrypted);
}

// Decrypt data with your private key
function decryptData($data, $privateKey) {
    openssl_private_decrypt(base64_decode($data), $decrypted, $privateKey);
    return $decrypted;
}

// Generate signature
function generateSignature($data, $privateKey) {
    openssl_sign($data, $signature, $privateKey, OPENSSL_ALGO_SHA256);
    return base64_encode($signature);
}

// Verify signature
function verifySignature($data, $signature, $publicKey) {
    return openssl_verify($data, base64_decode($signature), $publicKey, OPENSSL_ALGO_SHA256);
}
```

## 🧪 Testing

### Test Credentials:
Contact Nagad for sandbox credentials

### Test Scenarios:
1. ✅ Successful payment
2. ❌ Failed payment
3. ⏱️ Timeout
4. 🔄 Callback handling
5. 🔍 Payment verification

## 📊 Transaction Flow

```
1. User clicks "Pay with Nagad"
2. Backend initializes payment → Get paymentRefId
3. User redirected to Nagad URL
4. User enters PIN in Nagad app
5. Nagad redirects to callback URL
6. Backend completes payment
7. Backend verifies payment status
8. Update order status
9. Show success/failure to user
```

## ⚠️ Important Notes

1. **Encryption:** All sensitive data must be encrypted
2. **Signature:** All requests must be signed
3. **Timestamp:** Use ISO 8601 format
4. **Order ID:** Must be unique for each transaction
5. **Amount:** Minimum 10 BDT
6. **Currency:** Only BDT supported
7. **IP Address:** Client IP required in headers

## 🔒 Security Best Practices

1. ✅ Store keys securely in .env file
2. ✅ Never expose keys in frontend
3. ✅ Validate callback requests
4. ✅ Verify payment status before confirming order
5. ✅ Log all transactions
6. ✅ Use HTTPS for callback URL
7. ✅ Implement rate limiting
8. ✅ Handle errors gracefully

## 🐛 Common Errors

### Error: Invalid Signature
```
Solution: Check private key and signature generation
```

### Error: Encryption Failed
```
Solution: Verify public key format
```

### Error: Payment Not Found
```
Solution: Check payment reference ID
```

## 📱 Mobile Number Format

```
Valid: 01XXXXXXXXX (11 digits)
Invalid: +8801XXXXXXXXX, 8801XXXXXXXXX
```

## 💡 Tips

1. Test encryption/decryption separately first
2. Keep transaction logs for debugging
3. Implement proper error handling
4. Show user-friendly error messages
5. Add loading indicators
6. Handle network timeouts
7. Implement retry mechanism

## 📞 Support

- Email: merchant@nagad.com.bd
- Phone: 16167
- Website: https://nagad.com.bd/

## ⏱️ Implementation Checklist

- [ ] Get merchant credentials
- [ ] Setup backend API
- [ ] Create database table
- [ ] Implement encryption/decryption
- [ ] Implement signature generation
- [ ] Implement initialize payment
- [ ] Implement complete payment
- [ ] Implement verify payment
- [ ] Create Flutter UI
- [ ] Test in sandbox
- [ ] Handle callbacks
- [ ] Verify payments
- [ ] Error handling
- [ ] Get production credentials
- [ ] Test in production
- [ ] Go live!

## 🔗 Useful Links

- Merchant Portal: https://merchant.nagad.com.bd/
- Documentation: Contact Nagad for API docs

Good luck with your Nagad integration! 🚀
