/*
* Name: MonitorLogGenerationController
* Created On: 9 May 2019 
* Author: Azhar Shaikh
* Description: Class is used for inserting error and monitor messages in monitor log.
*/

public without sharing class MonitorLogGenerationController {
    Id KYCRecordTypeId;
    static Id KYCRecordTypeIdss;
    
    public MonitorLogGenerationController(){
        KYCRecordTypeId=Schema.SObjectType.Monitor_Log__c.getRecordTypeInfosByName().get('KYC').getRecordTypeId(); 
        KYCRecordTypeIdss = Schema.SObjectType.Monitor_Log__c.getRecordTypeInfosByName().get('KYC').getRecordTypeId(); 
    }
    public void setMonitorLog(String kyc_mode, DateTime da_time, String reqs, String resp, String message, String name, String statuscode,String KycId){
        System.debug('statuscode : '+statuscode);
        Integer sCode=0;
        if(statuscode!=''){
            System.debug('sCode : '+sCode);
             sCode=Integer.valueOf(statuscode);
        }
        
        
        System.debug('kyc_mode : '+kyc_mode);
        System.debug('da_time'+da_time+' - name : '+name);
        System.debug('reqs : '+reqs);
        System.debug('resp : '+resp);
        System.debug('message : '+message);
        System.debug('KycId : '+KycId);
        
        
        Map<String, String> mapStatusCode= new Map<String, String>();
    mapStatusCode.put('101', 'Valid Authentication');
        mapStatusCode.put('102', 'Invalid ID number or combination of inputs');
        mapStatusCode.put('103', 'No records found for the given ID or combination of inputs');
        mapStatusCode.put('104', 'Max retries exceeded');
        mapStatusCode.put('105', 'Missing Consent');
        mapStatusCode.put('106', 'Multiple Records Exist');
        mapStatusCode.put('107', 'Not Supported');
        
        mapStatusCode.put('200', 'OK');
        mapStatusCode.put('400', 'Bad Request');
        mapStatusCode.put('401', 'Unauthorized Access');
        mapStatusCode.put('402', 'Insufficient Credits');
        mapStatusCode.put('500', 'Internal Server Error');
        mapStatusCode.put('503', 'Source Unavailable');
        mapStatusCode.put('504', 'Endpoint Request Timed Out');
        
        
        List<Monitor_Log__c> monitorLogListNew = new List<Monitor_log__c>();
        
            Monitor_log__c monitorLogObj= new Monitor_log__c();
            monitorLogObj.Request_Type__c=kyc_mode;
          monitorLogObj.Name= da_time+' - '+name;
            monitorLogObj.Request__c=reqs;
            monitorLogObj.Response__c=resp;
            if(statuscode != ''){
                monitorLogObj.Message__c=mapStatusCode.get(statuscode);
            }else {
                monitorLogObj.Message__c=message;
            }
            monitorLogObj.Status_Code__c=sCode;
          monitorLogObj.KYC__c=KycId;
        monitorLogObj.RecordtypeId=KYCRecordTypeId;
        monitorLogListNew.add(monitorLogObj);
        
        //System.debug('monitorLogList :- '+monitorLogListNew);
        insert monitorLogObj;
        //System.debug('@@@@ monitorLogObj id is '+monitorLogObj.id);
    }
    
    public static void setMonitorLogss(String kyc_mode, DateTime da_time, String reqs, String resp, String message, String name, String statuscode,String KycId){
        System.debug('statuscode : '+statuscode);
        Integer sCode=0;
        if(statuscode!=''){
            System.debug('sCode : '+sCode);
             sCode=Integer.valueOf(statuscode);
        }
        
        
        System.debug('kyc_mode : '+kyc_mode);
        System.debug('da_time'+da_time+' - name : '+name);
        System.debug('reqs : '+reqs);
        System.debug('resp : '+resp);
        System.debug('message : '+message);
        System.debug('KycId : '+KycId);
        
        
        Map<String, String> mapStatusCode= new Map<String, String>();
    mapStatusCode.put('101', 'Valid Authentication');
        mapStatusCode.put('102', 'Invalid ID number or combination of inputs');
        mapStatusCode.put('103', 'No records found for the given ID or combination of inputs');
        mapStatusCode.put('104', 'Max retries exceeded');
        mapStatusCode.put('105', 'Missing Consent');
        mapStatusCode.put('106', 'Multiple Records Exist');
        mapStatusCode.put('107', 'Not Supported');
        
        mapStatusCode.put('200', 'OK');
        mapStatusCode.put('400', 'Bad Request');
        mapStatusCode.put('401', 'Unauthorized Access');
        mapStatusCode.put('402', 'Insufficient Credits');
        mapStatusCode.put('500', 'Internal Server Error');
        mapStatusCode.put('503', 'Source Unavailable');
        mapStatusCode.put('504', 'Endpoint Request Timed Out');
        
        
        List<Monitor_Log__c> monitorLogListNew = new List<Monitor_log__c>();
        
            Monitor_log__c monitorLogObj= new Monitor_log__c();
            monitorLogObj.Request_Type__c=kyc_mode;
          monitorLogObj.Name= da_time+' - '+name;
            monitorLogObj.Request__c=reqs;
            monitorLogObj.Response__c=resp;
            if(statuscode != ''){
                monitorLogObj.Message__c=mapStatusCode.get(statuscode);
            }else {
                monitorLogObj.Message__c=message;
            }
            monitorLogObj.Status_Code__c=sCode;
          monitorLogObj.KYC__c=KycId;
        
        KYCRecordTypeIdss = Schema.SObjectType.Monitor_Log__c.getRecordTypeInfosByName().get('KYC').getRecordTypeId(); 
        System.debug('KYCRecordTypeIdss : '+KYCRecordTypeIdss);
        
        monitorLogObj.RecordtypeId=KYCRecordTypeIdss;
        monitorLogListNew.add(monitorLogObj);
        
        //System.debug('monitorLogList :- '+monitorLogListNew);
        insert monitorLogObj;
        //System.debug('@@@@ monitorLogObj id is '+monitorLogObj.id);
    }
    
}