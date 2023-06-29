public without sharing class QuoteProductEntry_CAM_Controller {
    
    //fetchAllQuoteItem
    @AuraEnabled
    public static List<QuoteLineItem> fetchAllQuoteItem(String quoteId){
        List<QuoteLineItem> quoteLineItemList = new List<QuoteLineItem>();
        quoteLineItemList =[SELECT Id, IsDeleted, LineNumber, QuoteId, PricebookEntryId,Product2.Description, 
                            OpportunityLineItemId, Quantity, UnitPrice, Discount, Description, 
                            Product2Id,Product2.Name, SortOrder, ListPrice, Subtotal, TotalPrice, 
                            Sales_Org__c,Sales_Org__r.Name, Description_of_Goods__c, Pack_Size__c,UOM__c,Min_Price__c,Max_Price__c 
                            FROM QuoteLineItem
                            WHERE QuoteId=:quoteId
                            ORDER by CreatedDate DESC];
        
        return quoteLineItemList;
    }
    
    
    
    @AuraEnabled
    public static String checkApprovalProcess(String quoteId){
        Quote QuoteObj = new Quote();
        String result='';
        QuoteObj = [select Id, Name,Status,IsApprovalRequired__c from Quote 
                    WHERE Id=:quoteId];
        System.debug('QuoteObj.IsApprovalRequired__c '+QuoteObj.IsApprovalRequired__c); 
        if(QuoteObj.Status =='Draft' || QuoteObj.Status=='Rejected' ){
            result = 'false';
        }else{
            result = 'true';
        }
        System.debug('Result is '+result);
        return result;
    }
    
    
    @AuraEnabled
    public static List<PricebookEntry> fetchSKUValues(String searchKeyWord, String quoteId ) {
        // for standard price book
        Quote quoteObj = new Quote();
        quoteObj = [Select Id,Name,AccountId FROM Quote 
                    WHERE Id=:quoteId];
        
        Account accObj = new Account();
        accObj = [Select Id, Name,Sales_Org_Code__c, Distribution_Channel__c,Division__c FROM Account WHERE Id=:quoteObj.AccountId];
        
		String salesOrg =   accObj.Sales_Org_Code__c;
        
        Pricebook2 Pricebook2Obj = new Pricebook2();
        Pricebook2Obj= [SELECT Id, Name, isActive FROM Pricebook2 WHERE Name='Standard Price Book' AND isActive=true]; 
        List < PricebookEntry > returnList = new List < PricebookEntry > (); 
        if(Pricebook2Obj!=null){
            // retrive all the product from the standard price book
            
            List<PricebookEntry> pricebookEntryList = new List<PricebookEntry>();
            pricebookEntryList = [SELECT Id, Name, isActive, Pricebook2Id,Product2.Pack_Size_1__c, 
                                  Product2Id,Product2.Name,Product2.Description,Product2.Product_Code__c,
                                  Product2.Sales_Org__c
                                  FROM PricebookEntry 
                                  WHERE isActive=true
                                  AND Pricebook2Id=:Pricebook2Obj.Id 
                                  AND Product2.Active_for_CAM__c = True
                                  AND Product2.Sales_Org_Code__c=:salesOrg
                                  AND Product2.Division__c =:accObj.Division__c
                                  AND Product2.Distribution_Channel__c =:accObj.Distribution_Channel__c
                                  AND CurrencyIsoCode = 'USD' LIMIT 15] ;
            
            System.debug('@@@ pricebookEntryList  '+pricebookEntryList[0].Id);
            for (PricebookEntry obj: pricebookEntryList) {
                returnList.add(obj);
            }
        }
        return returnList;
    }
    
    @AuraEnabled
    public static List<PricebookEntry> searchHelperOnKeyPres(String searchKeyWord ,String quoteId ){
        Pricebook2 Pricebook2Obj = new Pricebook2();
        Pricebook2Obj= [SELECT Id, Name, isActive FROM Pricebook2 WHERE Name='Standard Price Book' AND isActive=true LIMIT 1]; 
        List < PricebookEntry > returnList = new List < PricebookEntry > ();
        
        Quote quoteObj = new Quote();
        quoteObj = [Select Id,Name,AccountId FROM Quote 
                    WHERE Id=:quoteId];
        
        Account accObj = new Account();
        accObj = [Select Id, Name, Sales_Org_Code__c,Distribution_Channel__c,Division__c FROM Account WHERE Id=:quoteObj.AccountId];
        String salesOrg = accObj.Sales_Org_Code__c;
        String curCode ='USD';
        if(Pricebook2Obj!=null){
            String priceBookId = Pricebook2Obj.Id;
            List<PricebookEntry> pricebookEntryList = new List<PricebookEntry>();
            //String sQuery = 'SELECT Id, Name, isActive, Pricebook2Id,Product2.Pack_Size_1__c,Product2.Description, Product2Id,Product2.Name,Product2.Product_Code__c, Product2.Sales_Org__c FROM PricebookEntry WHERE Product2.Description like \'%'+searchKeyWord+'%\'AND CurrencyIsoCode =\''+curCode+'\' AND isActive = true  AND Pricebook2Id =\''+priceBookId+'\'';                   
            String sQuery = 'SELECT Id, Name, isActive, Pricebook2Id,Product2.Pack_Size_1__c,Product2.Description, Product2Id,Product2.Name,Product2.Product_Code__c, Product2.Sales_Org__c FROM PricebookEntry WHERE Product2.Description like \'%'+searchKeyWord+'%\' AND Product2.Division__c =\''+accObj.Division__c+'\' AND Product2.Distribution_Channel__c =\''+accObj.Distribution_Channel__c+'\' AND CurrencyIsoCode =\''+curCode+'\' AND isActive = true AND Product2.Active_for_CAM__c = True  AND Pricebook2Id =\''+priceBookId+'\'';                   
            //String sQuery = 'SELECT Id, Name, isActive, Pricebook2Id,Product2.Pack_Size_1__c,Product2.Description, Product2Id,Product2.Name,Product2.Product_Code__c, Product2.Sales_Org__c FROM PricebookEntry WHERE Product2.Description like \'%'+searchKeyWord+'%\' AND Product2.Sales_Org__c =\''+salesOrg+'\' AND Product2.Distribution_Channel__c =\''+accObj.Distribution_Channel__c+'\' AND CurrencyIsoCode =\''+curCode+'\' AND isActive = true AND Product2.Active_for_CAM__c = True  AND Pricebook2Id =\''+priceBookId+'\'';                   
            System.debug('sQuery '+sQuery);
            pricebookEntryList = Database.query(sQuery);
            if(pricebookEntryList.size()>0){
                for(PricebookEntry PricebookEntryObj :pricebookEntryList){
                    returnList.add(PricebookEntryObj);
                }
            }
        }
        System.debug('returnList  size '+returnList.size());
        return returnList;
    }
    
    @AuraEnabled
    public static List<wrapperClassSKU> fetchPriceBookMasterDetails(String productId ,String quoteId){
        System.debug('productId '+productId);
        String depoId ='';
        
        
        String salesorgcodeforpbm ='' ;
        
        
        List<PriceBookMaster__c> PbmList = new List<PriceBookMaster__c>();
        List<wrapperClassSKU> wrapperClassSKUList = new List<wrapperClassSKU>();
        
        Quote quoteObj = [Select Id,Name,OpportunityId,AccountId 
                          FROM Quote
                          WHERE Id =:quoteId];
        
        List<PriceBookMaster__c> tempPBMList = new List<PriceBookMaster__c>();
        tempPBMList = [Select Id,DistributorCustomerCode__c 
                       FROM PriceBookMaster__c WHERE DistributorCustomerCode__c=:quoteObj.AccountId];
        
        List<DistributorSalesAreaMapping__c> SalesAreaDMList = [SELECT Id, Division_Code__c, Sales_Org_Code__c, Order_Type__c, 
                                                                PriceGroupMaster__c, Distribution_Channel_Code__c, SalesOrg__c, 
                                                                Division__c, Distributor__c 
                                                                FROM DistributorSalesAreaMapping__c 
                                                                where Distributor__c=:quoteObj.AccountId];
        List<String>divisionIds = new List<String>();
        for(DistributorSalesAreaMapping__c DSAMObj : SalesAreaDMList){
            divisionIds.add(DSAMObj.Division__c);
            salesorgcodeforpbm =DSAMObj.Sales_Org_Code__c;
        }
        
        Product2 prodObj = [select Id,Name,Composite_Key__c,Pack_Size_1__c,Pack_Size__c
                            From Product2
                            WHERE id=:productId
                            AND Active_for_CAM__c= true];
        
        
        
        
        System.debug('prodObj '+prodObj);
        String compoKey ='';
        if(prodObj!=null){
            compoKey = prodObj.Composite_Key__c;
            System.debug('compoKey '+compoKey);
            Account accObj = new Account();
            accObj = [Select Id,Name, Sales_Org__c,Price_Classification__c,Price_List_CAM__c,Cust_Group__c,Customer_Grp__c,
                      Customer_Country__c FROM Account WHERE Id=:quoteObj.AccountId];
            
            SKU__c skuObj = new SKU__c();
            skuObj = [SELECT Id,Name,New_Combination_Key_for_SWAL__c  
                      FROM SKU__c 
                      WHERE New_Combination_Key_for_SWAL__c =:compoKey LIMIT 1];
            System.debug('skuObj Id is '+skuObj.Id);
            
            List<Distributor_Depot_Mapping__c> depotList = [SELECT id, Depot__c 
                                                            FROM Distributor_Depot_Mapping__c 
                                                            WHERE Distributor__c=:quoteObj.AccountId 
                                                            AND Depot__c!='' LIMIT 1];
            if(!depotList.isEmpty()){
                depoId = depotList[0].Depot__c;
            }
            
            
            if(tempPBMList.size()>0){
                PbmList = [SELECT Id,DistributorCustomerCode__c,SKUCode__c,Sales_Org__c,
                           StartDate__c,EndDate__c,UOM__c,Division__c,DistributionChannel__c,
                           DepotCode__c,Price__c,MinPrice__c,CompositeKey__c,Sales_Org_Code__c
                           FROM PriceBookMaster__c
                           WHERE SKUCombinationKey__c =:compoKey 
                           AND DistributorCustomerCode__c =:quoteObj.AccountId
                           AND DepotCode__c =: depoId
                           AND Division__c IN :divisionIds
                           AND SKUCode__r.Sales_Org__r.sales_org_code__c =:salesorgcodeforpbm
                           AND Price__c != null AND Price__c != 0 
                           AND SKUCode__r.Active__c = True 
                           AND MinPrice__c != 0 AND MinPrice__c!= null
                           AND StartDate__c <= TODAY AND EndDate__c >= TODAY];
                
            }else{
                PbmList = [SELECT Id,DistributorCustomerCode__c,Sales_Org_Code__c,SKUCode__c,Sales_Org__c,
                           StartDate__c,EndDate__c,UOM__c,Division__c,DistributionChannel__c,
                           DepotCode__c,Price__c,MinPrice__c,CompositeKey__c
                           FROM PriceBookMaster__c
                           WHERE SKUCombinationKey__c =:compoKey 
                           AND SKUCode__r.Sales_Org__r.sales_org_code__c =:salesorgcodeforpbm
                           AND DistributorCustomerCode__c = null
                           AND Price__c != null AND Price__c != 0 
                           AND DepotCode__c =: depoId
                           AND Division__c IN :divisionIds
                           AND SKUCode__r.Active__c = True 
                           AND MinPrice__c != 0 AND MinPrice__c!= null
                           AND Price_Classification__c =:accObj.Price_Classification__c
                           AND Price_List_CAM__c =:accObj.Price_List_CAM__c
                           AND Customer_Group__c =:accObj.Customer_Grp__c
                           AND Country__c  =:accObj.Sales_Org__c
                           AND StartDate__c <= TODAY AND EndDate__c >= TODAY];
            }
            
            
            
            
            String selSku = PbmList[0].SKUCode__c;
            System.debug('selSku @@  '+selSku);
            
            List<Stock_Requirement__c> sRequList = new List<Stock_Requirement__c>();
            
            sRequList =[Select Id,Depot__c,SKU__c,Available_Stock__c,Stock_In_Transit__c
                        FROM Stock_Requirement__c
                        WHERE Depot__c=:depoId 
                        AND SKU__c =:selSku];
            User loginUserObj = new User();
            loginUserObj = [SELECT Id, Name, IsActive, ContactId,UserRole.name,
                            Show_Inventory__c, Show_Credit_Limit__c, EnableDepot__c, Sales_Director__c,
                            Show_Inventory_Column__c, ManagerId,Show_InTransit__c, Show_InTransit_Values__c,
                            HO__c, Country_Head__c, Marketing_Manager__c,ProfileId,Profile.Name
                            FROM User 
                            WHERE Id =: UserInfo.getUserId()
                            AND IsActive = True];
            Boolean showInTransit,showInTransitValues;
            
            showInTransit = loginUserObj.Show_InTransit__c;
            showInTransitValues = loginUserObj.Show_InTransit_Values__c;
            
            
            
          /*  List<Inventory__c> inventoryList = new List<Inventory__c>();
            inventoryList = [SELECT Id,  Name,  Allocated_Quantity__c, Balanced_Quanity__c, Batch_Number__c, 
                             Depot__c, SKU_Depot__c, SKU__c, Stock_Quantity__c, 
                             Storage_Location__c, UOM__c, ProductName__c, 
                             Distribution_Channel__c, Division__c, Sales_Org__c, 
                             In_transit_stock_quantity__c, SKU_Status__c, 
                             Storage_Location_Depot__c, Gross_Inventory__c, 
                             Net_Open_Order_Inventory__c, Net_Open_Delivery_inventory__c, 
                             Net_Inventory__c, Combination_key_Storage_Location__c, Continent__c, 
                             Production_Date__c, Expiry_Date__c, Sales_Org_Code__c 
                             FROM Inventory__c WHERE SKU__c=:PbmList[0].SKUCode__c
                             AND Sales_Org__c=:accObj.Sales_Org__c
                             AND Depot__c =:depoId
                             AND Division__c IN:divisionIds];*/
            
            System.debug('PbmList Size '+PbmList);
            //List<wrapperClassSKU> wrapperClassSKUList = new List<wrapperClassSKU>();
            wrapperClassSKU wrapObj = new wrapperClassSKU();
            
            wrapObj.UOM = PbmList[0].UOM__c;
            wrapObj.PackSize = prodObj.Pack_Size_1__c;
            wrapObj.MinPrice = PbmList[0].MinPrice__c; 
            wrapObj.MaxPrice = PbmList[0].Price__c;
            
            
            if(sRequList.size()>0){                
                wrapObj.available = sRequList[0].Available_Stock__c;
                if(sRequList[0].Available_Stock__c>0){
                    wrapObj.available2 = 'In Stock';
                }else if(sRequList[0].Stock_In_Transit__c!= null){
                    if(sRequList[0].Stock_In_Transit__c > 0 && showInTransit==true && showInTransitValues==false){
                        wrapObj.available2 = 'In Transit';
                    }
                    else if(sRequList[0].Stock_In_Transit__c > 0 && showInTransit==false && showInTransitValues==true){
                        wrapObj.available2 = '('+sRequList[0].Stock_In_Transit__c+')';
                    }                    
                    else if(sRequList[0].Stock_In_Transit__c > 0 && showInTransit==true && showInTransitValues==true){
                        wrapObj.available2 = 'In Transit ('+sRequList[0].Stock_In_Transit__c+')';
                    } 
                    
                }
                
            }else{
                wrapObj.available2 = '0';
            }
            
            
            wrapObj.SKUId = PbmList[0].SKUCode__c;
            //wrapObj.itemNumber = '10';
            wrapObj.depotId = PbmList[0].DepotCode__c;
            wrapObj.storageLocation =  PbmList[0].DepotCode__c;
            wrapObj.distributionChannel = PbmList[0].DistributionChannel__c;
            wrapObj.division = PbmList[0].Division__c;
            wrapObj.SalesOrg = PbmList[0].Sales_Org__c;
            wrapperClassSKUList.add(wrapObj);
            
        }
        
        System.debug('wrapperClassSKUList '+wrapperClassSKUList);
        System.debug('wrapperClassSKUList Size  '+wrapperClassSKUList.size());
        return wrapperClassSKUList;
    }
    
    @AuraEnabled
    public static void saveQuoteLineItem(List<QuoteLineItem> ListQuote){
        try{
            if(ListQuote.size()>0){
                //ListQuote[0].PricebookEntryId
                System.debug('PricebookEntryId  in Insert OPeration '+ListQuote[0].QuoteId); 
                Quote QuoteObj = new Quote();
                QuoteObj = [Select Id,Pricebook2Id from Quote WHERE Id=:ListQuote[0].QuoteId];
                System.debug('QuoteObj.Pricebook2Id '+QuoteObj.Pricebook2Id);
                if(QuoteObj.Pricebook2Id == null){
                    Pricebook2 Pricebook2Obj1 = new Pricebook2();
                    Pricebook2Obj1= [SELECT Id, Name, isActive FROM Pricebook2 WHERE Name='Standard Price Book' AND isActive=true];
                    QuoteObj.Pricebook2Id = Pricebook2Obj1.Id;
                    update QuoteObj;
                }
                Insert ListQuote;  
                System.debug('ListQuote Sucess '+ListQuote[0].Id);
            }
            
        }
        catch(Exception ex){
            System.debug('Error Occured Line Number '+ex.getLineNumber());
            System.debug('Error Occured Message '+ex.getMessage());
        }
    }
    
    
    @AuraEnabled
    public static QuoteLineItem fetchsingleQuoteLineItem(String quoteLitemId){
        QuoteLineItem quoteLineItemObj = new QuoteLineItem();
        quoteLineItemObj = [SELECT Id, IsDeleted, LineNumber, QuoteId, PricebookEntryId,Product2.Description, 
                            OpportunityLineItemId, Quantity, UnitPrice, Discount, Description, 
                            Product2Id,Product2.Name,Product2.Product_Code__c, SortOrder, ListPrice, Subtotal, TotalPrice, 
                            Sales_Org__c,Sales_Org__r.Name, Description_of_Goods__c, Pack_Size__c,UOM__c,Min_Price__c,Max_Price__c
                            FROM QuoteLineItem
                            WHERE Id=:quoteLitemId];
        System.debug('quoteLineItemObj '+quoteLineItemObj);
        
        return quoteLineItemObj;
    }
    
    @AuraEnabled
    public static String deleteQuoteLineItms(String quoteLineId){
        System.debug('In deleteQuoteLineItms '+quoteLineId);
        String returnMsg ='';
        try{
            List<QuoteLineItem> QuotelineItemList = [Select Id  from QuoteLineItem WHERE Id=:quoteLineId];
            if(QuotelineItemList.size()>0){
                delete QuotelineItemList;
                returnMsg = 'Success';
            }
        }
        catch(Exception ex){
            System.debug('Error Occure Line Number '+ex.getLineNumber());
            System.debug('Error Occure Message '+ex.getMessage());
            returnMsg ='This record is locked. If you need to edit it, contact your admin';
        }
        return returnMsg;
        
    }
    
    
    @AuraEnabled
    public static void submitToApproval(String quoteId ){
        // Create an approval request for the Opportunity
        /* Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
req1.setComments('Submitting request for approval ');
req1.setObjectId(quoteId);
Approval.ProcessResult result = Approval.process(req1);*/
        Quote qObj = new Quote();
        qObj = [Select Id,AccountId,Order_Type__c From Quote Where Id=:quoteId];
        String accId = qObj.AccountId;
        List<DistributorSalesAreaMapping__c> SalesAreaDMList = [SELECT Id, Division_Code__c, Sales_Org_Code__c, Order_Type__c,
                                                                PriceGroupMaster__c, Distribution_Channel_Code__c, SalesOrg__c, Division__c, Distributor__c 
                                                                FROM DistributorSalesAreaMapping__c where Distributor__c=:accId];
        
        Account accOnjtemp = new Account();
        accOnjtemp = [Select Id,Inco_Term__c,Payment_Term_Code__c FROM Account WHERE Id=:accId];
        
        
        
        
        
        Set<String> cntSalesOrg = new Set<String>();
        
        for(DistributorSalesAreaMapping__c sdaobj :SalesAreaDMList){
            cntSalesOrg.add(sdaobj.Sales_Org_Code__c);
        }
        String orderType='';
        
        //5711   5712
        //changes due to UPL-CR130 vishal Pawar 24 march 2021
        
        if(cntSalesOrg.size()== 1){
            for(String tmp :cntSalesOrg){
                
                if(tmp == '5711'){
                    orderType ='ZZOR';
                } 
                if(tmp=='5712'){
                    orderType ='ZZEX';
                }
            }
        }
        
        System.debug('orderType is '+orderType);
        Order_Type__c orderTypeObj =   [Select Id,SalesOrg__c,Order_Type_Code__c 
                                        FROM Order_Type__c 
                                        WHERE Order_Type_Code__c =:orderType limit 1];
        Quote temObj = new Quote();
        temObj.Id = quoteId;
        temObj.Order_Type__c = orderTypeObj.Id;
        update temObj;
        
        
        List<QuoteLineItem> qliList = new List<QuoteLineItem>();
        qliList = [SELECT Id, QuoteId, PricebookEntryId, OpportunityLineItemId, Quantity, 
                   Discount, Description, Product2Id, SortOrder, ListPrice, 
                   Subtotal, TotalPrice, Sales_Org__c, Description_of_Goods__c, 
                   opportunity_line_item_id_1__c, Max_Price__c, Pack_Size__c, 
                   opportunity_line_item_id__c,Min_Price__c,UnitPrice, UOM__c 
                   FROM QuoteLineItem
                   WHERE QuoteId=:quoteId];
        //code setting check boxes for Approval
        Decimal twoPercent =0.0;
        Decimal sevenPercent=0.0;
        Decimal tenPercent=0.0;
        Decimal tenPercentMore=0.0;
        
        
        
        Boolean Sent_for_Manager_Approval=false; // {get;set;}
        Boolean Sent_for_Director_Approval=false;
        Boolean Sent_for_Latam_Director_Approval=false;
        
        for(QuoteLineItem QuoteObj :qliList){
            
            if(QuoteObj.Min_Price__c != null){  
                
                // twoPercent = skuWrapObj.minPrice - (skuWrapObj.minPrice * 2) /100 ;
                
                twoPercent = QuoteObj.Min_Price__c - ((QuoteObj.Min_Price__c * 2) /100) ;
                sevenPercent = QuoteObj.Min_Price__c - ((QuoteObj.Min_Price__c * 7) /100) ;
                tenPercent = QuoteObj.Min_Price__c - ((QuoteObj.Min_Price__c * 10) /100) ;
                tenPercentMore =QuoteObj.Min_Price__c - ((QuoteObj.Min_Price__c * 10.01) /100) ;
                
                system.debug('twoPercent '+ twoPercent);
                system.debug('sevenPercent '+sevenPercent);
                system.debug('tenPercent '+tenPercent);
                system.debug('tenPercentMore '+tenPercentMore);
                
                if(QuoteObj.UnitPrice < tenPercentMore){    
                    Sent_for_Manager_Approval = true;
                    Sent_for_Director_Approval= true;
                    Sent_for_Latam_Director_Approval= true;
                } else if(QuoteObj.UnitPrice <= tenPercent){ 
                    Sent_for_Manager_Approval = true;
                    Sent_for_Director_Approval= true;
                    Sent_for_Latam_Director_Approval= false;
                }else if(QuoteObj.UnitPrice <= sevenPercent){  
                    Sent_for_Manager_Approval = true;
                    Sent_for_Director_Approval= false;
                    Sent_for_Latam_Director_Approval= false;
                }else if(QuoteObj.UnitPrice> twoPercent){
                    System.debug('No Approval');
                    Sent_for_Manager_Approval = false;
                    Sent_for_Director_Approval= false;
                    Sent_for_Latam_Director_Approval= false;
                }
                
               
                
                
            }
            
               
            
        }// end of for loop
        
       
        
        
        
        user loginUserObj = new User();
        String quoteRaisedBy = '';
        loginUserObj = [SELECT Id, Name, IsActive, ContactId,UserRole.name,
                        Show_Inventory__c, Show_Credit_Limit__c, EnableDepot__c, Sales_Director__c,
                        Show_Inventory_Column__c, ManagerId, Show_InTransit__c, Show_InTransit_Values__c,HO__c, 
                        Country_Head__c, Marketing_Manager__c
                        FROM User 
                        WHERE Id =: UserInfo.getUserId()
                        AND IsActive = True];
        
        Id profileId = UserInfo.getProfileId();
        String profileName =[Select Id, Name from Profile where Id=:profileId].Name;
        system.debug(' @@@@ Profile Name '+profileName);
        
        
        if(profileName =='CAM(Sales Representative)'){
            quoteRaisedBy ='Territory Manager'; 
        }
        if(profileName =='CAM(Regional Manager)'){
            quoteRaisedBy ='Regional Manager';
        }
        
        System.debug('quoteRaisedBy '+quoteRaisedBy);
        
        
        
        
        Quote quoObj = new Quote();
        quoObj.Manager__c = loginUserObj.ManagerId;
        quoObj.Director__c = loginUserObj.Marketing_Manager__c;
        quoObj.Region_Head__c = loginUserObj.Country_Head__c;
        quoObj.Quote_Raised_By__c = quoteRaisedBy;
        
        quoObj.Inco_Term_Code__c = accOnjtemp.Inco_Term__c;
        quoObj.Payment_Term__c = accOnjtemp.Payment_Term_Code__c;
        
        //accOnjtemp
        
        if(Sent_for_Manager_Approval || Sent_for_Director_Approval || Sent_for_Latam_Director_Approval){
            quoObj.Status = 'Pending';  
        }else{
            quoObj.Status = 'Approved';
        }
        
        system.debug('Sent_for_Manager_Approval '+Sent_for_Manager_Approval);
        system.debug('Sent_for_Director_Approval '+Sent_for_Director_Approval);
        system.debug('Sent_for_Latam_Director_Approval '+Sent_for_Latam_Director_Approval);

        
        if(Sent_for_Manager_Approval){
            quoObj.sent_for_Region_Manager_Approval__c = true;
        }
        if(Sent_for_Director_Approval){
            quoObj.sent_for_Commercial_Manager_Approval__c = true;
        }
        if(Sent_for_Latam_Director_Approval){
            quoObj.sent_for_Commercial_Head_Approval__c = true;
        }
        
        quoObj.Id = quoteId;      
        update quoObj;
        
    }
    
    @AuraEnabled
    public static void updateQuoteLineItem(List<QuoteLineItem> ListQuote){
        update ListQuote;
    }
    
    @AuraEnabled
    public static User InventoryShow(){
        User loginUserObj = new User();
        Boolean isshowInventory = false;
        Boolean showInventory = false;
        
        List<Boolean> booleanList = new List<Boolean>();
        
        loginUserObj = [SELECT Id, Name, IsActive, ContactId,UserRole.name,
                        Show_Inventory__c, Show_Credit_Limit__c, EnableDepot__c, Sales_Director__c,
                        Show_Inventory_Column__c, ManagerId,Show_InTransit__c, Show_InTransit_Values__c,
                        HO__c, Country_Head__c, Marketing_Manager__c,ProfileId,Profile.Name
                        FROM User 
                        WHERE Id =: UserInfo.getUserId()
                        AND IsActive = True];
        
        
        
        return loginUserObj;
        
        
    }
    
    
    public class wrapperClassSKU{
        @AuraEnabled public String UOM {get;set;}
        @AuraEnabled public String  PackSize{get;set;}
        @AuraEnabled public Decimal MaxPrice {get;set;}
        @AuraEnabled public Decimal MinPrice {get;set;}
        @AuraEnabled public Decimal inventory {get;set;}
        
        @AuraEnabled public String SKUId {get;set;}
        @AuraEnabled public String itemNumber {get;set;}
        @AuraEnabled public String depotId {get;set;}
        @AuraEnabled public String storageLocation {get;set;}
        
        
        @AuraEnabled public String division {get;set;}
        @AuraEnabled public String distributionChannel {get;set;}
        @AuraEnabled public String SalesOrg {get;set;}
        @AuraEnabled public Decimal available {get;set;}
        @AuraEnabled public String available2 {get;set;}
        
        
    }
    
    
    
}