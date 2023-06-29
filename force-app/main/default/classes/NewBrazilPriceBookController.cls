public without sharing class NewBrazilPriceBookController {  
    
    
    public Static Map<String,String> skuMap;  
    public Static Map<String,String> districtMap;  
    //Constructor  
    public NewBrazilPriceBookController(){}  
    
    
    @AuraEnabled  
    public static String getProfileID(){  
        List<Profile> PROFILE = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];  
        String MyProflieName = PROFILE[0].Name;  
        return MyProflieName;  
    }  
     //added by Atish
    @AuraEnabled  
    public static List<ContentDocument> getFiles(string recordId, List<Id> filepricelistIds){        
        Set<Id> recordIds=new Set<Id>{recordId};
        Set<Id> documentIds = new Set<Id>(); 
        System.debug('recordId'+recordId);
                System.debug('filepricelistIds'+filepricelistIds);

        List<ContentDocumentLink> cdl=[SELECT id,LinkedEntityId,ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId IN:recordIds];  
        for(ContentDocumentLink cdLink:cdl){  
            documentIds.add(cdLink.ContentDocumentId);  
        } 
        if(filepricelistIds.size() >=2)
        {
              sendPriceBookFile(filepricelistIds,recordId);
    
        }

        return [SELECT Id,Title,FileType,CreatedDate FROM ContentDocument WHERE id IN: documentIds];  
    } 
     @AuraEnabled  
    public static List<ContentDocument> getUplFiles(string recordsId){        
        
             
        return [SELECT Id,Title,FileType,CreatedDate FROM ContentDocument ORDER BY CreatedDate DESC LIMIT 1];  
    } 
     @AuraEnabled  
    public static Id getUploadItems(){  
        for(Price_Book__c valueprice : [select Id from Price_Book__c where ownerId =: UserInfo.getUserId() order by createdDate   desc Limit 1])
        {
            return valueprice.Id;
        }
        return null;
    } 
    //Added by Atish for fileupload
    @AuraEnabled  
    public static void deleteFiles(string sdocumentId, List<Id> filepricelistIds){ 
        System.debug('sdocumentId'+sdocumentId);
        List<ContentDocumentLink> cdl=[SELECT id,LinkedEntityId,ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId IN:filepricelistIds]; 
         Set<Id> documentIds = new Set<Id>(); 
        for(ContentDocumentLink cdLink:cdl){  
            documentIds.add(cdLink.ContentDocumentId);  
        } 
        delete [SELECT Id,Title,FileType,CreatedDate FROM ContentDocument WHERE id IN: documentIds];  
        delete [SELECT Id,Title,FileType from ContentDocument WHERE id=:sdocumentId];       
    } 

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
                                   //code added by Sagar@Wipro PB-003 for fetching crop cultures
                                   //   commented  by javed  for RITM0463334 23-12-2022* 
   /* @AuraEnabled  
    public static List<Culture__c> getCropCultures() {  
        cultureWrapper
        return [SELECT Id, Name, Culture_Code__c    
                FROM Culture__c  
                where Sales_Org__r.Sales_Org_Code__c ='5191'  
                ORDER BY createdDate ASC];   
        
    }  */
     // strat added by javed(Grazitti) for RITM0463334 23-12-2022*/
      @AuraEnabled  
    public static List<cultureWrapper> getCropCultures() {  
        list<cultureWrapper> wrapList= new list<cultureWrapper>();
      
        for(Culture__c c:[SELECT Id, Name, Culture_Code__c    
        FROM Culture__c  
        where Sales_Org__r.Sales_Org_Code__c ='5191'  
        ORDER BY createdDate ASC]){
            cultureWrapper wrap= new cultureWrapper();
            wrap.Id=c.Id;
            wrap.Name=c.Name;
            wrap.cultureCode=c.Culture_Code__c;
            wrap.check=true;
            wrapList.add(wrap);
        }
        if(wrapList.size()>0){
            return wrapList;
        }else{
            return new list<cultureWrapper>();
        }
        
    }  
// end added by javed(Grazitti) for RITM0463334 23-12-2022*/
     //code added by Sagar@Wipro PB-004 for fetching Custmer Groups
    @AuraEnabled  
    public static List<Account> getCustmerGroups() {  
        
        //return [SELECT Id, Name, Customer_Group_Code__c FROM Customer_Group__c ORDER BY createdDate ASC]; 
        List<Account> accunique = new List<Account>();
        Map<String,Account> mapAcc = new Map<String,Account>();
        
        try{
            List<Account> acc =  [SELECT id,Name,Customer_Group__c FROM Account where Sales_Org__r.Sales_Org_Code__c ='5191' and Customer_Group__c!=null	]; 
            for(Account acc1:acc){
                mapAcc.put(acc1.Customer_Group__c,acc1);//This is map and hence it will always have unique values 
            }
            system.debug('List return'+mapAcc.values());
            accunique=mapAcc.values();
            system.debug('List uni'+accunique.size());
        }
        catch (Exception e) {  
            System.debug('Exception while retrieving'+ e);  
        }
        return accunique;  
        
    }   
     //code added by Sagar@Wipro PB-004 for fetching Custmer Names
      //code added by Sagar@Wipro PB-004 for fetching Custmer Names
    @AuraEnabled  
    public static List<Account> getCustmerNames(string custGrpArray) {
        List<string> ss = new List<string>();
        if(custGrpArray != null){  
            List<wrapperForCustGroup> custgrplist = (List<wrapperForCustGroup>)JSON.deserialize(custGrpArray, List<wrapperForCustGroup>.class);  
            
            for(wrapperForCustGroup custgrplist1:custgrplist){
                ss.add(custgrplist1.SDCode2);
            }
        }
        
        return [SELECT Id, Name, Customer_Group__c,SAP_Code__c,Price_Conversion_Group__c,BillingCity,Brazil_Depot_Code__r.Depot_Code__c  
                FROM Account where 	Customer_Group__c IN:ss
                ORDER BY createdDate ASC];   
        
    }    
    @AuraEnabled  
    public static List<Payment_Term__c> getPaymentTerms() {  
        System.debug('getPaymentTerms call---------->');  
        return [SELECT Id, SalesOrgCode__c, Active__c, Payterms_Desc__c FROM Payment_Term__c where   
                SalesOrgCode__c='5191' AND Active__c=true AND Maturity_Date_Mandatory__c!='Yes' ORDER BY Payterms_Desc__c ASC];  
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
        PriceBookWrapper pb_wrapper = new PriceBookWrapper();  
        return  [SELECT Id, Name ,Division_Code__c  
                 FROM Division__c   
                 where Name LIKE '%Agro Formulation%'  
                 ORDER BY createdDate ASC  
                 LIMIT 1];  
    }      
    @AuraEnabled  
    public static List<ListView> getListViews(){  
        List<ListView> lstview = [SELECT Id, Name   
                                  FROM ListView   
                                  where (Name Like '%All%'  
                                         AND SobjectType = 'Price_Book__c')];  
        // Perform isAccessible() check here  
        return lstview;  
    }  
    
    @AuraEnabled  
    public Static Map<String,String> skuDescriptionMap(){  
        System.debug('skuDescriptionMap called---------->');  
        List<SKU__c> skuList = new List<SKU__c>();  
        Map<String,String> skuDesc = new Map<String,String>();  
        skuList=[SELECT Id, SKU_Description__c, Combination_Key__c, Sales_Org_Code__c FROM SKU__c where Sales_Org_Code__c='5191' AND Active__c=true];  
        if(skuList.size()>0){  
            for(SKU__c sk : skuList){  
                skuDesc.put(sk.Combination_Key__c,sk.SKU_Description__c);  
            }  
        }  
        System.debug('skuDescriptionMap ----------> '+skuDesc);  
        return skuDesc;  
    }  
    //modified if kit pricebook, added kit: in pbname, and setting kit sku in material  
    @AuraEnabled  
    public static String saveNewPriceBook(String price_book, String sku_file, String salesDistArray, String cropCulArray,String custGrpArray, string custNameArray, String paymentTerms,String pbType,list<string> cropCultureId) {  
        System.debug('saveNewPriceBook called---------->');  
        System.debug('sku map ----------> '+ skuMap);  
        System.debug('Dist map ----------> '+ districtMap);  
        System.debug('price_book ----------> '+ price_book);  
        System.debug('salesDistArray ----------> '+ salesDistArray);  
        System.debug('paymentTerms ----------> '+ paymentTerms);  
        System.debug('cropCultureId ----------> '+ cropCultureId);
        loadMapValues();  
        System.debug('sku map after ----------> '+ skuMap);  
        System.debug('Dist map after ----------> '+ districtMap);  
        // PriceBook pb = new PriceBook();  
        Price_Book__c priceBook =new Price_Book__c();  
        List<Price_Book__c> priceBookList = new List<Price_Book__c>();  
        Price_Book_Details__c pbd = new Price_Book_Details__c();  
        List<Price_Book_Details__c> detailsList= new List<Price_Book_Details__c>();  
        List<Price_Book_Sales_District__c> salesDistList = new List<Price_Book_Sales_District__c>();
        List<Price_Book_Crop_Culture__c> cropCulList = new List<Price_Book_Crop_Culture__c>();	//added by Sagar@Wipro for PB-003
        List<Customer_Group_Price_Book__c> custgrpList = new List<Customer_Group_Price_Book__c>();//added by Sagar@Wipro for PB-004  
    List<Customer__c> custNameList = new List<Customer__c>();//added by Sagar@Wipro for PB-004  
        List<Campaign_Payment_Terms__c> paymentTermList = new List<Campaign_Payment_Terms__c>();  
        
        // String pb_id='';  
        String preffix='';  
        String isoCurrency='';  
        String result='';  
        Boolean flag=true;  
        String[] skuArray;   
        try{  
            if(price_book != null){  
                // pb = (Price_Book__c) price_book;  
                PriceBook pb= (PriceBook)JSON.deserialize(price_book, PriceBook.class);  
                
                if(pb.curncy == 'Only BRL'){  
                    preffix='BRL : ';  
                    isoCurrency='BRL';  
                }  
                else if(pb.curncy == 'Only USD'){  
                    preffix='USD : ';  
                    isoCurrency='USD';  
                }  
                if(pb.pb_for_Kit==True){  
                    preffix=system.label.Kit+preffix;  
                    
                }  
                if(pb.curncy == 'BRL and USD'){  
                    if(pb.pb_for_cmpgn == true){  
                        priceBook.Use_Campaign__c = true;  
                        priceBook.Campaign_Type__c = pb.cmpgn_tp;  
                        priceBook.Sales_Order_Block_Date__c = Date.valueof(pb.blk_dt);  
                        priceBook.Interest_Date__c = Date.valueof(pb.intr_dt);     
                    }   
                    else{  
                        priceBook.Use_Campaign__c = false;  
                        }  
          if(pb.pb_for_avec == true){

                        priceBook.AVEC_Price_Book__c=true;
                          //  priceBook.Campaign_Type__c = pb.cmpgn_tp;
                        priceBook.Sales_Order_Block_Date__c = Date.valueof(pb.blk_dt);  

                        priceBook.Interest_Date__c = Date.valueof(pb.intr_dt);

                    }  

                    else{  

                        priceBook.AVEC_Price_Book__c = false;
                        
                    }  
                    if(pb.pb_for_Kit==True){  
                        priceBook.Name = system.label.Kit+'BRL : '+pb.pb_name;  
                        priceBook.Kit_Price_Book__c	=true;	
                    }else{  
                        priceBook.Name = 'BRL : '+pb.pb_name;  
                    }  
                    priceBook.Currency__c = 'Only BRL';//pb.curncy;  
                    priceBook.CurrencyIsoCode = 'BRL';  
                    priceBook.Valid_From__c = Date.valueof(pb.frm_dt);  
                    priceBook.Expiry_Date__c = Date.valueof(pb.exp_dt);
                    priceBook.Last_Month_Of_The_Season__c = Date.valueof(pb.las_mon);// Modified by by Anmol@wipro for US PB-005  
                    priceBook.Interest_Rate_R__c = decimal.valueOf(pb.intr_rt_R);  
                    priceBook.Interest_Rate_U__c = 0;    //decimal.valueOf(pb.intr_rt_U);  
                    priceBook.Division__c = pb.division;  
                    priceBook.isActive__c = true;  
                    // apply discount matrix and usdrate
                    pricebook.Apply_Discount_Matrix__c = pb.apply_discount; //Divya
                    pricebook.Apply_Minimum_Price__c = pb.applyMinPrice; // Priya RITM0237685
                    priceBook.Simulation_Price_Book__c = pb.applySimulation; //Simulation
                    priceBook.Apply_Increase_Decrease_Percentage__c = pb.applyPercentage;
                    if(pb.usdRate != null){
                        pricebook.USD_Rate__c = decimal.valueOf(pb.usdRate); //Divya
                    }
                    priceBook.Status__c = 'Draft';  
                    priceBookList.add(priceBook);  
                    Price_Book__c priceBook2 =new Price_Book__c();  
                    if(pb.pb_for_cmpgn == true){  
                        priceBook2.Use_Campaign__c = true;  
                        priceBook2.Campaign_Type__c = pb.cmpgn_tp;  
                        priceBook2.Sales_Order_Block_Date__c = Date.valueof(pb.blk_dt);  
                        priceBook2.Interest_Date__c = Date.valueof(pb.intr_dt);     
                    }   
                    else{  
                        priceBook2.Use_Campaign__c = false;  
                        }  
                        // added by wipro
          if(pb.pb_for_avec == true){

                        priceBook2.AVEC_Price_Book__c=true;
//priceBook2.Campaign_Type__c = pb.cmpgn_tp;
                      priceBook2.Sales_Order_Block_Date__c = Date.valueof(pb.blk_dt);  

                        priceBook2.Interest_Date__c = Date.valueof(pb.intr_dt);

                    }  

                    else{  

                        priceBook2.AVEC_Price_Book__c = false;
                    }  
                    if(pb.pb_for_Kit==True){  
                        priceBook2.Name = system.label.Kit+'USD : '+pb.pb_name;  
                        priceBook2.Kit_Price_Book__c	=true;	
                    }else{  
                        priceBook2.Name = 'USD : '+pb.pb_name;  
                    }  
                    priceBook2.Currency__c = 'Only USD';//pb.curncy;  
                    priceBook2.CurrencyIsoCode = 'USD';  
                    priceBook2.Valid_From__c = Date.valueof(pb.frm_dt);  
                    priceBook2.Expiry_Date__c = Date.valueof(pb.exp_dt);  
                    priceBook2.Interest_Rate_R__c = 0;       //decimal.valueOf(pb.intr_rt_R);  
                    priceBook2.Interest_Rate_U__c = decimal.valueOf(pb.intr_rt_U);  
                    priceBook2.Division__c = pb.division;  
                    priceBook2.isActive__c = true;  
                    // apply discount matrix and usdrate
                    priceBook2.Apply_Discount_Matrix__c = pb.apply_discount; //Divya
                    priceBook2.Apply_Minimum_Price__c = pb.applyMinPrice; // Priya RITM0237685
                    priceBook2.Simulation_Price_Book__c = pb.applySimulation; //Simulation
                    priceBook.Apply_Increase_Decrease_Percentage__c = pb.applyPercentage;
                    if(pb.usdRate != null)
                    {
                        priceBook2.USD_Rate__c = decimal.valueOf(pb.usdRate);} //Divya  
                    
                    priceBook2.Status__c = 'Draft';  
                    priceBookList.add(priceBook2);  
                }  
                else{  
                    if(pb.pb_for_cmpgn == true){  
                        priceBook.Use_Campaign__c = true;  
                        priceBook.Campaign_Type__c = pb.cmpgn_tp;  
                        priceBook.Sales_Order_Block_Date__c = Date.valueof(pb.blk_dt);  
                        priceBook.Interest_Date__c = Date.valueof(pb.intr_dt);     
                    }   
                    else{  
                        priceBook.Use_Campaign__c = false;  
                        
                    }  
                    if(pb.pb_for_avec == true){ // added by wipro

                        priceBook.AVEC_Price_Book__c=true;
                      //  priceBook.Campaign_Type__c = pb.cmpgn_tp;

                        priceBook.Sales_Order_Block_Date__c = Date.valueof(pb.blk_dt);  

                        priceBook.Interest_Date__c = Date.valueof(pb.intr_dt);

                    }  

                    else{ 
                        priceBook.AVEC_Price_Book__c = false;
                    }
                    
                    priceBook.Name = preffix+pb.pb_name;  
                    if(pb.pb_for_Kit==True){  
                        priceBook.Kit_Price_Book__c	=true;	
                    }  
                    priceBook.Currency__c = pb.curncy;  
                    priceBook.CurrencyIsoCode = isoCurrency;  
                    priceBook.Valid_From__c = Date.valueof(pb.frm_dt);  
                    priceBook.Expiry_Date__c = Date.valueof(pb.exp_dt);  
                    priceBook.Last_Month_Of_The_Season__c = Date.valueof(pb.las_mon);// Modified by by Anmol@wipro for US PB-005
                    priceBook.Interest_Rate_R__c = decimal.valueOf(pb.intr_rt_R);  
                    priceBook.Interest_Rate_U__c = decimal.valueOf(pb.intr_rt_U);  
                    priceBook.Division__c = pb.division;  
                    priceBook.isActive__c = true;  
                    // apply discount matrix and usdrate
                    priceBook.Apply_Discount_Matrix__c = pb.apply_discount; //Divya
                    priceBook.Apply_Minimum_Price__c = pb.applyMinPrice; // Priya RITM0237685
                    priceBook.Simulation_Price_Book__c = pb.applySimulation; //Simulation
                    priceBook.Apply_Increase_Decrease_Percentage__c = pb.applyPercentage;
                    
                    if(pb.usdRate != null){
                        priceBook.USD_Rate__c = decimal.valueOf(pb.usdRate);} //Divya  
                    priceBook.Status__c = 'Draft';  
                    priceBookList.add(priceBook);  
                }  
                
                result='true';  
                System.debug('priceBookList size ----> ' +priceBookList.size());  
                System.debug('priceBookList ----> ' +priceBookList);  
                if(priceBookList.size()>0){  
                    insert priceBookList;  
                }  
            }  
            if(priceBookList.size()>0){  
                if(sku_file != null){  
                    List<ProductSku> skuList = (List<ProductSku>)JSON.deserialize(sku_file, List<ProductSku>.class) ;  
                    for(Price_Book__c priceBook1 : priceBookList){  
                        skuArray = new String[]{};  
                            if(skuList.size()>0){  
                                for(ProductSku sku : skuList){  
                                    flag=true;  
                                    Price_Book_Details__c p_detail = new Price_Book_Details__c();  
                                    p_detail.Price_Book__c = priceBook1.id;  
                                    p_detail.CurrencyIsoCode = priceBook1.CurrencyIsoCode;  
                                    sku.min_prc=sku.min_prc.replace(',','.');  
                                    sku.min_prc_u=sku.min_prc_u.replace(',','.');  
                                    sku.unt_prc=sku.unt_prc.replace(',','.');  
                                    sku.unt_prc_u=sku.unt_prc_u.replace(',','.');  
                                    sku.fsp=sku.fsp.replace(',','.');  
                                    sku.fsp_u=sku.fsp_u.replace(',','.');  
                                    sku.sellOutPrice=sku.sellOutPrice.replace(',','.');	
                                    sku.sellOutPriceU=sku.sellOutPriceU.replace(',','.');
                                       
                                    p_detail.Minimum_Price_R__c = decimal.valueOf(sku.min_prc);  
                                    //added by krishanu
                                    p_detail.Sellout_Price_BRL__c = decimal.valueOf(sku.sellOutPrice);
                                    p_detail.Sellout_Price_USD__c = decimal.valueOf(sku.sellOutPriceU);
                                    p_detail.GM__c = sku.GM;
                                    p_detail.GM_USD__c = sku.GMU;		
                                    p_detail.Sellout_Factor__c = sku.SelloutFactor;	
                                    p_detail.Sellout_Factor_USD__c = sku.SelloutFactorU;		
                                    p_detail.Type__c = sku.selloutType;			
                                    p_detail.Type_USD__c = sku.selloutTypeU;	
                                    p_detail.MinValue_Factor__c = sku.MinPriceFactor;	
                                    p_detail.Minimum_Value_Factor_USD__c = sku.MinPriceFactorU;	
                                    p_detail.Unit_Price_R__c = decimal.valueOf(sku.unt_prc);  
                                    p_detail.Future_Sales_Price_R__c = decimal.valueOf(sku.fsp);  
                                    p_detail.Minimum_Price_U__c = decimal.valueOf(sku.min_prc_u);  
                                    p_detail.Unit_Price_U__c = decimal.valueOf(sku.unt_prc_u);  
                                    p_detail.Future_Sales_Price_U__c = decimal.valueOf(sku.fsp_u);  
                                    String combKey='';  
                                    System.debug('sku code ----> ' +sku.sku_code);  
                                    System.debug('sku length ----> ' +sku.sku_code.trim().length());  
                                    if(sku.sku_code.trim().length() == 6){  
                                        combKey='5191000000000000'+sku.sku_code;   // if length is 6 then added 12 zeros.   
                                    }  
                                    else if(sku.sku_code.trim().length() == 7){  
                                        combKey='519100000000000'+sku.sku_code;    // if length is 7 then added 11 zeros.         
                                    }  
                                    else {  
                                        combKey='5191'+sku.sku_code;    // if length is 18 then added sales org code only.         
                                    }  
                                    System.debug('SKU id---- '+ skuMap.get(combKey));  
                                    if(skuMap.containsKey(combKey)){  
                                        
                                        System.debug('SKU code---- '+ sku.sku_code);  
                                        
                                        p_detail.SKU__c = skuMap.get(combKey);  
                                    }  
                                    else{  
                                        flag=false;  
                                    }  
                                    PriceBook pb= (PriceBook)JSON.deserialize(price_book, PriceBook.class);  
                                    if(pb.pb_for_kit==true){  
                                        
                                        String combKeyKit='';  
                                        if(sku.kit_prod.trim().length() == 6){  
                                            combKeyKit='5191000000000000'+sku.kit_prod;   // if length is 6 then added 12 zeros.   
                                        }  
                                        else if(sku.kit_prod.trim().length() == 7){  
                                            combKeyKit='519100000000000'+sku.kit_prod;    // if length is 7 then added 11 zeros.         
                                        }  
                                        else {  
                                            combKeyKit='5191'+sku.kit_prod;    // if length is 18 then added sales org code only.         
                                        }  
                                        //System.debug('SKU id---- '+ skuMap.get(combKey));  
                                        if(skuMap.containsKey(combKeyKit)){  
                                            
                                            System.debug('SKU code---- '+ sku.kit_prod);  
                                            
                                            p_detail.Kit_SKU__c = skuMap.get(combKeyKit);  
                                        }  
                                        else{  
                                            flag=false;  
                                        }  
                                    }  
                                    /*  if(districtMap.containsKey(sku.cn)){  

p_detail.Sales_District1__c = districtMap.get(sku.cn);  
}  
else{  
flag=false;  
}*/  
                                    if(flag){  
                                        detailsList.add(p_detail);  
                                    }  
                                    else{  
                                        if(pb.pb_for_kit==true){  
                                            skuArray.add(sku.kit_prod);  
                                        }  
                                        else{  
                                            skuArray.add(sku.sku_code);  
                                        }  
                                    }  
                                }  
                            }  
                    }  
                }  
                if(priceBookList.size()>0){  
                    if(salesDistArray != null){  
                        List<wrapperForSalesDistrict> salesList = (List<wrapperForSalesDistrict>)JSON.deserialize(salesDistArray, List<wrapperForSalesDistrict>.class);  
                        for(Price_Book__c priceBook2 : priceBookList){  
                            if(salesList.size()>0){  
                                
                                System.debug('salesList-->'+salesList);  
                                for(wrapperForSalesDistrict slds : salesList){  
                                    Price_Book_Sales_District__c obj = new Price_Book_Sales_District__c();  
                                    obj.Price_Book__c = priceBook2.id;  
                                    obj.Sales_District1__c = slds.sdtId;  
                                    
                                    salesDistList.add(obj);  
                                }  
                            }  
                        }    
                    }  
                }  
                //added by Sagar@Wipro for PB-003
                list<Culture__c> culList= [select id,name from Culture__c where id in:cropCultureId];
                if(priceBookList.size()>0){  
                    if(salesDistArray != null){  
                  
                        //List<wrapperForCropCul> salesList1 = (List<wrapperForCropCul>)JSON.deserialize(cropCulArray, List<wrapperForCropCul>.class);  
                        for(Price_Book__c priceBook2 : priceBookList){ 

                           /* if(salesList1.size()>0){  
                                
                                System.debug('salesList-->'+salesList1);  
                                for(wrapperForCropCul slds : salesList1){  
                                    Price_Book_Crop_Culture__c obj1 = new Price_Book_Crop_Culture__c();  
                                    obj1.Price_Book_Brazil__c = priceBook2.id;  
                                    obj1.Crop_Culture1__c = slds.sdtId1;  
                                    //obj1.Culture_Desc__c=slds.Name1;
                                    //obj1.Culture_Code__c=slds.SDCode1;
                                    cropCulList.add(obj1);  
                                }  
                            }  */
                            /* start code added by javed(Grazitti) for RITM0463334 23-12-2022*/
                            if(culList.size()>0){
                                for(Culture__c slds : culList){  
                                Price_Book_Crop_Culture__c obj1 = new Price_Book_Crop_Culture__c();  
                                obj1.Price_Book_Brazil__c = priceBook2.id;  
                                obj1.Crop_Culture1__c = slds.Id;  
                                //obj1.Culture_Desc__c=slds.Name1;
                                //obj1.Culture_Code__c=slds.SDCode1;
                                cropCulList.add(obj1); 
                                }
                            }
                              /* end code added by javed(Grazitti) for RITM0463334 23-12-2022*/
                        }    
                    }  
                }  
              
                //added by Sagar@Wipro for PB-004
                if(priceBookList.size()>0){  
                    if(custGrpArray != null){  
                        List<wrapperForCustGroup> salesList2 = (List<wrapperForCustGroup>)JSON.deserialize(custGrpArray, List<wrapperForCustGroup>.class);  
                        for(Price_Book__c priceBook2 : priceBookList){  
                            if(salesList2.size()>0){  
                                
                                System.debug('salesList-->'+salesList2);  
                                for(wrapperForCustGroup slds : salesList2){  
                                    Customer_Group_Price_Book__c obj1 = new Customer_Group_Price_Book__c();  
                                    obj1.Price_Book_Brazil__c = priceBook2.id;  
                                    //obj1.Customer_Group__c = slds.sdtId2;  
                                    obj1.Customer_Group_Code__c = slds.SDCode2;  
                                    custgrpList.add(obj1);  
                                }  
                            }  
                        }    
                    }  
                }  
                //added by Sagar@Wipro for PB-004
                 if(priceBookList.size()>0){  
                    if(custNameArray != null){  
                        List<wrapperForCustName> salesList3 = (List<wrapperForCustName>)JSON.deserialize(custNameArray, List<wrapperForCustName>.class);  
                        for(Price_Book__c priceBook2 : priceBookList){  
                            if(salesList3.size()>0){  
                                
                                System.debug('salesList-->'+salesList3);  
                                for(wrapperForCustName slds : salesList3){  
                                    Customer__c obj1 = new Customer__c();  
                                    obj1.Price_Book_Brazil__c = priceBook2.id;  
                                    obj1.Account__c = slds.Id;  
                                    custNameList.add(obj1);  
                                }  
                            }  
                        }    
                    }  
                }
                if(priceBookList.size()>0){  
                    if(paymentTerms != null){  
                        List<PaymentTerms> payList = (List<PaymentTerms>)JSON.deserialize(paymentTerms, List<PaymentTerms>.class);  
                        for(Price_Book__c priceBook3 : priceBookList){  
                            if(payList.size()>0){  
                                System.debug('salesList-->'+payList);  
                                for(PaymentTerms payTm : payList){  
                                    Campaign_Payment_Terms__c obj = new Campaign_Payment_Terms__c();  
                                    obj.Price_Book_Brazil__c = priceBook3.id;  
                                    
                                    if(payTm.pt_type=='day'){  
                                        obj.Payment_Term__c = payTm.pt_id;  
                                    }  
                                    else{  
                                        obj.Payment_Term_in_Date__c = Date.valueof(payTm.pt_name);  
                                    }  
                                    paymentTermList.add(obj);  
                                }  
                            }  
                        }  
                    }  
                }  
            }  
            System.debug('SKU details List size---- '+ detailsList.size());  
            System.debug('SKU details List ---- '+ detailsList);  
            if(detailsList.size()>0){  
                insert detailsList;  
            }  
            System.debug('salesDistList List size---- '+ salesDistList.size());  
            System.debug('salesDistList ---- '+ salesDistList);  
            if(salesDistList.size()>0){  
                insert salesDistList;  
            }  
            //code added by Sagar@Wipro for PB-003 & PB-004 Start--
            if(cropCulList.size()>0){  
                insert cropCulList;  
            }
            if(custgrpList.size()>0){  
                insert custgrpList;  
            }
            if(custNameList.size()>0){  
                insert custNameList;  
            }
             //code added by Sagar@Wipro for PB-003 & PB-004 End--
            System.debug('paymentTermList  size---- '+ paymentTermList.size());  
            System.debug('paymentTermList ---- '+ paymentTermList);  
            if(paymentTermList.size()>0){  
                insert paymentTermList;  
            }   
            if(skuArray.size()>0){  
                result = JSON.serialize(skuArray);  
            }     
        } catch (Exception e) {  
            System.debug('Exception while Adding Price Book'+ e);  
            result='false';  
            return result;  
        }  
        return result;  
        
    }  
    //modified if kit pricebook, added kit related codes in wrapper  
    @AuraEnabled  
    public static PriceBookWrapper editNewPriceBook(String price_bookId) {  
        System.debug('editNewPriceBook called---------->');  
        System.debug('price_bookId ----------> '+ price_bookId);  
        
        PriceBookWrapper pb_wrapper = new PriceBookWrapper();  
        try {  
            if(price_bookId.length()>0){  
                Price_Book__c pb = new Price_Book__c();  
                pb =[SELECT Id, Name, Currency__c, Last_Month_Of_The_Season__c, Division__c,Division__r.Name, Expiry_Date__c, Valid_From__c, isActive__c,   
                     Interest_Date__c, Interest_Rate_R__c, Interest_Rate_U__c, Sales_Order_Block_Date__c, Use_Campaign__c,   
                     Status__c, Campaign_Type__c,Kit_Price_Book__c,Apply_Discount_Matrix__c,USD_Rate__c,Apply_Minimum_Price__c, Simulation_Price_Book__c,Apply_Increase_Decrease_Percentage__c,AVEC_Price_Book__c  FROM Price_Book__c where id=:price_bookId];  
                
                // Date conversion....to string  
                DateTime val_dt = pb.Valid_From__c;  
                DateTime exp_dt = pb.Expiry_Date__c;  
                system.debug('exp_dt>>--->'+exp_dt);  
                System.debug('...--Expiry Date Nik....---> '+ exp_dt.format('dd MMM, yyyy'));  
                
                String str=pb.Name.replace('USD : ','');  
                str=str.replace('BRL : ','');  
                str=str.replace('Kit :','');  
                str=str.trim();  
                pb_wrapper.pc_book.pcb_id = pb.Id;  
                pb_wrapper.pc_book.pb_for_cmpgn = pb.Use_Campaign__c;  
                pb_wrapper.pc_book.pb_for_avec=pb.AVEC_Price_Book__c;//added by wipro
                pb_wrapper.pc_book.cmpgn_tp = pb.Campaign_Type__c;  
                pb_wrapper.pc_book.pb_name = str;//pb.Name;  
                pb_wrapper.pc_book.curncy = pb.Currency__c;  
                pb_wrapper.pc_book.frm_dt = string.valueOf(pb.Valid_From__c);//val_dt.format('dd MMM, yyyy');  
                pb_wrapper.pc_book.exp_dt = string.valueOf(pb.Expiry_Date__c);//exp_dt.format('dd MMM, yyyy');  
                pb_wrapper.pc_book.las_mon = string.valueOf(pb.Last_Month_Of_The_Season__c);// Modified by by Anmol@wipro for US PB-005  
                pb_wrapper.pc_book.intr_rt_R = String.valueOf(pb.Interest_Rate_R__c);  
                pb_wrapper.pc_book.intr_rt_R = pb_wrapper.pc_book.intr_rt_R.replace('.',',');  
                pb_wrapper.pc_book.intr_rt_U = String.valueOf(pb.Interest_Rate_U__c);  
                pb_wrapper.pc_book.intr_rt_U = pb_wrapper.pc_book.intr_rt_U.replace('.',',');  
                pb_wrapper.pc_book.division = pb.Division__c;  
                pb_wrapper.pc_book.division_nm = pb.Division__r.Name;  
                pb_wrapper.pc_book.isActive = pb.isActive__c;  
                pb_wrapper.pc_book.status = pb.Status__c;  
                // apply discount matrix and usdrate
                pb_wrapper.pc_book.apply_discount = pb.Apply_Discount_Matrix__c;//Divya
                pb_wrapper.pc_book.applyMinPrice = pb.Apply_Minimum_Price__c;  // Priya RITM0237685
                pb_wrapper.pc_book.applySimulation = pb.Simulation_Price_Book__c; //Simulation
                pb_wrapper.pc_book.applyPercentage = pb.Apply_Increase_Decrease_Percentage__c;
                if (pb.USD_Rate__c != null){
                    pb_wrapper.pc_book.usdRate = String.valueOf(pb.USD_Rate__c); //Divya
                    pb_wrapper.pc_book.usdRate = pb_wrapper.pc_book.usdRate.replace('.',','); } //Divya
                
                //added for kit  
                pb_wrapper.pc_book.pb_for_Kit = pb.Kit_Price_Book__c;  
                if(pb.Kit_Price_Book__c==true){  
                    pb_wrapper.pc_book.pbType='Price Book For Kit';  
                }  
                else if(pb.Use_Campaign__c==true){  
                    
                    pb_wrapper.pc_book.pbType='Price Book For Campaign';  
                }  
                else if(pb.AVEC_Price_Book__c==true){  
                 pb_wrapper.pc_book.pbType='AVEC Price Book';    
                }
                else{  
                    pb_wrapper.pc_book.pbType='Normal pricebook';  
                }  
                if(pb.Sales_Order_Block_Date__c !=null){  
                    DateTime blk_dt = pb.Sales_Order_Block_Date__c;  
                    pb_wrapper.pc_book.blk_dt = string.valueOf(pb.Sales_Order_Block_Date__c);//blk_dt.format('dd MMM, yyyy');  
                }  
                if(pb.Interest_Date__c != null){  
                    DateTime inr_dt = pb.Interest_Date__c;  
                    pb_wrapper.pc_book.intr_dt = string.valueOf(pb.Interest_Date__c);//inr_dt.format('dd MMM, yyyy');  
                }  
                
                System.debug('price book ----------> '+ pb_wrapper.pc_book);  
                
                List<Price_Book_Details__c> pbList = new List<Price_Book_Details__c>();  
                //Added fields in query by Harshit@Wipro
                pbList=[SELECT Id, Name, Price_Book__c, SKU__c, SKU__r.SKU_Code__c, SKU__r.SKU_Description__c,Type__c,Type_USD__c,GM__c,Sellout_Price_BRL__c,Sellout_Factor__c,MinValue_Factor__c,GM_USD__c,Sellout_Price_USD__c,Sellout_Factor_USD__c,Minimum_Value_Factor_USD__c, 	
                        Minimum_Price_R__c, Minimum_Price_U__c, Unit_Price_R__c, Unit_Price_U__c, Future_Sales_Price_R__c, Future_Sales_Price_U__c ,Kit_SKU__c,Kit_SKU__r.sku_code__c  
                        FROM Price_Book_Details__c where Price_Book__c=:price_bookId];   //Sales_District1__c, Sales_District1__r.RegionCode__c
                System.debug('price book List----------> '+ pbList);  
                if(pbList.size()>0){  
                    for(Price_Book_Details__c pbd : pbList){  
                        ProductSku sku= new ProductSku();  
                        sku.pbd_id=pbd.Id;  
                        //   sku.cn = pbd.Sales_District1__r.RegionCode__c;  
                        if(pbd.SKU__r.SKU_Description__c!=null){
                            sku.mt_code = pbd.SKU__r.SKU_Description__c.replace(',','').replace('\'','');
                        }else{
                            sku.mt_code = '';
                        }
                        sku.sku_code= pbd.SKU__r.SKU_Code__c;  
                        sku.min_prc= String.valueOf(pbd.Minimum_Price_R__c).replace('.',',');  
                        sku.min_prc_u= String.valueOf(pbd.Minimum_Price_U__c).replace('.',',');  
                        sku.unt_prc= String.valueOf(pbd.Unit_Price_R__c).replace('.',',');  
                        sku.unt_prc_u= String.valueOf(pbd.Unit_Price_U__c).replace('.',',');  
                        sku.fsp= String.valueOf(pbd.Future_Sales_Price_R__c).replace('.',',');  
                        sku.fsp_u= String.valueOf(pbd.Future_Sales_Price_U__c).replace('.',',');  
                          //Below 10 lines added by Harshit@Wipro START
                        //Added If condition by Krishanu@Wipro
                        if(pbd.Sellout_Price_BRL__c!=null){
                            sku.sellOutPrice = String.valueOf(pbd.Sellout_Price_BRL__c).replace('.',',');
                        }else{
                            sku.sellOutPrice = '0';
                        }
                        if(pbd.Sellout_Price_USD__c!=null){
                            sku.sellOutPriceU = String.valueOf(pbd.Sellout_Price_USD__c).replace('.',',');
                        }else{
                            sku.sellOutPriceU = '0';
                        }
                        sku.GM=pbd.GM__c;
                        sku.GMU = pbd.GM_USD__c;
                       	sku.selloutType = pbd.Type__c;
                        sku.selloutTypeU = pbd.Type_USD__c;
                       
                        sku.SelloutFactor = pbd.Sellout_Factor__c;
                        sku.SelloutFactorU = pbd.Sellout_Factor_USD__c;
                        sku.MinPriceFactor = pbd.MinValue_Factor__c;
                        sku.MinPriceFactorU = pbd.Minimum_Value_Factor_USD__c;
                        //END
                        if(pbd.Kit_SKU__c!=null){  
                            sku.kit_prod=pbd.Kit_SKU__r.SKU_Code__c;  
                            sku.kit_comp=pbd.Kit_SKU__r.SKU_Code__c+'#'+pbd.SKU__r.SKU_Code__c;  
                        }  
                        else{  
                            sku.kit_prod='';  
                            sku.kit_comp='';  
                        }  
                        pb_wrapper.materialList.add(sku);  
                    }  
                }  
                List<Price_Book_Sales_District__c> salesList = new List<Price_Book_Sales_District__c>();  
                salesList=[SELECT id,Name,Price_Book__c,Sales_District1__c,Sales_District1__r.Name,Sales_District_Name1__c,  
                           Sales_District_Code__c FROM Price_Book_Sales_District__c where Price_Book__c=:price_bookId ];  
                System.debug('salesList  lsit--- '+salesList);  
                if(salesList.size()>0){  
                    for(Price_Book_Sales_District__c pbsd : salesList){  
                        wrapperForSalesDistrict wsd = new wrapperForSalesDistrict();  
                        wsd.Id=pbsd.Id;  
                        wsd.sdtId=pbsd.Sales_District1__c;  
                        wsd.Name=pbsd.Sales_District_Name1__c;  
                        wsd.SDCode=pbsd.Sales_District_Code__c;  
                        pb_wrapper.salesDistricts.add(wsd);  
                    }  
                }
                
                //code added by Sagar@Wipro
                list<Price_Book_Crop_Culture__c> PBCC = [select id, Crop_Culture_Code__c,Crop_Culture1__c,  
                                                           Crop_Culture_Name__c ,Price_Book_Brazil__c  
                                                           from Price_Book_Crop_Culture__c   
                                                           where Price_Book_Brazil__c = :price_bookId];
                
                System.debug('salesList  lsit--- '+salesList);  
                if(salesList.size()>0){  
                    for(Price_Book_Crop_Culture__c PBCC1 : PBCC){  
                        wrapperForCropCul wsd1 = new wrapperForCropCul();  
                        wsd1.Id=PBCC1.Id;  
                        wsd1.sdtId1=PBCC1.Crop_Culture1__c;
                        wsd1.Name1=PBCC1.Crop_Culture_Name__c;  
                        wsd1.SDCode1=PBCC1.Crop_Culture_Code__c;  
                        pb_wrapper.cropculs.add(wsd1);  
                    }  
                }
                
                
                list<Customer_Group_Price_Book__c> PBCG = [select id,Name,Customer_Group_Code__c,Price_Book_Brazil__c  
                                                           from Customer_Group_Price_Book__c   
                                                           where Price_Book_Brazil__c = :price_bookId];
                
                System.debug('salesList  lsit--- '+salesList);  
                if(salesList.size()>0){  
                    for(Customer_Group_Price_Book__c PBCG1 : PBCG){  
                        wrapperForCustGroup wsd2 = new wrapperForCustGroup();  
                        wsd2.Id2=PBCG1.Id;  
                        wsd2.sdtId2=PBCG1.Id;
                        wsd2.Name2=PBCG1.Name;  
                        wsd2.SDCode2=PBCG1.Customer_Group_Code__c;  
                        pb_wrapper.custgrps.add(wsd2);  
                    }  
                }
                //wrapperForCustName
                list<Customer__c> PBCN = [select id,Name,Account__c, Account__r.Name,Price_Book_Brazil__c,Account__r.Customer_Group__c  
                                                           from Customer__c   
                                                           where Price_Book_Brazil__c = :price_bookId];
                
                System.debug('salesList  lsit--- '+salesList);  
                if(salesList.size()>0){  
                    for(Customer__c PBCN1 : PBCN){  
                        wrapperForCustName wsd3 = new wrapperForCustName();  
                        wsd3.Id=PBCN1.Account__c;  
                        //wsd3.sdtId1=PBCN1.Id;
                        wsd3.Name=PBCN1.Account__r.Name;
                        wsd3.PriceConversionGroup=PBCN1.Account__r.Customer_Group__c;  
                        pb_wrapper.custnames.add(wsd3);  
                    }  
                }
                
                
                
                List<ProcessInstanceStep> pisList =new List<ProcessInstanceStep>();  
                pisList=[SELECT Id, ProcessInstanceId, StepStatus, OriginalActorId, ActorId, Actor.email,Actor.Name,   
                         Comments, ProcessInstance.LastModifiedDate, SystemModstamp FROM ProcessInstanceStep   
                         where ProcessInstance.TargetObjectId=:price_bookId order by SystemModstamp  desc];  
                System.debug('Approval  lsit--- '+pisList);  
                if(!pisList.isEmpty()){  
                    for(ProcessInstanceStep pis : pisList){  
                        ApprovalHistory ah = new ApprovalHistory();  
                        DateTime ap_dt = pis.SystemModstamp;  
                        ah.date_tm = ap_dt.format('dd MMM, yyyy');  
                        ah.user = pis.Actor.email;  
                        if(pis.StepStatus == 'Started'){  
                            ah.cur_status = 'Submitted';   
                        }  
                        else{  
                            ah.cur_status = pis.StepStatus;  
                        }  
                        ah.prev_status = '';  
                        ah.comment = pis.Comments;  
                        ah.name = pis.Actor.Name;  
                        pb_wrapper.approvarList.add(ah);  
                    }  
                }   
                
                List<Campaign_Payment_Terms__c> payList = new List<Campaign_Payment_Terms__c>();  
                payList=[select id, Price_Book_Brazil__c, Payment_Term__c,Payment_Term__r.Payterms_Desc__c,   
                         Payment_Term_in_Date__c from Campaign_Payment_Terms__c where Price_Book_Brazil__c=:price_bookId];  
                System.debug('Payment term lsit--- '+payList);  
                if(!payList.isEmpty()){  
                    for(Campaign_Payment_Terms__c payTm : payList){  
                        PaymentTerms pt = new PaymentTerms();  
                        
                        
                        if(payTm.Payment_Term_in_Date__c != null){  
                            pt.id=payTm.id;  
                            pt.pBook=payTm.Price_Book_Brazil__c;    
                            pt.pt_name = String.valueof(payTm.Payment_Term_in_Date__c);  
                            pt.pt_type ='date';   
                        }  
                        if(payTm.Payment_Term__c != null){  
                            // DateTime ap_dt = payTm.Payment_Term_in_Date__c;  
                            // pt.pt_name = ap_dt.format('dd MMM, yyyy');    
                            pt.id=payTm.id;  
                            pt.pBook=payTm.Price_Book_Brazil__c;  
                            pt.pt_id=payTm.Payment_Term__c;  
                            pt.pt_name=payTm.Payment_Term__r.Payterms_Desc__c;  
                            pt.pt_type='day';   
                        }  
                        
                        pb_wrapper.paymentTerms.add(pt);   
                    }  
                }  
                
            }  
            else{  
                pb_wrapper.materialList=null;  
                pb_wrapper.pc_book=null;  
                pb_wrapper.approvarList=null;  
                pb_wrapper.salesDistricts=null;  
                pb_wrapper.paymentTerms=null;  
            }  
        } catch (Exception e) {  
            System.debug('Exception while retrieving Price Book (edit Method) '+ e);  
            pb_wrapper.materialList=null;  
            pb_wrapper.pc_book=null;  
            pb_wrapper.approvarList=null;  
            pb_wrapper.salesDistricts=null;  
            pb_wrapper.paymentTerms=null;  
            return pb_wrapper;  
        }  
        
        return pb_wrapper;  
    }  
    
    //modified if kit pricebook,updating kit sku and pricebook name   
    @AuraEnabled  
    public static String updateNewPriceBook(String price_book, String sku_file, String sku_fileToDelete, String paymentTerms, String paymentTermsToDelete, String salesDistArray, String cropCulArray,String custGrpArray, string custNameArray,list<string> cropCultureId) {  
        System.debug('updateNewPriceBook called---------->');  
        System.debug('sku map ----------> '+ skuMap);  
        System.debug('Dist map ----------> '+ districtMap);  
        System.debug('price_book ----------> '+ price_book);  
        System.debug('paymentTerms ----------> '+ paymentTerms);  
        System.debug('paymentTermsToDelete ----------> '+ paymentTermsToDelete);  
        System.debug('salesDistArray ----------> '+ salesDistArray);  
        System.debug('cropCulArray ----------> '+ cropCulArray);
        System.debug('custGrpArray ----------> '+ custGrpArray);
        System.debug('custNameArray ----------> '+ custNameArray);
        System.debug('cropCultureId ----------> '+ cropCultureId);
        loadMapValues();  
        System.debug('sku map after ----------> '+ skuMap);  
        System.debug('Dist map after ----------> '+ districtMap);  
        // PriceBook pb = new PriceBook();  
        Price_Book__c priceBook =new Price_Book__c();  
        Price_Book_Details__c pbd = new Price_Book_Details__c();  
        List<Price_Book_Details__c> detailsList= new List<Price_Book_Details__c>();  
        List<Price_Book_Details__c> detailsListDelete= new List<Price_Book_Details__c>();  
        List<Campaign_Payment_Terms__c> paymentTermList = new List<Campaign_Payment_Terms__c>();  
        List<Campaign_Payment_Terms__c> paymentTermListDelete = new List<Campaign_Payment_Terms__c>();  
        List<Price_Book_Sales_District__c> salesDistList = new List<Price_Book_Sales_District__c>();
        List<Price_Book_Crop_Culture__c> cropCulList = new List<Price_Book_Crop_Culture__c>();	//added by Sagar@Wipro for PB-003
        List<Customer_Group_Price_Book__c> custgrpList = new List<Customer_Group_Price_Book__c>();//added by Sagar@Wipro for PB-004  
    List<Customer__c> custNameList = new List<Customer__c>();//added by Sagar@Wipro for PB-004  
        
        String pb_id='';  
        String preffix='';  
        String result='';  
        Boolean flag=true;  
        try {  
            
            if(price_book != null){  
                // pb = (Price_Book__c) price_book;  
                PriceBook pb= (PriceBook)JSON.deserialize(price_book, PriceBook.class);  
                
                if(pb.curncy == 'Only BRL'){  
                    preffix='BRL : ';  
                    
                }  
                else if(pb.curncy == 'Only USD'){  
                    preffix='USD : ';  
                    
                }  
                if(pb.pb_for_Kit==True){  
                    preffix=system.label.Kit+preffix;  
                    
                }  
                if(pb.pb_for_cmpgn == true){  
                    priceBook.Use_Campaign__c = true;  
                    priceBook.Campaign_Type__c = pb.cmpgn_tp;  
                    priceBook.Sales_Order_Block_Date__c = Date.valueof(pb.blk_dt);  
                    priceBook.Interest_Date__c = Date.valueof(pb.intr_dt);     
                }   
                else{  
                    priceBook.Use_Campaign__c = false;  
                    
                }
                if(pb.pb_for_avec == true){//added by wipro

                        priceBook.AVEC_Price_Book__c=true;
                   // priceBook.Campaign_Type__c = pb.cmpgn_tp;

                            // commented below code by Ankit, since we are not checking null condition, invalid date error was coming --> INCTASK0922496
                            //   priceBook.Sales_Order_Block_Date__c = Date.valueof(pb.blk_dt);
                            //   priceBook.Interest_Date__c = Date.valueof(pb.intr_dt);
                            //    written this both if condition to check null condition --> (Ankit --- INCTASK0922496)
                           if(String.isNotBlank(pb.blk_dt)) {
                               priceBook.Sales_Order_Block_Date__c = Date.valueof(pb.blk_dt);  
                           }
                           if(String.isNotBlank(pb.intr_dt)) {
                               priceBook.Interest_Date__c = Date.valueof(pb.intr_dt);
                           }
                    }  

                    else{  

                        priceBook.AVEC_Price_Book__c = false;

                    }  
                
                priceBook.Id=pb.pcb_id;  
                priceBook.Name = preffix+pb.pb_name;  
                priceBook.Currency__c = pb.curncy;  
                priceBook.Valid_From__c = Date.valueof(pb.frm_dt);  
                priceBook.Expiry_Date__c = Date.valueof(pb.exp_dt);  
                priceBook.Interest_Rate_R__c = decimal.valueOf(pb.intr_rt_R);  
                priceBook.Interest_Rate_U__c = decimal.valueOf(pb.intr_rt_U);  
                priceBook.Division__c = pb.division;  
                priceBook.Status__c = 'Draft';
                priceBook.Last_Month_Of_The_Season__c = Date.valueof(pb.las_mon);// Modified by by Anmol@wipro for US PB-005 
                // apply discount matrix and usdrate
                priceBook.Apply_Discount_Matrix__c =pb.apply_discount ; //Divya  
                priceBook.Apply_Minimum_Price__c =pb.applyMinPrice ; // Priya RITM0237685  
                priceBook.Simulation_Price_Book__c = pb.applySimulation; //Simulation
                priceBook.Apply_Increase_Decrease_Percentage__c = pb.applyPercentage;
                
                if(pb.usdRate != null)
                    priceBook.USD_Rate__c = decimal.valueOf(pb.usdRate); //Divya  
                //  priceBook.isActive__c = pb.isActive;  
                update priceBook;   
                pb_id=priceBook.id;  
                
               List<Price_Book_Crop_Culture__c> cropcultureslistold = [select id,Price_Book_Brazil__c from Price_Book_Crop_Culture__c where Price_Book_Brazil__c =:pb_id ];
                if(cropcultureslistold.size() > 0){
                    delete cropcultureslistold;
                }
               List<Customer_Group_Price_Book__c> custgrplistold = [select id,Price_Book_Brazil__c from Customer_Group_Price_Book__c  where Price_Book_Brazil__c =:pb_id ];
               if(custgrplistold.size() > 0){
                    delete custgrplistold;
                }
                
                  List<Customer__c> custlistold = [select id,Price_Book_Brazil__c from Customer__c  where Price_Book_Brazil__c =:pb_id ];
               if(custlistold.size() > 0){
                    delete custlistold;
                }
                
                
                result='true';  
                System.debug('Price book ID ----> ' +pb_id);  
                System.debug('Price book ----> ' +priceBook);  
            }  
            System.debug('pb_id.length() ----> ' +pb_id.length());  
            System.debug('sku_file ----> ' +sku_file);  
            System.debug('sku_file size----> ' +sku_file);  
            if(sku_file.length() == 4){  
                sku_file = null;  
            }  
            if(sku_fileToDelete.length() == 4){  
                sku_fileToDelete = null;  
            }  
            if(pb_id.length() != 0 || pb_id !='' || pb_id != null){  
                if(sku_file != null){  
                    List<ProductSku> skuList = (List<ProductSku>)JSON.deserialize(sku_file, List<ProductSku>.class) ;  
                    if(skuList.size()>0){  
                        for(ProductSku sku : skuList){  
                            flag=true;  
                            Price_Book_Details__c p_detail = new Price_Book_Details__c();  
                            // p_detail.Id = sku.pbd_id;   
                            if(sku.pbd_id==''){  
                                p_detail.Price_Book__c = pb_id;  
                                p_detail.CurrencyIsoCode = priceBook.CurrencyIsoCode;  
                                sku.min_prc=sku.min_prc.replace(',','.');  
                                sku.min_prc_u=sku.min_prc_u.replace(',','.');  
                                sku.unt_prc=sku.unt_prc.replace(',','.');  
                                sku.unt_prc_u=sku.unt_prc_u.replace(',','.');  
                                sku.fsp=sku.fsp.replace(',','.');  
                                sku.fsp_u=sku.fsp_u.replace(',','.');  
                                p_detail.Minimum_Price_R__c = decimal.valueOf(sku.min_prc);  
                                p_detail.Minimum_Price_U__c = decimal.valueOf(sku.min_prc_u);  
                                p_detail.Unit_Price_R__c = decimal.valueOf(sku.unt_prc);  
                                p_detail.Unit_Price_U__c = decimal.valueOf(sku.unt_prc_u);  
                                p_detail.Future_Sales_Price_R__c = decimal.valueOf(sku.fsp);  
                                p_detail.Future_Sales_Price_U__c = decimal.valueOf(sku.fsp_u);  
                                String combKey='';  
                                System.debug('sku code ----> ' +sku.sku_code);  
                                System.debug('sku length ----> ' +sku.sku_code.trim().length());  
                                if(sku.sku_code.trim().length() == 6){  
                                    combKey='5191000000000000'+sku.sku_code;   // if length is 6 then added 12 zeros.   
                                }  
                                else if(sku.sku_code.trim().length() == 7){  
                                    combKey='519100000000000'+sku.sku_code;    // if length is 7 then added 11 zeros.         
                                }  
                                else {  
                                    combKey='5191'+sku.sku_code;    // if length is 18 then added sales org code only.         
                                }  
                                System.debug('SKU id---- '+ skuMap.get(combKey));  
                                if(skuMap.containsKey(combKey)){  
                                    
                                    System.debug('SKU code---- '+ sku.sku_code);  
                                    
                                    p_detail.SKU__c = skuMap.get(combKey);  
                                }  
                                else{  
                                    flag=false;  
                                }  
                                //added for kit  
                                PriceBook pb= (PriceBook)JSON.deserialize(price_book, PriceBook.class);  
                                if(pb.pb_for_kit==true){  
                                    system.debug(sku.kit_prod+'***hello***');  
                                    String combKeyKit='';  
                                    if(sku.kit_prod.trim().length() == 6){  
                                        combKeyKit='5191000000000000'+sku.kit_prod;   // if length is 6 then added 12 zeros.   
                                    }  
                                    else if(sku.kit_prod.trim().length() == 7){  
                                        combKeyKit='519100000000000'+sku.kit_prod;    // if length is 7 then added 11 zeros.         
                                    }  
                                    else {  
                                        combKeyKit='5191'+sku.kit_prod;    // if length is 18 then added sales org code only.         
                                    }  
                                    //System.debug('SKU id---- '+ skuMap.get(combKey));  
                                    if(skuMap.containsKey(combKeyKit)){  
                                        
                                        System.debug('SKU code---- '+ sku.kit_prod);  
                                        
                                        p_detail.Kit_SKU__c = skuMap.get(combKeyKit);  
                                    }  
                                    else{  
                                        flag=false;  
                                    }  
                                }  
                                
                                
                                /* if(districtMap.containsKey(sku.cn)){  
System.debug('Dist code---- '+ sku.cn);  
System.debug('Dist id---- '+ districtMap.get(sku.cn));  
p_detail.Sales_District1__c = districtMap.get(sku.cn);  
}  
else{  
flag=false;  
}*/  
                                if(flag){  
                                    detailsList.add(p_detail);  
                                }  
                            }  
                        }  
                    }  
                }  
                if(sku_fileToDelete != null){  
                    List<ProductSku> skuListDelete = (List<ProductSku>)JSON.deserialize(sku_fileToDelete, List<ProductSku>.class) ;  
                    if(skuListDelete.size()>0){  
                        for(ProductSku skuD : skuListDelete){  
                            Price_Book_Details__c p_detailD = new Price_Book_Details__c();  
                            p_detailD.Id = skuD.pbd_id;    
                            detailsListDelete.add(p_detailD);  
                        }  
                    }  
                }  
                if(paymentTerms != null){  
                    List<PaymentTerms> payList = (List<PaymentTerms>)JSON.deserialize(paymentTerms, List<PaymentTerms>.class);  
                    if(payList.size()>0){  
                        
                        System.debug('salesList-->'+payList);  
                        for(PaymentTerms payTm : payList){  
                            Campaign_Payment_Terms__c obj = new Campaign_Payment_Terms__c();  
                            if(payTm.id != null || payTm.id != ''){  
                                obj.Id = payTm.id;  
                            }                                 
                            obj.Price_Book_Brazil__c = pb_id;  
                            
                            if(payTm.pt_type=='day'){  
                                obj.Payment_Term__c = payTm.pt_id;  
                            }  
                            else{  
                                obj.Payment_Term_in_Date__c = Date.valueof(payTm.pt_name);  
                            }  
                            paymentTermList.add(obj);  
                        }  
                    }  
                }  
                if(paymentTermsToDelete != null){  
                    List<PaymentTerms> payListDelete = (List<PaymentTerms>)JSON.deserialize(paymentTermsToDelete, List<PaymentTerms>.class) ;  
                    if(payListDelete.size()>0){  
                        for(PaymentTerms pay : payListDelete){  
                            Campaign_Payment_Terms__c payD = new Campaign_Payment_Terms__c();  
                            payD.Id = pay.id;    
                            paymentTermListDelete.add(payD);  
                        }  
                    }  
                }  
                if(salesDistArray != null){  
                    List<wrapperForSalesDistrict> salesList = (List<wrapperForSalesDistrict>)JSON.deserialize(salesDistArray, List<wrapperForSalesDistrict>.class);  
                    
                    if(salesList.size()>0){  
                        
                        System.debug('salesList-->'+salesList);  
                        for(wrapperForSalesDistrict slds : salesList){  
                            Price_Book_Sales_District__c obj = new Price_Book_Sales_District__c();  
                            if(slds.Id !=null || slds.Id !=''){  
                                obj.Id=slds.Id1;   
                            }  
                            obj.Price_Book__c = pb_id;  
                            obj.Sales_District1__c = slds.sdtId;  
                            
                            salesDistList.add(obj);  
                        }  
                    }  
                    
                }
                
                 //added by Sagar@Wipro for PB-003
                 list<Culture__c> culList= [select id,name from Culture__c where id in:cropCultureId];//added by javed(Grazitti) for RITM0463334 23-12-2022
                   if(salesDistArray != null){  
                       // List<wrapperForCropCul> salesList1 = (List<wrapperForCropCul>)JSON.deserialize(cropCulArray, List<wrapperForCropCul>.class);  
                            if(culList.size()>0){  
                                
                                System.debug('culList-->'+culList);  
                                  /* start code added by javed(Grazitti) for RITM0463334 23-12-2022*/
                                for(Culture__c slds : culList){  
                                    Price_Book_Crop_Culture__c obj1 = new Price_Book_Crop_Culture__c();  
                                    obj1.Price_Book_Brazil__c = pb_id;  
                                    obj1.Crop_Culture1__c = slds.Id;  
                                    //obj1.Culture_Desc__c=slds.Name1;
                                    //obj1.Culture_Code__c=slds.SDCode1;
                                    cropCulList.add(obj1);  
                                    system.debug('cropCulList'+cropCulList);
                                }  
                                  /* end code added by javed(Grazitti) for RITM0463334 23-12-2022*/
                            }  
                            
                    }  
                
                  //added by Sagar@Wipro for PB-004
                    if(custGrpArray != null){  
                        List<wrapperForCustGroup> salesList2 = (List<wrapperForCustGroup>)JSON.deserialize(custGrpArray, List<wrapperForCustGroup>.class);  
                            if(salesList2.size()>0){  
                                
                                System.debug('salesList-->'+salesList2);  
                                for(wrapperForCustGroup slds : salesList2){  
                                    Customer_Group_Price_Book__c obj1 = new Customer_Group_Price_Book__c();  
                                    obj1.Price_Book_Brazil__c = pb_id;  
                                    //obj1.Customer_Group__c = slds.sdtId2;  
                                    obj1.Customer_Group_Code__c = slds.SDCode2;  
                                    custgrpList.add(obj1);  
                                }  
                            }  
                        }    
                      
                  
                //added by Sagar@Wipro for PB-004
                    if(custNameArray != null){  
                        List<wrapperForCustName> salesList3 = (List<wrapperForCustName>)JSON.deserialize(custNameArray, List<wrapperForCustName>.class);  
                            if(salesList3.size()>0){  
                                
                                System.debug('salesList-->'+salesList3);  
                                for(wrapperForCustName slds : salesList3){  
                                    Customer__c obj1 = new Customer__c();  
                                    obj1.Price_Book_Brazil__c = pb_id;  
                                    obj1.Account__c = slds.Id;  
                                    custNameList.add(obj1);  
                                }  
                            }  
                            
                    }  
                
                  
                
            }  
            System.debug('SKU details List size---- '+ detailsList.size());  
            System.debug('SKU details List ---- '+ detailsList);  
            if(detailsList.size()>0){  
                upsert detailsList;  
            }  
            System.debug('detailsListDelete List size---- '+ detailsListDelete.size());  
            System.debug('detailsListDelete List ---- '+ detailsListDelete);  
            if(detailsListDelete.size()>0){  
                delete detailsListDelete;  
            }  
            System.debug('paymentTermList  size---- '+ paymentTermList.size());  
            System.debug('paymentTermList ---- '+ paymentTermList);  
            if(paymentTermList.size()>0){  
                upsert paymentTermList;  
            }    
            System.debug('paymentTermListDelete  size---- '+ paymentTermListDelete.size());  
            System.debug('paymentTermListDelete ---- '+ paymentTermListDelete);  
            if(paymentTermListDelete.size()>0){  
                delete paymentTermListDelete;  
            }   
            System.debug('salesDistList List size---- '+ salesDistList.size());  
            System.debug('salesDistList ---- '+ salesDistList);  
            if(salesDistList.size()>0){  
                upsert salesDistList;  
            } 
            
            if(cropCulList.size()>0){//added by wipro
               //upsert cropCulList;  
                Database.upsert(cropCulList, false);
            }
            if(custgrpList.size()>0){  
               // upsert custgrpList;  
                Database.upsert(custgrpList, false);
            }
            if(custNameList.size()>0){  
              // upsert custNameList;  
                Database.upsert(custNameList, false);
            }
            
        } catch (DMLException e) {  
            System.debug('Exception while updating Price Book'+ e.getLineNumber());  
            result='false';  
            return result;  
        }  
        return result;  
    }  
    
    @AuraEnabled  
    public static String submitForApproval(String priceBookId) {  
        System.debug('submitForApproval calle...');  
        System.debug('price_book id ... '+priceBookId);  
        try{  
            Price_Book__c priceBook =new Price_Book__c();  
            priceBook.Id=priceBookId;  
            priceBook.Status__c = 'Waiting Approval';  
            update priceBook;  
            Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();  
            req1.setObjectId(priceBook.Id);  
            Approval.ProcessResult result = Approval.process(req1);  
        }  
        catch(DmlException e){  
            System.debug('Exception occured ... '+e);    
        }  
        return priceBookId;	//added by Atish
        
    }  
    @AuraEnabled  
    public static String setActiveDeactive(String priceBookId,String value) {  
        System.debug('setActiveDeactive calle...');  
        System.debug('price_book id ... '+priceBookId);  
        System.debug('value  ... '+value);  
        try{  
            if(value == 'false'){  
                if(Approval.isLocked(priceBookId)){  
                    System.debug('Recall called....>> ');  
                    ProcessInstanceWorkitem[] workItems = [  
                        SELECT Id FROM ProcessInstanceWorkitem  WHERE ProcessInstance.TargetObjectId = :priceBookId  
                        AND ProcessInstance.Status = 'Pending'];  
                    if(workItems.size()>0){  
                        Approval.ProcessWorkitemRequest pwr = new Approval.ProcessWorkitemRequest();  
                        pwr.setAction('Removed');  
                        pwr.setWorkItemId(workItems[0].id);  
                        Approval.ProcessResult result = Approval.process(pwr);  
                    }  
                }  
            }  
            Price_Book__c priceBook =new Price_Book__c();  
            priceBook.Id=priceBookId;  
            if(value == 'true'){  
                priceBook.isActive__c = true;  
            }  
            else{  
                priceBook.isActive__c = false;  
                priceBook.Status__c= 'Canceled';  
            }  
            
            update priceBook;  
        }  
        catch(DmlException e){  
            System.debug('Exception occured ... '+e);    
        }  
        return null;  
        
    }  
      //added by Atish
    public static  void sendPriceBookFile(List<Id> setPrIds,String recrds)
    {
        system.debug('setPrIds'+setPrIds);
                         Set<Id> documentIds = new Set<Id>(); 

        list<ContentDocumentLink > PBFiles = [SELECT ContentDocumentId, LinkedEntityId  FROM ContentDocumentLink where LinkedEntityId IN:setPrIds];
        system.debug('PBFiles'+PBFiles);
Map<Id,ContentDocumentLink> cDocumentLinkMap = new Map<Id,ContentDocumentLink>();  //ADDED LOGIC START FROM HERE
for(ContentDocumentLink cdoLink :PBFiles)
{
cDocumentLinkMap.put(cdoLink.LinkedEntityId , cdoLink);
}                                                                                //  LOGIC END HERE
                                system.debug('PBFiles'+PBFiles);
                  

for(ContentDocumentLink cdLink:PBFiles){  
           documentIds.add(cdLink.ContentDocumentId);  
                 
             system.debug('documentIds'+documentIds);
                 }
list<ContentVersion> converList =[Select Id,ContentDocumentId,PathOnClient,ContentLocation,Title,VersionData FROM ContentVersion where ContentDocumentId IN:documentIds ];
                ContentVersion[] insertContent = new  ContentVersion[]{};
                 for(ContentVersion cv :converList)
                {
ContentVersion cvs= new ContentVersion(ContentLocation= 'S',PathOnClient= cv.PathOnClient,Title=cv.Title,VersionData=cv.VersionData);
                insertContent.add(cvs);
                    system.debug('insertContent'+insertContent);
                }
                if(insertContent.size()>0)
                {
                    insert insertContent;
Id conDoc =[Select ContentDocumentId,CreatedDate from ContentVersion ORDER BY CreatedDate DESC LIMIT 1].ContentDocumentId;
                    ContentDocumentLink[] conDocLink = new ContentDocumentLink[]{};
                        for(Id pr :setPrIds){  // ADDING LOGIC START HERE
                      if(cDocumentLinkMap.containsKey(pr))
                   {
                       system.debug('Exists');
                       
                    }
                    else{
                ContentDocumentLink cdl = new ContentDocumentLink(LinkedEntityId=pr ,ContentDocumentId= conDoc,shareType ='V') ;  
                       conDocLink.add(cdl);
                        system.debug('');
                          }   // LOGIC END HERE

                        }
      if(conDocLink.size() >0)
      {
    insert conDocLink;
      
      }
                    
    }
                 }	
    
    //modified if kit pricebook, added kit: in pbname, and setting kit sku in material   
    @AuraEnabled  
    public static String cloneNewPriceBook(String price_book, String sku_file, String salesDistArray,string cropCulArray,String custGrpArray, string custNameArray, String paymentTerms,list<string> cropCultureId) {  
        System.debug('cloneNewPriceBook called---------->');  
        System.debug('sku map ----------> '+ skuMap);  
        System.debug('Dist map ----------> '+ districtMap);  
        System.debug('price_book ----------> '+ price_book);  
        System.debug('salesDistArray ----------> '+ salesDistArray);
         System.debug('cropCulArray ----------> '+ cropCulArray);
        System.debug('custGrpArray ----------> '+ custGrpArray);
        System.debug('custNameArray ----------> '+ custNameArray);
        System.debug('paymentTerms ----------> '+ paymentTerms);  
        System.debug('cropCultureId ----------> '+ cropCultureId);  
        loadMapValues();  
        System.debug('sku map after ----------> '+ skuMap);  
        System.debug('Dist map after ----------> '+ districtMap);  
        // PriceBook pb = new PriceBook();  
        Price_Book__c priceBook =new Price_Book__c();  
        List<Price_Book__c> priceBookList = new List<Price_Book__c>();  
        Price_Book_Details__c pbd = new Price_Book_Details__c();  
        List<Price_Book_Details__c> detailsList= new List<Price_Book_Details__c>();  
        List<Price_Book_Sales_District__c> salesDistList = new List<Price_Book_Sales_District__c>();  
        List<Campaign_Payment_Terms__c> paymentTermList = new List<Campaign_Payment_Terms__c>();  
        List<Price_Book_Crop_Culture__c> cropCulList = new List<Price_Book_Crop_Culture__c>();
        List<Customer_Group_Price_Book__c> custgrpList = new List<Customer_Group_Price_Book__c>();  
        List<Customer__c> custNameList = new List<Customer__c>();
        // String pb_id='';  
        String preffix='';  
        String isoCurrency='';  
        String result='';  
        Boolean flag=true;  
        String[] skuArray;   
        try{  
            if(price_book != null){  
                // pb = (Price_Book__c) price_book;  
                PriceBook pb= (PriceBook)JSON.deserialize(price_book, PriceBook.class);  
                
                if(pb.curncy == 'Only BRL'){  
                    preffix='BRL : ';  
                    isoCurrency='BRL';  
                }  
                else if(pb.curncy == 'Only USD'){  
                    preffix='USD : ';  
                    isoCurrency='USD';  
                }  
                if(pb.pb_for_Kit==True){  
                    preffix=system.label.Kit+preffix;  
                    priceBook.Kit_Price_Book__c	=true;	
                    
                }  
                if(pb.curncy == 'BRL and USD'){  
                    if(pb.pb_for_cmpgn == true){  
                        priceBook.Use_Campaign__c = true;  
                        priceBook.Campaign_Type__c = pb.cmpgn_tp;  
                        priceBook.Sales_Order_Block_Date__c = Date.valueof(pb.blk_dt);  
                        priceBook.Interest_Date__c = Date.valueof(pb.intr_dt);     
                    }   
                    else{  
                        priceBook.Use_Campaign__c = false;  
                      }  
          if(pb.pb_for_avec == true){

                        priceBook.AVEC_Price_Book__c=true;
//priceBook.Campaign_Type__c = pb.cmpgn_tp;
                        priceBook.Sales_Order_Block_Date__c = Date.valueof(pb.blk_dt);  

                        priceBook.Interest_Date__c = Date.valueof(pb.intr_dt);

                    }  

                    else{  

                        priceBook.AVEC_Price_Book__c = false;  
                    }  
                    if(pb.pb_for_Kit==True){  
                        priceBook.Name = system.label.Kit+'BRL : '+pb.pb_name;  
                        priceBook.Kit_Price_Book__c	=true;	
                    }else{  
                        priceBook.Name = 'BRL : '+pb.pb_name;  
                    }  
                    //priceBook.Name = 'BRL : '+pb.pb_name;  
                    priceBook.Currency__c = 'Only BRL';//pb.curncy;  
                    priceBook.CurrencyIsoCode = 'BRL';  
                    priceBook.Valid_From__c = Date.valueof(pb.frm_dt);  
                    priceBook.Expiry_Date__c = Date.valueof(pb.exp_dt);  
                    priceBook.Interest_Rate_R__c = decimal.valueOf(pb.intr_rt_R);  
                    priceBook.Interest_Rate_U__c = 0;    //decimal.valueOf(pb.intr_rt_U);  
                    priceBook.Division__c = pb.division;  
                    priceBook.isActive__c = true;  
                    // apply discount matrix and usdrate
                    priceBook.Apply_Discount_Matrix__c = pb.apply_discount; //Divya
                    priceBook.Apply_Minimum_Price__c = pb.applyMinPrice; // Priya RITM0237685
                    priceBook.Simulation_Price_Book__c = pb.applySimulation; //Simulation
                    priceBook.Apply_Increase_Decrease_Percentage__c = pb.applyPercentage;
                    priceBook.Last_Month_Of_The_Season__c = Date.valueof(pb.las_mon);
                    if (pb.usdRate != null)
                        priceBook.USD_Rate__c = decimal.valueOf(pb.usdRate); //Divya  
                    priceBook.Status__c = 'Draft';  
                    priceBookList.add(priceBook);  
                    Price_Book__c priceBook2 =new Price_Book__c();  
                    if(pb.pb_for_cmpgn == true){  
                        priceBook2.Use_Campaign__c = true;  
                        priceBook2.Campaign_Type__c = pb.cmpgn_tp;  
                        priceBook2.Sales_Order_Block_Date__c = Date.valueof(pb.blk_dt);  
                        priceBook2.Interest_Date__c = Date.valueof(pb.intr_dt);     
                    }   
                    else{  
                        priceBook2.Use_Campaign__c = false;  
                        }	//added by wipro
          if(pb.pb_for_avec == true){

                        priceBook2.AVEC_Price_Book__c=true;
//priceBook2.Campaign_Type__c = pb.cmpgn_tp;
                        priceBook2.Sales_Order_Block_Date__c = Date.valueof(pb.blk_dt);  

                        priceBook2.Interest_Date__c = Date.valueof(pb.intr_dt);

                    }  

                    else{  

                        priceBook2.AVEC_Price_Book__c = false;
                    }  
                    if(pb.pb_for_Kit==True){  
                        priceBook2.Name = system.label.Kit+'USD : '+pb.pb_name;  
                        priceBook2.Kit_Price_Book__c	=true;	
                    }else{  
                        priceBook2.Name = 'USD : '+pb.pb_name;  
                    }  
                    // priceBook2.Name = 'USD : '+pb.pb_name;  
                    priceBook2.Currency__c = 'Only USD';//pb.curncy;  
                    priceBook2.CurrencyIsoCode = 'USD';  
                    priceBook2.Valid_From__c = Date.valueof(pb.frm_dt);  
                    priceBook2.Expiry_Date__c = Date.valueof(pb.exp_dt);  
                    priceBook2.Interest_Rate_R__c = 0;       //decimal.valueOf(pb.intr_rt_R);  
                    priceBook2.Interest_Rate_U__c = decimal.valueOf(pb.intr_rt_U);  
                    priceBook2.Division__c = pb.division;  
                    priceBook2.isActive__c = true;  
                    priceBook2.Status__c = 'Draft';  
                    // apply discount matrix and usdrate
                    priceBook2.Apply_Discount_Matrix__c = pb.apply_discount; //Divya
                    priceBook2.Apply_Minimum_Price__c = pb.applyMinPrice; // Priya RITM0237685
                    priceBook2.Simulation_Price_Book__c = pb.applySimulation; //Simulation
                    priceBook2.Apply_Increase_Decrease_Percentage__c = pb.applyPercentage;
                    priceBook.Last_Month_Of_The_Season__c = Date.valueof(pb.las_mon);
                    if (pb.usdRate != null)
                        priceBook2.USD_Rate__c = decimal.valueOf(pb.usdRate); //Divya
                    priceBookList.add(priceBook2);  
                }  
                else{  
                    if(pb.pb_for_cmpgn == true){  
                        priceBook.Use_Campaign__c = true;  
                        priceBook.Campaign_Type__c = pb.cmpgn_tp;  
                        priceBook.Sales_Order_Block_Date__c = Date.valueof(pb.blk_dt);  
                        priceBook.Interest_Date__c = Date.valueof(pb.intr_dt);     
                    }   
                    else{  
                        priceBook.Use_Campaign__c = false;  
                        
                    }  
                     if(pb.pb_for_avec == true){//added by wipro

                        priceBook.AVEC_Price_Book__c=true;
//priceBook.Campaign_Type__c = pb.cmpgn_tp;
                        priceBook.Sales_Order_Block_Date__c = Date.valueof(pb.blk_dt);  

                        priceBook.Interest_Date__c = Date.valueof(pb.intr_dt);
    }  

                    else{  

                        priceBook.AVEC_Price_Book__c = false;

                    }
                    priceBook.Name = preffix+pb.pb_name;  
                    priceBook.Currency__c = pb.curncy;  
                    priceBook.CurrencyIsoCode = isoCurrency;  
                    priceBook.Valid_From__c = Date.valueof(pb.frm_dt);  
                    priceBook.Expiry_Date__c = Date.valueof(pb.exp_dt);  
                    priceBook.Interest_Rate_R__c = decimal.valueOf(pb.intr_rt_R);  
                    priceBook.Interest_Rate_U__c = decimal.valueOf(pb.intr_rt_U);  
                    priceBook.Division__c = pb.division;  
                    priceBook.isActive__c = true;  
                    priceBook.Status__c = 'Draft';  
                    // apply discount matrix and usdrate
                    priceBook.Apply_Discount_Matrix__c = pb.apply_discount; //Divya  
                    priceBook.Apply_Minimum_Price__c = pb.applyMinPrice; // Priya RITM0237685
                    priceBook.Simulation_Price_Book__c = pb.applySimulation; //Simulation
                    priceBook.Apply_Increase_Decrease_Percentage__c = pb.applyPercentage;
                    priceBook.Last_Month_Of_The_Season__c = Date.valueof(pb.las_mon);
                    if (pb.usdRate != null)
                        priceBook.USD_Rate__c = decimal.valueOf(pb.usdRate); //Divya  
                    
                    priceBookList.add(priceBook);  
                }  
                
                result='true';  
                System.debug('priceBookList size ----> ' +priceBookList.size());  
                System.debug('priceBookList ----> ' +priceBookList);  
                if(priceBookList.size()>0){  
                    insert priceBookList;  
                }  
            }  
            if(priceBookList.size()>0){  
                if(sku_file != null){ 
                    List<ProductSku> skuList = (List<ProductSku>)JSON.deserialize(sku_file, List<ProductSku>.class) ;  
                    for(Price_Book__c priceBook1 : priceBookList){  
                        skuArray = new String[]{};  
                            if(skuList.size()>0){  
                                for(ProductSku sku : skuList){  
                                    flag=true;  
                                    Price_Book_Details__c p_detail = new Price_Book_Details__c();  
                                    p_detail.Price_Book__c = priceBook1.id;  
                                    p_detail.CurrencyIsoCode = priceBook1.CurrencyIsoCode;  
                                    sku.min_prc=sku.min_prc.replace(',','.');  
                                    sku.min_prc_u=sku.min_prc_u.replace(',','.');  
                                    sku.unt_prc=sku.unt_prc.replace(',','.');  
                                    sku.unt_prc_u=sku.unt_prc_u.replace(',','.');  
                                    sku.fsp=sku.fsp.replace(',','.');  
                                    sku.fsp_u=sku.fsp_u.replace(',','.');  
                                        //added by Krishanu	
                                   sku.sellOutPrice=sku.sellOutPrice.replace(',','.');	
                                    sku.sellOutPriceU=sku.sellOutPriceU.replace(',','.');
                                    p_detail.Minimum_Price_R__c = decimal.valueOf(sku.min_prc); 
                                     p_detail.Sellout_Price_BRL__c = decimal.valueOf(sku.sellOutPrice);
                                    p_detail.Sellout_Price_USD__c = decimal.valueOf(sku.sellOutPriceU);
                                    p_detail.GM__c = sku.GM;
                                    p_detail.GM_USD__c = sku.GMU;		
                                    p_detail.Sellout_Factor__c = sku.SelloutFactor;	
                                    p_detail.Sellout_Factor_USD__c = sku.SelloutFactorU;		
                                   p_detail.Type__c = sku.selloutType;			
                                    p_detail.Type_USD__c = sku.selloutTypeU;	
                                    p_detail.MinValue_Factor__c = sku.MinPriceFactor;	
                                    p_detail.Minimum_Value_Factor_USD__c = sku.MinPriceFactorU; 
                                    p_detail.Unit_Price_R__c = decimal.valueOf(sku.unt_prc);  
                                    p_detail.Future_Sales_Price_R__c = decimal.valueOf(sku.fsp);  
                                    p_detail.Minimum_Price_U__c = decimal.valueOf(sku.min_prc_u);  
                                    p_detail.Unit_Price_U__c = decimal.valueOf(sku.unt_prc_u);  
                                    p_detail.Future_Sales_Price_U__c = decimal.valueOf(sku.fsp_u);  
                                    String combKey='';  
                                    System.debug('sku code ----> ' +sku.sku_code);  
                                    System.debug('sku length ----> ' +sku.sku_code.trim().length());  
                                    if(sku.sku_code.trim().length() == 6){  
                                        combKey='5191000000000000'+sku.sku_code;   // if length is 6 then added 12 zeros.   
                                    }  
                                    else if(sku.sku_code.trim().length() == 7){  
                                        combKey='519100000000000'+sku.sku_code;    // if length is 7 then added 11 zeros.         
                                    }  
                                    else {  
                                        combKey='5191'+sku.sku_code;    // if length is 18 then added sales org code only.         
                                    }  
                                    System.debug('SKU id---- '+ skuMap.get(combKey));  
                                    if(skuMap.containsKey(combKey)){  
                                        
                                        System.debug('SKU code---- '+ sku.sku_code);  
                                        
                                        p_detail.SKU__c = skuMap.get(combKey);  
                                    }  
                                    else{  
                                        flag=false;  
                                    }  
                                    
                                    /*  if(districtMap.containsKey(sku.cn)){  

p_detail.Sales_District1__c = districtMap.get(sku.cn);  
}  
else{  
flag=false;  
}*/  
                                    PriceBook pb= (PriceBook)JSON.deserialize(price_book, PriceBook.class);  
                                    if(pb.pb_for_kit==true){  
                                        system.debug(sku.kit_prod+'***hello***');  
                                        String combKeyKit='';  
                                        if(sku.kit_prod.trim().length() == 6){  
                                            combKeyKit='5191000000000000'+sku.kit_prod;   // if length is 6 then added 12 zeros.   
                                        }  
                                        else if(sku.kit_prod.trim().length() == 7){  
                                            combKeyKit='519100000000000'+sku.kit_prod;    // if length is 7 then added 11 zeros.         
                                        }  
                                        else {  
                                            combKeyKit='5191'+sku.kit_prod;    // if length is 18 then added sales org code only.         
                                        }  
                                        //System.debug('SKU id---- '+ skuMap.get(combKey));  
                                        if(skuMap.containsKey(combKeyKit)){  
                                            
                                            System.debug('SKU code---- '+ sku.kit_prod);  
                                            
                                            p_detail.Kit_SKU__c = skuMap.get(combKeyKit);  
                                        }  
                                        else{  
                                            flag=false;  
                                        }  
                                    }  
                                    if(flag){  
                                        detailsList.add(p_detail);  
                                    }  
                                    else{  
                                        //skuArray.add(sku.sku_code);  
                                        if(pb.pb_for_kit==true){  
                                            skuArray.add(sku.kit_prod);  
                                        }  
                                        else{  
                                            skuArray.add(sku.sku_code);  
                                        }  
                                    }  
                                    
                                }  
                            }  
                    }  
                }  
                if(priceBookList.size()>0){  
                    if(salesDistArray != null){  
                        List<wrapperForSalesDistrict> salesList = (List<wrapperForSalesDistrict>)JSON.deserialize(salesDistArray, List<wrapperForSalesDistrict>.class);  
                        for(Price_Book__c priceBook2 : priceBookList){  
                            if(salesList.size()>0){  
                                
                                System.debug('salesList-->'+salesList);  
                                for(wrapperForSalesDistrict slds : salesList){  
                                    Price_Book_Sales_District__c obj = new Price_Book_Sales_District__c();  
                                    obj.Price_Book__c = priceBook2.id;  
                                    obj.Sales_District1__c = slds.sdtId;  
                                    
                                    salesDistList.add(obj);  
                                    system.debug('salesDistList'+salesDistList);
                                }  
                            }  
                        }    
                    }  
                }  
                 //added by Sagar@wipro
                 // start  code added by javed(Grazitti) for RITM0463334 23-12-2022*
                 set<id> cropId= new set <id>();
                 list<Culture__c> culList= new list<Culture__c>();
                 List<wrapperForCropCul> croList= (List<wrapperForCropCul>)JSON.deserialize(cropCulArray, List<wrapperForCropCul>.class);
                 for(wrapperForCropCul slds : croList){  
                    cropId.add(slds.sdtId1);
                 }
                 if(cropId!=null){
                    culList= [select id,name from Culture__c where id in:cropCultureId and id Not In:cropId];// code added by javed(Grazitti) for RITM0463334 23-12-2022*y
                 }else{
                    culList= [select id,name from Culture__c where id in:cropCultureId];
                 }
                 
                for(Culture__c crop:culList){
                    Price_Book_Crop_Culture__c obj1 = new Price_Book_Crop_Culture__c(); 
                    for(Price_Book__c priceBook2 : priceBookList){  
                                    obj1.Price_Book_Brazil__c = priceBook2.id;  
                                    obj1.Crop_Culture1__c = crop.Id;  
                                    //obj1.Culture_Desc__c=slds.Name1;
                                    //obj1.Culture_Code__c=slds.SDCode1;
                                    cropCulList.add(obj1);
                                    system.debug('cropCulList'+cropCulList);
                    }
                }
                // end added by javed(Grazitti) for RITM0463334 23-12-2022*
                 if(priceBookList.size()>0){  
                    if(cropCulArray != null){  
                        List<wrapperForCropCul> salesList1 = (List<wrapperForCropCul>)JSON.deserialize(cropCulArray, List<wrapperForCropCul>.class);  
                        for(Price_Book__c priceBook2 : priceBookList){  
                            if(salesList1.size()>0){  
                                
                                System.debug('salesList-->'+salesList1);  
                                for(wrapperForCropCul slds : salesList1){  
                                    Price_Book_Crop_Culture__c obj1 = new Price_Book_Crop_Culture__c();  
                                    obj1.Price_Book_Brazil__c = priceBook2.id;  
                                    obj1.Crop_Culture1__c = slds.sdtId1;  
                                    //obj1.Culture_Desc__c=slds.Name1;
                                    //obj1.Culture_Code__c=slds.SDCode1;
                                    cropCulList.add(obj1);
                                    system.debug('cropCulList'+cropCulList);
                                }  
                            }  
                        }    
                    }  
                }
                
                if(priceBookList.size()>0){  
                    if(custGrpArray != null){  
                        List<wrapperForCustGroup> salesList2 = (List<wrapperForCustGroup>)JSON.deserialize(custGrpArray, List<wrapperForCustGroup>.class);  
                        for(Price_Book__c priceBook2 : priceBookList){  
                            if(salesList2.size()>0){  
                                
                                System.debug('salesList-->'+salesList2);  
                                for(wrapperForCustGroup slds : salesList2){  
                                    Customer_Group_Price_Book__c obj1 = new Customer_Group_Price_Book__c();  
                                    obj1.Price_Book_Brazil__c = priceBook2.id;  
                                    //obj1.Customer_Group__c = slds.sdtId2;  
                                    obj1.Customer_Group_Code__c = slds.SDCode2;  
                                    custgrpList.add(obj1);  
                                    system.debug('custgrpList'+custgrpList);
                                }  
                            }  
                        }    
                    }  
                }
                
                if(priceBookList.size()>0){  
                    if(custNameArray != null){  
                        List<wrapperForCustName> salesList3 = (List<wrapperForCustName>)JSON.deserialize(custNameArray, List<wrapperForCustName>.class);  
                        for(Price_Book__c priceBook2 : priceBookList){  
                            if(salesList3.size()>0){  
                                
                                System.debug('salesList-->'+salesList3);  
                                for(wrapperForCustName slds : salesList3){  
                                    Customer__c obj1 = new Customer__c();  
                                    obj1.Price_Book_Brazil__c = priceBook2.id;  
                                    obj1.Account__c = slds.Id;  
                                    custNameList.add(obj1);  
                                    system.debug('custNameList'+custNameList);
                                }  
                            }  
                        }    
                    }  
                }  
                
                
                if(priceBookList.size()>0){  
                    if(paymentTerms != null){  
                        List<PaymentTerms> payList = (List<PaymentTerms>)JSON.deserialize(paymentTerms, List<PaymentTerms>.class);  
                        for(Price_Book__c priceBook3 : priceBookList){  
                            if(payList.size()>0){  
                                System.debug('salesList-->'+payList);  
                                for(PaymentTerms payTm : payList){  
                                    Campaign_Payment_Terms__c obj = new Campaign_Payment_Terms__c();  
                                    obj.Price_Book_Brazil__c = priceBook3.id;  
                                    
                                    if(payTm.pt_type=='day'){  
                                        obj.Payment_Term__c = payTm.pt_id;  
                                    }  
                                    else{  
                                        obj.Payment_Term_in_Date__c = Date.valueof(payTm.pt_name);  
                                    }  
                                    paymentTermList.add(obj);  
                                }  
                            }  
                        }  
                    }  
                }  
            }  
            System.debug('SKU details List size---- '+ detailsList.size());  
            System.debug('SKU details List ---- '+ detailsList);  
            if(detailsList.size()>0){  
                insert detailsList;  
            }  
            System.debug('salesDistList List size---- '+ salesDistList.size());  
            System.debug('salesDistList ---- '+ salesDistList);  
            if(salesDistList.size()>0){  
                insert salesDistList;  
            }  
            if(cropCulList.size()>0){//added by wipro
               // insert cropCulList;
                Database.insert(cropCulList, false);
            }
            if(custgrpList.size()>0){  
                //insert custgrpList;  
                Database.insert(custgrpList, false);
            }
            if(custNameList.size()>0){  
               // insert custNameList;  
                Database.insert(custNameList, false);
            }
            System.debug('paymentTermList  size---- '+ paymentTermList.size());  
            System.debug('paymentTermList ---- '+ paymentTermList);  
            if(paymentTermList.size()>0){  
                insert paymentTermList;  
            }   
            if(skuArray.size()>0){  
                result = JSON.serialize(skuArray);  
            }     
        } catch (Exception e) {  
            System.debug('Exception while Adding Price Book'+ e);  
            System.debug(e.getLineNumber());
            result='false';  
            return result;  
        }  
        return result;  
        
    }  
    //added to get componnet based on kit code  
    @AuraEnabled  
    public static List<Component__c> getComponent(String kitCode) {  
        List<Component__c> cmp=[SELECT Id, Name,Component_SKU__c, Kit_SKU__c, Component_Quantity__c,   
                                Combination_Key__c,Sales_Org__c, Distribution_Channel__c, Division__c,  
                                Component_Item_Category__c,Component_SKU__r.SKU_Description__c,Component_SKU__r.SKU_Code__c,Kit_SKU__r.SKU_Code__c FROM Component__c where (Sales_Org__r.Sales_Org_Code__c='5191'  
                                                                                                                                                                            AND Kit_SKU__r.SKU_Code__c =:kitCode)  
                                ORDER BY createdDate ASC];  
        
        //system.debug('hello123'+cmp[0].Component_SKU__r.SKU_Description__c+cmp[0].Kit_SKU__r.SKU_Code__c);  
        return [SELECT Id, Name,Component_SKU__c, Kit_SKU__c, Component_Quantity__c,   
                Combination_Key__c,Sales_Org__c, Distribution_Channel__c, Division__c,  
                Component_Item_Category__c,Component_SKU__r.SKU_Description__c,Component_SKU__r.SKU_Code__c,Kit_SKU__r.SKU_Code__c FROM Component__c where (Sales_Org__r.Sales_Org_Code__c='5191'  
                                                                                                                                                            AND Kit_SKU__r.SKU_Code__c =:kitCode)  
                ORDER BY createdDate ASC];  
    }  
     //added by Krishnu	
    @AuraEnabled
    public static CFwrapper getConversionFactor(string Brand){
        List<Customer_Conversion_factor__c> cf= [select id,Brand_Name__c,Conversion_Factor__c from Customer_Conversion_factor__c where Brand_Name__c=:Brand];
        Decimal lowest = cf[0].Conversion_Factor__c;
        Decimal highest = cf[0].Conversion_Factor__c;
        for(Customer_Conversion_factor__c cfi:cf){
            if(cfi.Conversion_Factor__c<lowest){
                lowest = cfi.Conversion_Factor__c;
            }
            if(cfi.Conversion_Factor__c>highest){
                highest = cfi.Conversion_Factor__c;
            }
        }
        CFwrapper cfw = new CFwrapper();
        cfw.maximum=highest;
        cfw.minimum=lowest;
        return cfw;
    }
    @AuraEnabled
    public static List<Sell_Out_Percentage__c> getSelloutMinpriceFactor(){
        return [select Type__c,Sell_Out_Factor__c,Min_Price_Factor__c from Sell_Out_Percentage__c]; //Type__c,
    } 
    //modified query to fetch products based on kit and non kit,added paramter pbtype  
    @AuraEnabled  
    public static List<SKU__c> getSku(String divisionId,Boolean pbKit) {  
        
        if(pbKit==true){  
            
            return [SELECT Id, Name,SKU_Code__c,Division__c,  
                    SKU_Description__c, Product_Category__c,  
                    Product_Name__c,Product_Name__r.Name,  
                    Sales_Org_Code__c,Active__c,Kit_Product__c,brand_Name__c//added Brand Name field by Swapnil  
                    FROM SKU__c   
                    where (Sales_Org_Code__c='5191'  
                           AND Division__c =:divisionId  
                           AND  Active__c = true  
                           AND  SKU_Description__c != null  
                           AND Kit_Product__c =true)  
                    ORDER BY createdDate ASC];}  
        else{  
            
            return [SELECT Id, Name,SKU_Code__c,Division__c,  
                    SKU_Description__c, Product_Category__c,  
                    Product_Name__c,Product_Name__r.Name,  
                    Sales_Org_Code__c,Active__c,Kit_Product__c,brand_Name__c//added Brand Name field by Swapnil  
                    FROM SKU__c   
                    where (Sales_Org_Code__c='5191'  
                           AND Division__c =:divisionId  
                           AND  Active__c = true  
                           AND  SKU_Description__c != null  
                           AND Kit_Product__c=false)  
                    ORDER BY createdDate ASC];  
        }  
        
    }     
    @AuraEnabled  
    public static String getCampaigntype(String priceBookId) {  
        System.debug('getCampaigntype called---------->');  
        System.debug('price_bookId ----------> '+ priceBookId);  
        String str='';  
        
        if(priceBookId.length()>0){  
            Price_Book__c pb = new Price_Book__c();  
            pb =[SELECT Id, Name, Currency__c, Division__c,Division__r.Name, Expiry_Date__c, Valid_From__c, isActive__c,   
                 Interest_Date__c, Interest_Rate_R__c, Interest_Rate_U__c, Sales_Order_Block_Date__c, Use_Campaign__c,   
                 Status__c, Campaign_Type__c FROM Price_Book__c where id=:priceBookId];  
            
            str=pb.Campaign_Type__c;                       
        }  
        return str;  
    }                              
    public Static void loadMapValues(){  
        List<SKU__c> skuList = new List<SKU__c>();  
        List<Region__c> distList = new List<Region__c>();  
        skuMap = new Map<String,String>();  
        skuList=[SELECT Id, SKU_Code__c, Combination_Key__c, Sales_Org_Code__c FROM SKU__c where Sales_Org_Code__c='5191' AND Active__c=true];  
        if(skuList.size()>0){  
            for(SKU__c sk : skuList){  
                skuMap.put(sk.Combination_Key__c,sk.Id);  
            }  
        }  
        /* districtMap = new Map<String,String>();  
distList=[SELECT Id, RegionCode__c,SalesOrg__c,Sales_Org_Code__c,Zone__c FROM Region__c where SalesOrg__r.Sales_Org_Code__c ='5191'];   
if(distList.size()>0){  
for(Region__c rgn : distList){  
districtMap.put(rgn.RegionCode__c,rgn.Id);   
}  
}*/
    }  
    //modified if kit, added name and kit sku on material  
    //modified by Atish
    @AuraEnabled  
    public static wrapPriceBookDetails saveAndSendForApprovalNewPriceBook(String price_book, String sku_file, String salesDistArray,string cropCulArray,String custGrpArray, string custNameArray, String paymentTerms,String pbType,list<string> cropCultureId) {	
        System.debug('saveAndSendForApprovalNewPriceBook called---------->');  
        System.debug('sku map ----------> '+ skuMap);  
        System.debug('Dist map ----------> '+ districtMap);  
        System.debug('price_book ----------> '+ price_book);  
        System.debug('salesDistArray ----------> '+ salesDistArray);  
        System.debug('paymentTerms ----------> '+ paymentTerms);  
        System.debug('cropCultureId ----------> '+cropCultureId); 
        loadMapValues();  
        System.debug('sku map after ----------> '+ skuMap);  
        System.debug('Dist map after ----------> '+ districtMap);  
        // PriceBook pb = new PriceBook(); 
        wrapPriceBookDetails wpBdetails = new wrapPriceBookDetails();// added by Atish
        Price_Book__c priceBook =new Price_Book__c();  
        List<Price_Book__c> priceBookList = new List<Price_Book__c>();  
        Set<Id> priceBookListId = new Set<Id>();	

        Price_Book_Details__c pbd = new Price_Book_Details__c();  
        List<Price_Book_Details__c> detailsList= new List<Price_Book_Details__c>();  
        List<Price_Book_Sales_District__c> salesDistList = new List<Price_Book_Sales_District__c>();  
        List<Campaign_Payment_Terms__c> paymentTermList = new List<Campaign_Payment_Terms__c>();  
        List<Price_Book_Crop_Culture__c> cropCulList = new List<Price_Book_Crop_Culture__c>();  
        List<Customer_Group_Price_Book__c> custgrpList = new List<Customer_Group_Price_Book__c>();  
        List<Customer__c> custNameList = new List<Customer__c>();
        // String pb_id='';  
        String preffix='';  
        String isoCurrency='';  
        String result='';  
        Boolean flag=true;  
        String[] skuArray;   
        try{  
            if(price_book != null){  
                // pb = (Price_Book__c) price_book;  
                PriceBook pb= (PriceBook)JSON.deserialize(price_book, PriceBook.class);  
                
                if(pb.curncy == 'Only BRL'){  
                    preffix='BRL : ';  
                    isoCurrency='BRL';  
                }  
                else if(pb.curncy == 'Only USD'){  
                    preffix='USD : ';  
                    isoCurrency='USD';  
                }  
                if(pb.pb_for_Kit==True){  
                    preffix=system.label.Kit+preffix;  
                    priceBook.Kit_Price_Book__c	=true;	
                    system.debug('hello'+priceBook.Kit_Price_Book__c);  
                }  
                if(pb.curncy == 'BRL and USD'){  
                    if(pb.pb_for_cmpgn == true){  
                        priceBook.Use_Campaign__c = true;  
                        priceBook.Campaign_Type__c = pb.cmpgn_tp;  
                        priceBook.Sales_Order_Block_Date__c = Date.valueof(pb.blk_dt);  
                        priceBook.Interest_Date__c = Date.valueof(pb.intr_dt);     
                    }   
                    else{  
                        priceBook.Use_Campaign__c = false;  
                        }//added by wipro  
          if(pb.pb_for_avec == true){

                        priceBook.AVEC_Price_Book__c=true;
//priceBook.Campaign_Type__c = pb.cmpgn_tp;
                        priceBook.Sales_Order_Block_Date__c = Date.valueof(pb.blk_dt);  

                        priceBook.Interest_Date__c = Date.valueof(pb.intr_dt);

                    }  

                    else{  

                        priceBook.AVEC_Price_Book__c = false;
                    }  
                    if(pb.pb_for_Kit==True){  
                        priceBook.Name = system.label.Kit+'BRL : '+pb.pb_name;  
                        priceBook.Kit_Price_Book__c	=true;	
                    }else{  
                        priceBook.Name = 'BRL : '+pb.pb_name;  
                    }  
                    //priceBook.Name = 'BRL : '+pb.pb_name;  
                    priceBook.Currency__c = 'Only BRL';//pb.curncy;  
                    priceBook.CurrencyIsoCode = 'BRL';  
                    priceBook.Valid_From__c = Date.valueof(pb.frm_dt);  
                    priceBook.Expiry_Date__c = Date.valueof(pb.exp_dt);  
                    priceBook.Last_Month_Of_The_Season__c = Date.valueof(pb.las_mon);// Modified by by Anmol@wipro for US PB-005 
                    priceBook.Interest_Rate_R__c = decimal.valueOf(pb.intr_rt_R);  
                    priceBook.Interest_Rate_U__c = 0;    //decimal.valueOf(pb.intr_rt_U);  
                    priceBook.Division__c = pb.division;  
                    priceBook.isActive__c = true;  
                    // apply discount matrix and usdrate
                    priceBook.Apply_Discount_Matrix__c = pb.apply_discount; //Divya  
                    priceBook.Apply_Minimum_Price__c = pb.applyMinPrice; // Priya RITM0237685
                    priceBook.Simulation_Price_Book__c = pb.applySimulation; //Simulation
                    priceBook.Apply_Increase_Decrease_Percentage__c = pb.applyPercentage;
                    if (pb.usdRate != null){
                        priceBook.USD_Rate__c = decimal.valueOf(pb.usdRate); //Divya
                    }
                    priceBook.Status__c = 'Waiting Approval';  
                    priceBookList.add(priceBook);  
                    Price_Book__c priceBook2 =new Price_Book__c();  
                    if(pb.pb_for_cmpgn == true){  
                        priceBook2.Use_Campaign__c = true;  
                        priceBook2.Campaign_Type__c = pb.cmpgn_tp;  
                        priceBook2.Sales_Order_Block_Date__c = Date.valueof(pb.blk_dt);  
                        priceBook2.Interest_Date__c = Date.valueof(pb.intr_dt);     
                    }   
                    else{  
                        priceBook2.Use_Campaign__c = false;  
                      }	//added by wipro
          if(pb.pb_for_avec == true){

                        priceBook2.AVEC_Price_Book__c=true;
//priceBook2.Campaign_Type__c = pb.cmpgn_tp;
                        priceBook2.Sales_Order_Block_Date__c = Date.valueof(pb.blk_dt);  

                        priceBook2.Interest_Date__c = Date.valueof(pb.intr_dt);

                    }  

                    else{  

                        priceBook2.AVEC_Price_Book__c = false;
System.debug('test1.4'+pb.pb_for_avec);  
                    }  
                    if(pb.pb_for_Kit==True){  
                        priceBook2.Name = system.label.Kit+'USD : '+pb.pb_name;  
                        priceBook2.Kit_Price_Book__c	=true;	
                    }else{  
                        priceBook2.Name = 'USD : '+pb.pb_name;  
                    }  
                    //priceBook2.Name = 'USD : '+pb.pb_name;  
                    priceBook2.Currency__c = 'Only USD';//pb.curncy;  
                    priceBook2.CurrencyIsoCode = 'USD';  
                    priceBook2.Valid_From__c = Date.valueof(pb.frm_dt);  
                    priceBook2.Expiry_Date__c = Date.valueof(pb.exp_dt);  
                    priceBook2.Interest_Rate_R__c = 0;       //decimal.valueOf(pb.intr_rt_R);  
                    priceBook2.Interest_Rate_U__c = decimal.valueOf(pb.intr_rt_U);  
                    priceBook2.Last_Month_Of_The_Season__c = Date.valueof(pb.las_mon);// Modified by by Anmol@wipro for US PB-005
                    priceBook2.Division__c = pb.division;  
                    priceBook2.isActive__c = true;  
                    priceBook2.Status__c = 'Waiting Approval';  
                    // apply discount matrix and usdrate
                    priceBook2.Apply_Discount_Matrix__c = pb.apply_discount; //Divya  
                    priceBook2.Apply_Minimum_Price__c = pb.applyMinPrice; // Priya RITM0237685
                    priceBook2.Simulation_Price_Book__c = pb.applySimulation; //Simulation
                    priceBook2.Apply_Increase_Decrease_Percentage__c = pb.applyPercentage;
                    if (pb.usdRate != null)
                        priceBook2.USD_Rate__c = decimal.valueOf(pb.usdRate); //Divya  
                    priceBookList.add(priceBook2);  
                }  
                else{  
                    if(pb.pb_for_cmpgn == true){  
                        priceBook.Use_Campaign__c = true;  
                        priceBook.Campaign_Type__c = pb.cmpgn_tp;  
                        priceBook.Sales_Order_Block_Date__c = Date.valueof(pb.blk_dt);  
                        priceBook.Interest_Date__c = Date.valueof(pb.intr_dt);     
                    }   
                    else{  
                        priceBook.Use_Campaign__c = false;  
                        
                    }
                    if(pb.pb_for_avec == true){//added by wipro

                        priceBook.AVEC_Price_Book__c=true;
//priceBook.Campaign_Type__c = pb.cmpgn_tp;
                        priceBook.Sales_Order_Block_Date__c = Date.valueof(pb.blk_dt);  

                        priceBook.Interest_Date__c = Date.valueof(pb.intr_dt);

                    }  

                    else{  

                        priceBook.AVEC_Price_Book__c = false;

                    }              
                    
                    priceBook.Name = preffix+pb.pb_name;  
                    priceBook.Currency__c = pb.curncy;  
                    priceBook.CurrencyIsoCode = isoCurrency;  
                    priceBook.Valid_From__c = Date.valueof(pb.frm_dt);  
                    priceBook.Expiry_Date__c = Date.valueof(pb.exp_dt);  
                    priceBook.Last_Month_Of_The_Season__c = Date.valueof(pb.las_mon);
                    priceBook.Interest_Rate_R__c = decimal.valueOf(pb.intr_rt_R);  
                    priceBook.Interest_Rate_U__c = decimal.valueOf(pb.intr_rt_U);  
                    priceBook.Division__c = pb.division;  
                    priceBook.isActive__c = true;  
                    priceBook.Status__c = 'Waiting Approval';
                    // apply discount matrix and usdrate
                    priceBook.Apply_Discount_Matrix__c = pb.apply_discount; //Divya
                    priceBook.Apply_Minimum_Price__c = pb.applyMinPrice; // Priya RITM0237685
                    priceBook.Simulation_Price_Book__c = pb.applySimulation; //Simulation
                    priceBook.Apply_Increase_Decrease_Percentage__c = pb.applyPercentage;
                    if (pb.usdRate != null)
                        priceBook.USD_Rate__c = decimal.valueOf(pb.usdRate); //Divya
                    priceBookList.add(priceBook);  
                }  
                
                result='true';  
                System.debug('priceBookList size ----> ' +priceBookList.size());  
                System.debug('priceBookList ----> ' +priceBookList);  
                if(priceBookList.size()>0){  
                    insert priceBookList;  
                }  
                for(Price_Book__c pricefilesId :priceBookList)
              {
                priceBookListId.add(pricefilesId.Id)  ;
              }	
               wpBdetails.pbSet= priceBookListId;
            }  
            if(priceBookList.size()>0){  
                if(sku_file != null){  
                    List<ProductSku> skuList = (List<ProductSku>)JSON.deserialize(sku_file, List<ProductSku>.class) ;  
                    for(Price_Book__c priceBook1 : priceBookList){  
                        skuArray = new String[]{};  
                            if(skuList.size()>0){  
                                for(ProductSku sku : skuList){  
                                    flag=true;  
                                    Price_Book_Details__c p_detail = new Price_Book_Details__c();  
                                    p_detail.Price_Book__c = priceBook1.id;  
                                    p_detail.CurrencyIsoCode = priceBook1.CurrencyIsoCode;  
                                    sku.min_prc=sku.min_prc.replace(',','.');  
                                    sku.min_prc_u=sku.min_prc_u.replace(',','.');  
                                    sku.unt_prc=sku.unt_prc.replace(',','.');  
                                    sku.unt_prc_u=sku.unt_prc_u.replace(',','.');  
                                    sku.fsp=sku.fsp.replace(',','.');  
                                    sku.fsp_u=sku.fsp_u.replace(',','.');  
                                     //added by Krishanu	
                                   sku.sellOutPrice=sku.sellOutPrice.replace(',','.');	
                                    sku.sellOutPriceU=sku.sellOutPriceU.replace(',','.');
                                    
                                    p_detail.Minimum_Price_R__c = decimal.valueOf(sku.min_prc);  
                                      p_detail.Sellout_Price_BRL__c = decimal.valueOf(sku.sellOutPrice);
                                    p_detail.Sellout_Price_USD__c = decimal.valueOf(sku.sellOutPriceU);
                                    p_detail.GM__c = sku.GM;
                                    p_detail.GM_USD__c = sku.GMU;		
                                    p_detail.Sellout_Factor__c = sku.SelloutFactor;	
                                    p_detail.Sellout_Factor_USD__c = sku.SelloutFactorU;		
                                    //p_detail.Type__c = sku.selloutType;	
                                    if(priceBook1.Currency__c == 'Only BRL'){
                                        p_detail.Type__c = sku.selloutType;	
                                        p_detail.Type_USD__c = '-';
                                    }
                                    else if(priceBook1.Currency__c == 'Only USD'){
                                        p_detail.Type__c ='-'; 
                                        p_detail.Type_USD__c = sku.selloutTypeU;	
                                    }
                                    else{
                                        p_detail.Type__c = sku.selloutType;	
                                        p_detail.Type_USD__c = sku.selloutTypeU;	
                                    }
                                    p_detail.MinValue_Factor__c = sku.MinPriceFactor;	
                                    p_detail.Minimum_Value_Factor_USD__c = sku.MinPriceFactorU;
                                    p_detail.Unit_Price_R__c = decimal.valueOf(sku.unt_prc);  
                                    p_detail.Future_Sales_Price_R__c = decimal.valueOf(sku.fsp);  
                                    p_detail.Minimum_Price_U__c = decimal.valueOf(sku.min_prc_u);  
                                    p_detail.Unit_Price_U__c = decimal.valueOf(sku.unt_prc_u);  
                                    p_detail.Future_Sales_Price_U__c = decimal.valueOf(sku.fsp_u);  
                                    String combKey='';  
                                    System.debug('sku code ----> ' +sku.sku_code);  
                                    System.debug('sku length ----> ' +sku.sku_code.trim().length());  
                                    if(sku.sku_code.trim().length() == 6){  
                                        combKey='5191000000000000'+sku.sku_code;   // if length is 6 then added 12 zeros.   
                                    }  
                                    else if(sku.sku_code.trim().length() == 7){  
                                        combKey='519100000000000'+sku.sku_code;    // if length is 7 then added 11 zeros.         
                                    }  
                                    else {  
                                        combKey='5191'+sku.sku_code;    // if length is 18 then added sales org code only.         
                                    }  
                                    System.debug('SKU id---- '+ skuMap.get(combKey));  
                                    if(skuMap.containsKey(combKey)){  
                                        
                                        System.debug('SKU code---- '+ sku.sku_code);  
                                        
                                        p_detail.SKU__c = skuMap.get(combKey);  
                                    }  
                                    else{  
                                        flag=false;  
                                    }  
                                    
                                    /*  if(districtMap.containsKey(sku.cn)){  

p_detail.Sales_District1__c = districtMap.get(sku.cn);  
}  
else{  
flag=false;  
}*/  
                                    PriceBook pb= (PriceBook)JSON.deserialize(price_book, PriceBook.class);  
                                    if(pb.pb_for_kit==true){  
                                        system.debug(sku.kit_prod+'***hello***');  
                                        String combKeyKit='';  
                                        if(sku.kit_prod.trim().length() == 6){  
                                            combKeyKit='5191000000000000'+sku.kit_prod;   // if length is 6 then added 12 zeros.   
                                        }  
                                        else if(sku.kit_prod.trim().length() == 7){  
                                            combKeyKit='519100000000000'+sku.kit_prod;    // if length is 7 then added 11 zeros.         
                                        }  
                                        else {  
                                            combKeyKit='5191'+sku.kit_prod;    // if length is 18 then added sales org code only.         
                                        }  
                                        //System.debug('SKU id---- '+ skuMap.get(combKey));  
                                        if(skuMap.containsKey(combKeyKit)){  
                                            
                                            System.debug('SKU code---- '+ sku.kit_prod);  
                                            
                                            p_detail.Kit_SKU__c = skuMap.get(combKeyKit);  
                                        }  
                                        else{  
                                            flag=false;  
                                        }  
                                    }  
                                    if(flag){  
                                        detailsList.add(p_detail);  
                                    }  
                                    else{  
                                        //skuArray.add(sku.sku_code);  
                                        if(pb.pb_for_kit==true){  
                                            skuArray.add(sku.kit_prod);  
                                        }  
                                        else{  
                                            skuArray.add(sku.sku_code);  
                                        }  
                                    }  
                                }  
                            }  
                    }  
                }  
                if(priceBookList.size()>0){  
                    if(salesDistArray != null){  
                        List<wrapperForSalesDistrict> salesList = (List<wrapperForSalesDistrict>)JSON.deserialize(salesDistArray, List<wrapperForSalesDistrict>.class);  
                        for(Price_Book__c priceBook2 : priceBookList){  
                            if(salesList.size()>0){  
                                
                                System.debug('salesList-->'+salesList);  
                                for(wrapperForSalesDistrict slds : salesList){  
                                    Price_Book_Sales_District__c obj = new Price_Book_Sales_District__c();  
                                    obj.Price_Book__c = priceBook2.id;  
                                    obj.Sales_District1__c = slds.sdtId;  
                                    
                                    salesDistList.add(obj);  
                                }  
                            }  
                        }    
                    }  
                }  
                //added by Sagar@wipro
                  /* start code added by javed(Grazitti) for RITM0463334 23-12-2022*/
                list<Culture__c> culList= [select id,name from Culture__c where id in:cropCultureId];// added by javed(Grazitti) for RITM0463334 23-12-2022
        if(priceBookList.size()>0){  
                    if(culList != null){  
                        //List<wrapperForCropCul> salesList1 = (List<wrapperForCropCul>)JSON.deserialize(cropCulArray, List<wrapperForCropCul>.class);  
                        for(Price_Book__c priceBook2 : priceBookList){  
                           // if(salesList1.size()>0){  
                                
                                //System.debug('culList-->'+culList);  
                                for(Culture__c slds : culList){  
                                    Price_Book_Crop_Culture__c obj1 = new Price_Book_Crop_Culture__c();  
                                    obj1.Price_Book_Brazil__c = priceBook2.id;  
                                    obj1.Crop_Culture1__c = slds.id;  
                                    //obj1.Culture_Desc__c=slds.Name1;
                                    //obj1.Culture_Code__c=slds.SDCode1;
                                    cropCulList.add(obj1);  
                                }  
                                /* end code added by javed(Grazitti) for RITM0463334 23-12-2022*/
                           // }  
                        }    
                    }  
                }  
                
                
                if(priceBookList.size()>0){  
                    if(custGrpArray != null){  
                        List<wrapperForCustGroup> salesList2 = (List<wrapperForCustGroup>)JSON.deserialize(custGrpArray, List<wrapperForCustGroup>.class);  
                        for(Price_Book__c priceBook2 : priceBookList){  
                            if(salesList2.size()>0){  
                                
                                System.debug('salesList-->'+salesList2);  
                                for(wrapperForCustGroup slds : salesList2){  
                                    Customer_Group_Price_Book__c obj1 = new Customer_Group_Price_Book__c();  
                                    obj1.Price_Book_Brazil__c = priceBook2.id;  
                                    //obj1.Customer_Group__c = slds.sdtId2;  
                                    obj1.Customer_Group_Code__c = slds.SDCode2;  
                                    custgrpList.add(obj1);  
                                }  
                            }  
                        }    
                    }  
                }
                
                if(priceBookList.size()>0){  
                    if(custNameArray != null){  
                        List<wrapperForCustName> salesList3 = (List<wrapperForCustName>)JSON.deserialize(custNameArray, List<wrapperForCustName>.class);  
                        for(Price_Book__c priceBook2 : priceBookList){  
                            if(salesList3.size()>0){  
                                
                                System.debug('salesList-->'+salesList3);  
                                for(wrapperForCustName slds : salesList3){  
                                    Customer__c obj1 = new Customer__c();  
                                    obj1.Price_Book_Brazil__c = priceBook2.id;  
                                    obj1.Account__c = slds.Id;  
                                    custNameList.add(obj1);  
                                }  
                            }  
                        }    
                    }  
                }  
                
                
                if(priceBookList.size()>0){  
                    if(paymentTerms != null){  
                        List<PaymentTerms> payList = (List<PaymentTerms>)JSON.deserialize(paymentTerms, List<PaymentTerms>.class);  
                        for(Price_Book__c priceBook3 : priceBookList){  
                            if(payList.size()>0){  
                                System.debug('salesList-->'+payList);  
                                for(PaymentTerms payTm : payList){  
                                    Campaign_Payment_Terms__c obj = new Campaign_Payment_Terms__c();  
                                    obj.Price_Book_Brazil__c = priceBook3.id;  
                                    
                                    if(payTm.pt_type=='day'){  
                                        obj.Payment_Term__c = payTm.pt_id;  
                                    }  
                                    else{  
                                        obj.Payment_Term_in_Date__c = Date.valueof(payTm.pt_name);  
                                    }  
                                    paymentTermList.add(obj);  
                                }  
                            }  
                        }  
                    }  
                }  
                //......send for Approval...  
                if(priceBookList.size()>0){  
                    for(Price_Book__c priceBook4 : priceBookList){  
                        /*  Price_Book__c priceBookNew =new Price_Book__c();  
priceBookNew.Id=priceBook4.id;  
priceBookNew.Status__c = 'Waiting Approval';  
update priceBookNew;*/  
                        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();  
                        req1.setObjectId(priceBook4.Id);  
                        Approval.ProcessResult result1 = Approval.process(req1);  
                    }  
                }  
            }  
            System.debug('SKU details List size---- '+ detailsList.size());  
            System.debug('SKU details List ---- '+ detailsList);  
            if(detailsList.size()>0){  
                insert detailsList;  
            }  
            System.debug('salesDistList List size---- '+ salesDistList.size());  
            System.debug('salesDistList ---- '+ salesDistList);  
            if(salesDistList.size()>0){  
                insert salesDistList;  
            }  
            if(cropCulList.size()>0){//added by wipro
                insert cropCulList;  
            }
            if(custgrpList.size()>0){  
                insert custgrpList;  
            }
            if(custNameList.size()>0){  
                insert custNameList;  
            }
            System.debug('paymentTermList  size---- '+ paymentTermList.size());  
            System.debug('paymentTermList ---- '+ paymentTermList);  
            if(paymentTermList.size()>0){  
                insert paymentTermList;  
            }   
            if(skuArray.size()>0){  
                result = JSON.serialize(skuArray);  
            }     
        } catch (Exception e) {  
            System.debug('Exception while Adding Price Book'+ e);  
            result='false';  
           //return result;	
            wpBdetails.res = result; //Added by Atist@Wipro
        }  
        wpBdetails.res = result;
        return wpBdetails;        
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
    //added by wipro
  public class wrapperForCropCul{  
        
        @AuraEnabled  
        public String Id;  
        @AuraEnabled  
        public String Id11;  
        @AuraEnabled  
        public string sdtId1;  
        @AuraEnabled  
        public String Name1;  
        @AuraEnabled  
        public String SDCode1;  
        
    }   
    
    public class wrapperForCustGroup{  
        
        @AuraEnabled  
        public String Id;  
        @AuraEnabled  
        public String Id2;  
        @AuraEnabled  
        public string sdtId2;  
        @AuraEnabled  
        public String Name2;  
        @AuraEnabled  
        public String SDCode2;  
        
    }   
    
    public class wrapperForCustName{  
        
        @AuraEnabled  
        public String Id;  
        @AuraEnabled  
        public String Name;  
        @AuraEnabled  
        public String PriceConversionGroup;  
        @AuraEnabled  
        public String sapcode;  
        
    }  
    
    public class PriceBook {  
        @AuraEnabled public Boolean pb_for_cmpgn;  
        @AuraEnabled public Boolean apply_discount; //Divya  
        @AuraEnabled public Boolean applyMinPrice; // Priya RITM0237685
        @AuraEnabled public Boolean applySimulation; //Simulation
        @AuraEnabled public String usdRate; //Divya  
        @AuraEnabled public String cmpgn_tp;  
        @AuraEnabled public String pb_name;  
        @AuraEnabled public String curncy;  
        @AuraEnabled public String frm_dt;  
        @AuraEnabled public String exp_dt;  
        @AuraEnabled public String las_mon;// Modified by by Anmol@wipro for US PB-005
        @AuraEnabled public String intr_rt_R;  
        @AuraEnabled public String intr_rt_U;  
        @AuraEnabled public String intr_dt;  
        @AuraEnabled public String division;  
        @AuraEnabled public String blk_dt;  
        @AuraEnabled public String division_nm;  
        @AuraEnabled public String pcb_id;  
        @AuraEnabled public Boolean isActive;  
        @AuraEnabled public String status;  
        @AuraEnabled public String pbType;  
        @AuraEnabled public Boolean pb_for_Kit;  
        @AuraEnabled public Boolean pb_for_avec;
        @AuraEnabled public String custgrp;	// added by Sagar
        @AuraEnabled public Boolean applyPercentage;  // added by Sagar
        public PriceBook(){  
            pb_for_cmpgn=false;  
            cmpgn_tp='';
            pb_for_avec=false;    
            pb_name='';  
            curncy='';  
            frm_dt='';  
            exp_dt='';  
            las_mon='';// Modified by by Anmol@wipro for US PB-005  
            intr_rt_R='';  
            intr_rt_U='';  
            intr_dt='';  
            division='';  
            blk_dt='';  
            division_nm='';  
            pcb_id='';  
            isActive=true;  
            status='';  
            pbType='';  
            pb_for_Kit=false;  
            apply_discount=false; //Divya
            applyMinPrice= false; // Priya RITM0237685
            applySimulation= false; //Simulation                  
      applyPercentage= false;  
            usdRate=''; //Divya
            custgrp=''; // Sagar
        }  
    }  
    public class ProductSku {  
        @AuraEnabled public String cn;  
        @AuraEnabled public String mt_code; 
        @AuraEnabled public String Brand;	//added by Sagar for Sellout
        @AuraEnabled public String sku_code;  
        @AuraEnabled public String min_prc;  
        @AuraEnabled public String min_prc_u;  
        @AuraEnabled public String unt_prc;  
        @AuraEnabled public String unt_prc_u;  
        @AuraEnabled public String fsp;  
          //added by Krishanu
        @AuraEnabled public Decimal GM;
        @AuraEnabled public String sellOutPrice;
        @AuraEnabled public String selloutType;		
        @AuraEnabled public Decimal SelloutFactor;		
        @AuraEnabled public Decimal MinPriceFactor;	
        @AuraEnabled public Decimal GMU;
        @AuraEnabled public string sellOutPriceU;
        @AuraEnabled public String selloutTypeU;		
        @AuraEnabled public Decimal SelloutFactorU;		
        @AuraEnabled public Decimal MinPriceFactorU;
        @AuraEnabled public String fsp_u;  
        @AuraEnabled public String pbd_id;  
        //kit product  
        @AuraEnabled public String kit_comp;  
        @AuraEnabled public String kit_prod;  
        public ProductSku(){  
            cn='';  
            mt_code='';  
            sku_code='';  
            min_prc='';  
            min_prc_u='';  
            unt_prc='';  
            unt_prc_u='';  
            GM=0;
            sellOutPrice='0';
            selloutType='';
            SelloutFactor=0;
            MinPriceFactor=0;
            GMU=0;
            sellOutPriceU='0';
            selloutTypeU='';
            SelloutFactorU=0;
            MinPriceFactorU=0;	
            fsp='';  
            fsp_u='';  
            pbd_id='';  
            kit_prod='';  
            kit_comp='';  
        }  
    }  
    public class ApprovalHistory {  
        @AuraEnabled public String date_tm;  
        @AuraEnabled public String user;  
        @AuraEnabled public String cur_status;  
        @AuraEnabled public String prev_status;  
        @AuraEnabled public String comment;  
        @AuraEnabled public String name;  
        public ApprovalHistory(){  
            date_tm='';  
            user='';  
            cur_status='';  
            prev_status='';  
            comment='';  
            name='';  
        }  
    }  
    public class PaymentTerms {  
        @AuraEnabled public String id;  
        @AuraEnabled public String pt_id;  
        @AuraEnabled public String pt_name;  
        @AuraEnabled public String pt_date;  
        @AuraEnabled public String pBook;  
        @AuraEnabled public String pt_type;  
        public PaymentTerms(){  
            id='';  
            pt_id='';  
            pt_name='';  
            pt_date='';  
            pBook='';  
            pt_type='';  
        }  
    }  
    
    public class PriceBookWrapper {  
        @AuraEnabled public PriceBook pc_book {get;set;}  
        @AuraEnabled public List<ProductSku> materialList {get;set;}  
        @AuraEnabled public List<ApprovalHistory> approvarList {get;set;}  
        @AuraEnabled public List<wrapperForSalesDistrict> salesDistricts {get;set;}  
        @AuraEnabled public List<wrapperForCropCul> cropculs {get;set;}  
        @AuraEnabled public List<wrapperForCustGroup> custgrps {get;set;}  
        @AuraEnabled public List<wrapperForCustName> custnames {get;set;}  
        @AuraEnabled public List<PaymentTerms> paymentTerms {get;set;}  
        public PriceBookWrapper(){  
            this.pc_book= new PriceBook();  
            this.materialList = new List<ProductSku>();  
            this.approvarList = new List<ApprovalHistory>();  
            this.salesDistricts = new List<wrapperForSalesDistrict>();  
            this.cropculs = new List<wrapperForCropCul>();  
            this.custgrps = new List<wrapperForCustGroup>();
            this.custnames = new List<wrapperForCustName>();  
            this.paymentTerms =new List<PaymentTerms>();  
        }  
        
    }  
    
    //added by Swapnil -- to get Market variation, Discount Matrix and Sales District Cost  
    //  
    //  
    @AuraEnabled  
    public static wrapperMasterData getMasterdata(){  
        wrapperMasterData WMD = new wrapperMasterData();  
        list<string> liMV = new list<string>();  
        for (Market_Variation__c MV: [select Combination_Key__c from Market_Variation__c]){  
            liMV.add(MV.Combination_Key__c);  
        }  
        list<string> liSDC = new list<string>();  
        for (Sales_District_Cost__c SDC: [select Combination_Key__c from Sales_District_Cost__c]){  
            liSDC.add(SDC.Combination_Key__c);  
        }  
        list<string> liDM = new list<string>();  
        for (Discount_Matrix__c DM: [select Combination_Key__c from Discount_Matrix__c]){  
            liDM.add(DM.Combination_Key__c);  
        }  
        /*map<string,string> mapSKUBrand = new map<string,string>();  
for(SKU__c S: [select Id, SKU_Code__c,Brand_Name__c from SKU__C where Sales_org_code__c = '5191']){  
mapSKUBrand.put(S.SKU_Code__c,S.Brand_Name__c);  
}*/  
        
        WMD.MarketVariation = liMV;  
        WMD.SalesDistrictCost = liSDC;  
        WMD.DiscountMatrix = liDM;  
        UPL_Settings__c SalesOrg = UPL_Settings__c.getInstance();  
        WMD.SalesOrg = SalesOrg.SalesOrg__c;  
        //WMD.mapSKUBrand = mapSKUBrand;  
        return WMD;  
        
    }  
    public class wrapperMasterData{  
        @AuraEnabled  
        Public list<string> MarketVariation {get;set;}  
        @AuraEnabled  
        Public list<string> SalesDistrictCost {get;set;}  
        @AuraEnabled  
        Public list<string> DiscountMatrix {get;set;}  
        @AuraEnabled  
        Public String SalesOrg {get;set;}  
        /* @AuraEnabled  
Public map<string,string> mapSKUBrand {get;set;}*/  
    }  
    //added validation for kit products  
    @AuraEnabled  
    public static wrapperCalculation SKUValidationKIT(string LiSKU,string salesDistArray,Boolean kitPb){  
        system.debug(LiSKU);  
        system.debug(salesDistArray);  
        String errorMessage='';  
        wrapperCalculation wC = new wrapperCalculation();  
        List<ProductSku> finalskuList = new List<ProductSku>();  
        try{  
            
            List<ProductSku> skuList = (List<ProductSku>)JSON.deserialize(LiSKU, List<ProductSku>.class) ;              
            List<wrapperForSalesDistrict> SDList = (List<wrapperForSalesDistrict>)JSON.deserialize(salesDistArray,   
                                                                                                   List<wrapperForSalesDistrict>.class) ;  
            
            set<string> combinationKey = new  set<string>();  
            Map<string,string> mapCombKey = new  map<string,string>();  
            Map<string,string> mapCombKeyrev = new  map<string,string>();  
            set<string> combinationKeyKit = new  set<string>();  
            Map<string,string> mapCombKeyKit = new  map<string,string>();  
            Map<string,string> mapCombKeyrevKit = new  map<string,string>();  
            Map<string,sku__c> mapSKU = new  map<string,sku__c>();  
            Map<string,sku__c> mapSKUKit = new  map<string,sku__c>();  
            Map<string,string> mapDiscountMatrix = new  map<string,string>();  
            Map<string,string> mapMarketVariation = new  map<string,string>();  
            Map<string,List<String>> kitComp = new  map<string,List<string>>();  
            Map<string,List<String>> kitCompProd = new  map<string,List<string>>();  
            wrapperMasterData wMD = getMasterdata();  
            for(String s: wMD.DiscountMatrix){  
                mapDiscountMatrix.put(s,s);   
            }  
            for(String sm: wMD.MarketVariation){  
                mapMarketVariation.put(sm,sm);   
            }  
            for(ProductSku p:skuList){  
                string combKey;  
                string combKeyKit;  
                if(p.sku_code.trim().length() == 6){  
                    combKey='5191000000000000'+p.sku_code;   // if length is 6 then added 12 zeros.   
                }  
                else if(p.sku_code.trim().length() == 7){  
                    combKey='519100000000000'+p.sku_code;    // if length is 7 then added 11 zeros.         
                }  
                else {  
                    combKey='5191'+p.sku_code;    // if length is 18 then added sales org code only.         
                }  
                if(p.kit_prod.trim().length() == 6){  
                    combKeyKit='5191000000000000'+p.kit_prod;   // if length is 6 then added 12 zeros.   
                }  
                else if(p.kit_prod.trim().length() == 7){  
                    combKeyKit='519100000000000'+p.kit_prod;    // if length is 7 then added 11 zeros.         
                }  
                else {  
                    combKeyKit='5191'+p.kit_prod;    // if length is 18 then added sales org code only.         
                }  
                combinationKey.add(combKey);  
                mapCombKey.put(p.sku_code,combKey);  
                mapCombKeyrev.put(combKey,p.sku_code);  
                combinationKeyKit.add(combKeyKit);  
                mapCombKeyKit.put(p.kit_prod,combKeyKit);  
                mapCombKeyrevKit.put(combKeyKit,p.kit_prod);  
            }  
            
            for (SKU__c s: [select brand_name__c,combination_key__c from sku__c   
                            where combination_key__c in :mapCombKey.values()]){  
                                mapSKU.put(s.combination_key__c, s);   
                            }  
            for (SKU__c s: [select brand_name__c,combination_key__c from sku__c   
                            where combination_key__c in :mapCombKeyKit.values() and Kit_Product__c=true]){  
                                mapSKUKit.put(s.combination_key__c, s);   
                            }  
            for(Component__c cmp:[Select id,Component_SKU__c,Component_SKU__r.SKU_Code__c,Kit_SKU__c,Kit_SKU__r.SKU_Code__c from Component__c where Kit_SKU__r.combination_key__c in:mapCombKeyKit.values()]){  
                if(kitComp.containsKey(cmp.Kit_SKU__r.SKU_Code__c)) {  
                    kitComp.get(cmp.Kit_SKU__r.SKU_Code__c).add(cmp.Component_SKU__r.SKU_Code__c);  
                } else {  
                    kitComp.put(cmp.Kit_SKU__r.SKU_Code__c, new List<String> { cmp.Component_SKU__r.SKU_Code__c });  
                }  
            }  
            system.debug('kcomp'+kitComp);  
            for(ProductSku p:skuList){  
                String sk='';  
                STring kt='';  
                
                if(p.kit_prod.trim().length() == 6){  
                    kt='000000000000'+p.kit_prod;   // if length is 6 then added 12 zeros.   
                }  
                else if(p.kit_prod.trim().length() == 7){  
                    kt='00000000000'+p.kit_prod;    // if length is 7 then added 11 zeros.         
                }  
                else {  
                    kt=p.kit_prod;    // if length is 18 then added sales org code only.         
                }  
                if(p.kit_prod.trim().length() == 6){  
                    sk='000000000000'+p.sku_code;   // if length is 6 then added 12 zeros.   
                }  
                else if(p.kit_prod.trim().length() == 7){  
                    sk='00000000000'+p.sku_code;    // if length is 7 then added 11 zeros.         
                }  
                else {  
                    sk=p.sku_code;    // if length is 18 then added sales org code only.         
                }  
                if(kitCompProd.containsKey(kt)) {  
                    kitCompProd.get(kt).add(sk);  
                } else {  
                    kitCompProd.put(kt, new List<String> { sk});  
                }  
            }  
            system.debug('kcompProd'+kitCompProd);  
            for(ProductSku p:skuList){  
                
                
                
                Boolean validProduct = true;  
                system.debug(p.sku_code);  
                if(!mapSKU.containskey(mapCombKey.get(p.sku_code))){  
                    errorMessage = errorMessage + p.sku_code + '| ' + system.label.SKUISInvalid+' \n';  
                    validProduct = false;  
                    
                }  
                Boolean validProductKit = true;  
                if(!mapSKUKit.containskey(mapCombKeyKit.get(p.kit_prod))){  
                    errorMessage = errorMessage + p.kit_prod + '| ' + system.label.SKUISInvalid+' \n';  
                    validProductKit = false;  
                    
                }  
                
                if(validProduct && validProductKit){  
                    Boolean notNullBrand = true;  
                    Boolean notNullBrandKit = true;  
                    Boolean validComponent = true;  
                    if(string.isBlank(mapSKU.get(mapCombKey.get(p.sku_code)).Brand_Name__c)){  
                        errorMessage = errorMessage + p.sku_code + '| ' +system.label.BrandValueIsBlank +' \n';  
                        notNullBrand = false;  
                        
                    }  
                    if(string.isBlank(mapSKUkit.get(mapCombKeykit.get(p.kit_prod)).Brand_Name__c)){  
                        errorMessage = errorMessage + p.kit_prod + '| ' +system.label.BrandValueIsBlank +' \n';  
                        notNullBrandKit = false;  
                        
                    }  
                    
                    if(kitComp.get(p.kit_prod)!=kitCompProd.get(p.kit_prod)){  
                        errorMessage = errorMessage + p.kit_prod + '| ' + System.label.Components_Not_In_Kit+' \n';  
                        validComponent = false;  
                    }  
                    if(notNullBrand && notNullBrandKit && validComponent){  
                        Boolean validBrand = false;  
                        
                        if(mapDiscountMatrix.containskey(mapSKUKit.get(mapCombKeyKit.get(p.kit_prod)).Brand_Name__c+'5191')){  
                            validBrand = true;  
                        }  
                        
                        if(!validBrand){  
                            errorMessage = errorMessage + p.kit_prod+ '| '+mapSKUKit.get(mapCombKeyKit.get(p.kit_prod)).Brand_Name__c  
                                +' '+  System.label.SKUBrandNotAvailablein+ ' \n';  
                            
                            
                        }  
                        
                        Boolean validMarket= false;  
                        map<string,boolean> mapSD = new map<string,boolean>();  
                        for(wrapperForSalesDistrict w: SDList){  
                            
                            
                            if(mapMarketVariation.containsKey(w.SDCode+mapSKUKit.get(mapCombKeyKit.get(p.kit_prod)).Brand_Name__c+'5191')){  
                                validMarket = true;  
                                mapSD.put(w.SDCode+mapSKUKit.get(mapCombKeyKit.get(p.kit_prod)).Brand_Name__c, true);  
                                
                            }                      
                            
                            else{  
                                errorMessage = errorMessage +p.Kit_prod+'| '+w.SDCode+ '| ' + mapSKUKit.get(mapCombKeyKit.get(p.Kit_prod)).Brand_Name__c  
                                    + ' ' + system.label.RegionaAndSKU +' \n';  
                                mapSD.put(w.SDCode+mapSKUKit.get(mapCombKeyKit.get(p.Kit_prod)).Brand_Name__c, false);   
                                
                            }  
                            
                        }  
                        Boolean validSDBrand = true;  
                        if(notNullBrand && ValidBrand){  
                            for(boolean b: mapSD.values()){  
                                if(!b){  
                                    validSDBrand = false;  
                                }  
                            }  
                            if(validSDBrand){  
                                finalskuList.add(P);  
                            }  
                        }  
                    }  
                }  
            }  
            
            system.debug('FinalskuList '+finalskuList);  
            wC.FinalSKUList = getSelloutPriceSKU(finalskuList);  
            wC.ErrorString = errorMessage;  
            
            system.debug('errorMessage '+errorMessage);  
        }  
        catch(Exception e){  
            
            system.debug('Exception '+e.getMessage());  
        }  
        return wC;  
    }  
    @AuraEnabled  
    public static wrapperCalculation SKUValidation(string LiSKU,string salesDistArray){  
        system.debug('LiSKU:'+LiSKU);
        system.debug(salesDistArray);  
        String errorMessage='';  
        wrapperCalculation WC = new wrapperCalculation();  
        List<ProductSku> FinalskuList = new List<ProductSku>();  
        try{  
            
            List<ProductSku> skuList = (List<ProductSku>)JSON.deserialize(LiSKU, List<ProductSku>.class) ;              
            List<wrapperForSalesDistrict> SDList = (List<wrapperForSalesDistrict>)JSON.deserialize(salesDistArray,   
                                                                                                   List<wrapperForSalesDistrict>.class) ;  
            
            set<string> combinationKey = new  set<string>();  
            Map<string,string> mapCombKey = new  map<string,string>();  
            Map<string,string> mapCombKeyrev = new  map<string,string>();  
            Map<string,sku__c> mapSKU = new  map<string,sku__c>();  
            Map<string,string> mapDiscountMatrix = new  map<string,string>();  
            Map<string,string> mapMarketVariation = new  map<string,string>();  
            wrapperMasterData WMD = getMasterdata();  
            for(String S: WMD.DiscountMatrix){  
                mapDiscountMatrix.put(S,S);   
            }  
            for(String sm: WMD.MarketVariation){  
                mapMarketVariation.put(sm,sm);   
            }  
            for(ProductSku P:skuList){  
                string combKey;  
                if(P.sku_code.trim().length() == 6){  
                    combKey='5191000000000000'+P.sku_code;   // if length is 6 then added 12 zeros.   
                }  
                else if(P.sku_code.trim().length() == 7){  
                    combKey='519100000000000'+P.sku_code;    // if length is 7 then added 11 zeros.         
                }  
                else {  
                    combKey='5191'+P.sku_code;    // if length is 18 then added sales org code only.         
                }  
                combinationKey.add(combKey);  
                mapCombKey.put(P.sku_code,combKey);  
                mapCombKeyrev.put(combKey,P.sku_code);  
            }  
            
            for (SKU__c S: [select brand_name__c,combination_key__c from sku__c   
                            where combination_key__c in :mapCombKey.values()]){  
                                mapSKU.put(s.combination_key__c, S);   
                            }  
            
            for(ProductSku P:skuList){  
                Boolean validProduct = true;  
                system.debug(P.sku_code);  
                if(!mapSKU.containskey(mapCombKey.get(P.sku_code))){  
                    errorMessage = errorMessage + P.sku_code + '| ' + system.label.SKUISInvalid+' \n';  
                    validProduct = false;  
                    
                }  
                if(validProduct){  
                    Boolean notNullBrand = true;  
                    if(string.isBlank(mapSKU.get(mapCombKey.get(P.sku_code)).Brand_Name__c)){  
                        errorMessage = errorMessage + P.sku_code + '| ' +system.label.BrandValueIsBlank +' \n';  
                        notNullBrand = false;  
                        
                    }  
                    if(notNullBrand){  
                        Boolean ValidBrand = false;  
                        
                        if(mapDiscountMatrix.containskey(mapSKU.get(mapCombKey.get(P.sku_code)).Brand_Name__c+'5191')){  
                            ValidBrand = true;  
                        }  
                        system.debug('P.sku_code = '+P.sku_code);//Sayan10  
                        system.debug('mapCombKey.get(P.sku_code) = '+mapCombKey.get(P.sku_code));//Sayan10  
                        system.debug('mapSKU.get(mapCombKey.get(P.sku_code)) = '+mapSKU.get(mapCombKey.get(P.sku_code)));//Sayan10  
                        
                        if(!ValidBrand){  
                            errorMessage = errorMessage + P.sku_code+ '| '+mapSKU.get(mapCombKey.get(P.sku_code)).Brand_Name__c  
                                +' '+  System.label.SKUBrandNotAvailablein+ ' \n';  
                            
                            
                        }  
                        
                        Boolean validMarket= false;  
                        map<string,boolean> mapSD = new map<string,boolean>();  
                        for(wrapperForSalesDistrict W: SDList){  
                            
                            
                            if(mapMarketVariation.containsKey(W.SDCode+mapSKU.get(mapCombKey.get(P.sku_code)).Brand_Name__c+'5191')){  
                                validMarket = true;  
                                mapSD.put(W.SDCode+mapSKU.get(mapCombKey.get(P.sku_code)).Brand_Name__c, true);  
                                
                            }                      
                            
                            else{  
                                errorMessage = errorMessage +P.sku_code+'| '+W.SDCode+ '| ' + mapSKU.get(mapCombKey.get(P.sku_code)).Brand_Name__c  
                                    + ' ' + system.label.RegionaAndSKU +' \n';  
                                mapSD.put(W.SDCode+mapSKU.get(mapCombKey.get(P.sku_code)).Brand_Name__c, false);   
                                
                            }  
                            
                        }  
                        Boolean validSDBrand = true;  
                        if(notNullBrand && ValidBrand){  
                            for(boolean b: mapSD.values()){  
                                if(!b){  
                                    validSDBrand = false;  
                                }  
                            }  
                            if(validSDBrand){  
                                FinalskuList.add(P);  
                            }  
                        }  
                    }  
                }  
            }  
            
            system.debug('FinalskuList '+FinalskuList);  
            WC.FinalSKUList = getSelloutPriceSKU(FinalskuList);  
            system.debug('FinalskuList** '+FinalskuList);  
            WC.ErrorString = errorMessage;  
            
            system.debug('errorMessage '+errorMessage);  
            
        }  
        catch(Exception e){  
            
            system.debug('Exception '+e.getMessage());  
            system.debug('Exception '+e.getLineNumber());  
        }  
        return WC;  
    }  
     //added by Atish
    public class wrapPriceBookDetails {
         @AuraEnabled
        public String res {get; set;}
         @AuraEnabled
        public Set<Id> pbSet {get; set;}
    }
     public class CFwrapper{	
        @AuraEnabled	
        Public Decimal maximum {get;set;}	
        @AuraEnabled	
        Public Decimal minimum {get;set;}	
    }  
    public class wrapperCalculation{  
        @AuraEnabled  
        Public list<ProductSku> FinalSKUList {get;set;}  
        @AuraEnabled  
        Public string ErrorString {get;set;}  
    }
    //added by wipro
    public class materialplantrecords{
        @AuraEnabled public Boolean Active{get;set;}
        @AuraEnabled public decimal Recommendedprice{get;set;}
        @AuraEnabled public String ReplacementCost{get;set;}
        @AuraEnabled public String MaterialCode{get;set;}
        @AuraEnabled public String SKUid{get;set;} 
        @AuraEnabled public String ID{get;set;} 
    }
  @AuraEnabled  
    public static List<materialplantrecords> materialPlantrecordfetch(string depotcode){
        List<materialplantrecords> mpr = new List<materialplantrecords>();
        List<Material_Plant_Relation__c> mtrel = [Select id,Name,SKU__c,Material_Code__c,Replacement_Cost__c,Active__c,Depot_Code__c  from Material_Plant_Relation__c where Depot_Code__c  =:depotcode];
        for(Material_Plant_Relation__c obj:mtrel)  {
            materialplantrecords rec = new materialplantrecords();
            rec.ID=obj.id;
            rec.SKUid=obj.SKU__c;
            rec.MaterialCode=obj.Material_Code__c;
            rec.Recommendedprice=obj.Replacement_Cost__c;
            rec.Active=obj.Active__c;
            mpr.add(rec);
        }         
        return mpr;
    }  
 // Added by Krishanu Mallik Thakur and Ankita Tripathy @WIPRO
    @AuraEnabled	
    public static Decimal getReplacementCost(string skuid){
        Material_Plant_Relation__c mtrel = [Select id,Name,SKU__c,Material_Code__c,Replacement_Cost__c,Active__c,Depot_Code__c  from Material_Plant_Relation__c where SKU__C=:skuid AND Depot_Code__c  ='BR07' LIMIT 1];     		
        return mtrel.Replacement_Cost__c;
    }
    @AuraEnabled	
    public static map<string,Decimal> getReplacementCostMaterial(List<string> skucode){
        List<Material_Plant_Relation__c> mtrel = [Select id,Name,SKU__c,Material_Code__c,Replacement_Cost__c,Active__c,Depot_Code__c  from Material_Plant_Relation__c where SKU__r.SKU_Code__c in :skucode AND Depot_Code__c  ='BR07'];     		
        map<string,decimal> repmap = new map<string,decimal>();
        for(Material_Plant_Relation__c mtin:mtrel){
            repmap.put(mtin.Material_Code__c,mtin.Replacement_Cost__c);
        }
        return repmap;
    }
    @AuraEnabled	
    public static map<string,string> getBrand(List<string> skucode){
        List<SKU__C> mtrel = [Select id,Name,Brand_Name__c,SKU_Code__c  from SKU__C where SKU_Code__c in :skucode];     		
        map<string,string> repmap = new map<string,string>();
        for(SKU__C mtin:mtrel){
            repmap.put(mtin.SKU_Code__c,mtin.Brand_Name__c);
        }
        return repmap;
    }
     // Added by Krishanu Mallik Thakur and Ankita Tripathy @WIPRO
    @AuraEnabled
    public static Decimal getCurrentExchangeRate(){
        ExchangeRate__c er = [select id,ExchangeRate__c,createddate from ExchangeRate__c order by createddate desc limit 1];
		return er.ExchangeRate__c;
    }
    @AuraEnabled
    public static map<string,Sell_Out_Percentage__c> getSelloutMinpriceFactorMap(){
        List<Sell_Out_Percentage__c> smlst = [select Type__c,Sell_Out_Factor__c,Min_Price_Factor__c from Sell_Out_Percentage__c]; //Type__c,
        map<string,Sell_Out_Percentage__c> smap = new map<string,Sell_Out_Percentage__c>();
        for(Sell_Out_Percentage__c ins:smlst){
            smap.put(ins.Type__c, ins);
        }
        return smap;
    }
    @AuraEnabled
    public static map<string,CFwrapper> getConversionFactorMap(List<string> Brand){
        list<AggregateResult> lst = [select Brand_Name__c,max(Conversion_Factor__c),min(Conversion_Factor__c) from Customer_Conversion_factor__c where brand_name__c in :Brand group by brand_name__c];
        map<string,CFwrapper> resmap = new map<string,CFwrapper>();
        for(AggregateResult i:lst){
            CFwrapper cfw = new CFwrapper();
            cfw.maximum = (Decimal)i.get('expr0');
            cfw.minimum = (Decimal)i.get('expr1');
           	resmap.put((string)i.get('Brand_Name__c'),cfw);
        }
        for(string str:Brand){
            if(!resmap.containskey(str)){
                CFwrapper cfw = new CFwrapper();
            	cfw.maximum = 1;
            	cfw.minimum = 1;
           		resmap.put(str,cfw);
            }
        }
        return resmap;
    }
    @AuraEnabled
    public static List<ProductSku> getSelloutPriceSKU(List<ProductSku> skulst){
        system.debug('skulst!!:'+skulst);
        map<string,Sell_Out_Percentage__c> smap = getSelloutMinpriceFactorMap();
        system.debug('smap!!:'+smap);
        list<string> skucode = new list<string>();
        for(ProductSku p:skulst){
            if(p.sku_code.length() == 6){
                p.sku_code='000000000000'+p.sku_code; 
            }
            else if(p.sku_code.length() == 7){
                p.sku_code='00000000000'+p.sku_code;       
            }
            skucode.add(p.sku_code);
        }
        map<string,decimal> repmap = getReplacementCostMaterial(skucode);
        system.debug('repmap!!:'+repmap);
        map<string,string> Brandmap = getBrand(skucode);
        system.debug('Brandmap!!:'+Brandmap);
        List<string> brands = Brandmap.values();
        system.debug('brands!!:'+brands);
        map<string,CFwrapper> minmaxCF = getConversionFactorMap(brands);
        system.debug('minmaxCF!!:'+minmaxCF);
        // start 
        Decimal currER = getCurrentExchangeRate();
        for(ProductSku skui: skulst){
            if(smap.containsKey((Brandmap.get(skui.sku_code)))){
                system.debug('TESTE sku_code'+skui.sku_code);
                Decimal minprice = smap.get(Brandmap.get(skui.sku_code)).Min_Price_Factor__c;
                Decimal sellout = smap.get(Brandmap.get(skui.sku_code)).Sell_Out_Factor__c; 
                Decimal max = minmaxCF.get(Brandmap.get(skui.sku_code)).maximum;
                Decimal unitp = Decimal.valueof(skui.unt_prc.replace('.','').replace(',','.'));
                Decimal unitpu = Decimal.valueof(skui.unt_prc_u.replace('.','').replace(',','.'));
                Decimal sp =  unitp*max + (unitp*max*sellout/100);
                Decimal mp = unitp-(unitp*minprice/100);
                skui.min_prc = String.valueOf(mp.setScale(2)).replace('.',',');
                skui.sellOutPrice = String.valueOf(sp.setScale(2)).replace('.',',');
                Decimal spu =  unitpu*max + (unitpu*max*sellout/100);
                Decimal mpu = unitpu-(unitpu*minprice/100);
                skui.min_prc_u = String.valueOf(mpu.setScale(2)).replace('.',',');
                skui.sellOutPriceU = String.valueOf(spu.setScale(2)).replace('.',',');
                skui.selloutType = smap.get(Brandmap.get(skui.sku_code)).Type__c;
                skui.selloutTypeU = smap.get(Brandmap.get(skui.sku_code)).Type__c;
                skui.SelloutFactor = smap.get(Brandmap.get(skui.sku_code)).Sell_Out_Factor__c;
                skui.SelloutFactorU = smap.get(Brandmap.get(skui.sku_code)).Sell_Out_Factor__c;
                skui.MinPriceFactor = smap.get(Brandmap.get(skui.sku_code)).Min_Price_Factor__c;
                skui.MinPriceFactorU =smap.get(Brandmap.get(skui.sku_code)).Min_Price_Factor__c;
            }else{
                system.debug('elseeeeeeee');
                Decimal max = minmaxCF.get(Brandmap.get(skui.sku_code)).maximum;
                Decimal min = minmaxCF.get(Brandmap.get(skui.sku_code)).minimum;
                Decimal repcost = repmap.get(skui.sku_code)*currER;
                Decimal unitp = Decimal.valueof(skui.unt_prc.replace('.','').replace(',','.'));
                Decimal unitpu = Decimal.valueof(skui.unt_prc_u.replace('.','').replace(',','.'));
                Decimal gm = ((unitp*min*0.96-repcost)/(unitp*min*0.96))*100;
                Decimal gmu = ((unitpu*min*0.96-repmap.get(skui.sku_code))/(unitpu*min*0.96))*100;
                gm = gm.round();
                gmu = gmu.round();
                string typeb = '';
				if(gm>=60){
                    typeb = 'Gold';
                }else if(gm<60&&gm>=40){
                    typeb = 'A';
                }else if(gm<40&&gm>=20){
                    typeb = 'B';
                }else{
                    typeb = 'C';
                }
                string typeu = '';
				if(gmu>=60){
                    typeu = 'Gold';
                }else if(gmu<60&&gmu>=40){
                    typeu = 'A';
                }else if(gmu<40&&gmu>=20){
                    typeu = 'B';
                }else{
                    typeu = 'C';
                }
                Decimal minprice = smap.get(typeb).Min_Price_Factor__c;
                Decimal sellout = smap.get(typeb).Sell_Out_Factor__c; 
                Decimal minpriceu = smap.get(typeu).Min_Price_Factor__c;
                Decimal selloutu = smap.get(typeu).Sell_Out_Factor__c;
                Decimal sp = unitp*max + (unitp*max*sellout/100);
                Decimal mp = unitp - (unitp*minprice/100);
                skui.min_prc = String.valueOf(mp.setScale(2)).replace('.',',');
                skui.sellOutPrice = String.valueOf(sp.setScale(2)).replace('.',',');
                Decimal spu = unitpu*max + (unitpu*max*selloutu/100);
                Decimal mpu = unitpu - (unitpu*minpriceu/100);
                skui.min_prc_u = String.valueOf(mpu.setScale(2)).replace('.',',');
                skui.sellOutPriceU = String.valueOf(spu.setScale(2)).replace('.',',');
                skui.GM = gm;
                skui.GMU = gmu;
                skui.selloutType = smap.get(typeb).Type__c;
                skui.selloutTypeU = smap.get(typeu).Type__c;
                skui.SelloutFactor = smap.get(typeb).Sell_Out_Factor__c;
                skui.SelloutFactorU = smap.get(typeu).Sell_Out_Factor__c;
                skui.MinPriceFactor = smap.get(typeb).Min_Price_Factor__c;
                skui.MinPriceFactorU =smap.get(typeu).Min_Price_Factor__c;
            }
        }
        system.debug('skulstretrun:'+skulst);
        // end
        return skulst;
    }
    public class cultureWrapper{
        @AuraEnabled
            public String Id{get;set;}
            @AuraEnabled
            public String Name{get;set;}
             @AuraEnabled
            public String cultureCode{get;set;}
             @AuraEnabled
            public boolean check{get;set;}
            
  
       
        
    }
}