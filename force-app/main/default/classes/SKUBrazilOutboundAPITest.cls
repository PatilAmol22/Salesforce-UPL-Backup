@istest
public class SKUBrazilOutboundAPITest {
 static testMethod void myUnitTest1() { 
     
        Sales_Order__c so3 = new Sales_Order__c();
        so3.Currency_Brazil__c = 'Billing USD / Payment USD';  
        so3.Valid_FROM__c = System.today();   
         so3.SAP_Order_Number__c='7676767676';  
        so3.BrazilOrderSubmittedforApproval__c = true;        
        so3.Valid_To__c = System.today()+365;        
        so3.PONumber__c = 'qweet1';   
        so3.BudgetApprovalCheck__c = false;
        so3.Key_Account__c = false;  
        so3.Business_Discount__c = 0.00;                  
        so3.Financial_Discount__c = 0.00;                 
        insert so3;
        List<String> ss = new List<String>();
        ss.add(so3.id);
        ExchangeRate__c exrate= new ExchangeRate__c();
        exrate.ExchangeRate__c=5.06;
        insert exrate;
        SKU__c skuRec = new SKU__c(
            Name = 'a1C0k000000A1ug',
            SKU_Code__c = '000000000006302803',
            SKU_Description__c = 'Kit ',
            UOM__c = 'KG', 
            Multiple_of__c = 25.00,
            Combination_Key__c = '519110000000000006302803',
            Active__c = true,
            Kit_Product__c = true,
            brand_name__c = 'MANZATE Kit'
        );
        insert skuRec;
        Price_Book__c pbook =  new Price_Book__c();
        pbook.Name = 'BRL : Price List [DO NOT MODIFY]';
        pbook.CurrencyIsoCode='BRL';
        pbook.Valid_FROM__c = system.today();
        pbook.Expiry_Date__c = system.today()+360;
        insert pbook;
        Price_Book_Details__c PBdetails = new Price_Book_Details__c(
            SKU__c = skuRec.Id,                     
            Monthly_Interest_Rate__c = 1.00,          
            Price_Book__c = pbook.Id,                
            Exchange_Rate__c = 3.00,                 
            Unit_Price__c = 120.00,                  
            Minimum_Price__c = 75.00,                
            Minimum_Price_R__c = 5.00,
            Minimum_Price_U__c =2.00,
            Unit_Price_R__c = 28.14,
            Unit_Price_U__c = 8.54,
            Future_Sales_Price_R__c = 25.00,
            Future_Sales_Price_U__c = 30.00,
            Volume__c = 3000.00,
            Equivalence__c = 0.00,
            Group__c = '001',
            Sub_Group__c = 'Orthene',
            Anchor__c = 'SIM',
            Sub_Group_Required__c = 'SIM' 
        );
        insert PBdetails;

        
        
          Sales_Order_Line_Item__c soLineItm = new Sales_Order_Line_Item__c(
            Sale_Order__c = so3.Id,
            SKU_Name__c = skuRec.Id,
            Item_Number__c = 20,
            Item_Status__c = 'Not yet processed',
            Item_Cancel__c = false,
            Order_Item_Key__c = '836010',
            PriceBookDetail__c = PBdetails.Id,
            Approval_Flag__c = 0,
            ExchangeRate__c = exrate.id,
            OrderQuantityEdited__c = false,
            Time_in_months__c = 0,
            Days__c = 0, 
            DateofFAT__c =  system.today()+1, 
            Quantity__c = 450.00, 
            UnitValue__c = 100.00,
            UnitValuewithInterest__c = 100.00,
            InterestRate__c = 0.00,
            TotalTax__c = 0.00, 
            TotalFreight__c = 0.00,
            TotalPunctuality__c = 0.00,
            TotalLedgerCost__c = 0.00,
            TotalReplacementCost__c = 0.00 ,
            Customer_Conversion_Factor__c = 1
        );
        insert soLineItm;
       List<Sales_Order_Line_Item__c> soitemlist = new List<Sales_Order_Line_Item__c>();
       soitemlist.add(soLineItm); 
       UPL_Settings__c oUPLSetting = new UPL_Settings__c();
       oUPLSetting.Price2Win_Oauth_Username__c = 'test@test.com';
       oUPLSetting.Price2Win_Oauth_Passward__c = 'test@123';
       oUPLSetting.Token_Access_Endpoint_Price2Win__c = 'https://oauthasservices-ae7328026.hana.ondemand.com/oauth2/api/v1/token?grant1_type=client_credentials';
                oUPLSetting.Price2Win_StatusOrdemVendas_Endpoint__c = 'https://test.hcisbp.eu1.hina.ondemand.com/http/test';
SKUBrazilOutboundAPI.wrapOauthResponse wor= new SKUBrazilOutboundAPI.wrapOauthResponse();
		wor.access_token='wdq';
        wor.expires_in='21/3/2031';
        wor.scope='sc';
        wor.token_type='tt';
       insert oUPLSetting;
      // OrderItemBlocking.OrderItemChangeAPICall(so3,soitemlist);
         datetime d  =  Datetime.now();
          datetime d1 =  Datetime.now()-1;
       SKUBrazilOutboundAPI.SKUUpdate(so3.id,null,null);
       //  SKUBrazilOutboundAPI.SKUUpdate(so3.id,d,d1);
      
    
   }
}