// lib/screens/admin/products_admin.dart
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mscomputersangola/services/firebase_service.dart';
import 'package:mscomputersangola/services/storage_service.dart';
import 'package:mscomputersangola/models/product.dart';
import 'dart:io';

class ProductsAdmin extends StatefulWidget {
  const ProductsAdmin({super.key});

  @override
  State<ProductsAdmin> createState() => _ProductsAdminState();
}

class _ProductsAdminState extends State<ProductsAdmin> {
  final FirebaseService _firebaseService = FirebaseService();
  final StorageService _storageService = StorageService();
  List<Product> _products = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() => _isLoading = true);
    try {
      final products = await _firebaseService.getAllProducts();
      setState(() {
        _products = products;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading products: $e')),
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
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Products Management',
                    style: TextStyle(
                      fontSize: isMobile ? 20 : 24,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0A4C80),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _showAddProductDialog,
                  icon: Icon(Icons.add, size: isMobile ? 18 : 20),
                  label: Text(
                    'Add Product',
                    style: TextStyle(fontSize: isMobile ? 12 : 14),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0A4C80),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 12 : 16,
                      vertical: isMobile ? 8 : 12,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: isMobile ? 12 : 16),

            // Search Bar
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: isMobile ? 12 : 16,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  // Filter products based on search
                });
              },
            ),

            SizedBox(height: isMobile ? 16 : 24),

            // Products List
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : isMobile
                      ? _buildMobileProductList()
                      : _buildDesktopProductTable(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopProductTable() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Name (Marathi)')),
            DataColumn(label: Text('Category')),
            DataColumn(label: Text('Price')),
            DataColumn(label: Text('Stock')),
            DataColumn(label: Text('Actions')),
          ],
          rows: _products.map((product) {
            return DataRow(cells: [
              DataCell(Text(product.nameMarathi)),
              DataCell(Text(product.category)),
              DataCell(Text('₹${product.price}')),
              DataCell(
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: product.inStock
                        ? Colors.green.shade100
                        : Colors.red.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    product.inStock ? 'In Stock' : 'Out of Stock',
                    style: TextStyle(
                      color: product.inStock
                          ? Colors.green.shade800
                          : Colors.red.shade800,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              DataCell(
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, size: 20),
                      onPressed: () => _showEditProductDialog(product),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                      onPressed: () => _deleteProduct(product.id),
                    ),
                  ],
                ),
              ),
            ]);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildMobileProductList() {
    return ListView.builder(
      itemCount: _products.length,
      itemBuilder: (context, index) {
        final product = _products[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
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
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Name and Category
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.nameMarathi,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0A4C80),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            product.category,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: product.inStock
                            ? Colors.green.shade100
                            : Colors.red.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        product.inStock ? 'In Stock' : 'Out of Stock',
                        style: TextStyle(
                          color: product.inStock
                              ? Colors.green.shade800
                              : Colors.red.shade800,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Price
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '₹${product.price}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0A4C80),
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, size: 20),
                          onPressed: () => _showEditProductDialog(product),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                          onPressed: () => _deleteProduct(product.id),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showAddProductDialog() async {
    await showDialog(
      context: context,
      builder: (context) => const AddProductDialog(),
    ).then((_) {
      // Refresh products list after dialog closes
      _loadProducts();
    });
  }

  void _showEditProductDialog(Product product) {
    // Implementation for edit product dialog
    showDialog(
      context: context,
      builder: (context) => EditProductDialog(product: product),
    );
  }

  void _deleteProduct(String productId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Product'),
        content: const Text('Are you sure you want to delete this product? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await _firebaseService.deleteProduct(productId);
                Navigator.of(context).pop();
                _loadProducts(); // Refresh the list
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Product deleted successfully')),
                );
              } catch (e) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error deleting product: $e')),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
class AddProductDialog extends StatefulWidget {
  const AddProductDialog({super.key});

  @override
  State<AddProductDialog> createState() => _AddProductDialogState();
}

class _AddProductDialogState extends State<AddProductDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  String _selectedCategory = 'लॅपटॉप';
  bool _inStock = true;
  final FirebaseService _firebaseService = FirebaseService();
  final StorageService _storageService = StorageService();
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;
  String? _uploadedImageUrl;

  final List<String> _categories = [
    'लॅपटॉप',
    'प्रिंटर',
    'सीसीटीव्ही',
    'एसएसडी / हार्ड डिस्क',
    'अ‍ॅक्सेसरीज',
    'डेस्कटॉप',
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return Dialog(
      child: Container(
        width: isMobile ? screenWidth * 0.95 : 700,
        constraints: BoxConstraints(
          maxWidth: screenWidth * 0.95,
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        padding: EdgeInsets.all(isMobile ? 16 : 24),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add New Product',
                  style: TextStyle(
                    fontSize: isMobile ? 18 : 20,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0A4C80),
                  ),
                ),
                SizedBox(height: isMobile ? 12 : 16),

                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Product Name (Marathi)',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value?.isEmpty == true ? 'Required' : null,
                ),

                SizedBox(height: isMobile ? 12 : 16),

                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                  items: _categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => _selectedCategory = value!),
                ),

                SizedBox(height: isMobile ? 12 : 16),

                TextFormField(
                  controller: _priceController,
                  decoration: const InputDecoration(
                    labelText: 'Price',
                    border: OutlineInputBorder(),
                    prefixText: '₹',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) => value?.isEmpty == true ? 'Required' : null,
                ),

                SizedBox(height: isMobile ? 12 : 16),

                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description (Marathi)',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: isMobile ? 2 : 3,
                ),

                SizedBox(height: isMobile ? 12 : 16),

                // Image Upload Section (Optional)
                Container(
                  padding: EdgeInsets.all(isMobile ? 16 : 20),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _isUploading ? Colors.blue.shade300 : Colors.grey.shade300,
                      width: 2,
                      style: BorderStyle.solid,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    color: _isUploading ? Colors.blue.shade50 : Colors.grey.shade50,
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.cloud_upload,
                        size: isMobile ? 40 : 48,
                        color: _isUploading ? Colors.blue.shade400 : Colors.grey.shade400,
                      ),
                      SizedBox(height: isMobile ? 8 : 12),
                      Text(
                        _isUploading ? 'Uploading your image...' : 'Image Upload (Optional)',
                        style: TextStyle(
                          fontSize: isMobile ? 14 : 16,
                          fontWeight: FontWeight.bold,
                          color: _isUploading ? Colors.blue.shade700 : Colors.grey.shade700,
                        ),
                      ),
                      SizedBox(height: isMobile ? 6 : 8),
                      Text(
                        'Upload an image or leave empty - category icon will be generated automatically',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: isMobile ? 12 : 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: isMobile ? 12 : 16),
                      isMobile
                          ? Column(
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: _isUploading ? null : _pickFromGallery,
                                    icon: const Icon(Icons.photo_library),
                                    label: const Text('Gallery'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: const Color(0xFF0A4C80),
                                      side: const BorderSide(color: Color(0xFF0A4C80)),
                                    ),
                                  ),
                                ),
                                SizedBox(height: isMobile ? 8 : 12),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: _isUploading ? null : _pickFromCamera,
                                    icon: const Icon(Icons.camera_alt),
                                    label: const Text('Camera'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF0A4C80),
                                      foregroundColor: Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(height: isMobile ? 8 : 12),
                                SizedBox(
                                  width: double.infinity,
                                  child: OutlinedButton.icon(
                                    onPressed: () {
                                      setState(() {
                                        _imageUrlController.text = '';
                                        _uploadedImageUrl = null;
                                      });
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('✅ Will use category icon for this product'),
                                          backgroundColor: Colors.green,
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.category),
                                    label: const Text('Use Icon'),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.orange.shade700,
                                      side: BorderSide(color: Colors.orange.shade300),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: _isUploading ? null : _pickFromGallery,
                                  icon: const Icon(Icons.photo_library),
                                  label: const Text('Gallery'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: const Color(0xFF0A4C80),
                                    side: const BorderSide(color: Color(0xFF0A4C80)),
                                  ),
                                ),
                                SizedBox(width: isMobile ? 8 : 12),
                                ElevatedButton.icon(
                                  onPressed: _isUploading ? null : _pickFromCamera,
                                  icon: const Icon(Icons.camera_alt),
                                  label: const Text('Camera'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF0A4C80),
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                                SizedBox(width: isMobile ? 8 : 12),
                                OutlinedButton.icon(
                                  onPressed: () {
                                    setState(() {
                                      _imageUrlController.text = '';
                                      _uploadedImageUrl = null;
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('✅ Will use category icon for this product'),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.category),
                                  label: const Text('Use Icon'),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.orange.shade700,
                                    side: BorderSide(color: Colors.orange.shade300),
                                  ),
                                ),
                              ],
                            ),
                    ],
                  ),
                ),

                // Category Icon Preview Section
                if (_imageUrlController.text.isEmpty && !_isUploading) ...[
                  SizedBox(height: isMobile ? 12 : 16),
                  Container(
                    padding: EdgeInsets.all(isMobile ? 12 : 16),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.orange.shade200),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Category Icon Preview:',
                          style: TextStyle(
                            fontSize: isMobile ? 14 : 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                        SizedBox(height: isMobile ? 8 : 12),
                        _getCategoryIcon(_selectedCategory),
                        SizedBox(height: isMobile ? 6 : 8),
                        Text(
                          'This icon will be displayed for "${_selectedCategory}" category products',
                          style: TextStyle(
                            color: Colors.orange.shade700,
                            fontSize: isMobile ? 11 : 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],

                // Image Preview Section
                if (_uploadedImageUrl != null || _imageUrlController.text.isNotEmpty) ...[
                  Text(
                    'Image Preview:',
                    style: TextStyle(
                      fontSize: isMobile ? 14 : 16,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0A4C80),
                    ),
                  ),
                  SizedBox(height: isMobile ? 6 : 8),
                  Container(
                    height: isMobile ? 150 : 200,
                    width: double.infinity,
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.8,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: _uploadedImageUrl != null
                          ? Image.network(
                              _uploadedImageUrl!,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Container(
                                  color: Colors.grey.shade100,
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey.shade100,
                                  child: const Center(
                                    child: Icon(Icons.error, color: Colors.red),
                                  ),
                                );
                              },
                            )
                          : Image.network(
                              _imageUrlController.text,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Container(
                                  color: Colors.grey.shade100,
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey.shade100,
                                  child: const Center(
                                    child: Icon(Icons.error, color: Colors.red),
                                  ),
                                );
                              },
                            ),
                    ),
                  ),
                  SizedBox(height: isMobile ? 12 : 16),
                ],

                // Upload Progress Indicator
                if (_isUploading) ...[
                  SizedBox(height: isMobile ? 12 : 16),
                  Container(
                    padding: EdgeInsets.all(isMobile ? 12 : 16),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Row(
                      children: [
                        const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0A4C80)),
                        ),
                        SizedBox(width: isMobile ? 12 : 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Uploading image...',
                                style: TextStyle(
                                  color: Colors.blue.shade800,
                                  fontWeight: FontWeight.bold,
                                  fontSize: isMobile ? 14 : 16,
                                ),
                              ),
                              SizedBox(height: isMobile ? 2 : 4),
                              Text(
                                'Please wait while we upload your image to the cloud.',
                                style: TextStyle(
                                  color: Colors.blue.shade600,
                                  fontSize: isMobile ? 11 : 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                SizedBox(height: isMobile ? 12 : 16),

                Row(
                  children: [
                    const Text('In Stock:'),
                    const SizedBox(width: 8),
                    Switch(
                      value: _inStock,
                      onChanged: (value) => setState(() => _inStock = value),
                      activeColor: const Color(0xFF0A4C80),
                    ),
                  ],
                ),

                SizedBox(height: isMobile ? 16 : 24),

                // Action Buttons
                isMobile
                    ? Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isUploading ? null : _saveProduct,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0A4C80),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                              child: Text(
                                _isUploading ? 'Saving...' : 'Save Product',
                                style: TextStyle(fontSize: isMobile ? 14 : 16),
                              ),
                            ),
                          ),
                          SizedBox(height: isMobile ? 8 : 12),
                          SizedBox(
                            width: double.infinity,
                            child: TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                              child: Text(
                                'Cancel',
                                style: TextStyle(fontSize: isMobile ? 14 : 16),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Cancel'),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: _isUploading ? null : _saveProduct,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0A4C80),
                              foregroundColor: Colors.white,
                            ),
                            child: Text(_isUploading ? 'Saving...' : 'Save Product'),
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickFromGallery() async {
    try {
      print('Attempting to pick image from gallery...');
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 85,
      );

      if (image != null) {
        print('Image selected successfully: ${image.path}');
        await _uploadImageFromXFile(image);
      } else {
        print('No image selected by user');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No image selected')),
        );
      }
    } catch (e) {
      print('Error picking image from gallery: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  Future<void> _pickFromCamera() async {
    try {
      print('Attempting to capture image from camera...');
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 85,
      );

      if (image != null) {
        print('Image captured successfully: ${image.path}');
        await _uploadImageFromXFile(image);
      } else {
        print('No image captured by user');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No image captured')),
        );
      }
    } catch (e) {
      print('Error capturing image from camera: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error capturing image: $e')),
      );
    }
  }

  // Helper method to get category icon
  Widget _getCategoryIcon(String category) {
    IconData iconData;
    Color iconColor;

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
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(
        iconData,
        size: 48,
        color: iconColor,
      ),
    );
  }

  Future<void> _uploadImageFromXFile(XFile image) async {
    setState(() => _isUploading = true);

    try {
      print('🔄 Starting image upload process...');
      print('📁 Image source: ${image.path.startsWith('blob:') ? 'Web (blob URL)' : 'Mobile/Desktop (file path)'}');

      // For web, check if it's a blob URL and handle accordingly
      if (image.path.startsWith('blob:')) {
        print('🌐 Detected web blob URL, reading as bytes...');
        // Web file - read as bytes
        final bytes = await image.readAsBytes();
        print('📊 Read ${bytes.length} bytes from web image');

        // Validate image size (max 5MB) - Firebase Storage limit
        if (bytes.length > 5 * 1024 * 1024) {
          throw Exception('Image size must be less than 5MB (Firebase Storage limit)');
        }

        print('🚀 Uploading bytes to Firebase Storage...');
        String? downloadUrl = await _storageService.uploadImageBytes(
          bytes,
          '${DateTime.now().millisecondsSinceEpoch}_${image.name}',
          'products',
        );

        if (downloadUrl != null) {
          print('✅ Upload successful! Firebase Storage URL: $downloadUrl');
          setState(() {
            _imageUrlController.text = downloadUrl;
            _uploadedImageUrl = downloadUrl;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✅ Image uploaded to Firebase Storage successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          print('❌ Upload returned null URL');
          throw Exception('Failed to upload image to Firebase Storage');
        }
      } else {
        print('📱 Detected file path, using File approach...');
        // Mobile/Desktop file - use traditional File approach
        final File file = File(image.path);
        final fileSize = await file.length();
        print('📊 File size: $fileSize bytes');

        if (fileSize > 5 * 1024 * 1024) {
          throw Exception('Image size must be less than 5MB (Firebase Storage limit)');
        }

        print('🚀 Uploading file to Firebase Storage...');
        String? downloadUrl = await _storageService.uploadImage(
          file,
          'products',
        );

        if (downloadUrl != null) {
          print('✅ Upload successful! Firebase Storage URL: $downloadUrl');
          setState(() {
            _imageUrlController.text = downloadUrl;
            _uploadedImageUrl = downloadUrl;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✅ Image uploaded to Firebase Storage successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          print('❌ Upload returned null URL');
          throw Exception('Failed to upload image to Firebase Storage');
        }
      }
    } catch (e) {
      print('❌ Upload error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Upload to Firebase Storage failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isUploading = false);
    }
  }

  void _saveProduct() async {
    if (_formKey.currentState!.validate()) {
      try {
        setState(() => _isUploading = true);

        Product newProduct = Product(
          id: '', // Will be set by Firebase
          nameMarathi: _nameController.text,
          price: int.parse(_priceController.text),
          category: _selectedCategory,
          descriptionMarathi: _descriptionController.text,
          inStock: _inStock,
          imageUrl: _imageUrlController.text,
        );

        await _firebaseService.addProduct(newProduct);

        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product added successfully')),
        );

        // Refresh products list in parent widget
        if (mounted) {
          // Trigger parent widget to reload data
          Navigator.of(context).pop();
          // The parent widget will reload data in its initState or other method
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding product: $e')),
        );
      } finally {
        setState(() => _isUploading = false);
      }
    }
  }
}

// Edit Product Dialog (similar structure)
class EditProductDialog extends StatefulWidget {
  final Product product;

  const EditProductDialog({super.key, required this.product});

  @override
  State<EditProductDialog> createState() => _EditProductDialogState();
}

class _EditProductDialogState extends State<EditProductDialog> {
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;
  late TextEditingController _imageUrlController;
  late String _selectedCategory;
  late bool _inStock;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product.nameMarathi);
    _priceController = TextEditingController(text: widget.product.price.toString());
    _descriptionController = TextEditingController(text: widget.product.descriptionMarathi);
    _imageUrlController = TextEditingController(text: widget.product.imageUrl);
    _selectedCategory = widget.product.category;
    _inStock = widget.product.inStock;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Edit Product: ${widget.product.nameMarathi}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0A4C80),
              ),
            ),
            // Similar form fields as AddProductDialog
            // ... (form implementation)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Update product in Firebase
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0A4C80),
                  ),
                  child: const Text('Update Product'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
