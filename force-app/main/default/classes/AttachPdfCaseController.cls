public class AttachPdfCaseController {
    //Approval ProcessProperties Declaration
    transient public ApprovalList aSW {get; private set;}
    private Id recordId;
    //private Id retURLRecordId;
    private String ORG_LNK;
    //End 
    
    public String idVal {get;set;}
    public Case caseObj {get;set;}
    
    
    public AttachPdfCaseController(){
        try{
            System.debug('----------CasePageController----------');
            
            idVal = ApexPages.currentPage().getParameters().get('id');
            System.debug('idVal: '+idVal);
            
            //Query Case Object for all the necessary fields to be populated in PDF
            List<Case> caseList = [SELECT Id, CaseNumber,Account.name,Contact.name,Owner.Name,Complaint_Form_Completed_Date__c,
                                   Complaint_First_Observed_Date__c,TypeofComplaint__c,Packaging_Complaint_Specifics__c,If_Packaging_Complaint_is_Other__c,
                                   Formulation_Complaint_Specifics__c,If_Formulation_Complaint_is_Other__c,
                                   QuantityDiscrepancySpecifics__c,If_Quantity_Discrepancy_is_Other__c,Pallet_Configuration__c,
                                   Pack_Size_SKU__r.Name,Lot_Number__c,Batch_Number_1__c,Batch_Number_2__c,Batch_Number_3__c,
                                   Total_Volume_Effected__c,Units_1__c,Units_2__c,List_Price_of_Complaint_Product_Unit__c,
                                   Total_Value_of_Complaint_Product__c,Description,Photos_Included__c,Sample_of_Complaint_Product_to_Lab__c,
                                   Requested_Resolution__c,Replacement_Credit_Volume_in_Units__c,List_Price_per_Unit__c,
                                   Total_Value_of_Replacement_or_Credit__c
                                   
                                   FROM Case WHERE ID = :idVal]; 
            
            System.debug('caseList: '+caseList);
            
            //Assign returned result to case Object
            caseObj = caseList[0];
            
            
            //Approval Process Logic retURLRecordId = 
            recordId = caseObj.Id;
            
            ORG_LNK = 'https://'+URL.getSalesforceBaseUrl().getHost();
            if(!String.isBlank(recordID)){
                aSW = new ApprovalList();
                aSW = generateData();
            }  
            //End
        }
        catch(Exception ex){
            System.debug('Case Page Controller Exception');
            System.debug('Ex Line No: '+ex.getLineNumber());
            System.debug('Ex Message: '+ex.getMessage());
        }
    }
    //approval data retrieval logic
    ApprovalList generateData(){
        ApprovalList approvalResultForObject = new ApprovalList();
        List<ApprovalStepWrapper> aSW = new List<ApprovalStepWrapper>();
        String recallApprovalProcessLink;
        Boolean isSubmitForApproval = true;
        for(ProcessInstance pI:getProcessHistory(recordId).values()){
            Map<Id,List<ProcessInstanceHistory>> mapOfProcessNodeIdAndProcessInstanceHistory = new Map<Id,List<ProcessInstanceHistory>>();
            Set<Id> processNodeId= new Set<Id>(); 
            
            for(ProcessInstanceHistory sWI:pI.StepsAndWorkitems){
                if(processNodeId.size() ==0)
                    processNodeId.add(sWI.ProcessNodeId);
                else if(processNodeId.size()>0 && processNodeId.contains(sWI.ProcessNodeId)!= NULL)
                    processNodeId.add(sWI.ProcessNodeId);
            }
            
            for(Id pNId: processNodeId){
                ApprovalStepWrapper aSWr = new ApprovalStepWrapper();
                for(ProcessInstanceHistory sWI:pI.StepsAndWorkitems){
                    if(sWI.processNodeId == pNID){
                        aSWr.listOfSteps.add(sWI);
                    }
                /*    if(sWI.StepStatus == 'Pending'){
                        aSWr.workItemApproveOrRejectLink = ORG_LNK+'/p/process/ProcessInstanceWorkitemWizardStageManager?id='+sWI.Id;
                        aSWr.workItemReassignLink =  ORG_LNK+'/'+sWI.Id+'/e?et=REASSIGN&retURL=/'+retURLRecordId;
                        recallApprovalProcessLink =  ORG_LNK +'/'+sWI.Id+'/e?et=REMOVE&retURL=/'+retURLRecordId;
                        isSubmitForApproval = false;
                    } */
                    
                }
                aSW.add(aSWr);
            }
        }
        approvalResultForObject.approvals = aSW;
        approvalResultForObject.recordId = recordId;
        approvalResultForObject.isSubmitForApproval = isSubmitForApproval;
        approvalResultForObject.recallApprovalProcessLink = recallApprovalProcessLink;
        return approvalResultForObject;
    }
    //Process Instance actually get approval object
    private Map<Id,ProcessInstance> getProcessHistory(Id objectId){
        return new Map<Id,ProcessInstance>([SELECT Id, (SELECT ID, ProcessNodeId,
                                                        StepStatus,Comments,TargetObjectId,ActorId,CreatedById,IsDeleted,IsPending
                                                        ,OriginalActorId,ProcessInstanceId,RemindersSent,CreatedDate, Actor.Name,
                                                        OriginalActor.Name , ProcessNode.Name FROM StepsAndWorkitems order by CreatedDate ASC ) 
                                            FROM ProcessInstance where TargetObjectId =:objectId order by CreatedDate ASC]);
    }
    //Wrapper 1 class for approval logic
    public class ApprovalStepWrapper{
        public String workItemApproveOrRejectLink {get;set;}
        public String workItemReassignLink {get;set;}
        public List<ProcessInstanceHistory> listOfSteps {get;set;}
        public ApprovalStepWrapper(){
            listOfSteps = new  List<ProcessInstanceHistory>();
        }
    }
    //Another Wrapper class which has list of Wrapper 1
    public class ApprovalList{
        public List<ApprovalStepWrapper> approvals {get;set;}
        public String recallApprovalProcessLink {get;set;}
        public Boolean isSubmitForApproval {get;set;}
        public Id recordId {get;set;}
        public ApprovalList(){
            approvals = new List<ApprovalStepWrapper>();
            isSubmitForApproval = true;
        }
    }
}