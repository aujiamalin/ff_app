import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart_provider.dart';
import 'main.dart';
import 'about_us_page.dart';
import 'product_data.dart';

// 1. Color Palette Definitions
const Color primaryOrange = Color(0xFFFF9800);
const Color gradientOrangeEnd = Color(0xFFF57C00);
const Color communityBlueStart = Color(0xFF3B82F6);
const Color communityBlueEnd = Color(0xFF06B6D4);
const Color darkSlateText = Color(0xFF1E293B);

// 2. Typography Styles 
const TextStyle largeWelcomeTitleStyle = TextStyle(
  color: Colors.white,
  fontSize: 24,
  fontWeight: FontWeight.w800,
  letterSpacing: -0.5, 
);

const TextStyle sectionTitleStyle = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w800,
  color: darkSlateText,
  letterSpacing: -0.3,
);

const TextStyle productNameStyle = TextStyle(
  fontWeight: FontWeight.w700,
  fontSize: 15,
  color: darkSlateText,
  letterSpacing: -0.2,
);

const TextStyle priceTextStyle = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w900, 
  color: primaryOrange,
  letterSpacing: -0.2,
);

class CategoryItem {
  final String id;
  final String name;
  final String icon; 
  final Color color;

  const CategoryItem({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });
}



const List<CategoryItem> categories = [
  CategoryItem(
    id: 'dogs',
    name: 'Dogs',
    icon: 'https://cdn-icons-png.flaticon.com/512/616/616554.png',
    color: Color(0xFFFFF7ED),
  ),
  CategoryItem(
    id: 'cats',
    name: 'Cats',
    icon: 'https://cdn-icons-png.flaticon.com/512/8277/8277431.png',
    color: Color(0xFFF1F5F9),
  ),
  CategoryItem(
    id: 'birds',
    name: 'Birds',
    icon: 'https://cdn-icons-png.flaticon.com/512/2832/2832126.png',
    color: Color(0xFFFEFCE8),
  ),
  CategoryItem(
    id: 'fish',
    name: 'Fish',
    icon: 'https://cdn-icons-png.flaticon.com/512/2970/2970068.png',
    color: Color(0xFFEFF6FF),
  ),
  CategoryItem(
    id: 'small-pets',
    name: 'Small Pets',
    icon: 'https://cdn-icons-png.flaticon.com/512/12910/12910447.png',
    color: Color(0xFFFDF2F8),
  ),
];




class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  // Cart action handler simulation
  void _addToCart(BuildContext context, ProductItem product) {
    // Tells the provider to add the item
    Provider.of<CartProvider>(context, listen: false).addToCart(product);
  
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} added to cart! 🛒'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  // Routing and navigation simulation
  void _navigate(BuildContext context, String route) {
    print('Navigating to: $route');
  }

  @override
  Widget build(BuildContext context) {
    final featuredProducts = allProducts.take(5).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 12.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderBar(context),
                const SizedBox(height: 20),
                _buildWelcomeGradientBox(),
                const SizedBox(height: 24),
                _buildQuickActionGrid(context),
                const SizedBox(height: 24),
                const Text('Shop by Pet', style: sectionTitleStyle),
                const SizedBox(height: 14),
                _buildCategoryListGrid(context),
                const SizedBox(height: 28),
                _buildFeaturedSubHeader(context),
                const SizedBox(height: 14),
                _buildProductListView(featuredProducts, context),
                const SizedBox(height: 24),
                _buildCommunityBannerBox(context),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildHeaderBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16), 
              child: Image.asset(
                'assets/logo.png', 
                width: 65, 
                height: 65,
                fit: BoxFit.contain, 
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Fluffy Friend',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 20,
                color: darkSlateText,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
  
        // 👇 REPLACED THE SINGLE ICON WITH A ROW OF TWO ICONS
        Row(
          children: [
            // 1. Live Cart Icon
            GestureDetector(
              onTap: () => MainLayout.changeTab(context, 2), // Changes bottom nav to Cart Tab
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Icon(
                      Icons.shopping_cart_outlined,
                      color: Colors.grey.shade800,
                      size: 22,
                    ),
                  ),
                  // The Live Badge counter!
                  Consumer<CartProvider>(
                    builder: (context, cart, child) {
                      if (cart.items.isEmpty) return const SizedBox.shrink(); // Hide if empty
                      return Positioned(
                        right: 0, // Brought safely inside the boundary
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 18, // Forces it to be visible
                            minHeight: 18,
                          ),
                          child: Center(
                            child: Text(
                              '${cart.items.length}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                height: 1, // Fixes weird text centering on web
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            
            // 2. Existing Notification Icon
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Icon(
                Icons.notifications_none_outlined,
                color: Colors.grey.shade800,
                size: 22,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWelcomeGradientBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          24,
        ),
        gradient: const LinearGradient(
          colors: [primaryOrange, gradientOrangeEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: primaryOrange.withOpacity(0.25),
            blurRadius: 20,
            offset: const Offset(
              0,
              8,
            ), 
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Welcome to Fluffy Friend! 🐾',
            style: largeWelcomeTitleStyle,
          ),
          const SizedBox(height: 8),
          Text(
            'Everything your pet needs, delivered to your door',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 18),
          _buildSearchBarInput(),
        ],
      ),
    );
  }

  Widget _buildSearchBarInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(99),
      ),
      child: TextField(
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Search for products...',
          hintStyle: const TextStyle(color: Colors.white70, fontSize: 14),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.white.withOpacity(0.8),
            size: 20,
          ),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

Widget _buildQuickActionGrid(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 14,
      mainAxisSpacing: 14,
      childAspectRatio: 1.50,
      children: [
        _buildActionCard(
          context,
          'Bundles',
          Icons.layers_outlined,
          const Color(0xFFFFF4E6),
          const Color(0xFFFF9800),
          '',
        ),

        _buildActionCard(
          context,
          'Subscribe',
          Icons.autorenew_rounded,
          const Color(0xFFEBF3FF),
          const Color(0xFF2563EB),
          'subscription', 
        ),

        _buildActionCard(
          context,
          'Rewards',
          Icons.card_giftcard_outlined,
          const Color(0xFFFFFBEA),
          const Color(0xFFD97706),
          '',
        ),

        _buildActionCard(
          context,
          'About Us',
          Icons.info_outline_rounded,
          const Color(0xFFF3E8FF), // Soft purple background
          const Color(0xFF9333EA), // Deep purple icon
          'about', // The route keyword we will listen for
        ),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    String title,
    IconData icon,
    Color bgColor,
    Color iconColor,
    String route,
  ) {
    return Material(
      color: bgColor, 
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias, 
      child: InkWell(
        splashColor: iconColor.withOpacity(0.12),
        highlightColor: iconColor.withOpacity(0.05), 
        onTap: () {
          if (route == 'subscription') {
            MainLayout.changeTab(context, 4);
          } else if (route == 'about') {
            // 👇 ADDED THIS CONDITION TO OPEN YOUR PAGE
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AboutUsPage()),
            );
          } else if (route.isNotEmpty) {
            _navigate(context, route);
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 4,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, color: iconColor, size: 22),
              const SizedBox(height: 6),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

 Widget _buildCategoryListGrid(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 14,
      mainAxisSpacing: 14,
      childAspectRatio: 0.95,
      children: categories.take(6).map((category) {
        return InkWell(
          onTap: () {
            if (category.name == 'Dogs') {
              MainLayout.changeTab(context, 5, category: 'Dog');
            } else if (category.name == 'Cats') {
              MainLayout.changeTab(context, 5, category: 'Cat');
            } else if (category.name == 'Fish') {
              MainLayout.changeTab(context, 5, category: 'Fish');
            } else if (category.name == 'Birds') {
              MainLayout.changeTab(context, 5, category: 'Bird');
            } else if (category.name == 'Small Pets') {
              MainLayout.changeTab(context, 5, category: 'Small Pets');
            } else {
              _navigate(context, '/products/${category.id}');
            }
          },
          borderRadius: BorderRadius.circular(24),
          child: Container(
            decoration: BoxDecoration(
              color: category.color,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: const Color(0xFFE2E8F0),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0F172A).withOpacity(0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                  category.icon,
                  width: 44,
                  height: 44,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 10),
                Text(
                  category.name,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFeaturedSubHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Featured Products', style: sectionTitleStyle),
        InkWell(
          onTap: () {
            MainLayout.changeTab(context, 1);
          },
          child: const Text(
            'See All',
            style: TextStyle(
              color: primaryOrange,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductListView(
    List<ProductItem> featuredProducts,
    BuildContext context,
  ) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: featuredProducts.length,
      itemBuilder: (context, index) {
        final product = featuredProducts[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: const Color(
                  0xFF0F172A,
                ).withOpacity(0.04),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
            border: Border.all(color: const Color(0xFFF1F5F9)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => _navigate(context, '/product/${product.id}'),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      product.image,
                      width: 90,
                      height: 90,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () =>
                            _navigate(context, '/product/${product.id}'),
                        child: Text(
                          product.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: productNameStyle,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: Color(0xFFFFB800),
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${product.rating}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            ' (${product.reviews})',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('\$${product.price}', style: priceTextStyle),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryOrange,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              minimumSize: const Size(64, 34),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () => _addToCart(context, product),
                            child: const Text(
                              'Add',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
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
    );
  }

  Widget _buildCommunityBannerBox(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [communityBlueStart, communityBlueEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: communityBlueStart.withOpacity(0.2),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Join Our Community 🎉',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Get exclusive deals and pet care tips',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF2563EB),
                elevation: 2,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () => _navigate(context, '/membership'),
              child: const Text(
                'Become a Member',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}