/*
Class Name : AFLiquidationStatusMailSBUBatch
Description : Batch Class to send AF Liquidation Status Mail to SBU
Author : Bonny Mathews
Date : 05/08/2022
*/
global class AFLiquidationStatusMailSBUBatch implements Database.batchable<sObject>{
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String salesOrgCodeAF = System.Label.AF_Sales_Org_Code_Label;
        String salesOrgCodeAFNew = System.Label.New_AF_Sales_Org_Code_Label;
        String sbuCode = System.Label.AF_Active_SBUs;
        String queryString = 'SELECT Id, SBUMarketingheads__c, SBUMarketingheads__r.Email, SBUMarketingheads__r.IsActive, SBUUser__c, SBUUser__r.Email, SBUUserActive__c FROM  SBU__c WHERE SBUCode__c IN ('+sbuCode+') AND (SalesOrg__r.Sales_Org_Code__c = \''+salesOrgCodeAF+'\' OR SalesOrg__r.Sales_Org_Code__c = \''+salesOrgCodeAFNew+'\')';
        System.debug(queryString);
        return Database.getQueryLocator(queryString);
    }

    global void execute(Database.BatchableContext BC, List<SBU__c> scope){
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
        List<EmailTemplate> emailTempList  = [SELECT Id FROM EmailTemplate WHERE DeveloperName = 'AF_SBU_Territory_Liquidation_Status' LIMIT 1];
        if(emailTempList.size() > 0){
            templateId = emailTempList[0].Id;
        }
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();

        for(SBU__c sbu : scope){
            if(!String.isBlank(sbu.SBUMarketingheads__r.Email) && !sbu.SBUMarketingheads__r.Email.Contains('invalid') && (sbu.SBUMarketingheads__r.IsActive)){
                toAddressList.add(sbu.SBUMarketingheads__r.Email);
            }
            if(!String.isBlank(sbu.SBUUser__r.Email) && !sbu.SBUUser__r.Email.Contains('invalid') && (sbu.SBUUserActive__c)){
                toAddressList.add(sbu.SBUUser__r.Email);
            }

            //email part
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setOrgWideEmailAddressId(owaId);
            message.setTemplateID(templateId);
            message.setTargetObjectId(sbu.SBUUser__c);
            message.setTreatTargetObjectAsRecipient(false);
            message.setSaveAsActivity(false); 
            message.setWhatId(sbu.Id); //This is important for the merge fields in template to work
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