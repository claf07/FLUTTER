import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // 👈 Import Provider
import '../product_provider.dart'; // 👈 Import your provider

class ViewProductsPage extends StatefulWidget {
  const ViewProductsPage({super.key});

  @override
  _ViewProductsPageState createState() => _ViewProductsPageState();
}

class _ViewProductsPageState extends State<ViewProductsPage> {
  @override
  void initState() {
    super.initState();
    // Fetch products as soon as the widget is initialized
    Future.delayed(Duration.zero, () {
      context.read<ProductsProvider>().fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFfde2f3),
      appBar: AppBar(
        title: const Text(
          "Products",
          style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 10,
        backgroundColor: const Color(0xfffbcfe8),
      ),
      body: Consumer<ProductsProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (provider.errorMessage != null) {
            return Center(child: Text('Error: ${provider.errorMessage}'));
          } else if (provider.products.isEmpty) {
            return const Center(child: Text("No Products Available!!"));
          } else {
            final products = provider.products;
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: GridView.builder(
                itemCount: products.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 0.7,
                ),
                itemBuilder: (context, index) {
                  final product = products[index];
                  print('Product des: ${product.description}');
                  print('Product Image URL: ${product.image}');
                  return GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.network(
                                        product.image ,
                                        height: MediaQuery.of(context).size.height * 0.4,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) =>
                                            const Icon(Icons.broken_image, size: 50),
                                        
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      product.name ,
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,),
                                          textAlign: TextAlign.center,
                                          
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '₹ ${product.price}',
                                      style: const TextStyle(
                                          color: Colors.green, fontSize: 16),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      product.description ,
                                      textAlign: TextAlign.justify,
                                    ),
                                    const SizedBox(height: 12),
                                    ElevatedButton(
                                      onPressed: () => Navigator.of(context).pop(),
                                      child: const Text("Close"),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18)),
                      elevation: 5,
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(18)),
                            child: Image.network(
                              product.image,
                              height: 120,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.broken_image,
                                      size: 50, color: Colors.grey),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              product.name ,
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              '₹ ${product.price}',
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xff007f5f),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              product.description ,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
