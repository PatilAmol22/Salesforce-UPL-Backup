public with sharing class OpportunityProductEntry_Controller {
    
    @AuraEnabled
    public static List<PricebookEntry> fetchSKUValues(String searchKeyWord,String oppId) {
        // for standard price book
        Opportunity oppObj = new Opportunity();
        oppObj =[SELECT Id,Country_of_Origin__c,CurrencyIsoCode,AccountId,Account.Sales_Org__c  
                 FROM Opportunity
                 WHERE Id=:oppId];
        
        String countryOfOrigin ='';
        countryOfOrigin = oppObj.Country_of_Origin__c;
        System.debug('### oppObj.Country_of_Origin__c '+oppObj.Country_of_Origin__c);
        String curCode = oppObj.CurrencyIsoCode;

        Pricebook2 Pricebook2Obj = new Pricebook2();
        Pricebook2Obj= [SELECT Id, Name, isActive FROM Pricebook2 WHERE Name='Standard Price Book' AND isActive=true]; 
        
        
        
        List < PricebookEntry > returnList = new List < PricebookEntry > (); 
        if(Pricebook2Obj!=null){
            // retrive all the product from the standard price book
            List<PricebookEntry> pricebookEntryList = new List<PricebookEntry>();
            pricebookEntryList = [SELECT Id, Name, isActive, Pricebook2Id,Product2.Pack_Size_1__c,Product2.Pack_Size__c,
                                  Product2Id,Product2.Name,Product2.Description,Product2.Product_Code__c,Product2.UOM1__c,
                                  Product2.Sales_Org__c
                                  FROM PricebookEntry 
                                  WHERE isActive=true
                                  AND Pricebook2Id=:Pricebook2Obj.Id
                                  AND Product2.Country_of_origin__c =:countryOfOrigin 
                                  AND CurrencyIsoCode =:curCode LIMIT 15] ;  
            System.debug('pricebookEntryList  '+pricebookEntryList);
            for (PricebookEntry obj: pricebookEntryList) {
                returnList.add(obj);
            }
        }
        System.debug('returnList  infetch SKU '+returnList);
        System.debug('returnList  infetch SKU Size '+returnList.size());
        return returnList;
        
    }
    
    
    
    
    
    
    //this is for fetching SKU on key press
    //searchHelperOnKeyPres
    @AuraEnabled
    public static List<PricebookEntry> searchHelperOnKeyPres(String searchKeyWord ,String selSalesOrg, String oppId ){
        System.debug('selSalesOrg '+selSalesOrg);
        Opportunity oppObj = new Opportunity();
        oppObj =[SELECT Id,Country_of_Origin__c,CurrencyIsoCode,AccountId,Account.Sales_Org__c 
                 FROM Opportunity
                 WHERE Id=:oppId];
        String curCode = oppObj.CurrencyIsoCode;
        //Domestic Sales Org
        
        String countryOfOrigin ='';
        countryOfOrigin = oppObj.Country_of_Origin__c;
     
        
        Pricebook2 Pricebook2Obj = new Pricebook2();
        Pricebook2Obj= [SELECT Id, Name, isActive FROM Pricebook2 WHERE Name='Standard Price Book' AND isActive=true LIMIT 1]; 
        List < PricebookEntry > returnList = new List < PricebookEntry > (); 
        if(Pricebook2Obj!=null){
            String priceBookId = Pricebook2Obj.Id;
            List<PricebookEntry> pricebookEntryList = new List<PricebookEntry>();
            String sQuery = 'SELECT Id, Name, isActive, Pricebook2Id,Product2.Pack_Size_1__c,Product2.UOM1__c,Product2.Pack_Size__c,Product2.Description, Product2Id,Product2.Name,Product2.Product_Code__c, Product2.Sales_Org__c FROM PricebookEntry WHERE Product2.Description like \'%'+searchKeyWord+'%\'  AND isActive = true  AND Pricebook2Id =\''+priceBookId+'\' AND CurrencyIsoCode =\''+curCode+'\' AND Product2.Country_of_origin__c =\''+countryOfOrigin+'\'';                   
            
            pricebookEntryList = Database.query(sQuery);
            if(pricebookEntryList.size()>0){
                for(PricebookEntry PricebookEntryObj :pricebookEntryList){
                    returnList.add(PricebookEntryObj);
                }
            }
            
        }
        return returnList;
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
            result ='pricebook entry currency code does not match opportunity currency code';
        }
        
        return result;
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
    
    
    @AuraEnabled
    public static void deleteOpportunityLineItem(String oppolineItemId){
        List<OpportunityLineItem> oppolineItemList =[Select Id, Name from OpportunityLineItem WHERE Id=:oppolineItemId];
        if(oppolineItemList.size()>0){
            delete oppolineItemList;
        }
    }
    
    
    
    @AuraEnabled
    public static List<OpportunityLineItem> fetchAllOppoLineItem(String oppoId){
        List<OpportunityLineItem>  opportunityLineItemList = new List<OpportunityLineItem>();
        opportunityLineItemList=[SELECT Id, OpportunityId, SortOrder, PricebookEntryId,PricebookEntry.Name,Product2.Description, 
                                 Product2Id, ProductCode, Name, CurrencyIsoCode, Quantity, 
                                 TotalPrice, UnitPrice, ListPrice, ServiceDate, Description,
                                 Sales_Org__c,Sales_Org__r.Name, Pack_Size__c FROM OpportunityLineItem
                                 WHERE OpportunityId =:oppoId
                                 ORDER BY CreatedDate DESC];
        
        return opportunityLineItemList;
        
    }
    
    //getting single Opportunity Line Item
    @AuraEnabled
    public static OpportunityLineItem fetchsingleOppoLineItem(String oppoLIId){
        
        OpportunityLineItem OppoLIObj = New OpportunityLineItem();
        OppoLIObj = [SELECT Id, OpportunityId, SortOrder, PricebookEntryId,PricebookEntry.Name,Product2.Description, 
                     Product2Id, Product2.Product_Code__c,Product2.Name,ProductCode, Name, CurrencyIsoCode, Quantity, 
                     TotalPrice, UnitPrice, ListPrice, ServiceDate, Description,
                     Sales_Org__c,Sales_Org__r.Name, Pack_Size__c FROM OpportunityLineItem
                     WHERE Id =:oppoLIId];
        
        return OppoLIObj;
    }
    
    @AuraEnabled
    public static List<PricebookEntry> searchHelperOnKeyPresPopup(String searchKeyWord ,String selSalesOrg, String oppId ){
        
        System.debug('oppId searchHelperOnKeyPresPopup '+oppId);
        
        Opportunity oppObj = new Opportunity();
        oppObj =[SELECT Id,Country_of_Origin__c,CurrencyIsoCode,AccountId,Account.Sales_Org__c 
                 FROM Opportunity
                 WHERE Id=:oppId];
        
        String curCode = oppObj.CurrencyIsoCode;
        
        String countryOfOrigin ='';
        countryOfOrigin = oppObj.Country_of_Origin__c;
         
        
        
        Pricebook2 Pricebook2Obj = new Pricebook2();
        Pricebook2Obj= [SELECT Id, Name, isActive FROM Pricebook2 WHERE Name='Standard Price Book' AND isActive=true LIMIT 1]; 
        List < PricebookEntry > returnList = new List < PricebookEntry > (); 
        if(Pricebook2Obj!=null){
            String priceBookId = Pricebook2Obj.Id;
            List<PricebookEntry> pricebookEntryList = new List<PricebookEntry>();
            String sQuery = 'SELECT Id, Name, isActive, Pricebook2Id,Product2.Pack_Size_1__c,Product2.UOM1__c,Product2.Pack_Size__c,Product2.Description, Product2Id,Product2.Name,Product2.Product_Code__c, Product2.Sales_Org__c FROM PricebookEntry WHERE  Product2.Description like \'%'+searchKeyWord+'%\'  AND isActive = true  AND Pricebook2Id =\''+priceBookId+'\' AND CurrencyIsoCode =\''+curCode+'\' AND Product2.Country_of_origin__c =\''+countryOfOrigin+'\'';                   
            
            pricebookEntryList = Database.query(sQuery);
            if(pricebookEntryList.size()>0){
                for(PricebookEntry PricebookEntryObj :pricebookEntryList){
                    returnList.add(PricebookEntryObj);
                }
            }
            
        }
        System.debug('returnList in popup '+returnList);
        System.debug('returnList in popup '+returnList.size());
        return returnList;
    }
    
    
    
    
}