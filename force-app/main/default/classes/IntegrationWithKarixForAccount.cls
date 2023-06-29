/**************************************************************************************
Apex Class Name  : IntegrationWithKarixForAccount
Version          : 1.0
Created Date     : 08 Apr 020
Function         : Class for sending Account messages
Modification Log :
*   Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* 	Deeksha Gupta             	08 Apr 020               
*************************************************************************************/
public class IntegrationWithKarixForAccount {
    @InvocableMethod
    public static void getAccountContentsForSMS(List<Task> taskList){
        if(!taskList.isEmpty()){
            List<id> accIds = new List<id>();
            String senderId = 'Nurture';
            for(Task t :taskList){
                accIds.add(t.whatId);
                List<Account> accountList = new List<Account>();
                    if(!accIds.isEmpty()){
                        accountList = [Select RecordTypeId,State_Language__pc,Preferred_Language__pc,UniquePhone__c from Account where Id IN :accIds];
                       if(!accountList.isEmpty()){
                           if(accountList[0].RecordTypeId == Schema.SObjectType.Account.getRecordTypeInfosByName().get('SWAL Farmer').getRecordTypeId() ||
                               accountList[0].RecordTypeId == Schema.SObjectType.Account.getRecordTypeInfosByName().get('SWAL PreRegistered Farmer').getRecordTypeId()
                              ){
                                  system.debug('SWAL');
                                  String content = '';
                                  String encodedcontent = '';
                                  List<SMS_Template__c> smsTemplate = new List<SMS_Template__c>();
                                  if(accountList[0].Preferred_Language__pc!=null){
                                      if(accountList[0].Preferred_Language__pc=='Marathi'||accountList[0].Preferred_Language__pc=='Bengali'||accountList[0].Preferred_Language__pc=='Kannada'||accountList[0].Preferred_Language__pc=='Gujarati'||accountList[0].Preferred_Language__pc=='Punjabi'||accountList[0].Preferred_Language__pc=='Tamil'||accountList[0].Preferred_Language__pc=='Telugu'||accountList[0].Preferred_Language__pc=='English'){
                                        smsTemplate = [Select id,Name__c,ObjectName__c,Text__c from SMS_Template__c where ObjectName__c = 'SWAL_Account' AND Name__c like : '%'+accountList[0].Preferred_Language__pc+'%'];
                                    }
                                    else{
                                        smsTemplate = [Select id,Name__c,ObjectName__c,Text__c from SMS_Template__c where ObjectName__c = 'SWAL_Account' AND Name__c like : '%Hindi%'];
                                    }
                                    
                                    System.debug('@@@@@'+smsTemplate );
                                  }
                                  if(!smsTemplate.isEmpty())
                                  { 
                                      content = smsTemplate[0].Text__c;
                                      encodedcontent = EncodingUtil.urlEncode(smsTemplate[0].Text__c, 'UTF-8');
                                      IntegrationWithKarix.sendSMSforSWAL(encodedcontent,accountList[0].UniquePhone__c,accountList[0].id);
                                  }
                                  else{
                                      IntegrationWithKarix.createSMSHistoryforSWAL(accountList[0].id, accountList[0].UniquePhone__c, 'Template did not found', null);
                                  }
                                  
                              }
                            else{
                                system.debug('OTHER');
                                String content = '';
                                String encodedcontent = '';
                                List<SMS_Template__c> smsTemplate = new List<SMS_Template__c>();
                                if(accountList[0].Preferred_Language__pc!=null){
                                    if(accountList[0].Preferred_Language__pc=='Marathi'||accountList[0].Preferred_Language__pc=='Bengali'||accountList[0].Preferred_Language__pc=='Kannada'||accountList[0].Preferred_Language__pc=='Gujarati'||accountList[0].Preferred_Language__pc=='Punjabi'||accountList[0].Preferred_Language__pc=='Tamil'||accountList[0].Preferred_Language__pc=='Telugu'||accountList[0].Preferred_Language__pc=='English'){
                                        smsTemplate = [Select id,Name__c,ObjectName__c,Text__c from SMS_Template__c where ObjectName__c = 'Account' AND Name__c like : '%'+accountList[0].Preferred_Language__pc+'%'];
                                    }
                                    else{
                                        smsTemplate = [Select id,Name__c,ObjectName__c,Text__c from SMS_Template__c where ObjectName__c = 'Account' AND Name__c like : '%Hindi%'];
                                    }
                                    
                                    System.debug('@@@@@'+smsTemplate );
                                }
                                if(!smsTemplate.isEmpty())
                                { 
                                    content = smsTemplate[0].Text__c;
                                    encodedcontent = EncodingUtil.urlEncode(smsTemplate[0].Text__c, 'UTF-8');
                                    IntegrationWithKarix.sendSMS(encodedcontent,accountList[0].UniquePhone__c,accountList[0].id,senderId);
                                }
                                else{
                                    IntegrationWithKarix.createSMSHistory(accountList[0].id, accountList[0].UniquePhone__c, 'Template did not found', null);
                                }
                            }
                    }   
                  }  
            }
        }
        
    }
}