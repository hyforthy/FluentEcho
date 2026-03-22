import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/app_database.dart';
import '../../domain/entities/note.dart';

/// Note group (grouped by date)
class NoteGroup {
  final DateTime date;
  final List<Note> notes;

  const NoteGroup({required this.date, required this.notes});
}

/// Search query provider
final searchQueryProvider = StateProvider<String>((ref) => '');

/// Note filter provider
final noteFilterProvider = StateProvider<NoteFilter>((ref) => NoteFilter.all);

/// Selected tag id provider (null means no tag filter active)
final selectedTagIdProvider = StateProvider<int?>((ref) => null);

/// Exposes the filtered notes stream; re-creates when filter/search/tag changes
final filteredNotesStreamProvider = StreamProvider<List<Note>>((ref) {
  final filter = ref.watch(noteFilterProvider);
  final query = ref.watch(searchQueryProvider);
  final tagId = ref.watch(selectedTagIdProvider);
  final db = ref.watch(appDatabaseProvider);
  return db.notesDao.watchNotes(
    filter: filter,
    searchQuery: query.isNotEmpty ? query : null,
    tagId: tagId,
  );
});

/// Note list Notifier (grouped by date, supports filtering and search)
class NoteListNotifier extends AsyncNotifier<List<NoteGroup>> {
  @override
  Future<List<NoteGroup>> build() async {
    final notes = await ref.watch(filteredNotesStreamProvider.future);
    return _groupByDate(notes);
  }

  List<NoteGroup> _groupByDate(List<Note> notes) {
    final grouped = <String, List<Note>>{};
    for (final note in notes) {
      final dateKey =
          '${note.createdAt.year}-${note.createdAt.month.toString().padLeft(2, '0')}-${note.createdAt.day.toString().padLeft(2, '0')}';
      grouped.putIfAbsent(dateKey, () => []).add(note);
    }
    return grouped.entries
        .map((e) => NoteGroup(
              date: DateTime.parse(e.key),
              notes: e.value,
            ))
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }
}

final noteListNotifierProvider =
    AsyncNotifierProvider<NoteListNotifier, List<NoteGroup>>(NoteListNotifier.new);
