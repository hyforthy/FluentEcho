import 'package:drift/drift.dart';

@DataClassName('AiServiceConfigData')
class AiServiceConfigs extends Table {
  TextColumn get id => text()();
  TextColumn get serviceType => text()();
  TextColumn get providerKey => text()();
  TextColumn get displayName => text()();
  TextColumn get model => text()();
  TextColumn get customBaseUrl => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
