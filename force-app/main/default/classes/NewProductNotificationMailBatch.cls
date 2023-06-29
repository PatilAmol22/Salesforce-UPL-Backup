/*
Class Name : NewProductNotificationMailBatch
Description : Batch class to trigger mail on creation of new products
Author : Abhineet Kumar
Date : 05/08/2022
*/
global class NewProductNotificationMailBatch implements Database.batchable<sObject>, Database.Stateful{
    global String productId;
    global String salesOrgCode;
    global Set<Id> mgrIds = new Set<Id>();

    global NewProductNotificationMailBatch(String productId, String salesOrgCode) {
        this.productId = productId;
        this.salesOrgCode = salesOrgCode;
    }

    global Database.QueryLocator start(Database.BatchableContext BC) {
        //String queryString = 'SELECT Id, TerritoryManager__c, TerritoryManager__r.Email,TerritoryManager__r.IsActive, Zone__r.ZMMUser__c, Zone__r.ZMMUser__r.Email,zone__r.ZMMUser__r.IsActive,Zone__r.ZonalHead__c, Zone__r.ZonalHead__r.Email,Zone__r.ZonalHead__r.IsActive,SBU__r.SBUUser__r.Email,SBU__r.SBUUser__r.IsActive,SBU_Head_Id__c, SBU__r.SBUMarketingheads__r.Email,SBU__r.SBUMarketingheads__r.IsActive,SBU_Marketing_heads_Id__c, Region__r.RegionHead__c, Region__r.RegionHead__r.Email, Region__r.RegionHead__r.IsActive, Region__r.FMM_User__c, Region__r.FMM_User__r.Email, Region__r.FMM_User__r.IsActive FROM Territory_Distributor__c WHERE Sales_Org_Code__c = \''+salesOrgCode+'\' AND Present_in_KEDE__c = true AND (TerritoryManager__c != null OR Zonal_Marketing_Manager_1_Id__c != null)';
        return Database.getQueryLocator([SELECT Id, TerritoryManager__c, TerritoryManager__r.Email,TerritoryManager__r.IsActive, Zone__r.ZMMUser__c, Zone__r.ZMMUser__r.Email,zone__r.ZMMUser__r.IsActive,Zone__r.ZonalHead__c, Zone__r.ZonalHead__r.Email,Zone__r.ZonalHead__r.IsActive,SBU__r.SBUUser__r.Email,SBU__r.SBUUser__r.IsActive,SBU_Head_Id__c, SBU__r.SBUMarketingheads__r.Email,SBU__r.SBUMarketingheads__r.IsActive,SBU_Marketing_heads_Id__c, Region__r.RegionHead__c, Region__r.RegionHead__r.Email, Region__r.RegionHead__r.IsActive, Region__r.FMM_User__c, Region__r.FMM_User__r.Email, Region__r.FMM_User__r.IsActive FROM Territory_Distributor__c WHERE Sales_Org_Code__c = :salesOrgCode AND Present_in_KEDE__c = true AND (TerritoryManager__c != null OR Zonal_Marketing_Manager_1_Id__c != null) AND (NOT (Name LIKE 'CIL%' OR Name LIKE 'SAIB%' OR Name LIKE 'Vector%' OR Name LIKE '%-b' OR Name LIKE '%- b' OR Name LIKE '%Provision'))]);
    }

    global void execute(Database.BatchableContext BC, List<Territory_Distributor__c> scope) {
        Map<Id,String> userIdToEmailMap = new Map<Id,String>();
        System.debug('set size = '+mgrIds.size());
        for(Territory_Distributor__c territory : scope){
            if(salesOrgCode == System.Label.SWAL_Sales_Org_Code_Label){
                if(territory.TerritoryManager__c != null && territory.TerritoryManager__r.IsActive == true && !territory.TerritoryManager__r.Email.contains('.invalid') && !mgrIds.contains(territory.TerritoryManager__c)){
                    userIdToEmailMap.put(territory.TerritoryManager__c,territory.TerritoryManager__r.Email);
                    mgrIds.add(territory.TerritoryManager__c);
                }
                if(territory.Region__r.RegionHead__c != null && territory.Region__r.RegionHead__r.IsActive == true && !territory.Region__r.RegionHead__r.Email.contains('.invalid') && !mgrIds.contains(territory.Region__r.RegionHead__c)){
                    userIdToEmailMap.put(territory.Region__r.RegionHead__c,territory.Region__r.RegionHead__r.Email);
                    mgrIds.add(territory.Region__r.RegionHead__c);
                }
                if(territory.Region__r.FMM_User__c != null && territory.Region__r.FMM_User__r.IsActive == true && !territory.Region__r.FMM_User__r.Email.contains('.invalid') && !mgrIds.contains(territory.Region__r.FMM_User__c)){
                    userIdToEmailMap.put(territory.Region__r.FMM_User__c,territory.Region__r.FMM_User__r.Email);
                    mgrIds.add(territory.Region__r.FMM_User__c);
                }
                if(territory.Zone__r.ZMMUser__c != null && territory.zone__r.ZMMUser__r.IsActive == true && !territory.Zone__r.ZMMUser__r.Email.contains('.invalid') && !mgrIds.contains(territory.Zone__r.ZMMUser__c)){
                    userIdToEmailMap.put(territory.Zone__r.ZMMUser__c,territory.Zone__r.ZMMUser__r.Email);
                    mgrIds.add(territory.Zone__r.ZMMUser__c);
                }
                if(territory.Zone__r.ZonalHead__c != null && territory.Zone__r.ZonalHead__r.IsActive == true && !territory.Zone__r.ZonalHead__r.Email.contains('.invalid') && !mgrIds.contains(territory.Zone__r.ZonalHead__c)){
                    userIdToEmailMap.put(territory.Zone__r.ZonalHead__c,territory.Zone__r.ZonalHead__r.Email);
                    mgrIds.add(territory.Zone__r.ZonalHead__c);
                }
            }else if(salesOrgCode == System.Label.AF_Sales_Org_Code_Label){
                if(territory.TerritoryManager__c != null && territory.TerritoryManager__r.IsActive == true && !territory.TerritoryManager__r.Email.contains('.invalid') && !mgrIds.contains(territory.TerritoryManager__c)){
                    userIdToEmailMap.put(territory.TerritoryManager__c,territory.TerritoryManager__r.Email);
                    mgrIds.add(territory.TerritoryManager__c);
                }
                if(territory.Zone__r.ZMMUser__c != null && territory.zone__r.ZMMUser__r.IsActive == true && !territory.Zone__r.ZMMUser__r.Email.contains('.invalid') && !mgrIds.contains(territory.Zone__r.ZMMUser__c)){
                    userIdToEmailMap.put(territory.Zone__r.ZMMUser__c,territory.Zone__r.ZMMUser__r.Email);
                    mgrIds.add(territory.Zone__r.ZMMUser__c);
                }
                if(territory.Zone__r.ZonalHead__c != null && territory.Zone__r.ZonalHead__r.IsActive == true && !territory.Zone__r.ZonalHead__r.Email.contains('.invalid') && !mgrIds.contains(territory.Zone__r.ZonalHead__c)){
                    userIdToEmailMap.put(territory.Zone__r.ZonalHead__c,territory.Zone__r.ZonalHead__r.Email);
                    mgrIds.add(territory.Zone__r.ZonalHead__c);
                }
                if(territory.SBU_Head_Id__c != null && territory.SBU__r.SBUUser__r.IsActive == true && !territory.SBU__r.SBUUser__r.Email.contains('.invalid') && !mgrIds.contains(territory.SBU_Head_Id__c)){
                    userIdToEmailMap.put(territory.SBU_Head_Id__c,territory.SBU__r.SBUUser__r.Email);
                    mgrIds.add(territory.SBU_Head_Id__c);
                }
                if(territory.SBU_Marketing_heads_Id__c != null && territory.SBU__r.SBUMarketingheads__r.IsActive == true && !territory.SBU__r.SBUMarketingheads__r.Email.contains('.invalid') && !mgrIds.contains(territory.SBU_Marketing_heads_Id__c)){
                    userIdToEmailMap.put(territory.SBU_Marketing_heads_Id__c,territory.SBU__r.SBUMarketingheads__r.Email);
                    mgrIds.add(territory.SBU_Marketing_heads_Id__c);
                }
            }
        }

        //email part
        try{
            //get OrgWideEmailAddressId
            //Need to check which one we can use.
            String owaId;
            String templateId;
            List<OrgWideEmailAddress> owaList = new List<OrgWideEmailAddress>();
            //get OWA ID
    		String OWAEmailIdLabel = System.Label.OWAEmailId;
            owaList = [SELECT Id FROM OrgWideEmailAddress WHERE Address = :OWAEmailIdLabel];
            if(owaList.size() > 0){
                owaId = owaList[0].Id;
            }

            //get Template ID
            List<EmailTemplate> emailTempList  = [SELECT Id FROM EmailTemplate WHERE DeveloperName = 'New_Product_Added' LIMIT 1];
            if(emailTempList.size() > 0){
                templateId = emailTempList[0].Id;
            }
            List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
            for(Id usrId : userIdToEmailMap.keySet()){
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                message.setOrgWideEmailAddressId(owaId);
                message.setTemplateID(templateId);
                message.setTargetObjectId(usrId);
                message.setTreatTargetObjectAsRecipient(false);
                message.setSaveAsActivity(false); 
                message.setWhatId(productId); //This is important for the merge fields in template to work
                message.setToAddresses(new String[] {userIdToEmailMap.get(usrId)});
                emails.add(message);
            }

        Messaging.sendEmail(emails);
        }catch(Exception exp){
            System.debug('Something went wrong - '+exp.getMessage());
        }
    }

    global void finish(Database.BatchableContext BC) {
    }
}