@isTest
private class ConnectAccSummaryCtrl_Test {
    
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
            res.setBody('{"customerInfo":{"City":"SANTIAGO","ClosingBalance":"91094.5","CustomerCode":"0001085739","CustomerName":"AGRICOLA ALTO DE QUITRALMAN S A","GlAccountLongText":"Loss from currency valuation","GlAccountNumber":"0000230010","OpeningBalance":"0.0","SalesOffice":"CL18"},"ItemInfo":[{"AccountingDocNumber":"","Credit":"0.0","Debit":"0.0","DocType":"","DocumentHeaderText":"","PostDate":"0000-00-00","ReferebceChqNumber":"","RunningBalance":"0.0","SGTXT":""}]}');
            return res;
        }
    }
    
    static testMethod void wrapperUnitTest() {
        ConnectAccSummaryController.CreditInfoWrapper cl= new ConnectAccSummaryController.CreditInfoWrapper();
        cl.Balance_Limit=21;
        cl.Credit_Limit=21;
        cl.DistributorCurrencyIsoCode='USD';
        cl.overdue=2;
        cl.Percentage_Used=21;
        cl.Sum_Open_Item=21;
        cl.Used_Limit=21;
        
        ConnectAccSummaryController.wrapOauthResponse wor= new ConnectAccSummaryController.wrapOauthResponse();
		wor.access_token='wdq';
        wor.expires_in='21/3/2031';
        wor.scope='sc';
        wor.token_type='tt';
        
        ConnectAccSummaryController.WrapCreditInfo wci= new ConnectAccSummaryController.WrapCreditInfo();
		wci.BalanceLimit='21';
        wci.clean_limit='21';
        wci.company_code='413';
        wci.credit_control='1313';
        wci.Credit_exposure='2w1';
        wci.CreditExposure='yes';
        wci.CreditLimit='lmtd';
        wci.Customer_Credit_Group='ccg';
        wci.Customer_group='cg';
        wci.customer_number='213';
        wci.Line_limit='2121';
        wci.name='name';
        wci.Percentage='21';
        wci.sales_organization='sorg';
        wci.Total_receivables='trec';
        
        
        ConnectAccSummaryController.wrapLedgerInfo ob= new ConnectAccSummaryController.wrapLedgerInfo();
        ob.Credit='Credit';
        ob.Debit='Debit';
        
         ConnectAccSummaryController.wrapCustomerInfo ob1= new ConnectAccSummaryController.wrapCustomerInfo();
        ob1.closingBalance='closingBalance';
        
        
        ConnectAccSummaryController.Item ob2= new ConnectAccSummaryController.Item();
        ob2.customerNumber='customerNumber';
        ob2.custName='custName';
        ob2.bucket1='bucket1';
         ob2.bucket2='bucket2';
         ob2.bucket3='bucket3';
         ob2.bucket4='bucket4';
         ob2.bucket5='bucket5';
         ob2.bucket6='bucket6';
         ob2.bucket7='bucket7';
         ob2.bucket8='bucket8';
         ob2.bucket9='bucket9';
         ob2.totalOutstanding='totalOutstanding';
         ob2.unadjustedReceipts='unadjustedReceipts';
         ob2.unadjustedCredits='unadjustedCredits';
         ob2.netOutstanding='netOutstanding';
         ob2.currencyKey='currencyKey';
        
        
         ConnectAccSummaryController.OutstandingAgeingWrapper ob3= new ConnectAccSummaryController.OutstandingAgeingWrapper();
        
        ob3.o0_30=30;
        ob3.o31_60=60;
        ob3.o61_75=75;
        ob3.o76_90=90;
        ob3.Above_90=100;
        ob3.Net_Outstanding=101;
        ob3.LastModifiedDate=system.today();
        ob3.currencyKey123='currencyKey123';
        
    }
    static testMethod void myUnitTest() {
        
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');   
        String orgId = UserInfo.getOrganizationId();
        String uniqueName = orgId + dateString + randomInt;
        Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
 
        Sales_Org__c org =new Sales_Org__c();
        org.Name='Turkey';
        org.Description__c='Turkey';
        org.Sales_Org_Code__c='7110';
        insert org;
        
        Account a1 = new Account();
        a1.Name = 'Test';
        a1.RecordTypeId = RecordTypeId;
        a1.SAP_Code__c = '12346';
        a1.Sap_UserId__c = 'UPLINTCRM';
        a1.CurrencyIsoCode = '';
        a1.Sales_Org__c=org.Id;
        insert a1;
        
        Contact c = new Contact();
        c.AccountId=a1.Id;
        c.LastName='Test';
        insert c; 
        
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
        
        
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        Id devRecordforCC = Schema.SObjectType.Community_Configuration__c.getRecordTypeInfosByName().get('Account Summary').getRecordTypeId();
        
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
        acc.Sap_UserId__c = 'UPLINTCRM';
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
        //acc.OwnerId=sobj.Id;
        insert acc;
        
        
        Credit_Info__c sobj = new Credit_Info__c(
            Sales_Org__c = sorg.Id ,        // Sales Org
            Distributor__c = acc.Id,      // Distributor
            Distributor_Code__c = '00010101341210',  // Distributor Code
            Credit_Limit__c = 0.00,                  // Credit Limit
            Internal_Limit__c = 0.00,                // Internal Limit
            Used_Limit__c = 20306.31,                // Used Limit
            Balance_Limit__c = 20306.31,             // Balance Limit
            Percentage_Used__c = 0.00,             // Percentage Used
            Sum_Open_Item__c = 20306            // Outstanding
        );
        insert sobj;
        
        /* Account_Statement__c accStateObj = new Account_Statement__c(
Account__c = acc.Id,  // Account
Opening_Balance__c = 0.00,     // Opening Balance
SAP_Code__c = '00010370541210'  // SAP Code
);
insert accStateObj;*/
        
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
            Image__c = '\n',                             // Image
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
        
        Community_Endpoints__c cLedger =new Community_Endpoints__c();
        cLedger.Name='Customer Ledger';
        cLedger.URL__c='https://l4097-iflmap.hcisbp.eu1.hana.ondemand.com/http/CustomerLedger_NL';
        insert cLedger;
		
        Community_Endpoints__c credinfo =new Community_Endpoints__c();
        credinfo.Name='Credit Summary';
        credinfo.URL__c='https://l4097-iflmap.hcisbp.eu1.hana.ondemand.com/http/CreditSummary_NL';
        insert credinfo;
        
        Community_Endpoints__c customOut =new Community_Endpoints__c();
        customOut.Name='Customer Outstanding';
        customOut.URL__c='https://l4097-iflmap.hcisbp.eu1.hana.ondemand.com/http/CustomerOutstanding_NL';
        insert customOut;
        
        Community_Url_Configuration__c url = new Community_Url_Configuration__c();
        url.Name='Distributors Community URL';
        url.URL__c='https://uat-upl.cs117.force.com/Distributor';
        insert url;
        
        
        
        
        
        
        System.runAs ( new User(Id = UserInfo.getUserId()) ) {
            UserRole r = [select id from UserRole where name = 'UPL Management'];
            UserLicense licence = [SELECT Id FROM UserLicense where name ='Customer Community Plus'];
            Profile p = [SELECT Id FROM Profile WHERE UserLicenseId = : licence.Id Limit 1]; 
            
            User comUser = new User(alias = 'test123', 
                                    email='test123@noemail.com',
                                    emailencodingkey='UTF-8', 
                                    lastname='Testing123', 
                                    languagelocalekey='en_US',
                                    localesidkey='en_US', 
                                    profileid = p.Id, 
                                    country='Spain',
                                    Community_Role__c ='1',
                                    IsActive =true,
                                    contactId=contactObj.Id,
                                    timezonesidkey='America/Los_Angeles', 
                                    username='newone@noemail.com');
            insert comuser;
        }
        
        User cuser = [select id from user where username ='newone@noemail.com' limit 1];
        
        test.startTest();
          Test.setMock(HttpCalloutMock.class, new ExampleCalloutMock2());
        ConnectAccSummaryController.showHideDetailsInfo();
        ConnectAccSummaryController.getting_Credit_Information();
        ConnectAccSummaryController.getting_Credit_Information1();// api call
        ConnectAccSummaryController.account_Statement_Information();// api call
        ConnectAccSummaryController.outstanding_Ageing_Information();
        ConnectAccSummaryController.collection_Information();
       // ConnectAccSummaryController.accountStatement();//api call
        ConnectAccSummaryController.gettingOverdue();
        ConnectAccSummaryController.gettingUrlAddress();
        ConnectAccSummaryController.getCreditSummary(); // api call
        test.stopTest();
        
        
        /*System.RunAs(cuser) {
            //ConnectAccSummaryController tmpObj = new ConnectAccSummaryController();
            ConnectAccSummaryController.showHideDetailsInfo();
            ConnectAccSummaryController.getting_Credit_Information();
            //Test.setMock(HttpCalloutMock.class, new CommunityTokenMock());
            //wrapOauthResponse strResp = ConnectAccSummaryController.account_Statement_Information();
            ConnectAccSummaryController.getting_Credit_Information1();
            //ConnectAccSummaryController.account_Statement_Information();
            ConnectAccSummaryController.outstanding_Ageing_Information();
            ConnectAccSummaryController.collection_Information();
            
            ConnectAccSummaryController.gettingUrlAddress();
            ConnectAccSummaryController.CreditInfoWrapper ciwrap = new ConnectAccSummaryController.CreditInfoWrapper();
            ConnectAccSummaryController.OutstandingAgeingWrapper owrap = new ConnectAccSummaryController.OutstandingAgeingWrapper();
            ConnectAccSummaryController.wrapOauthResponse wrapOauth = new ConnectAccSummaryController.wrapOauthResponse();
            ConnectAccSummaryController.WrapCreditInfo wrapCI=new ConnectAccSummaryController.WrapCreditInfo();
            ConnectAccSummaryController.wrapOutstanding wrapOut=new ConnectAccSummaryController.wrapOutstanding();
            ConnectAccSummaryController.wrapCustomerInfo wrapCInfo=new ConnectAccSummaryController.wrapCustomerInfo();
            ConnectAccSummaryController.wrapLedgerInfo wrapLedger=new ConnectAccSummaryController.wrapLedgerInfo();
            ConnectAccSummaryController.accountStatement();
        } */ 
        
        /*System.RunAs(u) {
            //ConnectAccSummaryController tmpObj = new ConnectAccSummaryController();
            
            Test.startTest();
            ConnectAccSummaryController.showHideDetailsInfo();
           // Test.setMock(HttpCalloutMock.class, new ExampleCalloutMock());
            //Test.setMock(HttpCalloutMock.class, new ExampleCalloutMock2());            
           // ConnectAccSummaryController.account_Statement_Information();
            ConnectAccSummaryController.getting_Credit_Information();
            ConnectAccSummaryController.outstanding_Ageing_Information();
            ConnectAccSummaryController.collection_Information();
            //Test.setMock(HttpCalloutMock.class, new ExampleCalloutMock());
            //ConnectAccSummaryController.getCreditSummary();
            Test.stopTest();
           
        } */ 
        
    }
    
    static testMethod void myUnitTest1() {
        
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');   
        String orgId = UserInfo.getOrganizationId();
        String uniqueName = orgId + dateString + randomInt;
        Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
 
        Sales_Org__c org =new Sales_Org__c();
        org.Name='Japan';
        org.Description__c='Japan';
        org.Sales_Org_Code__c='7110';
        insert org;
        
        Account a1 = new Account();
        a1.Name = 'Test';
        a1.RecordTypeId = RecordTypeId;
        a1.SAP_Code__c = '12346';
        a1.Sap_UserId__c = 'UPLINTCRM';
        a1.CurrencyIsoCode = '';
        a1.Sales_Org__c=org.Id;
        insert a1;
        
        Contact c = new Contact();
        c.AccountId=a1.Id;
        c.LastName='Test';
        insert c; 
        
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
        
        
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        Id devRecordforCC = Schema.SObjectType.Community_Configuration__c.getRecordTypeInfosByName().get('Account Summary').getRecordTypeId();
        
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
        acc.Sap_UserId__c = 'UPLINTCRM';
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
        //acc.OwnerId=sobj.Id;
        insert acc;
        
        
        Credit_Info__c sobj = new Credit_Info__c(
            Sales_Org__c = sorg.Id ,        // Sales Org
            Distributor__c = acc.Id,      // Distributor
            Distributor_Code__c = '00010101341210',  // Distributor Code
            Credit_Limit__c = 0.00,                  // Credit Limit
            Internal_Limit__c = 0.00,                // Internal Limit
            Used_Limit__c = 20306.31,                // Used Limit
            Balance_Limit__c = 20306.31,             // Balance Limit
            Percentage_Used__c = 0.00,             // Percentage Used
            Sum_Open_Item__c = 20306            // Outstanding
        );
        insert sobj;
        
        /* Account_Statement__c accStateObj = new Account_Statement__c(
Account__c = acc.Id,  // Account
Opening_Balance__c = 0.00,     // Opening Balance
SAP_Code__c = '00010370541210'  // SAP Code
);
insert accStateObj;*/
        
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
            Image__c = '\n',                             // Image
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
        
        Community_Endpoints__c cLedger =new Community_Endpoints__c();
        cLedger.Name='Customer Ledger';
        cLedger.URL__c='https://l4097-iflmap.hcisbp.eu1.hana.ondemand.com/http/CustomerLedger_NL';
        insert cLedger;
		
        Community_Endpoints__c credinfo =new Community_Endpoints__c();
        credinfo.Name='Credit Summary';
        credinfo.URL__c='https://l4097-iflmap.hcisbp.eu1.hana.ondemand.com/http/CreditSummary_NL';
        insert credinfo;
        
        Community_Endpoints__c customOut =new Community_Endpoints__c();
        customOut.Name='Customer Outstanding';
        customOut.URL__c='https://l4097-iflmap.hcisbp.eu1.hana.ondemand.com/http/CustomerOutstanding_NL';
        insert customOut;
        
        Community_Url_Configuration__c url = new Community_Url_Configuration__c();
        url.Name='Distributors Community URL';
        url.URL__c='https://uat-upl.cs117.force.com/Distributor';
        insert url;
        
        
        
        
        
        
        System.runAs ( new User(Id = UserInfo.getUserId()) ) {
            UserRole r = [select id from UserRole where name = 'UPL Management'];
            UserLicense licence = [SELECT Id FROM UserLicense where name ='Customer Community Plus'];
            Profile p = [SELECT Id FROM Profile WHERE UserLicenseId = : licence.Id Limit 1]; 
            
            User comUser = new User(alias = 'test1234', 
                                    email='test1234@noemail.com',
                                    emailencodingkey='UTF-8', 
                                    lastname='Testing1234', 
                                    languagelocalekey='en_US',
                                    localesidkey='en_US', 
                                    profileid = p.Id, 
                                    country='Spain',
                                    Community_Role__c ='1',
                                    IsActive =true,
                                    contactId=contactObj.Id,
                                    timezonesidkey='America/Los_Angeles', 
                                    username='newone@noemail.com');
            insert comuser;
        }
        
        User cuser = [select id from user where username ='newone@noemail.com' limit 1];
        
        test.startTest();
          Test.setMock(HttpCalloutMock.class, new ExampleCalloutMock2());
        ConnectAccSummaryController.showHideDetailsInfo();
        ConnectAccSummaryController.getting_Credit_Information();
        ConnectAccSummaryController.getting_Credit_Information1();// api call
        ConnectAccSummaryController.account_Statement_Information();// api call
        ConnectAccSummaryController.outstanding_Ageing_Information();
        ConnectAccSummaryController.collection_Information();
       // ConnectAccSummaryController.accountStatement();//api call
        ConnectAccSummaryController.gettingOverdue();
        ConnectAccSummaryController.gettingUrlAddress();
        ConnectAccSummaryController.getCreditSummary(); // api call
        test.stopTest(); 
        
    }
}