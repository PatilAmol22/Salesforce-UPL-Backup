public without sharing class VietnamSOController {
    
    @AuraEnabled   
    public static OrderWrapper getOrderDetails(String id_val){
        OrderWrapper orderWrap = new OrderWrapper();
        CreditSummaryWrapper csWrap = new CreditSummaryWrapper();
        List<Sales_Order__c> SOObj;
        List<Order__c> orderObj;
        List<Account> accList;
        List<Shipping_Location__c> shippingLocationList;
        Map<String,Shipping_Location__c> shippingMap;
        List<DistributorSalesAreaMapping__c> orderForList;
        User loginUserObj;
        String SelectedCurrency = '';
        String accountId='';
        String Sales_Org_Code = '';
        List<OrderItemWrapper> orderItemList = new List<OrderItemWrapper>();
        //List<TM_Depot_Mapping__c> depoList = new List<TM_Depot_Mapping__c>();
        List<Attachment> atchmnt = new List<Attachment>();
        try{

            SelectedCurrency = 'VND';

            loginUserObj = [SELECT Id, Name, Country, IsActive, Show_Inventory__c, Show_Credit_Limit__c, 
                            Show_Inventory_Column__c, Show_InTransit__c, Show_InTransit_Values__c, 
                            ProfileId,Profile.Name, ManagerId, Country_Head__c, Zonal_Manager__c, RegionalManager__c
                            FROM User WHERE Id =: UserInfo.getUserId() AND IsActive = True];
            /* ------------- Start SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022 ---------------------------------- */
            List<Login_Country__c> logCntry = new List<Login_Country__c>();
            logCntry = [SELECT Id, Name, For_Contry__c, Sales_Org_Code__c, Delivery_Date__c, 
                        PO_Date__c, Show_Delivery_Date__c, Show_PO_Date__c FROM Login_Country__c 
                        where Name =:loginUserObj.Country limit 1];

            if(logCntry.size() > 0){
                /* if(logCntry[0].For_Contry__c == 'Bolivia'){
                    Sales_Org_Code = '5361';
                }
                else if(logCntry[0].For_Contry__c == 'Paraguay'){
                    Sales_Org_Code = '5441';
                } */
                //Sales_Org_Code = logCntry[0].Sales_Org_Code__c;
                orderWrap.showPODate = logCntry[0].Show_PO_Date__c;
                orderWrap.showDeliveryDate = logCntry[0].Show_Delivery_Date__c;
                orderWrap.isPORequired = logCntry[0].PO_Date__c;
                orderWrap.isDeliveryRequired = logCntry[0].Delivery_Date__c;
            }                
            /* ------------------ End SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022 ------------------------------- */
            /* depoList = [SELECT Id, Name, Depot__c, Depot__r.Name, Depot__r.Depot_Code__c, Depot__r.SalesOrg__c, 
                        Depot__r.SalesOrg__r.Sales_org_code__c, Territory_Manager__c, Depot_Name__c, Depot_Code__c 
                        FROM TM_Depot_Mapping__c WHERE Territory_Manager__c =: UserInfo.getUserId()];

            if(depoList.size()>0){
                orderWrap.tmDepoList = depoList;
            }    */         

            SOObj = new List<Sales_Order__c>();
            // SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022.....Purchase_order_date__c field added....
            SOObj = [SELECT Id, Name, Bill_To_Party__c, Order_Status__c, Ship_To_Party__c, Sales_Org_lk__c, 
                    Remarks__c, PONumber__c, Order_Type_lk__c, Depot__c, Depot__r.Name, Purchase_Order_Date__c, 
                    Order_For__c, CurrencyIsoCode, Sold_to_Party__c, Ship_To_Party__r.Region__c, 
                    Ship_To_Party__r.City__c, Ship_To_Party__r.State__c, Ship_To_Party__r.Pincode__c,
                    Total_Amount__c, OwnerId, Order__c, SalesOrgCode__c, Business_Type__c, 
                    Payment_Term__c, Payment_Term__r.Payterms_Desc__c, Distribution_Channel_lk__c, Division_lk__c
                    FROM Sales_Order__c WHERE Order_Status__c='Draft' AND Bill_To_Party__c =: id_val 
                    ORDER BY CreatedDate DESC LIMIT 1];
                    
            if(SOObj.size()==0){ // SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022 ..Purchase_order_date__c field added....
                SOObj = [SELECT Id, Name, Bill_To_Party__c, Order_Status__c, Ship_To_Party__c, Sales_Org_lk__c, 
                        Remarks__c, PONumber__c, Order_Type_lk__c, Depot__c, Depot__r.Name, Purchase_Order_Date__c, 
                        Order_For__c, CurrencyIsoCode, Sold_to_Party__c, Ship_To_Party__r.Region__c, 
                        Ship_To_Party__r.City__c, Ship_To_Party__r.State__c, Ship_To_Party__r.Pincode__c,
                        Total_Amount__c, OwnerId, Order__c, SalesOrgCode__c, Business_Type__c, 
                        Payment_Term__c, Payment_Term__r.Payterms_Desc__c, Distribution_Channel_lk__c, Division_lk__c
                        FROM Sales_Order__c WHERE Id =: id_val limit 1];
            }
            System.debug('Sales org obj... -- '+ SOObj);

            if(SOObj.size()==0){

                accList = new List<Account>(); 
                accList = getAccountDetails(id_val);
                accountId = id_val;
                
                orderObj = new List<Order__c>();
                // SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022........PO_Date__c field added...
                orderObj = [SELECT Id, Name, Bill_To_Party__c, Order_Status__c, Sales_Org__c, Depot__c, Depot__r.Name, 
                            Order_Type__c, PONumber__c, Remarks__c, Shipping_Location__c, Order_For__c, PO_Date__c, 
                            OwnerId, Net_Amount__c, Shipping_Location__r.Region__c, Shipping_Location__r.City__c, 
                            Shipping_Location__r.State__c, Shipping_Location__r.Pincode__c, Sales_Org__r.Sales_Org_Code__c 
                            FROM Order__c WHERE Order_Status__c='Draft' AND 
                            Bill_To_Party__c =:id_val ORDER BY CreatedDate DESC LIMIT 1];

                
                orderWrap.payment_term = accList[0].Payment_Term_Code__r.Payterms_Desc__c;
                orderWrap.payment_term_id = accList[0].Payment_Term_Code__c;

                if(accList[0].Customer_Grp__c != null){
                    orderWrap.businessType = accList[0].Customer_Grp__c;

                    if(accList[0].Customer_Grp__r.Customer_Group_Code__c == '75'){
                        orderWrap.businessTypeName = 'B2B';
                    }
                    else if(accList[0].Customer_Grp__r.Customer_Group_Code__c == '76'){
                        orderWrap.businessTypeName = 'B2C';
                    }
                    
                }
                

                if(orderObj.size()<=0){
                    Order__c ordObj2 = new Order__c();
                    ordObj2.Bill_To_Party__c = id_val;
                   // ordObj2.OwnerId = accList[0].OwnerId;                               
                    ordObj2.Order_Date__c = System.today();
                    ordObj2.Order_Status__c = 'Draft';
                    ordObj2.CurrencyIsoCode = SelectedCurrency;
                                                           
                    insert ordObj2;
                    orderWrap.ordr_id = ordObj2.Id;
                    orderWrap.isSalesOrder = false;
                    orderWrap.status = ordObj2.Order_Status__c;
                    orderWrap.orderFor = '';
                    orderWrap.ownerId = ''; //ordObj2.OwnerId;
                    orderWrap.so_id = '';
                    orderWrap.shipping_loc = '';
                }
                else{
                    atchmnt = [SELECT Id, ParentId, Name, ContentType, Body FROM Attachment 
                                WHERE ParentId =: orderObj[0].Id ORDER BY LastModifiedDate DESC LIMIT 1];

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
                    orderWrap.total_amount = orderObj[0].Net_Amount__c.setScale(2);

                    if(orderObj[0].Depot__c != null){
                        orderWrap.depo_name = orderObj[0].Depot__r.Name;  
                        orderWrap.Depo_Obj = orderObj[0].Depot__c; 
                    }
                    /* ----------------- Start SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022 ----------------- */
                    if(orderObj[0].PO_Date__c != null){
                        orderWrap.poDate = String.valueOf(orderObj[0].PO_Date__c);
                    }
                    /* ---------------- End SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022 -------------------- */
                    List<OrderLineItem__c> orderItems = new List<OrderLineItem__c>();
                    // SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022......Delivery_Date__c field added...
                    orderItems = [SELECT Id, Name, FinalPrice__c, Net_Price__c, No_of_Case__c, Edited_Discount__c, 
                                  Order__c, Price__c, Quantity__c, Shipping_Date__c, SKU_Name__c, SKU_Name__r.Name, 
                                  SKU_Name__r.SKU_Description__c, Pack_Size__c, Comment__c, UOM__c, 
                                  Price_Book_Master__c, Distribution_Channel__c, Division__c, Delivery_Date__c, 
                                  Item_Number__c FROM OrderLineItem__c WHERE Order__c =: orderObj[0].Id];

                    if(orderItems.size()>0){
                        
                        for(OrderLineItem__c ordItem : orderItems){
                            OrderItemWrapper itemWrap = new OrderItemWrapper();
                            itemWrap.orderItem_id = ordItem.Id;
                            itemWrap.order_id = ordItem.Order__c;
                            itemWrap.pb_id = ordItem.Price_Book_Master__c;
                            itemWrap.sku_name = ordItem.SKU_Name__r.SKU_Description__c;
                            itemWrap.sku_id = ordItem.SKU_Name__c;
                            itemWrap.uom = ordItem.UOM__c;
                            itemWrap.special_discount = ordItem.Edited_Discount__c;
                            itemWrap.boxes = ordItem.No_of_Case__c;                            
                            itemWrap.quantity = ordItem.Quantity__c;
                            itemWrap.pack_size = ordItem.Pack_Size__c;
                            itemWrap.net_rate = ordItem.FinalPrice__c;
                            itemWrap.net_value = ordItem.Price__c;
                            itemWrap.base_price = ordItem.Net_Price__c;
                            itemWrap.comment = ordItem.Comment__c;
                            //itemWrap.net_price = ordItem.Price__c;
                            //itemWrap.base_price = ordItem.Net_Price__c;
                            itemWrap.shipmnt_date = string.valueOf(ordItem.Shipping_Date__c);
                            //itemWrap.inventory = ordItem.;
                            itemWrap.distributionChanlIds = ordItem.Distribution_Channel__c;
                            itemWrap.divisionIds = ordItem.Division__c;
                            itemWrap.itemNumber = Integer.ValueOf(ordItem.Item_Number__c);

                            if(ordItem.UOM__c.toUpperCase() == 'KG'){
                                orderWrap.quantity_kg = orderWrap.quantity_kg + ordItem.Quantity__c;
                                orderWrap.net_price_kg = (orderWrap.net_price_kg + ordItem.Price__c).setScale(2);
                                //orderWrap.net_price_kg = (orderWrap.net_price_kg + ordItem.Price__c).setScale(2);
                            }
                            else if(ordItem.UOM__c.toUpperCase() == 'L'){
                                orderWrap.quantity_litre = orderWrap.quantity_litre + ordItem.Quantity__c;
                                orderWrap.net_price_litre = (orderWrap.net_price_litre + ordItem.Price__c).setScale(2);
                                //orderWrap.net_price_litre = (orderWrap.net_price_litre + ordItem.Price__c).setScale(2);
                            }

                            if(Integer.ValueOf(ordItem.Item_Number__c) > orderWrap.lastItemNumber){
                                orderWrap.lastItemNumber = Integer.ValueOf(ordItem.Item_Number__c);
                            }
                            /* --------------- Start SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022 ----------------- */
                            if(ordItem.Delivery_Date__c == null){
                                itemWrap.deliveryDate = '';
                            }
                            else{
                                itemWrap.deliveryDate = String.valueOf(ordItem.Delivery_Date__c);
                            }
                            /* --------------- End SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022 ------------------- */
                            orderItemList.add(itemWrap);
                        }
                    }              
                }
            }
            else{
                atchmnt = [SELECT Id, ParentId, Name, ContentType, Body FROM Attachment 
                                WHERE ParentId =: SOObj[0].Id ORDER BY LastModifiedDate DESC LIMIT 1];

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

                if(SOObj[0].Business_Type__c == null){
                    if(accList[0].Customer_Grp__c != null){
                        orderWrap.businessType = accList[0].Customer_Grp__c;
    
                        if(accList[0].Customer_Grp__r.Customer_Group_Code__c == '75'){
                            orderWrap.businessTypeName = 'B2B';
                        }
                        else if(accList[0].Customer_Grp__r.Customer_Group_Code__c == '76'){
                            orderWrap.businessTypeName = 'B2C';
                        }
                        
                    }
                }
                else{
                    orderWrap.businessTypeName = SOObj[0].Business_Type__c;
                }
                
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
                orderWrap.total_amount = SOObj[0].Total_Amount__c.setScale(2);
                orderWrap.CurrencyCode = SOObj[0].CurrencyIsoCode;
                orderWrap.salesOrgObj = SOObj[0].Sales_Org_lk__c;
                orderWrap.Order_Type = SOObj[0].Order_Type_lk__c;

                if(SOObj[0].Depot__c != null){
                    orderWrap.depo_name = SOObj[0].Depot__r.Name;  
                    orderWrap.Depo_Obj = SOObj[0].Depot__c; 
                }
                
                if(SOObj[0].Payment_Term__c == null){
                    orderWrap.payment_term = '';
                    orderWrap.payment_term_id = '';
                }
                else{
                    orderWrap.payment_term = SOObj[0].Payment_Term__r.Payterms_Desc__c;
                    orderWrap.payment_term_id = SOObj[0].Payment_Term__c;
                }
                /* ----------------- Start SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022 -------------------- */
                if(SOObj[0].Purchase_Order_Date__c != null){
                    orderWrap.poDate = String.valueOf(SOObj[0].Purchase_Order_Date__c);
                }
                /* ----------------- End SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022 ----------------------- */
                List<String> divIds = new List<String>();
                List<String> disIds = new List<String>();

                List<Sales_Order_Line_Item__c> orderItems = new List<Sales_Order_Line_Item__c>();
                // SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022....Delivery_Date__c field added...
                    orderItems = [SELECT Id, Name, SKU_Name__c, SKU_Name__r.Name, DepotDepot__c, SKU_Name__r.SKU_Description__c,
                                  Storage_Location__c, UOM__c, CurrencyIsoCode, Finalprice__c, 
                                  Net_Price__c, Quantity__c, Price__c, Sale_Order__c, Shipping_Date__c, 
                                  PriceBookMaster__c, No_of_Case__c, Edited_Discount__c, Pack_Size__c, Comment__c,
                                  Distribution_Channel__c, Division__c, Item_Number__c, Delivery_Date__c 
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
                            itemWrap.special_discount = ordItem.Edited_Discount__c;
                            itemWrap.boxes = ordItem.No_of_Case__c;                             
                            itemWrap.quantity = ordItem.Quantity__c;
                            itemWrap.net_rate = ordItem.FinalPrice__c;
                            //itemWrap.base_price = ordItem.Price__c;
                            //itemWrap.net_price = ordItem.Net_Price__c;
                            itemWrap.base_price = ordItem.Net_Price__c;
                            itemWrap.net_value = ordItem.Price__c;
                            itemWrap.shipmnt_date = string.valueOf(ordItem.Shipping_Date__c);
                            //itemWrap.inventory = ordItem.;
                            itemWrap.pack_size = ordItem.Pack_Size__c;
                            itemWrap.comment = ordItem.Comment__c;
                            itemWrap.distributionChanlIds = ordItem.Distribution_Channel__c;
                            itemWrap.divisionIds = ordItem.Division__c;
                            itemWrap.itemNumber = Integer.valueOf(ordItem.Item_Number__c);                           

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
                            
                            if(Integer.ValueOf(ordItem.Item_Number__c) > orderWrap.lastItemNumber){
                                orderWrap.lastItemNumber = Integer.ValueOf(ordItem.Item_Number__c);
                            }
                            /* --------------- Start SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022 ---------------- */
                            if(ordItem.Delivery_Date__c != null){
                                itemWrap.deliveryDate = String.valueOf(ordItem.Delivery_Date__c);
                            }
                            else{
                                itemWrap.deliveryDate = '';
                            }
                            /* ----------------- End SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022 ------------------ */
                            orderItemList.add(itemWrap);
                            divIds.add(ordItem.Division__c);
                            disIds.add(ordItem.Distribution_Channel__c);
                            orderWrap.Storage_Location = ordItem.Storage_Location__c;
                        }
                    }
                    else{
                        divIds.add(SOObj[0].Division_lk__c);
                        disIds.add(SOObj[0].Distribution_Channel_lk__c);
                        OrderForWrapper orderFor2 = new OrderForWrapper();
                        orderFor2 = setOrderFor(Sales_Org_Code);
                        orderWrap.Storage_Location = orderFor2.Storage_Location.Id;
                    }

                    orderWrap.distributionChanlIds = disIds;
                    orderWrap.divisionIds = divIds;
            }

            if(orderItemList.size()>0 && Sales_Org_Code != ''){
                OrderForWrapper orderFor = new OrderForWrapper();
                orderFor = setOrderFor(Sales_Org_Code);
                List<String> idList = new List<String>();

                for(OrderItemWrapper oiw : orderItemList){
                    if(oiw.sku_id != '' || oiw.sku_id != null){
                        idList.add(oiw.sku_id);
                    }
                }
                
                if(orderWrap.Depo_Obj != null || orderWrap.Depo_Obj != ''){
                    Map<String,Decimal> inventoryMap = new Map<String,Decimal>();

                    inventoryMap = getInventory(idList,Sales_Org_Code,orderWrap.Depo_Obj);
                    
                    if(inventoryMap.size()>0){
                        for(OrderItemWrapper itemW : orderItemList){
                            if(inventoryMap.containsKey(itemW.sku_id)){
                                itemW.inventory= inventoryMap.get(itemW.sku_id);
                            }
                        }
                    }
                }
                                        
            }

                        
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
                        else{
                            shipAdr.Billing_Street_1__c = shipAdr.Billing_Street_1__c;
                        }

                        if(shipAdr.Billing_Street_2__c == null || shipAdr.Billing_Street_2__c == ''){
                            shipAdr.Billing_Street_2__c = 'None';
                        }
                        else{
                            shipAdr.Billing_Street_2__c = shipAdr.Billing_Street_2__c;
                        } 
                        if(shipAdr.Billing_Street_3__c == null || shipAdr.Billing_Street_3__c == ''){
                            shipAdr.Billing_Street_3__c = 'None';
                        }
                        else{
                            shipAdr.Billing_Street_3__c = shipAdr.Billing_Street_3__c;
                        } 

                        if(shipAdr.Billing_Street_4__c == null || shipAdr.Billing_Street_4__c == ''){
                            shipAdr.Billing_Street_4__c = 'None';
                        }
                        else{
                            shipAdr.Billing_Street_4__c = shipAdr.Billing_Street_4__c;
                        } 
                        
                        if(shipAdr.Billing_Street_5__c == null || shipAdr.Billing_Street_5__c == ''){
                            shipAdr.Billing_Street_5__c = 'None';
                        }
                        else{
                            shipAdr.Billing_Street_5__c = shipAdr.Billing_Street_5__c;
                        } 
                        
                        if(shipAdr.Billing_Street_6__c == null || shipAdr.Billing_Street_6__c == ''){
                            shipAdr.Billing_Street_6__c = 'None';
                        }
                        else{
                            shipAdr.Billing_Street_6__c = shipAdr.Billing_Street_6__c;
                        } 
                        
                        if(shipAdr.Region__c == null || shipAdr.Region__c == ''){
                            shipAdr.Region__c = 'None';
                        }
                        else{
                            shipAdr.Region__c = shipAdr.Region__c;
                        }

                        if(shipAdr.Country_Name__c == null || shipAdr.Country_Name__c == ''){    // country name field is used for refence as City name..
                            shipAdr.Country_Name__c = 'None';
                        }
                        else{
                            shipAdr.Country_Name__c = shipAdr.Country_Name__c;
                        }

                        if(shipAdr.State__c == null || shipAdr.State__c == ''){
                            shipAdr.State__c = 'None';
                        }
                        else{
                            shipAdr.State__c = shipAdr.State__c;
                        }

                        if(shipAdr.Pincode__c == null || shipAdr.Pincode__c == ''){
                            shipAdr.Pincode__c = 'None';
                        }
                        else{
                            shipAdr.Pincode__c = shipAdr.Pincode__c;
                        }
                        if(shipAdr.Country__c == null || shipAdr.Country__c == ''){
                            shipAdr.Country__c = 'None';
                        }
                        else{
                            shipAdr.Country__c = shipAdr.Country__c;
                        }
                        shippingMap.put(shipAdr.id,shipAdr);
                    }
                }

                Shipping_Location__c shipLoc = new Shipping_Location__c();   // for shipping location Same as billing address..
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
                }
                
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
            if(orderWrap.businessTypeName == 'B2C'){
                orderForList = [SELECT Id, Name, Distributor__c, SalesOrg__c, SalesOrg__r.Name, Sales_Org_Code__c,  
                                AccountOwner__c FROM DistributorSalesAreaMapping__c where Distributor__c =: accountId AND
                                AccountOwner__c =: loginUserObj.Id ORDER BY LastModifiedDate DESC];
            }
            else if(orderWrap.businessTypeName == 'B2B'){
                orderForList = [SELECT Id, Name, Distributor__c, SalesOrg__c, SalesOrg__r.Name, Sales_Org_Code__c,  
                                AccountOwner__c FROM DistributorSalesAreaMapping__c where Distributor__c =: accountId AND
                                Sales_Org_Code__c = '6610' ORDER BY LastModifiedDate DESC LIMIT 1];
            }

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
            

            //loginUserObj.Profile.Name.Contains('Business Intelligence Manager')
            /* if(loginUserObj.Profile.Name == 'Regional Manager/Sales Reps Spain'){
                orderForList = [SELECT Id, Name, Distributor__c, SalesOrg__c, SalesOrg__r.Name, Sales_Org_Code__c,  
                                AccountOwner__c FROM DistributorSalesAreaMapping__c where Distributor__c =: accountId AND
                                AccountOwner__c =: loginUserObj.Id LIMIT 1];   
            }
            else{
                orderForList = [SELECT Id, Name, Distributor__c, SalesOrg__c, SalesOrg__r.Name, Sales_Org_Code__c,  
                                AccountOwner__c FROM DistributorSalesAreaMapping__c where Distributor__c =: accountId ];

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
            } */

            List<Sales_Order_Line_Item__c> historyList = new List<Sales_Order_Line_Item__c>();
            historyList = [SELECT Id, Name, Sale_Order__c, Sale_Order__r.Name, Sale_Order__r.Order_Status__c, 
                           SAP_Order_Number__c,Sales_Order_Code__c, SKU_Code__c, SKU_Name__c, SKU_Description__c, 
                           Quantity__c, Sales_Org_Code__c FROM Sales_Order_Line_Item__c 
                           WHERE Sale_Order__r.Bill_To_Party__c =: accountId ORDER BY LastModifiedDate DESC LIMIT 10];

            if(historyList.size()>0){
                List<OrderHistory> histList = new List<OrderHistory>();
                for(Sales_Order_Line_Item__c lItem : historyList){
                    OrderHistory ordHis = new OrderHistory();
                    ordHis.so_id = lItem.Sale_Order__c;
                    ordHis.orderNO = lItem.Sale_Order__r.Name;
                    ordHis.orderSAP = lItem.SAP_Order_Number__c;
                    ordHis.orderSFDC = lItem.Sales_Order_Code__c;
                    ordHis.orderStatus = lItem.Sale_Order__r.Order_Status__c;
                    ordHis.skuId = lItem.SKU_Name__c;
                    ordHis.skuDesc = lItem.SKU_Description__c;
                    ordHis.skuCode = lItem.SKU_Code__c;
                    ordHis.quantity = lItem.Quantity__c;

                    histList.add(ordHis);
                }

                if(histList.size()>0){
                    orderWrap.orderHistory = histList;
                }
            }
            
            List<Payment_Term__c> paymentTermList = new List<Payment_Term__c>();
            paymentTermList = [SELECT Id, Name, Payment_Term_Code__c, Payment_Term__c, Sales_Org__c, 
                                   Payterms_Desc__c, Active__c, SalesOrgCode__c, CombinationKey__c 
                                   FROM Payment_Term__c WHERE SalesOrgCode__c =: Sales_Org_Code AND Active__c = true];

            if(paymentTermList.size()>0){
                orderWrap.payTermList = paymentTermList;
            }                       


            if(loginUserObj.Profile.Name == 'Vietnam Regional Sales Manager(RSM)'){
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
            PriceBookDetailsWrapper priceBookW = new PriceBookDetailsWrapper();
            orderWrap.priceBookWrapper = priceBookW;
            orderWrap.orderItemList = orderItemList;

            if(atchmnt.size()>0){
                orderWrap.fileName = atchmnt[0].Name;
            }
                        
        }
        catch(Exception ex){
            System.debug('Exception in getOrderDetails method : ' + ex);
            System.debug('Exception is : ' + ex);
            System.debug('Exception Line No : ' + ex.getLineNumber());
        }

        return orderWrap;
    }

    @AuraEnabled   
    public static OrderForWrapper setOrderFor(String org_code){

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
        List<Payment_Term__c> paymentTermList = new List<Payment_Term__c>();
        List<Depot__c> depoList = new List<Depot__c>();
        try{        
            if(org_code == '6610'){
              //  salesOrgObj = new Sales_Org__c();
                salesOrgObj = [SELECT Id, Name, Description__c, Sales_Org_Code__c FROM Sales_Org__c 
                            where Sales_Org_Code__c = '6610' limit 1];

              //  Order_Type = new Order_Type__c();
                Order_Type = [SELECT Id, Name, Description__c, Order_Type_Code__c, SalesOrg__c, Division__c 
                            FROM Order_Type__c where Order_Type_Code__c = 'ZZOR' AND Combination_Key__c='661010ZZOR' limit 1];

              //  Storage_Location = new Depot__c();
                /* Storage_Location = [SELECT Id, Name, Depot_Code__c, SalesOrg__c, Plant_Desc__c, Active__c, Depot__c, 
                                    Shipping_Point__c, RecordType.Name FROM Depot__c where 
                                    Name = 'VN00' AND RecordType.Name='Storage Location']; */

                Distribution_ChnlList = [SELECT Id, Name, Description__c, Distribution_Channel_Code__c, Sales_Org__c 
                                        FROM Distribution_Channel__c where Distribution_Channel_Code__c IN ('10')];
                if(Distribution_ChnlList.size()>0){
                    for(Distribution_Channel__c dcl : Distribution_ChnlList){
                        distributionChanlIds.add(dcl.Id);
                    }
                }

                Division_List = [SELECT Id, Name, Description__c, Division_Code__c FROM Division__c 
                                where Division_Code__c IN ('10')];  
                if(Division_List.size()>0){
                    for(Division__c dvsn : Division_List){
                        divisionIds.add(dvsn.Id);
                    }
                }                

               // Depo_Obj = new Depot__c();
                Depo_Obj = [SELECT Id, Name, Depot_Code__c, SalesOrg__c, Plant_Desc__c, Active__c, Depot__c 
                            FROM Depot__c where Depot_Code__c = 'VN00'];    
                            
                paymentTermList = [SELECT Id, Name, Payment_Term_Code__c, Payment_Term__c, Sales_Org__c, 
                                   Payterms_Desc__c, Active__c, SalesOrgCode__c, CombinationKey__c 
                                   FROM Payment_Term__c WHERE SalesOrgCode__c ='6610' AND Active__c = true];
                                   
                /* depoList = [SELECT Id, Name, Depot_Code__c, SalesOrg__c, Plant_Desc__c, Active__c, Depot__c 
                            FROM Depot__c where SalesOrg__r.Sales_org_code__c = '6610']; */   
                    depoList = getDepoList(org_code);                                    
            }
            else if(org_code == '6631'){
               // salesOrgObj = new Sales_Org__c();
                salesOrgObj = [SELECT Id, Name, Description__c, Sales_Org_Code__c FROM Sales_Org__c 
                            where Sales_Org_Code__c = '6631' limit 1];

               // Order_Type = new Order_Type__c();
                Order_Type = [SELECT Id, Name, Description__c, Order_Type_Code__c, SalesOrg__c, Division__c 
                            FROM Order_Type__c where Order_Type_Code__c = 'ZZOR' AND Combination_Key__c='663110ZZOR' limit 1];
               

               // Storage_Location = new Depot__c();
                /* Storage_Location = [SELECT Id, Name, Depot_Code__c, SalesOrg__c, Plant_Desc__c, Active__c, Depot__c, 
                                    Shipping_Point__c, RecordType.Name FROM Depot__c where 
                                    Name = 'SW06' AND RecordType.Name='Storage Location']; */

                Distribution_ChnlList = [SELECT Id, Name, Description__c, Distribution_Channel_Code__c, Sales_Org__c 
                                        FROM Distribution_Channel__c where Distribution_Channel_Code__c IN ('10')];
                if(Distribution_ChnlList.size()>0){
                    for(Distribution_Channel__c dcl : Distribution_ChnlList){
                        distributionChanlIds.add(dcl.Id);
                    }
                }

                Division_List = [SELECT Id, Name, Description__c, Division_Code__c FROM Division__c 
                                where Division_Code__c IN ('10')];
                if(Division_List.size()>0){
                    for(Division__c dvsn : Division_List){
                        divisionIds.add(dvsn.Id);
                    }
                } 

                paymentTermList = [SELECT Id, Name, Payment_Term_Code__c, Payment_Term__c, Sales_Org__c, 
                                   Payterms_Desc__c, Active__c, SalesOrgCode__c, CombinationKey__c 
                                   FROM Payment_Term__c WHERE SalesOrgCode__c ='6631' AND Active__c = true];

              //  Depo_Obj = new Depot__c();
                /* Depo_Obj = [SELECT Id, Name, Depot_Code__c, SalesOrg__c, Plant_Desc__c, Active__c, Depot__c 
                            FROM Depot__c where Depot_Code__c = 'ES51']; */

                /* depoList = [SELECT Id, Name, Depot_Code__c, SalesOrg__c, Plant_Desc__c, Active__c, Depot__c 
                            FROM Depot__c where SalesOrg__r.Sales_org_code__c = '6631']; */  
                    depoList = getDepoList(org_code);                   
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
            orderFor.paymentTermList = paymentTermList;
            orderFor.tmDepoList = depoList;
            
        }
        catch(Exception ex){
            System.debug('Exception in setOrderFor method : ' + ex);
            System.debug('Exception is : ' + ex);
        }

        return orderFor;
    }
    
    @AuraEnabled   
    public static OrderForWrapper getTMDepoList(String org_code){
        OrderForWrapper orderFor = new OrderForWrapper();

        try{
            orderFor.tmDepoList = getDepoList(org_code); 
        }
    
        catch(Exception ex){
            System.debug('Exception in getTMDepoList method : ' + ex);
            System.debug('Exception is : ' + ex);
        }
        return orderFor;
    }

    @AuraEnabled   
    public static PriceBookWrapper getSKUInventory(String skuId,String Sales_Org_Code, String depoId){
        PriceBookWrapper pbWrapper = new PriceBookWrapper();
                
        try{
            
            Map<String,Decimal> inventoryMap = new Map<String,Decimal>();
            List<String> idList = new List<String>();
            idList.add(skuId);
            inventoryMap = getInventory(idList,Sales_Org_Code,depoId);

            if(inventoryMap.size()>0){
                if(inventoryMap.containsKey(skuId)){
                    pbWrapper.inventory = inventoryMap.get(skuId);
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
       // List<Order__c> orderIds = new List<Order__c>();
       // List<String> orIds = new List<String>();
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
            /* --------------- Start SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022 ------------------- */
            if(ordWrap.showPODate == true && String.isNotBlank(ordWrap.poDate)){
                ordObj.PO_Date__c = Date.valueof(ordWrap.poDate);
            }
            else if(ordWrap.showPODate == true && String.isBlank(ordWrap.poDate)){
                ordObj.PO_Date__c = null;
            }
            /* --------------- End SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022 --------------------- */
        // ordObj.Distribution_Channel__c = ordWrap.distributorChannelId; 
        // ordObj.Division__c = ordWrap.divisionId; 
            
            update ordObj;
           // orIds.add(ordObj.Id);
            Integer itemNumber = 0;

            if(orderItemList.size()>0){
                itemNumber = ordWrap.lastItemNumber;
            }
            
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
                    
                    ordItem.CurrencyIsoCode = ordWrap.CurrencyCode;
                    ordItem.FinalPrice__c = itemWrap.net_rate;
                    ordItem.Net_Price__c = itemWrap.base_price;
                    ordItem.Price__c = itemWrap.net_value;
                    System.debug('net_value :- ' + itemWrap.net_value);
                    /* ordItem.Net_Price__c = itemWrap.base_price;
                    ordItem.Price__c = itemWrap.net_price; */
                    ordItem.Quantity__c = itemWrap.quantity;
                    ordItem.Shipping_Date__c = Date.valueof(itemWrap.shipmnt_date);
                    ordItem.SKU_Name__c = itemWrap.sku_id;
                    ordItem.UOM__c = itemWrap.uom;
                    System.debug('businessTypeName :- ' + ordWrap.businessTypeName);
                    if(ordWrap.businessTypeName == 'B2C'){
                        ordItem.Price_Book_Master__c = itemWrap.pb_id;
                    }
                    
                    ordItem.Distribution_Channel__c = itemWrap.distributionChanlIds;
                    ordItem.Division__c = itemWrap.divisionIds;
                    ordItem.No_of_Case__c = itemWrap.boxes;
                    ordItem.Edited_Discount__c = itemWrap.special_discount;
                    ordItem.Pack_Size__c = itemWrap.pack_size;
                    ordItem.Comment__c = itemWrap.comment;                  
                    if(itemWrap.itemNumber == 0){
                        itemNumber = itemNumber+10;
                        ordItem.Item_Number__c = String.valueOf(itemNumber);
                    }
                    /* ------------------- Start SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022 -------------------- */
                    if(ordWrap.showDeliveryDate == true && String.isNotBlank(itemWrap.deliveryDate)){
                        ordItem.Delivery_Date__c = Date.valueof(itemWrap.deliveryDate);
                    }
                    else if(ordWrap.showDeliveryDate == true && String.isBlank(itemWrap.deliveryDate)){
                        ordItem.Delivery_Date__c = null;
                    }
                    /* ----------------- End SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022 ----------------------- */
                    orderLineItems.add(ordItem);
                }

                if(orderLineItems.size()>0){
                    upsert orderLineItems;
                    result = true;
                }
            }

           
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
    public static List<Sales_Order__c> createNewSO(String orderObj){
        List<Sales_Order__c> orderIds = new List<Sales_Order__c>();
        List<Sales_Order__c> orderToUpdate = new List<Sales_Order__c>();
        List<String> orIds = new List<String>();
        OrderWrapper ordWrap = (OrderWrapper)JSON.deserialize(orderObj, OrderWrapper.class);
        List<OrderItemWrapper> orderItemList = ordWrap.orderItemList;
        CreditSummaryWrapper credSum = ordWrap.creditSummary;
        Map<String, Sales_Order__c> divisionSOMap = new Map<String, Sales_Order__c>();
        Map<String, Integer> itemNoMap = new Map<String, Integer>();
        Map<String,List<OrderItemWrapper>> DivisionMap = new Map<String,List<OrderItemWrapper>>();
        User user = new User();
        try{

            String div_Id = '';
            String sOrder_Id = '';
            Integer itemNo = 0;
            
            /* if(orderItemList.size()>0){
                itemNo = ordWrap.lastItemNumber;
            } */

            if(orderItemList.size()>0){

                user = [SELECT Id, Name, Country, IsActive, Show_Inventory__c, Show_Credit_Limit__c, 
                        Show_Inventory_Column__c, Show_InTransit__c, Show_InTransit_Values__c, 
                        ProfileId,Profile.Name, ManagerId, Country_Head__c, Zonal_Manager__c, RegionalManager__c
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
                            ordObj.Total_Amount__c = ordObj.Total_Amount__c + item.net_value;

                            if(ordWrap.businessTypeName == 'B2C'){
                                if((item.special_discount > 0 || credSum.net_overdue > 0) && ordObj.Sent_for_Manager_Approval_Mexico__c == false){
                                    ordObj.Order_Status__c = 'Pending';
                                    ordObj.Sent_for_Manager_Approval_Mexico__c = true;
                                    ordObj.Sent_for_Director_Approval_Mexico__c = true;
    
                                    sliObj.is_Approval_Required__c = true;
                                }
                            }
                            else if(ordWrap.businessTypeName == 'B2B'){
                                ordObj.Order_Status__c = 'Pending';
                                ordObj.Sent_for_Manager_Approval_Mexico__c = true;
                                sliObj.is_Approval_Required__c = true;
                            }

                            /* if((item.special_discount > 0 || credSum.net_overdue > 0) && ordObj.Sent_for_Manager_Approval_Mexico__c == false){
                                ordObj.Order_Status__c = 'Pending';
                                ordObj.Sent_for_Manager_Approval_Mexico__c = true;

                                if(ordWrap.businessTypeName == 'B2C'){
                                    ordObj.Sent_for_Director_Approval_Mexico__c = true;
                                }

                                sliObj.is_Approval_Required__c = true;
                            } */
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
                            ordObj.Business_Type__c = ordWrap.businessTypeName;
                            ordObj.Overdue_Amount__c = credSum.net_overdue;
                            ordObj.Total_Credit_Limit__c = credSum.total_credit_limit;

                            /* if(ordWrap.businessTypeName == 'B2C'){
                                if(user.RegionalManager__c != null){
                                    ordObj.Manager__c = user.RegionalManager__c;
                                }
                            }

                            if(user.Zonal_Manager__c != null){
                                ordObj.Sales_Director_Mexico__c = user.Zonal_Manager__c; 
                            } */
                            
                            if(ordWrap.businessTypeName == 'B2C'){
                                
                                if(item.special_discount > 0 || credSum.net_overdue > 0){
                                    ordObj.Order_Status__c = 'Pending';
                                    ordObj.Sent_for_Manager_Approval_Mexico__c = true;
                                    ordObj.Sent_for_Director_Approval_Mexico__c = true;                                  
                                }
                                else{
                                    ordObj.Order_Status__c = 'Open';
                                    ordObj.Sent_for_Manager_Approval_Mexico__c = false;
                                    ordObj.Sent_for_Director_Approval_Mexico__c = false;
                                }

                                if(user.RegionalManager__c != null){
                                    ordObj.Manager__c = user.RegionalManager__c;
                                }
                                if(user.Zonal_Manager__c != null){
                                    ordObj.Sales_Director_Mexico__c = user.Zonal_Manager__c; 
                                }
                            }
                            else if(ordWrap.businessTypeName == 'B2B'){
                                ordObj.Order_Status__c = 'Pending';
                                ordObj.Sent_for_Manager_Approval_Mexico__c = true;

                                if(user.Zonal_Manager__c != null){
                                    ordObj.Sales_Director_Mexico__c = user.Zonal_Manager__c; 
                                }
                            }
                            /* ----------------- Start SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022 -------------------- */
                            if(ordWrap.showPODate == true && String.isNotBlank(ordWrap.poDate)){
                                ordObj.Purchase_Order_Date__c = Date.valueof(ordWrap.poDate);
                            }
                            else if(ordWrap.showPODate == true && String.isBlank(ordWrap.poDate)){
                                ordObj.Purchase_Order_Date__c = null;
                            }
                            /* -------------- End SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022 ------------------------------ */
                            /* if(item.special_discount > 0 || credSum.net_overdue > 0){
                                ordObj.Order_Status__c = 'Pending';
                                ordObj.Sent_for_Manager_Approval_Mexico__c = true;

                                if(ordWrap.businessTypeName == 'B2C'){
                                    ordObj.Sent_for_Director_Approval_Mexico__c = true;
                                }
                                
                            }
                            else{
                                ordObj.Order_Status__c = 'Open';
                                ordObj.Sent_for_Manager_Approval_Mexico__c = false;
                                ordObj.Sent_for_Director_Approval_Mexico__c = false;
                            } */
                            
                            ordObj.Depot__c = ordWrap.Depo_Obj; 
                            ordObj.Total_Amount__c = item.net_value;
                           // ordObj.Gross_Amount_With_Early_Discount__c = ordWrap.gross_amount;
                            
                            ordObj.Payment_Term__c = ordWrap.payment_term_id;

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

                        if(item.special_discount > 0 || credSum.net_overdue > 0){
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
                        sliObj.Finalprice__c = item.net_rate;
                        //sliObj.Net_Price__c = item.net_price;
                        //sliObj.Price__c = item.base_price;
                        sliObj.Net_Price__c = item.base_price;
                        sliObj.Price__c = item.net_value;
                        sliObj.Quantity__c = item.quantity;
                        sliObj.Shipping_Date__c = Date.valueof(item.shipmnt_date);
                        //sliObj.PriceBookMaster__c = item.pb_id;
                        if(ordWrap.businessTypeName == 'B2C'){
                            sliObj.PriceBookMaster__c = item.pb_id;
                        }
                        
                        sliObj.Distribution_Channel__c = item.distributionChanlIds;
                        sliObj.Division__c = item.divisionIds;

                        sliObj.No_of_Case__c = item.boxes;
                        sliObj.Edited_Discount__c = item.special_discount;
                        sliObj.Pack_Size__c = item.pack_size;
                        sliObj.Comment__c = item.comment; 
                        /* ------------------------ Start SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022 ------------------ */
                        if(ordWrap.showDeliveryDate == true && String.isNotBlank(item.deliveryDate)){
                            sliObj.Delivery_Date__c = Date.valueof(item.deliveryDate);
                        }
                        else if(ordWrap.showDeliveryDate == true && String.isBlank(item.deliveryDate)){
                            sliObj.Delivery_Date__c = null;
                        }
                       /* ------------------ End SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022 ------------------------ */
                        soItemList.add(sliObj);
                        ordWrap.so_id = '';
                    }
                }

                if(soItemList.size()>0){
                    upsert soItemList;  //orderToUpdate
                    
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
                orderIds = [SELECT Id, Name, Total_Amount__c, Call_Process_Builder_Flow__c FROM Sales_Order__c WHERE Id IN : orIds];

                if(orderIds.size() > 0){
                    for(Sales_Order__c sOrder : orderIds){
                        //Decimal val = sOrder.Total_Amount__c; //(sOrder.Total_Amount__c - ((sOrder.Total_Amount__c * sOrder.Early_Order_Discount__c) / 100)).setScale(2) ;
                        //sOrder.Total_Amount__c = val;
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
        CreditSummaryWrapper credSum = ordWrap.creditSummary;
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
            ordObj.Total_Amount__c = ordWrap.total_amount;
            ordObj.Order_Status__c = 'Draft';
           
            ordObj.Payment_Term__c = ordWrap.payment_term_id;
            ordObj.Overdue_Amount__c = credSum.net_overdue;
            ordObj.Total_Credit_Limit__c = credSum.total_credit_limit;
            /* ----------------- Start SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022 --------------------- */
            if(ordWrap.showPODate == true && String.isNotBlank(ordWrap.poDate)){
                ordObj.Purchase_Order_Date__c = Date.valueof(ordWrap.poDate);
            }
            else if(ordWrap.showPODate == true && String.isBlank(ordWrap.poDate)){
                ordObj.Purchase_Order_Date__c = null;
            }
            /* ---------------- End SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022 ---------------------- */
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
                        sliObj.Finalprice__c = item.net_rate;
                       // sliObj.Net_Price__c = item.net_price;
                       // sliObj.Price__c = item.base_price;
                        sliObj.Net_Price__c = item.base_price;
                        sliObj.Price__c = item.net_value;
                        sliObj.Quantity__c = item.quantity;
                        
                        
                        sliObj.Shipping_Date__c = Date.valueof(item.shipmnt_date);
                        //sliObj.PriceBookMaster__c = item.pb_id;
                        if(ordWrap.businessTypeName == 'B2C'){
                            sliObj.PriceBookMaster__c = item.pb_id;
                        }
                        
                        sliObj.Distribution_Channel__c = item.distributionChanlIds;
                        sliObj.Division__c = item.divisionIds;
                                               
                        sliObj.No_of_Case__c = item.boxes;
                        sliObj.Edited_Discount__c = item.special_discount;
                        sliObj.Pack_Size__c = item.pack_size;
                        sliObj.Comment__c = item.comment; 
                        /* ------------------ Start SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022 ------------------- */
                        if(ordWrap.showDeliveryDate == true && String.isNotBlank(item.deliveryDate)){
                            sliObj.Delivery_Date__c = Date.valueof(item.deliveryDate);
                        }
                        else if(ordWrap.showDeliveryDate == true && String.isBlank(item.deliveryDate)){
                            sliObj.Delivery_Date__c = null;
                        }
                        /* --------------------End SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022 ---------------- */
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
        
        System.debug('deleteLineItem id -: '+ itemId);
        if(type == 'Sales Order'){
            List<Sales_Order_Line_Item__c> soItemList = [SELECT Id, Name,Sale_Order__c,Sale_Order__r.Total_Amount__c 
                                                         FROM Sales_Order_Line_Item__c  WHERE Id=:itemId LIMIT 1];
                        if(soItemList.size()>0){
                            Sales_Order__c sOrdr = new Sales_Order__c();
                            sOrdr.Id = soItemList[0].Sale_Order__c;
                            sOrdr.Total_Amount__c = soItemList[0].Sale_Order__r.Total_Amount__c - netPrc;
                            //Decimal grsPrc = (sOrdr.Total_Amount__c - ((soItemList[0].Sale_Order__r.Early_Order_Discount__c * sOrdr.Total_Amount__c) / 100)).setScale(2) ;
                            //sOrdr.Gross_Amount_With_Early_Discount__c = soItemList[0].Sale_Order__r.Gross_Amount_With_Early_Discount__c - grsPrc;
                            update sOrdr;

                            delete soItemList;
                            result = true;
                        }                                
        }
        else if(type == 'Order'){
            List<OrderLineItem__c> soItemList = [SELECT Id, Name, Order__c, Order__r.Net_Amount__c 
                                                    FROM OrderLineItem__c WHERE Id=:itemId LIMIT 1];
                if(soItemList.size()>0){
                    Order__c ordr = new Order__c();
                    ordr.Id = soItemList[0].Order__c;
                    
                    //Decimal grsPrc = (soItemList[0].Order__r.Gross_Net__c - ((soItemList[0].Order__r.Early_Order_Discount__c * soItemList[0].Order__r.Gross_Net__c) / 100)).setScale(2) ;
                    //ordr.Gross_Amount_With_Early_Discount__c = soItemList[0].Order__r.Gross_Amount_With_Early_Discount__c - grsPrc;
                    
                    delete soItemList;
                    update ordr;
                    
                    result = true;
                }  
        }
        return result;
    }

    @AuraEnabled   
    public static Boolean deleteAllLineItem(String ordrId, String type){
        Boolean result = false;
        System.debug('deleteAllLineItem id -: '+ ordrId);
        if(type == 'Sales Order'){
            List<Sales_Order_Line_Item__c> soItemList = [SELECT Id, Name, Sale_Order__c FROM Sales_Order_Line_Item__c 
                                                        WHERE Sale_Order__c=:ordrId ];
                        if(soItemList.size()>0){
                            delete soItemList; //
                            Sales_Order__c sOrdr = new Sales_Order__c();
                            sOrdr.Id = ordrId;
                            sOrdr.Total_Amount__c = 0;
                            //sOrdr.Gross_Amount_With_Early_Discount__c = 0;
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
                    //ordr.Gross_Amount_With_Early_Discount__c = 0;
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
                 BillingStreet, BillingState, BillingPostalCode , CurrencyIsoCode, Customer_Grp__c, 
                 Sales_Org__r.Name, OwnerId, SAP_Code__c, Sales_Org__c, Distribution_Channel__c,
                 Division__c,Inco_Term__c, Inco_Term__r.IncoTerm_Desc__c,Inco_Term__r.Name,
                 Order_Type__c, Order_Block__c,Sales_Org_Code__c, Status__c, Payment_Terms__c, 
                 Payment_Term_Code__c, Payment_Term_Code__r.Payterms_Desc__c, PriceGroupCode__c,
                 Sales_District__r.Sales_Director__c,Sales_District__r.Latam_Director__c, Sales_District__c,
                 Payment_Method__c, Payment_Method__r.Name, Payment_Method__r.Description__c, 
                 Customer_Grp__r.Name, Customer_Grp__r.Customer_Group_Code__c 
                 FROM Account WHERE Id=:acc_id];
        return acList;                             
    }

    public static Map<String,Decimal> getInventory(List<String> skuId, String salesOrg, String depoId){
        Map<String,Decimal> stockReq = new  Map<String,Decimal>();
         
        /* if(skuId == ''){
            stockReq = [SELECT Id, Name, SKU__c, Depot__c, Balanced_Quanity__c, UOM__c 
                        FROM Inventory__c WHERE  Depot__c =: depo_id AND 
                        Storage_Location_Depot__r.Combination_key_Storage_Location__c =:combKey]; 
        }
        else{
            stockReq = [SELECT Id, Name, SKU__c, Depot__c, Balanced_Quanity__c, UOM__c 
                        FROM Inventory__c WHERE SKU__c =: skuId AND Depot__c =: depo_id AND 
                        Storage_Location_Depot__r.Combination_key_Storage_Location__c =:combKey LIMIT 1];  
        }  */
        
        Map<String, Decimal> soMap = new Map<String, Decimal>();
        Map<String, Decimal> srMap = new Map<String, Decimal>();
        List<Sales_Order_Line_Item__c> solList = new List<Sales_Order_Line_Item__c>();
        solList = [Select Id,Name,SKU_Name__c, Quantity__c, Sale_Order__r.Depot__c from Sales_Order_Line_Item__c
                   WHERE SKU_Name__c IN: skuId AND Sale_Order__r.Order_Status__c='Pending'
                   AND Sale_Order__r.SalesOrgCode__c=: salesOrg AND Sale_Order__r.Depot__c =: depoId]; 

        if(solList.size()>0){
            for(Sales_Order_Line_Item__c obj:solList){
                
                if(soMap.containsKey(obj.SKU_Name__c)){
                    Decimal val = soMap.get(obj.SKU_Name__c);
                    Decimal val2 = val + obj.Quantity__c;
                    soMap.put(obj.SKU_Name__c,val2);
                }
                else{
                    soMap.put(obj.SKU_Name__c,obj.Quantity__c);
                }
            }
        }

        List<Stock_Requirement__c> stList = new List<Stock_Requirement__c>();
        stList =[SELECT Id,Available_Stock__c,SKU__c, Depot__c FROM Stock_Requirement__c 
                    WHERE SKU__c IN: skuId AND Depot__c =: depoId];
        if(stList.size()>0){
            for(Stock_Requirement__c sr : stList){
                if(srMap.containsKey(sr.SKU__c)){
                    Decimal val = srMap.get(sr.SKU__c);
                    Decimal val2 = val + sr.Available_Stock__c;
                    srMap.put(sr.SKU__c,val2);
                }
                else{
                    srMap.put(sr.SKU__c,sr.Available_Stock__c);
                }
            }
            
        }

        if(soMap.size()>0){
            for(String sku : soMap.keySet()){
                
                Decimal totQ = 0;
                if(srMap.containsKey(sku)){
                    totQ =  srMap.get(sku) - soMap.get(sku);
                }
                else{
                    totQ = 0 - soMap.get(sku);
                }

                if(!stockReq.containsKey(sku)){
                    stockReq.put(sku,totQ);
                }

            }
        }
        else if(srMap.size()>0){
            for(String sku:srMap.keySet()){
                Decimal totQ = 0;
                if(srMap.containsKey(sku)){
                    totQ = srMap.get(sku);
                }
                else{
                    totQ = 0;
                }
                
                if(!stockReq.containsKey(sku)){
                    stockReq.put(sku,totQ);
                }
            }
        } 
        
                
        return stockReq;
    }

    public static List<Depot__c> getDepoList(String salesOrg){
        List<Depot__c> depoList = new List<Depot__c>();

        if(salesOrg != null){
            depoList = [SELECT Id, Name, Depot_Code__c, SalesOrg__c, Plant_Desc__c, Active__c, Depot__c, RecordType.Name 
                        FROM Depot__c where SalesOrg__r.Sales_org_code__c =: salesOrg AND RecordType.Name = 'Depot'];
        }
        
        return depoList;
    }

    public class OrderHistory{
        @AuraEnabled public String so_id;
        @AuraEnabled public String orderNO;
        @AuraEnabled public String orderSAP;
        @AuraEnabled public String orderSFDC;
        @AuraEnabled public String orderStatus;
        @AuraEnabled public String skuId;
        @AuraEnabled public String skuDesc;
        @AuraEnabled public String skuCode;
        @AuraEnabled public Decimal quantity;

        public OrderHistory(){
            so_id = '';
            orderNO = '';
            orderSAP = '';
            orderSFDC = '';
            orderStatus = '';
            skuId = '';
            skuDesc = '';
            skuCode = '';
            quantity = 0;
        }
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
        @AuraEnabled public List<Payment_Term__c> paymentTermList;
        @AuraEnabled public List<Depot__c> tmDepoList;

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
            paymentTermList = new List<Payment_Term__c>();
            tmDepoList = new List<Depot__c>();
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
        @AuraEnabled public Decimal pack_size;
        @AuraEnabled public Decimal base_price;
        @AuraEnabled public Decimal special_discount;
        @AuraEnabled public Decimal boxes;
        @AuraEnabled public Decimal quantity;
        @AuraEnabled public Decimal net_rate;
        @AuraEnabled public Decimal net_value;
        @AuraEnabled public String shipmnt_date;
        @AuraEnabled public Decimal inventory;
        @AuraEnabled public String comment;
        @AuraEnabled public String distributionChanlIds;
        @AuraEnabled public String divisionIds;
        @AuraEnabled public String deliveryDate;     // SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022
       // @AuraEnabled public Decimal min_quantity;
       // @AuraEnabled public String campaign_code;
       //@AuraEnabled public String campaign_nm;
       // @AuraEnabled public String campaign_id;
       // @AuraEnabled public Boolean apply_cmpgn_disc;
       // @AuraEnabled public Decimal campaign_discount;
       // @AuraEnabled public Decimal line_discount;
       // @AuraEnabled public Decimal volume_discount;
       // @AuraEnabled public Decimal final_price;
       // @AuraEnabled public Decimal net_price;
       // @AuraEnabled public Decimal actual_discount;
       // @AuraEnabled public Decimal edited_discount;
       // @AuraEnabled public Decimal multiple_of;
       // @AuraEnabled public Decimal actual_campaign_discount;
       // @AuraEnabled public Decimal actual_line_discount;
       // @AuraEnabled public Decimal actual_volume_discount;
       //@AuraEnabled public String pb_discount_id;

        public PriceBookDetailsWrapper(){
            pb_id = '';
            sku_name = '';
            sku_id = '';
            uom = '';
            pack_size = 0.0;
            base_price = 0.0;
            special_discount = 0.0;
            boxes = 0.0;
            quantity = 0.0;
            net_rate = 0.0;
            net_value = 0.0;
            shipmnt_date = String.valueOf(System.today());
            inventory = 0.0;
            comment = '';
            distributionChanlIds = '';
            divisionIds = '';
            deliveryDate = String.valueOf(System.today()+1); // SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022
            //min_quantity = 0;
            //campaign_code = '';
            //campaign_nm = '';
            //campaign_id = '';
            //apply_cmpgn_disc = false;
            //campaign_discount = 0.0;
            //line_discount = 0.0;
            //volume_discount = 0.0;
            //final_price = 0.0;
            //net_price = 0.0;
            //actual_discount = 0.0;
            //edited_discount = 0.0;
            //multiple_of = 0.0;
            //actual_campaign_discount = 0.0;
            //actual_line_discount = 0.0;
            //actual_volume_discount = 0.0;
            //pb_discount_id = '';
        }
    }

    public class OrderItemWrapper{
        @AuraEnabled public String orderItem_id;
        @AuraEnabled public String order_id;
        @AuraEnabled public String pb_id;
        @AuraEnabled public String sku_name;
        @AuraEnabled public String sku_id;
        @AuraEnabled public String uom;
        @AuraEnabled public Decimal pack_size;
        @AuraEnabled public Decimal base_price;
        @AuraEnabled public Decimal special_discount;
        @AuraEnabled public Decimal boxes;
        @AuraEnabled public Decimal quantity;
        @AuraEnabled public Decimal net_rate;
        @AuraEnabled public Decimal net_value;
        @AuraEnabled public String shipmnt_date;
        @AuraEnabled public Decimal inventory;
        @AuraEnabled public String comment;
        @AuraEnabled public String distributionChanlIds;
        @AuraEnabled public String divisionIds;
        @AuraEnabled public Integer itemNumber;
        @AuraEnabled public String deliveryDate;  // SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022
         
        public OrderItemWrapper(){
            orderItem_id = '';
            order_id = '';
            pb_id = '';
            sku_name = '';
            sku_id = '';
            uom = '';
            pack_size = 0.0;
            base_price = 0.0;
            special_discount = 0.0;
            boxes = 0.0;
            quantity = 0.0;
            net_rate = 0.0;
            net_value = 0.0;
            shipmnt_date = String.valueOf(System.today());
            inventory = 0.0;
            comment = '';
            distributionChanlIds = '';
            divisionIds = '';
            itemNumber = 0;
            deliveryDate = String.valueOf(System.today()+1); // SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022
        }
    }

    public class OrderWrapper{
        @AuraEnabled public Sales_Order__c soObj;
        @AuraEnabled public CreditSummaryWrapper creditSummary;
        @AuraEnabled public List<PriceBookDetailsWrapper> priceBookList;
        @AuraEnabled public List<OrderItemWrapper> orderItemList;
        @AuraEnabled public List<Shipping_Location__c> shippingLocationList;
        @AuraEnabled public Map<String,Shipping_Location__c> shippingMap;
        @AuraEnabled public List<DistributorSalesAreaMapping__c> orderForList;
        @AuraEnabled public PriceBookDetailsWrapper priceBookWrapper;
        @AuraEnabled public String orderFor;
        @AuraEnabled public String account_Id;
        @AuraEnabled public String ordr_id;
        @AuraEnabled public String so_id;
        @AuraEnabled public Boolean isSalesOrder;
        //@AuraEnabled public Decimal early_ordr_discount;
        @AuraEnabled public Decimal total_amount;
       // @AuraEnabled public Decimal gross_amount;
        @AuraEnabled public String uom_kg;
       // @AuraEnabled public String uom_bottle;
        @AuraEnabled public String uom_litre;
        @AuraEnabled public Decimal net_price_kg;
       // @AuraEnabled public Decimal net_price_bottle;
        @AuraEnabled public Decimal net_price_litre;
        @AuraEnabled public Decimal quantity_kg;
       // @AuraEnabled public Decimal quantity_bottle;
        @AuraEnabled public Decimal quantity_litre;
       // @AuraEnabled public String inco_term;
       // @AuraEnabled public String inco_term_id;
       // @AuraEnabled public String payment_method;
       // @AuraEnabled public String payment_method_id;
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
        @AuraEnabled public String depo_name;
       // @AuraEnabled public String Shipping_Point;
        @AuraEnabled public String Storage_Location;
        @AuraEnabled public String CurrencyCode;
        @AuraEnabled public String ownerId;
        @AuraEnabled public List<String> distributionChanlIds;
        @AuraEnabled public List<String> divisionIds;
        @AuraEnabled public Integer lastItemNumber;
       // @AuraEnabled public List<Decimal> countryWise_EOD;
       // @AuraEnabled public Boolean disable_EOD;
        @AuraEnabled public String orderRaisedBy;
        @AuraEnabled public String managerId;
        @AuraEnabled public String countryHead;
        @AuraEnabled public String businessType;
        @AuraEnabled public String businessTypeName;
        //@AuraEnabled public List<TM_Depot_Mapping__c> tmDepoList;
        @AuraEnabled public List<OrderHistory> orderHistory;
        @AuraEnabled public List<Payment_Term__c> payTermList;
        @AuraEnabled public String fileName;
        /* ------------- Start SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022 -------------------- */
        @AuraEnabled public Boolean showPODate;
        @AuraEnabled public Boolean showDeliveryDate;
        @AuraEnabled public Boolean isPORequired;
        @AuraEnabled public Boolean isDeliveryRequired;
        @AuraEnabled public String poDate;
        /* -------------End SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022 --------------------------- */    
        public OrderWrapper(){
            soObj = new Sales_Order__c();
            creditSummary = new CreditSummaryWrapper();
            priceBookList = new List<PriceBookDetailsWrapper>();
            orderItemList = new List<OrderItemWrapper>();
            shippingLocationList = new List<Shipping_Location__c>();
            shippingMap = new Map<String,Shipping_Location__c>();
            orderForList = new List<DistributorSalesAreaMapping__c>();
            priceBookWrapper = new PriceBookDetailsWrapper();
            orderFor = '';
            account_Id = '';
            ordr_id = '';
            so_id = '';
            isSalesOrder = false;
            //early_ordr_discount = 0;
            total_amount = 0.0;
            //gross_amount = 0.0;
            uom_kg = '';
            //uom_bottle = '';
            uom_litre = '';
            net_price_kg = 0.0;
            //net_price_bottle = 0.0;
            net_price_litre = 0.0;
            quantity_kg = 0.0;
            //quantity_bottle = 0.0;
            quantity_litre = 0.0;
            //inco_term = '';
            //inco_term_id = '';
            //payment_method = '';
            //payment_method_id = '';
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
            depo_name = '';
            //Shipping_Point = '';
            Storage_Location = '';
            CurrencyCode = '';
            ownerId = '';
            distributionChanlIds = new List<String>();
            divisionIds = new List<String>();
            lastItemNumber = 0;
            //countryWise_EOD = new List<Decimal>();
            //disable_EOD = false;
            orderRaisedBy = '';
            managerId = '';
            countryHead = '';
            businessType = '';
            businessTypeName = '';
            //tmDepoList = new List<TM_Depot_Mapping__c>();
            orderHistory  = new List<OrderHistory>();
            payTermList = new List<Payment_Term__c>();
            fileName = '';
            /* -------------- Start SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022 --------------------- */
            showPODate = false;
            showDeliveryDate = false;
            isPORequired = false;
            isDeliveryRequired = false;
            poDate = String.valueOf(System.today());
            /* --------------- End SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022 --------------------------------- */
        }
    }
}