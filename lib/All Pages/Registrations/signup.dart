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

  // --- FIXED: Added Navigation inside the Logic Function ---
  Future<void> _onSignup() async {
    // 1. Validate Form
    if (!_formKey.currentState!.validate()) return;

    // 2. Start Loading
    setState(() => _isLoading = true);

    // 3. Simulate Network Delay
    await Future.delayed(const Duration(milliseconds: 1500));

    // 4. Stop Loading
    setState(() => _isLoading = false);

    // 5. Show Success Feedback
    Get.snackbar(
      'Sign Up',
      'Account created successfully!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.white,
      colorText: Colors.black,
      margin: const EdgeInsets.all(15),
      duration: const Duration(seconds: 2),
    );

    // 6. Navigate to Login Page
    // Using Get.off to prevent user from going back to Signup form
    Get.off(() => const LogIn());
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
                              : r.hp(78),
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

  Widget _buildStackedLayout(AppResponsive r) {
    return Column(
      children: [
        SizedBox(
          height: r.value(
            smallMobile: 170,
            mobile: 205,
            tablet: 230,
            smallDesktop: 260,
            desktop: 280,
          ),
          width: double.infinity,
          child: _buildLeftPanel(),
        ),
        _buildRightPanel(isStacked: true),
      ],
    );
  }

  Widget _buildLeftPanel() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 231, 160, 79),
            Color.fromARGB(230, 149, 180, 219),
          ],
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
                  const Icon(Icons.bolt, color: Colors.white, size: 50),
            ),
            SizedBox(height: AppDimensions.padding(context) * 0.6),
            Text(
              'Get all your buying\nproblems solved today',
              style: TextStyle(
                color: Colors.white,
                fontSize: AppDimensions.titleFont(context),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: AppDimensions.padding(context) * 0.6),
            Text(
              'Join Electrocity-BD and connect\nwith suppliers across Bangladesh',
              style: TextStyle(
                color: Colors.white70,
                fontSize: AppDimensions.bodyFont(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRightPanel({bool isStacked = false}) {
    final r = AppResponsive.of(context);

    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(
        horizontal: r.value(
          smallMobile: 14,
          mobile: 16,
          tablet: 24,
          smallDesktop: AppDimensions.padding(context) * 1.4,
          desktop: AppDimensions.padding(context) * 1.5,
        ),
        vertical: r.value(
          smallMobile: 12,
          mobile: 14,
          tablet: 18,
          smallDesktop: AppDimensions.padding(context) * 1.1,
          desktop: AppDimensions.padding(context) * 0.8,
        ),
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          physics: isStacked ? const NeverScrollableScrollPhysics() : null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Register Your Account',
                  style: TextStyle(
                    fontSize: AppDimensions.titleFont(context),
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF4A3AFF),
                  ),
                ),
              ),
              SizedBox(height: AppDimensions.padding(context) * 0.9),
              _buildInputField(
                'Name',
                controller: _nameController,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Name is required';
                  return null;
                },
              ),
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
              _buildInputField(
                'Confirm Password',
                controller: _confirmPasswordController,
                isPassword: true,
                obscureText: _obscureConfirmPassword,
                onTogglePassword: () {
                  setState(
                    () => _obscureConfirmPassword = !_obscureConfirmPassword,
                  );
                },
                validator: (v) {
                  if (v != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: AppDimensions.buttonHeight(context),
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _onSignup,
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
                          'SIGN UP',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                ),
              ),
              Center(
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    const Text(
                      'Already registered? ',
                      style: TextStyle(color: Colors.grey),
                    ),
                    TextButton(
                      onPressed: () {
                        // Regular navigation back to login
                        Get.off(() => const LogIn());
                      },
                      child: const Text('Login'),
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
      padding: const EdgeInsets.only(bottom: 10),
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
