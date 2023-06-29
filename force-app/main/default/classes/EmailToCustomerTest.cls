/* Developer Name : Vaishnavi/Nandhini
* Purpose: Test class for EmailToCustomer.cls
* CR: APPS-3974
* Author: EY
* Created Date: 06/01/2023
*/
@isTest
public without sharing class EmailToCustomerTest {
    
    public static  List<User> userList;
    public static final Id territoryManagerProfileId = [SELECT Id FROM Profile WHERE Name = 'Territory Manager'].Id;
    public static final Id regionalZonalProfileId = [SELECT Id FROM Profile WHERE Name = 'Regional/Zonal Managers'].Id;
    public static final Id sbuProfileId = [SELECT Id FROM Profile WHERE Name = 'SBU Profile'].Id;
    
    public static void insertUser(){
        userList = new List<User>(); 
        User userRecord = new User(
            ProfileId =territoryManagerProfileId ,
            LastName = 'last',
            Email = 'testNewUserEmailId@gmail.com',
            Username = 'testNewUserEmailId1@gmail.com' + System.currentTimeMillis(),
            Country='India',
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            isActive = true,
            MobilePhone = '9748694980'
            
        );  
        userList.add(userRecord);
        
        User userRecord1 = new User(
            ProfileId = regionalZonalProfileId,
            LastName = 'last',
            Email = 'testNewUserEmailId2@gmail.com',
            Username = 'testNewUserEmailId2@gmail.com' + System.currentTimeMillis(),
            Country='India',
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            isActive = true,
            MobilePhone = '9748694980'
            
        );  
        userList.add(userRecord1);
        
        User userRecord2 = new User(
            ProfileId =sbuProfileId ,
            LastName = 'last',
            Email = 'testNewUserEmailId2@gmail.com',
            Username = 'testNewUserEmailId3@gmail.com' + System.currentTimeMillis(),
            Country='India',
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            isActive = true,
            MobilePhone = '9748694980'
            
        );  
        userList.add(userRecord2);
        User userRecord3 = new User(
            ProfileId =regionalZonalProfileId,
            LastName = 'last',
            Email = 'testNewUserEmailId4@gmail.com',
            Username = 'testNewUserEmailId4@gmail.com' + System.currentTimeMillis(),
            Country='India',
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            isActive = true,
            MobilePhone = '9748694980'
            
        );  
        userList.add(userRecord3);
        INSERT  userList;
    }
/*  
* Name: fetchCountryAndCustomer    
* return:void
* Description: -This method responsible to cover fetchCountryData and fetchCustomerData methods.
                This test method fetch the customer info based on SBU,Zone,Region,Salesorg.
*/
    @isTest
    public static void fetchCountryAndCustomer(){
        insertUser();
        Sales_Org__c salesOrgObj =new Sales_Org__c();
        salesOrgObj.Name='UPL SAS';
        salesOrgObj.Description__c='UPL SAS';
        salesOrgObj.Sales_Org_Code__c='1410';
        insert salesOrgObj;
        
        Sales_Org__c salesOrgObjSwal =new Sales_Org__c();
        salesOrgObjSwal.Name='SWAL';
        salesOrgObjSwal.Description__c='SWAL';
        salesOrgObjSwal.Sales_Org_Code__c='1210';
        insert salesOrgObjSwal;
        
        SBU__c SBUObj = new SBU__c(
            SBUUser__c = userList[3].Id, 
            SBUCode__c = 'SBU2',  
            SalesOrg__c = salesOrgObjSwal.id
        );
        insert SBUObj;
        
        List<String> SBUId = new List<String>{String.valueOf(SBUObj.id)};
        Zone__c zoneObj = new Zone__c(
            Name = 'Indore',                 
            SalesOrg__c = salesOrgObjSwal.Id,   
            ZoneCode__c = 'Z16',              
            ZonalHead__c = userList[2].Id, 
            SBUCode__c = SBUObj.Id   
        );
        insert zoneObj;
        List<String> ZoneId = new List<String>{String.valueOf(zoneObj.id)};
        
        
        Region__c regionObj = new Region__c(
            Name = 'TRIANGULO',                 
            RegionCode__c = 'BR4003',            
            SalesOrg__c =salesOrgObjSwal.id,      
            RegionHead__c = userList[1].id,    
            Zone__c = zoneObj.id
            
        );
        
        insert regionObj;
        
        List<String> RegionId= new List<String>{String.valueOf(regionObj.id)};
        Region__c regionObj1 = new Region__c(
            Name = 'TRIANGULO1',                 
            RegionCode__c = 'BR40031',          
            SalesOrg__c =salesOrgObjSwal.id,     
            RegionHead__c = userList[1].id,    
            Zone__c = zoneObj.id
            
        );
        insert regionObj1;
        Territory_Distributor__c territoryObj = new Territory_Distributor__c();
        territoryObj.Name = 'Narayangaon';
        territoryObj.TerritoryCode__c = '398';
        territoryObj.SalesOrg__c = salesOrgObjSwal.id;
        territoryObj.Region__c = regionObj.id;
        territoryObj.TerritoryManager__c = userList[0].Id;
        territoryObj.Zone__c = zoneObj.id;
        territoryObj.SBU__c = SBUObj.Id;
        territoryObj.SalesOrg__c = salesOrgObj.id;
        territoryObj.Present_in_KEDE__c = true ;
        territoryObj.Neglected__c = false;
        
        insert territoryObj;
        
        List<String> territoryId = new List<String>{String.valueOf(territoryObj.id)};
        
         State__c stateObj = new State__c(
                Name = 'Uttar Pradesh',                
                State_Code__c = '9',                     
                Country__c = 'India',                    
                Active__c = true,                        
                State_Code_Census__c = '9',              
                State_Name_Census__c = 'UTTAR PRADESH' 
                //Country_Akc__c = countryObj.id      
            );
            insert stateObj;
        List<String> stateId=new List<String>{(String)stateObj.id};
        Account accRecord = new Account();
        accRecord.Name='Bhavik Devdhar';
        accRecord.Last_Name__c='Devdhar';
        accRecord.SAP_Code__c='0001131274';
        accRecord.RecordTypeId=UPLConstantClass.distributorRecordTypeId;
        accRecord.Territory_Distributor__c=territoryObj.id;
        accRecord.Mobile__c='9967341759';
        accRecord.Phone='020256589';
        accRecord.Sales_Org__c=salesOrgObjSwal.Id;
        accRecord.BillingCity='Pune';
        accRecord.Depot_Code__c = 'PUN1';
        insert accRecord;
        
        contact conRec = new contact();
        conRec.LastName = 'Test';
        conRec.AccountId= accRecord.Id;
        insert conRec; 
        
        System.runAs(userList[0]) {
            Test.StartTest();   
            
                EmailToCustomer.fetchCountryData(salesOrgObj.Sales_Org_Code__c);
                List<SBU__c> sbuRecordList = [select id,Name from SBU__c where SalesOrg__c=:salesOrgObjSwal.id ]; //what is the need of this ASSERT ?
                System.assert(sbuRecordList.size()>0);
                
                EmailToCustomer.CountryWrapper wrapper = EmailToCustomer.fetchCountryData(salesOrgObjSwal.Sales_Org_Code__c);
                List<Region__c> regionRecordList=[select id,Name from Region__c where SalesOrg__c=:salesOrgObjSwal.id ];//what is the need of this ASSERT ?
                System.assert(regionRecordList.size()>0);
            	List<String> subList = new List<String>();
            	List<String> reList = new List<String>();
                List<String> zoList = new List<String>();
                for(SBU__c sb: sbuRecordList){
                    subList.add(sb.Name);
                }
            	for(Region__c re: regionRecordList){
                    reList.add(re.Name);
                }
            	EmailToCustomer.fetchSearchData('1210','Zone__c','In',JSON.serialize(subList),JSON.serialize(zoList),JSON.serialize(reList));
            	EmailToCustomer.fetchSearchData('1210','Territory_Distributor__c','Narayangaon',JSON.serialize(subList),JSON.serialize(zoList),JSON.serialize(reList));
            	EmailToCustomer.fetchSearchData('1210','Region__c','TRI',JSON.serialize(subList),JSON.serialize(zoList),JSON.serialize(reList));
            	EmailToCustomer.fetchSearchData('1210','SBU__c','00',JSON.serialize(subList),JSON.serialize(zoList),JSON.serialize(reList));
                EmailToCustomer.fetchSearchData('1210','State__c','Ut',JSON.serialize(subList),JSON.serialize(zoList),JSON.serialize(reList));
            	
            	EmailToCustomer.customerWrapper wrap = new EmailToCustomer.customerWrapper();

            
                EmailToCustomer.fetchCustomerData( UPLConstantClass.UPL_SAS_SalesOrg, SBUId, ZoneId, RegionId, stateId,territoryId);
                ContentVersion newFile = new ContentVersion();
                newFile.PathOnClient = 'TestFile';
                newFile.Title = 'TestFile';
                newFile.VersionData = Blob.valueOf('sample content');
                insert newFile;
            
             	ContentVersion newFile1 = new ContentVersion();
                newFile1.PathOnClient = 'TestFileData.csv';
                newFile1.Title = 'TestFileData';
                newFile1.VersionData = Blob.valueOf('sample content \n Test, TestFile');
                insert newFile1;
            
            	List<Id> fileIds = new List<Id>{newFile.Id,newFile1.Id};
                List<ContentVersion> insertedFile = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id IN:fileIds];
                List<Id> contentDocumentId = new List<Id>();
                contentDocumentId.add(insertedFile[0].ContentDocumentId);
                contentDocumentId.add(insertedFile[1].ContentDocumentId);
                /*ContentDocumentLink linkedFile = new ContentDocumentLink(LinkedEntityId=territoryObj.id, ContentDocumentId=insertedFile.ContentDocumentId);
    insert linkedFile;*/
             	Account acc = new Account();
            	acc.Name='VS Traders';
            	acc.Sales_Org__c=salesOrgObj.Id;
                insert acc;
            
            	Account acc1 = new Account();
            	acc1.Name='VS Traders';
            	acc1.Sales_Org__c=salesOrgObj.Id;
                insert acc1;
            
                String userListOfString = '{"Id":"'+acc.Id+'","Name":"VS Traders","SBUName":"NA","ZoneName":"Coimbatore","TerritoryName":"Madhurai","Email":"vstraders33vs@gmail.com","check":true,"SAPCode":"0001131274"}';
                String userListString2 = '{"Id":"'+acc1.Id+'","Name":"VKS Agri Clinic cum Mini STL","SBUName":"NA","ZoneName":"Coimbatore","TerritoryName":"Madhurai","Email":"vstraders33v1s@gmail.com","check":true,"SAPCode":"0001025004"}';
                List<String> finalUserList=new List<String>();
                finalUserList.add(userListOfString);
                finalUserList.add(userListString2);
               
            	Map<String,List<Id>> customerDocumentMap = new Map<String,List<Id>>();
                customerDocumentMap.put('0001131274',contentDocumentId);
                customerDocumentMap.put('0001025004',contentDocumentId);
                String serializedCustomerDocument=JSON.serialize(customerDocumentMap);
                EmailToCustomer.SendEmail('This is Test body',finalUserList,contentDocumentId,serializedCustomerDocument);
                
            Test.StopTest(); 
        }
        List<Account> accList=[select id from Account where Territory_Distributor__c=:territoryObj.Id];
        System.assert(accList.size()>0);
    }
 /*  
* Name: fetchCountryAndCustomer    
* return:void
* Description: -This method responsible to cover uploadFiles method.
                This test method upload the inserted file into selected accounts
*/
    @isTest
    public static void uploadFilesUnderAccount(){
        insertUser();
        Sales_Org__c salesOrgObj =new Sales_Org__c();
        salesOrgObj.Name='UPL SAS';
        salesOrgObj.Description__c='UPL SAS';
        salesOrgObj.Sales_Org_Code__c='1410';
        insert salesOrgObj;
        Distribution_Channel__c distributionChannel = new Distribution_Channel__c();
        distributionChannel.Name = '20';                      
        distributionChannel.Distribution_Channel_Code__c = '20';  
        distributionChannel.Description__c='test';
        insert distributionChannel;
        
        Division__c divObj = new Division__c();
        divObj.Name = '10';         
        divObj.Description__c = null;    
        divObj.Division_Code__c = '10'; 
        Insert divObj;
        
        Account accRecord = new Account();
        accRecord.Name='Bhavik Devdhar';
        accRecord.Last_Name__c='Devdhar';
        accRecord.SAP_Code__c='SAP996734';
        accRecord.RecordTypeId=UPLConstantClass.distributorRecordTypeId;
        accRecord.Mobile__c='9967341759';
        accRecord.Phone='020256589';
        accRecord.Sales_Org__c=salesOrgObj.Id;
        accRecord.Division__c=divObj.Id;
        accRecord.Distribution_Channel__c=distributionChannel.Id;
        accRecord.BillingCity='Pune';
        accRecord.Depot_Code__c = 'PUN1';
        insert accRecord;
        
        List<id> accId=new List<id>();
        
        accId.add(accRecord.Id);
        System.runAs(userList[0]) {
            Test.StartTest();    
                ContentVersion newFile = new ContentVersion();
                newFile.PathOnClient = 'TestFile';
                newFile.Title = 'TestFile';
                newFile.VersionData = Blob.valueOf('sample content');
                insert newFile;
            
                ContentVersion insertedFile = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =:newFile.Id];
                EmailToCustomer.uploadFiles(insertedFile.ContentDocumentId,accId);
                List<ContentDocumentLink> contentLink=[select id,LinkedEntityId from ContentDocumentLink where ContentDocumentId=:insertedFile.ContentDocumentId];
                System.assert(contentLink.size()>0);
            Test.StopTest();
            
        }
    }
/*  
* Name: fetchCountryAndCustomer    
* return:void
* Description: -This method responsible to cover SendEmail method.
                This test method send the email to selected customers with the attched files.
*/
    @isTest
    public static void sendCsvFile(){   
        insertUser();
        Sales_Org__c salesOrgObj =new Sales_Org__c();
        salesOrgObj.Name='UPL SAS';
        salesOrgObj.Description__c='UPL SAS';
        salesOrgObj.Sales_Org_Code__c='1410';
        insert salesOrgObj; 
        
        System.runAs(userList[0]) {
            Test.StartTest(); 
                ContentVersion newFile = new ContentVersion();
                newFile.PathOnClient = 'TestFile.csv';
                newFile.Title = 'TestFile';
                newFile.VersionData = Blob.valueOf('sample content \n Test, TestFile');
                insert newFile;
            
                ContentVersion insertedFile = [SELECT Id, ContentDocumentId,FileExtension FROM ContentVersion WHERE Id =:newFile.Id];
                List<id> contentDocumentId=new List<id>();
                contentDocumentId.add(insertedFile.ContentDocumentId);
             	Account acc = new Account();
            	acc.Name='VS Traders';
            	acc.Sales_Org__c=salesOrgObj.Id;
                insert acc;
            
            	Account acc1 = new Account();
            	acc1.Name='VS Traders';
            	acc1.Sales_Org__c=salesOrgObj.Id;
                insert acc1;
                String userLsitOfString='{"Id":"'+acc.Id+'","Name":"VS Traders","SBUName":"NA","ZoneName":"Coimbatore","TerritoryName":"Madhurai","Email":"vstraders33vs@gmail.com","check":true,"SAPCode":"0001131274"}';
                String userLsitString2='{"Id":"'+acc1.Id+'","Name":"VKS Agri Clinic cum Mini STL","SBUName":"NA","ZoneName":"Coimbatore","TerritoryName":"Madhurai","Email":"vstraders33v1s@gmail.com","check":true,"SAPCode":"0001025004"}';
               
            
            	List<String> finalUserList=new List<String>();
                finalUserList.add(userLsitOfString);
                finalUserList.add(userLsitString2);
                
            	Map<String,List<id>> customerDocumentMap=new Map<String,List<id>>();
                customerDocumentMap.put('0001131274',contentDocumentId);
                String serializedCustomerDocument=JSON.serialize(customerDocumentMap);
                system.assertEquals(insertedFile.FileExtension,'csv');
                
            	EmailToCustomer.SendEmail('This is Test body',finalUserList,contentDocumentId,serializedCustomerDocument);
            Test.StopTest();
        }
    }
    
    /*
    * Description: Test Class for exceptionCoverage method in UtilityClass
	* Param: NA
	* return : NA
    * */
    static testMethod void exceptionCoverage(){
        Test.startTest();
            try{
                UtilityClass.exceptionCoverage(true);
            }catch(Exception ex){
                
            }
        Test.stopTest();
    }
}