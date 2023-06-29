@isTest
public class AccountSummaryReportCtrl_Test { 
    
    public class ExampleCalloutMock implements HttpCalloutMock{
        public HttpResponse respond(HTTPRequest req){
            HttpResponse res = new HttpResponse();
            res.setStatus('OK');
            res.setStatusCode(200);
            res.setBody('{"access_token": "9937fe13fc1c182ec316273870c5b1d","token_type": "Bearer","expires_in": 1800,"scope": ""}');
            return res;
        }
    }
    
    public class ExampleCalloutMock2 implements HttpCalloutMock{
        public HttpResponse respond(HTTPRequest req){
            HttpResponse res = new HttpResponse();
            res.setStatus('OK');
            res.setStatusCode(200);
            res.setBody('{"CreditInfo":[{"company_code":"","credit_control":"","sales_organization":"","customer_number":"","name":"0.0","Customer_account_number_with_credit_limit_reference":"","Customer_group":"","Customer_Credit_Group":"","Credit_representative_group_for_credit_management":"","clean_limit":"0.0","Line_limit":"0.0","Total_receivables":"0.0","Relevant_special_liabilities_for_credit_limit_check":"0.0","Credit_exposure":"0.0","ZTOT_LIB_GARANT":"0.0","Next_internal_review":"0000-00-00","CreditLimit":"0.0","CreditExposure":"0.0","Percentage":"0.0","BalanceLimit":"0.0"}]}');
            return res;
        }
    }
    
    public class ExampleCalloutMock3 implements HttpCalloutMock{
        public HttpResponse respond(HTTPRequest req){
            HttpResponse res = new HttpResponse();
            res.setStatus('OK');
            res.setStatusCode(200);
            res.setBody('{"customerNumber":"0001023171","custName":"AGRICOLA RIO NEIVA S.A.S","bucket1":"0.0","bucket2":"0.0","bucket3":"0.0","bucket4":"0.0","bucket5":"0.0","bucket6":"0.0","bucket7":"0.0","bucket8":"0.0","bucket9":"37215693.0","totalOutstanding":"37215693.0","unadjustedReceipts":"0.0","unadjustedCredits":"0.0","netOutstanding":"37215693.0","currencyKey":"COP"}');
            return res;
        }
    }

     
    static testMethod void myUnitTest() {
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        Id devRecordforCC = Schema.SObjectType.Community_Configuration__c.getRecordTypeInfosByName().get('Account Summary').getRecordTypeId();
        
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');   
        String orgId = UserInfo.getOrganizationId();
        String uniqueName = orgId + dateString + randomInt;
        Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        
		Integer randomInt1 = Integer.valueOf(math.rint(math.random()*1000000));
        String dateString1 = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');   
        String orgId1 = UserInfo.getOrganizationId();
        String uniqueName1 = orgId1 + dateString1 + randomInt1;

        Integer randomInt2 = Integer.valueOf(math.rint(math.random()*1000000));
        String dateString2 = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');   
        String orgId2 = UserInfo.getOrganizationId();
        String uniqueName2 = orgId2 + dateString2 + randomInt2;
 
        Sales_Org__c org =new Sales_Org__c();
        org.Name='Turkey';
        org.Description__c='Turkey';
        org.Sales_Org_Code__c='7110';
        insert org;
        
        Sales_Org__c org1 =new Sales_Org__c();
        org1.Name='Poland';
        org1.Description__c='Poland';
        org1.Sales_Org_Code__c='2941';
        insert org1;
        
        Account a1 = new Account();
        a1.Name = 'Test';
        a1.RecordTypeId = RecordTypeId;
        a1.SAP_Code__c = '12346';
        a1.CurrencyIsoCode = '';
        a1.Sales_Org__c=org.Id;
        a1.Sap_UserId__c='UPLINTCRM';
        insert a1;
        
        Contact c = new Contact();
        c.AccountId=a1.Id;
        c.LastName='Test';
        insert c; 
        
        Account a2 = new Account();
        a2.Name = 'Test123';
        a2.RecordTypeId = RecordTypeId;
        a2.SAP_Code__c = '123';
        a2.CurrencyIsoCode = '';
        a2.Sales_Org__c=org1.Id;
        insert a2;
        
        Contact c1 = new Contact();
        c1.AccountId=a2.Id;
        c1.LastName='Test';
        insert c1; 
        
        Id profile = [select id from profile where name='Partner Community User'].id;
        
     //     UserRole userRole1 = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        User u = new User(Alias = 'standt', 
            EmailEncodingKey='UTF-8',
            LastName='Testing',
            Country = 'Turkey',
      //      ContactId=c.Id,
            LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = profile,                 
            TimeZoneSidKey='America/Los_Angeles',
            email = uniqueName + '@test' + orgId + '.org',
         //   UserRoleId = userRole1.Id,
           ContactId = c.Id ,            
            Username = uniqueName + '@test' + orgId + '.org');
        	
        insert u;
        
        User u1 = new User(Alias = 'standt11', 
            EmailEncodingKey='UTF-8',
            LastName='Testing123',
            Country = 'Poland',
      //      ContactId=c.Id,
            LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = profile,                 
            TimeZoneSidKey='America/Los_Angeles',
            email = uniqueName2 + '@test' + orgId2 + '.org',
         //   UserRoleId = userRole1.Id,
           ContactId = c1.Id ,            
            Username = uniqueName2 + '@test' + orgId2 + '.org');
        	
        insert u1;
        
        Price_Group_Master__c pg = new Price_Group_Master__c ();
        pg.PG_Code__c='03';
        insert Pg;
        
        Auto_Number__c auto = new Auto_Number__c();
        auto.Name='FarmerCode';
        auto.Sequence__c='11';
        insert auto;
        
        Sales_Org__c sorg =new Sales_Org__c();
        sorg.Name='Colombia';
        sorg.Description__c='Colombia';
        sorg.Sales_Org_Code__c='5710';
        insert sorg;
        
        
        
        Order_Type__c  orderTypeObj = new Order_Type__c(
            Name = 'ZXOR',                  // Order Type Name
            Description__c = 'Factura',     // Description
            Order_Type_Code__c = 'ZXOR',      // Order Type Code
            SalesOrg__c = sorg.Id  // Sales Org
        );
        insert orderTypeObj;
        
        Payment_Method__c paymentMethodObj = new Payment_Method__c(
            Name = 'Contado',                   // Payment Method Name
            Sales_Org__c = sorg.Id,      // Sales Org
            Payment_Method_Code__c = 'C1',     // Payment Method Code
            Active__c = true                  // Active
        );
        insert paymentMethodObj;
        
        
        Payment_Term__c paymentTermObj = new Payment_Term__c(
            Payment_Term_Code__c = '0015',                     // Payment Term Code
            Payment_Term__c = '30 dias',                         // Payment Term
            Payterms_Desc__c = 'Pagamento estrito em 30 dias.',  // Payterms Desc
            Maturity_Date_Mandatory__c = 'Yes',                  // Maturity Date Mandatory
            Sales_Org__c = sorg.Id,                    // Sales Org
            Active__c = false                                   // Active
        );
        insert paymentTermObj;
        
        
        
        Depot__c dp =new Depot__c ();
        dp.Name='Argentina';
        dp.Country__c='Argentina';
        dp.Location__c='Charata';
        dp.Depot_Code__c='PUN1';
        insert dp;
        
        Product2 pro = new Product2();
        pro.ProductCode = '66700';
        pro.Product_Code__c='66700';
        pro.Name='DOST';
        pro.popular__c = true;
        pro.Combination_Key__c='RM0065100';
        insert Pro;
        
        
        
        Distribution_Channel__c disbj = new Distribution_Channel__c();
        disbj.Name = '20';                      
        disbj.Distribution_Channel_Code__c = '20';  
        disbj.Description__c='test';
        insert disbj;
        
        Division__c Divbj = new Division__c();
        Divbj.Name = '10';         
        Divbj.Description__c = null;    
        Divbj.Division_Code__c = '10'; 
        insert Divbj;
        
        SKU__c sku = new SKU__c();
        sku.Name='DOST';
        sku.SKU_Code__c='704002';
        sku.SKU_Pack__c=1.00;
        sku.SKU_UOM__c='L';
        sku.Group__c='DOST';
        sku.Pack_Size__c=10.00;
        sku.Product_Name__c=pro.Id;
        sku.Sales_Org__c = sorg.Id;
        sku.UOM__c='L';
        sku.Active__c=True;
        sku.Combination_Key__c='Cooooooo000011111';
        sku.Multiple_of__c = 5.00;
        insert sku;
        
        PriceBookMaster__c PbMaster = new PriceBookMaster__c(
            BudgetPrice__c = 5.00,                                        // Budget Price
            SKUCode__c = sku.id,                               // SKU Code
            MinPrice__c = 5.20,                                           // Min Price
            DepotCode__c = dp.id,                             // Depot Code
            Price__c = 7.00,
            PG_CODE__c =Pg.Id,                           // Price
            UOM__c = 'KG',                                                // UOM
            StartDate__c = system.today(),                      // Start Date
            
            EndDate__c = system.today()+1,                       // End Date
            // DistributionChannel__c = 'a0x0k000000IQiV',                   // Distribution Channel
            Active__c = true,                                            // Active
            PerUnit__c = 1, 
            Batch__c ='test',
            CompositeKey__c = 'c1',  // CompositeKey
            Sales_Org__c = sorg.id,                             // Sales Org
            Price_Book_Change__c = false                                 // Price_Book_Change
        );
        insert PbMaster; 
        
        Order_Type__c ordType =new Order_Type__c();
        ordType.Name = 'ZXOR';              
        ordType.Description__c = 'Factura';    
        ordType.Order_Type_Code__c = 'ZXOR';
        insert ordType;
        
        Account acc = new Account();
        acc.Name='Bhavik Devdhar';
        acc.Last_Name__c='Devdhar';
        acc.PriceGroupCode__c=pg.id;
        acc.SAP_Code__c='SAP996734';
        acc.RecordTypeId=devRecordTypeId;
        acc.Raise_Order_Type__c = 'Factura';
        acc.Mobile__c='9967341759';
        acc.Phone='020256589';
        acc.Sales_Org__c=sorg.Id;
        acc.Division__c=Divbj.Id;
        acc.Distribution_Channel__c=disbj.Id;
        acc.BillingCity='Charata';
        acc.Order_Type__c=ordType.Id;
        acc.Depot_Code__c = 'PUN1';
       // acc.Sap_UserId__c = 'UPLINTCRM';        //acc.OwnerId=sobj.Id;
        insert acc;
        
          Credit_Info__c sobj = new Credit_Info__c(
            Sales_Org__c = sorg.Id,        // Sales Org
            Distributor__c = acc.Id,      // Distributor
            //Distributor_Code__c = '00010101341210',  // Distributor Code
            Credit_Limit__c = 0.00,                  // Credit Limit
            Internal_Limit__c = 0.00,                // Internal Limit
            Used_Limit__c = 20306.31,                // Used Limit
            Balance_Limit__c = 20306.31,             // Balance Limit
            Percentage_Used__c = 0.00,             // Percentage Used
            Sum_Open_Item__c = 20306            // Outstanding
        );
        insert sobj;
        
        Credit_Info__c sobj1 = new Credit_Info__c(
            Sales_Org__c = org.Id,        // Sales Org
            Distributor__c = a1.Id,      // Distributor
            //Distributor_Code__c = '00010101341210',  // Distributor Code
            Credit_Limit__c = 0.00,                  // Credit Limit
            Internal_Limit__c = 0.00,                // Internal Limit
            Used_Limit__c = 20306.31,                // Used Limit
            Balance_Limit__c = 20306.31,             // Balance Limit
            Percentage_Used__c = 0.00,             // Percentage Used
            Sum_Open_Item__c = 20306            // Outstanding
        );
        insert sobj1;
        
        Credit_Info__c sobj2 = new Credit_Info__c(
            Sales_Org__c = org1.Id,        // Sales Org
            Distributor__c = a2.Id,      // Distributor
            //Distributor_Code__c = '00010101341210',  // Distributor Code
            Credit_Limit__c = 0.00,                  // Credit Limit
            Internal_Limit__c = 0.00,                // Internal Limit
            Used_Limit__c = 20306.31,                // Used Limit
            Balance_Limit__c = 20306.31,             // Balance Limit
            Percentage_Used__c = 0.00,             // Percentage Used
            Sum_Open_Item__c = 20306            // Outstanding
        );
        insert sobj2;
        
        Outstanding_Ageing__c outObj = new Outstanding_Ageing__c(
            SAP_Code__c = '0001106787',           // SAP Code
            X0_30__c = 0.00,                        // 0-30
            X31_60__c = 0.00,                       // 31-60
            X61_75__c = 0.00,                       // 61-75
            Net_Outstanding__c = 1790.44,           // Net Outstanding
            X76_90__c = 0.00,                       // 76-90
            //Territory_KEDE__c = 'a1L28000005HT04',  // Territory (KEDE)
            X91_120__c = 0.00,                      // 91-120
            X121_150__c = 0.00,                     // 121-150
            // Zone__c = 'a1M0K00000616XH',            // Zone
            X151_180__c = 0.00,                     // 151-180
            //SBU__c = 'a1m28000000PtAd',             // SBU
            X181_210__c = 0.00,                     // 181-210
            //Sales_Org__c = 'a1F0K0000054zNM',       // Sales Org
            X211_Above__c = 0.00,                   // 211 Above
            Total_Outstanding__c = 0.00,            // Total Outstanding
            Unadjusted_Credits__c = 1790.44,        // Unadjusted Credits
            Customer_Code__c = acc.Id,   // Customer Code
            Unadjusted_Receipts__c = 0.00,          // Unadjusted Receipts
            Combination_Key__c = '00011067871510'  // Combination Key
            );
            insert outObj;
        
       Account_Statement__c astateObj = new Account_Statement__c(
            Account__c = acc.Id,  // Account
            Opening_Balance__c = 0.00,     // Opening Balance
            SAP_Code__c = '00010249971210'  // SAP Code
        );
        insert astateObj;
        
        
        Contact contactObj = new Contact(LastName = 'Contact Last Name');
        contactObj.AccountId = acc.Id;
        insert contactObj;  
        
        Community_Configuration__c ccObj = new Community_Configuration__c(
            Country__c = 'Colombia',                   // Country
            RecordTypeId = devRecordforCC,                  // Record Type
            Active__c = true,                            // Active
            Community_User_Role__c = '1',                // Community User Role
            Visible_to_All__c = true,                    // Visible to All
            Sales_Org__c = '5710',                       // Sales Org
            Distributor_Name__c = acc.Id,     // Distributor Name
            //Image__c = '\n',                             // Image
            Custom_Link_Name__c = 'www.google.com',      // Custom Link Name
            Valid_From__c = System.today(),  // Valid From
            Valid_To__c = System.today()    // Valid To
        );
        insert ccObj;
        
        Community_Credentials__c cred = new Community_Credentials__c();
        cred.Name='oauth credentials';
       	cred.Username__c='8031b1e0-1730-34be-9790-8e165a577f02';
        cred.Password__c='ComPortalOauthDev112';
        insert cred;    
            
        Community_Endpoints__c token =new Community_Endpoints__c();
        token.Name='Token';
        token.URL__c='https://oauthasservices-ae7888026.hana.ondemand.com/oauth2/api/v1/token?grant_type=client_credentials';
        insert token;
        
        Community_Endpoints__c credinfo =new Community_Endpoints__c();
        credinfo.Name='Credit Summary';
        credinfo.URL__c='https://l4097-iflmap.hcisbp.eu1.hana.ondemand.com/http/CreditSummary_NL';
        insert credinfo;
        
        Community_Endpoints__c customOut =new Community_Endpoints__c();
        customOut.Name='Customer Outstanding';
        customOut.URL__c='https://l4097-iflmap.hcisbp.eu1.hana.ondemand.com/http/CustomerOutstanding_NL';
        insert customOut;
        
        
        
        System.runAs ( new User(Id = UserInfo.getUserId()) ) {
            UserRole r = [select id from UserRole where name = 'UPL Management'];
            UserLicense licence = [SELECT Id FROM UserLicense where name ='Customer Community Plus'];
            Profile p = [SELECT Id FROM Profile WHERE UserLicenseId = : licence.Id Limit 1]; 
            
            User comUser = new User(alias = 'test123', 
                                    email='test123@noemail.com',
                                    emailencodingkey='UTF-8', 
                                    lastname='Testing', 
                                    languagelocalekey='en_US',
                                    localesidkey='en_US', 
                                    profileid = p.Id, 
                                    country='United States',
                                    Community_Role__c ='1',
                                    IsActive =true,
                                    contactId=contactObj.Id,
                                    timezonesidkey='America/Los_Angeles', 
                                    username='newone@noemail.com');
            insert comuser;
        }
        
        User cuser = [select id from user where username ='newone@noemail.com' limit 1];

        System.RunAs(cuser) {
            AccountSummaryReportCtrl tmpObj = new AccountSummaryReportCtrl();
            AccountSummaryReportCtrl.CreditInfoWrapper creditInfo = new AccountSummaryReportCtrl.CreditInfoWrapper();
            AccountSummaryReportCtrl.wrapOauthResponse Response = new AccountSummaryReportCtrl.wrapOauthResponse();
            AccountSummaryReportCtrl.WrapCreditInfo WrapCredit = new AccountSummaryReportCtrl.WrapCreditInfo();
            AccountSummaryReportCtrl.wrapOutstanding Outstanding = new AccountSummaryReportCtrl.wrapOutstanding();  
            tmpObj.displayAccountSummary();
        }  
        
        System.RunAs(u) {
            
            AccountSummaryReportCtrl tmpObj = new AccountSummaryReportCtrl();
            AccountSummaryReportCtrl.CreditInfoWrapper creditInfo = new AccountSummaryReportCtrl.CreditInfoWrapper();
            AccountSummaryReportCtrl.wrapOauthResponse Response = new AccountSummaryReportCtrl.wrapOauthResponse();
            AccountSummaryReportCtrl.WrapCreditInfo WrapCredit = new AccountSummaryReportCtrl.WrapCreditInfo();
            AccountSummaryReportCtrl.wrapOutstanding Outstanding = new AccountSummaryReportCtrl.wrapOutstanding();
            Test.startTest();
             Test.setMock(HttpCalloutMock.class, new ExampleCalloutMock());
            Test.setMock(HttpCalloutMock.class, new ExampleCalloutMock2());
            Test.setMock(HttpCalloutMock.class, new ExampleCalloutMock3());
           
           tmpObj.displayAccountSummary();
            Test.stopTest();
        } 
        
        System.RunAs(u1) {
            AccountSummaryReportCtrl tmpObj = new AccountSummaryReportCtrl();
            AccountSummaryReportCtrl.CreditInfoWrapper creditInfo = new AccountSummaryReportCtrl.CreditInfoWrapper();
            AccountSummaryReportCtrl.wrapOauthResponse Response = new AccountSummaryReportCtrl.wrapOauthResponse();
            AccountSummaryReportCtrl.WrapCreditInfo WrapCredit = new AccountSummaryReportCtrl.WrapCreditInfo();
            AccountSummaryReportCtrl.wrapOutstanding Outstanding = new AccountSummaryReportCtrl.wrapOutstanding();          
            Test.setMock(HttpCalloutMock.class, new ExampleCalloutMock());
            Test.setMock(HttpCalloutMock.class, new ExampleCalloutMock2());
            Test.setMock(HttpCalloutMock.class, new ExampleCalloutMock3());
            tmpObj.displayAccountSummary();            
        } 
        
    }
}