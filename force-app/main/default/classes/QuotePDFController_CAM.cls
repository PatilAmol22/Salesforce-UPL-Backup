public without sharing class QuotePDFController_CAM {
    
     public List<QuoteLineItem>  quoteLineItemList {get;set;}
    Public Quote QuoteObj {get;set;}
    public String numberInWord {get;set;}
    public String curCodes {get;set;}
    
  
    public Account supllierObj {get;set;}
    public Bank_Details__c bankDetailsObj {get;set;}
    public String curCode {get;set;}
    public String curSign {get;set;}
    public String imageURL {get;set;}
    Public String imgUrl {get;set;}
    Public String stamImageURL {get;set;}
    
    
   
    
    
    public QuotePDFController_CAM(ApexPages.StandardController controller) {
        quoteLineItemList = new List<QuoteLineItem>();
        QuoteObj = new Quote();
        
    }
    
    public void gettingQuoteID(){
    try{
            String quoteId = ApexPages.currentPage().getParameters().get('qid');
            System.debug('id in generate PDF Controller '+quoteId); 
            stamImageURL ='';
            curCodes ='';
            if(quoteId!=''){
                
                Id uId = UserInfo.getUserId();
                
                User userObj = [Select Id,Name, Signature__c FROM User Where Id=:uId];
                System.debug('userObj signature '+userObj.Signature__c);
                if(userObj.Signature__c!=null){
                  imageURL = userObj.Signature__c.subStringBetween(userObj.Signature__c.contains('src') ? 'src="' : 'href="','"').replaceAll('&amp;','&');    
                    System.debug('@@@@ imageURL '+imageURL);
                   
                }
                
                
                
                QuoteObj = [SELECT Id, OwnerId,Name,Quote_Number__c, Inco_Term_Code__c,Payment_Term__c,Payment_Term__r.Payterms_Desc__c,Inco_Term_Code__r.Name,Inco_Term_Code__r.IncoTerm_Code__c,Account.SAP_Code__c,CreatedDate,FOB__c,CurrencyIsoCode,Container_load__c,Freight__c, Port_of_Final_destination__c, 
                            OpportunityId, Pricebook2Id, ContactId,Port_of_loading__c, QuoteNumber,Place_of_Receipt_By_pre_carrier__c,
                            IsSyncing, ShippingHandling, Tax, Status, ExpirationDate, Description,Account.Name,
                            Account.Billing_Street_1__c, Account.Billing_Street_2__c,Account.Billing_Street_3__c,
                            Account.Billing_Street_4__c,Account.Billing_Street_5__c,Account.Billing_Street_6__c,Account.Sales_Org_Country__c,
                            Subtotal, TotalPrice, LineItemCount, BillingStreet, BillingCity, BillingState,
                            BillingPostalCode, BillingCountry, BillingLatitude, BillingLongitude, 
                            BillingGeocodeAccuracy, BillingAddress, ShippingStreet, ShippingCity, 
                            ShippingState, ShippingPostalCode, ShippingCountry, ShippingLatitude,
                            ShippingLongitude, ShippingGeocodeAccuracy, ShippingAddress, BillingName, 
                            ShippingName, Email, Phone, Fax, AccountId, Discount, GrandTotal, CanCreateQuoteLineItems,
                            Ship_to_Party__c,Carriage_By__c, SGS_Inspection__c, Country_of_Origin__c, Inco_Term_2__c,
                            Dated__c, Country_of_Final_Destinations__c, Inco_Term__c,Payment_Term1__c,
                            Opportunity.Account.Name,Opportunity.Account.BillingAddress,
                            Opportunity.Account.Billing_Street_1__c,Opportunity.Account.Billing_Street_2__c,Opportunity.Account.Billing_Street_3__c,
                            Opportunity.Account.Billing_Street_4__c,Opportunity.Account.Billing_Street_5__c,Opportunity.Account.Billing_Street_6__c,
                            Supplier__c,Ship_to_Party__r.Location_Name__c,Ship_to_Party__r.Billing_Street_1__c,Ship_to_Party__r.Billing_Street_2__c,
                            Ship_to_Party__r.Billing_Street_3__c,Ship_to_Party__r.Billing_Street_4__c,Ship_to_Party__r.Billing_Street_5__c,
                            Ship_to_Party__r.Billing_Street_6__c,Ship_to_Party__r.Pincode__c,Ship_to_Party__r.Country__c
                            FROM Quote
                            WHERE Id =:quoteId];
                String suplid = QuoteObj.Supplier__c;
                //System.debug('QuoteObj.Supplier__c '+QuoteObj.Supplier__c);
                
                /*supllierObj =[SELECT Id,Name,BillingStreet,BillingCountry,BillingPostalCode,Phone,
                              fax,Email__c
                              FROM Account 
                              WHERE Id=:suplid]; 
                
                System.debug('supllierObj '+supllierObj);*/
                
                
                stamImageURL='/servlet/servlet.FileDownload?file=';
                
                
                List< document > documentList=[select id, name from document where 
                                               Name=:'UPLStamp' LIMIT 1];
                System.debug('documentList '+documentList);
                System.debug('documentList Size  '+documentList.size());
                
                if(documentList.size()>0)
                {
                    stamImageURL = stamImageURL+documentList[0].id;
                    System.debug('stamImageURL '+stamImageURL);
                }
                
                
                
                
               
               
                if(QuoteObj.CurrencyIsoCode == 'USD'){
                    curCode ='USD';
                    curCodes = 'Dollars';
                    curSign ='$';
                }
                if(QuoteObj.CurrencyIsoCode == 'EUR'){
                    curCode ='EUR';
                    curCodes = 'Euros';
                    curSign ='€';
                }
                
                Decimal subtotal = (QuoteObj.Subtotal).setScale(2);
               
               //numberInWord = NumberToWord.english_number(subtotal,curCodes);
                numberInWord = NumberToWord.english_number(subtotal);
                
                
                //numberInWord = getNumberTOWordConvertion(subtotal,curCodes);
                
                
                List<QuoteLineItem> tempQuoteLineItemList = new List<QuoteLineItem>();
                
                tempQuoteLineItemList  = [SELECT Id,Product2.Description,IsDeleted, LineNumber, CurrencyIsoCode, CreatedDate, CreatedById,
                                          LastModifiedDate, LastModifiedById, SystemModstamp, LastViewedDate, LastReferencedDate, 
                                          QuoteId,Product2.Name,Product2.Pack_Size__c, PricebookEntryId, OpportunityLineItemId, Quantity, UnitPrice, 
                                          Discount, Description,Pack_Size__c, Product2Id, SortOrder, ListPrice, Subtotal, TotalPrice 
                                          FROM QuoteLineItem
                                          WHERE QuoteId=:quoteId];
                System.debug('tempQuoteLineItemList.size() Out side '+tempQuoteLineItemList.size());
                if(tempQuoteLineItemList.size()>0){
                    System.debug('tempQuoteLineItemList.size() '+tempQuoteLineItemList.size());
                    quoteLineItemList = tempQuoteLineItemList;
                }
                
                  System.debug('QuoteObj.Supplier__c '+QuoteObj.Supplier__c);
                
               
                
                
            }
            
        }
        catch(Exception ex){
            System.debug('Error Occure Line Number '+ex.getLineNumber());
            System.debug('Error Occure Message '+ex.getMessage());
        }
        
        
    } 
    

}