@isTest
public class PolandPriceComAuraControllerTest {
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
         
         /*Attachment attach=new Attachment();   	
         attach.Name='Unit Test Attachment';
         Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
         attach.body=bodyBlob;
         attach.parentId=ppcObj.id;
         insert attach;*/
         
         ContentVersion cv = new ContentVersion();
         cv.Title = 'Penguins';
         cv.PathOnClient = 'Penguins.jpeg';
         cv.VersionData = Blob.valueOf('Penguins');
         cv.IsMajorVersion = true;
         insert cv;    
         
         List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
         //create ContentDocumentLink  record 
         ContentDocumentLink cdl = New ContentDocumentLink();
         cdl.LinkedEntityId = ppcObj.id;
         cdl.ContentDocumentId = documents[0].Id;
         insert cdl;
         
     }
    static testMethod void method(){
        Poland_Price_Communication__c ppcObj=[Select Id,Contact__c,isEmailChecked__c,OwnerId from Poland_Price_Communication__c limit 1];
        List<Poland_Price_Communication__c> ppcList=[Select Id,Account__c,Contact__c,isEmailChecked__c,Description__c,OwnerId from Poland_Price_Communication__c limit 1];
         List<ContentVersion> cvList=[Select Id,Title,VersionData,FileType,FileExtension from ContentVersion limit 1];
        String acntObj=[Select Id,Name from Account limit 1].Name;
        String acntName=acntObj;
        String acntId=[Select Id,Name from Account limit 1].Id;
        String cId=[Select Id,Name from Contact limit 1].Id;
        List<String> emailIds=new List<String>();
        emailIds.add('abc@gmail.com');
        List<Blob> blobList=new List<Blob>();
        blobList.add(Blob.valueOf('Penguins'));
        List<String> fileName=new List<String>();
        fileName.add('Penguins');
        List<String> fileExt=new List<String>();
        fileExt.add('image/jpeg');
        DistributorDetailsWrapper wrap=new DistributorDetailsWrapper();
        wrap.accId=acntId;
        wrap.accName=acntName;
        wrap.cId=cId;
        String myJSON = '['+JSON.serialize(wrap)+']';
        System.debug('myJSON : '+myJSON);
        System.debug('ppcList : '+ppcList);
        System.debug('cvList : '+cvList);
        PolandPriceCommunicationAuraController.getDistributors();
        PolandPriceCommunicationAuraController.getCommunityContacts(new String[]{acntId});
        PolandPriceCommunicationAuraController.uploadFileAttachments(ppcList,cvList[0].Title,'abcijsdnasidgisdbsdbs',cvList[0].FileExtension,null,2);
        PolandPriceCommunicationAuraController.createPPCommunication(true,'Test Description',myJSON);
        //PolandPriceCommunicationAuraController.sendEmailMethod();
    }
    
    public class DistributorDetailsWrapper{
        @AuraEnabled public String accId;
        @AuraEnabled public String accName;
        @AuraEnabled public String cId;
        @AuraEnabled public String cName;
        @AuraEnabled public String cEmail;
        @AuraEnabled public boolean checkMail;
        
        DistributorDetailsWrapper(){
            accId='';
            accName='';
            cId='';
            cName='';
            cEmail='';
            checkMail=true;
        }
    } 
}