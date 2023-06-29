/*******************************************************************************************
* @Name         DgApprovalHistoryUtil
* @Author       Prashant Kumbhar <prashant.kumbhar@skinternational.com>
* @Date         13/03/2023
* @Group        SKI
* @Description  This class contains all  methods related to SOR and DG Approval History.
*******************************************************************************************/
/* MODIFICATION LOG
* Version          Developer          Date               Description
*-------------------------------------------------------------------------------------------
*  1.0              Prashant         13/02/2023           Initial Creation                                                      
*******************************************************************************************/



public class DgApprovalHistoryController {
    public static final String APPROVE_ACTION = 'Approve';
    public static final String REJECT_ACTION = 'Reject';
    public static final String RECALL_ACTION = 'Removed';
    
    /*
    * @Description - This method Used to Search Users .
    * @Param - input paramters is searchTerm .
    * @return  -  result of operation
    */
  
    
    @AuraEnabled(Cacheable=true)
    public static List<LookupSearchResult> searchUsers(String searchTerm) {
        // Prepare query paramters
        searchTerm += '*';

        // Execute search query
        List<List<SObject>> searchResults = [
            FIND :searchTerm
            IN ALL FIELDS
            RETURNING
                User(Id, FirstName, LastName)
            LIMIT :DgApprovalHistoryUtil.MAX_RESULTS 
        ];

        // Prepare results
        List<LookupSearchResult> results = new List<LookupSearchResult>();

        // Extract Accounts & convert them into LookupSearchResult
        String userIcon = 'standard:user';
        User[] users = (List<User>) searchResults[0];
        for (User currUser : users) {
            results.add(
                new LookupSearchResult(
                    currUser.Id,
                    'User',
                    userIcon,
                    currUser.FirstName + ' ' + currUser.LastName,
                    ''
                )
            );
        }

        // Optionnaly sort all results on title
        results.sort();

        return results;
    }
    /*
    * @Description - This method Used to Find Approval Steps .
    * @Param - input paramters are recordId,comments,nextApproverId,action .
    * @return  -  result of operation
    */
  
    
    @AuraEnabled
    public static String processStep(String recordId, String comments, String nextApproverId, String action){
        List<ProcessInstanceWorkitem> workItems = [
            SELECT Id, ProcessInstanceId 
            FROM ProcessInstanceWorkitem 
            WHERE ProcessInstance.TargetObjectId = :recordId 
        ];
			
        return DgApprovalHistoryUtil.processStep(workItems,comments, nextApproverId,  action);
       
    }
   
    /*
    * @Description - This method Used to Reassign Approval Steps .
    * @Param - input paramters are recordId,newActorId.
    * @return  -  result of operation
    */
  
    
    @AuraEnabled
    public static void reassignStep(String recordId, String newActorId ){
        List<ProcessInstanceWorkItem> workItemList = [SELECT ActorId FROM ProcessInstanceWorkitem WHERE ProcessInstance.TargetObjectId = : recordId];
        DgApprovalHistoryUtil.reassignStep(workItemList, newActorId);
    }

    /*
    * @Description - This method Used to Submit for Approval Steps .
    * @Param - input paramters are recordId,comments,nextApproverId.
    * @return  -  result of operation
    */
  
    @AuraEnabled
    public static String submitForApproval(String recordId, String comments, String nextApproverId){
        Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
        req.setComments(comments);
        if(!String.isBlank(nextApproverId)){
            req.setNextApproverIds(new Id[] {nextApproverId});
        }
        req.setObjectId(recordId);
        
        // Submit on behalf of a specific submitter
       // req.setSubmitterId(DgApprovalHistoryUtil.currentUserId); 
        // Submit the approval request for the account
        Approval.ProcessResult result = Approval.process(req);
        
        return JSON.serialize(result);
        
    }
    
    /*
    * @Description - This method Used to get Approval History .
    * @Param - input paramters are recordId.
    * @return  -  result of operation
    */
  

    @AuraEnabled (cacheable=true)
    public static ApprovalHistory getApprovalHistory(String recordId){  
                          
        List<ProcessInstance> processInstances = [SELECT Id,SubmittedById, ProcessDefinition.Name , (SELECT ID, ProcessNodeId,  
                                                            StepStatus,Comments,TargetObjectId,ActorId,CreatedById,IsDeleted,IsPending  
                                                            ,OriginalActorId,ProcessInstanceId,RemindersSent,CreatedDate, Actor.Name, Actor.Profile.Name, 
                                                            OriginalActor.Name , ProcessNode.Name FROM StepsAndWorkitems order by IsPending DESC, CreatedDate DESC )   
                                                    FROM ProcessInstance where TargetObjectId =:recordId order by CreatedDate DESC];
        
        String AccountOwner = '';
        
        if(!Test.isRunningTest()){
            try{
  			 Sales_Order__c so = [select Sold_to_Party__c , Sold_to_Party__r.OwnerId from Sales_Order__c where Id=:recordId];
            	AccountOwner=so.Sold_to_Party__r.OwnerId;
            }catch(Exception e){
                system.debug('Ex -->'+e);
            }
        }else{
             AccountOwner=userinfo.getUserId();
             
        }
        	
        return DgApprovalHistoryUtil.populateApprovalHistorySteps(processInstances, recordId, AccountOwner);                                                 
                                                                      
    }  

    public class ApprovalHistoryStep{
        @AuraEnabled  
        public String stepName {get;set;}  
        @AuraEnabled  
        public String stepUrl {get;set;}
        @AuraEnabled  
        public DateTime createdDate {get;set;}   
        @AuraEnabled  
        public String stepStatus {get;set;}  
        @AuraEnabled  
        public String assignedTo {get;set;}   
        @AuraEnabled  
        public String assignedToUrl {get;set;}
        @AuraEnabled
        public String comments {get;set;}
        @AuraEnabled
        public String AccountOwner {get;set;}
        @AuraEnabled
        public String CurrentUserProfile {get;set;}
        public ApprovalHistoryStep(){}
        public ApprovalHistoryStep(
            String stepName,
            String stepId,
            DateTime createdDate, 
            String stepStatus,
            String assignedTo,
            String assignedToId,
            String comments,
            String AccountOwner,
            String CurrentUserProfile
            )  
        { 
            this.stepName = stepName;
            this.stepUrl = '/' + stepId;
            this.createdDate = createdDate;
            this.assignedTo = assignedTo;  
            this.assignedToUrl = '/'+assignedToId;
            
            this.CurrentUserProfile = CurrentUserProfile;
            System.debug('Profile=='+this.CurrentUserProfile);
            if(this.CurrentUserProfile == 'Customer Community Plus User - Poland - 1' || this.CurrentUserProfile == 'Customer Community Plus User - Poland - 2' ||this.CurrentUserProfile == 'Customer Partner Community Plus User - Poland - 1'|| this.CurrentUserProfile == 'Customer Partner Community Plus User - Poland - 2'){
            if(AccountOwner == assignedToId){
                this.comments = comments;
            }else{
                this.comments = '';
            }
            }else{
                this.comments = comments;
            }            
            this.AccountOwner = AccountOwner;
            
            
            
            if(stepStatus == DgApprovalHistoryUtil.STATUS_STARTED){   
                this.stepStatus = Label.Submitted;
            }else if(stepStatus == DgApprovalHistoryUtil.STATUS_REMOVED){
                this.stepStatus = DgApprovalHistoryUtil.STATUS_RECALLED;
            }else if(stepStatus == DgApprovalHistoryUtil.STATUS_PENDING){
                this.stepStatus = Label.Pending;
            }else if(stepStatus == 'Approved'){
                this.stepStatus = Label.Approved;
            }else if(stepStatus == 'Rejected'){
                this.stepStatus = Label.Rejected;
            }else{
                this.stepStatus = stepStatus;
            }
            
        } 
    }

    public class ApprovalHistory{
        @AuraEnabled
        public List<ApprovalHistoryStep> approvalSteps;
        @AuraEnabled
        public String approvalStepsSize;
        @AuraEnabled 
        public boolean isCurrentUserApprover; 
        @AuraEnabled 
        public boolean showRecall;  //Modify All Data" permission or "Modify All" on the object level
                                    // system admin and submitter(if it says so on the approval process)
                                        //SELECT Name FROM Profile WHERE PermissionsModifyAllData = true
                                    //query permission sets with modify all or modify all for object and see if curr user has them

        @AuraEnabled 
        public boolean showSubmitForApproval; 
        public ApprovalHistory(List<ApprovalHistoryStep> approvalSteps, boolean isCurrentUserApprover, boolean isSubmitForApproval, boolean showRecall){
            this.approvalSteps = approvalSteps;
            this.isCurrentUserApprover = isCurrentUserApprover; 
            //this.approvalStepsSize = moreThan6Steps ? '6+' : string.valueOf(approvalSteps.size());
            this.showSubmitForApproval = isSubmitForApproval;
            this.showRecall = showRecall;
        }
    }


}