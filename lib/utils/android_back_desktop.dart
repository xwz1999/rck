import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AndroidBackTop {
	//初始化通信管道-设置退出到手机桌面
	static const String CHANNEL = "android/back/desktop";
	//设置回退到手机桌面事件
	static const String eventBackDesktop = "backDesktop";
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
}
