@isTest
public class Grz_OrderGraphTest {
    
    static Date fiscalYearStartDate;
    
    static void init(Integer i){
        Id accRecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Account acc = Grz_TestDataFactory.createAccount(true, 'Test Account',accRecordTypeId); 
        Sales_Org__c sorg = Grz_TestDataFactory.createSalesOrg(true, 'india', '1000');
        Sales_Org__c sorg1 = Grz_TestDataFactory.createSalesOrg(true, 'Brazil', '5191');
        String sapOrderNum = '7062140268'+i;
        String sapOrderNum1 = '7062143468'+i;
        String sapOrderNum2 = '7062143468'+i;
        Sales_Order__c salesObj = Grz_TestDataFactory.createSalesOrderRecord(false, sapOrderNum,'Open',Date.today(), acc.Id);
        salesObj.Total_Amount__c = 500;
        salesObj.Sales_Org_lk__c = sorg.Id;
        salesObj.Type_of_Order__c = 'VENDA NORMAL';
        insert salesObj;
        Sales_Order__c salesObj1 = Grz_TestDataFactory.createSalesOrderRecord(false, sapOrderNum1,'Approved',Date.today(), acc.Id);    
        salesObj1.Total_Amount__c = 500;
        salesObj1.Type_of_Order__c = 'CONTRATO MÃE';
        salesObj1.Sales_Org_lk__c = sorg1.Id;
        salesObj1.Valid_From__c=Date.today();
        salesObj1.Valid_To__c=Date.today();
        insert salesObj1;
        Brazil_Portal_Configuration__c bp = new Brazil_Portal_Configuration__c();
        bp.Name = 'Configuration';
        bp.Portal_Sales_Order_Type__c = 'CONTRATO MÃE';
        bp.Graph_Invoice_Order_Type__c = 'VENDA NORMAL\nCONTRATO MÃE';
        bp.Graph_Sales_Order_Type__c = 'VENDA NORMAL\nCONTRATO MÃE';
        insert bp;
        Invoice__c inv = Grz_TestDataFactory.createInvoice(false, acc.Id);
        inv.Sales_Order__c = salesObj.Id;
        inv.Sales_Org__c = sorg1 .Id;
        insert inv;
        List<Period> fiscalYearList = [Select Type, StartDate, EndDate, Number, FiscalYearSettings.PeriodId From Period Where Type='Year' and startDate <= TODAY and endDate >= TODAY];      
        fiscalYearStartDate = fiscalYearList[0].StartDate;
        Datetime createDate = fiscalYearStartDate.addMonths(i);
        Test.setCreatedDate(salesObj.Id, createDate);
        Test.setCreatedDate(salesObj1.Id, createDate);
        Test.setCreatedDate(inv.Id, createDate);
        Test.startTest();
        //Grz_OrderGraph.getDonData('0');
        //Grz_OrderGraph.getDonDataBrazil('0');
        Grz_OrderGraph.getDonDataAll('0','en_US');
        Grz_OrderGraph.getDonDataAll('0','pt_BR');
        Grz_OrderGraph.getDonDataAll('1','en_US');
        Grz_OrderGraph.getDonDataAll('1','pt_BR');
         Grz_OrderGraph.getUserData();
        Test.stopTest();
    }
    
    
    static void init1(integer t){
        Id accRecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Account acc = Grz_TestDataFactory.createAccount(true, 'Test Account',accRecordTypeId);
         Sales_Org__c sorg2 = Grz_TestDataFactory.createSalesOrg(true, 'Chile', '5661');
        String sapOrderNum2 = '7062143468';
        Sales_Order__c salesObj2 = Grz_TestDataFactory.createSalesOrderRecord(false, sapOrderNum2,'Approved',Date.today(), acc.Id);    
        salesObj2.Total_Amount__c = 500;
        salesObj2.Sales_Org_lk__c = sorg2.Id;
        insert salesObj2;
        
        //Invoice__c inv = Grz_TestDataFactory.createInvoice(true, acc.Id);
        List<Period> fiscalYearList = [Select Type, StartDate, EndDate, Number, FiscalYearSettings.PeriodId From Period Where Type='Year' and startDate <= TODAY and endDate >= TODAY];      
        fiscalYearStartDate = fiscalYearList[0].StartDate;
       // Test.startTest();
        Datetime createDate = Datetime.newInstance(System.Today().year(), t, 28, 1, 6, 8);
        Test.setCreatedDate(salesObj2.Id, createDate);
        //Test.setCreatedDate(inv.Id, createDate);
        Grz_OrderGraph.getDonDataAll('0','es');
        Grz_OrderGraph.getDonDataAll('1','es');
        
         Grz_OrderGraph.getUserData();
        
       //  Test.stopTest();
    }
    
      static void init2(integer t){
        Id accRecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Account acc = Grz_TestDataFactory.createAccount(true, 'Test Account',accRecordTypeId);
         Sales_Org__c sorg2 = Grz_TestDataFactory.createSalesOrg(true, 'Mexico', '5100');
        String sapOrderNum2 = '7062143468';
        Sales_Order__c salesObj2 = Grz_TestDataFactory.createSalesOrderRecord(false, sapOrderNum2,'Approved',Date.today(), acc.Id);    
        salesObj2.Total_Amount__c = 500;
        salesObj2.Sales_Org_lk__c = sorg2.Id;
        insert salesObj2;
        
        //Invoice__c inv = Grz_TestDataFactory.createInvoice(true, acc.Id);
        List<Period> fiscalYearList = [Select Type, StartDate, EndDate, Number, FiscalYearSettings.PeriodId From Period Where Type='Year' and startDate <= TODAY and endDate >= TODAY];      
        fiscalYearStartDate = fiscalYearList[0].StartDate;
       // Test.startTest();
        Datetime createDate = Datetime.newInstance(System.Today().year(), t, 28, 1, 6, 8);
        Test.setCreatedDate(salesObj2.Id, createDate);
        //Test.setCreatedDate(inv.Id, createDate);
        Grz_OrderGraph.getDonDataAll('0','es_Mx');
        Grz_OrderGraph.getDonDataAll('1','es_Mx');
        
         Grz_OrderGraph.getUserData();
        
       //  Test.stopTest();
    }

    Public  static testmethod void Chile1(){
        init1(12);
        
    }
    
     Public  static testmethod void Chile2(){
        init1(11);
        
    }
    
     Public  static testmethod void Chile3(){
        init1(10);
        
    }
    
     Public  static testmethod void Chile4(){
        init1(9);
        
    }
    
     Public  static testmethod void Chile5(){
        init1(8);
        
    }
    
     Public  static testmethod void Chile6(){
        init1(7);
        
    }
    
     Public  static testmethod void Chile7(){
        init1(6);
        
    }
    
     Public  static testmethod void Chile8(){
        init1(5);
        
    }
    
     Public  static testmethod void Chile9(){
        init1(4);
        
    }
    
     Public  static testmethod void Chile10(){
        init1(3);
        
    }
    
     Public  static testmethod void Chile11(){
        init1(2);
        
    }
    
     Public  static testmethod void Chile12(){
        init1(1);
        
    }
     Public  static testmethod void Mexico1(){
        init2(12);
        
    }
    
     Public  static testmethod void Mexico2(){
        init2(11);
        
    }
    
     Public  static testmethod void Mexico3(){
        init2(10);
        
    }
    
     Public  static testmethod void Mexico4(){
        init2(9);
        
    }
    
     Public  static testmethod void Mexico5(){
        init2(8);
        
    }
    
     Public  static testmethod void Mexico6(){
        init2(7);
        
    }
    
     Public  static testmethod void Mexico7(){
        init2(6);
        
    }
    
     Public  static testmethod void Mexico8(){
        init2(5);
        
    }
    
     Public  static testmethod void Mexico9(){
        init2(4);
        
    }
    
     Public  static testmethod void Mexico10(){
        init2(3);
        
    }
    
     Public  static testmethod void Mexico11(){
        init2(2);
        
    }
    
     Public  static testmethod void Mexico12(){
        init2(1);
        
    }
    
    Public  static testmethod void testSalesCount(){
        init(0);
    }
    Public  static testmethod void testSalesCount1(){
        init(1);
    }
    Public  static testmethod void testSalesCount2(){
        init(2);
    }
    Public  static testmethod void testSalesCount3(){
        init(3);
    }
    Public  static testmethod void testSalesCount4(){
        init(4);
    }
    Public  static testmethod void testSalesCount5(){
        init(5);
    }
    Public  static testmethod void testSalesCount6(){
        init(6);
    }
    Public  static testmethod void testSalesCount7(){
        init(7);
    }
    Public  static testmethod void testSalesCount8(){
        init(8);
    }
    Public  static testmethod void testSalesCount9(){
        init(9);
    }
    Public  static testmethod void testSalesCount10(){
        init(10);
    }
    Public  static testmethod void testSalesCount11(){
        init(11);
    }
}