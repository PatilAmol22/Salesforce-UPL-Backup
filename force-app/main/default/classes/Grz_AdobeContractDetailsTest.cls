@isTest
public class Grz_AdobeContractDetailsTest {
    @isTest
    public static void testMethod1(){
        
        contractDetailsMobileView__c c=new contractDetailsMobileView__c(Name='Mobile view',Active__c=true);
        insert c;
        
        Sales_Org__c sales_org = new Sales_Org__c();
        sales_org.Name = 'Colombia';
        sales_org.Sales_Org_Code__c = '5710';
        sales_org.CurrencyIsoCode = 'INR';
        insert sales_org;
        
        Sales_Org__c salesOrg= new Sales_Org__c();
        salesorg.Name='India';
        salesorg.Description__c='India';
        salesorg.Sales_Org_Code__c= '1410';
        insert salesorg;
        
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        Account a = new Account();
        a.Name = 'Name';
        a.Email__c= 'email@example.com';
        a.RecordTypeId = recordTypeId;
        a.CurrencyIsoCode = 'COP';
        a.Sales_Org__c = sales_org.Id;
        insert a;
        
        User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User'].Id,
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
        
        
        //SELECT Id, Name, AccountOwner__c, Distributor__c FROM DistributorSalesAreaMapping__c where Distributor__c='0010k00000n5MrYAAU'
        DistributorSalesAreaMapping__c sales_area = new DistributorSalesAreaMapping__c();
        //sales_area.Name = 'sales_area';
        sales_area.AccountOwner__c = u.Id;
        sales_area.Distributor__c = a.Id;
        sales_area.Ratio_of_Cash_Credit_Purchase_in_busines__c=213.48;
        
        insert sales_area;
        //RestRequest req = RestContext.request;
        //RestResponse res = RestContext.response;
        string name='testDoc';
        //insert contentVersion
        contentVersion cVersion = new contentVersion();
        cVersion.Title = name;
        system.debug('title'+cVersion.title);
        cVersion.PathOnClient = name +'.'+'jpg'; 
        system.debug('PathOnClient'+cVersion.PathOnClient);
        cVersion.versionData = Blob.valueOf('Test Content');
        system.debug('Version data'+cVersion.versionData);
        insert cVersion; 
        
        ID conDocument = [Select ContentDocumentID from ContentVersion 
                          where ID=:cVersion.ID].ContentDocumentID;
        //insert ContentDocumentLink
        
        ContentDocumentLink conDocLink = new ContentDocumentLink();
        conDocLink.LinkedEntityId = sales_area.Id;
        conDocLink.ContentDocumentId = conDocument;
        conDocLink.shareType = 'V';
        conDocLink.Visibility = 'AllUsers';
        insert conDocLink; 
        
        Grz_AdobeContractDetails.getSAandAccData(sales_area.id);
        update new DistributorSalesAreaMapping__c(id=sales_area.id,SalesOrg__c=salesOrg.id);
        Grz_AdobeContractDetails.getSAandAccData(sales_area.id);
        update new account(id=a.id,Sales_Org__c = salesorg.Id,GST_Validated__c=true,Non_GST_Customer__c=true);
        update new DistributorSalesAreaMapping__c(id=sales_area.id,SalesOrg__c=salesOrg.id);
        Grz_AdobeContractDetails.getSAandAccData(sales_area.id);
        update new DistributorSalesAreaMapping__c(id=sales_area.id,Contract_Details_Submitted__c=true);
        Grz_AdobeContractDetails.getSAandAccData(sales_area.id);
        update new account(id=a.id,Sales_Org__c = salesorg.Id,GST_Validated__c=true,Non_GST_Customer__c=false);
        Grz_AdobeContractDetails.getSAandAccData(sales_area.id);
        //update new account(id=a.id,GST_Validated__c=false);
        system.runAs(u){Grz_AdobeContractDetails.getSAandAccData(sales_area.id);}
        
        Grz_AdobeContractDetails.updateFileName(name,new list<string>{conDocument},sales_area.id);
        name='nann';
        contentVersion cVersion1 = new contentVersion();
        cVersion1.Title = name;
        cVersion1.PathOnClient = name +'.'+'jpg'; 
        cVersion1.versionData = Blob.valueOf('Test Content11111');
        insert cVersion1; 
        ID conDocument1 = [Select ContentDocumentID from ContentVersion 
                           where ID=:cVersion1.ID].ContentDocumentID;
        //insert ContentDocumentLink
        
        ContentDocumentLink conDocLink1 = new ContentDocumentLink();
        conDocLink1.LinkedEntityId = sales_area.Id;
        conDocLink1.ContentDocumentId = conDocument1;
        conDocLink1.shareType = 'V';
        conDocLink1.Visibility = 'AllUsers';
        insert conDocLink1; 
        
        Grz_AdobeContractDetails.updateFileName(name,new list<string>{conDocument,conDocument1},sales_area.id);
        update new contentVersion(id=cVersion1.id,title='profilePhoto',PathOnClient='profilePhoto.jpg');
        Grz_AdobeContractDetails.updateFileName('profilePhoto',new list<string>{conDocument,conDocument1},sales_area.id);
        Grz_AdobeContractDetails.updateFileName('dummy',new list<string>{conDocument,conDocument1,'cdw3'},sales_area.id);
        
        On_Boarding_Cheque_Details__c obcD= new On_Boarding_Cheque_Details__c(Name='obcD',Bank_Name1__c='OTHERS',sales_area__c=sales_area.id);
        On_Boarding_Cheque_Details__c obcU= new On_Boarding_Cheque_Details__c(Name='obcU',Bank_Name1__c='OTHERS',sales_area__c=sales_area.id);
        On_Boarding_Cheque_Details__c obcI= new On_Boarding_Cheque_Details__c(Name='obcI',Bank_Name1__c='OTHERS',sales_area__c=sales_area.id);
        
        insert new list<On_Boarding_Cheque_Details__c>{obcD,obcU,obcI};
            map<string,object> saMap=new map<string,object>{'Fertilizer_License_No__c'=>'','Seeds_License_No__c'=>'','Year_of_Establishment__c'=>'','Shop_Establishment_Act_License_No__c'=>'','Insectticides_License_No__c'=>'','Bank_Name__c'=>'Bank_Name__c','Fertilizer_Valid_till_date__c'=>system.today(),'Ratio_of_Cash_Credit_Purchase_in_busines__c'=>2300.10};
                map<string,object>od=new map<string,object>{'objectAPIName'=>'On_Boarding_Cheque_Details__c','Id'=>obcd.id,'sales_area__c'=>obcd.sales_area__c};
                    map<string,object>ou=new map<string,object>{'objectAPIName'=>'On_Boarding_Cheque_Details__c','Id'=>obcu.id,'sales_area__c'=>obcu.sales_area__c};
                        map<string,object>oi=new map<string,object>{'objectAPIName'=>'On_Boarding_Cheque_Details__c','sales_area__c'=>obci.sales_area__c};
                            system.debug('========================'+JSON.serializePretty(new list<object>{sales_area}));
        
        update new list<contentVersion>{new contentVersion(id=cVersion1.id,title='shopEstablishmentFile',PathOnClient='shopEstablishmentFile.jpg'),new contentVersion(id=cVersion.id,title='yearOfEstablishmentFile',PathOnClient='yearOfEstablishmentFile.jpg')};

            List<String> cdList=new List<String>();
        cdList.add('');
        Grz_AdobeContractDetails.saveData(cdList,JSON.serialize(saMap) ,sales_area.id,JSON.serialize(new list<object>{od}),JSON.serialize(new list<object>{ou}),JSON.serialize(new list<object>{oi}));
         Grz_AdobeContractDetails.checkAttachmentsSize(sales_area.id);
         List<String> contentDocIds=new List<String>();
         contentDocIds.add(conDocument);
                  contentDocIds.add(conDocument1);
                   Grz_AdobeContractDetails.deleteFiles(contentDocIds);
        
    }
    
}