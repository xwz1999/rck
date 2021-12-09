package com.akuhome.recook;

//import android.os.Bundle;
//import io.flutter.app.FlutterActivity;
//import io.flutter.plugins.GeneratedPluginRegistrant;
import android.os.Bundle;
import android.os.Build;
import android.os.PersistableBundle;
import android.view.KeyEvent;
import android.view.View;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import io.flutter.plugin.common.MethodCall;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;


public class MainActivity extends FlutterActivity {
//  @Override
//  protected void onCreate(Bundle savedInstanceState) {
//    super.onCreate(savedInstanceState);
//    GeneratedPluginRegistrant.registerWith(this);
//  }

  //通讯名称,回到手机桌面
  private  final String CHANNEL = "android/back/desktop";
  @Override
  public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
    GeneratedPluginRegistrant.registerWith(flutterEngine);
    new MethodChannel(flutterEngine.getDartExecutor(), CHANNEL).setMethodCallHandler(
            new MethodChannel.MethodCallHandler() {
              @Override
              public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
                if (call.method.equals("backDesktop")) {
                  result.success(true);
                  moveTaskToBack(false);
                }
              }
            }
    );
  }

    // 设置状态栏沉浸式透明（修改flutter状态栏黑色半透明为全透明）
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            getWindow().setStatusBarColor(0);
        }
    }
  //  @Override
//    protected void onCreate(Bundle savedInstanceState) {
//        super.onCreate(savedInstanceState);
////        GeneratedPluginRegistrant.registerWith(this);
//        new MethodChannel(FlutterEngine.dart, CHANNEL).setMethodCallHandler(
////        new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(
//            new MethodChannel.MethodCallHandler() {
//              @Override
//              public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
//                if (methodCall.method.equals("backDesktop")) {
//                  result.success(true);
//                  moveTaskToBack(false);
//                }
//              }
//            }
//        );
//    }

}
