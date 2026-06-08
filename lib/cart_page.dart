import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'cart_provider.dart';
import 'stripe_service.dart';
import 'purchase_history_page.dart';

class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);

  Widget buildProductImage(String image) {
    if (image.startsWith('data:image')) {
      final base64Str = image.split(',').last;
      return Image.memory(base64Decode(base64Str));
    } else {
      return Image.network(image);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Cart',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Consumer<CartProvider>(
        builder: (context, cart, child) {
          if (cart.items.isEmpty) {
            return const Center(
              child: Text(
                'Your cart is empty 🐾',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cart.items.length,
                  itemBuilder: (context, index) {
                    final cartItem = cart.items[index];
                    return ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: SizedBox(
                          width: 50,
                          height: 50,
                          child: buildProductImage(cartItem.product.image),
                        ),
                      ),
                      title: Text(
                        cartItem.product.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Qty: ${cartItem.quantity}   |   \$${cartItem.product.price}',
                      ),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                        ),
                        onPressed: () => cart.removeFromCart(cartItem.product),
                      ),
                    );
                  },
                ),
              ),

              // Bottom Checkout Section
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade200,
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total:',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '\$${cart.totalPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () async {
                          int amountInCents = (cart.totalPrice * 100).toInt();
                          
                          // 1. Trigger Stripe and wait for the result
                          bool isSuccess = await StripeService.makePayment(
                            context,
                            amountInCents.toString(),
                          );

                          // 2. If successful, save to Firebase and navigate
                          if (isSuccess && context.mounted) {
                            
                            // Save to Firestore
                            await FirebaseFirestore.instance.collection('orders').add({
                              'totalAmount': cart.totalPrice,
                              'orderDate': DateTime.now().toIso8601String(),
                              'status': 'Paid',
                              'items': cart.items.map((cartItem) => {
                                'name': cartItem.product.name,
                                'quantity': cartItem.quantity,
                                'price': cartItem.product.price,
                                'image': cartItem.product.image,
                              }).toList(),
                            });

                            // Empty the cart
                            cart.clearCart();

                            // Navigate to History page
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const PurchaseHistoryPage()),
                            );
                          }
                        },
                        child: const Text(
                          'Checkout',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}