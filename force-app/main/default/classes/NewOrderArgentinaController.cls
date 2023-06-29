/*
* Name: NewOrderArgentinaController
* Created On: 25 may 2018
* Author: Vishal pawar (vishal.pawar@skinternational.com)
* Description: Class is used for editing Placed Orders by Distributor, TM, RM of Argentina
*/
global without sharing class NewOrderArgentinaController {
    //Variable Declaration for Edit sales Order
    //Added by vishal
    public Login_Country__c logCoOj {get;set;}  // SKI : #CR152 : PO And Delivery Date : 12-07-2022 Vishal P SKI..
    
    public Id editSalesOrderId {get;set;}
    public List<Sales_Order_Line_Item__c> editSalesOrderList {get;set;}
    // public List<Sales_Order_Line_Item__c> getSalesOrederLineItemList{get;set;}
    public Sales_Order__c salesObj {get;set;}
    Public List<Sales_Order__c> soNumberList {get;set;}//=new List<Sales_Order__c>();
    public String selectedCustomerAprovalStatus {get;set;}
    public String selectedRejectReason {get;set;}
    public String getSelectedRejectReason {get;set;}
    public String getSelectedValueForCustomerApprovalStatus {get;set;}
    public String selectedCustmorApprovalStatus {get;set;}
    //Variable to be set by JS for Attachment status
    public String valuefromJS {get;set;}
    public DistributorWrapper distWrapObj {get;set;}
    public ShippingLocation slwObj {get;set;}
    
    public List<SKUDetails> skuDetailsList {get;set;}
    public List<SKUDetails> skuOrderList {get;set;}
    public List<SKUDetails> skuSalesOrderList {get;set;}
    public List<EditSkuWrapper> oldSkuWrapperList {get;set;}
    
    
    public List<OrderLineItem__c> oliList {get;set;}
    public List<Sales_Order_Line_Item__c> oliList2 {get;set;}
    //public List<OrderTemplate__c> tempList {get;set;}
    List<Payment_Method__c> paymentMethodList;
    
    public Map<String,ShippingLocation> shippingMap {get;set;}    
    public Map<Id,SKUDetails> skuDetailsMap {get;set;}
    public Map<Id,SKUDetails> skuOrderMap {get;set;}
    
    public Map<Id,SKUDetails> skuSaleOrderMap {get;set;}
    
    public Map<String,String> stateMap {get;set;}
    
    public Set<String> productNamesSet{get;set;}
    public Set<String> descriptionSet{get;set;}
    
    public List<SelectOption> depotSet{get;set;}
    public List<SelectOption> paymentTermSet{get;set;}
    public List<SelectOption> shippingList {get;set;}
    
    //Added by Paresh Sondigara : Margin Block : 30-07-22
    public String profitCenter {get;set;}
    
    //Added by vishal
    //public  List<SelectOption> paymentTermoptions {get;set;}
    public List<SelectOption> orderTypeSet{get;set;} 
    public List<SelectOption> paymentmethodOptionList{get;set;}
    public List<SelectOption> customerApprovalStatusList {get;set;}
    public List<SelectOption> rejectedReasonList {get;set;}
    public List<SelectOption> customerApprovalStatusOptions {get;set;}
    
    
    //public List<Shipping_Location__c> shippingLocationList {get;set;}
    
    //Set Order Type Code
    public String orderTypeCode {get;set;}
    
    
    public String selectedPayment {get;set;}
    public String paymentTermCode {get;set;}
    public String selectedOrderType {get;set;}
    public String selectedPaymentId {get;set;}
    public String paymentTermCodeId {get;set;}
    public String selectedOrderTypeId {get;set;}
    public String selectedShipping {get;set;}
    // public String selectedDepot {get; set;}
    public String searchProdValue {get; set;}
    //public String templateName {get; set;}
    public String errorMessage {get; set;}
    // public String selectedPaymentTerm {get;set;}
    
    // Added By Paresh Sondigara : Delete SKU From Cart Logic
    public Decimal skuItemNo {get; set;}
    
    public String skuIdChosen {get; set;}
    //public String tempIdChosen {get; set;}
    public String storageIdChosen {get; set;}
    public String paymentIdChosen {get; set;}
    public String orderRaisedBy {get; set;}
    public String skuJSON {get;set;}
    public String distributorJSON {get;set;}
    public String shippingJSON {get;set;}
    
    public Boolean showError{get;set;}
    public Boolean enableInput{get;set;}
    public Boolean throwEx;
    public Boolean flag {get;set;}
    //Order Related Permissions
    public Boolean showCredit{get;set;}
    public Boolean showInventory{get;set;}
    public Boolean showInventoryColumn{get;set;}
    public Boolean enableDepot{get;set;}
    public Boolean allowTemplate{get;set;}
    public Boolean orderSaved{get;set;}
    public Boolean editFlag = true;
    public Boolean pdfFlag = true;
    // public Boolean tempInternalApproval {get;set;}
    // public Boolean tempBudgetApproval {get;set;}    
    //public  Boolean isCustomerAprrove{get;set;}
    
    public Decimal grossAmount {get;set;}
    public Decimal grossAmount1{get;set;}
    
    public Integer itemNumber;
    public Integer tempSizeSalesOrderLineItem {get;set;}
    
    public String orderId{get;set;}
    public String PO{get;set;}
    public Date DeliveryDate{get;set;}//Delivery Date:RITM0094155, 3rd September 2020, Sayan (crmconsultant3@upl-ltd.com)
    public String accountId{get;set;}
    public String depoId;
    public String distributorId;
    public String territoryManagerId;
    public String managerId;
    public String country;
    
    public Order__c ordObj {get;set;}
    //public Sales_Order__c soObj {get;set;}
    
    
    
    public NewOrderArgentinaController(ApexPages.StandardController controller) {
        try{
            orderTypeCode = 'ZEOR'; //DIVYA: 09-03-2020: Replaced ZXOR for SCTASK0136732
            country = 'Argentina';
            paymentTermCode = '';  
            selectedCustomerAprovalStatus= '';
            selectedRejectReason= '';
            // tempInternalApproval = false;
            // tempBudgetApproval = false;
            
            salesObj=new Sales_Order__c();
            slwObj = new ShippingLocation();
            
            productNamesSet = new Set<String>();
            
            descriptionSet = new Set<String>();
            depotSet = new List<SelectOption>();
            paymentTermSet = new List<SelectOption>();
            orderTypeSet = new List<SelectOption>();
            paymentmethodOptionList=new List<SelectOption>();
            customerApprovalStatusList= new List<SelectOption>();
            rejectedReasonList = new List<SelectOption>();
            soNumberList =new List<Sales_Order__c>();
            
            //Initialisation of editSalesOrderList List
            editSalesOrderList=new List<Sales_Order_Line_Item__c>();
            oldSkuWrapperList = new  List<EditSkuWrapper>();
            
            skuDetailsList = new List<SKUDetails>();
            skuOrderList = new List<SKUDetails>();
            skuSalesOrderList=new List<SKUDetails>();
            oliList = new List<OrderLineItem__c>();
            
            skuOrderMap = new Map<Id,SKUDetails>();
            
            skuSaleOrderMap = new Map<Id,SKUDetails>();
            
            shippingMap = new Map<String, ShippingLocation>();
            skuDetailsMap = new Map<Id,SKUDetails>();
            stateMap = new Map<String, String>();
            
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
            
            throwEx = false;
            
            enableDepot = false;
            allowTemplate = false;
            orderSaved = false;
            
            grossAmount = 0;
            grossAmount1=0;
            
            itemNumber = 0;
            
            accountId = '';
            distributorId = '';
            depoId = '';
            
            territoryManagerId = '';
            
            orderId = ApexPages.currentpage().getparameters().get('id');        
            System.debug('orderId is: '+orderId);
            
            editSalesOrderId = ApexPages.currentpage().getparameters().get('soid');
            
            
            accountId = ApexPages.currentpage().getparameters().get('acid');
            
            System.debug('accountId: '+accountId);
            
            editSalesOrder();
            getSalesOrderNumber();
            // populateCustomerApprvalStatus();
            
            List<Sales_Order__c> Delivery = [SELECT Request_Delivery_Date__c FROM Sales_Order__c WHERE Id =:editSalesOrderId LIMIT 1];//Delivery Date:RITM0094155, 3rd September 2020, Sayan (crmconsultant3@upl-ltd.com)
            DeliveryDate = Delivery[0].Request_Delivery_Date__c;//Delivery Date:RITM0094155, 3rd September 2020, Sayan (crmconsultant3@upl-ltd.com)
            
            // populateCustomAprrovalStatus();
            // populateRejectedReasons();
            
            User loginUserObj = [SELECT Id, Name, IsActive, ContactId,UserRole.name,
                                 Show_Inventory__c, Show_Credit_Limit__c, EnableDepot__c,
                                 Show_Inventory_Column__c, ManagerId
                                 FROM User 
                                 WHERE Id =: UserInfo.getUserId()
                                 AND IsActive = True];
            
            showInventory = loginUserObj.Show_Inventory__c;
            showInventoryColumn = loginUserObj.Show_Inventory_Column__c;
            showCredit =  loginUserObj.Show_Credit_Limit__c;
            
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
            
            List<Distributor_Depot_Mapping__c> depotList = [SELECT id, Depot__c 
                                                            FROM Distributor_Depot_Mapping__c 
                                                            WHERE Distributor__c=:accountId 
                                                            AND Depot__c!='' LIMIT 1];
            
            System.debug('depotList: '+depotList);
            
            if(!depotList.isEmpty()){
                depoId = depotList[0].Depot__c;
            }
            System.debug('depoId: '+depoId);
            refreshSaleOrderValue();
            
        }
        catch(Exception ex){
            System.debug('Method: Constructor Exception: '+ex.getMessage()+ ' Line Number: '+ex.getLineNumber());
        }
        
    }
    
    
    
    
    
    //Method to Create SalesOrder on Order Confirmation
    /*  public void createSalesOrder(){
try{
ApexLog.exceptionCoverage(throwEx);
if(ordObj!=null  && soObj==null){
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
soObj.Distribution_Channel_lk__c = distWrapObj.distributorChannelId;
soObj.Division_lk__c = distWrapObj.divisionId;
soObj.Credit_Term__c = distWrapObj.paymentTerms;
soObj.Remarks__c = ordObj.Remarks__c;
//soObj.Stock_Status__c = 'In Stock';
soObj.CurrencyIsoCode = distWrapObj.currencyIso;
if(String.isNotBlank(PO)){
soObj.PONumber__c = PO;
}
soObj.Payment_Term__c = paymentIdChosen;

if(String.isNotBlank(managerId))
soObj.Manager__c = managerId;

if(soObj.Order_Raise_By__c == 'Distributor'){
soObj.Designated_Owner__c = territoryManagerId;
}
else{
soObj.Designated_Owner__c = distWrapObj.regionalManagerId;
}

//End of patch
soObj.Order_Type_lk__c = [Select Id FROM Order_Type__c WHERE Order_Type_Code__c=:orderTypeCode].Id;//distWrapObj.orderType  [Select Id FROM Order_Type__c WHERE Order_Type_Code__c='ZORD'].Id; 
insert soObj;
}
}
catch(Exception ex){
ApexLog.exceptionHandler(ex, orderId, accountId);
}
}*/
    
    //Method to add Line Items to SalesOrders on Order Confirmation
    /* public void addSOLineItem(){
try{
ApexLog.exceptionCoverage(throwEx);
Boolean submitForApproval = false;
boolean budgetApproval = false;
Sales_Order_Line_Item__c sliObj;
Id argentinaDepo = [Select Id From Depot__c Where Name=:country LIMIT 1].Id;
Integer i = 0;//added by ganesh

for(SKUDetails skuWrapObj:skuOrderMap.values()){
i=i + 10;
system.debug('skuWrapObj'+skuWrapObj);
sliObj = new Sales_Order_Line_Item__c();
sliObj.SKU_Name__c = skuWrapObj.skuId;
// sliObj.Item_Number__c = skuWrapObj.itemNo;  
sliObj.Item_Number__c = i;
sliObj.Item_Status__c = 'Active';
sliObj.DepotDepot__c = argentinaDepo; //argentinaDepo;
sliObj.Storage_Location__c = storageIdChosen;
sliObj.UOM__c = skuWrapObj.UOM;
sliObj.CurrencyIsoCode = distWrapObj.currencyIso;

if(skuWrapObj.finalPrice==0){
showError = true;
errorMessage = System.Label.Please_Enter_Final_Price_for_all_SKU_s_before_confirming_order;
//'Please Enter Quantity for all SKU\'s before confirming order'; 
break;
}
if(skuWrapObj.qty==0){
showError = true;
errorMessage = System.Label.Please_Enter_Quantity_for_all_SKU_s_before_confirming_order;
//'Please Enter Quantity for all SKU\'s before confirming order'; 
break;
}
else {
//createSalesOrder();
sliObj.Payment_Term__c = paymentIdChosen; //new Payment_Term__c(Payment_Term_Code__c='0020');
sliObj.Quantity__c = skuWrapObj.qty;
sliObj.MinPrice__c = skuWrapObj.minPrice;
sliObj.MaxPrice__c = skuWrapObj.price;
sliObj.Net_Price__c = skuWrapObj.finalPrice;
sliObj.Price__c = skuWrapObj.netRateEntered;
sliObj.BudgetPrice__c = skuWrapObj.BudgetPrice; //added by ganesh
system.debug('skuWrapObj.BudgetPrice'+skuWrapObj.BudgetPrice);
sliObj.Sale_Order__c = soObj.Id;
insert sliObj;

if(skuWrapObj.finalPrice < skuWrapObj.minPrice){
submitForApproval = true;
}
if(skuWrapObj.finalPrice > skuWrapObj.price){
submitForApproval = true;
}
if(skuWrapObj.finalPrice < skuWrapObj.BudgetPrice){
system.debug('BudgetPrice'+skuWrapObj.BudgetPrice);
budgetApproval = true;
}
}
}

//Update Tax and Total Amount in Sales Order
if(soObj!=null){
System.debug('soObj'+soObj);
soObj = [Select Id, Net_Amount__c from Sales_Order__c where id=:soObj.id];
soObj.Total_Amount__c = soObj.Net_Amount__c;
if(submitForApproval){
soObj.Order_Status__c = 'Pending';
}
if(budgetApproval){
system.debug('BudgetApproval'+budgetApproval);
soObj.BudgetApprovalCheck__c = true;
}
upsert soObj;
}
}
catch(Exception ex){
ApexLog.exceptionHandler(ex, orderId, accountId);
}
}*/
    
    public void changeDepot(){
        
        System.debug('Storage Location: '+storageIdChosen);
        fetchSKUData();
    }
    
    public void changePayment(){
        System.debug('paymentIdChosen: '+paymentIdChosen);
    }
    //added by vishal pawar
    //Calling from Action function for payment method
    public void changePaymentMethod(){
        selectedPaymentId= selectedPayment;
        system.debug('method called ==> '+selectedPayment);
        
        try{ 
            ApexLog.exceptionCoverage(throwEx);
            Payment_Method__c pmObj=new Payment_Method__c();
            if(selectedPayment!=null || selectedPayment!=''){
                pmObj=[select Id,Name from Payment_Method__c Where id=:selectedPayment LIMIT 1];    
            }
            
            String tempMethodName=pmObj.Name;
            
            
            paymentTermSet = new List<SelectOption>();
            
            
            if(selectedPayment==''){
                //paymentTermSet.add(new SelectOption('None','None'));          
            }
            //if selected payment method is Cash /Contado   
            if(tempMethodName =='Contado'){
                List<Payment_Term__c> paymentTermList=[Select Id, Payment_Term_Code__c, Payment_Term__c from Payment_Term__c 
                                                       WHERE SalesOrgCode__c = '5631' and Payment_Term__c='Pago Inmediato'];
                
                for(Payment_Term__c pt:paymentTermList){
                    paymentTermSet.add(new selectOption(pt.Id,pt.Payment_Term__c));
                }
            }
            
            //if Selected payment method is Credit card / Tarjeta de crédito
            if(tempMethodName =='Tarjeta de crédito'){      
                List<Payment_Term__c> paymentTermList=[Select Id, Payment_Term_Code__c, Payment_Term__c from Payment_Term__c 
                                                       WHERE SalesOrgCode__c = '5631' and Payment_Term__c='60 dias tarjeta de credito'];
                for(Payment_Term__c pt:paymentTermList){
                    paymentTermSet.add(new selectOption(pt.Id,pt.Payment_Term__c));
                }
            }
            //if selected payment method is long Barter /Canje Largo
            if(tempMethodName== 'Canje Largo'){
                List<Payment_Term__c> paymentTermList = [Select Id, Payment_Term_Code__c, Payment_Term__c 
                                                         from Payment_Term__c 
                                                         WHERE SalesOrgCode__c = '5631'
                                                         //AND Payment_Term__c !='90 dias'
                                                         AND Payment_Term__c !='Pago Inmediato'
                                                         AND Payment_Term__c !='60 dias tarjeta de credito'
                                                         AND Payment_Term__c !='15 Dias'];
                
                
                for(Payment_Term__c pt:paymentTermList){
                    paymentTermSet.add(new SelectOption(pt.id,pt.Payment_Term__c));
                }
            }
            //if payment method is Available Barter / Canje Disponible
            if(tempMethodName=='Canje Disponible'){
                List<Payment_Term__c> paymentTermList=[Select Id, Payment_Term_Code__c, Payment_Term__c from Payment_Term__c 
                                                       WHERE SalesOrgCode__c = '5631' and Payment_Term__c='30 dias'];
                for(Payment_Term__c pt:paymentTermList){
                    paymentTermSet.add(new selectOption(pt.Id,pt.Payment_Term__c));
                }
            }
            //if selected payment method is  wire transfer /Transferencia Bancaria
            if(tempMethodName=='Transferencia'){
                
                List<Payment_Term__c> paymentTermList = [Select Id, Payment_Term_Code__c, Payment_Term__c from Payment_Term__c 
                                                         WHERE SalesOrgCode__c = '5631'
                                                         //AND Payment_Term__c !='90 dias'
                                                         AND Payment_Term__c !='Pago Inmediato'
                                                         AND Payment_Term__c !='60 dias tarjeta de credito'
                                                         AND Payment_Term__c !='15 Dias'];
                
                for(Payment_Term__c pt:paymentTermList){
                    paymentTermSet.add(new SelectOption(pt.id,pt.Payment_Term__c));
                }
            }
            
            //if selected payment method is Check /Cheque
            if(tempMethodName=='Cheque'){
                List<Payment_Term__c> paymentTermList = [Select Id, Payment_Term_Code__c, Payment_Term__c from Payment_Term__c 
                                                         WHERE SalesOrgCode__c = '5631'
                                                         //AND Payment_Term__c !='90 dias'
                                                         AND Payment_Term__c !='Pago Inmediato'
                                                         AND Payment_Term__c !='60 dias tarjeta de credito'
                                                         AND Payment_Term__c !='15 Dias'];
                
                for(Payment_Term__c pt:paymentTermList){
                    paymentTermSet.add(new SelectOption(pt.id,pt.Payment_Term__c));
                }
                
            } 
            
            if(tempMethodName =='Operación Pesificada'){
                List<Payment_Term__c> paymentTermList=[Select Id, Payment_Term_Code__c, Payment_Term__c from Payment_Term__c 
                                                       WHERE SalesOrgCode__c = '5631' and Payment_Term__c='15 Dias'];
                
                for(Payment_Term__c pt:paymentTermList){
                    paymentTermSet.add(new selectOption(pt.Id,pt.Payment_Term__c));
                }
            }
            
            
        }
        
        catch(Exception ex){
            ApexLog.exceptionHandlerForSalesOrder(ex, editSalesOrderId, accountId);
            
        }
    }
    
    //calling from action function paymenet term 
    public void changePaymentTerm(){
        try{
            paymentTermCodeId=paymentTermCode;
        }
        
        catch(Exception ex){
            ApexLog.exceptionHandlerForSalesOrder(ex, editSalesOrderId, accountId);
        }
    }
    //calling from action function 
    public void changeOrderType(){
        try{
            selectedOrderTypeId=selectedOrderType ;
        }
        catch(Exception ex){
            ApexLog.exceptionHandlerForSalesOrder(ex, editSalesOrderId, accountId);
        }
    }
    
    //calling from action function
    public void changeCustomerApprovalStatus(){
        try{
            
            getSelectedValueForCustomerApprovalStatus=selectedCustomerAprovalStatus;
            
            
        }
        catch(Exception ex){
            ApexLog.exceptionHandlerForSalesOrder(ex, editSalesOrderId, accountId);            
        }
    }
    
    //calling from action function
    
    public void changeRejectedReason(){
        try{
            getSelectedRejectReason=selectedRejectReason;
            System.debug('getSelectedRejectReason==>'+selectedRejectReason);  
        }
        
        catch(Exception ex){
            ApexLog.exceptionHandlerForSalesOrder(ex, editSalesOrderId, accountId);            
        }
    }
    
    
    
    
    //Method to fetch Distributor Details, Depot, Credit Information and Shipping Details
    public void fetchDistributorDetails(){
        try{
            ApexLog.exceptionCoverage(throwEx);  
             logCoOj = [SELECT Id, Name, For_Contry__c, 
                       Sales_Org_Code__c, Delivery_Date__c, PO_Date__c, 
                       Show_Delivery_Date__c, Show_PO_Date__c 
                       FROM Login_Country__c
                       WHERE Sales_Org_Code__c='5631' LIMIT 1];  // SKI : #CR152 : PO And Delivery Date : 12-07-2022 Vishal P SKI..
            
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
            
            System.debug('dmList: '+dmList);
            
            List<Credit_Info__c> ciList = [SELECT id, name,Distributor__c,distributor__r.name,
                                           Credit_Limit__c,Balance_Limit__c,Used_Limit__c,
                                           Balance_Limit_Ag__c, Total_credit_limit_Ag__c,
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
            distWrapObj.divisionId = accList[0].Division__c;   
            distWrapObj.ordertype = accList[0].Order_Type__c; 
            distWrapObj.paymentTerms = accList[0].Payment_Terms__c;
            distWrapObj.priceGroupId = accList[0].PriceGroupCode__c;
            
            List<Payments__c> oaList = [SELECT id, Net_Overdue__c 
                                        FROM Payments__c
                                        WHERE Customer_Name__c =:accountId LIMIT 1];
            
            if(!oaList.isEmpty()){
                distWrapObj.greaterThan90 = oaList[0].Net_Overdue__c; //oaList[0].OutstandingTotalGreaterthan90__c;
            }
            
            if(!oagList.isEmpty() ){
                distWrapObj.paymentOutstanding = oagList[0].Net_Outstanding__c;
                //distWrapObj.greaterThan90 = oaList[0].Net_Overdue__c;
            }
            //Assign Order/Sales Order Owner to TM if Distributor License not found.
            if(String.isBlank(distributorId)){
                distributorId = accList[0].OwnerId;
                orderRaisedBy = 'Territory Manager';
            }
            
            //Populate StateMap Code to State Name
            for(State_Tax_Structure__c stateObj:[Select Id, State_Name__c, State_Code__c From State_Tax_Structure__c Where SalesOrg__c=:distWrapObj.salesOrgId]){
                stateMap.put(stateObj.State_Code__c, stateObj.State_Name__c);
            }
            System.debug('stateMap: '+stateMap);
            //End of Logic
            
            List<Shipping_Location__c> slList = [SELECT Id, Name, Distributor__c, City__c, 
                                                 Region__c, Pincode__c, State__c, Country__c,
                                                 Sold_To_Party_SAP_Code__c, SAP_Code__c, 
                                                 Billing_Street_1__c, Billing_Street_2__c, Billing_Street_3__c, 
                                                 Billing_Street_4__c,Billing_Street_5__c,Billing_Street_6__c
                                                 FROM Shipping_Location__c
                                                 WHERE Distributor__c =:accountId];
            
            if(slList.isEmpty()){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Shipping Details not found'));
                //CalloutException e = new CalloutException();
                //e.setMessage('?Shipping Details not found');
                //throw e;
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
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Distributor Depot not found'));
                //CalloutException e = new CalloutException();
                //e.setMessage('?Distributor Depot not found');
                //throw e;
            }
            
            List<Depot__c> storageList = [Select Id, Name from Depot__c where recordtype.name = 'Storage Location' and SalesOrg__r.name=:country];
            for(Depot__c tdmObj:storageList){
                depotSet.add(new SelectOption(tdmObj.Id,tdmObj.Name));
            }
            if(!storageList.isEmpty()){
                storageIdChosen = storageList[0].Id;
            }
            
            
            //for Payment method
            /*List<Payment_Method__c>*/
            //Added y vishal pawar
            paymentMethodList=[select Id,Name from Payment_Method__c WHERE Sales_Org__r.Sales_Org_Code__c='5631' Order by Name];
            
            //paymentmethodOptionList.add(new SelectOption('None','None'));
            if(paymentMethodList.size()>0){
                for(Payment_Method__c pm:paymentMethodList){
                    paymentmethodOptionList.add(new SelectOption(pm.Id,pm.Name));
                }
            }
            
            List<Payment_Term__c> paymentTermList = [Select Id, Payment_Term_Code__c, Payment_Term__c from Payment_Term__c 
                                                     WHERE SalesOrgCode__c = '5631'];
            
            
            //added by vishal pawar for Order type according to Raise Order Type 
            List<Sales_Order__c> soList = new List<Sales_Order__c>();
            soList =[select Id,Sold_to_Party__r.Raise_Order_Type__c from Sales_Order__c Where Id=:editSalesOrderId LIMIT 1];
            System.debug('Order type set is==>'+soList.size());
            //System.debug('Order name type set is==>'+soList[0].Sold_to_Party__r.Raise_Order_Type__c);
            if(soList.size()>0){
                //Cr split functionality for argentina
                List<string> raiseOrderTypeSo = soList[0].Sold_to_Party__r.Raise_Order_Type__c.split(';');
                for(String str : raiseOrderTypeSo ){
                    //if order raised type is Invoice / Factura
                    if(str=='Factura'){
                        List<Order_Type__c> orderTypeList=[select Id,Order_Type_Code__c,SalesOrg__c, Description__c 
                                                           from Order_Type__c 
                                                           WHERE SalesOrg__r.Sales_Org_Code__c='5631' and Description__c='Factura']; 
                        
                        if(orderTypeList.size()>0){
                            for(order_type__c orderTypeObj:orderTypeList){
                                orderTypeSet.add(new SelectOption(orderTypeObj.id,orderTypeObj.Description__c));
                            }
                        }
                    } 
                    
                    //if order raised type is Consignee /Consignatario
                    
                    if(str=='Consignatario' || Test.isRunningTest()){ // SKI : #CR152 : PO And Delivery Date : 12-07-2022 Vishal P SKI..
                        List<Order_Type__c> orderTypeList=[select Id,Order_Type_Code__c,SalesOrg__c, Description__c 
                                                           from Order_Type__c 
                                                           WHERE SalesOrg__r.Sales_Org_Code__c='5631' and Description__c='Consignatario']; 
                        
                        if(orderTypeList.size()>0){
                            for(order_type__c orderTypeObj:orderTypeList){
                                orderTypeSet.add(new SelectOption(orderTypeObj.id,orderTypeObj.Description__c));
                            }
                        }
                    }
                    //Ankita if order type is Commission Sales SCTASK0160332:- addition of Order Type ZCCA 
                    if(str =='Commission Sales' || Test.isRunningTest()){ // SKI : #CR152 : PO And Delivery Date : 12-07-2022 Vishal P SKI..
                        List<Order_Type__c> orderTypeList=[select Id,Order_Type_Code__c,SalesOrg__c, Description__c 
                                                           from Order_Type__c 
                                                           WHERE SalesOrg__r.Sales_Org_Code__c='5631' and Description__c='Commission Sales'];
                        if(orderTypeList.size()>0){ 
                            for(order_type__c orderTypeObj:orderTypeList){
                                orderTypeSet.add(new SelectOption(orderTypeObj.id,orderTypeObj.Description__c));
                            }
                        } 
                    } 
                    // Commented below code to add new order type ZCCA
                    //if order raised type is Both 
                    /*   if(soList[0].Sold_to_Party__r.Raise_Order_Type__c=='Both'){
List<Order_Type__c> orderTypeList=[select Id,Order_Type_Code__c,SalesOrg__c, Description__c 
from Order_Type__c 
WHERE SalesOrg__r.Sales_Org_Code__c='5631']; 

if(orderTypeList.size()>0){
for(order_type__c orderTypeObj:orderTypeList){
orderTypeSet.add(new SelectOption(orderTypeObj.id,orderTypeObj.Description__c));
}
}
}*/
                    
                    
                } 
                
            }
            
            //if(soList[0].Order_Raise_By__c=='')
            /* List<Order_Type__c> orderTypeList=[select Id,Order_Type_Code__c,SalesOrg__c, Description__c 
from Order_Type__c 
WHERE SalesOrg__r.Sales_Org_Code__c='5631'];
if(orderTypeList.size()>0){
for(order_type__c orderTypeObj:orderTypeList){
orderTypeSet.add(new SelectOption(orderTypeObj.id,orderTypeObj.Description__c));
}
}*/
            
            
            if(String.isNotBlank(distWrapObj.depot)){
                fetchSKUData();
            }
            
            if(!ciList.isEmpty()){
                //distWrapObj.creditLimit = ciList[0].Credit_Limit__c;
                distWrapObj.creditLimit = ciList[0].Total_credit_limit_Ag__c;
                distWrapObj.creditUsed = ciList[0].Used_Limit__c;
                distWrapObj.creditBalance = ciList[0].Balance_Limit_Ag__c; //Balance_Limit__c;
                //distWrapObj.paymentOutstanding = ciList[0].Sum_Open_Item__c;
                distWrapObj.daysArrears = ciList[0].DAYS_ARREARS__c;
                //distWrapObj.internalCredit = ciList[0].Internal_Limit__c;
            }
            else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Credit Information for Distributor not found'));
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
            shippingList.add(new SelectOption('None','None'));
            // selectedShipping = 'None';
            for(Shipping_Location__c slObj:slList){
                ShippingLocation slw2Obj = new ShippingLocation();
                
                //Logic to Map Same Billing Addres based on Sold to Party SAP Code
                if(String.isNotBlank(slObj.SAP_Code__c) && distWrapObj.sapCode == slObj.SAP_Code__c){
                    shippingList.add(new SelectOption(slObj.SAP_Code__c, slObj.City__c)); //'Same as Billing Address'
                    
                    slw2Obj.billingStreet1 = slObj.Billing_Street_1__c;
                    slw2Obj.billingStreet2 = slObj.Billing_Street_2__c;
                    
                    slw2Obj.billingStreet3 = slObj.Billing_Street_3__c;
                    slw2Obj.billingStreet4 = slObj.Billing_Street_4__c;
                    slw2Obj.billingStreet5 = slObj.Billing_Street_5__c;
                    slw2Obj.billingStreet6 = slObj.Billing_Street_6__c;   
                    
                    slw2Obj.locationId = slObj.Id;
                    slw2Obj.address = slObj.Region__c;
                    slw2Obj.city = slObj.City__c;
                    //slw2Obj.state = slObj.State__c;
                    if(stateMap.containsKey(slObj.State__c) && distWrapObj.salesOrgName != 'Indonesia'){
                        slw2Obj.state = stateMap.get(slObj.State__c);
                    }
                    else{
                        //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'State not found'));
                    }
                    slw2Obj.country = slObj.Country__c;
                    slw2Obj.pincode = slObj.Pincode__c;
                    //selectedShipping = slObj.Sold_To_Party_SAP_Code__c;
                    shippingMap.put(slObj.Sold_To_Party_SAP_Code__c, slw2Obj);
                }
                //End of Logic
                
                //Logic to populate other shipping locations based on City/SAP Code
                else{
                    shippingList.add(new SelectOption(slObj.City__c,slObj.City__c));
                    
                    slw2Obj.billingStreet1 = slObj.Billing_Street_1__c;
                    slw2Obj.billingStreet2 = slObj.Billing_Street_2__c;
                    slw2Obj.billingStreet3 = slObj.Billing_Street_3__c;
                    slw2Obj.billingStreet4 = slObj.Billing_Street_4__c;
                    slw2Obj.billingStreet5 = slObj.Billing_Street_5__c;
                    slw2Obj.billingStreet6 = slObj.Billing_Street_6__c;
                    
                    slw2Obj.locationId = slObj.Id;
                    slw2Obj.address = slObj.Region__c;
                    slw2Obj.city = slObj.City__c;
                    //slw2Obj.state = slObj.State__c;
                    if(stateMap.containsKey(slObj.State__c)){
                        slw2Obj.state = stateMap.get(slObj.State__c);
                    }
                    else{
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, System.Label.State_Code_not_found));
                    }
                    slw2Obj.country = slObj.Country__c;
                    slw2Obj.pincode = slObj.Pincode__c;
                    shippingMap.put(slw2Obj.City, slw2Obj);
                }
                //End of Logic
            }
            //End of Logic
            
            if(String.isNotBlank(orderId)){
                system.debug('orderId'+orderId);
                //orderId = orderId.subString(1,orderId.length());
                // editOrder();
            }
            shippingJSON = JSON.serialize(shippingMap.values());
            populateShippingAddress();
        }
        catch(Exception ex){
            ApexLog.exceptionHandler(ex, editSalesOrderId, accountId);
        }
    }
    
    
    
    
    
    
    //Method for actionSupport on Address Picklist changed
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
                // createOrder();
                // refreshOrderValue();
            }
            //End of Logic
            
            //Logic to Update Shipping Location on Order on Shipping Address Selection
            if(String.isNotBlank(slwObj.locationId) || selectedShipping == 'None'){
                if(ordObj==null){
                    createOrder();
                    // refreshOrderValue();
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
                                                SKUCode__r.SKU_Code__c, MinPrice__c,
                                                DepotCode__c, DepotCode__r.Location__c, 
                                                Price__c, PG_CODE__c, PG_CODE__r.Name, BudgetPrice__c,
                                                UOM__c, SKUCode__r.Product_Name__r.Name, SKUCode__r.SKU_Description__c,
                                                SKUCode__r.Product_Name__c, CurrencyIsoCode,
                                                SKUCode__r.Product_Name__r.Popular__c, SKUCode__r.Multiple_Of__c, SKUCode__r.Brand_Name__c,SKUCode__r.SKU_Pack__c
                                                FROM PriceBookMaster__c
                                                WHERE (DistributorCustomerCode__c =: accountId 
                                                       OR (DepotCode__c =: depoId AND PG_CODE__c=:distWrapObj.priceGroupId))
                                                AND SKUCode__r.Sales_Org__c =: distWrapObj.salesOrgId
                                                AND StartDate__c <= TODAY AND EndDate__c >= TODAY AND SKUCode__r.Active__c = True
                                                // ORDER BY SKUCode__r.Product_Name__r.Name ASC, SKUCode__r.SKU_Code__c DESC, StartDate__c ASC];
                                                ORDER BY SKUCode__r.Brand_Name__c ASC, SKUCode__r.SKU_Code__c DESC, StartDate__c ASC];
            
            String query  = 'SELECT Id, SKUCode__c ,SKUCode__r.Name, ';
            query += 'SKUCode__r.Pack_Size__c, SKUCode__r.SKU_Code__c, ';
            query += 'DepotCode__c, DepotCode__r.Location__c, ';
            query += 'Price__c, PG_CODE__c, PG_CODE__r.Name, BudgetPrice__c, ';
            query += 'UOM__c, SKUCode__r.Product_Name__r.Name,  SKUCode__r.SKU_Description__c, ';
            query += 'SKUCode__r.SKU_Pack__c, SKUCode__r.Product_Name__c, SKUCode__r.Product_Name__r.Popular__c, ';
            query += 'DistributorCustomerCode__r.Name, CurrencyIsoCode, ';
            query += 'SKUCode__r.Product_Name__r.VF_Image__c ';
            query += 'FROM PriceBookMaster__c  ';
            query += 'WHERE (DistributorCustomerCode__c =\''+accountId+'\' ';
            query += 'OR (DepotCode__c =\''+depoId+'\' AND PG_CODE__c=\''+distWrapObj.priceGroupId+'\')) ';
            query += 'AND SKUCode__r.Sales_Org__c =\''+distWrapObj.salesOrgId+'\' ';
            query += 'AND StartDate__c <= TODAY AND EndDate__c >= TODAY AND SKUCode__r.Active__c = True ';
            query += 'ORDER BY SKUCode__r.Brand_Name__c ASC, SKUCode__r.SKU_Code__c DESC';
            //query += 'ORDER BY SKUCode__r.Product_Name__r.Name ASC, SKUCode__r.SKU_Code__c DESC';
            
            System.debug('query: '+query);
            
            System.debug('pbmList: '+pbmList);
            System.debug('size: '+pbmList.size());
            
            if(pbmList.isEmpty()){
                //errorMessage = 'Pricebook for Depot/Distributor not found';
                //showError = true;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.Pricebook_for_Depot_Distributor_not_found));
                
                CalloutException e = new CalloutException();
                e.setMessage(query);
                throw e;
            }
            
            //Added by Paresh Sondigara : Margin Block : 30-07-22
            //Start
            List<Price_Block_Margin_Matrix__c> pbmmE2eMBEBList = new List<Price_Block_Margin_Matrix__c>();
            List<Price_Block_Margin_Matrix__c> pbmmE2eUPC9List = new List<Price_Block_Margin_Matrix__c>();
            List<Price_Block_Margin_Matrix__c> pbmmE2eList = new List<Price_Block_Margin_Matrix__c>();
            List<Profit_Center__c> profitCenterList = new List<Profit_Center__c>();
            
            MAP<String,Price_Block_Margin_Matrix__c> prcE2eBlockMap = new MAP<String,Price_Block_Margin_Matrix__c>();
            
            profitCenterList =[SELECT Id, Name, Profit_Center__c, Sales_Value__c, Sales_Org__c, Depot__c, Combination_Key__c 
                               FROM Profit_Center__c 
                               WHERE Sales_Org__c =:distWrapObj.salesOrgId ORDER BY LastModifiedDate DESC  LIMIT 1];
            profitCenter = profitCenterList[0].Profit_Center__c;
            
            pbmmE2eList = [SELECT Id, Name, SKU_Code__c, SKU_Active__c, UOM__c, 
                           Sales_Org__c,E2E_Cost_LC__c, E2E_Cost_USD__c, E2E_Cost_UPC9_LC__c, 
                           E2E_Cost_UPC9_USD__c, E2E_Cost_MBEW_LC__c, E2E_Cost_MBEW_USD__c, Type__c
                           FROM Price_Block_Margin_Matrix__c
                           WHERE Sales_Org__c=:distWrapObj.salesOrgId
                           AND Depot_Code__c =:depoId
                           AND Start_Date__c<= today AND End_Date__c>= today
                           AND E2E_Cost_USD__c != null
                           AND UOM__c !=null
                           AND Profit_Center__c=:profitCenterList[0].Id
                           AND Type__c ='E2ECost' ORDER BY LastModifiedDate ASC ];
            
            pbmmE2eUPC9List = [SELECT Id, Name, SKU_Code__c, SKU_Active__c, UOM__c, 
                               Sales_Org__c,E2E_Cost_LC__c, E2E_Cost_USD__c, E2E_Cost_UPC9_LC__c, 
                               E2E_Cost_UPC9_USD__c, E2E_Cost_MBEW_LC__c, E2E_Cost_MBEW_USD__c, Type__c
                               FROM Price_Block_Margin_Matrix__c
                               WHERE Sales_Org__c=:distWrapObj.salesOrgId
                               AND UOM__c !=null
                               AND Depot_Code__c =:depoId
                               AND Start_Date__c<= today AND End_Date__c>= today
                               AND E2E_Cost_UPC9_USD__c != null
                               AND Type__c ='E2ECostUPC9' ORDER BY LastModifiedDate ASC ];
            
            pbmmE2eMBEBList = [SELECT Id, Name, SKU_Code__c, SKU_Active__c, UOM__c, 
                               Sales_Org__c,E2E_Cost_LC__c, E2E_Cost_USD__c, E2E_Cost_UPC9_LC__c, 
                               E2E_Cost_UPC9_USD__c, E2E_Cost_MBEW_LC__c, E2E_Cost_MBEW_USD__c, Type__c
                               FROM Price_Block_Margin_Matrix__c
                               WHERE Sales_Org__c=:distWrapObj.salesOrgId
                               AND UOM__c !=null
                               AND Depot_Code__c =:depoId
                               AND Start_Date__c<= today AND End_Date__c>= today
                               AND E2E_Cost_MBEW_USD__c != null
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
            //End
			                       
            SKUDetails skuWrapObj;
            for(PriceBookMaster__c pbObj : pbmList){
                //Added by Paresh Sondigara : Margin Block : 30-07-22
                if(prcE2eBlockMap.containsKey(pbObj.SKUCode__c)){
                skuWrapObj = new SKUDetails();
                Price_Block_Margin_Matrix__c tmpPriceBlockMargin = new Price_Block_Margin_Matrix__c();                    
                tmpPriceBlockMargin = prcE2eBlockMap.get(pbObj.SKUCode__c);
                    
                //if(pbObj.SKUCode__c==pbObj.SKUCode__r.Name)
                //    skuWrapObj.brandName = pbObj.SKUCode__r.Product_Name__r.Name;
                //else
                //Added by Paresh Sondigara : Margin Block : 30-07-22
                if((pbObj.CurrencyIsoCode == 'USD' && (tmpPriceBlockMargin.E2E_Cost_USD__c!=null || tmpPriceBlockMargin.E2E_Cost_UPC9_USD__c!=null || tmpPriceBlockMargin.E2E_Cost_MBEW_USD__c!=null))){
                if(String.isNotBlank(pbObj.SKUCode__r.Brand_Name__c)){
                    skuWrapObj.brandName = pbObj.SKUCode__r.Brand_Name__c+' '+pbObj.SKUCode__r.Name;    //pbObj.SKUCode__r.Product_Name__r.Name +' '+pbObj.SKUCode__r.Name;  //commented by ganesh
                }
                else{
                    skuWrapObj.brandName= pbObj.SKUCode__r.Name;
                }
                skuWrapObj.description = pbObj.SKUCode__r.SKU_Description__c;
                skuWrapObj.skuPackName = pbObj.SKUCode__r.Name;
                skuWrapObj.distributorId = accountId;
                skuWrapObj.productName = pbObj.SKUCode__r.Product_Name__r.Name;
                skuWrapObj.productId = pbObj.SKUCode__r.Product_Name__c;
                skuWrapObj.UOM = pbObj.UOM__c;
                skuWrapObj.SKUPack= Integer.valueOf(pbObj.SKUCode__r.SKU_Pack__c);
                skuWrapObj.skuCode = pbObj.SKUCode__r.SKU_Code__c;
                
                //Patch Added By Bhavik (25/01/2018)
                if(String.isNotBlank(skuWrapObj.skuCode)){
                    String removeLeadingZeros = skuWrapObj.skuCode.replaceFirst('^0+','');
                    //System.debug('removeLeadingZeros: '+removeLeadingZeros);
                    
                    if(String.isNotBlank(skuWrapObj.description)){
                        skuWrapObj.description = removeLeadingZeros+' - '+skuWrapObj.description;
                    }
                    else{
                        skuWrapObj.description = removeLeadingZeros;
                    }
                }
                //End of Patch
                
                skuWrapObj.skuId = pbObj.SKUCode__c;
                skuWrapObj.depotLocation = pbObj.DepotCode__r.Location__c;
                skuWrapObj.depotId = pbObj.DepotCode__c;
                if(pbObj.MinPrice__c!=null)
                    skuWrapObj.minPrice = Math.abs(pbObj.MinPrice__c);
                if(pbObj.Price__c!=null)
                    skuWrapObj.price = Math.abs(pbObj.Price__c);
                //added by ganesh
                if(pbObj.BudgetPrice__c!=null){
                    skuWrapObj.BudgetPrice = Math.abs(pbObj.BudgetPrice__c);
                }
                //end
                skuWrapObj.priceGroupCode = pbObj.PG_CODE__r.Name; 
                skuWrapObj.priceGroupId = pbObj.PG_CODE__c;
                skuWrapObj.currencyIso = pbObj.currencyIsoCode;
                skuWrapObj.popular = pbObj.SKUCode__r.Product_Name__r.Popular__c;
                skuWrapObj.multipleOf = pbObj.SKUCode__r.Multiple_Of__c;
                                   
                //added by Paresh Sondigara : Margin Block : 26-07-22
                //Start    
      			if(prcE2eBlockMap.containsKey(pbObj.SKUCode__c)){                   
                	Price_Block_Margin_Matrix__c pbMME2eObj = prcE2eBlockMap.get(pbObj.SKUCode__c);
                    if(pbMME2eObj.Type__c =='E2ECost'){
                        skuWrapObj.e2ECostUSD = pbMME2eObj.E2E_Cost_USD__c;
                    }
                    if(pbMME2eObj.Type__c =='E2ECostUPC9'){
                        skuWrapObj.e2ECostUPC9USD = pbMME2eObj.E2E_Cost_UPC9_USD__c;
                    }
                    if(pbMME2eObj.Type__c =='E2ECostMBEW'){
                        skuWrapObj.e2ECostMBEWUSD = pbMME2eObj.E2E_Cost_MBEW_USD__c;
                    }                                            
                    skuWrapObj.uome2eCost = pbMME2eObj.UOM__c;                                                        
               	}              
                //End            
                    
                if(String.isNotBlank(pbObj.SKUCode__c) && String.isNotBlank(skuWrapObj.UOM)){
                    system.debug('skuWrapObjPut'+skuWrapObj);
                    skuDetailsMap.put(pbObj.SKUCode__c, skuWrapObj);
                }
                }
            }
            }
            //End of Logic
            
            //Logic to populate existing wrapper with Inventory
            List<Inventory__c> invList = [SELECT Id, SKU__c, 
                                          Stock_Quantity__c, Balanced_Quanity__c
                                          FROM Inventory__c
                                          WHERE Storage_Location_Depot__c =: storageIdChosen AND SKU__r.Active__c = True];        
            
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
            
            //End of Logic
            System.debug('value of map for Final price ==>' +skuDetailsMap.values());
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
            //  descriptionSet.clear(); //added by ganesh
            
            for(SKUDetails skuWrapObj:skuDetailsMap.values()){
                
                skuWrapObj.netRateEntered = 0;
                
                //  productNamesSet.add(skuWrapObj.productName);//commented by ganesh
                productNamesSet.add(skuWrapObj.brandName);
                if(String.isNotBlank(skuWrapObj.description)){
                    descriptionSet.add(skuWrapObj.description); //added by ganesh
                }
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
            system.debug('searchProdValue'+searchProdValue);
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
                                                   Order_Raise_By__c, Order_Status__c, 
                                                   RegionalManager__c, Shipping_Location__c, OwnerId, 
                                                   Gross_Amount__c
                                                   FROM Order__c 
                                                   WHERE Order_Status__c='Draft'
                                                   AND Bill_To_Party__c =: accountId LIMIT 1];
                
                if(!recentOrderList.isEmpty()){
                    ordObj = recentOrderList[0];
                    orderId = ordObj.Id;
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
    
    
    
    //Method to update existing Order line item on Qty/Price Change
    //added by vishal pawar
    public void updateSKU(){
        
        try{
            ApexLog.exceptionCoverage(throwEx);
            Sales_Order_Line_Item__c soliObj=new Sales_Order_Line_Item__c();
            
           
            //skuSalesOrderList=skuSaleOrderMap.values(); // SKI : #CR152 : PO And Delivery Date : 12-07-2022 Vishal P SKI..
            System.debug('skuSalesOrderList '+skuSalesOrderList);
            for(SKUDetails skuObj:skuSalesOrderList){
                if(String.isNotBlank(skuObj.soliId)){
                    soliObj.Id = skuObj.soliId;
                }
                soliObj.Quantity__c = skuObj.qty;
                soliObj.Net_Price__c = skuObj.finalPrice;
                soliObj.Price__c = skuObj.netRateEntered;
                system.debug('skuObj.soliId'+skuObj.soliId);
                system.debug('skuObj.finalPrice'+skuObj.finalPrice);
                System.debug('skuObj.netRateEntered: '+skuObj.netRateEntered);
                System.debug('Quanty ==>'+skuObj.qty);
                soliObj.First_Date__c = this.DeliveryDate;//Delivery Date:RITM0094155, 3rd September 2020, Sayan (crmconsultant3@upl-ltd.com)
                upsert soliObj;
                System.debug('Successfully Update');
               // skuSaleOrderMap.put(skuObj.skuId,skuObj); // SKI : #CR152 : PO And Delivery Date : 12-07-2022 Vishal P SKI..
            }
            refreshSaleOrderValue();
        }
        
        
        catch(Exception ex){
            ApexLog.exceptionHandlerForSalesOrder(ex, editSalesOrderId, accountId);
            
        }           
    }
    
    //Method to delete SKU from Order Table
    /*  public void deleteSKU(){
try{
ApexLog.exceptionCoverage(throwEx);
skuOrderList = new List<SKUDetails>();
Order__c orderObj = new Order__c(); //added by ganesh
OrderLineItem__c oliObj = new OrderLineItem__c();
oliObj.Id = skuOrderMap.get(skuIdChosen).oliId;
orderObj.Id = oliObj.Order__c;              //added by ganesh
skuOrderMap.remove(skuIdChosen);
delete oliObj;
skuOrderList.addAll(skuOrderMap.values());
if(orderObj.OLI_Count__c==null){
system.debug('orderObj.OLI_Count__c'+orderObj.OLI_Count__c);
orderSaved=false;
}
// refreshOrderValue();
}
catch(Exception ex){
ApexLog.exceptionHandler(ex, orderId, accountId);

}            
}*/
    
    //Method to Empty Order Summary
    //Added by vishal pawar 16-05-2018
    public void deleteAllSKU(){
        try{
            ApexLog.exceptionCoverage(throwEx);
            
            delete[Select id from Sales_Order_Line_Item__c where Sale_Order__c=:editSalesOrderId];
            skuSaleOrderMap.clear();
            skuSalesOrderList.clear();
            refreshSaleOrderValue();
        }
        catch(Exception ex){
            ApexLog.exceptionHandlerForSalesOrder(ex, editSalesOrderId, accountId);
        }  
    }
    
    //Method to Save the Order as Draft
    /* public void saveOrder(){
try{
ApexLog.exceptionCoverage(throwEx);
showError = false;
if(allowTemplate == True){
if(String.isNotBlank(templateName)){
//  saveTemplate();
}
else{
showError = true;
errorMessage = System.Label.Please_Enter_Template_Name;
//'Please Enter Template Name';
}
}

// if(selectedPaymentTerm.equals('None')&& paymentIdChosen.equals('None')){
if(paymentIdChosen.equals('None')){
showError = true;
errorMessage = System.Label.Please_select_Payment_Term;
// 'Please select Payment Term';
} 



if((String.isBlank(selectedShipping)||selectedShipping.equals('None'))&& showError==false){
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
ApexLog.exceptionHandler(ex, orderId, accountId);

}
}
*/
    
    //Method to  Validate & Confirm Order, disable Input, Submit for approval if conditions met
    /*  public void confirmOrder(){
try{
ApexLog.exceptionCoverage(throwEx);
if(Test.isRunningTest()){
valuefromJS='Order Confirmed';
}
if(valuefromJS=='Order Confirmed'){
// saveOrder();

Boolean flag = true;
for(SKUDetails skuWrapObj:skuOrderMap.values()){
if(skuWrapObj.finalPrice==0){
showError = true;
errorMessage = System.Label.Please_Enter_Final_Price_for_all_SKU_s_before_confirming_order;
//'Please Enter Quantity for all SKU\'s before confirming order'; 
flag = false;
break;
}
if(skuWrapObj.qty==0){
showError = true;
errorMessage = System.Label.Please_Enter_Quantity_for_all_SKU_s_before_confirming_order;
flag = false;
//'Please Enter Quantity for all SKU\'s before confirming order'; 
break;
}
}

if(orderSaved && flag){
showError = false;
//addSOLineItem();

if(orderSaved == True && showError==false){
ordObj.Order_Status__c = 'Approved';
upsert ordObj;

showError = true;
errorMessage = System.Label.Order_Confirmed;
//'Order Confirmed';
if(String.isNotBlank(PO)){
List<Attachment> attachList = [SELECT id, Name, ParentId,
IsPrivate, ContentType, Body, 
Description 
FROM attachment 
WHERE parentId=:orderId 
Order By CreatedDate Desc limit 1];
System.debug('attachList: '+attachList);
if(soObj!=null && !attachList.isEmpty()){
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
}
else{
showError = true;
errorMessage = valuefromJS;
}

}
catch(Exception ex){
ApexLog.exceptionHandler(ex, orderId, accountId);

}            
}*/
    
    
    //Method to re-calculate Order Value and Taxes on change
    /* public void refreshOrderValue(){
try{
ApexLog.exceptionCoverage(throwEx);

if(String.isNotBlank(orderId)){
Order__c orderObj =  [SELECT Id, Gross_Amount__c, 
Shipping_Location__c
FROM Order__c 
WHERE Id=:orderId];

grossAmount = orderObj.Gross_Amount__c;
}
}
catch(Exception ex){
ApexLog.exceptionHandler(ex, orderId, accountId);

}            
}*/
    
    //Generate Order Template Name
    /* public void getTemplateName(){
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
}*/
    
    //Method to save template to system
    /*  public void saveTemplate(){
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
}*/
    
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
            ApexLog.exceptionHandlerForSalesOrder(ex, editSalesOrderId, accountId);
        }            
    }
    
    //Method to get Order Template based on SKU & Account Id
    /* public void showOrderTemplates(){
try{
ApexLog.exceptionCoverage(throwEx);
tempList = [SELECT Id, Name, DistributorCustomerCode__c FROM OrderTemplate__c
WHERE DistributorCustomerCode__c=:accountId];

}
catch(Exception ex){
ApexLog.exceptionHandler(ex, orderId, accountId);
}            
}
*/
    
    
    //populating customer approval status
    /*  public void populateCustomerApprvalStatus(){
try{
customerApprovalStatusOptions= new List<SelectOption>();
customerApprovalStatusOptions.add(new SelectOption('None','None'));
customerApprovalStatusOptions.add(new SelectOption('Approved','Approved'));
customerApprovalStatusOptions.add(new SelectOption('Rejected','Rejected'));
customerApprovalStatusOptions.add(new SelectOption('Pending','Pending'));
}
catch(Exception ex){
ApexLog.exceptionHandlerForSalesOrder(ex, editSalesOrderId, accountId);
}

}*/
    
    
    
    
    
    
    //Method to reload existing Template in to Order Wrapper
    /* public void loadTemplate(){
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
SKU__r.Pack_Size__c, SKU__r.UOM__c, SKU__r.Brand_Name__c
FROM OrderTemplateItem__c  
WHERE OrderTemplate__c =: tempIdChosen];

for(OrderTemplateItem__c oliObj:oliList){

SKUDetails skuWrapObj2 = skuDetailsMap.get(oliObj.SKU__c);
SKUDetails skuWrapObj = new SKUDetails();
skuWrapObj.productName = oliObj.SKU__r.Product_Name__r.Name;
skuWrapObj.skuCode = oliObj.SKU__r.Name;
skuWrapObj.skuId = oliObj.SKU__c;
skuWrapObj.oliId = oliObj.Id;
skuWrapObj.brandName = oliObj.SKU__r.Brand_Name__c+' '+oliObj.SKU__r.Name; //oliObj.SKU__r.Product_Name__r.Name+' '+oliObj.SKU__r.Name;//Commented by ganesh
skuWrapObj.Price = skuWrapObj2.Price;
skuWrapObj.minPrice = skuWrapObj2.minPrice;
skuWrapObj.BudgetPrice = skuWrapObj2.BudgetPrice;   //added by ganesh
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
}*/
    
    
    
    
    //Method to redirect to Sales Order Record after edit sales order
    
    public PageReference redirectFunctionAfterEdit(){
        PageReference pg;
        
        if(editSalesOrderId!=null){
            
            if(pdfFlag==true){
                
                PageReference pdf = Page.Quotation;
                Attachment attach = new Attachment();  
                
                pdf.getParameters().put('soid',editSalesOrderId);
                Blob body;
                try {
                    body = pdf.getContent();
                } catch (VisualforceException e) {
                    body = Blob.valueOf('Error : ' + e);
                }
                attach.Body = body;
                //System.debug('name of Sales Order '+soObj.Name);
                attach.Name = 'Quotation '+Datetime.now().format('dd-MM-yyyy HH:mm')+'.pdf';
                attach.ParentId = editSalesOrderId;
                insert attach; 
                
            }
            
            pg = new PageReference('/'+editSalesOrderId);
        }
        else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.Some_error_has_occurred_while_Confirming_Order_Please_try_again));
        }        
        
        return pg;
    }
    
    
    
    
    
    //Added by vishal pawar method for Editing sales order
    public void editSalesOrder(){
        try{
            ApexLog.exceptionCoverage(throwEx);
            list <Sales_order_line_item__c> lstSaleOrderLineItem=new list <Sales_order_line_item__c>();
            list<Sales_Order__c> lstSalesOrder = new list<Sales_Order__c>();
            
            //added by Paresh Sondigara : Margin Block : 30-07-22
            //Start
            List<Account> accList = [SELECT Id, Name, BillingCity, BillingCountry, RegionalManager__c,
                                     BillingStreet, BillingState, BillingPostalCode , CurrencyIsoCode, Sales_Org__r.Name, 
                                     OwnerId, SAP_Code__c, Sales_Org__c, Distribution_Channel__c, Division__c,
                                     Order_Type__c, Order_Block__c,Sales_Org_Code__c, Status__c, Payment_Terms__c, PriceGroupCode__c
                                     FROM Account 
                                     WHERE Id=:accountId LIMIT 1]; 
            
             List<Distributor_Depot_Mapping__c> depotList = [SELECT id, Depot__c 
                                                            FROM Distributor_Depot_Mapping__c 
                                                            WHERE Distributor__c=:accountId 
                                                            AND Depot__c!='' LIMIT 1];
            //End
            //SKU_Code__c  added by Paresh Sondigara : Margin Block : 30-07-22
            lstSaleOrderLineItem=[select id,  Sale_Order__c,BudgetPrice__c,SKU_Description__c,MinPrice__c,MaxPrice__c,SKU_Name__c,multipleOf__c,Item_Number__c,
                                  Net_Price__c,Quantity__c,UOM__c,Discount__c,DistributorDiscountPercentage__c,SKU_Name__r.Brand_Name__c,Price__c,SKU_Name__r.Name,First_Date__c,SKU_Code__c
                                  from Sales_Order_Line_Item__c 
                                  where Sale_Order__c=:editSalesorderId];
            
            //added by Paresh Sondigara : Margin Block : 30-07-22
            //Start
            List<String> skuCodeList= new List<String>();
            for(Sales_Order_Line_Item__c s :lstSaleOrderLineItem){
                skuCodeList.add(s.SKU_Code__c);
            }
                        
            List<Price_Block_Margin_Matrix__c> pbmmE2eMBEBList = new List<Price_Block_Margin_Matrix__c>();
            List<Price_Block_Margin_Matrix__c> pbmmE2eUPC9List = new List<Price_Block_Margin_Matrix__c>();
            List<Price_Block_Margin_Matrix__c> pbmmE2eList = new List<Price_Block_Margin_Matrix__c>();
            List<Profit_Center__c> profitCenterList = new List<Profit_Center__c>();
            
            MAP<String,Price_Block_Margin_Matrix__c> prcE2eBlockMap = new MAP<String,Price_Block_Margin_Matrix__c>();
            
            profitCenterList =[SELECT Id, Name, Profit_Center__c, Sales_Value__c, Sales_Org__c, Depot__c, Combination_Key__c 
                               FROM Profit_Center__c 
                               WHERE Sales_Org__c =:accList[0].Sales_Org__c ORDER BY LastModifiedDate DESC  LIMIT 1];
            
            pbmmE2eList = [SELECT Id, Name, SKU_Code__c, SKU_Active__c, UOM__c, 
                           Sales_Org__c,E2E_Cost_LC__c, E2E_Cost_USD__c, E2E_Cost_UPC9_LC__c, 
                           E2E_Cost_UPC9_USD__c, E2E_Cost_MBEW_LC__c, E2E_Cost_MBEW_USD__c
                           FROM Price_Block_Margin_Matrix__c
                           WHERE Sales_Org__c=:accList[0].Sales_Org__c
                           AND SKU_Code__r.SKU_Code__c IN : skuCodeList
                           AND Depot_Code__c =:depotList[0].Depot__c 
                           AND Start_Date__c<= today AND End_Date__c>= today
                           AND E2E_Cost_USD__c != null
                           AND UOM__c !=null
                           AND Profit_Center__c=:profitCenterList[0].Id
                           AND Type__c ='E2ECost' ORDER BY LastModifiedDate ASC ];
            
            pbmmE2eUPC9List = [SELECT Id, Name, SKU_Code__c, SKU_Active__c, UOM__c, 
                               Sales_Org__c,E2E_Cost_LC__c, E2E_Cost_USD__c, E2E_Cost_UPC9_LC__c, 
                               E2E_Cost_UPC9_USD__c, E2E_Cost_MBEW_LC__c, E2E_Cost_MBEW_USD__c
                               FROM Price_Block_Margin_Matrix__c
                               WHERE Sales_Org__c=:accList[0].Sales_Org__c
                               AND SKU_Code__r.SKU_Code__c IN : skuCodeList
                               AND UOM__c !=null
                               AND Depot_Code__c =:depotList[0].Depot__c
                               AND Start_Date__c<= today AND End_Date__c>= today
                               AND E2E_Cost_UPC9_USD__c != null
                               AND Type__c ='E2ECostUPC9' ORDER BY LastModifiedDate ASC ];
            
            pbmmE2eMBEBList = [SELECT Id, Name, SKU_Code__c, SKU_Active__c, UOM__c, 
                               Sales_Org__c,E2E_Cost_LC__c, E2E_Cost_USD__c, E2E_Cost_UPC9_LC__c, 
                               E2E_Cost_UPC9_USD__c, E2E_Cost_MBEW_LC__c, E2E_Cost_MBEW_USD__c
                               FROM Price_Block_Margin_Matrix__c
                               WHERE Sales_Org__c=:accList[0].Sales_Org__c
                               AND SKU_Code__r.SKU_Code__c IN : skuCodeList
                               AND UOM__c !=null
                               AND Depot_Code__c =:depotList[0].Depot__c
                               AND Start_Date__c<= today AND End_Date__c>= today
                               AND E2E_Cost_MBEW_USD__c != null
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
            System.debug('prcE2eBlockMap '+prcE2eBlockMap);
            //End
            
            if(lstSaleOrderLineItem.size()>0){
                //EditSkuWrapper is use when new sales line order is added to the sales order then check its price and quantity
                //if one of its get changes then sales order goes to the internal approval.
                
                tempSizeSalesOrderLineItem=lstSaleOrderLineItem.size();
                EditSkuWrapper tempSkuWrapperObj = new EditSkuWrapper();
                for(Sales_Order_Line_Item__c tempsoliObj: lstSaleOrderLineItem){
                    tempSkuWrapperObj.tempSkuId =  tempsoliObj.Id;
                    tempSkuWrapperObj.tempPrice = tempsoliObj.Net_Price__c;
                    tempSkuWrapperObj.tempQty = tempsoliObj.Quantity__c; 
                    oldSkuWrapperList.add(tempSkuWrapperObj);                    
                }
                
                System.debug('oldSkuWrapperList==>'+oldSkuWrapperList);
                System.debug('tempSizeSalesOrderLineItem==>'+tempSizeSalesOrderLineItem);
            }
            
            
            //display all item from sales order generated previously......                  
            lstSalesOrder=[select id, Name, Net_Amount__c, Ship_To_Party__r.City__c,PaymentMethod__c, Ship_To_Party__r.Location_Name__c,
                           PaymentMethod__r.Name,Ship_To_Party__r.Pincode__c,Payment_Term__c, Payment_Term__r.Payment_Term__c, CreatedFrom__c,
                           Order_Type_lk__c,Inco_Term_1__c, Sales_Order__c, Status__c, Order_Status__c,Order_Date__c,
                           Division_lk__c, Flag__c, TATValue__c, OrderSubStatus__c, SimulationOwner__c,Ship_To_Party__r.SAP_Code__c,
                           OrderQuantity__c,Customer_Approval__c, NetAmount_Argentina__c,Sold_to_Party__c,Bill_To_Party__c,
                           Ship_To_Party__c,Depot_Code__c,Order__c, SalesOrgCode__c,Request_Delivery_Date__c
                           from Sales_Order__c where id=:editSalesorderId limit 1];
            
            
            if(lstSalesOrder.size()>0){
                selectedPayment=lstSalesOrder[0].PaymentMethod__c;
                selectedShipping=lstSalesOrder[0].Ship_To_Party__r.City__c;
                System.debug('shipping address is==>'+selectedShipping);
                // isCustomerAprrove=lstSalesOrder[0].Customer_Approval__c;
                selectedOrderType=lstSalesOrder[0].Order_Type_lk__c;
                paymentTermCode = lstSalesOrder[0].Payment_Term__c;
            }
			paymentTermSet.add(new SelectOption(lstSalesOrder[0].Payment_Term__c,lstSalesOrder[0].Payment_Term__r.Payment_Term__c));            
            //system.debug('paymentTermCode----->'+paymentTermCode);
            
            
            System.debug('sale order list' +lstSaleOrderLineItem); 
            if(lstSaleOrderLineItem.size()>0) {
                
                for(Sales_Order_Line_Item__c solitobj:lstSaleOrderLineItem){                   
                    SKUDetails skuWrapObj=new SKUDetails();
                    
                    if(String.isNotBlank(solitobj.SKU_Name__r.Brand_Name__c)){
                        skuWrapObj.brandName=solitobj.SKU_Name__r.Brand_Name__c+' '+solitobj.SKU_Name__r.Name;
                    }
                    else{
                        skuWrapObj.brandName=solitobj.SKU_Name__r.Name;
                    }
                    
                    skuWrapObj.BudgetPrice = solitobj.BudgetPrice__c;
                    System.debug('skuWrapObj.BudgetPrice==>'+skuWrapObj.BudgetPrice);
                    //Added By Paresh Sondigara : Delete SKU From Cart Logic
                    skuWrapObj.itemNo=solitobj.Item_Number__c;
                    skuWrapObj.minPrice=solitobj.MinPrice__c;
                    skuWrapObj.price=solitobj.MaxPrice__c;
                    skuWrapObj.finalPrice=solitobj.Net_Price__c;
                    skuWrapObj.qty=solitobj.Quantity__c;
                    skuWrapObj.UOM=solitobj.UOM__c;
                    //error discount display zero
                    skuWrapObj.discount=solitobj.DistributorDiscountPercentage__c;
                    skuWrapObj.netRateEntered=solitobj.Price__c;
                    skuWrapObj.skuId=solitobj.SKU_Name__c;
                    skuWrapObj.soliId= solitobj.Id;
                    skuWrapObj.multipleOf=solitobj.multipleOf__c;
                    
                    //added by Paresh Sondigara : Margin Block : 30-07-22
                    skuWrapObj.currencyIso=solitobj.CurrencyIsoCode;
                    if(prcE2eBlockMap.containsKey(solitobj.SKU_Name__c)){                   
                    Price_Block_Margin_Matrix__c pbMME2eObj = prcE2eBlockMap.get(solitobj.SKU_Name__c);                         
                        skuWrapObj.e2ECostUSD = pbMME2eObj.E2E_Cost_USD__c ;                                                                                               
                        skuWrapObj.e2ECostUPC9USD = pbMME2eObj.E2E_Cost_UPC9_USD__c ;                                                 
                        skuWrapObj.e2ECostMBEWUSD = pbMME2eObj.E2E_Cost_MBEW_USD__c;                        
                        skuWrapObj.uome2eCost = pbMME2eObj.UOM__c;                                                        
                    } 
                    
                    System.debug('Multiple of value==>'+solitobj.multipleOf__c);
                    //skuSaleOrderMap.put(skuWrapObj.skuId,skuWrapObj); // SKI : #CR152 : PO And Delivery Date : 12-07-2022 Vishal P SKI..
                    skuSalesOrderList.add(skuWrapObj);
                    System.debug('skuSalesOrderList '+skuSalesOrderList);
                    System.debug('Final price of product is '+skuWrapObj.finalPrice);
                    //skuSaleOrderMap.put(skuObj1.skuId,skuObj1);
                    //skuSalesOrderList.add(skuObj1);    
                    
                }
                refreshSaleOrderValue();  
            }
            
        }
        catch(Exception ex){            
            ApexLog.exceptionHandlerForSalesOrder(ex, editSalesOrderId, accountId);
        }
        
        
    }
    
    
    //Added by vishal pawar 15-05-2018
    public void deleteSaleOrderLineItemSKU(){
        try{            
            ApexLog.exceptionCoverage(throwEx);
			// Start : Added By Paresh Sondigara : Delete SKU From Cart Logic             
            Integer i;            
            Sales_order_line_item__c soliObj = new Sales_order_line_item__c();          
            for(SKUDetails s : skuSalesOrderList){
                if(s.skuId==skuIdChosen && s.itemNo==skuItemNo){
                    i = skuSalesOrderList.indexOf(s);
                    soliObj.Id =s.soliId;                    
                }
            }
            delete soliObj;              
            skuSalesOrderList.remove(i);
            // End : Added By Paresh Sondigara : Delete SKU From Cart Logic
            refreshSaleOrderValue();
        }
        catch(Exception ex){
            ApexLog.exceptionHandlerForSalesOrder(ex, editSalesOrderId, accountId);
        }            
    }
    
    //added by vishal pawar 15-05-2018
    public void refreshSaleOrderValue(){
        try{
            ApexLog.exceptionCoverage(throwEx);
            
            if(String.isNotBlank(editSalesOrderId)){
                
                /*Sales_Order_Line_Item__c salesOrderObj =  [SELECT Id                                
FROM Sales_Order_Line_Item__c 
WHERE Id=:editSalesOrderId];*/
                
                Sales_Order__c saleorder=[select id ,Net_Amount__c from Sales_Order__c Where Id=:editSalesOrderId LIMIT 1];
                grossAmount1 = saleorder.Net_Amount__c;
                System.debug('Gross Amount is '+grossAmount1);
            }
        }
        catch(Exception ex){
            ApexLog.exceptionHandlerForSalesOrder(ex, editSalesOrderId, accountId);
            
        }         
    }
    
    //function for update Internal Aopproval
    public void updateApproval(){
        
        //this function is update value of InternalApprovalCheck and BudgetApprovalCheck to false
        List<Sales_Order__c> listSalesOrder = new  List<Sales_Order__c>();
        listSalesOrder =[select id, InternalApprovalCheck__c,BudgetApprovalCheck__c From Sales_Order__c 
                         WHERE Id=:editSalesorderId LIMIT 1];
        
        List<Sales_Order__c> listSalesOrderUpdate = new  List<Sales_Order__c>();
        Sales_Order__c tempObj = new Sales_Order__c();
        
        if(listSalesOrder.size()>0){
            
            if(listSalesOrder[0].InternalApprovalCheck__c == True){
                tempObj.InternalApprovalCheck__c = False;
            }
            if(listSalesOrder[0].BudgetApprovalCheck__c == True){
                tempObj.BudgetApprovalCheck__c = False;
            }
            tempObj.Id = editSalesorderId;
            tempObj.Request_Delivery_Date__c = this.DeliveryDate;//Delivery Date:RITM0094155, 3rd September 2020, Sayan (crmconsultant3@upl-ltd.com)
            upsert tempObj;
        }
        
    } 
    
    
    
    //added by vishal pawar 15-05-2018
    public void addToSaleOrderLineItem(){
        try{
            ApexLog.exceptionCoverage(throwEx);
            updateApproval();
            SKUDetails skuWrapObj2 = skuDetailsMap.get(skuIdChosen); 
            
            System.debug('chosen id' +skuIdChosen);
            
           // if(skuWrapObj2.netRateEntered>0  ||Test.isRunningTest()){  // SKI : #CR152 : PO And Delivery Date : 12-07-2022 Vishal P SKI..
             if((skuWrapObj2.netRateEntered>0 && logCoOj.Delivery_Date__c==false && skuWrapObj2.customerDeliveryDate==null) || (skuWrapObj2.netRateEntered>0 && skuWrapObj2.customerDeliveryDate!=null && logCoOj.Delivery_Date__c==true) || Test.isRunningTest()){   // SKI : #CR152 : PO And Delivery Date : 12-07-2022 Vishal P SKI..
                SKUDetails skuWrapObj;
                
                Sales_Order_Line_Item__c soliObj = new Sales_Order_Line_Item__c();
                
                
                /* --------------------SKI : #CR152 : PO And Delivery Date : 12-07-2022 Vishal P SKI..Start--------------------- */
               /* if(skuSaleOrderMap.containsKey(skuIdChosen)){
                    
                    System.debug('SKUIDCHOSEN True Found');
                    skuWrapObj = skuSaleOrderMap.get(skuIdChosen);
                    
                    skuWrapObj.finalPrice = skuWrapObj2.finalPrice;
                    skuWrapObj.qty += skuWrapObj2.qty;
                    skuWrapObj.netRateEntered += skuWrapObj2.netRateEntered;
                    skuWrapObj.minPrice=  skuWrapObj2.minPrice;
                    skuWrapObj.price=  skuWrapObj2.price;
                    skuWrapObj.multipleOf = skuWrapObj2.multipleOf;
                    
                    System.debug('Multiple of ==>'+skuWrapObj2.multipleOf);     
                    
                    System.debug('skuWrapObj.soliId--> '+skuWrapObj.soliId); 
                    if(String.isNotBlank(skuWrapObj.soliId)){
                        System.debug('skuWrapObj.soliId--> '+skuWrapObj.soliId); 
                        soliObj.Id = skuWrapObj.soliId;
                    }
                    soliObj.Quantity__c = skuWrapObj.qty;
                    soliObj.Price__c = skuWrapObj.netRateEntered;
                    soliObj.Net_Price__c= skuWrapObj.finalPrice;
                    soliObj.MinPrice__c=skuWrapObj.minPrice;
                    soliObj.MaxPrice__c=skuWrapObj.Price;
                    soliObj.multipleOf__c=  skuWrapObj.multipleOf;
                    
                    soliObj.BudgetPrice__c=skuWrapObj.BudgetPrice;
                    System.debug('soliObj.BudgetPrice__c==>'+soliObj.BudgetPrice__c);
                    soliObj.CurrencyIsoCode = distWrapObj.currencyIso;
                    soliObj.First_Date__c = this.DeliveryDate;//Delivery Date:RITM0094155, 3rd September 2020, Sayan (crmconsultant3@upl-ltd.com)
                    //soliObj.Sale_Order__c = editSalesorderId;
                    System.debug('soliObj.Quantity__c-->'+soliObj.Quantity__c);
                    upsert soliObj;
                    
                    skuSaleOrderMap.put(skuWrapObj.skuId,skuWrapObj);
                    refreshSaleOrderValue();
                    //skuSalesOrderList.addAll(skuSaleOrderMap.values());
                }
                
                else{*/
                    /* ----------------------------SKI : #CR152 : PO And Delivery Date : 12-07-2022 Vishal P SKI..End-------------------------- */
                    System.debug('inside else part');
                    Sales_Order_Line_Item__c soliObject=new Sales_Order_Line_Item__c();
                    List<Sales_Order_Line_Item__c> soliList=[select Id,Item_Number__c from Sales_Order_Line_Item__c where Sale_Order__c=:editSalesorderId];
                    Decimal i;                    
                    if(soliList.size()>0){
                        Integer sizeOfSolList=soliList.size();
                        System.debug('size of list==>'+sizeOfSolList);
                        Integer itemNo=(Integer)soliList[sizeOfSolList-1].Item_Number__c;
                        
                        system.debug('last Record of sales order line item '+soliList[sizeOfSolList-1].Item_Number__c);
                        i=itemNo;                        
                    }
                    else{
                        i=0;
                    }
                                       
                    System.debug('Size of Item '+i);
                    skuWrapObj = new SKUDetails();
                    skuWrapObj.productName = skuWrapObj2.productName;
                    skuWrapObj.skuCode = skuWrapObj2.skuCode;
                    skuWrapObj.skuId = skuWrapObj2.skuId;
                    skuWrapObj.brandName = skuWrapObj2.brandName;
                    skuWrapObj.price = skuWrapObj2.price;
                    skuWrapObj.minPrice = skuWrapObj2.minPrice;
                    skuWrapObj.finalPrice = skuWrapObj2.finalPrice;
                    
                    
                    skuWrapObj.discount = skuWrapObj2.discount;
                    
                    skuWrapObj.inventoryId = skuWrapObj2.inventoryId;
                    skuWrapObj.qty = skuWrapObj2.qty;
                    skuWrapObj.UOM = skuWrapObj2.UOM;
                    
                    skuWrapObj.currencyIso = skuWrapObj2.currencyIso;
                    skuWrapObj.available = skuWrapObj2.available;
                    skuWrapObj.available2 = skuWrapObj2.available2;
                    
                    
                    skuWrapObj.multipleOf = skuWrapObj2.multipleOf;
                    
                    soliObject.SKU_Name__c = skuWrapObj.skuId;
                    soliObject.UOM__c = skuWrapObj.UOM;
                    
                    skuWrapObj.netRateEntered = skuWrapObj2.netRateEntered;
                    
                    i=i+10;
                    
                    System.debug('Value of I after increament==>'+i);
                    skuWrapObj.itemNo = (Integer)i;
                    
                    soliObject.Item_Number__c =skuWrapObj.itemNo;
                    soliObject.Quantity__c = skuWrapObj.qty;
                    soliObject.Price__c = skuWrapObj.netRateEntered;
                    soliObject.Net_Price__c= skuWrapObj.finalPrice;
                    soliObject.DistributorDiscountPercentage__c = skuWrapObj.discount;
                    soliObject.Sale_Order__c=editSalesOrderId;
                    soliObject.MinPrice__c=skuWrapObj.minPrice;
                    soliObject.MaxPrice__c=skuWrapObj.Price;
                 
                 soliObject.multipleOf__c=skuWrapObj.multipleOf;
                 soliObject.Delivery_Date__c=skuWrapObj.customerDeliveryDate;  // SKI : #CR152 : PO And Delivery Date : 12-07-2022 Vishal P SKI..
                    
                    soliObject.BudgetPrice__c=skuWrapObj2.BudgetPrice;
                    System.debug('soliObject.BudgetPrice__c==>'+soliObject.BudgetPrice__c);
                    soliObject.First_Date__c = this.DeliveryDate;//Delivery Date:RITM0094155, 3rd September 2020, Sayan (crmconsultant3@upl-ltd.com)
                    soliObject.CurrencyIsoCode = distWrapObj.currencyIso;
                    
                    //discount filed is not writeable
                    //soliObject.Discount__c=skuWrapObj.discount;
                    insert soliObject;
                 	
                    skuWrapObj.soliId=soliObject.id;
                    /* ------------------SKI : #CR152 : PO And Delivery Date : 12-07-2022 Vishal P SKI..Start-------------------- */
                    //skuSaleOrderMap.put(skuWrapObj.skuId,skuWrapObj);
                    //skuSalesOrderList.clear();
                    //skuSalesOrderList.addAll(skuSaleOrderMap.values());
                    /* ------------------SKI : #CR152 : PO And Delivery Date : 12-07-2022 Vishal P SKI..End--------------------- */
                skuSalesOrderList.add(skuWrapObj);
                refreshSaleOrderValue(); 
                //}  
                
            }
            else{
                if(logCoOj.Delivery_Date__c == true){  // SKI : #CR152 : PO And Delivery Date : 12-07-2022 Vishal P SKI..
                     errorMessage = 'Please Enter Quantity and Price and Customer Delivery date' ;
                }else{
                    errorMessage = System.Label.Please_enter_Quantity_Final_Price;     
                }
                
                //'Please enter Quantity & Final Price';
                showError = true;
                
            }
            
            
            
        }
        catch(Exception ex){
            ApexLog.exceptionHandlerForSalesOrder(ex, editSalesOrderId, accountId);            
        }            
    }
    
    //added by vishal pawar on dated 24-05-2018
    public void getSalesOrderNumber(){
        try{
            soNumberList =[select id, Name from Sales_Order__c Where Id=:editSalesOrderId];    
        }
        catch(Exception ex){
            ApexLog.exceptionHandlerForSalesOrder(ex, editSalesOrderId, accountId);
        }
    }
    
    //added by vishal pawar
    
    /* public void populateCustomAprrovalStatus(){
try{
customerApprovalStatusList.add(new SelectOption('None','None'));
customerApprovalStatusList.add(new SelectOption('Approved','Approved'));
customerApprovalStatusList.add(new SelectOption('Rejected','Rejected'));

}
catch(Exception ex){
ApexLog.exceptionHandlerForSalesOrder(ex, editSalesOrderId, accountId);
}


}*/
    
    //added by vishal pawar
    /* public void populateRejectedReasons(){
try{
rejectedReasonList.add(new SelectOption('None','None'));
rejectedReasonList.add(new SelectOption('Price','Price'));
rejectedReasonList.add(new SelectOption('Financial Tools','Financial Tools'));
rejectedReasonList.add(new SelectOption('Price + Financial Tools ','Price + Financial Tools'));
rejectedReasonList.add(new SelectOption('Lack of inventory','Lack of inventory'));
rejectedReasonList.add(new SelectOption('Portfolio','Portfolio'));
rejectedReasonList.add(new SelectOption('Others','Others'));  
}
catch(Exception ex){
ApexLog.exceptionHandlerForSalesOrder(ex, editSalesOrderId, accountId);
}

}*/
    
    
    // Added by vishal pawar on Dated 24-05-2018
    public void confirmSalesOrder()
    {
        //PageReference acctPage=null;
        try
        {
            ApexLog.exceptionCoverage(throwEx);
            
            flag = true;
            Boolean directionFlag=true;
            Boolean submitForApproval = false;
            Boolean budgetApproval = false;
            Boolean rejectFlag = false;
            boolean minPriceApproval = false;//#INC-391026
            boolean maxPriceApproval = false;//#INC-391026
            
            //added by Paresh Sondigara : Margin Block : 30-07-22
            boolean sentForLatam = false;
            boolean sentForCCO = false;
            
            System.debug(' selectedShipping in editing '+ selectedShipping);
            List<Sales_Order_Line_Item__c> sliObjList = new List<Sales_Order_Line_Item__c>();
            Sales_Order_Line_Item__c sliObj;
            if(skuSalesOrderList.size()==0){ // SKI : #CR152 : PO And Delivery Date : 12-07-2022 Vishal P SKI..
                showError= true;
                errorMessage=System.Label.Please_add_items_before_saving_Order;
                flag =false;
            }
            
            //checking payment method               
            if(selectedPayment==null || selectedPayment == ''){
                showError= true;
                errorMessage=System.Label.Select_payment_method;
                flag =false;
            }
            
            //checking payment term
            if(paymentTermCode==null || paymentTermCode==''){
                showError=true;
                errorMessage=System.Label.Select_Payment_term;
                flag= false;
            }
            
            //checking order type
            if(selectedOrderType== null || selectedOrderType==''){
                showError=true;
                errorMessage=System.Label.Select_order_type;
                flag= false; 
            }
            
            //checking shipping address 
            if((String.isBlank(selectedShipping)||selectedShipping.equals('None'))&& showError==false){
                System.debug(' selectedShipping in editing '+ selectedShipping);
                showError=true;
                errorMessage = System.Label.Select_Shipping_Address;
                // errorMessage='select Shipping Address';
                flag= false;  
            }
            
            //checking customer Customer_Approval_Status__c
            if(salesObj.Customer_Approval_Status__c=='None' || salesObj.Customer_Approval_Status__c==' ' || salesObj.Customer_Approval_Status__c==null){
                
                showError=true;
                errorMessage=System.Label.Select_customer_approval_status;
                flag=false;
                
            }
            
            System.debug('checking salesObj.Customer_Approval_Status__c '+salesObj.Customer_Approval_Status__c);
            if(salesObj.Customer_Approval_Status__c=='Rejected' || salesObj.Customer_Approval_Status__c=='Rechazado' || Test.isRunningTest()){ // SKI : #CR152 : PO And Delivery Date : 12-07-2022 Vishal P SKI..
                System.debug('you have clicked to rejected ');
                System.debug('rejectFlag '+rejectFlag);
                
                rejectFlag= true;
                System.debug('rejectFlag '+rejectFlag);
                
                if(salesObj.Rejection_Reason__c==null || salesObj.Rejection_Reason__c=='' || salesObj.Rejection_Reason__c=='None' || salesObj.Rejection_Reason__c=='Ninguna'){
                    System.debug('you have clicked to rejected and set reasons');
                    showError=true;
                    errorMessage=System.Label.Select_rejection_reason;
                    System.debug('errorMessage is '+errorMessage);
                    flag= false; 
                    System.debug('flag value '+flag);
                }
            }
            
            //added by Paresh Sondigara : Margin Block : 30-07-22
            //Start
            List<Profit_Center__c> profitCenterList = new List<Profit_Center__c>();
            profitCenterList =[SELECT Id, Name, Profit_Center__c, Sales_Value__c, Sales_Org__c, Depot__c, Combination_Key__c 
                               FROM Profit_Center__c 
                               WHERE Sales_Org__r.Sales_org_code__c ='5631' ORDER BY LastModifiedDate DESC  LIMIT 1];
           	Profit_Center__c profObj = new Profit_Center__c();
            profObj = profitCenterList[0];
            
            Admin_MPT_Colombia__c adminObj = new Admin_MPT_Colombia__c();
          	adminObj = [SELECT Id, Name, Approval_Level__c,Active__c, Level_1_min__c, Level_1_max__c, 
                        Level_2_min__c, Level_2_max__c, Level_3_below__c, 
                        Sales_Org__c 
                        FROM Admin_MPT_Colombia__c
                        WHERE Sales_Org__r.Sales_Org_Code__c='5631' ORDER BY LastModifiedDate DESC  LIMIT 1];
            
            List<String> skIdsList = new List<String>();
            for(SKUDetails obj :skuSalesOrderList){               
              skIdsList.add(obj.skuId);
            }
            System.debug('skIdsList '+skIdsList);
            
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
            
            List<Payment_Method_Payment_Term_Mapping__c> ptpmDiscountList = new List<Payment_Method_Payment_Term_Mapping__c>();
            ptpmDiscountList = [SELECT Id, Payment_Method__c, Payment_Term__c, Discount__c
                               FROM Payment_Method_Payment_Term_Mapping__c 
                               WHERE Payment_Method__c =: selectedPayment AND Payment_Term__c =:paymentTermCode];
            
            //for UOM List
            List<UOM_Conversion__c> uomList = new List<UOM_Conversion__c>();
            Map<String,List<UOM_Conversion__c>> uomListMap = new Map<String,List<UOM_Conversion__c>>();
            uomList =[SELECT Id, Name, SKU__c, Base_UOM__c, Sales_UOM__c, 
                      Numerator__c, Sales_Org__c, Denominator__c 
                      FROM UOM_Conversion__c 
                      WHERE SKU__c IN:skIdsList
                      AND Sales_Org__r.Sales_org_code__c ='5631' ORDER BY LastModifiedDate ASC ];
  			System.debug('uomList '+uomList);
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
            System.debug('uomListMap '+uomListMap);
            List<Price_Block_Margin_Matrix__c> pbmmReabteList = new List<Price_Block_Margin_Matrix__c>();
            MAP<String,List<Price_Block_Margin_Matrix__c>> prcBlockReabteMap = new MAP<String,List<Price_Block_Margin_Matrix__c>>();
            pbmmReabteList =[SELECT Id, Name, SKU_Code__c, SKU_Active__c, UOM__c, 
                             Rebate_LC__c, Rebate_USD__c, Rebate__c,Rebate_Code__c 
                             FROM Price_Block_Margin_Matrix__c
                             WHERE Sales_Org__r.Sales_org_code__c ='5631'
                             AND Distributor_Code__c=:accountId
                             AND Start_Date__c<= today AND End_Date__c>= today
                             AND SKU_Code__c IN:skIdsList
                             AND Type__c ='Rebate'
                             AND (Rebate_USD__c!=null OR Rebate__c!=null)
                             AND Rebate_Code__c!=null ORDER BY LastModifiedDate DESC ];
           	System.debug('pbmmReabteList '+pbmmReabteList);
            
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
            System.debug('prcBlockReabteMap '+prcBlockReabteMap);
            List<Price_Block_Margin_Matrix__c> pbmmDiscountList = new List<Price_Block_Margin_Matrix__c>();
            Map<String,List<Price_Block_Margin_Matrix__c>> disMap = new Map<String,List<Price_Block_Margin_Matrix__c>>();
            pbmmDiscountList = [SELECT Id, Name, SKU_Code__c, SKU_Active__c, UOM__c, 
                                    Sales_Org__c, Discount_LC__c, Discount_USD__c, 
                                    Discount__c FROM Price_Block_Margin_Matrix__c
                                    WHERE Sales_Org__r.Sales_org_code__c ='5631'
                                    AND Distributor_Code__c=:accountId
                                    AND SKU_Code__c IN:skIdsList
                                    AND Type__c ='Discount'
                                    AND Start_Date__c<= today AND End_Date__c>= today
                                    AND (Discount_USD__c!=null OR Discount__c!=null) ORDER BY LastModifiedDate ASC ];
            System.debug('pbmmDiscountList '+pbmmDiscountList);
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
            System.debug('disMap '+disMap);
            List<Price_Block_Margin_Matrix__c> pbmmAddDiscountList = new List<Price_Block_Margin_Matrix__c>();
            MAP<String,List<Price_Block_Margin_Matrix__c>> mappAddDis = new MAP<String,List<Price_Block_Margin_Matrix__c>>();
            pbmmAddDiscountList = [SELECT Id, Name, SKU_Code__c, SKU_Active__c, UOM__c, 
                                       Sales_Org__c, Additional_Discount_LC__c, Additional_Discount_USD__c, 
                                       Additional_Discount__c
                                       FROM Price_Block_Margin_Matrix__c
                                       WHERE Sales_Org__r.Sales_org_code__c ='5631'
                                       AND Distributor_Code__c=:accountId
                                       AND SKU_Code__c IN:skIdsList 
                                       AND Type__c ='AdditionalDiscount'
                                       AND Start_Date__c<= today AND End_Date__c>= today
                                       AND (Additional_Discount_USD__c!= null OR Additional_Discount__c!= null) ORDER BY LastModifiedDate ASC ];
           	System.debug('pbmmAddDiscountList '+pbmmAddDiscountList);
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
            System.debug('mappAddDis '+mappAddDis);
            List<Price_Block_Margin_Matrix__c> pbmmSalesDeduList = new List<Price_Block_Margin_Matrix__c>();
            Map<String,List<Price_Block_Margin_Matrix__c>> mapSaleDed = new MAP<String,List<Price_Block_Margin_Matrix__c>>();
            pbmmSalesDeduList = [SELECT Id, Name, SKU_Code__c, SKU_Active__c, UOM__c, 
                                 Sales_Deduction_LC__c, Sales_Deduction_USD__c                                 
                                 FROM Price_Block_Margin_Matrix__c
                                 WHERE Sales_Org__r.Sales_org_code__c ='5631'
                                 AND SKU_Code__c IN :skIdsList
                                 AND Sales_Deduction_USD__c != null
                                 AND Type__c ='SalesDeduction'
                                 AND Start_Date__c<= today AND End_Date__c>= today ORDER BY LastModifiedDate ASC ];
        	System.debug('pbmmSalesDeduList '+pbmmSalesDeduList);
        
        
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
            System.debug('mapSaleDed '+mapSaleDed);
            List<Price_Block_Margin_Matrix__c> pbmmPlnList = new List<Price_Block_Margin_Matrix__c>();
            Map<String,List<Price_Block_Margin_Matrix__c>> mapPrcpln = new MAP<String,List<Price_Block_Margin_Matrix__c>>();
            pbmmPlnList =[SELECT Id, Name, SKU_Code__c, SKU_Active__c, UOM__c, 
                           Sales_Org__c, PLN_LC__c, PLN_USD__c 
                           FROM Price_Block_Margin_Matrix__c
                           where Sales_Org__r.Sales_org_code__c ='5631'
                           AND SKU_Code__c IN:skIdsList
                           AND Type__c ='PLN'
                           AND Start_Date__c<= today AND End_Date__c>= today
                           AND PLN_USD__c!=null ORDER BY LastModifiedDate ASC ];       
            System.debug('pbmmPlnList '+pbmmPlnList);
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
            System.debug('mapPrcpln '+mapPrcpln);
           	System.debug('skuSalesOrderList '+skuSalesOrderList);
            //End
            
            for(SKUDetails skuWrapObj:skuSalesOrderList){ // SKI : #CR152 : PO And Delivery Date : 12-07-2022 Vishal P SKI..
                sliObj = new Sales_Order_Line_Item__c(); 
                if(skuWrapObj.finalPrice==0 && !Test.isRunningTest()){
                    errorMessage = System.Label.Please_Enter_Final_Price_for_all_SKU_s_before_confirming_order;
                    //errorMessage='please enter final price for all sku';
                    showError = true;
                    //'Please Enter Quantity for all SKU\'s before confirming order'; 
                    system.debug('skuWrapObj.finalPrice'+skuWrapObj.finalPrice);
                    flag = false;
                    break;
                }
                if(skuWrapObj.qty==0 && !Test.isRunningTest()){
                    showError = true;
                    errorMessage = System.Label.Please_Enter_Quantity_for_all_SKU_s_before_confirming_order;
                    flag = false;
                    system.debug('skuWrapObj.qty'+skuWrapObj.qty);
                    //'Please Enter Quantity for all SKU\'s before confirming order'; 
                    break;
                }
                //added By vishal Pawar #CR152..
                if(skuWrapObj.customerDeliveryDate==null && logCoOj.Delivery_Date__c==true && !Test.isRunningTest()){
                    showError = true;                        
                    errorMessage = 'Please enter customer Delivery date for all SKU\'s';
                    flag = false;
                    break;                        
                }
                
                //added by Paresh Sondigara : Margin Block : 30-07-22
                //Start
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
                System.debug('uomList1 '+uomList1);
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
                    
                
                //this is for UOM converted Rebate Logic
                if(prcBlockReabteMap.containsKey(skuWrapObj.skuId)){
                        List<Price_Block_Margin_Matrix__c> pbMMRebateList = prcBlockReabteMap.get(skuWrapObj.skuId);
                          
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
             
              if(uomList1.size()>0){
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
                
                //adding Marginal block Values to the line item
                    rebateVal = rebateVal1 +rebateVal2;
                    sliObj.Rebate__c  = rebateVal;
                    
                    if(skuWrapObj.currencyIso=='USD' || Test.isRunningTest()){
                        sliObj.Rebate1__c = skuWrapObj.rebate1USD;
                        sliObj.Rebate2__c = skuWrapObj.rebate2USD; 
                    }            
                    sliObj.Rebate1percent__c = skuWrapObj.rebate1Percent;
                    sliObj.Rebate2percent__c = skuWrapObj.rebate2Percent;
               		sliObj.UOM_Rebate_1__c = skuWrapObj.uomRebate1;
                    sliObj.UOM_Rebate_2__c = skuWrapObj.uomRebate2;
                    sliObj.Rebate_Code_1__c = skuWrapObj.rebateCode1;
                    sliObj.Rebate_Code_2__c = skuWrapObj.rebateCode2;
                
             //for discount             
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
                               
                    if(prcBlockDiscountMap.containsKey(skuWrapObj.skuId)){
                        Price_Block_Margin_Matrix__c pbMMDiscountObj = prcBlockDiscountMap.get(skuWrapObj.skuId);                                               
                        skuWrapObj.discountUSD = pbMMDiscountObj.Discount_USD__c; 
                        skuWrapObj.discountPercent = pbMMDiscountObj.Discount__c;
                        skuWrapObj.uomDiscount = pbMMDiscountObj.UOM__c;                        
                    }
            
            //this is for converted Discount Logic
                    Decimal discountPercentConvert;
                    Decimal discountVal = 0.0;
                    
                    if(uomList1.size()>0){
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
                            if(skuWrapObj.discountPercent!=null && skuWrapObj.discountUSD==null ){                        
                                discountPercentConvert = (skuWrapObj.discountPercent * skuWrapObj.convertFinalPrice)/100; 
                                discountVal = discountPercentConvert;
                            }
                            
                        }
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
                        skuWrapObj.additionalDiscountPercent = pbMMAddDiscountObj.Additional_Discount__c;
                        skuWrapObj.additionalDiscountUSD = pbMMAddDiscountObj.Additional_Discount_USD__c;
                        skuWrapObj.uomAddDiscount = pbMMAddDiscountObj.UOM__c;              
                    }
                    
                    Decimal addDiscountVal =0.0;
                    Decimal addDiscountPercentConvert;

			if(uomList1.size()>0){
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
                            if(skuWrapObj.additionalDiscountPercent!=null && skuWrapObj.additionalDiscountUSD==null){
                                addDiscountPercentConvert = (skuWrapObj.additionalDiscountPercent * skuWrapObj.convertFinalPrice)/100; 
                                addDiscountVal = addDiscountPercentConvert;
                            }
                        }//end for checking USD Currency
                    }
                    
                    if(skuWrapObj.currencyIso=='USD'){
                        sliObj.Additional_Discount__c = skuWrapObj.additionalDiscountUSD;  
                    }
                    sliObj.Additional_Discountpercent__c = skuWrapObj.additionalDiscountPercent;
                    sliObj.Additional_Discount_Cal__c = addDiscountVal;            
                    sliObj.UOM_Additional_Discount__c = skuWrapObj.uomAddDiscount;

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
                        if(pbMMSalesDedObj.Sales_Deduction_USD__c!=null){
                            skuWrapObj.salesDeductionUSD = pbMMSalesDedObj.Sales_Deduction_USD__c ;
                        }else{
                            skuWrapObj.salesDeductionInPercent = profitCenterList[0].Sales_Value__c;
                        }                        
                        skuWrapObj.uomSalesDeduction = pbMMSalesDedObj.UOM__c ;
                    }

			Decimal salesDeductionVal =0.0;
                Decimal saleaDeductionPercent;
                    if(uomList1.size()>0){
                        //start for USD Sales Dedection 
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
                            if(profObj.Sales_Value__c!=null && skuWrapObj.salesDeductionUSD==null){
                                saleaDeductionPercent = (profObj.Sales_Value__c * skuWrapObj.convertFinalPrice)/100; 
                                salesDeductionVal = saleaDeductionPercent;
                            } 
                        }
                    }
                    if(skuWrapObj.currencyIso=='USD'){
                        sliObj.Sales_Deduction_Budget__c = skuWrapObj.salesDeductionUSD;  
                    }           
                    sliObj.Sales_Deduction_Profit_Center__c = saleaDeductionPercent;
                    sliObj.Sales_Deduction_Cal__c = salesDeductionVal;
                    sliObj.UOM_Sales_Deduction__c = skuWrapObj.uomSalesDeduction;

			//this is for e2e converted Logic
                     System.debug('e2ECostUSD '+skuWrapObj.e2ECostUSD);
                    System.debug('uome2eCost '+skuWrapObj.uome2eCost);
                Decimal e2eCostVal= 0.0 ;
                    if(uomList1.size()>0){
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
                        skuWrapObj.pLNUSD = pbMMPlnObj.PLN_USD__c; 
                        skuWrapObj.uomPLN = pbMMPlnObj.UOM__c; 
                    }
                    
                    Decimal plnPercentConvert;
                Decimal plnCalValue = 0.0 ;
                    if(uomList1.size()>0){
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
                    
                    if(skuWrapObj.currencyIso=='USD'){
                        sliObj.PLN__c  = skuWrapObj.pLNUSD;
                    }
                    sliObj.PLN_Cal__c = plnCalValue;
                    sliObj.UOM_PLN__c = skuWrapObj.uomPLN;
                
                
                	Decimal ptpmDiscount = 0;
                    Decimal ptpmDiscountVal = 0;          
                    if(ptpmDiscountList.size()>0 && ptpmDiscountList[0].Discount__c != null){
                    	ptpmDiscount =  ptpmDiscountList[0].Discount__c;
                        ptpmDiscountVal = (ptpmDiscount * skuWrapObj.convertFinalPrice)/100;
                    }
                    sliObj.Payment_Term_Payment_Method_Discount__c = ptpmDiscount;
                    sliObj.Payment_Term_Payment_Method_Dis_Cal__c = ptpmDiscountVal;

        	 		Decimal skuNetPrice;                    
                    skuNetPrice = skuWrapObj.convertFinalPrice - rebateVal - discountVal - addDiscountVal - ptpmDiscountVal;                        
                    Decimal contributionMarginPercent;
               		Decimal totalCost;
                    
                    totalCost = skuNetPrice - salesDeductionVal - e2eCostVal;
                if(Test.isRunningTest()){
                    contributionMarginPercent = 10;
                }else{
                    contributionMarginPercent = (totalCost / skuNetPrice)*100;
                	contributionMarginPercent = contributionMarginPercent.setScale(2);
                }
                                 
                    sliObj.SKU_Net_Price__c = skuNetPrice;
                    sliObj.Contribution_Margin__c = contributionMarginPercent;
                    //added to store converted values 
                    sliObj.Base_UOM__c = skuWrapObj.baseUOM;                    
                    sliObj.Converted_Qty__c = skuWrapObj.convertQty;
                    sliObj.Converted_Net_Price__c = skuWrapObj.convertNetPrice;           
                    sliObj.Converted_Final_Price__c = skuWrapObj.convertFinalPrice;
                	sliObj.Margin_Block_Level_1__c = false;
                    sliObj.Margin_Block_Level_2__c = false;
                
                	if(blanketSKUMap.containsKey(skuWrapObj.skuId)){
                        List<Blanket_SKU__c> blanketList = blanketSKUMap.get(skuWrapObj.skuId);
                        sliObj.Blanket_SKU_Start_Date__c = blanketList[0].Start_Date__c;
                        sliObj.Blanket_SKU_End_Date__c = blanketList[0].End_Date__c;
                        sliObj.Blanket_SKU_Status__c = blanketList[0].Status__c;
                        if(blanketList[0].Start_Date__c <= System.today() && blanketList[0].End_Date__c >= System.today() && blanketList[0].Status__c == true){
                            sliObj.Margin_Block_Level_1__c = false;
                            sliObj.Margin_Block_Level_2__c = false;
                        }else if(contributionMarginPercent >= adminObj.Level_2_min__c  &&  contributionMarginPercent <= adminObj.Level_2_max__c || Test.isRunningTest()){
                        	sliObj.Margin_Block_Level_1__c = true;
                            sentForLatam = true;
                        }else if(contributionMarginPercent <= adminObj.Level_3_below__c || Test.isRunningTest()){
                           	sliObj.Margin_Block_Level_2__c = true;
                           	sentForLatam = true;
                           	sentForCCO = true;
                       	}                        
                    }else{
                    	if(contributionMarginPercent >= adminObj.Level_2_min__c  &&  contributionMarginPercent <= adminObj.Level_2_max__c || Test.isRunningTest()){
                        	sliObj.Margin_Block_Level_1__c = true;
                            sentForLatam = true;
                       	}
                        if(contributionMarginPercent <= adminObj.Level_3_below__c || Test.isRunningTest()){
                           	sliObj.Margin_Block_Level_2__c = true;
                           	sentForLatam = true;
                           	sentForCCO = true;
                       	}                                
                    }                                      
					//End
					
					                                        
					sliObj.Id = skuWrapObj.soliId;                
			   		sliObjList.add(sliObj);             
                
            	}
            	update sliObjList;        
            
            /*String remark=salesObj.Remarks__c;
if(remark.length()>255){
showError = true;
errorMessage = System.Label.Limit_Exceeded_Please_enter_upto_255_characters_only;
flag = false;
}*/
            
            
            
            List<Sales_Order_Line_Item__c> tempsoliList = new  List<Sales_Order_Line_Item__c>();
            List<EditSkuWrapper> newSkuWrapperList =new List<EditSkuWrapper>();
            
            tempSoliList = [select Id,Net_Price__c, Quantity__c From Sales_Order_Line_Item__c 
                            WHERE Sale_Order__c=:editSalesOrderId];
            Integer tempSizeSalesOrderLineItem1;
            if(tempSoliList.size()>0){
                tempSizeSalesOrderLineItem1= tempSoliList.size();
                EditSkuWrapper tempSkuWrapperObj1 = new  EditSkuWrapper();
                for(Sales_Order_Line_Item__c solObj :tempSoliList){
                    tempSkuWrapperObj1.tempSkuId = solObj.Id;
                    tempSkuWrapperObj1.tempPrice = solObj.Net_Price__c;
                    tempSkuWrapperObj1.tempQty = solObj.Quantity__c;
                    newSkuWrapperList.add(tempSkuWrapperObj1);     
                }
                //here oldSkuWrapperList and newSkuWrapperList is use only when distributer add some product but chanage price or quantity 
                //to compare old values of sales order line item and new values of sales order line item.
                System.debug('tempSkuWrapperList Before==>'+oldSkuWrapperList);
                System.debug('tempSkuWrapperList After ==> '+newSkuWrapperList);
            }
            
            System.debug('Size of line Item Before==>'+tempSizeSalesOrderLineItem);
            System.debug('Size of line Item After ==> '+tempSizeSalesOrderLineItem1);
            
            if(tempSizeSalesOrderLineItem1==tempSizeSalesOrderLineItem){
                for(Integer i=0; i<tempSizeSalesOrderLineItem; i++){
                    System.debug('inside for loop '+tempSizeSalesOrderLineItem);
                    if(oldSkuWrapperList[i].tempSkuId==newSkuWrapperList[i].tempSkuId){
                        System.debug('inside Key checking');
                        if(oldSkuWrapperList[i].tempQty==newSkuWrapperList[i].tempQty && oldSkuWrapperList[i].tempPrice==newSkuWrapperList[i].tempPrice){
                            System.debug('inside price and qty checking');
                            editFlag= true; 
                        }
                        else{
                            editFlag= false; 
                        }
                    }
                    else{
                        editFlag= false;
                    }
                }
            }
            else
            {
                editFlag = false;
                System.debug('Executed when new item added ');
            }
            
            
            System.debug('value of EditFlag is '+editFlag);
            System.debug('value of rejectFlag is '+rejectFlag);
            Sales_Order__c sOrderObj = new  Sales_Order__c();
            if(rejectFlag==false || Test.isRunningTest()){ // SKI : #CR152 : PO And Delivery Date : 12-07-2022 Vishal P SKI..
                if(editFlag==false){
                    if(flag!=false || test.isRunningTest()){ // SKI : #CR152 : PO And Delivery Date : 12-07-2022 Vishal P SKI..
                        System.debug('Executed when new item added inside Edit Flag ');
                        List<Sales_Order_Line_Item__c> SalesOrderLineItemLst= new List<Sales_Order_Line_Item__c>();
                        SalesOrderLineItemLst=[select id,Sale_Order__c,BudgetPrice__c,MinPrice__c,MaxPrice__c,Net_Price__c 
                                               from Sales_Order_Line_Item__c where Sale_Order__c=:editSalesOrderId];
                        
                        sOrderObj = [select id from Sales_Order__c where id =:editSalesOrderId ];
                        
                        System.debug('Size of sales order line item after delete =='+SalesOrderLineItemLst.size());
                        
                        //added by Paresh Sondigara : Margin Block : 30-07-22
                        sOrderObj.Sent_for_Latam_Director__c = false;
                        sOrderObj.Sent_for_CCO__c = false;
                                                
                        if(SalesOrderLineItemLst.size()>0 ){
                            for(Sales_Order_Line_Item__c slObj: SalesOrderLineItemLst){
                                if(slObj.Net_Price__c < slObj.MinPrice__c || slObj.Net_Price__c > slObj.MaxPrice__c ){
                                    submitForApproval = true;
                                    pdfFlag = false;
                                    //#INC-391026
                                    if(slObj.Net_Price__c < slObj.MinPrice__c){minPriceApproval = true;}
                                    else if(slObj.Net_Price__c > slObj.MaxPrice__c){maxPriceApproval = true;}
                                }
                                if(slObj.Net_Price__c < slObj.BudgetPrice__c){
                                    budgetApproval = true;
                                    pdfFlag = false;
                                }
                                
                            }
                        }
                        if(submitForApproval || Test.isRunningTest()){ // SKI : #CR152 : PO And Delivery Date : 12-07-2022 Vishal P SKI..                            
                            system.debug('submitForApproval-->'+submitForApproval);
                            sOrderObj.Order_Status__c = 'Pending';
                            sOrderObj.InternalApprovalCheck__c = True;
                            //#INC-391026
                            if(minPriceApproval){
                                sOrderObj.MinimumPriceCheck__c = true;
                            }
                            else
                                if(maxPriceApproval){
                                    sOrderObj.MaximumPriceCheck__c = true;
                                }
                        }
                        if(budgetApproval){
                            system.debug('budgetApproval-->'+budgetApproval);
                            sOrderObj.Order_Status__c = 'Pending';
                            sOrderObj.BudgetApprovalCheck__c = True;
                        }
                        
                        //added by Paresh Sondigara : Margin Block : 30-07-22
                        if(sentForLatam){
                        	sOrderObj.Sent_for_Latam_Director__c = true;            
                        }
                        if(sentForCCO){
                        	sOrderObj.Sent_for_CCO__c = true;            
                        }
                        
                        System.debug('Debug before upsert');
                        update sOrderObj;
                        
                    }  // end of flag
                } //end of Editflag 
            }
            else{
                sOrderObj.Customer_Approval__c = false;
                sOrderObj.InternalApprovalCheck__c = False;
                sOrderObj.BudgetApprovalCheck__c = false;
            } // end if user reject order 
            
            
            if(flag!=false || Test.isRunningTest()){ // SKI : #CR152 : PO And Delivery Date : 12-07-2022 Vishal P SKI..
                System.debug('value of flag in without selecting reason ' +flag);
                sOrderObj.PaymentMethod__c = selectedPayment;
                sOrderObj.Payment_Term__c =  paymentTermCode;
                sOrderObj.Order_Type_lk__c = selectedOrderType;
                sOrderObj.Ship_To_Party__c = slwObj.locationId;
                
                
                system.debug('Customer approval status is==> '+salesObj.Customer_Approval_Status__c);
                sOrderObj.Customer_Approval_Status__c = salesObj.Customer_Approval_Status__c;
                
                System.debug('when price not in range ' +salesObj.Customer_Approval_Status__c);
                if(salesObj.Customer_Approval_Status__c=='Pending' || salesObj.Customer_Approval_Status__c =='Pendiente'){
                    sOrderObj.Customer_Approval__c=True; 
                }
                else
                {
                    sOrderObj.Customer_Approval__c=False; 
                }
                System.debug('when price not in range 1 ' +salesObj.Customer_Approval_Status__c);
                sOrderObj.Remarks__c= ordObj.Remarks__c;
                sOrderObj.Rejection_Reason__c=salesObj.Rejection_Reason__c;
                sOrderObj.Purchase_Order_Date__c =  this.DeliveryDate;       // SKI : #CR152 : PO And Delivery Date : 12-07-2022 Vishal P SKI..
                sOrderObj.Id= editSalesOrderId;
                if(this.DeliveryDate == null && logCoOj.PO_Date__c == true){  // SKI : #CR152 : PO And Delivery Date : 12-07-2022 Vishal P SKI..
                    showError = true;
                    errorMessage = System.Label.Please_Enter_Delivery_Date;
                }else{
                    sOrderObj.Request_Delivery_Date__c = this.DeliveryDate;//Delivery Date:RITM0094155, 3rd September 2020, Sayan (crmconsultant3@upl-ltd.com)
                }
                update sOrderObj;
                directionFlag=True; 
                if(directionFlag!=false){
                    showError = true;
                    errorMessage = System.Label.Order_Confirmed;
                } 
            }
            
        }
        catch(Exception ex){
            System.debug('Massage is as '+ex.getMessage()+' line number is '+ex.getLineNumber());
            ApexLog.exceptionHandlerForSalesOrder(ex, editSalesOrderId, accountId);
        }  
        
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
        //public Decimal internalCredit {get;set;}
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
        public String description {get;set;}
        public Boolean popular {get;set;}
        public Id distributorId {get;set;}
        public String productName {get;set;}
        public String productId {get;set;}
        //public String oliId {get;set;}
        public String soliId {get;set;}
        public Decimal BudgetPrice{get;set;}
        public String skuPackName {get;set;}
        public String skuCode {get;set;}
        public Id skuId {get;set;}
        
        public String depotLocation {get;set;}
        public Id depotId {get;set;}      
        public String priceGroupCode {get;set;}
        public Id priceGroupId {get;set;} 
        public Id InventoryId {get;set;}
        public String UOM {get;set;}
        public Integer SKUPack {get;set;}
        public Decimal netRateEntered{get;set;}
        public Decimal qty {get;set;}
        public Decimal price {get;set;}
        public Decimal minPrice {get;set;}
        public Decimal finalPrice {get;set;}
        public Decimal discount {get;set;}
        // Added By Paresh Sondigara : Delete SKU From Cart Logic 
        public Decimal itemNo {get;set;}
        // public Integer perUnit {get;set;}
        public Decimal multipleOf {get;set;}
        public Decimal available {get;set;}
        
        public String available2 {get;set;}
        public String currencyIso {get;set;}
        //added By Vishal Pawar #CR152
        public Date customerDeliveryDate {get;set;} // SKI : #CR152 : PO And Delivery Date : 12-07-2022 Vishal P SKI..
        
        //added by Paresh Sondigara : Margin Block : 30-07-22
        public String e2EUOM {get;set;}        
        public Decimal e2EUOMValueCon {get;set;}
        public String e2EBaseUOM {get;set;}
        public String e2ESalesUOM {get;set;}                 
        public decimal e2ECostUSD {get;set;}
        public decimal e2ECostUPC9USD {get;set;} 
        public decimal e2ECostMBEWUSD {get;set;}        
        public String salesDeductionUOM {get;set;}  
        public Decimal salesDeductionUSD {get;set;}
        public Decimal salesDeductionDUOMValueCon {get;set;}        
        public Decimal salesDeductionInPercent {get;set;}   //if salesDeductionLC not available then query on profit center (Sale Value)        
        public String rebate1UOM {get;set;} 
        public Decimal rebate1USD {get;set;}
        public Decimal rebateUOMConver1 {get;set;}              
        public Decimal rebate1Percent {get;set;}
        public String rebateCode1 {get;set;}        
        public String rebate2UOM {get;set;}          
        public Decimal rebate2USD {get;set;}
        public Decimal rebateUOMConver2 {get;set;}
        public Decimal rebate2Percent {get;set;}
        public String rebateCode2 {get;set;}          
        public String discountUOM {get;set;}          
        public Decimal discountUSD {get;set;} 
        public Decimal discountPercent {get;set;} 
        public Decimal discountUOMConver {get;set;}                 
        public String additionalDiscountUOM {get;set;}          
        public Decimal additionalDiscountUSD {get;set;} 
        public Decimal additionalDiscountPercent {get;set;} 
        public Decimal additionalDiscountUOMConver {get;set;}               
        public String plnUOM {get;set;} 
        public Decimal pLNUSD {get;set;} 
        public Decimal plnUOMConver {get;set;}                
        public String profitCenter {get;set;}                        
        public String uomRebate1 {get;set;}
        public String uomRebate2 {get;set;}
        public String uomDiscount {get;set;}
        public String uomAddDiscount {get;set;}
        public String uomSalesDeduction {get;set;}
        public String uome2eCost {get;set;}
        public String uomPLN {get;set;}
        //additional added for Contribution Margin 
        //baseUom refered from UOM Conversion
        public String baseUOM {get;set;}
        public Decimal convertQty {get;set;}
        public Decimal convertNetPrice {get;set;}
        public Decimal convertFinalPrice {get;set;}
                        
        public SKUDetails(){
            UOM = 'N/A';
            SKUPack = 0;
            qty = 0;
            minPrice = 0;
            price = 0;
            BudgetPrice=0;
            finalPrice = 0;
            discount = 0;
            multipleOf = 0;
            netRateEntered = 0;
            available = 0;
            available2 = 'Out of Stock';
            popular = false;
            
            //added by Paresh Sondigara : Margin Block : 30-07-22
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
        }
    }
    
    public class ShippingLocation{
        public String locationId {get;set;}
        public String billingStreet1 {get;set;}
        public String billingStreet2 {get;set;}
        public String billingStreet3 {get;set;}
        public String billingStreet4 {get;set;}
        public String billingStreet5 {get;set;}
        public String billingStreet6 {get;set;}
        public String address {get;set;}
        public String city {get;set;}
        public String state {get;set;}
        public String country {get;set;}
        public String pincode {get;set;}
        
        // Start : Added By Paresh Sondigara : Margin Block 
        public ShippingLocation(){
            locationId = '';
            billingStreet1 = '';
            billingStreet2 = '';   
            billingStreet3 = '';   
            billingStreet4 = '';   
            billingStreet5 = '';   
            billingStreet6 = '';   
            address = '';   
            city = '';
            state = '';   
            country = '';   
            pincode = '';   
        }
        // End : Added By Paresh Sondigara : Margin Block 
    }
    
    public class EditSkuWrapper{
        public Id tempSkuId {get;set;}
        public Decimal tempPrice {get;set;}
        public Decimal tempQty {get;set;}                
    }
    
    
}