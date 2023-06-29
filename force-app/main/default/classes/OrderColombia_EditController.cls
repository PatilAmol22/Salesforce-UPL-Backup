/*
* Name: OrderColombia_EditController
* * Created On: 18 JAN 2019
* Author: Abhis
* Description: Class is used for Placing Orders by Distributor, TM, RM of Colombia
*/
global without sharing class OrderColombia_EditController{
    //Variable to be set by JS for Attachment status
    public String valuefromJS {get;set;}
        public Sales_Order__c salesObj {get;set;}
    public String divId{get;set;}
    public String salesorderCombinationKey='';
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
    
    //Order Related Permissions
    public Boolean showCredit{get;set;}
    public Boolean showInventory{get;set;}
    public Boolean showInventoryColumn{get;set;}
    public Boolean showMinPrice{get;set;}
    public Boolean showMaxPrice{get;set;}
    public Boolean showFloorPrice{get;set;}
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
    /*abhishek*/
    public OrderColombia_EditController(ApexPages.StandardController controller) {
        try{
            multipleOf=0;
               Sent_for_Latam_Director_Approval=false;
            Sent_for_Director_Approval= false;
                Remaks='';
            Sent_for_Manager_Approval = false;
                        salesObj=new Sales_Order__c();
                        salesorderCombinationKey='';

            orgSalesorderMap = new MAP<String,Sales_Order__c>();
           
            showMinPrice= false;
            showMaxPrice= false;
            showFloorPrice= false;
            CurrencyCodeList = new Set<SelectOption>();
          skuOrderList = new List<SKUDetails>();
            oldSKUList = new List<SKUDetailsEdit>();
            skuSalesOrderList=new List<SKUDetails>();
            //CurrencyCodeList.add('-None-');
            CurrencyCodeList.add(new SelectOption('-None-','-None-'));
            CurrencyCodeList.add(new SelectOption('MXN','MXN'));
            CurrencyCodeList.add(new SelectOption('USD','USD'));
             orderTypeCode = 'ZORU';
            country = '5710';
            SelectedCurrency='COP';
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
            
            territoryManagerId = '';
            
            orderId = ApexPages.currentpage().getparameters().get('id');        
            System.debug('orderId: '+orderId);
            salesOrderId = ApexPages.currentpage().getparameters().get('soid');
            system.debug('salesOrderId '+salesOrderId );
            accountId = ApexPages.currentpage().getparameters().get('acid');
            System.debug('accountId: '+accountId);
            
            loginUserObj = [SELECT Id, Name, IsActive, ContactId,UserRole.name,Show_Min_Price__c,Show_Max_Price__c,Show_Floor_Price__c,
                                 Show_Inventory__c, Show_Credit_Limit__c, EnableDepot__c,
                                 Show_Inventory_Column__c, ManagerId,Show_InTransit__c, Show_InTransit_Values__c,HO__c, Country_Head__c, Marketing_Manager__c
                                 FROM User 
                                 WHERE Id =: UserInfo.getUserId()
                                 AND IsActive = True];
            
            showInventory = loginUserObj.Show_Inventory__c;
            showInventoryColumn = loginUserObj.Show_Inventory_Column__c;
            showCredit =  loginUserObj.Show_Credit_Limit__c;
            showInTransit = loginUserObj.Show_InTransit__c;
            showInTransitValues = loginUserObj.Show_InTransit_Values__c;
            showMinPrice = loginUserObj.Show_Min_Price__c;
            showMaxPrice = loginUserObj.Show_Max_Price__c;
            showFloorPrice = loginUserObj.Show_Floor_Price__c;
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
              if(String.isNotBlank(salesOrderId)){
                       salesObj = [select id, Remarks__c,SFDC_Order_Number__c,Price_Entry__c,Name,Order_Type_lk__c,Division_lk__c ,Net_Amount__c,Inco_Term__c,PaymentMethod__c ,CurrencyIsoCode,Payment_Term__c,Payment_Term__r.Payment_Term__c, Order_Type_lk__r.Description__c from Sales_Order__c Where Id=:salesOrderId limit 1];
                       selectedSoId = salesObj.Name;
                     //  grossamount = salesObj.Net_Amount__c;
                       paymentTermCode=salesObj.Payment_Term__c;
                       selectedOrderType = salesObj.Order_Type_lk__c;
                       SelectedCurrency = salesObj.CurrencyIsoCode;
                       Payment_Methods=salesObj.PaymentMethod__c ;
                       salesorderCombinationKey = salesObj.SFDC_Order_Number__c;
                       system.debug('salesorderCombinationKey---->'+salesorderCombinationKey);
                       
                       Payment_Terms =salesObj.Payment_Term__c;
                       Inco_Terms  = salesObj.Inco_Term__c; 
                       PriceEntry = salesObj.Price_Entry__c;
                       Remaks = salesObj.Remarks__c;
                       PriceEntry = salesObj.Price_Entry__c;
                       system.debug('SelectedCurrency---> '+SelectedCurrency);
                       
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
            
            SOLineItemList=[select id,Manager_Price__c,Order_Item_Key__c ,SKU_Name__r.SKU_Code__c,SKU_Name__r.SKU_Description__c,Director_Price__c,CurrencyIsoCode,Sale_Order__c,multipleOf__c,SKU_Description__c,MinPrice__c,MaxPrice__c,Comment__c,FinalPrice__c,Campaign_Discount__c,SKU_Name__c,SKU_Name__r.Division__c,
                            Net_Price__c,Quantity__c,UOM__c,Material_Discount__c,Distributor_Discount__c,DistributorDiscountPercentage__c,SKU_Name__r.Brand_Name__c,Price__c,SKU_Name__r.Name
                            from Sales_Order_Line_Item__c 
                            where Sale_Order__c=:salesOrderId];
            
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
                System.debug('oldSKUList'+oldSKUList);
            }
            
            System.debug('saleOrderlist' +SOLineItemList); 
            if(SOLineItemList.size()>0) {
                
                for(Sales_Order_Line_Item__c solitobj:SOLineItemList){
                system.debug('solitobj--> '+solitobj);
                system.debug('skuDetailsMap--->'+skuDetailsMap);
                
                SKUDetails skuWrapObj3 =new SKUDetails();
                SKUDetails skuWrapObj=new SKUDetails();
                
                 if(skuDetailsMap.containsKey(solitobj.SKU_Name__c)){
                        skuWrapObj3=new SKUDetails();
                        skuWrapObj3 = skuDetailsMap.get(solitobj.SKU_Name__c);
                        skuWrapObj.Price = skuWrapObj3.Price; 
                        skuWrapObj.packsize = skuWrapObj3.packsize;
                        system.debug('skuWrapObj3--->'+skuWrapObj3);
                     }
                    if(String.isNotBlank(solitobj.SKU_Name__r.Brand_Name__c)){
                        skuWrapObj.brandName=solitobj.SKU_Name__r.Brand_Name__c+' '+solitobj.SKU_Name__r.SKU_Description__c+' '+solitobj.SKU_Name__r.SKU_Code__c;
                    }
                    else{
                        skuWrapObj.brandName=solitobj.SKU_Name__r.SKU_Description__c+' '+solitobj.SKU_Name__r.SKU_Code__c;
                    }
                    //End
                   // skuWrapObj.brandName=solitobj.SKU_Description__c+' '+solitobj.SKU_Name__r.Name;
                    
                   // skuWrapObj.Price = skuWrapObj3.Price;      //solitobj.MaxPrice__c;   added in above if...
                    skuWrapObj.maxPrice=skuWrapObj3.maxPrice;
                    skuWrapObj.minPrice=skuWrapObj3.minPrice;
                    skuWrapObj.finalPrice=Integer.valueof(solitobj.FinalPrice__c+'')+'';    //solitobj.Net_Price__c;
                    skuWrapObj.qty=solitobj.Quantity__c;
                    skuWrapObj.priceEntered= solitobj.Price__c;
                    skuWrapObj.multipleof=solitobj.multipleOf__c;
                    skuWrapObj.Director_Price = solitobj.Director_Price__c;
                    skuWrapObj.Manager_Price= solitobj.Manager_Price__c;
                    skuWrapObj.packsize = skuWrapObj3.packsize;       //     added in above if...
                    
                  
                   // skuWrapObj.finalPrice= solitobj.FinalPrice__c;        // by Nikhil..
                    system.debug('skuWrapObj.finalPrice--->'+solitobj.FinalPrice__c);
                   system.debug('skuWrapObj.Director_Price__c--->'+solitobj.Director_Price__c);
                   system.debug('skuWrapObj.Manager_Price__c--->'+solitobj.Manager_Price__c);
                    skuWrapObj.UOM=skuWrapObj3.UOM;
                    //error discount display zero
                    
                    
                   
                    system.debug('skuWrapObj--'+skuWrapObj);
                    
                     
                    
                    skuWrapObj.netRateEntered=solitobj.Price__c;
                    skuWrapObj.skuId=solitobj.SKU_Name__c;
                    skuWrapObj.soliId= solitobj.Id;
                    
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
               System.debug('Method: Constructor Exception: '+ex.getMessage()+ ' Line Number: '+ex.getLineNumber());
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
            soObj.CurrencyIsoCode =SelectedCurrency;
            
           
            system.debug('Login User-----: '+loginUserObj);
            soObj.Latam_Director_Mexico__c = loginUserObj.HO__c;
            soObj.Sales_Director_Mexico__c = loginUserObj.Country_Head__c;
            soObj.Manager__c = loginUserObj.ManagerId;   
            soObj.Customer_Service_CAM__c = loginUserObj.Marketing_Manager__c;
            
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
            
            soObj.Order_Type_lk__c = [Select Id FROM Order_Type__c WHERE Order_Type_Code__c=:orderTypeCode].Id;//distWrapObj.orderType  [Select Id FROM Order_Type__c WHERE Order_Type_Code__c='ZORD'].Id; 
            
            
            insert soObj;
            orgSalesorderMap.put(salesOrgId,soObj);
            system.debug('orgSalesorderMap - '+orgSalesorderMap);
            
        }
        return soObj.ID;
    }
    //Method to Create SalesOrder on Order Confirmation
    
  
    
    public void changeDepot(){
        System.debug('Storage Location: '+storageIdChosen);
        fetchSKUData();
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
                                     Order_Type__c,Payment_Term_Code__C,Sales_District__r.Sales_Director__c,Sales_District__r.Latam_Director__c, Order_Block__c,Sales_Org_Code__c, Status__c, Payment_Terms__c, PriceGroupCode__c
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
             country ='5710'; //for multi country
            List<DistributorSalesAreaMapping__c> SalesAreaDMList = [SELECT Id,Order_Type__c ,Sales_Org_Code__c,PriceGroupMaster__c,Name, Distributor__c, DistributionChannel__c, Division__c, SalesOrg__c, Status__c FROM DistributorSalesAreaMapping__c where Distributor__c=:accountId];                                                 
            DistributorSalesAreaMappingMAP = new MAP<String,DistributorSalesAreaMapping__c>();
            List<String>divisionIdsforDepot = new List<String>();
            for(DistributorSalesAreaMapping__c DSAM : SalesAreaDMList){
                DistributorSalesAreaMappingMAP.put(DSAM.Division__c,DSAM);
                divisionIdsforDepot.add(DSAM.Division__c);
                 
                  salesorgcodeforpbmlist =DSAM.Sales_Org_Code__c; 
            }
          
            system.debug('country----> '+country);
            paymentMethodList = [SELECT Id, Name, Active__c, Description__c,Payment_Method_Code__c,Sales_Org__r.sales_org_code__c FROM Payment_Method__c where Sales_Org__r.sales_org_code__c=:country];
            incoTermList= [SELECT Id, Name, Active__c, Sales_Org__c,IncoTerm_Desc__c FROM Inco_Term__c where Sales_Org__r.Sales_Org_Code__c='5710' AND Active__c=true];
              payemntTermSingleList =  [SELECT Id,name,Payment_Term__c,Payterms_Desc__c,Sales_Org__c,Payment_Term_Code__c FROM Payment_Term__c where Sales_Org__r.sales_org_code__c='5710'];
            payemntTermList = [SELECT Id,name,Sales_Org__c,Payment_Term_Code__c,Payterms_Desc__c FROM Payment_Term__c where Sales_Org__r.sales_org_code__c='5710'];    
          
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
            distWrapObj.paymentTerms = payemntTermSingleList [0].Payment_Term__c;//accList[0].Payment_Term_Code__C;
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
                                                 Sold_To_Party_SAP_Code__c, SAP_Code__c,Location_Name__c,Billing_Street_1__c,Billing_Street_2__c,Billing_Street_3__c,Billing_Street_4__c,Billing_Street_5__c,Billing_Street_6__c
                                                 FROM Shipping_Location__c
                                                 WHERE Distributor__c =:accountId];
            
            if(slList.isEmpty()){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Shipping Details not found'));
                //CalloutException e = new CalloutException();
                //e.setMessage('?Shipping Details not found');
                //throw e;
            }            
             if(!slList.isEmpty()){
                 
                slwObj.address = slList[0].Region__c;
                slwObj.Name = slList[0].Name;
                slwObj.city = slList[0].City__c;
                slwObj.country = slList[0].Country__c;
                slwObj.pincode = slList[0].Pincode__c;
                slwObj.state = slList[0].State__c;
                slwObj.LocationName = slList[0].Location_Name__c; 
                    slwObj.Billing_Street_1 = slList[0].Billing_Street_1__c;
                    slwObj.Billing_Street_2 = slList[0].Billing_Street_2__c;
                    slwObj.Billing_Street_3 = slList[0].Billing_Street_3__c;
                    slwObj.Billing_Street_4 = slList[0].Billing_Street_4__c;
                    slwObj.Billing_Street_5 = slList[0].Billing_Street_5__c;
                    slwObj.Billing_Street_6 = slList[0].Billing_Street_6__c;
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
            
            List<Depot__c> storageList = [Select Id, Name,depot_code__c  from Depot__c where recordtype.name = 'Storage Location' and Depot__r.name='CO51' order by Name];
            for(Depot__c tdmObj:storageList){
                depotSet.add(new SelectOption(tdmObj.Id,tdmObj.Name+' '+tdmObj.depot_code__c));
            }
            if(!storageList.isEmpty()){
                storageIdChosen = storageList[0].Id;
            }
            
            List<Payment_Term__c> paymentTermList = [Select Id, Payment_Term_Code__c, Payment_Term__c from Payment_Term__c where sales_org__r.sales_org_code__c='5710'];
            for(Payment_Term__c tdmObj:paymentTermList){
                paymentTermSet.add(new SelectOption(tdmObj.Id,tdmObj.Payment_Term__c));
            }
            if(!paymentTermList.isEmpty()){
                paymentIdChosen = paymentTermList[0].Id;
            }
            
            if(String.isNotBlank(distWrapObj.depot)){
                
            }
           // fetchSKUData();
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
            shippingList.add(new SelectOption('Select shipping location',System.label.Select_Shipping_Address));
            for(Shipping_Location__c slObj:slList){
                ShippingLocation slw2Obj = new ShippingLocation();
                
                //Logic to Map Same Billing Addres based on Sold to Party SAP Code
                if(String.isNotBlank(slObj.SAP_Code__c) && distWrapObj.sapCode == slObj.SAP_Code__c){
                    shippingList.add(new SelectOption(slObj.SAP_Code__c,System.label.same_as_billing_address));
                    
                    slw2Obj.locationId = slObj.Id;
                    slw2Obj.Name = slObj.Name;
                    slw2Obj.address = slObj.Region__c;
                    slw2Obj.city = slObj.City__c;
                    slw2Obj.state = distWrapObj.State;
                    
                      slw2Obj.Billing_Street_1 = slObj.Billing_Street_1__c;
                    slw2Obj.Billing_Street_2 = slObj.Billing_Street_2__c;
                    slw2Obj.Billing_Street_3 = slObj.Billing_Street_3__c;
                    slw2Obj.Billing_Street_4 = slObj.Billing_Street_4__c;
                    slw2Obj.Billing_Street_5 = slObj.Billing_Street_5__c;
                    slw2Obj.Billing_Street_6 = slObj.Billing_Street_6__c;
                    
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
                    shippingList.add(new SelectOption(slObj.Name,slObj.City__c+'-'+slObj.Pincode__c));
                    
                    slw2Obj.locationId = slObj.Id;
                    slw2Obj.Name = slObj.Name;
                    slw2Obj.address = slObj.Region__c;
                    slw2Obj.city = slObj.City__c;
                    slw2Obj.state = slObj.State__c;
                    slw2Obj.LocationName =slObj.Location_Name__c;
                    slw2Obj.Billing_Street_1 = slObj.Billing_Street_1__c;
                    slw2Obj.Billing_Street_2 = slObj.Billing_Street_2__c;
                    slw2Obj.Billing_Street_3 = slObj.Billing_Street_3__c;
                    slw2Obj.Billing_Street_4 = slObj.Billing_Street_4__c;
                    slw2Obj.Billing_Street_5 = slObj.Billing_Street_5__c;
                    slw2Obj.Billing_Street_6 = slObj.Billing_Street_6__c;
                    /*if(stateMap.containsKey(slObj.State__c)){
slw2Obj.state = stateMap.get(slObj.State__c);
}
else{
ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, System.Label.State_Code_not_found));
}*/
                    slw2Obj.country = slObj.Country__c;
                    slw2Obj.pincode = slObj.Pincode__c;
                    shippingMap.put(slw2Obj.Name, slw2Obj);
                }
                //End of Logic
            }
            //End of Logic
            system.debug('orderId----->'+orderId);
            List<PriceBookMaster__c> pbmList = [SELECT Id, BudgetPrice__c ,Final_Price__c, Director_Price__c,Manager_Price__c,SKUCode__c ,Division__c,MaxPrice__c,SKUCode__r.Multiple_Of__c,SKUCode__r.Name, 
                                                    SKUCode__r.SKU_Code__c,SKUCode__r.Pack_Size__c, MinPrice__c,
                                                    DepotCode__c, DepotCode__r.Location__c, 
                                                    Price__c, PG_CODE__c, PG_CODE__r.Name, 
                                                    UOM__c, SKUCode__r.Product_Name__r.Name,
                                                    SKUCode__r.Product_Name__c, CurrencyIsoCode,SKUCode__r.Brand_Name__c,
                                                    SKUCode__r.Product_Name__r.Popular__c, SKUCode__r.SKU_Description__c
                                                    FROM PriceBookMaster__c
                                                    WHERE (DistributorCustomerCode__c =: accountId 
                                                           OR (DepotCode__c =: depoId ))
                                                    AND SKUCode__r.Sales_Org__r.sales_org_code__c =:salesorgcodeforpbmlist
                                                    AND StartDate__c <= TODAY AND EndDate__c >= TODAY AND SKUCode__r.Active__c = True  
                                                    AND Division__c IN : distWrapObj.divisionIds ORDER BY SKUCode__r.Brand_Name__c ASC, SKUCode__r.SKU_Code__c DESC, StartDate__c ASC];
            
                
                System.debug('pbmList1: '+pbmList);
                System.debug('size: '+pbmList.size());
                
                if(pbmList.isEmpty()){
                    //errorMessage = 'Pricebook for Depot/Distributor not found';
                    //showError = true;
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.Pricebook_for_Depot_Distributor_not_found));
                    
                    CalloutException e = new CalloutException();
                    //e.setMessage(query);
                    throw e;
                }
                SKUDetails skuWrapObj4;
                for(PriceBookMaster__c pbObj : pbmList){
                    skuWrapObj4 = new SKUDetails();
                      
                   /* if(pbObj.SKUCode__c==pbObj.SKUCode__r.Name)
                        skuWrapObj.brandName = pbObj.SKUCode__r.Product_Name__r.Name;
                    else
                    skuWrapObj4.brandName = pbObj.SKUCode__r.Product_Name__r.Name +' '+pbObj.SKUCode__r.Name ;*/
                    if(String.isNotBlank(pbObj.SKUCode__r.Brand_Name__c)){
                       skuWrapObj4.brandName=pbObj.SKUCode__r.Brand_Name__c+' '+pbObj.SKUCode__r.SKU_Description__c+' '+pbObj.SKUCode__r.SKU_Code__c;  }
                    else{
                       skuWrapObj4.brandName=pbObj.SKUCode__r.SKU_Description__c+' '+pbObj.SKUCode__r.SKU_Code__c;  }
                    
                    //End
                    skuWrapObj4.description = pbObj.SKUCode__r.SKU_Description__c;
                    skuWrapObj4.skuPackName = pbObj.SKUCode__r.Name;
                    skuWrapObj4.distributorId = accountId;
                    skuWrapObj4.productName = pbObj.SKUCode__r.Product_Name__r.Name;
                    skuWrapObj4.productId = pbObj.SKUCode__r.Product_Name__c;
                    skuWrapObj4.maxprice = pbObj.Price__c;             //pbObj.Price__c;
                    skuWrapObj4.minprice = pbObj.MinPrice__c;
                    skuWrapObj4.Director_Price = pbObj.Director_Price__c;
                    skuWrapObj4.floorPrice =  pbObj.BudgetPrice__c;
                    skuWrapObj4.Manager_Price = pbObj.Manager_Price__c;
                    skuWrapObj4.UOM = pbObj.UOM__c;
                    skuWrapObj4.skuCode = pbObj.SKUCode__r.SKU_Code__c;
                    skuWrapObj4.skuId = pbObj.SKUCode__c;
                    skuWrapObj4.depotLocation = pbObj.DepotCode__r.Location__c;
                    skuWrapObj4.depotId = pbObj.DepotCode__c;
                    skuWrapObj4.multipleOf = pbObj.SKUCode__r.Multiple_Of__c;
                    //if(pbObj.MinPrice__c!=null)
                    //    skuWrapObj.minPrice = Math.abs(pbObj.MinPrice__c);
                    if(pbObj.Price__c!=null)
                        skuWrapObj4.price = pbObj.Price__c;
                    skuWrapObj4.priceGroupCode = pbObj.PG_CODE__r.Name; 
                    skuWrapObj4.priceGroupId = pbObj.PG_CODE__c;
                    skuWrapObj4.currencyIso = pbObj.currencyIsoCode;
                    skuWrapObj4.popular = pbObj.SKUCode__r.Product_Name__r.Popular__c;
                    skuWrapObj4.divisionId=pbObj.Division__c;//Abhishek
                    skuWrapObj4.packsize = pbObj.SKUCode__r.Pack_Size__c;
                  
                   // skuWrapObj4.finalprice =pbObj.final_price__c+''; 
                    skuWrapObj4.price =pbObj.final_price__c; 
                    
                    if(String.isNotBlank(pbObj.SKUCode__c) && String.isNotBlank(skuWrapObj4.UOM)){
                        skuDetailsMap.put(pbObj.SKUCode__c, skuWrapObj4);
                    }
                    
                    
                    
                }
                //storageIdChosen='a0w0k000001BowCAAS';
                 system.debug('storageIdChosen---------------> '+storageIdChosen);
                List<Inventory__c> invList = [SELECT Id, SKU__c, 
                                              Stock_Quantity__c, Balanced_Quanity__c,In_transit_stock_quantity__c
                                              FROM Inventory__c
                                              WHERE Depot__c =: depoId AND SKU__r.Active__c = True AND Storage_Location_Depot__c=:storageIdChosen];    /*AND Storage_Location_Depot__c=:storageIdChosen*/    
                
                System.debug('invList: '+invList);
                System.debug('size: '+invList.size());
                
                for(Inventory__c pbObj : invList){
                    if(skuDetailsMap.containsKey(pbObj.SKU__c)){
                        skuWrapObj4 = skuDetailsMap.get(pbObj.SKU__c);
                        skuWrapObj4.available = Integer.valueOf(pbObj.Balanced_Quanity__c); //+ skuWrapObj.available;
                        skuWrapObj4.inventoryId = pbObj.Id;
                        if(pbObj.Balanced_Quanity__c!=null && pbObj.Balanced_Quanity__c > 0){
                            skuWrapObj4.available2 = 'In Stock';
                        }
                        else if(pbObj.In_transit_stock_quantity__c != null){
                            if(pbObj.In_transit_stock_quantity__c > 0 && showInTransit==true && showInTransitValues==false){
                                skuWrapObj4.available2 = 'In Transit';
                            }
                            else if(pbObj.In_transit_stock_quantity__c > 0 && showInTransit==false && showInTransitValues==true){
                                skuWrapObj4.available2 = '('+pbObj.In_transit_stock_quantity__c+')';
                            }                    
                            else if(pbObj.In_transit_stock_quantity__c > 0 && showInTransit==true && showInTransitValues==true){
                                skuWrapObj4.available2 = 'In Transit ('+pbObj.In_transit_stock_quantity__c+')';
                            } 
                        }
                        skuDetailsMap.put(pbObj.SKU__c, skuWrapObj4);
                    }
                }
               // skuDetailsMap
                 for(SKUDetails skuWrapObj:skuDetailsMap.values()){
                
                skuWrapObj.netRateEntered = 0;
                
                productNamesSet.add(skuWrapObj.brandName);
                descriptionSet.add(skuWrapObj.skucode+' - '+skuWrapObj.description);
                //if(skuWrapObj.Popular){
                skuDetailsList.add(skuWrapObj);
                //}
                
                skuDetailsMap.put(skuWrapObj.skuId, skuWrapObj);
            }
                //End of Logic
            if(String.isNotBlank(salesOrderId )){
                //orderId = orderId.subString(1,orderId.length());
                //editOrder();
                
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
              /*skuDetailsList.clear();
                productNamesSet.clear();
                descriptionSet.clear();
                skuDetailsMap.clear();*/
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
                List<PriceBookMaster__c> pbmList = [SELECT Id, Final_Price__c, Director_Price__c,Manager_Price__c,SKUCode__c ,Division__c,MaxPrice__c,SKUCode__r.Multiple_Of__c,SKUCode__r.Name, 
                                                    SKUCode__r.SKU_Code__c,SKUCode__r.Pack_Size__c, MinPrice__c,
                                                    DepotCode__c, DepotCode__r.Location__c, 
                                                    Price__c, PG_CODE__c, PG_CODE__r.Name, 
                                                    UOM__c, SKUCode__r.Product_Name__r.Name,
                                                    SKUCode__r.Product_Name__c, CurrencyIsoCode,SKUCode__r.Brand_Name__c,
                                                    SKUCode__r.Product_Name__r.Popular__c, SKUCode__r.SKU_Description__c
                                                    FROM PriceBookMaster__c
                                                    WHERE (DistributorCustomerCode__c =: accountId 
                                                           OR (DepotCode__c =: depoId ))
                                                    AND SKUCode__r.Sales_Org__r.sales_org_code__c =:salesorgcodeforpbmlist 
                                                    AND StartDate__c <= TODAY AND EndDate__c >= TODAY AND SKUCode__r.Active__c = True  
                                                    AND Division__c IN : distWrapObj.divisionIds ORDER BY SKUCode__r.Brand_Name__c ASC, SKUCode__r.SKU_Code__c DESC, StartDate__c ASC];
                
                // SKUCode__r.Pack_Size__c!=0  nikhil
                
                //AND PG_CODE__c=:distWrapObj.priceGroupId
                /* String query  = 'SELECT Id, SKUCode__c ,SKUCode__r.Name, ';
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
query += 'AND SKUCode__r.Sales_Org__c =\''+distWrapObj.salesOrgId+'\' ';
query += 'AND StartDate__c <= TODAY AND EndDate__c >= TODAY AND SKUCode__r.Active__c = True ';
query += 'ORDER BY SKUCode__r.Product_Name__r.Name ASC, SKUCode__r.SKU_Code__c DESC';*/
                
                //System.debug('query: '+query);
                
                System.debug('pbmList: '+pbmList);
                System.debug('size: '+pbmList.size());
                
                if(pbmList.isEmpty()){
                    //errorMessage = 'Pricebook for Depot/Distributor not found';
                    //showError = true;
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.Pricebook_for_Depot_Distributor_not_found));
                    
                    CalloutException e = new CalloutException();
                    //e.setMessage(query);
                    throw e;
                }
                SKUDetails skuWrapObj;
                for(PriceBookMaster__c pbObj : pbmList){
                    skuWrapObj = new SKUDetails();
                    
                    //if(pbObj.SKUCode__c==pbObj.SKUCode__r.Name)
                    //    skuWrapObj.brandName = pbObj.SKUCode__r.Product_Name__r.Name;
                    //else
                    //skuWrapObj.brandName = pbObj.SKUCode__r.Product_Name__r.Name +' '+pbObj.SKUCode__r.Name ;
                    
                    if(String.isNotBlank(pbObj.SKUCode__r.Brand_Name__c)){
                     skuWrapObj.brandName=pbObj.SKUCode__r.Brand_Name__c+' '+pbObj.SKUCode__r.SKU_Description__c+' '+pbObj.SKUCode__r.SKU_Code__c;  }
                    else{
                      skuWrapObj.brandName=pbObj.SKUCode__r.SKU_Description__c+' '+pbObj.SKUCode__r.SKU_Code__c;  }
                  
                    
                    
                    skuWrapObj.description = pbObj.SKUCode__r.SKU_Description__c;
                    skuWrapObj.skuPackName = pbObj.SKUCode__r.Name;
                    skuWrapObj.distributorId = accountId;
                    skuWrapObj.productName = pbObj.SKUCode__r.Product_Name__r.Name;
                    skuWrapObj.productId = pbObj.SKUCode__r.Product_Name__c;
                    skuWrapObj.maxprice = pbObj.Price__c;
                    skuWrapObj.minprice = pbObj.MinPrice__c;
                     skuWrapObj.Director_Price = pbObj.Director_Price__c;
                    skuWrapObj.Manager_Price = pbObj.Manager_Price__c;
                    skuWrapObj.UOM = pbObj.UOM__c;
                    skuWrapObj.skuCode = pbObj.SKUCode__r.SKU_Code__c;
                    skuWrapObj.skuId = pbObj.SKUCode__c;
                    skuWrapObj.depotLocation = pbObj.DepotCode__r.Location__c;
                    skuWrapObj.depotId = pbObj.DepotCode__c;
                    skuWrapObj.multipleOf = pbObj.SKUCode__r.Multiple_Of__c;
                    //skuWrapObj.finalPrice = pbObj.Final_Price__c+'';
                    //if(pbObj.MinPrice__c!=null)
                    //    skuWrapObj.minPrice = Math.abs(pbObj.MinPrice__c);
                   /* if(pbObj.Price__c!=null)
                        skuWrapObj.price = pbObj.Price__c;*/
                    
                     system.debug('skuWrapObj.finalPrice------->'+skuWrapObj.finalPrice);
                    if(pbObj.Final_Price__c!=null)
                        skuWrapObj.price = pbObj.Final_Price__c;   
                         
                    skuWrapObj.priceGroupCode = pbObj.PG_CODE__r.Name; 
                    skuWrapObj.priceGroupId = pbObj.PG_CODE__c;
                    skuWrapObj.currencyIso = pbObj.currencyIsoCode;
                    skuWrapObj.popular = pbObj.SKUCode__r.Product_Name__r.Popular__c;
                    skuWrapObj.divisionId=pbObj.Division__c;//Abhishek
                    skuWrapObj.packsize = pbObj.SKUCode__r.Pack_Size__c;
                   
                    system.debug('skuWrapObj.divisionId- - '+skuWrapObj.divisionId);
                    if(String.isNotBlank(pbObj.SKUCode__c) && String.isNotBlank(skuWrapObj.UOM)){
                        skuDetailsMap.put(pbObj.SKUCode__c, skuWrapObj);
                    }
                    
                }
                //End of Logic
                
                //Logic to populate existing wrapper with Inventory
                system.debug('storageIdChosen--------2-------> '+storageIdChosen);
                List<Inventory__c> invList = [SELECT Id, SKU__c, 
                                              Stock_Quantity__c, Balanced_Quanity__c,In_transit_stock_quantity__c
                                              FROM Inventory__c
                                              WHERE Depot__c =: depoId AND SKU__r.Active__c = True AND Storage_Location_Depot__c=:storageIdChosen];    /*AND Storage_Location_Depot__c=:storageIdChosen*/    
                
                System.debug('invList2: '+invList);
                System.debug('size2: '+invList.size());
                
                for(Inventory__c pbObj : invList){
                    if(skuDetailsMap.containsKey(pbObj.SKU__c)){
                        skuWrapObj = skuDetailsMap.get(pbObj.SKU__c);
                        skuWrapObj.available = Integer.valueOf(pbObj.Balanced_Quanity__c); //+ skuWrapObj.available;
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
                        system.debug('skuWrapObj2:'+skuWrapObj);
                        skuDetailsMap.put(pbObj.SKU__c, skuWrapObj);
                    }
                }
               // skuDetailsMap
            
                System.debug('skuDetailsMap2: '+skuDetailsMap);
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
        try{
            ApexLog.exceptionCoverage(throwEx);
            
            SKUDetails skuWrapObj2 = skuDetailsMap.get(skuIdChosen);
            
            if(skuWrapObj2.netRateEntered>0 && skuWrapObj2.qty>0 && Decimal.valueof(skuWrapObj2.finalprice.replace(',','.'))>0 || Test.isRunningTest()){
                skuOrderList.clear();
                SKUDetails skuWrapObj;
                OrderLineItem__c oliObj = new OrderLineItem__c();
                
                if(skuOrderMap.containsKey(skuIdChosen)){
                system.debug('Inside if of add SKU');
                    skuWrapObj = skuOrderMap.get(skuIdChosen);
                    skuWrapObj.finalPrice = skuWrapObj2.finalPrice;
                     skuWrapObj.floorPrice = skuWrapObj2.floorPrice;
                    
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
                    oliObj.Net_Price__c= Decimal.valueof(skuWrapObj2.finalprice.replace(',','.'));
                    upsert oliObj;
                }
                else{
                system.debug('Inside else of add SKU');
                    createOrder();
                    
                    skuWrapObj = new SKUDetails();
                    skuWrapObj.productName = skuWrapObj2.productName;
                     skuWrapObj.floorPrice = skuWrapObj2.floorPrice;
                    skuWrapObj.skuCode = skuWrapObj2.skuCode;
                    skuWrapObj.skuId = skuWrapObj2.skuId;
                    skuWrapObj.brandName = skuWrapObj2.brandName;
                    skuWrapObj.price = skuWrapObj2.price;
                    //skuWrapObj.minPrice = skuWrapObj2.minPrice;
                    skuWrapObj.finalPrice = skuWrapObj2.finalPrice;
                    
                    
                    skuWrapObj.packsize = skuWrapObj2.packsize;        //by Nikhil
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
                    
                    skuWrapObj.netRateEntered = skuWrapObj2.netRateEntered;
                    skuWrapObj.multipleOf =skuWrapObj2.multipleOf; 
                    itemNumber = itemNumber+10;
                    skuWrapObj.itemNo = itemNumber;
                    oliObj.Item_Number__c = String.valueOf(itemNumber);
                    oliObj.CurrencyIsoCode = distWrapObj.currencyIso;
                    oliObj.Quantity__c = skuWrapObj2.qty;         // skuWrapObj.qty; by Nikhil..
                    oliObj.Price__c = skuWrapObj2.netRateEntered;  // skuWrapObj.netRateEntered; by Nikhil..
                    oliObj.Net_Price__c= Decimal.valueof(skuWrapObj2.finalprice.replace(',','.'));   // skuWrapObj.finalPrice; by Nikhil..
                    
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
            ApexLog.exceptionHandler(ex, orderId, accountId);
            
        }            
    }
    
    //Method to update existing Order line item on Qty/Price Change
    public void updateSKU(){
        try{
            ApexLog.exceptionCoverage(throwEx);
           
            Sales_Order_Line_Item__c soliObj=new Sales_Order_Line_Item__c();
            Integer ietmNum2 = 0;
            system.debug('skuSaleOrderMap.values()'+skuSaleOrderMap.values());
            skuSalesOrderList=skuSaleOrderMap.values();
            //skuSalesOrderList
            for(SKUDetails skuWrapObj:skuSalesOrderList){
             system.debug('skuWrapObj.finalPrice---x-->'+skuWrapObj.finalPrice);
                if(String.isNotBlank(skuWrapObj.soliId)){
               
                 if(skuWrapObj.finalPrice==''){
                     skuWrapObj.finalPrice='0';
                 }
                  
                   
                    soliObj.Id = skuWrapObj.soliId;
                    system.debug('soliObj.Id--->'+soliObj.Id);
                   
                     Decimal value1=Decimal.valueof(skuWrapObj.finalprice.replace(',','.'));
                     Decimal value2 =skuWrapObj.minPrice;     
                     Decimal diff=0 ;Decimal avrg =0;Decimal divResult=0;Decimal per=0;
                    diff = math.abs(value1-value2);
                    //=100-((E3/B3)*100)
                    avrg = (value1 + value2)/2;
                    divResult = diff/avrg;
                    per =100-((value1 / value2)*100); // divResult * 100;
                    Decimal rounded = per.setScale(2);
                    system.debug(rounded);
                    per = rounded;
                    
                     // if(per<=8 && per>=0 ){
                   if(per<=8.31 && per>=16.60 ){
                    // TRUE when If Final Price <= 0% to 8% Of Minimum Price
                     system.debug('TRUE when If Final Price <= 0% to 8% Of Minimum Price');
                         Sent_for_Manager_Approval = true;
                    }
                     //if(per>=8.01 && per<=16 ){
                    if(per>=16.61 && per<=24.91 ){
                    // TRUE when If Final Price <= 8.01% to 16% Of Minimum Price
                     system.debug('TRUE when If Final Price <= 8.01% to 16% Of Minimum Price');
                      Sent_for_Manager_Approval = true;
                      Sent_for_Director_Approval= true;
                    }
                   //if(per>=16.01 ){
                    if(per>=24.92 ){
                    //TRUE when If Final Price <= 16.01% Of Minimum Price and Above
                     system.debug('TRUE when If Final Price <= 16.01% Of Minimum Price and Above');
                      Sent_for_Manager_Approval = true;
                      Sent_for_Director_Approval= true;
                      Sent_for_Latam_Director_Approval = true;
                    }
                    system.debug('skuWrapObj.finalPrice ------>'+skuWrapObj.finalPrice );
                    system.debug('skuWrapObj.floorPrice------>'+skuWrapObj.floorPrice);
                    
                    if(Decimal.valueof(skuWrapObj.finalprice.replace(',','.'))<=skuWrapObj.floorPrice ){
                    //TRUE when Final Price <= Floor Price
                    system.debug('TRUE when Final Price is less than Min Price');
                      Sent_for_Manager_Approval = true;
                      Sent_for_Director_Approval= true;
                      Sent_for_Latam_Director_Approval = true;
                      
                    } 
                     
                    
                }
                
                
                    
               
                soliObj.Quantity__c = skuWrapObj.qty;
                soliObj.Net_Price__c = Decimal.valueof(skuWrapObj.finalprice.replace(',','.'));
                    soliObj.Price__c = skuWrapObj.netRateEntered;
                soliObj.FinalPrice__c= Decimal.valueof(skuWrapObj.finalprice.replace(',','.'));
                
                system.debug('soliObj==>'+soliObj);
                upsert soliObj;
              
                System.debug('updated'+soliObj);
                System.debug('finalPrice'+ skuWrapObj.finalPrice);
                System.debug('qty'+ soliObj.Quantity__c);
                System.debug('skuWrapObj.netRateEntered'+ skuWrapObj.netRateEntered);
                 if(skuWrapObj.finalPrice=='' ||skuWrapObj.qty==0 ||skuWrapObj.finalPrice=='0' ){
                        showError = true;
                       orderSaved =false;
                       //refreshSaleOrderValue();
                       
                       // errorMessage = System.Label.Please_enter_Quantity_Final_Price;
                       // break;
                    }else{
                    skuSaleOrderMap.put(skuWrapObj.skuId,skuWrapObj);
                }
                
            }
            
            refreshSaleOrderValue();
        }
        catch(Exception ex){
            
            // ApexLog.exceptionHandler(ex, orderId, accountId);
            System.debug('Method: Constructor Exception: '+ex.getMessage()+ ' Line Number: '+ex.getLineNumber());
            ApexLog.exceptionHandlerForSalesOrder(ex, salesOrderId, accountId); 
        }            
             
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
            
             if(!skuSalesOrderList.isEmpty() && showError==false){
                orderSaved = true;
            }
            else if(showError==false){
                showError = true;
                errorMessage = System.Label.Please_add_product_to_cart;
                //'Please add product to cart';
            }
            if(Remaks.length()>200){
               showError = true;
                errorMessage = 'Limit Exceeded Please enter upto 200 characters only';
            }
        }
        catch(Exception ex){
            ApexLog.exceptionHandler(ex, orderId, accountId);
            
        }
    }
    
    //Method to  Validate & Confirm Order, disable Input, Submit for approval if conditions met
    public void confirmOrder(){
        try{
        system.debug('confirmOrder called..');
            ApexLog.exceptionCoverage(throwEx);
            
            if(Test.isRunningTest()){
                valuefromJS='Order Confirmed';
            }
               for(SKUDetails skuWrapObj:skuSaleOrderMap.values()){
                    
                    if(skuWrapObj.finalPrice=='0'){
                        showError = true;
                        errorMessage = System.Label.Please_Enter_Final_Price_for_all_SKU_s_before_confirming_order;
                        //'Please Enter Quantity for all SKU\'s before confirming order'; 
                        orderSaved = false;
                        break;
                    }
                    if(skuWrapObj.qty==0){
                        showError = true;
                        errorMessage = System.Label.Please_Enter_Quantity_for_all_SKU_s_before_confirming_order;
                        orderSaved = false;
                        //'Please Enter Quantity for all SKU\'s before confirming order'; 
                        break;
                    }
                }
            
            if(valuefromJS=='Order Confirmed'){
                  
                  saveOrder();
                  updateSKU();
                
                if(orderSaved == true){
                    //showError = false;
                    
                    
                    if(orderSaved == True && showError==false){
                        ordObj.Order_Status__c = 'Approved';
                        upsert ordObj;
                        
                        showError = true;
                       
                        //checking charracter of Remark__c field
                        
                        
                      
                        
                        system.debug(SalesOrderID);
                        
                        List<Sales_order__c> salesOrderName = [select ID,Inco_Term__c ,Payment_Term__c,CurrencyIsoCode,PaymentMethod__c,Name,Price_Entry_Flag__c FROM Sales_order__c where Id =:salesOrderId];
                          system.debug('SORDER---> '+salesOrderName );
                       integer numericCounter = 0;
                      List<Sales_Order_Line_Item__c> soitemlistforautonum  = [SELECT Id,Item_Number__c,Order_Item_Key__c FROM Sales_Order_Line_Item__c WHERE Sale_Order__c=:salesOrderId];
                      for(Sales_Order_Line_Item__c soitemss :soitemlistforautonum){
                          numericCounter =numericCounter +10;
                          soitemss.Item_Number__c = numericCounter;
                          soitemss.Order_Item_Key__c =SalesorderCombinationKey+numericCounter;
                      }  
                      if(soitemlistforautonum.size()>0){
                         system.debug('soitemlistforautonum----->'+soitemlistforautonum);
                          update soitemlistforautonum;
                      }
                        
                        for(Sales_Order__c SORDER : salesOrderName){
                     
                        SORDER.Sent_for_Manager_Approval_Mexico__c= Sent_for_Manager_Approval;
                        SORDER.Sent_for_Director_Approval_Mexico__c = Sent_for_Director_Approval;
                        SORDER.Sent_for_Latam_Director_Approval__c = Sent_for_Latam_Director_Approval;
                        SORDER.Order_Status__c = 'Pending';
                       if(String.isnotblank(Remaks)){
                        SORDER.Remarks__c=Remaks;
                       
                       }
                         
                        soObj = SORDER;
                        
                        system.debug('SORDER---> '+SORDER);
                        //CurrencyIsoCode 
                        //Payment_Term__c, PaymentMethod__c,Inco_Term__c 
                            if(salesOrderName.size()>1){
                                errorMessage = errorMessage +' '+SORDER.Name+',';
                            }else{
                                errorMessage = errorMessage +' '+SORDER.Name;
                            }
                            
                              errorMessage = 'Sales Order ('+SORDER.Name+') edited successfully';
                            
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
            
            system.debug('Payment Term inside saveTemplate method-----: '+Payment_Terms);
            system.debug('CurrencyIsoCode  inside saveTemplate method-----: '+SelectedCurrency);
            system.debug('Inco_Terms inside saveTemplate method-----: '+Inco_Terms);
            system.debug('InsertedOrderTemplate Id..- '+ otObj.Id);
            system.debug('skuOrderList..- '+ skuSalesOrderList);
            
            
            for(SKUDetails skuObj:skuSalesOrderList){
             system.debug('Inside forloop..- ');
                OrderTemplateItem__c otiObj = new OrderTemplateItem__c();
                /*otiObj.Name = skuObj.skuCode;
                otiObj.SKU__c = skuObj.skuId;
                otiObj.OrderTemplate__c = otObj.Id;*/
                
                otiObj.Name = skuObj.skuCode;
                otiObj.SKU__c = skuObj.skuId;
                otiObj.MinPrice__c =skuObj.minprice;
                otiObj.MaxPrice__c = skuObj.maxprice;
                otiObj.FinalPrice__c =Decimal.valueof(skuObj.finalprice.replace(',','.'));
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
            
            oliList2 = [SELECT Id, Sale_Order__r.Name, Quantity__c,Order_Item_Key__c , Sale_Order__r.Status__c, 
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
                skuWrapObj.brandName = oliObj.SKU__r.Product_Name__r.Name+' '+oliObj.SKU__r.Name;
                skuWrapObj.Price = skuWrapObj2.Price;
                //skuWrapObj.minPrice = skuWrapObj2.minPrice;
                skuWrapObj.netRateEntered = 0;   //skuWrapObj.Price;
                skuWrapObj.qty = 0;
                skuWrapObj.UOM = oliObj.SKU__r.UOM__c;
                skuWrapObj.available = skuWrapObj2.available;
                skuWrapObj.available2 = skuWrapObj2.available2;
                skuWrapObj.packsize = skuWrapObj2.packsize;
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
            SKUDetails skuWrapObj2 = skuDetailsMap.get(skuIdChosen);
            system.debug('skuWrapObj2'+skuWrapObj2);
            ApexLog.exceptionCoverage(throwEx);
            system.debug('skuWrapObj2.netRateEntered--->'+skuWrapObj2.netRateEntered);
            if(skuWrapObj2.netRateEntered>0 || Test.isRunningTest()){
            
                skuSalesOrderList.clear();
                SKUDetails skuWrapObj;
                Sales_Order_Line_Item__c soliObj = new Sales_Order_Line_Item__c();
                
                if(skuSaleOrderMap.containsKey(skuIdChosen)){
                 system.debug('Inside If..');
                    system.debug('conains id');
                    skuWrapObj = skuSaleOrderMap.get(skuIdChosen);
                   system.debug('Inside skuWrapObj ..');
                   
                    if(String.isBlank(skuWrapObj2.finalprice)){
                    showError = true;
                    errorMessage = System.Label.Please_enter_Quantity_Final_Price;
                    // break;
               
                }
                   
                    skuWrapObj.finalPrice = skuWrapObj2.finalPrice;
                    Decimal amnt=Integer.valueof(skuWrapObj.finalPrice);
                   
                    
                    /* if(PriceEntry.equals('Pre-uploaded')){
                            skuWrapObj.finalPrice = skuWrapObj2.Price; 
                    }*/
                    
                    skuWrapObj.qty += skuWrapObj2.qty;
                    skuWrapObj.netRateEntered = skuWrapObj.qty * amnt;                                         //skuWrapObj2.netRateEntered;
                    skuWrapObj.priceEntered = skuWrapObj.netRateEntered*skuWrapObj.qty;
                  
                    system.debug('skuWrapObj.finalPrice'+skuWrapObj);
                    if(String.isNotBlank(skuWrapObj.soliId)){
                        soliObj.Id = skuWrapObj.soliId;
                    }
                    skuWrapObj.brandName = skuWrapObj2.brandName;
                    soliObj.MaxPrice__c = skuWrapObj2.maxPrice;
                    soliObj.MinPrice__c = skuWrapObj2.minPrice ;
                    soliObj.Quantity__c = skuWrapObj.qty;
                    soliObj.Price__c = skuWrapObj.netRateEntered;     //skuWrapObj.maxPrice;  by Nikhil
                    soliObj.Net_Price__c= amnt;  //skuWrapObj.finalPrice;   //skuWrapObj.netRateEntered;  by Nikhil
                    
                    Decimal value1=Decimal.valueof(skuWrapObj.finalprice.replace(',','.'));Decimal value2 =skuWrapObj.minPrice;     
                    Decimal diff=0 ;Decimal avrg =0;Decimal divResult=0;Decimal per=0;
                    diff = math.abs(value1-value2);
                    //=100-((E3/B3)*100)
                    avrg = (value1 + value2)/2;
                    divResult = diff/avrg;
                    per =100-((value1 / value2)*100); // divResult * 100;
                    Decimal rounded = per.setScale(2);
                    system.debug(rounded);
                    per = rounded;
                    
                    if(per<=8 && per>=0 ){
                    // TRUE when If Final Price <= 0% to 8% Of Minimum Price
                     system.debug('TRUE when If Final Price <= 0% to 8% Of Minimum Price');
                         Sent_for_Manager_Approval = true;
                    }
                    if(per>=8.01 && per<=16 ){
                    // TRUE when If Final Price <= 8.01% to 16% Of Minimum Price
                     system.debug('TRUE when If Final Price <= 8.01% to 16% Of Minimum Price');
                      Sent_for_Manager_Approval = true;
                      Sent_for_Director_Approval= true;
                    }
                    if(per>=16.01 ){
                    //TRUE when If Final Price <= 16.01% Of Minimum Price and Above
                     system.debug('TRUE when If Final Price <= 16.01% Of Minimum Price and Above');
                      Sent_for_Manager_Approval = true;
                      Sent_for_Director_Approval= true;
                      Sent_for_Latam_Director_Approval = true;
                    }
                    system.debug('skuWrapObj.finalPrice ------>'+skuWrapObj.finalPrice );
                    system.debug('skuWrapObj.floorPrice------>'+skuWrapObj.floorPrice);
                    
                    if(Decimal.valueof(skuWrapObj.finalprice.replace(',','.'))<=skuWrapObj.floorPrice ){
                    //TRUE when Final Price <= Floor Price
                    system.debug('TRUE when Final Price is less than Min Price');
                      Sent_for_Manager_Approval = true;
                      Sent_for_Director_Approval= true;
                      Sent_for_Latam_Director_Approval = true;
                      
                    }
                   upsert soliObj;
                }
                else{
                system.debug('Inside Else 1st..');
                    List<Sales_Order_Line_Item__c> soliList=[select Id,Order_Item_Key__c ,Item_Number__c from Sales_Order_Line_Item__c where Sale_Order__c=:salesOrderId];
                    if(soliList.size()>0){
                        Integer sizeOfSolList=soliList.size();
                        Integer itemNo=(Integer)soliList[sizeOfSolList-1].Item_Number__c;
                        itemNumber=itemNo;                        
                    }
                    else{
                        itemNumber=0;
                    }
                     if(String.isBlank(skuWrapObj2.finalprice)){
                    showError = true;
                    errorMessage = System.Label.Please_enter_Quantity_Final_Price;
                    // break;
               
                }
                    skuWrapObj = new SKUDetails();
                    skuWrapObj.productName = skuWrapObj2.productName;
                    skuWrapObj.skuCode = skuWrapObj2.skuCode;
                    skuWrapObj.skuId = skuWrapObj2.skuId;
                    skuWrapObj.brandName = skuWrapObj2.brandName;
                    
                    soliObj.MaxPrice__c = skuWrapObj2.maxPrice;     
                    soliObj.MinPrice__c = skuWrapObj2.minPrice ;
                    soliObj.multipleOf__c = skuWrapObj2.multipleof;
                    soliObj.FinalPrice__c = Decimal.valueof(skuWrapObj2.finalprice.replace(',','.'));    // by Nikhil..
                    soliObj.Net_Price__c= Decimal.valueof(skuWrapObj2.finalprice.replace(',','.'));           // by Nikhil..
                    
                    soliObj.SKU_Name__c = skuWrapObj.skuId;
                    soliObj.DepotDepot__c = TurkeyDepo; 
                    soliObj.UOM__c = skuWrapObj.UOM;
                   
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
                    skuWrapObj.floorPrice= skuWrapObj2.floorPrice;
                    soliObj.Sale_Order__c = salesOrderId;
                    skuWrapObj.netRateEntered= skuWrapObj2.netRateEntered;
                    itemNumber = itemNumber+10;
                    skuWrapObj.itemNo = itemNumber;
                    soliObj.Item_Number__c = itemNumber;
                    soliObj.CurrencyIsoCode = skuWrapObj2.currencyIso;
                    soliObj.Quantity__c = skuWrapObj2.qty;
                    Decimal value1=Decimal.valueof(skuWrapObj2.finalprice.replace(',','.'));Decimal value2 =skuWrapObj.minPrice;     
                    Decimal diff=0 ;Decimal avrg =0;Decimal divResult=0;Decimal per=0;
                    diff = math.abs(value1-value2);
                    //=100-((E3/B3)*100)
                    avrg = (value1 + value2)/2;
                    divResult = diff/avrg;
                    per =100-((value1 / value2)*100); // divResult * 100;
                    Decimal rounded = per.setScale(2);
                    system.debug(rounded);
                    per = rounded;
                    
                    if(per<=8 && per>=0 ){
                    // TRUE when If Final Price <= 0% to 8% Of Minimum Price
                     system.debug('TRUE when If Final Price <= 0% to 8% Of Minimum Price');
                         Sent_for_Manager_Approval = true;
                    }
                    if(per>=8.01 && per<=16 ){
                    // TRUE when If Final Price <= 8.01% to 16% Of Minimum Price
                     system.debug('TRUE when If Final Price <= 8.01% to 16% Of Minimum Price');
                      Sent_for_Manager_Approval = true;
                      Sent_for_Director_Approval= true;
                    }
                    if(per>=16.01 ){
                    //TRUE when If Final Price <= 16.01% Of Minimum Price and Above
                     system.debug('TRUE when If Final Price <= 16.01% Of Minimum Price and Above');
                      Sent_for_Manager_Approval = true;
                      Sent_for_Director_Approval= true;
                      Sent_for_Latam_Director_Approval = true;
                    }
                    system.debug('skuWrapObj.finalPrice ------>'+skuWrapObj.finalPrice );
                    system.debug('skuWrapObj.floorPrice------>'+skuWrapObj.floorPrice);
                    
                    if(Decimal.valueof(skuWrapObj.finalprice.replace(',','.'))<=skuWrapObj.floorPrice ){
                    //TRUE when Final Price <= Floor Price
                    system.debug('TRUE when Final Price is less than Min Price');
                      Sent_for_Manager_Approval = true;
                      Sent_for_Director_Approval= true;
                      Sent_for_Latam_Director_Approval = true;
                      
                    }
                    insert soliObj;
                    skuWrapObj.soliId = soliObj.Id;
                    system.debug('skuWrapObj-*****-'+skuWrapObj);
                }
                
                system.debug('SalesOrderId----->'+SalesOrderId);
                    
                    
                
                skuSaleOrderMap.put(skuWrapObj2.skuId,skuWrapObj);
                // skuSalesOrderList.clear();
                skuSalesOrderList.addAll(skuSaleOrderMap.values());
                refreshSaleOrderValue();
                showError = false;
            }
            else if((skuWrapObj2.netRateEntered==0 && skuWrapObj2.finalprice!='' && skuWrapObj2.qty!=0)){
                    //skuSalesOrderList.clear();
                    system.debug('Inside else If..');
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
                       
                        soliObj.Quantity__c = skuWrapObj2.qty;
                        soliObj.Price__c = 0;//skuWrapObj.priceEntered;
                        soliObj.Net_Price__c= 0;// skuWrapObj.netRateEntered;
                        upsert soliObj;
                    }
                    else{
                    
                    system.debug('Inside else if ifElse..');
                        List<Sales_Order_Line_Item__c> soliList=[select Id,Order_Item_Key__c ,Item_Number__c from Sales_Order_Line_Item__c where Sale_Order__c=:salesOrderId];
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
                        skuWrapObj.finalPrice =skuWrapObj2.finalPrice;
                        skuWrapObj.Director_Price =skuWrapObj2.Director_Price ;
                        skuWrapObj.Manager_Price=skuWrapObj2.Manager_Price;
                        soliObj.Sale_Order__c = salesOrderId;
                    
                     /*if(skuWrapObj.finalPrice<skuWrapObj.minPrice || skuWrapObj.finalPrice>skuWrapObj.maxPrice){
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
                    }*/
                    
                    
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
                        //soliObj.FinalPrice__c = 0;//skuWrapObj.finalPrice;
                        //skuWrapObj.netRateEntered = 0;//skuWrapObj2.netRateEntered;
                        itemNumber = itemNumber+10;
                        skuWrapObj.itemNo = itemNumber;
                        soliObj.Item_Number__c = itemNumber;
                        soliObj.CurrencyIsoCode = SelectedCurrency;
                        soliObj.Quantity__c = skuWrapObj2.qty;
                        soliObj.Price__c = skuWrapObj2.netRateEntered;   //added by Nikhil
                        system.debug('skuWrapObj2.finalprice'+skuWrapObj2.finalprice);
                        soliObj.Net_Price__c= Decimal.valueof(skuWrapObj2.finalprice.replace(',','.'));  //skuWrapObj.finalPrice; //added by Nikhil
                       // soliObj.Price__c =0;  //added by Nikhil
                       // soliObj.Net_Price__c= 0;  //added by Nikhil
                        insert soliObj;
                        skuWrapObj.soliId = soliObj.Id;
                    }
                    
                    skuSaleOrderMap.put(skuWrapObj2.skuId,skuWrapObj);
                    skuSalesOrderList.clear();
                    skuSalesOrderList.addAll(skuSaleOrderMap.values());
                    refreshSaleOrderValue();
                    showError = false;
                }
            else{
                system.debug('inside else');
                errorMessage = System.Label.Please_enter_Quantity_Final_Price;
                //'Please enter Quantity & Final Price';
                showError = true;
            }
        }
        catch(Exception ex){
            system.debug('catch data found');
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
        public String finalPrice {get;set;}
        public Integer itemNo {get;set;}
        public Integer perUnit {get;set;}
        public Decimal available {get;set;}
        public Decimal priceEntered {get;set;}
        public Decimal campaignDiscountPercent {get;set;}
        public Decimal packsize{get;set;}
        public String available2 {get;set;}
        public String currencyIso {get;set;}
        public Decimal floorPrice{get;set;}
        public SKUDetails(){
            UOM = 'N/A';
            qty = 0;
            //minPrice = 0;
            Director_Price=0;
            Manager_Price=0;
            price = 0;
            packsize=0;
            finalPrice = '0';
            netRateEntered = 0;
            maxPrice =0;
            minPrice =0;
            available = 0;
            floorPrice=0;
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
        public String Name {get;set;}
        public String locationId {get;set;}
        public String LocationName {get;set;}
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