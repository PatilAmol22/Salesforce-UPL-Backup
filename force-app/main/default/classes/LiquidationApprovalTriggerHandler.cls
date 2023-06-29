/*
Class Name : LiquidationApprovalTriggerHandler
Description : Handler class for Liquidation Approval History trigger
Author : Bonny Mathews
Date : 05/08/2022
*/
public without sharing class LiquidationApprovalTriggerHandler {
    //Constant
    static final String salesOrgCodeAF = System.Label.AF_Sales_Org_Code_Label;
    static final String salesOrgCodeSWAL = System.Label.SWAL_Sales_Org_Code_Label;

    /*
    Method Name : updateMailIds
    Description : Add the email id of territory users for AF and SWAL
    */
    public static void updateMailIds(List<Liquidation_Approval_History__c> liqApprovalHistoryNewList){
        String SalesOrgCode;
        String territoryId;
        String approvalStatus;
        Map<String,String> userRoleToIdMap = new Map<String,String>();
        Map<String,String> userIdToEmailMap = new Map<String,String>();
        Set<Id> territoryUsersIdSet = new Set<Id>();
        List<User> userList = new List<User>();

        for(Liquidation_Approval_History__c liqAppHisObj : liqApprovalHistoryNewList){
            territoryId = liqAppHisObj.Territory__c;
            approvalStatus = liqAppHisObj.Approval_Status__c;
        }

        if(approvalStatus == 'In Progress'){
            for(Territory_Distributor__c terr : [SELECT Id, Sales_Org_Code__c, FMM_User_Id__c, TerritoryManager__c, Regional_Manager_Id__c, SBU_Marketing_heads_Id__c, Zonal_Manager_Id__c, Zonal_Marketing_Manager_1_Id__c, SBU_Head_Id__c 
                                                FROM Territory_Distributor__c WHERE Id = :territoryId]){
                SalesOrgCode = terr.Sales_Org_Code__c;
                if(terr.TerritoryManager__c != null){
                    userRoleToIdMap.put('TM',terr.TerritoryManager__c);
                    territoryUsersIdSet.add(terr.TerritoryManager__c);
                }
                if(terr.FMM_User_Id__c != null){
                    userRoleToIdMap.put('FMM',terr.FMM_User_Id__c);
                    territoryUsersIdSet.add(terr.TerritoryManager__c);
                }
                if(terr.SBU_Marketing_heads_Id__c != null){
                    userRoleToIdMap.put('SBUM',terr.SBU_Marketing_heads_Id__c);
                    territoryUsersIdSet.add(terr.SBU_Marketing_heads_Id__c);
                }
                if(terr.SBU_Head_Id__c  != null){
                    userRoleToIdMap.put('SBUH',terr.SBU_Head_Id__c);
                    territoryUsersIdSet.add(terr.SBU_Head_Id__c);
                }
                if(terr.Regional_Manager_Id__c != null){
                    userRoleToIdMap.put('RM',terr.Regional_Manager_Id__c);
                    territoryUsersIdSet.add(terr.Regional_Manager_Id__c);
                }
                if(terr.Zonal_Manager_Id__c != null){
                    userRoleToIdMap.put('ZM',terr.Zonal_Manager_Id__c);
                    territoryUsersIdSet.add(terr.Zonal_Manager_Id__c);
                }
                if(terr.Zonal_Marketing_Manager_1_Id__c != null){
                    userRoleToIdMap.put('ZMM',terr.Zonal_Marketing_Manager_1_Id__c);
                    territoryUsersIdSet.add(terr.Zonal_Marketing_Manager_1_Id__c);
                }
            }
            
            //Get Email fro User object
            if(territoryUsersIdSet.size() > 0){
                for(user usr : [SELECT Id, Email, IsActive FROM User Where Id IN :territoryUsersIdSet]){
                    if(usr.IsActive){
                        userIdToEmailMap.put(usr.Id,usr.Email);
                    }
                }
            }
            //Assigning email to respective field based on role
            for(Liquidation_Approval_History__c liqApprovalHisObj : liqApprovalHistoryNewList){
                for(String role : userRoleToIdMap.keySet()){
                    if(role == 'TM'){
                        liqApprovalHisObj.Territory_Manager_Email__c = userIdToEmailMap.get(userRoleToIdMap.get(role));
                    }else if(role == 'FMM' && SalesOrgCode == salesOrgCodeSWAL){
                        liqApprovalHisObj.SWAL_FMM_User_Email__c = userIdToEmailMap.get(userRoleToIdMap.get(role));
                    }else if(role == 'SBUM' && SalesOrgCode == salesOrgCodeAF){
                        liqApprovalHisObj.Territory_SBU_Marketing_Head_EmailID__c = userIdToEmailMap.get(userRoleToIdMap.get(role));
                    }else if(role == 'SBUH' && SalesOrgCode == salesOrgCodeAF){
                        liqApprovalHisObj.Territory_SBU_User_EmailID__c = userIdToEmailMap.get(userRoleToIdMap.get(role));
                    }else if(role == 'RM' && SalesOrgCode == salesOrgCodeSWAL){
                        liqApprovalHisObj.SWAL_Region_Head_Email__c = userIdToEmailMap.get(userRoleToIdMap.get(role));
                    }else if(role == 'ZM'){
                        liqApprovalHisObj.Zonal_Head_Email__c = userIdToEmailMap.get(userRoleToIdMap.get(role));
                    }else if(role == 'ZMM' ){
                        liqApprovalHisObj.ZMM_User_Email__c = userIdToEmailMap.get(userRoleToIdMap.get(role));
                    }
                }
            }
        }
    }

    /*
    Method Name : sendMailOnLiquidationSubmission
    Description : Trigger mail to Territory Manager and Zone/Regional Head once Territory Manager submits the liquidation for approval
    */
    public static void sendMailOnLiquidationSubmission(List<Liquidation_Approval_History__c> liqApprovalHistoryNewList, Map<Id,Liquidation_Approval_History__c> liqApprovalHistoryOldMap){
        String recordId;
        String[] toCCAddressList = new List<String>();
        String salesOrgCode;
        String newStatus;
        String oldStatus;
        String tmMail;
        String afManagerMail;
        String swalManagerMail;
        String targetUsrId;
        String templateId;

        for(Liquidation_Approval_History__c liqAppObj : liqApprovalHistoryNewList){
            recordId  = liqAppObj.Id;
            salesOrgCode = liqAppObj.Sales_Org_Code__c;
            newStatus = liqAppObj.Approval_Status__c;
            oldStatus = liqApprovalHistoryOldMap.get(liqAppObj.Id).Approval_Status__c;
            tmMail = liqAppObj.Territory_Manager_Email__c;
            if(salesOrgCode == salesOrgCodeAF){
                if(!String.isBlank(liqAppObj.ZMM_User_Email__c)){
                    afManagerMail = liqAppObj.ZMM_User_Email__c;
                }else{
                    afManagerMail = liqAppObj.Zonal_Head_Email__c;
                }
            }else if(salesOrgCode == salesOrgCodeSWAL){
                if(!String.isBlank(liqAppObj.SWAL_Region_Head_Email__c)){
                    swalManagerMail = liqAppObj.SWAL_Region_Head_Email__c;
                }else if(!String.isBlank(liqAppObj.SWAL_FMM_User_Email__c)){
                    swalManagerMail = liqAppObj.SWAL_Region_Head_Email__c;
                }else{
                    swalManagerMail = liqAppObj.ZMM_User_Email__c;
                }
            }
        }
        
        if((newStatus == 'Pending for Approval') && (oldStatus == 'In Progress')){
            List<EmailTemplate> emailTempList  = [SELECT Id FROM EmailTemplate WHERE DeveloperName = 'Liquidation_Submission_for_Manager' LIMIT 1];
            if(emailTempList.size() > 0){
                templateId = emailTempList[0].Id;
            }

            if(salesOrgCode == salesOrgCodeAF){
                List<User> usrList = [SELECT Id From User WHERE Email = :afManagerMail AND IsActive = True LIMIT 1];
                if(usrList.size() > 0){
                    targetUsrId = usrList[0].Id;
                }
                toCCAddressList.add(tmMail);
            }else if(salesOrgCode == salesOrgCodeSWAL){
                List<User> usrList = [SELECT Id From User WHERE Email = :swalManagerMail AND IsActive = True LIMIT 1];
                if(usrList.size() > 0){
                    targetUsrId = usrList[0].Id;
                }
                toCCAddressList.add(tmMail);
            }

            //Send Email
            senEmail(templateId,targetUsrId,toCCAddressList,recordId,false);
        }
    }

    /*
    Method Name : sendMailOnLiquidationApproval
    Description : Trigger mail to Territory Manager and Zone/Regional Head, once Zoneal/Regional Head approves the liquidation
    */
    public static void sendMailOnLiquidationApproval(List<Liquidation_Approval_History__c> liqApprovalHistoryNewList, Map<Id,Liquidation_Approval_History__c> liqApprovalHistoryOldMap){
        String recordId;
        String[] toCCAddressList = new List<String>();
        String salesOrgCode;
        String newStatus;
        String oldStatus;
        String tmMail;
        String afManagerMail;
        String swalManagerMail;
        String targetUsrId;
        String templateId;
        String fiscalYear;
        String territoryId;
        String month;

        for(Liquidation_Approval_History__c liqAppObj : liqApprovalHistoryNewList){
            recordId  = liqAppObj.Id;
            salesOrgCode = liqAppObj.Sales_Org_Code__c;
            newStatus = liqAppObj.Approval_Status__c;
            oldStatus = liqApprovalHistoryOldMap.get(liqAppObj.Id).Approval_Status__c;
            tmMail = liqAppObj.Territory_Manager_Email__c;
            if(salesOrgCode == salesOrgCodeAF){
                if(!String.isBlank(liqAppObj.ZMM_User_Email__c)){
                    afManagerMail = liqAppObj.ZMM_User_Email__c;
                }else{
                    afManagerMail = liqAppObj.Zonal_Head_Email__c;
                }
            }else if(salesOrgCode == salesOrgCodeSWAL){
                if(!String.isBlank(liqAppObj.SWAL_Region_Head_Email__c)){
                    swalManagerMail = liqAppObj.SWAL_Region_Head_Email__c;
                }else if(!String.isBlank(liqAppObj.SWAL_FMM_User_Email__c)){
                    swalManagerMail = liqAppObj.SWAL_Region_Head_Email__c;
                }else{
                    swalManagerMail = liqAppObj.ZMM_User_Email__c;
                }
            }
            fiscalYear = liqAppObj.LAP_Fiscal_Year__c;
            territoryId = liqAppObj.Territory__c;
            month = liqAppObj.Month__c;
        }
        
        if((newStatus == 'Approved') && (oldStatus == 'Pending for Approval')){
            List<User> usrList = [SELECT Id From User WHERE Email = :tmMail AND IsActive = True LIMIT 1];
            if(usrList.size() > 0){
                targetUsrId = usrList[0].Id;
            }

            List<EmailTemplate> emailTempList  = [SELECT Id FROM EmailTemplate WHERE DeveloperName = 'Liquidation_Approval' LIMIT 1];
            if(emailTempList.size() > 0){
                templateId = emailTempList[0].Id;
            }

            if(salesOrgCode == salesOrgCodeAF){ 
                toCCAddressList.add(afManagerMail);

                // Email to SBU
                sendEmailToSBU(territoryId, month, fiscalYear);
            }else if(salesOrgCode == salesOrgCodeSWAL){
                toCCAddressList.add(swalManagerMail);

                // Email to ZML
                sendEmailToZML(territoryId, month, fiscalYear);
            }

            //Send Email
            senEmail(templateId,targetUsrId,toCCAddressList,recordId,false);
                                    
            //logic to reset the Opening inv field
            resetOpeningInvFlag(fiscalYear, territoryId);
        }else if((newStatus == 'Approved') && (oldStatus == 'In Progress')){
            List<EmailTemplate> emailTempList  = [SELECT Id FROM EmailTemplate WHERE DeveloperName = 'Liquidation_Approval_for_Manager' LIMIT 1];
            if(emailTempList.size() > 0){
                templateId = emailTempList[0].Id;
            }
            if(salesOrgCode == salesOrgCodeAF){ 
                List<User> usrList = [SELECT Id From User WHERE Email = :afManagerMail AND IsActive = True LIMIT 1];
                if(usrList.size() > 0){
                    targetUsrId = usrList[0].Id;
                }

                // Email to SBU
                sendEmailToSBU(territoryId, month, fiscalYear);
            }else if(salesOrgCode == salesOrgCodeSWAL){
                List<User> usrList = [SELECT Id From User WHERE Email = :swalManagerMail AND IsActive = True LIMIT 1];
                if(usrList.size() > 0){
                    targetUsrId = usrList[0].Id;
                }

                // Email to ZML
                sendEmailToZML(territoryId, month, fiscalYear);
            }

            //Send Email
            senEmail(templateId,targetUsrId,toCCAddressList,recordId,false);
            
            //logic to reset the Opening inv field
            resetOpeningInvFlag(fiscalYear, territoryId);
        }
    }

    /*
    Method Name : sendMailOnLiquidationRejection
    Description : Trigger mail to Territory Manager and Zone/Regional Head, once Zoneal/Regional Head rejects the liquidation
    */
    public static void sendMailOnLiquidationRejection(List<Liquidation_Approval_History__c> liqApprovalHistoryNewList, Map<Id,Liquidation_Approval_History__c> liqApprovalHistoryOldMap){
        String recordId;
        String[] toCCAddressList = new List<String>();
        String salesOrgCode;
        String newStatus;
        String oldStatus;
        String tmMail;
        String afManagerMail;
        String swalManagerMail;
        String targetUsrId;
        String templateId;

        for(Liquidation_Approval_History__c liqAppObj : liqApprovalHistoryNewList){
            recordId  = liqAppObj.Id;
            salesOrgCode = liqAppObj.Sales_Org_Code__c;
            newStatus = liqAppObj.Approval_Status__c;
            oldStatus = liqApprovalHistoryOldMap.get(liqAppObj.Id).Approval_Status__c;
            tmMail = liqAppObj.Territory_Manager_Email__c;
            if(salesOrgCode == salesOrgCodeAF){
                if(!String.isBlank(liqAppObj.ZMM_User_Email__c)){
                    afManagerMail = liqAppObj.ZMM_User_Email__c;
                }else{
                    afManagerMail = liqAppObj.Zonal_Head_Email__c;
                }
            }else if(salesOrgCode == salesOrgCodeSWAL){
                if(!String.isBlank(liqAppObj.SWAL_Region_Head_Email__c)){
                    swalManagerMail = liqAppObj.SWAL_Region_Head_Email__c;
                }else if(!String.isBlank(liqAppObj.SWAL_FMM_User_Email__c)){
                    swalManagerMail = liqAppObj.SWAL_Region_Head_Email__c;
                }else{
                    swalManagerMail = liqAppObj.ZMM_User_Email__c;
                }
            }
        }
        
        if((newStatus == 'Rejected') && (oldStatus == 'Pending for Approval')){
            List<User> usrList = [SELECT Id From User WHERE Email = :tmMail AND IsActive = True LIMIT 1];
            if(usrList.size() > 0){
                targetUsrId = usrList[0].Id;
            }

            List<EmailTemplate> emailTempList  = [SELECT Id FROM EmailTemplate WHERE DeveloperName = 'Liquidation_Rejection_for_TM' LIMIT 1];
            if(emailTempList.size() > 0){
                templateId = emailTempList[0].Id;
            }

            if(salesOrgCode == salesOrgCodeAF){ 
                toCCAddressList.add(afManagerMail);
            }else if(salesOrgCode == salesOrgCodeSWAL){
                toCCAddressList.add(swalManagerMail);
            }

            //Send Email
            senEmail(templateId,targetUsrId,toCCAddressList,recordId,false);
        }
    }

    /*
    Method Name : sendMailOnLiquidationEditApproval
    Description : Trigger mail to Territory Manager and Zone/Regional Head, once Zoneal/Regional Head edit and approves the liquidation
    */
    public static void sendMailOnLiquidationEditApproval(List<Liquidation_Approval_History__c> liqApprovalHistoryNewList, Map<Id,Liquidation_Approval_History__c> liqApprovalHistoryOldMap){
        String recordId;
        String[] toCCAddressList = new List<String>();
        String salesOrgCode;
        String newStatus;
        String oldStatus;
        String tmMail;
        String afManagerMail;
        String swalManagerMail;
        String targetUsrId;
        String templateId;
        String fiscalYear;
        String territoryId;
        String month;

        for(Liquidation_Approval_History__c liqAppObj : liqApprovalHistoryNewList){
            recordId  = liqAppObj.Id;
            salesOrgCode = liqAppObj.Sales_Org_Code__c;
            newStatus = liqAppObj.Approval_Status__c;
            oldStatus = liqApprovalHistoryOldMap.get(liqAppObj.Id).Approval_Status__c;
            tmMail = liqAppObj.Territory_Manager_Email__c;
            if(salesOrgCode == salesOrgCodeAF){
                if(!String.isBlank(liqAppObj.ZMM_User_Email__c)){
                    afManagerMail = liqAppObj.ZMM_User_Email__c;
                }else{
                    afManagerMail = liqAppObj.Zonal_Head_Email__c;
                }
            }else if(salesOrgCode == salesOrgCodeSWAL){
                if(!String.isBlank(liqAppObj.SWAL_Region_Head_Email__c)){
                    swalManagerMail = liqAppObj.SWAL_Region_Head_Email__c;
                }else if(!String.isBlank(liqAppObj.SWAL_FMM_User_Email__c)){
                    swalManagerMail = liqAppObj.SWAL_Region_Head_Email__c;
                }else{
                    swalManagerMail = liqAppObj.ZMM_User_Email__c;
                }
            }
            fiscalYear = liqAppObj.LAP_Fiscal_Year__c;
            territoryId = liqAppObj.Territory__c;
            month = liqAppObj.Month__c;
        }

        if((newStatus == 'Edit and Approved') && (oldStatus == 'Pending for Approval')){
            List<User> usrList = [SELECT Id From User WHERE Email = :tmMail AND IsActive = True LIMIT 1];
            if(usrList.size() > 0){
                targetUsrId = usrList[0].Id;
            }

            List<EmailTemplate> emailTempList  = [SELECT Id FROM EmailTemplate WHERE DeveloperName = 'Liquidation_Edited_and_Approved_for_TM' LIMIT 1];
            if(emailTempList.size() > 0){
                templateId = emailTempList[0].Id;
            }

            if(salesOrgCode == salesOrgCodeAF){ 
                toCCAddressList.add(afManagerMail);
                // Email to SBU
            sendEmailToSBU(territoryId, month, fiscalYear);
            }else if(salesOrgCode == salesOrgCodeSWAL){
                toCCAddressList.add(swalManagerMail);
                // Email to ZML
                sendEmailToZML(territoryId, month, fiscalYear);
            }

            //Send Email
            senEmail(templateId,targetUsrId,toCCAddressList,recordId,false);
            
            //logic to reset the Opening inv field
            resetOpeningInvFlag(fiscalYear, territoryId);
        }
    }

    /*
    Method Name : senEmail
    Description : Common method to send all mails
    */
    public static void senEmail( String mailTemplateId, String targetId, String[] addressList, String recordId, Boolean isSBUUsr){
        try{
            //get OrgWideEmailAddressId
            String owaEmail = System.Label.OWAEmailId;
            List<OrgWideEmailAddress> owaList = new List<OrgWideEmailAddress>();
            
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            //get OWA ID
            owaList = [SELECT Id FROM OrgWideEmailAddress WHERE Address = :owaEmail];
            if(owaList.size() > 0){
                message.setOrgWideEmailAddressId(owaList[0].Id);
            }
            message.setTargetObjectId(targetId);
            message.setSaveAsActivity(false); 
            message.setTemplateID(mailTemplateId); 
            message.setWhatId(recordId); //This is important for the merge fields in template to work
            if(isSBUUsr){
                message.toAddresses = addressList;
            }else{
                message.ccAddresses = addressList;
            }
            Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            
            if (results[0].success) 
            {
                System.debug('The email was sent successfully.');
            } else {
                System.debug('The email failed to send: ' +  results[0].errors[0].message);
            }
        }catch(Exception exp){
            System.debug('Something went wrong - '+exp.getMessage());
        }
    }

    /**
     Method Name : resetOpeningInvFlag
     Description : This method will reset the Is From Liq Module checkbox field on Opening Inventory Object once the status is changed to Approved or Edit and Approved
     */

     public static void resetOpeningInvFlag(String fiscalYear, String territoryId){
        List<Opening_Inventory2__c> openingInvToUpdateList = new List<Opening_Inventory2__c>();

        for(Opening_Inventory2__c opnInv : [SELECT Id,Is_From_Liq_Module__c FROM Opening_Inventory2__c WHERE Multi_Country_Formula_Key__c = :fiscalYear AND Territory__c  = :territoryId AND Is_From_Liq_Module__c  = true]){
            Opening_Inventory2__c openingInv = new Opening_Inventory2__c();
            openingInv.Id = opnInv.Id;
            openingInv.Is_From_Liq_Module__c = false;
            openingInvToUpdateList.add(openingInv);
        }

        If(openingInvToUpdateList.size() > 0){
            UPDATE openingInvToUpdateList;
        }
     }

     /*
    Method Name : sendEmailToSBU
    Description : Trigger mail to SUH and SBUM when all territories under under a zone has completed the the liquidation
    */
    public static void sendEmailToSBU(String territoryId, String month, String fiscalYear){
        List<Territory_Distributor__c> allTerrUnderZoneList = new List<Territory_Distributor__c>();
        List<Liquidation_Approval_History__c> allAppLAHList = new List<Liquidation_Approval_History__c>();
        String zoneId;
        String sbuhEmail;
        String sbumEmail;
        String targetUsrId;
        String templateId;
        String recLAHId;
        String[] toAddressList = new List<String>();
        for(Territory_Distributor__c terr : [SELECT Zone__c,Zone__r.SBUCode__r.SBUUser__c FROM Territory_Distributor__c WHERE Id = :territoryId]){
            zoneId = terr.Zone__c;
            targetUsrId = terr.Zone__r.SBUCode__r.SBUUser__c;
        }

        if(zoneId != null){
            allTerrUnderZoneList = [SELECT Id, Name FROM Territory_Distributor__c WHERE Zone__c  = :zoneId  AND Present_in_KEDE__c = true AND (NOT (Name LIKE 'CIL%' OR Name LIKE 'SAIB%' OR Name LIKE 'Vector%' OR Name LIKE '%-b' OR Name LIKE '%- b' OR Name LIKE '%Provision'))];

            allAppLAHList = [SELECT Id, Name,Territory__r.Name,  Approval_Status__c,Territory_SBU_User_EmailID__c,Territory_SBU_Marketing_Head_EmailID__c FROM Liquidation_Approval_History__c WHERE Territory__r.Zone__c  = :zoneId AND Month__c = :month  AND LAP_Fiscal_Year__c = :fiscalYear AND (Approval_Status__c = 'Approved' OR Approval_Status__c = 'Edit and Approved')];
            sbuhEmail = allAppLAHList[0].Territory_SBU_User_EmailID__c;
            sbumEmail = allAppLAHList[0].Territory_SBU_Marketing_Head_EmailID__c;
            recLAHId = allAppLAHList[0].Id;
            if(allTerrUnderZoneList.size() == allAppLAHList.size()){
                List<EmailTemplate> emailTempList  = [SELECT Id FROM EmailTemplate WHERE DeveloperName = 'Liquidation_Zone_Completion' LIMIT 1];
                if(emailTempList.size() > 0){
                    templateId = emailTempList[0].Id;
                }
                if(sbuhEmail != null ){
                    toAddressList.add(sbuhEmail);
                }
                if(sbumEmail != null){
                    toAddressList.add(sbumEmail);
                }
                System.debug('Send mail to SBU');
                senEmail(templateId,targetUsrId,toAddressList,recLAHId,true);
            }else{
                System.debug('Donot Send mail to SBU');
            }
        }
    }
    
    /*
    Method Name : sendEmailTo ZMM
    Description : Trigger mail to ZMM when all territories under under a region has completed the the liquidation
    */
    public static void sendEmailToZML(String territoryId, String month, String fiscalYear){
        List<Territory_Distributor__c> allTerrUnderRegionList = new List<Territory_Distributor__c>();
        List<Liquidation_Approval_History__c> allAppLAHList = new List<Liquidation_Approval_History__c>();
        String regionId;
        String zmlEmail;
        String zbhEmail;
        String targetUsrId;
        String templateId;
        String recLAHId;
        String[] toAddressList = new List<String>();
        for(Territory_Distributor__c terr : [SELECT Region__c, Region__r.Zone__r.ZMMUser__c FROM Territory_Distributor__c WHERE Id = :territoryId]){
            regionId = terr.Region__c;
            targetUsrId = terr.Region__r.Zone__r.ZMMUser__c;
        }

        if(regionId != null){
            allTerrUnderRegionList = [SELECT Id, Name FROM Territory_Distributor__c WHERE Region__c  = :regionId  AND Present_in_KEDE__c = true AND (NOT (Name LIKE 'CIL%' OR Name LIKE 'SAIB%' OR Name LIKE 'Vector%' OR Name LIKE '%-b' OR Name LIKE '%- b' OR Name LIKE '%Provision'))];

            allAppLAHList = [SELECT Id, Name,Territory__r.Name,  Approval_Status__c,ZMM_User_Email__c,Zonal_Head_Email__c FROM Liquidation_Approval_History__c WHERE Territory__r.Region__c  = :regionId AND Month__c = :month  AND LAP_Fiscal_Year__c = :fiscalYear AND (Approval_Status__c = 'Approved' OR Approval_Status__c = 'Edit and Approved')];
            zmlEmail = allAppLAHList[0].ZMM_User_Email__c;
            zbhEMail = allAppLAHList[0].Zonal_Head_Email__c;
            recLAHId = allAppLAHList[0].Id;
            if(allTerrUnderRegionList.size() == allAppLAHList.size()){
                List<EmailTemplate> emailTempList  = [SELECT Id FROM EmailTemplate WHERE DeveloperName = 'Liquidation_Region_Completion' LIMIT 1];
                if(emailTempList.size() > 0){
                    templateId = emailTempList[0].Id;
                }
                if(zmlEmail != null ){
                    toAddressList.add(zmlEmail);
                }
                if(zbhEmail != null){
                    toAddressList.add(zbhEmail);
                }
                System.debug('Send mail to ZMM');
                senEmail(templateId,targetUsrId,toAddressList,recLAHId,true);
            }else{
                System.debug('Donot Send mail to ZMM');
            }
        }
    }
    
    /*
    Method Name : Update Liquidation Submitted Checkbox
    Description : 
    */
    public static void updateProductLiquidationSubmitted(List<Liquidation_Approval_History__c> liqApprovalHistoryNewList, Map<Id,Liquidation_Approval_History__c> liqApprovalHistoryOldMap){
        Set<Id> lapIds = new Set<Id>();
        Map<Id,String> lahtoStatusMap = new Map<Id,String>();
        List<Liquidation2__c> liquidationList = new List<Liquidation2__c>();
        String month;
        for(Liquidation_Approval_History__c lah :liqApprovalHistoryNewList ){
            month = lah.Month__c; 
            if((lah.Approval_Status__c =='Approved'|| lah.Approval_Status__c == 'Edit and Approved')&&((lah.Approval_Status__c != liqApprovalHistoryOldMap.get(lah.Id).Approval_Status__c))){
                lapIds.add(lah.LAP__c);
                lahtoStatusMap.put(lah.LAP__c,lah.Approval_Status__c);
            }
            if(lah.Approval_Status__c == 'Unlocked' && (liqApprovalHistoryOldMap.get(lah.Id).Approval_Status__c == 'Approved' || liqApprovalHistoryOldMap.get(lah.Id).Approval_Status__c == 'Edit and Approved')){
                lapIds.add(lah.LAP__c);
                lahtoStatusMap.put(lah.LAP__c,lah.Approval_Status__c);
            }
        }
        
        for(Liquidation2__c liq:[SELECT Id,Sales_Org_Code__c,Liquidation_Annual_Plan__c,submitted_trade__c,submitted_Trade_SWAL__c FROM Liquidation2__c WHERE Liquidation_Annual_Plan__c IN:lapIds AND Month__c =:month]){
            if(liq.Sales_Org_Code__c == salesOrgCodeAF){
                if(lahtoStatusMap.get(liq.Liquidation_Annual_Plan__c) == 'Unlocked'){
                   liq.submitted_trade__c = false;
                }
                else{
                   liq.submitted_trade__c = true; 
                }
            	
            }
            else if(liq.Sales_Org_Code__c == salesOrgCodeSWAL){
                if(lahtoStatusMap.get(liq.Liquidation_Annual_Plan__c) == 'Unlocked'){
            		liq.submitted_Trade_SWAL__c  = false;
                }
                else{
                    liq.submitted_Trade_SWAL__c  = true;
                }
            }
            liquidationList.add(liq);
        }
        update liquidationList;
    }
}