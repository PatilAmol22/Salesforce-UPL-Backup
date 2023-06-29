public without sharing class Catalog_Controller {
    //Order Management Variables
    public List<String> searchList {get;set;}
    public DistributorWrapper distWrapObj {get;set;}
    public SKUDetails skuWrapObj {get;set;}
    public ShippingLocation slwObj {get;set;}
    public Shipping_Location__c slwObj2 {get;set;}
    
    public List<SelectOption> shippingList {get;set;}
    public List<SKUDetails> skuDetailsList {get;set;}
    public List<SKUOrder> skuOrderList {get;set;}
    
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
    public Map<Id,SKUOrder> skuOrderMap {get;set;}
    public Map<String,List<SKUDetails>> skuMap {get;set;}
    public Map<String,String> stateMap {get;set;}
    
    public Set<String> SKUNamesSet{get;set;}
    public Set<String> productNamesSet{get;set;}
    public Set<String> depotSet{get;set;}
    
    public String selectedShipping {get;set;}
    public String selectedDepot {get; set;}
    public String searchSkuValue {get; set;}
    public String searchProdValue {get; set;}
    public String newAddress {get; set;}
    public String errorMessage {get; set;}
    public String state {get; set;}
    public String skuIdChosen {get; set;}
    public String tempIdChosen {get; set;}
    public String orderRaisedBy {get; set;}
    public String cpId {get;set;}
    public String redirectURI {get;set;}
    
    public Boolean showError{get;set;}
    public Boolean showCredit{get;set;}
    public Boolean showInventory{get;set;}
    public Boolean enableInput{get;set;}
    public Boolean throwEx{get;set;}
    public Boolean allowAddress{get;set;}
    public Boolean orderSaved{get;set;}
    
    public Decimal netAmount {get;set;}
    public Decimal grossAmount {get;set;}
    public Decimal taxAmount {get;set;}
    public Decimal vatAmount {get;set;}
    
    public Integer itemNumber;
    
    //public String orderId{get;set;}
    //public String accountId{get;set;}
    public String depoId;
    public String distributorId;
    public String territoryManagerId;
    public String methodName;
    
    public Order__c ordObj {get;set;}
    public Sales_Order__c soObj {get;set;}
    public Sales_Order__c soObj2 {get;set;}
    public User loginUserObj {get;set;}
    public Exception exObj;
    //End of Code
    
     /*Abhishek --
    */
    public List<SelectOption> PaymentOptions{get;set;}
    public String paymentType{get;set;}
    public String SelectedPaymentType{get;set;} 
    /**/
    
    // Primarily Catalog variables
    public Map<String, String> familyMap {get;set;}
    public Map<String, SKUDetails> productMap {get;set;}
    public Integer numberOfFamilies {get;set;}
    //public List<Product2> productsInFamily {get;set;}
    public String hostURL {get;set;}
    //public Catalog_Template__c myCatalogTemplate {get;set;}
    public String backgroundURL {get;set;}
    public String currencyCode{get;set;}    
    // Primarily Cart variables
    //public Set<String> productSet {get;set;}
    //public String productId {get;set;}
    public String accountId {get;set;}
    public String orderId {get;set;}
    //public Integer productQuantity {get;set;}
    //public Catalog_Order__c myOrder {get;set;}
    //public List<Catalog_Line_item__c> myLineItems {get;set;}
    
    // Lookup Component variables
    public string debugString {get;set;}
    //public String lookupValue {get;set;}
    //public sObject myObject {get;set;}
    //public String objectName {get;set;}
    //public String objectField {get;set;}
    //
    //public String filter {get;set;}
    
    //public Set<SKUDetails> productList {get;set;}
    
    public Catalog_Controller() {
        try{
        //Abhishek 
         PaymentOptions = new List<SelectOption>();
             PaymentOptions.add(new SelectOption('Cash','Cash'));
             PaymentOptions.add(new SelectOption('Credit','Credit'));
             paymentType='Credit';  
             SelectedPaymentType='';
         //abhishek    
            //Order Management
            searchList = new List<String>();
            searchList.add('ULALA');
            currencyCode = 'INR';
            slwObj = new ShippingLocation();
            slwObj2 = new Shipping_Location__c();
            SKUNamesSet = new Set<String>();
            productNamesSet = new Set<String>();
            depotSet = new Set<String>();
            
            skuDetailsList = new List<SKUDetails>();
            skuOrderList = new List<SKUOrder>();
            oliList = new List<OrderLineItem__c>();
            
            skuOrderMap = new Map<Id,SKUOrder>();
            shippingMap = new Map<String, ShippingLocation>();
            skuDetailsMap = new Map<Id,SKUDetails>();
            skuMap = new Map<String,List<SKUDetails>>();
            familyMap = new Map<String, String>();
            productMap = new Map<String, SKUDetails>();
            stateMap = new Map<String, String>(); 
            
            searchSkuValue = '';
            searchProdValue = '';
            errorMessage = '';
            skuIdChosen = '';
            state = '';
            orderRaisedBy = '';
            methodName = '';
            cpid = '';
            redirectURI = '';
            
            showError = false;
            throwEx = false;
            enableInput = true;
            showCredit = false;
            showInventory = false;
            orderSaved = false;
            allowAddress = false;
            
            netAmount = 0;
            taxAmount = 0;
            grossAmount = 0;
            vatAmount = 0;
            
            itemNumber = 0;
            
            accountId = '';
            distributorId = '';
            depoId = '';
            territoryManagerId = '';
            
            //orderId = ApexPages.currentpage().getparameters().get('id');
            
            accountId = ApexPages.currentpage().getparameters().get('acid');
            System.debug('accountId: '+accountId);
            
            loginUserObj = [SELECT Id, Name, IsActive, ContactId, PortalRole,
                            Show_Inventory__c,DefaultCurrencyIsoCode, Show_Credit_Limit__c
                            FROM User 
                            WHERE Id =: UserInfo.getUserId()
                            AND IsActive = True];
            currencyCode = loginUserObj.DefaultCurrencyIsoCode;
            showInventory = loginUserObj.Show_Inventory__c;
            showCredit =  loginUserObj.Show_Credit_Limit__c;
            
            //Assign account Id if TM creates order on behalf of Distributor
            if(String.isNotBlank(accountId)){
                //enableDepot = loginUserObj.EnableDepot__c;
                system.debug('acc id  ----- '+accountId);
                distributorId = [SELECT Id FROM User where Contact.AccountId =: accountId].Id;
                orderRaisedBy = 'Territory Manager';
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
                    //accountId = '001N000000qg8AT';
                    accountId = '001N000000qg8BE';
                }
                orderRaisedBy = 'Distributor';
                //enableDepot = false;
            }
            
            depotList = [SELECT id, Depot__c 
                         FROM Distributor_Depot_Mapping__c 
                         WHERE Distributor__c=:accountId LIMIT 1];
            
            if(!depotList.isEmpty()){
                depoId = depotList[0].Depot__c;
            }
            system.debug('depotList[ ----'+depotList);
            //fetchDistributorDetails();
            //End of Code
            if(!Test.isRunningTest()){
                prepareBackground();
            }
            //prepareCatalog();
            //prepareCart();
            //prepareCatalogTemplate();
            debugString = 'My debug';
            
            //productList = new Set<SKUDetails>();
            
            /*productList  = [SELECT ID, Family, VF_Image__c,name 
                              FROM Product2 
                              WHERE Popular__c = true order by id desc limit 6 ];*/
            //WHERE Popular__c = true AND VF_Image__c!='/resource/1474914704000/No_Image' order by id desc limit 6 ];
            
        }
        catch(Exception ex){
            methodName = 'Constructor';
            //exObj = ex;
            //exceptionHandler();
            System.debug('Exception: '+ex.getMessage()+ ' Line Number: '+ex.getLineNumber());
        }
    }
    
    public Pagereference getRedirect(){
        cpId = ApexPages.currentpage().getparameters().get('cpid');
        
        if(cpId == 'true'){
            redirectURI = '/apex/catalog_products';  
        }
        else{
            redirectURI = '/apex/CatalogHome';
        }
        PageReference pg = new PageReference(redirectURI);
        return pg.setRedirect(false);
    }
    public Pagereference redirectFalse(){
        //Default setRedirect Value if false
        PageReference pg = new PageReference('/apex/SearchPage?cpid=true');
        return pg.setRedirect(true);
    }
    
    //Method to fetch Distributor Details, Depot, Credit Information and Shipping Details
    public void fetchDistributorDetails(){
        try{if(Test.isRunningTest() && throwEx==true){Integer x=1/0;}
            
            List<Account> accList = [SELECT Id, Name, BillingCity, BillingCountry, RegionalManager__c,
                                     BillingStreet, BillingState, BillingPostalCode , CurrencyIsoCode, 
                                     OwnerId, Owner.Name, Owner.MobilePhone, SAP_Code__c, Sales_Org__c, Distribution_Channel__c, Division__c,
                                     Order_Type__c, Order_Block__c, Status__c, Owner.SmallPhotoUrl, Payment_Terms__c, PriceGroupCode__c
                                     FROM Account 
                                     WHERE Id=:accountId LIMIT 1];
            
            territoryManagerId = accList[0].OwnerId;
            
            System.debug('territoryManagerId:'+territoryManagerId);
            
            List<Distributor_Depot_Mapping__c> dmList = [SELECT id, Distributor__c ,Depot__c, Depot__r.Location__c 
                                                         FROM Distributor_Depot_Mapping__c 
                                                         WHERE Distributor__c=:accountId LIMIT 1];
            
            List<Credit_Info__c> ciList = [SELECT id, name,Distributor__c,distributor__r.name,
                                           Credit_Limit__c,Balance_Limit__c,Used_Limit__c, 
                                           Allocated_Balance_Limit__c, Sum_Open_Item__c, DAYS_ARREARS__c 
                                           FROM Credit_Info__c 
                                           WHERE Distributor__c =:accountId LIMIT 1];
            
            
            //Logic to add Account Details, Billing Address and Credit Information to Wrapper
            distWrapObj = new DistributorWrapper();
            distWrapObj.distributorName = accList[0].Name;
            distWrapObj.profileURI = accList[0].Owner.SmallPhotoUrl;
            distWrapObj.territoryManager = accList[0].Owner.Name;//(accList[0].Owner.Name).replaceAll('\\s+', ' ');
            System.debug('territoryManager: '+distWrapObj.territoryManager);
            distWrapObj.territoryPhone = accList[0].Owner.MobilePhone;
            distWrapObj.sapCode = accList[0].SAP_Code__c;
            distWrapObj.salesOrgId = accList[0].Sales_Org__c;
            distWrapObj.distributorChannelId = accList[0].Distribution_Channel__c;            
            distWrapObj.divisionId = accList[0].Division__c;   
            distWrapObj.ordertype = accList[0].Order_Type__c; 
            distWrapObj.paymentTerms = accList[0].Payment_Terms__c;
            distWrapObj.priceGroupId = accList[0].PriceGroupCode__c;
            
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
            
            //Populate StateMap Code to State Name
            for(State_Tax_Structure__c stateObj:[Select Id, State_Name__c, State_Code__c From State_Tax_Structure__c]){
                stateMap.put(stateObj.State_Code__c, stateObj.State_Name__c);
            }
            System.debug('stateMap: '+stateMap);
            //End of Logic
            
            List<Shipping_Location__c> slList = [SELECT Id, Name, Distributor__c, City__c, 
                                                 Region__c, Pincode__c, State__c, Country__c,
                                                 Sold_To_Party_SAP_Code__c, SAP_Code__c
                                                 FROM Shipping_Location__c
                                                 WHERE Distributor__c =:accountId];
            //AND Sold_To_Party_SAP_Code__c!=:distWrapObj.sapCode];
            
            /*List<TM_Depot_Mapping__c> tdmList = [SELECT Id, Depot__c, Depot__r.Location__c, Territory_Manager__c 
                                                    FROM TM_Depot_Mapping__c
                                                    WHERE Territory_Manager__c =:territoryManagerId];
            System.debug('tdmList:'+tdmList);
            for(TM_Depot_Mapping__c tdmObj:tdmList){
            depotSet.add(tdmObj.Depot__r.Location__c);
            }*/
            
            if(!dmList.isEmpty()){
                distWrapObj.depot = dmList[0].Depot__r.Location__c;
            }
            System.debug('distWrapObj.depot: '+distWrapObj.depot);
            
            if(String.isNotBlank(distWrapObj.depot)){
                fetchSKUData();
            }
            
            if(!ciList.isEmpty()){
                distWrapObj.creditLimit = ciList[0].Credit_Limit__c;
                distWrapObj.creditUsed = ciList[0].Used_Limit__c;
                distWrapObj.creditBalance = ciList[0].Allocated_Balance_Limit__c;
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
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Order cannot be placed. Reason - Insufficient Credit Balance'));
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
            
            //Add select options for Shipping Location
            shippingList = new List<SelectOption>();
            //shippingList.add(new SelectOption('Select','Select'));
            //shippingList.add(new SelectOption('Same as Billing Address','Same as Billing Address'));
            
            for(Shipping_Location__c slObj:slList){
                ShippingLocation slw2Obj = new ShippingLocation();
                
                //Logic to Map Same Billing Addres based on Sold to Party SAP Code
                if(String.isNotBlank(slObj.SAP_Code__c) && slObj.SAP_Code__c == distWrapObj.sapCode){
                    shippingList.add(new SelectOption(slObj.SAP_Code__c,'Same as Billing Address'));
                    
                    slw2Obj.locationId = slObj.Id;
                    slw2Obj.address = slObj.Region__c;
                    slw2Obj.city = slObj.City__c;
                    if(stateMap.containsKey(slObj.State__c)){
                        slw2Obj.state = stateMap.get(slObj.State__c);
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
                    if(stateMap.containsKey(slObj.State__c)){
                        slw2Obj.state = stateMap.get(slObj.State__c);
                    }
                    slw2Obj.country = slObj.Country__c;
                    slw2Obj.pincode = slObj.Pincode__c;
                    shippingMap.put(slw2Obj.City, slw2Obj);
                }
                //End of Logic
            }
            //End of Logic
            selectedShipping = distWrapObj.sapCode;
            editOrder();
            //populateShippingAddress();
           }
        catch(Exception ex){
            methodName = 'fetchDistributorDetails';
            exObj = ex;
            //exceptionHandler();
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
                //createOrder();
                calculateTax();
            }
            //End of Logic
            
            //Logic to Update Shipping Location on Order on Shipping Address Selection
            if(String.isNotBlank(slwObj.locationId)){
                ordObj.Shipping_Location__c = slwObj.locationId;
                update ordObj;
            }
            //End of Logic
           }
        catch(Exception ex){
            methodName = 'populateShippingAddress';
            
            exObj = ex;
            //exceptionHandler();
            System.debug('Exception: '+ex.getMessage()+ ' Line Number: '+ex.getLineNumber());
        }
    }
    
    //Method to fetch Popular Products
    public void fetchPopular(){
        try{if(Test.isRunningTest() && throwEx==true){Integer x=1/0;}
            numberOfFamilies = 0;
            skuDetailsList.clear();
            SKUNamesSet.clear();
            productNamesSet.clear();
            System.debug('sku map --- '+skuDetailsMap);
            System.debug('distWrapObj.priceGroupId ----- '+distWrapObj.priceGroupId);
            System.debug('conList  ----- '+conList );
             
            System.debug('depotList  ----- '+depotList  );
            for(SKUDetails skuWrapObj:skuDetailsMap.values()){
                skuWrapObj.netRateEntered = skuWrapObj.Price - skuWrapObj.invoiceDiscount - skuWrapObj.specialDiscount;
                //skuWrapObj.skuPackName = pbObj.SKUCode__r.SKU_Pack__c +' '+pbObj.SKUCode__r.SKU_UOM__c;
                SKUNamesSet.add(skuWrapObj.skuPackName);
                productNamesSet.add(skuWrapObj.productName);
                if(skuWrapObj.Popular){
                    //productList.add(skuWrapObj);
                    if(skuMap.containsKey(skuWrapObj.productName.replaceAll('\\s+',''))) {
                        List<skuDetails> skuList = skuMap.get(skuWrapObj.productName.replaceAll('\\s+',''));
                        skuList.add(skuWrapObj);
                        skuMap.put(skuWrapObj.productName.replaceAll('\\s+',''), skuList);
                    } else {
                        skuMap.put(skuWrapObj.productName.replaceAll('\\s+',''), new List<skuDetails> { skuWrapObj });
                    }
                    if(familyMap.containsKey(skuWrapObj.productName.replaceAll('\\s+',''))) {
                        //List<skuDetails> skuList = skuMap.get(skuWrapObj.productName);
                        //skuList.add(skuWrapObj);
                        familyMap.put(skuWrapObj.productName.replaceAll('\\s+',''), skuWrapObj.productName);
                    } else {
                        numberOfFamilies += 1;
                        familyMap.put(skuWrapObj.productName.replaceAll('\\s+',''), skuWrapObj.productName);
                    }
                    System.debug('familyMap: '+familyMap);
                    if(productMap.containsKey(skuWrapObj.productName.replaceAll('\\s+',''))) {
                        //List<skuDetails> skuList = skuMap.get(skuWrapObj.productName);
                        //skuList.add(skuWrapObj);
                        productMap.put(skuWrapObj.productName.replaceAll('\\s+',''), skuWrapObj);
                    } else {
                        productMap.put(skuWrapObj.productName.replaceAll('\\s+',''), skuWrapObj);
                    }
                    System.debug('productMap: '+productMap);
                }
                skuDetailsList.add(skuWrapObj);
                skuDetailsMap.put(skuWrapObj.skuId, skuWrapObj);
            }
            System.debug('skuMap: '+skuMap);
           }
        catch(Exception ex){
            methodName = 'fetchPopular';
            exObj = ex;
            exceptionHandler();
            System.debug('Exception: '+ex.getMessage()+ ' Line Number: '+ex.getLineNumber());
        }
    }
    
    //Method to populate Products based on Brand Input
    public void searchProduct(){
        try{if(Test.isRunningTest() && throwEx==true){Integer x=1/0;}
            
            if(searchProdValue!=''){
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
                //fetchPopular();
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
                //fetchPopular();
            }
           }
        catch(Exception ex){
            methodName = 'searchSKU';
            exObj = ex;
            exceptionHandler();
            System.debug('Exception: '+ex.getMessage()+ ' Line Number: '+ex.getLineNumber());
        }
    }
    public void fetchSKUData(){
        try{if(Test.isRunningTest() && throwEx==true){Integer x=1/0;}
            
            //Logic to populate existing wrapper with Pricebook Details
            System.debug('distWrapObj.priceGroupId ----- '+distWrapObj.priceGroupId);
            System.debug('depoId  ----- '+depoId );
            List<PriceBookMaster__c> pbmList = [SELECT Id, SKUCode__c ,SKUCode__r.Name, 
                                                SKUCode__r.Pack_Size__c,
                                                DepotCode__c, DepotCode__r.Location__c, 
                                                Price__c, PG_CODE__c, PG_CODE__r.Name, 
                                                UOM__c, SKUCode__r.Product_Name__r.Name,
                                                SKUCode__r.Product_Name__c, SKUCode__r.Product_Name__r.Popular__c,
                                                DistributorCustomerCode__r.Name, CurrencyIsoCode,
                                                SKUCode__r.Product_Name__r.VF_Image__c
                                                FROM PriceBookMaster__c
                                                WHERE (DistributorCustomerCode__c =: accountId 
                                                       OR (DepotCode__c =: depoId AND PG_CODE__c=:distWrapObj.priceGroupId))
                                                AND StartDate__c <= TODAY AND EndDate__c >= TODAY 
                                                ORDER BY SKUCode__r.Name ASC];
            
            for(PriceBookMaster__c pbObj : pbmList){
                skuWrapObj = new SKUDetails();
                skuWrapObj.brandName = pbObj.SKUCode__r.Product_Name__r.Name +' '+pbObj.SKUCode__r.Name;
                skuWrapObj.skuPackName = pbObj.SKUCode__r.Name;
                skuWrapObj.distributorId = accountId;
                skuWrapObj.productName = pbObj.SKUCode__r.Product_Name__r.Name;
                skuWrapObj.productId = pbObj.SKUCode__r.Product_Name__c;
               // skuWrapObj.packSize = Integer.valueOf(pbObj.SKUCode__r.Pack_Size__c);commented By abhishek
                skuWrapObj.packSize = pbObj.SKUCode__r.Pack_Size__c;
                skuWrapObj.UOM = pbObj.UOM__c;
                //skuWrapObj.packUOM = pbObj.SKUCode__r.SKU_UOM__c;
                skuWrapObj.skuCode = pbObj.SKUCode__r.Name;
                skuWrapObj.skuId = pbObj.SKUCode__c;
                skuWrapObj.depotLocation = pbObj.DepotCode__r.Location__c;
                skuWrapObj.depotId = pbObj.DepotCode__c;
                skuWrapObj.price = pbObj.Price__c;
                skuWrapObj.priceGroupCode = pbObj.PG_CODE__r.Name; 
                skuWrapObj.priceGroupId = pbObj.PG_CODE__c;
                skuWrapObj.currencyIso = pbObj.currencyIsoCode;
                skuWrapObj.popular = pbObj.SKUCode__r.Product_Name__r.Popular__c;
                if(String.isNotBlank(pbObj.SKUCode__r.Product_Name__r.VF_Image__c)){
                    skuWrapObj.image2 = pbObj.SKUCode__r.Product_Name__r.VF_Image__c;
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
                                                  AND StartDate__c <= TODAY AND EndDate__c >= TODAY];
            
            for(PricebookDiscount__c pbObj : pbdList){
                if(skuDetailsMap.containsKey(pbObj.SKUCode__c)){
                    skuWrapObj = skuDetailsMap.get(pbObj.SKUCode__c);
                    skuWrapObj.invoiceDiscount = pbObj.Price__c;
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
                                                       AND StartDate__c <= TODAY AND EndDate__c >= TODAY];
            
            for(SpecialInvoiceDiscount__c pbObj : sidList){
                if(skuDetailsMap.containsKey(pbObj.SKUCode__c)){
                    skuWrapObj = skuDetailsMap.get(pbObj.SKUCode__c);
                    skuWrapObj.specialDiscount = pbObj.Price__c;
                    skuWrapObj.currencyIso = pbObj.currencyIsoCode;
                    skuDetailsMap.put(pbObj.SKUCode__c, skuWrapObj);
                }
            }
            //End of Logic
            
            //Logic to populate existing wrapper with Inventory
            List<Inventory__c> invList = [SELECT Id, SKU__c, 
                                          Stock_Quantity__c, Balanced_Quanity__c
                                          FROM Inventory__c
                                          WHERE Depot__c =: depoId];        
            
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
            
            fetchPopular();
           }
        catch(Exception ex){
            methodName = 'fetchSKUData';
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
                                                   WHERE Order_Status__c='Draft' AND Bill_To_Party__c=:accountId LIMIT 1];
                
                if(!recentOrderList.isEmpty()){
                    ordObj = recentOrderList[0];
                    orderId = ordObj.Id;
                    System.debug('orderId: '+orderId);
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
            
            List<OrderLineItem__c> oliList = [SELECT Id, Name, CurrencyIsoCode, SKUPackSize__c, 
                                              Order__c, UOM__c, Special_Discount__c, SKU_Name__c, 
                                              SKU_Name__r.Pack_Size__c,
                                              SKU_Name__r.Product_Name__r.Name,
                                              SKU_Name__r.Name, Quantity__c, Price__c, No_of_Case__c, Item_Number__c, 
                                              Item_Status__c, Invoice_Discount__c, Order__r.Shipping_Location__c 
                                              FROM OrderLineItem__c
                                              WHERE Order__c=:orderId];
            if(!oliList.isEmpty()){
                List<Shipping_Location__c> sameAsBillList = [SELECT Id, City__c, Location_Name__c
                                                             FROM Shipping_Location__c
                                                             WHERE Id=:oliList[0].Order__r.Shipping_Location__c
                                                             AND Sold_To_Party_SAP_Code__c = '']; 
                if(!sameAsBillList.isEmpty()){
                    selectedShipping = sameAsBillList[0].Location_Name__c;
                }
                else{
                    selectedShipping = distWrapObj.sapCode; //distWrapObj.SAPCode;
                }
                
                //populateShippingAddress();
            }
            System.debug('oliList: '+oliList);
            System.debug('oliList.size(): '+oliList.size());
            SKUOrder skuWrapObj;
            SKUDetails skuWrapObj2;
            for(OrderLineItem__c oliObj:oliList){
                skuWrapObj2 = skuDetailsMap.get(oliObj.SKU_Name__c);
                skuWrapObj = new SKUOrder();
                skuWrapObj.productName = oliObj.SKU_Name__r.Product_Name__r.Name;
                skuWrapObj.skuCode = oliObj.SKU_Name__r.Name;
                skuWrapObj.skuId = oliObj.SKU_Name__c;
                skuWrapObj.oliId = oliObj.Id;
                skuWrapObj.brandName = oliObj.SKU_Name__r.Product_Name__r.Name+' '+oliObj.SKU_Name__r.Name;
                skuWrapObj.packSize = oliObj.SKU_Name__r.Pack_Size__c;
                skuWrapObj.numberOfCases = Integer.valueOf(oliObj.Quantity__c/oliObj.SKU_Name__r.Pack_Size__c);
                skuWrapObj.invoiceDiscount = skuWrapObj2.invoiceDiscount;
                skuWrapObj.specialDiscount = skuWrapObj2.specialDiscount;
                skuWrapObj.price = skuWrapObj2.price;
                skuWrapObj.invoiceDiscountEntered = oliObj.Invoice_Discount__c;
                skuWrapObj.specialDiscountEntered = oliObj.Special_Discount__c;
                skuWrapObj.priceEntered = oliObj.Price__c;
                skuWrapObj.netRateEntered = skuWrapObj.Price - skuWrapObj.invoiceDiscount - skuWrapObj.specialDiscount;
               // skuWrapObj.qty = Integer.valueOf(oliObj.Quantity__c); added by abhishek 
                skuWrapObj.qty = oliObj.Quantity__c;
                skuWrapObj.UOM = oliObj.UOM__c;
                //skuWrapObj.packUOM = oliObj.UOM__c; 
                skuWrapObj.available = skuWrapObj2.available;
                skuWrapObj.available2 = skuWrapObj2.available2;
                skuWrapObj.currencyIso = oliObj.CurrencyIsoCode;
                skuWrapObj.Image2 = skuWrapObj2.Image2;
                skuOrderMap.put(skuWrapObj.skuId,skuWrapObj);
                skuOrderList.add(skuWrapObj);
            }
           }
        catch(Exception ex){
            methodName = 'editOrder';
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
            //createOrder();
            
            if(String.isNotBlank(state) && selectedShipping != 'Select'){
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
            /*else{
            ordObj.VAT__c = 0;
            ordObj.Additional_Tax__c = 0;
            upsert ordObj;
            }
            ordObj.VAT__c = 12;
            ordObj.Additional_Tax__c = 12;
            upsert ordObj;*/
            refreshOrderValue();
           }
        catch(Exception ex){
            methodName = 'calculateTax';
            exObj = ex;
            exceptionHandler();
            System.debug('Exception: '+ex.getMessage()+ ' Line Number: '+ex.getLineNumber());
        }            
    }
    //Method to Add SKU to Order Table
    public void addSKU(){
        try{if(Test.isRunningTest() && throwEx==true){Integer x=1/0;}
            showError = false;
            SKUDetails skuWrapObj2 = skuDetailsMap.get(skuIdChosen);
            
            //skuOrderList.clear();
            SKUOrder skuWrapObj;
            OrderLineItem__c oliObj = new OrderLineItem__c();
            
            if(skuOrderMap.containsKey(skuIdChosen)){
                errorMessage = 'Product already added to Cart';
                showError = true;
            }
            else{
                createOrder();
                
                skuWrapObj = new SKUOrder();
                skuWrapObj.productName = skuWrapObj2.productName;
                skuWrapObj.skuCode = skuWrapObj2.skuCode;
                skuWrapObj.skuId = skuWrapObj2.skuId;
                skuWrapObj.brandName = skuWrapObj2.brandName;
                skuWrapObj.packSize = skuWrapObj2.packSize;
                skuWrapObj.numberOfCases = 1;//skuWrapObj2.numberOfCases;
                skuWrapObj.invoiceDiscount = skuWrapObj2.invoiceDiscount;
                skuWrapObj.specialDiscount = skuWrapObj2.specialDiscount;
                skuWrapObj.price = skuWrapObj2.price;
                skuWrapObj.invoiceDiscountEntered = skuWrapObj2.invoiceDiscountEntered;
                skuWrapObj.specialDiscountEntered = skuWrapObj2.specialDiscountEntered;
                skuWrapObj.netRateEntered = skuWrapObj2.netRateEntered;
                skuWrapObj.inventoryId = skuWrapObj2.inventoryId;
                skuWrapObj.qty = Integer.valueOf(skuWrapObj2.numberOfCases * skuWrapObj.packSize);
                skuWrapObj.priceEntered = (skuWrapObj2.price*skuWrapObj.qty)-(skuWrapObj2.invoiceDiscount*skuWrapObj.qty)-(skuWrapObj2.specialDiscount*skuWrapObj.qty);
                skuWrapObj.UOM = skuWrapObj2.UOM;
                skuWrapObj.packUOM = skuWrapObj2.packUOM; 
                skuWrapObj.currencyIso = skuWrapObj2.currencyIso;
                skuWrapObj.available = skuWrapObj2.available;
                skuWrapObj.available2 = skuWrapObj2.available2;
                skuWrapObj.image2 = skuWrapObj2.image2;
                
                if(skuWrapObj2.available==0 || skuWrapObj2.available2=='Out of Stock'){
                    oliObj.Stock_Available__c = true;
                }
                oliObj.Order__c = orderId;
                oliObj.SKU_Name__c = skuWrapObj.skuId;
                oliObj.UOM__c = skuWrapObj.UOM;
                oliObj.Invoice_Discount__c = skuWrapObj.invoiceDiscountEntered;
                oliObj.Special_Discount__c = skuWrapObj.specialDiscountEntered;
                itemNumber = itemNumber+10;
                skuWrapObj.itemNo = itemNumber;
                oliObj.Item_Number__c = String.valueOf(itemNumber);
                oliObj.CurrencyIsoCode = distWrapObj.currencyIso;
                oliObj.No_of_Case__c = skuWrapObj.numberOfCases;
                oliObj.Quantity__c = skuWrapObj.qty;
                oliObj.Price__c = skuWrapObj.priceEntered;
                insert oliObj;
                skuWrapObj.oliId = oliObj.Id;
                
                netAmount += skuWrapObj2.priceEntered;
                skuOrderMap.put(skuWrapObj2.skuId,skuWrapObj);
                //skuOrderList.addAll(skuOrderMap.values());
                skuOrderList.add(skuWrapObj);
                errorMessage = skuWrapObj2.brandName+' added to Cart';
                showError = true;
            }
            
            System.debug('skuOrderList: '+skuOrderList);
            calculateTax();
            
            //refreshOrderValue();
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
            
            netAmount = 0;
            OrderLineItem__c oliObj = new OrderLineItem__c();
            for(SKUOrder skuObj:skuOrderList){
                if(String.isNotBlank(skuObj.oliId)){
                    oliObj.Id = skuObj.oliId;
                }
                oliObj.Invoice_Discount__c = skuObj.invoiceDiscountEntered;
                oliObj.Special_Discount__c = skuObj.specialDiscountEntered;
                oliObj.No_of_Case__c = skuObj.numberOfCases;
                oliObj.Quantity__c = skuObj.qty;
                oliObj.Price__c = skuObj.priceEntered;
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
            skuOrderList = new List<SKUOrder>();
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
    
    //Method to handle & monitor Exceptions
    public void exceptionHandler(){
        if(exObj!=null){
            Monitor_Log__c monObj = new Monitor_Log__c();
            monObj.Name = 'Exception';
            monObj.Line_Number__c = exObj.getLineNumber();
            monObj.Message__c = exObj.getMessage();
            monObj.Cause__c = String.valueOf(exObj.getCause());
            monObj.Stack_Trace__c = exObj.getStackTraceString();
            monObj.Module__c = 'Catalog Controller';
            monObj.Method__c = methodName;
            monObj.Distributor__c = accountId;
            monObj.User__c = UserInfo.getUserId();
            insert monObj;
            
            //PageMessages.addMessage(new PageMessages.PageMessage(PageMessages.Severity.INFO, monObj.Line_Number__c+' - '+monObj.Method__c+' : '+monObj.Message__c));
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, monObj.Line_Number__c+' - '+monObj.Method__c+' : '+monObj.Message__c));
        }
    }
    /* 
    *  prepareBackground()
    *  Additional constructor helper method grabbing the appropriate background image. 
    */
    public void prepareBackground() {
        String servlet = '/servlet/servlet.FileDownload?file=';
        String backgroundName = 'Catalog_BG';
        Document backgroundDoc = [SELECT Id FROM Document WHERE Name = :backgroundName];
        backgroundURL = servlet + backgroundDoc.Id;
    }
    
    /*
    *  prepareCatalog()
    *  This method contains all initialization for the catalog, and notably aids in 
    *  navigation with the FamilyMap (used in the category nav on the first page). 
    */
        /*public pageReference prepareCatalog() {
    try{if(Test.isRunningTest() && throwEx==true){Integer x=1/0;}
    if(!Product2.sObjectType.getDescribe().isAccessible()) {
    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'Insufficient access'));
    return null;
    }
    // Initialize maps, run queries
    productMap = new Map<String, List<Product2>>();
    familyMap = new Map<String, String>();
    numberOfFamilies = 0;
    
    // Prepare the picklist values from Family field on Product2
    Schema.DescribeFieldResult familyResult = Product2.Family.getDescribe();
    List<Schema.PicklistEntry> familyPLE = familyResult.getPicklistValues();
    system.debug('Product Family Name :'+familyPLE);
    // For each Family picklist value, clean the value and continue
    
    
    
    for( Schema.PicklistEntry f : familyPLE ) {
    String familyLabel = f.getLabel().trim();
    String familyValue = f.getValue().trim();
    String familyNoWhtSpc = familyValue.replaceAll('\\s+','');
    // Now that we have a clean Family, get all Products with that Family
    // Then add it to the map for Family -> ProductList
    Integer countProductsInFamily = 0;
    try {
    countProductsInFamily = 0;
    countProductsInFamily = [SELECT count() FROM Product2 WHERE Family = :familyValue AND Mobile_Ready__c = true];
    if(countProductsInFamily > 0) {
    productsInFamily = [SELECT Id,Name,Description,Family,ProductCode,Blurb__c,Default_Price__c,VF_Image__c,Inventory__c,Mobile_Ready__c FROM Product2 WHERE Mobile_Ready__c = true AND Family = :familyValue ORDER BY Name DESC NULLS FIRST];
    familyMap.put(familyNoWhtSpc, familyLabel);
    System.debug(' IF Condition productsInFamily  size :'+productsInFamily.size());
    
    productMap.put(familyNoWhtSpc, productsInFamily);
    numberOfFamilies += 1;
    }
    
    
    } catch (exception e) {System.debug('Error : ---------------- ' + e.getMessage());}
    }
    
    System.debug('productsInFamily  size :'+productsInFamily.size());
    //Prep the host URL for use in Catalog images
    hostURL  = 'https://' + ApexPages.currentPage().getHeaders().get('Host');
    }
    catch(Exception ex){
    System.debug('Exc: '+ex.getLineNumber()+' '+ex.getMessage());
    }
    return null;
    }*/
    
    /* 
    *  prepareCart()
    *  Additional constructor helper method for initializing Cart variables. 
    */
        /*public pageReference prepareCart() {
    if(!Catalog_Order__c.sObjectType.getDescribe().isCreateable()) {
    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'Insufficient access'));
    return null;
    }
    productSet = new Set<String>();
    myOrder = new Catalog_Order__c();
    myLineItems = new List<Catalog_Line_item__c>();
    
    // This query tries to eliminate the constant creation of more and more Orders
    // It grabs the last catalog modified by the current user with the status of Cart
    Catalog_Order__c[] orderQuery = [SELECT Items__c,Total_Cost__c,Account__c,Id,(SELECT Id,Product__c,Product_Short_Description__c,Product_Price__c,Product_Name__c,Quantity__c,VF_Image__c FROM Catalog_Line_Items__r) FROM Catalog_Order__c WHERE Status__c = 'Cart' AND CreatedById =:UserInfo.getUserId() ORDER BY LastModifiedDate DESC NULLS FIRST LIMIT 1];
    if( orderQuery.size() > 0 ) {
    myOrder = orderQuery[0];
    
    List<Catalog_Line_Item__c> cliList =  myOrder.getSObjects('Catalog_Line_Items__r'); //Get all Line Items for Order
    if (cliList == null || cliList.size() < 1) {
    // No Line Items in related list so do nothing
    } else {
    // Line Items returned, so add them to product set
    for(Catalog_Line_Item__c cli : cliList) {
    productSet.add( cli.Product__c );
    }
    }
    }
    
    
    return null;
    }*/
    
    /* 
    *  prepareCatalogTemplate()
    *  Additional constructor helper method for initializing Catalog Template variables. 
    */
        /*public pageReference prepareCatalogTemplate() {
    if(!Catalog_Template__c.sObjectType.getDescribe().isCreateable()) {
    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'Insufficient access'));
    return null;
    }
    myCatalogTemplate = new Catalog_Template__c();
    
    // This query tries to eliminate the constant creation of more and more Templates
    // It grabs the Template with the name we set in the Brander Controller
    Catalog_Template__c[] templateQuery = [SELECT Category_Text_Color__c,Header_Left_Text_Color__c,Header_Right_Text_Color__c,Id,Name,Subtitle_Text_Color__c,Subtitle_Text_Size__c,Subtitle_Text__c,Title_Text_Color__c,Title_Text_Size__c,Title_Text__c FROM Catalog_Template__c WHERE Name = 'Catalog Template 1'];
    if( templateQuery.size() > 0 ) {
    myCatalogTemplate = templateQuery[0];
    }
    return null;
    }*/
    
    /* 
    *  addToCart()
    *  Handles the complexity of adding a product as a line item to the Order from Actionfunction
    */
    /*public pageReference addToCart() {
    if(!Catalog_Order__c.sObjectType.getDescribe().isUpdateable() || !Catalog_Line_Item__c.sObjectType.getDescribe().isCreateable()) {
    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'Insufficient access'));
    return null;
    }
    if( productId == null ) {} else {
    // First make sure that our Order is in the database
    upsert myOrder;
    orderId = myOrder.Id;
    
    // Check if the product is already in the Cart
    if( productSet.contains( productId ) ) { } else {
    // Here is where we add the ID to the set...
    productSet.add( productId );
    // ...and to the Order.
    Catalog_Line_Item__c li =  new Catalog_Line_item__c();
    li.Product__c = '01tN0000002gh5S';//productId;
    li.Catalog_Order__c = myOrder.Id;
    li.Quantity__c = 1;
    insert li;
    // Added to Cart
    }}
    // Clear the parameter and reupsert
    productId = null;
    upsert myOrder;
    return null;
    }*/
    
    /* 
    *  deleteFromCart()
    *  Handles the complexity of deleting a product as a line item from the Order
    */
    /*public PageReference deleteFromCart() {
    if(!Catalog_Order__c.sObjectType.getDescribe().isUpdateable() || !Catalog_Line_Item__c.sObjectType.getDescribe().isDeletable()) {
    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'Insufficient access'));
    return null;
    }
    if( productId == null ) {system.debug('Empty delete.'); return null;} 
    else {
    Catalog_Line_Item__c li = [SELECT Id FROM Catalog_Line_Item__c WHERE Id =: productId];
    try {
    // About to delete Line Item
    if(!Catalog_Order__c.sObjectType.getDescribe().isDeletable()){
    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'Insufficient access'));
    return null;
    }
    delete li;
    } catch (DmlException e) {System.debug(e.getMessage());}
    
    // Check if the product is already in the Cart
    if( productSet.contains( productId ) ) { 
    // Here is where we remove the ID from the set...
    productSet.remove( productId );
    }
    }
    // Clear the parameter and reupsert
    productId = null;
    upsert myOrder;
    
    return null;
    }*/
    
    /* 
    *  updateQuantity(String ID) 
    *  Updates the Quantity field of the Catalog Line Item with the given Id 
    */
    /*public PageReference updateQuantity() {
    if(!Catalog_Line_Item__c.sObjectType.getDescribe().isUpdateable()) {
    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'Insufficient access'));
    return null;
    }
    Catalog_Line_Item__c li = [SELECT Quantity__c FROM Catalog_Line_Item__c WHERE Id =: productId];
    li.Quantity__c = productQuantity;
    update li;
    update myOrder;
    // Stay on current page
    return null;
    }*/
        
        /* 
    *  updateAccount(String ID) 
    *  Updates the Account field of the Order with the given Id 
    */
        /*public PageReference updateAccount() {
    if(!Catalog_Order__c.sObjectType.getDescribe().isUpdateable()) {
    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'Insufficient access'));
    return null;
    }
    myOrder.Account__c = accountId;
    update myOrder;
    // Stay on current page
    return null;
    }*/
    
    /* 
    *  getProduct(String ID) 
    *  queries and returns relevant product info from a string ID 
    */
        /*public Product2 getProduct(String stringID) {
    if(!Product2.sObjectType.getDescribe().isAccessible()) {
    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'Insufficient access'));
    return null;
    }
    Product2 product = [SELECT Id,Name,Description,Family,ProductCode,Blurb__c,Default_Price__c,VF_Image__c,Inventory__c,Mobile_Ready__c FROM Product2 WHERE Id =: stringID LIMIT 1];
    return product;
    }*/
    
    /* 
    *  clearOrder() 
    *  clears all line items on the order and navigates to the catalog page 
    */
    public PageReference clearOrder() {
        //if(!Catalog_Line_Item__c.sObjectType.getDescribe().isDeletable()) {
        //    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'Insufficient access'));
        //    return null;
        //}
        
        // Remove all line items from the order
        delete[Select id from OrderLineItem__c where order__c =: orderId];
        skuOrderMap.clear();
        skuOrderList.clear();
        //List<Catalog_Line_Item__c> toDelete = [SELECT Id,Product__c,Product_Short_Description__c,Product_Price__c,Product_Name__c,Price__c,Quantity__c,Subtotal__c,VF_Image__c FROM Catalog_Line_Item__c WHERE Catalog_Order__c =: myOrder.Id];
        //delete toDelete;
        
        // Stay on current page
        return null;
    }
    
    /* 
    *  completeOrder() 
    *  Completes the current order and prepares a new one for the user
    */
    /*public PageReference completeOrder() {
    if(!Catalog_Order__c.sObjectType.getDescribe().isCreateable() || !Catalog_Order__c.sObjectType.getDescribe().isDeletable()) {
    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'Insufficient access'));
    return null;
    }
    //Preparing to complete myOrder
    // Set status of current order
    myOrder.Status__c = 'Submitted';
    update myOrder;
    // myOrder was submitted
    
    // create new order and set it to myOrder
    // This allows us to continue operations when the user returns to the Catalog
    productSet = new Set<String>();
    myOrder = new Catalog_Order__c();
    myOrder.Status__c = 'Cart';
    // myOrder reinitiated and set to Cart
    myLineItems = new List<Catalog_Line_item__c>();
    
    // Stay on current page
    return null;
    }*/
    
    /* 
    *  toCart() 
    *  navigates to the cart page 
    */
    public PageReference toCart() {
        /*if(!Catalog_Order__c.sObjectType.getDescribe().isAccessible()) {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'Insufficient access'));
        return null;
        }
        try{if(Test.isRunningTest() && throwEx==true){Integer x=1/0;}
        //myOrder = [SELECT Items__c,Lines__c,Total_Cost__c,Account__c,Id,(SELECT Id,Product__c,Product_Short_Description__c,Product_Price__c,Product_Name__c,Price__c,Quantity__c,Subtotal__c,VF_Image__c FROM Catalog_Line_Items__r) FROM Catalog_Order__c WHERE Id =: orderId LIMIT 1];
        } catch (exception e) {System.debug(e.getMessage());}
        */
        PageReference next = new PageReference('/apex/catalog_cart');
        next.setRedirect(false);
        // Directing to Cart
        return next;
    }
    
    /*
    *  toCatalog() 
    *  navigates to the catalog page 
    */
    public PageReference toCatalog() {
        /*if(!Product2.sObjectType.getDescribe().isAccessible()) {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'Insufficient access'));
        return null;
        }*/
        PageReference next = new PageReference('/apex/catalog_products');
        next.setRedirect(false);
        // Directing to Catalog
        return next;
    }
    /*
    *  toHome() 
    *  navigates to the Home page 
    */
    public PageReference toHome() {
        PageReference next = new PageReference('/apex/cataloghome');
        next.setRedirect(true);
        // Directing to Home
        return next;
    }
    /* 
    *  toCreditInfo() 
    *  navigates to the CreditInfo page 
    */
    public PageReference toCreditInfo() {
        
        PageReference next = new PageReference('/apex/creditinfo');
        next.setRedirect(false);
        // Directing to CreditInfo
        return next;
    }
    
    /* 
    *  toCreditInfo() 
    *  navigates to the CreditInfo page 
    */
    public PageReference toSearchPage() {
        
        PageReference next = new PageReference('/apex/SearchPage');
        next.setRedirect(false);
        // Directing to CreditInfo
        return next;
    }
    
    /* 
    *  toCreditInfo() 
    *  navigates to the CreditInfo page 
    */
    public PageReference toOrderHistory() {
        
        PageReference next = new PageReference('/apex/orderhistorymob');
        //next.setRedirect(false);
        // Directing to CreditInfo
        return next;
    }    
    
    /* 
    *  toCreditInfo() 
    *  navigates to the CreditInfo page 
    */
    public PageReference toAccountLedger() {
        
        PageReference next = new PageReference('/apex/accountledgermob');
        //next.setRedirect(false);
        // Directing to CreditInfo
        return next;
    }    
    /*
    *  escapeReservedCharacters(String) 
    *  Cleans up the dishonorable...
    */
    /*private String escapeReservedCharacters(String s) {
    String reservedCharacters = '—&|!{}[]()^~:\\\"\'+-';
    for (Integer i = 0; i < reservedCharacters.length(); i++)
    s = s.replace(reservedCharacters.substring(i,i+1), '\\' + reservedCharacters.substring(i,i+1));
    return s;
    }
    
    public void TestFunction(){
    System.assert(1 == 1,'WTF');
    }*/
    
    //Method to Save the Order as Draft
    public void saveOrder(){
        try{if(Test.isRunningTest() && throwEx==true){Integer x=1/0;}
            showError = false;
            if(allowAddress == True){
                if(String.isNotBlank(newAddress)){
                    //saveTemplate();
                }
                else{
                    //allowTemplate == false;
                    showError = true;
                    errorMessage = 'Please Enter Correct Address';
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
            
            saveOrder();
            
            if(orderSaved == true){
                showError = false;
                addSOLineItem();
                
                Decimal totalAmount = 0;
                if(soObj!=null){
                    totalAmount = soObj.Total_Amount__c;
                }
                /*if(totalAmount > distWrapObj.creditBalance && showError==false){
                showError = true;
                errorMessage = 'Order Value has exceeded Credit Balance. Please review your order.';
                if(soObj!=null){
                //if(String.isNotBlank(soObj.id))
                delete soObj;
                }
                if(soObj2!=null){
                //if(String.isNotBlank(soObj2.id))
                delete soObj2;
                }
                }
                
                else*/
                if(orderSaved == True && showError==false){
                    ordObj.Order_Status__c = 'Approved';
                    upsert ordObj;
                    showError = true;
                    errorMessage = 'Order Confirmed';
                    enableInput = false;
                    
                    if(soObj!=null){
                        Credit_Info__c ciObj = [Select Id, Allocated_Limit__c FROM Credit_Info__c WHERE Distributor__c=:accountId];
                        ciObj.Allocated_Limit__c = totalAmount + ciObj.Allocated_Limit__c;
                        update ciObj;
                        
                        //update updateInvList;
                        distWrapObj.creditBalance = distWrapObj.creditBalance - totalAmount;
                        //fetchDistributorDetails();
                    }
                    /*List<Sales_Order_Line_Item__c> solList = [Select Id FROM Sales_Order_Line_Item__c WHERE Sale_Order__c=:soObj.Id];
                    if(solList.isEmpty()){
                    delete soObj;
                    }
                    List<Sales_Order_Line_Item__c> solList2 = [Select Id FROM Sales_Order_Line_Item__c WHERE Sale_Order__c=:soObj2.Id];
                    if(solList2.isEmpty()){
                    delete soObj2;
                    }*/
                }
                
            }
            else if(orderSaved != True && showError==false){
                System.debug('ordObj.Order_Status__c: '+ordObj.Order_Status__c);
                showError = true;
                errorMessage = 'Please Save Order before Confirming';
                if(soObj!=null){
                    if(String.isNotBlank(soObj.id))
                        delete soObj;
                }
                if(soObj2!=null){
                    if(String.isNotBlank(soObj2.id))
                        delete soObj2;
                }
            }
           }
        catch(Exception ex){
            methodName = 'confirmOrder'; 
            exObj = ex;
            exceptionHandler();
            System.debug('Exception: '+ex.getMessage()+ ' Line Number: '+ex.getLineNumber());
        }            
    }
    
    //Method to Create 2 SalesOrders on Order Confirmation
    public void createSalesOrder(){
        System.debug(ordObj);
        System.debug(soObj);
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
            
             //patch work done by abhishek Here
           
             String orderTypeCode;
           //paymentType= SelectedPaymentType;
           Account acc =[select id,Sales_Org_Code__c from Account where id=:accountId][0];
           System.debug('----paymentType logic -----'+paymentType);
           if(acc.Sales_Org_Code__c =='1000'){//india
               //orderTypeCode='ZORD'
               if(paymentType=='Cash'){
                   orderTypeCode = 'ZOCO';
               }else{
                   orderTypeCode='ZORD';
               }
           }
           if(acc.Sales_Org_Code__c =='6410'){ //indonesia
                   orderTypeCode='ZOR1';
           }//End of patch
           System.debug('----orderTypeCode -----'+orderTypeCode);

            soObj.Order_Type_lk__c = [Select Id FROM Order_Type__c WHERE Order_Type_Code__c=:orderTypeCode].Id;//distWrapObj.orderType; 
            insert soObj;
            
            //soObj2 = soObj.clone(false);
            //insert soObj2;
        }
    }
    
    public void createSalesOrder2(){
        System.debug(ordObj);
        System.debug(soObj2);
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
             //patch work done by abhishek Here
           
             String orderTypeCode;
           //paymentType= SelectedPaymentType;
           Account acc =[select id,Sales_Org_Code__c from Account where id=:accountId][0];
           System.debug('----paymentType logic -----'+paymentType);
           if(acc.Sales_Org_Code__c =='1000'){//india
               //orderTypeCode='ZORD'
               if(paymentType=='Cash'){
                   orderTypeCode = 'ZOCO';
               }else{
                   orderTypeCode='ZORD';
               }
           }
           if(acc.Sales_Org_Code__c =='6410'){ //indonesia
                   orderTypeCode='ZOR1';
           }//End of patch

           System.debug('----orderTypeCode -----'+orderTypeCode);
            //End of patch

            soObj2.Order_Type_lk__c = [Select Id FROM Order_Type__c WHERE Order_Type_Code__c=:orderTypeCode].Id;//distWrapObj.orderType; 
            insert soObj2;
            
            //soObj2 = soObj.clone(false);
            //insert soObj2;
        }
    }
    
    //Method to add Line Items to SalesOrders on Order Confirmation
    public void addSOLineItem(){
        try{if(Test.isRunningTest() && throwEx==true){Integer x=1/0;}
            //createSalesOrder();
            
            //if(soObj!=null){
            //soObj = [SELECT Id, name FROM Sales_Order__c WHERE Id=:soObj.id];
            //soObj2 = [SELECT Id, name FROM Sales_Order__c WHERE Id=:soObj2.id];
            
            updateInvList = new List<Inventory__c>();
            
            Sales_Order_Line_Item__c sliObj;
            Sales_Order_Line_Item__c sliObj2;
            Inventory__c invObj; //= new Inventory();
            
            for(SKUOrder skuWrapObj:skuOrderMap.values()){
                sliObj = new Sales_Order_Line_Item__c();
                sliObj.SKU_Name__c = skuWrapObj.skuId;
                sliObj.Item_Number__c = skuWrapObj.itemNo;
                sliObj.Item_Status__c = 'Active';
                sliObj.No_of_Case__c = skuWrapObj.numberOfCases;
                sliObj.DepotDepot__c = depoId;
                //sliObj.Order_Item_Key__c = soObj.Name+'-'+itemNumber;
                sliObj.UOM__c = skuWrapObj.UOM;
                if(skuWrapObj.qty==0){
                    showError = true;
                    //errorMessage = 'Please Enter No. of Cases for '+ skuWrapObj.brandName +' before confirming order'; 
                    errorMessage = 'Please Enter No. of Cases for all SKU\'s before confirming order'; 
                    //delete soObj;
                    //delete soObj2;
                    break;
                }
                else if(skuWrapObj.available == 0){
                    createSalesOrder2();
                    System.debug('skuWrapObj.available == 0: '+skuWrapObj.available);
                    sliObj2 = sliObj.clone(false);
                    sliObj2.Quantity__c = skuWrapObj.qty;
                    sliObj2.Invoice_Discount__c = skuWrapObj.invoiceDiscount * skuWrapObj.qty;
                    sliObj2.Special_Discount__c = skuWrapObj.specialDiscount * skuWrapObj.qty;
                    sliObj2.Price__c = (skuWrapObj.price*sliObj2.Quantity__c) - sliObj2.Invoice_Discount__c - sliObj2.Special_Discount__c;
                    sliObj2.Sale_Order__c = soObj2.Id;
                    insert sliObj2;
                }
                //If Order Qty <= Available Stock Create Single Sales Order
                else if(skuWrapObj.qty <= skuWrapObj.available){
                    createSalesOrder();
                    System.debug('skuWrapObj.qty <= skuWrapObj.available: '+skuWrapObj.qty);
                    System.debug('skuWrapObj.qty <= skuWrapObj.available: '+skuWrapObj.available);
                    sliObj.Quantity__c = skuWrapObj.qty;
                    
                    //Logic to update Allocated Quantity
                    invObj = new Inventory__c();
                    invObj.Id = skuWrapObj.inventoryId;
                    invObj.Allocated_Quantity__c = skuWrapObj.available - skuWrapObj.qty;
                    updateInvList.add(invObj);
                    //End of Logic 
                    sliObj.Quantity__c = skuWrapObj.qty;
                    sliObj.Invoice_Discount__c = skuWrapObj.invoiceDiscount * skuWrapObj.qty;
                    sliObj.Special_Discount__c = skuWrapObj.specialDiscount * skuWrapObj.qty;
                    sliObj.Price__c = (skuWrapObj.price*sliObj.Quantity__c) - sliObj.Invoice_Discount__c - sliObj.Special_Discount__c;
                    sliObj.Sale_Order__c = soObj.Id;
                    insert sliObj;
                }
                //If Order Qty > Available Split Sales Order
                else if(skuWrapObj.qty > skuWrapObj.available){
                    createSalesOrder();
                    createSalesOrder2();
                    System.debug('skuWrapObj.qty > skuWrapObj.available: '+skuWrapObj.qty);
                    System.debug('skuWrapObj.qty > skuWrapObj.available: '+skuWrapObj.available);
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
                    
                    sliObj2.Invoice_Discount__c = skuWrapObj.invoiceDiscount * sliObj2.Quantity__c;
                    sliObj2.Special_Discount__c = skuWrapObj.specialDiscount * sliObj2.Quantity__c;
                    sliObj2.No_of_Case__c = sliObj2.Quantity__c/skuWrapObj.packSize;
                    sliObj2.Price__c = (skuWrapObj.price*sliObj2.Quantity__c) - sliObj2.Invoice_Discount__c - sliObj2.Special_Discount__c;                  
                    insert sliObj2; 
                    
                    sliObj.Quantity__c = skuWrapObj.available; 
                    sliObj.Invoice_Discount__c = skuWrapObj.invoiceDiscount * sliObj.Quantity__c;
                    sliObj.Special_Discount__c = skuWrapObj.specialDiscount * sliObj.Quantity__c;
                    sliObj.No_of_Case__c = skuWrapObj.available/skuWrapObj.packSize;
                    sliObj.Price__c = (skuWrapObj.price*sliObj.Quantity__c) - sliObj.Invoice_Discount__c - sliObj.Special_Discount__c;
                    sliObj.Sale_Order__c = soObj.Id;
                    insert sliObj;
                }
            }
            /*List<Sales_Order_Line_Item__c> solList = [Select Id FROM Sales_Order_Line_Item__c WHERE Sale_Order__c=:soObj.Id];
if(solList.isEmpty()){
delete soObj;
}*/
            //else{
            //Update Tax and Total Amount in Sales Order 1
            if(soObj!=null){
                soObj = [Select Id, Net_Amount__c from Sales_Order__c where id=:soObj.id];
                //System.debug('soObj: '+soObj);
                soObj.Tax_Amount__c = (stsList[0].Tax__c/100) * soObj.Net_Amount__c;
                soObj.Additional_Tax__c = (stsList[0].AdditionalTax__c/100) * soObj.Net_Amount__c;
                soObj.Total_Amount__c = soObj.Net_Amount__c + soObj.Tax_Amount__c + soObj.Additional_Tax__c;
                upsert soObj;
                System.debug('After upsert soObj: '+soObj);
            }
            //}
            //If single sales order is created, delete second sales order
            //List<Sales_Order_Line_Item__c> solList2 = [Select Id FROM Sales_Order_Line_Item__c WHERE Sale_Order__c=:soObj2.Id];
            //System.debug('solList2: '+solList2);
            //if(solList2.isEmpty()){
            //    delete soObj2;
            //}
            //else{
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
            //}
            //}
           }
        catch(Exception ex){
            methodName = 'addSOLineItem';
            exObj = ex;
            exceptionHandler();
            System.debug('Exception: '+ex.getMessage()+ ' Line Number: '+ex.getLineNumber());
        }
    }
    
    public class DistributorWrapper{
        public String distributorName {get;set;}
        public String profileURI {get;set;}
        public String salesOrgId {get;set;}
        public String distributorChannelId {get;set;}
        public String divisionId {get;set;}
        public String orderType {get;set;}
        public String sapCode {get;set;}
        public String depot {get;set;}
        public Decimal creditLimit {get;set;}
        public Decimal creditUsed {get;set;}
        public Decimal creditBalance {get;set;}
        public Decimal paymentOutstanding {get;set;}
        public Decimal daysArrears {get;set;}
        public String address {get;set;}
        public String city {get;set;}
        public String state {get;set;}
        public String country {get;set;}
        public String pincode {get;set;}
        public String currencyIso {get;set;}
        public String territoryManager {get;set;}
        public String territoryPhone {get;set;}
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
        public String packUOM {get;set;}
        public Decimal invoiceDiscount {get;set;}
        public Decimal specialDiscount {get;set;}
        public Decimal invoiceDiscountEntered {get;set;}
        public Decimal specialDiscountEntered {get;set;}
        public Decimal netRateEntered {get;set;}
        public Decimal priceEntered {get;set;}
        public Integer numberOfCases {get;set;}
        //public Integer qty {get;set;} added by abhishek 
        public Decimal qty {get;set;} 
        public Decimal price {get;set;}
        public Integer perUnit {get;set;}
       // public Integer available {get;set;}added by abhishek
        public Decimal available {get;set;}
        public String available2 {get;set;}
        public String currencyIso {get;set;}
        public String image2 {get;set;}
        public SKUDetails(){
            qty = 0;
            numberOfCases = 1;
            invoiceDiscountEntered = 0;
            specialDiscountEntered = 0;
            priceEntered = 0;
            invoiceDiscount = 0;
            specialDiscount = 0;
            price = 0;
            netRateEntered = 0;
            available = 0;
            available2 = 'Out of Stock';
            popular = false;
            //image = '/servlet/servlet.FileDownload?file=015N0000000R8hc';
        }
    }
    
    public class SKUOrder{
        public String brandName {get;set;}
        public Id distributorId {get;set;}
        public String productName {get;set;}
        public String productId {get;set;}
        public String oliId {get;set;}
        public String skuCode {get;set;}
        public Id skuId {get;set;}
        public Id InventoryId {get;set;}
        public Decimal packSize {get;set;}
        public String packUOM {get;set;}
        public String depotLocation {get;set;}
        public Id depotId {get;set;}      
        public String priceGroupCode {get;set;}
        public Id priceGroupId {get;set;}        
        public String UOM {get;set;}
        public Decimal invoiceDiscount {get;set;}
        public Decimal specialDiscount {get;set;}
        public Decimal invoiceDiscountEntered {get;set;}
        public Decimal specialDiscountEntered {get;set;}
        public Decimal priceEntered {get;set;}
        public Decimal netRateEntered {get;set;}
        public Integer numberOfCases {get;set;}
        //public Integer qty {get;set;}
        public Decimal qty {get;set;}
        
        public Decimal price {get;set;}
        public Integer itemNo {get;set;}
        public Integer perUnit {get;set;}
        
       // public Integer available {get;set;} added by abhishek
       public Decimal available {get;set;} 
        public String available2 {get;set;}
        public String currencyIso {get;set;}
        public String image2 {get;set;}
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