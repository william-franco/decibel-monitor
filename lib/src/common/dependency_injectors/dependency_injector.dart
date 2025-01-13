import 'package:decibel_monitor/src/common/services/storage_service.dart';
import 'package:decibel_monitor/src/features/decibel/controllers/decibel_controller.dart';
import 'package:decibel_monitor/src/features/decibel/repositories/decibel_repository.dart';
import 'package:decibel_monitor/src/features/permission/controllers/permission_controller.dart';
import 'package:decibel_monitor/src/features/permission/repositories/permission_repository.dart';
import 'package:decibel_monitor/src/features/settings/controllers/setting_controller.dart';
import 'package:decibel_monitor/src/features/settings/repositories/setting_repository.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void dependencyInjector() {
  _startStorageService();
  _startFeaturePermission();
  _startFeatureDecibel();
  _startFeatureSetting();
}

void _startStorageService() {
  locator.registerLazySingleton<StorageService>(
    () => StorageServiceImpl(),
  );
}

void _startFeaturePermission() {
  locator.registerCachedFactory<PermissionRepository>(
    () => PermissionRepositoryImpl(),
  );
  locator.registerLazySingleton<PermissionController>(
    () => PermissionControllerImpl(
      permissionRepository: locator<PermissionRepository>(),
    ),
  );
}

void _startFeatureDecibel() {
  locator.registerCachedFactory<DecibelRepository>(
    () => DecibelRepositoryImpl(),
  );
  locator.registerLazySingleton<DecibelController>(
    () => DecibelControllerImpl(
      decibelRepository: locator<DecibelRepository>(),
    ),
  );
}

void _startFeatureSetting() {
  locator.registerCachedFactory<SettingRepository>(
    () => SettingRepositoryImpl(
      storageService: locator<StorageService>(),
    ),
  );
  locator.registerLazySingleton<SettingController>(
    () => SettingControllerImpl(
      settingRepository: locator<SettingRepository>(),
    ),
  );
}

Future<void> initDependencies() async {
  await Future.wait([
    locator<SettingController>().loadTheme(),
    locator<PermissionController>().initMicrophonePermission(),
  ]);
}

void resetDependencies() {
  locator.reset();
}

void resetFeatureSetting() {
  locator.unregister<SettingRepository>();
  locator.unregister<SettingController>();
  _startFeatureSetting();
}
