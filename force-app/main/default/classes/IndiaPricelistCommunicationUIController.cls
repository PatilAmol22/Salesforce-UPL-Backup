/*
* Name: IndiaPricelistCommunicationUIController
* Created On: 9 May 2018
* Author: Azhar Shaikh (azhar.shaikh@skinternational.com)
* Description: Class is used for displaying pribook data of India
*/
global without sharing class IndiaPricelistCommunicationUIController {
   
    public DistributorWrapper distWrapObj {get;set;}
    //public ShippingLocation slwObj {get;set;}
    //public Shipping_Location__c slwObj2 {get;set;}
    
    //public List<SelectOption> shippingList {get;set;}
    public List<SKUDetails> skuDetailsList {get;set;}
   public List<State_Tax_Structure__c> stsList {get;set;}
   
   public List<Distributor_Depot_Mapping__c> depotList {get;set;}
    public List<Depot__c> depotIdList {get;set;}
   
    public Set<string> TotalcreatedSO {get;set;}
   // public Map<String,ShippingLocation> shippingMap {get;set;}    
    public Map<Id,SKUDetails> skuDetailsMap {get;set;}
    public Map<String,String> stateMap {get;set;}
    
    public Set<String> productNamesSet{get;set;}
    public List<SelectOption> depotSet{get;set;}
    
    //public String selectedShipping {get;set;}
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
    
    public Boolean isPortalUser;
    public Boolean showError{get;set;}
    public Boolean enableInput{get;set;}
    
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
    
    public String orderId{get;set;}
    public String PO{get;set;}
    public String accountId{get;set;}
    public String depoId;
    public String regionOfDeliveryId; // add by Ganesh - region of delivery id referred from state tax structure
    public String distributorId;
    public String territoryManagerId;
    public String country;
    public String paymentType{get;set;}
    public Integer sizeSkuDetailsList {get;set;}
    // Migration from 1000 to 1410
    //Added to change the Sales Org Code for IndiaSAS to 1410 from 1000
    //public string salesOrgCodeSAS = UtilityClass.getSalesOrgIndiaSAS();
    Map<String, UPL_SalesOrg_Detail__mdt> salesOrgDetailsMap = UtilityClass.getSalesOrgDetails();
    public string salesOrgCodeSAS = salesOrgDetailsMap.get('India_SalesOrg').value__c;
    public IndiaPricelistCommunicationUIController(ApexPages.StandardController controller) {
       
        try{
            country = 'India';
            skuDetailsList = new List<SKUDetails>();
            skuDetailsMap = new Map<Id,SKUDetails>();
            
            
            paymentType='Credit';  
            sizeSkuDetailsList =0;
            PO = '';
            searchProdValue = '';
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
            
            //accountId = '0010k000002TXLN';
            distributorId = '';
            depoId = '';
            regionOfDeliveryId=''; 
            territoryManagerId = '';
            
            stateMap = new Map<String,String>();
            depotSet = new List<SelectOption>();  
          //  shippingMap = new Map<String, ShippingLocation>();
             User loginUserObj ;
            //String acntId=ApexPages.currentPage().getParameters().get('ID');
            //System.debug('acntId pdf:- '+acntId);
            String accountIdi = ApexPages.currentpage().getparameters().get('acid');
            System.debug('accountIdi:------------ '+accountIdi);
            String profileName = 'System Administrator';
            String usrid = ApexPages.currentpage().getparameters().get('usrid');
            System.debug('UserInfo.getUserId() :--------------- '+UserInfo.getUserId());
            System.debug('usrid :- '+usrid);
            
            if(!Test.isRunningTest()){
                loginUserObj = [SELECT Id, Name, AccountId, isPortalEnabled, IsActive, ContactId,UserRole.name,Profile.Name,
                                 Show_Inventory__c, Show_Credit_Limit__c, EnableDepot__c,
                                 Show_Inventory_Column__c, Show_InTransit__c, Show_InTransit_Values__c
                                 FROM User 
                                 WHERE Id =: UserInfo.getUserId()
                                 AND IsActive = True];
            }else{
                
                loginUserObj = [SELECT Id, Name, AccountId, isPortalEnabled, IsActive, ContactId,UserRole.name,Profile.Name,
                                 Show_Inventory__c, Show_Credit_Limit__c, EnableDepot__c,
                                 Show_Inventory_Column__c, Show_InTransit__c, Show_InTransit_Values__c
                                 FROM User 
                                 WHERE Id =:UserInfo.getUserId()
                                 AND IsActive = True];
            }
            
            
            System.debug('loginUserObj :--------------- '+loginUserObj);
            
           /* Contact cntObj = [SELECT Id, AccountId
                                 FROM Contact 
                                 WHERE Id =: loginUserObj.ContactId];
            
            System.debug('cntObj :--------------- '+cntObj);*/
            //String con_actid= cntObj[0].AccountId;
            //System.debug('con_actid :--------------- '+con_actid);
            //!loginUserObj.IsPortalEnabled
            accountId = loginUserObj.AccountId;
            System.debug('accountId :----- '+accountId);
            
            if(accountIdi!=null){
                depotList = [SELECT id, Depot__c,Depot__r.Region__c
                             FROM Distributor_Depot_Mapping__c 
                             WHERE Depot__r.SalesOrg__r.Sales_Org_Code__c=:salesOrgCodeSAS
                             AND Distributor__c=:accountIdi AND Depot__c!='' LIMIT 1];
                
                System.debug('depotList: '+depotList);
                
                if(!depotList.isEmpty()){
                    depoId = depotList[0].Depot__c;
                    regionOfDeliveryId = depotList[0].Depot__r.Region__c;
                }
                fetchDistributorDetails(accountIdi);
            }
            
            if(String.isEmpty(accountId)){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Authorised person can view the Pricing Details.'));
            }else{
                
                accountId = loginUserObj.AccountId;
                System.debug('accountId :------------'+accountId);
                depotList = [SELECT id, Depot__c,Depot__r.Region__c
                             FROM Distributor_Depot_Mapping__c 
                             WHERE Depot__r.SalesOrg__r.Sales_Org_Code__c=:salesOrgCodeSAS 
                             AND Distributor__c=:accountId AND Depot__c!='' LIMIT 1];
                
                System.debug('depotList: '+depotList);
                
                if(!depotList.isEmpty()){
                    depoId = depotList[0].Depot__c;
                    regionOfDeliveryId = depotList[0].Depot__r.Region__c;
                }
                
                
                
            }
        }catch(Exception ex){
            System.debug('Error--->'+ex);
            System.debug('ErrorLine--->'+ex.getLineNumber());
            
        }
        
    }
    public IndiaPricelistCommunicationUIController(String acnt,String isbatch) {
       
        try{
            country = 'India';
            skuDetailsList = new List<SKUDetails>();
            skuDetailsMap = new Map<Id,SKUDetails>();
            paymentType='Credit';  
            PO = '';
            searchProdValue = '';
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
            
            //accountId = '0010k000002TXLN';
            distributorId = '';
            depoId = '';
            regionOfDeliveryId=''; 
            territoryManagerId = '';
            
            stateMap = new Map<String,String>();
            depotSet = new List<SelectOption>();  
         //   shippingMap = new Map<String, ShippingLocation>();
            
            
            
            String profileName = 'System Administrator';
            
            if(isbatch !='batch'){
                
            	
                User loginUserObj = [SELECT Id, Name, AccountId, isPortalEnabled, IsActive, ContactId,UserRole.name,Profile.Name,
                                 Show_Inventory__c, Show_Credit_Limit__c, EnableDepot__c,
                                 Show_Inventory_Column__c, Show_InTransit__c, Show_InTransit_Values__c
                                 FROM User 
                                 WHERE Id =: UserInfo.getUserId()
                                 AND IsActive = True];
            
                System.debug('loginUserObj :--------------- '+loginUserObj);
            
                
            }else{
                
                //accountId = loginUserObj.AccountId;
                accountId = acnt;
                System.debug('accountId batch :------------'+accountId);
                //System.debug('Depot__c :------------'+Distributor_Depot_Mapping__c.Depot__c);
                depotList = [SELECT id, Depot__c,Depot__r.Region__c
                             FROM Distributor_Depot_Mapping__c 
                             WHERE Depot__r.SalesOrg__r.Sales_Org_Code__c=:salesOrgCodeSAS 
                             AND Distributor__c=:accountId AND Depot__c!='' LIMIT 1];
                
                System.debug('depotList:---------- '+depotList);
                
                if(!depotList.isEmpty()){
                    depoId = depotList[0].Depot__c;
                    regionOfDeliveryId = depotList[0].Depot__r.Region__c;
                } 
                fetchDistributorDetails();
            }
            
            
           /* 
            //!loginUserObj.IsPortalEnabled
            //accountId = loginUserObj.AccountId;
            if(String.isEmpty(accountId)){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Authorised person can view the Pricing Details.'));
            }else{
                
                            
                
               
            } */
            
        }catch(Exception ex){
            System.debug('Error--->'+ex);
            System.debug('ErrorLine--->'+ex.getLineNumber());
            
        }
        
    }
    
    
    //Method to fetch Distributor Details, Depot, Credit Information and Shipping Details
    public void fetchDistributorDetails(){
        try{
            //accountId = '0010k000002TXLN';
            ApexLog.exceptionCoverage(throwEx);
            
            List<Account> accList = [SELECT Id, Name, BillingCity, BillingCountry, RegionalManager__c,
                                     BillingStreet, BillingState, BillingPostalCode , CurrencyIsoCode, Sales_Org__r.Name, 
                                     OwnerId, SAP_Code__c, Sales_Org__c, Distribution_Channel__c, Division__c,
                                     Order_Type__c, Order_Block__c,Sales_Org_Code__c, Status__c, Payment_Terms__c, PriceGroupCode__c, Price_List_Type__c, 
                                     State_Tax_Structure__c
                                     FROM Account 
                                     WHERE Id=:accountId LIMIT 1];
            
            System.debug('accList: '+accList);
            
            if(accList.isEmpty()){
                
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Distributor ID not found'));
                //CalloutException e = new CalloutException();
                //e.setMessage('?Distributor ID not found');
                //throw e;
            }
            
            if(String.isBlank(territoryManagerId)){
                territoryManagerId = UserInfo.getUserId(); //accList[0].OwnerId;
            }
            System.debug('territoryManagerId:'+territoryManagerId);
            
            List<Credit_Info__c> ciList = [SELECT id, name,Distributor__c,distributor__r.name,
                                           Credit_Limit__c,Balance_Limit__c,Used_Limit__c, 
                                           Sum_Open_Item__c, DAYS_ARREARS__c 
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
            //distWrapObj.salesOrgId = accList[0].Sales_Org__c;
            //distWrapObj.salesOrgName = accList[0].Sales_Org__r.Name;
            //distWrapObj.distributorChannelId = accList[0].Distribution_Channel__c;            
            //distWrapObj.divisionId = accList[0].Division__c;   
            distWrapObj.ordertype = accList[0].Order_Type__c; 
            distWrapObj.paymentTerms = accList[0].Payment_Terms__c;
            distWrapObj.priceGroupId = accList[0].PriceGroupCode__c;
            //distWrapObj.priceListType  = accList[0].Price_List_Type__c;
            distWrapObj.region = accList[0].State_Tax_Structure__c;

            
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
                distributorId = territoryManagerId; //UserInfo.getUserId(); //accList[0].OwnerId;
                System.debug('distributorId'+distributorId);
                orderRaisedBy = 'Territory Manager';
            }
            
            //Populate StateMap Code to State Name
            for(State_Tax_Structure__c stateObj:[Select Id, State_Name__c, State_Code__c From State_Tax_Structure__c Where SalesOrg__r.Sales_org_code__c =:salesOrgCodeSAS]){
                stateMap.put(stateObj.State_Code__c, stateObj.State_Name__c);
            }
            System.debug('stateMap: '+stateMap);
            //End of Logic
            
            List<Shipping_Location__c> slList = [SELECT Id, Name, Distributor__c, City__c, 
                                                 Region__c, Pincode__c, State__c, Country__c,
                                                 Sold_To_Party_SAP_Code__c, SAP_Code__c
                                                 FROM Shipping_Location__c
                                                 WHERE Distributor__c =:accountId];
            
            if(slList.isEmpty()){
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Shipping Details not found'));
                //CalloutException e = new CalloutException();
                //e.setMessage('?Shipping Details not found');
                //throw e;
            }
            List<DistributorSalesAreaMapping__c> dsmList = [SELECT Id, DistributionChannel__c, SalesOrg__r.Name,
                                                            Distribution_Channel_Code__c, Division_Code__c,
                                                            SalesOrg__c, SalesOrg__r.Sales_Org_Code__c,
                                                            Division__c, Division__r.Name, AccountOwner__c, PrIceListTypeMaster__r.Price_List_Type__c 
                                                            FROM DistributorSalesAreaMapping__c
                                                            WHERE Distributor__c=:accountId
                                                            AND SalesOrg__r.Sales_Org_Code__c=:salesOrgCodeSAS];
            if(!dsmList.isEmpty()){
                territoryManagerId = dsmList[0].AccountOwner__c;
                distWrapObj.salesOrgId = dsmList[0].SalesOrg__c;
                distWrapObj.salesOrgName = dsmList[0].SalesOrg__r.Name;
                distWrapObj.distributorChannelId = dsmList[0].DistributionChannel__c;            
                distWrapObj.divisionId = dsmList[0].Division__c;  
                distWrapObj.priceListType  = dsmList[0].PrIceListTypeMaster__c;
            }
            else{
                territoryManagerId = UserInfo.getUserId(); //conList[0].Account.OwnerId;      
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Sales Area not found'));
                //CalloutException e = new CalloutException();
                //e.setMessage('?Sales Area not found');
                //throw e;
            }
            
            List<User> userList = [Select u.Id, u.IsActive, u.IsPortalEnabled from User u where id=:UserInfo.getUserId()];
            Boolean isPortalEnabled = false;
            if(!userList.isEmpty()){
                isPortalEnabled = userList[0].IsPortalEnabled;
            }
            
            System.debug('territoryManagerId: '+territoryManagerId);
            if(!isPortalEnabled){
                List<TM_Depot_Mapping__c> tdmList = [SELECT Id, Depot__c, Depot__r.Location__c, Territory_Manager__c 
                                                     FROM TM_Depot_Mapping__c
                                                     WHERE Territory_Manager__c =:territoryManagerId];
                System.debug('tdmList: '+tdmList);
                for(TM_Depot_Mapping__c tdmObj:tdmList){
                    depotSet.add(new SelectOption(tdmObj.Depot__r.Location__c,tdmObj.Depot__r.Location__c));
                }
                System.debug('tdmList: '+tdmList);
            }
            List<Distributor_Depot_Mapping__c> dmList = [SELECT id, Distributor__c ,Depot__c, Depot__r.Location__c 
                                                         FROM Distributor_Depot_Mapping__c 
                                                         WHERE Distributor__c=:accountId 
                                                         AND Depot__r.SalesOrg__r.Sales_Org_Code__c=:salesOrgCodeSAS LIMIT 1];
            
            System.debug('dmList: '+dmList);
            
            if(!dmList.isEmpty()){
                distWrapObj.depot = dmList[0].Depot__r.Location__c;
                depoId = dmList[0].Depot__c;
                if(depotSet.isEmpty()){
                    depotSet.add(new SelectOption(dmList[0].Depot__r.Location__c,dmList[0].Depot__r.Location__c));
                }
                selectedDepot = depoId;
                //changeDepot();
            }
            else{
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Distributor Depot not found'));
                //CalloutException e = new CalloutException();
                //e.setMessage('?Distributor Depot not found');
                //throw e;
            }
            System.debug('depotSet: '+depotSet);
            System.debug('distWrapObj.depot: '+distWrapObj.depot);
            if(String.isNotBlank(distWrapObj.depot)){
                fetchSKUData();
            }
            
            if(!ciList.isEmpty()){
                distWrapObj.creditLimit = ciList[0].Credit_Limit__c;
                distWrapObj.creditUsed = ciList[0].Used_Limit__c;
                distWrapObj.creditBalance = ciList[0].Balance_Limit__c;
                //distWrapObj.paymentOutstanding = ciList[0].Sum_Open_Item__c;
                distWrapObj.daysArrears = ciList[0].DAYS_ARREARS__c;
            }
            else{
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Credit Information for Distributor not found'));
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
            /*shippingList = new List<SelectOption>();
            
            for(Shipping_Location__c slObj:slList){
                ShippingLocation slw2Obj = new ShippingLocation();
                
                //Logic to Map Same Billing Addres based on Sold to Party SAP Code
                if(String.isNotBlank(slObj.SAP_Code__c) && distWrapObj.sapCode == slObj.SAP_Code__c){
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
                    
                    System.debug('slObj.City__c :-----------------'+slObj.City__c);
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
                    shippingMap.put(slw2Obj.City, slw2Obj);
                }
                //End of Logic
            }*/
            //End of Logic
            
            
            //shippingJSON = JSON.serialize(shippingMap.values());
           
        }
        catch(Exception ex){
            System.debug('ErrorLine-->'+ex.getLineNumber());
            //ApexLog.exceptionHandler(ex, orderId, accountId);
        }
    }
    
    
    public void fetchSKUData(){
        try{
            ApexLog.exceptionCoverage(throwEx);
            
            //Logic to populate existing wrapper with Pricebook Details
            // Newly adde code by Azhar & Sandip
                
            List<PriceBookMaster__c> pbmList = [SELECT Id, SKUCode__c ,SKUCode__r.Name, 
                                                    SKUCode__r.Pack_Size__c, SKUCode__r.SKU_Code__c,
                                                    DepotCode__c, DepotCode__r.Location__c, 
                                                    Price__c, PG_CODE__c, PG_CODE__r.Name, 
                                                    UOM__c, SKUCode__r.Product_Name__r.Name, SKUCode__r.SKU_Description__c,
                                                    SKUCode__r.Product_Name__c, SKUCode__r.Product_Name__r.Popular__c,
                                                    DistributorCustomerCode__r.Name, CurrencyIsoCode,
                                                    SKUCode__r.Product_Name__r.VF_Image__c,SKUCode__r.GST__c, LastModifiedDate
                                                FROM PriceBookMaster__c
                                                WHERE PG_CODE__c=:distWrapObj.priceGroupId      
                                                	AND PrIce_List_Type__c=: distWrapObj.priceListType 
                                                	AND Price_Book_Change__c = True    
                                                    AND SKUCode__r.Sales_Org__c =: distWrapObj.salesOrgId
                                                    AND StartDate__c <= TODAY AND EndDate__c >= TODAY 
                                                    AND SKUCode__r.Active__c = True
                                                    AND (SKUCode__r.GST__c!=Null AND SKUCode__r.GST__c!=0)
                                                	ORDER BY SKUCode__r.Product_Name__r.Name ASC, SKUCode__r.SKU_Code__c DESC, LastModifiedDate ASC];
                                                
            
            String orderType = 'ZORD';
            String query  = 'SELECT Id, SKUCode__c ,SKUCode__r.Name, ';
            query += 'SKUCode__r.Pack_Size__c, SKUCode__r.SKU_Code__c, ';
            query += 'DepotCode__c, DepotCode__r.Location__c, ';
            query += 'Price__c, PG_CODE__c, PG_CODE__r.Name, ';
            query += 'UOM__c, SKUCode__r.Product_Name__r.Name, ';
            query += 'SKUCode__r.Product_Name__c, SKUCode__r.Product_Name__r.Popular__c, ';
            query += 'DistributorCustomerCode__r.Name, CurrencyIsoCode, ';
            query += 'SKUCode__r.Product_Name__r.VF_Image__c ,SKUCode__r.GST__c ';
            query += 'FROM PriceBookMaster__c  ';
            query += 'WHERE PG_CODE__c=\''+distWrapObj.priceGroupId+'\')) ';
            query += 'AND PrIce_List_Type__c= \''+distWrapObj.priceListType+'\' ';
            query += 'AND Price_Book_Change__c = True';
            query += 'AND SKUCode__r.Sales_Org__c =\''+distWrapObj.salesOrgId+'\' ';
            query += 'AND StartDate__c <= TODAY AND EndDate__c >= TODAY AND SKUCode__r.Active__c = True ';
            query += 'AND (SKUCode__r.GST__c!=Null AND SKUCode__r.GST__c!=0)';
            query += 'ORDER BY SKUCode__r.Product_Name__r.Name ASC, SKUCode__r.SKU_Code__c DESC, LastModifiedDate ASC';                                    
            
            System.debug('query: '+query);
            System.debug('pbmList: '+pbmList);
            System.debug('size: '+pbmList.size());
            
            SKUDetails skuWrapObj;
            if(pbmList.isEmpty()){
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Pricebook for Depot/Distributor not found'));
                //CalloutException e = new CalloutException();
                //e.setMessage(query);
                //throw e;
            }
            
            for(PriceBookMaster__c pbObj : pbmList){
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
                skuWrapObj.priceBookMasterId = pbObj.Id;
                skuWrapObj.price = pbObj.Price__c;
                skuWrapObj.priceGroupCode = pbObj.PG_CODE__r.Name; 
                skuWrapObj.priceGroupId = pbObj.PG_CODE__c;
                skuWrapObj.currencyIso = pbObj.currencyIsoCode;
                skuWrapObj.popular = pbObj.SKUCode__r.Product_Name__r.Popular__c;
                
                if(pbObj.SKUCode__r.GST__c!=0){
                     
                    Decimal suggestedRetailerPrice = ((Math.abs(pbObj.SKUCode__r.GST__c)/100)*skuWrapObj.price);
                    skuWrapObj.suggestedretailerprice = suggestedRetailerPrice;
                    skuWrapObj.creditgst = pbObj.SKUCode__r.GST__c;
                }
                
                            
                if(String.isNotBlank(pbObj.SKUCode__r.Product_Name__r.VF_Image__c)){
                    skuWrapObj.image = pbObj.SKUCode__r.Product_Name__r.VF_Image__c;
                }
                if(String.isNotBlank(pbObj.SKUCode__c) && String.isNotBlank(skuWrapObj.UOM) ){
                    skuDetailsMap.put(pbObj.SKUCode__c, skuWrapObj);
                }
                 
                
                
            }
            //End of Logic
            // New code for channel margin discount 
            // last condition type 4
            
            System.debug('priceListType :- '+distWrapObj.priceListType);
            System.debug('depoId :- '+depoId);
            System.debug('salesOrgId :- '+distWrapObj.salesOrgId);
            System.debug('distWrapObj.priceGroupId :- '+distWrapObj.priceGroupId);
            
            List<Distributor_Margin__c> dmList5 = [SELECT Id, SKU_Code__c, 
                                                       Discount__c, CurrencyIsoCode, LastModifiedDate
                                                       FROM Distributor_Margin__c
                                                       WHERE (PrIce_List_Type__c=: distWrapObj.priceListType AND Depot_Code__c =: depoId AND SKU_Code__r.Sales_Org__c =: distWrapObj.salesOrgId ) 
                                                  	   AND PG_CODE__c=:distWrapObj.priceGroupId
                                                       AND StartDate__c <= TODAY AND EndDate__c >= TODAY 
                                                       AND SKU_Code__r.Active__c = True
                                                  	   ORDER BY SKU_Code__r.Product_Name__r.Name ASC, SKU_Code__r.SKU_Code__c DESC, LastModifiedDate ASC];
           
           
            System.debug('dmList4 size :- '+dmList5.size());
            for(Distributor_Margin__c dmObj : dmList5){
                if(skuDetailsMap.containsKey(dmObj.SKU_Code__c)){
                    skuWrapObj = skuDetailsMap.get(dmObj.SKU_Code__c);
                    //change added by ganesh
                    //desc: to change special invoice discount percent to Price
                    skuWrapObj.invoiceDiscountPercent = Math.abs(dmObj.Discount__c);
                    System.debug('skuWrapObj.invoiceDiscountPercent :- '+skuWrapObj.invoiceDiscountPercent);
                    
                    Decimal sidPrice = ((Math.abs(dmObj.Discount__c)/100)*skuWrapObj.price);
                    skuWrapObj.invoiceDiscount = sidPrice.setScale(0);
                    skuWrapObj.invoiceDiscountId = dmObj.Id;
                    skuWrapObj.currencyIso = dmObj.currencyIsoCode;
                    skuDetailsMap.put(dmObj.SKU_Code__c, skuWrapObj);
                   
                }
            }
            
            // last condition type 3 pending ==========
            
            System.debug('distWrapObj.priceListType :- '+distWrapObj.priceListType);
            System.debug('depoId :- '+depoId);
            System.debug('distWrapObj.salesOrgId :- '+distWrapObj.salesOrgId);
            List<SKU__c> skuListdm4 = [SELECT  Id, (select Id, SKU_Code__c, Discount__c, CurrencyIsoCode, LastModifiedDate from Distributor_Margins__r 
                                                        Where PrIce_List_Type__c=: distWrapObj.priceListType AND Depot_Code__c =: depoId AND Material_Group__r.Sales_Org__c =: distWrapObj.salesOrgId
                                                    AND StartDate__c <= TODAY AND EndDate__c >= TODAY ORDER BY LastModifiedDate ASC)
                                                    FROM     SKU__c
                                                    WHERE    Active__c= true
                                                    AND      Sales_Org_Code__C = :salesOrgCodeSAS 
                                                    ORDER BY Product_Name__r.Name ASC, SKU_Code__c DESC];
            
            System.debug('skuListdm3 size :- '+skuListdm4.size());
            List<Distributor_Margin__c> dmList4 = new List<Distributor_Margin__c>();
            if(skuListdm4.size() > 0){
                
                for(Sku__c skuObj : skuListdm4){
                    System.debug('skuObj :----'+skuObj.Distributor_Margins__r);
                   for(Distributor_Margin__c dmObj : skuObj.Distributor_Margins__r){
                       System.debug('Print value of distributer channel');
                        System.debug('dmObj :- '+dmObj.SKU_Code__c);
                        dmList4.add(dmObj);
                    }
                }
            }
            
            
            for(Distributor_Margin__c dmObj : dmList4){
                if(skuDetailsMap.containsKey(dmObj.SKU_Code__c)){
                    skuWrapObj = skuDetailsMap.get(dmObj.SKU_Code__c);
                    //change added by ganesh
                    //desc: to change special invoice discount percent to Price
                    skuWrapObj.invoiceDiscountPercent = Math.abs(dmObj.Discount__c);
                    Decimal sidPrice = ((Math.abs(dmObj.Discount__c)/100)*skuWrapObj.price);
                    skuWrapObj.invoiceDiscount = sidPrice.setScale(0);
                    skuWrapObj.invoiceDiscountId = dmObj.Id;
                    skuWrapObj.currencyIso = dmObj.currencyIsoCode;
                    skuDetailsMap.put(dmObj.SKU_Code__c, skuWrapObj);
                   
                }
            }
            
            
            // last condition type 2 
           List<Distributor_Margin__c> dmList3 = [SELECT Id, SKU_Code__c, 
                                                       Discount__c, CurrencyIsoCode, LastModifiedDate
                                                       FROM Distributor_Margin__c
                                                       WHERE (PrIce_List_Type__c=: distWrapObj.priceListType  AND Region__c =: distWrapObj.region  AND SKU_Code__r.Sales_Org__c =: distWrapObj.salesOrgId ) 
                                                       AND PG_CODE__c=:distWrapObj.priceGroupId
                                                       AND StartDate__c <= TODAY AND EndDate__c >= TODAY 
                                                       AND SKU_Code__r.Active__c = True
                                                       ORDER BY SKU_Code__r.Product_Name__r.Name ASC, SKU_Code__r.SKU_Code__c DESC, LastModifiedDate ASC];
            
            System.debug('dmList2 size :- '+dmList3.size());
            for(Distributor_Margin__c dmObj : dmList3){
                if(skuDetailsMap.containsKey(dmObj.SKU_Code__c)){
                    skuWrapObj = skuDetailsMap.get(dmObj.SKU_Code__c);
                    //change added by ganesh
                    //desc: to change special invoice discount percent to Price
                    skuWrapObj.invoiceDiscountPercent = Math.abs(dmObj.Discount__c);
                    Decimal sidPrice = ((Math.abs(dmObj.Discount__c)/100)*skuWrapObj.price);
                     skuWrapObj.invoiceDiscount = sidPrice.setScale(0);
                    skuWrapObj.invoiceDiscountId = dmObj.Id;
                    skuWrapObj.currencyIso = dmObj.currencyIsoCode;
                    skuDetailsMap.put(dmObj.SKU_Code__c, skuWrapObj);
                   
                }
            }
            
            // last condition type 1 pending ==========
            
            
            List<SKU__c> skuListdm2 = [SELECT  Id, (select Id, SKU_Code__c, Discount__c, CurrencyIsoCode, LastModifiedDate from Distributor_Margins__r Where 
                                                 PrIce_List_Type__c=: distWrapObj.priceListType AND Region_of_Delivery_Depot__c =: regionOfDeliveryId 
                                                  AND Region__c =: distWrapObj.region AND Material_Group__r.Sales_Org__c =: distWrapObj.salesOrgId)
                                                    FROM     SKU__c
                                                    WHERE    Active__c= true
                                                    AND      Sales_Org_Code__C = :salesOrgCodeSAS
                                                    ORDER BY Product_Name__r.Name ASC, SKU_Code__c DESC];
            
            System.debug('skuListdm1 size :- '+skuListdm2.size());
            List<Distributor_Margin__c> dmList2 = new List<Distributor_Margin__c>();
            if(skuListdm2.size() > 0){
                for(Sku__c skuObj : skuListdm2){
                   for(Distributor_Margin__c dmObj : skuObj.Distributor_Margins__r){
                       System.debug('Print value of placement');
                        System.debug('dmObj :- '+dmObj.SKU_Code__c);
                        dmList2.add(dmObj);
                    }
                }
            }
        
            
            for(Distributor_Margin__c dmObj : dmList2){
                if(skuDetailsMap.containsKey(dmObj.SKU_Code__c)){
                    skuWrapObj = skuDetailsMap.get(dmObj.SKU_Code__c);
                    //change added by ganesh
                    //desc: to change special invoice discount percent to Price
                    skuWrapObj.invoiceDiscountPercent = Math.abs(dmObj.Discount__c);
                    Decimal sidPrice = ((Math.abs(dmObj.Discount__c)/100)*skuWrapObj.price);
                     skuWrapObj.invoiceDiscount = sidPrice.setScale(0);
                    skuWrapObj.invoiceDiscountId = dmObj.Id;
                    skuWrapObj.currencyIso = dmObj.currencyIsoCode;
                    skuDetailsMap.put(dmObj.SKU_Code__c, skuWrapObj);
                   
                }
            }
            
            // condition type 1 (Patch) // 30th Aug 2018
            
            List<Distributor_Margin__c> dmList1 = [SELECT Id, SKU_Code__c, PG_CODE__c, 
                                                     Discount__c, CurrencyIsoCode, LastModifiedDate
                                                     FROM Distributor_Margin__c
                                                     WHERE (PrIce_List_Type__c=: distWrapObj.priceListType AND SKU_Code__r.Sales_Org__c =: distWrapObj.salesOrgId ) 
                                                     AND PG_CODE__c=:distWrapObj.priceGroupId
                                                     AND Depot_Code__c =Null
                                                     AND Region__c = Null
                                                     AND StartDate__c <= TODAY AND EndDate__c >= TODAY 
                                                     AND SKU_Code__r.Active__c = True
                                                     ORDER BY SKU_Code__r.Product_Name__r.Name ASC, SKU_Code__r.SKU_Code__c DESC, LastModifiedDate ASC];
            
            System.debug('dmListNew size :- '+dmList1.size());
            for(Distributor_Margin__c dmObj : dmList1){
                if(skuDetailsMap.containsKey(dmObj.SKU_Code__c)){
                    System.debug(' Distributor Margin 2 :- ');
                    if(dmObj.PG_CODE__c==distWrapObj.priceGroupId){
                        System.debug('dmObj.PG_CODE__c 2:- '+dmObj.PG_CODE__c);
                        System.debug('distWrapObj.priceGroupId 2:- '+distWrapObj.priceGroupId);
                        skuWrapObj = skuDetailsMap.get(dmObj.SKU_Code__c);
                        skuWrapObj.invoiceDiscountPercent = Math.abs(dmObj.Discount__c);
                        Decimal sidPrice = ((Math.abs(dmObj.Discount__c)/100)*skuWrapObj.price);
                        skuWrapObj.invoiceDiscount = sidPrice.setScale(0);
                        skuWrapObj.invoiceDiscountId = dmObj.Id;
                        skuWrapObj.currencyIso = dmObj.currencyIsoCode;
                        skuDetailsMap.put(dmObj.SKU_Code__c, skuWrapObj);
                        
                    }
                }
            }
            
            
            
            
            // New code for placement discount 
            // last condition type 4
            List<Placement__c> plList5 = [SELECT Id, SKU_Code__c, 
                                                       Discount__c, CurrencyIsoCode, LastModifiedDate
                                                       FROM Placement__c
                                                       WHERE (PrIce_List_Type__c=: distWrapObj.priceListType AND Depot_Code__c =: depoId AND SKU_Code__r.Sales_Org__c =: distWrapObj.salesOrgId ) 
                                                       AND PG_CODE__c=:distWrapObj.priceGroupId
                                                       AND StartDate__c <= TODAY AND EndDate__c >= TODAY 
                                                       AND SKU_Code__r.Active__c = True
                                                       ORDER BY SKU_Code__r.Product_Name__r.Name ASC, SKU_Code__r.SKU_Code__c DESC, LastModifiedDate ASC];
            
           
            
            for(Placement__c pbObj : plList5){
                if(skuDetailsMap.containsKey(pbObj.SKU_Code__c)){
                    skuWrapObj = skuDetailsMap.get(pbObj.SKU_Code__c);
                    //change added by ganesh
                    //desc: to change special invoice discount percent to Price
                    skuWrapObj.specialDiscoutPercent = Math.abs(pbObj.Discount__c);
                    Decimal sidPrice = ((Math.abs(pbObj.Discount__c)/100)*skuWrapObj.price);
                    skuWrapObj.specialDiscount = sidPrice.setScale(0);
                    skuWrapObj.specialDiscountId = pbObj.Id;
                    skuWrapObj.currencyIso = pbObj.currencyIsoCode;
                    skuDetailsMap.put(pbObj.SKU_Code__c, skuWrapObj);
                   
                }
            }
            
            // last condition type 3 pending ==========
            
          
            List<SKU__c> skuListpl4 = [SELECT  Id, (select Id, SKU_Code__c, Discount__c, CurrencyIsoCode, LastModifiedDate from Placements__r 
                                                    Where PrIce_List_Type__c=: distWrapObj.priceListType AND Depot_Code__c =: depoId AND Material_Group__r.Sales_Org__c =: distWrapObj.salesOrgId
                                                    AND StartDate__c <= TODAY AND EndDate__c >= TODAY ORDER BY LastModifiedDate ASC)
                                                    FROM     SKU__c
                                                    WHERE    Active__c= true
                                                    AND      Sales_Org_Code__C = :salesOrgCodeSAS
                                                    ORDER BY Product_Name__r.Name ASC, SKU_Code__c DESC];
            
            
          
            List<Placement__c> plcList4 = new List<Placement__c>();
            if(skuListpl4.size() > 0){
                for(Sku__c skuObj : skuListpl4){
                   for(Placement__c plcObj : skuObj.Placements__r){
                       System.debug('Print value of placement');
                        System.debug('plcObj :- '+plcObj.SKU_Code__c);
                        plcList4.add(plcObj);
                    }
                }
            }
            
            
            for(Placement__c pbObj : plcList4){
                if(skuDetailsMap.containsKey(pbObj.SKU_Code__c)){
                    skuWrapObj = skuDetailsMap.get(pbObj.SKU_Code__c);
                    //change added by ganesh
                    //desc: to change special invoice discount percent to Price
                    skuWrapObj.specialDiscoutPercent = Math.abs(pbObj.Discount__c);
                    Decimal sidPrice = ((Math.abs(pbObj.Discount__c)/100)*skuWrapObj.price);
                    skuWrapObj.specialDiscount = sidPrice.setScale(0);
                    skuWrapObj.specialDiscountId = pbObj.Id;
                    skuWrapObj.currencyIso = pbObj.currencyIsoCode;
                    skuDetailsMap.put(pbObj.SKU_Code__c, skuWrapObj);
                   
                }
            }
            
            
            // last condition type 2 
           List<Placement__c> plList3 = [SELECT Id, SKU_Code__c, 
                                                       Discount__c, CurrencyIsoCode, LastModifiedDate
                                                       FROM Placement__c
                                                       WHERE (PrIce_List_Type__c=: distWrapObj.priceListType  AND Region__c =: distWrapObj.region  AND SKU_Code__r.Sales_Org__c =: distWrapObj.salesOrgId ) 
                                                       AND PG_CODE__c=:distWrapObj.priceGroupId
                                                       AND StartDate__c <= TODAY AND EndDate__c >= TODAY 
                                                       AND SKU_Code__r.Active__c = True
                                                       ORDER BY SKU_Code__r.Product_Name__r.Name ASC, SKU_Code__r.SKU_Code__c DESC, LastModifiedDate ASC];
            
           for(Placement__c pbObj : plList3){
                if(skuDetailsMap.containsKey(pbObj.SKU_Code__c)){
                    skuWrapObj = skuDetailsMap.get(pbObj.SKU_Code__c);
                    //desc: to change special invoice discount percent to Price
                    skuWrapObj.specialDiscoutPercent = Math.abs(pbObj.Discount__c);
                    Decimal sidPrice = ((Math.abs(pbObj.Discount__c)/100)*skuWrapObj.price);
                    skuWrapObj.specialDiscount = sidPrice.setScale(0);
                    skuWrapObj.specialDiscountId = pbObj.Id;
                    skuWrapObj.currencyIso = pbObj.currencyIsoCode;
                    skuDetailsMap.put(pbObj.SKU_Code__c, skuWrapObj);
                   
                }
            }
            
            // last condition type 1 pending ==========
            
          
            List<SKU__c> skuListpl2 = [SELECT  Id, (select Id, SKU_Code__c, Discount__c, CurrencyIsoCode, LastModifiedDate from Placements__r Where 
                                                 PrIce_List_Type__c=: distWrapObj.priceListType AND Region_of_Delivery_Depot__c =: regionOfDeliveryId 
                                                  AND Region__c =: distWrapObj.region AND Material_Group__r.Sales_Org__c =: distWrapObj.salesOrgId)
                                                    FROM     SKU__c
                                                    WHERE    Active__c= true
                                                    AND      Sales_Org_Code__C = :salesOrgCodeSAS 
                                                    ORDER BY Product_Name__r.Name ASC, SKU_Code__c DESC];
            
            
            System.debug('skuListpl1 :- '+skuListpl2);
            System.debug('skuListpl1 size :- '+skuListpl2.size());
            List<Placement__c> plcList2 = new List<Placement__c>();
            if(skuListpl2.size() > 0){
                for(Sku__c skuObj : skuListpl2){
                   for(Placement__c plcObj : skuObj.Placements__r){
                       System.debug('Print value of placement');
                        System.debug('plcObj :- '+plcObj.SKU_Code__c);
                        plcList2.add(plcObj);
                    }
                }
            }
        
            
            for(Placement__c pbObj : plcList2){
                if(skuDetailsMap.containsKey(pbObj.SKU_Code__c)){
                    skuWrapObj = skuDetailsMap.get(pbObj.SKU_Code__c);
                    //change added by ganesh
                    //desc: to change special invoice discount percent to Price
                    skuWrapObj.specialDiscoutPercent = Math.abs(pbObj.Discount__c);
                    Decimal sidPrice = ((Math.abs(pbObj.Discount__c)/100)*skuWrapObj.price);
                    skuWrapObj.specialDiscount = sidPrice.setScale(0);
                    skuWrapObj.specialDiscountId = pbObj.Id;
                    skuWrapObj.currencyIso = pbObj.currencyIsoCode;
                    skuDetailsMap.put(pbObj.SKU_Code__c, skuWrapObj);
                   
                }
            }
            
            // condition type 1 (Patch) // 30th Aug 2018
            
            List<Placement__c> plList1 = [SELECT Id, SKU_Code__c, PG_CODE__c, 
                                                     Discount__c, CurrencyIsoCode, LastModifiedDate
                                                     FROM Placement__c
                                                     WHERE (PrIce_List_Type__c=: distWrapObj.priceListType AND SKU_Code__r.Sales_Org__c =: distWrapObj.salesOrgId ) 
                                                     AND PG_CODE__c=:distWrapObj.priceGroupId
                                                     AND Depot_Code__c =Null
                                                     AND Region__c = Null
                                                     AND StartDate__c <= TODAY AND EndDate__c >= TODAY 
                                                     AND SKU_Code__r.Active__c = True
                                                     ORDER BY SKU_Code__r.Product_Name__r.Name ASC, SKU_Code__r.SKU_Code__c DESC, LastModifiedDate ASC];
            
           
            
            for(Placement__c pbObj : plList1){
                if(skuDetailsMap.containsKey(pbObj.SKU_Code__c)){
                    skuWrapObj = skuDetailsMap.get(pbObj.SKU_Code__c);
                    //change added by ganesh
                    //desc: to change special invoice discount percent to Price
                    skuWrapObj.specialDiscoutPercent = Math.abs(pbObj.Discount__c);
                    Decimal sidPrice = ((Math.abs(pbObj.Discount__c)/100)*skuWrapObj.price);
                    skuWrapObj.specialDiscount = sidPrice.setScale(0);
                    skuWrapObj.specialDiscountId = pbObj.Id;
                    skuWrapObj.currencyIso = pbObj.currencyIsoCode;
                    skuDetailsMap.put(pbObj.SKU_Code__c, skuWrapObj);
                   
                }
            }
            
            
            
 //----------------------------------------------------------------------------------------------------------------------------------    
            
            
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
                    /*else if(pbObj.In_transit_stock_quantity__c != null){
                        if(pbObj.In_transit_stock_quantity__c > 0 && showInTransit==true && showInTransitValues==false){
                            skuWrapObj.available2 = 'In Transit';
                        }
                        else if(pbObj.In_transit_stock_quantity__c > 0 && showInTransit==false && showInTransitValues==true){
                            skuWrapObj.available2 = '('+pbObj.In_transit_stock_quantity__c+')';
                        }                    
                        else if(pbObj.In_transit_stock_quantity__c > 0 && showInTransit==true && showInTransitValues==true){
                            skuWrapObj.available2 = 'In Transit ('+pbObj.In_transit_stock_quantity__c+')';
                        } 
                    }*/
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
        
        System.debug('skuDetailsList:----------------------------------- ');
        try{
            ApexLog.exceptionCoverage(throwEx);
            
            for(SKUDetails skuWrapObj:skuDetailsMap.values()){
                
                
                skuWrapObj.totalDiscount= Math.abs(skuWrapObj.invoiceDiscountPercent) + Math.abs(skuWrapObj.specialDiscoutPercent);
                
                if(skuWrapObj.totalDiscount>=100){
                    System.debug('Total discount is more than 100% ');
                }else {
                    System.debug('Total discount'+skuWrapObj.totalDiscount);
                }
                skuWrapObj.netRateEntered = skuWrapObj.Price - Math.abs(skuWrapObj.invoiceDiscount) - Math.abs(skuWrapObj.specialDiscount);
                
                Decimal gstincludingCredit = ((Math.abs(skuWrapObj.creditgst)/100)*skuWrapObj.netRateEntered);
                skuWrapObj.netpriceinvoicediscountgst = skuWrapObj.netRateEntered + gstincludingCredit;
                
                skuWrapObj.suggestedretailerprice = skuWrapObj.Price + skuWrapObj.suggestedretailerprice ;
                
                String sk_code = skuWrapObj.skuCode.replaceFirst('^0+','');
                skuWrapObj.skuCode = sk_code;
                //productNamesSet.add(skuWrapObj.productName);
                //if(skuWrapObj.Popular){
                skuDetailsList.add(skuWrapObj);
                sizeSkuDetailsList = skuDetailsList.size();
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
    
    
    //Method to fetch Distributor Details, Depot, Credit Information and Shipping Details
    public void fetchDistributorDetails(String accountId){
        try{
            System.debug('accountId 2: '+accountId);
            //accountId = '0010k000002TXLN';
            ApexLog.exceptionCoverage(throwEx);
            
            List<Account> accList = [SELECT Id, Name, BillingCity, BillingCountry, RegionalManager__c,
                                     BillingStreet, BillingState, BillingPostalCode , CurrencyIsoCode, Sales_Org__r.Name, 
                                     OwnerId, SAP_Code__c, Sales_Org__c, Distribution_Channel__c, Division__c,
                                     Order_Type__c, Order_Block__c,Sales_Org_Code__c, Status__c, Payment_Terms__c, PriceGroupCode__c, Price_List_Type__c, 
                                     State_Tax_Structure__c
                                     FROM Account 
                                     WHERE Id=:accountId LIMIT 1];
            
            System.debug('accList 2: '+accList);
            
            if(accList.isEmpty()){
                
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Distributor ID not found'));
                //CalloutException e = new CalloutException();
                //e.setMessage('?Distributor ID not found');
                //throw e;
            }
            
            if(String.isBlank(territoryManagerId)){
                territoryManagerId = UserInfo.getUserId(); //accList[0].OwnerId;
            }
            System.debug('territoryManagerId:'+territoryManagerId);
            
            List<Credit_Info__c> ciList = [SELECT id, name,Distributor__c,distributor__r.name,
                                           Credit_Limit__c,Balance_Limit__c,Used_Limit__c, 
                                           Sum_Open_Item__c, DAYS_ARREARS__c 
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
            //distWrapObj.salesOrgId = accList[0].Sales_Org__c;
            //distWrapObj.salesOrgName = accList[0].Sales_Org__r.Name;
            //distWrapObj.distributorChannelId = accList[0].Distribution_Channel__c;            
            //distWrapObj.divisionId = accList[0].Division__c;   
            distWrapObj.ordertype = accList[0].Order_Type__c; 
            distWrapObj.paymentTerms = accList[0].Payment_Terms__c;
            distWrapObj.priceGroupId = accList[0].PriceGroupCode__c;
            //distWrapObj.priceListType  = accList[0].Price_List_Type__c;
            distWrapObj.region = accList[0].State_Tax_Structure__c;

            
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
                distributorId = territoryManagerId; //UserInfo.getUserId(); //accList[0].OwnerId;
                System.debug('distributorId'+distributorId);
                orderRaisedBy = 'Territory Manager';
            }
            
            //Populate StateMap Code to State Name
            for(State_Tax_Structure__c stateObj:[Select Id, State_Name__c, State_Code__c From State_Tax_Structure__c Where SalesOrg__r.Sales_org_code__c =: salesOrgCodeSAS]){
                stateMap.put(stateObj.State_Code__c, stateObj.State_Name__c);
            }
            System.debug('stateMap: '+stateMap);
            //End of Logic
            
            List<Shipping_Location__c> slList = [SELECT Id, Name, Distributor__c, City__c, 
                                                 Region__c, Pincode__c, State__c, Country__c,
                                                 Sold_To_Party_SAP_Code__c, SAP_Code__c
                                                 FROM Shipping_Location__c
                                                 WHERE Distributor__c =:accountId];
            
            if(slList.isEmpty()){
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Shipping Details not found'));
                //CalloutException e = new CalloutException();
                //e.setMessage('?Shipping Details not found');
                //throw e;
            }
            List<DistributorSalesAreaMapping__c> dsmList = [SELECT Id, DistributionChannel__c, SalesOrg__r.Name,
                                                            Distribution_Channel_Code__c, Division_Code__c,
                                                            SalesOrg__c, SalesOrg__r.Sales_Org_Code__c,
                                                            Division__c, Division__r.Name, AccountOwner__c, PrIceListTypeMaster__r.Price_List_Type__c 
                                                            FROM DistributorSalesAreaMapping__c
                                                            WHERE Distributor__c=:accountId
                                                            AND SalesOrg__r.Sales_Org_Code__c=:salesOrgCodeSAS];
            if(!dsmList.isEmpty()){
                territoryManagerId = dsmList[0].AccountOwner__c;
                distWrapObj.salesOrgId = dsmList[0].SalesOrg__c;
                distWrapObj.salesOrgName = dsmList[0].SalesOrg__r.Name;
                distWrapObj.distributorChannelId = dsmList[0].DistributionChannel__c;            
                distWrapObj.divisionId = dsmList[0].Division__c;
                distWrapObj.priceListType  = dsmList[0].PrIceListTypeMaster__c;
            }
            else{
                territoryManagerId = UserInfo.getUserId(); //conList[0].Account.OwnerId;      
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Sales Area not found'));
                //CalloutException e = new CalloutException();
                //e.setMessage('?Sales Area not found');
                //throw e;
            }
            
            System.debug('UserInfo.getUserId() 2: '+UserInfo.getUserId());
            List<User> userList = [Select u.Id, u.IsActive, u.IsPortalEnabled from User u where id=:UserInfo.getUserId()];
            Boolean isPortalEnabled = false;
            if(!userList.isEmpty()){
                isPortalEnabled = userList[0].IsPortalEnabled;
            }
            
            System.debug('territoryManagerId 2: '+territoryManagerId);
            if(!isPortalEnabled){
                List<TM_Depot_Mapping__c> tdmList = [SELECT Id, Depot__c, Depot__r.Location__c, Territory_Manager__c 
                                                     FROM TM_Depot_Mapping__c
                                                     WHERE Territory_Manager__c =:territoryManagerId];
                System.debug('tdmList: '+tdmList);
                for(TM_Depot_Mapping__c tdmObj:tdmList){
                    depotSet.add(new SelectOption(tdmObj.Depot__r.Location__c,tdmObj.Depot__r.Location__c));
                }
                System.debug('tdmList: '+tdmList);
            }
            List<Distributor_Depot_Mapping__c> dmList = [SELECT id, Distributor__c ,Depot__c, Depot__r.Location__c 
                                                         FROM Distributor_Depot_Mapping__c 
                                                         WHERE Distributor__c=:accountId 
                                                         AND Depot__r.SalesOrg__r.Sales_Org_Code__c=:salesOrgCodeSAS LIMIT 1];
            
            System.debug('dmList: '+dmList);
            
            if(!dmList.isEmpty()){
                distWrapObj.depot = dmList[0].Depot__r.Location__c;
                depoId = dmList[0].Depot__c;
                if(depotSet.isEmpty()){
                    depotSet.add(new SelectOption(dmList[0].Depot__r.Location__c,dmList[0].Depot__r.Location__c));
                }
                selectedDepot = depoId;
                //changeDepot();
            }
            else{
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Distributor Depot not found'));
                //CalloutException e = new CalloutException();
                //e.setMessage('?Distributor Depot not found');
                //throw e;
            }
            System.debug('depotSet 2: '+depotSet);
            System.debug('distWrapObj.depot 2: '+distWrapObj.depot);
            
            if(String.isNotBlank(distWrapObj.depot)){
                fetchSKUData(accountId);
            }
            
            if(!ciList.isEmpty()){
                distWrapObj.creditLimit = ciList[0].Credit_Limit__c;
                distWrapObj.creditUsed = ciList[0].Used_Limit__c;
                distWrapObj.creditBalance = ciList[0].Balance_Limit__c;
                //distWrapObj.paymentOutstanding = ciList[0].Sum_Open_Item__c;
                distWrapObj.daysArrears = ciList[0].DAYS_ARREARS__c;
            }
            else{
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Credit Information for Distributor not found'));
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
            
            
           
        }
        catch(Exception ex){
            System.debug('ErrorLine-->'+ex.getLineNumber());
            //ApexLog.exceptionHandler(ex, orderId, accountId);
        }
    }
    
    
    public void fetchSKUData(String accountId){
        try{
            ApexLog.exceptionCoverage(throwEx);
            
            //Logic to populate existing wrapper with Pricebook Details
            // Newly adde code by Azhar & Sandip
                
            List<PriceBookMaster__c> pbmList = [SELECT Id, SKUCode__c ,SKUCode__r.Name, 
                                                    SKUCode__r.Pack_Size__c, SKUCode__r.SKU_Code__c,
                                                    DepotCode__c, DepotCode__r.Location__c, 
                                                    Price__c, PG_CODE__c, PG_CODE__r.Name, 
                                                    UOM__c, SKUCode__r.Product_Name__r.Name, SKUCode__r.SKU_Description__c,
                                                    SKUCode__r.Product_Name__c, SKUCode__r.Product_Name__r.Popular__c,
                                                    DistributorCustomerCode__r.Name, CurrencyIsoCode,
                                                    SKUCode__r.Product_Name__r.VF_Image__c,SKUCode__r.GST__c, LastModifiedDate
                                                FROM PriceBookMaster__c
                                                WHERE PG_CODE__c=:distWrapObj.priceGroupId      
                                                	AND PrIce_List_Type__c=: distWrapObj.priceListType 
                                                	AND Price_Book_Change__c = True    
                                                    AND SKUCode__r.Sales_Org__c =: distWrapObj.salesOrgId
                                                    AND StartDate__c <= TODAY AND EndDate__c >= TODAY 
                                                    AND SKUCode__r.Active__c = True
                                                    AND (SKUCode__r.GST__c!=Null AND SKUCode__r.GST__c!=0)
                                                	ORDER BY SKUCode__r.Product_Name__r.Name ASC, SKUCode__r.SKU_Code__c DESC, LastModifiedDate ASC];
                                                
            
            String orderType = 'ZORD';
            String query  = 'SELECT Id, SKUCode__c ,SKUCode__r.Name, ';
            query += 'SKUCode__r.Pack_Size__c, SKUCode__r.SKU_Code__c, ';
            query += 'DepotCode__c, DepotCode__r.Location__c, ';
            query += 'Price__c, PG_CODE__c, PG_CODE__r.Name, ';
            query += 'UOM__c, SKUCode__r.Product_Name__r.Name, ';
            query += 'SKUCode__r.Product_Name__c, SKUCode__r.Product_Name__r.Popular__c, ';
            query += 'DistributorCustomerCode__r.Name, CurrencyIsoCode, ';
            query += 'SKUCode__r.Product_Name__r.VF_Image__c ,SKUCode__r.GST__c ';
            query += 'FROM PriceBookMaster__c  ';
            query += 'WHERE PG_CODE__c=\''+distWrapObj.priceGroupId+'\')) ';
            query += 'AND PrIce_List_Type__c= \''+distWrapObj.priceListType+'\' ';
            query += 'AND Price_Book_Change__c = True';
            query += 'AND SKUCode__r.Sales_Org__c =\''+distWrapObj.salesOrgId+'\' ';
            query += 'AND StartDate__c <= TODAY AND EndDate__c >= TODAY AND SKUCode__r.Active__c = True ';
            query += 'AND (SKUCode__r.GST__c!=Null AND SKUCode__r.GST__c!=0)';
            query += 'ORDER BY SKUCode__r.Product_Name__r.Name ASC, SKUCode__r.SKU_Code__c DESC, LastModifiedDate ASC';                                    
            
            System.debug('query: '+query);
            System.debug('pbmList: '+pbmList);
            System.debug('size: '+pbmList.size());
            
            SKUDetails skuWrapObj;
            if(pbmList.isEmpty()){
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Pricebook for Depot/Distributor not found'));
                //CalloutException e = new CalloutException();
                //e.setMessage(query);
                //throw e;
            }
            
            for(PriceBookMaster__c pbObj : pbmList){
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
                skuWrapObj.priceBookMasterId = pbObj.Id;
                skuWrapObj.price = pbObj.Price__c;
                skuWrapObj.priceGroupCode = pbObj.PG_CODE__r.Name; 
                skuWrapObj.priceGroupId = pbObj.PG_CODE__c;
                skuWrapObj.currencyIso = pbObj.currencyIsoCode;
                skuWrapObj.popular = pbObj.SKUCode__r.Product_Name__r.Popular__c;
                
                if(pbObj.SKUCode__r.GST__c!=0){
                     
                    Decimal suggestedRetailerPrice = ((Math.abs(pbObj.SKUCode__r.GST__c)/100)*skuWrapObj.price);
                    skuWrapObj.suggestedretailerprice = suggestedRetailerPrice;
                    skuWrapObj.creditgst = pbObj.SKUCode__r.GST__c;
                }
                
                            
                if(String.isNotBlank(pbObj.SKUCode__r.Product_Name__r.VF_Image__c)){
                    skuWrapObj.image = pbObj.SKUCode__r.Product_Name__r.VF_Image__c;
                }
                if(String.isNotBlank(pbObj.SKUCode__c) && String.isNotBlank(skuWrapObj.UOM) ){
                    skuDetailsMap.put(pbObj.SKUCode__c, skuWrapObj);
                }
                 
                
                
            }
            //End of Logic
            // New code for channel margin discount 
            // last condition type 4
            
            System.debug('priceListType :- '+distWrapObj.priceListType);
            System.debug('depoId :- '+depoId);
            System.debug('salesOrgId :- '+distWrapObj.salesOrgId);
            System.debug('distWrapObj.priceGroupId :- '+distWrapObj.priceGroupId);
            
            List<Distributor_Margin__c> dmList5 = [SELECT Id, SKU_Code__c, 
                                                       Discount__c, CurrencyIsoCode, LastModifiedDate
                                                       FROM Distributor_Margin__c
                                                       WHERE (PrIce_List_Type__c=: distWrapObj.priceListType AND Depot_Code__c =: depoId AND SKU_Code__r.Sales_Org__c =: distWrapObj.salesOrgId ) 
                                                  	   AND PG_CODE__c=:distWrapObj.priceGroupId
                                                       AND StartDate__c <= TODAY AND EndDate__c >= TODAY 
                                                       AND SKU_Code__r.Active__c = True
                                                  	   ORDER BY SKU_Code__r.Product_Name__r.Name ASC, SKU_Code__r.SKU_Code__c DESC, LastModifiedDate ASC];
           
           
            System.debug('dmList4 size :- '+dmList5.size());
            for(Distributor_Margin__c dmObj : dmList5){
                if(skuDetailsMap.containsKey(dmObj.SKU_Code__c)){
                    skuWrapObj = skuDetailsMap.get(dmObj.SKU_Code__c);
                    //change added by ganesh
                    //desc: to change special invoice discount percent to Price
                    skuWrapObj.invoiceDiscountPercent = Math.abs(dmObj.Discount__c);
                    System.debug('skuWrapObj.invoiceDiscountPercent :- '+skuWrapObj.invoiceDiscountPercent);
                    
                    Decimal sidPrice = ((Math.abs(dmObj.Discount__c)/100)*skuWrapObj.price);
                    skuWrapObj.invoiceDiscount = sidPrice.setScale(0);
                    skuWrapObj.invoiceDiscountId = dmObj.Id;
                    skuWrapObj.currencyIso = dmObj.currencyIsoCode;
                    skuDetailsMap.put(dmObj.SKU_Code__c, skuWrapObj);
                   
                }
            }
            
            // last condition type 3 pending ==========
            
            System.debug('distWrapObj.priceListType :- '+distWrapObj.priceListType);
            System.debug('depoId :- '+depoId);
            System.debug('distWrapObj.salesOrgId :- '+distWrapObj.salesOrgId);
            List<SKU__c> skuListdm4 = [SELECT  Id, (select Id, SKU_Code__c, Discount__c, CurrencyIsoCode, LastModifiedDate from Distributor_Margins__r 
                                                        Where PrIce_List_Type__c=: distWrapObj.priceListType AND Depot_Code__c =: depoId AND Material_Group__r.Sales_Org__c =: distWrapObj.salesOrgId
                                                    AND StartDate__c <= TODAY AND EndDate__c >= TODAY ORDER BY LastModifiedDate ASC)
                                                    FROM     SKU__c
                                                    WHERE    Active__c= true
                                                    AND      Sales_Org_Code__C = :salesOrgCodeSAS 
                                                    ORDER BY Product_Name__r.Name ASC, SKU_Code__c DESC];
            
            System.debug('skuListdm3 size :- '+skuListdm4.size());
            List<Distributor_Margin__c> dmList4 = new List<Distributor_Margin__c>();
            if(skuListdm4.size() > 0){
                
                for(Sku__c skuObj : skuListdm4){
                    System.debug('skuObj :----'+skuObj.Distributor_Margins__r);
                   for(Distributor_Margin__c dmObj : skuObj.Distributor_Margins__r){
                       System.debug('Print value of distributer channel');
                        System.debug('dmObj :- '+dmObj.SKU_Code__c);
                        dmList4.add(dmObj);
                    }
                }
            }
            
            
            for(Distributor_Margin__c dmObj : dmList4){
                if(skuDetailsMap.containsKey(dmObj.SKU_Code__c)){
                    skuWrapObj = skuDetailsMap.get(dmObj.SKU_Code__c);
                    //change added by ganesh
                    //desc: to change special invoice discount percent to Price
                    skuWrapObj.invoiceDiscountPercent = Math.abs(dmObj.Discount__c);
                    Decimal sidPrice = ((Math.abs(dmObj.Discount__c)/100)*skuWrapObj.price);
                    skuWrapObj.invoiceDiscount = sidPrice.setScale(0);
                    skuWrapObj.invoiceDiscountId = dmObj.Id;
                    skuWrapObj.currencyIso = dmObj.currencyIsoCode;
                    skuDetailsMap.put(dmObj.SKU_Code__c, skuWrapObj);
                   
                }
            }
            
            
            // last condition type 2 
           List<Distributor_Margin__c> dmList3 = [SELECT Id, SKU_Code__c, 
                                                       Discount__c, CurrencyIsoCode, LastModifiedDate
                                                       FROM Distributor_Margin__c
                                                       WHERE (PrIce_List_Type__c=: distWrapObj.priceListType  AND Region__c =: distWrapObj.region  AND SKU_Code__r.Sales_Org__c =: distWrapObj.salesOrgId ) 
                                                       AND PG_CODE__c=:distWrapObj.priceGroupId
                                                       AND StartDate__c <= TODAY AND EndDate__c >= TODAY 
                                                       AND SKU_Code__r.Active__c = True
                                                       ORDER BY SKU_Code__r.Product_Name__r.Name ASC, SKU_Code__r.SKU_Code__c DESC, LastModifiedDate ASC];
            
            System.debug('dmList2 size :- '+dmList3.size());
            for(Distributor_Margin__c dmObj : dmList3){
                if(skuDetailsMap.containsKey(dmObj.SKU_Code__c)){
                    skuWrapObj = skuDetailsMap.get(dmObj.SKU_Code__c);
                    //change added by ganesh
                    //desc: to change special invoice discount percent to Price
                    skuWrapObj.invoiceDiscountPercent = Math.abs(dmObj.Discount__c);
                    Decimal sidPrice = ((Math.abs(dmObj.Discount__c)/100)*skuWrapObj.price);
                     skuWrapObj.invoiceDiscount = sidPrice.setScale(0);
                    skuWrapObj.invoiceDiscountId = dmObj.Id;
                    skuWrapObj.currencyIso = dmObj.currencyIsoCode;
                    skuDetailsMap.put(dmObj.SKU_Code__c, skuWrapObj);
                   
                }
            }
            
            // last condition type 1 pending ==========
            
            
            List<SKU__c> skuListdm2 = [SELECT  Id, (select Id, SKU_Code__c, Discount__c, CurrencyIsoCode, LastModifiedDate from Distributor_Margins__r Where 
                                                 PrIce_List_Type__c=: distWrapObj.priceListType AND Region_of_Delivery_Depot__c =: regionOfDeliveryId 
                                                  AND Region__c =: distWrapObj.region AND Material_Group__r.Sales_Org__c =: distWrapObj.salesOrgId)
                                                    FROM     SKU__c
                                                    WHERE    Active__c= true
                                                    AND      Sales_Org_Code__C = :salesOrgCodeSAS 
                                                    ORDER BY Product_Name__r.Name ASC, SKU_Code__c DESC];
            
            System.debug('skuListdm1 size :- '+skuListdm2.size());
            List<Distributor_Margin__c> dmList2 = new List<Distributor_Margin__c>();
            if(skuListdm2.size() > 0){
                for(Sku__c skuObj : skuListdm2){
                   for(Distributor_Margin__c dmObj : skuObj.Distributor_Margins__r){
                       System.debug('Print value of placement');
                        System.debug('dmObj :- '+dmObj.SKU_Code__c);
                        dmList2.add(dmObj);
                    }
                }
            }
        
            
            for(Distributor_Margin__c dmObj : dmList2){
                if(skuDetailsMap.containsKey(dmObj.SKU_Code__c)){
                    skuWrapObj = skuDetailsMap.get(dmObj.SKU_Code__c);
                    //change added by ganesh
                    //desc: to change special invoice discount percent to Price
                    skuWrapObj.invoiceDiscountPercent = Math.abs(dmObj.Discount__c);
                    Decimal sidPrice = ((Math.abs(dmObj.Discount__c)/100)*skuWrapObj.price);
                     skuWrapObj.invoiceDiscount = sidPrice.setScale(0);
                    skuWrapObj.invoiceDiscountId = dmObj.Id;
                    skuWrapObj.currencyIso = dmObj.currencyIsoCode;
                    skuDetailsMap.put(dmObj.SKU_Code__c, skuWrapObj);
                   
                }
            }
            
            // condition type 1 (Patch) // 30th Aug 2018
            
            List<Distributor_Margin__c> dmList1 = [SELECT Id, SKU_Code__c, PG_CODE__c, 
                                                     Discount__c, CurrencyIsoCode, LastModifiedDate
                                                     FROM Distributor_Margin__c
                                                     WHERE (PrIce_List_Type__c=: distWrapObj.priceListType AND SKU_Code__r.Sales_Org__c =: distWrapObj.salesOrgId ) 
                                                     AND PG_CODE__c=:distWrapObj.priceGroupId
                                                     AND Depot_Code__c =Null
                                                     AND Region__c = Null
                                                     AND StartDate__c <= TODAY AND EndDate__c >= TODAY 
                                                     AND SKU_Code__r.Active__c = True
                                                     ORDER BY SKU_Code__r.Product_Name__r.Name ASC, SKU_Code__r.SKU_Code__c DESC, LastModifiedDate ASC];
            
            System.debug('dmListNew size :- '+dmList1.size());
            for(Distributor_Margin__c dmObj : dmList1){
                if(skuDetailsMap.containsKey(dmObj.SKU_Code__c)){
                    System.debug(' Distributor Margin 2 :- ');
                    if(dmObj.PG_CODE__c==distWrapObj.priceGroupId){
                        System.debug('dmObj.PG_CODE__c 2:- '+dmObj.PG_CODE__c);
                        System.debug('distWrapObj.priceGroupId 2:- '+distWrapObj.priceGroupId);
                        skuWrapObj = skuDetailsMap.get(dmObj.SKU_Code__c);
                        skuWrapObj.invoiceDiscountPercent = Math.abs(dmObj.Discount__c);
                        Decimal sidPrice = ((Math.abs(dmObj.Discount__c)/100)*skuWrapObj.price);
                        skuWrapObj.invoiceDiscount = sidPrice.setScale(0);
                        skuWrapObj.invoiceDiscountId = dmObj.Id;
                        skuWrapObj.currencyIso = dmObj.currencyIsoCode;
                        skuDetailsMap.put(dmObj.SKU_Code__c, skuWrapObj);
                        
                    }
                }
            }
            
            
            
            
            // New code for placement discount 
            // last condition type 4
            List<Placement__c> plList5 = [SELECT Id, SKU_Code__c, 
                                                       Discount__c, CurrencyIsoCode, LastModifiedDate
                                                       FROM Placement__c
                                                       WHERE (PrIce_List_Type__c=: distWrapObj.priceListType AND Depot_Code__c =: depoId AND SKU_Code__r.Sales_Org__c =: distWrapObj.salesOrgId ) 
                                                       AND PG_CODE__c=:distWrapObj.priceGroupId
                                                       AND StartDate__c <= TODAY AND EndDate__c >= TODAY 
                                                       AND SKU_Code__r.Active__c = True
                                                       ORDER BY SKU_Code__r.Product_Name__r.Name ASC, SKU_Code__r.SKU_Code__c DESC, LastModifiedDate ASC];
            
           
            
            for(Placement__c pbObj : plList5){
                if(skuDetailsMap.containsKey(pbObj.SKU_Code__c)){
                    skuWrapObj = skuDetailsMap.get(pbObj.SKU_Code__c);
                    //change added by ganesh
                    //desc: to change special invoice discount percent to Price
                    skuWrapObj.specialDiscoutPercent = Math.abs(pbObj.Discount__c);
                    Decimal sidPrice = ((Math.abs(pbObj.Discount__c)/100)*skuWrapObj.price);
                    skuWrapObj.specialDiscount = sidPrice.setScale(0);
                    skuWrapObj.specialDiscountId = pbObj.Id;
                    skuWrapObj.currencyIso = pbObj.currencyIsoCode;
                    skuDetailsMap.put(pbObj.SKU_Code__c, skuWrapObj);
                   
                }
            }
            
            // last condition type 3 pending ==========
            
          
            List<SKU__c> skuListpl4 = [SELECT  Id, (select Id, SKU_Code__c, Discount__c, CurrencyIsoCode, LastModifiedDate from Placements__r 
                                                    Where PrIce_List_Type__c=: distWrapObj.priceListType AND Depot_Code__c =: depoId AND Material_Group__r.Sales_Org__c =: distWrapObj.salesOrgId
                                                    AND StartDate__c <= TODAY AND EndDate__c >= TODAY ORDER BY LastModifiedDate ASC)
                                                    FROM     SKU__c
                                                    WHERE    Active__c= true
                                                    AND      Sales_Org_Code__C = :salesOrgCodeSAS
                                                    ORDER BY Product_Name__r.Name ASC, SKU_Code__c DESC];
            
            
          
            List<Placement__c> plcList4 = new List<Placement__c>();
            if(skuListpl4.size() > 0){
                for(Sku__c skuObj : skuListpl4){
                   for(Placement__c plcObj : skuObj.Placements__r){
                       System.debug('Print value of placement');
                        System.debug('plcObj :- '+plcObj.SKU_Code__c);
                        plcList4.add(plcObj);
                    }
                }
            }
            
            
            for(Placement__c pbObj : plcList4){
                if(skuDetailsMap.containsKey(pbObj.SKU_Code__c)){
                    skuWrapObj = skuDetailsMap.get(pbObj.SKU_Code__c);
                    //change added by ganesh
                    //desc: to change special invoice discount percent to Price
                    skuWrapObj.specialDiscoutPercent = Math.abs(pbObj.Discount__c);
                    Decimal sidPrice = ((Math.abs(pbObj.Discount__c)/100)*skuWrapObj.price);
                    skuWrapObj.specialDiscount = sidPrice.setScale(0);
                    skuWrapObj.specialDiscountId = pbObj.Id;
                    skuWrapObj.currencyIso = pbObj.currencyIsoCode;
                    skuDetailsMap.put(pbObj.SKU_Code__c, skuWrapObj);
                   
                }
            }
            
            
            // last condition type 2 
           List<Placement__c> plList3 = [SELECT Id, SKU_Code__c, 
                                                       Discount__c, CurrencyIsoCode, LastModifiedDate
                                                       FROM Placement__c
                                                       WHERE (PrIce_List_Type__c=: distWrapObj.priceListType  AND Region__c =: distWrapObj.region  AND SKU_Code__r.Sales_Org__c =: distWrapObj.salesOrgId ) 
                                                       AND PG_CODE__c=:distWrapObj.priceGroupId
                                                       AND StartDate__c <= TODAY AND EndDate__c >= TODAY 
                                                       AND SKU_Code__r.Active__c = True
                                                       ORDER BY SKU_Code__r.Product_Name__r.Name ASC, SKU_Code__r.SKU_Code__c DESC, LastModifiedDate ASC];
            
           for(Placement__c pbObj : plList3){
                if(skuDetailsMap.containsKey(pbObj.SKU_Code__c)){
                    skuWrapObj = skuDetailsMap.get(pbObj.SKU_Code__c);
                    //desc: to change special invoice discount percent to Price
                    skuWrapObj.specialDiscoutPercent = Math.abs(pbObj.Discount__c);
                    Decimal sidPrice = ((Math.abs(pbObj.Discount__c)/100)*skuWrapObj.price);
                    skuWrapObj.specialDiscount = sidPrice.setScale(0);
                    skuWrapObj.specialDiscountId = pbObj.Id;
                    skuWrapObj.currencyIso = pbObj.currencyIsoCode;
                    skuDetailsMap.put(pbObj.SKU_Code__c, skuWrapObj);
                   
                }
            }
            
            // last condition type 1 pending ==========
            
          
            List<SKU__c> skuListpl2 = [SELECT  Id, (select Id, SKU_Code__c, Discount__c, CurrencyIsoCode, LastModifiedDate from Placements__r Where 
                                                 PrIce_List_Type__c=: distWrapObj.priceListType AND Region_of_Delivery_Depot__c =: regionOfDeliveryId 
                                                  AND Region__c =: distWrapObj.region AND Material_Group__r.Sales_Org__c =: distWrapObj.salesOrgId)
                                                    FROM     SKU__c
                                                    WHERE    Active__c= true
                                                    AND      Sales_Org_Code__C = :salesOrgCodeSAS
                                                    ORDER BY Product_Name__r.Name ASC, SKU_Code__c DESC];
            
            
            System.debug('skuListpl1 :- '+skuListpl2);
            System.debug('skuListpl1 size :- '+skuListpl2.size());
            List<Placement__c> plcList2 = new List<Placement__c>();
            if(skuListpl2.size() > 0){
                for(Sku__c skuObj : skuListpl2){
                   for(Placement__c plcObj : skuObj.Placements__r){
                       System.debug('Print value of placement');
                        System.debug('plcObj :- '+plcObj.SKU_Code__c);
                        plcList2.add(plcObj);
                    }
                }
            }
        
            
            for(Placement__c pbObj : plcList2){
                if(skuDetailsMap.containsKey(pbObj.SKU_Code__c)){
                    skuWrapObj = skuDetailsMap.get(pbObj.SKU_Code__c);
                    //change added by ganesh
                    //desc: to change special invoice discount percent to Price
                    skuWrapObj.specialDiscoutPercent = Math.abs(pbObj.Discount__c);
                    Decimal sidPrice = ((Math.abs(pbObj.Discount__c)/100)*skuWrapObj.price);
                    skuWrapObj.specialDiscount = sidPrice.setScale(0);
                    skuWrapObj.specialDiscountId = pbObj.Id;
                    skuWrapObj.currencyIso = pbObj.currencyIsoCode;
                    skuDetailsMap.put(pbObj.SKU_Code__c, skuWrapObj);
                   
                }
            }
            
            // condition type 1 (Patch) // 30th Aug 2018
            
            List<Placement__c> plList1 = [SELECT Id, SKU_Code__c, PG_CODE__c, 
                                                     Discount__c, CurrencyIsoCode, LastModifiedDate
                                                     FROM Placement__c
                                                     WHERE (PrIce_List_Type__c=: distWrapObj.priceListType AND SKU_Code__r.Sales_Org__c =: distWrapObj.salesOrgId ) 
                                                     AND PG_CODE__c=:distWrapObj.priceGroupId
                                                     AND Depot_Code__c =Null
                                                     AND Region__c = Null
                                                     AND StartDate__c <= TODAY AND EndDate__c >= TODAY 
                                                     AND SKU_Code__r.Active__c = True
                                                     ORDER BY SKU_Code__r.Product_Name__r.Name ASC, SKU_Code__r.SKU_Code__c DESC, LastModifiedDate ASC];
            
           
            
            for(Placement__c pbObj : plList1){
                if(skuDetailsMap.containsKey(pbObj.SKU_Code__c)){
                    skuWrapObj = skuDetailsMap.get(pbObj.SKU_Code__c);
                    //change added by ganesh
                    //desc: to change special invoice discount percent to Price
                    skuWrapObj.specialDiscoutPercent = Math.abs(pbObj.Discount__c);
                    Decimal sidPrice = ((Math.abs(pbObj.Discount__c)/100)*skuWrapObj.price);
                    skuWrapObj.specialDiscount = sidPrice.setScale(0);
                    skuWrapObj.specialDiscountId = pbObj.Id;
                    skuWrapObj.currencyIso = pbObj.currencyIsoCode;
                    skuDetailsMap.put(pbObj.SKU_Code__c, skuWrapObj);
                   
                }
            }
            
            
            
 //----------------------------------------------------------------------------------------------------------------------------------    
            
            
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
                    /*else if(pbObj.In_transit_stock_quantity__c != null){
                        if(pbObj.In_transit_stock_quantity__c > 0 && showInTransit==true && showInTransitValues==false){
                            skuWrapObj.available2 = 'In Transit';
                        }
                        else if(pbObj.In_transit_stock_quantity__c > 0 && showInTransit==false && showInTransitValues==true){
                            skuWrapObj.available2 = '('+pbObj.In_transit_stock_quantity__c+')';
                        }                    
                        else if(pbObj.In_transit_stock_quantity__c > 0 && showInTransit==true && showInTransitValues==true){
                            skuWrapObj.available2 = 'In Transit ('+pbObj.In_transit_stock_quantity__c+')';
                        } 
                    }*/
                    skuDetailsMap.put(pbObj.SKU__c, skuWrapObj);
                }
            }
            
            System.debug('skuDetailsMap: '+skuDetailsMap);
            System.debug('size: '+skuDetailsMap.size());
            
            System.debug('salesOrgName: '+distWrapObj.salesOrgName);
            
            //System.debug('enableIndia: '+enableIndia);
            
            //End of Logic
            skuJSON = JSON.serialize(skuDetailsMap.values());
            fetchPopular(accountId);
        }
        catch(Exception ex){
            ApexLog.exceptionHandler(ex, orderId, accountId);
        }
    }
    
    //Method to fetch Popular Products
    public void fetchPopular(String accountId){
        
        System.debug('skuDetailsList:----------------------------------- ');
        try{
            ApexLog.exceptionCoverage(throwEx);
            
            for(SKUDetails skuWrapObj:skuDetailsMap.values()){
                
                
                skuWrapObj.totalDiscount= Math.abs(skuWrapObj.invoiceDiscountPercent) + Math.abs(skuWrapObj.specialDiscoutPercent);
                
                if(skuWrapObj.totalDiscount>=100){
                    System.debug('Total discount is more than 100% ');
                }else {
                    System.debug('Total discount'+skuWrapObj.totalDiscount);
                }
                skuWrapObj.netRateEntered = skuWrapObj.Price - Math.abs(skuWrapObj.invoiceDiscount) - Math.abs(skuWrapObj.specialDiscount);
                
                Decimal gstincludingCredit = ((Math.abs(skuWrapObj.creditgst)/100)*skuWrapObj.netRateEntered);
                skuWrapObj.netpriceinvoicediscountgst = skuWrapObj.netRateEntered + gstincludingCredit;
                
                skuWrapObj.suggestedretailerprice = skuWrapObj.Price + skuWrapObj.suggestedretailerprice ;
                
                String sk_code = skuWrapObj.skuCode.replaceFirst('^0+','');
                skuWrapObj.skuCode = sk_code;
                //productNamesSet.add(skuWrapObj.productName);
                //if(skuWrapObj.Popular){
                skuDetailsList.add(skuWrapObj);
                sizeSkuDetailsList = skuDetailsList.size();
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
        public Id region {get;set;}
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
        public Decimal specialDiscountEntered {get;set;}
        public Decimal netRateEntered{get;set;}
        public Decimal priceEntered {get;set;}
        public Integer numberOfCases {get;set;}
        public Decimal qty {get;set;}
        public Integer itemNo {get;set;}
        public Decimal available {get;set;}
        public String available2 {get;set;}
        public String currencyIso {get;set;}
        public String image {get;set;}
        
       	//desc: For percent of pricebook and special invoice discount.
        public Decimal invoiceDiscountPercent{get;set;}  // Channel Margin
        public Decimal specialDiscoutPercent{get;set;}    // Placement scheme
        
        //Add to Sales Order Line Item
        public Decimal price {get;set;}
        public Decimal invoiceDiscount {get;set;}
        public Decimal specialDiscount {get;set;}
        public Decimal totalDiscount{get;set;}
        
        //Lookup Id's of Price/Discount Masters
        public String priceBookMasterId {get;set;}
        public String invoiceDiscountId {get;set;}
        public String specialDiscountId {get;set;}
        
        
        public Decimal netpriceinvoicediscountgst {get;set;}
        public Decimal creditgst {get;set;}
        public Decimal suggestedretailerprice {get;set;}
        
        public SKUDetails(){
            priceBookMasterId = '';
            invoiceDiscountId = '';
            specialDiscountId = '';
            
            packSize = 0;
            UOM = 'N/A';
            qty = 0;
            numberOfCases = 0;
            invoiceDiscountEntered = 0;
            specialDiscountEntered = 0;
            GST=0;
            priceEntered = 0;
            invoiceDiscount = 0;
            specialDiscount = 0;
            totalDiscount=0;
            invoiceDiscountPercent = 0;
            specialDiscoutPercent = 0;
            netpriceinvoicediscountgst =0;
            creditgst =0;
            suggestedretailerprice =0;
            price = 0;
            netRateEntered = 0;
            available = 0;
            available2 = 'Out of Stock';
            popular = false;
            image = '/servlet/servlet.FileDownload?file=015N0000000R8hc';
        }
    }
    
   /* public class ShippingLocation{
        public String locationId {get;set;}
        public String address {get;set;}
        public String city {get;set;}
        public String state {get;set;}
        public String country {get;set;}
        public String pincode {get;set;}
    }*/

}