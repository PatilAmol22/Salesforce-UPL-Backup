@isTest
public class CreateCaseTest {
    static testMethod void method(){
        
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        
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
   
        
        
        Account acc = new Account();
        acc.Name='Bhavik Devdhar';
      
        acc.Last_Name__c='Devdhar';
        acc.PriceGroupCode__c=pg.id;
        acc.SAP_Code__c='SAP996734';
        acc.RecordTypeId=devRecordTypeId;
        acc.Mobile__c='9967341759';
        acc.Phone='020256589';
        insert acc;
        
        
        Account_Ledger__c Accledger = new Account_Ledger__c();
        Accledger.Customer__c = acc.id;       
        Accledger.Doc_Amount__c = 10000;                    
        Accledger.Doc_Number__c = '4252';                    
        Accledger.Doc_Type__c = 'Registration';                
        Accledger.Posting_Date__c =System.today(); 
 //       Accledger.Customer_Code__c='C1'; // Not require Sandip Atkari commented this line - 22/09/2016
        insert Accledger;
        PageReference pageRef = Page.CreateCaseAccount;
        Test.setCurrentPage(pageRef);
        apexpages.currentpage().getparameters().put('id',Accledger.id );
        
        ApexPages.StandardController sc = new ApexPages.StandardController(Accledger);
        CreateCase caseObj = new CreateCase(sc);
        caseObj.startDate=system.today();
        caseObj.EndDate=system.today()+1;
        caseObj.test();
    }
}