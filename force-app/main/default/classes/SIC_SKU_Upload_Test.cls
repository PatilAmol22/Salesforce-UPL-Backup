@isTest(SeeAllData=true)
private class SIC_SKU_Upload_Test {
    
    static testMethod void testGetDocument(){   
    
        Test.startTest();  
        Document d = new Document();
        d.Name= 'SIC SKU Upload Template';
        d.FolderId=[select id from folder where name = 'Shared Documents'].id;
        insert d;
        Sales_Org__c sorg =new Sales_Org__c();
        sorg.Name='Brazil';
        sorg.Description__c='Brazil';
        sorg.Sales_Org_Code__c='5191';
        insert sorg;
        SKU__c sk = TestDataFactory.CreateSKU('000000000000674052',sorg,'100000000');
        SIC_SKU_Upload.getDocument();
       //SIC_SKU_Upload.passFile('Available for SIC\r\n 000000000000652017,test11\r\n test2,test22\r\n test3,test33');
        SIC_SKU_Upload.passFile('SKU Code,000000000000674052\r\n test2,test22\r\n test3,test33');
        // SIC_SKU_Upload.cheatCode();
        Test.stopTest(); 
    }
    }