import 'package:flutter/material.dart';
import 'package:jingyaoyun/base/base_store_state.dart';
import 'package:jingyaoyun/constants/api.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/constants/styles.dart';
import 'package:jingyaoyun/manager/http_manager.dart';
import 'package:jingyaoyun/models/after_sales_log_list_model.dart';
import 'package:jingyaoyun/utils/text_parse_util.dart';
import 'package:jingyaoyun/widgets/custom_app_bar.dart';
import 'package:jingyaoyun/widgets/toast.dart';
import 'package:timeline_tile/timeline_tile.dart';

enum AfterSalesRichTextType { black, gray, address, none }

class AfterSalesRichTextModel {
  final String richText;
  String normalText;
  final AfterSalesRichTextType type;
  final int start;
  final int end;
  AfterSalesRichTextModel({this.richText, this.type, this.start, this.end});
  getNormalText() {
    if (type == AfterSalesRichTextType.none) return this.richText;
    return this.richText.replaceAll(RegExp("<[^>]+>"), "");
  }
}

class AfterSalesLogPage extends StatefulWidget {
  final Map arguments;
  AfterSalesLogPage({Key key, this.arguments}) : super(key: key);

  static setArguments(int id) {
    return {'id': id};
  }

  @override
  _AfterSalesLogPageState createState() => _AfterSalesLogPageState();
}

class _AfterSalesLogPageState extends BaseStoreState<AfterSalesLogPage> {
  AfterSalesLogListModel _afterSalesLogListModel;
  @override
  void initState() {
    super.initState();
    _getOrderDetail();
  }

  @override
  Widget buildContext(BuildContext context, {store}) {
    return Scaffold(
        appBar: CustomAppBar(
          title: "进度明细",
          themeData: AppThemes.themeDataGrey.appBarTheme,
          background: Colors.white,
          appBackground: Colors.white,
          elevation: 0,
        ),
        body: _afterSalesLogListModel == null ? loadingView() : _bodyWidget());
  }

  _bodyWidget() {
    return Container(
      child: ListView.builder(
        padding:
            EdgeInsets.symmetric(horizontal: rSize(20), vertical: 20 * 2.h),
        itemCount: _afterSalesLogListModel.data.length,
        itemBuilder: (BuildContext context, int index) {
          AfterSalesLogModel afterSalesLogModel =
              _afterSalesLogListModel.data[index];
          return _buildTimelineTile(
            isFirst: index == 0,
            isLast: index == _afterSalesLogListModel.data.length - 1,
            title: afterSalesLogModel.title,
            // subInfo: ExtendedText.rich(TextSpan(
            //   children: _getRichTextWidget(afterSalesLogModel.content),
            // )),
            subInfo: DefaultTextStyle(
              style: TextStyle(
                fontSize: 14 * 2.sp,
                color: Color(0xFF666666),
              ),
              child: TextParseUtil.parseRefundText(afterSalesLogModel.content),
            ),
            // subInfo: _getRichTextWidget(afterSalesLogModel.content),
            time: afterSalesLogModel.ctime,
            line: afterSalesLogModel.content.split('|').length,
          );
        },
      ),
    );
  }

  TimelineTile _buildTimelineTile({
    String time = "",
    String title,
    dynamic subInfo,
    bool isLast = false,
    bool isFirst = false,
    int line = 0,
  }) {
    GlobalKey globalKey = GlobalKey();
    return TimelineTile(
      isFirst: isFirst,
      alignment: TimelineAlign.manual,
      lineX: 0,
      topLineStyle: LineStyle(color: Color(0xffe5e5e5), width: 2),
      hasIndicator: true,
      indicatorStyle: IndicatorStyle(
          padding: EdgeInsets.zero,
          color: isFirst ? AppColor.redColor : Color(0xffe5e5e5),
          indicatorY: 0.0,
          drawGap: false,
          width: rSize(8),
          height: rSize(8)),
      isLast: isLast,
      rightChild: Transform.translate(
        offset: Offset(0, -10),
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 10, bottom: 10),
          child: Column(
            key: globalKey,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 14 * 2.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    time,
                    style: TextStyle(
                      color: Color(0xff999999),
                      fontSize: 12 * 2.sp,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 4),
              subInfo != null && subInfo is String
                  ? Text(subInfo,
                      maxLines: 10,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Color(0xff666666), fontSize: 14 * 2.sp))
                  : subInfo != null && subInfo is Widget
                      ? subInfo
                      : Container()
            ],
          ),
        ),
      ),
    );
  }

  _getOrderDetail() async {
    ResultData resultData =
        await HttpManager.post(OrderApi.order_after_sales_log, {
      'asGoodsId': widget.arguments['id'],
    });
    if (!resultData.result) {
      Toast.showError(resultData.msg);
      return;
    }
    AfterSalesLogListModel model =
        AfterSalesLogListModel.fromJson(resultData.data);
    if (model.code != HttpStatus.SUCCESS) {
      Toast.showError(model.msg);
      return;
    }
    setState(() {
      _afterSalesLogListModel = model;
    });
  }

  _getSubInfoChildren(String text) {
    if (text.contains('|')) {
      return text.split('|').map((e) => Text(e)).toList();
    } else {
      return Text(text);
    }
  }

  _getRichTextWidget(String text) {
    // text = "退款金额 <black>¥169</black> 将原路退回至您的<black>付款账户</black>，请及时关注到账情况。<gray>若3天内未收到退款/瑞币，请联系客服咨询。</gray> <gray>gray</gray>  <address>寄回地址：浙江省宁波市海曙区翠柏路宁波工程学院翠柏校区 左家右厨 13888888888</address>";
    // text = text.replaceAll("|", "\n");
    List<AfterSalesRichTextModel> richTextList = [];

    // RegExp reg = RegExp("<[^>]+>(.*?)<[^>]+>");
    // RegExp reg = RegExp("(?<=<black>)(.*?)(?=</black>)");
    // RegExp reg = RegExp("(<black>)(.*?)(</black>)");
    // black
    richTextList.addAll(_regTextList("(<black>)(.*?)(</black>)", text,
        type: AfterSalesRichTextType.black));
    richTextList.addAll(_regTextList("(<gray>)(.*?)(</gray>)", text,
        type: AfterSalesRichTextType.gray));
    richTextList.addAll(_regTextList("(<address>)(.*?)(</address>)", text,
        type: AfterSalesRichTextType.address));
    List normalTextList = text.split(RegExp("<[^>]+>(.*?)<[^>]+>"));
    for (String normalText in normalTextList) {
      int index = text.indexOf(normalText);
      richTextList.add(AfterSalesRichTextModel(
        type: AfterSalesRichTextType.none,
        richText: normalText,
        start: index,
        end: index + normalText.length - 1,
      ));
    }
    richTextList.sort((left, right) => left.start.compareTo(right.start));
    // richtext list
    List<InlineSpan> textSpanList = [];
    TextStyle normalStyle =
        TextStyle(color: Color(0xff333333), fontSize: 14 * 2.sp);
    TextStyle blackStyle = TextStyle(color: Colors.black, fontSize: 14 * 2.sp);
    TextStyle grayStyle =
        TextStyle(color: Color(0xff999999), fontSize: 14 * 2.sp);
    TextStyle addressStyle =
        TextStyle(color: Color(0xff666666), fontSize: 14 * 2.sp);
    for (AfterSalesRichTextModel textModel in richTextList) {
      print("--- " + textModel.getNormalText());
      if (textModel.type == AfterSalesRichTextType.none) {
        textSpanList
            .add(TextSpan(text: textModel.getNormalText(), style: normalStyle));
      }
      if (textModel.type == AfterSalesRichTextType.black) {
        textSpanList
            .add(TextSpan(text: textModel.getNormalText(), style: blackStyle));
      }
      if (textModel.type == AfterSalesRichTextType.address) {
        textSpanList.add(
            TextSpan(text: textModel.getNormalText(), style: addressStyle));
      }
      if (textModel.type == AfterSalesRichTextType.gray) {
        textSpanList.add(WidgetSpan(
            child: Container(
          decoration: BoxDecoration(
              color: Color(0xfff8f8f8), borderRadius: BorderRadius.circular(4)),
          child: Text(textModel.getNormalText(), style: grayStyle),
          padding:
              EdgeInsets.symmetric(horizontal: rSize(8), vertical: 8 * 2.h),
        )));
      }
    }
    return textSpanList;
  }

  _regTextList(String regExp, String text,
      {AfterSalesRichTextType type = AfterSalesRichTextType.none}) {
    if (TextUtils.isEmpty(regExp)) return [];
    List<AfterSalesRichTextModel> richTextList = [];
    RegExp reg = RegExp(regExp);
    for (RegExpMatch item in reg.allMatches(text)) {
      richTextList.add(AfterSalesRichTextModel(
          richText: text.substring(item.start, item.end),
          type: type,
          start: item.start,
          end: item.end));
    }
    return richTextList;
  }
}
