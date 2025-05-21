import 'dart:convert';
import 'package:flutter/material.dart';

class ImageDisplay extends StatelessWidget {
  final String image;

  const ImageDisplay({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    if (image.startsWith('data:image')) {
      // It's a base64-encoded image
      try {
        final base64Data = image.split(',').last;
        final decodedBytes = base64Decode(base64Data);
        return Image.memory(
          decodedBytes,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const Text('Invalid base64 image'),
        );
      } catch (e) {
        return const Text('Failed to decode base64 image');
      }
    } else {
      // It's a direct image URL
      return Image.network(
        image,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const Text('Failed to load image'),
        loadingBuilder: (_, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(child: CircularProgressIndicator());
        },
      );
    }
  }
}
