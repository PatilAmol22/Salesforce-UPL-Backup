@isTest
public class InvokePDF_Test {
    //for coverage of Standard
    @isTest
    static void test1(){
        //product record to be inserted as a brandpack look up in case 
        Product2 pro = new Product2();
        pro.Name = 'Manco';
        pro.Combination_Key__c = '1235346787';
       
        
        //Some prerequisites for the CaseTrigger & Account Trigger
        Auto_Number__c auto = new Auto_Number__c();
        auto.Name='FarmerCode';
        auto.Sequence__c='11';
       
        
        //Some prerequisites for the CaseTrigger & Account Trigger
        Trigger_Settings__c tsObj1 = new Trigger_Settings__c();
        tsObj1.Name = 'CaseTrigger';
        tsObj1.isActive__c = True;
       
        
        //Account Instance with dynamic record type
        Account acc= new Account();
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('US Distributor').getRecordTypeId();
        acc.Name = 'Accountt';
        acc.BillingStreet = 'DSP road';
        acc.BillingCity = 'MUMBAI';
        acc.BillingCountry = 'INDIA';
        acc.BillingState = 'MAHARASHTRA';
        acc.BillingPostalCode = '400068';
        acc.Phone='1010101004';
        acc.WRMS_Code__c='1222'; 
      
        
        //CSR record with Standard as record type
        CSR__c csrObj = new CSR__c();
        csrObj.RecordTypeId =  Schema.SObjectType.CSR__c.getRecordTypeInfosByName().get('Standard').getRecordTypeId();
        csrObj.Account_Name__c = acc.Id;
        csrObj.Brand_Pack__c = pro.Id;
        test.startTest();
        insert pro;
        insert auto;
        insert tsObj1;
        insert acc;
        insert csrObj;
        test.stopTest();
        List<String> lst = new List<String>();
        for(CSR__c vsr : [Select ID from CSR__c where ID = :csrObj.Id]){
            lst.add(vsr.Id);
        } 
        //setting the page reference to test
        PageReference pageRef = Page.AttachPdfCSR;
        Test.setCurrentPage(pageRef); 
        // The class instance
        InvokePDF.savePDF(lst);
    }
    
    //for coverage of outside program funds in CSR 
    @isTest
    static void test2(){
        //product record to be inserted as a brandpack look up in case 
        Product2 pro = new Product2();
        pro.Name = 'Manco';
        pro.Combination_Key__c = '1235346787';
        
        //Some prerequisites for the CaseTrigger & Account Trigger
        Auto_Number__c auto = new Auto_Number__c();
        auto.Name='FarmerCode';
        auto.Sequence__c='11';
       
        
        //Some prerequisites for the CaseTrigger & Account Trigger
        Trigger_Settings__c tsObj1 = new Trigger_Settings__c();
        tsObj1.Name = 'CaseTrigger';
        tsObj1.isActive__c = True;
       
        
        //Account Instance with dynamic record type
        Account acc= new Account();
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('US Distributor').getRecordTypeId();
        acc.Name = 'Accountt';
        acc.BillingStreet = 'DSP road';
        acc.BillingCity = 'MUMBAI';
        acc.BillingCountry = 'INDIA';
        acc.BillingState = 'MAHARASHTRA';
        acc.BillingPostalCode = '400068';
        acc.Phone='1010101004';
        acc.WRMS_Code__c='1222'; 
      
        
        //CSR record with Standard as record type
        CSR__c csrObj = new CSR__c();
        csrObj.RecordTypeId =  Schema.SObjectType.CSR__c.getRecordTypeInfosByName().get('Outside of Program Funds').getRecordTypeId();
        csrObj.Account_Name__c = acc.Id;
        csrObj.Brand_Pack__c = pro.Id;
        test.startTest();
        insert pro;
        insert auto;
        insert tsObj1;
        insert acc;
        insert csrObj;
        test.stopTest();
        List<String> lst = new List<String>();
        for(CSR__c vsr : [Select ID from CSR__c where ID = :csrObj.Id]){
            lst.add(vsr.Id);
        } 
        //setting the page reference to test
        PageReference pageRef = Page.AttachPDFOutSideCSR;
        Test.setCurrentPage(pageRef); 
        // The class instance
        InvokePDF.savePDF(lst);
    }
    
    
}