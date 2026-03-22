import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/ai_service_configs_table.dart';

part 'ai_service_configs_dao.g.dart';

@DriftAccessor(tables: [AiServiceConfigs])
class AiServiceConfigsDao extends DatabaseAccessor<AppDatabase>
    with _$AiServiceConfigsDaoMixin {
  AiServiceConfigsDao(super.db);

  Future<List<AiServiceConfigData>> getByType(String serviceType) =>
      (select(aiServiceConfigs)
            ..where((t) => t.serviceType.equals(serviceType))
            ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
          .get();

  Future<AiServiceConfigData?> getById(String id) =>
      (select(aiServiceConfigs)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<void> insert(AiServiceConfigsCompanion companion) =>
      into(aiServiceConfigs).insert(companion);

  Future<bool> updateConfig(AiServiceConfigsCompanion companion) =>
      update(aiServiceConfigs).replace(companion);

  Future<int> deleteById(String id) =>
      (delete(aiServiceConfigs)..where((t) => t.id.equals(id))).go();
}
