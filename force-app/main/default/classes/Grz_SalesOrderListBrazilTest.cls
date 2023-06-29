@isTest
public class Grz_SalesOrderListBrazilTest {
    public static testmethod void test_getSalesOrderRecordBrazil(){
        Date startdate = Date.newInstance(2021, 04, 1);
        Date enddate = Date.newInstance(2022, 03, 31);
        Test.startTest();
        Id recordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Account acc = Grz_TestDataFactory.createAccount(true, 'Test Account',recordTypeId);
        Sales_Org__c sorg = Grz_TestDataFactory.createSalesOrg(true, 'Brazil', '5191');
        Sales_Order__c salesObj1 = Grz_TestDataFactory.createSalesOrderRecord(false, '7062133268','Approved',Date.today(), acc.Id);
        salesObj1.Sales_Org_lk__c = sorg.Id;
        salesObj1.Type_of_Order__c = 'CONTRATO MÃE';
        salesObj1.Currency_Brazil__c = 'Billing USD / Payment USD';
        salesObj1.Invoice_Status__c = 'test';
        salesObj1.Valid_From__c = system.today();
        insert salesObj1;
        Brazil_Portal_Configuration__c bp = new Brazil_Portal_Configuration__c();
        bp.Name = 'Configuration';
        bp.Portal_Sales_Order_Type__c = 'CONTRATO MÃE';
        insert bp;
        Grz_SalesOrderListBrazil.getSalesOrderRecordBrazil('7062133268','CreatedDate asc','All',1,1,'2020-01-01','2030-01-01','All','','', false);       
        Grz_SalesOrderListBrazil.getSalesOrderRecordBrazil('7062133268',null,'Pedido em Análise',1,null,'2020-01-01','2030-01-01','All','A','1223',false);
        Grz_SalesOrderListBrazil.getSalesOrderRecordBrazil('7062133268',null,'Pedido em Análise',1,null,'2020-01-01','2030-01-01','All','B','1234', true);
        Grz_SalesOrderListBrazil.getSalesOrderRecordBrazil('7062133268',null,'Pedido em Análise',1,null,'2020-01-01','2030-01-01','All','Entregue em','',false);
        Grz_SalesOrderListBrazil.updateCheckbox(true);
        Test.stopTest();
        Grz_SalesOrderListBrazil.FinamlSalesDataWrapper wrap = new Grz_SalesOrderListBrazil.FinamlSalesDataWrapper();
        wrap.brazilFlag = false;
        wrap.isMainParent = false;
    }
}