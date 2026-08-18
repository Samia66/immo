import 'dart:html' as html;

/// Triggers a browser download of [bytes] directly - there's no OS file
/// system to save into on web, the browser's own download UI handles it.
/// Returns null: unlike the native path, there's no file path to hand back
/// to the caller for a follow-up `launchUrl`.
Future<String?> saveReceiptBytes(List<int> bytes, String filename) async {
  final blob = html.Blob([bytes], 'application/pdf');
  final url = html.Url.createObjectUrlFromBlob(blob);
  html.AnchorElement(href: url)
    ..setAttribute('download', filename)
    ..click();
  html.Url.revokeObjectUrl(url);
  return null;
}
