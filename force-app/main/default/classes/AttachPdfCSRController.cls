public class AttachPdfCSRController {
    //Approval ProcessProperties Declaration
    transient public ApprovalList aSW {get; private set;}
   @TestVisible private Id recordId;
//   @TestVisible  private Id retURLRecordId;
   @TestVisible  private String ORG_LNK;
    //End 
    
    public String idVal {get;set;}
    public CSR__c CSRItem {get;set;}
    public List<CSRSKU__c> skuList {get;set;}
    
    public AttachPdfCSRController(){
        try{
            System.debug('----------CSRPageController----------');
            
            idVal = ApexPages.currentPage().getParameters().get('id');
            System.debug('idVal:----------- '+idVal);
            
            //Query CSR Object for all the necessary fields to be populated in PDF
            List<CSR__c> csrList = [SELECT Id, Name, Approval_Submitted_Date__c, RecordType.DeveloperName, Reviewed__c,
                                    Owner.Name,Total_Percent_new__c,CSR_Type__c,Campaign_Year__c, CSR_2_Unit_Request__c,
                                    Distributor_from_who_they_purchase_1__r.Name, Contact_Name__r.Name, Account_Name__r.Name,
                                    Account_Name__r.UPI_Division__c, RecordType.Name, Competitive_product__c,
                                    Account_Name__r.Phone, Account_Name__r.Customer_Type__c, CSR_1_PER_UNIT_REQUEST__c,
                                    Account_Name__r.BillingAddress, Account_Name__r.BillingStreet,
                                    Account_Name__r.BillingCity, Account_Name__r.BillingState, Reason_for_Competitive_Offer__c,
                                    Account_Name__r.BillingPostalCode, Account_Name__c, Brand_Pack__r.Name,
                                    Customers_PY_Purchase_Volume__c, Customers_CY_Planned_Purchase_Volume__c,
                                    Product_pack_Unit_of_Measure_2__c,UPI_List_Price__c, UPI_Program_Net_Price_before_CSR__c, 
                                    Competitive_product_pack_unit_of_measu__c, Competitive_product_price_from_distribut__c,
                                    Competitive_per_unit_back_to_customer__c, Competitive_product_low_net__c,
                                    Difference_in_Price_UPI_vs_Competitor__c, Planned_Volume__c, Total_UPI_Competitive_Offer__c,
                                    Requested_Additional_Unit__c,New_Program_Net_Price_Unit__c,UPI_List_Price_OPF__c
                                    FROM CSR__c WHERE ID = :idVal]; 
            
            System.debug('csrList:--------- '+csrList);
            
            //Assign returned result to CSR Object
            if(csrList.size()>0){
                skuList = [SELECT Id, Pack_Size_SKU__c, UPI_Written_Program_Rebate__c, Brand_Pack__c, Brand_Pack__r.Name , Pack_Size_SKU__r.Name
                           FROM CSRSKU__c WHERE CSR_Number__c =: csrList[0].Id];
                recordId = csrList[0].Id;
                CSRItem = csrList[0];
            }
            
            //Approval Process Logic retURLRecordId = 
            
            
            ORG_LNK = 'https://'+URL.getSalesforceBaseUrl().getHost();
            if(!String.isBlank(recordID)){
                aSW = new ApprovalList();
                aSW = generateData();
            }  
            //End
        }
        catch(Exception ex){
            System.debug('CSR Page Controller Exception');
            System.debug('Ex Line No: '+ex.getLineNumber());
            System.debug('Ex Message: '+ex.getMessage());
        }
    }
    
    ApprovalList generateData(){
        ApprovalList approvalResultForObject = new ApprovalList();
        List<ApprovalStepWrapper> aSW = new List<ApprovalStepWrapper>();
        //String recallApprovalProcessLink;
        //Boolean isSubmitForApproval = true;
        System.debug('recordId: '+recordId);
        System.debug('getProcessHistory(recordId): '+getProcessHistory(recordId));
        System.debug('getProcessHistory(recordId).values(): '+getProcessHistory(recordId).values());
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
                    /*if(sWI.StepStatus == 'Pending'){
                        aSWr.workItemApproveOrRejectLink = ORG_LNK+'/p/process/ProcessInstanceWorkitemWizardStageManager?id='+sWI.Id;
                        aSWr.workItemReassignLink =  ORG_LNK+'/'+sWI.Id+'/e?et=REASSIGN&retURL=/'+retURLRecordId;
                        recallApprovalProcessLink =  ORG_LNK +'/'+sWI.Id+'/e?et=REMOVE&retURL=/'+retURLRecordId;
                        isSubmitForApproval = false;
                    }*/
                    
                }
                aSW.add(aSWr);
            }
        }
        approvalResultForObject.approvals = aSW;
        approvalResultForObject.recordId = recordId;
        //approvalResultForObject.isSubmitForApproval = isSubmitForApproval;
        //approvalResultForObject.recallApprovalProcessLink = recallApprovalProcessLink;
        return approvalResultForObject;
    }
    
    private Map<Id,ProcessInstance> getProcessHistory(Id objectId){
        System.debug('getProcessHistory: '+[SELECT Id, (SELECT ID, ProcessNodeId,StepStatus,Comments,TargetObjectId,ActorId,CreatedById,IsDeleted,IsPending,OriginalActorId,ProcessInstanceId,RemindersSent,CreatedDate, Actor.Name,OriginalActor.Name , ProcessNode.Name FROM StepsAndWorkitems order by CreatedDate ASC ) FROM ProcessInstance  order by CreatedDate ASC]);
        return new Map<Id,ProcessInstance>([SELECT Id, (SELECT ID, ProcessNodeId,
                                                        StepStatus,Comments,TargetObjectId,ActorId,CreatedById,IsDeleted,IsPending
                                                        ,OriginalActorId,ProcessInstanceId,RemindersSent,CreatedDate, Actor.Name,
                                                        OriginalActor.Name , ProcessNode.Name FROM StepsAndWorkitems order by CreatedDate ASC ) 
                                            FROM ProcessInstance where TargetObjectId =:objectId order by CreatedDate ASC]);
    }
    
    public class ApprovalStepWrapper{
        public String workItemApproveOrRejectLink {get;set;}
        public String workItemReassignLink {get;set;}
        public List<ProcessInstanceHistory> listOfSteps {get;set;}
        public ApprovalStepWrapper(){
            listOfSteps = new  List<ProcessInstanceHistory>();
        }
    }
    
    public class ApprovalList{
        public List<ApprovalStepWrapper> approvals {get;set;}
        public String recallApprovalProcessLink {get;set;}
        //public Boolean isSubmitForApproval {get;set;}
        public Id recordId {get;set;}
        public ApprovalList(){
            approvals = new List<ApprovalStepWrapper>();
            //isSubmitForApproval = true;
        }
    }
}