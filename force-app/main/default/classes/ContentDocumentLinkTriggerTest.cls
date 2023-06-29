/*
* Name: ContentDocumentLinkTriggerTest
* Created On: 30 Jan 2023
* Author: Abhinay kurmi patel
* Description: Test class  for ContentDocumentLinkTrigger (France)
* Supporting Classes: ContentDocumentLinkHelper
*/

@isTest
public class ContentDocumentLinkTriggerTest {
    static testMethod void method(){
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        
        Account accObj = new Account();
        	accObj.RecordTypeId = recordTypeId;
            	accObj.Name = 'KVP Test';
                accObj.Mobile__c = '9999999999';
              insert accObj;
        
       Id recordTypeId2 = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('General Contact').getRecordTypeId();
         	Contact conObj = new Contact();
        	conObj.RecordTypeId = recordTypeId2;
            	conObj.FirstName = 'KVP';
        		conObj.LastName = 'KVP Test';
                conObj.AccountId = accObj.Id;
              insert conObj;
        
        Contract_management__c Contractmanagement = new Contract_management__c();
        	Contractmanagement.Customer_Account__c = accObj.id;
        	Contractmanagement.Contact__c = conObj.id;
        	Contractmanagement.Contract_Type__c = 'Annexes';
        	Contractmanagement.Contract_Start_Date__c =Date.newInstance(2016, 11, 9);
            Contractmanagement.Contract_End_Date__c = Date.newInstance(2016, 12, 10);
        insert Contractmanagement;  
        
        ContentVersion content=new ContentVersion(); 
        content.Title='Header_Picture1'; 
        content.PathOnClient='/' + content.Title + '.pdf'; 
        Blob bodyBlob=Blob.valueOf('Unit Test ContentVersion Body'); 
        content.VersionData=bodyBlob; 
        //content.LinkedEntityId=sub.id;
        content.origin = 'H';
        insert content;
        ContentDocumentLink contentlink=new ContentDocumentLink();
        contentlink.LinkedEntityId=Contractmanagement.id;
        contentlink.contentdocumentid=[select contentdocumentid from contentversion where id =: content.id].contentdocumentid;
        contentlink.ShareType = 'I';
        contentlink.Visibility = 'AllUsers'; 
        insert contentlink;
                
    }
    
}