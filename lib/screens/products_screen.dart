// lib/screens/products_screen.dart
import 'package:flutter/material.dart';
import 'package:mscomputersangola/services/firebase_service.dart';
import 'package:mscomputersangola/services/mock_data_service.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  List<String> _categories = [];
  String _selectedCategory = 'All';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
    _setupRealtimeListeners();
  }

  void _setupRealtimeListeners() {
    // Listen to real-time product updates
    _firebaseService.getProductsStream().listen((products) {
      if (mounted) {
        setState(() {
          _allProducts = products;
          _filterProducts(_selectedCategory);
        });
      }
    });
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Load initial data (will be replaced by real-time updates)
      List<Product> products = await _firebaseService.getAllProducts();
      List<String> categories = await _firebaseService.getCategories();

      if (mounted) {
        setState(() {
          _allProducts = products;
          _filteredProducts = products;
          _categories = ['All', ...categories];
          _isLoading = false;
        });
      }
    } catch (e) {
      // Use mock data if Firebase fails (real-time listeners will still work once connected)
      print('Firebase initial load failed, using mock data: $e');
      if (mounted) {
        setState(() {
          _allProducts = MockDataService.getMockProducts();
          _filteredProducts = MockDataService.getMockProducts();
          _categories = ['All', ...MockDataService.getMockCategories()];
          _isLoading = false;
        });
      }
    }
  }

  void _filterProducts(String category) {
    setState(() {
      _selectedCategory = category;
      if (category == 'All') {
        _filteredProducts = _allProducts;
      } else {
        _filteredProducts = _allProducts.where((product) => product.category == category).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Column(
        children: [
          // Category Tabs
          Container(
            height: 60,
            margin: const EdgeInsets.all(10),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(_categories.length, (index) {
                  String category = _categories[index];
                  bool isSelected = category == _selectedCategory;
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    child: FilterChip(
                      label: Text(
                        category == 'All' ? 'All Products' : category,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                      ),
                      selected: isSelected,
                      onSelected: (selected) {
                        _filterProducts(category);
                      },
                      backgroundColor: Colors.grey.shade200,
                      selectedColor: const Color(0xFF0A4C80), // MS Blue
                      checkmarkColor: Colors.white,
                    ),
                  );
                }),
              ),
            ),
          ),

          // Products Grid/List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredProducts.isEmpty
                    ? const Center(
                        child: Text(
                          'No products found',
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(10),
                        child: GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 0.75, // Slightly less tall to prevent overflow
                          ),
                          itemCount: _filteredProducts.length,
                          itemBuilder: (context, index) {
                            Product product = _filteredProducts[index];
                            return _buildProductCard(product);
                          },
                        ),
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/order');
        },
        backgroundColor: const Color(0xFFCC0000), // MS Red
        child: const Icon(Icons.shopping_cart, color: Colors.white),
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
                image: DecorationImage(
                  image: NetworkImage(product.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // Product Details
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name (Marathi)
                  Text(
                    product.nameMarathi,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 5),

                  // Price
                  Text(
                    '₹${product.price}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0A4C80), // MS Blue
                    ),
                  ),

                  const SizedBox(height: 5),

                  // Stock Status
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: product.inStock ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      product.inStock ? 'उपलब्ध' : 'संपले',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Order Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: product.inStock ? () {
                        _launchWhatsAppWithProduct(product);
                      } : null, // Disable button if out of stock
                      style: ElevatedButton.styleFrom(
                        backgroundColor: product.inStock
                            ? const Color(0xFFCC0000) // MS Red for available
                            : Colors.grey, // Grey for out of stock
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(product.inStock ? 'Order Now' : 'Out of Stock'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
  Future<void> _launchWhatsAppWithProduct(Product product) async {
    String phoneNumber = '+918788028134'; // Default WhatsApp number
    String message = 'Hi, I want to order: ${product.nameMarathi}. Price: ₹${product.price}';
    final Uri url = Uri.parse('https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }
