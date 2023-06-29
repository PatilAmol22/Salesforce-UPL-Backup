public with sharing class Grz_PricesDiscounts {
    @AuraEnabled(cacheable=true)
    public static Account getAccInfo(){
        Id id;
        if(Test.isRunningTest()){
            Profile pro = [SELECT Id FROM Profile WHERE Name = 'India Partner Community Distributor Profile'];
            User user = [SELECT Id, Username, AccountId, ContactId FROM User WHERE ProfileId =: pro.Id AND lastname = 'Testing' and Email ='test@grazitti.com' LIMIT 1];
            id = user.Id;
        }
        else{
            id = UserInfo.getUserId();// getting current user info
        }
        System.debug('id'+id);
        List<User> user = [SELECT Id, Username, AccountId, ContactId, profile.name FROM User where Id =: id];
        String accountId = user[0].AccountId;
        system.debug('accountId'+accountId);
        Account acc=[Select Id, Price_List_Type__r.Zone__r.Name, Price_List_Type__r.Zone__r.ZoneCode__c, Price_List_Type__r.SBU__r.Name, PriceGroupCode__r.PG_Code__c from Account where id =:accountId];
        return acc;
    }
   
    
}