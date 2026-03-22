import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class AudioFileStore {
  static const _subDir = 'audio';

  Future<Directory> _audioDir() async {
    final docs = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(docs.path, _subDir));
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  Future<String> save(String filename, List<int> bytes) async {
    final dir = await _audioDir();
    final file = File(p.join(dir.path, filename));
    await file.writeAsBytes(bytes);
    return file.path;
  }

  Future<void> delete(String filePath) async {
    final file = File(filePath);
    if (await file.exists()) {
      await file.delete();
    }
  }

  Future<void> clearAll() async {
    final dir = await _audioDir();
    if (await dir.exists()) {
      await dir.delete(recursive: true);
    }
  }

  Future<int> getTotalSizeBytes() async {
    final dir = await _audioDir();
    if (!await dir.exists()) return 0;
    int total = 0;
    await for (final entity in dir.list(recursive: true)) {
      if (entity is File) {
        total += await entity.length();
      }
    }
    return total;
  }
}

final audioFileStoreProvider = Provider<AudioFileStore>((ref) => AudioFileStore());
