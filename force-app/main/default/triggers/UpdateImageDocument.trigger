/*
* Name: UpdateImageDocument
* Created On: 24 Dec 2019
* Author: Vishal pawar (vishal.pawar@skinternational.com)
* Description: This Trigger is used to create file record after community confuguration record is created with Banner and News Record type
*/

trigger UpdateImageDocument on Community_Configuration__c (After insert, after update) {
    
    //System.debug('In after insert of Imaage in community configuration ');
    
    Id devRecordTypeIdOfBanner = Schema.SObjectType.Community_Configuration__c.getRecordTypeInfosByDeveloperName().get('Banner').getRecordTypeId();
    Id devRecordTypeIdOfNews = Schema.SObjectType.Community_Configuration__c.getRecordTypeInfosByDeveloperName().get('News').getRecordTypeId();
    
    
    if (Trigger.isInsert) {
        System.debug('is After is Insert');
        for (Community_Configuration__c ccobj : Trigger.new){
            
            if(devRecordTypeIdOfBanner==ccobj.RecordTypeId){
                //This is for Banner 
                System.debug('Image in trigger '+ccobj.Image__c);
                String url = ccobj.Image__c;
                String fName= ccobj.Name;
                String recId = ccObj.Id;
                
                System.debug('url in Trigger '+url);
                String hyperlinkURL = 'https://'+ccObj.Custom_Link_Url__c;
                
                if(!Test.isRunningTest()){
                     ParseToBlobCtrl.convertToBlob(url,fName,recId,'Banner',hyperlinkURL,'','');
                }
                  
                
            }
            
            if(devRecordTypeIdOfNews==ccobj.RecordTypeId){
                //This for News
                String url = ccobj.Image__c;
                String fName= ccobj.Name;
                String recId = ccObj.Id;
                String hyperlinkURL = 'https://'+ccObj.Custom_Link_Url__c;
                String description = ccObj.Description__c;
                String descriptionForNews = ccObj.Description_For_News__c;
                
                if(!Test.isRunningTest()){
                    ParseToBlobCtrl.convertToBlob(url,fName,recId,'News',hyperlinkURL,description,descriptionForNews);
                }
               
            }
            
        }
    }
    
    if (Trigger.isUpdate) {
        System.debug('is After is update');
        for (Community_Configuration__c ccobj : Trigger.new){
            System.debug('ccobj in update record of community Configuaration '+ccobj.Id);
            delete [SELECT Id, ContentDocumentId,LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId=:ccobj.Id];
            
            if(devRecordTypeIdOfBanner==ccobj.RecordTypeId){
                //This is for Banner 
                String url = ccobj.Image__c;
                String fName= ccobj.Name;
                String recId = ccObj.Id;
                String hyperlinkURL = 'https://'+ccObj.Custom_Link_Url__c;
                if(!Test.isRunningTest()){
                    ParseToBlobCtrl.convertToBlob(url,fName,recId,'Banner',hyperlinkURL,'','');    
                }  
                
                
            }
            
            if(devRecordTypeIdOfNews==ccobj.RecordTypeId){
                //This for News
                String url = ccobj.Image__c;
                String fName= ccobj.Name;
                String recId = ccObj.Id;
                String hyperlinkURL = ccObj.Custom_Link_Url__c;
                String description = ccObj.Description__c;
                String descriptionForNews = ccObj.Description_For_News__c;
                if(!Test.isRunningTest()){
                     ParseToBlobCtrl.convertToBlob(url,fName,recId,'News',hyperlinkURL,description,descriptionForNews);
                }
               
            }
            
        }
        
        
    }
    
    
    
}