@isTest
public class ErrorMessageTest {
   /* @isTest
    static void test1(){
        //prerequisite for account
        Auto_Number__c auto = new Auto_Number__c();
        auto.Name='FarmerCode';
        auto.Sequence__c='11';
        insert auto;
        
        //Prerequisite for account and case object
        Trigger_Settings__c tsObj1 = new Trigger_Settings__c();
        tsObj1.Name = 'CaseTrigger';
        tsObj1.isActive__c = True;
        insert tsObj1;
        
        Account acc= new Account();
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('US Distributor').getRecordTypeId();
        acc.Name = 'Account';
        acc.BillingStreet = 'DSP road';
        acc.BillingCity = 'MUMBAI';
        acc.BillingCountry = 'INDIA';
        acc.BillingState = 'MAHARASHTRA';
        acc.BillingPostalCode = '400068';
        acc.Phone='1010101004';
        acc.WRMS_Code__c='1222';
        acc.UPI_Division__c = 'AG';
        insert acc; 
        
        Sales_Order__c so  =  new Sales_Order__c();
        so.Sold_to_Party__c = acc.id;
        so.ErrorMessage__c = 'Error!';
        insert so;
        
        Transaction_Log__c tl = new Transaction_Log__c();
        tl.Sales_Order__c = so.Id;
        tl.Status__c = 'Failed';
        insert tl;
        
        Sales_Order__c so1  =  new Sales_Order__c();
        so1.Sold_to_Party__c = acc.id;
        insert so1;
        
        Transaction_Log__c tl1 = new Transaction_Log__c();
        tl1.Sales_Order__c = so1.Id;
        tl1.Status__c = 'Failed';
        insert tl1;
        
    } */  
    
    @isTest
    static void test2(){
        //prerequisite for account
        Auto_Number__c auto = new Auto_Number__c();
        auto.Name='FarmerCode';
        auto.Sequence__c='11';
        insert auto;
        
        //Prerequisite for account and case object
        Trigger_Settings__c tsObj1 = new Trigger_Settings__c();
        tsObj1.Name = 'CaseTrigger';
        tsObj1.isActive__c = True;
        insert tsObj1;
        
        Account acc= new Account();
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('US Distributor').getRecordTypeId();
        acc.Name = 'Account';
        acc.BillingStreet = 'DSP road';
        acc.BillingCity = 'MUMBAI';
        acc.BillingCountry = 'INDIA';
        acc.BillingState = 'MAHARASHTRA';
        acc.BillingPostalCode = '400068';
        acc.Phone='1010101004';
        acc.WRMS_Code__c='1222';
        acc.UPI_Division__c = 'AG';
        insert acc; 
        
        Sales_Order__c so1  =  new Sales_Order__c();
        so1.Sold_to_Party__c = acc.id;
        so1.ErrorMessage__c = 'Error!';
        insert so1;
        
        Sales_Order__c so2  =  new Sales_Order__c();
        so2.Sold_to_Party__c = acc.id;
        so2.Order_cancellation_error_message__c = 'Error';
        so2.ErrorMessage__c = 'E';
        insert so2;
        
        Sales_Order__c so3  =  new Sales_Order__c();
        so3.Sold_to_Party__c = acc.Id;
        insert so3;
        
        Sales_Order_Line_Item__c soliObj  = new Sales_Order_Line_Item__c();
        soliObj.Sale_Order__c = so2.Id;
        insert soliObj;
        
        Transaction_Log__c tl = new Transaction_Log__c();
        tl.Sales_Order__c = so1.Id;
        tl.Sales_Order_Line_Item__c = soliObj.Id;
        tl.Status__c = 'Failed';
        insert tl;
          
        Sales_Order_Line_Item__c soliObj1  = new Sales_Order_Line_Item__c();
        soliObj1.Sale_Order__c = so1.Id;
        insert soliObj1;
        
        Transaction_Log__c tl1 = new Transaction_Log__c();
        tl1.Sales_Order__c = so2.Id;
        tl1.Sales_Order_Line_Item__c = soliObj1.Id;
        tl1.Status__c = 'Failed';
        insert tl1;
        
       /* Sales_Order_Line_Item__c soliObj2  = new Sales_Order_Line_Item__c();
        soliObj2.Sale_Order__c = so2.Id;
        soliObj2.Item_Message__c = 'Sales Order Line Item';
       // insert soliObj2;
        
        Transaction_Log__c tl2 = new Transaction_Log__c();
        tl2.Sales_Order__c = so2.Id;
        tl2.Sales_Order_Line_Item__c = soliObj2.Id;
        tl2.Status__c = 'Failed';
        insert tl2;
		*/
 
    }
    
}