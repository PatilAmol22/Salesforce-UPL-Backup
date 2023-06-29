@isTest
public with sharing class SaveColombiaCaseTest {
 
    @testsetup
    static void makedata(){
        
        Sales_Org__c sales_org = new Sales_Org__c();
        sales_org.Name = 'Colombia';
        sales_org.Sales_Org_Code__c = '5710';
        sales_org.CurrencyIsoCode = 'INR';
        insert sales_org;
        
         Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        Account a = new Account();
        a.Name = 'Name';
        a.Email__c= 'email@example.com';
        a.RecordTypeId = recordTypeId;
        a.CurrencyIsoCode = 'COP';
        a.Sales_Org__c = sales_org.Id;
        insert a;
        
        File_Attachment__c file = new File_Attachment__c();
        file.Name = 'Colombia Case';
        insert file;
        
         User u = new User(
     ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
     LastName = 'last',
     Email = 'test@test.com',
     Username = 'test@test.com' + System.currentTimeMillis(),
     CompanyName = 'TEST',
     Title = 'title',
     Alias = 'alias',
     TimeZoneSidKey = 'America/Los_Angeles',
     EmailEncodingKey = 'UTF-8',
     LanguageLocaleKey = 'en_US',
     LocaleSidKey = 'en_US'
     );
     insert u;
        
        //select id,AccountId,UserId from AccountTeamMember where AccountId=:acc_id
        AccountTeamMember atm = new AccountTeamMember();
        atm.AccountId = a.Id;
        atm.UserId = u.Id;
        
        insert atm;
        
        DistributorSalesAreaMapping__c sales_area = new DistributorSalesAreaMapping__c();
        sales_area.AccountOwner__c = u.Id;
        sales_area.Distributor__c = a.Id;   
        insert sales_area;
        
        Id recordTypeId_case = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Colombia Case').getRecordTypeId();
        Case c = new Case();
        c.Priority= 'Credit Limit';
        c.Type ='Other';
        c.FAQs_Effectiveness__c = true;
        //c.AccountID =a.Id;
        c.Farmer_Name__c = 'Test_case';
        c.Email__c = 'test@gmail.com';
        c.ID_Number__c = '123456';
        c.Mobile_Number_col__c = '9594216059';
        c.status = 'Abierto';
        c.RecordTypeId = recordTypeId_case;
        insert c;
        
        Case c2 = new Case();
        c2.Priority= 'Credit Limit';
        c2.Type ='Other';
        c2.FAQs_Effectiveness__c = true;
        c2.AccountID =a.Id;
        c2.Farmer_Name__c = 'Test_case';
        c2.Email__c = 'test@gmail.com';
        c2.ID_Number__c = '123456';
        c2.Mobile_Number_col__c = '9594216059';
        c2.status = 'Cerrado';
        c2.RecordTypeId = recordTypeId_case;
        c2.Sales_representative__c = u.Id;
        insert c2;
        
        
        ContentVersion cv = new ContentVersion(
            Title = 'Test',
            PathOnClient = 'Test.jpg',
            VersionData = Blob.valueOf('Test Content Data'),
            IsMajorVersion = true
        );
        insert cv;
 
        Id conDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cv.Id].ContentDocumentId;
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = c.Id;
        cdl.ContentDocumentId = conDocId;
        cdl.shareType = 'V';
        Insert cdl;
        
        Product2 prod = new Product2();
        prod.Active__c = true;
        prod.Name = 'Product_test';
        prod.Combination_Key__c ='abvcf';
        insert prod;
        
        //SELECT Id,SKU_Description__c, Sales_Org_Code__c, Active__c FROM SKU__c where Sales_Org_Code__c='5710' 
        SKU__c sku = new SKU__c();
        sku.SKU_Description__c = 'product_name_sku';
        sku.SKU_code__c = '001';
        sku.Active__c = true;
        insert sku;         
            
        Case_Product_Information__c cpi = new Case_Product_Information__c();
        cpi.Case__c = c.Id;
        cpi.Date_of_Receiving_Product__c = date.newInstance(2020, 7, 29);
        cpi.Expiration_Date__c = date.newInstance(2020, 7, 29);
        cpi.Lot_Number__c = '5';
        cpi.Product__c = prod.Id;
        cpi.Quantity__c = 2.0;
        cpi.SKU__c = sku.Id;
        
        insert cpi;

              
    }
    
    static testMethod void  getAccountEmailandPhoneTest(){
        Account a1 = [select id,Name,Mobile__c,Email__c from Account limit 1]; 
        Case c1 = [Select Id,CaseNumber from Case limit 1];
            SaveColombiaCase.getAccountEmailandPhone(a1.id+'');
            SaveColombiaCase.getAccountEmailandPhone('');
            SaveColombiaCase.getCaseInfomation(c1.id+'');
    }
    static testMethod void SaveCaseTest(){
        Case c1 = [SELECT Id, Priority, Type, FAQs_Effectiveness__c, AccountID, Farmer_Name__c, Email__c, ID_Number__c, Mobile_Number_col__c, status, RecordTypeId From Case where status='Abierto' limit 1];
        Case c2 = [SELECT Id, Priority, Type, FAQs_Effectiveness__c, AccountID, Farmer_Name__c, Email__c, ID_Number__c, Mobile_Number_col__c, status, RecordTypeId From Case where status='Cerrado' limit 1];
        User u1 = [Select id,Lastname from User limit 1];
         System.runAs(u1){
             Test.startTest();
            SaveColombiaCase.SaveCase(c1);
            SaveColombiaCase.SaveCase(c2);
             Test.stopTest();
         }
    }
    
    static testMethod void addAssignmentRuleTest(){
        Case c1 = [SELECT Id, Priority, Type, FAQs_Effectiveness__c, AccountID, Farmer_Name__c, Email__c, ID_Number__c, Mobile_Number_col__c, status, RecordTypeId From Case where status='Abierto' limit 1];
        Case c2 = [SELECT Id, Priority, Type,Sales_representative__c, FAQs_Effectiveness__c, AccountID, Farmer_Name__c, Email__c, ID_Number__c, Mobile_Number_col__c, status, RecordTypeId From Case where status='Cerrado' limit 1];
        Product2 prod = [SELECT Id, IsActive, Active__c, Name, Sales_Org_Code__c FROM Product2 limit 1];
        SKU__c sku = [SELECT Id,SKU_Description__c, Sales_Org_Code__c, Active__c FROM SKU__c limit 1];
        User u1 = [Select id,Lastname from User limit 1];
         System.runAs(u1){
             Test.startTest();
        SaveColombiaCase.addAssignmentRule(c1.Id+''); 
        SaveColombiaCase.addAssignmentRule(c2.Id+'');      
        SaveColombiaCase.getProductInformation(c1.Id+''); 
        String cpi_str = '[{"date_of_receiving":"'+date.newInstance(2020, 7, 29)+'","expiration_date":"'+date.newInstance(2020, 7, 29)+'","id":"'+1+'","lot_number":"'+'1'+'","product":"'+prod.Id+'","productname":"'+prod.Name+'","quality":"'+'1'+'","recId":"'+''+'","sku":"'+sku.Id+'","skuname":"'+sku.SKU_Description__c+'","price":"'+'100'+'"}]'; 
        
        SaveColombiaCase.makeProductList(c1.Id+'',cpi_str);
        SaveColombiaCase.addCaseClosedEmail(c1.Id+'',[Select id,Lastname from User limit 1].Id+'');
        ID cpi = [Select id from Case_Product_Information__c limit 1].Id;
        SaveColombiaCase.deleteProductList(new List<String> {cpi});
        SaveColombiaCase.getFilesdata(c1.Id);
        SaveColombiaCase.getFilesdataTemp();
        SaveColombiaCase.deleteFilefromTemp();
        SaveColombiaCase.getFileAttachment();
        //SaveColombiaCase.FileWrapper fw= new SaveColombiaCase.FileWrapper();
         SaveColombiaCase.addCaseTeamMember(null,c1.id,u1.id);  
             Test.stopTest();
         } 
    }
}