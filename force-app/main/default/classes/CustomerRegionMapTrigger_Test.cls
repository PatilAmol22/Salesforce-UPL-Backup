/*
@Developer Name: Ketan Khatri
@Description: To unit test the Customer Region Mapping Trigger
*/
@isTest
public class CustomerRegionMapTrigger_Test {
 @isTest
    static void test1(){
        
        Id devRecordTypeIdAcc = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId(); 
        
        Price_Group_Master__c pg = new Price_Group_Master__c ();
        pg.PG_Code__c='03';
        insert Pg;
        
       /* Auto_Number__c auto = new Auto_Number__c();
        auto.Name='FarmerCode';
        auto.Sequence__c='11';
        insert auto;*/
        
        Account acc = new Account();
        acc.Name='Bhavik Devdhar';
        acc.Last_Name__c='Devdhar';
        acc.PriceGroupCode__c=pg.id;
        acc.SAP_Code__c='SAP996734';
        acc.RecordTypeId=devRecordTypeIdAcc;
        acc.Mobile__c='9967341759';
        acc.Phone='020256589';
        insert acc;
        
        Sales_Org__c sorg =new Sales_Org__c();
        sorg.Name='Brazil';
        sorg.Description__c='Brazil';
        sorg.Sales_Org_Code__c='5191';
        insert sorg;
        
        Distribution_Channel__c disObj = new Distribution_Channel__c();
        disObj.Name = '20';                      
        disObj.Distribution_Channel_Code__c = '20';  
        disObj.Description__c='test';
        insert disObj;
        
        Division__c DivObj = new Division__c();
        DivObj.Name = '10';         
        DivObj.Description__c = null;    
        DivObj.Division_Code__c = '10'; 
        insert DivObj;
        
         		userrole  usrole = new userrole();
        usrole.Name ='Customer User';
        
        Profile p = [SELECT Id,name FROM Profile WHERE Name = 'Brazil Customer Service User'];
        
        User sobj1 = new User();
        sobj1.Alias = 'zonaa';                                                            
        sobj1.Email = 'himanshua.mehta@skinternational.com';                             
        sobj1.ProfileId  = p.ID;                                                     
        sobj1.Username = 'zonal_aaexe1232@upl122333.com.devbox';                                    
        sobj1.IsActive = true;  
        sobj1.LastName='Terriotory Manager';
        sobj1.CommunityNickname = 'zonalExe1222 Di'; 
        sobj1.TimeZoneSidKey = 'America/Sao_Paulo'; 
        // sobj1.Contact.AccountID = acc.id;// Time Zone
        sobj1.LocaleSidKey = 'en_IN';                                    
        sobj1.LanguageLocaleKey = 'en_US';                                             
        sobj1.ForecastEnabled = false;                                                     
        sobj1.EmailEncodingKey = 'ISO-8859-1';    
        sobj1.Show_Inventory__c = false;                                                     
        sobj1.Show_Credit_Limit__c = false; 
        sobj1.UserRoleId=usrole.id;
        //sobj1.ContactId=con.Id;
        insert sobj1;
        
        Territory_Distributor__c tr1 = new Territory_Distributor__c();
        tr1.Name = 'BR1009149';
        tr1.SalesOrg__c = sorg.Id;
        tr1.TerritoryManager__c = sobj1.Id;
        insert tr1;
        
        Territory_Distributor__c tr2 = new Territory_Distributor__c();
        tr2.Name = 'BR1009149';
        tr2.SalesOrg__c = sorg.Id;
        insert tr2;
        
        Customer_and_Region_Mapping__c crmObj =  new Customer_and_Region_Mapping__c();
        crmObj.Customer_Name__c = acc.Id;
        crmObj.Sales_Org__c =sorg.Id;   
        crmObj.Division__c = DivObj.Id;
        crmObj.Distribution_Channel__c = disObj.Id;
       // crmObj.CombinationKey__c = '0001048345141';
        crmObj.CustomerRegion__c =tr1.Id;
       // crmObj.Active__c = true;
        insert crmObj;
        
        delete crmObj;
        
    }
}