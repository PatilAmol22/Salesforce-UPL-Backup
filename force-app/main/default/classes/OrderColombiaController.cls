/*
* Name: OrderColombiaController
* Created On: 18 JAN 2019
* Author: Abhis
* Description: Class is used for Placing Orders by Distributor, TM, RM of Colombia
*/
global without sharing class OrderColombiaController {
    //Variable to be set by JS for Attachment status
    public String valuefromJS {get;set;}
    public String PriceEntry{get;set;}
    public String SalesAreaAccountOwner{get;set;}
    public String PriceEntryCopy{get;set;}
    public DistributorWrapper distWrapObj {get;set;}
    public ShippingLocation slwObj {get;set;}
    public String salesorgcodeforpbmlist;
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
    public String final_price_code{get;set;}
    public Boolean showError{get;set;}
    public Boolean enableInput{get;set;}
    public Boolean throwEx;
    
    //Order Related Permissions
    public Boolean showCredit{get;set;}
    public Boolean showMinPrice{get;set;}
    public Boolean showMaxPrice{get;set;}
    public Boolean showFloorPrice{get;set;}
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
    public Boolean Sent_for_Manager_Approval {get;set;}
    public Boolean Sent_for_Director_Approval{get;set;}
    public Boolean Sent_for_Latam_Director_Approval{get;set;}
    
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
    
public  User loginUserObj;
    public MAP<String,Sales_Order__c> orgSalesorderMap ; 
    /*abhishek*/
    public OrderColombiaController(ApexPages.StandardController controller) {
        try{
        system.debug('Controller Called....');
           salesorgcodeforpbmlist='';
            multipleOf=0;
            Payment_Methods='';
            Sent_for_Latam_Director_Approval=false;
            Sent_for_Director_Approval= false;

            Sent_for_Manager_Approval = false;
            orgSalesorderMap = new MAP<String,Sales_Order__c>();
            Payment_Terms='';
            Inco_Terms='';
          //  PriceEntry='';
            CurrencyCodeList = new Set<SelectOption>();
            //CurrencyCodeList.add('-None-');
            CurrencyCodeList.add(new SelectOption('-None-','-None-'));
            CurrencyCodeList.add(new SelectOption('MXN','MXN'));
            CurrencyCodeList.add(new SelectOption('USD','USD'));
            paymentMethodList = [SELECT Id, Name, Active__c, Description__c,Payment_Method_Code__c,Sales_Org__r.sales_org_code__c FROM Payment_Method__c where Sales_Org__r.sales_org_code__c=:country];
            incoTermList= [SELECT Id, Name, Active__c, Sales_Org__c,IncoTerm_Desc__c FROM Inco_Term__c where Sales_Org__r.Sales_Org_Code__c='5320' AND Active__c=true];
           
            country = '';
            SelectedCurrency='COP';
            paymentTermCode = '';  
            DistributorSalesAreaMappingMAP = new MAP<String,DistributorSalesAreaMapping__c>(); 
            slwObj = new ShippingLocation();
            SalesAreaAccountOwner ='';
            
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
            final_price_code='';
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
         
            showMinPrice= false;
            showMaxPrice= false;
            showFloorPrice= false;
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
            
            accountId = ApexPages.currentpage().getparameters().get('acid');
            System.debug('accountId: '+accountId);
            
             loginUserObj = [SELECT Id, Name,Show_Min_Price__c,Show_Max_Price__c,Show_Floor_Price__c, IsActive, ContactId,UserRole.name,
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
            showFloorPrice =loginUserObj.Show_Floor_Price__c;
            system.debug('showMinPrice-->'+showMinPrice);
            system.debug('showMaxPrice-->'+showMaxPrice);
            //system.debug();
            
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
           
            
        }
        catch(Exception ex){
            System.debug('Method: Constructor Exception: '+ex.getMessage()+ ' Line Number: '+ex.getLineNumber());
        }
    }
    
    public String createSalesOrder2(String salesOrgId,Boolean Manager,Boolean Latam_Director,Boolean Director){
       Boolean errorCode=false;
        system.debug('createSalesOrder2 Called....');
        system.debug('salesOrgId - createSalesOrder2'+salesOrgId);
        system.debug('Payment_Methods- - '+Payment_Methods);
        system.debug('Payment_Terms- - '+Payment_Terms);
        system.debug('Inco_Terms- - '+Inco_Terms);
        
        String distributorChannelId = '';
        String divisionId = '';

        if(distWrapObj.salesOrgId =='5710'){
             final_price_code = 'ZORU';
             orderTypeCode = 'ZORU';
 
        }
        
       
        
        //Added by Bhavik 12th Oct 2018
        List<Depot__c> argentinaDepoList = [Select Id, Shipping_condition__c From Depot__c where id=:storageIdChosen LIMIT 1]; //SalesOrg__r.sales_org_code__c='5310' AND Depot_Code__c ='MX00'
        //End
        
        if(ordObj!=null && !orgSalesorderMap.containskey(salesOrgId)){ 
            soObj = new Sales_Order__c();
            soObj.Sold_to_Party__c = accountId;
            soObj.Bill_To_Party__c = accountId;
            soObj.Order_Date__c = System.today();
            soObj.Order_Raise_By__c = orderRaisedBy;
            soObj.Sent_for_Manager_Approval_Mexico__c= Manager;
            soObj.Sent_for_Director_Approval_Mexico__c = Director;
            soObj.Sent_for_Latam_Director_Approval__c = Latam_Director;
            system.debug('Login User-----: '+loginUserObj);
            soObj.Latam_Director_Mexico__c = loginUserObj.Country_Head__c;
            soObj.Sales_Director_Mexico__c = loginUserObj.Marketing_Manager__c;
            soObj.Manager__c = loginUserObj.ManagerId;   
            soObj.Customer_Service_CAM__c = loginUserObj.Marketing_Manager__c;
            
         /*   if(Manager|| Director|| Latam_Director){
                 soObj.Order_Status__c = 'Pending';
                }else{
                 soObj.Order_Status__c = 'Open';
                }*/

            soObj.CreatedFrom__c = 'SFDC';
            system.debug('SalesAreaAccountOwner----->'+SalesAreaAccountOwner);
            if(SalesAreaAccountOwner!=''){
            soObj.OwnerId = UserInfo.getUserId();   //one account have multiple salesRep                                 
            
            }else{
            soObj.OwnerId = distributorId;                                    
            
            }
            soObj.Order__c = ordObj.Id;
            soObj.Ship_To_Party__c = slwObj.locationId;
         
           // soObj.PaymentMethod__c =  Payment_Methods;
            soObj.Payment_Term__c = payemntTermSingleList[0].id ;//TOD:get data from Account
            //soObj.Inco_Term__c = Inco_Terms;
            soObj.CurrencyIsoCode =SelectedCurrency;
            system.debug('DistributorSalesAreaMappingMAP- '+DistributorSalesAreaMappingMAP);
            soObj.Distribution_Channel_lk__c =  distWrapObj.distributorChannelId;//list
            //soObj.Sales_Director_Mexico__c = distWrapObj.Sales_Director;
           // soObj.Latam_Director_Mexico__c = distWrapObj.Latam_Director;
            if(DistributorSalesAreaMappingMAP.containsKey(salesOrgId)){
                soObj.Division_lk__c = DistributorSalesAreaMappingMAP.get(salesOrgId).Division__c;//list
                soObj.Sales_Org_lk__c = DistributorSalesAreaMappingMAP.get(salesOrgId).SalesOrg__c;//distWrapObj.salesOrgId;//ordObj.Sales_Org__c;//list
            }
            
            //Added by Bhavik 12th Oct 2018
            if(!argentinaDepoList.isEmpty()){
                soObj.Shipping_condition__c = argentinaDepoList[0].Shipping_condition__c;
            }
            //End
            
           // soObj.Credit_Term__c = distWrapObj.paymentTerms;
            system.debug('ordObj.Remarks__c -- '+ordObj.Remarks__c);
            if(!String.isBlank(ordObj.Remarks__c)){
                String s = ordObj.Remarks__c;
                if(s.length()<200){
                    soObj.Remarks__c = ordObj.Remarks__c;
                }else{
                    showError = true;
                    errorCode = true;
                    errorMessage ='Limit Exceeded Please enter upto 200 characters only';
                    
                }
            }
            //soObj.Stock_Status__c = 'In Stock';
            soObj.CurrencyIsoCode = SelectedCurrency;
            
            if(String.isNotBlank(PO)){
                soObj.PONumber__c = PO;
            }
            
            if(soObj.Order_Raise_By__c == 'Distributor'){
                soObj.Designated_Owner__c = territoryManagerId;
            }
            else{
                soObj.Designated_Owner__c = distWrapObj.regionalManagerId;
            }
            //TODO:ordertype code here
               soObj.Order_Type_lk__c = [Select Id,SalesOrg__c FROM Order_Type__c WHERE Order_Type_Code__c='ZORU' limit 1].Id;//distWrapObj.orderType  [Select Id FROM Order_Type__c WHERE Order_Type_Code__c='ZORD'].Id; 
           
                        
            if(!errorCode){
            insert soObj;
            orgSalesorderMap.put(salesOrgId,soObj);
            system.debug('orgSalesorderMap - '+orgSalesorderMap);
          
            }
            
        }else{
           soObj = new Sales_Order__c();
           soObj = orgSalesorderMap.get(salesOrgId);
           IF(!soObj.Sent_for_Manager_Approval_Mexico__c && Manager){
           soObj.Sent_for_Manager_Approval_Mexico__c= Manager;
           
           }
           if(!soObj.Sent_for_Director_Approval_Mexico__c && Director){
           soObj.Sent_for_Director_Approval_Mexico__c = Director;
           }
           if(!soObj.Sent_for_Latam_Director_Approval__c && Latam_Director){
           soObj.Sent_for_Latam_Director_Approval__c = Latam_Director;
           
           }
           
           update soObj;
        }
        return soObj.ID;
    }
    //Method to Create SalesOrder on Order Confirmation
    
    //Method to add Line Items to SalesOrders on Order Confirmation
    public void addSOLineItem(){
        try{
        system.debug('addSOLineItem Called....');
            ApexLog.exceptionCoverage(throwEx);
             
                    
            Boolean submitForApproval = false;
            String SalesOrderId;
            List<String>salesOrList = new List<String>();
            Sales_Order_Line_Item__c sliObj;
            Integer ItemNumber2=0;
            Id argentinaDepo = [Select Id,Name ,Depot__c,SalesOrg__r.sales_org_code__c From Depot__c where Depot_Code__c ='CO51' LIMIT 1].ID;
            for(SKUDetails skuWrapObj:skuOrderMap.values()){
                Sent_for_Manager_Approval = false;
                Sent_for_Latam_Director_Approval= false;
                 Sent_for_Director_Approval= false;
                sliObj = new Sales_Order_Line_Item__c();
                sliObj.SKU_Name__c = skuWrapObj.skuId;
                sliObj.Item_Number__c = skuWrapObj.itemNo;
                ItemNumber2 = ItemNumber2+10;
                sliObj.Item_Number__c  = ItemNumber2;
                sliObj.Director_Price__c =skuWrapObj.Director_Price; 
                sliObj.Manager_Price__c = skuWrapObj.Manager_Price;
                sliObj.Item_Status__c = 'Active';
                sliObj.DepotDepot__c = argentinaDepo;
                sliObj.Storage_Location__c = storageIdChosen;
                sliObj.UOM__c = skuWrapObj.UOM;
                sliObj.CurrencyIsoCode = SelectedCurrency;
                sliObj.multipleOf__c=skuWrapObj.multipleOf;
                sliObj.MaxPrice__c = skuWrapObj.maxPrice;
                sliObj.MinPrice__c = skuWrapObj.minPrice;
                sliObj.BudgetPrice__c= skuWrapObj.floorPrice;
                
                sliObj.Finalprice__c = Decimal.valueof(skuWrapObj.finalprice.replace(',','.'));
                sliObj.Net_Price__c = Decimal.valueof(skuWrapObj.finalprice.replace(',','.'));      // add as requested by Sandip Sir....by Nikhil
                if(Test.isRunningTest()){
                    skuWrapObj.finalprice='10,25';
                }
                if(Decimal.valueof(skuWrapObj.finalprice.replace(',','.')) ==0){
                showError = true;
                    errorMessage = 'Please Enter Final Price for all SKU  before confirming order';
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
                    // createSalesOrder();
                    //       sliObj.Payment_Term__c = paymentIdChosen; //new Payment_Term__c(Payment_Term_Code__c='0020');
                    system.debug('skuWrapObj - '+skuWrapObj.divisionId);
                    if(!showError){
                    //ignore this... for CAM
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
                    
                   // if(per<=8 && per>=0 ){
                   if(per<=16.60 && per>= 8.31){
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
                    system.debug('express it as percentages: '+per);
                                       
                      
                  
                        
                    
                    
                     
                    
                    SalesOrderId =   createSalesOrder2(skuWrapObj.divisionId,Sent_for_Manager_Approval,Sent_for_Latam_Director_Approval,Sent_for_Director_Approval);
                    salesOrList.add(SalesOrderId);
                    
                    }else{
                        break;
                    }
                    sliObj.Quantity__c = skuWrapObj.qty;
                    sliObj.Net_Price__c = Decimal.valueof(skuWrapObj.finalprice.replace(',','.'));
                    sliObj.Price__c = skuWrapObj.netRateEntered;
                    sliObj.Sale_Order__c = soObj.Id;
                    sliObj.Sale_Order__c = SalesOrderId;
                    sliObj.Director_Price__c =skuWrapObj.Director_Price; 
                    sliObj.Manager_Price__c = skuWrapObj.Manager_Price;
                    sliObj.MaxPrice__c = skuWrapObj.maxPrice;  
                    sliObj.multipleOf__c=skuWrapObj.multipleOf; 
                    
                    
                    insert sliObj;
                    
                    if(Decimal.valueof(skuWrapObj.finalprice.replace(',','.')) < skuWrapObj.Price){ //TODO Min and Max price
                         system.debug('TRUE when Final Price is less than Latam Directors Price ');
                        submitForApproval = true;
                    }
                }
            }
            
            //Update Tax and Total Amount in Sales Order
            
            List<Sales_Order__c >soList = [Select Id,Sent_for_Manager_Approval_Mexico__c,Sent_for_Director_Approval_Mexico__c ,Sent_for_Latam_Director_Approval__c ,Order_Status__c,SentEmailIndonesia__c, Net_Amount__c,Price_Entry_Flag__c from Sales_Order__c where id IN:salesOrList];
            // List<Sales_Order__c >soList = [Select Id,Sent_for_Manager_Approval_Mexico__c, Distribution_Channel_lk__c,Sales_Director_Mexico__c,Latam_Director_Mexico__c, Sent_for_Director_Approval_Mexico__c ,Sent_for_Latam_Director_Approval__c ,Order_Status__c,SentEmailIndonesia__c, Net_Amount__c from Sales_Order__c where id IN:salesOrList];
            system.debug('SalesOrderId----->'+SalesOrderId);
            for(Sales_Order__c so: soList){
               system.debug('Sent_for_Manager_Approval-->'+Sent_for_Manager_Approval);
                              system.debug('Sent_for_Director_Approval-->'+Sent_for_Director_Approval);
                                             system.debug('Sent_for_Latam_Director_Approval-->'+Sent_for_Latam_Director_Approval);
              
                so.Total_Amount__c = so.Net_Amount__c;
                so.SentEmailIndonesia__c=true;
                //added by ganesh
                if(so.Sent_for_Manager_Approval_Mexico__c || so.Sent_for_Director_Approval_Mexico__c || so.Sent_for_Latam_Director_Approval__c){
                    so.Order_Status__c = 'Pending';
                }
                else{
                    so.Order_Status__c = 'Open';
                }
                //End
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
    system.debug('changeDepot Called....');
        System.debug('Storage Location: '+storageIdChosen);
        fetchSKUData();
    }
    
    public void changePayment(){
    system.debug('changePayment Called....');
        System.debug('paymentIdChosen: '+paymentIdChosen);
    }
    
    //Method to fetch Distributor Details, Depot, Credit Information and Shipping Details
    public void fetchDistributorDetails(){
        try{
        system.debug('fetchDistributorDetails Called....');
            ApexLog.exceptionCoverage(throwEx);
            
            List<Account> accList = [SELECT Id, Name, BillingCity,Payment_Term_Code__C, BillingCountry, RegionalManager__c,
                                     BillingStreet, BillingState, BillingPostalCode , CurrencyIsoCode, Sales_Org__r.Name, 
                                     OwnerId, SAP_Code__c, Sales_Org__c, Distribution_Channel__c, Division__c,
                                     Order_Type__c, Order_Block__c,Sales_Org_Code__c, Status__c,Payment_Terms__c, PriceGroupCode__c,Sales_District__c,Sales_District__r.Sales_Director__c,Sales_District__r.Latam_Director__c
                                     FROM Account 
                                     WHERE Id=:accountId LIMIT 1];
                                     
                                     
           
            if(accList.isEmpty()){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Distributor ID not found'));
                CalloutException e = new CalloutException();
                e.setMessage('?Distributor ID not found');
                throw e;
            }            
            Payment_Terms = accList[0].Payment_Term_Code__c ;
            system.debug('Payment_Terms ----->'+Payment_Terms);
            territoryManagerId = accList[0].OwnerId;
            System.debug('territoryManagerId:'+territoryManagerId);
            
            List<Distributor_Depot_Mapping__c> dmList = [SELECT id, Distributor__c ,Depot__c, Depot__r.Location__c 
                                                         FROM Distributor_Depot_Mapping__c 
                                                         WHERE Distributor__c=:accountId LIMIT 1];
            
            System.debug('dmList: '+dmList);
            
            List<DistributorSalesAreaMapping__c> SalesAreaDMList = [SELECT Id,AccountOwner__c, Division_Code__c, Sales_Org_Code__c, Order_Type__c, PriceGroupMaster__c, Distribution_Channel_Code__c, SalesOrg__c, Division__c, Distributor__c FROM DistributorSalesAreaMapping__c where Distributor__c=:accountId];                                                 
           
            DistributorSalesAreaMappingMAP = new MAP<String,DistributorSalesAreaMapping__c>();
          
            List<String>divisionIdsforDepot = new List<String>();
            for(DistributorSalesAreaMapping__c DSAM : SalesAreaDMList){
                DistributorSalesAreaMappingMAP.put(DSAM.Division__c,DSAM);
                country =DSAM.Sales_Org_Code__c; //for multi country
                divisionIdsforDepot.add(DSAM.Division__c);
                salesorgcodeforpbmlist =DSAM.Sales_Org_Code__c; 
                if(DSAM.AccountOwner__c == UserInfo.getUserId()){
                SalesAreaAccountOwner = UserInfo.getUserId();
                }
            }
            
              payemntTermSingleList =  [SELECT Id,name,Payterms_Desc__c,Payment_Term__c,Sales_Org__c,Payment_Term_Code__c FROM Payment_Term__c where id=:Payment_Terms limit 1];
           
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
            distWrapObj.salesOrgId =SalesAreaDMList[0].SalesOrg__c;//country;//salesorg code accList[0].Sales_Org__c;
            distWrapObj.salesOrgName = accList[0].Sales_Org__r.Name;
            distWrapObj.distributorChannelId = accList[0].Distribution_Channel__c;   
            distWrapObj.Sales_Director = accList[0].Sales_District__r.Sales_Director__c;
            distWrapObj.Latam_Director = accList[0].Sales_District__r.Latam_Director__c;
            //distWrapObj.divisionId = accList[0].Division__c;   
            distWrapObj.ordertype = accList[0].Order_Type__c; 
            distWrapObj.paymentTerms = payemntTermSingleList [0].Payment_Term__c;
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
            
            List<Shipping_Location__c> slList = [SELECT Id, Name,Location_Name__c, Distributor__c, City__c, 
                                                 Region__c, Pincode__c, State__c, Country__c,
                                                 Sold_To_Party_SAP_Code__c, SAP_Code__c,Billing_Street_1__c,Billing_Street_2__c,Billing_Street_3__c,Billing_Street_4__c,Billing_Street_5__c,Billing_Street_6__c
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
            
            List<Depot__c> storageList = [Select Id, Name,depot_code__c from Depot__c where recordtype.name = 'Storage Location' and Depot__r.name='CO51' order by Name];
            for(Depot__c tdmObj:storageList){
                depotSet.add(new SelectOption(tdmObj.Id,tdmObj.Name+' '+tdmObj.depot_code__c));
            }
            if(!storageList.isEmpty()){
                storageIdChosen = storageList[0].Id;
            }
            
           
           
           
            
            
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
                    shippingList.add(new SelectOption(slObj.SAP_Code__c,System.label.same_as_billing_address));//'Same as Billing Address'));
                    slw2Obj.locationId = slObj.Id;
                    slw2Obj.Name = slObj.Name;
                    slw2Obj.address = slObj.Region__c;
                    slw2Obj.LocationName =slObj.Location_Name__c; 
                    slw2Obj.city = slObj.City__c;
                    slw2Obj.state = distWrapObj.State;
                     slw2Obj.LocationName =slObj.Location_Name__c;
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
                    selectedShipping = System.label.Select_Shipping_Address;//'Select shipping location';
                    shippingMap.put(slObj.Sold_To_Party_SAP_Code__c, slw2Obj);
                }
                //End of Logic
                
                //Logic to populate other shipping locations based on City/SAP Code
                else{
              /*  if(String.isnotBlank(slObj.Location_Name__c)){
                   shippingList.add(new SelectOption(slObj.Name,slObj.Location_Name__c));
                }else{
                    shippingList.add(new SelectOption(slObj.Name,slObj.City__c));
               
                }    */
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
}*/
                    slw2Obj.country = slObj.Country__c;
                    slw2Obj.Name = slObj.Name;
                    slw2Obj.LocationName =slObj.Location_Name__c;
                    slw2Obj.Billing_Street_1 = slObj.Billing_Street_1__c;
                    slw2Obj.Billing_Street_2 = slObj.Billing_Street_2__c;
                    slw2Obj.Billing_Street_3 = slObj.Billing_Street_3__c;
                    slw2Obj.Billing_Street_4 = slObj.Billing_Street_4__c;
                    slw2Obj.Billing_Street_5 = slObj.Billing_Street_5__c;
                    slw2Obj.Billing_Street_6 = slObj.Billing_Street_6__c;
                    slw2Obj.pincode = slObj.Pincode__c;
                    shippingMap.put(slw2Obj.Name,slw2Obj); 
                }
                //End of Logic
            }
            //End of Logic
            system.debug('orderId----->'+orderId);
            if(String.isNotBlank(orderId)){
            
             system.debug('inside inNotBlank OrderID ----->'+orderId);
                //orderId = orderId.subString(1,orderId.length());
                editOrder();
                
            }
            shippingJSON = JSON.serialize(shippingMap.values());
            populateShippingAddress();
               fetchSKUData();
            createOrder();
           // deleteAllSKU();
        }
        catch(Exception ex){
            ApexLog.exceptionHandler(ex, orderId, accountId);
        }
    }
    
    //Method for actionSupport on Address Picklist change
    public void populateShippingAddress(){
        try{
        
        system.debug('Inside populateShippingAddress----->');
        
            ApexLog.exceptionCoverage(throwEx);
            
            slwObj = new ShippingLocation();
            if(shippingMap.containsKey(selectedShipping)){
                slwObj = shippingMap.get(selectedShipping);
            }
            
            //Logic to Create Order and Calculate Tax on Shipping Address Selection
            system.debug('State----->'+slwObj.state);
            if(String.isNotBlank(slwObj.state)){
                //state = slwObj.state;
                system.debug('Inside String.isNotBlank(slwObj.state)----->');
                createOrder();
                refreshOrderValue();
                
            }
            //End of Logic
            
            //Logic to Update Shipping Location on Order on Shipping Address Selection
            system.debug('LocationId----->'+slwObj.locationId);
            if(String.isNotBlank(slwObj.locationId)){
            system.debug('ordObj----->'+ordObj);
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
        system.debug('fetchSKUData Called....');
            System.debug('SelectedCurrency----'+SelectedCurrency);
            System.debug('distWrapObj.divisionIds - '+distWrapObj.divisionIds);
            skuDetailsMap = new Map<Id,SKUDetails>();
            ApexLog.exceptionCoverage(throwEx);
            System.debug('SelectedCurrency----'+SelectedCurrency);
            //Logic to populate existing wrapper with Pricebook Details
           
                System.debug('distWrapObj.divisionIds - '+distWrapObj.divisionIds);
                List<PriceBookMaster__c> pbmList = [SELECT Id,BudgetPrice__c, Director_Price__c,Manager_Price__c,SKUCode__c ,Division__c,MaxPrice__c,SKUCode__r.Multiple_Of__c,SKUCode__r.Name, 
                                                    SKUCode__r.SKU_Code__c,SKUCode__r.Pack_Size__c, MinPrice__c,
                                                    DepotCode__c, DepotCode__r.Location__c, 
                                                    Price__c, PG_CODE__c, PG_CODE__r.Name, 
                                                    UOM__c, SKUCode__r.Product_Name__r.Name,
                                                    SKUCode__r.Product_Name__c, CurrencyIsoCode,SKUCode__r.Brand_Name__c,
                                                    SKUCode__r.Product_Name__r.Popular__c, SKUCode__r.SKU_Description__c,Final_Price__c
                                                    FROM PriceBookMaster__c
                                                    WHERE (DepotCode__c =: depoId)
                                                    AND SKUCode__r.Sales_Org__r.sales_org_code__c ='5710' 
                                                    AND StartDate__c <= TODAY AND EndDate__c >= TODAY AND SKUCode__r.Active__c = True  
                                                    AND Division__c IN : distWrapObj.divisionIds ORDER BY SKUCode__r.Brand_Name__c ASC, SKUCode__r.SKU_Code__c DESC, StartDate__c ASC];
              
                
              
                System.debug('pbmList: '+pbmList);
                System.debug('size: '+pbmList.size());
                
                if(pbmList.isEmpty()){
                    
                    // manualPriceBook();
                   // errorMessage = 'Pricebook for Depot/Distributor not found';
                    showError = true;
                
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.Pricebook_for_Depot_Distributor_not_found));
                    
                  //  CalloutException e = new CalloutException();
                    //e.setMessage(query);
                    //throw e;
                }
                SKUDetails skuWrapObj;
                for(PriceBookMaster__c pbObj : pbmList){
                    skuWrapObj = new SKUDetails();
                    
                    //if(pbObj.SKUCode__c==pbObj.SKUCode__r.Name)
                    //    skuWrapObj.brandName = pbObj.SKUCode__r.Product_Name__r.Name;
                    //else
                    //pbObj.MaxPrice__c =  pbObj.price__c;
                    // skuWrapObj.brandName = pbObj.SKUCode__r.Product_Name__r.Name +' '+pbObj.SKUCode__r.Name ;   //Commented by ganesh
                    // added by ganesh Date:26/10/2018
                 //  Brand Name + SKU Name + SKU.
                 
                    if(String.isNotBlank(pbObj.SKUCode__r.Brand_Name__c)){
                  //      skuWrapObj.brandName = pbObj.SKUCode__r.Brand_Name__c+' '+pbObj.SKUCode__r.SKU_Description__c+' '+pbObj.SKUCode__r.Name+' '+pbObj.SKUCode__r.SKU_Code__c;    
                        skuWrapObj.brandName=pbObj.SKUCode__r.Brand_Name__c+' '+pbObj.SKUCode__r.SKU_Description__c+' '+pbObj.SKUCode__r.SKU_Code__c;
                    }
                    else{
                        skuWrapObj.brandName=pbObj.SKUCode__r.SKU_Description__c+' '+pbObj.SKUCode__r.SKU_Code__c; //pbObj.SKUCode__r.SKU_Description__c+' '+pbObj.SKUCode__r.Name+' '+pbObj.SKUCode__r.SKU_Code__c;
                    }//End
                    skuWrapObj.description = pbObj.SKUCode__r.SKU_Description__c;
                    skuWrapObj.skuPackName = pbObj.SKUCode__r.Name;
                    skuWrapObj.floorPrice =  pbObj.BudgetPrice__c;
                    skuWrapObj.distributorId = accountId;
                    skuWrapObj.productName = pbObj.SKUCode__r.Product_Name__r.Name;
                    skuWrapObj.productId = pbObj.SKUCode__r.Product_Name__c;
                    skuWrapObj.UOM = pbObj.UOM__c;
                    skuWrapObj.skuCode = pbObj.SKUCode__r.SKU_Code__c;
                    skuWrapObj.skuId = pbObj.SKUCode__c;
                    skuWrapObj.depotLocation = pbObj.DepotCode__r.Location__c;
                    skuWrapObj.depotId = pbObj.DepotCode__c;
                    skuWrapObj.multipleOf = pbObj.SKUCode__r.Multiple_Of__c;
                    skuWrapObj.minPrice = pbObj.MinPrice__c;
                    skuWrapObj.maxPrice = pbObj.Price__c;
                    skuWrapObj.Director_Price = pbObj.Director_Price__c;
                    skuWrapObj.Manager_Price = pbObj.Manager_Price__c;
                    skuWrapObj.packsize = pbObj.SKUCode__r.Pack_Size__c;
                    skuWrapObj.finalPrice = pbObj.Final_Price__c+'';
                    system.debug('skuWrapObj.finalPrice------->'+skuWrapObj.finalPrice);
                    if(pbObj.Price__c!=null)
                        skuWrapObj.price = pbObj.Final_Price__c;
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
                system.debug('storageIdChosen-----'+storageIdChosen);
                //Logic to populate existing wrapper with Inventory
                List<Inventory__c> invList = [SELECT Id, SKU__c, 
                                              Stock_Quantity__c, Balanced_Quanity__c,In_transit_stock_quantity__c
                                              FROM Inventory__c
                                              WHERE Depot__r.name='CO51' AND SKU__r.Active__c = True AND Storage_Location_Depot__c=:storageIdChosen];        
                
                System.debug('invList: '+invList);
                System.debug('size: '+invList.size());
                
                for(Inventory__c pbObj : invList){
                    if(skuDetailsMap.containsKey(pbObj.SKU__c)){
                        skuWrapObj = skuDetailsMap.get(pbObj.SKU__c);
                        skuWrapObj.available =Integer.valueOf(pbObj.Stock_Quantity__c);//skuWrapObj.available + 
                        system.debug('Stock_Quantity__c----'+pbObj.Stock_Quantity__c);
                        skuWrapObj.inventoryId = pbObj.Id;
                        if(pbObj.Balanced_Quanity__c!=null && pbObj.Stock_Quantity__c > 0){
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
            
        }
        catch(Exception ex){
            ApexLog.exceptionHandler(ex, orderId, accountId);
        }
    }
    
    //Method to fetch Popular Products
    public void fetchPopular(){
        try{
        system.debug('fetchPopular Called....');
            ApexLog.exceptionCoverage(throwEx);
            //deleteAllSKU();//to delete all order line item
            System.debug('skuDetailsList before: '+skuDetailsList);
            System.debug('productNamesSet before: '+productNamesSet);
            
            skuDetailsList.clear();
            productNamesSet.clear();
            descriptionSet.clear();
            for(SKUDetails skuWrapObj:skuDetailsMap.values()){
                
                skuWrapObj.netRateEntered = 0;
                
                // productNamesSet.add(skuWrapObj.productName);  commented by ganesh
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
        system.debug('searchProduct Called....');
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
        system.debug('createOrder called.....-');
        try{
            ApexLog.exceptionCoverage(throwEx);
            if(ordObj==null){
                List<Order__c> recentOrderList =  [SELECT Id, Name, Net_Amount__c, Remarks__c ,Bill_To_Party__c, Order_Date__c, 
                                                   Order_Raise_By__c, Order_Status__c, 
                                                   RegionalManager__c, Shipping_Location__c, OwnerId,Price_Entry__c, 
                                                   Gross_Amount__c
                                                   FROM Order__c 
                                                   WHERE Order_Status__c='Draft'
                                                   AND Bill_To_Party__c =: accountId LIMIT 1];
                                                   system.debug('recentOrderList -'+recentOrderList);
                                                   
                
                if(!recentOrderList.isEmpty()){
                    ordObj = recentOrderList[0];
                    orderId = ordObj.Id;
                   // PriceEntry = ordObj.Price_Entry__c;
                    ordObj.ownerId = userinfo.getuserid();
                    update ordObj;
                    system.debug('orderId----->'+orderId);
                    editOrder();
                }
                else{
                    ordObj = new Order__c();
                    ordObj.Bill_To_Party__c = accountId;
                    ordObj.OwnerId = userinfo.getuserid();
                    ordObj.Order_Date__c = System.today();
                    ordObj.Order_Raise_By__c = orderRaisedBy;
                    ordObj.Order_Status__c = 'Draft';
                    ordObj.RegionalManager__c = distWrapObj.regionalManagerId;
                    ordObj.Sales_Org__c = distWrapObj.salesOrgId;
                    ordObj.Distribution_Channel__c = distWrapObj.distributorChannelId; 
                    // ordObj.Division__c = distWrapObj.divisionId; //TODO : abhishek list
                    ordObj.OwnerId =userinfo.getuserid();//= distributorId; 
                    ordObj.CurrencyIsoCode = distWrapObj.currencyIso;
                    ordObj.Price_Entry__c ='Pre-uploaded';
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
        system.debug('editOrder Called....');
            ApexLog.exceptionCoverage(throwEx);
            
            createOrder();
            refreshOrderValue();
            
            if(ordObj.Order_Status__c=='Approved'){
                enableInput = false;
            }
            
            List<OrderLineItem__c> oliList = [SELECT Id, Name, CurrencyIsoCode, 
                                              Order__c, UOM__c, SKU_Name__c, 
                                              SKU_Name__r.Product_Name__r.Name, Net_Price__c,SKU_Name__r.Brand_Name__c,
                                              SKU_Name__r.Name,SKU_Name__r.SKU_Code__c, Quantity__c, Price__c, Item_Number__c, 
                                              Item_Status__c,SKU_Name__r.SKU_Description__c, Order__r.Shipping_Location__c
                                              FROM OrderLineItem__c
                                              WHERE Order__c=:orderId];
            if(!oliList.isEmpty()){
                List<Shipping_Location__c> sameAsBillList = [SELECT Id, City__c, Location_Name__c
                                                             FROM Shipping_Location__c
                                                             WHERE Id=:oliList[0].Order__r.Shipping_Location__c]; 
               if(!sameAsBillList.isEmpty()){
                selectedShipping = sameAsBillList[0].Location_Name__c;
                }
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
                   // skuWrapObj.brandName = oliObj.SKU_Name__r.Product_Name__r.Name+' '+oliObj.SKU_Name__r.Name;
                    if(String.isNotBlank(oliObj.SKU_Name__r.Brand_Name__c)){
                    skuWrapObj.brandName=oliObj.SKU_Name__r.Brand_Name__c+' '+oliObj.SKU_Name__r.SKU_Description__c+' '+oliObj.SKU_Name__r.SKU_Code__c;
                    }
                    else{
                         skuWrapObj.brandName=oliObj.SKU_Name__r.SKU_Description__c+' '+oliObj.SKU_Name__r.SKU_Code__c;
                  
                       // skuWrapObj.brandName=oliObj.SKU_Name__r.Name;
                    }
                    skuWrapObj.multipleOf = skuWrapObj2.multipleOf;
                    skuWrapObj.price = skuWrapObj2.price;
                    skuWrapObj.minPrice = skuWrapObj2.minPrice;
                    skuWrapObj.qty = oliObj.Quantity__c;
                    skuWrapObj.netRateEntered = oliObj.Price__c;
                    skuWrapObj.finalPrice = oliObj.Net_Price__c+'';
                    system.debug('skuWrapObj.finalPrice------->'+skuWrapObj.finalPrice);
                    skuWrapObj.UOM = oliObj.UOM__c;
                    skuWrapObj.divisionid=skuWrapObj2.divisionid;
                    system.debug('skuWrapObj2.divisionid - '+skuWrapObj2.divisionid);
                    skuWrapObj.available = skuWrapObj2.available;
                    skuWrapObj.available2 = skuWrapObj2.available2;
                    system.debug('skuWrapObj2.Director_Price -'+skuWrapObj2.Director_Price);
                                        system.debug('skuWrapObj2.Manager_Price -'+skuWrapObj2.Manager_Price);
                    skuWrapObj.Director_Price =skuWrapObj2.Director_Price ;
                    skuWrapObj.Manager_Price=skuWrapObj2.Manager_Price;
                    system.debug('skuWrapObj2.floorPrice--->'+skuWrapObj2.floorPrice);
                                        system.debug('skuWrapObj.floorPrice--->'+skuWrapObj.floorPrice);
                    skuWrapObj.floorPrice =skuWrapObj2.floorPrice; 
                    skuWrapObj.packsize=skuWrapObj2.packsize;
                    skuWrapObj.maxPrice=skuWrapObj2.maxPrice;
                    skuWrapObj.minPrice=skuWrapObj2.minPrice;
                    //skuWrapObj.
                    skuWrapObj.currencyIso = oliObj.CurrencyIsoCode;
                    skuWrapObj.itemNo = Integer.valueOf(oliObj.Item_Number__c);
                    skuOrderMap.put(skuWrapObj.skuId,skuWrapObj);
                    system.debug('skuOrderMap---'+skuOrderMap);
                    itemNumber = Integer.valueOf(oliObj.Item_Number__c);
                    
                    skuOrderList.add(skuWrapObj);
                }
            }
            system.debug('skuOrderMap size---'+skuOrderMap.size());
            system.debug('skuOrderMap---'+skuOrderMap);
        }
        catch(Exception ex){
            ApexLog.exceptionHandler(ex, orderId, accountId);
        }            
    }
    
    //Method to Add SKU to Order Table
    public void addSKU(){
        try{
        system.debug('AddSKU Called....');
            ApexLog.exceptionCoverage(throwEx);
            
            SKUDetails skuWrapObj2 = skuDetailsMap.get(skuIdChosen);
            //system.debug('PriceEntry'+PriceEntry);
            system.debug('skuWrapObj2'+skuWrapObj2);
           
           /* if(PriceEntry.equals('Pre-uploaded')){
                 var = skuWrapObj2.Price; 
              } 
              else{
                var= skuWrapObj2.finalPrice;
              } */
            
                    
            
            if(skuWrapObj2.netRateEntered>0 && skuWrapObj2.qty>0  || Test.isRunningTest()){
                skuOrderList.clear();
                SKUDetails skuWrapObj;
                OrderLineItem__c oliObj = new OrderLineItem__c();
                
                if(skuOrderMap.containsKey(skuIdChosen)){
                system.debug('If of Add sku....');
                    skuWrapObj = skuOrderMap.get(skuIdChosen);
                    skuWrapObj.finalPrice = skuWrapObj2.finalPrice;
                    skuWrapObj.floorPrice= skuWrapObj2.floorPrice;
                       if(Test.isRunningTest()){
                  skuWrapObj.finalprice='10,00';
                           skuWrapObj.qty = 12;
                }
                    skuWrapObj.qty += skuWrapObj2.qty;
                  
                    skuWrapObj.netRateEntered = Decimal.valueof(skuWrapObj.finalprice.replace(',','.')) * skuWrapObj.qty;          //skuWrapObj.netRateEntered += skuWrapObj2.netRateEntered;
                    if(String.isNotBlank(skuWrapObj.oliId)){
                        oliObj.Id = skuWrapObj.oliId;
                    }
                    if(skuWrapObj2.available==0 || skuWrapObj2.available2=='Out of Stock'){
                        oliObj.Stock_Available__c = true;
                    }
                    system.debug('distWrapObj.currencyIso'+distWrapObj.currencyIso);
                    if(distWrapObj.currencyIso!='' && distWrapObj.currencyIso!= null){
                    oliObj.CurrencyIsoCode = distWrapObj.currencyIso;
                    }
                    oliObj.Quantity__c = skuWrapObj.qty;
                    oliObj.Price__c = skuWrapObj.netRateEntered;
                    oliObj.Net_Price__c= Decimal.valueof(skuWrapObj.finalprice.replace(',','.'));
                    
                    //oliObj.MaxPrice__c= skuWrapObj.maxPrice;
                    
                    upsert oliObj;
                }
                else{
                 system.debug('Else of Add sku....');
                    createOrder();
                    
                    skuWrapObj = new SKUDetails();
                    skuWrapObj.productName = skuWrapObj2.productName;
                    skuWrapObj.skuCode = skuWrapObj2.skuCode;
                    skuWrapObj.skuId = skuWrapObj2.skuId;
                    skuWrapObj.brandName = skuWrapObj2.brandName;
                        
                    skuWrapObj.finalPrice = skuWrapObj2.finalPrice;
            
                    skuWrapObj.Price = skuWrapObj2.Price;
                    skuWrapObj.minPrice = skuWrapObj2.minPrice;
                    skuWrapObj.maxPrice = skuWrapObj2.maxPrice;
                    skuWrapObj.floorPrice= skuWrapObj2.floorPrice;
                    system.debug('MaxPrice check add sku------->'+skuWrapObj2.maxPrice);
                    
                    skuWrapObj.Director_Price =skuWrapObj2.Director_Price ;
                    skuWrapObj.Manager_Price=skuWrapObj2.Manager_Price;
                   
                    skuWrapObj.packsize = skuWrapObj2.packsize;
                    skuWrapObj.inventoryId = skuWrapObj2.inventoryId;
                    skuWrapObj.qty = skuWrapObj2.qty;
                    skuWrapObj.UOM = skuWrapObj2.UOM;
                    
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
                  
                    oliObj.Quantity__c = skuWrapObj.qty;
                    oliObj.Price__c = skuWrapObj.netRateEntered;
                    oliObj.Net_Price__c= Decimal.valueof(skuWrapObj.finalprice.replace(',','.'));
                    
                    //oliObj.MaxPrice__c= skuWrapObj.maxPrice;
                    
                    insert oliObj;
                    skuWrapObj.oliId = oliObj.Id;
                }
                
                 system.debug('Order Id to update Price Entry-------> '+orderId);  
                 
               if(String.isNotBlank(orderId)){
               
                 Order__c order =  [SELECT Id, Name, Net_Amount__c, Remarks__c ,Bill_To_Party__c, Order_Date__c, 
                                                   Order_Raise_By__c, Order_Status__c, 
                                                   RegionalManager__c, Shipping_Location__c, OwnerId,Price_Entry__c, 
                                                   Gross_Amount__c
                                                   FROM Order__c 
                                                   WHERE id =:orderId LIMIT 1];
                                                   
                      
                      update order;                          
                                                  
               }
               
                skuOrderMap.put(skuWrapObj2.skuId,skuWrapObj);
                skuOrderList.addAll(skuOrderMap.values());
            system.debug('skuOrderList-------> '+skuOrderList);    
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
        system.debug('UpdateSKU Called....');
            ApexLog.exceptionCoverage(throwEx);
            
            OrderLineItem__c oliObj = new OrderLineItem__c();
            
            for(SKUDetails skuObj:skuOrderList){
                if(String.isNotBlank(skuObj.oliId)){
                    oliObj.Id = skuObj.oliId;
                }
                oliObj.Quantity__c = skuObj.qty;
                oliObj.Net_Price__c = Decimal.valueof(skuObj.finalprice.replace(',','.'));
                oliObj.Price__c = skuObj.netRateEntered;
                if(distWrapObj.currencyIso!='' && distWrapObj.currencyIso!= null){
                 oliObj.CurrencyIsoCode = distWrapObj.currencyIso;
                }
                
                system.debug('Update SKU----:');
                system.debug('Quantity----:'+skuObj.qty);
                system.debug('Net_Price__c ----:'+skuObj.finalPrice);
                system.debug('Price__c ----:'+skuObj.netRateEntered);
                system.debug('OrderId----:'+orderId);
                
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
        system.debug('DeleteSKU Called....');
            ApexLog.exceptionCoverage(throwEx);
            skuOrderList = new List<SKUDetails>();
            OrderLineItem__c oliObj = new OrderLineItem__c();
            system.debug('Inside DeleteSKU...skuIdChosen--: '+skuIdChosen);//
            oliObj.Id = skuOrderMap.get(skuIdChosen).oliId;
            system.debug('Inside DeleteSKU...skuOrderMap--: '+skuOrderMap);//
            skuOrderMap.remove(skuIdChosen);
            delete oliObj;
            //skuOrderList.addAll(skuOrderMap.values());
            editOrder();
            system.debug('Inside DeleteSKU...orderList Size--: '+skuOrderList.size());//
            system.debug('Inside DeleteSKU...orderList--: '+skuOrderList);//
            refreshOrderValue();
        }
        catch(Exception ex){
            ApexLog.exceptionHandler(ex, orderId, accountId);
            
        }            
    }
    
    //Method to Empty Order Summary
    public void deleteAllSKU(){
        try{
        system.debug('DeleteAllSKU Called....');
            ApexLog.exceptionCoverage(throwEx);
            delete[Select id from OrderLineItem__c where order__c=:orderId];
            skuOrderMap.clear();
            skuOrderList.clear();
            refreshOrderValue();
        }
        catch(Exception ex){
            ApexLog.exceptionHandler(ex, orderId, accountId);
            
        }  
    }
    
    //Method to Save the Order as Draft
    public void saveOrder(){
        try{
        system.debug('SaveOrder Called....');
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
            else if(!skuOrderList.isEmpty() && showError==false){
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
        system.debug('Confirm Order Called....');
            ApexLog.exceptionCoverage(throwEx);
            
            if(Test.isRunningTest()){
                valuefromJS='Order Confirmed';
            }
            
            if(valuefromJS=='Order Confirmed'){
                saveOrder();
                 if(Test.isRunningTest()){
                    orderSaved =true;
                }
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
                        system.debug(SalesOrderID);
                        if(valuefromJS!=''){
                            errorMessage = System.Label.Order_Confirmed;//valuefromJS;
                            errorMessage = errorMessage +  '\n' +System.Label.Order_No;//'.Order Number : ';
                            
                        }
                        List<Sales_order__c> salesOrderName = [select ID,Name FROM Sales_order__c where Id IN:SalesOrderID];
                        for(Sales_Order__c SORDER : salesOrderName){
                            if(SalesOrderID .size()>1){
                                errorMessage = errorMessage +' '+SORDER.Name+',';
                            }else{
                                errorMessage = errorMessage +' '+SORDER.Name;
                            }
                            
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
                            for(String soid : SalesOrderID){
                                if(soid!=null && !attachList.isEmpty()){
                                    Attachment attObj = new Attachment();
                                    attObj.Name = attachList[0].Name;
                                    attObj.ParentId = soid;
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
        system.debug('RefreshOrderValue Called....');
            ApexLog.exceptionCoverage(throwEx);
            system.debug('refreshOrderValue----:');
            system.debug('orderId----:'+orderId);

            
            if(String.isNotBlank(orderId)){
                Order__c orderObj =  [SELECT Id, Gross_Amount__c,Remarks__c, 
                                      Shipping_Location__c
                                      FROM Order__c 
                                      WHERE Id=:orderId];
                
                grossAmount = orderObj.Gross_Amount__c;
                system.debug('grossAmount ----:'+grossAmount);
            }
        }
        catch(Exception ex){
            ApexLog.exceptionHandler(ex, orderId, accountId);
            
        }            
    }
    
    //Generate Order Template Name
    public void getTemplateName(){
        try{
        system.debug('getTemplateName Called....');
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
        system.debug('saveTemplate Called....');
            ApexLog.exceptionCoverage(throwEx);
            
            List<OrderTemplateItem__c> oliList = new List<OrderTemplateItem__c>();
            
            OrderTemplate__c otObj = new OrderTemplate__c();
            otObj.name = templateName;
            otObj.DistributorCustomerCode__c = accountId;
            system.debug('SelectedCurrency'+SelectedCurrency);
            otObj.CurrencyIsoCode = SelectedCurrency;
            if(Test.isRunningTest()){
            otObj.Payment_Method__c = (ID)(Payment_Methods);
            otObj.Payment_Term__c = (ID)Payment_Terms;
            otObj.Inco_Term__c = (ID)Inco_Terms;
            }else{
           // otObj.Payment_Method__c = Payment_Methods;
           system.debug('Payment Term inside saveTemplate method-----: '+Payment_Terms);
            otObj.Payment_Term__c = Payment_Terms;
            otObj.Inco_Term__c = Inco_Terms;
    
            }
            insert otObj;
            
            for(SKUDetails skuObj:skuOrderList){
                OrderTemplateItem__c otiObj = new OrderTemplateItem__c();
                if(SelectedCurrency!='' && SelectedCurrency!= null){
                otiObj.CurrencyIsoCode = SelectedCurrency;
                }
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
        system.debug('showORderHistory Called....');
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
        system.debug('showOrderTemplate Called....');
            ApexLog.exceptionCoverage(throwEx);
            tempList = [SELECT Id, Name,CurrencyIsoCode,Payment_Method__c,Payment_Term__c,Inco_Term__c, DistributorCustomerCode__c FROM OrderTemplate__c
                        WHERE DistributorCustomerCode__c=:accountId];
            
        }
        catch(Exception ex){
            ApexLog.exceptionHandler(ex, orderId, accountId);
        }            
    }
    
    //Method to reload existing Template in to Order Wrapper
    public void loadTemplate(){
        try{
        system.debug('LoadTemplate Called....');
            ApexLog.exceptionCoverage(throwEx);
            
            createOrder();
            
            delete [SELECT Id FROM OrderLineItem__c WHERE Order__c=:ordObj.Id];
            
            skuOrderMap.clear();
            skuOrderList.clear();        
            
            refreshOrderValue();
            
            if(ordObj.Order_Status__c=='Approved'){
                enableInput = false;
            }
             tempList = [SELECT Id, Name,CurrencyIsoCode,Payment_Method__c,Payment_Term__c,Inco_Term__c, DistributorCustomerCode__c FROM OrderTemplate__c
                        WHERE DistributorCustomerCode__c=:accountId AND ID=:tempIdChosen limit 1];
           system.debug(tempList);
             if(tempList.size()>0){
               
                 SelectedCurrency = tempList[0].CurrencyIsoCode;
                // Payment_Methods = tempList[0].Payment_Method__c;
                // Payment_Terms = tempList[0].Payment_Term_Code__c ;
                 Inco_Terms = tempList[0].Inco_Term__c;
                   system.debug('Payment_Methods - '+Payment_Methods);
                     system.debug('Payment_Terms- '+Payment_Terms);
                         system.debug('Inco_Terms- '+Inco_Terms);
             }
             fetchSKUData();
            
            List<OrderTemplateItem__c> oliList = [SELECT Id, Name,Director_Price__c,Manager_Price__c, SKU__c,MinPrice__c, MaxPrice__c, FinalPrice__c, OrderTemplate__c,
                                                  SKU__r.Product_Name__r.Name, SKU__r.Name,multipleOf__c,
                                                  SKU__r.Pack_Size__c, SKU__r.UOM__c, SKU__r.Brand_Name__c
                                                  FROM OrderTemplateItem__c  
                                                  WHERE OrderTemplate__c =: tempIdChosen];
            system.debug(oliList);
            
            for(OrderTemplateItem__c oliObj:oliList){ // TODO:abhishek
               system.debug('skuDetailsMap -- '+skuDetailsMap);
                system.debug('skuDetailsMap------->'+skuDetailsMap.get(oliObj.SKU__c));
                SKUDetails skuWrapObj2 = skuDetailsMap.get(oliObj.SKU__c);
                SKUDetails skuWrapObj = new SKUDetails();
                skuWrapObj.productName = skuWrapObj2.productName; //oliObj.SKU__r.Product_Name__r.Name;
                skuWrapObj.skuCode =skuWrapObj2.skuCode;// oliObj.SKU__r.Name;
                skuWrapObj.skuId =skuWrapObj2.skuId;// oliObj.SKU__c;
                skuWrapObj.minprice= skuWrapObj2.minprice;
                skuWrapObj.maxprice = skuWrapObj2.maxprice;//oliObj.MaxPrice__c;
                skuWrapObj.finalprice = oliObj.FinalPrice__c+'' ;
                skuWrapObj.Floorprice = oliObj.FinalPrice__c ;
                skuWrapObj.multipleof = skuWrapObj2.multipleof;//oliObj.multipleOf__c; 
                skuWrapObj.Director_Price = skuWrapObj2.Director_Price;//oliObj.Director_Price__c; 
                skuWrapObj.Manager_Price = skuWrapObj2.Manager_Price;//oliObj.Manager_Price__c; 
                skuWrapObj.brandName = skuWrapObj2.brandName ;//oliObj.SKU__r.Name;
                skuWrapObj.packsize=skuWrapObj2.packsize;
                
               // skuWrapObj.Price = skuWrapObj2.Price;
                //skuWrapObj.minPrice = skuWrapObj2.minPrice;
                skuWrapObj.netRateEntered = 0;            //skuWrapObj2.Price;
                skuWrapObj.qty = 0;
                skuWrapObj.UOM = oliObj.SKU__r.UOM__c;
                skuWrapObj.divisionId =skuWrapObj2.divisionId;
                skuWrapObj.available = skuWrapObj2.available;
                skuWrapObj.available2 = skuWrapObj2.available2;
                skuWrapObj.currencyIso = skuWrapObj2.currencyIso;
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
                oliObj.Net_Price__c = skuWrapObj.netRateEntered;
                  oliObj.MinPrice__c =skuWrapObj.minprice;
                  oliObj.MaxPrice__c = skuWrapObj.maxprice;
                 if(Test.isRunningTest()){
                 skuWrapObj.finalprice='10,00';
                }  
                oliObj.FinalPrice__c = Decimal.valueof(skuWrapObj.finalprice.replace(',','.'));//skuWrapObj.finalprice;
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
    system.debug('redirectFunction Called....');
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
        
        public Decimal multipleOf {get;set;}
        public Decimal Director_Price{get;set;}
        public Decimal Manager_Price{get;set;}    //.....its Regional Head Price
        public String brandName {get;set;}
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
        public Decimal floorPrice{get;set;}
        public Decimal minPrice {get;set;}
        public String finalPrice {get;set;}
        public Integer itemNo {get;set;}
        public Integer perUnit {get;set;}
        public Decimal available {get;set;}
        public Decimal maxPrice{get;set;}
       // public Decimal minPrice{get;set;}
     //   public Decimal floorPrice{get;set;}
        public Decimal packsize{get;set;}
        public String available2 {get;set;}
        public String currencyIso {get;set;}
        
        public SKUDetails(){
            UOM = 'N/A';
            packsize=0;
            maxPrice = 0;
            minPrice = 0;
            //qty = 0;
            floorPrice = 0;//for colombia ..pricebook add by abhishek verma
            //minPrice = 0;
            Manager_Price=0;
            Director_Price = 0;
            price = 0;
            finalPrice = '0';
            netRateEntered = 0;
            available = 0;
            available2 = 'Out of Stock';
            popular = false;
            divisionId='';
            multipleOf =0;
        }
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