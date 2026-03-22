import '../entities/conversation_entry.dart';

abstract interface class IConversationHistoryRepository {
  Future<List<ConversationEntry>> loadInitialPage({int limit = 30});
  Future<List<ConversationEntry>> loadOlderThan(ConversationEntry cursor, {int limit = 30});
  Future<void> append(ConversationEntry entry);
  Future<void> updateEntry(ConversationEntry entry);
}
