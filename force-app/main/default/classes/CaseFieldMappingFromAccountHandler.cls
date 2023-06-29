/*
* Name: CaseFieldMappingFromAccountHandler
* Created On: 24 - Aug -2022
* Author: KVP-Chakresh Verma / Abhinay Kurmi Patel
* Description: Handler Class to update the Account fields to the child case under the France Farmer Accounts
*/

public class CaseFieldMappingFromAccountHandler {
    //Method To Update the Case Fields and Called from the Account Trigger
    public static void updateCaseFields(List<Account> accList){
        List<Case> caseToUpdate = new List<Case>();
        Map<String,Account> mapOfAccount = new Map<String,Account>();
        
        //Comment :-  Change by Siddhesh (Grazitti) - INC0373921 - 05/09/2022
        Schema.DescribeSObjectResult describeAccount = Schema.SObjectType.Account;
		List<Schema.RecordTypeInfo> rtInfos = describeAccount.getRecordTypeInfos();
        Id recordTypeId;
		for(Schema.RecordTypeInfo rtInfo : rtInfos) {
            //system.debug('rtInfo.getName() ' + rtInfo.getName());
            //System.debug('rtInfo.isAvailable() ' + rtInfo.isAvailable());
            //if((rtInfo.getName()=='France Farmer' && rtInfo.isAvailable())){//||(Test.isRunningTest())
                if((rtInfo.getName()=='France Farmer' && rtInfo.isAvailable())||(Test.isRunningTest())){//||(Test.isRunningTest())
            
                recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('France Farmer').getRecordTypeId(); 
            }
        }
       
        //system.debug('recordTypeId ' + recordTypeId);
        if(!accList.isEmpty() && recordTypeId!=null){
            for(Account acc : accList){
                //System.debug('acc.RecordTypeId ' + acc.RecordTypeId);
                //System.debug('recordTypeId ' + recordTypeId);
                if(acc.RecordTypeId == recordTypeId){
                    mapOfAccount.put(acc.Id,acc);
                }
            }   
        }
        
        if(!mapOfAccount.isEmpty()){
            for(Case caseRecord : [Select Id,Farmer_Account__c from Case where Farmer_Account__c In : mapOfAccount.keySet() for Update]){
                if(mapOfAccount.containsKey(caseRecord.Farmer_Account__c)){
                    caseRecord.First_Name__c = mapOfAccount.get(caseRecord.Farmer_Account__c).First_Name__c;
                    caseRecord.Last_Name__c = mapOfAccount.get(caseRecord.Farmer_Account__c).Last_Name__c;
                    caseRecord.Email__c = mapOfAccount.get(caseRecord.Farmer_Account__c).Email__c;
                    caseRecord.Billing_postal_code__c = mapOfAccount.get(caseRecord.Farmer_Account__c).BillingPostalCode ;
                    caseRecord.Billing_street__c = mapOfAccount.get(caseRecord.Farmer_Account__c).BillingStreet;
                    caseRecord.Billing_city__c = mapOfAccount.get(caseRecord.Farmer_Account__c).BillingCity;
                    caseToUpdate.add(caseRecord);
                }
            }
        }
        if(!caseToUpdate.isEmpty()){
            update caseToUpdate;
        }
               
    }

}