@isTest
public class ClonedOpeningInventorySchedulerTest {
 static testmethod void  testschedule(){
        Sales_Org__c salorg = new Sales_Org__c();
         salorg.name = 'Indo1';
         salorg.Sales_Org_Code__c = '6451';
         insert salorg;
        
         Sales_Org__c salorg2 = new Sales_Org__c();
         salorg2.name = 'Indo2';
         salorg2.Sales_Org_Code__c = '6410';
         insert salorg2;
        
        Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        RecordType rt = [SELECT Id,Name FROM RecordType WHERE SobjectType='Liquidation_Annual_Plan__c' and Name='Multi Country'];
        Account a1 = new Account();
        a1.Name = 'Test';
        a1.RecordTypeId = RecordTypeId;
        a1.SAP_Code__c = '12346';
        insert a1;
        
        Account a2 = new Account();
        a2.Name = 'Test2';
        a2.RecordTypeId = RecordTypeId;
        a2.SAP_Code__c = '12345';
        insert a2;
        
        Liquidation_Annual_Plan__c liqannlPln = new Liquidation_Annual_Plan__c();
                  liqannlPln.Fiscal_Start_Date__c = Date.newInstance(2020, 04, 01);
                  liqannlPln.FIscal_Year__c = '2020-2021';                   
                  liqannlPln.Fiscal_End_Date__c = Date.newInstance(2021,31, 03);  
                  liqannlPln.Distributor__c = a1.Id;
                  liqannlPln.Multi_Country_Key__c =  a1.SAP_Code__c+'2020'+'-'+'2021'+'6451';
                  liqannlPln.SentToBatch__c = false;                      
                  liqannlPln.Sales_Org__c=salorg.id;
                  liqannlPln.RecordTypeId=rt.Id;                 
         insert liqannlPln;
        
        Liquidation_Annual_Plan__c liqannlPln2 = new Liquidation_Annual_Plan__c();
                  liqannlPln2.Fiscal_Start_Date__c = Date.newInstance(2020, 04, 01);
                  liqannlPln2.FIscal_Year__c = '2020-2021';                   
                  liqannlPln2.Fiscal_End_Date__c = Date.newInstance(2021,31, 03);  
                  liqannlPln2.Distributor__c = a2.Id;
                  liqannlPln2.Multi_Country_Key__c =  a1.SAP_Code__c+'2020'+'-'+'2021'+'6410';
                  liqannlPln2.SentToBatch__c = false;                      
                  liqannlPln2.Sales_Org__c=salorg2.id;
                  liqannlPln2.RecordTypeId=rt.Id;  
                
         insert liqannlPln2;
        
        Liquidation_Batch_Filters__c lbf1 = new Liquidation_Batch_Filters__c();
        lbf1.Name = 'Indonesia';
        lbf1.Sales_Org_Filter__c = 'Sales_Org_Code__c = \'6451\'';
        lbf1.Account_Type_Filter__c ='AccountType__c = \'Sold To Party\'';
        lbf1.Active__c = true;
        insert lbf1;
        
         ClonedOpeningInventoryScheduler sh1 = new ClonedOpeningInventoryScheduler();      
         String sch = '0  00 1 3 * ?';
           system.schedule('Test', sch, sh1);
    }
}