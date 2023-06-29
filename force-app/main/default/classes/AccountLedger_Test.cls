@isTest
public class AccountLedger_Test {
    @isTest
    public static void alTest(){
        CustomerTransaction__c CustomerTransactionObj ;//= new CustomerTransaction__c();
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        Id comRecordTypeId = Schema.SObjectType.Community_Configuration__c.getRecordTypeInfosByName().get('Account Summary').getRecordTypeId();
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');   
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        String orgId = UserInfo.getOrganizationId();
        String uniqueName = orgId + dateString + randomInt;
        
        Community_Configuration__c cc=new Community_Configuration__c();
        cc.Show_Running_Balance__c=true;
        cc.Company_Address__c='a1';
        cc.Company_Contact_Number__c='123';
        cc.Company_Name__c='c1';
        cc.Country__c='Poland';
        cc.RecordTypeId=comRecordTypeId;
        insert cc;
        
        Sales_Org__c sorg =new Sales_Org__c();
        sorg.Name='1000';
        sorg.Description__c='India';
        sorg.Sales_Org_Code__c='1000';
        insert sorg;
        
        Price_Group_Master__c pg = new Price_Group_Master__c ();
        pg.PG_Code__c='03';
        insert Pg;
        
        Auto_Number__c auto = new Auto_Number__c();
        auto.Name='FarmerCode';
        auto.Sequence__c='11';
        insert auto;
        
        Trigger_Settings__c tsObj = new Trigger_Settings__c();
        tsObj.Name = 'CaseTrigger';
        tsObj.isActive__c = True;
        insert tsObj;
        
        
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
        
        Order_Type__c ordType =new Order_Type__c();
        ordType.Name = 'ZORD';              
        ordType.Description__c = 'India';    
        ordType.Order_Type_Code__c = 'ZORD';
        insert ordType;
        
        Account acc = new Account();
        acc.Name='Test';
        //acc.Last_Name__c='pawar';
        //acc.PriceGroupCode__c=pg.id;
        acc.SAP_Code__c='SAP996734';
        acc.RecordTypeId=devRecordTypeId;
        //acc.Mobile__c='9405883688';
        //acc.Phone='020256589';
        //acc.Sales_Org__c=sorg.Id;
        //acc.Division__c=Divbj.Id;
        //acc.Distribution_Channel__c=disbj.Id;
        //acc.BillingCity='Pune';
        //acc.Order_Type__c=ordType.Id;
        //acc.Depot_Code__c = 'PUN1';
        //  acc.OwnerId=sobj.Id;
        insert acc;
        
        Periodical_Closing_Balance__c pcb=new Periodical_Closing_Balance__c();
        pcb.Closing_Balance__c=11000;
        pcb.Debit__c=1000;
        pcb.Debit__c=1000;
        pcb.Month__c='jan';
        pcb.Year__c='2020';
        insert pcb;
        
        CustomerTransactionObj = new CustomerTransaction__c(
            DocNumber__c = '2205965379',                // Doc Number
            Sales_Org__c = sorg.Id,             // Sales Org
            Amount__c = 8300.60,                          // Amount
            DocType__c = 'RV',                            // Doc Type
            Payment_Term__c = 30.00,                    // Payment Term
            Billing_Date__c = System.today(),  // Billing Date
            Customer__c = acc.ID,              // Customer
            PostingDate__c=date.today()+5,
            Reference__c='1234',
            Head_Text__c='1234',
            Status__c='H',
            CurrencyIsoCode='CPO'
        );
        
        Contact c = new Contact();
        c.AccountId=acc.Id;
        c.LastName='Test';
        insert c; 
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        
     //     UserRole userRole1 = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        User u = new User(Alias = 'standt1', 
            EmailEncodingKey='UTF-8',
            LastName='Testing',
            Country = 'Poland',
      //      ContactId=c.Id,
            LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', 
            ProfileId = p.Id,                 
            TimeZoneSidKey='America/Los_Angeles',
            email = uniqueName + '@test' + orgId + '.org',
         //   UserRoleId = userRole1.Id,             
            Username = uniqueName + '@test' + orgId + '.org');
        insert u;
        
        test.startTest();
        PageReference pageRef = Page.CustomerLedgerReport;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('DateFrom', '2019-06-15');
        pageRef.getParameters().put('DateTo', '2019-06-15');
        pageRef.getParameters().put('AccId', '');
        pageRef.getParameters().put('Month', '6');
        pageRef.getParameters().put('Cyear','2020');
        pageRef.getParameters().put('reportDate', '');
        pageRef.getParameters().put('fDate', '');
        pageRef.getParameters().put('tDate', '');
        AccountLedger.fetchUser();
        AccountLedger.fetchCommunityObj();
        AccountLedger.getALData('2019-06-15','2019-07-15',acc.id,'6');
        AccountLedger al1=new AccountLedger();
        
        system.runAs(u){
            PageReference pageRef2 = Page.CustomerLedgerReport;
            Test.setCurrentPage(pageRef2);
            pageRef2.getParameters().put('DateFrom', '2019-06-15');
            pageRef2.getParameters().put('DateTo', '2019-06-15');
            pageRef2.getParameters().put('AccId', acc.id);
            pageRef2.getParameters().put('Month', '6');
            pageRef2.getParameters().put('Cyear','2020');
            pageRef2.getParameters().put('reportDate', '2019-06-15');
            pageRef2.getParameters().put('fDate', '2019-06-15');
            pageRef2.getParameters().put('tDate', '2019-06-15');
            AccountLedger al2=new AccountLedger();
            
        }
test.stopTest();        
    }
}