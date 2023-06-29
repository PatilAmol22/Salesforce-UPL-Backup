@isTest
public class PolandPriceCommunicationEmailBatchTest {
@testSetup
    static void allDataForThisClass(){
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Customer Community Plus User - Poland - 1' LIMIT 1]; 
         
        Sales_Org__c salesOrg= new Sales_Org__c();
        salesorg.Name='Poland';
        salesorg.Description__c='Poland';
        salesorg.Sales_Org_Code__c='2941';
        insert salesorg;
         
         Account acntObj = new Account(
             Name = 'AGROSIMEX SP Z O.O. [View Hierarchy]',  // Account Name
             Last_Name__c = 'AGROSIMEX SP Z O.O.',             // Last Name
             SAP_Code__c = '0001021932',                       // SAP Customer Code
             Order_Block__c = false,                           // Order Block
             Account_Type__c = 'Sold To Party',                // Account Type
             Incoterms_Part_2__c = 'CIP',                      // Incoterms (Part 2)
             //Unproductive_Call_Backend_Support__c = false,     // Unproductive Call (Backend) Support
             Prospect_to_Distributor__c = false,               // Prospect to Distributor
             AuthorizationGroupSalesoffice__c = '',        // Authorization Group (Sales office)
             TaxNumber1__c = '7971581032',                     // Tax Number 1
             Visit_Response__c = 'Red',                        // Visit Response
             LanguageKey__c = 'EN',                            // Language Key
             CountryKey__c = 'IN',                             // Country Key
             Sales_Org__c = salesOrg.Id,                // Sales Org
             ShippingConditions__c = '01',                     // Shipping Conditions
             Division__c = 'a10280000050MKD',                  // Division Name
             Distribution_Channel__c = 'a0x28000001p9hc',      // Distribution Channel
             CustomerAccountGroup__c = 'Z031',                 // Customer Account Group
             Depot_Code__c = 'PD01',                           // Depot Code
             //Inco_Term__c = 'a280k000000S7FV',                 // Inco Term
             Payment_Term_Code1__c = 'PT-4061',                // Payment Term Code
             Payment_Terms__c = 'UK04',                        // Payment Terms
             Distributor_Type_Poland__c = 'Regular Customer',  // Distributor Type Poland
             Is_Fixed_Rate_Available_Italy__c = false,         // Is Fixed Rate Available
             Tax_classification_for_customer__c = ''         // Tax classification for customer
         	
         );
         insert acntObj;
         
         Contact conObj = new Contact();
         conObj.LastName='shaikh';
         conObj.AccountId = acntObj.id;                // Account Name
         conObj.Email = 'azhar.shaikh@skinternational.com';  // Email
         conObj.Is_Community__c=true;
         insert conObj;
             
         User userObj=new User();
         userObj.LastName='Grzegorz Podrażka';
         userObj.Username='grzegorz@gmail.com';
         userObj.Email='shama.buchade@skinternational.com';
         userObj.Alias='gpodr';
         userObj.LocaleSidKey='pl_PL';
         userObj.TimeZoneSidKey='Asia/Kolkata';
         userObj.LanguageLocaleKey='pl';
         userObj.EmailEncodingKey='ISO-8859-1';
         userObj.ProfileId=p.Id;
         userObj.ContactId=conObj.Id;
         insert userObj;
         
         Poland_Price_Communication__c ppcObj=new Poland_Price_Communication__c();
         ppcObj.Account__c=acntObj.Id;
         ppcObj.Description__c='test';
         ppcObj.Contact__c=conObj.Id;
         ppcObj.OwnerId=userObj.Id;
         ppcObj.isEmailChecked__c=true;
         insert ppcObj;
         
         ContentVersion cv = new ContentVersion();
         cv.Title = 'Penguins';
         cv.PathOnClient = 'Penguins.jpeg';
         cv.VersionData = Blob.valueOf('Penguins');
         cv.IsMajorVersion = true;
         insert cv;    
         
         List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
         
         ContentDocumentLink cdl = New ContentDocumentLink();
         cdl.LinkedEntityId = ppcObj.id;
         cdl.ContentDocumentId = documents[0].Id;
         insert cdl;        
    }
    static TestMethod void method(){
        
        Test.startTest();
        PolandPriceCommunicationEmailBatch batchObj=new PolandPriceCommunicationEmailBatch();
        Database.executeBatch(batchObj,1);
        Test.stopTest();
    }
}