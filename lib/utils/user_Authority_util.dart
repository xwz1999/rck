import 'package:jingyaoyun/manager/user_manager.dart';
import 'package:jingyaoyun/widgets/toast.dart';

class UserAuthorityUtil{

  hasLogin(){
    if (UserManager.instance.haveLogin) {// 登录了就渲染用户界面
      return true;
    }else{
      return false;
    }
  }

  showToast(String title,){
    Toast.showError(title);
  }

  showNeedLoginToast(){
    if (!hasLogin()) {
      showToast('游客没有权限,请先登录...');
      return true;
    }else{
      return false;
    }
  }



}
