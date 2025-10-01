// lib/models/banner.dart
class BannerData {
  final String titleMarathi;
  final String subtitleMarathi;
  final bool isActive;

  BannerData({
    required this.titleMarathi,
    required this.subtitleMarathi,
    required this.isActive,
  });

  factory BannerData.fromFirestore(Map<String, dynamic> data) {
    return BannerData(
      titleMarathi: data['title_marathi'] ?? '',
      subtitleMarathi: data['subtitle_marathi'] ?? '',
      isActive: data['isActive'] ?? false,
    );
  }
}
