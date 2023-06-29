@isTest 
public class Utility_Test{
    
 public static testMethod void UserCreatetest(){
 
    Profile pr = new Profile(name = 'UPL Call Expert');
            Profile prof = [select id from profile where name='UPL Call Expert'];
           
            
           User usr = new User(LastName = 'Krishnan',
                               FirstName='Sujin1',
                               Alias = 'Sujin',
                               Email = 'abc@sfdc1.com',
                               Username = 'sujinkrishnnan29081993111231@sfdc.com',
                               ProfileId = prof.id,
                               TimeZoneSidKey = 'GMT',
                               LanguageLocaleKey = 'en_US',
                               EmailEncodingKey = 'UTF-8',
                               LocaleSidKey = 'en_US'
                               ); 
           
           system.runAs(usr){
           
            Sales_Org__c SO = new Sales_Org__c();
            so.name = 'TestFin';
            so.Sales_Org_Code__c = '1000';
            insert SO;
            
            Product2 p = new product2();
           //P.RecordTypeId= Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Non-US').getRecordTypeId();
            p.name = 'testproduct';
            P.Sales_Org__c = SO.ID;
            p.Combination_Key__c = '123';
           // p.Sales_Org_Code__c = 1000;
            
            insert p;
           // Product2 prc=[select id,name,Sales_Org_Code__c,recordtype.name from Product2 where id=:p.id];
            
           // system.assert(false,''+prc);
            
            Promotional_Product__c pp = new Promotional_Product__c();
            pp.Name = 'Testabc';
            pp.Product_Name__c = p.id;
            pp.Current_Month__c = TRUE;
            pp.Month__c = 'Jan';
            pp.Financial_Year__c = '2020';
            insert pp;
            
            Promotional_Product__c pp1 = new Promotional_Product__c();
            pp1.Name = 'Testabc1';
            pp1.Product_Name__c = p.id;
            pp1.Current_Month__c = TRUE;
            pp1.Month__c = 'Jan';
            pp1.Financial_Year__c = '2020';
            insert pp1;
        }
     }
 }