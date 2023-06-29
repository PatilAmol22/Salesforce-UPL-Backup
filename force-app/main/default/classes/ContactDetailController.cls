public without sharing class ContactDetailController {
	@AuraEnabled
    public static ContactInfo getDetail(){
        id userId = UserInfo.getUserId();
        System.debug(userId);
        User u=new User();        
        u = [select id, contactId, AccountId,Country from User where id = : userId];
        id AccountId=u.AccountId;
        AccountTeamMember atm =new AccountTeamMember();
        Account a=new Account();
        ContactInfo ci=new ContactInfo();
        if(u.Country=='Colombia'){
            //atm=[SELECT Id, AccountId, User.Name, User.Email, User.MobilePhone FROM AccountTeamMember where AccountId=: AccountId Order By LastModifiedDate Desc limit 1];
        	ci.Name='Servicio al Cliente UPL';
        	ci.Email='centrodenegocios.colombia@upl-ltd.com';
        	ci.MobilePhone='01 8000 096 1048';
        }else{
            a=[select id, OwnerId, Owner.name, Owner.email, Owner.MobilePhone from Account where id = : AccountId];
            System.debug('OwnerId=='+a.OwnerId);
        	ci.Name=a.Owner.Name;
        	ci.Email=a.Owner.Email;
        	ci.MobilePhone=a.Owner.MobilePhone;
        }     
        return ci;
    }
    public class ContactInfo{
        @AuraEnabled public String Name{get;set;}
        @AuraEnabled public String Email{get;set;} 
        @AuraEnabled public String MobilePhone{get;set;} 
        public ContactInfo(){
            Name='';
            Email='';
            MobilePhone='';
        }
    }     
}