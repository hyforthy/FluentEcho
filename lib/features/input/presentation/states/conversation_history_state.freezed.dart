// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'conversation_history_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ConversationHistoryState {
  List<ConversationEntry> get entries => throw _privateConstructorUsedError;
  bool get isLoadingMore => throw _privateConstructorUsedError;
  bool get hasReachedEnd => throw _privateConstructorUsedError;
  bool get isInitializing => throw _privateConstructorUsedError;

  /// Create a copy of ConversationHistoryState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConversationHistoryStateCopyWith<ConversationHistoryState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConversationHistoryStateCopyWith<$Res> {
  factory $ConversationHistoryStateCopyWith(ConversationHistoryState value,
          $Res Function(ConversationHistoryState) then) =
      _$ConversationHistoryStateCopyWithImpl<$Res, ConversationHistoryState>;
  @useResult
  $Res call(
      {List<ConversationEntry> entries,
      bool isLoadingMore,
      bool hasReachedEnd,
      bool isInitializing});
}

/// @nodoc
class _$ConversationHistoryStateCopyWithImpl<$Res,
        $Val extends ConversationHistoryState>
    implements $ConversationHistoryStateCopyWith<$Res> {
  _$ConversationHistoryStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ConversationHistoryState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? entries = null,
    Object? isLoadingMore = null,
    Object? hasReachedEnd = null,
    Object? isInitializing = null,
  }) {
    return _then(_value.copyWith(
      entries: null == entries
          ? _value.entries
          : entries // ignore: cast_nullable_to_non_nullable
              as List<ConversationEntry>,
      isLoadingMore: null == isLoadingMore
          ? _value.isLoadingMore
          : isLoadingMore // ignore: cast_nullable_to_non_nullable
              as bool,
      hasReachedEnd: null == hasReachedEnd
          ? _value.hasReachedEnd
          : hasReachedEnd // ignore: cast_nullable_to_non_nullable
              as bool,
      isInitializing: null == isInitializing
          ? _value.isInitializing
          : isInitializing // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ConversationHistoryStateImplCopyWith<$Res>
    implements $ConversationHistoryStateCopyWith<$Res> {
  factory _$$ConversationHistoryStateImplCopyWith(
          _$ConversationHistoryStateImpl value,
          $Res Function(_$ConversationHistoryStateImpl) then) =
      __$$ConversationHistoryStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<ConversationEntry> entries,
      bool isLoadingMore,
      bool hasReachedEnd,
      bool isInitializing});
}

/// @nodoc
class __$$ConversationHistoryStateImplCopyWithImpl<$Res>
    extends _$ConversationHistoryStateCopyWithImpl<$Res,
        _$ConversationHistoryStateImpl>
    implements _$$ConversationHistoryStateImplCopyWith<$Res> {
  __$$ConversationHistoryStateImplCopyWithImpl(
      _$ConversationHistoryStateImpl _value,
      $Res Function(_$ConversationHistoryStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of ConversationHistoryState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? entries = null,
    Object? isLoadingMore = null,
    Object? hasReachedEnd = null,
    Object? isInitializing = null,
  }) {
    return _then(_$ConversationHistoryStateImpl(
      entries: null == entries
          ? _value._entries
          : entries // ignore: cast_nullable_to_non_nullable
              as List<ConversationEntry>,
      isLoadingMore: null == isLoadingMore
          ? _value.isLoadingMore
          : isLoadingMore // ignore: cast_nullable_to_non_nullable
              as bool,
      hasReachedEnd: null == hasReachedEnd
          ? _value.hasReachedEnd
          : hasReachedEnd // ignore: cast_nullable_to_non_nullable
              as bool,
      isInitializing: null == isInitializing
          ? _value.isInitializing
          : isInitializing // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$ConversationHistoryStateImpl implements _ConversationHistoryState {
  const _$ConversationHistoryStateImpl(
      {final List<ConversationEntry> entries = const [],
      this.isLoadingMore = false,
      this.hasReachedEnd = false,
      this.isInitializing = false})
      : _entries = entries;

  final List<ConversationEntry> _entries;
  @override
  @JsonKey()
  List<ConversationEntry> get entries {
    if (_entries is EqualUnmodifiableListView) return _entries;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_entries);
  }

  @override
  @JsonKey()
  final bool isLoadingMore;
  @override
  @JsonKey()
  final bool hasReachedEnd;
  @override
  @JsonKey()
  final bool isInitializing;

  @override
  String toString() {
    return 'ConversationHistoryState(entries: $entries, isLoadingMore: $isLoadingMore, hasReachedEnd: $hasReachedEnd, isInitializing: $isInitializing)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConversationHistoryStateImpl &&
            const DeepCollectionEquality().equals(other._entries, _entries) &&
            (identical(other.isLoadingMore, isLoadingMore) ||
                other.isLoadingMore == isLoadingMore) &&
            (identical(other.hasReachedEnd, hasReachedEnd) ||
                other.hasReachedEnd == hasReachedEnd) &&
            (identical(other.isInitializing, isInitializing) ||
                other.isInitializing == isInitializing));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_entries),
      isLoadingMore,
      hasReachedEnd,
      isInitializing);

  /// Create a copy of ConversationHistoryState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConversationHistoryStateImplCopyWith<_$ConversationHistoryStateImpl>
      get copyWith => __$$ConversationHistoryStateImplCopyWithImpl<
          _$ConversationHistoryStateImpl>(this, _$identity);
}

abstract class _ConversationHistoryState implements ConversationHistoryState {
  const factory _ConversationHistoryState(
      {final List<ConversationEntry> entries,
      final bool isLoadingMore,
      final bool hasReachedEnd,
      final bool isInitializing}) = _$ConversationHistoryStateImpl;

  @override
  List<ConversationEntry> get entries;
  @override
  bool get isLoadingMore;
  @override
  bool get hasReachedEnd;
  @override
  bool get isInitializing;

  /// Create a copy of ConversationHistoryState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConversationHistoryStateImplCopyWith<_$ConversationHistoryStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
