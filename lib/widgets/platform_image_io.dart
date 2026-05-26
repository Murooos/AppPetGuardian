import 'dart:io';
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
    final file = File(path!);
    if (file.existsSync()) {
      return Image.file(file, width: width, height: height, fit: fit);
    }
    // Fallback: if path looks like a network URL, try network
    if (path!.startsWith('http')) {
      return Image.network(path!, width: width, height: height, fit: fit);
    }
    return const Icon(Icons.pets, color: Colors.grey, size: 20);
  }
}
