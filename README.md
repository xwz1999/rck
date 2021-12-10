
# recook

![recook](./assets/icon/recook_icon_120.png)

## 京耀云 商城应用 📦

## 在运行和构建应用前请详细阅读本文档

## Before Started

### Fluwx ShareSDK_Plugin冲突 修改详情

`fluwx` 和 `sharesdk_plugin`冲突 ，参考 [ShareSDK(分享插件)和Fluwx(微信支付插件)存在冲突](https://github.com/OpenFlutter/fluwx/blob/master/doc/QA_CN.md#sharesdk%E5%88%86%E4%BA%AB%E6%8F%92%E4%BB%B6%E5%92%8Cfluwx%E5%BE%AE%E4%BF%A1%E6%94%AF%E4%BB%98%E6%8F%92%E4%BB%B6%E5%AD%98%E5%9C%A8%E5%86%B2%E7%AA%81)

[fluwx fix](http://test.akuhotel.com:8099/laiiihz/fluwx)

[sharesdk_plugin](http://test.akuhotel.com:8099/laiiihz/sharesdk_plugin/commit/7e5ac4829491e386321f8533223211c1c865cf52)

### 简单校验应用证书

`main.dart` 142行

### 明文保存证书解决方案

`./lib/utils/sc_encrypt_util.dart`  17,27行

## Getting Started

### 打包apk

```bash
flutter pub run grinder build-apk
```

`with verbose`

```bash
flutter pub run grinder build-apk --v
```

### 加固应用后签名
//加固使用腾讯云
//签名前请确保已安装java环境
//签名前请将加固后的的安装包重命名为"RECOOK_reinforce.apk",并移动至”/Users/$name/Downloads/buils/“目录下
```bash
grind sign
```

### 预安装软件包

在运行应用前请使用`./command/resource_gen.sh`来生成图片

该命令需要安装`flutter_resource_generator`,在终端中运行

```bash
flutter pub global activate flutter_resource_generator
```

* [flutter_resource_generator](https://pub.flutter-io.cn/packages/flutter_resource_generator)

开发分支在`master`,`main.dart`中isDebug参数为`true`

发行分支在`release`,`main.dart`中isDebug参数为`false`

注意 ⚠️ 请勿直接修改发行`isDebug`参数,打包发行分支前请合并开发分支

## Design Guide Book

### 设计宽 Design Width `rSize`

### 设计高 Design Height `rSize`

example:
rSize(`value`) `value` is design `pt`

### 使用自动生成的图片

假设你有一张图片`assets/live/user.png`,你只需要使用`R.ASSETS_LIVE_USER_PNG`即可使用该图片

## TODO LIST

* [ ] 迁移GSDialog 到 BotToast
