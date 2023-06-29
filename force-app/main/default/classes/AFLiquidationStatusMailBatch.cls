/*
     Class Name : AFLiquidationStatusMailBatch
     Description : Batch Class to trigger mail for Liquidation Status for AF
     Author : Abhineet Kumar
     Date : 15/09/2022
 */
global class AFLiquidationStatusMailBatch implements Database.batchable<sObject>{
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String salesOrgCodeAF = System.Label.AF_Sales_Org_Code_Label;
        String salesOrgCodeNewAF = System.Label.New_AF_Sales_Org_Code_Label;
        String queryString = 'SELECT Id, Name, ZMMUser__c, ZMMUser__r.Email,ZMMUser__r.IsActive,  ZonalHead__c, ZonalHead__r.Email,ZonalHead__r.IsActive,  SBUCode__r.SBUUser__c, SBUCode__r.SBUUser__r.Email, SBUCode__r.SBUUser__r.IsActive, (Select Id from Territories__r) FROM Zone__c WHERE  SalesOrg__r.Sales_Org_Code__c = \''+salesOrgCodeAF+'\' OR SalesOrg__r.Sales_Org_Code__c = \''+salesOrgCodeNewAF+'\'';
        return Database.getQueryLocator(queryString);
    }

    global void execute(Database.BatchableContext BC, List<Zone__c> scope){
        String owaEmail = System.Label.OWAEmailId;
        String[] toAddressList = new List<String>();
        String[] toCCAddressList = new List<String>();
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
        List<EmailTemplate> emailTempList  = [SELECT Id FROM EmailTemplate WHERE DeveloperName = 'Territory_Liquidation_Status_For_AF' LIMIT 1];
        if(emailTempList.size() > 0){
            templateId = emailTempList[0].Id;
        }
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();

        for(Zone__c zne : scope){
          if(zne.Territories__r.size()>0){
            if(!String.isBlank(zne.ZMMUser__r.Email) && !zne.ZMMUser__r.Email.Contains('invalid') && (zne.ZMMUser__r.IsActive)){
                toAddressList.add(zne.ZMMUser__r.Email);
            }
            if(!String.isBlank(zne.ZonalHead__r.Email) && !zne.ZonalHead__r.Email.Contains('invalid') && (zne.ZonalHead__r.IsActive)){
                toAddressList.add(zne.ZonalHead__r.Email);
            }
            //if(!String.isBlank(zne.SBUCode__r.SBUUser__r.Email) && !zne.SBUCode__r.SBUUser__r.Email.Contains('invalid') && (zne.SBUCode__r.SBUUser__r.IsActive)){
                //toCCAddressList.add(zne.SBUCode__r.SBUUser__r.Email);
            //}

            //email part
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setOrgWideEmailAddressId(owaId);
            message.setTemplateID(templateId);
            message.setTargetObjectId(zne.ZonalHead__c);
            message.setTreatTargetObjectAsRecipient(false);
            message.setSaveAsActivity(false); 
            message.setWhatId(zne.Id); //This is important for the merge fields in template to work
            message.setToAddresses(toAddressList);
            //message.setCCAddresses(toCCAddressList);
            emails.add(message);
            toAddressList.clear();
            toCCAddressList.clear();
          }
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