/// E2E / 核心用户旅程集成测试
///
/// 本文件包含两类测试：
///
/// 1. Widget smoke tests（依赖 App 小部件完整编译）
///    验证 App widget 可正常渲染并响应导航操作。
///
/// 2. 核心用户旅程数据层测试（SaveNoteUseCase + NoteListNotifier + SearchQuery）
///    直接操作 UseCase 和数据库，不依赖 UI 层编译，验证"保存→展示→搜索"完整链路。
///    这组测试满足 CLAUDE.md 第 5.1 节对"保存→搜索"旅程的覆盖要求。
///
/// 运行命令：
///   flutter test test/integration/app_e2e_test.dart
///
/// 使用 @Tags(['e2e']) 标注，CI 可通过 --tags / --exclude-tags 过滤。

@Tags(['e2e'])
library;

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:english_learning/app.dart';
import 'package:english_learning/core/database/app_database.dart';
import 'package:english_learning/features/notes/domain/entities/note.dart';
import 'package:english_learning/features/notes/domain/usecases/save_note_usecase.dart';
import 'package:english_learning/features/notes/presentation/providers/note_list_notifier.dart';

AppDatabase _buildInMemoryDb() {
  return AppDatabase.forTesting(NativeDatabase.memory());
}

/// 通过 ProviderContainer 读取 provider 状态（不需要 Flutter Widget 树）
ProviderContainer _buildContainer(AppDatabase db) {
  return ProviderContainer(
    overrides: [appDatabaseProvider.overrideWithValue(db)],
  );
}

void main() {
  late AppDatabase testDb;

  setUp(() {
    testDb = _buildInMemoryDb();
  });

  tearDown(() async {
    await testDb.close();
  });

  // ---------------------------------------------------------------------------
  // Widget smoke tests
  // ---------------------------------------------------------------------------

  group('App Smoke Tests（核心用户旅程入口）', () {
    testWidgets('App widget 能正常渲染并显示底部导航栏', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [appDatabaseProvider.overrideWithValue(testDb)],
          child: const App(),
        ),
      );
      await tester.pump();
      expect(find.byType(NavigationBar), findsOneWidget);
      // '英语助手' 同时出现在 AppBar 标题和导航栏标签，用 findsAtLeast(1) 避免假阳性
      expect(find.text('英语助手'), findsAtLeast(1));
      expect(find.text('笔记本'), findsOneWidget);
    });

    testWidgets('点击"笔记本"导航项可跳转到笔记列表页', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [appDatabaseProvider.overrideWithValue(testDb)],
          child: const App(),
        ),
      );
      await tester.pump();
      await tester.tap(find.text('笔记本'));
      await tester.pumpAndSettle();
      expect(find.text('搜索笔记...'), findsOneWidget);
    });
  });

  // ---------------------------------------------------------------------------
  // 核心用户旅程：保存→展示→搜索（数据层，不依赖 UI 编译）
  //
  // 通过 ProviderContainer 直接验证 SaveNoteUseCase → NoteListNotifier →
  // searchQueryProvider 的完整数据链路，满足 CLAUDE.md 第 5.1 节
  // "保存→搜索"用户旅程覆盖要求。
  // ---------------------------------------------------------------------------

  group('核心用户旅程：保存→展示（数据层）', () {
    test('保存笔记后 NoteListNotifier 可读取到该笔记', () async {
      final saveUseCase = SaveNoteUseCase(testDb);
      await saveUseCase.call(
        originalText: 'I want to go to school.',
        optimizedText: 'I would like to go to school.',
        translatedText: '我想去上学。',
        detectedLanguage: 'en',
        confidence: 1.0,
      );

      final container = _buildContainer(testDb);
      addTearDown(container.dispose);

      // 等待 AsyncNotifier 首次构建完成
      final result = await container
          .read(noteListNotifierProvider.future);

      expect(result, isNotEmpty);
      expect(result.first.notes.first.optimizedText, equals('I would like to go to school.'));
    });

    test('保存中文笔记后 NoteListNotifier 可按语言过滤（中→英）', () async {
      final saveUseCase = SaveNoteUseCase(testDb);
      await saveUseCase.call(
        originalText: '今天天气很好。',
        optimizedText: 'The weather is great today.',
        translatedText: 'The weather is great today.',
        detectedLanguage: 'zh',
        confidence: 1.0,
      );
      await saveUseCase.call(
        originalText: 'Good morning.',
        optimizedText: 'Good morning!',
        detectedLanguage: 'en',
        confidence: 1.0,
      );

      final container = _buildContainer(testDb);
      addTearDown(container.dispose);

      // 切换过滤器为中→英
      container.read(noteFilterProvider.notifier).state = NoteFilter.zhToEn;

      final result = await container.read(noteListNotifierProvider.future);

      expect(result.expand((g) => g.notes).length, equals(1));
      expect(result.first.notes.first.detectedLanguage, equals('zh'));
    });
  });

  group('核心用户旅程：搜索（数据层）', () {
    test('搜索关键词可在已保存笔记中精确匹配', () async {
      final saveUseCase = SaveNoteUseCase(testDb);
      await saveUseCase.call(
        originalText: 'Good morning everyone.',
        optimizedText: 'Good morning, everyone.',
        detectedLanguage: 'en',
        confidence: 1.0,
      );
      await saveUseCase.call(
        originalText: '今天天气很好。',
        optimizedText: 'The weather is great today.',
        translatedText: 'The weather is great today.',
        detectedLanguage: 'zh',
        confidence: 1.0,
      );

      final container = _buildContainer(testDb);
      addTearDown(container.dispose);

      // 输入搜索词
      container.read(searchQueryProvider.notifier).state = 'morning';

      final result = await container.read(noteListNotifierProvider.future);
      final notes = result.expand((g) => g.notes).toList();

      // 只命中含 "morning" 的笔记
      expect(notes.length, equals(1));
      expect(notes.first.optimizedText, equals('Good morning, everyone.'));
    });

    test('清空搜索词后恢复显示全部笔记', () async {
      final saveUseCase = SaveNoteUseCase(testDb);
      await saveUseCase.call(
        originalText: 'Hello.',
        optimizedText: 'Hello!',
        detectedLanguage: 'en',
        confidence: 1.0,
      );
      await saveUseCase.call(
        originalText: 'World.',
        optimizedText: 'World!',
        detectedLanguage: 'en',
        confidence: 1.0,
      );

      final container = _buildContainer(testDb);
      addTearDown(container.dispose);

      // 先搜索，再清空
      container.read(searchQueryProvider.notifier).state = 'Hello';
      final filtered = await container.read(noteListNotifierProvider.future);
      expect(filtered.expand((g) => g.notes).length, equals(1));

      container.read(searchQueryProvider.notifier).state = '';
      final all = await container.read(noteListNotifierProvider.future);
      expect(all.expand((g) => g.notes).length, equals(2));
    });
  });
}
