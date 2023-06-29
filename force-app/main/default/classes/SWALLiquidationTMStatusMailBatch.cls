/*
     Class Name : SWALLiquidationTMStatusMailBatch
     Description : Batch Class to trigger mail for TM status for SWAL 
     Author : Abhineet Kumar
     Date : 17/09/2022
 */
global class SWALLiquidationTMStatusMailBatch implements Database.Batchable<sObject>  {
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String salesOrgCodeSWAL = '1210';
        String queryString = 'SELECT Id, Name, RegionHead__c, RegionHead__r.Email, RegionHead__r.IsActive, FMM_User__c, FMM_User__r.Email, FMM_User__r.IsActive, Zone__r.ZMMUser__c, Zone__r.ZMMUser__r.Email,Zone__r.ZMMUser__r.IsActive,(Select Id from Territories__r) FROM Region__c WHERE  SalesOrg__r.Sales_Org_Code__c = \''+salesOrgCodeSWAL+'\'';
        return Database.getQueryLocator(queryString);
    }

    global void execute(Database.BatchableContext BC, List<Region__c> scope){
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
        List<EmailTemplate> emailTempList  = [SELECT Id FROM EmailTemplate WHERE DeveloperName = 'Territory_Manager_SWAL' LIMIT 1];
        if(emailTempList.size() > 0){
            templateId = emailTempList[0].Id;
        }
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();

        for(Region__c reg : scope){
          if(reg.Territories__r.size()>0){
            if(!String.isBlank(reg.RegionHead__r.Email) && !reg.RegionHead__r.Email.Contains('invalid') && (reg.RegionHead__r.IsActive)){
                toAddressList.add(reg.RegionHead__r.Email);
            }
            if(!String.isBlank(reg.FMM_User__r.Email) && !reg.FMM_User__r.Email.Contains('invalid') && (reg.FMM_User__r.IsActive)){
                toAddressList.add(reg.FMM_User__r.Email);
            }
            //if(!String.isBlank(reg.Zone__r.ZMMUser__r.Email) && !reg.Zone__r.ZMMUser__r.Email.Contains('invalid') && (reg.Zone__r.ZMMUser__r.IsActive)){
                //toCCAddressList.add(reg.Zone__r.ZMMUser__r.Email);
            //}

            //email part
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setOrgWideEmailAddressId(owaId);
            message.setTemplateID(templateId);
            message.setTargetObjectId(reg.RegionHead__c);
            message.setTreatTargetObjectAsRecipient(false);
            message.setSaveAsActivity(false); 
            message.setWhatId(reg.Id); //This is important for the merge fields in template to work
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
		AFLiquidationTMStatusMailSBUBatch afTMSBUBatch = new AFLiquidationTMStatusMailSBUBatch();
        Database.executeBatch(afTMSBUBatch,10);
    }
}