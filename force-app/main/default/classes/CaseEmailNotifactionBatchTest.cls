@isTest
private class CaseEmailNotifactionBatchTest {

    private static void createData(){
        Sales_Org__c sorg = new Sales_Org__c();
        sorg.Country_Code__c = 'IN';
        sorg.Company_Code__c = '1200';
        sorg.Sales_Org_Code__c = '1210';
        sorg.Name = 'SWAL';
        insert sorg;
        
        Id accountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('SWAL Distributor').getRecordTypeId();
        Account acc = new Account();
        acc.Name = 'test Account';
        acc.RecordTypeId = accountRecordTypeId;
        acc.Sales_Org__c = sorg.Id;
        insert acc;
        Case c = new Case();
        c.AccountId = acc.Id;
        c.Type = 'Invoice';
        c.Status = 'New';
        c.RecordTypeId = caseRecordTypeId;
        insert c;
        Territory_Distributor__c t = new Territory_Distributor__c();
        t.TerritoryManager__c = userInfo.getUserId();
        t.RCM_Email__c = 'testrcm@upl.com';
        insert t;
        Depot__c d = new Depot__c();
        d.Name = 'test depot';
        d.Active__c = true;
        d.Case_Access_Email__c = 'testcnf@upl.com';
        insert d;
        TM_Depot_Mapping__c tdm = new TM_Depot_Mapping__c();
        tdm.Territory_Manager__c = userInfo.getUserId();
        tdm.Depot__c = d.Id;
        insert tdm;
    }
    
    @isTest
    private static void testEmailForInvoiceType(){
        createData();
        Test.startTest();
            CaseEmailNotifactionBatch myBatchObject = new CaseEmailNotifactionBatch(); 
            Id batchId = Database.executeBatch(myBatchObject);
        Test.stopTest();
    }
    
    @isTest
    private static void testEmailForOutstandingType(){
        createData();
        Case c = [Select Type From Case limit 1];
        c.Type = 'Outstanding';
        update c;
        Test.startTest();
            CaseEmailNotifactionBatch myBatchObject = new CaseEmailNotifactionBatch(); 
            Id batchId = Database.executeBatch(myBatchObject);
        Test.stopTest();
    }
    
    @isTest
    private static void testEmailForSchemeType(){
        createData();
        Case c = [Select Type From Case limit 1];
        c.Type = 'Scheme';
        update c;
        Test.startTest();
            CaseEmailNotifactionBatch myBatchObject = new CaseEmailNotifactionBatch(); 
            Id batchId = Database.executeBatch(myBatchObject);
        Test.stopTest();
    }
    
    @isTest
    private static void testEmailForCustomer_Master_UpdationType(){
        createData();
        Case c = [Select Type From Case limit 1];
        c.Type = 'Customer Master Updation';
        update c;
        Test.startTest();
            CaseEmailNotifactionBatch myBatchObject = new CaseEmailNotifactionBatch(); 
            Id batchId = Database.executeBatch(myBatchObject);
        Test.stopTest();
    }
    
    @isTest
    private static void testEmailNotificationScheduler(){
        createData();
        Case c = [Select Type From Case limit 1];
        c.Type = 'Customer Master Updation';
        update c;
        Test.startTest();
        UtilityClass.getCompanyCodeIndiaSAS();
        UtilityClass.getSalesOrgIndiaOld();
            CaselNotificationBatchSchedular myscd = new CaselNotificationBatchSchedular(); 
            System.schedule('test job', '0 0 23 * * ?', myscd);
        Test.stopTest();
    }
}