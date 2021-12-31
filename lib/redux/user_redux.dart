import 'package:redux/redux.dart';

import 'package:jingyaoyun/models/user_model.dart';

final UserReducer = combineReducers<User>([
  TypedReducer<User, UpdateUserAction>(updateUserInfo)
]);

User updateUserInfo(User user, action) {
  user = action.userInfo;
  return user;
}

class UpdateUserAction{
  final User userInfo;
  UpdateUserAction(this.userInfo);
}
