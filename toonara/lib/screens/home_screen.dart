import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/comic_provider.dart';
import '../services/image_gen_service.dart';
import 'comic_view_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _controller = TextEditingController();
  bool isLoading = false;

  Future<void> _generateComic() async {
    final concept = _controller.text.trim();
    if (concept.isEmpty) {
      _showSnackBar("Please enter a concept to generate a comic.");
      return;
    }

    setState(() => isLoading = true);

    final notifier = ref.read(comicPanelsProvider.notifier);
    final imageService = ImageGenService();

    await notifier.generatePanels(concept);

    final panels = ref.read(comicPanelsProvider);
    if (panels.isEmpty) {
      _showSnackBar("Failed to generate comic script. Try again.");
      setState(() => isLoading = false);
      return;
    }

    for (int i = 0; i < panels.length; i++) {
      final prompt = panels[i].prompt;
      final image = await imageService.generateImage(prompt);
      if (image != null) {
        notifier.updateImage(i, image);
      }
    }

    if (!mounted) return;
    setState(() => isLoading = false);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ComicViewScreen()),
    );
  }

  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Toonara – AI Comic Generator")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              maxLines: 6,
              decoration: InputDecoration(
                hintText: 'Paste your concept or lesson module here...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: isLoading ? null : _generateComic,
              icon: const Icon(Icons.auto_awesome),
              label: Text(isLoading ? "Generating..." : "Generate Comic"),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            if (isLoading)
              const Padding(
                padding: EdgeInsets.only(top: 20),
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}
