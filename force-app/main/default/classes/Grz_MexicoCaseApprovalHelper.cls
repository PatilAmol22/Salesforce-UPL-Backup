public class Grz_MexicoCaseApprovalHelper {

    public static void submitProcessApprovalRequestMexico(List<Case> caseList){
        
        System.debug('Inside submitProcessApprovalRequestMexico method');      
    
        Id Case_recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Mexico_Distributor').getRecordTypeId();
        System.debug('Case_recordTypeId Mexico : '+Case_recordTypeId);
        Id portalrecordTypeId = Schema.SObjectType.Partner_Portal_Configuration__c.RecordTypeInfosByName.get('CaseCategoryMapping').RecordTypeId;
        List<Partner_Portal_Configuration__c> eachRecord = new  List<Partner_Portal_Configuration__c>();
        eachRecord= [Select Id,Name,Label__c,CaseType__c,Description__c from  Partner_Portal_Configuration__c where  recordtypeId  =: portalrecordTypeId and Language__c = 'es-MX'];
        Map<String,String> mxCaseTypeMap = new Map<String,String>();
        
        for(Partner_Portal_Configuration__c ppc : eachRecord){
            mxCaseTypeMap.put(ppc.Label__c,ppc.Description__c);
        }
        
        for(Case ca : caseList){
            
            if(ca.RecordTypeId == Case_recordTypeId && ca.IsCaseCreatedFromMxPortal__c){
                System.debug('Inside Approval Condition');
                Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                req1.setComments('Submitting request for approval For Mexico Portal Case.');
                req1.setObjectId(ca.id);
                // Submit on behalf of a specific submitter
                req1.setSubmitterId(ca.CreatedById); 
                // Submit the record to specific process and skip the criteria evaluation
                req1.setProcessDefinitionNameOrId(mxCaseTypeMap.get(ca.Type));
                //req1.setSkipEntryCriteria(true);
                // Submit the approval request for the account
        		Approval.ProcessResult result = Approval.process(req1);
                System.debug('Approval result : '+result);
            }
            
        }
    }
}