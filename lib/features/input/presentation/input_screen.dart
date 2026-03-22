import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/top_snack_bar.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_typography.dart';
import 'providers/input_notifier.dart';
import 'widgets/conversation_history_view.dart';
import 'widgets/input_bar.dart';

class InputScreen extends ConsumerStatefulWidget {
  const InputScreen({super.key});

  @override
  ConsumerState<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends ConsumerState<InputScreen> {
  final _scrollController = ScrollController();
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = ref.read(inputTextControllerProvider);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        // ListView is reverse:true — newest items are at the visual bottom,
        // which corresponds to minScrollExtent (position 0).
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _handleSubmit(String text) async {
    _textController.clear();
    await ref.read(inputNotifierProvider.notifier).submitText(text);
    _scrollToBottom();
  }

  void _handleVoiceRecorded(String text) {
    _textController.text = text;
  }

  @override
  Widget build(BuildContext context) {
    // Listen to state: auto-scroll when new content arrives; show top toast on LLM error
    ref.listen(inputNotifierProvider, (_, next) {
      next.maybeWhen(
        streaming: (_, __, ___, ____, _____) => _scrollToBottom(),
        done: (_) => _scrollToBottom(),
        error: (message, _) => showTopSnackBar(context, message, isError: true),
        orElse: () {},
      );
    });

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('AI助手', style: AppTextStyles.appBarTitle),
        backgroundColor: AppColors.surfaceWhite,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleSpacing: 0,
        leadingWidth: 40,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          padding: EdgeInsets.zero,
          visualDensity: VisualDensity.compact,
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, size: 20),
            tooltip: '设置',
            padding: EdgeInsets.zero,
            visualDensity: VisualDensity.compact,
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: Stack(
        children: [
          ConversationHistoryView(scrollController: _scrollController),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              top: false,
              left: false,
              right: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
                child: InputBar(
                  controller: _textController,
                  onSubmitText: _handleSubmit,
                  onVoiceRecorded: _handleVoiceRecorded,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
