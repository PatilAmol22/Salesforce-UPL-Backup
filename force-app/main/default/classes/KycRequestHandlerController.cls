/*
* Name: KycRequestHandlerController
* Created On: 9 May 2019 
* Author: Azhar Shaikh
* Description: Class is used for hadling errors, parsing JSON Response and updating kyc Object for all api parameters And it is invoking from Batch class.
*/
public without sharing class KycRequestHandlerController {
    String logName ='';
    String errorMessage='';
    Id recordtypeKycEmailId;
    Id recordtypeKycPANId;
    Id recordtypeKycBankAccountId;
    Id recordtypeKycIfscCodeId;
    Id recordtypeKycPassportId;
    Id recordtypeKycVoterId;
    Id recordtypeKycFDAId;
    Id recordtypeKycGSTId;
    Id recordtypeKycDrivingLicenseId;
    Id recordtypeKycFSSAIId;
    DateTime currentTime;
    String jsonRequestBody='';
    String conStr='';
    
    // Apex Controller Object
    MonitorLogGenerationController monitorLogObj;
    KYCApiIntegrationController kycApiObj;
    
    //Response Object 
    Object statusCode='';
    Object requestId='';
    
    //String of objects
    String statusCodeStr='';
    String requestIdStr='';
    
    public KycRequestHandlerController(){
        recordtypeKycEmailId=Schema.SObjectType.KYC__c.getRecordTypeInfosByName().get('Email').getRecordTypeId();
        //recordtypeKycPANId=Schema.getGlobalDescribe().get('KYC__c').getDescribe().getRecordTypeInfosByName().get('PAN_Card').getRecordTypeId();
        recordtypeKycPANId=Schema.SObjectType.KYC__c.getRecordTypeInfosByName().get('PAN Card').getRecordTypeId();         
        recordtypeKycBankAccountId=Schema.SObjectType.KYC__c.getRecordTypeInfosByName().get('Bank Account').getRecordTypeId();
        System.debug('recordtypeKycBankAccountId : '+recordtypeKycBankAccountId);
        recordtypeKycPassportId=Schema.SObjectType.KYC__c.getRecordTypeInfosByName().get('Passport').getRecordTypeId();
        recordtypeKycVoterId=Schema.SObjectType.KYC__c.getRecordTypeInfosByName().get('Voter ID').getRecordTypeId();
        recordtypeKycFDAId=Schema.SObjectType.KYC__c.getRecordTypeInfosByName().get('FDA').getRecordTypeId();
        recordtypeKycGSTId=Schema.SObjectType.KYC__c.getRecordTypeInfosByName().get('Gst').getRecordTypeId();
        recordtypeKycDrivingLicenseId=Schema.SObjectType.KYC__c.getRecordTypeInfosByName().get('Driving License').getRecordTypeId();
        recordtypeKycFSSAIId=Schema.SObjectType.KYC__c.getRecordTypeInfosByName().get('FSSAI').getRecordTypeId();
        
        monitorLogObj= new MonitorLogGenerationController();
        kycApiObj = new KYCApiIntegrationController();
        currentTime = Datetime.now();
    }
    
    public String putKycRequestHandler(String type_of_validation, KYC__c kycObj, String kyc_mode){
        
        String returnStr='';
        try{
            if(type_of_validation=='PAN Card'){
                
                logName='PAN Card Number';
                //System.debug('kycObj.PAN_Number__c : '+kycObj.PAN_Number__c );
                if(kycObj.Consent__c!=true){
                    errorMessage = 'ErrorLog Pan Card: Consent is NO';
                    MonitorLogGenerationController.setMonitorLogss( kyc_mode, currentTime, '','', errorMessage, logName, '', kycObj.Id);
                    
                }else if(kycApiObj.checkPAN(kycObj.PAN_Number__c)==false || kycObj.PAN_Number__c ==null || kycObj.PAN_Number__c.trim().length()!=10){ 
                    errorMessage ='ErrrLog Pan Card: Pan Number is invalid';
                    MonitorLogGenerationController.setMonitorLogss(kyc_mode, currentTime, '','', errorMessage, logName, '', kycObj.Id);
                    
                }else{
                    System.debug(' else condition2 ');
                    conStr = 'Y';
                    jsonRequestBody = kycApiObj.getPANCardJsonRequestStr(kycObj.PAN_Number__c,conStr);
                    KYCApiIntegrationController.validatePan(kycObj.Id,kyc_mode,jsonRequestBody,recordtypeKycPANId,currentTime,logName);  
                    returnStr = 'Success'; 
                } 
                
            }  
            
            if(type_of_validation=='Email'){
                logName='Email Id';
                
                if(kycObj.Consent__c!=true){
                    errorMessage = 'ErrorLog Email ID: Consent is NO';
                    MonitorLogGenerationController.setMonitorLogss( kyc_mode, currentTime, '','', errorMessage, logName, '', kycObj.Id);
                }else if(kycApiObj.checkEmail(kycObj.Email_ID__c)==false || kycObj.Email_ID__c==null || kycObj.Email_ID__c =='' || kycObj.Email_ID__c.length()<0 ){ 
                    errorMessage ='ErrrLog Email ID: Email is invalid';
                    MonitorLogGenerationController.setMonitorLogss(kyc_mode, currentTime, '','', errorMessage, logName, '', kycObj.Id);
                }else{
                    conStr = 'Y';
                    jsonRequestBody = kycApiObj.getEmailIdJsonRequestStr(kycObj.Email_ID__c,conStr);
                    KYCApiIntegrationController.validateEmail(kycObj.Id,kyc_mode,jsonRequestBody,currentTime,logName);
                    returnStr = 'Success'; 
                }
            }  
            
            if(type_of_validation=='Driving License'){
                logName='Driving License';
                
                if(kycObj.Consent__c!=true){
                    errorMessage = 'ErrorLog Driving License: Consent is NO';
                    MonitorLogGenerationController.setMonitorLogss( kyc_mode, currentTime, '','', errorMessage, logName, '', kycObj.Id);
                }else if(kycObj.dl_no__c =='' || kycObj.dl_no__c==null || (kycApiObj.checkDrivingLicense(kycObj.dl_no__c)==false && kycObj.dl_no__c.length()<5)){ 
                    errorMessage ='ErrrLog Driving License: Driving License Number is invalid';
                    MonitorLogGenerationController.setMonitorLogss(kyc_mode, currentTime, '','', errorMessage, logName, '', kycObj.Id);
                }else if(kycObj.DOB__c ==null){ 
                    errorMessage ='ErrrLog Driving License: DOB is invalid';
                    MonitorLogGenerationController.setMonitorLogss(kyc_mode, currentTime, '','', errorMessage, logName, '', kycObj.Id);
                }else{
                    DateTime dob=kycObj.DOB__c;//kycObj.dl_dob__c;
                    String dateOutput = dob.format('dd-MM-yyyy'); 
                    conStr = 'Y';
                    jsonRequestBody = kycApiObj.getDrivingLicenseJsonRequestStr(conStr,kycObj.dl_no__c,dateOutput);
                    KYCApiIntegrationController.validateDriverLicense(kycObj.Id,kyc_mode,jsonRequestBody,recordtypeKycDrivingLicenseId,currentTime,logName);// calling integration method for validation ....
                    returnStr = 'Success'; 
                }
            }  
            
            if(type_of_validation=='Voter ID'){
                logName='Voter ID';
                
                if(kycObj.Consent__c!=true){
                    errorMessage = 'ErrorLog Voter: Consent is NO';
                    MonitorLogGenerationController.setMonitorLogss( kyc_mode, currentTime, '','', errorMessage, logName, '', kycObj.Id);
                }else if(kycObj.vi_req_epic_no__c =='' || kycObj.vi_req_epic_no__c==null || (kycObj.vi_req_epic_no__c.length()<10 || kycObj.vi_req_epic_no__c.length()>23)){ 
                    errorMessage ='ErrorLog Voter: Epic no is invalid';
                    MonitorLogGenerationController.setMonitorLogss(kyc_mode, currentTime, '','', errorMessage, logName, '', kycObj.Id);
                }else{
                    conStr = 'Y';  
                    jsonRequestBody = kycApiObj.getVoterJsonRequestStr(conStr,kycObj.vi_req_epic_no__c);
                    KYCApiIntegrationController.validateVoterId(kycObj.Id,kyc_mode,jsonRequestBody,recordtypeKycVoterId,currentTime,logName);
                    returnStr = 'Success';  
                }
                
            }   
            
            if(type_of_validation=='FSSAI'){
                logName='FSSAI';
                
                if(kycObj.Consent__c!=true){
                    errorMessage = 'ErrorLog FSSAI: Consent is NO';
                    monitorLogObj.setMonitorLog( kyc_mode, currentTime, '','', errorMessage, logName, '', kycObj.Id);
                }else if(kycObj.fssai_reg_no__c =='' || kycObj.fssai_reg_no__c==null || kycObj.fssai_reg_no__c.length()!=14){ 
                    errorMessage ='ErrorLog FSSAI: FSSAI Reg no is invalid';
                    monitorLogObj.setMonitorLog(kyc_mode, currentTime, '','', errorMessage, logName, '', kycObj.Id);
                }else{
                    conStr = 'Y';
                    jsonRequestBody = kycApiObj.getFssaiJsonRequestStr(conStr,kycObj.fssai_reg_no__c);
                    System.debug('jsonRequestBody : '+jsonRequestBody);
                    //kycApiObj.requestKycRequestIntegrationStatus(kycObj, 'In Progress',currentTime);
                    KYCApiIntegrationController.validateFssai(kycObj.Id,kyc_mode,jsonRequestBody,recordtypeKycFSSAIId,currentTime,logName);
                    returnStr = 'Success'; 
                }
            }   
            
            if(type_of_validation=='Bank Account'){
                logName='Bank Account';
                
                if(kycObj.Consent__c!=true){
                    errorMessage = 'ErrorLog Bank Account: Consent is NO';
                    monitorLogObj.setMonitorLog( kyc_mode, currentTime, '','', errorMessage, logName, '', kycObj.Id);
                }else if(kycObj.ban_ifsc__c =='' || kycObj.ban_ifsc__c==null){ 
                    errorMessage ='ErrorLog Bank Account: Ifsc code is invalid';
                    monitorLogObj.setMonitorLog(kyc_mode, currentTime, '','', errorMessage, logName, '', kycObj.Id);
                    
                }else if(kycObj.ban_account_number__c =='' || kycObj.ban_account_number__c==null){ 
                    errorMessage ='ErrorLog Bank Account: Bank Account is invalid';
                    monitorLogObj.setMonitorLog(kyc_mode, currentTime, '','', errorMessage, logName, '', kycObj.Id);
                }else{
                    conStr = 'Y';
                    jsonRequestBody = kycApiObj.getBankAccountJsonRequestStr(conStr,kycObj.ban_ifsc__c, String.valueOf(kycObj.ban_account_number__c));
                    System.debug('jsonRequestBody : '+jsonRequestBody);
                    KYCApiIntegrationController.validateBankAccount(kycObj.Id,kyc_mode,jsonRequestBody,recordtypeKycBankAccountId,currentTime,logName);// calling integration method for validation ....
                    returnStr = 'Success';    
                }
                
            }  
            
            if(type_of_validation=='FDA'){
                logName='FDA';
                
                if(kycObj.Consent__c!=true){
                    errorMessage = 'ErrorLog FDA: Consent is NO';
                    monitorLogObj.setMonitorLog( kyc_mode, currentTime, '','', errorMessage, logName, '', kycObj.Id);
                    
                }else if(kycObj.fda_licence_no__c =='' || kycObj.fda_licence_no__c==null){ 
                    errorMessage ='ErrorLog FDA: License no is invalid';
                    monitorLogObj.setMonitorLog(kyc_mode, currentTime, '','', errorMessage, logName, '', kycObj.Id);
                }else if(kycObj.fda_state__c =='' || kycObj.fda_state__c==null){ 
                    errorMessage ='ErrorLog FDA: State is invalid';
                    monitorLogObj.setMonitorLog(kyc_mode, currentTime, '','', errorMessage, logName, '', kycObj.Id);
                }else{
                    conStr = 'Y';
                    jsonRequestBody = kycApiObj.getFdaJsonRequestStr(conStr,kycObj.fda_licence_no__c, kycObj.fda_state__c);
                    System.debug('jsonRequestBody : '+jsonRequestBody);
                    KYCApiIntegrationController.validateFda(kycObj.Id,kyc_mode,jsonRequestBody,recordtypeKycFDAId,currentTime,logName);
                    returnStr = 'Success';    
                }
            }  
            
            if(type_of_validation=='Gst'){
                logName='Gst';
                
                if(kycObj.Consent__c!=true){
                    errorMessage = 'ErrorLog GST: Consent is NO';
                    monitorLogObj.setMonitorLog( kyc_mode, currentTime, '','', errorMessage, logName, '', kycObj.Id);
                    
                }else if(kycObj.gst_gstin__c =='' || kycObj.gst_gstin__c==null || (kycApiObj.checkgst(kycObj.gst_gstin__c)==false && kycObj.gst_gstin__c.length()!=15)){ 
                    errorMessage ='ErrorLog GST: Gst no is invalid';
                    monitorLogObj.setMonitorLog(kyc_mode, currentTime, '','', errorMessage, logName, '', kycObj.Id);
                    
                }else{
                    conStr = 'Y';
                    jsonRequestBody = kycApiObj.getGstJsonRequestStr(conStr,kycObj.gst_gstin__c);
                    System.debug('jsonRequestBody : '+jsonRequestBody);
                    KYCApiIntegrationController.validateGst(kycObj.Id,kyc_mode,jsonRequestBody,recordtypeKycGSTId,currentTime,logName);// calling integration method for validation ....
                    returnStr = 'Success';  
                }
                
            }
            
            if(type_of_validation=='Passport'){
                logName='Passport';
                List<ContentDocumentLink> contentDocumentLinkObj= new List<ContentDocumentLink>();
                contentDocumentLinkObj =[SELECT ContentDocumentId, ContentDocument.Title FROM ContentDocumentLink WHERE LinkedEntityId=:kycObj.Id ORDER BY SystemModstamp Desc Limit 1];
                if(contentDocumentLinkObj.size()>0){
                    System.debug('Inside Passport contentDocumentLinkObj');
                    ContentVersion contentversionObj=[SELECT VersionData FROM ContentVersion WHERE ContentDocumentId =:contentDocumentLinkObj[0].ContentDocumentId];
                    //System.debug('data : '+EncodingUtil.Base64Encode(contentversionObj.VersionData));
                    String base64Str=EncodingUtil.Base64Encode(contentversionObj.VersionData);
                    jsonRequestBody = KYCApiIntegrationController.getOCRJsonRequestStr(base64Str);
                    KYCApiIntegrationController.validatePassportOCR(kycObj.Id,kyc_mode,jsonRequestBody,recordtypeKycPassportId,currentTime,logName);  
                    returnStr = 'Success';  
                } 
            } 
            
            
        } catch(DmlException ex) {
            monitorLogObj.setMonitorLog(kyc_mode, currentTime, '','', ''+ex.getMessage() , '', '', kycObj.Id);
            returnStr='Exception Occured : Error';
        } catch(SObjectException ex) {
            monitorLogObj.setMonitorLog(kyc_mode, currentTime, '','', ''+ex.getMessage() , '', '', kycObj.Id);
            returnStr='Exception Occured : Error';
        } catch(Exception ex){
            monitorLogObj.setMonitorLog(kyc_mode, currentTime, '','', ''+ex.getStackTraceString() , '', '', kycObj.Id);
            returnStr='Exception Occured : Error';
        }
        
        return returnStr;
    }
}