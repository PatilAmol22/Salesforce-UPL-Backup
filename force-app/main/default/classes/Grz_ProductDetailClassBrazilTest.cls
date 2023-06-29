@isTest
public class Grz_ProductDetailClassBrazilTest {
    Public  static testmethod void testgetProductDetailListBrazil()
    {
        Test.setMock(HttpCalloutMock.class, new Grz_SapIntegrationMockTestDataFactory(true));   
        Id recordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Sales_Org__c sOrg = Grz_TestDataFactory.createSalesOrg(true, 'Test Org','1000');
        Account acc = Grz_TestDataFactory.createUserAccount(true, 'Test Account',recordTypeId,sOrg.Id);
        Contact con = Grz_TestDataFactory.createContact(true, 'Test Contact',acc.Id);
        Profile pro = [SELECT Id FROM Profile WHERE Name = 'Brazil Partner Community Distributor Profile'];
        
        Profile pro1 = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User usr1 = Grz_TestDataFactory.createInternalUser(true,pro1.Id);
        User usr=new User();
        System.runAs(usr1){
            Group gg=Grz_TestDataFactory.creategroup(true);
            usr = Grz_TestDataFactory.createExternalUser(true,pro.Id,con.Id);
            GroupMember gm=Grz_TestDataFactory.createGM(true,gg.Id,usr.id);
        }
        Sales_Order__c salesObj = Grz_TestDataFactory.createSalesOrderRecord(false, '7062140268','Approved',Date.today(), acc.Id);
        salesObj.Currency_Brazil__c = 'Billing BRL / Payment BRL';
        salesObj.Type_of_Order__c='BONIFICAÇÃO';
        //salesObj.TotalValueWithoutInterest__c='10';
        
        insert salesObj;
        Invoice__c invo = Grz_TestDataFactory.createInvoice(false, acc.Id);
        invo.Sales_Order__c = salesObj.Id;
        invo.Nota_Fiscal__c = '1234';
        invo.Invoice_key__c = '12345';
        invo.Billing_Date__c = Date.newInstance(2020, 12, 9);
        insert invo;
        
        Sales_Order_Line_Item__c lineItem = Grz_TestDataFactory.createsalesLineItemsRecord(true, salesObj.Id, 23);
        Test.startTest(); 
        Grz_ProductDetailClassBrazil.getProductDetailList(String.valueOf(salesObj.Id));
        Grz_ProductDetailClassBrazil.getFiles(invo.Id, 'PDF');
        
        PageReference pageRef = Page.Grz_SalesOrderPDF; // Add your VF page Name here
        pageRef.setRedirect(true);
        pageRef.getParameters().put('Id','a1E6D000000YTBTUA4');
        pageRef.getParameters().put('punct','true');
        Test.setCurrentPage(pageRef);
        Grz_ProductDetailClassBrazil obj1 = new Grz_ProductDetailClassBrazil();
        obj1.getDataForVF();
        
        Grz_ProductDetailClassBrazil.ProductDetailWrapper ob= new Grz_ProductDetailClassBrazil.ProductDetailWrapper();
        ob.soldToPartyEmail ='soldToPartyEmail';
        ob.soldToParty='Test';
        
        ob.soldToPartyBillingStreet='soldToPartyBillingStreet'; 
        ob.soldToPartyBillingCity ='soldToPartyBillingCity';
        ob.soldToPartyBillingState='soldToPartyBillingState';
        ob.soldToPartyBillingCountry='soldToPartyBillingCountry';
        ob.soldToPartyBillingPostalCode ='soldToPartyBillingPostalCode';
        ob.soldToPartyCustomerRegion ='soldToPartyCustomerRegion';
        ob.soldToPartyTax3 ='soldToPartyTax3';
        ob.campaignPaymentTerm=system.today(); 
        ob.maturityDate =system.today();
        ob.reloadPaymentTerm ='reloadPaymentTerm';
        ob.paymentMethod ='paymentMethod';
        ob.shippingType ='shippingType';
        ob.invoiceMessage='invoiceMessage'; 
        ob.obs='obs'; 
        ob.campaignType ='campaignType';
        ob.punchDiscount =10;
        ob.finalTotal=20;
        obj1.getDataForVF();
        Grz_ProductDetailClassBrazil.LineItemWrap ob1= new Grz_ProductDetailClassBrazil.LineItemWrap();
        ob1.qty=1; 
        ob1.unitVal=2;
        ob1.fatDate=system.today();
        ob1.amt =3;
        Test.stopTest(); 
        
        Grz_ProductDetailClassBrazil.ProductDetailWrapper pd = new Grz_ProductDetailClassBrazil.ProductDetailWrapper();
        pd.crncy = 'test';
        pd.paymentTerm = 'test';
        Grz_ProductDetailClassBrazil.LineItemWrap lm = new Grz_ProductDetailClassBrazil.LineItemWrap();
        lm.quantity = 'test';
        lm.unitPrice = 'test';
        
    }
    Public  static testmethod void testgetFilesFailure()
    {
        Id recordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Sales_Org__c sOrg = Grz_TestDataFactory.createSalesOrg(true, 'Test Org','1000');
        Account acc = Grz_TestDataFactory.createUserAccount(true, 'Test Account',recordTypeId,sOrg.Id);
        Contact con = Grz_TestDataFactory.createContact(true, 'Test Contact',acc.Id);
        Profile pro = [SELECT Id FROM Profile WHERE Name = 'Brazil Partner Community Distributor Profile'];
        
        Profile pro1 = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User usr1 = Grz_TestDataFactory.createInternalUser(true,pro1.Id);
        User usr=new User();
        System.runAs(usr1){
            Group gg=Grz_TestDataFactory.creategroup(true);
            usr = Grz_TestDataFactory.createExternalUser(true,pro.Id,con.Id);
            GroupMember gm=Grz_TestDataFactory.createGM(true,gg.Id,usr.id);
        }
        test.startTest();
        Sales_Order__c salesObj = Grz_TestDataFactory.createSalesOrderRecord(false, '7062140268','Approved',Date.today(), acc.Id);
        salesObj.Currency_Brazil__c = 'Billing BRL / Payment BRL';
        insert salesObj;
        Invoice__c invo = Grz_TestDataFactory.createInvoice(false, acc.Id);
        invo.Sales_Order__c = salesObj.Id;
        invo.Nota_Fiscal__c = '1234';
        invo.Invoice_key__c = '12345';
        invo.Billing_Date__c = Date.newInstance(2020, 12, 9);
        insert invo;
        Grz_ProductDetailClassBrazil.getFiles(invo.Id, 'XML');
        PageReference pageRef = Page.Grz_SalesOrderPDF; // Add your VF page Name here
        pageRef.setRedirect(true);
        pageRef.getParameters().put('Id',salesObj.Id);
        pageRef.getParameters().put('punct','4');
        Test.setCurrentPage(pageRef);
        Grz_ProductDetailClassBrazil obj1 = new Grz_ProductDetailClassBrazil();
        obj1.getDataForVF();
        test.stopTest();
    }
    
}