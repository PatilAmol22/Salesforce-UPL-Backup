@isTest
public class Grz_Top10ProductMxControllerTest {
	
    public static testmethod void testgetTop10ProductCustomer(){
        Id recordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Account acc = Grz_TestDataFactory.createAccount(true,'Test Account',recordTypeId);
        Sales_Org__c sorgMx = Grz_TestDataFactory.createSalesOrg(true, 'Mexico','5100');
        List<Sales_Order__c> saleList = new List<Sales_Order__c>();
        
        Sales_Order__c salesObj = Grz_TestDataFactory.createSalesOrderRecord(false, '5434265676','Approved',Date.today(), acc.Id);
        salesObj.Sales_Org_lk__c = sorgMx.Id;
        salesObj.Total_Amount__c = 5000;
        Sales_Order__c salesObj1 = Grz_TestDataFactory.createSalesOrderRecord(false, '','Open',Date.today(), acc.Id);
        salesObj1.Sales_Org_lk__c = sorgMx.Id;
        salesObj1.Total_Amount__c = 15000;
        saleList.add(salesObj);
        saleList.add(salesObj1);
        insert saleList;
        
        SKU__c sku = Grz_TestDataFactory.createSKU(false);
        sku.Brand_Name__c = 'TERRAVAX';
        insert sku;
        
        Sales_Order_Line_Item__c saleline = Grz_TestDataFactory.createsalesLineItemsRecord(false, salesObj.Id, 20);
        saleline.Price__c = 200;
        saleline.Quantity__c = 10;
        saleline.SKU_Name__c = sku.Id;
        insert saleline;
        
        Test.startTest();
        Grz_Top10ProductMxController.getTop10ProductCustomer();
        Test.stopTest();
        
    }
}