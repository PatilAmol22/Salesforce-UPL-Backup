@isTest(seeAllData=false)
public class invoiceUpdateBatchTest {
    
    @isTest
    static void TestInvoiceUpdateBatch(){
      Id RecordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
      
      Sales_Org__c s1 = new Sales_Org__c();
      s1.Name='Test';
      s1.Sales_Org_Code__c='2481';
      insert s1;
     
        
      Account testAccount = new Account();
      testAccount.Name='Test Account' ;
      testAccount.RecordTypeId = RecordTypeIdAccount;
      testAccount.SAP_Code__c = '12345';
      testAccount.Account_Type__c = 'Sold To Party';
      testAccount.Sales_Org__c=s1.Id;
      insert testAccount; 
                
      Invoice__c i = new Invoice__c();
      i.Check_Attachment_File__c = false;
      i.Sales_Org__c = s1.Id; 
      i.Sold_To_Party__c = testAccount.Id;
      insert i; 
        
        invoiceUpdateBatch a = new invoiceUpdateBatch();      
        Database.executeBatch(a);
    }
}