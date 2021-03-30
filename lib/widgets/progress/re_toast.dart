import 'package:flutter/material.dart';

import 'package:bot_toast/bot_toast.dart';

import 'package:recook/widgets/progress/loading_dialog.dart';

class ReToast {
  static Function loading({String text}) {
    return BotToast.showCustomLoading(
      toastBuilder: (func) {
        return LoadingDialog(text: text ?? '');
      },
    );
  }

  static Function err({String text}) {
    return BotToast.showCustomText(
      toastBuilder: (func) {
        return StatusDialog(
          status: Status.error,
          text: text ?? '',
        );
      },
    );
  }

  static Function raw(Widget child) => BotToast.showCustomLoading(
        toastBuilder: (func) => child,
        enableKeyboardSafeArea: false,
      );
}
