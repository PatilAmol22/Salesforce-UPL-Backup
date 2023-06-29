public class SideBar_User {
@AuraEnabled
    public static Boolean getUserType(){
        Boolean isLogInUser;
        String userType = UserInfo.getUserType();
        System.debug(userType);
    if(userType!= 'guest'){
        System.debug('True');
        isLogInUser = true;
    }else{
        isLogInUser = false;
    }
        return isLogInUser;
    }
}