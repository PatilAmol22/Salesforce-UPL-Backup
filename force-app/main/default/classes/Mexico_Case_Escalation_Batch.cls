/* Batch file to check unclosed cases of type Mexico Distributor and send Email notification if case has exceeded the timeframe to close 
 * the case according to the escalation matrix stored in custom setting (Mexico_Case_Escalation_Matrix__c). 
 * Written by Virag Mhatre  * */
global class Mexico_Case_Escalation_Batch  implements  Database.Batchable<SObject> 
{
     global Database.QueryLocator start(Database.BatchableContext  BC)
     {
         Id RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Mexico Distributor').getRecordTypeId();
         return Database.getQueryLocator('SELECT  CaseNumber, Subject, Description, CreatedDate, Approval_Submitted_Date__c, OpenNewEscalationDateTime__c, Status, Type FROM Case WHERE RecordTypeId =\'' + RecordTypeId +'\' AND isEscalated = false AND Status!=\'Closed\' AND Status=\'Approved\' AND Approval_Submitted_Date__c != null AND Type!=\'\' AND AccountId != null');  
     }    
      
     global void execute(Database.BatchableContext ctx, List<Case> scope)
     {
         system.debug('SCOPE >>> '+scope);
         
         List<Mexico_Case_Reminder_Email_Address__c> mcreu = new List<Mexico_Case_Reminder_Email_Address__c>([SELECT Id, Email_Address__c, Name FROM Mexico_Case_Reminder_Email_Address__c WHERE Name = 'Mexico Case']);

         /* Retrieving Case escalation matrix from custom setting into a list and then storing it in Map with case type as key
         and time to close as value */
         
         List<Mexico_Case_Escalation_Matrix__c> m = new List<Mexico_Case_Escalation_Matrix__c>([SELECT Id, Case_Type__c, Time_to_close__c FROM Mexico_Case_Escalation_Matrix__c]);
         system.debug(m);
         
         Map<String, Decimal> EscalationMatrixMap = new Map<String, Decimal>();
         for(Mexico_Case_Escalation_Matrix__c mcem : m ){
             if(!EscalationMatrixMap.containsKey(mcem.Case_Type__c)){
             EscalationMatrixMap.put(mcem.Case_Type__c , mcem.Time_to_close__c);
                 }
             }
         system.debug('mcem>>>'+EscalationMatrixMap);  
        
         /* Checking whether case is open and has exceeded the time to close hours and sending escalation email if true */
         
         List<Case> CaseNumbersForReminder = new List<Case>();
 
         for(Case c : scope)
       {  
           if(c.OpenNewEscalationDateTime__c==null){
           Double Hours = (System.now().getTime() - c.Approval_Submitted_Date__c.getTime())/(1000.0*60.0*60.0); 
           system.debug('Hours Completed after approval for case no : '+c.CaseNumber+'>>> '+Hours);
           Decimal TimeToClose = EscalationMatrixMap.get(c.Type);
           system.debug('Time to Close for case no : '+c.CaseNumber+'>>> '+TimeToClose);
           if(Hours > TimeToClose && c.Status!='Closed'){
               CaseNumbersForReminder.add(c);      
               c.OpenNewEscalationDateTime__c = System.now();
             //   c.IsEscalated = true;
           }
          }
           if(c.OpenNewEscalationDateTime__c!=null){
           Double Hours = (System.now().getTime() - c.OpenNewEscalationDateTime__c.getTime())/(1000.0*60.0*60.0); 
           system.debug('Hours Completed after escalation for case no : '+c.CaseNumber+'>>> '+Hours);
           Decimal TimeToClose = EscalationMatrixMap.get(c.Type);
           system.debug('Time to Close for case no : '+c.CaseNumber+'>>> '+TimeToClose);
           if(Hours > TimeToClose && c.Status!='Closed'){
               CaseNumbersForReminder.add(c);      
               c.OpenNewEscalationDateTime__c = System.now();
             //   c.IsEscalated = true;
           }
          }
           if(CaseNumbersForReminder.size()>0){
            String mailbody='';
        		Decimal CaseAgeing = (System.now().getTime() - c.Approval_Submitted_Date__c.getTime())/(1000.0*60.0*60.0);
                  Decimal CaseAgeingRoundedOff = CaseAgeing.setScale(2);
                    mailbody=mailbody+system.Label.Mexico_Case_Reminder_Header+'.<br><br>';
                   // mailbody=mailbody+'<table cellpadding="5" cellspacing="2" border="0"><tr><div style="border:1px solid #222;">Case Number</div><div style="border:1px solid #222;">Case Type</div><div style="border:1px solid #222;">Case Ageing<br>(In Hours)</br></div><div style="border:1px solid #222;">Subject</div><div style="border:1px solid #222;">Description</div>';                                    
                  //mailbody=mailbody+'<div style="border:1px solid #222;">'+c.CaseNumber+'</div><div style="border:1px solid #222;">'+c.Type+'</div><div style="text-align: center; vertical-align: middle; border:1px solid #222;">'+CaseAgeingRoundedOff+'</div><div style="border:1px solid #222;">'+c.Subject+'</div><div style="border:1px solid #222;">'+c.Description+'</div></tr>';
                mailbody=mailbody+'<table cellpadding="5" cellspacing="0" border="1"><tr><td style="text-align: center; border:1px solid #222;">'+system.Label.Mexico_Case_Reminder_Case_Number+'</td><td style="text-align: center; vertical-align: middle;border:1px solid #222;">'+c.CaseNumber+'</td></tr><tr><td style="text-align: center; vertical-align: middle;border:1px solid #222;">'+system.Label.Mexico_Case_Reminder_Case_Type+'</td><td style="text-align: center; vertical-align: middle;border:1px solid #222;">'+c.Type+'</td></tr><tr><td style="text-align: center; vertical-align: middle;border:1px solid #222;">'+system.Label.Mexico_Case_Reminder_Case_Ageing+'</br></td><td style="text-align: center; vertical-align: middle; border:1px solid #222;">'+CaseAgeingRoundedOff+'</td></tr><tr><td style="text-align: center; vertical-align: middle;border:1px solid #222;">'+system.Label.Mexico_Case_Reminder_Case_Subject+'</td><td style="text-align: center; vertical-align: middle;border:1px solid #222;">'+c.Subject+'</td></tr><tr><td style="text-align: center; vertical-align: middle;border:1px solid #222;">'+system.Label.Mexico_Case_Reminder_Case_Description+'</td><td style="text-align: center; vertical-align: middle;border:1px solid #222;">'+c.Description+'</td></tr>';
                mailbody +='</table><br>';                
                mailbody +=+system.Label.Mexico_Case_Reminder_Thank_you+'.';
               
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(new List<String> {mcreu[0].Email_Address__c});              
                mail.setSubject('Case Reminder');
                mail.setHtmlBody(mailbody);    
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
           }
           CaseNumbersForReminder.clear();
               
       }
         
         update scope;
   }
           
    global void finish(Database.BatchableContext ctx)
    {
     
    }

}