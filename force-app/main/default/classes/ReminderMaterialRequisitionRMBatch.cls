/*
* Name: ReminderMaterialRequisitionRMBatch
* Author: Azhar Shaikh 
* Description: Used for sending pending request reminder to RM 
*/

global class ReminderMaterialRequisitionRMBatch implements Database.Batchable<sObject>, Database.Stateful {
    
    
    String reminderSubject='';
    String reminderMsg='';
    String userName='';
    String userEmail='';
    public List<String> salesOrgCode= new List<String>();// Edited by Sandeep Vishwakarma - SKI 27-01-2023 AF Material Requisition
    public ReminderMaterialRequisitionRMBatch(List<String> salesOrgCode,String reminderSubject, String reminderMsg){
        this.salesOrgCode=salesOrgCode;
        this.reminderSubject=reminderSubject;
        this.reminderMsg=reminderMsg;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        System.debug('salesOrgCode : '+salesOrgCode);
        String query='SELECT Id, Name, RegionHead__c,FMM_User__c, Zone__c, Sales_Org_Code__c, Region_Name__c,RegionHead__r.Name,RegionHead__r.Email,FMM_User__r.Name,FMM_User__r.Email, SalesOrg__c, RegionHeadActive__c,Zone__r.ZMMUser__c,Zone__r.ZonalHead__c,Zone__r.ZMMUser__r.Email,Zone__r.ZMMUser__r.Name,Zone__r.ZonalHead__r.Email,Zone__r.ZonalHead__r.Name FROM Region__c where Sales_Org_Code__c IN :salesOrgCode';// AND RegionHeadActive__c=true';// Edited by Sandeep Vishwakarma - SKI 27-01-2023 AF Material Requisition
        System.debug('query : '+query);
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Region__c> regionList) {
        
        boolean isRecordUpdated=false;
        String rmId='';
        
        if(!salesOrgCode.contains('1410')){
            if(regionList[0].FMM_User__c!=null){
                System.debug('regionList[0].FMM_User__c :'+regionList[0].FMM_User__c);
                rmId=regionList[0].FMM_User__c;
                userEmail=regionList[0].FMM_User__r.Email;
                userName=regionList[0].FMM_User__r.Name;  
            }else{
                rmId=regionList[0].RegionHead__c;
                userEmail=regionList[0].RegionHead__r.Email;
                userName=regionList[0].RegionHead__r.Name;  
            }
        }else{
            if(regionList[0].Zone__r.ZMMUser__c!=null){
                System.debug('regionList[0].FMM_User__c :'+regionList[0].Zone__r.ZMMUser__c);
                rmId=regionList[0].Zone__r.ZMMUser__c;
                userEmail=regionList[0].Zone__r.ZMMUser__r.Email;
                userName=regionList[0].Zone__r.ZMMUser__r.Name;  
            }else{
                rmId=regionList[0].Zone__r.ZonalHead__c;
                userEmail=regionList[0].Zone__r.ZonalHead__r.Email;
                userName=regionList[0].Zone__r.ZonalHead__r.Name;  
            } 
        }
        System.debug('rmId :'+rmId);
        String status='Pending';
        String subStatus='Pending for Approval 1';
        
        List<PendingRequisitionWrapper> prWrap12List=new List<PendingRequisitionWrapper>();
        List<PendingRequisitionWrapper> prWrap18List=new List<PendingRequisitionWrapper>();
        
        List<Free_Sample_Management__c> fsmList=[SELECT Id,Name,Depot__r.Name,Territory_Manager__r.Name,Territory__r.Name,Status__c,Sub_Status__c,Approval_Submission_Date_Time__c,Auto_Approved_1__c,Auto_Approved_2__c,X1st_Approval_Date_Time__c,X2nd_Approval_Date_Time__c,X3rd_Approval_Date_Time__c,Office_Manager__r.Name,Office_Manager__r.Email,Sales_Assistant__r.Name, Sales_Assistant__r.Email,Technical_Manager__r.Email,RMNotification12HrsChecked__c,RMNotification18HrsChecked__c,LastModifiedById FROM Free_Sample_Management__c Where Office_Manager__c=:rmId AND Status__c=:status AND Sub_Status__c=:subStatus AND Approval_Submission_Date_Time__c!=null AND X1st_Approval_Date_Time__c=null AND X2nd_Approval_Date_Time__c=null AND X3rd_Approval_Date_Time__c=null AND Office_Manager__c!=null];
        for(Free_Sample_Management__c fsmObj:fsmList){
             Datetime todayDate = Datetime.now();
            Long dt2Long = todayDate.getTime();
            Long submithours=0;
            if(fsmObj.Approval_Submission_Date_Time__c!=null){
                Datetime asdtDatetime= fsmObj.Approval_Submission_Date_Time__c;
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
            
            if(submithours>12){
              if(fsmObj.RMNotification12HrsChecked__c!=true){
                    fsmObj.RMNotification12HrsChecked__c=true;
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
            
            if(submithours>18){
                if(fsmObj.RMNotification18HrsChecked__c!=true){
                    fsmObj.RMNotification18HrsChecked__c=true;
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
        System.debug('prWrap12List :'+prWrap12List);
        if(prWrap12List.size()>0){
            sendEmail(userEmail,userName,prWrap12List);
        }
        System.debug('prWrap18List size :'+prWrap18List.size());
        if(prWrap18List.size()>0){
            sendEmail(userEmail,userName,prWrap18List);
        }
        
    }   
    
    // Finish Method
    
    global void finish(Database.BatchableContext BC) {
        
    }
    
    public void sendEmail(String userEmail, String userName, List<PendingRequisitionWrapper> prList){
       List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {userEmail};
        email.setToAddresses(toAddresses);
        email.setSubject(reminderSubject);
        String htmlBody= '<b>Dear '+userName+',</b><br /><br /><b>'+reminderMsg+'</b><br /><br />';
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
        htmlBody += '<table border="1" style="border-collapse: collapse"><caption><b>Material Requisition Pending Request Details</b></caption><tr><th>Name</th><th>DepotName</th><th>Territory Manager</th><th>Territory</th></tr>';
        
        for(PendingRequisitionWrapper wrapper : prList){
            
            String fsmName = wrapper.fsmName; if(wrapper.fsmName == null){fsmName = '[Not Provided]';}
            String DepotName = wrapper.DepotName; if(wrapper.DepotName == null){DepotName = '[Not Provided]';}
            String TMName = wrapper.TMName; if(wrapper.TMName == null){TMName = '[Not Provided]';}
            String Territory = wrapper.Territory; if(wrapper.Territory == null){Territory = '[Not Provided]';}
            
            htmlBody += '<tr><td>' + fsmName + '</td><td>' + DepotName + '</td><td>' + TMName + '</td><td>' + Territory + '</td></tr>';
            
        }
        
        //close table...
        htmlBody += '</table>';
        
        system.debug('Email Body: ' + htmlBody);   
        
        return htmlBody;
        
    }
}