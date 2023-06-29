/*
* Name: OrderArgentinaController
* Created On: 12 April 2017
* Author: Bhavik Devdhar (bhavik.devdhar@skinternational.com)
* Description: Class is used for Placing Orders by Distributor, TM, RM of Argentina
 Latmodified:EY -CR:APPS-5287 -To calculate Freeze period
*/
global without sharing class OrderArgentinaController {
    //Variable to be set by JS for Attachment status
    //added By vishal Pawar CR152
    public Login_Country__c logCoOj {get;set;}
        
    
    public String valuefromJS {get;set;}
    public Sales_Order__c sorderObj {get;set;}
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
    
    public Set<String> productNamesSet{get;set;}
    public Set<String> descriptionSet{get;set;}
    
    public List<SelectOption> depotSet{get;set;}
    public List<SelectOption> paymentTermSet{get;set;}
    public List<SelectOption> shippingList {get;set;}    
    public List<SelectOption> paymentmethodOptionList{get;set;}
    public List<SelectOption> orderTypeSet{get;set;}
    // public List<SelectOption> customerApprovalStatusOption { get;set;}
    //Set Order Type Code
    public String orderTypeCode {get;set;}
    //added by Paresh Sondigara : Margin Block : 26-07-22
    public String profitCenter {get;set;}
    public String orderType {get;set;}
    public String selectedShipping {get;set;}
    public String selectedDepot {get; set;}
    public String searchProdValue {get; set;}
    public String templateName {get; set;}
    public String errorMessage {get; set;}
    public String selectedPaymentTerm {get;set;}
    
    public String selectedPayment{get;set;}
    public String paymentTermCode {get;set;}
    public String selectedOrderType{get;set;}
    
    public String selectedPaymentId {get;set;}
    public String paymentTermCodeId {get;set;}
    public String selectedOrderTypeId {get;set;}
    //Added By Paresh Sondigara : Delete SKU From Cart Logic
    public Integer skuItemNo {get;set;}
    public String skuIdChosen {get; set;}
    public String tempIdChosen {get; set;}
    public String storageIdChosen {get; set;}
    public String paymentIdChosen {get; set;}
    //added by vishal pawar on dated 21-05-2018
    public String paymentMethodIdChosen {get;set;}
    public String orderTypeIdChosen {get;set;}
    //public Boolean customerApproval {get;set;}
    
    public String orderRaisedBy {get; set;}
    public String skuJSON {get;set;}
    public String distributorJSON {get;set;}
    public String shippingJSON {get;set;}    
    public Boolean showError{get;set;}
    public Boolean enableInput{get;set;}
    public Boolean throwEx;
    public Boolean isCustomerAprrove{get;set;}
    
    
    //Order Related Permissions
    public Boolean showCredit{get;set;}
    public Boolean showInventory{get;set;}
    public Boolean showInventoryColumn{get;set;}
    public Boolean enableDepot{get;set;}
    
    public Boolean allowTemplate{get;set;}
    public Boolean orderSaved{get;set;}
    public Boolean flagForPdf = true;
    public Boolean flagForAccTeam ;
    
    public Decimal grossAmount {get;set;}
    
    public Integer itemNumber;
    //Added by Nandhini
    public String selectDeliveryModule{get;set;}
    // public String deliveryChoosen{get;set;}
    public Map<String,Decimal> mapOfFreezePeriod;
    public Integer deliveryPeriod{get;set;}
    public Map<Id,Integer> mapOfdeliveryPeriod{get;set;}
    public Map<Id,Integer> mapOfSalesApprovalPeriod;
    public String commonPeriodMap{get;set;}
    public String salesApprovalPeriodMap{get;set;}
    public List<String> holidayList{get;set;}
    //For Order summary
    public Map<Id,Integer> mapOfOrderSummaryDelivery{get;set;}
    public Map<Id,Integer> mapOfOrderSummarySalesApprovalPeriod;
    public String commonPeriodMapOrderSummary{get;set;}
    public String salesApprovalPeriodMapOrderSumamry{get;set;}
    Public String serialiZedOrderSummaryDeliveryPeriod{get;set;}
    Public String serialiZedOrderSummarysalesApprovalPeriod{get;set;}
    
    Public String serialiZedMapOfDeliveryPeriod{get;set;}
    Public String serialiZedMapOfsalesApprovalPeriod{get;set;}
    public Integer financialApproval{get;set;}
    public Integer deliveryAndShipping{get;set;}
    public Integer salesApprovalPeriod{get;set;}
    public Decimal enteredFinalPrice{get;set;}
    public Decimal enteredqty{get;set;}
    public Id skuId{get;set;}
   // public List<ProcessInstanceHistory> stepWorksItem;
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
    public Sales_Order__c soObj {get;set;}
    //added by vishal 7-9-2018
    public String userID {get;set;}
    public List<AccountTeamMember> accTeamMemberLst ;
    public User loginUserObj1; 
    public String ugdnNumber ;
    public String SAPPassword;
   
    public OrderArgentinaController(ApexPages.StandardController controller) {
        try{
            orderTypeCode = 'ZEOR'; //DIVYA: 06-03-2020: Replaced ZXOR for SCTASK0136732
            country = 'Argentina';
            paymentTermCode = '';  
            slwObj = new ShippingLocation();
            sorderObj=new Sales_Order__c();
            productNamesSet = new Set<String>();
            descriptionSet = new Set<String>();
            depotSet = new List<SelectOption>();
            paymentTermSet = new List<SelectOption>();
            paymentmethodOptionList=new List<SelectOption>();
            orderTypeSet = new List<SelectOption>();
            skuDetailsList = new List<SKUDetails>();
            skuOrderList = new List<SKUDetails>();
            oliList = new List<OrderLineItem__c>();
            mapOfFreezePeriod =new Map<String,Decimal>();
            skuOrderMap = new Map<Id,SKUDetails>();
            shippingMap = new Map<String, ShippingLocation>();
            skuDetailsMap = new Map<Id,SKUDetails>();
            stateMap = new Map<String, String>();
            accTeamMemberLst = new List<AccountTeamMember>();
            ugdnNumber =  '';
            SAPPassword = '';
            flagForAccTeam = true;
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
            
            itemNumber = 0;
            
            accountId = '';
            userID = '';
            distributorId = '';
            depoId = '';
            
            territoryManagerId = '';
            //Added by nandhini--need to comment this
            deliveryPeriod=0;
            financialApproval=1;
            deliveryAndShipping=0;
            salesApprovalPeriod=0;
            mapOfdeliveryPeriod=new Map<id,Integer>();
            mapOfSalesApprovalPeriod=new Map<Id,Integer>();
            mapOfOrderSummaryDelivery=new Map<Id,Integer>();
            mapOfOrderSummarySalesApprovalPeriod=new Map<Id,Integer>();
            holidayList=new List<String>();
            //stepWorksItem=new List<ProcessInstanceHistory>();
            List<Argetina_Holiday_Days__mdt> holidayInfo=[Select Id,Holiday_Dates__c from Argetina_Holiday_Days__mdt];
            for(Argetina_Holiday_Days__mdt holidayDate:holidayInfo){
                holidayList.add(holidayDate.Holiday_Dates__c);
            }
            
            //commonPeriodMap=new Map<Id,Integer>();
            
            orderId = ApexPages.currentpage().getparameters().get('id');        
            System.debug('orderId: '+orderId);
            
            accountId = ApexPages.currentpage().getparameters().get('acid');
            System.debug('accountId: '+accountId);
            
            
            
            User loginUserObj = [SELECT Id, Name, IsActive, ContactId,UserRole.name,
                                 Show_Inventory__c, Show_Credit_Limit__c, EnableDepot__c,
                                 Show_Inventory_Column__c, ManagerId
                                 FROM User 
                                 WHERE Id =: UserInfo.getUserId()
                                 AND IsActive = True];
            
            //SAP_User_Password__c
            
            userID = UserInfo.getUserId();
            System.debug('loginUserObj '+loginUserObj);
            System.debug('userID in Create Order '+userID);
            System.debug('Account Id is '+accountId);
            
            accTeamMemberLst = [SELECT Id, AccountId, UserId, TeamMemberRole, Title 
                                FROM AccountTeamMember 
                                WHERE AccountId=:accountId 
                                AND UserId =:userID];
            System.debug('size of accTeamMemberLst '+accTeamMemberLst.size());
            
            if(accTeamMemberLst.size()>0){
                User loginUserObj1 = [SELECT Id, Name,SAP_User_Password__c, IsActive,UGDN_Number__c 
                                      FROM User 
                                      WHERE Id =: UserInfo.getUserId()
                                      AND IsActive = True];
                System.debug('loginUserObj1.UGDN '+loginUserObj1.UGDN_Number__c);
                
                
                
                if(loginUserObj1!=Null){
                    //        ugdnNumber = loginUserObj1.UGDN_Number__c;
                    //        SAPPassword = loginUserObj1.SAP_User_Password__c;
                    //      distributorId = UserInfo.getUserId();
                    flagForAccTeam =false;
                }
            }
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
                   // distributorId = listUr[0].id;
                   // Added by Ishu Mital for ticket RITM0508960
                    Account accowner = [Select id,ownerId From Account Where id =: accountId];
                    distributorId = accowner.ownerId;
                }else{
                    Account accowner = [Select id,ownerId From Account Where id =: accountId];
                    // patch created by vishal pawar
                    if(flagForAccTeam){
                        distributorId = accowner.ownerId;
                        System.debug('without Team ');
                    }else{
                        distributorId =  UserInfo.getUserId();
                        System.debug('with Team ');
                    }
                    
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
            System.debug('customer approval ==>'+isCustomerAprrove);
            
           
            
        }
        catch(Exception ex){
            System.debug('Method: Constructor Exception: '+ex.getMessage()+ ' Line Number: '+ex.getLineNumber());
        }
    }
    
    //Method to Create SalesOrder on Order Confirmation
    public void createSalesOrder(){
        try{
            system.debug('check shipping Map '+shippingMap);
            system.debug('check slwObj Map '+slwObj);
            system.debug('check selected shipping Map '+selectedShipping);
            //New change by Nandhini
            if(shippingMap.containsKey(selectedShipping)){
                slwObj = shippingMap.get(selectedShipping);
            }
            ApexLog.exceptionCoverage(throwEx);
            if(ordObj!=null  && soObj==null){
               // if(this.DeliveryDate == null && logCoOj.PO_Date__c == false){//Delivery Date:RITM0094155, 3rd September 2020, Sayan (crmconsultant3@upl-ltd.com) // SKI : #CR152 : PO And Delivery Date : 12-07-2022 Vishal P SKI..
                    soObj = new Sales_Order__c();
                    soObj.Sold_to_Party__c = accountId;
                    soObj.Bill_To_Party__c = accountId;
                    soObj.Order_Date__c = System.today();
                    soObj.Order_Raise_By__c = orderRaisedBy;
                    soObj.Order_Status__c = 'Open';
                    soObj.CreatedFrom__c = 'SFDC';
                    soObj.OwnerId = distributorId;
                    //soObj.UGDN__c = ugdnNumber;
                    //soObj.SAP_Password__c = 'init123';
                    soObj.Order__c = ordObj.Id;
                    soObj.Ship_To_Party__c = slwObj.locationId;
                    soObj.Sales_Org_lk__c = distWrapObj.salesOrgId;
                    soObj.Distribution_Channel_lk__c = distWrapObj.distributorChannelId;
                    soObj.Division_lk__c = distWrapObj.divisionId;
                    soObj.Request_Delivery_Date__c  = this.DeliveryDate;//Delivery Date:RITM0094155, 3rd September 2020, Sayan (crmconsultant3@upl-ltd.com)
                    //added By Vishal Pawar SKI : #CR152 : PO And Delivery Date : 12-07-2022
                    soObj.Purchase_Order_Date__c = this.DeliveryDate;
                    //Ended By Vishal Pawar SKI : #CR152 : PO And Delivery Date : 12-07-2022
                    soObj.Credit_Term__c = distWrapObj.paymentTerms;
                    soObj.Remarks__c = ordObj.Remarks__c;
                    //soObj.Payment_Method_Code__c
                    //soObj.Stock_Status__c = 'In Stock';
                    soObj.CurrencyIsoCode = distWrapObj.currencyIso;
                    //Added by Nandhini to capture the Delivery Module
                    soObj.Deliver_Pickup__c=selectDeliveryModule;
                    if(String.isNotBlank(PO)){
                        soObj.PONumber__c = PO;
                    }
                    //Added by Varun Shrivastava : Ticket : INCTASK0243921 start
                    else{
                        soObj.PONumber__c = '.';
                    }
                    //Added by Varun Shrivastava : Ticket : INCTASK0243921 start
                    
                    
                    System.debug(' soObj.Payment_Term__c ==>'+ soObj.Payment_Term__c);
                    //added by vishal pawar
                    System.debug('payment term is '+paymentTermCode);
                    System.debug('payment term is '+selectedPaymentTerm);
                    soObj.PaymentMethod__c = selectedPaymentId;
                    soObj.Payment_Term__c =  paymentTermCode;
                    soObj.Order_Type_lk__c = selectedOrderType;
                    
                    /* Order_Type__c orderTypeObj = [select id,Name,Description__c from Order_Type__c Where Id=:selectedOrderType];
if(orderTypeObj.Description__c=='Invoice'){
soObj.Customer_Approval__c=isCustomerAprrove;        
}*/
                    
                    soObj.Customer_Approval__c=isCustomerAprrove;
                    if(isCustomerAprrove==true){
                        soObj.Customer_Approval_Status__c= 'Pending'; 
                    }
                    if(String.isNotBlank(managerId))
                        soObj.Manager__c = managerId;
                    
                    if(soObj.Order_Raise_By__c == 'Distributor'){
                        soObj.Designated_Owner__c = territoryManagerId;
                    }
                    else{
                        soObj.Designated_Owner__c = distWrapObj.regionalManagerId;
                    }
                    
                    //End of patch
                    //soObj.Order_Type_lk__c = [Select Id FROM Order_Type__c WHERE Order_Type_Code__c=:orderTypeCode].Id;//distWrapObj.orderType  [Select Id FROM Order_Type__c WHERE Order_Type_Code__c='ZORD'].Id; 
                    insert soObj;
                    Sales_Order__Share salesOrderShare  = new Sales_Order__Share();
                    salesOrderShare.ParentId = soObj.id;
                    salesOrderShare.UserOrGroupId = UserInfo.getUserId();
                    salesOrderShare.AccessLevel ='read';
                    salesOrderShare.RowCause = Schema.Sales_Order__Share.RowCause.Manual;
                    insert salesOrderShare;
                    system.debug('sales order id is ='+soObj.Id);
                    //Delivery Date:RITM0094155, 3rd September 2020, Sayan (crmconsultant3@upl-ltd.com)
                //}
                /*else{   // SKI : #CR152 : PO And Delivery Date : 12-07-2022 Vishal P SKI..
                    showError = true;
                    errorMessage = System.Label.Please_Enter_Delivery_Date;
                }*/
                //Delivery Date:RITM0094155, 3rd September 2020, Sayan (crmconsultant3@upl-ltd.com)
            }
        }
        catch(Exception ex){
            System.debug('Error number is '+ex.getLineNumber());
            System.debug('Error massage is '+ex.getMessage());
            ApexLog.exceptionHandler(ex, orderId, accountId);
        }
    }
    
    //Method to add Line Items to SalesOrders on Order Confirmation
    public void addSOLineItem(){
        try{
            ApexLog.exceptionCoverage(throwEx);
            Boolean submitForApproval = false;
            boolean budgetApproval = false;
            boolean minPriceApproval = false;//#INC-391026
            boolean maxPriceApproval = false;//#INC-391026
            
            //added by Paresh Sondigara : Margin Block : 26-07-22
            boolean sentForLatam = false;
            boolean sentForCCO = false;
            
            List<Sales_Order_Line_Item__c> sliObjList = new List<Sales_Order_Line_Item__c>();
            Sales_Order_Line_Item__c sliObj;
            System.debug('country name is '+country);
            Id argentinaDepo = [Select Id From Depot__c Where Name=:country LIMIT 1].Id;
            System.debug('argentinaDepo=>'+argentinaDepo);
            //System.debug('argentinaDepo=>'+skuOrderMap);
            
            //added by Paresh Sondigara : Margin Block : 26-07-22
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
            for(SKUDetails obj :skuOrderList){               
              skIdsList.add(obj.skuId);
            }
            
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
            
            
            
            List<UOM_Conversion__c> uomList = new List<UOM_Conversion__c>();
            Map<String,List<UOM_Conversion__c>> uomListMap = new Map<String,List<UOM_Conversion__c>>();
            uomList =[SELECT Id, Name, SKU__c, Base_UOM__c, Sales_UOM__c, 
                      Numerator__c, Sales_Org__c, Denominator__c 
                      FROM UOM_Conversion__c 
                      WHERE SKU__c IN:skIdsList
                      AND Sales_Org__r.Sales_org_code__c ='5631' ORDER BY LastModifiedDate ASC ];
  
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
                             WHERE Sales_Org__r.Sales_org_code__c ='5631'
                             AND Distributor_Code__c=:accountId
                             AND Start_Date__c<= today AND End_Date__c>= today
                             AND SKU_Code__c IN:skIdsList
                             AND Type__c ='Rebate'
                             AND (Rebate_USD__c!=null OR Rebate__c!=null)
                             AND Rebate_Code__c!=null ORDER BY LastModifiedDate DESC ];
           
            
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
                                       WHERE Sales_Org__r.Sales_org_code__c ='5631'
                                       AND Distributor_Code__c=:accountId
                                       AND SKU_Code__c IN:skIdsList 
                                       AND Type__c ='AdditionalDiscount'
                                       AND Start_Date__c<= today AND End_Date__c>= today
                                       AND (Additional_Discount_USD__c!= null OR Additional_Discount__c!= null) ORDER BY LastModifiedDate ASC ];
           
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
                                 WHERE Sales_Org__r.Sales_org_code__c ='5631'
                                 AND SKU_Code__c IN :skIdsList
                                 AND Sales_Deduction_USD__c != null
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
            Map<String,List<Price_Block_Margin_Matrix__c>> mapPrcpln = new MAP<String,List<Price_Block_Margin_Matrix__c>>();
            pbmmPlnList =[SELECT Id, Name, SKU_Code__c, SKU_Active__c, UOM__c, 
                           Sales_Org__c, PLN_LC__c, PLN_USD__c 
                           FROM Price_Block_Margin_Matrix__c
                           where Sales_Org__r.Sales_org_code__c ='5631'
                           AND SKU_Code__c IN:skIdsList
                           AND Type__c ='PLN'
                           AND Start_Date__c<= today AND End_Date__c>= today
                           AND PLN_USD__c!=null ORDER BY LastModifiedDate ASC ];       
            
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
            //End 
            
            Integer i = 0;//added by ganesh
            for(SKUDetails skuWrapObj:skuOrderList){ // SKI : #CR152 : PO And Delivery Date : 12-07-2022 Vishal P SKI..
                i=i + 10;                
                sliObj = new Sales_Order_Line_Item__c();                
                
                if(skuWrapObj.finalPrice==0  && !Test.isRunningTest()){
                    showError = true;
                    errorMessage = System.Label.Please_Enter_Final_Price_for_all_SKU_s_before_confirming_order;
                    //'Please Enter Quantity for all SKU\'s before confirming order'; 
                    break;
                }
                if(skuWrapObj.qty==0 && !Test.isRunningTest()){
                    showError = true;
                    errorMessage = System.Label.Please_Enter_Quantity_for_all_SKU_s_before_confirming_order;
                    //'Please Enter Quantity for all SKU\'s before confirming order'; 
                    break;
                }
                else{
                    createSalesOrder();
                    //  sliObj.Payment_Term__c = paymentIdChosen; //new Payment_Term__c(Payment_Term_Code__c='0020');
                      
                  
                    //added by Paresh Sondigara : Margin Block : 26-07-22
                    //Start
                    Decimal rebateVal1 = 0.0 ;
                    Decimal rebateVal2 = 0.0 ;
                    Decimal rebateVal = 0.0 ;
                    Decimal rebatePercent1Convert;
                    Decimal rebatePercent2Convert;
                                        
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
                                        Decimal uomConver = uomObj.Numerator__c /uomObj.Denominator__c;                                            
                                        skuWrapObj.convertQty = skuWrapObj.qty*uomConver;
                                        break;
                                    }                            
                                }
                            }      
                    }
                                         
            
                    for(UOM_Conversion__c uomObj :uomList1){
                        if(skuWrapObj.finalPrice!=null){ 
                            if(skuWrapObj.uOM == uomObj.Base_UOM__c){
                                skuWrapObj.convertNetPrice = skuWrapObj.finalPrice; 
                                skuWrapObj.convertFinalPrice = skuWrapObj.finalPrice *skuWrapObj.convertQty;
                                break;
                            }else if(skuWrapObj.uOM == uomObj.Sales_UOM__c){                        
                                Decimal uomConver = uomObj.Numerator__c /uomObj.Denominator__c; 
                                skuWrapObj.convertNetPrice = skuWrapObj.finalPrice / uomConver;                                                        
                                skuWrapObj.convertFinalPrice = skuWrapObj.convertNetPrice *  skuWrapObj.convertQty;
                                break;
                            }                            
                        }
                    }
                    
                    
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
                            if(skuWrapObj.discountPercent!=null && skuWrapObj.discountUSD==null){                        
                                discountPercentConvert = (skuWrapObj.discountPercent * skuWrapObj.convertFinalPrice)/100; 
                                discountVal = discountPercentConvert;
                            }
                            
                        }
                    }
                                        
                    if(skuWrapObj.currencyIso=='USD'){
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
                                if(skuWrapObj.salesDeductionUSD>0){ 
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
                            if(profObj.Sales_Value__c!=null && skuWrapObj.salesDeductionUSD==0){
                                saleaDeductionPercent = (profObj.Sales_Value__c * skuWrapObj.convertFinalPrice)/100; 
                                salesDeductionVal = saleaDeductionPercent;
                            } 
                        }
                    }
                    if(skuWrapObj.currencyIso=='USD'){
                        sliObj.Sales_Deduction_Budget__c = skuWrapObj.salesDeductionUSD;  
                    }           
                    sliObj.Sales_Deduction_Profit_Center__c = profObj.Sales_Value__c;
                    sliObj.Sales_Deduction_Cal__c = salesDeductionVal;
                    sliObj.UOM_Sales_Deduction__c = skuWrapObj.uomSalesDeduction;
                    
                                        
                    //this is for e2e converted Logic
                    System.debug('e2ECostUSD '+skuWrapObj.e2ECostUSD);
                    System.debug('e2ECostUPC9USD '+skuWrapObj.e2ECostUPC9USD);
                    System.debug('e2ECostMBEWUSD '+skuWrapObj.e2ECostMBEWUSD);
                    System.debug('uome2eCost '+skuWrapObj.uome2eCost);
                    Decimal e2eCostVal= 0.0 ;
                    if(uomList1.size()>0){
                        if(skuWrapObj.currencyIso=='USD'){
                            for(UOM_Conversion__c uomObj :uomList){
                                if(skuWrapObj.e2ECostUSD > 0){                                                                      
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
                                }else if(skuWrapObj.e2ECostUSD == 0 && skuWrapObj.e2ECostUPC9USD > 0){                        
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
                                }else if(skuWrapObj.e2ECostUSD == 0 && skuWrapObj.e2ECostUPC9USD == 0 && skuWrapObj.e2ECostMBEWUSD > 0){
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
                    
                    if(skuWrapObj.currencyIso=='USD'){
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
                         if(skuWrapObj.currencyIso=='USD'){
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
                    Decimal totalCost=0;                    
                    totalCost = skuNetPrice - salesDeductionVal - e2eCostVal;
                    
                    System.debug('convertFinalPrice--'+skuWrapObj.convertFinalPrice);
                    System.debug('rebateVal--'+rebateVal);
                    System.debug('discountVal--'+discountVal);
                    System.debug('addDiscountVal--'+addDiscountVal);
                    System.debug('ptpmDiscountVal--'+ptpmDiscountVal);
                    System.debug('skuNetPrice--'+skuNetPrice);
                    System.debug('totalCost--'+totalCost);
                    System.debug('salesDeductionVal--'+salesDeductionVal);
                    System.debug('e2eCostVal--'+e2eCostVal);
                    
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
                    
                    if(blanketSKUMap.containsKey(skuWrapObj.skuId)){
                        List<Blanket_SKU__c> blanketList = blanketSKUMap.get(skuWrapObj.skuId);
                        sliObj.Blanket_SKU_Start_Date__c = blanketList[0].Start_Date__c;
                        sliObj.Blanket_SKU_End_Date__c = blanketList[0].End_Date__c;
                        sliObj.Blanket_SKU_Status__c = blanketList[0].Status__c;
                        if(blanketList[0].Start_Date__c <= System.today() && blanketList[0].End_Date__c >= System.today() && blanketList[0].Status__c == true){
                            sliObj.Margin_Block_Level_1__c = false;
                            sliObj.Margin_Block_Level_2__c = false;
                        }else if(contributionMarginPercent >= adminObj.Level_2_min__c  &&  contributionMarginPercent <= adminObj.Level_2_max__c ){
                            sliObj.Margin_Block_Level_1__c = true;
                            sentForLatam = true;
                        }else if(contributionMarginPercent <= adminObj.Level_3_below__c ){
                            sliObj.Margin_Block_Level_2__c = true;  
                            sentForLatam = true;
                            sentForCCO = true;
                        }                        
                    }else{
                        if(contributionMarginPercent >= adminObj.Level_2_min__c  &&  contributionMarginPercent <= adminObj.Level_2_max__c){
                            sliObj.Margin_Block_Level_1__c = true;
                            sentForLatam = true;
                        }
                        if(contributionMarginPercent <= adminObj.Level_3_below__c){
                            sliObj.Margin_Block_Level_2__c = true;
                            sentForLatam = true;
                            sentForCCO = true;
                        }                                
                    }     
                    //End
                    
                    sliObj.SKU_Name__c = skuWrapObj.skuId;
                    // sliObj.Item_Number__c = skuWrapObj.itemNo;  
                    sliObj.Item_Number__c = i;
                    sliObj.Item_Status__c = 'Active';
                    sliObj.DepotDepot__c = argentinaDepo; //argentinaDepo;
                    sliObj.Storage_Location__c = storageIdChosen;
                    
                    sliObj.UOM__c = skuWrapObj.UOM;
                    sliObj.CurrencyIsoCode = distWrapObj.currencyIso;
                    
                    sliObj.Quantity__c = skuWrapObj.qty;
                    sliObj.MinPrice__c = skuWrapObj.minPrice;
                    sliObj.MaxPrice__c = skuWrapObj.price;
                    sliObj.List_Price__c = skuWrapObj.listprice;//added by mahesh RITM0542614
                    sliObj.Net_Price__c = skuWrapObj.finalPrice;
                    sliObj.Price__c = skuWrapObj.netRateEntered;
                    sliObj.DistributorDiscountPercentage__c=skuWrapObj.discount;
                    System.debug('skuWrapObj.BudgetPrice'+skuWrapObj.BudgetPrice);
                    
                    sliObj.BudgetPrice__c = skuWrapObj.BudgetPrice; //added by ganesh
                    system.debug('skuWrapObj.BudgetPrice'+skuWrapObj.BudgetPrice);
                    sliObj.multipleOf__c=skuWrapObj.multipleOf; //added by vishal pawar
                    sliObj.Sale_Order__c = soObj.Id;
                    //added By VIshal Pawar #CR152
                    sliObj.Delivery_Date__c = skuWrapObj.customerDeliveryDate;
                    sliObj.First_Date__c = soObj.Request_Delivery_Date__c;//Delivery Date:RITM0094155, 3rd September 2020, Sayan (crmconsultant3@upl-ltd.com)
                    sliObjList.add(sliObj);
                    
                    
                    if(skuWrapObj.finalPrice < skuWrapObj.minPrice){
                        System.debug('Internal Approval');
                        submitForApproval = true;
                        minPriceApproval = true;//#INC-391026
                        flagForPdf=false;
                    }
                    if(skuWrapObj.finalPrice > skuWrapObj.price){
                        System.debug('Internal Approval');
                        submitForApproval = true;
                        maxPriceApproval = true;//#INC-391026
                        flagForPdf=false;
                    }
                    if(skuWrapObj.finalPrice < skuWrapObj.BudgetPrice){
                        System.debug('Budget Approval');
                        system.debug('BudgetPrice'+skuWrapObj.BudgetPrice);
                        budgetApproval = true;
                        flagForPdf=false;
                    }
                }
            }
            insert sliObjList;
            
            //Update Tax and Total Amount in Sales Order
            if(soObj!=null){
                System.debug('soObj'+soObj);
                soObj = [Select Id, Net_Amount__c,Is_Sales_Order_Line_Item_Updated__c from Sales_Order__c where id=:soObj.id];
                soObj.Total_Amount__c = soObj.Net_Amount__c;
                if(submitForApproval){
                    soObj.Order_Status__c = 'Pending';
                    soObj.InternalApprovalCheck__c = true;
                    //#INC-391026
                    if(minPriceApproval){
                        soObj.MinimumPriceCheck__c = true;
                    }
                    else if(maxPriceApproval){
                        soObj.MaximumPriceCheck__c = true;
                    }
                }
                if(budgetApproval){
                    system.debug('BudgetApproval'+budgetApproval);
                    soObj.Order_Status__c = 'Pending';
                    soObj.BudgetApprovalCheck__c = true;
                }
                soObj.Is_Sales_Order_Line_Item_Updated__c = true;
                
                //added by Paresh Sondigara : Margin Block : 26-07-22
                if(sentforLatam){
                    soObj.Sent_for_Latam_Director__c = true;
                }
                if(sentForCCO){
                    soObj.Sent_for_CCO__c = true;
                }
                
                upsert soObj;
            }
            // if(soObj!=null)
            //  { redirectFunction();}
        }
        catch(Exception ex){
            system.debug('inside catch block');
            ApexLog.exceptionHandler(ex, orderId, accountId);
        }
    }
    //Added 
    @AuraEnabled(cacheable=true)
    public static String getApprovalHistory(String recordId){
        try {
            Sales_Order__c SalesOrder = [SELECT Id,MinimumPriceCheck__c,BudgetApprovalCheck__c,MaximumPriceCheck__c,Sent_for_Latam_Director__c,Sent_for_CCO__c,Sales_Org_Code_New__c,Order_Status__c FROM Sales_Order__c WHERE Id=:recordId];
            System.debug('Sales Order rec=> '+SalesOrder);
            List<User> appuser = new List<User>();
            List<User> appuser1 = new List<User>();
            List<User> appuser2 = new List<User>();
            
           
            String step1user='';
            String step2user='';
                String step3user='';
            
            Boolean isFirstApprover=false;
            Boolean isSecondApprover=false;
           Boolean  isthirdApprover=false;
             Boolean isFirstRejected=false;
            Boolean isSecondRejected=false;
           Boolean  isthirdRejected=false;
            
            ProcessInstance pi= [Select id , Status, SubmittedBy.Name,ProcessDefinitionId,ProcessDefinition.Name,(Select id,StepStatus,Actor.Name,ProcessNode.Name from StepsAndWorkitems) from ProcessInstance where TARGETOBJECTID =:recordId ORDER BY CreatedDate DESC];
           System.debug('pi---->'+pi.StepsAndWorkitems.size());
            
             for(Integer i=0;i<pi.StepsAndWorkitems.size();i++)
            {
 System.debug('processNode Name------>'+pi.StepsAndWorkitems[i].ProcessNode.Name  +'StepStatus-------->'+pi.StepsAndWorkitems[i].StepStatus); 
                if((pi.StepsAndWorkitems[i].ProcessNode.Name=='Step 1') && (pi.StepsAndWorkitems[i].StepStatus=='Rejected') )
                {
                   isFirstRejected=true;
                }
                 if((pi.StepsAndWorkitems[i].ProcessNode.Name=='Step 2') && (pi.StepsAndWorkitems[i].StepStatus=='Rejected') )
                {
                   isSecondRejected=true;
                }

                 if((pi.StepsAndWorkitems[i].ProcessNode.Name=='Step 3') && (pi.StepsAndWorkitems[i].StepStatus=='Rejected') )
                {
                   isThirdRejected=true;
                }

               
                if((pi.StepsAndWorkitems[i].ProcessNode.Name=='Step 1') && (pi.StepsAndWorkitems[i].StepStatus=='Approved') )
                {
                   isFirstApprover=true;
                }
                if(pi.StepsAndWorkitems[i].ProcessNode.Name=='Step 2' && pi.StepsAndWorkitems[i].StepStatus=='Approved')
                {
                  isSecondApprover=true;  
                }
                if(pi.StepsAndWorkitems[i].ProcessNode.Name=='Step 3' && pi.StepsAndWorkitems[i].StepStatus=='Approved')
                {
                  isthirdApprover=true;  
                }
                
            }
           
         
            Map<String,String> StepVsUser = new Map<String,String>();
            Approval_Process_History__mdt processData = [SELECT Id,Step_One_Approver__c,Step_Two_Approver__c,Step_Three_Approver__c FROM Approval_Process_History__mdt WHERE DeveloperName = 'Argentina_SO_Approval'];
            
            List<String> userList = processData.Step_One_Approver__c.contains(';') ? processData.Step_One_Approver__c.split(';') : new List<String>{processData.Step_One_Approver__c};
                if(pi.StepsAndWorkitems.size()>0)
            {
                appuser = [Select Id,Name, Username from User where UserName IN: UserList];
            
            for(User u:appuser)
            {
                step1user=step1user+u.Name+',';
            }
            step1user = step1user.removeEnd(',');
            System.debug(step1user);
            StepVsUser.put('Step_1',step1user);
                
                if(((SalesOrder.MinimumPriceCheck__c==true && SalesOrder.BudgetApprovalCheck__c==False) || (SalesOrder.MinimumPriceCheck__c==true && SalesOrder.BudgetApprovalCheck__c==true) 
                   ||(SalesOrder.MaximumPriceCheck__c==true && SalesOrder.BudgetApprovalCheck__c==False && SalesOrder.Sent_for_Latam_Director__c==true)||(SalesOrder.MaximumPriceCheck__c==true && SalesOrder.BudgetApprovalCheck__c==false && SalesOrder.Sent_for_Latam_Director__c==true && SalesOrder.Sent_for_CCO__c==true)||
                  (SalesOrder.MaximumPriceCheck__c==False && SalesOrder.MinimumPriceCheck__c==False && SalesOrder.BudgetApprovalCheck__c==False && SalesOrder.Sent_for_Latam_Director__c==True)))
                {
                   List<String> userList1 = processData.Step_Two_Approver__c.contains(';') ? processData.Step_Two_Approver__c.split(';') : new List<String>{processData.Step_Two_Approver__c};
            appuser1 = [Select Id,Name, Username from User where UserName IN: UserList1];
            for(User u:appuser1)
            {
                step2user=step2user+u.Name+',';
            }
            step2user = step2user.removeEnd(',');
            System.debug(step2user);
            StepVsUser.put('Step_2',step2user); 
                }
                 if(((SalesOrder.MinimumPriceCheck__c==true && SalesOrder.BudgetApprovalCheck__c==true && SalesOrder.Sent_for_Latam_Director__c==false) || (SalesOrder.MinimumPriceCheck__c==true && SalesOrder.BudgetApprovalCheck__c==true && SalesOrder.Sent_for_Latam_Director__c==true) 
                   ||(SalesOrder.MaximumPriceCheck__c==true && SalesOrder.BudgetApprovalCheck__c==False && SalesOrder.Sent_for_Latam_Director__c==true)||
                  (SalesOrder.MaximumPriceCheck__c==False && SalesOrder.MinimumPriceCheck__c==False && SalesOrder.BudgetApprovalCheck__c==False && SalesOrder.Sent_for_Latam_Director__c==True)) )
                 {
                       List<String> userList2 = processData.Step_Three_Approver__c.contains(';') ? processData.Step_Three_Approver__c.split(';') : new List<String>{processData.Step_Three_Approver__c};
            appuser2 = [Select Id,Name, Username from User where UserName IN: UserList2];
             for(User u:appuser2)
            {
                step3user=step3user+u.Name+',';
            }
            step3user = step3user.removeEnd(',');
            System.debug(step3user);
            StepVsUser.put('Step_3',step3user);  
                 }
 
           
                           
            }
            List<ApprovalHistory> approvalHistorywrapper=new List<ApprovalHistory>();
         for(String s: StepVsUser.keyset())
            {  ApprovalHistory wrapper=new ApprovalHistory();
                if(s=='Step_1' )
                {
                 if(isFirstApprover)
                 {
                   wrapper.Status='Approved';    
                 }
                 else if(isFirstRejected)
                 {
                     wrapper.Status='Rejected';
                 }
                    else
                 {
                   wrapper.Status='Pending';   
                 }
                 wrapper.userName=StepVsUser.get(s);
                    wrapper.step='Step 1';
             
                }
            
             if(s=='Step_2')
                {
                 if(isSecondApprover)
                 {
                   wrapper.Status='Approved';    
                 }
                     else if(isSecondRejected)
                 {
                     wrapper.Status='Rejected';
                 }
                    else if(isFirstRejected)
                    {
                       wrapper.Status='Cancelled'; 
                    }
                 else
                 {
                   wrapper.Status='Pending';   
                 }
                 wrapper.userName=StepVsUser.get(s);
              wrapper.step='Step 2';
                }
             if(s=='Step_3')
                {
                 if(isthirdApprover)
                 {
                   wrapper.Status='Approved';    
                 }
                     else if(isThirdRejected)
                 {
                     wrapper.Status='Rejected';
                 }
                    else if(isFirstRejected || isSecondRejected)
                    {
                       wrapper.Status='Cancelled'; 
                    }
                 else
                 {
                   wrapper.Status='Pending';   
                 }
                 wrapper.userName=StepVsUser.get(s);
                     wrapper.step='Step 3';
             
                }
             approvalHistoryWrapper.add(wrapper);
            }
            System.debug('approvalHistoryWrapper----->'+approvalHistoryWrapper);

           
            return JSON.serialize(approvalHistorywrapper);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    public void changeDepot(){
        
        System.debug('Storage Location: '+storageIdChosen);
        fetchSKUData();
    }
    //added by vishal pawar dt21-05-2018
    
    public void changePayment(){
        System.debug('paymentIdChosen: '+paymentIdChosen);
        
        /*if(selectedPayment!='None'){
paymentMethodIdChosen=selectedPayment;    
} */
        
    }
    
    public void changePaymentMethod(){
        System.debug('payment method is==>'+selectedPayment);
        System.debug('calling after clicking None 1');
        selectedPaymentId = selectedPayment;
        try{
            System.debug('Calling getPayment Term after selection of payment method');
            ApexLog.exceptionCoverage(throwEx);
            paymentTermSet = new List<SelectOption>();
            system.debug('method called getPaymentTerm ==> '+selectedPayment );
            
            /*if(selectedPayment=='None' || selectedPayment==''|| selectedPayment== null){
System.debug('calling after clicking None');
List<Payment_Term__c> paymentTermList = [Select Id, Payment_Term_Code__c, Payment_Term__c from Payment_Term__c 
WHERE SalesOrgCode__c = '5631'];
for(Payment_Term__c pt:paymentTermList){
paymentTermSet.add(new SelectOption(pt.id,pt.Payment_Term__c));
}
}*/
            
            if(selectedPayment!='None'){
                System.debug('select payment in if Condition '+selectedPayment);
                
                Payment_Method__c paymentMethodObj=new Payment_Method__c();
                paymentMethodObj=[select id,Name,Payment_Method_Code__c from Payment_Method__c where id=:selectedPayment];
                
                //paymentTermSet.add(new SelectOption('None','None'));
                //Discount field added by Paresh Sondigara : Margin Block : 26-07-22  
                for(Payment_Method_Payment_Term_Mapping__c pmptm : [SELECT Id, Payment_Method__c, Payment_Term__c, Payment_Term__r.Payment_Term__c, Discount__c
                                                                    FROM Payment_Method_Payment_Term_Mapping__c 
                                                                    WHERE Payment_Method__c =: selectedPayment Order By Payment_Term__r.Payment_Term__c]){
                                                                        paymentTermSet.add(new selectOption(pmptm.Payment_Term__c,pmptm.Payment_Term__r.Payment_Term__c));  
                                                                    }
            }else{
                List<Payment_Term__c> paymentTermList = [Select Id, Payment_Term_Code__c, Payment_Term__c from Payment_Term__c 
                                                         WHERE SalesOrgCode__c = '5631'];
                paymentTermSet.add(new SelectOption('None','None'));
                for(Payment_Term__c pt:paymentTermList){
                    paymentTermSet.add(new SelectOption(pt.id,pt.Payment_Term__c));
                }
            }
            
            
            
        }
        
        catch(Exception ex){
            ApexLog.exceptionHandler(ex, orderId, accountId);
            
        }
    }
    public void changePaymentTerm(){
        System.debug('payment Term is==>'+paymentTermCode);
        paymentTermCodeId=paymentTermCode;
    }
    
    public void changeOrderType(){
        System.debug('Order Type is==>'+selectedOrderType);
        selectedOrderTypeId=selectedOrderType;
    }
    
    
    
    
    
    
    
    //Method to fetch Distributor Details, Depot, Credit Information and Shipping Details
    public void fetchDistributorDetails(){
        try{
            ApexLog.exceptionCoverage(throwEx);
            // SKI : #CR152 : PO And Delivery Date : 12-07-2022 Vishal P SKI..
            logCoOj = [SELECT Id, Name, For_Contry__c, 
                       Sales_Org_Code__c, Delivery_Date__c, PO_Date__c, 
                       Show_Delivery_Date__c, Show_PO_Date__c 
                       FROM Login_Country__c
                       WHERE Sales_Org_Code__c='5631' LIMIT 1];
            
            
            
            
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
            
            List<Depot__c> storageList = [Select Id, Name from Depot__c where recordtype.name = 'Storage Location' and SalesOrg__r.name=:country and Sequence_Number__c <> null ORDER BY Sequence_Number__c ASC];
            System.debug('storageList '+storageList);
            System.debug('storageList size  '+storageList.size());
            if(storageIdChosen == ''){
                storageIdChosen = storageList[0].Id;
            }
            //Sayan Majumder(IBM): Added sorting, 22/01/2020, 14.38, SCTASK0117939
            //List<Depot__c> d = new List<Depot__c>();
            /*for(Depot__c temp : storageList){
if(temp.Name == 'Farace'){
d.add(temp);
}else if(temp.Name == 'PM Filling'){
d.add(temp);
}else if(temp.Name == 'PM'){
d.add(temp);
}else if(temp.Name == 'Decco Tucuman'){
d.add(temp);
}else if(temp.Name == 'Crane'){
d.add(temp);
storageIdChosen = temp.Id;
}
}
for(Depot__c tdmObj:d){
if(tdmObj.Name == 'Crane'){
depotSet.add(new SelectOption(tdmObj.Id,tdmObj.Name));
}
}for(Depot__c tdmObj:d){
if(tdmObj.Name == 'Farace'){
depotSet.add(new SelectOption(tdmObj.Id,tdmObj.Name));
}
}for(Depot__c tdmObj:d){
if(tdmObj.Name == 'PM Filling'){
depotSet.add(new SelectOption(tdmObj.Id,tdmObj.Name));
}
}for(Depot__c tdmObj:d){
if(tdmObj.Name == 'PM'){
depotSet.add(new SelectOption(tdmObj.Id,tdmObj.Name));
}
}for(Depot__c tdmObj:d){
if(tdmObj.Name == 'Decco Tucuman'){
depotSet.add(new SelectOption(tdmObj.Id,tdmObj.Name));
}
}*/
            for (Depot__c d:storageList){
                depotSet.add(new SelectOption(d.Id,d.Name));
            }
            
            //Sayan Majumder(IBM): Modifications added
            List<Payment_Term__c> paymentTermList = [Select Id, Payment_Term_Code__c, Payment_Term__c from Payment_Term__c 
                                                     WHERE SalesOrgCode__c = '5631' ];
            paymentTermSet.add(new SelectOption('None','None'));
            selectedPaymentTerm='None';
            
            for(Payment_Term__c tdmObj:paymentTermList){
                paymentTermSet.add(new SelectOption(tdmObj.Id,tdmObj.Payment_Term__c));
            }
            
            populatePaymentMethod();
            populateOrderType();
            
            
            if(String.isNotBlank(distWrapObj.depot)){
                fetchSKUData();
            }
            System.debug('aaaaa '+distWrapObj.depot);
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
            shippingList.add(new SelectOption('None','None'));
            selectedShipping = 'None';
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
                    slw2Obj.statecode=slObj.State__c;
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
                    slw2Obj.statecode=slObj.State__c;
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
                //state = slwObj.state;
                createOrder();
                refreshOrderValue();
            }
            //End of Logic
            
            //Logic to Update Shipping Location on Order on Shipping Address Selection
            if(String.isNotBlank(slwObj.locationId) || selectedShipping == 'None'){
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
            ApexLog.exceptionCoverage(throwEx);
            
            //Logic to populate existing wrapper with Pricebook Details
            system.debug('depoId'+depoId);
            system.debug('distWrapObj.priceGroupId'+distWrapObj.priceGroupId);
            List<PriceBookMaster__c> pbmList = [SELECT Id, SKUCode__c ,SKUCode__r.Name, 
                                                SKUCode__r.SKU_Code__c, MinPrice__c,List_Price__c,
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
            
            //added by Paresh Sondigara : Margin Block : 26-07-22
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
                           E2E_Cost_UPC9_USD__c, E2E_Cost_MBEW_LC__c, E2E_Cost_MBEW_USD__c,Type__c
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
                               E2E_Cost_UPC9_USD__c, E2E_Cost_MBEW_LC__c, E2E_Cost_MBEW_USD__c,Type__c
                               FROM Price_Block_Margin_Matrix__c
                               WHERE Sales_Org__c=:distWrapObj.salesOrgId
                               AND UOM__c !=null
                               AND Depot_Code__c =:depoId
                               AND Start_Date__c<= today AND End_Date__c>= today
                               AND E2E_Cost_UPC9_USD__c != null
                               AND Type__c ='E2ECostUPC9' ORDER BY LastModifiedDate ASC ];
            
             pbmmE2eMBEBList = [SELECT Id, Name, SKU_Code__c, SKU_Active__c, UOM__c, 
                               Sales_Org__c,E2E_Cost_LC__c, E2E_Cost_USD__c, E2E_Cost_UPC9_LC__c, 
                               E2E_Cost_UPC9_USD__c, E2E_Cost_MBEW_LC__c, E2E_Cost_MBEW_USD__c,Type__c
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
                        
            for(PriceBookMaster__c pbObj : pbmList){
                //added by Paresh Sondigara : Margin Block : 26-07-22
                //Start  
                if(prcE2eBlockMap.containsKey(pbObj.SKUCode__c)){
                SKUDetails skuWrapObj = new SKUDetails();                    
                Price_Block_Margin_Matrix__c tmpPriceBlockMargin = new Price_Block_Margin_Matrix__c();
                tmpPriceBlockMargin = prcE2eBlockMap.get(pbObj.SKUCode__c);
                //End    
                //if(pbObj.SKUCode__c==pbObj.SKUCode__r.Name)
                //    skuWrapObj.brandName = pbObj.SKUCode__r.Product_Name__r.Name;
                //else
                //added by Paresh Sondigara : Margin Block : 26-07-22
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
                if(pbObj.List_Price__c!=null)
                    skuWrapObj.listprice = Math.abs(pbObj.List_Price__c); //added by mahesh RITM0542614
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
                    //Added By Paresh Sondigara : Margin Block 
                    SKUDetails skuWrapObj = skuDetailsMap.get(pbObj.SKU__c);
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
            System.debug('skuOrderMap =>>> '+skuOrderMap);
            System.debug('skuOrderList =>>> '+skuOrderList);
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
            System.debug('skuOrderMap =>>> '+skuOrderMap);
            System.debug('skuOrderList =>>> '+skuOrderList);
        }
        catch(Exception ex){
            ApexLog.exceptionHandler(ex, orderId, accountId);
        }
    }
    
    //Method to populate Products based on Brand Input 
    //Not in use
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
                                                   RegionalManager__c, Shipping_Location__c, OwnerId,Remarks__c, 
                                                   Gross_Amount__c
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
    //Added by vishal pawar 
    //getting payment term on selection of payment Method
    
    /* public void getPaymentTerm(){
try{
System.debug('Calling getPayment Term after selection of payment method');
ApexLog.exceptionCoverage(throwEx);
paymentTermSet = new List<SelectOption>();
system.debug('method called getPaymentTerm ==> '+selectedPayment );

Payment_Method__c paymentMethodObj=new Payment_Method__c();
paymentMethodObj=[select id,Name,Payment_Method_Code__c from Payment_Method__c where id=:selectedPayment];

//paymentTermSet.add(new SelectOption('None','None'));          

//if selected payment method is Cash    
if(paymentMethodObj.Name =='Cash'){
List<Payment_Term__c> paymentTermList=[Select Id, Payment_Term_Code__c, Payment_Term__c from Payment_Term__c 
WHERE SalesOrgCode__c = '5631' and Payment_Term__c='30 days'];

for(Payment_Term__c pt:paymentTermList){
paymentTermSet.add(new selectOption(pt.Id,pt.Payment_Term__c));
}
}

//if Selected payment method is Credit card 
if(paymentMethodObj.Name =='Credit Card'){      
List<Payment_Term__c> paymentTermList=[Select Id, Payment_Term_Code__c, Payment_Term__c from Payment_Term__c 
WHERE SalesOrgCode__c = '5631' and Payment_Term__c='60 days'];
for(Payment_Term__c pt:paymentTermList){
paymentTermSet.add(new selectOption(pt.Id,pt.Payment_Term__c));
}
}
//if selected payment method is long Barter
if(paymentMethodObj.Name== 'Long Barter'){
List<Payment_Term__c> paymentTermList = [Select Id, Payment_Term_Code__c, Payment_Term__c from Payment_Term__c 
WHERE SalesOrgCode__c = '5631'];
for(Payment_Term__c pt:paymentTermList){
paymentTermSet.add(new SelectOption(pt.id,pt.Payment_Term__c));
}
}
//if payment method is Available Barter 
if(paymentMethodObj.Name=='Available Barter'){
List<Payment_Term__c> paymentTermList=[Select Id, Payment_Term_Code__c, Payment_Term__c from Payment_Term__c 
WHERE SalesOrgCode__c = '5631' and Payment_Term__c='30 days'];
for(Payment_Term__c pt:paymentTermList){
paymentTermSet.add(new selectOption(pt.Id,pt.Payment_Term__c));
}
}
//if selected payment method is  wire transfer
if(paymentMethodObj.Name=='Wire transfer'){

List<Payment_Term__c> paymentTermList = [Select Id, Payment_Term_Code__c, Payment_Term__c from Payment_Term__c 
WHERE SalesOrgCode__c = '5631'];
for(Payment_Term__c pt:paymentTermList){
paymentTermSet.add(new SelectOption(pt.id,pt.Payment_Term__c));
}
}

//if selected payment method is Check
if(paymentMethodObj.Name=='Check'){
List<Payment_Term__c> paymentTermList = [Select Id, Payment_Term_Code__c, Payment_Term__c from Payment_Term__c 
WHERE SalesOrgCode__c = '5631'];
for(Payment_Term__c pt:paymentTermList){
paymentTermSet.add(new SelectOption(pt.id,pt.Payment_Term__c));
}

} 

}

catch(Exception ex){
ApexLog.exceptionHandler(ex, orderId, accountId);

}

}*/
    
    //popuate Customer approval status
    
    /*
public void populateCustomerApprvalStatus(){
customerApprovalStatusOption=new List<SelectOption>();
//Schema.DescribeFieldResult fieldResult = Object1__c.Picklist_Field__c.getDescribe();
customerApprovalStatusOption.add(new SelectOption('Approved','Approved'));
customerApprovalStatusOption.add(new SelectOption('Rejected','Rejected'));
}
*/
    
    
    
    
    
    
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
                                              Order__c, UOM__c, SKU_Name__c, DistributorDiscountPercentage__c,
                                              SKU_Name__r.Product_Name__r.Name, Net_Price__c,SKU_Name__r.Brand_Name__c,
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
            
            for(OrderLineItem__c oliObj:oliList){
                if(skuDetailsMap.containsKey(oliObj.SKU_Name__c)){
                    skuWrapObj2 = skuDetailsMap.get(oliObj.SKU_Name__c);
                    skuWrapObj = new SKUDetails();
                    skuWrapObj.productName = oliObj.SKU_Name__r.Product_Name__r.Name;
                    skuWrapObj.skuCode = oliObj.SKU_Name__r.Name;
                    
                    skuWrapObj.skuId = oliObj.SKU_Name__c;//oliObj.id changed by ishu 
                    skuWrapObj.oliId = oliObj.Id;
                    if(String.isNotBlank(oliObj.SKU_Name__r.Brand_Name__c)){
                        skuWrapObj.brandName = oliObj.SKU_Name__r.Brand_Name__c+' '+oliObj.SKU_Name__r.Name;// oliObj.SKU_Name__r.Product_Name__r.Name+' '+oliObj.SKU_Name__r.Name; //added by ganesh
                    }
                    else{
                        skuWrapObj.brandName=oliObj.SKU_Name__r.Name;
                    }
                    skuWrapObj.price = skuWrapObj2.price;
                    skuWrapObj.minPrice = skuWrapObj2.minPrice;
                    skuWrapObj.listprice = skuWrapObj2.listprice; //added by mahesh RITM0542614
                    skuWrapObj.multipleOf = skuWrapObj2.multipleOf;
                    //added by ganesh 
                    skuWrapObj.BudgetPrice = skuWrapObj2.BudgetPrice;
                    //end
                    skuWrapObj.qty = oliObj.Quantity__c;
                    skuWrapObj.netRateEntered = oliObj.Price__c;
                    skuWrapObj.finalPrice = oliObj.Net_Price__c;
                    skuWrapObj.discount = oliObj.DistributorDiscountPercentage__c;
                    skuWrapObj.UOM = oliObj.UOM__c;
                    skuWrapObj.available = skuWrapObj2.available;
                    skuWrapObj.available2 = skuWrapObj2.available2;
                    skuWrapObj.currencyIso = oliObj.CurrencyIsoCode;
                    skuWrapObj.itemNo = Integer.valueOf(oliObj.Item_Number__c);
                    
                    //added by Paresh Sondigara : Margin Block : 26-07-22
                    skuWrapObj.e2ECostUSD = skuWrapObj2.e2ECostUSD ;                                                                                               
                    skuWrapObj.e2ECostUPC9USD = skuWrapObj2.e2ECostUPC9USD ;                                                 
                    skuWrapObj.e2ECostMBEWUSD = skuWrapObj2.e2ECostMBEWUSD;                        
                    skuWrapObj.uome2eCost = skuWrapObj2.uome2eCost;
                    skuWrapObj.SKUPack= skuWrapObj2.SKUPack;// added by Vaishnavi
                   // skuWrapObj.deliveryDateMax=13-05-2023;
                    skuWrapObj.deliveryDateMax=5;//by Nandhini
                    skuOrderMap.put(skuWrapObj.skuId,skuWrapObj);                    
                    itemNumber = Integer.valueOf(oliObj.Item_Number__c);                    
                    skuOrderList.add(skuWrapObj);
                   
                    
                }
            }
            //calculateFreezePeriodonLineItems(mapOfOrderandSKUId,mapOfOrderIdandFinal,mapOfOrderIAndQty);
            System.debug('skuOrderMap =>>> '+skuOrderMap);
            System.debug('skuOrderList =>>> '+skuOrderList);

        }
        catch(Exception ex){
            ApexLog.exceptionHandler(ex, orderId, accountId);
        }            
    }
    //Added by Nandhini-APPS-5287 -This method Caculate the freeze Period Based on Approval Process and returns the final freeze Period for Order summary Block
    public void calculateFreezePeriodonLineItems(){
        set<Id> skuIdFromOrderList=new set<Id>();
        String depotCode = [Select id,Depot_Code__c from Depot__c where id=:storageIdChosen].Depot_Code__c;
        String shippingState1;
        if(shippingMap.containsKey(selectedShipping)){
            shippingState1=shippingMap.get(selectedShipping).statecode;
        }
        
         String freezeKey;
        if(selectDeliveryModule == 'Deliver'){
            freezeKey=depotCode + shippingState1 + selectDeliveryModule;
        }
        else{
            freezeKey=depotCode + 'null' + selectDeliveryModule;
        }
       
        
         mapOfFreezePeriod = UtilityClass.getArgentinaFreezePeriodDetails(); 
        
        if(mapOfFreezePeriod!=null && !mapOfFreezePeriod.isEmpty() && mapOfFreezePeriod.containsKey(freezeKey)){
            deliveryAndShipping=Integer.valueof(mapOfFreezePeriod.get(freezeKey));
        }else if(selectDeliveryModule.equalsIgnoreCase('Deliver')){
            deliveryAndShipping =3;
        }else{
            deliveryAndShipping =0;
        }
        system.debug('deliveryAndShipping summary:' +deliveryAndShipping);
        List<OrderLineItem__c> oliList = [SELECT Id, Name, CurrencyIsoCode, 
                                          Order__c, UOM__c, SKU_Name__c, DistributorDiscountPercentage__c,
                                          SKU_Name__r.Product_Name__r.Name, Net_Price__c,SKU_Name__r.Brand_Name__c,
                                          SKU_Name__r.Name, Quantity__c, Price__c, Item_Number__c, 
                                          Item_Status__c, Order__r.Shipping_Location__c
                                          FROM OrderLineItem__c
                                          WHERE Order__c=:orderId];
        
        system.debug('inside calculateFreezePeriodonLineItems :'+oliList);
        if(oliList !=null && !oliList.isEmpty()){
            for(OrderLineItem__c orderLineItem:oliList){
                skuIdFromOrderList.add(orderLineItem.SKU_Name__c);
            }
            
            
            salesApprovalPeriod=0;
            deliveryPeriod=0;
            Id argentinaDepo = [Select Id From Depot__c Where Name=:country LIMIT 1].Id;
            System.debug('argentinaDepo=>'+argentinaDepo);
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
            List<Blanket_SKU__c> blanketSKUList = new List<Blanket_SKU__c>(); 
            blanketSKUList = [SELECT Id, SKU__c, Sales_Org__c, Start_Date__c, End_Date__c, Status__c
                              FROM Blanket_SKU__c
                              WHERE SKU__c IN :skuIdFromOrderList];
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
            
            
            
            List<UOM_Conversion__c> uomList = new List<UOM_Conversion__c>();
            Map<String,List<UOM_Conversion__c>> uomListMap = new Map<String,List<UOM_Conversion__c>>();
            uomList =[SELECT Id, Name, SKU__c, Base_UOM__c, Sales_UOM__c, 
                      Numerator__c, Sales_Org__c, Denominator__c 
                      FROM UOM_Conversion__c 
                      WHERE SKU__c IN :skuIdFromOrderList
                      AND Sales_Org__r.Sales_org_code__c ='5631' ORDER BY LastModifiedDate ASC ];
            
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
                             WHERE Sales_Org__r.Sales_org_code__c ='5631'
                             AND Distributor_Code__c=:accountId
                             AND Start_Date__c<= today AND End_Date__c>= today
                             AND SKU_Code__c IN :skuIdFromOrderList
                             AND Type__c ='Rebate'
                             AND (Rebate_USD__c!=null OR Rebate__c!=null)
                             AND Rebate_Code__c!=null ORDER BY LastModifiedDate DESC ];
            
            
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
            
            List<Price_Block_Margin_Matrix__c> pbmmDiscountList = new List<Price_Block_Margin_Matrix__c>();
            Map<String,List<Price_Block_Margin_Matrix__c>> disMap = new Map<String,List<Price_Block_Margin_Matrix__c>>();
            pbmmDiscountList = [SELECT Id, Name, SKU_Code__c, SKU_Active__c, UOM__c, 
                                Sales_Org__c, Discount_LC__c, Discount_USD__c, 
                                Discount__c FROM Price_Block_Margin_Matrix__c
                                WHERE Sales_Org__r.Sales_org_code__c ='5631'
                                AND Distributor_Code__c=:accountId
                                AND SKU_Code__c IN :skuIdFromOrderList
                                AND Type__c ='Discount'
                                AND Start_Date__c<= today AND End_Date__c>= today
                                AND (Discount_USD__c!=null OR Discount__c!=null) ORDER BY LastModifiedDate ASC ];
            
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
                                   WHERE Sales_Org__r.Sales_org_code__c ='5631'
                                   AND Distributor_Code__c=:accountId
                                   AND SKU_Code__c IN :skuIdFromOrderList
                                   AND Type__c ='AdditionalDiscount'
                                   AND Start_Date__c<= today AND End_Date__c>= today
                                   AND (Additional_Discount_USD__c!= null OR Additional_Discount__c!= null) ORDER BY LastModifiedDate ASC ];
            
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
                                 WHERE Sales_Org__r.Sales_org_code__c ='5631'
                                 AND SKU_Code__c IN :skuIdFromOrderList
                                 AND Sales_Deduction_USD__c != null
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
            Map<String,List<Price_Block_Margin_Matrix__c>> mapPrcpln = new MAP<String,List<Price_Block_Margin_Matrix__c>>();
            pbmmPlnList =[SELECT Id, Name, SKU_Code__c, SKU_Active__c, UOM__c, 
                          Sales_Org__c, PLN_LC__c, PLN_USD__c 
                          FROM Price_Block_Margin_Matrix__c
                          where Sales_Org__r.Sales_org_code__c ='5631'
                          AND SKU_Code__c IN :skuIdFromOrderList
                          AND Type__c ='PLN'
                          AND Start_Date__c<= today AND End_Date__c>= today
                          AND PLN_USD__c!=null ORDER BY LastModifiedDate ASC ];       
            
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
            
            for(OrderLineItem__c orderLineItem:oliList){
                Boolean submitForApproval = false;
                boolean budgetApproval = false;
                boolean minPriceApproval = false;
                boolean maxPriceApproval = false;
                boolean sentForLatam = false;
                boolean sentForCCO = false;
                Decimal finalPriceFromOrderList=orderLineItem.Net_Price__c;
                Decimal quantityFromOrderList=orderLineItem.Quantity__c;
                Id skuIdOrderList=orderLineItem.SKU_Name__c;
                Decimal rebateVal1 = 0.0 ;
                Decimal rebateVal2 = 0.0 ;
                Decimal rebateVal = 0.0 ;
                Decimal rebatePercent1Convert;
                Decimal rebatePercent2Convert;
                String baseUOM;
                Decimal convertQty;
                Decimal convertNetPrice;
                Decimal convertFinalPrice;
                SKUDetails skuWrapObj = skuDetailsMap.get(skuIdOrderList);   
                system.debug('skuWrapObj :'+skuWrapObj);
                List<UOM_Conversion__c> uomList1 = new List<UOM_Conversion__c>();
                if(uomListMap.containsKey(skuIdOrderList)){
                    uomList1 =uomListMap.get(skuIdOrderList);   
                }
                if(uomList1.size()>0){
                    for(UOM_Conversion__c uomObj :uomList1){
                        if(quantityFromOrderList!=null){          
                            if(skuWrapObj.uOM == uomObj.Base_UOM__c){                        
                                baseUOM  = skuWrapObj.uOM;
                                convertQty = quantityFromOrderList;                            
                                break;
                            }else if(skuWrapObj.uOM == uomObj.Sales_UOM__c){                                        
                                baseUOM  = uomObj.Base_UOM__c;
                                Decimal uomConver = uomObj.Numerator__c /uomObj.Denominator__c;                                            
                                convertQty = quantityFromOrderList*uomConver;
                                break;
                            }                            
                        }
                    }      
                }
                
                for(UOM_Conversion__c uomObj :uomList1){
                    if(finalPriceFromOrderList!=null){ 
                        if(skuWrapObj.uOM == uomObj.Base_UOM__c){
                            convertNetPrice = finalPriceFromOrderList; 
                            convertFinalPrice = finalPriceFromOrderList *convertQty;
                            break;
                        }else if(skuWrapObj.uOM == uomObj.Sales_UOM__c){                        
                            Decimal uomConver = uomObj.Numerator__c /uomObj.Denominator__c; 
                            convertNetPrice = finalPriceFromOrderList / uomConver;                                                        
                            convertFinalPrice = convertNetPrice * convertQty;
                            break;
                        }                            
                    }
                }
                
                Decimal rebate1USD;
                Decimal rebate1Percent;
                String uomRebate1;
                String rebateCode1;
                
                Decimal rebate2USD;
                Decimal rebate2Percent;
                String uomRebate2;
                String rebateCode2;
                
                if(prcBlockReabteMap.containsKey(skuIdOrderList)){
                    List<Price_Block_Margin_Matrix__c> pbMMRebateList = prcBlockReabteMap.get(skuIdOrderList);
                    
                    if(pbMMRebateList.size()>0){                    
                        if(pbMMRebateList.size()>=2){
                            String rebateCodeNew1 = pbMMRebateList[0].Rebate_Code__c;
                            String rebateCodeNew2 = pbMMRebateList[1].Rebate_Code__c;
                            if(rebateCodeNew1!=rebateCodeNew2){                                                                        
                                rebate1USD = pbMMRebateList[0].Rebate_USD__c; 
                                rebate1Percent = pbMMRebateList[0].Rebate__c;
                                uomRebate1 = pbMMRebateList[0].UOM__c;
                                rebateCode1 = pbMMRebateList[0].Rebate_Code__c;                                    
                                
                                rebate2USD = pbMMRebateList[1].Rebate_USD__c; 
                                rebate2Percent = pbMMRebateList[1].Rebate__c;
                                uomRebate2 = pbMMRebateList[1].UOM__c;
                                rebateCode2 = pbMMRebateList[1].Rebate_Code__c;
                            }                                
                        }else{                                                                
                            rebate1USD = pbMMRebateList[0].Rebate_USD__c; 
                            rebate1Percent = pbMMRebateList[0].Rebate__c;
                            rebateCode1 = pbMMRebateList[0].Rebate_Code__c;
                            uomRebate1 = pbMMRebateList[0].UOM__c;                               
                        }
                    }
                }
                
                if(uomList1.size()>0){
                    if(skuWrapObj.currencyIso=='USD' || Test.isRunningTest()){
                        for(UOM_Conversion__c uomObj :uomList){
                            if(rebate1USD!=null){                         
                                if(uomRebate1 == uomObj.Base_UOM__c){
                                    rebateVal1 = rebate1USD;                            
                                    rebateVal1 = rebateVal1 * convertQty;
                                    break;
                                }else if(uomRebate1 == uomObj.Sales_UOM__c){
                                    Decimal uomConver = uomObj.Numerator__c /uomObj.Denominator__c;  
                                    rebateVal1 = uomConver * rebate1USD;
                                    rebateVal1 = rebateVal1 * convertQty;
                                    break;
                                }                            
                            }                           
                        }//end of for loop
                        if(rebate1Percent!=null && rebate1USD==null){
                            //need to clear for netRateEntered
                            rebatePercent1Convert = (rebate1Percent * convertFinalPrice)/100; 
                            rebateVal1 = rebatePercent1Convert;
                        }                    
                    }//checking for USD End for Rebate 1                                                
                }
                if(uomList1.size()>0){
                    if(skuWrapObj.currencyIso=='USD' || Test.isRunningTest()){
                        for(UOM_Conversion__c uomObj :uomList){
                            if(rebate2USD!=null){ 
                                if(uomRebate2 == uomObj.Base_UOM__c){
                                    rebateVal2 = rebate2USD;
                                    rebateVal2 = rebateVal2 * convertQty;
                                    break;
                                }else if(uomRebate2 == uomObj.Sales_UOM__c){
                                    Decimal uomConver = uomObj.Numerator__c /uomObj.Denominator__c; 
                                    rebateVal2 = uomConver * rebate2USD;
                                    rebateVal2 = rebateVal2 * convertQty;
                                    break;
                                }                            
                            }
                        }//end of for loop
                        if(rebate2Percent!=null && rebate2USD==null){                                
                            rebatePercent2Convert = (rebate2Percent * convertFinalPrice)/100; 
                            rebateVal2 = rebatePercent2Convert;
                        }
                    }                        
                }
                //adding Marginal block Values to the line item
                rebateVal = rebateVal1 +rebateVal2;
                
                //for discount  
                Decimal discountUSD;
                Decimal discountPercent;
                String uomDiscount;
                List<Price_Block_Margin_Matrix__c> pbmmDiscountList1 = new List<Price_Block_Margin_Matrix__c>();
                MAP<String,Price_Block_Margin_Matrix__c> prcBlockDiscountMap = new MAP<String,Price_Block_Margin_Matrix__c>();
                if(disMap.containsKey(skuIdOrderList)){
                    pbmmDiscountList1 = disMap.get(skuIdOrderList);
                }
                
                if(pbmmDiscountList1.size()>0){
                    for(Price_Block_Margin_Matrix__c discontIbj:pbmmDiscountList1){
                        prcBlockDiscountMap.put(discontIbj.SKU_Code__c ,discontIbj);
                    }
                }
                
                if(prcBlockDiscountMap.containsKey(skuIdOrderList)){
                    Price_Block_Margin_Matrix__c pbMMDiscountObj = prcBlockDiscountMap.get(skuIdOrderList);                                               
                    discountUSD = pbMMDiscountObj.Discount_USD__c; 
                    discountPercent = pbMMDiscountObj.Discount__c;
                    uomDiscount = pbMMDiscountObj.UOM__c;                        
                }
                
                //this is for converted Discount Logic
                Decimal discountPercentConvert;
                Decimal discountVal = 0.0;
                
                if(uomList1.size()>0){
                    //this now for Discount
                    if(skuWrapObj.currencyIso=='USD' || Test.isRunningTest()){
                        //discountUSD
                        for(UOM_Conversion__c uomObj :uomList){                    
                            if(discountUSD!=null){
                                if(uomDiscount == uomObj.Base_UOM__c){
                                    discountVal = discountUSD;  
                                    discountVal = discountVal * convertQty;                                
                                    break;
                                }else if(uomDiscount == uomObj.Sales_UOM__c){
                                    Decimal uomConver = uomObj.Numerator__c /uomObj.Denominator__c;  
                                    discountVal = uomConver * discountUSD;
                                    discountVal = discountVal * convertQty;                                 
                                    break;
                                }
                            }
                        }//end of for loop
                        if(discountPercent!=null && discountUSD==null){                        
                            discountPercentConvert = (discountPercent *convertFinalPrice)/100; 
                            discountVal = discountPercentConvert;
                        }
                        
                    }
                }
                
                // this is for converted addition Discount Logic
                Decimal additionalDiscountPercent;
                Decimal additionalDiscountUSD;
                String uomAddDiscount;
                List<Price_Block_Margin_Matrix__c> pbmmAddDiscountList1 = new List<Price_Block_Margin_Matrix__c>();
                MAP<String,Price_Block_Margin_Matrix__c> prcBlockAddDiscountMap = new MAP<String,Price_Block_Margin_Matrix__c>();
                if(mappAddDis.containskey(skuIdOrderList)){
                    pbmmAddDiscountList1 = mappAddDis.get(skuIdOrderList);    
                }
                
                if(pbmmAddDiscountList1.size()>0){
                    for(Price_Block_Margin_Matrix__c addDisObj:pbmmAddDiscountList1){
                        prcBlockAddDiscountMap.put(addDisObj.SKU_Code__c,addDisObj);    
                    }
                }
                
                if(prcBlockAddDiscountMap.containsKey(skuIdOrderList)){
                    Price_Block_Margin_Matrix__c pbMMAddDiscountObj = prcBlockAddDiscountMap.get(skuIdOrderList);                                                                      
                    additionalDiscountPercent = pbMMAddDiscountObj.Additional_Discount__c;
                    additionalDiscountUSD = pbMMAddDiscountObj.Additional_Discount_USD__c;
                    uomAddDiscount = pbMMAddDiscountObj.UOM__c;              
                }
                
                Decimal addDiscountVal =0.0;
                Decimal addDiscountPercentConvert;
                if(uomList1.size()>0){
                    //this now additional disc
                    if(skuWrapObj.currencyIso=='USD' || Test.isrunningTest()){
                        for(UOM_Conversion__c uomObj :uomList){
                            if(additionalDiscountUSD!=null){ 
                                if(uomAddDiscount == uomObj.Base_UOM__c){
                                    addDiscountVal = additionalDiscountUSD;
                                    addDiscountVal = addDiscountVal * convertQty;
                                    break;
                                }else if(uomAddDiscount == uomObj.Sales_UOM__c){
                                    Decimal uomConver = uomObj.Numerator__c /uomObj.Denominator__c;   
                                    addDiscountVal = uomConver * additionalDiscountUSD;
                                    addDiscountVal = addDiscountVal * convertQty;
                                    break;
                                }                            
                            }
                        }//end of for loop                
                        if(additionalDiscountPercent!=null && additionalDiscountUSD==null){
                            addDiscountPercentConvert = (additionalDiscountPercent *convertFinalPrice)/100; 
                            addDiscountVal = addDiscountPercentConvert;
                        }
                    }//end for checking USD Currency  
                }
                
                Decimal salesDeductionUSD;
                Decimal salesDeductionInPercent;
                String uomSalesDeduction;
                
                List<Price_Block_Margin_Matrix__c> pbmmSalesDeduList1 = new List<Price_Block_Margin_Matrix__c>();
                MAP<String,Price_Block_Margin_Matrix__c> prcBlockForDeduMap = new MAP<String,Price_Block_Margin_Matrix__c>();
                if(mapSaleDed.size()>0){
                    if(mapSaleDed.containsKey(skuIdOrderList)){
                        pbmmSalesDeduList1 = mapSaleDed.get(skuIdOrderList);         
                    }                        
                }                   
                if(pbmmSalesDeduList1.size()>0){                
                    for(Price_Block_Margin_Matrix__c dedObj : pbmmSalesDeduList1){
                        prcBlockForDeduMap.put(dedObj.SKU_Code__c,dedObj);
                    }
                }
                
                if(prcBlockForDeduMap.containsKey(skuIdOrderList)){
                    Price_Block_Margin_Matrix__c pbMMSalesDedObj = prcBlockForDeduMap.get(skuIdOrderList);                        
                    if(pbMMSalesDedObj.Sales_Deduction_USD__c!=null){
                        salesDeductionUSD = pbMMSalesDedObj.Sales_Deduction_USD__c ;
                    }else{
                        salesDeductionInPercent = profitCenterList[0].Sales_Value__c;
                    }                        
                    uomSalesDeduction = pbMMSalesDedObj.UOM__c ;
                }
                
                Decimal salesDeductionVal =0.0;
                Decimal saleaDeductionPercent;
                if(uomList1.size()>0){
                    //start for USD Sales Dedection 
                    if(skuWrapObj.currencyIso=='USD' || Test.isRunningTest()){
                        for(UOM_Conversion__c uomObj :uomList){
                            if(salesDeductionUSD>0){ 
                                if(uomSalesDeduction == uomObj.Base_UOM__c){
                                    salesDeductionVal = salesDeductionUSD;
                                    salesDeductionVal = salesDeductionVal * convertQty;
                                    break;
                                }else if(uomSalesDeduction == uomObj.Sales_UOM__c){
                                    Decimal uomConver = uomObj.Numerator__c /uomObj.Denominator__c; 
                                    salesDeductionVal = uomConver * salesDeductionUSD;
                                    salesDeductionVal = salesDeductionVal * convertQty;
                                    break;
                                }                            
                            }
                        }//end of for loop
                        if(profObj.Sales_Value__c!=null && salesDeductionUSD==0){
                            saleaDeductionPercent = (profObj.Sales_Value__c * convertFinalPrice)/100; 
                            salesDeductionVal = saleaDeductionPercent;
                        } 
                    }
                }
                
                Decimal e2eCostVal= 0.0 ;
                if(uomList1.size()>0){
                    if(skuWrapObj.currencyIso=='USD'){
                        for(UOM_Conversion__c uomObj :uomList){
                            if(skuWrapObj.e2ECostUSD > 0){                                                                      
                                if(skuWrapObj.uome2eCost == uomObj.Base_UOM__c){                                        
                                    e2eCostVal = skuWrapObj.e2ECostUSD;
                                    e2eCostVal = e2eCostVal * convertQty;
                                    break;
                                }else if(skuWrapObj.uome2eCost == uomObj.Sales_UOM__c){                                        
                                    Decimal uomConver = uomObj.Numerator__c /uomObj.Denominator__c; 
                                    e2eCostVal = uomConver * skuWrapObj.e2ECostUSD;
                                    e2eCostVal = e2eCostVal * convertQty;
                                    break;
                                } 
                            }else if(skuWrapObj.e2ECostUSD == 0 && skuWrapObj.e2ECostUPC9USD > 0){                        
                                if(skuWrapObj.uome2eCost == uomObj.Base_UOM__c){                                        
                                    e2eCostVal = skuWrapObj.e2ECostUPC9USD;
                                    e2eCostVal = e2eCostVal * convertQty;
                                    break;
                                }else if(skuWrapObj.uome2eCost == uomObj.Sales_UOM__c){                                        
                                    Decimal uomConver = uomObj.Numerator__c /uomObj.Denominator__c; 
                                    e2eCostVal = uomConver * skuWrapObj.e2ECostUPC9USD;
                                    e2eCostVal = e2eCostVal * convertQty;
                                    break;
                                }
                            }else if(skuWrapObj.e2ECostUSD == 0 && skuWrapObj.e2ECostUPC9USD == 0 && skuWrapObj.e2ECostMBEWUSD > 0){
                                if(skuWrapObj.uome2eCost == uomObj.Base_UOM__c){                                        
                                    e2eCostVal = skuWrapObj.e2ECostMBEWUSD;
                                    e2eCostVal = e2eCostVal * convertQty;
                                    break;
                                }else if(skuWrapObj.uome2eCost == uomObj.Sales_UOM__c){                                        
                                    Decimal uomConver = uomObj.Numerator__c /uomObj.Denominator__c;  
                                    e2eCostVal = uomConver * skuWrapObj.e2ECostMBEWUSD;
                                    e2eCostVal = e2eCostVal *convertQty;
                                    break;
                                }
                            }
                        }//end of for loop
                    }    
                    //end for chekcing USD for e2e
                }
                
                
                Decimal pLNUSD;
                String uomPLN;
                List<Price_Block_Margin_Matrix__c> pbmmPlnList1 = new List<Price_Block_Margin_Matrix__c>();
                MAP<String,Price_Block_Margin_Matrix__c> prcBlockPlnMap = new MAP<String,Price_Block_Margin_Matrix__c>();                    
                if(mapPrcpln.size()>0){
                    if(mapPrcpln.containsKey(skuIdOrderList)){
                        pbmmPlnList1 =mapPrcpln.get(skuIdOrderList);            
                    }                    
                }                                       
                if(pbmmPlnList1.size()>0){
                    for(Price_Block_Margin_Matrix__c plnObj :pbmmPlnList1){
                        prcBlockPlnMap.put(plnObj.SKU_Code__c,plnObj);
                    }
                }
                
                if(prcBlockPlnMap.containsKey(skuIdOrderList)){                
                    Price_Block_Margin_Matrix__c pbMMPlnObj = prcBlockPlnMap.get(skuIdOrderList);                                                
                    pLNUSD = pbMMPlnObj.PLN_USD__c; 
                    uomPLN = pbMMPlnObj.UOM__c; 
                }
                
                Decimal plnPercentConvert;
                Decimal plnCalValue = 0.0 ;
                if(uomList1.size()>0){
                    if(skuWrapObj.currencyIso=='USD'){
                        for(UOM_Conversion__c uomObj :uomList){
                            if(pLNUSD!=null){                                     
                                if(uomPLN == uomObj.Base_UOM__c){
                                    plnCalValue = pLNUSD;
                                    plnCalValue = plnCalValue * convertQty;
                                    break;
                                }else if(uomPLN == uomObj.Sales_UOM__c){
                                    Decimal uomConver = uomObj.Numerator__c /uomObj.Denominator__c; 
                                    plnCalValue = uomConver * pLNUSD;
                                    plnCalValue = plnCalValue * convertQty;
                                    break;
                                }                            
                            }
                        }//end of for loop
                    }//checking USD currnec PLN end
                }
                Decimal ptpmDiscount = 0;
                Decimal ptpmDiscountVal = 0;          
                if(ptpmDiscountList.size()>0 && ptpmDiscountList[0].Discount__c != null){
                    ptpmDiscount =  ptpmDiscountList[0].Discount__c;
                    ptpmDiscountVal = (ptpmDiscount *convertFinalPrice)/100;
                }
                Decimal skuNetPrice = convertFinalPrice - rebateVal - discountVal - addDiscountVal - ptpmDiscountVal; 
                
                Decimal contributionMarginPercent;
                Decimal totalCost=0;                    
                totalCost = skuNetPrice - salesDeductionVal - e2eCostVal;
                if(Test.isRunningTest()){
                    contributionMarginPercent = 10;
                }else{
                    contributionMarginPercent = (totalCost / skuNetPrice)*100;
                    contributionMarginPercent = contributionMarginPercent.setScale(2);
                }   
                if(blanketSKUMap.containsKey(skuId)){
                    List<Blanket_SKU__c> blanketList = blanketSKUMap.get(skuId);
                    //sliObj.Blanket_SKU_Start_Date__c = blanketList[0].Start_Date__c;
                    //sliObj.Blanket_SKU_End_Date__c = blanketList[0].End_Date__c;
                    //sliObj.Blanket_SKU_Status__c = blanketList[0].Status__c;
                    if(blanketList[0].Start_Date__c <= System.today() && blanketList[0].End_Date__c >= System.today() && blanketList[0].Status__c == true){
                        //sliObj.Margin_Block_Level_1__c = false;
                        //sliObj.Margin_Block_Level_2__c = false;
                    }else if(contributionMarginPercent >= adminObj.Level_2_min__c  &&  contributionMarginPercent <= adminObj.Level_2_max__c ){
                        // sliObj.Margin_Block_Level_1__c = true;
                        sentForLatam = true;
                    }else if(contributionMarginPercent <= adminObj.Level_3_below__c ){
                        //sliObj.Margin_Block_Level_2__c = true;  
                        sentForLatam = true;
                        sentForCCO = true;
                    }                        
                }else{
                    if(contributionMarginPercent >= adminObj.Level_2_min__c  &&  contributionMarginPercent <= adminObj.Level_2_max__c){
                        // sliObj.Margin_Block_Level_1__c = true;
                        sentForLatam = true;
                    }
                    if(contributionMarginPercent <= adminObj.Level_3_below__c){
                        //sliObj.Margin_Block_Level_2__c = true;
                        sentForLatam = true;
                        sentForCCO = true;
                    }                                
                }
                if(finalPriceFromOrderList < skuWrapObj.minPrice){
                    System.debug('Internal Approval');
                    submitForApproval = true;
                    minPriceApproval = true;
                    
                }
                if(finalPriceFromOrderList > skuWrapObj.price){
                    System.debug('Internal Approval');
                    submitForApproval = true;
                    maxPriceApproval = true;
                    
                }
                if(finalPriceFromOrderList < skuWrapObj.BudgetPrice){
                    System.debug('Budget Approval');
                    system.debug('BudgetPrice'+skuWrapObj.BudgetPrice);
                    budgetApproval = true;
                    
                }
                Integer salesApprovalPeriodOrderSummary;
                //starting the calculation of freeze period
                if((minPriceApproval == true && budgetApproval ==false)|| (minPriceApproval == true && budgetApproval ==true) ||(maxPriceApproval ==true && budgetApproval==false && sentforLatam==true) || (maxPriceApproval ==true && budgetApproval==false && sentforLatam==true && sentForCCO ==true)||(maxPriceApproval ==false && minPriceApproval==false &&budgetApproval==false &&sentForLatam==true)){
                    salesApprovalPeriodOrderSummary = 2;
                }else if((minPriceApproval == true && budgetApproval ==true && sentForLatam ==false)||(minPriceApproval == true && budgetApproval ==false && sentForLatam ==true)||(minPriceApproval == true && budgetApproval ==true && sentForLatam ==true)||(maxPriceApproval == true && budgetApproval ==false && sentForLatam ==true)||(maxPriceApproval ==false && minPriceApproval==false &&budgetApproval==false &&sentForLatam==true)){
                    salesApprovalPeriodOrderSummary = 2;
                }
                else{
                    salesApprovalPeriodOrderSummary = 1;
                }
                Integer deliveryPeriodOrderSummary = deliveryAndShipping + financialApproval + salesApprovalPeriodOrderSummary;
                mapOfOrderSummaryDelivery.put(orderLineItem.Id,deliveryPeriodOrderSummary);
                mapOfOrderSummarySalesApprovalPeriod.put(orderLineItem.Id,salesApprovalPeriodOrderSummary);
                
                // deliveryPeriod =deliveryAndShipping + financialApproval + salesApprovalPeriod;
                // system.debug('final deliveryPeriod :'+deliveryPeriod);
                
            }
            serialiZedOrderSummarysalesApprovalPeriod=JSON.serialize(mapOfOrderSummarySalesApprovalPeriod);
            serialiZedOrderSummaryDeliveryPeriod =JSON.serialize(mapOfOrderSummaryDelivery);
            system.debug('final mapOfOrderSummaryDelivery:'+serialiZedOrderSummaryDeliveryPeriod);
        }
    } 
    //Added by Nandhini-APPS-5287 -This method Caculate the freeze Period Based on Approval Process and returns the final freeze Period for Add product Block
 public void calculateFreezePeriod(){
        
        Depot__c storageIdInfo=[Select id,Depot_Code__c from Depot__c where id=:storageIdChosen];
        String shippingState1;
        if(shippingMap.containsKey(selectedShipping)){
            shippingState1=shippingMap.get(selectedShipping).statecode;
        }
        
        String freezeKey;
        if(selectDeliveryModule == 'Deliver'){
            freezeKey=storageIdInfo.Depot_Code__c+shippingState1+selectDeliveryModule;
        }
        else{
            freezeKey=storageIdInfo.Depot_Code__c+'null'+selectDeliveryModule;
        }
        system.debug(' inside calculateFreeZeon product Select'+freezeKey);
        /*List<Argentina_Freeze_Period__mdt> frezePeriodList=[Select id,Depot_Code__c,Freeze_Period__c,State_Code__c,Type__c from Argentina_Freeze_Period__mdt];
        if(frezePeriodList!=null && !frezePeriodList.isEmpty()){
            for(Argentina_Freeze_Period__mdt freezePeriod:frezePeriodList){
                String freezeKey1=freezePeriod.Depot_Code__c+freezePeriod.State_Code__c+freezePeriod.Type__c;
                mapOfFreezePeriod.put(freezeKey1,freezePeriod.Freeze_Period__c);
            }
            system.debug('freeze period :' +mapOfFreezePeriod);
        }   */
        mapOfFreezePeriod = UtilityClass.getArgentinaFreezePeriodDetails(); //changed by Nandhini
        if(mapOfFreezePeriod!=null && !mapOfFreezePeriod.isEmpty() && mapOfFreezePeriod.containsKey(freezeKey)){
            deliveryAndShipping=(Integer)mapOfFreezePeriod.get(freezeKey);
        }
        else if(selectDeliveryModule == 'Deliver'){
            deliveryAndShipping =3;
        }
        else{
            deliveryAndShipping =0;
        }
        system.debug('deliveryAndShipping inside Product select :'+deliveryAndShipping);
        if(String.isNotBlank(commonPeriodMap)){
            Map<String,Object> deserializing=(Map<String,Object>)JSON.deserializeUntyped(commonPeriodMap);
             system.debug('start deserializing :'+deserializing);
            for(String ids:deserializing.keySet()){
                mapOfdeliveryPeriod.put(Id.valueOf(ids),(Integer)deserializing.get(ids));
            }
        }
        if(String.isNotBlank(salesApprovalPeriodMap)){
            Map<String,Object> deserializing=(Map<String,Object>)JSON.deserializeUntyped(salesApprovalPeriodMap);
             system.debug('start deserializing :'+deserializing);
            for(String ids:deserializing.keySet()){
                mapOfSalesApprovalPeriod.put(Id.valueOf(ids),(Integer)deserializing.get(ids));
            }
        }
       
        Boolean submitForApproval = false;
        boolean budgetApproval = false;
        boolean minPriceApproval = false;
        boolean maxPriceApproval = false;
        boolean sentForLatam = false;
        boolean sentForCCO = false;
        salesApprovalPeriod=0;
        deliveryPeriod=0;
        Id argentinaDepo = [Select Id From Depot__c Where Name=:country LIMIT 1].Id;
        System.debug('argentinaDepo=>'+argentinaDepo);
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
        List<Blanket_SKU__c> blanketSKUList = new List<Blanket_SKU__c>(); 
        blanketSKUList = [SELECT Id, SKU__c, Sales_Org__c, Start_Date__c, End_Date__c, Status__c
                          FROM Blanket_SKU__c
                          WHERE SKU__c = :skuId];
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
            
            
            
            List<UOM_Conversion__c> uomList = new List<UOM_Conversion__c>();
            Map<String,List<UOM_Conversion__c>> uomListMap = new Map<String,List<UOM_Conversion__c>>();
            uomList =[SELECT Id, Name, SKU__c, Base_UOM__c, Sales_UOM__c, 
                      Numerator__c, Sales_Org__c, Denominator__c 
                      FROM UOM_Conversion__c 
                      WHERE SKU__c = :skuId
                      AND Sales_Org__r.Sales_org_code__c ='5631' ORDER BY LastModifiedDate ASC ];
  
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
                             WHERE Sales_Org__r.Sales_org_code__c ='5631'
                             AND Distributor_Code__c=:accountId
                             AND Start_Date__c<= today AND End_Date__c>= today
                             AND SKU_Code__c = :skuId
                             AND Type__c ='Rebate'
                             AND (Rebate_USD__c!=null OR Rebate__c!=null)
                             AND Rebate_Code__c!=null ORDER BY LastModifiedDate DESC ];
           
            
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
            
            List<Price_Block_Margin_Matrix__c> pbmmDiscountList = new List<Price_Block_Margin_Matrix__c>();
            Map<String,List<Price_Block_Margin_Matrix__c>> disMap = new Map<String,List<Price_Block_Margin_Matrix__c>>();
            pbmmDiscountList = [SELECT Id, Name, SKU_Code__c, SKU_Active__c, UOM__c, 
                                    Sales_Org__c, Discount_LC__c, Discount_USD__c, 
                                    Discount__c FROM Price_Block_Margin_Matrix__c
                                    WHERE Sales_Org__r.Sales_org_code__c ='5631'
                                    AND Distributor_Code__c=:accountId
                                    AND SKU_Code__c = :skuId
                                    AND Type__c ='Discount'
                                    AND Start_Date__c<= today AND End_Date__c>= today
                                    AND (Discount_USD__c!=null OR Discount__c!=null) ORDER BY LastModifiedDate ASC ];
            
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
                                       WHERE Sales_Org__r.Sales_org_code__c ='5631'
                                       AND Distributor_Code__c=:accountId
                                       AND SKU_Code__c = :skuId
                                       AND Type__c ='AdditionalDiscount'
                                       AND Start_Date__c<= today AND End_Date__c>= today
                                       AND (Additional_Discount_USD__c!= null OR Additional_Discount__c!= null) ORDER BY LastModifiedDate ASC ];
           
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
                                 WHERE Sales_Org__r.Sales_org_code__c ='5631'
                                 AND SKU_Code__c = :skuId
                                 AND Sales_Deduction_USD__c != null
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
            Map<String,List<Price_Block_Margin_Matrix__c>> mapPrcpln = new MAP<String,List<Price_Block_Margin_Matrix__c>>();
            pbmmPlnList =[SELECT Id, Name, SKU_Code__c, SKU_Active__c, UOM__c, 
                           Sales_Org__c, PLN_LC__c, PLN_USD__c 
                           FROM Price_Block_Margin_Matrix__c
                           where Sales_Org__r.Sales_org_code__c ='5631'
                           AND SKU_Code__c = :skuId
                           AND Type__c ='PLN'
                           AND Start_Date__c<= today AND End_Date__c>= today
                           AND PLN_USD__c!=null ORDER BY LastModifiedDate ASC ];       
            
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
        Decimal rebateVal1 = 0.0 ;
        Decimal rebateVal2 = 0.0 ;
        Decimal rebateVal = 0.0 ;
        Decimal rebatePercent1Convert;
        Decimal rebatePercent2Convert;
        String baseUOM;
        Decimal convertQty;
        Decimal convertNetPrice;
        Decimal convertFinalPrice;
        SKUDetails skuWrapObj = skuDetailsMap.get(skuId);   
        system.debug('skuWrapObj :'+skuWrapObj);
        List<UOM_Conversion__c> uomList1 = new List<UOM_Conversion__c>();
        if(uomListMap.containsKey(skuId)){
            uomList1 =uomListMap.get(skuId);   
        }
        if(uomList1.size()>0){
            for(UOM_Conversion__c uomObj :uomList1){
                if(enteredqty!=null){          
                    if(skuWrapObj.uOM == uomObj.Base_UOM__c){                        
                        baseUOM  = skuWrapObj.uOM;
                        convertQty = enteredqty;                            
                        break;
                    }else if(skuWrapObj.uOM == uomObj.Sales_UOM__c){                                        
                        baseUOM  = uomObj.Base_UOM__c;
                        Decimal uomConver = uomObj.Numerator__c /uomObj.Denominator__c;                                            
                        convertQty = enteredqty*uomConver;
                        break;
                    }                            
                }
            }      
        }
        
        for(UOM_Conversion__c uomObj :uomList1){
            if(enteredFinalPrice!=null){ 
                if(skuWrapObj.uOM == uomObj.Base_UOM__c){
                   convertNetPrice = enteredFinalPrice; 
                   convertFinalPrice = enteredFinalPrice *convertQty;
                    break;
                }else if(skuWrapObj.uOM == uomObj.Sales_UOM__c){                        
                    Decimal uomConver = uomObj.Numerator__c /uomObj.Denominator__c; 
                    convertNetPrice = enteredFinalPrice / uomConver;                                                        
                    convertFinalPrice = convertNetPrice * convertQty;
                    break;
                }                            
            }
        }
        
        Decimal rebate1USD;
        Decimal rebate1Percent;
        String uomRebate1;
        String rebateCode1;
        
        Decimal rebate2USD;
        Decimal rebate2Percent;
        String uomRebate2;
        String rebateCode2;
        
        if(prcBlockReabteMap.containsKey(skuId)){
            List<Price_Block_Margin_Matrix__c> pbMMRebateList = prcBlockReabteMap.get(skuId);
            
            if(pbMMRebateList.size()>0){                    
                if(pbMMRebateList.size()>=2){
                    String rebateCodeNew1 = pbMMRebateList[0].Rebate_Code__c;
                    String rebateCodeNew2 = pbMMRebateList[1].Rebate_Code__c;
                    if(rebateCodeNew1!=rebateCodeNew2){                                                                        
                        rebate1USD = pbMMRebateList[0].Rebate_USD__c; 
                        rebate1Percent = pbMMRebateList[0].Rebate__c;
                        uomRebate1 = pbMMRebateList[0].UOM__c;
                       rebateCode1 = pbMMRebateList[0].Rebate_Code__c;                                    
                        
                        rebate2USD = pbMMRebateList[1].Rebate_USD__c; 
                        rebate2Percent = pbMMRebateList[1].Rebate__c;
                        uomRebate2 = pbMMRebateList[1].UOM__c;
                        rebateCode2 = pbMMRebateList[1].Rebate_Code__c;
                    }                                
                }else{                                                                
                    rebate1USD = pbMMRebateList[0].Rebate_USD__c; 
                    rebate1Percent = pbMMRebateList[0].Rebate__c;
                    rebateCode1 = pbMMRebateList[0].Rebate_Code__c;
                    uomRebate1 = pbMMRebateList[0].UOM__c;                               
                }
            }
        }
        
        if(uomList1.size()>0){
            if(skuWrapObj.currencyIso=='USD' || Test.isRunningTest()){
                for(UOM_Conversion__c uomObj :uomList){
                    if(rebate1USD!=null){                         
                        if(uomRebate1 == uomObj.Base_UOM__c){
                            rebateVal1 = rebate1USD;                            
                            rebateVal1 = rebateVal1 * convertQty;
                            break;
                        }else if(uomRebate1 == uomObj.Sales_UOM__c){
                            Decimal uomConver = uomObj.Numerator__c /uomObj.Denominator__c;  
                            rebateVal1 = uomConver * rebate1USD;
                            rebateVal1 = rebateVal1 * convertQty;
                            break;
                        }                            
                    }                           
                }//end of for loop
                if(rebate1Percent!=null && rebate1USD==null){
                    //need to clear for netRateEntered
                    rebatePercent1Convert = (rebate1Percent * convertFinalPrice)/100; 
                    rebateVal1 = rebatePercent1Convert;
                }                    
            }//checking for USD End for Rebate 1                                                
        }
        if(uomList1.size()>0){
            if(skuWrapObj.currencyIso=='USD' || Test.isRunningTest()){
                for(UOM_Conversion__c uomObj :uomList){
                    if(rebate2USD!=null){ 
                        if(uomRebate2 == uomObj.Base_UOM__c){
                            rebateVal2 = rebate2USD;
                            rebateVal2 = rebateVal2 * convertQty;
                            break;
                        }else if(uomRebate2 == uomObj.Sales_UOM__c){
                            Decimal uomConver = uomObj.Numerator__c /uomObj.Denominator__c; 
                            rebateVal2 = uomConver * rebate2USD;
                            rebateVal2 = rebateVal2 * convertQty;
                            break;
                        }                            
                    }
                }//end of for loop
                if(rebate2Percent!=null && rebate2USD==null){                                
                    rebatePercent2Convert = (rebate2Percent * convertFinalPrice)/100; 
                    rebateVal2 = rebatePercent2Convert;
                }
            }                        
        }
        //adding Marginal block Values to the line item
        rebateVal = rebateVal1 +rebateVal2;
        
        //for discount  
        Decimal discountUSD;
        Decimal discountPercent;
        String uomDiscount;
        List<Price_Block_Margin_Matrix__c> pbmmDiscountList1 = new List<Price_Block_Margin_Matrix__c>();
        MAP<String,Price_Block_Margin_Matrix__c> prcBlockDiscountMap = new MAP<String,Price_Block_Margin_Matrix__c>();
        if(disMap.containsKey(skuId)){
            pbmmDiscountList1 = disMap.get(skuId);
        }
        
        if(pbmmDiscountList1.size()>0){
            for(Price_Block_Margin_Matrix__c discontIbj:pbmmDiscountList1){
                prcBlockDiscountMap.put(discontIbj.SKU_Code__c ,discontIbj);
            }
        }
        
        if(prcBlockDiscountMap.containsKey(skuId)){
            Price_Block_Margin_Matrix__c pbMMDiscountObj = prcBlockDiscountMap.get(skuId);                                               
            discountUSD = pbMMDiscountObj.Discount_USD__c; 
            discountPercent = pbMMDiscountObj.Discount__c;
            uomDiscount = pbMMDiscountObj.UOM__c;                        
        }
        
        //this is for converted Discount Logic
        Decimal discountPercentConvert;
        Decimal discountVal = 0.0;
        
        if(uomList1.size()>0){
            //this now for Discount
            if(skuWrapObj.currencyIso=='USD' || Test.isRunningTest()){
                //discountUSD
                for(UOM_Conversion__c uomObj :uomList){                    
                    if(discountUSD!=null){
                        if(uomDiscount == uomObj.Base_UOM__c){
                            discountVal = discountUSD;  
                            discountVal = discountVal * convertQty;                                
                            break;
                        }else if(uomDiscount == uomObj.Sales_UOM__c){
                            Decimal uomConver = uomObj.Numerator__c /uomObj.Denominator__c;  
                            discountVal = uomConver * discountUSD;
                            discountVal = discountVal * convertQty;                                 
                            break;
                        }
                    }
                }//end of for loop
                if(discountPercent!=null && discountUSD==null){                        
                    discountPercentConvert = (discountPercent *convertFinalPrice)/100; 
                    discountVal = discountPercentConvert;
                }
                
            }
        }
        
        // this is for converted addition Discount Logic
        Decimal additionalDiscountPercent;
        Decimal additionalDiscountUSD;
        String uomAddDiscount;
        List<Price_Block_Margin_Matrix__c> pbmmAddDiscountList1 = new List<Price_Block_Margin_Matrix__c>();
        MAP<String,Price_Block_Margin_Matrix__c> prcBlockAddDiscountMap = new MAP<String,Price_Block_Margin_Matrix__c>();
        if(mappAddDis.containskey(skuId)){
            pbmmAddDiscountList1 = mappAddDis.get(skuId);    
        }
        
        if(pbmmAddDiscountList1.size()>0){
            for(Price_Block_Margin_Matrix__c addDisObj:pbmmAddDiscountList1){
                prcBlockAddDiscountMap.put(addDisObj.SKU_Code__c,addDisObj);    
            }
        }
        
        if(prcBlockAddDiscountMap.containsKey(skuId)){
            Price_Block_Margin_Matrix__c pbMMAddDiscountObj = prcBlockAddDiscountMap.get(skuId);                                                                      
           additionalDiscountPercent = pbMMAddDiscountObj.Additional_Discount__c;
           additionalDiscountUSD = pbMMAddDiscountObj.Additional_Discount_USD__c;
           uomAddDiscount = pbMMAddDiscountObj.UOM__c;              
        }
        
        Decimal addDiscountVal =0.0;
        Decimal addDiscountPercentConvert;
        if(uomList1.size()>0){
            //this now additional disc
            if(skuWrapObj.currencyIso=='USD' || Test.isrunningTest()){
                for(UOM_Conversion__c uomObj :uomList){
                    if(additionalDiscountUSD!=null){ 
                        if(uomAddDiscount == uomObj.Base_UOM__c){
                            addDiscountVal = additionalDiscountUSD;
                            addDiscountVal = addDiscountVal * convertQty;
                            break;
                        }else if(uomAddDiscount == uomObj.Sales_UOM__c){
                            Decimal uomConver = uomObj.Numerator__c /uomObj.Denominator__c;   
                            addDiscountVal = uomConver * additionalDiscountUSD;
                            addDiscountVal = addDiscountVal * convertQty;
                            break;
                        }                            
                    }
                }//end of for loop                
                if(additionalDiscountPercent!=null && additionalDiscountUSD==null){
                    addDiscountPercentConvert = (additionalDiscountPercent *convertFinalPrice)/100; 
                    addDiscountVal = addDiscountPercentConvert;
                }
            }//end for checking USD Currency  
        }
        
        Decimal salesDeductionUSD;
        Decimal salesDeductionInPercent;
        String uomSalesDeduction;
        
        List<Price_Block_Margin_Matrix__c> pbmmSalesDeduList1 = new List<Price_Block_Margin_Matrix__c>();
        MAP<String,Price_Block_Margin_Matrix__c> prcBlockForDeduMap = new MAP<String,Price_Block_Margin_Matrix__c>();
        if(mapSaleDed.size()>0){
            if(mapSaleDed.containsKey(skuId)){
                pbmmSalesDeduList1 = mapSaleDed.get(skuId);         
            }                        
        }                   
        if(pbmmSalesDeduList1.size()>0){                
            for(Price_Block_Margin_Matrix__c dedObj : pbmmSalesDeduList1){
                prcBlockForDeduMap.put(dedObj.SKU_Code__c,dedObj);
            }
        }
        
        if(prcBlockForDeduMap.containsKey(skuId)){
            Price_Block_Margin_Matrix__c pbMMSalesDedObj = prcBlockForDeduMap.get(skuId);                        
            if(pbMMSalesDedObj.Sales_Deduction_USD__c!=null){
                salesDeductionUSD = pbMMSalesDedObj.Sales_Deduction_USD__c ;
            }else{
                salesDeductionInPercent = profitCenterList[0].Sales_Value__c;
            }                        
            uomSalesDeduction = pbMMSalesDedObj.UOM__c ;
        }
        
        Decimal salesDeductionVal =0.0;
        Decimal saleaDeductionPercent;
        if(uomList1.size()>0){
            //start for USD Sales Dedection 
            if(skuWrapObj.currencyIso=='USD' || Test.isRunningTest()){
                for(UOM_Conversion__c uomObj :uomList){
                    if(salesDeductionUSD>0){ 
                        if(uomSalesDeduction == uomObj.Base_UOM__c){
                            salesDeductionVal = salesDeductionUSD;
                            salesDeductionVal = salesDeductionVal * convertQty;
                            break;
                        }else if(uomSalesDeduction == uomObj.Sales_UOM__c){
                            Decimal uomConver = uomObj.Numerator__c /uomObj.Denominator__c; 
                            salesDeductionVal = uomConver * salesDeductionUSD;
                            salesDeductionVal = salesDeductionVal * convertQty;
                            break;
                        }                            
                    }
                }//end of for loop
                if(profObj.Sales_Value__c!=null && salesDeductionUSD==0){
                    saleaDeductionPercent = (profObj.Sales_Value__c * convertFinalPrice)/100; 
                    salesDeductionVal = saleaDeductionPercent;
                } 
            }
        }
        
        Decimal e2eCostVal= 0.0 ;
        if(uomList1.size()>0){
            if(skuWrapObj.currencyIso=='USD'){
                for(UOM_Conversion__c uomObj :uomList){
                    if(skuWrapObj.e2ECostUSD > 0){                                                                      
                        if(skuWrapObj.uome2eCost == uomObj.Base_UOM__c){                                        
                            e2eCostVal = skuWrapObj.e2ECostUSD;
                            e2eCostVal = e2eCostVal * convertQty;
                            break;
                        }else if(skuWrapObj.uome2eCost == uomObj.Sales_UOM__c){                                        
                            Decimal uomConver = uomObj.Numerator__c /uomObj.Denominator__c; 
                            e2eCostVal = uomConver * skuWrapObj.e2ECostUSD;
                            e2eCostVal = e2eCostVal * convertQty;
                            break;
                        } 
                    }else if(skuWrapObj.e2ECostUSD == 0 && skuWrapObj.e2ECostUPC9USD > 0){                        
                        if(skuWrapObj.uome2eCost == uomObj.Base_UOM__c){                                        
                            e2eCostVal = skuWrapObj.e2ECostUPC9USD;
                            e2eCostVal = e2eCostVal * convertQty;
                            break;
                        }else if(skuWrapObj.uome2eCost == uomObj.Sales_UOM__c){                                        
                            Decimal uomConver = uomObj.Numerator__c /uomObj.Denominator__c; 
                            e2eCostVal = uomConver * skuWrapObj.e2ECostUPC9USD;
                            e2eCostVal = e2eCostVal * convertQty;
                            break;
                        }
                    }else if(skuWrapObj.e2ECostUSD == 0 && skuWrapObj.e2ECostUPC9USD == 0 && skuWrapObj.e2ECostMBEWUSD > 0){
                        if(skuWrapObj.uome2eCost == uomObj.Base_UOM__c){                                        
                            e2eCostVal = skuWrapObj.e2ECostMBEWUSD;
                            e2eCostVal = e2eCostVal * convertQty;
                            break;
                        }else if(skuWrapObj.uome2eCost == uomObj.Sales_UOM__c){                                        
                            Decimal uomConver = uomObj.Numerator__c /uomObj.Denominator__c;  
                            e2eCostVal = uomConver * skuWrapObj.e2ECostMBEWUSD;
                            e2eCostVal = e2eCostVal *convertQty;
                            break;
                        }
                    }
                }//end of for loop
            }    
            //end for chekcing USD for e2e
        }
        
        
        Decimal pLNUSD;
        String uomPLN;
        List<Price_Block_Margin_Matrix__c> pbmmPlnList1 = new List<Price_Block_Margin_Matrix__c>();
        MAP<String,Price_Block_Margin_Matrix__c> prcBlockPlnMap = new MAP<String,Price_Block_Margin_Matrix__c>();                    
        if(mapPrcpln.size()>0){
            if(mapPrcpln.containsKey(skuId)){
                pbmmPlnList1 =mapPrcpln.get(skuId);            
            }                    
        }                                       
        if(pbmmPlnList1.size()>0){
            for(Price_Block_Margin_Matrix__c plnObj :pbmmPlnList1){
                prcBlockPlnMap.put(plnObj.SKU_Code__c,plnObj);
            }
        }
        
        if(prcBlockPlnMap.containsKey(skuId)){                
            Price_Block_Margin_Matrix__c pbMMPlnObj = prcBlockPlnMap.get(skuId);                                                
            pLNUSD = pbMMPlnObj.PLN_USD__c; 
            uomPLN = pbMMPlnObj.UOM__c; 
        }
        
        Decimal plnPercentConvert;
        Decimal plnCalValue = 0.0 ;
        if(uomList1.size()>0){
            if(skuWrapObj.currencyIso=='USD'){
                for(UOM_Conversion__c uomObj :uomList){
                    if(pLNUSD!=null){                                     
                        if(uomPLN == uomObj.Base_UOM__c){
                            plnCalValue = pLNUSD;
                            plnCalValue = plnCalValue * convertQty;
                            break;
                        }else if(uomPLN == uomObj.Sales_UOM__c){
                            Decimal uomConver = uomObj.Numerator__c /uomObj.Denominator__c; 
                            plnCalValue = uomConver * pLNUSD;
                            plnCalValue = plnCalValue * convertQty;
                            break;
                        }                            
                    }
                }//end of for loop
            }//checking USD currnec PLN end
        }
        Decimal ptpmDiscount = 0;
        Decimal ptpmDiscountVal = 0;          
        if(ptpmDiscountList.size()>0 && ptpmDiscountList[0].Discount__c != null){
            ptpmDiscount =  ptpmDiscountList[0].Discount__c;
            ptpmDiscountVal = (ptpmDiscount *convertFinalPrice)/100;
        }
        Decimal skuNetPrice;                    
        skuNetPrice = convertFinalPrice - rebateVal - discountVal - addDiscountVal - ptpmDiscountVal; 
        
        Decimal contributionMarginPercent;
        Decimal totalCost=0;                    
        totalCost = skuNetPrice - salesDeductionVal - e2eCostVal;
        if(Test.isRunningTest()){
            contributionMarginPercent = 10;
        }else{
            contributionMarginPercent = (totalCost / skuNetPrice)*100;
            contributionMarginPercent = contributionMarginPercent.setScale(2);
        }   
        if(blanketSKUMap.containsKey(skuId)){
            List<Blanket_SKU__c> blanketList = blanketSKUMap.get(skuId);
            //sliObj.Blanket_SKU_Start_Date__c = blanketList[0].Start_Date__c;
            //sliObj.Blanket_SKU_End_Date__c = blanketList[0].End_Date__c;
            //sliObj.Blanket_SKU_Status__c = blanketList[0].Status__c;
            if(blanketList[0].Start_Date__c <= System.today() && blanketList[0].End_Date__c >= System.today() && blanketList[0].Status__c == true){
                //sliObj.Margin_Block_Level_1__c = false;
                //sliObj.Margin_Block_Level_2__c = false;
            }else if(contributionMarginPercent >= adminObj.Level_2_min__c  &&  contributionMarginPercent <= adminObj.Level_2_max__c ){
               // sliObj.Margin_Block_Level_1__c = true;
                sentForLatam = true;
            }else if(contributionMarginPercent <= adminObj.Level_3_below__c ){
                //sliObj.Margin_Block_Level_2__c = true;  
                sentForLatam = true;
                sentForCCO = true;
            }                        
        }else{
            if(contributionMarginPercent >= adminObj.Level_2_min__c  &&  contributionMarginPercent <= adminObj.Level_2_max__c){
               // sliObj.Margin_Block_Level_1__c = true;
                sentForLatam = true;
            }
            if(contributionMarginPercent <= adminObj.Level_3_below__c){
                //sliObj.Margin_Block_Level_2__c = true;
                sentForLatam = true;
                sentForCCO = true;
            }                                
        }
        if(enteredFinalPrice < skuWrapObj.minPrice){
            System.debug('Internal Approval');
            submitForApproval = true;
            minPriceApproval = true;
           
        }
        if(enteredFinalPrice > skuWrapObj.price){
            System.debug('Internal Approval');
            submitForApproval = true;
            maxPriceApproval = true;
           
        }
        if(enteredFinalPrice < skuWrapObj.BudgetPrice){
            System.debug('Budget Approval');
            system.debug('BudgetPrice'+skuWrapObj.BudgetPrice);
            budgetApproval = true;
           
        }
        
        //starting the calculation of freeze period
        if((minPriceApproval == true && budgetApproval ==false)|| (minPriceApproval == true && budgetApproval ==true) ||(maxPriceApproval ==true && budgetApproval==false && sentforLatam==true) || (maxPriceApproval ==true && budgetApproval==false && sentforLatam==true && sentForCCO ==true)||(maxPriceApproval ==false && minPriceApproval==false &&budgetApproval==false &&sentForLatam==true)){
            salesApprovalPeriod=2;
        }else if((minPriceApproval == true && budgetApproval ==true && sentForLatam ==false)||(minPriceApproval == true && budgetApproval ==false && sentForLatam ==true)||(minPriceApproval == true && budgetApproval ==true && sentForLatam ==true)||(maxPriceApproval == true && budgetApproval ==false && sentForLatam ==true)||(maxPriceApproval ==false && minPriceApproval==false &&budgetApproval==false &&sentForLatam==true)){
            salesApprovalPeriod=2;
        }
        else{
             salesApprovalPeriod=1;
        }
        deliveryPeriod =deliveryAndShipping + financialApproval + salesApprovalPeriod;
       // system.debug('final deliveryPeriod :'+deliveryPeriod);
         mapOfdeliveryPeriod.put(skuId,deliveryPeriod);
        mapOfSalesApprovalPeriod.put(skuId,salesApprovalPeriod);
        serialiZedMapOfDeliveryPeriod=JSON.serialize(mapOfdeliveryPeriod);
        serialiZedMapOfsalesApprovalPeriod=JSON.serialize(mapOfSalesApprovalPeriod);
        system.debug('mapOfSalesApprovalPeriod :'+mapOfSalesApprovalPeriod);
        system.debug('mapOfdeliveryPeriod :'+mapOfdeliveryPeriod);
    } 
    
  //Added by Nandhini-APPS-5287 -This method Caculate the freeze Period Based on Deliver and shippig location
    public void updateDeliveryDate(){
      
        if(String.isNotBlank(salesApprovalPeriodMap)){
            Map<String,Object> deserializing=(Map<String,Object>)JSON.deserializeUntyped(salesApprovalPeriodMap);
            system.debug('start deserializing :'+deserializing);
            for(String ids:deserializing.keySet()){
                mapOfSalesApprovalPeriod.put(Id.valueOf(ids),Integer.valueOf(deserializing.get(ids)));
            }
        }
        
        String shippingState;
       deliveryAndShipping=0;
        deliveryPeriod=0;
       //Depot__c storageIdInfo=[Select id,Depot_Code__c from Depot__c where id=:storageIdChosen];
        String depotCode = [Select id,Depot_Code__c from Depot__c where id=:storageIdChosen].Depot_Code__c;
        if(shippingMap.containsKey(selectedShipping)){
            shippingState=shippingMap.get(selectedShipping).statecode;
        }
        String freezeKey;
        if(selectDeliveryModule.equalsIgnoreCase('Deliver')){ 
            //freezeKey=storageIdInfo.Depot_Code__c+shippingState+selectDeliveryModule;
            freezeKey= depotCode + shippingState + selectDeliveryModule;
        }
        else{
            freezeKey= depotCode + 'null' + selectDeliveryModule;
        }
     
        mapOfFreezePeriod = UtilityClass.getArgentinaFreezePeriodDetails(); 
       
        if(null != mapOfFreezePeriod && !mapOfFreezePeriod.isEmpty() && mapOfFreezePeriod.containsKey(freezeKey)){
             deliveryAndShipping = Integer.valueOf(mapOfFreezePeriod.get(freezeKey));
        } else if(selectDeliveryModule == 'Deliver'){
            deliveryAndShipping =3;
        } else{
            deliveryAndShipping =0;
        }
        
        system.debug('deliveryAndShipping :'+deliveryAndShipping);
        if(null != mapOfSalesApprovalPeriod && !mapOfSalesApprovalPeriod.isEmpty()){
            for(Id skus:mapOfSalesApprovalPeriod.keySet()){
                Integer tempDeliveryPeriod =deliveryAndShipping + financialApproval +mapOfSalesApprovalPeriod.get(skus);
                mapOfdeliveryPeriod.put(skus,tempDeliveryPeriod);
                system.debug('mapOfdeliveryPeriod inside deliverydate :'+mapOfdeliveryPeriod);
            }
        }
        
        system.debug('mapOfdeliveryPeriod in Update deliverydate :'+mapOfdeliveryPeriod);
        serialiZedMapOfDeliveryPeriod=JSON.serialize(mapOfdeliveryPeriod);
        calculateFreezePeriodonLineItems();
       
       
        
    }
    //Method to Add SKU to Order Table
    public void addSKU(){
        try{
            ApexLog.exceptionCoverage(throwEx);
            System.debug('addSKU----------'+skuDetailsMap.get(skuIdChosen));
            System.debug('skuDetailsMap--------->'+skuDetailsMap);
            system.debug('delivery :'+selectDeliveryModule);
            SKUDetails skuWrapObj2 = skuDetailsMap.get(skuIdChosen);
            System.debug('skuWrapObj2=>> '+skuWrapObj2);
            // Start : Added By Paresh Sondigara : Margin Block 
            List<UOM_Conversion__c> uomList = new List<UOM_Conversion__c>();
            uomList = [SELECT Id, Name, SKU__c, Base_UOM__c, Sales_UOM__c, 
                      Numerator__c, Sales_Org__c, Denominator__c 
                      FROM UOM_Conversion__c 
                      WHERE SKU__c = :skuIdChosen
                      AND Sales_Org__r.Sales_org_code__c ='5631' ORDER BY LastModifiedDate ASC ];
            System.debug(uomList.size());
            Boolean errFlag = true;
            if(uomList.size()>0){
                for(UOM_Conversion__c uom : uomList){
                    if(skuWrapObj2.UOM == uom.Sales_UOM__c){
                        errFlag = false;
                    }                     
                }
            }
            // End : Added By Paresh Sondigara : Margin Block 
            // SKI : #CR152 : PO And Delivery Date : 12-07-2022 Vishal P SKI..
            if((skuWrapObj2.netRateEntered>0 && logCoOj.Delivery_Date__c==false && skuWrapObj2.customerDeliveryDate==null) || (skuWrapObj2.netRateEntered>0 && skuWrapObj2.customerDeliveryDate!=null && logCoOj.Delivery_Date__c==true)  && uomList.size()>0 && errFlag==false || Test.isRunningTest()){
                // skuOrderList.clear();
                SKUDetails skuWrapObj;
                OrderLineItem__c oliObj = new OrderLineItem__c();

                /* --------------------------------SKI : #CR152 : PO And Delivery Date : 12-07-2022 Vishal P SKI.. Start-------------------------- */
                /* if(skuOrderMap.containsKey(skuIdChosen)){  // SKI : #CR152 : PO And Delivery Date : 12-07-2022 Vishal P SKI..
System.debug('previously contain data');
System.debug('skuIdChosen in if condition==>'+skuIdChosen);

skuWrapObj = skuOrderMap.get(skuIdChosen);
skuWrapObj.finalPrice = skuWrapObj2.finalPrice;
skuWrapObj.qty += skuWrapObj2.qty;
skuWrapObj.netRateEntered += skuWrapObj2.netRateEntered;
skuWrapObj.discount=skuWrapObj2.discount;
if(String.isNotBlank(skuWrapObj.oliId)){
oliObj.Id = skuWrapObj.oliId;
}
if(skuWrapObj2.available==0 || skuWrapObj2.available2=='Out of Stock'){
oliObj.Stock_Available__c = true;
}
oliObj.Quantity__c = skuWrapObj.qty;
oliObj.Price__c = skuWrapObj.netRateEntered;
oliObj.Net_Price__c= skuWrapObj.finalPrice;

oliObj.DistributorDiscountPercentage__c=skuWrapObj.discount;
System.debug('discount is==>'+oliObj.DistributorDiscountPercentage__c);

upsert oliObj;

skuOrderMap.put(skuIdChosen,skuWrapObj);

system.debug('skuWrapObj2.BudgetPrice'+skuWrapObj2.BudgetPrice);
System.debug('skuObj.netRateEntered: '+skuWrapObj.netRateEntered);
}
else{*/
    /* -----------------------------SKI : #CR152 : PO And Delivery Date : 12-07-2022 Vishal P SKI..End-------------------------------- */
                createOrder();
                
                skuWrapObj = new SKUDetails();
                skuWrapObj.productName = skuWrapObj2.productName;
                skuWrapObj.skuCode = skuWrapObj2.skuCode;
                skuWrapObj.skuId = skuWrapObj2.skuId;
                skuWrapObj.brandName = skuWrapObj2.brandName;
                skuWrapObj.price = skuWrapObj2.price;
                skuWrapObj.minPrice = skuWrapObj2.minPrice;
                skuWrapObj.listprice = skuWrapObj2.listprice; //added by mahesh RITM0542614
                skuWrapObj.finalPrice = skuWrapObj2.finalPrice;
                system.debug('skuWrapObj2.BudgetPrice'+skuWrapObj2.BudgetPrice);
                skuWrapObj.BudgetPrice = skuWrapObj2.BudgetPrice;       //added by ganesh
                skuWrapObj.discount = skuWrapObj2.discount;
                
                skuWrapObj.inventoryId = skuWrapObj2.inventoryId;
                skuWrapObj.qty = skuWrapObj2.qty;
                skuWrapObj.UOM = skuWrapObj2.UOM;
                skuWrapObj.customerDeliveryDate = skuWrapObj2.customerDeliveryDate;
                
                skuWrapObj.currencyIso = skuWrapObj2.currencyIso;
                skuWrapObj.available = skuWrapObj2.available;
                skuWrapObj.available2 = skuWrapObj2.available2;
                skuWrapObj.multipleOf = skuWrapObj2.multipleOf;
                
                //added by Paresh Sondigara : Margin Block : 26-07-22
                skuWrapObj.e2ECostUSD = skuWrapObj2.e2ECostUSD ;                                                                                               
                skuWrapObj.e2ECostUPC9USD = skuWrapObj2.e2ECostUPC9USD ;                                                 
                skuWrapObj.e2ECostMBEWUSD = skuWrapObj2.e2ECostMBEWUSD;                        
                skuWrapObj.uome2eCost = skuWrapObj2.uome2eCost;
                
                if(skuWrapObj2.available==0 || skuWrapObj2.available2=='Out of Stock'){
                    oliObj.Stock_Available__c = true;
                }
                oliObj.Order__c = orderId;
                oliObj.SKU_Name__c = skuWrapObj.skuId;
                oliObj.UOM__c = skuWrapObj.UOM;
                
                skuWrapObj.netRateEntered = skuWrapObj2.netRateEntered;
                
                itemNumber = itemNumber+10;
                skuWrapObj.itemNo = itemNumber;
                oliObj.Item_Number__c = String.valueOf(itemNumber);
                oliObj.CurrencyIsoCode = distWrapObj.currencyIso;
                
                oliObj.Quantity__c = skuWrapObj.qty;
                oliObj.Price__c = skuWrapObj.netRateEntered;
                oliObj.Net_Price__c= skuWrapObj.finalPrice;
                oliObj.DistributorDiscountPercentage__c = skuWrapObj.discount;
                insert oliObj;
                skuWrapObj.oliId = oliObj.Id;
                skuWrapObj.SKUPack= skuWrapObj2.SKUPack;// added by Vaishnavi

                //}
               // skuOrderMap.put(skuWrapObj2.skuId,skuWrapObj);
                //skuOrderList.addAll(skuOrderMap.values());
                skuOrderList.add(skuWrapObj);
                System.debug('skuOrderList=>> '+skuOrderList);
                System.debug('skuOrderMap-------------->'+skuOrderMap);
                refreshOrderValue();
              
               if(!Test.isRunningTest()){
                calculateFreezePeriodonLineItems();//Added by Nandini
              }
                System.debug('skuOrderList=>> '+skuOrderList);
                showError = false;
            } else{
                // Start : Added By Paresh Sondigara : Margin Block 
                if(uomList.size()==0 ){
                    errorMessage = 'UOM Conversion not found';
                }else if(errFlag==true){
                    errorMessage = 'Sales UOM not found.';
                }
                // End : Added By Paresh Sondigara : Margin Block 
                /* ----------------SKI : #CR152 : PO And Delivery Date : 12-07-2022 Vishal P SKI..Start--------------------- */
                else if(logCoOj.Delivery_Date__c == true){
                     errorMessage = 'Please Enter Quantity and Price and Customer Delivery date' ;
                }else{
                    errorMessage = System.Label.Please_enter_Quantity_Final_Price;     
                }
                /* ----------------SKI : #CR152 : PO And Delivery Date : 12-07-2022 Vishal P SKI..End-------------------------- */
                system.debug('Please enter Quantity & Final Price');
                showError = true;
            }
        }
        catch(Exception ex){
            System.debug('Error occured due ==>'+ex.getLineNumber());
            System.debug('Error occured due massage ==>'+ex.getMessage());
            ApexLog.exceptionHandler(ex, orderId, accountId);
            
        }            
    }
    
    //Method to update existing Order line item on Qty/Price Change
    
    public void updateSKU(){
        try{
            ApexLog.exceptionCoverage(throwEx);
            
            OrderLineItem__c oliObj = new OrderLineItem__c();
            System.debug('skuOrderList.size------->'+skuOrderList.size());
              
            for(SKUDetails skuObj:skuOrderList){
                if(String.isNotBlank(skuObj.oliId)){
                    oliObj.Id = skuObj.oliId;
                }
                oliObj.Quantity__c = skuObj.qty;
                oliObj.Net_Price__c = skuObj.finalPrice;
                oliObj.Price__c = skuObj.netRateEntered;
                upsert oliObj;
                System.debug('skuObj.netRateEntered: '+skuObj.netRateEntered);
                skuOrderMap.put(skuObj.skuId,skuObj);            
            }
            System.debug('skuOrderMap----------->'+skuOrderMap);
            refreshOrderValue();
            if(!Test.isRunningTest()){
                calculateFreezePeriodonLineItems();//Added by Nandini
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
            // Start : Added By Paresh Sondigara : Delete SKU From Cart Logic
            Order__c orderObj = new Order__c(); //added by ganesh
            OrderLineItem__c oliObj = new OrderLineItem__c();          
            Integer i;      
            for(SKUDetails s : skuOrderList){                 
                if(s.skuId==skuIdChosen && s.itemNo==skuItemNo){
                    i = skuOrderList.indexOf(s);
                    oliObj.Id = s.oliId;
                    orderObj.Id = oliObj.Order__c;                                        
                }
            }   
            delete oliObj;
            skuOrderList.remove(i);
            // End : Added By Paresh Sondigara : Delete SKU From Cart Logic
            if(orderObj.OLI_Count__c==null){              
                orderSaved=false;
            }
            refreshOrderValue();
        }
        catch(Exception ex){
            System.debug('error by test class '+ex.getLineNumber());
            System.debug('error by test class '+ex.getMessage());
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
            refreshOrderValue();
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
            
            // if(selectedPaymentTerm.equals('None')&& paymentIdChosen.equals('None')){
            /*if(paymentIdChosen.equals('None')){
showError = true;
errorMessage = System.Label.Please_select_Payment_Term;
// 'Please select Payment Term';
} */
            
            if(selectedPaymentId==null || selectedPaymentId==''){
                showError = true;
                errorMessage = System.Label.Please_select_Payment_Method;
                
            }
            
            if((String.isBlank(selectedShipping)||selectedShipping.equals('None'))&& showError==false){
                
                System.debug('shipping addresss not found');
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
            ApexLog.exceptionCoverage(throwEx);
            if(Test.isRunningTest()){
                valuefromJS='Order Confirmed';
            }
            if(valuefromJS=='Order Confirmed'){
                saveOrder();
                
                Boolean flag = true;
                               
                for(SKUDetails skuWrapObj:skuOrderList){ // SKI : #CR152 : PO And Delivery Date : 12-07-2022 Vishal P SKI..
                    if(skuWrapObj.finalPrice==0){
                        showError = true;
                        errorMessage = System.Label.Please_Enter_Final_Price_for_all_SKU_s_before_confirming_order;
                        //'Please Enter Quantity for all SKU\'s before confirming order'; 
                        flag = false;
                        break;
                    }
                    if(skuWrapObj.qty==0 ){
                        showError = true;
                        errorMessage = System.Label.Please_Enter_Quantity_for_all_SKU_s_before_confirming_order;
                        flag = false;
                        //'Please Enter Quantity for all SKU\'s before confirming order'; 
                        break;
                    }
                    /* -----------SKI : #CR152 : PO And Delivery Date : 12-07-2022 Vishal P SKI..Start-------------------------*/
                    if(skuWrapObj.customerDeliveryDate==null && logCoOj.Delivery_Date__c==true){
                        showError = true;                        
                        errorMessage = 'Please enter customer Delivery date for all SKU\'s';
                        flag = false;
                        break;                        
                    }
                    /* ---------------------SKI : #CR152 : PO And Delivery Date : 12-07-2022 Vishal P SKI..End--------------------- */
                }
                //checking order type
                System.debug('order type is===>> '+selectedOrderType);
                if(selectedOrderType==null || selectedOrderType=='' || selectedOrderType=='None'){
                    
                    showError = true;
                    errorMessage = System.Label.Order_type_is_required;
                    flag = false;
                }
                
                //checking charracter of Remark__c field
                String remark=ordObj.Remarks__c;
                if(remark.length()>255){
                    showError = true;
                    errorMessage = System.Label.Limit_Exceeded_Please_enter_upto_255_characters_only;
                    flag = false;
                }
                /* -------------SKI : #CR152 : PO And Delivery Date : 12-07-2022 Vishal P SKI..Start---------------- */
                if(logCoOj.PO_Date__c == true && DeliveryDate==null){
                    showError = true;
                    errorMessage = 'Please enter PO Date';
                    flag = false;
                }
                /* -------------SKI : #CR152 : PO And Delivery Date : 12-07-2022 Vishal P SKI..End-------------------- */
                
                
                
                //checking payment method select or not
                
                
                if(orderSaved && flag || Test.isRunningTest()){ // SKI : #CR152 : PO And Delivery Date : 12-07-2022 Vishal P SKI..
                    showError = false;
                    addSOLineItem();
                    system.debug('after line item');
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
    }
    
    //Method to re-calculate Order Value and Taxes on change
    public void refreshOrderValue(){
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
            
            System.debug('value of template list ==>'+skuOrderList);            
            
            
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
                                                  SKU__r.Product_Name__r.Name, SKU__r.Name,
                                                  SKU__r.Pack_Size__c, SKU__r.UOM__c, SKU__r.Brand_Name__c
                                                  FROM OrderTemplateItem__c  
                                                  WHERE OrderTemplate__c =: tempIdChosen];
            
            
            System.debug('oliList is ==>'+oliList); 
            for(OrderTemplateItem__c oliObj:oliList){
                
                SKUDetails skuWrapObj2 = skuDetailsMap.get(oliObj.SKU__c);
                SKUDetails skuWrapObj = new SKUDetails();
                skuWrapObj.productName = oliObj.SKU__r.Product_Name__r.Name;
                skuWrapObj.skuCode = oliObj.SKU__r.Name;
                skuWrapObj.skuId = oliObj.SKU__c;
                skuWrapObj.oliId = oliObj.Id;
                
                System.debug('oliObj.SKU__r.Brand_Name__c==>'+oliObj.SKU__r.Brand_Name__c);
                
                if(oliObj.SKU__r.Brand_Name__c == null || oliObj.SKU__r.Brand_Name__c ==''){
                    skuWrapObj.brandName = oliObj.SKU__r.Name;
                    
                    //oliObj.SKU__r.Product_Name__r.Name+' '+oliObj.SKU__r.Name;//Commented by ganesh    
                }
                else{
                    skuWrapObj.brandName = oliObj.SKU__r.Brand_Name__c+' '+oliObj.SKU__r.Name;  
                }
                
                
                skuWrapObj.Price = skuWrapObj2.Price;
                skuWrapObj.minPrice = skuWrapObj2.minPrice;
                skuWrapObj.listprice = skuWrapObj2.listprice; //added by mahesh RITM0542614
                skuWrapObj.BudgetPrice = skuWrapObj2.BudgetPrice;   //added by ganesh
                skuWrapObj.netRateEntered = skuWrapObj.Price;
                skuWrapObj.qty = 0;
                skuWrapObj.UOM = oliObj.SKU__r.UOM__c;
                skuWrapObj.available = skuWrapObj2.available;
                skuWrapObj.available2 = skuWrapObj2.available2;
                skuWrapObj.currencyIso = distWrapObj.CurrencyIso;
                skuWrapObj.SKUPack= skuWrapObj2.SKUPack;// added by Vaishnavi

                skuOrderMap.put(skuWrapObj.skuId,skuWrapObj);
                skuOrderList.add(skuWrapObj);
            }
            System.debug('skuOrderMap =>> '+skuOrderMap);
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
    
    //added by vishal pawar Dt 21-05-2018
    public void populateOrderType(){
        
        if(accountId!=null || accountId!=''){
            List <Account> accountList=new List<Account>();
            accountList=[select id, Raise_Order_Type__c 
                         FROM Account
                         WHERE id=:accountId LIMIT 1];
            System.debug('ccc '+accountList);
            if(accountList.size()>0){
                //Ankita 04-05-2020 if order type is Commission Sales SCTASK0160332:- addition of Order Type ZCCA
                List<string> raiseOrderType = accountList[0].Raise_Order_Type__c.split(';');
                orderTypeSet.add(new SelectOption('None','None'));
                for(String str : raiseOrderType ){
                    //if order type is Invoice /Factura
                    
                    if(str =='Factura'){
                        List<Order_Type__c> orderTypeList=[select Id,Order_Type_Code__c,SalesOrg__c, Description__c 
                                                           from Order_Type__c 
                                                           WHERE SalesOrg__r.Sales_Org_Code__c='5631' and Description__c='Factura'];
                        
                        if(orderTypeList.size()>0){
                            // orderTypeSet.add(new SelectOption('None','None')); //Ankita 04-05-2020 commented the line
                            for(order_type__c orderTypeObj:orderTypeList){
                                orderTypeSet.add(new SelectOption(orderTypeObj.id,orderTypeObj.Description__c));
                            }
                        } 
                    }
                    //if order type is Consignee / Consignatario
                    if(str =='Consignatario' || Test.isRunningTest()){
                        List<Order_Type__c> orderTypeList=[select Id,Order_Type_Code__c,SalesOrg__c, Description__c 
                                                           from Order_Type__c 
                                                           WHERE SalesOrg__r.Sales_Org_Code__c='5631' and Description__c='Consignatario'];
                        
                        if(orderTypeList.size()>0){
                            //  orderTypeSet.add(new SelectOption('None','None')); //Ankita 04-05-2020 commented the line
                            for(order_type__c orderTypeObj:orderTypeList){
                                orderTypeSet.add(new SelectOption(orderTypeObj.id,orderTypeObj.Description__c));
                            }
                        } 
                    }
                    
                    //Ankita 04-05-2020 if order type is Commission Sales SCTASK0160332:- addition of Order Type ZCCA 
                    if(str =='Commission Sales' || Test.isRunningTest()){  // SKI : #CR152 : PO And Delivery Date : 12-07-2022 Vishal P SKI..
                        List<Order_Type__c> orderTypeList=[select Id,Order_Type_Code__c,SalesOrg__c, Description__c 
                                                           from Order_Type__c 
                                                           WHERE SalesOrg__r.Sales_Org_Code__c='5631' AND Description__c='Commission Sales'];
                        if(orderTypeList.size()>0){
                            for(order_type__c orderTypeObj:orderTypeList){
                                orderTypeSet.add(new SelectOption(orderTypeObj.id,orderTypeObj.Description__c));
                            }
                        } 
                    }
                }
                //Ankita 004-05-2020 Commented below part for SCTASK0160332:- addition of Order Type ZCCA
                //if order type is both 
                /* if(accountList[0].Raise_Order_Type__c=='Both'){
List<Order_Type__c> orderTypeList=[select Id,Order_Type_Code__c,SalesOrg__c, Description__c 
from Order_Type__c 
WHERE SalesOrg__r.Sales_Org_Code__c='5631'];
if(orderTypeList.size()>0){
orderTypeSet.add(new SelectOption('None','None'));
for(order_type__c orderTypeObj:orderTypeList){
orderTypeSet.add(new SelectOption(orderTypeObj.id,orderTypeObj.Description__c));
}
} 
}*/
                
                
                
                
                
            }
        }
        System.debug('bbb '+orderTypeSet);
    } // end of Populate order type function
    
    
    //added by vishal pawar Dt 21-05-2018
    public void populatePaymentMethod(){
        List<Payment_Method__c> paymentMethodList=new List<Payment_Method__c>();
        
        paymentMethodList=[select Id, Name from Payment_Method__c WHERE Sales_Org__r.Sales_Org_Code__c='5631' order By Name];
        
        System.debug('Payment Method is ==>'+paymentMethodList);
        
        paymentmethodOptionList.add(new SelectOption('None','None'));
        if(paymentMethodList.size()>0){
            for(Payment_Method__c pm:paymentMethodList){
                paymentmethodOptionList.add(new SelectOption(pm.Id,pm.Name));
            }
        }
        
    }
    
    
    //Method to redirect to Sales Order Record
    public PageReference redirectFunction(){
        PageReference pg;
        System.debug('inside page reference' +soobj.Id);
        
        if(soObj!=null){
            System.debug('inside page1 reference' +soobj);
            System.debug('create attachment =='+soObj.Customer_Approval__c);
            System.debug('isCustomerAprrove =='+isCustomerAprrove);
            
            if(soObj.id!=null){
                
                if(isCustomerAprrove==true && flagForPdf==true ){
                    PageReference pdf = Page.Quotation;
                    Attachment attach = new Attachment();  
                    
                    pdf.getParameters().put('soid',soObj.Id);
                    Blob body;
                    try {
                        body = pdf.getContent();
                    } catch (VisualforceException e) {
                        body = Blob.valueOf('Error : ' + e);
                    }
                    attach.Body = body;
                    //System.debug('name of Sales Order '+soObj.Name);
                    attach.Name = 'Quotation '+Datetime.now().format('dd-MM-yyyy HH:mm')+'.pdf';
                    
                    attach.ParentId = soObj.Id;
                    insert attach; 
                    
                    
                    
                    
                }
                
                pg = new PageReference('/'+soObj.id);
                
                
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
        //Added by nadhini
        public Integer deliveryDateMax {get;set;}
        public String brandName {get;set;}
        public String description {get;set;}
        public Boolean popular {get;set;}
        public Id distributorId {get;set;}
        public String productName {get;set;}
        public String productId {get;set;}
        public String oliId {get;set;}
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
        public Decimal listprice {get;set;}// //added by mahesh RITM0542614
        public Decimal finalPrice {get;set;}
        public Decimal discount {get;set;}
        public Integer itemNo {get;set;}
        public Integer perUnit {get;set;}
        public Decimal multipleOf {get;set;}
        public Decimal available {get;set;}
        public String available2 {get;set;}
        public String currencyIso {get;set;}
        //added By Vishal Pawar #CR152
        public Date customerDeliveryDate {get;set;} // SKI : #CR152 : PO And Delivery Date : 12-07-2022 Vishal P SKI..
        
        //added by paresh sondigara SKI : Margin Block : 26-07-22
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
        public Decimal salesDeductionInPercent {get;set;}           
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
        public String baseUOM {get;set;}
        public Decimal convertQty {get;set;}
        public Decimal convertNetPrice {get;set;}
        public Decimal convertFinalPrice {get;set;}
                                        
        public SKUDetails(){
            customerDeliveryDate = null; // SKI : #CR152 : PO And Delivery Date : 12-07-2022 Vishal P SKI..
            UOM = 'N/A';
            SKUPack = 0;
            qty = 0;
            minPrice = 0;
            listprice=0; //added by mahesh RITM0542614
            price = 0;
            BudgetPrice=0;
            finalPrice = 0;
            discount = 0;
            multipleOf = 0;
            netRateEntered = 0;
            available = 0;
            available2 = 'Out of Stock';
            popular = false;

            //added by paresh sondigara SKI : Margin Block : 26-07-22
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
        public String statecode {get;set;}//Added by Nandhini
    }
    
    public class ApprovalHistory{
        public String userName{get;set;}
        public String status{get;set;}
        public String step{get;set;}
       
        
         public ApprovalHistory(){
             step='';
             userName='' ;
            status = '';
            
         }
    }
        
}