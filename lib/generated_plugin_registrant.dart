//
// Generated file. Do not edit.
//

// ignore_for_file: lines_longer_than_80_chars

import 'package:audio_session/audio_session_web.dart';
import 'package:device_info_plus_web/device_info_plus_web.dart';
import 'package:image_picker_for_web/image_picker_for_web.dart';
import 'package:just_audio_web/just_audio_web.dart';
import 'package:package_info_plus_web/package_info_plus_web.dart';
import 'package:shared_preferences_web/shared_preferences_web.dart';
import 'package:url_launcher_web/url_launcher_web.dart';
import 'package:video_player_web/video_player_web.dart';

import 'package:flutter_web_plugins/flutter_web_plugins.dart';

// ignore: public_member_api_docs
void registerPlugins(Registrar registrar) {
  AudioSessionWeb.registerWith(registrar);
  DeviceInfoPlusPlugin.registerWith(registrar);
  ImagePickerPlugin.registerWith(registrar);
  JustAudioPlugin.registerWith(registrar);
  PackageInfoPlugin.registerWith(registrar);
  SharedPreferencesPlugin.registerWith(registrar);
  UrlLauncherPlugin.registerWith(registrar);
  VideoPlayerPlugin.registerWith(registrar);
  registrar.registerMessageHandler();
}
