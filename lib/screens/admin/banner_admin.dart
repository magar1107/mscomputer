// lib/screens/admin/banner_admin.dart
import 'package:flutter/material.dart';
import 'package:mscomputersangola/services/firebase_service.dart';
import 'package:mscomputersangola/models/banner.dart';

class BannerAdmin extends StatefulWidget {
  const BannerAdmin({super.key});

  @override
  State<BannerAdmin> createState() => _BannerAdminState();
}

class _BannerAdminState extends State<BannerAdmin> {
  final FirebaseService _firebaseService = FirebaseService();
  BannerData? _bannerData;
  bool _isLoading = true;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _subtitleController = TextEditingController();
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    _loadBanner();
  }

  Future<void> _loadBanner() async {
    setState(() => _isLoading = true);
    try {
      final banner = await _firebaseService.getBannerData();
      setState(() {
        _bannerData = banner;
        if (banner != null) {
          _titleController.text = banner.titleMarathi;
          _subtitleController.text = banner.subtitleMarathi;
          _isActive = banner.isActive;
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading banner: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(isMobile ? 16.0 : 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Banner Management',
              style: TextStyle(
                fontSize: isMobile ? 20 : 24,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF0A4C80),
              ),
            ),

            SizedBox(height: isMobile ? 16 : 24),

            if (_isLoading)
              const Expanded(child: Center(child: CircularProgressIndicator()))
            else
              Expanded(
                child: isMobile
                    ? Column(
                        children: [
                          // Edit Form - Mobile
                          Expanded(
                            flex: 1,
                            child: _buildEditForm(isMobile),
                          ),
                          SizedBox(height: isMobile ? 16 : 24),
                          // Preview - Mobile
                          Expanded(
                            flex: 1,
                            child: _buildPreview(isMobile),
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          // Edit Form - Desktop
                          Expanded(
                            flex: 1,
                            child: _buildEditForm(isMobile),
                          ),
                          SizedBox(width: isMobile ? 16 : 24),
                          // Preview - Desktop
                          Expanded(
                            flex: 1,
                            child: _buildPreview(isMobile),
                          ),
                        ],
                      ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditForm(bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Edit Homepage Banner',
            style: TextStyle(
              fontSize: isMobile ? 16 : 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: isMobile ? 16 : 24),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Title (Marathi)',
                      border: OutlineInputBorder(),
                      hintText: 'तुम्हाला दर्जा आणि सेवा हवी असल्यास...',
                    ),
                    maxLines: 2,
                  ),

                  SizedBox(height: isMobile ? 12 : 16),

                  TextField(
                    controller: _subtitleController,
                    decoration: const InputDecoration(
                      labelText: 'Subtitle (Marathi)',
                      border: OutlineInputBorder(),
                      hintText: 'आपल्याकडे सर्व नवीन कॉम्प्युटर...',
                    ),
                    maxLines: 2,
                  ),

                  SizedBox(height: isMobile ? 12 : 16),

                  Row(
                    children: [
                      const Text('Active:'),
                      const SizedBox(width: 8),
                      Switch(
                        value: _isActive,
                        onChanged: (value) => setState(() => _isActive = value),
                        activeColor: const Color(0xFF0A4C80),
                      ),
                    ],
                  ),

                  SizedBox(height: isMobile ? 16 : 24),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _updateBanner,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0A4C80),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: isMobile ? 12 : 16),
                      ),
                      child: Text(
                        'Update Banner',
                        style: TextStyle(fontSize: isMobile ? 14 : 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreview(bool isMobile) {
    return Container(
      height: isMobile ? null : 400,
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
          Container(
            height: 40,
            decoration: const BoxDecoration(
              color: Color(0xFF0A4C80),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: const Center(
              child: Text(
                'Preview',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.all(isMobile ? 12 : 20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF00695C), Color(0xFF004D40)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: EdgeInsets.all(isMobile ? 16 : 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _titleController.text.isEmpty
                          ? 'तुम्हाला दर्जा आणि सेवा हवी असल्यास, एकमेव जागा...!'
                          : _titleController.text,
                      style: TextStyle(
                        fontSize: isMobile ? 16 : 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: isMobile ? 8 : 12),
                    Text(
                      _subtitleController.text.isEmpty
                          ? 'आपल्याकडे सर्व नवीन कॉम्प्युटर, लॅपटॉप, सीसीटीव्ही... एकदम स्वस्त दरात!'
                          : _subtitleController.text,
                      style: TextStyle(
                        fontSize: isMobile ? 12 : 14,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: isMobile ? 16 : 24),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2196F3),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: isMobile ? 16 : 24,
                          vertical: isMobile ? 8 : 12,
                        ),
                      ),
                      child: Text(
                        'Explore Products',
                        style: TextStyle(fontSize: isMobile ? 12 : 14),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _updateBanner() async {
    try {
      BannerData updatedBanner = BannerData(
        titleMarathi: _titleController.text,
        subtitleMarathi: _subtitleController.text,
        isActive: _isActive,
      );

      await _firebaseService.updateBanner(updatedBanner);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Banner updated successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating banner: $e')),
      );
    }
  }
}
