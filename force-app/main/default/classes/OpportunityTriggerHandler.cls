/**************************************************************************************************
* Name               : OpportunityTriggerHandler 
* TestClass			 : OpportunityTriggerHandlerTest
* Description        : Handler class for OpportunityTrigger
* Created Date       : 30/03/2023                                                                
* Created By         : Nikhil Verma (Grazitti) for RITM0537885                                                                   
**************************************************************************************************/
public class OpportunityTriggerHandler {
    
    /**************************************************************************************************
    * Name               : ChurnAndCrossSellAutomation 
    * Description        : Method to update Account and Owner of Churn & Cross Sell Opp on basis of Customer_Code__c (which is SAP Customer Code) 
    * 					   and Sales_Rep_Id__c (i.e UDGN Code) field
    * Created Date       : 06/04/2023                                                                
    * Created By         : Nikhil Verma (Grazitti) for RITM0537885                                                                      
    **************************************************************************************************/
    public void ChurnAndCrossSellAutomation(List<Opportunity> newList){
        Set<String> customerCodeSet = new Set<String>();
        Set<String> repIdSet = new Set<String>();
        Set<String> DM_repIdSet = new Set<String>();
        Id recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Churn_Cross_Sell').getRecordTypeId();
        for(Opportunity op : newList){
            if(op.Type == 'Churn' || op.Type == 'Cross Sell'){
                op.RecordTypeId = recordTypeId;
                if(op.Customer_Code__c != null){
                    String code = op.Customer_Code__c;
                    code = code.replace('U','0');
                    code = code.leftPad(10, '0');
                    op.Customer_Code__c = code;
                    customerCodeSet.add(op.Customer_Code__c);
                }
                if(op.Sales_Rep_Id__c != null){
					String UGDN_DM= op.Sales_Rep_Id__c+'DM';
                	repIdSet.add(op.Sales_Rep_Id__c);
                    DM_repIdSet.add(UGDN_DM);
            	}
            }
        }
        if(customerCodeSet != null && !customerCodeSet.isEmpty()){
            Map<String,Id> sapCodeToAccountIdIdMap = new Map<String,Id>();
            for(Account acc : [SELECT Id,SAP_Customer_Code__c FROM Account WHERE SAP_Customer_Code__c IN:customerCodeSet ]){
                sapCodeToAccountIdIdMap.put(acc.SAP_Customer_Code__c, acc.Id);
            }
            if(sapCodeToAccountIdIdMap != null){
                for(Opportunity op : newList){
                    if(op.recordTypeId == recordTypeId && op.Customer_Code__c != null && sapCodeToAccountIdIdMap.containsKey(op.Customer_Code__c)){
                        op.AccountId = sapCodeToAccountIdIdMap.get(op.Customer_Code__c);
                    }
        		}
            }
        }
        if((repIdSet != null && !repIdSet.isEmpty())|| (DM_repIdSet != null && !DM_repIdSet.isEmpty())){
            Map<String,Id> repIdToUserIdMap = new Map<String,Id>();
            for(User usr : [SELECT Id,UGDN_Number__c FROM User WHERE (UGDN_Number__c IN:repIdSet OR UGDN_Number__c IN:DM_repIdSet) AND IsActive = true]){
                String usr_UGDN=usr.UGDN_Number__c;
                if(usr.UGDN_Number__c!=null && usr.UGDN_Number__c.contains('DM')){
                    usr_UGDN=usr.UGDN_Number__c.split('DM')[0];
                }
            	repIdToUserIdMap.put(usr_UGDN , usr.Id );
            }
            if(repIdToUserIdMap != null){
                for(Opportunity op : newList){
                    if(op.recordTypeId == recordTypeId && op.Sales_Rep_Id__c != null && repIdToUserIdMap.containsKey(op.Sales_Rep_Id__c)){
                        op.OwnerId = repIdToUserIdMap.get(op.Sales_Rep_Id__c);
                    }
        		}
            }
        }
    }
    
    /**************************************************************************************************
    * Name               : DefaultFieldsChurnAndCrossSell 
    * Description        : Method to fields for Churn & Cross Sell Opp
    * Created Date       : 06/04/2023                                                                
    * Created By         : Nikhil Verma (Grazitti) for RITM0537885                                                                       
    **************************************************************************************************/
    public void DefaultFieldsChurnAndCrossSell(List<Opportunity> newList){
        Id recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Churn_Cross_Sell').getRecordTypeId();
        for(Opportunity op : newList){
            if(op.recordTypeId == recordTypeId){
                if(op.StageName == null){
                    op.StageName = 'New';
                }
                op.Name = 'OPP-';
                if(op.CloseDate == null){
                    if(op.Month__c == '1' || op.Month__c == '2' || op.Month__c == '3'){
                    	op.CloseDate = date.valueOf(op.Year__c +'-03-31');
                    }else if(op.Month__c == '4' || op.Month__c == '5' || op.Month__c == '6'){
                        op.CloseDate = date.valueOf(op.Year__c +'-06-30');
                    }else if(op.Month__c == '7' || op.Month__c =='8' || op.Month__c == '9'){
                        op.CloseDate = date.valueOf(op.Year__c +'-09-30');
                    }else if(op.Month__c == '10' || op.Month__c =='11' || op.Month__c == '12'){
                        op.CloseDate = date.valueOf(op.Year__c +'-12-31');
                    }
                }
            }
        }
    }
        
    /**************************************************************************************************
    * Name               : ActivityValidation 
    * Description        : Method to restrict stage change if no activities
    * Created Date       : 03/05/2023                                                                
    * Created By         : Nikhil Verma (Grazitti) for RITM0537885                                                                       
    **************************************************************************************************/
    /*public void ActivityValidation(List<Opportunity> newList, Map<Id,Opportunity> oldMap){
        Id recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Churn_Cross_Sell').getRecordTypeId();
        Set<Id> oppIdSet = new Set<Id>();
        for(Opportunity op : newList){
            if(op.recordTypeId == recordTypeId && op.StageName != 'Closed Lost' && op.StageName != oldMap.get(op.Id).StageName){
                oppIdSet.add(op.Id);
            }
        }
        if(oppIdSet != null && !oppIdSet.isEmpty()){
            Map<Id,Boolean> taskCheckMap = new Map<Id,Boolean>();
            for(Task tsk : [SELECT Id,WhatId FROM Task WHERE WhatId IN : oppIdSet]){
                taskCheckMap.put(tsk.WhatId, True);
            }
            for(Event evnt : [SELECT Id,WhatId FROM Event WHERE WhatId IN : oppIdSet]){
                if(!taskCheckMap.containsKey(evnt.WhatId))
                	taskCheckMap.put(evnt.WhatId, True);
            }
            if(taskCheckMap != null){
                for(Opportunity op : newList){
                    if(!taskCheckMap.containsKey(op.Id)){
                        op.addError('Please create atleast one Task/Event before changing the Stage');
                    }
                }
            }
        }
    }*/
}