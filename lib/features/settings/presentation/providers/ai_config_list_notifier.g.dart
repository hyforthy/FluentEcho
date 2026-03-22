// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_config_list_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$aiConfigListNotifierHash() =>
    r'd4788e0e5797d7dca4ac120ef8264c91a0b0d0c4';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$AiConfigListNotifier
    extends BuildlessAsyncNotifier<List<AIServiceConfig>> {
  late final AIServiceType type;

  FutureOr<List<AIServiceConfig>> build(
    AIServiceType type,
  );
}

/// AI config list Notifier (family by AIServiceType).
/// Write operations call ref.invalidateSelf() to keep UI in sync with DB state.
///
/// Copied from [AiConfigListNotifier].
@ProviderFor(AiConfigListNotifier)
const aiConfigListNotifierProvider = AiConfigListNotifierFamily();

/// AI config list Notifier (family by AIServiceType).
/// Write operations call ref.invalidateSelf() to keep UI in sync with DB state.
///
/// Copied from [AiConfigListNotifier].
class AiConfigListNotifierFamily
    extends Family<AsyncValue<List<AIServiceConfig>>> {
  /// AI config list Notifier (family by AIServiceType).
  /// Write operations call ref.invalidateSelf() to keep UI in sync with DB state.
  ///
  /// Copied from [AiConfigListNotifier].
  const AiConfigListNotifierFamily();

  /// AI config list Notifier (family by AIServiceType).
  /// Write operations call ref.invalidateSelf() to keep UI in sync with DB state.
  ///
  /// Copied from [AiConfigListNotifier].
  AiConfigListNotifierProvider call(
    AIServiceType type,
  ) {
    return AiConfigListNotifierProvider(
      type,
    );
  }

  @override
  AiConfigListNotifierProvider getProviderOverride(
    covariant AiConfigListNotifierProvider provider,
  ) {
    return call(
      provider.type,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'aiConfigListNotifierProvider';
}

/// AI config list Notifier (family by AIServiceType).
/// Write operations call ref.invalidateSelf() to keep UI in sync with DB state.
///
/// Copied from [AiConfigListNotifier].
class AiConfigListNotifierProvider extends AsyncNotifierProviderImpl<
    AiConfigListNotifier, List<AIServiceConfig>> {
  /// AI config list Notifier (family by AIServiceType).
  /// Write operations call ref.invalidateSelf() to keep UI in sync with DB state.
  ///
  /// Copied from [AiConfigListNotifier].
  AiConfigListNotifierProvider(
    AIServiceType type,
  ) : this._internal(
          () => AiConfigListNotifier()..type = type,
          from: aiConfigListNotifierProvider,
          name: r'aiConfigListNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$aiConfigListNotifierHash,
          dependencies: AiConfigListNotifierFamily._dependencies,
          allTransitiveDependencies:
              AiConfigListNotifierFamily._allTransitiveDependencies,
          type: type,
        );

  AiConfigListNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.type,
  }) : super.internal();

  final AIServiceType type;

  @override
  FutureOr<List<AIServiceConfig>> runNotifierBuild(
    covariant AiConfigListNotifier notifier,
  ) {
    return notifier.build(
      type,
    );
  }

  @override
  Override overrideWith(AiConfigListNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: AiConfigListNotifierProvider._internal(
        () => create()..type = type,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        type: type,
      ),
    );
  }

  @override
  AsyncNotifierProviderElement<AiConfigListNotifier, List<AIServiceConfig>>
      createElement() {
    return _AiConfigListNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AiConfigListNotifierProvider && other.type == type;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, type.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AiConfigListNotifierRef
    on AsyncNotifierProviderRef<List<AIServiceConfig>> {
  /// The parameter `type` of this provider.
  AIServiceType get type;
}

class _AiConfigListNotifierProviderElement extends AsyncNotifierProviderElement<
    AiConfigListNotifier, List<AIServiceConfig>> with AiConfigListNotifierRef {
  _AiConfigListNotifierProviderElement(super.provider);

  @override
  AIServiceType get type => (origin as AiConfigListNotifierProvider).type;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
