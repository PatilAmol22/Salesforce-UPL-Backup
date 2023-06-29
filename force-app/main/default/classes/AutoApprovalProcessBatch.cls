/*
* Name: AutoApprovalProcessBatch
* Author: Azhar Shaikh 
* Description: Used for Auto Approve from RM and ZM user
  Modified for: INC0473136 - SFDC -  Demo Requisition -Auto Approved
  Modified Date: 09-May-2023
*/

global class AutoApprovalProcessBatch implements Database.Batchable<sObject>{

    List<String> salesOrgCode=new List<String>();// Edited by Sandeep Vishwakarma - SKI 27-01-2023 AF Material Requisition
    
    public AutoApprovalProcessBatch(List<String> salesOrgCode){ // Edited by Sandeep Vishwakarma - SKI 27-01-2023 AF Material Requisition
        this.salesOrgCode=salesOrgCode;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        System.debug('salesOrgCode : '+salesOrgCode);
        String status='Pending';
        String subStatus1='Pending for Approval 1';
        String subStatus2='Pending for Approval 2';
        // Edited by Sandeep Vishwakarma - SKI 27-01-2023 AF Material Requisition
        String query = 'SELECT Id,Status__c,Sub_Status__c,SalesOrg__r.Sales_Org_Code__c,Approval_Submission_Date_Time__c,Auto_Approved_1__c,Auto_Approved_2__c,X1st_Approval_Date_Time__c,X2nd_Approval_Date_Time__c,X3rd_Approval_Date_Time__c,Office_Manager__c,Sales_Assistant__c,Need_Marketing_HO_Approval__c,LastModifiedById FROM Free_Sample_Management__c Where SalesOrg__r.Sales_Org_Code__c IN:salesOrgCode AND Status__c=\''+status+'\' AND (Sub_Status__c=\''+subStatus1+'\' OR Sub_Status__c=\''+subStatus2+'\')';
        System.debug('query : '+query);
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Free_Sample_Management__c> freeSampleManagementList) {
        boolean isRecordUpdated=false;
        List<String> processInstanceIds=new List<String>();
        for(Free_Sample_Management__c fsm : freeSampleManagementList)
        {  
            System.debug('fsm :'+fsm);
            System.debug('fsm.Office_Manager__c :'+fsm.Office_Manager__c);
            System.debug('fsm.Sales_Assistant__c :'+fsm.Sales_Assistant__c);
            
            Datetime todayDate = Datetime.now();
            Long dt2Long = todayDate.getTime();
            Long submithours=0, x1sthours=0;
            if(fsm.Approval_Submission_Date_Time__c!=null){
                Datetime asdtDatetime= fsm.Approval_Submission_Date_Time__c;
                Long dt1Long = asdtDatetime.getTime();
                // Use for hours calculation
                if(dt1Long!=0){
                    Long milliseconds = dt2Long - dt1Long;
                    Long seconds = milliseconds / 1000;
                    Long minutes = seconds / 60;
                    submithours = minutes / 60;
                    System.debug('submithours :'+submithours); 
                }
            }
            
            if(fsm.X1st_Approval_Date_Time__c!=null){
                Datetime x1stDatetime= fsm.X1st_Approval_Date_Time__c;
                Long dt3Long = x1stDatetime.getTime();  
                // Use for hours calculation
                if(dt3Long!=0){
                    Long milliseconds = dt2Long - dt3Long;
                    Long seconds = milliseconds / 1000;
                    Long minutes = seconds / 60;
                    x1sthours = minutes / 60;
                    System.debug('x1sthours :'+x1sthours);
                }
            }
            
            
            If(submithours>24 && fsm.Status__c=='Pending' && fsm.Sub_Status__c=='Pending for Approval 1' && fsm.Auto_Approved_1__c!=true && fsm.Auto_Approved_2__c!=true && fsm.Office_Manager__c!=null && fsm.Sales_Assistant__c!=null && (fsm.Need_Marketing_HO_Approval__c==false ||fsm.Need_Marketing_HO_Approval__c==true)){//Regional Step 1 (Auto Approve)
                System.debug('1=>>>');
                setMonitorLog('Auto Approval Scheduler Step 1', 'Step 1 : Pending for Approval 1'+', submithours: '+submithours+', Date :'+Datetime.now());
                fsm.Auto_Approved_1__c=true;
                isRecordUpdated=true;
                
            }
            else If(submithours>24 && fsm.Status__c=='Pending' && fsm.Sub_Status__c=='Pending for Approval 1' && fsm.Auto_Approved_1__c!=true && fsm.Auto_Approved_2__c!=true && fsm.Office_Manager__c==null && fsm.Sales_Assistant__c!=null && (fsm.Need_Marketing_HO_Approval__c==true)){//Zonal Step 3 (When RM is absent)
                System.debug('2=>>>');
                setMonitorLog('Auto Approval Scheduler Step 2', 'Step 2 : Pending for Approval 1'+', submithours: '+submithours+', Date :'+Datetime.now());
                fsm.Auto_Approved_2__c=true;
                isRecordUpdated=true;
            }
            
            else If(x1sthours>24 && fsm.Status__c=='Pending' && fsm.Sub_Status__c=='Pending for Approval 2' && fsm.Auto_Approved_1__c==true && fsm.Auto_Approved_2__c!=true && fsm.Office_Manager__c!=null && fsm.Sales_Assistant__c!=null && (fsm.Need_Marketing_HO_Approval__c==true || (fsm.Need_Marketing_HO_Approval__c==false && fsm.SalesOrg__r.Sales_Org_Code__c!='1210'))){//Zonal Step 2 (Auto Approve) and SBU for AF
                System.debug('3=>>>');
                setMonitorLog('Auto Approval Scheduler Step 3', 'Step 3 :Pending for Approval 2'+', x1sthours: '+x1sthours+', Date :'+Datetime.now());
                fsm.Auto_Approved_2__c=true;
                isRecordUpdated=true;
            }
            else If(submithours>24 && fsm.Status__c=='Pending' && fsm.Sub_Status__c=='Pending for Approval 1' && fsm.Auto_Approved_1__c!=true && fsm.Office_Manager__c!=null && fsm.Sales_Assistant__c==null){//HO Marketing (Working)(When ZM is absent)
                System.debug('4=>>>');
                setMonitorLog('Auto Approval Scheduler Step 4', 'Step 4 : Pending for Approval 1'+', submithours: '+submithours+', Date :'+Datetime.now());
                approveRecord(fsm);
                fsm.Auto_Approved_1__c=true;
            }
            else If(x1sthours>24 && fsm.Status__c=='Pending' && fsm.Sub_Status__c=='Pending for Approval 2' && fsm.Auto_Approved_1__c!=true && fsm.X1st_Approval_Date_Time__c!=null && fsm.Office_Manager__c!=null && fsm.Sales_Assistant__c!=null && fsm.Need_Marketing_HO_Approval__c==true){//Goes to Ho marketing on manual approve
                System.debug('5=>>>');
                setMonitorLog('Auto Approval Scheduler Step 5', 'Step 5 : Pending for Approval 2'+', x1sthours: '+x1sthours+', Date :'+Datetime.now());
                fsm.Auto_Approved_2__c=true;
                isRecordUpdated=true;
            }
            else If(submithours>24 && fsm.Status__c=='Pending' && fsm.Sub_Status__c=='Pending for Approval 2' && fsm.Auto_Approved_1__c!=true && fsm.Auto_Approved_2__c!=true && fsm.Sales_Assistant__c!=null && (fsm.Need_Marketing_HO_Approval__c==true) && fsm.SalesOrg__r.Sales_Org_Code__c!='1210'){
                System.debug('6=>>>');
                setMonitorLog('Auto Approval Scheduler Step 6', 'Step 6 : Pending for Approval 2'+', submithours: '+submithours+', Date :'+Datetime.now());
                fsm.Auto_Approved_2__c=true;
                isRecordUpdated=true;
            }
        }
        
        try {
            if(isRecordUpdated==true){
                update freeSampleManagementList;
                if(freeSampleManagementList.size()>0){
                    System.debug('freeSampleManagementList :'+freeSampleManagementList);
                    for(Free_Sample_Management__c fsm : freeSampleManagementList){
                        if(fsm.Sales_Assistant__c!=null){
                            setMonitorLog('Auto Approval Scheduler', 'FSM : '+fsm+', isRecordUpdated : '+isRecordUpdated);
                            System.debug('fsm.Sales_Assistant__c :'+fsm.Sales_Assistant__c);
                            System.debug('fsm Status__c :'+fsm.Status__c);
                            System.debug('fsm Sub_Status__c :'+fsm.Sub_Status__c);
                            approveRecord(fsm);
                        }
                    }  
                }
            }
            
            
        } catch(Exception e) {
            System.debug(e);
        }
        
    }   
    
    global void finish(Database.BatchableContext BC) {
        // execute any post-processing operations
    }
    
    //method used for approve record
    public void approveRecord(Free_Sample_Management__c fsm)
    {
        Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
        req.setComments('Auto Approved');
        req.setAction('Approve');
        req.setNextApproverIds(new Id[] {getApproverId(fsm.id)});
        Id workItemId = getWorkItemId(fsm.id); 

        if(workItemId == null)
        {
            fsm.addError('Error Occured');
        }
        else
        {
            req.setWorkitemId(workItemId);
            // Submit the request for approval
            Approval.ProcessResult result =  Approval.process(req);
        }
    }
    public Id getWorkItemId(Id targetObjectId)
    {
        Id retVal = null;

        for(ProcessInstanceWorkitem workItem  : [Select p.Id from ProcessInstanceWorkitem p
            where p.ProcessInstance.TargetObjectId =: targetObjectId])
        {
            retVal  =  workItem.Id;
        }

        return retVal;
    }
    // Method used to get approver Id
    public static String getApproverId(String recordId){
        String approverId='';
        List<ProcessInstance> piList=[SELECT Id,TargetObjectid, Status,(SELECT ID, ProcessNodeId, ToLabel(StepStatus), Comments, TargetObjectId, ActorId, 
                                              CreatedById, IsDeleted, IsPending, OriginalActorId, ProcessInstanceId, RemindersSent, 
                                              CreatedDate, Actor.Name, OriginalActor.Name , ProcessNode.Name 
                                              FROM StepsAndWorkitems order by CreatedDate DESC,IsPending DESC) FROM ProcessInstance where Status='Pending' AND TargetObjectId =:recordId];
        for(ProcessInstance piObj:piList){
            for(ProcessInstanceHistory sWI:piObj.StepsAndWorkitems){
                approverId=sWI.ActorId;
            }
        }
        return approverId;
    } 
    public static void setMonitorLog( String name, String message){
        Monitor_log__c monitorLogObj= new Monitor_log__c();
        monitorLogObj.Name=name;
        monitorLogObj.Message__c=message;
        insert monitorLogObj;
        System.debug('monitorLogObj :- '+monitorLogObj);
    }
}