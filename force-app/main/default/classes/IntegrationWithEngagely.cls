public class IntegrationWithEngagely {
/**************************************************************************************
Apex Class Name  : IntegrationWithEngagely
Version          : 1.0
Created Date     : 28 May 020
Function         : Class for sending case whatsapp messages
Modification Log :
*   Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
*   Divya Singh                 28 May 020               
*************************************************************************************/
 @InvocableMethod
    public static void getCaseContentsForSMS(List<Task> taskList){
        if(!taskList.isEmpty()){
            //Id caseId = [Select WhatId from Task where Id = :taskList[0].Id].WhatId;
            List<id> caseIds = new List<id>();
            for(Task t :taskList){
                caseIds.add(t.whatId);
            }
            List<Case> caseData = new List<Case>();
            if(!caseIds.isEmpty()){
                caseData = [Select Account.Name, Account.PersonMobilePhone, CaseNumber, Account.State_Language__pc from Case where Id = :caseIds[0] and Account.SMS_Voice_Msg_Call_Consent__pc = 'Yes'];
                if(!caseData.isEmpty()){
                    sendWhatsapp(caseData[0].id,caseData[0].Account.Name,caseData[0].Account.PersonMobilePhone,caseData[0].CaseNumber,caseData[0].Account.State_Language__pc,null,null,null,null,null);
                }
            }
        }/*
        if(!caseList.isEmpty()){
            List<Case> caseData = new List<Case>();
            caseData = [Select Account.Name, Account.UniquePhone__c, CaseNumber, Account.State_Language__pc from Case where Id = :caseList[0].Id];
            if(!caseData.isEmpty()){
                sendWhatsapp(caseData[0].Account.Name,caseData[0].Account.UniquePhone__c,caseData[0].CaseNumber,caseData[0].Account.State_Language__pc,null);
            }
        }*/
    }
    @future(callout=true)
    public static void sendWhatsapp(String id,String name,String phone,String casenum,String language,String r1,String r2,String r3,String r4,Integer days){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        List <Engagely_Settings__c> EngSet = Engagely_Settings__c.getall().values();
        String Username = EngSet[0].User_Name__c;
        String Password = EngSet[0].Password__c;
        String URL = EngSet[0].Feedback_URL__c;
        JSONGenerator gen = JSON.createGenerator(true);    
        gen.writeStartObject(); 
        if(name!=null)
        gen.writeStringField('name', name);
        if(phone!=null)
        gen.writeStringField('mobile_number',phone);
        if(casenum!=null)
        gen.writeStringField('case_no',casenum);
        if(language!=null)
        gen.writeStringField('language',language);
        
        if(r1!= null || r2 != null || r3!= null || r4!= null){
            List<String> r =  new List<String>();
            if(r1!=null)
            r.add(r1);
            if(r2!=null)
            r.add(r2);
            if(r3!=null)
            r.add(r3);
            if(r4!=null)
            r.add(r4);
            gen.writeObjectField('products',r);
            gen.writeNumberField('message_after_days',days);
            URL = EngSet[0].Product_URL__c;
        }
        gen.writeEndObject();  
        //system.debug('@@'+r) ;
        String jsonS = gen.getAsString();
        System.debug('jsonMaterials'+jsonS);
        request.setEndpoint(URL);
        request.setbody(jsonS);
        String headerValue =EncodingUtil.base64Encode(Blob.valueOf(Username + ':' + Password));
        String authorizationHeader = 'Basic '+headerValue;
        request.setHeader('Authorization', authorizationHeader);
        HttpResponse response;
        if(!Test.isRunningTest()){
                response = http.send(request);
        }
        if(response!= null)
        {
            createSMSHistory(id,phone,response);
        }
    }
    public static void getRecommendedForwhatsapp(List<Task> taskList, Integer days){
        if(!taskList.isEmpty()){
            //Id caseId = [Select WhatId from Task where Id = :taskList[0].Id].WhatId;
            List<id> caseIds = new List<id>();
            for(Task t :taskList){
                caseIds.add(t.whatId);
            }
            Map<String,Map<String,String>> fieldValueCaseMapList = new Map<String,Map<String,String>>();
            List<String> fields = new List<String>(Case.SObjectType.getDescribe().fields.getMap().keySet());
            List<Case> caseList = new List<Case>();
            if(!caseIds.isEmpty()){
                caseList = [Select Product_Recommended_1_gc__c, Product_Recommended_2_gc__c, Product_Recommended_3_gc__c, Product_Recommended_4__c, Account.PersonMobilePhone,Account.Name,CaseNumber, Account.State_Language__pc from Case where Id IN :caseIds and Account.SMS_Voice_Msg_Call_Consent__pc = 'Yes'];
                if(!caseList.isEmpty()){
                    sendWhatsapp(caseList[0].id,caseList[0].Account.Name,caseList[0].Account.PersonMobilePhone,caseList[0].CaseNumber,caseList[0].Account.State_Language__pc,caseList[0].Product_Recommended_1_gc__c,caseList[0].Product_Recommended_2_gc__c,caseList[0].Product_Recommended_3_gc__c,caseList[0].Product_Recommended_4__c,days);
                }
            }
        }
    }
    public static void createSMSHistory(string objectId,String mob,httpResponse r){
        SMS_History__c smsHistory = new SMS_History__c();
        if(objectId.substring(0,3) == '001'){
            smsHistory.Account__c = objectId;}
        smsHistory.Mobile_Number__c =mob;
        if(r!=null){
            smsHistory.Status_Code__c = r.getStatus();
            smsHistory.Status_Description__c = r.getbody();
        }
        insert smsHistory;
    }
}