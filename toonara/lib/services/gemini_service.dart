import 'package:google_generative_ai/google_generative_ai.dart';
import '../config/api_keys.dart';

class GeminiService {
  final _model = GenerativeModel(
    model: 'gemini-2.0-flash',
    apiKey: geminiApiKey,
  );

  Future<List<Map<String, String>>> generateComicScript(String concept) async {
    print('[GeminiService] Starting comic script generation...');
    print('[GeminiService] Concept received:\n$concept');

    final prompt = '''
🎨 You are a comic strip writer for Indian college students. Your job is to turn the educational concept below into a *funny, desi-style comic script*.

📘 Format:
Return a JSON array. Each panel must include:
- "Scene": Short description of what's visually happening.
- "Dialogue": Funny speech of the characters (use Indian-English, casual tone, memes, Hinglish jokes if needed).

😂 Style:
- Make it **relatable for Indian students**.
- Use jokes like: "Yaar, this is tougher than 8 AM lectures!", "Bro, my brain just Ctrl+Alt+Deleted itself", etc.
- Include playful exaggeration, sarcasm, drama.
- Add punchlines like a classic cartoon strip.
- Do *not* restrict to 3 panels — take as many as needed to explain the concept fully.

🎯 Goal:
- Fully explain the concept *in comic-strip style*
- Make it visually easy and mentally fun
- Output ONLY a valid JSON array of panels.

Concept:
$concept
''';

    try {
      print('[GeminiService] Sending prompt to Gemini API...');
      final response = await _model.generateContent([Content.text(prompt)]);
      print('[GeminiService] Received response from Gemini API.');

      final output = response.text ?? '';
      print('[Gemini Raw Output]\n$output');

      List<Map<String, String>> panels = [];

      // ✅ Step 1: Try parsing JSON-style "Scene": "", "Dialogue": ""
      final regex = RegExp(
        r'"Scene"\s*:\s*"([^"]+)"\s*,\s*"Dialogue"\s*:\s*"([^"]+)"',
        caseSensitive: false,
      );

      final matches = regex.allMatches(output);
      // After regex match logic...
      for (final match in matches) {
        final scene = match.group(1)?.trim() ?? '';
        final dialogue = match.group(2)?.trim() ?? '';

        // Skip if scene/dialogue is too short
        if (scene.length < 5 || dialogue.length < 5) continue;

        // ✅ Preserve multiline dialogues as a single block
        panels.add({'prompt': scene, 'dialogue': dialogue});
      }

      // ✅ Step 2: Fallback to Scene:/Dialogue: style parsing
      if (panels.isEmpty) {
        final lines =
            output
                .split('\n')
                .map((line) => line.trim())
                .where((line) => line.isNotEmpty)
                .toList();

        String? currentScene;
        for (final line in lines) {
          if (line.toLowerCase().startsWith('scene:')) {
            currentScene =
                line
                    .replaceFirst(RegExp(r'Scene:', caseSensitive: false), '')
                    .trim();
          } else if (line.toLowerCase().startsWith('dialogue:') &&
              currentScene != null) {
            final dialogue =
                line
                    .replaceFirst(
                      RegExp(r'Dialogue:', caseSensitive: false),
                      '',
                    )
                    .trim();
            if (currentScene.length >= 5 && dialogue.length >= 5) {
              panels.add({'prompt': currentScene, 'dialogue': dialogue});
              currentScene = null;
            }
          }
        }
      }

      // ✅ Final fallback (don't generate image for this)
      if (panels.isEmpty && output.isNotEmpty) {
        panels.add({
          'prompt': 'A confused student surrounded by textbooks',
          'dialogue': output.trim(),
        });
      }

      // ✅ Limit to avoid accidental bulk image generation (optional)
      // panels = panels.take(10).toList();

      print('[GeminiService] ✅ Returning ${panels.length} clean panel(s).');
      return panels;
    } catch (e) {
      print('[GeminiService] ❌ Exception: $e');
      return [];
    }
  }
}

// import 'dart:convert';

// import 'package:google_generative_ai/google_generative_ai.dart';
// import '../config/api_keys.dart';

// class GeminiService {
//   final _model = GenerativeModel(
//     model: 'gemini-2.0-flash',
//     apiKey: geminiApiKey,
//   );

//   Future<List<Map<String, String>>> generateComicScript(String concept) async {
//     print('[GeminiService] Starting comic script generation...');
//     print('[GeminiService] Concept received:\n$concept');

//     final prompt = '''
// Turn the following educational concept into a fun 3-panel comic script.

// Each panel must include:
// - Scene: [short visual description]
// - Dialogue: [character: says something]

// Only return 3 entries in structured plain text or JSON format.

// Concept:
// $concept
// ''';

//     try {
//       print('[GeminiService] Sending prompt to Gemini API...');
//       final response = await _model.generateContent([Content.text(prompt)]);
//       print('[GeminiService] Received response from Gemini API.');

//       final output = response.text ?? '';
//       print('[Gemini Raw Output]\n$output');

//       List<Map<String, String>> panels = [];

//       /// Step 1: Try JSON-like parsing manually
//       final regex = RegExp(
//         r'"Scene"\s*:\s*"([^"]+)"\s*,\s*"Dialogue"\s*:\s*"([^"]+)"',
//         caseSensitive: false,
//       );
//       final matches = regex.allMatches(output);

//       for (final match in matches) {
//         final scene = match.group(1)?.trim() ?? '';
//         final dialogue = match.group(2)?.trim() ?? '';
//         if (scene.isNotEmpty && dialogue.isNotEmpty) {
//           panels.add({'prompt': scene, 'dialogue': dialogue});
//         }
//       }

//       // Step 2: Fallback to Scene:/Dialogue: style
//       if (panels.isEmpty) {
//         final lines =
//             output
//                 .split('\n')
//                 .map((line) => line.trim())
//                 .where((line) => line.isNotEmpty)
//                 .toList();
//         String? currentScene;

//         for (final line in lines) {
//           if (line.toLowerCase().startsWith('scene:')) {
//             currentScene =
//                 line
//                     .replaceFirst(RegExp(r'Scene:', caseSensitive: false), '')
//                     .trim();
//           } else if (line.toLowerCase().startsWith('dialogue:') &&
//               currentScene != null) {
//             final dialogue =
//                 line
//                     .replaceFirst(
//                       RegExp(r'Dialogue:', caseSensitive: false),
//                       '',
//                     )
//                     .trim();
//             panels.add({'prompt': currentScene, 'dialogue': dialogue});
//             currentScene = null;
//           }
//         }
//       }

//       // Final fallback
//       if (panels.isEmpty && output.isNotEmpty) {
//         panels.add({
//           'prompt': 'A generic educational scene',
//           'dialogue': output,
//         });
//       }

//       print('[GeminiService] Returning ${panels.length} panel(s).');
//       return panels;
//     } catch (e) {
//       print('[Gemini Error] $e');
//       return [];
//     }
//   }
// }
