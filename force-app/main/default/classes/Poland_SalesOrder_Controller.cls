/*  
* Name: Poland_SalesOrder_Controller    
* Created On: 20 Aug 2020  
* Author: Vishal Pawar (vishal.pawar@skinternational.com)   
* Description: Lightning Component Apex Controller used for Raising orders for Poland. 
test Class Name: Poland_SalesOrder_Controller_test
*/ 

public without sharing class Poland_SalesOrder_Controller {
    
    @AuraEnabled    
    public static void OrderItems(CartWrapper cartObj2 ,Order__c orderObj2, SalesOrderItem OrderItemString,String PaymentTerm){
        List<OrderLineItem__c> oliList = new List<OrderLineItem__c>();
        
        OrderLineItem__c oliObj = new OrderLineItem__c();   
        oliObj.Order__c = orderObj2.Id; 
        
        System.debug('OrderItemString.productId '+OrderItemString.productId);
        System.debug('OrderItemString.UOM '+OrderItemString);
        
        oliObj.SKU_Name__c = OrderItemString.skuId; 
        
        oliObj.UOM__c = OrderItemString.UOM; 
        
        oliObj.Price__c =OrderItemString.basePrice;
        oliObj.Base_Price_OG__c= OrderItemString.basePriceOg;
        
        System.debug('OrderItemString.distributionChannelId; '+OrderItemString.distributionChannelId);
        System.debug('OrderItemString.distributionChannelId; '+OrderItemString.divisionId);
        oliObj.Distribution_Channel__c =OrderItemString.distributionChannelId;
        oliObj.Division__c =OrderItemString.divisionId;
        oliObj.Quantity__c = OrderItemString.qty;
        oliObj.multipleOf__c = OrderItemString.multipleOf;
        oliObj.pallet_Size_Italy__c = OrderItemString.palletSize;
        oliObj.Early_Order_Discount__c = OrderItemString.earlyOrderDiscount;
        oliObj.Big_Volume_Discount__c = OrderItemString.bigVolDiscount;
        oliObj.Manual_Discount__c = OrderItemString.manualDiscount;
        oliObj.Logistic_Discount__c = OrderItemString.logisticDiscount;
        //Added for the CR-APPS-2521-Start
        if(OrderItemString.PAK != null){
            oliObj.PAK__c = OrderItemString.PAK;
        }
        if(OrderItemString.isParent != null){
            oliObj.isParent__c=OrderItemString.isParent;//Nandhini
        }
        //APPS-2521-End
        //oliObj.PAK__c = OrderItemString.PAK;
        
        //System.debug('OrderItemString.logisticDiscountValue '+OrderItemString.logisticDiscountValue);
        
        oliObj.Logistic_Discount_Value__c = OrderItemString.logisticDiscountValue;        
        oliObj.Truck_Quantity__c = OrderItemString.truckSize;
        
        
        oliObj.Net_Price__c = OrderItemString.basePrice;//correct
        oliObj.Unit_Price__c = OrderItemString.finalPrice ;//correct
        oliObj.FinalPrice__c = OrderItemString.netValue; //correct
        //this is for Inventory  Inventory__c
        oliObj.Inventory__c = OrderItemString.inventory; //correct
        oliObj.Payment_Term_Poland__c = OrderItemString.typeOfPayment;
        oliObj.CurrencyIsoCode = 'PLN';
        
        oliObj.Big_Volume_for_Truck_c__c = OrderItemString.Big_Volume_for_Truck;
        oliObj.Big_Volume_for_Pallet__c = OrderItemString.Big_Volume_for_Pallet;
        oliObj.Delivery_Date__c = OrderItemString.customerDeliveryDate;         //SKI(Vishal P) : #CR152 : PO and Delivery Date : 29-09-2022...
        
        
        //Pending Of Inventory
        oliList.add(oliObj);
        System.debug('oliList @@@@ '+oliList);
        if(!oliList.isEmpty()){
            insert oliList; 
            OrderItemString.oliId = oliList[0].Id;
            System.debug('OrderItemString after adding oliList[0].Id  '+oliList[0].Id);
            
            cartObj2.soitemObj = OrderItemString;    
            
        }
        
        
    }
    
    
    
    //Added for the CR-APPS-2521-Start(Added the last Parameter)
    @AuraEnabled    
    public static CartWrapper saveOrder(String accountId, String OrderItemString ,String orderObjId,String PaymentTerm,String incoTerm,List<String> orderItemListString){
        System.debug('accountId '+accountId);
        System.debug('OrderItemString in save Order  '+OrderItemString);
        System.debug('orderObjId '+orderObjId);
        System.debug('PaymentTerm '+PaymentTerm);
        System.debug('incoTerm '+incoTerm);
        
        CartWrapper cartObj = new CartWrapper(); 
        try{
            Order__c orderObj = new Order__c(); 
            system.debug('orderObjId'+orderObjId);
            if(orderObjId!=null && orderObjId!=''){  
                orderObj.id = orderObjId; 
                upsert orderObj; 
                system.debug('orderObjId--->1'+orderObj); 
            }else{
                system.debug('orderObjId--Else--'+orderObjId); 
                orderObj.OwnerId = UserInfo.getUserId();
                orderObj.Bill_To_Party__c = accountId;
                orderObj.Inco_Term__c =incoTerm ;
                orderObj.Order_Status__c = 'Draft';
                orderObj.CurrencyIsoCode = 'PLN';    
                orderObj.Order_Date__c = System.today();
                List<Sales_Org__c> salesOrgList = [Select ID FROM Sales_Org__c   
                                                   WHERE Sales_Org_Code__c = '2941' LIMIT 1];  
                if(!salesOrgList.isEmpty()){ 
                    orderObj.Sales_Org__c = salesOrgList[0].Id;  
                }
                insert  orderObj; 
                cartObj.cartOrderId = orderObj.Id;
                system.debug('orderObj.Id '+orderObj.Id); 
            }
            system.debug('OrderItemString : '+OrderItemString);
              // below added by Vaishnavi W.r.t CR- RITM0443900 -//Added for the CR-APPS-2521-Start
            system.debug('orderItemListString : '+orderItemListString);
            if(orderItemListString?.size() > 0){
                for(String orderLi: orderItemListString){
                    //System.debug('orderLi ===> '+orderLi);
                    SalesOrderItem OrderItemList1 = (SalesOrderItem)JSON.deserialize(orderLi, SalesOrderItem.class);
                    //System.debug('OrderItemList1 =>> '+OrderItemList1);
                    Poland_SalesOrder_Controller.OrderItems(cartObj,orderObj, OrderItemList1,PaymentTerm);
                    cartObj.soiList.add(cartObj.soitemObj);
                }//Added for the CR-APPS-2521-End
            }else{
                SalesOrderItem OrderItemList1 = (SalesOrderItem)JSON.deserialize(OrderItemString, SalesOrderItem.class); 
                Poland_SalesOrder_Controller.OrderItems(cartObj,orderObj, OrderItemList1,PaymentTerm);
            }
            
        }
        catch(Exception ex){   
            System.debug('ErrLine--@@@@@ >'+ex.getMessage()); 
            System.debug('ErrLine--@@@@@ >'+ex.getLineNumber()); 
            //If Exception occurrs or If Upsert Fails assign data to return wrapper object. 
            cartObj.errorMessage = 'Product not added to the Cart Please Contact System Administrator';    
        }
        
        System.debug('cartObj in return '+cartObj);
        return cartObj; 
    }
    
        
            
            
            
        
    
    @AuraEnabled (cacheable = true)   
    public static OrderFields getOrderFields1(String accId){ 
        OrderFields ofObj = new OrderFields();  
        ofObj.DistributorData = Poland_SalesOrder_Controller.fetchDistributorDetails(accId); 
        return ofObj;
    }
    
    
    @AuraEnabled    
    public static OrderFields getOrderFields(String accId){ 
        
        
        String recordId = '';    
        Id profileId= userinfo.getProfileId();
        String userid = UserInfo.getUserId();
        System.debug('userid '+userid);
        String profileName = [Select Id,Name from Profile where Id=:profileId].Name;
        system.debug('ProfileName community '+profileName);
        
        if(profileName == 'Customer Community Plus User - Poland - 1' || profileName == 'Customer Community Plus User - Poland - 2' || profileName=='Customer Partner Community Plus User - Poland - 1' ||profileName=='Customer Partner Community Plus User - Poland - 2'){
            User userObj = [SELECT Id,UserName, AccountId FROM User WHERE Id=: userid];
            recordId = userObj.AccountId;  
            
        }else{
            recordId = accId;    
        }
        /* ----------------- Start SKI(Vishal P) : #CR152 : PO and Delivery Date : 29-09-2022 --------------------- */
        Login_Country__c lObj = [SELECT Id, Name, For_Contry__c, Sales_Org_Code__c, 
                                 Delivery_Date__c, PO_Date__c, Show_Delivery_Date__c, Show_PO_Date__c 
                                 FROM Login_Country__c
                                WHERE Sales_Org_Code__c='2941']; 
        /* ------------------ End SKI(Vishal P) : #CR152 : PO and Delivery Date : 29-09-2022 ----------------------- */                        
        
        OrderFields ofObj = new OrderFields();
        ofObj.loginCobj = lObj;  // SKI(Vishal P) : #CR152 : PO and Delivery Date : 29-09-2022...
        ofObj.DistributorData = Poland_SalesOrder_Controller.fetchDistributorDetails(recordId); 
        ofObj.ShippingLocMap = Poland_SalesOrder_Controller.getShippingLoations(recordId);  
        System.debug('@@@ ofObj.ShippingLocMap '+ofObj.ShippingLocMap);
        ofObj.incoTermMap = Poland_SalesOrder_Controller.gettingIncoTermList();
        ofObj.paymentTermMap = Poland_SalesOrder_Controller.gettingPaymentTermList();
        ofObj.userObj = [Select Id, Profile.Name, Show_List_Value__c FROM User WHERE Id=:UserInfo.getUserId()]; 
        List<DistributorSalesAreaMapping__c> divisionCodeListTemp = [SELECT Id,AccountOwner__c, Division_Code__c  
                                                                     FROM DistributorSalesAreaMapping__c
                                                                     where Distributor__c=:recordId And Distribution_Channel_Code__c='20' 
                                                                     AND Manually_Created__c = false];
        
        if(divisionCodeListTemp.size()>0){
            for(DistributorSalesAreaMapping__c dsaObj:divisionCodeListTemp){
                ofObj.divisionCodeList.add(dsaObj.Division_Code__c);
            }
            
        }
        
        
        return ofObj;   
    }   
    
    @AuraEnabled    
    public static DistributorWrapper fetchDistributorDetails(String recordId){  
        
        String  Payment_Terms = ''; 
        List<Payment_Term__c> paymentTermList = new List<Payment_Term__c>();    
        List<Account> accList = [SELECT Id, Name, BillingCity,Payment_Term_Code__C, BillingCountry, RegionalManager__c,    
                                 BillingStreet, BillingState, BillingPostalCode , CurrencyIsoCode, Sales_Org__r.Name,Billing_Street_6__c,  
                                 OwnerId, SAP_Code__c, Sales_Org__c, Distribution_Channel__c, Division__c,Region__r.RegionHead__c,Billing_Street_4__c,Billing_Street_5__c,  
                                 Order_Type__c, Order_Block__c,Sales_Org_Code__c, Status__c,Payment_Terms__c,Billing_Street_1__c,Billing_Street_2__c,Billing_Street_3__c,   
                                 PriceGroupCode__c,Sales_District__c,Distributor_Type_Poland__c,Sales_District__r.Sales_Director__c,Sales_District__r.Latam_Director__c    
                                 FROM Account   
                                 WHERE Id=:recordId LIMIT 1];   
        
        if(accList.size()>0){ 
            
            if(accList[0].Payment_Term_Code__c!=null){  
                Payment_Terms = accList[0].Payment_Term_Code__c ;   
                paymentTermList =  [SELECT Id,name,Payterms_Desc__c,Payment_Term__c,Sales_Org__c,Payment_Term_Code__c FROM Payment_Term__c    
                                    where id=:Payment_Terms LIMIT 1]; 
            }   
        }   
        
        List<Distributor_Depot_Mapping__c> dmList = [SELECT id, Distributor__c ,Depot__c, Depot__r.Location__c  
                                                     FROM Distributor_Depot_Mapping__c  
                                                     WHERE Distributor__c=:recordId LIMIT 1];   
        
        List<DistributorSalesAreaMapping__c> SalesAreaDMList = [SELECT Id,AccountOwner__c, Division_Code__c, Sales_Org_Code__c, Order_Type__c, PriceGroupMaster__c, 
                                                                Distribution_Channel_Code__c, SalesOrg__c, Division__c, Distributor__c  
                                                                FROM DistributorSalesAreaMapping__c where Distributor__c=:recordId And Distribution_Channel_Code__c='20' 
                                                                AND Manually_Created__c = false LIMIT 1]; 
        
        
        
         
        List<Credit_Info__c> ciList = [SELECT id, name,Distributor__c,distributor__r.name,  
                                       Credit_Limit__c,Balance_Limit__c,Used_Limit__c,  
                                       Internal_Limit__c, Sum_Open_Item__c, DAYS_ARREARS__c     
                                       FROM Credit_Info__c  
                                       WHERE Distributor__c =:recordId LIMIT 1];    
        
       
        List<Outstanding_Ageing__c> oagList = [SELECT id, OutstandingTotalGreaterthan90__c, Net_Outstanding__c  
                                               FROM Outstanding_Ageing__c   
                                               WHERE Customer_Code__c =:recordId LIMIT 1];  
        
        List<Payments__c> oaList = [SELECT id, Net_Overdue__c  FROM Payments__c     
                                    WHERE Customer_Name__c =:recordId LIMIT 1]; 
        
        
        DistributorWrapper distributorDetails = new DistributorWrapper();
        distributorDetails.accountIds = accList[0].Id;
        distributorDetails.distributorName = accList[0].Name;   
        distributorDetails.sapCode = accList[0].SAP_Code__c;    
        distributorDetails.salesOrgId =SalesAreaDMList[0].SalesOrg__c;  
        distributorDetails.salesOrgName = accList[0].Sales_Org__r.Name; 
        distributorDetails.distributorChannelId = accList[0].Distribution_Channel__c;       
        distributorDetails.divisionId = SalesAreaDMList[0].Division__c;     
        distributorDetails.priceGroupId = SalesAreaDMList[0].PriceGroupMaster__c;
        System.debug('accList[0].Distributor_Type_Poland__c '+accList[0].Distributor_Type_Poland__c);
        distributorDetails.customerType = accList[0].Distributor_Type_Poland__c;
        
        if(paymentTermList.size()>0){   
            distributorDetails.paymentTermId = Payment_Terms;   
            distributorDetails.paymentTerms = paymentTermList[0].Payment_Term__c;   
            
        }   
        distributorDetails.address = accList[0].BillingStreet;  
        distributorDetails.city = accList[0].BillingCity;   
        distributorDetails.state = accList[0].BillingState; 
        distributorDetails.country = accList[0].BillingCountry; 
        distributorDetails.pincode = accList[0].BillingPostalCode;  
        distributorDetails.billingSteet1 = accList[0].Billing_Street_1__c;  
        distributorDetails.billingSteet2 = accList[0].Billing_Street_2__c;  
        distributorDetails.billingSteet3 = accList[0].Billing_Street_3__c;  
        distributorDetails.billingSteet4 = accList[0].Billing_Street_4__c;  
        distributorDetails.billingSteet5 = accList[0].Billing_Street_5__c;  
        distributorDetails.billingSteet6 = accList[0].Billing_Street_6__c;  
        distributorDetails.currencyIso = accList[0].currencyIsoCode;    
        distributorDetails.regionalManagerId = accList[0].RegionalManager__c;   
        
        if(!oaList.isEmpty()){  
            distributorDetails.greaterThan90 = oaList[0].Net_Overdue__c; //oaList[0].OutstandingTotalGreaterthan90__c;  
        }   
        
        if(!oagList.isEmpty()){ 
            distributorDetails.paymentOutstanding = oagList[0].Net_Outstanding__c;  
        }   
        
        if(!dmList.isEmpty()){  
            distributorDetails.depot = dmList[0].Depot__r.Location__c;  
        }   
        
        if(!ciList.isEmpty()){  
            distributorDetails.creditLimit = ciList[0].Credit_Limit__c; 
            distributorDetails.creditUsed = ciList[0].Used_Limit__c;    
            distributorDetails.creditBalance = ciList[0].Balance_Limit__c;  
            distributorDetails.daysArrears = ciList[0].DAYS_ARREARS__c; 
            distributorDetails.internalCredit = ciList[0].Internal_Limit__c;    
        }   
        return distributorDetails;  
    } // end of fetchDistributorDetails function
    
    
    
    //Method to get a map of picklist values of Shipping Location from custom object.   
    public static Map<String,Shipping_Location__c> getShippingLoations(string accountId){   
        Map<String,Shipping_Location__c> options = new Map<String,Shipping_Location__c>();   
        if(String.isNotBlank(accountId)){
            //ItalyShipLocationShare is use in Italy but getting Shipping Location with sharing
            options = PolandShipLocationShare.getShippingLocation(accountId);    
            system.debug('options while Community users Place Order '+options);    
        }   
        return options; 
    } 
    
    @AuraEnabled   
    public static CartWrapper deleteOrderItems(String orderId ){    
        CartWrapper cartObj = new CartWrapper();    
        try{    
            delete[Select id from OrderLineItem__c where order__c=:orderId];  
            delete[Select id from Order__c where id=:orderId];
        }   
        catch(Exception ex){    
            System.debug('ErrLine-->'+ex.getMessage()); 
            cartObj.errorMessage = System.Label.Error_While_Deleting_Cart_Please_Contact_System_Administrator;  
            // ApexLog.exceptionHandler(ex, orderId, accountId);    
        }   
        return cartObj; 
    }
    
    
    
    
    
    
    @AuraEnabled   
    public static CartWrapper deleteSaleOrderItems(String sorderId ){   
        CartWrapper cartObj = new CartWrapper(); 
        try{
            delete[Select id from Sales_Order_Line_Item__c where Sale_Order__c  =:sorderId]; 
        }
        catch(Exception ex){
            cartObj.errorMessage = System.Label.Error_While_Deleting_Cart_Please_Contact_System_Administrator;  
        }
        return cartObj;  
    }
    
    
    
    
    
    @AuraEnabled     
    public static List<PriceDetail> getSkuData(String accId,Boolean isCommonPriceBook){    
        System.debug('accId '+accId);  
        System.debug('isCommonPriceBook '+isCommonPriceBook);  
        
        //Common Price book will be applicable for the Key Account managers and Wholesale Sales Manager. 
        //For Distributors while creating orders Customer Wise Price book will be applicable.
        
        //two type of Price Book Common and Customer
        List<PriceDetail> priceList = new List<PriceDetail>();
        List<PriceBookMaster__c> pbmList =new List<PriceBookMaster__c>(); 
        //Added for the CR-APPS-2521-Start
        set<String> parentSKUCodes =new set<String>();
        
       List<Poland_Dependent_SKU_Code__mdt> PD_Skus = [SELECT Id,Main_SKU_Code__c,Sub_SKU_Codes__c FROM Poland_Dependent_SKU_Code__mdt];
        
        for(Poland_Dependent_SKU_Code__mdt skuInfo:PD_Skus){
            parentSKUCodes.add(skuInfo.Main_SKU_Code__c);
        }
        //Added for the CR-APPS-2521-Start
        if(isCommonPriceBook){
            //this is for Common Price Book Master 
            System.debug('Inside Common Price Book Master');
            
            //Added for the CR-APPS-2521-Added PAK__c in the query 
            pbmList =  [SELECT Id, SKUCode__r.Distribution_Channel__c,SKUCode__r.Division__c,Director_Price__c,Manager_Price__c,SKUCode__r.Payment_Term__c,SKUCode__c,SKUCode__r.Logistic_Discount__c,SKUCode__r.Truck_Quantity__c,Division__c,SKUCode__r.Multiple_Of__c,SKUCode__r.Name,     
                        SKUCode__r.SKU_Code__c,SKUCode__r.Pack_Size__c, MinPrice__c,DistributorCustomerCode__c, 
                        DepotCode__c, DepotCode__r.Location__c,SKUCode__r.UOM__c,SKUCode__r.Area_Manager_MSP__c,    
                        SKUCode__r.Sales_Director_MSP__c, Price__c, PG_CODE__c, PG_CODE__r.Name,SKUCode__r.Product_Category__c,SKUCode__r.Sales_Agent_MSP__c,   
                        UOM__c, SKUCode__r.Product_Name__r.Name, SKUCode__r.Unit_Cost__c,SKUCode__r.pallet_Size_Italy__c,   
                        SKUCode__r.Product_Name__c, CurrencyIsoCode,SKUCode__r.Brand_Name__c,
                        SKUCode__r.Inventory_order_Flag_Color_Italy__c,SKUCode__r.Inventory_Description_Italy__c,SKUCode__r.Inventory_order_Flag_Italy__c,PAK__c,  
                        SKUCode__r.Product_Name__r.Popular__c, SKUCode__r.Division__r.Division_Code__c,SKUCode__r.SKU_Description__c,Final_Price__c,SKUCode__r.Distribution_Channel__r.Distribution_Channel_Code__c 
                        FROM PriceBookMaster__c                        
                        WHERE DepotCode__r.Location__c ='PD01'
                        AND SKUCode__r.Distribution_Channel__r.Distribution_Channel_Code__c = '20'
                        AND DistributorCustomerCode__c = null
                        AND (SKUCode__r.Division__r.Division_Code__c = '10' OR SKUCode__r.Division__r.Division_Code__c = '60') 
                        AND SKUCode__r.Sales_Org__r.sales_org_code__c ='2941'
                        AND StartDate__c <= TODAY AND EndDate__c >= TODAY AND SKUCode__r.Active__c = True   
                        ORDER BY SKUCode__r.Brand_Name__c ASC, SKUCode__r.SKU_Code__c DESC, StartDate__c ASC,LastModifiedDate ASC ]; 
            
            
            
        }else{
            //this is for Customer Wise Price Book Master
            System.debug('Inside Custmer wise Price Book Master');
            //if(accId != null){
            //Added for the CR-APPS-2521-Added PAK__c in the query    
            pbmList =  [SELECT Id,SKUCode__r.Distribution_Channel__r.Distribution_Channel_Code__c,SKUCode__r.Division__r.Division_Code__c,SKUCode__r.Distribution_Channel__c,SKUCode__r.Division__c,SKUCode__c,SKUCode__r.Truck_Quantity__c,SKUCode__r.Payment_Term__c,SKUCode__r.Logistic_Discount__c,Division__c,SKUCode__r.Multiple_Of__c,SKUCode__r.Name,     
                        SKUCode__r.SKU_Code__c,SKUCode__r.Pack_Size__c, MinPrice__c,DistributorCustomerCode__c, 
                        DepotCode__c, DepotCode__r.Location__c,SKUCode__r.UOM__c,SKUCode__r.Area_Manager_MSP__c,    
                        SKUCode__r.Sales_Director_MSP__c, Price__c, PG_CODE__c, PG_CODE__r.Name,SKUCode__r.Product_Category__c,SKUCode__r.Sales_Agent_MSP__c,   
                        UOM__c, SKUCode__r.Product_Name__r.Name, SKUCode__r.Unit_Cost__c,SKUCode__r.pallet_Size_Italy__c,   
                        SKUCode__r.Product_Name__c, CurrencyIsoCode,SKUCode__r.Brand_Name__c,SKUCode__r.Active_ingredient_Italy__c,
                        SKUCode__r.Product_Name__r.Popular__c, SKUCode__r.SKU_Description__c,Final_Price__c,PAK__c
                        FROM PriceBookMaster__c 
                        WHERE DistributorCustomerCode__c =: accId
                        AND DepotCode__r.Location__c ='PD01'
                        AND SKUCode__r.Distribution_Channel__r.Distribution_Channel_Code__c='20'
                        AND (SKUCode__r.Division__r.Division_Code__c = '10' OR SKUCode__r.Division__r.Division_Code__c = '60')
                        AND SKUCode__r.Sales_Org__r.sales_org_code__c ='2941'   
                        AND StartDate__c <= TODAY AND EndDate__c >= TODAY AND SKUCode__r.Active__c = True   
                        ORDER BY SKUCode__r.Brand_Name__c ASC, SKUCode__r.SKU_Code__c DESC, StartDate__c ASC,LastModifiedDate ASC ]; 
          // } 
        }
        System.debug('pbmList after adding Division and Distribution Channel '+pbmList);
        System.debug('pbmList after adding Division and Distribution Channel size '+pbmList.size());
        
        
        
        if(pbmList.size()>0){
            for(PriceBookMaster__c pbObj :pbmList){
                PriceDetail pb = new PriceDetail();
                pb.skuId = pbObj.SKUCode__c;
                pb.skuCategory = pbObj.SKUCode__r.Product_Category__c;
                pb.basePrice = pbObj.Price__c;
                pb.basePriceOg  = pbObj.Price__c;
                System.debug('in getting sku PMBLIST pbObj.SKUCode__r.SKU_Description__c '+pbObj.SKUCode__r.SKU_Description__c);
                pb.productName = pbObj.SKUCode__r.SKU_Description__c;
                pb.UOM = pbObj.SKUCode__r.UOM__c;
                System.debug('pbObj.SKUCode__r.Multiple_Of__c '+pbObj.SKUCode__r.Multiple_Of__c);
                pb.multipleOf=pbObj.SKUCode__r.Multiple_Of__c;
                
                pb.palletSize=pbObj.SKUCode__r.pallet_Size_Italy__c;
                System.debug('pbObj.SKUCode__r.Truck_Quantity__c; '+pbObj.SKUCode__r.Truck_Quantity__c);
                pb.truckSize = pbObj.SKUCode__r.Truck_Quantity__c;
                pb.logisticDiscount = pbObj.SKUCode__r.Logistic_Discount__c;
                
                pb.divisionId = pbObj.SKUCode__r.Division__c;
                pb.distributionChannelId = pbObj.SKUCode__r.Distribution_Channel__c;
                
                
                pb.skuDescription = pbObj.SKUCode__r.SKU_Description__c;
                System.debug('fisrt pbObj.SKUCode__r.Payment_Term__c '+pbObj.SKUCode__r.Payment_Term__c);
                
                pb.PaymentTermId = pbObj.SKUCode__r.Payment_Term__c;
                pb.skuCode = pbObj.SKUCode__r.SKU_Code__c;  
                //Added for the CR-APPS-2521-Start
                if(parentSKUCodes != null && parentSKUCodes.contains(pbObj.SKUCode__r.SKU_Code__c)){
                    pb.isParent=true;
                }
                //Added for the CR-APPS-2521-Start
                pb.PAK = pbObj.PAK__c;
                priceList.add(pb);
            }
        }
        
        System.debug('priceList '+priceList);
        System.debug('priceList size '+priceList.size());
        return priceList;
        
    }
    
    
    
    
    @AuraEnabled     
    public static String getincotermCode(String incode){
        System.debug('incode in apex code '+incode);
        String icTrmCode ='';
        Inco_Term__c incObj = new Inco_Term__c();
        incObj = [Select Id,Name FROM Inco_Term__c WHERE Id=:incode];
        icTrmCode = incObj.Name;
        System.debug('icTrmCode in apex code return '+icTrmCode);
        return icTrmCode;    
    }
    
    @AuraEnabled     
    public static list<discountWrapper> getdiscount(){
        System.debug('getdiscount Apex controller');
        
        list<discountWrapper> discountList = new List<discountWrapper>();
        
        List<Early_Order_Discount__c> earlyOrderfieldMappings = Early_Order_Discount__c.getAll().values();
        List<Big_Volume_Discount__c> bigVolDiscountfieldMappings = Big_Volume_Discount__c.getAll().values();
        
        discountWrapper discountWrapperObj = new discountWrapper();
        System.debug('earlyOrderfieldMappings '+earlyOrderfieldMappings);
        
        for(Early_Order_Discount__c obj :earlyOrderfieldMappings){
            
            if(obj.Name=='Early Order Discount'){
                discountWrapperObj.earlyOrderDisName =obj.Name;
                discountWrapperObj.startDate =obj.Start_Date__c;
                discountWrapperObj.endDate =obj.End_Date__c;
                discountWrapperObj.discount =obj.Discount__c;
                discountList.add(discountWrapperObj);
            }
            
        }//end of for Loop
        discountWrapperobj.bigOrderDisName = bigVolDiscountfieldMappings[0].Name;
        discountWrapperobj.paletQtydis = bigVolDiscountfieldMappings[0].Discount_If_Qty_Eq_or_Gt_Pallet__c;
        discountWrapperobj.truckQtydis =  bigVolDiscountfieldMappings[0].Discount_If_Qty_Eq_or_Gt_Truck__c;
        discountList.add(discountWrapperobj);
        
        System.debug(' discountList '+ discountList);
        return discountList;
    }
    
    
    
    
    public static Map<String, Inco_Term__c> gettingIncoTermList(){
        Map<String, Inco_Term__c> incTermMap = new Map<String, Inco_Term__c>();
        List<Inco_Term__c> incoTermList = new List<Inco_Term__c>();
        incoTermList = [Select Id,Name,Sales_Org__r.Sales_Org_Code__c,IncoTerm_Desc__c FROM Inco_Term__c WHERE Sales_Org__r.Sales_Org_Code__c ='2941'];
        System.debug('incoTermList '+incoTermList);
        
        if(incoTermList.size()>0){
            for(Inco_Term__c incTrmObj :incoTermList){
                incTermMap.put(incTrmObj.Id,incTrmObj);
            }
        }
        System.debug('incTermMap in Loading '+incTermMap);
        return incTermMap;
    }
    
    //getting Payment Term List
    public static Map<String,Payment_Term__c> gettingPaymentTermList(){
        Map<String, Payment_Term__c> paytTermMap = new Map<String, Payment_Term__c>();
        List<Payment_Term__c> ptTrmList = new List<Payment_Term__c>();
        ptTrmList = [Select Id,Payterms_Desc__c From Payment_Term__c WHERE Sales_Org__r.Sales_Org_Code__c='2941' AND Active__c = true];
        System.debug('ptTrmList '+ptTrmList);
        System.debug('ptTrmList size '+ptTrmList.size());
        if(ptTrmList.size()>0){
            for(Payment_Term__c pObj:ptTrmList){
                paytTermMap.put(pObj.Id,pObj);
            }
        }
        
        return paytTermMap;
    }
    
    @AuraEnabled     
    public static Decimal gettingSKUInventories(String skuId){
        System.debug('in gettingSKUInventorie ');
        Decimal totalQty = 0;
        List<Sales_Order_Line_Item__c> solList = new List<Sales_Order_Line_Item__c>();
        solList = [Select Id,Name,SKU_Name__c,Quantity__c from Sales_Order_Line_Item__c 
                   WHERE SKU_Name__c=:skuId AND Sale_Order__r.Order_Status__c='Pending' 
                   AND Sale_Order__r.SalesOrgCode__c='2941'];
        
        for(Sales_Order_Line_Item__c obj:solList){
            totalQty =totalQty +obj.Quantity__c;
        }
        Decimal inventory = 0;
        
        List<Stock_Requirement__c> stList = new List<Stock_Requirement__c>();
        stList =[Select Id,Available_Stock__c,SKU__c From Stock_Requirement__c WHERE SKU__c=:skuId];
        if(stList.size()>0){
            if(stList[0].Available_Stock__c!=null){
                inventory = stList[0].Available_Stock__c-totalQty;    
            }else{
                inventory = totalQty;
            }
            
        }else{
            inventory = totalQty;
        }
        System.debug('solList totalQty '+inventory);
        return inventory;
    }
    
    
    
    public static Map<String, Payment_Method__c> gettingPaymentMethodList(){
        return null;
    }
    
    
    @AuraEnabled // SKI(Vishal P) : #CR152 : PO and Delivery Date : 29-09-2022...poDate added to method parameter...   
    public static OrderWrapper saveSalesOrder(Sales_Order__c soObj, String salesOrderItemString, String incoTermId,String forCloneOrders,Date poDate) {
        System.debug('Sales Order: '+soObj);
        System.debug('Sales Order:Id when Edit Order is Call '+soObj.Id);
        System.debug('Sales Order:Id when Edit Order is Call forCloneOrders '+forCloneOrders);
        OrderWrapper owObj = new OrderWrapper();
        List<SalesOrderItem> salesOrderItemList = (List<SalesOrderItem>)JSON.deserialize(SalesOrderItemString, List<SalesOrderItem>.class); 
        System.debug('salesOrderItemList at test : '+salesOrderItemList);
        String OrderLineId =salesOrderItemList[0].oliId;
        System.debug('OrderLineId '+OrderLineId);
        
        if(OrderLineId!=null && OrderLineId!=''){   
            if(!Test.isRunningTest()){
                Order__c orderObj = new Order__c();
                String orderId =[select Id,Order__c from OrderLineItem__c where Id =:OrderLineId Limit 1].Order__c; 
                system.debug('orderId'+orderId);    
                orderObj.id =orderId;   
                orderObj.Order_Status__c ='Approved';   
                update orderObj; 
            }
        }
        // SKI(Vishal P) : #CR152 : PO and Delivery Date : 29-09-2022...poDate parameter added...
        owObj.createdsalesOrderList = Poland_SalesOrder_Controller.saveOrderItems(soObj, salesOrderItemList,incoTermId,forCloneOrders,poDate);
        owObj.salesOrderName = Poland_SalesOrder_Controller.getSalesOrderNames(owObj.createdsalesOrderList);
        
        System.debug(' owObj.salesOrderName '+ owObj.salesOrderName);
        
        
        
        return owObj;
    }
    
    public static List<String> getSalesOrderNames(List<String> soids){
        List<Sales_Order__c> solIst = new List<Sales_Order__c>();
        List<String> solIstName = new List<String>();
        solIst = [Select Id,Name From Sales_Order__c WHERE Id IN:soids];
        System.debug('solIst '+solIst);
        System.debug('solIst '+solIst.size());
        if(solIst.size()>0){
            for(Sales_Order__c obj :solIst){
                solIstName.add(obj.Name);
            }
        }
        System.debug('solIstName '+solIstName);
        return solIstName;
    }
    
    
    //Reload existing Sales Order with given recordID  
    @AuraEnabled    
    public static Sales_Order__c getSalesOrder(ID soId) { 
        //Make sure to add new fields that are being input from the UI to this SOQL query otherwise the data will not be inserted.  
        // SKI(Vishal P) : #CR152 : PO and Delivery Date : 29-09-2022...Purchase_order_date__c field added to query...
        List<Sales_Order__c> soList = [SELECT Id, Name,Gross_Net_Value__c, SAP_Order_Number__c, Order_Status__c,Total_Amount__c,Order_Raise_By__c,PONumber__c,DirectApproved__c,   
                                       Sold_to_Party__r.Tax_Number_1__c,Ship_To_Party__r.City__c,Payment_Term__r.Payment_Term__c,Ship_To_Party__r.Name,    
                                       Sold_to_Party__r.Name, Sold_to_Party__c, ReloadPaymentTerms__c, OrderSubStatus__c,Ship_To_Party__r.Location_Name__c, 
                                       Sold_to_Party__r.Tax_Number_3__c, Depot_Code__c,Sent_for_Manager_Approval_Mexico__c,  
                                       Sold_to_Party__r.SAP_Code__c,Ship_To_Party__c,Remarks_Long__c,Check_Transport_contribution__c,    
                                       Sold_to_Party__r.Customer_Group__c,Sent_for_Latam_Director_Approval__c,Editable_Payment_Term_Discount__c,    
                                       Sold_to_Party__r.BillingCity,CreatedById, OwnerId, Owner.Name,CurrencyIsoCode,Sent_for_Director_Approval_Mexico__c,  
                                       Sold_to_Party__r.BillingState,Valid_From__c,Valid_To__c,
                                       Payment_Term__c, Sold_to_Party__r.Depot_Code__c,Normal_Delivery_Cost__c,Express_Delivery_Cost__c, 
                                       Sold_to_Party__r.Customer_Region__c,Net_Amount__c, 
                                       RecordType.Name, SalesOrgCode__c,Purchase_Order_Date__c,Sales_Order__r.Name,Parent_SAP_Order_Number__c      
                                       FROM Sales_Order__c  
                                       WHERE Id =: soId];
        System.debug('07102020219882 '+soList[0].Ship_To_Party__r.Name);
        
        return soList[0]; 
        
    }
    
    
    
    
    //Method to save Order Line Items from the wrapper against the Sales Order  
    @AuraEnabled    // SKI(Vishal P) : #CR152 : PO and Delivery Date : 29-09-2022...poDate added to method parameter...
    public static List<String> saveOrderItems(Sales_Order__c soObj, List<SalesOrderItem> salesOrderItemList,String incoterm,String forCloneOrders,Date poDate){ 
        System.debug('soObj saveOrderItems '+soObj);
        System.debug('Load salesOrderItemList '+salesOrderItemList);
        System.debug('salesOrderItemList size '+salesOrderItemList.size());
        List<Sales_Order__c> orderIds = new List<Sales_Order__c>();
        List<String> orIds = new List<String>();
        Map<String, Sales_Order__c> divisionSOMap = new Map<String, Sales_Order__c>();
        Map<String, Integer> itemNoMap = new Map<String, Integer>();
        Map<String,List<SalesOrderItem>> DivisionMap = new Map<String,List<SalesOrderItem>>();
        Map<String,String> DivisionMap1 = new Map<String,String>();
         String additionalDatails = '';  //Added by GRZ(Butesh) for RITM0515253 modified 13-03-2023
        additionalDatails = 'incoterm : '+incoterm+'\n forCloneOrders : '+forCloneOrders+'\n poDate : '+string.valueof(poDate);//Added by GRZ(Butesh) for RITM0515253 modified 13-03-2023
        Map<string,String> childParentMap=new Map<String,string>();
        childParentMap =UtilityClass.polandDependentSKU();
        Map<String, Integer> itemNoMapParentChild = new Map<String, Integer>();
        try{
            String div_Id = '';
            String sOrder_Id = '';
            Integer itemNo = 0;
            String depotId = '';
            String accId = '';
            Depot__c DepotObj = new Depot__c();
            Id depotRecordTypeId = Schema.SObjectType.Depot__c.getRecordTypeInfosByName().get('Depot').getRecordTypeId();
            DepotObj =[Select Id,Name,Depot_Code__c From Depot__c 
                       WHERE Depot_Code__c='PD01' 
                       AND SalesOrg__r.Sales_Org_Code__c='2941'
                       AND RecordTypeId=:depotRecordTypeId];
            depotId = DepotObj.Id;
            
            List<Sales_Order_Line_Item__c> soiList = new List<Sales_Order_Line_Item__c>();
            if(salesOrderItemList.size()>0){
                for(SalesOrderItem itemWrap : salesOrderItemList){
                    System.debug('itemWrap.PaymentTermId '+itemWrap.typeOfPayment);
                    
                    if(!DivisionMap.containsKey(itemWrap.divisionId+''+itemWrap.typeOfPayment)) {
                        DivisionMap.put(itemWrap.divisionId+''+itemWrap.typeOfPayment, new List<SalesOrderItem>{itemWrap});
                        DivisionMap1.put(itemWrap.divisionId+''+itemWrap.typeOfPayment,itemWrap.salesOrderId );
                        
                    }else{
                        DivisionMap.get(itemWrap.divisionId+''+itemWrap.typeOfPayment).add(itemWrap);
                    }
                }//end of for Loop  
                
                
                
                
                
                System.debug('Size of Map after adding Key Value Pair '+DivisionMap);
                System.debug('Size of Map after adding Key Value Pair size '+DivisionMap.size());
                
                System.debug('Size of Map after adding Key DivisionMap1 '+DivisionMap1);
                System.debug('Size of Map after adding Key DivisionMap1 '+DivisionMap1.size());
                
                
                
                
                List<Sales_Order_Line_Item__c> soItemList = new List<Sales_Order_Line_Item__c>();
                List<String> soItemListDelete = new List<String>();
                String tempSalesId;
                
                for(String div : DivisionMap.keySet()){
                    Sales_Order_Line_Item__c sliObj;
                    for(SalesOrderItem item : DivisionMap.get(div)){
                        if(item.salesOrderId!=null){
                            tempSalesId= item.salesOrderId;    
                        }
                        
                        
                        System.debug('One Reapeat');
                        Sales_Order__c tempSaleOrdrObj = new Sales_Order__c();
                        if(divisionSOMap.containsKey(item.divisionId+''+item.typeOfPayment)){
                            System.debug('inside create order');
                            tempSaleOrdrObj = new Sales_Order__c();
                            tempSaleOrdrObj = divisionSOMap.get(item.divisionId+''+item.typeOfPayment);
                        }else{
                            
                            tempSaleOrdrObj.Remarks_Long__c = soObj.Remarks_Long__c;
                            tempSaleOrdrObj.PONumber__c = soObj.PONumber__c;
                            System.debug('soObj.Ship_To_Party__c at sales Order exw '+soObj.Ship_To_Party__c);
                            String shipLoc = soObj.Ship_To_Party__c;
                            
                            System.debug('soObj Id in insert '+soObj);
                            String distributorType='';
                            Account accObj = new Account();
                            Id profileId= userinfo.getProfileId();
                            String userid = UserInfo.getUserId();
                            System.debug('userid '+userid);
                            String profileName1 = [Select Id,Name from Profile where Id=:profileId].Name;
                            system.debug('ProfileName community '+profileName1);
                            if(profileName1 == 'Customer Community Plus User - Poland - 1' || profileName1=='Customer Community Plus User - Poland - 2' || profileName1=='Customer Partner Community Plus User - Poland - 1'|| profileName1 == 'Customer Partner Community Plus User - Poland - 2'){
                                User userObj = [SELECT Id,UserName, AccountId FROM User WHERE Id=: userid];
                                accId = userObj.AccountId;  
                                //System.debug('inside Customer Community Plus User ');
                            }else{
                                //System.debug('inside Customer Community Plus User ');
                                accId = soObj.Sold_to_Party__c;    
                            }
                            
                            if(shipLoc!=''){
                                tempSaleOrdrObj.Ship_To_Party__c = soObj.Ship_To_Party__c;    
                            }else{
                                String accuntId = accId;
                                System.debug('when shipping Location is Empty accuntId '+accuntId);
                                
                                Account acc = [Select Id,SAP_Code__c from Account WHERE Id=:accuntId];
                                System.debug('when shipping Location is Empty  '+acc.SAP_Code__c);
                                System.debug('when shipping Location is Empty  '+acc.Id);
                                Shipping_Location__c shipLocObj = [Select Id,SAP_Code__c,Distributor__c 
                                                                   From Shipping_Location__c
                                                                   WHERE SAP_Code__c=:acc.SAP_Code__c AND Distributor__c=:acc.Id];
                                
                                tempSaleOrdrObj.Ship_To_Party__c = shipLocObj.Id;                                
                            }
                            System.debug('tempSaleOrdrObj.Ship_To_Party__c '+tempSaleOrdrObj.Ship_To_Party__c);
                            
                            
                            
                            
                            System.debug('AccId while Community User Place Order '+accId);
                            accObj =[Select Id,Name,SAP_Code__c, Distributor_Type_Poland__c From Account WHERE Id=:accId];
                            distributorType = accObj.Distributor_Type_Poland__c;
                            String SAPCodeAccount = accObj.SAP_Code__c;
                            
                            String ProfileName = '';    
                            String LoggedInUser ='';
                            
                            
                            String ownerId = tempSaleOrdrObj.OwnerId; 
                            if(String.isBlank(ownerId) || ownerId=='None'){ 
                                // tempSaleOrdrObj.OwnerId = UserInfo.getUserId();   
                            }
                            LoggedInUser = UserInfo.getUserId(); 
                            User userObj =   [Select Id, Profile.Name,ManagerId, Show_List_Value__c,Show_Min_Price__c,Show_Max_Price__c,Show_Floor_Price__c, 
                                              IsActive, ContactId,UserRole.name,Show_Inventory__c, Show_Credit_Limit__c, EnableDepot__c,   
                                              Show_Inventory_Column__c,Sales_Director__c,RegionalManager__c,Show_InTransit__c, Show_InTransit_Values__c,HO__c, Country_Head__c, 
                                              Marketing_Manager__c   
                                              FROM User  
                                              WHERE Id =:LoggedInUser    
                                              AND IsActive = True]; 
                            
                            System.debug('userObj.Profile.Name '+userObj.Profile.Name);
                            System.debug('distributorType '+distributorType);
                            
                            
                            //Modified By Nandhini
                            if(userObj!=null && (userObj.Profile.Name=='Poland(wholesale sales Manager)'||userObj.Profile.Name=='Poland(Non Crop Product & Retail Sales Manager)') && distributorType=='Regular Customer'){
                                if(userObj.Profile.Name=='Poland(wholesale sales Manager)'){
                                    tempSaleOrdrObj.Order_Raise_By__c ='Wholesale Sales Manager';     
                                }
                               if(userObj.Profile.Name=='Poland(Non Crop Product & Retail Sales Manager)'){
                                    tempSaleOrdrObj.Order_Raise_By__c ='Non Crop Product & Retail Sales Manager';     
                                }
                                
                                tempSaleOrdrObj.Manager__c = userObj.ManagerId;
                                System.debug('soObj.Sold_to_Party__c While Wholeesale Manager '+soObj.Sold_to_Party__c);
                                
                                //SKI(Paresh S) : Field IsPartner Added : CR#157 & CR#159...
                                Account acobj = [Select Id,Name,IsCustomerPortal,IsPartner,Need_Community_Approval__c FROM Account WHERE Id=:soObj.Sold_to_Party__c];
                                System.debug('Outside Portal ');
                                
                                //SKI(Paresh S) : Condition IsPartner==true Added : CR#157 & CR#159...
                                if(acobj.IsCustomerPortal==true || acobj.IsPartner==true || Test.isRunningTest()){
                                    System.debug('Inside Portal ');
                                    tempSaleOrdrObj.IsCustomerPortal__c = true;
                                    tempSaleOrdrObj.Need_Community_Approval__c = acobj.Need_Community_Approval__c;
                                    tempSaleOrdrObj.Sent_for_Director_Approval_Mexico__c = true;
                                    tempSaleOrdrObj.Sent_for_Manager_Approval_Mexico__c =true;
                                    List<Contact> conList = new List<Contact>();
                                    // SKI(Paresh S) : Filter Is_Community__c=true Added : CR#157 & CR#159...                                     
                                    conList = [Select Id From Contact Where AccountId =:soObj.Sold_to_Party__c and Is_Community__c=true];
                                    List<String> contIds = new List<String>();
                                    for(Contact con:conList){
                                        contIds.add(con.Id);
                                    }
                                    System.debug('contIds '+contIds);
                                    List<User> usrLIst = new List<User>();
                                    // SKI(Paresh S) : Filter IsActive=true Added : CR#157 & CR#159...
                                    usrLIst = [Select Id,ContactId from User 
                                               WHERE ContactId IN:contIds and IsActive=true];
                                    
                                    System.debug('usrLIst '+usrLIst);
                                    System.debug('usrLIst size '+usrLIst.size());
                                                                       
                                    if(usrLIst.size()>0){
                                        if(usrLIst.size()==1){
                                            
                                            tempSaleOrdrObj.Sales_Director_Mexico__c = usrLIst[0].Id;    
                                            
                                        }
                                        if(usrLIst.size()==2){
                                            tempSaleOrdrObj.Sales_Director_Mexico__c = usrLIst[0].Id; 
                                            tempSaleOrdrObj.Latam_Director_Mexico__c = usrLIst[1].Id;
                                            
                                        }
                                        
                                        if(usrLIst.size()==3){
                                            tempSaleOrdrObj.Sales_Director_Mexico__c = usrLIst[0].Id; 
                                            tempSaleOrdrObj.Latam_Director_Mexico__c = usrLIst[1].Id;
                                            tempSaleOrdrObj.RegionalManager__c = usrLIst[2].Id;
                                            
                                        }
                                        
                                        if(usrLIst.size()==4){
                                            tempSaleOrdrObj.Sales_Director_Mexico__c = usrLIst[0].Id; 
                                            tempSaleOrdrObj.Latam_Director_Mexico__c = usrLIst[1].Id;
                                            tempSaleOrdrObj.RegionalManager__c = usrLIst[2].Id;
                                            tempSaleOrdrObj.REH__c = usrLIst[3].Id;
                                            
                                        }
                                        // SKI(Paresh S) : Condition changed : CR#157 & CR#159...
                                        if(usrLIst.size()>=5){
                                            tempSaleOrdrObj.Sales_Director_Mexico__c = usrLIst[0].Id; 
                                            tempSaleOrdrObj.Latam_Director_Mexico__c = usrLIst[1].Id;
                                            tempSaleOrdrObj.RegionalManager__c = usrLIst[2].Id;
                                            tempSaleOrdrObj.REH__c = usrLIst[3].Id;
                                            tempSaleOrdrObj.TerritoryManager__c = usrLIst[4].Id;
                                            
                                        }
                                        
                                    }
                                    
                                    String conId ='';
                                    //SKI(Paresh S) : Filter Is_Community__c=true Added : CR#157 & CR#159...
                                    conId = [SELECT ID,AccountId FROM Contact WHERE AccountId=:accId AND Is_Community__c=true LIMIT 1].Id;
                                    User userObj1 = new User();
                                    userObj1 =[Select id,ContactId FROM User WHERE ContactId=:conId LIMIT 1];
                                    tempSaleOrdrObj.OwnerId = userObj1.Id;
                                }else{
                                    System.debug('in else Part ');
                                    tempSaleOrdrObj.IsCustomerPortal__c = false;
                                    tempSaleOrdrObj.Sent_for_Manager_Approval_Mexico__c =true; 
                                    tempSaleOrdrObj.Sent_for_Director_Approval_Mexico__c = false;
                                    
                                }
                                
                                tempSaleOrdrObj.Distributor_Type_Poland__c = 'Regular Customer';
                                
                                Account acObj1 = new Account();
                                acObj1 = [Select Id,OwnerId,TM_UGDN_Number__c from Account WHERE Id=:soObj.Sold_to_Party__c];
                                
                                
                            }else if(userObj!=null && (((userObj.Profile.Name=='Poland(wholesale sales Manager)'||userObj.Profile.Name=='Poland(Non Crop Product & Retail Sales Manager)') && distributorType=='Non Regular Customer')) /*&& distributorType=='Non Regular Customer'*/){ //RITM0212523: Sayan, 28th May, 2021, 19:02IST                                
                                
                                if(userObj.Profile.Name=='Poland(wholesale sales Manager)'){
                                    tempSaleOrdrObj.Order_Raise_By__c ='Wholesale Sales Manager';     
                                }
                                if(userObj.Profile.Name=='Poland(Non Crop Product & Retail Sales Manager)'){
                                    tempSaleOrdrObj.Order_Raise_By__c ='Non Crop Product & Retail Sales Manager';     
                                }
                                
                                
                                tempSaleOrdrObj.Sent_for_Manager_Approval_Mexico__c = true;
                                tempSaleOrdrObj.Distributor_Type_Poland__c = 'Non Regular Customer';
                                tempSaleOrdrObj.Manager__c = userObj.ManagerId;
                                tempSaleOrdrObj.OwnerId = UserInfo.getUserId();
                                
                                
                            }else if(userObj!=null && userObj.Profile.Name=='Poland(Key Account Manager)' && distributorType=='Regular Customer'){
                                tempSaleOrdrObj.Order_Raise_By__c ='Key Account Manager'; 
                                tempSaleOrdrObj.Manager__c = userObj.ManagerId;
                                
                                //SKI(Paresh S) : Field IsPartner Added : CR#157 & CR#159...
                                Account acobjTe = [Select Id,Name,IsCustomerPortal,IsPartner,Need_Community_Approval__c FROM Account WHERE Id=:soObj.Sold_to_Party__c];
                                
                                //SKI(Paresh S) : Condition IsPartner==true Added : CR#157 & CR#159...
                                if(acobjTe.IsCustomerPortal==true || acobjTe.IsPartner==true){
                                    tempSaleOrdrObj.IsCustomerPortal__c = true; 
                                    tempSaleOrdrObj.Need_Community_Approval__c= acobjTe.Need_Community_Approval__c;
                                    tempSaleOrdrObj.Sent_for_Manager_Approval_Mexico__c =true; 
                                    tempSaleOrdrObj.Sent_for_Director_Approval_Mexico__c = true;
                                    List<Contact> conList1 = new List<Contact>();
                                    // SKI(Paresh S) : Filter Is_Community__c=true Added : CR#157 & CR#159....
                                    conList1 = [Select Id From Contact Where AccountId =:soObj.Sold_to_Party__c and Is_Community__c=true];
                                    List<String> contIds1 = new List<String>();
                                    for(Contact con:conList1){
                                        contIds1.add(con.Id);
                                    }
                                    System.debug('contIds1 '+contIds1);
                                    List<User> usrLIst1 = new List<User>();
                                    // SKI(Paresh S) : Filter IsActive=true Added : CR#157 & CR#159....
                                    usrLIst1 = [Select Id,ContactId from User 
                                                WHERE ContactId IN:contIds1 and IsActive=true ];
                                    
                                    if(usrLIst1.size()>0){
                                        if(usrLIst1.size()==1){
                                            
                                            tempSaleOrdrObj.Sales_Director_Mexico__c = usrLIst1[0].Id;    
                                            
                                        }
                                        
                                        
                                        if(usrLIst1.size()==2){
                                            
                                            tempSaleOrdrObj.Sales_Director_Mexico__c = usrLIst1[0].Id;    
                                            tempSaleOrdrObj.Latam_Director_Mexico__c = usrLIst1[1].Id;
                                            
                                        }
                                        
                                        if(usrLIst1.size()==3){
                                            
                                            tempSaleOrdrObj.Sales_Director_Mexico__c = usrLIst1[0].Id;    
                                            tempSaleOrdrObj.Latam_Director_Mexico__c = usrLIst1[1].Id;
                                            tempSaleOrdrObj.RegionalManager__c = usrLIst1[2].Id;
                                            
                                        }
                                        
                                        
                                        if(usrLIst1.size()==4){
                                            
                                            tempSaleOrdrObj.Sales_Director_Mexico__c = usrLIst1[0].Id;    
                                            tempSaleOrdrObj.Latam_Director_Mexico__c = usrLIst1[1].Id;
                                            tempSaleOrdrObj.RegionalManager__c = usrLIst1[2].Id;
                                            tempSaleOrdrObj.REH__c = usrLIst1[3].Id;
                                            
                                        }
                                        
                                        // SKI(Paresh S) : Condition changed : CR#157 & CR#159...
                                        if(usrLIst1.size()>=5){
                                            
                                            tempSaleOrdrObj.Sales_Director_Mexico__c = usrLIst1[0].Id;    
                                            tempSaleOrdrObj.Latam_Director_Mexico__c = usrLIst1[1].Id;
                                            tempSaleOrdrObj.RegionalManager__c = usrLIst1[2].Id;
                                            tempSaleOrdrObj.REH__c = usrLIst1[3].Id;
                                            tempSaleOrdrObj.TerritoryManager__c = usrLIst1[4].Id;
                                            
                                        }
                                        
                                        
                                        
                                    }
                                    
                                    
                                    String conId ='';
                                    conId = [SELECT ID,AccountId FROM Contact WHERE AccountId=:accId AND Is_Community__c=true LIMIT 1].Id;
                                    User userObj1 = new User();
                                    userObj1 =[Select id,ContactId FROM User WHERE ContactId=:conId LIMIT 1];
                                    tempSaleOrdrObj.OwnerId = userObj1.Id;
                                    
                                }else{
                                    tempSaleOrdrObj.IsCustomerPortal__c = false;
                                    tempSaleOrdrObj.Sent_for_Manager_Approval_Mexico__c =true; 
                                    tempSaleOrdrObj.Sent_for_Director_Approval_Mexico__c = false;
                                }
                                
                                
                                
                                tempSaleOrdrObj.Distributor_Type_Poland__c = 'Regular Customer';
                                
                                
                                Account acObj1 = new Account();
                                acObj1 = [Select Id,OwnerId,TM_UGDN_Number__c from Account WHERE Id=:soObj.Sold_to_Party__c];
                                
                                // tempSaleOrdrObj.UGDN__c = acObj1.TM_UGDN_Number__c;
                                
                            }else if(userObj!=null && userObj.Profile.Name=='Poland(Key Account Manager)' && distributorType=='Non Regular Customer'){
                                tempSaleOrdrObj.Order_Raise_By__c ='Key Account Manager'; 
                                tempSaleOrdrObj.Sent_for_Manager_Approval_Mexico__c = true;
                                tempSaleOrdrObj.Distributor_Type_Poland__c = 'Non Regular Customer';
                                tempSaleOrdrObj.Manager__c = userObj.ManagerId;
                                tempSaleOrdrObj.OwnerId = UserInfo.getUserId();
                                
                            } else if(userObj!=null && (userObj.Profile.Name=='Customer Community Plus User - Poland - 1' || userObj.Profile.Name=='Customer Community Plus User - Poland - 2' || userObj.Profile.Name=='Customer Partner Community Plus User - Poland - 1' || userObj.Profile.Name=='Customer Partner Community Plus User - Poland - 2')){
                                tempSaleOrdrObj.Order_Raise_By__c ='Regular Distributor'; 
                                tempSaleOrdrObj.Sent_for_Manager_Approval_Mexico__c = true;
                                Account acObj = new Account();
                                acObj = [Select Id, OwnerId,TM_UGDN_Number__c,SAP_Customer_Code__c  From Account Where Id=:accId];
                               
                                User us =[Select id ,Name From User where Name ='Tomasz Stadnikiewicz' limit 1]; 
                                if(acObj.SAP_Customer_Code__c==label.PolandSpecificCustomer){
                                 tempSaleOrdrObj.Sales_Director_Mexico__c = us.id;                        //Updated for RITM0531740	  GRZ(Dheeraj Sharma) 04-03-2023
                                }else{
                                    tempSaleOrdrObj.Sales_Director_Mexico__c = acObj.OwnerId; 
                                }
                               
                                tempSaleOrdrObj.OwnerId = UserInfo.getUserId(); 
                                
                                
                            }
                            
                            
                            List<Sales_Org__c> salesOrgList = [Select ID FROM Sales_Org__c  
                                                               WHERE Sales_Org_Code__c = '2941'     
                                                               LIMIT 1]; 
                            
                            if(!salesOrgList.isEmpty()){    
                                tempSaleOrdrObj.Sales_Org_lk__c = salesOrgList[0].Id; 
                            }
                            tempSaleOrdrObj.Order_Type_lk__c = [Select Id,SalesOrg__c FROM Order_Type__c WHERE Order_Type_Code__c='ZZOD' limit 1].Id;
                            tempSaleOrdrObj.CurrencyIsoCode = 'PLN';
                            tempSaleOrdrObj.Order_Date__c = System.today();  
                            tempSaleOrdrObj.CreatedFrom__c = 'SFDC'; 
                            tempSaleOrdrObj.Inco_Term__c = incoterm; 
                            tempSaleOrdrObj.Sold_to_Party__c = accId;
                            
                            tempSaleOrdrObj.Bill_To_Party__c = accId;
                            
                            
                            tempSaleOrdrObj.Payment_Term__c = item.typeOfPayment;// payment Term
                            tempSaleOrdrObj.Division_lk__c   = item.divisionId; // Division Code
                            tempSaleOrdrObj.Distribution_Channel_lk__c = item.distributionChannelId; // Distribution Channel
                            String tmpIdSales;
                            if(DivisionMap1.containsKey(div)){
                                System.debug('Inside first');
                                tmpIdSales = DivisionMap1.get(div);
                                System.debug('tmpIdSales '+tmpIdSales);
                                if(item.salesOrderId==null && tmpIdSales== null){
                                    System.debug('Inside fifth');
                                    
                                    insert tempSaleOrdrObj;
                                }else{
                                    if(tmpIdSales == item.salesOrderId && tmpIdSales!=''){
                                        System.debug('Inside second for clone order 2 ');
                                        if(forCloneOrders=='cloneOrder'){
                                            insert tempSaleOrdrObj; 
                                        }else{
                                            tempSaleOrdrObj.Id = tmpIdSales;                                        
                                        update tempSaleOrdrObj;        
                                        }
                                        
                                    }else{
                                        System.debug('Inside third');
                                        System.debug('Inside second for clone order 3 ');
                                        insert tempSaleOrdrObj;
                                    }
                                }
                                
                            }else{
                                System.debug('Inside fourth');
                                System.debug('Inside second for clone order 4 ');
                                insert tempSaleOrdrObj;
                            }
                            
                            orIds.add(tempSaleOrdrObj.Id);
                            divisionSOMap.put(item.divisionId+''+item.typeOfPayment,tempSaleOrdrObj);
                            
                            
                        }
                        if(itemNoMap.containsKey(tempSaleOrdrObj.Id)){
                            itemNo = itemNoMap.get(tempSaleOrdrObj.Id);
                        }
                        else{
                            itemNo = 0;
                        }
                        sliObj = new Sales_Order_Line_Item__c();
                        
                        itemNo = itemNo +10;
                        sliObj.Item_Number__c = itemNo;
                        if(item.PAK == null || item.PAK ==false){//item number changes
                            itemNoMap.put(tempSaleOrdrObj.Id,itemNo);
                        }
                        
                        System.debug('itemNoMap '+itemNoMap);
                        //Item Number changes-APPS 2521
                        if(item.isParent){
                            itemNoMapParentChild.put(item.skuCode,itemNo);
                        }
                        if(childParentMap.containsKey(item.skuCode) && item.PAK == true){
                            string parentSku=childParentMap.get(item.skuCode);
                            if(itemNoMapParentChild.containsKey(parentSku)){
                                Integer childItemNumber=itemNoMapParentChild.get(parentSku)+1;
                                sliObj.Item_Number__c =childItemNumber;
                                itemNoMapParentChild.put(parentSku,childItemNumber);
                            }
                            
                        }
                        //Item Number changes-APPS 2521-end
                        if(tempSaleOrdrObj.Id!=null){
                            sliObj.Sale_Order__c = tempSaleOrdrObj.Id;    
                        }else{
                            sliObj.Sale_Order__c = soObj.Id;
                        } 
                        
                        System.debug('item.skuId '+item.skuId);
                        sliObj.SKU_Name__c = item.skuId;
                        sliObj.UOM__c = item.UOM;
                        sliObj.Quantity__c = item.qty;
                        sliObj.Price__c = item.basePrice;
                        sliObj.Base_Price_OG__c = item.basePriceOg;
                        //Added by Nandhini-APPS-2521
                        if(item.isParent){
                            sliObj.Item_Category__c='parent';
                            sliObj.Manual_Discount__c=0;
                            sliObj.Early_Order_Discount__c = 0;
                            sliObj.Big_Volume_Discount__c = 0;
                            sliObj.Logistic_Discount__c = 0;
                            sliObj.Logistic_Discount_Value__c = 0;
                            
                        } else{
                            sliObj.Manual_Discount__c = item.manualDiscount;
                            sliObj.Early_Order_Discount__c = item.earlyOrderDiscount;
                            sliObj.Big_Volume_Discount__c = item.bigVolDiscount;
                            sliObj.Logistic_Discount__c = item.logisticDiscount;
                            sliObj.Logistic_Discount_Value__c = item.logisticDiscountValue;
                        }
                        
                       
                        sliObj.Payment_Term__c = item.typeOfPayment;
                        sliObj.CurrencyIsoCode = 'PLN';
                        
                        
                       
                        System.debug('skuCombinationKey in save function '+item.skuCombinationKey);
                            
                        sliObj.Distribution_Channel__c = item.distributionChannelId;
                        sliObj.Division__c = item.divisionId;
                        sliObj.pallet_Size_Italy__c = item.palletSize;  
                        sliObj.multipleOf__c =item.multipleOf;
                        
                        sliObj.Delivery_Date__c = item.customerDeliveryDate; // SKI(Vishal P) : #CR152 : PO and Delivery Date : 29-09-2022...
                        
                        sliObj.DepotDepot__c = depotId; 
                        
                        System.debug('item.inventory '+item.inventory);
                        sliObj.Inventory__c = item.inventory;
                        
                        
                        sliObj.Net_Price__c =item.basePrice; 
                        sliObj.Unit_Price__c = item.finalPrice;
                        sliObj.FinalPrice__c = item.netValue;
                        
                        System.debug('item.soliId  '+item.soliId);
                        System.debug('Inside second for clone order 5 '+item.soliId);
                        if(item.soliId!=''){
                            System.debug('Inside second for clone order 6 ');
                            if(forCloneOrders=='cloneOrder'){
                                
                            }else{
                                sliObj.Id = item.soliId;  
                            }
                               
                        }
                        
                        soiList.add(sliObj);
                        
                    }//end of inner for Loop
                    
                }//end of for Loop
                
                                
                System.debug('soiList '+soiList);
                System.debug('soiList size placing Order  '+soiList.size());
                if(soiList.size()>0){
                   
                    List<Sales_order__c> sListTemp = new List<Sales_order__c>();
                    List<Sales_order__c> sListTempUpdate = new List<Sales_order__c>();
                    System.debug('orIds saa'+orIds);
                    sListTemp =[Select Id,Order_Status__c FROM Sales_Order__c WHERE Id IN:orIds];
                    System.debug('sListTemp '+sListTemp);
                    if(sListTemp.size()>0){
                        Sales_order__c tmpObj;
                        for(Sales_order__c ob :sListTemp ){
                            tmpObj = new Sales_Order__c();
                            System.debug('ob.Id '+ob.Id);
                            tmpObj.Id = ob.Id;
                            tmpObj.Order_Status__c = 'Pending';  
                            tmpObj.Purchase_Order_Date__c = poDate;  // SKI(Vishal P) : #CR152 : PO and Delivery Date : 29-09-2022...
                            sListTempUpdate.add(tmpObj);
                        }
                        System.debug('sListTempUpdate '+sListTempUpdate);
                        System.debug('sListTempUpdate size '+sListTempUpdate.size());
                        upsert soiList;
                        upsert sListTempUpdate;
                    }
                }
                
                
            }//end of size check condition
			 ApexLog.exceptionHandlerPoland(null, accId, soObj, string.valueOf(salesOrderItemList),additionalDatails); //Added by GRZ(Butesh) for RITM0515253 modified 13-03-2023
        }//end of Try block
        
        catch(Exception Ex){  //Added by GRZ(Butesh) for RITM0515253 modified 13-03-2023
            System.debug('Error Occured Line Number '+ex.getLineNumber());
            System.debug('Error Occured Message '+ex.getMessage());
            String accId = '';
            Id profileId= userinfo.getProfileId();
            String userid = UserInfo.getUserId();
            String profileName1 = [Select Id,Name from Profile where Id=:profileId].Name;
            system.debug('ProfileName community '+profileName1);
            if(profileName1 == 'Customer Community Plus User - Poland - 1' || profileName1=='Customer Community Plus User - Poland - 2' || profileName1=='Customer Partner Community Plus User - Poland - 1'|| profileName1 == 'Customer Partner Community Plus User - Poland - 2'){
                User userObj = [SELECT Id,UserName, AccountId FROM User WHERE Id=: userid];
                accId = userObj.AccountId;  
                //System.debug('inside Customer Community Plus User ');
            }else{
                //System.debug('inside Customer Community Plus User ');
                accId = soObj.Sold_to_Party__c;    
            }
            ApexLog.exceptionHandlerPoland(ex, accId, soObj, string.valueOf(salesOrderItemList),additionalDatails);
        }//end of Catch
        
        
        return orIds;
        
    }//end of Function
    
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
        oAttachment.ParentId = parentId;
        
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
    
    
    
    @AuraEnabled   
    public static void clubbingSKUs(String orderList) { 
        List<SalesOrderItem> salesOrderList = (List<SalesOrderItem>)JSON.deserialize(orderList, List<SalesOrderItem>.class); 
        System.debug('salesOrderList '+salesOrderList);
        System.debug('salesOrderList size in clubbing '+salesOrderList.size());
        
    }
    
    
    
    @AuraEnabled   
    public static Sales_Order__c getSalesSTP(ID soId) { 
        
        List<Sales_Order__c> soList = [SELECT Id,Sold_to_Party__c,Inco_Term__c,Ship_To_Party__c,
                                       Order_Raise_By__c,Division_lk__r.Division_Code__c   
                                       FROM Sales_Order__c  
                                       WHERE Id =: soId];  
        System.debug('soList  after fetching solist  '+soList);
        System.debug('soList  after fetching solist size  '+soList.size());
        if(soList.size()>0){
            return soList[0]; 
        }else{
            System.debug('In null section');
            return null;  
        }
        
    }  
    
    
    //Reload existing Sales Order Line Items with given Sales Order ID     
    @AuraEnabled    
    public static List<SalesOrderItem> getSalesOrderItems(ID soId, String cloneOrders,String filter) { 
        
        // SKI(Vishal P) : #CR152 : PO and Delivery Date : 29-09-2022...Delivery_Date__c field added to query...
        List<Sales_Order_Line_Item__c> salesOrderItemList = [SELECT Id,Delivery_Date__c,Sale_Order__r.Sold_to_Party__c,SKU_Name__r.Combination_Key__c,SKU_Name__r.Big_Volume_for_Truck__c,SKU_Name__r.Big_Volume_for_Pallet__c,SKU_Name__r.Truck_Quantity__c,Logistic_Discount_Value__c,Base_Price_OG__c,Inventory__c, Sale_Order__c, SKU_Name__c,Apply_Rebate__c,multipleOf__c, Discount__c,MinPrice__c,MinValue__c,UOM__c,
                                                             Transport_contribution2__c,SKU_Name__r.Multiple_of__c,SKU_Name__r.Logistic_Discount__c,SKU_Name__r.pallet_Size_Italy__c, SKU_Name__r.SKU_Description__c,Item_Number__c,Quantity__c,Price__c,FinalPrice__c,
                                                             pallet_Size_Italy__c,Transport_contribution__c, CurrencyIsoCode, Sales_Org__c,Net_Price__c,FinalPrice2__c,Rebate__c,
                                                             Net_Invoice_Price__c,UnitValue__c,Product_Type_Italy__c,Unit_Price__c,Rebate_2__c,Shipping_Date__c,Average_Final_Price__c,
                                                             Inventory_order_Flag_Color_Italy__c,Payment_Term__c,Distribution_Channel__c,Division__c,Inventory_Description_Italy__c,Comment__c,Accrual_Discount__c, 
                                                             SKU_Name__r.Name,Manual_Discount__c,Big_Volume_Discount__c,Early_Order_Discount__c,Logistic_Discount__c   
                                                             FROM Sales_Order_Line_Item__c  
                                                             WHERE Sale_Order__c=:soId Order By CreatedDate];
        
        Set<String> skuIds = new Set<String>();
        for(Sales_Order_Line_Item__c tempSoiObj: salesOrderItemList){ 
            skuIds.add(tempSoiObj.SKU_Name__c);
        }  
        
        String skuId = '(';
        for(String str:skuIds){
            skuId+= '\''+str+'\',';
        }
        skuId +=')';
        
       // integer length = skuId.length();
        
        skuId = skuId.replace(',)', ')');
        System.debug('skuId in clone item '+skuId);
        
        
         List<PriceBookMaster__c> pbmList =new List<PriceBookMaster__c>();
        
        String query = 'Select Id,Name,SKUCode__c,Price__c FROM PriceBookMaster__c where SKUCode__c IN '+skuId+' '+filter ;
        System.debug('query in getting line item for clone '+query);
        
         pbmList = Database.query(query);
        
        System.debug('pbmList in clone '+pbmList);
        System.debug('pbmList in clone '+pbmList.size());
        MAP<String,Decimal> mapPriceBook = New MAP<String,Decimal>();
        
        
        for(PriceBookMaster__c pbmObj:pbmList){
            mapPriceBook.put(pbmObj.SKUCode__c,pbmObj.Price__c);
        }
        
        System.debug('mapPriceBook '+mapPriceBook);
        System.debug('mapPriceBook '+mapPriceBook.size());
            
        
        
        
        List<SalesOrderItem> itemList = new List<SalesOrderItem>(); 
        System.debug('salesOrderItemList'+salesOrderItemList);  
        
        for(Sales_Order_Line_Item__c soiObj: salesOrderItemList){  
            SalesOrderItem item = new SalesOrderItem(); 
            item.productId = soiObj.SKU_Name__c;
            item.productName = soiObj.SKU_Name__r.SKU_Description__c;             
            item.UOM = soiObj.UOM__c;
            item.soliId = soiObj.Id;
            item.salesOrderId = soiObj.Sale_Order__c;
            item.skuId = soiObj.SKU_Name__c;
            item.inventory = soiObj.Inventory__c;
            item.divisionId = soiObj.Division__c;
            item.customerDeliveryDate = soiObj.Delivery_Date__c; //SKI(Vishal P) : #CR152 : PO and Delivery Date : 29-09-2022...
            item.distributionChannelId = soiObj.Distribution_Channel__c;
           
            item.skuCombinationKey = soiObj.SKU_Name__r.Combination_Key__c;
            
            
           // item.logisticDiscountValue = soiObj.Logistic_Discount_Value__c;
           item.logisticDiscountValue = soiObj.SKU_Name__r.Logistic_Discount__c;
            //SKU_Name__r.Multiple_of__c
            
            item.basePriceOg = soiObj.Base_Price_OG__c;
            
            item.itemNo = soiObj.Item_Number__c;    
            item.multipleOf = soiObj.SKU_Name__r.Multiple_of__c; 
            //item.multipleOf = soiObj.multipleOf__c; 
            
            item.palletSize = soiObj.SKU_Name__r.pallet_Size_Italy__c;  
            //item.palletSize = soiObj.pallet_Size_Italy__c;  
            
            item.typeOfPayment = soiObj.Payment_Term__c;
            
            
            
            if(cloneOrders=='cloneOrder'){
                System.debug('inside clone Order ');
                System.debug('new Price for clone order '+mapPriceBook.get(soiObj.SKU_Name__c));
                System.debug('new Price for clone order '+mapPriceBook.get(soiObj.SKU_Name__c));
                item.basePrice = mapPriceBook.get(soiObj.SKU_Name__c);//soiObj.Net_Price__c;
                if(soiObj.Net_Price__c==mapPriceBook.get(soiObj.SKU_Name__c)){
                    //item.qty = soiObj.Quantity__c;
                     item.qty = 0.0;
                }else{
                    item.qty = 0.0;
                }
                item.truckSize = soiObj.SKU_Name__r.Truck_Quantity__c;
                item.Big_Volume_for_Pallet = soiObj.SKU_Name__r.Big_Volume_for_Pallet__c;
                item.Big_Volume_for_Truck = soiObj.SKU_Name__r.Big_Volume_for_Truck__c;
                item.earlyOrderDiscount = 0.0;
                item.bigVolDiscount = 0.0;
                item.manualDiscount = 0.0;
                item.logisticDiscount = 0.0;
                item.finalPrice=0.0;
                item.netValue=0.0;
                item.accountId = soiObj.Sale_Order__r.Sold_to_Party__c;
               
                
                
            }else{
                System.debug('not inside clone Order ');
                item.basePrice=soiObj.Net_Price__c;
                item.qty = soiObj.Quantity__c;
                item.earlyOrderDiscount = soiObj.Early_Order_Discount__c;
                item.bigVolDiscount = soiObj.Big_Volume_Discount__c;
                item.manualDiscount = soiObj.Manual_Discount__c;
                item.logisticDiscount = soiObj.Logistic_Discount__c;
                item.finalPrice=soiObj.Unit_Price__c;
                item.netValue=soiObj.FinalPrice__c;
                item.accountId = '';
            }
            
            
            
            
            
           /* item.earlyOrderDiscount = soiObj.Early_Order_Discount__c;
            item.bigVolDiscount = soiObj.Big_Volume_Discount__c;
            item.manualDiscount = soiObj.Manual_Discount__c;
            item.logisticDiscount = soiObj.Logistic_Discount__c;*/
            
            
            
            itemList.add(item);
        }
        System.debug('itemList: '+itemList);    
        return itemList;
    }
    
    
    
    
    @AuraEnabled
    public static String getfileNames(String soId){
        String fName='';
        List<Attachment> attList = new List<Attachment>();
        attList= [Select id,ParentId, Name From Attachment
                  WHERE ParentId=:soId LIMIT 1];
        if(attList.size()>0){
            fName = attList[0].Name;
        }else{
            fName ='';
        }
        
        return fName;
        
    }
    
    @AuraEnabled
    public static List<OrderTemplate__c> showOrderTemplates(String accId){
        System.debug('Accid in Getting Loading Template '+accId);
        List<OrderTemplate__c>  templist = new List<OrderTemplate__c>();
        templist =[SELECT Id, Name,CurrencyIsoCode,Payment_Method__c,DistributorCustomerCode__c FROM OrderTemplate__c
                   WHERE DistributorCustomerCode__c=:accId];
        return templist;
    }
    
    
    @AuraEnabled    
    public static CartWrapper deleteOItem(List<String> oliId,String orderId,String itemsLength){
        
        CartWrapper cartObj = new CartWrapper();    
        //Added for the CR-APPS-2521 
        try{   
            List<OrderLineItem__c> orderLineItemList =  [Select id from OrderLineItem__c where id IN:oliId];
            System.debug('orderLineItemList => '+orderLineItemList);
            if(orderLineItemList?.size()>0){
                delete orderLineItemList;
            }
            //delete[Select id from OrderLineItem__c where id=:oliId];
            if(itemsLength=='0'){
                delete[Select id from Order__c where id=:orderId]; 
            }
        }   
        catch(Exception ex){    
            System.debug('ErrLine-->'+ex.getMessage()); 
            cartObj.errorMessage = System.Label.Error_While_Deleting_Item_Please_Contact_System_Administrator;  
            // ApexLog.exceptionHandler(ex, orderId, accountId);    
        }  
        return cartObj; 
    }  
    
    @AuraEnabled    
    public static void deleteSalesOrderLineItem(String salesOLId){
        System.debug('salesOLId Apex controller '+salesOLId);
        try{
            delete [Select Id,Name From Sales_Order_Line_Item__c WHERE Id=:salesOLId];
        }
        catch(Exception ex){
            System.debug('Error Occure Line Number '+ex.getLineNumber());
            System.debug('Error Occure Line Number '+ex.getMessage());
        }
        
        
    }
    
    
    
    
    @AuraEnabled    
    public static CartWrapper getCartOrderItems(ID accId) { 
        Order__c ordObj =new Order__c();
        String orderId =''; 
        Boolean isChange = false;    
        
        CartWrapper cartObj = new CartWrapper();
        System.debug('accId is '+accId);
        
        List<Order__c> recentOrderList =  [SELECT Id, Name, Bill_To_Party__c, Order_Date__c,Inco_Term__c,Gross_Net_Value__c,   
                                           Order_Status__c, OwnerId,Gross_Net__c    
                                           FROM Order__c WHERE Order_Status__c='Draft'  
                                           AND Bill_To_Party__c =: accId Order By CreatedDate DESC LIMIT 1];
        if(!recentOrderList.isEmpty()){ 
            ordObj = recentOrderList[0];
            system.debug('@@@@@@ at Loading CArt ordObj '+ordObj);
            orderId = ordObj.Id;  
            System.debug('in Loading of Order Previously recentOrderList[0].Gross_Net__c '+recentOrderList[0].Gross_Net__c);
            cartObj.grossNetPrice = recentOrderList[0].Gross_Net_Value__c;
            cartObj.incoTerm = recentOrderList[0].Inco_Term__c;
            
        }
         //Added for the CR-APPS-2521-Added fields in the query
        // SKI(Vishal P) : #CR152 : PO and Delivery Date : 29-09-2022...Delivery_Date__c field added to query....
        List<OrderLineItem__c> oliList = [SELECT Id,Delivery_Date__c,PAK__c,Big_Volume_for_Pallet__c,Big_Volume_for_Truck_c__c,Logistic_Discount_Value__c,Base_Price_OG__c,Truck_Quantity__c,Inventory__c,SKU_Name__r.Payment_Term__c,Unit_Price__c, Name,Early_Order_Discount__c,Big_Volume_Discount__c,CurrencyIsoCode, SKU_Name__r.SKU_Description__c,
                                          Discount__c,multipleOf__c, Distribution_Channel__c,Division__c,Order__c, UOM__c, SKU_Name__c,Net_Price__c,FinalPrice__c,pallet_Size_Italy__c, SKU_Name__r.SKU_Code__c,
                                          SKU_Name__r.Name,SKU_Name__r.Combination_Key__c ,Quantity__c, Price__c,Manual_Discount__c,   
                                          FinalPrice2__c,Discount2__c,isParent__c,Average_Final_Price__c,Logistic_Discount__c,
                                          Comment__c,Payment_Term_Poland__c     
                                          FROM OrderLineItem__c 
                                          WHERE Order__c=:orderId Order By CreatedDate];
        
        List<SalesOrderItem> itemList = new List<SalesOrderItem>();
        system.debug('oliList: '+oliList);
        for(OrderLineItem__c oliObj: oliList){ 
            SalesOrderItem item = new SalesOrderItem(); 
            item.productId = oliObj.SKU_Name__c;
            System.debug('oliObj.SKU_Name__c while loading cart  '+oliObj.SKU_Name__c);
            item.skuId = oliObj.SKU_Name__c;
            System.debug('oliObj.SKU_Name__r.SKU_Description__c '+oliObj.SKU_Name__r.SKU_Description__c);
            item.oliId = oliObj.Id;
            item.productName = oliObj.SKU_Name__r.SKU_Description__c;
            item.skuDescription = oliObj.SKU_Name__r.SKU_Description__c;
            item.typeOfPayment = oliObj.SKU_Name__r.Payment_Term__c;
            item.UOM = oliObj.UOM__c;
            item.skuCombinationKey = oliObj.SKU_Name__r.Combination_Key__c;
            item.Big_Volume_for_Truck = oliObj.Big_Volume_for_Truck_c__c;
            item.Big_Volume_for_Pallet = oliObj.Big_Volume_for_Pallet__c;
            item.customerDeliveryDate = oliObj.Delivery_Date__c;            //SKI(Vishal P) : #CR152 : PO and Delivery Date : 29-09-2022..
            item.skuCode = oliObj.SKU_Name__r.SKU_Code__c;
             //Added for the CR-APPS-2521 -start
            item.PAK = oliObj.PAK__c;
            item.isParent=oliObj.isParent__c;
             //Added for the CR-APPS-2521 -ENd
            item.basePrice = oliObj.Price__c;
            item.basePriceOg = oliObj.Base_Price_OG__c;
            item.qty = oliObj.Quantity__c;
            item.multipleOf = oliObj.multipleOf__c;
            item.palletSize = oliObj.pallet_Size_Italy__c;
            item.earlyOrderDiscount = oliObj.Early_Order_Discount__c;
            item.bigVolDiscount = oliObj.Big_Volume_Discount__c;
            item.manualDiscount = oliObj.Manual_Discount__c;
            item.logisticDiscount = oliObj.Logistic_Discount__c;
            System.debug('oliObj.Logistic_Discount_Value__c '+oliObj.Logistic_Discount_Value__c);
            
            item.logisticDiscountValue = oliObj.Logistic_Discount_Value__c;
            
            
            item.truckSize = oliObj.Truck_Quantity__c;
            
            item.typeOfPayment = oliObj.Payment_Term_Poland__c;
            item.divisionId = oliObj.Division__c;
            item.distributionChannelId = oliObj.Distribution_Channel__c;
            
            //item.inventory = oliObj.;
            item.finalPrice = oliObj.Unit_Price__c;
            
            item.basePrice = oliObj.Net_Price__c;
            item.netValue = oliObj.FinalPrice__c;
            item.inventory = oliObj.Inventory__c;  
            
            itemList.add(item); 
        }
        system.debug('itemList'+itemList);   
        cartObj.cartOrderId =orderId;   
        cartObj.soiList = itemList; 
        
        System.debug('cartObj in apex Code '+cartObj);
        return cartObj;
        
    }
    
    @auraEnabled
    public static void saveTemplate(String accId,String lineItem,String templateName, String incoTerm){
        System.debug('In save Template Function '+accId);
        System.debug('In save Template Function '+lineItem);
        System.debug('In save Template Function '+templateName);
        System.debug('In save Template Function '+incoTerm);
        
        OrderTemplate__c otObj = new OrderTemplate__c();
        otObj.DistributorCustomerCode__c = accId;
        otObj.Inco_Term__c = incoTerm;
        otObj.Name = templateName;
        otObj.CurrencyIsoCode = 'PLN';
        insert otObj;
        System.debug('otObj Id '+otObj.Id);
        
        
        List<SalesOrderItem> salesOrderItemList = (List<SalesOrderItem>)JSON.deserialize(lineItem, List<SalesOrderItem>.class); 
        
        System.debug('salesOrderItemList '+salesOrderItemList);
        if(salesOrderItemList.size()>0){
            //must add currencyisocode in line item
            List<OrderTemplateItem__c> OrderTemplateItemList = new List<OrderTemplateItem__c>();
            for(SalesOrderItem salesOrderItemobj :salesOrderItemList){
                OrderTemplateItem__c otiObj = new OrderTemplateItem__c();
                otiObj.OrderTemplate__c = otObj.Id;
                otiObj.SKU__c =  salesOrderItemobj.skuId;
                otiObj.multipleOf__c =  salesOrderItemobj.multipleOf;
                otiObj.Pallet_Size__c =  salesOrderItemobj.palletSize;
                otiObj.UOM__c =  salesOrderItemobj.UOM;
                otiObj.Logistic_Discount__c = salesOrderItemobj.logisticDiscountValue;
                otiObj.Payment_Term__c = salesOrderItemobj.typeOfPayment;
                otiObj.Base_Price__c = salesOrderItemobj.basePrice;
                otiObj.CurrencyIsoCode = 'PLN';
                
                otiObj.Division__c = salesOrderItemobj.divisionId;
                otiObj.Distribution_Channel__c = salesOrderItemobj.distributionChannelId;
                
                System.debug('while saving Order template salesOrderItemobj.earlyOrderDiscount '+salesOrderItemobj.earlyOrderDiscount);
                otiObj.Early_Order_Discount__c = salesOrderItemobj.earlyOrderDiscount;
                
                
                
                OrderTemplateItemList.add(otiObj);
            }
            if(OrderTemplateItemList.size()>0){
                insert OrderTemplateItemList;
            }
        }
        
    }
    
    
    @AuraEnabled
    public static String getDistributorTypePolands(String accountIdTemp){
        System.debug('accountIdTemp '+accountIdTemp);
        String customerType='';
        Account accObj  = [Select Id, Name,Distributor_Type_Poland__c From Account WHERE Id=:accountIdTemp LIMIT 1];
        customerType = accObj.Distributor_Type_Poland__c;
        return customerType; 
        
        
    }
    
    
    @AuraEnabled
    public static CartWrapper getEntity(String templateId){
        System.debug('templateId '+templateId);
        CartWrapper cartObj = new CartWrapper();
        
        System.debug('loadOrderTemplate '+templateId);
        OrderTemplate__c  OrderTemplateObj = new OrderTemplate__c();
        OrderTemplateObj = [SELECT Id,Name,Inco_Term__c 
                            FROM OrderTemplate__c
                            WHERE Id=:templateId];
        
        cartObj.incoTerm = OrderTemplateObj.Inco_Term__c;
        
        List<OrderTemplateItem__c> orderTempList = New List<OrderTemplateItem__c>();
        orderTempList = [SELECT Id, OrderTemplate__c,SKU__c,multipleOf__c,SKU__r.SKU_Description__c,
                         Pallet_Size__c,UOM__c,Logistic_Discount__c,Payment_Term__c,Division__c,Distribution_Channel__c,
                         Base_Price__c,CurrencyIsoCode,SKU__r.Truck_Quantity__c,SKU__r.Big_Volume_for_Pallet__c,SKU__r.Big_Volume_for_Truck__c,
                         Early_Order_Discount__c
                         FROM OrderTemplateItem__c
                         WHERE OrderTemplate__c=:templateId];
        List<SalesOrderItem> itemList = new List<SalesOrderItem>();
        if(orderTempList.size()>0){
            SalesOrderItem item;
            for(OrderTemplateItem__c oliObj :orderTempList){
                item = new SalesOrderItem(); 
                item.productId = oliObj.SKU__c;
                item.skuId = oliObj.SKU__c;
                item.productName = oliObj.SKU__r.SKU_Description__c;
                item.skuDescription = oliObj.SKU__r.SKU_Description__c;
                item.typeOfPayment = oliObj.Payment_Term__c;
                item.UOM = oliObj.UOM__c;
                item.basePrice = oliObj.Base_Price__c;
                item.basePriceOg = oliObj.Base_Price__c;
                item.multipleOf = oliObj.multipleOf__c;
                item.palletSize = oliObj.Pallet_Size__c;
                item.logisticDiscount = oliObj.Logistic_Discount__c;
                item.logisticDiscountValue = oliObj.Logistic_Discount__c;
                item.divisionId = oliObj.Division__c;
                item.distributionChannelId = oliObj.Distribution_Channel__c;
                
                item.Big_Volume_for_Truck = oliObj.SKU__r.Big_Volume_for_Truck__c;
                item.Big_Volume_for_Pallet = oliObj.SKU__r.Big_Volume_for_Pallet__c;
                item.truckSize = oliObj.SKU__r.Truck_Quantity__c;
                item.earlyOrderDiscount = oliObj.Early_Order_Discount__c;
                
                
                itemList.add(item); 
            }//end of for Loop
            //cartObj.cartOrderId =orderId; 
            cartObj.soiList = itemList; 
            
        }
        System.debug(' cartObj '+cartObj);
        return cartObj;
    }
    
    
     @AuraEnabled
    public static CartWrapper getEntityAll(String templateId){
        System.debug('templateId '+templateId);
        CartWrapper cartObj = new CartWrapper();
        
        System.debug('loadOrderTemplate '+templateId);
        OrderTemplate__c  OrderTemplateObj = new OrderTemplate__c();
        OrderTemplateObj = [SELECT Id,Name,Inco_Term__c 
                            FROM OrderTemplate__c
                            WHERE Id=:templateId];
        
        cartObj.incoTerm = OrderTemplateObj.Inco_Term__c;  
        
        List<OrderTemplateItem__c> orderTempList = New List<OrderTemplateItem__c>();
        orderTempList = [SELECT Id, OrderTemplate__c,SKU__c,multipleOf__c,SKU__r.SKU_Description__c,
                         Pallet_Size__c,UOM__c,Logistic_Discount__c,Payment_Term__c,Division__c,Distribution_Channel__c,
                         Base_Price__c,CurrencyIsoCode,SKU__r.Truck_Quantity__c,SKU__r.Big_Volume_for_Pallet__c,SKU__r.Big_Volume_for_Truck__c,
                         Early_Order_Discount__c
                         FROM OrderTemplateItem__c
                         WHERE OrderTemplate__c=:templateId];
        List<SalesOrderItem> itemList = new List<SalesOrderItem>();
        if(orderTempList.size()>0){
            SalesOrderItem item;
            for(OrderTemplateItem__c oliObj :orderTempList){
                item = new SalesOrderItem(); 
                item.productId = oliObj.SKU__c;
                item.skuId = oliObj.SKU__c;
                item.productName = oliObj.SKU__r.SKU_Description__c;
                item.skuDescription = oliObj.SKU__r.SKU_Description__c;
                item.typeOfPayment = oliObj.Payment_Term__c;
                item.UOM = oliObj.UOM__c;
                item.basePrice = oliObj.Base_Price__c;
                item.basePriceOg = oliObj.Base_Price__c;
                item.multipleOf = oliObj.multipleOf__c;
                item.palletSize = oliObj.Pallet_Size__c;
                item.logisticDiscount = oliObj.Logistic_Discount__c;
                item.logisticDiscountValue = oliObj.Logistic_Discount__c;
                item.divisionId = oliObj.Division__c;
                item.distributionChannelId = oliObj.Distribution_Channel__c;
                
                item.Big_Volume_for_Truck = oliObj.SKU__r.Big_Volume_for_Truck__c;
                item.Big_Volume_for_Pallet = oliObj.SKU__r.Big_Volume_for_Pallet__c;
                item.truckSize = oliObj.SKU__r.Truck_Quantity__c;
                item.earlyOrderDiscount = oliObj.Early_Order_Discount__c;
                
                
                itemList.add(item); 
            }//end of for Loop
            //cartObj.cartOrderId =orderId; 
            cartObj.soiList = itemList; 
            
        }
        System.debug(' cartObj '+cartObj);
        return cartObj;
    }
    
    //added for #CR143
    
    @AuraEnabled
    public static PriceBookMaster__c gettingPriceBookPrices(String combinationKey, String customerId){
        System.debug('combinationKey in price '+combinationKey);
        PriceBookMaster__c priceBookMasterObj = new PriceBookMaster__c();
         //Added for the CR-APPS-2521 -Added fields in the Query
        priceBookMasterObj =[Select Id,Price__c,SKUCode__r.SKU_Code__c 
                             FROM PriceBookMaster__c
                             WHERE SKUCombinationKey__c=:combinationKey
                             AND DistributorCustomerCode__c=:customerId                           
                             AND StartDate__c <= TODAY AND EndDate__c >= TODAY
                             ORDER BY SKUCode__r.Brand_Name__c ASC, SKUCode__r.SKU_Code__c DESC, StartDate__c ASC,LastModifiedDate ASC LIMIT 1];
        
       // System.debug('priceBookMasterObj getting price '+priceBookMasterObj);
        
        return priceBookMasterObj;
    }
    
    
    
    @AuraEnabled
    public static ZSP1_Discount__c gettingBigVolDiscounts(String combinationKeys){
        System.debug('combinationKeys big vol disc '+combinationKeys);
        ZSP1_Discount__c ZSP1Obj = new ZSP1_Discount__c();
        ZSP1Obj = [Select Id,Name,Discount__c,Second_Discount__c,StartDate__c,EndDate__c,
                   SKUCode__c,Sales_Org__c,SKUCombinationkey__c,Active__c
                   FROM ZSP1_Discount__c
                   WHERE SKUCombinationkey__c=:combinationKeys
                   ORDER BY  LastModifiedDate DESC LIMIT 1]; 
                   
        System.debug('ZSP1Obj '+ZSP1Obj);
        return ZSP1Obj;
    }
    
    
     @AuraEnabled
    public static SpecialInvoiceDiscount__c gettingEarlyOrderDiscounts(String combinationKeys){
        System.debug('combinationKeys ingetting '+combinationKeys);
        SpecialInvoiceDiscount__c SIDObj = new SpecialInvoiceDiscount__c();
         //Added for the CR-APPS-2521 -Added fields in the Query
        SIDObj = [Select Id,Name,Discount__c,StartDate__c,SKUCode__r.SKU_Description__c,EndDate__c,SKUCombinationkey__c,Active__c 
                  FROM SpecialInvoiceDiscount__c
                  WHERE SKUCombinationkey__c=: combinationKeys
                  ORDER BY  LastModifiedDate DESC LIMIT 1];
        System.debug('SIDObj in early order Discount  '+SIDObj);
            
        return SIDObj;
    }
    
    
    @AuraEnabled
    public static PriceBook_Indonesia_Discount__c gettingManualDisc(String combinationKeys,String accId){
        //System.debug('in gettoing manual discount combinationKeys '+combinationKeys);
        //System.debug('in gettoing manual discount accId '+accId);
        PriceBook_Indonesia_Discount__c pIndDis = new PriceBook_Indonesia_Discount__c();
        pIndDis =[SELECT Id, Name,DistributorCustomerCode__c,Payment_Term__c,New_Composite_key__c,Manual_Discount__c
                 FROM PriceBook_Indonesia_Discount__c
                 WHERE DistributorCustomerCode__c=:accId
                 AND New_Composite_key__c=:combinationKeys ORDER BY LastModifiedDate DESC LIMIT 1];
        return pIndDis;
        
        
    }
    
    
     @AuraEnabled
    public static CartWrapper getEntity1(String templateId){
        System.debug('templateId '+templateId);
        CartWrapper cartObj = new CartWrapper();
        
        System.debug('loadOrderTemplate '+templateId);
        OrderTemplate__c  OrderTemplateObj = new OrderTemplate__c();
        OrderTemplateObj = [SELECT Id,Name,Inco_Term__c 
                            FROM OrderTemplate__c
                            WHERE Id=:templateId];
        
        cartObj.incoTerm = OrderTemplateObj.Inco_Term__c;  
        
        List<OrderTemplateItem__c> orderTempList = New List<OrderTemplateItem__c>();
        orderTempList = [SELECT Id, OrderTemplate__c,SKU__c,multipleOf__c,SKU__r.SKU_Description__c,
                         Pallet_Size__c,UOM__c,Logistic_Discount__c,Payment_Term__c,Division__c,Distribution_Channel__c,
                         Base_Price__c,CurrencyIsoCode,SKU__r.Truck_Quantity__c,SKU__r.Big_Volume_for_Pallet__c,SKU__r.Big_Volume_for_Truck__c,
                         Early_Order_Discount__c
                         FROM OrderTemplateItem__c
                         WHERE OrderTemplate__c=:templateId];
        List<SalesOrderItem> itemList = new List<SalesOrderItem>();
        if(orderTempList.size()>0){
            SalesOrderItem item;
            for(OrderTemplateItem__c oliObj :orderTempList){
                item = new SalesOrderItem(); 
                item.productId = oliObj.SKU__c;
                item.skuId = oliObj.SKU__c;
                item.productName = oliObj.SKU__r.SKU_Description__c;
                item.skuDescription = oliObj.SKU__r.SKU_Description__c;
                item.typeOfPayment = oliObj.Payment_Term__c;
                item.UOM = oliObj.UOM__c;
                item.basePrice = oliObj.Base_Price__c;
                item.basePriceOg = oliObj.Base_Price__c;
                item.multipleOf = oliObj.multipleOf__c;
                item.palletSize = oliObj.Pallet_Size__c;
                item.logisticDiscount = oliObj.Logistic_Discount__c;
                item.logisticDiscountValue = oliObj.Logistic_Discount__c;
                item.divisionId = oliObj.Division__c;
                item.distributionChannelId = oliObj.Distribution_Channel__c;
                
                item.Big_Volume_for_Truck = oliObj.SKU__r.Big_Volume_for_Truck__c;
                item.Big_Volume_for_Pallet = oliObj.SKU__r.Big_Volume_for_Pallet__c;
                item.truckSize = oliObj.SKU__r.Truck_Quantity__c;
                item.earlyOrderDiscount = oliObj.Early_Order_Discount__c;
                
                
                itemList.add(item); 
            }//end of for Loop
            //cartObj.cartOrderId =orderId; 
            cartObj.soiList = itemList; 
            
        }
        System.debug(' cartObj '+cartObj);
        return cartObj;
    }
    
    
     @AuraEnabled
    public static CartWrapper getDetailsTemp(String templateId){
        System.debug('templateId '+templateId);
        CartWrapper cartObj = new CartWrapper();
        
        System.debug('loadOrderTemplate '+templateId);
        OrderTemplate__c  OrderTemplateObj = new OrderTemplate__c();
        OrderTemplateObj = [SELECT Id,Name,Inco_Term__c 
                            FROM OrderTemplate__c
                            WHERE Id=:templateId];
        
        cartObj.incoTerm = OrderTemplateObj.Inco_Term__c;  
        
        List<OrderTemplateItem__c> orderTempList = New List<OrderTemplateItem__c>();
        orderTempList = [SELECT Id, OrderTemplate__c,SKU__c,multipleOf__c,SKU__r.SKU_Description__c,
                         Pallet_Size__c,UOM__c,Logistic_Discount__c,Payment_Term__c,Division__c,Distribution_Channel__c,
                         Base_Price__c,CurrencyIsoCode,SKU__r.Truck_Quantity__c,SKU__r.Big_Volume_for_Pallet__c,SKU__r.Big_Volume_for_Truck__c,
                         Early_Order_Discount__c
                         FROM OrderTemplateItem__c
                         WHERE OrderTemplate__c=:templateId];
        List<SalesOrderItem> itemList = new List<SalesOrderItem>();
        if(orderTempList.size()>0){
            SalesOrderItem item;
            for(OrderTemplateItem__c oliObj :orderTempList){
                item = new SalesOrderItem(); 
                item.productId = oliObj.SKU__c;
                item.skuId = oliObj.SKU__c;
                item.productName = oliObj.SKU__r.SKU_Description__c;
                item.skuDescription = oliObj.SKU__r.SKU_Description__c;
                item.typeOfPayment = oliObj.Payment_Term__c;
                item.UOM = oliObj.UOM__c;
                item.basePrice = oliObj.Base_Price__c;
                item.basePriceOg = oliObj.Base_Price__c;
                item.multipleOf = oliObj.multipleOf__c;
                item.palletSize = oliObj.Pallet_Size__c;
                item.logisticDiscount = oliObj.Logistic_Discount__c;
                item.logisticDiscountValue = oliObj.Logistic_Discount__c;
                item.divisionId = oliObj.Division__c;
                item.distributionChannelId = oliObj.Distribution_Channel__c;
                
                item.Big_Volume_for_Truck = oliObj.SKU__r.Big_Volume_for_Truck__c;
                item.Big_Volume_for_Pallet = oliObj.SKU__r.Big_Volume_for_Pallet__c;
                item.truckSize = oliObj.SKU__r.Truck_Quantity__c;
                item.earlyOrderDiscount = oliObj.Early_Order_Discount__c;
                
                
                itemList.add(item); 
            }//end of for Loop
            //cartObj.cartOrderId =orderId; 
            cartObj.soiList = itemList; 
            
        }
        System.debug(' cartObj '+cartObj);
        return cartObj;
    }
    
     
    
    //patch for Paresh
   // this method id callimg from View Order Summary, this is used in Community Portal 
   
    @AuraEnabled (cacheable = true)
    public static List<OrderWrapperView> viewOrderSummary(String recordId){
        System.debug('In paresh class recordId '+recordId);
        List<OrderWrapperView> orderViewList = new List<OrderWrapperView>();
        Sales_Order__c salesOrderObj = new Sales_Order__c();
        String accId ='';
        //SKI(Paresh S) : #CR152 : PO and Delivery Date : 29-09-2022...field Purchase_Order_Date__c added...
        salesOrderObj = [Select Id,Name,CreatedFrom__c,Total_Amount__c,Remarks_Long__c,Inco_Term__c,Inco_Term__r.IncoTerm_Desc__c,SAP_Order_Number__c,Gross_Net_Value__c,
                         PONumber__c,Inco_Term_Code__c,Sold_to_Party__c,Ship_To_Party__c,Purchase_Order_Date__c,
                         Ship_To_Party__r.Location_Name__c,
                         Ship_To_Party__r.Billing_Street_1__c,
                         Ship_To_Party__r.Billing_Street_2__c,
                         Ship_To_Party__r.Billing_Street_3__c,
                         Ship_To_Party__r.Billing_Street_4__c,
                         Ship_To_Party__r.Billing_Street_5__c,
                         Ship_To_Party__r.Billing_Street_6__c,
                         Ship_To_Party__r.City__c,
                         Ship_To_Party__r.Pincode__c,
                         Ship_To_Party__r.State__c,
                         Ship_To_Party__r.Region__c,
                         Ship_To_Party__r.Country__c
                         FROM Sales_Order__c WHERE Id=:recordId];
        
        System.debug('salesOrderObj in community '+salesOrderObj);
        
            
        
        OrderWrapperView OrderWrapperObj = new OrderWrapperView();
        OrderWrapperObj.soObj= salesOrderObj;
        //SKI(Paresh S) : #CR152 : PO and Delivery Date : 29-09-2022...field Delivery_Date__c added...
        List<Sales_Order_Line_Item__c> solItemList = [SELECT Id,Payment_Term__r.Payterms_Desc__c,Logistic_Discount_Value__c,Base_Price_OG__c,Inventory__c, Sale_Order__c, SKU_Name__c,Apply_Rebate__c,multipleOf__c, Discount__c,MinPrice__c,MinValue__c,UOM__c,
                                                      Transport_contribution2__c, SKU_Name__r.SKU_Description__c,Item_Number__c,Quantity__c,Price__c,FinalPrice__c,
                                                      pallet_Size_Italy__c,Transport_contribution__c, CurrencyIsoCode, Sales_Org__c,Net_Price__c,FinalPrice2__c,Rebate__c,
                                                      Net_Invoice_Price__c,UnitValue__c,Product_Type_Italy__c,Unit_Price__c,Rebate_2__c,Shipping_Date__c,Average_Final_Price__c,
                                                      Inventory_order_Flag_Color_Italy__c,Payment_Term__c,Distribution_Channel__c,Division__c,Inventory_Description_Italy__c,Comment__c,Accrual_Discount__c, 
                                                      SKU_Name__r.Name,Manual_Discount__c,Big_Volume_Discount__c,Early_Order_Discount__c,Logistic_Discount__c,Delivery_Date__c 
                                                      FROM Sales_Order_Line_Item__c
                                                      WHERE Sale_Order__c=:recordId];
        
        System.debug('solItemList '+solItemList);
        if(solItemList.size()>0){
            OrderWrapperObj.soiList = solItemList;
        }
        orderViewList.add(OrderWrapperObj);
        System.debug('orderViewList in View Order Summary '+orderViewList);
        System.debug('orderViewList in View Order Summary '+orderViewList.size());
        return orderViewList;
        
    }

    @AuraEnabled (cacheable = true)
    public static List<User> getUserInfo(){
        List<User> u =new List<User>();
        u=[select Id, Country,AccountId ,Account.SAP_Customer_Code__c, Community_Role__c,profile.Name from user WHERE Id =: UserInfo.getUserId() ];  //Updated for RITM0531740	  GRZ(Dheeraj Sharma) 04-03-2023
       
        return u;
    }

 /*
    * Description: This method will fetch the PBM record related to dependent SKU code and update the quantity (entered quantity * 100)
                   and PaymentTerm on child orderLine Items
	* Param: accountid,Parent SKU code,Quantity entered for Parent SKU,Payment Terms of Parent SKU
	* return : List<SalesOrderItem>
    * */   
    
    
     @AuraEnabled
     public static List<SalesOrderItem> getDependentSKUData(Id accId,String SKUCode,Decimal quantity,String paymentTerm){
         try {
             Map<String, UPL_SalesOrg_Detail__mdt> SalesOrgDetails = new Map<String, UPL_SalesOrg_Detail__mdt>();
             salesOrgDetails = UtilityClass.getSalesOrgDetails();
             String location = salesOrgDetails?.get('Poland Sales org')?.Location__c;
             String DistributionChannelCode = salesOrgDetails?.get('Poland Sales org')?.Distribution_Channel_Code__c;
             set<Id> skuIds=new set<Id>();//by Nandhini
             Poland_Dependent_SKU_Code__mdt PD_Sku = [SELECT Id,Main_SKU_Code__c,Child_SKU_Code__c,Sub_SKU_Codes__c FROM Poland_Dependent_SKU_Code__mdt WHERE Main_SKU_Code__c=: SKUCode];
             List<String> subSKUCode = PD_Sku.Sub_SKU_Codes__c.split(',');
             List<PriceBookMaster__c> PBList = [SELECT Id,DistributionChannel__c,Payment_Term__c,SKUCode__r.Distribution_Channel__r.Distribution_Channel_Code__c,SKUCode__r.Division__r.Division_Code__c,SKUCode__r.Distribution_Channel__c,SKUCode__r.Division__c,SKUCode__c,SKUCode__r.Truck_Quantity__c,SKUCode__r.Payment_Term__c,SKUCode__r.Logistic_Discount__c,Division__c,SKUCode__r.Multiple_Of__c,SKUCode__r.Name,     
                                                 SKUCode__r.SKU_Code__c,SKUCode__r.Combination_Key__c,SKUCode__r.Pack_Size__c, MinPrice__c,DistributorCustomerCode__c, PAK__c,
                                                 DepotCode__c, DepotCode__r.Location__c,SKUCode__r.UOM__c,SKUCode__r.Area_Manager_MSP__c,    
                                                 SKUCode__r.Sales_Director_MSP__c, Price__c, PG_CODE__c, PG_CODE__r.Name,SKUCode__r.Product_Category__c,SKUCode__r.Sales_Agent_MSP__c,   
                                                 UOM__c, SKUCode__r.Product_Name__r.Name, SKUCode__r.Unit_Cost__c,SKUCode__r.pallet_Size_Italy__c,   
                                                 SKUCode__r.Product_Name__c, CurrencyIsoCode,SKUCode__r.Brand_Name__c,SKUCode__r.Active_ingredient_Italy__c,
                                                 SKUCode__r.Product_Name__r.Popular__c, SKUCode__r.SKU_Description__c,Final_Price__c 
                                                 FROM PriceBookMaster__c WHERE SKUCode__r.SKU_Code__c LIKE:subSKUCode AND DepotCode__r.Location__c =:location AND PAK__c = true AND
                                                  SKUCode__r.Distribution_Channel__r.Distribution_Channel_Code__c =:DistributionChannelCode AND DistributorCustomerCode__c =null
                                                   AND SKUCode__r.Sales_Org__r.sales_org_code__c ='2941' AND StartDate__c <= TODAY AND EndDate__c >= TODAY 
                                                   AND SKUCode__r.Active__c = True ORDER BY SKUCode__r.Brand_Name__c ASC, SKUCode__r.SKU_Code__c DESC, 
                                                   StartDate__c ASC,LastModifiedDate ASC];
 
             Map<String,PriceBookMaster__c> SKUCodeVsPB = new Map<String,PriceBookMaster__c>();
             for(PriceBookMaster__c PB: PBList){
                 if(SKUCodeVsPB.get(PB.SKUCode__r.SKU_Code__c) == null){
                     SKUCodeVsPB.put(PB.SKUCode__r.SKU_Code__c,PB);
                     skuIds.add(PB.SKUCode__c);
                 }
             }
             List<PriceBookMaster__c> PBMList = new List<PriceBookMaster__c>();
             for(PriceBookMaster__c pbRec:SKUCodeVsPB.values()){
                 PBMList.add(pbRec);
             }
             
             //Added by Nandhini
             Decimal totalQty = 0;
             List<Sales_Order_Line_Item__c> solList = new List<Sales_Order_Line_Item__c>();
             solList = [Select Id,Name,SKU_Name__c,Quantity__c from Sales_Order_Line_Item__c 
                        WHERE SKU_Name__c IN:skuIds AND Sale_Order__r.Order_Status__c='Pending' 
                        AND Sale_Order__r.SalesOrgCode__c='2941'];
             Map<Id,Decimal> skuTotalQuantity=new Map<Id,Decimal>();
             if(solList !=null && !solList.isEmpty()){
                 for(Sales_Order_Line_Item__c obj:solList){
                     if(!skuTotalQuantity.containsKey(obj.SKU_Name__c)){
                         skuTotalQuantity.put(obj.SKU_Name__c,obj.Quantity__c);
                     }
                     else{
                         totalQty =skuTotalQuantity.get(obj.SKU_Name__c) +obj.Quantity__c;
                         skuTotalQuantity.put(obj.SKU_Name__c,totalQty);
                     }
                     // totalQty =totalQty +obj.Quantity__c;
                 }
             }
             
             Decimal inventory = 0;
             Map<Id,Decimal> finalInventory=new Map<Id,Decimal>();
             List<Stock_Requirement__c> stList = new List<Stock_Requirement__c>();
             stList =[Select Id,Available_Stock__c,SKU__c From Stock_Requirement__c WHERE SKU__c IN :skuIds];
              if(stList.size()>0){
                  for(Stock_Requirement__c steq:stList){
                      if(steq.Available_Stock__c!=null && skuTotalQuantity.containsKey(steq.SKU__c)){
                          inventory = steq.Available_Stock__c-skuTotalQuantity.get(steq.SKU__c);
                          finalInventory.put(steq.SKU__c,inventory);
                      }else{
                          if(skuTotalQuantity.containsKey(steq.SKU__c)){
                              finalInventory.put(steq.SKU__c,skuTotalQuantity.get(steq.SKU__c));
                          }
                      }
                  }
              }
             else{
                 finalInventory=skuTotalQuantity;
             }
             List<SalesOrderItem> itemList = new List<SalesOrderItem>(); 
             
             for(PriceBookMaster__c pbObj: PBMList){  
                 SalesOrderItem item = new SalesOrderItem(); 
                 Decimal tempQuantity=quantity * 100;
                 item.productId = pbObj.SKUCode__r.Name;
                 item.productName = pbObj.SKUCode__r.SKU_Description__c;             
                 item.skuId = pbObj.SKUCode__c;
                 item.divisionId = pbObj.Division__c;
                 item.distributionChannelId = pbObj.DistributionChannel__c;
                 item.qty = quantity * 100;
                 item.UOM = pbObj.UOM__c;
                 item.skuCombinationKey = pbObj.SKUCode__r.Combination_Key__c;
                
                 //item.logisticDiscountValue = pbObj.SKUCode__r.Logistic_Discount__c;
               
                 item.palletSize = pbObj.SKUCode__r.pallet_Size_Italy__c;  
                 
                 item.typeOfPayment = paymentTerm;
                 item.basePrice = pbObj.Price__c;
                 //Decimal pricepBobj= pbObj.Price__c;
                // Decimal tempNetValue=tempQuantity * pricepBobj;
                 item.netValue = (item.qty * pbObj.Price__c);
                 //item.netValue =tempNetValue;
                 item.skuCode =pbObj.SKUCode__r.SKU_Code__c;
                 item.PAK = pbObj.PAK__c;
                 if(finalInventory.containsKey(pbObj.SKUCode__c)){
                     item.inventory=finalInventory.get(pbObj.SKUCode__c);
                 }
                 else{
                     item.inventory=0;
                 }
                 
                 itemList.add(item);
             }
             System.debug('itemList => '+itemList);
             //String serialiZed =JSON.serialize(itemList);
             return itemList;
         } catch (Exception e) {
             throw new AuraHandledException(e.getMessage());
         }
     }

    public class OrderWrapperView{ 
        @AuraEnabled public Sales_Order__c soObj;   
        @AuraEnabled public List<Sales_Order_Line_Item__c> soiList;
        
        public OrderWrapperView(){  
            soObj = new Sales_Order__c();
            soiList= new List<Sales_Order_Line_Item__c>(); 
        }
    }
    
    
    public class OrderWrapper{  
        @AuraEnabled public Sales_Order__c soObj;   
        @AuraEnabled public List<SalesOrderItem> soiList;
        @AuraEnabled public List<String> createdsalesOrderList;
        @AuraEnabled public List<String> salesOrderName;
        
        
        @AuraEnabled public String sfdcOrderNo; 
        @AuraEnabled public String sapOrderNo;  
        @AuraEnabled public String orderSubStatus; 
        public Exception exObj; 
        
        public OrderWrapper(){  
            soObj = new Sales_Order__c();   
            soiList = new List<SalesOrderItem>();  
            createdsalesOrderList = new List<String>();
            salesOrderName = new List<String>();
            sfdcOrderNo = '';   
            sapOrderNo = '';    
            orderSubStatus = '';
            
        }   
    } 
    
    public class discountWrapper{
        @AuraEnabled public String earlyOrderDisName;
        @AuraEnabled public Date startDate;
        @AuraEnabled public Date endDate;
        @AuraEnabled public Decimal discount;
        
        @AuraEnabled public String bigOrderDisName;
        @AuraEnabled public Decimal paletQtydis;
        @AuraEnabled public Decimal truckQtydis;
        
        public discountWrapper(){
            earlyOrderDisName='';
            //startDate;
            //endDate;
            discount =0;
            
            bigOrderDisName ='';
            paletQtydis =0;
            truckQtydis=0;
        }         
    }
    
    
    
    public class CartWrapper{   
        @AuraEnabled public List<SalesOrderItem> soiList;  
        @AuraEnabled public SalesOrderItem soitemObj;  
        @AuraEnabled public String cartOrderId;    
        @AuraEnabled public String errorMessage;   
        @AuraEnabled public Decimal grossNetPrice; 
        @AuraEnabled public String incoTerm;
        //@AuraEnabled public Boolean isExpressDelivery; 
        
        
        
        
        public CartWrapper(){   
            soiList = new List<SalesOrderItem>();  
            soitemObj = new SalesOrderItem();  
            cartOrderId ='';   
            errorMessage='';   
            grossNetPrice=0;   
            incoTerm ='';
            //isExpressDelivery =false; 
        }    
    }  
    
    
    public class PriceDetail{   
        @AuraEnabled public String skuId;   
        @AuraEnabled public String skuDescription;  
        @AuraEnabled public String skuCategory; 
        @AuraEnabled public String UOM; 
        @AuraEnabled public String productName;
        @AuraEnabled public String PaymentTermId;
        
        @AuraEnabled public String divisionId;
        @AuraEnabled public String distributionChannelId;
        
        @AuraEnabled public Decimal basePrice;
        @AuraEnabled public Decimal basePriceOg;
        
        @AuraEnabled public Decimal quantity;
        @AuraEnabled public Decimal multipleOf;
        @AuraEnabled public Decimal palletSize;
        @AuraEnabled public Decimal discount1; //early order discount
        
        @AuraEnabled public Decimal truckSize;
        
        @AuraEnabled public Decimal earlyOrderDiscount;
        @AuraEnabled public Decimal bigVolDiscount;
        @AuraEnabled public Decimal manualDiscount;
        @AuraEnabled public Decimal logisticDiscount;
        @AuraEnabled public Decimal logisticDiscountValue;
        
        @AuraEnabled public Decimal finalPrice;
        @AuraEnabled public Decimal netValue;
        @AuraEnabled public String skuCode; 
        @AuraEnabled public String paymentTerm;
        @AuraEnabled public Decimal inventory; 
        @AuraEnabled public Boolean PAK; 
        @AuraEnabled public Boolean isParent; //by Nandhini
        
        public PriceDetail(){
            skuId='';   
            skuDescription=''; 
            distributionChannelId ='';
            divisionId='';
            skuCategory=''; 
            productName ='';
            truckSize = 0;
            UOM=''; 
            skuCode=''; 
            PaymentTermId='';
            basePrice=0;
            basePriceOg =0;
            quantity=0;
            multipleOf = 0;
            palletSize=0; 
            discount1 =0; //early Order Ds
            earlyOrderDiscount=0;
            bigVolDiscount=0;
            manualDiscount=0;
            logisticDiscount=0;
            logisticDiscountValue =0;
            finalPrice=0;
            netValue=0;
            paymentTerm='';
            inventory=0;
            PAK = false;
            isParent= false;//by Nandhini
        }
        
        
        
        
    }
    
    
    
    
    
    //Wrapper Class to store all data
    public class OrderFields{  
        @AuraEnabled public DistributorWrapper DistributorData; 
        // @AuraEnabled public List<String> orderTypeList;   
        @AuraEnabled public List<String> paymentMethodList; 
        @AuraEnabled public List<String> currencyList; 
        @AuraEnabled public Map<String,Inco_Term__c> incoTermMap; 
        @AuraEnabled public Map<String,Payment_Term__c> paymentTermMap; 
        
        @AuraEnabled public Map<String, Shipping_Location__c> ShippingLocMap;   
        //@AuraEnabled public Map<String,Payment_Term_PG_Group_Mapping__c> PaymentTermMap;    
        @AuraEnabled public Map<String,Payment_Term_PG_Group_Mapping__c> PaymentTermCustomerMap; 
        @AuraEnabled public Map<String,Payment_Term__c> PaymentTermMap1; 
        
        @AuraEnabled public List<String> divisionCodeList; 
        @AuraEnabled public List<String> incoTermsList; 
        @AuraEnabled public List<String> productTypesList;  
        @AuraEnabled public List<String> priceList; 
        @AuraEnabled public User userObj; 
        @AuraEnabled public String whereCluseFilter;
        @AuraEnabled public Login_Country__c loginCobj;  // SKI(Vishal P) : #CR152 : PO and Delivery Date : 29-09-2022...
        
        
        
        
        public OrderFields(){   
            DistributorData = new DistributorWrapper(); 
            paymentMethodList = new List<String>();
            loginCobj = new Login_Country__c();         // SKI(Vishal P) : #CR152 : PO and Delivery Date : 29-09-2022...
            currencyList = new List<String>(); 
            divisionCodeList = new List<String>();
            ShippingLocMap = new Map<String, Shipping_Location__c>();
            incoTermMap = new Map<String,Inco_Term__c>();
            paymentTermMap = new Map<String,Payment_Term__c>();
            
            
            //PaymentTermMap = new Map<String, Payment_Term_PG_Group_Mapping__c>();   
            PaymentTermCustomerMap = new Map<String, Payment_Term_PG_Group_Mapping__c>();   
            PaymentTermMap1 = new Map<String, Payment_Term__c>();   
            incoTermsList = new List<String>(); 
            productTypesList = new List<String>();  
            priceList = new List<String>(); 
            userObj = new User();
            whereCluseFilter='';
            
            
        }   
        
    }
    
    
    
    
    
    public class SalesOrderItem { 
        @AuraEnabled public Date customerDeliveryDate;  // SKI(Vishal P) : #CR152 : PO and Delivery Date : 29-09-2022..
        @AuraEnabled public Decimal basePrice;
        @AuraEnabled public Decimal basePriceOg;
        
        @AuraEnabled public Decimal bigVolDiscount;
        @AuraEnabled public Decimal discount1;
        @AuraEnabled public Decimal earlyOrderDiscount;
        @AuraEnabled public Decimal finalPrice;
        @AuraEnabled public Decimal inventory; 
        @AuraEnabled public String typeOfPayment; 
        
        @AuraEnabled public Decimal logisticDiscount; 
        @AuraEnabled public Decimal logisticDiscountValue;
        @AuraEnabled public Decimal manualDiscount;
        @AuraEnabled public Decimal multipleOf;
        @AuraEnabled public Decimal netValue;
        @AuraEnabled public Decimal palletSize;
        @AuraEnabled public String oliId;
        @AuraEnabled public String salesOrderId;
        
        @AuraEnabled public String divisionId;
        @AuraEnabled public String distributionChannelId;
        @AuraEnabled public Decimal itemNo; 
        //@AuraEnabled public String typeOfPayementTerm ; 
        
        
        @AuraEnabled public String paymentTerm;
        @AuraEnabled public String PaymentTermId;
        @AuraEnabled public String productName;
        @AuraEnabled public Decimal quantity; 
        @AuraEnabled public String skuCode; 
        @AuraEnabled public String skuDescription;
        @AuraEnabled public String skuId;
        @AuraEnabled public Decimal truckSize;
        @AuraEnabled public String UOM; 
        @AuraEnabled public Decimal qty; 
        @AuraEnabled public String productId;
        @AuraEnabled public String so_id;
        @AuraEnabled public String soliId;
        @AuraEnabled public String Big_Volume_for_Truck;    
        @AuraEnabled public String Big_Volume_for_Pallet;
        @AuraEnabled public String skuCombinationKey;
        @AuraEnabled public String accountId;
        @AuraEnabled public String parent;
        @AuraEnabled public Boolean PAK;
        @AuraEnabled public Boolean isParent; //by Nandhini
        
        
        
        
        
        
        //@AuraEnabled public String productCode; 
        
        
        public SalesOrderItem(){
            skuCombinationKey='';
            accountId ='';
            inventory = 0;
            basePrice = 0;
            basePriceOg =0;
            divisionId ='';
            distributionChannelId ='';
            bigVolDiscount = 0;
            discount1 = 0;
            salesOrderId='';
            soliId ='';
            typeOfPayment ='';
            so_id='';
            itemNo= 0; 
            earlyOrderDiscount = 0;
            finalPrice = 0;
            logisticDiscount = 0;
            logisticDiscountValue=0;
            manualDiscount = 0;
            multipleOf = 0;
            netValue = 0;
            palletSize = 0;
            paymentTerm = '';
            oliId = '';
            PaymentTermId = '';
            productName = '';
            quantity = 0;
            skuCode  = ''; 
            skuDescription = '';
            skuId = '';
            truckSize = 0;
            UOM = ''; 
            qty = 0 ; 
            productId = '';
            Big_Volume_for_Truck='';    
            Big_Volume_for_Pallet='';
            PAK = false;
            parent='';
            isParent= false;
        }
        
    }
    
    
    
    
    
    
    
    public class DistributorWrapper{ 
        @AuraEnabled   public String accountIds;    
        @AuraEnabled   public String Sales_Director;    
        @AuraEnabled   public String Latam_Director;    
        @AuraEnabled   public List<String> divisionIds; 
        @AuraEnabled   public String distributorName;   
        @AuraEnabled   public String areaManagerId; 
        @AuraEnabled   public String salesOrgId;    
        @AuraEnabled   public String salesOrgName;  
        @AuraEnabled   public String distributorChannelId;  
        @AuraEnabled   public String divisionId;    
        @AuraEnabled   public String orderType; 
        @AuraEnabled   public String sapCode;   
        @AuraEnabled   public String depot; 
        @AuraEnabled   public Decimal creditLimit;  
        @AuraEnabled   public Decimal daysArrears;  
        @AuraEnabled   public Decimal creditUsed;   
        @AuraEnabled   public Decimal creditBalance;    
        @AuraEnabled   public Decimal paymentOutstanding;   
        @AuraEnabled   public Decimal greaterThan90;    
        @AuraEnabled   public Decimal normalDCostTC;    
        @AuraEnabled   public Decimal expressDCostTC;   
        @AuraEnabled   public String address;   
        @AuraEnabled   public String city;  
        @AuraEnabled   public String state; 
        @AuraEnabled   public String country;   
        @AuraEnabled   public String pincode;   
        @AuraEnabled   public String billingSteet1; 
        @AuraEnabled   public String billingSteet2; 
        @AuraEnabled   public String billingSteet3; 
        @AuraEnabled   public String billingSteet4; 
        @AuraEnabled   public String billingSteet5; 
        @AuraEnabled   public String billingSteet6; 
        @AuraEnabled   public String currencyIso; 
        @AuraEnabled   public String customerType; 
        @AuraEnabled   public Id regionalManagerId; 
        @AuraEnabled   public String paymentTerms;  
        @AuraEnabled   public String paymentTermId;
        @AuraEnabled   public Id priceGroupId;  
        @AuraEnabled   public Id priceListType; 
        @AuraEnabled   public String territoryManagerId;    
        @AuraEnabled   public Decimal internalCredit;   
        @AuraEnabled   public Boolean fixedRateAvailable;   
        
    }
}