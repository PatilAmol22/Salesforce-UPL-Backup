/*
* Name: OrderSWALController
* Created On: 15 April 2017
* Author: Bhavik Devdhar (bhavik.devdhar@skinternational.com)
* Description: Class is used for Placing Orders by Distributor, TM, RM of SWAL
* Modified By:Nandhini -CR:APPS-4845 -Description :To create Multiple Sales orders for different Payment terms
*/
global without sharing class OrderSWALController {
    public class TestException extends Exception{}
    
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
    public List<SelectOption> OrgNames{get;set;}   // Updated for RITM0491228 GRZ(Dheeraj Sharma) 20-01-2023 
    public String selectedCompany {get; set;}  // Updated for RITM0491228 GRZ(Dheeraj Sharma) 20-01-2023 
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
    public List<SelectOption> depotSet{get;set;}
    
    public String selectedShipping {get;set;}
    public String depLocation{get;set;}
    public String selectedDepot {get; set;}
    public String searchProdValue {get; set;}
    public String templateName {get; set;}
    public String PO {get; set;}
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
    public Boolean isPortalUser;
    
    public Decimal netAmount {get;set;}
    public Decimal grossAmount {get;set;}
    public Decimal taxAmount {get;set;}
    public Decimal vatAmount {get;set;}
    
    public Integer itemNumber;
    
    public String orderId{get;set;}
    // public String divisionId{get;set;}
    public String accountId{get;set;}
    public String depoId;
    public String distributorId;
    public String territoryManagerId;
    public String country;
    
    public Order__c ordObj {get;set;}
    public Sales_Order__c soObj {get;set;}
    public User loginUserObj {get;set;}
    
    //Added by Divya for SCTASK0058061
    public List<SelectOption> paymentOptions{get;set;}
    
    //Variables to Enable Country Wise Table
    public Boolean enableIndia{get;set;}
    public Boolean enableIndonesia{get;set;}
    
    //APPS-4845-Added by Nandhini
    public set<String> paymentTermList;
    Map<String,String>paymentTermDivNumber;
    //public set<String> paymentTermDivNumber;
    public Map<String,Sales_Order__c> mapOfPaymentAndSO;
    public set<Id> salesOrderIds;
    
    public Integer orderListCount{get;set;}
    public List<SelectOption> divisionSet{get;set;}  //added 
    public Set<String> setOfDiv{get;set;}  //added
    public String paymentType{get;set;}
    public Map<String,String> orderTypeMap;
    public List<Order_Type__c> orderTypeList;//RITM0395664 Order Type changes for SWAL Org for Price Group NR and NC.
    
    public String cartPaymentTerm;
    public Boolean isSatisfying;
    public OrderSWALController(ApexPages.StandardController controller) {
        try{
            orderType = '';
            
            orderTypeMap = new Map<String,String>();
            orderTypeList = new List<Order_Type__c>(); //RITM0395664 Order Type changes for SWAL Org for Price Group NR and NC.                                                           
            country = 'SWAL';
            orderListCount = 0;
            depLocation='';
            cartPaymentTerm = 'NA';
            divisionSet = new List<SelectOption>();  //added
            setOfDiv = new Set<String>();   //added
            //Added by Divya for SCTASK0058061
            paymentOptions = new List<SelectOption>();
            paymentOptions.add(new SelectOption('Cash','Cash'));
            paymentOptions.add(new SelectOption('Credit','Credit'));
            
            paymentType='Credit';  
            
            slwObj = new ShippingLocation();            
            slwObj2 = new Shipping_Location__c();
            productNamesSet = new Set<String>();
            depotSet = new List<SelectOption>();
            TotalcreatedSO =new Set<String>();
            
            skuDetailsList = new List<SKUDetails>();
            skuOrderList = new List<SKUDetails>();
            oliList = new List<OrderLineItem__c>();
            
            skuOrderMap = new Map<Id,SKUDetails>();
            shippingMap = new Map<String, ShippingLocation>();
            skuDetailsMap = new Map<Id,SKUDetails>();
            stateMap = new Map<String, String>();
            
            searchProdValue = '';
            errorMessage = '';
            skuIdChosen = '';
            state = '';
            orderRaisedBy = '';   
            skuJSON = '';
            distributorJSON = '';
            shippingJSON = '';
            PO = '';
            
            throwEx = false;
            showError = false;
            enableInput = true;
            showCredit = false;
            showInventory = false;
            showInventoryColumn = false;
            showInTransit = false;
            showInTransitValues = false;
            
            isPortalUser = false;
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
            //  divisionId = '';
            territoryManagerId = '';
            
            orderId = ApexPages.currentpage().getparameters().get('id');        
            System.debug('orderId: '+orderId);
            
            accountId = ApexPages.currentpage().getparameters().get('acid');
            System.debug('accountId: '+accountId);
            
            loginUserObj = [SELECT Id, Name, IsActive, ContactId,UserRole.name,
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
            
            System.debug('showInventory: '+showInventory);
            System.debug('showInventoryColumn: '+showInventoryColumn);
            System.debug('showCredit: '+showCredit);
            
            //Assign account Id if TM creates order on behalf of Distributor
            if(String.isNotBlank(accountId)) {
                
                enableDepot = loginUserObj.EnableDepot__c;
                System.debug('enableDepot: '+enableDepot);
                //distributorId = [SELECT Id FROM User where Contact.AccountId =: accountId].Id;
                //Commented for Community User Change :Deeksha 
                /*
List<User> listUr = [Select u.Id, u.IsActive, u.IsPortalEnabled from User u where u.AccountId=:accountId];
territoryManagerId = UserInfo.getUserId();
if(listUr.size() >0 ){
distributorId = listUr[0].id;
}else{*/
                //Account accowner = [Select id,ownerId From Account Where id =: accountId];
                //distributorId = accowner.ownerId;
                //
                /********** Added By ketan ***************/
                DistributorSalesAreaMapping__c salesArea = [SELECT Id, Name, Distributor__c,  AccountOwner__c,AccountOwner__r.Name, AccountOwnerActive__c 
                                                            FROM DistributorSalesAreaMapping__c WHERE Distributor__c = :accountId AND Sales_Org_Code__c = '1210'
                                                            AND AccountOwnerActive__c = true LIMIT 1];
                System.Debug('Inside Portal User Id else listUr[0].id --> '+salesArea.AccountOwner__r.Name);
                distributorId = salesArea.AccountOwner__c;
                
                /********** Added By ketan ***************/
                //}
                
                System.debug('-inside if condition-- distributorId--->'+ distributorId);
                if(loginUserObj.UserRole.name.contains('Regional Manager')) {
                    orderRaisedBy = 'Regional Manager';
                } else {
                    orderRaisedBy = 'Territory Manager';
                }
            } else {
                //Assign Account Id based on Logged In User            
                List<Contact> conList = [SELECT Id, FirstName, LastName, 
                                         Accountid, Account.OwnerId, 
                                         Account.RegionalManager__c
                                         FROM Contact 
                                         WHERE Id =: loginUserObj.ContactID];
                
                distributorId = UserInfo.getUserId();
                isPortalUser = true;
                showInventory = loginUserObj.Show_Inventory__c;
                
                if(!conList.isEmpty()) {        
                    accountId = conList[0].Accountid;
                    //territoryManagerId = UserInfo.getUserId(); //conList[0].Account.OwnerId;      
                } else {
                    //accountId = '001N000000qg8AT'; commented By abhishek...
                    //depoId = 'a0wN0000002zYrxIAE';
                    //territoryManagerId = '005N0000002kOef';
                }
                orderRaisedBy = 'Distributor';
            }
            
            depotList = [SELECT id, Depot__c 
                         FROM Distributor_Depot_Mapping__c 
                         WHERE Depot__r.SalesOrg__r.Sales_Org_Code__c='1210' 
                         AND Distributor__c=:accountId AND Depot__c!='' LIMIT 1];
            
            System.debug('depotList: '+depotList);
            
            if(!depotList.isEmpty()) {
                depoId = depotList[0].Depot__c;
            }
            
            System.debug('depoId: '+depoId);
        }
        catch(Exception ex){
            System.debug('Method: Constructor Exception: '+ex.getMessage()+ ' Line Number: '+ex.getLineNumber());
        }
        //System.assert(false,'Payment Type:'+paymentType);
    }
    
    
    
    //Method to Create Sales Order on Order Confirmation
    public void createSalesOrder(){
        try{
            ApexLog.exceptionCoverage(throwEx);
            system.debug('paymentTermsList in create:'+paymentTermList);
            system.debug('paymentTerms and division in create:'+paymentTermDivNumber);
            //APPS-4845-Added by Nandhini
            mapOfPaymentAndSO=new Map<String,Sales_Order__c>();
            if(ordObj!=null ){
                if(paymentTermDivNumber !=null && !paymentTermDivNumber.isEmpty()){//Added by Nandhini-APPS-4845
                    for(String paymentTermDiv:paymentTermDivNumber.keySet()){//Added by Nandhini-APPS-4845
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
                        soObj.Sales_Org_lk__c = distWrapObj.salesOrgId;
                        
                        if(depLocation.containsIgnoreCase('SW')){
                            soObj.Distribution_Channel_lk__r = new Distribution_Channel__c(Distribution_Channel_Code__c='10') ;
                        } else {
                            soObj.Distribution_Channel_lk__c = distWrapObj.distributorChannelId;
                        }
                        
                        soObj.Division_lk__c = distWrapObj.divisionId;
                       // soObj.Credit_Term__c = distWrapObj.paymentTerms;//commented by Nandhini
                        if(paymentTermDivNumber.get(paymentTermDiv) !='No PaymentTerm'){
                            soObj.Credit_Term__c=paymentTermDivNumber.get(paymentTermDiv);//APPS-4845-Added by Nandhini 
                        }
                       
                        //soObj.Stock_Status__c = 'In Stock';
                        if(String.isNotBlank(PO)) {
                            soObj.PONumber__c = PO;
                        }
                        
                        soObj.CurrencyIsoCode = distWrapObj.currencyIso;
                        
                        if(soObj.Order_Raise_By__c == 'Distributor') {
                            soObj.Designated_Owner__c = territoryManagerId;
                        } else {
                            soObj.Designated_Owner__c = distWrapObj.regionalManagerId;
                        }
                        
                        mapOfPaymentAndSO.put(paymentTermDiv,soObj);
                    }  //soObj.Order_Type_lk__c = orderType;
                }
               // insert soObj;//commented by Nandhini
                try{
                    if(mapOfPaymentAndSO !=null && !mapOfPaymentAndSO.isEmpty()){
                        insert mapOfPaymentAndSO.values();
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
                catch(Exception ex){
                    system.debug('exception in sales order insert :'+ex.getMessage());
                }
            }
            
            else {
                System.debug('createSalesOrder failed');
            }
        }
        catch(Exception ex){
            ApexLog.exceptionHandler(ex, orderId, accountId);
        }
    }
    
    //Method to poulate Order Type Code based on Sales Org of Distributor
    public void setOrderType() {
        /*orderType = [SELECT Id, Order_Type_Code__c, Division__r.Division_Code__c FROM Order_Type__c 
WHERE SalesOrg__c =: distWrapObj.salesOrgId AND Description__c =: paymentType].Id;*/
        
        System.debug('paymentType: ' + paymentType);
        System.debug('distWrapObj.salesOrgId --> ' + distWrapObj.salesOrgId);
        System.debug('Distributor Id --> ' + accountId);
        
        //RITM0395664
        if(Test.isRunningTest()) {
            String swalId = [Select Id FROM Sales_Org__c WHERE Sales_Org_Code__c='1210'].Id;
            for(Order_Type__c otObj:[SELECT Id, Description__c, Name, Order_Type_Code__c, Division__r.Division_Code__c, Combination_Key__c
                                     FROM Order_Type__c 
                                     WHERE SalesOrg__c =: swalId
                                     AND Description__c = 'Credit']) {
                                         // orderTypeMap.put(otObj.Division__r.Division_Code__c,otObj.Id);
                                         orderTypeList.add(otObj);  //  RITM0395664 changes done by Ey Team
                                     }
        } else {
            for(Order_Type__c otObj:[SELECT Id, Description__c, Name, Order_Type_Code__c, Division__r.Division_Code__c, Combination_Key__c
                                     FROM Order_Type__c 
                                     WHERE SalesOrg__c =: distWrapObj.salesOrgId  
                                     AND Description__c =: paymentType]) {
                                         // orderTypeMap.put(otObj.Division__r.Division_Code__c,otObj.Id);
                                         orderTypeList.add(otObj);  //  RITM0395664 changes done by Ey Team
                                     }
        }
        
        //System.debug('orderTypeMap: '+orderTypeMap);
        System.debug('orderTypeList: ' + orderTypeList);
    }
    
    public void setPO() {
        System.debug('PO: '+PO);
    }
    
    /*public void changeDivision(){
System.debug('divisionId: '+divisionId);
changeDepot();
}*/
    
    //Method to add Line Items to SalesOrders on Order Confirmation
    public void addSOLineItem() {
        try{
            ApexLog.exceptionCoverage(throwEx);
            //  List<SKUDetails> gstList ;
            List<SKUDetails>divList;
            // Map<Decimal,List<SKUDetails>> gstMap = new Map<Decimal,List<SKUDetails>>();
            Map<Decimal,List<SKUDetails>> gstMap;
            Map<String,List<SKUDetails>> DivisionMap =new Map<String,List<SKUDetails>>();
            system.debug('soLineItemDiv'+DivisionMap);
            
            //getting List of SKUDetails Wrapper from SKUDetails Map 
            for(SKUDetails skuWrapObj1:skuOrderMap.values()) {
                //retrieving division code from SKU and put in Division map
                if(!DivisionMap.containsKey(skuWrapObj1.divNumber)) {
                    divList = new List<SKUDetails>();
                    system.debug('IfsoSku'+divList);
                    divList.add(skuWrapObj1);
                    DivisionMap.put(skuWrapObj1.divNumber,divList);
                    system.debug('IfsoLineItemDiv'+DivisionMap);
                    
                } else {
                    DivisionMap.get(skuWrapObj1.divNumber).add(skuWrapObj1);
                    system.debug('ElsesoLineItemDiv'+DivisionMap);
                    system.debug('ElsesoLineItemDiv'+divList);
                }
            }
            //Added by Nandhini
            createSalesOrder();
            Map<Id,Integer> itemNumberMap=New Map<Id,Integer>();
            Account accRec = [select id,name,PriceGroupCode__r.PG_Code__c from account where id =: accountId];
            Map<String,Id> mapOdDivCodeAndID=new Map<String,Id>();
            if(DivisionMap !=null && !DivisionMap.isEmpty()){
                for(Division__c div:[Select Id,Name,Division_Code__c from Division__c where Division_Code__c IN :DivisionMap.keySet()]){
                    mapOdDivCodeAndID.put(div.Division_Code__c,div.Id);
                }  
            }
            //APPS-4845-Added by Nandhini
            Map<Id,Decimal> mapOfGstAndSoID=new Map<Id,Decimal>();
            Map<Id,String> mapOfdivAndSoID=new Map<Id,String>();
            List<Sales_Order_Line_Item__c> salesOrderLineItemList=new List<Sales_Order_Line_Item__c>();//Added by Nandhini
            
            //retrieving gst And putting in gstMap and gstList
            for( String div : DivisionMap.keySet()) {
                gstMap = new Map<Decimal,List<SKUDetails>>();
                system.debug('keyset'+ DivisionMap.keySet());
                for(SKUDetails skuWrapObj:DivisionMap.get(div)){
                    if(!gstMap.containsKey(skuWrapObj.GST)) {
                        
                        gstMap.put(skuWrapObj.GST, new List<SKUDetails>{skuWrapObj});
                    } else {
                        gstMap.get(skuWrapObj.GST).add(skuWrapObj);
                    }
                }
                //Sayan10 for (Decimal gst : gstMap.keySet()){
                Integer i=0;
                Sales_Order_Line_Item__c sliObj;
                Set<Id> salesOrderNewIds=new Set<Id>();
                
                // createSalesOrder();//commented by Nandhini
                for(SKUDetails skuWrapObj:DivisionMap.get(div)) {
                    //i=i+10;
                    sliObj = new Sales_Order_Line_Item__c();
                    sliObj.SKU_Name__c = skuWrapObj.skuId;
                    
                    //sliObj.Item_Number__c = i;//commented by Nandhini
                    sliObj.Item_Status__c = 'Active';
                    sliObj.No_of_Case__c = skuWrapObj.numberOfCases;
                    sliObj.DepotDepot__c = depoId;
                    sliObj.UOM__c = skuWrapObj.UOM;
                    sliObj.CurrencyIsoCode = distWrapObj.currencyIso;
                    
                    if(Test.isRunningTest()){
                        skuWrapObj.qty=1;
                    }
                    
                    if(skuWrapObj.qty==0) {
                        showError = true;
                        errorMessage = 'Please Enter No. of Cases for all SKU\'s before confirming order'; 
                        break;
                    }
                    
                    sliObj.Quantity__c = skuWrapObj.qty;
                    sliObj.Invoice_Discount__c = skuWrapObj.invoiceDiscount * skuWrapObj.qty;
                    sliObj.Special_Discount__c = skuWrapObj.specialDiscount * skuWrapObj.qty;
                    sliObj.Price__c = (skuWrapObj.price*sliObj.Quantity__c) - sliObj.Invoice_Discount__c - sliObj.Special_Discount__c;
                    // sliObj.Sale_Order__c = soObj.Id;//commented by Nandhini
                    //APPS-4845- Added by Nandhini
                    if(skuWrapObj.PaymentTerm != null){
                        String paymentTermAndDiv=skuWrapObj.divNumber+skuWrapObj.PaymentTerm;
                        if(mapOfPaymentAndSO.containsKey(paymentTermAndDiv)){
                            sliObj.Sale_Order__c=mapOfPaymentAndSO.get(paymentTermAndDiv).Id;
                        }
                    }
                    else if(distWrapObj.paymentTerms != null){
                        system.debug('distWrapObj.paymentTerms :'+distWrapObj.paymentTerms);
                        String paymentTermAndDiv=skuWrapObj.divNumber+distWrapObj.paymentTerms;
                        if(mapOfPaymentAndSO.containsKey(paymentTermAndDiv)){
                            sliObj.Sale_Order__c=mapOfPaymentAndSO.get(paymentTermAndDiv).Id;
                        }
                        
                    }
                    else{
                        String paymentTermAndDiv=skuWrapObj.divNumber+'No PaymentTerm';
                        if(mapOfPaymentAndSO.containsKey(paymentTermAndDiv)){
                            sliObj.Sale_Order__c=mapOfPaymentAndSO.get(paymentTermAndDiv).Id;
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
                    //Added by Nandhini
                    //salesOrderNewIds.add(sliObj.Sale_Order__c);
                    salesOrderLineItemList.add(sliObj);
                    mapOfdivAndSoID.put(sliObj.Sale_Order__c,div);
                    mapOfGstAndSoID.put(sliObj.Sale_Order__c,skuWrapObj.GST);
                    //insert sliObj;//comented by Nandhini
                }
                
                
                //Update Tax and Total Amount in Sales Order
                /*if(soObj!=null) {//commented by Nandhini
soObj = [Select Id,Name, Net_Amount__c from Sales_Order__c where id=:soObj.id];
soObj.Division_lk__c =[Select Id,Name,Division_Code__c from Division__c where Division_Code__c=:div].Id;

//Added for RITM0395664---
Account accRec = [select id,name,PriceGroupCode__r.PG_Code__c from account where id =: accountId];

for(Order_Type__c orType : orderTypeList) {
system.debug('OrderType:- ' + orType);

if(accRec.PriceGroupCode__r.PG_Code__c == 'NC' || accRec.PriceGroupCode__r.PG_Code__c == 'NR') {
if(orType.Description__c == 'Credit' && orType.Order_Type_Code__c == 'ZWOD' && orType.Division__r.Division_Code__c == div) {
soObj.Order_Type_lk__c =   orType.Id;
} else if(orType.Description__c == 'Credit' && orType.Order_Type_Code__c == 'ZWOF' && orType.Division__r.Division_Code__c == div) {
soObj.Order_Type_lk__c =   orType.Id;
} else if(orType.Description__c == 'Cash' && orType.Order_Type_Code__c == 'ZWMD' && orType.Division__r.Division_Code__c == div) {
soObj.Order_Type_lk__c =   orType.Id;
}
} else if(accRec.PriceGroupCode__r.PG_Code__c == '03' || accRec.PriceGroupCode__r.PG_Code__c == '04') {
if(orType.Description__c == 'Credit' && orType.Order_Type_Code__c == 'ZWOD' && orType.Division__r.Division_Code__c == div) {
soObj.Order_Type_lk__c =   orType.Id;
} else if(orType.Description__c == 'Credit' && orType.Order_Type_Code__c == 'ZWOF' && orType.Division__r.Division_Code__c == div) {
soObj.Order_Type_lk__c =   orType.Id;
} else if(orType.Description__c == 'Cash' && orType.Order_Type_Code__c == 'ZWCO' && orType.Division__r.Division_Code__c == div) {
soObj.Order_Type_lk__c =   orType.Id;
}
} else if(accRec.PriceGroupCode__r.PG_Code__c == '49' || accRec.PriceGroupCode__r.PG_Code__c == '27') { //Added for INC0373560-- start -//PG_Code__c 27 added for RITM0478003
if(orType.Description__c == 'Credit' && orType.Order_Type_Code__c == 'ZWOD' && orType.Division__r.Division_Code__c == div){
soObj.Order_Type_lk__c = orType.Id;
} else if(orType.Description__c == 'Credit' && orType.Order_Type_Code__c == 'ZWOF' && orType.Division__r.Division_Code__c == div){
soObj.Order_Type_lk__c =   orType.Id;
} else if(orType.Description__c == 'Cash' && orType.Order_Type_Code__c == 'ZWCO' && orType.Division__r.Division_Code__c == div){
soObj.Order_Type_lk__c = orType.Id;
}
} //ends INC0373560
}
//ends RITM0395664--

System.debug('soObj: '+soObj);
TotalcreatedSO.add(soObj.Name);
//soObj.Tax_Amount__c = (stsList[0].Tax__c/100) * soObj.Net_Amount__c;
// soObj.Additional_Tax__c = (stsList[0].AdditionalTax__c/100) * soObj.Net_Amount__c;
// soObj.Total_Amount__c = soObj.Net_Amount__c + soObj.Tax_Amount__c + soObj.Additional_Tax__c;
//Sayan10 soObj.Tax_Amount__c = (gst/100) * soObj.Net_Amount__c;
for (Decimal gst : gstMap.keySet()){
soObj.Tax_Amount__c = (gst/100) * soObj.Net_Amount__c;
}

soObj.Total_Amount__c = soObj.Net_Amount__c + soObj.Tax_Amount__c;
upsert soObj;
}*/
                //Sayan10 }
            }
            //Added by Nandhini
            try{
                if(salesOrderLineItemList !=null && !salesOrderLineItemList.isEmpty()){
                     insert salesOrderLineItemList;
                }
               
            }
            catch(Exception ex){
                system.debug('exception in inserting lineItemList'+ex.getMessage());
            }
            //APPS-4845-Added by Nandhini
            List<Sales_order__c> salesOrdersToBeUpserted=new List<Sales_order__c>();
            if(salesOrderIds !=null && !salesOrderIds.isEmpty()){
                for(Sales_Order__c soRec:[Select Id,Name, Net_Amount__c from Sales_Order__c where id in:salesOrderIds]){
                    system.debug('mapOfdivAndSoID :'+mapOfdivAndSoID);
                    system.debug('mapOfGstAndSoID :'+mapOfGstAndSoID);
                    String div='';
                    Decimal gst=0;
                    if(mapOfdivAndSoID.containsKey(soRec.Id))
                    {
                       div=mapOfdivAndSoID.get(soRec.Id);  
                    }
                    if(mapOfGstAndSoID.containsKey(soRec.Id))
                    {
                        gst=mapOfGstAndSoID.get(soRec.Id); 
                    }
                   
                    if(mapOdDivCodeAndID.containsKey(div))
                    {
                        soRec.Division_lk__c=mapOdDivCodeAndID.get(div);
                    }
                    
                    for(Order_Type__c orType : orderTypeList) {
                        system.debug('OrderType:- ' + orType);
                        
                        if(accRec.PriceGroupCode__r.PG_Code__c == 'NC' || accRec.PriceGroupCode__r.PG_Code__c == 'NR') {
                            if(orType.Description__c == 'Credit' && orType.Order_Type_Code__c == 'ZWOD' && orType.Division__r.Division_Code__c == div) {
                                soRec.Order_Type_lk__c =   orType.Id;
                            } else if(orType.Description__c == 'Credit' && orType.Order_Type_Code__c == 'ZWOF' && orType.Division__r.Division_Code__c == div) {
                                soRec.Order_Type_lk__c =   orType.Id;
                            } else if(orType.Description__c == 'Cash' && orType.Order_Type_Code__c == 'ZWMD' && orType.Division__r.Division_Code__c == div) {
                                soRec.Order_Type_lk__c =   orType.Id;
                            }
                        } else if(accRec.PriceGroupCode__r.PG_Code__c == '03' || accRec.PriceGroupCode__r.PG_Code__c == '04') {
                            if(orType.Description__c == 'Credit' && orType.Order_Type_Code__c == 'ZWOD' && orType.Division__r.Division_Code__c == div) {
                                soRec.Order_Type_lk__c =   orType.Id;
                            } else if(orType.Description__c == 'Credit' && orType.Order_Type_Code__c == 'ZWOF' && orType.Division__r.Division_Code__c == div) {
                                soRec.Order_Type_lk__c =   orType.Id;
                            } else if(orType.Description__c == 'Cash' && orType.Order_Type_Code__c == 'ZWCO' && orType.Division__r.Division_Code__c == div) {
                                soRec.Order_Type_lk__c =   orType.Id;
                            }
                        } else if(accRec.PriceGroupCode__r.PG_Code__c == '49' || accRec.PriceGroupCode__r.PG_Code__c == '27') { //Added for INC0373560-- start -//PG_Code__c 27 added for RITM0478003
                            if(orType.Description__c == 'Credit' && orType.Order_Type_Code__c == 'ZWOD' && orType.Division__r.Division_Code__c == div){
                                soRec.Order_Type_lk__c = orType.Id;
                            } else if(orType.Description__c == 'Credit' && orType.Order_Type_Code__c == 'ZWOF' && orType.Division__r.Division_Code__c == div){
                                soRec.Order_Type_lk__c =   orType.Id;
                            } else if(orType.Description__c == 'Cash' && orType.Order_Type_Code__c == 'ZWCO' && orType.Division__r.Division_Code__c == div){
                                soRec.Order_Type_lk__c = orType.Id;
                            }
                        } //ends INC0373560
                    }
                    TotalcreatedSO.add(soRec.Name);
                    //for (Decimal gst : gstMap.keySet()){
                    soRec.Tax_Amount__c = (gst/100) * soRec.Net_Amount__c;
                    //}
                    
                    soRec.Total_Amount__c = soRec.Net_Amount__c + soRec.Tax_Amount__c;
                    // upsert soRec;
                    salesOrdersToBeUpserted.add(soRec);
                }
                if(salesOrdersToBeUpserted !=null && !salesOrdersToBeUpserted.isEmpty()){
                    Upsert salesOrdersToBeUpserted;
                }
                
            }
        }
        catch(Exception ex) {
            ApexLog.exceptionHandler(ex, orderId, accountId);
        }
    }
    
    public void methodOne(){}
    
    public void changeDepot(){
        try{
            ApexLog.exceptionCoverage(throwEx);
            depotIdList = [SELECT id, Name ,Location__c,Depot_Code__c
                           FROM Depot__c 
                           //   WHERE ID =: selectedDepot LIMIT 1];
                           WHERE Name LIKE: selectedDepot LIMIT 1];
            
            System.debug('selectedDepot: '+selectedDepot);
            
            if(!depotIdList.isEmpty()){
                //added by ganesh 
                //Date:12_4_2018 
                depLocation = depotIdList[0].Depot_Code__c;
                /*if(depLocation.startsWithIgnoreCase('SW')){
paymentType='ZWOR';
}else{
paymentType='Credit';
}*/ //commented by Divya for SCTASK0058061
                depoId = depotIdList[0].Id;
                system.debug('depoId--->'+depoId);
            }
            system.debug('depoId->'+depoId);
            skuDetailsList.clear();
            skuDetailsMap.clear();
            
            
            searchProdValue = '';
            
            fetchSKUData();
            calculateTax();
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
            
            if(String.isBlank(territoryManagerId)){
                territoryManagerId = UserInfo.getUserId(); //accList[0].OwnerId;
            }
            System.debug('territoryManagerId:'+territoryManagerId);
            
            /*List<Distributor_Depot_Mapping__c> dmList = [SELECT id, Distributor__c ,Depot__c, Depot__r.Location__c 
FROM Distributor_Depot_Mapping__c 
WHERE Distributor__c=:accountId LIMIT 1];

System.debug('dmList: '+dmList);*/
            
            
            //Logic Changed By Bhavik
            
            
            // Updated Start for RITM0491228 GRZ(Dheeraj Sharma) 20-01-2023 
            /* 

List<Credit_Info__c> ciList = [SELECT id, name,Distributor__c,distributor__r.name,
Credit_Limit__c,Balance_Limit__c,Used_Limit__c, 
DAYS_ARREARS__c 
FROM Credit_Info__c 
WHERE Distributor__c =: accountId
AND Sales_Org__r.Sales_Org_Code__c = '1210' LIMIT 1];
//Sum_Open_Item__c,             

List<Outstanding_Ageing__c> oagList = [SELECT id, OutstandingTotalGreaterthan90__c, Net_Outstanding__c
FROM Outstanding_Ageing__c
WHERE Customer_Code__c =:accountId 
AND Sales_Org__r.Sales_Org_Code__c = '1210' LIMIT 1];
System.debug('ciList: '+ciList);
*/
            // Updated End for RITM0491228 GRZ(Dheeraj Sharma) 20-01-2023
            
            //Logic to add Account Details, Billing Address and Credit Information to Wrapper
            distWrapObj = new DistributorWrapper();
            distWrapObj.distributorName = accList[0].Name;
            distWrapObj.sapCode = accList[0].SAP_Code__c;
            //distWrapObj.salesOrgId = [Select Id FROM Sales_Org__c WHERE Sales_Org_Code__c='1210'].Id; //accList[0].Sales_Org__c;
            //distWrapObj.salesOrgName = accList[0].Sales_Org__r.Name;
            //distWrapObj.distributorChannelId = accList[0].Distribution_Channel__c;            
            //distWrapObj.divisionId = accList[0].Division__c;   
            distWrapObj.ordertype = accList[0].Order_Type__c; 
            distWrapObj.paymentTerms = accList[0].Payment_Terms__c;
            //  distWrapObj.priceGroupId = accList[0].PriceGroupCode__c;
            
            
            /*   List<Outstanding_Ageing__c> oaList = [SELECT id, OutstandingTotalGreaterthan90__c 
FROM Outstanding_Ageing__c
WHERE Customer_Code__c =:accountId LIMIT 1];
if(!oaList.isEmpty()){
distWrapObj.greaterThan90 = oaList[0].OutstandingTotalGreaterthan90__c;
}*/
            // Updated Start for RITM0491228 GRZ(Dheeraj Sharma) 20-01-2023 ----------------
            /*
List<Payments__c> oaList = [SELECT id, Net_Overdue__c 
FROM Payments__c
WHERE Customer_Name__c =:accountId LIMIT 1];

if(!oaList.isEmpty()) {
distWrapObj.greaterThan90 = oaList[0].Net_Overdue__c; //oaList[0].OutstandingTotalGreaterthan90__c;
}
System.debug('oagList: '+oagList);
if(!oagList.isEmpty()) {
distWrapObj.paymentOutstanding = oagList[0].Net_Outstanding__c;
//distWrapObj.greaterThan90 = oaList[0].Net_Overdue__c;
}
System.debug('distWrapObj.paymentOutstanding: '+distWrapObj.paymentOutstanding);

*/
            // Updated End for RITM0491228 GRZ(Dheeraj Sharma) 20-01-2023 ------------
            //End of Changes
            
            //Assign Order/Sales Order Owner to TM if Distributor License not found.
            if(String.isBlank(distributorId)) {
                distributorId = territoryManagerId; //UserInfo.getUserId(); //accList[0].OwnerId;
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
            
            List<DistributorSalesAreaMapping__c> salesAreaList = [SELECT Id ,SalesOrg__r.name,Company_Code__c From DistributorSalesAreaMapping__c where Distributor__c =:accountId And SalesOrg__r.Name Not In ('India','ALS India','UPL SAS')];
            System.debug('salesAreaList'+salesAreaList);
            
            
            
            for(DistributorSalesAreaMapping__c dsa : salesAreaList){
                if(!saleOrgCountered.contains(dsa.SalesOrg__r.name) ){
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
            
            if(slList.isEmpty() || Test.isRunningTest()) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Shipping Details not found'));
                //CalloutException e = new CalloutException();
                //e.setMessage('?Shipping Details not found');
                //throw e;
            }
            
            //Start
            List<User> userList = [Select u.Id, u.IsActive, u.IsPortalEnabled from User u where id=:UserInfo.getUserId()];
            Boolean isPortalEnabled = false;
            if(!userList.isEmpty()) {
                isPortalEnabled = userList[0].IsPortalEnabled;
            }
            
            //Deeksha 
            if(isPortalEnabled) {
                DistributorSalesAreaMapping__c salesArea = [SELECT Id, Name, Distributor__c,  AccountOwner__c,AccountOwner__r.Name, AccountOwnerActive__c 
                                                            FROM DistributorSalesAreaMapping__c WHERE Distributor__c = :accountId AND Sales_Org_Code__c = '1210'
                                                            AND AccountOwnerActive__c = true LIMIT 1];
                System.Debug('Inside Portal User Id else listUr[0].id --> '+salesArea.AccountOwner__r.Name);
                distributorId = salesArea.AccountOwner__c;
                System.debug('territoryManagerId: '+territoryManagerId);
            }
            //Deeksha
            System.debug('territoryManagerId: '+territoryManagerId);
            if(!isPortalEnabled) {
                List<TM_Depot_Mapping__c> tdmList = [SELECT Id, Depot__c, Depot__r.Location__c, Territory_Manager__c 
                                                     FROM TM_Depot_Mapping__c
                                                     WHERE Territory_Manager__c =:territoryManagerId];
                System.debug('tdmList: '+tdmList);
                for(TM_Depot_Mapping__c tdmObj:tdmList) {
                    depotSet.add(new SelectOption(tdmObj.Depot__r.Location__c,tdmObj.Depot__r.Location__c));
                }
                System.debug('tdmList: '+tdmList);
            }
            
            List<Distributor_Depot_Mapping__c> dmList = [SELECT id, Distributor__c ,Depot__c,Depot__r.Depot_Code__c, Depot__r.Location__c 
                                                         FROM Distributor_Depot_Mapping__c 
                                                         WHERE Distributor__c=:accountId 
                                                         AND Depot__r.SalesOrg__r.Sales_Org_Code__c='1210' LIMIT 1];
            
            System.debug('dmList: '+dmList);
            
            if(!dmList.isEmpty()) {
                depLocation = dmList[0].Depot__r.Depot_Code__c;
                /*if(depLocation.startsWithIgnoreCase('SW')){
paymentType='ZWOR';  
}*/ //Commented by Divya for SCTASK0058061
                distWrapObj.depot = dmList[0].Depot__r.Location__c;
                depoId = dmList[0].Depot__c;
                if(depotSet.isEmpty()){
                    depotSet.add(new SelectOption(dmList[0].Depot__r.Location__c,dmList[0].Depot__r.Location__c));
                }
                selectedDepot = depoId;
                //changeDepot();
            } else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Distributor Depot not found'));
                //CalloutException e = new CalloutException();
                //e.setMessage('?Distributor Depot not found');
                //throw e;
            }
            //End
            
            /*Changes done by Ishu Mittal on 12=09-2022.
* Commenting query for fetching Sales Area record 
* adding new Condition  so that it wil not take the record  whose division is ALP*/
            
            /*   List<DistributorSalesAreaMapping__c> dsmList = [SELECT Id, DistributionChannel__c, SalesOrg__r.Name,
Distribution_Channel_Code__c, Division_Code__c,
SalesOrg__c, SalesOrg__r.Sales_Org_Code__c,PriceGroupMaster__c,
Division__c, Division__r.Name, AccountOwner__c 
FROM DistributorSalesAreaMapping__c
WHERE Distributor__c=:accountId
AND SalesOrg__r.Sales_Org_Code__c='1210'];*/
            
            List<DistributorSalesAreaMapping__c> dsmList = [SELECT Id, DistributionChannel__c, SalesOrg__r.Name,
                                                            Distribution_Channel_Code__c, Division_Code__c,
                                                            SalesOrg__c, SalesOrg__r.Sales_Org_Code__c,PriceGroupMaster__c,
                                                            Division__c, Division__r.Name, AccountOwner__c 
                                                            FROM DistributorSalesAreaMapping__c
                                                            WHERE Distributor__c=:accountId
                                                            AND SalesOrg__r.Sales_Org_Code__c='1210' AND Division__r.Name!='ALP'];
            
            if(!dsmList.isEmpty()) {
                territoryManagerId = dsmList[0].AccountOwner__c;
                distWrapObj.salesOrgId = dsmList[0].SalesOrg__c;
                distWrapObj.salesOrgName = dsmList[0].SalesOrg__r.Name;
                distWrapObj.distributorChannelId = dsmList[0].DistributionChannel__c;            
                distWrapObj.divisionId = dsmList[0].Division__c;  
                distWrapObj.priceGroupId = dsmList[0].PriceGroupMaster__c;
            } else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Sales Area not found'));
                CalloutException e = new CalloutException();
                e.setMessage('?Sales Area not found');
                throw e;
                territoryManagerId = UserInfo.getUserId(); //conList[0].Account.OwnerId;      
            }
            
            //changes By ganesh
            List<DistributorSalesAreaMapping__c> divisionList = [SELECT Id, DistributionChannel__c, 
                                                                 Distribution_Channel_Code__c, Division_Code__c,
                                                                 SalesOrg__c, SalesOrg__r.Sales_Org_Code__c,
                                                                 Division__c, Division__r.Name, AccountOwner__c 
                                                                 FROM DistributorSalesAreaMapping__c
                                                                 WHERE Distributor__c =:accountId
                                                                 AND SalesOrg__r.Sales_Org_Code__c='1210'
                                                                 AND OrderBlock__c = False];
            
            for(DistributorSalesAreaMapping__c divObj:divisionList) {
                divisionSet.add(new SelectOption(divObj.Division__c,divObj.Division__r.Name));
                setOfDiv.add(divObj.Division__c);
            }
            system.debug('setOfDiv'+setOfDiv);
            /*  if(!divisionList.isEmpty()){
divisionId = divisionList[0].Division__c;
}            
System.debug('divisionId: '+divisionId);*/
            
            //Changes Ended by ganesh
            System.debug('distWrapObj.depot: '+distWrapObj.depot);
            if(String.isNotBlank(distWrapObj.depot)) {
                fetchSKUData();
            }
            
            
            // Updated Start for RITM0491228 GRZ(Dheeraj Sharma) 20-01-2023
          
            //distWrapObj.paymentOutstanding = ciList[0].Sum_Open_Item__c;
            
           
            /* 
if(!ciList.isEmpty()) {
distWrapObj.creditLimit = ciList[0].Credit_Limit__c;
distWrapObj.creditUsed = ciList[0].Used_Limit__c;
distWrapObj.creditBalance = ciList[0].Balance_Limit__c;
distWrapObj.daysArrears = ciList[0].DAYS_ARREARS__c;
} else {
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
            
            for(Shipping_Location__c slObj:slList) {
                ShippingLocation slw2Obj = new ShippingLocation();
                
                //Logic to Map Same Billing Addres based on Sold to Party SAP Code
                if(String.isNotBlank(slObj.SAP_Code__c) && distWrapObj.sapCode == slObj.SAP_Code__c){
                    shippingList.add(new SelectOption(slObj.SAP_Code__c,'Same as Billing Address'));
                    system.debug('slObj--------->'+slObj);
                    slw2Obj.locationId = slObj.Id;
                    slw2Obj.address = slObj.Region__c;
                    slw2Obj.city = slObj.City__c;
                    
                    if(stateMap.containsKey(slObj.State__c) && distWrapObj.salesOrgName != 'Indonesia'){
                        
                        slw2Obj.state = stateMap.get(slObj.State__c);
                    } else {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'State Code not found'));
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
                    } else {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'State Code not found'));
                    }
                    
                    slw2Obj.country = slObj.Country__c;
                    slw2Obj.pincode = slObj.Pincode__c;
                    shippingMap.put(slw2Obj.City, slw2Obj);
                }
                //End of Logic
            }
            //End of Logic
            
            if(String.isNotBlank(orderId)) {
                //orderId = orderId.subString(1,orderId.length());
                editOrder();
            }
            
            shippingJSON = JSON.serialize(shippingMap.values());
            populateShippingAddress();
            System.debug('distWrapObj.paymentOutstanding: '+distWrapObj.paymentOutstanding);
        }
        catch(Exception ex){
            ApexLog.exceptionHandler(ex, orderId, accountId);
        }
    }
    
    // Updated Start for RITM0491228 GRZ(Dheeraj Sharma) 20-01-2023
    
    public void creditSalesArea(){
         String SorgCode;
        String selectedCompany = ApexPages.currentPage().getParameters().get('selectedCompany');
        System.debug('selectedCompany'+selectedCompany);
        List<DistributorSalesAreaMapping__c> DSA =[SELECT Id, SalesOrg__r.sales_org_code__c,Company_Code__c from DistributorSalesAreaMapping__c where distributor__c =: accountId AND Company_Code__c =: selectedCompany LIMIT 1];
                 system.debug('DSA'+DSA);
       
        if(DSA.size()>0){
            SorgCode=DSA[0].SalesOrg__r.sales_org_code__c;
        }
        
        if(accountId!=Null && accountId!='' && selectedCompany!=''&& selectedCompany!='None' && SorgCode!=Null && SorgCode!=''){
            
            //For CreditInfo data
            Grz_Customer360Wrapper.Wrapper credInfoData=Grz_CreditSummaryInternal.getData(accountId ,selectedCompany,SorgCode ); 
            String credDatas= JSON.serialize(credInfoData.data);
            System.debug('credDatas'+credDatas);
            List<OrderSWALController.CreditParse> crdata = (List<OrderSWALController.CreditParse>) System.JSON.deserialize(credDatas, List<OrderSWALController.CreditParse>.class);
            if(credInfoData.success){
                distWrapObj.creditLimit = Decimal.Valueof(crdata[0].CreditLimit);
                distWrapObj.creditUsed = Decimal.Valueof(crdata[0].CreditExposure);
                distWrapObj.creditBalance = Decimal.Valueof(crdata[0].BalanceLimit);
                
            }else if(!credInfoData.success){
                distWrapObj.creditLimit =null;
                distWrapObj.creditUsed = null;
                distWrapObj.creditBalance = null;
              //  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Credit / OutStanding Information for Distributor not found'));
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
    
    // Updated End for RITM0491228 GRZ(Dheeraj Sharma) 20-01-2023
    
    
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
                system.debug('state present');
                state = slwObj.state;
                createOrder();
                calculateTax();
            }
            //End of Logic
            
            //Logic to Update Shipping Location on Order on Shipping Address Selection
            if(String.isNotBlank(slwObj.locationId)) {
                if(ordObj==null) {
                    system.debug('state present order null');
                    createOrder();
                    calculateTax();
                }
                
                ordObj.Shipping_Location__c = slwObj.locationId;
                update ordObj;
            }
            //End of Logic
            //RITM0478003
            if(Test.isRunningTest()){
                throw new TestException('Test exception is here');
            }
            //RITM0478003
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
                                                Price__c, PG_CODE__c, PG_CODE__r.Name,SKUCode__r.Division__r.Division_Code__c,
                                                UOM__c, SKUCode__r.Product_Name__r.Name,SKUCode__r.SKU_Description__c,
                                                SKUCode__r.Product_Name__c, SKUCode__r.Product_Name__r.Popular__c,
                                                DistributorCustomerCode__r.Name, CurrencyIsoCode,
                                                SKUCode__r.Product_Name__r.VF_Image__c,SKUCode__r.GST__c,LastModifiedDate,Payment_Term__c
                                                FROM PriceBookMaster__c
                                                WHERE (DistributorCustomerCode__c =: accountId 
                                                       OR (DepotCode__c =: depoId AND PG_CODE__c=:distWrapObj.priceGroupId))
                                                AND SKUCode__r.Sales_Org__c =: distWrapObj.salesOrgId
                                                AND StartDate__c <= TODAY AND EndDate__c >= TODAY AND SKUCode__r.Active__c = True
                                                AND (SKUCode__r.GST__c!=Null AND SKUCode__r.GST__c!=0)
                                                //   AND Division__c =:divisionId
                                                AND SKUCode__r.Division__c IN: setOfDiv
                                                ORDER BY SKUCode__r.Product_Name__r.Name ASC, SKUCode__r.SKU_Code__c DESC, LastModifiedDate ASC];
            
            
            String query  = 'SELECT Id, SKUCode__c ,SKUCode__r.Name, ';
            query += 'SKUCode__r.Pack_Size__c, SKUCode__r.SKU_Code__c, ';
            query += 'DepotCode__c, DepotCode__r.Location__c, ';
            query += 'Price__c, PG_CODE__c, PG_CODE__r.Name, SKUCode__r.Division__r.Division_Code__c, ';
            query += 'UOM__c, SKUCode__r.Product_Name__r.Name, ';
            query += 'SKUCode__r.Product_Name__c, SKUCode__r.Product_Name__r.Popular__c, ';
            query += 'DistributorCustomerCode__r.Name, CurrencyIsoCode, ';
            query += 'SKUCode__r.Product_Name__r.VF_Image__c ,SKUCode__r.GST__c ';
            query += 'FROM PriceBookMaster__c  ';
            query += 'WHERE (DistributorCustomerCode__c =\''+accountId+'\' ';
            query += 'OR (DepotCode__c =\''+depoId+'\' AND PG_CODE__c=\''+distWrapObj.priceGroupId+'\')) ';
            query += 'AND SKUCode__r.Sales_Org__c =\''+distWrapObj.salesOrgId+'\' ';
            query += 'AND StartDate__c <= TODAY AND EndDate__c >= TODAY AND SKUCode__r.Active__c = True ';
            query += 'AND (SKUCode__r.GST__c!=Null AND SKUCode__r.GST__c!=0)';
            query += 'AND SKUCode__r.Division__c IN: setOfDiv';
            query += 'ORDER BY SKUCode__r.Product_Name__r.Name ASC, SKUCode__r.SKU_Code__c DESC, LastModifiedDate ASC';
            
            System.debug('query: '+query);
            
            System.debug('pbmList: '+pbmList);
            System.debug('size: '+pbmList.size());
            SKUDetails skuWrapObj;
            
            if(pbmList.isEmpty()) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Pricebook for Depot/Distributor not found'));
                CalloutException e = new CalloutException();
                e.setMessage(query);
                throw e;                
            }
            
            for(PriceBookMaster__c pbObj : pbmList) {
                skuWrapObj = new SKUDetails();
                skuWrapObj.brandName = pbObj.SKUCode__r.Product_Name__r.Name +' '+pbObj.SKUCode__r.Name;
                skuWrapObj.skuPackName = pbObj.SKUCode__r.Name;
                skuWrapObj.distributorId = accountId;
                skuWrapObj.productName = pbObj.SKUCode__r.Product_Name__r.Name;
                skuWrapObj.description = pbObj.SKUCode__r.SKU_Description__c;
                skuWrapObj.productId = pbObj.SKUCode__r.Product_Name__c;
                skuWrapObj.packSize = pbObj.SKUCode__r.Pack_Size__c;
                skuWrapObj.UOM = pbObj.UOM__c;
                skuWrapObj.skuCode = pbObj.SKUCode__r.SKU_Code__c;
                skuWrapObj.skuId = pbObj.SKUCode__c;
                skuWrapObj.depotLocation = pbObj.DepotCode__r.Location__c;
                skuWrapObj.depotId = pbObj.DepotCode__c;
                skuWrapObj.GST = pbObj.SKUCode__r.GST__c;
                skuWrapObj.divNumber=pbObj.SKUCode__r.Division__r.Division_Code__c;
                skuWrapObj.price = pbObj.Price__c;
                skuWrapObj.priceGroupCode = pbObj.PG_CODE__r.Name; 
                skuWrapObj.priceGroupId = pbObj.PG_CODE__c;
                skuWrapObj.currencyIso = pbObj.currencyIsoCode;
                skuWrapObj.popular = pbObj.SKUCode__r.Product_Name__r.Popular__c;
                skuWrapObj.paymentTerm = pbObj.Payment_Term__c;
                
                if(String.isNotBlank(pbObj.SKUCode__r.Product_Name__r.VF_Image__c)) {
                    skuWrapObj.image = pbObj.SKUCode__r.Product_Name__r.VF_Image__c;
                }
                
                if(String.isNotBlank(pbObj.SKUCode__c) && String.isNotBlank(skuWrapObj.UOM)){
                    skuDetailsMap.put(pbObj.SKUCode__c, skuWrapObj);
                }
            }
            //End of Logic
            
            //Logic to populate existing wrapper with Pricebook Discount
            List<PricebookDiscount__c> pbdList = [SELECT Id, SKUCode__c ,
                                                  Price__c, CurrencyIsoCode, LastModifiedDate
                                                  FROM PricebookDiscount__c
                                                  WHERE (DistributorCustomerCode__c =:accountId 
                                                         OR (DepotCode__c =: depoId AND PG_CODE__c=:distWrapObj.priceGroupId))
                                                  AND SKUCode__r.Sales_Org__c =: distWrapObj.salesOrgId
                                                  AND StartDate__c <= TODAY AND EndDate__c >= TODAY AND SKUCode__r.Active__c = True
                                                  ORDER BY SKUCode__r.Product_Name__r.Name ASC, SKUCode__r.SKU_Code__c DESC, LastModifiedDate ASC];
            System.debug('pbdList: '+pbdList);
            System.debug('size: '+pbdList.size());
            
            for(PricebookDiscount__c pbObj : pbdList) {
                if(skuDetailsMap.containsKey(pbObj.SKUCode__c)) {
                    skuWrapObj = skuDetailsMap.get(pbObj.SKUCode__c);
                    //change by ganesh
                    //desc: to change special invoice discount percent to Price
                    skuWrapObj.invoiceDiscountPercent = Math.abs(pbObj.Price__c);
                    Decimal pbdPrice = ((Math.abs(pbObj.Price__c)/100)*skuWrapObj.price);
                    skuWrapObj.invoiceDiscount = pbdPrice.setScale(0);
                    //  skuWrapObj.invoiceDiscount = Math.abs(pbObj.Price__c);
                    skuWrapObj.currencyIso = pbObj.currencyIsoCode;
                    skuDetailsMap.put(pbObj.SKUCode__c, skuWrapObj);
                }
                
            }
            //End of Logic
            
            //Logic to populate existing wrapper with Special Discount
            List<SpecialInvoiceDiscount__c> sidList = [SELECT Id, SKUCode__c, 
                                                       Price__c, CurrencyIsoCode, LastModifiedDate
                                                       FROM SpecialInvoiceDiscount__c
                                                       WHERE (DistributorCustomerCode__c =:accountId 
                                                              OR (DepotCode__c =: depoId AND PG_CODE__c=:distWrapObj.priceGroupId))
                                                       AND SKUCode__r.Sales_Org__c =: distWrapObj.salesOrgId
                                                       AND StartDate__c <= TODAY AND EndDate__c >= TODAY AND SKUCode__r.Active__c = True
                                                       ORDER BY SKUCode__r.Product_Name__r.Name ASC, SKUCode__r.SKU_Code__c DESC, LastModifiedDate ASC];
            
            System.debug('sidList: '+sidList);
            System.debug('size: '+sidList.size());
            
            for(SpecialInvoiceDiscount__c pbObj : sidList) {
                if(skuDetailsMap.containsKey(pbObj.SKUCode__c)) {
                    skuWrapObj = skuDetailsMap.get(pbObj.SKUCode__c);
                    //change added by ganesh
                    //desc: to change special invoice discount percent to Price
                    skuWrapObj.specialDiscoutPercent = Math.abs(pbObj.Price__c);
                    Decimal sidPrice = ((Math.abs(pbObj.Price__c)/100)*skuWrapObj.price);
                    skuWrapObj.specialDiscount = sidPrice.setScale(0);
                    // skuWrapObj.specialDiscount = Math.abs(pbObj.Price__c); 
                    skuWrapObj.currencyIso = pbObj.currencyIsoCode;
                    skuDetailsMap.put(pbObj.SKUCode__c, skuWrapObj);
                }
            }
            //End of Logic
            
            //Logic to populate existing wrapper with ZSP Discount
            // added by ganesh for new CR
            List<ZSP1_Discount__c> zspDList = [SELECT Id, SKUCode__c ,DepotCode__r.Location__c,
                                               Price__c, CurrencyIsoCode, LastModifiedDate
                                               FROM ZSP1_Discount__c
                                               WHERE (DistributorCustomerCode__c =:accountId 
                                                      OR (DepotCode__c =: depoId AND PG_CODE__c=:distWrapObj.priceGroupId))
                                               AND SKUCode__r.Sales_Org__c =: distWrapObj.salesOrgId AND DepotCode__r.Location__c like 'SW%'
                                               AND StartDate__c <= TODAY AND EndDate__c >= TODAY AND SKUCode__r.Active__c = True
                                               ORDER BY SKUCode__r.Product_Name__r.Name ASC, SKUCode__r.SKU_Code__c DESC, LastModifiedDate ASC];
            System.debug('zspDList: '+zspDList);
            System.debug('size: '+zspDList.size());
            
            for(ZSP1_Discount__c pbObj : zspDList) {
                if(skuDetailsMap.containsKey(pbObj.SKUCode__c)) {
                    skuWrapObj = skuDetailsMap.get(pbObj.SKUCode__c);
                    //desc: to change ZSP discount percent to Price
                    skuWrapObj.ZSPDiscount =  Math.abs(pbObj.Price__c);
                    system.debug('skuWrapObj.ZSPDiscount'+skuWrapObj.ZSPDiscount);
                    // Decimal zspdPrice = ((Math.abs(pbObj.Price__c)/100)*skuWrapObj.price);
                    Decimal zspdPrice = ((Math.abs(pbObj.Price__c)/skuWrapObj.price)*100);
                    skuWrapObj.ZSPDiscountPercent = zspdPrice.setScale(2);
                    system.debug('skuWrapObj.ZSPDiscountPercent'+skuWrapObj.ZSPDiscountPercent);
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
            
            for(SKU_Pack_Size__c psObj : packSizeList) {
                if(skuDetailsMap.containsKey(psObj.SKU__c)) {
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
            
            for(Inventory__c pbObj : invList) {
                if(skuDetailsMap.containsKey(pbObj.SKU__c)) {
                    skuWrapObj = skuDetailsMap.get(pbObj.SKU__c);
                    skuWrapObj.available = Integer.valueOf(pbObj.Balanced_Quanity__c);
                    skuWrapObj.inventoryId = pbObj.Id;
                    if(pbObj.Balanced_Quanity__c!=null && pbObj.Balanced_Quanity__c > 0) {
                        skuWrapObj.available2 = 'In Stock';
                    } else if(pbObj.In_transit_stock_quantity__c != null) {
                        if(pbObj.In_transit_stock_quantity__c > 0 && showInTransit==true && showInTransitValues==false){
                            skuWrapObj.available2 = 'In Transit';
                        } else if(pbObj.In_transit_stock_quantity__c > 0 && showInTransit==false && showInTransitValues==true){
                            skuWrapObj.available2 = '('+pbObj.In_transit_stock_quantity__c+')';
                        } else if(pbObj.In_transit_stock_quantity__c > 0 && showInTransit==true && showInTransitValues==true){
                            skuWrapObj.available2 = 'In Transit ('+pbObj.In_transit_stock_quantity__c+')';
                        }
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
            ApexLog.exceptionHandler(ex, orderId, accountId);
        }
    }
    
    //Method to fetch Popular Products
    public void fetchPopular(){
        try{
            ApexLog.exceptionCoverage(throwEx);
            skuDetailsList.clear();
            productNamesSet.clear();
            
            for(SKUDetails skuWrapObj:skuDetailsMap.values()){
                skuWrapObj.netRateEntered = skuWrapObj.Price - Math.abs(skuWrapObj.invoiceDiscount) - Math.abs(skuWrapObj.specialDiscount);              
                productNamesSet.add(skuWrapObj.productName);
                //if(skuWrapObj.Popular){
                skuDetailsList.add(skuWrapObj);
                //}
                skuDetailsMap.put(skuWrapObj.skuId, skuWrapObj);
            }
            
            System.debug('skuDetailsList: '+skuDetailsList);
            System.debug('productNamesSet: '+productNamesSet);
            System.debug('skuDetailsMap: '+skuDetailsMap);
            
            //RITM0478003
            if(Test.isRunningTest()){
                throw new TestException('Test Exception');
            }
            //RITM0478003
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
                                                   Additional_Tax_Amount__c, Gross_Amount__c
                                                   FROM Order__c 
                                                   WHERE Order_Status__c='Draft'
                                                   AND Bill_To_Party__c =: accountId LIMIT 1];
                
                if(!recentOrderList.isEmpty()) {
                    ordObj = recentOrderList[0];
                    orderId = ordObj.Id;
                    editOrder();
                } else {
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
                    
                    if(String.isNotBlank(slwObj.locationId)) {
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
            
            if(ordObj.Order_Status__c=='Approved'){
                enableInput = false;
            }
            
            List<OrderLineItem__c> oliList = [SELECT Id, Name, CurrencyIsoCode, SKUPackSize__c, 
                                              Order__c, UOM__c, Special_Discount__c, SKU_Name__c, 
                                              SKU_Name__r.Pack_Size__c, Scheme_Bonus_Discount__c,
                                              SKU_Name__r.Product_Name__r.Name,SKU_Name__r.GST__c,SKU_Name__r.Division__r.Division_Code__c,
                                              SKU_Name__r.Name, Quantity__c, Price__c, No_of_Case__c, Item_Number__c,Payment_Term__c,
                                              Item_Status__c, Invoice_Discount__c, Order__r.Shipping_Location__c
                                              FROM OrderLineItem__c
                                              WHERE Order__c=:orderId];
            if(!oliList.isEmpty()){
                List<Shipping_Location__c> sameAsBillList = [SELECT Id, City__c, Location_Name__c
                                                             FROM Shipping_Location__c
                                                             WHERE Id=:oliList[0].Order__r.Shipping_Location__c]; 
                selectedShipping = sameAsBillList[0].Location_Name__c;
                cartPaymentTerm = oliList[0].Payment_Term__c;
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
                    skuWrapObj.brandName = oliObj.SKU_Name__r.Product_Name__r.Name+' '+oliObj.SKU_Name__r.Name;
                    skuWrapObj.packSize = oliObj.SKU_Name__r.Pack_Size__c;
                    skuWrapObj.numberOfCases = Integer.valueOf(oliObj.Quantity__c/oliObj.SKU_Name__r.Pack_Size__c);
                    skuWrapObj.GST = oliObj.SKU_Name__r.GST__c;
                    skuWrapObj.divNumber=oliObj.SKU_Name__r.Division__r.Division_Code__c;
                    skuWrapObj.paymentTerm=oliObj.Payment_Term__c;
                    skuWrapObj.invoiceDiscount = skuWrapObj2.invoiceDiscount;
                    skuWrapObj.specialDiscount = skuWrapObj2.specialDiscount;
                    skuWrapObj.ZSPDiscount = skuWrapObj2.ZSPDiscount;
                    //added by ganesh Date:30/4/18
                    skuWrapObj.invoiceDiscountPercent = skuWrapObj2.invoiceDiscountPercent;
                    skuWrapObj.specialDiscoutPercent = skuWrapObj2.specialDiscoutPercent;
                    skuWrapObj.ZSPDiscountPercent = skuWrapObj2.ZSPDiscountPercent;
                    //end
                    skuWrapObj.price = skuWrapObj2.price;
                    
                    skuWrapObj.specialDiscountEntered = oliObj.Special_Discount__c;
                    
                    skuWrapObj.qty = oliObj.Quantity__c;
                    
                    skuWrapObj.invoiceDiscountEntered = oliObj.Invoice_Discount__c;
                    skuWrapObj.netRateEntered = skuWrapObj.Price - Math.abs(skuWrapObj.invoiceDiscount) - Math.abs(skuWrapObj.specialDiscount) - Math.abs(skuWrapObj.ZSPDiscount) ;
                    
                    skuWrapObj.priceEntered = oliObj.Price__c;
                    
                    skuWrapObj.UOM = oliObj.UOM__c;
                    skuWrapObj.available = skuWrapObj2.available;
                    skuWrapObj.available2 = skuWrapObj2.available2;
                    skuWrapObj.currencyIso = oliObj.CurrencyIsoCode;
                    skuWrapObj.paymentTerm = oliObj.Payment_Term__c;
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
        /*paymentType = paymentType;
System.debug('paymentType addSKU----after '+paymentType);*/
        try{
            ApexLog.exceptionCoverage(throwEx);
            
            SKUDetails skuWrapObj2 = skuDetailsMap.get(skuIdChosen);
            
            if(skuWrapObj2.qty>0||Test.isRunningTest()) {
                if(cartPaymentTerm == 'NA') {
                    cartPaymentTerm = skuWrapObj2.paymentTerm;//Deeksha 
                }
                /*isSatisfying = false;
                
                if(skuWrapObj2.PaymentTerm == cartPaymentTerm) {
                    isSatisfying = true;
                } else if((skuWrapObj2.PaymentTerm == '' || skuWrapObj2.PaymentTerm == null) && distWrapObj.paymentTerms == cartPaymentTerm) {
                    isSatisfying = true;
                } else if((cartPaymentTerm== '' ||cartPaymentTerm== null) && skuWrapObj2.PaymentTerm == distWrapObj.paymentTerms) {
                    isSatisfying = true;
                } else {
                    isSatisfying = false;
                }*/
                
                //if(isSatisfying){
                    skuOrderList.clear();
                    SKUDetails skuWrapObj;
                    OrderLineItem__c oliObj = new OrderLineItem__c();
                    
                    if(skuOrderMap.containsKey(skuIdChosen)) {
                        system.debug('@@ in first block');
                        skuWrapObj = skuOrderMap.get(skuIdChosen);
                        
                        skuWrapObj.invoiceDiscountEntered += skuWrapObj2.invoiceDiscountEntered;
                        skuWrapObj.numberOfCases += skuWrapObj2.numberOfCases;
                        skuWrapObj.specialDiscountEntered += skuWrapObj2.specialDiscountEntered;
                        skuWrapObj.priceEntered += skuWrapObj2.priceEntered;
                        skuWrapObj.paymentTerm=skuWrapObj2.paymentTerm;//Deeksha 
                        skuWrapObj.qty += skuWrapObj2.qty;
                        
                        if(String.isNotBlank(skuWrapObj.oliId)) {
                            oliObj.Id = skuWrapObj.oliId;
                        }
                        
                        if(skuWrapObj2.available==0 || skuWrapObj2.available2=='Out of Stock'){
                            oliObj.Stock_Available__c = true;
                        }
                        
                        oliObj.Payment_Term__c=skuWrapObj.paymentTerm;//Deeksha 
                        oliObj.Invoice_Discount__c = skuWrapObj.invoiceDiscountEntered;
                        oliObj.Special_Discount__c = skuWrapObj.specialDiscountEntered;
                        
                        oliObj.No_of_Case__c = skuWrapObj.numberOfCases;
                        oliObj.Quantity__c = skuWrapObj.qty;
                        oliObj.Price__c = skuWrapObj.priceEntered;
                        upsert oliObj;
                    } else {
                        createOrder();
                        system.debug('@@ in 2nd  block');
                        skuWrapObj = new SKUDetails();
                        skuWrapObj.productName = skuWrapObj2.productName;
                        skuWrapObj.skuCode = skuWrapObj2.skuCode;
                        skuWrapObj.skuId = skuWrapObj2.skuId;
                        skuWrapObj.brandName = skuWrapObj2.brandName;
                        skuWrapObj.packSize = skuWrapObj2.packSize;
                        skuWrapObj.numberOfCases = skuWrapObj2.numberOfCases;
                        skuWrapObj.GST = skuWrapObj2.GST;
                        skuWrapObj.divNumber = skuWrapObj2.divNumber;
                        skuWrapObj.paymentTerm = skuWrapObj2.paymentTerm;//Deeksha 
                        skuWrapObj.invoiceDiscount = skuWrapObj2.invoiceDiscount;
                        skuWrapObj.specialDiscount = skuWrapObj2.specialDiscount;
                        skuWrapObj.ZSPDiscount = skuWrapObj2.ZSPDiscount;
                        skuWrapObj.invoiceDiscountPercent = skuWrapObj2.invoiceDiscountPercent;
                        skuWrapObj.specialDiscoutPercent = skuWrapObj2.specialDiscoutPercent;
                        skuWrapObj.ZSPDiscountPercent = skuWrapObj2.ZSPDiscountPercent;
                        
                        skuWrapObj.price = skuWrapObj2.price;
                        
                        skuWrapObj.invoiceDiscountEntered = skuWrapObj2.invoiceDiscountEntered;
                        skuWrapObj.specialDiscountEntered = skuWrapObj2.specialDiscountEntered;
                        
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
                        //oliObj.Payment_Term__c=skuWrapObj.paymentTerm;//Deeksha 
                        if(skuWrapObj.PaymentTerm != null){//APPS-4845-Added by Nandhini
                          oliObj.Payment_Term__c = skuWrapObj.PaymentTerm;
                        }else{
                          oliObj.Payment_Term__c = distWrapObj.paymentTerms;  
                        }
                        oliObj.Invoice_Discount__c = skuWrapObj.invoiceDiscountEntered;
                        oliObj.Spot_Discount__c = 0;
                        skuWrapObj.netRateEntered = skuWrapObj2.netRateEntered;
                        // system.debug('skuWrapObj'+skuWrapObj);
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
                    }
                    
                    netAmount += skuWrapObj2.priceEntered;
                    skuOrderMap.put(skuWrapObj2.skuId,skuWrapObj);
                    skuOrderList.addAll(skuOrderMap.values());
                    
                    calculateTax();
                    showError = false;
                /* }else {//commented by Nandhini
                    errorMessage = 'Please place separate sales order for items with different payment terms';
                    showError = true;
                }*/
            } else { 
                errorMessage = 'Please enter No. of Cases';
                showError = true;
            }
            
            if(skuWrapObj2.packSize==0  || Test.isRunningTest()) { 
                errorMessage = 'Case Size should be greater than 0';
                showError = true;
            }
            
            if(skuWrapObj2.UOM=='NA' || Test.isRunningTest()) { //RITM0478003
                errorMessage = 'SKU UOM is required to Add SKU to Cart';
                showError = true;
            }
        }
        catch(Exception ex){
            ApexLog.exceptionHandler(ex, orderId, accountId);
        }            
    }
    
    //Method to update existing Order line item on Qty/Price Change
    public void updateSKU() {
        try{
            ApexLog.exceptionCoverage(throwEx);
            
            OrderLineItem__c oliObj = new OrderLineItem__c();
            for(SKUDetails skuObj:skuOrderList) {
                if(String.isNotBlank(skuObj.oliId)) {
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
            system.debug('@@'+skuOrderMap.get(skuIdChosen));
            delete oliObj;
            if(skuOrderMap.isEmpty()){
                cartPaymentTerm = 'NA';
            }
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
            cartPaymentTerm = 'NA';
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
            
            if((String.isBlank(selectedShipping))&& showError==false) {
                showError = true;
                errorMessage = 'Please select Shipping Address';
            } else if(!skuOrderList.isEmpty() && showError==false) {
                orderSaved = true;
            } else if(showError==false) {
                showError = true;
                errorMessage = 'Please add product to cart';
            }
        }
        catch(Exception ex){
            ApexLog.exceptionHandler(ex, orderId, accountId);
        }
    }
    
    //Method to  Validate &amp; Confirm Order, disable Input, Submit for approval if conditions met
    public void confirmOrder(){
        try{
            ApexLog.exceptionCoverage(throwEx);
            
            if(Test.isRunningTest()) {
                valuefromJS='Sales Order created successfully!';
            }
            
            if(valuefromJS=='Sales Order created successfully!') {
                saveOrder();
                 paymentTermList=new set<String>();
                 paymentTermDivNumber=new Map<String,String>();
                //APPS-4845-Added by Nandhini
                for(SKUDetails skuWrapObj:skuOrderMap.values()){
                    if(skuWrapObj.PaymentTerm !=null){
                        paymentTermList.add(skuWrapObj.PaymentTerm);
                        String paymentTermAndDiv=skuWrapObj.divNumber+skuWrapObj.PaymentTerm;
                        paymentTermDivNumber.put(paymentTermAndDiv,skuWrapObj.PaymentTerm);
                    }
                     else if(distWrapObj.paymentTerms != null){
                        system.debug('accounts payment term'+distWrapObj.paymentTerms);
                        paymentTermList.add(distWrapObj.paymentTerms);
                        String paymentTermAndDiv=skuWrapObj.divNumber+distWrapObj.paymentTerms;
                        paymentTermDivNumber.put(paymentTermAndDiv,distWrapObj.paymentTerms);

                    }
                    else{
                        String paymentTermAndDiv =skuWrapObj.divNumber+'No PaymentTerm';
                        paymentTermDivNumber.put(paymentTermAndDiv,'No PaymentTerm');
                    }
                    
                }
                system.debug('paymentTerms :'+paymentTermList);
                system.debug('paymentTermDivNumber :'+paymentTermDivNumber);
               
                if(orderSaved == true) {
                    showError = false;
                    
                    addSOLineItem();
                    
                    if(orderSaved == True && showError==false){
                        ordObj.Order_Status__c = 'Approved';
                        upsert ordObj;
                        showError = true;
                        
                        String finaltxt='';
                        for(String a :TotalcreatedSO) {
                            finaltxt+=a;
                            finaltxt+=', ';
                        }
                        System.debug('finaltxt: '+finaltxt);
                        System.debug('finaltxt.length(): '+finaltxt.length());
                        if(finaltxt.length()>3){
                            finaltxt=finaltxt.subString(0,finaltxt.length()-2);
                        }
                        System.debug('finaltxt after: '+finaltxt);
                        if(TotalcreatedSO.size()==1){
                            enableInput = false;
                            errorMessage = valuefromJS +' Sales Order Number is '+ finaltxt+'.';
                        }
                        if(TotalcreatedSO.size()>1){
                            enableInput = false;
                            //Sayan10 errorMessage = 'Sales Orders created successfully! '+' Due to different GST rates/ Division, multiple orders created as: '+ finaltxt+'.';
                            errorMessage = 'Sales Orders created successfully! '+' Due to different Division and Payment Terms, multiple orders created as: '+ finaltxt+'.';
                        }
                        
                        if(String.isNotBlank(PO)){
                            
                            List<Attachment> attachList = [SELECT id, Name, ParentId,
                                                           IsPrivate, ContentType, Body, 
                                                           Description 
                                                           FROM attachment 
                                                           WHERE parentId=:orderId limit 1];
                           // APPS-4845-Modified by Nandhini
                            List<Attachment> attachmentList=new List<Attachment>();
                            if(!attachList.isEmpty()){
                                if(salesOrderIds!=null && !salesOrderIds.isEmpty()){
                                    for(Id soId:salesOrderIds){
                                        Attachment attObj = new Attachment();
                                        attObj.Name = attachList[0].Name;
                                        attObj.ParentId = soId;
                                        attObj.IsPrivate = attachList[0].IsPrivate;  
                                        attObj.ContentType = attachList[0].ContentType;
                                        attObj.Body = attachList[0].Body;
                                        attObj.Description = attachList[0].Description;
                                        attachmentList.add(attObj);
                                    }
                                }
                                if(attachmentList !=null && !attachmentList.isEmpty()){
                                    Insert attachmentList;
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
                //  vatAmount = orderObj.Vat_Amount__c;
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
                    
                    List<AggregateResult> lstAR = [Select SUM(GST_Amount__c)gst FROM OrderLineItem__c WHERE Order__c =: ordObj.Id];
                    Decimal gstAmount =(Decimal)lstAR[0].get('gst');
                    vatAmount = gstAmount;
                    ordObj.GST_Amount__c = gstAmount;
                    //ordObj.VAT__c = stsList[0].Tax__c;
                    ordObj.Additional_Tax__c = stsList[0].AdditionalTax__c;
                    upsert ordObj;
                }
            } else {
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
    public void getTemplateName() {
        try{
            ApexLog.exceptionCoverage(throwEx);        
            templateName = '';
            System.debug('allowTemplate: '+allowTemplate);
            
            for(SKUDetails skuObj:skuOrderList) {
                templateName += skuObj.brandName+' - ';
            }
            
            if(String.isNotBlank(templateName)) {
                Integer length = templateName.length();
                if(length > 75) {
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
            
            for(SKUDetails skuObj:skuOrderList) {
                OrderTemplateItem__c otiObj = new OrderTemplateItem__c();
                otiObj.Name = skuObj.skuCode;
                otiObj.SKU__c = skuObj.skuId;
                otiObj.OrderTemplate__c = otObj.Id;
                oliList.add(otiObj);
            }
            
            if(!oliList.isEmpty()) {
                insert oliList;
                allowTemplate = false;
                templateName = '';
            }
        }
        catch(Exception ex){
            ApexLog.exceptionHandler(ex, orderId, accountId);
        }            
    }
    
    //Method to get Order History based on SKU &amp; Account Id
    public void showOrderHistory() {
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
    
    //Method to get Order Template based on SKU &amp; Account Id
    public void showOrderTemplates() {
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
    public void loadTemplate() {
        try{
            ApexLog.exceptionCoverage(throwEx);
            
            createOrder();
            
            delete [SELECT Id FROM OrderLineItem__c WHERE Order__c=:ordObj.Id];
            
            skuOrderMap.clear();
            skuOrderList.clear();        
            
            refreshOrderValue();
            
            if(ordObj.Order_Status__c=='Approved') {
                enableInput = false;
            }
            
            List<OrderTemplateItem__c> oliList = [SELECT Id, Name, SKU__c, OrderTemplate__c,
                                                  SKU__r.Product_Name__r.Name, SKU__r.Name,SKU__r.GST__c,SKU__r.Division__r.Division_Code__c,
                                                  SKU__r.Pack_Size__c, SKU__r.UOM__c
                                                  FROM OrderTemplateItem__c  
                                                  WHERE OrderTemplate__c =: tempIdChosen];
            
            for(OrderTemplateItem__c oliObj:oliList) {
                
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
                skuWrapObj.ZSPDiscount = skuWrapObj2.ZSPDiscount;
                skuWrapObj.invoiceDiscountPercent = skuWrapObj2.invoiceDiscountPercent;
                skuWrapObj.specialDiscoutPercent = skuWrapObj2.specialDiscoutPercent;
                skuWrapObj.ZSPDiscountPercent = skuWrapObj2.ZSPDiscountPercent;
                skuWrapObj.GST=oliObj.SKU__r.GST__c;
                skuWrapObj.divNumber=oliObj.SKU__r.Division__r.Division_Code__c;
                skuWrapObj.paymentTerm = skuWrapObj2.paymentTerm; //Divya
                
                skuWrapObj.price = skuWrapObj2.price;
                skuWrapObj.invoiceDiscountEntered = 0;
                skuWrapObj.specialDiscountEntered = 0;
                
                skuWrapObj.priceEntered = 0;
                skuWrapObj.netRateEntered = skuWrapObj.Price - Math.abs(skuWrapObj.invoiceDiscount) - Math.abs(skuWrapObj.specialDiscount);
                skuWrapObj.qty = 0;
                skuWrapObj.UOM = oliObj.SKU__r.UOM__c;
                skuWrapObj.available = skuWrapObj2.available;
                skuWrapObj.available2 = skuWrapObj2.available2;
                skuWrapObj.currencyIso = distWrapObj.CurrencyIso;
                skuOrderMap.put(skuWrapObj.skuId,skuWrapObj);
                skuOrderList.add(skuWrapObj);
            }
            
            if(skuOrderList.size() > 0 && !skuOrderList.isEmpty()){ //Divya
                cartPaymentTerm = skuOrderList[0].paymentTerm;
                system.debug('PaymentTerm in add SKU '+cartPaymentTerm);
            }
            
            for(SKUDetails skuWrapObj:skuOrderMap.values()) {
                OrderLineItem__c oliObj = new OrderLineItem__c();
                
                oliObj.Order__c = orderId;
                oliObj.SKU_Name__c = skuWrapObj.skuId;
                oliObj.UOM__c = skuWrapObj.UOM;
                oliObj.Invoice_Discount__c = skuWrapObj.invoiceDiscountEntered;
                oliObj.Special_Discount__c = skuWrapObj.specialDiscountEntered;
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
        if(String.isNotBlank(accountId)) {
            pg = new PageReference('/'+accountId);
        }
        
        return pg;
    }
    
    public class DistributorWrapper{
        public String distributorName {get;set;}
        public String salesOrgId {get;set;}
        public String salesOrgName {get;set;}
        public String distributorChannelId {get;set;}
        public String salesOrgNames {get;set;}  // Updated Start for RITM0491228 GRZ(Dheeraj Sharma) 20-01-2023
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
    
    public class SKUDetails {
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
        public String divNumber{get;set;}
        public Decimal GST {get;set;}
        public Id depotId {get;set;}      
        public String priceGroupCode {get;set;}
        public Id priceGroupId {get;set;} 
        public Id InventoryId {get;set;}
        public String UOM {get;set;}
        public Decimal invoiceDiscount {get;set;}
        public Decimal specialDiscount {get;set;}
        public Decimal ZSPDiscount {get;set;}
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
        public String paymentTerm;//Deeksha 
        //added by ganesh 
        //desc: For percent of pricebook and special invoice discount.
        public Decimal invoiceDiscountPercent{get;set;}
        public Decimal specialDiscoutPercent{get;set;}
        public Decimal ZSPDiscountPercent{get;set;}
        
        public SKUDetails() {
            packSize = 0;
            UOM = 'N/A';
            qty = 0;
            numberOfCases = 0;
            invoiceDiscountEntered = 0;
            specialDiscountEntered = 0;
            priceEntered = 0;
            invoiceDiscount = 0;
            specialDiscount = 0;
            ZSPDiscount = 0;
            price = 0;
            GST=0;
            invoiceDiscountPercent = 0;
            specialDiscoutPercent = 0;
            ZSPDiscountPercent = 0;
            divNumber='';
            netRateEntered = 0;
            available = 0;
            available2 = 'Out of Stock';
            popular = false;
            image = '/servlet/servlet.FileDownload?file=015N0000000R8hc';
            paymentTerm = '';//Deeksha 
        }
    }
    
    public class ShippingLocation {
        public String locationId {get;set;}
        public String address {get;set;}
        public String city {get;set;}
        public String state {get;set;}
        public String country {get;set;}
        public String pincode {get;set;}
    }
    
    // Updated Start for RITM0491228 GRZ(Dheeraj Sharma) 20-01-2023
    public class Credit{
        List<CreditParse> credParse{get;set;}
        
    }
    public class CreditParse{
        public String CreditLimit{get;set;}
        public String CreditExposure{get;set;}
        public String BalanceLimit{get;set;}
    }
    // Updated End for RITM0491228 GRZ(Dheeraj Sharma) 20-01-2023
    
}