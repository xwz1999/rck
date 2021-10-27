import 'dart:io';

import 'package:common_utils/common_utils.dart';
import 'package:grinder/grinder.dart';
import 'package:path/path.dart' hide context;
import 'package:yaml/yaml.dart';

import 'config.dart';

main(args) => grind(args);

int pid;

@Task()
test() => new TestRunner().testAsync();

///打包APK
@Task()
Future releaseApk() async {
  stdout.write("Build APK 📦\n");
  stdout.write("BUILDINGAPK\n");
  await Process.start('fvm', [
    'flutter',
    'build',
    'apk',
    '--target-platform=android-arm64,android-arm',
    '--dart-define',
    'ISDEBUG=false',
  ]).then((proc) async {
    await stdout.addStream(proc.stdout);
    await stderr.addStream(proc.stderr);
  });
  stdout.write("\rBuild APK DONE 📦\n");
  stdout.write("copy build to download 🛠\n");

  String date = DateUtil.formatDate(DateTime.now(), format: 'yy_MM_dd_HH_mm');
  String version = await getVersion();
  await runAsync('mv', arguments: [
    Config.buildPath,
    '${Config.buildDir}/${Config.packageName}_${version}_beta_$date.apk'
  ]);
  stdout.write("rename done 🛠\n");
  await Process.run('rm', ['-rf', '${Config.downloadPath}/builds']);
  await Process.run('mkdir', ['${Config.downloadPath}/builds']);
  await Process.run('cp', [
    '${Config.buildDir}/${Config.packageName}_${version}_beta_$date.apk',
    '${Config.downloadPath}/builds/${Config.packageName}_release.apk'
  ]);

  stdout.write("opening downloadPath 🛠\n");
  await Process.run('open', ['${Config.downloadPath}/builds']);
  stdout.write("opening tencent reinforce 🛠\n");
  await Process.run(
      'open', ['https://console.cloud.tencent.com/ms/reinforce/upload']);
  stdout.write("请将加固后的文件重命名为RECOOK_reinforce.apk,并移动至builds文件夹");
}

@Task()
Future releaseDev() async {
  TaskArgs args = context.invocation.arguments;
  String input = args.getOption('type') ?? 'dev';

  stdout.write("Build Dev APK 📦\n");
  stdout.write("BUILDINGAPK\n");
  await Process.start('fvm', [
    'flutter',
    'build',
    'apk',
    '--target-platform=android-arm64',
    '--dart-define',
    'ISDEBUG=true'
  ]).then((proc) async {
    await stdout.addStream(proc.stdout);
    await stderr.addStream(proc.stderr);
  });
  String date = DateUtil.formatDate(DateTime.now(), format: 'yyyy.MM.dd_HH_mm');
  await Process.run('cp', [
    Config.buildPath,
    '${Config.downloadPath}/builds/${Config.packageName}_$input\_$date\.apk'
  ]);
  await Process.run('open', ['${Config.downloadPath}/builds']);
}

///签名
@Task()
sign() async {
  //TaskArgs args = context.invocation.arguments;
  //String input = args.getOption('input');
  stdout.write('start SIGN 🔑\n');
  ProcessResult process = await Process.run(
    Config.apksignerPath,
    [
      'sign',
      '--ks',
      Config.keystorePath,
      '--ks-key-alias',
      'alias',
      '--ks-pass',
      'pass:${Config.recookPassword}',
      '--key-pass',
      'pass:${Config.recookPassword}',
      '--out',
      '${Config.downloadPath}/builds/${Config.packageName}_release_signed.apk',
      // input,
      // '--input',
      '${Config.downloadPath}/builds/${Config.packageName}_reinforce.apk'
    ],
  );
  stdout.write(process.stdout);
  stderr.write(process.stderr);
  stdout.write('end SIGN 🔑\n');
  Process.run('adb', [
    'install',
    '${Config.downloadPath}/builds/${Config.packageName}_release_signed.apk',
  ]);
}

@DefaultTask()
@Depends(test)
build() {
  Pub.build();
}

@Task()
clean() => defaultClean();

@Task()
buildApk() async {
  await runAsync('fvm', arguments: [
    'flutter',
    'build',
    'apk',
    '--target-platform=android-arm64',
    '--dart-define',
    'ISDEBUG=false'
  ]);
  String date = DateUtil.formatDate(DateTime.now(), format: 'yy_MM_dd_HH_mm');
  String version = await getVersion();
  await runAsync('mv', arguments: [
    Config.buildPath,
    '${Config.buildDir}/${Config.packageName}_${version}_release_$date.apk'
  ]);
}

@Task()
buildApk32() async {
  await runAsync('fvm', arguments: [
    'flutter',
    'build',
    'apk',
    '--target-platform=android-armeabi-v7a',
    '--dart-define',
    'ISDEBUG=false'
  ]);
  String date = DateUtil.formatDate(DateTime.now(), format: 'yy_MM_dd_HH_mm');
  String version = await getVersion();
  await runAsync('mv', arguments: [
    Config.buildPath,
    '${Config.buildDir}/${Config.packageName}_${version}_release_$date.apk'
  ]);
}
@Task()
@Depends(getVersion)
buildApkDev() async {
  await runAsync('fvm', arguments: [
    'flutter',
    'build',
    'apk',
    '--target-platform=android-arm64',
    '--dart-define',
    'ISDEBUG=true'
  ]);

  String date = DateUtil.formatDate(DateTime.now(), format: 'yy_MM_dd_HH_mm');
  String version = await getVersion();
  await runAsync('mv', arguments: [
    Config.buildPath,
    '${Config.buildDir}/${Config.packageName}_${version}_beta_$date.apk'
  ]);
}

@Task()
buildIos() async {
  runAsync('fvm',
      arguments: ['flutter', 'build', 'ios', '--dart-define', 'ISDEBUG=false']);
}

@Task()
buildIosDev() async {
  runAsync('fvm',
      arguments: ['flutter', 'build', 'ios', '--dart-define', 'ISDEBUG=true']);
}

@Task()
Future<String> getVersion() async {
  String projectPath = Directory('.').absolute.path;
  String yamlPath = join(projectPath, 'pubspec.yaml');
  String yamlContent = await File(yamlPath).readAsString();
  dynamic content = loadYaml(yamlContent);
  String version = content['version'];
  return version;
}
