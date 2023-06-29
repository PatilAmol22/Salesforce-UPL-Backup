/* Developer Name : Nandhini Perumalsamy
* Purpose: Inserts record into EmailMessage sObject 
* Related to: EmailMessageTrigger
* CR: APPS-3946 
* Author: EY
* Created Date: 29/12/2022
* ModifiedBy: Vaishnavi
* LastModifiedDate: 16-Feb-2023
*/
public without sharing class EmailMessageTriggerhandler {
    
    //static final String EMAIL_DETAILS = System.Label.Email_To_Case_Email_Ids;

    //If the cusomer replies to the EMails when case is Resolved,below method resposible to reopen that case.
    /*public static void updateCaseStatusToResolved(List<EmailMessage> newMessageList) {   
        
        system.debug('newMessageList :'+newMessageList);
        Map<Id, EmailMessage> emailMessageMap = new Map<Id, EmailMessage>(); 
        
        for(EmailMessage emailMessageRecord : newMessageList) {
            if(!(EMAIL_DETAILS.containsIgnoreCase(emailMessageRecord.FromAddress))){
                system.debug('inside if');
                emailMessageMap.put(emailMessageRecord.ParentId, emailMessageRecord);
               
            }  
         
        }

        EmailMessageService.updateCaseStatusService(emailMessageMap); 
    }*/

    
  /**
   * CR- APPS-3974
   * @description: populate the Account record from Bulkcommunications screen
   * @param: newMessageList
   * @Author: Vaishanvi
   * */
    public static void beforeInsert(List<EmailMessage> newMessageList) {   
        system.debug('newMessageList :'+newMessageList);
        EmailTemplate emailTemplateRecord = getEmailTemplate();
        for(EmailMessage emailMessageRecord : newMessageList) {
            if(null != emailMessageRecord.RelatedToId){
                String relatedId = String.valueOf(emailMessageRecord.RelatedToId);
                if(String.isNotBlank(relatedId) && relatedId.startsWith('001') && emailMessageRecord.Subject == emailTemplateRecord.Subject){
                    emailMessageRecord.Account__c = emailMessageRecord.RelatedToId;
                }   
            }
        }
    }
    
 /*
  * * CR- APPS-3974
    * Description: Retrieve all templateDetails in EmailTemplate using SingleTon designPattern
	* Param: NA
	* CR- APPS-3974
	* @Author: Vaishanvi
	* return : mEmailTemplate
    * */   
    public static EmailTemplate mEmailTemplate;
    public static EmailTemplate getEmailTemplate(){
        if(null == mEmailTemplate){
            mEmailTemplate = [SELECT Id, body, Subject FROM EmailTemplate WHERE DeveloperName = 'Bulk_Communication_India']; 
        }
        return mEmailTemplate;
    }
}