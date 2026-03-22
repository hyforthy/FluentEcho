import 'package:flutter/material.dart';

import '../../../../shared/theme/app_colors.dart';
import '../../domain/entities/detected_language.dart';

/// Low-confidence language detection banner
/// Displayed at the top of the first AI bubble when detectionConfidence < 0.7 (non-blocking)
class LanguageDetectionHint extends StatelessWidget {
  final DetectedLanguage detected;
  final VoidCallback onSwitch;

  const LanguageDetectionHint({
    required this.detected,
    required this.onSwitch,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final switchLabel = detected.language == 'zh' ? '切换为英文' : '切换为中文';
    return Container(
      margin: const EdgeInsets.only(left: 52, right: 12, bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.warningBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.warning.withOpacity(0.3)),
      ),
      child: Row(children: [
        const Icon(Icons.info_outline, size: 13, color: AppColors.warning),
        const SizedBox(width: 6),
        Text(
          '检测为${detected.language == 'zh' ? '中文' : '英文'}，置信度较低',
          style: const TextStyle(fontSize: 12, color: AppColors.warning),
        ),
        const Spacer(),
        GestureDetector(
          onTap: onSwitch,
          child: Text(
            switchLabel,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.warning,
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ]),
    );
  }
}
