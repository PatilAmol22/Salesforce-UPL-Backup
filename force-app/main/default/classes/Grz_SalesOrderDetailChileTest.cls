@isTest
public class Grz_SalesOrderDetailChileTest {
    Public  static testmethod void testgetProductDetailListChile(){
        Test.startTest();   
        Id recordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Sales_Org__c sOrg = Grz_TestDataFactory.createSalesOrg(true, 'Chile','5661');
        Account acc = Grz_TestDataFactory.createUserAccount(true, 'Test Account',recordTypeId,sOrg.Id);
        
        
        Sales_Order__c salesObj = Grz_TestDataFactory.createSalesOrderRecord(false, '7062140268','Approved',Date.today(), acc.Id);
        salesObj.Currency_Brazil__c = 'Billing BRL / Payment BRL';
        insert salesObj;

        Sales_Order_Line_Item__c soi = new Sales_Order_Line_Item__c();
        soi.Sale_Order__c = salesObj.Id;
        soi.Per_Unit_Discount__c = 20;
        soi.Quantity__c = 30;
        soi.UnitValue__c = 30;
        insert soi;
        Invoice__c invo = Grz_TestDataFactory.createInvoice(false, acc.Id);
        invo.Sales_Order__c = salesObj.Id;
        invo.Folio__c = '1234567';
        invo.Delivery_Number__c = '12345';
        invo.Billing_Date__c = Date.newInstance(2020, 12, 9);
        insert invo;
        Dispatch__c dis = new Dispatch__c();
        dis.Sales_Order__c = salesObj.Id;
        dis.SKUDescription__c = 'AZOTE';
        dis.Quantity__c = 20;
        dis.SalesOrderLineItem__c = soi.Id;
        dis.SalesOrg__c = sOrg.Id;
        dis.Reference_Number__c = 'GD107948';
        dis.Deliverynumber__c = '12345';
        dis.Batch__c = '213';
        insert dis;
        Test.stopTest(); 
       
        Grz_SalesOrderDetailChile.getProductDetailList(String.valueOf(salesObj.Id));
        Grz_SalesOrderDetailChile.getPoDocument(salesObj.Id);
        Grz_SalesOrderDetailChile.getPDF('Invoice', invo.Id, '');
        Grz_SalesOrderDetailChile.getPDF('Delivery', soi.Id, '');
        
    }
    Public  static testmethod void testCalloutChile(){
        Grz_SalesOrderDetailChile.getDataFromDBNet('12345', '32', '12345', '2020-01-01', '12345'); 
        Grz_SalesOrderDetailChile.ResultWrapper wr = new Grz_SalesOrderDetailChile.ResultWrapper();
        wr.fileName = 'test';
        wr.fileContent = 'test';
        Grz_SalesOrderDetailChile.LineItemWrap lw = new Grz_SalesOrderDetailChile.LineItemWrap();
        lw.quantity = '1';
        lw.unitPrice = '1';
        lw.unitPrice = '1';
        Grz_SalesOrderDetailChile.ProductDetailWrapper pd = new Grz_SalesOrderDetailChile.ProductDetailWrapper();
        pd.poDate = '1';
        pd.poDocLink = '1';
        pd.orderTotal = '1';
        
    }
}