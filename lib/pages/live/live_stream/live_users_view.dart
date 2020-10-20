import 'package:flutter/material.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:tencent_im_plugin/entity/group_member_entity.dart';

class LiveUsersView extends StatefulWidget {
  final List<GroupMemberEntity> members;
  final List<String> usersId;
  LiveUsersView({Key key, @required this.members, @required this.usersId})
      : super(key: key);

  @override
  _LiveUsersViewState createState() => _LiveUsersViewState();
}

class _LiveUsersViewState extends State<LiveUsersView> {
  List<dynamic> users;

  @override
  void initState() {
    super.initState();
    HttpManager.post(
      LiveAPI.getLiveUsers,
      {'identifiers': widget.usersId},
    ).then((resultData) {
      setState(() {
        users = (resultData?.data['data'] as List).map((e) {
          return {
            'name': e['identifier'],
            'fans': e['fans'],
            'follow': e['isFollow'],
          };
        }).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      minChildSize: 0.5,
      maxChildSize: 0.9,
      builder: (context, controller) {
        return Material(
          color: Colors.black.withOpacity(0.55),
          borderRadius: BorderRadius.vertical(top: Radius.circular(rSize(15))),
          child: users == null
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(rSize(15)),
                      child: Text(
                        '在线观众',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: rSP(16),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        controller: controller,
                        itemBuilder: (BuildContext context, int index) {
                          final fans = users[index]['fans'];
                          return Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: rSize(15),
                              vertical: rSize(15 / 2),
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(rSize(34 / 2)),
                                  child: FadeInImage.assetNetwork(
                                    placeholder:
                                        R.ASSETS_PLACEHOLDER_NEW_1X1_A_PNG,
                                    image: Api.getImgUrl(widget
                                        .members[index].userProfile.faceUrl),
                                    width: rSize(34),
                                    height: rSize(34),
                                  ),
                                ),
                                rWBox(10),
                                Text(
                                  '${widget.members[index].userProfile.nickName}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: rSP(14),
                                  ),
                                ),
                                rWBox(10),
                                Text(
                                  '粉丝数$fans',
                                  style: TextStyle(
                                    color: Color(0xFFEEEEEE),
                                    fontSize: rSP(12),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        itemCount: users.length,
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}
