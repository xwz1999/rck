import 'package:flutter_test/flutter_test.dart';

import 'package:recook/pages/user/model/user_benefit_month_detail_model.dart';

class UserBenefitModelsTest {
  static runTest() {
    test('test userBenefit', () {
      UserBenefitMonthDetailModel userBenefitModel =
          UserBenefitMonthDetailModel.fromJson({
        "id": 2,
        "userId": 6,
        "day": 20201201, // 年月日
        "purchaseAmount": 0, // 自购收益
        "purchaseCount": 0, // 自购单数
        "purchaseSalesVolume": 0, // 自购销售额
        "guideAmount": 0, // 导购收益
        "guideCount": 0, // 导购单数
        "guideSalesVolume": 0 // 导购销售额
      });
      expect(userBenefitModel.day, DateTime(2020, 12, 1));
      expect(userBenefitModel.id, 2);
      expect(userBenefitModel.userId, 6);
      expect(userBenefitModel.purchaseAmount, 0);
      expect(userBenefitModel.purchaseCount, 0);
      expect(userBenefitModel.purchaseSalesVolume, 0);
      expect(userBenefitModel.guideAmount, 0);
      expect(userBenefitModel.guideCount, 0);
      expect(userBenefitModel.guideSalesVolume, 0);
    });
  }
}
