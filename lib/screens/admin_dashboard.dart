// lib/screens/admin_dashboard.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mscomputersangola/services/auth_service.dart';
import 'package:mscomputersangola/screens/admin/products_admin.dart';
import 'package:mscomputersangola/screens/admin/banner_admin.dart';
import 'package:mscomputersangola/screens/admin/contact_admin.dart';
import 'package:mscomputersangola/screens/admin/orders_admin.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final AuthService _authService = AuthService();
  int _selectedIndex = 0;

  final List<Widget> _adminScreens = [
    const DashboardOverview(),
    const OrdersAdmin(),
    const ProductsAdmin(),
    const BannerAdmin(),
    const ContactAdmin(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel - MS Computer'),
        backgroundColor: const Color(0xFF0A4C80),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _authService.signOut();
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
        ],
      ),
      drawer: isMobile ? _buildMobileDrawer() : null,
      body: Row(
        children: [
          // Sidebar Navigation - Hidden on mobile (replaced by drawer)
          if (!isMobile)
            Container(
              width: 250,
              color: const Color(0xFF0A4C80),
              child: _buildDesktopSidebar(),
            ),

          // Main Content Area
          Expanded(
            child: Container(
              color: Colors.grey.shade50,
              child: _adminScreens[_selectedIndex],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileDrawer() {
    return Drawer(
      child: Container(
        color: const Color(0xFF0A4C80),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Logo/Brand
            Container(
              padding: const EdgeInsets.all(16),
              child: const Column(
                children: [
                  Icon(
                    Icons.admin_panel_settings,
                    size: 48,
                    color: Colors.white,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'MS Computer\nAdmin Panel',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.white24),

            // Navigation Items
            _buildMobileNavItem(Icons.dashboard, 'Dashboard', 0),
            _buildMobileNavItem(Icons.shopping_cart, 'Orders', 1),
            _buildMobileNavItem(Icons.inventory, 'Products', 2),
            _buildMobileNavItem(Icons.announcement, 'Banner', 3),
            _buildMobileNavItem(Icons.contact_phone, 'Contact', 4),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopSidebar() {
    return Column(
      children: [
        const SizedBox(height: 20),
        // Logo/Brand
        Container(
          padding: const EdgeInsets.all(16),
          child: const Column(
            children: [
              Icon(
                Icons.admin_panel_settings,
                size: 48,
                color: Colors.white,
              ),
              SizedBox(height: 8),
              Text(
                'MS Computer\nAdmin Panel',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const Divider(color: Colors.white24),

        // Navigation Items
        _buildNavItem(Icons.dashboard, 'Dashboard', 0),
        _buildNavItem(Icons.shopping_cart, 'Orders', 1),
        _buildNavItem(Icons.inventory, 'Products', 2),
        _buildNavItem(Icons.announcement, 'Banner', 3),
        _buildNavItem(Icons.contact_phone, 'Contact', 4),
      ],
    );
  }

  Widget _buildNavItem(IconData icon, String title, int index) {
    bool isSelected = _selectedIndex == index;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? Colors.white : Colors.white70,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white70,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        tileColor: isSelected ? Colors.white24 : Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        onTap: () => _onItemTapped(index),
      ),
    );
  }

  Widget _buildMobileNavItem(IconData icon, String title, int index) {
    bool isSelected = _selectedIndex == index;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? Colors.white : Colors.white70,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white70,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        tileColor: isSelected ? Colors.white24 : Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        onTap: () {
          _onItemTapped(index);
          Navigator.of(context).pop(); // Close drawer
        },
      ),
    );
  }
}

// Dashboard Overview Screen
class DashboardOverview extends StatelessWidget {
  const DashboardOverview({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return Padding(
      padding: EdgeInsets.all(isMobile ? 16.0 : 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Dashboard Overview',
            style: TextStyle(
              fontSize: isMobile ? 24 : 28,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF0A4C80),
            ),
          ),
          SizedBox(height: isMobile ? 16 : 24),

          // Stats Cards
          isMobile
              ? Column(
                  children: [
                    _buildStatCard(
                      'Total Products',
                      '25',
                      Icons.inventory,
                      Colors.blue,
                    ),
                    const SizedBox(height: 12),
                    _buildStatCard(
                      'Total Orders',
                      '0',
                      Icons.shopping_cart,
                      Colors.orange,
                    ),
                    const SizedBox(height: 12),
                    _buildStatCard(
                      'Active Banner',
                      '1',
                      Icons.announcement,
                      Colors.green,
                    ),
                    const SizedBox(height: 12),
                    _buildStatCard(
                      'Contact Info',
                      'Updated',
                      Icons.contact_phone,
                      Colors.purple,
                    ),
                  ],
                )
              : Row(
                  children: [
                    _buildStatCard(
                      'Total Products',
                      '25',
                      Icons.inventory,
                      Colors.blue,
                    ),
                    const SizedBox(width: 16),
                    _buildStatCard(
                      'Total Orders',
                      '0',
                      Icons.shopping_cart,
                      Colors.orange,
                    ),
                    const SizedBox(width: 16),
                    _buildStatCard(
                      'Active Banner',
                      '1',
                      Icons.announcement,
                      Colors.green,
                    ),
                    const SizedBox(width: 16),
                    _buildStatCard(
                      'Contact Info',
                      'Updated',
                      Icons.contact_phone,
                      Colors.purple,
                    ),
                  ],
                ),

          SizedBox(height: isMobile ? 24 : 32),

          // Quick Actions
          Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: isMobile ? 18 : 20,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF0A4C80),
            ),
          ),
          SizedBox(height: isMobile ? 12 : 16),

          isMobile
              ? Column(
                  children: [
                    _buildQuickActionButton(
                      context,
                      'View Orders',
                      Icons.shopping_cart,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const OrdersAdmin()),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildQuickActionButton(
                      context,
                      'Add Product',
                      Icons.add,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ProductsAdmin()),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildQuickActionButton(
                      context,
                      'Update Banner',
                      Icons.edit,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const BannerAdmin()),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildQuickActionButton(
                      context,
                      'Update Contact',
                      Icons.phone,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ContactAdmin()),
                      ),
                    ),
                  ],
                )
              : Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    _buildQuickActionButton(
                      context,
                      'View Orders',
                      Icons.shopping_cart,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const OrdersAdmin()),
                      ),
                    ),
                    _buildQuickActionButton(
                      context,
                      'Add Product',
                      Icons.add,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ProductsAdmin()),
                      ),
                    ),
                    _buildQuickActionButton(
                      context,
                      'Update Banner',
                      Icons.edit,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const BannerAdmin()),
                      ),
                    ),
                    _buildQuickActionButton(
                      context,
                      'Update Contact',
                      Icons.phone,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ContactAdmin()),
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 32, color: color),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return InkWell(
      onTap: onTap,
      child: Container(
        width: isMobile ? double.infinity : 150,
        height: isMobile ? 80 : 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 8,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: isMobile ? 28 : 32, color: const Color(0xFF0A4C80)),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF0A4C80),
                fontSize: isMobile ? 14 : 16,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
