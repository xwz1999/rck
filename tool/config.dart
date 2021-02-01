class Config {
  ///用户根目录
  static const homeDir = '/Users/akufe';

  ///签名密码
  static const recookPassword = 'recook';

  /// 签名目录
  static const keystorePath = './jks/recook.keystore';

  ///包名
  static const packageName = 'RECOOK';

  ///Android SDK 目录
  static String get androidSdkRoot => '$homeDir/Library/Android/sdk';

  ///Apksigner 目录
  static String get apksignerPath =>
      '$androidSdkRoot/build-tools/30.0.2/apksigner';

  ///下载目录
  static String get downloadPath => '$homeDir/Downloads';

  ///打包目录
  static String get buildPath =>
      './build/app/outputs/flutter-apk/app-release.apk';
}