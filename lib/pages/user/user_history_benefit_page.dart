import 'package:flutter/material.dart';
import 'package:recook/widgets/recook/recook_scaffold.dart';

class UserHistoryBenefitPage extends StatefulWidget {
  UserHistoryBenefitPage({Key key}) : super(key: key);

  @override
  _UserHistoryBenefitPageState createState() => _UserHistoryBenefitPageState();
}

class _UserHistoryBenefitPageState extends State<UserHistoryBenefitPage> {
  @override
  Widget build(BuildContext context) {
    return RecookScaffold(title: '累计总收益');
  }
}
