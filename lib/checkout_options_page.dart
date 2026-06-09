import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'editprofilepage.dart';
import 'stripe_service.dart';
import 'cart_provider.dart';

class CheckoutOptionsPage extends StatefulWidget {
  const CheckoutOptionsPage({Key? key}) : super(key: key);

  @override
  State<CheckoutOptionsPage> createState() => _CheckoutOptionsPageState();
}

class _CheckoutOptionsPageState extends State<CheckoutOptionsPage> {
  String _deliveryOption = 'pickup';
  String _deliveryAddress = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadAddress();
  }

  Future<void> _loadAddress() async {
    final prefs = await SharedPreferences.getInstance();
    final savedAddress = prefs.getString('address') ?? '';
    if (savedAddress.isNotEmpty) {
      setState(() {
        _deliveryAddress = savedAddress;
      });
    }
  }

  Future<void> _onChangeAddress() async {
    final User? user = FirebaseAuth.instance.currentUser;
    final prefs = await SharedPreferences.getInstance();
    final currentAddress = prefs.getString('address') ?? '';

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditProfilePage(
          firstName: '',
          lastName: '',
          email: user?.email ?? '',
          phone: '',
          address: currentAddress,
        ),
      ),
    );

    if (result != null && result is Map) {
      final newAddress = (result['address'] as String?) ?? '';
      final prefs2 = await SharedPreferences.getInstance();
      if (newAddress.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Address cannot be empty.')),
          );
        }
        return;
      }

      await prefs2.setString('address', newAddress);
      setState(() {
        _deliveryAddress = newAddress;
        _deliveryOption = 'delivery';
      });
    }
  }

  Future<void> _onProceedToPayment() async {
    if (_deliveryOption == 'delivery') {
      if (_deliveryAddress.isEmpty) {
        if (mounted) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please save your delivery address first.')),
          );
        }
        await _onChangeAddress();
        return;
      }
    }

    if (_deliveryOption == 'delivery' && _deliveryAddress.isEmpty) {
      await _onChangeAddress();
      return;
    }

    setState(() => _isLoading = true);

    final cart = context.read<CartProvider>();
    final amountInCents = (cart.totalPrice * 100).toInt();

    try {
      final isSuccess = await StripeService.makePayment(context, amountInCents.toString());

      if (isSuccess && mounted) {
        final userId = FirebaseAuth.instance.currentUser!.uid;
        final addressToSave = _deliveryOption == 'delivery'
            ? _deliveryAddress
            : 'Taman Universiti, Pura Kencana, Batu Pahat, Johor';

        await FirebaseFirestore.instance.collection('orders').add({
          'userId': userId,
          'items': cart.items.map((cartItem) => {
            'name': cartItem.product.name,
            'quantity': cartItem.quantity,
            'price': cartItem.product.price,
            'image': cartItem.product.image,
          }).toList(),
          'totalAmount': cart.totalPrice,
          'deliveryOption': _deliveryOption,
          'address': addressToSave,
          'status': 'Paid',
          'createdAt': FieldValue.serverTimestamp(),
        });

        cart.clearCart();
        if (mounted) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            '/',
            (route) => route.isFirst,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Checkout error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delivery Options', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'How would you like to receive your order?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            _buildDeliveryOptionTile(
              title: 'Home Delivery',
              icon: Icons.delivery_dining,
              value: 'delivery',
              description: _deliveryAddress.isEmpty
                  ? 'No address saved — tap to add'
                  : _deliveryAddress,
              trailing: _deliveryOption == 'delivery'
                  ? TextButton(
                      onPressed: _onChangeAddress,
                      child: const Text('Change Address'),
                    )
                  : null,
            ),

            const SizedBox(height: 12),

            _buildDeliveryOptionTile(
              title: 'Self Pickup',
              icon: Icons.store,
              value: 'pickup',
              description: 'Taman Universiti, Pura Kencana, Batu Pahat, Johor',
              trailing: null,
            ),

            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    _deliveryOption == 'delivery' ? Icons.delivery_dining : Icons.store,
                    color: Colors.orange,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _deliveryOption == 'delivery'
                          ? 'Selected: Home Delivery\n${_deliveryAddress.isEmpty ? "Address not set" : _deliveryAddress}'
                          : 'Selected: Self Pickup\nTaman Universiti, Pura Kencana, Batu Pahat, Johor',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _onProceedToPayment,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Text(
                    'Proceed to Payment',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeliveryOptionTile({
    required String title,
    required IconData icon,
    required String value,
    required String description,
    Widget? trailing,
  }) {
    final isSelected = _deliveryOption == value;
    return GestureDetector(
      onTap: () async {
        if (value == 'delivery' && _deliveryAddress.isEmpty) {
          await _loadAddress();
          if (_deliveryAddress.isEmpty) {
            await _onChangeAddress();
          }
          if (_deliveryAddress.isEmpty) return;
        }
        setState(() => _deliveryOption = value);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.orange : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? Colors.orange : Colors.grey, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? Colors.orange : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (trailing != null) trailing,
            Radio<String>(
              value: value,
              groupValue: _deliveryOption,
              onChanged: (newValue) async {
                if (newValue == 'delivery' && _deliveryAddress.isEmpty) {
                  await _loadAddress();
                  if (_deliveryAddress.isEmpty) {
                    await _onChangeAddress();
                    return;
                  }
                }
                setState(() => _deliveryOption = newValue!);
              },
              activeColor: Colors.orange,
            ),
          ],
        ),
      ),
    );
  }
}
