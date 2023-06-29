/**************************************************************************************
Apex Class Name  : IntegrationWithKarixForCall
Version          : 1.0
Created Date     : 09 May 20
Function         : Class for sending call recommendation to Farmer
Modification Log :
*   Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
*   Anuja                     09 May 20               
*************************************************************************************/
public class IntegrationWithKarixForCall {
    @InvocableMethod
    public static void getCallContent(List<Id> callId) {
        if(!callId.isEmpty()){
            String senderId = 'Nurture';
            String content = '';
            String encodedcontent = '';
            List<SMS_Template__c> smsTemplate = new List<SMS_Template__c>();
            
            Call__c callrecord = [SELECT ID, Empanelment__c, Empanelment__r.Farmer__c, Empanelment__r.Farmer__r.State_Language__pc,
                                  Empanelment__r.Farmer__r.UniquePhone__c FROM Call__c WHERE Id =: callId[0] ];
            
            if(callrecord.Empanelment__r.Farmer__r.State_Language__pc !=null){
                smsTemplate = [Select id,Name__c,ObjectName__c,Text__c from SMS_Template__c where ObjectName__c = 'Call' AND Name__c like : '%'+callrecord.Empanelment__r.Farmer__r.State_Language__pc+'%'];
                System.debug('@@@@@'+smsTemplate );
            }
            
            List<Recommendations__c> recOfCall = [SELECT Id,Call__c, Product__c , Dosage__c , DosageUnit__c FROM Recommendations__c WHERE Call__c =: callId[0]];
            
            String recom = ''; 
            for(Recommendations__c ree : recOfCall){
                recom += ree.Product__c+' '+ree.Dosage__c+' '+ree.DosageUnit__c+' '+',';
              } 
         	System.debug('recom '+recom);
            
            if(!smsTemplate.isEmpty())
            { 
                content = parseTemplate(smsTemplate[0].Text__c,recom);
                encodedcontent = EncodingUtil.urlEncode(content, 'UTF-8');
                IntegrationWithKarix.sendSMS(encodedcontent,callrecord.Empanelment__r.Farmer__r.UniquePhone__c,callrecord.Empanelment__r.Farmer__r.id,senderId);
            }
            else{
                IntegrationWithKarix.createSMSHistory(callrecord.Empanelment__r.Farmer__r.id, callrecord.Empanelment__r.Farmer__r.UniquePhone__c, 'Template did not found', null);
            }
        }
        
        
    }
    
    public static String parseTemplate(String template,String recomstring){
        String result;
        system.debug('@@'+template);
        result = (template.indexOf('{!')!= -1)?template.substring(template.indexOf('{!'), template.indexOf('}')+1):null;
        System.debug('result '+result);
        if(result!=null){
            template = template.replace(result,recomstring);
            //result = (template.indexOf('{!')!= -1)?template.substring(template.indexOf('{!'), template.indexOf('}')+1):null;
            system.debug('@@'+template);
            //system.debug('@@'+result); 
        }
        return template;
    }
    
}