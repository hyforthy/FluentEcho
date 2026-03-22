import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/database/app_database.dart';
import '../entities/note.dart';

class ExportImportNotesUseCase {
  ExportImportNotesUseCase(this._db);

  final AppDatabase _db;

  /// Exports all notes as a JSON file and triggers the system share/save dialog.
  /// Returns the number of notes exported.
  Future<int> export() async {
    final notes = await _db.notesDao.getAll();

    final payload = {
      'version': 1,
      'exportedAt': DateTime.now().toUtc().toIso8601String(),
      'notes': notes.map(_noteToJson).toList(),
    };

    final jsonStr =
        const JsonEncoder.withIndent('  ').convert(payload);

    final dir = await getTemporaryDirectory();
    final dateStr = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final file = File('${dir.path}/english_notes_$dateStr.json');
    await file.writeAsString(jsonStr, encoding: utf8);

    await Share.shareXFiles(
      [XFile(file.path, mimeType: 'application/json')],
      subject: '英语笔记导出 $dateStr',
    );

    return notes.length;
  }

  /// Prompts the user to pick a JSON file and imports notes from it.
  /// Returns an `(imported, skipped)` tuple: number of notes imported and number skipped due to format errors.
  Future<(int imported, int skipped)> import() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
      allowMultiple: false,
    );
    if (result == null || result.files.isEmpty) {
      return (0, 0); // user cancelled
    }

    final path = result.files.single.path;
    if (path == null) return (0, 0);

    final content = await File(path).readAsString(encoding: utf8);
    final Map<String, dynamic> payload;
    try {
      payload = jsonDecode(content) as Map<String, dynamic>;
    } catch (_) {
      throw const FormatException('文件不是有效的 JSON 格式');
    }

    final version = payload['version'];
    if (version != 1) {
      throw FormatException('不支持的导出版本：$version');
    }

    final rawNotes = payload['notes'];
    if (rawNotes is! List) {
      throw const FormatException('JSON 格式错误：缺少 notes 数组');
    }

    int imported = 0;
    int skipped = 0;

    for (final raw in rawNotes) {
      if (raw is! Map<String, dynamic>) { skipped++; continue; }
      try {
        final originalText = raw['originalText'] as String?;
        if (originalText == null || originalText.isEmpty) {
          skipped++;
          continue;
        }
        final createdAt = raw['createdAt'] != null
            ? DateTime.tryParse(raw['createdAt'] as String) ?? DateTime.now()
            : DateTime.now();
        final updatedAt = raw['updatedAt'] != null
            ? DateTime.tryParse(raw['updatedAt'] as String) ?? createdAt
            : createdAt;

        await _db.notesDao.insert(
          NotesCompanion.insert(
            originalText: originalText,
            optimizedText: Value(raw['optimizedText'] as String?),
            translatedText: Value(raw['translatedText'] as String?),
            detectedLanguage: Value(
                (raw['detectedLanguage'] as String?) ?? 'zh'),
            detectionConfidence:
                Value((raw['detectionConfidence'] as num?)?.toDouble() ?? 1.0),
            isFavorite: Value((raw['isFavorite'] as bool?) ?? false),
            createdAt: Value(createdAt),
            updatedAt: Value(updatedAt),
          ),
        );
        imported++;
      } catch (_) {
        skipped++;
      }
    }

    return (imported, skipped);
  }

  Map<String, dynamic> _noteToJson(Note n) => {
        'originalText': n.originalText,
        'optimizedText': n.optimizedText,
        'translatedText': n.translatedText,
        'detectedLanguage': n.detectedLanguage,
        'detectionConfidence': n.detectionConfidence,
        'isFavorite': n.isFavorite,
        'createdAt': n.createdAt.toUtc().toIso8601String(),
        'updatedAt': n.updatedAt.toUtc().toIso8601String(),
      };
}

final exportImportNotesUseCaseProvider =
    Provider<ExportImportNotesUseCase>((ref) {
  return ExportImportNotesUseCase(ref.watch(appDatabaseProvider));
});
