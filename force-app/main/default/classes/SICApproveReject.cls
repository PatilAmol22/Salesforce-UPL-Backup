public without sharing class SICApproveReject {
    
    @auraenabled
    public static InitWrapper init(Id StockInChannelId){ //custId
        
        list<Stock_In_channel__c> liSIC = [select id ,Status_1__c,Status_2__c,Status_3__c,
                                           Status_4__c,Status_5__c,Status_6__c,Status_7__c,
                                           Status_8__c,Status_9__c,Status_10__c,Status_11__c,
                                           Status_12__c,Territory__r.Region__r.RegionHead__c
                                           from Stock_In_channel__c 
                                           where id = :StockInChannelId];
        
        list<SIC_Approval__c> liApprovalHistory = [select id, Status__c, Comments__c,FORMAT(createddate),CreatedBy.name from SIC_Approval__c
                                                   where Month__c = :Date.Today().Month()
                                                   and Stock_In_Channel__c = :StockInChannelId
                                                  order by createddate desc];
        InitWrapper I = new InitWrapper();
        if(liSIC.size()==0){
            
            I.Status = 'Not Started';
            I.isRegionalManager = false;
            I.SubmittedForApprovalStatus = false;
            
        }
        else{
            
            
            string Status = 'Status_'+Date.Today().Month()+'__c';
            if(string.isBlank(string.valueOf(liSIC[0].get(Status)))){
            I.Status = 'Not Started';    
            }
            else{
            I.Status = string.valueOf(liSIC[0].get(Status));
            }
            list<Territory_Distributor__c> TD = [select id, Region__r.RegionHead__c 
                                           from Territory_Distributor__c
                                           where Region__r.RegionHead__c = :userinfo.getUserId()];
            if(TD.size()>0){
            if(TD[0].Region__r.RegionHead__c == userinfo.getUserId()){ //liSIC[0].Territory__r.Region__r.RegionHead__c
                I.isRegionalManager = true;
            }
            }
            else{
                I.isRegionalManager = false;    
            }
            
            if(string.valueOf(liSIC[0].get(Status)) == 'Submitted for Approval'){
                I.SubmittedForApprovalStatus = true;
            }
            else{
                I.SubmittedForApprovalStatus = false;
            }
            
        }
        
        I.liApprovalHistory = liApprovalHistory;
        system.debug('I'+I);
        return I;
    }
    
    //Wrapper Class to get SKU with Pagination  
    public class InitWrapper {
        
        @AuraEnabled
        public string Status {get;set;}
        @AuraEnabled
        public boolean isRegionalManager {get;set;}
        @AuraEnabled
        public boolean SubmittedForApprovalStatus {get;set;}
        @AuraEnabled
        public list<SIC_Approval__c> liApprovalHistory {get;set;}
        
    }
 
    @auraenabled
    public static list<SIC_Approval__c> SubmitForApprovalApex (Id StockInChannelId){ //custId
        system.debug('StockInChannelId '+StockInChannelId);
        list<Stock_In_channel__c> liSIC = [select id ,Territory__r.Region__r.RegionHead__c,Sales_Rep__c,
                                           Territory__c,Status_1__c,Status_2__c,Status_3__c,Status_4__c,
                                           Status_5__c,Status_6__c,Status_7__c,Status_8__c,Status_9__c,
                                           Status_10__c,Status_11__c,Status_12__c                                           
                                           from Stock_In_channel__c 
                                           where id = :StockInChannelId];
        list<Territory_Distributor__c> liTD = [select id 
                                              from Territory_Distributor__c
                                              where TerritoryManager__c = :userinfo.getUserId()];
       
        string MonthStatus = 'Status_'+Date.Today().Month()+'__c';
        string userId = userinfo.getUserId();
        liSIC[0].put(MonthStatus, 'Submitted for Approval');
        liSIC[0].put('Sales_Rep__c', userId);
        liSIC[0].put('Territory__c', liTD[0].Id);
        update liSIC[0];
        
        SIC_Approval__c SICA = new SIC_Approval__c();
        SICA.status__c = 'Submitted for Approval';
        //SICA.Comments__c = Comments;
        SICA.Stock_In_Channel__c = StockInChannelId;
        SICA.Month__c = Date.Today().Month();
        insert SICA;
        
        list<SIC_Approval__c> liApprovalHistory = [select id, Status__c, Comments__c ,CreatedBy.Name,createddate
                                                                                                     from SIC_Approval__c
                                                                                                     where Month__c = :Date.Today().Month()
                                                                                                     and Stock_In_Channel__c = :StockInChannelId
                                                  order by createddate desc];
                                                          
        return liApprovalHistory;
        
        
    }
    
    @auraenabled
    public static list<SIC_Approval__c> ApproveReject(Boolean Approved, 
                                                      String Comments,
                                                      Id StockInChannelId){ //CustomerId
                                                          
                                                          list<Stock_In_channel__c> liSIC = [select id , Sales_Rep__c
                                                                                             from Stock_In_channel__c 
                                                                                             where id = :StockInChannelId];
                                                          
                                                          if(Approved){
                                                              //liSIC[0].Status_June__c = 'Approved';
                                                              string MonthStatus = 'Status_'+Date.Today().Month()+'__c';
                                                              liSIC[0].put(MonthStatus, 'Approved');
                                                              update liSIC[0];
                                                              
                                                              SIC_Approval__c SICA = new SIC_Approval__c();
                                                              SICA.status__c = 'Approved';
                                                              SICA.Comments__c = Comments;
                                                              SICA.Stock_In_Channel__c = StockInChannelId;
                                                              SICA.Month__c = Date.Today().Month();
                                                              insert SICA;
                                                              
                                                              EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where name = 'SIC Approved Template'];  
                                                              
                                                              String templateId = emailTemplate.Id;
                                                              String userId = liSIC[0].Sales_Rep__c;
                                                              String whatId = liSIC[0].Id;
                                                              
                                                              Messaging.SingleEmailMessage email = Messaging.renderStoredEmailTemplate(templateId, userId, whatId);
                                                              
                                                              String emailSubject = email.getSubject();
                                                              String emailTextBody = email.getPlainTextBody();
                                                              String emailHTMLBody = email.getHtmlBody();
                                                              emailHTMLBody = emailHTMLBody.replace('Comentário', 'Comentário :'+Comments);
                                                              system.debug('emailTextBody '+emailHTMLBody);
                                                              email.setTargetObjectId(userId);
                                                              email.setSubject(emailSubject);
                                                              email.setPlainTextBody(emailTextBody);
                                                              email.saveAsActivity = false;
                                                              email.setHtmlBody(emailHTMLBody);
                                                              
                                                              if(!Test.isRunningTest()) {
                                                                  Messaging.SendEmailResult[] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
                                                              }
                                                              
                                                              
                                                          }
                                                          else{
                                                              //liSIC[0].Status_June__c = 'Rejected';
                                                              string MonthStatus = 'Status_'+Date.Today().Month()+'__c';
                                                              liSIC[0].put(MonthStatus, 'Rejected');
                                                              update liSIC[0];
                                                              
                                                              SIC_Approval__c SICA = new SIC_Approval__c();
                                                              SICA.status__c = 'Rejected';
                                                              SICA.Comments__c = Comments;
                                                              SICA.Stock_In_Channel__c = StockInChannelId;
                                                              SICA.Month__c = Date.Today().Month();
                                                              insert SICA;
                                                              
                                                              EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where name = 'SIC Rejected Template'];  
                                                              
                                                              String templateId = emailTemplate.Id;
                                                              String userId = liSIC[0].Sales_Rep__c;
                                                              String whatId = liSIC[0].Id;
                                                              
                                                              Messaging.SingleEmailMessage email = Messaging.renderStoredEmailTemplate(templateId, userId, whatId);
                                                              
                                                              String emailSubject = email.getSubject();
                                                              String emailTextBody = email.getPlainTextBody();
                                                              emailTextBody = emailTextBody+ 'Comentário: '+Comments;
                                                              String emailHTMLBody = email.getHtmlBody();
                                                              emailHTMLBody = emailHTMLBody.replace('Comentário', 'Comentário :'+Comments);
                                                              
                                                              email.setTargetObjectId(userId);
                                                              email.setSubject(emailSubject);
                                                              email.setPlainTextBody(emailTextBody);
                                                              email.saveAsActivity = false;
                                                              email.setHtmlBody(emailHTMLBody);
                                                              
                                                              if(!Test.isRunningTest()) {
                                                                  Messaging.SendEmailResult[] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
                                                              }
                                                              
                                                          }
                                                          
                                                          
                                                          list<SIC_Approval__c> liApprovalHistory = [select id, Status__c, Comments__c ,CreatedBy.Name,createddate
                                                                                                     from SIC_Approval__c
                                                                                                     where Month__c = :Date.Today().Month()
                                                                                                     and Stock_In_Channel__c = :StockInChannelId
                                                                                                    order by createddate desc];
                                                          
                                                          return liApprovalHistory;
                                                          
                                                      }
    
    
}