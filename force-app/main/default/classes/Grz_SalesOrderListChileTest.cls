@isTest
public class Grz_SalesOrderListChileTest {
    Public  static testmethod void SalesOrderListChile()
    {
        Date startdate = Date.newInstance(2021, 04, 1);
        Date enddate = Date.newInstance(2022, 03, 31);
        Test.startTest();
        Id recordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Account acc = Grz_TestDataFactory.createAccount(true, 'Test Account',recordTypeId);
        Sales_Org__c sorg = Grz_TestDataFactory.createSalesOrg(true, 'Chile', '5661');
        Sales_Order__c salesObj1 = Grz_TestDataFactory.createSalesOrderRecord(false, '7062133268','Approved',Date.today(), acc.Id);
        salesObj1.Sales_Org_lk__c = sorg.Id;
        salesObj1.Purchase_Order_Date__c = Date.newInstance(2020, 03, 31);
        salesObj1.Invoice_Status__c = 'test';
        insert salesObj1;
        Sales_Order_Line_Item__c lin = Grz_TestDataFactory.createsalesLineItemsRecord(true,salesObj1.id,123);
        Datetime dt = Datetime.newInstance(2013, 5, 28, 1, 6, 8);
        
        Sales_order_delivery__c del1 = new Sales_order_delivery__c();
        Id deliveryRecordType =  Schema.SObjectType.Sales_order_delivery__c.getRecordTypeInfosByDeveloperName().get('Delivery_Information').getRecordTypeId();
        del1.SubStatus__c ='xyz';
        del1.RecordTypeId = deliveryRecordType;
        del1.Arrived_At__c =String.valueOf(dt);
        del1.Estimated_at__c  = String.valueOf(dt);
        del1.Sales_Order_Line_Item__c= lin.Id;
        insert del1;
        Id itemRecordType =  Schema.SObjectType.Sales_order_delivery__c.getRecordTypeInfosByDeveloperName().get('Item_Information').getRecordTypeId();
        Sales_order_delivery__c del = new Sales_order_delivery__c();
        del.SubStatus__c ='xyz';
        del.Parent_Record__c = del1.Id;
        del.RecordTypeId = itemRecordType;
        del.Arrived_At__c =String.valueOf(dt);
        del.Estimated_at__c  = String.valueOf(dt);
        del.Sales_Order_Line_Item__c= lin.Id;
        insert del;
        Test.stopTest();
        Grz_SalesOrderListChile.getSalesOrderRecord('','CreatedDate asc',1,10,'2020-01-01','2090-01-01','Approved','All'); 
        Grz_SalesOrderListChile.getSalesOrderRecord('7062133268','CreatedDate asc',1,10,'2020-01-01','2090-01-01','All','All'); 
        Grz_SalesOrderListChile.getSalesOrderRecord('','CreatedDate asc',1,10,'2020-01-01','2090-01-01','Other','All');
        Grz_SalesOrderListChile.getLineItems(lin.id);
        
        PageReference pageRef = Page.Grz_SalesOrderChilePDF; // Add your VF page Name here
        pageRef.setRedirect(true);
        pageRef.getParameters().put('searchKey','7062133268');
        pageRef.getParameters().put('datefilter','CreatedDate asc');
        pageRef.getParameters().put('pageNumber','1');
        pageRef.getParameters().put('pageSize','10');
        pageRef.getParameters().put('startDate','2020-01-01');
        pageRef.getParameters().put('endDate','2090-01-01');
        pageRef.getParameters().put('orderStatus','All');
        pageRef.getParameters().put('distributorId','All');
        Test.setCurrentPage(pageRef);
        Grz_SalesOrderListChile obj1 = new Grz_SalesOrderListChile();
        obj1.salesOrderListVF();
        
    }
}