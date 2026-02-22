import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Provider/Admin_product_provider.dart';
import '../utils/api_service.dart';
import '../pages/home_page.dart';
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

  static void _navigateFromSidebar(BuildContext context, AdminSidebarItem item) {
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
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  Widget _buildProductsContent(BuildContext context) {
    const Color cardBg = Color(0xFF151C2C);
    const List<String> sectionTitles = [
      "Best Sellings",
      "Flash Sale",
      "Trending Items",
      "Deals of the Day",
      "Tech Part",
    ];
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
                        MaterialPageRoute(builder: (_) => const AdminUpdateProductPage()),
                      );
                    },
                    icon: const Icon(Icons.delete_sweep, color: Color(0xFFF59E0B), size: 20),
                    label: const Text(
                      "Delete Products",
                      style: TextStyle(color: Color(0xFFF59E0B), fontWeight: FontWeight.w600),
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
                    icon: const Icon(Icons.store, color: Color(0xFFF59E0B), size: 20),
                    label: const Text(
                      "Back to Store",
                      style: TextStyle(color: Color(0xFFF59E0B), fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: sectionTitles
                  .map(
                    (title) => Padding(
                      padding: const EdgeInsets.only(bottom: 32),
                      child: _SectionUploadCard(sectionTitle: title),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
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
          Expanded(
            child: _buildProductsContent(context),
          ),
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
  List<Map<String, dynamic>> _categories = [];
  int? _selectedCategoryId;
  PlatformFile? _selectedFile;
  bool _loadingCategories = true;
  bool _publishing = false;

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
  }

  Future<void> _loadCategories() async {
    try {
      final list = await ApiService.getCategories();
      if (mounted) {
        setState(() {
          _categories = list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
          _loadingCategories = false;
          if (_categories.isNotEmpty && _selectedCategoryId == null) {
            _selectedCategoryId = _categories.first['category_id'] as int?;
          }
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loadingCategories = false);
    }
  }

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
                    const SizedBox(height: 12),
                    _customTextField(
                      _imageUrlController,
                      "Image URL (optional)",
                      fieldBg,
                    ),
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
                              .map((c) => DropdownMenuItem<int>(
                                    value: c['category_id'] as int?,
                                    child: Text((c['category_name'] ?? '').toString()),
                                  ))
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
            onPressed: _publishing ? null : () => _handlePublish(productProvider),
            style: ElevatedButton.styleFrom(
              backgroundColor: brandOrange,
              minimumSize: const Size(double.infinity, 50),
            ),
            child: _publishing
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                  )
                : const Text(
                    "Publish Now",
                    style: TextStyle(
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
                    backgroundColor: hasBytes || (imageUrl != null && imageUrl.isNotEmpty)
                        ? null
                        : Colors.grey[700],
                    child: (hasBytes || (imageUrl != null && imageUrl.isNotEmpty))
                        ? null
                        : const Icon(Icons.image, color: Colors.white54),
                  ),
                  title: Text(
                    p['name'],
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    "৳ ${p['price']}",
                    style: const TextStyle(color: Colors.green),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Color(0xFFF59E0B), size: 20),
                        onPressed: () => _showEditDialog(context, productProvider, index, p),
                        tooltip: 'Edit',
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                        onPressed: () => _confirmDelete(context, productProvider, index),
                        tooltip: 'Delete',
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

  void _confirmDelete(BuildContext context, AdminProductProvider provider, int index) {
    showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF151C2C),
        title: const Text('Remove product?', style: TextStyle(color: Colors.white)),
        content: const Text(
          'This will remove the product from this section.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
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
            const SnackBar(backgroundColor: Colors.orange, content: Text('Product removed')),
          );
        }
      }
    });
  }

  void _showEditDialog(BuildContext context, AdminProductProvider provider, int index, Map<String, dynamic> p) {
    final nameC = TextEditingController(text: '${p['name']}');
    final priceC = TextEditingController(text: '${p['price']}');
    final descC = TextEditingController(text: '${p['desc']}');
    final imageUrlC = TextEditingController(text: '${p['imageUrl'] ?? ''}');
    String category = p['category'] ?? 'Home Utility';
    PlatformFile? pickedFile;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF151C2C),
              title: const Text('Edit product', style: TextStyle(color: Colors.white)),
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
                          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
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
                          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
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
                          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: imageUrlC,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Image URL',
                          labelStyle: TextStyle(color: Colors.white54),
                          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
                        ),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: category,
                        dropdownColor: const Color(0xFF0B121E),
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Category',
                          labelStyle: TextStyle(color: Colors.white54),
                        ),
                        items: ['Home Utility', 'Personal Care', 'Kitchen', 'Cooling']
                            .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                            .toList(),
                        onChanged: (v) => setDialogState(() => category = v ?? category),
                      ),
                      const SizedBox(height: 8),
                      OutlinedButton.icon(
                        onPressed: () async {
                          final result = await FilePicker.platform.pickFiles(type: FileType.image, withData: true);
                          if (result != null) setDialogState(() => pickedFile = result.files.first);
                        },
                        icon: const Icon(Icons.add_photo_alternate, color: Color(0xFFF59E0B)),
                        label: const Text('Change image', style: TextStyle(color: Color(0xFFF59E0B))),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF59E0B)),
                  onPressed: () {
                    if (nameC.text.trim().isEmpty || priceC.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Name and price required')),
                      );
                      return;
                    }
                    final Map<String, dynamic> data = {
                      'name': nameC.text.trim(),
                      'price': priceC.text.trim(),
                      'desc': descC.text.trim(),
                      'category': category,
                      'imageUrl': imageUrlC.text.trim().isEmpty ? null : imageUrlC.text.trim(),
                    };
                    if (pickedFile != null) data['image'] = pickedFile;
                    else if (p['image'] != null) data['image'] = p['image'];
                    provider.updateProduct(widget.sectionTitle, index, data);
                    Navigator.pop(ctx);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(backgroundColor: Colors.green, content: Text('Product updated')),
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
    if (_nameController.text.isEmpty || _priceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Product name and price required!")),
      );
      return;
    }
    if (_selectedFile == null && _imageUrlController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Add an image (file or URL)!")),
      );
      return;
    }
    final price = double.tryParse(_priceController.text.trim()) ?? 0;
    if (price <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter a valid price.")),
      );
      return;
    }

    setState(() => _publishing = true);
    try {
      final imageUrl = _imageUrlController.text.trim().isEmpty ? null : _imageUrlController.text.trim();
      final res = await ApiService.createProductWithImage(
        product_name: _nameController.text.trim(),
        description: _descController.text.trim(),
        price: price,
        stock_quantity: 0,
        category_id: _selectedCategoryId,
        image_url: imageUrl,
        imageBytes: _selectedFile?.bytes,
        imageFileName: _selectedFile?.name,
      );
      final productId = res['productId'] as int?;
      if (productId == null) throw Exception('No product ID returned');

      final sectionKey = _sectionToApiKey[widget.sectionTitle];
      if (sectionKey != null) {
        await ApiService.updateProductSections(productId, {sectionKey: true});
      }

      final productData = {
        "name": _nameController.text.trim(),
        "price": _priceController.text.trim(),
        "desc": _descController.text.trim(),
        "category": () {
          for (final c in _categories) {
            if (c['category_id'] == _selectedCategoryId) return (c['category_name'] ?? '').toString();
          }
          return '';
        }(),
        "image": _selectedFile,
        "imageUrl": imageUrl ?? (res['image_url']?.toString()),
      };
      provider.addProduct(widget.sectionTitle, productData);

      _nameController.clear();
      _priceController.clear();
      _descController.clear();
      _imageUrlController.clear();
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
}
