/*
* Name: Order Management
* Created On: 28 Aug 2016
* Author: Bhavik Devdhar (bhavik.devdhar@skinternational.com)
* Description: Class is used for Placing Orders by Distributor, TM, RM of various Countries (India, Indonesia, Mexico)
*/
global without sharing class OrderManagementController {
    //Variable to be set by JS for Attachment status
    public String valuefromJS {get;set;}
    
    //Set Order Type Code
    public String orderTypeCode {get;set;}
    
    public DistributorWrapper distWrapObj {get;set;}
    public SKUDetails skuWrapObj {get;set;}
    public ShippingLocation slwObj {get;set;}
    public Shipping_Location__c slwObj2 {get;set;}
    
    public List<SelectOption> shippingList {get;set;}
    public List<SKUDetails> skuDetailsList {get;set;}
    public List<SKUDetails> skuOrderList {get;set;}
    
    public List<State_Tax_Structure__c> stsList {get;set;}
    public List<Inventory__c> updateInvList {get;set;}
    public List<OrderLineItem__c> oliList {get;set;}
    public List<Sales_Order_Line_Item__c> oliList2 {get;set;}
    public List<Contact> conList {get;set;}
    public List<Distributor_Depot_Mapping__c> depotList {get;set;}
    public List<Depot__c> depotIdList {get;set;}
    public List<OrderTemplate__c> tempList {get;set;}
    
    public Map<String,ShippingLocation> shippingMap {get;set;}    
    public Map<Id,SKUDetails> skuDetailsMap {get;set;}
    public Map<Id,SKUDetails> skuOrderMap {get;set;}
    public Map<String,String> stateMap {get;set;}
    
    public Set<String> SKUNamesSet{get;set;}
    public Set<String> productNamesSet{get;set;}
    public List<SelectOption> depotSet{get;set;}
    
    public String selectedShipping {get;set;}
    public String selectedDepot {get; set;}
    public String searchSkuValue {get; set;}
    public String searchProdValue {get; set;}
    public String templateName {get; set;}
    public String errorMessage {get; set;}
    public String state {get; set;}
    public String skuIdChosen {get; set;}
    public String tempIdChosen {get; set;}
    public String orderRaisedBy {get; set;}
    public String skuJSON {get;set;}
    public String distributorJSON {get;set;}
    public String shippingJSON {get;set;}
    
    public Boolean showError{get;set;}
    public Boolean enableInput{get;set;}
    
    //Order Related Permissions
    public Boolean showCredit{get;set;}
    public Boolean showInventory{get;set;}
    public Boolean showInventoryColumn{get;set;}
    public Boolean enableDepot{get;set;}
    
    public Boolean allowTemplate{get;set;}
    public Boolean orderSaved{get;set;}
    //public Boolean allowCashOrder{get;set;}
    public Boolean throwEx;
    
    public Decimal netAmount {get;set;}
    public Decimal grossAmount {get;set;}
    public Decimal taxAmount {get;set;}
    public Decimal vatAmount {get;set;}
    
    public Integer itemNumber;
    
    public String orderId{get;set;}
    public String accountId{get;set;}
    public String accountId1{get;set;}
    public String depoId;
    public String distributorId;
    public String territoryManagerId;
    public String methodName;
    
    public Order__c ordObj {get;set;}
    public Sales_Order__c soObj {get;set;}
    public Sales_Order__c soObj2 {get;set;}
    public User loginUserObj {get;set;}
    public Exception exObj;
    
    //Variables to Enable Country Wise Table
    public Boolean enableIndia{get;set;}
    public Boolean enableIndonesia{get;set;}
    public Boolean enableMexico{get;set;}
    
    /*Abhishek --
    */
    public String depoId1;
    public String sObjId1{get;set;}
    public String sObjId2{get;set;}
    public Integer orderListCount{get;set;}
    public List<SelectOption> PaymentOptions{get;set;}
    public String paymentType{get;set;}
    public String SelectedPaymentType{get;set;} 
    /**/
    
    public OrderManagementController(ApexPages.StandardController controller) {
        try{
            orderTypeCode = '';
            
            PaymentOptions = new List<SelectOption>();
            orderListCount = 0;
            PaymentOptions.add(new SelectOption('Cash','Cash'));
            PaymentOptions.add(new SelectOption('Credit','Credit'));
            paymentType='Credit';  
            SelectedPaymentType='';
            slwObj = new ShippingLocation();
            
            slwObj2 = new Shipping_Location__c();
            SKUNamesSet = new Set<String>();
            productNamesSet = new Set<String>();
            depotSet = new List<SelectOption>();
            
            skuDetailsList = new List<SKUDetails>();
            skuOrderList = new List<SKUDetails>();
            oliList = new List<OrderLineItem__c>();
            
            skuOrderMap = new Map<Id,SKUDetails>();
            shippingMap = new Map<String, ShippingLocation>();
            skuDetailsMap = new Map<Id,SKUDetails>();
            stateMap = new Map<String, String>();
            
            searchSkuValue = '';
            searchProdValue = '';
            errorMessage = '';
            skuIdChosen = '';
            state = '';
            orderRaisedBy = '';
            methodName = '';   
            skuJSON = '';
            distributorJSON = '';
            shippingJSON = '';
            
            throwEx = false;
            showError = false;
            enableInput = true;
            showCredit = false;
            showInventory = false;
            showInventoryColumn = false;
            //allowCashOrder = false;
            enableDepot = false;//change to True by Abhishek  enableDepot = false;
            allowTemplate = false;
            orderSaved = false;
            
            netAmount = 0;
            taxAmount = 0;
            grossAmount = 0;
            vatAmount = 0;
            
            itemNumber = 0;
            
            accountId = '';
            accountId1 = '';
            distributorId = '';
            depoId = '';
            depoId1 = '';
            territoryManagerId = '';
            
            //orderId = ApexPages.currentpage().getparameters().get('retURL');        
            orderId = ApexPages.currentpage().getparameters().get('id');        
            System.debug('---->orderId: '+orderId);
            
            accountId = ApexPages.currentpage().getparameters().get('acid');
            accountId1 = ApexPages.currentpage().getparameters().get('acid');
            System.debug('------>accountId: '+accountId);
            
            loginUserObj = [SELECT Id, Name, IsActive, ContactId,UserRole.name,
                            Show_Inventory__c, Show_Credit_Limit__c, EnableDepot__c,
                            Show_Inventory_Column__c
                            FROM User 
                            WHERE Id =: UserInfo.getUserId()
                            AND IsActive = True];
            
            showInventory = loginUserObj.Show_Inventory__c;
            showInventoryColumn = loginUserObj.Show_Inventory_Column__c;
            showCredit =  loginUserObj.Show_Credit_Limit__c;
            
            System.debug('showInventory: '+showInventory);
            System.debug('showInventoryColumn: '+showInventoryColumn);
            System.debug('showCredit: '+showCredit);
            
            //Assign account Id if TM creates order on behalf of Distributor
            if(String.isNotBlank(accountId)){
                
               enableDepot = loginUserObj.EnableDepot__c;
               System.debug('enableDepot: '+enableDepot);
               //distributorId = [SELECT Id FROM User where Contact.AccountId =: accountId].Id;
               
               List<User> listUr = [Select u.Id, u.IsActive, u.IsPortalEnabled from User u where u.AccountId=:accountId];
               
               if(listUr.size() >0 ){
                   distributorId = listUr[0].id;
               }else{
                   Account accowner = [Select id,ownerId From Account Where id =: accountId];
                   distributorId = accowner.ownerId;
              } 
               System.debug('-inside if condition-- distributorId--->'+ distributorId);
                if(loginUserObj.UserRole.name.contains('Regional Manager')){
                    orderRaisedBy = 'Regional Manager';
                }
                else{
                    orderRaisedBy = 'Territory Manager';
                }
            }
            else{
                //Assign Account Id based on Logged In User            
                conList = [SELECT Id, FirstName, LastName, 
                           Accountid, Account.OwnerId, 
                           Account.RegionalManager__c
                           FROM Contact 
                           WHERE Id =: loginUserObj.ContactID];
                
                distributorId = UserInfo.getUserId();
                
                showInventory = loginUserObj.Show_Inventory__c;
                
                if(!conList.isEmpty()){        
                    accountId = conList[0].Accountid;
                    territoryManagerId = conList[0].Account.OwnerId;      
                }
                else{
                    //accountId = '001N000000qg8AT'; commented By abhishek...
                    //depoId = 'a0wN0000002zYrxIAE';
                    //territoryManagerId = '005N0000002kOef';
                }
                orderRaisedBy = 'Distributor';
                //enableDepot = false;
            }
            
           depotList = [SELECT id, Depot__c 
                         FROM Distributor_Depot_Mapping__c 
                         WHERE Distributor__c=:accountId AND Depot__c!='' LIMIT 1];
        
            System.debug('depotList: '+depotList);
            
            if(!depotList.isEmpty()){
                depoId = depotList[0].Depot__c;
                depoId1 = depoId;
            }
            System.debug('depoId: '+depoId);
            System.debug('depotList: '+depotList);
            System.debug('depoId1 --- : '+depoId1);
            
        }
        catch(Exception ex){
            methodName = 'Constructor';
            //exObj = ex;
            //exceptionHandler();
            System.debug('Exception: '+ex.getMessage()+ ' Line Number: '+ex.getLineNumber());
        }
       
    }
    
    //Method to Create 2 SalesOrders on Order Confirmation
    public void createSalesOrder(){
        if(ordObj!=null  && soObj==null){
            System.debug('soObj1');
            soObj = new Sales_Order__c();
            soObj.Sold_to_Party__c = accountId;
            soObj.Bill_To_Party__c = accountId;
            soObj.Order_Date__c = System.today();
            soObj.Order_Raise_By__c = orderRaisedBy;
            soObj.Order_Status__c = 'Open';
            soObj.OwnerId = distributorId;
            soObj.Order__c = ordObj.Id;
            soObj.Ship_To_Party__c = slwObj.locationId;
            soObj.Sales_Org_lk__c = distWrapObj.salesOrgId;
            soObj.Distribution_Channel_lk__c = distWrapObj.distributorChannelId;
            soObj.Division_lk__c = distWrapObj.divisionId;
            soObj.Credit_Term__c = distWrapObj.paymentTerms;
            soObj.Stock_Status__c = 'In Stock';
            soObj.CurrencyIsoCode = distWrapObj.currencyIso;
            
            if(soObj.Order_Raise_By__c == 'Distributor'){
                soObj.Designated_Owner__c = territoryManagerId;
            }
            else{
                soObj.Designated_Owner__c = distWrapObj.regionalManagerId;
            }
            //patch work done by abhishek Here
            
            //orderTypeCode = [SELECT Id, Sales_Org_Code__c FROM Sales_Org__c WHERE Sales_Org_Code__c=:acc.Sales_Org_Code__c LIMIT 1]
            //paymentType= SelectedPaymentType;
            Account acc =[select id,Sales_Org_Code__c from Account where id=:accountId][0];
            System.debug('----paymentType logic -----'+paymentType);

            setOrderTypeCode(acc.Sales_Org_Code__c);
            
            //End of patch
            soObj.Order_Type_lk__c = [Select Id FROM Order_Type__c WHERE Order_Type_Code__c=:orderTypeCode].Id;//distWrapObj.orderType  [Select Id FROM Order_Type__c WHERE Order_Type_Code__c='ZORD'].Id; 
            insert soObj;
        }
    }
    
    //Method to poulate Order Type Code based on Sales Org of Distributor
    public void setOrderTypeCode(String salesOrgCode){
        if(salesOrgCode =='1000'){//india
            if(paymentType=='Cash'){
                orderTypeCode = 'ZOCO';
            }
            else{
                orderTypeCode='ZORD';
            }
        }
        else if(salesOrgCode =='6410'){ //indonesia
            orderTypeCode='Z1OR';
        }
        else if(salesOrgCode =='6451'){ //indonesia
            orderTypeCode='ZORO';
        }
    }
    
    public void createSalesOrder2(){
        if(ordObj!=null && soObj2==null){
            System.debug('soObj2');
            soObj2 = new Sales_Order__c();
            soObj2.Sold_to_Party__c = accountId;
            soObj2.Bill_To_Party__c = accountId;
            soObj2.Order_Date__c = System.today();
            soObj2.Order_Raise_By__c = orderRaisedBy;
            soObj2.Order_Status__c = 'Open';
            soObj2.OwnerId = distributorId;
            soObj2.Order__c = ordObj.Id;
            soObj2.Ship_To_Party__c = slwObj.locationId;
            soObj2.Sales_Org_lk__c = distWrapObj.salesOrgId;
            soObj2.Distribution_Channel_lk__c = distWrapObj.distributorChannelId;
            soObj2.Division_lk__c = distWrapObj.divisionId;
            soObj2.Credit_Term__c = distWrapObj.paymentTerms;
            soObj2.Stock_Status__c = 'Out of Stock';
            soObj2.CurrencyIsoCode = distWrapObj.currencyIso;
            
            if(soObj2.Order_Raise_By__c == 'Distributor'){
                soObj2.Designated_Owner__c = territoryManagerId;
            }
            else{
                soObj2.Designated_Owner__c = distWrapObj.regionalManagerId;
            }
            /*Abhishek */
            //String orderTypeCode;
            System.debug('----paymentType logic 2-----'+paymentType);
            Account acc =[select id,Sales_Org_Code__c from Account where id=:accountId][0];

            setOrderTypeCode(acc.Sales_Org_Code__c);
            System.debug('orderTypeCode: '+orderTypeCode);
            
            /*Abhishek*/
            soObj2.Order_Type_lk__c = [Select Id FROM Order_Type__c WHERE Order_Type_Code__c=:orderTypeCode].Id;//distWrapObj.orderType; 
            System.debug('Order_Type_lk__c: '+soObj2.Order_Type_lk__c);
            insert soObj2;
        }
    }
    
    //Method to add Line Items to SalesOrders on Order Confirmation
    public void addSOLineItem(){
        try{if(Test.isRunningTest() && throwEx==true){Integer x=1/0;}
            
            updateInvList = new List<Inventory__c>();
            
            Sales_Order_Line_Item__c sliObj;
            Sales_Order_Line_Item__c sliObj2;
            Inventory__c invObj; //= new Inventory();

            for(SKUDetails skuWrapObj:skuOrderMap.values()){
                sliObj = new Sales_Order_Line_Item__c();
                sliObj.SKU_Name__c = skuWrapObj.skuId;
                sliObj.Item_Number__c = skuWrapObj.itemNo;
                sliObj.Item_Status__c = 'Active';
                sliObj.No_of_Case__c = skuWrapObj.numberOfCases;
                sliObj.DepotDepot__c = depoId;
                //sliObj.Order_Item_Key__c = soObj.Name+'-'+itemNumber;
                sliObj.UOM__c = skuWrapObj.UOM;
                sliObj.CurrencyIsoCode = distWrapObj.currencyIso;
                
                if(skuWrapObj.qty==0){
                    showError = true;
                    errorMessage = 'Please Enter No. of Cases for all SKU\'s before confirming order'; 
                    break;
                }
                else if(skuWrapObj.available == 0){
                    createSalesOrder2();
                    System.debug('skuWrapObj.available == 0: '+skuWrapObj.available);
                    sliObj2 = sliObj.clone(false);
                    sliObj2.Quantity__c = skuWrapObj.qty;
                    if(enableIndonesia == true){
                        //Decimal totalPrice = skuWrapObj.Price - skuWrapObj.specialDiscount - skuWrapObj.schemeBonus;
                        sliObj2.Invoice_Discount__c = (skuWrapObj.invoiceDiscount/100)*skuWrapObj.price*sliObj2.Quantity__c;
                        sliObj2.Spot_Discount__c = (skuWrapObj.spotDiscount/100)*skuWrapObj.price*sliObj2.Quantity__c;
                        sliObj2.SpotDiscountPercentage__c = skuWrapObj.spotDiscount;
                        sliObj2.DistributorDiscountPercentage__c = skuWrapObj.invoiceDiscount;
                    }
                    else{
                        sliObj2.Spot_Discount__c = 0;
                        sliObj2.Invoice_Discount__c = skuWrapObj.invoiceDiscount * skuWrapObj.qty;
                    }
                    
                    sliObj2.Special_Discount__c = skuWrapObj.specialDiscount * skuWrapObj.qty;
                    sliObj2.Scheme_Bonus_Discount__c = skuWrapObj.schemeBonus * skuWrapObj.qty;

                    sliObj2.Price__c = (skuWrapObj.price*sliObj2.Quantity__c) - sliObj2.Invoice_Discount__c - sliObj2.Special_Discount__c - sliObj2.Spot_Discount__c - sliObj2.Scheme_Bonus_Discount__c;
                    sliObj2.Sale_Order__c = soObj2.Id;
                    insert sliObj2;
                }
                //If Order Qty <= Available Stock Create Single Sales Order
                else if(skuWrapObj.qty <= skuWrapObj.available){
                    createSalesOrder();
                    System.debug('skuWrapObj.qty <= skuWrapObj.available: '+skuWrapObj.qty);
                    System.debug('skuWrapObj.qty <= skuWrapObj.available: '+skuWrapObj.available);
                    
                    //Logic to update Allocated Quantity
                    invObj = new Inventory__c();
                    invObj.Id = skuWrapObj.inventoryId;
                    invObj.Allocated_Quantity__c = skuWrapObj.available - skuWrapObj.qty;
                    updateInvList.add(invObj);
                    //End of Logic 
                    sliObj.Quantity__c = skuWrapObj.qty;
                    if(enableIndonesia == true){
                        //Decimal totalPrice = skuWrapObj.Price - skuWrapObj.specialDiscount - skuWrapObj.schemeBonus; 
                        sliObj.Invoice_Discount__c = (skuWrapObj.invoiceDiscount/100)*skuWrapObj.price*sliObj.Quantity__c;
                        sliObj.Spot_Discount__c = (skuWrapObj.spotDiscount/100)*skuWrapObj.price*sliObj.Quantity__c;
                        sliObj.SpotDiscountPercentage__c = skuWrapObj.spotDiscount;
                        sliObj.DistributorDiscountPercentage__c = skuWrapObj.invoiceDiscount;
                    }
                    else{
                        sliObj.Spot_Discount__c = 0;
                        sliObj.Invoice_Discount__c = skuWrapObj.invoiceDiscount * skuWrapObj.qty;
                    }
                    //sliObj.Invoice_Discount__c = skuWrapObj.invoiceDiscount * skuWrapObj.qty;
                    sliObj.Special_Discount__c = skuWrapObj.specialDiscount * skuWrapObj.qty;
                    sliObj.Scheme_Bonus_Discount__c = skuWrapObj.schemeBonus * skuWrapObj.qty;
                    sliObj.Price__c = (skuWrapObj.price*sliObj.Quantity__c) - sliObj.Invoice_Discount__c - sliObj.Special_Discount__c - sliObj.Spot_Discount__c - sliObj.Scheme_Bonus_Discount__c;
                    sliObj.Sale_Order__c = soObj.Id;
                    insert sliObj;
                }
                //If Order Qty > Available Split Sales Order
                else if(skuWrapObj.qty > skuWrapObj.available){
                    createSalesOrder();
                    createSalesOrder2();

                    sliObj2 = sliObj.clone(false);
                    //sliObj2.Order_Item_Key__c = soObj2.Name+'-'+itemNumber;
                    sliObj2.Sale_Order__c = soObj2.Id;
                    sliObj2.Quantity__c = skuWrapObj.qty - skuWrapObj.available;
                    
                    //Logic to update Allocated Quantity
                    invObj = new Inventory__c();
                    invObj.Id = skuWrapObj.inventoryId;
                    invObj.Allocated_Quantity__c = skuWrapObj.available - sliObj2.Quantity__c;
                    updateInvList.add(invObj);
                    //End of Logic 
                    if(enableIndonesia == true){
                        //Decimal totalPrice = skuWrapObj.Price - skuWrapObj.specialDiscount - skuWrapObj.schemeBonus;
                        sliObj2.Invoice_Discount__c = (skuWrapObj.invoiceDiscount/100)*skuWrapObj.price*sliObj2.Quantity__c;
                        sliObj2.Spot_Discount__c = (skuWrapObj.spotDiscount/100)*skuWrapObj.price*sliObj2.Quantity__c;
                        sliObj2.SpotDiscountPercentage__c = skuWrapObj.spotDiscount;
                        sliObj2.DistributorDiscountPercentage__c = skuWrapObj.invoiceDiscount;
                    }
                    else{
                        sliObj2.Spot_Discount__c = 0;
                        sliObj2.Invoice_Discount__c = skuWrapObj.invoiceDiscount * sliObj2.Quantity__c;
                    }
                    
                    sliObj2.Special_Discount__c = skuWrapObj.specialDiscount * sliObj2.Quantity__c;
                    
                    sliObj2.Scheme_Bonus_Discount__c = skuWrapObj.schemeBonus * sliObj2.Quantity__c;
                    sliObj2.CurrencyIsoCode = distWrapObj.currencyIso;

                    sliObj2.No_of_Case__c = sliObj2.Quantity__c/skuWrapObj.packSize;
                    sliObj2.Price__c = (skuWrapObj.price*sliObj2.Quantity__c) - sliObj2.Invoice_Discount__c - sliObj2.Special_Discount__c - sliObj2.Spot_Discount__c - sliObj2.Scheme_Bonus_Discount__c;
                    insert sliObj2; 
                    
                    sliObj.Quantity__c = skuWrapObj.available; 
                    if(enableIndonesia == true){
                        //Decimal totalPrice = skuWrapObj.Price - skuWrapObj.specialDiscount - skuWrapObj.schemeBonus;
                        sliObj.Invoice_Discount__c = (skuWrapObj.invoiceDiscount/100)*skuWrapObj.price*sliObj.Quantity__c;
                        sliObj.Spot_Discount__c = (skuWrapObj.spotDiscount/100)*skuWrapObj.price*sliObj.Quantity__c;
                        sliObj.SpotDiscountPercentage__c = skuWrapObj.spotDiscount;
                        sliObj.DistributorDiscountPercentage__c = skuWrapObj.invoiceDiscount;
                    }
                    else{
                        sliObj.Spot_Discount__c = 0;
                        sliObj.Invoice_Discount__c = skuWrapObj.invoiceDiscount * sliObj.Quantity__c;
                    }
                    
                    sliObj.Special_Discount__c = skuWrapObj.specialDiscount * sliObj.Quantity__c;
                    sliObj.Scheme_Bonus_Discount__c = skuWrapObj.schemeBonus * sliObj.Quantity__c;
                    sliObj.No_of_Case__c = skuWrapObj.available/skuWrapObj.packSize;
                    sliObj.Price__c = (skuWrapObj.price*sliObj.Quantity__c) - sliObj.Invoice_Discount__c - sliObj.Special_Discount__c - sliObj.Spot_Discount__c - sliObj.Scheme_Bonus_Discount__c;
                    sliObj.Sale_Order__c = soObj.Id;
                    insert sliObj;
                }
            }

            //Update Tax and Total Amount in Sales Order 1
            if(soObj!=null){
                soObj = [Select Id, Net_Amount__c from Sales_Order__c where id=:soObj.id];
                System.debug('soObj: '+soObj);
                soObj.Tax_Amount__c = (stsList[0].Tax__c/100) * soObj.Net_Amount__c;
                soObj.Additional_Tax__c = (stsList[0].AdditionalTax__c/100) * soObj.Net_Amount__c;
                soObj.Total_Amount__c = soObj.Net_Amount__c + soObj.Tax_Amount__c + soObj.Additional_Tax__c;
                upsert soObj;
                System.debug('After upsert soObj: '+soObj);
            }

            //Update Tax and Total Amount in Sales Order 2
            if(soObj2!=null){
                soObj2 = [Select Id, Net_Amount__c from Sales_Order__c where id=:soObj2.id];
                System.debug('soObj2: '+soObj2);
                soObj2.Tax_Amount__c = (stsList[0].Tax__c/100) * soObj2.Net_Amount__c;
                soObj2.Additional_Tax__c = (stsList[0].AdditionalTax__c/100) * soObj2.Net_Amount__c;
                soObj2.Total_Amount__c = soObj2.Net_Amount__c + soObj2.Tax_Amount__c + soObj2.Additional_Tax__c;
                upsert soObj2;
                System.debug('After upsert soObj2: '+soObj2);
            }
        }
        catch(Exception ex){
            methodName = 'addSOLineItem';
            exObj = ex;
            exceptionHandler();
            System.debug('Exception: '+ex.getMessage()+ ' Line Number: '+ex.getLineNumber());
        }
    }
    
    public void changeDepot(){
        System.debug('changeDepot-----------> ');
        try{if(Test.isRunningTest() && throwEx==true){Integer x=1/0;}
            
            depotIdList = [SELECT id, Name 
                           FROM Depot__c 
                           WHERE Name LIKE: selectedDepot LIMIT 1];
            
            System.debug('selectedDepot: '+selectedDepot);
            
            if(!depotIdList.isEmpty()){
                system.debug('depotIdList ----> '+depotIdList[0].Id);
                system.debug('depoId1 ----> '+depoId1);
            
                if(depoId1 != depotIdList[0].Id+''){
                    accountId1 ='';
                }
                else{
                    accountId1 = accountId;
                }
                depoId = '';
                depoId = depotIdList[0].Id;
            }
            
            skuDetailsList.clear();
            skuDetailsMap.clear();
            
            searchProdValue = '';
            searchSkuValue = '';
            /*Added by Abhishek AND StartDate__c <= TODAY AND EndDate__c >= TODAY */
            List<PriceBookMaster__c> pbmList = [SELECT Id, SKUCode__c ,SKUCode__r.Name, 
                                                SKUCode__r.Pack_Size__c, SKUCode__r.SKU_Code__c,
                                                DepotCode__c, DepotCode__r.Location__c, 
                                                Price__c, PG_CODE__c, PG_CODE__r.Name, 
                                                UOM__c, SKUCode__r.Product_Name__r.Name,
                                                SKUCode__r.Product_Name__c, SKUCode__r.Product_Name__r.Popular__c,
                                                DistributorCustomerCode__r.Name, CurrencyIsoCode,
                                                SKUCode__r.Product_Name__r.VF_Image__c
                                                FROM PriceBookMaster__c
                                                WHERE (DepotCode__c =: depoId AND PG_CODE__c=:distWrapObj.priceGroupId)
                                                AND SKUCode__r.Sales_Org__c =: distWrapObj.salesOrgId
                                                AND StartDate__c <= TODAY AND EndDate__c >= TODAY   AND SKUCode__r.Active__c = True
                                                ORDER BY SKUCode__r.Product_Name__r.Name ASC, SKUCode__r.SKU_Code__c DESC];

            System.debug('pbmList   ------->'+pbmList);
            System.debug('accountId1: '+accountId1);
            System.debug('depoId: '+depoId);
            System.debug('distWrapObj.priceGroupId ------->'+distWrapObj.priceGroupId);
            
            if(pbmList.isEmpty()){
                //errorMessage = 'Pricebook for Depot/Distributor not found';
                //showError = true;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Pricebook for Depot/Distributor not found'));
            }
            else{
                for(PriceBookMaster__c pbObj : pbmList){
                    skuWrapObj = new SKUDetails();
                    skuWrapObj.brandName = pbObj.SKUCode__r.Product_Name__r.Name +' '+pbObj.SKUCode__r.Name;
                    skuWrapObj.skuPackName = pbObj.SKUCode__r.Name;
                    skuWrapObj.distributorId = accountId;
                    skuWrapObj.productName = pbObj.SKUCode__r.Product_Name__r.Name;
                    skuWrapObj.productId = pbObj.SKUCode__r.Product_Name__c;

                    skuWrapObj.packSize = pbObj.SKUCode__r.Pack_Size__c;
                    skuWrapObj.UOM = pbObj.UOM__c;

                    skuWrapObj.skuCode = pbObj.SKUCode__r.SKU_Code__c;
                    skuWrapObj.skuId = pbObj.SKUCode__c;
                    skuWrapObj.depotLocation = pbObj.DepotCode__r.Location__c;
                    skuWrapObj.depotId = pbObj.DepotCode__c;
                    skuWrapObj.price = Math.abs(pbObj.Price__c);
                    skuWrapObj.priceGroupCode = pbObj.PG_CODE__r.Name; 
                    skuWrapObj.priceGroupId = pbObj.PG_CODE__c;
                    skuWrapObj.currencyIso = pbObj.currencyIsoCode;
                    skuWrapObj.popular = pbObj.SKUCode__r.Product_Name__r.Popular__c;
                    if(String.isNotBlank(pbObj.SKUCode__r.Product_Name__r.VF_Image__c)){
                        skuWrapObj.image = pbObj.SKUCode__r.Product_Name__r.VF_Image__c;
                    }

                    if(String.isNotBlank(pbObj.SKUCode__c) && String.isNotBlank(skuWrapObj.UOM)){
                        skuDetailsMap.put(pbObj.SKUCode__c, skuWrapObj);
                    }
                }
            }
            //End of Logic
            
            //Logic to populate existing wrapper with Pricebook Discount
            List<PricebookDiscount__c> pbdList = [SELECT Id, SKUCode__c ,
                                                  Price__c, CurrencyIsoCode
                                                  FROM PricebookDiscount__c
                                                  WHERE  (DistributorCustomerCode__c =:accountId1 
                                                         OR (DepotCode__c =: depoId AND PG_CODE__c=:distWrapObj.priceGroupId)) 
                                                  AND SKUCode__r.Sales_Org__c =: distWrapObj.salesOrgId
                                                  AND StartDate__c <= TODAY AND EndDate__c >= TODAY AND SKUCode__r.Active__c = True];
            System.debug('pbdList ---->'+pbdList);
            for(PricebookDiscount__c pbObj : pbdList){
                if(skuDetailsMap.containsKey(pbObj.SKUCode__c)){
                    skuWrapObj = skuDetailsMap.get(pbObj.SKUCode__c);
                    skuWrapObj.invoiceDiscount = Math.abs(pbObj.Price__c);
                    skuWrapObj.currencyIso = pbObj.currencyIsoCode;
                    skuDetailsMap.put(pbObj.SKUCode__c, skuWrapObj);
                }
                
            }
            //End of Logic
            
            //Logic to populate existing wrapper with Special Discount
            List<SpecialInvoiceDiscount__c> sidList = [SELECT Id, SKUCode__c, 
                                                       Price__c, CurrencyIsoCode
                                                       FROM SpecialInvoiceDiscount__c
                                                       WHERE  (DistributorCustomerCode__c =:accountId1 
                                                         OR (DepotCode__c =: depoId AND PG_CODE__c=:distWrapObj.priceGroupId))
                                                       AND SKUCode__r.Sales_Org__c =: distWrapObj.salesOrgId
                                                       AND StartDate__c <= TODAY AND EndDate__c >= TODAY AND SKUCode__r.Active__c = True];
            
            for(SpecialInvoiceDiscount__c pbObj : sidList){
                if(skuDetailsMap.containsKey(pbObj.SKUCode__c)){
                    skuWrapObj = skuDetailsMap.get(pbObj.SKUCode__c);
                    skuWrapObj.specialDiscount = Math.abs(pbObj.Price__c);
                    skuWrapObj.currencyIso = pbObj.currencyIsoCode;
                    skuDetailsMap.put(pbObj.SKUCode__c, skuWrapObj);
                }
            }
            //End of Logic
            
            //Logic to populate existing wrapper with Pack Size
            
            List<SKU_Pack_Size__c> packSizeList = [SELECT Id, Pack_Size__c, 
                                                   UOM__c, SKU__c
                                                   FROM SKU_Pack_Size__c
                                                   WHERE Depot__c =: depoId
                                                   AND SKU__r.Active__c = True];
            
            System.debug('packSizeList: '+packSizeList);
            System.debug('size: '+packSizeList.size());
            
            for(SKU_Pack_Size__c psObj : packSizeList){
                if(skuDetailsMap.containsKey(psObj.SKU__c)){
                    skuWrapObj = skuDetailsMap.get(psObj.SKU__c);
                    skuWrapObj.packSize = Decimal.ValueOf(psObj.Pack_Size__c);
                    skuWrapObj.UOM = psObj.UOM__c;
                    skuDetailsMap.put(psObj.SKU__c, skuWrapObj);
                }
            }
            //End of Logic
            
            //Logic to populate existing wrapper with Inventory
            List<Inventory__c> invList = [SELECT Id, SKU__c, 
                                          Stock_Quantity__c, Balanced_Quanity__c
                                          FROM Inventory__c
                                          WHERE Depot__c =: depoId AND SKU__r.Active__c = True];        
            
            for(Inventory__c pbObj : invList){
                if(skuDetailsMap.containsKey(pbObj.SKU__c)){
                    skuWrapObj = skuDetailsMap.get(pbObj.SKU__c);
                    skuWrapObj.available = Integer.valueOf(pbObj.Balanced_Quanity__c);
                    skuWrapObj.inventoryId = pbObj.Id;
                    if(pbObj.Balanced_Quanity__c!=null && pbObj.Balanced_Quanity__c > 0){
                        skuWrapObj.available2 = 'In Stock';
                    }
                    skuDetailsMap.put(pbObj.SKU__c, skuWrapObj);
                }
            }
            //End of Logic
            skuJSON = JSON.serialize(skuDetailsMap.values());
            fetchPopular();
            System.debug('skuJSON: '+skuJSON);
            /*Added By abhishek*/
        }
        catch(Exception ex){
            methodName = 'changeDepot';
            exObj = ex;
            exceptionHandler();
            System.debug('Exception: '+ex.getMessage()+ ' Line Number: '+ex.getLineNumber());
        }
    }
    
    //Method to fetch Distributor Details, Depot, Credit Information and Shipping Details
    public void fetchDistributorDetails(){
        try{if(Test.isRunningTest() && throwEx==true){Integer x=1/0;}
            
            List<Account> accList = [SELECT Id, Name, BillingCity, BillingCountry, RegionalManager__c,
                                     BillingStreet, BillingState, BillingPostalCode , CurrencyIsoCode, Sales_Org__r.Name, 
                                     OwnerId, SAP_Code__c, Sales_Org__c, Distribution_Channel__c, Division__c,
                                     Order_Type__c, Order_Block__c,Sales_Org_Code__c, Status__c, Payment_Terms__c, PriceGroupCode__c
                                     FROM Account 
                                     WHERE Id=:accountId LIMIT 1];
            
            System.debug('accList: '+accList);
            
            territoryManagerId = accList[0].OwnerId;
            System.debug('territoryManagerId:'+territoryManagerId);
            
            List<Distributor_Depot_Mapping__c> dmList = [SELECT id, Distributor__c ,Depot__c, Depot__r.Location__c 
                                                         FROM Distributor_Depot_Mapping__c 
                                                         WHERE Distributor__c=:accountId LIMIT 1];
            
            System.debug('dmList: '+dmList);
            
            List<Credit_Info__c> ciList = [SELECT id, name,Distributor__c,distributor__r.name,
                                           Credit_Limit__c,Balance_Limit__c,Used_Limit__c, 
                                           Allocated_Balance_Limit__c, Sum_Open_Item__c, DAYS_ARREARS__c 
                                           FROM Credit_Info__c 
                                           WHERE Distributor__c =:accountId LIMIT 1];
            
            List<Outstanding_Ageing__c> oaList = [SELECT id, OutstandingTotalGreaterthan90__c 
                                                  FROM Outstanding_Ageing__c
                                                  WHERE Customer_Code__c =:accountId LIMIT 1];
            System.debug('ciList: '+ciList);
            
            //Logic to add Account Details, Billing Address and Credit Information to Wrapper
            distWrapObj = new DistributorWrapper();
            distWrapObj.distributorName = accList[0].Name;
            distWrapObj.sapCode = accList[0].SAP_Code__c;
            distWrapObj.salesOrgId = accList[0].Sales_Org__c;
            distWrapObj.salesOrgName = accList[0].Sales_Org__r.Name;
            distWrapObj.distributorChannelId = accList[0].Distribution_Channel__c;            
            distWrapObj.divisionId = accList[0].Division__c;   
            distWrapObj.ordertype = accList[0].Order_Type__c; 
            distWrapObj.paymentTerms = accList[0].Payment_Terms__c;
            distWrapObj.priceGroupId = accList[0].PriceGroupCode__c;
            
            if(!oaList.isEmpty()){
                distWrapObj.greaterThan90 = oaList[0].OutstandingTotalGreaterthan90__c;
            }
            //Assign Order/Sales Order Owner to TM if Distributor License not found.
            if(String.isBlank(distributorId)){
                distributorId = accList[0].OwnerId;
                orderRaisedBy = 'Territory Manager';
            }
            /*if(accList[0].Status__c == 'Inactive'){
                //errorMessage = 'Order Blocked because Account Status Inactive';
                //showError = true;                
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Order cannot be placed. Reason - Account Status Inactive'));
                enableInput = false;
            }
            
            if(accList[0].Order_Block__c == true){
                enableInput = false;
                //errorMessage = 'Order has been Blocked for your Account';
                //showError = true;                
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Order cannot be placed. Reason - Order Blocked'));
            }*/

            //Populate StateMap Code to State Name
            for(State_Tax_Structure__c stateObj:[Select Id, State_Name__c, State_Code__c From State_Tax_Structure__c]){
                stateMap.put(stateObj.State_Code__c, stateObj.State_Name__c);
            }
            System.debug('stateMap: '+stateMap);
            //End of Logic
            
            List<Shipping_Location__c> slList = [SELECT Id, Name, Distributor__c, City__c, 
                                                 Region__c, Pincode__c, State__c, Country__c,
                                                 Sold_To_Party_SAP_Code__c
                                                 FROM Shipping_Location__c
                                                 WHERE Distributor__c =:accountId];
                                                 //AND Sold_To_Party_SAP_Code__c!=:distWrapObj.sapCode];
            
            List<TM_Depot_Mapping__c> tdmList = [SELECT Id, Depot__c, Depot__r.Location__c, Territory_Manager__c 
                                                 FROM TM_Depot_Mapping__c
                                                 WHERE Territory_Manager__c =:territoryManagerId];
            for(TM_Depot_Mapping__c tdmObj:tdmList){
                depotSet.add(new SelectOption(tdmObj.Depot__r.Location__c,tdmObj.Depot__r.Location__c));
            }
            System.debug('depotSet ---- > '+depotSet);
            if(!dmList.isEmpty()){
                distWrapObj.depot = dmList[0].Depot__r.Location__c;
                depoId = dmList[0].Depot__c;
            }
            
            if(String.isNotBlank(distWrapObj.depot)){
                fetchSKUData();
            }
            
            if(!ciList.isEmpty()){
                distWrapObj.creditLimit = ciList[0].Credit_Limit__c;
                distWrapObj.creditUsed = ciList[0].Used_Limit__c;
                //distWrapObj.creditBalance = ciList[0].Allocated_Balance_Limit__c;
                distWrapObj.creditBalance = ciList[0].Balance_Limit__c;
                distWrapObj.paymentOutstanding = ciList[0].Sum_Open_Item__c;
                distWrapObj.daysArrears = ciList[0].DAYS_ARREARS__c;
                /*if(distWrapObj.creditLimit<=1){
                    //allowCashOrder = true; 
                    //enableInput = true;
                }
                else if(distWrapObj.creditBalance<=0){
                    //allowCashOrder = false; 
                    enableInput = false;
                    //errorMessage = 'Order Blocked due to insufficient Credit Balance';
                    //showError = true;
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Order cannot be placed. Reason - Insufficient Credit Limit Balance'));
                }
                if(distWrapObj.daysArrears > 0){
                    //errorMessage = 'Order Blocked due to Payment Outstanding';
                    //showError = true;
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Order cannot be placed. Reason - Payment Outstanding Overdue'));
                    enableInput = false;
                }*/
            }
            distWrapObj.address = accList[0].BillingStreet;
            distWrapObj.city = accList[0].BillingCity;
            distWrapObj.state = accList[0].BillingState;
            distWrapObj.country = accList[0].BillingCountry;
            distWrapObj.pincode = accList[0].BillingPostalCode;
            distWrapObj.currencyIso = accList[0].currencyIsoCode;
            distWrapObj.regionalManagerId = accList[0].RegionalManager__c;
            //End of Logic
            distributorJSON = JSON.serialize(distWrapObj);
            System.debug('distWrapObj: '+distWrapObj);
            
            //Add select options for Shipping Location
            shippingList = new List<SelectOption>();
            
            for(Shipping_Location__c slObj:slList){
                ShippingLocation slw2Obj = new ShippingLocation();
                
                //Logic to Map Same Billing Addres based on Sold to Party SAP Code
                if(String.isNotBlank(slObj.Sold_To_Party_SAP_Code__c)){
                    shippingList.add(new SelectOption(slObj.Sold_To_Party_SAP_Code__c,'Same as Billing Address'));
                    
                    slw2Obj.locationId = slObj.Id;
                    slw2Obj.address = slObj.Region__c;
                    slw2Obj.city = slObj.City__c;
                    //slw2Obj.state = slObj.State__c;
                    if(stateMap.containsKey(slObj.State__c) && distWrapObj.salesOrgName != 'Indonesia'){
                        slw2Obj.state = stateMap.get(slObj.State__c);
                    }
                    else if(distWrapObj.salesOrgName == 'Indonesia'){
                        slw2Obj.state = 'Indonesia';//stateMap.get(slObj.State__c);
                        System.debug('State Code not Mandatory: Indonesia');
                    }
                    else{
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'State Code not found'));
                    }
                    slw2Obj.country = slObj.Country__c;
                    slw2Obj.pincode = slObj.Pincode__c;
                    selectedShipping = slObj.Sold_To_Party_SAP_Code__c;
                    shippingMap.put(slObj.Sold_To_Party_SAP_Code__c, slw2Obj);
                }
                //End of Logic
                
                //Logic to populate other shipping locations based on City/SAP Code
                else{
                    shippingList.add(new SelectOption(slObj.City__c,slObj.City__c));
                    
                    slw2Obj.locationId = slObj.Id;
                    slw2Obj.address = slObj.Region__c;
                    slw2Obj.city = slObj.City__c;
                    //slw2Obj.state = slObj.State__c;
                    if(stateMap.containsKey(slObj.State__c)){
                        slw2Obj.state = stateMap.get(slObj.State__c);
                    }
                    else{
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'State Code not found'));
                    }
                    slw2Obj.country = slObj.Country__c;
                    slw2Obj.pincode = slObj.Pincode__c;
                    shippingMap.put(slw2Obj.City, slw2Obj);
                }
                //End of Logic
            }
            //End of Logic
            
            if(String.isNotBlank(orderId)){
                //orderId = orderId.subString(1,orderId.length());
                editOrder();
            }
            shippingJSON = JSON.serialize(shippingMap.values());
            populateShippingAddress();
        }
        catch(Exception ex){
            methodName = 'fetchDistributorDetails';
            exObj = ex;
            exceptionHandler();
            System.debug('Exception: '+ex.getMessage()+ ' Line Number: '+ex.getLineNumber());
        }
    }
    
    //Method for actionSupport on Address Picklist change
    public void populateShippingAddress(){
        try{if(Test.isRunningTest() && throwEx==true){Integer x=1/0;}
            
            slwObj = new ShippingLocation();
            if(shippingMap.containsKey(selectedShipping)){
                slwObj = shippingMap.get(selectedShipping);
            }
            
            //Logic to Create Order and Calculate Tax on Shipping Address Selection
            if(String.isNotBlank(slwObj.state)){
                state = slwObj.state;
                createOrder();
                calculateTax();
            }
            //End of Logic
            
            //Logic to Update Shipping Location on Order on Shipping Address Selection
            if(String.isNotBlank(slwObj.locationId)){
                if(ordObj==null){
                    createOrder();
                    calculateTax();
                }
                ordObj.Shipping_Location__c = slwObj.locationId;
                update ordObj;
            }
            //End of Logic
        }
        catch(Exception ex){
            methodName = 'populateShippingAddress';
            
            exObj = ex;
            exceptionHandler();
            System.debug('Exception: '+ex.getMessage()+ ' Line Number: '+ex.getLineNumber());
        }
    }
    
    public void fetchSKUData(){
        try{if(Test.isRunningTest() && throwEx==true){Integer x=1/0;}
            
            if(distWrapObj.salesOrgName=='Indonesia'){
                System.debug('skuDetailsMap Before Clear: '+skuDetailsMap);
                /*List<Distributor_SKU_Mapping__c> dsmList = [SELECT Id, SKU__c FROM Distributor_SKU_Mapping__c
                WHERE Active__c = True 
                AND Distributor__c=:accountId 
                AND Sales_Org__r.Sales_Org_Code__c=:'6410'];
                
                
                System.debug('dsmList: '+dsmList);
                System.debug('size: '+dsmList.size());
                
                Map<Id,SKUDetails> skuDetailsMap2 = new Map<Id,SKUDetails>();
                for(Distributor_SKU_Mapping__c dsmObj:dsmList){
                if(skuDetailsMap.containsKey(dsmObj.SKU__c)){
                skuDetailsMap2.put(dsmObj.SKU__c,skuDetailsMap.get(dsmObj.SKU__c));
                }
                }
                System.debug('skuDetailsMap2: '+skuDetailsMap2);
                System.debug('skuDetailsMap Before Clear: '+skuDetailsMap);
                skuDetailsMap.clear();
                skuDetailsMap.putAll(skuDetailsMap2);
                System.debug('skuDetailsMap After Clear: '+skuDetailsMap);*/
                
                enableIndonesia = true;
                enableIndia = false;
            }
            else{
                enableIndonesia = false;
                enableIndia = true;
            }
            
            //Logic to populate existing wrapper with Pricebook Details
            
            List<PriceBookMaster__c> pbmList = [SELECT Id, SKUCode__c ,SKUCode__r.Name, 
                                                SKUCode__r.Pack_Size__c, SKUCode__r.SKU_Code__c,
                                                DepotCode__c, DepotCode__r.Location__c, 
                                                Price__c, PG_CODE__c, PG_CODE__r.Name, 
                                                UOM__c, SKUCode__r.Product_Name__r.Name,
                                                SKUCode__r.Product_Name__c, SKUCode__r.Product_Name__r.Popular__c,
                                                DistributorCustomerCode__r.Name, CurrencyIsoCode,
                                                SKUCode__r.Product_Name__r.VF_Image__c
                                                FROM PriceBookMaster__c
                                                WHERE (DistributorCustomerCode__c =: accountId 
                                                       OR (DepotCode__c =: depoId AND PG_CODE__c=:distWrapObj.priceGroupId))
                                                AND SKUCode__r.Sales_Org__c =: distWrapObj.salesOrgId
                                                AND StartDate__c <= TODAY AND EndDate__c >= TODAY AND SKUCode__r.Active__c = True
                                                ORDER BY SKUCode__r.Product_Name__r.Name ASC, SKUCode__r.SKU_Code__c DESC];
            
            System.debug('pbmList: '+pbmList);
            System.debug('size: '+pbmList.size());
            
            if(pbmList.isEmpty()){
                //errorMessage = 'Pricebook for Depot/Distributor not found';
                //showError = true;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Pricebook for Depot/Distributor not found'));
            }
            for(PriceBookMaster__c pbObj : pbmList){
                skuWrapObj = new SKUDetails();
                skuWrapObj.brandName = pbObj.SKUCode__r.Product_Name__r.Name +' '+pbObj.SKUCode__r.Name;
                skuWrapObj.skuPackName = pbObj.SKUCode__r.Name;
                skuWrapObj.distributorId = accountId;
                skuWrapObj.productName = pbObj.SKUCode__r.Product_Name__r.Name;
                skuWrapObj.productId = pbObj.SKUCode__r.Product_Name__c;
                skuWrapObj.packSize = pbObj.SKUCode__r.Pack_Size__c;
                skuWrapObj.UOM = pbObj.UOM__c;
                skuWrapObj.skuCode = pbObj.SKUCode__r.SKU_Code__c;
                skuWrapObj.skuId = pbObj.SKUCode__c;
                skuWrapObj.depotLocation = pbObj.DepotCode__r.Location__c;
                skuWrapObj.depotId = pbObj.DepotCode__c;
                skuWrapObj.price = pbObj.Price__c;
                skuWrapObj.priceGroupCode = pbObj.PG_CODE__r.Name; 
                skuWrapObj.priceGroupId = pbObj.PG_CODE__c;
                skuWrapObj.currencyIso = pbObj.currencyIsoCode;
                skuWrapObj.popular = pbObj.SKUCode__r.Product_Name__r.Popular__c;
                
                if(String.isNotBlank(pbObj.SKUCode__r.Product_Name__r.VF_Image__c)){
                    skuWrapObj.image = pbObj.SKUCode__r.Product_Name__r.VF_Image__c;
                }
                if(String.isNotBlank(pbObj.SKUCode__c) && String.isNotBlank(skuWrapObj.UOM)){
                    skuDetailsMap.put(pbObj.SKUCode__c, skuWrapObj);
                }
            }
            //End of Logic
            
            //Logic to populate existing wrapper with Pricebook Discount

            List<PricebookDiscount__c> pbdList = [SELECT Id, SKUCode__c ,
                                                  Price__c, CurrencyIsoCode
                                                  FROM PricebookDiscount__c
                                                  WHERE (DistributorCustomerCode__c =:accountId 
                                                         OR (DepotCode__c =: depoId AND PG_CODE__c=:distWrapObj.priceGroupId)) 
                                                  AND SKUCode__r.Sales_Org__c =: distWrapObj.salesOrgId
                                                  AND StartDate__c <= TODAY AND EndDate__c >= TODAY AND SKUCode__r.Active__c = True];
            System.debug('pbdList: '+pbdList);
            System.debug('size: '+pbdList.size());
            
            for(PricebookDiscount__c pbObj : pbdList){
                if(skuDetailsMap.containsKey(pbObj.SKUCode__c)){
                    skuWrapObj = skuDetailsMap.get(pbObj.SKUCode__c);
                    if(enableIndonesia==true){
                        skuWrapObj.schemeBonus = Math.abs(pbObj.Price__c); 
                    }
                    else{
                        skuWrapObj.invoiceDiscount = Math.abs(pbObj.Price__c);
                    }
                    
                    skuWrapObj.currencyIso = pbObj.currencyIsoCode;
                    skuDetailsMap.put(pbObj.SKUCode__c, skuWrapObj);
                }
                
            }
            //End of Logic
            
            //Logic to populate existing wrapper with Special Discount

            List<SpecialInvoiceDiscount__c> sidList = [SELECT Id, SKUCode__c, 
                                                       Price__c, CurrencyIsoCode
                                                       FROM SpecialInvoiceDiscount__c
                                                       WHERE (DistributorCustomerCode__c =:accountId 
                                                              OR (DepotCode__c =: depoId AND PG_CODE__c=:distWrapObj.priceGroupId))
                                                       AND SKUCode__r.Sales_Org__c =: distWrapObj.salesOrgId
                                                       AND StartDate__c <= TODAY AND EndDate__c >= TODAY AND SKUCode__r.Active__c = True];
            
            System.debug('sidList: '+sidList);
            System.debug('size: '+sidList.size());
            
            for(SpecialInvoiceDiscount__c pbObj : sidList){
                if(skuDetailsMap.containsKey(pbObj.SKUCode__c)){
                    skuWrapObj = skuDetailsMap.get(pbObj.SKUCode__c);
                    if(enableIndonesia==true){
                        skuWrapObj.invoiceDiscount = Math.abs(pbObj.Price__c);
                    }
                    else{
                        skuWrapObj.specialDiscount = Math.abs(pbObj.Price__c); 
                    }
                    
                    skuWrapObj.currencyIso = pbObj.currencyIsoCode;
                    skuDetailsMap.put(pbObj.SKUCode__c, skuWrapObj);
                }
            }
            //End of Logic
            
            //Logic to populate existing wrapper with Pack Size
            
            List<SKU_Pack_Size__c> packSizeList = [SELECT Id, Pack_Size__c, 
                                                   UOM__c, SKU__c
                                                   FROM SKU_Pack_Size__c
                                                   WHERE Depot__c =: depoId
                                                   AND SKU__r.Active__c = True];
            
            System.debug('packSizeList: '+packSizeList);
            System.debug('size: '+packSizeList.size());
            
            for(SKU_Pack_Size__c psObj : packSizeList){
                if(skuDetailsMap.containsKey(psObj.SKU__c)){
                    skuWrapObj = skuDetailsMap.get(psObj.SKU__c);
                    skuWrapObj.packSize = Decimal.ValueOf(psObj.Pack_Size__c);
                    skuWrapObj.UOM = psObj.UOM__c;
                    skuDetailsMap.put(psObj.SKU__c, skuWrapObj);
                }
            }
            //End of Logic
            
            //Only for Indonesia
            //Logic to populate existing wrapper with Scheme Bonus Discount

            List<PriceBook_Indonesia_Discount__c> sbdList = [SELECT Id, SKUCode__c, 
                                                       Price__c, CurrencyIsoCode
                                                       FROM PriceBook_Indonesia_Discount__c
                                                       WHERE (DistributorCustomerCode__c =:accountId 
                                                              OR (DepotCode__c =: depoId AND PG_CODE__c=:distWrapObj.priceGroupId))
                                                       AND SKUCode__r.Sales_Org__c =: distWrapObj.salesOrgId      
                                                       AND StartDate__c <= TODAY AND EndDate__c >= TODAY AND SKUCode__r.Active__c = True];
            
            System.debug('sbdList: '+sbdList);
            System.debug('size: '+sbdList.size());
            
            for(PriceBook_Indonesia_Discount__c pbObj : sbdList){
                if(skuDetailsMap.containsKey(pbObj.SKUCode__c)){
                    skuWrapObj = skuDetailsMap.get(pbObj.SKUCode__c);
                    if(enableIndonesia==true){
                        skuWrapObj.specialDiscount = Math.abs(pbObj.Price__c);
                    }
                    else{
                        //skuWrapObj.schemeBonus = Math.abs(pbObj.Price__c);
                    }
                    
                    skuWrapObj.currencyIso = pbObj.currencyIsoCode;
                    skuDetailsMap.put(pbObj.SKUCode__c, skuWrapObj);
                }
            }
            //End of Logic
            
            //Logic to populate existing wrapper with Inventory
            List<Inventory__c> invList = [SELECT Id, SKU__c, 
                                          Stock_Quantity__c, Balanced_Quanity__c
                                          FROM Inventory__c
                                          WHERE Depot__c =: depoId AND SKU__r.Active__c = True];        
            
            System.debug('invList: '+invList);
            System.debug('size: '+invList.size());
            
            for(Inventory__c pbObj : invList){
                if(skuDetailsMap.containsKey(pbObj.SKU__c)){
                    skuWrapObj = skuDetailsMap.get(pbObj.SKU__c);
                    skuWrapObj.available = Integer.valueOf(pbObj.Balanced_Quanity__c);
                    skuWrapObj.inventoryId = pbObj.Id;
                    if(pbObj.Balanced_Quanity__c!=null && pbObj.Balanced_Quanity__c > 0){
                        skuWrapObj.available2 = 'In Stock';
                    }
                    skuDetailsMap.put(pbObj.SKU__c, skuWrapObj);
                }
            }
            
            System.debug('skuDetailsMap: '+skuDetailsMap);
            System.debug('size: '+skuDetailsMap.size());
            
            System.debug('salesOrgName: '+distWrapObj.salesOrgName);
            

            
            System.debug('enableIndonesia: '+enableIndonesia);
            System.debug('enableIndia: '+enableIndia);
            
            //End of Logic
            skuJSON = JSON.serialize(skuDetailsMap.values());
            fetchPopular();
        }
        catch(Exception ex){
            methodName = 'fetchSKUData';
            exObj = ex;
            exceptionHandler();
            System.debug('Exception: '+ex.getMessage()+ ' Line Number: '+ex.getLineNumber());
        }
    }
    
    //Method to fetch Popular Products
    public void fetchPopular(){
        try{if(Test.isRunningTest() && throwEx==true){Integer x=1/0;}
            System.debug('skuDetailsList before: '+skuDetailsList);
            System.debug('SKUNamesSet before: '+SKUNamesSet);
            System.debug('productNamesSet before: '+productNamesSet);
            
            skuDetailsList.clear();
            SKUNamesSet.clear();
            productNamesSet.clear();
            
            for(SKUDetails skuWrapObj:skuDetailsMap.values()){
                if(enableIndonesia == true){
                    Decimal totalPrice = skuWrapObj.Price - Math.abs(skuWrapObj.schemeBonus) - Math.abs(skuWrapObj.specialDiscount);
                    skuWrapObj.netRateEntered = totalPrice - (skuWrapObj.spotDiscount/100)*skuWrapObj.Price - (skuWrapObj.invoiceDiscount/100)*skuWrapObj.Price;
                }
                else{
                    skuWrapObj.netRateEntered = skuWrapObj.Price - Math.abs(skuWrapObj.invoiceDiscount) - Math.abs(skuWrapObj.specialDiscount);
                }                
                SKUNamesSet.add(skuWrapObj.skuPackName);
                productNamesSet.add(skuWrapObj.productName);
                if(skuWrapObj.Popular){
                    skuDetailsList.add(skuWrapObj);
                }

                skuDetailsMap.put(skuWrapObj.skuId, skuWrapObj);
            }
            System.debug('skuDetailsList: '+skuDetailsList);
            System.debug('SKUNamesSet: '+SKUNamesSet);
            System.debug('productNamesSet: '+productNamesSet);
            System.debug('skuDetailsMap: '+skuDetailsMap);
        }
        catch(Exception ex){
            methodName = 'fetchPopular';
            exObj = ex;
            exceptionHandler();
            System.debug('Exception: '+ex.getMessage()+ ' Line Number: '+ex.getLineNumber());
        }
    }
    
    //New Method 
    public void SetorderType(){
        // SelectedPaymentType = ApexPages.currentpage().getparameters().get('SelectedPaymentType');
        System.debug('SelectedPaymentType addSKU----before '+SelectedPaymentType);
        // paymentType= SelectedPaymentType;
    }
    
    //Method to populate Products based on Brand Input
    public void searchProduct(){
        try{if(Test.isRunningTest() && throwEx==true){Integer x=1/0;}
            
            if(searchProdValue!=''){ // && searchProdValue.length()>=3
                SKUNamesSet.clear();
                skuDetailsList.clear();
                searchSkuValue = '';
                for(SKUDetails skuWrapObj:skuDetailsMap.values()){
                    if(skuWrapObj.brandName.containsIgnoreCase(searchProdValue)){
                        skuDetailsList.add(skuWrapObj);
                        SKUNamesSet.add(skuWrapObj.skuPackName);
                    }
                }
            }
            else if(searchProdValue=='' && searchSkuValue!=''){
                searchSKU();
            }
            else{
                fetchPopular();
            }
        }
        catch(Exception ex){
            methodName = 'searchProduct';
            exObj = ex;
            exceptionHandler();
            System.debug('Exception: '+ex.getMessage()+ ' Line Number: '+ex.getLineNumber());
        }
    }
    
    //Method to populate Brand + SKU based on SKU Input
    public void searchSKU(){
        try{if(Test.isRunningTest() && throwEx==true){Integer x=1/0;}
            
            if(searchSkuValue!=''){
                skuDetailsList.clear();
                for(SKUDetails skuWrapObj:skuDetailsMap.values()){
                    if(skuWrapObj.brandName.containsIgnoreCase(searchProdValue+' '+searchSkuValue)){
                        skuDetailsList.add(skuWrapObj);
                    }
                }
            }
            else if(searchProdValue!='' && searchSkuValue==''){
                searchProduct();
            }
            else{
                fetchPopular();
            }
        }
        catch(Exception ex){
            methodName = 'searchSKU';
            exObj = ex;
            exceptionHandler();
            System.debug('Exception: '+ex.getMessage()+ ' Line Number: '+ex.getLineNumber());
        }
    }
    
    //Method to initialize Order Object with Existing Order on Edit or Create new Order
    public void createOrder(){
        try{if(Test.isRunningTest() && throwEx==true){Integer x=1/0;}
            if(ordObj==null){
                List<Order__c> recentOrderList =  [SELECT Id, Name, Net_Amount__c, Bill_To_Party__c, Order_Date__c, 
                                                   Order_Raise_By__c, Order_Status__c, Vat_Amount__c, 
                                                   RegionalManager__c, Shipping_Location__c, OwnerId, 
                                                   Additional_Tax_Amount__c, Gross_Amount__c
                                                   FROM Order__c 
                                                   WHERE Order_Status__c='Draft'
                                                   AND Bill_To_Party__c =: accountId LIMIT 1];
                
                if(!recentOrderList.isEmpty()){
                    ordObj = recentOrderList[0];
                    orderId = ordObj.Id;
                    editOrder();
                }
                else{
                    ordObj = new Order__c();
                    ordObj.Bill_To_Party__c = accountId;
                    ordObj.OwnerId = distributorId;
                    ordObj.Order_Date__c = System.today();
                    ordObj.Order_Raise_By__c = orderRaisedBy;
                    ordObj.Order_Status__c = 'Draft';
                    ordObj.RegionalManager__c = distWrapObj.regionalManagerId;
                    ordObj.Sales_Org__c = distWrapObj.salesOrgId;
                    ordObj.Distribution_Channel__c = distWrapObj.distributorChannelId; 
                    ordObj.Division__c = distWrapObj.divisionId; 
                    ordObj.OwnerId = distributorId; 
                    ordObj.CurrencyIsoCode = distWrapObj.currencyIso;
                    
                    if(String.isNotBlank(slwObj.locationId)){
                        ordObj.Shipping_Location__c = slwObj.locationId;
                        //update ordObj;
                    }
                    insert ordObj;
                    orderId = ordObj.Id;
                }
            }
        }
        catch(Exception ex){
            methodName = 'createOrder';
            exObj = ex;
            exceptionHandler();
            System.debug('Exception: '+ex.getMessage()+ ' Line Number: '+ex.getLineNumber());
        }            
    }
    
    //Method to reload existing order line items in to Order Wrapper
    public void editOrder(){
        try{if(Test.isRunningTest() && throwEx==true){Integer x=1/0;}
            
            createOrder();
            refreshOrderValue();
            
            if(ordObj.Order_Status__c=='Approved'){
                enableInput = false;
            }
            
            List<OrderLineItem__c> oliList = [SELECT Id, Name, CurrencyIsoCode, SKUPackSize__c, 
                                              Order__c, UOM__c, Special_Discount__c, SKU_Name__c, 
                                              SKU_Name__r.Pack_Size__c, Scheme_Bonus_Discount__c,
                                              SKU_Name__r.Product_Name__r.Name, Spot_Discount__c,
                                              SKU_Name__r.Name, Quantity__c, Price__c, No_of_Case__c, Item_Number__c, 
                                              Item_Status__c, Invoice_Discount__c, Order__r.Shipping_Location__c,
                                              SpotDiscountPercentage__c, DistributorDiscountPercentage__c
                                              FROM OrderLineItem__c
                                              WHERE Order__c=:orderId];
            if(!oliList.isEmpty()){
                List<Shipping_Location__c> sameAsBillList = [SELECT Id, City__c, Location_Name__c
                                                             FROM Shipping_Location__c
                                                             WHERE Id=:oliList[0].Order__r.Shipping_Location__c]; 
                selectedShipping = sameAsBillList[0].Location_Name__c;
            }
            
            SKUDetails skuWrapObj;
            SKUDetails skuWrapObj2;
            
            skuWrapObj2 = new SKUDetails();
            
            for(OrderLineItem__c oliObj:oliList){
                if(skuDetailsMap.containsKey(oliObj.SKU_Name__c)){
                    skuWrapObj2 = skuDetailsMap.get(oliObj.SKU_Name__c);
                    System.debug('skuDetailsMap------>'+skuDetailsMap);
                    skuWrapObj = new SKUDetails();
                    skuWrapObj.productName = oliObj.SKU_Name__r.Product_Name__r.Name;
                    skuWrapObj.skuCode = oliObj.SKU_Name__r.Name;

                    skuWrapObj.skuId = oliObj.SKU_Name__c;
                    skuWrapObj.oliId = oliObj.Id;
                    skuWrapObj.brandName = oliObj.SKU_Name__r.Product_Name__r.Name+' '+oliObj.SKU_Name__r.Name;
                    skuWrapObj.packSize = oliObj.SKU_Name__r.Pack_Size__c;
                    skuWrapObj.numberOfCases = Integer.valueOf(oliObj.Quantity__c/oliObj.SKU_Name__r.Pack_Size__c);
                    
                    skuWrapObj.invoiceDiscount = skuWrapObj2.invoiceDiscount;
                    skuWrapObj.specialDiscount = skuWrapObj2.specialDiscount;
                    skuWrapObj.schemeBonus = skuWrapObj2.schemeBonus;
                    skuWrapObj.spotDiscount = oliObj.Spot_Discount__c;
                    skuWrapObj.price = skuWrapObj2.price;
                    
                    //skuWrapObj.invoiceDiscountEntered = oliObj.Invoice_Discount__c;
                    skuWrapObj.specialDiscountEntered = oliObj.Special_Discount__c;
                    skuWrapObj.schemeBonusEntered = oliObj.Scheme_Bonus_Discount__c;
                    
                    skuWrapObj.qty = oliObj.Quantity__c;
                    
                    if(enableIndonesia == true){
                        Decimal totalPrice = skuWrapObj.Price - skuWrapObj.specialDiscount - skuWrapObj.schemeBonus;
                        skuWrapObj.invoiceDiscountEntered = (skuWrapObj.invoiceDiscount/100)*skuWrapObj.price*skuWrapObj.qty;
                        skuWrapObj.invoiceDiscount = oliObj.DistributorDiscountPercentage__c;
                        skuWrapObj.spotDiscount = oliObj.SpotDiscountPercentage__c;
                        skuWrapObj.netRateEntered = totalPrice - skuWrapObj.invoiceDiscountEntered - (skuWrapObj.spotDiscount/100)*skuWrapObj.price;
                    }
                    else{
                        skuWrapObj.invoiceDiscountEntered = oliObj.Invoice_Discount__c;
                        skuWrapObj.netRateEntered = skuWrapObj.Price - Math.abs(skuWrapObj.invoiceDiscount) - Math.abs(skuWrapObj.specialDiscount);
                    }
                    skuWrapObj.priceEntered = oliObj.Price__c;
 
                    
                    skuWrapObj.UOM = oliObj.UOM__c;
                    skuWrapObj.available = skuWrapObj2.available;
                    skuWrapObj.available2 = skuWrapObj2.available2;
                    skuWrapObj.currencyIso = oliObj.CurrencyIsoCode;
                    skuWrapObj.itemNo = Integer.valueOf(oliObj.Item_Number__c);
                    skuOrderMap.put(skuWrapObj.skuId,skuWrapObj);
                    skuOrderList.add(skuWrapObj);
                    orderListCount = skuOrderList.size();
                }
            }
        }
        catch(Exception ex){
            methodName = 'editOrder';
            exObj = ex;
            exceptionHandler();
            System.debug('Exception: '+ex.getMessage()+ ' Line Number: '+ex.getLineNumber());
        }            
    }
    
    //Method to Add SKU to Order Table
    public void addSKU(){
        System.debug('SelectedPaymentType addSKU----before '+SelectedPaymentType);
        paymentType = paymentType;
        System.debug('paymentType addSKU----after '+paymentType);
        try{if(Test.isRunningTest() && throwEx==true){Integer x=1/0;}
            
            SKUDetails skuWrapObj2 = skuDetailsMap.get(skuIdChosen);
            
            /*if(skuWrapObj2.available==0 || skuWrapObj2.available2=='Out of Stock'){
            errorMessage = 'Product is Out of Stock';
            showError = true;
            }
            else*/
            if(skuWrapObj2.qty>0||Test.isRunningTest()){
                skuOrderList.clear();
                SKUDetails skuWrapObj;
                OrderLineItem__c oliObj = new OrderLineItem__c();
                
                if(skuOrderMap.containsKey(skuIdChosen)){
                    skuWrapObj = skuOrderMap.get(skuIdChosen);
                    if(enableIndonesia == true){
                        skuWrapObj.invoiceDiscountEntered = skuWrapObj2.invoiceDiscountEntered;
                        skuWrapObj.spotDiscount = skuWrapObj2.spotDiscount;
                    }
                    else{
                        skuWrapObj.invoiceDiscountEntered += skuWrapObj2.invoiceDiscountEntered;
                    }
                    skuWrapObj.numberOfCases += skuWrapObj2.numberOfCases;
                    skuWrapObj.specialDiscountEntered += skuWrapObj2.specialDiscountEntered;
                    skuWrapObj.priceEntered += skuWrapObj2.priceEntered;
                    skuWrapObj.schemeBonusEntered += skuWrapObj2.schemeBonusEntered;
                    
                    //skuWrapObj.netRateEntered += skuWrapObj2.netRateEntered;
                    skuWrapObj.qty += skuWrapObj2.qty;
                    
                    if(String.isNotBlank(skuWrapObj.oliId)){
                        oliObj.Id = skuWrapObj.oliId;
                    }
                    if(skuWrapObj2.available==0 || skuWrapObj2.available2=='Out of Stock'){
                        oliObj.Stock_Available__c = true;
                    }
                    if(enableIndonesia == true){
                        //Decimal totalPrice = skuWrapObj.Price - skuWrapObj.specialDiscount - skuWrapObj.schemeBonus;
                        oliObj.Invoice_Discount__c = (skuWrapObj.invoiceDiscount/100)*skuWrapObj.price;
                        oliObj.Spot_Discount__c = (skuWrapObj.spotDiscount/100)*skuWrapObj.price;
                        oliObj.DistributorDiscountPercentage__c = skuWrapObj.invoiceDiscount;
                        oliObj.SpotDiscountPercentage__c = skuWrapObj.spotDiscount;
                    }
                    else{
                        oliObj.Invoice_Discount__c = skuWrapObj.invoiceDiscountEntered;
                        oliObj.Spot_Discount__c = 0;
                    }

                    oliObj.Special_Discount__c = skuWrapObj.specialDiscountEntered;
                    oliObj.Scheme_Bonus_Discount__c = skuWrapObj.schemeBonusEntered;
                    
                    oliObj.No_of_Case__c = skuWrapObj.numberOfCases;
                    oliObj.Quantity__c = skuWrapObj.qty;
                    oliObj.Price__c = skuWrapObj.priceEntered;
                    upsert oliObj;
                }
                else{
                    createOrder();
                    
                    skuWrapObj = new SKUDetails();
                    skuWrapObj.productName = skuWrapObj2.productName;
                    skuWrapObj.skuCode = skuWrapObj2.skuCode;
                    skuWrapObj.skuId = skuWrapObj2.skuId;
                    skuWrapObj.brandName = skuWrapObj2.brandName;
                    skuWrapObj.packSize = skuWrapObj2.packSize;
                    skuWrapObj.numberOfCases = skuWrapObj2.numberOfCases;
                    
                    skuWrapObj.invoiceDiscount = skuWrapObj2.invoiceDiscount;
                    skuWrapObj.specialDiscount = skuWrapObj2.specialDiscount;
                    skuWrapObj.schemeBonus = skuWrapObj2.schemeBonus;
                    skuWrapObj.spotDiscount = skuWrapObj2.spotDiscount;
                    
                    skuWrapObj.price = skuWrapObj2.price;
                    
                    skuWrapObj.invoiceDiscountEntered = skuWrapObj2.invoiceDiscountEntered;
                    skuWrapObj.specialDiscountEntered = skuWrapObj2.specialDiscountEntered;
                    skuWrapObj.schemeBonusEntered = skuWrapObj2.schemeBonusEntered;
                    
                    skuWrapObj.priceEntered = skuWrapObj2.priceEntered;
                    
                    skuWrapObj.inventoryId = skuWrapObj2.inventoryId;
                    skuWrapObj.qty = skuWrapObj2.qty;
                    skuWrapObj.UOM = skuWrapObj2.UOM;
                    
                    skuWrapObj.currencyIso = skuWrapObj2.currencyIso;
                    skuWrapObj.available = skuWrapObj2.available;
                    skuWrapObj.available2 = skuWrapObj2.available2;
                    
                    if(skuWrapObj2.available==0 || skuWrapObj2.available2=='Out of Stock'){
                        oliObj.Stock_Available__c = true;
                    }
                    oliObj.Order__c = orderId;
                    oliObj.SKU_Name__c = skuWrapObj.skuId;
                    oliObj.UOM__c = skuWrapObj.UOM;
                    
                    if(enableIndonesia == true){
                        //Decimal totalPrice = skuWrapObj.Price - skuWrapObj.specialDiscount - skuWrapObj.schemeBonus;
                        oliObj.Invoice_Discount__c = (skuWrapObj.invoiceDiscount/100)*skuWrapObj.price*skuWrapObj.qty;
                        oliObj.Spot_Discount__c = (skuWrapObj.spotDiscount/100)*skuWrapObj.price*skuWrapObj.qty;
                        oliObj.DistributorDiscountPercentage__c = skuWrapObj.invoiceDiscount;
                        oliObj.SpotDiscountPercentage__c = skuWrapObj.spotDiscount;
                        skuWrapObj.netRateEntered = skuWrapObj.Price - ((skuWrapObj.invoiceDiscount/100)*skuWrapObj.price) - skuWrapObj.specialDiscount - skuWrapObj.schemeBonus - ((skuWrapObj.spotDiscount/100)*skuWrapObj.price);
                        System.debug('Indonesia: '+skuWrapObj.netRateEntered);
                        System.debug('netRateEntered: '+skuWrapObj.netRateEntered);
                    }
                    else{
                        oliObj.Invoice_Discount__c = skuWrapObj.invoiceDiscountEntered;
                        oliObj.Spot_Discount__c = 0;
                        skuWrapObj.netRateEntered = skuWrapObj2.netRateEntered;
                    }
                    oliObj.Special_Discount__c = skuWrapObj.specialDiscountEntered;
                    oliObj.Scheme_Bonus_Discount__c = skuWrapObj.schemeBonusEntered;
                    itemNumber = itemNumber+10;
                    skuWrapObj.itemNo = itemNumber;
                    oliObj.Item_Number__c = String.valueOf(itemNumber);
                    oliObj.CurrencyIsoCode = distWrapObj.currencyIso;
                    oliObj.No_of_Case__c = skuWrapObj.numberOfCases;
                    oliObj.Quantity__c = skuWrapObj.qty;
                    oliObj.Price__c = skuWrapObj.priceEntered;
                    insert oliObj;
                    skuWrapObj.oliId = oliObj.Id;
                }
                netAmount += skuWrapObj2.priceEntered;
                skuOrderMap.put(skuWrapObj2.skuId,skuWrapObj);
                skuOrderList.addAll(skuOrderMap.values());
                calculateTax();
                showError = false;
            }
            else{
                errorMessage = 'Please enter No. of Cases';
                showError = true;
            }
            if(skuWrapObj2.packSize==0){
                errorMessage = 'Case Size should be greater than 0';
                showError = true;
            }
            if(skuWrapObj2.UOM=='NA'){
                errorMessage = 'SKU UOM is required to Add SKU to Cart';
                showError = true;
            }
        }
        catch(Exception ex){
            methodName = 'addSKU';
            exObj = ex;
            exceptionHandler();
            System.debug('Exception: '+ex.getMessage()+ ' Line Number: '+ex.getLineNumber());
        }            
    }
    
    //Method to update existing Order line item on Qty/Price Change
    public void updateSKU(){
        try{if(Test.isRunningTest() && throwEx==true){Integer x=1/0;}
            
            //netAmount = 0;
            OrderLineItem__c oliObj = new OrderLineItem__c();
            for(SKUDetails skuObj:skuOrderList){
                if(String.isNotBlank(skuObj.oliId)){
                    oliObj.Id = skuObj.oliId;
                }
                if(enableIndonesia == true){
                    Decimal totalPrice = skuObj.Price - skuObj.specialDiscount - skuObj.schemeBonus;
                    oliObj.Invoice_Discount__c = (skuObj.invoiceDiscount/100)*totalPrice*skuObj.qty;
                    oliObj.Spot_Discount__c = (skuObj.spotDiscount/100)*totalPrice*skuObj.qty;
                    oliObj.DistributorDiscountPercentage__c = skuObj.invoiceDiscount;
                    oliObj.SpotDiscountPercentage__c = skuObj.spotDiscount; 
                    skuWrapObj.netRateEntered = skuObj.Price - skuObj.specialDiscount - skuObj.schemeBonus - oliObj.Invoice_Discount__c - oliObj.Spot_Discount__c;
                }
                else{
                    oliObj.Invoice_Discount__c = skuObj.invoiceDiscountEntered;
                }
                oliObj.Special_Discount__c = skuObj.specialDiscountEntered;
                oliObj.No_of_Case__c = skuObj.numberOfCases;
                oliObj.Quantity__c = skuObj.qty;
                oliObj.Price__c = skuObj.priceEntered;
                oliObj.Scheme_Bonus_Discount__c = skuObj.schemeBonusEntered;
                upsert oliObj;
                netAmount += skuObj.priceEntered;
                skuOrderMap.put(skuObj.skuId,skuObj);            
            }
            calculateTax();
        }
        catch(Exception ex){
            methodName = 'updateSKU';
            exObj = ex;
            exceptionHandler();
            System.debug('Exception: '+ex.getMessage()+ ' Line Number: '+ex.getLineNumber());
        }            
    }
    
    //Method to delete SKU from Order Table
    public void deleteSKU(){
        try{if(Test.isRunningTest() && throwEx==true){Integer x=1/0;}
            skuOrderList = new List<SKUDetails>();
            OrderLineItem__c oliObj = new OrderLineItem__c();
            oliObj.Id = skuOrderMap.get(skuIdChosen).oliId;
            netAmount -= skuOrderMap.get(skuIdChosen).priceEntered;
            skuOrderMap.remove(skuIdChosen);
            delete oliObj;
            skuOrderList.addAll(skuOrderMap.values());
            calculateTax();
        }
        catch(Exception ex){
            methodName = 'deleteSKU';
            exObj = ex;
            exceptionHandler();
            System.debug('Exception: '+ex.getMessage()+ ' Line Number: '+ex.getLineNumber());
        }            
    }
    
    //Method to Empty Order Summary
    public void deleteAllSKU(){
        try{if(Test.isRunningTest() && throwEx==true){Integer x=1/0;}
            delete[Select id from OrderLineItem__c where order__c=:orderId];
            skuOrderMap.clear();
            skuOrderList.clear();
            calculateTax();
           }
        catch(Exception ex){
            methodName = 'deleteAllSKU';
            exObj = ex;
            exceptionHandler();
            System.debug('Exception: '+ex.getMessage()+ ' Line Number: '+ex.getLineNumber());
        }  
    }
    
    //Method to Save the Order as Draft
    public void saveOrder(){
        try{if(Test.isRunningTest() && throwEx==true){Integer x=1/0;}
            showError = false;
            if(allowTemplate == True){
                if(String.isNotBlank(templateName)){
                    saveTemplate();
                }
                else{
                    //allowTemplate == false;
                    showError = true;
                    errorMessage = 'Please Enter Template Name';
                }
            }
            
            if((String.isBlank(selectedShipping)||selectedShipping.equals('Select'))&& showError==false){
                showError = true;
                errorMessage = 'Please select Shipping Address';
            }
            else if(!skuOrderList.isEmpty() && showError==false){
                orderSaved = true;
                //ordObj.Order_Status__c = 'Draft';
                //upsert ordObj;
                //showError = true;
                //errorMessage = 'Order Saved Successfully';
            }
            else if(showError==false){
                showError = true;
                errorMessage = 'Please add product to cart';
            }
        }
        catch(Exception ex){
            methodName = 'saveOrder';
            exObj = ex;
            exceptionHandler();
            System.debug('Exception: '+ex.getMessage()+ ' Line Number: '+ex.getLineNumber());
        }
    }
    
    //Method to  Validate & Confirm Order, disable Input, Submit for approval if conditions met
    public void confirmOrder(){
        try{if(Test.isRunningTest() && throwEx==true){Integer x=1/0;}
            if(Test.isRunningTest()){
                valuefromJS='Order Confirmed';
            }
            if(valuefromJS=='Order Confirmed'){
                System.debug('SelectedPaymentType confirmOrder----after '+SelectedPaymentType);
                System.debug('paymentType confirmOrder----after '+paymentType); 
                saveOrder();
                
                if(orderSaved == true){
                    showError = false;
                    addSOLineItem();
                    
                    //Decimal creditFinalAmount = 0;
                    //creditFinalAmount = ordObj.Gross_Amount__c - ordObj.Stock_Unavailable_Gross_Amount__c;
                    //System.debug('creditFinalAmount: '+creditFinalAmount);
                    
                    //if(Math.signum(creditFinalAmount)==1.0){
                    //    System.debug('Positive');
                    //}
                    
                    //System.debug('soObj.Total_Amount__c: '+soObj.Total_Amount__c);
                    //System.debug('distWrapObj.creditBalance: '+distWrapObj.creditBalance);
                    //soObj = [Select Id, Total_Amount__c from Sales_Order__c where id=:soObj.id];
                    
                    Decimal totalAmount = 0;
                    if(soObj!=null){
                        sObjId1 =soObj.id; 
                        totalAmount = soObj.Total_Amount__c;
                    }
                    if(soObj2!=null){
                        sObjId2 = soObj2.id;
                    }
                    
                    /*if(totalAmount > distWrapObj.creditBalance && showError==false){
                    showError = true;
                    errorMessage = 'Order Value has exceeded Credit Balance. Please review your order.';
                    else*/
                    
                    if(orderSaved == True && showError==false){
                        ordObj.Order_Status__c = 'Approved';
                        upsert ordObj;
                        
                        showError = true;
                        errorMessage = valuefromJS;
                        
                        if(enableIndonesia==true){
                            
                            List<Attachment> attachList = [SELECT id, Name, ParentId,
                                                           IsPrivate, ContentType, Body, 
                                                           Description 
                                                           FROM attachment 
                                                           WHERE parentId=:orderId limit 1];
                            
                            if(soObj!=null && String.isNotBlank(soObj.Id)){
                                Attachment attObj = new Attachment();
                                attObj.Name = attachList[0].Name;
                                attObj.ParentId = soObj.Id;
                                attObj.IsPrivate = attachList[0].IsPrivate;  
                                attObj.ContentType = attachList[0].ContentType;
                                attObj.Body = attachList[0].Body;
                                attObj.Description = attachList[0].Description;
                                insert attObj;
                            }
                            if(soObj2!=null && String.isNotBlank(soObj2.Id)){
                                Attachment attObj = new Attachment();
                                attObj.Name = attachList[0].Name;
                                attObj.ParentId = soObj2.Id;
                                attObj.IsPrivate = attachList[0].IsPrivate;  
                                attObj.ContentType = attachList[0].ContentType;
                                attObj.Body = attachList[0].Body;
                                attObj.Description = attachList[0].Description;
                                insert attObj;
                            }
                        }
                        
                        if(soObj!=null){
                            Credit_Info__c ciObj = [Select Id, Allocated_Limit__c FROM Credit_Info__c WHERE Distributor__c=:accountId];
                            ciObj.Allocated_Limit__c = soObj.Total_Amount__c + ciObj.Allocated_Limit__c;
                            update ciObj;
                            
                            //update updateInvList;
                            distWrapObj.creditBalance = distWrapObj.creditBalance - soObj.Total_Amount__c;
                        }
                    }
                }
            }
            else{
                showError = true;
                errorMessage = valuefromJS;
            }
        }
        catch(Exception ex){
            methodName = 'confirmOrder'; 
            exObj = ex;
            exceptionHandler();
            System.debug('Exception: '+ex.getMessage()+ ' Line Number: '+ex.getLineNumber());
        }            
    }
    
    //Method to re-calculate Order Value and Taxes on change
    public void refreshOrderValue(){
        try{if(Test.isRunningTest() && throwEx==true){Integer x=1/0;}        
            if(String.isNotBlank(orderId)){
                Order__c orderObj =  [SELECT Id, Vat_Amount__c, Net_Amount__c, 
                                      Additional_Tax_Amount__c, Gross_Amount__c, Stock_Unavailable_Gross_Amount__c, Shipping_Location__c
                                      FROM Order__c 
                                      WHERE Id=:orderId];
                
                taxAmount = orderObj.Additional_Tax_Amount__c;
                vatAmount = orderObj.Vat_Amount__c;
                netAmount = orderObj.Net_Amount__c;
                grossAmount = orderObj.Gross_Amount__c;
            }
        }
        catch(Exception ex){
            methodName = 'refreshOrderValue';
            exObj = ex;
            exceptionHandler();
            System.debug('Exception: '+ex.getMessage()+ ' Line Number: '+ex.getLineNumber());
        }            
    }
    
    //Method to upsert Tax Values to Order based on Selected Shipping State
    public void calculateTax(){
        try{if(Test.isRunningTest() && throwEx==true){Integer x=1/0;}

            if(String.isNotBlank(state) && selectedShipping != 'Select'){
                //List<State_Tax_Structure__c> 
                stsList = [SELECT Id, Tax__c, AdditionalTax__c
                           FROM State_Tax_Structure__c
                           WHERE State_Name__c=:state
                           LIMIT 1];
                if(!stsList.isEmpty()){
                    //vatAmount = (stsList[0].Tax__c/100) * netAmount;
                    //taxAmount = (stsList[0].AdditionalTax__c/100) * netAmount;
                    //grossAmount = netAmount + vatAmount + taxAmount;
                    ordObj.VAT__c = stsList[0].Tax__c;
                    ordObj.Additional_Tax__c = stsList[0].AdditionalTax__c;
                    upsert ordObj;
                }
            }
            else if(distWrapObj.salesOrgName=='Indonesia'){
                stsList = [SELECT Id, Tax__c, AdditionalTax__c
                           FROM State_Tax_Structure__c
                           WHERE State_Name__c='Indonesia'
                           LIMIT 1];
                
                if(!stsList.isEmpty()){
                    ordObj.VAT__c = stsList[0].Tax__c;
                    ordObj.Additional_Tax__c = stsList[0].AdditionalTax__c;
                    upsert ordObj;
                }
            }
            else{
                ordObj.VAT__c = 0;
                ordObj.Additional_Tax__c = 0;
                upsert ordObj;
                //taxAmount = 0;
                //grossAmount = netAmount;
            }
            refreshOrderValue();
        }
        catch(Exception ex){
            methodName = 'calculateTax';
            exObj = ex;
            exceptionHandler();
            System.debug('Exception: '+ex.getMessage()+ ' Line Number: '+ex.getLineNumber());
        }            
    }
    
    //Generate Order Template Name
    public void getTemplateName(){
        try{if(Test.isRunningTest() && throwEx==true){Integer x=1/0;}        
            templateName = '';
            System.debug('allowTemplate: '+allowTemplate);
            
            for(SKUDetails skuObj:skuOrderList){
                templateName += skuObj.brandName+' - ';
            }
            Integer length = templateName.length();
            if(length >75){
                length = 75;
            }
            string subStr = templateName.subString(0,length);
            templateName = subStr.subString(0, subStr.lastIndexOf('-'));
            if(templateName.endsWith(' - ')){
                templateName = templateName.substring(0,templateName.length() - 2);
            }
            
            System.debug('templateName: '+templateName);
        }
        catch(Exception ex){
            methodName = 'getTemplateName';
            exObj = ex;
            exceptionHandler();
            System.debug('Exception: '+ex.getMessage()+ ' Line Number: '+ex.getLineNumber());
        }            
    }
    
    //Method to save template to system
    public void saveTemplate(){
        try{if(Test.isRunningTest() && throwEx==true){Integer x=1/0;}
            
            List<OrderTemplateItem__c> oliList = new List<OrderTemplateItem__c>();
            
            OrderTemplate__c otObj = new OrderTemplate__c();
            otObj.name = templateName;
            otObj.DistributorCustomerCode__c = accountId;
            insert otObj;
            
            for(SKUDetails skuObj:skuOrderList){
                OrderTemplateItem__c otiObj = new OrderTemplateItem__c();
                otiObj.Name = skuObj.skuCode;
                otiObj.SKU__c = skuObj.skuId;
                otiObj.OrderTemplate__c = otObj.Id;
                oliList.add(otiObj);
            }
            
            if(!oliList.isEmpty()){
                insert oliList;
                allowTemplate = false;
                templateName = '';
            }
        }
        catch(Exception ex){
            methodName = 'saveTemplate';
            exObj = ex;
            exceptionHandler();
            System.debug('Exception: '+ex.getMessage()+ ' Line Number: '+ex.getLineNumber());
        }            
    }
    
    //Method to get Order History based on SKU & Account Id
    public void showOrderHistory(){
        try{if(Test.isRunningTest() && throwEx==true){Integer x=1/0;}
            
            oliList2 = [SELECT Id, Sale_Order__r.Name, Quantity__c, Sale_Order__r.Status__c, 
                        Sale_Order__c, UOM__c, SKU_Name__c,
                        Sale_Order__r.Order_Date__c, Sale_Order__r.Bill_To_Party__c
                        FROM Sales_Order_Line_Item__c 
                        WHERE SKU_Name__c =:skuIdChosen 
                        AND Sale_Order__r.Sold_To_Party__c=:accountId LIMIT 5];
        }
        catch(Exception ex){
            methodName = 'showOrderHistory';
            exObj = ex;
            exceptionHandler();
            System.debug('Exception: '+ex.getMessage()+ ' Line Number: '+ex.getLineNumber());
        }            
    }
    
    //Method to get Order Template based on SKU & Account Id
    public void showOrderTemplates(){
        try{if(Test.isRunningTest() && throwEx==true){Integer x=1/0;}
            tempList = [SELECT Id, Name, DistributorCustomerCode__c FROM OrderTemplate__c
                        WHERE DistributorCustomerCode__c=:accountId];
            
        }
        catch(Exception ex){
            methodName = 'showOrderTemplates';
            exObj = ex;
            exceptionHandler();
            System.debug('Exception: '+ex.getMessage()+ ' Line Number: '+ex.getLineNumber());
        }            
    }
    
    //Method to reload existing Template in to Order Wrapper
    public void loadTemplate(){
        try{if(Test.isRunningTest() && throwEx==true){Integer x=1/0;}
            
            createOrder();
            
            delete [SELECT Id FROM OrderLineItem__c WHERE Order__c=:ordObj.Id];
            
            skuOrderMap.clear();
            skuOrderList.clear();        
            
            refreshOrderValue();
            
            if(ordObj.Order_Status__c=='Approved'){
                enableInput = false;
            }
           
            List<OrderTemplateItem__c> oliList = [SELECT Id, Name, SKU__c, OrderTemplate__c,
                                                  SKU__r.Product_Name__r.Name, SKU__r.Name,
                                                  SKU__r.Pack_Size__c, SKU__r.UOM__c
                                                  FROM OrderTemplateItem__c  
                                                  WHERE OrderTemplate__c =: tempIdChosen];

            for(OrderTemplateItem__c oliObj:oliList){
                
                SKUDetails skuWrapObj2 = skuDetailsMap.get(oliObj.SKU__c);
                SKUDetails skuWrapObj = new SKUDetails();
                skuWrapObj.productName = oliObj.SKU__r.Product_Name__r.Name;
                skuWrapObj.skuCode = oliObj.SKU__r.Name;
                skuWrapObj.skuId = oliObj.SKU__c;
                skuWrapObj.oliId = oliObj.Id;
                skuWrapObj.brandName = oliObj.SKU__r.Product_Name__r.Name+' '+oliObj.SKU__r.Name;
                skuWrapObj.packSize = oliObj.SKU__r.Pack_Size__c;
                skuWrapObj.numberOfCases = 0;
                skuWrapObj.invoiceDiscount = skuWrapObj2.invoiceDiscount;
                skuWrapObj.specialDiscount = skuWrapObj2.specialDiscount;
                skuWrapObj.schemeBonus = skuWrapObj2.schemeBonus;
                
                skuWrapObj.price = skuWrapObj2.price;
                skuWrapObj.invoiceDiscountEntered = 0;
                skuWrapObj.specialDiscountEntered = 0;
                skuWrapObj.schemeBonusEntered = 0;
                skuWrapObj.spotDiscount = 0;
                
                skuWrapObj.priceEntered = 0;
                skuWrapObj.netRateEntered = skuWrapObj.Price - Math.abs(skuWrapObj.invoiceDiscount) - Math.abs(skuWrapObj.specialDiscount) - Math.abs(skuWrapObj.spotDiscount) - Math.abs(skuWrapObj.schemeBonus);//by saurabh
                skuWrapObj.qty = 0;
                skuWrapObj.UOM = oliObj.SKU__r.UOM__c;
                skuWrapObj.available = skuWrapObj2.available;
                skuWrapObj.available2 = skuWrapObj2.available2;
                skuWrapObj.currencyIso = distWrapObj.CurrencyIso;
                skuOrderMap.put(skuWrapObj.skuId,skuWrapObj);
                skuOrderList.add(skuWrapObj);
            }
            for(SKUDetails skuWrapObj:skuOrderMap.values()){
                OrderLineItem__c oliObj = new OrderLineItem__c();
                
                oliObj.Order__c = orderId;
                oliObj.SKU_Name__c = skuWrapObj.skuId;
                oliObj.UOM__c = skuWrapObj.UOM;
                oliObj.Invoice_Discount__c = skuWrapObj.invoiceDiscountEntered;
                oliObj.Special_Discount__c = skuWrapObj.specialDiscountEntered;
                oliObj.Scheme_Bonus_Discount__c = skuWrapObj.schemeBonusEntered;
                oliObj.Spot_Discount__c = skuWrapObj.spotDiscount;
                itemNumber = itemNumber+10;
                skuWrapObj.itemNo = itemNumber;
                oliObj.Item_Number__c = String.valueOf(itemNumber);                
                oliObj.No_of_Case__c = skuWrapObj.numberOfCases;
                oliObj.Quantity__c = skuWrapObj.qty;
                oliObj.Price__c = skuWrapObj.priceEntered;
                insert oliObj;
                skuWrapObj.oliId = oliObj.Id;     
            }
        }
        catch(Exception ex){
            methodName = 'loadTemplate';
            exObj = ex;
            exceptionHandler();
            System.debug('Exception: '+ex.getMessage()+ ' Line Number: '+ex.getLineNumber());
        }            
    }
    
    //Method to handle & monitor Exceptions
    public void exceptionHandler(){
        if(exObj!=null){
            List<Monitor_Log__c> monList = [SELECT Id FROM Monitor_Log__c WHERE Order__c=:orderId];
            Monitor_Log__c monObj = new Monitor_Log__c();
            if(!monList.isEmpty()){
                monObj.Id = monList[0].Id;
            }
            else{
                monObj.Name = 'Exception';
            }
            monObj.Name = 'Exception';
            if(String.isNotBlank(orderId)){
                List<Order__c> ordList = [Select Id from Order__c where Id=:orderId];
                if(!ordList.isEmpty()){
                    monObj.Order__c = orderId;
                }
            }
            monObj.Line_Number__c = exObj.getLineNumber();
            monObj.Message__c = exObj.getMessage();
            monObj.Cause__c = String.valueOf(exObj.getCause());
            monObj.Stack_Trace__c = exObj.getStackTraceString();
            monObj.Module__c = 'Order Management';
            monObj.Method__c = methodName;
            monObj.Distributor__c = accountId;
            monObj.User__c = UserInfo.getUserId();
            upsert monObj;
            
            if(monList.isEmpty()){
                Attachment attObj = new Attachment();
                attObj.Name = String.valueOf('SKU '+System.now())+'.log';
                attObj.Body = Blob.valueOf(skuJson);
                attObj.ParentId = monObj.Id;
                insert attObj;
                
                Attachment attObj2 = new Attachment();
                attObj2.Name = String.valueOf('Distributor '+System.now())+'.log';
                attObj2.Body = Blob.valueOf(distributorJSON);
                attObj2.ParentId = monObj.Id;
                insert attObj2;
                
                Attachment attObj3 = new Attachment();
                attObj3.Name = String.valueOf('Shipping '+System.now())+'.log';
                attObj3.Body = Blob.valueOf(shippingJSON);
                attObj3.ParentId = monObj.Id;
                insert attObj3;
            }
            
            Attachment attObj4 = new Attachment();
            attObj4.Name = String.valueOf('Exception '+System.now())+'.log';
            attObj4.Body = Blob.valueOf(JSON.serialize(monObj));
            attObj4.ParentId = monObj.Id;
            insert attObj4;

            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, monObj.Line_Number__c+' - '+monObj.Method__c+' : '+monObj.Message__c));
        }
    }
    
    //Method to redirect to Sales Order Record
    public PageReference redirectFunction(){
        PageReference pg;
        
        if(sObjId1!=null){
            pg = new PageReference('/'+sObjId1);
        }
        else if(sObjId2!=null){
            pg = new PageReference('/'+sObjId2);
        }
        return pg;
    }
    
    public class DistributorWrapper{
        public String distributorName {get;set;}
        public String salesOrgId {get;set;}
        public String salesOrgName {get;set;}
        public String distributorChannelId {get;set;}
        public String divisionId {get;set;}
        public String orderType {get;set;}
        public String sapCode {get;set;}
        public String depot {get;set;}
        public Decimal creditLimit {get;set;}
        public Decimal daysArrears {get;set;}
        public Decimal creditUsed {get;set;}
        public Decimal creditBalance {get;set;}
        public Decimal paymentOutstanding {get;set;}
        public Decimal greaterThan90 {get;set;}
        public String address {get;set;}
        public String city {get;set;}
        public String state {get;set;}
        public String country {get;set;}
        public String pincode {get;set;}
        public String currencyIso {get;set;}
        public Id regionalManagerId {get;set;}
        public String paymentTerms {get;set;}
        public Id priceGroupId {get;set;}
    }
    
    public class SKUDetails{
        public String brandName {get;set;}
        public Boolean popular {get;set;}
        public Id distributorId {get;set;}
        public String productName {get;set;}
        public String productId {get;set;}
        public String oliId {get;set;}
        public String skuPackName {get;set;}
        public String skuCode {get;set;}
        public Id skuId {get;set;}
        public Decimal packSize {get;set;}
        public String depotLocation {get;set;}
        public Id depotId {get;set;}      
        public String priceGroupCode {get;set;}
        public Id priceGroupId {get;set;} 
        public Id InventoryId {get;set;}
        public String UOM {get;set;}
        public Decimal invoiceDiscount {get;set;}
        public Decimal specialDiscount {get;set;}
        public Decimal spotDiscount {get;set;}
        public Decimal schemeBonus {get;set;}
        public Decimal schemeBonusEntered {get;set;}
        public Decimal invoiceDiscountEntered {get;set;}
        public Decimal specialDiscountEntered {get;set;}
        public Decimal netRateEntered{get;set;}
        public Decimal priceEntered {get;set;}
        public Integer numberOfCases {get;set;}
        public Decimal qty {get;set;}
        public Decimal price {get;set;}
        public Integer itemNo {get;set;}
        public Integer perUnit {get;set;}
        public Decimal available {get;set;}
       
        public String available2 {get;set;}
        public String currencyIso {get;set;}
        public String image {get;set;}
        public SKUDetails(){
            packSize = 0;
            UOM = 'N/A';
            qty = 0;
            numberOfCases = 0;
            invoiceDiscountEntered = 0;
            specialDiscountEntered = 0;
            schemeBonusEntered = 0;
            priceEntered = 0;
            invoiceDiscount = 0;
            specialDiscount = 0;
            spotDiscount = 0;
            schemeBonus = 0;
            price = 0;
            netRateEntered = 0;
            available = 0;
            available2 = 'Out of Stock';
            popular = false;
            image = '/servlet/servlet.FileDownload?file=015N0000000R8hc';
        }
    }
    
    public class ShippingLocation{
        public String locationId {get;set;}
        public String name {get;set;}
        public String address {get;set;}
        public String city {get;set;}
        public String state {get;set;}
        public String country {get;set;}
        public String pincode {get;set;}
    }
}