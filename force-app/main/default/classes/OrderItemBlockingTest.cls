@istest
public class OrderItemBlockingTest {

    
   static testMethod void myUnitTest() { 
        // User cuser = [select id from user where username ='newone@noemail.com' limit 1];
   // System.RunAs(cuser) {
          //  OrderItemBlocking tmpObj = new OrderItemBlocking();
            //AccountSummaryReportCtrl.CreditInfoWrapper creditInfo = new AccountSummaryReportCtrl.CreditInfoWrapper();
           // AccountSummaryReportCtrl.wrapOauthResponse Response = new AccountSummaryReportCtrl.wrapOauthResponse();
           // AccountSummaryReportCtrl.WrapCreditInfo WrapCredit = new AccountSummaryReportCtrl.WrapCreditInfo();
           // AccountSummaryReportCtrl.wrapOutstanding Outstanding = new AccountSummaryReportCtrl.wrapOutstanding();          
            //Test.setMock(HttpCalloutMock.class, new ExampleCalloutMock());
          //  Test.setMock(HttpCalloutMock.class, new ExampleCalloutMock2());
           // Test.setMock(HttpCalloutMock.class, new ExampleCalloutMock3());
       //Test.setMock(HttpCalloutMock.class, new ExampleCalloutMock4());
        Sales_Order__c so3 = new Sales_Order__c();
        so3.Currency_Brazil__c = 'Billing USD / Payment USD';  
        so3.Valid_FROM__c = System.today();        
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
            Item_Number__c = 10,
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
       oUPLSetting.Price2Win_SalesOrderBlockItem_Endpoint__c = 'https://l4237-iflmap.hcisbp.eu1.hina.ondemand.com/http/Sales_Order_Block_Item_Brazil';
       oUPLSetting.Price2Win_SalesOrderChange_Endpoint__c = 'https://test.hcisbp.eu1.hina.ondemand.com/http/test';
       insert oUPLSetting;
       OrderItemBlocking.OrderItemBlockingAPICall1(so3,soitemlist,1);
       OrderItemBlocking.OrderItemBlockingAPICall1(so3,soitemlist,2);
       OrderItemBlocking.OrderItemBlockingAPICall1(so3,soitemlist,3);
       OrderItemBlocking.OrderItemBlockingAPICall2(so3.id,json.serialize(soitemlist));
       
      //  } 
    
   }
    
     static testMethod void myUnitTest1() { 
        // User cuser = [select id from user where username ='newone@noemail.com' limit 1];
   // System.RunAs(cuser) {
          //  OrderItemBlocking tmpObj = new OrderItemBlocking();
            //AccountSummaryReportCtrl.CreditInfoWrapper creditInfo = new AccountSummaryReportCtrl.CreditInfoWrapper();
           // AccountSummaryReportCtrl.wrapOauthResponse Response = new AccountSummaryReportCtrl.wrapOauthResponse();
           // AccountSummaryReportCtrl.WrapCreditInfo WrapCredit = new AccountSummaryReportCtrl.WrapCreditInfo();
           // AccountSummaryReportCtrl.wrapOutstanding Outstanding = new AccountSummaryReportCtrl.wrapOutstanding();          
            //Test.setMock(HttpCalloutMock.class, new ExampleCalloutMock());
          //  Test.setMock(HttpCalloutMock.class, new ExampleCalloutMock2());
           // Test.setMock(HttpCalloutMock.class, new ExampleCalloutMock3());
       //Test.setMock(HttpCalloutMock.class, new ExampleCalloutMock4());
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
            //  SAP_Order_Number__c='7676767676',
            SKU_Name__c = skuRec.Id,
            Item_Number__c = 10,
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
       //oUPLSetting.Price2Win_SalesOrderBlockItem_Endpoint__c = 'https://l4237-iflmap.hcisbp.eu1.hina.ondemand.com/http/Sales_Order_Block_Item_Brazil';
       oUPLSetting.Price2Win_SalesOrderChange_Endpoint__c = 'https://test.hcisbp.eu1.hina.ondemand.com/http/test';
       insert oUPLSetting;
       OrderItemBlocking.OrderItemChangeAPICall(so3,soitemlist);
         
    
   }
}