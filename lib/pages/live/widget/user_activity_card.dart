import 'package:flutter/material.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/constants.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/pages/live/models/activity_list_model.dart';
import 'package:recook/pages/live/widget/user_base_card.dart';
import 'package:recook/utils/date/recook_date_util.dart';
import 'package:recook/widgets/custom_image_button.dart';

class UserActivityCard extends StatefulWidget {
  final ActivityListModel model;
  UserActivityCard({Key key, @required this.model}) : super(key: key);

  @override
  _UserActivityCardState createState() => _UserActivityCardState();
}

class _UserActivityCardState extends State<UserActivityCard> {
  int get imgSize => widget.model.imgList.length;

  int get axisCount {
    if (imgSize == 1)
      return 1;
    else if (imgSize <= 4)
      return 2;
    else
      return 3;
  }

  @override
  Widget build(BuildContext context) {
    final recookDateUtil = RecookDateUtil.fromString(widget.model.updatedAt);

    return UserBaseCard(
      date: recookDateUtil.prefixDay,
      detailDate: recookDateUtil.detailDate,
      children: [
        SizedBox(height: rSize(35)),
        Builder(builder: (context) {
          if (widget.model.trendType == 1)
            return widget.model.imgList.isEmpty
                ? SizedBox()
                : GridView(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: axisCount,
                      crossAxisSpacing: rSize(9),
                      mainAxisSpacing: rSize(9),
                    ),
                    physics: NeverScrollableScrollPhysics(),
                    children: widget.model.imgList
                        .map((e) => FadeInImage.assetNetwork(
                              placeholder: R.ASSETS_PLACEHOLDER_NEW_1X1_A_PNG,
                              image: Api.getImgUrl(e.url),
                            ))
                        .toList(),
                    shrinkWrap: true,
                  );
          else if (widget.model.trendType == 2)
            return Image.asset(R.ASSETS_PLACEHOLDER_NEW_1X1_A_PNG);
          else
            return SizedBox();
        }),
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: rSize(10),
          ),
          child: Text(
            widget.model.content,
            style: TextStyle(
              color: Color(0xFF333333),
              fontSize: rSP(14),
            ),
          ),
        ),
        Container(
          color: Color(0xFFF2F4F7),
          padding: EdgeInsets.all(12),
          child: Row(
            children: [
              FadeInImage.assetNetwork(
                placeholder: R.ASSETS_PLACEHOLDER_NEW_1X1_A_PNG,
                image: Api.getImgUrl(widget.model.goods.mainPhotoURL),
                height: rSize(48),
                width: rSize(48),
              ),
              SizedBox(width: rSize(12)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.model.goods.name,
                      maxLines: 1,
                      style: TextStyle(
                        color: Color(0xFF333333),
                        fontSize: rSP(14),
                      ),
                    ),
                    SizedBox(height: rSize(6)),
                    Text(
                      '¥${widget.model.goods.price}',
                      maxLines: 1,
                      style: TextStyle(
                        color: Color(0xFF333333),
                        fontSize: rSP(14),
                      ),
                    ),
                  ],
                ),
              ),
              CustomImageButton(
                child: Image.asset(
                  R.ASSETS_HOME_PAGE_ROW_SHARE_ICON_PNG,
                  width: rSize(18),
                  height: rSize(18),
                ),
                onPressed: () {},
              ),
              SizedBox(width: rSize(10)),
            ],
          ),
        ),
        Row(
          children: [
            CustomImageButton(
              padding: EdgeInsets.only(top: rSize(10)),
              child: Image.asset(
                R.ASSETS_LIVE_MORE_PNG,
                width: rSize(18),
                height: rSize(18),
              ),
              onPressed: () {},
            ),
            Spacer(),
            CustomImageButton(
              padding: EdgeInsets.only(top: rSize(10)),
              child: Image.asset(
                R.ASSETS_LIVE_REVIEW_PNG,
                width: rSize(18),
                height: rSize(18),
              ),
              onPressed: _showReviewDialog,
            ),
            SizedBox(width: rSize(10)),
            CustomImageButton(
              padding: EdgeInsets.only(top: rSize(10)),
              child: Image.asset(
                R.ASSETS_LIVE_LIKE_PNG,
                width: rSize(18),
                height: rSize(18),
              ),
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }

  _showReviewDialog() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.55),
      barrierLabel: '',
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final value = Curves.easeInOutCubic.transform(animation.value);
        return Transform.translate(
          offset: Offset(0, (1 - value) * 400),
          child: child,
        );
      },
      transitionDuration: Duration(milliseconds: 300),
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return ReviewChildCards();
      },
    );
  }
}

class ReviewChildCards extends StatefulWidget {
  ReviewChildCards({Key key}) : super(key: key);

  @override
  _ReviewChildCardsState createState() => _ReviewChildCardsState();
}

class _ReviewChildCardsState extends State<ReviewChildCards> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: DraggableScrollableSheet(
        maxChildSize: 1 - (MediaQuery.of(context).padding.top / rSize(667)),
        minChildSize: rSize(434) / rSize(667),
        initialChildSize: rSize(434) / rSize(667),
        builder: (context, scrollController) {
          return Material(
            color: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
              top: Radius.circular(rSize(15)),
            )),
            child: Column(
              children: [
                SizedBox(height: rSize(15)),
                Row(
                  children: [
                    SizedBox(width: rSize(15)),
                    Text(
                      '评论',
                      style: TextStyle(
                        color: Color(0xFF333333),
                        fontSize: rSP(16),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: rSize(8)),
                    Text(
                      '21',
                      style: TextStyle(
                        color: Color(0xFF333333).withOpacity(0.4),
                        fontSize: rSP(16),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: rSize(15)),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    padding: EdgeInsets.symmetric(horizontal: rSize(15)),
                    itemBuilder: (context, index) {
                      return _buildReviewCard();
                    },
                  ),
                ),
                Container(
                  color: Colors.white,
                  height: rSize(48),
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(
                    vertical: rSize(6),
                    horizontal: rSize(15),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        hintText: '随便说两句…',
                        hintStyle: TextStyle(
                          color: Color(0xFF7F858D),
                          fontSize: rSP(14),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: rSize(15),
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(rSize(18)),
                    ),
                  ),
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  height: MediaQuery.of(context).viewPadding.bottom +
                      MediaQuery.of(context).viewInsets.bottom,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  _buildReviewCard() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: rSize(28 / 2),
        ),
        SizedBox(width: rSize(6)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    '蔡奇奇',
                    style: TextStyle(
                      color: Color(0xFF333333),
                      fontSize: rSP(14),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  Image.asset(
                    R.ASSETS_LIVE_LIKE_PNG,
                    width: rSize(14),
                    height: rSize(14),
                  ),
                ],
              ),
              SizedBox(height: rSize(2)),
              Text(
                '这个我已经用了很久啦，终于看到有人来推荐了，大家一定要入手啊这个我已经用了很久啦，终于看到有人来推荐了，大家一定要入手啊',
                style: TextStyle(
                  color: Color(0xFF333333),
                  fontSize: rSP(14),
                ),
              ),
              SizedBox(height: rSize(2)),
              Text(
                '2小时前',
                style: TextStyle(
                  color: Color(0xFF999999),
                  fontSize: rSP(12),
                ),
              ),
              SizedBox(height: rSize(20)),
            ],
          ),
        ),
      ],
    );
  }
}
