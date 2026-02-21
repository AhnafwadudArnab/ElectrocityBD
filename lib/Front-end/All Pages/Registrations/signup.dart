import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Dimensions/responsive_dimensions.dart';
import 'login.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  static const String _logoPath = 'assets/logo_electrocity.png';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _onSignup() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1500));

    if (!mounted) return;
    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Account created successfully!'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.white,
      ),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LogIn()),
    );
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
                        maxHeight: isStackedLayout ? double.infinity : r.hp(85),
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
          // For Mobile & Tablet: Only showing icon, so keep the height short
          height: 150,
          width: double.infinity,
          child: _buildLeftPanel(
            showText: false,
          ), // Hide text for Tablet/Mobile
        ),
        _buildRightPanel(),
      ],
    );
  }

  Widget _buildLeftPanel({required bool showText}) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF1E40AF),
            Color(0xFFFBBF24),
          ],
          end: Alignment.bottomRight,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.padding(context)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: showText
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.center,
          children: [
            Image.asset(
              _logoPath,
              height: showText ? 80 : 75,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.bolt, color: Colors.white, size: 50),
            ),
            if (showText) ...[
              const SizedBox(height: 20),
              Text(
                'Get all your buying\nproblems solved today',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: AppDimensions.titleFont(context) * 0.9,
                  fontWeight: FontWeight.bold,
                ),
              ),
             
            ],
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
                'Register Your Account',
                style: TextStyle(
                  fontSize: AppDimensions.titleFont(context) * 0.85,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF4A3AFF),
                ),
              ),
            ),
            SizedBox(height: AppDimensions.padding(context)),
            _buildInputField(
              'Name',
              controller: _nameController,
              validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
            ),
            _buildInputField(
              'Email Address',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              validator: (v) =>
                  !GetUtils.isEmail(v ?? '') ? 'Invalid Email' : null,
            ),
            _buildInputField(
              'Password',
              controller: _passwordController,
              isPassword: true,
              obscureText: _obscurePassword,
              onTogglePassword: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
              validator: (v) =>
                  (v != null && v.length < 6) ? 'Min 6 chars' : null,
            ),
            _buildInputField(
              'Confirm Password',
              controller: _confirmPasswordController,
              isPassword: true,
              obscureText: _obscureConfirmPassword,
              onTogglePassword: () => setState(
                () => _obscureConfirmPassword = !_obscureConfirmPassword,
              ),
              validator: (v) =>
                  v != _passwordController.text ? 'Mismatch' : null,
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              height: AppDimensions.buttonHeight(context),
              child: ElevatedButton(
                onPressed: _isLoading ? null : _onSignup,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFA6E4FF),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
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
                        'SIGN UP',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Already registered? ',
                  style: TextStyle(color: Colors.grey),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const LogIn()),
                    );
                  },
                  child: const Text('Login'),
                ),
              ],
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
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword ? obscureText : false,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          isDense: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          suffixIcon: isPassword
              ? IconButton(
                  onPressed: onTogglePassword,
                  icon: Icon(
                    obscureText ? Icons.visibility_off : Icons.visibility,
                    size: 20,
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
