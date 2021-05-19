import 'dart:async';
import 'dart:io';
import 'package:common_utils/common_utils.dart';
import 'package:grinder/grinder.dart';

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
  await Process.start('flutter', ['build', 'apk']).then((proc) async {
    await stdout.addStream(proc.stdout);
    await stderr.addStream(proc.stderr);
  });
  stdout.write("\rBuild APK DONE 📦\n");
  stdout.write("copy build to download 🛠\n");
  await Process.run('rm', ['-rf', '${Config.downloadPath}/builds']);
  await Process.run('mkdir', ['${Config.downloadPath}/builds']);
  await Process.run('cp', [
    Config.buildPath,
    '${Config.downloadPath}/builds/${Config.packageName}_release.apk'
  ]);

  stdout.write("opening downloadPath 🛠\n");
  await Process.run('open', ['${Config.downloadPath}/builds']);
  stdout.write("opening tencent reinforce 🛠\n");
  await Process.run(
      'open', ['https://console.cloud.tencent.com/ms/reinforce/upload']);
}

@Task()
Future releaseDev() async {
  TaskArgs args = context.invocation.arguments;
  String input = args.getOption('type') ?? 'dev';

  stdout.write("Build Dev APK 📦\n");
  stdout.write("BUILDINGAPK\n");
  await Process.start('flutter', ['build', 'apk']).then((proc) async {
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
  TaskArgs args = context.invocation.arguments;
  String input = args.getOption('input');
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
      input,
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
  Pub.runAsync('flutter', arguments: [
    'build',
    'apk',
    '--target-platform=android-arm64',
    '--dart-define',
    'ISDEBUG=false'
  ]);
}

@Task()
buildApkDev() async {
  Pub.runAsync('flutter', arguments: [
    'build',
    'apk',
    '--target-platform=android-arm64',
    '--dart-define',
    'ISDEBUG=true'
  ]);
}

@Task()
buildIos() async {
  Pub.runAsync('flutter', arguments: [
    'build',
    'ios',
    '--dart-define',
    'ISDEBUG=false'
  ]);
}


