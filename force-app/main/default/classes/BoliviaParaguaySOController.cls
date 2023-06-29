public without sharing class BoliviaParaguaySOController {
    
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
            SelectedCurrency = 'USD';
            
            loginUserObj = [SELECT Id, Name, Country, IsActive, Show_Inventory__c, Show_Credit_Limit__c, 
                            Show_Inventory_Column__c, Show_InTransit__c, Show_InTransit_Values__c, 
                            ProfileId,Profile.Name, ManagerId, Country_Head__c, Zonal_Manager__c, RegionalManager__c
                            FROM User WHERE Id =: UserInfo.getUserId() AND IsActive = True];
            
            if(loginUserObj != null) {
                List<Login_Country__c> logCntry = new List<Login_Country__c>();
                logCntry = [SELECT Id, Name, For_Contry__c, Sales_Org_Code__c, Delivery_Date__c, 
                            PO_Date__c, Show_Delivery_Date__c, Show_PO_Date__c FROM Login_Country__c 
                            where Name =:loginUserObj.Country limit 1];
                
                /* ------------------------SKI (Nik) : #CR152 : PO And Delivery Date : 12-07-2022 NIK SKI-------------------------------- */
                if(logCntry.size() > 0) {
                    /* if(logCntry[0].For_Contry__c == 'Bolivia'){
Sales_Org_Code = '5361';
}
else if(logCntry[0].For_Contry__c == 'Paraguay'){
Sales_Org_Code = '5441';
} */
                    Sales_Org_Code = logCntry[0].Sales_Org_Code__c;
                    orderWrap.showPODate = logCntry[0].Show_PO_Date__c;
                    orderWrap.showDeliveryDate = logCntry[0].Show_Delivery_Date__c;
                    orderWrap.isPORequired = logCntry[0].PO_Date__c;
                    orderWrap.isDeliveryRequired = logCntry[0].Delivery_Date__c;
                }
                /* ------------------------SKI (Nik) : #CR152 : PO And Delivery Date : 12-07-2022 SKI-------------------------------- */
            }         
            
            SOObj = new List<Sales_Order__c>();
            
            SOObj = [SELECT Id, Name, Bill_To_Party__c, Order_Status__c, Ship_To_Party__c, Sales_Org_lk__c, 
                     Remarks__c, PONumber__c, Purchase_Order_Date__c, Order_Type_lk__c, Depot__c, Depot__r.Name, Order_Type__c, 
                     Order_For__c, CurrencyIsoCode, Sold_to_Party__c, Ship_To_Party__r.Region__c, 
                     Ship_To_Party__r.City__c, Ship_To_Party__r.State__c, Ship_To_Party__r.Pincode__c,
                     Total_Amount__c, OwnerId, Order__c, SalesOrgCode__c, Date_of_Payment__c, Inco_Term__c, 
                     Payment_Term__c, Payment_Term__r.Payterms_Desc__c, Distribution_Channel_lk__c, Division_lk__c, 
                     Inco_Term__r.IncoTerm_Desc__c FROM Sales_Order__c WHERE Order_Status__c='Draft' 
                     AND Bill_To_Party__c =: id_val ORDER BY CreatedDate DESC LIMIT 1];
            
            if(SOObj.size()==0) {
                SOObj = [SELECT Id, Name, Bill_To_Party__c, Order_Status__c, Ship_To_Party__c, Sales_Org_lk__c, 
                         Remarks__c, PONumber__c, Purchase_Order_Date__c, Order_Type_lk__c, Depot__c, Depot__r.Name, Order_Type__c, 
                         Order_For__c, CurrencyIsoCode, Sold_to_Party__c, Ship_To_Party__r.Region__c, 
                         Ship_To_Party__r.City__c, Ship_To_Party__r.State__c, Ship_To_Party__r.Pincode__c,
                         Total_Amount__c, OwnerId, Order__c, SalesOrgCode__c, Date_of_Payment__c, Inco_Term__c, 
                         Payment_Term__c, Payment_Term__r.Payterms_Desc__c, Distribution_Channel_lk__c, Division_lk__c, 
                         Inco_Term__r.IncoTerm_Desc__c FROM Sales_Order__c WHERE Id =: id_val limit 1];
            }
            System.debug('Sales org obj... -- '+ SOObj);
            
            if(SOObj.size()==0) {
                accList = new List<Account>(); 
                accList = getAccountDetails(id_val);
                accountId = id_val;
                
                orderObj = new List<Order__c>();
                orderObj = [SELECT Id, Name, Bill_To_Party__c, Order_Status__c, Sales_Org__c, Depot__c, Depot__r.Name, 
                            Order_Type__c, PONumber__c, PO_Date__c, Remarks__c, Shipping_Location__c, Order_For__c, Date_of_Payment__c, 
                            OwnerId, Net_Amount__c, Shipping_Location__r.Region__c, Shipping_Location__r.City__c, Type_of_Order__c,  
                            Shipping_Location__r.State__c, Shipping_Location__r.Pincode__c, Sales_Org__r.Sales_Org_Code__c, 
                            Inco_Term__c, Inco_Term__r.IncoTerm_Desc__c FROM Order__c WHERE Order_Status__c='Draft' AND 
                            Bill_To_Party__c =:id_val ORDER BY CreatedDate DESC LIMIT 1];
                                
                orderWrap.payment_term = accList[0].Payment_Term_Code__r.Payterms_Desc__c;
                orderWrap.payment_term_id = accList[0].Payment_Term_Code__c;
                
                if(orderObj.size()<=0) {
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
                    orderWrap.ownerId = ordObj2.OwnerId;
                    orderWrap.so_id = '';
                    orderWrap.shipping_loc = '';
                    orderWrap.payment_date = String.valueOf(System.today());
                } else {
                    atchmnt = [SELECT Id, ParentId, Name, ContentType, Body FROM Attachment 
                               WHERE ParentId =: orderObj[0].Id ORDER BY LastModifiedDate DESC LIMIT 1];
                    
                    //Sales_Org_Code = orderObj[0].Sales_Org__r.Sales_Org_Code__c;
                    orderWrap.isSalesOrder = false;
                    orderWrap.ordr_id = orderObj[0].Id;
                    orderWrap.status = orderObj[0].Order_Status__c;
                    orderWrap.ownerId = orderObj[0].OwnerId;
                    
                    if(orderObj[0].Shipping_Location__c == null) {
                        orderWrap.shipping_loc = '';
                    } else {
                        orderWrap.shipping_loc = orderObj[0].Shipping_Location__c;
                    }
                    
                    orderWrap.so_id = '';
                    
                    if(orderObj[0].Shipping_Location__r.Region__c != null) {
                        orderWrap.shipping_loc_details = orderObj[0].Shipping_Location__r.Region__c;
                    }
                    
                    if(orderObj[0].Shipping_Location__r.City__c != null) {                         
                        orderWrap.shipping_loc_details = orderWrap.shipping_loc_details + ', ' + orderObj[0].Shipping_Location__r.City__c;
                    }
                    
                    if(orderObj[0].Shipping_Location__r.State__c != null) {
                        orderWrap.shipping_loc_details = orderWrap.shipping_loc_details + ', ' + orderObj[0].Shipping_Location__r.State__c;
                    }
                    
                    if(orderObj[0].Shipping_Location__r.Pincode__c != null) {
                        orderWrap.shipping_loc_details = orderWrap.shipping_loc_details + ', ' + orderObj[0].Shipping_Location__r.Pincode__c;
                    }
                    
                    if(orderObj[0].Order_For__c == null) {
                        orderWrap.orderFor = '';
                    } else {
                        orderWrap.orderFor = orderObj[0].Order_For__c;
                    }
                    
                    if(orderObj[0].Date_of_Payment__c != null) {
                        orderWrap.payment_date = String.valueOf(orderObj[0].Date_of_Payment__c);
                    }
                    
                    orderWrap.po_no = orderObj[0].PONumber__c;
                    /* ------------------------SKI (Nik) : #CR152 : PO And Delivery Date : 12-07-2022 NIK SKI-------------------------------- */
                    if(orderObj[0].PO_Date__c != null) {                 
                        orderWrap.poDate = String.valueOf(orderObj[0].PO_Date__c);
                    }
                    /* else {	// SKI (Nik) : #CR152 : PO And Delivery Date : 08-02-2022...
orderWrap.poDate = '';	
} */
                    /* ------------------------SKI (Nik) : #CR152 : PO And Delivery Date : 12-07-2022 SKI-------------------------------- */
                    
                    orderWrap.remark = orderObj[0].Remarks__c;
                    orderWrap.total_amount = orderObj[0].Net_Amount__c.setScale(2);
                    orderWrap.order_typ = orderObj[0].Type_of_Order__c;
                    
                    if(orderObj[0].Depot__c != null) {
                        orderWrap.depo_name = orderObj[0].Depot__r.Name;  
                        orderWrap.Depo_Obj = orderObj[0].Depot__c; 
                    }
                    
                    List<OrderLineItem__c> orderItems = new List<OrderLineItem__c>();
                    orderItems = [SELECT Id, Name, Net_Price__c, No_of_Case__c, Date_of_Payment__c, 
                                  Order__c, Price__c, Quantity__c, Delivery_Date__c, SKU_Name__c, SKU_Name__r.Name, 
                                  SKU_Name__r.SKU_Description__c,SKU_Name__r.Multiple_of__c, UOM__c, MaxPrice__c, 
                                  MinPrice__c, Price_Book_Master__c, Distribution_Channel__c, Division__c, 
                                  Item_Number__c FROM OrderLineItem__c WHERE Order__c =: orderObj[0].Id];
                    
                    if(orderItems.size()>0) {
                        for(OrderLineItem__c ordItem : orderItems) {
                            OrderItemWrapper itemWrap = new OrderItemWrapper();
                            itemWrap.orderItem_id = ordItem.Id;
                            itemWrap.order_id = ordItem.Order__c;
                            itemWrap.pb_id = ordItem.Price_Book_Master__c;
                            itemWrap.sku_name = ordItem.SKU_Name__r.SKU_Description__c;
                            itemWrap.sku_id = ordItem.SKU_Name__c;
                            itemWrap.uom = ordItem.UOM__c;
                            itemWrap.max_price = ordItem.MaxPrice__c;
                            itemWrap.min_price = ordItem.MinPrice__c;
                            itemWrap.final_price = ordItem.Price__c;
                            itemWrap.net_price = ordItem.Net_Price__c;
                            itemWrap.quantity = ordItem.Quantity__c;
                            
                            /* ------------------------SKI (Nik) : #CR152 : PO And Delivery Date : 12-07-2022 NIK SKI-------------------------------- */
                            if(ordItem.Delivery_Date__c == null) {
                                itemWrap.deliveryDate = '';
                            } else {
                                itemWrap.deliveryDate = String.valueOf(ordItem.Delivery_Date__c);
                            }
                            /* ------------------------SKI (Nik) : #CR152 : PO And Delivery Date : 12-07-2022 SKI-------------------------------- */
                            
                            if(ordItem.SKU_Name__r.Multiple_of__c == null) {
                                itemWrap.multiple_of = 0;
                            } else {
                                itemWrap.multiple_of = ordItem.SKU_Name__r.Multiple_of__c;
                            }
                            
                            itemWrap.payment_date = String.valueOf(ordItem.Date_of_Payment__c);
                            //itemWrap.inventory = ordItem.;
                            itemWrap.distributionChanlIds = ordItem.Distribution_Channel__c;
                            itemWrap.divisionIds = ordItem.Division__c;
                            itemWrap.itemNumber = Integer.ValueOf(ordItem.Item_Number__c);
                            
                            if(ordItem.UOM__c.toUpperCase() == 'KG') {
                                orderWrap.quantity_kg = orderWrap.quantity_kg + ordItem.Quantity__c;
                                orderWrap.net_price_kg = (orderWrap.net_price_kg + ordItem.Price__c).setScale(2);
                                //orderWrap.net_price_kg = (orderWrap.net_price_kg + ordItem.Price__c).setScale(2);
                            } else if(ordItem.UOM__c.toUpperCase() == 'L') {
                                orderWrap.quantity_litre = orderWrap.quantity_litre + ordItem.Quantity__c;
                                orderWrap.net_price_litre = (orderWrap.net_price_litre + ordItem.Price__c).setScale(2);
                                //orderWrap.net_price_litre = (orderWrap.net_price_litre + ordItem.Price__c).setScale(2);
                            } else if(ordItem.UOM__c.toUpperCase() == 'Each') {
                                orderWrap.quantity_each = orderWrap.quantity_each + ordItem.Quantity__c;
                                orderWrap.net_price_each = (orderWrap.net_price_each + ordItem.Price__c).setScale(2);
                                //orderWrap.net_price_litre = (orderWrap.net_price_litre + ordItem.Price__c).setScale(2);
                            }
                            
                            if(Integer.ValueOf(ordItem.Item_Number__c) > orderWrap.lastItemNumber) {
                                orderWrap.lastItemNumber = Integer.ValueOf(ordItem.Item_Number__c);
                            }
                            
                            orderItemList.add(itemWrap);
                        }
                    }              
                }
            } else {
                atchmnt = [SELECT Id, ParentId, Name, ContentType, Body FROM Attachment 
                           WHERE ParentId =: SOObj[0].Id ORDER BY LastModifiedDate DESC LIMIT 1];
                
                accountId = SOObj[0].Bill_To_Party__c;
                accList = new List<Account>(); 
                accList = getAccountDetails(accountId);
                //Sales_Org_Code = SOObj[0].SalesOrgCode__c;
                orderWrap.status = SOObj[0].Order_Status__c;
                orderWrap.isSalesOrder = true;
                orderWrap.so_id = SOObj[0].Id;
                orderWrap.ordr_id = SOObj[0].Order__c;
                orderWrap.status = SOObj[0].Order_Status__c;
                orderWrap.ownerId = SOObj[0].OwnerId;
                orderWrap.payment_date = String.valueOf(SOObj[0].Date_of_Payment__c);
                orderWrap.shipping_loc = SOObj[0].Ship_To_Party__c;
                
                if(SOObj[0].Ship_To_Party__r.Region__c != null) {
                    orderWrap.shipping_loc_details = SOObj[0].Ship_To_Party__r.Region__c;
                }
                
                if(SOObj[0].Ship_To_Party__r.City__c != null) {                         
                    orderWrap.shipping_loc_details = orderWrap.shipping_loc_details + ', ' + SOObj[0].Ship_To_Party__r.City__c;
                }
                
                if(SOObj[0].Ship_To_Party__r.State__c != null) {
                    orderWrap.shipping_loc_details = orderWrap.shipping_loc_details + ', ' + SOObj[0].Ship_To_Party__r.State__c;
                }
                
                if(SOObj[0].Ship_To_Party__r.Pincode__c != null) {
                    orderWrap.shipping_loc_details = orderWrap.shipping_loc_details + ', ' + SOObj[0].Ship_To_Party__r.Pincode__c;
                }
                
                orderWrap.orderFor = SOObj[0].Order_For__c;
                orderWrap.po_no = SOObj[0].PONumber__c;
                
                /* ------------------------SKI (Nik) : #CR152 : PO And Delivery Date : 12-07-2022 NIK SKI-------------------------------- */
                if(SOObj[0].Purchase_Order_Date__c != null) {
                    orderWrap.poDate = String.valueOf(SOObj[0].Purchase_Order_Date__c);
                }
                /* else {	// SKI (Nik) : #CR152 : PO And Delivery Date : 02-08-2022...
orderWrap.poDate = '';	
} */
                /* ------------------------SKI (Nik) : #CR152 : PO And Delivery Date : 12-07-2022 SKI-------------------------------- */
                
                orderWrap.remark = SOObj[0].Remarks__c;
                orderWrap.total_amount = SOObj[0].Total_Amount__c.setScale(2);
                orderWrap.CurrencyCode = SOObj[0].CurrencyIsoCode;
                orderWrap.salesOrgObj = SOObj[0].Sales_Org_lk__c;
                orderWrap.Order_Type = SOObj[0].Order_Type_lk__c;
                orderWrap.order_typ = SOObj[0].Order_Type__c;
                
                if(SOObj[0].Depot__c != null) {
                    orderWrap.depo_name = SOObj[0].Depot__r.Name;  
                    orderWrap.Depo_Obj = SOObj[0].Depot__c; 
                }
                
                if(SOObj[0].Payment_Term__c == null) {
                    orderWrap.payment_term = '';
                    orderWrap.payment_term_id = '';
                } else {
                    orderWrap.payment_term = SOObj[0].Payment_Term__r.Payterms_Desc__c;
                    orderWrap.payment_term_id = SOObj[0].Payment_Term__c;
                }
                
                if(SOObj[0].Inco_Term__c == null) {
                    orderWrap.inco_term = '';
                    orderWrap.inco_term_id = '';
                } else {
                    orderWrap.inco_term = SOObj[0].Inco_Term__r.IncoTerm_Desc__c;
                    orderWrap.inco_term_id = SOObj[0].Inco_Term__c;
                }
                
                List<String> divIds = new List<String>();
                List<String> disIds = new List<String>();
                
                List<Sales_Order_Line_Item__c> orderItems = new List<Sales_Order_Line_Item__c>();
                orderItems = [SELECT Id, Name, SKU_Name__c, SKU_Name__r.Name, DepotDepot__c, SKU_Name__r.SKU_Description__c,
                              Storage_Location__c, UOM__c, CurrencyIsoCode, SKU_Name__r.Multiple_of__c, 
                              Net_Price__c, Quantity__c, Price__c, Sale_Order__c, Delivery_Date__c, 
                              PriceBookMaster__c, MaxPrice__c, MinPrice__c, Date_of_Payment__c,
                              Distribution_Channel__c, Division__c, Item_Number__c
                              FROM Sales_Order_Line_Item__c WHERE Sale_Order__c =: SOObj[0].Id];
                
                if(orderItems.size()>0) {                    
                    for(Sales_Order_Line_Item__c ordItem : orderItems) {
                        OrderItemWrapper itemWrap = new OrderItemWrapper();
                        itemWrap.orderItem_id = ordItem.Id;
                        itemWrap.order_id = ordItem.Sale_Order__c;
                        itemWrap.pb_id = ordItem.PriceBookMaster__c;
                        itemWrap.sku_name = ordItem.SKU_Name__r.SKU_Description__c;
                        itemWrap.sku_id = ordItem.SKU_Name__c;
                        itemWrap.uom = ordItem.UOM__c;
                        itemWrap.payment_date = String.valueOf(ordItem.Date_of_Payment__c);
                        itemWrap.max_price = ordItem.MaxPrice__c;
                        itemWrap.min_price = ordItem.MinPrice__c;
                        itemWrap.net_price = ordItem.Net_Price__c;
                        itemWrap.final_price = ordItem.Price__c;
                        itemWrap.quantity = ordItem.Quantity__c;
                        
                        /* ------------------------SKI (Nik) : #CR152 : PO And Delivery Date : 12-07-2022 NIK SKI-------------------------------- */
                        if(ordItem.Delivery_Date__c != null) {
                            itemWrap.deliveryDate = String.valueOf(ordItem.Delivery_Date__c);
                        } else {
                            itemWrap.deliveryDate = '';
                        }
                        /* ------------------------SKI (Nik) : #CR152 : PO And Delivery Date : 12-07-2022 SKI-------------------------------- */
                        
                        if(ordItem.SKU_Name__r.Multiple_of__c == null) {
                            itemWrap.multiple_of = 0;
                        } else {
                            itemWrap.multiple_of = ordItem.SKU_Name__r.Multiple_of__c;
                        }
                        
                        itemWrap.distributionChanlIds = ordItem.Distribution_Channel__c;
                        itemWrap.divisionIds = ordItem.Division__c;
                        itemWrap.itemNumber = Integer.valueOf(ordItem.Item_Number__c);                           
                        
                        if(ordItem.UOM__c.toUpperCase() == 'KG') {
                            orderWrap.quantity_kg = orderWrap.quantity_kg + ordItem.Quantity__c;
                            //orderWrap.net_price_kg = (orderWrap.net_price_kg + ordItem.Net_Price__c).setScale(2);
                            orderWrap.net_price_kg = (orderWrap.net_price_kg + ordItem.Price__c).setScale(2);
                        } else if(ordItem.UOM__c.toUpperCase() == 'L') {
                            orderWrap.quantity_litre = orderWrap.quantity_litre + ordItem.Quantity__c;
                            //orderWrap.net_price_litre = (orderWrap.net_price_litre + ordItem.Net_Price__c).setScale(2);
                            orderWrap.net_price_litre = (orderWrap.net_price_litre + ordItem.Price__c).setScale(2);
                        } else if(ordItem.UOM__c.toUpperCase() == 'Each') {
                            orderWrap.quantity_each = orderWrap.quantity_each + ordItem.Quantity__c;
                            //orderWrap.net_price_litre = (orderWrap.net_price_litre + ordItem.Net_Price__c).setScale(2);
                            orderWrap.net_price_each = (orderWrap.net_price_each + ordItem.Price__c).setScale(2);
                        }
                        
                        if(Integer.ValueOf(ordItem.Item_Number__c) > orderWrap.lastItemNumber) {
                            orderWrap.lastItemNumber = Integer.ValueOf(ordItem.Item_Number__c);
                        }
                        
                        orderItemList.add(itemWrap);
                        System.debug('orderItemList --> ' + orderItemList);
                        divIds.add(ordItem.Division__c);
                        disIds.add(ordItem.Distribution_Channel__c);
                        orderWrap.Storage_Location = ordItem.Storage_Location__c;
                    }
                } else {
                    if(SOObj[0].Division_lk__c != null) {
                        divIds.add(SOObj[0].Division_lk__c);
                    }
                    
                    if(SOObj[0].Distribution_Channel_lk__c != null) {
                        disIds.add(SOObj[0].Distribution_Channel_lk__c);
                    }                       
                }
                //System.debug('disIds  : ' + disIds);
                
                orderWrap.distributionChanlIds = disIds;
                orderWrap.divisionIds = divIds;
            }
            
            OrderForWrapper orderFor2 = new OrderForWrapper();
            orderFor2 = setOrderFor(Sales_Org_Code);
            orderWrap.orderForWrapper = orderFor2;
            
            if(orderWrap.Storage_Location == '' || orderWrap.Storage_Location == null) {
                orderWrap.Storage_Location = orderFor2.Storage_Location.Id;
            }            
            
            if(orderFor2.paymentTermList.size()>0) {
                orderWrap.payTermList = orderFor2.paymentTermList;
            }
            
            if((orderWrap.inco_term_id == null || orderWrap.inco_term_id == '') && orderFor2.incoTerm != null) {
                orderWrap.inco_term_id = orderFor2.incoTerm.id;
            }
            
            if(orderWrap.distributionChanlIds.size() == 0) {
                orderWrap.distributionChanlIds = orderFor2.distributionChanlIds;
            }
            
            if(orderWrap.divisionIds.size() == 0) {
                orderWrap.divisionIds = orderFor2.divisionIds;
            }
            
            if(orderWrap.salesOrgObj == null || orderWrap.salesOrgObj == '') {
                orderWrap.salesOrgObj = orderFor2.salesOrgObj.id;
            }
            
            if(orderWrap.Depo_Obj == null || orderWrap.Depo_Obj == '') {
                orderWrap.depo_name = orderFor2.Depo_Obj.Name;
                orderWrap.Depo_Obj = orderFor2.Depo_Obj.id;
            }
            
            if(orderWrap.Order_Type == null || orderWrap.Order_Type == '') {
                orderWrap.Order_Type = orderFor2.Order_Type.id;
            }
            
            if(orderItemList.size()>0 && Sales_Org_Code != '') {
                List<String> idList = new List<String>();
                
                for(OrderItemWrapper oiw : orderItemList) {
                    if(oiw.sku_id != '' || oiw.sku_id != null) {
                        idList.add(oiw.sku_id);
                    }
                }
                
                if(orderWrap.Depo_Obj != null || orderWrap.Depo_Obj != '') {
                    Map<String,Decimal> inventoryMap = new Map<String,Decimal>();
                    inventoryMap = getInventory(idList,Sales_Org_Code,orderWrap.Depo_Obj);
                    
                    if(inventoryMap.size()>0) {
                        for(OrderItemWrapper itemW : orderItemList) {
                            if(inventoryMap.containsKey(itemW.sku_id)) {
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
            
            if(shippingLocationList.size()>0) {
                shippingMap = new Map<String,Shipping_Location__c>();               // for shipping location map..
                for(Shipping_Location__c shipAdr : shippingLocationList) {
                    if(!shippingMap.containsKey(shipAdr.id)) {
                        if(shipAdr.Billing_Street_1__c == null || shipAdr.Billing_Street_1__c == '') {
                            shipAdr.Billing_Street_1__c = 'None';
                        } else {
                            shipAdr.Billing_Street_1__c = shipAdr.Billing_Street_1__c;
                        }
                        
                        if(shipAdr.Billing_Street_2__c == null || shipAdr.Billing_Street_2__c == '') {
                            shipAdr.Billing_Street_2__c = 'None';
                        } else {
                            shipAdr.Billing_Street_2__c = shipAdr.Billing_Street_2__c;
                        }
                        
                        if(shipAdr.Billing_Street_3__c == null || shipAdr.Billing_Street_3__c == '') {
                            shipAdr.Billing_Street_3__c = 'None';
                        } else {
                            shipAdr.Billing_Street_3__c = shipAdr.Billing_Street_3__c;
                        } 
                        
                        if(shipAdr.Billing_Street_4__c == null || shipAdr.Billing_Street_4__c == '') {
                            shipAdr.Billing_Street_4__c = 'None';
                        } else {
                            shipAdr.Billing_Street_4__c = shipAdr.Billing_Street_4__c;
                        } 
                        
                        if(shipAdr.Billing_Street_5__c == null || shipAdr.Billing_Street_5__c == '') {
                            shipAdr.Billing_Street_5__c = 'None';
                        } else {
                            shipAdr.Billing_Street_5__c = shipAdr.Billing_Street_5__c;
                        }
                        
                        if(shipAdr.Billing_Street_6__c == null || shipAdr.Billing_Street_6__c == '') {
                            shipAdr.Billing_Street_6__c = 'None';
                        } else {
                            shipAdr.Billing_Street_6__c = shipAdr.Billing_Street_6__c;
                        }
                        
                        if(shipAdr.Region__c == null || shipAdr.Region__c == '') {
                            shipAdr.Region__c = 'None';
                        } else {
                            shipAdr.Region__c = shipAdr.Region__c;
                        }
                        
                        if(shipAdr.Country_Name__c == null || shipAdr.Country_Name__c == '') { // country name field is used for refence as City name..
                            shipAdr.Country_Name__c = 'None';
                        } else {
                            shipAdr.Country_Name__c = shipAdr.Country_Name__c;
                        }
                        
                        if(shipAdr.State__c == null || shipAdr.State__c == '') {
                            shipAdr.State__c = 'None';
                        } else {
                            shipAdr.State__c = shipAdr.State__c;
                        }
                        
                        if(shipAdr.Pincode__c == null || shipAdr.Pincode__c == '') {
                            shipAdr.Pincode__c = 'None';
                        } else {
                            shipAdr.Pincode__c = shipAdr.Pincode__c;
                        }
                        
                        if(shipAdr.Country__c == null || shipAdr.Country__c == '') {
                            shipAdr.Country__c = 'None';
                        } else {
                            shipAdr.Country__c = shipAdr.Country__c;
                        }
                        
                        shippingMap.put(shipAdr.id,shipAdr);
                    }
                }
                
                Shipping_Location__c shipLoc = new Shipping_Location__c();   // for shipping location Same as billing address..
                Boolean flag = false;
                
                for(Shipping_Location__c shpLoc : shippingLocationList) {
                    if(shpLoc.SAP_Code__c == accList[0].SAP_Code__c) {
                        shipLoc = shpLoc;
                        shipLoc.Country_Name__c = shipLoc.City__c;
                        shipLoc.City__c = System.Label.same_as_billing_address;
                        flag = true;
                    } else {
                        shipLoc.Country_Name__c = shipLoc.City__c;
                        shpLoc.City__c = shpLoc.Location_Name__c +'-'+ shpLoc.City__c;
                    }
                }
                
                if(flag == true) {
                    shippingLocationList.set(0,shipLoc);
                }
            }
            
            csWrap.sap_code = accList[0].SAP_Code__c; 
            csWrap.account_name = accList[0].name;
            
            List<Credit_Info__c> ciList = new List<Credit_Info__c>();
            ciList = [SELECT id, name,Distributor__c,distributor__r.name, Credit_Limit__c,
                      Balance_Limit__c,Used_Limit__c, Internal_Limit__c, Sum_Open_Item__c, 
                      DAYS_ARREARS__c FROM Credit_Info__c WHERE Distributor__c =:accountId LIMIT 1];
            
            if(ciList.size()>0) {
                csWrap.total_credit_limit = ciList[0].Credit_Limit__c;
                csWrap.internal_credit_limit = ciList[0].Internal_Limit__c;
                csWrap.credit_limit_used = ciList[0].Used_Limit__c;
                csWrap.credit_limit_balance = ciList[0].Balance_Limit__c;
            } 
            
            List<Outstanding_Ageing__c> oagList = new List<Outstanding_Ageing__c>();                              
            oagList = [SELECT id, OutstandingTotalGreaterthan90__c, Net_Outstanding__c
                       FROM Outstanding_Ageing__c WHERE Customer_Code__c =:accountId LIMIT 1];
            
            if(oagList.size()>0) {
                csWrap.total_outstanding = oagList[0].Net_Outstanding__c;
            }
            
            List<Payments__c> payList = new List<Payments__c>();
            payList = [SELECT id, Net_Overdue__c FROM Payments__c WHERE Customer_Name__c =:accountId LIMIT 1];
            
            if(payList.size()>0) {
                csWrap.net_overdue = payList[0].Net_Overdue__c;
            }
            
            orderForList = new List<DistributorSalesAreaMapping__c>();
            
            if(loginUserObj.Profile.Name == 'Bolivia & Paraguay Sales Representative') {
                orderForList = [SELECT Id, Name, Distributor__c, SalesOrg__c, SalesOrg__r.Name, Sales_Org_Code__c,  
                                AccountOwner__c FROM DistributorSalesAreaMapping__c where Distributor__c =: accountId AND
                                AccountOwner__c =: loginUserObj.Id AND Sales_Org_Code__c =: Sales_Org_Code 
                                ORDER BY LastModifiedDate DESC LIMIT 1];
            } else {
                orderForList = [SELECT Id, Name, Distributor__c, SalesOrg__c, SalesOrg__r.Name, Sales_Org_Code__c,  
                                AccountOwner__c FROM DistributorSalesAreaMapping__c where Distributor__c =: accountId AND
                                Sales_Org_Code__c =: Sales_Org_Code ORDER BY LastModifiedDate DESC LIMIT 1];
            }
            
            if(orderForList.size()>0) {
                Map<String,DistributorSalesAreaMapping__c> myMap = new Map<String,DistributorSalesAreaMapping__c>();
                
                for(DistributorSalesAreaMapping__c dsap : orderForList) {
                    if(!myMap.containsKey(dsap.SalesOrg__r.Name)) {
                        myMap.put(dsap.SalesOrg__r.Name,dsap);
                    }
                }
                
                if(myMap.size()>0) {
                    orderForList = new List<DistributorSalesAreaMapping__c>();
                    orderForList = myMap.values();
                }
            }
            
            if(loginUserObj.Profile.Name == 'Bolivia & Paraguay Sales Representative' || loginUserObj.Profile.Name == 'Bolivia & Paraguay Customer Service') {
                orderWrap.orderRaisedBy = 'Territory Manager';
            }
            
            if(loginUserObj.Profile.Name == 'Bolivia & Paraguay Customer Service') {
                orderWrap.isCustomerService = true;
            }
            /* if(loginUserObj.ManagerId != null){
orderWrap.managerId = loginUserObj.ManagerId;
}

if(loginUserObj.Country_Head__c != null){
orderWrap.countryHead = loginUserObj.Country_Head__c;
} */
            
            if(orderWrap.order_typ == null || orderWrap.order_typ == '') {
                orderWrap.order_typ = 'Regular';
            }
            
            orderWrap.CurrencyCode = SelectedCurrency;
            orderWrap.account_Id = accountId;           
            orderWrap.orderForList = orderForList;
            
            orderWrap.shippingMap = shippingMap;
            orderWrap.creditSummary = csWrap;
            orderWrap.shippingLocationList = shippingLocationList;
            PriceBookDetailsWrapper priceBookW = new PriceBookDetailsWrapper();
            orderWrap.priceBookWrapper = priceBookW;
            orderWrap.orderItemList = orderItemList;
            
            if(atchmnt.size()>0) {
                orderWrap.fileName = atchmnt[0].Name;
            }
            
            Schema.DescribeFieldResult fieldResult3 = Sales_Order__c.Order_Type__c.getDescribe();
            List<Schema.PicklistEntry> ple3 = fieldResult3.getPicklistValues();
            
            if(ple3.size()>0) {
                Map<String,String> orderTypMap = new Map<String,String>();
                for(Schema.PicklistEntry f3 : ple3) {
                    orderTypMap.put(f3.getLabel(),f3.getValue());
                }
                orderWrap.orderTypMap = orderTypMap;
            }
        }
        catch(Exception ex){
            System.debug('Exception in getOrderDetails method : ' + ex);
            System.debug('Exception is : ' + ex);
            System.debug('Exception Line No : ' + ex.getLineNumber());
        }
        
        System.debug('orderWrap is : ' + orderWrap);
        return orderWrap;
    }
    
    @AuraEnabled   
    public static OrderForWrapper setOrderFor(String org_code) {
        OrderForWrapper orderFor = new OrderForWrapper();
        Sales_Org__c salesOrgObj = new Sales_Org__c();
        List<Distribution_Channel__c> Distribution_ChnlList = new List<Distribution_Channel__c>();
        List<Division__c> Division_List = new List<Division__c>();
        Order_Type__c Order_Type = new Order_Type__c();
        
        Depot__c Depo_Obj = new Depot__c();
        //Depot__c Shipping_Point = new Depot__c();
        Depot__c Storage_Location = new Depot__c();
        List<String> distributionChanlIds = new List<String>();
        List<String> divisionIds = new List<String>();
        List<Payment_Term__c> paymentTermList = new List<Payment_Term__c>();
        List<Inco_Term__c> incoTerm = new List<Inco_Term__c>();
        //List<Depot__c> depoList = new List<Depot__c>();
        String combky = ''; 
        String combky2 = ''; 
        String incoComb = '';
        
        try {        
            if(org_code == '5361') {
                //  salesOrgObj = new Sales_Org__c();
                salesOrgObj = [SELECT Id, Name, Description__c, Sales_Org_Code__c FROM Sales_Org__c 
                               where Sales_Org_Code__c =: org_code LIMIT 1];
                
                //  Order_Type = new Order_Type__c();
                Order_Type = [SELECT Id, Name, Description__c, Order_Type_Code__c, SalesOrg__c, Division__c 
                              FROM Order_Type__c where Order_Type_Code__c = 'ZZOR' AND Combination_Key__c='536110ZZOR' LIMIT 1];
                
                //  Storage_Location = new Depot__c();
                Storage_Location = [SELECT Id, Name, Depot_Code__c, SalesOrg__c, Plant_Desc__c, Active__c, Depot__c, 
                                    SalesOrg__r.Sales_org_code__c, Shipping_Point__c, RecordType.Name FROM Depot__c 
                                    where Depot_Code__c = 'MAIN' AND RecordType.Name='Storage Location' LIMIT 1];
                
                Distribution_ChnlList = [SELECT Id, Name, Description__c, Distribution_Channel_Code__c, Sales_Org__c 
                                         FROM Distribution_Channel__c where Distribution_Channel_Code__c IN ('20')];
                
                if(Distribution_ChnlList.size()>0) {
                    for(Distribution_Channel__c dcl : Distribution_ChnlList) {
                        distributionChanlIds.add(dcl.Id);
                    }
                }
                
                Division_List = [SELECT Id, Name, Description__c, Division_Code__c FROM Division__c 
                                 where Division_Code__c IN ('10')];
                
                if(Division_List.size()>0) {
                    for(Division__c dvsn : Division_List) {
                        divisionIds.add(dvsn.Id);
                    }
                }
                
                // Depo_Obj = new Depot__c();
                Depo_Obj = [SELECT Id, Name, Depot_Code__c, SalesOrg__c, Plant_Desc__c, Active__c, Depot__c 
                            FROM Depot__c where Depot_Code__c = 'BO00' 
                            AND SalesOrg__r.Sales_Org_Code__c =: org_code LIMIT 1];    
                
                combky = org_code+'LIB1'; 
                combky2 = org_code+'0015';  
                
                paymentTermList = [SELECT Id, Name, Payment_Term_Code__c, Payment_Term__c, Sales_Org__c, 
                                   Payterms_Desc__c, Active__c, SalesOrgCode__c, CombinationKey__c 
                                   FROM Payment_Term__c WHERE SalesOrgCode__c =: org_code AND Active__c = true 
                                   AND CombinationKey__c IN (:combky,:combky2)];
                
                incoComb = org_code+'CIF';                   
                incoTerm = [SELECT Id, Name, IncoTerm_Code__c, IncoTerm_Desc__c, Active__c, Sales_Org__c, 
                            Distribution_Channel__c, Division__c, Combination_Key__c FROM Inco_Term__c 
                            WHERE Active__c = true AND Combination_Key__c =: incoComb LIMIT 1];
                
            } else if(org_code == '5441') {
                // salesOrgObj = new Sales_Org__c();
                salesOrgObj = [SELECT Id, Name, Description__c, Sales_Org_Code__c FROM Sales_Org__c 
                               where Sales_Org_Code__c =: org_code LIMIT 1];
                
                // Order_Type = new Order_Type__c();
                Order_Type = [SELECT Id, Name, Description__c, Order_Type_Code__c, SalesOrg__c, Division__c 
                              FROM Order_Type__c where Order_Type_Code__c = 'ZZOR' AND Combination_Key__c='544110ZZOR' LIMIT 1];
                
                // Storage_Location = new Depot__c();
                Storage_Location = [SELECT Id, Name, Depot_Code__c, SalesOrg__c, Plant_Desc__c, Active__c, Depot__c, 
                                    SalesOrg__r.Sales_org_code__c, Shipping_Point__c, RecordType.Name FROM Depot__c 
                                    where Depot_Code__c = 'MAIN' AND RecordType.Name='Storage Location' LIMIT 1];
                
                Distribution_ChnlList = [SELECT Id, Name, Description__c, Distribution_Channel_Code__c, Sales_Org__c 
                                         FROM Distribution_Channel__c where Distribution_Channel_Code__c IN ('20')];
                
                if(Distribution_ChnlList.size()>0) {
                    for(Distribution_Channel__c dcl : Distribution_ChnlList) {
                        distributionChanlIds.add(dcl.Id);
                    }
                }
                
                Division_List = [SELECT Id, Name, Description__c, Division_Code__c FROM Division__c 
                                 where Division_Code__c IN ('10')];
                
                if(Division_List.size()>0) {
                    for(Division__c dvsn : Division_List) {
                        divisionIds.add(dvsn.Id);
                    }
                }
                
                // Depo_Obj = new Depot__c();
                Depo_Obj = [SELECT Id, Name, Depot_Code__c, SalesOrg__c, Plant_Desc__c, Active__c, Depot__c 
                            FROM Depot__c where Depot_Code__c = 'PY01' 
                            AND SalesOrg__r.Sales_Org_Code__c =: org_code LIMIT 1];   
                
                combky = org_code+'LIB1';             
                
                paymentTermList = [SELECT Id, Name, Payment_Term_Code__c, Payment_Term__c, Sales_Org__c, 
                                   Payterms_Desc__c, Active__c, SalesOrgCode__c, CombinationKey__c 
                                   FROM Payment_Term__c WHERE SalesOrgCode__c =: org_code AND Active__c = true 
                                   AND CombinationKey__c IN (:combky)];
                
                incoComb = org_code+'CIF';                   
                incoTerm = [SELECT Id, Name, IncoTerm_Code__c, IncoTerm_Desc__c, Active__c, Sales_Org__c, 
                            Distribution_Channel__c, Division__c, Combination_Key__c FROM Inco_Term__c 
                            WHERE Active__c = true AND Combination_Key__c =: incoComb LIMIT 1];
            } else {
                orderFor.error = true;
            }
            
            orderFor.salesOrgObj = salesOrgObj;
            orderFor.Order_Type = Order_Type;
            orderFor.Depo_Obj = Depo_Obj;
            //orderFor.Shipping_Point = Shipping_Point;
            orderFor.Storage_Location = Storage_Location;
            orderFor.distributionChanlIds = distributionChanlIds;
            orderFor.divisionIds = divisionIds;
            orderFor.paymentTermList = paymentTermList;
            
            if(incoTerm.size()>0) {
                orderFor.incoTerm = incoTerm[0];
            }
            //orderFor.tmDepoList = depoList;
        }
        catch(Exception ex){
            System.debug('Exception in setOrderFor method : ' + ex);
            System.debug('Exception is : ' + ex);
            System.debug('Exception Line No : ' + ex.getLineNumber());
        }
        
        return orderFor;
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
        
        if(prntId.size()>0) {
            for(Integer i=0; i<prntId.size(); i++) {
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
    
    public static List<Account> getAccountDetails(String acc_id) {
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
    
    public static Map<String,Decimal> getInventory(List<String> skuId, String salesOrg, String depoId) {
        Map<String,Decimal> stockReq = new  Map<String,Decimal>();        
        Map<String, Decimal> soMap = new Map<String, Decimal>();
        Map<String, Decimal> srMap = new Map<String, Decimal>();
        List<Sales_Order_Line_Item__c> solList = new List<Sales_Order_Line_Item__c>();
        
        solList = [Select Id,Name,SKU_Name__c, Quantity__c, Sale_Order__r.Depot__c from Sales_Order_Line_Item__c
                   WHERE SKU_Name__c IN: skuId AND Sale_Order__r.Order_Status__c='Pending'
                   AND Sale_Order__r.SalesOrgCode__c=: salesOrg AND Sale_Order__r.Depot__c =: depoId]; 
        
        if(solList.size()>0) {
            for(Sales_Order_Line_Item__c obj:solList) {
                if(soMap.containsKey(obj.SKU_Name__c)) {
                    Decimal val = soMap.get(obj.SKU_Name__c);
                    Decimal val2 = val + obj.Quantity__c;
                    soMap.put(obj.SKU_Name__c,val2);
                } else {
                    soMap.put(obj.SKU_Name__c,obj.Quantity__c);
                }
            }
        }
        
        List<Stock_Requirement__c> stList = new List<Stock_Requirement__c>();
        stList = [SELECT Id,Available_Stock__c,SKU__c, Depot__c FROM Stock_Requirement__c 
                  WHERE SKU__c IN: skuId AND Depot__c =: depoId];
        
        if(stList.size()>0) {
            for(Stock_Requirement__c sr : stList) {
                if(srMap.containsKey(sr.SKU__c)) {
                    Decimal val = srMap.get(sr.SKU__c);
                    Decimal val2 = val + sr.Available_Stock__c;
                    srMap.put(sr.SKU__c,val2);
                } else {
                    srMap.put(sr.SKU__c,sr.Available_Stock__c);
                }
            }
        }
        
        if(soMap.size()>0) {
            for(String sku : soMap.keySet()) {
                Decimal totQ = 0;
                
                if(srMap.containsKey(sku)) {
                    totQ =  srMap.get(sku) - soMap.get(sku);
                } else {
                    totQ = 0 - soMap.get(sku);
                }
                
                if(!stockReq.containsKey(sku)) {
                    stockReq.put(sku,totQ);
                }
            }
        } else if(srMap.size()>0) {
            for(String sku:srMap.keySet()) {
                Decimal totQ = 0;
                
                if(srMap.containsKey(sku)) {
                    totQ = srMap.get(sku);
                } else {
                    totQ = 0;
                }
                
                if(!stockReq.containsKey(sku)) {
                    stockReq.put(sku,totQ);
                }
            }
        }
        
        return stockReq;
    }
    
    
    @AuraEnabled   
    public static PriceBookWrapper getSKUInventory(String skuId,String Sales_Org_Code, String depoId) {
        PriceBookWrapper pbWrapper = new PriceBookWrapper();
         
        try {
            
            Map<String,Decimal> inventoryMap = new Map<String,Decimal>();
            List<String> idList = new List<String>();
            idList.add(skuId);
            inventoryMap = getInventory(idList,Sales_Org_Code,depoId);
            
            if(inventoryMap.size()>0) {
                if(inventoryMap.containsKey(skuId)) {
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
    public static Boolean createDraftOrder(String orderObj) {
        OrderWrapper ordWrap = (OrderWrapper)JSON.deserialize(orderObj, OrderWrapper.class);
        List<OrderItemWrapper> orderItemList = ordWrap.orderItemList;        
        Boolean result = true;
        
        try {
            Order__c ordObj = new Order__c();
            ordObj.Id = ordWrap.ordr_id;
            ordObj.Order_Status__c = 'Draft';
            ordObj.Sales_Org__c = ordWrap.salesOrgObj;
            ordObj.Depot__c = ordWrap.Depo_Obj; 
            ordObj.Order_Type__c = ordWrap.Order_Type;
            ordObj.PONumber__c = ordWrap.po_no;
            ordObj.Remarks__c = ordWrap.remark;
            ordObj.OwnerId = ordWrap.ownerId;
            
            if(ordWrap.shipping_loc.trim().length()>0) {
                ordObj.Shipping_Location__c = ordWrap.shipping_loc;
            }
            ordObj.Date_of_Payment__c = Date.valueof(ordWrap.payment_date);
            ordObj.Type_of_Order__c = ordWrap.order_typ;
            
            /* ------------------------SKI (Nik) : #CR152 : PO And Delivery Date : 12-07-2022 NIK SKI-------------------------------- */
            if(ordWrap.showPODate == true && String.isNotBlank(ordWrap.poDate)) {
                ordObj.PO_Date__c = Date.valueof(ordWrap.poDate);
            } else if(ordWrap.showPODate == true && String.isBlank(ordWrap.poDate)) {
                ordObj.PO_Date__c = null;
            }
            /* ------------------------SKI (Nik) : #CR152 : PO And Delivery Date : 12-07-2022 SKI-------------------------------- */
            // ordObj.Distribution_Channel__c = ordWrap.distributorChannelId; 
            // ordObj.Division__c = ordWrap.divisionId; 
            
            update ordObj;
            // orIds.add(ordObj.Id);
            Integer itemNumber = 0;
            
            if(orderItemList.size()>0) {
                itemNumber = ordWrap.lastItemNumber;
            }
            System.debug('New lastItemNumber :- ' + itemNumber);
            
            if(orderItemList.size()>0) {
                List<OrderLineItem__c> orderLineItems = new List<OrderLineItem__c>();
                
                for(OrderItemWrapper itemWrap : orderItemList) {
                    OrderLineItem__c ordItem = new OrderLineItem__c();
                    
                    if(itemWrap.orderItem_id.trim().length() > 0) {
                        ordItem.Id = itemWrap.orderItem_id;
                    } else {
                        ordItem.Order__c = ordObj.Id; 
                    }
                    
                    ordItem.CurrencyIsoCode = ordWrap.CurrencyCode;
                    ordItem.MaxPrice__c = itemWrap.max_price;
                    ordItem.MinPrice__c = itemWrap.min_price;
                    ordItem.Net_Price__c = itemWrap.net_price;
                    ordItem.Price__c = itemWrap.final_price;
                    ordItem.Quantity__c = itemWrap.quantity;
                    ordItem.Date_of_Payment__c = Date.valueof(itemWrap.payment_date);
                    ordItem.SKU_Name__c = itemWrap.sku_id;
                    ordItem.UOM__c = itemWrap.uom;
                    ordItem.Price_Book_Master__c = itemWrap.pb_id;
                    ordItem.Distribution_Channel__c = itemWrap.distributionChanlIds;
                    ordItem.Division__c = itemWrap.divisionIds;
                    
                    System.debug('itemWrap.deliveryDate :- ' + itemWrap.deliveryDate.length());
                    
                    if(itemWrap.itemNumber == 0) {
                        itemNumber = itemNumber+10;
                        ordItem.Item_Number__c = String.valueOf(itemNumber);
                    }
                    
                    /* ------------------------SKI (Nik) : #CR152 : PO And Delivery Date : 12-07-2022 NIK SKI-------------------------------- */
                    if(ordWrap.showDeliveryDate == true && itemWrap.deliveryDate.length()>0) {
                        ordItem.Delivery_Date__c = Date.valueof(itemWrap.deliveryDate);
                    } else if(ordWrap.showDeliveryDate == true && itemWrap.deliveryDate.length()<=0) {
                        ordItem.Delivery_Date__c = null;
                    }
                    /* ------------------------SKI (Nik) : #CR152 : PO And Delivery Date : 12-07-2022 SKI-------------------------------- */
                    
                    orderLineItems.add(ordItem);
                }
                
                if(orderLineItems.size()>0) {
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
    public static List<Sales_Order__c> createNewSO(String orderObj) {
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
        List<Admin_MPT_Colombia__c> usdConv = new List<Admin_MPT_Colombia__c>();
        
        try {
            String div_Id = '';
            String sOrder_Id = '';
            Integer itemNo = 0;
            
            /* if(orderItemList.size()>0){
itemNo = ordWrap.lastItemNumber;
} */
            
            if(orderItemList.size()>0) {
                user = [SELECT Id, Name, Country, IsActive, Show_Inventory__c, Show_Credit_Limit__c, 
                        Show_Inventory_Column__c, Show_InTransit__c, Show_InTransit_Values__c, 
                        ProfileId,Profile.Name, ManagerId, Country_Head__c, Zonal_Manager__c, RegionalManager__c, 
                        Marketing_Manager__c FROM User WHERE Id =: ordWrap.ownerId AND IsActive = True];
                
                usdConv = [SELECT Id, Name, USD_conversion_rate__c, Sales_Org__c, Sales_Org__r.Sales_org_code__c, 
                           Active__c FROM Admin_MPT_Colombia__c WHERE Sales_Org__c =: ordWrap.salesOrgObj 
                           ORDER BY LastModifiedDate DESC LIMIT 1];
                
                for(OrderItemWrapper itemWrap : orderItemList) {
                    if(!DivisionMap.containsKey(itemWrap.divisionIds)) {
                        DivisionMap.put(itemWrap.divisionIds, new List<OrderItemWrapper>{itemWrap});
                    } else {
                        DivisionMap.get(itemWrap.divisionIds).add(itemWrap);
                    }
                }
                
                List<Sales_Order_Line_Item__c> soItemList = new List<Sales_Order_Line_Item__c>();
                List<String> soItemListDelete = new List<String>();
                
                for(String div : DivisionMap.keySet()) {
                    // Integer itemNo = 0;
                    Sales_Order_Line_Item__c sliObj;
                    
                    for(OrderItemWrapper item : DivisionMap.get(div)) {
                        Sales_Order__c ordObj = new Sales_Order__c();
                        
                        if(divisionSOMap.containsKey(item.divisionIds)) { System.debug('@1134 If is true--'+item.divisionIds+'@');
                            ordObj = divisionSOMap.get(item.divisionIds);System.debug('ordObj>>>' +ordObj);
                            ordObj.Total_Amount__c = ordObj.Total_Amount__c + item.final_price;  // change..
                            
                            System.debug('Sent_for_Manager_Approval_Mexico__c >>>' +ordObj.Sent_for_Manager_Approval_Mexico__c);
                            if(item.net_price < item.min_price  && ordObj.Sent_for_Manager_Approval_Mexico__c == false) {
                                ordObj.Order_Status__c = 'Pending';
                                ordObj.Sent_for_Manager_Approval_Mexico__c = true;
                                ordObj.Sent_for_Director_Approval_Mexico__c = true;
                                ordObj.Sent_for_Latam_Director_Approval__c = true;
                                //sliObj.is_Approval_Required__c = true;
                            }
                            
                            update ordObj;
                        } else {
                            if(ordWrap.so_id.trim().length() > 0) {
                                System.debug('@1150--'+ordWrap.so_id+'@');
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
                            ordObj.OwnerId = ordWrap.ownerId;	//userinfo.getuserid();
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
                            ordObj.Date_of_Payment__c = Date.valueof(ordWrap.payment_date);  
                            ordObj.Inco_Term__c = ordWrap.inco_term_id; 
                            ordObj.Order_Type__c = ordWrap.order_typ;
                            
                            
                            if(usdConv.size()>0) {
                                ordObj.USD_Conversion_Rate__c = usdConv[0].USD_conversion_rate__c;
                            }
                            //New approval step for Bolivia & Paraguay , If payment date is greater than 270 days --Starts
                            //Added By Srinivas G--RITM0383130
                            Sales_Order__c ordO = new Sales_Order__c();
                            Date paymentDate= ordObj.Date_of_Payment__c;
                            Date startDate = System.today();
                            Integer noOfDays = startDate.daysBetween( paymentDate );
                            ordObj.isPriceMinimum__c=false;	
                            ordObj.isDaysGT270MinPrice__c=false;	
                            ordObj.isPaymentDaysParaguay__c=false;
                            ordObj.ParaguayApprover__c='None';
                            //
                            ordObj.min_price__c=item.net_price;
                         	ordObj.Sku_name__c=item.sku_id;
                            ordObj.quantity__c= item.quantity;
                            
                            if(item.net_price < item.min_price && noOfDays<=270) {
                                ordObj.Order_Status__c = 'Pending';
                                ordObj.isPriceMinimum__c=true;
                                ordObj.isDaysGT270MinPrice__c=false;
                                ordObj.Sent_for_Manager_Approval_Mexico__c = true;
                                ordObj.Sent_for_Director_Approval_Mexico__c = true; 
                                ordObj.Sent_for_Latam_Director_Approval__c = true;
                                ordObj.ParaguayApprover__c='Diego Demestri, Manuel Tarraza - For minimum price';
                                //ordObj.Order__c
                               
                                //sliObj.is_Approval_Required__c = true;
                                
                            } else if (noOfDays>=270 && item.net_price >item.min_price) {
                                ordObj.Order_Status__c = 'Pending';
                                ordObj.isPaymentDaysParaguay__c=true;
                                ordObj.isPriceMinimum__c=false;
                                ordObj.ParaguayApprover__c='Manuel Tarraza -For Payment date >270';
                               
                              
                                
                            } else if(noOfDays>=270 && item.net_price < item.min_price) {
                                ordObj.Order_Status__c = 'Pending';
                                ordObj.isDaysGT270MinPrice__c=true;
                                ordObj.isPriceMinimum__c=true;
                                ordObj.isPaymentDaysParaguay__c=true;
                               	ordObj.Sent_for_Manager_Approval_Mexico__c = true;
                                ordObj.Sent_for_Director_Approval_Mexico__c = true; 
                                ordObj.Sent_for_Latam_Director_Approval__c = true; 
                               
                                ordObj.ParaguayApprover__c='Diego Demestri, Manuel Tarraza - For both Payment date >270  & Minimum price';
                                
                            } else {
                                ordObj.Order_Status__c = 'Open';
                                ordObj.isPriceMinimum__c=false;
                                ordObj.Sent_for_Manager_Approval_Mexico__c = false;
                                ordObj.Sent_for_Latam_Director_Approval__c = false;
                                ordObj.Sent_for_Director_Approval_Mexico__c = false;
                                ordObj.ParaguayApprover__c='None';
                            } 
                            //---End RITM0383130
                            
                            if(user.Country_Head__c != null) {
                                ordObj.Latam_Director_Mexico__c = user.Country_Head__c;
                            }
                            
                            if(user.Marketing_Manager__c != null) {
                                ordObj.Sales_Director_Mexico__c = user.Marketing_Manager__c; 
                            }
                            
                            if(user.Zonal_Manager__c != null) {
                                ordObj.Manager__c = user.Zonal_Manager__c;
                            }
                            
                            ordObj.Depot__c = ordWrap.Depo_Obj; 
                            ordObj.Total_Amount__c = item.final_price;
                            ordObj.Payment_Term__c = ordWrap.payment_term_id;
                            
                            /* ------------------------SKI (Nik) : #CR152 : PO And Delivery Date : 12-07-2022 NIK SKI-------------------------------- */
                            if(ordWrap.showPODate == true && String.isBlank(ordWrap.poDate)) {
                                ordObj.Purchase_Order_Date__c = null;
                            } else if(ordWrap.showPODate == true && String.isNotBlank(ordWrap.poDate)) {
                                ordObj.Purchase_Order_Date__c = Date.valueof(ordWrap.poDate);
                            }
                            /* ------------------------SKI (Nik) : #CR152 : PO And Delivery Date : 12-07-2022 SKI-------------------------------- */
                            
                            upsert ordObj;
                            
                            System.debug('Here'+ordWrap.so_id+'Here');
                            if(ordWrap.so_id.trim().length() == 0) {
                                System.debug('ordObj.Id 1265>>>>>>>>>>>>>>>>>>' +ordObj.Id);
                                orIds.add(ordObj.Id);
                                System.debug('orIds 1267>>>>>>>>>>>>>>>>>>' +orIds);
                            }
                            
                            divisionSOMap.put(item.divisionIds,ordObj);
                        }
                        
                        if(itemNoMap.containsKey(ordObj.Id)) {
                            itemNo = itemNoMap.get(ordObj.Id);
                        } else {
                            itemNo = 0;
                        }
                        
                        sliObj = new Sales_Order_Line_Item__c();  
                        
                        if(item.net_price < item.min_price) {
                            sliObj.is_Approval_Required__c = true;
                        } else {
                            sliObj.is_Approval_Required__c = false;
                        }
                        
                        if(ordWrap.isSalesOrder == false) {
                            sliObj.Sale_Order__c = ordObj.Id;
                        } else {
                            if(ordWrap.isSalesOrder == true && item.order_id == sOrder_Id && item.divisionIds == div_Id) {
                                sliObj.Id = item.orderItem_id;
                            } else {
                                sliObj.Sale_Order__c = ordObj.Id;
                                soItemListDelete.add(item.orderItem_id);
                            }
                        }
                        
                        if(ordWrap.isSalesOrder == false) {
                            itemNo = itemNo +10;
                            sliObj.Item_Number__c = itemNo;
                            itemNoMap.put(ordObj.Id,itemNo);
                        } else {
                            sliObj.Item_Number__c = item.itemNumber;
                        }
                        
                        sliObj.SKU_Name__c = item.sku_id;						            
                        sliObj.Item_Status__c = 'Active';
                        sliObj.DepotDepot__c = ordWrap.Depo_Obj;
                        sliObj.Storage_Location__c = ordWrap.Storage_Location;
                        sliObj.UOM__c = item.uom;
                        sliObj.CurrencyIsoCode = ordWrap.CurrencyCode;
                        sliObj.MaxPrice__c = item.max_price;
                        sliObj.MinPrice__c = item.min_price; 
                        sliObj.Net_Price__c = item.net_price;
                        sliObj.Price__c = item.final_price;
                        sliObj.Quantity__c = item.quantity;
                        sliObj.Date_of_Payment__c = Date.valueof(item.payment_date);
                        sliObj.PriceBookMaster__c = item.pb_id;
                        sliObj.Distribution_Channel__c = item.distributionChanlIds;
                        sliObj.Division__c = item.divisionIds;
                        
                        /* ------------------------SKI (Nik) : #CR152 : PO And Delivery Date : 12-07-2022 NIK SKI-------------------------------- */
                        if(ordWrap.showDeliveryDate == true && item.deliveryDate.length()>0) {
                            sliObj.Delivery_Date__c = Date.valueof(item.deliveryDate);
                        } else if(ordWrap.showDeliveryDate == true && item.deliveryDate.length()<=0) {
                            sliObj.Delivery_Date__c = null;
                        }
                        /* ------------------------SKI (Nik) : #CR152 : PO And Delivery Date : 12-07-2022 SKI-------------------------------- */
                        
                        soItemList.add(sliObj);
                        ordWrap.so_id = '';
                    }
                }
                
                if(soItemList.size()>0) {
                    
                    upsert soItemList;  //orderToUpdate
                }
                
                if(ordWrap.isSalesOrder == true) {
                    List<Attachment> newAttchlist = new List<Attachment>();
                    List<Attachment> attchlist = new List<Attachment>();
                    attchlist = [SELECT Id, ParentId, Name, ContentType, Body FROM Attachment 
                                 where ParentId =: sOrder_Id];
                    
                    if(attchlist.size()>0) {
                        if(orIds.size()>0) {
                            for(Attachment atch : attchlist) {
                                for(String so : orIds) {
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
                    
                    if(newAttchlist.size()>0) {
                        insert newAttchlist;
                    }
                    System.debug('here-->'+sOrder_Id);
                    orIds.add(sOrder_Id);
                }
                
                Order__c ord = new Order__c();
                ord.Id = ordWrap.ordr_id;
                ord.Order_Status__c = 'Approved';
                
                update ord;
                
                if(ordWrap.isSalesOrder == true) {
                    List<Sales_Order_Line_Item__c> lineItemlist = new List<Sales_Order_Line_Item__c>();
                    lineItemlist = [SELECT Id, Name FROM Sales_Order_Line_Item__c WHERE
                                    Id IN : soItemListDelete];
                    
                    if(lineItemlist.size()>0) {
                        delete lineItemlist;
                    } 
                }
                System.debug('orderIds>>>1384'+orIds);
                orderIds = [SELECT Id, Name, Total_Amount__c, Call_Process_Builder_Flow__c FROM Sales_Order__c WHERE Id IN : orIds];
                System.debug('orderIds>>>1386'+orderIds);
                if(orderIds.size()>0) {
                    for(Sales_Order__c sOrder : orderIds) {
                        //Decimal val = sOrder.Total_Amount__c; //(sOrder.Total_Amount__c - ((sOrder.Total_Amount__c * sOrder.Early_Order_Discount__c) / 100)).setScale(2) ;
                        //sOrder.Total_Amount__c = val;
                        sOrder.Call_Process_Builder_Flow__c = true;
                        System.debug('Call_Process_Builder_Flow__c>>>1392'+sOrder.Call_Process_Builder_Flow__c);
                        
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
    public static List<Sales_Order__c> updateSalesOrder(String orderObj) {
        List<Sales_Order__c> orderIds = new List<Sales_Order__c>();
        List<String> orIds = new List<String>();
        OrderWrapper ordWrap = (OrderWrapper)JSON.deserialize(orderObj, OrderWrapper.class);
        
        CreditSummaryWrapper credSum = ordWrap.creditSummary;
        List<OrderItemWrapper> orderItemList = ordWrap.orderItemList;
        System.debug('updateSalesOrder :- '+ ordWrap);
        
        try {
            Sales_Order__c ordObj = new Sales_Order__c();
            
            if(ordWrap.so_id.trim().length() > 0) {
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
            ordObj.Date_of_Payment__c = Date.valueof(ordWrap.payment_date);
            ordObj.Payment_Term__c = ordWrap.payment_term_id;
            ordObj.Inco_Term__c = ordWrap.inco_term_id; 
            ordObj.Order_Type__c = ordWrap.order_typ;
            
            /* ------------------------SKI (Nik) : #CR152 : PO And Delivery Date : 12-07-2022 NIK SKI-------------------------------- */
            if(ordWrap.showPODate == true && String.isNotBlank(ordWrap.poDate)) {
                ordObj.Purchase_Order_Date__c = Date.valueof(ordWrap.poDate);
            } else if(ordWrap.showPODate == true && String.isBlank(ordWrap.poDate)) {
                ordObj.Purchase_Order_Date__c = null;
            }
            /* ------------------------SKI (Nik) : #CR152 : PO And Delivery Date : 12-07-2022 SKI-------------------------------- */
            
            upsert ordObj;
            
            orIds.add(ordObj.Id);
            orderIds = [SELECT Id, Name FROM Sales_Order__c WHERE Id IN : orIds];
            Integer itemNo = 0;
            
            if(orderItemList.size()>0) {
                itemNo = ordWrap.lastItemNumber;
            }
            
            if(orderItemList.size()>0) {
                List<Sales_Order_Line_Item__c> soItemList = new List<Sales_Order_Line_Item__c>();
                Sales_Order_Line_Item__c sliObj;
                
                for(OrderItemWrapper item : orderItemList) {
                    sliObj = new Sales_Order_Line_Item__c();
                    
                    if(item.orderItem_id.trim().length()>0 && ordWrap.isSalesOrder == true) {
                        sliObj.Id = item.orderItem_id;
                    } else {
                        sliObj.Sale_Order__c = ordObj.id;
                    }
                    
                    sliObj.SKU_Name__c = item.sku_id;
                    
                    if(ordWrap.isSalesOrder == false) {
                        sliObj.Item_Number__c = item.itemNumber;
                    } else if(ordWrap.isSalesOrder == true && item.itemNumber == 0) {
                        itemNo = itemNo + 10;
                        sliObj.Item_Number__c = itemNo;
                    }
                    
                    sliObj.Item_Status__c = 'Active';
                    sliObj.DepotDepot__c = ordWrap.Depo_Obj;
                    sliObj.Storage_Location__c = ordWrap.Storage_Location;
                    sliObj.UOM__c = item.uom;
                    sliObj.CurrencyIsoCode = ordWrap.CurrencyCode;
                    sliObj.MaxPrice__c = item.max_price;
                    sliObj.MinPrice__c = item.min_price; 
                    sliObj.Net_Price__c = item.net_price;
                    sliObj.Price__c = item.final_price;
                    sliObj.Quantity__c = item.quantity;
                    sliObj.Date_of_Payment__c = Date.valueof(item.payment_date);
                    sliObj.PriceBookMaster__c = item.pb_id;
                    sliObj.Distribution_Channel__c = item.distributionChanlIds;
                    sliObj.Division__c = item.divisionIds;
                    
                    /* ------------------------SKI (Nik) : #CR152 : PO And Delivery Date : 12-07-2022 NIK SKI-------------------------------- */
                    if(ordWrap.showDeliveryDate == true && item.deliveryDate.length()>0) {
                        sliObj.Delivery_Date__c = Date.valueof(item.deliveryDate);
                    } else if(ordWrap.showDeliveryDate == true && item.deliveryDate.length()<=0) {
                        sliObj.Delivery_Date__c = null;
                    }
                    /* ------------------------SKI (Nik) : #CR152 : PO And Delivery Date : 12-07-2022 SKI-------------------------------- */
                    soItemList.add(sliObj);
                }
                
                if(soItemList.size()>0) {
                    upsert soItemList;
                }
            }
            
            List<Order__c> ord = [SELECT Id, Name, Order_Status__c from Order__c WHERE 
                                  Id =: ordWrap.ordr_id LIMIT 1];
            if(ord.size()>0) {
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
    public static Boolean deleteLineItem(String itemId, String type, Decimal netPrc) {
        Boolean result = false;
        System.debug('deleteLineItem id -: '+ itemId);
        
        if(type == 'Sales Order') {
            List<Sales_Order_Line_Item__c> soItemList = [SELECT Id, Name,Sale_Order__c,Sale_Order__r.Total_Amount__c 
                                                         FROM Sales_Order_Line_Item__c  WHERE Id=:itemId LIMIT 1];
            
            if(soItemList.size()>0) {
                Sales_Order__c sOrdr = new Sales_Order__c();
                sOrdr.Id = soItemList[0].Sale_Order__c;
                sOrdr.Total_Amount__c = soItemList[0].Sale_Order__r.Total_Amount__c - netPrc;
                
                update sOrdr;
                delete soItemList;
                
                result = true;
            }                                
        } else if(type == 'Order') {
            List<OrderLineItem__c> soItemList = [SELECT Id, Name, Order__c, Order__r.Net_Amount__c 
                                                 FROM OrderLineItem__c WHERE Id=:itemId LIMIT 1];
            
            if(soItemList.size()>0) {
                Order__c ordr = new Order__c();
                ordr.Id = soItemList[0].Order__c;
                
                delete soItemList;
                update ordr;
                
                result = true;
            }
        }
        return result;
    }
    
    @AuraEnabled   
    public static Boolean deleteAllLineItem(String ordrId, String type) {
        Boolean result = false;
        System.debug('deleteAllLineItem id -: '+ ordrId);
        
        if(type == 'Sales Order') {
            List<Sales_Order_Line_Item__c> soItemList = [SELECT Id, Name, Sale_Order__c FROM Sales_Order_Line_Item__c 
                                                         WHERE Sale_Order__c=:ordrId ];
            
            if(soItemList.size()>0) {
                delete soItemList;
                Sales_Order__c sOrdr = new Sales_Order__c();
                sOrdr.Id = ordrId;
                sOrdr.Total_Amount__c = 0;
                
                update sOrdr;
                result = true;
            }
        } else if(type == 'Order') {
            List<OrderLineItem__c> soItemList = [SELECT Id, Name, Order__c FROM OrderLineItem__c 
                                                 WHERE Order__c=:ordrId ];
            
            if(soItemList.size()>0) {
                delete soItemList; 
                Order__c ordr = new Order__c();
                ordr.Id = ordrId;
                
                update ordr;
                result = true;
            }
        }
        return result;
    }
    
    public class CreditSummaryWrapper {
        @AuraEnabled public String account_name;
        @AuraEnabled public String sap_code;
        @AuraEnabled public Decimal total_credit_limit;
        @AuraEnabled public Decimal internal_credit_limit;
        @AuraEnabled public Decimal credit_limit_used;
        @AuraEnabled public Decimal credit_limit_balance;
        @AuraEnabled public Decimal total_outstanding;
        @AuraEnabled public Decimal net_overdue;
        
        public CreditSummaryWrapper() {
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
    
    public class OrderForWrapper {
        @AuraEnabled public Sales_Org__c salesOrgObj;
        @AuraEnabled public Order_Type__c Order_Type;
        @AuraEnabled public Depot__c Depo_Obj;
        @AuraEnabled public Depot__c Storage_Location;
        @AuraEnabled public List<String> distributionChanlIds;
        @AuraEnabled public List<String> divisionIds;
        @AuraEnabled public Boolean error;
        @AuraEnabled public String accId;
        @AuraEnabled public String skuId;
        @AuraEnabled public List<Payment_Term__c> paymentTermList;
        @AuraEnabled public Inco_Term__c incoTerm;
        
        public OrderForWrapper() {
            salesOrgObj = new Sales_Org__c();
            Order_Type = new Order_Type__c();
            Depo_Obj = new Depot__c();
            Storage_Location = new Depot__c();
            distributionChanlIds = new List<String>();
            divisionIds = new List<String>();
            error = false;
            accId = '';
            skuId = '';
            paymentTermList = new List<Payment_Term__c>();
            incoTerm = new Inco_Term__c();
        }
    }
    
    public class PriceBookWrapper {
        @AuraEnabled public String id_val;
        @AuraEnabled public String sku_name;
        @AuraEnabled public String sku_id;
        @AuraEnabled public Decimal inventory;
        
        public PriceBookWrapper() {
            id_val = '';
            sku_name = '';
            sku_id = '';
            inventory = 0.0;
        }
    }
    
    public class PriceBookDetailsWrapper {
        @AuraEnabled public String pb_id;
        @AuraEnabled public String sku_name;
        @AuraEnabled public String sku_id;
        @AuraEnabled public String uom;
        @AuraEnabled public String shipmnt_date;
        @AuraEnabled public Decimal inventory;
        @AuraEnabled public String distributionChanlIds;
        @AuraEnabled public String divisionIds;
        @AuraEnabled public Decimal multiple_of;
        @AuraEnabled public String sku_mat_grp_code;
        @AuraEnabled public String sku_mat_grp_desc;
        @AuraEnabled public String depo;
        @AuraEnabled public String strt_date;
        @AuraEnabled public String end_date;
        @AuraEnabled public Decimal min_price;
        @AuraEnabled public Decimal max_price;
        @AuraEnabled public Decimal final_price;
        @AuraEnabled public Decimal net_value;
        @AuraEnabled public Decimal net_price;
        @AuraEnabled public Decimal quantity;
        @AuraEnabled public String deliveryDate;  // SKI (Nik) : #CR152 : PO And Delivery Date : 12-07-2022 Nik SKI....
        
        public PriceBookDetailsWrapper() {
            pb_id = '';
            sku_name = '';
            sku_id = '';
            uom = '';
            shipmnt_date = String.valueOf(System.today());
            inventory = 0.0;
            distributionChanlIds = '';
            divisionIds = '';
            multiple_of = 0.0;
            sku_mat_grp_code = '';
            sku_mat_grp_desc = '';
            depo = '';
            strt_date = String.valueOf(System.today());
            end_date = String.valueOf(System.today());
            min_price = 0.0;
            max_price = 0.0;
            final_price = 0.0;
            net_value = 0.0;
            net_price = 0.0;
            quantity = 0.0;
            
            //RITM0500996 Start 
            //To change the delivery date from +1 days to +4 days while accounting for weekends.
            Date calculatedDate;
            Date d = System.today();
            Datetime dt = (DateTime)d;
            String dayOfWeek = dt.format('EEEE');
            System.debug('dayOfWeek --> ' + dayOfWeek); 
            
            if(dayOfWeek == 'Tuesday') {
                calculatedDate = d.addDays(6);
            } else if(dayOfWeek == 'Wednesday') {
                calculatedDate = d.addDays(5);
            } else {
                calculatedDate = d.addDays(4);
            }
            
            deliveryDate = String.valueOf(calculatedDate);  // SKI (Nik) : #CR152 : PO And Delivery Date : 12-07-2022 Nik SKI....
            //RITM0500996 End
        }
    }
    
    public class OrderItemWrapper {
        @AuraEnabled public String orderItem_id;
        @AuraEnabled public String order_id;
        @AuraEnabled public String pb_id;
        @AuraEnabled public String sku_name;
        @AuraEnabled public String sku_id;
        @AuraEnabled public String uom;
        @AuraEnabled public Decimal multiple_of;
        @AuraEnabled public Decimal min_price;
        @AuraEnabled public Decimal max_price;
        @AuraEnabled public String shipmnt_date;
        @AuraEnabled public Decimal inventory;
        @AuraEnabled public String distributionChanlIds;
        @AuraEnabled public String divisionIds;
        @AuraEnabled public Integer itemNumber;
        @AuraEnabled public Decimal quantity;
        @AuraEnabled public Decimal final_price;
        @AuraEnabled public Decimal net_price;
        @AuraEnabled public String payment_date;
        @AuraEnabled public String deliveryDate; // SKI (Nik) : #CR152 : PO And Delivery Date : 12-07-2022 Nik SKI....
        
        public OrderItemWrapper() {
            orderItem_id = '';
            order_id = '';
            pb_id = '';
            sku_name = '';
            sku_id = '';
            uom = '';
            multiple_of = 0.0;
            max_price = 0.0;
            min_price = 0.0;
            shipmnt_date = String.valueOf(System.today());
            inventory = 0.0;
            distributionChanlIds = '';
            divisionIds = '';
            itemNumber = 0;
            quantity = 0.0;
            final_price = 0.0;
            net_price = 0.0;
            payment_date = String.valueOf(System.today());
            deliveryDate = String.valueOf(System.today()+1); // SKI (Nik) : #CR152 : PO And Delivery Date : 12-07-2022 Nik SKI....
        }
    }
    
    public class OrderWrapper {
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
        @AuraEnabled public Decimal total_amount;
        @AuraEnabled public String uom_kg;
        @AuraEnabled public String uom_each;
        @AuraEnabled public String uom_litre;
        @AuraEnabled public Decimal net_price_kg;
        @AuraEnabled public Decimal net_price_each;
        @AuraEnabled public Decimal net_price_litre;
        @AuraEnabled public Decimal quantity_kg;
        @AuraEnabled public Decimal quantity_each;
        @AuraEnabled public Decimal quantity_litre;
        @AuraEnabled public String inco_term;
        @AuraEnabled public String inco_term_id;
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
        @AuraEnabled public String Storage_Location;
        @AuraEnabled public String CurrencyCode;
        @AuraEnabled public String ownerId;
        @AuraEnabled public List<String> distributionChanlIds;
        @AuraEnabled public List<String> divisionIds;
        @AuraEnabled public Integer lastItemNumber;
        @AuraEnabled public String orderRaisedBy;
        @AuraEnabled public String managerId;
        @AuraEnabled public String countryHead;
        @AuraEnabled public List<Payment_Term__c> payTermList;
        @AuraEnabled public String fileName;
        @AuraEnabled public String payment_date;
        @AuraEnabled public String order_typ;
        @AuraEnabled public OrderForWrapper orderForWrapper;
        @AuraEnabled public Boolean isCustomerService;
        @AuraEnabled public Map<String,String> orderTypMap;
        @AuraEnabled public Boolean showPODate;                 // SKI (Nik) : #CR152 : PO And Delivery Date : 12-07-2022 Nik SKI....
        @AuraEnabled public Boolean showDeliveryDate;           // SKI (Nik) : #CR152 : PO And Delivery Date : 12-07-2022 Nik SKI....
        @AuraEnabled public Boolean isPORequired;               // SKI (Nik) : #CR152 : PO And Delivery Date : 12-07-2022 Nik SKI....
        @AuraEnabled public Boolean isDeliveryRequired;         // SKI (Nik) : #CR152 : PO And Delivery Date : 12-07-2022 Nik SKI....
        @AuraEnabled public String poDate;                      // SKI (Nik) : #CR152 : PO And Delivery Date : 12-07-2022 Nik SKI....
        
        public OrderWrapper() {
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
            total_amount = 0.0;
            uom_kg = '';
            uom_each = '';
            uom_litre = '';
            net_price_kg = 0.0;
            net_price_each = 0.0;
            net_price_litre = 0.0;
            quantity_kg = 0.0;
            quantity_each = 0.0;
            quantity_litre = 0.0;
            inco_term = '';
            inco_term_id = '';
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
            Storage_Location = '';
            CurrencyCode = '';
            ownerId = '';
            distributionChanlIds = new List<String>();
            divisionIds = new List<String>();
            lastItemNumber = 0;
            orderRaisedBy = '';
            managerId = '';
            countryHead = '';
            payTermList = new List<Payment_Term__c>();
            fileName = '';
            payment_date = String.valueOf(System.today());
            order_typ = '';
            orderForWrapper = new OrderForWrapper();      
            isCustomerService = false; 
            orderTypMap = new Map<String,String>();
            showPODate = false;                             // SKI (Nik) : #CR152 : PO And Delivery Date : 12-07-2022 Nik SKI....
            showDeliveryDate = false;                       // SKI (Nik) : #CR152 : PO And Delivery Date : 12-07-2022 Nik SKI....
            isPORequired = false;                           // SKI (Nik) : #CR152 : PO And Delivery Date : 12-07-2022 Nik SKI....
            isDeliveryRequired = false;                     // SKI (Nik) : #CR152 : PO And Delivery Date : 12-07-2022 Nik SKI....
            poDate = String.valueOf(System.today());         // SKI (Nik) : #CR152 : PO And Delivery Date : 02-08-2022 Nik SKI....
        }
    }
}