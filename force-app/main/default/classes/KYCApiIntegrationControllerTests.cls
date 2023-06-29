@isTest
public class KYCApiIntegrationControllerTests {
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
        kycObj.req_kyc_int_datetime__c = System.now();                                                                            // req kyc int datetime
        kycObj.res_kyc_int_datetime__c = System.now();                                                                            // res kyc int datetime
        kycObj.KYC_Integration_Status__c = 'Partially Completed';                                                                                             // KYC Integration Status
        kycObj.First_Name__c = 'Shikha';                                                                                                                      // First Name
        kycObj.Last_Name__c = 'Sharma';                                                                                                                       // Last Name
        kycObj.DOB__c =  Date.newInstance(1990, 12, 9);                                                                                                          // DOB
        kycObj.PAN_Number__c = 'AHGPA32366';                                                                                                                  // PAN Number
        kycObj.pan_resp_name__c = 'Vishal Shah';                                                                                                     // pan resp name
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
        
        KYC__c kycOb12=new KYC__c();
        kycOb12.Name = 'MatchName';                                                                                                                           // KYC Name
        kycOb12.Account__c = acnt.Id;  
        kycOb12.Consent__c = true;  // Account
        kycOb12.First_Name__c='Test2';
        kycOb12.ma_type__c = 'Individual';
        kycOb12.ma_preset__c = 'S';
        insert kycOb12;
        
        KYC_Api__c kycapiObj= new KYC_Api__c();
        kycapiObj.Endpoint__c='https://testapi.karza.in/v2';
        kycapiObj.EndpointV3__c='https://testapi.karza.in/v3';
        kycapiObj.EndpointV1__c='https://gst.karza.in/uat/v1';
        kycapiObj.x_karza_key__c='l0fiz30qr2yCx35ABS6F';
        insert kycapiObj;
        
        KYCApiIntegrationController kycApiIntegrationControllerObj=new KYCApiIntegrationController(); 
        kycApiIntegrationControllerObj.getMatchAPIJsonRequestStr('Test1', 'Test2', 'Individual', 'S');
        kycApiIntegrationControllerObj.getPANCardJsonRequestStr('asdbs54545', 'Y');
        kycApiIntegrationControllerObj.getEmailIdJsonRequestStr('abc@gmail.com', 'Y');
        kycApiIntegrationControllerObj.getDrivingLicenseJsonRequestStr('y', 'MH s545451sddsd11','15-04-1995');
        kycApiIntegrationControllerObj.getVoterJsonRequestStr('Y', 'asdbs54545');
        kycApiIntegrationControllerObj.getFssaiJsonRequestStr('Y', 'asdbs54545');
        kycApiIntegrationControllerObj.getIfscCodeJsonRequestStr('Y', 'asdbs54545');
        kycApiIntegrationControllerObj.getFdaJsonRequestStr('Y', 'asdbs54545','GJ');
        kycApiIntegrationControllerObj.getBankAccountJsonRequestStr('Y', 'asdbs54545','544551115662');
        kycApiIntegrationControllerObj.getGstJsonRequestStr('Y', 'asdbs545456565414');
        KYCApiIntegrationController.getOCRJsonRequestStr('asdbs545456565414');
        
        kycApiIntegrationControllerObj.checkEmail('abc@gmail.com');
        kycApiIntegrationControllerObj.checkDrivingLicense('MH27 20160022933');
        kycApiIntegrationControllerObj.checkPAN('AHGPA3235Q');
        kycApiIntegrationControllerObj.checkgst('27AABCS1698G2Z4');
        kycApiIntegrationControllerObj.checkCountryCode('GJ');
        kycApiIntegrationControllerObj.getDateFormat('15-04-1995');
    }
    static testMethod void Matchmethod1(){
        Datetime currentTime = Datetime.now();
        Account acnt=[Select Id from Account];
        KYC_Api__c kycapiObj=[Select Id from KYC_Api__c];
        KYC__c kycObj=[Select Id,Name,Consent__c,RecordTypeId from KYC__c Where Name='MatchName'];
        String name1='Test2';
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new KycIntegrationCalloutMockTest('MatchName101'));
        KYCApiIntegrationController.validateMatchName(kycObj.Id, 'Manual', name1, kycObj.RecordTypeId, 'MatchName');
        Test.stopTest();
    }
    static testMethod void Matchmethod2(){
        Datetime currentTime = Datetime.now();
        Account acnt=[Select Id from Account];
        KYC_Api__c kycapiObj=[Select Id from KYC_Api__c];
        KYC__c kycObj=[Select Id,Name,Consent__c,RecordTypeId from KYC__c Where Name='MatchName'];
        String name1='Test2';
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new KycIntegrationCalloutMockTest('MatchName500'));
    KYCApiIntegrationController.validateMatchName(kycObj.Id, 'Manual', name1, kycObj.RecordTypeId, 'MatchName');
        Test.stopTest();
    }
    static testMethod void Matchmethod3(){
        Datetime currentTime = Datetime.now();
        Account acnt=[Select Id from Account];
        KYC_Api__c kycapiObj=[Select Id from KYC_Api__c];
        KYC__c kycObj=[Select Id,Name,Consent__c,RecordTypeId from KYC__c Where Name='MatchName'];
        String name1='Test2';
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new KycIntegrationCalloutMockTest('MatchNameNULL'));
    KYCApiIntegrationController.validateMatchName(kycObj.Id, 'Manual', name1, kycObj.RecordTypeId, 'MatchName');
        Test.stopTest();
    }
    static testMethod void Emailmethod1(){
        Datetime currentTime = Datetime.now();
        Account acnt=[Select Id from Account];
        KYC_Api__c kycapiObj=[Select Id from KYC_Api__c];
        KYC__c kycObj=[Select Id,Name,Consent__c,Email_ID__c from KYC__c Where Name='Email'];
        String jsonRequestBody='{ "consent" : "Y", "email" : "sharma@shikha.com"}';
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new KycIntegrationCalloutMockTest('Email101'));
    KYCApiIntegrationController.validateEmail(kycObj.Id, 'Manual', jsonRequestBody, currentTime, 'Email');
        Test.stopTest();
    }
    static testMethod void Emailmethod2(){
        Datetime currentTime = Datetime.now();
        Account acnt=[Select Id from Account];
        KYC_Api__c kycapiObj=[Select Id from KYC_Api__c];
        KYC__c kycObj=[Select Id,Name,Consent__c,Email_ID__c from KYC__c Where Name='Email'];
        String jsonRequestBody='{ "consent" : "Y", "email" : "sharma@shikha.com"}';
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new KycIntegrationCalloutMockTest('Email500'));
    KYCApiIntegrationController.validateEmail(kycObj.Id, 'Manual', jsonRequestBody, currentTime, 'Email');
        Test.stopTest();
    }
    static testMethod void Emailmethod3(){
        Datetime currentTime = Datetime.now();
        Account acnt=[Select Id from Account];
        KYC_Api__c kycapiObj=[Select Id from KYC_Api__c];
        KYC__c kycObj=[Select Id,Name,Consent__c,Email_ID__c from KYC__c Where Name='Email'];
        String jsonRequestBody='{ "consent" : "Y", "email" : ""}';
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new KycIntegrationCalloutMockTest('EmailNULL'));
    KYCApiIntegrationController.validateEmail(kycObj.Id, 'Manual', jsonRequestBody, currentTime, 'Email');
        Test.stopTest();
    }
    static testMethod void PANmethod1(){
        Datetime currentTime = Datetime.now();
        Account acnt=[Select Id from Account];
        KYC_Api__c kycapiObj=[Select Id from KYC_Api__c];
        KYC__c kycObj=[Select Id,Name,Consent__c,RecordTypeId,PAN_Number__c from KYC__c Where Name='PAN Card'];
        String jsonRequestBody='{ "consent" : "Y", "pan" : "AHGPA3235Q" }';
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new KycIntegrationCalloutMockTest('PAN101'));
    KYCApiIntegrationController.validatePan(kycObj.Id, 'Manual', jsonRequestBody, kycObj.RecordTypeId,currentTime, 'PAN Card');
        Test.stopTest();
    }
    static testMethod void PANmethod2(){
        Datetime currentTime = Datetime.now();
        Account acnt=[Select Id from Account];
        KYC_Api__c kycapiObj=[Select Id from KYC_Api__c];
        KYC__c kycObj=[Select Id,Name,Consent__c,RecordTypeId,PAN_Number__c from KYC__c Where Name='PAN Card'];
        String jsonRequestBody='{ "consent" : "Y", "pan" : "" }';
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new KycIntegrationCalloutMockTest('PAN500'));
    KYCApiIntegrationController.validatePan(kycObj.Id, 'Manual', jsonRequestBody,kycObj.RecordTypeId, currentTime, 'PAN Card');
        Test.stopTest();
    }
    static testMethod void PANmethod3(){
        Datetime currentTime = Datetime.now();
        Account acnt=[Select Id from Account];
        KYC_Api__c kycapiObj=[Select Id from KYC_Api__c];
        KYC__c kycObj=[Select Id,Name,Consent__c,RecordTypeId,PAN_Number__c from KYC__c Where Name='PAN Card'];
        String jsonRequestBody='{ "consent" : "Y", "pan" : "" }';
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new KycIntegrationCalloutMockTest('PANNULL'));
    KYCApiIntegrationController.validatePan(kycObj.Id, 'Manual', jsonRequestBody,kycObj.RecordTypeId, currentTime, 'PAN Card');
        Test.stopTest();
    }
    static testMethod void DLmethod1(){
        Datetime currentTime = Datetime.now();
        Account acnt=[Select Id from Account];
        KYC_Api__c kycapiObj=[Select Id from KYC_Api__c];
        KYC__c kycObj=[Select Id,Name,Consent__c,RecordTypeId from KYC__c Where Name='Driving License'];
        String jsonRequestBody='{ "consent": "<<Y/N>>", "dl_no": "MH01 20090091406", "dob": "12-06-1987" }';
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new KycIntegrationCalloutMockTest('DL101'));
    KYCApiIntegrationController.validateDriverLicense(kycObj.Id, 'Manual', jsonRequestBody, kycObj.RecordTypeId,currentTime, 'Driving License');
        Test.stopTest();
    }
    static testMethod void DLmethod2(){
        Datetime currentTime = Datetime.now();
        Account acnt=[Select Id from Account];
        KYC_Api__c kycapiObj=[Select Id from KYC_Api__c];
        KYC__c kycObj=[Select Id,Name,Consent__c,RecordTypeId from KYC__c Where Name='Driving License'];
        String jsonRequestBody='{ "consent": "<<Y/N>>", "dl_no": "MH01 20090091406", "dob": "12-06-1987" }';
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new KycIntegrationCalloutMockTest('DL500'));
    KYCApiIntegrationController.validateDriverLicense(kycObj.Id, 'Manual', jsonRequestBody,kycObj.RecordTypeId, currentTime, 'Driving License');
        Test.stopTest();
    }
    static testMethod void DLmethod3(){
        Datetime currentTime = Datetime.now();
        Account acnt=[Select Id from Account];
        KYC_Api__c kycapiObj=[Select Id from KYC_Api__c];
        KYC__c kycObj=[Select Id,Name,Consent__c,RecordTypeId from KYC__c Where Name='Driving License'];
        String jsonRequestBody='{ "consent": "<<Y/N>>", "dl_no": "", "dob": "" }';
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new KycIntegrationCalloutMockTest('DLNULL'));
    KYCApiIntegrationController.validateDriverLicense(kycObj.Id, 'Manual', jsonRequestBody,kycObj.RecordTypeId, currentTime, 'Driving License');
        Test.stopTest();
    }
    static testMethod void VoterIDmethod1(){
        Datetime currentTime = Datetime.now();
        Account acnt=[Select Id from Account];
        KYC_Api__c kycapiObj=[Select Id from KYC_Api__c];
        KYC__c kycObj=[Select Id,Name,Consent__c,RecordTypeId from KYC__c Where Name='Voter ID'];
        String jsonRequestBody='{ "consent": "<<Y/N>>", "epic_no": "SIQ3830379" }';
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new KycIntegrationCalloutMockTest('VoterID101'));
    KYCApiIntegrationController.validateVoterId(kycObj.Id, 'Manual', jsonRequestBody, kycObj.RecordTypeId,currentTime, 'Voter ID');
        Test.stopTest();
    }
    static testMethod void VoterIDmethod2(){
        Datetime currentTime = Datetime.now();
        Account acnt=[Select Id from Account];
        KYC_Api__c kycapiObj=[Select Id from KYC_Api__c];
        KYC__c kycObj=[Select Id,Name,Consent__c,RecordTypeId from KYC__c Where Name='Voter ID'];
        String jsonRequestBody='{ "consent": "<<Y/N>>", "epic_no": "SIQ3830379" }';
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new KycIntegrationCalloutMockTest('VoterID500'));
    KYCApiIntegrationController.validateVoterId(kycObj.Id, 'Manual', jsonRequestBody,kycObj.RecordTypeId, currentTime, 'Voter ID');
        Test.stopTest();
    }
    static testMethod void VoterIDmethod3(){
        Datetime currentTime = Datetime.now();
        Account acnt=[Select Id from Account];
        KYC_Api__c kycapiObj=[Select Id from KYC_Api__c];
        KYC__c kycObj=[Select Id,Name,Consent__c,RecordTypeId from KYC__c Where Name='Voter ID'];
        String jsonRequestBody='{ "consent": "<<Y/N>>", "epic_no": "" }';
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new KycIntegrationCalloutMockTest('VoterIDNULL'));
    KYCApiIntegrationController.validateVoterId(kycObj.Id, 'Manual', jsonRequestBody,kycObj.RecordTypeId, currentTime, 'Voter ID');
        Test.stopTest();
    }
    static testMethod void Fssaimethod1(){
        Datetime currentTime = Datetime.now();
        Account acnt=[Select Id from Account];
        KYC_Api__c kycapiObj=[Select Id from KYC_Api__c];
        KYC__c kycObj=[Select Id,Name,Consent__c,RecordTypeId from KYC__c Where Name='Fssai'];
        String jsonRequestBody='{ "consent": "<<Y/N>>", "reg_no": "10013022002245" }';
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new KycIntegrationCalloutMockTest('Fssai101'));
    KYCApiIntegrationController.validateFssai(kycObj.Id, 'Manual', jsonRequestBody, kycObj.RecordTypeId,currentTime, 'Fssai');
        Test.stopTest();
    }
    static testMethod void Fssaimethod2(){
        Datetime currentTime = Datetime.now();
        Account acnt=[Select Id from Account];
        KYC_Api__c kycapiObj=[Select Id from KYC_Api__c];
        KYC__c kycObj=[Select Id,Name,Consent__c,RecordTypeId from KYC__c Where Name='Fssai'];
        String jsonRequestBody='{ "consent": "<<Y/N>>", "reg_no": "10013022002245" }';
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new KycIntegrationCalloutMockTest('Fssai500'));
    KYCApiIntegrationController.validateFssai(kycObj.Id, 'Manual', jsonRequestBody,kycObj.RecordTypeId, currentTime, 'Fssai');
        Test.stopTest();
    }
    static testMethod void Fssaimethod3(){
        Datetime currentTime = Datetime.now();
        Account acnt=[Select Id from Account];
        KYC_Api__c kycapiObj=[Select Id from KYC_Api__c];
        KYC__c kycObj=[Select Id,Name,Consent__c,RecordTypeId from KYC__c Where Name='Fssai'];
        String jsonRequestBody='{ "consent": "<<Y/N>>", "reg_no": "" }';
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new KycIntegrationCalloutMockTest('FssaiNULL'));
    KYCApiIntegrationController.validateFssai(kycObj.Id, 'Manual', jsonRequestBody, kycObj.RecordTypeId,currentTime, 'Fssai');
        Test.stopTest();
    }
    static testMethod void Bankmethod(){
        Datetime currentTime = Datetime.now();
        Account acnt=[Select Id from Account];
        KYC_Api__c kycapiObj=[Select Id from KYC_Api__c];
        KYC__c kycObj=[Select Id,Name,Consent__c,RecordTypeId from KYC__c Where Name='Bank Account'];
        String jsonRequestBody='{ "consent": "Y", "ifsc": "icici55551", "accountNumber": "656541222555" }';
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new KycIntegrationCalloutMockTest('BA101'));
    KYCApiIntegrationController.validateBankAccount(kycObj.Id, 'Manual', jsonRequestBody, kycObj.RecordTypeId,currentTime, 'Bank Account');
        Test.stopTest(); 
    }
    
    static testMethod void Bankmethod2(){
        Datetime currentTime = Datetime.now();
        Account acnt=[Select Id from Account];
        KYC_Api__c kycapiObj=[Select Id from KYC_Api__c];
        KYC__c kycObj=[Select Id,Name,Consent__c,RecordTypeId from KYC__c Where Name='Bank Account'];
        String jsonRequestBody='{ "consent": "Y", "ifsc": "icici55551", "accountNumber": "" }';
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new KycIntegrationCalloutMockTest('BA500'));
    KYCApiIntegrationController.validateBankAccount(kycObj.Id, 'Manual', jsonRequestBody,kycObj.RecordTypeId, currentTime, 'Bank Account');
        Test.stopTest();
    }
    static testMethod void Bankmethod3(){
        Datetime currentTime = Datetime.now();
        Account acnt=[Select Id from Account];
        KYC_Api__c kycapiObj=[Select Id from KYC_Api__c];
        KYC__c kycObj=[Select Id,Name,Consent__c,RecordTypeId from KYC__c Where Name='Bank Account'];
        String jsonRequestBody='{ "consent": "Y", "ifsc": "icici55551", "accountNumber": "" }';
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new KycIntegrationCalloutMockTest('BANULL'));
    KYCApiIntegrationController.validateBankAccount(kycObj.Id, 'Manual', jsonRequestBody, kycObj.RecordTypeId,currentTime, 'Bank Account');
        Test.stopTest();
    }
    static testMethod void FDAmethod(){
        Datetime currentTime = Datetime.now();
        Account acnt=[Select Id from Account];
        KYC_Api__c kycapiObj=[Select Id from KYC_Api__c];
        KYC__c kycObj=[Select Id,Name,Consent__c,RecordTypeId from KYC__c Where Name='FDA'];
        String jsonRequestBody='{ "consent": "<<Y/N>>", "licence_no": "75202", "state": "GJ" }';
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new KycIntegrationCalloutMockTest('FDA101'));
    KYCApiIntegrationController.validateFda(kycObj.Id, 'Manual', jsonRequestBody, kycObj.RecordTypeId,currentTime, 'FDA');
        Test.stopTest(); 
    }
    
    static testMethod void FDAmethod2(){
        Datetime currentTime = Datetime.now();
        Account acnt=[Select Id from Account];
        KYC_Api__c kycapiObj=[Select Id from KYC_Api__c];
        KYC__c kycObj=[Select Id,Name,Consent__c,RecordTypeId from KYC__c Where Name='FDA'];
        String jsonRequestBody='{ "consent": "<<Y/N>>", "licence_no": "75202", "state": "GJ" }';
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new KycIntegrationCalloutMockTest('FDA500'));
    KYCApiIntegrationController.validateFda(kycObj.Id, 'Manual', jsonRequestBody,kycObj.RecordTypeId, currentTime, 'FDA');
        Test.stopTest();
    }
    static testMethod void FDAmethod3(){
        Datetime currentTime = Datetime.now();
        Account acnt=[Select Id from Account];
        KYC_Api__c kycapiObj=[Select Id from KYC_Api__c];
        KYC__c kycObj=[Select Id,Name,Consent__c,RecordTypeId from KYC__c Where Name='FDA'];
        String jsonRequestBody='{ "consent": "<<Y/N>>", "licence_no": "75202", "state": "GJ" }';
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new KycIntegrationCalloutMockTest('FDANULL'));
    KYCApiIntegrationController.validateFda(kycObj.Id, 'Manual', jsonRequestBody, kycObj.RecordTypeId,currentTime, 'FDA');
        Test.stopTest();
    }
    static testMethod void Gstmethod(){
        Datetime currentTime = Datetime.now();
        Account acnt=[Select Id from Account];
        KYC_Api__c kycapiObj=[Select Id from KYC_Api__c];
        KYC__c kycObj=[Select Id,Name,Consent__c,RecordTypeId from KYC__c Where Name='Gst'];
        String jsonRequestBody='{ "consent": "<<Y/N>>", "gstin": "27AAACR5055K1Z7" }';
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new KycIntegrationCalloutMockTest('Gst101'));
    KYCApiIntegrationController.validateGst(kycObj.Id, 'Manual', jsonRequestBody, kycObj.RecordTypeId,currentTime, 'Gst');
        Test.stopTest(); 
    }
    
    static testMethod void Gstmethod2(){
        Datetime currentTime = Datetime.now();
        Account acnt=[Select Id from Account];
        KYC_Api__c kycapiObj=[Select Id from KYC_Api__c];
        KYC__c kycObj=[Select Id,Name,Consent__c,RecordTypeId from KYC__c Where Name='Gst'];
        String jsonRequestBody='{ "consent": "<<Y/N>>", "gstin": "27AAACR5055K1Z7" }';
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new KycIntegrationCalloutMockTest('Gst500'));
    KYCApiIntegrationController.validateGst(kycObj.Id, 'Manual', jsonRequestBody,kycObj.RecordTypeId, currentTime, 'Gst');
        Test.stopTest();
    }
    static testMethod void Gstmethod3(){
        Datetime currentTime = Datetime.now();
        Account acnt=[Select Id from Account];
        KYC_Api__c kycapiObj=[Select Id from KYC_Api__c];
        KYC__c kycObj=[Select Id,Name,Consent__c,RecordTypeId from KYC__c Where Name='Passport'];
        String jsonRequestBody='{"fileB64" : "iVBORw0KGgobPY/nVQoE7c1KzwAAAAASUVORK5CYII="}';
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new KycIntegrationCalloutMockTest('GstNULL'));
    KYCApiIntegrationController.validateGst(kycObj.Id, 'Manual', jsonRequestBody, kycObj.RecordTypeId,currentTime, 'Gst');
        Test.stopTest();
    }
    static testMethod void Ocrmethod(){
        Datetime currentTime = Datetime.now();
        Account acnt=[Select Id from Account];
        KYC_Api__c kycapiObj=[Select Id from KYC_Api__c];
        KYC__c kycObj=[Select Id,Name,Consent__c,RecordTypeId from KYC__c Where Name='Passport'];
        String jsonRequestBody='{"fileB64" : "iVBORw0KGgobPY/nVQoE7c1KzwAAAAASUVORK5CYII="}';
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new KycIntegrationCalloutMockTest('Ocr101'));
    KYCApiIntegrationController.validateOCR(kycObj.Id, 'Manual', jsonRequestBody, kycObj.RecordTypeId,currentTime, 'Ocr');
        Test.stopTest(); 
    }
    
    static testMethod void Ocrmethod2(){
        Datetime currentTime = Datetime.now();
        Account acnt=[Select Id from Account];
        KYC_Api__c kycapiObj=[Select Id from KYC_Api__c];
        KYC__c kycObj=[Select Id,Name,Consent__c,RecordTypeId from KYC__c Where Name='Passport'];
        String jsonRequestBody='{"fileB64" : "iVBORw0KGgobPY/nVQoE7c1KzwAAAAASUVORK5CYII="}';
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new KycIntegrationCalloutMockTest('Ocr500'));
    KYCApiIntegrationController.validateOCR(kycObj.Id, 'Manual', jsonRequestBody,kycObj.RecordTypeId, currentTime, 'Ocr');
        Test.stopTest();
    }
    static testMethod void Ocrmethod3(){
        Datetime currentTime = Datetime.now();
        Account acnt=[Select Id from Account];
        KYC_Api__c kycapiObj=[Select Id from KYC_Api__c];
        KYC__c kycObj=[Select Id,Name,Consent__c,RecordTypeId from KYC__c Where Name='Passport'];
        String jsonRequestBody='{ "consent": "<<Y/N>>", "gstin": "27AAACR5055K1Z7" }';
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new KycIntegrationCalloutMockTest('OcrNULL'));
    KYCApiIntegrationController.validateOCR(kycObj.Id, 'Manual', jsonRequestBody, kycObj.RecordTypeId,currentTime, 'Ocr');
        Test.stopTest();
    }
}