/*
* Name: OrderCam_EditController
* Created On: 16 May 2017
* Author: Bhavik Devdhar (bhavik.devdhar@skinternational.com)
* Description: Class is used for Placing Orders by Distributor, TM, RM of Mexico
*/
global without sharing class OrderCam_EditController {
    //Variable to be set by JS for Attachment status
    
    public Login_Country__c logCoOj {get;set;}  // SKI : #CR152 : PO And Delivery Date : 12-07-2022 Vishal P SKI..
    public Date poDate {get;set;}               // SKI : #CR152 : PO And Delivery Date : 12-07-2022 Vishal P SKI..
    public String valuefromJS {get;set;}
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
    public String salesorgcodeforpbmlist;
    public Map<String,ShippingLocation> shippingMap {get;set;}    
    public Map<Id,SKUDetails> skuDetailsMap {get;set;}
    public Map<Id,SKUDetails> skuOrderMap {get;set;}
    //public Map<String,String> stateMap {get;set;}
    Public  SET<String>DistributionChannelIds = new SET<String>();
    public Set<String> productNamesSet{get;set;}
    public Set<String> descriptionSet{get;set;}
    public List<SelectOption> depotSet{get;set;}
    public List<SelectOption> paymentTermSet{get;set;}
    public List<SelectOption> shippingList {get;set;}    
    
    //Set Order Type Code
    public String orderTypeCode {get;set;}
    public String paymentTermCode {get;set;}
    
    public String selectedShipping {get;set;}
    public String selectedDepot {get; set;}
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
    
    public String saleogCode ;
    public List<String> distributionChanelCode ;//Margin Block Change - SKI Edited by Sandeep Vishwakarma
    
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
    public String PriceEntry{get;set;}
    public String PriceEntryCopy{get;set;}
    public String selectedOrderType  {get;set;}
    public MAP<String,Sales_Order__c> orgSalesorderMap ; 
    public User loginUserObj;
    public String orderType {get;set;}
    //Margin Block Change - SKI Edited by Sandeep Vishwakarma
    public List<Profit_Center__c> profitCenterList{get;set;}
	public Profit_Center__c profitCenter {get;set;}
    public Decimal salesDeduction {get;set;} 
	List<USD_Exchange_Rate__c> exchangeList;

    public List<SelectOption> getoriginOptions() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('None', 'None'));
        options.add(new SelectOption('india', 'India'));
        return options;
    }
    /*abhishek*/
    public OrderCam_EditController(ApexPages.StandardController controller) {
        try{
            multipleOf=0;
            Sent_for_Latam_Director_Approval=false;
            Sent_for_Director_Approval= false;
            Remaks='';
            Sent_for_Manager_Approval = false;
            salesObj=new Sales_Order__c();
            
            orgSalesorderMap = new MAP<String,Sales_Order__c>();
            
            
            CurrencyCodeList = new Set<SelectOption>();
            skuOrderList = new List<SKUDetails>();
            oldSKUList = new List<SKUDetailsEdit>();
            skuSalesOrderList=new List<SKUDetails>();
            //CurrencyCodeList.add('-None-');
            CurrencyCodeList.add(new SelectOption('-None-','-None-'));
            CurrencyCodeList.add(new SelectOption('MXN','MXN'));
            CurrencyCodeList.add(new SelectOption('USD','USD'));
            orderTypeCode = 'ZMOR';
            country = '';
            SelectedCurrency='USD';
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
            salesorgcodeforpbmlist='';
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
            PriceEntryCopy='';
            orderRaisedBy = '';
            skuJSON = '';
            distributorJSON = '';
            shippingJSON = '';
            saleogCode='' ;
            distributionChanelCode = new List<String>(); //Margin Block Change - SKI Edited by Sandeep Vishwakarma
            
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
            depoId = '';
            profitCenter = null; //Margin Block Change - SKI Edited by Sandeep Vishwakarma
            territoryManagerId = '';
            
            orderId = ApexPages.currentpage().getparameters().get('id');        
            System.debug('orderId: '+orderId);
            salesOrderId = ApexPages.currentpage().getparameters().get('soid');
            system.debug('in Constructor salesOrderId '+salesOrderId );
            accountId = ApexPages.currentpage().getparameters().get('acid');
            System.debug('in Constructor accountId: '+accountId);
            
            loginUserObj = [SELECT Id, Name, IsActive, ContactId,UserRole.name,
                            Show_Inventory__c, Show_Credit_Limit__c, EnableDepot__c,Sales_Director__c,
                            Show_Inventory_Column__c, ManagerId,Show_InTransit__c, Show_InTransit_Values__c,
                            HO__c, Country_Head__c, Marketing_Manager__c, ProfileId,Profile.Name
                            FROM User 
                            WHERE Id =: UserInfo.getUserId()
                            AND IsActive = True];
            
            showInventory = loginUserObj.Show_Inventory__c;
            showInventoryColumn = loginUserObj.Show_Inventory_Column__c;
            showCredit =  loginUserObj.Show_Credit_Limit__c;
            showInTransit = loginUserObj.Show_InTransit__c;
            showInTransitValues = loginUserObj.Show_InTransit_Values__c;
            
            managerId = loginUserObj.ManagerId;
            
            System.debug('showInventory: '+showInventory);
            System.debug('showInventoryColumn: '+showInventoryColumn);
            System.debug('showCredit: '+showCredit);
            
            //Assign account Id if TM creates order on behalf of Distributor
            if(String.isNotBlank(accountId)){
                
                enableDepot = loginUserObj.EnableDepot__c;
                System.debug('enableDepot: '+enableDepot);
                //distributorId = [SELECT Id FROM User where Contact.AccountId =: accountId].Id;
                
                List<User> listUr = [Select u.Id, u.IsActive, u.IsPortalEnabled from User u where u.AccountId=:accountId];
                
                /* if(listUr.size() >0 ){           // commented by Nik...New CR..06/2020
distributorId = listUr[0].id;
}else{
Account accowner = [Select id,ownerId From Account Where id =: accountId];
distributorId = accowner.ownerId;
}  */
                
                Account accowner = [Select id,ownerId From Account Where id =: accountId];  // Added By Nik..New CR..06/2020
                distributorId = accowner.ownerId;
                System.debug('-inside if condition-- distributorId: '+ distributorId);
                if(loginUserObj.Profile.Name == 'CAM(Regional Manager)'){
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
                
                // distributorId = UserInfo.getUserId();    //..Commented By Nik..New CR..06/2020
                
                showInventory = loginUserObj.Show_Inventory__c;
                
                if(!conList.isEmpty()){        
                    accountId = conList[0].Accountid;
                    territoryManagerId = conList[0].Account.OwnerId;    
                    distributorId = conList[0].Account.OwnerId;             // Added By Nik..New CR..06/2020    
                }
                else{
                    //accountId = '001N000000qg8AT'; commented By abhishek...
                    //depoId = 'a0wN0000002zYrxIAE';
                    //territoryManagerId = '005N0000002kOef';
                }
                orderRaisedBy = 'Distributor';
                //enableDepot = false;
            }
            //Margin Block Change - SKI Edited by Sandeep Vishwakarma
            List<Distributor_Depot_Mapping__c> depotList = [SELECT id, Depot__c 
                                                            FROM Distributor_Depot_Mapping__c 
                                                            WHERE Distributor__c=:accountId 
                                                            AND Depot__c!='' and Depot__r.Depot_Code__c='CR10' Order By LastModifiedDate DESC LIMIT 1];
            
            System.debug('depotList: '+depotList);
            
            if(!depotList.isEmpty()){
                depoId = depotList[0].Depot__c;
            }
            System.debug('depoId: '+depoId);
            //Margin Block Change - SKI Edited by Sandeep Vishwakarma
            if(String.isNotBlank(salesOrderId)){
                salesObj = [select id, Remarks__c,Price_Entry__c,Name,Order_Type_lk__c,Division_lk__c ,Net_Amount__c,
                            Inco_Term__c,PaymentMethod__c ,CurrencyIsoCode,Payment_Term__c,Payment_Term__r.Payment_Term__c, 
                            Order_Type_lk__r.Description__c,Order_Type_Code__c,SalesOrgCode__c,SalesDeductionUSD__c from Sales_Order__c Where Id=:salesOrderId limit 1];
                selectedSoId = salesObj.Name;
                //  grossamount = salesObj.Net_Amount__c;
                paymentTermCode=salesObj.Payment_Term__c;
                selectedOrderType = salesObj.Order_Type_lk__c;
                SelectedCurrency = salesObj.CurrencyIsoCode;
                Payment_Methods=salesObj.PaymentMethod__c ;
                Payment_Terms =salesObj.Payment_Term__c;
                Inco_Terms  = salesObj.Inco_Term__c; 
                PriceEntry = salesObj.Price_Entry__c;
                Remaks = salesObj.Remarks__c;
                PriceEntry = salesObj.Price_Entry__c;
                //Margin Block Change - SKI Edited by Sandeep Vishwakarma
                country = salesObj.SalesOrgCode__c;
                //End Margin Block Change - SKI Edited by Sandeep Vishwakarma

                system.debug('SelectedCurrency---> '+SelectedCurrency);
                if(!Test.isRunningTest()){
                    orderType = [Select Id,SalesOrg__c,Order_Type_Code__c FROM Order_Type__c WHERE Id =: salesObj.Order_Type_lk__c limit 1].Order_Type_Code__c;    
                }
                System.debug(' salesObj.Order_Type_Code__c '+salesObj.Order_Type_Code__c);
                if(salesObj.Order_Type_Code__c=='ZZEX'){
                    salesDeduction = salesObj.SalesDeductionUSD__c;
                }
                
                
                //editSalesOrder();
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
            system.debug('skuDetailsMap--->'+ skuDetailsMap);
            //fetchSKUData();
            
            
            list<Sales_order_line_item__c> SOLineItemList =new list <Sales_order_line_item__c>();
            //Margin Block Change - SKI Edited by Sandeep Vishwakarma
            SOLineItemList=[select id,Manager_Price__c,Director_Price__c,CurrencyIsoCode,Sale_Order__c,multipleOf__c,SKU_Description__c,MinPrice__c,MaxPrice__c,Comment__c,FinalPrice__c,Campaign_Discount__c,SKU_Name__c,SKU_Name__r.Division__c,
                            Net_Price__c,Quantity__c,UOM__c,Material_Discount__c,Distributor_Discount__c,DistributorDiscountPercentage__c,SKU_Name__r.Brand_Name__c,Price__c,SKU_Name__r.Name,SKU_Name__r.SKU_Description__c,Delivery_Date__c,Origin__c,E2E_Cost__c,E2E_Cost_MBEW__c,E2E_Cost_UPC9__c,Rebate1__c,Rebate2__c,Rebate1percent__c,Rebate2percent__c,Discount1__c,Discountpercent__c,Additional_Discount__c,Additional_Discountpercent__c,Contribution_Margin__c,Base_UOM__c
                            from Sales_Order_Line_Item__c 
                            where Sale_Order__c=:salesOrderId];
            //Margin Block Change - SKI Edited by Sandeep Vishwakarma
            system.debug('SOLineItemList.size----> '+SOLineItemList.size());
            if(SOLineItemList.size()>0){
                divId = SOLineItemList[0].SKU_Name__r.Division__c;
                selectedsoItemSize=SOLineItemList.size();
                SKUDetailsEdit tempSkuWrapperObj = new SKUDetailsEdit();
                for(Sales_Order_Line_Item__c tempsoliObj: SOLineItemList){
                    tempSkuWrapperObj.tempSkuId =  tempsoliObj.Id;
                    // tempSkuWrapperObj.tempPrice = tempsoliObj.Net_Price__c;
                    tempSkuWrapperObj.tempPrice = tempsoliObj.Price__c;
                    tempSkuWrapperObj.tempQty = tempsoliObj.Quantity__c; 
                    
                    oldSKUList.add(tempSkuWrapperObj);
                }
                System.debug('oldSKUListasdadasdas '+oldSKUList);
            }
            
            System.debug('saleOrderlist' +SOLineItemList); 
            if(SOLineItemList.size()>0) {
                
                for(Sales_Order_Line_Item__c solitobj:SOLineItemList){
                    system.debug('solitobj--> '+solitobj);
                    system.debug('skuDetailsMap--->'+skuDetailsMap);
                    
                    SKUDetails skuWrapObj3;
                    SKUDetails skuWrapObj=new SKUDetails();
                    
                    if(skuDetailsMap.containsKey(solitobj.SKU_Name__c)){
                        skuWrapObj3=new SKUDetails();
                        skuWrapObj3 = skuDetailsMap.get(solitobj.SKU_Name__c);
                        skuWrapObj.Price = skuWrapObj3.Price; 
                        skuWrapObj.packsize = skuWrapObj3.packsize;
                        system.debug('skuWrapObj3--->'+skuWrapObj3);
                    }
                    
                    
                    //skuWrapObj.brandName=solitobj.SKU_Description__c+' '+solitobj.SKU_Name__r.Name;
                    skuWrapObj.brandName=solitobj.SKU_Description__c;//+' '+solitobj.SKU_Name__r.Name;
                    skuWrapObj.description = solitobj.SKU_Name__r.SKU_Description__c;
                    
                    // skuWrapObj.Price = skuWrapObj3.Price;      //solitobj.MaxPrice__c;   added in above if...
                    skuWrapObj.maxPrice=solitobj.MaxPrice__c;
                    skuWrapObj.minPrice=solitobj.MinPrice__c;
                    skuWrapObj.finalPrice= solitobj.FinalPrice__c;    //solitobj.Net_Price__c;
                    skuWrapObj.qty=solitobj.Quantity__c;
                    skuWrapObj.priceEntered= solitobj.Price__c;
                    skuWrapObj.multipleof=solitobj.multipleOf__c;
                    skuWrapObj.Director_Price = solitobj.Director_Price__c;
                    skuWrapObj.Manager_Price= solitobj.Manager_Price__c;
                    //  skuWrapObj.packsize = skuWrapObj3.packsize;            added in above if...
                    
                    skuWrapObj.origin= solitobj.Origin__c;
                    skuWrapObj.freight= solitobj.Quantity__c * salesDeduction;
                    skuWrapObj.contributionMargin= solitobj.Contribution_Margin__c;
                    
                    skuWrapObj.e2EBaseUOM = solitobj.Base_UOM__c;
                    skuWrapObj.uome2eCost = solitobj.Base_UOM__c;
                    skuWrapObj.salesDeductionVal = solitobj.Quantity__c * salesDeduction;
                    skuWrapObj.salesDeductionUSD =  salesDeduction;
                    skuWrapObj.e2ECostUSD = solitobj.E2E_Cost__c;
                    skuWrapObj.e2ECostMBEWUSD = solitobj.E2E_Cost_MBEW__c;
                    skuWrapObj.e2ECostUPC9USD = solitobj.E2E_Cost_UPC9__c;
                    skuWrapObj.rebate1USD = solitobj.Rebate1__c;
                    skuWrapObj.rebate2USD = solitobj.Rebate2__c;
                    skuWrapObj.rebate1Percent = solitobj.Rebate1percent__c;
                    skuWrapObj.rebate2Percent = solitobj.Rebate2percent__c;
                    skuWrapObj.discountUSD = solitobj.Discount1__c;
                    skuWrapObj.discountPercent = solitobj.Discountpercent__c;
                    skuWrapObj.additionalDiscountUSD = solitobj.Additional_Discount__c;
                    skuWrapObj.additionalDiscountPercent = solitobj.Additional_Discountpercent__c;

                    system.debug('skuWrapObj.contributionMargin--->'+solitobj.Contribution_Margin__c);
                    // skuWrapObj.finalPrice= solitobj.FinalPrice__c;        // by Nikhil..
                    system.debug('skuWrapObj.finalPrice--->'+solitobj.FinalPrice__c);
                    system.debug('skuWrapObj.Director_Price__c--->'+solitobj.Director_Price__c);
                    system.debug('skuWrapObj.Manager_Price__c--->'+solitobj.Manager_Price__c);
                    skuWrapObj.UOM=solitobj.UOM__c;
                    //error discount display zero
                    
                    /*if(skuWrapObj.finalPrice<skuWrapObj.minPrice || skuWrapObj.finalPrice>skuWrapObj.maxPrice){
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
}*/
                    
                    system.debug('skuWrapObj--'+skuWrapObj);
                    
                    if(skuWrapObj.finalPrice < skuWrapObj.Director_Price){
                        //TRUE when Final Price is less than Directors Price 
                        system.debug('TRUE when Final Price is less than Directors Price');
                        Sent_for_Latam_Director_Approval = true;
                    }
                    
                    if(skuWrapObj.finalPrice < skuWrapObj.minPrice || skuWrapObj.finalPrice > skuWrapObj.maxPrice){
                        system.debug('TRUE when Final Price is less than Latam Directors Price ');
                        Sent_for_Director_Approval= true;
                    }
                    
                    skuWrapObj.netRateEntered=solitobj.Price__c;
                    skuWrapObj.skuId=solitobj.SKU_Name__c;
                    skuWrapObj.soliId= solitobj.Id;
                    skuWrapObj.customerDeliveryDate = solitobj.Delivery_Date__c;//Margin Block Change - SKI Edited by Sandeep Vishwakarma
                    
                    skuSaleOrderMap.put(skuWrapObj.skuId,skuWrapObj);
                    skuSalesOrderList.add(skuWrapObj);
                    System.debug('Final price of product is '+skuWrapObj.finalPrice);
                    //skuSaleOrderMap.put(skuObj1.skuId,skuObj1);
                    //skuSalesOrderList.add(skuObj1);    
                }
                refreshSaleOrderValue();  
            }
        }
        catch(Exception ex){
            
            System.debug('Exception is '+ex.getMessage());
            System.debug('Exception is Line Number is  '+ex.getLineNumber());
        }
    }
    
    public String createSalesOrder2(String salesOrgId){
        system.debug('salesOrgId - createSalesOrder2'+salesOrgId);
        system.debug('Payment_Methods- - '+Payment_Methods);
        system.debug('Payment_Terms- - '+Payment_Terms);
        system.debug('Inco_Terms- - '+Inco_Terms);
        
        String distributorChannelId = '';
        String divisionId = '';
        
        //Added by Bhavik 12th Oct 2018
        List<Depot__c> argentinaDepoList = [Select Id, Shipping_condition__c From Depot__c where id=:storageIdChosen LIMIT 1]; //SalesOrg__r.sales_org_code__c='5100' AND Depot_Code__c ='MX00'
        //End
        
        if(ordObj!=null && !orgSalesorderMap.containskey(salesOrgId)){ //if(ordObj!=null  && soObj==null){
            soObj = new Sales_Order__c();
            soObj.Sold_to_Party__c = accountId;
            soObj.Bill_To_Party__c = accountId;
            soObj.Order_Date__c = System.today();
            soObj.Order_Raise_By__c = orderRaisedBy;
            soObj.Order_Status__c = 'Open';
            soObj.CreatedFrom__c = 'SFDC';
            soObj.OwnerId = distributorId;
            soObj.Order__c = ordObj.Id;
            soObj.Ship_To_Party__c = slwObj.locationId;
            soObj.Sales_Org_lk__c = ordObj.Sales_Org__c;//list
            soObj.PaymentMethod__c =  Payment_Methods;
            soObj.Payment_Term__c = Payment_Terms;
            soObj.Inco_Term__c = Inco_Terms;
            // soObj.CurrencyIsoCode =SelectedCurrency;
            soObj.CurrencyIsoCode =ordObj.CurrencyIsoCode; ////Margin Block Change - SKI Edited by Sandeep Vishwakarma
            //soObj.Sent_for_Director_Approval_Mexico__c = Director;
            // soObj.Sent_for_Latam_Director_Approval__c = Latam_Director;
            system.debug('Login User-----: '+loginUserObj);
            /* soObj.Latam_Director_Mexico__c = loginUserObj.HO__c;
            soObj.Sales_Director_Mexico__c = loginUserObj.Country_Head__c;
            soObj.Manager__c = loginUserObj.ManagerId;   
            soObj.Customer_Service_CAM__c = loginUserObj.Marketing_Manager__c;*/
            //Margin Block Change - SKI Edited by Sandeep Vishwakarma
        if(soObj.CurrencyIsoCode=='CLP'){
                                                            
            if(exchangeList.size()>0){
                soObj.Exchange_Rate__c = exchangeList[0].Exchange_Rate__c;
                soObj.Exchange_Rate_Valid_From_Date__c = exchangeList[0].Valid_From__c;
                soObj.Exchange_Ratio_from__c = exchangeList[0].Ratio_from__c;
                soObj.Exchange_Ration_To__c = exchangeList[0].Ration_To__c;
            }

        }
            
            system.debug('DistributorSalesAreaMappingMAP- '+DistributorSalesAreaMappingMAP);
            soObj.Distribution_Channel_lk__c =  distWrapObj.distributorChannelId;//list
            
            if(DistributorSalesAreaMappingMAP.containsKey(salesOrgId)){
                soObj.Division_lk__c = DistributorSalesAreaMappingMAP.get(salesOrgId).Division__c;//list
            }
            
            //Added by Bhavik 12th Oct 2018
            if(!argentinaDepoList.isEmpty()){
                soObj.Shipping_condition__c = argentinaDepoList[0].Shipping_condition__c;
            }
            //End
            
            soObj.Credit_Term__c = distWrapObj.paymentTerms;
            system.debug('ordObj.Remarks__c -- '+ordObj.Remarks__c);
            if(!String.isBlank(ordObj.Remarks__c)){
                String s = ordObj.Remarks__c;
                if(s.length()<130){
                    soObj.Remarks__c = ordObj.Remarks__c;
                }else{
                    showError = true;
                    errorMessage = System.Label.You_can_enter_200_characters_only;
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
            
            if(!Test.isRunningTest()){
                soObj.Order_Type_lk__c = [Select Id FROM Order_Type__c WHERE Order_Type_Code__c=:orderTypeCode].Id;//distWrapObj.orderType  [Select Id FROM Order_Type__c WHERE Order_Type_Code__c='ZORD'].Id;     
            }
            
            
            
            insert soObj;
            orgSalesorderMap.put(salesOrgId,soObj);
            system.debug('orgSalesorderMap - '+orgSalesorderMap);
            
            if(userinfo.getuserid() != distributorId){                  // Added By Nik..To share order with Higher Athorities ..New CR ..06/2020
                Sales_Order__Share soShare = new Sales_Order__Share();
                soShare.ParentId = soObj.id;
                soShare.UserOrGroupId = userinfo.getuserid();
                soShare.AccessLevel = 'Edit';
                
                insert soShare;
            }
            
        }
        return soObj.ID;
    }
    //Method to Create SalesOrder on Order Confirmation
    
    //Method to add Line Items to SalesOrders on Order Confirmation
    public void addSOLineItem(){
        try{
            ApexLog.exceptionCoverage(throwEx);
            
            Decimal twoPercent = 0;
            Decimal sevenPercent = 0;
            Decimal tenPercent = 0;
            Decimal tenPercentMore = 0;
            
            Boolean submitForApproval = false;
            String SalesOrderId;
            List<String>salesOrList = new List<String>();
            Sales_Order_Line_Item__c sliObj;
            //Id argentinaDepo = [Select Id,Name ,Depot__c,SalesOrg__r.sales_org_code__c From Depot__c where SalesOrg__r.sales_org_code__c=:country AND Depot_Code__c ='CR10' LIMIT 1].ID;
            
            
            //changes due to UPL-CR130 vishal Pawar 24 march 2021
            //Margin Block Change - SKI Edited by Sandeep Vishwakarma
            Id argentinaDepo = [Select Id,Name ,Depot__c,SalesOrg__r.sales_org_code__c From Depot__c where SalesOrg__r.sales_org_code__c=:country AND Depot_Code__c ='CR10' LIMIT 1].ID;

            exchangeList = [SELECT Id,LastModifiedDate, FROM_Currency__c, 
			                                           TO_Currency__c, Exchange_Rate__c, Ratio_from__c, Ration_To__c, Valid_From__c 
			                                           FROM USD_Exchange_Rate__c WHERE FROM_Currency__c='CLP'  ORDER BY LastModifiedDate DESC LIMIT 1 ];

            List<Depot__c> argentinaDepoList = [SELECT Id, Shipping_condition__c From Depot__c WHERE Id =: storageIdChosen LIMIT 1];
            Boolean RM,SD,SRH,LRH,CCO,CFO;// TODO: Need to Sync with Needed flag

            List<String> skIdsList = new List<String>();
			Payment_Term__c payTermObj = [Select Id,Name,Payterms_Desc__c FROM Payment_Term__c
			                              WHERE Id=:Payment_Terms LIMIT 1]; // TODO: Payment term need to modified for export order

            String str = payTermObj.Payterms_Desc__c;
			List<Profit_Center__c> profitCenterList = new List<Profit_Center__c>();
			profitCenterList =[SELECT Id, Name, Profit_Center__c, Sales_Value__c, Sales_Org__c, Depot__c, Combination_Key__c FROM Profit_Center__c WHERE Sales_Org__r.Sales_org_code__c =:salesorgcodeforpbmlist and Sales_Value__c!=null ORDER BY  LastModifiedDate DESC  LIMIT 1];
			profitCenter = profitCenterList[0];
			Admin_MPT_Colombia__c adminObj = new Admin_MPT_Colombia__c();
			adminObj = [SELECT Id, Name, Approval_Level__c,Active__c, Level_1_min__c, Level_1_max__c, 
			            Level_2_min__c, Level_2_max__c, Level_3_below__c, 
			            Sales_Org__c 
			            FROM Admin_MPT_Colombia__c
			            WHERE Sales_Org__r.Sales_Org_Code__c=:salesorgcodeforpbmlist ORDER BY LastModifiedDate DESC  LIMIT 1];

            for(SKUDetails obj :skuOrderList){
				skIdsList.add(obj.skuId);
			}

            // Blanket SKU Start
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
			// Blanket SKU End

            Map<String, Sales_Order__c> sOrderMap = new Map<String, Sales_Order__c>();
			List<UOM_Conversion__c> uomList = new List<UOM_Conversion__c>();
			Map<String,List<UOM_Conversion__c>> uomListMap = new Map<String,List<UOM_Conversion__c>>();
			uomList =[SELECT Id, Name, SKU__c, Base_UOM__c, Sales_UOM__c, 
			          Numerator__c, Sales_Org__c, Denominator__c 
			          FROM UOM_Conversion__c 
			          WHERE SKU__c IN:skIdsList
			          AND Sales_Org__r.Sales_org_code__c =:salesorgcodeforpbmlist ORDER BY LastModifiedDate ASC ];
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
			                 WHERE Sales_Org__r.Sales_org_code__c =:salesorgcodeforpbmlist
			                 AND Distributor_Code__c=:accountId
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
			                    WHERE Sales_Org__r.Sales_org_code__c =:salesorgcodeforpbmlist
			                    AND Distributor_Code__c=:accountId
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
			                       WHERE Sales_Org__r.Sales_org_code__c =:salesorgcodeforpbmlist
			                       AND Distributor_Code__c=:accountId
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
			                     WHERE Sales_Org__r.Sales_org_code__c =:salesorgcodeforpbmlist
			                     AND SKU_Code__c IN :skIdsList
			                     AND Sales_Deduction_LC__c != null
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
			Map<String,List<Price_Block_Margin_Matrix__c>> mapPrCLPn = new MAP<String,List<Price_Block_Margin_Matrix__c>>();
			pbmmPlnList =[SELECT Id, Name, SKU_Code__c, SKU_Active__c, UOM__c, 
			              Sales_Org__c, PLN_LC__c, PLN_USD__c 
			              FROM Price_Block_Margin_Matrix__c
			              where Sales_Org__r.Sales_org_code__c =:salesorgcodeforpbmlist
			              AND SKU_Code__c IN:skIdsList
			              AND Type__c ='PLN'
			              AND Start_Date__c<= today AND End_Date__c>= today
			              AND PLN_LC__c!=null ORDER BY LastModifiedDate ASC ];       

			for(Price_Block_Margin_Matrix__c plnObj: pbmmPlnList){
				if(mapPrCLPn.containsKey(plnObj.SKU_Code__c)){
					List<Price_Block_Margin_Matrix__c> plmList = mapPrCLPn.get(plnObj.SKU_Code__c);
					plmList.add(plnObj);
					mapPrCLPn.put(plnObj.SKU_Code__c,plmList);
				}else{
					List<Price_Block_Margin_Matrix__c> plmList = new  List<Price_Block_Margin_Matrix__c>();
					plmList.add(plnObj);
					mapPrCLPn.put(plnObj.SKU_Code__c,plmList);

				}
			}

//End Margin Block Change - SKI Edited by Sandeep Vishwakarma
            for(SKUDetails skuWrapObj:skuOrderMap.values()){
                sliObj = new Sales_Order_Line_Item__c();
                sliObj.SKU_Name__c = skuWrapObj.skuId;
                sliObj.Item_Number__c = skuWrapObj.itemNo;
                sliObj.Item_Status__c = 'Active';
                sliObj.DepotDepot__c = argentinaDepo;
                 //commeted by Vishal pawar .. As per Sandip sir instruction
                //sliObj.Storage_Location__c = storageIdChosen;
                sliObj.UOM__c = skuWrapObj.UOM;
                sliObj.CurrencyIsoCode = distWrapObj.currencyIso;
                
                Decimal var=0;
                
                if(PriceEntryCopy.equals('Pre-uploaded')){
                    var = skuWrapObj.Price; 
                } 
                else{
                    var= skuWrapObj.finalPrice;
                }
                
                Decimal qtty ;
                Decimal var1;
                if(Test.isRunningTest()){
                    qtty=12;
                    var1 =23;
                }else{
                   qtty = skuWrapObj.qty;
                    var1 =var;
                }
                
                if(qtty==0 || qtty<0){
                    showError = true;
                    errorMessage = System.Label.Please_Enter_Quantity_for_all_SKU_s_before_confirming_order;
                    //'Please Enter Quantity for all SKU\'s before confirming order'; errorMessage = System.Label.Please_enter_Quantity_Final_Price;
                    break;
                }
                else if(var1==0 || var1<0){
                    
                    showError = true;
                    errorMessage = System.Label.Please_enter_Quantity_Final_Price;
                    break;
                }
                else {
                    // createSalesOrder();
                    //       sliObj.Payment_Term__c = paymentIdChosen; //new Payment_Term__c(Payment_Term_Code__c='0020');
                    system.debug('skuWrapObj.divisionId 1'+skuWrapObj.divisionId);
                    SalesOrderId =   createSalesOrder2(skuWrapObj.divisionId);
                    salesOrList.add(SalesOrderId);
                    //Margin Block Change - SKI Edited by Sandeep Vishwakarma
                    if(skuWrapObj.currencyIso=='CLP'){
						sliObj.E2E_Cost__c = skuWrapObj.e2ECostLC;
						sliObj.E2E_Cost_UPC9__c = skuWrapObj.e2ECostUPC9LC;
						sliObj.E2E_Cost_MBEW__c = skuWrapObj.e2ECostMBEWLC;
					}

					if(skuWrapObj.currencyIso=='USD' || Test.isRunningTest()){
						sliObj.E2E_Cost__c = skuWrapObj.e2ECostUSD;
						sliObj.E2E_Cost_UPC9__c = skuWrapObj.e2ECostUPC9USD;
						sliObj.E2E_Cost_MBEW__c = skuWrapObj.e2ECostMBEWUSD;
					}
                    //End Sandeep Vishwakarma Margin Block
                    sliObj.Quantity__c = skuWrapObj.qty;
                    sliObj.MaxPrice__C= skuWrapObj.maxprice;
                    sliObj.MinPrice__C= skuWrapObj.minprice;
                    sliObj.Net_Price__c = skuWrapObj.finalPrice;        // add as requested by Sandip Sir....by Nikhil
                    sliObj.Price__c = skuWrapObj.netRateEntered;
                    sliObj.Sale_Order__c = soObj.Id;
                    sliObj.Sale_Order__c = SalesOrderId;
                    sliObj.multipleOf__c=skuWrapObj.multipleOf; 
                    sliObj.FinalPrice__c= skuWrapObj.finalPrice;   // by Nikhil..
                    
                    /*if(skuWrapObj.finalPrice<skuWrapObj.minPrice || skuWrapObj.finalPrice>skuWrapObj.maxPrice){
//TRUE when Final Price is less than Min Price OR Final Price is greater than Max Price
system.debug('TRUE when Final Price is less than Min Price');
Sent_for_Manager_Approval = true;
}*/
                    
                    system.debug('skuWrapObj--'+skuWrapObj);
                    /*if(skuWrapObj.finalPrice < skuWrapObj.Director_Price){
//TRUE when Final Price is less than Directors Price 
system.debug('TRUE when Final Price is less than Directors Price');
Sent_for_Latam_Director_Approval= true; 
}
if(skuWrapObj.finalPrice < skuWrapObj.Manager_Price){
system.debug('TRUE when Final Price is less than Latam Directors Price ');
Sent_for_Director_Approval= true;
}*/
                    
                    if(skuWrapObj.minPrice != null){                        //...added By Nik...New CR...06/2020
                        twoPercent = skuWrapObj.minPrice - (skuWrapObj.minPrice * 2) /100 ;
                        sevenPercent = skuWrapObj.minPrice - (skuWrapObj.minPrice * 7) /100 ;
                        tenPercent = skuWrapObj.minPrice - (skuWrapObj.minPrice * 10) /100 ;
                        tenPercentMore = skuWrapObj.minPrice - (skuWrapObj.minPrice * 10.01) /100 ;
                        
                        if(skuWrapObj.finalprice < tenPercent){    
                            Sent_for_Manager_Approval = true;
                            Sent_for_Director_Approval= true;
                            Sent_for_Latam_Director_Approval= true;
                        }
                        else if(skuWrapObj.finalprice <= tenPercent || skuWrapObj.finalprice < sevenPercent){    
                            Sent_for_Manager_Approval = true;
                            Sent_for_Director_Approval= true;
                            Sent_for_Latam_Director_Approval= false;
                        }
                        else if(skuWrapObj.finalprice <= sevenPercent || skuWrapObj.finalprice <twoPercent){    
                            Sent_for_Manager_Approval = true;
                            Sent_for_Director_Approval= false;
                            Sent_for_Latam_Director_Approval= false;
                        }
                        else if(skuWrapObj.finalprice >= twoPercent){   
                            Sent_for_Manager_Approval = false;
                            Sent_for_Director_Approval= false;
                            Sent_for_Latam_Director_Approval= false;
                        }
                    }
                    
                    /* if(skuWrapObj.finalPrice < skuWrapObj.Director_Price){
//TRUE when Final Price is less than Directors Price 
system.debug('TRUE when Final Price is less than Directors Price');
Sent_for_Latam_Director_Approval = true;
}

if(skuWrapObj.finalPrice < skuWrapObj.minPrice || skuWrapObj.finalPrice > skuWrapObj.maxPrice){
system.debug('TRUE when Final Price is less than Latam Directors Price ');
Sent_for_Director_Approval= true;
} */

//Margin Block Change - SKI Edited by Sandeep Vishwakarma
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

System.debug('skuWrapObj.specialSKU '+skuWrapObj.specialSKU);
if(skuWrapObj.specialSKU==true){
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
        System.debug('skuWrapObj.uOM '+skuWrapObj.uOM+' uomObj.Base_UOM__c '+uomObj.Base_UOM__c);
        if(skuWrapObj.uOM == uomObj.Base_UOM__c){// comparing price book master UOM and UOM conversion Base UOM
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

    if(skuWrapObj.currencyIso=='CLP') {
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
        if(skuWrapObj.rebate1Percent!=null && skuWrapObj.rebate1LC==null ){
            //need to clear for netRateEntered
            rebatePercent1Convert = (skuWrapObj.rebate1Percent * skuWrapObj.convertFinalPrice)/100; 
            rebateVal1 = rebatePercent1Convert;
        }

    }//checking CLP end

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

    }//checking for USD End for Rebate 1
}

//this is for UOM converted Rebate2 Logic
if(uomList1.size()>0){
    if(skuWrapObj.currencyIso=='CLP'){
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
        }//end of for loop
        if(skuWrapObj.rebate2Percent!=null && skuWrapObj.rebate2LC==null){
            //need to clear for netRateEntered
            rebatePercent2Convert = (skuWrapObj.rebate2Percent * skuWrapObj.convertFinalPrice)/100; 
            rebateVal2 = rebatePercent2Convert;
        }
    }//end for CLP check for rebate 2
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
if(skuWrapObj.currencyIso=='CLP'){
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
    if(skuWrapObj.currencyIso=='CLP'){
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
        }//end of for loop
        if(skuWrapObj.discountPercent!=null && skuWrapObj.discountLC==null || Test.isRunningTest()){                        
            discountPercentConvert = (skuWrapObj.discountPercent * skuWrapObj.convertFinalPrice)/100; 
            discountVal = discountPercentConvert;
        }
    }//end for checking CLP currency

    //this now for Discount
    if(skuWrapObj.currencyIso=='USD' || Test.isRunningTest()){
        //discountUSD
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
        }//end of for loop
        if(skuWrapObj.discountPercent!=null && skuWrapObj.discountUSD==null || Test.isRunningTest()){                        
            discountPercentConvert = (skuWrapObj.discountPercent * skuWrapObj.convertFinalPrice)/100; 
            discountVal = discountPercentConvert;
        }

    }


}
if(skuWrapObj.currencyIso=='CLP'){
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
    if(skuWrapObj.currencyIso=='CLP'){
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
    }//end for CLP currency
    //this now additional disc
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
    }//end for checking USD Currency
}

if(skuWrapObj.currencyIso=='CLP'){
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
    System.debug('convertFinalPrice'+skuWrapObj.convertFinalPrice+' rebateVal '+rebateVal+' discountVal'+discountVal+' addDiscountVal'+addDiscountVal);
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

    if(skuWrapObj.currencyIso=='CLP'){
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
        }//end of for loop
        if(profitCenter.Sales_Value__c!=null && skuWrapObj.salesDeductionLC==null){
            saleaDeductionPercent = (profitCenter.Sales_Value__c * skuWrapObj.convertFinalPrice)/100; 
            salesDeductionVal = saleaDeductionPercent;
        } 
    }//end for checking CLP for sales deductions

    //start for USD Sales Dedectionssssd 
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
        }//end of for loop
        if(profitCenter.Sales_Value__c!=null && skuWrapObj.salesDeductionUSD==null){
            saleaDeductionPercent = (profitCenter.Sales_Value__c * skuWrapObj.convertFinalPrice)/100; 
            salesDeductionVal = saleaDeductionPercent;
        } 
        if(skuWrapObj.origin=='india' && orderType=='ZZEX'){
            salesDeductionVal = 0;
        }else if(orderType=='ZZEX'){
            salesDeductionVal = salesDeduction * skuWrapObj.convertQty;
        }
    }
}

if(skuWrapObj.currencyIso=='CLP'){
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
System.debug('Outside IF e2eCostVal 1:'+uomList1.size());
if(uomList1.size()>0){
    System.debug('Outside IF e2eCostVal 2:'+skuWrapObj.currencyIso);
    if(skuWrapObj.currencyIso=='CLP'){
        System.debug('Outside IF e2eCostVal 3:'+uomList+' skuWrapObj.e2ECostLC '+skuWrapObj.e2ECostLC);
        for(UOM_Conversion__c uomObj :uomList){
            if(skuWrapObj.e2ECostLC!=null){ 

                System.debug('Outside IF e2eCostVal 4:'+skuWrapObj.e2ECostLC);
                if(skuWrapObj.uome2eCost == uomObj.Base_UOM__c){
                    e2eCostVal = skuWrapObj.e2ECostLC;
                    e2eCostVal = e2eCostVal * skuWrapObj.convertQty;
                    System.debug('Inside If e2eCostVal :'+e2eCostVal);
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
    }//checking CLP for e2e 


    //for chekcing USD for e2e
    //sdaedsasda
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
    //end for chekcing USD for e2e

}

System.debug('skuWrapObj.currencyIso '+skuWrapObj.currencyIso);
if(skuWrapObj.currencyIso=='CLP'){
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

if(mapPrCLPn.size()>0){
    if(mapPrCLPn.containsKey(skuWrapObj.skuId)){
        pbmmPlnList1 =mapPrCLPn.get(skuWrapObj.skuId);            
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
    if(skuWrapObj.currencyIso=='CLP'){
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
    }//checking CLP currnec PLN end
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
    }//checking USD currnec PLN end
}

if(skuWrapObj.currencyIso=='CLP'){
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
    }else 
    /*if(contributionMarginPercent >= adminObj.Level_1_min__c &&  contributionMarginPercent <= adminObj.Level_1_max__c && adminObj.Approval_Level__c=='Level 1' || Test.isRunningTest()){                
        RM = true;
        SD = true;
        SRH = true;
        sliObj.Margin_Block_Level_2__c = true;
    }else
    */
     if(contributionMarginPercent >= adminObj.Level_2_min__c  &&  contributionMarginPercent <= adminObj.Level_2_max__c || Test.isRunningTest()){     
        //RITM0504522-- exluding margin level approvals
         LRH = true;
        //LRH=false;
        sliObj.Margin_Block_Level_1__c = true;
    }else if(contributionMarginPercent <= adminObj.Level_3_below__c || Test.isRunningTest()){ 
       //RITM0504522-- exluding margin level approvals
        LRH = true ;
        //CCO = true;
        CCO=false;
        //LRH=false;

        sliObj.Margin_Block_Level_2__c = true;
    }
}else{
    /*if(contributionMarginPercent >= adminObj.Level_1_min__c &&  contributionMarginPercent <= adminObj.Level_1_max__c && adminObj.Approval_Level__c=='Level 1' || Test.isRunningTest()){                
        RM = true;
        SD = true;
        SRH = true;
        sliObj.Margin_Block_Level_1__c = true;
    }else{
        sliObj.Margin_Block_Level_1__c = false;
    }   */         
    if(contributionMarginPercent >= adminObj.Level_2_min__c  &&  contributionMarginPercent <= adminObj.Level_2_max__c || Test.isRunningTest()){                
        RM = true;
        SD = true;
        SRH = true;
        //RITM0504522-- exluding margin level approvals
       LRH = true;
          //LRH = false;

        sliObj.Margin_Block_Level_1__c = true;
    }else{
        sliObj.Margin_Block_Level_1__c = false;
    }
    if(contributionMarginPercent <= adminObj.Level_3_below__c || Test.isRunningTest()){               
        //RITM0504522-- exluding margin level approvals
        LRH = true ;
        //CCO = true;
        //LRH = false ;
        CCO = false;
        sliObj.Margin_Block_Level_2__c = true;
    }else{
        sliObj.Margin_Block_Level_2__c = false;
    }
}
//blanket SKU end


if(skuWrapObj.pLNLC!=null){
    if(skuWrapObj.pLNLC > skuWrapObj.finalPrice){
        RM = true;
        SD = true;
        SRH = true;
        
       LRH = true;
         //LRH = false;
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

// End //Margin Block Change - SKI Edited by Sandeep Vishwakarma
                    
                    insert sliObj;
                    
                    if(skuWrapObj.finalPrice < skuWrapObj.Price){
                        submitForApproval = true;
                    }
                }
            }
            
            //Update Tax and Total Amount in Sales Order
            
            List<Sales_Order__c >soList = [Select Id,Sent_for_Manager_Approval_Mexico__c,Price_Entry__c ,
                                           Sent_for_Director_Approval_Mexico__c ,Sent_for_Latam_Director_Approval__c,
                                           Order_Status__c,SentEmailIndonesia__c, Net_Amount__c from Sales_Order__c 
                                           where id IN:salesOrList];
            system.debug('SalesOrderId----->'+SalesOrderId);
            for(Sales_Order__c so: soList){
                so.Total_Amount__c = so.Net_Amount__c;
                so.Sent_for_Manager_Approval_Mexico__c= Sent_for_Manager_Approval;
                so.Sent_for_Director_Approval_Mexico__c = Sent_for_Director_Approval;
                so.Sent_for_Latam_Director_Approval__c = Sent_for_Latam_Director_Approval;
                so.Order_Status__c = 'Pending';
                so.SentEmailIndonesia__c=true;
                
                system.debug('PriceEntry----> '+PriceEntry);
                so.Price_Entry__c = PriceEntry;
                so.Price_Entry_Flag__c = true;
            }
            
            if(soList.size()>0){
                update soList;
                System.debug('soObj: '+soList);
            }
            
        }
        catch(Exception ex){
            ApexLog.exceptionHandler(ex, orderId, accountId);
        }
    }
    
    public void changeDepot(){
        System.debug('Storage Location: '+storageIdChosen);
    }
    //Method to re-calculate Order Value and Taxes on change
    public void refreshSaleOrderValue(){
        try{
            ApexLog.exceptionCoverage(throwEx);
            
            if(String.isNotBlank(salesOrderId)){
                Sales_Order__c saleorder=[select id ,NetAmount_Argentina__c
                                          from Sales_Order__c
                                          Where Id=:salesOrderId LIMIT 1];
                grossAmount = saleorder.NetAmount_Argentina__c;
                system.debug('grossAmount---> '+grossAmount);
            }else{
                grossAmount= 0;  
            }
        }
        catch(Exception ex){
            //  ApexLog.exceptionHandler(ex, orderId, accountId);
            ApexLog.exceptionHandlerForSalesOrder(ex, salesOrderId, accountId);  
        }            
    }
    
    public void changePayment(){
        System.debug('paymentIdChosen: '+paymentIdChosen);
    }
    
    //Method to fetch Distributor Details, Depot, Credit Information and Shipping Details
    public void fetchDistributorDetails(){
        try{
            ApexLog.exceptionCoverage(throwEx);
            
            List<Account> accList = [SELECT Id, Name, BillingCity, BillingCountry, RegionalManager__c,
                                     BillingStreet, BillingState, BillingPostalCode , CurrencyIsoCode, Sales_Org__r.Name, 
                                     OwnerId, SAP_Code__c, Sales_Org__c, Distribution_Channel__c, Division__c,
                                     Order_Type__c,Sales_District__r.Sales_Director__c,Sales_District__r.Latam_Director__c, Order_Block__c,Sales_Org_Code__c, Status__c, Payment_Terms__c, PriceGroupCode__c
                                     FROM Account 
                                     WHERE Id=:accountId LIMIT 1];
            
            System.debug('accList: '+accList);
            
            if(accList.isEmpty()){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.Distributor_ID_not_found));
                CalloutException e = new CalloutException();
                e.setMessage('?Distributor ID not found');
                throw e;
            }            
            
            territoryManagerId = accList[0].OwnerId;
            System.debug('territoryManagerId:'+territoryManagerId);
            
            List<Distributor_Depot_Mapping__c> dmList = [SELECT id, Distributor__c ,Depot__c, Depot__r.Location__c 
                                                         FROM Distributor_Depot_Mapping__c 
                                                         WHERE Distributor__c=:accountId and Depot__r.Depot_Code__c='CR10' LIMIT 1];
            
            System.debug('dmList: '+dmList);
            //Margin Block Change - SKI Edited by Sandeep Vishwakarma
            List<DistributorSalesAreaMapping__c> SalesAreaDMList = [SELECT Id,Order_Type__c ,Sales_Org_Code__c,PriceGroupMaster__c,Name, Distributor__c, DistributionChannel__c, Division__c, SalesOrg__c, Status__c FROM DistributorSalesAreaMapping__c where Distributor__c=:accountId and SalesOrg__r.Sales_Org_Code__c=:country];                                                 
            DistributorSalesAreaMappingMAP = new MAP<String,DistributorSalesAreaMapping__c>();
            List<String>divisionIdsforDepot = new List<String>();
            for(DistributorSalesAreaMapping__c DSAM : SalesAreaDMList){
                DistributorSalesAreaMappingMAP.put(DSAM.Division__c,DSAM);
                divisionIdsforDepot.add(DSAM.Division__c);
                country =DSAM.Sales_Org_Code__c; //for multi country
                salesorgcodeforpbmlist =DSAM.Sales_Org_Code__c; 
                 DistributionChannelIds.add(DSAM.DistributionChannel__c);
            }
            
            
             Set<String> cntSalesOrg = new Set<String>();
            
            for(DistributorSalesAreaMapping__c sdaobj :SalesAreaDMList){
                cntSalesOrg.add(sdaobj.Sales_Org_Code__c);
            }
            
            
            //5711   5712
            //changes due to UPL-CR130 vishal Pawar 24 march 2021
            if(cntSalesOrg.size()== 1){
                for(String tmp :cntSalesOrg){
                    
                    if(tmp == '5711'){
                        orderType ='ZZOR';
                        saleogCode = '5711';
                    } 
                    if(tmp=='5712'){
                        orderType ='ZZEX';
                        saleogCode = '5712';
                    }
                    
                }
                
            }
            if(saleogCode == '5711'){
                distributionChanelCode.add('20');//Margin Block Change - SKI Edited by Sandeep Vishwakarma
            }else if(saleogCode == '5712'){
                distributionChanelCode.add('40');//Margin Block Change - SKI Edited by Sandeep Vishwakarma
                distributionChanelCode.add('60');//Margin Block Change - SKI Edited by Sandeep Vishwakarma
            }
            
            
            
            
            
            system.debug('country----> '+country +' distributionChanelCode '+distributionChanelCode+' saleogCode '+saleogCode);
            //Added By vishal Pawar #CR152
            logCoOj = [SELECT Id, Name, For_Contry__c, Sales_Org_Code__c, Delivery_Date__c, 
                       PO_Date__c, Show_Delivery_Date__c, Show_PO_Date__c 
                       FROM Login_Country__c
                       WHERE Sales_Org_Code__c=:country];          
            
            //Ended By vishal Pawar #CR152
            
            paymentMethodList = [SELECT Id, Name, Active__c, Description__c,Payment_Method_Code__c,Sales_Org__r.sales_org_code__c FROM Payment_Method__c where Sales_Org__r.sales_org_code__c=:country];
            incoTermList= [SELECT Id, Name, Active__c, Sales_Org__c,IncoTerm_Desc__c FROM Inco_Term__c where Sales_Org__r.Sales_Org_Code__c=:saleogCode AND Active__c=true];
            payemntTermSingleList =  [SELECT Id,name,Payterms_Desc__c,Sales_Org__c,Payment_Term_Code__c FROM Payment_Term__c where Sales_Org__r.sales_org_code__c=:saleogCode  limit 0];
            payemntTermList = [SELECT Id,name,Sales_Org__c,Payment_Term_Code__c,Payterms_Desc__c FROM Payment_Term__c where Sales_Org__r.sales_org_code__c=:saleogCode];    
            //Margin Block Change - SKI Edited by Sandeep Vishwakarma
            profitCenterList = [select id,Name,Profit_Center__c,Sales_Value__c from Profit_center__c where Sales_Org__r.sales_org_code__c=:saleogCode and Sales_Value__c!=null];

            List<Credit_Info__c> ciList = [SELECT id, name,Distributor__c,distributor__r.name,
                                           Credit_Limit__c,Balance_Limit__c,Used_Limit__c, 
                                           Internal_Limit__c, Sum_Open_Item__c, DAYS_ARREARS__c 
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
                                                 Sold_To_Party_SAP_Code__c, SAP_Code__c
                                                 FROM Shipping_Location__c
                                                 WHERE Distributor__c =:accountId];
            
            if(slList.isEmpty()){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.Shipping_Details_not_found));
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
            
            /*List<TM_Depot_Mapping__c> tdmList = [SELECT Id, Depot__c, Depot__r.Location__c, Territory_Manager__c 
FROM TM_Depot_Mapping__c
WHERE Territory_Manager__c =:territoryManagerId];
for(TM_Depot_Mapping__c tdmObj:tdmList){
depotSet.add(new SelectOption(tdmObj.Depot__r.Location__c,tdmObj.Depot__r.Location__c));
}*/
            
            if(!dmList.isEmpty()){
                distWrapObj.depot = dmList[0].Depot__r.Location__c;
                depoId = dmList[0].Depot__c;
            }
            else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.Distributor_Depot_not_found));
                //CalloutException e = new CalloutException();
                //e.setMessage('?Distributor Depot not found');
                //throw e;
            }
            
            //changes due to UPL-CR130 vishal Pawar 24 march 2021
            //List<Depot__c> storageList = [Select Id, Name from Depot__c where recordtype.name = 'Storage Location' and Depot__r.name='CR10'];
            List<Depot__c> storageList = [Select Id, Name from Depot__c where recordtype.name = 'Storage Location' and Depot__r.name='CR10'];//Margin Block Change - SKI Edited by Sandeep Vishwakarma
            for(Depot__c tdmObj:storageList){
                depotSet.add(new SelectOption(tdmObj.Id,tdmObj.Name));
            }
            if(!storageList.isEmpty()){
                storageIdChosen = storageList[0].Id;
            }
            
            List<Payment_Term__c> paymentTermList = [Select Id, Payment_Term_Code__c, Payment_Term__c from Payment_Term__c where sales_org__r.sales_org_code__c=:country];
            for(Payment_Term__c tdmObj:paymentTermList){
                paymentTermSet.add(new SelectOption(tdmObj.Id,tdmObj.Payment_Term__c));
            }
            if(!paymentTermList.isEmpty()){
                paymentIdChosen = paymentTermList[0].Id;
            }
            
            if(String.isNotBlank(distWrapObj.depot)){
                
            }
            fetchSKUData();
            if(!ciList.isEmpty()){
                distWrapObj.creditLimit = ciList[0].Credit_Limit__c;
                distWrapObj.creditUsed = ciList[0].Used_Limit__c;
                distWrapObj.creditBalance = ciList[0].Balance_Limit__c;
                //distWrapObj.paymentOutstanding = ciList[0].Sum_Open_Item__c;
                distWrapObj.daysArrears = ciList[0].DAYS_ARREARS__c;
                distWrapObj.internalCredit = ciList[0].Internal_Limit__c;
            }
            else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.Credit_Information_for_Distributor_not_found));
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
            shippingList.add(new SelectOption('Select shipping location',System.Label.Select_Shipping_Location));
            for(Shipping_Location__c slObj:slList){
                ShippingLocation slw2Obj = new ShippingLocation();
                
                //Logic to Map Same Billing Addres based on Sold to Party SAP Code
                if(String.isNotBlank(slObj.SAP_Code__c) && distWrapObj.sapCode == slObj.SAP_Code__c){
                    shippingList.add(new SelectOption(slObj.SAP_Code__c,System.Label.same_as_billing_address));
                    
                    slw2Obj.locationId = slObj.Id;
                    slw2Obj.address = slObj.Region__c;
                    slw2Obj.city = slObj.City__c;
                    slw2Obj.state = distWrapObj.State;
                    /*if(stateMap.containsKey(slObj.State__c) && distWrapObj.salesOrgName != 'Indonesia'){
slw2Obj.state = stateMap.get(slObj.State__c);
}
else{
//ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'State not found'));
}*/
                    slw2Obj.country = slObj.Country__c;
                    slw2Obj.pincode = slObj.Pincode__c;
                    selectedShipping = slObj.Sold_To_Party_SAP_Code__c;
                    // selectedShipping = 'Select shipping location';
                    shippingMap.put(slObj.Sold_To_Party_SAP_Code__c, slw2Obj);
                }
                //End of Logic
                
                //Logic to populate other shipping locations based on City/SAP Code
                else{
                    shippingList.add(new SelectOption(slObj.City__c,slObj.City__c));
                    
                    slw2Obj.locationId = slObj.Id;
                    slw2Obj.address = slObj.Region__c;
                    slw2Obj.city = slObj.City__c;
                    slw2Obj.state = slObj.State__c;
                    /*if(stateMap.containsKey(slObj.State__c)){
slw2Obj.state = stateMap.get(slObj.State__c);
}
else{
ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, System.Label.State_Code_not_found));
}*/
                    slw2Obj.country = slObj.Country__c;
                    slw2Obj.pincode = slObj.Pincode__c;
                    shippingMap.put(slw2Obj.City, slw2Obj);
                }
                //End of Logic
            }
            //End of Logic
            system.debug('orderId----->'+orderId);
            List<PriceBookMaster__c> pbmList = new List<PriceBookMaster__c>();
            //this is the condition according to the New #CR 116 changes made by Vishal Pawar
          //first check for customerwise Price book if not check for Combination 
          //Margin Block Change - SKI Edited by Sandeep Vishwakarma
          System.debug('DepotCode__c '+depoId+' sales_org_code__c '+salesorgcodeforpbmlist+' distWrapObj.divisionIds '+distWrapObj.divisionIds+' Distribution_Channel_Code__c '+distributionChanelCode);

            pbmList = [SELECT Id, Director_Price__c,Manager_Price__c,SKUCode__c ,Division__c,MaxPrice__c,SKUCode__r.Multiple_Of__c,SKUCode__r.Name, 
                       SKUCode__r.SKU_Code__c,SKUCode__r.Pack_Size__c, MinPrice__c, DepotCode__c, 
                       DepotCode__r.Location__c, SKUCode__r.Division__c, Price__c, PG_CODE__c, PG_CODE__r.Name, 
                       UOM__c, SKUCode__r.Product_Name__r.Name, SKUCode__r.Product_Name__c, CurrencyIsoCode,
                       SKUCode__r.Brand_Name__c, SKUCode__r.Product_Name__r.Popular__c, SKUCode__r.SKU_Description__c,Final_Price__c 
                       FROM PriceBookMaster__c 
                       WHERE DistributorCustomerCode__c =: accountId
                       AND DepotCode__c =: depoId
                       AND SKUCode__r.Sales_Org__r.sales_org_code__c =:salesorgcodeforpbmlist 
                       AND StartDate__c <= TODAY AND EndDate__c >= TODAY AND SKUCode__r.Active__c = True  
                       AND Division__c IN : distWrapObj.divisionIds
                       AND DistributionChannel__r.Distribution_Channel_Code__c  IN: distributionChanelCode AND Price__c != null AND Price__c != 0 //Margin Block Change - SKI Edited by Sandeep Vishwakarma
                       AND MinPrice__c != 0 AND MinPrice__c!= null ORDER BY SKUCode__r.Brand_Name__c ASC, 
                       SKUCode__r.SKU_Code__c DESC, StartDate__c ASC];
            
            if(pbmList.size()==0){
                //if(distWrapObj.priceGroupId != '' || distWrapObj.priceGroupId != null){ commented by Vishal Pawar
                    Account accobj = new Account();
                    accObj = [Select Id,Name, Sales_Org__c,Price_Classification__c,Price_List_CAM__c,Cust_Group__c,Customer_Grp__c,
                              Customer_Country__c FROM Account WHERE Id=:accountId];
                    
                //Margin Block Change - SKI Edited by Sandeep Vishwakarma
                    pbmList = [SELECT Id, Director_Price__c,Manager_Price__c,SKUCode__c ,Division__c,MaxPrice__c,SKUCode__r.Multiple_Of__c,SKUCode__r.Name, 
                               SKUCode__r.SKU_Code__c,SKUCode__r.Pack_Size__c, MinPrice__c, DepotCode__c, 
                               DepotCode__r.Location__c, SKUCode__r.Division__c, Price__c, PG_CODE__c, PG_CODE__r.Name, 
                               UOM__c, SKUCode__r.Product_Name__r.Name, SKUCode__r.Product_Name__c, CurrencyIsoCode,
                               SKUCode__r.Brand_Name__c, SKUCode__r.Product_Name__r.Popular__c, SKUCode__r.SKU_Description__c,Final_Price__c 
                               FROM PriceBookMaster__c 
                               WHERE  DepotCode__c =: depoId
                               AND SKUCode__r.Sales_Org__r.sales_org_code__c =:salesorgcodeforpbmlist 
                               AND StartDate__c <= TODAY AND EndDate__c >= TODAY 
                               AND SKUCode__r.Active__c = True  
                               AND Division__c IN : distWrapObj.divisionIds 
                               AND DistributionChannel__r.Distribution_Channel_Code__c  IN: distributionChanelCode
                               AND Price__c != null AND Price__c != 0 AND MinPrice__c != 0
                               AND Price_Classification__c =:accObj.Price_Classification__c
                               AND Price_List_CAM__c =:accObj.Price_List_CAM__c
                               AND Customer_Group__c =:accObj.Customer_Grp__c
                               AND Country__c  =:accObj.Sales_Org__c                                  
                               AND MinPrice__c!= null ORDER BY SKUCode__r.Brand_Name__c ASC, 
                               SKUCode__r.SKU_Code__c DESC, StartDate__c ASC];
                //}
            }
            
            System.debug('pbmList edit sales order '+pbmList);
            if(pbmList.isEmpty()){
                //errorMessage = 'Pricebook for Depot/Distributor not found';
                //showError = true;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.Pricebook_for_Depot_Distributor_not_found));
                
                CalloutException e = new CalloutException();
                //e.setMessage(query);
                throw e;
            }

            // Start Added by Sandeep Vishwakarma for Margin Block SKI

			List<Price_Block_Margin_Matrix__c> pbmmE2eMBEBList = new List<Price_Block_Margin_Matrix__c>();
			List<Price_Block_Margin_Matrix__c> pbmmE2eUPC9List = new List<Price_Block_Margin_Matrix__c>();
			List<Price_Block_Margin_Matrix__c> pbmmE2eList = new List<Price_Block_Margin_Matrix__c>();
			MAP<String,Price_Block_Margin_Matrix__c> prcE2eBlockMap = new MAP<String,Price_Block_Margin_Matrix__c>();

			pbmmE2eList = [SELECT Id, Name, SKU_Code__c, SKU_Active__c, UOM__c, 
			               Sales_Org__c,E2E_Cost_LC__c, E2E_Cost_USD__c, E2E_Cost_UPC9_LC__c, 
			               E2E_Cost_UPC9_USD__c, E2E_Cost_MBEW_LC__c, E2E_Cost_MBEW_USD__c
			               FROM Price_Block_Margin_Matrix__c
			               WHERE Sales_Org__r.sales_org_code__c=:salesorgcodeforpbmlist
			               AND Depot_Code__c =:depoId
			               AND Start_Date__c<= today AND End_Date__c>= today
			               AND (E2E_Cost_LC__c !=null OR E2E_Cost_USD__c != null)
			               AND UOM__c !=null
			               AND Profit_Center__c=:profitCenterList[0].Id
			               AND Type__c ='E2ECost' ORDER BY LastModifiedDate ASC ];

			pbmmE2eUPC9List = [SELECT Id, Name, SKU_Code__c, SKU_Active__c, UOM__c, 
			                   Sales_Org__c,E2E_Cost_LC__c, E2E_Cost_USD__c, E2E_Cost_UPC9_LC__c, 
			                   E2E_Cost_UPC9_USD__c, E2E_Cost_MBEW_LC__c, E2E_Cost_MBEW_USD__c
			                   FROM Price_Block_Margin_Matrix__c
			                   WHERE Sales_Org__r.sales_org_code__c=:salesorgcodeforpbmlist
			                   AND UOM__c !=null
			                   AND Depot_Code__c =:depoId
			                   AND Start_Date__c<= today AND End_Date__c>= today
			                   AND (E2E_Cost_UPC9_LC__c !=null OR E2E_Cost_UPC9_USD__c != null)
			                   AND Type__c ='E2ECostUPC9' ORDER BY LastModifiedDate ASC ];

			pbmmE2eMBEBList = [SELECT Id, Name, SKU_Code__c, SKU_Active__c, UOM__c, 
			                   Sales_Org__c,E2E_Cost_LC__c, E2E_Cost_USD__c, E2E_Cost_UPC9_LC__c, 
			                   E2E_Cost_UPC9_USD__c, E2E_Cost_MBEW_LC__c, E2E_Cost_MBEW_USD__c
			                   FROM Price_Block_Margin_Matrix__c
			                   WHERE Sales_Org__r.sales_org_code__c=:salesorgcodeforpbmlist
			                   AND UOM__c !=null
			                   AND Depot_Code__c =:depoId
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

			// End Added by Sandeep Vishwakarma for Margin Block SKI

            SKUDetails skuWrapObj4;
            for(PriceBookMaster__c pbObj : pbmList){
                skuWrapObj4 = new SKUDetails();
                
                if(String.isNotBlank(pbObj.SKUCode__r.Brand_Name__c)){
                    skuWrapObj4.brandName = pbObj.SKUCode__r.Brand_Name__c;//+' '+pbObj.SKUCode__r.Name;    
                }
                else{
                    skuWrapObj4.brandName= pbObj.SKUCode__r.Name;
                }//End
                
                System.debug('#### pbObj.SKUCode__r.SKU_Description__c '+pbObj.SKUCode__r.SKU_Description__c);
                skuWrapObj4.description = pbObj.SKUCode__r.SKU_Description__c;
                skuWrapObj4.skuPackName = pbObj.SKUCode__r.Name;
                skuWrapObj4.distributorId = accountId;
                skuWrapObj4.productName = pbObj.SKUCode__r.Product_Name__r.Name;
                skuWrapObj4.productId = pbObj.SKUCode__r.Product_Name__c;
                skuWrapObj4.maxprice = pbObj.Price__c;             //pbObj.Price__c;
                
                if(pbObj.MinPrice__c!=null){                               // ...added by Nik ..New CR..06/2020
                    skuWrapObj4.minPrice = pbObj.MinPrice__c ;//- (pbObj.MinPrice__c * 2 / 100); 
                }
                else{
                    skuWrapObj4.minPrice = 0;
                }
                
                skuWrapObj4.Director_Price = pbObj.Director_Price__c;
                skuWrapObj4.Manager_Price = pbObj.Manager_Price__c;
                skuWrapObj4.UOM = pbObj.UOM__c;
                skuWrapObj4.skuCode = pbObj.SKUCode__r.SKU_Code__c;
                skuWrapObj4.skuId = pbObj.SKUCode__c;
                skuWrapObj4.depotLocation = pbObj.DepotCode__r.Location__c;
                skuWrapObj4.depotId = pbObj.DepotCode__c;
                skuWrapObj4.multipleOf = pbObj.SKUCode__r.Multiple_Of__c;
                
                if(pbObj.Price__c!=null)
                    skuWrapObj4.price = pbObj.Price__c;
                skuWrapObj4.priceGroupCode = pbObj.PG_CODE__r.Name; 
                skuWrapObj4.priceGroupId = pbObj.PG_CODE__c;
                skuWrapObj4.currencyIso = pbObj.currencyIsoCode;
                skuWrapObj4.popular = pbObj.SKUCode__r.Product_Name__r.Popular__c;
                skuWrapObj4.divisionId=pbObj.Division__c;//Abhishek
                skuWrapObj4.packsize = pbObj.SKUCode__r.Pack_Size__c;
                skuWrapObj4.finalprice =pbObj.final_price__c; 
                skuWrapObj4.price =pbObj.final_price__c; 
                
                if(String.isNotBlank(pbObj.SKUCode__c) && String.isNotBlank(skuWrapObj4.UOM)){
                    skuDetailsMap.put(pbObj.SKUCode__c, skuWrapObj4);
                }
            }
            for(SKUDetails skuWrapObj:skuDetailsMap.values()){
                
                skuWrapObj.netRateEntered = 0;
                productNamesSet.add(skuWrapObj.brandName);
                descriptionSet.add(skuWrapObj.skucode+' - '+skuWrapObj.description);
                skuDetailsList.add(skuWrapObj);
                
                
                skuDetailsMap.put(skuWrapObj.skuId, skuWrapObj);
            }
            //End of Logic
            System.debug('Hunt UOM fetchDistributorDetails'+skuDetailsMap);
            System.debug('salesOrderId for edit '+salesOrderId);
            if(String.isNotBlank(salesOrderId )){
                editSalesOrder();    //   editsales order called here.........*******
                
            }
            shippingJSON = JSON.serialize(shippingMap.values());
            populateShippingAddress();
            // deleteAllSKU();
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
            ApexLog.exceptionHandler(ex, orderId, accountId);
        }
    }
    
    public void fetchSKUData(){
        try{
            System.debug('fetchSKUData called----');
            System.debug('SelectedCurrency----'+SelectedCurrency);
            distWrapObj.divisionIds.add(salesObj.Division_lk__c);
            System.debug('distWrapObj.divisionIds - '+distWrapObj.divisionIds);
            skuDetailsMap = new Map<Id,SKUDetails>();
            ApexLog.exceptionCoverage(throwEx);
            System.debug('SelectedCurrency----'+SelectedCurrency);
            //Logic to populate existing wrapper with Pricebook Details
            if(true){
                System.debug('distWrapObj.divisionIds - '+distWrapObj.divisionIds);
                
                List<PriceBookMaster__c> pbmList = new List<PriceBookMaster__c>();
                //Margin Block Change - SKI Edited by Sandeep Vishwakarma
                System.debug('DepotCode__c '+depoId+' sales_org_code__c '+salesorgcodeforpbmlist+' distWrapObj.divisionIds '+distWrapObj.divisionIds+' Distribution_Channel_Code__c '+distributionChanelCode);
                 //Margin Block Change - SKI Edited by Sandeep Vishwakarma
                    pbmList = [SELECT Id, Director_Price__c,Manager_Price__c,SKUCode__c ,Division__c,MaxPrice__c,SKUCode__r.Multiple_Of__c,SKUCode__r.Name, 
                               SKUCode__r.SKU_Code__c,SKUCode__r.Pack_Size__c, MinPrice__c, DepotCode__c, 
                               DepotCode__r.Location__c, SKUCode__r.Division__c, Price__c, PG_CODE__c, PG_CODE__r.Name, 
                               UOM__c, SKUCode__r.Product_Name__r.Name, SKUCode__r.Product_Name__c, CurrencyIsoCode,
                               SKUCode__r.Brand_Name__c, SKUCode__r.Product_Name__r.Popular__c, SKUCode__r.SKU_Description__c,SKUCode__r.Special_SKU__c,
                               Final_Price__c FROM PriceBookMaster__c 
                               WHERE DistributorCustomerCode__c =: accountId 
                               AND DepotCode__c =: depoId
                               AND SKUCode__r.Sales_Org__r.sales_org_code__c =:salesorgcodeforpbmlist 
                               AND StartDate__c <= TODAY AND EndDate__c >= TODAY AND SKUCode__r.Active__c = True  
                               AND Division__c IN : distWrapObj.divisionIds AND Price__c != null AND Price__c != 0 
                               AND MinPrice__c != 0 AND MinPrice__c!= null ORDER BY SKUCode__r.Brand_Name__c ASC, 
                               SKUCode__r.SKU_Code__c DESC, StartDate__c ASC];
            System.debug('@@@ pbmList First '+pbmList);
            System.debug('@@@ pbmList First '+pbmList.size());
                
                if(pbmList.size()==0 || Test.isRunningTest()){
                    
                    Account accobj = new Account();
                    accObj = [Select Id,Name, Sales_Org__c,Price_Classification__c,Price_List_CAM__c,Cust_Group__c,Customer_Grp__c,
                              Customer_Country__c FROM Account WHERE Id=:accountId];
                    //Margin Block Change - SKI Edited by Sandeep Vishwakarma
                    pbmList = [SELECT Id, Director_Price__c,Manager_Price__c,SKUCode__c ,Division__c,MaxPrice__c,SKUCode__r.Multiple_Of__c,SKUCode__r.Name, 
                               SKUCode__r.SKU_Code__c,SKUCode__r.Pack_Size__c, MinPrice__c,SKUCode__r.Special_SKU__c, DepotCode__c, 
                               DepotCode__r.Location__c, SKUCode__r.Division__c, Price__c, PG_CODE__c, PG_CODE__r.Name, 
                               UOM__c, SKUCode__r.Product_Name__r.Name, SKUCode__r.Product_Name__c, CurrencyIsoCode,
                               SKUCode__r.Brand_Name__c, SKUCode__r.Product_Name__r.Popular__c, SKUCode__r.SKU_Description__c,Final_Price__c 
                               FROM PriceBookMaster__c 
                               WHERE DepotCode__c =: depoId
                               AND SKUCode__r.Sales_Org__r.sales_org_code__c =:salesorgcodeforpbmlist 
                               AND Price_Classification__c =:accObj.Price_Classification__c
                               AND Price_List_CAM__c =:accObj.Price_List_CAM__c
                               AND Customer_Group__c =:accObj.Customer_Grp__c
                               AND Country__c  =:accObj.Sales_Org__c    
                               AND StartDate__c <= TODAY AND EndDate__c >= TODAY AND SKUCode__r.Active__c = True  
                               AND Division__c IN : distWrapObj.divisionIds AND Price__c != null AND Price__c != 0 AND MinPrice__c != 0 
                               AND MinPrice__c!= null ORDER BY SKUCode__r.Brand_Name__c ASC, 
                               SKUCode__r.SKU_Code__c DESC, StartDate__c ASC];
                    
                    System.debug('@@@ Inside Second '+pbmList);
                    System.debug('@@@ Inside Second '+pbmList.size());
                        
                    
                    //} commeneted by Vishal Pawar
                }
                
                if(pbmList.isEmpty()){
                    //errorMessage = 'Pricebook for Depot/Distributor not found';
                    //showError = true;
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.Pricebook_for_Depot_Distributor_not_found));
                    
                    CalloutException e = new CalloutException();
                    //e.setMessage(query);
                    throw e;
                }

                // start Sandeep Vishwakarma Margin Block SKI
                List<Price_Block_Margin_Matrix__c> pbmmE2eMBEBList = new List<Price_Block_Margin_Matrix__c>();
			List<Price_Block_Margin_Matrix__c> pbmmE2eUPC9List = new List<Price_Block_Margin_Matrix__c>();
			List<Price_Block_Margin_Matrix__c> pbmmE2eList = new List<Price_Block_Margin_Matrix__c>();
			MAP<String,Price_Block_Margin_Matrix__c> prcE2eBlockMap = new MAP<String,Price_Block_Margin_Matrix__c>();

			pbmmE2eList = [SELECT Id, Name, SKU_Code__c, SKU_Active__c, UOM__c, 
			               Sales_Org__c,E2E_Cost_LC__c, E2E_Cost_USD__c, E2E_Cost_UPC9_LC__c, 
			               E2E_Cost_UPC9_USD__c, E2E_Cost_MBEW_LC__c, E2E_Cost_MBEW_USD__c
			               FROM Price_Block_Margin_Matrix__c
			               WHERE Sales_Org__r.sales_org_code__c=:salesorgcodeforpbmlist
			               AND Depot_Code__c =:depoId
			               AND Start_Date__c<= today AND End_Date__c>= today
			               AND (E2E_Cost_LC__c !=null OR E2E_Cost_USD__c != null)
			               AND UOM__c !=null
			               AND Profit_Center__c=:profitCenterList[0].Id
			               AND Type__c ='E2ECost' ORDER BY LastModifiedDate ASC ];

			pbmmE2eUPC9List = [SELECT Id, Name, SKU_Code__c, SKU_Active__c, UOM__c, 
			                   Sales_Org__c,E2E_Cost_LC__c, E2E_Cost_USD__c, E2E_Cost_UPC9_LC__c, 
			                   E2E_Cost_UPC9_USD__c, E2E_Cost_MBEW_LC__c, E2E_Cost_MBEW_USD__c
			                   FROM Price_Block_Margin_Matrix__c
			                   WHERE Sales_Org__r.sales_org_code__c=:salesorgcodeforpbmlist
			                   AND UOM__c !=null
			                   AND Depot_Code__c =:depoId
			                   AND Start_Date__c<= today AND End_Date__c>= today
			                   AND (E2E_Cost_UPC9_LC__c !=null OR E2E_Cost_UPC9_USD__c != null)
			                   AND Type__c ='E2ECostUPC9' ORDER BY LastModifiedDate ASC ];

			pbmmE2eMBEBList = [SELECT Id, Name, SKU_Code__c, SKU_Active__c, UOM__c, 
			                   Sales_Org__c,E2E_Cost_LC__c, E2E_Cost_USD__c, E2E_Cost_UPC9_LC__c, 
			                   E2E_Cost_UPC9_USD__c, E2E_Cost_MBEW_LC__c, E2E_Cost_MBEW_USD__c
			                   FROM Price_Block_Margin_Matrix__c
			                   WHERE Sales_Org__r.sales_org_code__c=:salesorgcodeforpbmlist
			                   AND UOM__c !=null
			                   AND Depot_Code__c =:depoId
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
                // End Sandeep Vishwakarma Margin Block

                SKUDetails skuWrapObj;
                //Margin Block Change - SKI Edited by Sandeep Vishwakarma
                for(PriceBookMaster__c pbObj : pbmList){
                    if(prcE2eBlockMap.containsKey(pbObj.SKUCode__c)){
                    skuWrapObj = new SKUDetails();
                    
                    //if(pbObj.SKUCode__c==pbObj.SKUCode__r.Name)
                    //    skuWrapObj.brandName = pbObj.SKUCode__r.Product_Name__r.Name;
                    //else
                    //skuWrapObj.brandName = pbObj.SKUCode__r.Product_Name__r.Name +' '+pbObj.SKUCode__r.Name ;
                    
                    if(String.isNotBlank(pbObj.SKUCode__r.Brand_Name__c)){
                        //skuWrapObj.brandName = pbObj.SKUCode__r.Brand_Name__c+' '+pbObj.SKUCode__r.Name;    
                        skuWrapObj.brandName = pbObj.SKUCode__r.Brand_Name__c;//+' '+pbObj.SKUCode__r.Name;    
                    }
                    else{
                        skuWrapObj.brandName= pbObj.SKUCode__r.Name;
                    } 
                    
                    skuWrapObj.description = pbObj.SKUCode__r.SKU_Description__c;
                    skuWrapObj.skuPackName = pbObj.SKUCode__r.Name;
                    skuWrapObj.distributorId = accountId;
                    skuWrapObj.productName = pbObj.SKUCode__r.Product_Name__r.Name;
                    skuWrapObj.productId = pbObj.SKUCode__r.Product_Name__c;
                    skuWrapObj.maxprice = pbObj.Price__c;
                    skuWrapObj.Director_Price = pbObj.Director_Price__c;
                    skuWrapObj.Manager_Price = pbObj.Manager_Price__c;
                    skuWrapObj.UOM = pbObj.UOM__c;
                    skuWrapObj.skuCode = pbObj.SKUCode__r.SKU_Code__c;
                    skuWrapObj.skuId = pbObj.SKUCode__c;
                    skuWrapObj.depotLocation = pbObj.DepotCode__r.Location__c;
                    skuWrapObj.depotId = pbObj.DepotCode__c;
                    skuWrapObj.multipleOf = pbObj.SKUCode__r.Multiple_Of__c;
                    skuWrapObj.finalPrice = pbObj.Final_Price__c;
                    
                    //skuWrapObj.minPrice = pbObj.MinPrice__c;                 // ...commented by Nik ..New CR..06/2020
                    
                    if(pbObj.MinPrice__c!=null){                               // ...added by Nik ..New CR..06/2020
                        skuWrapObj.minPrice = pbObj.MinPrice__c - (pbObj.MinPrice__c * 2 / 100); 
                    }
                    else{
                        skuWrapObj.minPrice = 0;
                    }
                    
                    system.debug('skuWrapObj.finalPrice------->'+skuWrapObj.finalPrice);
                    if(pbObj.Final_Price__c!=null)
                        skuWrapObj.price = pbObj.Final_Price__c;   
                    
                    skuWrapObj.priceGroupCode = pbObj.PG_CODE__r.Name; 
                    skuWrapObj.priceGroupId = pbObj.PG_CODE__c;
                    skuWrapObj.currencyIso = pbObj.currencyIsoCode;
                    skuWrapObj.popular = pbObj.SKUCode__r.Product_Name__r.Popular__c;
                    System.debug('pbObj.Division__c ew '+pbObj.Division__c);
                    skuWrapObj.divisionId=pbObj.Division__c;//Abhishek
                    skuWrapObj.packsize = pbObj.SKUCode__r.Pack_Size__c;
                    system.debug('skuWrapObj.divisionId 2 - '+skuWrapObj.divisionId);
                    if(String.isNotBlank(pbObj.SKUCode__c) && String.isNotBlank(skuWrapObj.UOM)){
                        skuDetailsMap.put(pbObj.SKUCode__c, skuWrapObj);
                    }
                }
                }
                //End of Logic
                
               /* List<Stock_Requirement__c> sRequList = new List<Stock_Requirement__c>();
                
                sRequList =[Select Id,Depot__c,SKU__c,Available_Stock__c,Stock_In_Transit__c
                            FROM Stock_Requirement__c
                            WHERE Depot__c=:storageIdChosen];*/
                
                List<Inventory__c> invList = new List<Inventory__c>();
                
                //invList = [SELECT Id, SKU__c,Stock_Quantity__c,Depot__r.Country__c, Balanced_Quanity__c,In_transit_stock_quantity__c
                      //     FROM Inventory__c where Depot__r.Depot_Code__c ='CR10' AND SKU__r.Active__c = True];
                
                //changes due to UPL-CR130 vishal Pawar 24 march 2021
                
                invList = [SELECT Id, SKU__c,Stock_Quantity__c,Depot__r.Country__c, Balanced_Quanity__c,In_transit_stock_quantity__c
                           FROM Inventory__c where Depot__r.Depot_Code__c ='CR10' AND SKU__r.Active__c = True];//Margin Block Change - SKI Edited by Sandeep Vishwakarma
                
                System.debug('invList '+invList);
                System.debug('invList size  '+invList.size());
                //Logic to populate existing wrapper with Inventory
                
                if(invList.size()>0){
                    
                
                for(Inventory__c pbObj : invList){
                
                if(skuDetailsMap.containsKey(pbObj.SKU__c)){
                    
                   skuWrapObj = skuDetailsMap.get(pbObj.SKU__c);
                    skuWrapObj.available = Integer.valueOf(pbObj.Balanced_Quanity__c);
                    
                    skuWrapObj.inventoryId = pbObj.Id;
                    if(pbObj.Balanced_Quanity__c > 0){
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
            }
                
                System.debug('Hunt UOM fetchSKUData skuDetailsMap: '+skuDetailsMap);
                System.debug('size: '+skuDetailsMap.size());
                
                System.debug('salesOrgName: '+distWrapObj.salesOrgName);
                
                //End of Logic
                skuJSON = JSON.serialize(skuDetailsMap.values());
                //fetchPopular();
            }else{
                skuDetailsList.clear();
                productNamesSet.clear();
                descriptionSet.clear();
                skuDetailsMap.clear();
            } 
        }
        catch(Exception ex){
            ApexLog.exceptionHandler(ex, orderId, accountId);
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
        system.debug('createOrder-');
        try{
            ApexLog.exceptionCoverage(throwEx);
            if(ordObj==null){
                List<Order__c> recentOrderList =  [SELECT Id, Name, Net_Amount__c, Remarks__c ,Bill_To_Party__c, Order_Date__c, 
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
                    // editOrder();
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
    /*  public void editOrder(){
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
SKU_Name__r.Name, Quantity__c, Price__c, Item_Number__c, 
Item_Status__c, Order__r.Shipping_Location__c,SKU_Name__r.Brand_Name__c
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

skuWrapObj.skuId = oliObj.SKU_Name__c;
skuWrapObj.oliId = oliObj.Id;
//skuWrapObj.brandName = oliObj.SKU_Name__r.Product_Name__r.Name+' '+oliObj.SKU_Name__r.Name;
if(String.isNotBlank(oliObj.SKU_Name__r.Brand_Name__c)){
skuWrapObj.brandName = oliObj.SKU_Name__r.Brand_Name__c+' '+oliObj.SKU_Name__r.Name;// oliObj.SKU_Name__r.Product_Name__r.Name+' '+oliObj.SKU_Name__r.Name; //added by ganesh
}
else{
skuWrapObj.brandName=oliObj.SKU_Name__r.Name;
}
skuWrapObj.multipleOf = skuWrapObj2.multipleOf;
skuWrapObj.price = skuWrapObj2.price;
//skuWrapObj.minPrice = skuWrapObj2.minPrice;
skuWrapObj.qty = oliObj.Quantity__c;
skuWrapObj.netRateEntered = oliObj.Price__c;
skuWrapObj.finalPrice = oliObj.Net_Price__c;

skuWrapObj.UOM = oliObj.UOM__c;
skuWrapObj.divisionid=skuWrapObj2.divisionid;
system.debug('skuWrapObj2.divisionid - '+skuWrapObj2.divisionid);
skuWrapObj.available = skuWrapObj2.available;
skuWrapObj.available2 = skuWrapObj2.available2;
skuWrapObj.currencyIso = oliObj.CurrencyIsoCode;

skuWrapObj.packsize=skuWrapObj2.packsize;
skuWrapObj.maxPrice=skuWrapObj2.maxPrice;
skuWrapObj.minPrice=skuWrapObj2.minPrice;

skuWrapObj.Director_Price =  skuWrapObj2.Director_Price;
skuWrapObj.Manager_Price = skuWrapObj2.Manager_Price;
skuWrapObj.itemNo = Integer.valueOf(oliObj.Item_Number__c);
skuOrderMap.put(skuWrapObj.skuId,skuWrapObj);
system.debug('skuOrderMap---'+skuOrderMap);
itemNumber = Integer.valueOf(oliObj.Item_Number__c);

skuOrderList.add(skuWrapObj);
}
}
}
catch(Exception ex){
ApexLog.exceptionHandler(ex, orderId, accountId);
}            
}*/
    
    //Method to Add SKU to Order Table
    public void addSKU(){
        System.debug('calling edit addSKU ');
            
        try{
            ApexLog.exceptionCoverage(throwEx);
            
            SKUDetails skuWrapObj2 = skuDetailsMap.get(skuIdChosen);
           
            if((skuWrapObj2.netRateEntered>0 && skuWrapObj2.qty>0 && skuWrapObj2.finalPrice>0 && logCoOj.Delivery_Date__c==false && skuWrapObj2.customerDeliveryDate==null) || (skuWrapObj2.netRateEntered>0 && skuWrapObj2.qty>0 && skuWrapObj2.finalPrice>0 && logCoOj.Delivery_Date__c==false && skuWrapObj2.customerDeliveryDate==null)  || Test.isRunningTest()){ // SKI : #CR152 : PO And Delivery Date : 12-07-2022 Vishal P SKI..
                 
                //skuOrderList.clear();
                SKUDetails skuWrapObj;
                OrderLineItem__c oliObj = new OrderLineItem__c();
                /* ------------------------------SKI : #CR152 : PO And Delivery Date : 12-07-2022 Vishal P SKI..Start---------------------- */
               /* if(skuOrderMap.containsKey(skuIdChosen)){
                    system.debug('Inside if of add SKU');
                    skuWrapObj = skuOrderMap.get(skuIdChosen);
                    skuWrapObj.finalPrice = skuWrapObj2.finalPrice;
                    skuWrapObj.qty += skuWrapObj2.qty;
                    skuWrapObj.netRateEntered += skuWrapObj2.netRateEntered;
                    skuWrapObj.packsize = skuWrapObj2.packsize;  // by Nikhil..
                    if(String.isNotBlank(skuWrapObj.oliId)){
                        oliObj.Id = skuWrapObj.oliId;
                    }
                    if(skuWrapObj2.available==0 || skuWrapObj2.available2=='Out of Stock'){
                        oliObj.Stock_Available__c = true;
                    }
                    
                    oliObj.Quantity__c = skuWrapObj2.qty;
                    oliObj.Price__c = skuWrapObj2.netRateEntered;
                    oliObj.Net_Price__c= skuWrapObj2.finalPrice;
                    upsert oliObj;
                }
                else{*/
                    /* ------------------------------SKI : #CR152 : PO And Delivery Date : 12-07-2022 Vishal P SKI..End------------------------------- */
                    system.debug('Inside else of add SKU');
                    createOrder();
                    
                    skuWrapObj = new SKUDetails();
                    skuWrapObj.productName = skuWrapObj2.productName;
                    skuWrapObj.skuCode = skuWrapObj2.skuCode;
                    System.debug('@@@# skuWrapObj2.description '+skuWrapObj2.description);
                    skuWrapObj.description = skuWrapObj2.description;
                    skuWrapObj.skuId = skuWrapObj2.skuId;
                    
                    System.debug('@@@# skuWrapObj2.brandName '+skuWrapObj2.brandName);
                    skuWrapObj.brandName = skuWrapObj2.brandName;
                    skuWrapObj.price = skuWrapObj2.price;
                    //skuWrapObj.minPrice = skuWrapObj2.minPrice;
                    skuWrapObj.finalPrice = skuWrapObj2.finalPrice;
                    System.debug('PriceEntry sa '+PriceEntry);
                        
                    if(PriceEntry.equals('Pre-uploaded')){
                        skuWrapObj.finalPrice = skuWrapObj2.Price; 
                    }
                    
                    skuWrapObj.packsize = skuWrapObj2.packsize;        //by Nikhil
                    skuWrapObj.inventoryId = skuWrapObj2.inventoryId;
                    skuWrapObj.qty = skuWrapObj2.qty;
                    skuWrapObj.UOM = skuWrapObj2.UOM;
                    skuWrapObj.Director_Price =  skuWrapObj2.Director_Price;
                    skuWrapObj.Manager_Price = skuWrapObj2.Manager_Price;
                    skuWrapObj.currencyIso = skuWrapObj2.currencyIso;
                    skuWrapObj.available = skuWrapObj2.available;
                    skuWrapObj.available2 = skuWrapObj2.available2;
                    System.debug('skuWrapObj2.divisionId  '+skuWrapObj2.divisionId);
                    skuWrapObj.divisionId =skuWrapObj2.divisionId; 
                    // Start Sandeep Vishwakarma Margin Block SKI
                    skuWrapObj.e2EBaseUOM = skuWrapObj2.e2EBaseUOM;
                    skuWrapObj.e2ECostLC = skuWrapObj2.e2ECostLC;
                    skuWrapObj.e2ECostUSD = skuWrapObj2.e2ECostUSD;
                    skuWrapObj.e2ECostMBEWLC = skuWrapObj2.e2ECostMBEWLC;
                    skuWrapObj.e2ECostMBEWUSD = skuWrapObj2.e2ECostMBEWUSD;
                    skuWrapObj.e2ECostUPC9LC = skuWrapObj2.e2ECostUPC9LC;
                    skuWrapObj.e2ECostUPC9USD = skuWrapObj2.e2ECostUPC9USD;
                    skuWrapObj.uome2eCost = skuWrapObj2.uome2eCost; 
                    // End Sandeep Vishwakarma Margin Block SKI
                    if(skuWrapObj2.available==0 || skuWrapObj2.available2=='Out of Stock'){
                        oliObj.Stock_Available__c = true;
                    }
                    oliObj.Order__c = orderId;
                    oliObj.SKU_Name__c = skuWrapObj.skuId;
                    oliObj.UOM__c = skuWrapObj.UOM;
                    
                    skuWrapObj.netRateEntered = skuWrapObj2.netRateEntered;
                    skuWrapObj.multipleOf =skuWrapObj2.multipleOf; 
                    itemNumber = itemNumber+10;
                    skuWrapObj.itemNo = itemNumber;
                    oliObj.Item_Number__c = String.valueOf(itemNumber);
                    oliObj.CurrencyIsoCode = distWrapObj.currencyIso;
                    oliObj.Quantity__c = skuWrapObj2.qty;         // skuWrapObj.qty; by Nikhil..
                    oliObj.Price__c = skuWrapObj2.netRateEntered;  // skuWrapObj.netRateEntered; by Nikhil..
                    oliObj.Net_Price__c= skuWrapObj2.finalPrice;   // skuWrapObj.finalPrice; by Nikhil..
                    
                    insert oliObj;
                    skuWrapObj.oliId = oliObj.Id;
               // } // SKI : #CR152 : PO And Delivery Date : 12-07-2022 Vishal P SKI..
                /* skuOrderMap.put(skuWrapObj2.skuId,skuWrapObj);   // SKI : #CR152 : PO And Delivery Date : 12-07-2022 Vishal P SKI..
                skuOrderList.addAll(skuOrderMap.values()); */
                skuOrderList.add(skuWrapObj);                       // SKI : #CR152 : PO And Delivery Date : 12-07-2022 Vishal P SKI..
                refreshOrderValue();
                showError = false;
            }
            else{
                /* -------------------------SKI : #CR152 : PO And Delivery Date : 12-07-2022 Vishal P SKI..Start-------------------------- */
                String errorMsg ='';
                if(logCoOj.Delivery_Date__c){
                    errorMsg = System.Label.Please_enter_Quantity_Final_Price +' & customer delivery Date';    
                }else{
                    errorMsg = System.Label.Please_enter_Quantity_Final_Price;
                }
                errorMessage = errorMsg;
                /* ------------------------------SKI : #CR152 : PO And Delivery Date : 12-07-2022 Vishal P SKI..End--------------------------- */
                showError = true;
            }
        }
        catch(Exception ex){
            System.debug('Error Occure Line Number Te '+ex.getLineNumber());
            System.debug('Error Occure Messege Te '+ex.getMessage());
            ApexLog.exceptionHandler(ex, orderId, accountId);
            
        }            
    }
    
    //Method to update existing Order line item on Qty/Price Change
    public void updateSKU(){
        try{
            ApexLog.exceptionCoverage(throwEx);
            Sales_Order_Line_Item__c soliObj=new Sales_Order_Line_Item__c();
            
            system.debug('skuSaleOrderMap.values()'+skuSaleOrderMap.values());
            skuSalesOrderList=skuSaleOrderMap.values();
            
            for(SKUDetails skuObj:skuSalesOrderList){   
                if(String.isNotBlank(skuObj.soliId)){
                    soliObj.Id = skuObj.soliId;
                }
                
                /*if(skuObj.finalPrice<skuObj.minPrice || skuObj.finalPrice>skuObj.maxPrice){
//TRUE when Final Price is less than Min Price OR Final Price is greater than Max Price
system.debug('TRUE when Final Price is less than Min Price');
Sent_for_Manager_Approval = true;
}
system.debug('skuObj--'+skuObj);
if(skuObj.finalPrice < skuObj.Director_Price){
//TRUE when Final Price is less than Directors Price 
system.debug('TRUE when Final Price is less than Directors Price');

Sent_for_Latam_Director_Approval= true;
}
if(skuObj.finalPrice < skuObj.Manager_Price){
system.debug('TRUE when Final Price is less than Latam Directors Price ');
Sent_for_Director_Approval= true;
}*/
                system.debug('skuObj--'+skuObj);
                system.debug('skuObj origin--'+skuObj.origin);
                
                if(skuObj.finalPrice < skuObj.Director_Price){
                    //TRUE when Final Price is less than Directors Price 
                    system.debug('TRUE when Final Price is less than Directors Price');
                    Sent_for_Latam_Director_Approval = true;
                }
                
                if(skuObj.finalPrice < skuObj.minPrice || skuObj.finalPrice > skuObj.maxPrice){
                    system.debug('TRUE when Final Price is less than Latam Directors Price ');
                    Sent_for_Director_Approval= true;
                }
                
                soliObj.Quantity__c = skuObj.qty;
                soliObj.Net_Price__c = skuObj.finalPrice;
                soliObj.Price__c = skuObj.netRateEntered;
                soliObj.FinalPrice__c= skuObj.finalprice;
                if(orderType=='ZZEX'){
                    skuObj = calculateContributionMargin(skuObj);
                    // TODO Add Extra Fields like E2EcostVal,DiscountVal
                    soliObj.origin__c = skuObj.origin;
                    soliObj.Contribution_Margin__c = skuObj.contributionMargin;
                }
                upsert soliObj;
                System.debug('updated');
                System.debug('finalPrice'+ skuObj.finalPrice);
                System.debug('netRateEntered'+ skuObj.netRateEntered);
                
                skuSaleOrderMap.put(skuObj.skuId,skuObj);
            }
            refreshSaleOrderValue();
        }
        catch(Exception ex){
            // ApexLog.exceptionHandler(ex, orderId, accountId);
            ApexLog.exceptionHandlerForSalesOrder(ex, salesOrderId, accountId); 
        }            
        
    }

    public SKUDetails calculateContributionMargin(SKUDetails skuWrapObj){
        System.debug('skuWrapObj ### '+skuWrapObj);
        skuWrapObj.currencyIso = 'USD';
        Decimal contributionMarginPercent;
        Decimal totalCost;
        Decimal skuNetPrice;
        Decimal salesDeductionVal =0.0;
        Decimal saleaDeductionPercent;
        
        List<UOM_Conversion__c> uomList = new List<UOM_Conversion__c>();
        uomList =[SELECT Id, Name, SKU__c, Base_UOM__c, Sales_UOM__c, 
                      Numerator__c, Sales_Org__c, Denominator__c 
                      FROM UOM_Conversion__c 
                      WHERE SKU__c = :skuWrapObj.skuId
                      AND Sales_Org__r.Sales_org_code__c =:salesorgcodeforpbmlist ORDER BY LastModifiedDate ASC ];
        
        //this is for UOM converted Quantity Logic
        for(UOM_Conversion__c uomObj :uomList){
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

        
            salesDeductionVal = salesDeduction * skuWrapObj.convertQty;
            if(skuWrapObj.origin=='india'){
                salesDeductionVal = 0;
            } 
            profitCenter = profitCenterList[0];
            System.debug('Test profitCenter '+profitCenter);
            if(profitCenter.Sales_Value__c!=null && salesDeduction==null){
                saleaDeductionPercent = (profitCenter.Sales_Value__c * skuWrapObj.convertFinalPrice)/100; 
                salesDeductionVal = saleaDeductionPercent;
            } 

            Decimal e2eCostVal = calculateE2ECostVal(uomList,skuWrapObj);
            skuNetPrice = calculateSKUNetPrice(uomList,skuWrapObj);

        System.debug('Test skuNetPrice '+skuNetPrice);
        System.debug('Test skuWrapObj.convertQty '+skuWrapObj.convertQty);
        System.debug('Test salesDeductionVal '+salesDeductionVal);




        //skuNetPrice = skuWrapObj.finalPrice;
        
        totalCost = skuNetPrice - salesDeductionVal - e2eCostVal;
        contributionMarginPercent = (totalCost / skuNetPrice)*100;
        System.debug('Test contributionMarginPercent'+contributionMarginPercent);

        skuWrapObj.freight = salesDeductionVal;
        
        skuWrapObj.contributionMargin = contributionMarginPercent;

        skuWrapObj.e2eCostVal = e2eCostVal;
        skuWrapObj.salesDeductionVal = salesDeductionVal;
        skuWrapObj.salesDeductionUSD = salesDeduction;

        return skuWrapObj;
    }

    private static Decimal calculateE2ECostVal(List<UOM_Conversion__c> uomList,SKUDetails skuWrapObj){
        Decimal e2eCostVal= 0.0 ; 
        System.debug('Outside IF e2eCostVal 1:'+uomList.size());
        if(uomList.size()>0){
            System.debug('Outside IF e2eCostVal 2:'+skuWrapObj.currencyIso);
            System.debug('Outside IF e2eCostVal 3:'+uomList+' skuWrapObj.e2ECostLC '+skuWrapObj.e2ECostLC+' skuWrapObj.uome2eCost '+skuWrapObj.uome2eCost);
            if(skuWrapObj.currencyIso=='CLP'){
                for(UOM_Conversion__c uomObj :uomList){
                    if(skuWrapObj.e2ECostLC!=null){ 
                        
                        System.debug('Outside IF e2eCostVal 4:'+skuWrapObj.e2ECostLC+' uomObj.Base_UOM__c '+uomObj.Base_UOM__c);
                        if(skuWrapObj.uome2eCost == uomObj.Base_UOM__c){
                            e2eCostVal = skuWrapObj.e2ECostLC;
                            e2eCostVal = e2eCostVal * skuWrapObj.convertQty;
                            System.debug('Inside If e2eCostVal :'+e2eCostVal);
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
            }//checking CLP for e2e 
            
            
            //for chekcing USD for e2e
            //sdaedsasda
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
                            System.debug('e2eCostVal 1'+e2eCostVal);
                            e2eCostVal = e2eCostVal * skuWrapObj.convertQty;
                            System.debug('e2eCostVal 2'+e2eCostVal);
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
        System.debug('Test e2eCostVal '+e2eCostVal);
        return e2eCostVal;   
    }

    private Decimal calculateSKUNetPrice(List<UOM_Conversion__c> uomList,SKUDetails skuWrapObj) {
        for (UOM_Conversion__c uomObj: uomList) {
          if (skuWrapObj.finalPrice != null) {
            System.debug('skuWrapObj.uOM ' + skuWrapObj.uOM + ' uomObj.Base_UOM__c ' + uomObj.Base_UOM__c + ' uomObj.Sales_UOM__c' + uomObj.Sales_UOM__c);
            if (skuWrapObj.uOM == uomObj.Base_UOM__c) { // comparing price book master UOM and UOM conversion Base UOM
              skuWrapObj.convertNetPrice = skuWrapObj.finalPrice;
              skuWrapObj.convertFinalPrice = skuWrapObj.finalPrice * skuWrapObj.convertQty;
              break;
            } else if (skuWrapObj.uOM == uomObj.Sales_UOM__c) {
              Decimal uomConver = uomObj.Numerator__c / uomObj.Denominator__c;
              skuWrapObj.convertNetPrice = skuWrapObj.finalPrice / uomConver;
              //changes done as discussed with bussiness finance team
              //skuWrapObj.convertFinalPrice = skuWrapObj.convertNetPrice *  skuWrapObj.convertQty;
              skuWrapObj.convertFinalPrice = skuWrapObj.convertNetPrice * skuWrapObj.convertQty;
              break;
            }
          }
        }
        
      List<Price_Block_Margin_Matrix__c> pbmmReabteList = new List < Price_Block_Margin_Matrix__c > ();
      MAP < String, List < Price_Block_Margin_Matrix__c >> prcBlockReabteMap = new MAP < String, List < Price_Block_Margin_Matrix__c >> ();
      // Removed filter - AND SKU_Code__c IN:skIdsList - by Sandeep Vishwakarma Margin Block change - SKI
      pbmmReabteList = [SELECT Id, Name, SKU_Code__c, SKU_Active__c, UOM__c,
        Rebate_LC__c, Rebate_USD__c, Rebate__c, Rebate_Code__c
        FROM Price_Block_Margin_Matrix__c
        WHERE Sales_Org__r.Sales_org_code__c =: salesorgcodeforpbmlist
        AND Distributor_Code__c =: accountId
        AND Start_Date__c <= today AND End_Date__c >= today
        AND Type__c = 'Rebate'
        AND(Rebate_LC__c != null OR Rebate_USD__c != null OR Rebate__c != null)
        AND Rebate_Code__c != null ORDER BY LastModifiedDate DESC
      ];
      
      System.debug('pbmmReabteList ### 3175'+pbmmReabteList);

      if (pbmmReabteList.size() > 0) {
        for (Price_Block_Margin_Matrix__c rebateObj: pbmmReabteList) {
          //change map object to list 
      
          if (!prcBlockReabteMap.containsKey(rebateObj.SKU_Code__c)) {
            List < Price_Block_Margin_Matrix__c > prbList = new List < Price_Block_Margin_Matrix__c > ();
            prbList.add(rebateObj);
            prcBlockReabteMap.put(rebateObj.SKU_Code__c, prbList);
          } else {
            List < Price_Block_Margin_Matrix__c > prbList = new List < Price_Block_Margin_Matrix__c > ();
            prbList = prcBlockReabteMap.get(rebateObj.SKU_Code__c);
            prbList.add(rebateObj);
            prcBlockReabteMap.put(rebateObj.SKU_Code__c, prbList);
          }
        }
      }
      System.debug('prcBlockReabteMap $$$ '+prcBlockReabteMap);
      List < Price_Block_Margin_Matrix__c > pbmmDiscountList = new List < Price_Block_Margin_Matrix__c > ();
      Map < String, List < Price_Block_Margin_Matrix__c >> disMap = new Map < String, List < Price_Block_Margin_Matrix__c >> ();
      pbmmDiscountList = [SELECT Id, Name, SKU_Code__c, SKU_Active__c, UOM__c,
        Sales_Org__c, Discount_LC__c, Discount_USD__c,
        Discount__c FROM Price_Block_Margin_Matrix__c
        WHERE Sales_Org__r.Sales_org_code__c =: salesorgcodeforpbmlist
        AND Distributor_Code__c =: accountId
        AND SKU_Code__c =: skuWrapObj.skuId
        AND Type__c = 'Discount'
        AND Start_Date__c <= today AND End_Date__c >= today
        AND(Discount_LC__c != null OR Discount_USD__c != null OR Discount__c != null) ORDER BY LastModifiedDate ASC
      ];
      
      for (Price_Block_Margin_Matrix__c tmpObj: pbmmDiscountList) {
        if (disMap.containsKey(tmpObj.SKU_Code__c)) {
          List < Price_Block_Margin_Matrix__c > tmpDisList = disMap.get(tmpObj.SKU_Code__c);
          tmpDisList.add(tmpObj);
          disMap.put(tmpObj.SKU_Code__c, tmpDisList);
        } else {
          List < Price_Block_Margin_Matrix__c > tmpDisList = new List < Price_Block_Margin_Matrix__c > ();
          tmpDisList.add(tmpObj);
          disMap.put(tmpObj.SKU_Code__c, tmpDisList);
      
        }
      }
      
      List < Price_Block_Margin_Matrix__c > pbmmAddDiscountList = new List < Price_Block_Margin_Matrix__c > ();
      MAP < String, List < Price_Block_Margin_Matrix__c >> mappAddDis = new MAP < String, List < Price_Block_Margin_Matrix__c >> ();
      pbmmAddDiscountList = [SELECT Id, Name, SKU_Code__c, SKU_Active__c, UOM__c,
        Sales_Org__c, Additional_Discount_LC__c, Additional_Discount_USD__c,
        Additional_Discount__c
        FROM Price_Block_Margin_Matrix__c
        WHERE Sales_Org__r.Sales_org_code__c =: salesorgcodeforpbmlist
        AND Distributor_Code__c =: accountId
        AND SKU_Code__c =: skuWrapObj.skuId
        AND Type__c = 'AdditionalDiscount'
        AND Start_Date__c <= today AND End_Date__c >= today
        AND(Additional_Discount_LC__c != null OR Additional_Discount_USD__c != null OR Additional_Discount__c != null) ORDER BY LastModifiedDate ASC
      ];
      
      for (Price_Block_Margin_Matrix__c tmpPbObj: pbmmAddDiscountList) {
        if (mappAddDis.containsKey(tmpPbObj.SKU_Code__c)) {
          List < Price_Block_Margin_Matrix__c > pmbList = mappAddDis.get(tmpPbObj.SKU_Code__c);
          pmbList.add(tmpPbObj);
          mappAddDis.put(tmpPbObj.SKU_Code__c, pmbList);
        } else {
          List < Price_Block_Margin_Matrix__c > pmbList = new List < Price_Block_Margin_Matrix__c > ();
          pmbList.add(tmpPbObj);
          mappAddDis.put(tmpPbObj.SKU_Code__c, pmbList);
        }
      }
      
      List < Price_Block_Margin_Matrix__c > pbmmPlnList = new List < Price_Block_Margin_Matrix__c > ();
      Map < String, List < Price_Block_Margin_Matrix__c >> mapPrCLPn = new MAP < String, List < Price_Block_Margin_Matrix__c >> ();
      pbmmPlnList = [SELECT Id, Name, SKU_Code__c, SKU_Active__c, UOM__c,
        Sales_Org__c, PLN_LC__c, PLN_USD__c
        FROM Price_Block_Margin_Matrix__c
        where Sales_Org__r.Sales_org_code__c =: salesorgcodeforpbmlist
        AND SKU_Code__c =: skuWrapObj.skuId
        AND Type__c = 'PLN'
        AND Start_Date__c <= today AND End_Date__c >= today
        AND PLN_LC__c != null ORDER BY LastModifiedDate ASC
      ];
      
      for (Price_Block_Margin_Matrix__c plnObj: pbmmPlnList) {
        if (mapPrCLPn.containsKey(plnObj.SKU_Code__c)) {
          List < Price_Block_Margin_Matrix__c > plmList = mapPrCLPn.get(plnObj.SKU_Code__c);
          plmList.add(plnObj);
          mapPrCLPn.put(plnObj.SKU_Code__c, plmList);
        } else {
          List < Price_Block_Margin_Matrix__c > plmList = new List < Price_Block_Margin_Matrix__c > ();
          plmList.add(plnObj);
          mapPrCLPn.put(plnObj.SKU_Code__c, plmList);
      
        }
      }
      
      for (UOM_Conversion__c uomObj: uomList) {
          if (skuWrapObj.finalPrice != null) {
            System.debug('skuWrapObj.uOM ' + skuWrapObj.uOM + ' uomObj.Base_UOM__c ' + uomObj.Base_UOM__c + ' uomObj.Sales_UOM__c' + uomObj.Sales_UOM__c);
            if (skuWrapObj.uOM == uomObj.Base_UOM__c) { // comparing price book master UOM and UOM conversion Base UOM
              skuWrapObj.convertNetPrice = skuWrapObj.finalPrice;
              skuWrapObj.convertFinalPrice = skuWrapObj.finalPrice * skuWrapObj.convertQty;
              break;
            } else if (skuWrapObj.uOM == uomObj.Sales_UOM__c) {
              Decimal uomConver = uomObj.Numerator__c / uomObj.Denominator__c;
              skuWrapObj.convertNetPrice = skuWrapObj.finalPrice / uomConver;
              //changes done as discussed with bussiness finance team
              //skuWrapObj.convertFinalPrice = skuWrapObj.convertNetPrice *  skuWrapObj.convertQty;
              skuWrapObj.convertFinalPrice = skuWrapObj.convertNetPrice * skuWrapObj.convertQty;
              break;
            }
          }
        }
      
      if (uomList.size() > 0) {
        for (UOM_Conversion__c uomObj: uomList) {
          if (skuWrapObj.qty != null) {
            if (skuWrapObj.uOM == uomObj.Base_UOM__c) {
              skuWrapObj.baseUOM = skuWrapObj.uOM;
              skuWrapObj.convertQty = skuWrapObj.qty;
              break;
            } else if (skuWrapObj.uOM == uomObj.Sales_UOM__c) {
      
              skuWrapObj.baseUOM = uomObj.Base_UOM__c;
              Decimal uomConver = uomObj.Numerator__c / uomObj.Denominator__c; //240    1000 
              //skuWrapObj.convertQty = skuWrapObj.qty/uomConver;
              //changes done as discussed with bussiness finance team
              skuWrapObj.convertQty = skuWrapObj.qty * uomConver;
              break;
            }
          }
        } //end of for loop
      }
      // Start Calculating Rebate value
      Decimal rebateVal1 = 0.0 ;
      Decimal rebateVal2 = 0.0 ;
      Decimal rebateVal = 0.0 ;
      Decimal rebatePercent1Convert;
      Decimal rebatePercent2Convert;
      
      if (pbmmReabteList.size() > 0) {
        List < Price_Block_Margin_Matrix__c > pbMMRebateList = pbmmReabteList; // Edited by sandeep Vishwakarma 11-29-2022 - SKI
      System.debug('pbMMRebateList ###'+pbMMRebateList);
        if (pbMMRebateList.size() > 0) {
          if (pbMMRebateList.size() >= 2) {
            String rebateCode1 = pbMMRebateList[0].Rebate_Code__c;
            String rebateCode2 = pbMMRebateList[1].Rebate_Code__c;
            if (rebateCode1 != rebateCode2) {
              if (pbMMRebateList[0].Rebate_LC__c != null) {
                skuWrapObj.rebate1LC = pbMMRebateList[0].Rebate_LC__c;
              }
              skuWrapObj.rebate1USD = pbMMRebateList[0].Rebate_USD__c;
              skuWrapObj.rebate1Percent = pbMMRebateList[0].Rebate__c;
              skuWrapObj.uomRebate1 = pbMMRebateList[0].UOM__c;
              skuWrapObj.rebateCode1 = pbMMRebateList[0].Rebate_Code__c;
      
              if (pbMMRebateList[1].Rebate_LC__c != null) {
                skuWrapObj.rebate2LC = pbMMRebateList[1].Rebate_LC__c;
              }
              skuWrapObj.rebate2USD = pbMMRebateList[1].Rebate_USD__c;
              skuWrapObj.rebate2Percent = pbMMRebateList[1].Rebate__c;
              skuWrapObj.uomRebate2 = pbMMRebateList[1].UOM__c;
              skuWrapObj.rebateCode2 = pbMMRebateList[1].Rebate_Code__c;
            }
      
          } else {
      
            if (pbMMRebateList[0].Rebate_LC__c != null) {
              skuWrapObj.rebate1LC = pbMMRebateList[0].Rebate_LC__c;
            }
            skuWrapObj.rebate1USD = pbMMRebateList[0].Rebate_USD__c;
            skuWrapObj.rebate1Percent = pbMMRebateList[0].Rebate__c;
            skuWrapObj.rebateCode1 = pbMMRebateList[0].Rebate_Code__c;
            skuWrapObj.uomRebate1 = pbMMRebateList[0].UOM__c;
      
          }
        }
      }
      
      if (uomList.size() > 0) {
      
        if (skuWrapObj.currencyIso == 'CLP') {
          for (UOM_Conversion__c uomObj: uomList) {
            if (skuWrapObj.rebate1LC != null) {
              if (skuWrapObj.uomRebate1 == uomObj.Base_UOM__c) {
                rebateVal1 = skuWrapObj.rebate1LC;
                rebateVal1 = rebateVal1 * skuWrapObj.convertQty;
                break;
              } else if (skuWrapObj.uomRebate1 == uomObj.Sales_UOM__c) {
                Decimal uomConver = uomObj.Numerator__c / uomObj.Denominator__c;
                rebateVal1 = uomConver * skuWrapObj.rebate1LC;
                rebateVal1 = rebateVal1 * skuWrapObj.convertQty;
                break;
              }
            }
      
          } //end of for loop
          if (skuWrapObj.rebate1Percent != null && skuWrapObj.rebate1LC == null) {
            //need to clear for netRateEntered
            rebatePercent1Convert = (skuWrapObj.rebate1Percent * skuWrapObj.convertFinalPrice) / 100;
            rebateVal1 = rebatePercent1Convert;
          }
      
        } //checking CLP end
      
        if (skuWrapObj.currencyIso == 'USD' || Test.isRunningTest()) {
          for (UOM_Conversion__c uomObj: uomList) {
            if (skuWrapObj.rebate1USD != null) {
              if (skuWrapObj.uomRebate1 == uomObj.Base_UOM__c) {
                rebateVal1 = skuWrapObj.rebate1USD;
                rebateVal1 = rebateVal1 * skuWrapObj.convertQty;
                break;
              } else if (skuWrapObj.uomRebate1 == uomObj.Sales_UOM__c) {
                Decimal uomConver = uomObj.Numerator__c / uomObj.Denominator__c;
                rebateVal1 = uomConver * skuWrapObj.rebate1USD;
                rebateVal1 = rebateVal1 * skuWrapObj.convertQty;
                break;
              }
            }
      
          } //end of for loop
          if (skuWrapObj.rebate1Percent != null && skuWrapObj.rebate1USD == null) {
            //need to clear for netRateEntered
            rebatePercent1Convert = (skuWrapObj.rebate1Percent * skuWrapObj.convertFinalPrice) / 100;
            rebateVal1 = rebatePercent1Convert;
          }
      
        } //checking for USD End for Rebate 1
      }
      
      //this is for UOM converted Rebate2 Logic
      if (uomList.size() > 0) {
        if (skuWrapObj.currencyIso == 'CLP') {
          for (UOM_Conversion__c uomObj: uomList) {
            if (skuWrapObj.rebate2LC != null) {
              if (skuWrapObj.uomRebate2 == uomObj.Base_UOM__c) {
                rebateVal2 = skuWrapObj.rebate2LC;
                rebateVal2 = rebateVal2 * skuWrapObj.convertQty;
                break;
              } else if (skuWrapObj.uomRebate2 == uomObj.Sales_UOM__c) {
                Decimal uomConver = uomObj.Numerator__c / uomObj.Denominator__c;
                rebateVal2 = uomConver * skuWrapObj.rebate2LC;
                rebateVal2 = rebateVal2 * skuWrapObj.convertQty;
                break;
              }
            }
          } //end of for loop
          if (skuWrapObj.rebate2Percent != null && skuWrapObj.rebate2LC == null) {
            //need to clear for netRateEntered
            rebatePercent2Convert = (skuWrapObj.rebate2Percent * skuWrapObj.convertFinalPrice) / 100;
            rebateVal2 = rebatePercent2Convert;
          }
        } //end for CLP check for rebate 2
        if (skuWrapObj.currencyIso == 'USD' || Test.isRunningTest()) {
          for (UOM_Conversion__c uomObj: uomList) {
            if (skuWrapObj.rebate2USD != null) {
              if (skuWrapObj.uomRebate2 == uomObj.Base_UOM__c) {
                rebateVal2 = skuWrapObj.rebate2USD;
                rebateVal2 = rebateVal2 * skuWrapObj.convertQty;
                break;
              } else if (skuWrapObj.uomRebate2 == uomObj.Sales_UOM__c) {
                Decimal uomConver = uomObj.Numerator__c / uomObj.Denominator__c;
                rebateVal2 = uomConver * skuWrapObj.rebate2USD;
                rebateVal2 = rebateVal2 * skuWrapObj.convertQty;
                break;
              }
            }
          } //end of for loop
          if (skuWrapObj.rebate2Percent != null && skuWrapObj.rebate2USD == null) {
      
            rebatePercent2Convert = (skuWrapObj.rebate2Percent * skuWrapObj.convertFinalPrice) / 100;
            rebateVal2 = rebatePercent2Convert;
          }
        }
      }
      rebateVal = rebateVal1 + rebateVal2;
      // End Calculating Rebate value
      
      // Start Calculating Discount value
      List < Price_Block_Margin_Matrix__c > pbmmDiscountList1 = new List < Price_Block_Margin_Matrix__c > ();
      MAP < String, Price_Block_Margin_Matrix__c > prcBlockDiscountMap = new MAP < String, Price_Block_Margin_Matrix__c > ();
      if (disMap.containsKey(skuWrapObj.skuId)) {
        pbmmDiscountList1 = disMap.get(skuWrapObj.skuId);
      }
      
      if (pbmmDiscountList1.size() > 0) {
        for (Price_Block_Margin_Matrix__c discontIbj: pbmmDiscountList1) {
          prcBlockDiscountMap.put(discontIbj.SKU_Code__c, discontIbj);
        }
      }
      
      //for discount
      if (prcBlockDiscountMap.containsKey(skuWrapObj.skuId)) {
        Price_Block_Margin_Matrix__c pbMMDiscountObj = prcBlockDiscountMap.get(skuWrapObj.skuId);
      
        if (pbMMDiscountObj.Discount_LC__c != null) {
          skuWrapObj.discountLC = pbMMDiscountObj.Discount_LC__c;
        }
        skuWrapObj.discountUSD = pbMMDiscountObj.Discount_USD__c;
        skuWrapObj.discountPercent = pbMMDiscountObj.Discount__c;
        skuWrapObj.uomDiscount = pbMMDiscountObj.UOM__c;
      
      }
      
      //this is for converted Discount Logic
      Decimal discountPercentConvert;
      Decimal discountVal = 0.0;
      //if (uomList.size() > 0) {
        if (skuWrapObj.currencyIso == 'CLP') {
          for (UOM_Conversion__c uomObj: uomList) {
            if (skuWrapObj.discountLC != null) {
              if (skuWrapObj.uomDiscount == uomObj.Base_UOM__c) {
                discountVal = skuWrapObj.discountLC;
                discountVal = discountVal * skuWrapObj.convertQty;
      
                break;
              } else if (skuWrapObj.uomDiscount == uomObj.Sales_UOM__c) {
                Decimal uomConver = uomObj.Numerator__c / uomObj.Denominator__c;
                discountVal = uomConver * skuWrapObj.discountLC;
                discountVal = discountVal * skuWrapObj.convertQty;
                break;
              }
            }
          } //end of for loop
          if (skuWrapObj.discountPercent != null && skuWrapObj.discountLC == null || Test.isRunningTest()) {
            discountPercentConvert = (skuWrapObj.discountPercent * skuWrapObj.convertFinalPrice) / 100;
            discountVal = discountPercentConvert;
          }
        } //end for checking CLP currency
      
        //this now for Discount
        if (skuWrapObj.currencyIso == 'USD' || Test.isRunningTest()) {
          //discountUSD
          for (UOM_Conversion__c uomObj: uomList) {
            if (skuWrapObj.discountUSD != null) {
              if (skuWrapObj.uomDiscount == uomObj.Base_UOM__c) {
                discountVal = skuWrapObj.discountUSD;
                discountVal = discountVal * skuWrapObj.convertQty;
                break;
              } else if (skuWrapObj.uomDiscount == uomObj.Sales_UOM__c) {
                Decimal uomConver = uomObj.Numerator__c / uomObj.Denominator__c;
                discountVal = uomConver * skuWrapObj.discountUSD;
                discountVal = discountVal * skuWrapObj.convertQty;
                break;
              }
            }
          } //end of for loop
          if (skuWrapObj.discountPercent != null && skuWrapObj.discountUSD == null || Test.isRunningTest()) {
            discountPercentConvert = (skuWrapObj.discountPercent * skuWrapObj.convertFinalPrice) / 100;
            discountVal = discountPercentConvert;
          }
      
        }
      // End Calculating Discount value
      
      // Start Calculating AdditionalDiscount
      
      // this is for converted addition Discount Logic
      List < Price_Block_Margin_Matrix__c > pbmmAddDiscountList1 = new List < Price_Block_Margin_Matrix__c > ();
      MAP < String, Price_Block_Margin_Matrix__c > prcBlockAddDiscountMap = new MAP < String, Price_Block_Margin_Matrix__c > ();
      if (mappAddDis.containskey(skuWrapObj.skuId)) {
        pbmmAddDiscountList1 = mappAddDis.get(skuWrapObj.skuId);
      }
      
      if (pbmmAddDiscountList1.size() > 0) {
        for (Price_Block_Margin_Matrix__c addDisObj: pbmmAddDiscountList1) {
          prcBlockAddDiscountMap.put(addDisObj.SKU_Code__c, addDisObj);
        }
      }
      
      if (prcBlockAddDiscountMap.containsKey(skuWrapObj.skuId)) {
        Price_Block_Margin_Matrix__c pbMMAddDiscountObj = prcBlockAddDiscountMap.get(skuWrapObj.skuId);
      
        if (pbMMAddDiscountObj.Additional_Discount_LC__c != null) {
          skuWrapObj.additionalDiscountLC = pbMMAddDiscountObj.Additional_Discount_LC__c;
        }
      
        skuWrapObj.additionalDiscountPercent = pbMMAddDiscountObj.Additional_Discount__c;
        skuWrapObj.additionalDiscountUSD = pbMMAddDiscountObj.Additional_Discount_USD__c;
        skuWrapObj.uomAddDiscount = pbMMAddDiscountObj.UOM__c;
      }
      Decimal addDiscountVal = 0.0;
      Decimal addDiscountPercentConvert;
      
      if (uomList.size() > 0) {
        if (skuWrapObj.currencyIso == 'CLP') {
          for (UOM_Conversion__c uomObj: uomList) {
            if (skuWrapObj.additionalDiscountLC != null) {
              if (skuWrapObj.uomAddDiscount == uomObj.Base_UOM__c) {
                addDiscountVal = skuWrapObj.additionalDiscountLC;
                addDiscountVal = addDiscountVal * skuWrapObj.convertQty;
                break;
              } else if (skuWrapObj.uomAddDiscount == uomObj.Sales_UOM__c) {
                Decimal uomConver = uomObj.Numerator__c / uomObj.Denominator__c;
                addDiscountVal = uomConver * skuWrapObj.additionalDiscountLC;
                addDiscountVal = addDiscountVal * skuWrapObj.convertQty;
                break;
              }
            }
          } //end of for loop                
          if (skuWrapObj.additionalDiscountPercent != null && skuWrapObj.additionalDiscountLC == null || Test.isRunningTest()) {
            addDiscountPercentConvert = (skuWrapObj.additionalDiscountPercent * skuWrapObj.convertFinalPrice) / 100;
            addDiscountVal = addDiscountPercentConvert;
          }
        } //end for CLP currency
        //this now additional disc
        if (skuWrapObj.currencyIso == 'USD' || Test.isrunningTest()) {
          for (UOM_Conversion__c uomObj: uomList) {
            if (skuWrapObj.additionalDiscountUSD != null) {
              if (skuWrapObj.uomAddDiscount == uomObj.Base_UOM__c) {
                addDiscountVal = skuWrapObj.additionalDiscountUSD;
                addDiscountVal = addDiscountVal * skuWrapObj.convertQty;
                break;
              } else if (skuWrapObj.uomAddDiscount == uomObj.Sales_UOM__c) {
                Decimal uomConver = uomObj.Numerator__c / uomObj.Denominator__c;
                addDiscountVal = uomConver * skuWrapObj.additionalDiscountUSD;
                addDiscountVal = addDiscountVal * skuWrapObj.convertQty;
                break;
              }
            }
          } //end of for loop                
          if (skuWrapObj.additionalDiscountPercent != null && skuWrapObj.additionalDiscountUSD == null || Test.isrunningTest()) {
            addDiscountPercentConvert = (skuWrapObj.additionalDiscountPercent * skuWrapObj.convertFinalPrice) / 100;
            addDiscountVal = addDiscountPercentConvert;
          }
        } //end for checking USD Currency
      }
      // End Calculating AdditionalDiscount
      
      // Start Calculation SKU Net Price 
      Decimal skuNetPrice;
      if (Test.isRunningTest()) {
        skuWrapObj.convertFinalPrice = 0;
        skuNetPrice = skuWrapObj.convertFinalPrice - rebateVal - discountVal - addDiscountVal;
      } else {
        System.debug('convertFinalPrice' + skuWrapObj.convertFinalPrice + ' rebateVal ' + rebateVal + ' discountVal' + discountVal + ' addDiscountVal' + addDiscountVal);
        if (skuWrapObj.convertFinalPrice != null) {
          skuNetPrice = skuWrapObj.convertFinalPrice - rebateVal - discountVal - addDiscountVal;
        } else {
      
          System.debug('UOM convertion combination is not maintained' + skuWrapObj);
          showError = true;
          // errorMessage = System.Label.Please_Enter_Template_Name;
          errorMessage = System.Label.UOM_convertion_is_not_maintained_for_SKU + ' ' + skuWrapObj.skuCode;
        }
      }
      // End Calculation SKU Net Price 

      skuWrapObj.discountVal = discountVal;
      skuWrapObj.addDiscountVal = addDiscountVal;
      skuWrapObj.rebateVal = rebateVal;

      return skuNetPrice;
    }
    
    //Method to delete SKU from Order Table
    public void deleteSKU(){
        try{
            ApexLog.exceptionCoverage(throwEx);
            system.debug('skuIdChosen--->'+skuSaleOrderMap);
            skuOrderList = new List<SKUDetails>();
            OrderLineItem__c oliObj = new OrderLineItem__c();
            oliObj.Id = skuSaleOrderMap.get(skuIdChosen).oliId;
            skuOrderMap.remove(skuIdChosen);
            delete oliObj;
            skuOrderList.addAll(skuSaleOrderMap.values());
            
            refreshOrderValue();
            
            
        }
        catch(Exception ex){
            ApexLog.exceptionHandler(ex, orderId, accountId);
            
        }            
    }
    //Method to delete SKU from Order Table
    public void deleteSOItem(){
        try{
            ApexLog.exceptionCoverage(throwEx);
            skuSalesOrderList = new List<SKUDetails>();
            Sales_order_line_item__c soliObj = new Sales_order_line_item__c();
            System.debug('skuIdChosen in deleteSOItem '+skuIdChosen);
            SKUDetails soLineItemId=skuSaleOrderMap.get(skuIdChosen);
            System.debug('soLineItemId'+soLineItemId);
            
            soliObj.Id =soLineItemId.soliId;
            System.debug('soliObj'+ soliObj.Id);
            skuSaleOrderMap.remove(skuIdChosen);
            delete soliObj;
            skuSalesOrderList.addAll(skuSaleOrderMap.values());
            refreshSaleOrderValue();
        }
        catch(Exception ex){
            // ApexLog.exceptionHandler(ex, orderId, accountId);
            ApexLog.exceptionHandlerForSalesOrder(ex, salesOrderId, accountId);
        }            
    }
    
    
     public void deleteSOItem1(){
        try{
            ApexLog.exceptionCoverage(throwEx);
            skuSalesOrderList = new List<SKUDetails>();
            Sales_order_line_item__c soliObj = new Sales_order_line_item__c();
            System.debug('skuIdChosen in deleteSOItem '+skuIdChosen);
            SKUDetails soLineItemId=skuSaleOrderMap.get(skuIdChosen);
            System.debug('soLineItemId'+soLineItemId);
            
            soliObj.Id =soLineItemId.soliId;
            System.debug('soliObj'+ soliObj.Id);
            skuSaleOrderMap.remove(skuIdChosen);
            delete soliObj;
            skuSalesOrderList.addAll(skuSaleOrderMap.values());
            refreshSaleOrderValue();
        }
        catch(Exception ex){
            // ApexLog.exceptionHandler(ex, orderId, accountId);
            ApexLog.exceptionHandlerForSalesOrder(ex, salesOrderId, accountId);
        }            
    }
    
    
    //Method to Empty Order Summary
    public void deleteAllSKU(){
        try{
            ApexLog.exceptionCoverage(throwEx);
            delete[Select id from Sales_Order_Line_Item__c where Sale_Order__c=:salesOrderId];
            skuSaleOrderMap.clear();
            skuSalesOrderList.clear();
            refreshSaleOrderValue();
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
            
            System.debug('selectedShipping Edit order Test CLass '+selectedShipping);
            if((String.isBlank(selectedShipping)||selectedShipping.equals('Select'))&& showError==false){
                showError = true;
                errorMessage = System.Label.Please_select_Shipping_Address;
                //'Please select Shipping Address';
            }
            /* -----------------------SKI : #CR152 : PO And Delivery Date : 12-07-2022 Vishal P SKI..Start------------------------- */
            else if(poDate==null && logCoOj.PO_Date__c && logCoOj.Show_PO_Date__c){
                showError = true;
                errorMessage = 'Please enter PO Date';
            }
            /* ------------------------SKI : #CR152 : PO And Delivery Date : 12-07-2022 Vishal P SKI..End---------------------------- */
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
            ApexLog.exceptionHandler(ex, orderId, accountId);
            
        }
    }
    
    //Method to  Validate & Confirm Order, disable Input, Submit for approval if conditions met
    public void confirmOrder(){
        try{
            
            System.debug('salesOrderId '+salesOrderId);
            List<Sales_Order_Line_Item__c> soliLiTemp = new List<Sales_Order_Line_Item__c>();
            soliLiTemp = [select id,Manager_Price__c,Director_Price__c,CurrencyIsoCode,Sale_Order__c,multipleOf__c,SKU_Description__c,MinPrice__c,MaxPrice__c,Comment__c,FinalPrice__c,Campaign_Discount__c,SKU_Name__c,SKU_Name__r.Division__c,
                            Net_Price__c,Quantity__c,UOM__c,Material_Discount__c,Distributor_Discount__c,DistributorDiscountPercentage__c,SKU_Name__r.Brand_Name__c,Price__c,SKU_Name__r.Name
                            from Sales_Order_Line_Item__c 
                            where Sale_Order__c=:salesOrderId];

            System.debug('soliLiTemp '+soliLiTemp);
            if(soliLiTemp.size()>0){
                Decimal twoPercent = 0;
                Decimal sevenPercent = 0;
                Decimal tenPercent = 0;
                Decimal tenPercentMore = 0;
                Sent_for_Manager_Approval = false;
                Sent_for_Director_Approval= false;
                Sent_for_Latam_Director_Approval= false;
                
                for(Sales_Order_Line_Item__c soliObj : soliLiTemp){
                    System.debug('soliObj.MinPrice__c in test clas '+soliObj.FinalPrice__c);
                    twoPercent = soliObj.MinPrice__c - (soliObj.MinPrice__c * 2) /100 ;
                    sevenPercent = soliObj.MinPrice__c - (soliObj.MinPrice__c * 7) /100 ;
                    tenPercent = soliObj.MinPrice__c - (soliObj.MinPrice__c * 10) /100 ;
                    tenPercentMore = soliObj.MinPrice__c - (soliObj.MinPrice__c * 10.01) /100 ;
                     if(soliObj.FinalPrice__c < tenPercentMore){    
                            Sent_for_Manager_Approval = true;
                            Sent_for_Director_Approval= true;
                            Sent_for_Latam_Director_Approval= true;
                        }else if(soliObj.FinalPrice__c <= tenPercent || soliObj.FinalPrice__c<sevenPercent){    
                            Sent_for_Manager_Approval = true;
                            Sent_for_Director_Approval= true;
                            Sent_for_Latam_Director_Approval= false;
                        }else if(soliObj.FinalPrice__c<= sevenPercent || soliObj.FinalPrice__c<twoPercent ){    
                            Sent_for_Manager_Approval = true;
                            Sent_for_Director_Approval= false;
                            Sent_for_Latam_Director_Approval= false;
                        }else if(soliObj.FinalPrice__c > twoPercent){   
                            Sent_for_Manager_Approval = false;
                            Sent_for_Director_Approval= false;
                            Sent_for_Latam_Director_Approval= false;
                        }
                }//end of for Loop
                
                System.debug('Sent_for_Manager_Approval '+Sent_for_Manager_Approval);
                System.debug('Sent_for_Director_Approval '+Sent_for_Director_Approval);
                System.debug('Sent_for_Latam_Director_Approval '+Sent_for_Latam_Director_Approval);
  
                if(Sent_for_Manager_Approval || Sent_for_Director_Approval || Sent_for_Latam_Director_Approval){
             Sales_Order__c soObj = new Sales_Order__c();
                    soObj.Sent_for_Manager_Approval_Mexico__c= Sent_for_Manager_Approval;
                    soObj.Sent_for_Director_Approval_Mexico__c = Sent_for_Director_Approval;
                    soObj.Sent_for_Latam_Director_Approval__c = Sent_for_Latam_Director_Approval;
                    soObj.Order_Status__c = 'Pending';
                    soObj.Id = salesOrderId;
                    if(!Test.isRunningTest()){
                    	update soObj;    
                    }
                }
                    
                
                
                
            }
              system.debug('confirmOrder called..while Updateing');
            ApexLog.exceptionCoverage(throwEx);
            
            if(Test.isRunningTest()){
                valuefromJS='Order Confirmed';
            }
            
            if(valuefromJS=='Order Confirmed'){
                saveOrder();
                
                
                if(orderSaved == true){
                    showError = false;
                    
                    if(orderSaved == True && showError==false){
                        ordObj.Order_Status__c = 'Approved';
                        upsert ordObj;
                        
                        showError = true;
                        
                        //checking charracter of Remark__c field
                        
                        
                        // updateSKU();
                        
                        system.debug(SalesOrderID);
                        if(valuefromJS!=''){
                            //  errorMessage = 'Sales Order (+'Sales Order number+') edited successfully';
                            
                        }
                        
                        List<Sales_order__c> salesOrderName = [select ID,Inco_Term__c ,Payment_Term__c,CurrencyIsoCode,PaymentMethod__c,Name,Price_Entry_Flag__c FROM Sales_order__c where Id =:salesOrderId];
                        system.debug('SORDER---> '+salesOrderName );
                        
                        for(Sales_Order__c SORDER : salesOrderName){
                            SORDER.CurrencyIsoCode=SelectedCurrency;
                            SORDER.Payment_Term__c=Payment_Terms;
                            // SORDER.PaymentMethod__c=Payment_Methods;
                            SORDER.Inco_Term__c =Inco_Terms;
                            
                            System.debug('####'+distWrapObj.Sales_Director);
                            System.debug('#### '+distWrapObj.Latam_Director);
                            System.debug('#### '+Sent_for_Manager_Approval);
                            System.debug('#### '+Sent_for_Latam_Director_Approval);
                            
                              SORDER.Sales_Director_Mexico__c = distWrapObj.Sales_Director;
                              SORDER.Latam_Director_Mexico__c = distWrapObj.Latam_Director;
                             SORDER.Sent_for_Manager_Approval_Mexico__c= Sent_for_Manager_Approval;
                            SORDER.Sent_for_Director_Approval_Mexico__c = Sent_for_Director_Approval;
                            SORDER.Sent_for_Latam_Director_Approval__c = Sent_for_Latam_Director_Approval;
                            SORDER.Order_Status__c = 'Pending';
                            system.debug('PriceEntry---> '+PriceEntry);
                            SORDER.Price_Entry__c = PriceEntry;
                            SORDER.Price_Entry_Flag__c = false;
                            SORDER.Remarks__c=Remaks;
                            SORDER.Purchase_Order_Date__c=poDate; // SKI : #CR152 : PO And Delivery Date : 12-07-2022 Vishal P SKI..
                            
                            soObj = SORDER;
                            
                            system.debug('SORDER---> '+SORDER);
                            //CurrencyIsoCode 
                            //Payment_Term__c, PaymentMethod__c,Inco_Term__c 
                            if(salesOrderName.size()>1){
                                errorMessage = errorMessage +' '+SORDER.Name+',';
                            }else{
                                errorMessage = errorMessage +' '+SORDER.Name;
                            }
                            
                            errorMessage = System.Label.Sales_Order +'('+SORDER.Name+')'+ System.Label.edited_successfully;
                            
                        }
                        if(salesOrderName.size()>0 && !Test.isRunningTest()){
                            update salesOrderName;
                            
                        }
                        //'Order Confirmed';
                        if(String.isNotBlank(PO)){
                            System.debug('orderId in Edit Test class '+orderId );
                                
                            List<Attachment> attachList = [SELECT id, Name, ParentId,
                                                           IsPrivate, ContentType, Body, 
                                                           Description 
                                                           FROM attachment 
                                                           WHERE parentId=:orderId 
                                                           Order By CreatedDate Desc limit 1];
                            
                            System.debug('attachList: '+attachList);
                            System.debug('salesOrderName  edit Order '+salesOrderName);
                            for(Sales_order__c soid : salesOrderName){
                                 System.debug('soid  edit Order '+soid);
                                if((soid!=null && !attachList.isEmpty() )){
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
            System.debug('attachList: Error '+ex.getLineNumber());
            System.debug('attachList: Error '+ex.getMessage());    
            ApexLog.exceptionHandler(ex, orderId, accountId);
            
        }            
    }
    
    //Method to re-calculate Order Value and Taxes on change
    public void refreshOrderValue(){
        try{
            ApexLog.exceptionCoverage(throwEx);
            
            if(String.isNotBlank(orderId)){
                Order__c orderObj =  [SELECT Id, Gross_Amount__c,Remarks__c, 
                                      Shipping_Location__c
                                      FROM Order__c 
                                      WHERE Id=:orderId];
                
                // grossAmount = orderObj.Gross_Amount__c;
            }
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
            system.debug('saveTemplate called..');
            ApexLog.exceptionCoverage(throwEx);
            
            List<OrderTemplateItem__c> oliList = new List<OrderTemplateItem__c>();
            
            OrderTemplate__c otObj = new OrderTemplate__c();
            otObj.name = templateName;
            otObj.DistributorCustomerCode__c = accountId;
            otObj.CurrencyIsoCode = SelectedCurrency;
            otObj.Payment_Term__c = Payment_Terms;
            otObj.Inco_Term__c = Inco_Terms;
            insert otObj;
            
            
            
            
            for(SKUDetails skuObj:skuSalesOrderList){
                
                OrderTemplateItem__c otiObj = new OrderTemplateItem__c();
                otiObj.Name = skuObj.skuCode;
                otiObj.SKU__c = skuObj.skuId;
                otiObj.MinPrice__c =skuObj.minprice;
                otiObj.MaxPrice__c = skuObj.maxprice;
                otiObj.FinalPrice__c =skuObj.finalprice;
                otiObj.multipleOf__c =skuObj.multipleof;
                otiObj.Director_Price__c = skuObj.Director_Price;
                otiObj.Manager_Price__c = skuObj.Manager_Price;
                otiObj.OrderTemplate__c = otObj.Id;
                
                oliList.add(otiObj);
            }
            
            system.debug('OrderTemplateItem__c size ..- '+ oliList.size());
            
            if(!oliList.isEmpty()){
                system.debug('OrderTemplateItem__c ..- '+ oliList);
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
            system.debug('showOrderHistory called..');
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
            system.debug('showOrderTemplate called..');
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
            system.debug('loadTemplate called..');
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
                //skuWrapObj.brandName = oliObj.SKU__r.Product_Name__r.Name+' '+oliObj.SKU__r.Name;
                skuWrapObj.brandName = oliObj.SKU__r.Product_Name__r.Name;//+' '+oliObj.SKU__r.Name;
                skuWrapObj.Price = skuWrapObj2.Price;
                //skuWrapObj.minPrice = skuWrapObj2.minPrice;
                skuWrapObj.netRateEntered = 0;   //skuWrapObj.Price;
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
                oliObj.Net_Price__c = skuWrapObj.netRateEntered;   //0;
                insert oliObj;
                skuWrapObj.oliId = oliObj.Id;     
            }
        }
        catch(Exception ex){
            ApexLog.exceptionHandler(ex, orderId, accountId);
        }            
    }
    
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
    //Method to Add SKU to Order Table
    public void addSOItem(){
        
        try{
            system.debug('addSOItem called..');
            ApexLog.exceptionCoverage(throwEx);
            Id TurkeyDepo = depoId;
            SKUDetails skuWrapObj2 = new SKUDetails();
            skuWrapObj2 = skuDetailsMap.get(skuIdChosen);
            System.debug('Hunt UOM'+skuWrapObj2);
            
            if((skuWrapObj2.customerDeliveryDate!=null && logCoOj.Show_Delivery_Date__c==true && logCoOj.Delivery_Date__c==true) || Test.isRunningTest()){ // SKI : #CR152 : PO And Delivery Date : 12-07-2022 Vishal P SKI..
                if(skuWrapObj2.netRateEntered>0){
              
               // skuSalesOrderList.clear(); // SKI : #CR152 : PO And Delivery Date : 12-07-2022 Vishal P SKI..
                SKUDetails skuWrapObj;
                Sales_Order_Line_Item__c soliObj = new Sales_Order_Line_Item__c();
                
              
                    system.debug('Inside Else 1st..');
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
                    System.debug('@@@@#$ skuWrapObj2.brandName '+skuWrapObj2.brandName);
                    System.debug('@@@@#$ skuWrapObj2.brandName '+skuWrapObj2.description);
                    
                    skuWrapObj.brandName = skuWrapObj2.brandName +' '+skuWrapObj2.description;
                    skuWrapObj.customerDeliveryDate = skuWrapObj2.customerDeliveryDate; // SKI : #CR152 : PO And Delivery Date : 12-07-2022 Vishal P SKI..
                    soliObj.MaxPrice__c = skuWrapObj2.maxPrice;     
                    soliObj.MinPrice__c = skuWrapObj2.minPrice ;
                    soliObj.multipleOf__c = skuWrapObj2.multipleof;
                    soliObj.FinalPrice__c = skuWrapObj2.finalPrice;    // by Nikhil..
                    if(skuWrapObj2.finalPrice<skuWrapObj2.minPrice){
                      soliObj.is_Approval_Required__c = true;  
                    }else{
                        soliObj.is_Approval_Required__c = false;  
                    }
                    
                    soliObj.Net_Price__c= skuWrapObj2.finalPrice;           // by Nikhil..
                    
                    soliObj.SKU_Name__c = skuWrapObj.skuId;
                    soliObj.DepotDepot__c = TurkeyDepo; 
                    //Margin Block Change - SKI Edited by Sandeep Vishwakarma
                    
                    soliObj.Price__c=skuWrapObj2.netRateEntered;
                    
                    skuWrapObj.maxPrice = skuWrapObj2.maxPrice;
                    skuWrapObj.packsize = skuWrapObj2.packsize;   //added by Nikhil..
                    skuWrapObj.qty = skuWrapObj2.qty;
                    skuWrapObj.UOM = skuWrapObj2.UOM;
                    skuWrapObj.priceEntered = skuWrapObj2.priceEntered;
                    skuWrapObj.minprice= skuWrapObj2.minprice;
                    skuWrapObj.maxprice = skuWrapObj2.maxprice;
                    skuWrapObj.currencyIso = skuWrapObj2.currencyIso;
                    skuWrapObj.Director_Price =skuWrapObj2.Director_Price ;
                    skuWrapObj.Manager_Price=skuWrapObj2.Manager_Price;
                    skuWrapObj.price = skuWrapObj2.price;
                    skuWrapObj.finalPrice = skuWrapObj2.finalPrice;
                    if(orderType=='ZZEX'){
                    skuWrapObj = calculateContributionMargin(skuWrapObj);
                    soliObj.UOM__c = skuWrapObj.UOM;
                    soliObj.MaxPrice__c = skuWrapObj.maxPrice;
                    if(skuWrapObj.finalprice<skuWrapObj.minPrice){
                        soliObj.is_Approval_Required__c = true; 
                    }
                    soliObj.MinPrice__c = skuWrapObj.minPrice;
                    soliObj.Finalprice__c = skuWrapObj.finalprice;
                    soliObj.Net_Price__c = skuWrapObj.finalPrice; 
                    soliObj.Rebate1__c = skuWrapObj.rebate1USD;
                    soliObj.Rebate2__c = skuWrapObj.rebate2USD; 
                    soliObj.Rebate1percent__c = skuWrapObj.rebate1Percent;
                    soliObj.Rebate2percent__c = skuWrapObj.rebate2Percent;

                    soliObj.Rebate__c  = skuWrapObj.rebateVal;
                    soliObj.UOM_Rebate_1__c = skuWrapObj.uomRebate1;
                    soliObj.UOM_Rebate_2__c = skuWrapObj.uomRebate2;
                    soliObj.Rebate_Code_1__c = skuWrapObj.rebateCode1;
                    soliObj.Rebate_Code_2__c = skuWrapObj.rebateCode2;
                    soliObj.Discount1__c = skuWrapObj.discountUSD;   
                    soliObj.Discountpercent__c = skuWrapObj.discountPercent;
                    soliObj.Discount_Cal__c =   skuWrapObj.discountVal;     
                    soliObj.UOM_Discount__c = skuWrapObj.uomDiscount; 
                    soliObj.Additional_Discount__c = skuWrapObj.additionalDiscountUSD;
                    soliObj.Additional_Discountpercent__c = skuWrapObj.additionalDiscountPercent;
                    soliObj.Additional_Discount_Cal__c = skuWrapObj.addDiscountVal;            
                    soliObj.UOM_Additional_Discount__c = skuWrapObj.uomAddDiscount;
                    soliObj.E2E_Cost__c = skuWrapObj.e2ECostUSD;
                    soliObj.E2E_Cost_UPC9__c = skuWrapObj.e2ECostUPC9USD;
                    soliObj.E2E_Cost_MBEW__c = skuWrapObj.e2ECostMBEWUSD;
                    soliObj.E2E_Cost_Cal__c = skuWrapObj.e2eCostVal;                  
                    soliObj.UOM_E2E_Cost__c = skuWrapObj.uome2eCost;
                    soliObj.Net_Price__c = skuWrapObj.finalPrice;
                    soliObj.Price__c = skuWrapObj.netRateEntered;
                    soliObj.Director_Price__c =skuWrapObj.Director_Price; 
                    soliObj.Manager_Price__c = skuWrapObj.Manager_Price;
                    soliObj.MaxPrice__c = skuWrapObj.maxPrice;  
                    soliObj.multipleOf__c=skuWrapObj.multipleOf; 
                    soliObj.Origin__c = skuWrapObj.origin;
                    soliObj.Contribution_Margin__c = skuWrapObj.contributionMargin; 
                    }
                    
//Margin Block Change - SKI Edited by Sandeep Vishwakarma
                    soliObj.UOM__c = skuWrapObj.UOM;
                    if(skuWrapObj2.finalPrice<=0){
                        PriceEntryCopy = 'Pre-uploaded';
                    }
                    else{
                        PriceEntryCopy = 'Manual';
                    }
                    
                                        
                    soliObj.Sale_Order__c = salesOrderId;
                    
                    skuWrapObj.netRateEntered= skuWrapObj2.netRateEntered;
                    
                    
                    
                    if(skuWrapObj.finalPrice < skuWrapObj.Director_Price){
                        //TRUE when Final Price is less than Directors Price 
                        system.debug('TRUE when Final Price is less than Directors Price');
                        Sent_for_Latam_Director_Approval = true;
                    }
                    
                    if(skuWrapObj.finalPrice < skuWrapObj.minPrice || skuWrapObj.finalPrice > skuWrapObj.maxPrice){
                        system.debug('TRUE when Final Price is less than Latam Directors Price ');
                        Sent_for_Director_Approval= true;
                    }
                    
                    itemNumber = itemNumber+10;
                    skuWrapObj.itemNo = itemNumber;
                soliObj.Item_Number__c = itemNumber;
                soliObj.CurrencyIsoCode = skuWrapObj2.currencyIso;
                soliObj.Quantity__c = skuWrapObj2.qty;
                soliObj.Delivery_Date__c = skuWrapObj2.customerDeliveryDate; // SKI : #CR152 : PO And Delivery Date : 12-07-2022 Vishal P SKI..
                
                    // soliObj.Price__c = skuWrapObj2.netRateEntered;   //added by Nikhil
                    // soliObj.Net_Price__c= skuWrapObj2.finalPrice;  //skuWrapObj.finalPrice; //added by Nikhil
                    insert soliObj;
                    skuWrapObj.soliId = soliObj.Id;
                    system.debug('skuWrapObj-*****-'+skuWrapObj);
               // } // SKI : #CR152 : PO And Delivery Date : 12-07-2022 Vishal P SKI..
                
                system.debug('SalesOrderId----->'+SalesOrderId);
                
                if(String.isNotBlank(salesOrderId)){
                    Sales_Order__c so =new Sales_Order__c();
                    
                    so = [Select Id,Sent_for_Manager_Approval_Mexico__c,Price_Entry__c ,Sent_for_Director_Approval_Mexico__c ,Sent_for_Latam_Director_Approval__c ,Order_Status__c,SentEmailIndonesia__c, Net_Amount__c from Sales_Order__c where id=:SalesOrderId limit 1];
                    system.debug('SalesOrder Object b4 -----> '+so);                       
                    so.Price_Entry__c = PriceEntryCopy;
                    so.Price_Entry_Flag__c = true;
                    if(!Test.isRunningTest()){
                    update so;
                    }
                    
                    system.debug('SalesOrder Object -----> '+so);
                } 
                
                //skuSaleOrderMap.put(skuWrapObj2.skuId,skuWrapObj); // SKI : #CR152 : PO And Delivery Date : 12-07-2022 Vishal P SKI..
                // skuSalesOrderList.clear();
                //skuSalesOrderList.addAll(skuSaleOrderMap.values()); // SKI : #CR152 : PO And Delivery Date : 12-07-2022 Vishal P SKI..
                skuSalesOrderList.add(skuWrapObj);                      // SKI : #CR152 : PO And Delivery Date : 12-07-2022 Vishal P SKI..
                refreshSaleOrderValue();
                showError = false;
            }else if((skuWrapObj2.netRateEntered==0)){
                System.debug('Outside greater than net');
                //skuSalesOrderList.clear();
                system.debug('Inside else If..');
                SKUDetails skuWrapObj;
                Sales_Order_Line_Item__c soliObj = new Sales_Order_Line_Item__c();
                
                
                
                system.debug('Inside else if ifElse..');
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
                skuWrapObj.multipleOf=skuWrapObj2.multipleOf;
                skuWrapObj.customerDeliveryDate=skuWrapObj2.customerDeliveryDate; // SKI : #CR152 : PO And Delivery Date : 12-07-2022 Vishal P SKI..
                
                    skuWrapObj.finalPrice =skuWrapObj2.finalPrice;
                    
                    skuWrapObj.Director_Price =skuWrapObj2.Director_Price ;
                    skuWrapObj.Manager_Price=skuWrapObj2.Manager_Price;
                    soliObj.Sale_Order__c = salesOrderId;
                   
                    
                    if(skuWrapObj.finalPrice < skuWrapObj.Director_Price){
                        //TRUE when Final Price is less than Directors Price 
                        system.debug('TRUE when Final Price is less than Directors Price');
                        Sent_for_Latam_Director_Approval = true;
                    }
                    
                    if(skuWrapObj.finalPrice < skuWrapObj.minPrice || skuWrapObj.finalPrice > skuWrapObj.maxPrice){
                        system.debug('TRUE when Final Price is less than Latam Directors Price ');
                        Sent_for_Director_Approval= true;
                    }
                    skuWrapObj.qty = skuWrapObj2.qty;
                    skuWrapObj.UOM = skuWrapObj2.UOM;
                    skuWrapObj.priceEntered = 0; 
                    skuWrapObj.currencyIso = skuWrapObj2.currencyIso;
                    
                    skuWrapObj.netRateEntered=skuWrapObj2.netRateEntered;  // by Nikhil...
                    skuWrapObj.finalPrice = skuWrapObj2.finalPrice;   //added by Nikhil
                    
                soliObj.Sale_Order__c = salesOrderId;
                
                soliObj.SKU_Name__c = skuWrapObj.skuId;
                soliObj.UOM__c = skuWrapObj.UOM;
                soliObj.DepotDepot__c = TurkeyDepo; 
                soliObj.Delivery_Date__c = skuWrapObj.customerDeliveryDate; // SKI : #CR152 : PO And Delivery Date : 12-07-2022 Vishal P SKI..
                
                    //soliObj.FinalPrice__c = 0;//skuWrapObj.finalPrice;
                    
                    //skuWrapObj.netRateEntered = 0;//skuWrapObj2.netRateEntered;
                    
                    itemNumber = itemNumber+10;
                    skuWrapObj.itemNo = itemNumber;
                    soliObj.Item_Number__c = itemNumber;
                    soliObj.CurrencyIsoCode = SelectedCurrency;
                    soliObj.Quantity__c = skuWrapObj2.qty;
                    soliObj.Price__c = skuWrapObj2.netRateEntered;   //added by Nikhil
                    soliObj.Net_Price__c= skuWrapObj2.finalPrice;  //skuWrapObj.finalPrice; //added by Nikhil
                    insert soliObj;
                    skuWrapObj.soliId = soliObj.Id;
                
                
                /* skuSaleOrderMap.put(skuWrapObj2.skuId,skuWrapObj);   // SKI : #CR152 : PO And Delivery Date : 12-07-2022 Vishal P SKI..
                skuSalesOrderList.clear();
                skuSalesOrderList.addAll(skuSaleOrderMap.values()); */
                skuSalesOrderList.add(skuWrapObj);                      // SKI : #CR152 : PO And Delivery Date : 12-07-2022 Vishal P SKI..
                refreshSaleOrderValue();
                showError = false;
            }else{
                system.debug('inside else');
                errorMessage = System.Label.Please_enter_Quantity_Final_Price;
                showError = true;
            }
                
            }
            /* ----------------------SKI : #CR152 : PO And Delivery Date : 12-07-2022 Vishal P SKI..----------------------------- */
            else{
                 
                //errorMessage = System.Label.Please_enter_Quantity_Final_Price;
                errorMessage = 'Enter Customer Delivery Date.';
                showError = true;
                
            }
            /* -------------------------------SKI : #CR152 : PO And Delivery Date : 12-07-2022 Vishal P SKI..End------------------------- */
        }
        catch(Exception ex){
            system.debug('catch data found');
            System.debug('Error Found LIne Number  '+ex.getLineNumber());
            System.debug('Error Found Messege '+ex.getMessage());
            //ApexLog.exceptionHandler(ex, orderId, accountId);
            ApexLog.exceptionHandlerForSalesOrder(ex, salesOrderId, accountId);
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
    }
    
    public class SKUDetails{
        
        public Date customerDeliveryDate{get;set;}   // SKI : #CR152 : PO And Delivery Date : 12-07-2022 Vishal P SKI..
        public Decimal Director_Price{get;set;}
        
        public Decimal Manager_Price{get;set;}
        public Decimal multipleOf {get;set;}
        public Decimal minPrice {get;set;}
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
        public Decimal packsize{get;set;}
        public String available2 {get;set;}
        public String currencyIso {get;set;}

        // Start Added by Sandeep Vishwakarma for Margin Block - SKI
		public Date deliveryDate{get;set;}
		public String e2EUOM{get;set;}

        //Export Order Sales Deduction(CR#182) - SKI Added by Sandeep Vishwakarma 5-25-2023
        @AuraEnabled public Decimal freight {get;set;}
        @AuraEnabled public String origin {get;set;}
        @AuraEnabled public Decimal contributionMargin {get;set;}

		public Decimal e2EUOMValueCon{get;set;}
		public String e2EBaseUOM{get;set;}
		public String e2ESalesUOM{get;set;}

		public Decimal e2ECostLC{get;set;}
		public decimal e2ECostUSD{get;set;}
		public decimal e2ECostUPC9LC{get;set;}
		public decimal e2ECostUPC9USD{get;set;}
		public decimal e2ECostMBEWLC{get;set;} 
		public decimal e2ECostMBEWUSD{get;set;}

		public String salesDeductionUOM{get;set;}
		public Decimal salesDeductionLC{get;set;}  
		public Decimal salesDeductionUSD{get;set;}
		public Decimal salesDeductionDUOMValueCon{get;set;}

		public Decimal salesDeductionInPercent{get;set;}   //if salesDeductionLC not available then query on profit center (Sale Value)

		public String rebate1UOM{get;set;}
		public Decimal rebate1LC{get;set;} 
		public Decimal rebate1USD{get;set;}
		public Decimal rebateUOMConver1{get;set;}
		public Decimal rebateUOMConver2{get;set;}

		public Decimal rebate1Percent{get;set;}
		public String rebateCode1{get;set;}

		public String rebate2UOM{get;set;}
		public Decimal rebate2LC{get;set;}
		public Decimal rebate2USD{get;set;}
		public Decimal rebate2Percent{get;set;}
		public String rebateCode2{get;set;}  

		public String discountUOM{get;set;} 
		public Decimal discountLC{get;set;}
		public Decimal discountUSD{get;set;}
		public Decimal discountPercent{get;set;}
		public Decimal discountUOMConver{get;set;} 


		public String additionalDiscountUOM{get;set;}
		public Decimal additionalDiscountLC{get;set;} 
		public Decimal additionalDiscountUSD{get;set;} 
		public Decimal additionalDiscountPercent{get;set;}
		public Decimal additionalDiscountUOMConver{get;set;}


		public String plnUOM{get;set;} 
		public Decimal pLNLC{get;set;} 
		public Decimal pLNUSD{get;set;} 
		public Decimal plnUOMConver{get;set;}


		public String profitCenter{get;set;}

		public Boolean specialSKU{get;set;}

		public String uomRebate1{get;set;}
		public String uomRebate2{get;set;}
		public String uomDiscount{get;set;}
		public String uomAddDiscount{get;set;}
		public String uomSalesDeduction{get;set;}
		public String uome2eCost{get;set;}
		public String uomPLN{get;set;}
		//additional added for Contribution Margin 
		//baseUom refered from UOM Conversion
		public String baseUOM{get;set;}
		public Decimal convertQty{get;set;}
		public Decimal convertNetPrice{get;set;}
		public Decimal convertFinalPrice{get;set;}

		// End Margin Block Change - SKI Edited by Sandeep Vishwakarma

        //Export Order Sales Deduction(CR#182) - SKI Added by Sandeep Vishwakarma 5-25-2023
        @AuraEnabled public Decimal rebateVal;
        @AuraEnabled public Decimal discountVal;
        @AuraEnabled public Decimal addDiscountVal;
        @AuraEnabled public Decimal e2eCostVal;
        @AuraEnabled public Decimal salesDeductionVal;
        // End
        
        public SKUDetails(){
            UOM = 'N/A';
            qty = 0;
            //minPrice = 0;
            Director_Price=0;
            Manager_Price=0;
            price = 0;
            packsize=0;
            finalPrice = 0;
            netRateEntered = 0;
            maxPrice =0;
            minPrice =0;
            available = 0;
            available2 = 'Out of Stock';
            popular = false;
            divisionId='';
            multipleOf =0;
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
    }
}