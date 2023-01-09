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
import android.app.Activity;
import android.content.SharedPreferences;


public class MainActivity extends FlutterActivity {

  //通讯名称,回到手机桌面
  private  final String CHANNEL = "android/back/desktop";
  static final String eventBackDesktop = "backDesktop";
//  @Override
//  public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
//    GeneratedPluginRegistrant.registerWith(flutterEngine);
//    new MethodChannel(flutterEngine.getDartExecutor(), CHANNEL).setMethodCallHandler(
//            new MethodChannel.MethodCallHandler() {
//              @Override
//              public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
//                if (call.method.equals("backDesktop")) {
//                  result.success(true);
//                  moveTaskToBack(false);
//                }
//              }
//            }
//    );
//  }
    @Override
    public void configureFlutterEngine(FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        GeneratedPluginRegistrant.registerWith(flutterEngine);

        SharedPreferences sharedPreferences = getSharedPreferences("flutter",
                Activity.MODE_PRIVATE);
        String name =sharedPreferences.getString("copy", "");
        HookFlutterClipBordUtil.isAgree = name;

        HookFlutterClipBordUtil.hookClipBoard(flutterEngine);


    }


        // 设置状态栏沉浸式透明（修改flutter状态栏黑色半透明为全透明）
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        initBackToDesktop();
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            getWindow().setStatusBarColor(0);
        }

    }

    private void init(){
        SharedPreferences mySharedPreferences= getSharedPreferences("flutter",
                Activity.MODE_PRIVATE);
//实例化SharedPreferences.Editor对象（第二步）
        SharedPreferences.Editor editor = mySharedPreferences.edit();
//用putString的方法保存数据
        editor.putString("copy", "agree");
//提交当前数据
        editor.commit();
    }


    //注册返回到手机桌面事件
    private void initBackToDesktop() {
        new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(), CHANNEL).setMethodCallHandler(
                new MethodChannel.MethodCallHandler() {
                    @Override
                    public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
                        if (methodCall.method.equals(eventBackDesktop)) {
                            moveTaskToBack(false);
                            result.success(true);
                        }
                        else if(methodCall.method.equals("agree")){
                            System.out.println("agree");
                            init();
                        }
//                        else if(methodCall.method.equals("stopCopy")){
//
//                            System.out.println("stopCopy");
//                            HookFlutterClipBordUtil.hookClipBoard(getFlutterEngine());
//                        }
                    }
                }
        );
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
