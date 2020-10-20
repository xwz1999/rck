
# recook

## 瑞库客 商城应用 📦

## 在运行和构建应用前请详细阅读本文档

## Before Started

`fluwx` 和 `sharesdk_plugin`冲突 ，参考 [ShareSDK(分享插件)和Fluwx(微信支付插件)存在冲突](https://github.com/OpenFlutter/fluwx/blob/master/doc/QA_CN.md#sharesdk%E5%88%86%E4%BA%AB%E6%8F%92%E4%BB%B6%E5%92%8Cfluwx%E5%BE%AE%E4%BF%A1%E6%94%AF%E4%BB%98%E6%8F%92%E4%BB%B6%E5%AD%98%E5%9C%A8%E5%86%B2%E7%AA%81)

由于历史原因，下面给出本项目解决方案

找到`./ios/.symlinks/plugin`目录

将其中的`fluwx`目录下的 `./ios/fluwx.podspec` 中微信相关的依赖设置为`s.dependency 'mob_sharesdk/ShareSDKPlatforms/WeChatFull'`

``` podsepec
  ... ...
  s.homepage         = 'https://github.com/OpenFlutter/fluwx'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'JarvanMo' => 'jarvan.mo@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/public/*.h'
  s.static_framework = true
  s.dependency 'Flutter'
  # s.dependency 'WechatOpenSDK', '1.8.6.2'
  s.dependency 'mob_sharesdk/ShareSDKPlatforms/WeChatFull'
  # s.dependency 'OpenWeChatSDK','~> 1.8.3+10'
  #  s.xcconfig = { 'HEADER_SEARCH_PATHS' => "${PODS_ROOT}/Headers/Public/#{s.name}" }
  s.frameworks = ["SystemConfiguration", "CoreTelephony","WebKit"]
  s.libraries = ["z", "sqlite3.0", "c++"]
  s.preserve_paths = 'Lib/*.a'
  s.vendored_libraries = "**/*.a"
 s.ios.deployment_target = '8.0'
 ... ...
```

将`sharesdk_plugin`目录中`./ios/sharesdk_plugin.podspec`中微信依赖设置为`s.dependency 'mob_sharesdk/ShareSDKPlatforms/WeChatFull'`

``` podspec
  ... ...
  s.dependency 'Flutter'
  s.dependency 'mob_sharesdk'
  s.dependency 'mob_sharesdk/ShareSDKExtension'
  s.dependency 'mob_sharesdk/ShareSDKUI'
  s.dependency 'mob_sharesdk/ShareSDKPlatforms/QQ'
  s.dependency 'mob_sharesdk/ShareSDKPlatforms/SinaWeibo'
  # s.dependency 'mob_sharesdk/ShareSDKPlatforms/WeChat'
  s.dependency 'mob_sharesdk/ShareSDKPlatforms/WeChatFull'
  s.dependency 'mob_sharesdk/ShareSDKPlatforms/Facebook'
  s.dependency 'mob_sharesdk/ShareSDKPlatforms/Twitter'
  s.dependency 'mob_sharesdk/ShareSDKPlatforms/Douyin'
  s.dependency 'mob_sharesdk/ShareSDKPlatforms/Oasis'
  s.dependency 'mob_sharesdk/ShareSDKPlatforms/Line'
  s.dependency 'mob_sharesdk/ShareSDKPlatforms/SnapChat'
  s.dependency 'mob_sharesdk/ShareSDKPlatforms/WatermelonVideo'
  s.dependency 'mob_sharesdk/ShareSDKPlatforms/KuaiShou'
  ... ...
```

注意 *⚠️ 本修改直接修改依赖文件，需要注意其他使用相同依赖的项目*

## Getting Started

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
