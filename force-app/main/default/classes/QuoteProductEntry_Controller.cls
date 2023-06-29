public with sharing class QuoteProductEntry_Controller {
    
    
    //method for fetching Product 
    @AuraEnabled
    public static List<PricebookEntry> fetchSKUValues(String searchKeyWord, String quoteId ) {
        // for standard price book
        
        Quote oppObj = new Quote();
        oppObj =[SELECT Id,Opportunity.Country_of_Origin__c,CurrencyIsoCode,AccountId,Account.Sales_Org__c 
                 FROM Quote
                 WHERE Id=:quoteId];
        
        
        String curCode = oppObj.CurrencyIsoCode;
        
        String countryOfOrigin ='';
        countryOfOrigin = oppObj.Opportunity.Country_of_Origin__c;
        Pricebook2 Pricebook2Obj = new Pricebook2();
        Pricebook2Obj= [SELECT Id, Name, isActive FROM Pricebook2 WHERE Name='Standard Price Book' AND isActive=true]; 
        List < PricebookEntry > returnList = new List < PricebookEntry > (); 
        if(Pricebook2Obj!=null){
            // retrive all the product from the standard price book
            List<PricebookEntry> pricebookEntryList = new List<PricebookEntry>();
            pricebookEntryList = [SELECT Id, Name,Product2.Description, isActive, Pricebook2Id,Product2.Pack_Size_1__c, 
                                  Product2Id,Product2.Name,Product2.Product_Code__c,Product2.Pack_Size__c,Product2.UOM1__c,
                                  Product2.Sales_Org__c
                                  FROM PricebookEntry 
                                  WHERE isActive=true
                                  AND Pricebook2Id=:Pricebook2Obj.Id
                                  AND Product2.Country_of_origin__c=:countryOfOrigin 
                                  AND CurrencyIsoCode =: curCode LIMIT 15] ;  
            
            for (PricebookEntry obj: pricebookEntryList) {
                returnList.add(obj);
            }
        }
        return returnList;
        
    }
    
    //on key press on costom Lookup
    @AuraEnabled
    public static List<PricebookEntry> searchHelperOnKeyPres(String searchKeyWord ,String quoteId ){
        
        Quote quoteObj = new Quote();
        quoteObj =[SELECT Id,Opportunity.Country_of_Origin__c,CurrencyIsoCode,AccountId,Account.Sales_Org__c 
                   FROM Quote
                   WHERE Id=:quoteId];
        String curCode = quoteObj.CurrencyIsoCode;
        
        String countryOfOrigin ='';
        countryOfOrigin = quoteObj.Opportunity.Country_of_Origin__c;
        
        
        Pricebook2 Pricebook2Obj = new Pricebook2();
        Pricebook2Obj= [SELECT Id, Name, isActive FROM Pricebook2 WHERE Name='Standard Price Book' AND isActive=true LIMIT 1]; 
        List < PricebookEntry > returnList = new List < PricebookEntry > (); 
        if(Pricebook2Obj!=null){
            String priceBookId = Pricebook2Obj.Id;
            List<PricebookEntry> pricebookEntryList = new List<PricebookEntry>();
            
            String sQuery = 'SELECT Id, Name, isActive, Pricebook2Id,Product2.Pack_Size_1__c,Product2.Pack_Size__c,Product2.UOM1__c,Product2.Description, Product2Id,Product2.Name,Product2.Product_Code__c, Product2.Sales_Org__c FROM PricebookEntry WHERE  Product2.Description like \'%'+searchKeyWord+'%\'   AND isActive = true  AND Pricebook2Id =\''+priceBookId+'\' AND CurrencyIsoCode =\''+curCode+'\' AND Product2.Country_of_origin__c =\''+countryOfOrigin+'\'';                   
            
            System.debug('@@@@@ is sQuery '+sQuery);
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
    
    //fetchAllQuoteItem
    @AuraEnabled
    public static List<QuoteLineItem> fetchAllQuoteItem(String quoteId){
        List<QuoteLineItem> quoteLineItemList = new List<QuoteLineItem>();
        quoteLineItemList =[SELECT Id, IsDeleted, LineNumber, QuoteId, PricebookEntryId,Product2.Description, 
                            OpportunityLineItemId, Quantity, UnitPrice, Discount, Description, 
                            Product2Id,Product2.Name, SortOrder, ListPrice, Subtotal, TotalPrice, 
                            Sales_Org__c,Sales_Org__r.Name, Description_of_Goods__c, Pack_Size__c 
                            FROM QuoteLineItem
                            WHERE QuoteId=:quoteId
                            ORDER by CreatedDate DESC];
        
        return quoteLineItemList;
    }
    
    
    //fetching single Line Item for Quote
    @AuraEnabled
    public static QuoteLineItem fetchsingleQuoteLineItem(String quoteLitemId){
        QuoteLineItem quoteLineItemObj = new QuoteLineItem();
        quoteLineItemObj = [SELECT Id, IsDeleted, LineNumber, QuoteId, PricebookEntryId, 
                            OpportunityLineItemId, Quantity, UnitPrice, Discount, Description, 
                            Product2Id,Product2.Name,Product2.Product_Code__c, SortOrder, ListPrice, Subtotal, TotalPrice, 
                            Sales_Org__c,Sales_Org__r.Name, Description_of_Goods__c, Pack_Size__c 
                            FROM QuoteLineItem
                            WHERE Id=:quoteLitemId];
        System.debug('quoteLineItemObj '+quoteLineItemObj);
        
        return quoteLineItemObj;
    }
    
    
    @AuraEnabled
    public static void updateQuoteLineItem(List<QuoteLineItem> ListQuote){
        update ListQuote;
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
    
    //searchHelperOnKeyPresPopup
    @AuraEnabled
    public static List<PricebookEntry> searchHelperOnKeyPresPopup(String searchKeyWord ,String quoteId ){
        
        Quote quoteObj = new Quote();
        quoteObj =[SELECT Id,Opportunity.Country_of_Origin__c,CurrencyIsoCode,AccountId,Account.Sales_Org__c 
                   FROM Quote
                   WHERE Id=:quoteId];
        String curCode = quoteObj.CurrencyIsoCode;
        String countryOfOrigin ='';
        countryOfOrigin = quoteObj.Opportunity.Country_of_Origin__c;
        
        
        Pricebook2 Pricebook2Obj = new Pricebook2();
        Pricebook2Obj= [SELECT Id, Name, isActive FROM Pricebook2 WHERE Name='Standard Price Book' AND isActive=true LIMIT 1]; 
        List < PricebookEntry > returnList = new List < PricebookEntry > (); 
        if(Pricebook2Obj!=null){
            String priceBookId = Pricebook2Obj.Id;
            List<PricebookEntry> pricebookEntryList = new List<PricebookEntry>();
            String sQuery = 'SELECT Id, Name, isActive, Pricebook2Id,Product2.Pack_Size_1__c,Product2.Pack_Size__c,Product2.UOM1__c,Product2.Description, Product2Id,Product2.Name,Product2.Product_Code__c, Product2.Sales_Org__c FROM PricebookEntry WHERE  Product2.Name like \'%'+searchKeyWord+'%\'  AND isActive = true  AND Pricebook2Id =\''+priceBookId+'\' AND CurrencyIsoCode =\''+curCode+'\' AND Product2.Country_of_origin__c =\''+countryOfOrigin+'\'';                   
            
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
    public static void submitToApproval(String quoteId ){
        // Create an approval request for the Opportunity
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setComments('Submitting request for approval ');
        req1.setObjectId(quoteId);
        Approval.ProcessResult result = Approval.process(req1);
        
        
        /*
List<Quote> qtList = new List<Quote>();
Quote qotObj = new Quote();
Quote qotObjUpdate = new Quote();
qotObj =[select id,IsApprovalRequired__c FROM Quote WHERE id=:quoteId];
qotObjUpdate.Id = qotObj.Id;
qotObjUpdate.IsApprovalRequired__c = true;
qtList.add(qotObjUpdate);
if(qtList.size()>0){
update qtList;
}*/
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
    
    
    
}