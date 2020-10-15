import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/pages/live/models/live_data_list_model.dart';
import 'package:recook/pages/live/sub_page/data_manager/single_data_manager_live_page.dart';
import 'package:recook/utils/custom_route.dart';
import 'package:recook/utils/date/recook_date_util.dart';
import 'package:recook/widgets/refresh_widget.dart';

class DatamanagerLiveView extends StatefulWidget {
  DatamanagerLiveView({Key key}) : super(key: key);

  @override
  _DatamanagerLiveViewState createState() => _DatamanagerLiveViewState();
}

class _DatamanagerLiveViewState extends State<DatamanagerLiveView>
    with AutomaticKeepAliveClientMixin {
  int _page = 1;
  List<LiveDataListModel> _dataModels = [];
  GSRefreshController _controller = GSRefreshController();
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 500), () {
      if (mounted) _controller.requestRefresh();
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshWidget(
      controller: _controller,
      onRefresh: () {
        getLiveListDataModels().then((models) {
          setState(() {
            _dataModels = models;
          });
          _controller.refreshCompleted();
        });
      },
      body: ListView.builder(
        padding: EdgeInsets.all(rSize(15)),
        itemBuilder: (contet, index) {
          return _buildListColumn(_dataModels, index);
        },
        itemCount: _dataModels.length,
      ),
    );
  }

  _buildListColumn(List<LiveDataListModel> models, int index) {
    final date =
        DateTime.fromMillisecondsSinceEpoch(models[index].startAt * 1000);
    final endDate =
        DateTime.fromMillisecondsSinceEpoch(models[index].endAt * 1000);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Builder(
          builder: (context) {
            if (index == 0)
              return Text(
                RecookDateUtil(date).prefixDay,
                style: TextStyle(
                  color: Color(0xFF666666),
                  fontSize: rSP(14),
                ),
              );
            final beforeDate = DateTime.fromMillisecondsSinceEpoch(
                models[index - 1].startAt * 1000);
            if (beforeDate.year == date.year &&
                beforeDate.month == date.month &&
                beforeDate.day == date.day) {
              return SizedBox();
            } else
              return Text(
                RecookDateUtil(date).prefixDay,
                style: TextStyle(
                  color: Color(0xFF666666),
                  fontSize: rSP(14),
                ),
              );
          },
        ),
        SizedBox(height: rSize(10)),
        MaterialButton(
          elevation: 0,
          color: Colors.white,
          onPressed: () {
            CRoute.push(
                context,
                SingleDataManagerPage(
                  id: models[index].id,
                ));
          },
          padding: EdgeInsets.all(rSize(10)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(rSize(10)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${DateUtil.formatDate(
                        date,
                        format: 'HH:mm',
                      )}场',
                      style: TextStyle(
                        color: Color(0xFF333333),
                        fontSize: rSP(16),
                      ),
                    ),
                    SizedBox(height: rSize(6)),
                    Text(
                      '直播时间 ${DateUtil.formatDate(
                        date,
                        format: 'HH:mm',
                      )} - ${DateUtil.formatDate(
                        endDate,
                        format: 'HH:mm',
                      )}',
                      style: TextStyle(
                        color: Color(0xFF333333).withOpacity(0.5),
                        fontSize: rSP(12),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: rSize(13),
                color: Color(0xFF999999),
              ),
            ],
          ),
        )
      ],
    );
  }

  Future<List<LiveDataListModel>> getLiveListDataModels() async {
    ResultData resultData = await HttpManager.post(LiveAPI.liveDataList, {
      'page': _page,
      'limit': 15,
    });
    if (resultData?.data['data'] == null)
      return [];
    else
      return (resultData?.data['data'] as List)
          .map((e) => LiveDataListModel.fromJson(e))
          .toList();
  }

  @override
  bool get wantKeepAlive => true;
}
