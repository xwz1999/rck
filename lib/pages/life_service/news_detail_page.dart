import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/models/life_service/news_detail_model.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/recook_back_button.dart';

///成语接龙
class NewsDetailPage extends StatefulWidget {
  final NewsDetailModel newsDetailModel;

  NewsDetailPage({
    Key? key,
    required this.newsDetailModel,
  }) : super(key: key);

  @override
  _NewsDetailPageState createState() => _NewsDetailPageState();
}

class _NewsDetailPageState extends State<NewsDetailPage>
    with TickerProviderStateMixin {
  late NewsDetailModel newsDetailModel;

  @override
  void initState() {
    super.initState();
    newsDetailModel = widget.newsDetailModel;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: false,
      extendBody: true,
      appBar: CustomAppBar(
        appBackground: Colors.white,
        leading: RecookBackButton(
          white: false,
        ),
        elevation: 0,
        title: Text('新闻详情',
            style: TextStyle(
              color: Color(0xFF333333),
              fontWeight: FontWeight.bold,
              fontSize: 17.rsp,
            )),
      ),
      body: ListView(

        children: [
          Padding(
            padding:  EdgeInsets.symmetric(horizontal: 12.rw),
            child: Row(
              children: [
                Expanded(
                    child: Text(
                      newsDetailModel.detail!.title ?? '' ,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 22.rsp,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333333)),
                    )),
              ],
            ),
          ),
          5.hb,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.rw),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(newsDetailModel.detail!.authorName ?? '',
                    style: TextStyle(
                      color: Color(0xFF999999),
                      fontSize: 12.rsp,
                    )),
                16.wb,
                Padding(
                  padding: EdgeInsets.only(top: 3.rw),
                  child: Text(newsDetailModel.detail!.date ?? '',
                      style: TextStyle(
                        color: Color(0xFF999999),
                        fontSize: 12.rsp,
                      )),
                ),
              ],
            ),
          ),
          20.hb,
          _htmlWidget(),
        ],
      )

    );
  }

  _htmlWidget() {
    return Padding(
      padding: EdgeInsets.only(left: 12.rw,right: 12.rw,bottom: 24.rw),
      child: HtmlWidget(
        newsDetailModel.content ?? '',
        textStyle: TextStyle(color: Color(0xFF333333)),
      ),
    );
  }
}
