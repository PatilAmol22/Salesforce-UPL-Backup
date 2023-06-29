@isTest(SeeAllData=false)
public class OverdueSummaryTest {
    static testMethod void validateHelloWorld(){
       CustomerTransaction__c CustomerTransactionObj ;//= new CustomerTransaction__c();
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        
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
        acc.Name='vishal pawar';
        acc.Last_Name__c='pawar';
        acc.PriceGroupCode__c=pg.id;
        acc.SAP_Code__c='SAP996734';
        acc.RecordTypeId=devRecordTypeId;
        acc.Mobile__c='9405883688';
        acc.Phone='020256589';
        acc.Sales_Org__c=sorg.Id;
        acc.Division__c=Divbj.Id;
        acc.Distribution_Channel__c=disbj.Id;
        acc.BillingCity='Pune';
        acc.Order_Type__c=ordType.Id;
        acc.Depot_Code__c = 'PUN1';
        //  acc.OwnerId=sobj.Id;
        insert acc;
        
         CustomerTransactionObj = new CustomerTransaction__c(
            DocNumber__c = '2205965379',                // Doc Number
            Sales_Org__c = sorg.Id,             // Sales Org
            Amount__c = 8300.60,                          // Amount
            DocType__c = 'RV',                            // Doc Type
            Payment_Term__c = 30.00,                    // Payment Term
            Billing_Date__c = System.today(),  // Billing Date
            Customer__c = acc.ID,
             Customer_Transaction_Combination_Key__c='Test'
            // CreatedById= acc.Name // Customer
        );
        insert CustomerTransactionObj;
        ApexPages.StandardController sc = new ApexPages.StandardController(acc);
        ApexPages.currentPage().getParameters().put('AccId',acc.ID ); 
        overdueSummaryController OverdueSummaryControllerObj = new OverdueSummaryController(sc);
        OverdueSummaryControllerObj.generatePDF();
        OverdueSummaryPDFController overdueSummaryPDFControllerObj = new OverdueSummaryPDFController();
        
       
    }
    
}