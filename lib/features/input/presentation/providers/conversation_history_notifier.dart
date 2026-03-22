import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/app_database.dart' hide ConversationEntry;
import '../../../../core/storage/audio_file_store.dart';
import '../../data/repositories/conversation_history_repository_impl.dart';
import '../../domain/entities/conversation_entry.dart';
import '../../domain/repositories/i_conversation_history_repository.dart';
import '../states/conversation_history_state.dart';

final conversationHistoryRepositoryProvider =
    Provider<IConversationHistoryRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return ConversationHistoryRepositoryImpl(db.conversationEntryDao);
});

/// In-memory + persisted conversation history Notifier.
/// Loads from DB on build, appends to DB on add.
class ConversationHistoryNotifier
    extends Notifier<ConversationHistoryState> {
  @override
  ConversationHistoryState build() {
    _initialize();
    return const ConversationHistoryState(isInitializing: true);
  }

  IConversationHistoryRepository get _repo =>
      ref.read(conversationHistoryRepositoryProvider);

  Future<void> _initialize() async {
    // DB returns DESC (newest first). Reverse to ASC (oldest first) to match
    // the view's index remapper: historyIndex = history.length - 1 - index,
    // which expects history[last] = newest (shown at visual bottom with reverse:true).
    final dbEntries = await _repo.loadInitialPage();
    final dbIds = dbEntries.map((e) => e.id).toSet();
    final inFlight =
        state.entries.where((e) => !dbIds.contains(e.id)).toList();
    state = ConversationHistoryState(
      entries: [...dbEntries.reversed.toList(), ...inFlight],
      isInitializing: false,
      hasReachedEnd: dbEntries.length < 30,
    );
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore ||
        state.hasReachedEnd ||
        state.entries.isEmpty ||
        state.isInitializing) {
      return;
    }
    state = state.copyWith(isLoadingMore: true);
    // entries[0] is the oldest loaded entry (ASC storage).
    final oldest = state.entries.first;
    final older = await _repo.loadOlderThan(oldest);
    // Reverse DESC result to ASC then prepend so older entries appear at front
    // (visual top in reverse:true ListView).
    state = state.copyWith(
      entries: [...older.reversed.toList(), ...state.entries],
      isLoadingMore: false,
      hasReachedEnd: older.isEmpty,
    );
  }

  Future<void> addEntry(ConversationEntry entry) async {
    // Append newest entry at the end (ASC storage; view remapper shows it at bottom).
    state = state.copyWith(entries: [...state.entries, entry]);
    await _repo.append(entry);
  }

  void updateEntry(ConversationEntry entry) {
    final idx = state.entries.indexWhere((e) => e.id == entry.id);
    if (idx == -1) return;
    final updated = [...state.entries];
    updated[idx] = entry;
    state = state.copyWith(entries: updated);
    unawaited(_repo.updateEntry(entry));
  }

  void updateAudioPath(String entryId, String audioPath) {
    final idx = state.entries.indexWhere((e) => e.id == entryId);
    if (idx == -1) return;
    final entry = state.entries[idx].copyWith(audioFilePath: audioPath);
    updateEntry(entry);
  }

  void markSaved(String entryId, int noteId) {
    final idx = state.entries.indexWhere((e) => e.id == entryId);
    if (idx == -1) return;
    final entry = state.entries[idx].copyWith(savedNoteId: noteId);
    updateEntry(entry);
  }

  void markUnsaved(String entryId) {
    final idx = state.entries.indexWhere((e) => e.id == entryId);
    if (idx == -1) return;
    // copyWith(savedNoteId: null) is silently ignored by Freezed.
    // clearSavedNoteId() rebuilds the object with savedNoteId explicitly null.
    final entry = state.entries[idx].clearSavedNoteId();
    updateEntry(entry);
  }

  void clear() {
    state = const ConversationHistoryState();
  }

  /// Clears the conversation session.
  /// Audio files that are linked to saved notes are preserved;
  /// only orphaned conversation audio files are deleted.
  Future<void> clearSession() async {
    final conversationAudioPaths = state.entries
        .map((e) => e.audioFilePath)
        .whereType<String>()
        .toSet();

    if (conversationAudioPaths.isNotEmpty) {
      final noteAudioPaths =
          await ref.read(appDatabaseProvider).notesDao.getAllAudioPaths();
      // Also protect audio from entries that have a savedNoteId — guards against
      // a race condition where the note's audioFilePath was not yet written to DB.
      final savedEntryAudioPaths = state.entries
          .where((e) => e.savedNoteId != null && e.audioFilePath != null)
          .map((e) => e.audioFilePath!)
          .toSet();
      final protectedPaths = noteAudioPaths.union(savedEntryAudioPaths);
      final store = ref.read(audioFileStoreProvider);
      for (final path in conversationAudioPaths) {
        if (!protectedPaths.contains(path)) {
          await store.delete(path);
        }
      }
    }

    clear();
  }
}

final conversationHistoryProvider =
    NotifierProvider<ConversationHistoryNotifier, ConversationHistoryState>(
  ConversationHistoryNotifier.new,
);

/// Backward-compatible alias for [conversationHistoryProvider].
final conversationHistoryNotifierProvider = conversationHistoryProvider;
