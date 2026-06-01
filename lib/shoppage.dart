import 'package:flutter/material.dart';
import 'main.dart';

const Color primaryOrange = Color(0xFFFF9800);
const Color darkSlateText = Color(0xFF1E293B);

class ProductItem {
  final String id;
  final String name;
  final double price;
  final double rating;
  final int reviews;
  final String description;
  final String image;

  const ProductItem({
    required this.id, 
    required this.name, 
    required this.price, 
    required this.rating, 
    required this.reviews, 
    required this.description,
    required this.image,
  });
}

class ShopPage extends StatefulWidget {
  const ShopPage({Key? key}) : super(key: key);

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  final List<ProductItem> allProducts = const [
    ProductItem(
      id: '1', 
      name: 'Premium Dog Food', 
      price: 45.99, 
      rating: 4.8, 
      reviews: 234, 
      description: 'High-quality nutrition for your furry friend with real chicken and vegetables.',
      image: 'https://images.unsplash.com/photo-1589924691126-022f12796414?w=400&q=80',
    ),
    ProductItem(
      id: '2', 
      name: 'Cat Scratching Post', 
      price: 29.99, 
      rating: 4.6, 
      reviews: 189, 
      description: 'Durable sisal rope post to keep your cat entertained and save your furniture.',
      image: 'https://images.unsplash.com/photo-1545249390-6bdfa286032f?w=400&q=80',
    ),
    ProductItem(
      id: '3', 
      name: 'Bird Cage Deluxe', 
      price: 89.99, 
      rating: 4.7, 
      reviews: 142, 
      description: 'Spacious cage with multiple perches and feeding stations for happy birds.',
      image: 'https://images.unsplash.com/photo-1607990283143-e81e7a2c93ab?w=400&q=80',
    ),
    ProductItem(
      id: '4', 
      name: 'Aquarium Starter Kit', 
      price: 129.99, 
      rating: 4.9, 
      reviews: 312, 
      description: 'Complete 20-gallon setup with filter, heater, and LED lighting.',
      image: 'https://images.unsplash.com/photo-1522069169874-c58ec4b76be5?w=400&q=80',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), 
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: darkSlateText),
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const MainLayout()),
              (route) => false,
            );
          },
        ),
        title: const Text(
          'All Products',
          style: TextStyle(
            color: darkSlateText,
            fontSize: 20,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: true,
        shape: const Border(
          bottom: BorderSide(color: Color(0xFFE2E8F0), width: 1),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: allProducts.length,
        itemBuilder: (context, index) {
          final product = allProducts[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24), 
              border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0F172A).withOpacity(0.03), 
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16), 
                    child: Image.network(
                      product.image, 
                      width: 100, 
                      height: 100, 
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 100,
                          height: 100,
                          color: const Color(0xFFF1F5F9),
                          child: const Icon(Icons.image, color: Colors.grey),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name, 
                          style: const TextStyle(
                            fontWeight: FontWeight.w800, 
                            fontSize: 16,
                            color: darkSlateText,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Color(0xFFFFB800), size: 15),
                            const SizedBox(width: 4),
                            Text(
                              '${product.rating}', 
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: darkSlateText),
                            ),
                            Text(
                              ' (${product.reviews})', 
                              style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          product.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF64748B),
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '\$${product.price}', 
                              style: const TextStyle(
                                fontSize: 18, 
                                fontWeight: FontWeight.w900, 
                                color: primaryOrange,
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryOrange,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                minimumSize: const Size(70, 36),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ), 
                              ),
                              onPressed: () {},
                              child: const Text(
                                'Add', 
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
                              ),
                            ),
                          ],
                        ),
                      ],
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
}