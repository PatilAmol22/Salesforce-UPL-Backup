/*
Name : HFXAccountMappingHandler
Description : this class called from trigger. purpose of this to link account with case.
*/
public class HFXAccountMappingHandler {
    public static void accountMapping(List<case> caseList){
        Set<String> emailSet = new Set<String>();
        Map<String, Id> accMap = new Map<String, Id>();
        Id idRecordId = Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('Hannaford_General_Query').getRecordTypeId();
        
        for(case ca : caseList){
            if(ca.recordTypeId == idRecordId  && ca.SuppliedEmail != null){
                emailSet.add(ca.SuppliedEmail.trim());
                // Set default status open for web cases
                if(ca.Origin == 'Web' ){
                    ca.status = 'Open'; 
                }
            }
        }
        
        for(account acc : [SELECT Id, Email__c from account where Email__c!= null AND Email__c IN : emailSet limit 10]){
            if(!accMap.containsKey(acc.Email__c.trim())){
                accMap.put(acc.Email__c.trim(), acc.Id);
            }
        }
        
        if(accMap.values().size() > 0 ){
            for(case cs : caseList){
                if(accMap.containsKey(cs.SuppliedEmail.trim())){
                    cs.AccountId = accMap.get(cs.SuppliedEmail);
                }    
            }   
        }
    }
}