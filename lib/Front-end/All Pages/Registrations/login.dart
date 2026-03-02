import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../API/api_service.dart';
import '../../Admin Panel/A_customers.dart';
import '../../Dimensions/responsive_dimensions.dart';
import '../../pages/home_page.dart';
import '../../utils/auth_session.dart';
import '../CART/Cart_provider.dart';
import 'forgot_password.dart';
import 'signup.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;

  static const String _logoPath = 'assets/logo_electrocity.png';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Regular user login with API
  Future<void> _onLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      // Call the login API
      final result = await ApiService.login(email: email, password: password);

      if (!mounted) return;

      // Check if response contains token and user
      if (result['token'] == null || result['user'] == null) {
        throw ApiException('Invalid email or password.', 401);
      }

      final token = (result['token'] ?? '').toString();
      final userMap = result['user'] as Map<String, dynamic>?;

      if (token.isEmpty || userMap == null) {
        throw ApiException('Invalid email or password.', 401);
      }

      // Get user role
      final role = (userMap['role'] ?? 'customer').toString();

      // Create UserData object from response
      final userData = UserData(
        firstName: userMap['firstName'] ?? userMap['full_name'] ?? 'User',
        lastName: userMap['lastName'] ?? userMap['last_name'] ?? '',
        email: userMap['email'] ?? '',
        phone: userMap['phone'] ?? userMap['phone_number'] ?? '',
        gender: userMap['gender'] ?? 'Male',
      );

      // Save user data to session
      await AuthSession.saveUserData(userData);
      await AuthSession.saveToken(token);
      await AuthSession.setAdmin(role == 'admin');
      await AuthSession.setLoggedIn(true);

      // Try to get full profile
      try {
        final profile = await ApiService.getProfile();
        final fullUser = UserData(
          firstName:
              profile['firstName'] ??
              profile['full_name'] ??
              userData.firstName,
          lastName:
              profile['lastName'] ?? profile['last_name'] ?? userData.lastName,
          email: profile['email'] ?? userData.email,
          phone: profile['phone'] ?? profile['phone_number'] ?? userData.phone,
          gender: profile['gender'] ?? userData.gender,
        );
        await AuthSession.updateUserData(fullUser);
      } catch (_) {
        // Profile fetch failed, but that's ok
      }

      // Set user ID in cart provider
      await context.read<CartProvider>().setCurrentUserId(
        userData.email,
        mergeFromGuest: true,
      );

      if (!mounted) return;

      // Initialize cart
      await context.read<CartProvider>().init();

      if (!mounted) return;

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            role == 'admin' ? 'Admin login successful!' : 'Login successful!',
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.white,
        ),
      );

      // Navigate based on role
      if (role == 'admin') {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const AdminLayoutPage()),
          (route) => false,
        );
      } else {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const HomePage()),
          (route) => false,
        );
      }
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Server connection failed. Please check if backend is running at http://localhost:8000',
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // Admin login with dedicated admin API
  Future<void> _onAdminLogin() async {
    final username = _emailController.text.trim();
    final password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter admin username and password'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Call the admin login API
      final result = await ApiService.adminLogin(
        username: username,
        password: password,
      );

      if (!mounted) return;

      final userMap = result['user'] as Map<String, dynamic>?;

      if (userMap != null) {
        final userData = UserData(
          firstName: userMap['firstName'] ?? userMap['full_name'] ?? 'Admin',
          lastName: userMap['lastName'] ?? userMap['last_name'] ?? '',
          email: userMap['email'] ?? username,
          phone: userMap['phone'] ?? userMap['phone_number'] ?? '',
          gender: userMap['gender'] ?? 'Male',
        );
        await AuthSession.saveUserData(userData);
      }

      // Save token if provided
      if (result['token'] != null) {
        await AuthSession.saveToken(result['token'].toString());
      }

      await AuthSession.setAdmin(true);
      await AuthSession.setLoggedIn(true);

      if (!mounted) return;

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Admin login successful!'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.white,
        ),
      );

      // Navigate to admin panel
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const AdminLayoutPage()),
        (route) => false,
      );
    } on ApiException catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Server connection failed. Start PHP backend: php -S localhost:8000 -t backend/public',
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 5),
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final r = AppResponsive.of(context);
    final isCompact = r.isSmallMobile || r.isMobile;
    final isStackedLayout = isCompact || r.isTablet;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFFD54F), Color(0xFF64B5F6)],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Center(
                    child: Container(
                      margin: EdgeInsets.all(AppDimensions.padding(context)),
                      constraints: BoxConstraints(
                        maxWidth: r.value(
                          smallMobile: 360,
                          mobile: 430,
                          tablet: 550,
                          smallDesktop: 1040,
                          desktop: 1220,
                        ),
                        maxHeight: isStackedLayout ? double.infinity : r.hp(75),
                      ),
                      child: Card(
                        elevation: 10,
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppDimensions.borderRadius(context) + 6,
                          ),
                        ),
                        child: isStackedLayout
                            ? _buildStackedLayout(r)
                            : _buildDesktopLayout(),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        Expanded(flex: 2, child: _buildLeftPanel(showText: true)),
        Expanded(flex: 3, child: _buildRightPanel()),
      ],
    );
  }

  Widget _buildStackedLayout(AppResponsive r) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 150,
          width: double.infinity,
          child: _buildLeftPanel(showText: false),
        ),
        _buildRightPanel(),
      ],
    );
  }

  Widget _buildLeftPanel({required bool showText}) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1E40AF), Color(0xFFFBBF24)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.padding(context)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: Center(
                child: Image.asset(
                  _logoPath,
                  width: double.infinity,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.flash_on, color: Colors.white, size: 80),
                ),
              ),
            ),
            // if (showText) ...[
            //   Container(
            //     width: double.infinity,
            //     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            //     decoration: BoxDecoration(
            //       border: Border.all(color: Colors.white, width: 3),
            //       borderRadius: BorderRadius.circular(8),
            //     ),
            //     child: Text(
            //       'Welcome back to\nElectrocity-BD',
            //       textAlign: TextAlign.center,
            //       style: TextStyle(
            //         color: Colors.white,
            //         fontSize: AppDimensions.titleFont(context) * 0.85,
            //         fontWeight: FontWeight.bold,
            //       ),
            //     ),
            //   ),
            // ],
          ],
        ),
      ),
    );
  }

  Widget _buildRightPanel() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(AppDimensions.padding(context)),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Text(
                'LOG IN',
                style: TextStyle(
                  fontSize: AppDimensions.titleFont(context),
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF4A3AFF),
                ),
              ),
            ),
            SizedBox(height: AppDimensions.padding(context)),
            _buildInputField(
              'Email Address or Admin Username',
              controller: _emailController,
              keyboardType: TextInputType.text,
              validator: (v) => (v == null || v.isEmpty)
                  ? 'Enter email or admin username'
                  : null,
            ),
            _buildInputField(
              'Password',
              controller: _passwordController,
              isPassword: true,
              obscureText: _obscurePassword,
              onTogglePassword: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
              validator: (v) =>
                  (v == null || v.length < 4) ? 'Min 4 characters' : null,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ForgotPasswordPage()),
                  );
                },
                child: const Text(
                  'Forgot Password?',
                  style: TextStyle(
                    color: Color(0xFF4A3AFF),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: AppDimensions.buttonHeight(context),
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _onLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFA6E4FF),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppDimensions.borderRadius(context),
                          ),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Login',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SizedBox(
                    height: AppDimensions.buttonHeight(context),
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _onAdminLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppDimensions.borderRadius(context),
                          ),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Admin Login',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                ),
              ],
            ),
            Center(
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  const Text(
                    'Don\'t have an account? ',
                    style: TextStyle(color: Colors.grey),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const Signup()),
                      );
                    },
                    child: const Text('Sign Up'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(
    String label, {
    required TextEditingController controller,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onTogglePassword,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppDimensions.padding(context) * 0.8),
      child: SizedBox(
        height: 60,
        child: TextFormField(
          controller: controller,
          obscureText: isPassword ? obscureText : false,
          keyboardType: keyboardType,
          validator: validator,
          style: const TextStyle(fontSize: 18),
          decoration: InputDecoration(
            labelText: label,
            isDense: false,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                AppDimensions.borderRadius(context),
              ),
            ),
            suffixIcon: isPassword
                ? IconButton(
                    onPressed: onTogglePassword,
                    icon: Icon(
                      obscureText ? Icons.visibility_off : Icons.visibility,
                      size: 24,
                    ),
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
