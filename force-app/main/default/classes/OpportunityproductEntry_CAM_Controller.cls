public without sharing class  OpportunityproductEntry_CAM_Controller {
    
    @AuraEnabled
    public static List<PricebookEntry> fetchSKUValues(String searchKeyWord,String oppId) {
         List < PricebookEntry > returnList = new List < PricebookEntry > (); 
        
        Opportunity oppObj = [Select Id,Name,AccountId 
                              FROM Opportunity
                              WHERE Id =:oppId];
        
        System.debug('oppObj.AccountId today '+oppObj.AccountId);
            
        Account accObj = new Account();
        accObj = [Select Id, Name, Distribution_Channel__c,Division__c FROM Account WHERE Id=:oppObj.AccountId];
        Pricebook2 Pricebook2Obj = new Pricebook2();
        Pricebook2Obj= [SELECT Id, Name, isActive FROM Pricebook2 WHERE Name='Standard Price Book' AND isActive=true];
        System.debug('Pricebook2Obj '+Pricebook2Obj.Id);
       
        if(Pricebook2Obj!=null){
            // retrive all the product from the standard price book
            System.debug('accObj.Division__c '+accObj.Division__c);
            System.debug('accObj.Distribution_Channel__c ' +accObj.Distribution_Channel__c);
            List<PricebookEntry> pricebookEntryList = new List<PricebookEntry>();
            
            System.debug('@@@@accObj.Division__c  '+accObj.Division__c);
            System.debug('@@@ accObj.Distribution_Channel__c  '+accObj.Distribution_Channel__c);
            List<DistributorSalesAreaMapping__c> SalesAreaDMList = [SELECT Id, Division_Code__c, Sales_Org_Code__c, Order_Type__c, PriceGroupMaster__c,DistributionChannel__c, 
                                                                    Distribution_Channel_Code__c, SalesOrg__c, Division__c, Distributor__c FROM DistributorSalesAreaMapping__c
                                                                    where Distributor__c=:oppObj.AccountId];
            List<String>divisionIdsforDepot = new List<String>();
           
            for(DistributorSalesAreaMapping__c DSAM : SalesAreaDMList){
                divisionIdsforDepot.add(DSAM.Division__c);
            }
            
            System.debug('divisionIdsforDepot '+divisionIdsforDepot);
            System.debug('divisionIdsforDepot size '+divisionIdsforDepot.size());
            String saleogCode='';
            String distributionChanelCode='';
            Set<String> cntSalesOrg = new Set<String>();
            
            for(DistributorSalesAreaMapping__c sdaobj :SalesAreaDMList){
                cntSalesOrg.add(sdaobj.Sales_Org_Code__c);
            }
            
            
            //5711   5712
            //changes due to UPL-CR130 vishal Pawar 24 march 2021
            if(cntSalesOrg.size()== 1){
                for(String tmp :cntSalesOrg){
                     if(tmp == '5711'){
                        saleogCode = '5711';
                    } 
                    if(tmp=='5712'){
                        saleogCode = '5712';
                    }
                    
                }
                             
            }            
            if(saleogCode == '5711'){
                distributionChanelCode ='20';
            }else if(saleogCode == '5712'){
                distributionChanelCode ='40';
            }
            
            
            System.debug('saleogCode in chekcing '+saleogCode);
                
            System.debug('Pricebook2Obj.Id '+Pricebook2Obj.Id);
            System.debug('divisionIdsforDepot '+divisionIdsforDepot);
            System.debug('distributionChanelCode '+distributionChanelCode);
            
            pricebookEntryList = [SELECT Id, Name, isActive, Pricebook2Id,Product2.Pack_Size_1__c, 
                                  Product2Id,Product2.Name,Product2.Description,Product2.Product_Code__c,
                                  Product2.Sales_Org__c
                                  FROM PricebookEntry 
                                  WHERE isActive=true
                                  AND Pricebook2Id=:Pricebook2Obj.Id 
                                  AND Product2.Active_for_CAM__c = True
                                  AND Product2.Division__c IN:divisionIdsforDepot
                                  AND Product2.Sales_Org_Code__c=:saleogCode
                                  AND Product2.Distribution_Channel__r.Distribution_Channel_Code__c =:distributionChanelCode
                                  AND CurrencyIsoCode = 'USD' LIMIT 15] ;
            System.debug('pricebookEntryList '+pricebookEntryList);
            
           
           
            for (PricebookEntry obj: pricebookEntryList) {
                returnList.add(obj);
            }
        }
        
        return returnList;
        
    }
    
    
    @AuraEnabled
    public static List<PricebookEntry> searchHelperOnKeyPres(String searchKeyWord ,String selSalesOrg, String oppId ){
        System.debug('searchKeyWord in Addind product '+searchKeyWord);
        Pricebook2 Pricebook2Obj = new Pricebook2();
        Pricebook2Obj= [SELECT Id, Name, isActive FROM Pricebook2 WHERE Name='Standard Price Book' AND isActive=true LIMIT 1]; 
        List < PricebookEntry > returnList = new List < PricebookEntry > ();
        
        String curCode ='USD';
        Opportunity oppObj = [Select Id,Name,AccountId,Account.Sales_Org_Code__c
                              FROM Opportunity
                              WHERE Id =:oppId];
        String salesOrg = oppObj.Account.Sales_Org_Code__c;
        System.debug('sales org in serching typing '+salesOrg);
        Account accObj = new Account();
        accObj = [Select Id, Name, Distribution_Channel__c,Division__c FROM Account WHERE Id=:oppObj.AccountId];
       System.debug('accObj.Division__c '+accObj.Division__c);
           
        
        if(Pricebook2Obj!=null){
            String priceBookId = Pricebook2Obj.Id;
            List<PricebookEntry> pricebookEntryList = new List<PricebookEntry>();
            String sQuery = 'SELECT Id, Name, isActive, Pricebook2Id,Product2.Pack_Size_1__c,Product2.Description, Product2Id,Product2.Name,Product2.Product_Code__c, Product2.Sales_Org__c FROM PricebookEntry WHERE Product2.Description like \'%'+searchKeyWord+'%\' AND Product2.Division__c =\''+accObj.Division__c+'\' AND Product2.Distribution_Channel__c =\''+accObj.Distribution_Channel__c+'\' AND CurrencyIsoCode =\''+curCode+'\' AND isActive = true AND Product2.Active_for_CAM__c = True  AND Pricebook2Id =\''+priceBookId+'\''; 
            //String sQuery = 'SELECT Id, Name, isActive, Pricebook2Id,Product2.Pack_Size_1__c,Product2.Description, Product2Id,Product2.Name,Product2.Product_Code__c, Product2.Sales_Org__c FROM PricebookEntry WHERE Product2.Description like \'%'+searchKeyWord+'%\' AND Product2.Division__c =\''+accObj.Division__c+'\''; 
            
            
            
            System.debug('sQuery '+sQuery);
            pricebookEntryList = Database.query(sQuery);
            if(pricebookEntryList.size()>0){
                for(PricebookEntry PricebookEntryObj :pricebookEntryList){
                    returnList.add(PricebookEntryObj);
                }
            }
            
        }
        
        System.debug('returnList  size  in seraching '+returnList.size());
        return returnList;
    }
    
    @AuraEnabled
    public static List<wrapperClassSKU> fetchPriceBookMasterDetails(String productId, String oppId){
        
        String depoId='';
        String salesorgcodeforpbm ='';
        
        System.debug('productId today '+productId);
        System.debug('oppId today '+oppId);
        
        Opportunity oppObj = [Select Id,Name,AccountId 
                              FROM Opportunity
                              WHERE Id =:oppId];
        List<Distributor_Depot_Mapping__c> depotList = [SELECT id, Depot__c 
                                                        FROM Distributor_Depot_Mapping__c 
                                                        WHERE Distributor__c=:oppObj.AccountId 
                                                        AND Depot__c!='' Order By LastModifiedDate DESC LIMIT 1];
        
        List<DistributorSalesAreaMapping__c> SalesAreaDMList = [SELECT Id, Division_Code__c, Sales_Org_Code__c, Order_Type__c, 
                                                                PriceGroupMaster__c, Distribution_Channel_Code__c, SalesOrg__c, 
                                                                Division__c, Distributor__c 
                                                                FROM DistributorSalesAreaMapping__c 
                                                                where Distributor__c=:oppObj.AccountId];
        
        Account accObj = new Account();
        accObj = [Select Id,Name, Sales_Org__c,Price_Classification__c,Price_List_CAM__c,Cust_Group__c,Customer_Grp__c,
                  Customer_Country__c FROM Account WHERE Id=:oppObj.AccountId];
        
        List<String>divisionIds = new List<String>();
        for(DistributorSalesAreaMapping__c DSAMObj : SalesAreaDMList){
            divisionIds.add(DSAMObj.Division__c);
            salesorgcodeforpbm =DSAMObj.Sales_Org_Code__c;
        }
        System.debug('@@@ divisionIds: '+divisionIds);
        System.debug('@@@ salesorgcodeforpbm: '+salesorgcodeforpbm);
        System.debug('@@@ depotList: '+depotList);
        
        if(!depotList.isEmpty()){
            depoId = depotList[0].Depot__c;
        }
        
        
        List<PriceBookMaster__c> tempPBMList = new List<PriceBookMaster__c>();
        
        tempPBMList = [Select Id,DistributorCustomerCode__c 
                       FROM PriceBookMaster__c WHERE DistributorCustomerCode__c=:oppObj.AccountId];
        
        
        
        List<PriceBookMaster__c> PbmList = new List<PriceBookMaster__c>();
        List<wrapperClassSKU> wrapperClassSKUList = new List<wrapperClassSKU>();
        Product2 prodObj = [select Id,Name,Composite_Key__c,Pack_Size_1__c,Pack_Size__c
                            From Product2
                            WHERE id=:productId
                            AND Active_for_CAM__c= true];
        
        System.debug('prodObj select '+prodObj);
            
        String compoKey ='';
        if(prodObj!=null){
            compoKey = prodObj.Composite_Key__c;
            
            System.debug('compoKey in Opportunuty Level compoKey '+compoKey);
            System.debug('compoKey in Opportunuty Level salesorgcodeforpbm '+salesorgcodeforpbm);
            System.debug('compoKey in Opportunuty Level depoId '+depoId);
            System.debug('compoKey in Opportunuty Level divisionIds '+divisionIds);
            System.debug('compoKey in Opportunuty Level accObj.Price_Classification__c '+accObj.Price_Classification__c);
            System.debug('compoKey in Opportunuty Level accObj.Price_List_CAM__c '+accObj.Price_List_CAM__c);
            System.debug('compoKey in Opportunuty Level accObj.Customer_Grp__c '+accObj.Customer_Grp__c);
            System.debug('compoKey in Opportunuty Level accObj.Sales_Org__c '+accObj.Sales_Org__c);
            
            
            
            
            
            
            
            
            
            if(tempPBMList.size()>0){
                System.debug('inside ACCOUNT ');
                
               
                
                PbmList = [SELECT Id,DistributorCustomerCode__c,SKUCode__c,Sales_Org__c,
                           StartDate__c,EndDate__c,UOM__c,Division__c,DistributionChannel__c,
                           DepotCode__c,Price__c,MinPrice__c,CompositeKey__c,Sales_Org_Code__c
                           FROM PriceBookMaster__c
                           WHERE SKUCombinationKey__c =:compoKey 
                           AND DistributorCustomerCode__c =:oppObj.AccountId
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
                System.debug('inside Classification  ');    
            }
            
            
            System.debug('PbmList Size '+PbmList);
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
            
            wrapperClassSKU wrapObj = new wrapperClassSKU();
            
            wrapObj.UOM = PbmList[0].UOM__c;
            wrapObj.PackSize = prodObj.Pack_Size_1__c;
            wrapObj.MinPrice = PbmList[0].MinPrice__c; 
            wrapObj.MaxPrice = PbmList[0].Price__c;
            
            
            
            wrapObj.distributionChannel = PbmList[0].DistributionChannel__c;
            wrapObj.division = PbmList[0].Division__c;
            wrapObj.SalesOrg = PbmList[0].Sales_Org__c;
            System.debug('sRequList Avilable '+sRequList.size());
            
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
            wrapObj.depotId = PbmList[0].DepotCode__c;//DepotObj.Id;
            wrapObj.storageLocation =  PbmList[0].DepotCode__c;//DepotObj.Id;
            wrapperClassSKUList.add(wrapObj);
            
        }
        return wrapperClassSKUList;
    }
    
    @AuraEnabled
    public static String saveOpportunityLineItem(List<OpportunityLineItem> ListOpportunity){
        String result ='';
        try{
            Insert ListOpportunity;     
            result ='Success';
        }
        catch(Exception ex){
            System.debug('Error Msg '+ex.getMessage());
            System.debug('Error Line Number '+ex.getLineNumber());
            result = ex.getMessage();
        }
        
        return result;
    }
    
    @AuraEnabled
    public static List<OpportunityLineItem> fetchAllOppoLineItem(String oppoId){
        List<OpportunityLineItem>  opportunityLineItemList = new List<OpportunityLineItem>();
        opportunityLineItemList=[SELECT Id, OpportunityId, SortOrder, PricebookEntryId,PricebookEntry.Name,Product2.Description, 
                                 Product2Id, ProductCode, Name, CurrencyIsoCode, Quantity,UOM__c,Min_Price__c,Max_Price__c, 
                                 TotalPrice, UnitPrice, ListPrice, ServiceDate, Description,
                                 Sales_Org__c,Sales_Org__r.Name, Pack_Size__c FROM OpportunityLineItem
                                 WHERE OpportunityId =:oppoId
                                 ORDER BY CreatedDate DESC];
        return opportunityLineItemList;
        
    }
    
    
    @AuraEnabled
    public static void deleteOpportunityLineItem(String oppolineItemId){
        System.debug('oppolineItemId '+oppolineItemId);
        List<OpportunityLineItem> oppolineItemList =[Select Id, Name from OpportunityLineItem WHERE Id=:oppolineItemId];
        if(oppolineItemList.size()>0){
            delete oppolineItemList;
        }
    }
    
    @AuraEnabled
    public static OpportunityLineItem fetchsingleOppoLineItem(String oppoLIId){
        
        OpportunityLineItem OppoLIObj = New OpportunityLineItem();
        OppoLIObj = [SELECT Id, OpportunityId, SortOrder, PricebookEntryId,PricebookEntry.Name,Product2.Description, 
                     Product2Id, Product2.Product_Code__c,Product2.Name,ProductCode, Name, CurrencyIsoCode, Quantity, 
                     TotalPrice, UnitPrice, ListPrice, ServiceDate, Description,UOM__c,Min_Price__c,Max_Price__c,
                     Sales_Org__c,Sales_Org__r.Name, Pack_Size__c FROM OpportunityLineItem
                     WHERE Id =:oppoLIId];
        
        return OppoLIObj;
    }
    
    @AuraEnabled
    public static void updateOpportunityLineItem(List<OpportunityLineItem> ListOpportunity){
        try{
            update ListOpportunity;    
        }
        catch(Exception ex){
            System.debug('Error Occured Line Number '+ex.getLineNumber());
            System.debug('Error Occured Line Number '+ex.getMessage());
        }
        
    }
    
    //this function is used for show/hide inventory colom on interface 
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
    
    
    // Wrapper class to select SKU 
    // wrapper or Inner class with @AuraEnabled {get;set;} properties
    public class wrapperClassSKU{
        @AuraEnabled public String UOM {get;set;}
        @AuraEnabled public String  PackSize{get;set;}
        @AuraEnabled public Decimal MaxPrice {get;set;}
        @AuraEnabled public Decimal MinPrice {get;set;}
        @AuraEnabled public Decimal inventory {get;set;}
        
        @AuraEnabled public String SKUId {get;set;}
        
        @AuraEnabled public String depotId {get;set;} 
        @AuraEnabled public String storageLocation {get;set;}
        
        @AuraEnabled public String division {get;set;}
        @AuraEnabled public String distributionChannel {get;set;}
        @AuraEnabled public String SalesOrg {get;set;}
        
        @AuraEnabled public Decimal available {get;set;}
        @AuraEnabled public String available2 {get;set;}
        
    }
    
    
    
    
}