# bKash Payment Gateway Integration Guide

## 📋 Prerequisites

1. bKash Merchant Account
2. API Credentials:
   - Username
   - Password
   - App Key
   - App Secret
3. Sandbox credentials for testing

## 🔑 Get Credentials

### Sandbox (Testing):
1. Visit: https://developer.bka.sh/
2. Register for sandbox account
3. Get test credentials

### Production:
1. Visit: https://www.bkash.com/merchant
2. Apply for merchant account
3. Get production credentials after approval

## 🏗️ Architecture

```
User → Flutter App → Your Backend → bKash API → bKash Server
                ↓
            Database (Save transaction)
```

## 📝 Implementation Steps

### Step 1: Backend Setup

1. Create `backend/api/payments/bkash.php`
2. Add credentials to `backend/.env`:
```env
# bKash Sandbox
BKASH_USERNAME=sandboxTokenizedUser02
BKASH_PASSWORD=sandboxTokenizedUser02@12345
BKASH_APP_KEY=4f6o0cjiki2rfm34kfdadl1eqq
BKASH_APP_SECRET=2is7hdktrekvrbljjh44ll3d9l1dtjo4pasmjvs5vl5qr3fug4b
BKASH_BASE_URL=https://tokenized.sandbox.bka.sh/v1.2.0-beta

# bKash Production (when ready)
# BKASH_USERNAME=your_production_username
# BKASH_PASSWORD=your_production_password
# BKASH_APP_KEY=your_production_app_key
# BKASH_APP_SECRET=your_production_app_secret
# BKASH_BASE_URL=https://tokenized.pay.bka.sh/v1.2.0-beta
```

### Step 2: Database Table

```sql
CREATE TABLE IF NOT EXISTS bkash_transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    user_id INT NOT NULL,
    payment_id VARCHAR(100) UNIQUE,
    trx_id VARCHAR(100),
    amount DECIMAL(10,2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'BDT',
    intent VARCHAR(20) DEFAULT 'sale',
    merchant_invoice_number VARCHAR(100),
    status VARCHAR(50) DEFAULT 'pending',
    payment_execute_time DATETIME NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_order_id (order_id),
    INDEX idx_user_id (user_id),
    INDEX idx_payment_id (payment_id),
    INDEX idx_status (status),
    
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

### Step 3: API Flow

#### 3.1 Grant Token (Authentication)
```
POST /v1.2.0-beta/tokenized/checkout/token/grant
Headers:
  - username: {app_key}
  - password: {app_secret}
Body:
  - app_key: {app_key}
  - app_secret: {app_secret}

Response:
  - id_token: {token}
  - expires_in: 3600
```

#### 3.2 Create Payment
```
POST /v1.2.0-beta/tokenized/checkout/create
Headers:
  - Authorization: {id_token}
  - X-APP-Key: {app_key}
Body:
  - mode: "0011" (wallet payment)
  - payerReference: {customer_mobile}
  - callbackURL: {your_callback_url}
  - amount: {amount}
  - currency: "BDT"
  - intent: "sale"
  - merchantInvoiceNumber: {unique_invoice}

Response:
  - paymentID: {payment_id}
  - bkashURL: {redirect_url}
```

#### 3.3 Execute Payment
```
POST /v1.2.0-beta/tokenized/checkout/execute
Headers:
  - Authorization: {id_token}
  - X-APP-Key: {app_key}
Body:
  - paymentID: {payment_id}

Response:
  - paymentID: {payment_id}
  - trxID: {transaction_id}
  - transactionStatus: "Completed"
  - amount: {amount}
```

#### 3.4 Query Payment
```
POST /v1.2.0-beta/tokenized/checkout/payment/status
Headers:
  - Authorization: {id_token}
  - X-APP-Key: {app_key}
Body:
  - paymentID: {payment_id}

Response:
  - paymentID: {payment_id}
  - trxID: {transaction_id}
  - transactionStatus: "Completed"
```

### Step 4: Flutter Integration

1. Create payment page
2. Call backend API to create payment
3. Open bKash URL in WebView
4. Handle callback
5. Verify payment status
6. Update order status

## 🧪 Testing

### Test Credentials (Sandbox):
```
Username: sandboxTokenizedUser02
Password: sandboxTokenizedUser02@12345
App Key: 4f6o0cjiki2rfm34kfdadl1eqq
App Secret: 2is7hdktrekvrbljjh44ll3d9l1dtjo4pasmjvs5vl5qr3fug4b
Base URL: https://tokenized.sandbox.bka.sh/v1.2.0-beta
```

### Test Wallets:
```
Mobile: 01770618567
PIN: 12345
OTP: 123456
```

### Test Scenarios:
1. ✅ Successful payment
2. ❌ Failed payment
3. ⏱️ Timeout
4. 🔄 Callback handling
5. 🔍 Payment verification

## 📊 Transaction Flow

```
1. User clicks "Pay with bKash"
2. Backend creates payment → Get paymentID
3. User redirected to bKash URL
4. User enters PIN in bKash app
5. bKash redirects to callback URL
6. Backend executes payment
7. Backend verifies payment status
8. Update order status
9. Show success/failure to user
```

## ⚠️ Important Notes

1. **Token Expiry:** Grant token expires in 1 hour, refresh when needed
2. **Callback URL:** Must be publicly accessible (not localhost)
3. **Invoice Number:** Must be unique for each transaction
4. **Amount:** Minimum 1 BDT, maximum depends on merchant limit
5. **Currency:** Only BDT supported
6. **Mode:** "0011" for wallet payment, "0001" for tokenized payment

## 🔒 Security Best Practices

1. ✅ Store credentials in .env file
2. ✅ Never expose credentials in frontend
3. ✅ Validate callback requests
4. ✅ Verify payment status before confirming order
5. ✅ Log all transactions
6. ✅ Use HTTPS for callback URL
7. ✅ Implement rate limiting
8. ✅ Handle errors gracefully

## 🐛 Common Errors

### Error 2001: Invalid Credentials
```
Solution: Check app_key and app_secret
```

### Error 2002: Insufficient Balance
```
Solution: Use test wallet with sufficient balance
```

### Error 2003: Transaction Failed
```
Solution: Check transaction status and retry
```

### Error 2004: Duplicate Invoice
```
Solution: Use unique invoice number for each transaction
```

## 📱 Mobile Number Format

```
Valid: 01XXXXXXXXX (11 digits)
Invalid: +8801XXXXXXXXX, 8801XXXXXXXXX
```

## 💡 Tips

1. Always test in sandbox first
2. Keep transaction logs for debugging
3. Implement proper error handling
4. Show user-friendly error messages
5. Add loading indicators
6. Handle network timeouts
7. Implement retry mechanism

## 📞 Support

- Developer Portal: https://developer.bka.sh/
- Email: integration@bkash.com
- Phone: +880 1234567890

## 🔗 Useful Links

- API Documentation: https://developer.bka.sh/docs
- Sandbox Portal: https://developer.bka.sh/
- Merchant Portal: https://merchant.bkash.com/

## ⏱️ Implementation Checklist

- [ ] Get sandbox credentials
- [ ] Setup backend API
- [ ] Create database table
- [ ] Implement grant token
- [ ] Implement create payment
- [ ] Implement execute payment
- [ ] Implement query payment
- [ ] Create Flutter UI
- [ ] Test in sandbox
- [ ] Handle callbacks
- [ ] Verify payments
- [ ] Error handling
- [ ] Get production credentials
- [ ] Test in production
- [ ] Go live!

Good luck with your bKash integration! 🚀
