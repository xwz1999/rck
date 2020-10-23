import 'package:flutter/material.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/pages/live/sub_page/user_attention/topic_attention_view.dart';
import 'package:recook/pages/live/sub_page/user_attention/user_attention_view.dart';
import 'package:recook/pages/live/widget/live_attention_button.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/recook/recook_scaffold.dart';
import 'package:recook/widgets/recook_indicator.dart';

class UserAttentionPage extends StatefulWidget {
  final int id;
  UserAttentionPage({Key key, @required this.id}) : super(key: key);

  @override
  _UserAttentionPageState createState() => _UserAttentionPageState();
}

class _UserAttentionPageState extends State<UserAttentionPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  bool get selfFlag => widget.id == UserManager.instance.user.info.id;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RecookScaffold(
      title: selfFlag ? '我的关注' : 'TA的关注',
      whiteBg: true,
      appBarBottom: PreferredSize(
        preferredSize: Size.fromHeight(rSize(38)),
        child: TabBar(
          isScrollable: true,
          tabs: [
            Tab(text: '用户'),
            Tab(text: '话题'),
          ],
          indicatorPadding: EdgeInsets.symmetric(
            horizontal: 0,
          ),
          indicator: RecookIndicator(
            borderSide: BorderSide(
              color: Color(0xFFDB2D2D),
              width: rSize(3),
            ),
          ),
          indicatorSize: TabBarIndicatorSize.label,
          labelColor: Color(0xFF333333),
          unselectedLabelColor: Color(0xFF666666),
          controller: _tabController,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          UserAttentionView(id: widget.id),
          TopicAttentionView(id: widget.id),
        ],
      ),
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
