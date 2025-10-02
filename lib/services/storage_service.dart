// lib/services/storage_service.dart
// 📸 FIREBASE STORAGE ONLY - Handles all image/file uploads and storage
// 🔥 Document data is handled separately by FirebaseService (Firestore)
import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Upload image to Firebase Storage (Mobile/Desktop)
  Future<String?> uploadImage(File imageFile, String folder) async {
    try {
      String fileName = path.basename(imageFile.path);
      String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      String uniqueFileName = '${timestamp}_$fileName';

      Reference ref = _storage.ref().child('$folder/$uniqueFileName');
      UploadTask uploadTask = ref.putFile(imageFile);

      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  // Upload image from XFile (Cross-platform)
  Future<String?> uploadXFile(XFile imageFile, String folder) async {
    try {
      String fileName = path.basename(imageFile.path);
      String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      String uniqueFileName = '${timestamp}_$fileName';

      Reference ref = _storage.ref().child('$folder/$uniqueFileName');

      // For web, we need to read as bytes
      if (imageFile.path.startsWith('blob:') || imageFile.path.startsWith('data:')) {
        // Web file - read as bytes
        final bytes = await imageFile.readAsBytes();
        UploadTask uploadTask = ref.putData(
          bytes,
          SettableMetadata(contentType: 'image/jpeg'),
        );
        TaskSnapshot snapshot = await uploadTask;
        String downloadUrl = await snapshot.ref.getDownloadURL();
        return downloadUrl;
      } else {
        // Mobile file
        UploadTask uploadTask = ref.putFile(File(imageFile.path));
        TaskSnapshot snapshot = await uploadTask;
        String downloadUrl = await snapshot.ref.getDownloadURL();
        return downloadUrl;
      }
    } catch (e) {
      print('Error uploading XFile: $e');
      return null;
    }
  }

  // Upload image from bytes (for web)
  Future<String?> uploadImageBytes(List<int> imageBytes, String fileName, String folder) async {
    try {
      String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      String uniqueFileName = '${timestamp}_$fileName';
      Reference ref = _storage.ref().child('$folder/$uniqueFileName');
      UploadTask uploadTask = ref.putData(
        Uint8List.fromList(imageBytes),
        SettableMetadata(contentType: 'image/jpeg'),
      );

      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      print('Error uploading image bytes: $e');
      return null;
    }
  }

  // Delete image from Firebase Storage
  Future<bool> deleteImage(String imageUrl) async {
    try {
      Reference ref = _storage.refFromURL(imageUrl);
      await ref.delete();
      return true;
    } catch (e) {
      print('Error deleting image: $e');
      return false;
    }
  }

  // Get list of images in a folder
  Future<List<String>> getImagesInFolder(String folder) async {
    try {
      ListResult result = await _storage.ref().child(folder).listAll();
      List<String> downloadUrls = [];

      for (Reference ref in result.items) {
        String downloadUrl = await ref.getDownloadURL();
        downloadUrls.add(downloadUrl);
      }

      return downloadUrls;
    } catch (e) {
      print('Error getting images: $e');
      return [];
    }
  }
}
