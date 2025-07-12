import 'dart:io';

abstract class ShareService {
  Future<void> shareFile(File file, {String? text, String? subject});
}
