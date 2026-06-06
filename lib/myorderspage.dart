import 'package:flutter/material.dart';

class MyOrdersPage extends StatefulWidget {
  const MyOrdersPage({super.key});

  @override
  State<MyOrdersPage> createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage> {
  List<Map<String, dynamic>> orders = [
    {
      'title': 'Dog Food Premium',
      'quantity': '2',
      'status': 'Processing',
    },
    {
      'title': 'Cat Toy',
      'quantity': '1',
      'status': 'Delivered',
    },
    {
      'title': 'Pet Shampoo',
      'quantity': '1',
      'status': 'Shipping',
    },
  ];

  Color getStatusColor(String status) {
    switch (status) {
      case "Delivered":
        return Colors.green;

      case "Processing":
        return Colors.orange;

      case "Shipping":
        return Colors.blue;

      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),

      appBar: AppBar(
        title: const Text("My Orders"),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),

      body: orders.isEmpty
          ? const Center(
              child: Text(
                "No Orders Found",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            )
          : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 8,
                  ),
                  elevation: 3,
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.orange,
                      child: Icon(
                        Icons.shopping_bag,
                        color: Colors.white,
                      ),
                    ),

                    title: Text(
                      orders[index]['title'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    subtitle: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 5),

                        Text(
                          "Quantity: ${orders[index]['quantity']}",
                        ),

                        const SizedBox(height: 8),

                        Container(
                          padding:
                              const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: getStatusColor(
                              orders[index]['status'],
                            ),
                            borderRadius:
                                BorderRadius.circular(10),
                          ),
                          child: Text(
                            orders[index]['status'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
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
}