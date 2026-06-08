import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PurchaseHistoryPage extends StatelessWidget {
  const PurchaseHistoryPage({Key? key}) : super(key: key);

  // Helper to handle both network and base64 images
  Widget _buildImage(String imageUrl) {
    if (imageUrl.startsWith('data:image')) {
      final base64Str = imageUrl.split(',').last;
      return Image.memory(base64Decode(base64Str), width: 50, height: 50, fit: BoxFit.cover);
    } else {
      return Image.network(imageUrl, width: 50, height: 50, fit: BoxFit.cover);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Purchase History', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      // StreamBuilder listens to the 'orders' collection in real-time
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .orderBy('orderDate', descending: true) // Show newest orders first
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No past purchases yet.', 
                style: TextStyle(fontSize: 18, color: Colors.grey)
              ),
            );
          }

          final orders = snapshot.data!.docs;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              var orderData = orders[index].data() as Map<String, dynamic>;
              
              // Format the timestamp nicely
              DateTime date = DateTime.parse(orderData['orderDate']).toLocal();
              String formattedDate = '${date.day}/${date.month}/${date.year} at ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
              
              List items = orderData['items'] ?? [];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 3,
                child: ExpansionTile(
                  leading: const Icon(Icons.receipt_long, color: Colors.orange, size: 32),
                  title: Text(
                    'Order: \$${orderData['totalAmount'].toStringAsFixed(2)}', 
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  subtitle: Text(formattedDate),
                  children: items.map((item) {
                    return ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: _buildImage(item['image']),
                      ),
                      title: Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('Qty: ${item['quantity']}'),
                      trailing: Text('\$${item['price']}'),
                    );
                  }).toList(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}