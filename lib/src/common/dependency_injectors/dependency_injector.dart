import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void dependencyInjector() {
  _startFeatureLauncher();
  _startFeatureSetting();
}

void _startFeatureLauncher() {
  locator.registerCachedFactory<LauncherRepository>(
    () => LauncherRepositoryImpl(),
  );
  locator.registerCachedFactory<LauncherController>(
    () => LauncherControllerImpl(
      launcherRepository: locator<LauncherRepository>(),
    ),
  );
}

void _startFeatureSetting() {
  locator.registerCachedFactory<StorageService>(
    () => StorageServiceImpl(),
  );
  locator.registerCachedFactory<SettingRepository>(
    () => SettingRepositoryImpl(
      storageService: locator<StorageService>(),
    ),
  );
  locator.registerCachedFactory<SettingController>(
    () => SettingControllerImpl(
      settingRepository: locator<SettingRepository>(),
    ),
  );
}

void resetDependencies() {
  locator.reset();
}

void resetFeatureUser() {
  locator.unregister<LauncherRepository>();
  locator.unregister<LauncherController>();
  _startFeatureLauncher();
}