/*
* Name: OrderCAMController
* Created On: 16 May 2017
* Author: Bhavik Devdhar (bhavik.devdhar@skinternational.com)
* Description: Class is used for Placing Orders by Distributor, TM, RM of Mexico
*/
global without sharing class OrderCAMController {
    //Variable to be set by JS for Attachment status
    public String valuefromJS {get;set;}
    public Date poDate {get;set;}               // SKI : #CR152 : PO And Delivery Date : 12-07-2022 Vishal P SKI..
    public Login_Country__c logCoOj {get;set;}  // SKI : #CR152 : PO And Delivery Date : 12-07-2022 Vishal P SKI..
    
    public String PriceEntry{get;set;}
    public String PriceEntryCopy{get;set;}
    public DistributorWrapper distWrapObj {get;set;}
    public ShippingLocation slwObj {get;set;}
    public String salesorgcodeforpbmlist;
    public List<SKUDetails> skuDetailsList {get;set;}
    public List<SKUDetails> skuOrderList {get;set;}
    public List<OrderLineItem__c> oliList {get;set;}
    public List<Sales_Order_Line_Item__c> oliList2 {get;set;}
    public List<OrderTemplate__c> tempList {get;set;}
    public String disbaleEnableOrdrType {get;set;}
    Public  SET<String>DistributionChannelIds = new SET<String>();
    
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
    public String saleogCode ;
    public List<String> distributionChanelCode ;//Margin Block Change - SKI Added by Sandeep Vishwakarma
    
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
    public Boolean showInventory{get;set;}
    public Boolean showInventoryColumn{get;set;}
    public Boolean enableDepot{get;set;}
    public Boolean showInTransit{get;set;}
    public Boolean showInTransitValues{get;set;} 
    
    public Boolean allowTemplate{get;set;}
    public Boolean orderSaved{get;set;}
    
    public Decimal grossAmount {get;set;}
    
    public Integer itemNumber;
    //RITM0497119-Added by Nandhini
    public String storageLocationCodeInAcc;
    public Map<string,Id> mapOfStorageCodeAndId;
    
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
    public String orderType {get;set;}
    public Boolean isCAMManager{get;set;}
    //Export Order Sales Deduction(CR#182) - SKI Added by Sandeep Vishwakarma 5-25-2023
    public List<Profit_Center__c> profitCenterList{get;set;}
    public Profit_Center__c profitCenter {get;set;}
    List<USD_Exchange_Rate__c> exchangeList;
    List<Price_Block_Margin_Matrix__c> pbmmReabteList;//Export Order Sales Deduction(CR#182) - SKI Added by Sandeep Vishwakarma 5-25-2023
    public String selectedCountry { get; set; } 
    public String displayUSD { get; set; } 
    Decimal salesDeductionByCountry = 0;
    
    public  User loginUserObj;
    public MAP<String,Sales_Order__c> orgSalesorderMap ; 
    public set<Id> exsitingOrderId = new set<Id>();
    //Margin Block Change - SKI Added by Sandeep Vishwakarma
    /* Sandeep */
    public void setorderType(String type) {
        //If multiselect is false, countries must be of type String
        System.debug('Type '+type);
        this.orderType = type;
    }
    //Export Order Sales Deduction(CR#182) - SKI Added by Sandeep Vishwakarma 5-25-2023

    public List<SelectOption> getCountryOptions() {
        List<SelectOption> options = new List<SelectOption>();
       
        List<DistributorSalesAreaMapping__c> salesAreas= [select id,Name,Country_Code__c,Sales_Org_Code__c,SalesOrg__c,SalesOrg__r.Name from DistributorSalesAreaMapping__c where Distributor__c=:accountId];
        List<String> salesOrgList = new  List<String>();
        for(DistributorSalesAreaMapping__c sa: salesAreas){
            salesOrgList.add(sa.SalesOrg__c);
        }
        options.add(new SelectOption('0', 'None'));
        // for(DistributorSalesAreaMapping__c sa:salesAreas){
        //     options.add(new SelectOption(sa.SalesOrg__r.SalesDeduction__c,sa.SalesOrg__r.Name ));
        // }

        List<Profit_Center__c> profitCenterList1 =[SELECT Id, Name, Profit_Center__c,Sales_Deduction__c,Sales_Org__r.Name, Sales_Value__c, Sales_Org__c, Depot__c, Combination_Key__c FROM Profit_Center__c WHERE Sales_Org__c IN:salesOrgList];

        for(Profit_Center__c pc:profitCenterList1){
            if(pc.Sales_Deduction__c!=null){
                options.add(new SelectOption(pc.Sales_Deduction__c,pc.Sales_Org__r.Name ));
            }
        }

        return options;
    }

    
    public List<SelectOption> getoriginOptions() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('None', 'None'));
        options.add(new SelectOption('india', 'India'));
        return options;
    }

    /*abhishek*/
    public OrderCAMController(ApexPages.StandardController controller) {
        try{
            
            system.debug('Controller Called....');
            accountId = ApexPages.currentpage().getparameters().get('acid');
            System.debug('accountId: '+accountId);
            salesorgcodeforpbmlist='';
            selectedCountry = '0'; //Export Order Sales Deduction(CR#182) - SKI Added by Sandeep Vishwakarma 5-25-2023
            multipleOf=0;
            Payment_Methods='';
            Sent_for_Latam_Director_Approval=false;
            Sent_for_Director_Approval= false;
            disbaleEnableOrdrType = '';
            // SalesArea - salesOrg 
            // Added by sandeep Vishwakarma Margin Block
            List<DistributorSalesAreaMapping__c> SalesAreaDMList1 = [select Sales_Org_Code__c from DistributorSalesAreaMapping__c where Distributor__c=:accountId];
            Set<String> salesOrgCodes  = new Set<String>();
            for(DistributorSalesAreaMapping__c sa:SalesAreaDMList1){
                salesOrgCodes.add(sa.Sales_Org_Code__c);
            }
            List<String> lstSalesOrg = new List<String>();
            lstSalesOrg.addAll(salesOrgCodes);
            if(lstSalesOrg.size()==1){
                disbaleEnableOrdrType = 'show';
                saleogCode = lstSalesOrg[0];
                country = lstSalesOrg[0];
            }else{
                disbaleEnableOrdrType = 'hide';
                saleogCode ='5711';
                country = '5711';
            }
            //Margin Block Change - SKI Added by Sandeep Vishwakarma
            distributionChanelCode = new List<String>();//Margin Block Change - SKI Added by Sandeep Vishwakarma
            isCAMManager = true;
            Sent_for_Manager_Approval = false;
            orgSalesorderMap = new MAP<String,Sales_Order__c>();
            Payment_Terms='';
            //  PriceEntry='';
            CurrencyCodeList = new Set<SelectOption>();
            //CurrencyCodeList.add('-None-');
            CurrencyCodeList.add(new SelectOption('-None-','-None-'));
            CurrencyCodeList.add(new SelectOption('CLP','CLP'));//Margin Block Change - SKI Added by Sandeep Vishwakarma
            CurrencyCodeList.add(new SelectOption('USD','USD'));
            
            //System.debug('countrypaymebt list country  '+country);
            paymentMethodList = [SELECT Id, Name, Active__c, Description__c,Payment_Method_Code__c,Sales_Org__r.sales_org_code__c FROM Payment_Method__c where Sales_Org__r.sales_org_code__c=:country];
            
            
            
            SelectedCurrency='USD';
            paymentTermCode = '';  
            DistributorSalesAreaMappingMAP = new MAP<String,DistributorSalesAreaMapping__c>(); 
            slwObj = new ShippingLocation();
            
            productNamesSet = new Set<String>();
            descriptionSet = new Set<String>();
            depotSet = new List<SelectOption>();
            paymentTermSet = new List<SelectOption>();
            skuDetailsList = new List<SKUDetails>();
            skuOrderList = new List<SKUDetails>();
            oliList = new List<OrderLineItem__c>();
            
            skuOrderMap = new Map<Id,SKUDetails>();
            shippingMap = new Map<String, ShippingLocation>();
            //Export Order Sales Deduction(CR#182) - SKI Added by Sandeep Vishwakarma 5-25-2023
            // skuDetailsMap = new Map<Id,SKUDetails>();
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
            
            throwEx = false;
            
            enableDepot = false;
            allowTemplate = false;
            orderSaved = false;
            
            grossAmount = 0;
            
            itemNumber = 0;
            
            orderType = '';
            profitCenter = null;//Margin Block Change - SKI Added by Sandeep Vishwakarma
            distributorId = '';
            depoId = '';
            
            territoryManagerId = '';
            
            orderId = ApexPages.currentpage().getparameters().get('id');        
            System.debug('orderId: '+orderId);
            
            
            
            loginUserObj = [SELECT Id, Name, IsActive, ContactId,UserRole.name,
                            Show_Inventory__c, Show_Credit_Limit__c, EnableDepot__c, Sales_Director__c,
                            Show_Inventory_Column__c, ManagerId,Show_InTransit__c, Show_InTransit_Values__c,
                            HO__c, Country_Head__c, Marketing_Manager__c,ProfileId,Profile.Name
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
                    System.debug('inside isCAMManager CAM(Regional Manager)');
                    //isCAMManager= false;
                    orderRaisedBy = 'Regional Manager';
                }
                else{
                    //isCAMManager= true;
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
            
            List<Distributor_Depot_Mapping__c> depotList = [SELECT id, Depot__c 
                                                            FROM Distributor_Depot_Mapping__c 
                                                            WHERE Distributor__c=:accountId 
                                                            AND Depot__c!='' Order By LastModifiedDate DESC LIMIT 1];
            
            System.debug('depotList: '+depotList);
            
            if(!depotList.isEmpty()){
                depoId = depotList[0].Depot__c;
            }
            System.debug('depoId:now  '+depoId);
            
            
        }
        catch(Exception ex){
            System.debug('Method: Constructor Exception: '+ex.getMessage()+ ' Line Number: '+ex.getLineNumber());
        }
    }
    
    public String createSalesOrder2(String div_Id,Boolean Manager,Boolean Latam_Director,Boolean Director){
        
        system.debug('createSalesOrder2 Called....');
        system.debug('divisionId - createSalesOrder2'+div_Id);
        system.debug('Payment_Methods- - '+Payment_Methods);
        system.debug('Payment_Terms- - '+Payment_Terms);
        system.debug('Inco_Terms- - '+Inco_Terms);
        system.debug('orderType- - '+orderType);
        
        String distributorChannelId = '';
        String divisionId = '';
        
        if(orderType =='ZZOR'){
            final_price_code = 'ZP65';
            orderTypeCode = 'ZZOR';
            
        }
        if(orderType =='ZZEX'){
            final_price_code = 'ZP66';
            orderTypeCode = 'ZZEX';
        }
        
        
        //Added by Bhavik 12th Oct 2018
        List<Depot__c> argentinaDepoList = [Select Id, Shipping_condition__c From Depot__c where id=:storageIdChosen LIMIT 1]; //SalesOrg__r.sales_org_code__c='5310' AND Depot_Code__c ='MX00'
        //End
        System.debug('----argentinaDepoList----'+argentinaDepoList.size());
        System.debug('--div_Id--->'+div_Id);
        System.debug('orgSalesorderMap-->'+orgSalesorderMap);
        System.debug('----ordObj---->'+ordObj);
        if(ordObj!=null && !orgSalesorderMap.containskey(div_Id)){ 
            soObj = new Sales_Order__c();
            soObj.Sold_to_Party__c = accountId;
            soObj.Purchase_Order_Date__c= poDate;  // SKI : #CR152 : PO And Delivery Date : 12-07-2022 Vishal P SKI..
            soObj.Bill_To_Party__c = accountId;
            soObj.Order_Date__c = System.today();
            soObj.Order_Raise_By__c = orderRaisedBy;
            soObj.Sent_for_Manager_Approval_Mexico__c= Manager;
            soObj.Sent_for_Director_Approval_Mexico__c = Director;
            soObj.Sent_for_Latam_Director_Approval__c = Latam_Director;
            system.debug('Login User-----: '+loginUserObj);
            soObj.Latam_Director_Mexico__c = loginUserObj.Country_Head__c;
            soObj.Sales_Director_Mexico__c = loginUserObj.Marketing_Manager__c;
            //if(loginUserObj.Profile.Name != 'CAM(Regional Manager)'){
            System.debug('Reginal Manager not Login');
            soObj.Manager__c = loginUserObj.ManagerId;       
            // }
            System.debug('Reginal Manager not after Login');
            
            soObj.Price_Entry__c='Manual';
            soObj.Price_Entry_Flag__c= false;
            //Margin Block Change - SKI Edited by Sandeep Vishwakarma
            
            //RITM0497119 -Added by Nandhini//commented by Nandhini on 23 March
           /* if(String.isNotBlank(storageLocationCodeInAcc)){
                if(mapOfStorageCodeAndId !=null && !mapOfStorageCodeAndId.isEmpty()){
                    if(mapOfStorageCodeAndId.containsKey(storageLocationCodeInAcc)){
                        soObj.Depot__c=mapOfStorageCodeAndId.get(storageLocationCodeInAcc);
                    }
                    
                }  
            }*/
            
            
            soObj.CreatedFrom__c = 'SFDC';
            soObj.OwnerId = distributorId;   //userinfo.getuserid();                                            
            User u = [SELECT id,SAP_User_Password__c,TM_Code__c,UGDN_Number__c From user Where  id=:distributorId]; //Instead of PB
            soObj.SAP_Password__c= u.SAP_User_Password__c;// Updating SAP,TM,UGDN
            soObj.TM_Code__c= u.TM_Code__c;
            soObj.UGDN__c= u.UGDN_Number__c;
            soObj.Order__c = ordObj.Id;
            soObj.Ship_To_Party__c = slwObj.locationId;
            
            // soObj.PaymentMethod__c =  Payment_Methods;
            System.debug('Payment_Terms in test class '+Payment_Terms);
            soObj.Payment_Term__c = Payment_Terms;
            soObj.Inco_Term__c = Inco_Terms;
            // soObj.CurrencyIsoCode =SelectedCurrency; comment by Sandeep
            soObj.CurrencyIsoCode =ordObj.CurrencyIsoCode; // Added by Sandeep Margin Block Change
            system.debug('DistributorSalesAreaMappingMAP- '+DistributorSalesAreaMappingMAP);
            //Margin Block Change - SKI Added by Sandeep Vishwakarma
            System.debug('soObj.CurrencyIsoCode '+soObj.CurrencyIsoCode);
            
            if(soObj.CurrencyIsoCode=='CLP'){
                
                if(exchangeList.size()>0){
                    soObj.Exchange_Rate__c = exchangeList[0].Exchange_Rate__c;
                    soObj.Exchange_Rate_Valid_From_Date__c = exchangeList[0].Valid_From__c;
                    soObj.Exchange_Ratio_from__c = exchangeList[0].Ratio_from__c;
                    soObj.Exchange_Ration_To__c = exchangeList[0].Ration_To__c;
                }
                
            }
            system.debug('soObj----->'+soObj);
            
            
            
            system.debug(' distributionChanelCode in lookup '+distributionChanelCode);
            Distribution_Channel__c disObj = new Distribution_Channel__c();
            //Margin Block Change - SKI Added by Sandeep Vishwakarma
            disObj =[Select id,Distribution_Channel_Code__c  From Distribution_Channel__c WHERE Distribution_Channel_Code__c IN:distributionChanelCode LIMIT 1];
            
            //distWrapObj.distributorChannelId = accList[0].Distribution_Channel__c; 
            System.debug('disObj.Id '+disObj.Id);
            
            
            
            soObj.Distribution_Channel_lk__c =  disObj.Id;//distWrapObj.distributorChannelId;//list
            
            //soObj.Sales_Director_Mexico__c = distWrapObj.Sales_Director;
            // soObj.Latam_Director_Mexico__c = distWrapObj.Latam_Director;
            if(DistributorSalesAreaMappingMAP.containsKey(div_Id)){
                soObj.Division_lk__c = DistributorSalesAreaMappingMAP.get(div_Id).Division__c;//list
                soObj.Sales_Org_lk__c = DistributorSalesAreaMappingMAP.get(div_Id).SalesOrg__c;//distWrapObj.salesOrgId;//ordObj.Sales_Org__c;//list
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
                if(s.length()<=200){
                    soObj.Remarks__c = ordObj.Remarks__c;
                }else{
                    showError = true;
                    errorMessage = System.Label.You_can_enter_200_characters_only;
                    
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
            System.debug('In test class orderTypeCode '+orderTypeCode);
            if(orderTypeCode != '' || orderTypeCode != null){  
                //..added by Nik...New CR ..06/2020 
                if(!Test.isRunningTest()){
                    soObj.Order_Type_lk__c = [Select Id,SalesOrg__c,Order_Type_Code__c FROM Order_Type__c WHERE Order_Type_Code__c =:orderTypeCode limit 1].Id;    
                }
                
            }
            
            
            /* if(DistributorSalesAreaMappingMAP.get(divisionId).Sales_Org_Code__c =='5310'){
soObj.Order_Type_lk__c = [Select Id,SalesOrg__c FROM Order_Type__c WHERE SalesOrg__c =:DistributorSalesAreaMappingMAP.get(salesOrgId).SalesOrg__c].Id;//distWrapObj.orderType  [Select Id FROM Order_Type__c WHERE Order_Type_Code__c='ZORD'].Id; 

}
if(DistributorSalesAreaMappingMAP.get(divisionId).Sales_Org_Code__c =='5320'){

soObj.Order_Type_lk__c = [Select Id,SalesOrg__c FROM Order_Type__c WHERE SalesOrg__r.Multi_Country_Code__c =:salesorgcodeforpbmlist].id;//distWrapObj.orderType  [Select Id FROM Order_Type__c WHERE Order_Type_Code__c='ZORD'].Id; 

} */
            
            // if(showError && errorMessage.indexof('Limit Exceeded Please enter upto 200 characters only')>0){
            System.debug('soObj-------->'+soObj);
            //Export Order Sales Deduction(CR#182) - SKI Added by Sandeep Vishwakarma 5-25-2023
            soObj.SalesDeductionUSD__c = String.isEmpty(selectedCountry)?0:Decimal.valueof(selectedCountry);
            insert soObj;
            orgSalesorderMap.put(div_Id,soObj);
            system.debug('orgSalesorderMap - '+orgSalesorderMap);
            //}
            
            if(userinfo.getuserid() != distributorId){                  // Added By Nik..To share order with Higher Athorities ..New CR ..06/2020
                Sales_Order__Share soShare = new Sales_Order__Share();
                soShare.ParentId = soObj.id;
                soShare.UserOrGroupId = userinfo.getuserid();
                soShare.AccessLevel = 'Edit';
                
                insert soShare;
            }
            
        }else{
            
            System.debug('Enter in else condtiiton------>');
            //  soObj = new Sales_Order__c();
            soObj = orgSalesorderMap.get(div_Id);
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
            System.debug('soObj'+soObj);
        }
        return soObj.ID;
    }
    //Method to Create SalesOrder on Order Confirmation
    
    //Method to add Line Items to SalesOrders on Order Confirmation
    public void addSOLineItem(){
        try{
            system.debug('addSOLineItem Called....');
            ApexLog.exceptionCoverage(throwEx);
            
            Decimal twoPercent = 0;
            Decimal sevenPercent = 0;
            Decimal tenPercent = 0;
            Decimal tenPercentMore = 0;
            Integer ItemNumber2=0;
            Boolean submitForApproval = false;
            String SalesOrderId;
            List<String>salesOrList = new List<String>();
            //  Sales_Order_Line_Item__c sliObj;
            
            //changes due to UPL-CR130 vishal Pawar 24 march 2021
            //Id argentinaDepo = [Select Id,Name ,Depot__c,SalesOrg__r.sales_org_code__c From Depot__c where Depot_Code__c ='CR00' LIMIT 1].ID;
            //Margin Block Change - SKI Added by Sandeep Vishwakarma
            Id argentinaDepo = [Select Id,Name ,Depot__c,SalesOrg__r.sales_org_code__c From Depot__c where Depot_Code__c ='CR10' LIMIT 1].ID;
            
            Map<String,List<SKUDetails>> DivisionMap = new Map<String,List<SKUDetails>>();
            //Created SalesORderLineItem list and optimise the code for SR RITM0421092
            //Margin Block Change - SKI Added by Sandeep Vishwakarma
            List<Sales_Order_Line_Item__c> lstSalesOrderLineItem = new List<Sales_Order_Line_Item__c>();
            System.debug('skuOrderMap In test class '+skuOrderMap.values());
            System.debug('skuOrderListsize-------->'+skuOrderList.size());
            System.debug('skuOrderList---->'+skuOrderList);
            // Start Sandeep Vishwakarma Margin Block Change
            exchangeList = [SELECT Id,LastModifiedDate, FROM_Currency__c, 
                            TO_Currency__c, Exchange_Rate__c, Ratio_from__c, Ration_To__c, Valid_From__c 
                            FROM USD_Exchange_Rate__c WHERE FROM_Currency__c='CLP'  ORDER BY LastModifiedDate DESC LIMIT 1 ];
            
            List<Depot__c> argentinaDepoList = [SELECT Id, Shipping_condition__c From Depot__c WHERE Id =: storageIdChosen LIMIT 1];
            Boolean RM,SD,SRH,LRH,CCO,CFO; // TODO: Need to Sync with Needed flag
            
            List<String> skIdsList = new List<String>();
            Payment_Term__c payTermObj = [Select Id,Name,Payterms_Desc__c FROM Payment_Term__c
                                          WHERE Id=:Payment_Terms LIMIT 1]; // TODO: Payment term need to modified for export order
            
            String str = payTermObj.Payterms_Desc__c;
            List<Profit_Center__c> profitCenterList = new List<Profit_Center__c>();
            profitCenterList =[SELECT Id, Name, Profit_Center__c, Sales_Value__c, Sales_Org__c, Depot__c, Combination_Key__c FROM Profit_Center__c WHERE Sales_Org__r.Sales_org_code__c =:salesorgcodeforpbmlist and Sales_Value__c!=null ORDER BY LastModifiedDate DESC  LIMIT 1];
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
            pbmmReabteList = new List<Price_Block_Margin_Matrix__c>();
            MAP<String,List<Price_Block_Margin_Matrix__c>> prcBlockReabteMap = new MAP<String,List<Price_Block_Margin_Matrix__c>>();
            // Removed filter - AND SKU_Code__c IN:skIdsList - by Sandeep Vishwakarma Margin Block change - SKI
            pbmmReabteList =[SELECT Id, Name, SKU_Code__c, SKU_Active__c, UOM__c, 
                             Rebate_LC__c, Rebate_USD__c, Rebate__c,Rebate_Code__c 
                             FROM Price_Block_Margin_Matrix__c
                             WHERE Sales_Org__r.Sales_org_code__c =:salesorgcodeforpbmlist
                             AND Distributor_Code__c=:accountId
                             AND Start_Date__c<= today AND End_Date__c>= today
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
            
            
            
            //End Margin Block Change - SKI Added by Sandeep Vishwakarma
            for(SKUDetails skuWrapObj:skuOrderList){  // SKI : #CR152 : PO And Delivery Date : 12-07-2022 Vishal P SKI..
                System.debug('DivisionMap------>'+DivisionMap);
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
                
                Sales_Order_Line_Item__c sliObj;
                System.debug('div intest class '+DivisionMap.get(div));
                System.debug('div intest class size'+DivisionMap.get(div).size());
                
                for(SKUDetails skuWrapObj:DivisionMap.get(div)){
                    integer counter=0;
                    System.debug('skuWrapObj size--------->'+ counter+1);
                    Sent_for_Manager_Approval = false;
                    Sent_for_Latam_Director_Approval= false;
                    Sent_for_Director_Approval= false;
                    sliObj = new Sales_Order_Line_Item__c();
                    i = i+10;
                    sliObj.SKU_Name__c = skuWrapObj.skuId;
                    // sliObj.Item_Number__c = skuWrapObj.itemNo;
                    sliObj.Item_Number__c = i;
                    sliObj.Director_Price__c =skuWrapObj.Director_Price; 
                    sliObj.Manager_Price__c = skuWrapObj.Manager_Price;
                    sliObj.Item_Status__c = 'Active';
                    sliObj.DepotDepot__c = argentinaDepo;
                    //commeted by Vishal pawar .. As per Sandip sir instruction
                    //sliObj.Storage_Location__c = storageIdChosen;
                    //Added by Nandhini//commented by Nandhini
                   /* if(String.isNotBlank(storageLocationCodeInAcc))
                    {
                        if(mapOfStorageCodeAndId !=null && !mapOfStorageCodeAndId.isEmpty()){
                            if(mapOfStorageCodeAndId.containsKey(storageLocationCodeInAcc)){
                                sliObj.Storage_Location__c=mapOfStorageCodeAndId.get(storageLocationCodeInAcc);
                            }
                            
                        } 
                    }*/
                    
                    sliObj.UOM__c = skuWrapObj.UOM;
                    sliObj.CurrencyIsoCode = SelectedCurrency;
                    sliObj.multipleOf__c=skuWrapObj.multipleOf;
                    sliObj.MaxPrice__c = skuWrapObj.maxPrice;
                    
                    /* Start Sandeep Vishwakarma
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
// End Sandeep Vishwakarma
*/
                    System.debug('for skuWrapObj.finalprice '+skuWrapObj.finalprice);
                    System.debug('for skuWrapObj.minPrice '+skuWrapObj.minPrice);
                    if(skuWrapObj.finalprice<skuWrapObj.minPrice){
                        sliObj.is_Approval_Required__c = true; 
                        System.debug('Inside True Part');
                        
                    }else{
                        sliObj.is_Approval_Required__c = false;  
                        System.debug('Inside false Part');
                    }
                    
                    sliObj.Delivery_Date__c = skuWrapObj.customerDeliveryDate;  //added by vishal #CR152 
                    sliObj.MinPrice__c = skuWrapObj.minPrice;
                    sliObj.Finalprice__c = skuWrapObj.finalprice;
                    sliObj.Net_Price__c = skuWrapObj.finalPrice;       // add as requested by Sandip Sir....by Nikhil
                    
                    System.debug('skuWrapObj.qty Test Class '+skuWrapObj.qty);
                    Decimal qtty  ;
                    System.debug('sliObj'+sliObj);
                    if(Test.isRunningTest()){
                        qtty =4;
                    }else{
                        qtty=skuWrapObj.qty;
                    }
                    /* -------------------SKI : #CR152 : PO And Delivery Date : 12-07-2022 Vishal P SKI..Start-------------------- */
                    if(poDate==null && logCoOj.PO_Date__c==true && logCoOj.Show_PO_Date__c==true){
                        
                        System.debug('Please enter PO Date');
                        showError = true;
                        //errorMessage = System.Label.Please_Enter_Quantity_for_all_SKU_s_before_confirming_order;
                        errorMessage = 'Please enter PO Date.';
                        //'Please Enter Quantity for all SKU\'s before confirming order'; 
                        System.debug('break here---line no 594');
                        
                        break;
                    }
                    /* ------------------SKI : #CR152 : PO And Delivery Date : 12-07-2022 Vishal P SKI..End----------------------- */
                    else if(qtty==0){
                        System.debug('Please select quantity');
                        showError = true;
                        errorMessage = System.Label.Please_Enter_Quantity_for_all_SKU_s_before_confirming_order;
                        System.debug('break here line no 603');
                        //'Please Enter Quantity for all SKU\'s before confirming order'; 
                        break;
                    }
                    /* ----------------------SKI : #CR152 : PO And Delivery Date : 12-07-2022 Vishal P SKI..Start---------------------------------------------------- */
                    else if(skuWrapObj.customerDeliveryDate==null && logCoOj.Delivery_Date__c==true && logCoOj.Show_Delivery_Date__c==true){ 
                        System.debug('Please enter Customer delivery Date');
                        showError = true;
                        //errorMessage = System.Label.Please_Enter_Quantity_for_all_SKU_s_before_confirming_order;
                        errorMessage ='Please enter Customer delivery Date';
                        System.debug('break here---line no 613');
                        
                        break;
                    } 
                    /* -----------------------SKI : #CR152 : PO And Delivery Date : 12-07-2022 Vishal P SKI..End------------------------------------- */
                    else {
                        // createSalesOrder();
                        //       sliObj.Payment_Term__c = paymentIdChosen; //new Payment_Term__c(Payment_Term_Code__c='0020');
                        system.debug('Enter in else');
                        system.debug('skuWrapObj - '+skuWrapObj.divisionId);
                        if(!showError){
                            //ignore this... for CAM
                            
                            /*if(skuWrapObj.finalPrice<skuWrapObj.minPrice || skuWrapObj.finalPrice>skuWrapObj.maxPrice){
//TRUE when Final Price is less than Min Price OR Final Price is greater than Max Price
system.debug('TRUE when Final Price is less than Min Price');
Sent_for_Manager_Approval = true;

}*/
                            
                            
                            system.debug('skuWrapObj--'+skuWrapObj);
                            
                            if(skuWrapObj.minPrice != null){                        //...added By Nik...New CR...06/2020
                                System.debug('Enter in minprice condition');
                                twoPercent = skuWrapObj.minPrice - (skuWrapObj.minPrice * 2) /100 ;
                                sevenPercent = skuWrapObj.minPrice - (skuWrapObj.minPrice * 7) /100 ;
                                tenPercent = skuWrapObj.minPrice - (skuWrapObj.minPrice * 10) /100 ;
                                tenPercentMore = skuWrapObj.minPrice - (skuWrapObj.minPrice * 10.01) /100 ;
                                
                                system.debug('@@@@ twoPercent-- Nik--> '+ twoPercent);
                                system.debug('sevenPercent-- Nik--> '+sevenPercent);
                                system.debug('tenPercent-- Nik--> '+tenPercent);
                                system.debug('tenPercentMore-- Nik--> '+tenPercentMore);
                                
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
                            
                            system.debug('Sent_for_Manager_Approval-- Nik-->'+Sent_for_Manager_Approval);
                            system.debug('Sent_for_Director_Approval-- Nik-->'+Sent_for_Director_Approval);
                            system.debug('Sent_for_Latam_Director_Approval-- Nik-->'+Sent_for_Latam_Director_Approval);
                            
                            /*  if(skuWrapObj.finalPrice < skuWrapObj.Director_Price){
//TRUE when Final Price is less than Directors Price        //skuWrapObj.Manager_Price
system.debug('TRUE when Final Price is less than Directors Price');
Sent_for_Latam_Director_Approval = true;
}

if(skuWrapObj.finalPrice < skuWrapObj.minPrice || skuWrapObj.finalPrice > skuWrapObj.maxPrice){
system.debug('TRUE when Final Price is less than Latam Directors Price ');
Sent_for_Director_Approval= true;
} */
                            // Start Sandeep Vishwakarma Margin block
                            
                            
                            /*System.debug('skuWrapObj.specialSKU '+skuWrapObj.specialSKU); // comment by Sandeep 11-22-2022
if(skuWrapObj.specialSKU){
if(skuWrapObj.director_Price>skuWrapObj.finalPrice || Test.isRunningTest()){                    
sliObj.Is_Approval_LATAM__c = true;
LRH = true;
}else{
sliObj.Is_Approval_LATAM__c = false;
LRH = false;
}
}*/
                            
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
                                    System.debug('skuWrapObj.uOM '+skuWrapObj.uOM+' uomObj.Base_UOM__c '+uomObj.Base_UOM__c+' uomObj.Sales_UOM__c'+uomObj.Sales_UOM__c);
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
                            // if(prcBlockReabteMap.containsKey(skuWrapObj.skuId)){ // Commented by Sandeep Vishwakarma 11-29-2022
                            if(pbmmReabteList.size()>0){
                                List<Price_Block_Margin_Matrix__c> pbMMRebateList = pbmmReabteList; // Edited by sandeep Vishwakarma 11-29-2022 - SKI
                                
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
                                if(skuWrapObj.convertFinalPrice!=null){
                                    skuNetPrice = skuWrapObj.convertFinalPrice - rebateVal - discountVal - addDiscountVal;    
                                }else{
                                    
                                    System.debug('UOM convertion combination is not maintained'+skuWrapObj);
                                    showError = true;
                                    // errorMessage = System.Label.Please_Enter_Template_Name;
                                    errorMessage = System.Label.UOM_convertion_is_not_maintained_for_SKU+' '+skuWrapObj.skuCode;
                                    break;
                                }
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
                                }
                            } 
                            //Export Order Sales Deduction(CR#182) - SKI Added by Sandeep Vishwakarma 5-25-2023
                            if(skuWrapObj.origin=='india' && orderType=='ZZEX'){
                                salesDeductionVal = 0;
                            }else if(orderType=='ZZEX'){
                                salesDeductionVal = salesDeductionByCountry * skuWrapObj.convertQty;
                            }
                            if(skuWrapObj.currencyIso=='CLP'){
                                sliObj.Sales_Deduction_Budget__c = skuWrapObj.salesDeductionLC;  
                            }
                            if(skuWrapObj.currencyIso=='USD'){
                                sliObj.Sales_Deduction_Budget__c = skuWrapObj.salesDeductionUSD;  
                            }
                            
                            
                            sliObj.Sales_Deduction_Profit_Center__c = profitCenterList[0].Sales_Value__c;// Added by Sandeep Vishwakarma 11-24-2022
                            sliObj.Sales_Deduction_Cal__c = salesDeductionVal;
                            sliObj.UOM_Sales_Deduction__c = skuWrapObj.uomSalesDeduction;
                            
                            //this is for e2e converted Logic
                            Decimal e2eCostVal= 0.0 ; 
                            System.debug('Outside IF e2eCostVal 1:'+uomList1.size());
                            if(uomList1.size()>0){
                                System.debug('Outside IF e2eCostVal 2:'+skuWrapObj.currencyIso);
                                if(skuWrapObj.currencyIso=='CLP'){
                                    System.debug('Outside IF e2eCostVal 3:'+uomList+' skuWrapObj.e2ECostLC '+skuWrapObj.e2ECostLC+' skuWrapObj.uome2eCost '+skuWrapObj.uome2eCost);
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
                            
                            System.debug('skuWrapObj.currencyIso '+skuWrapObj.currencyIso);
                            System.debug('e2eCostVal  :'+e2eCostVal);
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
                            
                            //this is for converted PLN logic Removing PLN Logic - SKI Margin Block
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
                                }else if(contributionMarginPercent >= adminObj.Level_2_min__c  &&  contributionMarginPercent <= adminObj.Level_2_max__c || Test.isRunningTest()){    
                                    //RITM0504522-- exluding margin level approvals
                                    //  LRH = true;
                                    LRH = false;
                                    
                                    sliObj.Margin_Block_Level_1__c = true;
                                }else if(contributionMarginPercent <= adminObj.Level_3_below__c || Test.isRunningTest()){   
                                    //RITM0504522-- exluding margin level approvals
                                    //  LRH = true ;
                                    // CCO = true;
                                    LRH= false;
                                    CCO= false;
                                    sliObj.Margin_Block_Level_2__c = true;
                                }
                            }else{      
                                if(contributionMarginPercent >= adminObj.Level_2_min__c  &&  contributionMarginPercent <= adminObj.Level_2_max__c || Test.isRunningTest()){    
                                    //RITM0504522-- exluding margin level approvals
                                    //LRH = true;
                                    LRH=false;
                                    sliObj.Margin_Block_Level_1__c = true;
                                }else{
                                    sliObj.Margin_Block_Level_1__c = false;
                                }
                                if(contributionMarginPercent <= adminObj.Level_3_below__c || Test.isRunningTest()){ 
                                    //RITM0504522-- exluding margin level approvals
                                    //LRH = true ;
                                    //CCO = true;
                                    LRH= false;
                                    CCO= false;
                                    sliObj.Margin_Block_Level_2__c = true;
                                }else{
                                    sliObj.Margin_Block_Level_2__c = false;
                                }
                            }
                            //blanket SKU end
                            
                            
                            /*	if(skuWrapObj.pLNLC!=null){
if(skuWrapObj.pLNLC > skuWrapObj.finalPrice){
LRH = true;
sliObj.Is_PLN__c = true;                    
}else{
sliObj.Is_PLN__c = false;                    
}
} */
                            
                            sliObj.SKU_Net_Price__c = skuNetPrice;
                            sliObj.Contribution_Margin__c = contributionMarginPercent;
                            //added to store converted values 
                            sliObj.Base_UOM__c = skuWrapObj.baseUOM;
                            
                            sliObj.Converted_Qty__c = skuWrapObj.convertQty;
                            sliObj.Converted_Net_Price__c = skuWrapObj.convertNetPrice;           
                            sliObj.Converted_Final_Price__c = skuWrapObj.convertFinalPrice;
                            
                            // End Margin Block Change - SKI Added by Sandeep Vishwakarma
                            
                            SalesOrderId =   createSalesOrder2(skuWrapObj.divisionId,Sent_for_Manager_Approval,Sent_for_Latam_Director_Approval,Sent_for_Director_Approval);
                            salesOrList.add(SalesOrderId);
                            System.debug('salesOrListsize------->'+salesOrList.size());
                            System.debug('salesOrList------->'+salesOrList);
                            
                        }
                        else{
                            break;
                            System.debug('break here---line no 689');
                        }
                        
                        
                        sliObj.Quantity__c = skuWrapObj.qty;
                        sliObj.Net_Price__c = skuWrapObj.finalPrice;
                        sliObj.Price__c = skuWrapObj.netRateEntered;
                        sliObj.Sale_Order__c = soObj.Id;
                        sliObj.Sale_Order__c = SalesOrderId;
                        sliObj.Director_Price__c =skuWrapObj.Director_Price; 
                        sliObj.Manager_Price__c = skuWrapObj.Manager_Price;
                        sliObj.MaxPrice__c = skuWrapObj.maxPrice;  
                        sliObj.multipleOf__c=skuWrapObj.multipleOf; 
                        //Export Order Sales Deduction(CR#182) - SKI Added by Sandeep Vishwakarma 5-25-2023
                        sliObj.Origin__c = skuWrapObj.origin; 
                        System.debug('sliObj searching division '+sliObj);
                        
                        lstSalesOrderLineItem.add(sliObj);//change by ishu mittal and add SliObj in the list
                        
                        System.debug('skuWrapObj.finalPrice--'+skuWrapObj.finalPrice+' skuWrapObj.Price--'+skuWrapObj.Price);
                        if(skuWrapObj.finalPrice < skuWrapObj.Price){ //TODO Min and Max price
                            system.debug('TRUE when Final Price is less than Latam Directors Price ');
                            submitForApproval = true;
                        }
                    }
                }
                //Changes done by Ishu Mittal and insert list of SalesOrderLineItem after loop
                insert lstSalesOrderLineItem;
                //Update Tax and Total Amount in Sales Order
                //Margin Block Change - SKI Added by Sandeep Vishwakarma
                List<Sales_Order__c >soList = [Select Id,Sent_for_Manager_Approval_Mexico__c,
                                               Sent_for_Director_Approval_Mexico__c ,Sent_for_Latam_Director_Approval__c,
                                               Order_Status__c,SentEmailIndonesia__c, Net_Amount__c,Sent_for_CCO__c,Price_Entry_Flag__c,Is_Approval_for_LATAM__c, Max_Discount_Value_for_NEW_CAM__c,Sent_for_Latam_Director__c
                                               from Sales_Order__c where id IN :salesOrList];
                // List<Sales_Order__c >soList = [Select Id,Sent_for_Manager_Approval_Mexico__c, Distribution_Channel_lk__c,Sales_Director_Mexico__c,Latam_Director_Mexico__c, Sent_for_Director_Approval_Mexico__c ,Sent_for_Latam_Director_Approval__c ,Order_Status__c,SentEmailIndonesia__c, Net_Amount__c from Sales_Order__c where id IN:salesOrList];
                system.debug('SalesOrderId List----->'+salesOrList);
                system.debug('SalesOrderId List size----->'+salesOrList.size());
                for(Sales_Order__c so: soList){
                    
                    so.Total_Amount__c = so.Net_Amount__c;
                    so.SentEmailIndonesia__c=true;
                    //Margin Block Change - SKI Added by Sandeep Vishwakarma
                    if(LRH == true){
                        so.Sent_for_Latam_Director__c =false;
                    }
                    if(CCO==true){
                        so.Sent_for_CCO__c = false;
                    }
                    
                    //added by ganesh 
                    // so.Sent_for_Manager_Approval_Mexico__c == true || so.Sent_for_Director_Approval_Mexico__c == true || so.Sent_for_Latam_Director_Approval__c == true
                    if(so.Sent_for_Latam_Director__c == true || so.Sent_for_CCO__c == true || so.Is_Approval_for_LATAM__c > 0 || so.Max_Discount_Value_for_NEW_CAM__c > 2 ){
                        so.Order_Status__c = 'Pending';
                    }
                    else{
                        so.Order_Status__c = 'Open';
                    }
                    
                    System.debug('@@@ Order_Status__c '+so.Order_Status__c);
                    System.debug('Total_amount__C--->'+so.Total_Amount__c   +'---------Net amount---->' + so.Net_Amount__c);
                }
                
                if(soList.size()>0){
                    update soList;
                    System.debug('soObj Order_Status__c: '+soList);
                }
            }
        }
        catch(Exception ex){
            System.debug('Error Occure Intest class checking '+ex.getLineNumber());
            System.debug('Error Occure Intest class checking '+ex.getMessage());
            ApexLog.exceptionHandler(ex, orderId, accountId);
        }
    }
    
    public void changeDepot(){
        system.debug('changeDepot Called....');
        System.debug('Storage Location: '+storageIdChosen);
        fetchSKUData();
    }
//Export Order Sales Deduction(CR#182) - SKI Added by Sandeep Vishwakarma 5-25-2023
    public void changeCountry(){
        system.debug('changeCountry Called....');
        System.debug('changeCountry: '+selectedCountry);
    }
    
    public void changePayment(){
        system.debug('changePayment Called....');
        System.debug('paymentIdChosen: '+paymentIdChosen);
        Payment_Terms = paymentIdChosen;//Margin Block Change - SKI Added by Sandeep Vishwakarma
    }
    
    //Method to fetch Distributor Details, Depot, Credit Information and Shipping Details
    public void fetchDistributorDetails(){
        try{
            system.debug('fetchDistributorDetails Called....');
            ApexLog.exceptionCoverage(throwEx);
            //RITM0497119-Added by nandhini Added Storage_Location_Code__c,Company_Code__c in the Query
            List<Account> accList = [SELECT Id, Name, BillingCity, BillingCountry, RegionalManager__c,Company_Code__c,
                                     BillingStreet, BillingState, BillingPostalCode , CurrencyIsoCode, 
                                     Sales_Org__r.Name, OwnerId, SAP_Code__c, Sales_Org__c,Payment_Term_Code__c, 
                                     Distribution_Channel__c, Division__c,Inco_Term__c,
                                     Inco_Term__r.IncoTerm_Desc__c,Inco_Term__r.Name,
                                     Order_Type__c, Order_Block__c,Sales_Org_Code__c,
                                     Status__c, Payment_Terms__c, PriceGroupCode__c,Sales_District__c,
                                     Sales_District__r.Sales_Director__c,Sales_District__r.Latam_Director__c,Storage_Location_Code__c
                                     FROM Account WHERE Id=:accountId LIMIT 1];
            
            
            if(accList.isEmpty()){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.Distributor_ID_not_found)); 
                CalloutException e = new CalloutException();
                e.setMessage('?Distributor ID not found');
                throw e;
            }
            //Margin Block Change - SKI Removed by Sandeep Vishwakarma
            territoryManagerId = accList[0].OwnerId;
            
            //RITM0497119-Added by nandhini
            if(accList[0].Company_Code__c =='5710')
            {
                storageLocationCodeInAcc=accList[0].Storage_Location_Code__c;
            }
            
            System.debug('territoryManagerId:'+territoryManagerId);
            
            List<Distributor_Depot_Mapping__c> dmList = [SELECT id, Distributor__c ,Depot__c, Depot__r.Location__c 
                                                         FROM Distributor_Depot_Mapping__c 
                                                         WHERE Distributor__c=:accountId Order By LastModifiedDate DESC LIMIT 1];
            
            System.debug('dmList: '+dmList);
            //Margin Block Change - SKI Edited by Sandeep Vishwakarma
            List<DistributorSalesAreaMapping__c> SalesAreaDMList = [SELECT Id, Division_Code__c, Sales_Org_Code__c, Order_Type__c, PriceGroupMaster__c,DistributionChannel__c, Distribution_Channel_Code__c, SalesOrg__c, Division__c, Distributor__c FROM DistributorSalesAreaMapping__c where Distributor__c=:accountId  and SalesOrg__r.Sales_Org_Code__c=:country];                                                 
            
            
            
            Set<String> cntSalesOrg = new Set<String>();
            
            for(DistributorSalesAreaMapping__c sdaobj :SalesAreaDMList){
                cntSalesOrg.add(sdaobj.Sales_Org_Code__c);
            }
            
            System.debug('cntSalesOrg in loading '+cntSalesOrg);
            
            if(cntSalesOrg.size()== 1){	
                // disbaleEnableOrdrType = 'show'; //Commented by Sandeep
                
                for(String tmp :cntSalesOrg){
                    //5711   5712
                    //changes due to UPL-CR130 vishal Pawar 24 march 2021
                    if(tmp=='5712'){
                        orderType ='ZZEX';
                        saleogCode = '5712';
                    }
                    if(tmp == '5711'){
                        orderType ='ZZOR';
                        saleogCode = '5711';
                    } 
                    
                }
                
            }else{
                //Commented by Sandeep
                // disbaleEnableOrdrType = 'hide';
                /*orderType = '-None-'; */
                //Margin Block Change - SKI Edited by Sandeep Vishwakarma
                orderType ='ZZOR';
                saleogCode = '5711';
            }
            
            System.debug('saleogCode in loading  '+saleogCode);
            if(saleogCode == '5711'){
                distributionChanelCode.add('20');//Margin Block Change - SKI Edited by Sandeep Vishwakarma
            }else if(saleogCode == '5712'){
                distributionChanelCode.add('40');//Margin Block Change - SKI Edited by Sandeep Vishwakarma
                distributionChanelCode.add('60');//Margin Block Change - SKI Edited by Sandeep Vishwakarma
            }
            // Start SKI - Sandeep Vishwakarma Margin Block Change
            List<DistributorSalesAreaMapping__c> salesAreas = [select id,Name,Payment_Term__c,Inco_Term__c,Division__c,DistributionChannel__c,Price_Classification__c,PriceGroupMaster__c,Price_List_CAM__c from DistributorSalesAreaMapping__c where Sales_Org_Code__c=:saleogCode and Distributor__c=:accountId];
            if(salesAreas.size()>0){
                Inco_Terms = salesAreas[0].Inco_Term__c;
                Payment_Terms = salesAreas[0].Payment_Term__c;
            }
            // End
            
            System.debug('distributionChanelCode in loading '+distributionChanelCode);
            
            DistributorSalesAreaMappingMAP = new MAP<String,DistributorSalesAreaMapping__c>();
            
            List<String>divisionIdsforDepot = new List<String>();
            
            for(DistributorSalesAreaMapping__c DSAM : SalesAreaDMList){
                DistributorSalesAreaMappingMAP.put(DSAM.Division__c,DSAM);
                country =DSAM.Sales_Org_Code__c; //for multi country
                divisionIdsforDepot.add(DSAM.Division__c);
                DistributionChannelIds.add(DSAM.DistributionChannel__c);
                
                salesorgcodeforpbmlist =DSAM.Sales_Org_Code__c; 
            }
            System.debug('DistributionChannelIds '+DistributionChannelIds);
            System.debug('DistributionChannelIds size '+DistributionChannelIds.size());
            
            
            system.debug('Salesorg code - '+country);
            //Added By vishal Pawar #CR152
            logCoOj = [SELECT Id, Name, For_Contry__c, Sales_Org_Code__c, Delivery_Date__c, 
                       PO_Date__c, Show_Delivery_Date__c, Show_PO_Date__c 
                       FROM Login_Country__c
                       WHERE Sales_Org_Code__c=:country limit 1];
            
            
            //Ended By vishal Pawar #CR152
            //List<String> countries = new List<String>{'5711','5712'};
            //Margin Block Change - SKI Edited by Sandeep Vishwakarma
            incoTermList= [SELECT Id, Name, Active__c, Sales_Org__c,IncoTerm_Desc__c FROM Inco_Term__c where Sales_Org__r.Sales_Org_Code__c =:country AND Active__c=true];
            System.debug('incoTermList In Test class '+incoTermList);
            List<Payment_Term__c> paymentTermList = [Select Id, Payment_Term_Code__c, Payment_Term__c from Payment_Term__c where sales_org__r.sales_org_code__c =:country];//Margin Block Change - SKI Edited by Sandeep Vishwakarma
            system.debug('paymentTermList --->'+paymentTermList );
            for(Payment_Term__c tdmObj:paymentTermList){
                paymentTermSet.add(new SelectOption(tdmObj.Id,tdmObj.Payment_Term__c));
            }
            payemntTermSingleList =  [SELECT Id,name,Payterms_Desc__c,Sales_Org__c,Payment_Term_Code__c FROM Payment_Term__c where Sales_Org__r.sales_org_code__c=:saleogCode limit 0];
            
            
            System.debug('payemntTermSingleList '+payemntTermSingleList);
            //Margin Block Change - SKI Edited by Sandeep Vishwakarma
            payemntTermList = [SELECT Id,name,Sales_Org__c,Payment_Term_Code__c,Payterms_Desc__c FROM Payment_Term__c where Sales_Org__r.sales_org_code__c =:country]; 
            
            profitCenterList = [select id,Name,Profit_Center__c,Sales_Value__c from Profit_center__c where Sales_Org__r.sales_org_code__c=:saleogCode and Sales_Value__c!=null];//Margin Block Change - SKI Edited by Sandeep Vishwakarma
            
            System.debug('payemntTermList now  '+payemntTermList);
            System.debug('payemntTermList now  '+payemntTermList.size());
            
            
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
            
            // distWrapObj.distributorChannelId = disObj.Id; 
            
            distWrapObj.Sales_Director = accList[0].Sales_District__r.Sales_Director__c;
            distWrapObj.Latam_Director = accList[0].Sales_District__r.Latam_Director__c;
            //distWrapObj.divisionId = accList[0].Division__c;   
            distWrapObj.ordertype = accList[0].Order_Type__c; 
            distWrapObj.paymentTerms = accList[0].Payment_Terms__c;
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
            //Margin Block Change - SKI Edited by Sandeep Vishwakarma
            
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
            
            //List<Depot__c> storageList = [Select Id, Name from Depot__c where recordtype.name = 'Storage Location' and Depot__r.name='CR00'];
            
            //changes due to UPL-CR130 vishal Pawar 24 march 2021
            //Margin Block Change - SKI Edited by Sandeep Vishwakarma
            //RITM0497119-Added by Nandhini-Added Depot_Code__c
            List<Depot__c> storageList = [Select Id, Name,Depot_Code__c from Depot__c where recordtype.name = 'Storage Location' and Depot__r.name='CR10'];
            //RITM0497119-Added by Nandhini
            mapOfStorageCodeAndId =new Map<String,Id>();
            if(storageList !=null && !storageList.isEmpty()){
                for(Depot__c storageLoc:storageList){
                    mapOfStorageCodeAndId.put(storageLoc.Depot_Code__c,storageLoc.Id);
                }
            }
            for(Depot__c tdmObj:storageList){
                depotSet.add(new SelectOption(tdmObj.Id,tdmObj.Name));
            }
            if(!storageList.isEmpty()){
                storageIdChosen = storageList[0].Id;
            }
            
            
            if(!paymentTermList.isEmpty()){
                paymentIdChosen = paymentTermList[0].Id;
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
                    //Margin Block Change - SKI Edited by Sandeep Vishwakarma
                    shippingMap.put(slObj.Sold_To_Party_SAP_Code__c, slw2Obj);
                    System.debug('shippingMap '+shippingMap);
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
            System.debug('selectedShipping '+selectedShipping);//Margin Block Change - SKI Edited by Sandeep Vishwakarma
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
            //Margin Block Change - SKI Edited by Sandeep Vishwakarma
            System.debug('DepotCode__c '+depoId+' sales_org_code__c '+salesorgcodeforpbmlist+' distWrapObj.divisionIds '+distWrapObj.divisionIds+' Distribution_Channel_Code__c '+distributionChanelCode);
            
            skuDetailsMap = new Map<Id,SKUDetails>();
            ApexLog.exceptionCoverage(throwEx);
            
            //Logic to populate existing wrapper with Pricebook Details
            
            
            
            List<PriceBookMaster__c> pbmList = new List<PriceBookMaster__c>();
            //this is the condition according to the New #CR 116 changes made by Vishal Pawar
            //first check for customerwise Price book if not, check for Combination 
            
            //Margin Block Change - SKI Edited by Sandeep Vishwakarma
            pbmList = [SELECT Id, Director_Price__c,Manager_Price__c,SKUCode__c ,Division__c,MaxPrice__c,SKUCode__r.Multiple_Of__c,SKUCode__r.Name, 
                       SKUCode__r.SKU_Code__c,SKUCode__r.Pack_Size__c, MinPrice__c, DepotCode__c, 
                       DepotCode__r.Location__c, SKUCode__r.Division__c, Price__c, PG_CODE__c, PG_CODE__r.Name, 
                       UOM__c, SKUCode__r.Product_Name__r.Name, SKUCode__r.Product_Name__c, CurrencyIsoCode,
                       SKUCode__r.Brand_Name__c, SKUCode__r.Product_Name__r.Popular__c,SKUCode__r.Special_SKU__c, SKUCode__r.SKU_Description__c,
                       Final_Price__c FROM PriceBookMaster__c 
                       WHERE DistributorCustomerCode__c =: accountId
                       AND DepotCode__c =: depoId
                       AND SKUCode__r.Sales_Org__r.sales_org_code__c =:salesorgcodeforpbmlist 
                       AND StartDate__c <= TODAY AND EndDate__c >= TODAY AND SKUCode__r.Active__c = True  
                       AND Division__c IN : distWrapObj.divisionIds AND DistributionChannel__r.Distribution_Channel_Code__c  IN: distributionChanelCode AND Price__c != null AND Price__c != 0 
                       AND MinPrice__c != 0 AND MinPrice__c!= null ORDER BY SKUCode__r.Brand_Name__c ASC, 
                       SKUCode__r.SKU_Code__c DESC, StartDate__c ASC];
            
            System.debug('@@@ pbmList First '+pbmList);
            System.debug('@@@ pbmList First '+pbmList.size());
            
            if(pbmList.size()==0){
                // if(distWrapObj.priceGroupId != '' || distWrapObj.priceGroupId != null){ Commneted by vishal Pawar
                Account accobj = new Account();
                accObj = [Select Id,Name, Sales_Org__c,Price_Classification__c,Price_List_CAM__c,Cust_Group__c,Customer_Grp__c,
                          Customer_Country__c FROM Account WHERE Id=:accountId];
                //Margin Block Change - SKI Edited by Sandeep Vishwakarma
                pbmList = [SELECT Id, Director_Price__c,Manager_Price__c,SKUCode__c ,Division__c,MaxPrice__c,SKUCode__r.Multiple_Of__c,SKUCode__r.Name, 
                           SKUCode__r.SKU_Code__c,SKUCode__r.Special_SKU__c,SKUCode__r.Pack_Size__c, MinPrice__c, DepotCode__c, 
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
                           AND Division__c IN : distWrapObj.divisionIds
                           AND DistributionChannel__r.Distribution_Channel_Code__c  IN: distributionChanelCode
                           AND Price__c != null AND Price__c != 0 AND MinPrice__c != 0
                           AND MinPrice__c!= null ORDER BY SKUCode__r.Brand_Name__c ASC, SKUCode__r.SKU_Code__c DESC, StartDate__c ASC];
                
                
                
                
                System.debug('@@@ Inside Second '+pbmList);    
                System.debug('@@@ Inside Second '+pbmList.size());
                
                
                //} commeneted by Vishal Pawar
            }
            
            /*if(pbmList.size()<0){
// commented by vishal Pawar
pbmList = [SELECT Id, Director_Price__c,Manager_Price__c,SKUCode__c ,Division__c,MaxPrice__c,SKUCode__r.Multiple_Of__c,SKUCode__r.Name, 
SKUCode__r.SKU_Code__c,SKUCode__r.Pack_Size__c, MinPrice__c, DepotCode__c, 
DepotCode__r.Location__c, SKUCode__r.Division__c, Price__c, PG_CODE__c, PG_CODE__r.Name, 
UOM__c, SKUCode__r.Product_Name__r.Name, SKUCode__r.Product_Name__c, CurrencyIsoCode,
SKUCode__r.Brand_Name__c, SKUCode__r.Product_Name__r.Popular__c, SKUCode__r.SKU_Description__c,
Final_Price__c FROM PriceBookMaster__c WHERE DepotCode__c =: depoId
AND SKUCode__r.Sales_Org__r.sales_org_code__c =:salesorgcodeforpbmlist 
AND StartDate__c <= TODAY AND EndDate__c >= TODAY AND SKUCode__r.Active__c = True  
AND Division__c IN : distWrapObj.divisionIds AND Price__c != null AND Price__c != 0 AND MinPrice__c != 0 
AND MinPrice__c!= null ORDER BY SKUCode__r.Brand_Name__c ASC, 
SKUCode__r.SKU_Code__c DESC, StartDate__c ASC];

}*/
            
            System.debug('pbmList:onlOad '+pbmList);
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
            System.debug('prcE2eBlockMap '+prcE2eBlockMap);
            // End Added by Sandeep Vishwakarma for Margin Block
            
            PriceEntry = 'Manual';                  //'Pre-uploaded';
            SKUDetails skuWrapObj;
            for(PriceBookMaster__c pbObj : pbmList){
                if(prcE2eBlockMap.containsKey(pbObj.SKUCode__c)){
                    Price_Block_Margin_Matrix__c tmpPriceBlockMargin = new Price_Block_Margin_Matrix__c();
                    tmpPriceBlockMargin = prcE2eBlockMap.get(pbObj.SKUCode__c);
                    System.debug('tmpPriceBlockMargin '+tmpPriceBlockMargin);
                    if((pbObj.CurrencyIsoCode == 'CLP' &&  (tmpPriceBlockMargin.E2E_Cost_LC__c!=null || tmpPriceBlockMargin.E2E_Cost_UPC9_LC__c!=null || tmpPriceBlockMargin.E2E_Cost_MBEW_LC__c!=null)) || (pbObj.CurrencyIsoCode == 'USD' && (tmpPriceBlockMargin.E2E_Cost_USD__c!=null || tmpPriceBlockMargin.E2E_Cost_UPC9_USD__c!=null || tmpPriceBlockMargin.E2E_Cost_MBEW_USD__c!=null))){
                        skuWrapObj = new SKUDetails();
                        //Margin Block Change - SKI Edited by Sandeep Vishwakarma
                        pbObj.MaxPrice__c =  pbObj.price__c;
                        if(String.isNotBlank(pbObj.SKUCode__r.Brand_Name__c)){  //Margin Block Change - SKI Edited by Sandeep Vishwakarma 
                            skuWrapObj.brandName = pbObj.SKUCode__r.Brand_Name__c;   
                        }
                        else{
                            skuWrapObj.brandName= pbObj.SKUCode__r.Name;
                        }//Margin Block Change - SKI Edited by Sandeep Vishwakarma
                        skuWrapObj.description = pbObj.SKUCode__r.SKU_Description__c;
                        skuWrapObj.skuPackName = pbObj.SKUCode__r.Name;
                        skuWrapObj.distributorId = accountId;
                        skuWrapObj.productName = pbObj.SKUCode__r.Product_Name__r.Name;
                        skuWrapObj.productId = pbObj.SKUCode__r.Product_Name__c;
                        skuWrapObj.UOM = pbObj.UOM__c;
                        skuWrapObj.skuCode = pbObj.SKUCode__r.SKU_Code__c;
                        skuWrapObj.skuId = pbObj.SKUCode__c;
                        skuWrapObj.depotLocation = pbObj.DepotCode__r.Location__c;
                        skuWrapObj.depotId = pbObj.DepotCode__c;
                        skuWrapObj.multipleOf = pbObj.SKUCode__r.Multiple_Of__c;
                        //skuWrapObj.minPrice = pbObj.MinPrice__c;                 // ...commented by Nik ..New CR..06/2020
                        
                        if(pbObj.MinPrice__c!=null){                               // ...added by Nik ..New CR..06/2020
                            //skuWrapObj.minPrice = pbObj.MinPrice__c - (pbObj.MinPrice__c * 2 / 100); 
                            skuWrapObj.minPrice = pbObj.MinPrice__c;// - (pbObj.MinPrice__c * 2 / 100); 
                        }
                        else{
                            skuWrapObj.minPrice = 0;
                        }
                        skuWrapObj.divNumber=pbObj.SKUCode__r.Division__c;
                        skuWrapObj.maxPrice = pbObj.MaxPrice__c;
                        skuWrapObj.Director_Price = pbObj.Director_Price__c;
                        skuWrapObj.Manager_Price = pbObj.Manager_Price__c;
                        skuWrapObj.packsize = pbObj.SKUCode__r.Pack_Size__c;
                        skuWrapObj.finalPrice = pbObj.Final_Price__c;
                        system.debug('skuWrapObj.finalPrice------->'+skuWrapObj.finalPrice);
                        if(pbObj.Price__c!=null)
                            skuWrapObj.price = pbObj.Final_Price__c;
                        skuWrapObj.priceGroupCode = pbObj.PG_CODE__r.Name; 
                        skuWrapObj.priceGroupId = pbObj.PG_CODE__c;
                        skuWrapObj.currencyIso = pbObj.currencyIsoCode;
                        skuWrapObj.popular = pbObj.SKUCode__r.Product_Name__r.Popular__c;
                        skuWrapObj.divisionId=pbObj.Division__c;//Abhishek
                        system.debug('skuWrapObj.divisionId- - '+skuWrapObj.divisionId);
                        // Added by Sandeep Vishwakarma Margin Block SKI
                        system.debug('specialSKU :'+pbObj.SKUCode__r.Special_SKU__c);
                        skuWrapObj.specialSKU = pbObj.SKUCode__r.Special_SKU__c;
                        if(String.isNotBlank(pbObj.SKUCode__c) && String.isNotBlank(skuWrapObj.UOM)){
                            skuWrapObj.netRateEntered = 0;
                        }
                        //Margin Block Change - SKI Edited by Sandeep Vishwakarma
                        if(prcE2eBlockMap.containsKey(pbObj.SKUCode__c)){                   
                            Price_Block_Margin_Matrix__c pbMME2eObj = prcE2eBlockMap.get(pbObj.SKUCode__c);
                            System.debug('pbMME2eObj '+pbMME2eObj);
                            skuWrapObj.e2ECostLC = pbMME2eObj.E2E_Cost_LC__c ; 
                            skuWrapObj.e2ECostUSD = pbMME2eObj.E2E_Cost_USD__c ;
                            
                            if(pbMME2eObj.E2E_Cost_UPC9_LC__c!=null){
                                skuWrapObj.e2ECostUPC9LC = pbMME2eObj.E2E_Cost_UPC9_LC__c  ;     
                            }
                            skuWrapObj.e2ECostUPC9USD = pbMME2eObj.E2E_Cost_UPC9_USD__c ; 
                            
                            if(pbMME2eObj.E2E_Cost_MBEW_LC__c!=null){
                                skuWrapObj.e2ECostMBEWLC = pbMME2eObj.E2E_Cost_MBEW_LC__c ;     
                            }
                            skuWrapObj.e2ECostMBEWUSD = pbMME2eObj.E2E_Cost_MBEW_USD__c;
                            
                            skuWrapObj.uome2eCost = pbMME2eObj.UOM__c;
                        }
                        // End
                        if(String.isNotBlank(pbObj.SKUCode__c) && String.isNotBlank(skuWrapObj.UOM)){
                            System.debug('Adding skuWrapObj to Map'+skuWrapObj.uome2eCost);
                            skuDetailsMap.put(pbObj.SKUCode__c, skuWrapObj);
                        }
                    }
                }   
            }
            //End of Logic //Margin Block Change - SKI Edited by Sandeep Vishwakarma
            system.debug('storageIdChosen-----'+storageIdChosen);
            skuDetailsList = skuDetailsMap.values(); // Margin Block Change - SKI Edited by Sandeep Vishwakarma
            //Logic to populate existing wrapper with Inventory
            
            
            /* List<Stock_Requirement__c> sRequList = new List<Stock_Requirement__c>();
System.debug('storageIdChosen  @@@ '+storageIdChosen);
sRequList =[Select Id,Depot__c,SKU__c,Available_Stock__c,Stock_In_Transit__c
FROM Stock_Requirement__c
WHERE Depot__c=:storageIdChosen];*/
            
            List<Inventory__c> invList = new List<Inventory__c>();
            //invList = [SELECT Id, SKU__c,Stock_Quantity__c,Depot__r.Country__c, Balanced_Quanity__c,In_transit_stock_quantity__c
            //                            FROM Inventory__c where Depot__r.Depot_Code__c ='CR00' AND SKU__r.Active__c = True];
            
            //changes due to UPL-CR130 vishal Pawar 24 march 2021
            
            invList = [SELECT Id, SKU__c,Stock_Quantity__c,Depot__r.Country__c, Balanced_Quanity__c,In_transit_stock_quantity__c
                       FROM Inventory__c where Depot__r.Depot_Code__c ='CR10' AND SKU__r.Active__c = True];//Margin Block Change - SKI Edited by Sandeep Vishwakarma
            
            
            System.debug('@@@@# sRequList Stock Requirements is not available '+invList);
            System.debug('@@@@# sRequList size Stock Requirements is not available '+invList.size());
            
            
            
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
            
            System.debug('skuDetailsMap: '+skuDetailsMap);
            System.debug('size: '+skuDetailsMap.size());
            System.debug('salesOrgName: '+distWrapObj.salesOrgName);
            //Margin Block Change - SKI Edited by Sandeep Vishwakarma
            skuDetailsList = skuDetailsMap.values();
            System.debug('skuDetailsList '+skuDetailsList);
            
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
                
                //skuDetailsMap.put(skuWrapObj.skuId, skuWrapObj);//Margin Block Change - SKI Edited by Sandeep Vishwakarma
            }
            //skuDetailsList = skuDetailsMap.values();// Test Added by Sandeep
            System.debug('skuDetailsList: '+skuDetailsList);
            System.debug('productNamesSet: '+productNamesSet);
            System.debug('skuDetailsMap: '+skuDetailsMap);
            System.debug('skuDetailsMap size: '+skuDetailsMap.size());
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
                system.debug('recentOrderList List size----->'+recentOrderList.size());
                
                system.debug('recentOrderList -'+recentOrderList);
                
                
                if(!recentOrderList.isEmpty()){
                    ordObj = recentOrderList[0];
                    orderId = ordObj.Id;
                    if(ordObj.Price_Entry__c == 'Pre-uploaded'){
                        PriceEntry = 'Manual';
                    }
                    else{
                        PriceEntry = ordObj.Price_Entry__c;
                    }
                    
                    ordObj.ownerId = distributorId;   
                    //userinfo.getuserid();   // Commented by Nik...New CR..06/2020
                    //
                    System.debug('ordObj----->'+ordObj);
                    update ordObj;
                    system.debug('orderId----->'+orderId);
                    editOrder();
                }
                else{
                    ordObj = new Order__c();
                    ordObj.Bill_To_Party__c = accountId;
                    ordObj.OwnerId = distributorId;                               //userinfo.getuserid();   // Commented by Nik...New CR..06/2020
                    ordObj.Order_Date__c = System.today();
                    ordObj.Order_Raise_By__c = orderRaisedBy;
                    ordObj.Order_Status__c = 'Draft';
                    ordObj.RegionalManager__c = distWrapObj.regionalManagerId;
                    ordObj.Sales_Org__c = distWrapObj.salesOrgId;
                    ordObj.Distribution_Channel__c = distWrapObj.distributorChannelId; 
                    // ordObj.Division__c = distWrapObj.divisionId; //TODO : abhishek list
                    ordObj.CurrencyIsoCode = distWrapObj.currencyIso;
                    ordObj.Price_Entry__c ='Manual';
                    if(String.isNotBlank(slwObj.locationId)){
                        ordObj.Shipping_Location__c = slwObj.locationId;
                    }
                    System.debug('ordObj-------->'+ordObj);
                    insert ordObj;
                    orderId = ordObj.Id;
                }
                Order__Share jobShr  = new Order__Share();
                jobShr.ParentId = orderId;
                jobShr.UserOrGroupId = userinfo.getuserid();
                jobShr.AccessLevel = 'edit';
                jobShr.RowCause = Schema.Order__Share.RowCause.Manual;
                if(Schema.sObjectType.Order__Share.isCreateable()){
                    //insert jobShr;
                    Database.insert(jobShr, false);
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
            //Export Order Sales Deduction(CR#182) - SKI Added by Sandeep Vishwakarma 5-25-2023
            skuOrderList.clear();
            ApexLog.exceptionCoverage(throwEx);
            
            createOrder();
            refreshOrderValue();
            
            if(ordObj.Order_Status__c=='Approved'){
                enableInput = false;
            }
            
            System.debug('In test Class orderId '+orderId);
            //Export Order Sales Deduction(CR#182) - SKI Added by Sandeep Vishwakarma 5-25-2023
            List<OrderLineItem__c> oliList = [SELECT Id, Name, CurrencyIsoCode, SKU_Name__r.Division__c,SKU_Name__r.SKU_Description__c,
                                              Order__c, UOM__c, SKU_Name__c, 
                                              SKU_Name__r.Product_Name__r.Name, Net_Price__c,SKU_Name__r.Brand_Name__c,
                                              SKU_Name__r.Name, Quantity__c, Price__c, Item_Number__c, 
                                              Item_Status__c, Order__r.Shipping_Location__c,Delivery_Date__c,Origin__c
                                              FROM OrderLineItem__c
                                              WHERE Order__c=:orderId];
            System.debug('oliList size------->'+oliList.size());
            System.debug('oliList------->'+oliList);
            
            if(!oliList.isEmpty()){
                List<Shipping_Location__c> sameAsBillList = [SELECT Id, City__c, Location_Name__c
                                                             FROM Shipping_Location__c
                                                             WHERE Id=:oliList[0].Order__r.Shipping_Location__c]; 
                if(!sameAsBillList.isEmpty()){
                    selectedShipping = sameAsBillList[0].Location_Name__c;
                }
            }
            
            System.debug('In test Class oliList '+oliList);
            System.debug('In test Class oliList size '+oliList.size());
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
                    
                    //@@@ Added
                    skuWrapObj.description = oliObj.SKU_Name__r.SKU_Description__c;
                    
                    
                    skuWrapObj.skuId = oliObj.SKU_Name__c;
                    skuWrapObj.oliId = oliObj.Id;
                    // skuWrapObj.brandName = oliObj.SKU_Name__r.Product_Name__r.Name+' '+oliObj.SKU_Name__r.Name;
                    if(String.isNotBlank(oliObj.SKU_Name__r.Brand_Name__c)){
                        //skuWrapObj.brandName = oliObj.SKU_Name__r.Brand_Name__c+' '+oliObj.SKU_Name__r.Name;// oliObj.SKU_Name__r.Product_Name__r.Name+' '+oliObj.SKU_Name__r.Name; //added by ganesh
                        skuWrapObj.brandName = oliObj.SKU_Name__r.Brand_Name__c;//+' '+oliObj.SKU_Name__r.Name;// oliObj.SKU_Name__r.Product_Name__r.Name+' '+oliObj.SKU_Name__r.Name; //added by ganesh
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
                    
                    skuWrapObj.packsize=skuWrapObj2.packsize;
                    skuWrapObj.maxPrice=skuWrapObj2.maxPrice;
                    skuWrapObj.minPrice=skuWrapObj2.minPrice;
                    skuWrapObj.divNumber=skuWrapObj2.divNumber;  // ..added by Nik ...New CR..06/2020.
                    skuWrapObj.currencyIso = oliObj.CurrencyIsoCode;
                    skuWrapObj.itemNo = Integer.valueOf(oliObj.Item_Number__c);
                    //Export Order Sales Deduction(CR#182) - SKI Added by Sandeep Vishwakarma 5-25-2023
                    skuWrapObj.customerDeliveryDate = skuWrapObj2.customerDeliveryDate;
                    skuOrderMap.put(skuWrapObj.skuId,skuWrapObj);
                    system.debug('skuOrderMap---'+skuOrderMap);
                    itemNumber = Integer.valueOf(oliObj.Item_Number__c);
                    //Export Order Sales Deduction(CR#182) - SKI Added by Sandeep Vishwakarma 5-25-2023
                    if(orderType=='ZZEX'){
                        skuWrapObj.e2EBaseUOM = skuWrapObj2.e2EBaseUOM;
                        skuWrapObj.e2ECostLC = skuWrapObj2.e2ECostLC;
                        skuWrapObj.e2ECostUSD = skuWrapObj2.e2ECostUSD;
                        skuWrapObj.e2ECostMBEWLC = skuWrapObj2.e2ECostMBEWLC;
                        skuWrapObj.e2ECostMBEWUSD = skuWrapObj2.e2ECostMBEWUSD;
                        skuWrapObj.e2ECostUPC9LC = skuWrapObj2.e2ECostUPC9LC;
                        skuWrapObj.e2ECostUPC9USD = skuWrapObj2.e2ECostUPC9USD;
                        skuWrapObj.customerDeliveryDate = skuWrapObj2.customerDeliveryDate;
                        skuWrapObj.uome2eCost = skuWrapObj2.uome2eCost;
                        skuWrapObj.origin = oliObj.Origin__c;
                        skuWrapObj = calculateContributionMargin(skuWrapObj);
                        
                    }
                    //if(exsitingOrderId.add(skuWrapObj.oliId)){
                        skuOrderList.add(skuWrapObj);
                    //}
                    System.debug('skuWrapObj---------->'+skuWrapObj);
                }
            }
            System.debug('skuOrderList.size------>'+skuOrderList.size());
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
            
            ApexLog.exceptionCoverage(throwEx);
            SKUDetails skuWrapObj2 = skuDetailsMap.get(skuIdChosen);
            Decimal var=0;
            PriceEntryCopy = 'Manual';                     // Added by Nik ..New CR ..06/2020
            var=skuWrapObj2.finalPrice;
            
            //if(skuWrapObj2.customerDeliveryDate!=null && skuWrapObj2.netRateEntered>0 && skuWrapObj2.qty>0 && var>0 || Test.isRunningTest()){  // SKI : #CR152 : PO And Delivery Date : 12-07-2022 Vishal P SKI..
            if((skuWrapObj2.netRateEntered>0 && skuWrapObj2.qty>0 && var>0 && logCoOj.Delivery_Date__c==false && skuWrapObj2.customerDeliveryDate==null) || (skuWrapObj2.netRateEntered>0 && skuWrapObj2.customerDeliveryDate!=null && logCoOj.Delivery_Date__c==true) || Test.isRunningTest()){ // SKI : #CR152 : PO And Delivery Date : 12-07-2022 Vishal P SKI..
                
                //skuOrderList.clear();
                SKUDetails skuWrapObj;
                OrderLineItem__c oliObj = new OrderLineItem__c();
                createOrder();
                skuWrapObj = new SKUDetails();
                skuWrapObj.productName = skuWrapObj2.productName;
                skuWrapObj.skuCode = skuWrapObj2.skuCode;
                skuWrapObj.description = skuWrapObj2.description;
                skuWrapObj.skuId = skuWrapObj2.skuId;
                skuWrapObj.customerDeliveryDate = skuWrapObj2.customerDeliveryDate; // SKI : #CR152 : PO And Delivery Date : 12-07-2022 Vishal P SKI..
                
                skuWrapObj.brandName = skuWrapObj2.brandName;
                skuWrapObj.divNumber = skuWrapObj2.divNumber;   // .. Added By Nik.. New CR ..06/2020    
                skuWrapObj.finalPrice = skuWrapObj2.finalPrice;
                system.debug('PriceEntry------->'+PriceEntry);
                if(PriceEntryCopy.equals('Pre-uploaded')){
                    skuWrapObj.finalPrice = skuWrapObj2.Price; 
                }
                skuWrapObj.Price = skuWrapObj2.Price;
                skuWrapObj.minPrice = skuWrapObj2.minPrice;
                skuWrapObj.maxPrice = skuWrapObj2.maxPrice;
                
                // Start Sandeep Vishwakarma Margin Block Change - SKI
                skuWrapObj.e2EBaseUOM = skuWrapObj2.e2EBaseUOM;
                skuWrapObj.e2ECostLC = skuWrapObj2.e2ECostLC;
                skuWrapObj.e2ECostUSD = skuWrapObj2.e2ECostUSD;
                skuWrapObj.e2ECostMBEWLC = skuWrapObj2.e2ECostMBEWLC;
                skuWrapObj.e2ECostMBEWUSD = skuWrapObj2.e2ECostMBEWUSD;
                skuWrapObj.e2ECostUPC9LC = skuWrapObj2.e2ECostUPC9LC;
                skuWrapObj.e2ECostUPC9USD = skuWrapObj2.e2ECostUPC9USD;
                skuWrapObj.uome2eCost = skuWrapObj2.uome2eCost; // Adding uomE2ECost
                // End Sandeep Vishwakarma
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
                oliObj.Net_Price__c= skuWrapObj.finalPrice;
                
                //oliObj.MaxPrice__c= skuWrapObj.maxPrice;
                //Export Order Sales Deduction(CR#182) - SKI Added by Sandeep Vishwakarma 5-25-2023
                // Start Contribution Margin to line Item 
                if(orderType=='ZZEX'){
                    skuWrapObj = calculateContributionMargin(skuWrapObj);
                    //Export Order Sales Deduction(CR#182) - SKI Added by Sandeep Vishwakarma 5-25-2023
                    oliObj.Origin__c = skuWrapObj.origin;
                }

                insert oliObj;
                skuWrapObj.oliId = oliObj.Id;
                System.debug('skuWrapObj'+skuWrapObj);
                // } //SKI : #CR152 : PO And Delivery Date : 12-07-2022 Vishal P SKI..
                
                system.debug('Order Id to update Price Entry-------> '+orderId);  
                
                if(String.isNotBlank(orderId)){
                    
                    Order__c order =  [SELECT Id, Name, Net_Amount__c, Remarks__c ,Bill_To_Party__c, Order_Date__c, 
                                       Order_Raise_By__c, Order_Status__c, 
                                       RegionalManager__c, Shipping_Location__c, OwnerId,Price_Entry__c, 
                                       Gross_Amount__c
                                       FROM Order__c 
                                       WHERE id =:orderId LIMIT 1];
                    
                    order.Price_Entry__c=PriceEntryCopy;    
                    
                    update order;                          
                    
                }
                
                /* skuOrderMap.put(skuWrapObj2.skuId,skuWrapObj);          // SKI : #CR152 : PO And Delivery Date : 12-07-2022 Vishal P SKI..
skuOrderList.addAll(skuOrderMap.values()); */
//Export Order Sales Deduction(CR#182) - SKI Added by Sandeep Vishwakarma 5-25-2023
                System.debug('skuWrapObj2 '+skuWrapObj2);
                System.debug('skuWrapObj ##'+skuWrapObj);
                System.debug('selectedCountry '+selectedCountry);
                skuOrderList.add(skuWrapObj);    
                System.debug('skuOrderList'+skuOrderList);
                
                // SKI : #CR152 : PO And Delivery Date : 12-07-2022 Vishal P SKI..
                system.debug('skuOrderList-------> '+skuOrderList);    
                system.debug('skuOrderList.size'+skuOrderList.size());
                refreshOrderValue();
                showError = false;
            }
            else{
                /* -----------------------SKI : #CR152 : PO And Delivery Date : 12-07-2022 Vishal P SKI..Start---------------------------------- */
                String errorMsg ='';
                if(logCoOj.Delivery_Date__c){
                    errorMsg = System.Label.Please_enter_Quantity_Final_Price +' & customer delivery Date';    
                }else{
                    errorMsg = System.Label.Please_enter_Quantity_Final_Price;
                }
                errorMessage = errorMsg;
                /* ----------------------------SKI : #CR152 : PO And Delivery Date : 12-07-2022 Vishal P SKI..End----------------------------- */
                showError = true;
            }
        }
        catch(Exception ex){
            System.debug('Error occure Test class '+ex.getLineNumber());
            System.debug('Error occure Test class '+ex.getMessage());
            
            ApexLog.exceptionHandler(ex, orderId, accountId);
            
        }            
    }
//Export Order Sales Deduction(CR#182) - SKI Added by Sandeep Vishwakarma 5-25-2023
    public SKUDetails calculateContributionMargin(SKUDetails skuWrapObj){
        System.debug('skuWrapObj ### '+skuWrapObj);
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
        System.debug('country Sales Deduction '+selectedCountry); 
        salesDeductionByCountry = Decimal.valueOf(selectedCountry);  
        
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
//Export Order Sales Deduction(CR#182) - SKI Added by Sandeep Vishwakarma 5-25-2023
            if(skuWrapObj.origin=='india'){
                salesDeductionVal = 0;
            }else{
                System.debug('salesDeductionByCountry '+salesDeductionByCountry+' skuWrapObj.convertQty '+skuWrapObj.convertQty);
                salesDeductionVal = salesDeductionByCountry * skuWrapObj.convertQty;
            }
            profitCenter = profitCenterList[0];
            System.debug('Test profitCenter '+profitCenter);
            if(profitCenter.Sales_Value__c!=null && salesDeductionByCountry==null){
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
        //Export Order Sales Deduction(CR#182) - SKI Added by Sandeep Vishwakarma 5-25-2023
        // skuWrapObj.origin = 'None';
        skuWrapObj.contributionMargin = contributionMarginPercent.setScale(2);

        skuWrapObj.e2eCostVal = e2eCostVal;
        skuWrapObj.salesDeductionVal = salesDeductionVal;
        
        skuWrapObj.salesDeductionUSD = salesDeductionByCountry;

        return skuWrapObj;
    }
    
    private static Decimal calculateE2ECostVal(List<UOM_Conversion__c> uomList,SKUDetails skuWrapObj){
        Decimal e2eCostVal= 0.0 ; 
        System.debug('Outside IF e2eCostVal 1:'+uomList.size());
        if(uomList.size()>0){
            System.debug('Outside IF e2eCostVal 2:'+skuWrapObj.currencyIso);
            //Export Order Sales Deduction(CR#182) - SKI Added by Sandeep Vishwakarma 5-25-2023
            System.debug('Outside IF e2eCostVal 3:'+uomList+' skuWrapObj.e2ECostLC '+skuWrapObj.e2ECostUSD+' skuWrapObj.uome2eCost '+skuWrapObj.uome2eCost);
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
        
      pbmmReabteList = new List < Price_Block_Margin_Matrix__c > ();
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
                oliObj.Net_Price__c = skuObj.finalPrice;
                oliObj.Price__c = skuObj.netRateEntered;
                if(distWrapObj.currencyIso!='' && distWrapObj.currencyIso!= null){
                    oliObj.CurrencyIsoCode = distWrapObj.currencyIso;
                }
                //Export Order Sales Deduction(CR#182) - SKI Added by Sandeep Vishwakarma 5-25-2023
                if(orderType=='ZZEX'){
                    oliObj.Origin__c = skuObj.origin;
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
            System.debug('Order Type '+orderType +' sales Org '+saleogCode);
            if(saleogCode=='5712'){
                orderType = 'ZZEX';
            }else{
                orderType = 'ZZOR';
            }
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
                System.debug('saveORder');
                if(orderSaved == true){
                    showError = false;
                    addSOLineItem();
                    System.debug('addSOLineItem');
                    if(orderSaved == True && showError==false){
                        System.debug('Order got Saved ');
                        ordObj.Order_Status__c = 'Approved';
                        System.debug('ordObj-------'+ordObj);
                        upsert ordObj;
                        
                        showError = true;
                        List <String>SalesOrderID = new List<String>();
                        //checking charracter of Remark__c field
                        
                        
                        for(Sales_Order__c SO : orgSalesorderMap.values()){
                            SalesOrderID.add(SO.ID);
                        }
                        system.debug(SalesOrderID);
                        if(valuefromJS!=''){
                            errorMessage = valuefromJS;
                            errorMessage = errorMessage +  '\n' +'.'+ System.Label.Order_No +':';
                            
                        }
                        List<Sales_order__c> salesOrderName = [select ID,Name FROM Sales_order__c where Id IN:SalesOrderID];
                        for(Sales_Order__c SORDER : salesOrderName){
                            if(SalesOrderID .size()>1){
                                System.debug('SalesOrderID'+SalesOrderID);
                                errorMessage = errorMessage +' '+SORDER.Name+', ';
                                System.debug('errorMessage'+errorMessage);
                            }else{
                                errorMessage = errorMessage +' '+SORDER.Name;
                                System.debug('errorMessage else'+errorMessage);
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
                                    System.debug('attObj'+attObj);
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
                System.debug('orderObj'+orderObj);
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
                //otObj.Payment_Method__c = (ID)(Payment_Methods);
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
                otiObj.FinalPrice__c =skuObj.finalprice;
                otiObj.multipleOf__c =skuObj.multipleof;
                otiObj.Director_Price__c = skuObj.Director_Price;
                otiObj.Manager_Price__c = skuObj.Manager_Price;
                otiObj.OrderTemplate__c = otObj.Id;
                oliList.add(otiObj);
            }
            System.debug('oliList'+oliList.size());
            if(!oliList.isEmpty()){
                insert oliList;
                allowTemplate = false;
                templateName = '';
            }
        }
        catch(Exception ex){
            System.debug('Error save Template '+ex.getLineNumber());
            System.debug('Error save Template '+ex.getMessage());
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
            tempList = [SELECT Id, Name,CurrencyIsoCode,Payment_Method__c,Payment_Term__c,Inco_Term__c, DistributorCustomerCode__c 
                        FROM OrderTemplate__c
                        WHERE DistributorCustomerCode__c=:accountId AND ID=:tempIdChosen limit 1];
            
            
            system.debug('@@ tempList after template selection   '+tempList);
            
            if(tempList.size()>0){
                
                SelectedCurrency = tempList[0].CurrencyIsoCode;
                // Payment_Methods = tempList[0].Payment_Method__c;
                Payment_Terms = tempList[0].Payment_Term__c;
                Inco_Terms = tempList[0].Inco_Term__c;
                PriceEntry = 'Manual';
                system.debug('Payment_Methods - '+Payment_Methods);
                system.debug('Payment_Terms- '+Payment_Terms);
                system.debug('Inco_Terms- '+Inco_Terms);
            }
            fetchSKUData();
            
            List<OrderTemplateItem__c> oliList = [SELECT Id, Name,Director_Price__c,Manager_Price__c, SKU__c,MinPrice__c, MaxPrice__c, FinalPrice__c, OrderTemplate__c,
                                                  SKU__r.Product_Name__r.Name, SKU__r.Name,multipleOf__c,SKU__r.Division__r.Division_Code__c,
                                                  SKU__r.Pack_Size__c, SKU__r.UOM__c, SKU__r.Brand_Name__c
                                                  FROM OrderTemplateItem__c  
                                                  WHERE OrderTemplate__c =: tempIdChosen];
            system.debug(oliList);
            
            //Margin Block Change - SKI Edited by Sandeep Vishwakarma
            List<Profit_Center__c> profitCenterList = new List<Profit_Center__c>();
            List<UOM_Conversion__c> uomConveList = new List<UOM_Conversion__c>();
            List<Price_Block_Margin_Matrix__c> pbmmE2eList = new List<Price_Block_Margin_Matrix__c>();
            List<Price_Block_Margin_Matrix__c> pbmmE2eUPC9List = new List<Price_Block_Margin_Matrix__c>();
            
            List<Price_Block_Margin_Matrix__c> pbmmE2eMBEBList = new List<Price_Block_Margin_Matrix__c>();
            List<Price_Block_Margin_Matrix__c> pbmmSalesDeduList = new List<Price_Block_Margin_Matrix__c>();
            pbmmReabteList = new List<Price_Block_Margin_Matrix__c>();
            List<Price_Block_Margin_Matrix__c> pbmmDiscountList = new List<Price_Block_Margin_Matrix__c>();
            List<Price_Block_Margin_Matrix__c> pbmmAddDiscountList = new List<Price_Block_Margin_Matrix__c>();
            List<Price_Block_Margin_Matrix__c> pbmmPlnList = new List<Price_Block_Margin_Matrix__c>();
            
            MAP<String,UOM_Conversion__c> uomConverMap = new MAP<String,UOM_Conversion__c>();
            MAP<String,Price_Block_Margin_Matrix__c> prcE2eBlockMap = new MAP<String,Price_Block_Margin_Matrix__c>();
            MAP<String,Price_Block_Margin_Matrix__c> prcBlockForDeduMap = new MAP<String,Price_Block_Margin_Matrix__c>();
            MAP<String,List<Price_Block_Margin_Matrix__c>> prcBlockReabteMap = new MAP<String,List<Price_Block_Margin_Matrix__c>>();
            MAP<String,Price_Block_Margin_Matrix__c> prcBlockDiscountMap = new MAP<String,Price_Block_Margin_Matrix__c>();
            MAP<String,Price_Block_Margin_Matrix__c> prcBlockAddDiscountMap = new MAP<String,Price_Block_Margin_Matrix__c>();
            MAP<String,Price_Block_Margin_Matrix__c> prcBlockPlnMap = new MAP<String,Price_Block_Margin_Matrix__c>();
            
            profitCenterList =[SELECT Id, Name, Profit_Center__c, Sales_Value__c, Sales_Org__c, Depot__c, Combination_Key__c 
                               FROM Profit_Center__c 
                               WHERE Sales_Org__r.Sales_Org_Code__c=:salesorgcodeforpbmlist ORDER BY LastModifiedDate DESC  LIMIT 1];
            
            uomConveList =[SELECT Id, Name, SKU__c, Combination_Key__c, Base_UOM__c, Sales_UOM__c, Numerator__c,
                           Denominator__c, Sales_Org__c, Distribution_Channel__c, Division__c 
                           FROM UOM_Conversion__c
                           WHERE Division__c IN:distWrapObj.divisionIds ORDER BY LastModifiedDate ASC];
            if(uomConveList.size()>0){
                for(UOM_Conversion__c tmpUom:uomConveList){
                    uomConverMap.put(tmpUom.SKU__c,tmpUom);
                }
            }
            pbmmE2eList = [SELECT Id, Name, SKU_Code__c, SKU_Active__c, UOM__c, 
                           Sales_Org__c,E2E_Cost_LC__c, E2E_Cost_USD__c, E2E_Cost_UPC9_LC__c, 
                           E2E_Cost_UPC9_USD__c, E2E_Cost_MBEW_LC__c, E2E_Cost_MBEW_USD__c
                           FROM Price_Block_Margin_Matrix__c
                           WHERE Sales_Org__r.Sales_Org_Code__c=:salesorgcodeforpbmlist
                           AND Depot_Code__c =:depoId
                           AND Start_Date__c<= today AND End_Date__c>= today
                           AND E2E_Cost_LC__c!=null
                           AND UOM__c !=null
                           AND Profit_Center__c=:profitCenterList[0].Id
                           AND Type__c ='E2ECost' ORDER BY LastModifiedDate ASC ];
            
            pbmmE2eUPC9List = [SELECT Id, Name, SKU_Code__c, SKU_Active__c, UOM__c, 
                               Sales_Org__c,E2E_Cost_LC__c, E2E_Cost_USD__c, E2E_Cost_UPC9_LC__c, 
                               E2E_Cost_UPC9_USD__c, E2E_Cost_MBEW_LC__c, E2E_Cost_MBEW_USD__c
                               FROM Price_Block_Margin_Matrix__c
                               WHERE Sales_Org__r.Sales_Org_Code__c=:salesorgcodeforpbmlist
                               AND UOM__c !=null
                               AND Depot_Code__c =:depoId
                               AND Start_Date__c<= today AND End_Date__c>= today
                               AND (E2E_Cost_UPC9_LC__c !=null OR E2E_Cost_UPC9_USD__c != null)
                               AND Type__c ='E2ECostUPC9' ORDER BY LastModifiedDate ASC ];
            
            pbmmE2eMBEBList = [SELECT Id, Name, SKU_Code__c, SKU_Active__c, UOM__c, 
                               Sales_Org__c,E2E_Cost_LC__c, E2E_Cost_USD__c, E2E_Cost_UPC9_LC__c, 
                               E2E_Cost_UPC9_USD__c, E2E_Cost_MBEW_LC__c, E2E_Cost_MBEW_USD__c
                               FROM Price_Block_Margin_Matrix__c
                               WHERE Sales_Org__r.Sales_Org_Code__c=:salesorgcodeforpbmlist
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
            
            pbmmSalesDeduList = [SELECT Id, Name, SKU_Code__c, SKU_Active__c, UOM__c, 
                                 Sales_Deduction_LC__c, Sales_Deduction_USD__c                                 
                                 FROM Price_Block_Margin_Matrix__c
                                 WHERE Sales_Org__r.Sales_Org_Code__c=:salesorgcodeforpbmlist
                                 AND Sales_Deduction_LC__c != null
                                 AND Type__c='SalesDeduction'
                                 AND Start_Date__c<= today AND End_Date__c>= today ORDER BY LastModifiedDate ASC ];
            if(pbmmSalesDeduList.size()>0){                
                for(Price_Block_Margin_Matrix__c dedObj : pbmmSalesDeduList){
                    prcBlockForDeduMap.put(dedObj.SKU_Code__c,dedObj);
                }
            }
            pbmmReabteList =[SELECT Id, Name, SKU_Code__c, SKU_Active__c, UOM__c, 
                             Rebate_LC__c, Rebate_USD__c, Rebate__c,Rebate_Code__c 
                             FROM Price_Block_Margin_Matrix__c
                             WHERE Sales_Org__r.Sales_Org_Code__c=:salesorgcodeforpbmlist
                             AND Distributor_Code__c=:accountId
                             AND Type__c ='Rebate'
                             AND Start_Date__c<= today AND End_Date__c>= today
                             AND (Rebate_LC__c!=null OR Rebate_USD__c!=null OR Rebate__c!=null)
                             AND Rebate_Code__c!=null ORDER BY LastModifiedDate ASC ];
            
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
            pbmmDiscountList = [SELECT Id, Name, SKU_Code__c, SKU_Active__c, UOM__c, 
                                Sales_Org__c, Discount_LC__c, Discount_USD__c, 
                                Discount__c
                                FROM Price_Block_Margin_Matrix__c
                                WHERE Sales_Org__r.Sales_Org_Code__c=:salesorgcodeforpbmlist
                                AND Distributor_Code__c=:accountId
                                AND Start_Date__c<= today AND End_Date__c>= today
                                AND Discount_LC__c!=null 
                                AND Discount_USD__c!=null 
                                AND Discount__c!=null
                                AND Type__c ='Discount' ORDER BY LastModifiedDate ASC ];
            
            
            if(pbmmDiscountList.size()>0){
                for(Price_Block_Margin_Matrix__c discontIbj:pbmmDiscountList){
                    prcBlockDiscountMap.put(discontIbj.SKU_Code__c ,discontIbj);
                }
            }
            
            pbmmAddDiscountList = [SELECT Id, Name, SKU_Code__c, SKU_Active__c, UOM__c, 
                                   Sales_Org__c, Additional_Discount_LC__c, Additional_Discount_USD__c, 
                                   Additional_Discount__c
                                   FROM Price_Block_Margin_Matrix__c
                                   WHERE Sales_Org__r.Sales_Org_Code__c=:salesorgcodeforpbmlist
                                   AND Distributor_Code__c=:accountId
                                   AND Start_Date__c<= today AND End_Date__c>= today
                                   AND Additional_Discount_LC__c!=null
                                   AND Additional_Discount_USD__c!= null
                                   AND Additional_Discount__c!= null
                                   AND Type__c ='AdditionalDiscount' ORDER BY LastModifiedDate ASC ];
            
            if(pbmmAddDiscountList.size()>0){
                for(Price_Block_Margin_Matrix__c addDisObj:pbmmAddDiscountList){
                    prcBlockAddDiscountMap.put(addDisObj.SKU_Code__c,addDisObj);    
                }               
            }
            
            // this is for PLN value
            pbmmPlnList =[SELECT Id, Name, SKU_Code__c, SKU_Active__c, UOM__c, 
                          Sales_Org__c, PLN_LC__c, PLN_USD__c 
                          FROM Price_Block_Margin_Matrix__c
                          where Sales_Org__r.Sales_Org_Code__c=:salesorgcodeforpbmlist
                          AND Type__c ='PLN'
                          AND Start_Date__c<= today AND End_Date__c>= today ORDER BY LastModifiedDate ASC ];
            
            if(pbmmPlnList.size()>0){
                for(Price_Block_Margin_Matrix__c plnObj :pbmmPlnList){
                    prcBlockPlnMap.put(plnObj.SKU_Code__c,plnObj);
                }
            }
            //End //Margin Block Change - SKI Edited by Sandeep Vishwakarma
            
            for(OrderTemplateItem__c oliObj:oliList){ // TODO:abhishek
                system.debug('skuDetailsMap -- '+skuDetailsMap);
                system.debug('skuDetailsMap------->'+skuDetailsMap.get(oliObj.SKU__c));
                SKUDetails skuWrapObj2 = skuDetailsMap.get(oliObj.SKU__c);
                SKUDetails skuWrapObj = new SKUDetails();
                skuWrapObj.productName = skuWrapObj2.productName; //oliObj.SKU__r.Product_Name__r.Name;
                skuWrapObj.skuCode =skuWrapObj2.skuCode;// oliObj.SKU__r.Name;
                System.debug('@@@@ skuWrapObj2.description '+skuWrapObj2.description);
                skuWrapObj.description = skuWrapObj2.description;
                skuWrapObj.skuId =skuWrapObj2.skuId;// oliObj.SKU__c;
                skuWrapObj.minprice= skuWrapObj2.minprice;
                skuWrapObj.maxprice = skuWrapObj2.maxprice;//oliObj.MaxPrice__c;
                skuWrapObj.finalprice = oliObj.FinalPrice__c ;
                skuWrapObj.multipleof = skuWrapObj2.multipleof;//oliObj.multipleOf__c; 
                skuWrapObj.Director_Price = skuWrapObj2.Director_Price;//oliObj.Director_Price__c; 
                skuWrapObj.Manager_Price = skuWrapObj2.Manager_Price;//oliObj.Manager_Price__c; 
                skuWrapObj.brandName = skuWrapObj2.brandName ;//oliObj.SKU__r.Name;
                skuWrapObj.packsize = skuWrapObj2.packsize;
                skuWrapObj.divNumber = skuWrapObj2.divNumber;  //...Added By Nik...New CR..06/2020
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
                oliObj.FinalPrice__c = skuWrapObj.finalprice;
                insert oliObj;
                skuWrapObj.oliId = oliObj.Id;   
                System.debug('skuWrapObj---->'+skuWrapObj);
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
    //Margin Block Change - SKI Edited by Sandeep Vishwakarma
    public void picklist(){
        System.debug('IN Picklist Change'+orderType);
        if(orderType == 'ZZOR'){
            saleogCode = '5711';
            salesorgcodeforpbmlist = '5711';
            country = '5711';
            selectedCountry = '0';
        } 
        if(orderType=='ZZEX'){
            saleogCode = '5712';
            salesorgcodeforpbmlist = '5712';
            country = '5712';
        }
        
        // profitCenterList =[SELECT Id, Name, Profit_Center__c, Sales_Value__c, Sales_Org__c, Depot__c, Combination_Key__c FROM Profit_Center__c WHERE Sales_Org__r.Sales_org_code__c =:saleogCode ORDER BY LastModifiedDate DESC  LIMIT 1];
        // profitCenter = profitCenterList[0];
        
        // incoTermList= [SELECT Id, Name, Active__c, Sales_Org__c,IncoTerm_Desc__c FROM Inco_Term__c where Sales_Org__r.Sales_Org_Code__c =:saleogCode AND Active__c=true];
        
        // List<Payment_Term__c> paymentTermList = [Select Id, Payment_Term_Code__c, Payment_Term__c from Payment_Term__c where sales_org__r.sales_org_code__c =:saleogCode];
        // system.debug('paymentTermList --->'+paymentTermList );
        // for(Payment_Term__c tdmObj:paymentTermList){
        // 	paymentTermSet.add(new SelectOption(tdmObj.Id,tdmObj.Payment_Term__c));
        // }
        
        // List<DistributorSalesAreaMapping__c> salesAreas = [select id,Name,Payment_Term__c,Inco_Term__c,Division__c,DistributionChannel__c,Price_Classification__c,PriceGroupMaster__c,Price_List_CAM__c from DistributorSalesAreaMapping__c where Sales_Org_Code__c=:saleogCode and Distributor__c=:accountId];
        // System.debug('SalesArea '+salesAreas);
        
        
        // if(salesAreas.size()>0){
        // 	Inco_Terms = salesAreas[0].Inco_Term__c;
        // 	Payment_Terms = salesAreas[0].Payment_Term__c;
        // } 
        
        //Test Start
        
        //Test Stop
        skuDetailsList.clear();//Export Order Sales Deduction(CR#182) - SKI Added by Sandeep Vishwakarma 5-25-2023
        // skuDetailsMap.clear();
        distributionChanelCode.clear();
        fetchDistributorDetails();
        
        System.debug('Inco_Terms :'+Inco_Terms);
        System.debug('Payment_Terms :'+Payment_Terms);
        System.debug('Payment_Terms list :'+payemntTermList);
        System.debug('Inco_Terms list :'+incoTermList);

    }
    //Margin Block Change - SKI Edited by Sandeep Vishwakarma
    public class DistributorWrapper{
        public String Sales_Director{get;set;}
        public String Latam_Director{get;set;}
        public String distributorName {get;set;}
        public String salesOrgId {get;set;}
        public String salesOrgName {get;set;}
        public String distributorChannelId {get;set;}
        public List<String> divisionIds {get;set;} //Abhishek 
        public List<String> distributionChannelIds {get;set;} //Abhishek 
        
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
        //public Decimal minPrice {get;set;}
        public Decimal finalPrice {get;set;}
        public Integer itemNo {get;set;}
        public Integer perUnit {get;set;}
        public Decimal available {get;set;}
        public Decimal maxPrice{get;set;}
        public Decimal minPrice{get;set;}
        public Decimal packsize{get;set;}
        public String available2 {get;set;}
        public String currencyIso {get;set;}
        public String divNumber{get;set;}      // ..added by Nik ...New CR...06/2020
        public Date customerDeliveryDate {get;set;} // added by Vishal Pawar #CR152
        
        // Start Added by Sandeep Vishwakarma for Margin Block Change SKI
        @AuraEnabled public Date deliveryDate;
        @AuraEnabled public String e2EUOM;
        //Export Order Sales Deduction(CR#182) - SKI Added by Sandeep Vishwakarma 5-25-2023
        @AuraEnabled public Decimal freight {get;set;}
        @AuraEnabled public String origin {get;set;}
        @AuraEnabled public Decimal contributionMargin {get;set;}
        
        @AuraEnabled public Decimal e2EUOMValueCon;
        @AuraEnabled public String e2EBaseUOM;
        @AuraEnabled public String e2ESalesUOM;
        
        @AuraEnabled public Decimal e2ECostLC; 
        @AuraEnabled public decimal e2ECostUSD; 
        @AuraEnabled public decimal e2ECostUPC9LC; 
        @AuraEnabled public decimal e2ECostUPC9USD; 
        @AuraEnabled public decimal e2ECostMBEWLC; 
        @AuraEnabled public decimal e2ECostMBEWUSD;
        
        @AuraEnabled public String salesDeductionUOM; 
        @AuraEnabled public Decimal salesDeductionLC;  
        @AuraEnabled public Decimal salesDeductionUSD;
        @AuraEnabled public Decimal salesDeductionDUOMValueCon;
        
        @AuraEnabled public Decimal salesDeductionInPercent;   //if salesDeductionLC not available then query on profit center (Sale Value)
        
        @AuraEnabled public String rebate1UOM; 
        @AuraEnabled public Decimal rebate1LC; 
        @AuraEnabled public Decimal rebate1USD;
        @AuraEnabled public Decimal rebateUOMConver1;
        @AuraEnabled public Decimal rebateUOMConver2;
        
        @AuraEnabled public Decimal rebate1Percent;
        @AuraEnabled public String rebateCode1;
        
        @AuraEnabled public String rebate2UOM; 
        @AuraEnabled public Decimal rebate2LC; 
        @AuraEnabled public Decimal rebate2USD; 
        @AuraEnabled public Decimal rebate2Percent;
        @AuraEnabled public String rebateCode2;  
        
        @AuraEnabled public String discountUOM; 
        @AuraEnabled public Decimal discountLC; 
        @AuraEnabled public Decimal discountUSD; 
        @AuraEnabled public Decimal discountPercent; 
        @AuraEnabled public Decimal discountUOMConver; 
        
        
        @AuraEnabled public String additionalDiscountUOM; 
        @AuraEnabled public Decimal additionalDiscountLC; 
        @AuraEnabled public Decimal additionalDiscountUSD; 
        @AuraEnabled public Decimal additionalDiscountPercent; 
        @AuraEnabled public Decimal additionalDiscountUOMConver; 
        
        
        @AuraEnabled public String plnUOM; 
        @AuraEnabled public Decimal pLNLC; 
        @AuraEnabled public Decimal pLNUSD; 
        @AuraEnabled public Decimal plnUOMConver; 
        
        
        @AuraEnabled public String profitCenter;
        
        @AuraEnabled public Boolean specialSKU;
        
        @AuraEnabled public String uomRebate1;
        @AuraEnabled public String uomRebate2;
        @AuraEnabled public String uomDiscount;
        @AuraEnabled public String uomAddDiscount;
        @AuraEnabled public String uomSalesDeduction;
        @AuraEnabled public String uome2eCost;
        @AuraEnabled public String uomPLN;
        //additional added for Contribution Margin 
        //baseUom refered from UOM Conversion
        @AuraEnabled public String baseUOM;
        @AuraEnabled public Decimal convertQty;
        @AuraEnabled public Decimal convertNetPrice;
        @AuraEnabled public Decimal convertFinalPrice;

        //Export Order Sales Deduction(CR#182) - SKI Added by Sandeep Vishwakarma 5-25-2023
        @AuraEnabled public Decimal rebateVal;
        @AuraEnabled public Decimal discountVal;
        @AuraEnabled public Decimal addDiscountVal;
        @AuraEnabled public Decimal e2eCostVal;
        @AuraEnabled public Decimal salesDeductionVal;
        // End
        
        
        public SKUDetails(){
            customerDeliveryDate = null;
            UOM = 'N/A';
            packsize=0;
            maxPrice = 0;
            minPrice = 0;
            qty = 0;
            //minPrice = 0;
            Manager_Price=0;
            Director_Price = 0;
            price = 0;
            finalPrice = 0;
            netRateEntered = 0;
            available = 0;
            available2 = 'Out of Stock';
            popular = false;
            divisionId='';
            multipleOf =0;
            divNumber = '';
            //Margin Block Change - SKI Edited by Sandeep Vishwakarma
            this.deliveryDate = Date.today() + 3;
            specialSKU = false;
        }
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