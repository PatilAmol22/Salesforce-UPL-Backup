/*  
* Name: SendEmailApproval
* Created On: 22th Feb 2023
* Author: Amol Patil
* Description: Sending mails to selected email address for those orders which status is Approved and SubStatus is pending.
*/
public class SendEmailApproval {
    
    @InvocableMethod(label='Get Emails' description='Returns the list of Email Address corresponding to the specified RSO IDs.' category='Email')
    public static void sendEmailToOperator(List<Id> RSOId) {
        List<String> Emails = new List<String>();
        List<String>  CCAddressEmails = new List<String>();
        List<Return_Sales_Order__c> rsoSingleRecord = [SELECT Logistics_Operator_Email__c,Order_Status__c,Sub_Status__c FROM Return_Sales_Order__c WHERE Id in:RSOId];
        EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where DeveloperName ='SOR_Email_Template_To_Logistic_Operator'];
        User usr=new User();
        if(test.isRunningTest()){
             usr = [SELECT Id,name,email FROM User limit 1];
        }else{
             usr = [SELECT Id,name,email FROM User where Username =: System.Label.EmailUsername and profile.name =: System.Label.ProfileName1];
        }
            CCAddressEmails.add(usr.Email);
        Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage>();
        
        for (Return_Sales_Order__c mail: rsoSingleRecord) {
            List<String> singleEmail = new List<String>();
            if(mail.Logistics_Operator_Email__c != null){
                singleEmail = mail.Logistics_Operator_Email__c.split(';');
            }
            system.debug('Single Email=='+singleEmail);
            Emails=singleEmail;
            system.debug('Emails@@@'+Emails);
            try{
                if(mail.Order_Status__c =='Approved' && mail.Sub_Status__c =='Pending At Collection'){
                    System.debug('Inside Approved If');
                    Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                    message.setTemplateID(emailTemplate.Id);
                    message.setWhatId(mail.Id); 
                    message.setSaveAsActivity(false);
                    message.setTargetObjectId(userinfo.getUserId());
                    message.toAddresses = Emails;
                    message.ccaddresses = CCAddressEmails;
                    messages.add(message);
                    
                    Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
                    for(Messaging.SendEmailResult sr:results){
                        if (sr.success){
                            System.debug('The email was sent successfully.');
                            
                        }else{
                            System.debug('The email failed to send: ' +  sr.errors[0].message);
                        }
                    }
                }
            }catch(Exception e){
                System.debug('An unexpected error has occurred: ' + e.getMessage()+e.getLineNumber());
                
            }
        }
    }
}