import 'package:flutter/material.dart';

import '../../Dimensions/responsive_dimensions.dart';

class TrackOrderFormPage extends StatefulWidget {
  const TrackOrderFormPage({super.key});

  @override
  State<TrackOrderFormPage> createState() => _TrackOrderFormPageState();
}

class _TrackOrderFormPageState extends State<TrackOrderFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _orderIdController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _orderIdController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _handleTrackOrder() {
    if (_formKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const TrackOrderPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final r = AppResponsive.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.all(AppDimensions.padding(context)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SafeArea(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: EdgeInsets.all(
                          AppDimensions.padding(context) * 0.75,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(
                            AppDimensions.borderRadius(context),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.black87,
                          size: AppDimensions.iconSize(context),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: r.hp(3)),
                  Center(
                    child: Column(
                      children: [
                        Text(
                          'Track Your Order',
                          style: TextStyle(
                            fontSize: AppDimensions.titleFont(context),
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: r.hp(1)),
                        Text(
                          'Home / Track Your Order',
                          style: TextStyle(
                            fontSize: AppDimensions.smallFont(context),
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Form Container
            Padding(
              padding: EdgeInsets.all(AppDimensions.padding(context)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'To track your order please enter your Order ID in the box below and press the "Track Order" button. This was given to you on your receipt and in the confirmation email you should have received.',
                    style: TextStyle(
                      fontSize: AppDimensions.bodyFont(context),
                      color: Colors.grey.shade700,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: r.hp(4)),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Order ID Field
                        Text(
                          'Order ID',
                          style: TextStyle(
                            fontSize: AppDimensions.bodyFont(context),
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: r.hp(1)),
                        TextFormField(
                          controller: _orderIdController,
                          decoration: InputDecoration(
                            hintText: 'Enter Your Order ID',
                            hintStyle: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: AppDimensions.bodyFont(context),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                AppDimensions.borderRadius(context),
                              ),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: AppDimensions.padding(context),
                              vertical: AppDimensions.padding(context) * 0.875,
                            ),
                            fillColor: Colors.white,
                            filled: true,
                          ),
                          style: TextStyle(
                            fontSize: AppDimensions.bodyFont(context),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your Order ID';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: r.hp(3)),
                        // Billing Email Field
                        Text(
                          'Billing Email',
                          style: TextStyle(
                            fontSize: AppDimensions.bodyFont(context),
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: r.hp(1)),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            hintText: 'Enter Email Address',
                            hintStyle: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: AppDimensions.bodyFont(context),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                AppDimensions.borderRadius(context),
                              ),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: AppDimensions.padding(context),
                              vertical: AppDimensions.padding(context) * 0.875,
                            ),
                            fillColor: Colors.white,
                            filled: true,
                          ),
                          style: TextStyle(
                            fontSize: AppDimensions.bodyFont(context),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!RegExp(
                              r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                            ).hasMatch(value)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: r.hp(4)),
                        // Track Order Button
                        SizedBox(
                          width: double.infinity,
                          height: AppDimensions.buttonHeight(context),
                          child: ElevatedButton(
                            onPressed: _handleTrackOrder,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1B7340),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            child: Text(
                              'Track Order',
                              style: TextStyle(
                                fontSize: AppDimensions.bodyFont(context),
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: r.hp(6)),
                  // Features Section
                  Row(
                    children: [
                      Expanded(
                        child: _buildFeature(
                          context,
                          icon: Icons.local_shipping_outlined,
                          title: 'Free Shipping',
                          subtitle: 'Free shipping for order above \$180',
                        ),
                      ),
                      SizedBox(width: AppDimensions.padding(context) * 0.75),
                      Expanded(
                        child: _buildFeature(
                          context,
                          icon: Icons.credit_card,
                          title: 'Flexible Payment',
                          subtitle: 'Multiple secure payment options',
                        ),
                      ),
                      SizedBox(width: AppDimensions.padding(context) * 0.75),
                      Expanded(
                        child: _buildFeature(
                          context,
                          icon: Icons.support_agent,
                          title: '24x7 Support',
                          subtitle: 'We support online all days.',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeature(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.padding(context) * 0.75),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          AppDimensions.borderRadius(context),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: const Color(0xFF1B7340),
            size: AppDimensions.iconSize(context),
          ),
          SizedBox(height: AppResponsive.of(context).hp(1)),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppDimensions.smallFont(context),
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: AppResponsive.of(context).hp(0.5)),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppDimensions.smallFont(context) - 2,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}

class TrackOrderPage extends StatelessWidget {
  const TrackOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final r = AppResponsive.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header with Back Button
            Padding(
              padding: EdgeInsets.all(AppDimensions.padding(context)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SafeArea(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: EdgeInsets.all(
                          AppDimensions.padding(context) * 0.75,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(
                            AppDimensions.borderRadius(context),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.black87,
                          size: AppDimensions.iconSize(context),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: r.hp(3)),
                  Center(
                    child: Column(
                      children: [
                        Text(
                          'Track Your Order',
                          style: TextStyle(
                            fontSize: AppDimensions.titleFont(context),
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: r.hp(1)),
                        Text(
                          'Home / Track Your Order',
                          style: TextStyle(
                            fontSize: AppDimensions.smallFont(context),
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(AppDimensions.padding(context)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Order Status Header
                  Text(
                    'Order Status',
                    style: TextStyle(
                      fontSize: AppDimensions.titleFont(context) * 0.7,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: r.hp(1)),
                  Text(
                    'Order ID : #SDGT1254FD',
                    style: TextStyle(
                      fontSize: AppDimensions.smallFont(context),
                      color: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: r.hp(3)),
                  // Timeline Status
                  Container(
                    padding: EdgeInsets.all(AppDimensions.padding(context)),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        AppDimensions.borderRadius(context),
                      ),
                    ),
                    child: _buildTimeline(context),
                  ),
                  SizedBox(height: r.hp(4)),
                  // Products Section
                  Text(
                    'Products',
                    style: TextStyle(
                      fontSize: AppDimensions.titleFont(context) * 0.7,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: r.hp(2)),
                  // Product Items
                  _buildProductItem(
                    context: context,
                    productName: 'Wooden Sofa Chair',
                    color: 'Grey',
                    quantity: '4 Qty.',
                  ),
                  SizedBox(height: AppDimensions.padding(context) * 0.75),
                  _buildProductItem(
                    context: context,
                    productName: 'Red Gaming Chair',
                    color: 'Black',
                    quantity: '2 Qty.',
                  ),
                  SizedBox(height: AppDimensions.padding(context) * 0.75),
                  _buildProductItem(
                    context: context,
                    productName: 'Swivel Chair',
                    color: 'Light Brown',
                    quantity: '1 Qty.',
                  ),
                  SizedBox(height: AppDimensions.padding(context) * 0.75),
                  _buildProductItem(
                    context: context,
                    productName: 'Circular Sofa Chair',
                    color: 'Brown',
                    quantity: '2 Qty.',
                  ),
                  SizedBox(height: r.hp(4)),
                  // Features Section
                  Row(
                    children: [
                      Expanded(
                        child: _buildFeature(
                          context,
                          icon: Icons.local_shipping_outlined,
                          title: 'Free Shipping',
                          subtitle: 'Free shipping for order above \$180',
                        ),
                      ),
                      SizedBox(width: AppDimensions.padding(context) * 0.75),
                      Expanded(
                        child: _buildFeature(
                          context,
                          icon: Icons.credit_card,
                          title: 'Flexible Payment',
                          subtitle: 'Multiple secure payment options',
                        ),
                      ),
                      SizedBox(width: AppDimensions.padding(context) * 0.75),
                      Expanded(
                        child: _buildFeature(
                          context,
                          icon: Icons.support_agent,
                          title: '24x7 Support',
                          subtitle: 'We support online all days.',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeline(BuildContext context) {
    final r = AppResponsive.of(context);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStatusItem(
            context: context,
            icon: Icons.shopping_bag,
            label: 'Order Placed',
            date: '20 Apr 2024',
            time: '11:00 AM',
            isCompleted: true,
            isActive: true,
          ),
          _buildStatusConnector(context, true),
          _buildStatusItem(
            context: context,
            icon: Icons.done_all,
            label: 'Accepted',
            date: '20 Apr 2024',
            time: '11:15 AM',
            isCompleted: true,
            isActive: false,
          ),
          _buildStatusConnector(context, false),
          _buildStatusItem(
            context: context,
            icon: Icons.local_shipping,
            label: 'In Progress',
            date: 'Expected',
            time: '21 Apr 2024',
            isCompleted: false,
            isActive: false,
          ),
          _buildStatusConnector(context, false),
          _buildStatusItem(
            context: context,
            icon: Icons.directions_car,
            label: 'On the Way',
            date: 'Expected',
            time: '22,23 Apr 2024',
            isCompleted: false,
            isActive: false,
          ),
          _buildStatusConnector(context, false),
          _buildStatusItem(
            context: context,
            icon: Icons.home,
            label: 'Delivered',
            date: 'Expected',
            time: '24 Apr 2024',
            isCompleted: false,
            isActive: false,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String date,
    required String time,
    required bool isCompleted,
    required bool isActive,
  }) {
    final r = AppResponsive.of(context);

    return SizedBox(
      width: r.wp(15),
      child: Column(
        children: [
          Container(
            width: AppDimensions.iconSize(context) * 2,
            height: AppDimensions.iconSize(context) * 2,
            decoration: BoxDecoration(
              color: isCompleted
                  ? const Color(0xFF1B7340)
                  : Colors.grey.shade300,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isCompleted ? Colors.white : Colors.grey.shade500,
              size: AppDimensions.iconSize(context),
            ),
          ),
          SizedBox(height: r.hp(1)),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppDimensions.smallFont(context),
              fontWeight: FontWeight.w600,
              color: isCompleted ? Colors.black87 : Colors.grey.shade500,
            ),
          ),
          SizedBox(height: r.hp(0.5)),
          Text(
            date,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppDimensions.smallFont(context) - 2,
              color: Colors.grey.shade600,
            ),
          ),
          Text(
            time,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppDimensions.smallFont(context) - 2,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusConnector(BuildContext context, bool isCompleted) {
    final r = AppResponsive.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: r.hp(2.5)),
      child: Container(
        width: r.wp(3),
        height: AppDimensions.borderRadius(context) * 0.5,
        color: isCompleted ? const Color(0xFF1B7340) : Colors.grey.shade300,
      ),
    );
  }

  Widget _buildProductItem({
    required BuildContext context,
    required String productName,
    required String color,
    required String quantity,
  }) {
    final r = AppResponsive.of(context);

    return Container(
      padding: EdgeInsets.all(AppDimensions.padding(context) * 0.75),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          AppDimensions.borderRadius(context),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: AppDimensions.imageSize(context) * 0.4,
            height: AppDimensions.imageSize(context) * 0.4,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(
                AppDimensions.borderRadius(context),
              ),
            ),
            child: Icon(
              Icons.chair,
              color: Colors.grey.shade400,
              size: AppDimensions.iconSize(context),
            ),
          ),
          SizedBox(width: AppDimensions.padding(context) * 0.75),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                productName,
                style: TextStyle(
                  fontSize: AppDimensions.bodyFont(context),
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: r.hp(0.5)),
              Text(
                'Color : $color | $quantity',
                style: TextStyle(
                  fontSize: AppDimensions.smallFont(context),
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeature(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final r = AppResponsive.of(context);

    return Container(
      padding: EdgeInsets.all(AppDimensions.padding(context) * 0.75),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          AppDimensions.borderRadius(context),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: const Color(0xFF1B7340),
            size: AppDimensions.iconSize(context),
          ),
          SizedBox(height: r.hp(1)),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppDimensions.smallFont(context),
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: r.hp(0.5)),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppDimensions.smallFont(context) - 2,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}
