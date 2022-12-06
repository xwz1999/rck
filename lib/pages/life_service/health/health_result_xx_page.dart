import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/recook_back_button.dart';
class HealthResultXXPage extends StatefulWidget {
  final String pType;
  final String mType;
  final String remark;

  const HealthResultXXPage(
      {Key? key, required this.pType,required this.mType,required this.remark
})
      : super(key: key);

  @override
  _HealthResultXXPageState createState() => _HealthResultXXPageState();
}

class _HealthResultXXPageState extends State<HealthResultXXPage> {

  String may = '';
  String noMay = '';
  @override
  void initState() {
    super.initState();
    may = widget.remark.split('可能为：')[1].split('型')[0];
    noMay = widget.remark.split('不可能为')[1].split('型')[0];
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
        themeData: AppThemes.themeDataGrey.appBarTheme,
        leading: RecookBackButton(
          white: false,
        ),
        elevation: 0,
        title: Text('基础健康指数计算器',
            style: TextStyle(
              color: Color(0xFF333333),
              fontWeight: FontWeight.bold,
              fontSize: 17.rsp,
            )),
      ),
      body: _bodyWidget(),
    );
  }

  _bodyWidget() {
    return  Column(
      children: [
        Container(
          margin: EdgeInsets.all(12.rw),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.rw),
              border:
                  Border.all(color: Color(0xFFE8E8E8), width: 0.5.rw)),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [


              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      padding: EdgeInsets.all(20.rw),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('血型可能为',
                              style: TextStyle(
                                color: Color(0xFF999999),
                                fontSize: 12.rsp,
                              )),
                          10.hb,
                          Text(may,
                              style: TextStyle(
                                color: Color(0xFFDB2D2D),
                                fontWeight: FontWeight.bold,
                                fontSize: 26.rsp,
                              )),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: 0.5.rw,
                    height: 110.rw,
                    color: Color(0xFFE8E8E8),
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      padding: EdgeInsets.all(20.rw),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('血型不可能为',
                              style: TextStyle(
                                color: Color(0xFF999999),
                                fontSize: 12.rsp,
                              )),
                          10.hb,
                          Text(noMay,
                              style: TextStyle(
                                color: Color(0xFF333333),
                                fontWeight: FontWeight.bold,
                                fontSize: 26.rsp,
                              )),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Container(
                width: double.infinity,
                height: 0.5.rw,
                color: Color(0xFFE8E8E8),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      padding: EdgeInsets.all(20.rw),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('父亲血型',
                              style: TextStyle(
                                color: Color(0xFF999999),
                                fontSize: 12.rsp,
                              )),
                          10.hb,
                          Text(widget.pType,
                              style: TextStyle(
                                color: Color(0xFF333333),
                                fontWeight: FontWeight.bold,
                                fontSize: 16.rsp,
                              )),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: 0.5.rw,
                    height: 110.rw,
                    color: Color(0xFFE8E8E8),
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      padding: EdgeInsets.all(20.rw),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('母亲血型',
                              style: TextStyle(
                                color: Color(0xFF999999),
                                fontSize: 12.rsp,
                              )),
                          10.hb,
                          Text(widget.mType,
                              style: TextStyle(
                                color: Color(0xFFDB2D2D),
                                fontWeight: FontWeight.bold,
                                fontSize: 16.rsp,
                              )),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
  

}
