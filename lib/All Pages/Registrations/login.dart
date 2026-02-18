import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Dimensions/responsive_dimensions.dart';
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

  Future<void> _onLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 900));

    setState(() => _isLoading = false);

    Get.snackbar(
      'Login',
      'Login successful (demo)',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.white,
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
        // --- Consistent Background Gradient ---
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFFD54F), // Yellow
              Color(0xFF64B5F6), // Blue
            ],
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
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: isCompact
                          ? MediaQuery.of(context).viewInsets.bottom
                          : 0,
                    ),
                    child: Center(
                      child: Container(
                        margin: EdgeInsets.all(AppDimensions.padding(context)),
                        constraints: BoxConstraints(
                          maxWidth: r.value(
                            smallMobile: 360,
                            mobile: 430,
                            tablet: 760,
                            smallDesktop: 1040,
                            desktop: 1220,
                          ),
                          maxHeight: isStackedLayout
                              ? double.infinity
                              : r.hp(74),
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
                              ? _buildStackedLayout(r, isCompact: isCompact)
                              : _buildDesktopLayout(),
                        ),
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
        Expanded(flex: 2, child: _buildLeftPanel()),
        Expanded(flex: 3, child: _buildRightPanel()),
      ],
    );
  }

  Widget _buildStackedLayout(AppResponsive r, {required bool isCompact}) {
    return Column(
      children: [
        SizedBox(
          height: r.value(
            smallMobile: 130,
            mobile: 155,
            tablet: 210,
            smallDesktop: 260,
            desktop: 280,
          ),
          width: double.infinity,
          child: _buildLeftPanel(),
        ),
        _buildRightPanel(isCompact: isCompact, isStacked: true),
      ],
    );
  }

  Widget _buildLeftPanel() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1E40AF), Color(0xFFFBBF24)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.padding(context) * 1.6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              _logoPath,
              height: AppDimensions.imageSize(context) * 0.85,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.flash_on, color: Colors.white, size: 40),
            ),
            SizedBox(height: AppDimensions.padding(context) * 0.8),
            Center(
              child: Text(
                'Welcome back to Electrocity-BD',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: AppDimensions.smallFont(context) * 1.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRightPanel({bool isCompact = false, bool isStacked = false}) {
    final r = AppResponsive.of(context);

    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(
        horizontal: r.value(
          smallMobile: 14,
          mobile: 16,
          tablet: 24,
          smallDesktop: AppDimensions.padding(context) * 1.4,
          desktop: AppDimensions.padding(context) * 1.6,
        ),
        vertical: r.value(
          smallMobile: 12,
          mobile: 14,
          tablet: 18,
          smallDesktop: AppDimensions.padding(context) * 1.1,
          desktop: AppDimensions.padding(context) * 1.2,
        ),
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          physics: isStacked ? const NeverScrollableScrollPhysics() : null,
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
              SizedBox(height: AppDimensions.padding(context) * 1.2),
              _buildInputField(
                'Email Address',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Email is required';
                  if (!GetUtils.isEmail(v.trim())) return 'Enter a valid email';
                  return null;
                },
              ),
              _buildInputField(
                'Password',
                controller: _passwordController,
                isPassword: true,
                obscureText: _obscurePassword,
                onTogglePassword: () {
                  setState(() => _obscurePassword = !_obscurePassword);
                },
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Password is required';
                  if (v.length < 6) return 'Minimum 6 characters';
                  return null;
                },
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
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
                    elevation: 0,
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
              SizedBox(height: AppDimensions.padding(context) * 1.1),
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
      padding: EdgeInsets.only(bottom: AppDimensions.padding(context) * 0.9),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: AppDimensions.smallFont(context),
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller,
            obscureText: isPassword ? obscureText : false,
            keyboardType: keyboardType,
            validator: validator,
            decoration: InputDecoration(
              isDense: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  AppDimensions.borderRadius(context),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  AppDimensions.borderRadius(context),
                ),
                borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 14,
              ),
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
        ],
      ),
    );
  }
}
