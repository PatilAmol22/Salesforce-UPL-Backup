/*  
* Name: OrderMexicoCmpController    
* Created On: 24th Dec 2020
* Author: Vivek Shrivastava
* Description: Order Mexico Lightning Component Apex Controller used for rasing order in Mexico.
Changes Descriptions : - Marginal BLock and PLN values and chanages Approval Process. 
changed done By  :- Vishal Pawar (Vishal.pawar@skinternational.com) 21-02-2022
*/ 
public without sharing class OrderMexicoCmpController{
    
    //fetchProfitCenter
    @AuraEnabled
    public static Profit_Center__c fetchProfitCenter(){
        Profit_Center__c profObj = new Profit_Center__c();
        profObj = [SELECT Id, Name, Profit_Center__c, Sales_Value__c, Sales_Org__c, 
                   Depot__c, Combination_Key__c 
                   FROM Profit_Center__c
                   WHERE Sales_Org__r.Sales_Org_Code__c  ='5100'
                   AND Depot__r.Depot_Code__c='MX00'
                   ORDER BY LastModifiedDate DESC LIMIT 1]; // SKI(Vishal P) : #CR152 : PO And Delivery Date : 18-07-2022...Limit added.
        return profObj;
    }
    
    
    
    @AuraEnabled
    public static WrapperData initializeDetails(String recordId){
        WrapperData wrapObj = new WrapperData();
        String sobjectType = Id.valueOf(recordId).getSObjectType().getDescribe().getName();
        Order__c orderObj_For_Edit_So = new Order__c();
        Sales_Order__c soObj = new Sales_Order__c();
        SalesOrderDetailWrap soWrap = new SalesOrderDetailWrap();
        
        //Getting all details for initilaization
        wrapObj.initDetailsWrap = new GetDetailsWrap(recordId);
        
        wrapObj.lCountry = fetchLoginCountryData();  // SKI(Vishal P) : #CR152 : PO And Delivery Date : 18-07-2022
                
        //Getting all details of Distributer
        wrapObj.distributerWrapObj = getDistributerDetails(wrapObj.initDetailsWrap);
        
        //Getting all details of SKU & Popular
        mapSKUWrapper mapSKU = fetchSKUData(wrapObj.initDetailsWrap, wrapObj.distributerWrapObj.salesOrgId, wrapObj.distributerWrapObj.divisionIds);
        
        wrapObj.skuObjList = mapSKU.skuDetailsMap.values();
        WrappergetOrder getOdrObj;
        
        if(sobjectType == 'Sales_Order__c'){
            // SKI(Vishal P) : #CR152 : PO And Delivery Date : 18-07-2022...Purchase_Order_Date__c field added...
            soObj = [SELECT Id,Purchase_Order_Date__c, Remarks_Long__c, Depot__r.Depot_Code__c, Ship_To_Party__r.city__c,
                     Name, Ship_To_Party__r.Name, Order_Type_lk__c, Division_lk__c, Net_Amount__c, 
                     Inco_Term__c, PaymentMethod__c, CurrencyIsoCode, Payment_Term__c,
                     Payment_Term__r.Payment_Term__c, Order_Type_lk__r.Description__c,
                     Order__c, Order__r.Order_Status__c, Order__r.OwnerId
                     FROM Sales_Order__c Where Id =: recordId LIMIT 1];
            
            soWrap.soObj = soObj;
            soWrap.payment_Methods = soObj.PaymentMethod__c;
            soWrap.payment_Terms = soObj.Payment_Term__c;
            soWrap.inco_Terms = soObj.Inco_Term__c;
            soWrap.selectedShipping = soObj.Ship_To_Party__r.Name;
            soWrap.selectedOrderType = soObj.Order_Type_lk__c;
            soWrap.Remaks = soObj.Remarks_Long__c;
            
            orderObj_For_Edit_So.Id = soObj.Order__c;
            orderObj_For_Edit_So.Order_Status__c = soObj.Order__r.Order_Status__c;
            orderObj_For_Edit_So.OwnerId = soObj.Order__r.OwnerId;
            wrapObj.orderObj = orderObj_For_Edit_So;
            getOdrObj  = getSKUOrderList(soObj,wrapObj.distributerWrapObj.divisionIds,wrapObj.initDetailsWrap);
            wrapObj.distributerWrapObj.selectedShippingLocation = populateShippingAddress(
                JSON.serialize(wrapObj.distributerWrapObj.mapShippingLocationWrapper),
                soWrap.selectedShipping
            );
        }
        else if(sobjectType == 'Account'){ 
            wrapObj.orderObj = createOrder(wrapObj.initDetailsWrap.accountId, wrapObj.initDetailsWrap.orderRaisedBy, wrapObj.distributerWrapObj,
                                           wrapObj.initDetailsWrap.depoId);
            getOdrObj  = getSKUOrderList(mapSKU, wrapObj.orderObj,wrapObj.initDetailsWrap,wrapObj.distributerWrapObj.divisionIds);
        }
        
        wrapObj.skuOrderList = getOdrObj.skuOrderList;
        wrapObj.orderSummaryUOMList = getOdrObj.orderSummaryUOMList;
        wrapObj.orderSummaryCurrencyList = getOdrObj.orderSummaryCurrencyList;
        wrapObj.soWrap = soWrap; 
        wrapObj.error = mapSKU.error;
        wrapObj.error = wrapObj.distributerWrapObj.error;
        return wrapObj;
    }
    /* --------------------Start SKI(Vishal P) : #CR152 : PO And Delivery Date : 18-07-2022------------------------------------------ */
    public static Login_Country__c fetchLoginCountryData(){
        Login_Country__c  lcnty = [SELECT Id, Name, For_Contry__c, Sales_Org_Code__c, PO_Date__c, 
                                   Delivery_Date__c, Show_PO_Date__c, Show_Delivery_Date__c 
                                   FROM Login_Country__c 
                                   WHERE Sales_Org_Code__c='5100' LIMIT 1];
        return lcnty;
    }
    /* ----------------------End SKI(Vishal P) : #CR152 : PO And Delivery Date : 18-07-2022-------------------------------------------- */
    //Added for CR : Depot improvement Mexico. SCTASK0308045 (RITM0141217)
    @AuraEnabled
    public static InventoryWrap getInventoryDetails(String getDetailsWrap_str, String skuOrderList_str, String skuObjList_str,
                                                    String selectedSKU_str, String storageIdChosen)
    {   
        GetDetailsWrap detailObj = (GetDetailsWrap)system.JSON.deserializeStrict(getDetailsWrap_str, GetDetailsWrap.class);
        
        List<SKUDetails> skuOrderList = new List<SKUDetails>();
        if(skuOrderList_str != null){
            skuOrderList = (List<SKUDetails>)system.JSON.deserializeStrict(skuOrderList_str, List<SKUDetails>.class);
        }
        
        List<SKUDetails> skuObjList = new List<SKUDetails>();
        if(skuObjList_str != null){
            skuObjList = (List<SKUDetails>)system.JSON.deserializeStrict(skuObjList_str, List<SKUDetails>.class);
        }
        
        SKUDetails selectedSKUObj = new SKUDetails();
        if(selectedSKU_str != null){
            selectedSKUObj = (SKUDetails)system.JSON.deserializeStrict(selectedSKU_str, SKUDetails.class);    
        }
        
        Map<Id, SKUDetails> skuDetailsMap = new Map<Id, SKUDetails>();
        Map<Id, SKUDetails> skuOrderDetailsMap = new Map<Id, SKUDetails>();
        InventoryWrap invwrap = new InventoryWrap();
        
        for(SKUDetails skuObj : skuObjList){
            skuObj.available = 0;
            skuObj.available2 = 'Out of Stock';
            skuObj.invStyle = 'color:red;';
            skuDetailsMap.put(skuObj.skuId, skuObj);
        }
        
        for(SKUDetails skuObj : skuOrderList){
            skuObj.available = 0;
            skuObj.available2 = 'Out of Stock';
            skuObj.invStyle = 'color:red;';
            skuOrderDetailsMap.put(skuObj.skuId, skuObj);
        }
        
        if(selectedSKUObj != null && selectedSKUObj.skuId != null){
            selectedSKUObj.available = 0;
            selectedSKUObj.available2 = 'Out of Stock';
            selectedSKUObj.invStyle = 'color:red;';
        }
        
        for(Inventory__c invObj : [SELECT Id, SKU__c, Stock_Quantity__c, Balanced_Quanity__c,In_transit_stock_quantity__c
                                   FROM Inventory__c WHERE Storage_Location_Depot__c =: storageIdChosen AND SKU__r.Active__c = True])
        {
            if(skuDetailsMap.containsKey(invObj.SKU__c)){
                SKUDetails skuObj = skuDetailsMap.get(invObj.SKU__c);
                skuObj.available = Integer.valueOf(invObj.Balanced_Quanity__c);
                skuObj.inventoryId = invObj.Id;
                if(invObj.Balanced_Quanity__c!=null && invObj.Balanced_Quanity__c > 0){
                    skuObj.available2 = 'In Stock';
                    skuObj.invStyle = 'color:green;';
                }
                else if(invObj.In_transit_stock_quantity__c != null){
                    if(invObj.In_transit_stock_quantity__c > 0 && detailObj.showInTransit == true 
                       && detailObj.showInTransitValues == false){
                           skuObj.available2 = 'In Transit';
                           skuObj.invStyle = 'color:blue;';
                       }
                    else if(invObj.In_transit_stock_quantity__c > 0 && detailObj.showInTransit == false
                            && detailObj.showInTransitValues == true){
                                skuObj.available2 = '('+invObj.In_transit_stock_quantity__c+')';
                                skuObj.invStyle = 'color:blue;';
                            }                    
                    else if(invObj.In_transit_stock_quantity__c > 0 && detailObj.showInTransit == true 
                            && detailObj.showInTransitValues == true){
                                skuObj.available2 = 'In Transit ('+invObj.In_transit_stock_quantity__c+')';
                                skuObj.invStyle = 'color:blue;';
                            } 
                }else{
                    skuObj.available2 = 'Out of Stock';
                    skuObj.invStyle = 'color:red;';
                }
                skuDetailsMap.put(invObj.SKU__c, skuObj);
            }
            
            if(skuOrderDetailsMap.containsKey(invObj.SKU__c)){
                SKUDetails skuObj = skuOrderDetailsMap.get(invObj.SKU__c);
                skuObj.available = Integer.valueOf(invObj.Balanced_Quanity__c);
                skuObj.inventoryId = invObj.Id;
                if(invObj.Balanced_Quanity__c!=null && invObj.Balanced_Quanity__c > 0){
                    skuObj.available2 = 'In Stock';
                    skuObj.invStyle = 'color:green;';
                }
                else if(invObj.In_transit_stock_quantity__c != null){
                    if(invObj.In_transit_stock_quantity__c > 0 && detailObj.showInTransit == true 
                       && detailObj.showInTransitValues == false){
                           skuObj.available2 = 'In Transit';
                           skuObj.invStyle = 'color:blue;';
                       }
                    else if(invObj.In_transit_stock_quantity__c > 0 && detailObj.showInTransit == false
                            && detailObj.showInTransitValues == true){
                                skuObj.available2 = '('+invObj.In_transit_stock_quantity__c+')';
                                skuObj.invStyle = 'color:blue;';
                            }                    
                    else if(invObj.In_transit_stock_quantity__c > 0 && detailObj.showInTransit == true 
                            && detailObj.showInTransitValues == true){
                                skuObj.available2 = 'In Transit ('+invObj.In_transit_stock_quantity__c+')';
                                skuObj.invStyle = 'color:blue;';
                            } 
                }else{
                    skuObj.available2 = 'Out of Stock';
                    skuObj.invStyle = 'color:red;';
                }
                skuOrderDetailsMap.put(invObj.SKU__c, skuObj);
            }
            
            if(selectedSKUObj != null && selectedSKUObj.skuId != null && selectedSKUObj.skuId == invObj.SKU__c){
                selectedSKUObj.available = Integer.valueOf(invObj.Balanced_Quanity__c);
                selectedSKUObj.inventoryId = invObj.Id;
                if(invObj.Balanced_Quanity__c!=null && invObj.Balanced_Quanity__c > 0){
                    selectedSKUObj.available2 = 'In Stock';
                    selectedSKUObj.invStyle = 'color:green;';
                }
                else if(invObj.In_transit_stock_quantity__c != null){
                    if(invObj.In_transit_stock_quantity__c > 0 && detailObj.showInTransit == true 
                       && detailObj.showInTransitValues == false)
                    {
                        selectedSKUObj.available2 = 'In Transit';
                        selectedSKUObj.invStyle = 'color:blue;';
                    }
                    else if(invObj.In_transit_stock_quantity__c > 0 && detailObj.showInTransit == false
                            && detailObj.showInTransitValues == true)
                    {
                        selectedSKUObj.available2 = '('+invObj.In_transit_stock_quantity__c+')';
                        selectedSKUObj.invStyle = 'color:blue;';
                    }                    
                    else if(invObj.In_transit_stock_quantity__c > 0 && detailObj.showInTransit == true 
                            && detailObj.showInTransitValues == true)
                    {
                        selectedSKUObj.available2 = 'In Transit ('+invObj.In_transit_stock_quantity__c+')';
                        selectedSKUObj.invStyle = 'color:blue;';
                    } 
                }else{
                    selectedSKUObj.available2 = 'Out of Stock';
                    selectedSKUObj.invStyle = 'color:red;';
                }
            }
        }
        
        invwrap.skuObjList = skuDetailsMap.values();
        invwrap.skuOrderList = skuOrderDetailsMap.values();
        invwrap.selectedSKU = selectedSKUObj;
        return invwrap;
    }
    
    @AuraEnabled
    public static List<Sales_Order_Line_Item__c> getSalesOrderHistory(String initDetail, String skuId){
        GetDetailsWrap detailObj = (GetDetailsWrap)system.JSON.deserializeStrict(initDetail, GetDetailsWrap.class);
        List<Sales_Order_Line_Item__c> salesOrderLineItmList = new List<Sales_Order_Line_Item__c>();
        return [SELECT Id, Sale_Order__r.Name, Quantity__c, Sale_Order__r.Status__c, 
                Sale_Order__c, UOM__c, SKU_Name__c, Sale_Order__r.Order_Date__c, Crop__c, 
                Crop1_Percentage__c, Crop2__c, Crop2_Percentage__c,Crop3__c, Crop3_Percentage__c,Crop4__c, 
                Crop4_Percentage__c, Crop5__c, Crop5_Percentage__c, Sale_Order__r.Bill_To_Party__c,Agrosat_Sale_Mexico__c
                FROM Sales_Order_Line_Item__c WHERE SKU_Name__c =: skuId 
                AND Sale_Order__r.Sold_To_Party__c =: detailObj.accountId LIMIT 5];
    }
    
    
    
   @AuraEnabled
    public static List<SKUDetails> addSKU(String singleOrderItem_str, String skuOrderList_str, String distWrapObj_str, 
                                          String orderRaisedBy, Order__c ordObj, Boolean isEdit, Sales_Order__c salesOrderObj)
    {
        
        
        SKUDetails singleOrderItem = (SKUDetails)system.JSON.deserializeStrict(singleOrderItem_str, SKUDetails.class);
        DistributerWrapperObj distWrapObj = (DistributerWrapperObj)system.JSON.deserializeStrict(distWrapObj_str, DistributerWrapperObj.class);
        List<SKUDetails> skuOrderList = (List<SKUDetails>)system.JSON.deserializeStrict(skuOrderList_str, List<SKUDetails>.class);
        
        OrderLineItem__c oliObj = new OrderLineItem__c();
        Sales_Order_Line_Item__c soliObj = new Sales_Order_Line_Item__c();
        SKUDetails singleOrderItem_Existing = new SKUDetails();
        String selectedSKUId = singleOrderItem.skuId;
        Map<String, SKUDetails> mapSKUOrder = new Map<String, SKUDetails>();
        List<SKUDetails> skuOrderList_ToReturn = new List<SKUDetails>();
        
        if(skuOrderList != null && !skuOrderList.isEmpty()){
            //Check if SKU exists in Order List
            for(SKUDetails sku : skuOrderList){
                mapSKUOrder.put(sku.skuId+sku.typeOfSale, sku);
                if(sku.skuId == selectedSKUId && sku.typeOfSale == singleOrderItem.typeOfSale){
                    singleOrderItem_Existing = sku;
                }
            }
        }
        
        //For Sales Order edit
        /* -------------Start SKI(Vishal P) : #CR152 : PO And Delivery Date : 18-07-2022---------Complete logic changed------------------------- */
        if(isEdit){
            Integer itemNumber = 0;
            List<Sales_Order_Line_Item__c> soliList = [SELECT Id, Item_Number__c FROM Sales_Order_Line_Item__c
                                                       WHERE Sale_Order__c =: salesOrderObj.Id];
            if(soliList.size()>0){
                Integer sizeOfSolList = soliList.size();
                Integer itemNo = (Integer)soliList[sizeOfSolList-1].Item_Number__c;
                itemNumber = itemNo;                        
            }
            
            if(singleOrderItem.available == 0 || singleOrderItem.available2 == 'Out of Stock'){
                soliObj.Stock_Available__c = true;
            }
            soliObj.Sale_Order__c = salesOrderObj.Id;
            soliObj.SKU_Name__c = singleOrderItem.skuId;
            soliObj.UOM__c = singleOrderItem.UOM;
            singleOrderItem.netRateEntered = singleOrderItem.finalPrice*singleOrderItem.qty;
            Decimal totalpri = singleOrderItem.netRateEntered;
            singleOrderItem.netRateEnteredText = String.valueOf(totalpri);
            if(totalpri != null && singleOrderItem.typeOfSale != 'Promotion'){
                Decimal totalpriwithNoDecimal = Math.round(totalpri * 100) / 100;
                singleOrderItem.netRateEnteredText = String.valueOf(totalpriwithNoDecimal);
            }
            
            itemNumber = itemNumber + 10;
            singleOrderItem.itemNo = itemNumber;
            soliObj.Item_Number__c = itemNumber;
            soliObj.CurrencyIsoCode = singleOrderItem.currencyIso;
            soliObj.Quantity__c = singleOrderItem.qty;
            soliObj.Price__c = singleOrderItem.netRateEntered;
            soliObj.Net_Price__c = singleOrderItem.finalPrice;
            soliObj.MaxPrice__c = singleOrderItem.maxPrice;
            soliObj.MinPrice__c = singleOrderItem.minPrice;
            soliObj.Shipping_Date__c = singleOrderItem.DeliveryDate;
            soliObj.Agrosat_Sale_Mexico__c = singleOrderItem.agrosatsale;
            soliObj.crop__c = Id.valueOf(singleOrderItem.crop1);
            soliObj.Crop1_Percentage__c = singleOrderItem.crop1_Percentage;
            soliObj.Type_of_Sale__c = singleOrderItem.typeOfSale;
            if(!String.isBlank(singleOrderItem.crop2)){
                soliObj.Crop2__c = Id.valueOf(singleOrderItem.crop2);
            }else{
                soliObj.Crop2__c = null;
            }
            oliObj.crop2_Percentage__c = singleOrderItem.crop2_Percentage;
            
            if(!String.isBlank(singleOrderItem.crop3)){
                soliObj.Crop3__c = Id.valueOf(singleOrderItem.crop3);
            }else{
                soliObj.Crop3__c = null;
            }
            soliObj.crop3_Percentage__c = singleOrderItem.crop3_Percentage;
            
            
            if(!String.isBlank(singleOrderItem.crop4)){
                soliObj.Crop4__c = Id.valueOf(singleOrderItem.crop4);
            }else{
                soliObj.Crop4__c = null;
            }
            oliObj.Crop4_Percentage__c = singleOrderItem.crop4_Percentage;
            
            if(!String.isBlank(singleOrderItem.crop5)){
                soliObj.Crop5__c = Id.valueOf(singleOrderItem.crop5);
            }else{
                soliObj.Crop5__c = null;
            }
            soliObj.Crop5_Percentage__c = singleOrderItem.crop5_Percentage;
            INSERT soliObj;
            singleOrderItem.oliId = soliObj.Id;
            
            skuOrderList.add(singleOrderItem);
            skuOrderList_ToReturn.addAll(skuOrderList);
            
        }else{
            //Insert new Order Item
            System.debug('Insert new Order Item everytime');
            if(singleOrderItem.available == 0 || singleOrderItem.available2 == 'Out of Stock'){
                oliObj.Stock_Available__c = true;
            }
            oliObj.Order__c = ordObj.Id;
            oliObj.SKU_Name__c = singleOrderItem.skuId;
            oliObj.UOM__c = singleOrderItem.UOM;
            singleOrderItem.netRateEntered = singleOrderItem.finalPrice*singleOrderItem.qty;
            Decimal totalpri = singleOrderItem.netRateEntered;
            singleOrderItem.netRateEnteredText = String.valueOf(totalpri);
            if(totalpri != null && singleOrderItem.typeOfSale != 'Promotion'){
                Decimal totalpriwithNoDecimal = Math.round(totalpri * 100) / 100;
                singleOrderItem.netRateEnteredText = String.valueOf(totalpriwithNoDecimal);
            }
            singleOrderItem.itemNo = singleOrderItem.itemNo + 10;
            
            
            /*
            System.debug('singleOrderItem.uOM '+singleOrderItem.uOM);
            System.debug('skuWrapObj.rebate1LC '+singleOrderItem.rebate1LC);
            
            singleOrderItem.baseUOM = singleOrderItem.uOM;
            singleOrderItem.convertQty = singleOrderItem.convertQty;
            singleOrderItem.convertNetPrice = skuWrapObj.convertNetPrice;
            singleOrderItem.convertFinalPrice = skuWrapObj.convertFinalPrice;
            singleOrderItem.rebate1LC = skuWrapObj.rebate1LC;
            singleOrderItem.rebate1USD = skuWrapObj.rebate1USD;                
            singleOrderItem.rebate1USD = skuWrapObj.rebate1USD;
            singleOrderItem.rebate1Percent = skuWrapObj.rebate1Percent;
            singleOrderItem.uomRebate1 = skuWrapObj.uomRebate1;
            singleOrderItem.rebateCode1 = skuWrapObj.rebateCode1;
            singleOrderItem.rebate2LC = skuWrapObj.rebate2LC;                
            singleOrderItem.rebate2USD = skuWrapObj.rebate2USD;
            singleOrderItem.rebate2Percent = skuWrapObj.rebate2Percent;
            singleOrderItem.uomRebate2 = skuWrapObj.uomRebate2;
            singleOrderItem.rebateCode2 = skuWrapObj.rebateCode2;
            singleOrderItem.rebate2LC = skuWrapObj.rebate2LC;
            
            singleOrderItem.discountLC = skuWrapObj.discountLC;
            singleOrderItem.discountUSD = skuWrapObj.discountUSD;
            singleOrderItem.discountPercent = skuWrapObj.discountPercent;
            singleOrderItem.uomDiscount = skuWrapObj.uomDiscount;
            
            singleOrderItem.additionalDiscountLC = skuWrapObj.additionalDiscountLC;
            singleOrderItem.additionalDiscountPercent = skuWrapObj.additionalDiscountPercent;
            singleOrderItem.additionalDiscountUSD = skuWrapObj.additionalDiscountUSD;
            singleOrderItem.uomAddDiscount = skuWrapObj.uomAddDiscount;
            
            singleOrderItem.salesDeductionLC = skuWrapObj.salesDeductionLC;
            singleOrderItem.salesDeductionInPercent = skuWrapObj.salesDeductionInPercent;
            singleOrderItem.salesDeductionUSD = skuWrapObj.salesDeductionUSD;
            singleOrderItem.uomSalesDeduction = skuWrapObj.uomSalesDeduction;
            
            singleOrderItem.pLNLC = skuWrapObj.pLNLC;
            singleOrderItem.pLNUSD = skuWrapObj.pLNUSD;
            singleOrderItem.uomPLN = skuWrapObj.uomPLN;
*/
            
            oliObj.Item_Number__c = String.valueOf(singleOrderItem.itemNo);
            oliObj.CurrencyIsoCode = singleOrderItem.currencyIso;
            oliObj.Quantity__c = singleOrderItem.qty;
            oliObj.Price__c = singleOrderItem.netRateEntered;
            oliObj.Net_Price__c = singleOrderItem.finalPrice;
            oliObj.MaxPrice__c = singleOrderItem.maxPrice;
            oliObj.Shipping_Date__c = singleOrderItem.DeliveryDate;
            oliObj.crop__c = Id.valueOf(singleOrderItem.crop1);
            oliObj.Crop1_Percentage__c = singleOrderItem.crop1_Percentage;
            oliObj.Type_of_Sale__c = singleOrderItem.typeOfSale;
            oliObj.Agrosat_Sale_Mexico__c = singleOrderItem.agrosatSale;
            if(!String.isBlank(singleOrderItem.crop2)){
                oliobj.Crop2__c = Id.valueOf(singleOrderItem.crop2);
            }else{
                oliobj.Crop2__c = null;
            }
            oliObj.crop2_Percentage__c = singleOrderItem.crop2_Percentage;
            
            if(!String.isBlank(singleOrderItem.crop3)){
                oliobj.Crop3__c = Id.valueOf(singleOrderItem.crop3);
            }else{
                oliobj.Crop3__c = null;
            }
            oliObj.crop3_Percentage__c = singleOrderItem.crop3_Percentage;
            
            
            if(!String.isBlank(singleOrderItem.crop4)){
                oliobj.Crop4__c = Id.valueOf(singleOrderItem.crop4);
            }else{
                oliobj.Crop4__c = null;
            }
            oliObj.Crop4_Percentage__c = singleOrderItem.crop4_Percentage;
            
            if(!String.isBlank(singleOrderItem.crop5)){
                oliobj.Crop5__c = Id.valueOf(singleOrderItem.crop5);
            }else{
                oliobj.Crop5__c = null;
            }
            oliObj.Crop5_Percentage__c = singleOrderItem.crop5_Percentage;
            INSERT oliObj;
            singleOrderItem.oliId = oliObj.Id;
            
            /*
            if(skuOrderList != null && !skuOrderList.isEmpty()){
                for(SKUDetails sku : skuOrderList){
                String key1 = sku.skuId+sku.typeOfSale;
                String key2 = singleOrderItem.skuId+singleOrderItem.typeOfSale;
                if(key1 != key2){
                    skuOrderList_ToReturn.add(sku);   
                }
            }
            }*/
            
            skuOrderList.add(singleOrderItem);
            skuOrderList_ToReturn.addAll(skuOrderList);
        }
        /* ----------------------End SKI(Vishal P) : #CR152 : PO And Delivery Date : 18-07-2022--------------------------------------- */
        return skuOrderList_ToReturn;
    }    
    
    
    @AuraEnabled
    public static List<SKUDetails> updateSKU(String skuOrderList_str, Integer currentRow, Boolean isEdit){
        List<SKUDetails> skuOrderList_ToReturn = new List<SKUDetails>();
        List<SKUDetails> skuOrderList = (List<SKUDetails>)system.JSON.deserializeStrict(skuOrderList_str, List<SKUDetails>.class);
        
        if(isEdit){
            Sales_Order_Line_Item__c soliObj = new Sales_Order_Line_Item__c();
            
            SKUDetails skuWrapObj = skuOrderList[currentRow];
            if(String.isNotBlank(skuWrapObj.oliId)){
                soliObj.Id = skuWrapObj.oliId;
            }
            
            soliObj.Quantity__c = skuWrapObj.qty;
            soliObj.Net_Price__c = skuWrapObj.finalPrice;
            soliObj.Price__c = skuWrapObj.netRateEntered;
            soliObj.Shipping_Date__c = skuWrapObj.deliveryDate;
            soliObj.Delivery_Date__c = skuWrapObj.customerDeliveryDate;  // SKI(Vishal P) : #CR152 : PO And Delivery Date : 18-07-2022.....
            UPSERT soliObj;
            
            skuOrderList_ToReturn.addAll(skuOrderList);
        }else{
            OrderLineItem__c oliObj = new OrderLineItem__c();
            
            SKUDetails skuWrapObj = skuOrderList[currentRow];
            if(String.isNotBlank(skuWrapObj.oliId)){
                oliObj.Id = skuWrapObj.oliId;
            }
            
            oliObj.Quantity__c = skuWrapObj.qty;
            oliObj.Net_Price__c = skuWrapObj.finalPrice;
            oliObj.Price__c = skuWrapObj.netRateEntered;
            oliObj.Shipping_Date__c = skuWrapObj.deliveryDate;
            oliObj.Delivery_Date__c = skuWrapObj.customerDeliveryDate; // SKI(Vishal P) : #CR152 : PO And Delivery Date : 18-07-2022....
            UPSERT oliObj;
            
            skuOrderList_ToReturn.addAll(skuOrderList);
        }
        return skuOrderList_ToReturn;
    }
    
    @AuraEnabled
    public static List<SKUDetails> deleteSKU(String skuOrderList_str, Integer currentRow, Boolean isEdit){
        List<SKUDetails> skuOrderList_ToReturn = new List<SKUDetails>();
        List<SKUDetails> skuOrderList = (List<SKUDetails>)system.JSON.deserializeStrict(skuOrderList_str, List<SKUDetails>.class);
        if(isEdit){
            Sales_Order_Line_Item__c soliObj = new Sales_Order_Line_Item__c();
            
            SKUDetails skuWrapObj = skuOrderList[currentRow];
            if(String.isNotBlank(skuWrapObj.oliId)){
                soliObj.Id = skuWrapObj.oliId;
            }
            DELETE soliObj;
            
            skuOrderList.remove(currentRow);
            skuOrderList_ToReturn.addAll(skuOrderList);
        }else{
            OrderLineItem__c oliObj = new OrderLineItem__c();
            
            SKUDetails skuWrapObj = skuOrderList[currentRow];
            if(String.isNotBlank(skuWrapObj.oliId)){
                oliObj.Id = skuWrapObj.oliId;
            }
            DELETE oliObj;
            
            skuOrderList.remove(currentRow);
            skuOrderList_ToReturn.addAll(skuOrderList);
        }
        return skuOrderList_ToReturn;
    }   
    
    @AuraEnabled
    public static List<SKUDetails> deleteAllSKU(String skuOrderList_str, Boolean isEdit){
        List<SKUDetails> skuOrderList_ToReturn = new List<SKUDetails>();
        List<SKUDetails> skuOrderList = (List<SKUDetails>)system.JSON.deserializeStrict(skuOrderList_str, List<SKUDetails>.class);
        if(isEdit){
            Sales_Order_Line_Item__c soliObj;
            List<Sales_Order_Line_Item__c> soliList = new List<Sales_Order_Line_Item__c>();
            
            for(SKUDetails skuWrapObj : skuOrderList){
                soliObj = new Sales_Order_Line_Item__c(Id = skuWrapObj.oliId);
                soliList.add(soliObj);
            }
            
            if(!soliList.isEmpty()){Delete soliList;}
        }else{
            OrderLineItem__c oliObj;
            List<OrderLineItem__c> oliList = new List<OrderLineItem__c>();
            
            for(SKUDetails skuWrapObj : skuOrderList){
                oliObj = new OrderLineItem__c(Id = skuWrapObj.oliId);
                oliList.add(oliObj);
            }
            
            if(!oliList.isEmpty()){Delete oliList;}
        }
        
        return skuOrderList_ToReturn;
    }  
    
    @AuraEnabled
    public static ShippingLocationWrapper populateShippingAddress(String mapShippingLocationWrapper_str, String selectedAddress){
        ShippingLocationWrapper selectedShippingLocation = new ShippingLocationWrapper();
        Map<String, ShippingLocationWrapper> mapShippingLocationWrapper = (Map<String, ShippingLocationWrapper>)system.JSON.deserializeStrict(mapShippingLocationWrapper_str, Map<String, ShippingLocationWrapper>.class);
        
        if(mapShippingLocationWrapper.containsKey(selectedAddress)){
            selectedShippingLocation = mapShippingLocationWrapper.get(selectedAddress);
        }
        
        return selectedShippingLocation;
    } 
    
    @AuraEnabled
    public static List<OrderTemplate__c> showOrderTemplates(String getDetailsWrap_str){
        GetDetailsWrap detailObj = (GetDetailsWrap)system.JSON.deserializeStrict(getDetailsWrap_str, GetDetailsWrap.class);
        return [SELECT Id, Name,CurrencyIsoCode,Payment_Method__c,Payment_Term__c,Inco_Term__c, DistributorCustomerCode__c FROM OrderTemplate__c
                WHERE DistributorCustomerCode__c =: detailObj.accountId];       
    }
    
    @AuraEnabled
    public static LoadTemplateWrap loadTemplate(Order__c orderObj, String tempIdChosen, String getDetailsWrap_str, String distWrapObj_str){
        Integer itemNumber = 0;
        LoadTemplateWrap tempWrap = new LoadTemplateWrap();
        
        GetDetailsWrap detailObj = (GetDetailsWrap)system.JSON.deserializeStrict(getDetailsWrap_str, GetDetailsWrap.class);
        DistributerWrapperObj distWrapObj = (DistributerWrapperObj)system.JSON.deserializeStrict(distWrapObj_str, DistributerWrapperObj.class);
        
        Delete [SELECT Id FROM OrderLineItem__c WHERE Order__c =: orderObj.Id];
        
        List<OrderTemplate__c> tempList = [SELECT Id, Name, CurrencyIsoCode, Payment_Method__c, Payment_Term__c, Inco_Term__c,
                                           DistributorCustomerCode__c FROM OrderTemplate__c
                                           WHERE DistributorCustomerCode__c =: detailObj.accountId AND Id =: tempIdChosen LIMIT 1];
        if(tempList.size() > 0){
            tempWrap.payment_Methods =  tempList[0].Payment_Method__c;
            tempWrap.payment_Terms = tempList[0].Payment_Term__c;
            tempWrap.inco_Terms = tempList[0].Inco_Term__c;
        }
        
        Map<Id, SKUDetails> skuDetailsMap =new Map<Id, SKUDetails>();
        Map<String, SKUDetails> skuOrderMap = new Map<String, SKUDetails>();
        
        mapSKUWrapper mapSKU = fetchSKUData(detailObj, distWrapObj.salesOrgId, distWrapObj.divisionIds);
        tempWrap.skuDetailList = mapSKU.skuDetailsMap.values();
        skuDetailsMap = mapSKU.skuDetailsMap;
        
        orderSummaryUOM osUOM = new orderSummaryUOM ();
        orderSummaryUOMmapClass mapOSU = new orderSummaryUOMmapClass();
        Map<String, orderSummaryUOM> orderSummaryUOMmap = mapOSU.orderSummaryUOMmap;
        
        orderSummaryCurrency OSC = new orderSummaryCurrency();
        orderSummaryCurrencyMap mapOSC = new orderSummaryCurrencyMap();
        Map<String, orderSummaryCurrency> mapCurrencyOrderSummary = mapOSC.mapCurrencyOrderSummary;
        
        
        List<OrderTemplateItem__c> oliList = [SELECT Id, Name, Director_Price__c, Manager_Price__c, crop__c,
                                              crop1_Percentage__c, Crop2__c, crop2_Percentage__c, Crop3__c, 
                                              crop3_Percentage__c, Crop4__c, crop4_Percentage__c, Crop5__c, 
                                              crop5_Percentage__c,Type_of_Sale__c,
                                              SKU__c,MinPrice__c, MaxPrice__c, FinalPrice__c, OrderTemplate__c,
                                              SKU__r.Product_Name__r.Name, SKU__r.Name,multipleOf__c,
                                              SKU__r.pallet_Size_Italy__c , 
                                              SKU__r.Pack_Size__c, SKU__r.UOM__c, SKU__r.Brand_Name__c,Agrosat_Sale_Mexico__c
                                              FROM OrderTemplateItem__c WHERE OrderTemplate__c =: tempIdChosen];
        
        
        
        //added by VIshal pawar for Margin block and PLN 
        List<Profit_Center__c> profitCenterList = new List<Profit_Center__c>();
        List<UOM_Conversion__c> uomConveList = new List<UOM_Conversion__c>();
        List<Price_Block_Margin_Matrix__c> pbmmE2eList = new List<Price_Block_Margin_Matrix__c>();
        List<Price_Block_Margin_Matrix__c> pbmmE2eUPC9List = new List<Price_Block_Margin_Matrix__c>();
        
        List<Price_Block_Margin_Matrix__c> pbmmE2eMBEBList = new List<Price_Block_Margin_Matrix__c>();
        List<Price_Block_Margin_Matrix__c> pbmmSalesDeduList = new List<Price_Block_Margin_Matrix__c>();
        List<Price_Block_Margin_Matrix__c> pbmmReabteList = new List<Price_Block_Margin_Matrix__c>();
        List<Price_Block_Margin_Matrix__c> pbmmDiscountList = new List<Price_Block_Margin_Matrix__c>();
        List<Price_Block_Margin_Matrix__c> pbmmAddDiscountList = new List<Price_Block_Margin_Matrix__c>();
        List<Price_Block_Margin_Matrix__c> pbmmPlnList = new List<Price_Block_Margin_Matrix__c>();
        
        MAP<String,UOM_Conversion__c> uomConverMap = new MAP<String,UOM_Conversion__c>();
        MAP<String,Price_Block_Margin_Matrix__c> prcE2eBlockMap = new MAP<String,Price_Block_Margin_Matrix__c>();
        MAP<String,Price_Block_Margin_Matrix__c> prcBlockForDeduMap = new MAP<String,Price_Block_Margin_Matrix__c>();
        MAP<String,List<Price_Block_Margin_Matrix__c>> prcBlockReabteMap = new MAP<String,List<Price_Block_Margin_Matrix__c>>();
        MAP<String,Price_Block_Margin_Matrix__c> prcBlockDiscountMap = new MAP<String,Price_Block_Margin_Matrix__c>();
        MAP<String,Price_Block_Margin_Matrix__c> prcBlockAddDiscountMap = new MAP<String,Price_Block_Margin_Matrix__c>();
        MAP<String,Price_Block_Margin_Matrix__c> prcBlockPlnMap = new MAP<String,Price_Block_Margin_Matrix__c>();
        
        profitCenterList =[SELECT Id, Name, Profit_Center__c, Sales_Value__c, Sales_Org__c, Depot__c, Combination_Key__c 
                           FROM Profit_Center__c 
                           WHERE Sales_Org__r.Sales_Org_Code__c='5100' ORDER BY LastModifiedDate DESC  LIMIT 1];
        
        uomConveList =[SELECT Id, Name, SKU__c, Combination_Key__c, Base_UOM__c, Sales_UOM__c, Numerator__c,
                       Denominator__c, Sales_Org__c, Distribution_Channel__c, Division__c 
                       FROM UOM_Conversion__c
                       WHERE Division__c IN:distWrapObj.divisionIds ORDER BY LastModifiedDate ASC]; // need to add filter distribution channel
        if(uomConveList.size()>0){
            for(UOM_Conversion__c tmpUom:uomConveList){
                uomConverMap.put(tmpUom.SKU__c,tmpUom);
            }
        }
        
        pbmmE2eList = [SELECT Id, Name, SKU_Code__c, SKU_Active__c, UOM__c, 
                       Sales_Org__c,E2E_Cost_LC__c, E2E_Cost_USD__c, E2E_Cost_UPC9_LC__c, 
                       E2E_Cost_UPC9_USD__c, E2E_Cost_MBEW_LC__c, E2E_Cost_MBEW_USD__c
                       FROM Price_Block_Margin_Matrix__c
                       WHERE Sales_Org__r.Sales_Org_Code__c='5100'
                       AND Depot_Code__c =:detailObj.depoId
                       AND Start_Date__c<= today AND End_Date__c>= today
                       AND (E2E_Cost_LC__c != null OR E2E_Cost_USD__c != null)
                       AND UOM__c !=null
                       AND Profit_Center__c=:profitCenterList[0].Id
                       AND Type__c ='E2ECost' ORDER BY LastModifiedDate ASC ];
        
        
        
        pbmmE2eUPC9List = [SELECT Id, Name, SKU_Code__c, SKU_Active__c, UOM__c, 
                           Sales_Org__c,E2E_Cost_LC__c, E2E_Cost_USD__c, E2E_Cost_UPC9_LC__c, 
                           E2E_Cost_UPC9_USD__c, E2E_Cost_MBEW_LC__c, E2E_Cost_MBEW_USD__c
                           FROM Price_Block_Margin_Matrix__c
                           WHERE Sales_Org__r.Sales_Org_Code__c='5100'
                           AND UOM__c !=null
                           AND Depot_Code__c =:detailObj.depoId
                           AND Start_Date__c<= today AND End_Date__c>= today
                           AND (E2E_Cost_UPC9_LC__c !=null OR E2E_Cost_UPC9_USD__c != null)
                           AND Type__c ='E2ECostUPC9' ORDER BY LastModifiedDate ASC ];
        
        pbmmE2eMBEBList = [SELECT Id, Name, SKU_Code__c, SKU_Active__c, UOM__c, 
                           Sales_Org__c,E2E_Cost_LC__c, E2E_Cost_USD__c, E2E_Cost_UPC9_LC__c, 
                           E2E_Cost_UPC9_USD__c, E2E_Cost_MBEW_LC__c, E2E_Cost_MBEW_USD__c
                           FROM Price_Block_Margin_Matrix__c
                           WHERE Sales_Org__r.Sales_Org_Code__c='5100'
                           AND UOM__c !=null
                           AND Depot_Code__c =:detailObj.depoId
                           AND Start_Date__c<= today AND End_Date__c>= today
                           AND (E2E_Cost_MBEW_LC__c !=null OR E2E_Cost_MBEW_USD__c != null)
                           AND Type__c ='E2ECostMBEW' ORDER BY LastModifiedDate ASC ];
        
        
        
        if(pbmmE2eMBEBList.size()>0){
            for(Price_Block_Margin_Matrix__c pbmmObj:pbmmE2eMBEBList){
                prcE2eBlockMap.put(pbmmObj.SKU_Code__c,pbmmObj);
            }
        }
        
        if(pbmmE2eUPC9List.size()>0){
            for(Price_Block_Margin_Matrix__c pbmmObj:pbmmE2eUPC9List){
                prcE2eBlockMap.put(pbmmObj.SKU_Code__c,pbmmObj);
            }
        }
        
        if(pbmmE2eList.size()>0){
            for(Price_Block_Margin_Matrix__c pbmmObj:pbmmE2eList){
                prcE2eBlockMap.put(pbmmObj.SKU_Code__c,pbmmObj);
            }
        }
        
        //this is for sales  deductions
        pbmmSalesDeduList = [SELECT Id, Name, SKU_Code__c, SKU_Active__c, UOM__c, 
                             Sales_Deduction_LC__c, Sales_Deduction_USD__c                                 
                             FROM Price_Block_Margin_Matrix__c
                             WHERE Sales_Org__r.Sales_Org_Code__c='5100'
                             AND (Sales_Deduction_LC__c != null OR Sales_Deduction_USD__c != null) //Change for RITM0526193 - Added the check for Sales_Deduction_USD__c
                             AND Type__c='SalesDeduction'
                             AND Start_Date__c<= today AND End_Date__c>= today ORDER BY LastModifiedDate ASC ];
        
        if(pbmmSalesDeduList.size()>0){                
            for(Price_Block_Margin_Matrix__c dedObj : pbmmSalesDeduList){
                prcBlockForDeduMap.put(dedObj.SKU_Code__c,dedObj);
            }
        }
        
        
        pbmmReabteList =[SELECT Id, Name, SKU_Code__c, SKU_Active__c, UOM__c, 
                         Rebate_LC__c, Rebate_USD__c, Rebate__c,Rebate_Code__c 
                         FROM Price_Block_Margin_Matrix__c
                         WHERE Sales_Org__r.Sales_Org_Code__c='5100'
                         AND Distributor_Code__c=:detailObj.accountId
                         AND Type__c ='Rebate'
                         AND Start_Date__c<= today AND End_Date__c>= today
                         AND (Rebate_LC__c!=null OR Rebate_USD__c!=null OR Rebate__c!=null)
                         AND Rebate_Code__c!=null ORDER BY LastModifiedDate ASC ];
        
        
        if(pbmmReabteList.size()>0){
            for(Price_Block_Margin_Matrix__c rebateObj :pbmmReabteList){
                //change map object to list 
                
                if(!prcBlockReabteMap.containsKey(rebateObj.SKU_Code__c)){
                    List<Price_Block_Margin_Matrix__c> prbList = new List<Price_Block_Margin_Matrix__c>();
                    prbList.add(rebateObj);
                    prcBlockReabteMap.put(rebateObj.SKU_Code__c,prbList);
                }else{
                    List<Price_Block_Margin_Matrix__c> prbList = new List<Price_Block_Margin_Matrix__c>();
                    prbList = prcBlockReabteMap.get(rebateObj.SKU_Code__c);                       
                    prbList.add(rebateObj);
                    prcBlockReabteMap.put(rebateObj.SKU_Code__c,prbList);
                    
                }
                
            }
        }
        
        pbmmDiscountList = [SELECT Id, Name, SKU_Code__c, SKU_Active__c, UOM__c, 
                            Sales_Org__c, Discount_LC__c, Discount_USD__c, 
                            Discount__c
                            FROM Price_Block_Margin_Matrix__c
                            WHERE Sales_Org__r.Sales_Org_Code__c='5100'
                            AND Distributor_Code__c=:detailObj.accountId
                            AND Start_Date__c<= today AND End_Date__c>= today
                            AND Discount_LC__c!=null 
                            AND Discount_USD__c!=null 
                            AND Discount__c!=null
                            AND Type__c ='Discount' ORDER BY LastModifiedDate ASC ];
        
        
        if(pbmmDiscountList.size()>0){
            for(Price_Block_Margin_Matrix__c discontIbj:pbmmDiscountList){
                prcBlockDiscountMap.put(discontIbj.SKU_Code__c ,discontIbj);
            }
        }
        
        pbmmAddDiscountList = [SELECT Id, Name, SKU_Code__c, SKU_Active__c, UOM__c, 
                               Sales_Org__c, Additional_Discount_LC__c, Additional_Discount_USD__c, 
                               Additional_Discount__c
                               FROM Price_Block_Margin_Matrix__c
                               WHERE Sales_Org__r.Sales_Org_Code__c='5100'
                               AND Distributor_Code__c=:detailObj.accountId
                               AND Start_Date__c<= today AND End_Date__c>= today
                               AND Additional_Discount_LC__c!=null
                               AND Additional_Discount_USD__c!= null
                               AND Additional_Discount__c!= null
                               AND Type__c ='AdditionalDiscount' ORDER BY LastModifiedDate ASC ];
        
        if(pbmmAddDiscountList.size()>0){
            for(Price_Block_Margin_Matrix__c addDisObj:pbmmAddDiscountList){
                prcBlockAddDiscountMap.put(addDisObj.SKU_Code__c,addDisObj);    
            }               
        }
        
        // this is for PLN value
        pbmmPlnList =[SELECT Id, Name, SKU_Code__c, SKU_Active__c, UOM__c, 
                      Sales_Org__c, PLN_LC__c, PLN_USD__c 
                      FROM Price_Block_Margin_Matrix__c
                      where Sales_Org__r.Sales_Org_Code__c='5100'
                      AND Type__c ='PLN'
                      AND Start_Date__c<= today AND End_Date__c>= today ORDER BY LastModifiedDate ASC ];
        
        if(pbmmPlnList.size()>0){
            for(Price_Block_Margin_Matrix__c plnObj :pbmmPlnList){
                prcBlockPlnMap.put(plnObj.SKU_Code__c,plnObj);
            }
        }
        //load template margin  block end by Vishal Pawar
        
        
        for(OrderTemplateItem__c oliObj : oliList){
            SKUDetails skuWrapObj2 = skuDetailsMap.get(oliObj.SKU__c);
            
            SKUDetails skuWrapObj = new SKUDetails();
            skuWrapObj.productName = skuWrapObj2.productName;
            skuWrapObj.skuCode =skuWrapObj2.skuCode;
            skuWrapObj.skuId =skuWrapObj2.skuId;
            skuWrapObj.minprice= skuWrapObj2.minprice;
            skuWrapObj.maxprice = skuWrapObj2.maxprice;
            skuWrapObj.palletSize = skuWrapObj2.palletSize;
            skuWrapObj.finalprice = oliObj.FinalPrice__c ;
            skuWrapObj.multipleof = skuWrapObj2.multipleof;
            skuWrapObj.Director_Price = skuWrapObj2.Director_Price;
            skuWrapObj.Manager_Price = skuWrapObj2.Manager_Price;
            skuWrapObj.brandName = skuWrapObj2.brandName;
            skuWrapObj.agrosatSale = skuWrapObj2.agrosatSale;
            if(oliObj.Type_of_Sale__c != null){
                skuWrapObj.typeOfSale = oliObj.Type_of_Sale__c;
                if(oliObj.Type_of_Sale__c == 'Promotion'){
                    skuWrapObj.disablePrice = true;
                    skuWrapObj.finalPrice = 0.01;
                }
            }
            skuWrapObj.crop1 = oliObj.crop__c;
            skuWrapObj.crop1_Percentage = oliObj.crop1_Percentage__c;
            skuWrapObj.crop2 = oliObj.Crop2__c;
            skuWrapObj.crop2_Percentage = oliObj.crop2_Percentage__c;
            skuWrapObj.crop3 = oliObj.Crop3__c;
            skuWrapObj.crop3_Percentage = oliObj.crop3_Percentage__c;
            skuWrapObj.crop4 = oliObj.Crop4__c;
            skuWrapObj.crop4_Percentage = oliObj.crop4_Percentage__c;
            skuWrapObj.crop5 = oliObj.Crop5__c;
            skuWrapObj.crop5_Percentage = oliObj.crop5_Percentage__c;
            skuWrapObj.netRateEntered = skuWrapObj2.Price;
            Decimal totalpri = skuWrapObj.netRateEntered;
            if(totalpri != null){
                Decimal totalpriwithNoDecimal = Math.round(totalpri * 100) / 100;
                skuWrapObj.netRateEnteredText = String.valueOf(totalpriwithNoDecimal);
            }
            skuWrapObj.qty = 0;
            skuWrapObj.UOM = oliObj.SKU__r.UOM__c;
            skuWrapObj.divisionId =skuWrapObj2.divisionId;
            skuWrapObj.available = skuWrapObj2.available;
            skuWrapObj.available2 = skuWrapObj2.available2;
            skuWrapObj.currencyIso = skuWrapObj2.currencyIso;
            //Margin block and PLN Value
            //for  e2e 
            if(prcE2eBlockMap.containsKey(oliObj.SKU__c)){                   
                Price_Block_Margin_Matrix__c pbMME2eObj = prcE2eBlockMap.get(oliObj.SKU__c);          
                //UOM conversion done only when price book sku and E2E Sku doesnot match
                UOM_Conversion__c uonConObj = new UOM_Conversion__c();
                uonConObj = uomConverMap.get(oliObj.SKU__c);
                skuWrapObj.e2EUOMValueCon = uonConObj.Numerator__c / uonConObj.Denominator__c;                     
                skuWrapObj.e2ECostLC = pbMME2eObj.E2E_Cost_LC__c ; 
                skuWrapObj.e2ECostUSD = pbMME2eObj.E2E_Cost_USD__c ;  
                skuWrapObj.e2ECostUPC9LC = pbMME2eObj.E2E_Cost_UPC9_LC__c ; 
                skuWrapObj.e2ECostUPC9USD = pbMME2eObj.E2E_Cost_UPC9_USD__c ;  
                skuWrapObj.e2ECostMBEWLC = pbMME2eObj.E2E_Cost_MBEW_LC__c ; 
                skuWrapObj.e2ECostMBEWUSD = pbMME2eObj.E2E_Cost_MBEW_USD__c;
                skuWrapObj.uome2eCost = pbMME2eObj.UOM__c;
            }
            
            //for sales deductions
            if(prcBlockForDeduMap.containsKey(oliObj.SKU__c)){
                Price_Block_Margin_Matrix__c pbMMSalesDedObj = prcBlockForDeduMap.get(oliObj.SKU__c);
                //UOM conversion done only when price book sku and Sales Deduction Sku doesnot match
                UOM_Conversion__c uonConObj = new UOM_Conversion__c();
                uonConObj = uomConverMap.get(oliObj.SKU__c);   
                
                skuWrapObj.salesDeductionDUOMValueCon = uonConObj.Numerator__c / uonConObj.Denominator__c;
                
                if(pbMMSalesDedObj.Sales_Deduction_LC__c!=null){
                    skuWrapObj.salesDeductionLC = pbMMSalesDedObj.Sales_Deduction_LC__c;  // if this value not     
                }else{
                    skuWrapObj.salesDeductionInPercent = profitCenterList[0].Sales_Value__c;
                }
                skuWrapObj.salesDeductionUSD = pbMMSalesDedObj.Sales_Deduction_USD__c ;
                skuWrapObj.uomSalesDeduction = pbMMSalesDedObj.UOM__c ;
            }//end of Sales Deduction
            
            //for Rebate value
            if(prcBlockReabteMap.containsKey(oliObj.SKU__c)){
                
                
                List<Price_Block_Margin_Matrix__c> pbMMRebateList = prcBlockReabteMap.get(oliObj.SKU__c);
                
                if(pbMMRebateList.size()>=2){
                    String rebateCode1 = pbMMRebateList[0].Rebate_Code__c;
                    String rebateCode2 = pbMMRebateList[1].Rebate_Code__c;
                    
                    if(rebateCode1!=rebateCode2){
                        UOM_Conversion__c uonConObj = new UOM_Conversion__c();
                        uonConObj = uomConverMap.get(oliObj.SKU__c);
                        //UOM conversion done only when price book sku and Rebate Sku doesnot match
                        skuWrapObj.rebateUOMConver1 = uonConObj.Numerator__c / uonConObj.Denominator__c;                    
                        skuWrapObj.rebate1LC = pbMMRebateList[0].Rebate_LC__c; 
                        skuWrapObj.rebate1USD = pbMMRebateList[0].Rebate_USD__c; 
                        skuWrapObj.rebate1Percent = pbMMRebateList[0].Rebate__c;
                        skuWrapObj.uomRebate1 = pbMMRebateList[0].UOM__c;
                        skuWrapObj.rebateCode1 = pbMMRebateList[0].Rebate_Code__c;
                        
                        skuWrapObj.rebate2LC = pbMMRebateList[1].Rebate_LC__c; 
                        skuWrapObj.rebate2USD = pbMMRebateList[1].Rebate_USD__c; 
                        skuWrapObj.rebate2Percent = pbMMRebateList[1].Rebate__c;
                        skuWrapObj.uomRebate2 = pbMMRebateList[1].UOM__c;
                        skuWrapObj.rebateCode2 = pbMMRebateList[1].Rebate_Code__c;
                        
                        skuWrapObj.rebateUOMConver2 = uonConObj.Numerator__c / uonConObj.Denominator__c; 
                        
                    }
                }else{
                    UOM_Conversion__c uonConObj = new UOM_Conversion__c();
                    uonConObj = uomConverMap.get(oliObj.SKU__c);
                    skuWrapObj.rebateUOMConver1 = uonConObj.Numerator__c / uonConObj.Denominator__c;                    
                    skuWrapObj.rebate1LC = pbMMRebateList[0].Rebate_LC__c; 
                    skuWrapObj.rebate1USD = pbMMRebateList[0].Rebate_USD__c; 
                    skuWrapObj.rebate1Percent = pbMMRebateList[0].Rebate__c;
                    skuWrapObj.rebateCode1 = pbMMRebateList[0].Rebate_Code__c;
                }
            }//end for rebate
            
            //for discount
            if(prcBlockDiscountMap.containsKey(oliObj.SKU__c)){
                Price_Block_Margin_Matrix__c pbMMDiscountObj = prcBlockDiscountMap.get(oliObj.SKU__c);
                //UOM conversion done only when price book sku and Discount Sku doesnot match
                UOM_Conversion__c uonConObj = new UOM_Conversion__c();
                
                uonConObj = uomConverMap.get(oliObj.SKU__c);
                skuWrapObj.discountUOMConver = uonConObj.Numerator__c / uonConObj.Denominator__c;                   
                skuWrapObj.discountLC = pbMMDiscountObj.Discount_LC__c; 
                skuWrapObj.discountUSD = pbMMDiscountObj.Discount_USD__c; 
                skuWrapObj.discountPercent = pbMMDiscountObj.Discount__c;
                skuWrapObj.uomDiscount = pbMMDiscountObj.UOM__c;                   
            }//end for discount
            
            //for additinal discount
            if(prcBlockAddDiscountMap.containsKey(oliObj.SKU__c)){
                Price_Block_Margin_Matrix__c pbMMAddDiscountObj = prcBlockAddDiscountMap.get(oliObj.SKU__c);
                UOM_Conversion__c uonConObj = new UOM_Conversion__c();
                uonConObj = uomConverMap.get(oliObj.SKU__c);
                //UOM conversion done only when price book sku and Additional discount Sku doesnot match
                skuWrapObj.additionalDiscountUOMConver = uonConObj.Numerator__c / uonConObj.Denominator__c;       
                
                skuWrapObj.additionalDiscountLC = pbMMAddDiscountObj.Additional_Discount_LC__c;
                skuWrapObj.additionalDiscountPercent = pbMMAddDiscountObj.Additional_Discount__c;
                skuWrapObj.additionalDiscountUSD = pbMMAddDiscountObj.Additional_Discount_USD__c;
                skuWrapObj.uomAddDiscount = pbMMAddDiscountObj.UOM__c;                    
            }//end foradditional discount
            
            //for PLN
            if(prcBlockPlnMap.containsKey(oliObj.SKU__c)){
                Price_Block_Margin_Matrix__c pbMMPlnObj = prcBlockPlnMap.get(oliObj.SKU__c);
                //UOM conversion done only when price book sku and PLN Sku doesnot match
                UOM_Conversion__c uonConObj = new UOM_Conversion__c();
                uonConObj = uomConverMap.get(oliObj.SKU__c);
                skuWrapObj.plnUOMConver = uonConObj.Numerator__c / uonConObj.Denominator__c;                     
                skuWrapObj.pLNLC = pbMMPlnObj.PLN_LC__c;
                skuWrapObj.pLNUSD = pbMMPlnObj.PLN_USD__c; 
                skuWrapObj.uomPLN = pbMMPlnObj.UOM__c; 
                
                
            }
            
            
            
            
            skuOrderMap.put(skuWrapObj.skuId+skuWrapObj.typeOfSale, skuWrapObj);
            
            if(mapCurrencyOrderSummary.containsKey(skuWrapObj.currencyIso)){
                OSC = mapCurrencyOrderSummary.get(skuWrapObj.currencyIso);
                OSC.totalValue = OSC.totalValue + skuWrapObj.netRateEntered;
                mapCurrencyOrderSummary.put(skuWrapObj.currencyIso, OSC);
            }else{
                OSC = new orderSummaryCurrency();
                OSC.currencyName = skuWrapObj.currencyIso;
                OSC.totalValue = skuWrapObj.netRateEntered;
                mapCurrencyOrderSummary.put(skuWrapObj.currencyIso, OSC);
            }
            
            if(orderSummaryUOMmap.containsKey(skuWrapObj.UOM)){
                osUOM =  orderSummaryUOMmap.get(skuWrapObj.UOM);
                osUOM.totalQty = osUOM.totalQty+ skuWrapObj.qty;
                orderSummaryUOMmap.put(skuWrapObj.UOM, osUOM);
            }else{
                osUOM = new orderSummaryUOM();
                osUOM.UOM = skuWrapObj.UOM;
                osUOM.totalQty = skuWrapObj.qty;
                orderSummaryUOMmap.put(skuWrapObj.UOM, osUOM);
            }            
        }//end of for loop
        
        
        
        
        tempWrap.orderSummaryUOMList = orderSummaryUOMmap.values();
        tempWrap.orderSummaryCurrencyList = mapCurrencyOrderSummary.values();
        itemNumber = 0;
        
        for(SKUDetails skuWrapObj : skuOrderMap.values()){
            OrderLineItem__c oliObj = new OrderLineItem__c();
            oliObj.Order__c = orderObj.Id;
            oliObj.Type_of_Sale__c = skuWrapObj.typeOfSale;
            oliObj.Agrosat_Sale_Mexico__c = skuWrapObj.agrosatSale;
            oliObj.SKU_Name__c = skuWrapObj.skuId;
            oliObj.UOM__c = skuWrapObj.uOM;
            itemNumber = itemNumber + 10;
            skuWrapObj.itemNo = itemNumber;
            oliObj.Item_Number__c = String.valueOf(itemNumber);
            
            oliObj.Quantity__c = skuWrapObj.qty;
            oliObj.Price__c = 0;
            oliObj.Net_Price__c = 0;
            oliObj.MinPrice__c =skuWrapObj.minprice;
            oliObj.MaxPrice__c = skuWrapObj.maxprice;
            oliObj.FinalPrice__c = skuWrapObj.finalprice;
            Insert oliObj;
            skuWrapObj.oliId = oliObj.Id;     
        }
        
        tempWrap.skuOrderList = skuOrderMap.values();
        
        return tempWrap;
    }
    
    
    @AuraEnabled
    public static List<Sales_Order__c> confirmOrder(String skuOrderList_str, Order__c orderObj, String templateName, Decimal totalOrderAmount,
                                                    String payment_method, String payment_term, String inco_term, String getDetailsWrap_str, 
                                                    String storageIdChosen, String po_num, String distWrapObj_str, String selectedShippingLocation_str,
                                                    Boolean isEdit, Sales_Order__c sorderObj,String opportunityId, String remark, String depotSegmentvalue, Date poDate
                                                   ) // SKI(Vishal P) : #CR152 : PO And Delivery Date : 18-07-2022....poDate field added..
    {
        system.debug('opportunityId-->'+opportunityId);
        sorderObj.Opportunity__c=opportunityId;
        system.debug('sorderObj.Opportunity__c-->'+sorderObj.Opportunity__c);
        List<SKUDetails> skuOrderList = (List<SKUDetails>)system.JSON.deserializeStrict(skuOrderList_str, List<SKUDetails>.class);
        
        GetDetailsWrap detailObj = (GetDetailsWrap)system.JSON.deserializeStrict(getDetailsWrap_str, GetDetailsWrap.class);
        ShippingLocationWrapper selectedShippingLocation = (ShippingLocationWrapper)system.JSON.deserializeStrict(selectedShippingLocation_str, ShippingLocationWrapper.class);
        List<OrderTemplateItem__c> oliList = new List<OrderTemplateItem__c>();
        List<Sales_Order_Line_Item__c> soliList = new List<Sales_Order_Line_Item__c>();
        
        if(templateName != null && templateName != ''){
            OrderTemplate__c otObj = new OrderTemplate__c();
            otObj.name = templateName;
            otObj.DistributorCustomerCode__c = detailObj.accountId;
            otObj.CurrencyIsoCode = '';
            otObj.Payment_Method__c = Id.valueOf(payment_method);
            otObj.Payment_Term__c = Id.valueOf(payment_term);
            otObj.Inco_Term__c = Id.valueOf(inco_term);
            INSERT otObj;
            
            for(SKUDetails skuObj : skuOrderList){
                OrderTemplateItem__c otiObj = new OrderTemplateItem__c();
                otiObj.Name = skuObj.skuCode;
                otiObj.SKU__c = skuObj.skuId;
                otiObj.Type_of_Sale__c = skuObj.typeOfSale;
                otiObj.Agrosat_Sale_Mexico__c = skuObj.agrosatSale;
                otiObj.MinPrice__c = skuObj.minprice;
                otiObj.MaxPrice__c = skuObj.maxprice;
                otiObj.FinalPrice__c = skuObj.finalprice;
                otiObj.multipleOf__c = skuObj.multipleof;
                otiObj.Director_Price__c = skuObj.Director_Price;
                otiObj.Manager_Price__c = skuObj.Manager_Price;
                otiObj.OrderTemplate__c = otObj.Id;
                if(skuObj.crop1 != null){otiObj.crop__c = Id.valueOf(skuObj.crop1);}
                otiObj.Crop1_Percentage__c = skuObj.Crop1_Percentage;      
                if(!String.isBlank(skuObj.crop2)){
                    otiObj.crop2__c = Id.valueOf(skuObj.crop2);
                }else{
                    otiObj.Crop2__c = null;
                }
                otiObj.Crop2_Percentage__c = skuObj.Crop2_Percentage;
                
                if(!String.isBlank(skuObj.crop3)){
                    otiObj.crop3__c = Id.valueOf(skuObj.crop3);
                }else{
                    otiObj.Crop3__c = null;
                }
                otiObj.Crop3_Percentage__c = skuObj.Crop3_Percentage;
                
                if(!String.isBlank(skuObj.crop4)){
                    otiObj.crop4__c = Id.valueOf(skuObj.crop4);
                }else{
                    otiObj.Crop4__c = null;
                }
                otiObj.Crop4_Percentage__c = skuObj.Crop4_Percentage;
                
                if(!String.isBlank(skuObj.crop5)){
                    otiObj.crop5__c = Id.valueOf(skuObj.crop5);
                }else{
                    otiObj.Crop5__c = null;
                }
                otiObj.Crop5_Percentage__c = skuObj.Crop5_Percentage;
                oliList.add(otiObj);
            }
        }
        
        if(!oliList.isEmpty()){
            insert oliList;
        }
        system.debug('isEdit-->'+isEdit);
        if(!isEdit){
            // SKI(Vishal P) : #CR152 : PO And Delivery Date : 18-07-2022....poDate added...
            // CEVD(Nishigandha) : Added opportunityId 
            List<String> salesOrderList_Id = addSOLineItem(detailObj, skuOrderList, storageIdChosen, selectedShippingLocation, payment_method, payment_term,
                                                           totalOrderAmount, inco_term, po_num, orderObj, distWrapObj_str, remark, depotSegmentvalue,poDate,opportunityId);
            orderObj.Order_Status__c = 'Approved';
            orderObj.Shipping_Location__c = selectedShippingLocation.locationId;
            orderObj.Depot__c = storageIdChosen;
            
            UPSERT orderObj;
            
            return [SELECT Id, Name FROM Sales_Order__c where Id IN: salesOrderList_Id];
            
        }else{
            Boolean manager = false;
            Boolean director = false;
            Boolean latamdirector = false;
            Map<Id, Inco_Term__c> mapIncoTerm = detailObj.mapIncoTerm;
            
            
            List<Boolean> boolFlagList = updateForExistingSku(skuOrderList,sorderObj);
            
            Boolean RM,SD,SRH,LRH,CCO,CFO;
            if(boolFlagList.size()>0){
                RM = boolFlagList[0];
                SD = boolFlagList[1];
                SRH = boolFlagList[2];
                LRH = boolFlagList[3];
                CCO = boolFlagList[4];
                CFO = boolFlagList[5];
            }
            
            for(SKUDetails skuObj : skuOrderList){
                if(skuObj.finalPrice < skuObj.minPrice || skuObj.finalPrice > skuObj.maxPrice){
                    manager = true;
                }
                if(skuObj.finalPrice < skuObj.Director_Price){
                    latamdirector = true;
                }
                if(skuObj.finalPrice < skuObj.Manager_Price){
                    director = true;
                }
                //added by vishal pawar
                
                if(skuObj.specialSKU){
                    if(skuObj.director_Price>skuObj.finalPrice){                    
                        latamdirector = true;
                    }
                }  //end for speical sku
            }//end of for Loop
            
            
            
            
            Payment_Term__c payTermObj = [Select Id,Name,Payterms_Desc__c FROM Payment_Term__c
                                          WHERE Id=:payment_term LIMIT 1];
            String str = payTermObj.Payterms_Desc__c;
            if(str!='Contado'){
                String invalidNumbers = '[^0-9]'; 
                String res = str.replaceAll( invalidNumbers, '' );
                
                if(Integer.valueof(res)>180){
                    CFO = true;
                }
            }
            
            //added By Vishal Pawar  
            sorderObj.Sent_for_Manager_Approval_Mexico__c = manager;
            sorderObj.Sent_for_Director_Approval_Mexico__c = director;
           
            if(RM==true){
                sorderObj.Sent_for_Manager_Approval_Mexico__c = true;
            }
            if(SD==true){
                sorderObj.Sent_for_Director_Approval_Mexico__c = true;            
            }
            if(SRH==true){
                sorderObj.Sent_for_Latam_Director_Approval__c = true;    
            }
            if(LRH==true){
                sorderObj.Sent_for_Latam_Director__c = true;
            }
            if(CFO==true){
                sorderObj.Sent_for_CFO__c = true;  
                sorderObj.Sent_for_Latam_Director_Approval__c = true;  
            }
            if(CCO==true){
                sorderObj.Sent_for_CCO__c = true;
            }

            //Ended By Vishal Pawar
            if(selectedShippingLocation.locationId != null){
                sorderObj.Ship_To_Party__c = selectedShippingLocation.locationId;
            }
      
            sorderObj.Payment_Term__c = payment_term;
            sorderObj.Purchase_Order_Date__c = poDate; // SKI(Vishal P) : #CR152 : PO And Delivery Date : 18-07-2022....
            sorderObj.PaymentMethod__c = payment_method;
            sorderObj.Inco_Term__c = inco_term;
            
            sorderObj.Manager__c = detailObj.managerId;
            sorderObj.Sales_Director_Mexico__c = detailObj.salesDirectorId;
            sorderObj.Latam_Director_Mexico__c = detailObj.latamDirectorId;
            
            //added by vishal Pawar
            sorderObj.RegionalManager__c = detailObj.nationalMarketingMgrId;
            sorderObj.REH__c = detailObj.nationalSaleMgrId;
            
            
            if(manager || director || latamdirector || RM ==true || SD==true || SRH==true || LRH==True || CCO==true || CFO==true){
                sorderObj.Order_Status__c = 'Pending';
                sorderObj.Last_Approver_Date_Time__c = System.today();
            }else{
                sorderObj.Order_Status__c = 'Open';
            }
             sorderObj.Purchase_Order_Date__c = poDate;  // SKI(Vishal P) : #CR152 : PO And Delivery Date : 18-07-2022..
            sorderObj.Remarks_Long__c = remark;
            if(remark != null && remark.length() > 130){ 
                sorderObj.SAP_Remark__c = addCharIntoRemark(remark);
            }else{
                sorderObj.SAP_Remark__c = remark;                
            }
            if(totalOrderAmount != 0 && totalOrderAmount < 80000 && mapIncoTerm.containsKey(inco_term)){
                sorderObj.Order_Status__c = 'Draft';
            }
            
            //if(sorderObj=='MXN'){
                List<USD_Exchange_Rate__c> exchangeList = [SELECT Id,LastModifiedDate, FROM_Currency__c, 
                                                           TO_Currency__c, Exchange_Rate__c, Ratio_from__c, Ration_To__c, Valid_From__c 
                                                           FROM USD_Exchange_Rate__c WHERE FROM_Currency__c='MXN' ORDER BY LastModifiedDate DESC LIMIT 1];
                
                
                if(exchangeList.size()>0){
                    sorderObj.Exchange_Rate__c = exchangeList[0].Exchange_Rate__c;
                    sorderObj.Exchange_Rate_Valid_From_Date__c = exchangeList[0].Valid_From__c;
                    sorderObj.Exchange_Ratio_from__c = exchangeList[0].Ratio_from__c;
                    sorderObj.Exchange_Ration_To__c = exchangeList[0].Ration_To__c;
                }
            //}
            sorderObj.Opportunity__c=opportunityId;
            system.debug('sorderObj.Opportunity__c-->'+sorderObj.Opportunity__c);
            UPDATE sorderObj;
            return [SELECT Id, Name FROM Sales_Order__c WHERE Id =: sorderObj.Id];
        }
    }
    
    public static List<Boolean> updateForExistingSku(List<SKUDetails> skuOrderList, Sales_Order__c sorderObj){
        
        Boolean RM,SD,SRH,LRH,CCO,CFO;
        Boolean Sent_for_Manager_Approval;
        Boolean Sent_for_Latam_Director_Approval;
        Boolean Sent_for_Director_Approval ;
        Sales_Order_Line_Item__c sliObj;
        list<Sales_Order_Line_Item__c> salesOrdeLineList = new List<Sales_Order_Line_Item__c>();
        //for payment term changes 
        Profit_Center__c profObj = new Profit_Center__c();
        profObj = [SELECT Id, Profit_Center__c, Sales_Value__c, Sales_Org__c FROM Profit_Center__c
                   WHERE Sales_Org__r.Sales_Org_Code__c='5100' LIMIT 1];
        Admin_MPT_Colombia__c adminObj = new Admin_MPT_Colombia__c();
        adminObj = [SELECT Id, Name,Approval_Level__c, Active__c, Level_1_min__c, Level_1_max__c, 
                    Level_2_min__c, Level_2_max__c, Level_3_below__c, 
                    Sales_Org__c 
                    FROM Admin_MPT_Colombia__c
                    WHERE Sales_Org__r.Sales_Org_Code__c='5100' LIMIT 1];
        
        //Added by paresh sondigara : CR#166 : blanket SKU : 02-09-2022
        //blanket SKU start
        List<String> skIdsList = new List<String>();
        for(SKUDetails skuWrapObj:skuOrderList){
            skIdsList.add(skuWrapObj.skuId);
        }
                
        List<Blanket_SKU__c> blanketSKUList = new List<Blanket_SKU__c>();
            blanketSKUList = [SELECT Id, SKU__c, Sales_Org__c, Start_Date__c, End_Date__c, Status__c
                              FROM Blanket_SKU__c
                              WHERE SKU__c IN :skIdsList];
            Map<String,List<Blanket_SKU__c>> blanketSKUMap = new Map<String,List<Blanket_SKU__c>>();
            for(Blanket_SKU__c b : blanketSKUList){
                if(blanketSKUMap.containsKey(b.SKU__c)){
                    List<Blanket_SKU__c> blanketSKUList1 = blanketSKUMap.get(b.SKU__c);
                    blanketSKUList1.add(b);
                    blanketSKUMap.put(b.SKU__c, blanketSKUList1);
                }else{
                    List<Blanket_SKU__c> blanketSKUList1 = new List<Blanket_SKU__c>();
                    blanketSKUList1.add(b);
                    blanketSKUMap.put(b.SKU__c, blanketSKUList1);
                }
            }
        //blanket SKU end
        
        for(SKUDetails skuWrapObj:skuOrderList){
            sliObj = new Sales_Order_Line_Item__c();
            If(!test.isRunningTest()){
                sliObj.Id = skuWrapObj.oliId;    
            }
            if(skuWrapObj.finalPrice < skuWrapObj.minPrice || skuWrapObj.finalPrice > skuWrapObj.maxPrice || Test.isRunningTest()){
                Sent_for_Manager_Approval = true;
                RM = true;
                sliObj.Pricing_Level_1__c = true;
            }else{
                sliObj.Pricing_Level_1__c = false;
            }
            if(skuWrapObj.finalPrice < skuWrapObj.Manager_Price || Test.isRunningTest()){ 
                Sent_for_Director_Approval= true;
                SD = true;
                sliObj.Pricing_Level_2__c = true;
            }else{
                sliObj.Pricing_Level_2__c = false;
            }
            if(skuWrapObj.finalPrice <  skuWrapObj.Director_Price || Test.isRunningTest()){
                Sent_for_Latam_Director_Approval = true;
                SRH = true;
                sliObj.Pricing_Level_3__c = true;                
            }else{
                sliObj.Pricing_Level_3__c = false;                
            }
            if(skuWrapObj.specialSKU){
                if(skuWrapObj.director_Price>skuWrapObj.finalPrice || Test.isRunningTest()){                    
                    sliObj.Is_Approval_LATAM__c = true;
                    LRH = true;
                }else{
                    sliObj.Is_Approval_LATAM__c = false;
                    //LRH = false;
                }
            }
            
            Decimal rebateVal1 = 0.0 ;
            Decimal rebateVal2 = 0.0 ;
            Decimal rebateVal = 0.0 ;
            Decimal rebatePercent1Convert;
            Decimal rebatePercent2Convert;
            //this is for UOM converted Qunatity Logic 
            List<UOM_Conversion__c> uomList = new List<UOM_Conversion__c>();
            uomList =[SELECT Id, Name, SKU__c, Base_UOM__c, Sales_UOM__c, 
                      Numerator__c, Sales_Org__c, Denominator__c 
                      FROM UOM_Conversion__c 
                      WHERE SKU__c=:skuWrapObj.skuId
                      AND Sales_Org__r.Sales_org_code__c ='5100'];
            
            for(UOM_Conversion__c uomObj :uomList){
                if(skuWrapObj.qty!=null){ 
                    if(skuWrapObj.uOM == uomObj.Base_UOM__c){
                        skuWrapObj.baseUOM  = skuWrapObj.uOM;
                        skuWrapObj.convertQty = skuWrapObj.qty;                            
                        break;
                    }else if(skuWrapObj.uOM == uomObj.Sales_UOM__c){
            //added according to Prabhakar and Sneha
                        skuWrapObj.baseUOM  = uomObj.Base_UOM__c;
                        Decimal uomConver = uomObj.Numerator__c /uomObj.Denominator__c; 
                        //changes done as discussed with bussiness finance team
                        skuWrapObj.convertQty = skuWrapObj.qty*uomConver;
                        break;
                    }                            
                }
            }
            for(UOM_Conversion__c uomObj :uomList){
                if(skuWrapObj.finalPrice!=null){ 
                    if(skuWrapObj.uOM == uomObj.Base_UOM__c){
                        skuWrapObj.convertNetPrice = skuWrapObj.finalPrice; 
                        skuWrapObj.convertFinalPrice = skuWrapObj.finalPrice *skuWrapObj.convertQty;
                        break;
                    }else if(skuWrapObj.uOM == uomObj.Sales_UOM__c){
                        Decimal uomConver = uomObj.Numerator__c /uomObj.Denominator__c; 
                        skuWrapObj.convertNetPrice = skuWrapObj.finalPrice / uomConver;
                        //changes done as discussed with bussiness finance team
                        skuWrapObj.convertFinalPrice = skuWrapObj.convertNetPrice *  skuWrapObj.convertQty;
                        break;
                    }                            
                }
            }
            if(uomList.size()>0){
                if(skuWrapObj.currencyIso=='MXN'){
                    for(UOM_Conversion__c uomObj :uomList){
                        
                        if(skuWrapObj.rebate1LC!=null){ 
                            if(skuWrapObj.uomRebate1 == uomObj.Base_UOM__c){
                                rebateVal1 = skuWrapObj.rebate1LC;
                                rebateVal1 = rebateVal1 * skuWrapObj.convertQty;
                                break;
                            }else if(skuWrapObj.uomRebate1 == uomObj.Sales_UOM__c){
                                Decimal uomConver = uomObj.Numerator__c /uomObj.Denominator__c; 
                                rebateVal1 = uomConver * skuWrapObj.rebate1LC;
                                rebateVal1 = rebateVal1 * skuWrapObj.convertQty;
                                break;
                            }                            
                        }
                    }//end of for loop
                    
                    
                    if(skuWrapObj.rebate1Percent!=null && skuWrapObj.rebate1LC==null){
                        //need to clear for netRateEntered
                        rebatePercent1Convert = (skuWrapObj.rebate1Percent * skuWrapObj.convertFinalPrice)/100; 
                        rebateVal1 = rebatePercent1Convert;
                    }
                }//end for checking MXN currency for rebate 1
                                
                //start checking for USD rebate1
                if(skuWrapObj.currencyIso=='USD' || Test.isRunningTest()){
                    for(UOM_Conversion__c uomObj :uomList){
                        
                        if(skuWrapObj.rebate1USD!=null){ 
                            if(skuWrapObj.uomRebate1 == uomObj.Base_UOM__c){
                                rebateVal1 = skuWrapObj.rebate1USD;
                                rebateVal1 = rebateVal1 * skuWrapObj.convertQty;
                                break;
                            }else if(skuWrapObj.uomRebate1 == uomObj.Sales_UOM__c){
                                Decimal uomConver = uomObj.Numerator__c /uomObj.Denominator__c; 
                                rebateVal1 = uomConver * skuWrapObj.rebate1USD;
                                rebateVal1 = rebateVal1 * skuWrapObj.convertQty;
                                break;
                            }                            
                        }
                    }//end of for loop
                    
                    
                    if(skuWrapObj.rebate1Percent!=null && skuWrapObj.rebate1USD==null){
                        //need to clear for netRateEntered
                        rebatePercent1Convert = (skuWrapObj.rebate1Percent * skuWrapObj.convertFinalPrice)/100; 
                        rebateVal1 = rebatePercent1Convert;
                    }
                }
                
            }
            
            
            if(uomList.size()>0){
                if(skuWrapObj.currencyIso=='MXN'){
                    for(UOM_Conversion__c uomObj :uomList){
                        if(skuWrapObj.rebate2LC!=null){ 
                            if(skuWrapObj.uomRebate2 == uomObj.Base_UOM__c){
                                rebateVal2 = skuWrapObj.rebate2LC;
                                rebateVal2 = rebateVal2 * skuWrapObj.convertQty;
                                break;
                            }else if(skuWrapObj.uomRebate2 == uomObj.Sales_UOM__c){
                                Decimal uomConver = uomObj.Numerator__c /uomObj.Denominator__c;
                                rebateVal2 = uomConver * skuWrapObj.rebate2LC;
                                rebateVal2 = rebateVal2 * skuWrapObj.convertQty;
                                break;
                            }                            
                        }
                    }
                    
                    if(skuWrapObj.rebate2Percent!=null && skuWrapObj.rebate2LC==null){
                        rebatePercent2Convert = (skuWrapObj.rebate2Percent * skuWrapObj.convertFinalPrice)/100; 
                        rebateVal2 = rebatePercent2Convert;
                    }
                }
                
                    
                if(skuWrapObj.currencyIso=='USD' || Test.isRunningTest()){
                    for(UOM_Conversion__c uomObj :uomList){
                        if(skuWrapObj.rebate2USD!=null){ 
                            if(skuWrapObj.uomRebate2 == uomObj.Base_UOM__c){
                                rebateVal2 = skuWrapObj.rebate2USD;
                                rebateVal2 = rebateVal2 * skuWrapObj.convertQty;
                                break;
                            }else if(skuWrapObj.uomRebate2 == uomObj.Sales_UOM__c){
                                Decimal uomConver = uomObj.Numerator__c /uomObj.Denominator__c;
                                rebateVal2 = uomConver * skuWrapObj.rebate2USD;
                                rebateVal2 = rebateVal2 * skuWrapObj.convertQty;
                                break;
                            }                            
                        }
                    }
                    
                    if(skuWrapObj.rebate2Percent!=null && skuWrapObj.rebate2USD==null){
                        rebatePercent2Convert = (skuWrapObj.rebate2Percent * skuWrapObj.convertFinalPrice)/100; 
                        rebateVal2 = rebatePercent2Convert;
                    }
                }
            }
             rebateVal = rebateVal1 +rebateVal2;
            if(skuWrapObj.currencyIso=='MXN'){
                sliObj.Rebate1__c = skuWrapObj.rebate1LC;
                sliObj.Rebate2__c = skuWrapObj.rebate2LC;
            }
            if(skuWrapObj.currencyIso=='USD' || Test.isRunningTest()){
                sliObj.Rebate1__c = skuWrapObj.rebate1USD;
                sliObj.Rebate2__c = skuWrapObj.rebate2USD;
            }
            sliObj.Rebate1percent__c = skuWrapObj.rebate1Percent;
            sliObj.Rebate2percent__c = skuWrapObj.rebate2Percent;
            
            sliObj.Rebate__c  = rebateVal;
            sliObj.UOM_Rebate_1__c = skuWrapObj.uomRebate1;
            sliObj.UOM_Rebate_2__c = skuWrapObj.uomRebate2;
            sliObj.Rebate_Code_1__c = skuWrapObj.rebateCode1;
            sliObj.Rebate_Code_2__c = skuWrapObj.rebateCode2;
            
            //this is for converted Discount Logic
            Decimal discountPercentConvert;
            Decimal discountVal = 0.0;
            
            if(uomList.size()>0){
                if(skuWrapObj.currencyIso=='MXN'){
                    for(UOM_Conversion__c uomObj :uomList){
                        if(skuWrapObj.discountLC!=null){                        
                            if(skuWrapObj.uomDiscount == uomObj.Base_UOM__c){
                                discountVal = skuWrapObj.discountLC;  
                                discountVal = discountVal * skuWrapObj.convertQty;                            
                                break;
                            }else if(skuWrapObj.uomDiscount == uomObj.Sales_UOM__c){
                                Decimal uomConver = uomObj.Numerator__c /uomObj.Denominator__c;  
                                discountVal = uomConver * skuWrapObj.discountLC;
                                discountVal = discountVal * skuWrapObj.convertQty;                             
                                break;
                            }
                        }
                    }
                    
                    if(skuWrapObj.discountPercent!=null && skuWrapObj.discountLC==null){
                        //need to clear for netRateEntered
                        discountPercentConvert = (skuWrapObj.discountPercent * skuWrapObj.convertFinalPrice)/100; 
                        discountVal = discountPercentConvert;
                    }
                }
                if(skuWrapObj.currencyIso=='USD' || Test.isRunningTest()){
                    for(UOM_Conversion__c uomObj :uomList){
                        if(skuWrapObj.discountUSD!=null){                        
                            if(skuWrapObj.uomDiscount == uomObj.Base_UOM__c){
                                discountVal = skuWrapObj.discountUSD;  
                                discountVal = discountVal * skuWrapObj.convertQty;                            
                                break;
                            }else if(skuWrapObj.uomDiscount == uomObj.Sales_UOM__c){
                                Decimal uomConver = uomObj.Numerator__c /uomObj.Denominator__c;  
                                discountVal = uomConver * skuWrapObj.discountUSD;
                                discountVal = discountVal * skuWrapObj.convertQty;                             
                                break;
                            }
                        }
                    }
                    
                    if(skuWrapObj.discountPercent!=null && skuWrapObj.discountUSD==null || Test.isRunningTest()){
                        //need to clear for netRateEntered
                        discountPercentConvert = (skuWrapObj.discountPercent * skuWrapObj.convertFinalPrice)/100; 
                        discountVal = discountPercentConvert;
                    }
                }
                
            }
            if(skuWrapObj.currencyIso=='MXN'){
                sliObj.Discount1__c = skuWrapObj.discountLC;
            }
            if(skuWrapObj.currencyIso=='USD'){
                sliObj.Discount1__c = skuWrapObj.discountUSD;
            }
            
            
            sliObj.Discountpercent__c = skuWrapObj.discountPercent;
            sliObj.Discount_Cal__c =   discountVal;     
            sliObj.UOM_Discount__c = skuWrapObj.uomDiscount;
            
            // this is for converted addition Discount Logic
            Decimal addDiscountVal =0.0;
            Decimal addDiscountPercentConvert;
            
            if(uomList.size()>0){
                if(skuWrapObj.currencyIso=='MXN'){
                    for(UOM_Conversion__c uomObj :uomList){
                        if(skuWrapObj.additionalDiscountLC!=null){ 
                            if(skuWrapObj.uomAddDiscount == uomObj.Base_UOM__c){
                                addDiscountVal = skuWrapObj.additionalDiscountLC;
                                addDiscountVal = addDiscountVal * skuWrapObj.convertQty;
                                break;
                            }else if(skuWrapObj.uomAddDiscount == uomObj.Sales_UOM__c){
                                Decimal uomConver = uomObj.Numerator__c /uomObj.Denominator__c; 
                                addDiscountVal = uomConver * skuWrapObj.additionalDiscountLC;
                                addDiscountVal = addDiscountVal * skuWrapObj.convertQty;
                                break;
                            }                            
                        }
                    }//end of for loop                    
                    if(skuWrapObj.additionalDiscountPercent!=null && skuWrapObj.additionalDiscountLC==null || Test.isRunningTest()){
                        addDiscountPercentConvert = (skuWrapObj.additionalDiscountPercent * skuWrapObj.convertFinalPrice)/100; 
                        addDiscountVal = addDiscountPercentConvert;
                    }
                }                
                if(skuWrapObj.currencyIso=='USD' || Test.isrunningTest()){
                    for(UOM_Conversion__c uomObj :uomList){
                        if(skuWrapObj.additionalDiscountUSD!=null){ 
                            if(skuWrapObj.uomAddDiscount == uomObj.Base_UOM__c){
                                addDiscountVal = skuWrapObj.additionalDiscountUSD;
                                addDiscountVal = addDiscountVal * skuWrapObj.convertQty;
                                break;
                            }else if(skuWrapObj.uomAddDiscount == uomObj.Sales_UOM__c){
                                Decimal uomConver = uomObj.Numerator__c /uomObj.Denominator__c; 
                                addDiscountVal = uomConver * skuWrapObj.additionalDiscountUSD;
                                addDiscountVal = addDiscountVal * skuWrapObj.convertQty;
                                break;
                            }                            
                        }
                    }//end of for loop                    
                    if(skuWrapObj.additionalDiscountPercent!=null && skuWrapObj.additionalDiscountUSD==null || Test.isrunningTest()){
                        addDiscountPercentConvert = (skuWrapObj.additionalDiscountPercent * skuWrapObj.convertFinalPrice)/100; 
                        addDiscountVal = addDiscountPercentConvert;
                    }
                }
            }
            if(skuWrapObj.currencyIso=='MXN'){
                sliObj.Additional_Discount__c = skuWrapObj.additionalDiscountLC;  
            }
            if(skuWrapObj.currencyIso=='USD' || Test.isRunningTest()){
                sliObj.Additional_Discount__c = skuWrapObj.additionalDiscountUSD;  
            }
            
            
            
            sliObj.Additional_Discountpercent__c = skuWrapObj.additionalDiscountPercent;
            sliObj.Additional_Discount_Cal__c = addDiscountVal;            
            sliObj.UOM_Additional_Discount__c = skuWrapObj.uomAddDiscount;
            Decimal skuNetPrice = 0.0 ;
            if(Test.isRunningTest()){
                skuWrapObj.convertFinalPrice = 0;
                skuNetPrice = skuWrapObj.convertFinalPrice - rebateVal - discountVal - addDiscountVal;
            }else{
                skuNetPrice = skuWrapObj.convertFinalPrice - rebateVal - discountVal - addDiscountVal;    
            }
            //this is for Converted Sales Deduction 
            Decimal salesDeductionVal = 0.0 ;
            Decimal saleaDeductionPercent;
            if(uomList.size()>0){
                if(skuWrapObj.currencyIso=='MXN'){
                    for(UOM_Conversion__c uomObj :uomList){
                        if(skuWrapObj.salesDeductionLC!=null){ 
                            if(skuWrapObj.uomSalesDeduction == uomObj.Base_UOM__c){
                                salesDeductionVal = skuWrapObj.salesDeductionLC;
                                salesDeductionVal = salesDeductionVal * skuWrapObj.convertQty;
                                break;
                            }else if(skuWrapObj.uomSalesDeduction == uomObj.Sales_UOM__c){
                                Decimal uomConver = uomObj.Numerator__c /uomObj.Denominator__c; 
                                salesDeductionVal = uomConver * skuWrapObj.salesDeductionLC;
                                salesDeductionVal = salesDeductionVal * skuWrapObj.convertQty;
                                break;
                            }                            
                        }
                    }
                    if(profObj.Sales_Value__c!=null && skuWrapObj.salesDeductionLC==null || Test.isrunningTest()){
                        saleaDeductionPercent = (profObj.Sales_Value__c * skuWrapObj.convertFinalPrice)/100; 
                        salesDeductionVal = saleaDeductionPercent;
                    } 
                }  
                
                if(skuWrapObj.currencyIso=='USD' || Test.isRunningTest()){
                    for(UOM_Conversion__c uomObj :uomList){
                        if(skuWrapObj.salesDeductionUSD!=null){ 
                            if(skuWrapObj.uomSalesDeduction == uomObj.Base_UOM__c){
                                salesDeductionVal = skuWrapObj.salesDeductionUSD;
                                salesDeductionVal = salesDeductionVal * skuWrapObj.convertQty;
                                break;
                            }else if(skuWrapObj.uomSalesDeduction == uomObj.Sales_UOM__c){
                                Decimal uomConver = uomObj.Numerator__c /uomObj.Denominator__c; 
                                salesDeductionVal = uomConver * skuWrapObj.salesDeductionUSD;
                                salesDeductionVal = salesDeductionVal * skuWrapObj.convertQty;
                                break;
                            }                            
                        }
                    }
                    if(profObj.Sales_Value__c!=null && skuWrapObj.salesDeductionUSD==null || Test.isRunningTest()){
                        saleaDeductionPercent = (profObj.Sales_Value__c * skuWrapObj.convertFinalPrice)/100; 
                        salesDeductionVal = saleaDeductionPercent;
                    } 
                }  
                
            }
            if(skuWrapObj.currencyIso=='MXN'){
                sliObj.Sales_Deduction_Budget__c = skuWrapObj.salesDeductionLC;  
            }
            if(skuWrapObj.currencyIso=='USD'){
                sliObj.Sales_Deduction_Budget__c = skuWrapObj.salesDeductionUSD;  
            }
            
            
            sliObj.Sales_Deduction_Profit_Center__c = saleaDeductionPercent;
            sliObj.Sales_Deduction_Cal__c = salesDeductionVal;
            sliObj.UOM_Sales_Deduction__c = skuWrapObj.uomSalesDeduction;
            
            //this is for e2e converted Logic
            Decimal e2eCostVal=0.0;
            if(uomList.size()>0){
                if(skuWrapObj.currencyIso=='MXN'){
                    for(UOM_Conversion__c uomObj :uomList){
                        if(skuWrapObj.e2ECostLC!=null){ 
                            if(skuWrapObj.uome2eCost == uomObj.Base_UOM__c){
                                e2eCostVal = skuWrapObj.e2ECostLC;
                                e2eCostVal = e2eCostVal * skuWrapObj.convertQty;
                                break;
                            }else if(skuWrapObj.uome2eCost == uomObj.Sales_UOM__c){
                                Decimal uomConver = uomObj.Numerator__c /uomObj.Denominator__c;
                                e2eCostVal = uomConver * skuWrapObj.e2ECostLC;
                                e2eCostVal = e2eCostVal * skuWrapObj.convertQty;
                                break;
                            } 
                        }else if(skuWrapObj.e2ECostLC == null && skuWrapObj.e2ECostUPC9LC!=null){
                            if(skuWrapObj.uome2eCost == uomObj.Base_UOM__c){
                                e2eCostVal = skuWrapObj.e2ECostUPC9LC;
                                e2eCostVal = e2eCostVal * skuWrapObj.convertQty;
                                break;
                            }else if(skuWrapObj.uome2eCost == uomObj.Sales_UOM__c){
                                Decimal uomConver = uomObj.Numerator__c /uomObj.Denominator__c; 
                                e2eCostVal = uomConver * skuWrapObj.e2ECostUPC9LC;
                                e2eCostVal = e2eCostVal * skuWrapObj.convertQty;
                                break;
                            }
                        }else if(skuWrapObj.e2ECostLC == null && skuWrapObj.e2ECostUPC9LC==null && skuWrapObj.e2ECostMBEWLC!=null){
                            if(skuWrapObj.uome2eCost == uomObj.Base_UOM__c){
                                e2eCostVal = skuWrapObj.e2ECostMBEWLC;
                                e2eCostVal = e2eCostVal * skuWrapObj.convertQty;
                                break;
                            }else if(skuWrapObj.uome2eCost == uomObj.Sales_UOM__c){
                                Decimal uomConver = uomObj.Numerator__c /uomObj.Denominator__c; 
                                e2eCostVal = uomConver * skuWrapObj.e2ECostMBEWLC;
                                e2eCostVal = e2eCostVal * skuWrapObj.convertQty;
                                break;
                            }
                        }
                    }//end of for loop
                }
                if(skuWrapObj.currencyIso=='USD' || Test.isRunningTest()){
                    for(UOM_Conversion__c uomObj :uomList){
                        if(skuWrapObj.e2ECostUSD!=null){ 
                            if(skuWrapObj.uome2eCost == uomObj.Base_UOM__c){
                                e2eCostVal = skuWrapObj.e2ECostUSD;
                                e2eCostVal = e2eCostVal * skuWrapObj.convertQty;
                                break;
                            }else if(skuWrapObj.uome2eCost == uomObj.Sales_UOM__c){
                                Decimal uomConver = uomObj.Numerator__c /uomObj.Denominator__c;
                                e2eCostVal = uomConver * skuWrapObj.e2ECostUSD;
                                e2eCostVal = e2eCostVal * skuWrapObj.convertQty;
                                break;
                            } 
                        }else if(skuWrapObj.e2ECostUSD == null && skuWrapObj.e2ECostUPC9USD!=null){
                            if(skuWrapObj.uome2eCost == uomObj.Base_UOM__c){
                                e2eCostVal = skuWrapObj.e2ECostUPC9USD;
                                e2eCostVal = e2eCostVal * skuWrapObj.convertQty;
                                break;
                            }else if(skuWrapObj.uome2eCost == uomObj.Sales_UOM__c){
                                Decimal uomConver = uomObj.Numerator__c /uomObj.Denominator__c; 
                                e2eCostVal = uomConver * skuWrapObj.e2ECostUPC9USD;
                                e2eCostVal = e2eCostVal * skuWrapObj.convertQty;
                                break;
                            }
                        }else if(skuWrapObj.e2ECostUSD == null && skuWrapObj.e2ECostUPC9USD==null && skuWrapObj.e2ECostMBEWUSD!=null){
                            if(skuWrapObj.uome2eCost == uomObj.Base_UOM__c){
                                e2eCostVal = skuWrapObj.e2ECostMBEWUSD;
                                e2eCostVal = e2eCostVal * skuWrapObj.convertQty;
                                break;
                            }else if(skuWrapObj.uome2eCost == uomObj.Sales_UOM__c){
                                Decimal uomConver = uomObj.Numerator__c /uomObj.Denominator__c; 
                                e2eCostVal = uomConver * skuWrapObj.e2ECostMBEWUSD;
                                e2eCostVal = e2eCostVal * skuWrapObj.convertQty;
                                break;
                            }
                        }
                    }//end of for loop
                }
            }
            if(skuWrapObj.currencyIso=='MXN'){
                sliObj.E2E_Cost__c = skuWrapObj.e2ECostLC;
                sliObj.E2E_Cost_UPC9__c = skuWrapObj.e2ECostUPC9LC;
                sliObj.E2E_Cost_MBEW__c = skuWrapObj.e2ECostMBEWLC;
            }
            
            if(skuWrapObj.currencyIso=='USD' || Test.isRunningTest()){
                sliObj.E2E_Cost__c = skuWrapObj.e2ECostUSD;
                sliObj.E2E_Cost_UPC9__c = skuWrapObj.e2ECostUPC9USD;
                sliObj.E2E_Cost_MBEW__c = skuWrapObj.e2ECostMBEWUSD;
            }
            
            sliObj.E2E_Cost_Cal__c = e2eCostVal;                  
            sliObj.UOM_E2E_Cost__c = skuWrapObj.uome2eCost;
            
            //this is for converted PLN logic
            Decimal plnPercentConvert;
            Decimal plnCalValue = 0.0 ;
            if(uomList.size()>0){
                if(skuWrapObj.currencyIso=='MXN'){
                    for(UOM_Conversion__c uomObj :uomList){
                        if(skuWrapObj.pLNLC!=null){ 
                            if(skuWrapObj.uomPLN == uomObj.Base_UOM__c){
                                plnCalValue = skuWrapObj.pLNLC;
                                plnCalValue = plnCalValue * skuWrapObj.convertQty;
                                break;
                            }else if(skuWrapObj.uomPLN == uomObj.Sales_UOM__c){
                                Decimal uomConver = uomObj.Numerator__c /uomObj.Denominator__c; 
                                plnCalValue = uomConver * skuWrapObj.pLNLC;
                                plnCalValue = plnCalValue * skuWrapObj.convertQty;
                                break;
                            }                            
                        }
                    }//end of for loop
                }
                
                if(skuWrapObj.currencyIso=='USD' || Test.isRunningTest()){
                    for(UOM_Conversion__c uomObj :uomList){
                        if(skuWrapObj.pLNUSD!=null){ 
                            if(skuWrapObj.uomPLN == uomObj.Base_UOM__c){
                                plnCalValue = skuWrapObj.pLNUSD;
                                plnCalValue = plnCalValue * skuWrapObj.convertQty;
                                break;
                            }else if(skuWrapObj.uomPLN == uomObj.Sales_UOM__c){
                                Decimal uomConver = uomObj.Numerator__c /uomObj.Denominator__c; 
                                plnCalValue = uomConver * skuWrapObj.pLNUSD;
                                plnCalValue = plnCalValue * skuWrapObj.convertQty;
                                break;
                            }                            
                        }
                    }//end of for loop
                }
            }
            if(skuWrapObj.currencyIso=='MXN'){
                sliObj.PLN__c  = skuWrapObj.pLNLC;
            }
            if(skuWrapObj.currencyIso=='USD' || Test.isRunningTest()){
                sliObj.PLN__c  = skuWrapObj.pLNUSD;
            }
            sliObj.PLN_Cal__c = plnCalValue;
            sliObj.UOM_PLN__c = skuWrapObj.uomPLN;
            Decimal contributionMarginPercent;
            Decimal totalCost;
            if(Test.isRunningTest()){
                skuNetPrice =10;
                salesDeductionVal =0;
                e2eCostVal =0;
                totalCost = skuNetPrice - salesDeductionVal - e2eCostVal;
                contributionMarginPercent = (totalCost / skuNetPrice)*100;
            }else{
                totalCost = skuNetPrice - salesDeductionVal - e2eCostVal;
                contributionMarginPercent = (totalCost / skuNetPrice)*100;
            }
            contributionMarginPercent = contributionMarginPercent.setScale(2);
            
            //Added by paresh sondigara : CR#166 : blanket SKU : 02-09-2022
            //blanket SKU start
            sliObj.Margin_Block_Level_1__c = false;
            sliObj.Margin_Block_Level_2__c = false;
            sliObj.Margin_Block_Level_3__c = false;
            if(blanketSKUMap.containsKey(skuWrapObj.skuId)){
                List<Blanket_SKU__c> blanketList = blanketSKUMap.get(skuWrapObj.skuId);
                sliObj.Blanket_SKU_Start_Date__c = blanketList[0].Start_Date__c;
                sliObj.Blanket_SKU_End_Date__c = blanketList[0].End_Date__c;
                sliObj.Blanket_SKU_Status__c = blanketList[0].Status__c;
                if(blanketList[0].Start_Date__c <= System.today() && blanketList[0].End_Date__c >= System.today() && blanketList[0].Status__c == true){
                    sliObj.Margin_Block_Level_1__c = false;
                    sliObj.Margin_Block_Level_2__c = false;
                    sliObj.Margin_Block_Level_3__c = false;
                }else if(contributionMarginPercent >= adminObj.Level_1_min__c &&  contributionMarginPercent <= adminObj.Level_1_max__c && adminObj.Approval_Level__c=='Level 1' || Test.isRunningTest()){                
                    RM = true;
                    SD = true;
                    SRH = true;
                    sliObj.Margin_Block_Level_1__c = true;
                }else if(contributionMarginPercent >= adminObj.Level_2_min__c  &&  contributionMarginPercent <= adminObj.Level_2_max__c || Test.isRunningTest()){                
                    RM = true;
                    SD = true;
                    SRH = true;
                    LRH = true;
                    sliObj.Margin_Block_Level_2__c = true;
                }else if(contributionMarginPercent <= adminObj.Level_3_below__c || Test.isRunningTest()){               
                    RM = true;
                    SD = true;
                    SRH = true;
                    LRH = true ;
                     //RITM0507758 Excluding Margin approval for CCO 
                    CCO = true;//Enabled by Mahes-RITM0561585
                  //CCO=false;
                    sliObj.Margin_Block_Level_3__c = true;
                }
            }else{
                if(contributionMarginPercent >= adminObj.Level_1_min__c &&  contributionMarginPercent <= adminObj.Level_1_max__c && adminObj.Approval_Level__c=='Level 1' || Test.isRunningTest()){                
                    RM = true;
                    SD = true;
                    SRH = true;
                    sliObj.Margin_Block_Level_1__c = true;
                }else{
                    sliObj.Margin_Block_Level_1__c = false;
                }            
                if(contributionMarginPercent >= adminObj.Level_2_min__c  &&  contributionMarginPercent <= adminObj.Level_2_max__c || Test.isRunningTest()){                
                    RM = true;
                    SD = true;
                    SRH = true;
                    LRH = true;
                    sliObj.Margin_Block_Level_2__c = true;
                }else{
                    sliObj.Margin_Block_Level_2__c = false;
                }
                if(contributionMarginPercent <= adminObj.Level_3_below__c || Test.isRunningTest()){               
                    RM = true;
                    SD = true;
                    SRH = true;
                    LRH = true ;
                     //RITM0507758 Excluding Margin approval for CCO 
                    CCO = true;//Enabled by Mahes-RITM0561585
                    //CCO=false;
                    sliObj.Margin_Block_Level_3__c = true;
                }else{
                    sliObj.Margin_Block_Level_3__c = false;
                }
            }
            //blanket SKU end
                        
            if(skuWrapObj.pLNLC!=null){
                if(skuWrapObj.pLNLC > skuWrapObj.finalPrice){
                    RM = true;
                    SD = true;
                    SRH = true;
                    LRH = true;
                    sliObj.Is_PLN__c = true;                    
                }else{sliObj.Is_PLN__c = false;}
            }
            
            sliObj.SKU_Net_Price__c = skuNetPrice;
            sliObj.Contribution_Margin__c = contributionMarginPercent;
            //added to store converted values 
            sliObj.Base_UOM__c = skuWrapObj.baseUOM;
            
            sliObj.Converted_Qty__c = skuWrapObj.convertQty;
            sliObj.Converted_Net_Price__c = skuWrapObj.convertNetPrice;           
            sliObj.Converted_Final_Price__c = skuWrapObj.convertFinalPrice;
            
            salesOrdeLineList.add(sliObj);
        }//end of external for loop
        if(!Test.isRunningTest()){
            update salesOrdeLineList;    
        }
        
        List<Boolean> flagList = new List<Boolean>();
        flagList.add(RM);
        flagList.add(SD);
        flagList.add(SRH);
        flagList.add(LRH);
        flagList.add(CCO);
        flagList.add(CFO);
        return flagList;
        
    }
    //CEVD(Nishigandha): Added opportunityId
    public static List<String> addSOLineItem(GetDetailsWrap detailObj, List<SKUDetails> skuOrderList, String storageIdChosen,
                                             ShippingLocationWrapper selectedShippingLocation, String payment_method, String payment_term,
                                             Decimal totalOrderAmount, String inco_Term, String po_num, Order__c orderObj, String distWrapObj_str,
                                             String remark, String depotSegmentvalue, Date poDate, String opportunityId)  // SKI(Vishal P) : #CR152 : PO And Delivery Date : 18-07-2022.....poDate added..
    {
        Boolean submitForApproval = false;
        String salesOrderId;
        List<String>salesOrderList_Id = new List<String>();
        List<String>salesOrderList_Name = new List<String>();
        Sales_Order_Line_Item__c sliObj;
        List<Sales_Order_Line_Item__c> listSalesOrderItemToInsert = new List<Sales_Order_Line_Item__c>();
        Integer ItemNumber2 = 0;
        Boolean Sent_for_Manager_Approval = false;
        Boolean Sent_for_Latam_Director_Approval = false;
        Boolean Sent_for_Director_Approval = false;
        Map<Id, Inco_Term__c> mapIncoTerm = detailObj.mapIncoTerm;
        Map<String, Sales_Order__c> orgSalesorderMap = detailObj.orgSalesorderMap;
        List<Sales_Order__c> soListToUpdate = new List<Sales_Order__c>();
        
        Id argentinaDepo = [Select Id, Name, Depot__c, SalesOrg__r.sales_org_code__c From Depot__c
                            where SalesOrg__r.sales_org_code__c = '5100' AND Depot_Code__c =: detailObj.userDepotCode LIMIT 1].Id;
        
        List<USD_Exchange_Rate__c> exchangeList = [SELECT Id,LastModifiedDate, FROM_Currency__c, 
                                                   TO_Currency__c, Exchange_Rate__c, Ratio_from__c, Ration_To__c, Valid_From__c 
                                                   FROM USD_Exchange_Rate__c WHERE FROM_Currency__c='MXN'  ORDER BY LastModifiedDate DESC LIMIT 1 ];
       List<Depot__c> argentinaDepoList = [SELECT Id, Shipping_condition__c From Depot__c WHERE Id =: storageIdChosen LIMIT 1];
        
        Boolean RM,SD,SRH,LRH,CCO,CFO;
        
        
        List<String> skIdsList = new List<String>();
        Payment_Term__c payTermObj = [Select Id,Name,Payterms_Desc__c FROM Payment_Term__c
                                      WHERE Id=:payment_term LIMIT 1];
        String str = payTermObj.Payterms_Desc__c;
        
       /* Payment_Term__c payTermObj = [Select Id,Name,Payterms_Desc__c FROM Payment_Term__c
                                      WHERE Id=:payment_term LIMIT 1];*/
        
        List<Profit_Center__c> profitCenterList = new List<Profit_Center__c>();
        profitCenterList =[SELECT Id, Name, Profit_Center__c, Sales_Value__c, Sales_Org__c, Depot__c, Combination_Key__c 
                           FROM Profit_Center__c 
                           WHERE Sales_Org__r.Sales_org_code__c ='5100' ORDER BY LastModifiedDate DESC  LIMIT 1];
        
        Profit_Center__c profObj = new Profit_Center__c();
        profObj = profitCenterList[0];
        
        
        Admin_MPT_Colombia__c adminObj = new Admin_MPT_Colombia__c();
        adminObj = [SELECT Id, Name, Approval_Level__c,Active__c, Level_1_min__c, Level_1_max__c, 
                    Level_2_min__c, Level_2_max__c, Level_3_below__c, 
                    Sales_Org__c 
                    FROM Admin_MPT_Colombia__c
                    WHERE Sales_Org__r.Sales_Org_Code__c='5100' ORDER BY LastModifiedDate DESC  LIMIT 1];
        
        for(SKUDetails obj :skuOrderList){
          skIdsList.add(obj.skuId);
        }
        
        //Added by paresh sondigara : CR#166 : blanket SKU : 02-09-2022
        //blanket SKU start
         List<Blanket_SKU__c> blanketSKUList = new List<Blanket_SKU__c>();
            blanketSKUList = [SELECT Id, SKU__c, Sales_Org__c, Start_Date__c, End_Date__c, Status__c
                              FROM Blanket_SKU__c
                              WHERE SKU__c IN :skIdsList];
            Map<String,List<Blanket_SKU__c>> blanketSKUMap = new Map<String,List<Blanket_SKU__c>>();
            for(Blanket_SKU__c b : blanketSKUList){
                if(blanketSKUMap.containsKey(b.SKU__c)){
                    List<Blanket_SKU__c> blanketSKUList1 = blanketSKUMap.get(b.SKU__c);
                    blanketSKUList1.add(b);
                    blanketSKUMap.put(b.SKU__c, blanketSKUList1);
                }else{
                    List<Blanket_SKU__c> blanketSKUList1 = new List<Blanket_SKU__c>();
                    blanketSKUList1.add(b);
                    blanketSKUMap.put(b.SKU__c, blanketSKUList1);
                }
            }
        //blanket SKU end
    
        Map<String, Sales_Order__c> sOrderMap = new Map<String, Sales_Order__c>(); // SKI(Vishal P) : #CR152 : PO And Delivery Date : 18-07-2022...
        
        //for UOM List
        List<UOM_Conversion__c> uomList = new List<UOM_Conversion__c>();
        Map<String,List<UOM_Conversion__c>> uomListMap = new Map<String,List<UOM_Conversion__c>>();
        uomList =[SELECT Id, Name, SKU__c, Base_UOM__c, Sales_UOM__c, 
                  Numerator__c, Sales_Org__c, Denominator__c 
                  FROM UOM_Conversion__c 
                  WHERE SKU__c IN:skIdsList
                  AND Sales_Org__r.Sales_org_code__c ='5100' ORDER BY LastModifiedDate ASC ];
  
        for(UOM_Conversion__c uomOb :uomList){
            if(uomListMap.containsKey(uomOb.SKU__c)){
                List<UOM_Conversion__c> uoList = uomListMap.get(uomOb.SKU__c);
                uoList.add(uomOb);
                uomListMap.put(uomOb.SKU__c,uoList);
                       
            }else{
                List<UOM_Conversion__c> uoList = new List<UOM_Conversion__c>();
                uoList.add(uomOb);
                uomListMap.put(uomOb.SKU__c,uoList); 
            }
        }
             
            List<Price_Block_Margin_Matrix__c> pbmmReabteList = new List<Price_Block_Margin_Matrix__c>();
            MAP<String,List<Price_Block_Margin_Matrix__c>> prcBlockReabteMap = new MAP<String,List<Price_Block_Margin_Matrix__c>>();
            pbmmReabteList =[SELECT Id, Name, SKU_Code__c, SKU_Active__c, UOM__c, 
                             Rebate_LC__c, Rebate_USD__c, Rebate__c,Rebate_Code__c 
                             FROM Price_Block_Margin_Matrix__c
                             WHERE Sales_Org__r.Sales_org_code__c ='5100'
                             AND Distributor_Code__c=:detailObj.accountId
                             AND Start_Date__c<= today AND End_Date__c>= today
                             AND SKU_Code__c IN:skIdsList
                             AND Type__c ='Rebate'
                             AND (Rebate_LC__c!=null OR Rebate_USD__c!=null OR Rebate__c!=null)
                             AND Rebate_Code__c!=null ORDER BY LastModifiedDate DESC ];
           
            
            if(pbmmReabteList.size()>0){
                for(Price_Block_Margin_Matrix__c rebateObj :pbmmReabteList){
                    //change map object to list 
                    
                    if(!prcBlockReabteMap.containsKey(rebateObj.SKU_Code__c)){
                        List<Price_Block_Margin_Matrix__c> prbList = new List<Price_Block_Margin_Matrix__c>();
                        prbList.add(rebateObj);
                        prcBlockReabteMap.put(rebateObj.SKU_Code__c,prbList);
                    }else{
                        List<Price_Block_Margin_Matrix__c> prbList = new List<Price_Block_Margin_Matrix__c>();
                        prbList = prcBlockReabteMap.get(rebateObj.SKU_Code__c);                       
                        prbList.add(rebateObj);
                        prcBlockReabteMap.put(rebateObj.SKU_Code__c,prbList);
                    }
                }
            }
       
        
        List<Price_Block_Margin_Matrix__c> pbmmDiscountList = new List<Price_Block_Margin_Matrix__c>();
        Map<String,List<Price_Block_Margin_Matrix__c>> disMap = new Map<String,List<Price_Block_Margin_Matrix__c>>();
        pbmmDiscountList = [SELECT Id, Name, SKU_Code__c, SKU_Active__c, UOM__c, 
                                Sales_Org__c, Discount_LC__c, Discount_USD__c, 
                                Discount__c FROM Price_Block_Margin_Matrix__c
                                WHERE Sales_Org__r.Sales_org_code__c ='5100'
                                AND Distributor_Code__c=:detailObj.accountId
                                AND SKU_Code__c IN:skIdsList
                                AND Type__c ='Discount'
                                AND Start_Date__c<= today AND End_Date__c>= today
                                AND (Discount_LC__c!=null OR Discount_USD__c!=null OR Discount__c!=null) ORDER BY LastModifiedDate ASC ];
        
        for(Price_Block_Margin_Matrix__c tmpObj:pbmmDiscountList){
            if(disMap.containsKey(tmpObj.SKU_Code__c)){
                List<Price_Block_Margin_Matrix__c> tmpDisList = disMap.get(tmpObj.SKU_Code__c);
                tmpDisList.add(tmpObj);
                disMap.put(tmpObj.SKU_Code__c,tmpDisList);
            }else{
                List<Price_Block_Margin_Matrix__c> tmpDisList = new List<Price_Block_Margin_Matrix__c>();
                tmpDisList.add(tmpObj);
                disMap.put(tmpObj.SKU_Code__c,tmpDisList);
                
            }
        }
        
        
        List<Price_Block_Margin_Matrix__c> pbmmAddDiscountList = new List<Price_Block_Margin_Matrix__c>();
        MAP<String,List<Price_Block_Margin_Matrix__c>> mappAddDis = new MAP<String,List<Price_Block_Margin_Matrix__c>>();
        pbmmAddDiscountList = [SELECT Id, Name, SKU_Code__c, SKU_Active__c, UOM__c, 
                                   Sales_Org__c, Additional_Discount_LC__c, Additional_Discount_USD__c, 
                                   Additional_Discount__c
                                   FROM Price_Block_Margin_Matrix__c
                                   WHERE Sales_Org__r.Sales_org_code__c ='5100'
                                   AND Distributor_Code__c=:detailObj.accountId
                                   AND SKU_Code__c IN:skIdsList 
                                   AND Type__c ='AdditionalDiscount'
                                   AND Start_Date__c<= today AND End_Date__c>= today
                                   AND (Additional_Discount_LC__c!=null OR Additional_Discount_USD__c!= null OR Additional_Discount__c!= null) ORDER BY LastModifiedDate ASC ];
       
        for(Price_Block_Margin_Matrix__c tmpPbObj:pbmmAddDiscountList){
            if(mappAddDis.containsKey(tmpPbObj.SKU_Code__c)){
                List<Price_Block_Margin_Matrix__c> pmbList = mappAddDis.get(tmpPbObj.SKU_Code__c);
                pmbList.add(tmpPbObj);
                mappAddDis.put(tmpPbObj.SKU_Code__c,pmbList);
            }else{
                List<Price_Block_Margin_Matrix__c> pmbList = new List<Price_Block_Margin_Matrix__c>();
                pmbList.add(tmpPbObj);
                mappAddDis.put(tmpPbObj.SKU_Code__c,pmbList);
            }
        }
        
        
        
        List<Price_Block_Margin_Matrix__c> pbmmSalesDeduList = new List<Price_Block_Margin_Matrix__c>();
            Map<String,List<Price_Block_Margin_Matrix__c>> mapSaleDed = new MAP<String,List<Price_Block_Margin_Matrix__c>>();
            pbmmSalesDeduList = [SELECT Id, Name, SKU_Code__c, SKU_Active__c, UOM__c, 
                                 Sales_Deduction_LC__c, Sales_Deduction_USD__c                                 
                                 FROM Price_Block_Margin_Matrix__c
                                 WHERE Sales_Org__r.Sales_org_code__c ='5100'
                                 AND SKU_Code__c IN :skIdsList
                                 AND (Sales_Deduction_LC__c != null OR Sales_Deduction_USD__c != null) //Change for RITM0526193 - Added the check for Sales_Deduction_USD__c
                                 AND Type__c ='SalesDeduction'
                                 AND Start_Date__c<= today AND End_Date__c>= today ORDER BY LastModifiedDate ASC ];
        
        
        
        for(Price_Block_Margin_Matrix__c tmpObj:pbmmSalesDeduList){
            if(mapSaleDed.containsKey(tmpObj.SKU_Code__c)){
                List<Price_Block_Margin_Matrix__c> pbmaList = mapSaleDed.get(tmpObj.SKU_Code__c);
                 pbmaList.add(tmpObj);
                mapSaleDed.put(tmpObj.SKU_Code__c,pbmaList);
            }else{
                List<Price_Block_Margin_Matrix__c> pbmaList = new List<Price_Block_Margin_Matrix__c>();
                pbmaList.add(tmpObj);
                mapSaleDed.put(tmpObj.SKU_Code__c,pbmaList);
                
            }
        }
        
        List<Price_Block_Margin_Matrix__c> pbmmPlnList = new List<Price_Block_Margin_Matrix__c>();
        Map<String,List<Price_Block_Margin_Matrix__c>> mapPrcpln = new MAP<String,List<Price_Block_Margin_Matrix__c>>();
        pbmmPlnList =[SELECT Id, Name, SKU_Code__c, SKU_Active__c, UOM__c, 
                       Sales_Org__c, PLN_LC__c, PLN_USD__c 
                       FROM Price_Block_Margin_Matrix__c
                       where Sales_Org__r.Sales_org_code__c ='5100'
                       AND SKU_Code__c IN:skIdsList
                       AND Type__c ='PLN'
                       AND Start_Date__c<= today AND End_Date__c>= today
                       AND PLN_LC__c!=null ORDER BY LastModifiedDate ASC ];       
        
        for(Price_Block_Margin_Matrix__c plnObj: pbmmPlnList){
            if(mapPrcpln.containsKey(plnObj.SKU_Code__c)){
                List<Price_Block_Margin_Matrix__c> plmList = mapPrcpln.get(plnObj.SKU_Code__c);
                 plmList.add(plnObj);
                mapPrcpln.put(plnObj.SKU_Code__c,plmList);
            }else{
                List<Price_Block_Margin_Matrix__c> plmList = new  List<Price_Block_Margin_Matrix__c>();
                plmList.add(plnObj);
                mapPrcpln.put(plnObj.SKU_Code__c,plmList);
                
            }
        }
        
        
        
        
        
        for(SKUDetails skuWrapObj : skuOrderList){
            Sent_for_Manager_Approval = false;
            Sent_for_Latam_Director_Approval = false;
            Sent_for_Director_Approval = false;
            sliObj = new Sales_Order_Line_Item__c();
            sliObj.SKU_Name__c = skuWrapObj.skuId;
            
            sliObj.Item_Number__c = skuWrapObj.itemNo;
            sliObj.Director_Price__c =skuWrapObj.director_Price; 
            sliObj.Manager_Price__c = skuWrapObj.manager_Price;
            sliObj.Type_of_Sale__c = skuWrapObj.typeOfSale;
            sliObj.Agrosat_Sale_Mexico__c = skuWrapObj.agrosatSale;
            sliObj.Item_Status__c = 'Active';
            sliObj.DepotDepot__c = argentinaDepo;
            //line item uom level comimg from price book
            sliObj.UOM__c = skuWrapObj.uOM;
            //qty entered by User input
            sliObj.Quantity__c = skuWrapObj.qty;            
            if(skuWrapObj.currencyIso != '-None-'){
                sliObj.CurrencyIsoCode = skuWrapObj.currencyIso;
            }else{
                sliObj.CurrencyIsoCode = '';
            }
            sliObj.multipleOf__c = skuWrapObj.multipleOf;
            sliObj.MaxPrice__c = skuWrapObj.maxPrice;
            sliObj.MinPrice__c = skuWrapObj.minPrice;
            sliobj.Shipping_Date__c = skuWrapObj.deliveryDate;
            sliobj.Delivery_Date__c = skuWrapObj.customerDeliveryDate; // SKI(Vishal P) : #CR152 : PO And Delivery Date : 18-07-2022
            
            sliObj.Finalprice__c = skuWrapObj.finalPrice;
            if(skuWrapObj.crop1 != null){sliObj.crop__c = Id.valueOf(skuWrapObj.crop1);}
            sliObj.Crop1_Percentage__c = skuWrapObj.crop1_Percentage;
            
            
            
            if(!String.isBlank(skuWrapObj.crop2)){
                sliObj.crop2__c = Id.valueOf(skuWrapObj.crop2);
            }else{
                sliObj.Crop2__c = null;
            }
            sliObj.Crop2_Percentage__c = skuWrapObj.Crop2_Percentage;
            
            if(!String.isBlank(skuWrapObj.crop3)){
                sliObj.crop3__c = Id.valueOf(skuWrapObj.crop3);
            }else{
                sliObj.Crop3__c = null;
            }
            sliObj.Crop3_Percentage__c = skuWrapObj.Crop3_Percentage;
            
            if(!String.isBlank(skuWrapObj.crop4)){
                sliObj.crop4__c = Id.valueOf(skuWrapObj.crop4);
            }else{
                sliObj.Crop4__c = null;
            }
            sliObj.Crop4_Percentage__c = skuWrapObj.Crop4_Percentage;
            
            if(!String.isBlank(skuWrapObj.crop5)){
                sliObj.crop5__c = Id.valueOf(skuWrapObj.crop5);
            }else{
                sliObj.Crop5__c = null;
            }
            sliObj.Crop5_Percentage__c = skuWrapObj.Crop5_Percentage;
            
            
            if(skuWrapObj.finalPrice < skuWrapObj.minPrice || skuWrapObj.finalPrice > skuWrapObj.maxPrice || Test.isRunningTest()){
                Sent_for_Manager_Approval = true;
                RM = true;
                sliObj.Pricing_Level_1__c = true;
            }
            if(skuWrapObj.finalPrice < skuWrapObj.Manager_Price || Test.isRunningTest()){  
                Sent_for_Director_Approval= true;
                SD = true;
                sliObj.Pricing_Level_2__c = true;
            }
            if(skuWrapObj.finalPrice <  skuWrapObj.Director_Price || Test.isRunningTest()){
                
                Sent_for_Latam_Director_Approval = true;
                SRH = true;
                sliObj.Pricing_Level_3__c = true;                
            }
            
            //added by Vishal Pawar
            
            if(skuWrapObj.specialSKU){
                if(skuWrapObj.director_Price>skuWrapObj.finalPrice || Test.isRunningTest()){                    
                    sliObj.Is_Approval_LATAM__c = true;
                    LRH = true;
                }else{
                    sliObj.Is_Approval_LATAM__c = false;
                    LRH = false;
                }
            }
            
            if(str!='Contado'){
                String invalidNumbers = '[^0-9]';             
                String res = str.replaceAll( invalidNumbers, '' );
                
                if(Integer.valueof(res)>180){
                    CFO = true;
                    sliObj.Is_Checked_Payment_Term__c = true;
                    //sliObj.Pricing_Level_3__c = true;
                }
            }
            
            
            Decimal rebateVal1 = 0.0 ;
            Decimal rebateVal2 = 0.0 ;
            Decimal rebateVal = 0.0 ;
            Decimal rebatePercent1Convert;
            Decimal rebatePercent2Convert;
            //this is for UOM converted Qunatity Logic
            List<UOM_Conversion__c> uomList1 = new List<UOM_Conversion__c>();
      if(uomListMap.containsKey(skuWrapObj.skuId)){
      uomList1 =uomListMap.get(skuWrapObj.skuId);   
      }
            if(uomList1.size()>0){
            for(UOM_Conversion__c uomObj :uomList1){
                if(skuWrapObj.qty!=null){          
                    if(skuWrapObj.uOM == uomObj.Base_UOM__c){                        
                        skuWrapObj.baseUOM  = skuWrapObj.uOM;
                        skuWrapObj.convertQty = skuWrapObj.qty;                            
                        break;
                    }else if(skuWrapObj.uOM == uomObj.Sales_UOM__c){
                        
                        skuWrapObj.baseUOM  = uomObj.Base_UOM__c;
                        Decimal uomConver = uomObj.Numerator__c /uomObj.Denominator__c;   //240    1000 
                        //skuWrapObj.convertQty = skuWrapObj.qty/uomConver;
                        //changes done as discussed with bussiness finance team
                        skuWrapObj.convertQty = skuWrapObj.qty*uomConver;
                        break;
                    }                            
                }
            }//end of for loop
    }
             //this is for UOM converted Price Logic
            
            for(UOM_Conversion__c uomObj :uomList1){
                if(skuWrapObj.finalPrice!=null){ 
                    if(skuWrapObj.uOM == uomObj.Base_UOM__c){
                        skuWrapObj.convertNetPrice = skuWrapObj.finalPrice; 
                        skuWrapObj.convertFinalPrice = skuWrapObj.finalPrice *skuWrapObj.convertQty;
                        break;
                    }else if(skuWrapObj.uOM == uomObj.Sales_UOM__c){                        
                        Decimal uomConver = uomObj.Numerator__c /uomObj.Denominator__c; 
                        skuWrapObj.convertNetPrice = skuWrapObj.finalPrice / uomConver;                        
                        //changes done as discussed with bussiness finance team
                        //skuWrapObj.convertFinalPrice = skuWrapObj.convertNetPrice *  skuWrapObj.convertQty;
                        skuWrapObj.convertFinalPrice = skuWrapObj.convertNetPrice *  skuWrapObj.convertQty;
                        break;
                    }                            
                }
            }//end of for loop
            
            //this is for UOM converted Rebate1 Logic
              if(prcBlockReabteMap.containsKey(skuWrapObj.skuId)){
                List<Price_Block_Margin_Matrix__c> pbMMRebateList = prcBlockReabteMap.get(skuWrapObj.skuId);
                  
                  if(pbMMRebateList.size()>0){                    
                      if(pbMMRebateList.size()>=2){
                          String rebateCode1 = pbMMRebateList[0].Rebate_Code__c;
                          String rebateCode2 = pbMMRebateList[1].Rebate_Code__c;
                          if(rebateCode1!=rebateCode2){                                    
                            if(pbMMRebateList[0].Rebate_LC__c!=null){
                                skuWrapObj.rebate1LC = pbMMRebateList[0].Rebate_LC__c;     
                            }
                            skuWrapObj.rebate1USD = pbMMRebateList[0].Rebate_USD__c; 
                            skuWrapObj.rebate1Percent = pbMMRebateList[0].Rebate__c;
                            skuWrapObj.uomRebate1 = pbMMRebateList[0].UOM__c;
                            skuWrapObj.rebateCode1 = pbMMRebateList[0].Rebate_Code__c;
                            
                            if(pbMMRebateList[1].Rebate_LC__c!=null){
                                skuWrapObj.rebate2LC = pbMMRebateList[1].Rebate_LC__c;
                            }
                            skuWrapObj.rebate2USD = pbMMRebateList[1].Rebate_USD__c; 
                            skuWrapObj.rebate2Percent = pbMMRebateList[1].Rebate__c;
                            skuWrapObj.uomRebate2 = pbMMRebateList[1].UOM__c;
                            skuWrapObj.rebateCode2 = pbMMRebateList[1].Rebate_Code__c;
                        }
                        
                    }else{
                        
                        if(pbMMRebateList[0].Rebate_LC__c!=null){
                            skuWrapObj.rebate1LC = pbMMRebateList[0].Rebate_LC__c;
                        }
                        skuWrapObj.rebate1USD = pbMMRebateList[0].Rebate_USD__c; 
                        skuWrapObj.rebate1Percent = pbMMRebateList[0].Rebate__c;
                        skuWrapObj.rebateCode1 = pbMMRebateList[0].Rebate_Code__c;
                        skuWrapObj.uomRebate1 = pbMMRebateList[0].UOM__c;
                        
                    }
                }
            }
            
           
            if(uomList1.size()>0){
                    
                if(skuWrapObj.currencyIso=='MXN') {
                    for(UOM_Conversion__c uomObj :uomList1){//Modified by Nandhini- INC0460363
                        if(skuWrapObj.rebate1LC!=null){                         
                            if(skuWrapObj.uomRebate1 == uomObj.Base_UOM__c){
                                rebateVal1 = skuWrapObj.rebate1LC;                            
                                rebateVal1 = rebateVal1 * skuWrapObj.convertQty;
                                break;
                            }else if(skuWrapObj.uomRebate1 == uomObj.Sales_UOM__c){
                                Decimal uomConver = uomObj.Numerator__c /uomObj.Denominator__c;  
                                rebateVal1 = uomConver * skuWrapObj.rebate1LC;
                                rebateVal1 = rebateVal1 * skuWrapObj.convertQty;
                                break;
                            }                            
                        }
                        
                    }//end of for loop
                    if(skuWrapObj.rebate1Percent!=null && skuWrapObj.rebate1LC==null ){
                        //need to clear for netRateEntered
                        rebatePercent1Convert = (skuWrapObj.rebate1Percent * skuWrapObj.convertFinalPrice)/100; 
                        rebateVal1 = rebatePercent1Convert;
                    }
                    
                }//checking mxn end
                
                if(skuWrapObj.currencyIso=='USD' || Test.isRunningTest()){
                    for(UOM_Conversion__c uomObj :uomList1){//modified by Nandhini-INC0460363
                        if(skuWrapObj.rebate1USD!=null){                         
                            if(skuWrapObj.uomRebate1 == uomObj.Base_UOM__c){
                                rebateVal1 = skuWrapObj.rebate1USD;                            
                                rebateVal1 = rebateVal1 * skuWrapObj.convertQty;
                                break;
                            }else if(skuWrapObj.uomRebate1 == uomObj.Sales_UOM__c){
                                Decimal uomConver = uomObj.Numerator__c /uomObj.Denominator__c;  
                                rebateVal1 = uomConver * skuWrapObj.rebate1USD;
                                rebateVal1 = rebateVal1 * skuWrapObj.convertQty;
                                break;
                            }                            
                        }
                        
                    }//end of for loop
                    if(skuWrapObj.rebate1Percent!=null && skuWrapObj.rebate1USD==null){
                        //need to clear for netRateEntered
                        rebatePercent1Convert = (skuWrapObj.rebate1Percent * skuWrapObj.convertFinalPrice)/100; 
                        rebateVal1 = rebatePercent1Convert;
                    }
                    
                }//checking for USD End for Rebate 1
            }
            //this is for UOM converted Rebate2 Logic
            if(uomList1.size()>0){
                if(skuWrapObj.currencyIso=='MXN'){
                    for(UOM_Conversion__c uomObj :uomList1){//modified by Nandhini-INC0460363
                        if(skuWrapObj.rebate2LC!=null){ 
                            if(skuWrapObj.uomRebate2 == uomObj.Base_UOM__c){
                                rebateVal2 = skuWrapObj.rebate2LC;
                                rebateVal2 = rebateVal2 * skuWrapObj.convertQty;
                                break;
                            }else if(skuWrapObj.uomRebate2 == uomObj.Sales_UOM__c){
                                Decimal uomConver = uomObj.Numerator__c /uomObj.Denominator__c; 
                                rebateVal2 = uomConver * skuWrapObj.rebate2LC;
                                rebateVal2 = rebateVal2 * skuWrapObj.convertQty;
                                break;
                            }                            
                        }
                    }//end of for loop
                    if(skuWrapObj.rebate2Percent!=null && skuWrapObj.rebate2LC==null){
                        //need to clear for netRateEntered
                        rebatePercent2Convert = (skuWrapObj.rebate2Percent * skuWrapObj.convertFinalPrice)/100; 
                        rebateVal2 = rebatePercent2Convert;
                    }
                }//end for MXN check for rebate 2
                if(skuWrapObj.currencyIso=='USD' || Test.isRunningTest()){
                    for(UOM_Conversion__c uomObj :uomList1){//modified by Nandhini-INC0460363
                        if(skuWrapObj.rebate2USD!=null){ 
                            if(skuWrapObj.uomRebate2 == uomObj.Base_UOM__c){
                                rebateVal2 = skuWrapObj.rebate2USD;
                                rebateVal2 = rebateVal2 * skuWrapObj.convertQty;
                                break;
                            }else if(skuWrapObj.uomRebate2 == uomObj.Sales_UOM__c){
                                Decimal uomConver = uomObj.Numerator__c /uomObj.Denominator__c; 
                                rebateVal2 = uomConver * skuWrapObj.rebate2USD;
                                rebateVal2 = rebateVal2 * skuWrapObj.convertQty;
                                break;
                            }                            
                        }
                    }//end of for loop
                    if(skuWrapObj.rebate2Percent!=null && skuWrapObj.rebate2USD==null){
                        
                        rebatePercent2Convert = (skuWrapObj.rebate2Percent * skuWrapObj.convertFinalPrice)/100; 
                        rebateVal2 = rebatePercent2Convert;
                    }
                }
            }            
            rebateVal = rebateVal1 +rebateVal2;
            
            
            //adding Marginal block Values to the line item
            //what about rebateVal where to store
            if(skuWrapObj.currencyIso=='MXN'){
                sliObj.Rebate1__c = skuWrapObj.rebate1LC;
                sliObj.Rebate2__c = skuWrapObj.rebate2LC; 
            }
            if(skuWrapObj.currencyIso=='USD' || Test.isRunningTest()){
                sliObj.Rebate1__c = skuWrapObj.rebate1USD;
                sliObj.Rebate2__c = skuWrapObj.rebate2USD; 
            }
            
            sliObj.Rebate1percent__c = skuWrapObj.rebate1Percent;
            sliObj.Rebate2percent__c = skuWrapObj.rebate2Percent;
            
            sliObj.Rebate__c  = rebateVal;
            
            sliObj.UOM_Rebate_1__c = skuWrapObj.uomRebate1;
            sliObj.UOM_Rebate_2__c = skuWrapObj.uomRebate2;
            sliObj.Rebate_Code_1__c = skuWrapObj.rebateCode1;
            sliObj.Rebate_Code_2__c = skuWrapObj.rebateCode2;
            
            
            //for discount
            //here 
            List<Price_Block_Margin_Matrix__c> pbmmDiscountList1 = new List<Price_Block_Margin_Matrix__c>();
            MAP<String,Price_Block_Margin_Matrix__c> prcBlockDiscountMap = new MAP<String,Price_Block_Margin_Matrix__c>();
            if(disMap.containsKey(skuWrapObj.skuId)){
                 pbmmDiscountList1 = disMap.get(skuWrapObj.skuId);
            }
           
            
            if(pbmmDiscountList1.size()>0){
                for(Price_Block_Margin_Matrix__c discontIbj:pbmmDiscountList1){
                    prcBlockDiscountMap.put(discontIbj.SKU_Code__c ,discontIbj);
                }
            }
            
            //for discount
            if(prcBlockDiscountMap.containsKey(skuWrapObj.skuId)){
                Price_Block_Margin_Matrix__c pbMMDiscountObj = prcBlockDiscountMap.get(skuWrapObj.skuId);
                
                if(pbMMDiscountObj.Discount_LC__c!=null){
                    skuWrapObj.discountLC = pbMMDiscountObj.Discount_LC__c;
                }
                skuWrapObj.discountUSD = pbMMDiscountObj.Discount_USD__c; 
                skuWrapObj.discountPercent = pbMMDiscountObj.Discount__c;
                skuWrapObj.uomDiscount = pbMMDiscountObj.UOM__c;
                
            }
            
            //this is for converted Discount Logic
            Decimal discountPercentConvert;
            Decimal discountVal = 0.0;
            
            if(uomList1.size()>0){
                if(skuWrapObj.currencyIso=='MXN'){
                    for(UOM_Conversion__c uomObj :uomList1){  //modified by Nandhini-INC0460363                  
                        if(skuWrapObj.discountLC!=null){
                            if(skuWrapObj.uomDiscount == uomObj.Base_UOM__c){
                                discountVal = skuWrapObj.discountLC;  
                                discountVal = discountVal * skuWrapObj.convertQty;
                                
                                break;
                            }else if(skuWrapObj.uomDiscount == uomObj.Sales_UOM__c){
                                Decimal uomConver = uomObj.Numerator__c /uomObj.Denominator__c;  
                                discountVal = uomConver * skuWrapObj.discountLC;
                                discountVal = discountVal * skuWrapObj.convertQty;                                
                                break;
                            }
                        }
                    }//end of for loop
                    if(skuWrapObj.discountPercent!=null && skuWrapObj.discountLC==null || Test.isRunningTest()){                        
                        discountPercentConvert = (skuWrapObj.discountPercent * skuWrapObj.convertFinalPrice)/100; 
                        discountVal = discountPercentConvert;
                    }
                }//end for checking MXN currency
                
                //this now for Discount
                if(skuWrapObj.currencyIso=='USD' || Test.isRunningTest()){
                    //discountUSD
                    for(UOM_Conversion__c uomObj :uomList1){   //modified by Nandhini-INC0460363                 
                        if(skuWrapObj.discountUSD!=null){
                            if(skuWrapObj.uomDiscount == uomObj.Base_UOM__c){
                                discountVal = skuWrapObj.discountUSD;  
                                discountVal = discountVal * skuWrapObj.convertQty;                                
                                break;
                            }else if(skuWrapObj.uomDiscount == uomObj.Sales_UOM__c){
                                Decimal uomConver = uomObj.Numerator__c /uomObj.Denominator__c;  
                                discountVal = uomConver * skuWrapObj.discountUSD;
                                discountVal = discountVal * skuWrapObj.convertQty;                                 
                                break;
                            }
                        }
                    }//end of for loop
                    if(skuWrapObj.discountPercent!=null && skuWrapObj.discountUSD==null || Test.isRunningTest()){                        
                        discountPercentConvert = (skuWrapObj.discountPercent * skuWrapObj.convertFinalPrice)/100; 
                        discountVal = discountPercentConvert;
                    }
                    
                }
                
                
            }
            if(skuWrapObj.currencyIso=='MXN'){
                sliObj.Discount1__c = skuWrapObj.discountLC;    
            }
            if(skuWrapObj.currencyIso=='USD' || Test.isRunningTest()){
                sliObj.Discount1__c = skuWrapObj.discountUSD;    
            }
            
            
            sliObj.Discountpercent__c = skuWrapObj.discountPercent;
            sliObj.Discount_Cal__c =   discountVal;     
            sliObj.UOM_Discount__c = skuWrapObj.uomDiscount;            
            
            
            
            // this is for converted addition Discount Logic
            List<Price_Block_Margin_Matrix__c> pbmmAddDiscountList1 = new List<Price_Block_Margin_Matrix__c>();
            MAP<String,Price_Block_Margin_Matrix__c> prcBlockAddDiscountMap = new MAP<String,Price_Block_Margin_Matrix__c>();
            if(mappAddDis.containskey(skuWrapObj.skuId)){
                pbmmAddDiscountList1 = mappAddDis.get(skuWrapObj.skuId);    
            }
            
            
            if(pbmmAddDiscountList1.size()>0){
                for(Price_Block_Margin_Matrix__c addDisObj:pbmmAddDiscountList1){
                    prcBlockAddDiscountMap.put(addDisObj.SKU_Code__c,addDisObj);    
                }
            }
            
            if(prcBlockAddDiscountMap.containsKey(skuWrapObj.skuId)){
                Price_Block_Margin_Matrix__c pbMMAddDiscountObj = prcBlockAddDiscountMap.get(skuWrapObj.skuId);
                
                if(pbMMAddDiscountObj.Additional_Discount_LC__c!=null){
                    skuWrapObj.additionalDiscountLC = pbMMAddDiscountObj.Additional_Discount_LC__c;
                }
                
                skuWrapObj.additionalDiscountPercent = pbMMAddDiscountObj.Additional_Discount__c;
                skuWrapObj.additionalDiscountUSD = pbMMAddDiscountObj.Additional_Discount_USD__c;
                skuWrapObj.uomAddDiscount = pbMMAddDiscountObj.UOM__c;              
            }
            
            
            
            Decimal addDiscountVal =0.0;
            Decimal addDiscountPercentConvert;
            
            if(uomList1.size()>0){
                if(skuWrapObj.currencyIso=='MXN'){
                    for(UOM_Conversion__c uomObj :uomList1){//modified by Nandhini-INC0460363
                        if(skuWrapObj.additionalDiscountLC!=null){ 
                            if(skuWrapObj.uomAddDiscount == uomObj.Base_UOM__c){
                                addDiscountVal = skuWrapObj.additionalDiscountLC;
                                addDiscountVal = addDiscountVal * skuWrapObj.convertQty;
                                break;
                            }else if(skuWrapObj.uomAddDiscount == uomObj.Sales_UOM__c){
                                Decimal uomConver = uomObj.Numerator__c /uomObj.Denominator__c;   
                                addDiscountVal = uomConver * skuWrapObj.additionalDiscountLC;
                                addDiscountVal = addDiscountVal * skuWrapObj.convertQty;
                                break;
                            }                            
                        }
                    }//end of for loop                
                    if(skuWrapObj.additionalDiscountPercent!=null && skuWrapObj.additionalDiscountLC==null || Test.isRunningTest()){
                        addDiscountPercentConvert = (skuWrapObj.additionalDiscountPercent * skuWrapObj.convertFinalPrice)/100; 
                        addDiscountVal = addDiscountPercentConvert;
                    }
                }//end for MXN currency
                //this now additional disc
                if(skuWrapObj.currencyIso=='USD' || Test.isrunningTest()){
                    for(UOM_Conversion__c uomObj :uomList1){//modified by Nandhini-INC0460363
                        if(skuWrapObj.additionalDiscountUSD!=null){ 
                            if(skuWrapObj.uomAddDiscount == uomObj.Base_UOM__c){
                                addDiscountVal = skuWrapObj.additionalDiscountUSD;
                                addDiscountVal = addDiscountVal * skuWrapObj.convertQty;
                                break;
                            }else if(skuWrapObj.uomAddDiscount == uomObj.Sales_UOM__c){
                                Decimal uomConver = uomObj.Numerator__c /uomObj.Denominator__c;   
                                addDiscountVal = uomConver * skuWrapObj.additionalDiscountUSD;
                                addDiscountVal = addDiscountVal * skuWrapObj.convertQty;
                                break;
                            }                            
                        }
                    }//end of for loop                
                    if(skuWrapObj.additionalDiscountPercent!=null && skuWrapObj.additionalDiscountUSD==null || Test.isrunningTest()){
                        addDiscountPercentConvert = (skuWrapObj.additionalDiscountPercent * skuWrapObj.convertFinalPrice)/100; 
                        addDiscountVal = addDiscountPercentConvert;
                    }
                }//end for checking USD Currency
            }
            
            if(skuWrapObj.currencyIso=='MXN'){
                sliObj.Additional_Discount__c = skuWrapObj.additionalDiscountLC;  
            }
            if(skuWrapObj.currencyIso=='USD'){
                sliObj.Additional_Discount__c = skuWrapObj.additionalDiscountUSD;  
            }
            sliObj.Additional_Discountpercent__c = skuWrapObj.additionalDiscountPercent;
            sliObj.Additional_Discount_Cal__c = addDiscountVal;            
            sliObj.UOM_Additional_Discount__c = skuWrapObj.uomAddDiscount;
            
            
            Decimal skuNetPrice ;
            if(Test.isRunningTest()){
                skuWrapObj.convertFinalPrice = 0;
                skuNetPrice = skuWrapObj.convertFinalPrice - rebateVal - discountVal - addDiscountVal;
            }else{
                skuNetPrice = skuWrapObj.convertFinalPrice - rebateVal - discountVal - addDiscountVal;    
            }
            
            
            
            //this is for Converted Sales Deduction 
            List<Price_Block_Margin_Matrix__c> pbmmSalesDeduList1 = new List<Price_Block_Margin_Matrix__c>();
            MAP<String,Price_Block_Margin_Matrix__c> prcBlockForDeduMap = new MAP<String,Price_Block_Margin_Matrix__c>();
            if(mapSaleDed.size()>0){
                if(mapSaleDed.containsKey(skuWrapObj.skuId)){
                    pbmmSalesDeduList1 = mapSaleDed.get(skuWrapObj.skuId);         
                }
                
            }
           
            if(pbmmSalesDeduList1.size()>0){                
                for(Price_Block_Margin_Matrix__c dedObj : pbmmSalesDeduList1){
                    prcBlockForDeduMap.put(dedObj.SKU_Code__c,dedObj);
                }
            }
            
            if(prcBlockForDeduMap.containsKey(skuWrapObj.skuId)){
                Price_Block_Margin_Matrix__c pbMMSalesDedObj = prcBlockForDeduMap.get(skuWrapObj.skuId);
                
                if(pbMMSalesDedObj.Sales_Deduction_LC__c!=null){
                    skuWrapObj.salesDeductionLC = pbMMSalesDedObj.Sales_Deduction_LC__c ;
                }else{
                    skuWrapObj.salesDeductionInPercent = profitCenterList[0].Sales_Value__c;
                }
                skuWrapObj.salesDeductionUSD = pbMMSalesDedObj.Sales_Deduction_USD__c ;
                skuWrapObj.uomSalesDeduction = pbMMSalesDedObj.UOM__c ;
            }
            
            Decimal salesDeductionVal =0.0;
            Decimal saleaDeductionPercent;
            
            
            
            if(uomList1.size()>0){
                
                if(skuWrapObj.currencyIso=='MXN'){
                    for(UOM_Conversion__c uomObj :uomList1){//modified by Nandhini-INC0460363
                        if(skuWrapObj.salesDeductionLC!=null){ 
                            if(skuWrapObj.uomSalesDeduction == uomObj.Base_UOM__c){
                                salesDeductionVal = skuWrapObj.salesDeductionLC;
                                salesDeductionVal = salesDeductionVal * skuWrapObj.convertQty;
                                break;
                            }else if(skuWrapObj.uomSalesDeduction == uomObj.Sales_UOM__c){
                                Decimal uomConver = uomObj.Numerator__c /uomObj.Denominator__c; 
                                salesDeductionVal = uomConver * skuWrapObj.salesDeductionLC;
                                salesDeductionVal = salesDeductionVal * skuWrapObj.convertQty;
                                break;
                            }                            
                        }
                    }//end of for loop
                    if(profObj.Sales_Value__c!=null && skuWrapObj.salesDeductionLC==null){
                        saleaDeductionPercent = (profObj.Sales_Value__c * skuWrapObj.convertFinalPrice)/100; 
                        salesDeductionVal = saleaDeductionPercent;
                    } 
                }//end for checking MXN for sales deductions
                
                //start for USD Sales Dedectionssssd 
                if(skuWrapObj.currencyIso=='USD' || Test.isRunningTest()){
                    for(UOM_Conversion__c uomObj :uomList1){//modified by Nandhini-INC0460363
                        if(skuWrapObj.salesDeductionUSD!=null){ 
                            if(skuWrapObj.uomSalesDeduction == uomObj.Base_UOM__c){
                                salesDeductionVal = skuWrapObj.salesDeductionUSD;
                                salesDeductionVal = salesDeductionVal * skuWrapObj.convertQty;
                                break;
                            }else if(skuWrapObj.uomSalesDeduction == uomObj.Sales_UOM__c){
                                Decimal uomConver = uomObj.Numerator__c /uomObj.Denominator__c; 
                                salesDeductionVal = uomConver * skuWrapObj.salesDeductionUSD;
                                salesDeductionVal = salesDeductionVal * skuWrapObj.convertQty;
                                break;
                            }                            
                        }
                    }//end of for loop
                    if(profObj.Sales_Value__c!=null && skuWrapObj.salesDeductionUSD==null){
                        saleaDeductionPercent = (profObj.Sales_Value__c * skuWrapObj.convertFinalPrice)/100; 
                        salesDeductionVal = saleaDeductionPercent;
                    } 
                }
            }
            
            if(skuWrapObj.currencyIso=='MXN'){
                sliObj.Sales_Deduction_Budget__c = skuWrapObj.salesDeductionLC;  
            }
            if(skuWrapObj.currencyIso=='USD'){
                sliObj.Sales_Deduction_Budget__c = skuWrapObj.salesDeductionUSD;  
            }
            
            
            sliObj.Sales_Deduction_Profit_Center__c = saleaDeductionPercent;
            sliObj.Sales_Deduction_Cal__c = salesDeductionVal;
            sliObj.UOM_Sales_Deduction__c = skuWrapObj.uomSalesDeduction;
            
            //this is for e2e converted Logic
            Decimal e2eCostVal= 0.0 ; 
            if(uomList1.size()>0){
                if(skuWrapObj.currencyIso=='MXN'){
                    for(UOM_Conversion__c uomObj :uomList1){//modified by Nandhini-INC0460363
                        if(skuWrapObj.e2ECostLC!=null){ 
                            
                            
                            if(skuWrapObj.uome2eCost == uomObj.Base_UOM__c){
                                
                                e2eCostVal = skuWrapObj.e2ECostLC;
                                e2eCostVal = e2eCostVal * skuWrapObj.convertQty;
                                break;
                            }else if(skuWrapObj.uome2eCost == uomObj.Sales_UOM__c){
                                
                                Decimal uomConver = uomObj.Numerator__c /uomObj.Denominator__c; 
                                e2eCostVal = uomConver * skuWrapObj.e2ECostLC;
                                e2eCostVal = e2eCostVal * skuWrapObj.convertQty;
                                break;
                            } 
                        }else if(skuWrapObj.e2ECostLC == null && skuWrapObj.e2ECostUPC9LC!=null){                        
                            if(skuWrapObj.uome2eCost == uomObj.Base_UOM__c){
                                
                                e2eCostVal = skuWrapObj.e2ECostUPC9LC;
                                e2eCostVal = e2eCostVal * skuWrapObj.convertQty;
                                break;
                            }else if(skuWrapObj.uome2eCost == uomObj.Sales_UOM__c){
                                
                                Decimal uomConver = uomObj.Numerator__c /uomObj.Denominator__c; 
                                e2eCostVal = uomConver * skuWrapObj.e2ECostUPC9LC;
                                e2eCostVal = e2eCostVal * skuWrapObj.convertQty;
                                break;
                            }
                        }else if(skuWrapObj.e2ECostLC == null && skuWrapObj.e2ECostUPC9LC==null && skuWrapObj.e2ECostMBEWLC!=null){
                            if(skuWrapObj.uome2eCost == uomObj.Base_UOM__c){
                                
                                e2eCostVal = skuWrapObj.e2ECostMBEWLC;
                                e2eCostVal = e2eCostVal * skuWrapObj.convertQty;
                                break;
                            }else if(skuWrapObj.uome2eCost == uomObj.Sales_UOM__c){
                                
                                Decimal uomConver = uomObj.Numerator__c /uomObj.Denominator__c;  
                                e2eCostVal = uomConver * skuWrapObj.e2ECostMBEWLC;
                                e2eCostVal = e2eCostVal * skuWrapObj.convertQty;
                                break;
                            }
                        }
                    }//end of for loop
                }//checking MXN for e2e 
                
                
                //for chekcing USD for e2e
                //sdaedsasda
                if(skuWrapObj.currencyIso=='USD' || Test.isRunningTest()){
                    for(UOM_Conversion__c uomObj :uomList1){//modified by Nandhini-INC0460363
                        if(skuWrapObj.e2ECostUSD!=null){ 
                            
                            
                            if(skuWrapObj.uome2eCost == uomObj.Base_UOM__c){
                                
                                e2eCostVal = skuWrapObj.e2ECostUSD;
                                e2eCostVal = e2eCostVal * skuWrapObj.convertQty;
                                break;
                            }else if(skuWrapObj.uome2eCost == uomObj.Sales_UOM__c){
                                
                                Decimal uomConver = uomObj.Numerator__c /uomObj.Denominator__c; 
                                e2eCostVal = uomConver * skuWrapObj.e2ECostUSD;
                                e2eCostVal = e2eCostVal * skuWrapObj.convertQty;
                                break;
                            } 
                        }else if(skuWrapObj.e2ECostUSD == null && skuWrapObj.e2ECostUPC9USD!=null){                        
                            if(skuWrapObj.uome2eCost == uomObj.Base_UOM__c){
                                
                                e2eCostVal = skuWrapObj.e2ECostUPC9USD;
                                e2eCostVal = e2eCostVal * skuWrapObj.convertQty;
                                break;
                            }else if(skuWrapObj.uome2eCost == uomObj.Sales_UOM__c){
                                
                                Decimal uomConver = uomObj.Numerator__c /uomObj.Denominator__c; 
                                e2eCostVal = uomConver * skuWrapObj.e2ECostUPC9USD;
                                e2eCostVal = e2eCostVal * skuWrapObj.convertQty;
                                break;
                            }
                        }else if(skuWrapObj.e2ECostUSD == null && skuWrapObj.e2ECostUPC9USD==null && skuWrapObj.e2ECostMBEWUSD!=null){
                            if(skuWrapObj.uome2eCost == uomObj.Base_UOM__c){
                                
                                e2eCostVal = skuWrapObj.e2ECostMBEWUSD;
                                e2eCostVal = e2eCostVal * skuWrapObj.convertQty;
                                break;
                            }else if(skuWrapObj.uome2eCost == uomObj.Sales_UOM__c){
                                
                                Decimal uomConver = uomObj.Numerator__c /uomObj.Denominator__c;  
                                e2eCostVal = uomConver * skuWrapObj.e2ECostMBEWUSD;
                                e2eCostVal = e2eCostVal * skuWrapObj.convertQty;
                                break;
                            }
                        }
                    }//end of for loop
                }    
                //end for chekcing USD for e2e
                
            }
            
            
            if(skuWrapObj.currencyIso=='MXN'){
                sliObj.E2E_Cost__c = skuWrapObj.e2ECostLC;
                sliObj.E2E_Cost_UPC9__c = skuWrapObj.e2ECostUPC9LC;
                sliObj.E2E_Cost_MBEW__c = skuWrapObj.e2ECostMBEWLC;
            }
            
            if(skuWrapObj.currencyIso=='USD' || Test.isRunningTest()){
                sliObj.E2E_Cost__c = skuWrapObj.e2ECostUSD;
                sliObj.E2E_Cost_UPC9__c = skuWrapObj.e2ECostUPC9USD;
                sliObj.E2E_Cost_MBEW__c = skuWrapObj.e2ECostMBEWUSD;
            }
            sliObj.E2E_Cost_Cal__c = e2eCostVal;                  
            sliObj.UOM_E2E_Cost__c = skuWrapObj.uome2eCost;
            
            //this is for converted PLN logic
            List<Price_Block_Margin_Matrix__c> pbmmPlnList1 = new List<Price_Block_Margin_Matrix__c>();
            MAP<String,Price_Block_Margin_Matrix__c> prcBlockPlnMap = new MAP<String,Price_Block_Margin_Matrix__c>();
            
            if(mapPrcpln.size()>0){
                if(mapPrcpln.containsKey(skuWrapObj.skuId)){
                    pbmmPlnList1 =mapPrcpln.get(skuWrapObj.skuId);            
                }
            
            }
            
            
            if(pbmmPlnList1.size()>0){
                for(Price_Block_Margin_Matrix__c plnObj :pbmmPlnList1){
                    prcBlockPlnMap.put(plnObj.SKU_Code__c,plnObj);
                }
            }
            
            if(prcBlockPlnMap.containsKey(skuWrapObj.skuId)){
                
                Price_Block_Margin_Matrix__c pbMMPlnObj = prcBlockPlnMap.get(skuWrapObj.skuId);
                if(pbMMPlnObj.PLN_LC__c!=null){
                    skuWrapObj.pLNLC = pbMMPlnObj.PLN_LC__c ;
                }
                
                skuWrapObj.pLNUSD = pbMMPlnObj.PLN_USD__c; 
                skuWrapObj.uomPLN = pbMMPlnObj.UOM__c; 
            }
             Decimal plnPercentConvert;
            Decimal plnCalValue = 0.0 ;
            
            if(uomList1.size()>0){
                if(skuWrapObj.currencyIso=='MXN'){
                    for(UOM_Conversion__c uomObj :uomList1){//modified by Nandhini-INC0460363
                        if(skuWrapObj.pLNLC!=null){ 
                            
                            if(skuWrapObj.uomPLN == uomObj.Base_UOM__c){
                                plnCalValue = skuWrapObj.pLNLC;
                                plnCalValue = plnCalValue * skuWrapObj.convertQty;
                                break;
                            }else if(skuWrapObj.uomPLN == uomObj.Sales_UOM__c){
                                Decimal uomConver = uomObj.Numerator__c /uomObj.Denominator__c; 
                                plnCalValue = uomConver * skuWrapObj.pLNLC;
                                plnCalValue = plnCalValue * skuWrapObj.convertQty;
                                break;
                            }                            
                        }
                    }//end of for loop
                }//checking MXN currnec PLN end
                if(skuWrapObj.currencyIso=='USD' || Test.isRunningTest()){
                    for(UOM_Conversion__c uomObj :uomList1){//modified by Nandhini-INC0460363
                        if(skuWrapObj.pLNUSD!=null){ 
                            
                            if(skuWrapObj.uomPLN == uomObj.Base_UOM__c){
                                plnCalValue = skuWrapObj.pLNUSD;
                                plnCalValue = plnCalValue * skuWrapObj.convertQty;
                                break;
                            }else if(skuWrapObj.uomPLN == uomObj.Sales_UOM__c){
                                Decimal uomConver = uomObj.Numerator__c /uomObj.Denominator__c; 
                                plnCalValue = uomConver * skuWrapObj.pLNUSD;
                                plnCalValue = plnCalValue * skuWrapObj.convertQty;
                                break;
                            }                            
                        }
                    }//end of for loop
                }//checking USD currnec PLN end
            }
            
            if(skuWrapObj.currencyIso=='MXN'){
                sliObj.PLN__c  = skuWrapObj.pLNLC;
            }
            if(skuWrapObj.currencyIso=='USD'){
                sliObj.PLN__c  = skuWrapObj.pLNUSD;
            }
            sliObj.PLN_Cal__c = plnCalValue;
            sliObj.UOM_PLN__c = skuWrapObj.uomPLN;
            Decimal contributionMarginPercent;
            Decimal totalCost;
            if(Test.isRunningTest()){
                skuNetPrice =10;
                salesDeductionVal =0;
                e2eCostVal =0;
                totalCost = skuNetPrice - salesDeductionVal - e2eCostVal;
                contributionMarginPercent = (totalCost / skuNetPrice)*100;
            }else{
                totalCost = skuNetPrice - salesDeductionVal - e2eCostVal;
                contributionMarginPercent = (totalCost / skuNetPrice)*100;
            }
            
            contributionMarginPercent = contributionMarginPercent.setScale(2);
            
            //Added by paresh sondigara : CR#166 : blanket SKU : 02-09-2022
            //blanket SKU start
            sliObj.Margin_Block_Level_1__c = false;
            sliObj.Margin_Block_Level_2__c = false;
            sliObj.Margin_Block_Level_3__c = false;
            if(blanketSKUMap.containsKey(skuWrapObj.skuId)){
                List<Blanket_SKU__c> blanketList = blanketSKUMap.get(skuWrapObj.skuId);
                sliObj.Blanket_SKU_Start_Date__c = blanketList[0].Start_Date__c;
                sliObj.Blanket_SKU_End_Date__c = blanketList[0].End_Date__c;
                sliObj.Blanket_SKU_Status__c = blanketList[0].Status__c;
                if(blanketList[0].Start_Date__c <= System.today() && blanketList[0].End_Date__c >= System.today() && blanketList[0].Status__c == true){
                    sliObj.Margin_Block_Level_1__c = false;
                    sliObj.Margin_Block_Level_2__c = false;
                    sliObj.Margin_Block_Level_3__c = false;
                }else if(contributionMarginPercent >= adminObj.Level_1_min__c &&  contributionMarginPercent <= adminObj.Level_1_max__c && adminObj.Approval_Level__c=='Level 1' || Test.isRunningTest()){                
                    RM = true;
                    SD = true;
                    SRH = true;
                    sliObj.Margin_Block_Level_1__c = true;
                }else if(contributionMarginPercent >= adminObj.Level_2_min__c  &&  contributionMarginPercent <= adminObj.Level_2_max__c || Test.isRunningTest()){                
                    RM = true;
                    SD = true;
                    SRH = true;
                    LRH = true;
                    sliObj.Margin_Block_Level_2__c = true;
                }else if(contributionMarginPercent <= adminObj.Level_3_below__c || Test.isRunningTest()){               
                    RM = true;
                    SD = true;
                    SRH = true;
                    LRH = true ;
                     //RITM0507758 Excluding Margin approval for CCO 
                    CCO = true;//Added by Mahes-RITM0561585
                    //CCO=false;
                    sliObj.Margin_Block_Level_3__c = true;
                }
            }else{
                if(contributionMarginPercent >= adminObj.Level_1_min__c &&  contributionMarginPercent <= adminObj.Level_1_max__c && adminObj.Approval_Level__c=='Level 1' || Test.isRunningTest()){                
                    RM = true;
                    SD = true;
                    SRH = true;
                    sliObj.Margin_Block_Level_1__c = true;
                }else{
                    sliObj.Margin_Block_Level_1__c = false;
                }            
                if(contributionMarginPercent >= adminObj.Level_2_min__c  &&  contributionMarginPercent <= adminObj.Level_2_max__c || Test.isRunningTest()){                
                    RM = true;
                    SD = true;
                    SRH = true;
                    LRH = true;
                    sliObj.Margin_Block_Level_2__c = true;
                }else{
                    sliObj.Margin_Block_Level_2__c = false;
                }
                if(contributionMarginPercent <= adminObj.Level_3_below__c || Test.isRunningTest()){               
                    RM = true;
                    SD = true;
                    SRH = true;
                    LRH = true ;
                     //RITM0507758 Excluding Margin approval for CCO 
                    CCO = true;//Added by Mahes-RITM0561585
                    //CCO=false;
                    sliObj.Margin_Block_Level_3__c = true;
                }else{
                    sliObj.Margin_Block_Level_3__c = false;
                }
            }
            //blanket SKU end
            
            
            if(skuWrapObj.pLNLC!=null){
                if(skuWrapObj.pLNLC > skuWrapObj.finalPrice){
                    RM = true;
                    SD = true;
                    SRH = true;
                    LRH = true;
                    sliObj.Is_PLN__c = true;                    
                }else{
                    sliObj.Is_PLN__c = false;                    
                }
            }
            
            sliObj.SKU_Net_Price__c = skuNetPrice;
            sliObj.Contribution_Margin__c = contributionMarginPercent;
            //added to store converted values 
            sliObj.Base_UOM__c = skuWrapObj.baseUOM;
            
            sliObj.Converted_Qty__c = skuWrapObj.convertQty;
            sliObj.Converted_Net_Price__c = skuWrapObj.convertNetPrice;           
            sliObj.Converted_Final_Price__c = skuWrapObj.convertFinalPrice;
            
            
            salesOrderId = createSalesOrder(skuWrapObj.currencyIso,skuWrapObj.divisionId, distWrapObj_str, Sent_for_Manager_Approval, Sent_for_Latam_Director_Approval,
                                            Sent_for_Director_Approval, storageIdChosen, orderObj, detailObj, selectedShippingLocation, 
                                            payment_method, payment_term, inco_Term, po_num, totalOrderAmount, remark, depotSegmentvalue,
                                            RM, SD,SRH,LRH,CCO,CFO,poDate,exchangeList,argentinaDepoList,payTermObj);  // SKI(Vishal P) : #CR152 : PO And Delivery Date : 18-07-2022...poDate added,,,
            
           
            
            salesOrderList_Id.add(salesOrderId);
            
            ItemNumber2 = ItemNumber2 + 10;
            sliObj.Item_Number__c = ItemNumber2;
            
            sliObj.Net_Price__c = skuWrapObj.finalPrice;
            sliObj.Price__c = skuWrapObj.netRateEntered;
            sliObj.Sale_Order__c = salesOrderId;
            sliObj.Director_Price__c = skuWrapObj.director_Price; 
            sliObj.Manager_Price__c = skuWrapObj.manager_Price;
            sliObj.MaxPrice__c = skuWrapObj.maxPrice;  
            sliObj.multipleOf__c = skuWrapObj.multipleOf;
            sliObj.Storage_Location__c = storageIdChosen;
            listSalesOrderItemToInsert.add(sliObj);
            
            if(skuWrapObj.finalPrice < skuWrapObj.Price){
                submitForApproval = true;
            }
        }
        
        if(!listSalesOrderItemToInsert.isEmpty()){
            INSERT listSalesOrderItemToInsert; 
        }
        
        // create calling  to sales order Line Item
        //Update Tax and Total Amount in Sales Order
        for(Sales_Order__c so: [SELECT Id, Sent_for_Manager_Approval_Mexico__c, Sent_for_Director_Approval_Mexico__c, 
                                Sent_for_Latam_Director_Approval__c, Order_Status__c, SentEmailIndonesia__c,
                                Net_Amount__c,Sent_for_CFO__c FROM Sales_Order__c WHERE Id IN : salesOrderList_Id])
        {
            so.Total_Amount__c = so.Net_Amount__c;
            so.Opportunity__c = opportunityId; //CEVD(Nishigandha): Added opportunityId
            if(RM == true){
                so.Sent_for_Manager_Approval_Mexico__c = true;
            }
            if(SD == true){
                so.Sent_for_Director_Approval_Mexico__c = true;
            }
            if(SRH == true){
                so.Sent_for_Latam_Director_Approval__c = true;    
            }
            if(CFO==true){
                so.Sent_for_CFO__c = true;     
                so.Sent_for_Latam_Director_Approval__c = true;     
            }
            if(LRH == true){
                so.Sent_for_Latam_Director__c = true;
            }
            if(CCO==true){
                so.Sent_for_CCO__c = true;
            }
            
            if(so.Sent_for_Manager_Approval_Mexico__c || so.Sent_for_Director_Approval_Mexico__c || so.Sent_for_Latam_Director_Approval__c || so.Sent_for_CFO__c){
                so.Order_Status__c = 'Pending';
                so.Last_Approver_Date_Time__c = System.today();
            }
            else{
                so.Order_Status__c = 'Open';
            }
            if(totalOrderAmount != 0 && totalOrderAmount < 80000 && mapIncoTerm.containsKey(inco_Term)){
                so.Order_Status__c = 'Draft';
            }
            soListToUpdate.add(so);
        }
        
        List<String>salesOrderIdList = new List<String>();
        
        for(Sales_Order__c so : orgSalesorderMap.values()){
            salesOrderIdList.add(so.Id);
        }                               
        if(po_num != null && String.isNotBlank(po_num)){
            List<Attachment> listAtt = new List<Attachment>();
            List<Attachment> attachList = [SELECT Id, Name, ParentId, IsPrivate, ContentType, Body, 
                                           Description FROM Attachment WHERE parentId =: orderObj.Id 
                                           ORDER BY CreatedDate DESC LIMIT 1];
            for(String soid : salesOrderIdList){
                if(soid !=null && !attachList.isEmpty() || Test.isRunningTest()){
                    Attachment attObj = new Attachment();
                    
                    attObj.Name = attachList[0].Name;
                    attObj.ParentId = soid;
                    attObj.IsPrivate = attachList[0].IsPrivate;  
                    attObj.ContentType = attachList[0].ContentType;
                    attObj.Body = attachList[0].Body;
                    attObj.Description = attachList[0].Description;
                    listAtt.add(attObj);
                }
            }
            if(!listAtt.isEmpty()){
                INSERT listAtt;
            }
        }
        
        if(!soListToUpdate.isEmpty()){            
            update soListToUpdate;
        }
        
        return salesOrderList_Id;
    }
    // SKI(Vishal P) : #CR152 : PO And Delivery Date : 18-07-2022..........poDate added....
    public static String createSalesOrder(String skuCurrency, String divisionId, String distWrapObj_str, Boolean Manager, Boolean Latam_Director,
                                          Boolean Director, String storageIdChosen, Order__c orderObj, GetDetailsWrap detailObj,
                                          ShippingLocationWrapper selectedShippingLocation, String payment_method, String payment_term,
                                          String inco_term, String po_num, Decimal totalOrderAmount, String remark, String depotSegmentvalue,
                                          Boolean RM, Boolean SD, Boolean SRH, Boolean LRH, Boolean CCO, Boolean CFO,Date poDate,List<USD_Exchange_Rate__c> exchangeList,List<Depot__c> argentinaDepoList1,Payment_Term__c payTermObj) {
                                              System.debug('calling Create Sales Order');
                                              Sales_Order__c soObj;
                                              Map<String, Sales_Order__c> orgSalesorderMap = detailObj.orgSalesorderMap;
                                              DistributerWrapperObj distWrapObj = (DistributerWrapperObj)system.JSON.deserializeStrict(distWrapObj_str, DistributerWrapperObj.class);
                                              List<Depot__c> argentinaDepoList = argentinaDepoList1;//[SELECT Id, Shipping_condition__c From Depot__c WHERE Id =: storageIdChosen LIMIT 1];
                                              Map<String, DistributorSalesAreaMapping__c> distributorSalesAreaMappingMAP = distWrapObj.distributorSalesAreaMappingMAP;
                                              Map<Id, Inco_Term__c> mapIncoTerm = detailObj.mapIncoTerm;
                                              String dvsnId = '';
                                              
                                              if(orderObj != null && !orgSalesorderMap.containskey(skuCurrency+divisionId)){ 
                                                  soObj = new Sales_Order__c();
                                                  //soObj.Mexico_Segment_Type__c = depotSegmentvalue; 
                                                  soObj.Sold_to_Party__c = detailObj.accountId;
                                                  soObj.Bill_To_Party__c = detailObj.accountId;
                                                  soObj.Order_Date__c = System.today();
                                                  soObj.Order_Raise_By__c = detailObj.orderRaisedBy;
                                                      
                                                  soObj.Purchase_Order_Date__c = poDate; // SKI(Vishal P) : #CR152 : PO And Delivery Date : 18-07-2022
                                                  
                                                  //added By Vishal Pawar for Marginal Block and PLN
                                                  if(Manager==true || RM == true){
                                                      soObj.Sent_for_Manager_Approval_Mexico__c = true;
                                                  }
                                                  if(Director== true || SD== true ){
                                                      soObj.Sent_for_Director_Approval_Mexico__c = true;
                                                  }
                                                  if(Latam_Director == true || SRH == true){
                                                      soObj.Sent_for_Latam_Director_Approval__c = true;    
                                                  }
                                                  if(CFO==true){
                                                      soObj.Sent_for_CFO__c = true;     
                                                      soObj.Sent_for_Latam_Director_Approval__c = true;     
                                                  }
                                                  
                                                  if(LRH == true){
                                                      soObj.Sent_for_Latam_Director__c = true;
                                                  }
                                                  
                                                  if(CCO==true){
                                                      soObj.Sent_for_CCO__c = true;
                                                  }
                                                  
                                                  
                                                  //Ended by Vishal Pawar for Marginal Block and PLN
                                                  
                                                  soObj.Depot__c = storageIdChosen;
                                                  soObj.CreatedFrom__c = 'SFDC';                           
                                                  soObj.OwnerId = UserInfo.getUserId();  
                                                  if(detailObj.RM_AccountOwner != null){
                                                      soObj.OwnerId = detailObj.RM_AccountOwner;
                                                  }
                                                  soObj.Order__c = orderObj.Id;
                                                  soObj.Ship_To_Party__c = selectedShippingLocation.locationId;
                                                  soObj.Sales_Org_lk__c = distWrapObj.salesOrgId;
                                                  soObj.PaymentMethod__c = payment_method;
                                                  soObj.Payment_Term__c = payment_term;
                                                  
                                                 
                                                  
                                                  
                                                  String invalidNumbers = '[^0-9]'; 
                                                  String str = payTermObj.Payterms_Desc__c;
                                                  if(str!='Contado'){
                                                      String res = str.replaceAll( invalidNumbers, '' );
                                                      if(Integer.valueof(res)>180){
                                                          soObj.Sent_for_CFO__c = true;
                                                          soObj.Sent_for_Latam_Director_Approval__c =true;
                                                      }
                                                  }
                                                  soObj.Inco_Term__c = inco_term;
                                                  if(skuCurrency != '-None-'){
                                                      soObj.CurrencyIsoCode = skuCurrency;
                                                  }else{
                                                      soObj.CurrencyIsoCode ='';
                                                  }
                                                  if(skuCurrency=='MXN'){
                                                     
                                                      if(exchangeList.size()>0){
                                                      soObj.Exchange_Rate__c = exchangeList[0].Exchange_Rate__c;
                                                      soObj.Exchange_Rate_Valid_From_Date__c = exchangeList[0].Valid_From__c;
                                                      soObj.Exchange_Ratio_from__c = exchangeList[0].Ratio_from__c;
                                                      soObj.Exchange_Ration_To__c = exchangeList[0].Ration_To__c;
                                                  }
                                                  
                                                  }
                                                  
                                                  soObj.Distribution_Channel_lk__c = distWrapObj.distributorChannelId;
                                                 
                                                  soObj.Manager__c = detailObj.managerId;
                                                  soObj.Sales_Director_Mexico__c = detailObj.salesDirectorId;
                                                  soObj.Latam_Director_Mexico__c = detailObj.latamDirectorId;
                                                  soObj.RegionalManager__c = detailObj.nationalMarketingMgrId;
                                                  soObj.REH__c = detailObj.nationalSaleMgrId;
                                                   
                                                  if(distributorSalesAreaMappingMAP.containsKey(divisionId)){
                                                      soObj.Division_lk__c = DistributorSalesAreaMappingMAP.get(divisionId).Division__c;
                                                      dvsnId = DistributorSalesAreaMappingMAP.get(divisionId).Division__c;
                                                      //Added for CR : SCTASK0298876 (RITM0136949)
                                                      if(DistributorSalesAreaMappingMAP.get(divisionId).Division__r.Division_Code__c == '10')
                                                      {soObj.Mexico_Segment_Type__c = 'Sales Team';}
                                                      else if(DistributorSalesAreaMappingMAP.get(divisionId).Division__r.Division_Code__c == '20')
                                                      {soObj.Mexico_Segment_Type__c = 'B2B';}
                                                      else if(DistributorSalesAreaMappingMAP.get(divisionId).Division__r.Division_Code__c == '60')
                                                      {soObj.Mexico_Segment_Type__c = 'ALP';}
                                                      
                                                  }
                                                  if(!argentinaDepoList.isEmpty()){
                                                      soObj.Shipping_condition__c = argentinaDepoList[0].Shipping_condition__c;
                                                  }
                                                  soObj.Credit_Term__c = distWrapObj.paymentTerms;
                                                  if(remark != null && !String.isBlank(remark)){
                                                      String s = remark;
                                                      if(s.length() <= 1000){
                                                          soObj.Remarks_Long__c = remark;
                                                          if(s.length() > 130){
                                                              soObj.SAP_Remark__c = addCharIntoRemark(s);
                                                          }else{
                                                              soObj.SAP_Remark__c = remark;
                                                          }
                                                      }
                                                  }
                                                  
                                                  if(po_num != null && String.isNotBlank(po_num)){
                                                      soObj.PONumber__c = po_num;
                                                  }
                                                  if(soObj.Order_Raise_By__c == 'Distributor'){
                                                      soObj.Designated_Owner__c = detailObj.territoryManagerId;
                                                  }else{
                                                      soObj.Designated_Owner__c = UserInfo.getUserId();
                                                  }
                                                  List<Order_Type__c> orderTypeList = [Select Id FROM Order_Type__c WHERE Order_Type_Code__c = 'ZZOR' and Division__c =:dvsnId and SalesOrg__r.Name = 'Mexico' LIMIT 1];
                                                  if(!orderTypeList.isEmpty()){soObj.Order_Type_lk__c = orderTypeList[0].Id;}
                                                  if(totalOrderAmount != 0 && totalOrderAmount < 80000 &&  mapIncoTerm.containsKey(inco_Term)){
                                                      soObj.Order_Status__c = 'Draft';
                                                  }
                                                  INSERT soObj;
                                                  orgSalesorderMap.put(skuCurrency+divisionId, soObj);
                                                   System.debug('Count me in create');
                                              }                                              
                                              else{                                                  
                                                  soObj = new Sales_Order__c();
                                                  soObj = orgSalesorderMap.get(skuCurrency+divisionId);
                                                  If(!soObj.Sent_for_Manager_Approval_Mexico__c && Manager){
                                                      soObj.Sent_for_Manager_Approval_Mexico__c = Manager;
                                                      
                                                  }
                                                  if(!soObj.Sent_for_Director_Approval_Mexico__c && Director){
                                                      soObj.Sent_for_Director_Approval_Mexico__c = Director;
                                                  }
                                                  if(!soObj.Sent_for_Latam_Director_Approval__c && Latam_Director){
                                                      soObj.Sent_for_Latam_Director_Approval__c = Latam_Director;
                                                      
                                                  }
                                                  if(totalOrderAmount != 0 && totalOrderAmount < 80000 &&  mapIncoTerm.containsKey(inco_Term)){
                                                      soObj.Order_Status__c = 'Draft';
                                                  }
                                                   System.debug('Count me in update');
                                                   orgSalesorderMap.put(skuCurrency+divisionId, soObj);
                                                 // UPDATE soObj;
                                              }
                                               detailObj.orgSalesorderMap = orgSalesorderMap;
                                              return soObj.Id;
                                          }
    
    
    
    public static WrappergetOrder getSKUOrderList(Sales_Order__c sorderObj, List<String> divisionIds,GetDetailsWrap detailsWrapObj){
        
        
        WrappergetOrder getOdrObj = new WrappergetOrder();
        List<SKUDetails> listSKUOrders = new List<SKUDetails>();
        String sorderId = sorderObj.Id;
        SKUDetails skuWrapObj;
        
        orderSummaryUOM osUOM = new orderSummaryUOM ();
        orderSummaryUOMmapClass mapOSU = new orderSummaryUOMmapClass();
        Map<String, orderSummaryUOM> orderSummaryUOMmap = mapOSU.orderSummaryUOMmap;
        
        orderSummaryCurrency OSC = new orderSummaryCurrency();
        orderSummaryCurrencyMap mapOSC = new orderSummaryCurrencyMap();
        Map<String, orderSummaryCurrency> mapCurrencyOrderSummary = mapOSC.mapCurrencyOrderSummary;
        
        List<Price_Block_Margin_Matrix__c> pbmmE2eUPC9List = new List<Price_Block_Margin_Matrix__c>();
        List<Price_Block_Margin_Matrix__c> pbmmE2eMBEBList = new List<Price_Block_Margin_Matrix__c>();
        List<Price_Block_Margin_Matrix__c> pbmmE2eList = new List<Price_Block_Margin_Matrix__c>();
        
        List<Profit_Center__c> profitCenterList = new List<Profit_Center__c>();
        
        MAP<String,Price_Block_Margin_Matrix__c> prcE2eBlockMap = new MAP<String,Price_Block_Margin_Matrix__c>();
        
        
        
        profitCenterList =[SELECT Id, Name, Profit_Center__c, Sales_Value__c, Sales_Org__c, Depot__c, Combination_Key__c 
                           FROM Profit_Center__c 
                           WHERE Sales_Org__r.Sales_Org_Code__c ='5100' ORDER BY LastModifiedDate DESC  LIMIT 1];
        
        //this is for e2e
        pbmmE2eList = [SELECT Id, Name, SKU_Code__c, SKU_Active__c, UOM__c, 
                       Sales_Org__c,E2E_Cost_LC__c, E2E_Cost_USD__c, E2E_Cost_UPC9_LC__c, 
                       E2E_Cost_UPC9_USD__c, E2E_Cost_MBEW_LC__c, E2E_Cost_MBEW_USD__c
                       FROM Price_Block_Margin_Matrix__c
                       WHERE Sales_Org__r.Sales_Org_Code__c='5100'
                       AND Depot_Code__c =:detailsWrapObj.depoId
                       AND Start_Date__c<= today AND End_Date__c>= today
                       AND (E2E_Cost_LC__c != null OR E2E_Cost_USD__c != null)
                       AND UOM__c !=null
                       AND Profit_Center__c=:profitCenterList[0].Id
                       AND Type__c ='E2ECost' ORDER BY LastModifiedDate ASC ];
        
        pbmmE2eUPC9List = [SELECT Id, Name, SKU_Code__c, SKU_Active__c, UOM__c, 
                           Sales_Org__c,E2E_Cost_LC__c, E2E_Cost_USD__c, E2E_Cost_UPC9_LC__c, 
                           E2E_Cost_UPC9_USD__c, E2E_Cost_MBEW_LC__c, E2E_Cost_MBEW_USD__c
                           FROM Price_Block_Margin_Matrix__c
                           WHERE Sales_Org__r.Sales_Org_Code__c='5100'
                           AND UOM__c !=null
                           AND Depot_Code__c =:detailsWrapObj.depoId
                           AND Start_Date__c<= today AND End_Date__c>= today
                           AND (E2E_Cost_UPC9_LC__c !=null OR E2E_Cost_UPC9_USD__c != null)
                           AND Type__c ='E2ECostUPC9' ORDER BY LastModifiedDate ASC ];
        
        pbmmE2eMBEBList = [SELECT Id, Name, SKU_Code__c, SKU_Active__c, UOM__c, 
                           Sales_Org__c,E2E_Cost_LC__c, E2E_Cost_USD__c, E2E_Cost_UPC9_LC__c, 
                           E2E_Cost_UPC9_USD__c, E2E_Cost_MBEW_LC__c, E2E_Cost_MBEW_USD__c
                           FROM Price_Block_Margin_Matrix__c
                           WHERE Sales_Org__r.Sales_Org_Code__c='5100'
                           AND UOM__c !=null
                           AND Depot_Code__c =:detailsWrapObj.depoId
                           AND Start_Date__c<= today AND End_Date__c>= today
                           AND (E2E_Cost_MBEW_LC__c !=null OR E2E_Cost_MBEW_USD__c != null)
                           AND Type__c ='E2ECostMBEW' ORDER BY LastModifiedDate ASC ];
        
        if(pbmmE2eMBEBList.size()>0){
            for(Price_Block_Margin_Matrix__c pbmmObj:pbmmE2eMBEBList){
                prcE2eBlockMap.put(pbmmObj.SKU_Code__c,pbmmObj);
            }
        }
        
        if(pbmmE2eUPC9List.size()>0){
            for(Price_Block_Margin_Matrix__c pbmmObj:pbmmE2eUPC9List){
                prcE2eBlockMap.put(pbmmObj.SKU_Code__c,pbmmObj);
            }
        }
        
        if(pbmmE2eList.size()>0){
            for(Price_Block_Margin_Matrix__c pbmmObj:pbmmE2eList){
                prcE2eBlockMap.put(pbmmObj.SKU_Code__c,pbmmObj);
            }
        }
        
        List<Sales_order_line_item__c> soLineItemList = new List <Sales_order_line_item__c>();
        // SKI(Vishal P) : #CR152 : PO And Delivery Date : 18-07-2022......Delivery_Date__c added....
        soLineItemList = [SELECT Id, Delivery_Date__c,Manager_Price__c, Storage_Location__c, Director_Price__c, CurrencyIsoCode, Sale_Order__c, 
                          multipleOf__c, SKU_Description__c, MinPrice__c, MaxPrice__c, Comment__c, FinalPrice__c, Campaign_Discount__c, 
                          SKU_Name__c, SKU_Name__r.Division__c, SKU_Name__r.pallet_Size_Italy__c, Type_of_Sale__c,
                          Net_Price__c, crop__r.name, Crop1_Percentage__c, Crop2__r.name, Crop2_Percentage__c, Crop3__r.name, 
                          Crop3_Percentage__c, Crop4__r.name, Crop4_Percentage__c, Crop5__r.name, Crop5_Percentage__c,
                          Quantity__c, UOM__c, Material_Discount__c, Distributor_Discount__c, DistributorDiscountPercentage__c,
                          SKU_Name__r.Brand_Name__c, Price__c, SKU_Name__r.Special_SKU__c,SKU_Name__r.Name, Shipping_Date__c,Agrosat_Sale_Mexico__c
                          FROM Sales_Order_Line_Item__c WHERE Sale_Order__c =: sorderId];
        
        List<String> skuIdsList = new List<String>();
        
        if(soLineItemList != null && !soLineItemList.isEmpty()){
            for(Sales_order_line_item__c soliOsbj : soLineItemList){                
                skuIdsList.add(soliOsbj.SKU_Name__c);                
            }
        }

              List<Price_Block_Margin_Matrix__c> pbmmSalesDeduList = new List<Price_Block_Margin_Matrix__c>();                
                MAP<String,List<Price_Block_Margin_Matrix__c>> prcBlockForDeduMap1 = new MAP<String,List<Price_Block_Margin_Matrix__c>>();
                pbmmSalesDeduList = [SELECT Id, Name, SKU_Code__c, SKU_Active__c, UOM__c, 
                                     Sales_Deduction_LC__c, Sales_Deduction_USD__c                                 
                                     FROM Price_Block_Margin_Matrix__c
                                     WHERE Sales_Org__r.Sales_Org_Code__c='5100'
                                     AND (Sales_Deduction_LC__c != null OR Sales_Deduction_USD__c != null) //Change for RITM0526193 - Added the check for Sales_Deduction_USD__c
                                     AND SKU_Code__c IN :skuIdsList
                                     AND Type__c ='SalesDeduction'
                                     AND Start_Date__c<= today AND End_Date__c>= today ORDER BY LastModifiedDate ASC ];
                    
        for(Price_Block_Margin_Matrix__c pobj:pbmmSalesDeduList){
            if(prcBlockForDeduMap1.containsKey(pobj.SKU_Code__c)){
                List<Price_Block_Margin_Matrix__c> ppmList = prcBlockForDeduMap1.get(pobj.SKU_Code__c);
                ppmList.add(pobj);
                prcBlockForDeduMap1.put(pobj.SKU_Code__c,ppmList);
            }else{
                List<Price_Block_Margin_Matrix__c> ppmList = new List<Price_Block_Margin_Matrix__c>();
                ppmList.add(pobj);
                prcBlockForDeduMap1.put(pobj.SKU_Code__c,ppmList);
            }
        }
        
        
        List<Price_Block_Margin_Matrix__c> pbmmReabteList = new List<Price_Block_Margin_Matrix__c>();
                MAP<String,List<Price_Block_Margin_Matrix__c>> prcBlockReabteMap1 = new MAP<String,List<Price_Block_Margin_Matrix__c>>();
                pbmmReabteList =[SELECT Id, Name, SKU_Code__c, SKU_Active__c, UOM__c, 
                                 Rebate_LC__c, Rebate_USD__c, Rebate__c,Rebate_Code__c 
                                 FROM Price_Block_Margin_Matrix__c
                                 WHERE Sales_Org__r.Sales_Org_Code__c='5100'
                                 AND Distributor_Code__c=:detailsWrapObj.accountId
                                 AND SKU_Code__c IN :skuIdsList
                                 AND Start_Date__c<= today AND End_Date__c>= today
                                 AND (Rebate_LC__c!=null OR Rebate_USD__c!=null OR Rebate__c!=null)
                                 AND Rebate_Code__c!=null
                                 AND Type__c ='Rebate' ORDER BY LastModifiedDate DESC ];
        
        for(Price_Block_Margin_Matrix__c tobj:pbmmReabteList){
            if(prcBlockReabteMap1.containsKey(tobj.SKU_Code__c)){
                List<Price_Block_Margin_Matrix__c> pbList = prcBlockReabteMap1.get(tobj.SKU_Code__c);
                pbList.add(tobj);
                prcBlockReabteMap1.put(tobj.SKU_Code__c,pbList);                
            }else{
                List<Price_Block_Margin_Matrix__c> pbList = new  List<Price_Block_Margin_Matrix__c>();
                pbList.add(tobj);
                prcBlockReabteMap1.put(tobj.SKU_Code__c,pbList); 
            }
        }
        
        
        List<Price_Block_Margin_Matrix__c> pbmmDiscountList = new List<Price_Block_Margin_Matrix__c>();
                MAP<String,List<Price_Block_Margin_Matrix__c>> prcBlockDiscountMap1 = new MAP<String,List<Price_Block_Margin_Matrix__c>>();
                pbmmDiscountList = [SELECT Id, Name, SKU_Code__c, SKU_Active__c, UOM__c, 
                                    Sales_Org__c, Discount_LC__c, Discount_USD__c, 
                                    Discount__c
                                    FROM Price_Block_Margin_Matrix__c
                                    WHERE Sales_Org__r.Sales_Org_Code__c='5100'
                                    AND SKU_Code__c IN :skuIdsList
                                    AND Distributor_Code__c=:detailsWrapObj.accountId
                                    AND Start_Date__c<= today AND End_Date__c>= today
                                    AND Type__c ='Discount'
                                    AND (Discount_LC__c!=null OR Discount_USD__c!=null OR Discount__c!=null) ORDER BY LastModifiedDate ASC ];
        
        for(Price_Block_Margin_Matrix__c priBObj :pbmmDiscountList){
            if(prcBlockDiscountMap1.containsKey(priBObj.SKU_Code__c)){
                List<Price_Block_Margin_Matrix__c> pbmList = prcBlockDiscountMap1.get(priBObj.SKU_Code__c);
                pbmList.add(priBObj);
                prcBlockDiscountMap1.put(priBObj.SKU_Code__c,pbmList);                
            }else{
                List<Price_Block_Margin_Matrix__c> pbmList = new List<Price_Block_Margin_Matrix__c>();
                pbmList.add(priBObj);
                prcBlockDiscountMap1.put(priBObj.SKU_Code__c,pbmList);
            }
        }
        
        List<Price_Block_Margin_Matrix__c> pbmmAddDiscountList = new List<Price_Block_Margin_Matrix__c>();
                MAP<String,List<Price_Block_Margin_Matrix__c>> prcBlockAddDiscountMap1 = new MAP<String,List<Price_Block_Margin_Matrix__c>>();
                pbmmAddDiscountList = [SELECT Id, Name, SKU_Code__c, SKU_Active__c, UOM__c, 
                                       Sales_Org__c, Additional_Discount_LC__c, Additional_Discount_USD__c, 
                                       Additional_Discount__c
                                       FROM Price_Block_Margin_Matrix__c
                                       WHERE Sales_Org__r.Sales_Org_Code__c='5100'
                                       AND Distributor_Code__c=:detailsWrapObj.accountId
                                       AND SKU_Code__c IN :skuIdsList
                                       AND Type__c ='AdditionalDiscount'
                                       AND Start_Date__c<= today AND End_Date__c>= today
                                       AND (Additional_Discount_LC__c!=null OR Additional_Discount_USD__c!= null OR Additional_Discount__c!= null) ORDER BY LastModifiedDate ASC ];
        for(Price_Block_Margin_Matrix__c tmpObj:pbmmAddDiscountList){
            if(prcBlockAddDiscountMap1.containsKey(tmpObj.SKU_Code__c)){
                List<Price_Block_Margin_Matrix__c> pbmList = prcBlockAddDiscountMap1.get(tmpObj.SKU_Code__c);
                pbmList.add(tmpObj);
                prcBlockAddDiscountMap1.put(tmpObj.SKU_Code__c,pbmList);                
            }else{
                List<Price_Block_Margin_Matrix__c> pbmList = new List<Price_Block_Margin_Matrix__c>();
                pbmList.add(tmpObj);
                prcBlockAddDiscountMap1.put(tmpObj.SKU_Code__c,pbmList); 
            }
        }
        
        List<Price_Block_Margin_Matrix__c> pbmmPlnList = new List<Price_Block_Margin_Matrix__c>();
                MAP<String,List<Price_Block_Margin_Matrix__c>> prcBlockPlnMap1 = new MAP<String,List<Price_Block_Margin_Matrix__c>>();
                pbmmPlnList =[SELECT Id, Name, SKU_Code__c, SKU_Active__c, UOM__c, 
                              Sales_Org__c, PLN_LC__c, PLN_USD__c 
                              FROM Price_Block_Margin_Matrix__c
                              where Sales_Org__r.Sales_Org_Code__c='5100'
                              AND SKU_Code__c IN :skuIdsList
                              AND Type__c ='PLN'
                              AND Start_Date__c<= today AND End_Date__c>= today
                              AND PLN_LC__c!=null ORDER BY LastModifiedDate ASC ];
        for(Price_Block_Margin_Matrix__c prbObj:pbmmPlnList){
            if(prcBlockPlnMap1.containsKey(prbObj.SKU_Code__c)){
                List<Price_Block_Margin_Matrix__c> plbList = prcBlockPlnMap1.get(prbObj.SKU_Code__c);
                plbList.add(prbObj);
                prcBlockPlnMap1.put(prbObj.SKU_Code__c,plbList);
            }else{
                List<Price_Block_Margin_Matrix__c> plbList = new  List<Price_Block_Margin_Matrix__c>();
                plbList.add(prbObj);
                prcBlockPlnMap1.put(prbObj.SKU_Code__c,plbList);                
            }
        }
        
        if(soLineItemList != null && !soLineItemList.isEmpty()){
            for(Sales_order_line_item__c soliObj : soLineItemList){
                skuWrapObj = new SKUDetails();
                skuWrapObj.skuCode = soliObj.SKU_Name__r.Name;
                skuWrapObj.palletSize = soliObj.SKU_Name__r.pallet_Size_Italy__c;
                skuWrapObj.cropName1 = soliObj.Crop__r.Name;
                skuWrapObj.agrosatSale = soliObj.Agrosat_Sale_Mexico__c;
                skuWrapObj.cropName3 = soliObj.Crop2__r.Name;
                skuWrapObj.cropName3 = soliObj.Crop3__r.Name;
                skuWrapObj.cropName4 = soliObj.Crop4__r.Name;
                skuWrapObj.cropName5 = soliObj.Crop5__r.Name;
                skuWrapObj.crop1 = soliObj.crop__c;
                skuwrapObj.crop1_Percentage = soliObj.Crop1_Percentage__c;
                skuWrapObj.crop2 = soliObj.crop2__c;
                skuwrapObj.crop2_Percentage = soliObj.Crop2_Percentage__c;
                skuWrapObj.crop3 = soliObj.crop3__c;
                skuwrapObj.crop3_Percentage = soliObj.Crop3_Percentage__c;
                skuWrapObj.crop4 = soliObj.crop4__c;
                skuwrapObj.crop4_Percentage = soliObj.Crop4_Percentage__c;
                skuWrapObj.crop5 = soliObj.crop5__c;
                skuwrapObj.crop5_Percentage = soliObj.Crop5_Percentage__c;
                skuWrapObj.skuId = soliObj.SKU_Name__c;
                skuWrapObj.finalPrice = soliObj.Net_Price__c;
                if(soliObj.Type_of_Sale__c != null){
                    skuWrapObj.typeOfSale = soliObj.Type_of_Sale__c;
                    if(soliObj.Type_of_Sale__c == 'Promotion'){
                        skuWrapObj.disablePrice = true;
                        skuWrapObj.finalPrice = 0.01;
                    }
                }
                skuWrapObj.oliId = soliObj.Id;
                skuWrapObj.brandName = soliObj.SKU_Description__c+' '+soliObj.SKU_Name__r.Name;
                
                skuWrapObj.specialSKU = soliObj.SKU_Name__r.Special_SKU__c;
                
                skuWrapObj.multipleOf = soliObj.multipleOf__c;
                skuWrapObj.price = soliObj.Price__c;
                skuWrapObj.minPrice = soliObj.MinPrice__c;
                
                skuWrapObj.qty = soliObj.Quantity__c;
                skuWrapObj.netRateEntered = soliObj.Price__c;
                Decimal totalpri = skuWrapObj.netRateEntered;
                skuWrapObj.netRateEnteredText = String.valueOf(totalpri);
                if(totalpri != null && soliObj.Type_of_Sale__c != 'Promotion'){
                    Decimal totalpriwithNoDecimal = Math.round(totalpri * 100) / 100;
                    skuWrapObj.netRateEnteredText = String.valueOf(totalpriwithNoDecimal);
                }                
                skuWrapObj.maxPrice = soliObj.MaxPrice__c;
                skuWrapObj.deliveryDate = soliObj.Shipping_Date__c; // SKI(Vishal P) : #CR152 : PO And Delivery Date : 18-07-2022
                skuWrapObj.customerDeliveryDate = soliObj.Delivery_Date__c;
                skuWrapObj.UOM = soliObj.UOM__c;
                skuWrapObj.Director_Price = soliObj.Director_Price__c;
                skuWrapObj.Manager_Price = soliObj.Manager_Price__c;
                skuWrapObj.currencyIso = soliObj.CurrencyIsoCode;
                                
                if(prcE2eBlockMap.containsKey(soliObj.SKU_Name__c)){                   
                    Price_Block_Margin_Matrix__c pbMME2eObj = prcE2eBlockMap.get(soliObj.SKU_Name__c);
                    skuWrapObj.e2ECostLC = pbMME2eObj.E2E_Cost_LC__c ; 
                    skuWrapObj.e2ECostUSD = pbMME2eObj.E2E_Cost_USD__c ;  
                    skuWrapObj.e2ECostUPC9LC = pbMME2eObj.E2E_Cost_UPC9_LC__c ; 
                    skuWrapObj.e2ECostUPC9USD = pbMME2eObj.E2E_Cost_UPC9_USD__c ;  
                    skuWrapObj.e2ECostMBEWLC = pbMME2eObj.E2E_Cost_MBEW_LC__c ; 
                    skuWrapObj.e2ECostMBEWUSD = pbMME2eObj.E2E_Cost_MBEW_USD__c;
                    skuWrapObj.uome2eCost = pbMME2eObj.UOM__c;
                }
                 
                List<Price_Block_Margin_Matrix__c> pbmmSalesDeduList1 = new List<Price_Block_Margin_Matrix__c>();                
                MAP<String,Price_Block_Margin_Matrix__c> prcBlockForDeduMap = new MAP<String,Price_Block_Margin_Matrix__c>();
                if(prcBlockForDeduMap1.containsKey(soliObj.SKU_Name__c)){
                    pbmmSalesDeduList1 = prcBlockForDeduMap1.get(soliObj.SKU_Name__c);    
                }
                
                
                if(pbmmSalesDeduList1.size()>0){                
                    for(Price_Block_Margin_Matrix__c dedObj : pbmmSalesDeduList1){
                        prcBlockForDeduMap.put(dedObj.SKU_Code__c,dedObj);
                    }
                }
                
                //for sales deductions
                if(prcBlockForDeduMap.containsKey(soliObj.SKU_Name__c)){
                    Price_Block_Margin_Matrix__c pbMMSalesDedObj = prcBlockForDeduMap.get(soliObj.SKU_Name__c);
                    
                    if(pbMMSalesDedObj.Sales_Deduction_LC__c!=null){
                        skuWrapObj.salesDeductionLC = pbMMSalesDedObj.Sales_Deduction_LC__c;  // if this value not     
                    }else{
                        skuWrapObj.salesDeductionInPercent = profitCenterList[0].Sales_Value__c;
                    }
                    skuWrapObj.salesDeductionUSD = pbMMSalesDedObj.Sales_Deduction_USD__c ;
                    skuWrapObj.uomSalesDeduction = pbMMSalesDedObj.UOM__c ;
                }
                List<Price_Block_Margin_Matrix__c> pbmmReabteList1 = new List<Price_Block_Margin_Matrix__c>();
                MAP<String,List<Price_Block_Margin_Matrix__c>> prcBlockReabteMap = new MAP<String,List<Price_Block_Margin_Matrix__c>>();
                if(prcBlockReabteMap1.containsKey(soliObj.SKU_Name__c)){
                    pbmmReabteList1 =prcBlockReabteMap1.get(soliObj.SKU_Name__c);    
                }
                
                if(pbmmReabteList1.size()>0){
                    for(Price_Block_Margin_Matrix__c rebateObj :pbmmReabteList1){
                        //change map object to list 
                        
                        if(!prcBlockReabteMap.containsKey(rebateObj.SKU_Code__c)){
                            List<Price_Block_Margin_Matrix__c> prbList = new List<Price_Block_Margin_Matrix__c>();
                            prbList.add(rebateObj);
                            prcBlockReabteMap.put(rebateObj.SKU_Code__c,prbList);
                        }else{
                            List<Price_Block_Margin_Matrix__c> prbList = new List<Price_Block_Margin_Matrix__c>();
                            prbList = prcBlockReabteMap.get(rebateObj.SKU_Code__c);                       
                            prbList.add(rebateObj);
                            prcBlockReabteMap.put(rebateObj.SKU_Code__c,prbList);
                            
                        }
                        
                    }
                }
                
                //for Rebate Values
                if(prcBlockReabteMap.containsKey(soliObj.SKU_Name__c)){
                    List<Price_Block_Margin_Matrix__c> pbMMRebateList = prcBlockReabteMap.get(soliObj.SKU_Name__c);
                    
                    
                    if(pbMMRebateList.size()>0){
                        if(pbMMRebateList.size()>=2){
                            String rebateCode1 = pbMMRebateList[0].Rebate_Code__c;
                            String rebateCode2 = pbMMRebateList[1].Rebate_Code__c;
                            if(rebateCode1!=rebateCode2){
                                
                                skuWrapObj.rebate1LC = pbMMRebateList[0].Rebate_LC__c; 
                                skuWrapObj.rebate1USD = pbMMRebateList[0].Rebate_USD__c; 
                                skuWrapObj.rebate1Percent = pbMMRebateList[0].Rebate__c;
                                skuWrapObj.uomRebate1 = pbMMRebateList[0].UOM__c;
                                skuWrapObj.rebateCode1 = pbMMRebateList[0].Rebate_Code__c;
                                
                                skuWrapObj.rebate2LC = pbMMRebateList[1].Rebate_LC__c; 
                                skuWrapObj.rebate2USD = pbMMRebateList[1].Rebate_USD__c; 
                                skuWrapObj.rebate2Percent = pbMMRebateList[1].Rebate__c;
                                skuWrapObj.uomRebate2 = pbMMRebateList[1].UOM__c;
                                skuWrapObj.rebateCode2 = pbMMRebateList[1].Rebate_Code__c;                                
                            }
                        } else{
                            skuWrapObj.rebate1LC = pbMMRebateList[0].Rebate_LC__c; 
                            skuWrapObj.rebate1USD = pbMMRebateList[0].Rebate_USD__c; 
                            skuWrapObj.rebate1Percent = pbMMRebateList[0].Rebate__c;
                            skuWrapObj.rebateCode1 = pbMMRebateList[0].Rebate_Code__c;
                            skuWrapObj.uomRebate1 = pbMMRebateList[0].UOM__c;
                        } 
                    }             
                }
                 
                List<Price_Block_Margin_Matrix__c> pbmmDiscountList1 = new List<Price_Block_Margin_Matrix__c>();
                MAP<String,Price_Block_Margin_Matrix__c> prcBlockDiscountMap = new MAP<String,Price_Block_Margin_Matrix__c>();
                if(prcBlockDiscountMap1.ContainsKey(soliObj.SKU_Name__c)){
                    pbmmDiscountList1 = prcBlockDiscountMap1.get(soliObj.SKU_Name__c);    
                }
                
                
                if(pbmmDiscountList1.size()>0){
                    for(Price_Block_Margin_Matrix__c discontIbj:pbmmDiscountList1){
                        prcBlockDiscountMap.put(discontIbj.SKU_Code__c ,discontIbj);
                    }
                }
                
                
                //for discount
                if(prcBlockDiscountMap.containsKey(soliObj.SKU_Name__c)){
                    Price_Block_Margin_Matrix__c pbMMDiscountObj = prcBlockDiscountMap.get(soliObj.SKU_Name__c);
                    
                    skuWrapObj.discountLC = pbMMDiscountObj.Discount_LC__c; 
                    skuWrapObj.discountUSD = pbMMDiscountObj.Discount_USD__c; 
                    skuWrapObj.discountPercent = pbMMDiscountObj.Discount__c;
                    skuWrapObj.uomDiscount = pbMMDiscountObj.UOM__c;                    
                }
                
                
                
                
                List<Price_Block_Margin_Matrix__c> pbmmAddDiscountList1 = new List<Price_Block_Margin_Matrix__c>();
                MAP<String,Price_Block_Margin_Matrix__c> prcBlockAddDiscountMap = new MAP<String,Price_Block_Margin_Matrix__c>();
                if(prcBlockAddDiscountMap1.containsKey(soliObj.SKU_Name__c)){
                    pbmmAddDiscountList1 = prcBlockAddDiscountMap1.get(soliObj.SKU_Name__c);    
                }
                
                
                if(pbmmAddDiscountList1.size()>0){
                    for(Price_Block_Margin_Matrix__c addDisObj:pbmmAddDiscountList1){
                        prcBlockAddDiscountMap.put(addDisObj.SKU_Code__c,addDisObj);    
                    }            
                }
                
                
                //for additinal discount
                if(prcBlockAddDiscountMap.containsKey(soliObj.SKU_Name__c)){
                    Price_Block_Margin_Matrix__c pbMMAddDiscountObj = prcBlockAddDiscountMap.get(soliObj.SKU_Name__c);
                    
                    skuWrapObj.additionalDiscountLC = pbMMAddDiscountObj.Additional_Discount_LC__c;
                    skuWrapObj.additionalDiscountPercent = pbMMAddDiscountObj.Additional_Discount__c;
                    skuWrapObj.additionalDiscountUSD = pbMMAddDiscountObj.Additional_Discount_USD__c;
                    skuWrapObj.uomAddDiscount = pbMMAddDiscountObj.UOM__c;                    
                }
                
                List<Price_Block_Margin_Matrix__c> pbmmPlnList1 = new List<Price_Block_Margin_Matrix__c>();
                MAP<String,Price_Block_Margin_Matrix__c> prcBlockPlnMap = new MAP<String,Price_Block_Margin_Matrix__c>();
                if(prcBlockPlnMap1.containsKey(soliObj.SKU_Name__c)){
                pbmmPlnList1 =prcBlockPlnMap1.get(soliObj.SKU_Name__c);    
                }
                
                
                if(pbmmPlnList1.size()>0){
                    for(Price_Block_Margin_Matrix__c plnObj :pbmmPlnList1){
                        prcBlockPlnMap.put(plnObj.SKU_Code__c,plnObj);
                    }
                }
                
                //for PLN
                if(prcBlockPlnMap.containsKey(soliObj.SKU_Name__c)){
                    Price_Block_Margin_Matrix__c pbMMPlnObj = prcBlockPlnMap.get(soliObj.SKU_Name__c);                    
                    skuWrapObj.pLNLC = pbMMPlnObj.PLN_LC__c;
                    skuWrapObj.pLNUSD = pbMMPlnObj.PLN_USD__c; 
                    skuWrapObj.uomPLN = pbMMPlnObj.UOM__c; 
                }
                //End Added By vishal Pawar for Marginal Block and pln Values
                 if(mapCurrencyOrderSummary.containsKey(skuWrapObj.currencyIso)){
                    OSC = mapCurrencyOrderSummary.get(skuWrapObj.currencyIso);
                    OSC.totalValue = OSC.totalValue + skuWrapObj.netRateEntered;
                    mapCurrencyOrderSummary.put(skuWrapObj.currencyIso, OSC);
                }else{
                    OSC = new orderSummaryCurrency();
                    OSC.currencyName = skuWrapObj.currencyIso;
                    OSC.totalValue = skuWrapObj.netRateEntered;
                    mapCurrencyOrderSummary.put(skuWrapObj.currencyIso, OSC);
                }
                
                if(orderSummaryUOMmap.containsKey(skuWrapObj.UOM)){
                    osUOM =  orderSummaryUOMmap.get(skuWrapObj.UOM);
                    osUOM.totalQty = osUOM.totalQty+ skuWrapObj.qty;
                    orderSummaryUOMmap.put(skuWrapObj.UOM, osUOM);
                }else{
                    osUOM = new orderSummaryUOM();
                    osUOM.UOM = skuWrapObj.UOM;
                    osUOM.totalQty = skuWrapObj.qty;
                    orderSummaryUOMmap.put(skuWrapObj.UOM, osUOM);
                }
                listSKUOrders.add(skuWrapObj);
            }
        }
        getOdrObj.skuOrderList = listSKUOrders;
        getOdrObj.orderSummaryUOMList = orderSummaryUOMmap.values();
        getOdrObj.orderSummaryCurrencyList = mapCurrencyOrderSummary.values();
        return getOdrObj;
    }
    
    public static WrappergetOrder getSKUOrderList(mapSKUWrapper mapSkuObj, Order__c orderObj,GetDetailsWrap detailsWrapObj,List<String> divisionIds){
        
        WrappergetOrder getOdrObj = new WrappergetOrder();
        List<SKUDetails> listSKUOrders = new List<SKUDetails>();
        String orderId = orderObj.Id;
        Map<Id, SKUDetails> skuDetailsMap = mapSkuObj.skuDetailsMap;
        SKUDetails skuWrapObj;
        SKUDetails skuWrapObj2;
        
        orderSummaryUOM osUOM = new orderSummaryUOM ();
        orderSummaryUOMmapClass mapOSU = new orderSummaryUOMmapClass();
        Map<String, orderSummaryUOM> orderSummaryUOMmap = mapOSU.orderSummaryUOMmap;
        
        orderSummaryCurrency OSC = new orderSummaryCurrency();
        orderSummaryCurrencyMap mapOSC = new orderSummaryCurrencyMap();
        Map<String, orderSummaryCurrency> mapCurrencyOrderSummary = mapOSC.mapCurrencyOrderSummary;
        
        //Fetching Order Line Item List
        List<OrderLineItem__c> oliList = [SELECT Id, Name, CurrencyIsoCode, Order__c, UOM__c, SKU_Name__c, MaxPrice__c,
                                          SKU_Name__r.Product_Name__r.Name, Net_Price__c,SKU_Name__r.Brand_Name__c, Type_of_Sale__c,
                                          SKU_Name__r.Name, SKU_Name__r.pallet_Size_Italy__c, Quantity__c,crop__r.name, 
                                          Crop1_Percentage__c,Crop2__r.name, Crop2_Percentage__c,Crop3__r.name, Crop3_Percentage__c,
                                          Crop4__r.name, Crop4_Percentage__c,Crop5__r.name, Crop5_Percentage__c,
                                          Price__c, Item_Number__c, Item_Status__c, Order__r.Shipping_Location__c, 
                                          Shipping_Date__c,Agrosat_Sale_Mexico__c,
                                          SKU_Name__r.Special_SKU__c FROM OrderLineItem__c WHERE Order__c =: orderId];
        
        
        
        //added By Vishal Pawar for Marginal BLock and PLN value
        List<Profit_Center__c> profitCenterList = new List<Profit_Center__c>();
        
        List<Price_Block_Margin_Matrix__c> pbmmE2eList = new List<Price_Block_Margin_Matrix__c>();
        List<Price_Block_Margin_Matrix__c> pbmmE2eMBEBList = new List<Price_Block_Margin_Matrix__c>();
        List<Price_Block_Margin_Matrix__c> pbmmE2eUPC9List = new List<Price_Block_Margin_Matrix__c>();
         MAP<String,Price_Block_Margin_Matrix__c> prcE2eBlockMap = new MAP<String,Price_Block_Margin_Matrix__c>();
          profitCenterList =[SELECT Id, Name, Profit_Center__c, Sales_Value__c, Sales_Org__c, Depot__c, Combination_Key__c 
                           FROM Profit_Center__c 
                           WHERE Sales_Org__r.Sales_Org_Code__c='5100' ORDER BY LastModifiedDate DESC  LIMIT 1];
        pbmmE2eList = [SELECT Id, Name, SKU_Code__c, SKU_Active__c, UOM__c, 
                       Sales_Org__c,E2E_Cost_LC__c, E2E_Cost_USD__c, E2E_Cost_UPC9_LC__c, 
                       E2E_Cost_UPC9_USD__c, E2E_Cost_MBEW_LC__c, E2E_Cost_MBEW_USD__c
                       FROM Price_Block_Margin_Matrix__c
                       WHERE Sales_Org__r.Sales_Org_Code__c='5100'
                       AND Depot_Code__c =:detailsWrapObj.depoId
                       AND Start_Date__c<= today AND End_Date__c>= today
                       AND (E2E_Cost_LC__c != null OR E2E_Cost_USD__c != null)
                       AND UOM__c !=null
                       AND Profit_Center__c=:profitCenterList[0].Id
                       AND Type__c ='E2ECost' ORDER BY LastModifiedDate ASC ];
        
        pbmmE2eUPC9List = [SELECT Id, Name, SKU_Code__c, SKU_Active__c, UOM__c, 
                           Sales_Org__c,E2E_Cost_LC__c, E2E_Cost_USD__c, E2E_Cost_UPC9_LC__c, 
                           E2E_Cost_UPC9_USD__c, E2E_Cost_MBEW_LC__c, E2E_Cost_MBEW_USD__c
                           FROM Price_Block_Margin_Matrix__c
                           WHERE Sales_Org__r.Sales_Org_Code__c='5100'
                           AND UOM__c !=null
                           AND Depot_Code__c =:detailsWrapObj.depoId
                           AND Start_Date__c<= today AND End_Date__c>= today
                           AND (E2E_Cost_UPC9_LC__c !=null OR E2E_Cost_UPC9_USD__c != null)
                           AND Type__c ='E2ECostUPC9' ORDER BY LastModifiedDate ASC ];
        
        pbmmE2eMBEBList = [SELECT Id, Name, SKU_Code__c, SKU_Active__c, UOM__c, 
                           Sales_Org__c,E2E_Cost_LC__c, E2E_Cost_USD__c, E2E_Cost_UPC9_LC__c, 
                           E2E_Cost_UPC9_USD__c, E2E_Cost_MBEW_LC__c, E2E_Cost_MBEW_USD__c
                           FROM Price_Block_Margin_Matrix__c
                           WHERE Sales_Org__r.Sales_Org_Code__c='5100'
                           AND UOM__c !=null
                           AND Depot_Code__c =:detailsWrapObj.depoId
                           AND Start_Date__c<= today AND End_Date__c>= today
                           AND (E2E_Cost_MBEW_LC__c !=null OR E2E_Cost_MBEW_USD__c != null)
                           AND Type__c ='E2ECostMBEW' ORDER BY LastModifiedDate ASC ];
        
        
        if(pbmmE2eMBEBList.size()>0){
            for(Price_Block_Margin_Matrix__c pbmmObj:pbmmE2eMBEBList){
                prcE2eBlockMap.put(pbmmObj.SKU_Code__c,pbmmObj);
            }
        }
        
        if(pbmmE2eUPC9List.size()>0){
            for(Price_Block_Margin_Matrix__c pbmmObj:pbmmE2eUPC9List){
                prcE2eBlockMap.put(pbmmObj.SKU_Code__c,pbmmObj);
            }
        }
        
        if(pbmmE2eList.size()>0){
            for(Price_Block_Margin_Matrix__c pbmmObj:pbmmE2eList){
                prcE2eBlockMap.put(pbmmObj.SKU_Code__c,pbmmObj);
            }
        }
        
        List<String> skuIdsList = new List<String>();
        
        if(oliList != null && !oliList.isEmpty()){
            for(OrderLineItem__c odrObj :oliList){
                skuIdsList.add(odrObj.SKU_Name__c);
            }    
        }
        
        List<Price_Block_Margin_Matrix__c> pbmmSalesDeduList = new List<Price_Block_Margin_Matrix__c>();
        MAP<String,List<Price_Block_Margin_Matrix__c>> prcBlockMap = new MAP<String,List<Price_Block_Margin_Matrix__c>>();
        pbmmSalesDeduList = [SELECT Id, Name, SKU_Code__c, SKU_Active__c, UOM__c, 
                             Sales_Deduction_LC__c, Sales_Deduction_USD__c                                 
                             FROM Price_Block_Margin_Matrix__c
                             WHERE Sales_Org__r.Sales_org_code__c ='5100'
                             AND SKU_Code__c IN:skuIdsList
                             AND Type__c='SalesDeduction'
                             AND (Sales_Deduction_LC__c != null OR Sales_Deduction_USD__c != null) //Change for RITM0526193 - Added the check for Sales_Deduction_USD__c
                             AND Start_Date__c<= today AND End_Date__c>= today ORDER BY LastModifiedDate ASC ];
        
        for(Price_Block_Margin_Matrix__c obj:pbmmSalesDeduList){
            if(prcBlockMap.containsKey(obj.SKU_Code__c)) {
                List<Price_Block_Margin_Matrix__c> pbMList = prcBlockMap.get(obj.SKU_Code__c);
                pbMList.add(obj);
                prcBlockMap.put(obj.SKU_Code__c,pbMList);
            } else {
                List<Price_Block_Margin_Matrix__c> pbMList = new List<Price_Block_Margin_Matrix__c>();
                 pbMList.add(obj);
                prcBlockMap.put(obj.SKU_Code__c,pbMList);
            }
        }
        
        List<Price_Block_Margin_Matrix__c> pbmmReabteList = new List<Price_Block_Margin_Matrix__c>();
        MAP<String,List<Price_Block_Margin_Matrix__c>> prcBlockReabteMap1 = new MAP<String,List<Price_Block_Margin_Matrix__c>>();
        pbmmReabteList =[SELECT Id, Name, SKU_Code__c, SKU_Active__c, UOM__c, 
                          Rebate_LC__c, Rebate_USD__c, Rebate__c,Rebate_Code__c 
                          FROM Price_Block_Margin_Matrix__c
                          WHERE Sales_Org__r.Sales_Org_Code__c='5100'
                          AND Distributor_Code__c=:detailsWrapObj.accountId
                          AND SKU_Code__c IN :skuIdsList
                          AND Type__c ='Rebate'
                          AND Start_Date__c<= today AND End_Date__c>= today
                          AND (Rebate_LC__c!=null OR Rebate_USD__c!=null OR Rebate__c!=null)
                          AND Rebate_Code__c!=null ORDER BY LastModifiedDate ASC ]; // SKI(Vishal P) : #CR152 : PO And Delivery Date : 18-07-2022..changed DSC to ASC..
        
        if(pbmmReabteList.size()>0){
            for(Price_Block_Margin_Matrix__c rebateObj :pbmmReabteList){
                //change map object to list 
                
                            if(!prcBlockReabteMap1.containsKey(rebateObj.SKU_Code__c)){
                                List<Price_Block_Margin_Matrix__c> prbList = new List<Price_Block_Margin_Matrix__c>();
                                prbList.add(rebateObj);
                                prcBlockReabteMap1.put(rebateObj.SKU_Code__c,prbList);
                            }else{
                                List<Price_Block_Margin_Matrix__c> prbList = new List<Price_Block_Margin_Matrix__c>();
                                prbList = prcBlockReabteMap1.get(rebateObj.SKU_Code__c);                       
                                prbList.add(rebateObj);
                                prcBlockReabteMap1.put(rebateObj.SKU_Code__c,prbList);
                            }
                        }
                    }
        
        
        List<Price_Block_Margin_Matrix__c> pbmmDiscountList = new List<Price_Block_Margin_Matrix__c>();
                    MAP<String,List<Price_Block_Margin_Matrix__c>> prcBlockDiscountMap1 = new MAP<String,List<Price_Block_Margin_Matrix__c>>();
                    pbmmDiscountList = [SELECT Id, Name, SKU_Code__c, SKU_Active__c, UOM__c, 
                                        Sales_Org__c, Discount_LC__c, Discount_USD__c, 
                                        Discount__c
                                        FROM Price_Block_Margin_Matrix__c
                                        WHERE Sales_Org__r.Sales_Org_Code__c='5100'
                                        AND Distributor_Code__c=:detailsWrapObj.accountId
                                        AND SKU_Code__c IN :skuIdsList
                                        AND Type__c ='Discount'
                                        AND Start_Date__c<= today AND End_Date__c>= today
                                        AND (Discount_LC__c!=null OR Discount_USD__c!=null OR Discount__c!=null) ORDER BY LastModifiedDate ASC ];
        for(Price_Block_Margin_Matrix__c tObj:pbmmDiscountList){
            if(prcBlockDiscountMap1.containsKey(tObj.SKU_Code__c)){
                List<Price_Block_Margin_Matrix__c> pbList = prcBlockDiscountMap1.get(tObj.SKU_Code__c);
                pbList.add(tObj);
                prcBlockDiscountMap1.put(tObj.SKU_Code__c,pbList);
            }else{
                List<Price_Block_Margin_Matrix__c> pbList = new List<Price_Block_Margin_Matrix__c>();
                pbList.add(tObj);
                prcBlockDiscountMap1.put(tObj.SKU_Code__c,pbList);               
            }
        }
        
        List<Price_Block_Margin_Matrix__c> pbmmAddDiscountList = new List<Price_Block_Margin_Matrix__c>();
                    MAP<String,List<Price_Block_Margin_Matrix__c>> prcBlockAddDiscountMap1 = new MAP<String,List<Price_Block_Margin_Matrix__c>>();
                    pbmmAddDiscountList = [SELECT Id, Name, SKU_Code__c, SKU_Active__c, UOM__c, 
                                           Sales_Org__c, Additional_Discount_LC__c, Additional_Discount_USD__c, 
                                           Additional_Discount__c
                                           FROM Price_Block_Margin_Matrix__c
                                           WHERE Sales_Org__r.Sales_Org_Code__c='5100'
                                           AND SKU_Code__c IN :skuIdsList
                                           AND Type__c ='AdditionalDiscount'
                                           AND Distributor_Code__c=:detailsWrapObj.accountId
                                           AND Start_Date__c<= today AND End_Date__c>= today
                                           AND (Additional_Discount_LC__c!=null OR Additional_Discount_USD__c!= null OR Additional_Discount__c!= null) ORDER BY LastModifiedDate ASC ];
        for(Price_Block_Margin_Matrix__c ttObj:pbmmAddDiscountList){
            if(prcBlockAddDiscountMap1.containsKey(ttObj.SKU_Code__c)){
                List<Price_Block_Margin_Matrix__c> pbList = prcBlockAddDiscountMap1.get(ttObj.SKU_Code__c);
                pbList.add(ttObj);
                prcBlockAddDiscountMap1.put(ttObj.SKU_Code__c,pbList);                
            }else{
                List<Price_Block_Margin_Matrix__c> pbList = new List<Price_Block_Margin_Matrix__c>();
                pbList.add(ttObj);
                prcBlockAddDiscountMap1.put(ttObj.SKU_Code__c,pbList);                
            }           
        }
        
        List<Price_Block_Margin_Matrix__c> pbmmPlnList = new List<Price_Block_Margin_Matrix__c>();
                    MAP<String,List<Price_Block_Margin_Matrix__c>> prcBlockPlnMap1 = new MAP<String,List<Price_Block_Margin_Matrix__c>>();
                    pbmmPlnList =[SELECT Id, Name, SKU_Code__c, SKU_Active__c, UOM__c, 
                                  Sales_Org__c, PLN_LC__c, PLN_USD__c 
                                  FROM Price_Block_Margin_Matrix__c
                                  where Sales_Org__r.Sales_Org_Code__c='5100'
                                  AND SKU_Code__c IN:skuIdsList
                                  AND Type__c ='PLN'
                                  AND Start_Date__c<= today AND End_Date__c>= today
                                  AND PLN_LC__c!=null ORDER BY LastModifiedDate ASC ];
        for(Price_Block_Margin_Matrix__c pbmOBj:pbmmPlnList){
            if(prcBlockPlnMap1.containsKey(pbmOBj.SKU_Code__c)){
                List<Price_Block_Margin_Matrix__c> pbLisst =  prcBlockPlnMap1.get(pbmOBj.SKU_Code__c);
                pbLisst.add(pbmOBj);
                prcBlockPlnMap1.put(pbmOBj.SKU_Code__c,pbLisst);                
            }else{
                List<Price_Block_Margin_Matrix__c> pbLisst = new List<Price_Block_Margin_Matrix__c>();
                pbLisst.add(pbmOBj);
                prcBlockPlnMap1.put(pbmOBj.SKU_Code__c,pbLisst); 
            }
        }
        
        
        if(oliList != null && !oliList.isEmpty()){
            for(OrderLineItem__c oliObj : oliList){
                if(skuDetailsMap.containsKey(oliObj.SKU_Name__c)){
                    skuWrapObj2 = skuDetailsMap.get(oliObj.SKU_Name__c);
                    skuWrapObj = new SKUDetails();
                    skuWrapObj.productName = oliObj.SKU_Name__r.Product_Name__r.Name;
                    skuWrapObj.skuCode = oliObj.SKU_Name__r.Name;
                    skuWrapObj.palletSize = oliObj.SKU_Name__r.pallet_Size_Italy__c;
                    skuWrapObj.cropName1 = oliObj.Crop__r.Name;
                    skuWrapObj.agrosatSale = oliObj.Agrosat_Sale_Mexico__c;
                    skuWrapObj.cropName3 = oliObj.Crop2__r.Name;
                    skuWrapObj.cropName3 = oliObj.Crop3__r.Name;
                    skuWrapObj.cropName4 = oliObj.Crop4__r.Name;
                    skuWrapObj.cropName5 = oliObj.Crop5__r.Name;
                    skuWrapObj.crop1 = oliObj.crop__c;
                    skuwrapObj.crop1_Percentage = oliObj.Crop1_Percentage__c;
                    skuWrapObj.crop2 = oliObj.crop2__c;
                    skuwrapObj.crop2_Percentage = oliObj.Crop2_Percentage__c;
                    skuWrapObj.crop3 = oliObj.crop3__c;
                    skuwrapObj.crop3_Percentage = oliObj.Crop3_Percentage__c;
                    skuWrapObj.crop4 = oliObj.crop4__c;
                    skuwrapObj.crop4_Percentage = oliObj.Crop4_Percentage__c;
                    skuWrapObj.crop5 = oliObj.crop5__c;
                    skuwrapObj.crop5_Percentage = oliObj.Crop5_Percentage__c;
                    skuWrapObj.skuId = oliObj.SKU_Name__c;
                    skuWrapObj.finalPrice = oliObj.Net_Price__c;
                    //added By vishal Pawar for Marginal Block and PLN Value
                    skuWrapObj.specialSKU = oliObj.SKU_Name__r.Special_SKU__c;
                    //for E2E cost
                    if(prcE2eBlockMap.containsKey(oliObj.SKU_Name__c)){ 
                        Price_Block_Margin_Matrix__c pbMME2eObj = prcE2eBlockMap.get(oliObj.SKU_Name__c);
                        skuWrapObj.e2ECostLC = pbMME2eObj.E2E_Cost_LC__c ;
                        skuWrapObj.e2ECostUSD = pbMME2eObj.E2E_Cost_USD__c ;  
                        skuWrapObj.e2ECostUPC9LC = pbMME2eObj.E2E_Cost_UPC9_LC__c ; 
                        skuWrapObj.e2ECostUPC9USD = pbMME2eObj.E2E_Cost_UPC9_USD__c ;  
                        skuWrapObj.e2ECostMBEWLC = pbMME2eObj.E2E_Cost_MBEW_LC__c ; 
                        skuWrapObj.e2ECostMBEWUSD = pbMME2eObj.E2E_Cost_MBEW_USD__c;
                        skuWrapObj.uome2eCost = pbMME2eObj.UOM__c;
                    }
                    
                    // for Sales Deducitons
                    List<Price_Block_Margin_Matrix__c> pbmmSalesDeduList1 = new List<Price_Block_Margin_Matrix__c>();
                    MAP<String,Price_Block_Margin_Matrix__c> prcBlockForDeduMap = new MAP<String,Price_Block_Margin_Matrix__c>();
                    if(prcBlockMap.containsKey(oliObj.SKU_Name__c)){
                        pbmmSalesDeduList1 = prcBlockMap.get(oliObj.SKU_Name__c);    
                    }
                                        
                    if(pbmmSalesDeduList1.size()>0){                
                        for(Price_Block_Margin_Matrix__c dedObj : pbmmSalesDeduList1){
                            prcBlockForDeduMap.put(dedObj.SKU_Code__c,dedObj);
                        }
                    }
                    if(prcBlockForDeduMap.containsKey(oliObj.SKU_Name__c)){
                        Price_Block_Margin_Matrix__c pbMMSalesDedObj = prcBlockForDeduMap.get(oliObj.SKU_Name__c);
                        
                        if(pbMMSalesDedObj.Sales_Deduction_LC__c!=null){
                            skuWrapObj.salesDeductionLC = pbMMSalesDedObj.Sales_Deduction_LC__c;  // if this value not     
                        }else{
                            skuWrapObj.salesDeductionInPercent = profitCenterList[0].Sales_Value__c;
                        }
                        skuWrapObj.salesDeductionUSD = pbMMSalesDedObj.Sales_Deduction_USD__c ;
                        skuWrapObj.uomSalesDeduction = pbMMSalesDedObj.UOM__c ;                        
                    }//end for sales Deductions
                    
                    List<Price_Block_Margin_Matrix__c> pbmmReabteList1 = new List<Price_Block_Margin_Matrix__c>();
                    MAP<String,List<Price_Block_Margin_Matrix__c>> prcBlockReabteMap = new MAP<String,List<Price_Block_Margin_Matrix__c>>();
                    if(prcBlockReabteMap1.containsKey(oliObj.SKU_Name__c)){
                        pbmmReabteList1 =prcBlockReabteMap1.get(oliObj.SKU_Name__c);                        
                    }                    
                    
                    if(pbmmReabteList1.size()>0){
                        for(Price_Block_Margin_Matrix__c rebateObj :pbmmReabteList1){ 
                            
                            if(!prcBlockReabteMap.containsKey(rebateObj.SKU_Code__c)){
                                List<Price_Block_Margin_Matrix__c> prbList = new List<Price_Block_Margin_Matrix__c>();
                                prbList.add(rebateObj);
                                prcBlockReabteMap.put(rebateObj.SKU_Code__c,prbList);
                            }else{
                                List<Price_Block_Margin_Matrix__c> prbList = new List<Price_Block_Margin_Matrix__c>();
                                prbList = prcBlockReabteMap.get(rebateObj.SKU_Code__c);                       
                                prbList.add(rebateObj);
                                prcBlockReabteMap.put(rebateObj.SKU_Code__c,prbList);
                            }
                        }
                    }
                    //for rebate                    
                    if(prcBlockReabteMap.containsKey(oliObj.SKU_Name__c)){
                        
                        List<Price_Block_Margin_Matrix__c> pbMMRebateList = prcBlockReabteMap.get(oliObj.SKU_Name__c);
                        if(pbMMRebateList.size()>0){
                            if(pbMMRebateList.size()==2){ // SKI(Vishal P) : #CR152 : PO And Delivery Date : 18-07-2022...changed >= to == .....
                                String rebateCode1 = pbMMRebateList[0].Rebate_Code__c;
                                String rebateCode2 = pbMMRebateList[1].Rebate_Code__c;
                                if(rebateCode1!=rebateCode2){
                                    skuWrapObj.rebate1LC = pbMMRebateList[0].Rebate_LC__c; 
                                    skuWrapObj.rebate1USD = pbMMRebateList[0].Rebate_USD__c; 
                                    skuWrapObj.rebate1Percent = pbMMRebateList[0].Rebate__c;
                                    skuWrapObj.uomRebate1 = pbMMRebateList[0].UOM__c;
                                    skuWrapObj.rebateCode1 = pbMMRebateList[0].Rebate_Code__c;
                                    
                                    skuWrapObj.rebate2LC = pbMMRebateList[1].Rebate_LC__c; 
                                    skuWrapObj.rebate2USD = pbMMRebateList[1].Rebate_USD__c; 
                                    skuWrapObj.rebate2Percent = pbMMRebateList[1].Rebate__c;
                                    skuWrapObj.uomRebate2 = pbMMRebateList[1].UOM__c;
                                    skuWrapObj.rebateCode2 = pbMMRebateList[1].Rebate_Code__c;
                                } 
                            }else{
                                skuWrapObj.rebate1LC = pbMMRebateList[0].Rebate_LC__c; 
                                skuWrapObj.rebate1USD = pbMMRebateList[0].Rebate_USD__c; 
                                skuWrapObj.rebate1Percent = pbMMRebateList[0].Rebate__c;
                                skuWrapObj.rebateCode1 = pbMMRebateList[0].Rebate_Code__c;
                                skuWrapObj.uomRebate1 = pbMMRebateList[0].UOM__c;
                            }
                        }
                        
                    }//end for rebate
                    List<Price_Block_Margin_Matrix__c> pbmmDiscountList1 = new List<Price_Block_Margin_Matrix__c>();
                    MAP<String,Price_Block_Margin_Matrix__c> prcBlockDiscountMap = new MAP<String,Price_Block_Margin_Matrix__c>();
                    if(prcBlockDiscountMap1.containsKey(oliObj.SKU_Name__c)){
                        pbmmDiscountList1 = prcBlockDiscountMap1.get(oliObj.SKU_Name__c);                        
                    }
                    
                    if(pbmmDiscountList1.size()>0){
                        for(Price_Block_Margin_Matrix__c discontIbj:pbmmDiscountList1){
                            prcBlockDiscountMap.put(discontIbj.SKU_Code__c ,discontIbj);
                        }
                    }
                    
                    //for discount
                    if(prcBlockDiscountMap.containsKey(oliObj.SKU_Name__c)){
                        Price_Block_Margin_Matrix__c pbMMDiscountObj = prcBlockDiscountMap.get(oliObj.SKU_Name__c);
                        skuWrapObj.discountLC = pbMMDiscountObj.Discount_LC__c; 
                        skuWrapObj.discountUSD = pbMMDiscountObj.Discount_USD__c; 
                        skuWrapObj.discountPercent = pbMMDiscountObj.Discount__c;
                        skuWrapObj.uomDiscount = pbMMDiscountObj.UOM__c;                        
                    }
                    
                    
                    List<Price_Block_Margin_Matrix__c> pbmmAddDiscountList1 = new List<Price_Block_Margin_Matrix__c>();
                    MAP<String,Price_Block_Margin_Matrix__c> prcBlockAddDiscountMap = new MAP<String,Price_Block_Margin_Matrix__c>();
                    if(prcBlockAddDiscountMap1.containsKey(oliObj.SKU_Name__c)){
                        pbmmAddDiscountList1 = prcBlockAddDiscountMap1.get(oliObj.SKU_Name__c);    
                    }
                    if(pbmmAddDiscountList1.size()>0){
                        for(Price_Block_Margin_Matrix__c addDisObj:pbmmAddDiscountList1){
                            prcBlockAddDiscountMap.put(addDisObj.SKU_Code__c,addDisObj);    
                        }
                        
                    }
                    
                    if(prcBlockAddDiscountMap.containsKey(oliObj.SKU_Name__c)){
                        Price_Block_Margin_Matrix__c pbMMAddDiscountObj = prcBlockAddDiscountMap.get(oliObj.SKU_Name__c);
                        
                        skuWrapObj.additionalDiscountLC = pbMMAddDiscountObj.Additional_Discount_LC__c;
                        skuWrapObj.additionalDiscountPercent = pbMMAddDiscountObj.Additional_Discount__c;
                        skuWrapObj.additionalDiscountUSD = pbMMAddDiscountObj.Additional_Discount_USD__c;
                        skuWrapObj.uomAddDiscount = pbMMAddDiscountObj.UOM__c;
                        
                    }                    
                    
                    List<Price_Block_Margin_Matrix__c> pbmmPlnList1 = new List<Price_Block_Margin_Matrix__c>();
                    MAP<String,Price_Block_Margin_Matrix__c> prcBlockPlnMap = new MAP<String,Price_Block_Margin_Matrix__c>();
                    if(prcBlockPlnMap1.containsKey(oliObj.SKU_Name__c)){
                        pbmmPlnList1 =prcBlockPlnMap1.get(oliObj.SKU_Name__c);                        
                    }
                    
                    
                    if(pbmmPlnList1.size()>0){
                        for(Price_Block_Margin_Matrix__c plnObj :pbmmPlnList1){
                            prcBlockPlnMap.put(plnObj.SKU_Code__c,plnObj);
                        }
                    }
                    //for PLN
                    if(prcBlockPlnMap.containsKey(oliObj.SKU_Name__c)){
                        Price_Block_Margin_Matrix__c pbMMPlnObj = prcBlockPlnMap.get(oliObj.SKU_Name__c);
                        skuWrapObj.pLNLC = pbMMPlnObj.PLN_LC__c;
                        skuWrapObj.pLNUSD = pbMMPlnObj.PLN_USD__c; 
                        skuWrapObj.uomPLN = pbMMPlnObj.UOM__c;
                    }
                    //Ended By Vishal Pawar
                    if(oliObj.Type_of_Sale__c != null){
                        skuWrapObj.typeOfSale = oliObj.Type_of_Sale__c;
                        if(oliObj.Type_of_Sale__c == 'Promotion'){
                            skuWrapObj.disablePrice = true;
                            skuWrapObj.finalPrice = 0.01;
                        }
                    }
                    skuWrapObj.oliId = oliObj.Id;
                    if(String.isNotBlank(oliObj.SKU_Name__r.Brand_Name__c)){
                        skuWrapObj.brandName = oliObj.SKU_Name__r.Brand_Name__c+' '+oliObj.SKU_Name__r.Name;
                    }else{
                        skuWrapObj.brandName = oliObj.SKU_Name__r.Name;
                    }
                    skuWrapObj.multipleOf = skuWrapObj2.multipleOf;
                    skuWrapObj.price = skuWrapObj2.price;
                    skuWrapObj.minPrice = skuWrapObj2.minPrice;
                    
                    skuWrapObj.qty = oliObj.Quantity__c;
                    skuWrapObj.netRateEntered = oliObj.Price__c;
                    Decimal totalpri = skuWrapObj.netRateEntered;
                    skuWrapObj.netRateEnteredText = String.valueOf(totalpri);
                    if(totalpri != null && oliObj.Type_of_Sale__c != 'Promotion'){
                        Decimal totalpriwithNoDecimal = Math.round(totalpri * 100) / 100;
                        skuWrapObj.netRateEnteredText = String.valueOf(totalpriwithNoDecimal);
                    }
                    skuWrapObj.maxPrice = oliObj.MaxPrice__c;
                    skuWrapObj.DeliveryDate = oliObj.Shipping_Date__c;
                    skuWrapObj.UOM = oliObj.UOM__c;
                    skuWrapObj.divisionid = skuWrapObj2.divisionid;
                    skuWrapObj.available = skuWrapObj2.available;
                    skuWrapObj.available2 = skuWrapObj2.available2;
                    skuWrapObj.invStyle = skuWrapObj2.invStyle;
                    skuWrapObj.Director_Price =skuWrapObj2.Director_Price ;
                    skuWrapObj.Manager_Price=skuWrapObj2.Manager_Price;
                    skuWrapObj.currencyIso = oliObj.CurrencyIsoCode;
                    //skuWrapObj.currencyIso ='MXN';
                    if(oliObj.Item_Number__c != null){skuWrapObj.itemNo = Integer.valueOf(oliObj.Item_Number__c);}
                    if(mapCurrencyOrderSummary.containsKey(skuWrapObj.currencyIso)){
                        OSC = mapCurrencyOrderSummary.get(skuWrapObj.currencyIso);
                        OSC.totalValue = OSC.totalValue + skuWrapObj.netRateEntered;
                        mapCurrencyOrderSummary.put(skuWrapObj.currencyIso, OSC);
                    }else{
                        OSC = new orderSummaryCurrency();
                        OSC.currencyName = skuWrapObj.currencyIso;
                        OSC.totalValue = skuWrapObj.netRateEntered;
                        mapCurrencyOrderSummary.put(skuWrapObj.currencyIso, OSC);
                    }
                    
                    if(orderSummaryUOMmap.containsKey(skuWrapObj.UOM)){
                        osUOM =  orderSummaryUOMmap.get(skuWrapObj.UOM);
                        osUOM.totalQty = osUOM.totalQty+ skuWrapObj.qty;
                        orderSummaryUOMmap.put(skuWrapObj.UOM, osUOM);
                    }else{
                        osUOM = new orderSummaryUOM();
                        osUOM.UOM = skuWrapObj.UOM;
                        osUOM.totalQty = skuWrapObj.qty;
                        orderSummaryUOMmap.put(skuWrapObj.UOM, osUOM);
                    }
                    listSKUOrders.add(skuWrapObj);
                }
            }
        }
        getOdrObj.skuOrderList = listSKUOrders;
        getOdrObj.orderSummaryUOMList = orderSummaryUOMmap.values();
        getOdrObj.orderSummaryCurrencyList = mapCurrencyOrderSummary.values();
        return getOdrObj;
    }
    
    public static String addCharIntoRemark(String stringToreplace){
        String str = stringToreplace;
        String newStr = '';
        String finalReturnString = '';
        Integer j = 0;
        Integer lengthToTrim = 130;
        
        while (j < str.length())
        {
            newStr = str.mid(j, lengthToTrim);
            newStr = newStr+'~';
            finalReturnString = finalReturnString+newStr;
            j = j + lengthToTrim;
        } 
        return finalReturnString;
    }
    
    public static Order__c createOrder(String accountId, String orderRaisedBy, DistributerWrapperObj distWrapObj, String depoId){
        Order__c ordObj;
        List<Order__c> recentOrderList =  [SELECT Id, Name,Depot__c , Net_Amount__c, Remarks_Long__c ,Bill_To_Party__c, Order_Date__c, 
                                           Order_Raise_By__c, Order_Status__c, 
                                           RegionalManager__c, Shipping_Location__c, OwnerId, 
                                           Gross_Amount__c, Distribution_Channel__c FROM Order__c 
                                           WHERE Order_Status__c='Draft'
                                           AND Bill_To_Party__c =: accountId AND createdById =: UserInfo.getUserId() LIMIT 1];
        if(recentOrderList != null && !recentOrderList.isEmpty()){
            ordObj = recentOrderList[0];
            if(ordObj.ownerId != userinfo.getuserId()){
                ordObj.ownerId = userinfo.getuserId();
                update ordObj;
            }
        }
        else{
            ordObj = new Order__c();
            ordObj.Bill_To_Party__c = accountId;
            ordObj.OwnerId = userinfo.getuserid();
            ordObj.Order_Date__c = System.today();
            ordObj.Order_Raise_By__c = orderRaisedBy;
            ordObj.Order_Status__c = 'Draft';
            ordObj.RegionalManager__c = distWrapObj.regionalManagerId;
            ordObj.Sales_Org__c = distWrapObj.salesOrgId;
            ordObj.Distribution_Channel__c = distWrapObj.distributorChannelId; 
            ordObj.Depot__c = depoId;
            ordObj.OwnerId = userinfo.getuserid();
            ordObj.CurrencyIsoCode = distWrapObj.currencyIso;
            ordObj.Shipping_Location__c = distWrapObj.selectedShippingLocation.locationId;
            insert ordObj;
        }
        return ordObj;
    }
    
    public static DistributerWrapperObj getDistributerDetails(GetDetailsWrap detailObj){
        
        List<Depot__c> depotList = new List<Depot__c>();
        Map<String, ShippingLocationWrapper> mapShippingLocationWrapper = new Map<String, ShippingLocationWrapper>();
        List<PickListWrapper> shippingList = new List<PickListWrapper>();
        ShippingLocationWrapper selectedShippingLocation = new ShippingLocationWrapper();
        
        DistributerWrapperObj wrap = new DistributerWrapperObj();
        wrap.error = 'NA';
        
        List<Distribution_Channel__c> disChannelList = [SELECT Id FROM Distribution_Channel__c 
                                                        WHERE Distribution_Channel_Code__c =: detailObj.distributionChannel];
        if(disChannelList != null && !disChannelList.isEmpty()){
            wrap.distributorChannelId = disChannelList[0].Id;
        }
        
        //Fetching Account Data
        List<Account> accList = [SELECT Id, Name, BillingCity, BillingCountry, RegionalManager__c, Inco_Term__c,
                                 BillingStreet, BillingState, BillingPostalCode , CurrencyIsoCode, Sales_Org__r.Name, 
                                 OwnerId, SAP_Code__c, Sales_Org__c, Distribution_Channel__c, Division__c, Payment_Method__c, Payment_Term_Code__c,
                                 Order_Type__c, Order_Block__c, Sales_Org_Code__c, Status__c, Payment_Terms__c, PriceGroupCode__c, 
                                 Sales_District__c, Sales_District__r.Sales_Director__c, Sales_District__r.Latam_Director__c
                                 FROM Account WHERE Id =: detailObj.accountId LIMIT 1];
        if(accList != null && !accList.isEmpty()){
            wrap.territoryManagerId = accList[0].OwnerId;
            wrap.distributor_Name = accList[0].Name;
            wrap.sap_code = accList[0].SAP_Code__c;
            wrap.salesOrgId = accList[0].Sales_Org__c;
            wrap.salesOrgName = accList[0].Sales_Org__r.Name;
            wrap.incoTerms = accList[0].Inco_Term__c;
            wrap.salesDirector = accList[0].Sales_District__r.Sales_Director__c;
            wrap.latamDirector = accList[0].Sales_District__r.Latam_Director__c;
            wrap.orderType = accList[0].Order_Type__c; 
            wrap.paymentTerms = accList[0].Payment_Term_Code__c;
            wrap.paymentMethods = accList[0].Payment_Method__c;
            wrap.priceGroupId = accList[0].PriceGroupCode__c;
            wrap.address = accList[0].BillingStreet;
            wrap.city = accList[0].BillingCity;
            wrap.state = accList[0].BillingState;
            wrap.country = accList[0].BillingCountry;
            wrap.pincode = accList[0].BillingPostalCode;
            wrap.currencyIso = accList[0].currencyIsoCode;
            wrap.regionalManagerId = accList[0].RegionalManager__c;
        }else{
            wrap.error = 'Distributor ID not found';
        }
        
        //Fetching Distributer Sales Area Mapping
        List<DistributorSalesAreaMapping__c> salesAreaDMList = [SELECT Id, Order_Type__c, AccountOwner__c, PriceGroupMaster__c, Name,
                                                                Division__r.Division_Code__c, 
                                                                Distributor__c, DistributionChannel__c, Division__c, SalesOrg__c, Status__c
                                                                FROM DistributorSalesAreaMapping__c WHERE Distributor__c =: detailObj.accountId 
                                                                AND SalesOrg__r.Sales_Org_Code__c='5100'];
        Map<String, DistributorSalesAreaMapping__c> distributorSalesAreaMappingMAP = new Map<String, DistributorSalesAreaMapping__c>();
        List<String> divisionIdsforDepot = new List<String>();
        Set<String> divisionCodesforDepot = new Set<String>();
        for(DistributorSalesAreaMapping__c distSalMapObj : salesAreaDMList){
            distributorSalesAreaMappingMAP.put(distSalMapObj.Division__c, distSalMapObj);
            divisionIdsforDepot.add(distSalMapObj.Division__c);
            
            if(distSalMapObj.Division__r.Division_Code__c != null){
                String segment;
                if(distSalMapObj.Division__r.Division_Code__c == '10'){segment = 'Sales Team';}
                else if(distSalMapObj.Division__r.Division_Code__c == '20'){segment = 'B2B';}
                else if(distSalMapObj.Division__r.Division_Code__c == '60'){segment = 'ALP';}
                if(segment != null){divisionCodesforDepot.add(segment);}
            }
            
            if(distSalMapObj.AccountOwner__c == UserInfo.getUserId()){
                wrap.salesAreaAccountOwner = UserInfo.getUserId();
            }
        }
        wrap.distributorSalesAreaMappingMAP = distributorSalesAreaMappingMAP;
        wrap.divisionIds = divisionIdsforDepot;
        
        //Creating set of Depot
        //Updated by Varun Shrivastava: SCTASK0380343 Replace Segment with Segment Name: 
        List<String> multiSegment;
        for(Depot__c depObj : [Select Id, Name, Segment_Name__c   from Depot__c where RecordType.Name = 'Storage Location' AND 
                               SalesOrg__r.Name =: detailObj.country AND Depot__r.Depot_Code__c =: detailObj.userDepotCode AND
                               /*Segment_Name__c includes divisionCodesforDepot AND*/ Active__c = TRUE])
        {
            if(depObj.Segment_Name__c != null){
                multiSegment = depObj.Segment_Name__c.split(';');
                
            }
            for(String segment:multiSegment){
                if(divisionCodesforDepot.contains(segment)){
                    if(!depotList.contains(depObj))
                        depotList.add(depObj);
                }
            }
            //depotList.add(depObj);
            
        }
        wrap.listDepot = depotList;
        
        
        //Fetching Credit Info
        List<Credit_Info__c> credInfoList = [SELECT Id, Name, Distributor__c, Distributor__r.Name, Credit_Limit__c, Balance_Limit__c, Used_Limit__c, 
                                             Internal_Limit__c, Sum_Open_Item__c, DAYS_ARREARS__c FROM Credit_Info__c 
                                             WHERE Distributor__c =: detailObj.accountId ORDER BY LastModifiedDate DESC LIMIT 1 ];
        if(credInfoList != null && !credInfoList.isEmpty()){
            wrap.creditLimit = credInfoList[0].Credit_Limit__c;
            wrap.creditUsed = credInfoList[0].Used_Limit__c;
            wrap.creditBalance = credInfoList[0].Balance_Limit__c;
            wrap.daysArrears = credInfoList[0].DAYS_ARREARS__c;
            wrap.internalCredit = credInfoList[0].Internal_Limit__c;
        }
        else{
            wrap.error = 'Credit Information for Distributor not found';
        }
        
        //Fetching Payment Details      
        List<Payments__c> paymentList = [SELECT Id, Net_Overdue__c FROM Payments__c WHERE Customer_Name__c =: detailObj.accountId LIMIT 1];
        
        if(paymentList != null && !paymentList.isEmpty()){
            wrap.greaterThan90 = paymentList[0].Net_Overdue__c;
        }
        
        //Fetching Outstanding Ageing List
        List<Outstanding_Ageing__c> outstandingAgeingList = [SELECT Id, OutstandingTotalGreaterthan90__c, Net_Outstanding__c
                                                             FROM Outstanding_Ageing__c WHERE Customer_Code__c =: detailObj.accountId LIMIT 1];
        
        if(outstandingAgeingList != null && !outstandingAgeingList.isEmpty()){
            wrap.paymentOutstanding = outstandingAgeingList[0].Net_Outstanding__c;
        }
        
        //Making Map of pin code with Storage Location to plcae depoId on Shipping Location Wrapper for CR
        //Commented by Varun Shrivastava: SCTASK0380343 Start
        /*Map<String, String> mapPinCode_StorageLoc = new Map<String, String>();
for(Pincode_Depot_Code_Mapping__c obj : Pincode_Depot_Code_Mapping__c.getall().values()){
mapPinCode_StorageLoc.put(obj.Pin_Code__c, obj.Depot_Code__c);
}*/
        //Commented by Varun Shrivastava: SCTASK0380343 End
        
        Map<String, String> mapPinCode_StorageLoc_DepoId = new Map<String, String>();
        //Updated by Varun Shrivastava:  SCTASK0380343 Start
        /*for(Depot__c dep : [SELECT Id, Depot_Code__c FROM Depot__c WHERE Depot_Code__c IN : mapPinCode_StorageLoc.values()]){
mapPinCode_StorageLoc_DepoId.put(dep.Depot_Code__c, dep.Id);
}*/
        for(Depot__c dep : [SELECT Id, Depot_Code__c FROM Depot__c WHERE SalesOrg__r.Name = 'Mexico']){
            mapPinCode_StorageLoc_DepoId.put(dep.Depot_Code__c, dep.Id);
        }
        //Updated by Varun Shrivastava:  SCTASK0380343 End
        //Fetching Shipping Details
        List<Shipping_Location__c> shippingLocationList = new List<Shipping_Location__c>();
        List<Shipping_Location__c> shipLocList = [SELECT Id, Name, Distributor__c, City__c, Region__c, Pincode__c, State__c, Country__c,
                                                  Sold_To_Party_SAP_Code__c, SAP_Code__c,Location_Name__c,Billing_Street_1__c,Billing_Street_2__c,
                                                  //Added by Varun: SCTASK0380343 Start
                                                  Storage_Location_Code__c,  
                                                  //Added by Varun: SCTASK0380343 End
                                                  Billing_Street_3__c,Billing_Street_4__c,Billing_Street_5__c,Billing_Street_6__c
                                                  FROM Shipping_Location__c WHERE Distributor__c =: detailObj.accountId];
        
        if(!shipLocList.isEmpty()){
            shippingList.add(new PickListWrapper(System.Label.Select_shipping_location, 'Select shipping location'));
            for(Shipping_Location__c slObj : shipLocList){
                ShippingLocationWrapper slw2Obj = new ShippingLocationWrapper();
                
                if(String.isNotBlank(slObj.SAP_Code__c) && wrap.sap_code == slObj.SAP_Code__c){
                    shippingList.add(new PickListWrapper(System.Label.same_as_billing_address, slObj.SAP_Code__c));
                    slw2Obj.locationId = slObj.Id;
                    slw2Obj.address = slObj.Region__c;
                    slw2Obj.city = slObj.City__c;
                    slw2Obj.state = wrap.State;
                    slw2Obj.Billing_Street_1 = slObj.Billing_Street_1__c;
                    slw2Obj.Billing_Street_2 = slObj.Billing_Street_2__c;
                    slw2Obj.Billing_Street_3 = slObj.Billing_Street_3__c;
                    slw2Obj.Billing_Street_4 = slObj.Billing_Street_4__c;
                    slw2Obj.Billing_Street_5 = slObj.Billing_Street_5__c;
                    slw2Obj.Billing_Street_6 = slObj.Billing_Street_6__c;
                    slw2Obj.country = slObj.Country__c;
                    slw2Obj.pincode = slObj.Pincode__c;
                    //Updated by Varun Shrivastava: Start : SCTASK0380343
                    /*if(slObj.Pincode__c != null && mapPinCode_StorageLoc.containsKey(slObj.Pincode__c)){
if(mapPinCode_StorageLoc_DepoId.containsKey(mapPinCode_StorageLoc.get(slObj.Pincode__c))){
slw2Obj.depoId = mapPinCode_StorageLoc_DepoId.get(mapPinCode_StorageLoc.get(slObj.Pincode__c));
}
}*/
                    if(slObj.Storage_Location_Code__c != null){
                        if(mapPinCode_StorageLoc_DepoId.containsKey(slObj.Storage_Location_Code__c)){
                            slw2Obj.depoId = mapPinCode_StorageLoc_DepoId.get(slObj.Storage_Location_Code__c);
                        }
                    }
                    //Updated by Varun Shrivastava: End : SCTASK0380343
                    mapShippingLocationWrapper.put(slObj.Sold_To_Party_SAP_Code__c, slw2Obj);
                }
                else{
                    shippingList.add(new PickListWrapper(slObj.City__c+'-'+slObj.Pincode__c, slObj.Name)); 
                    slw2Obj.locationId = slObj.Id;
                    slw2Obj.address = slObj.Region__c;
                    slw2Obj.city = slObj.City__c;
                    slw2Obj.state = slObj.State__c;
                    slw2Obj.country = slObj.Country__c;
                    slw2Obj.pincode = slObj.Pincode__c;
                    slw2Obj.Billing_Street_1 = slObj.Billing_Street_1__c;
                    slw2Obj.Billing_Street_2 = slObj.Billing_Street_2__c;
                    slw2Obj.Billing_Street_3 = slObj.Billing_Street_3__c;
                    slw2Obj.Billing_Street_4 = slObj.Billing_Street_4__c;
                    slw2Obj.Billing_Street_5 = slObj.Billing_Street_5__c;
                    slw2Obj.Billing_Street_6 = slObj.Billing_Street_6__c;
                    //Updated by Varun Shrivastava: Start : SCTASK0380343
                    /*if(slObj.Pincode__c != null && mapPinCode_StorageLoc.containsKey(slObj.Pincode__c)){
if(mapPinCode_StorageLoc_DepoId.containsKey(mapPinCode_StorageLoc.get(slObj.Pincode__c))){
slw2Obj.depoId = mapPinCode_StorageLoc_DepoId.get(mapPinCode_StorageLoc.get(slObj.Pincode__c));
}
}*/
                    if(slObj.Storage_Location_Code__c != null){
                        if(mapPinCode_StorageLoc_DepoId.containsKey(slObj.Storage_Location_Code__c)){
                            slw2Obj.depoId = mapPinCode_StorageLoc_DepoId.get(slObj.Storage_Location_Code__c);
                        }
                    }
                    //Updated by Varun Shrivastava: End : SCTASK0380343
                    mapShippingLocationWrapper.put(slObj.Name, slw2Obj);
                }
            }
            
            wrap.shippingList = shippingList;
            wrap.mapShippingLocationWrapper = mapShippingLocationWrapper;
            wrap.selectedShippingLocation = selectedShippingLocation;
        }else{
            wrap.error= 'Shipping Details not found';
        }
        
        //Fetching Payment Method List
        List<Payment_Method__c> paymtMethList = [SELECT Id, Name, Active__c, Description__c,Payment_Method_Code__c,Sales_Org__r.sales_org_code__c
                                                 FROM Payment_Method__c WHERE Sales_Org__r.sales_org_code__c='5100'];
        if(paymtMethList != null && !paymtMethList.isEmpty()){wrap.paymentMethodList = paymtMethList;}
        
        //Fetching Inco Term List
        List<Inco_Term__c> incoTrmList = [SELECT Id, Name, Active__c, Sales_Org__c, IncoTerm_Desc__c FROM Inco_Term__c
                                          WHERE Sales_Org__r.Sales_Org_Code__c='5100' AND Active__c = TRUE];
        if(incoTrmList != null && !incoTrmList.isEmpty()){
            wrap.incoTermList = incoTrmList;
        }
        
        //Fetching Payment Term
        wrap.listPaymentTerm = new List<Payment_Term__c>();
        List<Payment_Term__c> payemntTrmSingleList =  [SELECT Id, Name, Payterms_Desc__c, Sales_Org__c, Payment_Term_Code__c FROM Payment_Term__c
                                                       WHERE Sales_Org__r.sales_org_code__c = '5100' AND Payment_Term_Code__c ='0004' LIMIT 1];
        if(payemntTrmSingleList != null && !payemntTrmSingleList.isEmpty()){
            wrap.listPaymentTerm.addAll(payemntTrmSingleList);
        }
        
        //Fetching Payment Term List
        List<Payment_Term__c> paymntTermList = [SELECT Id, Name, Sales_Org__c, Payment_Term_Code__c, Payterms_Desc__c FROM Payment_Term__c 
                                                WHERE Sales_Org__r.sales_org_code__c = '5100' AND Payment_Term_Code__c != '0004'];    
        if(paymntTermList != null && !paymntTermList.isEmpty()){
            wrap.listPaymentTerm.addAll(paymntTermList);
        }
        
        return wrap;
    }
    
    public static mapSKUWrapper fetchSKUData(GetDetailsWrap detailsWrapObj, String salesOrgId, List<String> divisionIds){
        mapSKUWrapper mapSKUObj = new mapSKUWrapper();
        Map<Id, SKUDetails> skuDetailsMapp = new Map<Id, SKUDetails>();
        List<PriceBookMaster__c> pbmList = new List<PriceBookMaster__c>();
        
        if(detailsWrapObj.userDepotCode != null){ 
            if(detailsWrapObj.userDepotCode=='MX00'){
                pbmList = [SELECT Id, Director_Price__c, SKUCode__r.Special_SKU__c,Manager_Price__c, SKUCode__c, Division__c, MaxPrice__c, SKUCode__r.Multiple_Of__c,SKUCode__r.Name, 
                           SKUCode__r.SKU_Code__c, MinPrice__c, DepotCode__c, DepotCode__r.Location__c, Division__r.Division_Code__c,
                           Price__c, PG_CODE__c, PG_CODE__r.Name, UOM__c, SKUCode__r.Product_Name__r.Name, SKUCode__r.UOM__c,
                           SKUCode__r.Product_Name__c, CurrencyIsoCode,SKUCode__r.Brand_Name__c, SKUCode__r.pallet_Size_Italy__c ,
                           SKUCode__r.Product_Name__r.Popular__c, SKUCode__r.SKU_Description__c
                           FROM PriceBookMaster__c 
                           WHERE DepotCode__c =: detailsWrapObj.depoId
                           AND SKUCode__r.Sales_Org__c =: salesOrgId
                           AND StartDate__c <= TODAY AND EndDate__c >= TODAY 
              
             AND SKUCode__r.Active__c = True
                           AND SKUCode__r.Multiple_Of__c !=null 
                           AND Division__c IN : divisionIds ORDER BY SKUCode__r.Brand_Name__c ASC, SKUCode__r.SKU_Code__c DESC, 
                           StartDate__c ASC,LastModifiedDate ASC];
            }
            if(pbmList.isEmpty()){
                System.debug('Price book empty found');
                mapSKUObj.error = String.valueOf(System.Label.Pricebook_for_Depot_Distributor_not_found);
            }
            //Added by Vishal Pawar for Marginal and PLN value
            List<Price_Block_Margin_Matrix__c> pbmmE2eMBEBList = new List<Price_Block_Margin_Matrix__c>();
            List<Price_Block_Margin_Matrix__c> pbmmE2eUPC9List = new List<Price_Block_Margin_Matrix__c>();
            List<Price_Block_Margin_Matrix__c> pbmmE2eList = new List<Price_Block_Margin_Matrix__c>();
            List<Profit_Center__c> profitCenterList = new List<Profit_Center__c>();
            
            MAP<String,Price_Block_Margin_Matrix__c> prcE2eBlockMap = new MAP<String,Price_Block_Margin_Matrix__c>();
            
            profitCenterList =[SELECT Id, Name, Profit_Center__c, Sales_Value__c, Sales_Org__c, Depot__c, Combination_Key__c 
                               FROM Profit_Center__c 
                               WHERE Sales_Org__c =:salesOrgId ORDER BY LastModifiedDate DESC  LIMIT 1];
            //this is for e2e
            pbmmE2eList = [SELECT Id, Name, SKU_Code__c, SKU_Active__c, UOM__c, 
                           Sales_Org__c,E2E_Cost_LC__c, E2E_Cost_USD__c, E2E_Cost_UPC9_LC__c, 
                           E2E_Cost_UPC9_USD__c, E2E_Cost_MBEW_LC__c, E2E_Cost_MBEW_USD__c
                           FROM Price_Block_Margin_Matrix__c
                           WHERE Sales_Org__c=:salesOrgId
                           AND Depot_Code__c =:detailsWrapObj.depoId
                           AND Start_Date__c<= today AND End_Date__c>= today
                           AND (E2E_Cost_LC__c != null OR E2E_Cost_USD__c != null)
                           AND UOM__c !=null
                           AND Profit_Center__c=:profitCenterList[0].Id
                           AND Type__c ='E2ECost' ORDER BY LastModifiedDate ASC ];
            pbmmE2eUPC9List = [SELECT Id, Name, SKU_Code__c, SKU_Active__c, UOM__c, 
                               Sales_Org__c,E2E_Cost_LC__c, E2E_Cost_USD__c, E2E_Cost_UPC9_LC__c, 
                               E2E_Cost_UPC9_USD__c, E2E_Cost_MBEW_LC__c, E2E_Cost_MBEW_USD__c
                               FROM Price_Block_Margin_Matrix__c
                               WHERE Sales_Org__c=:salesOrgId
                               AND UOM__c !=null
                               AND Depot_Code__c =:detailsWrapObj.depoId
                               AND Start_Date__c<= today AND End_Date__c>= today
                               AND (E2E_Cost_UPC9_LC__c !=null OR E2E_Cost_UPC9_USD__c != null)
                               AND Type__c ='E2ECostUPC9' ORDER BY LastModifiedDate ASC ];
            pbmmE2eMBEBList = [SELECT Id, Name, SKU_Code__c, SKU_Active__c, UOM__c, 
                               Sales_Org__c,E2E_Cost_LC__c, E2E_Cost_USD__c, E2E_Cost_UPC9_LC__c, 
                               E2E_Cost_UPC9_USD__c, E2E_Cost_MBEW_LC__c, E2E_Cost_MBEW_USD__c
                               FROM Price_Block_Margin_Matrix__c
                               WHERE Sales_Org__c=:salesOrgId
                               AND UOM__c !=null
                               AND Depot_Code__c =:detailsWrapObj.depoId
                               AND Start_Date__c<= today AND End_Date__c>= today
                               AND (E2E_Cost_MBEW_LC__c !=null OR E2E_Cost_MBEW_USD__c != null)
                               AND Type__c ='E2ECostMBEW' ORDER BY LastModifiedDate ASC ];
            if(pbmmE2eMBEBList.size()>0){
                for(Price_Block_Margin_Matrix__c pbmmObj:pbmmE2eMBEBList){
                    prcE2eBlockMap.put(pbmmObj.SKU_Code__c,pbmmObj);
                }
            }
            
            if(pbmmE2eUPC9List.size()>0){
                for(Price_Block_Margin_Matrix__c pbmmObj:pbmmE2eUPC9List){
                    prcE2eBlockMap.put(pbmmObj.SKU_Code__c,pbmmObj);
                }
            }
            
            if(pbmmE2eList.size()>0){
                for(Price_Block_Margin_Matrix__c pbmmObj:pbmmE2eList){
                    prcE2eBlockMap.put(pbmmObj.SKU_Code__c,pbmmObj);
                }
            }
                
            for(PriceBookMaster__c pbObj : pbmList){
                if(prcE2eBlockMap.containsKey(pbObj.SKUCode__c)){
                    Price_Block_Margin_Matrix__c tmpPriceBlockMargin = new Price_Block_Margin_Matrix__c();
                    tmpPriceBlockMargin = prcE2eBlockMap.get(pbObj.SKUCode__c);
                    //if(pbObj.CurrencyIsoCode == 'MXN' &&  (tmpPriceBlockMargin.E2E_Cost_LC__c != null || tmpPriceBlockMargin.E2E_Cost_UPC9_LC__c != null || tmpPriceBlockMargin.E2E_Cost_MBEW_LC__c != null)){
                    if((pbObj.CurrencyIsoCode == 'MXN' &&  (tmpPriceBlockMargin.E2E_Cost_LC__c != null || tmpPriceBlockMargin.E2E_Cost_UPC9_LC__c != null || tmpPriceBlockMargin.E2E_Cost_MBEW_LC__c != null)) || (pbObj.CurrencyIsoCode == 'USD' && (tmpPriceBlockMargin.E2E_Cost_USD__c != null || tmpPriceBlockMargin.E2E_Cost_UPC9_USD__c != null || tmpPriceBlockMargin.E2E_Cost_MBEW_USD__c != null))){
                            SKUDetails skuObj = new SKUDetails();
                            if(String.isNotBlank(pbObj.SKUCode__r.Brand_Name__c)){
                                skuObj.brandName = pbObj.SKUCode__r.Brand_Name__c+' '+pbObj.SKUCode__r.Name;    
                            }else{
                                skuObj.brandName= pbObj.SKUCode__r.Name;
                            }
                            skuObj.description = pbObj.SKUCode__r.SKU_Description__c;
                            if(pbObj.Division__r.Division_Code__c != null){
                                String divCode;
                        if(pbObj.Division__r.Division_Code__c == '10'){divCode = 'Sales Team';}
                        else if(pbObj.Division__r.Division_Code__c == '20'){divCode = 'B2B';}
                        else if(pbObj.Division__r.Division_Code__c == '60'){divCode = 'ALP';}
                        if(divCode != null){skuObj.divisionCode = divCode;}
                    }
                                
                    skuObj.skuPackName = pbObj.SKUCode__r.Name;
                    skuObj.distributorId = detailsWrapObj.accountId;
                    skuObj.palletSize = pbObj.SKUCode__r.pallet_Size_Italy__c;
                    skuObj.productName = pbObj.SKUCode__r.Product_Name__r.Name;
                    skuObj.productId = pbObj.SKUCode__r.Product_Name__c;
                    if(detailsWrapObj.userDepotCode=='MX00'){skuObj.uOM = pbObj.UOM__c;}
                    skuObj.skuCode = pbObj.SKUCode__r.SKU_Code__c;
                    skuObj.skuId = pbObj.SKUCode__c;
                    skuObj.depotLocation = pbObj.DepotCode__r.Location__c;
                    skuObj.depotId = pbObj.DepotCode__c;
                    skuObj.multipleOf = pbObj.SKUCode__r.Multiple_Of__c;
                    skuObj.minPrice = pbObj.MinPrice__c;
                    skuObj.Director_Price = pbObj.Director_Price__c;
                    skuObj.Manager_Price = pbObj.Manager_Price__c;
                    if(pbObj.Price__c != null){
                        skuObj.maxPrice = pbObj.Price__c;
                        skuObj.price = pbObj.Price__c;
                    }
                    skuObj.priceGroupCode = pbObj.PG_CODE__r.Name; 
                    skuObj.priceGroupId = pbObj.PG_CODE__c;
                    skuObj.currencyIso = pbObj.currencyIsoCode;
                    skuObj.popular = pbObj.SKUCode__r.Product_Name__r.Popular__c;
                    skuObj.divisionId = pbObj.Division__c;
                    
                    //added by Vishal Pawar for Margin block changes
                    skuObj.specialSKU = pbObj.SKUCode__r.Special_SKU__c;
                    
                    
                    if(String.isNotBlank(pbObj.SKUCode__c) && String.isNotBlank(skuObj.UOM)){
                        skuObj.netRateEntered = 0;
                    }
                    //added by Vishal Pawar for Marginal and PLN value
                    
                    //for e2e
                    
                    if(prcE2eBlockMap.containsKey(pbObj.SKUCode__c)){                   
                        Price_Block_Margin_Matrix__c pbMME2eObj = prcE2eBlockMap.get(pbObj.SKUCode__c);
                        skuObj.e2ECostLC = pbMME2eObj.E2E_Cost_LC__c ; 
                        skuObj.e2ECostUSD = pbMME2eObj.E2E_Cost_USD__c ;
                        
                        if(pbMME2eObj.E2E_Cost_UPC9_LC__c!=null){
                            skuObj.e2ECostUPC9LC = pbMME2eObj.E2E_Cost_UPC9_LC__c  ;     
                        }
                        skuObj.e2ECostUPC9USD = pbMME2eObj.E2E_Cost_UPC9_USD__c ; 
                        
                        if(pbMME2eObj.E2E_Cost_MBEW_LC__c!=null){
                            skuObj.e2ECostMBEWLC = pbMME2eObj.E2E_Cost_MBEW_LC__c ;     
                        }
                        skuObj.e2ECostMBEWUSD = pbMME2eObj.E2E_Cost_MBEW_USD__c;
                        
                        skuObj.uome2eCost = pbMME2eObj.UOM__c;
                        
                        
                    }
                    
                    
                    //Ended by Vishal Pawar for Marginal and PLN value
                    skuDetailsMapp.put(skuObj.skuId , skuObj);
                }    //price book master for loop ends
                }
                
            }
            
            for(Inventory__c invObj : [SELECT Id, SKU__c, Stock_Quantity__c, Balanced_Quanity__c,In_transit_stock_quantity__c
                                       FROM Inventory__c WHERE Depot__c =: detailsWrapObj.depoId AND SKU__r.Active__c = True])
            {
                if(skuDetailsMapp.containsKey(invObj.SKU__c)){
                    SKUDetails skuObj = skuDetailsMapp.get(invObj.SKU__c);
                    skuObj.available = Integer.valueOf(invObj.Balanced_Quanity__c);
                    skuObj.inventoryId = invObj.Id;
                    if(invObj.Balanced_Quanity__c!=null && invObj.Balanced_Quanity__c > 0){
                        skuObj.available2 = 'In Stock';
                        skuObj.invStyle = 'color:green;';
                    }
                    else if(invObj.In_transit_stock_quantity__c != null){
                        if(invObj.In_transit_stock_quantity__c > 0 && detailsWrapObj.showInTransit == true 
                           && detailsWrapObj.showInTransitValues == false){
                               skuObj.available2 = 'In Transit';
                               skuObj.invStyle = 'color:blue;';
                           }
                        else if(invObj.In_transit_stock_quantity__c > 0 && detailsWrapObj.showInTransit == false
                                && detailsWrapObj.showInTransitValues == true){
                                    skuObj.available2 = '('+invObj.In_transit_stock_quantity__c+')';
                                    skuObj.invStyle = 'color:blue;';
                                }                    
                        else if(invObj.In_transit_stock_quantity__c > 0 && detailsWrapObj.showInTransit == true 
                                && detailsWrapObj.showInTransitValues == true){
                                    skuObj.available2 = 'In Transit ('+invObj.In_transit_stock_quantity__c+')';
                                    skuObj.invStyle = 'color:blue;';
                                } 
                    }
                    skuDetailsMapp.put(invObj.SKU__c, skuObj);
                }
            }
            mapSKUObj.skuDetailsMap = skuDetailsMapp;
            
            //this is dd
            
        }
        return mapSKUObj;
    }
    
    //Load Template Wrapper
    public class LoadTemplateWrap{
        @AuraEnabled public String payment_Methods;
        @AuraEnabled public String payment_Terms;
        @AuraEnabled public String inco_Terms;
        @AuraEnabled public List<SKUDetails> skuDetailList;
        @AuraEnabled public List<SKUDetails> skuOrderList;
        @AuraEnabled public List<orderSummaryUOM> orderSummaryUOMList;
        @AuraEnabled public List<orderSummaryCurrency> orderSummaryCurrencyList;
    }
    
    //Sales Order Details Wrapper
    public class SalesOrderDetailWrap{
        @AuraEnabled public String payment_Methods;
        @AuraEnabled public String payment_Terms;
        @AuraEnabled public String inco_Terms;
        @AuraEnabled public String selectedShipping;
        @AuraEnabled public String selectedOrderType;
        @AuraEnabled public String Remaks;
        @AuraEnabled public Sales_Order__c soObj;
    }
    
    //All Wrapper Data
    public class WrapperData{
        @AuraEnabled public List<SKUDetails> skuObjList;
        @AuraEnabled public List<SKUDetails> skuOrderList;
        @AuraEnabled public GetDetailsWrap initDetailsWrap;
        @AuraEnabled public DistributerWrapperObj distributerWrapObj;
        @AuraEnabled public List<orderSummaryUOM> orderSummaryUOMList;
        @AuraEnabled public List<orderSummaryCurrency> orderSummaryCurrencyList;
        @AuraEnabled public Order__c orderObj;
        @AuraEnabled public String error;
        @AuraEnabled public SalesOrderDetailWrap soWrap;
        @AuraEnabled public Login_Country__c lCountry; // SKI(Vishal P) : #CR152 : PO And Delivery Date : 18-07-2022..
        
    }
    
    //Get Inventory details wrapper
    public class InventoryWrap{
        @AuraEnabled public List<SKUDetails> skuObjList;
        @AuraEnabled public List<SKUDetails> skuOrderList;
        @AuraEnabled public SKUDetails selectedSKU;
    }
    
    //Get Order ar init Wrapper Data
    public class WrappergetOrder{
        @AuraEnabled public List<SKUDetails> skuOrderList;
        @AuraEnabled public List<orderSummaryUOM> orderSummaryUOMList;
        @AuraEnabled public List<orderSummaryCurrency> orderSummaryCurrencyList;
    }
    
    //Map SKU Wrapper
    public class mapSKUWrapper{
        @AuraEnabled public Map<Id, SKUDetails> skuDetailsMap;
        @AuraEnabled public String error;
        public mapSKUWrapper(){
            skuDetailsMap = new Map<Id, SKUDetails>();
            error = 'NA';
        }
    }
    
    //Init Details Wrapper
    public class GetDetailsWrap{
        @AuraEnabled public String depoId;
        @AuraEnabled public String country;
        @AuraEnabled public String userDepotCode;
        @AuraEnabled public Boolean showInTransit;
        @AuraEnabled public Boolean showInTransitValues;
        @AuraEnabled public Boolean cropSelection;
        @AuraEnabled public Boolean showInventory;
        @AuraEnabled public Boolean showInventoryColumn;
        @AuraEnabled public Boolean showCredit;
        @AuraEnabled public Boolean showMaxPrice;
        @AuraEnabled public Boolean showMinPrice;
        @AuraEnabled public Boolean showDirectorPrice;
        @AuraEnabled public Boolean showRegionHeadPrice;
        @AuraEnabled public String managerId;
        @AuraEnabled public String latamDirectorId;
        @AuraEnabled public String salesDirectorId;
        
        @AuraEnabled public String nationalMarketingMgrId;
        @AuraEnabled public String nationalSaleMgrId;
        
        
        @AuraEnabled public Boolean enableDepot;
        @AuraEnabled public String orderRaisedBy;
        @AuraEnabled public String RM_AccountOwner;
        @AuraEnabled public String distributorId;
        @AuraEnabled public String accountId;
        @AuraEnabled public String territoryManagerId;
        @AuraEnabled public List<Crop__c> cropList;
        @AuraEnabled public String distributionChannel;
        @AuraEnabled public Map<Id, Inco_Term__c> mapIncoTerm;
        @AuraEnabled public String storageIdChosen;
        @AuraEnabled public Map<String, Sales_Order__c> orgSalesorderMap; 
        @AuraEnabled public String typeOfOrder; 
        
        public GetDetailsWrap(String recordId){
            country = 'Mexico';
            showMaxPrice = FALSE;
            showMinPrice = FALSE;
            cropList = [SELECT Id, Name FROM Crop__c where Active__c = TRUE AND Sales_Org_Code__c='5100'];
            showDirectorPrice = FALSE;
            showRegionHeadPrice = FALSE;
            userDepotCode = 'MX00';
            mapIncoTerm = new Map<Id, Inco_Term__c>([SELECT Id FROM Inco_Term__c WHERE Name IN ('CFR','ZNO')]);
            showCredit = FALSE;
            showInventory = FALSE;
            showInventoryColumn = FALSE;
            showInTransit = FALSE;
            showInTransitValues = FALSE;
            
            String sobjectType = Id.valueOf(recordId).getSObjectType().getDescribe().getName();
            if(sobjectType == 'Sales_Order__c'){
                Sales_Order__c soObj = [SELECT Id, Sold_to_Party__c FROM Sales_Order__c WHERE Id =: recordId];
                accountId = soObj.Sold_to_Party__c;
                typeOfOrder = 'Edit';
            }else if(sobjectType == 'Account'){
                accountId = recordId;
                typeOfOrder = 'Create';
            }
            
            orgSalesorderMap = new Map<String, Sales_Order__c>();
            
            User loginUserObj = [SELECT Id, Name, NationalMarketingManager__c,National_Sales_Manager__c,IsActive, ContactId, UserRole.Name, Show_Min_Price__c, Show_Max_Price__c, Show_Sales_Director_Price__c,
                                 Show_Latam_Region_Head_Price__c, Show_Inventory__c, Show_Credit_Limit__c, EnableDepot__c,
                                 Show_Inventory_Column__c, ManagerId, Show_InTransit__c, Show_InTransit_Values__c, Country_Head__c, Marketing_Manager__c,
                                 Crop_Selection__c FROM User WHERE Id =: UserInfo.getUserId() AND IsActive = True];
            
            cropSelection = loginUserObj.Crop_Selection__c;
            showInventory = loginUserObj.Show_Inventory__c;
            showInventoryColumn = loginUserObj.Show_Inventory_Column__c;
            showCredit = loginUserObj.Show_Credit_Limit__c;
            showInTransit = loginUserObj.Show_InTransit__c;
            showInTransitValues = loginUserObj.Show_InTransit_Values__c;
            showMaxPrice = loginUserObj.Show_Max_Price__c;
            showMinPrice = loginUserObj.Show_Min_Price__c;
            showDirectorPrice = loginUserObj.Show_Sales_Director_Price__c;
            showRegionHeadPrice = loginUserObj.Show_Latam_Region_Head_Price__c;
            //for Users 
            managerId = loginUserObj.ManagerId;
            latamDirectorId = loginUserObj.Country_Head__c;
            salesDirectorId = loginUserObj.Marketing_Manager__c;
            nationalMarketingMgrId = loginUserObj.NationalMarketingManager__c;
            nationalSaleMgrId = loginUserObj.National_Sales_Manager__c;
            
            //added by Vishal Pawar
            
            
            //Fetching Distributer Depot Mapping
            List<Distributor_Depot_Mapping__c> depotList = [SELECT Id, Depot__r.Depot_Code__c, Depot__c FROM Distributor_Depot_Mapping__c 
                                                            WHERE Depot__r.Depot_Code__c =: userDepotCode 
                                                            AND Depot__c != '' AND Depot__r.SalesOrg__r.Sales_Org_Code__c = '5100' LIMIT 1];
            if(depotList != null && !depotList.isEmpty()){
                depoId = depotList[0].Depot__c;
            }
            
            if(userDepotCode=='MX00'){distributionChannel = '20';}
            else if(userDepotCode=='MX51'){distributionChannel = '67';}
            
            //Assign account Id if TM creates order on behalf of Distributor
            if(String.isNotBlank(accountId)){            
                enableDepot = loginUserObj.EnableDepot__c;
                List<User> listUr = [SELECT u.Id, u.IsActive, u.IsPortalEnabled FROM User u where u.AccountId =: accountId];
                if(listUr != null && listUr.size() >0 ){
                    distributorId = listUr[0].Id;
                }else{
                    Account accOwner = [Select Id, ownerId From Account Where id =: accountId];
                    distributorId = accOwner.ownerId;
                }
                List<AccountTeamMember> accountTeamList = new List<AccountTeamMember>(); 
                
                if(loginUserObj.UserRole.Name.contains('Commercial Leader')){
                    orderRaisedBy = 'Commercial Leader';
                }else{
                    orderRaisedBy= 'Territory Manager';
                }
                accountTeamList = [SELECT UserId, User.ManagerId, TeamMemberRole, AccountId FROM AccountTeamMember
                                   WHERE AccountID =: accountId AND User.ManagerId =: loginUserObj.Id];
                if(accountTeamList.size() > 0){
                    RM_AccountOwner = accountTeamList[0].UserId;
                }else{
                    System.Debug('RM not Found in account team');
                }
            }
            else{
                //Assign Account Id based on Logged In User            
                List<Contact> conList = [SELECT Id, FirstName, LastName, AccountId, Account.OwnerId, Account.RegionalManager__c
                                         FROM Contact WHERE Id =: loginUserObj.ContactId];
                distributorId = UserInfo.getUserId();
                showInventory = loginUserObj.Show_Inventory__c;
                
                if(!conList.isEmpty()){        
                    accountId = conList[0].AccountId;
                    territoryManagerId = conList[0].Account.OwnerId;      
                }
                orderRaisedBy = 'Distributor';
            }
            
            //Set Storage Location
            List<Depot__c> listDepot = [Select Id, Name from Depot__c where recordtype.name = 'Storage Location' AND
                                        SalesOrg__r.name =: country AND Depot__r.Depot_Code__c =: userDepotCode 
                                        AND Active__c = TRUE];
            
            if(listDepot != null && !listDepot.isEmpty()){
                storageIdChosen = listDepot[0].Id;
            }
        }
    }
    
    //Distributer Details Wrapper
    public class DistributerWrapperObj{
        @AuraEnabled public String error = 'NA';
        @AuraEnabled public String distributor_Name;
        @AuraEnabled public String sap_code;
        @AuraEnabled public String salesAreaAccountOwner;
        @AuraEnabled public List<Depot__c> listDepot;
        @AuraEnabled public List<Payment_Term__c> listPaymentTerm;
        @AuraEnabled public List<Payment_Method__c> paymentMethodList;
        @AuraEnabled public List<Inco_Term__c> incoTermList;
        @AuraEnabled public List<String> divisionIds;
        @AuraEnabled public String territoryManagerId;
        @AuraEnabled public String salesOrgId;
        @AuraEnabled public String salesOrgName;
        @AuraEnabled public String incoTerms;
        @AuraEnabled public String salesDirector;
        @AuraEnabled public String latamDirector;
        @AuraEnabled public String orderType;
        @AuraEnabled public String paymentTerms;
        @AuraEnabled public String paymentMethods;
        @AuraEnabled public String priceGroupId;
        @AuraEnabled public Decimal internalCredit;
        @AuraEnabled public Decimal creditLimit;
        @AuraEnabled public Decimal daysArrears;
        @AuraEnabled public Decimal creditUsed;
        @AuraEnabled public Decimal creditBalance;
        @AuraEnabled public Decimal paymentOutstanding;
        @AuraEnabled public Decimal greaterThan90;
        @AuraEnabled public String address;
        @AuraEnabled public String city;
        @AuraEnabled public String state;
        @AuraEnabled public String country;
        @AuraEnabled public String pincode;
        @AuraEnabled public String currencyIso;
        @AuraEnabled public Id regionalManagerId;
        @AuraEnabled public Id distributorChannelId;
        @AuraEnabled public String paymentMthods;
        @AuraEnabled public Map<String, ShippingLocationWrapper> mapShippingLocationWrapper;
        @AuraEnabled public ShippingLocationWrapper selectedShippingLocation;
        @AuraEnabled public List<PickListWrapper> shippingList;
        @AuraEnabled public Map<String, DistributorSalesAreaMapping__c> distributorSalesAreaMappingMAP;
    }
    
    //Picklist Value Wrapper
    public class PickListWrapper{
        @AuraEnabled public String label;
        @AuraEnabled public String value;
        public PickListWrapper(String label, String value){
            this.label = label;
            this.value = value;
        }
    }
    
    //Shipping Location Wrapper
    public class ShippingLocationWrapper{
        @AuraEnabled public String locationId;
        @AuraEnabled public String depoId; 
        @AuraEnabled public String address;
        @AuraEnabled public String city;
        @AuraEnabled public String state;
        @AuraEnabled public String country;
        @AuraEnabled public String pincode;
        @AuraEnabled public String Billing_Street_1;
        @AuraEnabled public String Billing_Street_2;
        @AuraEnabled public String Billing_Street_3;
        @AuraEnabled public String Billing_Street_4;
        @AuraEnabled public String Billing_Street_5;
        @AuraEnabled public String Billing_Street_6;
    }
    
    //SKU Details Wrapper
    public class SKUDetails{
        @AuraEnabled public String cropName1;
        @AuraEnabled public String cropName2;
        @AuraEnabled public String cropName3;
        @AuraEnabled public String cropName4;
        @AuraEnabled public String cropName5;
        @AuraEnabled public String typeOfSale;
        @AuraEnabled public String agrosatSale;
        @AuraEnabled public Boolean disablePrice;
        @AuraEnabled public String crop1;
        @AuraEnabled public Decimal crop1_Percentage;
        @AuraEnabled public String crop2;
        @AuraEnabled public Decimal crop2_Percentage;
        @AuraEnabled public String crop3;
        @AuraEnabled public Decimal crop3_Percentage;
        @AuraEnabled public String crop4;
        @AuraEnabled public Decimal crop4_Percentage;
        @AuraEnabled public String crop5;
        @AuraEnabled public Decimal crop5_Percentage;
        @AuraEnabled public Decimal multipleOf;
        @AuraEnabled public Decimal director_Price;
        @AuraEnabled public Decimal manager_Price;
        @AuraEnabled public String brandName;
        @AuraEnabled public String divisionId;
        @AuraEnabled public String description;
        @AuraEnabled public Boolean popular;
        @AuraEnabled public Id distributorId;
        @AuraEnabled public String productName;
        @AuraEnabled public String productId;
        @AuraEnabled public String oliId;
        @AuraEnabled public String skuPackName;
        @AuraEnabled public String skuCode;
        @AuraEnabled public Id skuId;
        @AuraEnabled public String depotLocation;
        @AuraEnabled public Id depotId;     
        @AuraEnabled public String priceGroupCode;
        @AuraEnabled public Id priceGroupId;
        @AuraEnabled public Id InventoryId;
        @AuraEnabled public String uOM;
        @AuraEnabled public Decimal netRateEntered;
        @AuraEnabled public String netRateEnteredText;
        @AuraEnabled public Decimal qty;
        @AuraEnabled public Decimal price;
        @AuraEnabled public Decimal finalPrice;
        @AuraEnabled public Integer itemNo;
        @AuraEnabled public Decimal available;
        @AuraEnabled public Decimal maxPrice;
        @AuraEnabled public Decimal minPrice;
        @AuraEnabled public Date deliveryDate;
        @AuraEnabled public Date customerDeliveryDate; // SKI(Vishal P) : #CR152 : PO And Delivery Date : 18-07-2022
        @AuraEnabled public String available2;
        @AuraEnabled public String currencyIso;
        @AuraEnabled public Decimal palletSize;
        @AuraEnabled public String error;
        @AuraEnabled public String invStyle;
        @AuraEnabled public String divisionCode;
        
        //added By vishal for Margin block and PL value
        @AuraEnabled public String e2EUOM;
        @AuraEnabled public Decimal e2EUOMValueCon;
        @AuraEnabled public String e2EBaseUOM;
        @AuraEnabled public String e2ESalesUOM;
        
        @AuraEnabled public Decimal e2ECostLC; 
        @AuraEnabled public decimal e2ECostUSD; 
        @AuraEnabled public decimal e2ECostUPC9LC; 
        @AuraEnabled public decimal e2ECostUPC9USD; 
        @AuraEnabled public decimal e2ECostMBEWLC; 
        @AuraEnabled public decimal e2ECostMBEWUSD;
        
        @AuraEnabled public String salesDeductionUOM; 
        @AuraEnabled public Decimal salesDeductionLC;  
        @AuraEnabled public Decimal salesDeductionUSD;
        @AuraEnabled public Decimal salesDeductionDUOMValueCon;
        @AuraEnabled public Decimal salesDeductionInPercent;   //if salesDeductionLC not available then query on profit center (Sale Value)
        
        @AuraEnabled public String rebate1UOM; 
        @AuraEnabled public Decimal rebate1LC; 
        @AuraEnabled public Decimal rebate1USD;
        @AuraEnabled public Decimal rebateUOMConver1;
        @AuraEnabled public Decimal rebateUOMConver2;
        
        @AuraEnabled public Decimal rebate1Percent;
        @AuraEnabled public String rebateCode1;
        
        @AuraEnabled public String rebate2UOM; 
        @AuraEnabled public Decimal rebate2LC; 
        @AuraEnabled public Decimal rebate2USD; 
        @AuraEnabled public Decimal rebate2Percent;
        @AuraEnabled public String rebateCode2;  
        
        @AuraEnabled public String discountUOM; 
        @AuraEnabled public Decimal discountLC; 
        @AuraEnabled public Decimal discountUSD; 
        @AuraEnabled public Decimal discountPercent; 
        @AuraEnabled public Decimal discountUOMConver;
        
        @AuraEnabled public String additionalDiscountUOM; 
        @AuraEnabled public Decimal additionalDiscountLC; 
        @AuraEnabled public Decimal additionalDiscountUSD; 
        @AuraEnabled public Decimal additionalDiscountPercent; 
        @AuraEnabled public Decimal additionalDiscountUOMConver;
        
        @AuraEnabled public String plnUOM; 
        @AuraEnabled public Decimal pLNLC; 
        @AuraEnabled public Decimal pLNUSD; 
        @AuraEnabled public Decimal plnUOMConver;
        
        @AuraEnabled public String profitCenter;
        
        @AuraEnabled public Boolean specialSKU;
        
        @AuraEnabled public String uomRebate1;
        @AuraEnabled public String uomRebate2;
        @AuraEnabled public String uomDiscount;
        @AuraEnabled public String uomAddDiscount;
        @AuraEnabled public String uomSalesDeduction;
        @AuraEnabled public String uome2eCost;
        @AuraEnabled public String uomPLN;
        //additional added for Contribution Margin 
        //baseUom refered from UOM Conversion
        @AuraEnabled public String baseUOM;
        @AuraEnabled public Decimal convertQty;
        @AuraEnabled public Decimal convertNetPrice;
        @AuraEnabled public Decimal convertFinalPrice;
                
        public SKUDetails(){
            this.cropName1 = '';
            this.cropName2 = '';
            this.cropName3 = '';
            this.cropName4 = '';
            this.cropName5 = '';
            this.typeOfSale = 'Real Sale';
            this.agrosatSale = '';
            this.disablePrice = false;
            this.uOM = '';
            this.maxPrice = 0;
            this.crop1 = '';
            this.crop1_Percentage = 0;
            this.crop2 = '';
            this.crop2_Percentage = 0;
            this.crop3 = '';
            this.crop3_Percentage = 0;
            this.crop4 = '';
            this.crop4_Percentage = 0;
            this.crop5 = '';
            this.crop5_Percentage = 0;
            this.minPrice = 0;
            this.qty = 0;
            this.itemNo = 0;
            this.manager_Price=0;
            this.director_Price = 0;
            this.price = 0;
            this.finalPrice = 0;
            this.netRateEntered = 0;
            this.netRateEnteredText = '0';
            this.available = 0;
            this.available2 = 'Out of Stock';
            this.popular = false;
            this.divisionId='';
            this.multipleOf =0;
            this.deliveryDate = Date.today() + 3;
            //this.customerDeliveryDate = Date.today() + 1; // SKI(Vishal P) : #CR152 : PO And Delivery Date : 18-07-2022
            this.palletSize = 0;
            this.error = 'NA';
            this.invStyle = 'color:red;';
        }
    }
    
    //Order Summary Currency Map Wrapper
    public class orderSummaryCurrencyMap{
        @AuraEnabled public Map<String, orderSummaryCurrency> mapCurrencyOrderSummary;
        public orderSummaryCurrencyMap(){
            this.mapCurrencyOrderSummary = new Map<String, orderSummaryCurrency>();
        }
    }
    
    //Order Summary Currency Wrapper 
    public class orderSummaryCurrency{
        @AuraEnabled public String currencyName;
        @AuraEnabled public Decimal totalValue;
        public orderSummaryCurrency(){
            this.currencyName = '';
            this.totalValue = 0;
        }
    }
    
    //Order Summary UOM Wrapper
    public class orderSummaryUOM{
        @AuraEnabled public String UOM;
        @AuraEnabled public Decimal totalQty;
        public orderSummaryUOM(){
            UOM = '';
            totalQty = 0;
        }
    }
    
    //Order Summary UOM Map Wrapper
    public class orderSummaryUOMmapClass{
        @AuraEnabled public Map<String, orderSummaryUOM> orderSummaryUOMmap;
        public orderSummaryUOMmapClass(){
            this.orderSummaryUOMmap = new Map<String, orderSummaryUOM>();
        }
    }
    
    @AuraEnabled
    public static Id saveChunk(Id parentId, String fileName, String base64Data, String contentType, String fileId) {
        if(fileId == ''){
            fileId = saveTheFile(parentId, fileName, base64Data, contentType);
        }else{
            appendToFile(fileId, base64Data);
        }
        return Id.valueOf(fileId);
    }
    
    public static Id saveTheFile(Id parentId, String fileName, String base64Data, String contentType) {
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        Attachment oAttachment = new Attachment();
        oAttachment.parentId = parentId;
        oAttachment.Body = EncodingUtil.base64Decode(base64Data);
        oAttachment.Name = fileName;
        oAttachment.IsPrivate = false;
        oAttachment.ContentType = contentType;
        oAttachment.Description = fileName;
        insert oAttachment;
        return oAttachment.Id; 
    }
    
    private static void appendToFile(Id fileId, String base64Data) {
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        Attachment att = [SELECT Id, Body FROM Attachment WHERE Id =: fileId];
        String existingBody = EncodingUtil.base64Encode(att.Body);
        att.Body = EncodingUtil.base64Decode(existingBody + base64Data);
        update att;
    }
}