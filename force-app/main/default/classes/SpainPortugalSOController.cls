public without sharing class SpainPortugalSOController {
  
    @AuraEnabled   
    public static OrderWrapper getOrderDetails(String id_val){
        OrderWrapper orderWrap = new OrderWrapper();
        CreditSummaryWrapper csWrap = new CreditSummaryWrapper();
        List<Sales_Order__c> SOObj;
        List<Order__c> orderObj;
        List<Account> accList;
        List<Shipping_Location__c> shippingLocationList;
        List<Payment_Method__c> PaymentMethodList;
        List<Inco_Term__c> IncoTermList; //added by Vaishnavi w.r.t CR-RITM0378141

        List<Payment_Term__c> PaymentTermList;
        Map<String,Shipping_Location__c> shippingMap;
        List<DistributorSalesAreaMapping__c> orderForList;
        User loginUserObj;
        String SelectedCurrency = '';
        String accountId='';
        String Sales_Org_Code = '';
        
        List<OrderItemWrapper> orderItemList = new List<OrderItemWrapper>();
        try{

            SelectedCurrency = 'EUR';

            loginUserObj = [SELECT Id, Name, Country, IsActive, Show_Inventory__c, Show_Credit_Limit__c, 
                            Show_Inventory_Column__c, Show_InTransit__c, Show_InTransit_Values__c, 
                            ProfileId,Profile.Name, ManagerId, Country_Head__c
                            FROM User WHERE Id =: UserInfo.getUserId() AND IsActive = True];

            /* --------- Start SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022 ----------------------*/
            List<Login_Country__c> logCntry = new List<Login_Country__c>();
            logCntry = [SELECT Id, Name, For_Contry__c, Sales_Org_Code__c, Delivery_Date__c, 
                        PO_Date__c, Show_Delivery_Date__c, Show_PO_Date__c FROM Login_Country__c 
                        where Name =:loginUserObj.Country limit 1];

            if(logCntry.size() > 0){
                orderWrap.showPODate = logCntry[0].Show_PO_Date__c;
                orderWrap.showDeliveryDate = logCntry[0].Show_Delivery_Date__c;
                orderWrap.isPORequired = logCntry[0].PO_Date__c;
                orderWrap.isDeliveryRequired = logCntry[0].Delivery_Date__c;
            }  
            /*-------------- End SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022 ----------------------*/               

            List<Early_Order_Discount__c> eod = new List<Early_Order_Discount__c>();                
            if(loginUserObj.Country == 'Spain'){
                eod = [SELECT Id, Name, Discount__c FROM Early_Order_Discount__c WHERE Name = 'Spain' LIMIT 1];
                orderWrap.disable_EOD = false;
            } 
            else if(loginUserObj.Country == 'Portugal'){
                eod = [SELECT Id, Name, Discount__c FROM Early_Order_Discount__c WHERE Name = 'Portugal' LIMIT 1];
                orderWrap.disable_EOD = false;
            }
            else{
                orderWrap.disable_EOD = true;
            }  
            List<Decimal> eodList = new List<Decimal>();
            eodList.add(0);

            if(eod.size()>0){
                eodList.add(eod[0].Discount__c);
                //orderWrap.countryWise_EOD = eod[0].Discount__c;
            }
            else{
                eodList.add(0);
                //orderWrap.countryWise_EOD = 0;
            }
            orderWrap.countryWise_EOD = eodList;

            SOObj = new List<Sales_Order__c>();
            /* --------- Start SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022 ----------------------*/
            SOObj = [SELECT Id, Name, Bill_To_Party__c, Order_Status__c, Ship_To_Party__c, Sales_Org_lk__c, 
                    Remarks__c, PONumber__c, Order_Type_lk__c, Depot__c, Early_Order_Discount__c,
                    Order_For__c, CurrencyIsoCode, Sold_to_Party__c, Ship_To_Party__r.Region__c, Purchase_Order_Date__c, 
                    Ship_To_Party__r.City__c, Ship_To_Party__r.State__c, Ship_To_Party__r.Pincode__c,
                    Total_Amount__c, Gross_Amount_With_Early_Discount__c, OwnerId, Order__c, SalesOrgCode__c, 
                    Inco_Term__c, Inco_Term__r.IncoTerm_Desc__c, PaymentMethod__c, PaymentMethod__r.Description__c, 
                    Payment_Term__c, Payment_Term__r.Payterms_Desc__c, Distribution_Channel_lk__c, Division_lk__c
                    FROM Sales_Order__c WHERE Order_Status__c='Draft' AND Bill_To_Party__c =: id_val 
                    ORDER BY CreatedDate DESC LIMIT 1];
                    
            if(SOObj.size()==0){
                /* --------- Start SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022 ----------------------*/
                SOObj = [SELECT Id, Name, Bill_To_Party__c, Order_Status__c, Ship_To_Party__c, Sales_Org_lk__c, 
                        Remarks__c, PONumber__c, Order_Type_lk__c, Depot__c, Early_Order_Discount__c,
                        Order_For__c, CurrencyIsoCode, Sold_to_Party__c, Ship_To_Party__r.Region__c, Purchase_Order_Date__c, 
                        Ship_To_Party__r.City__c, Ship_To_Party__r.State__c, Ship_To_Party__r.Pincode__c,
                        Total_Amount__c, Gross_Amount_With_Early_Discount__c, OwnerId, Order__c, SalesOrgCode__c, 
                        Inco_Term__c, Inco_Term__r.IncoTerm_Desc__c, PaymentMethod__c, PaymentMethod__r.Description__c, 
                        Payment_Term__c, Payment_Term__r.Payterms_Desc__c, Distribution_Channel_lk__c, Division_lk__c
                        FROM Sales_Order__c WHERE Id =: id_val limit 1];
            }
            System.debug('Sales org obj... -- '+ SOObj);

            if(SOObj.size()==0){
                orderObj = new List<Order__c>();
                /* --------- Start SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022 ----------------------*/
                orderObj = [SELECT Id, Name, Bill_To_Party__c, Order_Status__c, Sales_Org__c, Depot__c,
                            Order_Type__c, PONumber__c, Remarks__c, Shipping_Location__c, Order_For__c,
                            Gross_Amount_With_Early_Discount__c, OwnerId, Early_Order_Discount__c, PO_Date__c, 
                            Gross_Net__c, Shipping_Location__r.Region__c, Shipping_Location__r.City__c, 
                            Shipping_Location__r.State__c, Shipping_Location__r.Pincode__c, Sales_Org__r.Sales_Org_Code__c 
                            FROM Order__c WHERE Order_Status__c='Draft' AND 
                            Bill_To_Party__c =:id_val ORDER BY CreatedDate DESC LIMIT 1];

                accList = new List<Account>(); 
                accList = getAccountDetails(id_val);
                accountId = id_val;

                orderWrap.inco_term = accList[0].Inco_Term__r.IncoTerm_Desc__c;
                orderWrap.inco_term_id = accList[0].Inco_Term__c;
                orderWrap.payment_method = accList[0].Payment_Method__r.Description__c;
                orderWrap.payment_method_id = accList[0].Payment_Method__c;
                orderWrap.payment_term = accList[0].Payment_Term_Code__r.Payterms_Desc__c;
                orderWrap.payment_term_id = accList[0].Payment_Term_Code__c;

                if(orderObj.size()<=0){
                    Order__c ordObj2 = new Order__c();
                    ordObj2.Bill_To_Party__c = id_val;
                   // ordObj2.OwnerId = accList[0].OwnerId;                               
                    ordObj2.Order_Date__c = System.today();
                    ordObj2.Order_Status__c = 'Draft';
                    ordObj2.CurrencyIsoCode = SelectedCurrency;
                    ordObj2.Early_Order_Discount__c = 0;
                    //ordObj2.Gross_Amount_With_Early_Discount__c = 0.0;
                   // ordObj2.Order_Raise_By__c = 'Distributor';
                   // ordObj2.Sales_Org__c = accList[0].Sales_Org__c;
                    //ordObj2.Distribution_Channel__c = distWrapObj.distributorChannelId; 
                    // ordObj2.Division__c = distWrapObj.divisionId; //TODO : 
                                       
                    insert ordObj2;
                    orderWrap.ordr_id = ordObj2.Id;
                    orderWrap.isSalesOrder = false;
                    orderWrap.status = ordObj2.Order_Status__c;
                    orderWrap.orderFor = '';
                    orderWrap.early_ordr_discount = ordObj2.Early_Order_Discount__c;
                    orderWrap.ownerId = ''; //ordObj2.OwnerId;
                    orderWrap.so_id = '';
                    orderWrap.shipping_loc = '';
                }
                else{
                    Sales_Org_Code = orderObj[0].Sales_Org__r.Sales_Org_Code__c;
                    orderWrap.isSalesOrder = false;
                    orderWrap.ordr_id = orderObj[0].Id;
                    orderWrap.status = orderObj[0].Order_Status__c;
                    orderWrap.ownerId = orderObj[0].OwnerId;
                 
                    if(orderObj[0].Shipping_Location__c == null){
                        orderWrap.shipping_loc = '';
                    }
                    else{
                        orderWrap.shipping_loc = orderObj[0].Shipping_Location__c;
                    }
                    
                    orderWrap.so_id = '';

                    if(orderObj[0].Shipping_Location__r.Region__c != null){
                        orderWrap.shipping_loc_details = orderObj[0].Shipping_Location__r.Region__c;
                    }
                    if(orderObj[0].Shipping_Location__r.City__c != null){                         
                        orderWrap.shipping_loc_details = orderWrap.shipping_loc_details + ', ' + orderObj[0].Shipping_Location__r.City__c;
                    }
                    if(orderObj[0].Shipping_Location__r.State__c != null){
                        orderWrap.shipping_loc_details = orderWrap.shipping_loc_details + ', ' + orderObj[0].Shipping_Location__r.State__c;
                    }
                    if(orderObj[0].Shipping_Location__r.Pincode__c != null){
                        orderWrap.shipping_loc_details = orderWrap.shipping_loc_details + ', ' + orderObj[0].Shipping_Location__r.Pincode__c;
                    }

                    if(orderObj[0].Order_For__c == null){
                        orderWrap.orderFor = '';
                    }
                    else{
                        orderWrap.orderFor = orderObj[0].Order_For__c;
                    }
                    
                    orderWrap.po_no = orderObj[0].PONumber__c;
                    orderWrap.remark = orderObj[0].Remarks__c;
                    if(orderObj[0].Early_Order_Discount__c == null){
                        orderWrap.early_ordr_discount = 0;
                    }
                    else{
                        orderWrap.early_ordr_discount = orderObj[0].Early_Order_Discount__c;
                    }

                    /* --------- Start SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022 ----------------------*/
                    if(orderObj[0].PO_Date__c != null){
                        orderWrap.poDate = String.valueOf(orderObj[0].PO_Date__c);
                    }
                    else{
                        orderWrap.poDate = String.valueOf(System.today()); // updated for RITM0475047 GRZ(Nikhil Verma) 16-12-2022
                    }
                    /*------------- End SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022 ----------------------*/

                    orderWrap.total_amount = orderObj[0].Gross_Net__c;
                    orderWrap.gross_amount = orderObj[0].Gross_Amount_With_Early_Discount__c;

                    List<OrderLineItem__c> orderItems = new List<OrderLineItem__c>();
                    /* --------- Start SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022 ----------------------*/
                    orderItems = [SELECT Id, Name, Campaign_Discount__c, FinalPrice__c, multipleOf__c, Net_Price__c,
                                  Order__c, Price__c, Quantity__c, Shipping_Date__c, SKU_Name__c, SKU_Name__r.Name, SKU_Name__r.SKU_Description__c,
                                  UOM__c, Price_Book_Master__c,Price_Book_Master__r.Country_Tax__c,Pricebook_Discount_Id__c, Apply_Campaign_Discount__c, Delivery_Date__c, 
                                  Campaign__c, Campaign__r.Name, Distribution_Channel__c, Division__c, Actual_Discount__c, 
                                  Edited_Discount__c, Line_Discount__c, Volume_Discount__c, Actual_Campaign_Discount__c,
                                  Actual_Line_Discount__c,Actual_Net_Price__c, Actual_Volume_Discount__c, Item_Number__c, SKU_Name__r.Mininum_Quantity__c,Base_Price_Without_Tax__c,
                                  Campaign_Code__c FROM OrderLineItem__c WHERE Order__c =: orderObj[0].Id];

                    if(orderItems.size()>0){
                        
                        for(OrderLineItem__c ordItem : orderItems){
                            OrderItemWrapper itemWrap = new OrderItemWrapper();
                            itemWrap.orderItem_id = ordItem.Id;
                            itemWrap.order_id = ordItem.Order__c;
                            itemWrap.pb_id = ordItem.Price_Book_Master__c;
                            itemWrap.sku_name = ordItem.SKU_Name__r.SKU_Description__c;
                            itemWrap.sku_id = ordItem.SKU_Name__c;
                            itemWrap.uom = ordItem.UOM__c;

                            if(ordItem.Campaign__c != null){
                                itemWrap.campaign_nm = ordItem.Campaign__r.Name;
                                itemWrap.campaign_id = ordItem.Campaign__c;
                                itemWrap.pb_discount_id = ordItem.Pricebook_Discount_Id__c;
                            }
                            
                            itemWrap.apply_cmpgn_disc = ordItem.Apply_Campaign_Discount__c;
                            itemWrap.campaign_discount = ordItem.Campaign_Discount__c;
                            itemWrap.line_discount = ordItem.Line_Discount__c;
                            itemWrap.volume_discount = ordItem.Volume_Discount__c;
                            itemWrap.quantity = ordItem.Quantity__c;
                            itemWrap.final_price = ordItem.FinalPrice__c;
                            itemWrap.net_price = ordItem.Net_Price__c;
                            itemWrap.base_price = ordItem.Price__c;
                            //itemWrap.net_price = ordItem.Price__c;
                            //itemWrap.base_price = ordItem.Net_Price__c;
                            itemWrap.shipmnt_date = string.valueOf(ordItem.Shipping_Date__c);
                            //itemWrap.inventory = ordItem.;
                            itemWrap.actual_discount = ordItem.Actual_Discount__c;
                            itemWrap.edited_discount = ordItem.Edited_Discount__c;
                            itemWrap.multiple_of = ordItem.multipleOf__c;
                            itemWrap.actual_campaign_discount = ordItem.Actual_Campaign_Discount__c;
                            itemWrap.actual_line_discount = ordItem.Actual_Line_Discount__c;
                            itemWrap.actual_base_price = ordItem.Actual_Net_Price__c;//Sayan
                            itemWrap.actual_volume_discount = ordItem.Actual_Volume_Discount__c;
                            itemWrap.distributionChanlIds = ordItem.Distribution_Channel__c;
                            itemWrap.divisionIds = ordItem.Division__c;
                            itemWrap.itemNumber = Integer.ValueOf(ordItem.Item_Number__c);
                            itemWrap.campaign_code = ordItem.Campaign_Code__c;
                            itemWrap.tax = ordItem.Price_Book_Master__r.Country_Tax__c; //Priya //uncommented by vaishnavi w.r.t CR-RITM0378156
							itemWrap.base_Price_without_tax = ordItem.Base_Price_without_Tax__c;
                            if(ordItem.SKU_Name__r.Mininum_Quantity__c == null){
                                itemWrap.min_quantity = 0;
                            }
                            else{
                                itemWrap.min_quantity = ordItem.SKU_Name__r.Mininum_Quantity__c;
                            }

                            if(ordItem.UOM__c.toUpperCase() == 'KG'){
                                orderWrap.quantity_kg = orderWrap.quantity_kg + ordItem.Quantity__c;
                                orderWrap.net_price_kg = (orderWrap.net_price_kg + ordItem.Net_Price__c).setScale(2);
                                //orderWrap.net_price_kg = (orderWrap.net_price_kg + ordItem.Price__c).setScale(2);
                            }
                            else if(ordItem.UOM__c.toUpperCase() == 'L'){
                                orderWrap.quantity_litre = orderWrap.quantity_litre + ordItem.Quantity__c;
                                orderWrap.net_price_litre = (orderWrap.net_price_litre + ordItem.Net_Price__c).setScale(2);
                                //orderWrap.net_price_litre = (orderWrap.net_price_litre + ordItem.Price__c).setScale(2);
                            }
                            else if(ordItem.UOM__c.toUpperCase() == 'BT'){
                                orderWrap.quantity_bottle = orderWrap.quantity_bottle + ordItem.Quantity__c;
                                orderWrap.net_price_bottle = (orderWrap.net_price_bottle + ordItem.Net_Price__c).setScale(2);
                                //orderWrap.net_price_bottle = (orderWrap.net_price_bottle + ordItem.Price__c).setScale(2);
                            }

                            if(Integer.ValueOf(ordItem.Item_Number__c) > orderWrap.lastItemNumber){
                                orderWrap.lastItemNumber = Integer.ValueOf(ordItem.Item_Number__c);
                            }

                            /* --------- Start SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022 ----------------------*/
                            if(ordItem.Delivery_Date__c == null){
                                itemWrap.deliveryDate = '';
                            }
                            else{
                                itemWrap.deliveryDate = String.valueOf(ordItem.Delivery_Date__c);
                            }
                            /* --------End SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022 ----------------------*/

                            orderItemList.add(itemWrap);
                        }
                    }              
                }
            }
            else{
                accountId = SOObj[0].Bill_To_Party__c;
                accList = new List<Account>(); 
                accList = getAccountDetails(accountId);
                Sales_Org_Code = SOObj[0].SalesOrgCode__c;
                orderWrap.status = SOObj[0].Order_Status__c;
                orderWrap.isSalesOrder = true;
                orderWrap.so_id = SOObj[0].Id;
                orderWrap.ordr_id = SOObj[0].Order__c;
                orderWrap.status = SOObj[0].Order_Status__c;
                orderWrap.ownerId = SOObj[0].OwnerId;
                orderWrap.shipping_loc = SOObj[0].Ship_To_Party__c;

                if(SOObj[0].Ship_To_Party__r.Region__c != null){
                    orderWrap.shipping_loc_details = SOObj[0].Ship_To_Party__r.Region__c;
                }
                if(SOObj[0].Ship_To_Party__r.City__c != null){                         
                    orderWrap.shipping_loc_details = orderWrap.shipping_loc_details + ', ' + SOObj[0].Ship_To_Party__r.City__c;
                }
                if(SOObj[0].Ship_To_Party__r.State__c != null){
                    orderWrap.shipping_loc_details = orderWrap.shipping_loc_details + ', ' + SOObj[0].Ship_To_Party__r.State__c;
                }
                if(SOObj[0].Ship_To_Party__r.Pincode__c != null){
                    orderWrap.shipping_loc_details = orderWrap.shipping_loc_details + ', ' + SOObj[0].Ship_To_Party__r.Pincode__c;
                }
                orderWrap.orderFor = SOObj[0].Order_For__c;
                orderWrap.po_no = SOObj[0].PONumber__c;
                orderWrap.remark = SOObj[0].Remarks__c;
                orderWrap.early_ordr_discount = SOObj[0].Early_Order_Discount__c;
                orderWrap.total_amount = SOObj[0].Total_Amount__c ;
                orderWrap.gross_amount = SOObj[0].Gross_Amount_With_Early_Discount__c;
                orderWrap.CurrencyCode = SOObj[0].CurrencyIsoCode;
                orderWrap.salesOrgObj = SOObj[0].Sales_Org_lk__c;
                orderWrap.Order_Type = SOObj[0].Order_Type_lk__c;
                orderWrap.Depo_Obj = SOObj[0].Depot__c;

                if(SOObj[0].Inco_Term__c == null){
                    orderWrap.inco_term = '';
                    orderWrap.inco_term_id = '';
                }
                else{
                    orderWrap.inco_term = SOObj[0].Inco_Term__r.IncoTerm_Desc__c;
                    orderWrap.inco_term_id = SOObj[0].Inco_Term__c;
                }

                if(SOObj[0].PaymentMethod__c == null){
                    orderWrap.payment_method = '';
                    orderWrap.payment_method_id = '';
                }
                else{
                    orderWrap.payment_method = SOObj[0].PaymentMethod__r.Description__c;
                    orderWrap.payment_method_id = SOObj[0].PaymentMethod__c;
                }
                
                if(SOObj[0].Payment_Term__c == null){
                    orderWrap.payment_term = '';
                    orderWrap.payment_term_id = '';
                }
                else{
                    orderWrap.payment_term = SOObj[0].Payment_Term__r.Payterms_Desc__c;
                    orderWrap.payment_term_id = SOObj[0].Payment_Term__c;
                }

                /* --------- Start SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022 ----------------------*/
                if(SOObj[0].Purchase_Order_Date__c != null){
                    orderWrap.poDate = String.valueOf(SOObj[0].Purchase_Order_Date__c);
                }
                else{
                    orderWrap.poDate = '';
                }
                /* --------- End SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022 ----------------------*/

                List<String> divIds = new List<String>();
                List<String> disIds = new List<String>();

                List<Sales_Order_Line_Item__c> orderItems = new List<Sales_Order_Line_Item__c>();
                /* --------- Start SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022 ----------------------*/
                //INC0416329 Change by Mohit(Grazitti)
                //Change by Aashima(Grazitti) RITM0509178 2 march 2023
                    orderItems = [SELECT Id, Name, SKU_Name__c, SKU_Name__r.Name, DepotDepot__c, SKU_Name__r.SKU_Description__c,
                                  Storage_Location__c, UOM__c, CurrencyIsoCode, multipleOf__c, Finalprice__c, 
                                  Net_Price__c, Quantity__c, Price__c, Sale_Order__c, Shipping_Date__c, 
                                  PriceBookMaster__c,Pricebook_Discount_Id__c, Campaign__c, Campaign__r.Name,
                                  Apply_Campaign_Discount__c, Actual_Campaign_Discount__c, Actual_Line_Discount__c,Actual_Net_Price__c,
                                  Actual_Volume_Discount__c, Actual_Discount__c, Edited_Discount__c, Delivery_Date__c, 
                                  Campaign_Discount__c, Line_Discount__c, Volume_Discount__c, Campaign_Code__c,
                                  Distribution_Channel__c, Division__c, Item_Number__c,PriceBookMaster__r.Country_Tax__c, SKU_Name__r.Mininum_Quantity__c, Base_Price_Without_Tax__c
                                  FROM Sales_Order_Line_Item__c WHERE Sale_Order__c =: SOObj[0].Id];

                    if(orderItems.size()>0){
                        
                        for(Sales_Order_Line_Item__c ordItem : orderItems){
                            OrderItemWrapper itemWrap = new OrderItemWrapper();
                            itemWrap.orderItem_id = ordItem.Id;
                            itemWrap.order_id = ordItem.Sale_Order__c;
                            itemWrap.pb_id = ordItem.PriceBookMaster__c;
                            itemWrap.sku_name = ordItem.SKU_Name__r.SKU_Description__c;
                            itemWrap.sku_id = ordItem.SKU_Name__c;
                            itemWrap.uom = ordItem.UOM__c;

                            if(ordItem.Campaign__c != null){
                                itemWrap.campaign_nm = ordItem.Campaign__r.Name;
                                itemWrap.campaign_id = ordItem.Campaign__c;
                                itemWrap.pb_discount_id = ordItem.Pricebook_Discount_Id__c;
                            }
                            
                            itemWrap.apply_cmpgn_disc = ordItem.Apply_Campaign_Discount__c;
                            itemWrap.campaign_discount = ordItem.Campaign_Discount__c;
                            itemWrap.line_discount = ordItem.Line_Discount__c;
                            itemWrap.volume_discount = ordItem.Volume_Discount__c;
                            itemWrap.quantity = ordItem.Quantity__c;
                            itemWrap.final_price = ordItem.FinalPrice__c;
                            //itemWrap.base_price = ordItem.Price__c;
                            //itemWrap.net_price = ordItem.Net_Price__c;
                            itemWrap.base_price = ordItem.Net_Price__c;
                            itemWrap.net_price = ordItem.Price__c;
                            itemWrap.shipmnt_date = string.valueOf(ordItem.Shipping_Date__c);
                            //itemWrap.inventory = ordItem.;
                            itemWrap.actual_discount = ordItem.Actual_Discount__c;
                            itemWrap.edited_discount = ordItem.Edited_Discount__c;
                            itemWrap.multiple_of = ordItem.multipleOf__c;
                            itemWrap.actual_campaign_discount = ordItem.Actual_Campaign_Discount__c;
                            itemWrap.actual_line_discount = ordItem.Actual_Line_Discount__c;
                            itemWrap.actual_base_price = ordItem.Actual_Net_Price__c;//Sayan
                            itemWrap.actual_volume_discount = ordItem.Actual_Volume_Discount__c;
                            itemWrap.distributionChanlIds = ordItem.Distribution_Channel__c;
                            itemWrap.divisionIds = ordItem.Division__c;
                            itemWrap.itemNumber = Integer.valueOf(ordItem.Item_Number__c);
                            itemWrap.campaign_code = ordItem.Campaign_Code__c;
                            itemWrap.tax = ordItem.PriceBookMaster__r.Country_Tax__c; //Priya //uncommented by vaishnavi w.r.t CR-RITM0378156
                            itemWrap.base_price_without_tax=ordItem.Base_Price_Without_Tax__c; //Change by Aashima(Grazitti) RITM0509178 2 march 2023
                            if(ordItem.SKU_Name__r.Mininum_Quantity__c == null){
                                itemWrap.min_quantity = 0;
                            }
                            else{
                                itemWrap.min_quantity = ordItem.SKU_Name__r.Mininum_Quantity__c;
                            }

                            if(ordItem.UOM__c.toUpperCase() == 'KG'){
                                orderWrap.quantity_kg = orderWrap.quantity_kg + ordItem.Quantity__c;
                                //orderWrap.net_price_kg = (orderWrap.net_price_kg + ordItem.Net_Price__c).setScale(2);
                                orderWrap.net_price_kg = (orderWrap.net_price_kg + ordItem.Price__c).setScale(2);
                            }
                            else if(ordItem.UOM__c.toUpperCase() == 'L'){
                                orderWrap.quantity_litre = orderWrap.quantity_litre + ordItem.Quantity__c;
                                //orderWrap.net_price_litre = (orderWrap.net_price_litre + ordItem.Net_Price__c).setScale(2);
                                orderWrap.net_price_litre = (orderWrap.net_price_litre + ordItem.Price__c).setScale(2);
                            }
                            else if(ordItem.UOM__c.toUpperCase() == 'BT'){
                                orderWrap.quantity_bottle = orderWrap.quantity_bottle + ordItem.Quantity__c;
                                //orderWrap.net_price_bottle = (orderWrap.net_price_bottle + ordItem.Net_Price__c).setScale(2);
                                orderWrap.net_price_bottle = (orderWrap.net_price_bottle + ordItem.Price__c).setScale(2);
                            }

                            if(Integer.ValueOf(ordItem.Item_Number__c) > orderWrap.lastItemNumber){
                                orderWrap.lastItemNumber = Integer.ValueOf(ordItem.Item_Number__c);
                            }

                            /* --------- Start SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022 ----------------------*/
                            if(ordItem.Delivery_Date__c != null){
                                itemWrap.deliveryDate = String.valueOf(ordItem.Delivery_Date__c);
                            }
                            else{
                                itemWrap.deliveryDate = '';
                            }
                            /* ---------End SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022 ----------------------*/

                            orderItemList.add(itemWrap);
                            divIds.add(ordItem.Division__c);
                            disIds.add(ordItem.Distribution_Channel__c);
                            orderWrap.Shipping_Point = ordItem.Storage_Location__c;
                            orderWrap.Storage_Location = ordItem.Storage_Location__c;
                        }
                    }
                    else{
                        divIds.add(SOObj[0].Division_lk__c);
                        disIds.add(SOObj[0].Distribution_Channel_lk__c);
                        OrderForWrapper orderFor2 = new OrderForWrapper();
                        orderFor2 = setOrderFor(Sales_Org_Code);
                        orderWrap.Shipping_Point = orderFor2.Shipping_Point.Id;
                        orderWrap.Storage_Location = orderFor2.Storage_Location.Id;
                    }

                    orderWrap.distributionChanlIds = disIds;
                    orderWrap.divisionIds = divIds;
            }

            if(orderItemList.size()>0 && Sales_Org_Code != ''){
                OrderForWrapper orderFor = new OrderForWrapper();
                orderFor = setOrderFor(Sales_Org_Code);

                String combKey = orderFor.Storage_Location.Name+''+orderFor.Depo_Obj.Name;
                Map<String,Inventory__c> inventoryMap = new Map<String,Inventory__c>();
                Map<String,decimal> inventoryBalancedQuantityMap = new Map<String,decimal>();//Sayan

                List<Inventory__c> stockReq = new  List<Inventory__c>();
                stockReq = getInventory('',orderFor.Depo_Obj.Id,combKey);
                
                if(stockReq.size()>0){
                    Decimal values=0;//Sayan
                    for(Inventory__c stReq : stockReq){
                        if(!inventoryMap.containsKey(stReq.SKU__c)){
                            inventoryMap.put(stReq.SKU__c,stReq);
                        }
                        //Sayan
                        if(inventoryBalancedQuantityMap.containsKey(stReq.SKU__c)){
                            values += inventoryBalancedQuantityMap.get(stReq.SKU__c);
                            inventoryBalancedQuantityMap.put(stReq.SKU__c,values);
                            
                        }else{
                            inventoryBalancedQuantityMap.put(stReq.SKU__c,stReq.Balanced_Quanity__c);
                        }
                        //Sayan
                    }

                    if(inventoryMap.size()>0){
                        for(OrderItemWrapper itemW : orderItemList){
                            if(inventoryMap.containsKey(itemW.sku_id)){
                                itemW.inventory= inventoryMap.get(itemW.sku_id).Balanced_Quanity__c;
                                itemW.inventory = inventoryBalancedQuantityMap.get(itemW.sku_id);//Sayan
                            }
                        }
                    }
                }
                
                
            }
            //Added for fetching the Payment Methods and Payment Terms
            List<Payment_Method_Term__c> lstpaymentmethod = new List<Payment_Method_Term__c>();
            List<String> lstpaymentmethodSpain = new List<String>();
            List<String> lstpaymenttermSpain = new List<String>();
            lstpaymentmethod = [SELECT Id,Name,Payment_Method_Spain__c,Payment_Term_Spain__c FROM Payment_Method_Term__c Order BY Name ASC];
            if(lstpaymentmethod.size()>0){
               for(Payment_Method_Term__c paymentmethod : lstpaymentmethod)
               {
                   if(paymentmethod.Payment_Method_Spain__c!='')
                    lstpaymentmethodSpain.add(paymentmethod.Payment_Method_Spain__c); 
                   if(paymentmethod.Payment_Term_Spain__c!='')
                    lstpaymenttermSpain.add(paymentmethod.Payment_Term_Spain__c);
               }
            }
            PaymentMethodList= new  List<Payment_Method__c>();
            if(lstpaymentmethodSpain.size()>0){
             PaymentMethodList = [SELECT Id, Name,Payment_Method_Code__c,Description__c,Sales_Org__c,Sales_Org__r.Name,Combination_Key__c
                                 FROM Payment_Method__c WHERE Payment_Method_Code__c IN :lstpaymentmethodSpain AND Sales_Org__r.Name='Spain' Order BY Name ASC];
            }
            PaymentTermList = new List<Payment_Term__c>();
            if(lstpaymenttermSpain.size()>0){
             PaymentTermList = [SELECT Id, Name,Payment_Term_Code__c,Payment_Term__c,Sales_Org__c,Sales_Org__r.Name,CombinationKey__c,Payterms_Desc__c 
                               FROM Payment_Term__c WHERE Payment_Term_Code__c IN :lstpaymenttermSpain AND Sales_Org__r.Name='Spain' Order BY Sequence_Number__c ASC];
            }
            IncoTermList = new List<Inco_Term__c>(); //added by Vaishnavi w.r.t CR-RITM0378141
            IncoTermList = [SELECT Id, Name FROM Inco_Term__c WHERE Active__c = true AND Sales_Org__r.Name='Spain' Order BY Name ASC];//added by Vaishnavi w.r.t CR-RITM0378141

            shippingLocationList = new List<Shipping_Location__c>();
            shippingLocationList = [SELECT Id, Name, Distributor__c, City__c, Region__c, Pincode__c, State__c, 
                                    Country__c, Sold_To_Party_SAP_Code__c, SAP_Code__c, Country_Name__c, 
                                    Billing_Street_1__c, Billing_Street_2__c, Billing_Street_3__c, 
                                    Billing_Street_4__c, Billing_Street_5__c, Billing_Street_6__c,   
                                    Location_Name__c FROM Shipping_Location__c WHERE Distributor__c =:accountId];
                                     
            if(shippingLocationList.size()>0){                          
                shippingMap = new Map<String,Shipping_Location__c>();               // for shipping location map..
                for(Shipping_Location__c shipAdr : shippingLocationList){
                    if(!shippingMap.containsKey(shipAdr.id)){
                        if(shipAdr.Billing_Street_1__c == null || shipAdr.Billing_Street_1__c == ''){
                            shipAdr.Billing_Street_1__c = 'None';
                        }
                        else if(shipAdr.Billing_Street_2__c == null || shipAdr.Billing_Street_2__c == ''){
                            shipAdr.Billing_Street_2__c = 'None';
                        }
                        else if(shipAdr.Billing_Street_3__c == null || shipAdr.Billing_Street_3__c == ''){
                            shipAdr.Billing_Street_3__c = 'None';
                        }
                        else if(shipAdr.Billing_Street_4__c == null || shipAdr.Billing_Street_4__c == ''){
                            shipAdr.Billing_Street_4__c = 'None';
                        }
                        else if(shipAdr.Billing_Street_5__c == null || shipAdr.Billing_Street_5__c == ''){
                            shipAdr.Billing_Street_5__c = 'None';
                        }
                        else if(shipAdr.Billing_Street_6__c == null || shipAdr.Billing_Street_6__c == ''){
                            shipAdr.Billing_Street_6__c = 'None';
                        }
                        else if(shipAdr.Region__c == null || shipAdr.Region__c == ''){
                            shipAdr.Region__c = 'None';
                        }
                        if(shipAdr.Country_Name__c == null || shipAdr.Country_Name__c == ''){    // country name field is used for refence as City name..
                            shipAdr.Country_Name__c = 'None';
                        }
                        if(shipAdr.State__c == null || shipAdr.State__c == ''){
                            shipAdr.State__c = 'None';
                        }
                        if(shipAdr.Pincode__c == null || shipAdr.Pincode__c == ''){
                            shipAdr.Pincode__c = 'None';
                        }
                        if(shipAdr.Country__c == null || shipAdr.Country__c == ''){
                            shipAdr.Country__c = 'None';
                        }
                        if(shipAdr.City__c == null || shipAdr.City__c == ''){
                            shipAdr.City__c = 'None';
                        }
                        //RITM0217558
                        shippingMap.put(shipAdr.id,shipAdr);
                    }
                }

                /*Shipping_Location__c shipLoc = new Shipping_Location__c();   // for shipping location Same as billing address..
                Boolean flag = false;
                for(Shipping_Location__c shpLoc : shippingLocationList){

                    if(shpLoc.SAP_Code__c == accList[0].SAP_Code__c){
                        shipLoc = shpLoc;
                        shipLoc.Country_Name__c = shipLoc.City__c;
                        shipLoc.City__c = System.Label.same_as_billing_address;
                        flag = true;
                    }
                    else{
                        shipLoc.Country_Name__c = shipLoc.City__c;
                        shpLoc.City__c = shpLoc.Location_Name__c +'-'+ shpLoc.City__c;
                    }
                   
                }

                if(flag == true){
                    shippingLocationList.set(0,shipLoc);
                }*/
                
            }
             
            csWrap.sap_code = accList[0].SAP_Code__c; 
    
            List<Credit_Info__c> ciList = new List<Credit_Info__c>();
            ciList = [SELECT id, name,Distributor__c,distributor__r.name, Credit_Limit__c,
                      Balance_Limit__c,Used_Limit__c, Internal_Limit__c, Sum_Open_Item__c, 
                      DAYS_ARREARS__c FROM Credit_Info__c WHERE Distributor__c =:accountId LIMIT 1];
            
            if(ciList.size()>0){
                
                csWrap.account_name = ciList[0].distributor__r.name;
                csWrap.total_credit_limit = ciList[0].Credit_Limit__c;
                csWrap.internal_credit_limit = ciList[0].Internal_Limit__c;
                csWrap.credit_limit_used = ciList[0].Used_Limit__c;
                csWrap.credit_limit_balance = ciList[0].Balance_Limit__c;
                 
            } 

            List<Outstanding_Ageing__c> oagList = new List<Outstanding_Ageing__c>();                              
            oagList = [SELECT id, OutstandingTotalGreaterthan90__c, Net_Outstanding__c
                       FROM Outstanding_Ageing__c WHERE Customer_Code__c =:accountId LIMIT 1];
            
            if(oagList.size()>0){
                csWrap.total_outstanding = oagList[0].Net_Outstanding__c;
            }

            List<Payments__c> payList = new List<Payments__c>();
            payList = [SELECT id, Net_Overdue__c FROM Payments__c WHERE Customer_Name__c =:accountId LIMIT 1];

            if(payList.size()>0){
                csWrap.net_overdue = payList[0].Net_Overdue__c;
            }

            orderForList = new List<DistributorSalesAreaMapping__c>();

            //loginUserObj.Profile.Name.Contains('Business Intelligence Manager')
            if(loginUserObj.Profile.Name == 'Regional Manager/Sales Reps Spain'){
                System.debug('inside 1');
                orderForList = [SELECT Id, Name, Distributor__c, SalesOrg__c, SalesOrg__r.Name, Sales_Org_Code__c,  
                                AccountOwner__c FROM DistributorSalesAreaMapping__c where Distributor__c =: accountId AND
                                AccountOwner__c =: loginUserObj.Id order by LastModifiedDate desc LIMIT 1 ];   
            }
            else{
                System.debug('outside 1');
                orderForList = [SELECT Id, Name, Distributor__c, SalesOrg__c, SalesOrg__r.Name, Sales_Org_Code__c,  
                                AccountOwner__c FROM DistributorSalesAreaMapping__c where Distributor__c =: accountId
                                order by LastModifiedDate desc];

                if(orderForList.size()>0){
                    Map<String,DistributorSalesAreaMapping__c> myMap = new Map<String,DistributorSalesAreaMapping__c>();
                    for(DistributorSalesAreaMapping__c dsap : orderForList){
                        if(!myMap.containsKey(dsap.SalesOrg__r.Name)){
                            myMap.put(dsap.SalesOrg__r.Name,dsap);
                        }
                    }

                    if(myMap.size()>0){
                        orderForList = new List<DistributorSalesAreaMapping__c>();
                        orderForList = myMap.values();
                    }
                } 
            }

            if(loginUserObj.Profile.Name == 'Spain(Business Intelligence Manager)' || loginUserObj.Profile.Name == 'Spain(Customer Service User)' || loginUserObj.Profile.Name == 'Regional Manager/Sales Reps Spain'){
                orderWrap.orderRaisedBy = 'Territory Manager';
            }
            else{
                orderWrap.orderRaisedBy = 'Regional Manager';
            }

            /* if(loginUserObj.ManagerId != null){
                orderWrap.managerId = loginUserObj.ManagerId;
            }

            if(loginUserObj.Country_Head__c != null){
                orderWrap.countryHead = loginUserObj.Country_Head__c;
            } */
            
            orderWrap.CurrencyCode = SelectedCurrency;
            orderWrap.account_Id = accountId;           
            orderWrap.orderForList = orderForList;
           /*  orderWrap.inco_term = accList[0].Inco_Term__r.IncoTerm_Desc__c;
            orderWrap.inco_term_id = accList[0].Inco_Term__c;
            orderWrap.payment_method = accList[0].Payment_Method__r.Description__c;
            orderWrap.payment_method_id = accList[0].Payment_Method__c;
            orderWrap.payment_term = accList[0].Payment_Term_Code__r.Payterms_Desc__c;
            orderWrap.payment_term_id = accList[0].Payment_Term_Code__c; */
            orderWrap.shippingMap = shippingMap;
            orderWrap.creditSummary = csWrap;
            orderWrap.shippingLocationList = shippingLocationList;
            orderWrap.PaymentMethodList = PaymentMethodList;
            orderWrap.PaymentTermList = PaymentTermList;
            orderWrap.IncoTermList = IncoTermList;
            PriceBookDetailsWrapper priceBookW = new PriceBookDetailsWrapper();
            orderWrap.priceBookWrapper = priceBookW;
            orderWrap.orderItemList = orderItemList;
                        
        }
        catch(Exception ex){
            System.debug('Exception in getOrderDetails method ');
            System.debug('Exception in Line number getOrderDetails : ' + ex.getLineNumber());
            System.debug('Exception is : ' + ex);
        }

        return orderWrap;
    }

    @AuraEnabled   
    public static OrderForWrapper setOrderFor(String org_code){
        System.debug('org_code in class '+org_code);
            

        OrderForWrapper orderFor = new OrderForWrapper();

        Sales_Org__c salesOrgObj = new Sales_Org__c();
        List<Distribution_Channel__c> Distribution_ChnlList = new List<Distribution_Channel__c>();
        List<Division__c> Division_List = new List<Division__c>();
        Order_Type__c Order_Type = new Order_Type__c();
        Depot__c Depo_Obj = new Depot__c();
        Depot__c Shipping_Point = new Depot__c();
        Depot__c Storage_Location = new Depot__c();
        List<String> distributionChanlIds = new List<String>();
        List<String> divisionIds = new List<String>();
        try{        
            if(org_code == '2510'){
              //  salesOrgObj = new Sales_Org__c();
                salesOrgObj = [SELECT Id, Name, Description__c, Sales_Org_Code__c FROM Sales_Org__c 
                            where Sales_Org_Code__c = '2510' limit 1];
                   
              /************ start project Harmony**************/      
              //  Order_Type = new Order_Type__c();
                /*Order_Type = [SELECT Id, Name, Description__c, Order_Type_Code__c, SalesOrg__c, Division__c 
                            FROM Order_Type__c where Order_Type_Code__c = 'ZQOR' limit 1]; */
              
               Order_Type = [SELECT Id, Name, Description__c, Order_Type_Code__c, SalesOrg__c, Division__c 
                            FROM Order_Type__c where Order_Type_Code__c = 'ZZOD' limit 1]; 
              
              /************ End project Harmony**************/  
              //  Shipping_Point = new Depot__c();
              // RITM0299826- Change shipping point from ES50 to ES29
                Shipping_Point = [SELECT Id, Name, Depot_Code__c, SalesOrg__c, Plant_Desc__c, Active__c, Depot__c, 
                                RecordTypeId FROM Depot__c where Shipping_Point__c='ES29'];

              //  Storage_Location = new Depot__c();
              // RITM0299826- Change storage location from sw06 to sw16
                Storage_Location = [SELECT Id, Name, Depot_Code__c, SalesOrg__c, Plant_Desc__c, Active__c, Depot__c, 
                                    Shipping_Point__c, RecordType.Name FROM Depot__c where 
                                    Name = 'SW16' AND RecordType.Name='Storage Location'];
                    /************ start project Harmony**************/  
              /*  Distribution_ChnlList = [SELECT Id, Name, Description__c, Distribution_Channel_Code__c, Sales_Org__c 
                                        FROM Distribution_Channel__c where Distribution_Channel_Code__c IN ('67')];*/
                                        
                   Distribution_ChnlList = [SELECT Id, Name, Description__c, Distribution_Channel_Code__c, Sales_Org__c 
                                        FROM Distribution_Channel__c where Distribution_Channel_Code__c IN ('10')];                     
                                                                                
                   /************ End project Harmony**************/                       
                                        
                if(Distribution_ChnlList.size()>0){
                    for(Distribution_Channel__c dcl : Distribution_ChnlList){
                        distributionChanlIds.add(dcl.Id);
                    }
                }

                Division_List = [SELECT Id, Name, Description__c, Division_Code__c FROM Division__c 
                                where Division_Code__c IN ('10','60')];  
                if(Division_List.size()>0){
                    for(Division__c dvsn : Division_List){
                        divisionIds.add(dvsn.Id);
                    }
                }                

               // Depo_Obj = new Depot__c();
                Depo_Obj = [SELECT Id, Name, Depot_Code__c, SalesOrg__c, Plant_Desc__c, Active__c, Depot__c 
                            FROM Depot__c where Depot_Code__c = 'ES51'];                     
            }
            
            // changes made by vishal UPL-CR131
            // This is for All Portugal
            else if(org_code == '2481'){
               // salesOrgObj = new Sales_Org__c();
              // // changes made by vishal UPL-CR131  changes from 2520 to 2481
                salesOrgObj = [SELECT Id, Name, Description__c, Sales_Org_Code__c FROM Sales_Org__c 
                            where Sales_Org_Code__c = '2481' limit 1];

               // Order_Type = new Order_Type__c();
                // changes made by vishal UPL-CR131   changes from ZQEX to ZZOR
                Order_Type = [SELECT Id, Name, Description__c, Order_Type_Code__c, SalesOrg__c, Division__c 
                            FROM Order_Type__c where Order_Type_Code__c = 'ZZOD' limit 1]; // as per Ashutosh Project Harmony

               // Shipping_Point = new Depot__c();
              // // changes made by vishal UPL-CR131   changes from ES50 to PT00 
                Shipping_Point = [SELECT Id, Name, Depot_Code__c, SalesOrg__c, Plant_Desc__c, Active__c, Depot__c, 
                                RecordTypeId FROM Depot__c where Shipping_Point__c='PT00'];

               // Storage_Location = new Depot__c();
               //  // // changes made by vishal UPL-CR131  changes from SW06 to WL01
                Storage_Location = [SELECT Id, Name, Depot_Code__c, SalesOrg__c, Plant_Desc__c, Active__c, Depot__c, 
                                    Shipping_Point__c, RecordType.Name FROM Depot__c where 
                                    Name = 'WL01' AND RecordType.Name='Storage Location'];

                 // changes made by vishal UPL-CR131   DIstribution channel code changes from 70 to 20
                Distribution_ChnlList = [SELECT Id, Name, Description__c, Distribution_Channel_Code__c, Sales_Org__c 
                                        FROM Distribution_Channel__c where Distribution_Channel_Code__c IN ('20')];
                if(Distribution_ChnlList.size()>0){
                    for(Distribution_Channel__c dcl : Distribution_ChnlList){
                        distributionChanlIds.add(dcl.Id);
                    }
                }
                // changes made by vishal UPL-CR131 division code changes from 10,60 to only 10
                Division_List = [SELECT Id, Name, Description__c, Division_Code__c FROM Division__c 
                                where Division_Code__c IN ('10')];
                if(Division_List.size()>0){
                    for(Division__c dvsn : Division_List){
                        divisionIds.add(dvsn.Id);
                    }
                } 

              //  Depo_Obj = new Depot__c();
              //  changes made by vishal UPL-CR131  changes from ES51 to PT00
                Depo_Obj = [SELECT Id, Name, Depot_Code__c, SalesOrg__c, Plant_Desc__c, Active__c, Depot__c 
                            FROM Depot__c where Depot_Code__c = 'PT00'];
            }
            else if(org_code == '2541'){
               // salesOrgObj = new Sales_Org__c();
                salesOrgObj = [SELECT Id, Name, Description__c, Sales_Org_Code__c FROM Sales_Org__c 
                            where Sales_Org_Code__c = '2541' limit 1];
                /************ start project Harmoney**************/
              //  Order_Type = new Order_Type__c();
               /* Order_Type = [SELECT Id, Name, Description__c, Order_Type_Code__c, SalesOrg__c, Division__c 
                            FROM Order_Type__c where Order_Type_Code__c = 'ZQOR' limit 1]; */
               // ProjectHarmony             
               Order_Type = [SELECT Id, Name, Description__c, Order_Type_Code__c, SalesOrg__c, Division__c 
                            FROM Order_Type__c where Order_Type_Code__c = 'ZZOD' limit 1];              
               /************ End project Harmoney**************/
               // Shipping_Point = new Depot__c();
                Shipping_Point = [SELECT Id, Name, Depot_Code__c, SalesOrg__c, Plant_Desc__c, Active__c, Depot__c, 
                                RecordTypeId FROM Depot__c where Shipping_Point__c='ES52'];

              //  Storage_Location = new Depot__c();
                Storage_Location = [SELECT Id, Name, Depot_Code__c, SalesOrg__c, Plant_Desc__c, Active__c, Depot__c, 
                                    Shipping_Point__c, RecordType.Name FROM Depot__c where 
                                    Name = 'SWCH' AND RecordType.Name='Storage Location'];
                  /************ start project Harmoney**************/
               /* Distribution_ChnlList = [SELECT Id, Name, Description__c, Distribution_Channel_Code__c, Sales_Org__c 
                                        FROM Distribution_Channel__c where Distribution_Channel_Code__c = '20'];*/
                
                 Distribution_ChnlList = [SELECT Id, Name, Description__c, Distribution_Channel_Code__c, Sales_Org__c 
                                        FROM Distribution_Channel__c where Distribution_Channel_Code__c = '10'];                        
                                        
                   /************ End project Harmoney**************/                       
                if(Distribution_ChnlList.size()>0){
                    for(Distribution_Channel__c dcl : Distribution_ChnlList){
                        distributionChanlIds.add(dcl.Id);
                    }
                }

                Division_List = [SELECT Id, Name, Description__c, Division_Code__c FROM Division__c 
                                where Division_Code__c = '10'];
                if(Division_List.size()>0){
                    for(Division__c dvsn : Division_List){
                        divisionIds.add(dvsn.Id);
                    }
                }  

               // Depo_Obj = new Depot__c();
                Depo_Obj = [SELECT Id, Name, Depot_Code__c, SalesOrg__c, Plant_Desc__c, Active__c, Depot__c 
                            FROM Depot__c where Depot_Code__c = 'ES52'];
            }
            else{
                orderFor.error = true;
            }

            orderFor.salesOrgObj = salesOrgObj;
            orderFor.Order_Type = Order_Type;
            orderFor.Depo_Obj = Depo_Obj;
            orderFor.Shipping_Point = Shipping_Point;
            orderFor.Storage_Location = Storage_Location;
            orderFor.distributionChanlIds = distributionChanlIds;
            orderFor.divisionIds = divisionIds;
            
        }
        catch(Exception ex){
            System.debug('Exception in setOrderFor method : ' + ex);
            System.debug('Exception is : ' + ex);
        }

        return orderFor;
    }    

    @AuraEnabled   
    public static PriceBookWrapper getCampaignAndDiscount(String skuId,String salesOrgObj,String Depo_Obj,String distributionChanlIds,String divisionIds, String combKey){
        PriceBookWrapper pbWrapper = new PriceBookWrapper();
        List<PricebookDiscount__c> discountList = new List<PricebookDiscount__c>();
                
        try{
            discountList = [SELECT Id, Name, SKUCode__c, SKUCode__r.Name, Spain_Portugal_Campaign__c, 
                            Spain_Portugal_Campaign__r.Name, Spain_Portugal_Campaign__r.Campaign_Id__c, Distributor_Discount__c, DepotCode__c, 
                            Division__c, Sales_Org__c, DistributionChannel__c, StartDate__c, EndDate__c 
                            FROM PricebookDiscount__c WHERE SKUCode__c =: skuId AND Sales_Org__c =: salesOrgObj 
                            AND DepotCode__c =: Depo_Obj AND Division__c =: divisionIds AND 
                            DistributionChannel__c =: distributionChanlIds AND 
                            StartDate__c <= TODAY AND EndDate__c >= TODAY ];
 
            List<SpecialInvoiceDiscount__c> splInvDiscnt = new List<SpecialInvoiceDiscount__c>();    // ...for Volume Discount..
            splInvDiscnt = [SELECT Id, Name, Discount__c, SKUCode__c, SKUCode__r.Name FROM  SpecialInvoiceDiscount__c WHERE
                            SKUCode__c =: skuId AND Sales_Org__c =: salesOrgObj
                            AND DepotCode__c =: Depo_Obj AND Division__c =: divisionIds AND 
                            DistributionChannel__c =: distributionChanlIds AND 
                            StartDate__c <= TODAY AND EndDate__c >= TODAY LIMIT 1]; 
                            
            List<ZSP1_Discount__c> zspDiscnt = new List<ZSP1_Discount__c>();                       // ...for Line Discount..
            zspDiscnt = [SELECT Id, Name, Discount__c FROM ZSP1_Discount__c WHERE 
                        SKUCode__c =: skuId AND Sales_Org__c =: salesOrgObj 
                        AND DepotCode__c =: Depo_Obj AND Division__c =: divisionIds AND 
                        DistributionChannel__c =: distributionChanlIds AND 
                        StartDate__c <= TODAY AND EndDate__c >= TODAY LIMIT 1];

            List<Inventory__c> stockReq = new  List<Inventory__c>();
            stockReq = getInventory(skuId,Depo_Obj,combKey);
            Map<String,decimal> inventoryBalancedQuantityMap = new Map<String,decimal>();//Sayan
            Decimal values=0;//Sayan
            //Sayan
            system.debug('Sayan stockReq size-->'+stockReq.size());
            for(Inventory__c stReq : stockReq){
                if(inventoryBalancedQuantityMap.containsKey(stReq.SKU__c)){
                    values += stReq.Balanced_Quanity__c ;
                    inventoryBalancedQuantityMap.put(stReq.SKU__c,values);
                }else{
                    inventoryBalancedQuantityMap.put(stReq.SKU__c,stReq.Balanced_Quanity__c);
                    values += stReq.Balanced_Quanity__c ;
                }
                
            }
            //Sayan

            pbWrapper.pbDiscount = discountList;    

            if(splInvDiscnt.size()> 0){
                pbWrapper.sku_id = splInvDiscnt[0].SKUCode__c;
                pbWrapper.sku_name = splInvDiscnt[0].SKUCode__r.Name;
                pbWrapper.volume_discount = splInvDiscnt[0].Discount__c;
            }  

            if(zspDiscnt.size()> 0){
                pbWrapper.line_discount = zspDiscnt[0].Discount__c;
            }

            if(stockReq.size()>0){
                //pbWrapper.inventory = stockReq[0].Balanced_Quanity__c;
                system.debug('Sayan inventoryBalancedQuantityMap-->'+inventoryBalancedQuantityMap);
                for(Inventory__c stReq : stockReq){
                    pbWrapper.inventory = inventoryBalancedQuantityMap.get(stReq.SKU__c);
                }
            }
        }
        catch(Exception ex){
            System.debug('Exception in getCampaignAndDiscount method : ' + ex);
            System.debug('Exception is : ' + ex);
        }
        return pbWrapper;
    }

    @AuraEnabled   
    public static Boolean createDraftOrder(String orderObj){
        OrderWrapper ordWrap = (OrderWrapper)JSON.deserialize(orderObj, OrderWrapper.class);
        List<OrderItemWrapper> orderItemList = ordWrap.orderItemList;
        //List<OrderItemWrapper> ordLineItemList = ordWrap.orderItemList;
        Boolean result = true;
        try{
            Order__c ordObj = new Order__c();
            ordObj.Id = ordWrap.ordr_id;
            ordObj.Order_Status__c = 'Draft';
            ordObj.Sales_Org__c = ordWrap.salesOrgObj;
            ordObj.Depot__c = ordWrap.Depo_Obj; 
            ordObj.Order_Type__c = ordWrap.Order_Type;
            ordObj.PONumber__c = ordWrap.po_no;
            ordObj.Remarks__c = ordWrap.remark;
            ordObj.OwnerId = ordWrap.ownerId;
            if(ordWrap.shipping_loc.trim().length()>0){
                ordObj.Shipping_Location__c = ordWrap.shipping_loc;
            }
            
            ordObj.Gross_Amount_With_Early_Discount__c = ordWrap.gross_amount;
            ordObj.Early_Order_Discount__c = ordWrap.early_ordr_discount;
            
            /* --------- Start SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022 ----------------------*/
            if(ordWrap.showPODate == true && String.isNotBlank(ordWrap.poDate)){
                ordObj.PO_Date__c = Date.valueof(ordWrap.poDate);
            }
            else if(ordWrap.showPODate == true && String.isBlank(ordWrap.poDate)){
                ordObj.PO_Date__c = null;
            }
            /* --------- End SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022 ----------------------*/

        // ordObj.Distribution_Channel__c = ordWrap.distributorChannelId; 
        // ordObj.Division__c = ordWrap.divisionId; 
            
            update ordObj;
           // orIds.add(ordObj.Id);
            Integer itemNumber = 0;

            if(orderItemList.size()>0){
                itemNumber = ordWrap.lastItemNumber;
            }
            System.debug('New lastItemNumber :- ' + itemNumber);

            if(orderItemList.size()>0){

                List<OrderLineItem__c> orderLineItems = new List<OrderLineItem__c>();
                for(OrderItemWrapper itemWrap : orderItemList){
                    OrderLineItem__c ordItem = new OrderLineItem__c();
                    
                    if(itemWrap.orderItem_id.trim().length() > 0){
                        ordItem.Id = itemWrap.orderItem_id;
                    }
                    else{
                        ordItem.Order__c = ordObj.Id; 
                    }
                    
                    ordItem.Campaign_Discount__c = itemWrap.campaign_discount;
                    ordItem.CurrencyIsoCode = ordWrap.CurrencyCode;
                    ordItem.FinalPrice__c = itemWrap.final_price;
                    ordItem.multipleOf__c = itemWrap.multiple_of;
                    ordItem.Net_Price__c = itemWrap.net_price;
                    ordItem.Price__c = itemWrap.base_price;
                    /* ordItem.Net_Price__c = itemWrap.base_price;
                    ordItem.Price__c = itemWrap.net_price; */
                    ordItem.Quantity__c = itemWrap.quantity;
                    ordItem.Shipping_Date__c = Date.valueof(itemWrap.shipmnt_date);
                    ordItem.SKU_Name__c = itemWrap.sku_id;
                    ordItem.UOM__c = itemWrap.uom;
                    ordItem.Price_Book_Master__c = itemWrap.pb_id;
                    ordItem.Apply_Campaign_Discount__c = itemWrap.apply_cmpgn_disc;
                    ordItem.Distribution_Channel__c = itemWrap.distributionChanlIds;
                    ordItem.Division__c = itemWrap.divisionIds;
                    ordItem.Actual_Discount__c = itemWrap.actual_discount;
                    ordItem.Edited_Discount__c = itemWrap.edited_discount;
                    ordItem.Line_Discount__c = itemWrap.line_discount;
                    ordItem.Volume_Discount__c = itemWrap.volume_discount;
                    ordItem.Actual_Campaign_Discount__c = itemWrap.actual_campaign_discount;
                    ordItem.Actual_Line_Discount__c = itemWrap.actual_line_discount;
                    ordItem.Actual_Net_Price__c = itemWrap.actual_base_price;//Sayan
                    ordItem.Actual_Volume_Discount__c = itemWrap.actual_volume_discount;
                    //ordItem.Price_Book_Master__r.Country_Tax__c = itemWrap.tax; //Priya
					ordItem.Base_Price_without_Tax__c = itemWrap.base_Price_without_tax;   //Change by Aashima(Grazitti) RITM0509178 21 march 2023
                    if(itemWrap.campaign_id.trim().length()>0){
                        ordItem.Campaign_Code__c = itemWrap.campaign_code;
                        ordItem.Pricebook_Discount_Id__c = itemWrap.pb_discount_id;
                        ordItem.Campaign__c = itemWrap.campaign_id;
                    }
                    
                    if(itemWrap.itemNumber == 0){
                        itemNumber = itemNumber+10;
                        ordItem.Item_Number__c = String.valueOf(itemNumber);
                    }

                    /* --------- Start SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022 ----------------------*/
                    if(ordWrap.showDeliveryDate == true && String.isNotBlank(itemWrap.deliveryDate)){
                        ordItem.Delivery_Date__c = Date.valueof(itemWrap.deliveryDate);
                    }
                    else if(ordWrap.showDeliveryDate == true && String.isBlank(itemWrap.deliveryDate)){
                        ordItem.Delivery_Date__c = null;
                    }
                    /* --------- End SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022 ----------------------*/
                    
                    orderLineItems.add(ordItem);
                }

                if(orderLineItems.size()>0){
                    upsert orderLineItems;
                    result = true;
                }
            }

            /* List<OrderLineItem__c> orderItems = new List<OrderLineItem__c>();
                orderItems = [SELECT Id, Name, Campaign_Discount__c, FinalPrice__c, multipleOf__c, Net_Price__c,
                                Order__c, Price__c, Quantity__c, Shipping_Date__c, SKU_Name__c, SKU_Name__r.Name,
                                UOM__c, Price_Book_Master__c, Pricebook_Discount_Id__c, Apply_Campaign_Discount__c,
                                Campaign__c, Campaign__r.Name, Distribution_Channel__c, Division__c, Actual_Discount__c, 
                                Edited_Discount__c, Line_Discount__c, Volume_Discount__c, Actual_Campaign_Discount__c,
                                Actual_Line_Discount__c, Actual_Volume_Discount__c, Item_Number__c, SKU_Name__r.Mininum_Quantity__c,
                                Campaign_code__c FROM OrderLineItem__c WHERE Order__c =: ordWrap.ordr_id];

                if(orderItems.size()>0){
                    
                    for(OrderLineItem__c ordItem : orderItems){
                        OrderItemWrapper itemWrap = new OrderItemWrapper();
                        itemWrap.orderItem_id = ordItem.Id;
                        itemWrap.order_id = ordItem.Order__c;
                        itemWrap.pb_id = ordItem.Price_Book_Master__c;
                        itemWrap.sku_name = ordItem.SKU_Name__r.Name;
                        itemWrap.sku_id = ordItem.SKU_Name__c;
                        itemWrap.uom = ordItem.UOM__c;
                        itemWrap.campaign_nm = ordItem.Campaign__r.Name;
                        itemWrap.campaign_id = ordItem.Campaign__c;
                        itemWrap.apply_cmpgn_disc = ordItem.Apply_Campaign_Discount__c;
                        itemWrap.campaign_discount = ordItem.Campaign_Discount__c;
                        itemWrap.line_discount = ordItem.Line_Discount__c;
                        itemWrap.volume_discount = ordItem.Volume_Discount__c;
                        itemWrap.quantity = ordItem.Quantity__c;
                        itemWrap.final_price = ordItem.FinalPrice__c;
                        //itemWrap.base_price = ordItem.Price__c;
                        //itemWrap.net_price = ordItem.Net_Price__c;
                        itemWrap.base_price = ordItem.Net_Price__c;
                        itemWrap.net_price = ordItem.Price__c;
                        itemWrap.shipmnt_date = string.valueOf(ordItem.Shipping_Date__c);
                        //itemWrap.inventory = ordItem.;
                        itemWrap.actual_discount = ordItem.Actual_Discount__c;
                        itemWrap.edited_discount = ordItem.Edited_Discount__c;
                        itemWrap.multiple_of = ordItem.multipleOf__c;
                        itemWrap.actual_campaign_discount = ordItem.Actual_Campaign_Discount__c;
                        itemWrap.actual_line_discount = ordItem.Actual_Line_Discount__c;
                        itemWrap.actual_volume_discount = ordItem.Actual_Volume_Discount__c;
                        itemWrap.pb_discount_id = ordItem.Pricebook_Discount_Id__c;
                        itemWrap.distributionChanlIds = ordItem.Distribution_Channel__c;
                        itemWrap.divisionIds = ordItem.Division__c;
                        itemWrap.itemNumber = Integer.ValueOf(ordItem.Item_Number__c);
                        itemWrap.campaign_code = ordItem.Campaign_Code__c;

                        if(ordItem.SKU_Name__r.Mininum_Quantity__c == null){
                            itemWrap.min_quantity = 0;
                        }
                        else{
                            itemWrap.min_quantity = ordItem.SKU_Name__r.Mininum_Quantity__c;
                        }                       

                        ordLineItemList.add(itemWrap);
                    }
                } */
        }
        catch(Exception ex){
            result = false;
            System.debug('Exception in createDraftOrder method : ' + ex);
            System.debug('Exception is : ' + ex);
            System.debug('Exception is : ' + ex.getLineNumber());
        }
        return result;
    }

    @AuraEnabled   
    public static List<Sales_Order__c> createNewSO(String orderObj,String TemplateName){
        //system.debug('**Apex TemplateName SKU - '+TemplateName);
        //Added to get the Account payment method and term
        List<Account> accList;
        List<Sales_Order__c> orderIds = new List<Sales_Order__c>();
        List<Sales_Order__c> orderToUpdate = new List<Sales_Order__c>();
        List<String> orIds = new List<String>();
        OrderWrapper ordWrap = (OrderWrapper)JSON.deserialize(orderObj, OrderWrapper.class);
        List<OrderItemWrapper> orderItemList = ordWrap.orderItemList;
        Map<String, Sales_Order__c> divisionSOMap = new Map<String, Sales_Order__c>();
        Map<String, Integer> itemNoMap = new Map<String, Integer>();
        Map<String,List<OrderItemWrapper>> DivisionMap = new Map<String,List<OrderItemWrapper>>();
        List<OrderTemplateItem__c> oliList = new List<OrderTemplateItem__c>();
         try{
         if(templateName != null && templateName != ''){
            OrderTemplate__c otObj = new OrderTemplate__c();
            otObj.name = templateName;
            otObj.DistributorCustomerCode__c = ordWrap.account_Id;
            otObj.CurrencyIsoCode = '';
            otObj.Payment_Method__c = ordWrap.payment_method_id;
            otObj.Payment_Term__c = ordWrap.payment_term_id;
            otObj.Inco_Term__c = ordWrap.inco_term_id;
            INSERT otObj;
            
            //system.debug('**OrderTemplate - '+otObj);
             
            for(OrderItemWrapper items : orderItemList){
            OrderTemplateItem__c otiObj = new OrderTemplateItem__c();
            otiObj.Name = items.sku_name;
            otiObj.OrderTemplate__c = otObj.Id;
            otiObj.SKU__c = items.sku_id;
            otiObj.Price_Book_Master__c = items.pb_id;
            otiObj.UOM__c = items.uom;
            otiObj.Price__c = items.net_price;
            otiObj.Quantity__c = items.quantity;
            otiObj.Line_Discount__c = items.line_discount;
            otiObj.Volume_Discount__c = items.volume_discount;
            otiObj.Base_Price__c = items.base_price;
            otiObj.Shipping_Date__c = Date.valueof(items.shipmnt_date);
            otiObj.Apply_Campaign_Discount__c = items.apply_cmpgn_disc;
            otiObj.Campaign_Discount__c = items.campaign_discount;
            otiObj.Actual_Line_Discount__c = items.actual_line_discount;
            otiObj.Actual_Volume_Discount__c = items.actual_volume_discount;
            otiObj.Actual_Discount__c = items.actual_discount;
            otiObj.Edited_Discount__c = items.edited_discount;
            otiObj.FinalPrice__c= items.final_price;
            otiObj.Actual_Base_Price__c = items.actual_base_price;
            otiObj.multipleOf__c = items.multiple_of;
            otiObj.Division__c = items.divisionIds;
            otiObj.Distribution_Channel__c = items.distributionChanlIds;
            otiObj.Actual_Campaign_Discount__c  = items.actual_campaign_discount;
            otiObj.Base_Price_without_Tax__c = items.base_Price_without_tax;    //Change by Aashima(Grazitti) RITM0509178 21 march 2023
                
            if(items.campaign_id.trim().length()>0){
                otiObj.Campaign__c=items.campaign_id;
                otiObj.Pricebook_Discount_Id__c = items.pb_discount_id;
                otiObj.Campaign_Code__c = items.campaign_code;
            }

            /* --------- Start SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022 ----------------------*/
            if(ordWrap.showDeliveryDate == true && String.isNotBlank(items.deliveryDate)){
                otiObj.Delivery_Date__c = Date.valueof(items.deliveryDate);
            }
            else if(ordWrap.showDeliveryDate == true && String.isBlank(items.deliveryDate)){
                otiObj.Delivery_Date__c = null;
            }
            /* --------- End SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022 ----------------------*/
            oliList.add(otiObj);
            otiObj.Inventory__c=items.inventory;
            }
            insert oliList;
            //system.debug('**OrderTemplate Items - '+oliList);
             
            }
        
        User user = new User();
       

            String div_Id = '';
            String sOrder_Id = '';
            Integer itemNo = 0;
            
            /* if(orderItemList.size()>0){
                itemNo = ordWrap.lastItemNumber;
            } */
            
            accList = getAccountDetails(ordWrap.account_Id);
            if(orderItemList.size()>0){

                user = [SELECT Id, Name, Country, IsActive, Show_Inventory__c, Show_Credit_Limit__c, 
                        Show_Inventory_Column__c, Show_InTransit__c, Show_InTransit_Values__c, 
                        ProfileId,Profile.Name, ManagerId, Country_Head__c
                        FROM User WHERE Id =: ordWrap.ownerId AND IsActive = True];

                for(OrderItemWrapper itemWrap : orderItemList){
                    if(!DivisionMap.containsKey(itemWrap.divisionIds)) {
                        DivisionMap.put(itemWrap.divisionIds, new List<OrderItemWrapper>{itemWrap});
                    }
                    else{
                        DivisionMap.get(itemWrap.divisionIds).add(itemWrap);
                    }
                }

                List<Sales_Order_Line_Item__c> soItemList = new List<Sales_Order_Line_Item__c>();
                List<String> soItemListDelete = new List<String>();
                
                for(String div : DivisionMap.keySet()){

                   // Integer itemNo = 0;
                    Sales_Order_Line_Item__c sliObj;

                    for(OrderItemWrapper item : DivisionMap.get(div)){

                        Sales_Order__c ordObj = new Sales_Order__c();
                        
                        if(divisionSOMap.containsKey(item.divisionIds)){
                            ordObj = divisionSOMap.get(item.divisionIds);
                            ordObj.Total_Amount__c = ordObj.Total_Amount__c + item.net_price;
                            system.debug('Sayan item.actual_base_price-->'+item.actual_base_price);
                            system.debug('Sayan item.base_price-->'+item.base_price);
                            system.debug('Sayan Price difference-->'+(item.actual_base_price-item.base_price));
                            if((((item.actual_base_price - item.base_price) != 0 ) || (item.actual_line_discount < item.line_discount)) || (ordWrap.payment_method_id!=accList[0].Payment_Method__c) || (ordWrap.payment_term_id!=accList[0].Payment_Term_Code__c) && ordObj.Sent_for_Manager_Approval_Mexico__c == false){
                                system.debug('Sayan inside approval check');
                                ordObj.Order_Status__c = 'Pending';
                                ordObj.Sent_for_Manager_Approval_Mexico__c = true;
                                sliObj.is_Approval_Required__c = true;
                                if(ordWrap.payment_term_id!=accList[0].Payment_Term_Code__c)
                                {
                                    ordObj.Is_payment_Term_Changed__c = true;
                                }
                            }else{
                                system.debug('Sayan outside approval check');
                            }
                            update ordObj;
                        }
                        else{
                            if(ordWrap.so_id.trim().length() > 0){
                                ordObj.Id = ordWrap.so_id;
                                sOrder_Id = ordWrap.so_id;
                                div_Id = item.divisionIds;
                            }
                            /* else{
                                ordObj.Order_Date__c = System.today();
                            } */
                            ordObj.Order_Date__c = System.today();
                            ordObj.Sold_to_Party__c = ordWrap.account_Id;
                            ordObj.Bill_To_Party__c = ordWrap.account_Id;
                            ordObj.CreatedFrom__c = 'SFDC';
                            ordObj.OwnerId = ordWrap.ownerId;                                     //userinfo.getuserid();
                            ordObj.Order__c = ordWrap.ordr_id;
                            ordObj.Ship_To_Party__c = ordWrap.shipping_loc;
                            ordObj.CurrencyIsoCode = ordWrap.CurrencyCode;
                            ordObj.Distribution_Channel_lk__c = item.distributionChanlIds;
                            ordObj.Division_lk__c = item.divisionIds;
                            ordObj.Sales_Org_lk__c = ordWrap.salesOrgObj;
                            ordObj.Remarks__c = ordWrap.remark;
                            ordObj.PONumber__c = ordWrap.po_no;
                            ordObj.Order_Type_lk__c = ordWrap.Order_Type;
                            ordObj.Order_Raise_By__c = ordWrap.orderRaisedBy;
                            if(user.ManagerId != null){
                                ordObj.Manager__c = user.ManagerId;
                            }

                            if(user.Country_Head__c != null){
                                ordObj.Sales_Director_Mexico__c = user.Country_Head__c; 
                            }
                            
                            //system.debug('Sayan item-->'+item);
                            //system.debug('Sayan item.actual_base_price-->'+item.actual_base_price);
                            //system.debug('Sayan item.base_price-->'+item.base_price);
                            //system.debug('Sayan Price difference-->'+(item.actual_base_price-item.base_price));
                            if( ((item.actual_base_price - item.base_price) != 0 ) || (item.actual_line_discount < item.line_discount) || (ordWrap.payment_method_id!=accList[0].Payment_Method__c) || (ordWrap.payment_term_id!=accList[0].Payment_Term_Code__c)){
                                system.debug('Sayan inside approval check');
                                ordObj.Order_Status__c = 'Pending';
                                ordObj.Sent_for_Manager_Approval_Mexico__c = true;
                                if(ordWrap.payment_term_id!=accList[0].Payment_Term_Code__c)
                                {
                                    ordObj.Is_payment_Term_Changed__c = true;
                                }
                            }
                            else{
                                system.debug('Sayan outside approval check');
                                ordObj.Order_Status__c = 'Open';
                                ordObj.Sent_for_Manager_Approval_Mexico__c = false;
                            }
                            
                            ordObj.Depot__c = ordWrap.Depo_Obj; 
                            ordObj.Early_Order_Discount__c = ordWrap.early_ordr_discount;
                            ordObj.Total_Amount__c = item.net_price;
                           // ordObj.Gross_Amount_With_Early_Discount__c = ordWrap.gross_amount;
                            ordObj.Inco_Term__c  = ordWrap.inco_term_id;
                            ordObj.PaymentMethod__c = ordWrap.payment_method_id;
                            ordObj.Payment_Term__c = ordWrap.payment_term_id;

                            /* --------- Start SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022 ----------------------*/
                            if(ordWrap.showPODate == true && String.isNotBlank(ordWrap.poDate)){
                                ordObj.Purchase_Order_Date__c = Date.valueof(ordWrap.poDate);
                            }
                            else if(ordWrap.showPODate == true && String.isBlank(ordWrap.poDate)){
                                ordObj.Purchase_Order_Date__c = null;
                            }
                            //ordObj.Call_Process_Builder_Flow__c = false;
                            /* --------- End SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022 ----------------------*/

                            upsert ordObj;

                            if(ordWrap.so_id.trim().length() == 0){
                                orIds.add(ordObj.Id);
                            }

                            divisionSOMap.put(item.divisionIds,ordObj);
                        }

                        if(itemNoMap.containsKey(ordObj.Id)){
                            itemNo = itemNoMap.get(ordObj.Id);
                        }
                        else{
                            itemNo = 0;
                        }

                        sliObj = new Sales_Order_Line_Item__c();  
                       
                       /* if(item.orderItem_id.trim().length()>0 && ordWrap.isSalesOrder == true){
                            sliObj.Id = item.orderItem_id;
                        } */

                        if((item.actual_line_discount < item.line_discount) || ((item.actual_base_price - item.base_price) != 0) || (ordWrap.payment_method_id!=accList[0].Payment_Method__c) || (ordWrap.payment_term_id!=accList[0].Payment_Term_Code__c)){
                            sliObj.is_Approval_Required__c = true;
                        }
                        else{
                            sliObj.is_Approval_Required__c = false;
                        }

                        if(ordWrap.isSalesOrder == false){
                            sliObj.Sale_Order__c = ordObj.Id;
                        }
                        else{
                            if(ordWrap.isSalesOrder == true && item.order_id == sOrder_Id && item.divisionIds == div_Id){
                                sliObj.Id = item.orderItem_id;
                            }
                            else{
                                sliObj.Sale_Order__c = ordObj.Id;
                                soItemListDelete.add(item.orderItem_id);
                            }
                        }

                        if(ordWrap.isSalesOrder == false){
                            itemNo = itemNo +10;
                            sliObj.Item_Number__c = itemNo;
                            itemNoMap.put(ordObj.Id,itemNo);
                        }
                        else{
                            sliObj.Item_Number__c = item.itemNumber;
                        }
                        
                        sliObj.SKU_Name__c = item.sku_id;
                        sliObj.Item_Status__c = 'Active';
                        sliObj.DepotDepot__c = ordWrap.Depo_Obj;
                        sliObj.Storage_Location__c = ordWrap.Storage_Location;
                        sliObj.UOM__c = item.uom;
                        sliObj.CurrencyIsoCode = ordWrap.CurrencyCode;
                        sliObj.multipleOf__c = item.multiple_of;
                        sliObj.Finalprice__c = item.final_price;
                        //sliObj.Net_Price__c = item.net_price;
                        //sliObj.Price__c = item.base_price;
                        sliObj.Net_Price__c = item.base_price;
                        sliObj.Price__c = item.net_price;
                        sliObj.Quantity__c = item.quantity;
                        sliObj.Shipping_Date__c = Date.valueof(item.shipmnt_date);
                        sliObj.PriceBookMaster__c = item.pb_id;
                        sliObj.Apply_Campaign_Discount__c = item.apply_cmpgn_disc;
                        sliObj.Actual_Campaign_Discount__c = item.actual_campaign_discount;
                        sliObj.Actual_Line_Discount__c = item.actual_line_discount;
                        sliObj.Actual_Net_Price__c = item.actual_base_price;//Sayan
                        sliObj.Actual_Volume_Discount__c = item.actual_volume_discount;
                        sliObj.Actual_Discount__c = item.actual_discount;
                        sliObj.Edited_Discount__c = item.edited_discount;
                        sliObj.Campaign_Discount__c = item.campaign_discount;
                        sliObj.Line_Discount__c = item.line_discount;
                        sliObj.Volume_Discount__c = item.volume_discount;
                        sliObj.Distribution_Channel__c = item.distributionChanlIds;
                        sliObj.Division__c = item.divisionIds;
                        //Change by Aashima(Grazitti) RITM0509178 2 march 2023
                        sliObj.Base_Price_Without_Tax__c=item.base_price_without_tax;
                     
                     
                        // Added below Condition for RITM0527643 GRZ(Dheeraj Sharma) 20-04-2023
        
                        if(sliObj.Edited_Discount__c==100){
                            sliObj.Item_Category__c='ZZNN';
                            sliObj.Base_Price_Without_Tax__c=0;
                        }else{
                            sliObj.Item_Category__c='ZZOD';
                        }
                      
                       // Added below method for RITM0527643 GRZ(Dheeraj Sharma) 20-04-2023


                        
                        if(item.campaign_id.trim().length()>0){
                            sliObj.Campaign_Code__c = item.campaign_code;
                            sliObj.Pricebook_Discount_Id__c = item.pb_discount_id;
                            sliObj.Campaign__c = item.campaign_id;
                        }

                        /* --------- Start SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022 ----------------------*/
                        if(ordWrap.showDeliveryDate == true && String.isNotBlank(item.deliveryDate)){
                            sliObj.Delivery_Date__c = Date.valueof(item.deliveryDate);
                        }
                        else if(ordWrap.showDeliveryDate == true && String.isBlank(item.deliveryDate)){
                            sliObj.Delivery_Date__c = null;
                        }
                        /* --------- End SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022 ----------------------*/
                       
                        soItemList.add(sliObj);
                        ordWrap.so_id = '';
                    }
                }

                if(soItemList.size()>0){
                    upsert soItemList;  //orderToUpdate

                    /* for(Sales_Order_Line_Item__c so_Item : soItemList){
                        Sales_Order__c order_Obj = new Sales_Order__c();
                        order_Obj.Id = so_Item.Sale_Order__c;
                        if(so_Item.Actual_Line_Discount__c < so_Item.Line_Discount__c){
                            order_Obj.Order_Status__c = 'Pending';
                            order_Obj.Sent_for_Manager_Approval_Mexico__c = true;
                        }
                        else{
                            order_Obj.Order_Status__c = 'Open';
                            order_Obj.Sent_for_Manager_Approval_Mexico__c = false;
                        }

                        orderToUpdate.add(order_Obj);
                    }

                    if(orderToUpdate.size()>0){
                        update orderToUpdate;
                    } */
                }

                if(ordWrap.isSalesOrder == true){
                    List<Attachment> newAttchlist = new List<Attachment>();
                    List<Attachment> attchlist = new List<Attachment>();
                    attchlist = [SELECT Id, ParentId, Name, ContentType, Body FROM Attachment 
                                where ParentId =: sOrder_Id];
                    if(attchlist.size()>0){
                        if(orIds.size()>0){
                            for(Attachment atch : attchlist){
                                    for(String so : orIds){
                                        Attachment atchmnt = new Attachment();
                                        atchmnt.ParentId = so;
                                        atchmnt.Name = atch.Name;
                                        atchmnt.ContentType = atch.ContentType;
                                        atchmnt.Body = atch.Body;

                                        newAttchlist.add(atchmnt);
                                    }  
                            }
                        }
                    }
                    
                    if(newAttchlist.size()>0){
                        insert newAttchlist;
                    }
                    orIds.add(sOrder_Id);
                }

                Order__c ord = new Order__c();
                ord.Id = ordWrap.ordr_id;
                ord.Order_Status__c = 'Approved';
                update ord;

                if(ordWrap.isSalesOrder == true){
                    List<Sales_Order_Line_Item__c> lineItemlist = new List<Sales_Order_Line_Item__c>();
                    lineItemlist = [SELECT Id, Name FROM Sales_Order_Line_Item__c WHERE
                                    Id IN : soItemListDelete];

                    if(lineItemlist.size()>0){
                        delete lineItemlist;
                    } 
                }               
                orderIds = [SELECT Id, Name, Early_Order_Discount__c, Total_Amount__c, Gross_Amount_With_Early_Discount__c FROM Sales_Order__c WHERE Id IN : orIds];
                
                if(orderIds.size() > 0){
                    for(Sales_Order__c sOrder : orderIds){
                        Decimal val = (sOrder.Total_Amount__c - ((sOrder.Total_Amount__c * sOrder.Early_Order_Discount__c) / 100)).setScale(2) ;
                        sOrder.Gross_Amount_With_Early_Discount__c = val;
                        sOrder.Call_Process_Builder_Flow__c = true;
                    }

                    update orderIds;
                }           
            }
            
        }
        catch(Exception ex){
            System.debug('Exception in createNewSO method : ' + ex);
            System.debug('Exception is : ' + ex);
            System.debug('Exception is : ' + ex.getLineNumber());
        }
        return orderIds;
    }


    @AuraEnabled   
    public static List<Sales_Order__c> updateSalesOrder(String orderObj){
        List<Sales_Order__c> orderIds = new List<Sales_Order__c>();
        List<String> orIds = new List<String>();
        OrderWrapper ordWrap = (OrderWrapper)JSON.deserialize(orderObj, OrderWrapper.class);
        List<OrderItemWrapper> orderItemList = ordWrap.orderItemList;
       System.debug('updateSalesOrder :- '+ ordWrap);
        try{

            Sales_Order__c ordObj = new Sales_Order__c();
            if(ordWrap.so_id.trim().length() > 0){
                ordObj.Id = ordWrap.so_id;
            }
            ordObj.Order__c = ordWrap.ordr_id;
            ordObj.Sold_to_Party__c = ordWrap.account_Id;
            ordObj.Bill_To_Party__c = ordWrap.account_Id;
            ordObj.CreatedFrom__c = 'SFDC';
            ordObj.OwnerId = ordWrap.ownerId;                                     //userinfo.getuserid();
            ordObj.Ship_To_Party__c = ordWrap.shipping_loc;
            ordObj.CurrencyIsoCode = ordWrap.CurrencyCode;
            ordObj.Draft_Order_Date__c = System.today();
            ordObj.Sales_Org_lk__c = ordWrap.salesOrgObj; 
            ordObj.Order_Type_lk__c = ordWrap.Order_Type;
            
            /* 
            ordObj.Distribution_Channel_lk__c = item.distributionChanlIds;
            ordObj.Division_lk__c = item.divisionIds;
            */
            ordObj.Remarks__c = ordWrap.remark;
            ordObj.PONumber__c = ordWrap.po_no;
            ordObj.Order_Status__c = ordWrap.status;
            ordObj.Depot__c = ordWrap.Depo_Obj; 
            ordObj.Early_Order_Discount__c = ordWrap.early_ordr_discount;
            ordObj.Total_Amount__c = ordWrap.total_amount;
            ordObj.Order_Status__c = 'Draft';
            ordObj.Gross_Amount_With_Early_Discount__c = ordWrap.gross_amount;
            ordObj.Inco_Term__c  = ordWrap.inco_term_id;
            ordObj.PaymentMethod__c = ordWrap.payment_method_id;
            ordObj.Payment_Term__c = ordWrap.payment_term_id;

            /* --------- Start SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022 ----------------------*/
            if(ordWrap.showPODate == true && String.isNotBlank(ordWrap.poDate)){
                ordObj.Purchase_Order_Date__c = Date.valueof(ordWrap.poDate);
            }
            else if(ordWrap.showPODate == true && String.isBlank(ordWrap.poDate)){
                ordObj.Purchase_Order_Date__c = null;
            }
            /* --------- End SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022 ----------------------*/

            upsert ordObj;
            orIds.add(ordObj.Id);
            orderIds = [SELECT Id, Name FROM Sales_Order__c WHERE Id IN : orIds];
            
            Integer itemNo = 0;

            if(orderItemList.size()>0){
                itemNo = ordWrap.lastItemNumber;
            }

            if(orderItemList.size()>0){

                List<Sales_Order_Line_Item__c> soItemList = new List<Sales_Order_Line_Item__c>();

                    Sales_Order_Line_Item__c sliObj;
                    
                    for(OrderItemWrapper item : orderItemList){

                        sliObj = new Sales_Order_Line_Item__c();
                        if(item.orderItem_id.trim().length()>0 && ordWrap.isSalesOrder == true){
                            sliObj.Id = item.orderItem_id;
                        }
                        else{
                            sliObj.Sale_Order__c = ordObj.id;
                        }
                        
                        sliObj.SKU_Name__c = item.sku_id;
                            
                        if(ordWrap.isSalesOrder == false){
                            sliObj.Item_Number__c = item.itemNumber;
                        }
                        else if(ordWrap.isSalesOrder == true && item.itemNumber == 0){
                            itemNo = itemNo + 10;
                            sliObj.Item_Number__c = itemNo;
                        }
                        
                        sliObj.Item_Status__c = 'Active';
                        sliObj.DepotDepot__c = ordWrap.Depo_Obj;
                        sliObj.Storage_Location__c = ordWrap.Storage_Location;
                        sliObj.UOM__c = item.uom;
                        sliObj.CurrencyIsoCode = ordWrap.CurrencyCode;
                        sliObj.multipleOf__c = item.multiple_of;
                        sliObj.Finalprice__c = item.final_price;
                       // sliObj.Net_Price__c = item.net_price;
                       // sliObj.Price__c = item.base_price;
                        sliObj.Net_Price__c = item.base_price;
                        sliObj.Price__c = item.net_price;
                        sliObj.Quantity__c = item.quantity;
                        
                        
                        sliObj.Shipping_Date__c = Date.valueof(item.shipmnt_date);
                        sliObj.PriceBookMaster__c = item.pb_id;
                        sliObj.Apply_Campaign_Discount__c = item.apply_cmpgn_disc;
                        sliObj.Actual_Campaign_Discount__c = item.actual_campaign_discount;
                        sliObj.Actual_Line_Discount__c = item.actual_line_discount;
                        sliObj.Actual_Net_Price__c = item.actual_base_price;//Sayan
                        sliObj.Actual_Volume_Discount__c = item.actual_volume_discount;
                        sliObj.Actual_Discount__c = item.actual_discount;
                        sliObj.Edited_Discount__c = item.edited_discount;
                        sliObj.Campaign_Discount__c = item.campaign_discount;
                        sliObj.Line_Discount__c = item.line_discount;
                        sliObj.Volume_Discount__c = item.volume_discount;
                        sliObj.Distribution_Channel__c = item.distributionChanlIds;
                        sliObj.Division__c = item.divisionIds;
                        //Change by Aashima(Grazitti) RITM0509178 2 march 2023
                        sliObj.Base_Price_Without_Tax__c = item.base_Price_without_tax;
                        if(item.campaign_id.trim().length()>0){
                            sliObj.Campaign_Code__c = item.campaign_code;
                            sliObj.Pricebook_Discount_Id__c = item.pb_discount_id;
                            sliObj.Campaign__c = item.campaign_id;
                        }

                        /* --------- Start SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022 ----------------------*/
                        if(ordWrap.showDeliveryDate == true && String.isNotBlank(item.deliveryDate)){
                            sliObj.Delivery_Date__c = Date.valueof(item.deliveryDate);
                        }
                        else if(ordWrap.showDeliveryDate == true && String.isBlank(item.deliveryDate)){
                            sliObj.Delivery_Date__c = null;
                        }
                        /* ---------End SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022 ----------------------*/

                        soItemList.add(sliObj);

                        /* if(ordWrap.status != 'Draft'){
                            if(item.actual_line_discount < item.line_discount && ordObj.Sent_for_Manager_Approval_Mexico__c == false){
                                ordObj.Order_Status__c = 'Pending';
                                ordObj.Sent_for_Manager_Approval_Mexico__c = true;
                            }
                            else{
                                ordObj.Order_Status__c = 'Open';
                                ordObj.Sent_for_Manager_Approval_Mexico__c = false;
                            }
                        }
                        else{
                            ordObj.Order_Status__c = 'Draft';
                        } */
                    }

                if(soItemList.size()>0){
                    upsert soItemList;
                }

            }

            List<Order__c> ord = [SELECT Id, Name, Order_Status__c from Order__c WHERE 
                                  Id =: ordWrap.ordr_id LIMIT 1];
            if(ord.size()>0){
                ord[0].Order_Status__c = 'Approved';
                update ord;
            }                      
            
        }
        catch(Exception ex){
            System.debug('Exception in updateSalesOrder method : ' + ex);
            System.debug('Exception is : ' + ex);
            System.debug('Exception is : ' + ex.getLineNumber());
        }
        return orderIds;
    }

    @AuraEnabled   
    public static Boolean deleteLineItem(String itemId, String type, Decimal netPrc){
        Boolean result = false;
        try{
        //System.debug('**deleteLineItem id - '+ itemId);
        if(type == 'Sales Order'){
            List<Sales_Order_Line_Item__c> soItemList = [SELECT Id, Name,Sale_Order__c,Sale_Order__r.Total_Amount__c,
                                                         Sale_Order__r.Gross_Amount_With_Early_Discount__c, Sale_Order__r.Early_Order_Discount__c
                                                         FROM Sales_Order_Line_Item__c  WHERE Id=:itemId LIMIT 1];
                        if(soItemList.size()>0){
                            Sales_Order__c sOrdr = new Sales_Order__c();
                            sOrdr.Id = soItemList[0].Sale_Order__c;
                            sOrdr.Total_Amount__c = soItemList[0].Sale_Order__r.Total_Amount__c - netPrc;
                            Decimal grsPrc = (sOrdr.Total_Amount__c - ((soItemList[0].Sale_Order__r.Early_Order_Discount__c * sOrdr.Total_Amount__c) / 100)).setScale(2) ;
                            if(soItemList[0].Sale_Order__r.Gross_Amount_With_Early_Discount__c!=null && grsPrc!=null){
                                sOrdr.Gross_Amount_With_Early_Discount__c = soItemList[0].Sale_Order__r.Gross_Amount_With_Early_Discount__c - grsPrc;
                            update sOrdr;
                            }

                            delete soItemList;
                            result = true;
                        }                                
        }
        else if(type == 'Order'){
            List<OrderLineItem__c> soItemList = [SELECT Id, Name, Order__c, Order__r.Gross_Amount_With_Early_Discount__c, 
                                                Order__r.Gross_Net__c,  Order__r.Early_Order_Discount__c
                                                FROM OrderLineItem__c WHERE Id=:itemId LIMIT 1];
            //system.debug('**Delete orderItemList - ' +soItemList);
                if(soItemList.size()>0){
                   //system.debug('**Delete Gross Amount - ' +soItemList[0].Order__r.Gross_Amount_With_Early_Discount__c);
                    Order__c ordr = new Order__c();
                    ordr.Id = soItemList[0].Order__c;
                    Decimal grsPrc = (soItemList[0].Order__r.Gross_Net__c - ((soItemList[0].Order__r.Early_Order_Discount__c * soItemList[0].Order__r.Gross_Net__c) / 100)).setScale(2) ;
                    if(soItemList[0].Order__r.Gross_Amount_With_Early_Discount__c!=null && grsPrc!=null){
                    ordr.Gross_Amount_With_Early_Discount__c = soItemList[0].Order__r.Gross_Amount_With_Early_Discount__c - grsPrc;
                    update ordr;
                    }
                    delete soItemList;
                    result = true;
                }  
        }
        }
        catch(Exception ex){
            System.debug('Exception is : ' + ex);
            System.debug('Exception is : ' + ex.getLineNumber());
        }
        return result;
    }

    @AuraEnabled   
    public static Boolean deleteAllLineItem(String ordrId, String type){
        Boolean result = false;
        //System.debug('deleteAllLineItem id -: '+ ordrId);
        if(type == 'Sales Order'){
            List<Sales_Order_Line_Item__c> soItemList = [SELECT Id, Name, Sale_Order__c FROM Sales_Order_Line_Item__c 
                                                        WHERE Sale_Order__c=:ordrId ];
                        if(soItemList.size()>0){
                            delete soItemList; //
                            Sales_Order__c sOrdr = new Sales_Order__c();
                            sOrdr.Id = ordrId;
                            sOrdr.Total_Amount__c = 0;
                            sOrdr.Gross_Amount_With_Early_Discount__c = 0;
                            update sOrdr;
                            result = true;
                        }                                
        }
        else if(type == 'Order'){
            List<OrderLineItem__c> soItemList = [SELECT Id, Name, Order__c FROM OrderLineItem__c 
                                                WHERE Order__c=:ordrId ];
                if(soItemList.size()>0){
                    delete soItemList; 
                    Order__c ordr = new Order__c();
                    ordr.Id = ordrId;
                    ordr.Gross_Amount_With_Early_Discount__c = 0;
                    update ordr;
                    result = true;
                }  
        }
        return result;
    }

    @AuraEnabled
    public static List<String> saveChunk(String parentId, String fileName, String base64Data, String contentType, String fileId) {
        // check if fileId id ''(Always blank in first chunk), then call the saveTheFile method,
        //  which is save the check data and return the attachemnt Id after insert, 
        //  next time (in else) we are call the appentTOFile() method
        //   for update the attachment with reamins chunks   
        System.debug('saveChunk parentId -- '+ parentId);
        System.debug('saveChunk fileId -- '+ fileId);
        List<String> prntId = (List<String>)JSON.deserialize(parentId, List<String>.class);
        List<String> atchId = (List<String>)JSON.deserialize(fileId, List<String>.class);
        System.debug('saveChunk prntId -- '+ prntId);
        System.debug('saveChunk atchId -- '+ atchId.size());
        List<String> newArry = new List<String>();
        if(prntId.size()>0){
            for(Integer i=0; i<prntId.size();i++){
                if (atchId.size() == 0) {
                    String atId = saveTheFile(prntId[i], fileName, base64Data, contentType);
                    newArry.add(atId);
                } else {
                    appendToFile(atchId[i], base64Data);
                }
            }
        }
 
        return newArry;
    }
    
    public static Id saveTheFile(Id parentId, String fileName, String base64Data, String contentType) {
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
 
        Attachment oAttachment = new Attachment();
        oAttachment.parentId = parentId;
 
        oAttachment.Body = EncodingUtil.base64Decode(base64Data);
        oAttachment.Name = fileName;
        oAttachment.ContentType = contentType;
 
        insert oAttachment;
 
        return oAttachment.Id;
    }
 
    private static void appendToFile(Id fileId, String base64Data) {
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
 
        Attachment a = [
            SELECT Id, Body
            FROM Attachment
            WHERE Id =: fileId
        ];
 
        String existingBody = EncodingUtil.base64Encode(a.Body);
 
        a.Body = EncodingUtil.base64Decode(existingBody + base64Data);
 
        update a;
    }

    public static List<Account> getAccountDetails(String acc_id){
        List<Account> acList = new List<Account>();
        acList = [SELECT Id, Name, BillingCity, BillingCountry, RegionalManager__c,
                 BillingStreet, BillingState, BillingPostalCode , CurrencyIsoCode, 
                 Sales_Org__r.Name, OwnerId, SAP_Code__c, Sales_Org__c, Distribution_Channel__c,
                 Division__c,Inco_Term__c, Inco_Term__r.IncoTerm_Desc__c,Inco_Term__r.Name,
                 Order_Type__c, Order_Block__c,Sales_Org_Code__c, Status__c, Payment_Terms__c, 
                 Payment_Term_Code__c, Payment_Term_Code__r.Payterms_Desc__c, PriceGroupCode__c,
                 Sales_District__r.Sales_Director__c,Sales_District__r.Latam_Director__c, Sales_District__c,
                 Payment_Method__c, Payment_Method__r.Name, Payment_Method__r.Description__c 
                 FROM Account WHERE Id=:acc_id];
        return acList;                             
    }

    public static List<Inventory__c> getInventory(String skuId, String depo_id, String combKey){
        List<Inventory__c> stockReq = new  List<Inventory__c>();
        /*if(skuId == ''){
            stockReq = [SELECT Id, Name, SKU__c, Depot__c, Available_Stock__c, UOM__c, Depot_Code__c 
                        FROM Stock_Requirement__c WHERE  Depot__c =: depo_id AND 
                        Depot__r.Combination_key_Storage_Location__c =:combKey]; 
        }
        else{
            stockReq = [SELECT Id, Name, SKU__c, Depot__c, Available_Stock__c, UOM__c, Depot_Code__c 
                        FROM Stock_Requirement__c WHERE SKU__c =: skuId AND Depot__c =: depo_id AND 
                        Depot__r.Combination_key_Storage_Location__c =:combKey LIMIT 1];  
        }*/   
        if(skuId == ''){
            stockReq = [SELECT Id, Name, SKU__c, Depot__c, Balanced_Quanity__c, UOM__c 
                        FROM Inventory__c WHERE  Depot__c =: depo_id AND 
                        Storage_Location_Depot__r.Combination_key_Storage_Location__c =:combKey]; 
        }
        else{
            stockReq = [SELECT Id, Name, SKU__c, Depot__c, Balanced_Quanity__c, UOM__c 
                        FROM Inventory__c WHERE SKU__c =: skuId AND Depot__c =: depo_id /*AND 
                        Storage_Location_Depot__r.Combination_key_Storage_Location__c =:combKey*/];
        } 

        return stockReq;
    }
    
@AuraEnabled
 public static List<OrderTemplate__c> showOrderTemplates(String accSAPCode){
        
    return [SELECT Id, Name, DistributorCustomerCode__c,DistributorCustomerCode__r.name,DistributorCustomerCode__r.SAP_Code__c FROM OrderTemplate__c
                WHERE DistributorCustomerCode__r.SAP_Code__c=:accSAPCode ];                     
    }  
    
@AuraEnabled
 public static OrderWrapper loadTemplate(String orderObj,String tempIdChosen){
     OrderWrapper ordWrap = (OrderWrapper)JSON.deserialize(orderObj, OrderWrapper.class); 
     list<OrderItemWrapper> orderItemList = new List<OrderItemWrapper>();
     list<OrderLineItem__c> insertOrderItems = new list<OrderLineItem__c>();
     List<OrderTemplateItem__c> oliList = new List<OrderTemplateItem__c>();
     OrderTemplate__c tempList = new OrderTemplate__c();
     Integer itemNumber = 0;
     //String SKUName= '';
     //itemNumber = itemNumber+10;
     //list<Order__c> insertOrder = new list<Order__c>();
     try{
     Delete [SELECT Id FROM OrderLineItem__c WHERE Order__c =: ordWrap.ordr_id];
     
     if(tempIdChosen!=null){
     tempList = [SELECT Id, Name, Payment_Method__c, Payment_Term__c, Inco_Term__c,
                                           DistributorCustomerCode__c FROM OrderTemplate__c
                                           WHERE Id =: tempIdChosen LIMIT 1];
     }
     //system.debug('**Order tempList retrived - '+tempList);   
      if(tempList!=null ){
          /* --------- Start SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022 ----------------------*/
       oliList = [SELECT Id, Name, FinalPrice__c, OrderTemplate__c,SKU__c,Price_Book_Master__c,UOM__c,Base_Price__c,Quantity__c, Delivery_Date__c, 
                                              SKU__r.Product_Name__r.Name, SKU__r.Name,SKU__r.SKU_Description__c,SKU__r.UOM__c, SKU__r.Brand_Name__c,Campaign_Discount__c,multipleOf__c,
                                              Apply_Campaign_Discount__c,Price__c,Campaign__c,Shipping_Date__c,Line_Discount__c,Volume_Discount__c,Campaign__r.name,
                                              Actual_Volume_Discount__c,Actual_Base_Price__c,Actual_Line_Discount__c,Actual_Campaign_Discount__c,Inventory__c,
                                              Edited_Discount__c,Actual_Discount__c,Distribution_Channel__c,Division__c,Pricebook_Discount_Id__c,Campaign_Code__c
                                              FROM OrderTemplateItem__c WHERE OrderTemplate__c =: tempIdChosen];
                                              
     //system.debug('**Order Item tempList retrived - '+oliList);
      }
      
     if(oliList.size()>0 ){
      for(OrderTemplateItem__c ordi: oliList){
          OrderLineItem__c orderItems = new OrderLineItem__c();
          orderItems.Order__c = ordWrap.ordr_id;
          orderItems.SKU_Name__c= ordi.SKU__c;
          orderItems.SKU__c=ordi.SKU__r.SKU_Description__c;
          orderItems.Price_Book_Master__c = ordi.Price_Book_Master__c;
          orderItems.UOM__c= ordi.UOM__c;
          orderItems.Price__c = ordi.Base_Price__c;
          orderItems.Quantity__c = ordi.Quantity__c;
          orderItems.Apply_Campaign_Discount__c = ordi.Apply_Campaign_Discount__c;
          orderItems.Campaign_Discount__c = ordi.Campaign_Discount__c;
          orderItems.Line_Discount__c = ordi.Line_Discount__c ;
          orderItems.Volume_Discount__c = ordi.Volume_Discount__c;
          orderItems.FinalPrice__c = ordi.FinalPrice__c;
          orderItems.Net_Price__c = ordi.Price__c;
          orderItems.Shipping_Date__c =  System.today();
          orderItems.multipleOf__c = ordi.multipleOf__c;
          itemNumber = itemNumber+10;
          orderItems.Item_Number__c = string.valueOf(itemNumber);
          orderItems.Distribution_Channel__c = ordi.Distribution_Channel__c;
          orderItems.Division__c = ordi.Division__c;
          orderItems.Actual_Discount__c = ordi.Actual_Discount__c;
          orderItems.Edited_Discount__c = ordi.Edited_Discount__c;
          //orderItems.Actual_Campaign_Discount__c = ordi.Actual_Campaign_Discount__c;
          orderItems.Actual_Line_Discount__c = ordi.Actual_Line_Discount__c;
          orderItems.Actual_Net_Price__c = ordi.Actual_Base_Price__c;
          orderItems.Actual_Volume_Discount__c  = ordi.Actual_Volume_Discount__c;
          orderItems.Inventory__c = ordi.Inventory__c;
          
              
            if(ordi.Campaign__c != null){
                orderItems.Campaign__c = ordi.Campaign__c;
                orderItems.Campaign_Code__c = ordi.Campaign_Code__c;
                orderItems.Pricebook_Discount_Id__c = ordi.Pricebook_Discount_Id__c;
            }

            /* --------- Start SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022 ----------------------*/
            if(ordi.Delivery_Date__c == null){
                orderItems.Delivery_Date__c = null;
            }
            else{
                orderItems.Delivery_Date__c = ordi.Delivery_Date__c;
            }
            /* --------- End SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022 ----------------------*/
          
          insertOrderItems.add(orderItems);
           }
     }
     if(insertOrderItems.size()>0){
         upsert insertOrderItems;
         }
              
               if(insertOrderItems.size()>0){
                for(OrderLineItem__c ordItem : insertOrderItems){
                            OrderItemWrapper itemWrap = new OrderItemWrapper();
                            itemWrap.orderItem_id = ordItem.Id;
                            itemWrap.order_id = ordWrap.ordr_id;
                            itemWrap.sku_id = ordItem.SKU_Name__c;
                            itemWrap.sku_name = ordItem.SKU__c;
                            //itemWrap.sku_name = ordItem.SKU_Name__r.SKU_Description__c;
                            itemWrap.pb_id = ordItem.Price_Book_Master__c;
                            itemWrap.uom = ordItem.UOM__c;

                            if(ordItem.Campaign__c != null){
                                itemWrap.campaign_nm = ordItem.Campaign__r.Name;
                                itemWrap.campaign_id = ordItem.Campaign__c;
                                itemWrap.pb_discount_id = ordItem.Pricebook_Discount_Id__c;
                            }
                            
                            itemWrap.apply_cmpgn_disc = ordItem.Apply_Campaign_Discount__c;
                            itemWrap.campaign_discount = ordItem.Campaign_Discount__c;
                            itemWrap.line_discount = ordItem.Line_Discount__c;
                            itemWrap.volume_discount = ordItem.Volume_Discount__c;
                            itemWrap.quantity = ordItem.Quantity__c;
                            itemWrap.final_price = ordItem.FinalPrice__c;
                            itemWrap.net_price = ordItem.Net_Price__c;
                            itemWrap.base_price = ordItem.Price__c;
                            itemWrap.shipmnt_date = String.valueOf(System.today());                            
                            itemWrap.itemNumber = Integer.ValueOf(ordItem.Item_Number__c);
                            itemWrap.actual_discount = ordItem.Actual_Discount__c;
                            itemWrap.edited_discount = ordItem.Edited_Discount__c;
                            itemWrap.multiple_of = ordItem.multipleOf__c;
                            //itemWrap.actual_campaign_discount = ordItem.Actual_Campaign_Discount__c;
                            itemWrap.actual_line_discount = ordItem.Actual_Line_Discount__c;
                            itemWrap.actual_base_price = ordItem.Actual_Net_Price__c;
                            itemWrap.actual_volume_discount = ordItem.Actual_Volume_Discount__c;
                            itemWrap.distributionChanlIds = ordItem.Distribution_Channel__c;
                            itemWrap.divisionIds = ordItem.Division__c;
                            itemWrap.inventory = ordItem.Inventory__c;
                    
                             if(ordItem.SKU_Name__r.Mininum_Quantity__c == null){
                                itemWrap.min_quantity = 0;
                            }
                            else{
                                itemWrap.min_quantity = ordItem.SKU_Name__r.Mininum_Quantity__c;
                            }
                            
                            if(ordItem.UOM__c.toUpperCase() == 'KG'){
                                ordWrap.quantity_kg = ordWrap.quantity_kg + ordItem.Quantity__c;
                                ordWrap.net_price_kg = (ordWrap.net_price_kg + ordItem.Net_Price__c).setScale(2);
                                //ordWrap.total_amount = net_price_kg;
                            }
                            else if(ordItem.UOM__c.toUpperCase() == 'L'){
                                ordWrap.quantity_litre = ordWrap.quantity_litre + ordItem.Quantity__c;
                                ordWrap.net_price_litre = (ordWrap.net_price_litre + ordItem.Net_Price__c).setScale(2);
                            }
                            else if(ordItem.UOM__c.toUpperCase() == 'BT'){
                                ordWrap.quantity_bottle = ordWrap.quantity_bottle + ordItem.Quantity__c;
                                ordWrap.net_price_bottle = (ordWrap.net_price_bottle + ordItem.Net_Price__c).setScale(2);
                            }

                            if(Integer.ValueOf(ordItem.Item_Number__c) > ordWrap.lastItemNumber){
                                ordWrap.lastItemNumber = Integer.ValueOf(ordItem.Item_Number__c);
                            }
                            /* --------- Start SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022 ----------------------*/
                            if(ordItem.Delivery_Date__c == null){
                                itemWrap.deliveryDate = '';
                            }
                            else{
                                itemWrap.deliveryDate = String.valueOf(ordItem.Delivery_Date__c);
                            }
                            /* ---------End SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022 ----------------------*/
                             orderItemList.add(itemWrap);
                } 
                   ordWrap.orderItemList= orderItemList;
                             }
     }
     
     catch(Exception ex){
            System.debug('Exception is : ' + ex);
            System.debug('Exception is : ' + ex.getLineNumber());
        }
        
     return ordWrap;
    }

    
    public class CreditSummaryWrapper{
        @AuraEnabled public String account_name;
        @AuraEnabled public String sap_code;
        @AuraEnabled public Decimal total_credit_limit;
        @AuraEnabled public Decimal internal_credit_limit;
        @AuraEnabled public Decimal credit_limit_used;
        @AuraEnabled public Decimal credit_limit_balance;
        @AuraEnabled public Decimal total_outstanding;
        @AuraEnabled public Decimal net_overdue;

        public CreditSummaryWrapper(){
            account_name = '';
            sap_code = '';
            total_credit_limit = 0.0;
            internal_credit_limit = 0.0;
            credit_limit_used = 0.0;
            credit_limit_balance = 0.0;
            total_outstanding = 0.0;
            net_overdue = 0.0;
        }
    }

    public class OrderForWrapper{
        @AuraEnabled public Sales_Org__c salesOrgObj;
        @AuraEnabled public Order_Type__c Order_Type;
        @AuraEnabled public Depot__c Depo_Obj;
        @AuraEnabled public Depot__c Shipping_Point;
        @AuraEnabled public Depot__c Storage_Location;
        @AuraEnabled public List<String> distributionChanlIds;
        @AuraEnabled public List<String> divisionIds;
        @AuraEnabled public Boolean error;
        @AuraEnabled public String accId;
        @AuraEnabled public String skuId;

        public OrderForWrapper(){
            salesOrgObj = new Sales_Org__c();
            Order_Type = new Order_Type__c();
            Depo_Obj = new Depot__c();
            Shipping_Point = new Depot__c();
            Storage_Location = new Depot__c();
            distributionChanlIds = new List<String>();
            divisionIds = new List<String>();
            error = false;
            accId = '';
            skuId = '';
        }
    }

    public class PriceBookWrapper{
        @AuraEnabled public String id_val;
        @AuraEnabled public String sku_name;
        @AuraEnabled public String sku_id;
        @AuraEnabled public Decimal line_discount;
        @AuraEnabled public Decimal volume_discount;
        @AuraEnabled public List<PricebookDiscount__c> pbDiscount;
        @AuraEnabled public Decimal inventory;

        public PriceBookWrapper(){
            id_val = '';
            sku_name = '';
            sku_id = '';
            line_discount = 0.0;
            volume_discount = 0.0;
            inventory = 0.0;
            pbDiscount = new List<PricebookDiscount__c>();
        }
    }

    public class PriceBookDetailsWrapper{
        @AuraEnabled public String pb_id;
        @AuraEnabled public String sku_name;
        @AuraEnabled public String sku_id;
        @AuraEnabled public String uom;
        @AuraEnabled public String campaign_nm;
        @AuraEnabled public String campaign_id;
        @AuraEnabled public Decimal base_price;
        @AuraEnabled public Boolean apply_cmpgn_disc;
        @AuraEnabled public Decimal campaign_discount;
        @AuraEnabled public Decimal line_discount;
        @AuraEnabled public Decimal volume_discount;
        @AuraEnabled public Decimal quantity;
        @AuraEnabled public Decimal final_price;
        @AuraEnabled public Decimal net_price;
        @AuraEnabled public String shipmnt_date;
        @AuraEnabled public Decimal inventory;
        @AuraEnabled public Decimal actual_discount;
        @AuraEnabled public Decimal edited_discount;
        @AuraEnabled public Decimal multiple_of;
        @AuraEnabled public Decimal actual_campaign_discount;
        @AuraEnabled public Decimal actual_line_discount;
        @AuraEnabled public Decimal actual_base_price;//Sayan
        @AuraEnabled public Decimal actual_volume_discount;
        @AuraEnabled public String pb_discount_id;
        @AuraEnabled public String distributionChanlIds;
        @AuraEnabled public String divisionIds;
        @AuraEnabled public Decimal min_quantity;
        @AuraEnabled public String campaign_code;
        @AuraEnabled public String deliveryDate; /* --------- Start SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022 ----------------------*/
        //@AuraEnabled public Decimal tax;
        

        public PriceBookDetailsWrapper(){
            pb_id = '';
            sku_name = '';
            sku_id = '';
            uom = '';
            campaign_nm = '';
            campaign_id = '';
            base_price = 0.0;
            apply_cmpgn_disc = false;
            campaign_discount = 0.0;
            line_discount = 0.0;
            volume_discount = 0.0;
            quantity = 0.0;
            final_price = 0.0;
            net_price = 0.0;
            shipmnt_date = String.valueOf(System.today());
            inventory = 0.0;
            actual_discount = 0.0;
            edited_discount = 0.0;
            multiple_of = 0.0;
            actual_campaign_discount = 0.0;
            actual_line_discount = 0.0;
            actual_base_price = 0.0;//Sayan
            actual_volume_discount = 0.0;
            pb_discount_id = '';
            distributionChanlIds = '';
            divisionIds = '';
            min_quantity = 0;
            campaign_code = '';
            //tax = 0.0;
            deliveryDate = String.valueOf(System.today()+1);  /* --------- Start SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022 ----------------------*/
        }
    }

    public class OrderItemWrapper{
        @AuraEnabled public String orderItem_id;
        @AuraEnabled public String order_id;
        @AuraEnabled public String pb_id;
        @AuraEnabled public String sku_name;
        @AuraEnabled public String sku_id;
        @AuraEnabled public String uom;
        @AuraEnabled public String campaign_nm;
        @AuraEnabled public String campaign_id;
        @AuraEnabled public Decimal base_price;
        @AuraEnabled public Boolean apply_cmpgn_disc;
        @AuraEnabled public Decimal campaign_discount;
        @AuraEnabled public Decimal line_discount;
        @AuraEnabled public Decimal volume_discount;
        @AuraEnabled public Decimal quantity;
        @AuraEnabled public Decimal final_price;
        @AuraEnabled public Decimal net_price;
        @AuraEnabled public String shipmnt_date;
        @AuraEnabled public Decimal inventory;
        @AuraEnabled public Decimal actual_discount;
        @AuraEnabled public Decimal edited_discount;
        @AuraEnabled public Decimal multiple_of;
        @AuraEnabled public Decimal actual_campaign_discount;
        @AuraEnabled public Decimal actual_line_discount;
        @AuraEnabled public Decimal actual_base_price;//Sayan
        @AuraEnabled public Decimal actual_volume_discount;
        @AuraEnabled public String pb_discount_id;
        @AuraEnabled public String distributionChanlIds;
        @AuraEnabled public String divisionIds;
        @AuraEnabled public Integer itemNumber;
        @AuraEnabled public Decimal min_quantity;
        @AuraEnabled public String campaign_code;
        @AuraEnabled public String deliveryDate; /* --------- Start SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022 ----------------------*/
        @AuraEnabled public Decimal tax; //uncommented by vaishnavi w.r.t CR-RITM0378156
        @AuraEnabled public Decimal base_Price_without_tax; //Change by Aashima(Grazitti) RITM0509178 2 march 2023

        public OrderItemWrapper(){
            orderItem_id = '';
            order_id = '';
            pb_id = '';
            sku_name = '';
            sku_id = '';
            uom = '';
            campaign_nm = '';
            campaign_id = '';
            base_price = 0.0;
            apply_cmpgn_disc = false;
            campaign_discount = 0.0;
            line_discount = 0.0;
            volume_discount = 0.0;
            quantity = 0.0;
            final_price = 0.0;
            net_price = 0.0;
            shipmnt_date = String.valueOf(System.today());
            inventory = 0.0;
            actual_discount = 0.0;
            edited_discount = 0.0;
            multiple_of = 0.0;
            actual_campaign_discount = 0.0;
            actual_line_discount = 0.0;
            actual_base_price = 0.0;//Sayan
            actual_volume_discount = 0.0;
            pb_discount_id = '';
            distributionChanlIds = '';
            divisionIds = '';
            itemNumber = 0;
            min_quantity = 0;
            campaign_code = '';
            tax = 0.0; //priya //uncommented by vaishnavi w.r.t CR-RITM0378156
            deliveryDate = String.valueOf(System.today()+1); /* --------- Start SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022 ----------------------*/
            base_Price_without_tax=0.0; //Change by Aashima(Grazitti) RITM0509178 2 march 2023
        }
    }

    public class OrderWrapper{
        @AuraEnabled public Sales_Order__c soObj;
        @AuraEnabled public CreditSummaryWrapper creditSummary;
        @AuraEnabled public List<PriceBookDetailsWrapper> priceBookList;
        @AuraEnabled public List<OrderItemWrapper> orderItemList;
        @AuraEnabled public List<Shipping_Location__c> shippingLocationList;
        @AuraEnabled public List<Payment_Method__c> PaymentMethodList;
        @AuraEnabled public List<Payment_Term__c> PaymentTermList;
        @AuraEnabled public List<Inco_Term__c> IncoTermList; //added by Vaishnavi w.r.t CR-RITM0378141
        @AuraEnabled public Map<String,Shipping_Location__c> shippingMap;
        @AuraEnabled public List<DistributorSalesAreaMapping__c> orderForList;
        @AuraEnabled public PriceBookDetailsWrapper priceBookWrapper;
        @AuraEnabled public String orderFor;
        @AuraEnabled public String account_Id;
        @AuraEnabled public String ordr_id;
        @AuraEnabled public String so_id;
        @AuraEnabled public Boolean isSalesOrder;
        @AuraEnabled public Decimal early_ordr_discount;
        @AuraEnabled public Decimal total_amount;
        @AuraEnabled public Decimal gross_amount;
        @AuraEnabled public String uom_kg;
        @AuraEnabled public String uom_bottle;
        @AuraEnabled public String uom_litre;
        @AuraEnabled public Decimal net_price_kg;
        @AuraEnabled public Decimal net_price_bottle;
        @AuraEnabled public Decimal net_price_litre;
        @AuraEnabled public Decimal quantity_kg;
        @AuraEnabled public Decimal quantity_bottle;
        @AuraEnabled public Decimal quantity_litre;
        @AuraEnabled public String inco_term;
        @AuraEnabled public String inco_term_id;
        @AuraEnabled public String payment_method;
        @AuraEnabled public String payment_method_id;
        @AuraEnabled public String payment_term;
        @AuraEnabled public String payment_term_id;
        @AuraEnabled public String shipping_loc;
        @AuraEnabled public String shipping_loc_details;
        @AuraEnabled public String po_no;
        @AuraEnabled public String remark;
        @AuraEnabled public String status;
        @AuraEnabled public String salesOrgObj;
        @AuraEnabled public String Order_Type;
        @AuraEnabled public String Depo_Obj;
        @AuraEnabled public String Shipping_Point;
        @AuraEnabled public String Storage_Location;
        @AuraEnabled public String CurrencyCode;
        @AuraEnabled public String ownerId;
        @AuraEnabled public List<String> distributionChanlIds;
        @AuraEnabled public List<String> divisionIds;
        @AuraEnabled public Integer lastItemNumber;
        @AuraEnabled public List<Decimal> countryWise_EOD;
        @AuraEnabled public Boolean disable_EOD;
        @AuraEnabled public String orderRaisedBy;
        @AuraEnabled public String managerId;
        @AuraEnabled public String countryHead;
        /* --------- Start SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022 ----------------------*/
        @AuraEnabled public Boolean showPODate;
        @AuraEnabled public Boolean showDeliveryDate;
        @AuraEnabled public Boolean isPORequired;
        @AuraEnabled public Boolean isDeliveryRequired;
        @AuraEnabled public String poDate;
        /* --------- End SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022 ----------------------*/
            
        public OrderWrapper(){
            soObj = new Sales_Order__c();
            creditSummary = new CreditSummaryWrapper();
            priceBookList = new List<PriceBookDetailsWrapper>();
            orderItemList = new List<OrderItemWrapper>();
            //Added to fetch PaymentMethod and payment Terms
            PaymentMethodList = new List<Payment_Method__c>();
            PaymentTermList = new List<Payment_Term__c>();
            IncoTermList = new List<Inco_Term__c>(); //added by Vaishnavi w.r.t CR-RITM0378141
            shippingLocationList = new List<Shipping_Location__c>();
            shippingMap = new Map<String,Shipping_Location__c>();
            orderForList = new List<DistributorSalesAreaMapping__c>();
            priceBookWrapper = new PriceBookDetailsWrapper();
            orderFor = '';
            account_Id = '';
            ordr_id = '';
            so_id = '';
            isSalesOrder = false;
            early_ordr_discount = 0;
            total_amount = 0.0;
            gross_amount = 0.0;
            uom_kg = '';
            uom_bottle = '';
            uom_litre = '';
            net_price_kg = 0.0;
            net_price_bottle = 0.0;
            net_price_litre = 0.0;
            quantity_kg = 0.0;
            quantity_bottle = 0.0;
            quantity_litre = 0.0;
            inco_term = '';
            inco_term_id = '';
            payment_method = '';
            payment_method_id = '';
            payment_term = '';
            payment_term_id = '';
            shipping_loc = '';
            shipping_loc_details = '';
            po_no = '';
            remark = '';
            status = '';
            salesOrgObj = '';
            Order_Type = '';
            Depo_Obj = '';
            Shipping_Point = '';
            Storage_Location = '';
            CurrencyCode = '';
            ownerId = '';
            distributionChanlIds = new List<String>();
            divisionIds = new List<String>();
            lastItemNumber = 0;
            countryWise_EOD = new List<Decimal>();
            disable_EOD = false;
            orderRaisedBy = '';
            managerId = '';
            countryHead = '';
            /* --------- Start SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022 ----------------------*/
            showPODate = false;
            showDeliveryDate = false;
            isPORequired = false;
            isDeliveryRequired = false;
            poDate = String.valueOf(System.today()); // updated for RITM0475047 GRZ(Nikhil Verma) 16-12-2022
            /* --------- End SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022 ----------------------*/
        }
    }
}