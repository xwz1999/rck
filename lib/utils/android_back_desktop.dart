import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AndroidBackTop {
	//初始化通信管道-设置退出到手机桌面
	static const String CHANNEL = "android/back/desktop";
	//设置回退到手机桌面事件
	static const String eventBackDesktop = "backDesktop";


	// static const String eventRecoveryCopy = "recoveryCopy";
	static const String agree = "agree";


	//设置回退到手机桌面
	static Future<bool> backDeskTop() async {
		final platform = MethodChannel(CHANNEL);
		//通知安卓返回,到手机桌面
		try {
			await platform.invokeMethod(eventBackDesktop);
		} on PlatformException catch (e) {
			debugPrint("通信失败(设置回退到安卓手机桌面:设置失败)");
			print(e.toString());
		}
		return Future.value(false);
	}

	///华为市场监测到调用剪切板（所以先全局禁用）同意隐私政策以后重新打开
	// static Future<bool> recoveryCopy() async {
	// 	final platform = MethodChannel(CHANNEL);
	// 	//通知安卓返回,到手机桌面
	// 	try {
	// 		print('flutter调用恢复方法');
	// 		await platform.invokeMethod(eventRecoveryCopy);
	//
	// 	} on PlatformException catch (e) {
	// 		debugPrint("恢复粘贴失败");
	// 		print(e.toString());
	// 	}
	// 	return Future.value(false);
	// }


	static Future<bool> agreeEvent() async {
		final platform = MethodChannel(CHANNEL);
		//通知安卓返回,到手机桌面
		try {
			print('同意协议');
			await platform.invokeMethod(agree);

		} on PlatformException catch (e) {
			debugPrint("恢复粘贴失败");
			print(e.toString());
		}
		return Future.value(false);
	}
}
