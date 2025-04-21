class Product {
  final String id;  // MongoDB _id
  final String name;
  final double price;
  final String description;
  final String image;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.image,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'],
    name: json['name'] ?? '',
    price: (json['price'] as num).toDouble(),
    description: json['description'] ?? '',
    image: json['image']??'',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      '_id': id,  // Include _id when sending updates to the backend
      'name': name,
      'price': price,
      'description': description,
      'image': image,
    };
  }
  
}
