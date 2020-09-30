import 'package:flutter/material.dart';
import 'package:recook/constants/header.dart';

class DataManagerAllView extends StatefulWidget {
  DataManagerAllView({Key key}) : super(key: key);

  @override
  _DataManagerAllViewState createState() => _DataManagerAllViewState();
}

class _DataManagerAllViewState extends State<DataManagerAllView>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  List<String> titles = [
    '收获点赞',
    '观众人数',
    '新增粉丝',
    '购买人数',
    '销售金额',
    '预计收入',
  ];
  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      vsync: this,
      length: 6,
      initialIndex: 0,
    );
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(rSize(15)),
      children: [
        Row(
          children: [
            PopupMenuButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(rSize(8)),
              ),
              color: Colors.white,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '近7天数据',
                    style: TextStyle(
                      color: Color(0xFF333333),
                      fontSize: rSP(16),
                    ),
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                    color: Color(0xFFDB2D2D),
                  ),
                ],
              ),
              initialValue: 'test',
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                      child: Text(
                    '近7天数据',
                    style: TextStyle(
                      color: Color(0xFF333333),
                      fontSize: rSP(16),
                    ),
                  )),
                ];
              },
            ),
          ],
        ),
        SizedBox(height: rSize(10)),
        Text(
          '累计开播7场，共14小时',
          style: TextStyle(
            color: Color(0xFF666666),
            fontSize: rSP(14),
          ),
        ),
        SizedBox(height: rSize(15)),
        ClipRRect(
          borderRadius: BorderRadius.circular(rSize(10)),
          child: Container(
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildChildBox('收获点赞', '3.7万', 0),
                    _vDivider(),
                    _buildChildBox('观众人数', '1114', 1),
                    _vDivider(),
                    _buildChildBox('新增粉丝', '434', 2),
                  ],
                ),
                Divider(
                  color: Color(0xFFEEEEEE),
                  height: rSize(0.5),
                  thickness: rSize(0.5),
                  indent: rSize(10),
                  endIndent: rSize(10),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildChildBox('购买人数', '3.7万', 3),
                    _vDivider(),
                    _buildChildBox('销售金额', '1114', 4),
                    _vDivider(),
                    _buildChildBox('预计收入', '434', 5),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: rSize(15)),
        AspectRatio(
          aspectRatio: 345 / 231,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(rSize(10)),
            ),
            child: TabBarView(
              controller: _tabController,
              children: titles.map((e) => _buildDataView(e)).toList(),
            ),
          ),
        ),
      ],
    );
  }

  _vDivider() {
    return Container(
      color: Color(0xFFEEEEEE),
      width: rSize(0.5),
      height: rSize(100),
    );
  }

  _buildChildBox(String title, String subTitle, int index) {
    return Expanded(
      child: AspectRatio(
        aspectRatio: 1,
        child: MaterialButton(
          elevation: 0,
          color:
              _tabController.index == index ? Color(0xFFEB4F4F) : Colors.white,
          onPressed: () {
            _tabController.animateTo(index);
            setState(() {});
          },
          padding: EdgeInsets.zero,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: _tabController.index == index
                      ? Colors.white.withOpacity(0.7)
                      : Color(0xFF333333).withOpacity(0.7),
                  fontSize: rSP(14),
                ),
              ),
              SizedBox(height: rSize(12)),
              Text(
                subTitle,
                style: TextStyle(
                  color: _tabController.index == index
                      ? Colors.white
                      : Color(0xFF333333),
                  fontSize: rSP(16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDataView(String title) {
    return Padding(
      padding: EdgeInsets.all(rSize(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Color(0xFF333333),
              fontSize: rSP(14),
              fontWeight: FontWeight.bold,
            ),
          ),
          Divider(
            height: rSize(21),
            thickness: rSize(1),
            color: Color(0xFFEEEEEE),
          ),
        ],
      ),
    );
  }
}
