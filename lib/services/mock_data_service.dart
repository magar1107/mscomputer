// lib/services/mock_data_service.dart
import 'package:mscomputersangola/models/product.dart';
import 'package:mscomputersangola/models/banner.dart';
import 'package:mscomputersangola/models/contact.dart';

class MockDataService {
  // Mock banner data
  static BannerData getMockBannerData() {
    return BannerData(
      titleMarathi: 'तुम्हाला दर्जा आणि सेवा हवी असल्यास, एकमेव जागा...!',
      subtitleMarathi: 'आपल्याकडे सर्व नवीन कॉम्प्युटर, लॅपटॉप, सीसीटीव्ही... एकदम स्वस्त दरात!',
      isActive: true,
    );
  }
  static ContactInfo getMockContactInfo() {
    return ContactInfo(
      addressMarathi: 'वाढेगाव नाका, शनी गल्ली, शनी मंदिर समोर, महिमकर बिल्डींग, सांगोला ४१३३०७',
      phone1: '+918788028134',
      phone2: '+917745028134',
      whatsappNumber: '+918788028134',
      instagramUrl: 'https://www.instagram.com/ms_computer_sangola?utm_source=ig_web_button_share_sheet&igsh=ZDNlZDc0MzIxNw==',
    );
  }

  // Mock products data
  static List<Product> getMockProducts() {
    return [
      Product(
        id: 'product1',
        nameMarathi: 'लेनोव्हो आयडिया पॅड 3',
        price: 28500,
        category: 'लॅपटॉप',
        descriptionMarathi: '15.6 इंच, i5, 8GB RAM, 512GB SSD',
        inStock: true,
        imageUrl: 'https://via.placeholder.com/300x200/4CAF50/white?text=Lenovo+Laptop'
      ),
      Product(
        id: 'product2',
        nameMarathi: 'एचपी पॅव्हिलियन x360',
        price: 42000,
        category: 'लॅपटॉप',
        descriptionMarathi: '14 इंच टचस्क्रीन, i3, 8GB RAM, 256GB SSD',
        inStock: true,
        imageUrl: 'https://via.placeholder.com/300x200/2196F3/white?text=HP+Laptop'
      ),
      Product(
        id: 'product3',
        nameMarathi: 'हीरो प्रिंटर',
        price: 8500,
        category: 'प्रिंटर',
        descriptionMarathi: 'काळा आणि पांढरा प्रिंटर, यूएसबी कनेक्शन',
        inStock: true,
        imageUrl: 'https://via.placeholder.com/300x200/FF9800/white?text=Printer'
      ),
      Product(
        id: 'product4',
        nameMarathi: 'सीपी प्लस सीसीटीव्ही कॅमेरा',
        price: 2500,
        category: 'सीसीटीव्ही',
        descriptionMarathi: '2MP, नाईट व्हिजन, इनडोर/आउटडोर',
        inStock: true,
        imageUrl: 'https://via.placeholder.com/300x200/F44336/white?text=CCTV+Camera'
      ),
      Product(
        id: 'product5',
        nameMarathi: 'एसएसडी 512GB',
        price: 3500,
        category: 'एसएसडी / हार्ड डिस्क',
        descriptionMarathi: 'सॅमसंग 512GB SSD, SATA इंटरफेस',
        inStock: false, // Out of stock example
        imageUrl: 'https://via.placeholder.com/300x200/9C27B0/white?text=SSD+Drive'
      ),
      Product(
        id: 'product6',
        nameMarathi: 'कीबोर्ड आणि माऊस सेट',
        price: 1200,
        category: 'अ‍ॅक्सेसरीज',
        descriptionMarathi: 'वायर्ड कीबोर्ड आणि माऊस, USB कनेक्शन',
        inStock: true,
        imageUrl: 'https://via.placeholder.com/300x200/607D8B/white?text=Keyboard'
      ),
    ];
  }

  // Mock categories
  static List<String> getMockCategories() {
    return ['लॅपटॉप', 'प्रिंटर', 'सीसीटीव्ही', 'एसएसडी / हार्ड डिस्क', 'अ‍ॅक्सेसरीज', 'डेस्कटॉप'];
  }
}
