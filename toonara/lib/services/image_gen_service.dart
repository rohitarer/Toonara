import 'package:http/http.dart' as http;

class ImageGenService {
  // Pollinations API doesn't require auth
  final String _baseUrl = 'https://image.pollinations.ai/prompt';

  Future<String?> generateImage(String prompt) async {
    try {
      // Encode prompt for URL safety
      final encodedPrompt = Uri.encodeComponent(prompt);

      // Build the image URL directly
      final imageUrl = '$_baseUrl/$encodedPrompt';

      // Optionally, test the URL with a HEAD or GET request to ensure availability
      final response = await http.get(Uri.parse(imageUrl));

      if (response.statusCode == 200) {
        return imageUrl; // This is a direct image URL
      } else {
        print('[ImageGenService] ❌ Pollinations error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('[ImageGenService] ❗ Exception: $e');
      return null;
    }
  }
}

// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../config/api_keys.dart'; // Make sure `stableDiffusionApiKey` is defined here

// class ImageGenService {
//   final String _url = 'https://stablediffusionapi.com/api/v3/dreambooth';
//   final String _modelId = 'disney-pixar-cartoon';

//   Future<String?> generateImage(String prompt) async {
//     try {
//       print('[ImageGenService] Sending prompt to stablediffusionapi...');

//       final response = await http
//           .post(
//             Uri.parse(_url),
//             headers: {'Content-Type': 'application/json'},
//             body: jsonEncode({
//               "key": stableDiffusionApiKey,
//               "model_id": _modelId,
//               "prompt": prompt,
//               "negative_prompt":
//                   "extra fingers, mutated hands, poorly drawn face, deformed, blurry, bad anatomy",
//               "width": "512",
//               "height": "512",
//               "samples": "1",
//               "num_inference_steps": "30",
//               "safety_checker": "no",
//               "enhance_prompt": "yes",
//               "guidance_scale": 7.5,
//             }),
//           )
//           .timeout(const Duration(seconds: 40));

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         final output = data['output'];
//         if (output is List && output.isNotEmpty && output[0] is String) {
//           print('[ImageGenService] Image URL: ${output[0]}');
//           return output[0];
//         } else {
//           print('[ImageGenService] No valid image URL in output.');
//         }
//       } else {
//         print(
//           '[ImageGenService] Error ${response.statusCode}: ${response.body}',
//         );
//       }
//     } catch (e) {
//       print('[ImageGenService] Exception: $e');
//     }
//     return null;
//   }
// }
