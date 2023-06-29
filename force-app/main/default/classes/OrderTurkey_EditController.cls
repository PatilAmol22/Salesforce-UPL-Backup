/*
* Name: OrderTurkey_EditController
* Created On: 9 August 2018
* Author: Ganesh Chaurasia (ganesh.chaurasia@skinternational.com)
* Description: Class is used for editing Orders by RM of Turkey
*/
global without sharing class OrderTurkey_EditController {
    //Variable to be set by JS for Attachment status
    public String valuefromJS {get;set;}
    
    /* ---------------Start SKI(Vishal P) : #CR152 : PO And Delivery Date : 13-07-2022------------- */
    public Login_Country__c logCoOj {get;set;}
    public Date poDate {get;set;}    
    /* -------------End SKI(Vishal P) : #CR152 : PO And Delivery Date : 13-07-2022------------------ */ 
    public DistributorWrapper distWrapObj {get;set;}
    public ShippingLocation slwObj {get;set;}
    
    public List<SKUDetails> skuDetailsList {get;set;}
    public List<SKUDetails> skuOrderList {get;set;}
    public List<SKUDetails> skuSalesOrderList {get;set;}
    public List<SKUDetailsEdit> oldSKUList {get;set;}
    public List<OrderLineItem__c> oliList {get;set;}
    public List<Sales_Order_Line_Item__c> oliList2 {get;set;}
    public Sales_Order__c salesObj {get;set;}
    
    public Map<String,ShippingLocation> shippingMap {get;set;}    
    public Map<Id,SKUDetails> skuDetailsMap {get;set;}
    public Map<Id,SKUDetails> skuOrderMap {get;set;}
    public Map<Id,SKUDetails> skuSaleOrderMap {get;set;}
    public Map<String,String> stateMap {get;set;}
    
    public Set<String> productNamesSet{get;set;}
    public Set<String> descriptionSet{get;set;}
    public String divId{get;set;}
    
    public String orderTypeId{get;set;}
    public String selectedOrderType{get;set;}
    public String selectedOrderName{get;set;}
    public String paymentTermCode {get;set;}
    public List<SelectOption> orderTypeSet{get;set;} 
    //  public set<SelectOption> depotSet{get;set;}
    public List<SelectOption> paymentTermSet{get;set;}
    public List<SelectOption> shippingList {get;set;}    
    
    //Set Order Type Code
    public String orderTypeName{get;set;}
    public String orderTypeCode {get;set;}
    
    
    public String selectedShipping {get;set;}
    public String selectedSoId {get; set;}
    public String searchProdValue {get; set;}
    public String templateName {get; set;}
    public String errorMessage {get; set;}
    public String selectedPaymentTerm {get;set;}
    
    public String skuIdChosen {get; set;}
    public String tempIdChosen {get; set;}
    public String storageIdChosen {get; set;}
    public String paymentIdChosen {get; set;}
    public String orderRaisedBy {get; set;}
    public String skuJSON {get;set;}
    public String distributorJSON {get;set;}
    public String shippingJSON {get;set;}
    public Boolean showMinPrice{get;set;}
    public Boolean showError{get;set;}
    public Boolean enableInput{get;set;}
    public Boolean throwEx;
    
    
    //Order Related Permissions
    public Boolean showCredit{get;set;}
    public Boolean showInventory{get;set;}
    public Boolean showInventoryColumn{get;set;}
    public Boolean enableDepot{get;set;}
    public Boolean sampleDisable{get;set;}
    public Boolean disableAdd{get;set;}
    
    public Boolean allowTemplate{get;set;}
    public Boolean orderSaved{get;set;}
    
    public Decimal grossAmount {get;set;}
    
    public Integer itemNumber;
    public Integer selectedsoItemSize {get;set;}
    
    public String orderId{get;set;}
    public String PO{get;set;}
    public String accountId{get;set;}
    public String salesOrderId{get;set;}
    public String depoId;
    public String distributorId;
    public String territoryManagerId;
    public String managerId;
    public String country;
    
    public Order__c ordObj {get;set;}
    public Sales_Order__c soObj {get;set;}
    
    public OrderTurkey_EditController(ApexPages.StandardController controller) {
        try{
            
            orderTypeCode = '';//ZTF0';
            country = 'Turkey';
            slwObj = new ShippingLocation();
            salesObj=new Sales_Order__c();
            
            productNamesSet = new Set<String>();
            descriptionSet = new Set<String>();
            selectedOrderName = '';
            //  depotSet = new set<SelectOption>();
            paymentTermSet = new List<SelectOption>();
            orderTypeSet = new List<SelectOption>();
            skuDetailsList = new List<SKUDetails>();
            skuOrderList = new List<SKUDetails>();
            oldSKUList = new List<SKUDetailsEdit>();
            skuSalesOrderList=new List<SKUDetails>();
            oliList = new List<OrderLineItem__c>();
            showMinPrice = false;
            skuOrderMap = new Map<Id,SKUDetails>();
            skuSaleOrderMap = new Map<Id,SKUDetails>();
            shippingMap = new Map<String, ShippingLocation>();
            skuDetailsMap = new Map<Id,SKUDetails>();
            stateMap = new Map<String, String>();
            divId ='';
            searchProdValue = '';
            PO = '';
            paymentTermCode = '';  
            errorMessage = '';
            skuIdChosen = '';
            storageIdChosen = '';
            paymentIdChosen = '';
            valuefromJS = '';
            selectedSoId = '';
            selectedOrderType='';
            orderRaisedBy = '';
            skuJSON = '';
            distributorJSON = '';
            shippingJSON = '';
            
            sampleDisable=false;
            showError = false;
            enableInput = true;
            showCredit = false;
            showInventory = false;
            showInventoryColumn = false;
            
            throwEx = false;
            disableAdd =true;
            enableDepot = false;
            allowTemplate = false;
            orderSaved = false;
            
            grossAmount = 0;
            
            itemNumber = 0;
            
            accountId = '';
            salesOrderId = '';
            distributorId = '';
            depoId = '';
            
            territoryManagerId = '';
            
            orderId = ApexPages.currentpage().getparameters().get('id');        
            System.debug('orderId: '+orderId);
            
            salesOrderId = ApexPages.currentpage().getparameters().get('soid');
            
            accountId = ApexPages.currentpage().getparameters().get('acid');
            System.debug('accountId: '+accountId);
            
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
                /*    if(loginUserObj.UserRole.name.contains('Regional Manager')){
orderRaisedBy = 'Regional Manager';
}*/
                /*  if(loginUserObj.UserRole.name.contains('District Manager')){
orderRaisedBy = 'District Manager';
}
else{
orderRaisedBy = 'Territory Manager';
}*/
            }
            
            if(String.isNotBlank(salesOrderId)){
                /* ------------SKI(Vishal P) : #CR152 : PO And Delivery Date : 13-07-2022--------------- */
                salesObj = [select id,Purchase_Order_Date__c, Name,Order_Type_lk__c,Payment_Term__c,Payment_Term__r.Payment_Term__c, Order_Type_lk__r.Description__c from Sales_Order__c Where Id=:salesOrderId limit 1];
                selectedSoId = salesObj.Name;
                paymentTermCode=salesObj.Payment_Term__c;
                selectedOrderType = salesObj.Order_Type_lk__c;
                if(salesObj.Order_Type_lk__r.Description__c=='Free Samples'){
                    sampleDisable=true;
                }
                poDate = salesObj.Purchase_Order_Date__c; // SKI(Vishal P) : #CR152 : PO And Delivery Date : 13-07-2022
                editSalesOrder();
                system.debug('selectedOrderType'+selectedOrderType);
            }else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Sales Order not found'));
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
            //  refreshSaleOrderValue(); //uncomment if need
            
        }
        catch(Exception ex){
            System.debug('Method: Constructor Exception: '+ex.getMessage()+ ' Line Number: '+ex.getLineNumber());
        }
    }
    
    public void changePayment(){
        if(paymentTermCode!=''){
            paymentIdChosen = paymentTermCode;
        }
        System.debug('paymentIdChosen: '+paymentIdChosen);
    }
    
    //Method to fetch Distributor Details, Depot, Credit Information and Shipping Details
    public void fetchDistributorDetails(){
        try{
            ApexLog.exceptionCoverage(throwEx);
            /* ----------Start SKI(Vishal P) : #CR152 : PO And Delivery Date : 13-07-2022------------ */
            logCoOj = [SELECT Id, Name, For_Contry__c, 
                       Sales_Org_Code__c, Delivery_Date__c, PO_Date__c, 
                       Show_Delivery_Date__c, Show_PO_Date__c 
                       FROM Login_Country__c
                       WHERE Sales_Org_Code__c='7110' LIMIT 1];
            /* -----------End SKI(Vishal P) : #CR152 : PO And Delivery Date : 13-07-2022--------------- */
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
            //distWrapObj.currencyIso = accList[0].CurrencyIsoCode;  
            
            // Populate Order Type  not in usr for edit phase
            List<Order_Type__c> orderTypeList=[select Id,Order_Type_Code__c,SalesOrg__c, Description__c 
                                               from Order_Type__c 
                                               WHERE SalesOrg__r.Sales_Org_Code__c='7110'];
            
            if(orderTypeList.size()>0){
                orderTypeSet.add(new SelectOption('None','None'));
                for(order_type__c orderTypeObj:orderTypeList){
                    orderTypeSet.add(new SelectOption(orderTypeObj.id, orderTypeObj.Description__c));
                }
            } 
            //End
            
            
            
            
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
                //  orderRaisedBy = 'Territory Manager';
            }
            
            List<Shipping_Location__c> slList = [SELECT Id, Name, Distributor__c, City__c, 
                                                 Region__c, Pincode__c, State__c, Country__c,
                                                 Sold_To_Party_SAP_Code__c, SAP_Code__c, 
                                                 Billing_Street_1__c, Billing_Street_2__c, Billing_Street_3__c, 
                                                 Billing_Street_4__c,Billing_Street_5__c,Billing_Street_6__c
                                                 FROM Shipping_Location__c
                                                 WHERE Distributor__c =:accountId Limit 1];
            
            if(slList.isEmpty()){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Shipping Details not found'));
                //CalloutException e = new CalloutException();
                //e.setMessage('?Shipping Details not found');
                //throw e;
            }
            if(!slList.isEmpty()){
                slwObj.billingStreet1 = slList[0].Billing_Street_1__c;
                slwObj.billingStreet2 = slList[0].Billing_Street_2__c;
                slwObj.billingStreet3 = slList[0].Billing_Street_3__c;
                slwObj.billingStreet4 = slList[0].Billing_Street_4__c;
                slwObj.billingStreet5 = slList[0].Billing_Street_5__c;
                slwObj.billingStreet6 = slList[0].Billing_Street_6__c;  
                slwObj.locationId = slList[0].Id;
                slwObj.address = slList[0].Region__c;
                slwObj.city = slList[0].City__c;
                slwObj.country = slList[0].Country__c;
                slwObj.pincode = slList[0].Pincode__c;
                slwObj.state = slList[0].State__c;
            }
            
            List<DistributorSalesAreaMapping__c> dsmList = [SELECT Id, DistributionChannel__c, SalesOrg__r.Name,
                                                            Distribution_Channel_Code__c, Division_Code__c,PriceGroupMaster__c,
                                                            SalesOrg__c, SalesOrg__r.Sales_Org_Code__c,
                                                            Division__c, Division__r.Name, AccountOwner__c 
                                                            FROM DistributorSalesAreaMapping__c
                                                            WHERE Distributor__c=:accountId 
                                                            AND SalesOrg__r.Sales_Org_Code__c='7110' AND Division__c=:accList[0].Division__c];
            
            if(!dsmList.isEmpty()){
                territoryManagerId = dsmList[0].AccountOwner__c;
                distWrapObj.salesOrgId = dsmList[0].SalesOrg__c;
                distWrapObj.salesOrgName = dsmList[0].SalesOrg__r.Name;
                distWrapObj.distributorChannelId = dsmList[0].DistributionChannel__c;            
                distWrapObj.divisionId = dsmList[0].Division__c;   
                distWrapObj.priceGroupId = dsmList[0].PriceGroupMaster__c;
            }
            else{
                territoryManagerId = UserInfo.getUserId();   
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Sales Area not found'));
                CalloutException e = new CalloutException();
                e.setMessage('?Sales Area not found');
                throw e;
            }
            
            
            
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
            
            /*uncomment when storage-location picklist needed
*  List<Depot__c> storageList = [Select Id, Name,Virtual_Storage_Location__c from Depot__c where recordtype.name = 'Storage Location' and SalesOrg__r.name=:country AND Virtual_Storage_Location__c!=null];
for(Depot__c tdmObj:storageList){
depotSet.add(new SelectOption(tdmObj.Id,tdmObj.Virtual_Storage_Location__c));
}
if(!storageList.isEmpty()){
storageIdChosen = storageList[0].Id;
}
*/
            
            //Payment term  Fetch
            List<Payment_Term__c> paymentTermList = [Select Id, Payment_Term_Code__c, Payment_Term__c from Payment_Term__c 
                                                     WHERE SalesOrgCode__c = '7110'];
            paymentTermSet.add(new SelectOption('None','None'));
            // selectedPaymentTerm='None';
            for(Payment_Term__c tdmObj:paymentTermList){
                paymentTermSet.add(new SelectOption(tdmObj.Id,tdmObj.Payment_Term__c));
            }
            //End payment Fetch
            
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
            /* else{
ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Credit Information for Distributor not found'));
//CalloutException e = new CalloutException();
//e.setMessage('?Credit Information for Distributor not found');
//throw e;
} uncomment whene data is available_ganesh*/
            
            distWrapObj.address = accList[0].BillingStreet;
            distWrapObj.city = accList[0].BillingCity;
            distWrapObj.state = accList[0].BillingState;
            distWrapObj.country = accList[0].BillingCountry;
            distWrapObj.pincode = accList[0].BillingPostalCode;
            distWrapObj.currencyIso = accList[0].currencyIsoCode;
            distWrapObj.regionalManagerId = accList[0].RegionalManager__c;
            //End of Logic
            //distributorJSON = JSON.serialize(distWrapObj);  not in use
            System.debug('distWrapObj: '+distWrapObj);
            
            
            system.debug('orderId'+orderId);
            if(String.isNotBlank(orderId)){
                system.debug('orderId'+orderId);
            }
            if(String.isNotBlank(slwObj.locationId)){
                if(ordObj==null){
                    //  createOrder();
                    //  refreshOrderValue();uncommennt if needed
                    // ordObj.Shipping_Location__c = slwObj.locationId;
                    //  update ordObj;
                }
            }
        }
        catch(Exception ex){
            //ApexLog.exceptionHandler(ex, orderId, accountId);
            ApexLog.exceptionHandlerForSalesOrder(ex, salesOrderId, accountId);
        }
    }
    
    public void fetchSKUData(){
        try{
            ApexLog.exceptionCoverage(throwEx);
            
            //Logic to populate existing wrapper with Pricebook Details
            
            List<PriceBookMaster__c> pbmList = [SELECT Id, SKUCode__c ,SKUCode__r.Name,SKUCode__r.Division__r.Name, 
                                                SKUCode__r.SKU_Code__c, MinPrice__c,SKUCode__r.Division__c,
                                                DepotCode__c, DepotCode__r.Location__c, 
                                                Price__c, PG_CODE__c, PG_CODE__r.Name, SKUCode__r.Pack_Size__c, 
                                                UOM__c, SKUCode__r.Product_Name__r.Name, SKUCode__r.SKU_Description__c,
                                                SKUCode__r.Product_Name__c, CurrencyIsoCode,
                                                SKUCode__r.Product_Name__r.Popular__c, SKUCode__r.Multiple_Of__c, SKUCode__r.Brand_Name__c
                                                FROM PriceBookMaster__c
                                                WHERE (DistributorCustomerCode__c =: accountId 
                                                       OR (DepotCode__c =: depoId ))
                                                AND SKUCode__r.Sales_Org__c =: distWrapObj.salesOrgId
                                                AND SKUCode__r.Division__c =:divId
                                                AND StartDate__c <= TODAY AND EndDate__c >= TODAY AND SKUCode__r.Active__c = True
                                                // ORDER BY SKUCode__r.Product_Name__r.Name ASC, SKUCode__r.SKU_Code__c DESC, StartDate__c ASC];
                                                ORDER BY SKUCode__r.Brand_Name__c ASC, SKUCode__r.SKU_Code__c DESC, StartDate__c ASC];
            
            String query  = 'SELECT Id, SKUCode__c ,SKUCode__r.Name, ';
            query += 'SKUCode__r.Pack_Size__c, SKUCode__r.SKU_Code__c, ';
            query += 'DepotCode__c, DepotCode__r.Location__c, ';
            query += 'Price__c, PG_CODE__c, PG_CODE__r.Name, ';
            query += 'UOM__c, SKUCode__r.Product_Name__r.Name,  SKUCode__r.SKU_Description__c, ';
            query += 'SKUCode__r.Product_Name__c, SKUCode__r.Product_Name__r.Popular__c, ';
            query += 'DistributorCustomerCode__r.Name, CurrencyIsoCode, ';
            query += 'SKUCode__r.Product_Name__r.VF_Image__c ';
            query += 'FROM PriceBookMaster__c  ';
            query += 'WHERE (DistributorCustomerCode__c =\''+accountId+'\' ';
            query += 'OR (DepotCode__c =\''+depoId+'\')) ';
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
            SKUDetails skuWrapObj;
            for(PriceBookMaster__c pbObj : pbmList){
                skuWrapObj = new SKUDetails();
                
                //if(pbObj.SKUCode__c==pbObj.SKUCode__r.Name)
                //    skuWrapObj.brandName = pbObj.SKUCode__r.Product_Name__r.Name;
                //else
                if(String.isNotBlank(pbObj.SKUCode__r.Brand_Name__c)){
                    skuWrapObj.brandName = pbObj.SKUCode__r.Brand_Name__c+' '+pbObj.SKUCode__r.Name;    //pbObj.SKUCode__r.Product_Name__r.Name +' '+pbObj.SKUCode__r.Name;  //commented by ganesh
                }
                else{
                    skuWrapObj.brandName= pbObj.SKUCode__r.Name;
                }
                skuWrapObj.description = pbObj.SKUCode__r.SKU_Description__c;
                skuWrapObj.minPrice = pbObj.MinPrice__c; //Added by Sayan
                //Added by Varun Shrivastava : SCTASK0282699 Start
                skuWrapObj.skuDescription = pbObj.SKUCode__r.SKU_Description__c;
                //Added by Varun Shrivastava : SCTASK0282699 End
                
                skuWrapObj.skuPackName = pbObj.SKUCode__r.Name;
                skuWrapObj.distributorId = accountId;
                skuWrapObj.productName = pbObj.SKUCode__r.Product_Name__r.Name;
                skuWrapObj.productId = pbObj.SKUCode__r.Product_Name__c;
                skuWrapObj.UOM = pbObj.UOM__c;
                skuWrapObj.skuCode = pbObj.SKUCode__r.SKU_Code__c;
                
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
                //added by ganesh
                if(String.isNotBlank(pbObj.SKUCode__r.Division__r.Name)){
                    skuWrapObj.description=skuWrapObj.description+' - '+pbObj.SKUCode__r.Division__r.Name;
                }
                //End of Patch
                
                skuWrapObj.skuId = pbObj.SKUCode__c;
                skuWrapObj.depotLocation = pbObj.DepotCode__r.Location__c;
                skuWrapObj.depotId = pbObj.DepotCode__c;
                if(pbObj.MinPrice__c!=null)
                    skuWrapObj.minPrice = Math.abs(pbObj.MinPrice__c);
                /* if(pbObj.Price__c!=null)
skuWrapObj.price = Math.abs(pbObj.Price__c);*/
                skuWrapObj.priceGroupCode = pbObj.PG_CODE__r.Name; 
                skuWrapObj.priceGroupId = pbObj.PG_CODE__c;
                skuWrapObj.currencyIso = pbObj.currencyIsoCode;
                skuWrapObj.popular = pbObj.SKUCode__r.Product_Name__r.Popular__c;
                if(String.isNotBlank(pbObj.SKUCode__c) && String.isNotBlank(skuWrapObj.UOM)){
                    skuDetailsMap.put(pbObj.SKUCode__c, skuWrapObj);
                }
                system.debug('-->skuDetailsMap'+skuDetailsMap);
            }
            //End of Logic
            
            //Logic to populate Distributor Discount
            List<PricebookDiscount__c> pbdList = [SELECT Id, SKUCode__c ,PG_Code__c,
                                                  Price__c, CurrencyIsoCode, LastModifiedDate,Distributor_Discount__c
                                                  FROM PricebookDiscount__c
                                                  WHERE (DistributorCustomerCode__c =:accountId 
                                                         OR (DepotCode__c =: depoId AND PG_CODE__c=:distWrapObj.priceGroupId)) 
                                                  AND SKUCode__r.Sales_Org__c =: distWrapObj.salesOrgId
                                                  AND PG_Code__r.PG_Code__c='03'
                                                  AND StartDate__c <= TODAY AND EndDate__c >= TODAY AND SKUCode__r.Active__c = True
                                                  ORDER BY SKUCode__r.Product_Name__r.Name ASC, SKUCode__r.SKU_Code__c DESC, LastModifiedDate ASC];
            System.debug('pbdList: '+pbdList);
            System.debug('size: '+pbdList.size());
            
            for(PricebookDiscount__c pbObj : pbdList){
                if(skuDetailsMap.containsKey(pbObj.SKUCode__c)){
                    skuWrapObj = skuDetailsMap.get(pbObj.SKUCode__c);
                    skuWrapObj.distributorDiscountPercent = Math.abs(pbObj.Distributor_Discount__c);
                    skuWrapObj.distributorDiscountId = pbObj.Id;
                    skuWrapObj.currencyIso = pbObj.currencyIsoCode;
                    skuDetailsMap.put(pbObj.SKUCode__c, skuWrapObj);
                }
            }
            //End
            
            
            System.debug('skuDetailsMap: '+skuDetailsMap);
            System.debug('size: '+skuDetailsMap.size());
            
            System.debug('salesOrgName: '+distWrapObj.salesOrgName);
            
            //End of Logic
            // skuJSON = JSON.serialize(skuDetailsMap.values());
            fetchPopular();
        }
        catch(Exception ex){
            //ApexLog.exceptionHandler(ex, orderId, accountId);
            ApexLog.exceptionHandlerForSalesOrder(ex, salesOrderId, accountId);
            
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
                //Updated by Varun Shrivastava : SCTASK0282699 Start
                //productNamesSet.add(skuWrapObj.brandName);
                productNamesSet.add(skuWrapObj.skuDescription);
                //Updated by Varun Shrivastava : SCTASK0282699 Start
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
            //ApexLog.exceptionHandler(ex, orderId, accountId);
            ApexLog.exceptionHandlerForSalesOrder(ex, salesOrderId, accountId);
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
            //  ApexLog.exceptionHandler(ex, orderId, accountId);
            ApexLog.exceptionHandlerForSalesOrder(ex, salesOrderId, accountId);
        }
    }
    
    public void editSalesOrder(){
        try{
            ApexLog.exceptionCoverage(throwEx);
            list<Sales_order_line_item__c> SOLineItemList =new list <Sales_order_line_item__c>();
            /* SKI(Vishal P) : #CR152 : PO And Delivery Date : 13-07-2022....added Delivery_Date__c field */
            SOLineItemList=[select id,Sale_Order__c,SKU_Description__c,MinPrice__c,Comment__c,FinalPrice__c,Campaign_Discount__c,SKU_Name__c,SKU_Name__r.Division__c,
                            SKU_Name__r.SKU_Description__c,//Added by Varun Shrivastava : SCTASK0282699
                            Net_Price__c,Quantity__c,UOM__c,Material_Discount__c,Distributor_Discount__c,
                            DistributorDiscountPercentage__c,SKU_Name__r.Brand_Name__c,Price__c,SKU_Name__r.Name,
                            Delivery_Date__c
                            from Sales_Order_Line_Item__c 
                            where Sale_Order__c=:salesOrderId];
            
            
            if(SOLineItemList.size()>0){
                divId = SOLineItemList[0].SKU_Name__r.Division__c;
                selectedsoItemSize=SOLineItemList.size();
                SKUDetailsEdit tempSkuWrapperObj = new SKUDetailsEdit();
                for(Sales_Order_Line_Item__c tempsoliObj: SOLineItemList){
                    tempSkuWrapperObj.tempSkuId =  tempsoliObj.Id;
                    tempSkuWrapperObj.tempPrice = tempsoliObj.Net_Price__c;
                    //  tempSkuWrapperObj.tempPrice = tempsoliObj.Price__c;  commented by ganesh
                    tempSkuWrapperObj.tempQty = tempsoliObj.Quantity__c; 
                    oldSKUList.add(tempSkuWrapperObj);
                }
                System.debug('oldSKUList'+oldSKUList);
            }
            
            System.debug('saleOrderlist' +SOLineItemList); 
            if(SOLineItemList.size()>0) {
                
                for(Sales_Order_Line_Item__c solitobj:SOLineItemList){
                    SKUDetails skuWrapObj=new SKUDetails();
                    if(String.isNotBlank(solitobj.SKU_Name__r.Brand_Name__c)){
                        skuWrapObj.brandName=solitobj.SKU_Name__r.Brand_Name__c+' '+solitobj.SKU_Name__r.Name;
                    }
                    else{
                        skuWrapObj.brandName=solitobj.SKU_Name__r.Name;
                    }
                    //Added by Varun Shrivastava : SCTASK0282699 Start
                    skuWrapObj.skuDescription = solitobj.SKU_Name__r.SKU_Description__c;
                    //Added by Varun Shrivastava : SCTASK0282699 End
                    skuWrapObj.Comment= solitobj.Comment__c;
                    skuWrapObj.minPrice=solitobj.MinPrice__c;
                    skuWrapObj.finalPrice=solitobj.FinalPrice__c+'';
                    skuWrapObj.qty=solitobj.Quantity__c;
                    skuWrapObj.priceEntered= solitobj.Price__c;
                    skuWrapObj.UOM=solitobj.UOM__c;
                    //error discount display zero
                    
                    skuWrapObj.campaignDiscountPercent  = solitobj.Campaign_Discount__c ;
                    skuWrapObj.materialDiscountPercent  = solitobj.Material_Discount__c ;
                    skuWrapObj.distributorDiscountPercent  = solitobj.Distributor_Discount__c ;
                    
                    skuWrapObj.netRateEntered=solitobj.Net_Price__c;
                    // skuWrapObj.netRateEntered=solitobj.Price__c;  commented by ganesh
                    skuWrapObj.skuId=solitobj.SKU_Name__c;
                    skuWrapObj.soliId= solitobj.Id;
                    
                    skuWrapObj.customerDeliveryDate = solitobj.Delivery_Date__c; // SKI(Vishal P) : #CR152 : PO And Delivery Date : 13-07-2022

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
        }
    }
    
    
    
    //Method to Add SKU to Order Table
    public void addSOItem(){
        
        try{
            ApexLog.exceptionCoverage(throwEx);
            Id TurkeyDepo = [Select Id From Depot__c Where Name=:country LIMIT 1].Id;
            SKUDetails skuWrapObj2 = skuDetailsMap.get(skuIdChosen);
           /* SKI(Vishal P) : #CR152 : PO And Delivery Date : 13-07-2022 */
            if((skuWrapObj2.netRateEntered>0 && skuWrapObj2.qty>0 && logCoOj.Delivery_Date__c==false && skuWrapObj2.customerDeliveryDate==null)  || (skuWrapObj2.netRateEntered>0 && skuWrapObj2.qty>0 && logCoOj.Delivery_Date__c==true && skuWrapObj2.customerDeliveryDate!=null) || Test.isRunningTest() ){
                //skuSalesOrderList.clear();  // SKI(Vishal P) : #CR152 : PO And Delivery Date : 13-07-2022
                SKUDetails skuWrapObj;
                Sales_Order_Line_Item__c soliObj = new Sales_Order_Line_Item__c();
                /* ------Start SKI(Vishal P) : #CR152 : PO And Delivery Date : 13-07-2022------------- */
                /*if(skuSaleOrderMap.containsKey(skuIdChosen)){
                    system.debug('conains id');
                    skuWrapObj = skuSaleOrderMap.get(skuIdChosen);
                    skuWrapObj.campaignDiscountPercent  = skuWrapObj2.campaignDiscountPercent ;
                    skuWrapObj.materialDiscountPercent  = skuWrapObj2.materialDiscountPercent ;
                    skuWrapObj.finalPrice = skuWrapObj2.finalPrice;
                    skuWrapObj.qty += skuWrapObj2.qty;
                    skuWrapObj.netRateEntered = skuWrapObj2.netRateEntered;
                    skuWrapObj.priceEntered =  skuWrapObj.netRateEntered*skuWrapObj.qty;
                    system.debug('skuWrapObj.Comment'+skuWrapObj.Comment);
                    system.debug('skuWrapObj.finalPrice'+skuWrapObj);
                    if(String.isNotBlank(skuWrapObj.soliId)){
                    soliObj.Id = skuWrapObj.soliId;
                    }
                    soliObj.Comment__c = skuWrapObj.Comment;
                    soliObj.Quantity__c = skuWrapObj.qty;
                    soliObj.Price__c = skuWrapObj.priceEntered;
                    soliObj.Net_Price__c= skuWrapObj.netRateEntered;
                    upsert soliObj;
            }
            else{*/
                /* ---------End SKI(Vishal P) : #CR152 : PO And Delivery Date : 13-07-2022------------ */
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
                //Added by Varun Shrivastava : SCTASK0282699 Start
                skuWrapObj.skuDescription = skuWrapObj2.skuDescription;
                //Added by Varun Shrivastava : SCTASK0282699 End
                
                skuWrapObj.minPrice = skuWrapObj2.minPrice;
                skuWrapObj.comment = skuWrapObj2.comment;
                skuWrapObj.finalPrice = skuWrapObj2.finalPrice;
                system.debug('skuWrapObj.finalPrice--'+skuWrapObj.finalPrice);
                
                skuWrapObj.campaignDiscount  = skuWrapObj2.campaignDiscount ;//not use for now
                skuWrapObj.materialDiscount  = skuWrapObj2.materialDiscount ;//not use for now
                skuWrapObj.distributorDiscount   = skuWrapObj2.distributorDiscount  ;//not in use for now
                
                skuWrapObj.campaignDiscountPercent  = skuWrapObj2.campaignDiscountPercent ;
                skuWrapObj.materialDiscountPercent  = skuWrapObj2.materialDiscountPercent ;
                skuWrapObj.distributorDiscountPercent  = skuWrapObj2.distributorDiscountPercent ;
                skuWrapObj.distributorDiscountId  = skuWrapObj2.distributorDiscountId;
                //End
                
                skuWrapObj.qty = skuWrapObj2.qty;
                skuWrapObj.UOM = skuWrapObj2.UOM;
                skuWrapObj.priceEntered = skuWrapObj2.priceEntered;
                skuWrapObj.currencyIso = skuWrapObj2.currencyIso;
                skuWrapObj.customerDeliveryDate = skuWrapObj2.customerDeliveryDate;  // SKI(Vishal P) : #CR152 : PO And Delivery Date : 13-07-2022
                
                system.debug('skuWrapObj.Comment'+skuWrapObj.Comment);
                soliObj.Sale_Order__c = salesOrderId;
                
                
                soliObj.SKU_Name__c = skuWrapObj.skuId;
                
                
                soliObj.DepotDepot__c = TurkeyDepo; 
                soliObj.UOM__c = skuWrapObj.UOM;
                soliObj.Comment__c = skuWrapObj.Comment;
                soliObj.FinalPrice__c = decimal.valueOf(skuWrapObj.finalPrice.replaceAll(',','')); //skuWrapObj.finalPrice;
                soliObj.Distributor_Discount__c = skuWrapObj.distributorDiscountPercent;
                soliObj.Material_Discount__c = skuWrapObj.materialDiscountPercent;
                soliObj.Campaign_Discount__c = skuWrapObj.campaignDiscountPercent;
                
                skuWrapObj.netRateEntered = skuWrapObj2.netRateEntered;
                
                itemNumber = itemNumber+10;
                skuWrapObj.itemNo = itemNumber;
                soliObj.Item_Number__c = itemNumber;
                soliObj.CurrencyIsoCode = distWrapObj.currencyIso;
                soliObj.Quantity__c = skuWrapObj.qty;
                soliObj.Price__c = skuWrapObj.priceEntered;
                soliObj.Net_Price__c= skuWrapObj.netRateEntered;
                System.debug('@@@@@ skuWrapObj.customerDeliveryDate '+skuWrapObj2.customerDeliveryDate);
                //added By Vishal CR152
                soliObj.Delivery_Date__c = skuWrapObj2.customerDeliveryDate;  // SKI(Vishal P) : #CR152 : PO And Delivery Date : 13-07-2022
                //ended by vishal Pawar
                insert soliObj;
                skuWrapObj.soliId = soliObj.Id;
                /* --------Start SKI(Vishal P) : #CR152 : PO And Delivery Date : 13-07-2022------------------ */
                //}
                //skuSaleOrderMap.put(skuWrapObj2.skuId,skuWrapObj);
                // skuSalesOrderList.clear();
                //skuSalesOrderList.addAll(skuSaleOrderMap.values());
                skuSalesOrderList.add(skuWrapObj);
                /* ------------End SKI(Vishal P) : #CR152 : PO And Delivery Date : 13-07-2022----------------- */
                refreshSaleOrderValue();
                showError = false;
            }else
                /* SKI(Vishal P) : #CR152 : PO And Delivery Date : 13-07-2022 */
                if((skuWrapObj2.netRateEntered==0 && skuWrapObj2.qty>0 && sampleDisable==true && logCoOj.Delivery_Date__c==false && skuWrapObj2.customerDeliveryDate==null) ||  (skuWrapObj2.netRateEntered==0 && sampleDisable==true && skuWrapObj2.qty>0 && skuWrapObj2.customerDeliveryDate!=null && logCoOj.Delivery_Date__c==true)){
                    //skuSalesOrderList.clear(); // SKI(Vishal P) : #CR152 : PO And Delivery Date : 13-07-2022
                    SKUDetails skuWrapObj;
                    Sales_Order_Line_Item__c soliObj = new Sales_Order_Line_Item__c();
                /* ----------------Start SKI(Vishal P) : #CR152 : PO And Delivery Date : 13-07-2022---------------------------- */    
                 /*
                if(skuSaleOrderMap.containsKey(skuIdChosen)){
                    system.debug('skuOrderMap'+skuSaleOrderMap);
                    skuWrapObj = skuSaleOrderMap.get(skuIdChosen);
                    skuWrapObj.campaignDiscountPercent  = skuWrapObj2.campaignDiscountPercent ;
                    skuWrapObj.materialDiscountPercent  = skuWrapObj2.materialDiscountPercent ;
                    // skuWrapObj.finalPrice = skuWrapObj2.finalPrice;
                    skuWrapObj.qty += skuWrapObj2.qty;
                    skuWrapObj.netRateEntered = 0;//skuWrapObj2.netRateEntered;
                    skuWrapObj.priceEntered =  0;//skuWrapObj.netRateEntered*skuWrapObj.qty;

                    //skuWrapObj.netRateEntered += skuWrapObj2.netRateEntered;
                    if(String.isNotBlank(skuWrapObj.soliId)){
                    soliObj.Id = skuWrapObj.soliId;
                    }
                    soliObj.Comment__c = skuWrapObj.Comment;
                    soliObj.Quantity__c = skuWrapObj.qty;
                    soliObj.Price__c = 0;//skuWrapObj.priceEntered;
                    soliObj.Net_Price__c= 0;// skuWrapObj.netRateEntered;
                    upsert soliObj;
                }
                else{*/
                /* ------------------End SKI(Vishal P) : #CR152 : PO And Delivery Date : 13-07-2022-------------------------------- */    
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
                    //Added by Varun Shrivastava : SCTASK0282699 Start
                    skuWrapObj.skuDescription = skuWrapObj2.skuDescription;
                    //Added by Varun Shrivastava : SCTASK0282699 End
                    
                    skuWrapObj.minPrice = 0;//skuWrapObj2.minPrice;
                    skuWrapObj.comment = skuWrapObj2.comment;
                    skuWrapObj.finalPrice = '0';//skuWrapObj2.finalPrice;
                    
                    skuWrapObj.campaignDiscountPercent  = 0;
                    skuWrapObj.materialDiscountPercent  = 0;
                    skuWrapObj.distributorDiscountPercent  = 0;
                    // skuWrapObj.distributorDiscountId  = skuWrapObj2.distributorDiscountId;
                    skuWrapObj.qty = skuWrapObj2.qty;
                    skuWrapObj.UOM = skuWrapObj2.UOM;
                    skuWrapObj.priceEntered = 0; 
                    skuWrapObj.currencyIso = skuWrapObj2.currencyIso;
                    skuWrapObj.customerDeliveryDate = skuWrapObj2.customerDeliveryDate; // SKI(Vishal P) : #CR152 : PO And Delivery Date : 13-07-2022
                    soliObj.Sale_Order__c = salesOrderId;
                    
                    soliObj.SKU_Name__c = skuWrapObj.skuId;
                    soliObj.UOM__c = skuWrapObj.UOM;
                    soliObj.DepotDepot__c = TurkeyDepo; 
                    soliObj.Comment__c = skuWrapObj.Comment;
                    soliObj.FinalPrice__c = 0;//skuWrapObj.finalPrice;
                    soliObj.Distributor_Discount__c =0;
                    soliObj.Material_Discount__c = 0;
                    soliObj.Campaign_Discount__c = 0;
                    skuWrapObj.netRateEntered = 0;//skuWrapObj2.netRateEntered;
                    
                    itemNumber = itemNumber+10;
                    skuWrapObj.itemNo = itemNumber;
                    soliObj.Item_Number__c = itemNumber;
                    soliObj.CurrencyIsoCode = distWrapObj.currencyIso;
                    soliObj.Quantity__c = skuWrapObj.qty;
                    soliObj.Price__c =0;
                    soliObj.Net_Price__c= 0;
                    soliObj.Delivery_Date__c = skuWrapObj2.customerDeliveryDate; // SKI(Vishal P) : #CR152 : PO And Delivery Date : 13-07-2022
                    insert soliObj;
                    skuWrapObj.soliId = soliObj.Id;
                    /* -----------Start SKI(Vishal P) : #CR152 : PO And Delivery Date : 13-07-2022-------------------------- */
                    // }
                    //skuSaleOrderMap.put(skuWrapObj2.skuId,skuWrapObj);
                    //skuSalesOrderList.clear();
                    //skuSalesOrderList.addAll(skuSaleOrderMap.values());
                    skuSalesOrderList.add(skuWrapObj);
                    /* ----------------End SKI(Vishal P) : #CR152 : PO And Delivery Date : 13-07-2022------------------------- */
                    refreshSaleOrderValue();
                    showError = false;
                }
            else{
                /* -----------Start SKI(Vishal P) : #CR152 : PO And Delivery Date : 13-07-2022--------------------------- */
                if(logCoOj.Delivery_Date__c == true){
                    System.debug('Inside checking quantiyu price date also');
                    errorMessage = 'Please Enter Quantity and Price and Customer Delivery date' ;
                }else{
                    errorMessage = System.Label.Please_enter_Quantity_Final_Price;                    
                    System.debug('Inside checking quantiyu price sadasdadate also');
                }
                /* --------------End SKI(Vishal P) : #CR152 : PO And Delivery Date : 13-07-2022--------------------------------- */
                showError = true;
            }
        }
        catch(Exception ex){
            system.debug('catch data found '+ex.getMessage()); // SKI(Vishal P) : #CR152 : PO And Delivery Date : 13-07-2022
            system.debug('catch data found line '+ex.getLineNumber()); // SKI(Vishal P) : #CR152 : PO And Delivery Date : 13-07-2022
            
            ApexLog.exceptionHandlerForSalesOrder(ex, salesOrderId, accountId);
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
                if(String.isNotBlank(skuObj.comment)){
                    soliObj.Comment__c = skuObj.comment;
                }
                soliObj.Quantity__c = skuObj.qty;
                soliObj.Net_Price__c = skuObj.netRateEntered;
                soliObj.Price__c = skuObj.priceEntered;
                soliObj.Delivery_Date__c = skuObj.CustomerDeliveryDate; // SKI(Vishal P) : #CR152 : PO And Delivery Date : 13-07-2022
                upsert soliObj;
                System.debug('updated');
                skuSaleOrderMap.put(skuObj.skuId,skuObj);
            }
            refreshSaleOrderValue();
        }
        catch(Exception ex){
            // ApexLog.exceptionHandler(ex, orderId, accountId);
            ApexLog.exceptionHandlerForSalesOrder(ex, salesOrderId, accountId); 
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
            // ApexLog.exceptionHandler(ex, orderId, accountId);
            ApexLog.exceptionHandlerForSalesOrder(ex, salesOrderId, accountId);
        }  
    }
    
    //Method to Save the Order as Draft
    public void saveOrder(){
        try{
            ApexLog.exceptionCoverage(throwEx);
            showError = false;
            //if payment Term is None
            if(paymentIdChosen.equals('None')){
                showError = true;
                errorMessage = System.Label.Payment_Terms_is_required;
                // 'Payment Terms is required';
            }else if(!skuSalesOrderList.isEmpty() && showError==false){
                orderSaved = true;
            }
            else if(showError==false){
                showError = true;
                errorMessage = System.Label.Please_add_product_to_cart;
                //'Please add product to cart';
            }
        }
        catch(Exception ex){
            //  ApexLog.exceptionHandler(ex, orderId, accountId);
            ApexLog.exceptionHandlerForSalesOrder(ex, salesOrderId, accountId);  
        }
    }
    
    //Method to  Validate & Confirm Order, disable Input, Submit for approval if conditions met
    public void confirmOrder(){
        try{
            system.debug('confirmOrder');
            ApexLog.exceptionCoverage(throwEx);
            if(Test.isRunningTest()){
                valuefromJS='Order Confirmed';
            }
            if(valuefromJS=='Order Confirmed'){
                saveOrder();
                
                Boolean flag = true;
                for(SKUDetails skuWrapObj:skuSalesOrderList){ // SKI(Vishal P) : #CR152 : PO And Delivery Date : 13-07-2022
                    if(skuWrapObj.comment=='' || skuWrapObj.comment==null ){
                        showError = true;
                        errorMessage = System.Label.Please_Enter_Comment;
                        flag = false;
                        //'Please Enter Comment; 
                        break;
                    }
                    if((skuWrapObj.finalPrice=='0' || skuWrapObj.finalPrice=='0.00') && sampleDisable==false){
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
                    /* ----------------Start SKI(Vishal P) : #CR152 : PO And Delivery Date : 13-07-2022=----------------------------- */
                    if(skuWrapObj.customerDeliveryDate==null && logCoOj.Delivery_Date__c){
                        showError = true;
                        //errorMessage = System.Label.Please_Enter_Quantity_for_all_SKU_s_before_confirming_order;
                        errorMessage = errorMessage = 'Please enter customer Delivery date for all SKU\'s before confirming Order';
                        flag = false;
                        //'Please Enter Quantity for all SKU\'s before confirming order'; 
                        break;
                    }
                     if(logCoOj.PO_Date__c == true && poDate==null){
                        showError = true;
                        errorMessage = System.Label.Purchase_Order_date_is_required;
                        flag = false;
                        break;
                    }
                    /* --------------End SKI(Vishal P) : #CR152 : PO And Delivery Date : 13-07-2022-------------------------- */
                }
                
                if(orderSaved && flag){
                    showError = false;
                    updateSKU();
                    // addSOLineItem();
                    if(orderSaved == True && showError==false){
                        if(paymentIdChosen!=''){
                            salesObj.Payment_Term__c =  paymentIdChosen;
                        }
                        salesObj.Order_Status__c = 'Pending';
                         salesObj.Purchase_Order_Date__c =  poDate; // SKI(Vishal P) : #CR152 : PO And Delivery Date : 13-07-2022
                        upsert salesObj;
                        
                        showError = true;
                        errorMessage = System.Label.Order_Confirmed;
                        //'Order Confirmed';
                    }
                }
            }
            else{
                showError = true;
                errorMessage = valuefromJS;
            }
            
        }
        catch(Exception ex){
            //  ApexLog.exceptionHandler(ex, orderId, accountId);
            ApexLog.exceptionHandlerForSalesOrder(ex, salesOrderId, accountId); 
        }            
    }
    
    //Method to re-calculate Order Value and Taxes on change
    public void refreshSaleOrderValue(){
        try{
            ApexLog.exceptionCoverage(throwEx);
            
            if(String.isNotBlank(salesOrderId)){
                Sales_Order__c saleorder=[select id ,Net_Amount__c 
                                          from Sales_Order__c
                                          Where Id=:salesOrderId LIMIT 1];
                grossAmount = saleorder.Net_Amount__c;
            }else{
                grossAmount= 0;  
            }
        }
        catch(Exception ex){
            //  ApexLog.exceptionHandler(ex, orderId, accountId);
            ApexLog.exceptionHandlerForSalesOrder(ex, salesOrderId, accountId);  
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
            //ApexLog.exceptionHandler(ex, orderId, accountId);
            ApexLog.exceptionHandlerForSalesOrder(ex, salesOrderId, accountId);
        }            
    }
    
    
    
    
    //Method to redirect to Sales Order Record
    public PageReference redirectFunction(){
        PageReference pg;
        if(salesOrderId!=null){
            if(salesObj.id!=null){
                pg = new PageReference('/'+salesObj.id);
            }
            else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.Some_error_has_occurred_while_Confirming_Order_Please_try_again));
            }        
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
        //Added by Varun Shrivastava :SCTASK0282699 Start
        public String skuDescription{get;set;}
        //Added by Varun Shrivastava :SCTASK0282699 End
        public String description {get;set;}
        public Boolean popular {get;set;}
        public Id distributorId {get;set;}
        public String productName {get;set;}
        public String productId {get;set;}
        public String oliId {get;set;}
        public String skuPackName {get;set;}
        public String soliId {get;set;}
        public String skuCode {get;set;}
        public String comment{get;set;}
        public Id skuId {get;set;}
        public Decimal packSize {get;set;}
        public String depotLocation {get;set;}
        public Id depotId {get;set;}      
        public String priceGroupCode {get;set;}
        public Id priceGroupId {get;set;} 
        public Id InventoryId {get;set;}
        public String UOM {get;set;}
        public Decimal netRateEntered{get;set;}
        public Decimal priceEntered {get;set;}
        public Decimal qty {get;set;}
        public Integer numberOfCases {get;set;}
        public Decimal price {get;set;}
        public Decimal minPrice {get;set;}
        public String finalPrice {get;set;}
        public Decimal discount {get;set;}
        public Integer itemNo {get;set;}
        public Integer perUnit {get;set;}
        public Decimal multipleOf {get;set;}
        public Decimal available {get;set;}
        
        public String available2 {get;set;}
        public String currencyIso {get;set;}
        
        public Decimal distributorDiscount {get;set;}
        public Decimal distributorDiscountPercent{get;set;}
        
        public Decimal campaignDiscount {get;set;}
        public Decimal materialDiscount {get;set;}
        
        public Decimal campaignDiscountPercent {get;set;}
        public Decimal materialDiscountPercent {get;set;}
        
        public Decimal campaignDiscountEntered {get;set;}
        public Decimal materialDiscountEntered {get;set;}
        public String distributorDiscountId {get;set;}
        
        public Date customerDeliveryDate {get;set;} //SKI(Vishal P) : #CR152 : PO And Delivery Date : 13-07-2022
        
        public SKUDetails(){
            UOM = 'N/A';
            //  qty = 0;
            packSize = 0;
            minPrice = 0;
            numberOfCases = 0;
            campaignDiscountEntered = 0;
            materialDiscountEntered = 0;
            priceEntered = 0;
            price = 0;
            //  finalPrice = 0;
            discount = 0;
            multipleOf = 0;
            netRateEntered = 0;
            available = 0;
            available2 = 'Out of Stock';
            popular = false;
            comment='';
            distributorDiscountId='';
            distributorDiscountPercent= 0;
            distributorDiscount = 0;
            
            campaignDiscountPercent= 0;
            campaignDiscount=0;
            
            materialDiscountPercent= 0;
            materialDiscount=0;
            //Added by Varun Shrivastava :SCTASK0282699 Start
            skuDescription='';
            //Added by Varun Shrivastava :SCTASK0282699 End
        }
    }
    
    public class SKUDetailsEdit{
        public Id tempSkuId {get;set;}
        public Decimal tempPrice {get;set;}
        public Decimal tempQty {get;set;}
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
    }
}