@isTest
public class SORIntegrationServiceTest {
    @TestSetup
    public static void testDataSorIntegration(){
        Sales_Org__c so = new Sales_Org__c();
        so.Name = 'Brazil';            
        so.Company_Code__c = '5190';        
        so.Sales_Org_Code__c = '5191';      
        so.Country_Code__c = 'BR';     
        insert so;
        
        Depot__c dp =new Depot__c ();
        dp.Name='Brazil';
        dp.Country__c='Brazil';
        dp.Depot_Code__c='CL00';
        dp.SalesOrg__c = so.Id;
        insert dp; 
         
        Account accObj = new Account();
        accObj.Name='Test User';
        accObj.SAP_Code__c = '0001013292';              
        accObj.Last_Name__c = 'UserTest';     
        accObj.Order_Block__c = false;                       
        accObj.Mobile__c = '1234567890';  
        accObj.Phone='2345678909'; // Mobile
        accObj.Email__c = 'test@gmail.com';       
        accObj.Account_Type__c = 'Sold To Party';           
        accObj.Raise_Order_Type__c = 'Factura';                 
        accObj.Billing_Street_2__c = 'CATAMARCA 3454';      
        accObj.Sales_Org__c = so.id; 
        accObj.Brazil_Depot_Code__c=dp.Id;
        insert accObj;
        
        Invoice__c invc=new Invoice__c();
        invc.Nota_Fiscal__c='test';
        invc.Billing_Doc_Number__c='12323';
        invc.Sold_To_Party__c=accObj.Id;
        insert invc;
        
        Order_Type__c ot=new Order_Type__c();
        ot.Order_Type_Code__c='ZROB';
        insert ot;
        
        RSO_Deposit__c dpst = new RSO_Deposit__c();
        dpst.Deposit_Code__c='teat123';
        insert dpst;
        
        RSO_Return_Sub_Status__c rss = new RSO_Return_Sub_Status__c();
        rss.Sub_Return_Type_Code__c='st123';
        insert rss;
        
        Return_Sales_Order__c rso=new Return_Sales_Order__c();
        rso.Customer__c=accobj.Id;
        rso.SFDC_Order_Number__c='test12345';
        rso.Return_Sub_Type__c = rss.Id;
        insert rso;
        
        Invoice_Line_Item__c ili=new Invoice_Line_Item__c();
        ili.Billing_DOC_reference_number__c='ABCD12345';
        ili.Invoice__c=invc.Id;
        insert ili;
        
        Return_Sales_Order_Line_Item__c rsoli=new Return_Sales_Order_Line_Item__c();
        rsoli.Invoice_Line_Item__c=ili.Id;
        rsoli.Return_Sales_Order__c=rso.Id;
        rsoli.Invoice_Line_Item__c=ili.Id;
        rsoli.Invoice__c=invc.Id;
        rsoli.Volumn_KG_LT__c=20;
        rsoli.Invoice_Line_Item__c=ili.Id;
        insert rsoli;
        
        RSO_with_Customer_Service__c rwcs=new RSO_with_Customer_Service__c();
        rwcs.Return_Sales_Order__c=rso.Id;
        rwcs.Invoice_Date__c=system.today();
        rwcs.Customer_Invoice_Date__c=system.today();
        rwcs.Order_Type__c=ot.Id;
        rwcs.Deposit__c = dpst.Id;
        rwcs.SAP_Order_Number__c='test54321';
        rwcs.Billing_Doc__c='Test1010';
        rwcs.Inco_Term__c='CIF';
        rwcs.Inco_Term_2__c='CFR';
        rwcs.Sub_Return_Type__c = rss.Id;
        rwcs.Deposit_Flag__c='TEST';
        rwcs.Full_Return__c=true;
        rwcs.Customer_Invoice__c='test12345';
        rwcs.Quantity__c=10;
        rwcs.Quantity_Flag__c='ABCD';
        rwcs.Billing_Doc_Item_Number__c=rsoli.Id;
        rwcs.Invoice__c=invc.Id;
        rwcs.Customer_Invoice__c='test12345';
        insert rwcs;
        
        RSOAndDGEndPoint__c endurl2 =new RSOAndDGEndPoint__c();
        endurl2.Name='NamedCredentialUrl';
        endurl2.EndPointUrl__c='callout:HCI_SAP';
        insert endurl2;
        
        RSOAndDGEndPoint__c endurl =new RSOAndDGEndPoint__c();
        endurl.Name='ZCER';
        endurl.EndPointUrl__c='https://l4097-iflmap.hcisbp.eu1.hana.ondemand.com/http/RSO_Header_ZCER_Brazil';
        insert endurl;
        
        RSOAndDGEndPoint__c  endPointurl=new RSOAndDGEndPoint__c();
        endPointurl.Name ='ZREB_ZROB';
        endPointurl.EndPointUrl__c='https://l4097-iflmap.hcisbp.eu1.hana.ondemand.com/http/RSO_Header_ZREB_ZROB_Brazil';
        insert endPointurl;
        
        SORIntegrationService.HttpWrapper httpWrap=new SORIntegrationService.HttpWrapper();
        httpWrap.request = new HttpRequest();
        httpWrap.response= new HttpResponse();
       SORIntegrationService.RSO rsoWrapper=new  SORIntegrationService.RSO();
        rsoWrapper.RSOSFDCNumber = 'test123';
        rsoWrapper.SAPBillingDoc = 'test123';
        rsoWrapper.invoice = 'test123';
        rsoWrapper.customerInvoice = 'test123';
        rsoWrapper.customerInvoiceDate = 'test123';
        rsoWrapper.returnSubType = 'test123';
        rsoWrapper.orderDocType = 'test123';
        rsoWrapper.incoTerms = 'test123';
        rsoWrapper.incoTerms2 = 'test123';
        rsoWrapper.FullReturn = 'test123';
        rsoWrapper.RSOLineItem = new List<SORIntegrationService.RSOLineItem>();
    }
    @istest
    public static void testSorIntegration(){
         Test.setMock(HttpCalloutMock.class, new DGMockHttpResponseGenerator());
        RSO_with_Customer_Service__c rwcs=[select id from RSO_with_Customer_Service__c];
        Return_Sales_Order__c rsoli=[select id from Return_Sales_Order__c];
        Invoice__c invc=[select id from Invoice__c];
        string rsoId=rsoli.Id;
        List<String> rwcsList=new  List<String>();
        rwcsList.add(rwcs.Id);
        List<String> invcList =new List<String>();
        invcList.add(invc.Id); 
        List<SORIntegrationService.HttpWrapper> httpList=new List<SORIntegrationService.HttpWrapper>();
       HttpResponse response = new HttpResponse();
        response.setBody('{"RSOSAPNumber":"12345","RSOSFDCNumber":"5678","SAPBillingDoc":"1234","customerInvoice":"ABC123","orderType":"ZROB"}');
         Map<String,String> invcDocTpMap=new  Map<String,String>();
        invcDocTpMap.put(invc.Id,'ZROB');
         HttpRequest req= new HttpRequest(); 
         HttpResponse response1 = new HttpResponse();
        response1.setBody('{"RSOSAPNumber":"12345","RSOSFDCNumber":"5678","SAPBillingDoc":"1234","customerInvoice":"ABC123"}');
        
        Test.startTest();
        SORIntegrationService.sendToIntegration(rwcsList,invcList,invcDocTpMap,rsoId,'Yes');
        SORIntegrationService.sendToIntegration(rwcsList,invcList,invcDocTpMap,rsoId,'No');
        SORIntegrationService.updateCSWithSAP(httpList,rsoId,'Yes');
        SORIntegrationService.updateCSWithSAP(httpList,'','');
        SORIntegrationService.responseToCustmerService(response, new HttpRequest(),'No',rsoId);
        SORIntegrationService.responseToCustmerService(response1, new HttpRequest(),'Yes',rsoId);
        SORIntegrationService.responseToCustmerService(response1, new HttpRequest(),'No',rsoId);


        Test.stopTest();
    }
}