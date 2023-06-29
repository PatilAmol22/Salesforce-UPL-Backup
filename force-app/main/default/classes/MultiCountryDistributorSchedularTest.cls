@isTest
public class MultiCountryDistributorSchedularTest {
    
   @testSetup static void makeData(){
        Sales_Org__c salorg = new Sales_Org__c();
        salorg.name = 'Indo1';
        salorg.Sales_Org_Code__c = '6451';
        insert salorg;
        
        Sales_Org__c salorg2 = new Sales_Org__c();
        salorg2.name = 'Indo2';
        salorg2.Sales_Org_Code__c = '6410';
        insert salorg2;
        
        Sales_Org__c salorg3 = new Sales_Org__c();
        salorg3.name = 'Mexico';
        salorg3.Sales_Org_Code__c = '5100';
        insert salorg3;
       
       	Sales_Org__c salorg4 = new Sales_Org__c();
        salorg4.name = 'Poland';
        salorg4.Sales_Org_Code__c = '2941';
        insert salorg4;
        
        Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        Account a1 = new Account();
        a1.Name = 'Test';
        a1.RecordTypeId = RecordTypeId;
        a1.SAP_Code__c = '12346';
        a1.Active_For_Liquidation__c = true;
        insert a1;
        
        Account a2 = new Account();
        a2.Name = 'Test2';
        a2.RecordTypeId = RecordTypeId;
        a2.SAP_Code__c = '12345';
        a2.Active_For_Liquidation__c = true;
        insert a2;
        
        DistributorSalesAreaMapping__c DSA = new DistributorSalesAreaMapping__c();
        DSA.SalesOrg__c = salorg.Id;
        DSA.AccountType__c = 'Sold To Party';
        DSA.Distributor__c = a1.Id;
        insert DSA;
        
        DistributorSalesAreaMapping__c DSA2 = new DistributorSalesAreaMapping__c();
        DSA2.SalesOrg__c = salorg2.Id;
        DSA2.AccountType__c = 'Sold To Party';
        DSA2.Distributor__c = a2.Id;
        insert DSA2;
        
        Shipping_Location__c sl1 = new Shipping_Location__c();
        sl1.Distributor__c = a1.Id;
        sl1.Active_for_Liquidation__c = true;
        sl1.Sales_Org__c = Salorg3.Id;
        sl1.SAP_Code__c = '21212';
        insert sl1;
        
        Liquidation_Batch_Filters__c lbf1 = new Liquidation_Batch_Filters__c();
        lbf1.Name = 'Indonesia';
        lbf1.Sales_Org_Filter__c = 'Sales_Org_Code__c = \'6451\'';
        lbf1.Account_Type_Filter__c ='AccountType__c = \'Sold To Party\'';
        lbf1.Active__c = true;
        insert lbf1;
        
        Liquidation_Batch_Filters__c lbf2 = new Liquidation_Batch_Filters__c();
        lbf2.Name = 'Mexico';
        lbf2.Sales_Org_Filter__c = 'Sales_Org_Code__c = \'5100\'';
        lbf2.Account_Type_Filter__c ='AccountType__c = \'Sold To Party\'';
        lbf2.Active__c = true;
        insert lbf2;
        
        
        RecordType rt = [SELECT Id,Name FROM RecordType WHERE SobjectType='Liquidation_Annual_Plan__c' and Name='Multi Country'];
        
        Liquidation_Annual_Plan__c liqannlPln = new Liquidation_Annual_Plan__c();
        liqannlPln.Fiscal_Start_Date__c = Date.newInstance(2020, 04, 01);
        liqannlPln.FIscal_Year__c = '2020-2021';                   
        liqannlPln.Fiscal_End_Date__c = Date.newInstance(2021,31, 03);  
        liqannlPln.Distributor__c = a1.Id;
        liqannlPln.Multi_Country_Key__c =  a1.SAP_Code__c+'2020'+'-'+'2021'+salorg3.Sales_Org_Code__c;
        liqannlPln.SentToBatch__c = false;                      
        liqannlPln.Sales_Org__c=salorg3.id;
        liqannlPln.RecordTypeId=rt.Id;                 
        insert liqannlPln;
        
        Liquidation_Annual_Plan__c liqannlPln1 = new Liquidation_Annual_Plan__c();
        liqannlPln1.Fiscal_Start_Date__c = Date.newInstance(2020, 04, 01);
        liqannlPln1.FIscal_Year__c = '2020-2021';                   
        liqannlPln1.Fiscal_End_Date__c = Date.newInstance(2021,31, 03);  
        liqannlPln1.Distributor__c = a1.Id;
        liqannlPln1.Multi_Country_Key__c =  a1.SAP_Code__c+'2020'+'-'+'2021'+salorg.Sales_Org_Code__c;
        liqannlPln1.SentToBatch__c = false;                      
        liqannlPln1.Sales_Org__c=salorg.id;
        liqannlPln1.RecordTypeId=rt.Id;                 
        insert liqannlPln1;
        
        //MultiCountryLiqAnnualPlanScheduler sh1 = new MultiCountryLiqAnnualPlanScheduler();      
        //String sch = '0  00 1 3 * ?';
        //system.schedule('Test', sch, sh1);
        
    }
    
    static testmethod void  testscheduleMexico(){
       	MultiCountry_Liquidation__c multicountry = new MultiCountry_Liquidation__c();
        multicountry.Active__c = true;
        multicountry.Name = 'Mexico';
        insert multicountry;
        
        MultiCountryDistributorSchedular.createAnnualPlan();
    }
    static testmethod void  testscheduleIndonesia(){
        MultiCountry_Liquidation__c multicountry = new MultiCountry_Liquidation__c();
        multicountry.Active__c = true;
        multicountry.Name = 'Indonesia';
        insert multicountry;
        
        MultiCountryDistributorSchedular.createAnnualPlan();
    }
}