import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';

import 'app.dart';
import 'core/migration/ai_migration_v1_service.dart';
import 'core/database/app_database.dart';
import 'core/storage/secure_storage_service.dart';

final logger = Logger();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );
  final db = AppDatabase();

  final migrationResult = await AIMigrationV1Service(
    secureStorage: secureStorage,
    db: db,
  ).runIfNeeded();

  migrationResult.maybeWhen(
    failed: (error) => logger.w('[main] AI multiconfig migration failed: $error'),
    orElse: () {},
  );

  runApp(
    ProviderScope(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        secureStorageProvider.overrideWithValue(secureStorage),
      ],
      child: const App(),
    ),
  );
}
