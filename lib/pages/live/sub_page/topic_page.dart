import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/recook_back_button.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

class TopicPage extends StatefulWidget {
  TopicPage({Key key}) : super(key: key);

  @override
  _TopicPageState createState() => _TopicPageState();
}

class _TopicPageState extends State<TopicPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.frenchColor,
      body: Stack(
        children: [
          CustomScrollView(
            physics:
                BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            slivers: [
              SliverAppBar(
                leading: RecookBackButton(white: true),
                stretch: true,
                floating: true,
                expandedHeight:
                    rSize(140) + MediaQuery.of(context).viewPadding.top,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        top: 0,
                        child: FadeInImage.assetNetwork(
                          placeholder: R.ASSETS_PLACEHOLDER_NEW_1X1_A_PNG,
                          image: Api.getImgUrl(
                              '/photo/58ea9ceb4be7300fa79c47e1ea80252f.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                        child: Container(
                          color: Colors.black.withOpacity(0.11),
                        ),
                      ),
                      Positioned(
                        bottom: rSize(22),
                        left: rSize(15),
                        right: rSize(15),
                        child: Row(
                          children: [
                            FadeInImage.assetNetwork(
                              placeholder: R.ASSETS_PLACEHOLDER_NEW_1X1_A_PNG,
                              image: Api.getImgUrl(
                                  '/photo/58ea9ceb4be7300fa79c47e1ea80252f.jpg'),
                              fit: BoxFit.cover,
                              height: rSize(64),
                              width: rSize(64),
                              alignment: Alignment.bottomRight,
                            ),
                            SizedBox(width: rSize(15)),
                            Expanded(
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '#高颜值厨房好物',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: rSP(16),
                                          ),
                                        ),
                                      ),
                                      MaterialButton(
                                        minWidth: rSize(56),
                                        height: rSize(26),
                                        onPressed: () {},
                                        color: Color(0xFFDB2D2D),
                                        child: Text('+ 关注'),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(rSize(13)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.all(rSize(15)),
                sliver: SliverWaterfallFlow(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return _buildCard();
                  }),
                  gridDelegate:
                      SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: rSize(15),
                    mainAxisSpacing: rSize(15),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: MediaQuery.of(context).viewPadding.bottom,
            left: 0,
            right: 0,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: rSize(15),
                vertical: rSize(6),
              ),
              child: SizedBox(
                height: rSize(36),
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(rSize(18)),
                  ),
                  onPressed: () {},
                  color: Color(0xFFDB2D2D),
                  child: Text(
                    '参与话题',
                    style: TextStyle(fontSize: rSP(16)),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildCard() {
    final height = 100 + 150 * Random().nextDouble();
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: CustomImageButton(
        onPressed: () {},
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: height,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Placeholder(),
            ),
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(rSize(10)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '爱生活，爱厨房，爱上厨房精美的器具里生活的…',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Color(0xFF333333),
                      fontSize: rSP(13),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: rSize(6)),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: rSize(9),
                      ),
                      Expanded(
                        child: Text(
                          '',
                          style: TextStyle(
                            color: Color(0xFF666666),
                            fontSize: rSP(12),
                          ),
                        ),
                      ),
                      Image.asset(
                        R.ASSETS_LIVE_FAVORITE_BLACK_PNG,
                        height: rSize(14),
                        width: rSize(14),
                      ),
                      Text(
                        '13',
                        style: TextStyle(
                          color: Color(0xFf666666),
                          fontSize: rSP(12),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
