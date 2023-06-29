/*
Class Name : SWALLiquidationStatusMailZMMBatch
Description : Batch Class to send SWAL Liquidation Status Mail to ZML
Author : Bonny Mathews
Date : 05/08/2022
*/
global class SWALLiquidationStatusMailZMMBatch implements Database.Batchable<sObject>  {
	global Database.QueryLocator start(Database.BatchableContext BC) {
        String salesOrgCodeSWAL = System.Label.SWAL_Sales_Org_Code_Label;
        String queryString = 'SELECT Id,Name,ZMMUser__c,ZMMUser__r.Email,ZMMUser__r.IsActive,ZonalHead__c,ZonalHead__r.Email,ZonalHeadActive__c FROM Zone__c WHERE ZMMUser__c!=null AND SalesOrg__r.Sales_Org_Code__c = \''+salesOrgCodeSWAL+'\'';
        return Database.getQueryLocator(queryString);
    }

    global void execute(Database.BatchableContext BC, List<Zone__c> scope){
        String owaEmail = System.Label.OwaEmailId;
        String[] toAddressList = new List<String>();
        Set<Id> toUsrIdSet = new Set<Id>();
        //get OrgWideEmailAddressId
        String owaId;
        String templateId;
        List<OrgWideEmailAddress> owaList = new List<OrgWideEmailAddress>();
        //get OWA ID
        owaList = [SELECT Id FROM OrgWideEmailAddress WHERE Address =:owaEmail];
        if(owaList.size() > 0){
            owaId = owaList[0].Id;
        }

        //get Template ID
        List<EmailTemplate> emailTempList  = [SELECT Id FROM EmailTemplate WHERE DeveloperName = 'SWAL_ZML_Territory_Liquidation_Status' LIMIT 1];
        if(emailTempList.size() > 0){
            templateId = emailTempList[0].Id;
        }
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();

        for(Zone__c zne : scope){
            if(!String.isBlank(zne.ZMMUser__r.Email) && !zne.ZMMUser__r.Email.Contains('invalid') && (zne.ZMMUser__r.IsActive)){
                toAddressList.add(zne.ZMMUser__r.Email);
            }
            if(!String.isBlank(zne.ZonalHead__r.Email) && !zne.ZonalHead__r.Email.Contains('invalid') && (zne.ZonalHeadActive__c)){
                toAddressList.add(zne.ZonalHead__r.Email);
            }


            //email part
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setOrgWideEmailAddressId(owaId);
            message.setTemplateID(templateId);
            message.setTargetObjectId(zne.ZMMUser__c);
            message.setTreatTargetObjectAsRecipient(false);
            message.setSaveAsActivity(false); 
            message.setWhatId(zne.Id); //This is important for the merge fields in template to work
            message.setToAddresses(toAddressList);
            emails.add(message);
            toAddressList.clear();
        }
        try{
            if(emails.size()>0){
            	Messaging.sendEmail(emails,false);
            }
        }catch(Exception exp){
            System.debug('Something went wrong - '+exp.getMessage());
        }
    }

    global void finish(Database.BatchableContext BC){

    }
}