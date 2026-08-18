/// Saves downloaded receipt PDF bytes and hands back a way to open them.
///
/// Platform-specific: on native, bytes are written to a temp file and the
/// path is returned so the caller can `launchUrl(Uri.file(path))`. On web
/// there's no OS filesystem to write into - the browser's own download UI is
/// triggered directly instead, so this returns null (nothing left to open).
export 'receipt_saver_io.dart' if (dart.library.html) 'receipt_saver_web.dart';
