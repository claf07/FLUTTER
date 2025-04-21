import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cloudinary_public/cloudinary_public.dart';
import '../models/product.dart';

class ProductsProvider extends ChangeNotifier {
  List<Product> _products = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  final CloudinaryPublic _cloudinary = CloudinaryPublic(
    'dqo2crjjn', // replace with your Cloudinary Cloud Name
    'Flutter_1', // replace with your Upload Preset
    cache: false,
  );

  final String baseUrl = 'http://192.168.147.210:3000/api/products';

  // Fetch products from API
  Future<void> fetchProducts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);
        _products = jsonData.map((json) => Product.fromJson(json)).toList();
      } else {
        _errorMessage = 'Failed to load products';
      }
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  // Upload Image to Cloudinary
  Future<String> uploadImage(File imageFile) async {
    try {
      final response = await _cloudinary.uploadFile(
        CloudinaryFile.fromFile(imageFile.path, resourceType: CloudinaryResourceType.Image),
      );
      return response.secureUrl;
    } catch (e) {
      throw Exception('Image upload failed: $e');
    }
  }

  // Add new product
  Future<void> addProduct({
    required String name,
    required double price,
    required String description,
    required File image,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final imageurl = await uploadImage(image);

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'price': price,
          'description': description,
          'image': imageurl,
        }),
      );

      if (response.statusCode == 201) {
        final product = Product.fromJson(jsonDecode(response.body));
        _products.add(product);
      } else {
        _errorMessage = 'Failed to add product';
      }
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  // Edit product
  Future<void> editProduct({
    required String id,
    required String name,
    required double price,
    required String description,
    required String image,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'price': price,
          'description': description,
          'imageurl': image,
        }),
      );

      if (response.statusCode == 200) {
        final updatedProduct = Product.fromJson(jsonDecode(response.body));
        int index = _products.indexWhere((product) => product.id == id);
        if (index != -1) {
          _products[index] = updatedProduct;
        }
      } else {
        _errorMessage = 'Failed to update product';
      }
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  // Delete product
  Future<void> deleteProduct(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));

      if (response.statusCode == 200) {
        _products.removeWhere((product) => product.id == id);
      } else {
        _errorMessage = 'Failed to delete product';
      }
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}
