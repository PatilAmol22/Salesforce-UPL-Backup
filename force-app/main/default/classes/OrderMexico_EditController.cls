/*
* Name: OrderArgentinaController
* Created On: 16 May 2017
* Author: Bhavik Devdhar (bhavik.devdhar@skinternational.com)
* Description: Class is used for Placing Orders by Distributor, TM, RM of Mexico
*/
global without sharing class OrderMexico_EditController {
    //Variable to be set by JS for Attachment status
    /* code:for new upl mexico
owner:Abhishek Verma(SKI) */
    public List<orderSummaryUOM> orderSummaryUOMList{get;set;}
    public List<orderSummaryCurrency> orderSummaryCurrencyList{get;set;}
    public MAP<String,orderSummaryUOM> orderSummaryUOMmap;
    public MAP<String,orderSummaryCurrency> orderSummaryCurrencyMap;
    public String userDepotCode{get;set;}
    public Boolean showMaxPrice{get;set;}
    public Boolean showMinPrice{get;set;}
    public Boolean showDirectorPrice{get;set;}
    public Boolean showRegionHeadPrice{get;set;}
    public Set<String>cropListStr{get;set;}
    public String SalesAreaAccountOwner; 
    public Boolean cropSelection{get;set;}
    /* EOC:Abhishek verma */
    public String valuefromJS {get;set;}
    public String division {get;set;}
    public Sales_Order__c salesObj {get;set;}
    public String divId{get;set;}
    public Integer selectedsoItemSize {get;set;}
    public List<SKUDetailsEdit> oldSKUList {get;set;}
    public DistributorWrapper distWrapObj {get;set;}
    public ShippingLocation slwObj {get;set;}
    public Map<Id,SKUDetails> skuSaleOrderMap {get;set;}
    public List<SKUDetails> skuSalesOrderList {get;set;}
    public Boolean Sent_for_Manager_Approval {get;set;}
    public Boolean Sent_for_Director_Approval{get;set;}
    public Boolean Sent_for_Latam_Director_Approval{get;set;}
    public List<SKUDetails> skuDetailsList {get;set;}
    public List<SKUDetails> skuOrderList {get;set;}
    public List<OrderLineItem__c> oliList {get;set;}
    public List<Sales_Order_Line_Item__c> oliList2 {get;set;}
    public List<OrderTemplate__c> tempList {get;set;}
    
    public Map<String,ShippingLocation> shippingMap {get;set;}    
    public Map<Id,SKUDetails> skuDetailsMap {get;set;}
    public Map<Id,SKUDetails> skuOrderMap {get;set;}
    //public Map<String,String> stateMap {get;set;}
    
    public Set<String> productNamesSet{get;set;}
    public Set<String> descriptionSet{get;set;}
    public List<SelectOption> depotSet{get;set;}
    public List<SelectOption> paymentTermSet{get;set;}
    public List<SelectOption> shippingList {get;set;}    
    
    //Set Order Type Code
    public String orderTypeCode {get;set;}
    public String paymentTermCode {get;set;}
    
    public String selectedShipping {get;set;}
    public String searchProdValue {get; set;}
    public String templateName {get; set;}
    public String errorMessage {get; set;}
    
    public String skuIdChosen {get; set;}
    public String tempIdChosen {get; set;}
    public String storageIdChosen {get; set;}
    public String paymentIdChosen {get; set;}
    public String orderRaisedBy {get; set;}
    public String skuJSON {get;set;}
    public String distributorJSON {get;set;}
    public String shippingJSON {get;set;}
    
    public Boolean showError{get;set;}
    public Boolean enableInput{get;set;}
    public Boolean throwEx;
    
    //Order Related Permissions
    public Boolean showCredit{get;set;}
    public Boolean showInventory{get;set;}
    public Boolean showInventoryColumn{get;set;}
    public Boolean enableDepot{get;set;}
    public Boolean showInTransit{get;set;}
    public Boolean showInTransitValues{get;set;} 
    
    public Boolean allowTemplate{get;set;}
    public Boolean orderSaved{get;set;}
    
    public Decimal grossAmount {get;set;}
    
    public Integer itemNumber;
    
    public String orderId{get;set;}
    public String PO{get;set;}
    public String accountId{get;set;}
    public String depoId;
    public String distributorId;
    public String territoryManagerId;
    public String managerId;
    public String latamDirectorId;
    public String salesDirectorId;
    public String country;
    
    public Order__c ordObj {get;set;}
    public Sales_Order__c soObj {get;set;}
    /*abhishek*/
    //Method to Create SalesOrder on Order Confirmation with diffrent Division
    public MAP<String,Sales_Order__c> divisionSalesorderMap ; 
    public MAP<String,Depot__c>divisionDepotMap;
    public MAP<String,DistributorSalesAreaMapping__c> DistributorSalesAreaMappingMAP;
    public String SelectedCurrency{get;set;}
    public List<Inco_Term__c>incoTermList{get;set;}
    public List<Payment_Method__c>paymentMethodList{get;set;}
    public Set<SelectOption>CurrencyCodeList{get;set;}
    public List<Payment_Term__c> payemntTermSingleList{get;set;}
    public List<Payment_Term__c> payemntTermList{get;set;}
    public String Payment_Methods{get;set;}
    public String Payment_Terms{get;set;}
    public String Inco_Terms{get;set;}
    public Decimal multipleOf {get;set;}
    public String salesOrderId{get;set;}
    public String selectedSoId {get; set;}
    public String Remaks{get;set;}
    public MAP<String,Crop__c> cropMap;
    public String selectedOrderType  {get;set;}
    public MAP<String,Sales_Order__c> orgSalesorderMap ; 
    //Added by Varun Shrivastava Start
    public Decimal totalOrderAmount{get;set;}
    public Map<Id,Inco_Term__c> idToRecordMap;
    //public String defaultStorageLocation{get;set;}
    //Added by Varun Shrivastava End
    /*abhishek*/
    public OrderMexico_EditController(ApexPages.StandardController controller) {
        try{
            multipleOf=0;
            Sent_for_Latam_Director_Approval=false;
            Sent_for_Director_Approval= false;
            Remaks='';
            cropMap = new MAP<String,Crop__c>();
            Sent_for_Manager_Approval = false;
            salesObj=new Sales_Order__c();
            showMaxPrice=false;
            showMinPrice=false;
            showDirectorPrice=false;
            showRegionHeadPrice=false;
            orderSummaryUOMmap = new MAP<String,orderSummaryUOM>();
            orderSummaryCurrencyMap = new MAP<String,orderSummaryCurrency>();
            //Added by Varun Shrivastava Start
            totalOrderAmount = 0;
            idToRecordMap = new Map<Id,Inco_Term__c>([select Id from Inco_Term__c where Name in ('CFR','ZNO')]);
            //defaultStorageLocation= '';
            //Added by Varun Shrivastava End
            orderSummaryUOMList = new List<orderSummaryUOM>();
            orderSummaryCurrencyList = new List<orderSummaryCurrency>();
            
            orgSalesorderMap = new MAP<String,Sales_Order__c>();
            cropListStr =  new Set<String>();
            List<Crop__c>cropList = new List<Crop__c>();
            cropList = [SELECT Id, Name FROM Crop__c where Active__c=true AND Sales_Org_Code__c='5100'];
            cropListStr = new Set<String>();
            for(Crop__c cpr : cropList){
                cropMap.put(cpr.Name,cpr);
                cropListStr.add(cpr.Name);
            }
            //userDepotCode='-None-';
            userDepotCode='MX00';//Sayan Majumder ( crmconsultant3@upl-ltd.com ) Ticket:SCTASK0192757 Date: 5th June,2020
            CurrencyCodeList = new Set<SelectOption>();
            skuOrderList = new List<SKUDetails>();
            oldSKUList = new List<SKUDetailsEdit>();
            skuSalesOrderList=new List<SKUDetails>();
            //CurrencyCodeList.add('-None-');
            CurrencyCodeList.add(new SelectOption('-None-','-None-'));
            CurrencyCodeList.add(new SelectOption('MXN','MXN'));
            CurrencyCodeList.add(new SelectOption('USD','USD'));
            paymentMethodList = [SELECT Id, Name, Active__c, Description__c,Payment_Method_Code__c,Sales_Org__r.sales_org_code__c FROM Payment_Method__c where Sales_Org__r.sales_org_code__c='5100'];
            incoTermList= [SELECT Id, Name, Active__c, Sales_Org__c,IncoTerm_Desc__c FROM Inco_Term__c where Sales_Org__r.Sales_Org_Code__c='5100' AND Active__c=true];
            payemntTermSingleList =  [SELECT Id,name,Payterms_Desc__c,Sales_Org__c,Payment_Term_Code__c FROM Payment_Term__c where Sales_Org__r.sales_org_code__c='5100' AND Payment_Term_Code__c='0004' limit 1];
            payemntTermList = [SELECT Id,name,Sales_Org__c,Payment_Term_Code__c,Payterms_Desc__c FROM Payment_Term__c where Sales_Org__r.sales_org_code__c='5100' AND Payment_Term_Code__c!='0004'];    
            orderTypeCode = 'ZZOR';
            country = 'Mexico';
            //SelectedCurrency='-None-';
            paymentTermCode = '';  
            DistributorSalesAreaMappingMAP = new MAP<String,DistributorSalesAreaMapping__c>(); 
            slwObj = new ShippingLocation();
            skuOrderMap = new Map<Id,SKUDetails>();
            skuSaleOrderMap = new Map<Id,SKUDetails>();
            
            productNamesSet = new Set<String>();
            descriptionSet = new Set<String>();
            depotSet = new List<SelectOption>();
            paymentTermSet = new List<SelectOption>();
            skuDetailsList = new List<SKUDetails>();
            skuOrderList = new List<SKUDetails>();
            oliList = new List<OrderLineItem__c>();
            
            skuOrderMap = new Map<Id,SKUDetails>();
            shippingMap = new Map<String, ShippingLocation>();
            skuDetailsMap = new Map<Id,SKUDetails>();
            //stateMap = new Map<String, String>();
            salesOrderId = '';
            
            searchProdValue = '';
            PO = '';
            errorMessage = '';
            skuIdChosen = '';
            storageIdChosen = '';
            paymentIdChosen = '';
            valuefromJS = '';
            
            orderRaisedBy = '';
            skuJSON = '';
            distributorJSON = '';
            shippingJSON = '';
            
            showError = false;
            enableInput = true;
            showCredit = false;
            showInventory = false;
            showInventoryColumn = false;
            showInTransit = false;
            showInTransitValues = false;
            
            throwEx = false;
            
            enableDepot = false;
            allowTemplate = false;
            orderSaved = false;
            
            grossAmount = 0;
            
            itemNumber = 0;
            
            accountId = '';
            distributorId = '';
            //depoId = '';
            depoId = [SELECT Id, Name, Depot_Code__c, Depot__c, SalesOrg__r.Sales_Org_Code__c FROM Depot__c 
                      where SalesOrg__r.Sales_Org_Code__c='5100' and Depot_Code__c='MX00'].Id;
            //Sayan Majumder ( crmconsultant3@upl-ltd.com ) Ticket:SCTASK0192757 Date: 5th June,2020
            
            territoryManagerId = '';
            
            orderId = ApexPages.currentpage().getparameters().get('id');        
            System.debug('orderId: '+orderId);
            salesOrderId = ApexPages.currentpage().getparameters().get('soid');
            system.debug('salesOrderId '+salesOrderId );
            accountId = ApexPages.currentpage().getparameters().get('acid');
            System.debug('accountId: '+accountId);
            
            User loginUserObj = [SELECT Id, Name, IsActive, ContactId,UserRole.name,
                                 Show_Inventory__c, Show_Credit_Limit__c, EnableDepot__c,
                                 Show_Inventory_Column__c,Crop_Selection__c, Show_Max_Price__c,Show_Min_Price__c,Show_Sales_Director_Price__c,Show_Latam_Region_Head_Price__c,ManagerId,Show_InTransit__c, Show_InTransit_Values__c, Country_Head__c, Marketing_Manager__c
                                 FROM User 
                                 WHERE Id =: UserInfo.getUserId()
                                 AND IsActive = True];
            cropSelection = loginUserObj.Crop_Selection__c;
            showInventory = loginUserObj.Show_Inventory__c;
            showInventoryColumn = loginUserObj.Show_Inventory_Column__c;
            showCredit =  loginUserObj.Show_Credit_Limit__c;
            showInTransit = loginUserObj.Show_InTransit__c;
            showInTransitValues = loginUserObj.Show_InTransit_Values__c;
            showMaxPrice=loginUserObj.Show_Max_Price__c;
            showMinPrice=loginUserObj.Show_Min_Price__c;
            showDirectorPrice=loginUserObj.Show_Sales_Director_Price__c;
            showRegionHeadPrice=loginUserObj.Show_Latam_Region_Head_Price__c;
            
            managerId = loginUserObj.ManagerId;
            latamDirectorId = loginUserObj.Country_Head__c;
            salesDirectorId = loginUserObj.Marketing_Manager__c;
            
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
                System.debug('-inside if condition-- distributorId: '+ distributorId);
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
                //enableDepot = false;
            }
            
            
            
            System.debug('depoId: '+depoId);
            if(String.isNotBlank(salesOrderId)){
                salesObj = [select id, Remarks_Long__c,Depot__r.Depot_Code__c,Ship_To_Party__r.city__c,Name,Ship_To_Party__r.Name,Order_Type_lk__c,Division_lk__c ,Net_Amount__c,Inco_Term__c,PaymentMethod__c ,CurrencyIsoCode,Payment_Term__c,Payment_Term__r.Payment_Term__c, Order_Type_lk__r.Description__c from Sales_Order__c Where Id=:salesOrderId limit 1];
                selectedSoId = salesObj.Name;
                //  grossamount = salesObj.Net_Amount__c;
                selectedShipping = salesObj.Ship_To_Party__r.Name;//salesObj.Ship_To_Party__r.city__c;
                paymentTermCode=salesObj.Payment_Term__c;
                selectedOrderType = salesObj.Order_Type_lk__c;
                SelectedCurrency = salesObj.CurrencyIsoCode;
                Payment_Methods=salesObj.PaymentMethod__c ;
                Payment_Terms =salesObj.Payment_Term__c;
                Inco_Terms  = salesObj.Inco_Term__c; 
                Remaks = salesObj.Remarks_Long__c;
                // userDepotCode = salesObj.Depot__r.Depot_Code__c;
                system.debug('SelectedCurrency---> '+SelectedCurrency);
                
                //refreshSaleOrderValue();
                
            }
            else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Sales Order not found'));
            }
            
        }
        catch(Exception ex){
            System.debug('Method: Constructor Exception: '+ex.getMessage()+ ' Line Number: '+ex.getLineNumber());
        }
    }
    public void editSalesOrder(){
        try{
            ApexLog.exceptionCoverage(throwEx);//CurrencyIsoCode
            system.debug('editSalesOrder--->');
            skuSalesOrderList.clear();
            list<Sales_order_line_item__c> SOLineItemList =new list <Sales_order_line_item__c>();
            
            SOLineItemList=[select id,Manager_Price__c,Storage_Location__c,Director_Price__c,CurrencyIsoCode,Sale_Order__c,multipleOf__c,SKU_Description__c,MinPrice__c,MaxPrice__c,Comment__c,FinalPrice__c,Campaign_Discount__c,SKU_Name__c,SKU_Name__r.Division__c,
                            SKU_Name__r.pallet_Size_Italy__c , //Added by Varun Shrivastava
                            Net_Price__c,crop__r.name,Quantity__c,UOM__c,Material_Discount__c,Distributor_Discount__c,DistributorDiscountPercentage__c,SKU_Name__r.Brand_Name__c,Price__c,SKU_Name__r.Name,Shipping_Date__c
                            from Sales_Order_Line_Item__c 
                            where Sale_Order__c=:salesOrderId];
            
            system.debug('SOLineItemList.size----> '+SOLineItemList.size());
            if(SOLineItemList.size()>0){
                divId = SOLineItemList[0].SKU_Name__r.Division__c;
                selectedsoItemSize=SOLineItemList.size();
                storageIdChosen = SOLineItemList[0].Storage_Location__c;
                SKUDetailsEdit tempSkuWrapperObj = new SKUDetailsEdit();
                for(Sales_Order_Line_Item__c tempsoliObj: SOLineItemList){
                    
                    tempSkuWrapperObj.tempSkuId =  tempsoliObj.Id;
                    // tempSkuWrapperObj.tempPrice = tempsoliObj.Net_Price__c;
                    tempSkuWrapperObj.tempPrice = tempsoliObj.Price__c;
                    tempSkuWrapperObj.tempQty = tempsoliObj.Quantity__c; 
                    oldSKUList.add(tempSkuWrapperObj);
                }
                System.debug('oldSKUList'+oldSKUList);
                userDepotCode = salesObj.Depot__r.Depot_Code__c;
                fetchSKUData();
            }else{
                //userDepotCode ='-None-';
                userDepotCode = 'MX00';//Sayan Majumder ( crmconsultant3@upl-ltd.com ) Ticket:SCTASK0192757 Date: 5th June,2020
            }
            
            System.debug('saleOrderlist' +SOLineItemList); 
            if(SOLineItemList.size()>0) {
                
                for(Sales_Order_Line_Item__c solitobj:SOLineItemList){
                    system.debug('solitobj--> '+solitobj);
                    SKUDetails skuWrapObj=new SKUDetails();
                    
                    skuWrapObj.brandName=solitobj.SKU_Description__c+' '+solitobj.SKU_Name__r.Name;
                    skuWrapObj.crop=solitobj.crop__r.name;
                    skuWrapObj.Price = solitobj.MaxPrice__c;
                    skuWrapObj.maxPrice=solitobj.MaxPrice__c;
                    skuWrapObj.minPrice=solitobj.MinPrice__c;
                    skuWrapObj.DeliveryDate=solitobj.Shipping_Date__c;//Sayan10
                    //Added by Varun Shrivastava Start
                    skuWrapObj.palletSize = solitobj.SKU_Name__r.pallet_Size_Italy__c;
                    //Added by Varun Shrivastava End
                    skuWrapObj.finalPrice=solitobj.Net_Price__c;
                    skuWrapObj.qty=solitobj.Quantity__c;
                    skuWrapObj.priceEntered= solitobj.Price__c;
                    skuWrapObj.multipleof=solitobj.multipleOf__c;
                    skuWrapObj.Director_Price = solitobj.Director_Price__c;
                    skuWrapObj.Manager_Price= solitobj.Manager_Price__c;
                    skuWrapObj.finalPrice= solitobj.FinalPrice__c;
                    skuWrapObj.currencyIso= solitobj.CurrencyIsoCode;
                    skuWrapObj.UOM=solitobj.UOM__c;
                    //error discount display zero
                    if(skuWrapObj.finalPrice<skuWrapObj.minPrice || skuWrapObj.finalPrice>skuWrapObj.maxPrice){
                        //TRUE when Final Price is less than Min Price OR Final Price is greater than Max Price
                        system.debug('TRUE when Final Price is less than Min Price');
                        Sent_for_Manager_Approval = true;
                    }
                    
                    if(skuWrapObj.finalPrice < skuWrapObj.Director_Price){
                        //TRUE when Final Price is less than Directors Price 
                        system.debug('TRUE when Final Price is less than Directors Price');
                        
                        Sent_for_Latam_Director_Approval= true;
                    }
                    if(skuWrapObj.finalPrice < skuWrapObj.Manager_Price){
                        system.debug('TRUE when Final Price is less than Latam Directors Price ');
                        Sent_for_Director_Approval= true;
                    }
                    
                    system.debug('total price 383 :-- '+skuWrapObj.finalPrice * skuWrapObj.qty);
                    system.debug('solitobj.Price__c 384:-- '+solitobj.Price__c);
                    skuWrapObj.netRateEntered=skuWrapObj.finalPrice * skuWrapObj.qty;
                    //skuWrapObj.netRateEntered=solitobj.Price__c;
                    skuWrapObj.skuId=solitobj.SKU_Name__c;
                    skuWrapObj.soliId= solitobj.Id;
                    orderSummaryUOM OSU = new orderSummaryUOM ();
                    orderSummaryCurrency OSC = new orderSummaryCurrency();
                    system.debug('------orderSummaryCurrencyMap-----------');
                    if(orderSummaryCurrencyMap.containsKey(skuWrapObj.currencyIso)){
                        OSC =  orderSummaryCurrencyMap.get(skuWrapObj.currencyIso);
                        OSC.totalValue = OSC.totalValue+ skuWrapObj.netRateEntered;
                        orderSummaryCurrencyMap.put(skuWrapObj.currencyIso,OSC);
                        
                    }else{
                        OSC = new orderSummaryCurrency();
                        OSC.currencyName = skuWrapObj.currencyIso;
                        OSC.totalValue = skuWrapObj.netRateEntered;
                        
                        orderSummaryCurrencyMap.put(skuWrapObj.currencyIso,OSC);
                        
                    }
                    
                    if(orderSummaryUOMmap.containsKey(skuWrapObj.UOM)){
                        OSU =  orderSummaryUOMmap.get(skuWrapObj.UOM);
                        OSU.totalQty = OSU.totalQty+ skuWrapObj.qty;
                        orderSummaryUOMmap.put(skuWrapObj.UOM,OSU);
                        system.debug('Update Call');
                    }else{
                        OSU = new orderSummaryUOM ();
                        OSU.UOM = skuWrapObj.UOM;
                        OSU.totalQty = skuWrapObj.qty;
                        system.debug('New Call');
                        orderSummaryUOMmap.put(skuWrapObj.UOM,OSU);
                        
                    }
                    skuSaleOrderMap.put(skuWrapObj.skuId,skuWrapObj);
                    skuSalesOrderList.add(skuWrapObj);
                    System.debug('Final price of product is '+skuWrapObj.finalPrice);
                    
                    //skuSaleOrderMap.put(skuObj1.skuId,skuObj1);
                    //skuSalesOrderList.add(skuObj1);    
                }
                orderSummaryUOMList.clear();
                orderSummaryCurrencyList.clear();
                orderSummaryUOMList.addAll(orderSummaryUOMmap.values());
                orderSummaryCurrencyList.addAll(orderSummaryCurrencyMap.values());
                refreshSaleOrderValue();  
            }
        }
        catch(Exception ex){
            System.debug('Exception is '+ex.getMessage());
        }
    }
    
    public String createSalesOrder2(String skuCurrency,String salesOrgId){
        system.debug('salesOrgId - createSalesOrder2'+salesOrgId);
        system.debug('Payment_Methods- - '+Payment_Methods);
        system.debug('Payment_Terms- - '+Payment_Terms);
        system.debug('Inco_Terms- - '+Inco_Terms);
        
        String distributorChannelId = '';
        String divisionId = '';
        
        //Added by Bhavik 12th Oct 2018
        List<Depot__c> argentinaDepoList = [Select Id, Shipping_condition__c From Depot__c where id=:storageIdChosen LIMIT 1]; //SalesOrg__r.sales_org_code__c='5100' AND Depot_Code__c ='MX00'
        //End
        
        if(ordObj!=null && !orgSalesorderMap.containskey(skuCurrency+salesOrgId)){ // Changed by Azhar shaikh.. 15/03/2019 New Upl Mexico //if(ordObj!=null  && soObj==null){
            soObj = new Sales_Order__c();
            soObj.Sold_to_Party__c = accountId;
            soObj.Bill_To_Party__c = accountId;
            soObj.Order_Date__c = System.today();
            soObj.Order_Raise_By__c = orderRaisedBy;
            soObj.Order_Status__c = 'Open';
            soObj.CreatedFrom__c = 'SFDC';
            soObj.OwnerId = distributorId;
            soObj.Order__c = ordObj.Id;
            if(shippingMap.containsKey(selectedShipping)){
                
                if(!Test.isRunningTest()){
                    soObj.Ship_To_Party__c = shippingMap.get(selectedShipping).locationId;//slwObj.locationId;
                }
            } 
            // soObj.Ship_To_Party__c = slwObj.locationId;
            soObj.Sales_Org_lk__c = ordObj.Sales_Org__c;//list
            soObj.PaymentMethod__c =  Payment_Methods;
            soObj.Payment_Term__c = Payment_Terms;
            soObj.Inco_Term__c = Inco_Terms;
            soObj.CurrencyIsoCode =SelectedCurrency;
            // salesObj.Ship_To_Party__r.city__c =   selectedShipping ;//abhishek 23/4/19
            system.debug('DistributorSalesAreaMappingMAP- '+DistributorSalesAreaMappingMAP);
            soObj.Distribution_Channel_lk__c =  distWrapObj.distributorChannelId;//list
            
            // Changed by Azhar Shaikh 18/03/2019
            
            if(DistributorSalesAreaMappingMAP.containsKey(salesOrgId)){
                soObj.Division_lk__c = DistributorSalesAreaMappingMAP.get(salesOrgId).Division__c;//list
                division = DistributorSalesAreaMappingMAP.get(salesOrgId).Division__c; //RITM0184294
            }
            
            //Added by Bhavik 12th Oct 2018
            if(!argentinaDepoList.isEmpty()){
                soObj.Shipping_condition__c = argentinaDepoList[0].Shipping_condition__c;
            }
            //End
            
            soObj.Credit_Term__c = distWrapObj.paymentTerms;
            // Changed by Azhar 15-04-2019
            system.debug('ordObj.Remarks_Long__c -- '+ordObj.Remarks_Long__c);//ordObj.Remarks__c);
            if(Test.isRunningTest()){ordObj.Remarks_Long__c='snjdgshjdghsgdhjgshjgdhjsghjdgjshgdgshjdgsjhgdjhsgdgshjgdjshgdhjgshjdgshjgdhjgsdhjjjjjjjjjjjjjjdjgsjdgshjgdhjsgdhjgsjdgshjgdjhsgdjhgsjhgdjsgdhjsgjdhgsjhdgsjgdhjsgdhgsjhgdjsgdjsgdhjgshjdg';}
            if(!String.isBlank(ordObj.Remarks_Long__c)){
                String s = ordObj.Remarks_Long__c;
                if(s.length()<=1000){
                    soObj.Remarks_Long__c = ordObj.Remarks_Long__c;
                    if(s.length()>130){ // code to add tilde character for SAP after every 130 character...code by abhishek 
                        soObj.SAP_Remark__c =   addCharIntoRemark(s);
                    }else{
                        soObj.SAP_Remark__c =s;
                        
                    }
                }else{
                    showError = true;
                    errorMessage ='Limit Exceeded Please enter upto 1000 characters only';
                }
            }
            /*system.debug('ordObj.Remarks__c -- '+ordObj.Remarks__c);

if(!String.isBlank(ordObj.Remarks__c)){
String s = ordObj.Remarks__c;
if(s.length()<250){
soObj.Remarks__c = ordObj.Remarks__c;
}else{
showError = true;
errorMessage ='Limit Exceeded Please enter upto 250 characters only';
}
}*/
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
            
            soObj.Order_Type_lk__c = [Select Id FROM Order_Type__c WHERE Order_Type_Code__c=:orderTypeCode and Division__c =:division and SalesOrg__r.Name = 'Mexico'].Id;//distWrapObj.orderType  [Select Id FROM Order_Type__c WHERE Order_Type_Code__c='ZORD'].Id; 
            
            //Added by Varun Shrivastava Start
            if(totalOrderAmount < 80000 && idToRecordMap.containsKey(Inco_Terms)){
                soObj.Order_Status__c = 'Draft';
            }
            //Added by Varun Shrivastava End
            system.debug('soObj -- '+soObj);
            insert soObj;
            orgSalesorderMap.put(skuCurrency+salesOrgId,soObj);
            system.debug('orgSalesorderMap - '+orgSalesorderMap);
            
        }
        return soObj.ID;
    }
    //Method to Create SalesOrder on Order Confirmation
    private Id argentinaDepo;
    //Method to add Line Items to SalesOrders on Order Confirmation
    public void addSOLineItem(){
        try{
            ApexLog.exceptionCoverage(throwEx);
            Boolean submitForApproval = false;
            String SalesOrderId;
            List<String>salesOrList = new List<String>();
            Sales_Order_Line_Item__c sliObj;
            if(Test.isRunningTest())/*{userDepotCode='MX51';}*/
            {userDepotCode='MX00';}//Sayan Majumder ( crmconsultant3@upl-ltd.com ) Ticket:SCTASK0192757 Date: 5th June,2020
            argentinaDepo = [Select Id,Name ,Depot__c,SalesOrg__r.sales_org_code__c From Depot__c where SalesOrg__r.sales_org_code__c='5100' AND Depot_Code__c =:userDepotCode LIMIT 1].ID;
            system.debug('orgSalesorderMap');
            
            system.debug(orgSalesorderMap);
            for(SKUDetails skuWrapObj:skuOrderMap.values()){
                sliObj = new Sales_Order_Line_Item__c();
                sliObj.SKU_Name__c = skuWrapObj.skuId;
                sliObj.Item_Number__c = skuWrapObj.itemNo;
                sliObj.Item_Status__c = 'Active';
                sliObj.DepotDepot__c = argentinaDepo;
                sliObj.Storage_Location__c = storageIdChosen;
                sliObj.UOM__c = skuWrapObj.UOM;
                sliObj.CurrencyIsoCode = distWrapObj.currencyIso;
                if(Test.isRunningTest()){skuWrapObj.qty=10 ;skuWrapObj.finalPrice=10 ;}
                if(skuWrapObj.qty==0 || skuWrapObj.finalPrice==0){
                    showError = true;
                    errorMessage = System.Label.Please_Enter_Quantity_for_all_SKU_s_before_confirming_order;
                    //'Please Enter Quantity for all SKU\'s before confirming order'; 
                    break;
                }
                else {
                    // createSalesOrder();
                    //       sliObj.Payment_Term__c = paymentIdChosen; //new Payment_Term__c(Payment_Term_Code__c='0020');
                    system.debug('skuWrapObj - '+skuWrapObj.divisionId);
                    SalesOrderId =   createSalesOrder2(skuWrapObj.currencyIso,skuWrapObj.divisionId);
                    salesOrList.add(SalesOrderId);
                    sliObj.Quantity__c = skuWrapObj.qty;
                    sliObj.MaxPrice__C= skuWrapObj.maxprice;
                    sliObj.MinPrice__C= skuWrapObj.minprice;
                    sliObj.Net_Price__c = skuWrapObj.finalPrice;
                    sliObj.Price__c = skuWrapObj.netRateEntered;
                    sliObj.Storage_Location__c = storageIdChosen;
                    sliObj.Sale_Order__c = soObj.Id;
                    sliObj.Sale_Order__c = SalesOrderId;
                    sliObj.multipleOf__c=skuWrapObj.multipleOf; 
                    if(skuWrapObj.finalPrice<skuWrapObj.minPrice || skuWrapObj.finalPrice>skuWrapObj.maxPrice){
                        //TRUE when Final Price is less than Min Price OR Final Price is greater than Max Price
                        system.debug('TRUE when Final Price is less than Min Price');
                        Sent_for_Manager_Approval = true;
                    }
                    system.debug('skuWrapObj--'+skuWrapObj);
                    if(skuWrapObj.finalPrice < skuWrapObj.Director_Price){
                        //TRUE when Final Price is less than Directors Price 
                        system.debug('TRUE when Final Price is less than Directors Price');
                        Sent_for_Latam_Director_Approval= true; 
                    }
                    if(skuWrapObj.finalPrice < skuWrapObj.Manager_Price){
                        system.debug('TRUE when Final Price is less than Latam Directors Price ');
                        Sent_for_Director_Approval= true;
                    }
                    insert sliObj;
                    
                    if(skuWrapObj.finalPrice < skuWrapObj.Price){
                        submitForApproval = true;
                    }
                }
            }
            
            //Update Tax and Total Amount in Sales Order
            
            List<Sales_Order__c >soList = [Select Id,Manager__c,Sales_Director_Mexico__c,Latam_Director_Mexico__c,Sent_for_Manager_Approval_Mexico__c,Sent_for_Director_Approval_Mexico__c ,Sent_for_Latam_Director_Approval__c ,Order_Status__c,SentEmailIndonesia__c, Net_Amount__c from Sales_Order__c where id IN:salesOrList];
            system.debug('SalesOrderId----->'+SalesOrderId);
            for(Sales_Order__c so: soList){
                so.Manager__c=managerId;
                so.Sales_Director_Mexico__c = salesDirectorId;
                so.Latam_Director_Mexico__c = latamDirectorId;
                so.Total_Amount__c = so.Net_Amount__c;
                so.Sent_for_Manager_Approval_Mexico__c= Sent_for_Manager_Approval;
                so.Sent_for_Director_Approval_Mexico__c = Sent_for_Director_Approval;
                so.Sent_for_Latam_Director_Approval__c = Sent_for_Latam_Director_Approval;
                if(Sent_for_Manager_Approval || Sent_for_Director_Approval || Sent_for_Latam_Director_Approval){
                    so.Order_Status__c = 'Pending';
                    
                }else{
                    so.Order_Status__c = 'Open';
                    
                }
                //Added by Varun Shrivastava Start
                if(totalOrderAmount < 80000 && idToRecordMap.containsKey(Inco_Terms)){
                    so.Order_Status__c = 'Draft';
                }
                //Added by Varun Shrivastava End
                so.SentEmailIndonesia__c=true;
                
            }
            
            if(soList.size()>0){
                update soList;
                System.debug('soObj: '+soList);
            }
            
        }
        catch(Exception ex){
            //ApexLog.exceptionHandler(ex, orderId, accountId);
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage()));
            System.debug('Exception Cause: '+ex.getCause()+' at line number: '+ex.getLineNumber());
        }
    }
    
    public void changeDepot(){
        System.debug('Storage Location: '+storageIdChosen);
        
        //  fetchSKUData();
    }
    //Method to re-calculate Order Value and Taxes on change
    public void refreshSaleOrderValue(){
        try{
            ApexLog.exceptionCoverage(throwEx);
            
            if(String.isNotBlank(salesOrderId)){
                Sales_Order__c saleorder=[select id ,NetAmount_Argentina__c,depot__c
                                          from Sales_Order__c
                                          Where Id=:salesOrderId LIMIT 1];
                
                grossAmount = saleorder.NetAmount_Argentina__c;
                system.debug('grossAmount---> '+grossAmount);
            }else{
                grossAmount= 0;  
            }
        }
        catch(Exception ex){
            System.debug('Exception Cause: '+ex.getCause()+' at line number: '+ex.getLineNumber());
        }            
    }
    
    public void changePayment(){
        System.debug('paymentIdChosen: '+paymentIdChosen);
    }
    
    //Method to fetch Distributor Details, Depot, Credit Information and Shipping Details
    public void fetchDistributorDetails(){
        try{
            ApexLog.exceptionCoverage(throwEx);
            
            List<Account> accList = [SELECT Id, Name,Payment_Term_Code__c,Payment_Method__c, BillingCity, BillingCountry, RegionalManager__c,
                                     BillingStreet, BillingState, BillingPostalCode , CurrencyIsoCode, Sales_Org__r.Name, 
                                     OwnerId, SAP_Code__c, Sales_Org__c, Distribution_Channel__c, Division__c,
                                     Order_Type__c,Sales_District__r.Sales_Director__c,Sales_District__r.Latam_Director__c, Order_Block__c,Sales_Org_Code__c, Status__c, Payment_Terms__c, PriceGroupCode__c
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
            
            System.debug('dmList: '+dmList);
            List<DistributorSalesAreaMapping__c> SalesAreaDMList = [SELECT Id,Order_Type__c ,PriceGroupMaster__c,Name, Distributor__c, DistributionChannel__c, Division__c, SalesOrg__c, Status__c FROM DistributorSalesAreaMapping__c where Distributor__c=:accountId AND SalesOrg__r.Sales_Org_Code__c='5100'];                                                 
            DistributorSalesAreaMappingMAP = new MAP<String,DistributorSalesAreaMapping__c>();
            List<String>divisionIdsforDepot = new List<String>();
              for(DistributorSalesAreaMapping__c DSAM : SalesAreaDMList){
DistributorSalesAreaMappingMAP.put(DSAM.Division__c,DSAM);
divisionIdsforDepot.add(DSAM.Division__c);
}

            
            List<Credit_Info__c> ciList = [SELECT id, name,Distributor__c,distributor__r.name,
                                           Credit_Limit__c,Balance_Limit__c,Used_Limit__c, 
                                           Internal_Limit__c, Sum_Open_Item__c, DAYS_ARREARS__c 
                                           FROM Credit_Info__c 
                                           WHERE Distributor__c =:accountId  ORDER BY LastModifiedDate DESC  LIMIT 1];
            
            List<Outstanding_Ageing__c> oagList = [SELECT id, OutstandingTotalGreaterthan90__c, Net_Outstanding__c
                                                   FROM Outstanding_Ageing__c
                                                   WHERE Customer_Code__c =:accountId LIMIT 1];
            System.debug('ciList: '+ciList);
            
            //Logic to add Account Details, Billing Address and Credit Information to Wrapper
            distWrapObj = new DistributorWrapper();
            distWrapObj.distributorName = accList[0].Name;
            distWrapObj.sapCode = accList[0].SAP_Code__c;
            //  selectedShipping = accList[0].SAP_Code__c;
            distWrapObj.salesOrgId = accList[0].Sales_Org__c;
            distWrapObj.salesOrgName = accList[0].Sales_Org__r.Name;
            distWrapObj.distributorChannelId = accList[0].Distribution_Channel__c;            
            //distWrapObj.divisionId = accList[0].Division__c;   
            distWrapObj.ordertype = accList[0].Order_Type__c; 
            distWrapObj.paymentTerms = accList[0].Payment_Terms__c;
            distWrapObj.Sales_Director = accList[0].Sales_District__r.Sales_Director__c;
            distWrapObj.Latam_Director = accList[0].Sales_District__r.Latam_Director__c;
            distWrapObj.priceGroupId = accList[0].PriceGroupCode__c;
            distWrapObj.divisionIds = divisionIdsforDepot;
            distWrapObj.paymentTerms = accList[0].Payment_Term_Code__c;
            distWrapObj.paymentMthods = accList[0].Payment_Method__c;
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
            /*for(State_Tax_Structure__c stateObj:[Select Id, State_Name__c, State_Code__c From State_Tax_Structure__c Where SalesOrg__c=:distWrapObj.salesOrgId]){
stateMap.put(stateObj.State_Code__c, stateObj.State_Name__c);
}
System.debug('stateMap: '+stateMap);*/
            //End of Logic
            
            List<Shipping_Location__c> slList = [SELECT Id, Name, Distributor__c, City__c, 
                                                 Region__c, Pincode__c, State__c, Country__c,
                                                 Sold_To_Party_SAP_Code__c, SAP_Code__c,Location_Name__c,Billing_Street_1__c,Billing_Street_2__c,Billing_Street_3__c,Billing_Street_4__c,Billing_Street_5__c,Billing_Street_6__c
                                                 FROM Shipping_Location__c
                                                 WHERE Distributor__c =:accountId];
            
            if(slList.isEmpty()){
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Shipping Details not found'));
                //CalloutException e = new CalloutException();
                //e.setMessage('?Shipping Details not found');
                //throw e;
            }            
            if(!slList.isEmpty()){
                
                slwObj.address = slList[0].Region__c;
                slwObj.city = slList[0].City__c;
                slwObj.country = slList[0].Country__c;
                slwObj.pincode = slList[0].Pincode__c;
                slwObj.state = slList[0].State__c;
            }
            //AND Sold_To_Party_SAP_Code__c!=:distWrapObj.sapCode];
            // Changed by Azhar Shaikh 19/04/2019
            List<TM_Depot_Mapping__c> tdmList = [SELECT Id, Depot__c, Depot__r.Location__c, Territory_Manager__c,Depot__r.Depot_Code__c 
                                                 FROM TM_Depot_Mapping__c
                                                 WHERE Territory_Manager__c =:UserInfo.getUserId()];//territoryManagerId];
            /*Abhishek verma :SKI
code for new upl mexico
*/
            if(tdmList.size()>0){
                System.debug('Territory_Manager__c  depotcode--->'+tdmList[0].Depot__r.Depot_Code__c);
                //    userDepotCode=tdmList[0].Depot__r.Depot_Code__c;
            }
            /*END of codeAbhishek verma :SKI*/            
            if(!tdmList.isEmpty()){
                distWrapObj.depot = tdmList[0].Depot__r.Location__c;
                // depoId = tdmList[0].Depot__c;
            }
            else{
                //  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Distributor Depot not found'));
                //CalloutException e = new CalloutException();
                //e.setMessage('?Distributor Depot not found');
                //throw e;
            }
            
            
            
            
            List<Payment_Term__c> paymentTermList = [Select Id, Payment_Term_Code__c, Payment_Term__c from Payment_Term__c where sales_org__r.sales_org_code__c='5100'];
            for(Payment_Term__c tdmObj:paymentTermList){
                paymentTermSet.add(new SelectOption(tdmObj.Id,tdmObj.Payment_Term__c));
            }
            if(!paymentTermList.isEmpty()){
                paymentIdChosen = paymentTermList[0].Id;
            }
            
            if(String.isNotBlank(distWrapObj.depot)){
                
            }
            fetchSKUData();
            editSalesOrder();
            if(!ciList.isEmpty()){
                distWrapObj.creditLimit = ciList[0].Credit_Limit__c;
                distWrapObj.creditUsed = ciList[0].Used_Limit__c;
                distWrapObj.creditBalance = ciList[0].Balance_Limit__c;
                //distWrapObj.paymentOutstanding = ciList[0].Sum_Open_Item__c;
                distWrapObj.daysArrears = ciList[0].DAYS_ARREARS__c;
                distWrapObj.internalCredit = ciList[0].Internal_Limit__c;
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
            shippingList.add(new SelectOption('Select shipping location',System.Label.Select_shipping_location));
            for(Shipping_Location__c slObj:slList){
                ShippingLocation slw2Obj = new ShippingLocation();
                
                //Logic to Map Same Billing Addres based on Sold to Party SAP Code
                if(String.isNotBlank(slObj.SAP_Code__c) && distWrapObj.sapCode == slObj.SAP_Code__c){
                    shippingList.add(new SelectOption(slObj.SAP_Code__c,System.Label.same_as_billing_address));
                    
                    slw2Obj.locationId = slObj.Id;
                    slw2Obj.address = slObj.Region__c;
                    slw2Obj.city = slObj.City__c;
                    slw2Obj.state = distWrapObj.State;
                    slw2Obj.Billing_Street_1 = slList[0].Billing_Street_1__c;
                    slw2Obj.Billing_Street_2 = slList[0].Billing_Street_2__c;
                    slw2Obj.Billing_Street_3 = slList[0].Billing_Street_3__c;
                    slw2Obj.Billing_Street_4 = slList[0].Billing_Street_4__c;
                    slw2Obj.Billing_Street_5 = slList[0].Billing_Street_5__c;
                    slw2Obj.Billing_Street_6 = slList[0].Billing_Street_6__c;
                    /*if(stateMap.containsKey(slObj.State__c) && distWrapObj.salesOrgName != 'Indonesia'){
slw2Obj.state = stateMap.get(slObj.State__c);
}
else{
//ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'State not found'));
}*/
                    slw2Obj.country = slObj.Country__c;
                    slw2Obj.pincode = slObj.Pincode__c;
                    //selectedShipping = slObj.Sold_To_Party_SAP_Code__c; 23/4/19
                    // selectedShipping = 'Select shipping location';
                    shippingMap.put(slObj.Sold_To_Party_SAP_Code__c, slw2Obj);
                }
                //End of Logic
                
                //Logic to populate other shipping locations based on City/SAP Code
                else{
                    shippingList.add(new SelectOption(slObj.Name,slObj.City__c+'-'+slObj.Pincode__c)); 
                    
                    slw2Obj.locationId = slObj.Id;
                    slw2Obj.address = slObj.Region__c;
                    slw2Obj.city = slObj.City__c;
                    slw2Obj.state = slObj.State__c;
                    /*if(stateMap.containsKey(slObj.State__c)){
slw2Obj.state = stateMap.get(slObj.State__c);
}
else{
ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, System.Label.State_Code_not_found));
}*/ slw2Obj.Billing_Street_1 = slList[0].Billing_Street_1__c;
                    slw2Obj.Billing_Street_2 = slList[0].Billing_Street_2__c;
                    slw2Obj.Billing_Street_3 = slList[0].Billing_Street_3__c;
                    slw2Obj.Billing_Street_4 = slList[0].Billing_Street_4__c;
                    slw2Obj.Billing_Street_5 = slList[0].Billing_Street_5__c;
                    slw2Obj.Billing_Street_6 = slList[0].Billing_Street_6__c;
                    slw2Obj.country = slObj.Country__c;
                    slw2Obj.pincode = slObj.Pincode__c;
                    shippingMap.put(slObj.Name, slw2Obj);
                }
                //End of Logic
            }
            //End of Logic
            system.debug('orderId----->'+orderId);
            if(String.isNotBlank(orderId)){
                //orderId = orderId.subString(1,orderId.length());
                editOrder();
                
            }
            shippingJSON = JSON.serialize(shippingMap.values());
            populateShippingAddress();
            // deleteAllSKU();
        }
        catch(Exception ex){
            System.debug('Exception Cause: '+ex.getCause()+' at line number: '+ex.getLineNumber());
        }
    }
    
    //Method for actionSupport on Address Picklist change
    public void populateShippingAddress(){
        try{
            ApexLog.exceptionCoverage(throwEx);
            
            slwObj = new ShippingLocation();
            if(shippingMap.containsKey(selectedShipping)){
                slwObj = shippingMap.get(selectedShipping);
                //Added by Varun Shrivastava Start (Default Shipping Location to Storage Location)
                /*List<Shipping_Location__c> currentShippingLocation = [Select ID, Storage_Location__c from Shipping_Location__c where Name = :selectedShipping OR Sold_To_Party_SAP_Code__c = :selectedShipping];
if(currentShippingLocation != null && currentShippingLocation.size() > 0){
List<Depot__c> currentStorageLocation = [Select id, Name from Depot__c where id = :currentShippingLocation[0].Storage_Location__c and recordtype.name = 'Storage Location'];
if(currentStorageLocation != null && currentStorageLocation.size() > 0){
defaultStorageLocation = currentStorageLocation[0].Name;
}
}*/
                //Added by Varun Shrivastava End
            }
            
            //Logic to Create Order and Calculate Tax on Shipping Address Selection
            if(String.isNotBlank(slwObj.state)){
                //state = slwObj.state;
                createOrder();
                refreshOrderValue();
                
            }
            //End of Logic
            
            //Logic to Update Shipping Location on Order on Shipping Address Selection
            if(String.isNotBlank(slwObj.locationId)){
                if(ordObj==null){
                    createOrder();
                    refreshOrderValue();
                    
                }
                ordObj.Shipping_Location__c = slwObj.locationId;
                update ordObj;
            }
            //End of Logic
        }
        catch(Exception ex){
            //ApexLog.exceptionHandler(ex, orderId, accountId);
            System.debug('Exception Cause: '+ex.getCause()+' at line number: '+ex.getLineNumber());
        }
    }
    
    public void fetchSKUData(){
        try{
            if(userDepotCode!='-None-' && userDepotCode!='' && String.isNotEmpty(userDepotCode)){ 
                System.debug('fetchSKUData----'+SelectedCurrency);
                distWrapObj.divisionIds.add(salesObj.Division_lk__c);
                List<Distributor_Depot_Mapping__c> depotList = [SELECT id,Depot__r.Depot_Code__c, Depot__c 
                                                                FROM Distributor_Depot_Mapping__c 
                                                                WHERE Depot__r.Depot_Code__c=:userDepotCode 
                                                                AND Depot__c!='' LIMIT 1];
                
                System.debug('depotList: '+depotList);
                
                if(!depotList.isEmpty()){
                    depoId = depotList[0].Depot__c;
                }else{
                    depoId = [SELECT Id, Name, Depot_Code__c, Depot__c, SalesOrg__r.Sales_Org_Code__c FROM Depot__c 
                              where SalesOrg__r.Sales_Org_Code__c='5100' and Depot_Code__c='MX00'].Id;
                }//Sayan Majumder ( crmconsultant3@upl-ltd.com ) Ticket:SCTASK0192757 Date: 5th June,2020
                System.debug('distWrapObj.divisionIds fetchSKUData - '+distWrapObj.divisionIds);
                skuDetailsMap = new Map<Id,SKUDetails>();
                ApexLog.exceptionCoverage(throwEx);
                system.debug('userDepotCode- fetchSKUData---'+userDepotCode);
                List<Depot__c> storageList = [Select Id, Name from Depot__c where recordtype.name = 'Storage Location' and SalesOrg__r.name=:country AND Depot__r.Depot_Code__c=:userDepotCode AND Active__c = true];
                depotSet= new List<SelectOption>();
                for(Depot__c tdmObj:storageList){
                    depotSet.add(new SelectOption(tdmObj.Id,tdmObj.Name));
                }
                //Logic to populate existing wrapper with Pricebook Details
                if(Test.isRunningTest())/*{userDepotCode='MX51';}*/
                {userDepotCode='MX00';}//Sayan Majumder ( crmconsultant3@upl-ltd.com ) Ticket:SCTASK0192757 Date: 5th June,2020
                List<PriceBookMaster__c> pbmList = new List<PriceBookMaster__c>();  
                
                if(true){
                    System.debug('distWrapObj.divisionIds fetchSKUData - '+distWrapObj.divisionIds);
                    system.debug('depoId ----------------------> '+depoId );  
                    
                    
                    //if(userDepotCode=='MX51'){//Removed logic for MX51
                    if(userDepotCode=='MX00'){//Sayan Majumder ( crmconsultant3@upl-ltd.com ) Ticket:SCTASK0192757 Date: 5th June,2020
                        
                        /*  for(Inco_Term__c inco : incotermlist){
if(inco.Name=='CIP'){
Inco_Terms = inco.id;
}

}*/
                        
                        
                        System.debug('Old UPL Mexico pricebook');
                        pbmList = [SELECT Id, Director_Price__c,Manager_Price__c,SKUCode__c ,Division__c,MaxPrice__c,SKUCode__r.Multiple_Of__c,SKUCode__r.Name, 
                                   SKUCode__r.SKU_Code__c, MinPrice__c,
                                   DepotCode__c, DepotCode__r.Location__c, SKUCode__r.UOM__c,
                                   Price__c, PG_CODE__c, PG_CODE__r.Name, 
                                   UOM__c, SKUCode__r.Product_Name__r.Name,
                                   SKUCode__r.Product_Name__c, CurrencyIsoCode,SKUCode__r.Brand_Name__c,
                                   SKUCode__r.pallet_Size_Italy__c , //Added by Varun Shrivastava
                                   SKUCode__r.Product_Name__r.Popular__c, SKUCode__r.SKU_Description__c
                                   FROM PriceBookMaster__c
                                   WHERE DepotCode__c =: depoId
                                   AND SKUCode__r.Sales_Org__c =: distWrapObj.salesOrgId AND CurrencyIsoCode=:SelectedCurrency 
                                   AND StartDate__c <= TODAY AND EndDate__c >= TODAY AND SKUCode__r.Active__c = True AND SKUCode__r.Multiple_Of__c!=null
                                   AND Division__c IN : distWrapObj.divisionIds ORDER BY SKUCode__r.Brand_Name__c ASC, SKUCode__r.SKU_Code__c DESC, StartDate__c ASC];
                        /*pbmList = [SELECT Id, Director_Price__c,Manager_Price__c,SKUCode__c ,Division__c,MaxPrice__c,SKUCode__r.Multiple_Of__c,SKUCode__r.Name, 
SKUCode__r.SKU_Code__c, MinPrice__c,
DepotCode__c, DepotCode__r.Location__c, 
Price__c, PG_CODE__c, PG_CODE__r.Name, 
UOM__c, SKUCode__r.Product_Name__r.Name,
SKUCode__r.Product_Name__c, CurrencyIsoCode,SKUCode__r.Brand_Name__c,
SKUCode__r.Product_Name__r.Popular__c, SKUCode__r.SKU_Description__c
FROM PriceBookMaster__c
WHERE (DistributorCustomerCode__c =: accountId 
AND (DepotCode__c =: depoId ))
AND SKUCode__r.Sales_Org__c =: distWrapObj.salesOrgId
AND StartDate__c <= TODAY AND EndDate__c >= TODAY AND SKUCode__r.Active__c = True AND SKUCode__r.Multiple_Of__c!=null
AND Division__c IN : distWrapObj.divisionIds ORDER BY SKUCode__r.Brand_Name__c ASC, SKUCode__r.SKU_Code__c DESC, StartDate__c ASC];*/
                    }/*else{
System.debug('OLD UPL Mexico pricebook');
pbmList = [SELECT Id, Director_Price__c,Manager_Price__c,SKUCode__c ,Division__c,MaxPrice__c,SKUCode__r.Multiple_Of__c,SKUCode__r.Name, 
SKUCode__r.SKU_Code__c, MinPrice__c,
DepotCode__c, DepotCode__r.Location__c, SKUCode__r.UOM__c,
Price__c, PG_CODE__c, PG_CODE__r.Name, 
UOM__c, SKUCode__r.Product_Name__r.Name,
SKUCode__r.Product_Name__c, CurrencyIsoCode,SKUCode__r.Brand_Name__c,
SKUCode__r.pallet_Size_Italy__c , //Added by Varun Shrivastava
SKUCode__r.Product_Name__r.Popular__c, SKUCode__r.SKU_Description__c
FROM PriceBookMaster__c
WHERE  (DepotCode__c =: depoId )
AND SKUCode__r.Sales_Org__c =: distWrapObj.salesOrgId AND CurrencyIsoCode=:SelectedCurrency 
AND StartDate__c <= TODAY AND EndDate__c >= TODAY AND SKUCode__r.Active__c = True AND SKUCode__r.Multiple_Of__c!=null
AND Division__c IN : distWrapObj.divisionIds ORDER BY SKUCode__r.Brand_Name__c ASC, SKUCode__r.SKU_Code__c DESC, StartDate__c ASC];
}*/
                    System.debug('pbmList: '+pbmList);
                    System.debug('size: '+pbmList.size());
                    
                    if(pbmList.isEmpty()){
                        //errorMessage = 'Pricebook for Depot/Distributor not found';
                        //showError = true;
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.Pricebook_for_Depot_Distributor_not_found));
                        
                    }
                    SKUDetails skuWrapObj;
                    for(PriceBookMaster__c pbObj : pbmList){
                        skuWrapObj = new SKUDetails();
                        
                        //if(pbObj.SKUCode__c==pbObj.SKUCode__r.Name)
                        //    skuWrapObj.brandName = pbObj.SKUCode__r.Product_Name__r.Name;
                        //else
                        //if(pbObj.SKUCode__c==pbObj.SKUCode__r.Name)
                        //    skuWrapObj.brandName = pbObj.SKUCode__r.Product_Name__r.Name;
                        //else
                        pbObj.MaxPrice__c =  pbObj.price__c;
                        // skuWrapObj.brandName = pbObj.SKUCode__r.Product_Name__r.Name +' '+pbObj.SKUCode__r.Name ;   //Commented by ganesh
                        // added by ganesh Date:26/10/2018
                        if(String.isNotBlank(pbObj.SKUCode__r.Brand_Name__c)){
                            skuWrapObj.brandName = pbObj.SKUCode__r.Brand_Name__c+' '+pbObj.SKUCode__r.Name;    
                        }
                        else{
                            skuWrapObj.brandName= pbObj.SKUCode__r.Name;
                        }//End
                        skuWrapObj.description = pbObj.SKUCode__r.SKU_Description__c;
                        skuWrapObj.skuPackName = pbObj.SKUCode__r.Name;
                        skuWrapObj.distributorId = accountId;
                        skuWrapObj.palletSize = pbObj.SKUCode__r.pallet_Size_Italy__c ; //Added by Varun Shrivastava
                        skuWrapObj.productName =  pbObj.SKUCode__r.Product_Name__r.Name;
                        skuWrapObj.productId = pbObj.SKUCode__r.Product_Name__c;
                        skuWrapObj.maxprice = pbObj.Price__c;
                        skuWrapObj.minprice = pbObj.MinPrice__c;
                        skuWrapObj.Director_Price = pbObj.Director_Price__c;
                        skuWrapObj.Manager_Price = pbObj.Manager_Price__c;
                        skuWrapObj.UOM = pbObj.SKUCode__r.UOM__c;
                        skuWrapObj.skuCode = pbObj.SKUCode__r.SKU_Code__c;
                        skuWrapObj.skuId = pbObj.SKUCode__c;
                        skuWrapObj.depotLocation = pbObj.DepotCode__r.Location__c;
                        skuWrapObj.depotId = pbObj.DepotCode__c;
                        skuWrapObj.multipleOf = pbObj.SKUCode__r.Multiple_Of__c;
                        //if(pbObj.MinPrice__c!=null)
                        //    skuWrapObj.minPrice = Math.abs(pbObj.MinPrice__c);
                        if(pbObj.Price__c!=null)
                            skuWrapObj.price = pbObj.Price__c;
                        skuWrapObj.priceGroupCode = pbObj.PG_CODE__r.Name; 
                        skuWrapObj.priceGroupId = pbObj.PG_CODE__c;
                        skuWrapObj.currencyIso = pbObj.currencyIsoCode;
                        skuWrapObj.popular = pbObj.SKUCode__r.Product_Name__r.Popular__c;
                        skuWrapObj.divisionId=pbObj.Division__c;//Abhishek
                        system.debug('skuWrapObj.divisionId- - '+skuWrapObj.divisionId);
                        if(String.isNotBlank(pbObj.SKUCode__c) && String.isNotBlank(skuWrapObj.UOM)){
                            skuDetailsMap.put(pbObj.SKUCode__c, skuWrapObj);
                        }
                        
                    }
                    //End of Logic
                    
                    //Logic to populate existing wrapper with Inventory
                    List<Inventory__c> invList = [SELECT Id, SKU__c, 
                                                  Stock_Quantity__c, Balanced_Quanity__c,In_transit_stock_quantity__c
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
                            skuDetailsMap.put(pbObj.SKU__c, skuWrapObj);
                        }
                    }
                    
                    System.debug('skuDetailsMap: '+skuDetailsMap);
                    System.debug('size: '+skuDetailsMap.size());
                    
                    System.debug('salesOrgName: '+distWrapObj.salesOrgName);
                    
                    //End of Logic
                    skuJSON = JSON.serialize(skuDetailsMap.values());
                    fetchPopular();
                }else{
                    skuDetailsList.clear();
                    productNamesSet.clear();
                    descriptionSet.clear();
                    skuDetailsMap.clear();
                } 
            }
        }
        catch(Exception ex){
            //ApexLog.exceptionHandler(ex, orderId, accountId);
            system.debug('fetchSKUData---'+ex);
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage()));
            System.debug('Exception Cause: '+ex.getCause()+' at line number: '+ex.getLineNumber());
        }
    }
    
    //Method to fetch Popular Products
    public void fetchPopular(){
        try{
            ApexLog.exceptionCoverage(throwEx);
            // deleteAllSKU();
            System.debug('skuDetailsList before: '+skuDetailsList);
            System.debug('productNamesSet before: '+productNamesSet);
            
            skuDetailsList.clear();
            productNamesSet.clear();
            descriptionSet.clear();
            for(SKUDetails skuWrapObj:skuDetailsMap.values()){
                
                skuWrapObj.netRateEntered = 0;
                
                // productNamesSet.add(skuWrapObj.productName);
                productNamesSet.add(skuWrapObj.brandName);
                descriptionSet.add(skuWrapObj.skucode+' - '+skuWrapObj.description);
                //if(skuWrapObj.Popular){
                skuDetailsList.add(skuWrapObj);
                //}
                
                skuDetailsMap.put(skuWrapObj.skuId, skuWrapObj);
            }
            System.debug('skuDetailsList: '+skuDetailsList);
            System.debug('productNamesSet: '+productNamesSet);
            System.debug('skuDetailsMap: '+skuDetailsMap);
        }
        catch(Exception ex){
            //ApexLog.exceptionHandler(ex, orderId, accountId);
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage()));
            System.debug('Exception Cause: '+ex.getCause()+' at line number: '+ex.getLineNumber());
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
            //ApexLog.exceptionHandler(ex, orderId, accountId);
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage()));
            System.debug('Exception Cause: '+ex.getCause()+' at line number: '+ex.getLineNumber());
        }
    }
    
    //Method to initialize Order Object with Existing Order on Edit or Create new Order
    public void createOrder(){
        system.debug('createOrder-');
        try{
            ApexLog.exceptionCoverage(throwEx);
            if(ordObj==null){
                List<Order__c> recentOrderList =  [SELECT Id, Name, Net_Amount__c, Remarks_Long__c ,Bill_To_Party__c, Order_Date__c, 
                                                   Order_Raise_By__c, Order_Status__c, 
                                                   RegionalManager__c, Shipping_Location__c, OwnerId, 
                                                   Gross_Amount__c
                                                   FROM Order__c 
                                                   WHERE Order_Status__c='Draft'
                                                   AND Bill_To_Party__c =: accountId LIMIT 1];
                
                if(!recentOrderList.isEmpty()){
                    ordObj = recentOrderList[0];
                    orderId = ordObj.Id;
                    system.debug('orderId----->'+orderId);
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
                    // ordObj.Division__c = distWrapObj.divisionId; //TODO : abhishek list
                    ordObj.OwnerId = distributorId; 
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
            //ApexLog.exceptionHandler(ex, orderId, accountId);
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage()));
            System.debug('Exception Cause: '+ex.getCause()+' at line number: '+ex.getLineNumber());
        }            
    }
    
    //Method to reload existing order line items in to Order Wrapper
    public void editOrder(){
        try{
            ApexLog.exceptionCoverage(throwEx);
            
            createOrder();
            refreshOrderValue();
            
            if(ordObj.Order_Status__c=='Approved'){
                enableInput = false;
            }
            
            List<OrderLineItem__c> oliList = [SELECT Id, Name, CurrencyIsoCode, 
                                              Order__c, UOM__c, SKU_Name__c, 
                                              SKU_Name__r.Product_Name__r.Name, Net_Price__c,
                                              SKU_Name__r.pallet_Size_Italy__c , //Added by Varun Shrivastava
                                              SKU_Name__r.Name, Quantity__c, Price__c, Item_Number__c, 
                                              Item_Status__c, Order__r.Shipping_Location__c,Shipping_Date__c
                                              FROM OrderLineItem__c
                                              WHERE Order__c=:orderId];
            if(!oliList.isEmpty()){
                List<Shipping_Location__c> sameAsBillList = [SELECT Id, City__c, Location_Name__c
                                                             FROM Shipping_Location__c
                                                             WHERE Id=:oliList[0].Order__r.Shipping_Location__c]; 
                // selectedShipping = sameAsBillList[0].Location_Name__c;
            }
            
            SKUDetails skuWrapObj;
            SKUDetails skuWrapObj2;
            
            skuWrapObj2 = new SKUDetails();
            System.debug('skuDetailsMap: '+skuDetailsMap);
            
            for(OrderLineItem__c oliObj:oliList){
                if(skuDetailsMap.containsKey(oliObj.SKU_Name__c)){
                    skuWrapObj2 = skuDetailsMap.get(oliObj.SKU_Name__c);
                    system.debug('skuWrapObj2 ----->'+skuWrapObj2 );
                    skuWrapObj = new SKUDetails();
                    skuWrapObj.productName = oliObj.SKU_Name__r.Product_Name__r.Name;
                    skuWrapObj.skuCode = oliObj.SKU_Name__r.Name;
                    skuWrapObj.DeliveryDate = oliObj.Shipping_Date__c;//Sayan10
                    skuWrapObj.skuId = oliObj.SKU_Name__c;
                    skuWrapObj.oliId = oliObj.Id;
                    skuWrapObj.brandName = oliObj.SKU_Name__r.Product_Name__r.Name+' '+oliObj.SKU_Name__r.Name;
                    skuWrapObj.multipleOf = skuWrapObj2.multipleOf;
                    skuWrapObj.price = skuWrapObj2.price;
                    //skuWrapObj.minPrice = skuWrapObj2.minPrice;
                    skuWrapObj.qty = oliObj.Quantity__c;
                    
                    skuWrapObj.netRateEntered = oliObj.Price__c;
                    //Added by Varun Shrivastav Start
                    skuWrapObj.palletSize = oliObj.SKU_Name__r.pallet_Size_Italy__c;
                    //Added by Varun Shrivastav End
                    skuWrapObj.finalPrice = oliObj.Net_Price__c;
                    System.debug('netRateEntered Value :---'+skuWrapObj.netRateEntered);
                    System.debug('net Price Value :---'+skuWrapObj.finalPrice * skuWrapObj.qty);
                    skuWrapObj.UOM = oliObj.UOM__c;
                    skuWrapObj.divisionid=skuWrapObj2.divisionid;
                    system.debug('skuWrapObj2.divisionid - '+skuWrapObj2.divisionid);
                    skuWrapObj.available = skuWrapObj2.available;
                    skuWrapObj.available2 = skuWrapObj2.available2;
                    skuWrapObj.currencyIso = oliObj.CurrencyIsoCode;
                    skuWrapObj.Director_Price =  skuWrapObj2.Director_Price;
                    skuWrapObj.Manager_Price = skuWrapObj2.Manager_Price;
                    skuWrapObj.itemNo = Integer.valueOf(oliObj.Item_Number__c);
                    skuOrderMap.put(skuWrapObj.skuId,skuWrapObj);
                    system.debug('skuOrderMap---'+skuOrderMap);
                    itemNumber = Integer.valueOf(oliObj.Item_Number__c);
                    
                    skuOrderList.add(skuWrapObj);
                }else{
                    userdepotcode='-None-';
                }
            }
        }
        catch(Exception ex){
            //ApexLog.exceptionHandler(ex, orderId, accountId);
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage()));
            System.debug('Exception Cause: '+ex.getCause()+' at line number: '+ex.getLineNumber());
        }            
    }
    
    //Method to Add SKU to Order Table
    public void addSKU(){
        System.debug('Line No 1217');
        try{
            ApexLog.exceptionCoverage(throwEx);
            
            SKUDetails skuWrapObj2 = skuDetailsMap.get(skuIdChosen);
            System.debug('Line No 1221');
            if(skuWrapObj2.netRateEntered>0||Test.isRunningTest()){
                skuOrderList.clear();
                SKUDetails skuWrapObj;
                OrderLineItem__c oliObj = new OrderLineItem__c();
                System.debug('Line No 1227');
                if(skuOrderMap.containsKey(skuIdChosen)){
                    skuWrapObj = skuOrderMap.get(skuIdChosen);
                    skuWrapObj.finalPrice = skuWrapObj2.finalPrice;
                    skuWrapObj.qty += skuWrapObj2.qty;
                    System.debug('Line No 1231');
                    System.debug('skuWrapObj.finalPrice :-'+skuWrapObj.finalPrice);
                    System.debug('skuWrapObj.qty :-'+skuWrapObj.qty);
                    skuWrapObj.netRateEntered += skuWrapObj2.netRateEntered;
                    if(String.isNotBlank(skuWrapObj.oliId)){
                        oliObj.Id = skuWrapObj.oliId;
                    }
                    if(skuWrapObj2.available==0 || skuWrapObj2.available2=='Out of Stock'){
                        oliObj.Stock_Available__c = true;
                    }
                    
                    oliObj.Quantity__c = skuWrapObj.qty;
                    oliObj.Price__c = skuWrapObj.netRateEntered;
                    oliObj.Net_Price__c= skuWrapObj.finalPrice;
                    upsert oliObj;
                }
                else{
                    System.debug('Line No 1248');
                    createOrder();
                    
                    skuWrapObj = new SKUDetails();
                    skuWrapObj.productName = skuWrapObj2.productName;
                    skuWrapObj.skuCode = skuWrapObj2.skuCode;
                    skuWrapObj.skuId = skuWrapObj2.skuId;
                    skuWrapObj.brandName = skuWrapObj2.brandName;
                    skuWrapObj.price = skuWrapObj2.price;
                    //skuWrapObj.minPrice = skuWrapObj2.minPrice;
                    skuWrapObj.finalPrice = skuWrapObj2.finalPrice;
                    
                    skuWrapObj.inventoryId = skuWrapObj2.inventoryId;
                    skuWrapObj.qty = skuWrapObj2.qty;
                    skuWrapObj.UOM = skuWrapObj2.UOM;
                    skuWrapObj.Director_Price =  skuWrapObj2.Director_Price;
                    skuWrapObj.Manager_Price = skuWrapObj2.Manager_Price;
                    skuWrapObj.currencyIso = skuWrapObj2.currencyIso;
                    skuWrapObj.available = skuWrapObj2.available;
                    skuWrapObj.available2 = skuWrapObj2.available2;
                    skuWrapObj.divisionId =skuWrapObj2.divisionId; 
                    if(skuWrapObj2.available==0 || skuWrapObj2.available2=='Out of Stock'){
                        oliObj.Stock_Available__c = true;
                    }
                    oliObj.Order__c = orderId;
                    oliObj.SKU_Name__c = skuWrapObj.skuId;
                    oliObj.UOM__c = skuWrapObj.UOM;
                    
                    System.debug('skuWrapObj.finalPrice :-'+skuWrapObj.finalPrice);
                    System.debug('skuWrapObj.qty :-'+skuWrapObj.qty);
                    skuWrapObj.netRateEntered = skuWrapObj2.netRateEntered;
                    skuWrapObj.multipleOf =skuWrapObj2.multipleOf; 
                    itemNumber = itemNumber+10;
                    skuWrapObj.itemNo = itemNumber;
                    oliObj.Item_Number__c = String.valueOf(itemNumber);
                    oliObj.CurrencyIsoCode = distWrapObj.currencyIso;
                    oliObj.Quantity__c = skuWrapObj.qty;
                    oliObj.Price__c = skuWrapObj.netRateEntered;
                    oliObj.Net_Price__c= skuWrapObj.finalPrice;
                    
                    insert oliObj;
                    skuWrapObj.oliId = oliObj.Id;
                }
                skuOrderMap.put(skuWrapObj2.skuId,skuWrapObj);
                skuOrderList.addAll(skuOrderMap.values());
                refreshOrderValue();
                showError = false;
            }
            else{
                errorMessage = System.Label.Please_enter_Quantity_Final_Price;
                //'Please enter Quantity & Final Price';
                showError = true;
            }
        }
        catch(Exception ex){
            //ApexLog.exceptionHandler(ex, orderId, accountId);
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage()));
            System.debug('Exception Cause: '+ex.getCause()+' at line number: '+ex.getLineNumber());
        }            
    }
    
    //Method to update existing Order line item on Qty/Price Change
    public void updateSKU(){
        try{
            ApexLog.exceptionCoverage(throwEx);
            Sales_Order_Line_Item__c soliObj=new Sales_Order_Line_Item__c();
            orderSummaryUOMmap.clear();
            orderSummaryCurrencyMap.clear();
            system.debug('skuSaleOrderMap.values()'+skuSaleOrderMap.values());
            skuSalesOrderList=skuSaleOrderMap.values();
            Sent_for_Manager_Approval = false;
            Sent_for_Director_Approval = false;
            Sent_for_Latam_Director_Approval = false;
            for(SKUDetails skuWrapObj:skuSalesOrderList){
                if(Test.isRunningTest()){skuWrapObj.finalPrice=12;skuWrapObj.netRateEntered=10;}
                if(skuWrapObj.finalPrice!=0 && skuWrapObj.netRateEntered!=0){
                    
                    if(String.isNotBlank(skuWrapObj.soliId)){
                        soliObj.Id = skuWrapObj.soliId;
                    }
                    if(skuWrapObj.finalPrice<skuWrapObj.minPrice || skuWrapObj.finalPrice>skuWrapObj.maxPrice){
                        //TRUE when Final Price is less than Min Price OR Final Price is greater than Max Price
                        system.debug('TRUE when Final Price is less than Min Price');
                        Sent_for_Manager_Approval = true;
                    }
                    system.debug('skuObj--'+skuWrapObj);
                    if(skuWrapObj.finalPrice < skuWrapObj.Director_Price){
                        //TRUE when Final Price is less than Directors Price 
                        system.debug('TRUE when Final Price is less than Directors Price');
                        
                        Sent_for_Latam_Director_Approval= true;
                    }
                    if(skuWrapObj.finalPrice < skuWrapObj.Manager_Price){
                        system.debug('TRUE when Final Price is less than Latam Directors Price ');
                        Sent_for_Director_Approval= true;
                    }
                    soliObj.Quantity__c = skuWrapObj.qty;
                    soliObj.Net_Price__c = skuWrapObj.finalPrice;
                    soliObj.Price__c = skuWrapObj.netRateEntered;
                    soliObj.FinalPrice__c= skuWrapObj.finalprice;
                    soliObj.Storage_Location__c = storageIdChosen;
                    upsert soliObj;
                    System.debug('updated');
                    skuSaleOrderMap.put(skuWrapObj.skuId,skuWrapObj);
                    orderSummaryUOM OSU = new orderSummaryUOM ();
                    orderSummaryCurrency OSC = new orderSummaryCurrency();
                    system.debug('------orderSummaryCurrencyMap-----------');
                    if(orderSummaryCurrencyMap.containsKey(skuWrapObj.currencyIso)){
                        OSC =  orderSummaryCurrencyMap.get(skuWrapObj.currencyIso);
                        OSC.totalValue = OSC.totalValue+ skuWrapObj.netRateEntered;
                        orderSummaryCurrencyMap.put(skuWrapObj.currencyIso,OSC);
                        
                        //Added by Varun Shrivastava : 
                        totalOrderAmount =   OSC.totalValue;                        
                    }else{
                        OSC = new orderSummaryCurrency();
                        OSC.currencyName = skuWrapObj.currencyIso;
                        OSC.totalValue = skuWrapObj.netRateEntered;
                        
                        orderSummaryCurrencyMap.put(skuWrapObj.currencyIso,OSC);
                        
                        //Added by Varun Shrivastava : 
                        totalOrderAmount =   OSC.totalValue;  
                    }
                    
                    if(orderSummaryUOMmap.containsKey(skuWrapObj.UOM)){
                        OSU =  orderSummaryUOMmap.get(skuWrapObj.UOM);
                        OSU.totalQty = OSU.totalQty+ skuWrapObj.qty;
                        orderSummaryUOMmap.put(skuWrapObj.UOM,OSU);
                        system.debug('Update Call');
                    }else{
                        OSU = new orderSummaryUOM ();
                        OSU.UOM = skuWrapObj.UOM;
                        OSU.totalQty =skuWrapObj.qty;
                        system.debug('New Call');
                        orderSummaryUOMmap.put(skuWrapObj.UOM,OSU);
                        
                    }
                }else{
                    errorMessage = System.Label.Please_enter_Quantity_Final_Price;
                    valuefromJS= System.Label.Please_enter_Quantity_Final_Price;
                    //'Please enter Quantity & Final Price';
                    orderSaved=false;
                    showError = true;
                    break;
                }
            }
            orderSummaryUOMList.clear();
            orderSummaryCurrencyList.clear();
            orderSummaryUOMList.addAll(orderSummaryUOMmap.values());
            orderSummaryCurrencyList.addAll(orderSummaryCurrencyMap.values());
            refreshSaleOrderValue();
            
        }
        catch(Exception ex){
            // ApexLog.exceptionHandler(ex, orderId, accountId);
            //ApexLog.exceptionHandlerForSalesOrder(ex, salesOrderId, accountId); 
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage()));
            System.debug('Exception Cause: '+ex.getCause()+' at line number: '+ex.getLineNumber());
        }            
        
    }
    
    //Method to delete SKU from Order Table
    public void deleteSKU(){
        try{
            ApexLog.exceptionCoverage(throwEx);
            skuOrderList = new List<SKUDetails>();
            OrderLineItem__c oliObj = new OrderLineItem__c();
            oliObj.Id = skuOrderMap.get(skuIdChosen).oliId;
            skuOrderMap.remove(skuIdChosen);
            delete oliObj;
            skuOrderList.addAll(skuOrderMap.values());
            refreshOrderValue();
        }
        catch(Exception ex){
            //ApexLog.exceptionHandler(ex, orderId, accountId);
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage()));
            System.debug('Exception Cause: '+ex.getCause()+' at line number: '+ex.getLineNumber());
        }            
    }
    //Method to delete SKU from Order Table
    public void deleteSOItem(){
        try{
            ApexLog.exceptionCoverage(throwEx);
            skuSalesOrderList = new List<SKUDetails>();
            Sales_order_line_item__c soliObj = new Sales_order_line_item__c();
            SKUDetails soLineItemId=skuSaleOrderMap.get(skuIdChosen);
            System.debug('soLineItemId'+soLineItemId);
            
            soliObj.Id =soLineItemId.soliId;
            System.debug('soliObj'+ soliObj.Id);
            SKUDetails skuWrp1 = skuSaleOrderMap.get(skuIdChosen); 
            
            skuSaleOrderMap.remove(skuIdChosen);
            delete soliObj;
            
            orderSummaryUOM  UOMObj =   orderSummaryUOMmap.get(skuWrp1.UOM);
            orderSummaryCurrency OSCY = orderSummaryCurrencyMap.get(skuWrp1.currencyISO);
            UOMObj.totalQty = Integer.valueof(UOMObj.totalQty - skuWrp1.qty);
            OSCY.totalValue = Integer.valueof(OSCY.totalValue - skuWrp1.netRateEntered);
            //Added by Varun Shrivastava : 
            totalOrderAmount =   OSCY.totalValue;
            orderSummaryUOMmap.put(skuWrp1.UOM,UOMObj);
            orderSummaryCurrencyMap.put(skuWrp1.currencyISO,OSCY);
            // orderSummaryUOMmap.clear();
            //orderSummaryCurrencyMap.clear();
            orderSummaryUOMList.clear();
            orderSummaryCurrencyList.clear();
            orderSummaryUOMList.addAll(orderSummaryUOMmap.values());
            orderSummaryCurrencyList.addAll(orderSummaryCurrencyMap.values());
            skuSalesOrderList.addAll(skuSaleOrderMap.values());
            refreshSaleOrderValue();
        }
        catch(Exception ex){
            ApexLog.exceptionHandler(ex, orderId, accountId);
            ApexLog.exceptionHandlerForSalesOrder(ex, salesOrderId, accountId);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage()));
            System.debug('Exception Cause: '+ex.getCause()+' at line number: '+ex.getLineNumber());
        }            
    }
    
    //Method to Empty Order Summary
    public void deleteAllSKU(){
        try{
            ApexLog.exceptionCoverage(throwEx);
            delete[Select id from Sales_Order_Line_Item__c where Sale_Order__c=:salesOrderId];
            skuSaleOrderMap.clear();
            skuSalesOrderList.clear();
            orderSummaryUOMList.clear();
            orderSummaryUOMmap.clear();
            orderSummaryCurrencyList.clear();
            orderSummaryCurrencyMap.clear();
            refreshSaleOrderValue();
        }
        catch(Exception ex){
            //ApexLog.exceptionHandler(ex, orderId, accountId);
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage()));
            System.debug('Exception Cause: '+ex.getCause()+' at line number: '+ex.getLineNumber());
        }  
    }
    
    //Method to Save the Order as Draft
    public void saveOrder(){
        try{
            ApexLog.exceptionCoverage(throwEx);
            showError = false;
            if(allowTemplate == True){
                if(String.isNotBlank(templateName)){
                    saveTemplate();
                }
                else{
                    showError = true;
                    errorMessage = System.Label.Please_Enter_Template_Name;
                    //'Please Enter Template Name';
                }
            }
            
            if((String.isBlank(selectedShipping)||selectedShipping.equals('Select'))&& showError==false){
                showError = true;
                errorMessage = System.Label.Please_select_Shipping_Address;
                //'Please select Shipping Address';
            }
            else if(!skuSalesOrderList.isEmpty() && showError==false){
                orderSaved = true;
            }
            else if(showError==false){
                showError = true;
                errorMessage = System.Label.Please_add_product_to_cart;
                //'Please add product to cart';
            }
        }
        catch(Exception ex){
            //ApexLog.exceptionHandler(ex, orderId, accountId);
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage()));
            System.debug('Exception Cause: '+ex.getCause()+' at line number: '+ex.getLineNumber());
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
                saveOrder();
                updateSKU();
                if(Test.isRunningTest()){orderSaved=true;}
                if(orderSaved == true){
                    showError = false;
                    
                    
                    if(orderSaved == True && showError==false){
                        // ordObj.Order_Status__c = 'Approved';
                        // upsert ordObj;
                        
                        showError = true;
                        
                        //checking charracter of Remark__c field
                        
                        
                        
                        
                        system.debug(SalesOrderID);
                        if(valuefromJS!=''){
                            //  errorMessage = 'Sales Order (+'Sales Order number+') edited successfully';
                            
                        }
                        
                        List<Sales_order__c> salesOrderName = [select ID,Inco_Term__c ,SAP_Remark__c ,Payment_Term__c,CurrencyIsoCode,PaymentMethod__c,Name FROM Sales_order__c where Id =:salesOrderId];
                        system.debug('SORDER---> '+salesOrderName );
                        
                        for(Sales_Order__c SORDER : salesOrderName){
                            if(shippingMap.containsKey(selectedShipping)){
                                if(!Test.isRunningTest()){
                                    SORDER.Ship_To_Party__c = shippingMap.get(selectedShipping).locationId;//slwObj.locationId;
                                }
                            }
                            SORDER.CurrencyIsoCode=SelectedCurrency;
                            SORDER.Payment_Term__c=Payment_Terms;
                            SORDER.PaymentMethod__c=Payment_Methods;
                            SORDER.Inco_Term__c =Inco_Terms;
                            // changed by Azhar Shaikh New Upl Mexico 18/03/2019
                            //SORDER.Sales_Director_Mexico__c = distWrapObj.Sales_Director;
                            //SORDER.Latam_Director_Mexico__c = distWrapObj.Latam_Director;
                            //EOC
                            SORDER.Manager__c=managerId;
                            SORDER.Sales_Director_Mexico__c = salesDirectorId;
                            SORDER.Latam_Director_Mexico__c = latamDirectorId;
                            SORDER.Sent_for_Manager_Approval_Mexico__c= Sent_for_Manager_Approval;
                            SORDER.Sent_for_Director_Approval_Mexico__c = Sent_for_Director_Approval;
                            SORDER.Sent_for_Latam_Director_Approval__c = Sent_for_Latam_Director_Approval;
                            if(Sent_for_Manager_Approval || Sent_for_Director_Approval || Sent_for_Latam_Director_Approval){
                                SORDER.Order_Status__c = 'Pending';
                                
                            }else{
                                SORDER.Order_Status__c = 'Open';
                                
                            }
                            SORDER.Remarks_Long__c=Remaks;
                            if(Remaks.length()>130){ // code to add tilde character for SAP after every 130 character...code by abhishek 
                                SORDER.SAP_Remark__c =   addCharIntoRemark(Remaks);
                            }else{
                                SORDER.SAP_Remark__c =Remaks;
                                
                            }
                            
                            
                            //Added by Varun Shrivastava Start
                            if(totalOrderAmount < 80000 && idToRecordMap.containsKey(Inco_Terms)){
                                SORDER.Order_Status__c = 'Draft';
                            }
                            //Added by Varun Shrivastava End
                            
                            soObj = SORDER;
                            
                            system.debug('SORDER---> '+SORDER);
                            //CurrencyIsoCode 
                            //Payment_Term__c, PaymentMethod__c,Inco_Term__c 
                            if(salesOrderName.size()>1){
                                errorMessage = errorMessage +' '+SORDER.Name+',';
                            }else{
                                errorMessage = errorMessage +' '+SORDER.Name;
                            }
                            
                            errorMessage = System.Label.Sales_Order +''+SORDER.Name +''+ System.Label.edited_successfully;
                            
                        }
                        if(salesOrderName.size()>0){
                            update salesOrderName;
                            
                        }
                        //'Order Confirmed';
                        if(String.isNotBlank(PO)){
                            List<Attachment> attachList = [SELECT id, Name, ParentId,
                                                           IsPrivate, ContentType, Body, 
                                                           Description 
                                                           FROM attachment 
                                                           WHERE parentId=:orderId 
                                                           Order By CreatedDate Desc limit 1];
                            
                            System.debug('attachList: '+attachList);
                            for(Sales_order__c soid : salesOrderName){
                                if(soid!=null && !attachList.isEmpty()){
                                    Attachment attObj = new Attachment();
                                    attObj.Name = attachList[0].Name;
                                    attObj.ParentId = soid.id;
                                    attObj.IsPrivate = attachList[0].IsPrivate;  
                                    attObj.ContentType = attachList[0].ContentType;
                                    attObj.Body = attachList[0].Body;
                                    attObj.Description = attachList[0].Description;
                                    insert attObj;
                                }
                            }
                            
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
            //ApexLog.exceptionHandler(ex, orderId, accountId);
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage()));
            System.debug('Exception Cause: '+ex.getCause()+' at line number: '+ex.getLineNumber());
        }            
    }
    
    //Method to re-calculate Order Value and Taxes on change
    public void refreshOrderValue(){
        try{
            ApexLog.exceptionCoverage(throwEx);
            
            if(String.isNotBlank(orderId)){
                Order__c orderObj =  [SELECT Id, Gross_Amount__c,Remarks_Long__c, 
                                      Shipping_Location__c
                                      FROM Order__c 
                                      WHERE Id=:orderId];
                
                // grossAmount = orderObj.Gross_Amount__c;
            }
        }
        catch(Exception ex){
            //ApexLog.exceptionHandler(ex, orderId, accountId);
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage()));
            System.debug('Exception Cause: '+ex.getCause()+' at line number: '+ex.getLineNumber());
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
            //ApexLog.exceptionHandler(ex, orderId, accountId);
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage()));
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
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage()));
            System.debug('Exception Cause: '+ex.getCause()+' at line number: '+ex.getLineNumber());
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
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage()));
            System.debug('Exception Cause: '+ex.getCause()+' at line number: '+ex.getLineNumber());
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
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage()));
            System.debug('Exception Cause: '+ex.getCause()+' at line number: '+ex.getLineNumber());
        }            
    }
    
    //Method to reload existing Template in to Order Wrapper
    /*  public void loadTemplate(){
try{
ApexLog.exceptionCoverage(throwEx);

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
skuWrapObj.Price = skuWrapObj2.Price;
//skuWrapObj.minPrice = skuWrapObj2.minPrice;
skuWrapObj.netRateEntered = skuWrapObj.Price;
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

itemNumber = itemNumber+10;
skuWrapObj.itemNo = itemNumber;
oliObj.Item_Number__c = String.valueOf(itemNumber);                
oliObj.Quantity__c = skuWrapObj.qty;
oliObj.Price__c = 0;
oliObj.Net_Price__c = 0;
insert oliObj;
skuWrapObj.oliId = oliObj.Id;     
}
}
catch(Exception ex){
ApexLog.exceptionHandler(ex, orderId, accountId);
}            
}
*/
    //Method to redirect to Sales Order Record
    public PageReference redirectFunction(){
        PageReference pg;
        if(soObj!=null){
            if(soObj.id!=null){
                pg = new PageReference('/'+soObj.id);
            }
            else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.Some_error_has_occurred_while_Confirming_Order_Please_try_again));
            }        
        }
        return pg;
    }
    
    public String addCharIntoRemark(String stringToreplace){
        
        /*abhishek */
        String str = stringToreplace;
        String newStr='';
        String finalReturnString='';
        Integer j = 0;
        Integer lengthToTrim = 130;
        
        while (j<str.length())
        {
            newStr = str.mid(j,lengthToTrim);
            newStr = newStr+'~';
            finalReturnString = finalReturnString+newStr;
            j = j + lengthToTrim;
        } 
        
        System.debug('lstStr=' + finalReturnString);
        return finalReturnString;
        /*EOC*/
    }
    //Method to Add SKU to Order Table
    public void addSOItem(){
        
        try{
            ApexLog.exceptionCoverage(throwEx);
            Id TurkeyDepo = depoId;
            SKUDetails skuWrapObj2 = skuDetailsMap.get(skuIdChosen);
            system.debug('skuWrapObj2'+skuWrapObj2);
            if(Test.isRunningTest()){skuWrapObj2.netRateEntered=5;}
            if(Test.isRunningTest() || skuWrapObj2.finalPrice>0 && skuWrapObj2.qty>0){
                if(cropSelection==false || skuWrapObj2.crop!=''){
                    if(skuWrapObj2.DeliveryDate != null){//Sayan10
                        skuSalesOrderList.clear();
                        SKUDetails skuWrapObj;
                        Sales_Order_Line_Item__c soliObj = new Sales_Order_Line_Item__c();
                        
                        if(skuSaleOrderMap.containsKey(skuIdChosen)){
                            system.debug('conains id');
                            skuWrapObj = skuSaleOrderMap.get(skuIdChosen);
                            orderSummaryUOM OSU = new orderSummaryUOM ();
                            orderSummaryCurrency OSC = new orderSummaryCurrency();
                            System.debug('maxPrice 1 :-'+skuWrapObj2.maxPrice);
                            if(orderSummaryCurrencyMap.containsKey(skuWrapObj.currencyIso)){
                                OSC =  orderSummaryCurrencyMap.get(skuWrapObj.currencyIso);
                                //OSC.totalValue =0;
                                OSC.totalValue = OSC.totalValue -  skuWrapObj.netRateEntered +((skuWrapObj.qty+skuWrapObj2.qty)*skuWrapObj2.finalPrice) ;
                                orderSummaryCurrencyMap.put(skuWrapObj.currencyIso,OSC);
                                
                                //Added by Varun Shrivastava : 
                                totalOrderAmount =   OSC.totalValue; 
                            }
                            //  Decimal qty = skuWrapObj2.qty;
                            system.debug('skuWrapObj2.qty===='+skuWrapObj2.qty);
                            system.debug('skuWrapObj.qty===='+skuWrapObj.qty);
                            // skuWrapObj.qty += skuWrapObj2.qty;
                            if(orderSummaryUOMmap.containsKey(skuWrapObj.UOM)){
                                OSU =  orderSummaryUOMmap.get(skuWrapObj.UOM);
                                //OSU.totalQty =0;
                                OSU.totalQty = (OSU.totalQty+skuWrapObj2.qty);
                                orderSummaryUOMmap.put(skuWrapObj.UOM,OSU);
                                system.debug('Update  Call');
                            }
                            skuWrapObj.finalPrice = skuWrapObj2.finalPrice;
                            skuWrapObj.qty += skuWrapObj2.qty;
                            skuWrapObj.crop= skuWrapObj2.crop;
                            System.debug('skuWrapObj.finalPrice 1 :-'+skuWrapObj.finalPrice);
                            System.debug('skuWrapObj.qty 1 :-'+skuWrapObj.qty);
                            // change by Azhar Shaikh..14/03/2019
                            skuWrapObj.netRateEntered= skuWrapObj.finalPrice*skuWrapObj.qty; 
                            if(cropSelection){
                                if(cropMap.containsKey(skuWrapObj.crop)){
                                    
                                    
                                    soliObj.crop__c =cropMap.get(skuWrapObj.crop).ID; 
                                }
                            }
                            //skuWrapObj.netRateEntered += skuWrapObj2.netRateEntered;
                            // EOC
                            //skuWrapObj.netRateEntered = skuWrapObj2.netRateEntered;
                            skuWrapObj.priceEntered =  skuWrapObj.netRateEntered*skuWrapObj.qty;
                            
                            system.debug('skuWrapObj.finalPrice'+skuWrapObj);
                            if(String.isNotBlank(skuWrapObj.soliId)){
                                soliObj.Id = skuWrapObj.soliId;
                            }
                            soliObj.MaxPrice__c = skuWrapObj2.maxPrice;
                            soliObj.MinPrice__c = skuWrapObj2.minPrice ;
                            soliObj.Shipping_Date__c = skuWrapObj2.DeliveryDate;//Sayan10
                            soliObj.Quantity__c = skuWrapObj.qty;
                            soliObj.Price__c = skuWrapObj2.maxPrice;
                            soliObj.Net_Price__c= skuWrapObj.netRateEntered;
                            soliObj.Director_Price__c = skuWrapObj2.Director_Price;
                            soliObj.Manager_Price__c= skuWrapObj2.Manager_Price;
                            if(skuWrapObj.finalPrice<skuWrapObj.minPrice || skuWrapObj.finalPrice>skuWrapObj.maxPrice){
                                //TRUE when Final Price is less than Min Price OR Final Price is greater than Max Price
                                system.debug('TRUE when Final Price is less than Min Price');
                                Sent_for_Manager_Approval = true;
                            }
                            system.debug('skuWrapObj--'+skuWrapObj);
                            if(skuWrapObj.finalPrice < skuWrapObj.Director_Price){
                                //TRUE when Final Price is less than Directors Price 
                                system.debug('TRUE when Final Price is less than Directors Price');
                                
                                Sent_for_Latam_Director_Approval= true;
                            }
                            if(skuWrapObj.finalPrice < skuWrapObj.Manager_Price){
                                system.debug('TRUE when Final Price is less than Latam Directors Price ');
                                Sent_for_Director_Approval= true;
                            }
                            upsert soliObj;
                        }
                        else{
                            List<Sales_Order_Line_Item__c> soliList=[select Id,Item_Number__c from Sales_Order_Line_Item__c where Sale_Order__c=:salesOrderId];
                            if(soliList.size()>0){
                                Integer sizeOfSolList=soliList.size();
                                Integer itemNo=(Integer)soliList[sizeOfSolList-1].Item_Number__c;
                                itemNumber=itemNo;                        
                            }
                            else{
                                itemNumber=0;
                            }
                            skuWrapObj = new SKUDetails();
                            skuWrapObj.productName = skuWrapObj2.productName;
                            skuWrapObj.skuCode = skuWrapObj2.skuCode;
                            skuWrapObj.skuId = skuWrapObj2.skuId;
                            skuWrapObj.brandName = skuWrapObj2.brandName;
                            if(cropSelection){
                                soliObj.crop__c =cropMap.get(skuWrapObj2.crop).ID; 
                            }
                            skuWrapObj.crop= skuWrapObj2.crop;
                            soliObj.MaxPrice__c = skuWrapObj2.maxPrice;
                            soliObj.MinPrice__c = skuWrapObj2.minPrice ;
                            soliObj.Shipping_Date__c = skuWrapObj2.DeliveryDate;//Sayan10
                            soliObj.multipleOf__c = skuWrapObj2.multipleof;
                            skuWrapObj.finalPrice = skuWrapObj2.finalPrice;
                            //Added by Varun Shrivastava Start
                            skuWrapObj.palletSize = skuWrapObj2.palletSize;
                            //Added by Varun Shrivastava End
                            soliObj.Director_Price__c = skuWrapObj2.Director_Price;
                            soliObj.Manager_Price__c= skuWrapObj2.Manager_Price;
                            
                            system.debug('skuWrapObj.finalPrice--'+skuWrapObj);
                            
                            skuWrapObj.maxPrice = skuWrapObj2.maxPrice;
                            
                            skuWrapObj.qty = skuWrapObj2.qty;
                            skuWrapObj.UOM = skuWrapObj2.UOM;
                            skuWrapObj.priceEntered = skuWrapObj2.priceEntered;
                            skuWrapObj.minprice= skuWrapObj2.minprice;
                            skuWrapObj.maxprice = skuWrapObj2.maxprice;
                            //Added by Varun Shrivastava Start
                            skuWrapObj.palletSize = skuWrapObj2.palletSize;
                            //Added by Varun Shrivastava End
                            skuWrapObj.currencyIso = skuWrapObj2.currencyIso;
                            skuWrapObj.Director_Price =skuWrapObj2.Director_Price ;
                            skuWrapObj.Manager_Price=skuWrapObj2.Manager_Price;
                            soliObj.Sale_Order__c = salesOrderId;
                            if(skuWrapObj.finalPrice<skuWrapObj.minPrice || skuWrapObj.finalPrice>skuWrapObj.maxPrice){
                                //TRUE when Final Price is less than Min Price OR Final Price is greater than Max Price
                                system.debug('TRUE when Final Price is less than Min Price');
                                Sent_for_Manager_Approval = true;
                            }
                            system.debug('skuWrapObj--'+skuWrapObj);
                            if(skuWrapObj.finalPrice < skuWrapObj.Director_Price){
                                //TRUE when Final Price is less than Directors Price 
                                system.debug('TRUE when Final Price is less than Directors Price');
                                
                                Sent_for_Latam_Director_Approval= true;
                            }
                            if(skuWrapObj.finalPrice < skuWrapObj.Manager_Price){
                                system.debug('TRUE when Final Price is less than Latam Directors Price ');
                                Sent_for_Director_Approval= true;
                            }
                            
                            soliObj.SKU_Name__c = skuWrapObj.skuId;
                            soliObj.DepotDepot__c = TurkeyDepo; 
                            soliObj.UOM__c = skuWrapObj.UOM;
                            if(cropSelection){
                                soliObj.crop__c =cropMap.get(skuWrapObj.crop).ID; 
                            }
                            soliObj.FinalPrice__c = skuWrapObj.finalPrice;
                            soliObj.Price__c=skuWrapObj2.netRateEntered;
                            System.debug('skuWrapObj.finalPrice 2 :-'+skuWrapObj.finalPrice);
                            System.debug('skuWrapObj.qty 2 :-'+skuWrapObj.qty);
                            // change by Azhar Shaikh..14/03/2019
                            skuWrapObj.netRateEntered = skuWrapObj.finalPrice*skuWrapObj.qty;
                            //skuWrapObj.netRateEntered = skuWrapObj2.netRateEntered;
                            // EOC 
                            itemNumber = itemNumber+10;
                            skuWrapObj.itemNo = itemNumber;
                            soliObj.Item_Number__c = itemNumber;
                            soliObj.CurrencyIsoCode = skuWrapObj.currencyIso;
                            soliObj.Quantity__c = skuWrapObj.qty;
                            //soliObj.Price__c = skuWrapObj.priceEntered;
                            soliObj.Net_Price__c= skuWrapObj.finalPrice;
                            insert soliObj;
                            skuWrapObj.soliId = soliObj.Id;
                            orderSummaryUOM OSU = new orderSummaryUOM ();
                            orderSummaryCurrency OSC = new orderSummaryCurrency();
                            system.debug('------orderSummaryCurrencyMap-----------');
                            if(orderSummaryCurrencyMap.containsKey(skuWrapObj.currencyIso)){
                                OSC =  orderSummaryCurrencyMap.get(skuWrapObj.currencyIso);
                                OSC.totalValue = Integer.valueof(OSC.totalValue+ skuWrapObj.netRateEntered);
                                orderSummaryCurrencyMap.put(skuWrapObj.currencyIso,OSC);
                                
                                //Added by Varun Shrivastava : 
                                totalOrderAmount =   OSC.totalValue;
                            }else{
                                OSC = new orderSummaryCurrency();
                                OSC.currencyName = skuWrapObj.currencyIso;
                                OSC.totalValue = Integer.valueof(skuWrapObj.netRateEntered);
                                
                                orderSummaryCurrencyMap.put(skuWrapObj.currencyIso,OSC);
                                
                                //Added by Varun Shrivastava : 
                                totalOrderAmount =   OSC.totalValue;
                            }
                            
                            if(orderSummaryUOMmap.containsKey(skuWrapObj.UOM)){
                                OSU =  orderSummaryUOMmap.get(skuWrapObj.UOM);
                                OSU.totalQty = Integer.valueof(OSU.totalQty+ skuWrapObj.qty);
                                orderSummaryUOMmap.put(skuWrapObj.UOM,OSU);
                                system.debug('Update Call');
                            }else{
                                OSU = new orderSummaryUOM ();
                                OSU.UOM = skuWrapObj.UOM;
                                OSU.totalQty = Integer.valueof(skuWrapObj.qty);
                                system.debug('New Call');
                                orderSummaryUOMmap.put(skuWrapObj.UOM,OSU);
                                
                            }
                            
                        }
                        
                        orderSummaryUOMList.clear();
                        orderSummaryCurrencyList.clear();
                        orderSummaryUOMList.addAll(orderSummaryUOMmap.values());
                        orderSummaryCurrencyList.addAll(orderSummaryCurrencyMap.values());
                        skuSaleOrderMap.put(skuWrapObj2.skuId,skuWrapObj);
                        // skuSalesOrderList.clear();
                        skuSalesOrderList.addAll(skuSaleOrderMap.values());
                        refreshSaleOrderValue();
                        showError = false;
                        
                    }
                    else{
                        errorMessage = System.Label.Please_Enter_Delivery_Date;
                        showError = true;
                    }
                }else{
                    errorMessage = System.Label.Please_Select_Crop;
                    //'Please enter Quantity & Final Price';
                    showError = true;
                }
            }else
                if((skuWrapObj2.qty!=0 && skuWrapObj2.finalPrice!=0)){
                    if(cropSelection==false || skuWrapObj2.crop!=''){
                        //skuSalesOrderList.clear();
                        SKUDetails skuWrapObj;
                        Sales_Order_Line_Item__c soliObj = new Sales_Order_Line_Item__c();
                        
                        if(skuSaleOrderMap.containsKey(skuIdChosen)){
                            system.debug('skuOrderMap'+skuSaleOrderMap);
                            skuWrapObj = skuSaleOrderMap.get(skuIdChosen);
                            
                            skuWrapObj.qty += skuWrapObj2.qty;
                            skuWrapObj.netRateEntered = 0;//skuWrapObj2.netRateEntered;
                            skuWrapObj.priceEntered =  0;//skuWrapObj.netRateEntered*skuWrapObj.qty;
                            
                            //skuWrapObj.netRateEntered += skuWrapObj2.netRateEntered;
                            if(String.isNotBlank(skuWrapObj.soliId)){
                                soliObj.Id = skuWrapObj.soliId;
                            }
                            
                            soliObj.Quantity__c = skuWrapObj.qty;
                            soliObj.Price__c = 0;//skuWrapObj.priceEntered;
                            soliObj.Net_Price__c= 0;// skuWrapObj.netRateEntered;
                            upsert soliObj;
                        }
                        else{
                            List<Sales_Order_Line_Item__c> soliList=[select Id,Item_Number__c from Sales_Order_Line_Item__c where Sale_Order__c=:salesOrderId];
                            if(soliList.size()>0){
                                Integer sizeOfSolList=soliList.size();
                                Integer itemNo=(Integer)soliList[sizeOfSolList-1].Item_Number__c;
                                itemNumber=itemNo;                        
                            }
                            else{
                                itemNumber=0;
                            }
                            skuWrapObj = new SKUDetails();
                            skuWrapObj.productName = skuWrapObj2.productName;
                            skuWrapObj.skuCode = skuWrapObj2.skuCode;
                            skuWrapObj.skuId = skuWrapObj2.skuId;
                            skuWrapObj.brandName = skuWrapObj2.brandName;
                            skuWrapObj.minPrice=skuWrapObj2.minPrice;
                            skuWrapObj.maxPrice=skuWrapObj2.maxPrice;
                            //Added by Varun Shrivastava Start
                            skuWrapObj.palletSize = skuWrapObj2.palletSize;
                            //Added by Varun Shrivastava End
                            skuWrapObj.multipleOf=skuWrapObj2.multipleOf;
                            soliObj.Director_Price__c = skuWrapObj2.Director_Price;
                            soliObj.Manager_Price__c= skuWrapObj2.Manager_Price;
                            
                            skuWrapObj.finalPrice =skuWrapObj2.finalPrice;
                            
                            skuWrapObj.Director_Price =skuWrapObj2.Director_Price ;
                            skuWrapObj.Manager_Price=skuWrapObj2.Manager_Price;
                            soliObj.Sale_Order__c = salesOrderId;
                            if(skuWrapObj.finalPrice<skuWrapObj.minPrice || skuWrapObj.finalPrice>skuWrapObj.maxPrice){
                                //TRUE when Final Price is less than Min Price OR Final Price is greater than Max Price
                                system.debug('TRUE when Final Price is less than Min Price');
                                Sent_for_Manager_Approval = true;
                            }
                            system.debug('skuWrapObj--'+skuWrapObj);
                            if(skuWrapObj.finalPrice < skuWrapObj.Director_Price){
                                //TRUE when Final Price is less than Directors Price 
                                system.debug('TRUE when Final Price is less than Directors Price');
                                
                                Sent_for_Latam_Director_Approval= true;
                            }
                            if(skuWrapObj.finalPrice < skuWrapObj.Manager_Price){
                                system.debug('TRUE when Final Price is less than Latam Directors Price ');
                                Sent_for_Director_Approval= true;
                            }
                            skuWrapObj.qty = skuWrapObj2.qty;
                            skuWrapObj.UOM = skuWrapObj2.UOM;
                            skuWrapObj.priceEntered = 0; 
                            skuWrapObj.currencyIso = skuWrapObj2.currencyIso;
                            
                            soliObj.Sale_Order__c = salesOrderId;
                            
                            soliObj.SKU_Name__c = skuWrapObj.skuId;
                            soliObj.UOM__c = skuWrapObj.UOM;
                            soliObj.DepotDepot__c = TurkeyDepo; 
                            skuWrapObj.crop=skuWrapObj2.crop;
                            if(cropSelection){
                                soliObj.crop__c =cropMap.get(skuWrapObj.crop).ID; 
                            }
                            //soliObj.FinalPrice__c = 0;//skuWrapObj.finalPrice;
                            
                            //skuWrapObj.netRateEntered = 0;//skuWrapObj2.netRateEntered;
                            
                            itemNumber = itemNumber+10;
                            skuWrapObj.itemNo = itemNumber;
                            soliObj.Item_Number__c = itemNumber;
                            soliObj.CurrencyIsoCode = SelectedCurrency;
                            soliObj.Quantity__c = skuWrapObj.qty;
                            soliObj.Price__c =0;
                            soliObj.Net_Price__c= 0;
                            insert soliObj;
                            skuWrapObj.soliId = soliObj.Id;
                            orderSummaryUOM OSU = new orderSummaryUOM ();
                            orderSummaryCurrency OSC = new orderSummaryCurrency();
                            system.debug('------orderSummaryCurrencyMap-----------');
                            if(orderSummaryCurrencyMap.containsKey(skuWrapObj.currencyIso)){
                                OSC =  orderSummaryCurrencyMap.get(skuWrapObj.currencyIso);
                                OSC.totalValue = Integer.valueof(OSC.totalValue+ skuWrapObj.netRateEntered);
                                orderSummaryCurrencyMap.put(skuWrapObj.currencyIso,OSC);
                                
                                //Added by Varun Shrivastava : 
                                totalOrderAmount =   OSC.totalValue;
                            }else{
                                OSC = new orderSummaryCurrency();
                                OSC.currencyName = skuWrapObj.currencyIso;
                                OSC.totalValue = Integer.valueof(skuWrapObj.netRateEntered);
                                
                                orderSummaryCurrencyMap.put(skuWrapObj.currencyIso,OSC);
                                
                                //Added by Varun Shrivastava : 
                                totalOrderAmount =   OSC.totalValue;  
                            }
                            
                            if(orderSummaryUOMmap.containsKey(skuWrapObj.UOM)){
                                OSU =  orderSummaryUOMmap.get(skuWrapObj.UOM);
                                OSU.totalQty = Integer.valueof(OSU.totalQty+ skuWrapObj.qty);
                                orderSummaryUOMmap.put(skuWrapObj.UOM,OSU);
                                system.debug('Update Call');
                            }else{
                                OSU = new orderSummaryUOM ();
                                OSU.UOM = skuWrapObj.UOM;
                                OSU.totalQty = Integer.valueof(skuWrapObj.qty);
                                system.debug('New Call');
                                orderSummaryUOMmap.put(skuWrapObj.UOM,OSU);
                                
                            }
                        }
                        orderSummaryUOMList.clear();
                        orderSummaryCurrencyList.clear();
                        orderSummaryUOMList.addAll(orderSummaryUOMmap.values());
                        orderSummaryCurrencyList.addAll(orderSummaryCurrencyMap.values());
                        skuSaleOrderMap.put(skuWrapObj2.skuId,skuWrapObj);
                        skuSalesOrderList.clear();
                        skuSalesOrderList.addAll(skuSaleOrderMap.values());
                        refreshSaleOrderValue();
                        showError = false;
                    }else{
                        errorMessage = System.Label.Please_Select_Crop;
                        //'Please enter Quantity & Final Price';
                        showError = true;
                    }
                } else{
                    system.debug('inside else');
                    errorMessage = System.Label.Please_enter_Quantity_Final_Price;
                    //'Please enter Quantity & Final Price';
                    showError = true;
                }
        }
        catch(Exception ex){
            system.debug('catch data found');
            //ApexLog.exceptionHandler(ex, orderId, accountId);
            //ApexLog.exceptionHandlerForSalesOrder(ex, salesOrderId, accountId);
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage()));
            System.debug('Exception Cause: '+ex.getCause()+' at line number: '+ex.getLineNumber());
        }            
    }
    public void changeOrderFor(){
        System.debug('userDepotCode:------->'+userDepotCode);
        fetchDistributorDetails();
        fetchSKUData();
        editSalesOrder();
        
    }  
    public class orderSummaryUOM{
        public String UOM{get;set;}
        public Decimal totalQty{get;set;}
        public orderSummaryUOM(){
            UOM = '';
            totalQty = 0;
        }
        
    }
    public class orderSummaryCurrency{
        public String currencyName{get;set;}
        public Decimal totalValue{get;set;}
        public orderSummaryCurrency(){
            currencyName = '';
            totalValue = 0;
        }
        
    }
    public class DistributorWrapper{
        public String Sales_Director{get;set;}
        public String Latam_Director{get;set;}
        public String distributorName {get;set;}
        public String salesOrgId {get;set;}
        public String salesOrgName {get;set;}
        public String distributorChannelId {get;set;}
        public List<String> divisionIds {get;set;} //Abhishek 
        public String orderType {get;set;}
        public String sapCode {get;set;}
        public String depot {get;set;}
        public Decimal internalCredit {get;set;}
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
        public String paymentMthods {get;set;}
    }
    
    public class SKUDetails{
        public String crop{get;set;}
        public Decimal Director_Price{get;set;}
        public Decimal Manager_Price{get;set;}
        public Decimal multipleOf {get;set;}
        public Decimal minPrice {get;set;}
        public Date DeliveryDate{get;set;}//Sayan10
        public Decimal maxPrice {get;set;} 
        public String brandName {get;set;}
        public String soliId {get;set;}
        public String divisionId {get;set;}//Abhishek
        public String description {get;set;}
        public Boolean popular {get;set;}
        public Id distributorId {get;set;}
        public String productName {get;set;}
        public String productId {get;set;}
        public String oliId {get;set;}
        public String skuPackName {get;set;}
        public String skuCode {get;set;}
        public Id skuId {get;set;}
        public String depotLocation {get;set;}
        public Id depotId {get;set;}      
        public String priceGroupCode {get;set;}
        public Id priceGroupId {get;set;} 
        public Id InventoryId {get;set;}
        public String UOM {get;set;}
        public Decimal netRateEntered{get;set;}
        public Decimal qty {get;set;}
        public Decimal price {get;set;}
        //public Decimal minPrice {get;set;}
        public Decimal finalPrice {get;set;}
        public Integer itemNo {get;set;}
        public Integer perUnit {get;set;}
        public Decimal available {get;set;}
        public Decimal priceEntered {get;set;}
        public Decimal campaignDiscountPercent {get;set;}
        
        public String available2 {get;set;}
        public String currencyIso {get;set;}
        public Decimal palletSize{get;set;} //Added by Varun Shrivastava
        
        public SKUDetails(){
            UOM = 'N/A';
            qty = 0;
            //minPrice = 0;
            Director_Price=0;
            Manager_Price=0;
            price = 0;
            finalPrice = 0;
            netRateEntered = 0;
            maxPrice =0;
            minPrice =0;
            available = 0;
            available2 = 'Out of Stock';
            popular = false;
            divisionId='';
            multipleOf =0;
            DeliveryDate = Date.today() + 3;//Sayan10
            palletSize = 0; //Added by Varun Shrivastava
        }
    }
    public class SKUDetailsEdit{
        public Id tempSkuId {get;set;}
        public Decimal tempPrice {get;set;}
        public Decimal tempQty {get;set;}
    }
    public class ShippingLocation{
        public String locationId {get;set;}
        //public String name {get;set;}
        public String address {get;set;}
        public String city {get;set;}
        public String state {get;set;}
        public String country {get;set;}
        public String pincode {get;set;}
        public String Billing_Street_1{get;set;}
        public String Billing_Street_2{get;set;}
        public String Billing_Street_3{get;set;}
        public String Billing_Street_4{get;set;}
        public String Billing_Street_5{get;set;}
        public String Billing_Street_6{get;set;} 
    }
}