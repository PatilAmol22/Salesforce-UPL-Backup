/**************************************************************************************
Apex Class Name  : IntegrationWithKarixForCase
Version          : 1.0
Created Date     : 08 Apr 020
Function         : Class for sending case messages
Modification Log :
*   Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
*   Deeksha Gupta           08 Apr 020               
*************************************************************************************/
public class IntegrationWithKarix {
    public class Response {
        public String ackid;
        public String resTime;
        public Status status;
        public String res;
    }
    public class Status{
        public String code;
        public String description;
    }
    
    
    public static void createSMSHistory(string objectId,String mob,String content,Response r){
        SMS_History__c smsHistory = new SMS_History__c();
        if(objectId.substring(0,3) == '001'){
            smsHistory.Account__c = objectId;
        }else
            if(objectId.substring(0,3) == '500'){
                smsHistory.Case__c = objectId;
            }
        //Code change by Grazitti(Aashima Puri) for including User for SMS History maintenance 
        if(objectId.substring(0,3) == '005'){
                smsHistory.User__c = objectId;
            }
        smsHistory.SMSText__c = EncodingUtil.urlDecode(content, 'UTF-8');
        smsHistory.SenderId__c = 'UPLLTD';
        smsHistory.Mobile_Number__c =mob;
        system.debug('@@'+r);
        if(r!=null){
            smsHistory.Response__c = r.res;
            system.debug('@@'+r);
            smsHistory.Response_Acknowledgement_ID__c = r.ackid;
            system.debug('@@'+r);
            smsHistory.Response_time__c = r.resTime;
            smsHistory.Status_Code__c = r.status.code;
            smsHistory.Status_Description__c = r.status.description;
        }
        insert smsHistory;
    }
    public static void createSMSHistoryforSWAL(string objectId,String mob,String content,Response r){
        SMS_History__c smsHistory = new SMS_History__c();
        if(objectId.substring(0,3) == '001'){
            smsHistory.Account__c = objectId;
        }else
            if(objectId.substring(0,3) == '500'){
                smsHistory.Case__c = objectId;
            }
        
        smsHistory.SMSText__c = EncodingUtil.urlDecode(content, 'UTF-8');
        smsHistory.SenderId__c = 'NURTURE';
        smsHistory.Mobile_Number__c =mob;
        system.debug('@@'+r);
        if(r!=null){
            smsHistory.Response__c = r.res;
            system.debug('@@'+r);
            smsHistory.Response_Acknowledgement_ID__c = r.ackid;
            system.debug('@@'+r);
            smsHistory.Response_time__c = r.resTime;
            smsHistory.Status_Code__c = r.status.code;
            smsHistory.Status_Description__c = r.status.description;
        }
        insert smsHistory;
    }
    @future(callout=true)
    public static void sendSMS(String encoded,String phoneNumber,String objectId, String senderId){
        System.debug('@@@');
        List<SMS_Endpoint__mdt> smsmetadata = new List<SMS_Endpoint__mdt> ();
        if(senderId == 'Nurture')
        {
            smsmetadata = [Select DeveloperName,MasterLabel, KeyPart__c,SenderIDPart__c from SMS_Endpoint__mdt WHERE MasterLabel = 'Nurture'];
        }
        else{
            smsmetadata = [Select DeveloperName,MasterLabel, KeyPart__c,SenderIDPart__c from SMS_Endpoint__mdt WHERE MasterLabel = 'UPL'];
        }
        Response r = new Response();
        Status s = new Status();
        r.status = s;
        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        request.setEndpoint(smsmetadata[0].KeyPart__c+phoneNumber+smsmetadata[0].SenderIDPart__c+encoded);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'text/JSON');
        Http http = new Http();
        response = http.send(request);
        system.debug('!!!'+response);
        List<string> splitted = response.getBody().split('&');
        if(splitted.size() > 0){
            r.ackid = splitted[0].right(splitted[0].length() - splitted[0].indexOf('=')-1);
            r.resTime = splitted[3].right(splitted[3].length() - splitted[3].indexOf('=')-1);
            s.code = splitted[1].right(splitted[1].length() - splitted[1].indexOf('=')-1);
            s.description= splitted[2].right(splitted[2].length() - splitted[2].indexOf('=')-1);
        }
        r.res = response.getBody();
        if(senderId == 'Nurture'){
          createSMSHistoryforSWAL(objectId,phoneNumber,encoded,r);  
        }
        else
        createSMSHistory(objectId,phoneNumber,encoded,r); 
    }
    
     @future(callout=true)
    public static void sendSMSforSWAL(String encoded,String phoneNumber,String objectId){
        System.debug('@@@');
        List<SMS_Endpoint__mdt> smsmetadata = [Select DeveloperName,MasterLabel, KeyPart__c,SenderIDPart__c from SMS_Endpoint__mdt WHERE MasterLabel = 'SWAL'];
        Response r = new Response();
        Status s = new Status();
        r.status = s;
        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        request.setEndpoint(smsmetadata[0].KeyPart__c+phoneNumber+smsmetadata[0].SenderIDPart__c+encoded);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'text/JSON');
        Http http = new Http();
        response = http.send(request);
        system.debug('!!!'+response);
        List<string> splitted = response.getBody().split('&');
        if(splitted.size() > 0){
            r.ackid = splitted[0].right(splitted[0].length() - splitted[0].indexOf('=')-1);
            r.resTime = splitted[3].right(splitted[3].length() - splitted[3].indexOf('=')-1);
            s.code = splitted[1].right(splitted[1].length() - splitted[1].indexOf('=')-1);
            s.description= splitted[2].right(splitted[2].length() - splitted[2].indexOf('=')-1);
        }
        r.res = response.getBody();
        createSMSHistoryforSWAL(objectId,phoneNumber,encoded,r); 
    }
}