import 'package:decibel_monitor/src/common/services/storage_service.dart';
import 'package:decibel_monitor/src/features/decibel/view_models/decibel_view_model.dart';
import 'package:decibel_monitor/src/features/decibel/repositories/decibel_repository.dart';
import 'package:decibel_monitor/src/features/permission/view_models/permission_view_model.dart';
import 'package:decibel_monitor/src/features/permission/repositories/permission_repository.dart';
import 'package:decibel_monitor/src/features/settings/view_models/setting_view_model.dart';
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
  locator.registerLazySingleton<StorageService>(() => StorageServiceImpl());
}

void _startFeaturePermission() {
  locator.registerCachedFactory<PermissionRepository>(
    () => PermissionRepositoryImpl(),
  );
  locator.registerLazySingleton<PermissionViewModel>(
    () => PermissionViewModelImpl(
      permissionRepository: locator<PermissionRepository>(),
    ),
  );
}

void _startFeatureDecibel() {
  locator.registerCachedFactory<DecibelRepository>(
    () => DecibelRepositoryImpl(),
  );
  locator.registerLazySingleton<DecibelViewModel>(
    () => DecibelViewModelImpl(decibelRepository: locator<DecibelRepository>()),
  );
}

void _startFeatureSetting() {
  locator.registerCachedFactory<SettingRepository>(
    () => SettingRepositoryImpl(storageService: locator<StorageService>()),
  );
  locator.registerLazySingleton<SettingViewModel>(
    () => SettingViewModelImpl(settingRepository: locator<SettingRepository>()),
  );
}

Future<void> initDependencies() async {
  await locator<StorageService>().initStorage();
  await Future.wait([
    locator<SettingViewModel>().getTheme(),
    locator<PermissionViewModel>().initMicrophonePermission(),
  ]);
}

void resetDependencies() {
  locator.reset();
}

void resetFeatureSetting() {
  locator.unregister<SettingRepository>();
  locator.unregister<SettingViewModel>();
  _startFeatureSetting();
}
