public class CurrentUserInfo {
    @AuraEnabled
    public static Contact getUserInfo(){
        id userId = UserInfo.getUserId();
        System.debug(userId);
        User u;        
        u = [select id, contactId from User where id = : userId];        
        id getContactId = u.contactId;
        System.debug(getContactId);
		Contact c = [select id, Name, Account.Name, Account.Mobile__c from Contact where id = : getContactId];
        System.debug(c);
    	return c;
		
    }
    
}