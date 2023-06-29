@isTest 
public class ActivityRedirectControllerTest {
    public static TestMethod void validateHelloWorld() {

        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();

        Account acc = new Account();
        acc.Name='Nikhil';
        acc.Last_Name__c='Dhoke';
        acc.SAP_Code__c='SAP996734';
        acc.RecordTypeId=devRecordTypeId;
        acc.Mobile__c='8600687971';
        acc.Phone='020266589';
        acc.BillingCity='Mumbai';
        acc.Depot_Code__c = 'MUM';
        acc.Account_Type__c = 'Sold To Party';
        //  acc.OwnerId=sobj.Id;
        insert acc;

        contact con = new Contact();
         con.AccountId=acc.Id;
         con.LastName=acc.Last_Name__c;
         insert con;


        Profile p = [SELECT Id,name FROM Profile WHERE Name = 'PartnerCommunity Distributor Profile'];
         userrole  usrole = new userrole();
        usrole.Name ='Customer User';
        
        User sobj1 = new User();
        sobj1.ProfileId  = p.ID;  
        sobj1.UserRoleId=usrole.id; 
        sobj1.ContactId=con.Id;
        sobj1.Alias = 'zonaa';                                                            
        sobj1.Email = 'test@skinternational.com';                             
        sobj1.Username = 'test@upl122333.com.devbox';                                    
        sobj1.IsActive = true;  
        sobj1.LastName='Terriotory Manager';
        sobj1.CommunityNickname = 'zonalExe1222 Di'; 
        sobj1.TimeZoneSidKey = 'Asia/Kolkata'; 
        // sobj1.Contact.AccountID = acc.id;// Time Zone
        sobj1.LocaleSidKey = 'en_IN';                                    
        sobj1.LanguageLocaleKey = 'en_US';                                             
        sobj1.ForecastEnabled = false;                                                     
        sobj1.EmailEncodingKey = 'ISO-8859-1';    
        sobj1.Show_Inventory__c = false;                                                     
        sobj1.Show_Credit_Limit__c = false; 
        insert sobj1;

        Test.startTest();
        Test.setCurrentPage(Page.ActivityRedirectPage);
        ApexPages.CurrentPage().getparameters().put('id',acc.id);
       
        ApexPages.StandardController controller = new ApexPages.StandardController(acc);
       // ApexPages.CurrentPage().getParameters().put('recordId',wayToGo.id);
       ActivityRedirectController ext = new ActivityRedirectController(controller);
        Test.stopTest();
    }
}