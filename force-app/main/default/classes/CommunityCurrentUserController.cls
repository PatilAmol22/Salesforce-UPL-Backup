public without sharing class CommunityCurrentUserController {
	@AuraEnabled 
    public static user fetchUser(){
       User u = [select id,Name,Country from User where id =: userInfo.getUserId()];
        return u;
    }
}