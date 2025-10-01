// lib/screens/services_screen.dart
import 'package:flutter/material.dart';
import 'package:mscomputersangola/widgets/custom_app_bar.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Our Services',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            _buildServiceCard(
              Icons.videocam,
              'CCTV Installation',
              'Professional CCTV camera installation with free wiring service. We provide complete security solutions for homes and businesses.',
            ),

            _buildServiceCard(
              Icons.build,
              'Computer & Laptop Repair',
              'Expert repair services for all brands of computers and laptops. Fast turnaround with genuine parts.',
            ),

            _buildServiceCard(
              Icons.computer,
              'Software Installation',
              'Complete software setup including operating systems, antivirus, and productivity software.',
            ),

            _buildServiceCard(
              Icons.support,
              'Online Support',
              'Remote technical support for software issues and troubleshooting. Get help from anywhere.',
            ),

            _buildServiceCard(
              Icons.local_shipping,
              'Home Delivery',
              'Free home delivery service for all products and installations within Sangola city limits.',
            ),

            const SizedBox(height: 30),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFE6F2FF),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  const Text(
                    'Why Choose Us?',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0A4C80), // MS Blue
                    ),
                  ),
                  const SizedBox(height: 15),
                  _buildFeatureList(),
                ],
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/contact');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFCC0000), // MS Red
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text(
                  'Get Quote',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard(IconData icon, String title, String description) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: const Color(0xFF0A4C80), // MS Blue
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 30,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: TextStyle(
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
    );
  }

  Widget _buildFeatureList() {
    return Column(
      children: [
        _buildFeatureItem('✓ Quality Products from Trusted Brands'),
        _buildFeatureItem('✓ Competitive Pricing'),
        _buildFeatureItem('✓ Expert Technical Support'),
        _buildFeatureItem('✓ Free Installation & Setup'),
        _buildFeatureItem('✓ Warranty on All Products'),
        _buildFeatureItem('✓ 24/7 Customer Support'),
      ],
    );
  }

  Widget _buildFeatureItem(String feature) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Text(
            feature,
            style: const TextStyle(
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
