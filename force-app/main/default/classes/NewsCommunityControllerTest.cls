@isTest
public class NewsCommunityControllerTest {
@testSetup
     static void allDataForThisClass(){
        
        //UserRole urole = [SELECT Id FROM UserRole WHERE DeveloperName = 'AGRIIPOLSKASPZOOCustomerUser' LIMIT 1]; 
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Customer Community Plus User - Poland - 1' LIMIT 1]; 
        Id devRecordTypeId = Schema.SObjectType.Community_Configuration__c.getRecordTypeInfosByName().get('News').getRecordTypeId(); 
         
        Sales_Org__c salesOrg= new Sales_Org__c();
        salesorg.Name='Poland';
        salesorg.Description__c='Poland';
        salesorg.Sales_Org_Code__c='2941';
        //salesorg.OwnerId=userObj.Id;
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
             Tax_classification_for_customer__c = ''        // Tax classification for customer
             
         );
         insert acntObj;
         
         Contact conObj = new Contact();
         conObj.LastName='shaikh';
         conObj.Email = 'azhar.shaikh@skinternational.com';  // Email
         conObj.AccountId=acntObj.Id;
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
         userObj.Community_Role__c='1';
         //userObj.UserRoleId=urole.Id;
         insert userObj;
         System.debug('userObj : '+userObj);
         
         
         
         ContentVersion cv = new ContentVersion();
         cv.Title = 'Penguins';
         cv.PathOnClient = 'Penguins.jpeg';
         cv.VersionData = Blob.valueOf('Penguins');
         cv.IsMajorVersion = true;
         insert cv;    
         
         List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
         
         Community_Configuration__c ccObj=new Community_Configuration__c();
         ccObj.Title__c='Test Message';
         ccObj.Description__c='Test Message';
         ccObj.Active__c=true;
         ccObj.Visible_to_All__c=true;
         //ccObj.Distributor_Name__c=acntObj.Id;
         ccObj.RecordTypeId=devRecordTypeId;
         ccObj.Valid_From__c=system.today();
         ccObj.Valid_To__c=System.today()+1; 
         ccObj.Image__c='Penguins';
         ccObj.Country__c='Poland';
         ccObj.Sales_Org__c='2941';
         insert ccObj;
         System.debug('ccObj : '+ccObj);
         
         //create ContentDocumentLink  record 
         ContentDocumentLink cdl = New ContentDocumentLink();
         cdl.LinkedEntityId = ccObj.id;
         cdl.Visibility='AllUsers';
         cdl.ContentDocumentId = documents[0].Id;
         insert cdl;
         /*Community_Configuration__c ccObj2=new Community_Configuration__c();
         ccObj2.Title__c='Test Message';
         ccObj2.Description__c='Test Message';
         ccObj2.Active__c=true;
         ccObj.Visible_to_All__c=true;
         ccObj2.RecordTypeId=devRecordTypeId;
         ccObj2.Valid_From__c=system.today();
         ccObj2.Valid_To__c=System.today()+1; 
         ccObj2.Image__c='Penguins';
         ccObj.Country__c='Poland';
         ccObj.Sales_Org__c='2941';
         insert ccObj2;
         System.debug('ccObj2 : '+ccObj2);*/
         
     }
    static testMethod void method(){
        User u=[Select id from User where Username='grzegorz@gmail.com' limit 1];
		Community_Configuration__c ccObj=[Select id from Community_Configuration__c where Title__c='Test Message' limit 1];        
        System.runAs(u){
            NewsCommunityController.TotalRecords();
        	NewsCommunityController.getNewsList();
            NewsCommunityController.getContentVersionIds(ccObj.Id);
        }
        
        //NewsCommunityController.getNext(1,10);
        //NewsCommunityController.getPrevious(0,10);
    }
    
}