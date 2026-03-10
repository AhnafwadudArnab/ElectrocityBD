# Testing Guide - ElectroCityBD

## 🎯 Testing Strategy

### Testing Levels:
1. **Unit Testing** - Individual functions
2. **Integration Testing** - API endpoints
3. **UI Testing** - User interface
4. **End-to-End Testing** - Complete user flows
5. **Performance Testing** - Load and stress testing

---

## 📋 Test Checklist

### 1. Authentication & Authorization

#### Registration:
- [ ] Valid email registration
- [ ] Duplicate email rejected
- [ ] Invalid email format rejected
- [ ] Weak password rejected
- [ ] Password confirmation mismatch
- [ ] Required fields validation
- [ ] Success message displayed
- [ ] Auto-login after registration

**Test Cases:**
```
Test 1: Valid Registration
Input: email=test@test.com, password=Test123!@#, name=Test User
Expected: Success, user created, auto-login

Test 2: Duplicate Email
Input: email=existing@test.com
Expected: Error "Email already exists"

Test 3: Invalid Email
Input: email=invalid-email
Expected: Error "Invalid email format"

Test 4: Weak Password
Input: password=123
Expected: Error "Password too weak"
```

#### Login:
- [ ] Valid credentials login
- [ ] Invalid email rejected
- [ ] Wrong password rejected
- [ ] Empty fields validation
- [ ] JWT token generated
- [ ] Token stored locally
- [ ] Redirect to home page

**Test Cases:**
```
Test 1: Valid Login
Input: email=test@test.com, password=Test123!@#
Expected: Success, JWT token, redirect to home

Test 2: Wrong Password
Input: email=test@test.com, password=wrong
Expected: Error "Invalid credentials"

Test 3: Non-existent Email
Input: email=notfound@test.com
Expected: Error "User not found"
```

#### Logout:
- [ ] Token cleared
- [ ] Redirect to login
- [ ] Cannot access protected routes

---

### 2. Product Management

#### Product Listing:
- [ ] All products displayed
- [ ] Images loaded correctly
- [ ] Prices displayed correctly
- [ ] Stock status shown
- [ ] Pagination working
- [ ] Search working
- [ ] Filter by category
- [ ] Filter by brand
- [ ] Sort by price
- [ ] Sort by name

**Test Cases:**
```
Test 1: Load Products
Expected: Products list displayed, images loaded

Test 2: Search Products
Input: search="fan"
Expected: Only fan products shown

Test 3: Filter by Category
Input: category="Electronics"
Expected: Only electronics shown

Test 4: Sort by Price
Input: sort="price_asc"
Expected: Products sorted low to high
```

#### Product Details:
- [ ] Product info displayed
- [ ] Images gallery working
- [ ] Add to cart button
- [ ] Buy now button
- [ ] Stock status
- [ ] Related products

#### Add Product (Admin):
- [ ] Form validation
- [ ] Image upload
- [ ] Product created
- [ ] Success message
- [ ] Redirect to products list

**Test Cases:**
```
Test 1: Add Valid Product
Input: name="Test Fan", price=1000, stock=10, image=file
Expected: Product created, success message

Test 2: Missing Required Fields
Input: name="", price=1000
Expected: Error "Name required"

Test 3: Invalid Price
Input: price=-100
Expected: Error "Invalid price"

Test 4: Large Image
Input: image=10MB file
Expected: Error "File too large"
```

---

### 3. Shopping Cart

#### Add to Cart:
- [ ] Product added
- [ ] Quantity updated
- [ ] Cart count updated
- [ ] Success message
- [ ] Duplicate product handling

**Test Cases:**
```
Test 1: Add New Product
Input: product_id=1, quantity=1
Expected: Product added, cart count +1

Test 2: Add Existing Product
Input: product_id=1, quantity=2
Expected: Quantity updated to 3

Test 3: Add Out of Stock
Input: product_id=999 (out of stock)
Expected: Error "Out of stock"
```

#### Update Cart:
- [ ] Quantity increase
- [ ] Quantity decrease
- [ ] Remove item
- [ ] Total price updated
- [ ] Empty cart handling

#### Checkout:
- [ ] Shipping address form
- [ ] Payment method selection
- [ ] Order summary
- [ ] Total calculation
- [ ] Place order button

---

### 4. Order Management

#### Place Order:
- [ ] Order created
- [ ] Stock decreased
- [ ] Cart cleared
- [ ] Order confirmation
- [ ] Email notification (if implemented)

**Test Cases:**
```
Test 1: Valid Order
Input: cart with 2 items, shipping address, payment method
Expected: Order created, stock updated, cart cleared

Test 2: Insufficient Stock
Input: quantity > available stock
Expected: Error "Insufficient stock"

Test 3: Empty Cart
Input: empty cart
Expected: Error "Cart is empty"
```

#### Order History:
- [ ] User's orders displayed
- [ ] Order details
- [ ] Order status
- [ ] Track order
- [ ] Cancel order (if pending)

#### Admin Order Management:
- [ ] All orders displayed
- [ ] Filter by status
- [ ] Update order status
- [ ] View order details
- [ ] Print invoice

---

### 5. Admin Features

#### Dashboard:
- [ ] Total sales displayed
- [ ] Total orders count
- [ ] Total products count
- [ ] Total users count
- [ ] Recent orders
- [ ] Charts/graphs

#### Product Management:
- [ ] Create product
- [ ] Edit product
- [ ] Delete product
- [ ] Bulk actions
- [ ] Image upload
- [ ] Category assignment

#### Promotions:
- [ ] Create promotion
- [ ] Edit promotion
- [ ] Delete promotion
- [ ] Date/time picker
- [ ] Discount percentage
- [ ] Active/inactive toggle
- [ ] Countdown timer

#### Flash Sales:
- [ ] Create flash sale
- [ ] Edit flash sale
- [ ] Delete flash sale
- [ ] Start/end time
- [ ] Active/inactive toggle
- [ ] Product assignment

#### Featured Brands:
- [ ] Add brand logo
- [ ] Edit brand logo
- [ ] Delete brand logo
- [ ] Reorder brands
- [ ] Mid-banners
- [ ] Offers section

---

### 6. Notifications

#### Local Notifications:
- [ ] Enable/disable toggle
- [ ] Show notification
- [ ] Notification tap handling
- [ ] Order notifications
- [ ] Promotion notifications
- [ ] Flash sale notifications

**Test Cases:**
```
Test 1: Enable Notifications
Expected: Notifications enabled, permission granted

Test 2: Show Notification
Input: title="Test", body="Test message"
Expected: Notification displayed

Test 3: Tap Notification
Expected: Navigate to relevant page
```

---

### 7. Multi-language

#### Language Switching:
- [ ] English selected
- [ ] Bengali selected
- [ ] UI text updated
- [ ] Preference saved
- [ ] Persistent across restarts

**Test Cases:**
```
Test 1: Switch to Bengali
Expected: All UI text in Bengali

Test 2: Switch to English
Expected: All UI text in English

Test 3: Restart App
Expected: Last selected language loaded
```

---

### 8. Settings

#### Admin Settings:
- [ ] Profile view
- [ ] Change password
- [ ] Email notifications toggle
- [ ] Push notifications toggle
- [ ] Language selection
- [ ] About dialog
- [ ] Logout

---

## 🧪 Manual Testing Procedure

### Day 1: User Flow Testing

**Morning (2-3 hours):**
1. Registration → Login → Browse Products
2. Search Products → View Details → Add to Cart
3. Update Cart → Checkout → Place Order
4. View Order History → Track Order

**Afternoon (2-3 hours):**
1. Test all filters and sorting
2. Test pagination
3. Test image loading
4. Test error scenarios

### Day 2: Admin Flow Testing

**Morning (2-3 hours):**
1. Admin Login → Dashboard
2. Create Product → Edit → Delete
3. Manage Orders → Update Status
4. Create Promotion → Edit → Delete

**Afternoon (2-3 hours):**
1. Create Flash Sale → Edit → Delete
2. Manage Featured Brands
3. Test Settings
4. Test Notifications

### Day 3: Edge Cases & Error Handling

**Morning (2-3 hours):**
1. Network errors (airplane mode)
2. Invalid inputs
3. Empty states
4. Loading states
5. Timeout scenarios

**Afternoon (2-3 hours):**
1. Large data sets
2. Slow network
3. Concurrent users
4. Session expiry

### Day 4: Cross-device Testing

**Morning (2-3 hours):**
1. Test on different Android versions
2. Test on different screen sizes
3. Test on tablets

**Afternoon (2-3 hours):**
1. Test on iOS (if applicable)
2. Test on web (if applicable)
3. Test on different browsers

### Day 5: Performance & Security

**Morning (2-3 hours):**
1. Load testing (many products)
2. Stress testing (many users)
3. Memory leaks
4. Battery usage

**Afternoon (2-3 hours):**
1. Security audit
2. SQL injection attempts
3. XSS attempts
4. Authentication bypass attempts

---

## 🔧 Testing Tools

### Backend Testing:
```bash
# Test API endpoints with curl

# Health check
curl https://yourdomain.com/api/health

# Login
curl -X POST https://yourdomain.com/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@test.com","password":"Test123!@#"}'

# Get products
curl https://yourdomain.com/api/products

# Get products with auth
curl https://yourdomain.com/api/products \
  -H "Authorization: Bearer YOUR_TOKEN"
```

### Database Testing:
```sql
-- Check data integrity
SELECT COUNT(*) FROM users;
SELECT COUNT(*) FROM products;
SELECT COUNT(*) FROM orders;

-- Check for orphaned records
SELECT * FROM order_items WHERE order_id NOT IN (SELECT order_id FROM orders);

-- Check stock consistency
SELECT p.product_id, p.product_name, p.stock_quantity, 
       COALESCE(SUM(oi.quantity), 0) as ordered
FROM products p
LEFT JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_id;
```

### Flutter Testing:
```bash
# Run tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test
flutter test test/widget_test.dart
```

---

## 📊 Test Report Template

```markdown
# Test Report - [Date]

## Summary
- Total Tests: X
- Passed: Y
- Failed: Z
- Skipped: W

## Failed Tests
1. Test Name: [Name]
   - Expected: [Expected result]
   - Actual: [Actual result]
   - Steps to Reproduce: [Steps]
   - Screenshot: [Link]

## Performance Issues
1. Issue: [Description]
   - Impact: [High/Medium/Low]
   - Solution: [Proposed fix]

## Security Issues
1. Issue: [Description]
   - Severity: [Critical/High/Medium/Low]
   - Solution: [Proposed fix]

## Recommendations
- [Recommendation 1]
- [Recommendation 2]
```

---

## 🐛 Bug Tracking

### Bug Report Template:
```markdown
**Title:** [Short description]

**Priority:** Critical / High / Medium / Low

**Description:**
[Detailed description of the bug]

**Steps to Reproduce:**
1. Step 1
2. Step 2
3. Step 3

**Expected Result:**
[What should happen]

**Actual Result:**
[What actually happened]

**Screenshots:**
[Attach screenshots]

**Environment:**
- Device: [Device name]
- OS: [Android/iOS version]
- App Version: [Version]

**Additional Notes:**
[Any other relevant information]
```

---

## ✅ Pre-Launch Checklist

### Functionality:
- [ ] All user flows working
- [ ] All admin features working
- [ ] No critical bugs
- [ ] Error handling working
- [ ] Loading states working

### Performance:
- [ ] App loads quickly
- [ ] Images load fast
- [ ] No memory leaks
- [ ] Smooth scrolling
- [ ] No crashes

### Security:
- [ ] Authentication working
- [ ] Authorization working
- [ ] Input validation
- [ ] SQL injection protected
- [ ] XSS protected

### UI/UX:
- [ ] Responsive design
- [ ] Consistent styling
- [ ] User-friendly messages
- [ ] Proper navigation
- [ ] Accessibility

### Data:
- [ ] Database backed up
- [ ] Test data removed
- [ ] Production data ready
- [ ] Data integrity verified

---

## ⏱️ Estimated Testing Time

- **Manual Testing:** 5 days (8 hours/day) = 40 hours
- **Bug Fixing:** 3-5 days
- **Regression Testing:** 2 days
- **Final Verification:** 1 day

**Total: 2 weeks**

---

## 📞 Need Help?

যদি testing এ কোনো সমস্যা হয়:
1. Bug report তৈরী করুন
2. Screenshots attach করুন
3. Steps to reproduce লিখুন
4. আমাকে জানান

Good luck with testing! 🧪
