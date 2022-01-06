import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jingyaoyun/base/base_store_state.dart';
import 'package:jingyaoyun/constants/styles.dart';
import 'package:jingyaoyun/widgets/custom_app_bar.dart';

class TextPage extends StatefulWidget {
  final Map arguments;
  static setArguments({String title = "",AppBarTheme appBarTheme, String info = ""}){
    if (appBarTheme == null) {
      appBarTheme = AppThemes.themeDataGrey.appBarTheme;
    }
    return {
      "appBarTheme": appBarTheme,
      "title": title,
      "info": info};
  }
  
  TextPage({Key key, this.arguments}) : super(key: key);
  
  @override
  _TextPageState createState() => _TextPageState();
}

class _TextPageState extends BaseStoreState<TextPage> {
  @override
  Widget buildContext(BuildContext context, {store}) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.arguments["title"],
        elevation: 0,
        appBackground:  Colors.white,
        themeData: widget.arguments["appBarTheme"],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              color: AppColor.frenchColor,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Text(widget.arguments["info"], style: TextStyle(color:Colors.black, fontSize: 16),),
                ),
              ),
            )
          )
        ],
      )
    );
  }

}
