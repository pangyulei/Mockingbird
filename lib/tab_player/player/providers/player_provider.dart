


//   Future<String?> _pickOneSubtitle() async {
//     try {
//       final subtitleExtensions = {'.srt', '.vtt'};
//       final pickedFiles = await FilePicker.pickFiles(
//         type: FileType.custom,
//         allowedExtensions: [...subtitleExtensions],
//       );
//       final subtitlePath = pickedFiles
//           .map((pf) => File(pf.xFile.path))
//           .toList()
//           .firstWhereOrNull(
//             (f) => subtitleExtensions.contains(p.extension(f.path)),
//           )
//           ?.path;
//       return subtitlePath;
//     } catch (e) {
//       debugPrint('Error adding subtitle: $e');
//       return null;
//     }
//   }
// }
