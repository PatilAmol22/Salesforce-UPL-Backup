@isTest
public class Grz_SalesOrderDetailMexicoTest {
	Public  static testmethod void testgetProductDetailListmexico(){        
        Id recordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Sales_Org__c sorgMx = Grz_TestDataFactory.createSalesOrg(true, 'Mexico','5100');
        Account acc = Grz_TestDataFactory.createUserAccount(true, 'Test Account',recordTypeId,sorgMx.Id);
        Sales_Order__c salesObj = Grz_TestDataFactory.createSalesOrderRecord(false, '7062140268','Approved',Date.today(), acc.Id);
        salesObj.Sales_Org_lk__c = sorgMx.Id;
        salesObj.Total_Amount__c = 5000;
        insert salesObj;
        Invoice__c invo = Grz_TestDataFactory.createInvoice(false, acc.Id);
        invo.Sales_Order__c = salesObj.Id;
        invo.Billing_Date__c = Date.newInstance(2020, 12, 9);
        invo.Mexico_E_Invoice__c = 'JVBERi0xLjQKJdP0zOEKMSAwIG9iago8PAovQ3';
        insert invo;
        Test.startTest();   
        Sales_Order_Line_Item__c lineItem = Grz_TestDataFactory.createsalesLineItemsRecord(false, salesObj.Id, 23);
        lineItem.Quantity__c = 5;
        lineItem.UnitValue__c = 100;
        insert lineItem;
        Grz_TestDataFactory.CreateDispatch(true,acc,'214567121',salesObj.Id,lineItem.Id,sorgMx.Id);
        Grz_SalesOrderDetailMexico.getProductDetailList(String.valueOf(salesObj.Id));
        Test.stopTest();         
    }
}