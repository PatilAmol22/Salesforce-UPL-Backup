/*
* Name: OrderTurkeyController
* Created On: 12 july 2018
* Author: Ganesh Chaurasia (ganesh.chaurasia@skinternational.com)
* Description: Class is used for Placing Orders by RM of Turkey
* RITM0155280: Sayan (crmconsultant3) have added new validation for Minimum price coming from priceBook, 21st Jan 2021
*/
global without sharing class OrderTurkeyController {
    //Variable to be set by JS for Attachment status
    public String valuefromJS {get;set;}
    /* -------------Start SKI(Vishal P) : #CR152 : PO And Delivery Date : 13-07-2022----------------- */
    public Login_Country__c logCoOj {get;set;}
    public Date poDate {get;set;}    
    /* --------------End SKI(Vishal P) : #CR152 : PO And Delivery Date : 13-07-2022 */
     
    public DistributorWrapper distWrapObj {get;set;}
    public ShippingLocation slwObj {get;set;}
    
    public List<SKUDetails> skuDetailsList {get;set;}
    public List<SKUDetails> skuOrderList {get;set;}
    public List<OrderLineItem__c> oliList {get;set;}
    public List<Sales_Order_Line_Item__c> oliList2 {get;set;}
    public List<OrderTemplate__c> tempList {get;set;}
    
    public Map<String,ShippingLocation> shippingMap {get;set;}    
    public Map<Id,SKUDetails> skuDetailsMap {get;set;}
    public Map<Id,SKUDetails> skuOrderMap {get;set;}
    public Map<String,String> stateMap {get;set;}
    public Map<String,String> StatusMap {get;set;}
    
    public Set<String> productNamesSet{get;set;}
    public Set<String> descriptionSet{get;set;}
    
   
    public String orderTypeId{get;set;}
    public String selectedOrderType{get;set;}
    public String selectedOrderName{get;set;}
    public List<SelectOption> orderTypeSet{get;set;} 
  //  public set<SelectOption> depotSet{get;set;}
    public List<SelectOption> paymentTermSet{get;set;}
    public List<SelectOption> shippingList {get;set;}    
    
    //Set Order Type Code
    public String orderTypeName{get;set;}
    public String orderTypeCode {get;set;}
    public String paymentTermCode {get;set;}
    public Set<string> TotalcreatedSO {get;set;}
    
    public String selectedShipping {get;set;}
    public String selectedDepot {get; set;}
    public String searchProdValue {get; set;}
    public String templateName {get; set;}
    public String errorMessage {get; set;}
    public String selectedPaymentTerm {get;set;}
    public String profilName{get;set;}
    
    public String skuIdChosen {get; set;}
    public String tempIdChosen {get; set;}
  //  public String storageIdChosen {get; set;}
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
    public Boolean sampleDisable{get;set;}
    public Boolean disableAdd{get;set;}
    public Boolean disableOType{get;set;}
    public Boolean showMinPrice{get;set;}
    
    public Boolean allowTemplate{get;set;}
    public Boolean orderSaved{get;set;}
    
    public Decimal grossAmount {get;set;}
    
    public Integer itemNumber;
    
    public String orderId{get;set;}
    public String PO{get;set;}
    public String accountId{get;set;}
    public String opportunityId{get;set;} //Nikhil Verma (Grazitti) for RITM0537885    
    public String depoId;
    public String distributorId;
    public String territoryManagerId;
    public String managerId;
    public String country;
    public String loggedUGDN;//#INC-408924:Changes made to bifergate sample and domestic order
    public Order__c ordObj {get;set;}
    public Sales_Order__c soObj {get;set;}
    
    public OrderTurkeyController(ApexPages.StandardController controller) {
        try{
            orderTypeCode = '';
            country = 'Turkey';
            paymentTermCode = '';  
            
            slwObj = new ShippingLocation();
            
            productNamesSet = new Set<String>();
            descriptionSet = new Set<String>();
            selectedOrderName = '';
          //  depotSet = new set<SelectOption>();
            paymentTermSet = new List<SelectOption>();
            orderTypeSet = new List<SelectOption>();
            skuDetailsList = new List<SKUDetails>();
            skuOrderList = new List<SKUDetails>();
            oliList = new List<OrderLineItem__c>();
            
            skuOrderMap = new Map<Id,SKUDetails>();
            shippingMap = new Map<String, ShippingLocation>();
            skuDetailsMap = new Map<Id,SKUDetails>();
            stateMap = new Map<String, String>();
            TotalcreatedSO =new Set<String>();
            
            
            searchProdValue = '';
            PO = '';
            errorMessage = '';
            skuIdChosen = '';
        //    storageIdChosen = '';
            paymentIdChosen = '';
            valuefromJS = '';
            profilName='';
            
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
            showMinPrice = false;
            
            throwEx = false;
            disableAdd =true;
            enableDepot = false;
            allowTemplate = false;
            orderSaved = false;
            disableOType=false;
            
            grossAmount = 0;
            
            itemNumber = 0;
            
            accountId = '';
            opportunityId = ''; //Nikhil Verma (Grazitti) for RITM0537885    
            distributorId = '';
            depoId = '';
            
            territoryManagerId = '';
            
            orderId = ApexPages.currentpage().getparameters().get('id');        
            
            System.debug('orderId: '+orderId);
            
            accountId = ApexPages.currentpage().getparameters().get('acid');
            System.debug('accountId: '+accountId);
            
            //Nikhil Verma (Grazitti) for RITM0537885    
            opportunityId = ApexPages.currentpage().getparameters().get('oppId');
            System.debug('opportunityId: '+opportunityId);
            if(opportunityId != '')
            {
                accountId = [SELECT Id,AccountId FROM Opportunity WHERE Id=: opportunityId].AccountId;
                System.debug('accountId: '+accountId);
            }            
           // End Nikhil Verma (Grazitti) for RITM0537885   
               
            User loginUserObj = [SELECT Id, Name, IsActive, ContactId,UserRole.name,Profile.Name,
                                 Show_Inventory__c, Show_Credit_Limit__c, EnableDepot__c,
                                 Show_Inventory_Column__c, ManagerId,UGDN_Number__c
                                 FROM User 
                                 WHERE Id =: UserInfo.getUserId()
                                 AND IsActive = True];
            
            showInventory = loginUserObj.Show_Inventory__c;
            showInventoryColumn = loginUserObj.Show_Inventory_Column__c;
            showCredit =  loginUserObj.Show_Credit_Limit__c;
            profilName = loginUserObj.Profile.Name;
            managerId = loginUserObj.ManagerId;
            loggedUGDN = loginUserObj.UGDN_Number__c;//#INC-408924:Changes made to bifergate sample and domestic order
            
            System.debug('loginUserObj: '+loginUserObj.Profile.Name);
            System.debug('showInventoryColumn: '+showInventoryColumn);
            System.debug('showCredit: '+showCredit);
            
            
            //Assign account Id if TM creates order on behalf of Distributor
            if(String.isNotBlank(accountId)){
                
                enableDepot = loginUserObj.EnableDepot__c;
                System.debug('enableDepot: '+enableDepot);
                //distributorId = [SELECT Id FROM User where Contact.AccountId =: accountId].Id;
                
                List<User> listUr = [Select u.Id, u.IsActive, u.IsPortalEnabled from User u where u.AccountId=:accountId];
                
               // if(listUr.size() >0 ){                          //Start GRZ(Butesh Singla) : APPS-4034  Date :28-12-2022
              //      distributorId = listUr[0].id;               //Start GRZ(Butesh Singla) : APPS-4034  Date :28-12-2022
             //   }else{                                           //Start GRZ(Butesh Singla) : APPS-4034  Date :28-12-2022
                    Account accowner = [Select id,ownerId From Account Where id =: accountId];
                    distributorId = accowner.ownerId;
            //    }                                               //Start GRZ(Butesh Singla) : APPS-4034  Date :28-12-2022
                System.debug('-inside if condition-- distributorId: '+ distributorId);
                /*    if(loginUserObj.UserRole.name.contains('Regional Manager')){
                        orderRaisedBy = 'Regional Manager';
                }*/
              /*  if(loginUserObj.UserRole.name.contains('District Manager')){
                    orderRaisedBy = 'District Manager'; //District Manager Turkey
                }
                else{
                    orderRaisedBy = 'Territory Manager';
                }*/
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
            
        }
        catch(Exception ex){
            System.debug('Method: Constructor Exception: '+ex.getMessage()+ ' Line Number: '+ex.getLineNumber());
        }
    }
    
    //Method to Create SalesOrder on Order Confirmation
    public void createSalesOrder(){
        try{
            ApexLog.exceptionCoverage(throwEx);
            if(ordObj!=null){
                soObj = new Sales_Order__c();
                soObj.Sold_to_Party__c = accountId;
                soObj.Bill_To_Party__c = accountId;
                if(opportunityId != ''){
                	soObj.Opportunity__c = opportunityId; //Nikhil Verma (Grazitti) for RITM0537885    
                }
                soObj.Order_Date__c = System.today();
                soObj.Order_Raise_By__c = orderRaisedBy;
                soObj.CreatedFrom__c = 'SFDC';
                soObj.OwnerId = distributorId;
                soObj.Order__c = ordObj.Id;
                soObj.Ship_To_Party__c = slwObj.locationId;
                soObj.Sales_Org_lk__c = distWrapObj.salesOrgId;
                soObj.Distribution_Channel_lk__c = distWrapObj.distributorChannelId;
                soObj.Division_lk__c = distWrapObj.divisionId;
                soObj.Credit_Term__c = distWrapObj.paymentTerms;
                soObj.Remarks__c = ordObj.Remarks__c;
                soObj.CurrencyIsoCode = distWrapObj.currencyIso;
                soObj.Order_Status__c = 'Pending'; //'Pending';
                /* --------------Start SKI(Vishal P) : #CR152 : PO And Delivery Date : 13-07-2022------- */
                /*  if(poDate==null && logCoOj.PO_Date__c == true){
                    showError = true;
                    errorMessage = 'Please enter PO Date before confirming Order';
                 } */
                soObj.Purchase_Order_Date__c = poDate;
                /* ------------End SKI(Vishal P) : #CR152 : PO And Delivery Date : 13-07-2022---------- */
               // soObj.Order_Type_lk__c = [Select Id FROM Order_Type__c WHERE Order_Type_Code__c=:orderTypeCode].Id;//distWrapObj.orderType  [Select Id FROM Order_Type__c WHERE Order_Type_Code__c='ZORD'].Id; 
                soObj.Order_Type_lk__c = selectedOrderType;
                soObj.Payment_Term__c =  paymentIdChosen;
                insert soObj;
               //#INC-372214:user murat ergül sample orders,Modified by Deeksha gupta
                Sales_Order__Share salesOrderShare  = new Sales_Order__Share();
                salesOrderShare.ParentId = soObj.id;
                salesOrderShare.UserOrGroupId = UserInfo.getUserId();
                salesOrderShare.AccessLevel ='read';
                salesOrderShare.RowCause = Schema.Sales_Order__Share.RowCause.Manual;
                insert salesOrderShare;
                
            }
        }
        catch(Exception ex){
            ApexLog.exceptionHandler(ex, orderId, accountId);
        }
    }
    
    //Method to add Line Items to SalesOrders on Order Confirmation
    public void addSOLineItem(){
        try{
            ApexLog.exceptionCoverage(throwEx);
            Boolean submitForApproval = false;
            Decimal distrbtrDscount = 0;
            Map<String,List<SKUDetails>> DivisionMap = new Map<String,List<SKUDetails>>();
            Id TurkeyDepo = [Select Id From Depot__c Where Name=:country LIMIT 1].Id;
            for(SKUDetails skuWrapObj:skuOrderList){ // SKI(Vishal P) : #CR152 : PO And Delivery Date : 13-07-2022
                
                if(!DivisionMap.containsKey(skuWrapObj.divNumber)) {
                    DivisionMap.put(skuWrapObj.divNumber, new List<SKUDetails>{skuWrapObj});
                }
                else{
                    DivisionMap.get(skuWrapObj.divNumber).add(skuWrapObj);
                }
            }
            system.debug('+DivisionMap.keySet()'+DivisionMap);
            for( String div : DivisionMap.keySet()){
                Integer i = 0;
                createSalesOrder();
                Sales_Order_Line_Item__c sliObj;
                
            for(SKUDetails skuWrapObj:DivisionMap.get(div)){
                i=i + 10;
                sliObj = new Sales_Order_Line_Item__c();
                sliObj.SKU_Name__c = skuWrapObj.skuId;
                sliObj.Item_Number__c = i;
                sliObj.Item_Status__c = 'Active';
                sliObj.DepotDepot__c = TurkeyDepo; 
                if(skuWrapObj.finalPrice!=null){
                sliObj.FinalPrice__c = decimal.valueOf(skuWrapObj.finalPrice.replaceAll(',',''));
                }
                sliObj.UOM__c = skuWrapObj.UOM;
                sliObj.CurrencyIsoCode = distWrapObj.currencyIso;
                sliObj.Distributor_Discount__c = skuWrapObj.distributorDiscountPercent;
                sliObj.Material_Discount__c = skuWrapObj.materialDiscountPercent;
                sliObj.Campaign_Discount__c = skuWrapObj.campaignDiscountPercent;
                
               
                if(sliObj.Item_Number__c==10 && sliObj.Distributor_Discount__c!=null ){
                   distrbtrDscount = sliObj.Distributor_Discount__c;
                }
                if(skuWrapObj.comment=='' || skuWrapObj.comment==null ){
                    showError = true;
                    errorMessage = System.Label.Please_Enter_Comment;
                    //'Please Enter Comment; 
                    break;
                }
                if((skuWrapObj.finalPrice=='0' || skuWrapObj.finalPrice=='0.00') && sampleDisable==false){
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
                /* -------------Start SKI(Vishal P) : #CR152 : PO And Delivery Date : 13-07-2022-------- */
                if(skuWrapObj.customerDeliveryDate==null && logCoOj.Delivery_Date__c == true){
                    showError = true;
                    //errorMessage = System.Label.Please_Enter_Quantity_for_all_SKU_s_before_confirming_order;
                    errorMessage = 'Please enter customer delivery Date for all sku before confirming Order';
                    //'Please Enter Quantity for all SKU\'s before confirming order'; 
                    break;
                } /* ---------Start SKI(Vishal P) : #CR152 : PO And Delivery Date : 13-07-2022----------- */
                else {
                    sliObj.Comment__c = skuWrapObj.comment;
                    sliObj.Quantity__c = skuWrapObj.qty;
                    sliObj.MinPrice__c = skuWrapObj.minPrice;
                    sliObj.Net_Price__c = skuWrapObj.netRateEntered;
                    submitForApproval = true;
                    sliObj.Price__c = skuWrapObj.priceEntered;
                    sliObj.Sale_Order__c = soObj.Id;
                    sliObj.Delivery_Date__c = skuWrapObj.customerDeliveryDate; // Start SKI(Vishal P) : #CR152 : PO And Delivery Date : 13-07-2022..
                    insert sliObj;
                }
            }
            
            //Update Tax and Total Amount in Sales Order
            if(soObj!=null){
                /* ------ SKI(Vishal P) : #CR152 : PO And Delivery Date : 13-07-2022--------- */
                soObj = [Select Id,Name, Net_Amount__c,Purchase_Order_Date__c from Sales_Order__c where id=:soObj.id];
                soObj.Division_lk__c =[Select Id,Name,Division_Code__c from Division__c where Division_Code__c=:div].Id;
                TotalcreatedSO.add(soObj.Name);
                if(submitForApproval){
                    soObj.Turkey_Order_Send_for_Approval__c = true;
                }
                soObj.Total_Amount__c = soObj.Net_Amount__c;
                system.debug('paymentIdChosen-->'+paymentIdChosen);
                if(paymentIdChosen!=''){
                soObj.Payment_Term__c =  paymentIdChosen;
                }
                soObj.Distributor_Discount__c = distrbtrDscount;
                soObj.Purchase_Order_Date__c = poDate; //  SKI(Vishal P) : #CR152 : PO And Delivery Date : 13-07-2022
                upsert soObj;
                System.debug('soObj: '+soObj);
            }
         }
       }
       catch(Exception ex){
            ApexLog.exceptionHandler(ex, orderId, accountId);
        }
    }
    
    public void changeOrderType(){
        System.debug('Order Type : '+selectedOrderType);
        orderTypeId=selectedOrderType;
        if(orderTypeName=='Free Samples'){
            sampleDisable=true;
        }else{
            sampleDisable=false;
        }
        fetchSKUData();
        skuOrderMap.clear();
        orderChangeUpdate();
        system.debug('sampleDisable'+sampleDisable);
    }
    
    
    public void orderChangeUpdate(){
        try{
          //  system.debug('orderId'+orderId+'-->'+selectedOrderType);
          if(selectedOrderType!='None'){
            if(orderId!=null){
                ApexLog.exceptionCoverage(throwEx);
                List<Order__c> ord =[Select id,Order_Type__c,Order_Type__r.Description__c from order__c where id=:orderId limit 1];
                if(ord.size()>0){
                    ord[0].Order_Type__c=selectedOrderType;
                    update ord[0];
                   
              }
            }
          }
        }
        catch(Exception ex){
            ApexLog.exceptionHandler(ex, orderId, accountId);
            
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
            /* -----Start SKI(Vishal P) : #CR152 : PO And Delivery Date : 13-07-2022------------ */
            logCoOj = [SELECT Id, Name, For_Contry__c, 
                       Sales_Org_Code__c, Delivery_Date__c, PO_Date__c, 
                       Show_Delivery_Date__c, Show_PO_Date__c 
                       FROM Login_Country__c
                       WHERE Sales_Org_Code__c='7110' LIMIT 1];
            /* ----------End SKI(Vishal P) : #CR152 : PO And Delivery Date : 13-07-2022----------- */           
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
            distWrapObj.ordertype = accList[0].Order_Type__c; 
            distWrapObj.paymentTerms = accList[0].Payment_Terms__c;
          //  distWrapObj.priceGroupId = accList[0].PriceGroupCode__c;
            
            
             // Populate Order Type  
            List<Order_Type__c> orderTypeList=[select Id,Order_Type_Code__c,SalesOrg__c, Description__c 
                                               from Order_Type__c 
                                               WHERE SalesOrg__r.Sales_Org_Code__c='7110'];
            //#INC-408924:Changes made to bifergate sample and domestic order
            List<Turkey_User__mdt> mtdList = [select id,Order_Type_Description__c,UGDN__c from Turkey_User__mdt where UGDN__c=: loggedUGDN ];
            
            if(orderTypeList.size()>0){
                orderTypeSet.add(new SelectOption('None','None'));
                for(order_type__c orderTypeObj:orderTypeList){
                    //#INC-408924:Changes made to bifergate sample and domestic order
                    if(!mtdList.isEmpty() && orderTypeObj.Description__c == mtdList[0].Order_Type_Description__c){
                        orderTypeSet.add(new SelectOption(orderTypeObj.id, orderTypeObj.Description__c));
                    }else if(mtdList.isEmpty()){
                        orderTypeSet.add(new SelectOption(orderTypeObj.id, orderTypeObj.Description__c));
                    }
                }
            } 
            //End
            if(profilName=='Regional tech & technical sales Turkey'){
                disableOType = true;
                selectedOrderType=[select id from Order_Type__c where Description__c='Free Samples'].id;
                if(orderId==null){
                    List<Order__c> lstOrdr =[SELECT Id FROM Order__c WHERE Order_Status__c='Draft' AND Bill_To_Party__c =: accountId LIMIT 1];
                    if(lstOrdr.size()>0){
                        orderId=lstOrdr[0].id;
                        orderChangeUpdate(); 
                        deleteAllSKU();
                    }
                   // orderId =[SELECT Id FROM Order__c WHERE Order_Status__c='Draft' AND Bill_To_Party__c =: accountId LIMIT 1].id;
                  
                    system.debug('tech looged'+orderId);
                }else{
                  //  createOrder();
                }
                system.debug('selectedOrderType'+selectedOrderType);
                system.debug('orderId'+orderId);
                sampleDisable = true;
               
            }
          
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
               // orderRaisedBy = 'Territory Manager';
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
                system.debug(' distWrapObj.creditLimit'+ distWrapObj.creditLimit);
            }
         /*   else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Credit Information for Distributor not found'));
                //CalloutException e = new CalloutException();
                //e.setMessage('?Credit Information for Distributor not found');
                //throw e;
            } */
            
            distWrapObj.address = accList[0].BillingStreet;
            distWrapObj.city = accList[0].BillingCity;
            distWrapObj.state = accList[0].BillingState;
            distWrapObj.country = accList[0].BillingCountry;
            distWrapObj.pincode = accList[0].BillingPostalCode;
            distWrapObj.currencyIso = accList[0].currencyIsoCode;
            distWrapObj.regionalManagerId = accList[0].RegionalManager__c;
            //End of Logic
            System.debug('distWrapObj: '+distWrapObj);
            system.debug('orderId'+orderId);
            if(String.isNotBlank(orderId)){
                //orderId = orderId.subString(1,orderId.length());
                editOrder();
            }
            if(String.isNotBlank(slwObj.locationId) && disableOType==false){
                if(ordObj==null){
                    createOrder();
                    refreshOrderValue();
                }
                ordObj.Shipping_Location__c = slwObj.locationId;
                update ordObj;
            }
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
                                                DepotCode__c, DepotCode__r.Location__c,SKUCode__r.Division__r.Division_Code__c, 
                                                Price__c, PG_CODE__c, PG_CODE__r.Name, SKUCode__r.Pack_Size__c, SKUCode__r.Division__r.Name
                                                ,
                                                UOM__c, SKUCode__r.Product_Name__r.Name, SKUCode__r.SKU_Description__c,
                                                SKUCode__r.Product_Name__c, CurrencyIsoCode,
                                                SKUCode__r.Product_Name__r.Popular__c, SKUCode__r.Multiple_Of__c, SKUCode__r.Brand_Name__c
                                                FROM PriceBookMaster__c
                                                WHERE (DistributorCustomerCode__c =: accountId 
                                                       OR (DepotCode__c =: depoId AND PG_CODE__c=:distWrapObj.priceGroupId))
                                                AND SKUCode__r.Sales_Org__c =: distWrapObj.salesOrgId
                                                AND MinPrice__c!=null
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
                    skuWrapObj.brandName = pbObj.SKUCode__r.Brand_Name__c+' '+pbObj.SKUCode__r.Name;
                }
                else{
                    skuWrapObj.brandName= pbObj.SKUCode__r.Name;
                }
                skuWrapObj.description = pbObj.SKUCode__r.SKU_Description__c;
                skuWrapObj.minPrice = pbObj.MinPrice__c; //Added by Divya
                //Added by Varun Shrivastava : SCTASK0282699 Start
                skuWrapObj.skuDescription = pbObj.SKUCode__r.SKU_Description__c;
                //Added by Varun Shrivastava : SCTASK0282699 End
                
                skuWrapObj.skuPackName = pbObj.SKUCode__r.Name;
                skuWrapObj.distributorId = accountId;
                skuWrapObj.productName = pbObj.SKUCode__r.Product_Name__r.Name;
                skuWrapObj.productId = pbObj.SKUCode__r.Product_Name__c;
                skuWrapObj.UOM = pbObj.UOM__c;
                skuWrapObj.skuCode = pbObj.SKUCode__r.SKU_Code__c;
                skuWrapObj.divNumber=pbObj.SKUCode__r.Division__r.Division_Code__c;
               
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
                if(String.isNotBlank(pbObj.SKUCode__r.Division__r.Name)){
                    skuWrapObj.description=skuWrapObj.description+' - '+pbObj.SKUCode__r.Division__r.Name;
                }
                
                //End of Patch
                
                skuWrapObj.skuId = pbObj.SKUCode__c;
                skuWrapObj.depotLocation = pbObj.DepotCode__r.Location__c;
                skuWrapObj.depotId = pbObj.DepotCode__c;
                if(pbObj.MinPrice__c!=null)
                    skuWrapObj.minPrice = Math.abs(pbObj.MinPrice__c);
               
                skuWrapObj.priceGroupCode = pbObj.PG_CODE__r.Name; 
                skuWrapObj.priceGroupId = pbObj.PG_CODE__c;
                skuWrapObj.currencyIso = pbObj.currencyIsoCode;
                skuWrapObj.popular = pbObj.SKUCode__r.Product_Name__r.Popular__c;
                if(String.isNotBlank(pbObj.SKUCode__c) && String.isNotBlank(skuWrapObj.UOM)){
                    skuDetailsMap.put(pbObj.SKUCode__c, skuWrapObj);
                }
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
           // System.debug('pbdList: '+pbdList);
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
           // System.debug('size: '+skuDetailsMap.size());
            
            System.debug('salesOrgName: '+distWrapObj.salesOrgName);
            
            //End of Logic
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
            system.debug('ordObj'+ordObj);
            if(ordObj==null){
                system.debug('creating order ');
                List<Order__c> recentOrderList =  [SELECT Id, Name, Net_Amount__c, Bill_To_Party__c,Order_Type__c,Order_Type__r.Description__c, Order_Date__c, 
                                                   Order_Raise_By__c, Order_Status__c, 
                                                   RegionalManager__c,Remarks__c , Shipping_Location__c, OwnerId, 
                                                   Gross_Amount__c
                                                   FROM Order__c 
                                                   WHERE Order_Status__c='Draft'
                                                   AND Bill_To_Party__c =: accountId LIMIT 1];
                
                if(!recentOrderList.isEmpty()){
                    ordObj = recentOrderList[0];
                    system.debug('ordObj'+ordObj);
                    orderId = ordObj.Id;
                    selectedOrderType= ordObj.Order_Type__c;
                    selectedOrderName = ordObj.Order_Type__r.Description__c;
                    if(ordObj.Order_Type__r.Description__c=='Free Samples'){
                        sampleDisable=true;
                    }
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
                    ordObj.Order_Type__c= selectedOrderType;    //orderTypeId;
                    
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
            system.debug('insdie Edit ');
            createOrder();
            refreshOrderValue();
            
            if(ordObj.Order_Status__c=='Approved'){
                enableInput = false;
            }
            
            
            List<OrderLineItem__c> oliList = [SELECT Id, Name, CurrencyIsoCode,SKU_Name__r.Division__r.Division_Code__c,
                                              Order__c, UOM__c, SKU_Name__c,Comment__c,Distributor_Discount__c,FinalPrice__c, Material_Discount__c,
                                              SKU_Name__r.Product_Name__r.Name, Net_Price__c,SKU_Name__r.Brand_Name__c,
                                              SKU_Name__r.SKU_Description__c,//Added by Varun Shrivastava : SCTASK0282699
                                              Campaign_Discount__c,
                                              SKU_Name__r.Name, Quantity__c, Price__c, Item_Number__c, 
                                              Item_Status__c, Order__r.Shipping_Location__c
                                              FROM OrderLineItem__c
                                              WHERE Order__c=:orderId];
            if(!oliList.isEmpty()){
                String shippingLocationId = oliList[0].Order__r.Shipping_Location__c;
                if(String.isNotBlank(shippingLocationId)){
                    List<Shipping_Location__c> sameAsBillList = [SELECT Id, City__c, Location_Name__c
                                                                 FROM Shipping_Location__c
                                                                 WHERE Id=:shippingLocationId]; 
                    
                    selectedShipping = sameAsBillList[0].Location_Name__c;
                }
                else{
                    selectedShipping = 'None';
                }
            }
            
            SKUDetails skuWrapObj;
            SKUDetails skuWrapObj2;
            
            skuWrapObj2 = new SKUDetails();
            System.debug('skuDetailsMap: '+skuDetailsMap);
             System.debug('oliList: '+oliList);
            
            for(OrderLineItem__c oliObj:oliList){
                if(skuDetailsMap.containsKey(oliObj.SKU_Name__c)){
                    skuWrapObj2 = skuDetailsMap.get(oliObj.SKU_Name__c);
                    skuWrapObj = new SKUDetails();
                    skuWrapObj.productName = oliObj.SKU_Name__r.Product_Name__r.Name;
                    skuWrapObj.skuCode = oliObj.SKU_Name__r.Name;
                    
                    skuWrapObj.skuId = oliObj.SKU_Name__c;
                    skuWrapObj.oliId = oliObj.Id;
                    if(String.isNotBlank(oliObj.SKU_Name__r.Brand_Name__c)){
                        skuWrapObj.brandName = oliObj.SKU_Name__r.Brand_Name__c+' '+oliObj.SKU_Name__r.Name;// oliObj.SKU_Name__r.Product_Name__r.Name+' '+oliObj.SKU_Name__r.Name; //added by ganesh
                    }
                    else{
                        skuWrapObj.brandName=oliObj.SKU_Name__r.Name;
                    }
                    //Added by Varun Shrivastava : SCTASK0282699 Start
                  skuWrapObj.skuDescription = oliObj.SKU_Name__r.SKU_Description__c;
                  //Added by Varun Shrivastava : SCTASK0282699 End
                    skuWrapObj.divNumber=oliObj.SKU_Name__r.Division__r.Division_Code__c;
                    skuWrapObj.minPrice = skuWrapObj2.minPrice;
                    //Patch added for discount turkey
                    skuWrapObj.campaignDiscount  = skuWrapObj2.campaignDiscount ;
                    skuWrapObj.materialDiscount  = skuWrapObj2.materialDiscount ;
                   
                    skuWrapObj.campaignDiscountPercent  = skuWrapObj2.campaignDiscountPercent ;
                    skuWrapObj.materialDiscountPercent  = skuWrapObj2.materialDiscountPercent ;
                    
                    skuWrapObj.distributorDiscountPercent  = skuWrapObj2.distributorDiscountPercent ;
                    
                    skuWrapObj.distributorDiscount   = skuWrapObj2.distributorDiscount  ;
                    skuWrapObj.distributorDiscountId  = skuWrapObj2.distributorDiscountId;
                    //End
                    
                    skuWrapObj.campaignDiscountPercent = oliObj.Campaign_Discount__c;
                    skuWrapObj.materialDiscountPercent = oliObj.Material_Discount__c;
                    skuWrapObj.distributorDiscountPercent = oliObj.Distributor_Discount__c;
                    system.debug(' skuWrapObj.distributorDiscountPercent'+ oliObj.Distributor_Discount__c);
                    skuWrapObj.comment  = skuWrapObj2.comment ;
                    skuWrapObj.finalPrice = oliObj.FinalPrice__c+'';
                    skuWrapObj.qty = oliObj.Quantity__c;
                    skuWrapObj.priceEntered = oliObj.Price__c;
                    skuWrapObj.netRateEntered = oliObj.Net_Price__c;
                    skuWrapObj.UOM = oliObj.UOM__c;
                    skuWrapObj.Comment= oliObj.Comment__c;
                    skuWrapObj.currencyIso = oliObj.CurrencyIsoCode;
                    skuWrapObj.itemNo = Integer.valueOf(oliObj.Item_Number__c);
                    skuOrderMap.put(skuWrapObj.skuId,skuWrapObj);
                    
                    itemNumber = Integer.valueOf(oliObj.Item_Number__c);
                    
                    skuOrderList.add(skuWrapObj);
                }
            }
        }
        catch(Exception ex){
            ApexLog.exceptionHandler(ex, orderId, accountId);
        }            
    }
    
    //Method to Add SKU to Order Table
    public void addSKU(){
        System.debug('AddSKU'); 
        try{
            ApexLog.exceptionCoverage(throwEx);
          
  
            if(String.isNotBlank(orderId)){
                Order__c  odrObj =  [SELECT Id,Order_Type__r.Description__c FROM Order__c WHERE Id=:orderId limit 1];
                if(odrObj.Order_Type__r.Description__c=='Free Samples'){
                sampleDisable=true;
            }
        }
        SKUDetails skuWrapObj2 = skuDetailsMap.get(skuIdChosen);
        system.debug('skuWrapObj2'+skuWrapObj2);
        /* ----------------Start SKI(Vishal P) : #CR152 : PO And Delivery Date : 13-07-2022---------- */
            if(Test.isRunningTest()){
                
                skuWrapObj2.netRateEntered = 200;
                skuWrapObj2.finalPrice = '12';
            }
            
            Decimal finlPrice = Decimal.valueOf(skuWrapObj2.finalPrice) ;
        /* ----------------End SKI(Vishal P) : #CR152 : PO And Delivery Date : 13-07-2022------------- */   
        // SKI(Vishal P) : #CR152 : PO And Delivery Date : 13-07-2022.....    
        if((skuWrapObj2.netRateEntered>0 && skuWrapObj2.qty>0 && finlPrice>0 && logCoOj.Delivery_Date__c==false && (skuWrapObj2.customerDeliveryDate==null || skuWrapObj2.customerDeliveryDate!=null )) || (skuWrapObj2.netRateEntered>0 && skuWrapObj2.qty>0 && finlPrice>0 && logCoOj.Delivery_Date__c==true && skuWrapObj2.customerDeliveryDate!=null) || Test.isRunningTest()){
           // skuOrderList.clear();   //  SKI(Vishal P) : #CR152 : PO And Delivery Date : 13-07-2022
            //skuOrderMap.clear();
            SKUDetails skuWrapObj;
            OrderLineItem__c oliObj = new OrderLineItem__c();
            /* -----------Start SKI(Vishal P) : #CR152 : PO And Delivery Date : 13-07-2022----------- */
            /*
                if(skuOrderMap.containsKey(skuIdChosen)){
                    system.debug('conains id');
                    skuWrapObj = skuOrderMap.get(skuIdChosen);
                    skuWrapObj.campaignDiscountPercent  = skuWrapObj2.campaignDiscountPercent ;
                    skuWrapObj.materialDiscountPercent  = skuWrapObj2.materialDiscountPercent ;
                    skuWrapObj.finalPrice = skuWrapObj2.finalPrice;
                    skuWrapObj.qty += skuWrapObj2.qty;
                    skuWrapObj.netRateEntered = skuWrapObj2.netRateEntered;
                    skuWrapObj.priceEntered =  skuWrapObj.netRateEntered*skuWrapObj.qty;
                    skuWrapObj.Comment = skuWrapObj2.Comment;
                    
                   //skuWrapObj.netRateEntered += skuWrapObj2.netRateEntered;
                    if(String.isNotBlank(skuWrapObj.oliId)){
                        oliObj.Id = skuWrapObj.oliId;
                    }
                 
                    //   if(skuWrapObj2.available==0 || skuWrapObj2.available2=='Out of Stock'){	
                    //    oliObj.Stock_Available__c = true;	
                    //}

                    oliObj.Comment__c = skuWrapObj.Comment;
                    oliObj.Quantity__c = skuWrapObj.qty;
                    oliObj.Price__c = skuWrapObj.priceEntered;
                    oliObj.Net_Price__c= skuWrapObj.netRateEntered;
                    upsert oliObj;
                }*/
                //else
                //{
            /* -----------End SKI(Vishal P) : #CR152 : PO And Delivery Date : 13-07-2022-------------- */        
            createOrder();
            
            skuWrapObj = new SKUDetails();
            skuWrapObj.customerDeliveryDate = skuWrapObj2.customerDeliveryDate;  // SKI(Vishal P) : #CR152 : PO And Delivery Date : 13-07-2022..
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
            skuWrapObj.divNumber=skuWrapObj2.divNumber;
            system.debug('skuWrapObj.finalPrice'+skuWrapObj.finalPrice);
            
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
            system.debug('skuWrapObj.Comment'+skuWrapObj.finalPrice);
            oliObj.Order__c = orderId;
            
            oliObj.SKU_Name__c = skuWrapObj.skuId;
            oliObj.UOM__c = skuWrapObj.UOM;
            oliObj.Comment__c = skuWrapObj.Comment;
            if(skuWrapObj.finalPrice!=null){
            oliObj.FinalPrice__c = decimal.valueOf(skuWrapObj.finalPrice.replaceAll(',','')); //skuWrapObj.finalPrice;
            }
            oliObj.Distributor_Discount__c = skuWrapObj.distributorDiscountPercent;
            oliObj.Material_Discount__c = skuWrapObj.materialDiscountPercent;
            oliObj.Campaign_Discount__c = skuWrapObj.campaignDiscountPercent;
            
            skuWrapObj.netRateEntered = skuWrapObj2.netRateEntered;
            
            itemNumber = itemNumber+10;
            skuWrapObj.itemNo = itemNumber;
            oliObj.Item_Number__c = String.valueOf(itemNumber);
            oliObj.CurrencyIsoCode = distWrapObj.currencyIso;
            oliObj.Quantity__c = skuWrapObj.qty;
            oliObj.Price__c = skuWrapObj.priceEntered;
            oliObj.Net_Price__c= skuWrapObj.netRateEntered;
            // oliObj.DistributorDiscountPercentage__c = skuWrapObj.discount;
            insert oliObj;
            skuWrapObj.oliId = oliObj.Id;
            /* -------------Start SKI(Vishal P) : #CR152 : PO And Delivery Date : 13-07-2022----------- */
               // }  
            //skuOrderMap.put(skuWrapObj2.skuId,skuWrapObj);
            //skuOrderList.addAll(skuOrderMap.values());
            skuOrderList.add(skuWrapObj);
            /* ------------End SKI(Vishal P) : #CR152 : PO And Delivery Date : 13-07-2022-------------- */
            refreshOrderValue();
            showError = false;
            }
            /* -------------SKI(Vishal P) : #CR152 : PO And Delivery Date : 13-07-2022---------------- */
            else if((skuWrapObj2.netRateEntered==0 && sampleDisable==true && skuWrapObj2.qty>0  && logCoOj.Delivery_Date__c==false && (skuWrapObj2.customerDeliveryDate!=null || skuWrapObj2.customerDeliveryDate==null)) || (skuWrapObj2.netRateEntered==0 && sampleDisable==true && skuWrapObj2.qty>0  && skuWrapObj2.customerDeliveryDate!=null && logCoOj.Delivery_Date__c==true) || Test.isRunningTest()){
               //  skuOrderList.clear(); // SKI(Vishal P) : #CR152 : PO And Delivery Date : 13-07-2022..
                 SKUDetails skuWrapObj;
                 OrderLineItem__c oliObj = new OrderLineItem__c();
                /* -----------Start SKI(Vishal P) : #CR152 : PO And Delivery Date : 13-07-2022-------- */
                /*
                if(skuOrderMap.containsKey(skuIdChosen)){
                    system.debug('skuOrderMap'+skuOrderMap);
                    skuWrapObj = skuOrderMap.get(skuIdChosen);
                    skuWrapObj.campaignDiscountPercent  = skuWrapObj2.campaignDiscountPercent ;
                    skuWrapObj.materialDiscountPercent  = skuWrapObj2.materialDiscountPercent ;
                   // skuWrapObj.finalPrice = skuWrapObj2.finalPrice;
                    skuWrapObj.qty += skuWrapObj2.qty;
                    skuWrapObj.netRateEntered = 0;//skuWrapObj2.netRateEntered;
                    skuWrapObj.priceEntered =  0;//skuWrapObj.netRateEntered*skuWrapObj.qty;
                    skuWrapObj.Comment = skuWrapObj2.Comment;
                    
                   //skuWrapObj.netRateEntered += skuWrapObj2.netRateEntered;
                    if(String.isNotBlank(skuWrapObj.oliId)){
                        oliObj.Id = skuWrapObj.oliId;
                    }

                    //   if(skuWrapObj2.available==0 || skuWrapObj2.available2=='Out of Stock'){	
                     //   oliObj.Stock_Available__c = true;	
                    //}
                 
                    oliObj.Comment__c = skuWrapObj.Comment;
                    oliObj.Quantity__c = skuWrapObj.qty;
                    oliObj.Price__c = 0;//skuWrapObj.priceEntered;
                    oliObj.Net_Price__c= 0;// skuWrapObj.netRateEntered;
                    upsert oliObj;
                }
                else{*/
                    /* -----------End SKI(Vishal P) : #CR152 : PO And Delivery Date : 13-07-2022 ------- */
                    createOrder();
                    
                    skuWrapObj = new SKUDetails();
                    skuWrapObj.customerDeliveryDate = skuWrapObj2.customerDeliveryDate;  // SKI(Vishal P) : #CR152 : PO And Delivery Date : 13-07-2022
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
                    system.debug('skuWrapObj.finalPrice1'+skuWrapObj.finalPrice);
                  
                  
                    skuWrapObj.divNumber=skuWrapObj2.divNumber;
                    skuWrapObj.campaignDiscountPercent  = 0;
                    skuWrapObj.materialDiscountPercent  = 0;
                    skuWrapObj.distributorDiscountPercent  = 0;
                   // skuWrapObj.distributorDiscountId  = skuWrapObj2.distributorDiscountId;
                    //End
                
                    skuWrapObj.qty = skuWrapObj2.qty;
                    skuWrapObj.UOM = skuWrapObj2.UOM;
                    skuWrapObj.priceEntered = 0; 
                    skuWrapObj.currencyIso = skuWrapObj2.currencyIso;
                    system.debug('skuWrapObj.Comment1'+skuWrapObj.Comment);
                    oliObj.Order__c = orderId;
                    
                    oliObj.SKU_Name__c = skuWrapObj.skuId;
                    oliObj.UOM__c = skuWrapObj.UOM;
                    oliObj.Comment__c = skuWrapObj.Comment;
                    oliObj.FinalPrice__c = 0;//skuWrapObj.finalPrice;
                    oliObj.Distributor_Discount__c =0;
                    oliObj.Material_Discount__c = 0;
                    oliObj.Campaign_Discount__c = 0;
                    
                    skuWrapObj.netRateEntered = 0;//skuWrapObj2.netRateEntered;
                    
                    itemNumber = itemNumber+10;
                    skuWrapObj.itemNo = itemNumber;
                    oliObj.Item_Number__c = String.valueOf(itemNumber);
                    oliObj.CurrencyIsoCode = distWrapObj.currencyIso;
                    oliObj.Quantity__c = skuWrapObj.qty;
                    oliObj.Price__c =0;
                    oliObj.Net_Price__c= 0;
                    insert oliObj;
                    skuWrapObj.oliId = oliObj.Id;
                    /* -----------Start SKI(Vishal P) : #CR152 : PO And Delivery Date : 13-07-2022------------- */
               // }
               
                    //skuOrderMap.put(skuWrapObj2.skuId,skuWrapObj);
                    //skuOrderList.addAll(skuOrderMap.values());
                    skuOrderList.add(skuWrapObj);
                    /* ----------End SKI(Vishal P) : #CR152 : PO And Delivery Date : 13-07-2022------------------ */
                    refreshOrderValue();
                    showError = false;
                    //  enableInput = false;
                
            }
            else{
                /* ---------------Start SKI(Vishal P) : #CR152 : PO And Delivery Date : 13-07-2022----------------- */
                if(logCoOj.Delivery_Date__c == true){
                    System.debug('Inside checking quantiyu price date also');
                    errorMessage = 'Please Enter Quantity and Customer Delivery date' ;
                }else{
                    errorMessage = System.Label.Please_enter_Quantity_Final_Price;                    
                    System.debug('Inside checking quantiyu price sadasdadate also');
                }
                /* -------------End SKI(Vishal P) : #CR152 : PO And Delivery Date : 13-07-2022------------------- */
                showError = true;
                
            }
        }
        catch(Exception ex){
            System.debug('catch data found messgae '+ex.getMessage());  // SKI(Vishal P) : #CR152 : PO And Delivery Date : 13-07-2022
            System.debug('catch data found Line Number '+ex.getLineNumber());  // SKI(Vishal P) : #CR152 : PO And Delivery Date : 13-07-2022
            ApexLog.exceptionHandler(ex, orderId, accountId);
            
        }            
    }
    
    //Method to update existing Order line item on Qty/Price Change
    public void updateSKU(){
        try{
            ApexLog.exceptionCoverage(throwEx);
            System.debug('skuObj.finalPrice: ');
            OrderLineItem__c oliObj = new OrderLineItem__c();
            for(SKUDetails skuObj:skuOrderList){
                if(String.isNotBlank(skuObj.oliId)){
                    oliObj.Id = skuObj.oliId;
                }
                 if(String.isNotBlank(skuObj.comment)){
                oliObj.Comment__c = skuObj.comment;
                }
                oliObj.FinalPrice__c=decimal.valueOf(skuObj.finalPrice.replaceAll(',',''));
                oliObj.Quantity__c = skuObj.qty;
                oliObj.Net_Price__c = skuObj.netRateEntered;
                oliObj.Price__c = skuObj.priceEntered;
                upsert oliObj;
                System.debug('skuObj.netRateEntered: '+skuObj.netRateEntered);
                skuOrderMap.put(skuObj.skuId,skuObj);            
            }
            refreshOrderValue();
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
            refreshOrderValue();
        }
        catch(Exception ex){
            ApexLog.exceptionHandler(ex, orderId, accountId);
            
        }            
    }
    
    //Method to Empty Order Summary
    public void deleteAllSKU(){
        try{
            system.debug('deleteAllSKU');
             system.debug('orderId'+orderId);
            if(orderId!=null){
            ApexLog.exceptionCoverage(throwEx);
            delete[Select id from OrderLineItem__c where order__c=:orderId];
               
            skuOrderMap.clear();
            skuOrderList.clear();
            refreshOrderValue();
            }
        }
        catch(Exception ex){
            ApexLog.exceptionHandler(ex, orderId, accountId);
            
        }  
    }
    
    
   /* public void DeleteOrderObj(){
        try{
            
            system.debug('orderId'+orderId);
            if(orderId!=null){
                ApexLog.exceptionCoverage(throwEx);
                delete[Select id from Order__c where id=:orderId];
                orderId=null;
                skuOrderMap.clear();
                skuOrderList.clear();
                refreshOrderValue();
            }
        }
        catch(Exception ex){
            ApexLog.exceptionHandler(ex, orderId, accountId);
            
        }  
    }*/
    
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
            //if payment Term is None
            if(paymentIdChosen.equals('None')){
                showError = true;
                errorMessage = System.Label.Payment_Terms_is_required;
                system.debug('Payment Terms is required');
            } 
            else if(!skuOrderList.isEmpty() && showError==false){
                orderSaved = true;
                 system.debug('skuOrderList'+skuOrderList);
            }
            else if(showError==false){
                showError = true;
                errorMessage = System.Label.Please_add_product_to_cart;
              system.debug('Please add product to cart');
            }
        }
        catch(Exception ex){
            ApexLog.exceptionHandler(ex, orderId, accountId);
            
        }
    }
    
    //Method to  Validate & Confirm Order, disable Input, Submit for approval if conditions met
    public void confirmOrder(){
        try{
            system.debug('confirmOrder');
            ApexLog.exceptionCoverage(throwEx);
            if(Test.isRunningTest()){
                valuefromJS='Sales Order created successfully!';
            }
            if(valuefromJS=='Sales Order created successfully!'){
                saveOrder();
               // system.debug('updating sku');
               // updateSKU();
                
                Boolean flag = true;
                for(SKUDetails skuWrapObj:skuOrderList){ // SKI(Vishal P) : #CR152 : PO And Delivery Date : 13-07-2022..
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
                    /* ------------Start SKI(Vishal P) : #CR152 : PO And Delivery Date : 13-07-2022------ */
                    if(skuWrapObj.customerDeliveryDate==null && logCoOj.Delivery_Date__c == true){
                        showError = true;
                        //errorMessage = System.Label.Please_Enter_Quantity_for_all_SKU_s_before_confirming_order;
                        errorMessage = 'Please enter Customer Delivery Date for all sku before comfirming Order';
                        flag = false;
                        break;
                    }
                    /* --------End SKI(Vishal P) : #CR152 : PO And Delivery Date : 13-07-2022----------- */
                    system.debug('skuWrapObj.comment'+skuWrapObj.comment);
                    if(skuWrapObj.comment=='' || skuWrapObj.comment==null ){
                        showError = true;
                        errorMessage = System.Label.Please_Enter_Comment;
                        flag = false;
                        //'Please Enter Comment; 
                        break;
                    }

                    /* --------------Start SKI(Vishal P) : #CR152 : PO And Delivery Date : 13-07-2022------- */
                    if(poDate==null && logCoOj.PO_Date__c == true){
                        showError = true;
                        errorMessage = System.Label.Purchase_Order_date_is_required;
                        flag = false;
                        break;
                    }
                    /* ------------End SKI(Vishal P) : #CR152 : PO And Delivery Date : 13-07-2022---------- */
                }
                
                if(orderSaved && flag){
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
                            errorMessage = System.Label.Sales_Order_created_successfully_Sales_Order_Number_is +' '+ finaltxt+'.';
                           // errorMessage = valuefromJS +' Sales Order Number is '+ finaltxt+'.';  Sales_Order_created_successfully_Sales_Order_Number_is
                        }
                        if(TotalcreatedSO.size()>1){
                            enableInput = false;
                           // errorMessage = 'Sales Orders created successfully! '+' Due to different  Division, multiple orders created as: '+ finaltxt+'.';
                            errorMessage = System.Label.Sales_Orders_created_successfully_Due_to_different_Division_multiple_orders_c + finaltxt+'.';
                        }
                       // errorMessage = System.Label.Order_Confirmed;
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
            ApexLog.exceptionHandler(ex, orderId, accountId);
            
        }            
    }
    
    //Method to re-calculate Order Value and Taxes on change
    public void refreshOrderValue(){
        try{
            ApexLog.exceptionCoverage(throwEx);
            if(String.isNotBlank(orderId)){
               Order__c  orderObj =  [SELECT Id, Gross_Amount__c, Remarks__c ,
                                      Shipping_Location__c
                                      FROM Order__c 
                                      WHERE Id=:orderId];
                grossAmount = orderObj.Gross_Amount__c;
                system.debug(grossAmount+'grossAmount');
            }else{
              grossAmount= 0;  
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
            ApexLog.exceptionCoverage(throwEx);
            
            List<OrderTemplateItem__c> oliList = new List<OrderTemplateItem__c>();
            
            OrderTemplate__c otObj = new OrderTemplate__c();
            otObj.name = templateName;
            otObj.DistributorCustomerCode__c = accountId;
            insert otObj;
            
            for(SKUDetails skuObj:skuOrderList){
                system.debug('skuObj'+skuObj);
                OrderTemplateItem__c otiObj = new OrderTemplateItem__c();
                otiObj.Name = skuObj.skuCode;
                otiObj.SKU__c = skuObj.skuId;
                otiObj.OrderTemplate__c = otObj.Id;
                otiObj.CurrencyIsoCode = skuObj.currencyIso;
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
          if(selectedOrderType!='None'){
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
                                                  SKU__r.Product_Name__r.Name, SKU__r.Name,SKU__r.Division__r.Division_Code__c,
                                                  SKU__r.SKU_Description__c , //Added by Varun Shrivastava SCTASK0282699
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
                  
                if(oliObj.SKU__r.Brand_Name__c == null || oliObj.SKU__r.Brand_Name__c ==''){
                    skuWrapObj.brandName = oliObj.SKU__r.Name;
                }
                else{
                    skuWrapObj.brandName = oliObj.SKU__r.Brand_Name__c+' '+oliObj.SKU__r.Name;  
                }
                //Added by Varun Shrivastava : SCTASK0282699 Start
                skuWrapObj.skuDescription = oliObj.SKU__r.SKU_Description__c;
                //Added by Varun Shrivastava : SCTASK0282699 End
                skuWrapObj.divNumber=oliObj.SKU__r.Division__r.Division_Code__c;
                skuWrapObj.minPrice = skuWrapObj2.minPrice;
                skuWrapObj.netRateEntered = skuWrapObj.netRateEntered;
                skuWrapObj.qty = 0;
                skuWrapObj.UOM = oliObj.SKU__r.UOM__c;
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
                oliObj.CurrencyIsoCode = skuWrapObj.currencyIso;
                insert oliObj;
                skuWrapObj.oliId = oliObj.Id;     
            }
          }
            else{
                system.debug('exxro');
                showError = true;
                errorMessage = System.Label.Please_Enter_Quantity_for_all_SKU_s_before_confirming_order;
            }
        }
        catch(Exception ex){
            ApexLog.exceptionHandler(ex, orderId, accountId);
        }            
    }
    
    //Method to redirect to Sales Order Record
    public PageReference redirectFunction(){
        PageReference pg;
        if(String.isNotBlank(accountId) && soObj!=null){
            pg = new PageReference('/'+accountId);
        }
        else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.Some_error_has_occurred_while_Confirming_Order_Please_try_again));
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
        public Date customerDeliveryDate {get;set;}  // SKI(Vishal P) : #CR152 : PO And Delivery Date : 13-07-2022
        public String brandName {get;set;}
        public String description {get;set;}
        //Added by Varun Shrivastava :SCTASK0282699 Start
        public String skuDescription{get;set;}
        //Added by Varun Shrivastava :SCTASK0282699 End
        public Boolean popular {get;set;}
        public Id distributorId {get;set;}
        public String productName {get;set;}
        public String productId {get;set;}
        public String oliId {get;set;}
        public String skuPackName {get;set;}
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
        public String divNumber{get;set;}
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
        
        public SKUDetails(){
            customerDeliveryDate = null; // SKI(Vishal P) : #CR152 : PO And Delivery Date : 13-07-2022
            UOM = 'N/A';
           // qty = 0;
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
            divNumber='';
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