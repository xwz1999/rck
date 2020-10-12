import 'package:flutter/material.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/pages/live/models/live_stream_info_model.dart'
    show GoodsLists;

class GoodsListDialog extends StatefulWidget {
  final List<GoodsLists> models;
  GoodsListDialog({Key key, @required this.models}) : super(key: key);

  @override
  _GoodsListDialogState createState() => _GoodsListDialogState();
}

class _GoodsListDialogState extends State<GoodsListDialog> {
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      minChildSize: 0.5,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Material(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(rSize(15)),
            ),
          ),
          child: ListView.separated(
            controller: scrollController,
            itemBuilder: (context, index) {
              return _buildGoodsCard(widget.models[index], index);
            },
            separatorBuilder: (context, index) {
              return Divider(
                height: rSize(0.5),
                thickness: rSize(0.5),
                color: Color(0xFFEEEEEE),
                indent: rSize(15),
                endIndent: rSize(15),
              );
            },
            itemCount: widget.models.length,
          ),
        );
      },
    );
  }

  _buildGoodsCard(GoodsLists model, int index) {
    return Container(
      padding: EdgeInsets.all(rSize(15)),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(rSize(4)),
            child: Stack(
              children: [
                FadeInImage.assetNetwork(
                  placeholder: R.ASSETS_PLACEHOLDER_NEW_1X1_A_PNG,
                  image: Api.getImgUrl(model.mainPhotoUrl),
                  height: rSize(104),
                  width: rSize(104),
                ),
                Positioned(
                  left: 0,
                  top: 0,
                  child: Container(
                    height: rSize(14),
                    width: rSize(28),
                    alignment: Alignment.center,
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: rSP(10),
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xFF959C9F),
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(rSize(4)),
                      ),
                    ),
                  ),
                ),
                model.isExplain == 1
                    ? Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          alignment: Alignment.center,
                          height: rSize(22),
                          child: Text(
                            '讲解中',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: rSP(12),
                            ),
                          ),
                          color: Color(0xFFDB2D2D).withOpacity(0.8),
                        ),
                      )
                    : SizedBox(),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [Text(model.goodsName)],
            ),
          ),
        ],
      ),
    );
  }
}

showGoodsListDialog(
  BuildContext context, {
  @required List<GoodsLists> models,
}) {
  showGeneralDialog(
    context: context,
    pageBuilder: (context, animation, secondaryAnimation) {
      return Align(
        alignment: Alignment.bottomCenter,
        child: GoodsListDialog(models: models),
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return Transform.translate(
        offset: Offset(
            0, (1 - Curves.easeInOutCubic.transform(animation.value)) * 500),
        child: child,
      );
    },
    barrierColor: Colors.black26,
    barrierLabel: 'label',
    barrierDismissible: true,
    transitionDuration: Duration(milliseconds: 500),
  );
}
