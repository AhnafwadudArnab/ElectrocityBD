import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// আপনার প্রোজেক্টের পাথ অনুযায়ী ইমপোর্ট করুন
// import 'path_to_your_provider/product_provider.dart';
import '../Provider/Admin_product_provider.dart';
import 'Admin_sidebar.dart';
import 'admin_dashboard_page.dart';
import 'A_orders.dart';

class AdminProductUploadPage extends StatelessWidget {
  const AdminProductUploadPage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color darkBg = Color(0xFF0B121E);
    const Color cardBg = Color(0xFF151C2C);

    final List<String> sectionTitles = [
      "Best Sellings",
      "Flash Sale",
      "Trending Items",
      "Deals of the Day",
      "Tech Part",
    ];

    return Scaffold(
      backgroundColor: darkBg,
      body: Row(
        children: [
          AdminSidebar(
            selected: AdminSidebarItem.products,
            onItemSelected: (item) {
              if (item == AdminSidebarItem.products) return;
              if (item == AdminSidebarItem.dashboard) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AdminDashboardPage()),
                );
              } else if (item == AdminSidebarItem.orders) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AdminOrdersPage()),
                );
              } // ... অন্য ন্যাভিগেশন গুলো এখানে থাকবে
            },
          ),
          Expanded(
            child: Column(
              children: [
                Container(
                  height: 70,
                  color: cardBg,
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: const Center(
                    child: Text(
                      "Inventory Control & Upload",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
            ),
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
  String _selectedCategory = 'Home Utility';
  PlatformFile? _selectedFile;

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
                    DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      dropdownColor: fieldBg,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: fieldBg,
                        border: InputBorder.none,
                      ),
                      items:
                          [
                                'Home Utility',
                                'Personal Care',
                                'Kitchen',
                                'Cooling',
                              ]
                              .map(
                                (c) =>
                                    DropdownMenuItem(value: c, child: Text(c)),
                              )
                              .toList(),
                      onChanged: (v) => setState(() => _selectedCategory = v!),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _handlePublish(productProvider),
            style: ElevatedButton.styleFrom(
              backgroundColor: brandOrange,
              minimumSize: const Size(double.infinity, 50),
            ),
            child: const Text(
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
                  trailing: const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 16,
                  ),
                );
              },
            ),
          ],
        ],
      ),
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

  // পাবলিশ করার ফাংশন
  void _handlePublish(AdminProductProvider provider) {
    if (_nameController.text.isEmpty || _priceController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Product name and price required!")));
      return;
    }
    if (_selectedFile == null && (_imageUrlController.text.trim().isEmpty)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Add an image (file or URL)!")));
      return;
    }

    final productData = {
      "name": _nameController.text.trim(),
      "price": _priceController.text.trim(),
      "desc": _descController.text.trim(),
      "category": _selectedCategory,
      "image": _selectedFile,
      "imageUrl": _imageUrlController.text.trim().isEmpty ? null : _imageUrlController.text.trim(),
    };

    provider.addProduct(widget.sectionTitle, productData);

    // ফর্ম ক্লিয়ার করা
    _nameController.clear();
    _priceController.clear();
    _descController.clear();
    _imageUrlController.clear();
    setState(() => _selectedFile = null);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text("${widget.sectionTitle}-এ আপলোড সফল হয়েছে!"),
      ),
    );
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
