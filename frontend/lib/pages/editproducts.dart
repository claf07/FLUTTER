import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../product_provider.dart';
import '../models/product.dart';

class EditProductsScreen extends StatefulWidget {
  @override
  _EditProductsScreenState createState() => _EditProductsScreenState();
}

class _EditProductsScreenState extends State<EditProductsScreen> {
  File? _pickedImage;
  final picker = ImagePicker();

  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<ProductsProvider>().fetchProducts());
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductsProvider>();
    final products = provider.products;
    final isLoading = provider.isLoading;

    return Scaffold(
      backgroundColor: const Color(0xFFfde2f3),
      appBar: AppBar(
        title: const Text(
          "Edit Products",
          style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 10,
        backgroundColor: const Color(0xfffbcfe8),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : products.isEmpty
              ? Center(child: Text('No Products Available'))
              : ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (ctx, i) {
                    final product = products[i];
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                      child: ListTile(
                        leading: Image.network(
                          product.image,
                          width: 50,
                          height: 50,
                          fit: BoxFit.fill,
                        ),
                        title: Text(product.name),
                        subtitle: Text('₹ ${product.price.toStringAsFixed(2)}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _showEditBottomSheet(product),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Color(0xffDB2777)),
                              onPressed: () => _confirmDelete(product.id),
                            ),
                          ],
                        ),
                        onTap: () => _showEditBottomSheet(product),
                      ),
                    );
                  },
                ),
    );
  }

  void _showEditBottomSheet(Product product) {
    _nameController.text = product.name;
    _priceController.text = product.price.toString();
    _descriptionController.text = product.description;
    _pickedImage = null;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Edit Product',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(height: 15),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Product Name'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 2,
              ),
              
              SizedBox(height: 10),
              if (_pickedImage != null)
                Image.file(
                  _pickedImage!,
                  height: 100,
                  width: 100,
                  fit: BoxFit.fill,
                )
              else
                Image.network(
                  product.image,
                  height: 150,
                  width: 150,
                  fit: BoxFit.fill,
                ),
                SizedBox(height: 20),
                
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: Icon(Icons.image),
                label: Text('Change Image'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Color(0xff2563EB),
                  backgroundColor: Color(0xFFfde2f3),
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
              SizedBox(height: 20),
              Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _editProduct(product),
                    child: Text('Save Changes'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Color(0xff2563EB),
                      backgroundColor: Color(0xFFfde2f3),
                      minimumSize: Size(double.infinity, 50),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _confirmDelete(product.id);
                    },
                    child: Text('Delete Product'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red,
                      minimumSize: Size(double.infinity, 50),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
          ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _editProduct(Product product) async {
    final name = _nameController.text.trim();
    final price = double.tryParse(_priceController.text.trim()) ?? 0;
    final description = _descriptionController.text.trim();
    String imageUrl = product.image;

    if (_pickedImage != null) {
      // Upload new image
      imageUrl = await context.read<ProductsProvider>().uploadImage(_pickedImage!);
    }

    if (name.isEmpty || price <= 0 || description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Fill all fields')));
      return;
    }

    await context.read<ProductsProvider>().editProduct(
      id: product.id,
      name: name,
      price: price,
      description: description,
      image: imageUrl,
    );

    Navigator.of(context).pop(); // Close the BottomSheet
  }

  Future<void> _confirmDelete(String productId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Confirm Delete'),
        content: Text('Are you sure you want to delete this product?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: Text('Cancel')),
          TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: Text('Delete')),
        ],
      ),
    );

    if (confirm == true) {
      await context.read<ProductsProvider>().deleteProduct(productId);
    }
  }
}
