import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../All Pages/Registrations/login.dart';
import '../Provider/Admin_product_provider.dart';
import '../pages/home_page.dart';
import '../utils/api_service.dart';
import 'A_Help.dart';
import 'A_Reports.dart';
import 'A_Settings.dart';
import 'A_banners.dart';
import 'A_carts.dart';
import 'A_deals.dart';
import 'A_discounts.dart';
import 'A_flash_sales.dart';
import 'A_orders.dart';
import 'A_promotions.dart';
import 'Admin_sidebar.dart';
import 'admin_dashboard_page.dart';
import 'admin_update_product.dart';

class AdminProductUploadPage extends StatelessWidget {
  final bool embedded;

  const AdminProductUploadPage({super.key, this.embedded = false});

  static void _navigateFromSidebar(
    BuildContext context,
    AdminSidebarItem item,
  ) {
    if (item == AdminSidebarItem.products) return;
    if (item == AdminSidebarItem.viewStore) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
        (route) => false,
      );
      return;
    }
    Widget page;
    switch (item) {
      case AdminSidebarItem.dashboard:
        page = const AdminDashboardPage(embedded: true);
        break;
      case AdminSidebarItem.orders:
        page = const AdminOrdersPage(embedded: true);
        break;
      case AdminSidebarItem.carts:
        page = const AdminCartsPage(embedded: true);
        break;
      case AdminSidebarItem.reports:
        page = const AdminReportsPage(embedded: true);
        break;
      case AdminSidebarItem.discounts:
        page = const AdminDiscountPage(embedded: true);
        break;
      case AdminSidebarItem.deals:
        page = const AdminDealsPage(embedded: true);
        break;
      case AdminSidebarItem.flashSales:
        page = const AdminFlashSalesPage(embedded: true);
        break;
      case AdminSidebarItem.promotions:
        page = const AdminPromotionsPage(embedded: true);
        break;
      case AdminSidebarItem.banners:
        page = const AdminBannersPage(embedded: true);
        break;
      case AdminSidebarItem.help:
        page = const AdminHelpPage(embedded: true);
        break;
      case AdminSidebarItem.settings:
        page = const AdminSettingsPage(embedded: true);
        break;
      default:
        return;
    }
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => page));
  }

  Widget _buildProductsContent(BuildContext context) {
    const Color cardBg = Color(0xFF151C2C);
    return Column(
      children: [
        Container(
          height: 70,
          color: cardBg,
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Inventory Control & Upload",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AdminUpdateProductPage(),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.delete_sweep,
                      color: Color(0xFFF59E0B),
                      size: 20,
                    ),
                    label: const Text(
                      "Delete Products",
                      style: TextStyle(
                        color: Color(0xFFF59E0B),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const HomePage()),
                        (route) => false,
                      );
                    },
                    icon: const Icon(
                      Icons.store,
                      color: Color(0xFFF59E0B),
                      size: 20,
                    ),
                    label: const Text(
                      "Back to Store",
                      style: TextStyle(
                        color: Color(0xFFF59E0B),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const Expanded(child: _SectionSwitcherView()),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color darkBg = Color(0xFF0B121E);

    if (embedded) {
      return Container(color: darkBg, child: _buildProductsContent(context));
    }
    return Scaffold(
      backgroundColor: darkBg,
      body: Row(
        children: [
          AdminSidebar(
            selected: AdminSidebarItem.products,
            onItemSelected: (item) => _navigateFromSidebar(context, item),
          ),
          Expanded(child: _buildProductsContent(context)),
        ],
      ),
    );
  }
}

class _SectionSwitcherView extends StatefulWidget {
  const _SectionSwitcherView();

  @override
  State<_SectionSwitcherView> createState() => _SectionSwitcherViewState();
}

class _SectionSwitcherViewState extends State<_SectionSwitcherView> {
  static const List<String> _displayOptions = [
    'Best Selling',
    'Trendings',
    'Deals of the Day',
    'Collections',
    'Flash Sale',
    'Others',
  ];

  static const Map<String, String> _displayToSection = {
    'Best Selling': 'Best Sellings',
    'Trendings': 'Trending Items',
    'Deals of the Day': 'Deals of the Day',
    'Collections': 'Collections',
    'Flash Sale': 'Flash Sale',
    'Others': 'Others',
  };

  String _selected = 'Best Selling';

  @override
  Widget build(BuildContext context) {
    const Color fieldBg = Color(0xFF0B121E);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButtonFormField<String>(
            value: _selected,
            dropdownColor: fieldBg,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: 'Select Page',
              labelStyle: TextStyle(color: Colors.white54),
            ),
            items: _displayOptions
                .map((d) => DropdownMenuItem<String>(value: d, child: Text(d)))
                .toList(),
            onChanged: (v) {
              if (v == null) return;
              setState(() => _selected = v);
            },
          ),
          const SizedBox(height: 16),
          _SectionUploadCard(sectionTitle: _displayToSection[_selected]!),
        ],
      ),
    );
  }
}

class _SectionUploadCard extends StatefulWidget {
  final String sectionTitle;
  const _SectionUploadCard({required this.sectionTitle});

  @override
  State<_SectionUploadCard> createState() => _SectionUploadCardState();
}

class _SectionUploadCardState extends State<_SectionUploadCard> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _minPriceController = TextEditingController();
  final TextEditingController _maxPriceController = TextEditingController();
  final TextEditingController _limitController = TextEditingController(
    text: '20',
  );
  String _sort = 'newest';
  List<Map<String, dynamic>> _categories = [];
  int? _selectedCategoryId;
  PlatformFile? _selectedFile;
  bool _loadingCategories = true;
  bool _publishing = false;
  bool _savingFilter = false;

  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _powerWattController = TextEditingController();
  final TextEditingController _warrantyMonthsController =
      TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _lumensController = TextEditingController();
  final TextEditingController _colorTempController = TextEditingController();
  final TextEditingController _lengthMeterController = TextEditingController();
  final TextEditingController _gaugeAwgController = TextEditingController();
  final TextEditingController _materialController = TextEditingController();
  final TextEditingController _sizeController = TextEditingController();

  static const Map<String, String> _sectionToApiKey = {
    'Best Sellings': 'best_sellers',
    'Flash Sale': 'flash_sale',
    'Trending Items': 'trending',
    'Deals of the Day': 'deals',
    'Tech Part': 'tech_part',
  };

  @override
  void initState() {
    super.initState();
    _loadCategories();
    // _loadSectionFilter();
  }

  Future<void> _loadCategories() async {
    try {
      final list = await ApiService.getCategories();
      if (mounted) {
        setState(() {
          final raw = list
              .map((e) => Map<String, dynamic>.from(e as Map))
              .toList();
          final byName = <String, Map<String, dynamic>>{};
          for (final c in raw) {
            final id = c['category_id'] as int?;
            final name = (c['category_name'] ?? '').toString().trim();
            if (id == null || id <= 0 || name.isEmpty) continue;
            final key = name.toLowerCase();
            final existing = byName[key];
            if (existing == null || ((existing['category_id'] as int) > id)) {
              byName[key] = {'category_id': id, 'category_name': name};
            }
          }
          final unique = byName.values.toList()
            ..sort(
              (a, b) =>
                  (a['category_name'] ?? '').toString().toLowerCase().compareTo(
                    (b['category_name'] ?? '').toString().toLowerCase(),
                  ),
            );
          _categories = unique;
          _loadingCategories = false;
          final stillExists = _categories.any(
            (c) => c['category_id'] == _selectedCategoryId,
          );
          if (_categories.isNotEmpty &&
              (_selectedCategoryId == null || !stillExists)) {
            _selectedCategoryId = _categories.first['category_id'] as int?;
          }
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loadingCategories = false);
    }
  }

  Future<void> _loadSectionFilter() async {}

  @override
  Widget build(BuildContext context) {
    const Color fieldBg = Color(0xFF0B121E);
    const Color brandOrange = Color(0xFFF59E0B);

    // Provider Access
    final productProvider = Provider.of<AdminProductProvider>(context);
    final currentSectionProducts =
        productProvider.sectionProducts[widget.sectionTitle] ?? [];

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF151C2C),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Upload to: ${widget.sectionTitle}",
            style: const TextStyle(
              color: brandOrange,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Form Fields
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    _customTextField(_nameController, "Product Name", fieldBg),
                    const SizedBox(height: 12),
                    _customTextField(
                      _priceController,
                      "Price (BDT)",
                      fieldBg,
                      isNumber: true,
                    ),
                    const SizedBox(height: 12),
                    _customTextField(
                      _descController,
                      "Full Description",
                      fieldBg,
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Product Details",
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildDetailsFields(fieldBg),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              // Image & Category
              Expanded(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        height: 120,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: fieldBg,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.white10),
                        ),
                        child: _selectedFile != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.memory(
                                  _selectedFile!.bytes!,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : const Icon(
                                Icons.add_a_photo,
                                color: Colors.white24,
                                size: 40,
                              ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<int>(
                      value: _selectedCategoryId,
                      dropdownColor: fieldBg,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: fieldBg,
                        border: InputBorder.none,
                      ),
                      items: _loadingCategories
                          ? []
                          : _categories
                                .map(
                                  (c) => DropdownMenuItem<int>(
                                    value: c['category_id'] as int?,
                                    child: Text(
                                      (c['category_name'] ?? '').toString(),
                                    ),
                                  ),
                                )
                                .toList(),
                      onChanged: (v) => setState(() => _selectedCategoryId = v),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _publishing
                ? null
                : () => _handlePublish(productProvider),
            style: ElevatedButton.styleFrom(
              backgroundColor: brandOrange,
              minimumSize: const Size(double.infinity, 50),
            ),
            child: _publishing
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    "Publish to ${widget.sectionTitle}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),

          // লাইভ প্রিভিউ সেকশন (নিচে দেখাবে কি কি আপলোড হয়েছে)
          if (currentSectionProducts.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Divider(color: Colors.white10),
            ),
            const Text(
              "Recently Published:",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: currentSectionProducts.length,
              itemBuilder: (context, index) {
                final p = currentSectionProducts[index];
                final hasBytes = p['image']?.bytes != null;
                final imageUrl = p['imageUrl'] as String?;
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundImage: hasBytes
                        ? MemoryImage(p['image'].bytes!)
                        : (imageUrl != null && imageUrl.isNotEmpty)
                        ? NetworkImage(imageUrl)
                        : null,
                    backgroundColor:
                        hasBytes || (imageUrl != null && imageUrl.isNotEmpty)
                        ? null
                        : Colors.grey[700],
                    child:
                        (hasBytes || (imageUrl != null && imageUrl.isNotEmpty))
                        ? null
                        : const Icon(Icons.image, color: Colors.white54),
                  ),
                  title: Text(
                    p['name'],
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "৳ ${p['price']}",
                        style: const TextStyle(color: Colors.green),
                      ),
                      if ((p['category'] ?? '').toString().isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            "Category: ${p['category']}",
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      if ((p['desc'] ?? '').toString().isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            "${p['desc']}",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white60,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
                  trailing: Wrap(
                    spacing: 8,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () =>
                            _showEditDialog(context, productProvider, index, p),
                        icon: const Icon(
                          Icons.edit,
                          color: Color(0xFFF59E0B),
                          size: 18,
                        ),
                        label: const Text(
                          'Update',
                          style: TextStyle(color: Color(0xFFF59E0B)),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFF59E0B)),
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () =>
                            _confirmDelete(context, productProvider, index),
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.redAccent,
                          size: 18,
                        ),
                        label: const Text(
                          'Delete',
                          style: TextStyle(color: Colors.redAccent),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  void _confirmDelete(
    BuildContext context,
    AdminProductProvider provider,
    int index,
  ) {
    showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF151C2C),
        title: const Text(
          'Remove product?',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'This will remove the product from this section.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    ).then((ok) {
      if (ok == true) {
        provider.removeProduct(widget.sectionTitle, index);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.orange,
              content: Text('Product removed'),
            ),
          );
        }
      }
    });
  }

  void _showEditDialog(
    BuildContext context,
    AdminProductProvider provider,
    int index,
    Map<String, dynamic> p,
  ) {
    final nameC = TextEditingController(text: '${p['name']}');
    final priceC = TextEditingController(text: '${p['price']}');
    final descC = TextEditingController(text: '${p['desc']}');
    String category = p['category'] ?? 'Home Utility';
    PlatformFile? pickedFile;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF151C2C),
              title: const Text(
                'Edit product',
                style: TextStyle(color: Colors.white),
              ),
              content: SingleChildScrollView(
                child: SizedBox(
                  width: 400,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: nameC,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Product name',
                          labelStyle: TextStyle(color: Colors.white54),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white24),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: priceC,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Price (BDT)',
                          labelStyle: TextStyle(color: Colors.white54),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white24),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: descC,
                        maxLines: 2,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          labelStyle: TextStyle(color: Colors.white54),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white24),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Builder(
                        builder: (context) {
                          final List<String> catNames = _categories
                              .map((e) => (e['category_name'] ?? '').toString())
                              .where((e) => e.isNotEmpty)
                              .toSet()
                              .toList();
                          final String? selectedValue =
                              catNames.contains(category)
                              ? category
                              : (catNames.isNotEmpty ? catNames.first : null);
                          return DropdownButtonFormField<String>(
                            value: selectedValue,
                            dropdownColor: const Color(0xFF0B121E),
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              labelText: 'Category',
                              labelStyle: TextStyle(color: Colors.white54),
                            ),
                            items: catNames
                                .map(
                                  (c) => DropdownMenuItem(
                                    value: c,
                                    child: Text(c),
                                  ),
                                )
                                .toList(),
                            onChanged: (v) =>
                                setDialogState(() => category = v ?? category),
                          );
                        },
                      ),
                      const SizedBox(height: 8),
                      OutlinedButton.icon(
                        onPressed: () async {
                          final result = await FilePicker.platform.pickFiles(
                            type: FileType.image,
                            withData: true,
                          );
                          if (result != null) {
                            setDialogState(
                              () => pickedFile = result.files.first,
                            );
                          }
                        },
                        icon: const Icon(
                          Icons.add_photo_alternate,
                          color: Color(0xFFF59E0B),
                        ),
                        label: const Text(
                          'Change image',
                          style: TextStyle(color: Color(0xFFF59E0B)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF59E0B),
                  ),
                  onPressed: () {
                    if (nameC.text.trim().isEmpty ||
                        priceC.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Name and price required'),
                        ),
                      );
                      return;
                    }
                    final Map<String, dynamic> data = {
                      'name': nameC.text.trim(),
                      'price': priceC.text.trim(),
                      'desc': descC.text.trim(),
                      'category': category,
                      'imageUrl': pickedFile == null
                          ? (p['imageUrl'] ?? null)
                          : null,
                    };
                    if (pickedFile != null) {
                      data['image'] = pickedFile;
                    } else if (p['image'] != null)
                      data['image'] = p['image'];
                    provider.updateProduct(widget.sectionTitle, index, data);
                    Navigator.pop(ctx);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Colors.green,
                          content: Text('Product updated'),
                        ),
                      );
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ইমেজ সিলেক্ট করার ফাংশন
  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );
    if (result != null) setState(() => _selectedFile = result.files.first);
  }

  // পাবলিশ করার ফাংশন - API তে সেভ করে তারপর সেকশনে অ্যাসাইন করে
  Future<void> _handlePublish(AdminProductProvider provider) async {
    final token = await ApiService.getToken();
    if (token == null || token.isEmpty) {
      if (!mounted) return;
      showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: const Color(0xFF151C2C),
          title: const Text(
            'Admin login required',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            'Please login as admin to publish products.',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LogIn()),
                  (route) => false,
                );
              },
              child: const Text('Login'),
            ),
          ],
        ),
      );
      return;
    }
    if (_nameController.text.isEmpty || _priceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Product name and price required!")),
      );
      return;
    }
    if (_selectedFile == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Add an image file!")));
      return;
    }
    final price = double.tryParse(_priceController.text.trim()) ?? 0;
    if (price <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Enter a valid price.")));
      return;
    }

    setState(() => _publishing = true);
    try {
      final specs = _buildSpecsForSelectedCategory();
      final res = await ApiService.createProductWithImage(
        product_name: _nameController.text.trim(),
        description: _descController.text.trim(),
        price: price,
        stock_quantity: 0,
        category_id: _selectedCategoryId,
        image_url: null,
        imageBytes: _selectedFile?.bytes,
        imageFileName: _selectedFile?.name,
        specs: specs.isEmpty ? null : specs,
      );
      final productId = res['productId'] as int?;
      if (productId == null) throw Exception('No product ID returned');

      final sectionKey = _sectionToApiKey[widget.sectionTitle];
      if (sectionKey != null) {
        await ApiService.updateProductSections(productId, {sectionKey: true});
      } else {
        // No backend section for this page (e.g., Collections/Others)
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.orange,
              content: Text(
                'Created product; this page has no backend section to assign.',
              ),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }

      final serverProduct = (res['product'] is Map)
          ? Map<String, dynamic>.from(res['product'])
          : null;
      final productData = serverProduct != null
          ? {
              "id": "server_$productId",
              "name": (serverProduct['product_name'] ?? '').toString(),
              "price": (serverProduct['price'] ?? '').toString(),
              "desc": (serverProduct['description'] ?? '').toString(),
              "category": (serverProduct['category_name'] ?? '').toString(),
              "imageUrl": (serverProduct['image_url'] ?? '').toString(),
              "image": null,
            }
          : {
              "name": _nameController.text.trim(),
              "price": _priceController.text.trim(),
              "desc": _descController.text.trim(),
              "category": () {
                for (final c in _categories) {
                  if (c['category_id'] == _selectedCategoryId) {
                    return (c['category_name'] ?? '').toString();
                  }
                }
                return '';
              }(),
              "image": _selectedFile,
              "imageUrl": null,
            };
      provider.addProduct(widget.sectionTitle, productData);

      _nameController.clear();
      _priceController.clear();
      _descController.clear();
      _imageUrlController.clear();
      _modelController.clear();
      _powerWattController.clear();
      _warrantyMonthsController.clear();
      _colorController.clear();
      _lumensController.clear();
      _colorTempController.clear();
      _lengthMeterController.clear();
      _gaugeAwgController.clear();
      _materialController.clear();
      _sizeController.clear();
      setState(() => _selectedFile = null);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text("${widget.sectionTitle}-এ আপলোড সফল হয়েছে!"),
          ),
        );
      }
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(backgroundColor: Colors.red, content: Text(e.message)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text('Upload failed: ${e.toString()}'),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _publishing = false);
    }
  }

  Future<void> _saveSectionFilter() async {}

  Widget _customTextField(
    TextEditingController controller,
    String hint,
    Color bg, {
    int maxLines = 1,
    bool isNumber = false,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white24, fontSize: 14),
        filled: true,
        fillColor: bg,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildDetailsFields(Color bg) {
    final catName = () {
      for (final c in _categories) {
        if (c['category_id'] == _selectedCategoryId)
          return (c['category_name'] ?? '').toString();
      }
      return '';
    }().toLowerCase();
    final isKitchen = catName.contains('kitchen');
    final isPersonal = catName.contains('personal');
    final isHome = catName.contains('home');
    final isLighting = catName.contains('lighting');
    final isTools = catName.contains('tools');
    final isWiring = catName.contains('wiring');

    final List<Widget> fields = [];
    if (isKitchen || isHome) {
      fields.addAll([
        _customTextField(_modelController, "Model", bg),
        const SizedBox(height: 8),
        _customTextField(
          _powerWattController,
          "Power (Watt)",
          bg,
          isNumber: true,
        ),
        const SizedBox(height: 8),
        _customTextField(
          _warrantyMonthsController,
          "Warranty (months)",
          bg,
          isNumber: true,
        ),
      ]);
    }
    if (isPersonal || isHome || isTools) {
      if (fields.isNotEmpty) fields.add(const SizedBox(height: 8));
      fields.add(_customTextField(_colorController, "Color", bg));
    }
    if (isLighting) {
      if (fields.isNotEmpty) fields.add(const SizedBox(height: 8));
      fields.addAll([
        _customTextField(_lumensController, "Lumens", bg, isNumber: true),
        const SizedBox(height: 8),
        _customTextField(
          _colorTempController,
          "Color Temperature (K)",
          bg,
          isNumber: true,
        ),
        const SizedBox(height: 8),
        _customTextField(
          _powerWattController,
          "Power (Watt)",
          bg,
          isNumber: true,
        ),
      ]);
    }
    if (isTools) {
      if (fields.isNotEmpty) fields.add(const SizedBox(height: 8));
      fields.addAll([
        _customTextField(_materialController, "Material", bg),
        const SizedBox(height: 8),
        _customTextField(_sizeController, "Size", bg),
      ]);
    }
    if (isWiring) {
      if (fields.isNotEmpty) fields.add(const SizedBox(height: 8));
      fields.addAll([
        _customTextField(
          _lengthMeterController,
          "Length (meter)",
          bg,
          isNumber: true,
        ),
        const SizedBox(height: 8),
        _customTextField(
          _gaugeAwgController,
          "Gauge (AWG)",
          bg,
          isNumber: true,
        ),
        const SizedBox(height: 8),
        _customTextField(_materialController, "Material", bg),
      ]);
    }
    if (fields.isEmpty) {
      fields.addAll([
        _customTextField(_modelController, "Model (optional)", bg),
      ]);
    }
    return Column(children: fields);
  }

  Map<String, dynamic> _buildSpecsForSelectedCategory() {
    final Map<String, dynamic> m = {};
    void put(String k, TextEditingController c, {bool number = false}) {
      final t = c.text.trim();
      if (t.isEmpty) return;
      m[k] = number ? (double.tryParse(t) ?? t) : t;
    }

    put('model', _modelController);
    put('power_watt', _powerWattController, number: true);
    put('warranty_months', _warrantyMonthsController, number: true);
    put('color', _colorController);
    put('lumens', _lumensController, number: true);
    put('color_temperature_k', _colorTempController, number: true);
    put('length_meter', _lengthMeterController, number: true);
    put('gauge_awg', _gaugeAwgController, number: true);
    put('material', _materialController);
    put('size', _sizeController);
    return m;
  }
}
