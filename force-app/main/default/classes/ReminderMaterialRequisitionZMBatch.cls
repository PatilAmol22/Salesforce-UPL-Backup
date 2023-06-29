/*
* Name: ReminderMaterialRequisitionZMBatch
* Author: Azhar Shaikh 
* Description: Used for sending pending request reminder to RM 
*/

global class ReminderMaterialRequisitionZMBatch implements Database.Batchable<sObject>, Database.Stateful {
    
    List<String> salesOrgCode= new List<String>();// Edited by Sandeep Vishwakarma - SKI 27-01-2023 AF Material Requisition
    String reminderSubject='';
    String reminderMsg='';
    String userName='';
    String userEmail='';
    
    public ReminderMaterialRequisitionZMBatch( List<String> salesOrgCode,String reminderSubject, String reminderMsg){// Edited by Sandeep Vishwakarma - SKI 27-01-2023 AF Material Requisition
        this.salesOrgCode=salesOrgCode;
        this.reminderSubject=reminderSubject;
        this.reminderMsg=reminderMsg;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        System.debug('salesOrgCode : '+salesOrgCode);
        // Edited by Sandeep Vishwakarma - SKI 27-01-2023 AF Material Requisition
        String query='SELECT Id, Name, ZoneCode__c, ZonalHead__c,ZonalHead__r.Email,ZonalHead__r.Name,SalesOrg__c,SBUCode__c,SBUCode__r.SBUMarketingheads__c,SBUCode__r.SBUUser__c,SBUCode__r.SBUMarketingheads__r.Email,SBUCode__r.SBUMarketingheads__r.Name,SBUCode__r.SBUUser__r.Email,SBUCode__r.SBUUser__r.Name FROM Zone__c where SalesOrg__r.Sales_Org_Code__c IN :salesOrgCode';
        System.debug('query : '+query);
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Zone__c> zoneList) {
        boolean isRecordUpdated=false;
        String ZMHId = null;
        if(!salesOrgCode.contains('1410')){
            ZMHId = zoneList[0].ZonalHead__c;
            userEmail=zoneList[0].ZonalHead__r.Email;
            userName=zoneList[0].ZonalHead__r.Name;
        }else{
            ZMHId = zoneList[0].SBUCode__r?.SBUMarketingheads__c;
            userEmail=zoneList[0].SBUCode__r?.SBUMarketingheads__r.Email;
            userName=zoneList[0].SBUCode__r?.SBUMarketingheads__r.Name;
            if(ZMHId==null){
                ZMHId = zoneList[0].SBUCode__r?.SBUUser__c;
                userEmail=zoneList[0].SBUCode__r?.SBUUser__r.Email;
                userName=zoneList[0].SBUCode__r?.SBUUser__r.Name;
            }
        }
        if(ZMHId!=null){
        // Edited by Sandeep Vishwakarma - SKI 27-01-2023 AF Material Requisition
        System.debug('ZMHId '+ZMHId);
        
        String status='Pending';
        //String subStatus1='Pending for Approval 1';
        String subStatus='Pending for Approval 2';
        List<PendingRequisitionWrapper> prWrap12List=new List<PendingRequisitionWrapper>();
    	List<PendingRequisitionWrapper> prWrap18List=new List<PendingRequisitionWrapper>();
        
        //List<Free_Sample_Management__c> fsmList = [SELECT Id,Name,Depot__r.Name,Territory_Manager__r.Name,Territory__r.Name,Status__c,Sub_Status__c,Approval_Submission_Date_Time__c,Auto_Approved_1__c,Auto_Approved_2__c,X1st_Approval_Date_Time__c,X2nd_Approval_Date_Time__c,X3rd_Approval_Date_Time__c,Office_Manager__r.Name,Office_Manager__r.Email,Sales_Assistant__r.Name, Sales_Assistant__r.Email,Technical_Manager__r.Email,LastModifiedById FROM Free_Sample_Management__c Where Sales_Org__r.Sales_Org_Code__c=:salesOrgCode AND Sales_Assistant__c=:ZMHId AND Status__c=:status AND (Sub_Status__c=:subStatus1 OR Sub_Status__c=:subStatus2) AND Sales_Assistant__c!=null AND X1st_Approval_Date_Time__c!=null AND X2nd_Approval_Date_Time__c=null];
        // Edited by Sandeep Vishwakarma - SKI 27-01-2023 AF Material Requisition
        List<Free_Sample_Management__c> fsmList = [SELECT Id,Name,Depot__r.Name,Territory_Manager__r.Name,Territory__r.Name,Status__c,Sub_Status__c,Approval_Submission_Date_Time__c,Auto_Approved_1__c,Auto_Approved_2__c,X1st_Approval_Date_Time__c,X2nd_Approval_Date_Time__c,X3rd_Approval_Date_Time__c,Office_Manager__r.Name,Office_Manager__r.Email,Sales_Assistant__r.Name, Sales_Assistant__r.Email,Technical_Manager__r.Email,ZMNotification12HrsChecked__c,ZMNotification18HrsChecked__c,LastModifiedById FROM Free_Sample_Management__c Where Sales_Assistant__c=:ZMHId AND Status__c=:status AND (Sub_Status__c=:subStatus OR (Sub_Status__c='Pending for Approval 1' AND Office_Manager__c=null))];
        for(Free_Sample_Management__c fsmObj : fsmList)
        {    
            Datetime todayDate = Datetime.now();
            Long dt2Long = todayDate.getTime();
            Long x1sthours=0;
            
            if(fsmObj.X1st_Approval_Date_Time__c!=null){
                Datetime x1stDatetime= fsmObj.X1st_Approval_Date_Time__c;
                Long dt3Long = x1stDatetime.getTime();	
                // Use for hours calculation
                if(dt3Long!=0){
                    Long milliseconds = dt2Long - dt3Long;
                    Long seconds = milliseconds / 1000;
                    Long minutes = seconds / 60;
                    x1sthours = minutes / 60;
                    System.debug('x1sthours :'+x1sthours);
                }
            }else if(fsmObj.Approval_Submission_Date_Time__c!=null && String.isBlank(fsmObj.Office_Manager__c)){// Edited by Sandeep Vishwakarma - SKI 27-01-2023 AF Material Requisition
                Datetime x1stDatetime= fsmObj.Approval_Submission_Date_Time__c;
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
            
            if(x1sthours>12) {
                if(fsmObj.ZMNotification12HrsChecked__c!=true){
                    fsmObj.ZMNotification12HrsChecked__c=true;
                    isRecordUpdated=true;
                    PendingRequisitionWrapper prWrap=new PendingRequisitionWrapper();
                    String getBaseUrl=URL.getSalesforceBaseUrl().toExternalForm();
                    String urlStr='/lightning/r/Free_Sample_Management__c/' + fsmObj.Id + '/edit';
                    prWrap.fsmName='<a href="'+getBaseUrl+urlStr+'">'+fsmObj.Name+'</a></p>';
                    prWrap.DepotName=fsmObj.Depot__r.Name;
                    prWrap.Territory=fsmObj.Territory__r.Name;
                    prWrap.TMName=fsmObj.Territory_Manager__r.Name;
                    prWrap12List.add(prWrap);
                }
            }
            
            if(x1sthours>18){
                if(fsmObj.ZMNotification18HrsChecked__c!=true){
                    fsmObj.ZMNotification18HrsChecked__c=true;
                    isRecordUpdated=true;
                    PendingRequisitionWrapper prWrap=new PendingRequisitionWrapper();
                    String getBaseUrl=URL.getSalesforceBaseUrl().toExternalForm();
                    String urlStr='/lightning/r/Free_Sample_Management__c/' + fsmObj.Id + '/edit';
                    prWrap.fsmName='<a href="'+getBaseUrl+urlStr+'">'+fsmObj.Name+'</a></p>';
                    prWrap.DepotName=fsmObj.Depot__r.Name;
                    prWrap.Territory=fsmObj.Territory__r.Name;
                    prWrap.TMName=fsmObj.Territory_Manager__r.Name;
                    prWrap18List.add(prWrap);
                }
            }
        }  
        if(isRecordUpdated==true){
        	update fsmList;
        }
        System.debug('prWrap12List size :'+prWrap12List.size());
        if(prWrap12List.size()>0){
            sendEmail(userEmail,userName,prWrap12List);
        }
        System.debug('prWrap18List size :'+prWrap18List.size());
        if(prWrap18List.size()>0){
            sendEmail(userEmail,userName,prWrap18List);
        }
    }
    }
    
    global void finish(Database.BatchableContext BC) {
        
    }
    
    public void sendEmail(String userEmail,String userName, List<PendingRequisitionWrapper> prList){
       List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {userEmail};
        email.setToAddresses(toAddresses);
        email.setSubject(reminderSubject);
        String htmlBody= '<b>Dear '+userName+',</b><br /><br /><b>'+reminderMsg+' </b><br /><br />';
        email.setHtmlBody(getTableEmailBody(prList,htmlBody));
        emailList.add(email);
        Messaging.sendEmail(emailList);
    }

    
    public class PendingRequisitionWrapper{
        public String fsmName{get;set;}
        public String DepotName{get;set;}
        public String Territory{get;set;}
        public String TMName{get;set;}
        
        PendingRequisitionWrapper(){
            fsmName='';
            DepotName='';
            Territory='';
            TMName='';
        }
    }
    public static string getTableEmailBody(List<PendingRequisitionWrapper> prList,String dearName){
        
        String htmlBody = dearName;
        System.debug('htmlBody : '+htmlBody);
        htmlBody += '<table border="1" style="border-collapse: collapse"><caption><b>Material Requisition Pending Request Details</b></caption><tr><th> Name </th><th> Depot </th><th> Territory Manager </th><th> Territory </th></tr>';
        
        for(PendingRequisitionWrapper wrapper : prList){
            
            String fsmName = wrapper.fsmName; if(wrapper.fsmName == null){fsmName = '[Not Provided]';}
            String DepotName = wrapper.DepotName; if(wrapper.DepotName == null){DepotName = '[Not Provided]';}
            String TMName = wrapper.TMName; if(wrapper.TMName == null){TMName = '[Not Provided]';}
            String Territory = wrapper.Territory; if(wrapper.Territory == null){Territory = '[Not Provided]';}
            
            htmlBody += '<tr><td> ' + fsmName + ' </td><td> ' + DepotName + ' </td><td> ' + TMName + ' </td><td> ' + Territory + ' </td></tr>';
            
        }
        
        //close table...
        htmlBody += '</table>';
        
        system.debug('Email Body: ' + htmlBody);   
        
        return htmlBody;
        
    }
}