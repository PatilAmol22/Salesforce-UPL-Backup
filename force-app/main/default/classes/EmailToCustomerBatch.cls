/*
*   Author : Vaishnavi Ahirrao (EY)
*   Schedular Class - EmailToCustomerBatch
*   CreatedDate: 08-02-2023
*   Description - Send Email related to Bulk Communication functionality.
*   CR: APPS-3974
**/
global class EmailToCustomerBatch implements Database.Batchable<sObject>{

    private String emailBody;
    private List<String> userList;
    private List<Id> ContentDocumentIds;
    private String CustVsContentIds;
    private set<String> SAPCodes;

    global EmailToCustomerBatch(String emailBody, List<String> userList,List<Id> ContentDocumentIds, String CustVsContentIds,set<String> SAPCodes) {
        this.emailBody = emailBody;
        this.userList = userList;
        this.ContentDocumentIds = ContentDocumentIds;
        this.CustVsContentIds = CustVsContentIds;
        this.SAPCodes = SAPCodes;

    }
    global EmailToCustomerBatch(){
        
    }
    global Database.QueryLocator start(Database.BatchableContext BC) {
        system.debug('SAPCodes=> '+SAPCodes);
        return Database.getQueryLocator('Select Id, Name, SAP_Customer_Code__c from Account where SAP_Customer_Code__c=:SAPCodes');
        
    }
    global void execute(Database.BatchableContext BC, List<Account>  accList) {
        
            System.debug('Json Obj=>> '+emailBody);
            String MailBody = emailBody;
            String organizationEmailId;
            List<Id> contentDocIds = new List<Id>();
            List<EmailToCustomer.customerWrapper> UserData = new List<EmailToCustomer.customerWrapper>();
            Messaging.SingleEmailMessage  message = new Messaging.SingleEmailMessage();
            Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage>();
            Messaging.EmailFileAttachment[] emailMsgAttachments = new List<Messaging.EmailFileAttachment>();
            List<ContentVersion> objVersions = new List<ContentVersion>();
            Map<Id,ContentVersion> contIdVsData = new Map<Id,ContentVersion>();
            Map<String,String> CustCodeVsFileName = new Map<String,String>();
            Map<String,List<Id>> custCodeVsContentDocIds = new Map<String,List<Id>>();
            System.debug('CustVsContentIds => '+CustVsContentIds);
            Map<String,List<Id>> jsonObj = (Map<String,List<Id>>)JSON.deserialize(CustVsContentIds,Map<String,List<Id>>.class);
            Map<String,Account> SAPCodeVsAcc = new Map<String,Account>();
            set<String> SAPCodes = new set<String>();
            System.debug('jsonObj =>> '+jsonObj);
            System.debug('userList =>> '+userList);
            System.debug('UserList Size =>> '+userList.size());
            for(String str : userList){
                EmailToCustomer.customerWrapper wrapData = (EmailToCustomer.customerWrapper)JSON.deserialize(str,EmailToCustomer.customerWrapper.class);
                UserData.add(wrapData);
                if(wrapData.SAPCode != null){
                    SAPCodes.add(wrapData.SAPCode);
                }
            }
            
            if(ContentDocumentIds != null &&  ContentDocumentIds.size()>0){
                objVersions = [SELECT Id, OwnerId,ContentDocumentId,FileExtension, VersionData FROM ContentVersion WHERE ContentDocumentId IN:ContentDocumentIds];
            }
            if(objVersions != null && objVersions.size()>0){
                for(ContentVersion cv:objVersions){
                    if(cv.FileExtension == 'csv'){
                        List < String > records = cv.VersionData.toString().split( '\n');
                        System.debug('records ==>>> '+records);
                        //Removing the Header
                        records.remove( 0 );

                        for ( String record : records ) {

                            if ( record != null ) {

                                List < String > row = record.split( ',' );
                                System.debug('ROW ==> '+row);
                                if(row?.size()>1){
                                    CustCodeVsFileName.put(row[0],row[1].trim());
                                }

                            }

                        }
                        contIdVsData.put(cv.ContentDocumentId,cv);
                    }else{
                        contIdVsData.put(cv.ContentDocumentId,cv);
                        contentDocIds.add(cv.ContentDocumentId);
                        custCodeVsContentDocIds = jsonObj;
                    }
                }
               
            }
            System.debug('CustCodeVsFileName => '+CustCodeVsFileName);
            if(CustCodeVsFileName.size()>0){
                for(String custCode:CustCodeVsFileName.keySet()){
                    String fileName = CustCodeVsFileName.get(custCode);
                    System.debug('fileName =>> '+fileName);
                    ContentVersion objVersions2 = [SELECT Id, OwnerId,ContentDocumentId,FileExtension, VersionData FROM ContentVersion WHERE Title =:fileName limit 1];
                    
                        contIdVsData.put(objVersions2.ContentDocumentId,objVersions2);
                        contentDocIds.add(objVersions2.ContentDocumentId);
                        custCodeVsContentDocIds.put(custCode,contentDocIds);
                       
                }
               
               
            }
            System.debug('custCodeVsContentDocIds => '+custCodeVsContentDocIds);
            System.debug('contIdVsData => '+contIdVsData);
            System.debug('SAPCodes =>> '+SAPCodes);

            List<OrgWideEmailAddress> owaList = [SELECT Id FROM OrgWideEmailAddress WHERE Address = 'salesexcellence1@upl-ltd.com'];
            if(null != owaList && !owaList.isEmpty()){
                organizationEmailId = owaList[0].Id;
            }
        	Account account = [SELECT id,Sales_Org_Code__c FROM Account WHERE Id=:UserData[0].Id];
        	EmailTemplate et = new EmailTemplate();
            if(account.Sales_Org_Code__c == '1210'){
               et = [SELECT Id,body,Subject FROM EmailTemplate WHERE DeveloperName = 'Bulk_Communication_Template_SWAL']; 
            }else if(account.Sales_Org_Code__c == '1410'){
                et = [SELECT Id,body,Subject FROM EmailTemplate WHERE DeveloperName = 'Bulk_Communication_Template'];
            }
            
            contact conObj = [select id,Account.Sales_Org__r.Sales_Org_Code__c  from contact where Account.Sales_Org__r.Sales_Org_Code__c ='1210' limit 1];
           // accList = [Select Id, Name, SAP_Customer_Code__c from Account where SAP_Customer_Code__c IN:SAPCodes];
           set<Id> accIds = new set<Id>();
           Map<Id,contact> accVsCon =new map<Id,contact>();
           
            for(Account acc : accList){
                if(!SAPCodeVsAcc.containsKey(acc.SAP_Customer_Code__c)){
                    SAPCodeVsAcc.put(acc.SAP_Customer_Code__c,acc);
                }
                accIds.add(acc.Id);
            }
            List<Contact> conList = [Select Id,AccountId from Contact where AccountId IN: accIds];
            if(conList != null && conList.size()>0){
                for(contact con: conList){
                    if(!accVsCon.containsKey(con.AccountId)){
                        accVsCon.put(con.AccountId,con);
                    }
                }
            }
            System.debug('SAPCodeVsAcc Values  => '+SAPCodeVsAcc);
          
           for(EmailToCustomer.customerWrapper user:UserData){
                if(!String.isBlank(user.Email) && SAPCodeVsAcc?.get(User.SAPCode) != null){
                    Id accId = SAPCodeVsAcc?.get(User.SAPCode)?.Id;
                    List<String> uList = new List<String>{user.Email};
                    //System.debug('uList =>>> '+User);
                    emailMsgAttachments = new List<Messaging.EmailFileAttachment>();
                    message = new Messaging.SingleEmailMessage();
                    message.setOrgWideEmailAddressId(organizationEmailId);
                    message.setCharset('UTF8');
                    message.setTemplateId(et.Id);
                    message.setWhatId(SAPCodeVsAcc?.get(User.SAPCode)?.Id);
                    message.setSubject(et.Subject);
                    if(accVsCon != null && accVsCon.size()>0 && accVsCon.get(accId) != null){
                        message.setTargetObjectId(accVsCon.get(accId).Id);
                    }else{
                        message.setTargetObjectId(conObj.Id);
                    }
                    message.setTreatTargetObjectAsRecipient(false);
                    message.setTreatBodiesAsTemplate(true);
                    List<String> bodyText = et.body.split(';');
                    System.debug('body list=>'+bodyText);
                    String body = bodyText[0];
                    //body = body.replace('{body}',MailBody);
                    MailBody = body+MailBody+bodyText[1];
                    message.setHtmlBody(MailBody);
                    MailBody = emailBody;
                    message.setToAddresses(uList);
                    //message.setSaveAsActivity(false);
                    //system.debug('check to address :'+message); 
                    if(custCodeVsContentDocIds != null && custCodeVsContentDocIds.size()>0 && custCodeVsContentDocIds.containsKey(user.SAPCode) && contIdVsData.size()>0){
                        List<Id> cntIds = custCodeVsContentDocIds.get(user.SAPCode);
                        System.debug('cntIds =>> '+cntIds);
                        for(Id contId : cntIds){
                            Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                            efa.setFileName('attachment'+contId+'.'+contIdVsData?.get(Id.valueOf(contId))?.FileExtension);
                            efa.setBody(contIdVsData?.get(Id.valueOf(contId))?.VersionData);
                            emailMsgAttachments.add(efa);
                        }
                        message.setFileAttachments(emailMsgAttachments);
                    }
                    //System.debug('message=>> => '+message);
                    messages.add(message);  
                }    
            }    
            //System.debug('messages => '+messages);
            System.debug('messages size => '+messages.size());
            Messaging.sendEmail(messages);
        
    }
    global void finish(Database.BatchableContext BC) {
        AsyncApexJob job=[select id,NumberOfErrors,JobItemsProcessed,Status,TotalJobItems,CompletedDate from AsyncApexJob where id =:bc.getJobId()];
        system.debug('Finish Method--->'+job.JobItemsProcessed);
    }
}