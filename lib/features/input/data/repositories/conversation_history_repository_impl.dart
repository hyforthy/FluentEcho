import '../../domain/entities/conversation_entry.dart';
import '../../domain/repositories/i_conversation_history_repository.dart';
import '../daos/conversation_entry_dao.dart';

class ConversationHistoryRepositoryImpl implements IConversationHistoryRepository {
  final ConversationEntryDao _dao;

  ConversationHistoryRepositoryImpl(this._dao);

  @override
  Future<List<ConversationEntry>> loadInitialPage({int limit = 30}) =>
      _dao.getOlderThan(
        createdAtMs: DateTime.now().millisecondsSinceEpoch + 1,
        id: '',
        limit: limit,
      );

  @override
  Future<List<ConversationEntry>> loadOlderThan(
    ConversationEntry cursor, {
    int limit = 30,
  }) =>
      _dao.getOlderThan(
        createdAtMs: cursor.createdAt.millisecondsSinceEpoch,
        id: cursor.id,
        limit: limit,
      );

  @override
  Future<void> append(ConversationEntry entry) => _dao.insertEntry(entry);

  @override
  Future<void> updateEntry(ConversationEntry entry) => _dao.updateEntry(entry);
}
