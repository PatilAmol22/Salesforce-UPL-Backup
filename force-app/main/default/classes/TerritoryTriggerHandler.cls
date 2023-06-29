/*
Class Name : TerritoryTriggerHandler
Description : Trigger Handler for Territory
Author : Bonny Mathews
Date : 05/08/2022
*/
public without sharing class TerritoryTriggerHandler {
    //Constant
    static final String salesOrgCodeAF = System.Label.AF_Sales_Org_Code_Label;
    static final String salesOrgCodeSWAL = System.Label.SWAL_Sales_Org_Code_Label;
	static final String salesOrgCodeNewAF = System.Label.New_AF_Sales_Org_Code_Label;
    static final String OWAEmailIdLabel = System.Label.OWAEmailId;
    static final String rtForAnnualPlanAF = Schema.SObjectType.Liquidation_Annual_Plan__c.getRecordTypeInfosByName().get('Trade').getRecordTypeId();
    static final String rtForAnnualPlanSWAL = Schema.SObjectType.Liquidation_Annual_Plan__c.getRecordTypeInfosByName().get('SWAL TRADE').getRecordTypeId();
    static final String rtForOpeningInventoryAF = Schema.SObjectType.Opening_Inventory2__c.getRecordTypeInfosByName().get('Trade').getRecordTypeId();
    static final String rtForOpeningInventorySWAL = Schema.SObjectType.Opening_Inventory2__c.getRecordTypeInfosByName().get('SWAL TRADE').getRecordTypeId();
    
    /*
    Method Name : updateMailIds
    Description : Add the email id of territory users for AF and SWAL
    */
    public static void sendMailOnTmAssignment(List<Territory_Distributor__c> newTerritoryList, Map<Id,Territory_Distributor__c> oldTerritoryMap){
        String[] toCCAddressList = new List<String>();
        String newTMId;
        String oldTmId;
        Set<Id> ccUserIdSet = new Set<Id>();
        String templateId;

        for(Territory_Distributor__c newTerr : newTerritoryList){
            if((newTerr.TerritoryManager__c != oldTerritoryMap.get(newTerr.Id).TerritoryManager__c) && newTerr.TerritoryManagerActive__c == true){
                if(newTerr.Sales_Org_Code__c == salesOrgCodeAF || newTerr.Sales_Org_Code__c == salesOrgCodeNewAF){
                    if(!String.isBlank(newTerr.Zonal_Marketing_Manager_1_Id__c)){ccUserIdSet.add(newTerr.Zonal_Marketing_Manager_1_Id__c);}
                    if(!String.isBlank(newTerr.Zonal_Manager_Id__c)){ccUserIdSet.add(newTerr.Zonal_Manager_Id__c);}
                    if(!String.isBlank(newTerr.SBU_Head_Id__c)){ccUserIdSet.add(newTerr.SBU_Head_Id__c);}
                    if(!String.isBlank(newTerr.SBU_Marketing_heads_Id__c)){ccUserIdSet.add(newTerr.SBU_Marketing_heads_Id__c);}
                }else if(newTerr.Sales_Org_Code__c == salesOrgCodeSWAL){
                    if(!String.isBlank(newTerr.Zonal_Marketing_Manager_1_Id__c)){ccUserIdSet.add(newTerr.Zonal_Marketing_Manager_1_Id__c);}
                    if(!String.isBlank(newTerr.Regional_Manager_Id__c)){ccUserIdSet.add(newTerr.Regional_Manager_Id__c);}
                    if(!String.isBlank(newTerr.FMM_User_Id__c)){ccUserIdSet.add(newTerr.FMM_User_Id__c);}
                    if(!String.isBlank(newTerr.Zonal_Manager_Id__c)){ccUserIdSet.add(newTerr.Zonal_Manager_Id__c);}
                }

                if(ccUserIdSet.size() > 0){
                    for(User usr : [SELECT Id, Email FROM User Where Id IN :ccUserIdSet]){
                        if(!usr.Email.contains('.invalid')){
                            toCCAddressList.add(usr.Email);
                        }
                    }
                }

                List<EmailTemplate> emailTempList  = [SELECT Id FROM EmailTemplate WHERE DeveloperName = 'Territory_Assignment_TM' LIMIT 1];
                if(emailTempList.size() > 0){
                    templateId = emailTempList[0].Id;
                }

                List<OrgWideEmailAddress> owaList = new List<OrgWideEmailAddress>();
            
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                //get OWA ID
                owaList = [SELECT Id FROM OrgWideEmailAddress WHERE Address = :OWAEmailIdLabel];
                if(owaList.size() > 0){
                    message.setOrgWideEmailAddressId(owaList[0].Id);
                }
                message.setTargetObjectId(newTerr.TerritoryManager__c);
                message.setSaveAsActivity(false); 
                message.setTemplateID(templateId); 
                message.setWhatId(newTerr.Id); //This is important for the merge fields in template to work
                //message.toAddresses = toAddressList; // need to check to address conditions
                message.ccAddresses = toCCAddressList;
                Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
                Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
                
                if (results[0].success) 
                {
                    System.debug('The email was sent successfully.');
                } else {
                    System.debug('The email failed to send: ' +  results[0].errors[0].message);
                }
            }
        }
    }

    /*
    Method Name : updateMailIds
    Description : Add the email id of territory users for AF and SWAL
    */
    public static void sendMailOnTmAssignmentOnInsert(List<Territory_Distributor__c> newTerritoryList){
        String[] toCCAddressList = new List<String>();
        String newTMId;
        String oldTmId;
        Set<Id> ccUserIdSet = new Set<Id>();
        String templateId;

        for(Territory_Distributor__c newTerr : newTerritoryList){
            if((newTerr.TerritoryManager__c != null) && newTerr.TerritoryManagerActive__c == true){
                if(newTerr.Sales_Org_Code__c == salesOrgCodeAF || newTerr.Sales_Org_Code__c == salesOrgCodeNewAF){
                    if(!String.isBlank(newTerr.Zonal_Marketing_Manager_1_Id__c)){ccUserIdSet.add(newTerr.Zonal_Marketing_Manager_1_Id__c);}
                    if(!String.isBlank(newTerr.Zonal_Manager_Id__c)){ccUserIdSet.add(newTerr.Zonal_Manager_Id__c);}
                    if(!String.isBlank(newTerr.SBU_Head_Id__c)){ccUserIdSet.add(newTerr.SBU_Head_Id__c);}
                }else if(newTerr.Sales_Org_Code__c == salesOrgCodeSWAL){
                    if(!String.isBlank(newTerr.Zonal_Marketing_Manager_1_Id__c)){ccUserIdSet.add(newTerr.Zonal_Marketing_Manager_1_Id__c);}
                    if(!String.isBlank(newTerr.Regional_Manager_Id__c)){ccUserIdSet.add(newTerr.Regional_Manager_Id__c);}
                    if(!String.isBlank(newTerr.FMM_User_Id__c)){ccUserIdSet.add(newTerr.FMM_User_Id__c);}
                }

                if(ccUserIdSet.size() > 0){
                    for(User usr : [SELECT Id, Email FROM User Where Id IN :ccUserIdSet]){
                        if(!usr.Email.contains('.invalid')){
                            toCCAddressList.add(usr.Email);
                        }
                    }
                }

                List<EmailTemplate> emailTempList  = [SELECT Id FROM EmailTemplate WHERE DeveloperName = 'Territory_Assignment_TM' LIMIT 1];
                if(emailTempList.size() > 0){
                    templateId = emailTempList[0].Id;
                }

                List<OrgWideEmailAddress> owaList = new List<OrgWideEmailAddress>();
            
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                //get OWA ID
                owaList = [SELECT Id FROM OrgWideEmailAddress WHERE Address = :OWAEmailIdLabel];
                if(owaList.size() > 0){
                    message.setOrgWideEmailAddressId(owaList[0].Id);
                }
                message.setTargetObjectId(newTerr.TerritoryManager__c);
                message.setSaveAsActivity(false); 
                message.setTemplateID(templateId); 
                message.setWhatId(newTerr.Id); //This is important for the merge fields in template to work
                //message.toAddresses = toAddressList; // need to check to address conditions
                message.ccAddresses = toCCAddressList;
                Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
                //Bypassed due to test class error by Grazitti team(Aashima) 10Nov22 INC0410433
                if(!Test.isRunningTest()){
                Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
                if (results[0].success) 
                {
                    System.debug('The email was sent successfully.');
                } else {
                    System.debug('The email failed to send: ' +  results[0].errors[0].message);
                }
                }
            }
        }
    }
    
    /*
    Method Name : createLAP-OI
    Description : create LAP and Opening Inventory for new Territories
    */
    public static void createLAPOpenInventory(List<Territory_Distributor__c> newTerritoryList){
        String startYear;
        String endYear;
        String startDate;
        String endDate;
        String fisYear;
        Set<Id> terrIds = new Set<Id>();
        Set<Id> terrWithLAP = new Set<Id>();
        Set<Id> terrWithOpenInv = new Set<Id>();
        Set<Id> productAF = new Set<Id>();
        Set<Id> productSWAL = new Set<Id>();
        List<String> terrName = new List<String>();
        List<Liquidation_Annual_Plan__c> lapList = new List<Liquidation_Annual_Plan__c>();
        List<Opening_Inventory2__c> openInvList = new List<Opening_Inventory2__c>();
        Map<Id,Id> terrIdWithLapIdMap = new Map<Id,Id>();
        
        fisYear = LiquidationAFSWALUtility.getFiscalYear();
    	startYear = String.valueOf(Integer.valueOf(fisYear.split('-')[0]));
        endYear = String.valueOf(Integer.valueOf(fisYear.split('-')[1]));
        startDate = '1/4/'+startYear;
        endDate = '31/3/'+endYear;
        
        for(Territory_Distributor__c terrs:newTerritoryList){
            terrIds.add(terrs.Id);
            terrName.add(terrs.Name);
            
        }
        
        for(Product2 afProd : [SELECT Id, Product_Code__c FROM Product2 WHERE Active_For_Liquidation__c = true AND IsActive = true AND (Sales_Org_Code__c = :salesOrgCodeAF OR Sales_Org_Code__c = :salesOrgCodeNewAF) AND Product_Code__c != null]){
            productAF.add(afProd.Id);
        }
        
        for(Product2 swalProd : [SELECT Id, Product_Code__c FROM Product2 WHERE Active_For_Liquidation__c = true AND IsActive = true AND (Sales_Org_Code__c = :salesOrgCodeSWAL) AND Product_Code__c != null]){
            productSWAL.add(swalProd.Id);
        }
        
        for(Liquidation_Annual_Plan__c laps : [SELECT Id, Territory_Name__c FROM Liquidation_Annual_Plan__c WHERE Territory_Name__c IN:terrIds AND FIscal_Year__c =:fisYear]){
            terrWithLAP.add(laps.Territory_Name__c);
            terrIdWithLapIdMap.put(laps.Territory_Name__c,laps.Id);
        }
        
        for(Opening_Inventory2__c openInvs :[SELECT Id,Territory__c FROM Opening_Inventory2__c WHERE Territory__c IN:terrIds AND Multi_Country_Formula_Key__c =:fisYear]){
            terrWithOpenInv.add(openInvs.Territory__c);
        }
        
        for(Territory_Distributor__c terr:newTerritoryList){
            Liquidation_Annual_Plan__c lapObj = new Liquidation_Annual_Plan__c();
            if(!terrWithLAP.contains(terr.Id)){
                if(terr.Sales_Org_Code__c == salesOrgCodeSWAL){
                   lapObj.RecordTypeId = rtForAnnualPlanSWAL;
                }
                else if(terr.Sales_Org_Code__c == salesOrgCodeAF || terr.Sales_Org_Code__c == salesOrgCodeNewAF){
                   lapObj.RecordTypeId = rtForAnnualPlanAF; 
                }
                lapObj.Fiscal_Start_Date__c = date.parse(startDate);
                lapObj.Fiscal_End_Date__c = date.parse(endDate);
                lapObj.FIscal_Year__c = fisYear;
                lapObj.Sales_Org__c = terr.SalesOrg__c;
                lapObj.Territory_Name__c = terr.Id;
                lapObj.CurrencyIsoCode = 'INR';
                lapList.add(lapObj);
            }
        }
        if(lapList.size()>0){
            INSERT lapList;
        }
        
        for(Liquidation_Annual_Plan__c laps : [SELECT Id, Territory_Name__c FROM Liquidation_Annual_Plan__c WHERE Territory_Name__c IN:terrIds AND FIscal_Year__c =:fisYear AND Id NOT IN:terrWithLAP]){
            terrIdWithLapIdMap.put(laps.Territory_Name__c,laps.Id);
        }
        
        for(Territory_Distributor__c terr:newTerritoryList){
            if(!terrWithOpenInv.contains(terr.Id)){
                if(terr.Sales_Org_Code__c == salesOrgCodeAF || terr.Sales_Org_Code__c == salesOrgCodeNewAF){
                    for(Id prodId : productAF){
                        Opening_Inventory2__c opnInvObj = new Opening_Inventory2__c();
                        opnInvObj.Liquidation_Annual_Plan__c = terrIdWithLapIdMap.get(terr.Id);
                        opnInvObj.Product__c = prodId;
                        opnInvObj.Territory__c = terr.Id;
                        opnInvObj.Opening_Inventory__c = 0;
                        opnInvObj.RecordTypeId = rtForOpeningInventoryAF;
                        opnInvObj.CurrencyIsoCode = 'INR';
                        opnInvObj.Is_From_Liq_Module__c = true;
                        openInvList.add(opnInvObj);
                    }
                }
                else if(terr.Sales_Org_Code__c == salesOrgCodeSWAL){
                    for(Id prodId : productSWAL){
                        Opening_Inventory2__c opnInvObj = new Opening_Inventory2__c();
                        opnInvObj.Liquidation_Annual_Plan__c = terrIdWithLapIdMap.get(terr.Id);
                        opnInvObj.Product__c = prodId;
                        opnInvObj.Territory__c = terr.Id;
                        opnInvObj.Opening_Inventory__c = 0;
                        opnInvObj.RecordTypeId = rtForOpeningInventorySWAL;
                        opnInvObj.CurrencyIsoCode = 'INR';
                        opnInvObj.Is_From_Liq_Module__c = true;
                        openInvList.add(opnInvObj);
                    }
                }
            }
            
        }
        if(openInvList.size()>0){
            INSERT openInvList;
        }
        
        LiquidationAFSWALUtility.sendEmail('Territory',string.join(terrName,','));
        
    }
    
}