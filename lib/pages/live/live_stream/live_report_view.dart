import 'dart:io';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:oktoast/oktoast.dart';

import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/models/media_model.dart';
import 'package:recook/pages/live/models/live_report_model.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/progress/re_toast.dart';

class LiveReportView extends StatefulWidget {
  LiveReportView({Key key}) : super(key: key);

  @override
  _LiveReportViewState createState() => _LiveReportViewState();
}

class _LiveReportViewState extends State<LiveReportView> {
  int type = 1;
  List<LiveReportModel> models;
  File _imageFile;
  TextEditingController _textController = TextEditingController();
  @override
  void initState() {
    HttpManager.post(LiveAPI.reportType, {}).then((resultData) {
      if (resultData?.data['data'] != null) {
        setState(() {
          models = (resultData?.data['data'] as List)
              .map((e) => LiveReportModel.fromJson(e))
              .toList();
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _textController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(builder: (context, controller) {
      return Material(
        color: Colors.black,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(rSize(10)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(10),
                controller: controller,
                children: [
                  Text(
                    '请选择举报类型',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: rSP(20),
                    ),
                  ),
                  models == null
                      ? Center(child: CircularProgressIndicator())
                      : Wrap(
                          children: models
                              .map((e) => Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Radio<int>(
                                        value: e.id,
                                        groupValue: type,
                                        onChanged: (value) {
                                          setState(() {
                                            type = value;
                                          });
                                        },
                                      ),
                                      Text(
                                        e.name,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: rSP(14),
                                        ),
                                      ),
                                    ],
                                  ))
                              .toList(),
                        ),
                  TextField(
                    controller: _textController,
                    maxLength: 255,
                    maxLines: 10,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                  CustomImageButton(
                    onPressed: () {
                      ImagePicker.pickImage(source: ImageSource.gallery)
                          .then((value) {
                        if (value != null) {
                          setState(() {
                            _imageFile = value;
                          });
                        }
                      });
                    },
                    child: _imageFile == null
                        ? Image.asset(
                            R.ASSETS_PLACEHOLDER_NEW_1X1_A_PNG,
                            height: rSize(100),
                            width: rSize(100),
                          )
                        : Image.file(
                            _imageFile,
                            height: rSize(100),
                          ),
                  ),
                ],
              ),
            ),
            MaterialButton(
              onPressed: () async {
                if (_imageFile == null) {
                  showToast('图片不能为空');
                  return;
                }
                final loadingCancel = ReToast.loading(text: '上传图片中');
                UploadResult uploadResult = await HttpManager.uploadFile(
                  url: CommonApi.upload,
                  file: _imageFile,
                  key: "photo",
                );
                loadingCancel();
                final reportLoadingCancel = ReToast.loading(text: '举报中');
                ResultData resultData = await HttpManager.post(LiveAPI.report, {
                  "type": type,
                  'content': _textController.text,
                  'imgUrl': uploadResult.url,
                });
                reportLoadingCancel();
                showToast(resultData.data['msg']);
                Navigator.pop(context);
              },
              color: Colors.red,
              child: Text('举报'),
            ),
          ],
        ),
      );
    });
  }
}
