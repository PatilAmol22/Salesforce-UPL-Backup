@isTest
public class SORTabSectionChildControllerTest {
     @TestSetup
    public static void testDataSorTab(){
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
        accObj.Active__c=true;
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
        accObj.Customer_Region__c='Brazil';
        insert accObj;
        
        Region__c rg=new Region__c();
        rg.SalesOrg__c=so.Id;
        rg.Batch_Number__c='12345';
        insert rg;
        
        Territory_Distributor__c td=new Territory_Distributor__c();
        td.Region__c=rg.Id;
        td.SalesOrg__c=so.Id;
        insert td;
        
        Customer_and_Region_Mapping__c crm=new Customer_and_Region_Mapping__c();
        crm.Active__c=true;
        crm.Customer_Name__c=accObj.Id;
        crm.CustomerRegion__c=td.Id;
        insert crm;
        
        Product2 pro = new Product2();
        pro.ProductCode = '66700';
        pro.Product_Code__c='66700';
        pro.Name='DOST';
        pro.popular__c = true;
        pro.Combination_Key__c='RM0065100';
        insert Pro;
        
        SKU__c sku = new SKU__c();
        sku.Name='DOST';
        sku.SKU_Code__c='704002';
        sku.SKU_Pack__c=1.00;
        sku.SKU_UOM__c='L';
        sku.Multiple_Of__c=5;
        sku.Group__c='DOST';
        sku.Pack_Size__c=10.00;
        sku.Product_Name__c=pro.Id;
        sku.Sales_Org__c = so.Id;
        sku.UOM__c='L';
        sku.Active__c=True;
        sku.Combination_Key__c='Cooooooo000011111';
        insert sku;
        
        Invoice__c invc=new Invoice__c();
        invc.Nota_Fiscal__c='test';
        invc.Billing_Doc_Number__c='12323';
        invc.Sold_To_Party__c=accObj.Id;
        insert invc;
        
        Order_Type__c ot=new Order_Type__c();
        ot.Order_Type_Code__c='test';
        ot.SalesOrg__c=so.id;
        ot.Name='ZROB';
        insert ot;
        
        RSO_Deposit__c dpst=new RSO_Deposit__c();
        dpst.Deposit_Code__c='teat123';
        insert dpst;
        
        RSO_Return_Sub_Status__c rss = new RSO_Return_Sub_Status__c();
        rss.Sub_Return_Type_Code__c='st123';
        insert rss;
        
        Return_Sales_Order__c rso=new Return_Sales_Order__c();
        rso.Customer__c=accobj.Id;
        rso.SFDC_Order_Number__c='test12345';
        rso.Order_Status__c='Blocked';
        rso.Return_Sub_Type__c = rss.Id;
        rso.Refusal__c='No';
        insert rso;
        
        Invoice_Line_Item__c ili=new Invoice_Line_Item__c();
        ili.Billing_DOC_reference_number__c='ABCD12345';
        ili.Invoice__c=invc.Id;
        ili.SKU__c=sku.Id;
        insert ili;
        
        Return_Sales_Order_Line_Item__c rsoli=new Return_Sales_Order_Line_Item__c();
        rsoli.Invoice_Line_Item__c=ili.Id;
        rsoli.Return_Sales_Order__c=rso.Id;
        rsoli.Invoice_Line_Item__c=ili.Id;
        rsoli.Invoice__c=invc.Id;
        rsoli.Volumn_KG_LT__c=20;
        rsoli.Invoice_Line_Item__c=ili.Id;
        rsoli.Item_Number__c='1234567';
        
        insert rsoli;
        
        RSO_with_Customer_Service__c rwcs=new RSO_with_Customer_Service__c();
        rwcs.Return_Sales_Order__c=rso.Id;
        rwcs.Invoice_Date__c=system.today();
        rwcs.Customer_Invoice_Date__c=system.today();
        rwcs.Order_Type__c=ot.Id;
        rwcs.Deposit__c=dpst.Id;
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
        
        RSO_with_SAP_Return_Order__c rwsro=new RSO_with_SAP_Return_Order__c();
        rwsro.Return_Sales_Order__c=rso.Id;
        rwsro.SAP_Order_Number__c='12345';
        rwsro.Branch__c='RSO';
        rwsro.Email__c='test@gmail.com';
        rwsro.Customer_Invoice__c='test';
        insert rwsro;
        
        
        
        
    }
    @istest
    public static void testSorTab(){
        Account acc=[select Id from Account];
        RSO_with_Customer_Service__c rwcs=[select id from RSO_with_Customer_Service__c];
        Return_Sales_Order__c rsoli=[select id,Inco_Term_1__c,Return_Sub_Type__c,Refusal__c from Return_Sales_Order__c];
         string rsoId=rsoli.Id;
        Return_Sales_Order_Line_Item__c rsoliObj=[select id from Return_Sales_Order_Line_Item__c];
        Invoice__c invc=[select id from Invoice__c];
        Depot__c dp=[select Id from Depot__c];
        RSO_Return_Sub_Status__c rrss=[select Id from RSO_Return_Sub_Status__c];
        
        List<SORProductDetailsChildController.ProductDetailsWrapper> rsoItemList=new List<SORProductDetailsChildController.ProductDetailsWrapper>();
        SORProductDetailsChildController.ProductDetailsWrapper ProDetailWrap=new SORProductDetailsChildController.ProductDetailsWrapper();
        ProDetailWrap.accountId=acc.Id;
        ProDetailWrap.sorId=rsoId;
        ProDetailWrap.invoiceId=invc.Id;
        ProDetailWrap.incoTerm=rsoli.Inco_Term_1__c;
        ProDetailWrap.billingDoc='';
        ProDetailWrap.invoiceDate='';
        rsoItemList.add(ProDetailWrap);
        
        Test.startTest();
        SORTabSectionChildController.getKEDEUsers(acc.Id);
        SORTabSectionChildController.getAccountDetails(acc.Id,acc.Id);
        SORTabSectionChildController.getCustomerServices(rsoId);
        SORTabSectionChildController.getInvoicesAndDeposite(rsoId);
        SORTabSectionChildController.getOrderTypes();
        SORTabSectionChildController.checkInvoiceFullReturn(invc.Id);
        SORTabSectionChildController.checkBalanceQuantity(rsoId,rsoliObj.Id);
        SORTabSectionChildController.checkBalanceQuantity(null,rsoliObj.Id);
        SORTabSectionChildController.getSAPOrders(rsoId);
        SORTabSectionChildController.deleteCustomerService(rwcs.Id);
        SORTabSectionChildController.deleteSAPOrder(rwcs.Id);
        SORTabSectionChildController.getDeposit(dp.Id,rrss.Id);
        
        SORTabSectionChildController.rsoItemToCustomerService(rsoItemList,rsoli);
        Test.stopTest();
    }
}