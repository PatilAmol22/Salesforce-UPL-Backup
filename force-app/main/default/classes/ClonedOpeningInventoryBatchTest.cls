@isTest
public class ClonedOpeningInventoryBatchTest {
    static testmethod void  testBatch(){
        Sales_Org__c salorg = new Sales_Org__c();
        salorg.name = 'Indo1';
        salorg.Sales_Org_Code__c = '6451';
        insert salorg;
        
        Sales_Org__c salorg2 = new Sales_Org__c();
        salorg2.name = 'Indo2';
        salorg2.Sales_Org_Code__c = '6410';
        insert salorg2;
        
        Sales_Org__c mexicoSalesorg = new Sales_Org__c();
        mexicoSalesorg.name = 'Mexico';
        mexicoSalesorg.Sales_Org_Code__c = '5100';
        insert mexicoSalesorg;
        
        SKU__c s1 = new SKU__c();
        s1.Active_for_Liquidation__c = true;
        s1.SKU_Code__c = '123';
        s1.Sales_Org__c = salorg.Id;
        insert s1;
        
        SKU__c s2 = new SKU__c();
        s2.Active_for_Liquidation__c = true;
        s2.SKU_Code__c = '1234';
        s2.Sales_Org__c = salorg2.Id;
        insert s2;
            
        SKU__c s3 = new SKU__c();
        s3.Active_for_Liquidation__c = true;
        s3.SKU_Code__c = '12345';
        s3.Sales_Org__c = mexicoSalesorg.Id;
        insert s3;
        
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
        liqannlPln.Fiscal_Start_Date__c = Date.newInstance(2023, 04, 01);
        liqannlPln.FIscal_Year__c = '2023-2024';                   
        liqannlPln.Fiscal_End_Date__c = Date.newInstance(2024,31, 03);  
        liqannlPln.Distributor__c = a1.Id;
        liqannlPln.Multi_Country_Key__c =  a1.SAP_Code__c+'2023'+'-'+'2024'+'6451';
        liqannlPln.SentToBatch__c = false;                      
        liqannlPln.Sales_Org__c=salorg.id;
        liqannlPln.RecordTypeId=rt.Id;                 
        insert liqannlPln;
        
        Liquidation_Annual_Plan__c liqannlPln2 = new Liquidation_Annual_Plan__c();
        liqannlPln2.Fiscal_Start_Date__c = Date.newInstance(2023, 04, 01);
        liqannlPln2.FIscal_Year__c = '2023-2024';                   
        liqannlPln2.Fiscal_End_Date__c = Date.newInstance(2024,31, 03);  
        liqannlPln2.Distributor__c = a2.Id;
        liqannlPln2.Multi_Country_Key__c =  a1.SAP_Code__c+'2023'+'-'+'2024'+'6410';
        liqannlPln2.SentToBatch__c = false;                      
        liqannlPln2.Sales_Org__c=salorg2.id;
        liqannlPln2.RecordTypeId=rt.Id;                 
        insert liqannlPln2;
        
        Liquidation_Annual_Plan__c liqannlPln3 = new Liquidation_Annual_Plan__c();
        liqannlPln3.Fiscal_Start_Date__c = Date.newInstance(2023, 04, 01);
        liqannlPln3.FIscal_Year__c = '2023-2024';                   
        liqannlPln3.Fiscal_End_Date__c = Date.newInstance(2024,31, 03);  
        liqannlPln3.Distributor__c = a2.Id;
        liqannlPln3.Multi_Country_Key__c =  a1.SAP_Code__c+'2023'+'-'+'2024'+'6410';
        liqannlPln3.SentToBatch__c = false;                      
        liqannlPln3.Sales_Org__c=mexicoSalesorg.id;
        liqannlPln3.RecordTypeId=rt.Id;                 
        insert liqannlPln3;
        
        Liquidation_Batch_Filters__c lbf1 = new Liquidation_Batch_Filters__c();
        lbf1.Name = 'Indonesia';
        lbf1.Sales_Org_Filter__c = 'Sales_Org_Code__c = \'6451\'';
        lbf1.Account_Type_Filter__c ='AccountType__c = \'Sold To Party\'';
        lbf1.Active__c = true;
        insert lbf1;
        
        string query = 'SELECT Name,Id,Sales_Org__c,Ship_To_Party__c,SentToBatch__c,FIscal_Year__c,Distributor__c,Fiscal_Start_Date__c,Fiscal_End_Date__c,Multi_Country_Key__c FROM Liquidation_Annual_Plan__c WHERE SentToBatch__c = false Limit 1'; 
        ClonedMultiCountryOpeningInventoryBatch  batchObj = new ClonedMultiCountryOpeningInventoryBatch(query);
        DataBase.executeBatch(batchObj,1);
    }
}