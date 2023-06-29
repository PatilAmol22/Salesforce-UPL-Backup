/*
*   ApexTest Class - SOLICombKeyTriggerTest for SOLICombKeyTrigger trigger
*   Modified Date: 23-02-2023
*   Description - RITM0500995 : This trigger already exists but we have refactored the code as this was recursively called and concatinate SOLI_Combination_Key__c = SAP order number + Itemnumber on CPIO was thrown with an error.
**/
@isTest
public class SOLICombKeyTriggerTest {
    
    static Id supplier_RecTypeId = [SELECT Id FROM RecordType WHERE Name = 'Storage Location' and isActive = TRUE LIMIT 1].Id;
    static Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
    
    static testMethod void validate() {
        Test.startTest(); 
        Trigger_Settings__c newtri = new Trigger_Settings__c();
        newtri.Name = 'SOLICombKeyTrigger';
        newtri.isActive__c = true;
        insert newtri;
        
        Sales_Org__c salesOrg  = new Sales_Org__c();
        salesOrg.Name = 'Mexico';
        salesOrg.Company_Code__c = '5000';
        salesOrg.Country_Code__c = 'MX';
        salesOrg.Sales_Org_Code__c = '5100';
        Insert salesOrg;
        
        Product2 pro = new Product2();
        pro.ProductCode = '66700';
        pro.Product_Code__c='66700';
        pro.Name='DOST';
        pro.popular__c = true;
        pro.Combination_Key__c='RM0065100';
        Insert Pro;
        
        SKU__c sku = new SKU__c();
        sku.Name='P1';
        sku.SKU_Code__c='704002';
        sku.SKU_Pack__c=1.00;
        sku.SKU_UOM__c='L';
        sku.Multiple_Of__c=5;
        sku.Group__c='DOST';
        sku.Special_SKU__c = true;
        sku.Pack_Size__c=10.00;
        sku.Product_Name__c=pro.Id;
        sku.Sales_Org__c = salesOrg.Id;
        sku.UOM__c='L';
        sku.Brand_Name__c='My brand Name';
        sku.Active__c=True;
        sku.Combination_Key__c='Cooooooo000011111';
        insert sku;
        
        Payment_Term__c paymenTermObj = new Payment_Term__c(
            Payment_Term__c = 'NET 75 Days',  
            Payment_Term_Code__c = 'UK38',     
            Maturity_Date_Mandatory__c = 'No', 
            Sales_Org__c = salesOrg.Id,   // Sales Org
            Payterms_Desc__c = 'NET 75 Days',  
            Active__c = true,                 
            CombinationKey__c = '5100UK38'     
        );
        insert paymenTermObj;
        
        
        Depot__c dp = new Depot__c ();
        dp.Name = 'NORTE';
        dp.recordtypeId = supplier_RecTypeId;
        dp.Country__c = 'Mexico';
        dp.Location__c = 'NORTEE';
        dp.Depot_Code__c = 'MW22';
        dp.Active__c = true;
        //dp.Depot__c = dp_M.Id;
        dp.SalesOrg__c = salesOrg.ID;
        dp.Segment_Name__c = 'Sales Team';
        insert dp;
        
        Order_Type__c ordType =new Order_Type__c();
        ordType.Name = 'ZORD';              
        
        ordType.Description__c = 'Indonesia';    
        ordType.Order_Type_Code__c = 'ZORD';
        insert ordType;
        
        Account acc = new Account();
        acc.Name = 'Test Account Distributer';
        acc.Last_Name__c = 'Distributer';
        acc.SAP_Code__c = 'SAP996734';
        acc.RecordTypeId = devRecordTypeId;
        acc.Mobile__c = '9967341759';
        acc.Phone = '020256589';
        acc.Sales_Org__c = salesOrg.Id;
        acc.BillingCity = 'Pune';
        acc.Order_Type__c = ordType.Id;
        acc.Depot_Code__c = 'PUN1';
        insert acc;
        
        Shipping_Location__c shippLoc =new Shipping_Location__c();
        shippLoc.Location_Name__c ='Same as Billing Address'; 
        shippLoc.Region__c='Pune';
        shippLoc.Distributor__c=acc.Id;
        shippLoc.City__c='Pune';
        shippLoc.Sold_To_Party_SAP_Code__c = acc.SAP_Code__c;
        shippLoc.SAP_Code__c='SAP0001';
        shippLoc.State__c='13';
        shippLoc.Sales_Org__c = salesOrg.id;
        insert shippLoc;
        
        Sales_Order__c so = new Sales_Order__c();
        so.Sold_to_Party__c = acc.Id;
        so.Bill_To_Party__c = acc.Id;
        so.Order_Date__c = system.today();
        so.CreatedFrom__c = 'SFDC';
        so.Depot__c = dp.Id;
        so.OwnerId = UserInfo.getUserId();
        so.Sales_Org_lk__c = salesOrg.Id;
        so.Order_Status__c = 'Draft';
        so.Ship_To_Party__c = shippLoc.Id;
        so.Payment_Term__c =paymenTermObj.Id;
        so.Sent_for_Latam_Director__c = true;
        so.PONumber__c='12345';
        so.SAP_Order_Number__c='5622991';
        insert so;
        
        Sales_Order_Line_Item__c sliObj = new Sales_Order_Line_Item__c();
        sliObj.SKU_Name__c = sku.Id;
        sliObj.Item_Number__c = 10;
        sliObj.Type_of_Sale__c = 'Real Sale';
        sliObj.Item_Status__c = 'Active';
        sliObj.UOM__c = 'L';
        sliObj.CurrencyIsoCode = 'MXN';
        sliObj.multipleOf__c = 10;
        sliObj.MaxPrice__c = 200;
        sliObj.MinPrice__c = 50;
        sliobj.Shipping_Date__c = System.today().addDays(3);
        sliObj.Finalprice__c = 150;
        sliObj.Crop1_Percentage__c = 100;
        sliObj.Quantity__c = 10;
        sliObj.Net_Price__c = 150;
        sliObj.Price__c = 1500;
        sliObj.Sale_Order__c = so.Id;
        sliObj.SOLI_Combination_Key__c = null;
        sliObj.Item_Number__c = 10;
        insert  sliObj;
        
        Grz_checkRecursiveTrigger.run=true;
        
        so.Cancel_Comment__c='test';
        update so;
        
        Test.stopTest();
    }
    
}