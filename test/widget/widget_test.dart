import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:english_learning/core/database/app_database.dart';
import 'package:english_learning/shared/widgets/app_shell.dart';
import 'package:english_learning/features/notes/presentation/note_list_screen.dart';

AppDatabase _inMemoryDb() => AppDatabase.forTesting(NativeDatabase.memory());

void main() {
  group('AppShell', () {
    testWidgets('渲染底部导航栏，包含两个目的地', (WidgetTester tester) async {
      final router = GoRouter(
        routes: [
          ShellRoute(
            builder: (_, __, child) => AppShell(child: child),
            routes: [
              GoRoute(
                path: '/',
                builder: (_, __) => const SizedBox(),
              ),
            ],
          ),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(routerConfig: router),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(NavigationBar), findsOneWidget);
      expect(find.byType(NavigationDestination), findsNWidgets(2));
    });

    testWidgets('初始选中第 0 项（英语助手）', (WidgetTester tester) async {
      final router = GoRouter(
        routes: [
          ShellRoute(
            builder: (_, __, child) => AppShell(child: child),
            routes: [
              GoRoute(
                path: '/',
                builder: (_, __) => const SizedBox(),
              ),
            ],
          ),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(routerConfig: router),
        ),
      );
      await tester.pumpAndSettle();

      final navBar = tester.widget<NavigationBar>(find.byType(NavigationBar));
      expect(navBar.selectedIndex, equals(0));
    });
  });

  group('NoteListScreen', () {
    testWidgets('空数据库时显示空状态提示', (WidgetTester tester) async {
      final db = _inMemoryDb();

      final router = GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (_, __) => const NoteListScreen(),
          ),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appDatabaseProvider.overrideWithValue(db),
          ],
          child: MaterialApp.router(routerConfig: router),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('笔记本还是空的'), findsOneWidget);

      await db.close();
    });
  });
}
