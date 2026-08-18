import 'dart:io';

import 'package:path_provider/path_provider.dart';

/// Saves [bytes] to a temp file and returns its path, to be opened with the
/// OS's default PDF viewer via `launchUrl(Uri.file(path))`.
Future<String?> saveReceiptBytes(List<int> bytes, String filename) async {
  final dir = await getTemporaryDirectory();
  final file = File('${dir.path}/$filename');
  await file.writeAsBytes(bytes);
  return file.path;
}
