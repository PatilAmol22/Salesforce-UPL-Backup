/****************************************************************************
    * Name - Grz_SalesOrderListArgentinaTest
    * @Description  - Test Class for grz_SalesOrderListArgentina OR Grz_SalesOrderArgentinaFileVFController Apex Class
    * Created Date - 31/08/2022
    * Author - Mohit garg(Grazitti)
    * Last modified by - Mohit Garg(Grazitti) 31/08/2022 
    *************************************************************************** */

@isTest
public class Grz_SalesOrderListArgentinaTest {
	public static testmethod void test_getSalesOrderRecordArgentina()
    {
        
        Date startdate = Date.today()-365;
        Date enddate = Date.today();
        Test.startTest();
        Id recordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Account acc = Grz_TestDataFactory.createAccount(true, 'Test Account',recordTypeId);
        Sales_Org__c sorg = Grz_TestDataFactory.createSalesOrg(true, 'Argentina', '5631');
        Sales_Order__c salesObj1 = Grz_TestDataFactory.createSalesOrderRecord(false, '7062133268','Open',Date.today(), acc.Id);
       salesObj1.Sales_Org_lk__c = sorg.Id;
        salesObj1.SFDC_Order_Number__c = '74272243';
        insert salesObj1;
        
        Grz_SalesOrderListArgentina.getSalesOrderRecord('','CreatedDate asc','All',1,1,'2020-01-01','2030-01-01');       
       Grz_SalesOrderListArgentina.getSalesOrderRecord('70',null,'Abierto',1,null,'2020-01-01','2030-01-01');
        Grz_SalesOrderListArgentina.getSalesOrderRecord('70','CreatedDate desc','Despachado',1,null,'2020-01-01','2030-01-01');
        
        Test.stopTest();
    }
    
    Public  static testmethod void Grz_SalesOrderArgentinaVFTest(){
        Test.startTest();
        Id recordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Account acc = Grz_TestDataFactory.createAccount(true, 'Test Account',recordTypeId);
        Sales_Org__c sorg = Grz_TestDataFactory.createSalesOrg(true, 'Argentina', '5631');
        Sales_Order__c salesObj1 = Grz_TestDataFactory.createSalesOrderRecord(false, '7062133268','Open',Date.today(), acc.Id);
        salesObj1.Sales_Org_lk__c = sorg.Id;
        salesObj1.SFDC_Order_Number__c = '74272243';
    	
        insert salesObj1;
        
        PageReference pageRef = Page.Grz_SalesOrderArgentinapdfDownload; // Add your VF page Name here
        pageRef.setRedirect(true);
        pageRef.getParameters().put('searchKey','7062133268');
    	
    	pageRef.getParameters().put('sortby','All');
        Test.setCurrentPage(pageRef);
        Grz_SalesOrderArgentinaFileVFController abc = new Grz_SalesOrderArgentinaFileVFController();
        abc.Grz_SalesOrderListVF();
        Test.stopTest(); 
    }
    
}