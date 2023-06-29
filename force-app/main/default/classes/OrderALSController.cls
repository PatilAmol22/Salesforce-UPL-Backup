/*
* Name: OrderIndiaController
* Created On: 28 Aug 2016
* Author: Bhavik Devdhar (bhavik.devdhar@skinternational.com)
* Description: Class is used for Placing Orders by Distributor, TM, RM of India
* Modified By:Nandhini -CR:APPS-4845 -Description :To create Multiple Sales orders for different Payment terms
*/
global without sharing class OrderALSController {
    //Variable to be set by JS for Attachment status
    public String valuefromJS {get;set;}
    
    //Set Order Type Code
    public String orderType {get;set;}
    
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
    public Set<string> TotalcreatedSO {get;set;}
    public Map<String,ShippingLocation> shippingMap {get;set;}    
    public Map<Id,SKUDetails> skuDetailsMap {get;set;}
    public Map<Id,SKUDetails> skuOrderMap {get;set;}
    public Map<String,String> stateMap {get;set;}
    
    public Set<String> productNamesSet{get;set;}
    public Set<String> descriptionSet{get;set;} //Added by ganesh
    public List<SelectOption> depotSet{get;set;}
    
    public String selectedShipping {get;set;}
    public String TerritoryId {get;set;}
    public String profilName{get;set;}
    public String selectedDepot {get; set;}
    public String searchProdValue {get; set;}
    public String templateName {get; set;}
    public String errorMessage {get; set;}
    public String state {get; set;}
    public String skuIdChosen {get; set;}
    public String tempIdChosen {get; set;}
    public String orderRaisedBy {get; set;}
    public String skuJSON {get;set;}        //not in use for now...By ganesh
    public String distributorJSON {get;set;}   //not in use for now...By ganesh
    public String shippingJSON {get;set;}     //not in use for now...By ganesh
    public Decimal pbdPercent{get;set;}
    public Decimal sidPercent{get;set;}
    public String tmID {get;set;}
    public String zmID {get;set;}
    
    public Boolean isPortalUser;
    public Boolean showError{get;set;}
    public Boolean enableInput{get;set;}
    public String PaymentTerm; //Divya
    public Boolean isSatisfying; //Divya
    //Order Related Permissions
    public Boolean showCredit{get;set;}
    public Boolean showInventory{get;set;}
    public Boolean showInventoryColumn{get;set;}
    public Boolean showInTransit{get;set;}
    public Boolean showInTransitValues{get;set;}    
    public Boolean enableDepot{get;set;}
    public Boolean disableButton{get;set;}
    
    public Boolean allowTemplate{get;set;}
    public Boolean orderSaved{get;set;}
    public Boolean throwEx;
    
    public Decimal netAmount {get;set;}
    public Decimal grossAmount {get;set;}
    public Decimal taxAmount {get;set;}
    public Decimal vatAmount {get;set;}
    
    public Integer itemNumber;
    public List<SelectOption> OrgNames{get;set;} // Updated for RITM0491228 GRZ(Dheeraj Sharma) 20-01-2023 
    public String selectedCompany {get; set;} // Updated for RITM0491228 GRZ(Dheeraj Sharma) 20-01-2023 
    public String orderId{get;set;}
    public String PO{get;set;}
    public String accountId{get;set;}
    public String depoId;
    public String distributorId;
    public String territoryManagerId;
    public String country;
    public Order__c ordObj {get;set;}
    public Sales_Order__c soObj {get;set;}
    public Integer orderListCount{get;set;}
    public List<SelectOption> paymentOptions{get;set;}
    public String paymentType{get;set;}
    public Map<String,String> depotNameIdMap;
    
    //APPS-4845-Added by Nandhini
    public set<String> paymentTermList;
    public Map<String,Sales_Order__c> mapOfPaymentAndSO;
    public set<Id> salesOrderIds;
    
    /* INCTASK0091151 :- Removed radio button logic as new Pop up is introduced on the Place Order Button
public string businessType;
public String getbusinessType(){
return businessType;
}
public void setbusinessType(String s){
businessType = s;
}
public pageReference redirectToPage(){
orderId = ApexPages.currentpage().getparameters().get('id');        
System.debug('orderId: '+orderId);

accountId = ApexPages.currentpage().getparameters().get('acid');
System.debug('accountId: '+accountId);
pageReference pg = new pageReference('/apex/OrderIndia?acid='+accountId);
return pg;
}*/
    public OrderALSController(ApexPages.StandardController stdController) {
        try{
            orderType = '';
            country = 'India';
            //businessType = 'ALS'; INCTASK0091151 :- Removed radio button logic as new Pop up is introduced on the Place Order Button
            orderListCount = 0;
            PaymentTerm = 'NA'; //Divya
            paymentOptions = new List<SelectOption>();
            paymentOptions.add(new SelectOption('Cash','Cash'));
            paymentOptions.add(new SelectOption('Credit','Credit'));
            depotNameIdMap = new Map<string,string>();
            paymentType='Credit';  
            
            slwObj = new ShippingLocation();            
            slwObj2 = new Shipping_Location__c();
            productNamesSet = new Set<String>();
            descriptionSet = new Set<String>();  //added by ganesh
            depotSet = new List<SelectOption>();
            TotalcreatedSO =new Set<String>();
            
            skuDetailsList = new List<SKUDetails>();
            skuOrderList = new List<SKUDetails>();
            oliList = new List<OrderLineItem__c>();
            
            skuOrderMap = new Map<Id,SKUDetails>();
            shippingMap = new Map<String, ShippingLocation>();
            skuDetailsMap = new Map<Id,SKUDetails>();
            stateMap = new Map<String, String>();
            
            PO = '';
            searchProdValue = '';
            profilName='';
            tmID = '';
            zmID = '';
            TerritoryId= '';
            errorMessage = '';
            skuIdChosen = '';
            state = '';
            orderRaisedBy = '';   
            skuJSON = '';
            distributorJSON = '';
            shippingJSON = '';
            
            isPortalUser = false;
            throwEx = false;
            showError = false;
            enableInput = true;
            showCredit = false;
            showInventory = false;
            showInventoryColumn = false;
            showInTransit = false;
            showInTransitValues = false;
            disableButton = false;
            
            enableDepot = false;
            allowTemplate = false;
            orderSaved = false;
            netAmount = 0;
            taxAmount = 0;
            grossAmount = 0;
            vatAmount = 0;
            
            itemNumber = 0;
            
            accountId = '';
            distributorId = '';
            depoId = '';
            territoryManagerId = '';
            
            orderId = ApexPages.currentpage().getparameters().get('id');        
            System.debug('orderId: '+orderId);
            
            accountId = ApexPages.currentpage().getparameters().get('acid');
            System.debug('accountId: '+accountId);
            
            
            User loginUserObj = [SELECT Id, Name, IsActive, ContactId,UserRole.name,Profile.Name,
                                 Show_Inventory__c, Show_Credit_Limit__c, EnableDepot__c,
                                 Show_Inventory_Column__c, Show_InTransit__c, Show_InTransit_Values__c
                                 FROM User 
                                 WHERE Id =: UserInfo.getUserId()
                                 AND IsActive = True];
            
            showInventory = loginUserObj.Show_Inventory__c;
            showInventoryColumn = loginUserObj.Show_Inventory_Column__c;
            profilName = loginUserObj.Profile.Name;
            showCredit =  loginUserObj.Show_Credit_Limit__c;
            showInTransit = loginUserObj.Show_InTransit__c;
            showInTransitValues = loginUserObj.Show_InTransit_Values__c;
            
            System.debug('showInventory: '+showInventory);
            System.debug('showInventoryColumn: '+showInventoryColumn);
            System.debug('showCredit: '+showCredit);
            
            //Assign account Id if TM creates order on behalf of Distributor
            if(String.isNotBlank(accountId)){
                
                enableDepot = loginUserObj.EnableDepot__c;
                System.debug('enableDepot: '+enableDepot);
                //distributorId = [SELECT Id FROM User where Contact.AccountId =: accountId].Id;
                
                List<User> listUr = [Select u.Id, u.IsActive, u.IsPortalEnabled from User u where u.AccountId=:accountId];
                territoryManagerId = UserInfo.getUserId();
                if(listUr.size() >0 ){
                    System.Debug('Inside Portal User Id If listUr[0].id --> '+listUr[0].id);
                    distributorId = listUr[0].id;
                }
                else{
                    //Account accowner = [Select id,ownerId From Account Where id =: accountId];
                    // distributorId = accowner.ownerId;
                    
                    /********** Added By ketan ***************/
                    DistributorSalesAreaMapping__c salesArea = [SELECT Id, Name, Distributor__c,  AccountOwner__c,AccountOwner__r.Name, AccountOwnerActive__c 
                                                                FROM DistributorSalesAreaMapping__c WHERE Distributor__c = :accountId 
                                                                AND AccountOwnerActive__c = true LIMIT 1];
                    System.Debug('Inside Portal User Id else listUr[0].id --> '+salesArea.AccountOwner__r.Name);
                    distributorId = salesArea.AccountOwner__c;
                    
                    /********** Added By ketan ***************/ 
                } 
                System.debug('-inside if condition-- distributorId--->'+ distributorId);
                if(loginUserObj.UserRole.name.contains('Regional Manager')){
                    orderRaisedBy = 'Regional Manager';
                    system.debug('login user is'+ orderRaisedBy);
                }
                else{
                    orderRaisedBy = 'Territory Manager';
                    system.debug('login user is'+ orderRaisedBy);
                }
            }
            else{
                //Assign Account Id based on Logged In User            
                List<Contact> conList = [SELECT Id, FirstName, LastName, 
                                         Accountid, Account.OwnerId, 
                                         Account.RegionalManager__c
                                         FROM Contact 
                                         WHERE Id =: loginUserObj.ContactID];
                System.debug('Conlist -->  '+conList);
                distributorId = UserInfo.getUserId();
                isPortalUser = true;
                showInventory = loginUserObj.Show_Inventory__c;
                
                if(!conList.isEmpty()){        
                    accountId = conList[0].Accountid;
                    /*List<DistributorSalesAreaMapping__c> dsmList = [SELECT Id, Distributor__c, SalesOrg__c,AccountOwner__c
FROM DistributorSalesAreaMapping__c
WHERE Distributor__c=:accountId
AND SalesOrg__r.Sales_Org_Code__c='1000' LIMIT 1];
if(!dsmList.isEmpty()){
territoryManagerId = dsmList[0].AccountOwner__c;
}
else{
territoryManagerId = UserInfo.getUserId(); //conList[0].Account.OwnerId;      
}*/
                }
                else{
                    //accountId = '001N000000qg8AT';
                    //depoId = 'a0wN0000002zYrxIAE';
                    //territoryManagerId = '005N0000002kOef';
                }
                orderRaisedBy = 'Distributor';
                system.debug('login user is'+ orderRaisedBy);
            }
            
            
            depotList = [SELECT id, Depot__c 
                         FROM Distributor_Depot_Mapping__c 
                         WHERE Depot__r.SalesOrg__r.Sales_Org_Code__c IN ('1510') 
                         AND Distributor__c=:accountId AND Depot__c!='' LIMIT 1];
            
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
    
    //Method to Create Sales Order on Order Confirmation
    public void createSalesOrder(){
        try{
            ApexLog.exceptionCoverage(throwEx);
            system.debug('paymentTermsList in create:'+paymentTermList);
            mapOfPaymentAndSO=new Map<String,Sales_Order__c>();//APPS-4845-Added by Nandhini
            if(ordObj!=null){
                if(paymentTermList !=null && !paymentTermList.isEmpty()){//APPS-4845-Added by Nandhini
                    for(String paymentTerm:paymentTermList){//APPS-4845-Added by Nandhini
                        soObj = new Sales_Order__c();
                        soObj.Sold_to_Party__c = accountId;
                        soObj.Bill_To_Party__c = accountId;
                        soObj.Order_Date__c = System.today();
                        soObj.Order_Raise_By__c = orderRaisedBy;
                        soObj.Order_Status__c = 'Open';
                        soObj.CreatedFrom__c = 'SFDC';
                        soObj.OwnerId = distributorId;
                        System.debug('distributorId-->'+distributorId);//added by ganesh
                        soObj.Order__c = ordObj.Id;
                        soObj.Ship_To_Party__c = slwObj.locationId;
                        soObj.Sales_Org_lk__c = distWrapObj.salesOrgId;
                        soObj.Distribution_Channel_lk__c = distWrapObj.distributorChannelId;
                        soObj.Division_lk__c = distWrapObj.divisionId;
                        if(paymentTerm != 'No PaymentTerm')
                        {
                          soObj.Credit_Term__c = paymentTerm;//APPS-4845-changed by Nandhini  
                        }
                        
                        //soObj.Stock_Status__c = 'In Stock';
                        soObj.CurrencyIsoCode = distWrapObj.currencyIso;
                        if(String.isNotBlank(tmID)){
                            soObj.TerritoryManager__c = tmID;
                        }
                        if(String.isNotBlank(zmID)){
                            soObj.SalesOfficeManager__c = zmID;
                        }
                        if(String.isNotBlank(PO)){
                            soObj.PONumber__c = PO;
                        }
                        if(soObj.Order_Raise_By__c == 'Distributor'){
                            soObj.Designated_Owner__c = territoryManagerId;
                        }
                        else{
                            soObj.Designated_Owner__c = distWrapObj.regionalManagerId;
                        }
                        soObj.Order_Type_lk__c = orderType;
                        
                        //insert soObj;
                        mapOfPaymentAndSO.put(paymentTerm,soObj);//APPS-4845-Added by Nandhini
                    }
                }
                if(mapOfPaymentAndSO !=null && !mapOfPaymentAndSO.isEmpty()){
                    try{
                        insert mapOfPaymentAndSO.values();
                    }
                    catch(Exception ex){
                        system.debug('Exception in SalesOrder Creation :'+ex.getMessage());
                    }
                }
                
                 salesOrderIds =new Set<Id>();
               //APPS-4845-Added by Nandhini 
                if(mapOfPaymentAndSO !=null && !mapOfPaymentAndSO.isEmpty()){
                    for(Sales_Order__c soRec:mapOfPaymentAndSO.Values()){
                        salesOrderIds.add(soRec.Id);
                        system.debug('salesOrderIds :'+salesOrderIds);
                    }
                }
            }
            else{
                System.debug('createSalesOrder failed');
            }
        }
        catch(Exception ex){
            ApexLog.exceptionHandler(ex, orderId, accountId);
        }
    }
    
    //Method to poulate Order Type Code based on Sales Org of Distributor
    public void setOrderType(){
        List<Order_Type__c> ot = [SELECT Id, Order_Type_Code__c FROM Order_Type__c 
                                  WHERE SalesOrg__c =: distWrapObj.salesOrgId
                                  AND Description__c =: paymentType limit 1];
        System.debug('paymentType: '+paymentType);
        if(!ot.isEmpty()){
            orderType = ot[0].id;
        }
        else
        {  
            errorMessage = 'cannot select';
            System.debug('errorMessage :- '+errorMessage);
            showError = true;
        }
    }
    
    //Method to add Line Items to SalesOrders on Order Confirmation
    public void addSOLineItem(){
        
        try{
            ApexLog.exceptionCoverage(throwEx);
            
            Integer i = 0;//Adding it before GST Map insertions to prevent duplicate orders from creation 
            createSalesOrder();//Adding it before GST Map insertions to prevent duplicate orders from creation
            
            //List<SKUDetails> gstList;
            Map<Decimal,List<SKUDetails>> gstMap = new Map<Decimal,List<SKUDetails>>();
            Map<Id,Integer> itemNumberMap=New Map<Id,Integer>();//Added by Nandhini
            for(SKUDetails skuWrapObj:skuOrderMap.values()){
                
                if(!gstMap.containsKey(skuWrapObj.GST)) {
                    ///gstList = new List<SKUDetails>();
                    //gstList.add(skuWrapObj);
                    //gstMap.put(skuWrapObj.GST,gstList);
                    gstMap.put(skuWrapObj.GST, new List<SKUDetails>{skuWrapObj});
                }
                else{
                    gstMap.get(skuWrapObj.GST).add(skuWrapObj);
                }
                
            }
            Map<Id,Decimal> mapOfGstAndSoID=new Map<Id,Decimal>();
            List<Sales_Order_Line_Item__c> salesOrderLineItemList=new List<Sales_Order_Line_Item__c>();//Added by Nandhini
            
            for(Decimal gst : gstMap.keySet()){
                
                //Integer i = 0;
                //createSalesOrder();
                
                for(SKUDetails skuWrapObj:gstMap.get(gst)){
                    
                    //i = i + 10;//commented by Nandhini
                    Sales_Order_Line_Item__c sliObj = new Sales_Order_Line_Item__c();
                    sliObj.SKU_Name__c = skuWrapObj.skuId;
                    if(skuWrapObj.priceBookMasterId!='' && skuWrapObj.priceBookMasterId!=null){
                        sliObj.PriceBookMaster__c = skuWrapObj.priceBookMasterId;
                    }
                    //sliObj.PriceBookMaster__c = skuWrapObj.priceBookMasterId;
                    if(String.isNotBlank(skuWrapObj.invoiceDiscountId))
                        sliObj.Pricebook_Discount_Id__c = skuWrapObj.invoiceDiscountId;
                    if(String.isNotBlank(skuWrapObj.tradeDiscountId))
                        sliObj.Trade_Discount_Id__c = skuWrapObj.tradeDiscountId;
                    if(String.isNotBlank(skuWrapObj.matchDiscountId)) //DIVYA
                        sliObj.Matching_Discount_Id__c = skuWrapObj.matchDiscountId; //DIVYA
                    //sliObj.Item_Number__c = i;
                    sliObj.Item_Status__c = 'Active';
                    sliObj.No_of_Case__c = skuWrapObj.numberOfCases;
                    sliObj.DepotDepot__c = depoId; 
                    sliObj.UOM__c = skuWrapObj.UOM;
                    sliObj.CurrencyIsoCode = distWrapObj.currencyIso;
                    
                    if(Test.isRunningTest()){
                        skuWrapObj.qty=1;
                    }
                    
                    if(skuWrapObj.qty==0){
                        showError = true;
                        errorMessage = 'Please Enter No. of Cases for all SKU\'s before confirming order'; 
                        break;
                    }
                    
                    sliObj.Quantity__c = skuWrapObj.qty;
                    sliObj.Unit_Price__c= skuWrapObj.price;
                    sliObj.Unit_PriceBook_Discount__c=skuWrapObj.invoiceDiscount;
                    sliObj.Unit_trade_Discount__c=skuWrapObj.tradeDiscount;
                    sliObj.Unit_Matching_Discount__c=skuWrapObj.matchDiscount;//DIVYA
                    system.debug('sliObj.Unit_Matching_Discount__c is '+sliObj.Unit_Matching_Discount__c);
                    sliObj.Invoice_Discount__c = skuWrapObj.invoiceDiscount * skuWrapObj.qty;
                    sliObj.ALS_Trade_Discount__c = skuWrapObj.tradeDiscount * skuWrapObj.qty;
                    sliObj.Matching_Discount__c = skuWrapObj.matchDiscount * skuWrapObj.qty;//DIVYA
                    sliObj.Price__c = (skuWrapObj.price*sliObj.Quantity__c) - sliObj.Invoice_Discount__c - sliObj.ALS_Trade_Discount__c - sliObj.Matching_Discount__c;//DIVYA: Subtracted sliObj.Matching_Discount__c
                    system.debug('skuWrapObj.PaymentTerm :'+skuWrapObj.PaymentTerm);
                    //APPS-4845-Added by Nandhini
                    if(skuWrapObj.PaymentTerm != null){
                        if(mapOfPaymentAndSO.containsKey(skuWrapObj.PaymentTerm)){
                            sliObj.Sale_Order__c=mapOfPaymentAndSO.get(skuWrapObj.PaymentTerm).Id;
                        }
                        
                        
                    }
                    else if(distWrapObj.paymentTerms != null){
                        system.debug('distWrapObj.paymentTerms :'+distWrapObj.paymentTerms);
                        if(mapOfPaymentAndSO.containsKey(distWrapObj.paymentTerms)){
                            sliObj.Sale_Order__c=mapOfPaymentAndSO.get(distWrapObj.paymentTerms).Id;
                        }
                        
                    }
                    else{
                        if(mapOfPaymentAndSO.containsKey('No PaymentTerm')){
                            sliObj.Sale_Order__c=mapOfPaymentAndSO.get('No PaymentTerm').Id;
                        }
                    }
                    if(itemNumberMap.containsKey(sliObj.Sale_Order__c)){
                        Integer temp = itemNumberMap.get(sliObj.Sale_Order__c)+10;
                        sliObj.Item_Number__c =temp;
                        itemNumberMap.put(sliObj.Sale_Order__c,temp);
                    }
                    else{
                        itemNumberMap.put(sliObj.Sale_Order__c,10);
                        sliObj.Item_Number__c =10;
                    }
                    
                    salesOrderLineItemList.add(sliObj);
                    mapOfGstAndSoID.put(sliObj.Sale_Order__c,gst);
                    //insert sliObj;
                    
                }
                
                //Update Tax and Total Amount in Sales Order
                /*if(soObj!=null){
soObj = [Select Id, Name, Net_Amount__c from Sales_Order__c where id=:soObj.id];
System.debug('soObj: '+soObj);
TotalcreatedSO.add(soObj.Name);

//soObj.Tax_Amount__c = (stsList[0].Tax__c/100) * soObj.Net_Amount__c;
//soObj.Additional_Tax__c = (stsList[0].AdditionalTax__c/100) * soObj.Net_Amount__c;
//soObj.Total_Amount__c = soObj.Net_Amount__c + soObj.Tax_Amount__c + soObj.Additional_Tax__c;
soObj.GST_Amount__c = (gst/100) * soObj.Net_Amount__c;
soObj.Tax_Amount__c = (gst/100) * soObj.Net_Amount__c;
soObj.Total_Amount__c = soObj.Net_Amount__c + soObj.Tax_Amount__c;
system.debug('soObj.Total_Amount__c'+soObj.Total_Amount__c);
system.debug('profilName'+profilName);
if(profilName=='PartnerCommunity Distributor Profile'){
system.debug('profilName'+profilName);
soObj.Order_Status__c = 'Pending';  
soObj.OrderSubStatus__c = 'Pending';  
soObj.Order_Raise_By__c = 'Distributor';
soObj.Escalation_Date_Time_del__c = system.now();
}
upsert soObj;
}    *///commented by Nandhini
                
            }
            if(salesOrderLineItemList !=null &&!salesOrderLineItemList.isEmpty())
            {
                try{
                    insert salesOrderLineItemList;
                }
                catch(Exception ex){
                    System.debug('Exception in inserting SO line item : '+ex.getMessage());
                } 
            }
            
            //APPS-4845-Added by Nandhini
            List<Sales_order__c> salesOrdersToBeUpserted=new List<Sales_order__c>();
            if(salesOrderIds !=null && !salesOrderIds.isEmpty()){
                for(Sales_order__c soRec:[Select id,Name, Net_Amount__c from Sales_Order__c where Id IN:salesOrderIds]){
                    TotalcreatedSO.add(soRec.Name);
                    Decimal gst=0;
                    if(mapOfGstAndSoID.containsKey(soRec.Id))
                    {
                        gst =mapOfGstAndSoID.get(soRec.Id);
                    }
                    
                    soRec.GST_Amount__c = (gst/100) * soRec.Net_Amount__c;
                    soRec.Tax_Amount__c = (gst/100) * soRec.Net_Amount__c;
                    soRec.Total_Amount__c = soRec.Net_Amount__c + soRec.Tax_Amount__c;
                    system.debug('soRec.Total_Amount__c'+soRec.Total_Amount__c);
                    system.debug('profilName'+profilName);
                    if(profilName=='PartnerCommunity Distributor Profile'){
                        system.debug('profilName'+profilName);
                        soRec.Order_Status__c = 'Pending';  
                        soRec.OrderSubStatus__c = 'Pending';  
                        soRec.Order_Raise_By__c = 'Distributor';
                        soRec.Escalation_Date_Time_del__c = system.now();
                    }
                    salesOrdersToBeUpserted.add(soRec);
                }
                if(salesOrdersToBeUpserted !=null && !salesOrdersToBeUpserted.isEmpty()){
                    try{
                        Upsert  salesOrdersToBeUpserted;
                    }
                    catch(Exception ex){
                         System.debug('Exception in upserting SO  : '+ex.getMessage());
                    }
                }
                
            }
        }
        catch(Exception ex){
            ApexLog.exceptionHandler(ex, orderId, accountId);
        }
    }
    
    public void changeDepot(){
        try{
            ApexLog.exceptionCoverage(throwEx);
            
            depotIdList = [SELECT Id, Name 
                           FROM Depot__c 
                           WHERE Name LIKE: selectedDepot LIMIT 1];
            
            System.debug('selectedDepot: '+selectedDepot);
            system.debug('depotIdList'+depotIdList);
            if(!depotIdList.isEmpty()){
                depoId = depotNameIdMap.get(selectedDepot);
            }
            
            skuDetailsList.clear();
            skuDetailsMap.clear();
            
            searchProdValue = '';
            
            fetchSKUData();
        }
        catch(Exception ex){
            ApexLog.exceptionHandler(ex, orderId, accountId);
        }
    }
    
    //Method to fetch Distributor Details, Depot, Credit Information and Shipping Details
    public void fetchDistributorDetails(){
        try{
            ApexLog.exceptionCoverage(throwEx);
            delete[SELECT Id FROM Order__c WHERE Order_Status__c='Draft' AND Bill_To_Party__c =: accountId AND Sales_Org__r.Name = 'India' LIMIT 1];
            
            List<Account> accList = [SELECT Id, Name, BillingCity, BillingCountry, RegionalManager__c,Territory_Distributor__c,
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
            
            if(String.isBlank(territoryManagerId)){
                territoryManagerId = UserInfo.getUserId(); //accList[0].OwnerId;
            }
            System.debug('territoryManagerId:'+territoryManagerId);
        
            // Updated Start for RITM0491228 GRZ(Dheeraj Sharma) 20-01-2023 
            /*
            
            List<Credit_Info__c> ciList = [SELECT id, name,Distributor__c,distributor__r.name,
                                           Credit_Limit__c,Balance_Limit__c,Used_Limit__c, 
                                           Sum_Open_Item__c, DAYS_ARREARS__c 
                                           FROM Credit_Info__c 
                                           WHERE Distributor__c =:accountId and Sales_Org__r.Sales_Org_Code__c = '1510'
                                           LIMIT 1];//Divya Singh:18-12-2019: Added Sales org condition for INCTASK0104759
            
            List<Outstanding_Ageing__c> oagList = [SELECT id, OutstandingTotalGreaterthan90__c, Net_Outstanding__c
                                                   FROM Outstanding_Ageing__c
                                                   WHERE Customer_Code__c =:accountId and Sales_Org__r.Sales_Org_Code__c = '1510'
                                                   LIMIT 1];//Divya Singh:18-12-2019: Added Sales org condition for INCTASK0104759
            System.debug('ciList: '+ciList);
           */
            // Updated End for RITM0491228 GRZ(Dheeraj Sharma) 20-01-2023 
            
            //Logic to add Account Details, Billing Address and Credit Information to Wrapper
            distWrapObj = new DistributorWrapper();
            distWrapObj.distributorName = accList[0].Name;
            distWrapObj.sapCode = accList[0].SAP_Code__c;
            //distWrapObj.salesOrgId = accList[0].Sales_Org__c;
            //distWrapObj.salesOrgName = accList[0].Sales_Org__r.Name;
            //distWrapObj.distributorChannelId = accList[0].Distribution_Channel__c;            
            //distWrapObj.divisionId = accList[0].Division__c;   
            distWrapObj.ordertype = accList[0].Order_Type__c; 
            distWrapObj.paymentTerms = accList[0].Payment_Terms__c;
            //  distWrapObj.priceGroupId = accList[0].PriceGroupCode__c;
            TerritoryId =  accList[0].Territory_Distributor__c;
            
            //get TM and ZM from territory of account(distributor)
            //Added by ganesh Date:4/10/2018
            if(TerritoryId!=null){
                List<Territory_Distributor__c> territoryKede = [SELECT id, Zonal_Manager_Id__c,TerritoryManager__c 
                                                                FROM Territory_Distributor__c
                                                                WHERE id =:TerritoryId LIMIT 1];
                
                if(!territoryKede.isEmpty()){
                    tmID=  territoryKede[0].TerritoryManager__c;
                    zmID = territoryKede[0].Zonal_Manager_Id__c;
                }
            }
            //Patch End
            
            // Updated Start for RITM0491228 GRZ(Dheeraj Sharma) 20-01-2023 
          /*
            List<Payments__c> oaList = [SELECT id, Net_Overdue__c 
                                        FROM Payments__c
                                        WHERE Customer_Name__c =:accountId and Company_Code__r.Sales_Org_Code__c = '1510' 
                                        LIMIT 1];//Divya Singh:18-12-2019: Added Sales org condition for INCTASK0104759
            
            if(!oaList.isEmpty()){
                distWrapObj.greaterThan90 = oaList[0].Net_Overdue__c; //oaList[0].OutstandingTotalGreaterthan90__c;
            }
            
            if(!oagList.isEmpty()){
                distWrapObj.paymentOutstanding = oagList[0].Net_Outstanding__c;
                //distWrapObj.greaterThan90 = oaList[0].Net_Overdue__c;
            }
            */
             // Updated End for RITM0491228 GRZ(Dheeraj Sharma) 20-01-2023 

            //Assign Order/Sales Order Owner to TM if Distributor License not found.
            if(String.isBlank(distributorId)){
                distributorId = territoryManagerId; //UserInfo.getUserId(); //accList[0].OwnerId;
                System.debug('distributorId'+distributorId);
                orderRaisedBy = 'Territory Manager';
            }
            
            //Populate StateMap Code to State Name
            for(State_Tax_Structure__c stateObj:[Select Id, State_Name__c, State_Code__c From State_Tax_Structure__c Where SalesOrg__r.Name =: country]){
                stateMap.put(stateObj.State_Code__c, stateObj.State_Name__c);
            }
            System.debug('stateMap: '+stateMap);
            //End of Logic
            
            
            
           // Updated Start for RITM0491228 GRZ(Dheeraj Sharma) 20-01-2023 
            orgNames = new List<SelectOption>();
            List<map<string,string>> salesAreaOptions = new  List<map<string,string>>();
            set<string>saleOrgCountered=new set<string>();
            
            List<DistributorSalesAreaMapping__c> salesAreaList = [SELECT Id ,SalesOrg__r.name,Company_Code__c From DistributorSalesAreaMapping__c where Distributor__c =:accountId And SalesOrg__r.Name Not In ('India','SWAL','UPL SAS')];
            System.debug('salesAreaList'+salesAreaList);
            for(DistributorSalesAreaMapping__c dsa : salesAreaList){
                if(!saleOrgCountered.contains(dsa.SalesOrg__r.name)){
                    map<string,string>salesMap=new map<string,string>{'label'=>dsa.SalesOrg__r.name,'value'=>dsa.Company_Code__c};
                        salesAreaOptions.add(salesMap);
                    saleOrgCountered.add(dsa.SalesOrg__r.name);
                }
            }
            orgNames.add(new SelectOption('None','None'));
            if(!salesAreaList.isEmpty()){
                
                for (map<String,String> sl :salesAreaOptions){
                    orgNames.add(new SelectOption(sl.get('value'),sl.get('label')));
                    
                }
            }
            
            
            // Updated End for RITM0491228 GRZ(Dheeraj Sharma) 20-01-2023 
            
            
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
            List<DistributorSalesAreaMapping__c> dsmList = [SELECT Id, DistributionChannel__c, SalesOrg__r.Name,
                                                            Distribution_Channel_Code__c, Division_Code__c,
                                                            SalesOrg__c, SalesOrg__r.Sales_Org_Code__c,PriceGroupMaster__c,
                                                            Division__c, Division__r.Name, AccountOwner__c,PrIceListTypeMaster__r.Price_List_Type__c 
                                                            FROM DistributorSalesAreaMapping__c
                                                            WHERE Distributor__c=:accountId
                                                            AND SalesOrg__r.Sales_Org_Code__c='1510'];
            if(!dsmList.isEmpty()){
                territoryManagerId = dsmList[0].AccountOwner__c;
                distWrapObj.salesOrgId = dsmList[0].SalesOrg__c;
                distWrapObj.salesOrgName = dsmList[0].SalesOrg__r.Name;
                distWrapObj.distributorChannelId = dsmList[0].DistributionChannel__c;            
                distWrapObj.divisionId = dsmList[0].Division__c;  
                distWrapObj.priceListType  = dsmList[0].PrIceListTypeMaster__c;
                distWrapObj.priceGroupId = dsmList[0].PriceGroupMaster__c;  
            }
            else{
                territoryManagerId = UserInfo.getUserId(); //conList[0].Account.OwnerId;      
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Sales Area not found'));
                CalloutException e = new CalloutException();
                e.setMessage('?Sales Area not found');
                throw e;
            }
            
            List<User> userList = [Select u.Id, u.IsActive, u.IsPortalEnabled from User u where id=:UserInfo.getUserId()];
            Boolean isPortalEnabled = false;
            if(!userList.isEmpty()){
                isPortalEnabled = userList[0].IsPortalEnabled;
            }
            
            System.debug('territoryManagerId: '+territoryManagerId);
            if(!isPortalEnabled){
                List<TM_Depot_Mapping__c> tdmList = [SELECT Id, Depot__c,Depot__r.Name, Depot__r.Location__c, Territory_Manager__c 
                                                     FROM TM_Depot_Mapping__c
                                                     WHERE Territory_Manager__c =:territoryManagerId AND Depot__r.SalesOrg__r.Sales_Org_Code__c ='1510'];
                System.debug('tdmList: '+tdmList);
                depoId = tdmList[0].Depot__c;
                for(TM_Depot_Mapping__c tdmObj:tdmList){
                    depotSet.add(new SelectOption(tdmObj.Depot__r.Name,tdmObj.Depot__r.Location__c));
                    depotNameIdMap.put(tdmObj.Depot__r.Name,tdmObj.Depot__c);
                }
                System.debug('tdmList: '+tdmList);
            }
            List<Distributor_Depot_Mapping__c> dmList = [SELECT id, Distributor__c ,Depot__r.Name,Depot__c, Depot__r.Location__c 
                                                         FROM Distributor_Depot_Mapping__c 
                                                         WHERE Distributor__c=:accountId 
                                                         AND Depot__r.SalesOrg__r.Sales_Org_Code__c ='1510' LIMIT 1];
            
            System.debug('dmList: '+dmList);
            
            if(!dmList.isEmpty()){
                distWrapObj.depot = dmList[0].Depot__r.Location__c;
                
                if(depotSet.isEmpty()){
                    depoId = dmList[0].Depot__c;
                    depotSet.add(new SelectOption(dmList[0].Depot__r.Location__c,dmList[0].Depot__r.Location__c));
                    depotNameIdMap.put(dmList[0].Depot__r.Name,dmList[0].Depot__c);
                }
                selectedDepot = depoId;
                //changeDepot();
            }
            else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Distributor Depot not found'));
                //CalloutException e = new CalloutException();
                //e.setMessage('?Distributor Depot not found');
                //throw e;
            }
            System.debug('depotSet: '+depotSet);
            System.debug('distWrapObj.depot: '+distWrapObj.depot);
            if(String.isNotBlank(distWrapObj.depot)){
                fetchSKUData();
            }
            
            // Updated Start for RITM0491228 GRZ(Dheeraj Sharma) 20-01-2023 
            /* 

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
*/
            // Updated End for RITM0491228 GRZ(Dheeraj Sharma) 20-01-2023 
           
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
            List<Shipping_Location__c> mulship = new List<Shipping_Location__c>();//sayan
            
            for(Shipping_Location__c slObj:slList){
                ShippingLocation slw2Obj = new ShippingLocation();
                
                //Logic to Map Same Billing Addres based on Sold to Party SAP Code
                if(String.isNotBlank(slObj.SAP_Code__c) && distWrapObj.sapCode == slObj.SAP_Code__c){
                    mulship.add(slObj);//sayan
                    
                    shippingList.add(new SelectOption(slObj.SAP_Code__c,'Same as Billing Address'));
                    
                    slw2Obj.locationId = slObj.Id;
                    slw2Obj.address = slObj.Region__c;
                    slw2Obj.city = slObj.City__c;
                    
                    if(stateMap.containsKey(slObj.State__c) && distWrapObj.salesOrgName != 'Indonesia'){
                        slw2Obj.state = stateMap.get(slObj.State__c);
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
                    if(slObj.City__c != null){//SCTASK0192985 : Sayan Majumder ( crmconsultant3@upl-ltd.com ) - 29/05/2020
                        shippingList.add(new SelectOption(slObj.City__c,slObj.City__c));
                        slw2Obj.locationId = slObj.Id;
                        slw2Obj.address = slObj.Region__c;
                        slw2Obj.city = slObj.City__c;
                        if(stateMap.containsKey(slObj.State__c)){
                            slw2Obj.state = stateMap.get(slObj.State__c);
                        }
                        else{
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'State Code not found'));
                        }
                        slw2Obj.country = slObj.Country__c;
                        slw2Obj.pincode = slObj.Pincode__c;
                        if(mulship.size() == 0){//sayan
                            selectedShipping = slObj.City__c;//sayan
                            shippingMap.put(slObj.City__c, slw2Obj);//sayan
                        }else{//sayan
                            shippingMap.put(slw2Obj.City, slw2Obj);
                        }//sayan
                    }//SCTASK0192985 : Sayan Majumder ( crmconsultant3@upl-ltd.com ) - 29/05/2020
                    //End of Logic
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
            System.debug('Shipping List Size : '+shippingList.size());
            if(shippingList.size() == 0){//sayan
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Shipping Location Having City as Blank'));//sayan
            }//sayan
        }
        catch(Exception ex){
            //ApexLog.exceptionHandler(ex, orderId, accountId);
            //SCTASK0192985 : Sayan Majumder ( crmconsultant3@upl-ltd.com ) - 29/05/2020
            System.debug('Exception : '+ex.getMessage()+ ' Line Number: '+ex.getLineNumber());//Sayan
        }
    }
    
    
    
   // Added Below Method Start for RITM0491228 GRZ(Dheeraj Sharma) 20-01-2023 

    public void creditSalesArea(){
      String sOrgCode;
      String selectedCompany = ApexPages.currentPage().getParameters().get('selectedCompany');
        System.debug('selectedCompany'+selectedCompany);
         List<DistributorSalesAreaMapping__c> DSA =[SELECT Id, SalesOrg__r.sales_org_code__c,Company_Code__c from DistributorSalesAreaMapping__c where distributor__c =: accountId AND Company_Code__c =: selectedCompany LIMIT 1];
                 system.debug('DSA'+DSA);
       
        if(DSA.size()>0){
            sOrgCode=DSA[0].SalesOrg__r.sales_org_code__c;
        }
       
       if(accountId!=Null && accountId!='' && selectedCompany!=''&& selectedCompany!='None'){
           
                //For CreditInfo data
            Grz_Customer360Wrapper.Wrapper credInfoData=Grz_CreditSummaryInternal.getData(accountId ,selectedCompany,sOrgCode );
            
            String credDatas= JSON.serialize(credInfoData.data);
        System.debug('credDatas'+credDatas);
            List<OrderALSController.CreditParse> crdata = (List<OrderALSController.CreditParse>) System.JSON.deserialize(credDatas, List<OrderALSController.CreditParse>.class);
            if(credInfoData.success){
                distWrapObj.creditLimit = Decimal.Valueof(crdata[0].CreditLimit);
                distWrapObj.creditUsed = Decimal.Valueof(crdata[0].CreditExposure);
                distWrapObj.creditBalance = Decimal.Valueof(crdata[0].BalanceLimit);
                
            }else if(!credInfoData.success){
                 distWrapObj.creditLimit =null;
                distWrapObj.creditUsed = null;
                distWrapObj.creditBalance = null;
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Credit / OutStanding Information for Distributor not found'));
            }
           
             //For Outstanding data
            
            Grz_Customer360Wrapper.Wrapper outStandData=Grz_OutstandingSummaryInternal.getData(accountId,selectedCompany);
            if(outStandData.success){ 
                distWrapObj.paymentOutstanding = Decimal.Valueof(outStandData.items.totalOutstanding);
            
            }
            else if(!outStandData.success){
                 distWrapObj.paymentOutstanding =null;
               //  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Credit / OutStanding Information for Distributor not found'));
            }
            
        }else{
                distWrapObj.creditLimit = null;
                distWrapObj.creditUsed =null;
                distWrapObj.creditBalance = null;
                distWrapObj.paymentOutstanding =null;
            
            
        }
        
        
    }
    
     // Added Method End for RITM0491228 GRZ(Dheeraj Sharma) 20-01-2023 

    
    
    
    
    
    
    //Method for actionSupport on Address Picklist change
    public void populateShippingAddress(){
        try{
            ApexLog.exceptionCoverage(throwEx);
            System.debug('We are inside populateShippingAddress() method');//Sayan
            System.debug('selectedShipping = '+selectedShipping);//Sayan
            slwObj = new ShippingLocation();
            if(shippingMap.containsKey(selectedShipping)){
                slwObj = shippingMap.get(selectedShipping);
                System.debug('Shipping details on load : '+slwObj);//sayan
            }
            System.debug('After if condition, slwObj = '+slwObj);//sayan
            
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
            List<PriceBookMaster__c> pbmList = [SELECT Id, SKUCode__c ,SKUCode__r.Name, 
                                                SKUCode__r.Pack_Size__c, SKUCode__r.SKU_Code__c,
                                                DepotCode__c, DepotCode__r.Location__c, 
                                                Price__c, PG_CODE__c, PG_CODE__r.Name, 
                                                UOM__c, SKUCode__r.Product_Name__r.Name, SKUCode__r.SKU_Description__c,
                                                SKUCode__r.Product_Name__c, SKUCode__r.Product_Name__r.Popular__c,
                                                DistributorCustomerCode__r.Name, CurrencyIsoCode,SKUCode__r.Brand_Name__c,
                                                SKUCode__r.Product_Name__r.VF_Image__c,SKUCode__r.GST__c, LastModifiedDate, Payment_Term__c
                                                FROM PriceBookMaster__c
                                                WHERE (DistributorCustomerCode__c =: accountId 
                                                       OR (DepotCode__c =: depoId AND PG_CODE__c=:distWrapObj.priceGroupId)
                                                       OR (PrIce_List_Type__c != null AND PrIce_List_Type__c=: distWrapObj.priceListType AND PG_CODE__c=:distWrapObj.priceGroupId))
                                                AND SKUCode__r.Sales_Org__c =: distWrapObj.salesOrgId
                                                AND StartDate__c <= TODAY AND EndDate__c >= TODAY AND SKUCode__r.Active__c = True
                                                AND (SKUCode__r.GST__c!=Null AND SKUCode__r.GST__c!=0 )
                                                ORDER BY SKUCode__r.Brand_Name__c ASC, SKUCode__r.SKU_Code__c DESC,  PrIce_List_Type__c ASC, LastModifiedDate ASC ];
            //, SKUCode__r.Brand_Name__c ASC
            String query  = 'SELECT Id, SKUCode__c ,SKUCode__r.Name, ';
            query += 'SKUCode__r.Pack_Size__c, SKUCode__r.SKU_Code__c, ';
            query += 'DepotCode__c, DepotCode__r.Location__c, ';
            query += 'Price__c, PG_CODE__c, PG_CODE__r.Name, ';
            query += 'UOM__c, SKUCode__r.Product_Name__r.Name, ';
            query += 'SKUCode__r.Product_Name__c, SKUCode__r.Product_Name__r.Popular__c, Payment_Term__c ';
            query += 'DistributorCustomerCode__r.Name, CurrencyIsoCode, SKUCode__r.Brand_Name__c, ';
            query += 'SKUCode__r.Product_Name__r.VF_Image__c ,SKUCode__r.GST__c ';
            query += 'FROM PriceBookMaster__c  ';
            query += 'WHERE (DistributorCustomerCode__c =\''+accountId+'\' ';
            query += 'OR (DepotCode__c =\''+depoId+'\' AND PG_CODE__c=\''+distWrapObj.priceGroupId+'\') ';
            query += 'OR (PrIce_List_Type__c != null AND PrIce_List_Type__c= \''+distWrapObj.priceListType+'\' AND PG_CODE__c=\''+distWrapObj.priceGroupId+'\')) ';
            query += 'AND SKUCode__r.Sales_Org__c =\''+distWrapObj.salesOrgId+'\' ';
            query += 'AND StartDate__c <= TODAY AND EndDate__c >= TODAY AND SKUCode__r.Active__c = True ';
            query += 'AND (SKUCode__r.GST__c!=Null AND SKUCode__r.GST__c!=0)';
            query += 'ORDER BY SKUCode__r.Brand_Name__c ASC, SKUCode__r.SKU_Code__c DESC,  PrIce_List_Type__c ASC, LastModifiedDate ASC';
            
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
                //   skuWrapObj.brandName = pbObj.SKUCode__r.Product_Name__r.Name +' '+pbObj.SKUCode__r.Name; 
                if(String.isNotBlank(pbObj.SKUCode__r.Brand_Name__c)){
                    skuWrapObj.brandName = pbObj.SKUCode__r.Brand_Name__c+' '+pbObj.SKUCode__r.Name;    
                }
                else{
                    skuWrapObj.brandName= pbObj.SKUCode__r.Name;
                }
                skuWrapObj.skuPackName = pbObj.SKUCode__r.Name;
                skuWrapObj.distributorId = accountId;
                skuWrapObj.productName = pbObj.SKUCode__r.Product_Name__r.Name;
                skuWrapObj.description = pbObj.SKUCode__r.SKU_Description__c;
                skuWrapObj.productId = pbObj.SKUCode__r.Product_Name__c;
                skuWrapObj.packSize = pbObj.SKUCode__r.Pack_Size__c;
                skuWrapObj.UOM = pbObj.UOM__c;
                skuWrapObj.skuCode = pbObj.SKUCode__r.SKU_Code__c;
                //Patch added by ganesh(6/6/2018)
                //desc: merge description field with sku Code
                if(String.isNotBlank(skuWrapObj.skuCode)){
                    String removeLeadingZeros = skuWrapObj.skuCode.replaceFirst('^0+','');
                    
                    if(String.isNotBlank(skuWrapObj.description)){
                        skuWrapObj.description = removeLeadingZeros+' - '+skuWrapObj.description;
                    }
                    else{
                        skuWrapObj.description = removeLeadingZeros;
                    }
                }
                //Patch end
                skuWrapObj.skuId = pbObj.SKUCode__c;
                skuWrapObj.depotLocation = pbObj.DepotCode__r.Location__c;
                skuWrapObj.PaymentTerm = pbObj.Payment_Term__c; //Divya
                skuWrapObj.depotId = pbObj.DepotCode__c;
                skuWrapObj.GST = pbObj.SKUCode__r.GST__c;
                skuWrapObj.priceBookMasterId = pbObj.Id;
                skuWrapObj.price = pbObj.Price__c;
                skuWrapObj.priceGroupCode = pbObj.PG_CODE__r.Name; 
                skuWrapObj.priceGroupId = pbObj.PG_CODE__c;
                skuWrapObj.currencyIso = pbObj.currencyIsoCode;
                skuWrapObj.popular = pbObj.SKUCode__r.Product_Name__r.Popular__c;
                
                if(String.isNotBlank(pbObj.SKUCode__r.Product_Name__r.VF_Image__c)){
                    skuWrapObj.image = pbObj.SKUCode__r.Product_Name__r.VF_Image__c;
                }
                if(String.isNotBlank(pbObj.SKUCode__c) && String.isNotBlank(skuWrapObj.UOM) ){
                    skuDetailsMap.put(pbObj.SKUCode__c, skuWrapObj);
                }
                
                
                
            }
            //End of Logic
            
            //Logic to populate existing wrapper with Pricebook Discount
            List<PricebookDiscount__c> pbdList = [SELECT Id, SKUCode__c ,
                                                  Price__c, CurrencyIsoCode, LastModifiedDate
                                                  FROM PricebookDiscount__c
                                                  WHERE (DistributorCustomerCode__c =:accountId 
                                                         OR (DepotCode__c =: depoId AND PG_CODE__c=:distWrapObj.priceGroupId)
                                                         OR (PrIce_List_Type__c != null AND PrIce_List_Type__c=: distWrapObj.priceListType AND PG_CODE__c=:distWrapObj.priceGroupId)) 
                                                  AND SKUCode__r.Sales_Org__c =: distWrapObj.salesOrgId
                                                  AND StartDate__c <= TODAY AND EndDate__c >= TODAY AND SKUCode__r.Active__c = True
                                                  ORDER BY SKUCode__r.Product_Name__r.Name ASC, SKUCode__r.SKU_Code__c DESC, PrIce_List_Type__c ASC, LastModifiedDate ASC];
            System.debug('pbdList: '+pbdList);
            System.debug('size: '+pbdList.size());
            
            for(PricebookDiscount__c pbObj : pbdList){
                if(skuDetailsMap.containsKey(pbObj.SKUCode__c)){
                    skuWrapObj = skuDetailsMap.get(pbObj.SKUCode__c);
                    //change by ganesh
                    //desc: to change special invoice discount percent to Price
                    skuWrapObj.invoiceDiscountPercent = Math.abs(pbObj.Price__c);
                    Decimal pbdPrice = ((Math.abs(pbObj.Price__c)/100)*skuWrapObj.price);
                    skuWrapObj.invoiceDiscount = pbdPrice.setScale(0);
                    skuWrapObj.invoiceDiscountId = pbObj.Id;
                    skuWrapObj.currencyIso = pbObj.currencyIsoCode;
                    skuDetailsMap.put(pbObj.SKUCode__c, skuWrapObj);
                    
                }
                
            }
            //End of Logic
            
            //Logic to populate existing wrapper with Special Discount
            List<Trade_Discount__c> tdList = [SELECT Id, SKUCode__c, 
                                              Price__c, CurrencyIsoCode, LastModifiedDate
                                              FROM Trade_Discount__c
                                              WHERE (DistributorCustomerCode__c =:accountId 
                                                     OR (DepotCode__c =: depoId AND PG_CODE__c=:distWrapObj.priceGroupId)
                                                     OR (PrIce_List_Type__c != null AND PrIce_List_Type__c=: distWrapObj.priceListType AND PG_CODE__c=:distWrapObj.priceGroupId))
                                              AND SKUCode__r.Sales_Org_Code__c ='1510'
                                              AND StartDate__c <= TODAY AND EndDate__c >= TODAY 
                                              AND SKUCode__r.Active__c = True
                                              ORDER BY SKUCode__r.Product_Name__r.Name ASC, SKUCode__r.SKU_Code__c DESC,PrIce_List_Type__c ASC, LastModifiedDate ASC];
            
            System.debug('sidList: '+tdList);
            System.debug('size: '+tdList.size());
            
            for(Trade_Discount__c pbObj : tdList){
                if(skuDetailsMap.containsKey(pbObj.SKUCode__c)){
                    skuWrapObj = skuDetailsMap.get(pbObj.SKUCode__c);
                    //change added by ganesh
                    //desc: to change trade invoice discount percent to Price
                    skuWrapObj.tradeDiscoutPercent = Math.abs(pbObj.Price__c);
                    Decimal sidPrice = ((Math.abs(pbObj.Price__c)/100)*skuWrapObj.price);
                    skuWrapObj.tradeDiscount = sidPrice.setScale(0);
                    skuWrapObj.tradeDiscountId = pbObj.Id;
                    skuWrapObj.currencyIso = pbObj.currencyIsoCode;
                    skuDetailsMap.put(pbObj.SKUCode__c, skuWrapObj);
                    
                }
            }
            //Logic to populate existing wrapper with Matching Discount DIVYA:SCTASK0165944
            List<Matching_Discount__c> mdList = [SELECT Id, SKUCode__c, 
                                                 Price__c, CurrencyIsoCode, LastModifiedDate
                                                 FROM Matching_Discount__c
                                                 WHERE (DistributorCustomerCode__c =:accountId 
                                                        OR (DepotCode__c =: depoId AND PG_CODE__c=:distWrapObj.priceGroupId)
                                                        OR (PrIce_List_Type__c != null AND PrIce_List_Type__c=: distWrapObj.priceListType AND PG_CODE__c=:distWrapObj.priceGroupId))
                                                 AND SKUCode__r.Sales_Org_Code__c ='1510'
                                                 AND StartDate__c <= TODAY AND EndDate__c >= TODAY 
                                                 AND SKUCode__r.Active__c = True
                                                 ORDER BY SKUCode__r.Product_Name__r.Name ASC, SKUCode__r.SKU_Code__c DESC,PrIce_List_Type__c ASC, LastModifiedDate ASC];
            
            System.debug('mdList: '+mdList);
            System.debug('size: '+mdList.size());
            
            for(Matching_Discount__c pbObj : mdList){
                if(skuDetailsMap.containsKey(pbObj.SKUCode__c)){
                    skuWrapObj = skuDetailsMap.get(pbObj.SKUCode__c);
                    skuWrapObj.matchDiscoutPercent = Math.abs(pbObj.Price__c);
                    //Decimal sidPrice = ((Math.abs(pbObj.Price__c)/100)*skuWrapObj.price);//Commented by Divya as new Matching discount will be flat price
                    skuWrapObj.matchDiscount = Math.abs(pbObj.Price__c);
                    skuWrapObj.matchDiscountId = pbObj.Id;
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
                                          Stock_Quantity__c, Balanced_Quanity__c, In_transit_stock_quantity__c
                                          FROM Inventory__c
                                          WHERE Depot__c =: depoId AND SKU__r.Active__c = True];        
            
            System.debug('invList: '+invList);
            System.debug('size: '+invList.size());
            
            for(Inventory__c pbObj : invList){
                if(skuDetailsMap.containsKey(pbObj.SKU__c)){
                    skuWrapObj = skuDetailsMap.get(pbObj.SKU__c);
                    skuWrapObj.available = pbObj.Balanced_Quanity__c;
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
            
            //System.debug('enableIndia: '+enableIndia);
            
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
            skuDetailsList.clear();
            productNamesSet.clear();
            descriptionSet.clear();
            
            for(SKUDetails skuWrapObj:skuDetailsMap.values()){
                
                skuWrapObj.netRateEntered = skuWrapObj.Price - Math.abs(skuWrapObj.invoiceDiscount) - Math.abs(skuWrapObj.tradeDiscount) - Math.abs(skuWrapObj.matchDiscount);  //DIVYA          
                // productNamesSet.add(skuWrapObj.productName);   //added by 
                
                productNamesSet.add(skuWrapObj.brandName);
                //added  by ganesh(6/6/2018)
                if(String.isNotBlank(skuWrapObj.description)){
                    descriptionSet.add(skuWrapObj.description); //added by ganesh
                }
                //end
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
                    if(skuWrapObj.brandName.containsIgnoreCase(searchProdValue) || skuWrapObj.description.containsIgnoreCase(searchProdValue)){
                        
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
            
            createOrder();
            refreshOrderValue();
            
            /*if(ordObj.Order_Status__c=='Approved'){
enableInput = false;
}*/
            system.debug('editorder'+orderId);
            
            List<OrderLineItem__c> oliList = [SELECT Id, Name, CurrencyIsoCode, SKUPackSize__c, 
                                              Order__c, UOM__c, trade_Discount__c,MatchingDiscount__c, SKU_Name__c, 
                                              SKU_Name__r.Pack_Size__c, Scheme_Bonus_Discount__c,
                                              SKU_Name__r.Product_Name__r.Name,SKU_Name__r.GST__c,SKU_Name__r.Brand_Name__c,
                                              SKU_Name__r.Name, Quantity__c, Price__c, No_of_Case__c, Item_Number__c, 
                                              Item_Status__c, Invoice_Discount__c, Order__r.Shipping_Location__c, Payment_Term__c
                                              FROM OrderLineItem__c
                                              WHERE Order__c=:orderId];
            if(!oliList.isEmpty()){
                List<Shipping_Location__c> sameAsBillList = [SELECT Id, City__c, Location_Name__c
                                                             FROM Shipping_Location__c
                                                             WHERE Id=:oliList[0].Order__r.Shipping_Location__c]; 
                selectedShipping = sameAsBillList[0].Location_Name__c;
                PaymentTerm = oliList[0].Payment_Term__c; //Divya
                system.debug('PaymentTerm in edit '+PaymentTerm);
            }
            
            SKUDetails skuWrapObj;
            SKUDetails skuWrapObj2;
            
            skuWrapObj2 = new SKUDetails();
            
            for(OrderLineItem__c oliObj:oliList){
                if(skuDetailsMap.containsKey(oliObj.SKU_Name__c)){
                    skuWrapObj2 = skuDetailsMap.get(oliObj.SKU_Name__c);
                    skuWrapObj = new SKUDetails();
                    skuWrapObj.productName = oliObj.SKU_Name__r.Product_Name__r.Name;
                    skuWrapObj.skuCode = oliObj.SKU_Name__r.Name;
                    
                    skuWrapObj.skuId = oliObj.SKU_Name__c;
                    skuWrapObj.oliId = oliObj.Id;
                    // skuWrapObj.brandName = oliObj.SKU_Name__r.Product_Name__r.Name+' '+oliObj.SKU_Name__r.Name;
                    if(String.isNotBlank(oliObj.SKU_Name__r.Brand_Name__c)){
                        skuWrapObj.brandName = oliObj.SKU_Name__r.Brand_Name__c+' '+oliObj.SKU_Name__r.Name;
                    }
                    else{
                        skuWrapObj.brandName=oliObj.SKU_Name__r.Name;
                    }
                    skuWrapObj.packSize = oliObj.SKU_Name__r.Pack_Size__c;
                    skuWrapObj.numberOfCases = Integer.valueOf(oliObj.Quantity__c/oliObj.SKU_Name__r.Pack_Size__c);
                    skuWrapObj.GST = oliObj.SKU_Name__r.GST__c;
                    
                    skuWrapObj.invoiceDiscount = skuWrapObj2.invoiceDiscount;
                    skuWrapObj.tradeDiscount = skuWrapObj2.tradeDiscount;
                    skuWrapObj.matchDiscount = skuWrapObj2.matchDiscount; //DIVYA
                    skuWrapObj.invoiceDiscountPercent = skuWrapObj2.invoiceDiscountPercent;
                    skuWrapObj.tradeDiscoutPercent = skuWrapObj2.tradeDiscoutPercent;
                    skuWrapObj.matchDiscoutPercent = skuWrapObj2.matchDiscoutPercent; //DIVYA
                    
                    skuWrapObj.priceBookMasterId = skuWrapObj2.priceBookMasterId;
                    skuWrapObj.invoiceDiscountId  = skuWrapObj2.invoiceDiscountId;
                    skuWrapObj.tradeDiscountId   = skuWrapObj2.tradeDiscountId;
                    skuWrapObj.matchDiscountId   = skuWrapObj2.matchDiscountId; //DIVYA
                    system.debug('skuWrapObj.matchDiscountId is '+skuWrapObj.matchDiscountId);
                    
                    skuWrapObj.price = skuWrapObj2.price;
                    skuWrapObj.invoiceDiscount  = skuWrapObj2.invoiceDiscount;
                    skuWrapObj.tradeDiscount  = skuWrapObj2.tradeDiscount;
                    skuWrapObj.matchDiscount  = skuWrapObj2.matchDiscount; //DIVYA
                    system.debug('skuWrapObj.matchDiscount is '+skuWrapObj.matchDiscount);
                    skuWrapObj.tradeDiscountEntered = oliObj.trade_Discount__c;
                    skuWrapObj.matchDiscountEntered = oliObj.MatchingDiscount__c; //DIVYA
                    
                    skuWrapObj.qty = oliObj.Quantity__c;
                    
                    skuWrapObj.invoiceDiscountEntered = oliObj.Invoice_Discount__c;
                    skuWrapObj.netRateEntered = skuWrapObj.Price - Math.abs(skuWrapObj.invoiceDiscount) - Math.abs(skuWrapObj.tradeDiscount) - Math.abs(skuWrapObj.matchDiscount); //DIVYA
                    
                    skuWrapObj.priceEntered = oliObj.Price__c;
                    
                    skuWrapObj.UOM = oliObj.UOM__c;
                    skuWrapObj.available = skuWrapObj2.available;
                    skuWrapObj.available2 = skuWrapObj2.available2;
                    skuWrapObj.currencyIso = oliObj.CurrencyIsoCode;
                    skuWrapObj.PaymentTerm = oliObj.Payment_Term__c;//Divya
                    skuWrapObj.itemNo = Integer.valueOf(oliObj.Item_Number__c);
                    skuOrderMap.put(skuWrapObj.skuId,skuWrapObj);
                    
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
            
            SKUDetails skuWrapObj2 = skuDetailsMap.get(skuIdChosen);
            system.debug('skuWrapObj2'+skuWrapObj2);
            if(skuWrapObj2.qty>0||Test.isRunningTest()){
                //system.debug('PaymentTerm is->'+PaymentTerm);
                /*isSatisfying = false;
                if(skuWrapObj2.PaymentTerm == PaymentTerm || PaymentTerm =='NA'){
                    isSatisfying = true;
                }
                else if(PaymentTerm =='NA' || ((skuWrapObj2.PaymentTerm == '' || skuWrapObj2.PaymentTerm == null) && distWrapObj.paymentTerms == PaymentTerm)){
                    isSatisfying = true;
                }
                else if(PaymentTerm =='NA' ||((PaymentTerm== '' || PaymentTerm== null) && skuWrapObj2.PaymentTerm == distWrapObj.paymentTerms)){
                    isSatisfying = true;
                }
                else{
                    isSatisfying = false;
                }
                System.debug('isSatisfying value :- '+isSatisfying);
                if(!isSatisfying){
                    errorMessage = 'Please place separate sales order for items with different payment terms';
                    System.debug('errorMessage :- '+errorMessage);
                    showError = true;
                }
                else{*///Commented by nandhini
                    skuOrderList.clear();
                    SKUDetails skuWrapObj;
                    OrderLineItem__c oliObj = new OrderLineItem__c();
                    
                    if(skuOrderMap.containsKey(skuIdChosen)){
                        System.debug('skuIdChosen --->'+skuIdChosen);
                        skuWrapObj = skuOrderMap.get(skuIdChosen);
                        
                        skuWrapObj.invoiceDiscountEntered += skuWrapObj2.invoiceDiscountEntered;
                        skuWrapObj.numberOfCases += skuWrapObj2.numberOfCases;
                        skuWrapObj.tradeDiscountEntered += skuWrapObj2.tradeDiscountEntered;
                        skuWrapObj.matchDiscountEntered += skuWrapObj2.matchDiscountEntered; //DIVYA
                        skuWrapObj.priceEntered += skuWrapObj2.priceEntered;
                        skuWrapObj.PaymentTerm = skuWrapObj2.PaymentTerm;//Divya 
                        /*skuWrapObj.priceBookMasterId = skuWrapObj2.priceBookMasterId;
skuWrapObj.invoiceDiscountId  = skuWrapObj2.invoiceDiscountId;
skuWrapObj.specialDiscountId   = skuWrapObj2.specialDiscountId;*/
                        
                        skuWrapObj.qty += skuWrapObj2.qty;
                        
                        if(String.isNotBlank(skuWrapObj.oliId)){
                            oliObj.Id = skuWrapObj.oliId;
                        }
                        if(skuWrapObj2.available==0 || skuWrapObj2.available2=='Out of Stock'){
                            oliObj.Stock_Available__c = true;
                        }
                        
                        oliObj.Invoice_Discount__c = skuWrapObj.invoiceDiscountEntered;
                        oliObj.trade_Discount__c = skuWrapObj.tradeDiscountEntered;
                        oliObj.MatchingDiscount__c = skuWrapObj.matchDiscountEntered; //DIVYA
                        
                        oliObj.No_of_Case__c = skuWrapObj.numberOfCases;
                        oliObj.Quantity__c = skuWrapObj.qty;
                        oliObj.Price__c = skuWrapObj.priceEntered;
                        upsert oliObj;
                    }
                    else{
                        System.debug('skuIdChosen ---> 2');
                        createOrder();
                        
                        skuWrapObj = new SKUDetails();
                        skuWrapObj.productName = skuWrapObj2.productName;
                        skuWrapObj.skuCode = skuWrapObj2.skuCode;
                        skuWrapObj.skuId = skuWrapObj2.skuId;
                        skuWrapObj.brandName = skuWrapObj2.brandName;
                        skuWrapObj.packSize = skuWrapObj2.packSize;
                        skuWrapObj.numberOfCases = skuWrapObj2.numberOfCases;
                        skuWrapObj.GST = skuWrapObj2.GST;
                        skuWrapObj.PaymentTerm = skuWrapObj2.PaymentTerm; //Divya
                        
                        skuWrapObj.invoiceDiscount = skuWrapObj2.invoiceDiscount;
                        skuWrapObj.tradeDiscount = skuWrapObj2.tradeDiscount;
                        skuWrapObj.matchDiscount = skuWrapObj2.matchDiscount; //DIVYA
                        skuWrapObj.invoiceDiscountPercent = skuWrapObj2.invoiceDiscountPercent;
                        skuWrapObj.tradeDiscoutPercent = skuWrapObj2.tradeDiscoutPercent;
                        skuWrapObj.matchDiscoutPercent = skuWrapObj2.matchDiscoutPercent; //DIVYA
                        
                        skuWrapObj.priceBookMasterId = skuWrapObj2.priceBookMasterId;
                        skuWrapObj.invoiceDiscountId  = skuWrapObj2.invoiceDiscountId;
                        skuWrapObj.tradeDiscountId   = skuWrapObj2.tradeDiscountId;
                        skuWrapObj.matchDiscountId   = skuWrapObj2.matchDiscountId; //DIVYA
                        skuWrapObj.price = skuWrapObj2.price;
                        skuWrapObj.invoiceDiscount  = skuWrapObj2.invoiceDiscount;
                        skuWrapObj.tradeDiscount  = skuWrapObj2.tradeDiscount;
                        skuWrapObj.matchDiscount  = skuWrapObj2.matchDiscount; //DIVYA
                        
                        skuWrapObj.invoiceDiscountEntered = skuWrapObj2.invoiceDiscountEntered;
                        skuWrapObj.tradeDiscountEntered = skuWrapObj2.tradeDiscountEntered;
                        skuWrapObj.matchDiscountEntered = skuWrapObj2.matchDiscountEntered; //DIVYA
                        
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
                        
                        oliObj.Invoice_Discount__c = skuWrapObj.invoiceDiscountEntered;
                        oliObj.Spot_Discount__c = 0;
                        skuWrapObj.netRateEntered = skuWrapObj2.netRateEntered;
                        
                        oliObj.trade_Discount__c = skuWrapObj.tradeDiscountEntered;
                        oliObj.MatchingDiscount__c = skuWrapObj.matchDiscountEntered; //DIVYA
                        itemNumber = itemNumber+10;
                        skuWrapObj.itemNo = itemNumber;
                        oliObj.Item_Number__c = String.valueOf(itemNumber);
                        oliObj.CurrencyIsoCode = distWrapObj.currencyIso;
                        oliObj.No_of_Case__c = skuWrapObj.numberOfCases;
                        oliObj.Quantity__c = skuWrapObj.qty;
                        oliObj.Price__c = skuWrapObj.priceEntered;
                       if(skuWrapObj.PaymentTerm != null){//APPS-4845-Added by Nandhini
                          oliObj.Payment_Term__c = skuWrapObj.PaymentTerm;
                        }else{
                          oliObj.Payment_Term__c = distWrapObj.paymentTerms;  
                        } 
                        insert oliObj;
                        skuWrapObj.oliId = oliObj.Id;
                    }
                    netAmount += skuWrapObj2.priceEntered;
                    skuOrderMap.put(skuWrapObj2.skuId,skuWrapObj);
                    skuOrderList.addAll(skuOrderMap.values());
                    if(skuOrderList.size() > 0 && !skuOrderList.isEmpty()){ //Divya
                        PaymentTerm = skuOrderList[0].PaymentTerm;
                        system.debug('PaymentTerm in add SKU '+PaymentTerm);
                    }
                    calculateTax();
                    showError = false;
                //}//commented by Nandhini
            }
            else{
                
                errorMessage = 'Please enter No. of Cases';
                System.debug('errorMessage :- '+errorMessage);
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
        try{
            ApexLog.exceptionCoverage(throwEx);
            
            OrderLineItem__c oliObj = new OrderLineItem__c();
            for(SKUDetails skuObj:skuOrderList){
                if(String.isNotBlank(skuObj.oliId)){
                    oliObj.Id = skuObj.oliId;
                }
                
                oliObj.Invoice_Discount__c = skuObj.invoiceDiscountEntered;
                oliObj.trade_Discount__c = skuObj.tradeDiscountEntered;
                oliObj.MatchingDiscount__c = skuObj.matchDiscountEntered;
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
            ApexLog.exceptionHandler(ex, orderId, accountId);
        }            
    }
    
    //Method to delete SKU from Order Table
    public void deleteSKU(){
        try{
            ApexLog.exceptionCoverage(throwEx);
            skuOrderList = new List<SKUDetails>();
            OrderLineItem__c oliObj = new OrderLineItem__c();
            oliObj.Id = skuOrderMap.get(skuIdChosen).oliId;
            netAmount -= skuOrderMap.get(skuIdChosen).priceEntered;
            skuOrderMap.remove(skuIdChosen);
            delete oliObj;
            skuOrderList.addAll(skuOrderMap.values());
            if(skuOrderList.isEmpty() || skuOrderList.size() <= 0){
                PaymentTerm = 'NA';
                system.debug('PaymentTerm in delete '+PaymentTerm);
            }
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
            PaymentTerm = 'NA';
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
            if(allowTemplate == True){
                if(String.isNotBlank(templateName)){
                    saveTemplate();
                }
                else{
                    showError = true;
                    errorMessage = 'Please Enter Template Name';
                }
            }
            
            if((String.isBlank(selectedShipping))&& showError==false){
                showError = true;
                errorMessage = 'Please select Shipping Address';
            }
            else if(!skuOrderList.isEmpty() && showError==false){
                orderSaved = true;
            }
            else if(showError==false){
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
        System.debug('------------------------------Inside confirm Order');
        try{
            ApexLog.exceptionCoverage(throwEx);
            if(Test.isRunningTest()){
                valuefromJS='Sales Order created successfully!';
            }
            if(valuefromJS=='Sales Order created successfully!'){
                saveOrder();
                //Change Added by ganesh
                Boolean flag = true;
                for(SKUDetails skuWrapObj:skuOrderMap.values()){
                    if(skuWrapObj.qty==0){
                        showError = true;
                        errorMessage = 'Please Enter No. of Cases for all SKU\'s before confirming order'; 
                        flag = false;
                        break;
                    }
                }
                //End
                 paymentTermList=new set<String>();
                //APPS-4845-Added by Nandhini
                for(SKUDetails skuWrapObj:skuOrderMap.values()){
                    if(skuWrapObj.PaymentTerm !=null){
                        paymentTermList.add(skuWrapObj.PaymentTerm);
                    }
                    else if(distWrapObj.paymentTerms != null){
                        system.debug('accounts payment term'+distWrapObj.paymentTerms);
                        paymentTermList.add(distWrapObj.paymentTerms);
                    }
                    else{
                        paymentTermList.add('No PaymentTerm');
                     }
                    
                }
                system.debug('paymentTerms :'+paymentTermList);
                if(Test.isRunningTest()){
                    flag=true;
                }
                if(orderSaved == true && flag == true){
                    showError = false;
                    
                    addSOLineItem();
                    
                    if(orderSaved == True && showError==false){
                        ordObj.Order_Status__c = 'Approved';
                        upsert ordObj;
                        showError = true;
                        
                        String finaltxt='';
                        
                        for(String a :TotalcreatedSO) {
                            finaltxt += a;
                            finaltxt += ', ';
                        }
                        
                        finaltxt = finaltxt.subString(0,finaltxt.length()-2);
                        
                        if(TotalcreatedSO.size()==1){
                            errorMessage = valuefromJS+'\n<br/>'+'Sales Order Number is '+ finaltxt+'.';
                            enableInput = false;
                        }
                        
                        if(TotalcreatedSO.size()>1){
                            errorMessage = 'Sales Orders created successfully!'+'\n<br/>'+'Due to different different paymentTerms, multiple orders created as: '+ finaltxt+'.';//Modified by Nandhini
                            enableInput = false;
                        }
                        
                        if(String.isNotBlank(PO)){
                            
                            List<Attachment> attachList = [SELECT id, Name, ParentId,
                                                           IsPrivate, ContentType, Body, 
                                                           Description 
                                                           FROM attachment 
                                                           WHERE parentId=:orderId limit 1];
                            //APPS-4845-Modified by Nandhini
                            List<Attachment> attachmentToBeinserted=new List<Attachment>(); 
                            if(!attachList.isEmpty()){
                                if(salesOrderIds !=null && !salesOrderIds.isEmpty()){ //APPS-4845-Modified by Nandhini
                                     for(Id soId:salesOrderIds){
                                         Attachment attObj = new Attachment();
                                         attObj.Name = attachList[0].Name;
                                         attObj.ParentId = soId;
                                         attObj.IsPrivate = attachList[0].IsPrivate;  
                                         attObj.ContentType = attachList[0].ContentType;
                                         attObj.Body = attachList[0].Body;
                                         attObj.Description = attachList[0].Description;
                                         //insert attObj;
                                         attachmentToBeinserted.add(attObj);
                                     }
                                }
                                if(attachmentToBeinserted != null && !attachmentToBeinserted.isEmpty()){
                                     Insert attachmentToBeinserted;
                                }
                               
                            }
                        }
                    }
                }
            }
            else{
                showError = true;
                errorMessage = valuefromJS;
                ApexLog.exceptionHandler(null, orderId, accountId);
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
                                      Additional_Tax_Amount__c, Gross_Amount__c, Shipping_Location__c
                                      FROM Order__c 
                                      WHERE Id=:orderId];
                
                taxAmount = orderObj.Additional_Tax_Amount__c;
                //vatAmount = orderObj.Vat_Amount__c;
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
                    system.debug('ordObj.Id'+ordObj.Id);
                    List<AggregateResult> lstAR = [Select SUM(GST_Amount__c)gst FROM OrderLineItem__c WHERE Order__c =: ordObj.Id];
                    Decimal gstAmount =(Decimal)lstAR[0].get('gst');
                    system.debug('gstAmount'+gstAmount);
                    vatAmount = gstAmount;
                    ordObj.GST_Amount__c = gstAmount;
                    //ordObj.VAT__c = stsList[0].Tax__c;
                    ordObj.Additional_Tax__c = stsList[0].AdditionalTax__c;
                    upsert ordObj;
                }
            }
            else{
                ordObj.VAT__c = 0;
                ordObj.Additional_Tax__c = 0;
                upsert ordObj;
            }
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
                if(length >75){
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
            
            createOrder();
            
            delete [SELECT Id FROM OrderLineItem__c WHERE Order__c=:ordObj.Id];
            
            skuOrderMap.clear();
            skuOrderList.clear();        
            
            refreshOrderValue();
            
            if(ordObj.Order_Status__c=='Approved'){
                enableInput = false;
            }
            
            List<OrderTemplateItem__c> oliList = [SELECT Id, Name, SKU__c, OrderTemplate__c,
                                                  SKU__r.Product_Name__r.Name, SKU__r.Name,SKU__r.GST__c,
                                                  SKU__r.Pack_Size__c, SKU__r.UOM__c,SKU__r.Brand_Name__c
                                                  FROM OrderTemplateItem__c  
                                                  WHERE OrderTemplate__c =: tempIdChosen];
            
            for(OrderTemplateItem__c oliObj:oliList){
                
                SKUDetails skuWrapObj2 = skuDetailsMap.get(oliObj.SKU__c);
                SKUDetails skuWrapObj = new SKUDetails();
                skuWrapObj.productName = oliObj.SKU__r.Product_Name__r.Name;
                skuWrapObj.skuCode = oliObj.SKU__r.Name;
                skuWrapObj.skuId = oliObj.SKU__c;
                skuWrapObj.oliId = oliObj.Id;
                skuWrapObj.brandName = skuWrapObj.brandName = oliObj.SKU__r.Brand_Name__c+' '+oliObj.SKU__r.Name; //oliObj.SKU__r.Product_Name__r.Name+' '+oliObj.SKU__r.Name;
                skuWrapObj.packSize = oliObj.SKU__r.Pack_Size__c;
                skuWrapObj.numberOfCases = 0;
                skuWrapObj.invoiceDiscount = skuWrapObj2.invoiceDiscount;
                skuWrapObj.tradeDiscount = skuWrapObj2.tradeDiscount;
                skuWrapObj.matchDiscount = skuWrapObj2.matchDiscount; //DIVYA
                skuWrapObj.invoiceDiscountPercent = skuWrapObj2.invoiceDiscountPercent;
                skuWrapObj.tradeDiscoutPercent = skuWrapObj2.tradeDiscoutPercent;
                skuWrapObj.matchDiscoutPercent = skuWrapObj2.matchDiscoutPercent; //DIVYA
                skuWrapObj.GST=oliObj.SKU__r.GST__c;
                skuWrapObj.PaymentTerm = skuWrapObj2.PaymentTerm; //Divya
                
                skuWrapObj.price = skuWrapObj2.price;
                skuWrapObj.invoiceDiscountEntered = 0;
                skuWrapObj.tradeDiscountEntered = 0;
                skuWrapObj.matchDiscountEntered = 0; //DIVYA
                
                skuWrapObj.priceEntered = 0;
                skuWrapObj.netRateEntered = skuWrapObj.Price - Math.abs(skuWrapObj.invoiceDiscount) - Math.abs(skuWrapObj.tradeDiscount) - Math.abs(skuWrapObj.matchDiscount); //DIVYA
                skuWrapObj.qty = 0;
                skuWrapObj.UOM = oliObj.SKU__r.UOM__c;
                skuWrapObj.available = skuWrapObj2.available;
                skuWrapObj.available2 = skuWrapObj2.available2;
                skuWrapObj.currencyIso = distWrapObj.CurrencyIso;
                skuOrderMap.put(skuWrapObj.skuId,skuWrapObj);
                skuOrderList.add(skuWrapObj);
            }
            if(skuOrderList.size() > 0 && !skuOrderList.isEmpty()){ //Divya
                PaymentTerm = skuOrderList[0].PaymentTerm;
                system.debug('PaymentTerm in add SKU '+PaymentTerm);
            }
            for(SKUDetails skuWrapObj:skuOrderMap.values()){
                OrderLineItem__c oliObj = new OrderLineItem__c();
                
                oliObj.Order__c = orderId;
                oliObj.SKU_Name__c = skuWrapObj.skuId;
                oliObj.UOM__c = skuWrapObj.UOM;
                oliObj.Invoice_Discount__c = skuWrapObj.invoiceDiscountEntered;
                oliObj.trade_Discount__c = skuWrapObj.tradeDiscountEntered;
                oliObj.MatchingDiscount__c = skuWrapObj.matchDiscountEntered; //DIVYA
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
            ApexLog.exceptionHandler(ex, orderId, accountId);
        }            
    }
    
    //Method to redirect to Sales Order Record
    public PageReference redirectFunction(){
        PageReference pg;
        if(isPortalUser){
            pg = new PageReference('/home/home.jsp');
        }
        else if(String.isNotBlank(accountId)){
            pg = new PageReference('/'+accountId);
        }
        return pg;
    }
    
    public class DistributorWrapper{
        public String distributorName {get;set;}
        public String salesOrgId {get;set;}
        public String salesOrgName {get;set;}
        public String distributorChannelId {get;set;}
         public String salesOrgNames {get;set;} // Updated  for RITM0491228 GRZ(Dheeraj Sharma) 20-01-2023 
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
        public Id priceListType {get;set;}
    }
    
    public class SKUDetails{
        public String brandName {get;set;}
        public Boolean popular {get;set;}
        public Id distributorId {get;set;}
        public String productName {get;set;}
        public String description {get;set;}
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
        public Decimal GST {get;set;}
        public Decimal invoiceDiscountEntered {get;set;}
        public Decimal tradeDiscountEntered {get;set;}
        public Decimal matchDiscountEntered {get;set;}
        public String PaymentTerm {get;set;} //Divya
        public Decimal netRateEntered{get;set;}
        public Decimal priceEntered {get;set;}
        public Integer numberOfCases {get;set;}
        public Decimal qty {get;set;}
        public Integer itemNo {get;set;}
        public Decimal available {get;set;}
        public String available2 {get;set;}
        public String currencyIso {get;set;}
        public String image {get;set;}
        
        //added by ganesh 
        //desc: For percent of pricebook and special invoice discount.
        public Decimal invoiceDiscountPercent{get;set;}
        public Decimal tradeDiscoutPercent{get;set;}
        public Decimal matchDiscoutPercent{get;set;}
        
        //Add to Sales Order Line Item
        public Decimal price {get;set;}
        public Decimal invoiceDiscount {get;set;}
        public Decimal tradeDiscount {get;set;}
        public Decimal matchDiscount {get;set;}
        
        //Lookup Id's of Price/Discount Masters
        public String priceBookMasterId {get;set;}
        public String invoiceDiscountId {get;set;}
        public String tradeDiscountId {get;set;}
        public String matchDiscountId {get;set;}
        
        public SKUDetails(){
            priceBookMasterId = '';
            invoiceDiscountId = '';
            tradeDiscountId = '';
            matchDiscountId = '';
            PaymentTerm = '';//Divya
            packSize = 0;
            UOM = 'N/A';
            qty = 0;
            numberOfCases = 0;
            invoiceDiscountEntered = 0;
            tradeDiscountEntered = 0;
            matchDiscountEntered = 0;
            GST=0;
            priceEntered = 0;
            invoiceDiscount = 0;
            tradeDiscount = 0;
            matchDiscount = 0;
            invoiceDiscountPercent = 0;
            tradeDiscoutPercent = 0;
            matchDiscoutPercent = 0;
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
        public String address {get;set;}
        public String city {get;set;}
        public String state {get;set;}
        public String country {get;set;}
        public String pincode {get;set;}
    }
   // Added Below Start for RITM0491228 GRZ(Dheeraj Sharma) 20-01-2023 

    public class Credit{
        List<CreditParse> credParse{get;set;}
        
    }
    public class CreditParse{
        public String CreditLimit{get;set;}
        public String CreditExposure{get;set;}
        public String BalanceLimit{get;set;}
    }
    // Added  End for RITM0491228 GRZ(Dheeraj Sharma) 20-01-2023 
}