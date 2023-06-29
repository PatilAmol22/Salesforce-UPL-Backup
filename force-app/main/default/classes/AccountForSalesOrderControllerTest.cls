@isTest 
public class AccountForSalesOrderControllerTest {
    public static TestMethod void validateHelloWorld() {
        Event eventToInsert = new Event();
               
         Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
      
         Sales_Org__c sorg =new Sales_Org__c();
         sorg.Name='6610';
         sorg.Description__c='Vietnam';
         sorg.Sales_Org_Code__c='6610';
         insert sorg;
        
         Sales_Org__c sorg1 =new Sales_Org__c();
         sorg1.Name='Poland';
         sorg1.Description__c='Poland';
         sorg1.Sales_Org_Code__c='2941';
         insert sorg1;
        
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

         Account acc2 = new Account();
         acc2.Name='Nik';
         acc2.Last_Name__c='D';
         acc2.SAP_Code__c='SAP996735';
         acc2.RecordTypeId=devRecordTypeId;
         acc2.Mobile__c='8600687972';
         acc2.Phone='020266590';
         acc2.Sales_Org__c=sorg.Id;
         acc2.Division__c=Divbj.Id;
         acc2.Distribution_Channel__c=disbj.Id;
         acc2.BillingCity='Mumbai';
         acc2.Depot_Code__c = 'MUM';
         acc2.Account_Type__c = 'Sold To Party';
         acc2.Customer_Grp__c = cg.id;
         insert acc2;

         contact con = new Contact();
         con.AccountId=acc.Id;
         con.LastName=acc.Last_Name__c;
         insert con;

         contact con2 = new Contact();
         con2.AccountId=acc2.Id;
         con2.LastName=acc2.Last_Name__c;
         insert con2;

         Profile p = [SELECT Id,name FROM Profile WHERE Name = 'PartnerCommunity Distributor Profile'];
         userrole  usrole = new userrole();
        usrole.Name ='Customer User';
        
        Profile p1 = [SELECT Id,name FROM Profile WHERE Name = 'Poland(Key Account Manager)'];
        userrole  usrole1 = new userrole();
        usrole1.Name ='Key Account Manager(North-East)';
        
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

        User sobj2 = new User();
        sobj2.ProfileId  = p.ID;  
        sobj2.UserRoleId=usrole.id; 
        sobj2.ContactId=con2.Id;
        sobj2.Alias = 'zonaa2';                                                            
        sobj2.Email = 'test2@skinternational.com';                             
        sobj2.Username = 'test2@upl122333.com.devbox';                                    
        sobj2.IsActive = true;  
        sobj2.LastName='Terriotory Manager';
        sobj2.CommunityNickname = 'zonalExe1222 Di2'; 
        sobj2.TimeZoneSidKey = 'Asia/Kolkata'; 
        // sobj2.Contact.AccountID = acc.id;// Time Zone
        sobj2.LocaleSidKey = 'en_IN';                                    
        sobj2.LanguageLocaleKey = 'en_US';                                             
        sobj2.ForecastEnabled = false;                                                     
        sobj2.EmailEncodingKey = 'ISO-8859-1';    
        sobj2.Show_Inventory__c = false;                                                     
        sobj2.Show_Credit_Limit__c = false; 
        sobj2.Country = 'Spain';
        insert sobj2;
        
        User sobj3 = new User();
        sobj3.ProfileId  = p1.ID;  
        sobj3.UserRoleId=usrole1.id;
        sobj3.Alias = 'zonaa2';                                                            
        sobj3.Email = 'test6@skinternational.com';                             
        sobj3.Username = 'test2@upl12233345.com.devbox';                                    
        sobj3.IsActive = true;  
        sobj3.LastName='Terriotory Manager';
        sobj3.TimeZoneSidKey = 'Asia/Kolkata'; 
        // sobj2.Contact.AccountID = acc.id;// Time Zone
        sobj3.LocaleSidKey = 'en_IN';                                    
        sobj3.LanguageLocaleKey = 'en_US';                                             
        sobj3.ForecastEnabled = false;                                                     
        sobj3.EmailEncodingKey = 'ISO-8859-1';    
        sobj3.Show_Inventory__c = false;                                                     
        sobj3.Show_Credit_Limit__c = false; 
        sobj3.Country = 'Poland';
        insert sobj3;
         
         AccountsForSalesOrderController.getLoginUserDetails(sobj1.id);
         
         AccountsForSalesOrderController.getAccountList(sobj1.id);

         AccountsForSalesOrderController.getAccountList(sobj2.id);
        
        AccountsForSalesOrderController.getAccountList(sobj3.id);

         
                               
     }
}