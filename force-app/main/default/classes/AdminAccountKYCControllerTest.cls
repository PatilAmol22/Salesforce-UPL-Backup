@isTest
public  class AdminAccountKYCControllerTest {
    static public  TestMethod void accountKycAdmin(){

       Id devRecordTypeId = Schema.SObjectType.KYC__c.getRecordTypeInfosByName().get('PAN Card').getRecordTypeId();


        Sales_Org__c sorg = new Sales_Org__c();
        sorg.Name = 'India';
        sorg.Sales_Org_Code__c = '1000';
        insert sorg;

        SBU__c sbu = new SBU__c(
        SBUCode__c = 'BR1',                // SBU Code
        SalesOrg__c = sorg.id     // Sales Org
        
        );
        insert sbu;

        Zone__c zone =  new Zone__c();
        zone.SalesOrg__c = sorg.Id;
        zone.Name = 'BU MATO GROSSO';
        zone.ZoneCode__c = 'BR10';              
        zone.SBUCode__c = sbu.Id;
        insert zone; 

         Region__c region = new Region__c();
        region.Name = 'MATO GROSSO DO SUL';
        region.RegionCode__c =  'BR1010';
        region.SalesOrg__c = sorg.Id;
        region.Zone__c = zone.Id;  
        region.SBU__c = sbu.Id;                                                                           
        insert region;
        
         Territory_Distributor__c territory =  new Territory_Distributor__c();
        territory.Name = 'Araxá';
        territory.TerritoryCode__c = 'BR165';
        territory.SBU__c = sbu.Id;     
        territory.Region__c = region.id;
        territory.SalesOrg__c = sorg.Id;
        territory.RegionDesciption__c = 'BR1001102 CHPS';                       
        territory.Zone__c = zone.Id;
       // territory.TerritoryManagerActive__c = false;
        insert territory;
    
           Id recordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
          
          Account accObj = new Account(
              Name = 'AKASH KRUSHI KENDRA',
              Last_Name__c = 'AKASH KRUSHI KENDRA - MANDRUP',       // Last Name
               recordtypeid = recordTypeIdAccount,                // Mobile
              OwnersetbyProcess__c = true,                          // Owner set by Process
              Status__c = 'Active',                                 // Status
              Zone__c = 'Pune',   
              Sales_Org__c  =  sorg.id,                                 // Zone
              Cust_Group__c = '189',                                // Customer Group
              Territory_Code__c = '189',                            // Territory Code
              ApprovedbyRegionalManager__c = false,                 // Approved by Regional Manager
              ApprovedbyZonalHead__c = false,
              ApprovalStatus__c = 'Draft'  
              //OwnerId  =  terrman.id
                                      // Approval Status
        );
        insert accObj;
        KYC__c kyc = new KYC__c(
            Name = 'PAN Card',                                                                                                                           // KYC Name
             Account__c = accObj.id,                                                                                                                // Account
                                                                                                                              // Record Type
            Kyc_status__c = 'Valid',                                                                                                                       // Kyc status
            Consent__c = true,                                                                                                                             // Consent
            Confidence_score__c = 28,                                                                                                                      // Confidence score
            API_Count__c = 19,                                                                                                                           // API Count (KYC)
            API_Count_Name__c = 5,                                                                                                                       // API Count (Name)
            API_Count_OCR__c = 9,                                                                                                                        // API Count (OCR)
            ma_type__c = 'individual',                                                                                                                     // ma type
            ma_preset__c = 'L',                                                                                                                            // ma preset
            Request_JSON__c = '{\n  "consent" : "Y",\n  "pan" : "AHGPA3235Q"\n}',                                                                          // Request JSON
            Respone_JSON__c = '{"result": {"name": "SANDIP TABAJI ATKARI"}, "request_id": "a924ba4c-811a-11e9-b9e9-775b828524a3", "status-code": "101"}',  // Respone JSON
            Status_Code__c = '101',                                                                                                                        // Status Code
            Request_Id__c = 'a924ba4c-811a-11e9-b9e9-775b828524a3',                                                                                        // Request Id
           // req_kyc_int_datetime__c = Datetime.valueOf('28-5-2019 1:01 PM:00'),                                                                            // req kyc int datetime
            //res_kyc_int_datetime__c = Datetime.valueOf('30-5-2019 4:30 PM:00'),                                                                            // res kyc int datetime
            KYC_Integration_Status__c = 'Completed',                                                                                                       // KYC Integration Status
            First_Name__c = 'Shikha',                                                                                                                      // First Name
            Last_Name__c = 'Sharma',                                                                                                                       // Last Name
           // DOB__c = Date.valueOf('15-5-1985'),                                                                                                            // DOB
            PAN_Number__c = 'AHGPA3235Q',                                                                                                                  // PAN Number
            pan_resp_name__c = 'SANDIP TABAJI ATKARI',                                                                                                     // pan resp name
            email_resp_accept_all__c = false,                                                                                                              // email resp accept all
            email_resp_regexp__c = false,                                                                                                                  // email resp regexp
            email_resp_disposable__c = false,                                                                                                              // email resp disposable
            email_resp_result__c = false,                                                                                                                  // email resp result
            email_resp_smtp_check__c = false,                                                                                                              // email resp smtp check
            email_resp_mx_records__c = false,                                                                                                              // email resp mx records
            email_resp_webmail__c = false,
            Territory__c = territory.id,
            RecordTypeId = devRecordTypeId                                                                                                               // email resp webmail
            );
            insert kyc;

            AdminAccountKYCController kycController = new AdminAccountKYCController();
            
            AdminAccountKYCController.KYCWrapper kycWrapper = new AdminAccountKYCController.KYCWrapper();
            AdminAccountKYCController.KYCDetails kycDetails = new AdminAccountKYCController.KYCDetails();

            kycController.salesOrg ='1000';
            kycController.fetchCountryData();

            kycController.sbu_Id = sbu.Id;
            kycController.zone_Id = zone.id;
            kycController.rgn_Id = region.id;
            kycController.ter_Id = territory.id;
            kycController.isKyc_done = 'Valid';
            kycController.getKYCDetailsList();

            kycController.kycSet = kyc.id;
            kycController.runKYC();

            kycController.kycId = kyc.id;
            kycController.getKYCDetails();

            kycController.Sales_Org = '1210';
            kycController.onSBUChangeFun();

            kycController.onZoneChangeFun();
            kycController.onRegChangeFun();


    }
    
}