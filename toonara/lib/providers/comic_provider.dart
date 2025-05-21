import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/comic_panel.dart';
import '../services/gemini_service.dart';

/// Riverpod StateNotifierProvider for managing comic panel state
final comicPanelsProvider =
    StateNotifierProvider<ComicPanelsNotifier, List<ComicPanel>>(
      (ref) => ComicPanelsNotifier(),
    );

class ComicPanelsNotifier extends StateNotifier<List<ComicPanel>> {
  ComicPanelsNotifier() : super([]);

  final GeminiService _geminiService = GeminiService();

  /// Step 1: Generate panels using Gemini
  Future<void> generatePanels(String concept) async {
    state = []; // Reset previous state

    final panelData = await _geminiService.generateComicScript(concept);

    if (panelData.isEmpty) {
      print("[ComicProvider] Gemini returned no panels.");
      return;
    }

    final newPanels =
        panelData.map((entry) {
          return ComicPanel(
            prompt: entry['prompt'] ?? 'Missing scene',
            dialogue: entry['dialogue'] ?? 'Missing dialogue',
            imageUrl: null,
          );
        }).toList();

    state = newPanels;

    print("[ComicProvider] ${state.length} panels created.");
  }

  /// Step 2: Update individual panel with generated image
  void updateImage(int index, String imageUrl) {
    if (index < 0 || index >= state.length) {
      print("[ComicProvider] Invalid index $index for image update.");
      return;
    }

    final updatedPanel = state[index].copyWith(imageUrl: imageUrl);
    state[index] = updatedPanel;
    state = [...state]; // Trigger state update
  }

  /// Optional: Clear all panels
  void clearPanels() {
    state = [];
  }
}
