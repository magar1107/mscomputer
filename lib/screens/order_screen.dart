// lib/screens/order_screen.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mscomputersangola/widgets/custom_app_bar.dart';
import 'package:mscomputersangola/services/firebase_service.dart';
import 'package:mscomputersangola/models/order.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _productController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final FirebaseService _firebaseService = FirebaseService();
  bool _isSubmitting = false;

  Future<void> _submitOrder() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);

      String name = _nameController.text;
      String phone = _phoneController.text;
      String product = _productController.text;
      String message = _messageController.text;

      try {
        // First, save the order to Firebase
        CustomerOrder newOrder = CustomerOrder(
          id: '', // Will be set by Firebase
          customerName: name,
          customerPhone: phone,
          product: product,
          message: message.isEmpty ? null : message,
          createdAt: DateTime.now(),
          status: 'pending',
        );

        String orderId = await _firebaseService.addOrder(newOrder);
        print('✅ Order saved to Firebase with ID: $orderId');

        // Then, send to WhatsApp
        String whatsappMessage = 'Hi, I want to order:\n\n'
            'Name: $name\n'
            'Phone: $phone\n'
            'Product: $product\n'
            'Message: $message\n\n'
            'Please contact me for further details.';

        String phoneNumber = '+918788028134'; // Default WhatsApp number
        final Uri url = Uri.parse('https://wa.me/$phoneNumber?text=${Uri.encodeComponent(whatsappMessage)}');

        if (await canLaunchUrl(url)) {
          await launchUrl(url);
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✅ Order submitted successfully! WhatsApp will open shortly.'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Could not open WhatsApp. Order saved - please contact us directly.'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      } catch (e) {
        print('❌ Error submitting order: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error submitting order: $e'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Order Details',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Fill in your details and we\'ll contact you shortly.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 30),

              // Name Field
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Phone Field
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Product Field
              TextFormField(
                controller: _productController,
                decoration: const InputDecoration(
                  labelText: 'Product/Service Interested *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.shopping_bag),
                  hintText: 'e.g., Lenovo Laptop, CCTV Installation, etc.',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please specify the product or service';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Message Field
              TextFormField(
                controller: _messageController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Additional Information',
                  border: OutlineInputBorder(),
                  hintText: 'Any specific requirements, budget, or questions...',
                ),
              ),

              const SizedBox(height: 30),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitOrder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFCC0000), // MS Red
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'Send Order via WhatsApp',
                          style: TextStyle(fontSize: 16),
                        ),
                ),
              ),

              const SizedBox(height: 20),

              // Alternative Contact
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: const Color(0xFFE6F2FF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Prefer to talk directly?',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () async {
                            const phoneNumber = 'tel:+918788028134';
                            if (await canLaunchUrl(Uri.parse(phoneNumber))) {
                              await launchUrl(Uri.parse(phoneNumber));
                            }
                          },
                          icon: const Icon(Icons.call),
                          label: const Text('Call Now'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF25D366),
                            foregroundColor: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 10),
                        OutlinedButton.icon(
                          onPressed: () async {
                            const whatsappUrl = 'https://wa.me/918788028134';
                            if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
                              await launchUrl(Uri.parse(whatsappUrl));
                            }
                          },
                          icon: const Icon(Icons.message),
                          label: const Text('WhatsApp'),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF25D366)),
                            foregroundColor: const Color(0xFF25D366),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Order Summary Card
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'What happens next?',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 15),
                      Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.green),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text('We receive your order details via WhatsApp'),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.phone, color: Colors.blue),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text('Our team will call you within 2 hours'),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.delivery_dining, color: Colors.orange),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text('Product delivered or service scheduled'),
                          ),
                        ],
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

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _productController.dispose();
    _messageController.dispose();
    super.dispose();
  }
}
