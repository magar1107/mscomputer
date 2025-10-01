// lib/models/contact.dart
class ContactInfo {
  final String addressMarathi;
  final String phone1;
  final String phone2;
  final String instagramUrl;
  final String whatsappNumber;

  ContactInfo({
    required this.addressMarathi,
    required this.phone1,
    required this.phone2,
    required this.instagramUrl,
    required this.whatsappNumber,
  });

  factory ContactInfo.fromFirestore(Map<String, dynamic> data) {
    return ContactInfo(
      addressMarathi: data['address_marathi'] ?? '',
      phone1: data['phone1'] ?? '',
      phone2: data['phone2'] ?? '',
      instagramUrl: data['instagramUrl'] ?? '',
      whatsappNumber: data['whatsappNumber'] ?? '',
    );
  }
}
