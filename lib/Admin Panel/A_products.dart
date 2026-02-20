import 'package:flutter/material.dart';

class AdminProductUploadPage extends StatefulWidget {
  final String sectionTitle;
  const AdminProductUploadPage({super.key, required this.sectionTitle});

  @override
  State<AdminProductUploadPage> createState() => _ProductUploadFormState();
}

class _ProductUploadFormState extends State<AdminProductUploadPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  String _selectedCategory = 'Home Utility';

  @override
  Widget build(BuildContext context) {
    const Color darkBg = Color(0xFF0B121E);
    const Color cardBg = Color(0xFF151C2C);
    const Color brandOrange = Color(0xFFF59E0B);

    return Scaffold(
      backgroundColor: darkBg,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              Text(
                widget.sectionTitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Fill in the details to update your real-time inventory.",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 32),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left: Form
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _formLabel("Product Name"),
                          _customTextField(
                            _nameController,
                            "e.g., Rice cooker, Trimmer...",
                          ),
                          const SizedBox(height: 20),
                          _formLabel("Price (BDT)"),
                          _customTextField(
                            _priceController,
                            "e.g., 5500",
                            isNumber: true,
                          ),
                          const SizedBox(height: 20),
                          _formLabel("Description"),
                          _customTextField(
                            _descController,
                            "Enter product specifications...",
                            maxLines: 5,
                          ),
                          const SizedBox(height: 32),
                          ElevatedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Product Uploaded Successfully!",
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: brandOrange,
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              "Publish Product",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 32),
                  // Right: Image & Category
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: cardBg,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.cloud_upload_outlined,
                                color: Colors.grey,
                                size: 48,
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                "Upload Product Image",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                "PNG, JPG up to 10MB",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 16),
                              OutlinedButton(
                                onPressed: () {},
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: brandOrange),
                                ),
                                child: Text(
                                  "Select File",
                                  style: TextStyle(color: brandOrange),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.all(24),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: cardBg,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _formLabel("Category"),
                              Theme(
                                data: Theme.of(
                                  context,
                                ).copyWith(canvasColor: cardBg),
                                child: DropdownButton<String>(
                                  value: _selectedCategory,
                                  isExpanded: true,
                                  underline: Container(),
                                  style: const TextStyle(color: Colors.white),
                                  items:
                                      [
                                            'Home Utility',
                                            'Personal Care',
                                            'Kitchen',
                                            'Cooling',
                                          ]
                                          .map(
                                            (cat) => DropdownMenuItem(
                                              value: cat,
                                              child: Text(cat),
                                            ),
                                          )
                                          .toList(),
                                  onChanged: (val) =>
                                      setState(() => _selectedCategory = val!),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _formLabel(String label) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      label,
      style: const TextStyle(
        color: Colors.grey,
        fontSize: 13,
        fontWeight: FontWeight.bold,
      ),
    ),
  );

  Widget _customTextField(
    TextEditingController controller,
    String hint, {
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
        hintStyle: const TextStyle(color: Colors.white24),
        filled: true,
        fillColor: const Color(0xFF0B121E),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
