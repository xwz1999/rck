/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019-08-29  16:22 
 * remark    : 
 * ====================================================
 */

import 'package:flutter/material.dart';

import 'package:async/async.dart';

import 'package:jingyaoyun/base/base_store_state.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/manager/http_manager.dart';
import 'package:jingyaoyun/manager/user_manager.dart';
import 'package:jingyaoyun/models/base_model.dart';
import 'package:jingyaoyun/models/media_model.dart';
import 'package:jingyaoyun/pages/user/items/item_evaluation.dart';
import 'package:jingyaoyun/pages/user/mvp/order_list_presenter_impl.dart';
import 'package:jingyaoyun/widgets/custom_app_bar.dart';
import 'package:jingyaoyun/widgets/custom_image_button.dart';

class EvaluationGoodsModel {
  int id;
  String goodsName;
  String mainPhotoUrl;

  EvaluationGoodsModel({this.id, this.goodsName, this.mainPhotoUrl});
}

class EvaluationModel {
  EvaluationGoodsModel goods;
  String content;
  List<MediaModel> imageFiles;

  EvaluationModel({this.goods, this.content = "", this.imageFiles}) {
    imageFiles = [];
  }
}

class CreateMaterialPage extends StatefulWidget {
  final Map arguments;

  const CreateMaterialPage({Key key, this.arguments}) : super(key: key);

  static setArguments({int orderId, List<EvaluationGoodsModel> goodsList}) {
    return {"orderId": orderId, "goodsList": goodsList};
  }

  @override
  State<StatefulWidget> createState() {
    return _CreateMaterialPageState();
  }
}

class _CreateMaterialPageState extends BaseStoreState<CreateMaterialPage> {
  OrderListPresenterImpl _presenter;
  List<EvaluationModel> _evaluations;
  List<EvaluationGoodsModel> _goodsList;
  int _orderId;

  @override
  void initState() {
    super.initState();
    _presenter = OrderListPresenterImpl();
    _evaluations = [];
    _goodsList = widget.arguments["goodsList"];
    _orderId = widget.arguments["orderId"];

    _goodsList.forEach((goods) {
      EvaluationModel evaluationModel = EvaluationModel(goods: goods);
      _evaluations.add(evaluationModel);
    });
  }

  @override
  Widget buildContext(BuildContext context, {store}) {
    return _buildContainer();
  }

  Widget _buildContainer() {
    return Scaffold(
      appBar: CustomAppBar(
        title: "发表评价",
        themeData: AppThemes.themeDataGrey.appBarTheme,
        actions: <Widget>[
          CustomImageButton(
            padding: EdgeInsets.only(top: rSize(8), right: rSize(10)),
            title: "发布",
            style: AppTextStyle.generate(15 * 2.sp),
            onPressed: () {
              _publish();
            },
          )
        ],
      ),
      body: ListView.builder(
          itemCount: _evaluations.length,
          itemBuilder: (_, index) {
            return EvaluationItem(
              maxSelectImage: 6,
              // evaluationModel: _evaluations[index],
            );
          }),
    );
  }

  _publish() async {
    showLoading("");
    await _uploadImages();
    Map<String, dynamic> totalParams = {
      "userId": UserManager.instance.user.info.id,
      "orderId": _orderId
    };
    List<Map<String, dynamic>> evaluations = [];
    for (EvaluationModel evaluation in _evaluations) {
      if (TextUtils.isEmpty(evaluation.content) &&
          evaluation.imageFiles.length == 0) continue;
      Map<String, dynamic> params = {
        "goodsID": evaluation.goods.id,
        "content": evaluation.content
      };
      List<Map<String, dynamic>> images = [];
      for (MediaModel media in evaluation.imageFiles) {
        if (TextUtils.isEmpty(media.result.url)) {
          showError(
              "第${_evaluations.indexOf(evaluation)}条评论的第${evaluation.imageFiles.indexOf(media) + 1}图片${media.result.msg}");
          return;
        }
        images.add({
          "path": media.result.url,
          "width": media.width,
          "height": media.height
        });
        params.addAll({"images": images});
      }
      evaluations.add(params);
    }
    totalParams.addAll({"evaluations": evaluations});

    HttpResultModel<BaseModel> resultModel =
        await _presenter.publishEvaluation(totalParams);
    if (!resultModel.result) {
      showError(resultModel.msg);
      return;
    }

    showSuccess("评价成功").then((value) {
      pop();
    });
  }

  _uploadImages() async {
    FutureGroup group = FutureGroup();
    for (EvaluationModel model in _evaluations) {
      group.add(HttpManager.uploadFiles(medias: model.imageFiles));
    }
    group.close();
    return group.future;
  }
}
