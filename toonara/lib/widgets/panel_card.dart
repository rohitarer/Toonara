import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/comic_panel.dart';

class PanelCard extends StatelessWidget {
  final ComicPanel panel;
  final int index;

  const PanelCard({super.key, required this.panel, required this.index});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (panel.imageUrl != null)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: Image.memory(
                base64Decode(panel.imageUrl!.split(',').last),
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            )
          else
            Container(
              height: 180,
              alignment: Alignment.center,
              color: Colors.grey[300],
              child: Text(
                "No image available",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[700],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Text(
              panel.dialogue.isNotEmpty
                  ? panel.dialogue
                  : "No dialogue provided.",
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
