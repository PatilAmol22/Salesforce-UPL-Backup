@isTest
public class UpdateKYCController_test {
    @testSetup
    static void allTheDataForThisTestClass() {
        Id RecordTypeIdPanCard = Schema.SObjectType.KYC__c.getRecordTypeInfosByName().get('PAN Card').getRecordTypeId();
        
        //Data For Account
        Account sobj = new Account(
            Name = 'Adarsh Krishi [View Hierarchy]',     // Account Name
            SAP_Code__c = 'ABCD1234',                      // SAP Customer Code
            Mobile__c = '99887552229988755222',            // Mobile
            Status__c = 'Active',                          // Status
            Order_Block__c = false,                        // Order Block
            //Sales_Org__c = 'a1F0k000000sXsH',              // Sales Org
           // Territory_Distributor__c = 'a1L0k000001INXs',  // Territory Distributor
            Account_Type__c = 'Sold To Party',             // Account Type
            OwnersetbyProcess__c = false                  // Owner set by Process
            
        );
        insert sobj;
        
        
        
        
        
        
        
        
        
        //for Pan card
        KYC__c kycObj1 = new KYC__c(
            Name = 'Driving Licence',                                               // KYC Name
            Account__c = sobj.id,                                        // Account
            RecordTypeId = RecordTypeIdPanCard,                                               // Record Type
            Kyc_status__c = 'Valid',                                                  // Kyc status
            Consent__c = true,                                                        // Consent
            Confidence_score__c = 100,                                          // Confidence score
            //API_Count__c = '12',                                                      // API Count (KYC)
            //Status_Code__c = '101',                                                   // Status Code
            //req_kyc_int_datetime__c = Datetime.valueOf('28-5-2019 2:00 PM:00'),       // req kyc int datetime
            //res_kyc_int_datetime__c = Datetime.valueOf('28-5-2019 2:00 PM:00'),       // res kyc int datetime
            //Territory__c = 'a1L0k000001INXs',                                         // Territory
            KYC_Integration_Status__c = 'Submitted for KYC',                                  // KYC Integration Status
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
        
        
    }
    
     static testMethod void method() {
        List<KYC__c> kyclst = [select Id, Name,  RecordTypeId,RecordType.Name,  Kyc_status__c, Confidence_score__c from KYC__c LIMIT 1];
        System.debug('kycobj '+kyclst);
        UpdateKYCController.updateKyc(kyclst[0].Id);
        
    }
    
    
    
    
}