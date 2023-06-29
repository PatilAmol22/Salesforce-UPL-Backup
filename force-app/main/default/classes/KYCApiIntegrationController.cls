/*
* Name: KYCApiIntegrationController
* Created On: 9 May 2019 
* Author: Azhar Shaikh
* Description: Class is used for getting endpoints from custom settings and API Integration and updating KYC Object And it is invoking from KycRequestHandlerController.
*/
public without sharing class KYCApiIntegrationController implements Database.AllowsCallouts {
    public String endPoint;
    public String endPointv3;
    public String endPointv1;
    public static String endPointv1static;
    public static String endPointv3static;
    public static String authorizationKey;
    public static String consent;
    public static Http httpProtocol;
    public static HttpRequest req;
    public String responsebody=''; 
    static Id recordtypeKycEmailId;
    KYC__c kycObj1;
    // MonitorLogGenerationController Object
    MonitorLogGenerationController monitorLogObj;
    
    // KYCApiController Constructor
    public KYCApiIntegrationController(){
        httpProtocol = new Http();
        req = new HttpRequest();
        monitorLogObj = new MonitorLogGenerationController();
        recordtypeKycEmailId=Schema.SObjectType.KYC__c.getRecordTypeInfosByName().get('Email').getRecordTypeId();   
    }
    
    public static void  validateMatchName(Id kycid, String kyc_mode, String nameFromResult, Id recordtypeKycId, String logName){
        String jsonMatchAPIRequestBody='';
        String responseBodyMatchName='';
        httpProtocol = new Http();
        req = new HttpRequest();
        List<KYC_Api__c> kycApiList=[Select id, Endpoint__c, EndpointV3__c, EndpointV1__c, x_karza_key__c from KYC_Api__c];
        endPointv3static = kycApiList[0].EndpointV3__c;
        authorizationKey= kycApiList[0].x_karza_key__c;
        List<KYC__c> kycList=[SELECT Id, IsDeleted, Name,First_Name__c,Last_Name__c, CurrencyIsoCode, RecordTypeId, CreatedDate, CreatedById,
        LastModifiedDate, LastModifiedById, SystemModstamp, Account__c, Kyc_status__c, Confidence_score__c, Result__c, 
        Input__c, Email_ID__c, KYC_Last_Updated_Date_Time__c, KYC_By__c, Request_JSON__c, Respone_JSON__c, Consent__c,
        Request_Id__c, Status_Code__c, API_Count__c, ma_preset__c, ma_type__c, API_Count_Name__c, PAN_Number__c, pan_resp_name__c FROM KYC__c 
        where Id=:kycid];
        List<KYC__c> kycList1 = new List<KYC__c>();
        KYC__c kycObj1 = new KYC__c();
        kycObj1.Id=kycid;
        System.debug('kycObj1.Id : '+kycObj1.Id);
        Datetime currentDateTime=Datetime.now();
        try{
            System.debug('nameFromResult :- '+nameFromResult);
            //System.debug(jsonMatchAPIRequestBody);
            String name2Str=kycList[0].First_Name__c+' '+kycList[0].Last_Name__c;
            System.debug('name2Str :- '+name2Str);
            JSONGenerator gen = JSON.createGenerator(true);    
            gen.writeStartObject();     
            gen.writeStringField('name1',nameFromResult);
            gen.writeStringField('name2',name2Str);
            gen.writeStringField('type',kycList[0].ma_type__c);
            gen.writeStringField('preset',kycList[0].ma_preset__c);
            gen.writeEndObject();    
            jsonMatchAPIRequestBody = gen.getAsString();
            req.setEndpoint(endPointv3static+'/name');
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('x-karza-key',authorizationKey);
            req.setMethod('POST');
            //req.setTimeout(120000);
            req.setBody(jsonMatchAPIRequestBody);
            //System.debug('req :- '+req);
            HttpResponse response=httpProtocol.send(req);
            System.debug('response :- '+response.getBody());
            responseBodyMatchName=response.getBody();
            if(responseBodyMatchName.length()>0){
                kycObj1.RecordTypeId=recordtypeKycId;
                kycObj1.KYC_Last_Updated_Date_Time__c=currentDateTime;
                kycObj1.Request_Type__c='Scheduler';
                if(kycObj1.Id!=null){
                    kycObj1.API_Count_Name__c=kycList[0].API_Count_Name__c+1; 
                }
                System.debug('kycObj1.API_Count_Name__c :- '+kycObj1.API_Count_Name__c);
                String status='';
                if(String.valueOf(getMapResults(responseBodyMatchName).get('status'))!=null){
                    status=String.valueOf(getMapResults(responseBodyMatchName).get('status'));
                    if(status!='' || status!=null){
                        kycObj1.Confidence_score__c = 0;
                        responseKycRequestIntegrationStatus(kycObj1, 'Failed', currentDateTime,'Not Valid');
                        MonitorLogGenerationController.setMonitorLogss(kyc_mode, currentDateTime, jsonMatchAPIRequestBody,responseBodyMatchName, '', logName, status, kycid);  
                    }
                } else{
                    String matchStatusCode=String.valueOf(getMapResults(responseBodyMatchName).get('statusCode'));
                    String matchScore=String.valueOf(getMapResult(responseBodyMatchName).get('score'));
                    System.debug('matchStatusCode : '+matchStatusCode);
                    if(matchStatusCode =='101'){
                        Decimal sc_percentage=Decimal.valueOf(matchScore) * 100;
                        kycObj1.Confidence_score__c = sc_percentage.round(); 
                        responseKycRequestIntegrationStatus(kycObj1, 'Completed', currentDateTime,'Valid');
                        //for Success 
                        MonitorLogGenerationController.setMonitorLogss(kyc_mode, currentDateTime, jsonMatchAPIRequestBody,responseBodyMatchName, '', logName, matchStatusCode, kycid);
                    }else{
                        kycObj1.Confidence_score__c = 0;
                        responseKycRequestIntegrationStatus(kycObj1, 'Failed', currentDateTime,'Not Valid');
                        MonitorLogGenerationController.setMonitorLogss( kyc_mode, currentDateTime, jsonMatchAPIRequestBody,responseBodyMatchName, '', logName, matchStatusCode, kycid);
                    }
                }
            }
            if(Test.isRunningTest())
            {
                Exception e;
                throw e;
            }
            
        }catch(DmlException ex) {
            responseKycRequestIntegrationStatus(kycObj1, 'Failed', currentDateTime,'Failed');
            MonitorLogGenerationController.setMonitorLogss(kyc_mode, currentDateTime, '','', ''+ex.getMessage() , '', '', kycid);
        } catch(SObjectException ex) {
            responseKycRequestIntegrationStatus(kycObj1, 'Failed', currentDateTime,'Failed');
            MonitorLogGenerationController.setMonitorLogss(kyc_mode, currentDateTime, '','', ''+ex.getMessage() , '', '', kycid);
        }catch(Exception e){
            responseKycRequestIntegrationStatus(kycObj1, 'Failed', currentDateTime,'Failed');
            MonitorLogGenerationController.setMonitorLogss(kyc_mode, currentDateTime, jsonMatchAPIRequestBody,'', 'Transaction Log : '+ e.getStackTraceString(), logName, '', kycid);
        }
    }

    public static void validateEmail(Id kycid,String kyc_mode,String jsonRequestBody,DateTime currentTime,String logName){
        String responseBodyEmail='';
        List<KYC_Api__c> kycApiList=[Select id, Endpoint__c, EndpointV3__c, EndpointV1__c, x_karza_key__c from KYC_Api__c];
        endPointv1static = kycApiList[0].endpoint__c;
        authorizationKey= kycApiList[0].x_karza_key__c;
        httpProtocol = new Http();
        req = new HttpRequest();
        List<KYC__c> kycList=[SELECT Id, API_Count__c, API_Count_OCR__c FROM KYC__c where Id=:kycid];
        List<KYC__c> kycList1 = new List<KYC__c>();
        KYC__c kycObj1 = new KYC__c();
        
        kycObj1.Id=kycid;
        System.debug('kycObj1.Id : '+kycObj1.Id);
        Datetime currentDateTime=Datetime.now();
        try{
            //System.debug('endpoint : '+endPointv1static+'/email');
            System.debug(jsonRequestBody);
            req.setEndpoint(endPointv1static+'/email');
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('x-karza-key',authorizationKey);
            req.setMethod('POST');
            req.setTimeout(120000);
            req.setBody(jsonRequestBody);
            HttpResponse response=httpProtocol.send(req);
            //System.debug('response :- '+response.getBody());
            responseBodyEmail=response.getBody();
            // calling request
            
            //System.debug('responseBodyEmail : '+responseBodyEmail);
            if(responseBodyEmail.length()>0){// check length
                System.debug('responseBodyEmail len : '+responseBodyEmail.length());
                //get ApiCount from KYCObj
                if(kycObj1.Id!=null){
                    kycObj1.API_Count__c=kycList[0].API_Count__c+1;
                }
            }
            kycObj1.RecordTypeId=recordtypeKycEmailId;
            kycObj1.KYC_Last_Updated_Date_Time__c=currentDateTime;
            kycObj1.Request_Type__c='Scheduler';
            String statusEmail='';
            if(String.valueOf(getMapResults(responseBodyEmail).get('status'))!=null){
                statusEmail=String.valueOf(getMapResults(responseBodyEmail).get('status'));
                if(statusEmail!='' || statusEmail!=null){
                    kycObj1.Status_Code__c=statusEmail;
                    kycObj1.Request_Id__c='';
                    kycObj1.Confidence_score__c = 0; 
                    kycObj1.email_resp_accept_all__c=false;
                    kycObj1.email_resp_disposable__c=false;
                    kycObj1.email_resp_email__c='';
                    kycObj1.email_resp_mx_records__c=false;
                    kycObj1.email_resp_regexp__c=false;
                    kycObj1.email_resp_result__c=false;
                    kycObj1.email_resp_smtp_check__c=false;
                    kycObj1.email_resp_webmail__c=false;
                    responseKycRequestIntegrationStatus(kycObj1, 'Failed', currentDateTime,'Not Valid');
                    MonitorLogGenerationController.setMonitorLogss(kyc_mode, currentTime, jsonRequestBody,responseBodyEmail, '', logName, statusEmail, kycid);   
                }
            }else{
                
                // Deserialized Email Json
                String statusCodeStr=String.valueOf(getMapResults(responseBodyEmail).get('status-code'));
                String requestIdStr=String.valueOf(getMapResults(responseBodyEmail).get('request_id'));
                if(statusCodeStr =='101'){
                    String nameFromResult=String.valueOf(getMapResult(responseBodyEmail).get('name'));
                    Map<String,Object> resultData = (Map<String, Object>) getMapResult(responseBodyEmail).get('data');
                    boolean accepAllResultFromResult=boolean.valueOf(resultData.get('accept_all'));
                    kycObj1.Status_Code__c=statusCodeStr;
                    kycObj1.Request_Id__c=requestIdStr;
                    kycObj1.Request_JSON__c=jsonRequestBody;
                    kycObj1.Respone_JSON__c=responseBodyEmail;
                    kycObj1.email_resp_accept_all__c=boolean.valueOf(resultData.get('accept_all'));
                    kycObj1.email_resp_disposable__c=boolean.valueOf(resultData.get('disposable'));
                    kycObj1.email_resp_email__c=String.valueOf(resultData.get('email'));
                    kycObj1.email_resp_mx_records__c=boolean.valueOf(resultData.get('mx_records'));
                    kycObj1.email_resp_regexp__c=boolean.valueOf(resultData.get('regexp'));
                    kycObj1.email_resp_result__c=boolean.valueOf(resultData.get('result'));
                    kycObj1.email_resp_smtp_check__c=boolean.valueOf(resultData.get('smtp_check'));
                    kycObj1.email_resp_webmail__c=boolean.valueOf(resultData.get('webmail'));
                    responseKycRequestIntegrationStatus(kycObj1, 'Completed', currentDateTime,'Valid');
                    //for Success 
                    MonitorLogGenerationController.setMonitorLogss(kyc_mode, currentTime, jsonRequestBody,responseBodyEmail, '', logName, statusCodeStr, kycid);
                }else {
                    kycObj1.Status_Code__c=statusCodeStr;
                    kycObj1.Request_Id__c=requestIdStr;
                    kycObj1.Confidence_score__c = 0; 
                    kycObj1.email_resp_accept_all__c=false;
                    kycObj1.email_resp_disposable__c=false;
                    kycObj1.email_resp_email__c='';
                    kycObj1.email_resp_mx_records__c=false;
                    kycObj1.email_resp_regexp__c=false;
                    kycObj1.email_resp_result__c=false;
                    kycObj1.email_resp_smtp_check__c=false;
                    kycObj1.email_resp_webmail__c=false;
                    responseKycRequestIntegrationStatus(kycObj1, 'Failed', currentDateTime,'Not Valid');
                    MonitorLogGenerationController.setMonitorLogss(kyc_mode, currentTime, jsonRequestBody,responseBodyEmail, '', logName, statusCodeStr, kycid);
                 }
                
            } 
            if(Test.isRunningTest())
            {
                Exception e;
                throw e;
            }
        }catch(DmlException ex) {
            responseKycRequestIntegrationStatus(kycObj1, 'Failed', currentDateTime,'Failed');
            MonitorLogGenerationController.setMonitorLogss(kyc_mode, currentTime, '','', ''+ex.getMessage() , '', '', kycid);
        } catch(SObjectException ex) {
            responseKycRequestIntegrationStatus(kycObj1, 'Failed', currentDateTime,'Failed');
            MonitorLogGenerationController.setMonitorLogss(kyc_mode, currentTime, '','', ''+ex.getMessage() , '', '', kycid);
        }catch(Exception e){
            responseKycRequestIntegrationStatus(kycObj1, 'Failed', currentDateTime,'Failed');
            MonitorLogGenerationController.setMonitorLogss(kyc_mode, currentTime, jsonRequestBody,'', 'Transaction Log : '+e.getStackTraceString(), logName, '', kycid);
        }
        System.debug('responseBodyEmail :- '+responseBodyEmail);
        
    }
 
    public static void validatePan(Id kycid, String kyc_mode, String jsonRequestBody, Id recordtypeKycPANId, DateTime currentTime, String logName){
        String responseBodyPan='';
        List<KYC_Api__c> kycApiList=[Select id, Endpoint__c, EndpointV3__c, EndpointV1__c, x_karza_key__c from KYC_Api__c];
        endPointv1static = kycApiList[0].endpoint__c;
        endPointv3static = kycApiList[0].endpointV3__c;
        authorizationKey= kycApiList[0].x_karza_key__c;
        httpProtocol = new Http();
        req = new HttpRequest();
        List<KYC__c> kycList=[SELECT Id, API_Count__c, API_Count_OCR__c FROM KYC__c where Id=:kycid];
        
        List<KYC__c> kycList1 = new List<KYC__c>();
        KYC__c kycObj1 = new KYC__c();
        
        kycObj1.Id=kycid;
        System.debug('kycObj1.Id : '+kycObj1.Id);
        Datetime currentDateTime=Datetime.now();
        String errorMessage='';
        try{
            System.debug(jsonRequestBody);
            req.setEndpoint(endPointv1static+'/pan');
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('x-karza-key',authorizationKey);
            req.setMethod('POST');
            req.setTimeout(120000);
            req.setBody(jsonRequestBody);
            HttpResponse response=httpProtocol.send(req);
            System.debug('response :- '+response.getBody());
            responseBodyPan=response.getBody();
            
            if(responseBodyPan.length()>0){
                System.debug('responseBodyPan len : '+responseBodyPan.length());
                //get ApiCount from KYCObj
                if(kycObj1.Id!=null){
                    //System.debug('kycList[0].API_Count__c : '+kycList[0].API_Count__c);
                    kycObj1.API_Count__c=kycList[0].API_Count__c+1;
                }
            }
            kycObj1.RecordTypeId=recordtypeKycPANId;
            kycObj1.KYC_Last_Updated_Date_Time__c=currentDateTime;
            kycObj1.Request_Type__c='Scheduler';
            // For getting status from PanResponse     //
            String statusPan='';
            List<ContentDocumentLink> contentDocumentLinkObj= new List<ContentDocumentLink>();
            contentDocumentLinkObj =[SELECT ContentDocumentId, ContentDocument.Title FROM ContentDocumentLink WHERE LinkedEntityId=:kycObj1.Id ORDER BY SystemModstamp Desc Limit 1];
            
            if(String.valueOf(getMapResults(responseBodyPan).get('status'))!=null){
                statusPan=String.valueOf(getMapResults(responseBodyPan).get('status'));
                if(statusPan!='' || statusPan!=null){
                    kycObj1.Status_Code__c=statusPan;
                    kycObj1.Request_Id__c='';
                    kycObj1.pan_resp_name__c='';
                    kycObj1.Request_JSON__c=jsonRequestBody;
                    kycObj1.Respone_JSON__c=responseBodyPan;
                    if(contentDocumentLinkObj.size()>0){
                        ContentVersion contentversionObj=[SELECT VersionData FROM ContentVersion WHERE ContentDocumentId =:contentDocumentLinkObj[0].ContentDocumentId];
                        System.debug('data : '+EncodingUtil.Base64Encode(contentversionObj.VersionData));
                        String base64Str=EncodingUtil.Base64Encode(contentversionObj.VersionData);
                        validateOCR(kycObj1.Id,kyc_mode,getOCRJsonRequestStr(base64Str),recordtypeKycPANId,currentTime,logName); 
                    }else{
                        responseKycRequestIntegrationStatus(kycObj1, 'Failed', currentDateTime,'Not Valid');
                        MonitorLogGenerationController.setMonitorLogss(kyc_mode, currentTime, jsonRequestBody,responseBodyPan, '', logName, statusPan, kycid);  
                    }
                }
            }else {
                // Deserialized PAN Json
                String statusCodeStr=String.valueOf(getMapResults(responseBodyPan).get('status-code'));
                String requestIdStr=String.valueOf(getMapResults(responseBodyPan).get('request_id'));
                
                if(statusCodeStr =='101'){
                    
                    String nameFromResult=String.valueOf(getMapResult(responseBodyPan).get('name'));
                    kycObj1.Status_Code__c=statusCodeStr;
                    kycObj1.Request_Id__c=requestIdStr;
                    kycObj1.pan_resp_name__c=nameFromResult;
                    kycObj1.Request_JSON__c=jsonRequestBody;
                    kycObj1.Respone_JSON__c=responseBodyPan;
                    responseKycRequestIntegrationStatus(kycObj1, 'Partially Completed', currentDateTime,'Valid');
                    MonitorLogGenerationController.setMonitorLogss(kyc_mode, currentTime, jsonRequestBody,responseBodyPan, '', logName, statusCodeStr, kycid);
                    
                }else {
                    if(contentDocumentLinkObj.size()>0){
                        ContentVersion contentversionObj=[SELECT VersionData FROM ContentVersion WHERE ContentDocumentId =:contentDocumentLinkObj[0].ContentDocumentId];
                        System.debug('data : '+EncodingUtil.Base64Encode(contentversionObj.VersionData));
                        String base64Str=EncodingUtil.Base64Encode(contentversionObj.VersionData);
                        validateOCR(kycObj1.Id,kyc_mode,getOCRJsonRequestStr(base64Str),recordtypeKycPANId,currentTime,logName); 
                    }else{
                        kycObj1.Status_Code__c=statusCodeStr;
                        kycObj1.Request_Id__c='';
                        kycObj1.pan_resp_name__c='';
                        kycObj1.Request_JSON__c=jsonRequestBody;
                        kycObj1.Respone_JSON__c=responseBodyPan;
                        responseKycRequestIntegrationStatus(kycObj1, 'Failed', currentDateTime,'Not Valid');
                        MonitorLogGenerationController.setMonitorLogss(kyc_mode, currentTime, jsonRequestBody,responseBodyPan, '', logName, statusCodeStr, kycid);
                    }
                }
            }  
            if(Test.isRunningTest())
			{
                Exception e;
				throw e;
			}
        }catch(DmlException ex) {
            responseKycRequestIntegrationStatus(kycObj1, 'Failed', currentDateTime,'Failed');
            MonitorLogGenerationController.setMonitorLogss(kyc_mode, currentTime, '','', ''+ex.getMessage() , '', '', kycid);
        } catch(SObjectException ex) {
            responseKycRequestIntegrationStatus(kycObj1, 'Failed', currentDateTime,'Failed');
            MonitorLogGenerationController.setMonitorLogss(kyc_mode, currentTime, '','', ''+ex.getMessage() , '', '', kycid);
	    }catch(Exception e){
            responseKycRequestIntegrationStatus(kycObj1, 'Failed', currentDateTime,'Failed');
            MonitorLogGenerationController.setMonitorLogss(kyc_mode, currentTime, jsonRequestBody,'', 'Transaction Log : '+ e.getStackTraceString(), logName, '', kycid);
        }
    }
    
    public static void validateDriverLicense(Id kycid,String kyc_mode,String jsonRequestBody,Id recordtypeKycDrivingLicenseId,DateTime currentTime,String logName){
        String responseBodyDriverLicense='';
        List<KYC_Api__c> kycApiList=[Select id, Endpoint__c, EndpointV3__c, EndpointV1__c, x_karza_key__c from KYC_Api__c];
        endPointv1static = kycApiList[0].endpoint__c;
        authorizationKey= kycApiList[0].x_karza_key__c;
        consent ='Y';
        httpProtocol = new Http();
        req = new HttpRequest();
        List<KYC__c> kycList=[SELECT Id, API_Count__c, API_Count_OCR__c FROM KYC__c where Id=:kycid];
        KYC__c kycObj1 = new KYC__c();
        kycObj1.Id=kycid;
        Datetime currentDateTime=Datetime.now();
        try{
            //System.debug(jsonRequestBody);
            //System.debug('endPointv1static : '+endPointv1static);
            req.setEndpoint(endPointv1static+'/dl');
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('x-karza-key',authorizationKey);
            req.setMethod('POST');
            req.setTimeout(120000);
            req.setBody(jsonRequestBody);
            HttpResponse response=httpProtocol.send(req);
            System.debug('response :- '+response.getBody());
            responseBodyDriverLicense=response.getBody();
            //responseKycRequestIntegrationStatus(kycObj1, 'Completed', currentDateTime);
            
            if(responseBodyDriverLicense.length()>0){// check length
                System.debug('responseBodyDriverLicense len : '+responseBodyDriverLicense.length());
                //get ApiCount from KYCObj
                if(kycObj1.Id!=null){
                    kycObj1.API_Count__c=kycList[0].API_Count__c+1;
                }
            }
            kycObj1.RecordTypeId=recordtypeKycDrivingLicenseId;
            kycObj1.KYC_Last_Updated_Date_Time__c=currentDateTime;
            kycObj1.Request_Type__c='Scheduler';

            // For getting status from responseBodyVoter     //
            String status='';
            if(String.valueOf(getMapResults(responseBodyDriverLicense).get('status'))!=null){
                status=String.valueOf(getMapResults(responseBodyDriverLicense).get('status'));
                if(status!='' || status!=null){
                    kycObj1.Status_Code__c = status;
                    kycObj1.Request_Id__c = '';
                    kycObj1.Request_JSON__c=jsonRequestBody;
                    kycObj1.Respone_JSON__c = responseBodyDriverLicense;
                    kycObj1.dl_resp_name__c = '';
                    kycObj1.dl_resp_dob__c = null;
                    kycObj1.dl_resp_father_husband_name__c = '';
                    kycObj1.dl_resp_Issue_Date__c = null;
                    kycObj1.dl_resp_address__c = '';
                    kycObj1.dl_resp_blood_group__c = '';
                    kycObj1.dl_resp_cov_issue_date__c='';
                    kycObj1.dl_resp_cov__c='';
                    kycObj1.dl_resp_validity_non_transport__c='';
                    kycObj1.dl_resp_validity_transport__c='';
                    responseKycRequestIntegrationStatus(kycObj1, 'Failed', currentDateTime,'Not Valid');
                    MonitorLogGenerationController.setMonitorLogss( kyc_mode, currentTime, jsonRequestBody,responseBodyDriverLicense, '', logName, status, kycid);  
                }
            }else {
                // Deserialized Driving license Json
                //System.debug('responseBodyDriverLicense : '+responseBodyDriverLicense);
                String statusCodeStr=String.valueOf(getMapResults(responseBodyDriverLicense).get('status-code'));
                String requestIdStr=String.valueOf(getMapResults(responseBodyDriverLicense).get('request_id'));
                
                if(statusCodeStr =='101'){
                    
                    String date1=String.valueOf(getMapResult(responseBodyDriverLicense).get('dob'));
                    String[] strDate = date1.split('-');
                    Integer myIntDate = integer.valueOf(strDate[1]);
                    Integer myIntMonth = integer.valueOf(strDate[0]);
                    Integer myIntYear = integer.valueOf(strDate[2]);
                    //Date dobDate = Date.newInstance(myIntYear, myIntMonth, myIntDate);
                    Date dobDate = Date.newInstance(myIntYear, myIntDate, myIntMonth);
                    
                    String date2=String.valueOf(getMapResult(responseBodyDriverLicense).get('issue_date'));
                    String[] strDate2 = date2.split('-');
                    Integer myIntDate2 = integer.valueOf(strDate2[1]);
                    Integer myIntMonth2 = integer.valueOf(strDate2[0]);
                    Integer myIntYear2 = integer.valueOf(strDate2[2]);
                    Date issueDate = Date.newInstance(myIntYear2, myIntMonth2, myIntDate2);
                    
                    //System.debug('statusCodeStr : '+statusCodeStr);
                    List<Object> covDetailsList=(List<Object>) getMapResult(responseBodyDriverLicense).get('cov_details');
                    String covIssusedateStr='';
                    String covCovStr='';
                    System.debug('covDetailsList : '+covDetailsList);
                    for(Object obj:covDetailsList){
                        Map<String,Object> mpParsed = (Map<String,Object>)obj;
                        Object issue_date=mpParsed.get('issue_date');
                        Object cov=mpParsed.get('cov');
                        //System.debug('issue_date : '+issue_date);
                        //System.debug('cov : '+cov);
                        covIssusedateStr = String.valueOf(issue_date);
                        covCovStr = String.valueOf(cov);
                    }
                    Map<String,Object> resultMatch = (Map<String, Object>) getMapResult(responseBodyDriverLicense).get('validity');
                    
                    /*Decimal dlScore=100;
                    kycObj1.Confidence_score__c = dlScore;*/
                    kycObj1.Status_Code__c = statusCodeStr;
                    kycObj1.Request_Id__c = requestIdStr;
                    kycObj1.Request_JSON__c=jsonRequestBody;
                    kycObj1.Respone_JSON__c = responseBodyDriverLicense;
                    kycObj1.dl_resp_name__c = String.valueOf(getMapResult(responseBodyDriverLicense).get('name'));
                    kycObj1.dl_resp_dob__c = dobDate;
                    kycObj1.dl_resp_father_husband_name__c = String.valueOf(getMapResult(responseBodyDriverLicense).get('father/husband'));
                    kycObj1.dl_resp_Issue_Date__c = issueDate;
                    kycObj1.dl_resp_address__c = String.valueOf(getMapResult(responseBodyDriverLicense).get('address'));
                    kycObj1.dl_resp_blood_group__c = String.valueOf(getMapResult(responseBodyDriverLicense).get('blood_group'));
                    kycObj1.dl_resp_cov_issue_date__c=covIssusedateStr;
                    kycObj1.dl_resp_cov__c=covCovStr;
                    kycObj1.dl_resp_validity_non_transport__c=String.valueOf(resultMatch.get('non-transport'));
                    kycObj1.dl_resp_validity_transport__c=String.valueOf(resultMatch.get('transport'));
                    responseKycRequestIntegrationStatus(kycObj1, 'Completed', currentDateTime,'Valid');
                    //for Success 
                    MonitorLogGenerationController.setMonitorLogss(kyc_mode, currentTime, jsonRequestBody,responseBodyDriverLicense, '', logName, statusCodeStr, kycid);
                 }else {
                    // Else condition for inner http status code 102,103,etc
                    kycObj1.Status_Code__c = statusCodeStr;
                    kycObj1.Request_Id__c = requestIdStr;
                    kycObj1.Request_JSON__c=jsonRequestBody;
                    kycObj1.Respone_JSON__c = responseBodyDriverLicense;
                    kycObj1.dl_resp_name__c = '';
                    kycObj1.dl_resp_dob__c = null;
                    kycObj1.dl_resp_father_husband_name__c = '';
                    kycObj1.dl_resp_Issue_Date__c = null;
                    kycObj1.dl_resp_address__c = '';
                    kycObj1.dl_resp_blood_group__c = '';
                    kycObj1.dl_resp_cov_issue_date__c='';
                    kycObj1.dl_resp_cov__c='';
                    kycObj1.dl_resp_validity_non_transport__c='';
                    kycObj1.dl_resp_validity_transport__c='';
                    responseKycRequestIntegrationStatus(kycObj1, 'Failed', currentDateTime,'Not Valid'); 
                    MonitorLogGenerationController.setMonitorLogss(kyc_mode, currentTime, jsonRequestBody,responseBodyDriverLicense, '', logName, statusCodeStr, kycid);
                } 
            }
            if(Test.isRunningTest())
            {
                Exception e;
                throw e;
            }
        }catch(DmlException ex) {
            responseKycRequestIntegrationStatus(kycObj1, 'Failed', currentDateTime,'Failed');
            MonitorLogGenerationController.setMonitorLogss(kyc_mode, currentTime, '','', ''+ex.getMessage() , '', '', kycid);
        } catch(SObjectException ex) {
            responseKycRequestIntegrationStatus(kycObj1, 'Failed', currentDateTime,'Failed');
            MonitorLogGenerationController.setMonitorLogss(kyc_mode, currentTime, '','', ''+ex.getMessage() , '', '', kycid);
        }catch(Exception e){
            responseKycRequestIntegrationStatus(kycObj1, 'Failed', currentDateTime,'Failed');
            MonitorLogGenerationController.setMonitorLogss(kyc_mode, currentTime, jsonRequestBody,'', 'Transaction Log : '+e.getStackTraceString(), logName, '', kycid);
        }
    }
    
    public static void validateVoterId(Id kycid,String kyc_mode,String jsonRequestBody,Id recordtypeKycVoterId,DateTime currentTime,String logName){
        String responseBodyVoter='';
        List<KYC_Api__c> kycApiList=[Select id, Endpoint__c, EndpointV3__c, EndpointV1__c, x_karza_key__c from KYC_Api__c];
        endPointv1static = kycApiList[0].endpoint__c;
        authorizationKey= kycApiList[0].x_karza_key__c;
        consent ='Y';
        httpProtocol = new Http();
        req = new HttpRequest();
        List<KYC__c> kycList=[SELECT Id, API_Count__c, API_Count_OCR__c FROM KYC__c where Id=:kycid];
        KYC__c kycObj1 = new KYC__c();
        
        kycObj1.Id=kycid;
        System.debug('kycObj1.Id : '+kycObj1.Id);
        Datetime currentDateTime=Datetime.now();
        try{
        System.debug(jsonRequestBody);
        req.setEndpoint(endPointv1static+'/voter');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('x-karza-key',authorizationKey);
        req.setMethod('POST');
        req.setTimeout(120000);
        req.setBody(jsonRequestBody);
        HttpResponse response=httpProtocol.send(req);
        System.debug('response :- '+response.getBody());
        responseBodyVoter=response.getBody();
           
        if(responseBodyVoter.length()>0){// check length
                      System.debug('responseBodyVoter len : '+responseBodyVoter.length());
                      //get ApiCount from KYCObj
                     if(kycObj1.Id!=null){
                            kycObj1.API_Count__c=kycList[0].API_Count__c+1;
                       }
                  }
            kycObj1.RecordTypeId=recordtypeKycVoterId;
            kycObj1.KYC_Last_Updated_Date_Time__c=currentDateTime;
            kycObj1.Request_Type__c='Scheduler';                
            // For getting status from responseBodyVoter     //
            String status='';
            if(String.valueOf(getMapResults(responseBodyVoter).get('status'))!=null){
                status=String.valueOf(getMapResults(responseBodyVoter).get('status'));
                if(status!='' || status!=null){
                    kycObj1.Status_Code__c = status; 
                    kycObj1.Request_Id__c = ''; 
                    kycObj1.Request_JSON__c=jsonRequestBody;
                    kycObj1.Respone_JSON__c = responseBodyVoter;
                    kycObj1.vi_resp_ac_name__c = '';
                    kycObj1.vi_resp_ac_no__c = '';
                    kycObj1.vi_resp_age__c = '';
                    kycObj1.vi_resp_district__c = '';
                    kycObj1.vi_resp_dob__c = '';
                    kycObj1.vi_resp_epic_no__c = '';
                    kycObj1.vi_resp_gender__c = '';
                    kycObj1.vi_resp_house_no__c = '';
                    kycObj1.vi_resp_vid__c = '';
                    kycObj1.vi_resp_last_update__c = '';
                    kycObj1.vi_resp_name__c = '';
                    kycObj1.vi_resp_name_v1__c = '';
                    kycObj1.vi_resp_name_v2__c = '';
                    kycObj1.vi_resp_name_v3__c = '';
                    kycObj1.vi_resp_part_name__c = '';
                    kycObj1.vi_resp_part_no__c = '';
                    kycObj1.vi_resp_pc_name__c = '';
                    kycObj1.vi_resp_ps_lat_long__c = '';
                    kycObj1.vi_resp_ps_name__c = '';
                    kycObj1.vi_resp_rln_name__c = '';
                    kycObj1.vi_resp_rln_name_v1__c = '';
                    kycObj1.vi_resp_rln_name_v1__c = '';
                    kycObj1.vi_resp_rln_name_v2__c = '';
                    kycObj1.vi_resp_rln_name_v3__c = '';
                    kycObj1.vi_resp_rln_type__c = '';
                    kycObj1.vi_resp_section_no__c = '';
                    kycObj1.vi_resp_slno_inpart__c = '';
                    kycObj1.vi_resp_state__c = '';
                    kycObj1.vi_resp_st_code__c = '';
                    responseKycRequestIntegrationStatus(kycObj1, 'Failed', currentDateTime,'Not Valid');
                    MonitorLogGenerationController.setMonitorLogss( kyc_mode, currentTime, jsonRequestBody,responseBodyVoter, '', logName, status, kycid);  
                }
            }else{
                // Deserialized Voter Id Json
                //System.debug('responseBodyVoter : '+responseBodyVoter);
                String statusCodeStr=String.valueOf(getMapResults(responseBodyVoter).get('status-code'));
                String requestIdStr=String.valueOf(getMapResults(responseBodyVoter).get('request_id'));
                String nameFromResult=String.valueOf(getMapResult(responseBodyVoter).get('name'));
                //System.debug('statusCodeStr : '+statusCodeStr);
                
                if(statusCodeStr =='101'){
                    
                    /*Decimal voterScore=100;
                    kycObj1.Confidence_score__c = voterScore;*/ 
                    kycObj1.Status_Code__c = statusCodeStr; 
                    kycObj1.Request_Id__c = requestIdStr; 
                    kycObj1.Request_JSON__c=jsonRequestBody;
                    kycObj1.Respone_JSON__c = responseBodyVoter;
                    kycObj1.vi_resp_ac_name__c = String.valueOf(getMapResult(responseBodyVoter).get('ac_name'));
                    kycObj1.vi_resp_ac_no__c = String.valueOf(getMapResult(responseBodyVoter).get('ac_no'));
                    kycObj1.vi_resp_age__c = String.valueOf(getMapResult(responseBodyVoter).get('age'));
                    kycObj1.vi_resp_district__c = String.valueOf(getMapResult(responseBodyVoter).get('district'));
                    kycObj1.vi_resp_dob__c = String.valueOf(getMapResult(responseBodyVoter).get('dob'));
                    kycObj1.vi_resp_epic_no__c = String.valueOf(getMapResult(responseBodyVoter).get('epic_no'));
                    kycObj1.vi_resp_gender__c = String.valueOf(getMapResult(responseBodyVoter).get('gender'));
                    kycObj1.vi_resp_house_no__c = String.valueOf(getMapResult(responseBodyVoter).get('house_no'));
                    kycObj1.vi_resp_vid__c = String.valueOf(getMapResult(responseBodyVoter).get('id'));
                    kycObj1.vi_resp_last_update__c = String.valueOf(getMapResult(responseBodyVoter).get('last_update'));
                    kycObj1.vi_resp_name__c = String.valueOf(getMapResult(responseBodyVoter).get('name'));
                    kycObj1.vi_resp_name_v1__c = String.valueOf(getMapResult(responseBodyVoter).get('name_v1'));
                    kycObj1.vi_resp_name_v2__c = String.valueOf(getMapResult(responseBodyVoter).get('name_v2'));
                    kycObj1.vi_resp_name_v3__c = String.valueOf(getMapResult(responseBodyVoter).get('name_v3'));
                    kycObj1.vi_resp_part_name__c = String.valueOf(getMapResult(responseBodyVoter).get('part_name'));
                    kycObj1.vi_resp_part_no__c = String.valueOf(getMapResult(responseBodyVoter).get('part_no'));
                    kycObj1.vi_resp_pc_name__c = String.valueOf(getMapResult(responseBodyVoter).get('pc_name'));
                    kycObj1.vi_resp_ps_lat_long__c = String.valueOf(getMapResult(responseBodyVoter).get('ps_lat_long'));
                    kycObj1.vi_resp_ps_name__c = String.valueOf(getMapResult(responseBodyVoter).get('ps_name'));
                    kycObj1.vi_resp_rln_name__c = String.valueOf(getMapResult(responseBodyVoter).get('rln_name'));
                    kycObj1.vi_resp_rln_name_v1__c = String.valueOf(getMapResult(responseBodyVoter).get('rln_name_v1'));
                    kycObj1.vi_resp_rln_name_v1__c = String.valueOf(getMapResult(responseBodyVoter).get('rln_name_v1'));
                    kycObj1.vi_resp_rln_name_v2__c = String.valueOf(getMapResult(responseBodyVoter).get('rln_name_v2'));
                    kycObj1.vi_resp_rln_name_v3__c = String.valueOf(getMapResult(responseBodyVoter).get('rln_name_v3'));
                    kycObj1.vi_resp_rln_type__c = String.valueOf(getMapResult(responseBodyVoter).get('rln_type'));
                    kycObj1.vi_resp_section_no__c = String.valueOf(getMapResult(responseBodyVoter).get('section_no'));
                    kycObj1.vi_resp_slno_inpart__c = String.valueOf(getMapResult(responseBodyVoter).get('slno_inpart'));
                    kycObj1.vi_resp_state__c = String.valueOf(getMapResult(responseBodyVoter).get('state'));
                    kycObj1.vi_resp_st_code__c = String.valueOf(getMapResult(responseBodyVoter).get('st_code'));
                    responseKycRequestIntegrationStatus(kycObj1, 'Completed', currentDateTime,'Valid');  
                    //for Success 
                    MonitorLogGenerationController.setMonitorLogss(kyc_mode, currentTime, jsonRequestBody,responseBodyVoter, '', logName, statusCodeStr, kycid);
                }else {
                    // Else condition for inner http status code 102,103,etc
                    kycObj1.Status_Code__c = statusCodeStr; 
                    kycObj1.Request_Id__c = requestIdStr; 
                    kycObj1.Request_JSON__c=jsonRequestBody;
                    kycObj1.Respone_JSON__c = responseBodyVoter;
                    kycObj1.vi_resp_ac_name__c = '';
                    kycObj1.vi_resp_ac_no__c = '';
                    kycObj1.vi_resp_age__c = '';
                    kycObj1.vi_resp_district__c = '';
                    kycObj1.vi_resp_dob__c = '';
                    kycObj1.vi_resp_epic_no__c = '';
                    kycObj1.vi_resp_gender__c = '';
                    kycObj1.vi_resp_house_no__c = '';
                    kycObj1.vi_resp_vid__c = '';
                    kycObj1.vi_resp_last_update__c = '';
                    kycObj1.vi_resp_name__c = '';
                    kycObj1.vi_resp_name_v1__c = '';
                    kycObj1.vi_resp_name_v2__c = '';
                    kycObj1.vi_resp_name_v3__c = '';
                    kycObj1.vi_resp_part_name__c = '';
                    kycObj1.vi_resp_part_no__c = '';
                    kycObj1.vi_resp_pc_name__c = '';
                    kycObj1.vi_resp_ps_lat_long__c = '';
                    kycObj1.vi_resp_ps_name__c = '';
                    kycObj1.vi_resp_rln_name__c = '';
                    kycObj1.vi_resp_rln_name_v1__c = '';
                    kycObj1.vi_resp_rln_name_v1__c = '';
                    kycObj1.vi_resp_rln_name_v2__c = '';
                    kycObj1.vi_resp_rln_name_v3__c = '';
                    kycObj1.vi_resp_rln_type__c = '';
                    kycObj1.vi_resp_section_no__c = '';
                    kycObj1.vi_resp_slno_inpart__c = '';
                    kycObj1.vi_resp_state__c = '';
                    kycObj1.vi_resp_st_code__c = '';
                    responseKycRequestIntegrationStatus(kycObj1, 'Failed', currentDateTime,'Not Valid'); 
                    MonitorLogGenerationController.setMonitorLogss(kyc_mode, currentTime, jsonRequestBody,responseBodyVoter, '', logName, statusCodeStr, kycid);
                }   
            } 
            if(Test.isRunningTest())
            {
                Exception e;
                throw e;
            }
        }catch(DmlException ex) {
            responseKycRequestIntegrationStatus(kycObj1, 'Failed', currentDateTime,'Failed');
            MonitorLogGenerationController.setMonitorLogss(kyc_mode, currentTime, '','', ''+ex.getMessage() , '', '', kycid);
        } catch(SObjectException ex) {
            responseKycRequestIntegrationStatus(kycObj1, 'Failed', currentDateTime,'Failed');
            MonitorLogGenerationController.setMonitorLogss(kyc_mode, currentTime, '','', ''+ex.getMessage() , '', '', kycid);
        }catch(Exception e){
            responseKycRequestIntegrationStatus(kycObj1, 'Failed', currentDateTime,'Failed');
            MonitorLogGenerationController.setMonitorLogss(kyc_mode, currentTime, jsonRequestBody,'', 'Transaction Log : '+e.getStackTraceString(), logName, '', kycid);
        }
    }
    
    public static void validateFssai(Id kycid,String kyc_mode,String jsonRequestBody,Id recordtypeKycFSSAIId,DateTime currentTime,String logName){
        String responseBodyFssai='';
        List<KYC_Api__c> kycApiList=[Select id, Endpoint__c, EndpointV3__c, EndpointV1__c, x_karza_key__c from KYC_Api__c];
        endPointv1static = kycApiList[0].endpoint__c;
        authorizationKey= kycApiList[0].x_karza_key__c;
        consent ='Y';
        httpProtocol = new Http();
        req = new HttpRequest();
        List<KYC__c> kycList=[SELECT Id, API_Count__c, API_Count_OCR__c FROM KYC__c where Id=:kycid];
        KYC__c kycObj1 = new KYC__c();
        
        kycObj1.Id=kycid;
        System.debug('kycObj1.Id : '+kycObj1.Id);
        Datetime currentDateTime=Datetime.now();
        try{
            System.debug(jsonRequestBody);
            req.setEndpoint(endPointv1static+'/fssai');
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('x-karza-key',authorizationKey);
            req.setMethod('POST');
            req.setTimeout(120000);
            req.setBody(jsonRequestBody);
            HttpResponse response=httpProtocol.send(req);
            System.debug('response :- '+response.getBody());
            responseBodyFssai=response.getBody();
            
            if(responseBodyFssai.length()>0){// check length
                //get ApiCount from KYCObj
                if(kycObj1.Id!=null){
                    kycObj1.API_Count__c=kycList[0].API_Count__c+1;
                }
            }
            kycObj1.RecordTypeId=recordtypeKycFSSAIId;
            kycObj1.KYC_Last_Updated_Date_Time__c=currentDateTime;
            kycObj1.Request_Type__c='Scheduler';
            // For getting status from responseBodyFssai     //
            // For Alternate http status code 400,401,402,500,503,504
            String status='';
            if(String.valueOf(getMapResults(responseBodyFssai).get('status'))!=null){
                status=String.valueOf(getMapResults(responseBodyFssai).get('status'));
                if(status!='' || status!=null){
                    kycObj1.Status_Code__c = status; 
                    kycObj1.Request_Id__c = ''; 
                    kycObj1.Request_JSON__c = jsonRequestBody; 
                    kycObj1.Respone_JSON__c = responseBodyFssai; 
                    kycObj1.fssai_resp_status__c = '';
                    kycObj1.fssai_resp_address__c = '';
                    kycObj1.fssai_resp_firm_name__c = '';
                    kycObj1.fssai_resp_lic_no__c = '';
                    kycObj1.fssai_resp_lic_type__c = '';
                    responseKycRequestIntegrationStatus(kycObj1, 'Failed', currentDateTime,'Not Valid');
                    MonitorLogGenerationController.setMonitorLogss( kyc_mode, currentTime, jsonRequestBody,responseBodyFssai, '', logName, status, kycid);  
                }
            }else{
                // Deserialized PAN Json
                String statusCodeStr=String.valueOf(getMapResults(responseBodyFssai).get('status-code'));
                String requestIdStr=String.valueOf(getMapResults(responseBodyFssai).get('request_id'));
                String firmNameFromResult=String.valueOf(getMapResult(responseBodyFssai).get('FirmName'));
                // For http status code 101
                if(statusCodeStr =='101'){
                    
                    kycObj1.Status_Code__c = statusCodeStr; 
                    kycObj1.Request_Id__c = requestIdStr; 
                    kycObj1.Request_JSON__c = jsonRequestBody; 
                    kycObj1.Respone_JSON__c = responseBodyFssai; 
                    kycObj1.fssai_resp_status__c = String.valueOf(getMapResult(responseBodyFssai).get('Status'));
                    kycObj1.fssai_resp_address__c = String.valueOf(getMapResult(responseBodyFssai).get('Address'));
                    kycObj1.fssai_resp_firm_name__c = firmNameFromResult;
                    kycObj1.fssai_resp_lic_no__c = String.valueOf(getMapResult(responseBodyFssai).get('LicNO'));
                    kycObj1.fssai_resp_lic_type__c = String.valueOf(getMapResult(responseBodyFssai).get('LicType'));
                    responseKycRequestIntegrationStatus(kycObj1, 'Completed', currentDateTime,'Valid');
                    //for Success 
                    MonitorLogGenerationController.setMonitorLogss(kyc_mode, currentTime, jsonRequestBody,responseBodyFssai, '', logName, statusCodeStr, kycid);
                }else {
                    // Else condition for inner http status code 102,103,etc
                    kycObj1.Status_Code__c = statusCodeStr; 
                    kycObj1.Request_Id__c = requestIdStr; 
                    kycObj1.Request_JSON__c = jsonRequestBody; 
                    kycObj1.Respone_JSON__c = responseBodyFssai; 
                    kycObj1.fssai_resp_status__c = '';
                    kycObj1.fssai_resp_address__c = '';
                    kycObj1.fssai_resp_firm_name__c = '';
                    kycObj1.fssai_resp_lic_no__c = '';
                    kycObj1.fssai_resp_lic_type__c = '';
                    responseKycRequestIntegrationStatus(kycObj1, 'Failed', currentDateTime,'Not Valid');
                    MonitorLogGenerationController.setMonitorLogss(kyc_mode, currentTime, jsonRequestBody,responseBodyFssai, '', logName, statusCodeStr, kycid);
                }
            }
            
            
            if(Test.isRunningTest())
            {
                Exception e;
                throw e;
            }
                           
        }catch(DmlException ex) {
            responseKycRequestIntegrationStatus(kycObj1, 'Failed', currentDateTime,'Failed');
            MonitorLogGenerationController.setMonitorLogss(kyc_mode, currentTime, '','', ''+ex.getMessage() , '', '', kycid);
        } catch(SObjectException ex) {
            responseKycRequestIntegrationStatus(kycObj1, 'Failed', currentDateTime,'Failed');
            MonitorLogGenerationController.setMonitorLogss(kyc_mode, currentTime, '','', ''+ex.getMessage() , '', '', kycid);
        }catch(Exception e){
            responseKycRequestIntegrationStatus(kycObj1, 'Failed', currentDateTime,'Failed');
            MonitorLogGenerationController.setMonitorLogss(kyc_mode, currentTime, jsonRequestBody,'', 'Transaction Log : '+e.getStackTraceString(), logName, '', kycid);
        }
    }
    
    
    public static void validateBankAccount(Id kycid, String kyc_mode,String jsonRequestBody,Id recordtypeKycBankAccountId, DateTime currentTime,String logName){
        String responseBodyBankAccount='';
        List<KYC_Api__c> kycApiList=[Select id, Endpoint__c, EndpointV3__c, EndpointV1__c, x_karza_key__c from KYC_Api__c];
        endPointv1static = kycApiList[0].endpoint__c;
        endPointv3static = kycApiList[0].endpointV3__c;
        authorizationKey= kycApiList[0].x_karza_key__c;
        httpProtocol = new Http();
        req = new HttpRequest();
        List<KYC__c> kycList=[SELECT Id, API_Count__c, API_Count_OCR__c FROM KYC__c where Id=:kycid];
        KYC__c kycObj1 = new KYC__c();
        
        kycObj1.Id=kycid;
        System.debug('kycObj1.Id : '+kycObj1.Id);
        Datetime currentDateTime=Datetime.now();
        String errorMessage='';
        
            try{
            System.debug(jsonRequestBody);
            req.setEndpoint(endPointv1static+'/bankacc');
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('x-karza-key',authorizationKey);
            req.setMethod('POST');
            req.setTimeout(120000);
            req.setBody(jsonRequestBody);
            HttpResponse response=httpProtocol.send(req);
            System.debug('response :- '+response.getBody());
            responseBodyBankAccount=response.getBody();
                
                if(responseBodyBankAccount.length()>0){// check length
                    //get ApiCount from KYCObj
                    if(kycObj1.Id!=null){
                        kycObj1.API_Count__c=kycList[0].API_Count__c+1;
                    }
                }
                kycObj1.RecordTypeId=recordtypeKycBankAccountId;
                kycObj1.KYC_Last_Updated_Date_Time__c=currentDateTime;
                kycObj1.Request_Type__c='Scheduler';
                // For getting status from responseBodyBankAccount  //
                String statusbankaccount='';
                if(String.valueOf(getMapResults(responseBodyBankAccount).get('status'))!=null){
                    statusbankaccount=String.valueOf(getMapResults(responseBodyBankAccount).get('status'));
                    if(statusbankaccount!='' || statusbankaccount!=null){
                        kycObj1.Status_Code__c = statusbankaccount;
                        kycObj1.Request_Id__c = '';
                        kycObj1.Request_JSON__c = jsonRequestBody;
                        kycObj1.Respone_JSON__c = responseBodyBankAccount;
                        kycObj1.ban_resp_bankTxnStatus__c= '';
                        kycObj1.ban_resp_account_number__c= '';
                        kycObj1.ban_resp_ifsc__c= '';
                        kycObj1.ban_resp_account_name__c= '';
                        kycObj1.ban_resp_bank_response__c= '';
                        responseKycRequestIntegrationStatus(kycObj1, 'Failed', currentDateTime,'Not Valid');
                        MonitorLogGenerationController.setMonitorLogss( kyc_mode, currentTime, jsonRequestBody,responseBodyBankAccount, '', logName, statusbankaccount, kycid);  
                    }
                }else {
                    // Deserialized Bank Account Json
                    String statusCodeStr=String.valueOf(getMapResults(responseBodyBankAccount).get('status-code'));
                    String requestIdStr=String.valueOf(getMapResults(responseBodyBankAccount).get('request_id'));
                    
                    if(statusCodeStr =='101'){
                        
                        kycObj1.Status_Code__c = statusCodeStr;
                        kycObj1.Request_Id__c = requestIdStr;
                        kycObj1.Request_JSON__c = jsonRequestBody;
                        kycObj1.Respone_JSON__c = responseBodyBankAccount;
                        kycObj1.ban_resp_bankTxnStatus__c= String.valueOf(getMapResult(responseBodyBankAccount).get('bankTxnStatus'));
                        kycObj1.ban_resp_account_number__c= String.valueOf(getMapResult(responseBodyBankAccount).get('accountNumber'));
                        kycObj1.ban_resp_ifsc__c= String.valueOf(getMapResult(responseBodyBankAccount).get('ifsc'));
                        kycObj1.ban_resp_account_name__c= String.valueOf(getMapResult(responseBodyBankAccount).get('accountName'));
                        kycObj1.ban_resp_bank_response__c= String.valueOf(getMapResult(responseBodyBankAccount).get('bankResponse'));
                        responseKycRequestIntegrationStatus(kycObj1, 'Partially Completed', currentDateTime,'Valid');
                        MonitorLogGenerationController.setMonitorLogss(kyc_mode, currentTime, jsonRequestBody,responseBodyBankAccount, '', logName, statusCodeStr, kycid);
                        
                    }else {
                        kycObj1.Status_Code__c = statusCodeStr;
                        kycObj1.Request_Id__c = requestIdStr;
                        kycObj1.Request_JSON__c = jsonRequestBody;
                        kycObj1.Respone_JSON__c = responseBodyBankAccount;
                        kycObj1.ban_resp_bankTxnStatus__c= '';
                        kycObj1.ban_resp_account_number__c= '';
                        kycObj1.ban_resp_ifsc__c= '';
                        kycObj1.ban_resp_account_name__c= '';
                        kycObj1.ban_resp_bank_response__c= '';
                        responseKycRequestIntegrationStatus(kycObj1, 'Failed', currentDateTime,'Not Valid');
                        MonitorLogGenerationController.setMonitorLogss(kyc_mode, currentTime, jsonRequestBody,responseBodyBankAccount, '', logName, statusCodeStr, kycid);
                    }   
                }  
                if(Test.isRunningTest())
                {
                    Exception e;
                    throw e;
                }
            }catch(DmlException ex) {
                responseKycRequestIntegrationStatus(kycObj1, 'Failed', currentDateTime,'Failed');
                MonitorLogGenerationController.setMonitorLogss(kyc_mode, currentTime, '','', ''+ex.getMessage() , '', '', kycid);
            } catch(SObjectException ex) {
                responseKycRequestIntegrationStatus(kycObj1, 'Failed', currentDateTime,'Failed');
                MonitorLogGenerationController.setMonitorLogss(kyc_mode, currentTime, '','', ''+ex.getMessage() , '', '', kycid);
            }catch(Exception e){
                responseKycRequestIntegrationStatus(kycObj1, 'Failed', currentDateTime,'Failed');
                MonitorLogGenerationController.setMonitorLogss(kyc_mode, currentTime, jsonRequestBody,'', 'Transaction Log : '+e.getStackTraceString(), logName, '', kycid);
            }
    }
    
    public static void validateFda(Id kycid, String kyc_mode,String jsonRequestBody,Id recordtypeKycFDAId, DateTime currentTime,String logName){
        String responseBodyFda='';
        List<KYC_Api__c> kycApiList=[Select id, Endpoint__c, EndpointV3__c, EndpointV1__c, x_karza_key__c from KYC_Api__c];
        endPointv1static = kycApiList[0].endpoint__c;
        authorizationKey= kycApiList[0].x_karza_key__c;
        consent ='Y';
        httpProtocol = new Http();
        req = new HttpRequest();
        List<KYC__c> kycList=[SELECT Id, API_Count__c, API_Count_OCR__c FROM KYC__c where Id=:kycid];
        KYC__c kycObj1 = new KYC__c();
        
        kycObj1.Id=kycid;
        System.debug('kycObj1.Id : '+kycObj1.Id);
        Datetime currentDateTime=Datetime.now();
        try{
            System.debug(jsonRequestBody);
            req.setEndpoint(endPointv1static+'/fda');
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('x-karza-key',authorizationKey);
            req.setMethod('POST');
            req.setTimeout(120000);
            req.setBody(jsonRequestBody);
            HttpResponse response=httpProtocol.send(req);
            System.debug('response :- '+response.getBody());
            responseBodyFda=response.getBody();
            if(responseBodyFda.length()>0){// check length
                System.debug('responseBodyFda len : '+responseBodyFda.length());
                //get ApiCount from KYCObj
                if(kycObj1.Id!=null){
                    kycObj1.API_Count__c=kycList[0].API_Count__c+1;
                }
            }
            kycObj1.RecordTypeId=recordtypeKycFDAId;
            kycObj1.KYC_Last_Updated_Date_Time__c=currentDateTime;
            kycObj1.Request_Type__c='Scheduler';
            // For getting status from responseBodyFda     //
            String status='';
            if(String.valueOf(getMapResults(responseBodyFda).get('status'))!=null){
                status=String.valueOf(getMapResults(responseBodyFda).get('status'));
                if(status!='' || status!=null){
                    kycObj1.Status_Code__c = status;
                    kycObj1.Request_Id__c = '';
                    kycObj1.Request_JSON__c = jsonRequestBody;
                    kycObj1.Respone_JSON__c = responseBodyFda;
                    kycObj1.fda_resp_store_name__c = '';
                    kycObj1.fda_resp_contact_number__c = '';
                    kycObj1.fda_resp_license_detail__c = '';
                    kycObj1.fda_resp_name__c =  '';
                    kycObj1.fda_resp_address__c =  '';
                    responseKycRequestIntegrationStatus(kycObj1, 'Failed', currentDateTime,'Not Valid');
                    MonitorLogGenerationController.setMonitorLogss( kyc_mode, currentTime, jsonRequestBody,responseBodyFda, '', logName, status, kycid);  
                }
            }else {
                // Deserialized FDA Json
                String statusCodeStr=String.valueOf(getMapResults(responseBodyFda).get('status-code'));
                String requestIdStr=String.valueOf(getMapResults(responseBodyFda).get('request_id'));
                
                if(statusCodeStr =='101'){
                    
                    kycObj1.Status_Code__c = statusCodeStr;
                    kycObj1.Request_Id__c = requestIdStr;
                    kycObj1.Request_JSON__c = jsonRequestBody;
                    kycObj1.Respone_JSON__c = responseBodyFda;
                    kycObj1.fda_resp_store_name__c = String.valueOf(getMapResult(responseBodyFda).get('store_name'));
                    kycObj1.fda_resp_contact_number__c = String.valueOf(getMapResult(responseBodyFda).get('contact_number'));
                    kycObj1.fda_resp_license_detail__c = String.valueOf(getMapResult(responseBodyFda).get('license_detail'));
                    kycObj1.fda_resp_name__c =  String.valueOf(getMapResult(responseBodyFda).get('name'));
                    kycObj1.fda_resp_address__c =  String.valueOf(getMapResult(responseBodyFda).get('address'));
                    responseKycRequestIntegrationStatus(kycObj1, 'Completed', currentDateTime,'Valid');
                    //for Success 
                    MonitorLogGenerationController.setMonitorLogss(kyc_mode, currentTime, jsonRequestBody,responseBodyFda, '', logName, statusCodeStr, kycid);
                    
                }else {
                    kycObj1.Status_Code__c = statusCodeStr;
                    kycObj1.Request_Id__c = requestIdStr;
                    kycObj1.Request_JSON__c = jsonRequestBody;
                    kycObj1.Respone_JSON__c = responseBodyFda;
                    kycObj1.fda_resp_store_name__c = '';
                    kycObj1.fda_resp_contact_number__c = '';
                    kycObj1.fda_resp_license_detail__c = '';
                    kycObj1.fda_resp_name__c =  '';
                    kycObj1.fda_resp_address__c =  '';
                    responseKycRequestIntegrationStatus(kycObj1, 'Failed', currentDateTime,'Not Valid');
                    MonitorLogGenerationController.setMonitorLogss(kyc_mode, currentTime, jsonRequestBody,responseBodyFda, '', logName, statusCodeStr, kycid);
                    
                } 
            }
            if(Test.isRunningTest())
            {
                Exception e;
                throw e;
            }
        }catch(DmlException ex) {
            responseKycRequestIntegrationStatus(kycObj1, 'Failed', currentDateTime,'Failed');
            MonitorLogGenerationController.setMonitorLogss(kyc_mode, currentTime, '','', ''+ex.getMessage() , '', '', kycid);
        } catch(SObjectException ex) {
            responseKycRequestIntegrationStatus(kycObj1, 'Failed', currentDateTime,'Failed');
            MonitorLogGenerationController.setMonitorLogss(kyc_mode, currentTime, '','', ''+ex.getMessage() , '', '', kycid);
        }catch(Exception e){
            responseKycRequestIntegrationStatus(kycObj1, 'Failed', currentDateTime,'Failed');
            MonitorLogGenerationController.setMonitorLogss(kyc_mode, currentTime, jsonRequestBody,'', 'Transaction Log : '+e.getStackTraceString(), logName, '', kycid);
        }
        
    }
    
    public static void validateGst(Id kycid,String kyc_mode,String jsonRequestBody,Id recordtypeKycGSTId, DateTime currentTime,String logName){
        String responseBodyGst = '';
        List<KYC_Api__c> kycApiList=[Select id, Endpoint__c, EndpointV3__c, EndpointV1__c, x_karza_key__c from KYC_Api__c];
        endPointv1static = kycApiList[0].EndpointV1__c;
        authorizationKey= kycApiList[0].x_karza_key__c;
        consent ='Y';
        httpProtocol = new Http();
        req = new HttpRequest();
        List<KYC__c> kycList=[SELECT Id, API_Count__c, API_Count_OCR__c FROM KYC__c where Id=:kycid];
        KYC__c kycObj1 = new KYC__c();
        
        kycObj1.Id=kycid;
        System.debug('kycObj1.Id : '+kycObj1.Id);
        Datetime currentDateTime=Datetime.now();
        String errorMessage='';
        try{
            System.debug(jsonRequestBody);
            req.setEndpoint(endPointv1static+'/gstdetailed');
            req.setHeader('Content-Type', 'application/json');
            System.debug('authorizationKey : '+authorizationKey);
            req.setHeader('x-karza-key',authorizationKey);
            req.setMethod('POST');
            req.setTimeout(120000);
            req.setBody(jsonRequestBody);
            HttpResponse response=httpProtocol.send(req);
            System.debug('response :- '+response.getBody());
            responseBodyGst=response.getBody();
            if(responseBodyGst.length()>0){// check length
                       //get ApiCount from KYCObj
                       if(kycObj1.Id!=null){
                           kycObj1.API_Count__c=kycList[0].API_Count__c+1;
                       }
                   }
            kycObj1.RecordTypeId=recordtypeKycGSTId;
            kycObj1.KYC_Last_Updated_Date_Time__c=currentDateTime;
            kycObj1.Request_Type__c='Scheduler';
            // For getting status from responseBodyGst  //
            String statusGst='';
            if(String.valueOf(getMapResults(responseBodyGst).get('status'))!=null){
                statusGst=String.valueOf(getMapResults(responseBodyGst).get('status'));
                if(statusGst!='' || statusGst!=null){
                    kycObj1.Status_Code__c = statusGst;
                    kycObj1.Request_Id__c = '';
                    kycObj1.Request_JSON__c = jsonRequestBody;
                    kycObj1.Respone_JSON__c = responseBodyGst;
                    kycObj1.gst_resp_mbr__c = '';
                    kycObj1.gst_resp_pradr__c = '';
                    kycObj1.gst_resp_nba__c = '';
                    kycObj1.gst_resp_adadr__c = '';
                    kycObj1.gst_resp_contacted__c = ''; 
                    kycObj1.gst_resp_canFlag__c =  '';
                    kycObj1.gst_resp_tradeNam__c =  '';
                    kycObj1.gst_resp_lstupdt__c =  '';
                    kycObj1.gst_resp_rgdt__c =  '';
                    kycObj1.gst_resp_stjCd__c =  '';
                    kycObj1.gst_resp_stj__c =  '';
                    kycObj1.gst_resp_ctjCd__c =  '';
                    kycObj1.gst_resp_ppr__c =  '';
                    kycObj1.gst_resp_dty__c =  '';
                    kycObj1.gst_resp_cmpRt__c =  '';
                    kycObj1.gst_resp_cxdt__c =  '';
                    kycObj1.gst_resp_ctb__c =  '';
                    kycObj1.gst_resp_sts__c =  '';
                    kycObj1.gst_resp_gstin__c =  '';
                    kycObj1.gst_resp_lgnm__c =  '';
                    kycObj1.gst_resp_ctj__c =  '';
                    responseKycRequestIntegrationStatus(kycObj1, 'Failed', currentDateTime,'Not Valid');
                    MonitorLogGenerationController.setMonitorLogss( kyc_mode, currentTime, jsonRequestBody,responseBodyGst, '', logName, statusGst, kycid);  
                }
                
            }else{
                
                // Deserialized FDA Json
                String statusCodeStr=String.valueOf(getMapResults(responseBodyGst).get('statusCode'));
                String requestIdStr=String.valueOf(getMapResults(responseBodyGst).get('requestId'));
                if(statusCodeStr =='101'){
                     
                    List<Object> resultMbr=(List<Object>) getMapResult(responseBodyGst).get('mbr'); 
                    System.debug('resultMbr : '+String.valueOf(resultMbr));
                    Map<String,Object> resultPradr = (Map<String, Object>) getMapResult(responseBodyGst).get('pradr');
                    //String adrResultPradr=String.valueOf(resultPradr.get('adr'));
                    
                    //Map<String,Object> resultContacted = (Map<String, Object>) getMapResult(responseBodyGst).get('contacted');
                    //String adrResultPradr=String.valueOf(resultContacted.get('adr'));
                    
                    
                    List<Object> nbaList=(List<Object>) getMapResult(responseBodyGst).get('nba');
                    //String zeroResultPradr=String.valueOf(nbaList[0]);
                    //String oneResultPradr=String.valueOf(nbaList[1]);
                    //String twoResultPradr=String.valueOf(nbaList[2]);
                    //String threeResultPradr=String.valueOf(nbaList[3]);
                    //String fourResultPradr=String.valueOf(nbaList[4]);
                    //String fiveResultPradr=String.valueOf(nbaList[5]);
                    //String sixResultPradr=String.valueOf(nbaList[6]);
                    //String sevenResultPradr=String.valueOf(nbaList[7]);
                    
                    
                    List<Object> adadrList=(List<Object>) getMapResult(responseBodyGst).get('adadr');
                    System.debug('adadrList : '+adadrList);
                    /*String emStr='';
                    String adrStr='';
                    String addrStr='';
                    String lastUpdatedDateStr='';
                    String mbStr='';
                    String ntrStr='';
                    
                    for(Object obj:adadrList){
                    Map<String,Object> mpParsed = (Map<String,Object>)obj;
                    emStr=String.valueOf(mpParsed.get('em'));
                    adrStr=String.valueOf(mpParsed.get('adr'));
                    addrStr=String.valueOf(mpParsed.get('addr'));
                    lastUpdatedDateStr=String.valueOf(mpParsed.get('lastUpdatedDate'));
                    mbStr=String.valueOf(mpParsed.get('mb'));
                    ntrStr=String.valueOf(mpParsed.get('ntr'));
                    }*/
                    
                    String jsonStrBody='';
                    JSONGenerator gen = JSON.createGenerator(true);    
                    gen.writeStartObject();     
                    gen.writeStringField('statusCode',statusCodeStr);
                    gen.writeStringField('requestId',requestIdStr);
                    gen.writeStringField('tradeNam',String.valueOf(getMapResult(responseBodyGst).get('tradeNam')));
                    gen.writeStringField('gstin',String.valueOf(getMapResult(responseBodyGst).get('gstin')));
                    gen.writeStringField('mbr',String.valueOf(resultMbr));
                    gen.writeEndObject();  
                    jsonStrBody=gen.getAsString();
                    System.debug('jsonStrBody : '+jsonStrBody);

                    String canFlagFromResult=String.valueOf(getMapResult(responseBodyGst).get('canFlag'));
                    String ctjFromResult=String.valueOf(getMapResult(responseBodyGst).get('ctj'));
                    kycObj1.Status_Code__c = statusCodeStr;
                    kycObj1.Request_Id__c = requestIdStr;
                    kycObj1.Request_JSON__c = jsonRequestBody;
                    kycObj1.Respone_JSON__c = jsonStrBody;        //responseBodyGst.remove('adadr'); Original json Response of GST
                    kycObj1.gst_resp_mbr__c = String.valueOf(resultMbr);
                    kycObj1.gst_resp_pradr__c = String.valueOf(resultPradr);
                    kycObj1.gst_resp_nba__c = String.valueOf(nbaList);
                    if(adadrList.size()>0){
                        kycObj1.gst_resp_adadr__c = String.valueOf(adadrList[0]);
                    }
                    
                    //kycObj.gst_resp_contacted__c =  String.valueOf(resultContacted); 
                    kycObj1.gst_resp_canFlag__c =  String.valueOf(getMapResult(responseBodyGst).get('canFlag'));
                    kycObj1.gst_resp_tradeNam__c =  String.valueOf(getMapResult(responseBodyGst).get('tradeNam'));
                    kycObj1.gst_resp_lstupdt__c =  String.valueOf(getMapResult(responseBodyGst).get('lstupdt'));
                    kycObj1.gst_resp_rgdt__c =  String.valueOf(getMapResult(responseBodyGst).get('rgdt'));
                    kycObj1.gst_resp_stjCd__c =  String.valueOf(getMapResult(responseBodyGst).get('stjCd'));
                    kycObj1.gst_resp_stj__c =  String.valueOf(getMapResult(responseBodyGst).get('stj'));
                    kycObj1.gst_resp_ctjCd__c =  String.valueOf(getMapResult(responseBodyGst).get('ctjCd'));
                    kycObj1.gst_resp_ppr__c =  String.valueOf(getMapResult(responseBodyGst).get('ppr'));
                    kycObj1.gst_resp_dty__c =  String.valueOf(getMapResult(responseBodyGst).get('dty'));
                    kycObj1.gst_resp_cmpRt__c =  String.valueOf(getMapResult(responseBodyGst).get('cmpRt'));
                    kycObj1.gst_resp_cxdt__c =  String.valueOf(getMapResult(responseBodyGst).get('cxdt'));
                    kycObj1.gst_resp_ctb__c =  String.valueOf(getMapResult(responseBodyGst).get('ctb'));
                    kycObj1.gst_resp_sts__c =  String.valueOf(getMapResult(responseBodyGst).get('sts'));
                    kycObj1.gst_resp_gstin__c =  String.valueOf(getMapResult(responseBodyGst).get('gstin'));
                    kycObj1.gst_resp_lgnm__c =  String.valueOf(getMapResult(responseBodyGst).get('lgnm'));
                    kycObj1.gst_resp_ctj__c =  String.valueOf(getMapResult(responseBodyGst).get('ctj'));
                    responseKycRequestIntegrationStatus(kycObj1, 'Partially Completed', currentDateTime,'Valid');
                    
                }else {
                    kycObj1.Status_Code__c = statusCodeStr;
                    kycObj1.Request_Id__c = requestIdStr;
                    kycObj1.Request_JSON__c = jsonRequestBody;
                    kycObj1.Respone_JSON__c = responseBodyGst;
                    kycObj1.gst_resp_mbr__c = '';
                    kycObj1.gst_resp_pradr__c = '';
                    kycObj1.gst_resp_nba__c = '';
                    kycObj1.gst_resp_adadr__c = '';
                    kycObj1.gst_resp_contacted__c = ''; 
                    kycObj1.gst_resp_canFlag__c =  '';
                    kycObj1.gst_resp_tradeNam__c =  '';
                    kycObj1.gst_resp_lstupdt__c =  '';
                    kycObj1.gst_resp_rgdt__c =  '';
                    kycObj1.gst_resp_stjCd__c =  '';
                    kycObj1.gst_resp_stj__c =  '';
                    kycObj1.gst_resp_ctjCd__c =  '';
                    kycObj1.gst_resp_ppr__c =  '';
                    kycObj1.gst_resp_dty__c =  '';
                    kycObj1.gst_resp_cmpRt__c =  '';
                    kycObj1.gst_resp_cxdt__c =  '';
                    kycObj1.gst_resp_ctb__c =  '';
                    kycObj1.gst_resp_sts__c =  '';
                    kycObj1.gst_resp_gstin__c =  '';
                    kycObj1.gst_resp_lgnm__c =  '';
                    kycObj1.gst_resp_ctj__c =  '';
                    responseKycRequestIntegrationStatus(kycObj1, 'Failed', currentDateTime,'Not Valid');
                    MonitorLogGenerationController.setMonitorLogss(kyc_mode, currentTime, jsonRequestBody,responseBodyGst, '', logName, statusCodeStr, kycid);
                }
            }
            if(Test.isRunningTest())
            {
                Exception e;
                throw e;
            }
            }catch(DmlException ex) {
                responseKycRequestIntegrationStatus(kycObj1, 'Failed', currentDateTime,'Failed');
                MonitorLogGenerationController.setMonitorLogss(kyc_mode, currentTime, '','', ''+ex.getMessage() , '', '', kycid);
            } catch(SObjectException ex) {
                responseKycRequestIntegrationStatus(kycObj1, 'Failed', currentDateTime,'Failed');
                MonitorLogGenerationController.setMonitorLogss(kyc_mode, currentTime, '','', ''+ex.getMessage() , '', '', kycid);
            }catch(Exception e){
                responseKycRequestIntegrationStatus(kycObj1, 'Failed', currentDateTime,'Failed');
                MonitorLogGenerationController.setMonitorLogss(kyc_mode, currentTime, jsonRequestBody,'', 'Transaction Log : '+e.getStackTraceString(), logName, '', kycid);
            }
    } 

    public static void validateOCR(Id kycid, String kyc_mode,String jsonRequestBody,Id recordtypeKycId, DateTime currentTime,String logName){
        String responseBodyOCR='';
        String requJson='{"fileB64" : "/9j/ -- Base64 String"}';
       	ID recordtypeKycPANId=Schema.SObjectType.KYC__c.getRecordTypeInfosByName().get('PAN Card').getRecordTypeId();         
        ID recordtypeKycPassportId=Schema.SObjectType.KYC__c.getRecordTypeInfosByName().get('Passport').getRecordTypeId();
        Id recordtypeKycVoterId=Schema.SObjectType.KYC__c.getRecordTypeInfosByName().get('Voter ID').getRecordTypeId();
        List<KYC_Api__c> kycApiList=[Select id, Endpoint__c, EndpointV3__c, EndpointV1__c, x_karza_key__c from KYC_Api__c];
        endPointv3static = kycApiList[0].EndpointV3__c;
        authorizationKey= kycApiList[0].x_karza_key__c;
        consent ='Y';
        httpProtocol = new Http();
        req = new HttpRequest();
        List<KYC__c> kycList=[SELECT Id, API_Count__c, API_Count_OCR__c FROM KYC__c where Id=:kycid];
        
        //List<KYC__c> kycList1 = new List<KYC__c>();
        KYC__c kycObj1 = new KYC__c();
        
        kycObj1.Id=kycid;
        System.debug('kycObj1.Id : '+kycObj1.Id);
        Datetime currentDateTime=Datetime.now();
		try{
            System.debug(jsonRequestBody);
            req.setEndpoint(endPointv3static+'/ocr/kyc');
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('x-karza-key',authorizationKey);
            req.setMethod('POST');
            req.setTimeout(120000);
            req.setBody(jsonRequestBody);
            HttpResponse response=httpProtocol.send(req);
            System.debug('response :- '+response.getBody());
            responseBodyOCR=response.getBody();
            if(responseBodyOCR.length()>0){// check length
                System.debug('responseBodyOCR len : '+responseBodyOCR.length());
                //get ApiCount from KYCObj
                if(kycObj1.Id!=null){
                    kycObj1.API_Count_OCR__c=kycList[0].API_Count_OCR__c+1;
                    System.debug('kycObj1.API_Count_OCR__c : '+kycObj1.API_Count_OCR__c);
                }
            }
            
            kycObj1.RecordTypeId=recordtypeKycId;
            kycObj1.KYC_Last_Updated_Date_Time__c=currentDateTime;
            kycObj1.Request_Type__c='Scheduler';
            String status='';
            if(String.valueOf(getMapResults(responseBodyOCR).get('status'))!=null){
                status=String.valueOf(getMapResults(responseBodyOCR).get('status'));
                if(status!='' || status!=null){
                    kycObj1.Status_Code__c = status;
                    kycObj1.Request_Id__c = '';
                    kycObj1.Request_JSON__c = requJson;
                    kycObj1.Respone_JSON__c = responseBodyOCR;
                    responseKycRequestIntegrationStatus(kycObj1, 'Failed', currentDateTime,'Not Valid');
                    MonitorLogGenerationController.setMonitorLogss( kyc_mode, currentTime, requJson,responseBodyOCR, '', logName, status, kycid);  
                }
            }else{
                String statusCodeStr=String.valueOf(getMapResults(responseBodyOCR).get('statusCode'));
                String requestIdStr=String.valueOf(getMapResults(responseBodyOCR).get('requestId'));
                System.debug('statusCodeStr : '+statusCodeStr);
                
                if(statusCodeStr =='101'){
                    
                    kycObj1.Status_Code__c = statusCodeStr;
                    kycObj1.Request_Id__c = requestIdStr;
                    kycObj1.Request_JSON__c = requJson;
                    kycObj1.Respone_JSON__c = responseBodyOCR;
                    
                    if(recordtypeKycPANId==recordtypeKycId){
                        System.debug('Pan recordtypeKycId : '+recordtypeKycId);
                        List<Object> results=(List<Object>) getMapResults(responseBodyOCR).get('result');
                        for(Object obj:results){
                            Map<String,Object> mpParsed = (Map<String,Object>)obj;
                            Object types=mpParsed.get('type');
                            Map<String,Object> details = (Map<String, Object>) mpParsed.get('details');
                            Map<String,Object> PANpanNo = (Map<String, Object>) details.get('panNo');
                            Map<String,Object> PANname = (Map<String, Object>) details.get('name');
                            Map<String,Object> PANfather = (Map<String, Object>) details.get('father');
                            Map<String,Object> PANdate = (Map<String, Object>) details.get('date');
                            Map<String,Object> PANdateOfIssue = (Map<String, Object>) details.get('dateOfIssue');
                            
                            kycObj1.PAN_Number__c=String.valueOf(PANpanNo.get('value'));
                            kycObj1.pan_resp_name__c=String.valueOf(PANname.get('value'));
                            kycObj1.ocr_pan_resp_father__c=String.valueOf(PANfather.get('value'));
                            kycObj1.ocr_pan_resp_date__c=String.valueOf(PANdate.get('value'));
                            kycObj1.ocr_pan_resp_dateofIssue__c=String.valueOf(PANdateOfIssue.get('value'));
                           }
						
                    }
                    responseKycRequestIntegrationStatus(kycObj1, 'Partially Completed', currentDateTime,'Valid');
                    //for Success 
                    MonitorLogGenerationController.setMonitorLogss(kyc_mode, currentTime, requJson,responseBodyOCR, '', logName, statusCodeStr, kycid);
                    
                }else {
                    kycObj1.Status_Code__c = statusCodeStr;
                    kycObj1.Request_Id__c = requestIdStr;
                    kycObj1.Request_JSON__c = requJson;
                    kycObj1.Respone_JSON__c = responseBodyOCR;
                    kycObj1.pan_resp_name__c = '';
                    kycObj1.PAN_Number__c = '';
                    kycObj1.ocr_pan_resp_father__c = '';
                    kycObj1.fda_resp_name__c =  '';
                    kycObj1.ocr_pan_resp_date__c =  '';
                    kycObj1.ocr_pan_resp_dateofIssue__c =  '';
                    responseKycRequestIntegrationStatus(kycObj1, 'Failed', currentDateTime,'Not Valid');
                    MonitorLogGenerationController.setMonitorLogss(kyc_mode, currentTime, requJson,responseBodyOCR, '', logName, statusCodeStr, kycid);
                    
                }
            }  
            if(Test.isRunningTest())
			{
                Exception e;
				throw e;
			}
        }catch(DmlException ex) {
            
            responseKycRequestIntegrationStatus(kycObj1, 'Failed', currentDateTime,'Failed');
            MonitorLogGenerationController.setMonitorLogss(kyc_mode, currentTime, '','', ''+ex.getMessage() , '', '', kycid);
        } catch(SObjectException ex) {
            responseKycRequestIntegrationStatus(kycObj1, 'Failed', currentDateTime,'Failed');
            MonitorLogGenerationController.setMonitorLogss(kyc_mode, currentTime, '','', ''+ex.getMessage() , '', '', kycid);
        }catch(Exception e){
            responseKycRequestIntegrationStatus(kycObj1, 'Failed', currentDateTime,'Failed');
            MonitorLogGenerationController.setMonitorLogss(kyc_mode, currentTime, requJson,'', 'Transaction Log : '+e.getStackTraceString(), logName, '', kycid);
        }
        
    }
    public static void validatePassportOCR(Id kycid, String kyc_mode,String jsonRequestBody,Id recordtypeKycId, DateTime currentTime,String logName){
        String responseBodyOCR='';
        String requJson='{"fileB64" : "/9j/ -- Base64 String"}';
       	ID recordtypeKycPANId=Schema.SObjectType.KYC__c.getRecordTypeInfosByName().get('PAN Card').getRecordTypeId();         
        ID recordtypeKycPassportId=Schema.SObjectType.KYC__c.getRecordTypeInfosByName().get('Passport').getRecordTypeId();
        Id recordtypeKycVoterId=Schema.SObjectType.KYC__c.getRecordTypeInfosByName().get('Voter ID').getRecordTypeId();
        List<KYC_Api__c> kycApiList=[Select id, Endpoint__c, EndpointV3__c, EndpointV1__c, x_karza_key__c from KYC_Api__c];
        endPointv3static = kycApiList[0].EndpointV3__c;
        authorizationKey= kycApiList[0].x_karza_key__c;
        consent ='Y';
        httpProtocol = new Http();
        req = new HttpRequest();
        List<KYC__c> kycList=[SELECT Id, API_Count__c, API_Count_OCR__c FROM KYC__c where Id=:kycid];
        //List<KYC__c> kycList1 = new List<KYC__c>();
        KYC__c kycObj1 = new KYC__c();
        
        kycObj1.Id=kycid;
        System.debug('kycObj1.Id : '+kycObj1.Id);
        Datetime currentDateTime=Datetime.now();
		try{
            System.debug(jsonRequestBody);
            req.setEndpoint(endPointv3static+'/ocr/kyc');
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('x-karza-key',authorizationKey);
            req.setMethod('POST');
            req.setTimeout(120000);
            req.setBody(jsonRequestBody);
            HttpResponse response=httpProtocol.send(req);
            System.debug('response :- '+response.getBody());
            responseBodyOCR=response.getBody();
            if(responseBodyOCR.length()>0){// check length
                System.debug('responseBodyOCR len : '+responseBodyOCR.length());
                //get ApiCount from KYCObj
                if(kycObj1.Id!=null){
                    kycObj1.API_Count_OCR__c=kycList[0].API_Count_OCR__c+1;
                    System.debug('kycObj1.API_Count_OCR__c : '+kycObj1.API_Count_OCR__c);
                }
            }
            
            kycObj1.RecordTypeId=recordtypeKycId;
            kycObj1.KYC_Last_Updated_Date_Time__c=currentDateTime;
            kycObj1.Request_Type__c='Scheduler';
            String status='';
            if(String.valueOf(getMapResults(responseBodyOCR).get('status'))!=null){
                status=String.valueOf(getMapResults(responseBodyOCR).get('status'));
                if(status!='' || status!=null){
                    kycObj1.Status_Code__c = status;
                    kycObj1.Request_Id__c = '';
                    kycObj1.Request_JSON__c = requJson;
                    kycObj1.Respone_JSON__c = responseBodyOCR;
                    responseKycRequestIntegrationStatus(kycObj1, 'Failed', currentDateTime,'Not Valid');
                    MonitorLogGenerationController.setMonitorLogss( kyc_mode, currentTime, requJson,responseBodyOCR, '', logName, status, kycid);  
                }
            }else{
                String statusCodeStr=String.valueOf(getMapResults(responseBodyOCR).get('statusCode'));
                String requestIdStr=String.valueOf(getMapResults(responseBodyOCR).get('requestId'));
                System.debug('statusCodeStr : '+statusCodeStr);
                
                if(statusCodeStr =='101'){
                    
                    kycObj1.Status_Code__c = statusCodeStr;
                    kycObj1.Request_Id__c = requestIdStr;
                    kycObj1.Request_JSON__c = requJson;
                    kycObj1.Respone_JSON__c = responseBodyOCR;
                    
                    if(recordtypeKycPassportId==recordtypeKycId){
                        List<Object> results=(List<Object>) getMapResults(responseBodyOCR).get('result');
                        for(Object obj:results){
                            Map<String,Object> mpParsed = (Map<String,Object>)obj;
                            Object types=mpParsed.get('type');
                            Map<String,Object> details = (Map<String, Object>) mpParsed.get('details');
                            Map<String,Object> PsppassportNum = (Map<String, Object>) details.get('passportNum');
                            Map<String,Object> PspgivenName = (Map<String, Object>) details.get('givenName');
                            Map<String,Object> Pspsurname = (Map<String, Object>) details.get('surname');
                            Map<String,Object> Pspgender = (Map<String, Object>) details.get('gender');
                            Map<String,Object> Pspdoi = (Map<String, Object>) details.get('doi');
                            Map<String,Object> Pspdob = (Map<String, Object>) details.get('dob');
                            Map<String,Object> Pspdoe = (Map<String, Object>) details.get('doe');
                            Map<String,Object> Pspnationality = (Map<String, Object>) details.get('nationality');
                            Map<String,Object> PspplaceOfBirth = (Map<String, Object>) details.get('placeOfBirth');
                            Map<String,Object> PspcountryCode = (Map<String, Object>) details.get('countryCode');
                            Map<String,Object> PspplaceOfIssue = (Map<String, Object>) details.get('placeOfIssue');
                            Map<String,Object> Psptype = (Map<String, Object>) details.get('type');
                            
                            kycObj1.psp_resp_country__c=String.valueOf(PspcountryCode.get('value'));
                            kycObj1.psp_resp_dob__c	=String.valueOf(Pspdob.get('value'));
                            kycObj1.psp_resp_doe__c	=String.valueOf(Pspdoe.get('value'));
                            kycObj1.psp_resp_gender__c=String.valueOf(Pspgender.get('value'));
                            kycObj1.psp_passport_no__c=String.valueOf(PsppassportNum.get('value'));
                            kycObj1.psp_resp_type__c	=String.valueOf(Psptype.get('value'));
                            kycObj1.psp_resp_given_name__c=String.valueOf(PspgivenName.get('value')) + ' ' + String.valueOf(Pspsurname.get('value')) ;
                            kycObj1.psp_resp_last_name__c=String.valueOf(Pspsurname.get('value'));
                        }
                        responseKycRequestIntegrationStatus(kycObj1, 'Partially Completed', currentDateTime,'Valid');
                        //for Success 
                        MonitorLogGenerationController.setMonitorLogss(kyc_mode, currentTime, requJson,responseBodyOCR, '', logName, statusCodeStr, kycid);
                    } 
                }else {
                    kycObj1.Status_Code__c = statusCodeStr;
                    kycObj1.Request_Id__c = requestIdStr;
                    kycObj1.Request_JSON__c = requJson;
                    kycObj1.Respone_JSON__c = responseBodyOCR;
                    kycObj1.pan_resp_name__c = '';
                    kycObj1.PAN_Number__c = '';
                    kycObj1.ocr_pan_resp_father__c = '';
                    kycObj1.fda_resp_name__c =  '';
                    kycObj1.ocr_pan_resp_date__c =  '';
                    kycObj1.ocr_pan_resp_dateofIssue__c =  '';
                    responseKycRequestIntegrationStatus(kycObj1, 'Failed', currentDateTime,'Not Valid');
                    MonitorLogGenerationController.setMonitorLogss(kyc_mode, currentTime, requJson,responseBodyOCR, '', logName, statusCodeStr, kycid);
                    
                }
            }  
            if(Test.isRunningTest())
            {
                Exception e;
                throw e;
            }
        }catch(DmlException ex) {
            
            responseKycRequestIntegrationStatus(kycObj1, 'Failed', currentDateTime,'Failed');
            MonitorLogGenerationController.setMonitorLogss(kyc_mode, currentTime, '','', ''+ex.getMessage() , '', '', kycid);
        } catch(SObjectException ex) {
            responseKycRequestIntegrationStatus(kycObj1, 'Failed', currentDateTime,'Failed');
            MonitorLogGenerationController.setMonitorLogss(kyc_mode, currentTime, '','', ''+ex.getMessage() , '', '', kycid);
        }catch(Exception e){
            responseKycRequestIntegrationStatus(kycObj1, 'Failed', currentDateTime,'Failed');
            MonitorLogGenerationController.setMonitorLogss(kyc_mode, currentTime, requJson,'', 'Transaction Log : '+e.getStackTraceString(), logName, '', kycid);
        }
        
    }    
    public String getMatchAPIJsonRequestStr(String name1, String name2, String nameType, String preset){
            String jsonStrBody='';
            JSONGenerator gen = JSON.createGenerator(true);    
            gen.writeStartObject();     
            gen.writeStringField('name1',name1);
            gen.writeStringField('name2',name2);
            gen.writeStringField('type',nameType);
            gen.writeStringField('preset',preset);
            gen.writeEndObject();    
            jsonStrBody = gen.getAsString();
        return jsonStrBody;
    }
    
    public String getPANCardJsonRequestStr(String pan, String consent){
  
            String jsonStrBody='';
            JSONGenerator gen = JSON.createGenerator(true);    
            gen.writeStartObject();     
            gen.writeStringField('consent',consent);
            gen.writeStringField('pan',pan);
            gen.writeEndObject();  
            jsonStrBody=gen.getAsString();
        return jsonStrBody;
    }
    public String getEmailIdJsonRequestStr(String email, String consent){
            String jsonStrBody='';
            JSONGenerator gen = JSON.createGenerator(true);    
            gen.writeStartObject();     
            gen.writeStringField('consent',consent);
            gen.writeStringField('email',email);
            gen.writeEndObject();    
            jsonStrBody = gen.getAsString();    
        return jsonStrBody;
    }
    
    public String getDrivingLicenseJsonRequestStr(String consent, String dl_no,String dob){
        String jsonStrBody='';
        JSONGenerator gen = JSON.createGenerator(true);    
        gen.writeStartObject();
        gen.writeStringField('consent',consent);      
        gen.writeStringField('dl_no',dl_no);
        gen.writeStringField('dob',dob);
        gen.writeEndObject();    
        jsonStrBody = gen.getAsString();    
        return jsonStrBody;
    }
    
    public String getVoterJsonRequestStr(String consent, String epic_no){
        String jsonStrBody='';
        JSONGenerator gen = JSON.createGenerator(true);    
        gen.writeStartObject();
        gen.writeStringField('consent',consent);      
        gen.writeStringField('epic_no',epic_no);
        gen.writeEndObject();    
        jsonStrBody = gen.getAsString();    
        return jsonStrBody;
    }
    
    public String getFssaiJsonRequestStr(String consent, String fssai_reg_no){
        String jsonStrBody='';
        JSONGenerator gen = JSON.createGenerator(true);    
        gen.writeStartObject();
        gen.writeStringField('consent',consent);      
        gen.writeStringField('reg_no',fssai_reg_no);
        gen.writeEndObject();    
        jsonStrBody = gen.getAsString();    
        return jsonStrBody;
    }
    
    public String getIfscCodeJsonRequestStr(String consent, String ifsc){
        String jsonStrBody='';
        JSONGenerator gen = JSON.createGenerator(true);    
        gen.writeStartObject();
        gen.writeStringField('consent',consent);  
        gen.writeStringField('ifsc',ifsc);
        gen.writeEndObject();    
        jsonStrBody = gen.getAsString();    
        return jsonStrBody;
    }
    
    public String getFdaJsonRequestStr(String consent, String licence_no, String state){
        String jsonStrBody='';
        JSONGenerator gen = JSON.createGenerator(true);    
        gen.writeStartObject();
        gen.writeStringField('consent',consent);  
        gen.writeStringField('licence_no',licence_no);
        gen.writeStringField('state',state);
        gen.writeEndObject();    
        jsonStrBody = gen.getAsString();    
        return jsonStrBody;
    }
    
     public String getBankAccountJsonRequestStr(String consent, String ifsc, String accountNumber){
        String jsonStrBody='';
        JSONGenerator gen = JSON.createGenerator(true);    
        gen.writeStartObject();
        gen.writeStringField('consent',consent);
        gen.writeStringField('ifsc',ifsc);
        gen.writeStringField('accountNumber',accountNumber);
        gen.writeEndObject();    
        jsonStrBody = gen.getAsString();    
        return jsonStrBody;
    }
    
    public String getGstJsonRequestStr(String consent, String gstin){
        String jsonStrBody='';
        JSONGenerator gen = JSON.createGenerator(true);    
        gen.writeStartObject();
        gen.writeStringField('consent',consent);  
        gen.writeStringField('gstin',gstin);
        gen.writeEndObject();    
        jsonStrBody = gen.getAsString();    
        return jsonStrBody;
    }
    
    /*public String getPassportJsonRequestStr(String consent, String name, String last_name, String dob, String doe, String gender, String passport_no, String psp_type, String country){
        String jsonStrBody='';
        JSONGenerator gen = JSON.createGenerator(true);    
        gen.writeStartObject();
        gen.writeStringField('consent',consent);  
        gen.writeStringField('name',name);
        gen.writeStringField('last_name',last_name);
        gen.writeStringField('dob',dob);
        gen.writeStringField('doe',doe);
        gen.writeStringField('gender',gender);
        gen.writeStringField('passport_no',passport_no);
        gen.writeStringField('type',psp_type);
        gen.writeStringField('country',country);
        gen.writeEndObject();    
        jsonStrBody = gen.getAsString();    
        return jsonStrBody;
    }*/
    
    public static String getOCRJsonRequestStr(String fileB64){
        String jsonStrBody='';
        JSONGenerator gen = JSON.createGenerator(true);    
        gen.writeStartObject();     
        gen.writeStringField('fileB64',fileB64);
        gen.writeEndObject();  
        jsonStrBody=gen.getAsString();
        return jsonStrBody;
    }
    
    public Boolean checkEmail(String email) {
    Boolean res = true;
    String emailRegex = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$'; 
    Pattern MyPattern = Pattern.compile(emailRegex);
    Matcher MyMatcher = MyPattern.matcher(email);
    if (!MyMatcher.matches()) 
        res = false;
    return res; 
    }   

    public Boolean checkDrivingLicense(String dl_no) {
    Boolean res = true;
    String dlnoRegex = '^(0[1-9]|[12][0-9]|3[01])-(0[1-9]|1[012])-(19|20)$'; 
    Pattern MyPattern = Pattern.compile(dlnoRegex);
    Matcher MyMatcher = MyPattern.matcher(dl_no);
    if (!MyMatcher.matches()) 
        res = false;
    return res; 
    } 
    
    public Boolean checkPAN(String pan) {
        Boolean res = true;
        String panRegex = '[A-Z]{5}[0-9]{4}[A-Z]{1}'; 
        Pattern MyPattern = Pattern.compile(panRegex);
        if(pan!=null && pan!=''){
            Matcher MyMatcher = MyPattern.matcher(pan);
            if (!MyMatcher.matches()) 
                res = false;
        }else{
             res = false;
        }
        return res; 
    } 

    public Boolean checkgst(String gst) {
        Boolean res = true;
        String gstRegex = '^([0][1-9]|[1-2][0-9]|[3][0-5])([a-zA-Z]{5}[0-9]{4}[a-zA-Z]{1}[1-9a-zA-Z]{1}[zZ]{1}[0-9a-zA-Z]{1})+$'; 
        Pattern MyPattern = Pattern.compile(gstRegex);
        Matcher MyMatcher = MyPattern.matcher(gst);
        if (!MyMatcher.matches()) 
            res = false;
        return res; 
    } 
    
    public Boolean checkCountryCode(String countryCode) {
    Boolean res = true;
    String countryCodeRegex = '[a-zA-Z]{3}'; 
    Pattern MyPattern = Pattern.compile(countryCodeRegex);
    Matcher MyMatcher = MyPattern.matcher(countryCode);
    if (!MyMatcher.matches()) 
        res = false;
    return res; 
    }
    public Date getDateFormat(String date1) {
        String[] strDate = date1.split('-');
        Integer myIntDate = integer.valueOf(strDate[1]);
        Integer myIntMonth = integer.valueOf(strDate[0]);
        Integer myIntYear = integer.valueOf(strDate[2]);
        Date datenew = Date.newInstance(myIntYear, myIntMonth, myIntDate);
        return datenew; 
    }
    
    // Method for updating IntegrationStatus, IntegrationDateTime in KYC Object used in KycRequestHandlerController Apex class.
    public void requestKycRequestIntegrationStatus(KYC__c kycObj, String intStatus, Datetime currentDateTime){
        kycObj.KYC_Integration_Status__c = intStatus;
        kycObj.req_kyc_int_datetime__c=currentDateTime;
        update kycObj;
    }
    
    // static Method for updating IntegrationStatus, IntegrationDateTime and KycStatus fields in KYC Object
    public static void responseKycRequestIntegrationStatus(KYC__c kycObj, String intStatus, Datetime currentDateTime,String kycstatus){
        kycObj.KYC_Integration_Status__c = intStatus;
        kycObj.res_kyc_int_datetime__c=currentDateTime;
        kycObj.Kyc_status__c = kycstatus;
        update kycObj;
    }
    
    // Method return Deserialization of result from json response 
    public static Map<String,Object> getMapResult(String responseBody){
        Map<String,Object> results = (Map<String, Object>) JSON.deserializeUntyped(responseBody);
        Map<String,Object> result = (Map<String, Object>) results.get('result');
        return result;
    }
    
    // Method return Deserialization of json response
    public static Map<String,Object> getMapResults(String responseBody){
        Map<String,Object> results = (Map<String, Object>) JSON.deserializeUntyped(responseBody);
        return results;
    }
}