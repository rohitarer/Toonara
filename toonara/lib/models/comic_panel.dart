class ComicPanel {
  final String prompt; // Visual description for AI image generation
  final String dialogue; // Dialogue or caption text
  final String? imageUrl; // Generated image (base64 or URL)

  const ComicPanel({
    required this.prompt,
    required this.dialogue,
    this.imageUrl,
  });

  /// Create a modified copy of this panel
  ComicPanel copyWith({String? prompt, String? dialogue, String? imageUrl}) {
    return ComicPanel(
      prompt: prompt ?? this.prompt,
      dialogue: dialogue ?? this.dialogue,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  /// Convert to Map (for Firestore, JSON, etc.)
  Map<String, dynamic> toMap() {
    return {'prompt': prompt, 'dialogue': dialogue, 'imageUrl': imageUrl};
  }

  /// Create from Map
  factory ComicPanel.fromMap(Map<String, dynamic> map) {
    return ComicPanel(
      prompt: map['prompt'] ?? '',
      dialogue: map['dialogue'] ?? '',
      imageUrl: map['imageUrl'],
    );
  }

  /// Convert to JSON string
  String toJson() => toMap().toString();

  /// Optional: Equality override (for testing, comparison)
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ComicPanel &&
            runtimeType == other.runtimeType &&
            prompt == other.prompt &&
            dialogue == other.dialogue &&
            imageUrl == other.imageUrl;
  }

  @override
  int get hashCode => prompt.hashCode ^ dialogue.hashCode ^ imageUrl.hashCode;
}
