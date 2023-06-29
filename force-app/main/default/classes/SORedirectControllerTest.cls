@isTest
public class SORedirectControllerTest {
    public static TestMethod void validateHelloWorld() {
        Event eventToInsert = new Event();
               
         Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
      
         Sales_Org__c sorg =new Sales_Org__c();
         sorg.Name='6610';
         sorg.Description__c='Vietnam';
         sorg.Sales_Org_Code__c='6610';
         insert sorg;
        
         Distribution_Channel__c disbj = new Distribution_Channel__c();
         disbj.Name = '10';                      
         disbj.Distribution_Channel_Code__c = '10';  
         disbj.Description__c='test';
         insert disbj;
         
         Division__c Divbj = new Division__c();
         Divbj.Name = '10';         
         Divbj.Description__c = null;    
         Divbj.Division_Code__c = '10'; 
         insert Divbj;

         Customer_Group__c cg = new Customer_Group__c(
            Name = 'B2B',                  // Customer Group Name
            Customer_Group_Code__c = '75',   // Customer Group Code
            Customer_Group_Desc__c = 'B2B'  // Customer Group Desc.
            );
         insert cg;

         Login_Country__c lg = new Login_Country__c(
            Name = 'Vietnam',                  // Customer Group Name
            For_Contry__c = 'Vietnam'
            );
         insert lg;

         Login_Country__c lg2 = new Login_Country__c(
            Name = 'India',                  // Customer Group Name
            For_Contry__c = 'India'
            );
         insert lg2;

         Account acc = new Account();
         acc.Name='Nikhil';
         acc.Last_Name__c='Dhoke';
         acc.SAP_Code__c='SAP996734';
         acc.RecordTypeId=devRecordTypeId;
         acc.Mobile__c='8600687971';
         acc.Phone='020266589';
         acc.Sales_Org__c=sorg.Id;
         acc.Division__c=Divbj.Id;
         acc.Distribution_Channel__c=disbj.Id;
         acc.BillingCity='Mumbai';
         acc.Depot_Code__c = 'MUM';
         acc.Account_Type__c = 'Sold To Party';
         acc.Customer_Grp__c = cg.id;
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
        sobj1.Country = 'Vietnam';
        insert sobj1;

        SORedirectController.getLoginUserDetails();

         
                               
     }
}