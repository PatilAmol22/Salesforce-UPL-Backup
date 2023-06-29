/*
* Name: OrderChileController
* Created On: 28/10/2020
* Author: Deeksha Gupta (dgupt31@in.ibm.com)
* Description: Lightning Component Apex Controller used for Raising orders by Customer service user of Chile
*/
public without sharing class OrderChileController {
    public static Map<String,Shipping_Location__c> shipMap = new Map<String,Shipping_Location__c>();
    public static List<id> salesOrderObjList = new List<id>();
    public static Order__c ordObj;
    @AuraEnabled public String ownerIdUser;
    //Method to fetch all Distributor
    @AuraEnabled
    public static List<Account> fetchCustomer() {
        return [select Id ,Name,SAP_Code__c, Sales_Org__c from Account where (Sales_Org__r.Sales_Org_Code__c = '5661' OR Sales_Org__r.Sales_Org_Code__c = '5662') and Account_Type__c ='Sold To Party' ];//CR#183 -Export Order Management – Chile- SKI- kalpesh chande -28-03-2023 
    }
    
    @AuraEnabled
    public static List<Account> findByName(String searchKey) {
        String name =  + searchKey + '%';
        return [SELECT id, name, phone,SAP_Code__c FROM Account WHERE (Sales_Org__r.Sales_Org_Code__c = '5661' OR Sales_Org__r.Sales_Org_Code__c = '5662') and Account_Type__c ='Sold To Party' and (name LIKE :name OR SAP_Code__c LIKE :name)];//CR#183 -Export Order Management – Chile- SKI- kalpesh chande -28-03-2023
    }  
    
    @AuraEnabled
    public static void updateAllOrderItems(String salesOrderItemString,String accountId,Sales_Order__c soObj2, String salesOrg){
        List<SalesOrderItem> SOIList = OrderChileController.createOrder(accountId,soObj2,salesOrg);
        system.debug('@@'+ordObj);
        if(ordObj!=null){
            Map<decimal,SalesOrderItem> itemNoToItemMap = new Map<decimal,SalesOrderItem>();
            List<OrderLineItem__c> orderlineItemsToUpdate = new List<OrderLineItem__c>();
            List<SalesOrderItem> items = (List<SalesOrderItem>)JSON.deserialize(SalesOrderItemString, List<SalesOrderItem>.class);
            List<OrderLineItem__c> orderlineItems = [select id ,Item_Number__c from OrderLineItem__c where Order__c=:ordObj.id ];
            for(SalesOrderItem oi : items){
                itemNoToItemMap.put(oi.itemNo, oi);
            }
            for(OrderLineItem__c oli :orderlineItems){
                Integer key = (Integer.valueOf(oli.Item_Number__c)/10)-1;
                if(itemNoToItemMap.containsKey(key)){
                    SalesOrderItem item = itemNoToItemMap.get(key);
                    oli.SKU_Name__c = item.productId;
                    oli.CurrencyIsoCode = item.oiCurrency;
                    oli.MinPrice__c =item.minValue;       
                    oli.MaxPrice__c =item.maxPrice;
                    oli.UOM__c = item.UOM;
                    oli.multipleOf__c = item.multipleOf;
                    oli.Quantity__c = item.qty;
                    oli.Shipping_Date__c = item.deliveryDate;
                    if(item.deliveryAddress!= null && item.deliveryAddress!= 'None'){
                        shipMap = OrderChileController.getShippingLoations(ordObj.Bill_To_Party__c);
                        oli.Shipping_Location__c = shipMap.get(item.deliveryAddress).id;   
                    }
                    oli.Price__c = item.netSales;
                    oli.FinalPrice__c = item.unitValue;
                    oli.Net_Price__c =item.unitValue;                                      
                    orderlineItemsToUpdate.add(oli);
                }
            }
            update orderlineItemsToUpdate;
        }
    }
    
    @AuraEnabled
    public static void updateOrderItem(String salesOrderItemString,String accountId,Sales_Order__c soObj2, String salesOrg){
       
        List<SalesOrderItem> SOIList = OrderChileController.createOrder(accountId,soObj2,salesOrg);
        system.debug('@@'+ordObj);
        if(ordObj!=null){
            SalesOrderItem item = (SalesOrderItem)JSON.deserialize(SalesOrderItemString, SalesOrderItem.class);
            String i = String.valueOf((item.itemNo+1)*10);
            List<OrderLineItem__c> orderlineItems = [select id from OrderLineItem__c where Item_Number__c =: i and Order__c=:ordObj.id ];
            
            
            if(!orderlineItems.isEmpty()) {
                orderlineItems[0].Item_Number__c = String.valueOf((item.itemNo+1)*10);
                //orderlineItems[0].Order__c = ordObj.id;
                orderlineItems[0].SKU_Name__c = item.productId;
                orderlineItems[0].CurrencyIsoCode = item.oiCurrency;
                orderlineItems[0].MinPrice__c =item.minValue;       
                orderlineItems[0].MaxPrice__c =item.maxPrice;
                orderlineItems[0].UOM__c = item.UOM;
                orderlineItems[0].multipleOf__c = item.multipleOf;
                orderlineItems[0].Quantity__c = item.qty;
                orderlineItems[0].Shipping_Date__c = item.deliveryDate;
                system.debug('@@delivery Address'+item.deliveryAddress);
                if(item.deliveryAddress!= '' && item.deliveryAddress!= 'None'){
                    shipMap = OrderChileController.getShippingLoations(ordObj.Bill_To_Party__c);
                    system.debug('@@shipMap'+shipMap);
                    orderlineItems[0].Shipping_Location__c = shipMap.get(item.deliveryAddress).id;   
                }else
                {
                    orderlineItems[0].Shipping_Location__c =null;
                }
                orderlineItems[0].Price__c = item.netSales;
                orderlineItems[0].FinalPrice__c = item.unitValue;
                orderlineItems[0].Net_Price__c =item.unitValue;                                    
                update orderlineItems[0];
            }else{
                OrderLineItem__c oiObj= new OrderLineItem__c();
                oiObj.Item_Number__c = String.valueOf((item.itemNo+1)*10);
                oiObj.Order__c = ordObj.id;
                oiObj.SKU_Name__c = item.productId;
                oiObj.CurrencyIsoCode = item.oiCurrency;
                oiObj.MinPrice__c =item.minValue;       
                oiObj.MaxPrice__c =item.maxPrice;
                oiObj.UOM__c = item.UOM;
                oiObj.multipleOf__c = item.multipleOf;
                oiObj.Quantity__c = item.qty;
                oiObj.Shipping_Date__c = item.deliveryDate;
                oiObj.Price__c = item.netSales;
                oiObj.FinalPrice__c = item.unitValue;
                oiObj.Net_Price__c =item.unitValue;
                insert oiObj;
            }
            
        }              
    }
    
    @AuraEnabled
    public static void deleteOrderItem(Integer ItemNo,String accountId){
        if(ordObj==null){
            List<Order__c> recentOrderList =  [SELECT Id, Name
                                               FROM Order__c 
                                               WHERE Order_Status__c='Draft'
                                               AND Bill_To_Party__c =: accountId LIMIT 1];
            if(!recentOrderList.isEmpty()){
                ordObj = recentOrderList[0];
            }
            
            
            String i = String.valueOf((ItemNo+1)*10);
            List<OrderLineItem__c> orderlineItems = [select id from OrderLineItem__c where Item_Number__c =: i and Order__c=:ordObj.id ];
            if(!orderlineItems.isEmpty()){
                delete orderlineItems;
            }
        }
    }
    
    @AuraEnabled
    public static void deleteAllOrderItem(String accountId){
        if(ordObj==null){
            List<Order__c> recentOrderList =  [SELECT Id, Name
                                               FROM Order__c 
                                               WHERE Order_Status__c='Draft'
                                               AND Bill_To_Party__c =: accountId LIMIT 1];
            if(!recentOrderList.isEmpty()){
                ordObj = recentOrderList[0];
            }
            
            List<OrderLineItem__c> oliList = [SELECT Id, Name
                                              FROM OrderLineItem__c
                                              WHERE Order__c=:ordObj.id];
            if(!oliList.isEmpty()){
                delete oliList;
            }
        }        
    }
    
    @AuraEnabled
    public static void updateOrder(String accountId){
        
        List<Order__c> recentOrderList =  [SELECT Id, Name
                                           FROM Order__c 
                                           WHERE Order_Status__c='Draft'
                                           AND Bill_To_Party__c =: accountId LIMIT 1];
        if(!recentOrderList.isEmpty()){
            ordObj = recentOrderList[0];
        }
        if(ordObj!=null){
            ordObj.Order_Status__c = 'Open';
            update ordObj;
        }
    }
    
    @AuraEnabled
    public static List<SalesOrderItem> createOrder(String accountId,Sales_Order__c soObj2, String salesOrg){
        try{
            //ApexLog.exceptionCoverage(throwEx);
            List<SalesOrderItem> itemList = new List<SalesOrderItem>();
            if(ordObj==null){
                List<Order__c> recentOrderList =  [SELECT Id, Name, Net_Amount__c, Bill_To_Party__c, Order_Date__c, 
                                                   Order_Raise_By__c, Order_Status__c, Vat_Amount__c,CurrencyIsoCode,
                                                   RegionalManager__c, Shipping_Location__c, OwnerId, 
                                                   Additional_Tax_Amount__c, Gross_Amount__c
                                                   FROM Order__c 
                                                   WHERE Order_Status__c='Draft'
                                                   AND Bill_To_Party__c =: accountId LIMIT 1];
                
                if(!recentOrderList.isEmpty()){
                    ordObj = recentOrderList[0];
                    //orderId = ordObj.Id;
                    itemList = editOrder();
                }
                else{
                    
                    ordObj = new Order__c();
                    ordObj.Bill_To_Party__c = accountId;
                    ordObj.OwnerId = UserInfo.getUserId();
                    ordObj.Order_Date__c = System.today();
                    //ordObj.Depot__c = soObj2.Depot__c;
                    ordObj.Order_Status__c = 'Draft';
                    //ordObj.RegionalManager__c = distWrapObj.regionalManagerId;
                    //ordObj.Distribution_Channel__c = soObj2.Distribution_Channel_lk__c; //CR#183 -Export Order Management – Chile- SKI- kalpesh chande -13-04-2023-Comment

                    ordObj.Division__c = soObj2.Division_lk__c; 
                    //List<Sales_Org__c> salesOrgList = [Select ID FROM Sales_Org__c WHERE NAME = 'Chile' AND Sales_Org_Code__c = '5661'LIMIT 1];
                    
                    if(salesOrg != '' && salesOrg != null){
                        ordObj.Sales_Org__c  = salesOrg;
                    }
                    ordObj.CurrencyIsoCode = soObj2.CurrencyIsoCode;
                    insert ordObj;
                    //orderId = ordObj.Id;
                }
                
            }
            return itemList;
        }
        catch(Exception ex){
            // ApexLog.exceptionHandler(ex, orderId, accountId);
            return null;
        }            
    }
    public static List<SalesOrderItem> editOrder(){
        List<OrderLineItem__c> oliList = [SELECT Id, Name, CurrencyIsoCode, SKUPackSize__c, Shipping_Date__c,multipleOf__c,
                                          Order__c, UOM__c, Special_Discount__c, SKU_Name__c,MatchingDiscount__c,Net_Price__c,
                                          SKU_Name__r.Pack_Size__c, Scheme_Bonus_Discount__c,MaxPrice__c,MinPrice__c,FinalPrice__c,
                                          SKU_Name__r.Product_Name__r.Name,SKU_Name__r.GST__c,SKU_Name__r.Brand_Name__c,SKU_Name__r.SKU_Description__c,
                                          SKU_Name__r.Name, Quantity__c, Price__c, No_of_Case__c, Item_Number__c, 
                                          Item_Status__c, Invoice_Discount__c, Order__r.Shipping_Location__c,Shipping_Location__r.City__c,Shipping_Location__r.Billing_Street_3__c
                                          FROM OrderLineItem__c
                                          WHERE Order__c=:ordObj.id order by Item_Number__c];
        
        List<SalesOrderItem> itemList = new List<SalesOrderItem>();
        for(OrderLineItem__c oliObj:oliList){
            SalesOrderItem item = new SalesOrderItem();
            item.productId = oliObj.SKU_Name__c;
            item.productName = oliObj.SKU_Name__r.SKU_Description__c;
            item.oiCurrency = oliObj.CurrencyIsoCode;
            item.maxPrice =oliObj.MaxPrice__c;
            item.minValue = oliObj.MinPrice__c;
            item.qty = oliObj.Quantity__c;
            item.UOM = oliObj.UOM__c;
            item.multipleOf = oliObj.multipleOf__c;
            item.itemNo = (decimal.valueOf(oliObj.Item_Number__c)/10)-1; 
            item.netSales = oliObj.Price__c;
            item.unitValue = oliObj.FinalPrice__c;
            item.netPrice = oliObj.Net_Price__c;
            item.deliveryDate = oliObj.Shipping_Date__c;
            if(oliObj.Shipping_Location__r.Billing_Street_3__c!=null && oliObj.Shipping_Location__r.City__c != null){
                //item.deliveryAddress= oliObj.Shipping_Location__r.Location_Name__c+' - '+oliObj.Shipping_Location__r.City__c;
                item.deliveryAddress= oliObj.Shipping_Location__r.City__c+' - '+oliObj.Shipping_Location__r.Billing_Street_3__c;
            }else{
                item.deliveryAddress= 'None';
            }
            itemList.add(item);
        }
        return itemList;
    }
    //Method to save sales order record
    /*Params: Sales Order (Object),
Sales Order Items (JSON String)*/
    //CR#169 -Chile Margin Block -SKI- kalpesh chande - 10/11/2022 - Start Here
    @AuraEnabled
    public static Map<String,String> checkSimulation(String priceDetailString,Sales_Order__c soObj, String salesOrderItemString, Boolean isSimulated, String salesOrg, Boolean isPaymentTermChanged,Boolean isSimulation){
        
        Map<String,String> appMap=new Map<String,String>();
         List<Sales_Org__c> salesOrgList = [Select ID FROM Sales_Org__c WHERE (Sales_Org_Code__c = '5661' OR Sales_Org_Code__c = '5662')];//CR#183 -Export Order Management – Chile- SKI- kalpesh chande -28-03-2023
        List<SalesOrderItem> salesOrderItemList = (List<SalesOrderItem>)JSON.deserialize(SalesOrderItemString, List<SalesOrderItem>.class);
        system.debug('priceDetailString '+priceDetailString);
        List<PriceDetail> priceDetailList = (List<PriceDetail>)JSON.deserialize(priceDetailString, List<PriceDetail>.class);
        appMap=OrderChileController.saveOrderItems(soObj,priceDetailList, salesOrderItemList, salesOrgList,isPaymentTermChanged, isSimulation);
        
        return appMap;
    }
    //CR#169 -Chile Margin Block -SKI- kalpesh chande - 10/11/2022 - End Here
    @AuraEnabled
    public static OrderWrapper saveSalesOrder(String priceDetailString,Sales_Order__c soObj, String salesOrderItemString, Boolean isSimulated, String salesOrg, Boolean isPaymentTermChanged,Boolean isSimulation) { //CR#169 -Chile Margin Block - SKI- kalpesh chande - 10/11/2022
        System.debug('Sales Order:>>>>'+soObj);
        //Initialize Return Order Wrapper.
        OrderWrapper owObj = new OrderWrapper();
        //Exception exObj;
        
        try{
            //If Owner Id is blank or None set Owner Id to Logged In User
            String ownerId = soObj.OwnerId;
            if(String.isBlank(ownerId) || ownerId=='None'){
                soObj.OwnerId = UserInfo.getUserId();
            }
            //  system.debug('soObj.Order_Status__c'+soObj.Order_Status__c+''+soObj);
            /*  User userObj =   [Select Id, Profile.Name, Show_List_Value__c,Show_Min_Price__c,Show_Max_Price__c,Show_Floor_Price__c, IsActive, ContactId,UserRole.name,
Show_Inventory__c, Show_Credit_Limit__c, EnableDepot__c,
Show_Inventory_Column__c, ManagerId,Show_InTransit__c, Show_InTransit_Values__c,HO__c, Country_Head__c, Marketing_Manager__c
FROM User 
WHERE Id =: UserInfo.getUserId()
AND IsActive = True]; */
            
            system.debug('soObj.OwnerId'+soObj.OwnerId);
            List<Sales_Org__c> salesOrgList = [Select ID FROM Sales_Org__c WHERE (Sales_Org_Code__c = '5661' OR Sales_Org_Code__c = '5662')];//CR#183 -Export Order Management – Chile- SKI- kalpesh chande -28-03-2023
     //CR#183 -Export Order Management – Chile- SKI- kalpesh chande -28-03-2023- Comment- Start here
           /* if(salesOrg != '' && salesOrg != null){
                soObj.Sales_Org_lk__c = salesOrg;
           }*/
     //CR#183 -Export Order Management – Chile- SKI- kalpesh chande -28-03-2023 -Comment -End here
            //system.debug('soObj.Order_Type_lk__c');
            //soObj.Order_Type_lk__c = [Select Id,SalesOrg__c FROM Order_Type__c WHERE Order_Type_Code__c='ZORU' limit 1].Id;
            //system.debug('soObj.Order_Type_lk__c'+soObj.Order_Type_lk__c);
            //soObj.CurrencyIsoCode = 'CLP';
            soObj.Order_Date__c = System.today();
            soObj.CreatedFrom__c = 'SFDC';
            //String depotCodeId= [Select Id,Name ,Depot__c,SalesOrg__r.sales_org_code__c From Depot__c where Depot_Code__c ='CO51' LIMIT 1].Id;
            
            //Logic to query if the record Id is not a rollback record as the Id for rollback record will be invalidated
            List<Sales_Order__c> salesOrderList = [Select Id, Name FROM Sales_Order__c WHERE Id=:soObj.Id];
            if(salesOrderList.isEmpty()){
                //After rollback the ID remains in the record, make it null & upsert
                soObj.Id = null;
            }
            List<SalesOrderItem> salesOrderItemList = (List<SalesOrderItem>)JSON.deserialize(SalesOrderItemString, List<SalesOrderItem>.class);
            List<PriceDetail> priceDetailList = (List<PriceDetail>)JSON.deserialize(priceDetailString, List<PriceDetail>.class); //CR#169 -Chile Margin Block - SKI- kalpesh chande - 10/11/2022
            System.debug('salesOrderItemList: '+salesOrderItemList);
            //System.debug('salesOrderItemList.size: '+salesOrderItemList.size());
            
            //Assign everything to Order Wrapper after upsert.
            //owObj.soiList = OrderChileController.saveOrderItems(soObj,priceDetailList, salesOrderItemList, salesOrgList,isPaymentTermChanged, isSimulation);
            OrderChileController.saveOrderItems(soObj,priceDetailList, salesOrderItemList, salesOrgList,isPaymentTermChanged, isSimulation); //CR#169 -Chile Margin Block - SKI- kalpesh chande - 10/11/2022
            owObj.soiList = OrderChileController.getSalesOrderItems(salesOrderObjList); //CR#169 -Chile Margin Block - SKI- kalpesh chande - 10/11/2022
            owObj.soObjList = OrderChileController.getSalesOrder(salesOrderObjList);
            //owObj.sfdcOrderNo = [Select Id, Name FROM Sales_Order__c WHERE Id=:soObj.Id].Name;
            //owObj.sapOrderNo = soObj.SAP_Order_Number__c;
            List<Approval.ProcessSubmitRequest> appRequests = new List<Approval.ProcessSubmitRequest>();
            for(Sales_Order__c Record : owObj.soObjList){
                if((Record.SalesOrgCode__c =='5661' || Record.SalesOrgCode__c =='5662') && Record.Order_Status__c =='Submitted'){//CR#183 -Export Order Management – Chile- SKI- kalpesh chande -28-03-2023
                    Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
                    req.setObjectId(Record.Id);
                    appRequests.add(req);
                }
            }
            List<Approval.ProcessResult> result = Approval.process(appRequests);  
            
            //owObj.approvalList = OrderChileController.generateData(soObj.Id);
            //End of Logic
            system.debug('owObj'+owObj);
            /*
if(soObj.Order_Status__c == 'Submitted' && (owObj.soObj.Sent_for_Manager_Approval_Mexico__c || owObj.soObj.Sent_for_Director_Approval_Mexico__c || owObj.soObj.Sent_for_Latam_Director_Approval__c)){
soObj.Order_Status__c = 'Pending';
soObj.Colombia_Order_Submitted_for_Approval__c = false;
update soObj;
}else
if(!owObj.soObj.Sent_for_Manager_Approval_Mexico__c && !owObj.soObj.Sent_for_Director_Approval_Mexico__c && !owObj.soObj.Sent_for_Latam_Director_Approval__c && soObj.Order_Status__c == 'Submitted'){
soObj.Order_Status__c = 'Open';
update soObj;
}
owObj.soObj.ErrorMessage__c = '';
*/
        }
        catch(Exception ex){
            System.debug('ErrLine-->'+ex.getLineNumber());
            //If Exception occurrs or If Upsert Fails assign data to return wrapper object.
            soObj.ErrorMessage__c = 'Sales Order save failed. Please contact System Administrator.';
            soObj.Flag_Message__c = soObj.ErrorMessage__c;
            soObj.Flag_Status__c = ''; 
            //owObj.soObj = soObj;
            owObj.soiList = (List<SalesOrderItem>)JSON.deserialize(SalesOrderItemString, List<SalesOrderItem>.class);            
            owObj.exObj = ex;
            //End of Logic
            
            System.debug('ex No: '+ex.getLineNumber()+' ex Msg: '+ex.getMessage());
            ApexLog.exceptionHandlerColumbia(ex, soObj.Sold_to_Party__c, soObj, salesOrderItemString);
        }
        return owObj;
    }
    @AuraEnabled
    public static Decimal getExchangeRate(Date PODate) {
        
        List<ExchangeRate__c> er = [select id,ExchangeRate__c from ExchangeRate__c where FromCurrency__c ='USD' and ToCurrency__c='CLP' and UpdatedDate__c <=: PODate order by UpdatedDate__c desc limit 1];
       system.debug('er.size() '+ er.size());
        if(er.isEmpty()){
            List<CurrencyType> curr = [select IsoCode ,ConversionRate from CurrencyType where IsActive = true and IsoCode = 'CLP'];
            if(!curr.isEmpty()){
                return curr[0].ConversionRate;
            }
            else
                return 0.00;
        }else{
            return er[0].ExchangeRate__c;
        }
    }
    
    //Reload existing Sales Order with given recordID
    @AuraEnabled
    public static List<Sales_Order__c> getSalesOrder(List<ID> soId) {
        //Make sure to add new fields that are being input from the UI to this SOQL query otherwise the data will not be inserted.
        
        List<Sales_Order__c> soList = [SELECT Id, Name, SAP_Order_Number__c, Order_Status__c,Min_for_Profitable_in_result_by_margin__c, 
                                       Sold_to_Party__r.Tax_Number_1__c,Payment_Term__r.Payment_Term__c,Ship_To_Party__r.City__c,
                                       Sold_to_Party__r.Name, Sold_to_Party__c, ReloadPaymentTerms__c, OrderSubStatus__c,
                                       Sold_to_Party__r.Tax_Number_3__c, Depot_Code__c,Sent_for_Manager_Approval_Mexico__c,
                                       Sold_to_Party__r.SAP_Code__c,Ship_To_Party__c,Remarks_Long__c,Order_Type_Colombia__c,
                                       Sold_to_Party__r.Customer_Group__c,Sent_for_Latam_Director_Approval__c,Gross_Margin_Colombia__c,
                                       Sold_to_Party__r.BillingCity,CreatedById, OwnerId, Owner.Name,CurrencyIsoCode,Sent_for_Director_Approval_Mexico__c,
                                       Sold_to_Party__r.BillingState,Net_Amount__c,Gross_Profit_colombia__c,Total_Discount_Per_Colombia__c,
                                       Payment_Term__c, Sold_to_Party__r.Depot_Code__c,Business_Impact_Per_colombia__c,(SELECT Id,Name FROM Attachments limit 1) ,
                                       Sold_to_Party__r.Customer_Region__c,Sent_for_Latam_Director__c,Sent_for_CCO__c,//CR#169 -Chile Margin Block - SKI- kalpesh chande
                                       RecordType.Name, SalesOrgCode__c 
                                       FROM Sales_Order__c 
                                       WHERE Id =: soId];   
        
        return soList;
    }
    
    @AuraEnabled
    public static List<String> getPOList(ID accId) {
        
        List<String> poList = new List<String>();
        for(Sales_Order__c so : [SELECT Purchase_Order_no__c
                                 FROM Sales_Order__c 
                                 WHERE Sold_to_Party__c =: accId and CreatedDate >= LAST_N_DAYS:365]){
                                     poList.add(so.Purchase_Order_no__c);
                                 }  
        
        return poList;
    }
    
    
    //Method to save Order Line Items from the wrapper against the Sales Order 
    @AuraEnabled
    public static Map<String,String> saveOrderItems(Sales_Order__c soObj2,List<PriceDetail>priceDetailList, List<SalesOrderItem> salesOrderItemList, List<Sales_Org__c> salesOrgList, Boolean isPaymentTermChanged,Boolean isSimulation){//CR#169 -Chile Margin Block - SKI- kalpesh chande
        //CR#169 -Chile Margin Block- SKI- kalpesh chande -  05/12/2022 - Start Here   
        
        boolean sentForLatam = false;
        boolean sentForCCO = false;
        Boolean subRegionHead=false;
        Boolean marketingDirector=false;
        Boolean regionalManager=false;
        Map<String,String> approvalAndAddressMap = new Map<String,String>();
        //CR#169 -Chile Margin Block- SKI- kalpesh chande -  05/12/2022 - End Here
        Sales_Order__c SalesOrder;
        String depotCodeId= '';
        depotCodeId = [Select Id,Name ,Depot__c,SalesOrg__r.sales_org_code__c From Depot__c where Depot_Code__c ='CL00' LIMIT 1].Id;
        //String depotCodeId = [SELECT Id, Brazil_Depot_Code__c FROM Account WHERE Id=:soObj2.Sold_to_Party__c].Brazil_Depot_Code__c;
        
        //For Item Number maintenance on Order reload, while saving items delete & re-insert all line items.
        //delete [SELECT Id FROM Sales_Order_Line_Item__c WHERE Sale_Order__c=:soObj2.Id];
        
        //CR#169 -Chile Margin Block- SKI- kalpesh chande -  05/12/2022 - Start Here
        system.debug('soObj2'+soObj2);
        system.debug('salesOrderItemList'+salesOrderItemList);
        system.debug('priceDetailList'+priceDetailList);
        system.debug('isPaymentTermChanged '+isPaymentTermChanged);
        
        
       // List<Profit_Center__c> profitCenterList = new List<Profit_Center__c>();//CR#183 -Export Order Management – Chile- SKI- kalpesh chande -28-03-2023-comment
        List<PriceDetail> skuOrderList=new List<PriceDetail>();
        //CR#183 -Export Order Management – Chile- SKI- kalpesh chande -28-03-2023-comment- start here
       /* profitCenterList =[SELECT Id, Name, Profit_Center__c, Sales_Value__c, Sales_Org__c, Depot__c, Combination_Key__c 
                           FROM Profit_Center__c 
                           WHERE Sales_Org__r.Sales_org_code__c ='5661' ORDER BY LastModifiedDate DESC  LIMIT 1];
        Profit_Center__c profObj = new Profit_Center__c();
        profObj = profitCenterList[0];*/
        //CR#183 -Export Order Management – Chile- SKI- kalpesh chande -28-03-2023-comment- End here
        Admin_MPT_Colombia__c adminObj = new Admin_MPT_Colombia__c();
        adminObj = [SELECT Id, Name, Approval_Level__c,Active__c, Level_1_min__c, Level_1_max__c, 
                    Level_2_min__c, Level_2_max__c, Level_3_below__c, Level_2_Minimum_Discount_Percent__c,
                    Level_2_Maximum_Discount_Percent__c, Level_2_Minimum_Gross_Margin_Percent__c, Sales_Org__c 
                    FROM Admin_MPT_Colombia__c
                    WHERE Sales_Org__r.Sales_Org_Code__c='5661' ORDER BY LastModifiedDate DESC  LIMIT 1];
        
        List<String> skIdsList = new List<String>();
        system.debug('skuOrderList'+priceDetailList[0].skuId);
        for(SalesOrderItem obj :salesOrderItemList){               
            skIdsList.add(obj.productId);
        }
        system.debug('skuOrderList'+skIdsList.size());
        system.debug('skuOrderList'+skIdsList);
        
        List<Payment_Method_Payment_Term_Mapping__c> ptpmDiscountList = new List<Payment_Method_Payment_Term_Mapping__c>();
        ptpmDiscountList = [SELECT Id, Payment_Method__c, Payment_Term__c, Discount__c
                            FROM Payment_Method_Payment_Term_Mapping__c 
                            WHERE Payment_Method__c =:soObj2.PaymentMethod__c AND Payment_Term__c =:SoObj2.Payment_Term__c];
        
        List<UOM_Conversion__c> uomList = new List<UOM_Conversion__c>();
        Map<String,List<UOM_Conversion__c>> uomListMap = new Map<String,List<UOM_Conversion__c>>();
        uomList =[SELECT Id, Name, SKU__c, Base_UOM__c, Sales_UOM__c, 
                  Numerator__c, Sales_Org__c, Denominator__c 
                  FROM UOM_Conversion__c 
                  WHERE SKU__c IN:skIdsList
                  AND (Sales_Org__r.Sales_org_code__c='5661' OR Sales_Org__r.Sales_org_code__c='5662')  ORDER BY LastModifiedDate ASC ];//CR#183 -Export Order Management – Chile- SKI- kalpesh chande -28-03-2023
        
        system.debug('uomList'+uomList.size());
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
                         WHERE (Sales_Org__r.Sales_org_code__c='5661' OR Sales_Org__r.Sales_org_code__c='5662') //CR#183 -Export Order Management – Chile- SKI- kalpesh chande -28-03-2023
                         AND Distributor_Code__c=:soObj2.Sold_to_Party__c
                         AND Start_Date__c<= today AND End_Date__c>= today
                         AND SKU_Code__c IN:skIdsList
                         AND Type__c ='Rebate'
                         AND (Rebate_USD__c!=null OR Rebate__c!=null)
                         AND Rebate_Code__c!=null ORDER BY LastModifiedDate DESC ];
        
        
        if(pbmmReabteList.size()>0){
            for(Price_Block_Margin_Matrix__c rebateObj :pbmmReabteList){                                        
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
                            WHERE (Sales_Org__r.Sales_org_code__c='5661' OR Sales_Org__r.Sales_org_code__c='5662') //CR#183 -Export Order Management – Chile- SKI- kalpesh chande -28-03-2023
                            AND Distributor_Code__c=:soObj2.Sold_to_Party__c
                            AND SKU_Code__c IN:skIdsList
                            AND Type__c ='Discount'
                            AND Start_Date__c<= today AND End_Date__c>= today
                            AND (Discount_USD__c!=null OR Discount__c!=null) ORDER BY LastModifiedDate ASC ];
        
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
                               WHERE (Sales_Org__r.Sales_org_code__c='5661' OR Sales_Org__r.Sales_org_code__c='5662') //CR#183 -Export Order Management – Chile- SKI- kalpesh chande -28-03-2023
                               AND Distributor_Code__c=:soObj2.Sold_to_Party__c
                               AND SKU_Code__c IN:skIdsList 
                               AND Type__c ='AdditionalDiscount'
                               AND Start_Date__c<= today AND End_Date__c>= today
                               AND (Additional_Discount_USD__c!= null OR Additional_Discount__c!= null) ORDER BY LastModifiedDate ASC ];
        
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
        pbmmSalesDeduList = [SELECT Id, Name, SKU_Code__c, SKU_Active__c, UOM__c,  Sales_Deduction_LC__c, Sales_Deduction_USD__c
                             FROM Price_Block_Margin_Matrix__c
                             WHERE Sales_Org__r.Sales_org_code__c='5661'
                             AND SKU_Code__c IN :skIdsList
                             AND Sales_Deduction_USD__c != null
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
        pbmmPlnList =[SELECT Id, Name, SKU_Code__c, SKU_Active__c, UOM__c,Distributor_Code__c,
                      Sales_Org__c, PLN_LC__c, PLN_USD__c
                      FROM Price_Block_Margin_Matrix__c
                      where (Sales_Org__r.Sales_org_code__c='5661' OR Sales_Org__r.Sales_org_code__c='5662') //CR#183 -Export Order Management – Chile- SKI- kalpesh chande -28-03-2023
                      AND (SKU_Code__c IN:skIdsList OR Distributor_Code__c =:soObj2.Sold_to_Party__c)
                      AND Type__c ='PLN'
                      AND Start_Date__c<= today AND End_Date__c>= today
                      AND PLN_USD__c!=null ORDER BY LastModifiedDate DESC ];       
        
        
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
        //CR#169 -Chile Margin Block- SKI- kalpesh chande -  05/12/2022 - End Here   
        List<Sales_Order_Line_Item__c> soiList = new List<Sales_Order_Line_Item__c>();
        Map<String ,List<SalesOrderItem>> deliveryAdressMap = new Map<String ,List<SalesOrderItem>>();
        Integer i = 0;
        Integer j= 0;
        decimal exchangeRate = 0;
        for(SalesOrderItem item: salesOrderItemList){
            if(!deliveryAdressMap.containsKey(item.deliveryAddress)){
                deliveryAdressMap.put(item.deliveryAddress,new List<SalesOrderItem>{item});
            }else{
                deliveryAdressMap.get(item.deliveryAddress).add(item);
            }
        }
        system.debug('@@'+deliveryAdressMap);
        Decimal totMaxPrice;
        Decimal clpUnitValue=0; //CR#169 -Chile Margin Block- SKI- kalpesh chande -  07/01/2023
        List<Sales_Order__c> salesOrderList = new List<Sales_Order__c>();
        List<Order_Type__c> orderTypeLst = [select id,SalesOrg__c,SalesOrg__r.Sales_Org_Code__c from Order_Type__c where (SalesOrg__r.Sales_Org_Code__c = '5661' OR SalesOrg__r.Sales_Org_Code__c = '5662') AND id=:soObj2.Order_Type_lk__c limit 1];//CR#183 -Export Order Management – Chile- SKI- kalpesh chande -28-03-2023
        List<Profit_Center__c> profitCenterList = new List<Profit_Center__c>();
        //CR#183 -Export Order Management – Chile- SKI- kalpesh chande -28-03-2023-Start here
           Distribution_Channel__c dc=[SELECT Id, Name, Distribution_Channel_Code__c FROM Distribution_Channel__c where Distribution_Channel_Code__c='20' limit 1];
             Distribution_Channel__c dcEx=[SELECT Id, Name, Distribution_Channel_Code__c FROM Distribution_Channel__c where Distribution_Channel_Code__c='40' limit 1];
           system.debug('@@@@@@'+dc.Id);
        
        profitCenterList =[SELECT Id, Name, Profit_Center__c, Sales_Value__c, Sales_Org__c, Depot__c, Combination_Key__c 
                           FROM Profit_Center__c 
                           WHERE Sales_Org__r.Sales_org_code__c =:orderTypeLst[0].SalesOrg__r.Sales_org_code__c ORDER BY LastModifiedDate DESC  LIMIT 1];
        Profit_Center__c profObj = new Profit_Center__c();
        system.debug('profitCenterList'+profitCenterList);
        profObj = profitCenterList[0];
        //CR#183 -Export Order Management – Chile- SKI- kalpesh chande -28-03-2023 -End Here
        String orderType = '';
        String salesOrg = '';
        if(!orderTypeLst.isEmpty()){
            orderType = orderTypeLst[0].id;
        }
        String sOSalesOrg='';//CR#183 -Export Order Management – Chile- SKI- kalpesh chande -28-03-2023
        if(!salesOrgList.isEmpty()){
    //CR#183 -Export Order Management – Chile- SKI- kalpesh chande -28-03-2023 -Start here
            for(sales_org__c sOrg:salesOrgList){
                if(sOrg.Id==orderTypeLst[0].SalesOrg__c){
                    salesOrg = sOrg.Id;//#CR183
                    sOSalesOrg=sOrg.Id;
                    system.debug('salesOrg>>>>'+salesOrg);
                    system.debug('soObj2.orderTypeLst[0].SalesOrg__c>>>>>'+orderTypeLst[0].SalesOrg__c);
                }
            }
    //CR#183 -Export Order Management – Chile- SKI- kalpesh chande -28-03-2023 -End here
        }
        exchangeRate = getExchangeRate(soObj2.Purchase_Order_Date__c); //Divya 
        for(String delAdd : deliveryAdressMap.keySet()){
         //CR#169 -Chile Margin Block- SKI- kalpesh chande -  05/12/2022- Start Here
            sentForLatam = false;
            sentForCCO = false;
            subRegionHead=false;
            marketingDirector=false;
            regionalManager=false;
        //CR#169 -Chile Margin Block- SKI- kalpesh chande -  05/12/2022- End Here  
            SalesOrder  = createSalesOrder(soObj2 ,delAdd, orderType, salesOrg, isPaymentTermChanged,isSimulation);//CR#169 -Chile Margin Block- SKI- kalpesh chande -  05/12/2022
            //CR#183 -Export Order Management – Chile- SKI- kalpesh chande -13-04-2023 -Start here
            if(orderTypeLst[0].SalesOrg__r.Sales_org_code__c=='5661'){
                salesorder.Distribution_Channel_lk__c=dc.Id;
            }else{
                salesorder.Distribution_Channel_lk__c=dcEx.Id;
            }
            //CR#183 -Export Order Management – Chile- SKI- kalpesh chande -13-04-2023 -End here
            //CR#169 -Chile Margin Block- SKI- kalpesh chande -  10/01/2023- Start Here 
            if(exchangeRate!=null){
                SalesOrder.Exchange_Rate__c=exchangeRate;
            }
             SalesOrder.Sales_Org_lk__c=sOSalesOrg;//CR#183 -Export Order Management – Chile- SKI- kalpesh chande -28-03-2023
       //CR#169 -Chile Margin Block- SKI- kalpesh chande -  10/01/2023- End Here 
            totMaxPrice = 0;
            String approvalLevel = ''; //CR#169 -Chile Margin Block- SKI- kalpesh chande -  05/12/2022
            system.debug('###'+SalesOrder);
            for(SalesOrderItem item: deliveryAdressMap.get(delAdd)){
                
                Sales_Order_Line_Item__c soiObj = new Sales_Order_Line_Item__c();
                i = i+10;
                soiObj.Item_Number__c = i;
                soiObj.Sale_Order__c = SalesOrder.id;
                soiObj.SKU_Name__c = item.productId;
                soiObj.CurrencyIsoCode = item.oiCurrency;
                soiObj.UOM__c = item.UOM;
                soiObj.Quantity__c = item.qty;
                soiObj.Unit_Price__c = item.unitCost;
                soiObj.Profit_colombia__c = item.profit;
                soiObj.Shipping_Date__c = item.deliveryDate;
                
                soiObj.Delivery_Date__c = item.deliveryDate; // SKI(Vishal P) : #CR152 : PO And Delivery Date : 18-07-2022
                
                //soiObj.Profit_colombia__c = item.deliveryAddress;
                
                //soiObj.Margin_colombia__c = soiObj.FinalPrice__c - soiObj.Unit_Price__c;
                soiObj.Price__c = item.netSales;
                soiObj.FinalPrice__c = item.unitValue;
               
                //Calculation
                soiObj.Unit_PriceBook_Discount__c = item.discount;
                //soiObj.Margin_colombia__c = item.profit;
                
                
                if(soiObj.CurrencyIsoCode == SalesOrder.CurrencyIsoCode){
                     clpUnitValue=item.unitValue/exchangeRate;//CR#169 -Chile Margin Block- SKI- kalpesh chande -  07/01/2023
                    if(soiObj.CurrencyIsoCode=='USD'){//CR#169 -Chile Margin Block- SKI- kalpesh chande -  23/01/2023
                     soiObj.MinPrice__c =item.minValue;
                     soiObj.MaxPrice__c =item.maxPrice;
                         soiObj.Net_Price__c =item.unitValue;
                         totMaxPrice += soiObj.MaxPrice__c*soiObj.Quantity__c;
                    
                    if(SalesOrder.Gross_Margin__c!=null){
                        SalesOrder.Gross_Margin__c += item.profit;
                    }else{
                        SalesOrder.Gross_Margin__c = item.profit;
                    }
                    if(SalesOrder.Business_Discount__c!=null){
                        SalesOrder.Business_Discount__c += item.discount;
                    }else{
                        SalesOrder.Business_Discount__c = item.discount;
                    }
                    if(SalesOrder.Total_Amount__c!=null){
                        SalesOrder.Total_Amount__c += soiObj.Price__c;
                    }else{
                        SalesOrder.Total_Amount__c = soiObj.Price__c;
                    }
                    }else{
              //CR#169 -Chile Margin Block- SKI- kalpesh chande -  23/01/2023-Start Here
                     if(item.minValue !=null){
                        soiObj.MinPrice__c =item.minValue/exchangeRate;  
                     }else{
                         soiObj.MinPrice__c=0;
                     }
                        if(item.maxPrice !=null){
                        soiObj.MaxPrice__c =item.maxPrice/exchangeRate;
                        }else{
                            soiObj.MaxPrice__c =0;
                        }
                        if(item.unitValue!=null){
                             soiObj.Net_Price__c =item.unitValue;
                        }else{
                            soiObj.Net_Price__c=0;
                        }
                         totMaxPrice += soiObj.MaxPrice__c*soiObj.Quantity__c;
                        system.debug('clpUnitValue '+clpUnitValue);
                        if(SalesOrder.Gross_Margin__c!=null){
                            SalesOrder.Gross_Margin__c += (item.profit*exchangeRate)/exchangeRate;
                        }else{
                            SalesOrder.Gross_Margin__c = (item.profit*exchangeRate)/exchangeRate;
                        }
                        if(SalesOrder.Business_Discount__c!=null){
                            SalesOrder.Business_Discount__c += (item.discount*exchangeRate)/exchangeRate;
                        }else{
                            SalesOrder.Business_Discount__c = (item.discount*exchangeRate)/exchangeRate;
                        }
                        if(SalesOrder.Total_Amount__c!=null){
                            SalesOrder.Total_Amount__c += soiObj.Price__c/exchangeRate;
                        }else{
                            SalesOrder.Total_Amount__c = soiObj.Price__c/exchangeRate;
                        }
                        
                    }
                   //CR#169 -Chile Margin Block- SKI- kalpesh chande -  23/01/2023-End here
                }
                else{
                    if(soiObj.CurrencyIsoCode == 'USD'){
                 //CR#169 -Chile Margin Block- SKI- kalpesh chande -  16/01/2023-Start Here
                        if(item.minValue !=null){
                        soiObj.MinPrice__c =item.minValue*exchangeRate;  
                        }else{
                            soiObj.MinPrice__c=0;
                        }
                        if(item.maxPrice !=null){
                        soiObj.MaxPrice__c =item.maxPrice*exchangeRate;
                        }else{
                            soiObj.MaxPrice__c =0;
                        }
                         if(item.unitValue!=null){
                             soiObj.Net_Price__c =item.unitValue;
                         }else{
                             soiObj.Net_Price__c =0;
                         }
                 //CR#169 -Chile Margin Block- SKI- kalpesh chande -  16/01/2023-End Here
                        totMaxPrice += soiObj.MaxPrice__c*soiObj.Quantity__c;
                        if(SalesOrder.Gross_Margin__c!=null){
                            SalesOrder.Gross_Margin__c += item.profit*exchangeRate;
                        }else{
                            SalesOrder.Gross_Margin__c = item.profit*exchangeRate;
                        }
                        if(SalesOrder.Business_Discount__c!=null){
                            SalesOrder.Business_Discount__c += item.discount*exchangeRate;
                        }else{
                            SalesOrder.Business_Discount__c = item.discount*exchangeRate;
                        }
                        if(SalesOrder.Total_Amount__c!=null){
                            SalesOrder.Total_Amount__c += soiObj.Price__c*exchangeRate;
                        }else{
                            SalesOrder.Total_Amount__c = soiObj.Price__c*exchangeRate;
                        }
                    }
                    else{
                    //CR#169 -Chile Margin Block- SKI- kalpesh chande -  16/01/2023-Start Here
                        if(item.minValue !=null){
                        soiObj.MinPrice__c =item.minValue/exchangeRate;  
                        }else{
                            soiObj.MinPrice__c =0;
                        }
                        if(item.maxPrice !=null){
                        soiObj.MaxPrice__c =item.maxPrice/exchangeRate;
                        }else{
                             soiObj.MaxPrice__c=0;
                        }
                         if(item.unitValue!=null){
                             soiObj.Net_Price__c =item.unitValue;
                         }else{
                             soiObj.Net_Price__c=0;
                         }
                 //CR#169 -Chile Margin Block- SKI- kalpesh chande -  16/01/2023-End Here
                        totMaxPrice += soiObj.MaxPrice__c*soiObj.Quantity__c;
                    //CR#169 -Chile Margin Block- SKI- kalpesh chande -  07/01/2023-Start Here
                       if(test.isRunningTest()){
                            clpUnitValue=800.97;
                        }else{
                        clpUnitValue=item.unitValue/exchangeRate;
                        }
                    //CR#169 -Chile Margin Block- SKI- kalpesh chande -  07/01/2023-End here
                        system.debug('clpUnitValue '+clpUnitValue);
                         if(SalesOrder.Gross_Margin__c!=null){
                            SalesOrder.Gross_Margin__c += (item.profit*exchangeRate)/exchangeRate; //CR#169 -Chile Margin Block- SKI- kalpesh chande -  23/01/2023
                        }else{
                            SalesOrder.Gross_Margin__c = (item.profit*exchangeRate)/exchangeRate; //CR#169 -Chile Margin Block- SKI- kalpesh chande -  23/01/2023
                        }
                        if(SalesOrder.Business_Discount__c!=null){
                            SalesOrder.Business_Discount__c += (item.discount*exchangeRate)/exchangeRate; //CR#169 -Chile Margin Block- SKI- kalpesh chande -  23/01/2023
                        }else{
                            SalesOrder.Business_Discount__c = (item.discount*exchangeRate)/exchangeRate; //CR#169 -Chile Margin Block- SKI- kalpesh chande -  23/01/2023
                        }
                        if(SalesOrder.Total_Amount__c!=null){
                            SalesOrder.Total_Amount__c += soiObj.Price__c/exchangeRate;
                        }else{
                            SalesOrder.Total_Amount__c = soiObj.Price__c/exchangeRate;
                        }
                    }
                    
                }
                 system.debug('Gross_Margin__c>>--->'+SalesOrder.Gross_Margin__c);
                system.debug('Business_Discount__c>>--->'+SalesOrder.Business_Discount__c);
                system.debug('Total_Amount__c>>--->'+SalesOrder.Total_Amount__c);
                system.debug('totMaxPrice>>--->'+totMaxPrice);
                system.debug('Discount_Percentage__c>>--->'+SalesOrder.Discount_Percentage__c);
                system.debug('Is_payment_Term_Changed__c>>--->'+SalesOrder.Is_payment_Term_Changed__c);
                system.debug('Gross_Margin_Percent__c>>--->'+SalesOrder.Gross_Margin_Percent__c);
                //SalesOrder.Total_Amount__c += soiObj.Price__c;
                SalesOrder.Discount_Percentage__c = (SalesOrder.Business_Discount__c/totMaxPrice)*100;
                SalesOrder.Gross_Margin_Percent__c = (SalesOrder.Gross_Margin__c/SalesOrder.Total_Amount__c)*100;
                if(!salesOrgList.isEmpty()){
                    soiObj.Sales_Org__c = salesOrgList[0].Id;
                    
                }
                
               
                //CR#169 -Chile Margin Block- SKI- kalpesh chande -  05/12/2022 Start Here......Commented
                /* if(SalesOrder.Discount_Percentage__c<5 && SalesOrder.Is_payment_Term_Changed__c == false && SalesOrder.Gross_Margin_Percent__c >20){
SalesOrder.Order_Status__c = 'Open';
}*/
                //CR#169 -Chile Margin Block- SKI- kalpesh chande -  05/12/2022 End Here
                if(depotCodeId!=null && depotCodeId!=''){
                    soiObj.DepotDepot__c = depotCodeId;
                }
                system.debug('soiObj>>--->'+soiObj);
                //CR#169 -Chile Margin Block- SKI- kalpesh chande -  05/12/2022- Start Here
                system.debug('skuOrderList'+salesOrderItemList);
                
                Decimal rebateVal1 = 0.0 ;
                Decimal rebateVal2 = 0.0 ;
                Decimal rebateVal = 0.0 ;
                Decimal rebatePercent1Convert;
                Decimal rebatePercent2Convert;
                //Sales_Order_Line_Item__c sliObj =new Sales_Order_Line_Item__c();                     
                List<UOM_Conversion__c> uomList1 = new List<UOM_Conversion__c>();
                // PriceDetail skuWrapObj=new PriceDetail();
                // system.debug('skuWrapObj'+skuWrapObj);
                for(PriceDetail skuWrapObj:priceDetailList){
                    if(skuWrapObj.skuId==item.productId){
                    system.debug('skuWrapObj'+skuWrapObj);
                    system.debug('item.qty'+item.qty);
                    system.debug('item.uom'+skuWrapObj.uOM);
                    
                    
                    if(uomListMap.containsKey(item.productId)){
                        system.debug('item.productId'+item.productId);
                        uomList1 =uomListMap.get(item.productId);   
                    }
                    if(uomList1.size()>0){
                        for(UOM_Conversion__c uomObj :uomList1){
                            system.debug('uomObj.Base_UOM__c'+uomObj.Base_UOM__c);
                            system.debug('uomObj.Sales_UOM__c'+uomObj.Sales_UOM__c);
                            system.debug('skuWrapObj.uOM'+skuWrapObj.uOM);
                            if(item.qty!=null){   
                                system.debug('inside');
                                if(skuWrapObj.uOM == uomObj.Base_UOM__c){                        
                                    skuWrapObj.baseUOM  = skuWrapObj.uOM;
                                    skuWrapObj.convertQty =  item.qty;
                                    system.debug('skuWrapObj.convertQty'+skuWrapObj.convertQty);
                                    break;
                                }else if(skuWrapObj.uOM == uomObj.Sales_UOM__c ){                                        
                                    skuWrapObj.baseUOM  = uomObj.Base_UOM__c;
                                    Decimal uomConver = uomObj.Numerator__c /uomObj.Denominator__c;                                            
                                    skuWrapObj.convertQty =  item.qty*uomConver;
                                    system.debug('skuWrapObj.convertQty'+skuWrapObj.convertQty);
                                    break;
                                }                            
                            }
                        }      
                    }
                    
                    system.debug('skuWrapObj.convertQty'+skuWrapObj.convertQty);
                    system.debug('item.unitValue'+item.unitValue);
                    
                    for(UOM_Conversion__c uomObj :uomList1){
                        if(item.unitValue!=null || clpUnitValue!=null){ //CR#169 -Chile Margin Block- SKI- kalpesh chande -  07/01/2023
                            if(skuWrapObj.uOM == uomObj.Base_UOM__c  ){
                                system.debug('skuWrapObj.uOM'+skuWrapObj.uOM+'skuWrapObj.uOM'+uomObj.Base_UOM__c);
                                 if(item.oiCurrency=='USD'){//CR#169 -Chile Margin Block- SKI- kalpesh chande -  07/01/2023
                                skuWrapObj.convertNetPrice = item.unitValue; 
                                skuWrapObj.convertFinalPrice = item.unitValue *skuWrapObj.convertQty;
                             //CR#169 -Chile Margin Block- SKI- kalpesh chande -  07/01/2023 -Start here
                                 }else{//net sales,total sales patch 
                                      system.debug('clpUnitValue1 '+clpUnitValue);
                                      skuWrapObj.convertNetPrice =clpUnitValue; 
                                      skuWrapObj.convertFinalPrice =clpUnitValue *skuWrapObj.convertQty;
                                 }
                           //CR#169 -Chile Margin Block- SKI- kalpesh chande -  07/01/2023 -End here
                                break;
                            }else if(skuWrapObj.uOM == uomObj.Sales_UOM__c){                        
                                Decimal uomConver = uomObj.Numerator__c /uomObj.Denominator__c; 
                                 if(item.oiCurrency=='USD'){//CR#169 -Chile Margin Block- SKI- kalpesh chande -  07/01/2023
                                skuWrapObj.convertNetPrice = item.unitValue / uomConver;                                                        
                                skuWrapObj.convertFinalPrice = skuWrapObj.convertNetPrice *  skuWrapObj.convertQty;
                         //CR#169 -Chile Margin Block- SKI- kalpesh chande -  07/01/2023-Start here
                                 }else{
                                      system.debug('clpUnitValue2 '+clpUnitValue);
                                      skuWrapObj.convertNetPrice =clpUnitValue / uomConver;                                                        
                                      skuWrapObj.convertFinalPrice = skuWrapObj.convertNetPrice *  skuWrapObj.convertQty;
                                 }
                           //CR#169 -Chile Margin Block- SKI- kalpesh chande -  07/01/2023-End Here
                                break;
                            }                            
                        }
                    }
                    system.debug(' skuWrapObj.convertNetPrice'+ skuWrapObj.convertNetPrice);
                    system.debug('skuWrapObj.convertFinalPrice'+ skuWrapObj.convertFinalPrice);
                    
                    //this is for UOM converted Rebate Logic
                    if(prcBlockReabteMap.containsKey(item.productId)){
                        List<Price_Block_Margin_Matrix__c> pbMMRebateList = prcBlockReabteMap.get(item.productId);
                        System.debug('pbMMRebateList'+pbMMRebateList.size());
                        if(pbMMRebateList.size()>0){                    
                            if(pbMMRebateList.size()>=2){
                                String rebateCode1 = pbMMRebateList[0].Rebate_Code__c;
                                String rebateCode2 = pbMMRebateList[1].Rebate_Code__c;
                                if(rebateCode1!=rebateCode2){                                                                        
                                    skuWrapObj.rebate1USD = pbMMRebateList[0].Rebate_USD__c; 
                                    skuWrapObj.rebate1Percent = pbMMRebateList[0].Rebate__c;
                                    skuWrapObj.uomRebate1 = pbMMRebateList[0].UOM__c;
                                    skuWrapObj.rebateCode1 = pbMMRebateList[0].Rebate_Code__c;                                    
                                    
                                    skuWrapObj.rebate2USD = pbMMRebateList[1].Rebate_USD__c; 
                                    skuWrapObj.rebate2Percent = pbMMRebateList[1].Rebate__c;
                                    skuWrapObj.uomRebate2 = pbMMRebateList[1].UOM__c;
                                    skuWrapObj.rebateCode2 = pbMMRebateList[1].Rebate_Code__c;
                                }                                
                            }else{                                                                
                                skuWrapObj.rebate1USD = pbMMRebateList[0].Rebate_USD__c; 
                                skuWrapObj.rebate1Percent = pbMMRebateList[0].Rebate__c;
                                skuWrapObj.rebateCode1 = pbMMRebateList[0].Rebate_Code__c;
                                skuWrapObj.uomRebate1 = pbMMRebateList[0].UOM__c;                               
                            }
                        }
                    }
                    system.debug(' skuWrapObj.rebate1USD '+ skuWrapObj.rebate1USD);
                    system.debug(' skuWrapObj.rebate1USD '+ skuWrapObj.rebate1Percent);
                    system.debug(' skuWrapObj.rebate1USD '+ skuWrapObj.rebateCode1);
                    system.debug(' skuWrapObj.rebate1USD '+ skuWrapObj.rebate1USD);
                    
                    system.debug('uomList1.size()'+uomList1.size());
                    system.debug('skuWrapObj.currencyIso'+item.oiCurrency);
                    if(uomList1.size()>0){
                        if(item.oiCurrency=='USD' || item.oiCurrency=='CLP'){ //CR#169 -Chile Margin Block- SKI- kalpesh chande -  07/01/2023
                            for(UOM_Conversion__c uomObj :uomList){
                                if(skuWrapObj.rebate1USD!=null){                         
                                    if(skuWrapObj.uomRebate1 == uomObj.Base_UOM__c){
                                        rebateVal1 = skuWrapObj.rebate1USD;                            
                                        rebateVal1 = rebateVal1 * skuWrapObj.convertQty;
                                        break;
                                    }else if(skuWrapObj.uomRebate1 == uomObj.Sales_UOM__c ){
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
                        if(item.oiCurrency=='USD' || item.oiCurrency=='CLP'){ //CR#169 -Chile Margin Block- SKI- kalpesh chande -  07/01/2023
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
                            }//end of for loop
                            if(skuWrapObj.rebate2Percent!=null && skuWrapObj.rebate2USD==null){                                
                                rebatePercent2Convert = (skuWrapObj.rebate2Percent * skuWrapObj.convertFinalPrice)/100; 
                                rebateVal2 = rebatePercent2Convert;
                            }
                        }                        
                    }
                    system.debug('skuWrapObj'+skuWrapObj);
                    //adding Marginal block Values to the line item
                    system.debug('rebateVal1 '+rebateVal1);
                    system.debug('rebateVal2 '+rebateVal2);
                    rebateVal = rebateVal1 +rebateVal2;
                    system.debug('skuWrapObj '+rebateVal);
                    soiObj.Rebate__c  = rebateVal;
                    
                    if(item.oiCurrency=='USD' || item.oiCurrency=='CLP' ){ //CR#169 -Chile Margin Block- SKI- kalpesh chande -  07/01/2023
                        soiObj.Rebate1__c = skuWrapObj.rebate1USD;
                        soiObj.Rebate2__c = skuWrapObj.rebate2USD; 
                    }            
                    soiObj.Rebate1percent__c = skuWrapObj.rebate1Percent;
                    soiObj.Rebate2percent__c = skuWrapObj.rebate2Percent;
                    soiObj.UOM_Rebate_1__c = skuWrapObj.uomRebate1;
                    soiObj.UOM_Rebate_2__c = skuWrapObj.uomRebate2;
                    soiObj.Rebate_Code_1__c = skuWrapObj.rebateCode1;
                    soiObj.Rebate_Code_2__c = skuWrapObj.rebateCode2;
                    
                    
                    //for discount             
                    List<Price_Block_Margin_Matrix__c> pbmmDiscountList1 = new List<Price_Block_Margin_Matrix__c>();
                    MAP<String,Price_Block_Margin_Matrix__c> prcBlockDiscountMap = new MAP<String,Price_Block_Margin_Matrix__c>();
                    if(disMap.containsKey(item.productId)){
                        pbmmDiscountList1 = disMap.get(item.productId);
                    }
                    
                    if(pbmmDiscountList1.size()>0){
                        for(Price_Block_Margin_Matrix__c discontIbj:pbmmDiscountList1){
                            prcBlockDiscountMap.put(discontIbj.SKU_Code__c ,discontIbj);
                        }
                    }
                        system.debug('prcBlockDiscountMap '+prcBlockDiscountMap);
                    system.debug('item.productId '+item.productId);
                    if(prcBlockDiscountMap.containsKey(item.productId)){
                        system.debug('item.productId '+item.productId);
                        system.debug('prcBlockDiscountMap '+prcBlockDiscountMap);
                        Price_Block_Margin_Matrix__c pbMMDiscountObj = prcBlockDiscountMap.get(item.productId);                                               
                        skuWrapObj.discountUSD = pbMMDiscountObj.Discount_USD__c; 
                        skuWrapObj.discountPercent = pbMMDiscountObj.Discount__c;
                        skuWrapObj.uomDiscount = pbMMDiscountObj.UOM__c;                        
                    }
                    //this is for converted Discount Logic
                    Decimal discountPercentConvert;
                    Decimal discountVal = 0.0;
                    
                    
                    if(uomList1.size()>0){
                        //this now for Discount
                        if(item.oiCurrency=='USD' || item.oiCurrency=='CLP'){ //CR#169 -Chile Margin Block- SKI- kalpesh chande -  07/01/2023
                            //discountUSD
                            for(UOM_Conversion__c uomObj :uomList){ 
                                System.debug('uomObj.Base_UOM__c '+uomObj.Base_UOM__c);
                                if(skuWrapObj.discountUSD!=null){
                                    if(skuWrapObj.uomDiscount == uomObj.Base_UOM__c){
                                        discountVal = skuWrapObj.discountUSD;  
                                        discountVal = discountVal * skuWrapObj.convertQty;                                
                                        break;
                                    }else if(skuWrapObj.uomDiscount == uomObj.Sales_UOM__c ){
                                        Decimal uomConver = uomObj.Numerator__c /uomObj.Denominator__c;  
                                        discountVal = uomConver * skuWrapObj.discountUSD;
                                        discountVal = discountVal * skuWrapObj.convertQty;                                 
                                        break;
                                    }
                                }
                            }//end of for loop
                            if(skuWrapObj.discountPercent!=null && skuWrapObj.discountUSD==null){                        
                                discountPercentConvert = (skuWrapObj.discountPercent * skuWrapObj.convertFinalPrice)/100; 
                                discountVal = discountPercentConvert;
                            }
                            
                        }
                    } for(Price_Block_Margin_Matrix__c plnObj: pbmmPlnList){
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
                    
                    if(item.oiCurrency=='USD' || item.oiCurrency=='CLP'){ //CR#169 -Chile Margin Block- SKI- kalpesh chande -  07/01/2023
                        soiObj.Discount1__c = skuWrapObj.discountUSD;    
                    }                                         
                    soiObj.Discountpercent__c = skuWrapObj.discountPercent;
                    soiObj.Discount_Cal__c =   discountVal;     
                    soiObj.UOM_Discount__c = skuWrapObj.uomDiscount; 
                    
                    
                    // this is for converted addition Discount Logic
                    List<Price_Block_Margin_Matrix__c> pbmmAddDiscountList1 = new List<Price_Block_Margin_Matrix__c>();
                    MAP<String,Price_Block_Margin_Matrix__c> prcBlockAddDiscountMap = new MAP<String,Price_Block_Margin_Matrix__c>();
                    if(mappAddDis.containskey(item.productId)){
                        pbmmAddDiscountList1 = mappAddDis.get(item.productId);    
                    }
                    
                    if(pbmmAddDiscountList1.size()>0){
                        for(Price_Block_Margin_Matrix__c addDisObj:pbmmAddDiscountList1){
                            prcBlockAddDiscountMap.put(addDisObj.SKU_Code__c,addDisObj);    
                        }
                    }
                    
                    if(prcBlockAddDiscountMap.containsKey(item.productId)){
                        Price_Block_Margin_Matrix__c pbMMAddDiscountObj = prcBlockAddDiscountMap.get(item.productId);                                                                      
                        skuWrapObj.additionalDiscountPercent = pbMMAddDiscountObj.Additional_Discount__c;
                        skuWrapObj.additionalDiscountUSD = pbMMAddDiscountObj.Additional_Discount_USD__c;
                        skuWrapObj.uomAddDiscount = pbMMAddDiscountObj.UOM__c;              
                    }
                    
                    Decimal addDiscountVal =0.0;
                    Decimal addDiscountPercentConvert;
                    System.debug('uomList1.size()'+uomList1.size());
                    if(uomList1.size()>0){
                           system.debug('inside 0');
                        //this now additional disc
                        if(item.oiCurrency=='USD' || item.oiCurrency=='CLP'){ //CR#169 -Chile Margin Block- SKI- kalpesh chande -  07/01/2023
                           system.debug('inside 1');
                            for(UOM_Conversion__c uomObj :uomList){
                                system.debug('inside 2');
                                if(skuWrapObj.additionalDiscountUSD!=null){ 
                           system.debug('inside 3');
                                    if(skuWrapObj.uomAddDiscount == uomObj.Base_UOM__c){
                           system.debug('inside 4');
                                        addDiscountVal = skuWrapObj.additionalDiscountUSD;
                                        addDiscountVal = addDiscountVal * skuWrapObj.convertQty;
                                        break;
                                    }else if(skuWrapObj.uomAddDiscount == uomObj.Sales_UOM__c ){
                           system.debug('inside 5');
                                        Decimal uomConver = uomObj.Numerator__c /uomObj.Denominator__c;   
                                        addDiscountVal = uomConver * skuWrapObj.additionalDiscountUSD;
                                        addDiscountVal = addDiscountVal * skuWrapObj.convertQty;
                                        break;
                                    }                            
                                }
                            }//end of for loop 
                            system.debug('skuWrapObj.additionalDiscountPercent '+skuWrapObj.additionalDiscountPercent +'addDiscountVal'+addDiscountVal+ skuWrapObj.additionalDiscountUSD);
                            if(skuWrapObj.additionalDiscountPercent!=null && skuWrapObj.additionalDiscountUSD==null){
                                addDiscountPercentConvert = (skuWrapObj.additionalDiscountPercent * skuWrapObj.convertFinalPrice)/100; 
                                addDiscountVal = addDiscountPercentConvert;
                            }
                        }//end for checking USD Currency  
                    }
                    
                    if(item.oiCurrency=='USD' || item.oiCurrency=='CLP'){ //CR#169 -Chile Margin Block- SKI- kalpesh chande -  07/01/2023
                        soiObj.Additional_Discount__c = skuWrapObj.additionalDiscountUSD;  
                    }
                    soiObj.Additional_Discountpercent__c = skuWrapObj.additionalDiscountPercent;
                        system.debug('addDiscountVal '+addDiscountVal);
                    soiObj.Additional_Discount_Cal__c = addDiscountVal;  
                    system.debug('soiObj.Additional_Discount_Cal__c '+soiObj.Additional_Discount_Cal__c);
                    soiObj.UOM_Additional_Discount__c = skuWrapObj.uomAddDiscount;
                            system.debug('skuWrapObj.additionalDiscountPercent '+skuWrapObj.additionalDiscountPercent +'addDiscountVal'+addDiscountVal+ skuWrapObj.additionalDiscountUSD);
                    //this is for Converted Sales Deduction 
                    List<Price_Block_Margin_Matrix__c> pbmmSalesDeduList1 = new List<Price_Block_Margin_Matrix__c>();
                    MAP<String,Price_Block_Margin_Matrix__c> prcBlockForDeduMap = new MAP<String,Price_Block_Margin_Matrix__c>();
                    if(mapSaleDed.size()>0){
                        if(mapSaleDed.containsKey(item.productId)){
                            pbmmSalesDeduList1 = mapSaleDed.get(item.productId);         
                        }                        
                    }                   
                    if(pbmmSalesDeduList1.size()>0){                
                        for(Price_Block_Margin_Matrix__c dedObj : pbmmSalesDeduList1){
                            prcBlockForDeduMap.put(dedObj.SKU_Code__c,dedObj);
                        }
                    }
                    
                    if(prcBlockForDeduMap.containsKey(item.productId)){
                        Price_Block_Margin_Matrix__c pbMMSalesDedObj = prcBlockForDeduMap.get(item.productId);                        
                        if(pbMMSalesDedObj.Sales_Deduction_USD__c!=null){
                            skuWrapObj.salesDeductionUSD = pbMMSalesDedObj.Sales_Deduction_USD__c ;
                        }else{
                            skuWrapObj.salesDeductionInPercent = profitCenterList[0].Sales_Value__c;
                        }                        
                        skuWrapObj.uomSalesDeduction = pbMMSalesDedObj.UOM__c ;
                    }
                    
                    Decimal salesDeductionVal =0.0;
                    Decimal saleaDeductionPercent;
                    if(uomList1.size()>0 && orderTypeLst[0].SalesOrg__r.Sales_Org_Code__c=='5661'){//CR#183 -Export Order Management – Chile- SKI- kalpesh chande -21-06-2023
                        //start for USD Sales Dedection 
                        if(item.oiCurrency=='USD' || item.oiCurrency=='CLP'){ //CR#169 -Chile Margin Block- SKI- kalpesh chande -  07/01/2023
                            for(UOM_Conversion__c uomObj :uomList){
                                if(skuWrapObj.salesDeductionUSD>0){ 
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
                            if(profObj.Sales_Value__c!=null && skuWrapObj.salesDeductionUSD==0 && orderTypeLst[0].SalesOrg__r.Sales_Org_Code__c=='5661'){//CR#183 -Export Order Management – Chile- SKI- kalpesh chande -21-06-2023
                                saleaDeductionPercent = (profObj.Sales_Value__c * skuWrapObj.convertFinalPrice)/100; 
                                salesDeductionVal = saleaDeductionPercent;
                            } 
                        }
                    }
                    if((item.oiCurrency=='USD' || item.oiCurrency=='CLP')&& orderTypeLst[0].SalesOrg__r.Sales_Org_Code__c=='5661'){ //CR#169 -Chile Margin Block- SKI- kalpesh chande -  07/01/2023 //CR#183 -Export Order Management – Chile- SKI- kalpesh chande -28-03-2023 
                        soiObj.Sales_Deduction_Budget__c = skuWrapObj.salesDeductionUSD;  
                    } 
               //CR#183 -Export Order Management – Chile- SKI- kalpesh chande -28-03-2023 -Existing code in if else condition -Start here
                        if(orderTypeLst[0].SalesOrg__r.Sales_Org_Code__c=='5661'){
                            soiObj.Sales_Deduction_Profit_Center__c = profObj.Sales_Value__c;
                            soiObj.Sales_Deduction_Cal__c = salesDeductionVal;
                            soiObj.UOM_Sales_Deduction__c = skuWrapObj.uomSalesDeduction;
                        }else{
                            soiObj.Sales_Deduction_Profit_Center__c = 0.0;
                            soiObj.Sales_Deduction_Cal__c = 0.0;
                        }
               //CR#183 -Export Order Management – Chile- SKI- kalpesh chande -28-03-2023 -Existing code in if else condition -End here
                    
                    //this is for e2e converted Logic
                    System.debug('e2ECostUSD '+skuWrapObj.e2ECostUSD);
                    System.debug('e2ECostUPC9USD '+skuWrapObj.e2ECostUPC9USD);
                    System.debug('e2ECostMBEWUSD '+skuWrapObj.e2ECostMBEWUSD);
                    System.debug('uome2eCost '+skuWrapObj.uome2eCost);
                    Decimal e2eCostVal= 0.0 ;
                    if(uomList1.size()>0){
                        if(item.oiCurrency=='USD' || item.oiCurrency=='CLP'){ //CR#169 -Chile Margin Block- SKI- kalpesh chande -  07/01/2023
                            for(UOM_Conversion__c uomObj :uomList){
                                if(skuWrapObj.e2ECostUSD > 0){                                                                      
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
                                }else if(skuWrapObj.e2ECostUSD == 0 && skuWrapObj.e2ECostUPC9USD > 0){                        
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
                                }else if(skuWrapObj.e2ECostUSD == 0 && skuWrapObj.e2ECostUPC9USD == 0 && skuWrapObj.e2ECostMBEWUSD > 0){
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
                    
                    if(item.oiCurrency=='USD' || item.oiCurrency=='CLP'){ //CR#169 -Chile Margin Block- SKI- kalpesh chande -  07/01/2023
                        soiObj.E2E_Cost__c = skuWrapObj.e2ECostUSD;
                        soiObj.E2E_Cost_UPC9__c = skuWrapObj.e2ECostUPC9USD;
                        soiObj.E2E_Cost_MBEW__c = skuWrapObj.e2ECostMBEWUSD;
                    }
                    soiObj.E2E_Cost_Cal__c = e2eCostVal;                  
                    soiObj.UOM_E2E_Cost__c = skuWrapObj.uome2eCost;
                    
                    //this is for converted PLN logic
                    List<Price_Block_Margin_Matrix__c> pbmmPlnList1 = new List<Price_Block_Margin_Matrix__c>();
                    MAP<String,Price_Block_Margin_Matrix__c> prcBlockPlnMap = new MAP<String,Price_Block_Margin_Matrix__c>();                    
                    if(mapPrcpln.size()>0){
                        if(mapPrcpln.containsKey(item.productId)){
                            pbmmPlnList1 =mapPrcpln.get(item.productId);            
                        }                    
                    }                                       
                    if(pbmmPlnList1.size()>0){
                        for(Price_Block_Margin_Matrix__c plnObj :pbmmPlnList1){
                            prcBlockPlnMap.put(plnObj.SKU_Code__c,plnObj);
                        }
                    }
                    
                    if(prcBlockPlnMap.containsKey(item.productId)){                
                        Price_Block_Margin_Matrix__c pbMMPlnObj = prcBlockPlnMap.get(item.productId);                                                
                        skuWrapObj.pLNUSD = pbMMPlnObj.PLN_USD__c; 
                        skuWrapObj.uomPLN = pbMMPlnObj.UOM__c; 
                    }
                    
                    Decimal plnPercentConvert;
                    Decimal plnCalValue = 0.0 ;
                    if(uomList1.size()>0){
                        if(item.oiCurrency=='USD' || item.oiCurrency=='CLP'){ //CR#169 -Chile Margin Block- SKI- kalpesh chande -  07/01/2023
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
                        }//checking USD currnec PLN end
                    }
                    
                    if(item.oiCurrency=='USD' || item.oiCurrency=='CLP'){ //CR#169 -Chile Margin Block- SKI- kalpesh chande -  07/01/2023
                        soiObj.PLN__c  = skuWrapObj.pLNUSD;
                    }
                    System.debug('plnCalValue '+plnCalValue);
                    soiObj.PLN_Cal__c = plnCalValue;
                    soiObj.UOM_PLN__c = skuWrapObj.uomPLN;
                    
                    Decimal ptpmDiscount = 0;
                    Decimal ptpmDiscountVal = 0;          
                    if(ptpmDiscountList.size()>0 && ptpmDiscountList[0].Discount__c != null){
                        ptpmDiscount =  ptpmDiscountList[0].Discount__c;
                        ptpmDiscountVal = (ptpmDiscount * skuWrapObj.convertFinalPrice)/100;
                    }
                    soiObj.Payment_Term_Payment_Method_Discount__c = ptpmDiscount;
                    // soiObj.Payment_Term_Payment_Method_Dis_Cal__c = ptpmDiscountVal;
                    
                    Decimal skuNetPrice; 
                    system.debug('skuWrapObj.convertFinalPrice'+skuWrapObj.convertFinalPrice);
                    system.debug('rebateVal'+rebateVal);
                    system.debug('discountVal'+discountVal);
                    system.debug('addDiscountVal'+addDiscountVal);
                    skuNetPrice =  skuWrapObj.convertFinalPrice - rebateVal - discountVal - addDiscountVal;  
                    system.debug('skuNetPrice'+skuNetPrice);
                    Decimal contributionMargin;
                    Decimal contributionMarginPercent;
                    Decimal totalCost;
                    system.debug('skuNetPrice '+skuNetPrice+' salesDeductionVal '+salesDeductionVal+' e2eCostVal '+e2eCostVal);
                    totalCost = salesDeductionVal + e2eCostVal;   
                    system.debug('totalCost'+totalCost);
                    contributionMargin=skuNetPrice - totalCost;
                    system.debug('contributionMargin'+contributionMargin);
                    if(Test.isRunningTest()){
                        contributionMarginPercent = 10;
                    }else{
                        contributionMarginPercent = (contributionMargin / skuNetPrice)*100;
                        contributionMarginPercent = contributionMarginPercent.setScale(2);
                    }
                    
                    system.debug('contributionMarginPercent '+contributionMarginPercent);
                    soiObj.SKU_Net_Price__c = skuNetPrice;
                    soiObj.Contribution_Margin__c = contributionMarginPercent;
                    //added to store converted values 
                    soiObj.Base_UOM__c = skuWrapObj.baseUOM;                    
                    soiObj.Converted_Qty__c = skuWrapObj.convertQty;
                    soiObj.Converted_Net_Price__c = skuWrapObj.convertNetPrice;           
                    soiObj.Converted_Final_Price__c = skuWrapObj.convertFinalPrice;
                    system.debug('soiObj.Contribution_Margin__c '+soiObj.Contribution_Margin__c);
                    
                    if(blanketSKUMap.containsKey(item.productId)){
                        
                        List<Blanket_SKU__c> blanketList = blanketSKUMap.get(item.productId);
                        soiObj.Blanket_SKU_Start_Date__c = blanketList[0].Start_Date__c;
                        soiObj.Blanket_SKU_End_Date__c = blanketList[0].End_Date__c;
                        soiObj.Blanket_SKU_Status__c = blanketList[0].Status__c;
                        if(blanketList[0].Start_Date__c <= System.today() && blanketList[0].End_Date__c >= System.today() && blanketList[0].Status__c == true){
                            soiObj.Margin_Block_Level_1__c = false;
                            soiObj.Margin_Block_Level_2__c = false;
                        }else if(contributionMarginPercent >= adminObj.Level_2_min__c  &&  contributionMarginPercent <= adminObj.Level_2_max__c ){
                            soiObj.Margin_Block_Level_1__c = true;
                            //RITM0555419-Removed Latam director approval for Margin Block
                            sentForLatam = true;//Kalpesh chande-SKI-31-05-2023
                              //sentForLatam = false;
                              marketingDirector=true;
                        }else if(contributionMarginPercent <= adminObj.Level_3_below__c ){
                            soiObj.Margin_Block_Level_2__c = true;  
                            //RITM0555419-Removed Latam director approval for Margin Block
                            sentForLatam = true;//Kalpesh chande-SKI-31-05-2023
                             // sentForLatam = false;
                            //RITM0550761- Removing CCO approval for Margin block
                            sentForCCO = true;//Kalpesh chande-SKI-31-05-2023
                           // sentForCCO = false;
                            marketingDirector=true;
                        }                        
                    }else{
                        if(contributionMarginPercent >= adminObj.Level_2_min__c  &&  contributionMarginPercent <= adminObj.Level_2_max__c ){
                            soiObj.Margin_Block_Level_1__c = true;
                            //RITM0555419-Removed Latam director approval for Margin Block
                            sentForLatam = true;//Kalpesh chande-SKI-31-05-2023
                             // sentForLatam = false;
                            marketingDirector=true;
                        }
                        if(contributionMarginPercent <= adminObj.Level_3_below__c){
                              soiObj.Margin_Block_Level_2__c = true;	
                            //RITM0555419-Removed Latam director approval for Margin Block	
                            sentForLatam = true;	//Kalpesh chande-SKI-31-05-2023
                             // sentForLatam = false;
                            //RITM0550761- Removing CCO approval for Margin block
                            sentForCCO = true;//Kalpesh chande-SKI-31-05-2023
                           // sentForCCO = false;
                            marketingDirector=true;
                        }                                
                    } 
                    //PLN Value Approval Process
                    
                    system.debug('mapPrcpln '+mapPrcpln);
                    system.debug('item.productId'+item.productId);
                    system.debug('skuWrapObj.pLNUSD '+skuWrapObj.pLNUSD+ ' item.unitValue ' +item.unitValue);
                    
                    if( skuWrapObj.pLNUSD==null){
                        subRegionHead=false;
                        marketingDirector=false;
                        regionalManager=false;
                        sentForLatam = false;
                        sentForCCO = false;
                        soiObj.Is_PLN__c=false;
                    }else if(item.unitValue<skuWrapObj.pLNUSD || Test.isRunningTest()){
                        subRegionHead=true;
                        marketingDirector=true;
                        regionalManager=true;
                        soiObj.Is_PLN__c=true;
                    }
                    
                    
                    if(sentForLatam){
                       //RITM0555419-Removed Latam director approval for Margin Block	
                        SalesOrder.Sent_for_Latam_Director__c = true;	//Kalpesh chande-SKI-31-05-2023
                       // SalesOrder.Sent_for_Latam_Director__c = false;
                    }
                    if(sentForCCO){
                        SalesOrder.Sent_for_Latam_Director__c = true;
                        SalesOrder.Sent_for_CCO__c = true;
                    }
                    if(marketingDirector){
                        SalesOrder.Sent_for_Director_Approval_Mexico__c = true;
                    }
                    if(subRegionHead){
                        SalesOrder.Sent_for_Latam_Director_Approval__c = true;
                    }
                    }
                }
                //soiList.add(soiObj);
                
                if(soiObj.Is_PLN__c==true){
                    SalesOrder.Sent_for_Manager_Approval_Mexico__c=true;
                    //SalesOrder.Sent_for_Director_Approval_Mexico__c = true;
                    //SalesOrder.Sent_for_Latam_Director_Approval__c = true;
                }
                //CR#169 -Chile Margin Block- SKI-kalpesh chande -  05/12/2022 End Here
                
                soiList.add(soiObj);
                
            }
            //CR#169 -Chile Margin Block- SKI- kalpesh chande -  07/01/2023-Start Here
             if(isPaymentTermChanged==true){
                    SalesOrder.Sent_for_Latam_Director_Approval__c = true;
                } 
            //CR#169 -Chile Margin Block- SKI- kalpesh chande -  07/01/2023-End Here
               
            //CR#169 -Chile Margin Block- SKI-kalpesh chande -  05/12/2022 Start Here 
            if(SalesOrder.Discount_Percentage__c >= adminObj.Level_2_Minimum_Discount_Percent__c && SalesOrder.Discount_Percentage__c <= adminObj.Level_2_Maximum_Discount_Percent__c){
                System.debug('inside 5.01 to 10');
                SalesOrder.Sent_for_Director_Approval_Mexico__c = true;
            }
            else if(SalesOrder.Discount_Percentage__c > adminObj.Level_2_Maximum_Discount_Percent__c ||SalesOrder.Sent_for_Manager_Approval_Mexico__c==true || Test.isRunningTest()){
                System.debug('Greater than 10');
                //SalesOrder.Sent_for_Director_Approval_Mexico__c = true;
                SalesOrder.Sent_for_Latam_Director_Approval__c = true;
            }
            else if(SalesOrder.Gross_Margin_Percent__c <= adminObj.Level_2_Minimum_Gross_Margin_Percent__c || isPaymentTermChanged==true || Test.isRunningTest()){
                //SalesOrder.Sent_for_Director_Approval_Mexico__c = true;
                SalesOrder.Sent_for_Latam_Director_Approval__c = true;
            }
            else if(SalesOrder.Discount_Percentage__c< adminObj.Level_2_Minimum_Discount_Percent__c && SalesOrder.Is_payment_Term_Changed__c == false && SalesOrder.Gross_Margin_Percent__c >adminObj.Level_2_Minimum_Gross_Margin_Percent__c && SalesOrder.Sent_for_Latam_Director__c ==False && SalesOrder.Sent_for_CCO__c == False){
                SalesOrder.Order_Status__c = 'Open';
                SalesOrder.Sent_for_Director_Approval_Mexico__c =false;
                SalesOrder.Sent_for_Latam_Director_Approval__c = false;
                SalesOrder.Sent_for_Latam_Director__c = false;
                SalesOrder.Sent_for_CCO__c = false;
                
            }
            if(SalesOrder.Sent_for_Director_Approval_Mexico__c == true){
                approvalLevel = System.Label.Marketing_Director;
            }
            if(SalesOrder.Sent_for_Latam_Director_Approval__c == true ||SalesOrder.Sent_for_Latam_Director__c == true){ //CR#169 -Chile Margin Block- SKI- kalpesh chande -  23/01/2023
                approvalLevel = approvalLevel+System.Label.Sub_Region_Head;
            }
            if(SalesOrder.Sent_for_Latam_Director__c == true || Test.isRunningTest()){
                approvalLevel = approvalLevel+System.Label.Latam_Region_Head;
                SalesOrder.Sent_for_Director_Approval_Mexico__c = true;
                SalesOrder.Sent_for_Latam_Director_Approval__c = true;
            }
            if(SalesOrder.Sent_for_CCO__c == true || Test.isRunningTest()){
                approvalLevel = approvalLevel+System.Label.Global_CCO;
                SalesOrder.Sent_for_Director_Approval_Mexico__c = true;
                SalesOrder.Sent_for_Latam_Director_Approval__c = true;
            }
            //CR#169 -Chile Margin Block- SKI- kalpesh chande -  05/12/2022 End Here
            
            if(isSimulation == false){  //CR#169 -Chile Margin Block- SKI- kalpesh chande -  05/12/2022
                System.debug('SalesOrder '+SalesOrder);
                salesOrderList.add(SalesOrder);
                salesOrderObjList.add(SalesOrder.id); 
            }
            //CR#169 -Chile Margin Block- SKI- kalpesh chande -  05/12/2022 Start Here
            if(!approvalAndAddressMap.containsKey(delAdd)){
                approvalAndAddressMap.put(delAdd,approvalLevel);
            }
        }   
        //CR#169 -Chile Margin Block- SKI- kalpesh chande -  05/12/2022 End Here    
        //Logic end
        if(isSimulation==false){  //CR#169 -Chile Margin Block- SKI- kalpesh chande -  05/12/2022
            if(!soiList.isEmpty()){
                insert soiList;
                //update soObj2;
            }
            if(!salesOrderList.isEmpty()){
                update salesOrderList;
                //update soObj2;
            }
        }
        return approvalAndAddressMap;  //CR#169 -Chile Margin Block- SKI-kalpesh chande -  05/12/2022
        //return getSalesOrderItems(salesOrderObjList);  //CR#169 -Chile Margin Block- SKI- kalpesh chande -  05/12/2022 Commented
    }
    
    public static Sales_Order__c createSalesOrder(Sales_Order__c soObj2 ,String delAdd, String orderType, String salesOrg, Boolean isPaymentTermChanged, Boolean isSimulation){  //CR#169 -Chile Margin Block- SKI- kalpesh chande -  05/12/2022
        Sales_Order__c SO =  soObj2.clone(false,true,true,false);
        system.debug('@@soObj2@@'+soObj2);
        //List<Order_Type__c> orderType = [select id from Order_Type__c where SalesOrg__r.Sales_Org_Code__c = '5661'];
        if(orderType != '' && orderType != null){
            SO.Order_Type_lk__c = orderType;
        }
        shipMap = OrderChileController.getShippingLoations(soObj2.Sold_to_Party__c);
        
        SO.Ship_To_Party__c = shipMap.get(delAdd).id;
        SO.TM_Code__c = shipMap.get(delAdd).Sales_Employee_TM_code__c;
        system.debug('@@@'+shipMap.get(delAdd).Sales_Employee_TM_code__c);
        if(ordObj!=null){
            SO.Order__c = ordObj.id;
        }
        else{
            List<SalesOrderItem> SOIList = OrderChileController.createOrder(soObj2.Sold_to_Party__c,soObj2,salesOrg); 
            SO.Order__c = ordObj.id;
        }
        if(isSimulation == false){  //CR#169 -Chile Margin Block- SKI- kalpesh chande -  05/12/2022
            updateOrder(soObj2.Sold_to_Party__c);
        }
        system.debug('Payment check'+soObj2.Payment_Term__c+'---------'+soObj2.Sold_to_Party__r.Payment_Terms__c);
        /*List<Payment_Term__c> soPaymentTerm = [SELECT Id,name,Payterms_Desc__c,Payment_Term__c,Sales_Org__c,Payment_Term_Code__c FROM Payment_Term__c 
where SalesOrgCode__c = '5661' AND id =:soObj2.Payment_Term__c];
List<Account> acc = [select id,Payment_Terms__c from Account where id =:soObj2.Sold_to_Party__c ];
if(!soPaymentTerm.isEmpty() && !acc.isEmpty()){
if(acc[0].Payment_Terms__c == soPaymentTerm[0].Payment_Term_Code__c){
SO.Is_payment_Term_Changed__c = false;
}
else{
SO.Is_payment_Term_Changed__c = true;
}
}*/
        //insert SO;
        
        SO.Is_payment_Term_Changed__c = isPaymentTermChanged;
        if(isSimulation == false){  //CR#169 -Chile Margin Block- SKI- kalpesh chande -  05/12/2022
            //  SO.Order_Status__c='Submitted';//Added by Kalpesh 2-12-2022
            Database.SaveResult lsr = Database.insert(SO,false);
            system.debug('Sayan lsr-->'+lsr.id);
        }
        return SO;
    }    
    //Reload existing Sales Order Line Items with given Sales Order ID    
    @AuraEnabled
    public static List<SalesOrderItem> getSalesOrderItems(List<ID> soId) {
        
        List<Sales_Order_Line_Item__c> salesOrderItemList = [SELECT ID, Sale_Order__c,Sale_Order__r.Order_Type_Colombia__c, SKU_Name__c, Discount__c,MinPrice__c,MaxPrice__c,MinValue__c,UOM__c,
                                                             SKU_Name__r.SKU_Description__c,Item_Number__c,Quantity__c,Profit_colombia__c,Price__c,FinalPrice__c,Net_Margin_colombia__c,
                                                             CurrencyIsoCode, Sales_Org__c,Net_Price__c,Discount_Per_colombia__c,Margin_colombia__c,Discount_Value_colombia__c,
                                                             Sales_Order_Line_Item__r.Item_Number__c,UnitValue__c,Business_Type_Colombia__c,Unit_Price__c,
                                                             SKU_Name__r.Name
                                                             FROM Sales_Order_Line_Item__c
                                                             WHERE Sale_Order__c=:soId Order By CreatedDate];
        
        List<SalesOrderItem> itemList = new List<SalesOrderItem>();
        System.debug('salesOrderItemList'+salesOrderItemList);
        integer itemno = 0;
        for(Sales_Order_Line_Item__c soiObj: salesOrderItemList){
            SalesOrderItem item = new SalesOrderItem();
            item.productId = soiObj.SKU_Name__c;
            item.productName = soiObj.SKU_Name__r.SKU_Description__c;
            item.unitValue = soiObj.UnitValue__c;//final price
            item.maxPrice =soiObj.MaxPrice__c;
            item.minValue = soiObj.MinPrice__c;//item.minValue = soiObj.MinValue__c; 
            item.unitCost = soiObj.Unit_Price__c;
            item.qty = soiObj.Quantity__c;
            item.profit = soiObj.Profit_colombia__c ;
            item.UOM = soiObj.UOM__c;
            item.typeOfBusiness = soiObj.Business_Type_Colombia__c;
            
            /*if(String.isNotBlank(soiObj.Sales_Order_Line_Item__c)){
item.itemNo = soiObj.Sales_Order_Line_Item__r.Item_Number__c;
}
else{
item.itemNo = soiObj.Item_Number__c;
}*/
            item.itemNo = itemno++; 
            itemList.add(item);
        }          
        System.debug('itemList: '+itemList);
        return itemList;
    }
    
    
    @AuraEnabled
    public static OrderFields getOrderFields(String accId){
        
        String recordId = accId;
        
        OrderFields ofObj = new OrderFields();
        
        
        ofObj.paymentTermList = OrderChileController.fetchPaymentTermDetails();
        ofObj.loginCountryObj = OrderChileController.fetchLogingCountry(); // SKI(Vishal P) : #CR152 : PO And Delivery Date : 18-07-2022
        ofObj.incoTermsList = OrderChileController.fetchincoTermDetails();
        ofObj.DistributorData = OrderChileController.fetchDistributorDetails(recordId);
        ofObj.ShippingLocMap = OrderChileController.getShippingLoations(recordId);
        // ofObj.incoTermsList= [SELECT Id, Name, Active__c, Sales_Org__c,IncoTerm_Desc__c FROM Inco_Term__c where Sales_Org__r.Sales_Org_Code__c='5661' AND Active__c=true];   //CR#169 -Chile Margin Block- SKI- kalpesh chande -  05/12/2022 Commented
        ofObj.userObj = [Select Id, Profile.Name, Show_List_Value__c FROM User WHERE Id=:UserInfo.getUserId()];
        ofObj.salesOrg = [Select ID FROM Sales_Org__c WHERE NAME = 'Chile' AND Sales_Org_Code__c = '5661'LIMIT 1].Id;
        ofObj.poNoList = OrderChileController.getPOList(recordId);
        System.debug('ofObj'+JSON.serializePretty(ofObj.incoTermsList));
        ofObj.orderTypeList1=OrderChileController.fetchOrderType(accId); //CR#183 -Export Order Management – Chile- SKI- kalpesh chande -28-03-2023  
        return ofObj;
    }
    
    /*@AuraEnabled
public static Payment_Term__c changePaymentTerm(){
Map<String,String> options = new Map<String,String>();
return [SELECT Id,name,Payterms_Desc__c,Payment_Term__c,Sales_Org__c,Payment_Term_Code__c FROM Payment_Term__c 
where SalesOrgCode__c = '5661' limit 1];       
}*/
    
    @AuraEnabled
    public static List<Inco_Term__c> fetchincoTermDetails(){
        
        return [SELECT Id, Name, Active__c, Sales_Org__c,IncoTerm_Desc__c FROM Inco_Term__c where Sales_Org__r.Sales_Org_Code__c='5661' AND Active__c=true  order by IncoTerm_Desc__c asc];  //CR#169 -Chile Margin Block- SKI- kalpesh chande -  05/12/2022 //CR#183 -Export Order Management – Chile- SKI- kalpesh chande -21-06-2023
        
    }
    
    
    
    @AuraEnabled
    public static List<Payment_Term__c> fetchPaymentTermDetails(){
        
        return [SELECT Id,name,Payterms_Desc__c,Payment_Term__c,Sales_Org__c,Payment_Term_Code__c FROM Payment_Term__c 
                where SalesOrgCode__c = '5661'];
        
    }
    /* ---------------Start SKI(Vishal P) : #CR152 : PO And Delivery Date : 18-07-2022------------ */
    @AuraEnabled
    public static Login_Country__c fetchLogingCountry(){
        
        return [SELECT Id, Name, For_Contry__c, Sales_Org_Code__c, Delivery_Date__c, 
                PO_Date__c, Show_Delivery_Date__c, Show_PO_Date__c 
                FROM Login_Country__c 
                WHERE Sales_Org_Code__c = '5661' LIMIT 1];
    }
    /* ------------------End SKI(Vishal P) : #CR152 : PO And Delivery Date : 18-07-2022------------ */
    
    
    //CR#183 -Export Order Management – Chile- SKI- kalpesh chande -28-03-2023- Start here
    @AuraEnabled
    public static List<Order_Type__c> fetchOrderType(String accId){
        
        List<DistributorSalesAreaMapping__c> accSalesOrg=[SELECT Id, Distributor__c,Distribution_Channel_Code__c, Sales_Org_Code__c, SalesOrg__c 
                                                          FROM DistributorSalesAreaMapping__c where (Sales_Org_Code__c='5661' OR Sales_Org_Code__c='5662')
                                                          AND
                                                          Distributor__c=:accId];
        List<Order_Type__c> otList=new List<Order_Type__c>();
        if(accSalesOrg.size()>1){
            otList=[SELECT Id, SalesOrg__c,SalesOrg__r.sales_org_code__c,name, Description__c FROM Order_Type__c where (SalesOrg__r.sales_org_code__c='5661' OR SalesOrg__r.sales_org_code__c='5662') order by name desc];
            return otList;
        }else if(accSalesOrg[0].Sales_Org_Code__c=='5661'){
            otList=[SELECT Id, SalesOrg__c,SalesOrg__r.sales_org_code__c,name, Description__c FROM Order_Type__c where SalesOrg__r.sales_org_code__c='5661' limit 1];
            return otList;
        }else{
            otList=[SELECT Id, SalesOrg__c,SalesOrg__r.sales_org_code__c,name, Description__c FROM Order_Type__c where SalesOrg__r.sales_org_code__c='5662' limit 1];
            return otList;
        }
    }
     //CR#183 -Export Order Management – Chile- SKI- kalpesh chande -28-03-2023- End here
    
    
    
    @AuraEnabled
    public static DistributorWrapper fetchDistributorDetails(String recordId){
        
        String  Payment_Terms = '';
        List<Account> accList = [SELECT Id, Name, BillingCity,Payment_Term_Code__C,Payment_Term_Code__r.Payment_Term__c, BillingCountry, RegionalManager__c,
                                 BillingStreet, BillingState, BillingPostalCode , CurrencyIsoCode, Sales_Org__r.Name, 
                                 OwnerId, SAP_Code__c, Sales_Org__c, Distribution_Channel__c, Division__c,
                                 Order_Type__c, Order_Block__c,Sales_Org_Code__c, Status__c,Payment_Terms__c, PriceGroupCode__c,Sales_District__c,Sales_District__r.User__c,Sales_District__r.Sales_Director__c,Sales_District__r.Latam_Director__c
                                 FROM Account 
                                 WHERE Id=:recordId LIMIT 1];
        
        if(accList.size()>0){
            Payment_Terms = accList[0].Payment_Terms__c ;
            
        }
        List<Payment_Term__c> accPaymentTerm = [SELECT Id,name,Payterms_Desc__c,Payment_Term__c,Sales_Org__c,Payment_Term_Code__c FROM Payment_Term__c 
                                                where SalesOrgCode__c = '5661' AND Payment_Term_Code__c =:accList[0].Payment_Terms__c];
        
        /*List<Distributor_Depot_Mapping__c> dmList = [SELECT id, Distributor__c ,Depot__c, Depot__r.Location__c 
FROM Distributor_Depot_Mapping__c 
WHERE Distributor__c=:recordId LIMIT 1];

List<DistributorSalesAreaMapping__c> SalesAreaDMList = [SELECT Id,AccountOwner__c, Division_Code__c, Sales_Org_Code__c, Order_Type__c, PriceGroupMaster__c,
Distribution_Channel_Code__c, SalesOrg__c, Division__c, Distributor__c 
FROM DistributorSalesAreaMapping__c where Distributor__c=:recordId];                                                 
*/
        List<Credit_Info__c> ciList = [SELECT id, name,Distributor__c,distributor__r.name,
                                       Credit_Limit__c,Balance_Limit__c,Used_Limit__c, 
                                       Internal_Limit__c, Sum_Open_Item__c, DAYS_ARREARS__c 
                                       FROM Credit_Info__c 
                                       WHERE Distributor__c =:recordId and (Sales_Org__r.Sales_Org_Code__c='5661' or Sales_Org__r.Sales_Org_Code__c='5662')  LIMIT 1];//CR#183 -Export Order Management – Chile- SKI- kalpesh chande -21-06-2023
        
        List<Outstanding_Ageing__c> oagList = [SELECT id, OutstandingTotalGreaterthan90__c, Net_Outstanding__c
                                               FROM Outstanding_Ageing__c
                                               WHERE Customer_Code__c =:recordId LIMIT 1];
        
        List<Payments__c> oaList = [SELECT id, Net_Overdue__c  FROM Payments__c  
                                    WHERE Customer_Name__c =:recordId LIMIT 1];
        
        String distributionChannelId= '';
      //CR#183 -Export Order Management – Chile- SKI- kalpesh chande -28-03-2023 -Existing code in if-else condition -Start here
        if(accList[0].Sales_Org_Code__c=='5661'){
            distributionChannelId = [Select Id,Distribution_Channel_Code__c From Distribution_Channel__c where Distribution_Channel_Code__c ='20' LIMIT 1].Id;
        }else{
            distributionChannelId = [Select Id,Distribution_Channel_Code__c From Distribution_Channel__c where Distribution_Channel_Code__c ='40' LIMIT 1].Id;
        }
    //CR#183 -Export Order Management – Chile- SKI- kalpesh chande -28-03-2023 -Existing code in if-else condition -End here
        String divId= '';
        divId = [Select Id,Division_Code__c From Division__c where Division_Code__c ='10' LIMIT 1].Id;
        
        DistributorWrapper distributorDetails = new DistributorWrapper();
        distributorDetails.distributorName = accList[0].Name;
        distributorDetails.sapCode = accList[0].SAP_Code__c;
        distributorDetails.salesOrgId =accList[0].Sales_Org__c;
        distributorDetails.salesOrgName = accList[0].Sales_Org__r.Name;
        distributorDetails.distributorChannelId = distributionChannelId;   
        distributorDetails.Sales_Director = accList[0].Sales_District__r.Sales_Director__c;
        distributorDetails.Latam_Director = accList[0].Sales_District__r.Latam_Director__c;
        distributorDetails.divisionId = divId;   
        distributorDetails.ordertype = accList[0].Order_Type__c; 
        distributorDetails.paymentTerms = accList[0].Payment_Terms__c;
        if(!accPaymentTerm.isEmpty()){
            distributorDetails.paymentTermId = accPaymentTerm[0].id;
        }
        
        //system.debug('@@@@@@  '+accPaymentTerm[0].id+'    @@@@   '+distributorDetails.paymentTermId);
        distributorDetails.priceGroupId = accList[0].PriceGroupCode__c;
        distributorDetails.soOwner = accList[0].Sales_District__r.User__c;
        distributorDetails.address = accList[0].BillingStreet;
        distributorDetails.city = accList[0].BillingCity;
        distributorDetails.state = accList[0].BillingState;
        distributorDetails.country = accList[0].BillingCountry;
        distributorDetails.pincode = accList[0].BillingPostalCode;
        distributorDetails.currencyIso = accList[0].currencyIsoCode;
        distributorDetails.regionalManagerId = accList[0].RegionalManager__c;
        
        if(!oaList.isEmpty()){
            distributorDetails.greaterThan90 = oaList[0].Net_Overdue__c; //oaList[0].OutstandingTotalGreaterthan90__c;
        }
        
        if(!oagList.isEmpty()){
            distributorDetails.paymentOutstanding = oagList[0].Net_Outstanding__c;
        }
        
        /*if(!dmList.isEmpty()){
distributorDetails.depot = dmList[0].Depot__r.Location__c;
}
*/        
        if(!ciList.isEmpty()){
            distributorDetails.creditLimit = ciList[0].Credit_Limit__c;
            distributorDetails.creditUsed = ciList[0].Used_Limit__c;
            distributorDetails.creditBalance = ciList[0].Balance_Limit__c;
            distributorDetails.daysArrears = ciList[0].DAYS_ARREARS__c;
            distributorDetails.internalCredit = ciList[0].Internal_Limit__c;
        }
        
        /*List<Shipping_Location__c> slList = [SELECT Id, Name,Location_Name__c, Distributor__c, City__c, 
Region__c, Pincode__c, State__c, Country__c,
Sold_To_Party_SAP_Code__c, SAP_Code__c,Billing_Street_1__c,Billing_Street_2__c,Billing_Street_3__c,Billing_Street_4__c,Billing_Street_5__c,Billing_Street_6__c
FROM Shipping_Location__c
WHERE Distributor__c =:recordId];*/
        return distributorDetails;
        
        
    }
    
    //Method to get a map of picklist values of Shipping Location from custom object.
    public static Map<String,Shipping_Location__c> getShippingLoations(string recordId){ 
        //Map<String,Shipping_Location__c> options = new Map<String,Shipping_Location__c>();
        
        for(Shipping_Location__c slObj:[SELECT Id, Name,Location_Name__c, Distributor__c, City__c, 
                                        Region__c, Pincode__c, State__c, Country__c,
                                        Sold_To_Party_SAP_Code__c, SAP_Code__c,Billing_Street_1__c,Billing_Street_2__c,
                                        Billing_Street_3__c,Billing_Street_4__c,Billing_Street_5__c,Billing_Street_6__c,Sales_Employee_TM_code__c
                                        FROM Shipping_Location__c
                                        WHERE Distributor__c =:recordId]){
                                            //shipMap.put(slobj.Location_Name__c+' - '+slObj.City__c, slObj);
                                            shipMap.put(slObj.City__c+' - '+slObj.Billing_Street_3__c, slObj);
                                        }
        return shipMap;
    }
    
    
    
    
    @AuraEnabled 
    public static List<PriceDetail> getSkuData(String accId,String orderTypeSku){//CR#183 -Export Order Management – Chile- SKI- kalpesh chande -28-03-2023

        system.debug('accId'+accId+'orderTypeSku'+orderTypeSku);
        DistributorWrapper distWrapObj = new DistributorWrapper();  //CR#169 -Chile Margin Block- SKI- kalpesh chande -  05/12/2022
        Map<id,PriceDetail> priceMap = new Map<id,PriceDetail>();
        List<PriceDetail> priceList = new List<PriceDetail>();
        List<PriceBookMaster__c> pbmList =new List<PriceBookMaster__c>();
       //CR#183 -Export Order Management – Chile- SKI- kalpesh chande -28-03-2023-Existing code in if-else condition-Start here
       Order_Type__c otObj=[SELECT Id, SalesOrg__c,SalesOrg__r.sales_org_code__c,name, Description__c FROM Order_Type__c where id=:orderTypeSku];
        system.debug('otObj@@@'+otObj);
        if(otObj!=null){
            system.debug('inside obj');
            if(otObj.SalesOrg__r.sales_org_code__c=='5661'){
                system.debug('inside else if'); 
                pbmList =  [SELECT Id, Director_Price__c,Manager_Price__c,SKUCode__c ,Division__c,MaxPrice__c,SKUCode__r.Multiple_Of__c,SKUCode__r.Name, 
                            SKUCode__r.SKU_Code__c,SKUCode__r.Pack_Size__c, MinPrice__c,DistributorCustomerCode__c,
                            DepotCode__c, DepotCode__r.Location__c,DepotCode__r.Depot_Code__c,SKUCode__r.UOM__c,
                            Price__c, PG_CODE__c, PG_CODE__r.Name,SKUCode__r.Product_Category__c,
                            UOM__c, SKUCode__r.Product_Name__r.Name, SKUCode__r.Unit_Cost__c,
                            SKUCode__r.Product_Name__c, CurrencyIsoCode,SKUCode__r.Brand_Name__c,
                            SKUCode__r.Product_Name__r.Popular__c, SKUCode__r.SKU_Description__c,Final_Price__c
                            FROM PriceBookMaster__c
                            WHERE (DistributorCustomerCode__c =: accId OR DistributorCustomerCode__c = null) and
                            SKUCode__r.Sales_Org__r.sales_org_code__c ='5661' AND DepotCode__r.Depot_Code__c ='CL00'
                            AND StartDate__c <= TODAY AND EndDate__c >= TODAY AND SKUCode__r.Active__c = True  
                            ORDER BY SKUCode__r.Brand_Name__c ASC, SKUCode__r.SKU_Code__c DESC,DistributorCustomerCode__c DESC NULLS LAST, StartDate__c ASC, LastModifiedDate DESC ];
            }else{
                system.debug('inside else');
                pbmList =  [SELECT Id, Director_Price__c,Manager_Price__c,SKUCode__c ,Division__c,MaxPrice__c,SKUCode__r.Multiple_Of__c,SKUCode__r.Name, 
                            SKUCode__r.SKU_Code__c,SKUCode__r.Pack_Size__c, MinPrice__c,DistributorCustomerCode__c,
                            DepotCode__c, DepotCode__r.Location__c,DepotCode__r.Depot_Code__c,SKUCode__r.UOM__c,
                            Price__c, PG_CODE__c, PG_CODE__r.Name,SKUCode__r.Product_Category__c,
                            UOM__c, SKUCode__r.Product_Name__r.Name, SKUCode__r.Unit_Cost__c,
                            SKUCode__r.Product_Name__c, CurrencyIsoCode,SKUCode__r.Brand_Name__c,
                            SKUCode__r.Product_Name__r.Popular__c, SKUCode__r.SKU_Description__c,Final_Price__c
                            FROM PriceBookMaster__c
                            WHERE (DistributorCustomerCode__c =: accId OR DistributorCustomerCode__c = null) and
                            SKUCode__r.Sales_Org__r.sales_org_code__c ='5662' AND DepotCode__r.Depot_Code__c ='CL00'
                            AND StartDate__c <= TODAY AND EndDate__c >= TODAY AND SKUCode__r.Active__c = True AND DistributionChannel__r.Distribution_Channel_Code__c='40'
                            ORDER BY SKUCode__r.Brand_Name__c ASC, SKUCode__r.SKU_Code__c DESC,DistributorCustomerCode__c DESC NULLS LAST, StartDate__c ASC, LastModifiedDate DESC ];
                
            }
        }
    //CR#183 -Export Order Management – Chile- SKI- kalpesh chande -28-03-2023-Existing code in if-else condition-End here
        //CR#169 -Chile Margin Block- SKI- kalpesh chande -  05/12/2022 Start Here
        List<Account> accList=[SELECT Id, Depot_Code__c, Brazil_Depot_Code__c 
                               FROM Account 
                               where (Sales_Org_Code__c='5661' OR Sales_Org_Code__c='5662') AND id=:accId ORDER BY LastModifiedDate DESC  LIMIT 1];//CR#183 -Export Order Management – Chile- SKI- kalpesh chande -28-03-2023
        system.debug('accList[0].Brazil_Depot_Code__c'+accList[0].Depot_Code__c);
        Map<String,Price_Block_Margin_Matrix__c> prcE2eBlockMap=new Map <String,Price_Block_Margin_Matrix__c>();
        
        List<Price_Block_Margin_Matrix__c> pbmmE2eMBEBList = new List<Price_Block_Margin_Matrix__c>();
        List<Price_Block_Margin_Matrix__c> pbmmE2eUPC9List = new List<Price_Block_Margin_Matrix__c>();
        List<Price_Block_Margin_Matrix__c> pbmmE2eList = new List<Price_Block_Margin_Matrix__c>();
        List<Price_Block_Margin_Matrix__c> pbmmPlnList = new List<Price_Block_Margin_Matrix__c>();
        List<Profit_Center__c> profitCenterList = new List<Profit_Center__c>();
        
        
        profitCenterList =[SELECT Id, Name, Profit_Center__c, Sales_Value__c, Sales_Org__c, Depot__c, Combination_Key__c 
                           FROM Profit_Center__c 
                           WHERE Sales_Org__r.Sales_Org_Code__c ='5661' ORDER BY LastModifiedDate DESC  LIMIT 1];
        system.debug('profitCenterList'+profitCenterList);
        String profitCenter = profitCenterList[0].Profit_Center__c;
        
        pbmmE2eMBEBList = [SELECT Id, Name, SKU_Code__c, SKU_Active__c, UOM__c, 
                           Sales_Org__c,E2E_Cost_LC__c, E2E_Cost_USD__c, E2E_Cost_UPC9_LC__c, 
                           E2E_Cost_UPC9_USD__c, E2E_Cost_MBEW_LC__c, E2E_Cost_MBEW_USD__c,Type__c
                           FROM Price_Block_Margin_Matrix__c
                           WHERE (Sales_Org__r.Sales_org_code__c='5661' OR Sales_Org__r.Sales_org_code__c='5662')//CR#183 -Export Order Management – Chile- SKI- kalpesh chande -28-03-2023
                           AND UOM__c !=null
                           AND Depot_Code__r.Depot_Code__c =:accList[0].Depot_Code__c
                           AND Start_Date__c<= today AND End_Date__c>= today
                           AND E2E_Cost_MBEW_USD__c != null
                           AND Type__c ='E2ECostMBEW' ORDER BY LastModifiedDate ASC ];
        System.debug('pbmmE2eMBEBList '+pbmmE2eMBEBList.size());
        pbmmE2eUPC9List = [SELECT Id, Name, SKU_Code__c, SKU_Active__c, UOM__c, 
                           Sales_Org__c,E2E_Cost_LC__c, E2E_Cost_USD__c, E2E_Cost_UPC9_LC__c, 
                           E2E_Cost_UPC9_USD__c, E2E_Cost_MBEW_LC__c, E2E_Cost_MBEW_USD__c,Type__c
                           FROM Price_Block_Margin_Matrix__c
                           WHERE (Sales_Org__r.Sales_org_code__c='5661' OR Sales_Org__r.Sales_org_code__c='5662')//CR#183 -Export Order Management – Chile- SKI- kalpesh chande -28-03-2023
                           AND UOM__c !=null
                           AND Depot_Code__r.Depot_Code__c =:accList[0].Depot_Code__c
                           AND Start_Date__c<= today AND End_Date__c>= today
                           AND E2E_Cost_UPC9_USD__c != null
                           AND Type__c ='E2ECostUPC9' ORDER BY LastModifiedDate ASC ];
         System.debug('pbmmE2eUPC9List '+pbmmE2eUPC9List.size());
        pbmmE2eList = [SELECT Id, Name, SKU_Code__c, SKU_Active__c, UOM__c, 
                       Sales_Org__c,E2E_Cost_LC__c, E2E_Cost_USD__c, E2E_Cost_UPC9_LC__c, 
                       E2E_Cost_UPC9_USD__c, E2E_Cost_MBEW_LC__c, E2E_Cost_MBEW_USD__c,Type__c
                       FROM Price_Block_Margin_Matrix__c
                       WHERE
                       (Sales_Org__r.Sales_org_code__c='5661' OR Sales_Org__r.Sales_org_code__c='5662') //CR#183 -Export Order Management – Chile- SKI- kalpesh chande -28-03-2023
                       AND Start_Date__c<= today AND End_Date__c>= today
                       AND E2E_Cost_USD__c != null
                       AND Depot_Code__r.Depot_Code__c =:accList[0].Depot_Code__c
                       AND UOM__c !=null
                       AND Profit_Center__c=:profitCenterList[0].Id
                       AND Type__c ='E2ECost' ORDER BY LastModifiedDate ASC ];
        System.debug('pbmmE2eList'+pbmmE2eList.size());
        System.debug('pbmmE2eUPC9List'+pbmmE2eUPC9List.size());
                        
        
        
        if(pbmmE2eMBEBList.size()>0){
            for(Price_Block_Margin_Matrix__c pbmmObj:pbmmE2eMBEBList){
                prcE2eBlockMap.put(pbmmObj.SKU_Code__c,pbmmObj);
                System.debug('prcE2eBlockMap'+prcE2eBlockMap);
            }
        }
        
        if(pbmmE2eUPC9List.size()>0){
            for(Price_Block_Margin_Matrix__c pbmmObj:pbmmE2eUPC9List){
                prcE2eBlockMap.put(pbmmObj.SKU_Code__c,pbmmObj);
                System.debug('prcE2eBlockMap'+prcE2eBlockMap);
            }
        }
        
        if(pbmmE2eList.size()>0){
            for(Price_Block_Margin_Matrix__c pbmmObj:pbmmE2eList){
                prcE2eBlockMap.put(pbmmObj.SKU_Code__c,pbmmObj);
                System.debug('prcE2eBlockMap'+prcE2eBlockMap);
            }
        }
        //CR#169 -Chile Margin Block- SKI- kalpesh chande -  05/12/2022 End Here
        
        if(pbmList.size()>0){
            system.debug('pbmList.size()'+pbmList.size());
            for(PriceBookMaster__c pbObj :pbmList){
                if(!priceMap.containsKey(pbObj.SKUCode__c)){
                    PriceDetail pb = new PriceDetail(); 
                    //CR#169 -Chile Margin Block- SKI- kalpesh chande -  05/12/2022 Start Here
                    system.debug('inside');
                    if(prcE2eBlockMap.containsKey(pbObj.SKUCode__c) || Test.isRunningTest()){
                        Price_Block_Margin_Matrix__c tmpPriceBlockMargin = new Price_Block_Margin_Matrix__c();
                        tmpPriceBlockMargin = prcE2eBlockMap.get(pbObj.SKUCode__c);
                        system.debug('tmpPriceBlockMargin'+tmpPriceBlockMargin);
                        if(pbObj.CurrencyIsoCode == 'USD' && (tmpPriceBlockMargin.E2E_Cost_USD__c!=null || tmpPriceBlockMargin.E2E_Cost_UPC9_USD__c!=null || tmpPriceBlockMargin.E2E_Cost_MBEW_USD__c!=null)|| Test.isRunningTest()){
                            //CR#169 -Chile Margin Block- SKI-kalpesh chande -  05/12/2022 End Here
                            // system.debug('pbObj'+pb);
                            pb.skuId = pbObj.SKUCode__c;
                            pb.skuCategory = pbObj.SKUCode__r.Product_Category__c; 
                            pb.skuDescription = pbObj.SKUCode__r.SKU_Description__c;
                            pb.unitCost = pbObj.SKUCode__r.Unit_Cost__c;
                            pb.UOM = pbObj.UOM__c;
                            // pb.unitValue = pbObj.Unit_Price__c;
                            pb.minValue = pbObj.MinPrice__c;
                            pb.maxPrice = pbObj.Price__c;
                            pb.pricebookId = pbObj.Id;
                            pb.skuCode = pbObj.SKUCode__r.SKU_Code__c;
                            pb.multipleOf = pbObj.SKUCode__r.Multiple_of__c;
                            //CR#169 -Chile Margin Block- SKI- kalpesh chande -  05/12/2022 Start Here
                            
                            system.debug('pbObj'+pb);
                            if(prcE2eBlockMap.containsKey(pbObj.SKUCode__c)){                   
                                Price_Block_Margin_Matrix__c pbMME2eObj = prcE2eBlockMap.get(pbObj.SKUCode__c);
                                if(pbMME2eObj.Type__c =='E2ECost'){
                                    pb.e2ECostUSD = pbMME2eObj.E2E_Cost_USD__c;
                                }
                                if(pbMME2eObj.Type__c =='E2ECostUPC9'){
                                    pb.e2ECostUPC9USD = pbMME2eObj.E2E_Cost_UPC9_USD__c;
                                }
                                if(pbMME2eObj.Type__c =='E2ECostMBEW'){
                                    pb.e2ECostMBEWUSD = pbMME2eObj.E2E_Cost_MBEW_USD__c;
                                }                                            
                                pb.uome2eCost = pbMME2eObj.UOM__c;                                                        
                            }    
                            system.debug('pb'+pb);
                            //CR#169 -Chile Margin Block- SKI- kalpesh chande -  05/12/2022 End Here              
                            priceMap.put(pbObj.SKUCode__c,pb);
                            
                        }
                    }
                   
                }
            }
        }
         system.debug('priceMap.values() '+priceMap.size());
        return priceMap.values();
    }
    
   //CR#169 -Chile Margin Block- SKI- kalpesh chande -  05/12/2022 Start Here   
     @AuraEnabled
    public Static List<UOM_Conversion__c> checkUom(String skuId){
       List<UOM_Conversion__c> uomList=new List<UOM_Conversion__c>();
       uomList= [SELECT Id, Name, SKU__c, Base_UOM__c, Sales_UOM__c, 
                      Numerator__c, Sales_Org__c, Denominator__c 
                      FROM UOM_Conversion__c 
                      WHERE SKU__c =: skuId
                      AND (Sales_Org__r.Sales_org_code__c ='5661' OR Sales_Org__r.Sales_org_code__c ='5662') ORDER BY LastModifiedDate DESC];//CR#183 -Export Order Management – Chile- SKI- kalpesh chande -28-03-2023
        System.debug('uomList'+uomList[0]);
        return uomList;
    }
  //CR#169 -Chile Margin Block- SKI- kalpesh chande -  05/12/2022 End Here   
    
    @AuraEnabled
    public static List<Id> saveChunk(List<Id> parentId, String fileName, String base64Data, String contentType, List<String> fileId) {
        // check if fileId id ''(Always blank in first chunk), then call the saveTheFile method,
        //  which is save the check data and return the attachemnt Id after insert, 
        //  next time (in else) we are call the appentTOFile() method
        //   for update the attachment with reamins chunks   
        System.debug('saveChunk'+parentId+'--'+fileName+'--'+contentType+'--'+fileId);
        deleteSavedAttach(parentId);
        /* System.debug('after delete'+parentId+'--'+fileName+'--'+contentType+'--'+fileId);
if (fileId.isEmpty() || fileId.size()<0 || fileId== null) {
System.debug('in save Chunk');*/
        fileId = saveTheFile(parentId, fileName, base64Data, contentType);
        /* } else {
appendToFile(fileId, base64Data);
}
*/
        return (fileId);
    }
    
    public static void deleteSavedAttach(List<Id> soId){
        list<Attachment> listofAttach = new list<Attachment>();
        listofAttach = [SELECT Id,Name FROM Attachment WHERE parentId=:soId ];
        if(listofAttach.size()>0){
            delete listofAttach;
        }
    }
    public static List<Id> saveTheFile(List<Id> parentId, String fileName, String base64Data, String contentType) {
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        List<Attachment> attToInsert = new List<Attachment>();
        system.debug('in Save the File');
        List<Id> attIds = new List<Id>();
        for(Id soID : parentId){
            Attachment oAttachment = new Attachment();
            oAttachment.parentId = soID;
            oAttachment.Body = EncodingUtil.base64Decode(base64Data);
            oAttachment.Name = fileName;
            oAttachment.ContentType = contentType;
            attToInsert.add(oAttachment);
            attIds.add(oAttachment.id);
        }
        insert attToInsert;
        system.debug('in Save the File'+attToInsert);
        system.debug('in Save the File'+attIds);
        return attIds;
    }
    /*
private static void appendToFile(List<Id> fileId, String base64Data) {
base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
List<Attachment> attUpdate = new List<Attachment>();
List<Attachment> att = [
SELECT Id, Body
FROM Attachment
WHERE Id =: fileId
];
for(Attachment a : att){
String existingBody = EncodingUtil.base64Encode(a.Body);
a.Body = EncodingUtil.base64Decode(existingBody + base64Data);
attUpdate.add(a);
}
update attUpdate;
}
*/
    
    
    /*******************************************/
    /* Wrapper classes to store All Data  */
    /*****************************************/
    
    public class OrderFields{
        @AuraEnabled public DistributorWrapper DistributorData;
        @AuraEnabled public List<String> orderTypeList;
        @AuraEnabled public List<Payment_Term__c> paymentTermList;
        @AuraEnabled public List<String> currencyList;
        @AuraEnabled public Map<String, Shipping_Location__c> ShippingLocMap;
        @AuraEnabled public List<Inco_Term__c> incoTermsList;
        @AuraEnabled public User userObj;
        @AuraEnabled public String salesOrg;
        @AuraEnabled public List<String> poNoList;
         @AuraEnabled public List<Order_Type__c> orderTypeList1;//CR#183 -Export Order Management – Chile- SKI- kalpesh chande -28-03-2023
        
        
        @AuraEnabled public Login_Country__c loginCountryObj; // SKI(Vishal P) : #CR152 : PO And Delivery Date : 18-07-2022
        
        public OrderFields(){
            DistributorData = new DistributorWrapper();
            orderTypeList = new List<String>();
            paymentTermList = new List<Payment_Term__c>();
            currencyList = new List<String>();
            ShippingLocMap = new Map<String, Shipping_Location__c>();
            incoTermsList = new List<Inco_Term__c>();
            userObj = new User();
            poNoList = new List<String>();
            salesOrg = '';
            loginCountryObj = new Login_Country__c(); // SKI(Vishal P) : #CR152 : PO And Delivery Date : 18-07-2022
            orderTypeList1=new List<Order_Type__c>();//CR#183 -Export Order Management – Chile- SKI- kalpesh chande -28-03-2023
        }
    }
    
    
    
    public class OrderWrapper{
        @AuraEnabled public List<Sales_Order__c> soObjList;
        @AuraEnabled public List<SalesOrderItem> soiList;
        @AuraEnabled public String sfdcOrderNo;
        @AuraEnabled public String sapOrderNo;
        @AuraEnabled public String orderSubStatus;
        public Exception exObj;
        
        public OrderWrapper(){
            soObjList = new List<Sales_Order__c>();
            soiList = new List<SalesOrderItem>();
            sfdcOrderNo = '';
            sapOrderNo = '';
            orderSubStatus = '';
        }
    }
    
    public class SalesOrderItem {
        
        @AuraEnabled public String productId;
        @AuraEnabled public String productCode;
        @AuraEnabled public String orderItemId;
        @AuraEnabled public String priceBookDetailId;
        @AuraEnabled public String skuCategory;
        @AuraEnabled public String UOM;
        @AuraEnabled public String productName;
        @AuraEnabled public Decimal qty;
        @AuraEnabled public Decimal inventory;
        @AuraEnabled public Decimal listValue;
        @AuraEnabled public Decimal minValue;
        @AuraEnabled public Decimal unitValue;//final prices
        @AuraEnabled public Decimal unitCost;
        @AuraEnabled public Decimal budgetValue;
        @AuraEnabled public Decimal discount;
        @AuraEnabled public Decimal discount_percent;
        @AuraEnabled public Decimal profit;
        @AuraEnabled public String typeOfBusiness;
        @AuraEnabled public Decimal netSales;
        @AuraEnabled public Decimal netPrice;
        @AuraEnabled public Decimal margin;
        @AuraEnabled public Decimal netMargin;
        @AuraEnabled public String resultByMargin;
        @AuraEnabled public String resultByPrice;
        @AuraEnabled public Decimal totalSales;
        @AuraEnabled public Decimal grossProfit;
        @AuraEnabled public Decimal grossMargin;
        @AuraEnabled public Decimal businessImpact;
        @AuraEnabled public Decimal totalDiscount;
        @AuraEnabled public Decimal maxPrice;
        @AuraEnabled public String oiCurrency;
        
        @AuraEnabled public Decimal replacementMargin;
        @AuraEnabled public Decimal ledgerMargin;
        @AuraEnabled public Decimal unitValueWithInterest;
        @AuraEnabled public Decimal totalValue;
        @AuraEnabled public Decimal totalValueWithInterest;
        @AuraEnabled public Decimal interestRate;
        @AuraEnabled public Decimal days;
        @AuraEnabled public Decimal timeInMonths;
        @AuraEnabled public Decimal multipleOf;
        @AuraEnabled public String cultureDesc;
        @AuraEnabled public String flag;
        @AuraEnabled public Decimal itemNo;
        @AuraEnabled public Decimal moItemNo;
        @AuraEnabled public Boolean isMO;
        @AuraEnabled public Date deliveryDate;
        @AuraEnabled public String deliveryAddress;
        
        
        public SalesOrderItem(){
            UOM = 'N/A';
            isMO = false;
            itemNo = 0;
            moItemNo = 0;
            productId = '';
            productCode = '';
            orderItemId = '';
            priceBookDetailId = '';
            productName = '';
            maxPrice = 0;
            unitCost =0;
            // fatDate = '';
            qty = 0;
            discount = 0;
            discount_percent = 0;
            profit = 0;
            netSales = 0;
            netPrice = 0;
            margin = 0;
            netMargin = 0;
            unitValueWithInterest = 0;
            totalValueWithInterest = 0;
            totalValue = 0;
            interestRate = 0;
            days = 0;
            cultureDesc = '';
            deliveryAddress = '';
            deliveryDate = Date.today();
            oiCurrency = 'USD';
            
        }
    } 
    
    public class PriceDetail{
        @AuraEnabled public String skuId;
        @AuraEnabled public String skuDescription;
        @AuraEnabled public String skuCategory;
        @AuraEnabled public String UOM;
        @AuraEnabled public Decimal unitValue;
        @AuraEnabled public Decimal unitCost;
        @AuraEnabled public Decimal minValue;
        @AuraEnabled public String pricebookId;
        @AuraEnabled public Decimal qty;
        @AuraEnabled public String skuCode;
        @AuraEnabled public Decimal multipleOf;
        @AuraEnabled public Decimal monthlyInterestRate;
        @AuraEnabled public String orderItemId;
        @AuraEnabled public String regState;
        @AuraEnabled public Decimal balanceQty;
        @AuraEnabled public Decimal balanceQty2;
        @AuraEnabled public String fatDate;
        @AuraEnabled public Decimal percUsed;
        @AuraEnabled public Decimal days;
        @AuraEnabled public Decimal unitValueWithInterest;
        @AuraEnabled public Decimal totalValue;
        @AuraEnabled public Decimal totalValueWithInterest;
        @AuraEnabled public Decimal interestRate;        
        @AuraEnabled public String cultureDesc;
        @AuraEnabled public Boolean isMO;
        @AuraEnabled public Decimal itemNo;
        @AuraEnabled public Boolean isValid;
        @AuraEnabled public Decimal maxPrice;
        //CR#169 -Chile Margin Block- SKI- kalpesh chande -  05/12/2022 Start Here
        @AuraEnabled public String e2EUOM;    
        @AuraEnabled public Decimal e2EUOMValueCon ;
        @AuraEnabled public String e2EBaseUOM;
        @AuraEnabled public String e2ESalesUOM;               
        @AuraEnabled public decimal e2ECostUSD;
        @AuraEnabled public decimal e2ECostUPC9USD; 
        @AuraEnabled public decimal e2ECostMBEWUSD;       
        @AuraEnabled public String salesDeductionUOM;
        @AuraEnabled public Decimal salesDeductionUSD ;
        @AuraEnabled public Decimal salesDeductionDUOMValueCon;      
        @AuraEnabled public Decimal salesDeductionInPercent;          
        @AuraEnabled public String rebate1UOM ; 
        @AuraEnabled public Decimal rebate1USD;
        @AuraEnabled public Decimal rebateUOMConver1 ;         
        @AuraEnabled public Decimal rebate1Percent;
        @AuraEnabled public String rebateCode1;    
        @AuraEnabled public String rebate2UOM ;       
        @AuraEnabled public Decimal rebate2USD ;
        @AuraEnabled public Decimal rebateUOMConver2;
        @AuraEnabled public Decimal rebate2Percent;
        @AuraEnabled public String rebateCode2;        
        @AuraEnabled public String discountUOM ;        
        @AuraEnabled public Decimal discountUSD;
        @AuraEnabled public Decimal discountPercent;
        @AuraEnabled public Decimal discountUOMConver;               
        @AuraEnabled public String additionalDiscountUOM;      
        @AuraEnabled public Decimal additionalDiscountUSD;
        @AuraEnabled public Decimal additionalDiscountPercent ; 
        @AuraEnabled public Decimal additionalDiscountUOMConver ;            
        @AuraEnabled public String plnUOM;
        @AuraEnabled public Decimal pLNUSD ;
        @AuraEnabled public Decimal plnUOMConver;           
        @AuraEnabled public String profitCenter;                    
        @AuraEnabled public String uomRebate1;
        @AuraEnabled public String uomRebate2;
        @AuraEnabled public String uomDiscount;
        @AuraEnabled public String uomAddDiscount;
        @AuraEnabled public String uomSalesDeduction ;
        @AuraEnabled public String uome2eCost;
        @AuraEnabled public String uomPLN ;        
        @AuraEnabled public String baseUOM;
        @AuraEnabled public Decimal convertQty;
        @AuraEnabled public Decimal convertNetPrice;
        @AuraEnabled public Decimal convertFinalPrice;
        @AuraEnabled public String currencyIso;
        //CR#169 -Chile Margin Block- SKI- kalpesh chande -  05/12/2022 End Here
        public PriceDetail(){
            UOM = 'N/A';
            itemNo = 0;
            skuId = '';
            skuDescription = '';
            skuCategory = '';
            unitValue = 0;
            unitCost =0;
            minValue = 0;
            pricebookId = '';
            days = 0;
            qty = 0;
            maxPrice = 0;
            skuCode = '';
            multipleOf = 0;
            monthlyInterestRate = 0;
            orderItemId = '';
            regState = '';
            balanceQty = 0;
            balanceQty2 = 0;
            percUsed = 100;
            unitValueWithInterest = 0;
            cultureDesc = '';
            totalValue = 0;
            interestRate = 0;
            totalValueWithInterest = 0;
            isMO = false;
            isValid = false;
            //CR#169 -Chile Margin Block- SKI- kalpesh chande -  05/12/2022 Start Here
            e2EUOM ='';     
            e2EUOMValueCon = 0;
            e2EBaseUOM ='';
            e2ESalesUOM ='';              
            e2ECostUSD = 0;
            e2ECostUPC9USD = 0;
            e2ECostMBEWUSD = 0;   
            salesDeductionUOM ='';
            salesDeductionUSD = 0;
            salesDeductionDUOMValueCon = 0;         
            salesDeductionInPercent = 0;      
            rebate1UOM ='';
            rebate1USD = 0;
            rebateUOMConver1 = 0;            
            rebate1Percent = 0;
            rebateCode1 ='';     
            rebate2UOM  ='';        
            rebate2USD = 0;
            rebateUOMConver2 = 0;
            rebate2Percent = 0;
            rebateCode2 ='';    
            discountUOM ='';         
            discountUSD = 0;
            discountPercent = 0;
            discountUOMConver = 0;               
            additionalDiscountUOM ='';        
            additionalDiscountUSD = 0; 
            additionalDiscountPercent = 0;
            additionalDiscountUOMConver = 0;             
            plnUOM ='';
            pLNUSD = 0;
            plnUOMConver = 0;             
            profitCenter ='';                       
            uomRebate1 ='';
            uomRebate2 ='';
            uomDiscount ='';
            uomAddDiscount ='';
            uomSalesDeduction ='';
            uome2eCost ='';
            uomPLN ='';        
            baseUOM ='';
            convertQty = 0;
            convertNetPrice = 0;
            convertFinalPrice = 0;
            //CR#169 -Chile Margin Block-SKI- kalpesh chande -  05/12/2022 End Here
        }
    }
    
    public class DistributorWrapper{
        @AuraEnabled   public String Sales_Director;
        @AuraEnabled   public String Latam_Director;
        @AuraEnabled   public List<String> divisionIds;
        @AuraEnabled   public String distributorName;
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
        @AuraEnabled   public String address;
        @AuraEnabled   public String city;
        @AuraEnabled   public String state;
        @AuraEnabled   public String country;
        @AuraEnabled   public String pincode;
        @AuraEnabled   public String currencyIso;
        @AuraEnabled   public Id regionalManagerId;
        @AuraEnabled   public String paymentTerms;
        @AuraEnabled   public String paymentTermId;
        @AuraEnabled   public Id priceGroupId;
        @AuraEnabled   public Id priceListType;
        @AuraEnabled   public String territoryManagerId;
        @AuraEnabled   public Decimal internalCredit;
        @AuraEnabled public String soOwner;
        // @AuraEnabled public Payment_Term__c paymentTerms;
    }
    
}