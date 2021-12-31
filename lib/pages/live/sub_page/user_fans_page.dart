import 'package:flutter/material.dart';

import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/manager/user_manager.dart';
import 'package:jingyaoyun/pages/live/sub_page/user_attention/topic_attention_view.dart';
import 'package:jingyaoyun/pages/live/sub_page/user_attention/user_attention_view.dart';
import 'package:jingyaoyun/pages/live/widget/live_attention_button.dart';
import 'package:jingyaoyun/widgets/custom_image_button.dart';
import 'package:jingyaoyun/widgets/recook/recook_scaffold.dart';
import 'package:jingyaoyun/widgets/recook_indicator.dart';

class UserFansPage extends StatefulWidget {
  final int id;
  UserFansPage({Key key, @required this.id}) : super(key: key);

  @override
  _UserFansPageState createState() => _UserFansPageState();
}

class _UserFansPageState extends State<UserFansPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  bool get selfFlag => widget.id == UserManager.instance.user.info.id;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RecookScaffold(
      title: selfFlag ? '我的粉丝' : 'TA的粉丝',
      whiteBg: true,
      body:  UserAttentionView(id: widget.id),
    );
  }
}

Widget buildUserBaseCard({
  Widget prefix,
  @required String title,
  String subTitlePrefix,
  String subTitleSuffix,
  @required VoidCallback onTap,
  bool initAttention = false,
  @required Function(bool oldState) onAttention,
}) {
  return CustomImageButton(
    onPressed: onTap,
    child: Container(
      padding: EdgeInsets.all(rSize(15)),
      child: Row(
        children: [
          prefix,
          SizedBox(width: rSize(15)),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Color(0xFF333333),
                    fontSize: rSP(14),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: rSize(3)),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        subTitlePrefix,
                        style: TextStyle(
                          color: Color(0xFF666666),
                          fontSize: rSP(13),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        subTitleSuffix,
                        style: TextStyle(
                          color: Color(0xFF666666),
                          fontSize: rSP(13),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: rSize(15)),
          LiveAttentionButton(
            initAttention: initAttention,
            onAttention: onAttention,
          ),
        ],
      ),
    ),
  );
}
