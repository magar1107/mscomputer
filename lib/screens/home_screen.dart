// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mscomputersangola/services/firebase_service.dart';
import 'package:mscomputersangola/services/mock_data_service.dart';
import 'package:mscomputersangola/models/banner.dart';
import 'package:mscomputersangola/models/product.dart';
import 'package:mscomputersangola/models/contact.dart';
import 'package:mscomputersangola/widgets/custom_app_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  BannerData? _bannerData;
  List<Product> _products = [];
  ContactInfo? _contactInfo;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
    _setupRealtimeListeners();
  }

  void _setupRealtimeListeners() {
    // Listen to real-time product updates
    _firebaseService.getProductsStream().listen((products) {
      if (mounted) {
        setState(() {
          _products = products;
        });
        // Debug: Print image URLs to check if Firebase is providing valid URLs
        for (var product in products) {
          print('Product: ${product.nameMarathi}, ImageURL: ${product.imageUrl}');
        }
      }
    });

    // Listen to real-time banner updates
    _firebaseService.getBannerStream().listen((banner) {
      if (mounted) {
        setState(() {
          _bannerData = banner;
        });
      }
    });

    // Listen to real-time contact updates
    _firebaseService.getContactStream().listen((contact) {
      if (mounted) {
        setState(() {
          _contactInfo = contact;
        });
      }
    });
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Load initial data (will be replaced by real-time updates)
      final bannerFuture = _firebaseService.getBannerData();
      final productsFuture = _firebaseService.getAllProducts();
      final contactFuture = _firebaseService.getContactInfo();

      final results = await Future.wait([
        bannerFuture,
        productsFuture,
        contactFuture,
      ]);

      if (mounted) {
        setState(() {
          _bannerData = results[0] as BannerData?;
          _products = results[1] as List<Product>;
          _contactInfo = results[2] as ContactInfo?;
          _isLoading = false;
        });
      }
    } catch (e) {
      // If Firebase fails, use mock data (real-time listeners will still work once connected)
      print('Firebase initial load failed, using mock data: $e');
      if (mounted) {
        setState(() {
          _bannerData = MockDataService.getMockBannerData();
          _products = MockDataService.getMockProducts();
          _contactInfo = MockDataService.getMockContactInfo();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA), // Crisp Off-White background
      appBar: CustomAppBar(),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00695C)), // Deep Teal
              ),
            )
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  _buildHeroSection(),

                  // Category Grid Section - Card-based categories with hover effects
                  _buildCategoryGrid(),

                  // Brand Logos Section - Logo placeholders with hover animations
                  _buildBrandLogos(),
                  // Products Section - Featured products with enhanced styling
                  _buildProductsSection(),

                  // Services Section - Service cards with lift animations
                  _buildServicesSection(),

                  // EMI Banner Section - Moved under Home Delivery service
                  _buildEmiBanner(),

                  // Contact Section - Contact cards with enhanced buttons
                  _buildContactSection(),

                  // Footer - Enhanced footer design
                  _buildFooter(),
                ],
              ),
            ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 3,
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () {
            _launchWhatsApp();
          },
          backgroundColor: Colors.white,
          elevation: 0,
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: const DecorationImage(
                image: AssetImage('assets/images/image.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF00695C), Color(0xFF004D40)], // Deep Teal gradient
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _bannerData?.titleMarathi ?? 'तुम्हाला दर्जा आणि सेवा हवी असल्यास, एकमेव जागा...!',
              style: GoogleFonts.poppins(
                fontSize: 26,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                height: 1.3,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _bannerData?.subtitleMarathi ?? 'आपल्याकडे सर्व नवीन कॉम्प्युटर, लॅपटॉप, सीसीटीव्ही... एकदम स्वस्त दरात!',
              style: GoogleFonts.inter(
                fontSize: 16,
                color: Colors.white.withOpacity(0.95),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                Scrollable.ensureVisible(
                  _productsSectionKey.currentContext!,
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeInOut,
                );
              },
              icon: const Icon(Icons.shopping_cart, size: 20),
              label: Text(
                'Explore Products',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2196F3), // Electric Blue accent
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                elevation: 3,
                shadowColor: const Color(0xFF2196F3).withOpacity(0.3),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryGrid() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 20),
            child: Text(
              'Shop by Category',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
                letterSpacing: 0.5,
              ),
            ),
          ),
          GridView.count(
            crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: 1.0,
            children: [
              _buildCategoryCard(Icons.laptop, 'लॅपटॉप'),
              _buildCategoryCard(Icons.print, 'प्रिंटर'),
              _buildCategoryCard(Icons.videocam, 'सीसीटीव्ही'),
              _buildCategoryCard(Icons.storage, 'एसएसडी / हार्ड डिस्क'),
              _buildCategoryCard(Icons.memory, 'अ‍ॅक्सेसरीज'),
              _buildCategoryCard(Icons.desktop_mac, 'डेस्कटॉप'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(IconData icon, String title) {
    return InkWell(
      onTap: () {
        Scrollable.ensureVisible(
          _productsSectionKey.currentContext!,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: Colors.grey.shade200,
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF00695C).withOpacity(0.1), // Deep Teal background
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 36,
                color: const Color(0xFF00695C), // Deep Teal
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: GoogleFonts.poppins(
                color: Colors.grey.shade800,
                fontSize: 15,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmiBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF2196F3), // Electric Blue accent
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2196F3).withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.credit_card,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Column(
              children: [
                Text(
                  '0% EMI Available',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Bajaj Finserv',
                  style: GoogleFonts.inter(
                    color: Colors.white.withOpacity(0.95),
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBrandLogos() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 20),
            child: Text(
              'Trusted Brands',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
                letterSpacing: 0.5,
              ),
            ),
          ),
          SizedBox(
            height: 70,
            child: ListView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              children: [
                _buildBrandLogo('Lenovo'),
                _buildBrandLogo('HP'),
                _buildBrandLogo('ASUS'),
                _buildBrandLogo('Acer'),
                _buildBrandLogo('Dell'),
                _buildBrandLogo('MSI'),
                _buildBrandLogo('Apple'),
                _buildBrandLogo('Windows'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBrandLogo(String brandName) {
    return Container(
      margin: const EdgeInsets.only(right: 20),
      child: InkWell(
        onTap: () {}, // Brand interaction
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo placeholder - sophisticated design
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.computer,
                  size: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                brandName,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  final GlobalKey _productsSectionKey = GlobalKey();

  Widget _buildProductsSection() {
    return Container(
      key: _productsSectionKey,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Featured Products',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade800,
                    letterSpacing: 0.5,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'View All',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF2196F3), // Electric Blue
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
          _products.isEmpty
              ? Center(
                  child: Container(
                    padding: const EdgeInsets.all(40),
                    child: Text(
                      'No products available',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ),
                )
              : GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: 0.55,
                  ),
                  itemCount: _products.length > 10 ? 10 : _products.length,
                  itemBuilder: (context, index) {
                    return _buildProductCard(_products[index]);
                  },
                ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [Colors.white, Colors.grey.shade50],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image with placeholder fallback
              Expanded(
                flex: 3,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    color: Colors.grey.shade100,
                  ),
                  child: product.imageUrl.isNotEmpty && product.imageUrl.startsWith('http')
                      ? ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                          child: Image.network(
                            product.imageUrl,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    topRight: Radius.circular(16),
                                  ),
                                ),
                                child: const Center(
                                  child: SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Color(0xFF2196F3),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              print('Image load error for product ${product.nameMarathi}: $error');
                              print('Image URL: ${product.imageUrl}');
                              return _buildCategoryImagePlaceholder(product.category);
                            },
                          ),
                        )
                      : _buildCategoryImagePlaceholder(product.category),
                ),
              ),

              // Product Details - Ultra compact
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Product Name (ultra-compact with extreme length handling)
                      Container(
                        constraints: BoxConstraints(
                          maxHeight: 26.0, // Maximum height for 2 lines (13px * 2)
                        ),
                        child: Text(
                          product.nameMarathi,
                          style: GoogleFonts.poppins(
                            fontSize: 12, // Slightly smaller for extreme lengths
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade800,
                            height: 1.0,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                          textAlign: TextAlign.start,
                        ),
                      ),

                      const SizedBox(height: 4),

                      // Price and Stock in one row (compact)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '₹${product.price}',
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF2196F3),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                            decoration: BoxDecoration(
                              color: product.inStock
                                  ? const Color(0xFF2196F3).withOpacity(0.1)
                                  : Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: product.inStock
                                    ? const Color(0xFF2196F3)
                                    : Colors.grey.shade400,
                                width: 1,
                              ),
                            ),
                            child: Text(
                              product.inStock ? 'In' : 'Sold Out',
                              style: GoogleFonts.inter(
                                color: product.inStock
                                    ? const Color(0xFF2196F3)
                                    : Colors.grey.shade600,
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 6),

                      // Order Button (minimal)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: product.inStock ? () {
                            _launchWhatsAppWithProduct(product);
                          } : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: product.inStock
                                ? const Color(0xFF2196F3)
                                : Colors.grey.shade400,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            elevation: 1,
                            shadowColor: product.inStock
                                ? const Color(0xFF2196F3).withOpacity(0.2)
                                : Colors.transparent,
                          ),
                          child: Text(
                            'Order',
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryImagePlaceholder(String category) {
    IconData iconData;
    Color iconColor;

    // Category-specific icons and colors
    switch (category.toLowerCase()) {
      case 'लॅपटॉप':
        iconData = Icons.laptop;
        iconColor = const Color(0xFF2196F3); // Blue
        break;
      case 'प्रिंटर':
        iconData = Icons.print;
        iconColor = const Color(0xFF4CAF50); // Green
        break;
      case 'सीसीटीव्ही':
        iconData = Icons.videocam;
        iconColor = const Color(0xFFF44336); // Red
        break;
      case 'एसएसडी / हार्ड डिस्क':
        iconData = Icons.storage;
        iconColor = const Color(0xFF9C27B0); // Purple
        break;
      case 'अ‍ॅक्सेसरीज':
        iconData = Icons.memory;
        iconColor = const Color(0xFF607D8B); // Blue Grey
        break;
      case 'डेस्कटॉप':
        iconData = Icons.desktop_mac;
        iconColor = const Color(0xFF795548); // Brown
        break;
      default:
        iconData = Icons.computer;
        iconColor = Colors.grey.shade500;
    }

    return Container(
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.1),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Icon(
        iconData,
        size: 48,
        color: iconColor,
      ),
    );
  }

  Widget _buildServicesSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
      color: const Color(0xFFFAFAFA), // Off-white background
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 24),
            child: Text(
              'Our Services',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
                letterSpacing: 0.5,
              ),
            ),
          ),
          _buildServiceCard(
            Icons.videocam,
            'CCTV Installation & Free Wiring',
            'Professional CCTV camera installation with free wiring service.',
          ),
          _buildServiceCard(
            Icons.laptop,
            'Laptop & Computer Repair',
            'Expert repair services for all brands of computers and laptops.',
          ),
          _buildServiceCard(
            Icons.computer,
            'Software Installation',
            'Complete software setup including operating systems and antivirus.',
          ),
          _buildServiceCard(
            Icons.laptop_mac,
            'Branded Laptop Sales & Service',
            'Authorized dealer for HP, Lenovo, Dell laptops with warranty support.',
          ),
          _buildServiceCard(
            Icons.support,
            'Online Support',
            'Remote technical support for software issues and troubleshooting.',
          ),
          _buildServiceCard(
            Icons.local_shipping,
            'Home Delivery',
            'Free home delivery service for all products and installations.',
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(IconData icon, String title, String description) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: InkWell(
        onTap: () {}, // Service interaction
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00695C).withOpacity(0.1), // Deep Teal background
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    size: 28,
                    color: const Color(0xFF00695C), // Deep Teal
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.poppins(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade800,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        description,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContactSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 24),
            child: Text(
              'Contact Us',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
                letterSpacing: 0.5,
              ),
            ),
          ),

          // Address Card
          Container(
            margin: const EdgeInsets.only(bottom: 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2196F3).withOpacity(0.1), // Electric Blue background
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.location_on,
                          color: Color(0xFF2196F3), // Electric Blue
                          size: 26,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        'Our Location',
                        style: GoogleFonts.poppins(
                          fontSize: 19,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _contactInfo?.addressMarathi ?? 'वाढेगाव नाका, शनी गल्ली, शनी मंदिर समोर, महिमकर बिल्डींग, सांगोला ४१३३०७',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      color: Colors.grey.shade700,
                      height: 1.5,
                    ),
                    softWrap: true,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),

          // Call Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _launchPhone('+918788028134'),
                  icon: const Icon(Icons.phone, size: 20),
                  label: const Text('+91 8788028134'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00695C), // Deep Teal
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                    shadowColor: const Color(0xFF00695C).withOpacity(0.3),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _launchPhone('+917745028134'),
                  icon: const Icon(Icons.phone, size: 20),
                  label: const Text('+91 7745028134'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2196F3), // Electric Blue
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                    shadowColor: const Color(0xFF2196F3).withOpacity(0.3),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Instagram Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _launchInstagram(),
              icon: const Icon(Icons.camera, size: 20), // Instagram camera icon
              label: const Text('Follow on Instagram'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE4405F),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
                shadowColor: const Color(0xFFE4405F).withOpacity(0.3),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF00695C), Color(0xFF004D40)], // Deep Teal gradient
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Text(
            'MS Computer Sangola',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.end,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
            ),
            child: Text(
              'वाढेगाव नाका, शनी गल्ली, शनी मंदिर समोर,\nमहिमकर बिल्डींग, सांगोला ४१३३०७',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.white.withOpacity(0.95),
                fontWeight: FontWeight.w400,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
              softWrap: true,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(Icons.phone, color: Colors.white70, size: 18),
              ),
              const SizedBox(width: 8),
              Text(
                '+91 8788028134 | +91 7745028134',
                style: GoogleFonts.inter(
                  color: Colors.white.withOpacity(0.95),
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(Icons.chat, color: Colors.white70, size: 18), // WhatsApp-like chat icon
              ),
              const SizedBox(width: 8),
              Text(
                'WhatsApp',
                style: GoogleFonts.inter(
                  color: Colors.white.withOpacity(0.95),
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 20),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(Icons.camera, color: Colors.white70, size: 18), // Instagram camera icon
              ),
              const SizedBox(width: 8),
              Text(
                'Instagram',
                style: GoogleFonts.inter(
                  color: Colors.white.withOpacity(0.95),
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'All right reserved to ms computer © 2025',
            style: GoogleFonts.inter(
              color: Colors.white.withOpacity(0.8),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Created by: Sacchidanand Magar',
            style: GoogleFonts.inter(
              color: Colors.white.withOpacity(0.8),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Company logo image
              Container(
                width: 16,
                height: 16,
                margin: const EdgeInsets.only(right: 8),
                child: Image.asset(
                  'assets/images/image2.jpg',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.business,
                      color: Colors.white70,
                      size: 16,
                    );
                  },
                ),
              ),
              // Company name
              Text(
                'Magar and Magar Company',
                style: GoogleFonts.inter(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _launchPhone(String phoneNumber) async {
    final Uri url = Uri.parse('tel:$phoneNumber');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  Future<void> _launchWhatsApp() async {
    String phoneNumber = _contactInfo?.whatsappNumber ?? '+918788028134';
    final Uri url = Uri.parse('https://wa.me/$phoneNumber');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  Future<void> _launchWhatsAppWithProduct(Product product) async {
    String phoneNumber = _contactInfo?.whatsappNumber ?? '+918788028134';
    String message = 'Hi, I want to order: ${product.nameMarathi}. Price: ₹${product.price}';
    final Uri url = Uri.parse('https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  Future<void> _launchInstagram() async {
    String instagramUrl = _contactInfo?.instagramUrl ?? 'https://www.instagram.com/ms_computer_sangola?utm_source=ig_web_button_share_sheet&igsh=ZDNlZDc0MzIxNw==';
    if (instagramUrl.isNotEmpty && await canLaunchUrl(Uri.parse(instagramUrl))) {
      await launchUrl(Uri.parse(instagramUrl));
    }
  }
}
