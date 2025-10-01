// lib/services/firebase_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mscomputersangola/models/product.dart';
import 'package:mscomputersangola/models/banner.dart';
import 'package:mscomputersangola/models/contact.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get homepage banner
  Future<BannerData?> getBannerData() async {
    try {
      DocumentSnapshot doc = await _firestore.collection('banners').doc('homepage').get();
      if (doc.exists) {
        return BannerData.fromFirestore(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error fetching banner: $e');
      return null;
    }
  }

  // Get contact information
  Future<ContactInfo?> getContactInfo() async {
    try {
      DocumentSnapshot doc = await _firestore.collection('contact').doc('info').get();
      if (doc.exists) {
        return ContactInfo.fromFirestore(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error fetching contact info: $e');
      return null;
    }
  }

  // Get all products
  Future<List<Product>> getAllProducts() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('products').get();
      return snapshot.docs.map((doc) =>
        Product.fromFirestore(doc.data() as Map<String, dynamic>, doc.id)
      ).toList();
    } catch (e) {
      print('Error fetching products: $e');
      return [];
    }
  }

  // Get products by category
  Future<List<Product>> getProductsByCategory(String category) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('products')
          .where('category', isEqualTo: category)
          .get();
      return snapshot.docs.map((doc) =>
        Product.fromFirestore(doc.data() as Map<String, dynamic>, doc.id)
      ).toList();
    } catch (e) {
      print('Error fetching products by category: $e');
      return [];
    }
  }

  // Get unique categories
  Future<List<String>> getCategories() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('products').get();
      Set<String> categories = {};
      for (var doc in snapshot.docs) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
        String category = data?['category'] ?? '';
        if (category.isNotEmpty) {
          categories.add(category);
        }
      }
      return categories.toList();
    } catch (e) {
      print('Error fetching categories: $e');
      return [];
    }
  }

  // Stream for real-time updates
  Stream<List<Product>> getProductsStream() {
    return _firestore.collection('products').snapshots().map((snapshot) =>
      snapshot.docs.map((doc) =>
        Product.fromFirestore(doc.data(), doc.id)
      ).toList()
    );
  }

  Stream<BannerData?> getBannerStream() {
    return _firestore.collection('banners').doc('homepage').snapshots().map((doc) {
      if (doc.exists) {
        return BannerData.fromFirestore(doc.data() as Map<String, dynamic>);
      }
      return null;
    });
  }

  Stream<ContactInfo?> getContactStream() {
    return _firestore.collection('contact').doc('info').snapshots().map((doc) {
      if (doc.exists) {
        return ContactInfo.fromFirestore(doc.data() as Map<String, dynamic>);
      }
      return null;
    });
  }
}
