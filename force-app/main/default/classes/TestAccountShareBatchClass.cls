@isTest
public class TestAccountShareBatchClass {
    
    public static testMethod void testBatch() {
        Sales_Org__c s=new Sales_Org__c();
        s.Sales_Org_Code__c='1210';
        insert s;
        Account acc = new Account();
        acc.Name='Test Account';
        acc.Last_Name__c='SKI';
        acc.SAP_Code__c='SAP996734';
        acc.Mobile__c='9967341759';
        acc.Phone='020256589';
        acc.Sales_Org__c=s.id;
        acc.BillingCity='Pune';
        acc.Depot_Code__c = 'PUN1';
        //  acc.OwnerId=sobj.Id;
        insert acc;
        
        String systemAdminProfile = [SELECT Id,name FROM Profile WHERE Name = 'System Administrator'].Id;
        
        //inserting first test userrecord.
        User sobj1 = new User();
        sobj1.Alias = 'zonaa';                                                            
        sobj1.Email = 'test@yopmail.com';                             
        sobj1.ProfileId  = systemAdminProfile;                                                     
        sobj1.Username = 'zonal_aaexe1232@upl122333.com.devbox';                                    
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
        
        //inserting second test userrecord.
        User sobj2 = new User();
        sobj2.Alias = 'zonaa';                                                            
        sobj2.Email = 'test1@yopmail.com';                             
        sobj2.ProfileId  = systemAdminProfile;                                                     
        sobj2.Username = 'zonal11_aaexe1232@upl122333.com.devbox';                                    
        sobj2.IsActive = true;  
        sobj2.LastName='Terriotorys Manager';
        sobj2.CommunityNickname = 'zonalExe12222 Di'; 
        sobj2.TimeZoneSidKey = 'Asia/Kolkata'; 
        // sobj1.Contact.AccountID = acc.id;// Time Zone
        sobj2.LocaleSidKey = 'en_IN';                                    
        sobj2.LanguageLocaleKey = 'en_US';                                             
        sobj2.ForecastEnabled = false;                                                     
        sobj2.EmailEncodingKey = 'ISO-8859-1';    
        sobj2.Show_Inventory__c = false;                                                     
        sobj2.Show_Credit_Limit__c = false;        
        insert sobj2;
        
        //inserting SalesArea test record and updating the Account.
        DistributorSalesAreaMapping__c salesArea = new DistributorSalesAreaMapping__c();
        salesArea.AccountOwner__c = sobj1.id;
        salesArea.Distributor__c = acc.id;
        insert salesArea;
        acc.name='abc';
        update acc;
        
        Test.StartTest();
            System.runAs(sobj1){
                AccountModifiedBatchClass obj = new AccountModifiedBatchClass();
                ID batchprocessid = Database.executeBatch(obj );
              
                
                SchedulableAccountShare sh1 = new SchedulableAccountShare();
                String sch = '0 0 2 * * ?'; 
                system.schedule('Test Territory Check', sch, sh1); 
                
               /* ScheduanleAccountModifiedShare sh21 = new ScheduanleAccountModifiedShare();
                String sch2 = '0 0 2 * * ?'; 
                system.schedule('Test Territory Check1', sch2, sh21); */
            }                
        Test.stopTest();
    }
}