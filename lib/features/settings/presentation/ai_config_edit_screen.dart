import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../../core/ai/ai_provider_registry.dart';
import '../../../core/ai/providers/ai_service_providers.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../domain/entities/ai_service_config.dart';
import 'providers/active_config_providers.dart';
import 'providers/ai_config_list_notifier.dart';

// Reuse private widgets defined here from settings_screen.dart pattern
class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, AppSpacing.md, 0, 8),
      child: Text(title, style: AppTextStyles.sectionHeader),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;
  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 8,
          offset: const Offset(0, 2),
        )],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );
  }
}

class AIConfigEditScreen extends ConsumerStatefulWidget {
  final AIServiceType serviceType;
  final AIServiceConfig? existingConfig;

  const AIConfigEditScreen({required this.serviceType, this.existingConfig, super.key});

  @override
  ConsumerState<AIConfigEditScreen> createState() => _AIConfigEditScreenState();
}

class _AIConfigEditScreenState extends ConsumerState<AIConfigEditScreen> {
  // Sentinel stored in controller when existing key should be kept unchanged.
  // obscureText renders it as dots; on focus it is cleared so user types a new key.
  static const _kMaskedKey = '••••••••••••';

  late String _selectedProvider;
  late TextEditingController _nameCtrl;
  late TextEditingController _modelCtrl;
  late TextEditingController _apiKeyCtrl;
  late TextEditingController _baseUrlCtrl;
  late FocusNode _apiKeyFocus;
  // Volcano-specific fields (only shown when volcano provider is selected)
  late TextEditingController _volcanoAppIdCtrl;
  late TextEditingController _volcanoTokenCtrl;
  late TextEditingController _volcanoResourceIdCtrl; // TTS only
  late TextEditingController _volcanoSpeakerIdCtrl;  // TTS only
  late FocusNode _volcanoAppIdFocus;
  late FocusNode _volcanoTokenFocus;
  bool _isTestingConnection = false;
  String? _testResult;
  bool _isSaving = false;

  bool get _isEditMode => widget.existingConfig != null;
  bool get _apiKeyUnchanged => _apiKeyCtrl.text == _kMaskedKey;

  bool get _isVolcano =>
      _selectedProvider == 'volcano_stt' || _selectedProvider == 'volcano_tts';
  bool get _isVolcanoTts => _selectedProvider == 'volcano_tts';

  // In edit mode, a volcano credential field is "unchanged" if it still holds
  // the masked sentinel or was left empty after focus-clearing the sentinel.
  bool _volcanoFieldUnchanged(TextEditingController ctrl) =>
      ctrl.text == _kMaskedKey || ctrl.text.trim().isEmpty;
  bool get _volcanoKeyUnchanged =>
      _volcanoFieldUnchanged(_volcanoAppIdCtrl) &&
      _volcanoFieldUnchanged(_volcanoTokenCtrl);

  List<(String, String)> get _providers => switch (widget.serviceType) {
    AIServiceType.llm => [
      ('deepseek', 'DeepSeek'),
      ('moonshot', 'Kimi（Moonshot）'),
      ('openai', 'OpenAI'),
      ('openrouter', 'OpenRouter'),
      ('minimax', 'MiniMax'),
      ('openai_compatible', '自定义（OpenAI 兼容）'),
    ],
    AIServiceType.tts => [
      ('volcano_tts', '火山引擎（大模型）'),
      ('siliconflow_tts', 'SiliconFlow'),
    ],
    AIServiceType.stt => [
      ('volcano_stt', '火山引擎（大模型）'),
      ('siliconflow', 'SiliconFlow'),
    ],
  };

  String get _modelLabel {
    final hasDefault = AiProviderRegistry.defaultModel(_selectedProvider) != null;
    final optional = hasDefault ? '（可选）' : '';
    return switch (widget.serviceType) {
      AIServiceType.llm => '模型 ID$optional',
      AIServiceType.tts => '音色$optional',
      AIServiceType.stt => '模型 ID$optional',
    };
  }

  /// Whether to show the Base URL field: required only for providers with a preset baseUrl or the custom-compatible mode.
  bool get _showBaseUrl {
    final preset = AiProviderRegistry.defaultBaseUrl(_selectedProvider);
    return preset != null || _selectedProvider == 'openai_compatible';
  }

  @override
  void initState() {
    super.initState();
    final e = widget.existingConfig;
    _selectedProvider = e?.providerKey ?? _providers.first.$1;
    _nameCtrl    = TextEditingController(text: e?.displayName ?? _providerDisplayName(_selectedProvider));
    _modelCtrl   = TextEditingController(text: e?.model ?? AiProviderRegistry.defaultModel(_selectedProvider) ?? '');
    _baseUrlCtrl = TextEditingController(text: e?.customBaseUrl ?? AiProviderRegistry.defaultBaseUrl(_selectedProvider) ?? '');
    _apiKeyCtrl  = TextEditingController(text: _isEditMode ? _kMaskedKey : '');
    _apiKeyFocus = FocusNode()..addListener(_onApiKeyFocusChange);
    // Volcano fields: in edit mode show masked sentinel so the user knows values
    // are already set (mirrors the regular apiKey field behavior).
    // Actual stored key is never read back here — sentinel is just a visual cue.
    final isEditingVolcano = _isEditMode &&
        (e!.providerKey == 'volcano_stt' || e.providerKey == 'volcano_tts');
    _volcanoAppIdCtrl  = TextEditingController(text: isEditingVolcano ? _kMaskedKey : '');
    _volcanoTokenCtrl  = TextEditingController(text: isEditingVolcano ? _kMaskedKey : '');
    _volcanoAppIdFocus = FocusNode()..addListener(_onVolcanoAppIdFocusChange);
    _volcanoTokenFocus = FocusNode()..addListener(_onVolcanoTokenFocusChange);
    if (isEditingVolcano && e.providerKey == 'volcano_tts') {
      final (rid, sid) = _splitColonPair(e.model);
      _volcanoResourceIdCtrl = TextEditingController(text: rid);
      _volcanoSpeakerIdCtrl  = TextEditingController(text: sid);
    } else if (isEditingVolcano && e.providerKey == 'volcano_stt') {
      _volcanoResourceIdCtrl = TextEditingController(text: e.model);
      _volcanoSpeakerIdCtrl  = TextEditingController();
    } else if (_selectedProvider == 'volcano_tts') {
      final (rid, sid) = _splitColonPair(AiProviderRegistry.defaultModel('volcano_tts') ?? '');
      _volcanoResourceIdCtrl = TextEditingController(text: rid);
      _volcanoSpeakerIdCtrl  = TextEditingController(text: sid);
    } else if (_selectedProvider == 'volcano_stt') {
      _volcanoResourceIdCtrl = TextEditingController(text: AiProviderRegistry.defaultModel('volcano_stt') ?? '');
      _volcanoSpeakerIdCtrl  = TextEditingController();
    } else {
      _volcanoResourceIdCtrl = TextEditingController();
      _volcanoSpeakerIdCtrl  = TextEditingController();
    }
  }

  String _providerDisplayName(String key) =>
      _providers.firstWhere((p) => p.$1 == key, orElse: () => (key, key)).$2;

  /// Splits "a:b" → ('a', 'b'). If no colon, returns (whole, '').
  (String, String) _splitColonPair(String s) {
    final idx = s.indexOf(':');
    if (idx <= 0) return (s, '');
    return (s.substring(0, idx), s.substring(idx + 1));
  }

  void _onApiKeyFocusChange() {
    if (_apiKeyFocus.hasFocus) {
      if (_apiKeyUnchanged) _apiKeyCtrl.clear();
    } else if (_isEditMode && _apiKeyCtrl.text.trim().isEmpty) {
      _apiKeyCtrl.text = _kMaskedKey;
    }
  }

  void _onVolcanoAppIdFocusChange() {
    if (_volcanoAppIdFocus.hasFocus) {
      if (_volcanoAppIdCtrl.text == _kMaskedKey) _volcanoAppIdCtrl.clear();
    } else if (_isEditMode && _volcanoAppIdCtrl.text.trim().isEmpty) {
      _volcanoAppIdCtrl.text = _kMaskedKey;
    }
  }

  void _onVolcanoTokenFocusChange() {
    if (_volcanoTokenFocus.hasFocus) {
      if (_volcanoTokenCtrl.text == _kMaskedKey) _volcanoTokenCtrl.clear();
    } else if (_isEditMode && _volcanoTokenCtrl.text.trim().isEmpty) {
      _volcanoTokenCtrl.text = _kMaskedKey;
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose(); _modelCtrl.dispose();
    _apiKeyCtrl.dispose(); _baseUrlCtrl.dispose();
    _apiKeyFocus.dispose();
    _volcanoAppIdCtrl.dispose(); _volcanoTokenCtrl.dispose();
    _volcanoResourceIdCtrl.dispose(); _volcanoSpeakerIdCtrl.dispose();
    _volcanoAppIdFocus.dispose(); _volcanoTokenFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceWhite,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleSpacing: 0,
        leadingWidth: 40,
        title: Text(
          _isEditMode ? '编辑配置' : '新增 ${_serviceLabel(widget.serviceType)} 配置',
          style: AppTextStyles.appBarTitle,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          padding: EdgeInsets.zero,
          visualDensity: VisualDensity.compact,
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          const _SectionHeader(title: '提供商'),
          _SettingsCard(children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
              child: DropdownButtonFormField<String>(
                value: _selectedProvider,
                decoration: _inputDecoration(hint: '', icon: Icons.dns_outlined),
                items: _providers.map((p) => DropdownMenuItem(value: p.$1, child: Text(p.$2, style: const TextStyle(fontSize: 15)))).toList(),
                onChanged: (v) {
                  if (v == null || v == _selectedProvider) return;
                  setState(() {
                    final knownNames = _providers.map((p) => p.$2).toSet();
                    if (_nameCtrl.text.isEmpty || knownNames.contains(_nameCtrl.text)) {
                      _nameCtrl.text = _providerDisplayName(v);
                    }
                    _selectedProvider = v;
                    _modelCtrl.text = AiProviderRegistry.defaultModel(v) ?? '';
                    _baseUrlCtrl.text = AiProviderRegistry.defaultBaseUrl(v) ?? '';
                    _volcanoAppIdCtrl.clear();
                    _volcanoTokenCtrl.clear();
                    if (v == 'volcano_tts') {
                      final (rid, sid) = _splitColonPair(AiProviderRegistry.defaultModel('volcano_tts') ?? '');
                      _volcanoResourceIdCtrl.text = rid;
                      _volcanoSpeakerIdCtrl.text = sid;
                    } else {
                      _volcanoResourceIdCtrl.clear();
                      _volcanoSpeakerIdCtrl.clear();
                    }
                  });
                },
              ),
            ),
          ]),

          const SizedBox(height: AppSpacing.md),
          const _SectionHeader(title: '配置信息'),
          _SettingsCard(children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(children: [
                _LabeledField(label: '配置名称', controller: _nameCtrl, icon: Icons.label_outline),
                const SizedBox(height: AppSpacing.md),
                if (_isVolcano) ...[
                  _LabeledField(
                    label: 'App ID（X-Api-App-Key）',
                    controller: _volcanoAppIdCtrl,
                    focusNode: _volcanoAppIdFocus,
                    icon: Icons.fingerprint,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _LabeledField(
                    label: 'Access Token（X-Api-Access-Key）',
                    controller: _volcanoTokenCtrl,
                    focusNode: _volcanoTokenFocus,
                    icon: Icons.vpn_key_outlined,
                    obscureText: true,
                  ),
                  if (_isVolcano) ...[
                    const SizedBox(height: AppSpacing.md),
                    _LabeledField(
                      label: 'Resource Id（可选）',
                      controller: _volcanoResourceIdCtrl,
                      icon: Icons.memory_outlined,
                    ),
                  ],
                  if (_isVolcanoTts) ...[
                    const SizedBox(height: AppSpacing.md),
                    _LabeledField(
                      label: '音色（可选）',
                      controller: _volcanoSpeakerIdCtrl,
                      icon: Icons.record_voice_over_outlined,
                    ),
                  ],
                ] else ...[
                  _LabeledField(
                    label: 'API Key',
                    controller: _apiKeyCtrl,
                    focusNode: _apiKeyFocus,
                    icon: Icons.vpn_key_outlined,
                    obscureText: true,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _LabeledField(label: _modelLabel, controller: _modelCtrl, icon: Icons.memory_outlined),
                ],
                if (_showBaseUrl) ...[
                  const SizedBox(height: AppSpacing.md),
                  _LabeledField(label: '自定义 Base URL（可选）', controller: _baseUrlCtrl, icon: Icons.link_outlined),
                ],
              ]),
            ),
          ]),

          const SizedBox(height: AppSpacing.md),
          OutlinedButton.icon(
            icon: _isTestingConnection
                ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.wifi_tethering, size: 18),
            label: const Text('测试连接'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: _isTestingConnection ? null : _testConnection,
          ),
          if (_testResult != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: _testResult!.startsWith('✓') ? AppColors.successBg : AppColors.errorBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(_testResult!, style: TextStyle(fontSize: 13,
                  color: _testResult!.startsWith('✓') ? AppColors.success : AppColors.error)),
            ),
          ],

          const SizedBox(height: AppSpacing.md),
          FilledButton(
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            onPressed: _isSaving ? null : _save,
            child: _isSaving
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Text('保存', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ),
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }

  String? _validate() {
    if (_nameCtrl.text.trim().isEmpty) return '配置名称不能为空';
    if (_isVolcano) {
      final appId = _volcanoAppIdCtrl.text.trim();
      final token = _volcanoTokenCtrl.text.trim();
      if (!_isEditMode) {
        // Create mode: all credential fields required
        if (appId.isEmpty) return 'App ID 不能为空';
        if (token.isEmpty) return 'Access Token 不能为空';
      } else {
        // Edit mode: "changed" = user replaced the sentinel with real content.
        final appIdChanged = !_volcanoFieldUnchanged(_volcanoAppIdCtrl);
        final tokenChanged = !_volcanoFieldUnchanged(_volcanoTokenCtrl);
        if (appIdChanged && !tokenChanged) return '请同时填写 App ID 和 Access Token';
        if (tokenChanged && !appIdChanged) return '请同时填写 App ID 和 Access Token';
      }
    } else {
      final hasPreset = AiProviderRegistry.defaultModel(_selectedProvider) != null;
      if (_modelCtrl.text.trim().isEmpty && !hasPreset) return '$_modelLabel不能为空';
      if (!_isEditMode && _apiKeyCtrl.text.trim().isEmpty) return 'API Key 不能为空';
    }
    return null;
  }

  Future<void> _testConnection() async {
    setState(() { _isTestingConnection = true; _testResult = null; });
    try {
      final configResult = await ref.read(activeConfigWithKeyProvider(widget.serviceType).future);
      final isAvailable = await configResult.when(
        configured: (config, key) async {
          return switch (widget.serviceType) {
            AIServiceType.llm => ref.read(llmServiceProvider).isConfigured,
            AIServiceType.tts => await ref.read(ttsServiceProvider).isAvailable(),
            AIServiceType.stt => await ref.read(sttServiceProvider).isAvailable(),
          };
        },
        noActiveConfig: () async => false,
        missingKey: (_) async => false,
      );
      if (mounted) {
        setState(() => _testResult = isAvailable ? '✓ 连接成功' : '✗ 连接失败：服务不可用，请检查 API Key 或网络');
      }
    } catch (e) {
      if (mounted) setState(() => _testResult = '✗ 连接失败：$e');
    } finally {
      if (mounted) setState(() => _isTestingConnection = false);
    }
  }

  Future<void> _save() async {
    final error = _validate();
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error), backgroundColor: AppColors.error));
      return;
    }
    setState(() => _isSaving = true);
    try {
      final notifier = ref.read(aiConfigListProvider(widget.serviceType).notifier);
      final now = DateTime.now();

      // Assemble model and apiKey values based on provider type.
      final String assembledModel;
      final String assembledApiKey;
      if (_isVolcano) {
        if (_isVolcanoTts) {
          final defaultRaw = AiProviderRegistry.defaultModel('volcano_tts') ?? 'seed-tts-2.0:zh_female_vv_uranus_bigtts';
          final defaultParts = defaultRaw.split(':');
          final rid = _volcanoResourceIdCtrl.text.trim().isEmpty
              ? defaultParts[0]
              : _volcanoResourceIdCtrl.text.trim();
          final speaker = _volcanoSpeakerIdCtrl.text.trim().isEmpty
              ? (defaultParts.length > 1 ? defaultParts[1] : '')
              : _volcanoSpeakerIdCtrl.text.trim();
          assembledModel = '$rid:$speaker';
        } else {
          // volcano_stt: model stores resourceId
          final defaultRid = AiProviderRegistry.defaultModel('volcano_stt') ?? 'volc.bigasr.auc_turbo';
          assembledModel = _volcanoResourceIdCtrl.text.trim().isEmpty
              ? defaultRid
              : _volcanoResourceIdCtrl.text.trim();
        }
        assembledApiKey = _volcanoKeyUnchanged
            ? '' // keep existing in secure storage
            : '${_volcanoAppIdCtrl.text.trim()}|${_volcanoTokenCtrl.text.trim()}';
      } else {
        assembledModel = _modelCtrl.text.trim();
        assembledApiKey = _apiKeyCtrl.text.trim();
      }

      if (_isEditMode) {
        final updated = widget.existingConfig!.copyWith(
          providerKey: _selectedProvider, displayName: _nameCtrl.text.trim(),
          model: assembledModel,
          customBaseUrl: _baseUrlCtrl.text.trim().isEmpty ? null : _baseUrlCtrl.text.trim(),
          updatedAt: now,
        );
        final shouldUpdateKey = _isVolcano
            ? !_volcanoKeyUnchanged
            : (assembledApiKey.isNotEmpty && assembledApiKey != _kMaskedKey);
        if (shouldUpdateKey) {
          await notifier.updateApiKey(updated.id, assembledApiKey);
        }
        await notifier.updateConfig(updated);
      } else {
        final newConfig = AIServiceConfig(
          id: const Uuid().v4(), serviceType: widget.serviceType,
          providerKey: _selectedProvider, displayName: _nameCtrl.text.trim(),
          model: assembledModel,
          customBaseUrl: _baseUrlCtrl.text.trim().isEmpty ? null : _baseUrlCtrl.text.trim(),
          createdAt: now, updatedAt: now,
        );
        await notifier.add(newConfig, apiKey: assembledApiKey);
      }
      if (context.mounted) context.pop();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('保存失败：$e'), backgroundColor: AppColors.error));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  InputDecoration _inputDecoration({required String hint, required IconData icon}) => InputDecoration(
    hintText: hint, hintStyle: const TextStyle(color: AppColors.textHint, fontSize: 14),
    prefixIcon: Icon(icon, size: 18, color: AppColors.textSecondary),
    filled: true, fillColor: AppColors.scaffoldBg,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.originalBorder)),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.originalBorder)),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
  );

  String _serviceLabel(AIServiceType type) => switch (type) {
    AIServiceType.llm => 'LLM', AIServiceType.tts => 'TTS', AIServiceType.stt => 'STT',
  };
}

class _LabeledField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final IconData icon;
  final bool obscureText;
  final FocusNode? focusNode;

  const _LabeledField({required this.label, required this.controller, required this.icon, this.obscureText = false, this.focusNode});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: AppTextStyles.cardLabel),
      const SizedBox(height: 6),
      TextField(
        controller: controller, focusNode: focusNode, obscureText: obscureText,
        style: AppTextStyles.inputBody.copyWith(fontSize: 15),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, size: 18, color: AppColors.textSecondary),
          filled: true, fillColor: AppColors.scaffoldBg,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.originalBorder)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.originalBorder)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
        ),
      ),
    ]);
  }
}
