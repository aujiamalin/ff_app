// product_data.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductItem {
  final String id;
  final String name;
  final double price;
  final double rating;
  final int reviews;
  final String image;
  final String description; // Now every product has a description!

  const ProductItem({
    required this.id,
    required this.name,
    required this.price,
    required this.rating,
    required this.reviews,
    required this.image,
    this.description =
        'A premium product for your fluffy friend.', // Default fallback text
  });

  // 2. TAMBAH FUNGSI UNTUK TUKAR DATA FIREBASE KEPADA OBJECT FLUTTER
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

// THIS IS YOUR MASTER INVENTORY
const List<ProductItem> allProducts = [
  ProductItem(
    id: '1',
    name: 'Premium Dog Food',
    price: 45.99,
    rating: 4.8,
    reviews: 234,
    description:
        'High-quality nutrition for your furry friend with real chicken and vegetables.',
    image:
        'https://images.unsplash.com/photo-1589924691126-022f12796414?w=400&q=80',
  ),
  ProductItem(
    id: '2',
    name: 'Cat Scratching Post',
    price: 29.99,
    rating: 4.6,
    reviews: 189,
    description:
        'Durable sisal rope post to keep your cat entertained and save your furniture.',
    image:
        'https://images.unsplash.com/photo-1545249390-6bdfa286032f?w=400&q=80',
  ),
  ProductItem(
    id: '3',
    name: 'Bird Cage Deluxe',
    price: 89.99,
    rating: 4.7,
    reviews: 142,
    description:
        'Spacious cage with multiple perches and feeding stations for happy birds.',
    image:
        'https://images.unsplash.com/photo-1607990283143-e81e7a2c93ab?w=400&q=80',
  ),
  ProductItem(
    id: '4',
    name: 'Aquarium Starter Kit',
    price: 129.99,
    rating: 4.9,
    reviews: 312,
    description:
        'Complete 20-gallon setup with filter, heater, and LED lighting.',
    image:
        'https://images.unsplash.com/photo-1522069169874-c58ec4b76be5?w=400&q=80',
  ),
  ProductItem(
    id: '5',
    name: 'Hamster Habitat',
    price: 39.99,
    rating: 4.5,
    reviews: 98,
    description: 'A fun and engaging multi-level habitat for small pets.',
    image:
        'https://images.unsplash.com/photo-1425082661705-1834bfd09dca?w=400&q=80',
  ),
  ProductItem(
    id: '6',
    name: 'Dog Chew Toys Set',
    price: 19.99,
    rating: 4.7,
    reviews: 445,
    description: 'Durable and safe chew toys for aggressive chewers.',
    image:
        'https://images.unsplash.com/photo-1576201836106-db1758fd1c97?w=400&q=80',
  ),
];
