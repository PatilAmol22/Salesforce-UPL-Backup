@isTest 
public class PolandOrderSearchControllerTest {
    static testMethod void validateHelloWorld() {

        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();

        Sales_Org__c sorg =new Sales_Org__c();
        sorg.Name='2941';
        sorg.Description__c='Poland';
        sorg.Sales_Org_Code__c='2941';
        insert sorg;

        Distribution_Channel__c disbj = new Distribution_Channel__c();
        disbj.Name = '20';                      
        disbj.Distribution_Channel_Code__c = '20';  
        disbj.Description__c='20';
        disbj.Sales_Org__c = sorg.id;
        insert disbj;
        
        Division__c divsn = new Division__c();
        divsn.Name = '10';         
        divsn.Description__c = '10';    
        divsn.Division_Code__c = '10'; 
        insert divsn;

        Account acc = new Account();
        acc.Name='Nikhil';
        acc.Last_Name__c='Dhoke';
        //acc.PriceGroupCode__c=pg.id;
        acc.SAP_Code__c='SAP996734';
        acc.RecordTypeId=devRecordTypeId;
        acc.Mobile__c='8600000000';
        acc.Phone='020200000';
        acc.Sales_Org__c=sorg.Id;
        //acc.Division__c=divsn.Id;
        //acc.Distribution_Channel__c=disbj.Id;
        acc.BillingCity='Mumbai';
       // acc.Order_Type__c=ordType.Id;
        acc.Depot_Code__c = 'ES51';
        //  acc.OwnerId=sobj.Id;
        insert acc;

        Product2 pro = new Product2();
        pro.ProductCode = '66700';
        pro.Product_Code__c='66700';
        pro.Name='DOST';
        pro.popular__c = true;
        pro.Combination_Key__c='RM0065100';
        insert pro;
        
        SKU__c sku = new SKU__c();
        sku.Name='DOST';
        sku.SKU_Code__c='704002';
        sku.SKU_Pack__c=1.00;
        sku.SKU_UOM__c='L';
        sku.Multiple_Of__c=5;
        sku.Group__c='DOST';
        sku.Pack_Size__c=10.00;
        sku.Product_Name__c=pro.Id;
        sku.Sales_Org__c = sorg.Id;
        sku.UOM__c='L';
        sku.Active__c=True;
        sku.Combination_Key__c='Cooooooo000011111';
        insert sku;

        Sales_Order__c salesOrder = new Sales_Order__c(
            //SFDC_Order_Number__c = '212964',                   // SFDC Order Number
            Order_Date__c = system.today(),            // Order Date
            Order_Approval_Date__c = system.today(),
           // Order__c = order.id,                        // Order
            SAP_Order_Number__c = '5010220050',                  // SAP Order Number
            Order_Status__c = 'Not yet processed',               // Order Status
            UGDN__c = '20003863',                                // UGDN
            Division_lk__c = divsn.id,                  // Division
            Distribution_Channel_lk__c = disbj.id,      // Distribution Channel
            CreatedFrom__c = 'SFDC',                             // Created From
            Sales_Org_lk__c = sorg.id,                 // Sales Org
            Total_Amount__c = 1804.00,                           // Total Amount
            Is_Order_FCA_Italy__c = false,                       // Is Order FCA
            Remarks__c = 'Test 3',                               // Remarks
            Order_FCA_Italy__c = false,                          // Order FCA
            PONumber__c = '65',                                  // PO Number
            Customer_Approval__c = false,                        // Customer Approval
            Early_Order_Discount__c = 2.00,                      // Early Order Discount
            is_Different_Free_Product__c = false,                // is Different Free Product
            Sold_to_Party__c = acc.id,                // Sold to Party
           // Depot_Code__c = depo.id,                              // Depot Code
            Bill_To_Party__c = acc.id,                // Bill To Party
          //  Ship_To_Party__c = shippLoc.id,                // Ship To Party
            Sent_for_Manager_Approval_Mexico__c = false,         // Sent for Manager Approval
            DirectApproved__c = false,                           // Direct Approved
            Sent_for_Director_Approval_Mexico__c = false,        // Sent for Director Approval
            Sent_for_Latam_Director_Approval__c = false,         // Sent for Latam Director Approval
            Check_Transport_contribution__c = false,             // Check Transport contribution
            Is_Payment_Term_Discount_Approval_Italy__c = false,  // Is Payment Term Discount Approval
            Is_Express_Delivery_Italy__c = false                // Is Express Delivery
          );
          insert salesOrder;

          Sales_Order_Line_Item__c soLineItem1 = new Sales_Order_Line_Item__c(
            Order_Item_Key__c = '0109202021296410',     // OrderNumber_Item_Key
            Item_Number__c = 10,                        // Item Number
            UOM__c = 'L',                                 // UOM
           // DepotDepot__c = depo.id,            // Depot
            Sale_Order__c = salesOrder.id,            // Sales Order
            SKU_Name__c = sku.id,              // SKU Name
            Item_Status__c = 'Active',                    // Item Status
            Division__c = divsn.id,              // Division
            Distribution_Channel__c = disbj.id,  // Distribution Channel
            Price__c = 10.00,                             // Value
         //   Storage_Location__c = storageLoc.id,      // Storage Location
            Stock_Available__c = false,                   // Stock Available
            is_Approval_Required__c = false,              // is Approval Required
            is_Different_Free_Product__c = false,         // is Different Free Product
            Apply_Campaign_Discount__c = true,            // Apply Campaign Discount
            Actual_Discount__c = 1.20,                    // Actual Discount
            Edited_Discount__c = 1.20,                    // Edited Discount
            Line_Discount__c = 2.00,                      // Line Discount
            Volume_Discount__c = 5.00,                    // Volume Discount
            Actual_Line_Discount__c = 2.00,               // Actual Line Discount
            Actual_Volume_Discount__c = 5.00,             // Actual Volume Discount
            Actual_Campaign_Discount__c = 5.00,           // Actual Campaign Discount
            Net_Price__c = 1804.00,                       // Net Price
            FinalPrice__c = 8.80,                         // Edited Estimated Final Price
            Quantity__c = 205.00,                       // Quantity
            Shipping_Date__c = system.today(),  // Shipping Date
            Check_Transport_contribution__c = false,      // Check Transport contribution
            Campaign_Discount__c = 5                     // Campaign Discount (%)
        );
        insert soLineItem1;


        //PolandOrderSearchController psoc = new PolandOrderSearchController();
        PolandOrderSearchController.getOrderData(1,1,sku.id,String.valueOf(system.today()),String.valueOf(system.today()));
        PolandOrderSearchController.getOrderDataToDownload(sku.id,String.valueOf(system.today()),String.valueOf(system.today()));
    }
}