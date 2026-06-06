import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import 'cart_provider.dart';
import 'homepage.dart';
import 'shoppage.dart';
import 'subscriptionpage.dart';
import 'petcategorypage.dart';
import 'about_us_page.dart';
import 'location_page.dart';  
import 'cart_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async{
  Stripe.publishableKey = 'pk_test_51SpAeAA7ZCTbcmpDYhNZiZm4hvwfG01Asa7Pzzeu2DYGRWIskMw2tZPdFRQlAjV9DpECg2ak3pCOXAHJfnxKuU9200ru9kIGix';
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ChangeNotifierProvider(
      create: (context) => CartProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fluffy Friend',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
        fontFamily: 'Inter',
      ),
      home: const MainLayout(),
    );
  }
}

class MainLayout extends StatefulWidget {
  final int initialIndex;
  const MainLayout({Key? key, this.initialIndex = 0}) : super(key: key);

  static void changeTab(BuildContext context, int index, {String? category}) {
    final _MainLayoutState? state = context.findAncestorStateOfType<_MainLayoutState>();
    if (state != null) {
      state.updateIndex(index, category: category);
    }
  }

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  late int _selectedIndex;
  String _activeCategory = 'Dog';

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void updateIndex(int index, {String? category}) {
    setState(() {
      _selectedIndex = index;
      if (category != null) {
        _activeCategory = category;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _screens = [
      const HomePage(),
      const ShopPage(),
      const CartPage(),
      const Center(child: Text('Profile Screen')),
      const SubscriptionPage(),
      PetCategoryPage(categoryName: _activeCategory),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex > 3 ? 0 : _selectedIndex,
        selectedItemColor: const Color(0xFFFF9800),
        unselectedItemColor: const Color(0xFF94A3B8),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: 'Shop'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}