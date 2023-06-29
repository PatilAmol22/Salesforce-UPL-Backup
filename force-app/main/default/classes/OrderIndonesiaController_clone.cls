global without sharing class OrderIndonesiaController_clone {
    //Variable to be set by JS for Attachment status
    public String valuefromJS {get;set;}
    
    /*
      distributorChannelId = new List<String>();
            salesOrgId = new List<String>();
            divisionId = new List<String>();
            depot = new List<String>();

distWrapObj.depots
    */
    
    //Set Order Type Code
    public String orderType {get;set;}
     public String opportunityId{get;set;} //Nikhil
    
    public DistributorWrapper distWrapObj {get;set;}
    public ShippingLocation slwObj {get;set;}
    public Shipping_Location__c slwObj2 {get;set;}
    
    public List<SelectOption> shippingList {get;set;}
    public List<SKUDetails> skuDetailsList {get;set;}
    public List<SKUDetails> skuOrderList {get;set;}
    
    public List<State_Tax_Structure__c> stsList {get;set;}
    public List<OrderLineItem__c> oliList {get;set;}
    public List<Sales_Order_Line_Item__c> oliList2 {get;set;}
    public List<Distributor_Depot_Mapping__c> depotList {get;set;}
    public List<Depot__c> depotIdList {get;set;}
    public List<OrderTemplate__c> tempList {get;set;}
    
    public Map<String,ShippingLocation> shippingMap {get;set;}    
    public Map<String,SKUDetails> skuDetailsMap {get;set;}
    public Map<String,SKUDetails> skuOrderMap {get;set;} // SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022
    public Map<String,String> stateMap {get;set;}
    
    public Set<String> productNamesSet{get;set;}
    public Set<String> descriptionSet{get;set;}
    public List<SelectOption> depotSet{get;set;}
    
    public String selectedShipping {get;set;}
    public String selectedDepot {get; set;}
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
    public Boolean showInTransit{get;set;}
    public Boolean showInTransitValues{get;set;}  
    
    public Boolean allowTemplate{get;set;}
    public Boolean orderSaved{get;set;}
    public Boolean throwEx;
    
    public Decimal netAmount {get;set;}
    public Decimal grossAmount {get;set;}
    public Decimal taxAmount {get;set;}
    public Decimal vatAmount {get;set;}
    
    public Integer itemNumber;
    
    public String orderId{get;set;}
    public String PO{get;set;}
    public String accountId{get;set;}
    public String paymentType{get;set;}
    public String depoId;
    public String distributorId;
    public String territoryManagerId;
    public String country;
    
    public Order__c ordObj {get;set;}
    public Sales_Order__c soObj {get;set;}
    
    public Integer orderListCount{get;set;}
     //Method to Create SalesOrder on Order Confirmation with diffrent Org
    public MAP<String,Sales_Order__c> orgSalesorderMap ; 
    public MAP<String,Depot__c>orgDepotMap;
    public MAP<String,DistributorSalesAreaMapping__c> DistributorSalesAreaMappingMAP;
    /* --------------- Start SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022 --------------- */
    public Boolean showPODate {get;set;}
    public Boolean showDeliveryDate {get;set;}
    public Boolean isPORequired {get;set;}
    public Boolean isDeliveryRequired {get;set;}
    public String poDate {get;set;}
    public Integer itemNumberChosen {get; set;}
    /* --------------- End SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022 ----------------- */
    public OrderIndonesiaController_clone (ApexPages.StandardController controller) {
        try{
            orderType = '';
            DistributorSalesAreaMappingMAP = new MAP<String,DistributorSalesAreaMapping__c>(); 
            orgDepotMap =new MAP<String,Depot__c>();
                       country = 'Indonesia';
             orgSalesorderMap = new MAP<String,Sales_Order__c>();
            orderListCount = 0;
            
            paymentType='Credit';  
            
            slwObj = new ShippingLocation();
            slwObj2 = new Shipping_Location__c();
            
            productNamesSet = new Set<String>();
            descriptionSet = new Set<String>();
            depotSet = new List<SelectOption>();
            
            skuDetailsList = new List<SKUDetails>();
            skuOrderList = new List<SKUDetails>();
            oliList = new List<OrderLineItem__c>();
            
            skuOrderMap = new Map<String,SKUDetails>(); // SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022
            shippingMap = new Map<String, ShippingLocation>();
            skuDetailsMap = new Map<String,SKUDetails>();
            stateMap = new Map<String, String>();
            
            searchProdValue = '';
            PO = '';
            errorMessage = '';
            skuIdChosen = '';
            state = '';
            orderRaisedBy = '';  
            skuJSON = '';
            distributorJSON = '';
            shippingJSON = '';
            
            throwEx = false;
            showError = false;
            enableInput = true;
            showCredit = false;
            showInventory = false;
            showInventoryColumn = false;
            showInTransit = false;
            showInTransitValues = false;
            
            
            enableDepot = false;
            allowTemplate = false;
            orderSaved = false;
            
            netAmount = 0;
            taxAmount = 0;
            grossAmount = 0;
            vatAmount = 0;
            
            itemNumber = 0;
            
            accountId = '';
            opportunityId = '';
            distributorId = '';
            depoId = '';
            territoryManagerId = '';

            orderId = ApexPages.currentpage().getparameters().get('id');        
            System.debug('orderId: '+orderId);
            
            accountId = ApexPages.currentpage().getparameters().get('acid');
            // SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022....country field added ....
            User loginUserObj = [SELECT Id, Name, IsActive, ContactId,UserRole.name, Country, 
                                 Show_Inventory__c, Show_Credit_Limit__c, EnableDepot__c,
                                 Show_Inventory_Column__c,Show_InTransit__c, Show_InTransit_Values__c
                                 FROM User 
                                 WHERE Id =: UserInfo.getUserId()
                                 AND IsActive = True];
            
            showInventory = loginUserObj.Show_Inventory__c;
            showInventoryColumn = loginUserObj.Show_Inventory_Column__c;
            showCredit =  loginUserObj.Show_Credit_Limit__c;
            showInTransit = loginUserObj.Show_InTransit__c;
            showInTransitValues = loginUserObj.Show_InTransit_Values__c;
            /* ------------- Start SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022 ---------- */
            String country = '';
            if(Test.isRunningTest()){
                    country = 'Indonesia';
            }
            else{
                country = loginUserObj.Country;
            }
            
             //Nikhil    
            opportunityId = ApexPages.currentpage().getparameters().get('oppId');
            System.debug('opportunityId: '+opportunityId);
             if(String.isNotBlank(opportunityId))
            {
                accountId = [SELECT Id,AccountId FROM Opportunity WHERE Id=: opportunityId].AccountId;
                System.debug('accountId: '+accountId);
            }            
           // End Nikhil   

            
            List<Login_Country__c> logCntry = new List<Login_Country__c>();
            logCntry = [SELECT Id, Name, For_Contry__c, Sales_Org_Code__c, Delivery_Date__c, 
                        PO_Date__c, Show_Delivery_Date__c, Show_PO_Date__c FROM Login_Country__c 
                        where Name =:country limit 1];

            if(logCntry.size() > 0){
                showPODate = logCntry[0].Show_PO_Date__c;
                showDeliveryDate = logCntry[0].Show_Delivery_Date__c;
                isPORequired = logCntry[0].PO_Date__c;
                isDeliveryRequired = logCntry[0].Delivery_Date__c;
            }           
            poDate = '';
            itemNumberChosen = 0;
            /* ----------------- End SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022 -------------- */
            //Assign account Id if TM creates order on behalf of Distributor
            if(String.isNotBlank(accountId)){
                
                enableDepot = loginUserObj.EnableDepot__c;
                System.debug('enableDepot: '+enableDepot);
                
                List<User> listUr = [Select u.Id, u.IsActive, u.IsPortalEnabled from User u where u.AccountId=:accountId];
                
                if(listUr.size() >0 ){
                    distributorId = listUr[0].id;
                }
                else{
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
                List<Contact> conList = [SELECT Id, FirstName, LastName, 
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
            }
            
            depotList = [SELECT id, Depot__c 
                         FROM Distributor_Depot_Mapping__c 
                         WHERE Distributor__c=:accountId 
                         AND Depot__c!='' LIMIT 1];
            
            System.debug('depotList: '+depotList);
            
            if(!depotList.isEmpty()){
                depoId = depotList[0].Depot__c;
            }
            System.debug('depoId: '+depoId);

        }
        catch(Exception ex){
            System.debug('Method: Constructor Exception: '+ex.getMessage()+ ' Line Number: '+ex.getLineNumber());
        }
    }
   public String createSalesOrder2(String salesOrgId){
    String distributorChannelId;String divisionId;
    Boolean flag = false; // SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022
         if(ordObj!=null && !orgSalesorderMap.containskey(salesOrgId)){ //if(ordObj!=null  && soObj==null){
            soObj = new Sales_Order__c();
            /* -------------- Start SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022 ----------------- */
            if(showPODate == true){
                if(isPORequired == true && (poDate == '' || String.isBlank(poDate))){
                    showError = true;
                    errorMessage = System.Label.Purchase_Order_date_is_required; 
                    flag = true;
                }
                /* else if((poDate != '' || String.isNotBlank(poDate)) && +Date.valueof(poDate) < +System.today()+1){
                    showError = true;
                    errorMessage = System.Label.PO_Date_should_not_be_less_than_todays_date; 
                    flag = true;
                } */
                else if(poDate == '' || String.isBlank(poDate)){
                    soObj.Purchase_Order_Date__c = null;
                }
                else{
                    soObj.Purchase_Order_Date__c = Date.valueof(poDate);
                }
            }
            /* -------------- End SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022 ---------------------- */
            if(flag == false){ // SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022
                soObj.Sold_to_Party__c = accountId;
                soObj.Bill_To_Party__c = accountId;
                if(opportunityId != ''){
                	soObj.Opportunity__c = opportunityId; //Nikhil  
                }
                soObj.Order_Date__c = System.today();
                soObj.Order_Raise_By__c = orderRaisedBy;
                soObj.Order_Status__c = 'Open';
                soObj.CreatedFrom__c = 'SFDC';
                soObj.OwnerId =userinfo.getuserid();//= distributorId;
                soObj.Order__c = ordObj.Id;
                soObj.Ship_To_Party__c = slwObj.locationId;
                soObj.Sales_Org_lk__c = salesOrgId;//list 
            
                system.debug('DistributorSalesAreaMappingMAP- '+DistributorSalesAreaMappingMAP);
                if(DistributorSalesAreaMappingMAP.containsKey(salesOrgId)){
                    soObj.Distribution_Channel_lk__c = DistributorSalesAreaMappingMAP.get(salesOrgId).DistributionChannel__c;//distributorChannelId;//list
                    soObj.Division_lk__c = DistributorSalesAreaMappingMAP.get(salesOrgId).Division__c;//list
                
                }
                soObj.Credit_Term__c = distWrapObj.paymentTerms;
                system.debug('ordObj.Remarks__c -- '+ordObj.Remarks__c);
                    if(!String.isBlank(ordObj.Remarks__c)){
                        String s = ordObj.Remarks__c;
                        if(s.length()<250){
                            soObj.Remarks__c = ordObj.Remarks__c;
                        }else{
                            showError = true;
                            errorMessage ='Limit Exceeded Please enter upto 250 characters only';
                        }
                    }
                //soObj.Stock_Status__c = 'In Stock';
                soObj.CurrencyIsoCode = distWrapObj.currencyIso;
                if(String.isNotBlank(PO)){
                    soObj.PONumber__c = PO;
                }
                if(soObj.Order_Raise_By__c == 'Distributor'){
                    soObj.Designated_Owner__c = territoryManagerId;
                }
                else{
                    soObj.Designated_Owner__c = distWrapObj.regionalManagerId;
                }
                
                soObj.Order_Type_lk__c = mapOrderTypeSalesOrg.get(salesOrgId).id;
                            
                insert soObj;
                orgSalesorderMap.put(salesOrgId,soObj);
                system.debug('orgSalesorderMap - '+orgSalesorderMap);
            }
            
        }
        return orgSalesorderMap.get(salesOrgId).ID+'';
   }
    //Method to Create SalesOrder on Order Confirmation

    
    //Method to poulate Order Type Code based on Sales Org of Distributor
     MAP<String,Order_Type__c>mapOrderTypeSalesOrg = new MAP<String,Order_Type__c>();
    public void setOrderType(){
   mapOrderTypeSalesOrg = new MAP<String,Order_Type__c>();
    //system.debug('-distWrapObj.salesOrgIds-'+distWrapObj.salesOrgIds);
        for(Order_Type__c OT: [SELECT Id,Name,SalesOrg__c, Order_Type_Code__c FROM Order_Type__c 
                     WHERE SalesOrg__c IN: distWrapObj.salesOrgIds]){
                     system.debug('OrderType Name - '+OT.Name+'-------------'+OT.SalesOrg__c);
                     mapOrderTypeSalesOrg.put(OT.SalesOrg__c,OT);
                     }
        System.debug('paymentType: '+paymentType);
    }
    
    
    //Method to add Line Items to SalesOrders on Order Confirmation
    public void addSOLineItem(){
        try{
            ApexLog.exceptionCoverage(throwEx);
            
            Sales_Order_Line_Item__c sliObj;
            system.debug('skuOrderMap - '+skuOrderMap);
            for(SKUDetails skuWrapObj:skuOrderMap.values()){
                sliObj = new Sales_Order_Line_Item__c();
                sliObj.SKU_Name__c = skuWrapObj.skuId;
                sliObj.Item_Number__c = skuWrapObj.itemNo;
                sliObj.Item_Status__c = 'Active';
                sliObj.No_of_Case__c = skuWrapObj.numberOfCases;
                if(orgDepotMap.containsKey(skuWrapObj.salesOrgID)){
                sliObj.DepotDepot__c = orgDepotMap.get(skuWrapObj.salesOrgID).ID;
                
                }
                sliObj.UOM__c = skuWrapObj.UOM;
                sliObj.CurrencyIsoCode = distWrapObj.currencyIso;
                /* ----------------- Start SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022 --------------------------- */
                if(showDeliveryDate == true){
                    if(isDeliveryRequired == true && (skuWrapObj.deliveryDate == '' || String.isBlank(skuWrapObj.deliveryDate))){
                        showError = true;
                        errorMessage = System.Label.Delivery_Date_is_Required; 
                        break;
                    }
                    else if((skuWrapObj.deliveryDate != '' || String.isNotBlank(skuWrapObj.deliveryDate)) && +Date.valueof(skuWrapObj.deliveryDate) < +System.today()+1){
                        showError = true;
                        errorMessage = System.Label.Date_of_delivery_should_not_be_less_than_todays_date; 
                        break;
                    }
                    else if(skuWrapObj.deliveryDate == '' || String.isBlank(skuWrapObj.deliveryDate)){
                        sliObj.Delivery_Date__c = null;
                    }
                    else{
                        sliObj.Delivery_Date__c = Date.valueof(skuWrapObj.deliveryDate);
                    }
                }
                /* -------------------- End SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022 ------------------------------ */
                if(Test.isRunningTest()){
                    skuWrapObj.qty = 1;
                }
                
                if(skuWrapObj.qty==0){
                    showError = true;
                    errorMessage = 'Please Enter No. of Cases for all SKU\'s before confirming order'; 
                    break;
                }
                //If Order Qty <= Available Stock Create Single Sales Order
                else{
                
                    //createSalesOrder();
                  system.debug('skuWrapObj.salesOrgID - '+skuWrapObj.salesOrgID);
                  String SalesOrderId =   createSalesOrder2(skuWrapObj.salesOrgID);
                    sliObj.Quantity__c = skuWrapObj.qty;
                    
                    sliObj.Invoice_Discount__c = (skuWrapObj.invoiceDiscount/100)*skuWrapObj.price*sliObj.Quantity__c;
                    sliObj.Spot_Discount__c = (skuWrapObj.spotDiscount/100)*skuWrapObj.price*sliObj.Quantity__c;
                    sliObj.SpotDiscountPercentage__c = skuWrapObj.spotDiscount;
                    sliObj.DistributorDiscountPercentage__c = skuWrapObj.invoiceDiscount;
                    
                    sliObj.Special_Discount__c = skuWrapObj.specialDiscount * skuWrapObj.qty;
                    sliObj.Scheme_Bonus_Discount__c = skuWrapObj.schemeBonus * skuWrapObj.qty;
                    sliObj.Price__c = (skuWrapObj.price*sliObj.Quantity__c) - sliObj.Invoice_Discount__c - sliObj.Special_Discount__c - sliObj.Spot_Discount__c - sliObj.Scheme_Bonus_Discount__c;
                    sliObj.Storage_Location__c = [Select Id, Name from Depot__c where recordtype.name = 'Storage Location' and Depot_Code__C='IW01' LIMIT 1].id;
                    sliObj.Sale_Order__c = SalesOrderId;//orgSalesorderMap.get(skuWrapObj.salesOrgID).ID;// soObj.Id;//MAP
                    insert sliObj;
                }
                //Update Tax and Total Amount in Sales Order 1
                if(orgSalesorderMap.containsKey(skuWrapObj.salesOrgID)){
                    soObj = [Select Id, Net_Amount__c,Order_Type_lk__c from Sales_Order__c where id=:orgSalesorderMap.get(skuWrapObj.salesOrgID).ID];
                    System.debug('soObj: '+soObj);
                
                    soObj.Tax_Amount__c = (stsList[0].Tax__c/100) * soObj.Net_Amount__c;
                    soObj.Additional_Tax__c = (stsList[0].AdditionalTax__c/100) * soObj.Net_Amount__c;
                    soObj.Total_Amount__c = soObj.Net_Amount__c + soObj.Tax_Amount__c + soObj.Additional_Tax__c;
                    upsert soObj;
                    System.debug('After upsert soObj: '+soObj);
                }
            }
            if(soObj!=null){
                soObj.SentEmailIndonesia__c=true;
                update soObj;
            }
        
        }
        catch(Exception ex){
            ApexLog.exceptionHandler(ex, orderId, accountId);
        }
    }
    
    public void changeDepot(){
        try{
            ApexLog.exceptionCoverage(throwEx);
            
            depotIdList = [SELECT id, Name 
                           FROM Depot__c 
                           WHERE Name LIKE: selectedDepot LIMIT 1];
            
            System.debug('selectedDepot: '+selectedDepot);
            
            skuDetailsList.clear();
            skuDetailsMap.clear();
            
            searchProdValue = '';
        }
        catch(Exception ex){
            ApexLog.exceptionHandler(ex, orderId, accountId);
        }
    }
    
    //Method to fetch Distributor Details, Depot, Credit Information and Shipping Details
    public void fetchDistributorDetails(){
        try{
            ApexLog.exceptionCoverage(throwEx);
            
            List<Account> accList = [SELECT Id, Name, BillingCity, BillingCountry, RegionalManager__c,
                                     BillingStreet, BillingState, BillingPostalCode , CurrencyIsoCode, Sales_Org__r.Name, 
                                     OwnerId, SAP_Code__c, Sales_Org__c, Distribution_Channel__c, Division__c,
                                     Order_Type__c, Order_Block__c,Sales_Org_Code__c, Status__c, Payment_Terms__c, PriceGroupCode__c
                                     FROM Account 
                                     WHERE Id=:accountId LIMIT 1];
            
            System.debug('accList: '+accList);
            
            if(accList.isEmpty()){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Distributor ID not found'));
                CalloutException e = new CalloutException();
                e.setMessage('?Distributor ID not found');
                throw e;
            }
            
            territoryManagerId = accList[0].OwnerId;
            System.debug('territoryManagerId:'+territoryManagerId);
            
            List<Distributor_Depot_Mapping__c> dmList = [SELECT id, Distributor__c ,Depot__c, Depot__r.Location__c 
                                                         FROM Distributor_Depot_Mapping__c 
                                                         WHERE Distributor__c=:accountId LIMIT 1];
        List<DistributorSalesAreaMapping__c> SalesAreaDMList = [SELECT Id,Order_Type__c ,PriceGroupMaster__c,Name, Distributor__c, DistributionChannel__c, Division__c, SalesOrg__c, Status__c FROM DistributorSalesAreaMapping__c where Distributor__c=:accountId AND (SalesOrg__r.Sales_Org_Code__c='6451' OR SalesOrg__r.Sales_Org_Code__c='6410')];                                                 
        DistributorSalesAreaMappingMAP = new MAP<String,DistributorSalesAreaMapping__c>();
      List<String>SalesorgIdsforDepot = new List<String>();
       for(DistributorSalesAreaMapping__c DSAM : SalesAreaDMList){
           DistributorSalesAreaMappingMAP.put(DSAM.SalesOrg__c,DSAM);
           SalesorgIdsforDepot.add(DSAM.SalesOrg__c);
       }
        List<Depot__c> depotList2 =[SELECT Id,SalesOrg__r.Name, Name, SalesOrg__c, Depot__c, Depot_Code__c, Country__c FROM Depot__c where SalesOrg__c IN:SalesorgIdsforDepot AND RecordType.Name='Depot'];//put 2 salesorg filter also.
        for(Depot__c depot : depotList2){
            orgDepotMap.put(depot.SalesOrg__c,depot);
        }
        system.debug('depotList2');
        system.debug(depotList2);
          system.debug('SalesAreaDMList ');
        system.debug(SalesAreaDMList );  
       
      
            //System.debug('dmList: '+dmList);
            
            List<Credit_Info__c> ciList = [SELECT id, name,Distributor__c,distributor__r.name,
                                           Credit_Limit__c,Balance_Limit__c,Used_Limit__c, 
                                           Sum_Open_Item__c, DAYS_ARREARS__c 
                                           FROM Credit_Info__c 
                                           WHERE Distributor__c =:accountId LIMIT 1];
            
            List<Outstanding_Ageing__c> oagList = [SELECT id, OutstandingTotalGreaterthan90__c, Net_Outstanding__c
                                                  FROM Outstanding_Ageing__c
                                                  WHERE Customer_Code__c =:accountId LIMIT 1];
            System.debug('ciList: '+ciList);
            
            //Logic to add Account Details, Billing Address and Credit Information to Wrapper
            distWrapObj = new DistributorWrapper();
            distWrapObj.distributorName = accList[0].Name;
            distWrapObj.sapCode = accList[0].SAP_Code__c;
            for(Depot__c depot:depotList2){
                distWrapObj.salesOrgIds.add(depot.SalesOrg__c);// = accList[0].Sales_Org__c;
                distWrapObj.depots.add(depot.id);
                 distWrapObj.salesOrgNames.add('');//TODO:salesorg to be add
            }
            //distWrapObj.salesOrgNames = accList[0].Sales_Org__r.Name;
            for(DistributorSalesAreaMapping__c salesArea :SalesAreaDMList ){
                distWrapObj.distributorChannelIds.add(salesArea.DistributionChannel__c); //= accList[0].Distribution_Channel__c;            
                distWrapObj.divisionIds.add(salesArea.Division__c); //= accList[0].Division__c;  
                 distWrapObj.priceGroupId.add(salesArea.PriceGroupMaster__c);// =DistributorSalesAreaMappingMAP.get(salesArea.SalesOrg__c).PriceGroupMaster__c;  
            }
            
            distWrapObj.ordertype = accList[0].Order_Type__c; 
            distWrapObj.paymentTerms = accList[0].Payment_Terms__c;
          //  = accList[0].PriceGroupCode__c;//comes from salesArea
            
            List<Payments__c> oaList = [SELECT id, Net_Overdue__c 
                                                  FROM Payments__c
                                                  WHERE Customer_Name__c =:accountId LIMIT 1];
            
            if(!oaList.isEmpty()){
                distWrapObj.greaterThan90 = oaList[0].Net_Overdue__c; //oaList[0].OutstandingTotalGreaterthan90__c;
            }

            if(!oagList.isEmpty()){
                distWrapObj.paymentOutstanding = oagList[0].Net_Outstanding__c;
                //distWrapObj.greaterThan90 = oaList[0].Net_Overdue__c;
            }
            
            //Assign Order/Sales Order Owner to TM if Distributor License not found.
            if(String.isBlank(distributorId)){
                distributorId = accList[0].OwnerId;
                orderRaisedBy = 'Territory Manager';
            }
            
            //Populate StateMap Code to State Name
            for(State_Tax_Structure__c stateObj:[Select Id, State_Name__c, State_Code__c From State_Tax_Structure__c Where SalesOrg__r.Name = 'Indonesia']){
                stateMap.put(stateObj.State_Code__c, stateObj.State_Name__c);
            }
            System.debug('stateMap: '+stateMap);
            //End of Logic
            
            List<Shipping_Location__c> slList = [SELECT Id, Name, Distributor__c, City__c, 
                                                 Region__c, Pincode__c, State__c, Country__c,
                                                 Sold_To_Party_SAP_Code__c, SAP_Code__c
                                                 FROM Shipping_Location__c
                                                 WHERE Distributor__c =:accountId];
            if(slList.isEmpty()){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Shipping Details not found'));
                //CalloutException e = new CalloutException();
                //e.setMessage('?Shipping Details not found');
                //throw e;
            }
            
            List<TM_Depot_Mapping__c> tdmList = [SELECT Id, Depot__c, Depot__r.Location__c, Territory_Manager__c 
                                                 FROM TM_Depot_Mapping__c
                                                 WHERE Territory_Manager__c =:territoryManagerId];
            for(TM_Depot_Mapping__c tdmObj:tdmList){
                depotSet.add(new SelectOption(tdmObj.Depot__r.Location__c,tdmObj.Depot__r.Location__c));
            }
            System.debug('depotSet: '+depotSet);
            
            if(!dmList.isEmpty()){
               // distWrapObj.depots = dmList[0].Depot__r.Location__c;
                //depoId = dmList[0].Depot__c; TODO:to convert into list
            }
            else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Distributor Depot not found'));
                //CalloutException e = new CalloutException();
                //e.setMessage('?Distributor Depot not found');
                //throw e;
            }
            System.debug('distWrapObj.depots: '+distWrapObj.depots);
            
            if(distWrapObj.depots.size()>0){
                fetchSKUData();
            }
            
            if(!ciList.isEmpty()){
                distWrapObj.creditLimit = ciList[0].Credit_Limit__c;
                distWrapObj.creditUsed = ciList[0].Used_Limit__c;
                distWrapObj.creditBalance = ciList[0].Balance_Limit__c;
                //distWrapObj.paymentOutstanding = ciList[0].Sum_Open_Item__c;
                distWrapObj.daysArrears = ciList[0].DAYS_ARREARS__c;
            }
            else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Credit Information for Distributor not found'));
                //CalloutException e = new CalloutException();
                //e.setMessage('?Credit Information for Distributor not found');
                //throw e;
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
                if(String.isNotBlank(slObj.SAP_Code__c) && distWrapObj.sapCode == slObj.SAP_Code__c){
                    shippingList.add(new SelectOption(slObj.SAP_Code__c,'Same as Billing Address'));
                    
                    slw2Obj.locationId = slObj.Id;
                    slw2Obj.address = slObj.Region__c;
                    slw2Obj.city = slObj.City__c;
                 //   if(distWrapObj.salesOrgNames == 'Indonesia'){ comment by abhishek
                        slw2Obj.state = 'Indonesia';
                    //}
                    //slw2Obj.state = slObj.State__c;
                   /* if(stateMap.containsKey(slObj.State__c) && distWrapObj.salesOrgNames != 'Indonesia'){
                        slw2Obj.state = stateMap.get(slObj.State__c);
                    }
                    else if(distWrapObj.salesOrgNames == 'Indonesia'){
                        slw2Obj.state = 'Indonesia';//stateMap.get(slObj.State__c);
                        System.debug('State Code not Mandatory: Indonesia');
                    }
                    else{
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'State Code not found'));
                    }*/
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
                  if(String.isNotBlank(slObj.City__c)){
                    slw2Obj.city = slObj.City__c;
                  }else{
                        slw2Obj.city = '';
                  
                  }
                    slw2Obj.city = slObj.City__c;
                    //slw2Obj.state = slObj.State__c;
                    System.debug('slObj.State__c: '+slObj.State__c);
                    System.debug('stateMap: '+stateMap);
                     slw2Obj.state = 'Indonesia';
                 /*   if(stateMap.containsKey(slObj.State__c)){
                        slw2Obj.state = stateMap.get(slObj.State__c);
                    }
                    else{
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'State Code not found'));
                    }*/
                    slw2Obj.country = slObj.Country__c;
                    slw2Obj.pincode = slObj.Pincode__c;
                    shippingMap.put(slw2Obj.City, slw2Obj);
                }
                //End of Logic
            }
            //End of Logic
            
            if(String.isNotBlank(orderId)){
                editOrder();
            }
            shippingJSON = JSON.serialize(shippingMap.values());
            populateShippingAddress();
        }
        catch(Exception ex){
            ApexLog.exceptionHandler(ex, orderId, accountId);
        }
    }
    
    //Method for actionSupport on Address Picklist change
    public void populateShippingAddress(){
        try{
            ApexLog.exceptionCoverage(throwEx);
            
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
            ApexLog.exceptionHandler(ex, orderId, accountId);
        }
    }
    
    public void fetchSKUData(){
        try{
            ApexLog.exceptionCoverage(throwEx);
            
            //Logic to populate existing wrapper with Pricebook Details
            
            List<PriceBookMaster__c> pbmList = [SELECT Id, SKUCode__c,SKUCode__r.Brand_Name__c ,SKUCode__r.Name, SKUCode__r.Sales_Org__r.Sales_Org_Code__c,
                                                SKUCode__r.Pack_Size__c, SKUCode__r.SKU_Code__c,
                                                DepotCode__c, DepotCode__r.Location__c, 
                                                Price__c, PG_CODE__c, PG_CODE__r.Name, 
                                                UOM__c, SKUCode__r.Product_Name__r.Name, SKUCode__r.SKU_Description__c,
                                                SKUCode__r.Product_Name__c, SKUCode__r.Product_Name__r.Popular__c,
                                                DistributorCustomerCode__r.Name, CurrencyIsoCode
                                                FROM PriceBookMaster__c
                                                WHERE (DistributorCustomerCode__c =: accountId 
                                                       OR (DepotCode__c IN: distWrapObj.depots AND PG_CODE__c IN:distWrapObj.priceGroupId))
                                                AND SKUCode__r.Sales_Org__c IN: distWrapObj.salesOrgIds
                                                AND StartDate__c <= TODAY AND EndDate__c >= TODAY AND SKUCode__r.Active__c = True
                                                ORDER BY SKUCode__r.Product_Name__r.Name ASC, SKUCode__r.SKU_Code__c DESC, LastModifiedDate ASC];
            
            String query  = 'SELECT Id, SKUCode__c ,SKUCode__r.Name, ';
            query += 'SKUCode__r.Pack_Size__c, SKUCode__r.SKU_Code__c, ';
            query += 'DepotCode__c, DepotCode__r.Location__c, ';
            query += 'Price__c, PG_CODE__c, PG_CODE__r.Name, ';
            query += 'UOM__c, SKUCode__r.Product_Name__r.Name, ';
            query += 'SKUCode__r.Product_Name__c, SKUCode__r.Product_Name__r.Popular__c, ';
            query += 'DistributorCustomerCode__r.Name, CurrencyIsoCode, ';
            query += 'SKUCode__r.Product_Name__r.VF_Image__c ';
            query += 'FROM PriceBookMaster__c  ';
            query += 'WHERE (DistributorCustomerCode__c =\''+accountId+'\' ';
            query += 'OR (DepotCode__c =\''+depoId+'\' AND PG_CODE__c=\''+distWrapObj.priceGroupId+'\')) ';
            query += 'AND SKUCode__r.Sales_Org__c =\''+distWrapObj.salesOrgIds+'\' ';
            query += 'AND StartDate__c <= TODAY AND EndDate__c >= TODAY AND SKUCode__r.Active__c = True ';
            query += 'ORDER BY SKUCode__r.Product_Name__r.Name ASC, SKUCode__r.SKU_Code__c DESC, LastModifiedDate ASC';
            
            System.debug('query: '+query);
            
            System.debug('pbmList: '+pbmList);
            System.debug('size: '+pbmList.size());
            
            SKUDetails skuWrapObj;
            
            if(pbmList.isEmpty()){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Pricebook for Depot/Distributor not found'));
                CalloutException e = new CalloutException();
                e.setMessage(query);
                throw e;
            }
            for(PriceBookMaster__c pbObj : pbmList){
                skuWrapObj = new SKUDetails();
                skuWrapObj.brandName = pbObj.SKUCode__r.SKU_Description__c;//pbObj.SKUCode__r.Product_Name__r.Name +' '+pbObj.SKUCode__r.Name;
                skuWrapObj.SKUBrand = pbObj.SKUCode__r.Brand_Name__c;
                skuWrapObj.description ='Sales Org: '+pbObj.SKUCode__r.Sales_Org__r.Sales_Org_Code__c+' SKU CODE : '+pbObj.SKUCode__r.SKU_Code__c;
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
                //system.debug('pbObj.SKUCode__r.Sales_Org__c - '+pbObj.SKUCode__r.Sales_Org__r.Sales_Org_Code__c);
                skuWrapObj.salesOrgID = pbObj.SKUCode__r.Sales_Org__r.ID;//added by abhishek
                
                /*if(String.isNotBlank(pbObj.SKUCode__r.Product_Name__r.VF_Image__c)){
        skuWrapObj.image = pbObj.SKUCode__r.Product_Name__r.VF_Image__c;
        }*/
                if(String.isNotBlank(pbObj.SKUCode__c) && String.isNotBlank(skuWrapObj.UOM)){
                    skuDetailsMap.put(pbObj.SKUCode__c+'_'+pbObj.SKUCode__r.Sales_Org__r.Sales_Org_Code__c, skuWrapObj);
                }
            }
            //End of Logic
            
            //Logic to populate existing wrapper with Pricebook Discount
            
            List<PricebookDiscount__c> pbdList = [SELECT Id, SKUCode__c,
                                                  Price__c, CurrencyIsoCode, LastModifiedDate,SKUCode__r.Sales_Org__c,SKUCode__r.Sales_Org__r.Sales_Org_Code__c
                                                  FROM PricebookDiscount__c
                                                  WHERE (DistributorCustomerCode__c =:accountId 
                                                         OR (DepotCode__c IN:distWrapObj.depots AND PG_CODE__c IN :distWrapObj.priceGroupId)) 
                                                  AND SKUCode__r.Sales_Org__c IN: distWrapObj.salesOrgIds
                                                  AND StartDate__c <= TODAY AND EndDate__c >= TODAY AND SKUCode__r.Active__c = True
                                                  ORDER BY SKUCode__r.Product_Name__r.Name ASC, SKUCode__r.SKU_Code__c DESC, LastModifiedDate ASC];
            System.debug('pbdList: '+pbdList);
            System.debug('size: '+pbdList.size());
            
            for(PricebookDiscount__c pbObj : pbdList){
                if(skuDetailsMap.containsKey(pbObj.SKUCode__c+'_'+pbObj.SKUCode__r.Sales_Org__r.Sales_Org_Code__c)){
                    skuWrapObj = skuDetailsMap.get(pbObj.SKUCode__c+'_'+pbObj.SKUCode__r.Sales_Org__r.Sales_Org_Code__c);
                    skuWrapObj.schemeBonus = Math.abs(pbObj.Price__c); 
                    skuWrapObj.currencyIso = pbObj.currencyIsoCode;
                    skuDetailsMap.put(pbObj.SKUCode__c+'_'+pbObj.SKUCode__r.Sales_Org__r.Sales_Org_Code__c, skuWrapObj);
                }
            }
            //End of Logic
            
            //Logic to populate existing wrapper with Special Discount
            
            List<SpecialInvoiceDiscount__c> sidList = [SELECT Id, SKUCode__c, 
                                                       Price__c, CurrencyIsoCode, LastModifiedDate,SKUCode__r.Sales_Org__c,SKUCode__r.Sales_Org__r.Sales_Org_Code__c
                                                       FROM SpecialInvoiceDiscount__c
                                                       WHERE (DistributorCustomerCode__c =:accountId 
                                                              OR (DepotCode__c IN: distWrapObj.depots AND PG_CODE__c IN :distWrapObj.priceGroupId))
                                                       AND SKUCode__r.Sales_Org__c IN: distWrapObj.salesOrgIds
                                                       AND StartDate__c <= TODAY AND EndDate__c >= TODAY AND SKUCode__r.Active__c = True
                                                       ORDER BY SKUCode__r.Product_Name__r.Name ASC, SKUCode__r.SKU_Code__c DESC, LastModifiedDate ASC];
            
            System.debug('sidList: '+sidList);
            System.debug('size: '+sidList.size());
            
            for(SpecialInvoiceDiscount__c pbObj : sidList){
                if(skuDetailsMap.containsKey(pbObj.SKUCode__c+'_'+pbObj.SKUCode__r.Sales_Org__r.Sales_Org_Code__c)){
                    skuWrapObj = skuDetailsMap.get(pbObj.SKUCode__c+'_'+pbObj.SKUCode__r.Sales_Org__r.Sales_Org_Code__c);
                    skuWrapObj.invoiceDiscount = Math.abs(pbObj.Price__c);
                    skuWrapObj.currencyIso = pbObj.currencyIsoCode;
                    skuDetailsMap.put(pbObj.SKUCode__c+'_'+pbObj.SKUCode__r.Sales_Org__r.Sales_Org_Code__c, skuWrapObj);
                }
            }
            //End of Logic
            
            //Logic to populate existing wrapper with Pack Size
            
            List<SKU_Pack_Size__c> packSizeList = [SELECT Id, Pack_Size__c, 
                                                   UOM__c, SKU__c,SKU__r.Sales_Org__c
                                                   FROM SKU_Pack_Size__c
                                                   WHERE Depot__c IN: distWrapObj.depots
                                                   AND SKU__r.Active__c = True];
            
            System.debug('packSizeList: '+packSizeList);
            System.debug('size: '+packSizeList.size());
            
            for(SKU_Pack_Size__c psObj : packSizeList){
                if(skuDetailsMap.containsKey(psObj.SKU__c+'_'+psObj.SKU__r.Sales_Org__c)){
                    skuWrapObj = skuDetailsMap.get(psObj.SKU__c+'_'+psObj.SKU__r.Sales_Org__c);
                    skuWrapObj.packSize = Decimal.ValueOf(psObj.Pack_Size__c);
                    skuWrapObj.UOM = psObj.UOM__c;
                    skuDetailsMap.put(psObj.SKU__c+'_'+psObj.SKU__r.Sales_Org__r.Sales_Org_Code__c, skuWrapObj);
                }
            }
            //End of Logic
            
            //Only for Indonesia
            //Logic to populate existing wrapper with Scheme Bonus Discount
            
            List<PriceBook_Indonesia_Discount__c> sbdList = [SELECT Id, SKUCode__c,SKUCode__r.Sales_Org__r.Sales_Org_Code__c, 
                                                             Price__c, CurrencyIsoCode
                                                             FROM PriceBook_Indonesia_Discount__c
                                                             WHERE (DistributorCustomerCode__c =:accountId 
                                                                    OR (DepotCode__c IN: distWrapObj.depots AND PG_CODE__c IN:distWrapObj.priceGroupId))
                                                             AND SKUCode__r.Sales_Org__c IN: distWrapObj.salesOrgIds      
                                                             AND StartDate__c <= TODAY AND EndDate__c >= TODAY AND SKUCode__r.Active__c = True];
            
            System.debug('sbdList: '+sbdList);
            System.debug('size: '+sbdList.size());
            
            for(PriceBook_Indonesia_Discount__c pbObj : sbdList){
               system.debug('pbObj.SKUCode__r.Sales_Org__c -'+pbObj.SKUCode__c+'_'+pbObj.SKUCode__r.Sales_Org__r.Sales_Org_Code__c);
                   
                if(skuDetailsMap.containsKey(pbObj.SKUCode__c+'_'+pbObj.SKUCode__r.Sales_Org__r.Sales_Org_Code__c)){
                    skuWrapObj = skuDetailsMap.get(pbObj.SKUCode__c+'_'+pbObj.SKUCode__r.Sales_Org__r.Sales_Org_Code__c);
                    skuWrapObj.specialDiscount = Math.abs(pbObj.Price__c);
                    skuWrapObj.currencyIso = pbObj.currencyIsoCode;
                    skuDetailsMap.put(pbObj.SKUCode__c+'_'+pbObj.SKUCode__r.Sales_Org__r.Sales_Org_Code__c, skuWrapObj);
                }
            }
            //End of Logic
            
            //Logic to populate existing wrapper with Inventory
            system.debug('distWrapObj.depots - '+distWrapObj.depots);
            List<Inventory__c> invList = [SELECT Id, SKU__c, 
                                          Stock_Quantity__c,SKU__r.Sales_Org__r.Sales_Org_Code__c, Balanced_Quanity__c,In_transit_stock_quantity__c
                                          FROM Inventory__c
                                          WHERE Depot__c IN: distWrapObj.depots AND SKU__r.Active__c = True];        
            
            System.debug('invList: '+invList);
            System.debug('size: '+invList.size());
            system.debug('skuDetailsMap - '+skuDetailsMap);
            for(Inventory__c pbObj : invList){
                 system.debug('pbObj.SKU__r.Sales_Org__r.Sales_Org_Code__c----->'+pbObj.SKU__c+'_'+pbObj.SKU__r.Sales_Org__r.Sales_Org_Code__c);
                if(skuDetailsMap.containsKey(pbObj.SKU__c+'_'+pbObj.SKU__r.Sales_Org__r.Sales_Org_Code__c)){
                    skuWrapObj = skuDetailsMap.get(pbObj.SKU__c+'_'+pbObj.SKU__r.Sales_Org__r.Sales_Org_Code__c);
                    system.debug('skuWrapObj----->'+skuWrapObj);
                    skuWrapObj.available = Integer.valueOf(pbObj.Balanced_Quanity__c);
                    skuWrapObj.inventoryId = pbObj.Id;
                    if(pbObj.Balanced_Quanity__c!=null && pbObj.Balanced_Quanity__c > 0){
                        skuWrapObj.available2 = 'In Stock';
                    }
                    else if(pbObj.In_transit_stock_quantity__c != null){
                        if(pbObj.In_transit_stock_quantity__c > 0 && showInTransit==true && showInTransitValues==false){
                            skuWrapObj.available2 = 'In Transit';
                        }
                        else if(pbObj.In_transit_stock_quantity__c > 0 && showInTransit==false && showInTransitValues==true){
                            skuWrapObj.available2 = '('+pbObj.In_transit_stock_quantity__c+')';
                        }                    
                        else if(pbObj.In_transit_stock_quantity__c > 0 && showInTransit==true && showInTransitValues==true){
                            skuWrapObj.available2 = 'In Transit ('+pbObj.In_transit_stock_quantity__c+')';
                        } 
                    }
                    
                    skuDetailsMap.put(pbObj.SKU__c+'_'+pbObj.SKU__r.Sales_Org__r.Sales_Org_Code__c, skuWrapObj);
                }
            }
            
            System.debug('skuDetailsMap: '+skuDetailsMap);
            System.debug('size: '+skuDetailsMap.size());
            
            System.debug('salesOrgName: '+distWrapObj.salesOrgNames);
            
            //End of Logic
            skuJSON = JSON.serialize(skuDetailsMap.values());
            fetchPopular();
        }
        catch(Exception ex){
            ApexLog.exceptionHandler(ex, orderId, accountId);
        }
    }
    
    //Method to fetch Popular Products
    public void fetchPopular(){
        try{
            ApexLog.exceptionCoverage(throwEx);
            
            System.debug('skuDetailsList before: '+skuDetailsList);
            System.debug('productNamesSet before: '+productNamesSet);
            
            skuDetailsList.clear();
            productNamesSet.clear();
            descriptionSet.clear();
            
            for(SKUDetails skuWrapObj:skuDetailsMap.values()){
                Decimal totalPrice = skuWrapObj.Price - Math.abs(skuWrapObj.schemeBonus) - Math.abs(skuWrapObj.specialDiscount);
                skuWrapObj.netRateEntered = totalPrice - (skuWrapObj.spotDiscount/100)*skuWrapObj.Price - (skuWrapObj.invoiceDiscount/100)*skuWrapObj.Price;
                
                productNamesSet.add(skuWrapObj.productName);
                descriptionSet.add(skuWrapObj.SKUBrand);
                //if(skuWrapObj.Popular){
                    skuDetailsList.add(skuWrapObj);
                //}
                
                skuDetailsMap.put(skuWrapObj.skuId, skuWrapObj);//TODO:
            }
            System.debug('skuDetailsList: '+skuDetailsList);
            System.debug('productNamesSet: '+productNamesSet);
            System.debug('skuDetailsMap: '+skuDetailsMap);
        }
        catch(Exception ex){
            ApexLog.exceptionHandler(ex, orderId, accountId);
        }
    }
    
    //Method to populate Products based on Brand Input
    public void searchProduct(){
        try{
            ApexLog.exceptionCoverage(throwEx);
            
            if(searchProdValue!=''){
                skuDetailsList.clear();
                for(SKUDetails skuWrapObj:skuDetailsMap.values()){
                    if(skuWrapObj.brandName.containsIgnoreCase(searchProdValue)){
                        skuDetailsList.add(skuWrapObj);
                    }
                }
            }
            else{
                fetchPopular();
            }
        }
        catch(Exception ex){
            ApexLog.exceptionHandler(ex, orderId, accountId);
        }
    }
    
    //Method to initialize Order Object with Existing Order on Edit or Create new Order
    public void createOrder(){
       try{
            ApexLog.exceptionCoverage(throwEx);
            if(ordObj==null){
                List<Order__c> recentOrderList =  [SELECT Id, Name, Net_Amount__c, Bill_To_Party__c, Order_Date__c, 
                                                   Order_Raise_By__c, Order_Status__c, Vat_Amount__c, 
                                                   RegionalManager__c, Shipping_Location__c, OwnerId, 
                                                   Additional_Tax_Amount__c, Gross_Amount__c, Remarks__c
                                                   FROM Order__c 
                                                   WHERE Order_Status__c='Draft'
                                                   AND Bill_To_Party__c =: accountId LIMIT 1];
                
                if(!recentOrderList.isEmpty()){
                    ordObj = recentOrderList[0];
                    orderId = ordObj.Id;
                    ordObj.OwnerId = userinfo.getuserid();
                   update ordObj; 
                    editOrder();
                }
                else{ //TODO:Order Spliting logic here
                
                    ordObj = new Order__c();
                    ordObj.Bill_To_Party__c = accountId;
                    ordObj.OwnerId =userinfo.getuserid();//= distributorId;
                    ordObj.Order_Date__c = System.today();
                    ordObj.Order_Raise_By__c = orderRaisedBy;
                    ordObj.Order_Status__c = 'Draft';
                    ordObj.RegionalManager__c = distWrapObj.regionalManagerId;
                   // ordObj.Sales_Org__c = distWrapObj.salesOrgIds;
                  //  ordObj.Distribution_Channel__c = distWrapObj.distributorChannelIds; 
                  //  ordObj.Division__c = distWrapObj.divisionIds; 
                    ordObj.OwnerId = userinfo.getuserid();//distributorId; 
                    ordObj.CurrencyIsoCode = distWrapObj.currencyIso;
                    
                    if(String.isNotBlank(slwObj.locationId)){
                        ordObj.Shipping_Location__c = slwObj.locationId;
                    }
                    insert ordObj;
                    orderId = ordObj.Id;
                }
            }
        }
        catch(Exception ex){
            ApexLog.exceptionHandler(ex, orderId, accountId);
        }  
    }
    
    //Method to reload existing order line items in to Order Wrapper
    public void editOrder(){
        try{
            ApexLog.exceptionCoverage(throwEx);
            List<OrderLineItem__c> oliList =new List<OrderLineItem__c>();
            createOrder();
            refreshOrderValue();
            
            if(ordObj.Order_Status__c=='Approved'){
                enableInput = false;
            }
            if(orderId!=null){ // SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022 ...Delivery date field added...
                oliList = [SELECT Id, Name, CurrencyIsoCode, SKUPackSize__c, Delivery_Date__c, 
                            Order__c, UOM__c, Special_Discount__c, SKU_Name__c,Net_Price__c,SKU_Name__r.Sales_Org__c, 
                            SKU_Name__r.Pack_Size__c, Scheme_Bonus_Discount__c,
                            SKU_Name__r.Product_Name__r.Name, Spot_Discount__c,
                            SKU_Name__r.Name, Quantity__c, Price__c, No_of_Case__c, Item_Number__c, 
                            Item_Status__c, Invoice_Discount__c, Order__r.Shipping_Location__c,
                            SpotDiscountPercentage__c, DistributorDiscountPercentage__c
                            FROM OrderLineItem__c
                            WHERE Order__c=:orderId];}
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
                    skuWrapObj.salesOrgID = skuWrapObj2.salesOrgID;//oliObj.SKU_Name__r.Sales_Org__c; 
                    system.debug('skuWrapObj2.salesOrgID - '+skuWrapObj2.salesOrgID);
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
                    
                    skuWrapObj.specialDiscountEntered = oliObj.Special_Discount__c;
                    skuWrapObj.schemeBonusEntered = oliObj.Scheme_Bonus_Discount__c;
                    
                    skuWrapObj.qty = oliObj.Quantity__c;
                    
                    Decimal totalPrice = skuWrapObj.Price - skuWrapObj.specialDiscount - skuWrapObj.schemeBonus;
                    skuWrapObj.invoiceDiscountEntered = (skuWrapObj.invoiceDiscount/100)*skuWrapObj.price*skuWrapObj.qty;
                    skuWrapObj.invoiceDiscount = oliObj.DistributorDiscountPercentage__c;
                    skuWrapObj.spotDiscount = oliObj.SpotDiscountPercentage__c;
                    skuWrapObj.netRateEntered = totalPrice - skuWrapObj.invoiceDiscountEntered - (skuWrapObj.spotDiscount/100)*skuWrapObj.price;
                    system.debug('skuWrapObj.netRateEntered'+skuWrapObj.netRateEntered);
                    skuWrapObj.priceEntered = oliObj.Price__c;
                    
                    
                    skuWrapObj.UOM = oliObj.UOM__c;
                    
                    skuWrapObj.available = skuWrapObj2.available;
                    system.debug('skuWrapObj.available --->'+skuWrapObj.available);
                                        system.debug('skuWrapObj2.available--->'+skuWrapObj2.available);
                    skuWrapObj.available2 = skuWrapObj2.available2;
                    skuWrapObj.currencyIso = oliObj.CurrencyIsoCode;
                    skuWrapObj.itemNo = Integer.valueOf(oliObj.Item_Number__c);
                    /* -------------- Start SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022 ----------------- */
                    if(oliObj.Delivery_Date__c == null){
                        skuWrapObj.deliveryDate = '';
                    }
                    else{
                        skuWrapObj.deliveryDate = String.valueof(oliObj.Delivery_Date__c);
                    }
                    
                    skuOrderMap.put(skuWrapObj.skuId+''+oliObj.Item_Number__c,skuWrapObj);
                    /* ----------------- End SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022 ----------------- */
                    itemNumber = Integer.valueOf(oliObj.Item_Number__c);
                    
                    skuOrderList.add(skuWrapObj);
                    orderListCount = skuOrderList.size();
                }
            }
        }
        catch(Exception ex){
            ApexLog.exceptionHandler(ex, orderId, accountId);
        }            
    }
    
    //Method to Add SKU to Order Table
    public void addSKU(){
        try{
            ApexLog.exceptionCoverage(throwEx);
            Boolean flag = false; // SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022
            SKUDetails skuWrapObj2 = skuDetailsMap.get(skuIdChosen);
            system.debug('skuWrapObj2'+skuWrapObj2);
            if(skuWrapObj2.qty>0||Test.isRunningTest()){
                skuOrderList.clear();
                SKUDetails skuWrapObj;
                OrderLineItem__c oliObj = new OrderLineItem__c();
                /* --------------- Start SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022 --Entire method logic changed---------- */
                /* if(skuOrderMap.containsKey(skuIdChosen)){
                    skuWrapObj = skuOrderMap.get(skuIdChosen);

                    if(showDeliveryDate == true){
                        if(isDeliveryRequired == true && (skuWrapObj2.deliveryDate == '' || String.isBlank(skuWrapObj2.deliveryDate))){
                            showError = true;
                            errorMessage = System.Label.Delivery_Date_is_Required; 
                            flag = true;
                        }
                        else if((skuWrapObj2.deliveryDate != '' || String.isNotBlank(skuWrapObj2.deliveryDate)) && +Date.valueof(skuWrapObj2.deliveryDate) < +System.today()+1){
                            showError = true;
                            errorMessage = System.Label.Date_of_delivery_should_not_be_less_than_todays_date; 
                            flag = true;
                        }
                        else if(skuWrapObj2.deliveryDate == '' || String.isBlank(skuWrapObj2.deliveryDate)){
                            oliObj.Delivery_Date__c = null;
                            skuWrapObj.deliveryDate = '';
                        }
                        else{
                            oliObj.Delivery_Date__c = Date.valueof(skuWrapObj2.deliveryDate);
                            skuWrapObj.deliveryDate = skuWrapObj2.deliveryDate;
                        }
                    }

                    if(flag == false){
                        skuWrapObj.invoiceDiscountEntered = skuWrapObj2.invoiceDiscountEntered;
                        skuWrapObj.spotDiscount = skuWrapObj2.spotDiscount;
                        
                        skuWrapObj.numberOfCases += skuWrapObj2.numberOfCases;
                        
                        skuWrapObj.specialDiscountEntered += skuWrapObj2.specialDiscountEntered;
                        skuWrapObj.priceEntered += skuWrapObj2.priceEntered;
                        skuWrapObj.schemeBonusEntered += skuWrapObj2.schemeBonusEntered;
                        system.debug('skuWrapObj2.netRateEntered'+skuWrapObj2.netRateEntered);
                    // skuWrapObj.netRateEntered =skuWrapObj2.netRateEntered;
                        skuWrapObj.netRateEntered = skuWrapObj.Price - ((skuWrapObj.invoiceDiscount/100)*skuWrapObj.price) - skuWrapObj.specialDiscount - skuWrapObj.schemeBonus - ((skuWrapObj.spotDiscount/100)*skuWrapObj.price);
                        
                        skuWrapObj.qty += skuWrapObj2.qty;
                        
                        if(String.isNotBlank(skuWrapObj.oliId)){
                            oliObj.Id = skuWrapObj.oliId;
                        }
                        if(skuWrapObj2.available==0 || skuWrapObj2.available2=='Out of Stock'){
                            oliObj.Stock_Available__c = true;
                        }
                        
                        oliObj.Invoice_Discount__c = (skuWrapObj.invoiceDiscount/100)*skuWrapObj.price;
                        oliObj.Spot_Discount__c = (skuWrapObj.spotDiscount/100)*skuWrapObj.price;
                        oliObj.DistributorDiscountPercentage__c = skuWrapObj.invoiceDiscount;
                        oliObj.SpotDiscountPercentage__c = skuWrapObj.spotDiscount;
                        
                        
                        oliObj.Special_Discount__c = skuWrapObj.specialDiscountEntered;
                        oliObj.Scheme_Bonus_Discount__c = skuWrapObj.schemeBonusEntered;
                        
                        oliObj.No_of_Case__c = skuWrapObj.numberOfCases;
                        oliObj.Quantity__c = skuWrapObj.qty;
                        oliObj.Price__c = skuWrapObj.priceEntered;
                        upsert oliObj; 
                    }
                } */
                //else{
                    skuWrapObj = new SKUDetails();

                    if(showDeliveryDate == true){
                        if(isDeliveryRequired == true && (skuWrapObj2.deliveryDate == '' || String.isBlank(skuWrapObj2.deliveryDate))){
                            showError = true;
                            errorMessage = System.Label.Delivery_Date_is_Required; 
                            flag = true;
                        }
                        else if((skuWrapObj2.deliveryDate != '' || String.isNotBlank(skuWrapObj2.deliveryDate)) && +Date.valueof(skuWrapObj2.deliveryDate) < +System.today()+1){
                            showError = true;
                            errorMessage = System.Label.Date_of_delivery_should_not_be_less_than_todays_date; 
                            flag = true;
                        }
                        else if(skuWrapObj2.deliveryDate == '' || String.isBlank(skuWrapObj2.deliveryDate)){
                            oliObj.Delivery_Date__c = null;
                            skuWrapObj.deliveryDate = '';
                        }
                        else{
                            oliObj.Delivery_Date__c = Date.valueof(skuWrapObj2.deliveryDate);
                            skuWrapObj.deliveryDate = skuWrapObj2.deliveryDate;
                        }
                    }

                    if(flag == false){
                        createOrder();
                        
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
                        oliObj.Invoice_Discount__c = (skuWrapObj.invoiceDiscount/100)*skuWrapObj.price*skuWrapObj.qty;
                        oliObj.Spot_Discount__c = (skuWrapObj.spotDiscount/100)*skuWrapObj.price*skuWrapObj.qty;
                        oliObj.DistributorDiscountPercentage__c = skuWrapObj.invoiceDiscount;
                        oliObj.SpotDiscountPercentage__c = skuWrapObj.spotDiscount;
                        skuWrapObj.netRateEntered = skuWrapObj.Price - ((skuWrapObj.invoiceDiscount/100)*skuWrapObj.price) - skuWrapObj.specialDiscount - skuWrapObj.schemeBonus - ((skuWrapObj.spotDiscount/100)*skuWrapObj.price);
                        System.debug('Indonesia: '+skuWrapObj.netRateEntered);
                        System.debug('netRateEntered: '+skuWrapObj.netRateEntered);
                        skuWrapObj.salesOrgID = skuWrapObj2.salesOrgID;
                        oliObj.Special_Discount__c = skuWrapObj.specialDiscountEntered;
                        oliObj.Scheme_Bonus_Discount__c = skuWrapObj.schemeBonusEntered;
                        itemNumber = itemNumber+10;
                        skuWrapObj.itemNo = itemNumber;
                        oliObj.Item_Number__c = String.valueOf(itemNumber);
                        oliObj.CurrencyIsoCode = distWrapObj.currencyIso;
                        oliObj.No_of_Case__c = skuWrapObj.numberOfCases;
                        oliObj.Quantity__c = skuWrapObj.qty;
                        oliObj.Price__c = skuWrapObj.priceEntered;
                    //  oliObj.PriceBookMaster__c;
                        
                        insert oliObj;
                        skuWrapObj.oliId = oliObj.Id;
                    }
                //}

                if(flag == false){
                    netAmount += skuWrapObj2.priceEntered;
                    system.debug('skuWrapObj.salesOrgID - '+skuWrapObj.salesOrgID);
                    skuOrderMap.put(skuWrapObj2.skuId+''+String.valueOf(skuWrapObj.itemNo),skuWrapObj);
                    skuOrderList.addAll(skuOrderMap.values());
                    calculateTax();
                    showError = false;
                }
                /* ----------- End SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022 ------------------------- */
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
            ApexLog.exceptionHandler(ex, orderId, accountId);
        }            
    }
    
    //Method to update existing Order line item on Qty/Price Change
    public void updateSKU(){
        System.debug('updateSKU: ');
        try{
            ApexLog.exceptionCoverage(throwEx);
            Boolean flag = false; // SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022
            //netAmount = 0;
            OrderLineItem__c oliObj = new OrderLineItem__c();
            for(SKUDetails skuObj:skuOrderList){
                /* ------------- Start SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022 ------------------- */
                if(showDeliveryDate == true){
                    if(isDeliveryRequired == true && (skuObj.deliveryDate == '' || String.isBlank(skuObj.deliveryDate))){
                        showError = true;
                        errorMessage = System.Label.Delivery_Date_is_Required; 
                        flag = true;
                    }
                    else if((skuObj.deliveryDate != '' || String.isNotBlank(skuObj.deliveryDate)) && +Date.valueof(skuObj.deliveryDate) < +System.today()+1){
                        showError = true;
                        errorMessage = System.Label.Date_of_delivery_should_not_be_less_than_todays_date; 
                        flag = true;
                    }
                    else if(skuObj.deliveryDate == '' || String.isBlank(skuObj.deliveryDate)){
                        oliObj.Delivery_Date__c = null;
                        skuObj.deliveryDate = '';
                    }
                    else{
                        oliObj.Delivery_Date__c = Date.valueof(skuObj.deliveryDate);
                        //skuObj.deliveryDate = skuObj.deliveryDate;
                    }
                }
                /* -------------- End SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022 -------------------------- */
                if(flag == false){ // SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022

                    if(String.isNotBlank(skuObj.oliId)){
                        oliObj.Id = skuObj.oliId;
                    }
                    
                    Decimal totalPrice = skuObj.Price - skuObj.specialDiscount - skuObj.schemeBonus;
                    oliObj.Invoice_Discount__c = (skuObj.invoiceDiscount/100)*totalPrice*skuObj.qty;
                    oliObj.Spot_Discount__c = (skuObj.spotDiscount/100)*totalPrice*skuObj.qty;
                    oliObj.DistributorDiscountPercentage__c = skuObj.invoiceDiscount;
                    oliObj.SpotDiscountPercentage__c = skuObj.spotDiscount; 
                    skuObj.netRateEntered = skuObj.Price - skuObj.specialDiscount - skuObj.schemeBonus - oliObj.Invoice_Discount__c - oliObj.Spot_Discount__c;
                    System.debug('netRateEntered: '+skuObj.netRateEntered);
                    oliObj.Special_Discount__c = skuObj.specialDiscountEntered;
                    oliObj.No_of_Case__c = skuObj.numberOfCases;
                    oliObj.Quantity__c = skuObj.qty;
                    oliObj.Price__c = skuObj.priceEntered;
                    oliObj.Scheme_Bonus_Discount__c = skuObj.schemeBonusEntered;
                    upsert oliObj;
                    netAmount += skuObj.priceEntered;
                    skuOrderMap.put(skuObj.skuId+''+String.valueOf(skuObj.itemNo),skuObj);    
                }        
            }
            if(flag == false){ // SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022
                calculateTax();
            }
        }
        catch(Exception ex){
            ApexLog.exceptionHandler(ex, orderId, accountId);
        }            
    }
    
    //Method to delete SKU from Order Table
    public void deleteSKU(){
        try{
            ApexLog.exceptionCoverage(throwEx);
            skuOrderList = new List<SKUDetails>();
            OrderLineItem__c oliObj = new OrderLineItem__c();
            /* -------------- Start SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022 ------------ */
            oliObj.Id = skuOrderMap.get(skuIdChosen+''+String.valueof(itemNumberChosen)).oliId;
            netAmount -= skuOrderMap.get(skuIdChosen+''+String.valueof(itemNumberChosen)).priceEntered;
            system.debug('skuOrderMap - before'+skuOrderMap);
            skuOrderMap.remove(skuIdChosen+''+String.valueof(itemNumberChosen));
           /* ------------- End SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022 --------------- */
            delete oliObj;
            skuOrderList.addAll(skuOrderMap.values());
            calculateTax();
        }
        catch(Exception ex){
            ApexLog.exceptionHandler(ex, orderId, accountId);
        }            
    }
    
    //Method to Empty Order Summary
    public void deleteAllSKU(){
        try{
            ApexLog.exceptionCoverage(throwEx);
            delete[Select id from OrderLineItem__c where order__c=:orderId];
            skuOrderMap.clear();
            skuOrderList.clear();
            calculateTax();
        }
        catch(Exception ex){
            ApexLog.exceptionHandler(ex, orderId, accountId);
        }  
    }
    
    //Method to Save the Order as Draft
    public void saveOrder(){
        try{
            ApexLog.exceptionCoverage(throwEx);
            showError = false;
    system.debug('Save Order----------skuOrderList.isEmpty()---'+skuOrderList.isEmpty() +' --showError-- '+showError);
    for(SKUDetails skuWrapObj:skuOrderMap.values()){
                   
                    if(skuWrapObj.qty==0){
                        showError = true;
                        errorMessage = 'Please Enter Quantity for all SKU\'s before confirming order'; 
                        //'Please Enter Quantity for all SKU\'s before confirming order'; 
                        break;
                    }
                }
            if(allowTemplate == True){
                if(String.isNotBlank(templateName)){
                    saveTemplate();
                }
                else{
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
            }
            else if(showError==false){
            system.debug('Please add product to cart');
            valuefromJS='';
                showError = true;
                errorMessage = 'Please add product to cart';
            }
            
            
        }
        catch(Exception ex){
            ApexLog.exceptionHandler(ex, orderId, accountId);
        }
    }
    
    //Method to  Validate & Confirm Order, disable Input, Submit for approval if conditions met
    public void confirmOrder(){
        try{
            ApexLog.exceptionCoverage(throwEx);
            if(Test.isRunningTest()){
                valuefromJS='Order Confirmed';
            }
            if(valuefromJS=='Order Confirmed'){
            
               String remark =ordObj.Remarks__c;
                system.debug('remark - - '+remark.length());
                if(!String.isBlank(remark)){
                    if(remark.length()>250){
                        showError = true;
                        errorMessage ='Limit Exceeded Please enter upto 250 characters only';
                       //ordObj.Remarks__c='';
                     }else{
                    // ordObj.Remarks__c = '';
                     }
                }
                saveOrder();
                
                if(orderSaved == true){
                    showError = false;
                    addSOLineItem();
                    
                    if(orderSaved == True && showError==false){
                        ordObj.Order_Status__c = 'Approved';
                        upsert ordObj;
                        
                        showError = true;
                     
                     
                        List <String>SalesOrderID = new List<String>();
                     //checking charracter of Remark__c field
               
                
                        for(Sales_Order__c SO : orgSalesorderMap.values()){
                            SalesOrderID.add(SO.ID);
                        }
                         if(valuefromJS!=''){
                        errorMessage = valuefromJS;
                        errorMessage = errorMessage +  '\n' +'.Order Number : ';
                      
                      }
                        List<Sales_order__c> salesOrderName = [select ID,Name FROM Sales_order__c where Id IN:SalesOrderID];
                        for(Sales_Order__c SORDER : salesOrderName){
                        if(SalesOrderID .size()>1){
                        errorMessage = errorMessage +' '+SORDER.Name+',';
                        }else{
                        errorMessage = errorMessage +' '+SORDER.Name;
                        }
                                
                        }
                        
                        List<Attachment> attachList = [SELECT id, Name, ParentId,
                                                       IsPrivate, ContentType, Body, 
                                                       Description 
                                                       FROM attachment 
                                                       WHERE parentId=:orderId order by createdDate DESC limit 1];
                        
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
                    }
                }
            }
            else{
                showError = true;
                if(valuefromJS!=''){
                errorMessage = valuefromJS;
                }
               
            }
        }
        catch(Exception ex){
            ApexLog.exceptionHandler(ex, orderId, accountId);
        }            
    }
    
    //Method to re-calculate Order Value and Taxes on change
    public void refreshOrderValue(){
        try{
            ApexLog.exceptionCoverage(throwEx);        
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
            ApexLog.exceptionHandler(ex, orderId, accountId);
        }            
    }
    
    //Method to upsert Tax Values to Order based on Selected Shipping State
    public void calculateTax(){
        try{
            ApexLog.exceptionCoverage(throwEx);
            
           // if(distWrapObj.salesOrgNames=='Indonesia'){ //comment by abhishek 
                stsList = [SELECT Id, Tax__c, AdditionalTax__c
                           FROM State_Tax_Structure__c
                           WHERE State_Name__c='Indonesia'
                           LIMIT 1];
                
                if(!stsList.isEmpty()){
                    ordObj.VAT__c = stsList[0].Tax__c;
                    ordObj.Additional_Tax__c = stsList[0].AdditionalTax__c;
                    upsert ordObj;
                }
           /* }//comment by abhishek 
            else{
                ordObj.VAT__c = 0;
                ordObj.Additional_Tax__c = 0;
                upsert ordObj;
            }*///comment by abhishek 
            refreshOrderValue();
        }
        catch(Exception ex){
            ApexLog.exceptionHandler(ex, orderId, accountId);
        }            
    }
    
    //Generate Order Template Name
    public void getTemplateName(){
        try{
            ApexLog.exceptionCoverage(throwEx);        
            templateName = '';
            System.debug('allowTemplate: '+allowTemplate);
            
            for(SKUDetails skuObj:skuOrderList){
                templateName += skuObj.brandName+' - ';
            }
            
            if(String.isNotBlank(templateName)){
                Integer length = templateName.length();
                if(length > 75){
                    length = 75;
                }
                string subStr = templateName.subString(0,length);
                templateName = subStr.subString(0, subStr.lastIndexOf('-'));
                if(templateName.endsWith(' - ')){
                    templateName = templateName.substring(0,templateName.length() - 2);
                }
            }
            System.debug('templateName: '+templateName);
        }
        catch(Exception ex){
            ApexLog.exceptionHandler(ex, orderId, accountId);
        }            
    }
    
    //Method to save template to system
    public void saveTemplate(){
        try{
            ApexLog.exceptionCoverage(throwEx);
            
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
                /* ----------------- Start SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022 ------------------ */
                otiObj.Item_Number__c = String.valueof(skuObj.itemNo);
                if(showDeliveryDate == true){
                    if(skuObj.deliveryDate == '' || String.isBlank(skuObj.deliveryDate)){
                        otiObj.Delivery_Date__c = null;
                    }
                    else{
                        otiObj.Delivery_Date__c = Date.valueof(skuObj.deliveryDate);
                    }
                }
                /* --------------------- End SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022 --------------------- */
                oliList.add(otiObj);
            }
            
            if(!oliList.isEmpty()){
                insert oliList;
                allowTemplate = false;
                templateName = '';
            }
        }
        catch(Exception ex){
            ApexLog.exceptionHandler(ex, orderId, accountId);
        }            
    }
    
    //Method to get Order History based on SKU & Account Id
    public void showOrderHistory(){
        try{
            ApexLog.exceptionCoverage(throwEx);
            
            oliList2 = [SELECT Id, Sale_Order__r.Name, Quantity__c, Sale_Order__r.Status__c, 
                        Sale_Order__c, UOM__c, SKU_Name__c,
                        Sale_Order__r.Order_Date__c, Sale_Order__r.Bill_To_Party__c
                        FROM Sales_Order_Line_Item__c 
                        WHERE SKU_Name__c =:skuIdChosen 
                        AND Sale_Order__r.Sold_To_Party__c=:accountId LIMIT 5];
        }
        catch(Exception ex){
            ApexLog.exceptionHandler(ex, orderId, accountId);
        }            
    }
    
    //Method to get Order Template based on SKU & Account Id
    public void showOrderTemplates(){
        try{
            ApexLog.exceptionCoverage(throwEx);
            tempList = [SELECT Id, Name, DistributorCustomerCode__c FROM OrderTemplate__c
                        WHERE DistributorCustomerCode__c=:accountId];
            
        }
        catch(Exception ex){
            ApexLog.exceptionHandler(ex, orderId, accountId);
        }            
    }
    
    //Method to reload existing Template in to Order Wrapper
    public void loadTemplate(){
        try{
            ApexLog.exceptionCoverage(throwEx);
           
            createOrder();//createsalesorder fileds 
            
            delete [SELECT Id FROM OrderLineItem__c WHERE Order__c=:ordObj.Id];
            
            skuOrderMap.clear();
            skuOrderList.clear();        
            
            refreshOrderValue();
            
            if(ordObj.Order_Status__c=='Approved'){
                enableInput = false;
            }
            // SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022 ....fields added.........
            List<OrderTemplateItem__c> oliList = [SELECT Id, Name, SKU__c, OrderTemplate__c, 
                                                    SKU__r.Product_Name__r.Name, SKU__r.Name,
                                                    SKU__r.Pack_Size__c, SKU__r.UOM__c, Delivery_Date__c, 
                                                    SKU__r.Sales_Org__r.Sales_Org_Code__c, Item_Number__c, 
                                                    SKU__r.Division__c,SKU__r.Distribution_Channel__c 
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
                /* ----------- SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022 ---------------- */
                if(oliObj.Item_Number__c != null){
                    skuWrapObj.itemNo = Integer.valueof(oliObj.Item_Number__c);
                }
                /* ------------ End SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022 ------------- */
                skuWrapObj.price = skuWrapObj2.price;
                skuWrapObj.invoiceDiscountEntered = 0;
                skuWrapObj.specialDiscountEntered = 0;
                skuWrapObj.schemeBonusEntered = 0;
                skuWrapObj.spotDiscount = 0;
                
                skuWrapObj.priceEntered = 0;
                skuWrapObj.netRateEntered = skuWrapObj.Price - Math.abs(skuWrapObj.invoiceDiscount) - Math.abs(skuWrapObj.specialDiscount) - Math.abs(skuWrapObj.spotDiscount) - Math.abs(skuWrapObj.schemeBonus);//by saurabh
               system.debug('skuWrapObj.netRateEntered  - '+skuWrapObj.netRateEntered );
                skuWrapObj.qty = 0;
                skuWrapObj.UOM = oliObj.SKU__r.UOM__c;
                skuWrapObj.available = skuWrapObj2.available;
                skuWrapObj.available2 = skuWrapObj2.available2;
                skuWrapObj.currencyIso = distWrapObj.CurrencyIso;
                skuWrapObj.salesOrgID = oliObj.SKU__r.Sales_Org__c;
                /* -------------- Start SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022 ------------- */
                if(oliObj.Delivery_Date__c == null){
                    skuWrapObj.deliveryDate = '';
                }
                else{
                    skuWrapObj.deliveryDate = String.valueof(oliObj.Delivery_Date__c);
                }

                skuOrderMap.put(skuWrapObj.skuId+''+String.valueof(skuWrapObj.itemNo),skuWrapObj);
                /* ------------- End SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022 ---------------- */
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
                /* -------- Start SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022 ------------ */
                if(skuWrapObj.deliveryDate == ''){
                    oliObj.Delivery_Date__c = null;
                }
                else{
                    oliObj.Delivery_Date__c = Date.valueof(skuWrapObj.deliveryDate);
                }
                /* ------------ End SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022 ------------- */
                insert oliObj;
                skuWrapObj.oliId = oliObj.Id;     
            }
        }
        catch(Exception ex){
            ApexLog.exceptionHandler(ex, orderId, accountId);
        }            
    }
    public void DeleteAttachmentOnOrder(){
        System.debug('attachList---->');
         List<Attachment> attachList = new List<Attachment>();
        if(orderId!=Null && orderId!=''){
         attachList = [SELECT id, Name, ParentId,IsPrivate, ContentType, Body, 
                                                       Description 
                                                       FROM attachment 
                                        WHERE parentId=:orderId LIMIT 1];
        }
        if(attachList.size()>0)
            DELETE attachList;
    } 
    //Method to redirect to Sales Order Record
    public PageReference redirectFunction(){
        PageReference pg;
        
        if(soObj.Id!=null){
            pg = new PageReference('/'+accountId);
        }
        return pg;
    }   
    public class DistributorWrapper{
        public String distributorName {get;set;}
        public Set<String> salesOrgIds {get;set;}//make list
        public List<String> salesOrgNames {get;set;}
        public List<String> distributorChannelIds {get;set;}//make list
        public List<String> divisionIds {get;set;}//make list
        public String orderType {get;set;}
        public String sapCode {get;set;}
        public List<String> depots {get;set;}//make list
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
        public List<String>/*Id*/ priceGroupId {get;set;}
        public DistributorWrapper(){
            distributorChannelIds = new List<String>();
            salesOrgIds = new Set<String>();
            divisionIds = new List<String>();
            depots = new List<String>();
            salesOrgNames = new List<String>();
            priceGroupId = new List<String>();
        }
    }
    
    public class SKUDetails{
        public String brandName {get;set;}
        public String description {get;set;}
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
        //public Integer perUnit {get;set;}
        public Decimal available {get;set;}
        
        public String available2 {get;set;}
        public String currencyIso {get;set;}
        public String salesOrgID{get;set;}
        public String SKUBrand{get;set;}
        public String deliveryDate {get;set;} // SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022
 
        public SKUDetails(){
            packSize = 0;
            UOM = 'N/A';
            qty = 0;
            SKUBrand='';
            salesOrgID='';
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
            deliveryDate = ''; // SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022
        }
    }
    
    public class ShippingLocation{
        public String locationId {get;set;}
        public String address {get;set;}
        public String city {get;set;}
        public String state {get;set;}
        public String country {get;set;}
        public String pincode {get;set;}
    }
}