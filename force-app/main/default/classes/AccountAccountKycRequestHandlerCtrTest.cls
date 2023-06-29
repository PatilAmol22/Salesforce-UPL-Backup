@isTest
public class AccountAccountKycRequestHandlerCtrTest {
 @testSetup
    static void allDataForThisClass(){
        Id recordtypeKycEmailId=Schema.SObjectType.KYC__c.getRecordTypeInfosByName().get('Email').getRecordTypeId();
        Id recordtypeKycPANId=Schema.SObjectType.KYC__c.getRecordTypeInfosByName().get('PAN Card').getRecordTypeId();         
        Id recordtypeKycBankAccountId=Schema.SObjectType.KYC__c.getRecordTypeInfosByName().get('Bank Account').getRecordTypeId();
        Id recordtypeKycPassportId=Schema.SObjectType.KYC__c.getRecordTypeInfosByName().get('Passport').getRecordTypeId();
        Id recordtypeKycVoterId=Schema.SObjectType.KYC__c.getRecordTypeInfosByName().get('Voter ID').getRecordTypeId();
        Id recordtypeKycFDAId=Schema.SObjectType.KYC__c.getRecordTypeInfosByName().get('FDA').getRecordTypeId();
        Id recordtypeKycGSTId=Schema.SObjectType.KYC__c.getRecordTypeInfosByName().get('Gst').getRecordTypeId();
        Id recordtypeKycDrivingLicenseId=Schema.SObjectType.KYC__c.getRecordTypeInfosByName().get('Driving License').getRecordTypeId();
        Id recordtypeKycFSSAIId=Schema.SObjectType.KYC__c.getRecordTypeInfosByName().get('FSSAI').getRecordTypeId();
        
        
        Sales_Org__c salesOrg= new Sales_Org__c();
        salesorg.Name='India';
        salesorg.Description__c='India';
        salesorg.Sales_Org_Code__c='1000';
        insert salesorg;
        
        Account acnt= new Account();
        acnt.Name = 'Azhar skinternational';
        acnt.Email__c='azhar.shaikh@skinternational.com';
        acnt.BillingCity ='Pune';
        acnt.BillingCountry='India';
        acnt.Mobile__c='9867341712';
        acnt.Phone='020256580';
        acnt.Sales_Org__c=salesOrg.Id;
        acnt.SAP_Code__c='SAP123456';
        insert acnt;
        
        KYC__c kycObj=new KYC__c();
        kycObj.Name = 'PAN Card';                                                                                                                           // KYC Name
        kycObj.Account__c = acnt.Id;                                                                                                                // Account
        kycObj.RecordTypeId = recordtypeKycPANId;                                                                                                                   // Record Type
        kycObj.Kyc_status__c = 'Not Done';                                                                                                                    // Kyc status
        kycObj.Consent__c = true;                                                                                                                             // Consent
        kycObj.Confidence_score__c = 28;                                                                                                                     // Confidence score
        kycObj.API_Count__c = 4;                                                                                                                            // API Count (KYC)
        kycObj.API_Count_Name__c = 1;                                                                                                                       // API Count (Name)
        kycObj.API_Count_OCR__c = 2;                                                                                                                        // API Count (OCR)
        kycObj.ma_type__c = 'individual';                                                                                                                     // ma type
        kycObj.ma_preset__c = 'L';                                                                                                                            // ma preset
        kycObj.Request_JSON__c = '{  "consent" : "Y",  "pan" : "AHGPA32366"}';                                                                                // Request JSON
        kycObj.Respone_JSON__c = '{"result": {"name": "Vishal Shah"}, "request_id": "cfbc9c5a-7d54-11e9-af9a-0d46037c45a7", "status-code": "101"}';  // Respone JSON
        kycObj.Status_Code__c = '101';                                                                                                                        // Status Code
        kycObj.Request_Id__c = 'cfbc9c5a-7d54-11e9-af9a-0d46037c45a7';                                                                                        // Request Id
        kycObj.req_kyc_int_datetime__c = System.now();                                                                            // req kyc int datetime
        kycObj.res_kyc_int_datetime__c = System.now();                                                                            // res kyc int datetime
        kycObj.KYC_Integration_Status__c = 'Partially Completed';                                                                                             // KYC Integration Status
        kycObj.First_Name__c = 'Shikha';                                                                                                                      // First Name
        kycObj.Last_Name__c = 'Sharma';                                                                                                                       // Last Name
        kycObj.DOB__c =  Date.newInstance(1990, 12, 9);                                                                                                          // DOB
        kycObj.PAN_Number__c = 'AHGPA32366';                                                                                                                  // PAN Number
        kycObj.pan_resp_name__c = 'Vishal Shah';                                                                                                     // pan resp name
        kycObj.email_resp_accept_all__c = false;                                                                                                              // email resp accept all
        kycObj.email_resp_regexp__c = false;                                                                                                                  // email resp regexp
        kycObj.email_resp_disposable__c = false;                                                                                                              // email resp disposable
        kycObj.email_resp_result__c = false;                                                                                                                  // email resp result
        kycObj.email_resp_smtp_check__c = false;                                                                                                              // email resp smtp check
        kycObj.email_resp_mx_records__c = false;                                                                                                              // email resp mx records
        kycObj.email_resp_webmail__c = false;
        insert kycObj;
        
        
        KYC__c kycOb3=new KYC__c();
        kycOb3.Name = 'PAN Card3';                                                                                                                           // KYC Name
        kycOb3.Account__c = acnt.Id;  
        kycOb3.Consent__c = false;  // Account
        kycOb3.PAN_Number__c = '';
        kycOb3.RecordTypeId = recordtypeKycPANId;
        insert kycOb3;
        
        KYC__c kycOb311=new KYC__c();
        kycOb311.Name = 'PAN Card4';                                                                                                                           // KYC Name
        kycOb311.Account__c = acnt.Id;  
        kycOb311.Consent__c = true;  // Account
        kycOb311.PAN_Number__c = '';
        kycOb311.RecordTypeId = recordtypeKycPANId;
        insert kycOb311;
        
        KYC__c kycObj28=new KYC__c();
        kycObj28.Name = 'PAN OCR';                                                                                                                           // KYC Name
        kycObj28.Account__c = acnt.Id;  
        kycOb311.PAN_Number__c = '';
        kycObj28.RecordTypeId = recordtypeKycPANId;
        insert kycObj28;
        
        KYC__c kycOb4=new KYC__c();
        kycOb4.Name = 'Email';                                                                                                                           // KYC Name
        kycOb4.Account__c = acnt.Id;  
        kycOb4.Consent__c = true;  // Account
        kycOb4.Email_ID__c='azhar.shaikh@skinternational.com';
        kycOb4.RecordTypeId = recordtypeKycEmailId;
        insert kycOb4;
        
        KYC__c kycOb5=new KYC__c();
        kycOb5.Name = 'Driving License';                                                                                                                           // KYC Name
        kycOb5.Account__c = acnt.Id;  
        kycOb5.Consent__c = true;  // Account
        kycOb5.dl_no__c='MH27 20160022933';
        kycOb5.DOB__c=Date.newInstance(1992, 12, 9);
        kycOb5.RecordTypeId = recordtypeKycDrivingLicenseId;
        insert kycOb5;
        
        KYC__c kycOb6=new KYC__c();
        kycOb6.Name = 'Voter ID';                                                                                                                           // KYC Name
        kycOb6.Account__c = acnt.Id;  
        kycOb6.Consent__c = true;  // Account
        kycOb6.vi_req_epic_no__c='SIQ3830379';
        kycOb6.RecordTypeId = recordtypeKycVoterId;
        insert kycOb6;
        
        KYC__c kycOb7=new KYC__c();
        kycOb7.Name = 'FDA';                                                                                                                           // KYC Name
        kycOb7.Account__c = acnt.Id;  
        kycOb7.Consent__c = true;  // Account
        kycOb7.fda_licence_no__c='75202';
        kycOb7.fda_state__c='GJ';
        kycOb7.RecordTypeId = recordtypeKycFDAId;
        insert kycOb7;
        
        KYC__c kycOb8=new KYC__c();
        kycOb8.Name = 'Gst';                                                                                                                           // KYC Name
        kycOb8.Account__c = acnt.Id;  
        kycOb8.Consent__c = true;  // Account
        kycOb8.gst_gstin__c='29AAAAA1234F2Z5';
        kycOb8.RecordTypeId = recordtypeKycGSTId;
        insert kycOb8;
        
        KYC__c kycOb9=new KYC__c();
        kycOb9.Name = 'Passport';                                                                                                                           // KYC Name
        kycOb9.Account__c = acnt.Id;  
        kycOb9.Consent__c = true;  // Account
        /*kycOb9.psp_name__c='OMKAR MILIND';
        kycOb9.psp_last_name__c='SHIRHATTI';
        kycOb9.psp_country__c='IND';
        kycOb9.psp_doe__c='10/07/2030';
        kycOb9.psp_dob__c='10/07/2015';
        kycOb9.psp_gender__c='M';
        kycOb9.psp_passport_no__c='12345678887';
        kycOb9.psp_type__c='P';*/
        kycOb9.DOB__c=Date.newInstance(1992, 12, 9);
        kycOb9.RecordTypeId = recordtypeKycPassportId;
        insert kycOb9;
        
        KYC__c kycOb10=new KYC__c();
        kycOb10.Name = 'FSSAI';                                                                                                                           // KYC Name
        kycOb10.Account__c = acnt.Id;  
        kycOb10.Consent__c = true;  // Account
        kycOb10.fssai_reg_no__c='10013022002245';
        kycOb10.RecordTypeId = recordtypeKycFSSAIId;
        insert kycOb10;
        
        KYC__c kycOb11=new KYC__c();
        kycOb11.Name = 'Bank Account';                                                                                                                           // KYC Name
        kycOb11.Account__c = acnt.Id;  
        kycOb11.Consent__c = true;  // Account
        kycOb11.ban_ifsc__c='PUNB0494200';
        kycOb11.ban_account_number__c='4942002100000013';
        kycOb11.RecordTypeId = recordtypeKycBankAccountId;
        insert kycOb11;
        
        KYC__c kycObj12=new KYC__c();
        kycObj12.Name = 'Passport2';                                                                                                                           // KYC Name
        kycObj12.Account__c = acnt.Id;                                                                                                                // Account
        /*kycObj12.psp_name__c='OMKAR MILIND1';
        kycObj12.psp_last_name__c='SHIRHATTI1';
        kycObj12.psp_country__c='IND';
        kycObj12.psp_doe__c='10/07/2030';
        kycObj12.psp_dob__c='10/07/2015';
        kycObj12.psp_gender__c='M';
        kycObj12.psp_passport_no__c='12345678888';
        kycObj12.psp_type__c='P';*/
        kycObj12.DOB__c=Date.newInstance(1992, 12, 9);
        kycObj12.RecordTypeId = recordtypeKycPassportId;
        insert kycObj12;
        
        
        
        KYC__c kycOb13=new KYC__c();
        kycOb13.Name = 'VoterId2';                                                                                                                           // KYC Name
        kycOb13.Account__c = acnt.Id;  
        kycOb13.Consent__c = true;  // Account
        kycOb13.vi_req_epic_no__c='SIQ3830379';
        kycOb13.RecordTypeId = recordtypeKycVoterId;
        insert kycOb13;
        
        //Email inset consent
        KYC__c kycOb14=new KYC__c();
        kycOb14.Name = 'Email1';                                                                                                                           // KYC Name
        kycOb14.Account__c = acnt.Id;  
        kycOb14.Consent__c = false;  // Account
        kycOb14.Email_ID__c='';
        kycOb14.RecordTypeId = recordtypeKycEmailId;
        insert kycOb14;
        //Email insert emailid
        KYC__c kycOb15=new KYC__c();
        kycOb15.Name = 'Email2';                                                                                                                           // KYC Name
        kycOb15.Account__c = acnt.Id;  
        kycOb15.Consent__c = true;  // Account
        kycOb15.Email_ID__c='azhar.shaikh@skinternational.com';
        kycOb15.RecordTypeId = recordtypeKycEmailId;
        insert kycOb15;
    
        //Driving License
        KYC__c kycOb16=new KYC__c();
        kycOb16.Name = 'DrivingLicense1';                                                                                                                           // KYC Name
        kycOb16.Account__c = acnt.Id;  
        kycOb16.Consent__c = false;  // Account
        kycOb16.dl_no__c='';
        kycOb16.RecordTypeId = recordtypeKycDrivingLicenseId;
        insert kycOb16;
        //Driving License
        KYC__c kycOb17=new KYC__c();
        kycOb17.Name = 'DrivingLicense2';                                                                                                                           // KYC Name
        kycOb17.Account__c = acnt.Id;  
        kycOb17.Consent__c = true;  // Account
        kycOb17.dl_no__c='';
        kycOb17.RecordTypeId = recordtypeKycDrivingLicenseId;
        insert kycOb17;
        //Driving License
        KYC__c kycOb18=new KYC__c();
        kycOb18.Name = 'DrivingLicense3';                                                                                                                           // KYC Name
        kycOb18.Account__c = acnt.Id;  
        kycOb18.Consent__c = true;  // Account
        kycOb18.dl_no__c='';
        kycOb18.DOB__c=Date.today();
        kycOb18.RecordTypeId = recordtypeKycDrivingLicenseId;
        insert kycOb18;
        
        //insert consent in VoterID 
        KYC__c kycOb19=new KYC__c();
        kycOb19.Name = 'VoterId';                                                                                                                           // KYC Name
        kycOb19.Account__c = acnt.Id;  
        kycOb19.Consent__c = false;  // Account
        kycOb19.vi_req_epic_no__c='';
        kycOb19.RecordTypeId = recordtypeKycVoterId;
        insert kycOb19;
        //insert epic no in VoterID 
        KYC__c kycOb20=new KYC__c();
        kycOb20.Name = 'VoterId3';                                                                                                                           // KYC Name
        kycOb20.Account__c = acnt.Id;  
        kycOb20.Consent__c = true;  // Account
        kycOb20.vi_req_epic_no__c='';
        kycOb20.RecordTypeId = recordtypeKycVoterId;
        insert kycOb20;
        
        //insert consent in FSSAI 
        KYC__c kycOb21=new KYC__c();
        kycOb21.Name = 'FSSAI1';                                                                                                                           // KYC Name
        kycOb21.Account__c = acnt.Id;  
        kycOb21.Consent__c = false;  // Account
        kycOb21.fssai_reg_no__c='';
        kycOb21.RecordTypeId = recordtypeKycFSSAIId;
        insert kycOb21;
        //insert fssai_reg_no__c in FSSAI 
        KYC__c kycOb22=new KYC__c();
        kycOb22.Name = 'FSSAI2';                                                                                                                           // KYC Name
        kycOb22.Account__c = acnt.Id;  
        kycOb22.Consent__c = true;  // Account
        kycOb22.fssai_reg_no__c='';
        kycOb22.RecordTypeId = recordtypeKycFSSAIId;
        insert kycOb22;
        
        //insert consent in Gst 
        KYC__c kycOb23=new KYC__c();
        kycOb23.Name = 'Gst1';                                                                                                                           // KYC Name
        kycOb23.Account__c = acnt.Id;  
        kycOb23.Consent__c = false;  // Account
        kycOb23.gst_gstin__c='';
        kycOb23.RecordTypeId = recordtypeKycGSTId;
        insert kycOb23;
        //insert gst_gstin__c in Gst 
        KYC__c kycOb24=new KYC__c();
        kycOb24.Name = 'Gst2';                                                                                                                           // KYC Name
        kycOb24.Account__c = acnt.Id;  
        kycOb24.Consent__c = true;  // Account
        kycOb24.gst_gstin__c='';
        kycOb24.RecordTypeId = recordtypeKycGSTId;
        insert kycOb24;

    //FDA
        KYC__c kycOb25=new KYC__c();
        kycOb25.Name = 'FDA1';                                                                                                                           // KYC Name
        kycOb25.Account__c = acnt.Id;  
        kycOb25.Consent__c = false;  // Account
        kycOb25.fda_licence_no__c='';
        kycOb25.fda_state__c='';
        kycOb25.RecordTypeId = recordtypeKycFDAId;
        insert kycOb25;
        //FDA
        KYC__c kycOb26=new KYC__c();
        kycOb26.Name = 'FDA2';                                                                                                                           // KYC Name
        kycOb26.Account__c = acnt.Id;  
        kycOb26.Consent__c = true;  // Account
        kycOb26.fda_licence_no__c='';
        kycOb26.fda_state__c='';
        kycOb26.RecordTypeId = recordtypeKycFDAId;
        insert kycOb26;
        //FDA
        KYC__c kycOb27=new KYC__c();
        kycOb27.Name = 'FDA3';                                                                                                                           // KYC Name
        kycOb27.Account__c = acnt.Id;  
        kycOb27.Consent__c = true;  // Account
        kycOb27.fda_licence_no__c='';
        kycOb26.fda_state__c='';
        kycOb27.RecordTypeId = recordtypeKycFDAId;
        insert kycOb27;  
        
       
        
        KYC_Api__c kycapiObj= new KYC_Api__c();
        kycapiObj.Endpoint__c='https://testapi.karza.in/v2';
        kycapiObj.EndpointV3__c='https://testapi.karza.in/v3';
        kycapiObj.EndpointV1__c='https://gst.karza.in/uat/v1';
        kycapiObj.x_karza_key__c='l0fiz30qr2yCx35ABS6F';
        insert kycapiObj;
        
        Blob beforeblob=Blob.valueOf('Unit Test Attachment Body');
    ContentVersion cv = new ContentVersion();
        cv.title = 'test content trigger';      
        cv.PathOnClient ='test';           
        cv.VersionData =beforeblob;          
        insert cv;
        
        Blob beforeblob2=Blob.valueOf('Unit Test Attachment Body2');
    ContentVersion cv2 = new ContentVersion();
        cv2.title = 'test content trigger2';      
        cv2.PathOnClient ='test2';           
        cv2.VersionData =beforeblob2;          
        insert cv2;
        
        Blob beforeblob3=Blob.valueOf('Unit Test Attachment Body3');
    ContentVersion cv3 = new ContentVersion();
        cv3.title = 'test content trigger3';      
        cv3.PathOnClient ='test3';           
        cv3.VersionData =beforeblob3;          
        insert cv3;
        
        Blob beforeblob4=Blob.valueOf('Unit Test Attachment Body4');
    ContentVersion cv4 = new ContentVersion();
        cv4.title = 'test pan ocr';      
        cv4.PathOnClient ='test4';           
        cv4.VersionData =beforeblob4;          
        insert cv4;
        
        ContentVersion testContent = [SELECT id, ContentDocumentId FROM ContentVersion where Id = :cv.Id];
    ContentDocumentLink contentlink=new ContentDocumentLink();
        contentlink.LinkedEntityId=kycObj.id;
        contentlink.ShareType= 'V';
        contentlink.ContentDocumentId=testContent.ContentDocumentId;
    insert contentlink;
        
        ContentVersion testContent2 = [SELECT id, ContentDocumentId FROM ContentVersion where Id = :cv2.Id];
    ContentDocumentLink contentlink2=new ContentDocumentLink();
        contentlink2.LinkedEntityId=kycObj12.id;
        contentlink2.ShareType= 'V';
        contentlink2.ContentDocumentId=testContent2.ContentDocumentId;
    insert contentlink2;
        
        ContentVersion testContent3 = [SELECT id, ContentDocumentId FROM ContentVersion where Id = :cv3.Id];
    ContentDocumentLink contentlink3=new ContentDocumentLink();
        contentlink3.LinkedEntityId=kycOb13.id;
        contentlink3.ShareType= 'V';
        contentlink3.ContentDocumentId=testContent3.ContentDocumentId;
    insert contentlink3;
        
        ContentVersion testContent4 = [SELECT id, ContentDocumentId FROM ContentVersion where Id = :cv4.Id];
    ContentDocumentLink contentlink4=new ContentDocumentLink();
        contentlink4.LinkedEntityId=kycObj28.id;
        contentlink4.ShareType= 'V';
        contentlink4.ContentDocumentId=testContent4.ContentDocumentId;
    insert contentlink4;
        
    }
    
    static testMethod void method1(){
        Account acnt=[Select Id from Account];
        KYC__c kycObj=[Select Id,Consent__c,PAN_Number__c from KYC__c Where Name='PAN Card'];
        KYC_Api__c kycapiObj=[Select Id from KYC_Api__c];
        AccountKycRequestHandlerController reqcontroller=new AccountKycRequestHandlerController();
        MonitorLogGenerationController monitorcontroller=new MonitorLogGenerationController();
        reqcontroller.putKycRequestHandler('PAN Card',kycObj,'Manual');
    }
    
    static testMethod void method4(){
        Account acnt=[Select Id from Account];
        KYC_Api__c kycapiObj=[Select Id from KYC_Api__c];
        KYC__c kycObj=[Select Id,Name,Consent__c,PAN_Number__c from KYC__c Where Name='PAN Card3'];
        AccountKycRequestHandlerController reqcontroller=new AccountKycRequestHandlerController();
        reqcontroller.putKycRequestHandler('PAN Card',kycObj,'Manual');
    } 
    
    static testMethod void method311(){
        Datetime currentTime = Datetime.now();
        Account acnt=[Select Id from Account];
        KYC_Api__c kycapiObj=[Select Id from KYC_Api__c];
        KYC__c kycObj=[Select Id,Name,Consent__c,PAN_Number__c from KYC__c Where Name='PAN Card4'];
        AccountKycRequestHandlerController reqcontroller=new AccountKycRequestHandlerController();
        reqcontroller.putKycRequestHandler('PAN Card',kycObj,'Manual');
    } 
    
    static testMethod void method5(){
        Datetime currentTime = Datetime.now();
        Account acnt=[Select Id from Account];
        KYC_Api__c kycapiObj=[Select Id from KYC_Api__c];
        KYC__c kycObj=[Select Id,Name,Consent__c,Email_ID__c from KYC__c Where Name='Email'];
        AccountKycRequestHandlerController reqcontroller=new AccountKycRequestHandlerController();
        MonitorLogGenerationController monitorLogGenerationControllerObj=new MonitorLogGenerationController();
        reqcontroller.putKycRequestHandler('Email',kycObj,'Manual');
        MonitorLogGenerationController.setMonitorLogss('Manual', currentTime, '','', 'E', 'p', '', kycObj.Id);
        monitorLogGenerationControllerObj.setMonitorLog('Manual', currentTime, '','', 'E', 'p', '', kycObj.Id);
        
  }
    
    static testMethod void method6(){
        Datetime currentTime = Datetime.now();
        Account acnt=[Select Id from Account];
        KYC_Api__c kycapiObj=[Select Id from KYC_Api__c];
        KYC__c kycObj=[Select Id,Name,Consent__c,dl_no__c,DOB__c from KYC__c Where Name='Driving License'];
        AccountKycRequestHandlerController reqcontroller=new AccountKycRequestHandlerController();
        MonitorLogGenerationController monitorLogGenerationControllerObj=new MonitorLogGenerationController();
        reqcontroller.putKycRequestHandler('Driving License',kycObj,'Manual');
        MonitorLogGenerationController.setMonitorLogss('Manual', currentTime, '','', 'E', 'p', '', kycObj.Id);
        monitorLogGenerationControllerObj.setMonitorLog('Manual', currentTime, '','', 'E', 'p', '', kycObj.Id);
  }
    
    static testMethod void method7(){
        Datetime currentTime = Datetime.now();
        Account acnt=[Select Id from Account];
        KYC_Api__c kycapiObj=[Select Id from KYC_Api__c];
        KYC__c kycObj=[Select Id,Name,Consent__c,vi_req_epic_no__c from KYC__c Where Name='Voter ID'];
        AccountKycRequestHandlerController reqcontroller=new AccountKycRequestHandlerController();
        MonitorLogGenerationController monitorLogGenerationControllerObj=new MonitorLogGenerationController();
        reqcontroller.putKycRequestHandler('Voter ID',kycObj,'Manual');
        MonitorLogGenerationController.setMonitorLogss('Manual', currentTime, '','', 'E', 'p', '', kycObj.Id);
        monitorLogGenerationControllerObj.setMonitorLog('Manual', currentTime, '','', 'E', 'p', '', kycObj.Id);
  }
    
    static testMethod void method8(){
        Datetime currentTime = Datetime.now();
        Account acnt=[Select Id from Account];
        KYC_Api__c kycapiObj=[Select Id from KYC_Api__c];
        KYC__c kycObj=[Select Id,Name,Consent__c,fda_licence_no__c,fda_state__c from KYC__c Where Name='FDA'];
        AccountKycRequestHandlerController reqcontroller=new AccountKycRequestHandlerController();
        MonitorLogGenerationController monitorLogGenerationControllerObj=new MonitorLogGenerationController();
        reqcontroller.putKycRequestHandler('FDA',kycObj,'Manual');
        MonitorLogGenerationController.setMonitorLogss('Manual', currentTime, '','', 'E', 'p', '', kycObj.Id);
        monitorLogGenerationControllerObj.setMonitorLog('Manual', currentTime, '','', 'E', 'p', '', kycObj.Id);
  }
    
    static testMethod void method9(){
        Datetime currentTime = Datetime.now();
        Account acnt=[Select Id from Account];
        KYC_Api__c kycapiObj=[Select Id from KYC_Api__c];
        KYC__c kycObj=[Select Id,Name,Consent__c,gst_gstin__c from KYC__c Where Name='Gst'];
        AccountKycRequestHandlerController reqcontroller=new AccountKycRequestHandlerController();
        
        MonitorLogGenerationController monitorLogGenerationControllerObj=new MonitorLogGenerationController();
        reqcontroller.putKycRequestHandler('Gst',kycObj,'Manual');
        MonitorLogGenerationController.setMonitorLogss('Manual', currentTime, '','', 'E', 'p', '', kycObj.Id);
        monitorLogGenerationControllerObj.setMonitorLog('Manual', currentTime, '','', 'E', 'p', '', kycObj.Id);
  }
    
    static testMethod void method10(){
        Datetime currentTime = Datetime.now();
        Account acnt=[Select Id from Account];
        KYC_Api__c kycapiObj=[Select Id from KYC_Api__c];
        KYC__c kycObj;//=[Select Id,Name,Consent__c,psp_name__c,psp_last_name__c,psp_country__c,psp_dob__c,psp_doe__c,psp_gender__c,psp_passport_no__c,psp_type__c,DOB__c from KYC__c Where Name='Passport'];
        AccountKycRequestHandlerController reqcontroller=new AccountKycRequestHandlerController();
        
        MonitorLogGenerationController monitorLogGenerationControllerObj=new MonitorLogGenerationController();
       // reqcontroller.putKycRequestHandler('Passport',kycObj,'Manual');  //commented by Nik on 24/06/2019 
       // MonitorLogGenerationController.setMonitorLogss('Manual', currentTime, '','', 'E', 'p', '', kycObj.Id);
       // monitorLogGenerationControllerObj.setMonitorLog('Manual', currentTime, '','', 'E', 'p', '', kycObj.Id);
  }
    
    static testMethod void method11(){
        Datetime currentTime = Datetime.now();
        Account acnt=[Select Id from Account];
        KYC_Api__c kycapiObj=[Select Id from KYC_Api__c];
        KYC__c kycObj=[Select Id,Name,Consent__c,fssai_reg_no__c from KYC__c Where Name='FSSAI'];
        AccountKycRequestHandlerController reqcontroller=new AccountKycRequestHandlerController();
        
        MonitorLogGenerationController monitorLogGenerationControllerObj=new MonitorLogGenerationController();
        reqcontroller.putKycRequestHandler('FSSAI',kycObj,'Manual');
        MonitorLogGenerationController.setMonitorLogss('Manual', currentTime, '','', 'E', 'p', '', kycObj.Id);
  }
    
    static testMethod void method12(){
        Datetime currentTime = Datetime.now();
        Account acnt=[Select Id from Account];
        KYC_Api__c kycapiObj=[Select Id from KYC_Api__c];
        KYC__c kycObj=[Select Id,Name,Consent__c,ban_account_number__c, ban_ifsc__c from KYC__c Where Name='Bank Account'];
        AccountKycRequestHandlerController reqcontroller=new AccountKycRequestHandlerController();
        
        MonitorLogGenerationController monitorLogGenerationControllerObj=new MonitorLogGenerationController();
        reqcontroller.putKycRequestHandler('Bank Account',kycObj,'Manual');
        MonitorLogGenerationController.setMonitorLogss('Manual', currentTime, '','', 'E', 'p', '', kycObj.Id);
        monitorLogGenerationControllerObj.setMonitorLog('Manual', currentTime, '','', 'E', 'p', '', kycObj.Id);
  }
    
    static testMethod void method13(){
        ContentVersion testContent = [SELECT id FROM ContentVersion Where title = 'test content trigger2']; 
        Account acnt=[Select Id from Account];
        KYC__c kycObj=[Select Id from KYC__c Where Name='Passport2'];
        KYC_Api__c kycapiObj=[Select Id from KYC_Api__c];
        AccountKycRequestHandlerController reqcontroller=new AccountKycRequestHandlerController();
        
        MonitorLogGenerationController monitorcontroller=new MonitorLogGenerationController();
        reqcontroller.putKycRequestHandler('Passport',kycObj,'Manual');
    }
    static testMethod void PANOCRmethod(){
        ContentVersion testContent = [SELECT id FROM ContentVersion Where title = 'test pan Ocr']; 
        Account acnt=[Select Id from Account];
        KYC__c kycObj=[Select Id from KYC__c Where Name='PAN OCR'];
        KYC_Api__c kycapiObj=[Select Id from KYC_Api__c];
        AccountKycRequestHandlerController reqcontroller=new AccountKycRequestHandlerController();
        
        MonitorLogGenerationController monitorcontroller=new MonitorLogGenerationController();
        reqcontroller.putKycRequestHandler('PAN OCR',kycObj,'Manual');
    }

  static testMethod void method14(){
        ContentVersion testContent = [SELECT id FROM ContentVersion Where title = 'test content trigger3']; 
        Account acnt=[Select Id from Account];
        KYC__c kycObj=[Select Id from KYC__c Where Name='VoterId2'];
        KYC_Api__c kycapiObj=[Select Id from KYC_Api__c];
        AccountKycRequestHandlerController reqcontroller=new AccountKycRequestHandlerController();
        
        MonitorLogGenerationController monitorcontroller=new MonitorLogGenerationController();
        reqcontroller.putKycRequestHandler('Voter ID',kycObj,'Manual');
    }
    
    
     // Email Error Handling
    static testMethod void method15(){
        ContentVersion testContent = [SELECT id FROM ContentVersion Where title = 'test content trigger3']; 
        Account acnt=[Select Id from Account];
        KYC__c kycObj=[Select Id,Consent__c,Email_ID__c from KYC__c Where Name='Email1'];
        KYC_Api__c kycapiObj=[Select Id from KYC_Api__c];
        AccountKycRequestHandlerController reqcontroller=new AccountKycRequestHandlerController();
        
        MonitorLogGenerationController monitorcontroller=new MonitorLogGenerationController();
        reqcontroller.putKycRequestHandler('Email',kycObj,'Manual');
    }
    // Email Error Handling
    static testMethod void method16(){
        ContentVersion testContent = [SELECT id FROM ContentVersion Where title = 'test content trigger3']; 
        Account acnt=[Select Id from Account];
        KYC__c kycObj=[Select Id,Consent__c,Email_ID__c from KYC__c Where Name='Email2'];
        KYC_Api__c kycapiObj=[Select Id from KYC_Api__c];
        AccountKycRequestHandlerController reqcontroller=new AccountKycRequestHandlerController();
        
        MonitorLogGenerationController monitorcontroller=new MonitorLogGenerationController();
        reqcontroller.putKycRequestHandler('Email',kycObj,'Manual');
    }
    
    // Driving License Error Handling
    static testMethod void method17(){
        Account acnt=[Select Id from Account];
        KYC__c kycObj=[Select Id,Consent__c,dl_no__c from KYC__c Where Name='DrivingLicense2'];
        KYC_Api__c kycapiObj=[Select Id from KYC_Api__c];
        AccountKycRequestHandlerController reqcontroller=new AccountKycRequestHandlerController();
        
        MonitorLogGenerationController monitorcontroller=new MonitorLogGenerationController();
        reqcontroller.putKycRequestHandler('Driving License',kycObj,'Manual');
    }
    // Driving License Error Handling
    static testMethod void method18(){
        Account acnt=[Select Id from Account];
        KYC__c kycObj=[Select Id,Consent__c,DOB__c from KYC__c Where Name='DrivingLicense3'];
        KYC_Api__c kycapiObj=[Select Id from KYC_Api__c];
        AccountKycRequestHandlerController reqcontroller=new AccountKycRequestHandlerController();
        
        MonitorLogGenerationController monitorcontroller=new MonitorLogGenerationController();
        reqcontroller.putKycRequestHandler('Driving License',kycObj,'Manual');
    }
    
    // VoterId Error Handling
    static testMethod void method19(){
        Account acnt=[Select Id from Account];
        KYC__c kycObj=[Select Id,Consent__c,vi_req_epic_no__c from KYC__c Where Name='VoterId'];
        KYC_Api__c kycapiObj=[Select Id from KYC_Api__c];
        AccountKycRequestHandlerController reqcontroller=new AccountKycRequestHandlerController();
        
        MonitorLogGenerationController monitorcontroller=new MonitorLogGenerationController();
        reqcontroller.putKycRequestHandler('Voter ID',kycObj,'Manual');
    }
    // VoterId Error Handling
    static testMethod void method20(){
        Account acnt=[Select Id from Account];
        KYC__c kycObj=[Select Id,Consent__c,vi_req_epic_no__c from KYC__c Where Name='VoterId3'];
        KYC_Api__c kycapiObj=[Select Id from KYC_Api__c];
        AccountKycRequestHandlerController reqcontroller=new AccountKycRequestHandlerController();
        
        MonitorLogGenerationController monitorcontroller=new MonitorLogGenerationController();
        reqcontroller.putKycRequestHandler('Voter ID',kycObj,'Manual');
    }
    
    // VoterId Error Handling
    static testMethod void method21(){
        Account acnt=[Select Id from Account];
        KYC__c kycObj=[Select Id,Consent__c,fssai_reg_no__c from KYC__c Where Name='FSSAI1'];
        KYC_Api__c kycapiObj=[Select Id from KYC_Api__c];
        AccountKycRequestHandlerController reqcontroller=new AccountKycRequestHandlerController();
        
        MonitorLogGenerationController monitorcontroller=new MonitorLogGenerationController();
        reqcontroller.putKycRequestHandler('FSSAI',kycObj,'Manual');
    }
    // VoterId Error Handling
    static testMethod void method22(){
        Account acnt=[Select Id from Account];
        KYC__c kycObj=[Select Id,Consent__c,fssai_reg_no__c from KYC__c Where Name='FSSAI2'];
        KYC_Api__c kycapiObj=[Select Id from KYC_Api__c];
        AccountKycRequestHandlerController reqcontroller=new AccountKycRequestHandlerController();
        
        MonitorLogGenerationController monitorcontroller=new MonitorLogGenerationController();
        reqcontroller.putKycRequestHandler('FSSAI',kycObj,'Manual');
    }
    
    // Gst Error Handling
    static testMethod void method23(){
        Account acnt=[Select Id from Account];
        KYC__c kycObj=[Select Id,Consent__c,fssai_reg_no__c from KYC__c Where Name='Gst1'];
        KYC_Api__c kycapiObj=[Select Id from KYC_Api__c];
        AccountKycRequestHandlerController reqcontroller=new AccountKycRequestHandlerController();
        
        MonitorLogGenerationController monitorcontroller=new MonitorLogGenerationController();
        reqcontroller.putKycRequestHandler('Gst',kycObj,'Manual');
    }
    // Gst Error Handling
    static testMethod void method24(){
        Account acnt=[Select Id from Account];
        KYC__c kycObj=[Select Id,Consent__c,fssai_reg_no__c from KYC__c Where Name='Gst2'];
        KYC_Api__c kycapiObj=[Select Id from KYC_Api__c];
        AccountKycRequestHandlerController reqcontroller=new AccountKycRequestHandlerController();
        
        MonitorLogGenerationController monitorcontroller=new MonitorLogGenerationController();
        reqcontroller.putKycRequestHandler('Gst',kycObj,'Manual');
    }
    
    // Driving License Error Handling
    static testMethod void method25(){
        Account acnt=[Select Id from Account];
        KYC__c kycObj=[Select Id,Consent__c,dl_no__c from KYC__c Where Name='FDA1'];
        KYC_Api__c kycapiObj=[Select Id from KYC_Api__c];
        AccountKycRequestHandlerController reqcontroller=new AccountKycRequestHandlerController();
        
        MonitorLogGenerationController monitorcontroller=new MonitorLogGenerationController();
        reqcontroller.putKycRequestHandler('FDA',kycObj,'Manual');
    }
    // Driving License Error Handling
    static testMethod void method26(){
        Account acnt=[Select Id from Account];
        KYC__c kycObj=[Select Id,Consent__c,DOB__c from KYC__c Where Name='FDA2'];
        KYC_Api__c kycapiObj=[Select Id from KYC_Api__c];
        AccountKycRequestHandlerController reqcontroller=new AccountKycRequestHandlerController();
        
        MonitorLogGenerationController monitorcontroller=new MonitorLogGenerationController();
        reqcontroller.putKycRequestHandler('FDA',kycObj,'Manual');
    }
    // Driving License Error Handling
    static testMethod void method27(){
        Account acnt=[Select Id from Account];
        KYC__c kycObj=[Select Id,Consent__c,DOB__c from KYC__c Where Name='FDA3'];
        KYC_Api__c kycapiObj=[Select Id from KYC_Api__c];
        AccountKycRequestHandlerController reqcontroller=new AccountKycRequestHandlerController();
        MonitorLogGenerationController monitorcontroller=new MonitorLogGenerationController();
        reqcontroller.putKycRequestHandler('FDA',kycObj,'Manual');
    }
}