@isTest
public class KYCScheduledDispatcherTest {

    
    @testSetup
    static void allDataForThisClass(){
        Id recordtypeKycPANId=Schema.SObjectType.KYC__c.getRecordTypeInfosByName().get('PAN Card').getRecordTypeId();         
        
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
        kycObj.KYC_Integration_Status__c = 'Submitted for KYC';                                                                                             // KYC Integration Status
        kycObj.First_Name__c = 'Shikha';                                                                                                                      // First Name
        kycObj.Last_Name__c = 'Sharma';                                                                                                                       // Last Name
        kycObj.DOB__c =  Date.newInstance(1990, 12, 9);                                                                                                          // DOB
        kycObj.PAN_Number__c = 'AHGPA32366';                                                                                                                  // PAN Number
        kycObj.pan_resp_name__c = 'Vishal Shah';                                                                                                     // pan resp name
        insert kycObj;
        
        
        KYC_Api__c kycapiObj= new KYC_Api__c();
        kycapiObj.Endpoint__c='https://testapi.karza.in/v2';
        kycapiObj.EndpointV3__c='https://testapi.karza.in/v3';
        kycapiObj.EndpointV1__c='https://gst.karza.in/uat/v1';
        kycapiObj.x_karza_key__c='l0fiz30qr2yCx35ABS6F';
        insert kycapiObj;
        
    }
    
    static testmethod void testschedule(){
        Test.startTest();
        KYCScheduledDispatcher sh1 = new KYCScheduledDispatcher();
        String sch = '0 0 2 * * ?'; 
        system.schedule('Test Check', sch, sh1); 
        Test.stopTest();
    }
    
}