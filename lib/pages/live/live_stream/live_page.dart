import 'package:flutter/material.dart';
import 'package:tencent_live_fluttify/tencent_live_fluttify.dart';

class LivePage extends StatefulWidget {
  LivePage({Key key}) : super(key: key);

  @override
  _LivePageState createState() => _LivePageState();
}

class _LivePageState extends State<LivePage> {
  LivePusher _livePusher;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _livePusher?.stopPreview();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Stack(
        children: [
          CloudVideo(
            onCloudVideoCreated: (controller) async {
              _livePusher = await LivePusher.create();
              _livePusher.startPreview(controller);
            },
          ),
          Positioned(
            right: 0,
            top: 0,
            child: FlatButton(
              onPressed: () {
                _livePusher.switchCamera();
              },
              child: Text('test'),
            ),
          ),
        ],
      ),
    );
  }
}
