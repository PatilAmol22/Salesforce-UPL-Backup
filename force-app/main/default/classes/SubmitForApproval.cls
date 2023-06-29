public class SubmitForApproval {
    

    public static void SubmitforApprovalAfterUpdate(Map<Id,Case> caseOldMap, List<Case> newCaseList){
        
        Id Case_recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
      //System.debug('Case_recordTypeId' + Case_recordTypeId);
     Map<Id,Sales_Org__c> salesOrgs = new Map<Id,Sales_Org__c >([Select Id, Name, Sales_Org_Code__c from Sales_Org__c where Name = 'UPL SAS' or Name = 'SWAL']);   // Change by Sumit(Grazitti) for APPS-4676 01-02-2023
        //System.debug('salesOrgs' + salesOrgs);
        
        for(Case c:newCaseList){  
     
            System.debug('c.catesub__c ' + c.catesub__c);    System.debug('c.RecordTypeId ' + c.RecordTypeId);  System.debug((salesOrgs.containsKey(c.SalesOrg__c)));
            try{
            
                if((c.sub_category__c != null) && ( c.catesub__c != null && (c.catesub__c == 'Request' || c.catesub__c == 'Complaint')) && (c.RecordTypeId == Case_recordTypeId) && (salesOrgs.containsKey(c.SalesOrg__c))){
                
                    case cOld=caseOldMap.get(c.Id);
                    if((c.Status == 'Closed' && cOld.Status != 'Closed') || Test.isRunningTest()){ 
             
                        ProcessApprovelRequest.submitForApproval(c);
                    }
          
                }
            }
            catch(Exception e){
                c.addError(e.getMessage());
            }
        }

    
    }
    
    //This method added by Mohit Garg - Grazitti (13-02-2023) - APPS-4742
    public static void SubmitforApprovalAfterUpdate1(Map<Id,Case> caseOldMap, List<Case> newCaseList){
        Id Case_recordTypeIdRCM = Schema.SObjectType.Case.getRecordTypeInfosByName().get('RCMCase').getRecordTypeId();        
        for(Case c: newCaseList){  
            try{
                if((c.RecordTypeId == Case_recordTypeIdRCM)){
                    case cOld=caseOldMap.get(c.Id);
                    if((c.Status == 'Closed' && cOld.Status != 'Closed')){ 
                        ProcessApprovelRequest.submitForApproval1(c);
                    }
                }
            }
            catch(Exception e){
                c.addError(e.getMessage());
            }
        }       
    }   
}