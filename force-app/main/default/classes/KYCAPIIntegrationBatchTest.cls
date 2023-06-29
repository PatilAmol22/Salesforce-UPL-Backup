/*
* Name: KYCAPIIntegrationBatchTest
* Created On: 07 July 2019
* Author: Azhar Shaikh
*/

@isTest
public class KYCAPIIntegrationBatchTest {
    
static testMethod void testMethod1() 
    {
        
        Id RecordTypeIdPanCard = Schema.SObjectType.KYC__c.getRecordTypeInfosByName().get('PAN Card').getRecordTypeId();
        Id RecordTypeIdGST = Schema.SObjectType.KYC__c.getRecordTypeInfosByName().get('Gst').getRecordTypeId();
        Id RecordTypeIdBankAcc = Schema.SObjectType.KYC__c.getRecordTypeInfosByName().get('Bank Account').getRecordTypeId();
        Id RecordTypeIdPassport = Schema.SObjectType.KYC__c.getRecordTypeInfosByName().get('Passport').getRecordTypeId();
        
        //Data for Account
        
        //Data for Account
        Account accObj = new Account(
            Name='Bhavik Devdhar',
            SAP_Code__c = '0001013292', 
            Last_Name__c = 'ADECO AGROPECUARIA S.A.',     // Last Name
            Order_Block__c = false,                       // Order Block
            Mobile__c = '9405883688',  
            Phone='020256589', // Mobile
            Email__c = 'marcelo.gorla@uniphos.com',       // Email
            Account_Type__c = 'Sold To Party',            // Account Type
            Raise_Order_Type__c = 'Both',                 // Raise Order Type
            Billing_Street_2__c = 'CATAMARCA 3454',       // Billing Street 2
            // Sales_Org__c = salesOrgObj.id,             // Sales Org
            //  Division__c = divisionObj.Id,              // Division Name
            //Distribution_Channel__c = distributionChannelObj.Id,  // Distribution Channel
            Depot_Code__c = 'AR13'                       // Depot Code
        );
        insert accObj;
        
        
        //for PAN Card
        KYC__c kycObj1 = new KYC__c(
            Name = 'Driving Licence',                                               // KYC Name
            Account__c = accObj.id,                                        // Account
            RecordTypeId = RecordTypeIdPanCard,                                               // Record Type
            Kyc_status__c = 'Valid', 
            PAN_Number__c ='PAN23456',// Kyc status
            Consent__c = true,
            ma_type__c ='',// Consent
            pan_resp_name__c = '',
            ma_preset__c ='',
            Confidence_score__c = 100,                                          // Confidence score
            //API_Count__c = '12',                                                      // API Count (KYC)
            //Status_Code__c = '101',                                                   // Status Code
            //req_kyc_int_datetime__c = Datetime.valueOf('28-5-2019 2:00 PM:00'),       // req kyc int datetime
            //res_kyc_int_datetime__c = Datetime.valueOf('28-5-2019 2:00 PM:00'),       // res kyc int datetime
            //Territory__c = 'a1L0k000001INXs',                                         // Territory
            KYC_Integration_Status__c = 'Partially Completed',                                  // KYC Integration Status
            //DOB__c = Date.valueOf('10-5-1987'),                                       // DOB
            email_resp_accept_all__c = false,                                         // email resp accept all
            email_resp_regexp__c = false,                                             // email resp regexp
            email_resp_disposable__c = false,                                         // email resp disposable
            email_resp_result__c = false,                                             // email resp result
            email_resp_smtp_check__c = false,                                         // email resp smtp check
            email_resp_mx_records__c = false,                                         // email resp mx records
            email_resp_webmail__c = false,                                            // email resp webmail
            //dl_dob__c = Date.valueOf('10-5-1987'),                                    // dl dob
            //dl_resp_dob__c = Date.valueOf('5-10-1987'),                               // dl resp dob
            dl_no__c = 'MH27 20160022933',                                            // dl no
            dl_resp_father_husband_name__c = 'SUDHAKAR',                              // dl resp father husband name
            dl_resp_address__c = 'AT-PO- TALEGAON THAKUR  TQ- TIOSA DIST- AMRAVATI',  // dl resp address
            //dl_resp_Issue_Date__c = Date.valueOf('8-11-2017'),                        // dl resp Issue Date
            dl_resp_name__c = 'VISHAL PAWAR',                                         // dl resp name
            dl_resp_cov__c = 'MCWG',                                                  // dl resp cov
            dl_resp_validity_non_transport__c = '23-08-2016 to 22-08-2036',           // dl resp validity non transport
            dl_resp_cov_issue_date__c = 'RTO,AMRAVATI'                               // dl resp cov issue date
        );
        insert kycObj1;
        
        
        //for GST
        KYC__c kycObj5 = new KYC__c(
            Name = 'Driving Licence',                                               // KYC Name
            Account__c = accObj.id,                                        // Account
            RecordTypeId = RecordTypeIdGST,                                               // Record Type
            Kyc_status__c = 'Not Valid',
            gst_gstin__c ='123445SGDT',                                      // Kyc status
            Consent__c = true,                                                        // Consent
            Confidence_score__c = 100, 
            ma_type__c ='',
            ma_preset__c ='',
            First_Name__c='',
            Last_Name__c='',
            // Confidence score
            //API_Count__c = '12',                                                      // API Count (KYC)
            //Status_Code__c = '101',                                                   // Status Code
            //req_kyc_int_datetime__c = Datetime.valueOf('28-5-2019 2:00 PM:00'),       // req kyc int datetime
            //res_kyc_int_datetime__c = Datetime.valueOf('28-5-2019 2:00 PM:00'),       // res kyc int datetime
            //Territory__c = 'a1L0k000001INXs',                                         // Territory
            KYC_Integration_Status__c = 'Partially Completed',                                  // KYC Integration Status
            //DOB__c = Date.valueOf('10-5-1987'),                                       // DOB
            email_resp_accept_all__c = false,                                         // email resp accept all
            email_resp_regexp__c = false,                                             // email resp regexp
            email_resp_disposable__c = false,                                         // email resp disposable
            email_resp_result__c = false,                                             // email resp result
            email_resp_smtp_check__c = false,                                         // email resp smtp check
            email_resp_mx_records__c = false,                                         // email resp mx records
            email_resp_webmail__c = false,                                            // email resp webmail
            //dl_dob__c = Date.valueOf('10-5-1987'),                                    // dl dob
            //dl_resp_dob__c = Date.valueOf('5-10-1987'),                               // dl resp dob
            dl_no__c = 'MH27 20160022933',                                            // dl no
            dl_resp_father_husband_name__c = 'SUDHAKAR',                              // dl resp father husband name
            dl_resp_address__c = 'AT-PO- TALEGAON THAKUR  TQ- TIOSA DIST- AMRAVATI',  // dl resp address
            //dl_resp_Issue_Date__c = Date.valueOf('8-11-2017'),                        // dl resp Issue Date
            dl_resp_name__c = 'VISHAL PAWAR',                                         // dl resp name
            dl_resp_cov__c = 'MCWG',                                                  // dl resp cov
            dl_resp_validity_non_transport__c = '23-08-2016 to 22-08-2036',           // dl resp validity non transport
            dl_resp_cov_issue_date__c = 'RTO,AMRAVATI'                               // dl resp cov issue date
        );
        insert kycObj5;
        
        //for Bank Account
        KYC__c kycObj6 = new KYC__c(
            Name = 'Driving Licence',                                               // KYC Name
            Account__c = accObj.id,                                        // Account
            RecordTypeId = RecordTypeIdBankAcc,                                               // Record Type
            Kyc_status__c = 'Valid',
            ban_account_number__c ='ABCD123131',                 // Kyc status
            Consent__c = true,                                                        // Consent
            Confidence_score__c = 100, 
            ma_type__c ='',
            ma_preset__c='',// Confidence score
            //API_Count__c = '12',                                                      // API Count (KYC)
            //Status_Code__c = '101',                                                   // Status Code
            //req_kyc_int_datetime__c = Datetime.valueOf('28-5-2019 2:00 PM:00'),       // req kyc int datetime
            //res_kyc_int_datetime__c = Datetime.valueOf('28-5-2019 2:00 PM:00'),       // res kyc int datetime
            //Territory__c = 'a1L0k000001INXs',                                         // Territory
            KYC_Integration_Status__c = 'Partially Completed',                                  // KYC Integration Status
            //DOB__c = Date.valueOf('10-5-1987'),                                       // DOB
            email_resp_accept_all__c = false,                                         // email resp accept all
            email_resp_regexp__c = false,                                             // email resp regexp
            email_resp_disposable__c = false,                                         // email resp disposable
            email_resp_result__c = false,                                             // email resp result
            email_resp_smtp_check__c = false,                                         // email resp smtp check
            email_resp_mx_records__c = false,                                         // email resp mx records
            email_resp_webmail__c = false,                                            // email resp webmail
            //dl_dob__c = Date.valueOf('10-5-1987'),                                    // dl dob
            //dl_resp_dob__c = Date.valueOf('5-10-1987'),                               // dl resp dob
            dl_no__c = 'MH27 20160022933',                                            // dl no
            dl_resp_father_husband_name__c = 'SUDHAKAR',                              // dl resp father husband name
            dl_resp_address__c = 'AT-PO- TALEGAON THAKUR  TQ- TIOSA DIST- AMRAVATI',  // dl resp address
            //dl_resp_Issue_Date__c = Date.valueOf('8-11-2017'),                        // dl resp Issue Date
            dl_resp_name__c = 'VISHAL PAWAR',                                         // dl resp name
            dl_resp_cov__c = 'MCWG',                                                  // dl resp cov
            dl_resp_validity_non_transport__c = '23-08-2016 to 22-08-2036',           // dl resp validity non transport
            dl_resp_cov_issue_date__c = 'RTO,AMRAVATI'                               // dl resp cov issue date
        );
        insert kycObj6;
        
        //for Passport
        KYC__c kycObj7 = new KYC__c(
            Name = 'Driving Licence',                                               // KYC Name
            Account__c = accObj.id,                                        // Account
            RecordTypeId = RecordTypeIdPassport, 
            psp_passport_no__c ='PASSPORT123456',                    // Record Type
            Kyc_status__c = 'Valid',                                                  // Kyc status
            Consent__c = true,                                                        // Consent
            Confidence_score__c = 100,  
            ma_type__c ='',
            ma_preset__c ='',
            First_Name__c='',
            Last_Name__c='',// Confidence score
            //API_Count__c = '12',                                                      // API Count (KYC)
            //Status_Code__c = '101',                                                   // Status Code
            //req_kyc_int_datetime__c = Datetime.valueOf('28-5-2019 2:00 PM:00'),       // req kyc int datetime
            //res_kyc_int_datetime__c = Datetime.valueOf('28-5-2019 2:00 PM:00'),       // res kyc int datetime
            //Territory__c = 'a1L0k000001INXs',                                         // Territory
            KYC_Integration_Status__c = 'Partially Completed',                                  // KYC Integration Status
            //DOB__c = Date.valueOf('10-5-1987'),                                       // DOB
            email_resp_accept_all__c = false,                                         // email resp accept all
            email_resp_regexp__c = false,                                             // email resp regexp
            email_resp_disposable__c = false,                                         // email resp disposable
            email_resp_result__c = false,                                             // email resp result
            email_resp_smtp_check__c = false,                                         // email resp smtp check
            email_resp_mx_records__c = false,                                         // email resp mx records
            email_resp_webmail__c = false,                                            // email resp webmail
            //dl_dob__c = Date.valueOf('10-5-1987'),                                    // dl dob
            //dl_resp_dob__c = Date.valueOf('5-10-1987'),                               // dl resp dob
            dl_no__c = 'MH27 20160022933',                                            // dl no
            dl_resp_father_husband_name__c = 'SUDHAKAR',                              // dl resp father husband name
            dl_resp_address__c = 'AT-PO- TALEGAON THAKUR  TQ- TIOSA DIST- AMRAVATI',  // dl resp address
            //dl_resp_Issue_Date__c = Date.valueOf('8-11-2017'),                        // dl resp Issue Date
            dl_resp_name__c = 'VISHAL PAWAR',                                         // dl resp name
            dl_resp_cov__c = 'MCWG',                                                  // dl resp cov
            dl_resp_validity_non_transport__c = '23-08-2016 to 22-08-2036',           // dl resp validity non transport 
            dl_resp_cov_issue_date__c = 'RTO,AMRAVATI'                               // dl resp cov issue date
        );
        insert kycObj7;
        
        Test.startTest();
        
        KYCAPIIntegrationBatch obj = new KYCAPIIntegrationBatch();
        KYCAPIIntegrationBatch.submitKyc(RecordTypeIdBankAcc,kycObj7,'Scheduler');
        DataBase.executeBatch(obj); 
        
        Test.stopTest();
    }
}