@isTest
public class SurveyFileUploadControllerTest {
    
    Static Date FromDate;                                    
    Static    Date Todate;                                      
    Static    String Season;
    Static Date today1 =date.today();  
    @testSetup static void TestData() {
        userrole  usrole = new userrole();
        usrole.Name ='Call Expert - Mumbai';
        //Insert usrole;
        
        Profile p = [SELECT Id,name FROM Profile WHERE Name = 'UPL Call Expert'];
        
        User sobj1 = new User();
        sobj1.Alias = 'zonaa';                                                            
        sobj1.Email = 'sumit.singh@skinternational.com';                             
        sobj1.ProfileId  = p.ID;                                                     
        sobj1.Division = 'Vizag';
        sobj1.Username = 'zonal_aaexe1232@upl122333.com.devbox';                                    
        sobj1.IsActive = true;  
        sobj1.LastName='Terriotory Manager';
        sobj1.CommunityNickname = 'zonalExe1222 Di'; 
        sobj1.TimeZoneSidKey = 'America/Sao_Paulo'; 
        // sobj1.Contact.AccountID = acc.id;// Time Zone
        sobj1.LocaleSidKey = 'en_IN';                                    
        sobj1.LanguageLocaleKey = 'en_US';                                             
        sobj1.ForecastEnabled = false;                                                     
        sobj1.EmailEncodingKey = 'ISO-8859-1';    
        sobj1.Show_Inventory__c = false;                                                     
        sobj1.Show_Credit_Limit__c = false; 
        sobj1.UserRoleId = usrole.id;
        //sobj1.ContactId=con.Id;
        insert sobj1; 
        // Product2 p1=[Select id,Name from Product2 where Name='ZEBA' LIMIT 1];
        Sales_Org__c sorg1 = new Sales_Org__c(
            Name = 'India',              // Sales Org Name
            Company_Code__c = '1000',      // Company Code
            Sales_Org_Code__c = '1000',    // Sales Org Code
            Country_Code__c = 'IN',        // Country Code
            Description__c = 'India'      // Description
        );
        insert sorg1;
        Product2 p1= new Product2();
        //p1.RecordTypeId=Schema.SObjectType.Product2.getRecordTypeInfosByName().get('India').getRecordTypeId();
        p1.Name = 'ZEBA';                       // Product Name
        p1.Combination_Key__c = '4430110002010';  // Combination Key
        p1.Sales_Org__c=sorg1.Id;
        insert p1;
        
        //Zone__c z1=[Select id,Name from Zone__c where Name='Pune' LIMIT 1];
        Promotional_Product__c Promotional_Product = new Promotional_Product__c(
            Name = 'DOST SUPER',                     // Promotional Product Name
            Product_Name__c = p1.Id,       // Product Name
            Current_Month__c = true,                  // Current Month
            Month__c = 'Aug',                          // Month
            Financial_Year__c = '2018',                // Financial Year
            Start_Date__c = Date.newInstance(2018, 12, 9),  // Start Date
            End_Date__c = Date.newInstance(2018, 12, 11)   // End Date
            //  Zone__c = z1.Id              // Zone
            //  Crop_Name__c = 'Cotton'                   // Crop Name
        );
        insert Promotional_Product;
        
        
        Sales_Org__c sorg = new Sales_Org__c(
            Name = 'India',              // Sales Org Name
            Company_Code__c = '1000',      // Company Code
            Sales_Org_Code__c = '1000',    // Sales Org Code
            Country_Code__c = 'IN',        // Country Code
            Description__c = 'India'      // Description
        );
        insert sorg;
        
        
        Account acc1 = new Account();
        acc1.RecordTypeId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        acc1.Name ='test';
        //   acc1.FirstName='test';
        //   acc1.LastName='Test';
        acc1.Last_Name__c='test';
        //  acc1.PersonMobilePhone='9869457812';
        //    acc1.PersonEmail='test@gmail.com';
        acc1.Phone='1010101004';
        acc1.WRMS_Code__c='1222';
        acc1.BillingStreet='test';
        acc1.BillingCity='test';
        acc1.BillingState='test';
        acc1.BillingPostalCode='test';
        acc1.BillingCountry='test';
        acc1.Sales_Org__c = sorg.Id;
        acc1.Promotional_Product__c=Promotional_Product.id;
        //    acc1.Promotional_Product__pc=Promotional_Product.id;
        insert acc1;
        
        /*   Farmer_Promotional_Product__c FarmerProduct = new Farmer_Promotional_Product__c(
Accounts__c = acc1.Id,           // Account
Promotional_Product__c = Promotional_Product.id,  // Promotional Product
Month__c = 'June',                           // Month
Financial_Year__c = '2018'                  // Financial Year
);
insert FarmerProduct; */
        
        Axedasurvey__c SurveyObj = new Axedasurvey__c(
            Account__c = acc1.Id,                         // Account Name
            Customer_Fisrt_Name__c = 'Himanshu',                      // Customer Fisrt Name
            Customer_Last_Name__c = 'Mehta',                          // Customer Last Name
            Customer_mobile_number__c = '99214562659921456265',       // Customer mobile number
            Customer_e_mail_Address__c = 'himan@yop.com',             // Customer e mail Address
            Customer_SAP_Code__c = '123456',                          // Customer SAP Code
            Does_customer_have_separate_ship_to_addr__c = 'Yes',      // Does customer have separate ship to addr
            If_yes_Please_mention_address__c = 'kkkk',                // If yes, Please mention address
            Mention_owner_Residence_Addres_with_pin__c = 'ujygh',     // Mention owner Residence Addres with pin
            Mention_pin_code_of_Ship_to_address__c = 'kkkkk',         // Mention pin code of Ship to address
            Mention_partner_operator_residanc_addre__c = 'uujjujuj',  // Mention partner/operator residance addrs
            Does_customer_has_any_sister_concern_fir__c = 'No',       // Do you have Sister Concern/Partner Firm
            Select_type_of_firm__c = 'Partnership',                   // Select type of firm
            Is_GST_Applicable__c = 'No',                              // Is GST Applicable?
            Mention_Firm_PAN_no__c = 'AZLPM6587E',                    // Mention Firm PAN no
            Firms_operating_bank_Name_and_city__c = 'HDFC',           // Firms operating bank Name and city
            Mention_firm_owners_Adhaar_Card_no__c = '123456789456',   // Mention firm owners Adhaar Card no
            Firms_operating_Bank_acc_no__c = '0045101222555',         // Firms operating Bank acc no
            If_no_from_whom_it_is_captured__c = 'Family member',      // If no, from whom it is captured
            I_hereby_confirm_that_above_information__c = 'Yes',       // I hereby confirm information is correct
            Whether_all_above_information_is_capture__c = 'No'     // Whether all above information is capture
            
        );
        insert SurveyObj;   
        
        kyc__c kyc = new KYC__c();
        kyc.Account__c = acc1.Id;
        kyc.Name = 'Test';
        kyc.recordtypeId = Schema.SObjectType.KYC__c.getRecordTypeInfosByName().get('Passport').getRecordTypeId();
        INSERT kyc;
        
        kyc__c kyc1 = new KYC__c();
        kyc1.Account__c = acc1.Id;
        kyc1.Name = 'Test';
        kyc1.recordtypeId = Schema.SObjectType.KYC__c.getRecordTypeInfosByName().get('PAN Card').getRecordTypeId();
        INSERT kyc1;
        
        DistributorDocument__c DistributeDocObj = new DistributorDocument__c(
            Distributor__c = acc1.Id,  // Distributor
            // Record Type
            Document_Name__c = 'TestPDF (6).pdf',  // Document Name
            Documents_Type__c = 'Passport',    // Documents Type
            Survey__c = SurveyObj.Id         // Survey
        );
        insert DistributeDocObj;
        
        DistributorDocument__c DistributeDocObj1 = new DistributorDocument__c(
            Distributor__c = acc1.Id,  // Distributor
            // Record Type
            Document_Name__c = 'TestPDF (6).pdf',  // Document Name
            Documents_Type__c = 'Passport',
            // Documents Type
            Survey__c = SurveyObj.Id         // Survey
        );
        insert DistributeDocObj1;
    }
    
    
    
    Static testMethod void createDistributorDocument(){
        
        // SurveyFileUploadController surveyFileUpload = new SurveyFileUploadController();
        test.startTest();
        List<DistributorDocument__c> DistributorDocList = [select id,Distributor__c,Document_Name__c,Documents_Type__c,AttachmentId__c from DistributorDocument__c];
        SurveyFileUploadController.createDistributorDoc(DistributorDocList);
        try{
        Axedasurvey__c SurveyObj = [select id from Axedasurvey__c limit 1];
        Id fileId = SurveyFileUploadController.saveChunk(SurveyObj .Id,'Test File','Test data','jpg','');
        SurveyFileUploadController.saveChunk(SurveyObj .Id,'Test File','Test data','jpg',fileId);
        SurveyFileUploadController.convertAttachmentToFile(fileId);
        }catch(exception e){}
        test.stopTest();
    } 
    
    Static testMethod void DeleteDistributorDocument(){
        
        // SurveyFileUploadController surveyFileUpload = new SurveyFileUploadController();
        test.startTest();
        List<DistributorDocument__c> DeletedDocumentList = [select id,Distributor__c,Document_Name__c,Documents_Type__c from DistributorDocument__c];
        SurveyFileUploadController.DeleteDistributorDocuments(DeletedDocumentList);
        Schema.SObjectType DistributorDocType = Schema.getGlobalDescribe().get('DistributorDocument__c');
        sObject sObj = DistributorDocType.newSObject();
        SurveyFileUploadController.getselectOptions(sObj, 'Documents_Type__c');
        test.stopTest();
    } 
    
    Static testMethod void loadDistributorDoc(){
        
        test.startTest();
        AxedaSurvey__c survey = [select id,Name from Axedasurvey__c limit1];
        Account Acc = [select id from account limit 1];
        SurveyFileUploadController.loadDistributorDoc(survey.Id, Acc.Id);
        test.stopTest();
    }
    
    
    Static testMethod void InsertAttachmentInSurvey(){
        
        test.startTest();
        AxedaSurvey__c survey = [select id,Name from Axedasurvey__c limit 1];
        List<DistributorDocument__c> DistributorDocList = [select id,Distributor__c,Document_Name__c,Documents_Type__c,AttachmentId__c from DistributorDocument__c];
        SurveyFileUploadController.InsertAttachmentInSurvey(DistributorDocList, survey.Id);
        test.stopTest();
    }
    
}