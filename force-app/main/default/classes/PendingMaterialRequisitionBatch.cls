/*
* Name: PendingMaterialRequisitionBatch
* Author: Azhar Shaikh 
* Description: Used for sending pending reminder to HO Marketing
*/

global class PendingMaterialRequisitionBatch implements Database.Batchable<sObject>, Database.Stateful {
    
   
    String reminderSubject='';
    String reminderMsg='';
    String emailStr='';
    String userName='';
    public List<String> salesOrgCode= new List<String>();// Edited by Sandeep Vishwakarma - SKI 27-01-2023
  	public List<String> fsmName=new List<String>();  
    public List<PendingRequisitionWrapper> psList=new List<PendingRequisitionWrapper>();  
    global PendingMaterialRequisitionBatch(List<String> salesOrgCode,String reminderSubject, String reminderMsg){// Edited by Sandeep Vishwakarma - SKI 27-01-2023
        this.salesOrgCode=salesOrgCode;
        this.reminderSubject=reminderSubject;
        this.reminderMsg=reminderMsg;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        System.debug('salesOrgCode : '+salesOrgCode);
        String status='Pending';
        String subStatus='Pending for Approval 3';
        // Edited by Sandeep Vishwakarma - SKI 27-01-2023
        String query = 'SELECT Id,Name,Depot__r.Name,Territory_Manager__r.Name,Territory__r.Name,Status__c,Sub_Status__c,Approval_Submission_Date_Time__c,Auto_Approved_1__c,Auto_Approved_2__c,X1st_Approval_Date_Time__c,X2nd_Approval_Date_Time__c,X3rd_Approval_Date_Time__c,Office_Manager__r.Email, Sales_Assistant__r.Email,Technical_Manager__r.Email,Technical_Manager__r.Name,LastModifiedById FROM Free_Sample_Management__c Where SalesOrg__r.Sales_Org_Code__c IN: salesOrgCode AND Status__c=\''+status+'\' AND Sub_Status__c=\''+subStatus+'\'';
        System.debug('query : '+query);
        return Database.getQueryLocator(query);
    }
    
    // Execute method
    
    global void execute(Database.BatchableContext BC, List<Free_Sample_Management__c> freeSampleManagementList) {
        
        for(Free_Sample_Management__c fsm : freeSampleManagementList)
        {    
            Long dt3Long=0;
            Long dt2Long=0;
            Long x2ndhours=0;
            if(fsm.X2nd_Approval_Date_Time__c!=null){
                Datetime todayDate = Datetime.now();
                Datetime x2ndDatetime= fsm.X2nd_Approval_Date_Time__c;
                dt2Long = todayDate.getTime();
                dt3Long = x2ndDatetime.getTime();
            }
            
            // Use for hours calculation
            if(dt3Long!=0){
                Long milliseconds = dt2Long - dt3Long;
                Long seconds = milliseconds / 1000;
                Long minutes = seconds / 60;
                x2ndhours = minutes / 60;
                System.debug('x2ndhours :'+x2ndhours);
            }
            
            
            // Check condition on notification checkbox 
            
            if(x2ndhours>12) {
                if(fsm.Status__c=='Pending' && fsm.Sub_Status__c=='Pending for Approval 3'){
                    userName=fsm.Technical_Manager__r.Name;
                    emailStr=fsm.Technical_Manager__r.Email;
                    
                    PendingRequisitionWrapper wrapper=new PendingRequisitionWrapper();
                    String getBaseUrl=URL.getSalesforceBaseUrl().toExternalForm();
                    String urlStr='/lightning/r/Free_Sample_Management__c/' + fsm.Id + '/edit';
                    wrapper.fsmName='<a href="'+getBaseUrl+urlStr+'">'+fsm.Name+'</a></p>';
                    wrapper.DepotName=fsm.Depot__r.Name;
                    wrapper.Territory=fsm.Territory__r.Name;
                    wrapper.TMName=fsm.Territory_Manager__r.Name;
                    psList.add(wrapper);
                }
            }
        }
        
    }   
    
    // Finish Method
    
    global void finish(Database.BatchableContext BC) {
        System.debug('psList :'+psList);
        if(psList.size()>0){
            sendEmail(psList);
        }
        
    }
    
    public void sendEmail(List<PendingRequisitionWrapper> prList){
        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();

        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[]{emailStr};// {'Azhar.shaikh@skinternational.com'};
        email.setToAddresses(toAddresses);
        email.setSubject(reminderSubject);
        String htmlBody= '<b> Dear '+userName+',</b><br /><br /><b>'+reminderMsg+'</b><br /><br />';
        email.setHtmlBody(getTableEmailBody(prList,htmlBody)); // Add vf page for body
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