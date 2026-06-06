import 'package:cloud_firestore/cloud_firestore.dart';

class ProductItem {
  final String id;
  final String name;
  final double price;
  final double rating;
  final int reviews;
  final String image;
  final String description;

  const ProductItem({
    required this.id,
    required this.name,
    required this.price,
    required this.rating,
    required this.reviews,
    required this.image,
    this.description = 'A premium product for your fluffy friend.',
  });

  // This is the magic function! It takes a raw Firebase document 
  // and turns it into a perfectly formatted ProductItem object.
  factory ProductItem.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    
    return ProductItem(
      id: doc.id,
      name: data['name'] ?? 'No Name',
      price: (data['price'] ?? 0.0).toDouble(),
      rating: (data['rating'] ?? 5.0).toDouble(),
      reviews: data['reviews'] ?? 0,
      description: data['description'] ?? 'No description available.',
      image: data['image'] ?? 'https://via.placeholder.com/150',
    );
  }
}

// 👇 NOTE: The const List<ProductItem> allProducts has been DELETED entirely!