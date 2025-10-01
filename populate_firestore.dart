// populate_firestore.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mscomputersangola/firebase_config.dart';

Future<void> main() async {
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  print('🚀 Starting Firebase data population...');

  try {
    // Add banner data
    await firestore.collection('banners').doc('homepage').set({
      'title_marathi': 'तुम्हाला दर्जा आणि सेवा हवी असल्यास, एकमेव जागा...!',
      'subtitle_marathi': 'आपल्याकडे सर्व नवीन कॉम्प्युटर, लॅपटॉप, सीसीटीव्ही... एकदम स्वस्त दरात!',
      'isActive': true,
    });
    print('✅ Banner data added');

    // Add contact data
    await firestore.collection('contact').doc('info').set({
      'address_marathi': 'वाढेगाव नाका, शनी गल्ली, शनी मंदिर समोर, महिमकर बिल्डींग, सांगोला ४१३३०७',
      'phone1': '+918788028134',
      'phone2': '+917745028134',
      'whatsappNumber': '+918788028134',
      'instagramUrl': 'https://www.instagram.com/ms_computer_sangola?utm_source=ig_web_button_share_sheet&igsh=ZDNlZDc0MzIxNw==',
    });
    print('✅ Contact data added');

    // Add sample products
    final products = [
      {
        'name_marathi': 'लेनोव्हो आयडिया पॅड 3',
        'price': 28500,
        'category': 'लॅपटॉप',
        'description_marathi': '15.6 इंच, i5, 8GB RAM, 512GB SSD',
        'inStock': true,
        'imageUrl': 'https://via.placeholder.com/300x200/4CAF50/white?text=Lenovo+Laptop',
      },
      {
        'name_marathi': 'एचपी पॅव्हिलियन x360',
        'price': 42000,
        'category': 'लॅपटॉप',
        'description_marathi': '14 इंच टचस्क्रीन, i3, 8GB RAM, 256GB SSD',
        'inStock': true,
        'imageUrl': 'https://via.placeholder.com/300x200/2196F3/white?text=HP+Laptop',
      },
      {
        'name_marathi': 'हीरो प्रिंटर',
        'price': 8500,
        'category': 'प्रिंटर',
        'description_marathi': 'काळा आणि पांढरा प्रिंटर, यूएसबी कनेक्शन',
        'inStock': true,
        'imageUrl': 'https://via.placeholder.com/300x200/FF9800/white?text=Printer',
      },
      {
        'name_marathi': 'सीपी प्लस सीसीटीव्ही कॅमेरा',
        'price': 2500,
        'category': 'सीसीटीव्ही',
        'description_marathi': '2MP, नाईट व्हिजन, इनडोर/आउटडोर',
        'inStock': true,
        'imageUrl': 'https://via.placeholder.com/300x200/F44336/white?text=CCTV+Camera',
      },
      {
        'name_marathi': 'एसएसडी 512GB',
        'price': 3500,
        'category': 'एसएसडी / हार्ड डिस्क',
        'description_marathi': 'सॅमसंग 512GB SSD, SATA इंटरफेस',
        'inStock': false, // Out of stock example
        'imageUrl': 'https://via.placeholder.com/300x200/9C27B0/white?text=SSD+Drive',
      },
      {
        'name_marathi': 'कीबोर्ड आणि माऊस सेट',
        'price': 1200,
        'category': 'अ‍ॅक्सेसरीज',
        'description_marathi': 'वायर्ड कीबोर्ड आणि माऊस, USB कनेक्शन',
        'inStock': true,
        'imageUrl': 'https://via.placeholder.com/300x200/607D8B/white?text=Keyboard',
      },
    ];

    for (int i = 0; i < products.length; i++) {
      await firestore.collection('products').doc('product${i + 1}').set(products[i]);
    }
    print('✅ ${products.length} products added');

    print('🎉 All data added successfully!');
    print('Your website will now show real data instead of sample data!');

  } catch (e) {
    print('❌ Error adding data: $e');
  }
}
