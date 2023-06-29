@isTest
Private class SalesOrderDetails_Test {
    @isTest
    public static void validateData(){
       
        
        Account accObj = new Account();
        accObj.Name='Agrolic Pharma Pvt Ltd';
        accObj.SAP_Code__c='319362';
        accObj.Account_Type__c='Sold To Party';
        insert accObj;
        
        Shipping_Location__c slObj = new Shipping_Location__c();
        slObj.Location_Name__c='MARTINEZ Y VALDIVIESO S A';
        slObj.Distributor__c=accObj.Id;
        slObj.CurrencyIsoCode='INR';
        slobj.SAP_Code__c='319362';
        insert slObj;
        
        Payment_Term__c ptObj = new Payment_Term__c();
        ptObj.Payment_Term_Code__c='ZV39';
        ptObj.Payterms_Desc__c='Net 210 days fm the dt of Invoice';
        insert ptObj;
        
        Order_Type__c otObj = new Order_Type__c();
        otObj.Order_Type_Code__c='ZZRO';
        otObj.Description__c='ZZOR';
        insert otObj;
        
        Sku__c skuObj = new Sku__c();
        skuObj.Name='Alkem 500mg';
        skuObj.SKU_Code__c='3673';
        skuObj.CurrencyIsoCode='INR';
        skuObj.SKU_Description__c='CAPTAN 80 WP 1KG_CL';
        insert skuObj;
        
        
        Sales_Order__c solist= new Sales_Order__c();
        solist.Total_Amount__c=45645; 
        solist.SAP_Order_Number__c='893483';
        solist.Order_Status__c='Pending';
        solist.Remarks_Long__c='Approval For CCO';
        solist.Sold_to_Party__c=accObj.Id;
        solist.Ship_To_Party__c=slObj.Id;
        solist.Payment_Term__c=ptObj.Id;
        solist.Order_Type_lk__c= otObj.Id;
        
        insert solist;
        
        Sales_Order_Line_Item__c soliList = new Sales_Order_Line_Item__c();
        soliList.Sale_Order__c=solist.Id;
        soliList.MinPrice__c=353.00;
        soliList.MaxPrice__c=435.00;
        soliList.Net_Price__c=6463.00;
        soliList.Quantity__c=100;
        soliList.SKU_Net_Price__c=100;
        soliList.SKU_Name__c=skuObj.Id;
        soliList.Margin_Block_Level_1__c=true;
        soliList.Margin_Block_Level_2__c=true;
        soliList.Margin_Block_Level_3__c=true;
        soliList.Blanket_SKU_Status__c=true;
        soliList.Blanket_SKU_Start_Date__c=date.parse('12/09/2009');
        soliList.Blanket_SKU_End_Date__c=date.parse('12/10/2009');
        soliList.Type_of_Sale__c='Promotion';
        insert soliList;
        
        ProcessInstanceStep pisObj = new ProcessInstanceStep();
        pisObj.Comments='Approved by CCO';
        
        test.startTest();
          SalesOrderDetails.getSalesOrderDetails(solist.Id);
          SalesOrderDetails.getSOLIDetails(solist.Id);
          SalesOrderDetails.getLastApproverComment(solist.Id);
        test.stopTest();
        
    }
    
 
   
}