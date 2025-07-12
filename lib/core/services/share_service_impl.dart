import 'dart:io';

import 'package:share_plus/share_plus.dart';

import '../../domain/services/share_service.dart';

class ShareServiceImpl implements ShareService {
  @override
  Future<void> shareFile(File file, {String? text, String? subject}) {
    return Share.shareXFiles(
      [XFile(file.path)],
      text: text,
      subject: subject,
    );
  }
}
