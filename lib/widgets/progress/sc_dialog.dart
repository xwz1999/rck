/*
 * ====================================================
 * package   : utils
 * author    : Created by nansi.
 * time      : 2019/3/26  2:47 PM 
 * remark    : 
 * ====================================================
 */

import 'package:flutter/material.dart';
import 'package:recook/widgets/progress/loading_dialog.dart';
@Deprecated('use Retoast or Toast instead')
class GSDialog {
  static Map<BuildContext?, GSDialog?> dialogs = Map();

  bool hasLoading = false;
  bool hasLongTimeLoading = false;

  static GSDialog of(BuildContext? context) {
    GSDialog? dialog = dialogs[context];
    if (dialog != null) {
      return dialog;
    }
    dialog = GSDialog();
    dialogs.putIfAbsent(context, () => dialog);
    return dialog;
  }

  @Deprecated("mark sc_dialog's loading need to be cleaned.")
  Future<Null> showLoadingDialog(BuildContext context, String text,
      {Color color = Colors.black38}) {
    if (hasLoading) {
      dismiss(context);
    }
    hasLoading = true;
    return showDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: color,
        builder: (BuildContext context) {
          return new LoadingDialog(
            //调用对话框
            text: text,
          );
        });
  }

  Future<Null> showLongTimeLoadingDialog(BuildContext context, String text) {
    if (hasLongTimeLoading) {
      dismiss(context);
    }
    hasLoading = true;
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new LoadingDialog(
            //调用对话框
            text: text,
          );
        });
  }

  Future<Null> showSuccess(BuildContext context, String text,
      {Duration duration = const Duration(milliseconds: 1000),
      bool dismissLoading = false}) {
    if (hasLoading) {
      dismiss(context);
    }
    return showCustomDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new StatusDialog(
            //调用对话框
            text: text,
          );
        });
  }

  Future<Null> showError(BuildContext context, String? text,
      {Duration duration = const Duration(milliseconds: 1000),
      bool dismissLoading = false}) {
    print("hasLoading ====== $hasLoading");
    if (hasLoading) {
      dismiss(context);
    }
    return showCustomDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new StatusDialog(
            status: Status.error,
            //调用对话框
            text: text,
          );
        });
  }

  Future<Null> showWarning(BuildContext context, String text,
      {Duration duration = const Duration(milliseconds: 1000),
      bool dismissLoading = false}) {
    if (hasLoading) {
      dismiss(context);
    }
    return showCustomDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new StatusDialog(
            status: Status.warning,
            //调用对话框
            text: text,
          );
        });
  }

  dismiss(BuildContext context) {
    hasLoading = false;
    dialogs.remove(context);
    Navigator.pop(context);
  }

  static Future<Null> showCustomDialog(
      {required BuildContext context,
      WidgetBuilder? builder,
      Duration duration = const Duration(milliseconds: 1000),
      bool barrierDismissible = true}) async {
    final ThemeData? theme = Theme.of(context);
    showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext buildContext, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        final Widget pageChild = Builder(builder: builder!);
        return SafeArea(
          child: Builder(builder: (BuildContext context) {
            return theme != null
                ? Theme(data: theme, child: pageChild)
                : pageChild;
          }),
        );
      },
      barrierDismissible: barrierDismissible,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Color.fromARGB(1, 0, 0, 0),
      transitionDuration: const Duration(milliseconds: 150),
      transitionBuilder: _buildMaterialDialogTransitions,
    );

    await Future<Null>.delayed(duration, () {});
    Navigator.pop(context);
    return null;
  }

  static Widget _buildMaterialDialogTransitions(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: animation,
        curve: Curves.easeOut,
      ),
      child: child,
    );
  }
}
