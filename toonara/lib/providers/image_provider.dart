import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/image_gen_service.dart';

/// Provider for managing image generation state for a single panel
final imageGenerationProvider =
    StateNotifierProvider<ImageGenNotifier, AsyncValue<String?>>(
      (ref) => ImageGenNotifier(),
    );

class ImageGenNotifier extends StateNotifier<AsyncValue<String?>> {
  ImageGenNotifier() : super(const AsyncValue.data(null));

  final ImageGenService _imageService = ImageGenService();

  /// Triggers image generation using Hugging Face
  Future<void> generate(String prompt) async {
    state = const AsyncValue.loading();

    final stopwatch = Stopwatch()..start();
    try {
      final imageUrl = await _imageService.generateImage(prompt);
      stopwatch.stop();

      if (imageUrl != null) {
        print(
          '[ImageGenProvider] Image generated in ${stopwatch.elapsedMilliseconds}ms',
        );
        state = AsyncValue.data(imageUrl);
      } else {
        state = AsyncValue.error(
          'No image returned from Hugging Face.',
          StackTrace.current,
        );
      }
    } catch (e, st) {
      state = AsyncValue.error('[ImageGen Error] $e', st);
    }
  }

  /// Resets the state (e.g. for refreshing or clearing)
  void reset() {
    state = const AsyncValue.data(null);
  }
}
