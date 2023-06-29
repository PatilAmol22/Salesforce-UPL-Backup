@isTest
public class AccountStatementReportCtrl_Test {
    
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

    static testMethod void myUnitTest() {
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');   
        String orgId = UserInfo.getOrganizationId();
        String uniqueName = orgId + dateString + randomInt;
        Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        
		Integer randomInt1 = Integer.valueOf(math.rint(math.random()*1000000));
        String dateString1 = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');   
        String orgId1 = UserInfo.getOrganizationId();
        String uniqueName1 = orgId1 + dateString1 + randomInt1;
        
        Sales_Org__c org =new Sales_Org__c();
        org.Name='Turkey';
        org.Description__c='Turkey';
        org.Sales_Org_Code__c='7110';
        insert org;
        
        Sales_Org__c org1 =new Sales_Org__c();
        org1.Name='Japan';
        org1.Description__c='Japan';
        org1.Sales_Org_Code__c='6731';
        insert org1;
        
        Account a = new Account();
        a.Name = 'Test';
        a.RecordTypeId = RecordTypeId;
        a.SAP_Code__c = '12346';
        a.CurrencyIsoCode = '';
        a.Sales_Org__c=org.Id;
        insert a;
        
        Contact c = new Contact();
        c.AccountId=a.Id;
        c.LastName='Test';
        insert c; 
        
        Account a1 = new Account();
        a1.Name = 'Test123';
        a1.RecordTypeId = RecordTypeId;
        a1.SAP_Code__c = '123';
        a1.CurrencyIsoCode = '';
        a1.Sap_UserId__c = 'UPLINTCRM';
        a1.Sales_Org__c=org1.Id;
        insert a1;
        
        Contact c1 = new Contact();
        c1.AccountId=a1.Id;
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
            Country = 'Japan',
      //      ContactId=c.Id,
            LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = profile,                 
            TimeZoneSidKey='America/Los_Angeles',
            email = uniqueName1 + '@test' + orgId1 + '.org',
         //   UserRoleId = userRole1.Id,
           ContactId = c1.Id ,            
            Username = uniqueName1 + '@test' + orgId1 + '.org');
        	
        insert u1;
        
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
        
        System.RunAs(u) {
            AccountStatementReportCtrl tmpObj = new AccountStatementReportCtrl();
            AccountStatementReportCtrl.wrapAccountStatement creditInfo = new AccountStatementReportCtrl.wrapAccountStatement();
            AccountStatementReportCtrl.wrapOauthResponse Response = new AccountStatementReportCtrl.wrapOauthResponse();
            AccountStatementReportCtrl.wrapCustomerInfo WrapCredit = new AccountStatementReportCtrl.wrapCustomerInfo();
            AccountStatementReportCtrl.wrapLedgerInfo Outstanding = new AccountStatementReportCtrl.wrapLedgerInfo();
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new ExampleCalloutMock());
            Test.setMock(HttpCalloutMock.class, new ExampleCalloutMock2()); 
            tmpObj.displayAccountStatement();
            Test.stopTest();
        } 
    }
}