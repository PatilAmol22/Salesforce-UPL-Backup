@isTest
public class PBUpload_Brazil_Test {
    
    static testMethod void pbMethod(){
        Sales_Org__c salesOrg= new Sales_Org__c();
        salesorg.Name='Brazil';
        salesorg.Description__c='Brazil';
        salesorg.Sales_Org_Code__c='5191';
        insert salesorg; 
        
        Pricebook2 pb=new Pricebook2();
        pb.Name='pb1';
        pb.Year__c='2021';
        pb.IsActive=true;
        insert pb;
        
        Sales_Forecast_Setting__c sfd=new Sales_Forecast_Setting__c();
        sfd.Active_Forecast_Month__c='April';
        insert sfd;
             
        Product2 pd=new Product2();
        pd.Name='pd1';
        pd.Active__c=true;
        pd.Product_Code__c='000000000005210065';
        pd.Combination_Key__c='5191000000000005210065';
        pd.Sales_Org__c=salesorg.id;
        insert pd;
        
        Region__c rg=new Region__c();
        rg.Name='rg1';
        rg.RegionCode__c='rg0011';
        rg.SalesOrg__c=salesorg.id;
        insert rg;
        
        
        
        PricebookEntry pbe=new PricebookEntry();
        //pbe.Name='pbe1';
        pbe.Pricebook2Id=Test.getStandardPricebookId();
        pbe.Combination_Key__c='April2021000000000005210065';
        pbe.Product2Id=pd.id;
        pbe.UnitPrice=1.0;
        pbe.Budget_Price__c=1.1;
        insert pbe;
        
        String str = 'Sales District code;product code;Price;unitprice\nrg0011;5210065;"10,1";"11,2"';
        ContentVersion cv=new Contentversion(); 
        cv.title='PB'; 
        cv.PathOnClient ='test'; 
        Blob b=Blob.valueOf(str); 
        cv.versiondata=b; 
        insert cv;
        
        Document document1=new Document();
        document1.Body = Blob.valueOf('Some Text');
    	document1.ContentType = 'csv';
    	document1.DeveloperName = 'samplw123';
    	document1.IsPublic = true;
    	document1.Name = 'samplw123';
    	document1.FolderId = [select id from folder where Name='Shared Documents'].id;
    	insert document1;
        
        File_Attachment__c fa=new File_Attachment__c();
        fa.Name='fa1';
        insert fa;
        
        ContentVersion  testContentInsert = [select id, ContentDocumentId from ContentVersion WHERE Id =: cv.Id];
        
        Test.startTest();
        
        PBUpload_Brazil.activeMonthSalesForecast();
        PBUpload_Brazil.getAllRecordId();
        PBUpload_Brazil.getReportId();
        PBUpload_Brazil.getCurrentYear();
        PBUpload_Brazil.getYearList();
        PBUpload_Brazil.getDownloadURLForTemplates();
        PBUpload_Brazil.readCSVFile(testContentInsert.ContentDocumentId, 'April-04', '2021');
        PBUpload_Brazil.sendMail('err', 'scc', 0, 1, 'mailUnit');       
        Test.stopTest();
        
        
        
        
    }
}