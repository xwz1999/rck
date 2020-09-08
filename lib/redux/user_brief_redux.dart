
import 'package:recook/models/user_brief_info_model.dart';
import 'package:redux/redux.dart';


final UserBriefReducer = combineReducers<UserBrief>([
  TypedReducer<UserBrief, UpdateUserBriefAction>(updateUserBriefInfo)
]);

UserBrief updateUserBriefInfo(UserBrief userBrief, action) {
  userBrief = action.userInfo;
  return userBrief;
}

class UpdateUserBriefAction{
  final UserBrief userInfo;
  UpdateUserBriefAction(this.userInfo);
}
