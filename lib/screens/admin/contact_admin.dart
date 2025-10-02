// lib/screens/admin/contact_admin.dart
import 'package:flutter/material.dart';
import 'package:mscomputersangola/services/firebase_service.dart';
import 'package:mscomputersangola/models/contact.dart';

class ContactAdmin extends StatefulWidget {
  const ContactAdmin({super.key});

  @override
  State<ContactAdmin> createState() => _ContactAdminState();
}

class _ContactAdminState extends State<ContactAdmin> {
  final FirebaseService _firebaseService = FirebaseService();
  ContactInfo? _contactInfo;
  bool _isLoading = true;
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phone1Controller = TextEditingController();
  final TextEditingController _phone2Controller = TextEditingController();
  final TextEditingController _whatsappController = TextEditingController();
  final TextEditingController _instagramController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadContact();
  }

  Future<void> _loadContact() async {
    setState(() => _isLoading = true);
    try {
      final contact = await _firebaseService.getContactInfo();
      setState(() {
        _contactInfo = contact;
        if (contact != null) {
          _addressController.text = contact.addressMarathi;
          _phone1Controller.text = contact.phone1;
          _phone2Controller.text = contact.phone2;
          _whatsappController.text = contact.whatsappNumber;
          _instagramController.text = contact.instagramUrl;
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading contact: $e')),
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
              'Contact Information Management',
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
                child: Container(
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
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Store Contact Details',
                          style: TextStyle(
                            fontSize: isMobile ? 16 : 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: isMobile ? 16 : 24),

                        // Address
                        TextField(
                          controller: _addressController,
                          decoration: const InputDecoration(
                            labelText: 'Store Address (Marathi)',
                            border: OutlineInputBorder(),
                            hintText: 'वाढेगाव नाका, शनी गल्ली...',
                          ),
                          maxLines: 3,
                        ),

                        SizedBox(height: isMobile ? 12 : 16),

                        // Phone Numbers
                        isMobile
                            ? Column(
                                children: [
                                  TextField(
                                    controller: _phone1Controller,
                                    decoration: const InputDecoration(
                                      labelText: 'Primary Phone',
                                      border: OutlineInputBorder(),
                                      prefixText: '+91 ',
                                    ),
                                    keyboardType: TextInputType.phone,
                                  ),
                                  SizedBox(height: isMobile ? 12 : 16),
                                  TextField(
                                    controller: _phone2Controller,
                                    decoration: const InputDecoration(
                                      labelText: 'Secondary Phone',
                                      border: OutlineInputBorder(),
                                      prefixText: '+91 ',
                                    ),
                                    keyboardType: TextInputType.phone,
                                  ),
                                ],
                              )
                            : Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: _phone1Controller,
                                      decoration: const InputDecoration(
                                        labelText: 'Primary Phone',
                                        border: OutlineInputBorder(),
                                        prefixText: '+91 ',
                                      ),
                                      keyboardType: TextInputType.phone,
                                    ),
                                  ),
                                  SizedBox(width: isMobile ? 12 : 16),
                                  Expanded(
                                    child: TextField(
                                      controller: _phone2Controller,
                                      decoration: const InputDecoration(
                                        labelText: 'Secondary Phone',
                                        border: OutlineInputBorder(),
                                        prefixText: '+91 ',
                                      ),
                                      keyboardType: TextInputType.phone,
                                    ),
                                  ),
                                ],
                              ),

                        SizedBox(height: isMobile ? 12 : 16),

                        // WhatsApp
                        TextField(
                          controller: _whatsappController,
                          decoration: const InputDecoration(
                            labelText: 'WhatsApp Number',
                            border: OutlineInputBorder(),
                            prefixText: '+91 ',
                          ),
                          keyboardType: TextInputType.phone,
                        ),

                        SizedBox(height: isMobile ? 12 : 16),

                        // Instagram
                        TextField(
                          controller: _instagramController,
                          decoration: const InputDecoration(
                            labelText: 'Instagram URL',
                            border: OutlineInputBorder(),
                            hintText: 'https://www.instagram.com/...',
                          ),
                        ),

                        SizedBox(height: isMobile ? 24 : 32),

                        // Save Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _updateContact,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0A4C80),
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: isMobile ? 12 : 16),
                            ),
                            child: Text(
                              'Update Contact Information',
                              style: TextStyle(fontSize: isMobile ? 14 : 16),
                            ),
                          ),
                        ),

                        SizedBox(height: isMobile ? 16 : 24),

                        // Preview Card
                        Text(
                          'Preview on Website:',
                          style: TextStyle(
                            fontSize: isMobile ? 14 : 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: isMobile ? 6 : 8),

                        Container(
                          padding: EdgeInsets.all(isMobile ? 12 : 16),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.location_on, color: const Color(0xFF0A4C80), size: isMobile ? 20 : 24),
                                  SizedBox(width: isMobile ? 6 : 8),
                                  Expanded(
                                    child: Text(
                                      _addressController.text.isEmpty
                                          ? 'वाढेगाव नाका, शनी गल्ली, शनी मंदिर समोर, महिमकर बिल्डींग, सांगोला ४१३३०७'
                                          : _addressController.text,
                                      style: TextStyle(fontSize: isMobile ? 12 : 14),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: isMobile ? 6 : 8),
                              Row(
                                children: [
                                  Icon(Icons.phone, color: const Color(0xFF0A4C80), size: isMobile ? 20 : 24),
                                  SizedBox(width: isMobile ? 6 : 8),
                                  Text(
                                    _phone1Controller.text.isEmpty
                                        ? '+91 8788028134'
                                        : '+91 ${_phone1Controller.text}',
                                    style: TextStyle(fontSize: isMobile ? 12 : 14),
                                  ),
                                ],
                              ),
                              SizedBox(height: isMobile ? 6 : 8),
                              Row(
                                children: [
                                  Icon(Icons.phone_android, color: Colors.green, size: isMobile ? 20 : 24),
                                  SizedBox(width: isMobile ? 6 : 8),
                                  Text(
                                    _whatsappController.text.isEmpty
                                        ? '+91 8788028134'
                                        : '+91 ${_whatsappController.text}',
                                    style: TextStyle(fontSize: isMobile ? 12 : 14),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _updateContact() async {
    try {
      ContactInfo updatedContact = ContactInfo(
        addressMarathi: _addressController.text,
        phone1: _phone1Controller.text,
        phone2: _phone2Controller.text,
        whatsappNumber: _whatsappController.text,
        instagramUrl: _instagramController.text,
      );

      await _firebaseService.updateContact(updatedContact);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Contact information updated successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating contact: $e')),
      );
    }
  }
}
