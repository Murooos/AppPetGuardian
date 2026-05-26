import 'package:flutter/material.dart';

class PlatformImage extends StatelessWidget {
  final String? path;
  final double? width;
  final double? height;
  final BoxFit fit;

  const PlatformImage({super.key, required this.path, this.width, this.height, this.fit = BoxFit.cover});

  @override
  Widget build(BuildContext context) {
    if (path == null || path!.isEmpty) {
      return const Icon(Icons.pets, color: Colors.grey, size: 20);
    }
    if (path!.startsWith('http')) {
      return Image.network(path!, width: width, height: height, fit: fit);
    }
    // For web, local file paths are not supported; show fallback icon
    return const Icon(Icons.pets, color: Colors.grey, size: 20);
  }
}
