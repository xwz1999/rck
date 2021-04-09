import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:extended_image/extended_image.dart';

import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/models/goods_detail_model.dart';
import 'package:recook/pages/home/classify/commodity_detail_page.dart';
import 'package:recook/pages/home/classify/mvp/goods_detail_model_impl.dart';
import 'package:recook/pages/home/home_page.dart';
import 'package:recook/utils/custom_route.dart';
import 'package:recook/utils/rui_code_util.dart';
import 'package:recook/utils/user_level_tool.dart';
import 'package:recook/widgets/toast.dart';

class RUICodeListener {
  final BuildContext context;
  RUICodeListener(this.context);
  Future<GoodsDetailModel> _getDetail(int goodsId) async {
    GoodsDetailModel _goodsDetail = await GoodsDetailModelImpl.getDetailInfo(
        goodsId, UserManager.instance.user.info.id);
    if (_goodsDetail.code != HttpStatus.SUCCESS) {
      Toast.showError(_goodsDetail.msg);
      return null;
    }
    return _goodsDetail;
  }

  Future<ResultData> _getUserInfo(int id) async {
    return await HttpManager.post(UserApi.userInfo, {'userId': id});
  }

  clipboardListener() async {
    String rawData =
        (await Clipboard.getData(Clipboard.kTextPlain))?.text ?? '';
    bool isRUICode = RUICodeUtil.isCode(rawData);
    GoodsDetailModel goodsDetailModel;

    //瑞口令
    if (isRUICode && ClipboardListenerValue.canListen) {
      RUICodeModel model = RUICodeUtil.decrypt(rawData);

      goodsDetailModel = await _getDetail(model.goodsId);
      //user info
      String userImg = '';
      String userName = '';
      ResultData resultData = await _getUserInfo(model.userId);
      if (resultData.data != null && resultData.data['data'] != null) {
        userImg = resultData.data['data']['headImgUrl'];
        userName = resultData.data['data']['nickname'];
      }
      if (goodsDetailModel != null &&
          userName != UserManager.instance.user.info.nickname)
        showDialog(
          context: context,
          builder: (context) => _RUICodeDialog(
            userName: userName,
            userImg: userImg,
            model: goodsDetailModel,
          ),
        );

      if (userName != UserManager.instance.user.info.nickname)
        Clipboard.setData(ClipboardData(text: ''));
    }
  }
}

class _RUICodeDialog extends StatefulWidget {
  final String userImg;
  final String userName;
  final GoodsDetailModel model;
  _RUICodeDialog({Key key, this.userImg, this.userName, this.model})
      : super(key: key);

  @override
  __RUICodeDialogState createState() => __RUICodeDialogState();
}

class __RUICodeDialogState extends State<_RUICodeDialog> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Material(
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(rSize(9)),
              ),
              margin: EdgeInsets.symmetric(horizontal: rSize(50)),
              padding: EdgeInsets.all(rSize(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Material(
                        clipBehavior: Clip.antiAlias,
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(rSize(17)),
                        child: ExtendedImage.network(
                          Api.getImgUrl(widget.userImg),
                          height: rSize(34),
                          width: rSize(34),
                          fit: BoxFit.cover,
                        ),
                      ),
                      rWBox(8),
                      Expanded(
                        child: Text(
                          widget.userName ?? '',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: rSP(14),
                          ),
                        ),
                      ),
                    ],
                  ),
                  rHBox(4),
                  Text(
                    '给你分享了商品',
                    style: TextStyle(
                      color: Color(0xFF666666),
                      fontSize: rSP(12),
                    ),
                  ),
                  rHBox(4),
                  Material(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(rSize(8)),
                    child: ExtendedImage.network(
                      Api.getImgUrl(
                        widget.model.data.mainPhotos.first.url,
                      ),
                      height: rSize(256),
                      fit: BoxFit.cover,
                    ),
                  ),
                  rHBox(10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        '¥',
                        style: TextStyle(
                          color: Color(0xFFE13327),
                          fontSize: rSP(14),
                        ),
                      ),
                      Text(
                        '${widget.model.data.price.max.discountPrice.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Color(0xFFE13327),
                          fontSize: rSP(18),
                        ),
                      ),
                      !(UserLevelTool.currentRoleLevelEnum() ==
                                  UserRoleLevel.Vip ||
                              UserLevelTool.currentRoleLevelEnum() ==
                                  UserRoleLevel.None)
                          ? Text(
                              '/赚${widget.model.data.price.max.commission.toStringAsFixed(1)}',
                              style: TextStyle(
                                color: Color(0xFFE13327),
                                fontSize: rSP(10),
                              ),
                            )
                          : SizedBox(),
                    ],
                  ),
                  rHBox(4),
                  Text(
                    widget.model.data.goodsName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(),
                  ),
                  Center(
                    child: MaterialButton(
                      elevation: 0,
                      shape: StadiumBorder(),
                      onPressed: () {
                        CRoute.pushReplace(
                            context,
                            CommodityDetailPage(
                              arguments: CommodityDetailPage.setArguments(
                                widget.model.data.id,
                              ),
                            ));
                      },
                      height: rSize(36),
                      minWidth: rSize(235),
                      padding: EdgeInsets.zero,
                      color: Color(0xFFDB2D2D),
                      child: Text(
                        '查看详情',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          rHBox(30),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Material(
              color: Colors.transparent,
              child: Icon(
                CupertinoIcons.clear_circled,
                size: rSize(40),
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
