import 'package:decibel_monitor/src/features/settings/models/setting_model.dart';
import 'package:decibel_monitor/src/features/settings/repositories/setting_repository.dart';
import 'package:flutter/material.dart';

typedef _Controller = ValueNotifier<SettingModel>;

abstract interface class SettingController extends _Controller {
  SettingController() : super(SettingModel());

  Future<void> loadTheme();
  Future<void> changeTheme({required bool isDarkTheme});
}

class SettingControllerImpl extends _Controller implements SettingController {
  final SettingRepository settingRepository;

  SettingControllerImpl({
    required this.settingRepository,
  }) : super(SettingModel());

  @override
  Future<void> loadTheme() async {
    bool isDarkTheme = await settingRepository.readTheme();
    final settingModel = SettingModel(
      isDarkTheme: isDarkTheme,
    );
    value = settingModel;
    _debug();
  }

  @override
  Future<void> changeTheme({required bool isDarkTheme}) async {
    await settingRepository.updateTheme(
      isDarkTheme: isDarkTheme,
    );
    final settingModel = SettingModel(
      isDarkTheme: isDarkTheme,
    );
    value = settingModel;
    _debug();
  }

  void _debug() {
    debugPrint('Dark theme: ${value.isDarkTheme}');
  }
}
