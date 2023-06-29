@isTest
public class overdueSummaryLWC_Test {
    
    public class ExampleCalloutMock implements HttpCalloutMock{
        public HttpResponse respond(HTTPRequest req){
            HttpResponse res = new HttpResponse();
            res.setStatus('OK');
            res.setStatusCode(200);
            res.setBody('{"access_token": "1da8ec3a6acdbe3f6de71e55ec22a66","token_type": "Bearer","expires_in": 1800,"scope": ""}');
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
    
    public class ExampleCalloutMock3 implements HttpCalloutMock{
        public HttpResponse respond(HTTPRequest req){
            HttpResponse res = new HttpResponse();
            res.setStatus('OK');
            res.setStatusCode(200);
                       //res.setBody('{"Return":[{"CompCode":"5000","Customer":"0001072073","ClearDate":"0000-00-00","AllocNmbr":"2110811073","FiscYear":"2019","DocNo":"0208003563","ItemNum":"002","PstngDate":"2020-03-30","DocDate":"2020-03-30","EntryDate":"2020-03-30","Currency":"MXN","LocCurrcy":"MXN","DocType":"AB","FisPeriod":"12","PostKey":"17","DbCrInd":"H","BusArea":"OTHR","LcAmount":"140120.16","AmtDoccur":"140120.16","LcTax":"0.0","TxDocCur":"0.0","BlineDate":"2020-03-30","DsctDays1":"0","DsctDays2":"0","Netterms":"0","DsctPct1":"0.0","DsctPct2":"0.0","DiscBase":"0.0","DscAmtLc":"0.0","DscAmtDc":"0.0","InvRef":"2110811073","InvYear":"2019","InvItem":"001","LastDunn":"0000-00-00","DunnLevel":"0","NxtDoctyp":"Z","TCurrency":"MXN","Amount":"140120.16","NetAmount":"0.0","Langu":"","BillLife":"0","BilltaxLc":"0.0","BilltaxFc":"0.0","LcColChg":"0.0","CollCharg":"0.0","IssueDate":"0000-00-00","Usagedate":"0000-00-00","DisctDays":"0","DisctRate":"0.0","BillDoc":"2110811073"}]}');
             res.setBody('{"Lineitems":[{"CompCode":"5000","Customer":"0001072073","ClearDate":"0000-00-00","AllocNmbr":"2110811073","FiscYear":"2019","DocNo":"0208003563","ItemNum":"002","PstngDate":"2020-03-30","DocDate":"2020-03-30","EntryDate":"2020-03-30","Currency":"MXN","LocCurrcy":"MXN","DocType":"AB","FisPeriod":"12","PostKey":"17","DbCrInd":"H","BusArea":"OTHR","LcAmount":"140120.16","AmtDoccur":"140120.16","LcTax":"0.0","TxDocCur":"0.0","BlineDate":"2020-03-30","DsctDays1":"0","DsctDays2":"0","Netterms":"0","DsctPct1":"0.0","DsctPct2":"0.0","DiscBase":"0.0","DscAmtLc":"0.0","DscAmtDc":"0.0","InvRef":"2110811073","InvYear":"2019","InvItem":"001","LastDunn":"0000-00-00","DunnLevel":"0","NxtDoctyp":"Z","TCurrency":"MXN","Amount":"140120.16","NetAmount":"0.0","Langu":"","BillLife":"0","BilltaxLc":"0.0","BilltaxFc":"0.0","LcColChg":"0.0","CollCharg":"0.0","IssueDate":"0000-00-00","Usagedate":"0000-00-00","DisctDays":"0","DisctRate":"0.0","BillDoc":"2110811073"}]}');
            return res;
        }
    }
    
    static testmethod void myUnitTest(){
        
        /*String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');   
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        Integer randomInt1 = Integer.valueOf(math.rint(math.random()*1000000));    
        Integer randomInt2 = Integer.valueOf(math.rint(math.random()*1000000));
        Integer randomInt3 = Integer.valueOf(math.rint(math.random()*1000000));
        Integer randomInt4 = Integer.valueOf(math.rint(math.random()*1000000));    
        String orgId = UserInfo.getOrganizationId();
        String uniqueName = orgId + dateString + randomInt;
        String uniqueName1 = orgId + dateString + randomInt1;
        String uniqueName2 = orgId + dateString + randomInt2;  
        String uniqueName3 = orgId + dateString + randomInt3;     
        String uniqueName4 = orgId + dateString + randomInt4;     
        Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        Id RecordTypeId2 = Schema.SObjectType.Community_Configuration__c.getRecordTypeInfosByName().get('General Setting').getRecordTypeId();
        Account a1 = new Account();
        a1.Name = 'Test';
        a1.RecordTypeId = RecordTypeId;
        a1.SAP_Code__c = '12346';
        a1.CurrencyIsoCode = '';
        insert a1;
        
        Contact c = new Contact();
        c.AccountId=a1.Id;
        c.LastName='Test';
        insert c; 
        
        Contact c1 = new Contact();
        c1.AccountId=a1.Id;
        c1.LastName='Test1';
        insert c1; 
        
        Contact c2 = new Contact();
        c2.AccountId=a1.Id;
        c2.LastName='Test2';
        insert c2; 
        
        Contact c3 = new Contact();
        c3.AccountId=a1.Id;
        c3.LastName='Test3';
        insert c3;
        
        Contact c4 = new Contact();
        c4.AccountId=a1.Id;
        c4.LastName='Test4';
        insert c4;
        
        Id p = [select id from profile where name='Partner Community User'].id;
        
        //     UserRole userRole1 = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        User u = new User(Alias = 'standt', 
                          EmailEncodingKey='UTF-8',
                          LastName='Testing',
                          Country = 'Turkey',
                          //      ContactId=c.Id,
                          LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p,                 
                          TimeZoneSidKey='America/Los_Angeles',
                          email = uniqueName + '@test' + orgId + '.org',
                          //   UserRoleId = userRole1.Id,
                          ContactId = c.Id ,            
                          Username = uniqueName + '@test' + orgId + '.org');
        
        insert u;
        
        User u1 = new User(Alias = 'standt1', 
                           EmailEncodingKey='UTF-8',
                           LastName='Testing1',
                           Country = 'Japan',
                           //      ContactId=c.Id,
                           LanguageLocaleKey='en_US', 
                           LocaleSidKey='en_US', ProfileId = p,                 
                           TimeZoneSidKey='America/Los_Angeles',
                           email = uniqueName1 + '@test' + orgId + '.org',
                           ContactId = c1.Id ,                
                           //   UserRoleId = userRole1.Id,             
                           Username = uniqueName1 + '@test' + orgId + '.org');
        insert u1;
        
        User u2 = new User(Alias = 'standt2', 
                           EmailEncodingKey='UTF-8',
                           LastName='Testing2',
                           Country = 'Spain',
                           //      ContactId=c.Id,
                           LanguageLocaleKey='en_US', 
                           LocaleSidKey='en_US', ProfileId = p,                 
                           TimeZoneSidKey='America/Los_Angeles',
                           email = uniqueName2 + '@test' + orgId + '.org',
                           ContactId = c2.Id ,                
                           //   UserRoleId = userRole1.Id,             
                           Username = uniqueName2 + '@test' + orgId + '.org');
        insert u2;
        
        User u3 = new User(Alias = 'standt3', 
                           EmailEncodingKey='UTF-8',
                           LastName='Testing3',
                           Country = 'Colombia',
                           //      ContactId=c.Id,
                           LanguageLocaleKey='en_US', 
                           LocaleSidKey='en_US', ProfileId = p,                 
                           TimeZoneSidKey='America/Los_Angeles',
                           email = uniqueName3 + '@test' + orgId + '.org',
                           ContactId = c3.Id ,                
                           //   UserRoleId = userRole1.Id,             
                           Username = uniqueName3 + '@test' + orgId + '.org');
        insert u3;
        
        User u4 = new User(Alias = 'standt4', 
                           EmailEncodingKey='UTF-8',
                           LastName='Testing4',
                           Country = 'Poland',
                           //      ContactId=c.Id,
                           LanguageLocaleKey='en_US', 
                           LocaleSidKey='en_US', ProfileId = p,                 
                           TimeZoneSidKey='America/Los_Angeles',
                           email = uniqueName4 + '@test' + orgId + '.org',
                           ContactId = c4.Id ,                
                           //   UserRoleId = userRole1.Id,             
                           Username = uniqueName4 + '@test' + orgId + '.org');
        insert u4;
        
        String query = 'SELECT Billing_Date__c, DocNumber__c, Clearing_doc__c, Amount__c, Payment_Term__c, Overdue_Date__c, Status_Formula__c FROM CustomerTransaction__c where Billing_Date__c >= 2019-06-02 AND Billing_Date__c <= 2023-06-02';
        system.debug('test class query --->'+query);
        system.debug('test class account ID ---->'+u.AccountId);
        
        Community_Configuration__c cc = new Community_Configuration__c();
        cc.Company_Name__c='UPL Turkey';
        cc.Company_Address__c='acsvdv';
        cc.Visible_To_All__c=true;
        cc.RecordTypeId=RecordTypeId2;
        cc.Community_User_Role__c='1';
        cc.Active__c=true;
        cc.Country__c='Turkey';
        insert cc;
        
        /*CustomerTransaction__c ct = new CustomerTransaction__c();
ct.Amount__c =1000;
ct.Billing_Date__c=date.today()-5;
ct.Base_Line_Date__c=date.today()-5;
ct.DocNumber__c='12345678';
ct.Clearing_doc__c='1265';
ct.Billing_doc__c='12345';
ct.DocType__c='AB';
ct.Payment_Term__c=0;
ct.Customer__c=a1.Id;
ct.Customer_Transaction_Combination_Key__c='1111111111';
insert ct;

CustomerTransaction__c ct1 = new CustomerTransaction__c();
ct1.Amount__c =1000;
ct1.Billing_Date__c=date.today();
ct1.Base_Line_Date__c=date.today();
ct1.DocNumber__c='12345678';
ct1.Clearing_doc__c='1265';
ct1.Billing_doc__c='12345';
ct1.DocType__c='AB';
ct1.Payment_Term__c=0;
ct1.Customer__c=a1.Id;
ct1.Customer_Transaction_Combination_Key__c='2222222222';
insert ct1;

CustomerTransaction__c ct2 = new CustomerTransaction__c();
ct2.Amount__c =1000;
ct2.Billing_Date__c=date.today()+5;
ct2.Base_Line_Date__c=date.today()+5;
ct2.DocNumber__c='12345678';
ct2.Clearing_doc__c='1265';
ct2.Billing_doc__c='12345';
ct2.DocType__c='AB';
ct2.Payment_Term__c=0;
ct2.Customer__c=a1.Id;
ct2.Customer_Transaction_Combination_Key__c='3333333333';
insert ct2;*/
        
        /*Community_Credentials__c cred = new Community_Credentials__c();
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
        
        Community_Endpoints__c openItem =new Community_Endpoints__c();
        openItem.Name='Open Item';
        openItem.URL__c='https://l4097-iflmap.hcisbp.eu1.hana.ondemand.com/http/OpenInvoices_NL';
        insert openItem;
        
        Community_Url_Configuration__c url = new Community_Url_Configuration__c();
        url.Name='Distributors Community URL';
        url.URL__c='https://uat-upl.cs117.force.com/Distributor';
        insert url;*/
        
        /*system.runAs(u3){
            PageReference pageRef2 = Page.InvoicePaymentDueReport;
            Test.setCurrentPage(pageRef2);
            pageRef2.getParameters().put('DateFrom', '2022-01-01');
            pageRef2.getParameters().put('DateTo', '2022-01-15');
            pageRef2.getParameters().put('AccId', a1.Id);
            pageRef2.getParameters().put('Status', 'Due');
            pageRef2.getParameters().put('PaidUnpaidStatus', 'Paid'); 
            
            //OverDueSummaryLWC_Controller o2 = new OverDueSummaryLWC_Controller();
            //OverDueSummaryLWC_Controller.fetchUser();
            // OverDueSummaryLWC_Controller.fetchURL();
            OverDueSummaryLWC_Controller.getODSData(query, a1.Id);   
            OverDueSummaryLWC_Controller.wrapOauthResponse wrapOauth = new OverDueSummaryLWC_Controller.wrapOauthResponse();
            OverDueSummaryLWC_Controller.wrapReturn wreturn = new OverDueSummaryLWC_Controller.wrapReturn();
            OverDueSummaryLWC_Controller.WrapOpenItemData wopi = new OverDueSummaryLWC_Controller.WrapOpenItemData();
            OverDueSummaryLWC_Controller.wrapLedgerInfo wli = new OverDueSummaryLWC_Controller.wrapLedgerInfo();      
        }*/
         String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');   
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
         Id p = [select id from profile where name='Partner Community User'].id;
         Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        Id RecordTypeId2 = Schema.SObjectType.Community_Configuration__c.getRecordTypeInfosByName().get('General Setting').getRecordTypeId();
        Account a1 = new Account();
        a1.Name = 'Test';
        a1.RecordTypeId = RecordTypeId;
        a1.SAP_Code__c = '12346';
        a1.CurrencyIsoCode = '';
        insert a1;
       
        
        Contact c = new Contact();
        c.AccountId=a1.Id;
        c.LastName='Test';
        insert c; 
          String uniqueName = orgId + dateString + randomInt;
          User u = new User(Alias = 'standt', 
                          EmailEncodingKey='UTF-8',
                          LastName='Testing',
                          Country = 'Turkey',
                          //      ContactId=c.Id,
                          LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p,                 
                          TimeZoneSidKey='America/Los_Angeles',
                          email = uniqueName + '@test' + orgId + '.org',
                          //   UserRoleId = userRole1.Id,
                          ContactId = c.Id ,            
                          Username = uniqueName + '@test' + orgId + '.org');
        
        insert u;
                String query = 'SELECT Billing_Date__c, DocNumber__c, Clearing_doc__c, Amount__c, Payment_Term__c, Overdue_Date__c, Status_Formula__c FROM CustomerTransaction__c where Billing_Date__c >= 2019-06-02 AND Billing_Date__c <= 2023-06-02';
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
        
        Community_Endpoints__c openItem =new Community_Endpoints__c();
        openItem.Name='Open Item';
        openItem.URL__c='https://l4097-iflmap.hcisbp.eu1.hana.ondemand.com/http/OpenInvoices_NL';
        insert openItem;
        
        Community_Url_Configuration__c url = new Community_Url_Configuration__c();
        url.Name='Distributors Community URL';
        url.URL__c='https://uat-upl.cs117.force.com/Distributor';
        insert url;
        
        OverDueSummaryLWC_Controller.wrapReturn ob= new OverDueSummaryLWC_Controller.wrapReturn();
        ob.Message='Message';
        system.runAs(u){
          Test.startTest(); 
            
           // PageReference pageRef2 = Page.InvoicePaymentDueReport;
            //Test.setCurrentPage(pageRef2);
            //pageRef2.getParameters().put('DateFrom', '');
            //pageRef2.getParameters().put('DateTo', '');
           // pageRef2.getParameters().put('AccId', '');
            //pageRef2.getParameters().put('Status', '');
            //pageRef2.getParameters().put('PaidUnpaidStatus', '');  
            
            //Test.setMock(HttpCalloutMock.class, new ExampleCalloutMock());
            //Test.setMock(HttpCalloutMock.class, new ExampleCalloutMock2());
            //Test.setMock(HttpCalloutMock.class, new ExampleCalloutMock3());
            Test.setMock(HttpCalloutMock.class, new ExampleCalloutMock());
            Test.setMock(HttpCalloutMock.class, new ExampleCalloutMock2());
            Test.setMock(HttpCalloutMock.class, new ExampleCalloutMock3());
            OverDueSummaryLWC_Controller o2 = new OverDueSummaryLWC_Controller();
            OverDueSummaryLWC_Controller.fetchUser();
            OverDueSummaryLWC_Controller.fetchURL();
            OverDueSummaryLWC_Controller.fetchSapData();
             OverDueSummaryLWC_Controller.getODSData(query, a1.Id);  
            /* OverDueSummaryLWC_Controller.wrapOauthResponse wrapOauth = new OverDueSummaryLWC_Controller.wrapOauthResponse();
           
            OverDueSummaryLWC_Controller.wrapReturn wreturn = new OverDueSummaryLWC_Controller.wrapReturn();
            OverDueSummaryLWC_Controller.WrapOpenItemData wopi = new OverDueSummaryLWC_Controller.WrapOpenItemData();
            OverDueSummaryLWC_Controller.wrapLedgerInfo wli = new OverDueSummaryLWC_Controller.wrapLedgerInfo(); */
            Test.stopTest();    
             /* system.runAs(u){
                
                PageReference pageRef3 = Page.InvoicePaymentDueReport;
                Test.setCurrentPage(pageRef3);
                pageRef2.getParameters().put('DateFrom', '');
                pageRef2.getParameters().put('DateTo', '');
                pageRef2.getParameters().put('AccId', '');
                pageRef2.getParameters().put('Status', 'Due');
                pageRef2.getParameters().put('PaidUnpaidStatus', '');  
                Test.startTest(); 
                Test.setMock(HttpCalloutMock.class, new ExampleCalloutMock());
                Test.setMock(HttpCalloutMock.class, new ExampleCalloutMock2());
                Test.setMock(HttpCalloutMock.class, new ExampleCalloutMock3());
                OverDueSummaryLWC_Controller o4 = new OverDueSummaryLWC_Controller();
                OverDueSummaryLWC_Controller.fetchUser();
                OverDueSummaryLWC_Controller.fetchURL();
                OverDueSummaryLWC_Controller.fetchSapData();
                
                Test.stopTest();     
                
            }*/
            /*system.runAs(u){
                
                PageReference pageRef3 = Page.InvoicePaymentDueReport;
                Test.setCurrentPage(pageRef3);
                pageRef2.getParameters().put('DateFrom', '');
                pageRef2.getParameters().put('DateTo', '');
                pageRef2.getParameters().put('AccId', '');
                pageRef2.getParameters().put('Status', '');
                pageRef2.getParameters().put('PaidUnpaidStatus', 'Paid');  
                Test.startTest(); 
                Test.setMock(HttpCalloutMock.class, new ExampleCalloutMock());
                Test.setMock(HttpCalloutMock.class, new ExampleCalloutMock2());
                Test.setMock(HttpCalloutMock.class, new ExampleCalloutMock3());
                OverDueSummaryLWC_Controller o3 = new OverDueSummaryLWC_Controller();
                OverDueSummaryLWC_Controller.fetchUser();
                OverDueSummaryLWC_Controller.fetchURL();
                OverDueSummaryLWC_Controller.fetchSapData();
                
                Test.stopTest();     
                
            } */ 
            //Test.setMock(HttpCalloutMock.class, new ExampleCalloutMock());
            //Test.setMock(HttpCalloutMock.class, new ExampleCalloutMock2());
            //Test.setMock(HttpCalloutMock.class, new ExampleCalloutMock3());    
            //OverDueSummaryLWC_Controller.fetchSapData();
            //OverDueSummaryLWC_Controller.wrapOauthResponse wrapOauth = new OverDueSummaryLWC_Controller.wrapOauthResponse();
            //OverDueSummaryLWC_Controller.wrapReturn wreturn = new OverDueSummaryLWC_Controller.wrapReturn();
            //OverDueSummaryLWC_Controller.WrapOpenItemData wopi = new OverDueSummaryLWC_Controller.WrapOpenItemData();
            //OverDueSummaryLWC_Controller.wrapLedgerInfo wli = new OverDueSummaryLWC_Controller.wrapLedgerInfo();  
                         
        }  
    }
}