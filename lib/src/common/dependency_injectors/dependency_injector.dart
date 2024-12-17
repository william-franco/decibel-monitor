import 'package:decibel_monitor/src/features/decibel/controllers/decibel_controller.dart';
import 'package:decibel_monitor/src/features/decibel/repositories/decibel_repository.dart';
import 'package:decibel_monitor/src/features/permission/controllers/permission_controller.dart';
import 'package:decibel_monitor/src/features/permission/repositories/permission_repository.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void dependencyInjector() {
  _startFeaturePermission();
  _startFeatureDecibel();
  _startFeatureSetting();
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
  // locator.registerCachedFactory<StorageService>(
  //   () => StorageServiceImpl(),
  // );
  // locator.registerCachedFactory<SettingRepository>(
  //   () => SettingRepositoryImpl(
  //     storageService: locator<StorageService>(),
  //   ),
  // );
  // locator.registerCachedFactory<SettingController>(
  //   () => SettingControllerImpl(
  //     settingRepository: locator<SettingRepository>(),
  //   ),
  // );
}

void resetDependencies() {
  locator.reset();
}

// void resetFeatureUser() {
//   locator.unregister<LauncherRepository>();
//   locator.unregister<LauncherController>();
//   _startFeatureLauncher();
// }
