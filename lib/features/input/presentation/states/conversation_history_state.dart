import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/conversation_entry.dart';

part 'conversation_history_state.freezed.dart';

@freezed
class ConversationHistoryState with _$ConversationHistoryState {
  const factory ConversationHistoryState({
    @Default([]) List<ConversationEntry> entries,
    @Default(false) bool isLoadingMore,
    @Default(false) bool hasReachedEnd,
    @Default(false) bool isInitializing,
  }) = _ConversationHistoryState;
}
