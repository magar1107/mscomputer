// lib/services/firebase_service.dart
// 🔥 FIRESTORE ONLY - Handles all document data (products, banners, contact)
// 📸 Images are handled separately by StorageService (Firebase Storage)
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mscomputersangola/models/product.dart';
import 'package:mscomputersangola/models/banner.dart';
import 'package:mscomputersangola/models/contact.dart';
import 'package:mscomputersangola/models/order.dart';

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

  // Add new product
  Future<String> addProduct(Product product) async {
    try {
      DocumentReference docRef = await _firestore.collection('products').add(product.toMap());
      return docRef.id;
    } catch (e) {
      print('Error adding product: $e');
      throw e;
    }
  }

  // Update product
  Future<void> updateProduct(String productId, Product product) async {
    try {
      await _firestore.collection('products').doc(productId).update(product.toMap());
    } catch (e) {
      print('Error updating product: $e');
      throw e;
    }
  }

  // Delete product
  Future<void> deleteProduct(String productId) async {
    try {
      await _firestore.collection('products').doc(productId).delete();
    } catch (e) {
      print('Error deleting product: $e');
      throw e;
    }
  }

  // Update banner
  Future<void> updateBanner(BannerData banner) async {
    try {
      await _firestore.collection('banners').doc('homepage').set(banner.toMap());
    } catch (e) {
      print('Error updating banner: $e');
      throw e;
    }
  }

  // Update contact info
  Future<void> updateContact(ContactInfo contact) async {
    try {
      await _firestore.collection('contact').doc('info').set(contact.toMap());
    } catch (e) {
      print('Error updating contact: $e');
      throw e;
    }
  }

  // ============== ORDER MANAGEMENT ==============

  // Add new order
  Future<String> addOrder(CustomerOrder order) async {
    try {
      DocumentReference docRef = await _firestore.collection('orders').add(order.toMap());
      return docRef.id;
    } catch (e) {
      print('Error adding order: $e');
      throw e;
    }
  }

  // Get all orders
  Future<List<CustomerOrder>> getAllOrders() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('orders')
          .orderBy('createdAt', descending: true)
          .get();
      return snapshot.docs.map((doc) =>
        CustomerOrder.fromFirestore(doc.data() as Map<String, dynamic>, doc.id)
      ).toList();
    } catch (e) {
      print('Error fetching orders: $e');
      return [];
    }
  }

  // Get orders by status
  Future<List<CustomerOrder>> getOrdersByStatus(String status) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('orders')
          .where('status', isEqualTo: status)
          .orderBy('createdAt', descending: true)
          .get();
      return snapshot.docs.map((doc) =>
        CustomerOrder.fromFirestore(doc.data() as Map<String, dynamic>, doc.id)
      ).toList();
    } catch (e) {
      print('Error fetching orders by status: $e');
      return [];
    }
  }

  // Stream for real-time order updates
  Stream<List<CustomerOrder>> getOrdersStream() {
    return _firestore.collection('orders').orderBy('createdAt', descending: true).snapshots().map((snapshot) =>
      snapshot.docs.map((doc) =>
        CustomerOrder.fromFirestore(doc.data(), doc.id)
      ).toList()
    );
  }

  // Update order status
  Future<void> updateOrderStatus(String orderId, String status) async {
    try {
      await _firestore.collection('orders').doc(orderId).update({'status': status});
    } catch (e) {
      print('Error updating order status: $e');
      throw e;
    }
  }

  // Delete order
  Future<void> deleteOrder(String orderId) async {
    try {
      await _firestore.collection('orders').doc(orderId).delete();
    } catch (e) {
      print('Error deleting order: $e');
      throw e;
    }
  }
}
