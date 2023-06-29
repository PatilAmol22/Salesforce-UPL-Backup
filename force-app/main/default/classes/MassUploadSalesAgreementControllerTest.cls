@isTest 
public class MassUploadSalesAgreementControllerTest {
	@testSetup
    static void allDataForThisClass(){
         
        Sales_Org__c salesOrg= new Sales_Org__c();
        salesorg.Name='Brazil';
        salesorg.Description__c='Brazil';
        salesorg.Sales_Org_Code__c='5191';
        insert salesorg;
         
		Sales_Forecast_Setting__c sfsObj= new Sales_Forecast_Setting__c();
        sfsObj.Active_Forecast_Month__c='May';
        sfsObj.Start_Day_Of_Approval__c=7;
        sfsObj.End_Day_Of_Approval__c=14;
        sfsObj.Start_Day_of_Submission__c=2;
        sfsObj.End_Day_of_Submission__c=5;
        //sfsObj.Sales_Org__c=salesorg.Id;
        insert sfsObj;
        
        
    }
    static testMethod void method(){
        
        MassUploadSalesAgreementController.getsalesforecastsetting();
        
        String body ='Update Id;Planned Quantity\r\n';
        body+='0YC1m0000004OmoGAE;1\r\n';
        body+='0YC1m0000004OmnGAE;2\r\n';
        
        
        ContentVersion contentVersionInsert = new ContentVersion(
            Title = 'SalesAgreementSchedule',
            PathOnClient = 'SalesAgreementSchedule.csv',
            VersionData = Blob.valueOf(body),
            IsMajorVersion = true
        );
        insert contentVersionInsert;
      
        ContentVersion contentVersionSelect = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :contentVersionInsert.Id LIMIT 1];
        
        BusinessDashboard__c bdObj2 = new BusinessDashboard__c();
        bdObj2.RecordTypeId = Schema.SObjectType.BusinessDashboard__c.getRecordTypeInfosByName().get('Split File').getRecordTypeId();
       	bdObj2.EmailSubject__c = 'test_liquidation3.txt';
        bdObj2.FromAddress__c = 'azhar.shaikh@skinternational.com' ;
        bdObj2.Status__c = 'Draft';
        bdObj2.As_of_now__c = System.now();
        bdObj2.Rows__c = 5;
        bdObj2.Header__c = 'Update Id,Planned Quantity';
        insert bdObj2;
        //System.debug('bdObj2 :----'+bdObj2);
        
        Attachment attachment2 = new Attachment();
        attachment2.ParentId = bdObj2.Id;
        attachment2.Name = 'SalesAgreementSchedule.csv';
        attachment2.Body = Blob.valueof('0YC0k0000002v6JGAQ,1\r\n');
        insert attachment2;
        
        
        //System.debug('attachment2 :----'+attachment2);
        
        Schema_Definition__c sdObj3 = new Schema_Definition__c();
        sdObj3.Name = 'SalesAgreementProductSchedule';
        sdObj3.Mapping_Definition__c = '[{"position":0,"label":"","fieldType":"","column":"Update Id","api":"Id"},{"position":1,"label":"","fieldType":"DOUBLE","column":"Planned Quantity","api":"PlannedQuantity"}]';
        insert sdObj3;
        //System.debug('sdObj3 :----'+sdObj3);
        
        SchemaObjectMapping__c smObj2 = new SchemaObjectMapping__c();
        smObj2.Name = 'SalesAgreementProductSchedule';
        smObj2.Filename__c='SalesAgreementSchedule.csv';
        smObj2.Object__c = 'SalesAgreementProductSchedule';
        insert smObj2;
        
        MassUploadSalesAgreementController.readCSVFile(contentVersionSelect.ContentDocumentId);
        
        
    }
    // Added by Prashant Kumbhar 20/4/2022
    static testMethod void method1(){
        
        String body1 ='Region Code;SKU Code;Quantity;Month\r\n';
        body1+='210;672019;0;1\r\n';
        body1+='118;672019;0;1\r\n';
        /*
        String body1 ='Region Code;SKU Code;Quantity;Month\r\n';
        body1+='0150K000009n3wY;1\r\n';
        body1+='0150K000009n3wY;1\r\n';
        */
        
        ContentVersion contentVersionInsert1 = new ContentVersion(
            Title = 'SampleTemplateBrazilBudgetUpload.csv',
            PathOnClient = 'SampleTemplateBrazilBudgetUpload.csv',
            VersionData = Blob.valueOf(body1),
            IsMajorVersion = true
        );
        insert contentVersionInsert1;
        
        ContentVersion contentVersionSelect1 = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :contentVersionInsert1.Id LIMIT 1];
        
        BusinessDashboard__c bdObj3 = new BusinessDashboard__c();
        bdObj3.RecordTypeId = Schema.SObjectType.BusinessDashboard__c.getRecordTypeInfosByName().get('Split File').getRecordTypeId();
       	bdObj3.EmailSubject__c = 'SampleTemplateBrazilBudgetUpload.csv';
        bdObj3.FromAddress__c = 'prashant.kumbhar@skinternational.com' ;
        bdObj3.Status__c = 'Draft';
        bdObj3.As_of_now__c = System.now();
        bdObj3.Rows__c = 2;
        bdObj3.Header__c = 'Region Code,SKU Code,Quantity,Month';
        insert bdObj3;
        
        Schema_Definition__c sdObj4 = new Schema_Definition__c();
        sdObj4.Name = 'Account_Target__c';
        sdObj4.Mapping_Definition__c = '[{"position":0,"label":"","fieldType":"Lookup","column":"Region Code","api":"Region__c"},{"position":1,"label":"","fieldType":"Lookup","column":"SKU Code","api":"Product__c"},{"position":2,"label":"","fieldType":"Number","column":"Quantity","api":"Quantity__c"},{"position":3,"label":"","fieldType":"picklist","column":"Month","api":"Month__c"}]';
        insert sdObj4;
        
        
        SchemaObjectMapping__c smObje = new SchemaObjectMapping__c();
        smObje.Name = 'Account_Target__c';
        smObje.Filename__c='SampleTemplateBrazilBudgetUpload.csv';
       // smObje.Filename__c='SampleTemplateBrazilBudgetUpload.csv';
        smObje.Object__c = 'Account_Target__c';
        insert smObje;
        
        
        Attachment attachment3 = new Attachment();
        attachment3.ParentId = bdObj3.Id;
        attachment3.Name = 'SampleTemplateBrazilBudgetUpload.csv';
        attachment3.Body = Blob.valueof('210;672019;0;1\r\n');
        insert attachment3;
        
        Attachment attachment4 = new Attachment();
        attachment4.ParentId = bdObj3.Id;
        attachment4.Name = String.valueOf('Success.csv');
        attachment4.Body = Blob.valueOf(( '210;672019;0;1\r\n'));
        insert attachment4;
        
        
        Sales_Org__c salesOrg= new Sales_Org__c();
        salesorg.Name='Brazil';
        salesorg.Description__c='Brazil';
        salesorg.Sales_Org_Code__c='5191';
        insert salesorg;
        
        Territory_Distributor__c ter=new Territory_Distributor__c();
        ter.Name='Region';
        ter.TerritoryCode__c='210';
        ter.SalesOrg__c=salesOrg.id;
        insert ter;
        
        Territory_Distributor__c ter1=new Territory_Distributor__c();
        ter1.Name='Region1';
        ter1.TerritoryCode__c='118';
        ter1.SalesOrg__c=salesOrg.id;
        insert ter1;
        
        
        Product2 pr = new Product2();
        pr.Name='Product';
        pr.Product_Code__c='672019';
        pr.Sales_Org__c=salesOrg.id;
        pr.Combination_Key__c='P123';
        insert pr;
        
        
        BudgetUploadYear__c bud = new  BudgetUploadYear__c();
        bud.Name='Budgetyear';
        bud.Year__c='2021';
        insert bud;
       
        
        Account_Target__c acc= new Account_Target__c();
        acc.Month__c='5';
        acc.Product__c=pr.id;
        acc.Quantity__c=decimal.valueOf('201.50');
        acc.Region__c=ter.id;
        acc.Sales_Org__c=salesorg.id;
        acc.Year__c='2021';
        acc.Combination_Key__c='BR210519100000000000625000352022';
        acc.CurrencyIsoCode='MXN';
        acc.Price__c=50;
        insert acc;
        MassUploadSalesAgreementController.readCSVFile(contentVersionSelect1.ContentDocumentId);
        SalesAgreementBatch x= new SalesAgreementBatch();
        x.processData('210;672019;0;1\r\n');
        
        SalesAgreementBatch.setYear('2021');
   
    
    
    }
    
    
}