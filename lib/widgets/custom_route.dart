/*
 * ====================================================
 * package   : widgets
 * author    : Created by nansi.
 * time      : 2019/5/29  1:19 PM 
 * remark    : 
 * ====================================================
 */

import 'package:flutter/material.dart';

enum AnimationType { push, fade, model }


class CustomRoute extends PageRouteBuilder {

  final AnimationType type;
  final WidgetBuilder builder;

  CustomRoute({ this.type, this.builder})
      : super(
            // 设置过度时间
            transitionDuration: Duration(milliseconds: 200),
            // 构造器
            pageBuilder: (
              // 上下文和动画
              BuildContext context,
              Animation<double> animaton1,
              Animation<double> animaton2,
            ) {
              return builder(context);
            },
            transitionsBuilder: (
              BuildContext context,
              Animation<double> animaton1,
              Animation<double> animaton2,
              Widget child,
            ) {
              // 需要什么效果把注释打开就行了
              // 渐变效果
              switch (type) {
                case AnimationType.fade:{
                  return FadeTransition(
                    // 从0开始到1
                    opacity: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                      // 传入设置的动画
                      parent: animaton1,
                      // 设置效果，快进漫出   这里有很多内置的效果
                      curve: Curves.fastOutSlowIn,
                    )),
                    child: child,
                  );
                }

                case AnimationType.model: {
                  return SlideTransition(
                    position: Tween<Offset>(
                      // 设置滑动的 X , Y 轴
                        begin: Offset(0.0, 1.0),
                        end: Offset(0.0,0.0)
                    ).animate(CurvedAnimation(
                        parent: animaton1,
                        curve: Curves.easeIn
                    )),
                    child: child,
                  );
                }

                case AnimationType.push: {

                }
              }


              // 缩放动画效果
              // return ScaleTransition(
              //   scale: Tween(begin: 0.0,end: 1.0).animate(CurvedAnimation(
              //     parent: animaton1,
              //     curve: Curves.fastOutSlowIn
              //   )),
              //   child: child,
              // );

              // 旋转加缩放动画效果
              // return RotationTransition(
              //   turns: Tween(begin: 0.0,end: 1.0)
              //   .animate(CurvedAnimation(
              //     parent: animaton1,
              //     curve: Curves.fastOutSlowIn,
              //   )),
              //   child: ScaleTransition(
              //     scale: Tween(begin: 0.0,end: 1.0)
              //     .animate(CurvedAnimation(
              //       parent: animaton1,
              //       curve: Curves.fastOutSlowIn
              //     )),
              //     child: child,
              //   ),
              // );

              // 左右滑动动画效果
              // return SlideTransition(
              //   position: Tween<Offset>(
              //     // 设置滑动的 X , Y 轴
              //     begin: Offset(-1.0, 0.0),
              //     end: Offset(0.0,0.0)
              //   ).animate(CurvedAnimation(
              //     parent: animaton1,
              //     curve: Curves.fastOutSlowIn
              //   )),
              //   child: child,
              // );
            });
}
