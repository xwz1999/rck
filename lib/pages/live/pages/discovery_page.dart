import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/pages/business/focus/child_focus_page.dart';

class DiscoveryPage extends StatefulWidget {
  DiscoveryPage({Key? key}) : super(key: key);

  @override
  _DiscoveryPageState createState() => _DiscoveryPageState();
}

class _DiscoveryPageState extends State<DiscoveryPage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 1, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.frenchColor,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        backgroundColor: Colors.white,
        // leading: SizedBox(
        //   width: rSize(50),
        //   child: UserManager.instance.haveLogin
        //       ? CustomImageButton(
        //           padding: EdgeInsets.symmetric(
        //             horizontal: rSize(16),
        //             vertical: rSize(12),
        //           ),
        //           child: Image.asset(
        //             R.ASSETS_LIVE_USER_PNG,
        //             width: rSize(20),
        //             height: rSize(20),
        //           ),
        //           onPressed: () {
        //             CRoute.push(
        //               context,
        //               UserHomePage(
        //                 userId: UserManager.instance.user.info.id,
        //               ),
        //             );
        //           },
        //         )
        //       : SizedBox(),
        // ),
        // title: TabBar(
        //   isScrollable: true,
        //   controller: _tabController,
        //   labelColor: Color(0xFF333333),
        //   unselectedLabelColor: Color(0xFF333333).withOpacity(0.3),
        //   labelStyle: TextStyle(
        //     fontSize: rSP(18),
        //     fontWeight: FontWeight.w600,
        //   ),
        //   unselectedLabelStyle: TextStyle(
        //     fontSize: rSP(18),
        //     fontWeight: FontWeight.w400,
        //   ),
        //   indicatorSize: TabBarIndicatorSize.label,
        //   indicator: RecookIndicator(
        //     borderSide: BorderSide(
        //       width: rSize(3),
        //       color: Color(0xFFDB2D2D),
        //     ),
        //   ),
        //   tabs: [
        //     // Tab(text: '直播'),
        //     // Tab(text: '视频'),
        //     Tab(text: '图文'),
        //   ],
        // ),
        title: Text('图文动态',style: TextStyle(color: Colors.black),),
        centerTitle: true,
        titleSpacing: 0,
        actions: [
          SizedBox(width: rSize(50)),
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: FocusPage(),
          //     CacheTabBarView(
          //   controller: _tabController,
          //   children: [
          //     // LiveStreamPage(),
          //     // VideoPage(),
          //     FocusPage(),
          //   ],
          // )
          ),
        ],
      ),
    );
  }
}
