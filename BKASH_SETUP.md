# bKash Payment Gateway Setup Guide

## Overview
Your ElectrocityBD website now has integrated bKash payment gateway for secure online payments. The integration uses the official `flutter_bkash` package (v0.3.1).

## Current Status
✅ **SANDBOX MODE ACTIVE** - Currently configured with bKash sandbox/test credentials for development and testing.

## Features Implemented
- ✅ Direct bKash payment integration
- ✅ Real-time payment processing
- ✅ Transaction ID generation
- ✅ Payment success/failure handling
- ✅ Secure payment flow with bKash native interface
- ✅ Order completion with transaction tracking

## Testing the Integration

### Sandbox Credentials (Currently Active)
The application is configured with bKash sandbox credentials:
- **Username**: sandboxTokenizedUser02
- **Password**: sandboxTokenizedUser02@12345
- **App Key**: 4f6o0cjiki2rfm34kfdadl1eqq
- **App Secret**: 2is7hdktrekvrbljjh44ll3d9l1dtjo4pasmjvs5vl5qr3fug4b
- **Mode**: Sandbox (isSandbox: true)

### How to Test
1. Run the application on a real Android device or emulator
2. Add products to cart and proceed to checkout
3. Login if not already logged in
4. Select "bKash" payment method
5. The bKash payment interface will open
6. Use bKash sandbox test credentials to complete the payment (provided by bKash)
7. Upon successful payment, you'll receive a transaction ID

## Production Setup

### Prerequisites
Before going live, you need:
1. **bKash Merchant Account** - Register at [https://www.bkash.com/](https://www.bkash.com/)
2. **Production Credentials** - Obtain from bKash during merchant on-boarding:
   - Username
   - Password
   - App Key (Application Key)
   - App Secret (Application Secret)

### Configuration Steps

1. **Update Payment Credentials**
   
   Open: `lib/All Pages/CART/Payment_methods.dart`
   
   Find the `initState()` method (around line 27) and replace the sandbox credentials:

   ```dart
   @override
   void initState() {
     super.initState();
     flutterBkash = FlutterBkash(
       bkashCredentials: const BkashCredentials(
         username: "YOUR_PRODUCTION_USERNAME",      // Replace with your merchant username
         password: "YOUR_PRODUCTION_PASSWORD",      // Replace with your merchant password
         appKey: "YOUR_PRODUCTION_APP_KEY",         // Replace with your app key
         appSecret: "YOUR_PRODUCTION_APP_SECRET",   // Replace with your app secret
         isSandbox: false,                          // IMPORTANT: Set to false for production
       ),
       logResponse: false,                          // Set to false in production for security
     );
   }
   ```

2. **Security Best Practices**
   
   ⚠️ **IMPORTANT**: Never commit production credentials to version control!
   
   Consider using environment variables or secure configuration:
   - Use Flutter's `--dart-define` for runtime configuration
   - Store credentials in secure backend and fetch at runtime
   - Use Firebase Remote Config or similar services

3. **Testing Before Going Live**
   - Test all payment scenarios with sandbox first
   - Verify transaction success flows
   - Test payment failure handling
   - Verify order completion process
   - Test on multiple devices

4. **Android Configuration**
   The Android manifest has been updated with required permissions:
   - `INTERNET` permission for API calls (already added)

5. **iOS Configuration** (if deploying to iOS)
   No additional configuration needed for bKash, but ensure:
   - Your app supports HTTPS (bKash uses secure connections)
   - Update `Info.plist` if needed for network permissions

## Payment Flow

1. **User adds products to cart** → Total amount calculated
2. **User proceeds to checkout** → Login required
3. **User selects bKash** → Payment initiated
4. **bKash interface opens** → User enters bKash PIN
5. **Payment processed** → Transaction ID generated
6. **Order completed** → User redirected to order confirmation

## Transaction Details Captured
- Transaction ID (trxId)
- Payment Amount
- Customer MSISDN (phone number)
- Merchant Invoice Number
- Payment Execution Time
- Payer Reference

## Error Handling
The integration handles:
- ✅ Payment cancellation by user
- ✅ Insufficient balance
- ✅ Network errors
- ✅ Invalid credentials
- ✅ Transaction failures

All errors are shown to users with user-friendly messages.

## Support & Resources

### bKash Documentation
- [bKash Merchant Portal](https://merchant.bkash.com/)
- [API Documentation](https://developer.bkash.com/)

### Package Documentation
- [flutter_bkash on pub.dev](https://pub.dev/packages/flutter_bkash)

### Need Help?
If you encounter issues:
1. Verify your bKash merchant credentials
2. Check internet connectivity
3. Ensure you're using production credentials in production
4. Review bKash transaction logs in merchant portal
5. Contact bKash merchant support: 16247

## Checklist Before Going Live

- [ ] Obtained production credentials from bKash
- [ ] Updated credentials in Payment_methods.dart
- [ ] Set `isSandbox: false`
- [ ] Set `logResponse: false`
- [ ] Tested all payment scenarios
- [ ] Secured credentials (not in version control)
- [ ] Updated app permissions if needed
- [ ] Tested on real devices
- [ ] Reviewed transaction flow
- [ ] Set up proper error logging

## Version Info
- **flutter_bkash**: ^0.3.1
- **Implementation Date**: February 2026
- **Integration Type**: Tokenized Payment (without agreement)

---

**Note**: This integration uses bKash's tokenized payment API without agreement. For recurring payments or saved payment methods, consider implementing the agreement-based payment flow.
