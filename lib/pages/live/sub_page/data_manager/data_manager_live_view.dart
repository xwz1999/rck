import 'package:flutter/material.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/pages/live/sub_page/data_manager/single_data_manager_live_page.dart';
import 'package:recook/utils/custom_route.dart';

class DatamanagerLiveView extends StatefulWidget {
  DatamanagerLiveView({Key key}) : super(key: key);

  @override
  _DatamanagerLiveViewState createState() => _DatamanagerLiveViewState();
}

class _DatamanagerLiveViewState extends State<DatamanagerLiveView> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(rSize(15)),
      itemBuilder: (contet, index) {
        return _buildListColumn('今天');
      },
      itemCount: 10,
    );
  }

  _buildListColumn(String date) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          date,
          style: TextStyle(
            color: Color(0xFF666666),
            fontSize: rSP(14),
          ),
        ),
        SizedBox(height: rSize(10)),
      ]..add(_buildDataColumn()),
    );
  }

  _buildDataColumn() {
    return MaterialButton(
      elevation: 0,
      color: Colors.white,
      onPressed: () {
        CRoute.push(context, SingleDataManagerPage());
      },
      padding: EdgeInsets.all(rSize(10)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(rSize(10)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '09:12场',
                  style: TextStyle(
                    color: Color(0xFF333333),
                    fontSize: rSP(16),
                  ),
                ),
                SizedBox(height: rSize(6)),
                Text(
                  '直播时间 09:02 - 10:30',
                  style: TextStyle(
                    color: Color(0xFF333333).withOpacity(0.5),
                    fontSize: rSP(12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
