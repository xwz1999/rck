import 'package:flutter/material.dart';
import 'package:recook/constants/constants.dart';
import 'package:recook/widgets/recook/recook_scaffold.dart';

class ConsumerNotificationPage extends StatelessWidget {
  const ConsumerNotificationPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RecookScaffold(
      title: '消费者告知书',
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          rSize(16),
          rSize(10),
          rSize(16),
          rSize(40),
        ),
        child: Text(
          '''为方便您更好的选购瑞库客跨境商品，请仔细阅读并理解以下告知书的内容：

1、消费者在瑞库客购买的跨境商品依据原产地或原销售地有关质量、安全、卫生、环保、标识等标准或技术规范要求生产和销售，可能与我国标准存在差异，消费者应自行承担相关风险。

2、相关商品直接购自境外，可能无中文标签。消费者可以通过网站查看商品中文电子标签。

3、商品的购买人或收件人将被记录为进口方，必须遵守中国的法律法规。

4、消费者购买的商品仅限个人自用，不得进行二次销售。

5、消费者现委托商家及其代理人或跨境电商平台企业、物流商、支付机构办理申报、代缴税款、代理购汇等通关事宜，并承诺提供（或通过授权的第三方提供）真实、准确及有效的身份信息（如姓名、身份证影印件）供商家及其代理人、跨境电商平台企业、物流商、支付机构依法办理实名审核、商品清关、购汇手续。''',
          style: TextStyle(
            color: Color(0xFF666666),
            fontSize: rSP(10),
          ),
        ),
      ),
    );
  }
}
