/**************************************************************************************
Apex Class Name  : IntegrationWithKarixForCase
Version          : 1.0
Created Date     : 08 Apr 020
Function         : Class for sending case messages
Modification Log :
*   Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
*   Divya Singh                 08 Apr 020               
*************************************************************************************/
public class IntegrationWithKarixForCase {
    @InvocableMethod
    public static void getCaseContentsForSMS(List<Task> taskList){
        if(!taskList.isEmpty()){
            //Id caseId = [Select WhatId from Task where Id = :taskList[0].Id].WhatId;
            List<id> caseIds = new List<id>();
            //WIT-002 - Kuhinoor
            string nutureFrmRecordTypeId  =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('nurture.farm care').getRecordTypeId();
            string AKCCaseRecordTypeId  =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('AKC General Case').getRecordTypeId();

            String farmerLanguage = '';
            String senderId = 'Nurture';
            for(Task t :taskList){
                caseIds.add(t.whatId);
            }
            Map<String,Map<String,String>> fieldValueCaseMapList = new Map<String,Map<String,String>>();
            List<String> fields = new List<String>(Case.SObjectType.getDescribe().fields.getMap().keySet());
            List<Case> caseList = new List<Case>();
            if(!caseIds.isEmpty()){
                caseList = [Select ClosedDate,CaseNumber,Product_Recommended_1_gc__c,Product_2__c,Product_2_Measure__c,Product_2_Size__c,Product_1__c, Product_Recommended_2_gc__c, Product_Recommended_3_gc__c, Product_Recommended_4__c, Account.UniquePhone__c,Product_1_Measure__c,Measure_1_gc__c,Measure_2__c,Measure_3__c,Measure_4__c,Product_1_Size__c,Dose_1_gc__c,Dose_2__c,Dose_3__c,Dose_4__c,Account.Name,Description,Products_Recommended__c,recordTypeID,Account.State_Language__pc,Account.Preferred_Language__pc from Case where Id IN :caseIds];
                if(!caseList.isEmpty()){
                    for(Case c : caseList){
                        Map<String,String> fieldValueCaseMap = new Map<String,String>();
                        fieldValueCaseMap.put('P1',c.Product_1__c);
                        fieldValueCaseMap.put('P2',c.Product_2__c);
                        fieldValueCaseMap.put('P3',c.Product_Recommended_3_gc__c);
                        fieldValueCaseMap.put('P4',c.Product_Recommended_4__c);
                        fieldValueCaseMap.put('M1',c.Product_1_Measure__c);
                        fieldValueCaseMap.put('M2',c.Product_2_Measure__c);
                        fieldValueCaseMap.put('M3',c.Measure_3__c);
                        fieldValueCaseMap.put('M4',c.Measure_4__c);
                        fieldValueCaseMap.put('D1',c.Product_1_Size__c);
                        fieldValueCaseMap.put('D2',c.Product_2_Size__c);
                        fieldValueCaseMap.put('D3',c.Dose_3__c);
                        fieldValueCaseMap.put('D4',c.Dose_4__c);
                        fieldValueCaseMap.put('CaseNumber',c.CaseNumber);
                        string s = string.valueof(c.ClosedDate);
                        fieldValueCaseMap.put('ClosedDate',s);
                        fieldValueCaseMapList.put(c.id,fieldValueCaseMap);
                    }
                }
            }
            
            //Please keep task subject name and SMS template name Same.
            Map<string,String> smsTemplateBySubject = new Map<String,String>();
            for(SMS_Template__c smsTemplate : [Select id,Name__c,ObjectName__c,Text__c from SMS_Template__c where ObjectName__c = 'Case']){
                smsTemplateBySubject.put(smsTemplate.Name__c,smsTemplate.Text__c);
            }
            
            Map<string,String> smsTemplateBySubjectforSWAL = new Map<String,String>();
            for(SMS_Template__c smsTemplate : [Select id,Name__c,ObjectName__c,Text__c from SMS_Template__c where ObjectName__c = 'SWAL_Case']){
                smsTemplateBySubjectforSWAL.put(smsTemplate.Name__c,smsTemplate.Text__c);
            }
            
            Map<string,String> smsTemplateBySubjectforClosure = new Map<String,String>();
            List<String> smsTemplateLanguage = new List<String>();
            for(SMS_Template__c smsTemplate : [Select id,Name__c,ObjectName__c,Text__c,Language__c from SMS_Template__c where ObjectName__c in ('Case', 'SWAL_Case') and Name__c in ('Case Closure','Auto Product1 Recommendation','Auto Product2 Recommendation','Auto Product3 Recommendation','Auto Product4 Recommendation')]){
                smsTemplateBySubjectforClosure.put(smsTemplate.Name__c+smsTemplate.Language__c+smsTemplate.ObjectName__c,smsTemplate.Text__c);
                smsTemplateLanguage.add(smsTemplate.Language__c);
            }
            
            for(Task t :taskList){
                //Divya 03/06/2021: Added for SCTASK0477508
                if (t.Subject == 'Case Closure' || t.Subject == 'Auto Product1 Recommendation' || t.Subject == 'Auto Product2 Recommendation' || t.Subject == 'Auto Product3 Recommendation' || t.Subject == 'Auto Product4 Recommendation'){
                    String content = '';
                    String encodedcontent = '';
                    if(caseList[0].Account.Preferred_Language__pc != null && smsTemplateLanguage.contains(caseList[0].Account.Preferred_Language__pc))
                    {
                        farmerLanguage = caseList[0].Account.Preferred_Language__pc;
                    }
                    else if(caseList[0].Account.State_Language__pc != null && smsTemplateLanguage.contains(caseList[0].Account.State_Language__pc))
                    {
                        farmerLanguage = caseList[0].Account.State_Language__pc;
                    }
                    else{
                        farmerLanguage = 'Hindi';
                    }
                    if(caseList[0].RecordTypeId != null && caseList[0].RecordTypeId == Schema.SObjectType.Case.getRecordTypeInfosByName().get('SWAL General Case').getRecordTypeId()){
                        if(smsTemplateBySubjectforClosure.containsKey(t.Subject+farmerLanguage+'SWAL_Case') && fieldValueCaseMapList.containsKey(t.whatId))
                        {   
                            content = parseTemplate(smsTemplateBySubjectforClosure.get(t.Subject+farmerLanguage+'SWAL_Case'),fieldValueCaseMapList.get(t.whatId));
                            encodedcontent = EncodingUtil.urlEncode(content, 'UTF-8');
                            IntegrationWithKarix.sendSMS(encodedcontent,caseList[0].Account.UniquePhone__c,caseList[0].id,senderId);
                        }
                    }
                    //else if(caseList[0].RecordTypeId != null && (caseList[0].RecordTypeId == AKCCaseRecordTypeId || caseList[0].RecordTypeId == nutureFrmRecordTypeId ) ){ // Modify WIT-002
                    else if(caseList[0].RecordTypeId != null && 
                            (caseList[0].RecordTypeId == AKCCaseRecordTypeId || 
                             (caseList[0].RecordTypeId == nutureFrmRecordTypeId &&
                              (t.Subject != 'Auto Product1 Recommendation' 
                               && t.Subject != 'Auto Product2 Recommendation'
                               && t.Subject != 'Auto Product3 Recommendation' 
                               && t.Subject != 'Auto Product4 Recommendation')))){   //modified by Nanhdini-RITM0573330-to stop the Product recommendation SMS
                                   if(smsTemplateBySubjectforClosure.containsKey(t.Subject+farmerLanguage+'Case') && fieldValueCaseMapList.containsKey(t.whatId)){   
                                       content = parseTemplate(smsTemplateBySubjectforClosure.get(t.Subject+farmerLanguage+'Case'),fieldValueCaseMapList.get(t.whatId));
                                       encodedcontent = EncodingUtil.urlEncode(content, 'UTF-8');
                                       system.debug('@@content'+encodedcontent);
                                       IntegrationWithKarix.sendSMS(encodedcontent,caseList[0].Account.UniquePhone__c,caseList[0].id,senderId);
                                   }
                               }else{
                        IntegrationWithKarix.createSMSHistoryforSWAL(caseList[0].id, caseList[0].Account.UniquePhone__c, 'Template did not found', null);
                    }
                } //End
                else{
                    if(caseList[0].RecordTypeId != null && caseList[0].RecordTypeId == Schema.SObjectType.Case.getRecordTypeInfosByName().get('SWAL General Case').getRecordTypeId()){
                    system.debug('SWAL--**');
                    String content = '';
                    String encodedcontent = '';
                    if(smsTemplateBySubjectforSWAL.containsKey(t.Subject) && fieldValueCaseMapList.containsKey(t.whatId))
                    {   
                        content = parseTemplate(smsTemplateBySubjectforSWAL.get(t.Subject),fieldValueCaseMapList.get(t.whatId));
                        encodedcontent = EncodingUtil.urlEncode(content, 'UTF-8');
                        IntegrationWithKarix.sendSMSforSWAL(encodedcontent,caseList[0].Account.UniquePhone__c,caseList[0].id);
                    }
                    else{
                        IntegrationWithKarix.createSMSHistoryforSWAL(caseList[0].id, caseList[0].Account.UniquePhone__c, 'Template did not found', null);
                    }
                }
                else{
                    system.debug('OTHER--**');
                    String content = '';
                    String encodedcontent = '';
                    if(smsTemplateBySubject.containsKey(t.Subject) && fieldValueCaseMapList.containsKey(t.whatId))
                    {   
                        content = parseTemplate(smsTemplateBySubject.get(t.Subject),fieldValueCaseMapList.get(t.whatId));
                        encodedcontent = EncodingUtil.urlEncode(content, 'UTF-8');
                        IntegrationWithKarix.sendSMS(encodedcontent,caseList[0].Account.UniquePhone__c,caseList[0].id,senderId);
                    }
                    else{
                        IntegrationWithKarix.createSMSHistoryforSWAL(caseList[0].id, caseList[0].Account.UniquePhone__c, 'Template did not found', null);
                    }
                }
                }
                    }
          //  }
            
        }
    }
    public static String parseTemplate(String template,Map<String,String> fieldValueCaseMap){
        String result;
        system.debug('@@'+template);
        result = (template.indexOf('{!')!= -1)?template.substring(template.indexOf('{!'), template.indexOf('}')+1):null;
        system.debug('@@result'+result);
        while(result!=null){
            template = template.replace(result,(fieldValueCaseMap.get(result.substring(result.indexOf('!')+1, result.length()-1)) != null )?fieldValueCaseMap.get(result.substring(result.indexOf('!')+1, result.length()-1)):'');
            result = (template.indexOf('{!')!= -1)?template.substring(template.indexOf('{!'), template.indexOf('}')+1):null;
            system.debug('@@'+template);
            system.debug('@@'+result); 
        }
        return template;
    }
}