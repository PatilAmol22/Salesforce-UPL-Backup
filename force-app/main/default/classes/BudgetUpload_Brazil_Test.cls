@isTest
public class BudgetUpload_Brazil_Test {
    
    static testMethod void buMethod(){
        Sales_Org__c salesOrg= new Sales_Org__c();
        salesorg.Name='Brazil';
        salesorg.Description__c='Brazil';
        salesorg.Sales_Org_Code__c='5191';
        insert salesorg;
        
        Product2 pd=new Product2();
        pd.Name='pd1';
        pd.Active__c=true;
        pd.Product_Code__c='000000000005210065';
        pd.Combination_Key__c='5191000000000005210065';
        pd.Sales_Org__c=salesorg.id;
        insert pd;
        
        Territory_Distributor__c td=new Territory_Distributor__c();
        td.Name='td1';
        td.TerritoryCode__c='BR201';
        insert td;
        
        Account_Target__c at=new Account_Target__c();
        at.Month__c='5';
        at.Year__c='2021';
        at.Product__c=pd.id;
        at.Region__c=td.Id;
        at.Quantity__c=10;
        at.Price__c=100;
        at.Sales_Org__c=salesorg.id;
        at.CurrencyIsoCode='BRL';
        at.Combination_Key__c='BR201519100000000000521006552021';
        insert at;
        
        String str = 'REgion;SKU;Quantity;Price\nBR202;5210065;10;"11,2"';
        ContentVersion cv=new Contentversion(); 
        cv.title='BU'; 
        cv.PathOnClient ='test'; 
        Blob b=Blob.valueOf(str); 
        cv.versiondata=b; 
        insert cv;
        
        Document document1=new Document();
        document1.Body = Blob.valueOf('Some Text');
    	document1.ContentType = 'csv';
    	document1.DeveloperName = 'Sample1';
    	document1.IsPublic = true;
    	document1.Name = 'Sample1';
    	document1.FolderId = [select id from folder where Name='Shared Documents'].id;
    	insert document1;
        
        File_Attachment__c fa=new File_Attachment__c();
        fa.Name='fa1';
        insert fa;
        
        ContentVersion  testContentInsert = [select id, ContentDocumentId from ContentVersion WHERE Id =: cv.Id];
        Test.startTest();
        
        BudgetUpload_Brazil.getAllRecordId();
        BudgetUpload_Brazil.getYearList();
        BudgetUpload_Brazil.getCurrentYear();
        BudgetUpload_Brazil.readCSVFile(testContentInsert.ContentDocumentId,'2021');
        BudgetUpload_Brazil.sendMail('err', 'scc', 0, 1);
        
        Test.stopTest();
    }

}