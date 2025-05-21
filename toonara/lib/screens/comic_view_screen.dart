import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../providers/comic_provider.dart';

class ComicViewScreen extends ConsumerWidget {
  const ComicViewScreen({super.key});

  Future<Uint8List?> _getImageBytes(String imageUrl) async {
    try {
      if (imageUrl.startsWith('data:image')) {
        final base64Data = imageUrl.split(',').last;
        return base64Decode(base64Data);
      } else {
        final response = await http.get(Uri.parse(imageUrl));
        if (response.statusCode == 200) {
          return response.bodyBytes;
        }
      }
    } catch (e) {
      print('[ComicViewScreen] Error decoding image: $e');
    }
    return null;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final panels = ref.watch(comicPanelsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Toonara Comic Page")),
      body:
          panels.isEmpty
              ? const Center(child: Text("No comic generated yet."))
              : Padding(
                padding: const EdgeInsets.all(12.0),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    int crossAxisCount = 2; // Default 2xN grid
                    if (constraints.maxWidth > 800) crossAxisCount = 3;

                    return GridView.builder(
                      itemCount: panels.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 3 / 4,
                      ),
                      itemBuilder: (context, index) {
                        final panel = panels[index];
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.yellow[100],
                            border: Border.all(color: Colors.black, width: 2),
                          ),
                          child: Column(
                            children: [
                              if (panel.imageUrl != null)
                                Expanded(
                                  child: Image.network(
                                    panel.imageUrl!,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    errorBuilder:
                                        (_, __, ___) => const Center(
                                          child: Text('Image error'),
                                        ),
                                  ),
                                ),
                              Container(
                                padding: const EdgeInsets.all(8),
                                color: Colors.white,
                                child: Text(
                                  panel.dialogue,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'ComicNeue',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
    );
  }
}

// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:http/http.dart' as http;
// import 'package:printing/printing.dart';
// import 'package:pdf/widgets.dart' as pw;

// import '../providers/comic_provider.dart';

// class ComicViewScreen extends ConsumerWidget {
//   const ComicViewScreen({super.key});

//   Future<Uint8List?> _getImageBytes(String imageUrl) async {
//     try {
//       if (imageUrl.startsWith('data:image')) {
//         // Base64 image
//         final base64Data = imageUrl.split(',').last;
//         return base64Decode(base64Data);
//       } else {
//         // URL image
//         final response = await http.get(Uri.parse(imageUrl));
//         if (response.statusCode == 200) {
//           return response.bodyBytes;
//         }
//       }
//     } catch (e) {
//       print('[ComicViewScreen] Error decoding image: $e');
//     }
//     return null;
//   }

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final panels = ref.watch(comicPanelsProvider);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Your Comic"),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.picture_as_pdf),
//             tooltip: 'Export as PDF',
//             onPressed: () async {
//               if (panels.isEmpty || panels.every((p) => p.imageUrl == null)) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('No comic to export.')),
//                 );
//                 return;
//               }

//               await Printing.layoutPdf(
//                 onLayout: (format) async {
//                   final pdf = pw.Document();

//                   pdf.addPage(
//                     pw.Page(
//                       build:
//                           (context) => pw.Center(
//                             child: pw.Text(
//                               'Your Toonara Comic',
//                               style: pw.TextStyle(
//                                 fontSize: 24,
//                                 fontWeight: pw.FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                     ),
//                   );

//                   for (var panel in panels) {
//                     if (panel.imageUrl == null) continue;
//                     final bytes = await _getImageBytes(panel.imageUrl!);
//                     if (bytes == null) continue;

//                     final image = pw.MemoryImage(bytes);

//                     pdf.addPage(
//                       pw.Page(
//                         build:
//                             (context) => pw.Column(
//                               crossAxisAlignment: pw.CrossAxisAlignment.center,
//                               children: [
//                                 pw.Image(image),
//                                 pw.SizedBox(height: 12),
//                                 pw.Text(
//                                   panel.dialogue,
//                                   textAlign: pw.TextAlign.center,
//                                   style: pw.TextStyle(fontSize: 14),
//                                 ),
//                               ],
//                             ),
//                       ),
//                     );
//                   }

//                   return pdf.save();
//                 },
//               );
//             },
//           ),
//         ],
//       ),
//       body:
//           panels.isEmpty
//               ? const Center(child: Text("No comic generated yet."))
//               : ListView.builder(
//                 padding: const EdgeInsets.all(12),
//                 itemCount: panels.length,
//                 itemBuilder: (context, index) {
//                   final panel = panels[index];

//                   return Card(
//                     margin: const EdgeInsets.symmetric(vertical: 10),
//                     elevation: 4,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.stretch,
//                       children: [
//                         if (panel.imageUrl != null)
//                           ClipRRect(
//                             borderRadius: const BorderRadius.vertical(
//                               top: Radius.circular(16),
//                             ),
//                             child: Image.network(
//                               panel.imageUrl!,
//                               fit: BoxFit.cover,
//                               errorBuilder:
//                                   (_, __, ___) =>
//                                       const Text('Failed to load image'),
//                               loadingBuilder: (_, child, progress) {
//                                 if (progress == null) return child;
//                                 return const Center(
//                                   child: CircularProgressIndicator(),
//                                 );
//                               },
//                             ),
//                           ),
//                         Padding(
//                           padding: const EdgeInsets.all(12.0),
//                           child: Text(
//                             panel.dialogue,
//                             textAlign: TextAlign.center,
//                             style: Theme.of(context).textTheme.bodyLarge
//                                 ?.copyWith(fontWeight: FontWeight.w500),
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//     );
//   }
// }
