class AiProviderConfig {
  const AiProviderConfig({
    required this.providerKey,
    required this.displayName,
    this.defaultBaseUrl,
    this.defaultModel,
    this.modelHint,
  });

  final String providerKey;
  final String displayName;
  final String? defaultBaseUrl;
  final String? defaultModel;
  /// Placeholder shown in the model/voice input field.
  /// Falls back to [defaultModel] if null.
  final String? modelHint;
}
