public class Brazil_priceBook {
    
    @AuraEnabled
    public Static List<Price_Book__c> priceBookListt {get;set;}
    @AuraEnabled
    public Static List<Price_Book_Sales_District__c> priceDistList {get;set;}
    @AuraEnabled
    public Static String SalesdtId {get;set;}
    @AuraEnabled
    public Static List<Price_Book_Details__c> priceBookdetailList {get;set;}
    @AuraEnabled
    public Static Map<String,Price_Book_Details__c> PBDupsertmap {get;set;}    
    
    //Constructor
    public Brazil_priceBook(){}
    
    @AuraEnabled
    public static wrapperForAll getPriceBookRecord(String priceBookRecId){
        
        system.debug('priceBookRecId-------'+priceBookRecId);
        wrapperForAll objectOfall = new wrapperForAll();
        
        objectOfall.priceBookList  = [select id,Name,Division__c,Valid_From__c,
                                      Currency__c,
                                      Expiry_Date__c,Division__r.Name,CurrencyIsoCode
                                      from Price_Book__c 
                                      where id=:priceBookRecId];
        
        objectOfall.priceBookDetailLst =  [select  id,Name,Price_Book__c,
                                           Sales_District1__c,Unit_Price__c,
                                           Minimum_Price__c,
                                           Monthly_Interest_Rate__c,
                                           Exchange_Rate__c,SKU__c,SKU__r.name,
                                           Sku_Name__c,Sku_Name1__c,SKU_Code__c
                                           from Price_Book_Details__c
                                           where Price_Book__c=:priceBookRecId
                                           AND Sku_Name1__c != null];
        
        
        objectOfall.priceBookSalesDistLst =  [ select id,Name,Price_Book__c,Sales_District1__c,
                                              Sales_District1__r.Name,Sales_District_Name1__c
                                              from Price_Book_Sales_District__c
                                              where Price_Book__c=:priceBookRecId
                                             ];
        

        System.debug('1-priceBookLIst-->'+objectOfall.priceBookList);
        System.debug('2-priceBookDetailLst-->'+objectOfall.priceBookDetailLst.size()); 
        System.debug('3-priceBookSalesDistLst-->'+objectOfall.priceBookSalesDistLst.size()); 
        objectOfall.salesdistCount = objectOfall.priceBookDetailLst.size();
       return objectOfall ;
    }
    
    @AuraEnabled
    public static String clonePriceBookapex(String arrOfSales,Price_Book__c priceBookAsObj,String skuList,String validfrm,String expiryfrm,String currencyName,String divName){
        System.debug('Implment Clone---->');
        try{
           
            List<wrapperForSalesDistrict> salesDistList = (List<wrapperForSalesDistrict>)JSON.deserialize(arrOfSales, List<wrapperForSalesDistrict>.class);
            List<wrapperForProductSku> apexSkuList = (List<wrapperForProductSku>)JSON.deserialize(skuList, List<wrapperForProductSku>.class);
            
            priceDistList = new List<Price_Book_Sales_District__c>();
            priceBookdetailList = new List<Price_Book_Details__c>();
            priceBookListt = new List<Price_Book__c>();
            String priceBookName = ''; 
            String prbName = '';
            
           			prbName = priceBookAsObj.Name;
                    priceBookAsObj = new Price_Book__c();
            		System.debug('currencyName--'+currencyName);
            
                    if(currencyName == 'Both'){
                        
                        priceBookName = 'BRL'+' : '+prbName;
                        priceBookAsObj.Name = priceBookName;
                        priceBookAsObj.Valid_From__c = Date.valueof(validfrm);
                        priceBookAsObj.Expiry_Date__c = Date.valueof(expiryfrm);
                        priceBookAsObj.Currency__c = 'Only BRL';
                        priceBookAsObj.CurrencyIsoCode = 'BRL';                        
                        priceBookListt.add(priceBookAsObj);
                            
                        Price_Book__c prb = new Price_Book__c();
                        priceBookName = 'USD'+' : '+prbName;
                        prb.Name = priceBookName;
                        prb.Valid_From__c = Date.valueof(validfrm);
                        prb.Expiry_Date__c = Date.valueof(expiryfrm);
                        prb.Division__c = priceBookAsObj.Division__c;
                        prb.Currency__c = 'Only USD';
                        prb.CurrencyIsoCode = 'USD';                        
                        priceBookListt.add(prb);
                        
                    }else{
                        
                        System.debug('Currency-------'+currencyName);
                        priceBookName = currencyName+' : '+prbName;
                        priceBookAsObj.Name = priceBookName;
                        priceBookAsObj.Valid_From__c = Date.valueof(validfrm);
                        priceBookAsObj.Expiry_Date__c = Date.valueof(expiryfrm);
                        priceBookAsObj.Division__c = divName;
                        if(currencyName == 'BRL'){
                        	priceBookAsObj.Currency__c = 'Only BRL';
                            priceBookAsObj.CurrencyIsoCode = 'BRL';
                        }else{
                            priceBookAsObj.Currency__c = 'Only USD';
                            priceBookAsObj.CurrencyIsoCode = 'USD';
                        }
                        priceBookListt.add(priceBookAsObj);
                    }
                	
                if(priceBookListt.size()>0){
                    insert priceBookListt;
                    
                    for(Price_Book__c prcbook : priceBookListt){
                        
                        //inserting into Price And salesDistrict Object
                        if(salesDistList.size()>0){
                            
                            for(wrapperForSalesDistrict slds : salesDistList){
                                Price_Book_Sales_District__c obj = new Price_Book_Sales_District__c();
                                obj.Price_Book__c = prcbook.id;
                                SalesdtId = slds.sdtId;
                                obj.Sales_District1__c = slds.sdtId;
                                priceDistList.add(obj);
                            }
                        }//salesDistList End
                        
                        //inserting into Price Book Detail Object
                      
                        if(apexSkuList.size()>0){
                            
                            for(wrapperForProductSku skuDetails : apexSkuList){
                                
                                Price_Book_Details__c prcbookdtObj = new Price_Book_Details__c();
                                prcbookdtObj.Sales_District1__c = SalesdtId;
                                prcbookdtObj.Price_Book__c = prcbook.id;
                                prcbookdtObj.SKU__c = skuDetails.skuId;
                                System.debug('skuDetails_code-->'+skuDetails.SkuCode);
                                prcbookdtObj.CurrencyIsoCode =  priceBookAsObj.CurrencyIsoCode;
                                prcbookdtObj.Unit_Price__c = skuDetails.unitPrice;
                                prcbookdtObj.Minimum_Price__c = skuDetails.minPrice;
                                prcbookdtObj.Exchange_Rate__c = skuDetails.exchangeRate;
                                prcbookdtObj.Monthly_Interest_Rate__c = skuDetails.monthlyIntRate;
                                priceBookdetailList.add(prcbookdtObj);
                            }
                        }// apexSkuList End
                    }// inner for loop end
                }// if block end
                
                if(priceDistList.size()>0){
                    system.debug('Insret Block priceDistList==>'+priceDistList);
                    insert priceDistList;
                    System.debug('----Done----');
                }
                if(priceBookdetailList.size()>0){
                   // system.debug('Insret Block priceBookdetailList==>'+priceBookdetailList);
                    insert priceBookdetailList;
                    System.debug('----Done-1---');
                }
            
            
        }catch(Exception ex){
            System.debug('Ex--'+ex.getMessage());
            System.debug('ExLineNumber--'+ex.getLineNumber());
        }
        return 'Success';
    }
    
    @AuraEnabled
    public static String savePriceBookapex(String arrOfSales,Price_Book__c priceBookAsObj,String skuList,String validfrm,String expiryfrm,String currencyName){
        try{
           
            List<wrapperForSalesDistrict> salesDistList = (List<wrapperForSalesDistrict>)JSON.deserialize(arrOfSales, List<wrapperForSalesDistrict>.class);
            List<wrapperForProductSku> apexSkuList = (List<wrapperForProductSku>)JSON.deserialize(skuList, List<wrapperForProductSku>.class);
            
            
            priceDistList = new List<Price_Book_Sales_District__c>();
            priceBookdetailList = new List<Price_Book_Details__c>();
            priceBookListt = new List<Price_Book__c>();
            String priceBookName = ''; 
            String prbName = '';
            
            System.debug('priceBookAsObj.Id---------'+priceBookAsObj.id);
            if(priceBookAsObj.id == null){
                
                	prbName = priceBookAsObj.Name;
                
                    if(currencyName == 'Both'){
                        
                        priceBookName = 'BRL'+' : '+prbName;
                        priceBookAsObj.Name = priceBookName;
                        priceBookAsObj.Valid_From__c = Date.valueof(validfrm);
                        priceBookAsObj.Expiry_Date__c = Date.valueof(expiryfrm);
                        priceBookAsObj.Currency__c = 'Only BRL';
                        priceBookAsObj.CurrencyIsoCode = 'BRL';
                        
                        priceBookListt.add(priceBookAsObj);
                            
                        Price_Book__c prb = new Price_Book__c();
                        priceBookName = 'USD'+' : '+prbName;
                        prb.Name = priceBookName;
                        prb.Valid_From__c = Date.valueof(validfrm);
                        prb.Expiry_Date__c = Date.valueof(expiryfrm);
                        prb.Division__c = priceBookAsObj.Division__c;
                        prb.Currency__c = 'Only USD';
                        prb.CurrencyIsoCode = 'USD';
                        
                        priceBookListt.add(prb);
                        
                    }else{
                        
                        System.debug('Currency-------'+currencyName);
                        priceBookName = currencyName+' : '+priceBookAsObj.Name;
                        priceBookAsObj.Name = priceBookName;
                        priceBookAsObj.Valid_From__c = Date.valueof(validfrm);
                        priceBookAsObj.Expiry_Date__c = Date.valueof(expiryfrm);
                        if(currencyName == 'BRL'){
                        	priceBookAsObj.Currency__c = 'Only BRL';
                            priceBookAsObj.CurrencyIsoCode = 'BRL';
                        }else{
                            priceBookAsObj.Currency__c = 'Only USD';
                            priceBookAsObj.CurrencyIsoCode = 'USD';
                        }
                        priceBookListt.add(priceBookAsObj);
                    }
                	
                if(priceBookListt.size()>0){
                    insert priceBookListt;
                    
                    for(Price_Book__c prcbook : priceBookListt){
                        
                        //inserting into Price And salesDisrtict Object
                        if(salesDistList.size()>0){
                            
                            System.debug('salesDistList-->'+salesDistList);
                            for(wrapperForSalesDistrict slds : salesDistList){
                                Price_Book_Sales_District__c obj = new Price_Book_Sales_District__c();
                                obj.Price_Book__c = prcbook.id;
                                obj.Sales_District1__c = slds.sdtId;
                                
                                SalesdtId = slds.sdtId;
                                priceDistList.add(obj);
                            }
                        }//salesDistList End
                        
                        //inserting into Price Book Detail Object
                        if(apexSkuList.size()>0){
                            
                            for(wrapperForProductSku skuDetails : apexSkuList){
                                
                                Price_Book_Details__c prcbookdtObj = new Price_Book_Details__c();
                                
                                prcbookdtObj.Sales_District1__c = SalesdtId;
                                prcbookdtObj.Price_Book__c = prcbook.id;
                                prcbookdtObj.SKU__c = skuDetails.skuId;
                                prcbookdtObj.CurrencyIsoCode =  prcbook.CurrencyIsoCode;
                                if(prcbook.CurrencyIsoCode == 'BRL' && currencyName == 'Both'){
                                    
                                    prcbookdtObj.Unit_Price__c = skuDetails.unitPrice * skuDetails.exchangeRate;
                                    prcbookdtObj.Minimum_Price__c = skuDetails.minPrice * skuDetails.exchangeRate;
                                    
                                }else{
                                    
                                    prcbookdtObj.Unit_Price__c = skuDetails.unitPrice;
                                    prcbookdtObj.Minimum_Price__c = skuDetails.minPrice;
                                }
                                
                                prcbookdtObj.Exchange_Rate__c = skuDetails.exchangeRate;
                                prcbookdtObj.Monthly_Interest_Rate__c = skuDetails.monthlyIntRate;
                                priceBookdetailList.add(prcbookdtObj);
                            }
                        }// apexSkuList End
                    }// inner for loop end
                }// if block end
                
                if(priceDistList.size()>0){
                    system.debug('priceDistList==>'+priceDistList);
                    insert priceDistList;
                }
                if(priceBookdetailList.size()>0){
                    system.debug('priceBookdetailList==>'+priceBookdetailList);
                    insert priceBookdetailList;
                }
            }else{
                
                system.debug('Name-->'+priceBookAsObj.Name);
                system.debug('currencyName-->'+currencyName);
               
                
                priceBookName = currencyName+' : '+priceBookAsObj.Name;
                priceBookAsObj.Name = priceBookName;                
                priceBookAsObj.Valid_From__c = Date.valueof(validfrm);
                priceBookAsObj.Expiry_Date__c = Date.valueof(expiryfrm);
                
                upsert priceBookAsObj;
                
                System.debug('Updated PriceBook-->'+priceBookAsObj);
                /*
                List<Price_Book_Details__c> lstTodel = new List<Price_Book_Details__c>();
                List<Price_Book_Sales_District__c> lstTodelOfPBSD = new List<Price_Book_Sales_District__c>();
				
                lstTodelOfPBSD = [select id,Name,Price_Book__c,Sales_District1__c
                                              from Price_Book_Sales_District__c
                                              where Price_Book__c=:priceBookAsObj.Id];
                
                lstTodel = [select id,Price_Book__c,name 
                            from Price_Book_Details__c
                            where Price_Book__c =:priceBookAsObj.Id]; 
                */
                //delete lstTodel;
                //delete lstTodelOfPBSD;
                
                System.debug('salesDistList------>>>'+salesDistList);
                
                 for(wrapperForSalesDistrict slds : salesDistList){
                    
                    Price_Book_Sales_District__c obj = new Price_Book_Sales_District__c();
                    obj.Price_Book__c = priceBookAsObj.id;
                    obj.Sales_District1__c = slds.sdtId;
                    obj.id=slds.Id1;
                    System.debug('slds.id--->>>'+slds.id);
                    SalesdtId = slds.sdtId;
                    priceDistList.add(obj);
                }
                
                System.debug('apexSkuList------>>>'+apexSkuList.size());
                for(wrapperForProductSku skuDetails : apexSkuList){
                    
                    Price_Book_Details__c prcbookdtObj = new Price_Book_Details__c();
                    prcbookdtObj.Sales_District1__c = SalesdtId;
                    prcbookdtObj.Price_Book__c = priceBookAsObj.id;
                    prcbookdtObj.SKU__c = skuDetails.skuId;
                    prcbookdtObj.CurrencyIsoCode =  priceBookAsObj.CurrencyIsoCode;
                    prcbookdtObj.Unit_Price__c = skuDetails.unitPrice;
                    prcbookdtObj.Minimum_Price__c = skuDetails.minPrice;
                    prcbookdtObj.Exchange_Rate__c = skuDetails.exchangeRate;
                    prcbookdtObj.Monthly_Interest_Rate__c = skuDetails.monthlyIntRate;
                    prcbookdtObj.id = skuDetails.id;
                    System.debug('----skuDetails.id----'+skuDetails.id);
                    priceBookdetailList.add(prcbookdtObj);
                }
                /*
				    Made upsert command change instead of Insert 
						for below Line as Sandip Sir asked to do.
					dated - 04-07-2018
				*/
                if(priceBookdetailList.size()>0){
                    upsert priceBookdetailList;
                     System.debug('----Done----');
                } 
                if(priceDistList.size()>0){
                    upsert priceDistList;
                     System.debug('----Done1----');
                }
                
                
            }
        }catch(Exception ex){
            
            System.debug('ErrorCause==>'+ex.getMessage());
            System.debug('ErrorLine==>'+ex.getLineNumber());
        }
        
        return priceBookAsObj.id;
    }
    
    @AuraEnabled
    public static List<String> getCurrency(){
        List<String> options = new List<String>();
        Schema.DescribeFieldResult fieldResult = Price_Book__c.Currency__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry f: ple) {
            options.add(f.getLabel());
        }
        System.debug('options==>'+options);
        return options;
    }
    /*    
    @AuraEnabled
    public static String getListViews(){
        List<Price_Book__c> prcbk = [SELECT Id, Name 
                                    FROM Price_Book__c 
                                    ORDER BY createdDate desc];
        // Perform isAccessible() check here
        return prcbk[0].id;
    }*/
    @AuraEnabled
    public static List<ListView> getListViews(){
        List<ListView> lstview = [SELECT Id, Name 
                                    FROM ListView 
                                    where (Name Like '%All%'
                                 	AND SobjectType = 'Price_Book__c')];
        // Perform isAccessible() check here
        return lstview;
    }
    /*
     * 
     * Earliar we are getting data from Sales District object
     * So that is the reason we are havaing naming convention
     * as Sales_District1__c instead of Sales_District__c
     * 
    @AuraEnabled
    public static List<Sales_District__c> getSalesDistrict() {
                
        return [SELECT Id, Name, CurrencyIsoCode, Sales_District_Code__c,
                Zone__r.Name, SalesOrg__r.Sales_Org_Code__c,
                User__c, SalesOrg__c, Zone__c, SBU__c 
                FROM Sales_District__c
                where SalesOrg__r.Sales_Org_Code__c ='5191'
                ORDER BY createdDate ASC];
        
      return [SELECT Id, Name, RegionCode__c, 
				SalesOrg__c,Sales_Org_Code__c,
                Zone__c, RegionHead__c, 
                RegionHeadActive__c,CreatedDate 
                FROM Region__c
                where SalesOrg__r.Sales_Org_Code__c ='5191'
                ORDER BY createdDate ASC]; 
        
    }*/
     @AuraEnabled
    public static List<Region__c> getSalesDistrict() {
        
      return [SELECT Id, Name, RegionCode__c, 
				SalesOrg__c,Sales_Org_Code__c,
                Zone__c, RegionHead__c, 
                RegionHeadActive__c,CreatedDate 
                FROM Region__c
                where SalesOrg__r.Sales_Org_Code__c ='5191'
                ORDER BY createdDate ASC]; 
        
    }    
    @AuraEnabled
    public static List<Division__c> getDivision() {
        System.debug('received Division call---------->');
        return [SELECT Id, Name ,Division_Code__c
                FROM Division__c 
                ORDER BY createdDate ASC];
    }
    @AuraEnabled
    public static List<Division__c> getDefaultDivision(){
      
       return  [SELECT Id, Name ,Division_Code__c
                FROM Division__c 
                where Name LIKE '%Agro Formulation%'
                ORDER BY createdDate ASC
                LIMIT 1];
    }    
    @AuraEnabled
    public static List<SKU__c> getSku(String divisionId) {
        
        return [SELECT Id, Name,SKU_Code__c,Division__c,
                SKU_Description__c,
                Product_Name__c,Product_Name__r.Name,
                Sales_Org_Code__c,Active__c
                FROM SKU__c 
                where (Sales_Org_Code__c='5191'
                AND Division__c =: divisionId
                AND  Active__c = true
                AND  SKU_Description__c != null)
                ORDER BY createdDate ASC];
       
    }   
    public class wrapperForProductSku{
        
        @AuraEnabled
        public String  Id ;
        @AuraEnabled
        public String skuId;
        @AuraEnabled
        public String  Name ;
        @AuraEnabled
        public String  SkuDes ;
        @AuraEnabled
        public String  SkuCode ;
        @AuraEnabled
        public Decimal minPrice;
        @AuraEnabled
        public Decimal unitPrice;
        @AuraEnabled
        public Decimal monthlyIntRate;
        @AuraEnabled
        public Decimal exchangeRate;
    }   
    public class wrapperForSalesDistrict{
        
        @AuraEnabled
        public String Id;
         @AuraEnabled
        public String Id1;
        @AuraEnabled
        public string sdtId;
        @AuraEnabled
        public String Name;
        @AuraEnabled
        public String SDCode;
      
    }   
    public class wrapperForAll {
        
        @AuraEnabled
        public Price_Book__c priceBookList {get;set;}
        @AuraEnabled
        public List<Price_Book_Details__c> priceBookDetailLst {get;set;}
        @AuraEnabled
        public List<Price_Book_Sales_District__c> priceBookSalesDistLst {get;set;}
        @AuraEnabled
        public Integer salesdistCount {get;set;}
        
        public wrapperForAll(){
            this.salesdistCount = 0;
            this.priceBookList = new Price_Book__c();
            this.priceBookDetailLst = new List<Price_Book_Details__c>();
            this.priceBookSalesDistLst = new List<Price_Book_Sales_District__c>();
        }
    }
}