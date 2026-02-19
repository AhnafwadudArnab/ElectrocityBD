import 'package:flutter/material.dart';

class AdminUploadProductPage extends StatefulWidget {
  @override
  _AdminUploadProductPageState createState() => _AdminUploadProductPageState();
}

class _AdminUploadProductPageState extends State<AdminUploadProductPage> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _description = '';
  double _price = 0.0;
  String _imageUrl = '';

  void _uploadProduct() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Product uploaded: $_name')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Upload Product')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Product Name'),
                validator: (value) =>
                    value!.isEmpty ? 'Enter product name' : null,
                onSaved: (value) => _name = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) =>
                    value!.isEmpty ? 'Enter description' : null,
                onSaved: (value) => _description = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Enter price' : null,
                onSaved: (value) => _price = double.parse(value!),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Image URL'),
                validator: (value) => value!.isEmpty ? 'Enter image URL' : null,
                onSaved: (value) => _imageUrl = value!,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _uploadProduct,
                child: Text('Upload Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
