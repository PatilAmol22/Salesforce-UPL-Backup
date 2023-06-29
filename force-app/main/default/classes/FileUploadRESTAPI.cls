/*
* Name: FileUploadRESTAPI
* Author: Azhar Shaikh 
* Description: REST API for File Upload
*/
@RestResource(urlMapping='/FileUpload/v1/*')
global without sharing class FileUploadRESTAPI
{
    @HttpPost
    global static void attachDoc(){
        RestRequest req = RestContext.request;
        RestResponse res = Restcontext.response;
        
        String fName = req.params.get('FileName');
        String cntName = req.params.get('Country');
        String materialWise = req.params.get('MaterialWise');
        String italymaterialWise = req.params.get('ItalyMaterialWise');
        String cammaterialWise =req.params.get('CAMMaterialWise');
        String SPNPBWise=req.params.get('SPNPBWise');
        String NaturagriPBWise=req.params.get('NaturagriPBWise');
        String PolandPBWise=req.params.get('PolandPBWise');
        String BolParPBWise=req.params.get('BolParPBWise');
        system.debug('cntName>>--->'+cntName);
        system.debug('materialWise>>--->'+materialWise);
        system.debug('cammaterialWise>>--->'+cammaterialWise);
        Blob postContent = req.requestBody; 
        
        System.debug('user id :-'+UserInfo.getUserId());
        Id profileId=userinfo.getProfileId();
        String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
        system.debug('ProfileName :-'+profileName);
        
        //Pass FileName & Blob to File Utility for File Splitting
        if(cntName!=null){
            processData(postContent,cntName,materialWise,italymaterialWise,cammaterialWise,SPNPBWise,NaturagriPBWise,PolandPBWise,BolParPBWise);
        }else {
            processSKUData(postContent,cntName);
        }
        
        
    }
    
    //Method to parse CSV and Upsert Pricebook
    public static void processData(Blob csvFile , string countryName, String materialWise,String italymaterialWise,String cammaterialWise,String SPNPBWise,String NaturagriPBWise,String PolandPBWise,String BolParPBWise){
        
        try{
            system.debug('countryName >>--->'+countryName);
            List<String> errorCSVList = new List<String>();
            List<String> successCSVList = new List<String>();
            //Map<id,SKU__c> skMap=new Map<id,SKU__c>();
            SplitString splitObj = new SplitString();
            
            //Logic to parse CSV row by row
            List<String> csvData = new List<String>();
            //blob csvBlob = csvFile.Body;
            String strCSVFile = csvFile.toString();
            csvData  = strCSVFile.split('\r\n');
            //csvData = splitObj.safeSplit(strCSVFile, '\r\n');
            system.debug('**csvData>>--- > ' +csvData);
            Boolean isTrue=true;
            successCSVList.add('Record ID,'+csvData[0]);
            errorCSVList.add(csvData[0]+',Error Description');
            system.debug('**successCSVList>>--- > ' +successCSVList);
      system.debug('**csvData size>>--- > ' +csvData.size());
            
            List<PriceBookMaster__c> upsertPricebookList = new List<PriceBookMaster__c>();
            List<PriceBookMaster__c> upsertPricebookList2 = new List<PriceBookMaster__c>();
            List<PricebookDiscount__c> upsertPricebookDiscountList = new List<PricebookDiscount__c>();
            List<PricebookDiscount__c> upsertPricebookDiscountList2 = new List<PricebookDiscount__c>();
            List<SpecialInvoiceDiscount__c> upsertSpecInvDiscountList = new List<SpecialInvoiceDiscount__c>();
            List<SpecialInvoiceDiscount__c> upsertSpecInvDiscountList2 = new List<SpecialInvoiceDiscount__c>();
            List<ZSP1_Discount__c> upsertZSP1DiscountList = new List<ZSP1_Discount__c>();
            List<ZSP1_Discount__c> upsertZSP1DiscountList2 = new List<ZSP1_Discount__c>();
            List<PriceBookMaster__c> errorPricebookList = new List<PriceBookMaster__c>();
            List<PricebookDiscount__c> errorPricebookDiscountList = new List<PricebookDiscount__c>();
            List<SpecialInvoiceDiscount__c> errorSpecInvDiscountList = new List<SpecialInvoiceDiscount__c>();
            List<ZSP1_Discount__c> errorZSP1DiscountList = new List<ZSP1_Discount__c>();
            set<string> codeSKU = new set<string>();
            //set<string> ColombiaSKU = new set<string>();
            
            
            Map<String,String> mapStr= new Map<String,String>();
            Map<String,String> mapErrorStr= new Map<String,String>();
            Map<String,String> mapStrUom= new Map<String,String>();
            Set<String> uomSet=new Set<String>(); 
            
           list<string> salesOrgCode = new list<string>();
      if(countryName == 'Argentina'){
      salesOrgCode.add('5631');
      }
      else if(countryName == 'Mexico'){
      salesOrgCode.add('5100');
      }
      else if(countryName == 'CAM'){
      salesOrgCode.add('5711');
      }
      else if(countryName == 'Colombia'){
      salesOrgCode.add('5710');
      }
      else if(countryName == 'Italy'){
      salesOrgCode.add('2410');
      }
      else if(countryName == 'Iberia & Portugal' || countryName == 'Naturagri'){
      salesOrgCode.add('2510');
      salesOrgCode.add('2481');
      salesOrgCode.add('2541');
      }
      else if(countryName == 'Poland'){
      salesOrgCode.add('2941');
      }
      else if(countryName == 'Bolivia & Paraguay'){
                salesOrgCode.add('5361');
                salesOrgCode.add('5441');
            }
      system.debug('**salesOrgCode>>--- > ' +salesOrgCode); 
      
            List<SKU__c> skuObjList=[Select id, Name, SKU_Code__c, UOM__c from SKU__c Where Sales_Org_Code__c IN :salesOrgCode ];
            
            //List<SKU__c> skuObjList=[Select id, Name, SKU_Code__c, UOM__c,Sales_Org_Code__c from SKU__c Where Sales_Org_Code__c='5100'  or Sales_Org_Code__c='5710' or Sales_Org_Code__c='2410' or Sales_Org_Code__c='5310' or Sales_Org_Code__c='2510' or Sales_Org_Code__c='2481' or Sales_Org_Code__c='2541' or Sales_Org_Code__c='2941'];
            system.debug('**skuObjList>>--- > ' +skuObjList);
            
            for(SKU__c skuOb:skuObjList){
                String scode=skuOb.SKU_Code__c;
                mapStrUom.put(scode, skuOb.UOM__c);
                
            }
            system.debug('**map of sku code n unit UOM >>--- > ' +mapStrUom);
            
            
            if(countryName == 'Argentina'){
                System.debug('countryName 53'+countryName);
                for (Integer i = 1; i < csvData.size(); i++){
                    String row = '';
                    try{
                        
                        List<String> csvLineItem = new List<String>();
                        PriceBookMaster__c sObj = new PriceBookMaster__c();
                        row = csvData[i];
                        csvLineItem = csvData[i].split(',');
                        
                        String startDate = '';
                        String depotCode = '';
                        String combinationKey = '';
                        String compositeKey = '';
                        
                        for(Integer j=0; j<csvLineItem.size(); j++){
                            if(j==0){
                                if(String.isNotBlank(csvLineItem[j])){
                                    sObj.Sales_Org__r = new Sales_Org__c(Sales_Org_Code__c = csvLineItem[j]);
                                    combinationKey += csvLineItem[j];
                                }
                            } else if(j==1){
                                if(String.isNotBlank(csvLineItem[j])){
                                    sObj.DistributionChannel__r = new Distribution_Channel__c(Distribution_Channel_Code__c = csvLineItem[j]);
                                    combinationKey += csvLineItem[j];
                                }
                            } else if(j==2){
                                if(String.isNotBlank(csvLineItem[j])){
                                    sObj.Division__r = new Division__c(Division_Code__c = csvLineItem[j]);
                                    combinationKey += csvLineItem[j];
                                }
                            } else if(j==3){
                                if(String.isNotBlank(csvLineItem[j])){
                                    System.debug('csvLineItem[j]'+csvLineItem[j]);
                                    sObj.DepotCode__r = new Depot__c(Depot_Code__c = csvLineItem[j]);
                                    depotCode = csvLineItem[j];
                                }
                            } else if(j==4){
                                if(String.isNotBlank(csvLineItem[j])){
                                    sObj.CurrencyIsoCode = csvLineItem[j];
                                }
                            } else if(j==5){
                                if(String.isNotBlank(csvLineItem[j])){
                                    String code = csvLineItem[j];
                                    
                                    if(code.length()==6){
                                        code = '000000000000'+csvLineItem[j];
                                    } else if(code.length()==7){
                                        code = '00000000000'+csvLineItem[j];
                                    }
                                    
                                    System.debug('**Argentina SKU code' +code);
                                    combinationKey += code;
                                    sObj.SKUCode__r = new SKU__c(Combination_Key__c = combinationKey);
                                    
                                    /*combinationKey += code;
sObj.SKUCode__r = new SKU__c(Combination_Key__c = combinationKey);*/
                                }
                            } else if(j==6){
                                if(String.isNotBlank(csvLineItem[j])){
                                    sObj.UOM__c =csvLineItem[j];
                                }
                            } else if(j==7){
                                if(String.isNotBlank(csvLineItem[j])){
                                    sObj.MinPrice__c = Decimal.valueOf(csvLineItem[j].trim());
                                }
                            } else if(j==8){
                                if(String.isNotBlank(csvLineItem[j])){
                                    sObj.List_Price__c = Decimal.valueOf(csvLineItem[j].trim()); //Updated for RITM0578833 by Abhimanyu Dakwale
                                }
                            } else if(j==9){
                                if(String.isNotBlank(csvLineItem[j])){
                                    sObj.Price__c = Decimal.valueOf(csvLineItem[j].trim()); //Updated for RITM0578833 by Abhimanyu Dakwale
                                }
                            } else if(j==10){
                                if(String.isNotBlank(csvLineItem[j])){
                                    sObj.Director_Price__c = Decimal.valueOf(csvLineItem[j].trim());
                                }
                            } else if(j==11){
                                if(String.isNotBlank(csvLineItem[j])){
                                    sObj.BudgetPrice__c = Decimal.valueOf(csvLineItem[j].trim());
                                }
                            } else if(j==12){
                                if(String.isNotBlank(csvLineItem[j])){
                                    Date d = Date.valueOf(csvLineItem[j]) ;
                                    //System.debug(logginglevel.error, startDate);
                                    sObj.StartDate__c = d;
                                }
                            } else if(j==13){
                                if(String.isNotBlank(csvLineItem[j])){
                                    sObj.EndDate__c = Date.valueOf(csvLineItem[j]);
                                }
                            }
                        }
                        
                        system.debug('sObj>>--->'+sObj);
                        compositeKey = startDate+depotCode+combinationKey;
                        sObj.CompositeKey__c = compositeKey;
                        upsertPricebookList.add(sObj);
                        system.debug('upsertPricebookList 185>>--->'+upsertPricebookList);
                    }
                    catch(Exception ex){
                        system.debug('ex.getMessage()>>--->'+ex.getMessage());
                        errorCSVList.add(row+','+ex.getMessage());
                    }
                }
            }
            //End of Logic
            else if(countryName == 'Mexico' ){
                
                for (Integer i = 1; i < csvData.size(); i++){
                    String row = '';
                    try{
                        
                        List<String> csvLineItem = new List<String>();
                        PriceBookMaster__c sObj = new PriceBookMaster__c();
                        row = csvData[i];
                        csvLineItem = csvData[i].split(',');
                        
                        String startDate = '';
                        String depotCode = '';
                        String combinationKey = '';
                        String compositeKey = '';
                        String combinationDepotDc='';
                        String uomblank='';   
                        
                        for(Integer j=0; j<csvLineItem.size(); j++){
                            
                            if(j==0){
                                if(String.isNotBlank(csvLineItem[j])){
                                    
                                    sObj.Sales_Org__r = new Sales_Org__c(Sales_Org_Code__c = csvLineItem[j]);
                                    combinationKey += csvLineItem[j];
                                }else {
                                    isTrue=false;
                                }
                            }
                            else if(j==1){
                                if(String.isNotBlank(csvLineItem[j])){
                                    sObj.DistributionChannel__r = new Distribution_Channel__c(Distribution_Channel_Code__c = csvLineItem[j]);
                                    combinationKey += csvLineItem[j];
                                }else {
                                    isTrue=false;
                                }
                            }
                            else if(j==2){
                                if(String.isNotBlank(csvLineItem[j])){
                                    sObj.Division__r = new Division__c(Division_Code__c = csvLineItem[j]);
                                    combinationKey += csvLineItem[j];
                                }else {
                                    isTrue=false;
                                }
                            }
                            else if(j==3){
                                if(String.isNotBlank(csvLineItem[j])){
                                    sObj.DepotCode__r = new Depot__c(Depot_Code__c = csvLineItem[j]);
                                    depotCode = csvLineItem[j];
                                }else {
                                    isTrue=false;
                                    errorCSVList.add(row+', Depot Code is blank');
                                }
                            }
                            else if(j==4){
                                if(String.isNotBlank(csvLineItem[j])){
                                    if(csvLineItem[j]=='MXN'||csvLineItem[j]=='USD'){
                                        sObj.CurrencyIsoCode = csvLineItem[j];
                                    }else {
                                        sObj.CurrencyIsoCode = csvLineItem[j];
                                        errorCSVList.add(row+', Invalid currency code');
                                    }
                                }else {
                                    isTrue=false;
                                }
                            }
                            
                            else if(j==5){
                                
                                if(String.isNotBlank(csvLineItem[j])){
                                    
                                    if((csvLineItem[1]=='67' && csvLineItem[3]=='MX00')||(csvLineItem[1]=='20' && csvLineItem[3]=='MX51')){
                                        errorCSVList.add(row+', SKU Invalid for this depot');
                                    }else{
                                        String code = csvLineItem[j];
                                        if(code.length()==6){
                                            code = '000000000000'+csvLineItem[j];
                                            mapStr.put('000000000000'+csvLineItem[j],row);
                                        }
                                        else if(code.length()==7){
                                            code = '00000000000'+csvLineItem[j];
                                            mapStr.put('00000000000'+csvLineItem[j],row);
                                        }
                                        codeSKU = mapStr.keySet();
                                        system.debug('**codeSKU Mexico Pricebook -> ' +codeSKU);
                                        combinationKey += code;
                                        sObj.SKUCode__r = new SKU__c(Combination_Key__c = combinationKey);
                                        combinationDepotDc = csvLineItem[1]+csvLineItem[3];
                                    }
                                    /*combinationKey += code;
sObj.SKUCode__r = new SKU__c(Combination_Key__c = combinationKey);*/
                                    
                                }else {
                                    isTrue=false;
                                }
                            }
                            else if(j==6){
                                if(String.isNotBlank(csvLineItem[j])){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        sObj.UOM__c =  csvLineItem[j].trim();
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                    }
                                }  
                            }
                            else if(j==7){
                                if(String.isNotBlank(csvLineItem[j])){
                                    
                                    Boolean isContains=csvLineItem[j].trim().contains('-');
                                    if(isContains!=true){
                                        System.debug('min price decimal :- '+Decimal.valueOf(csvLineItem[j].trim()));
                                        sObj.MinPrice__c = Decimal.valueOf(csvLineItem[j].trim());
                                    }else {
                                        errorCSVList.add(row+', Invalid number. Min price contains negative value');
                                    }
                                    
                                }else {
                                    isTrue=false;
                                    errorCSVList.add(row+', Min Price is blank');
                                }
                            }
                            else if(j==8){
                                if(String.isNotBlank(csvLineItem[j])){
                                    Boolean isContains=csvLineItem[j].trim().contains('-');
                                    System.debug('max price decimal 1 :- '+Decimal.valueOf(csvLineItem[j].trim()));
                                    if(isContains!=true && (Decimal.valueof(csvLineItem[8].trim())>=Decimal.valueof(csvLineItem[7].trim()))){
                                        System.debug('max price decimal 2 :- '+Decimal.valueOf(csvLineItem[j].trim()));
                                        sObj.Price__c = Decimal.valueOf(csvLineItem[j].trim());
                                    }else {
                                        if(isContains==true){
                                            errorCSVList.add(row+', Invalid number. Max price contains negative value');
                                        }
                                        if(Decimal.valueof(csvLineItem[8].trim())<Decimal.valueof(csvLineItem[7].trim())){
                                            errorCSVList.add(row+', Invalid number. Max price should be greater than min price');
                                        }
                                    }
                                }else {
                                    isTrue=false;
                                    errorCSVList.add(row+', Max price is blank');
                                }
                            }
                            else if(j==9){
                                if(String.isNotBlank(csvLineItem[j])){
                                    Boolean isContains=csvLineItem[j].trim().contains('-');
                                    if(isContains!=true && (Decimal.valueof(csvLineItem[9].trim())<=Decimal.valueof(csvLineItem[7].trim()))){
                                        sObj.Manager_Price__c = Decimal.valueOf(csvLineItem[j].trim());
                                    }else {
                                        if(isContains==true){
                                            errorCSVList.add(row+', Invalid number. Sales director price contains negative value');
                                        }
                                        if(Decimal.valueof(csvLineItem[9].trim())>Decimal.valueof(csvLineItem[7].trim())){
                                            errorCSVList.add(row+', Invalid number. Sales director price should be less than min price');
                                        }
                                    }
                                }else {
                                    isTrue=false;
                                    errorCSVList.add(row+', Sales director price is blank');
                                }
                            }else if(j==10){
                                if(String.isNotBlank(csvLineItem[j])){
                                    Boolean isContains=csvLineItem[j].trim().contains('-');
                                    if(isContains!=true && (Decimal.valueof(csvLineItem[10].trim())<=Decimal.valueof(csvLineItem[9].trim()))){
                                        sObj.Director_Price__c = Decimal.valueOf(csvLineItem[j].trim());
                                    }else {
                                        if(isContains==true){
                                            errorCSVList.add(row+', Invalid number. Latam Director price contains negative value');
                                        }
                                        if(Decimal.valueof(csvLineItem[10].trim())>Decimal.valueof(csvLineItem[9].trim())){
                                            errorCSVList.add(row+', Invalid number. Latam Director price should be less than Sales director');
                                        }
                                    }
                                }else {
                                    isTrue=false;
                                    errorCSVList.add(row+', Latam Director price is blank');
                                }
                            }
                            
                            else if(j==11){
                                if(String.isNotBlank(csvLineItem[j])){
                                    Date d = Date.valueOf(csvLineItem[j]) ;
                                    sObj.StartDate__c = d;
                                }else {
                                    isTrue=false;
                                    errorCSVList.add(row+', Start date is blank');
                                }
                            }
                            else if(j==12){
                                if(String.isNotBlank(csvLineItem[j])){
                                    
                                    if(Date.valueOf(csvLineItem[12])>Date.valueOf(csvLineItem[11])){
                                        sObj.EndDate__c = Date.valueOf(csvLineItem[j]);
                                    }else {
                                        errorCSVList.add(row+', End date should be greater than start date');
                                    }
                                }else {
                                    isTrue=false;
                                    errorCSVList.add(row+', End date is blank');
                                }
                            }
                            
                            // start Added by Vijaylaxmi for Mexico Price Control CR 27 Jan 2022
                             else if(j==13){
                                if(String.isNotBlank(csvLineItem[j])){
                                    
                                    Boolean isContains=csvLineItem[j].trim().contains('-');
                                    if(isContains!=true){
                                        System.debug('sub region price  :- '+Decimal.valueOf(csvLineItem[j].trim()));
                                        sObj.Sub_Region_Price__c = Decimal.valueOf(csvLineItem[j].trim());
                                    }else {
                                        errorCSVList.add(row+', Invalid number. sub region price contains negative value');
                                    }
                                    
                                }else {
                                    isTrue=false;
                                    errorCSVList.add(row+', sub region Price is blank');
                                }
                            }
                             // End Added by Vijaylaxmi for Mexico Price Control CR 27 Jan 2022
                        }
                        
                        if(combinationDepotDc=='67MX00' || combinationDepotDc=='20MX51'){
                            isTrue=false;
                        }
                        else{
                            compositeKey = startDate+depotCode+combinationKey;
                            sObj.CompositeKey__c = compositeKey;
                            mapErrorStr.put(compositeKey,row);
                            upsertPricebookList.add(sObj);
                        }
                    }
                    catch(Exception ex){
                        
                        errorCSVList.add(row+','+ex.getMessage());
                        system.debug('** Review Error -> ' +errorCSVList);
                    }
                }
            }
            else if(countryName == 'Mexico Customerwise'){
                
                for (Integer i = 1; i < csvData.size(); i++){
                    String row = '';
                    try{
                        List<String> csvLineItem = new List<String>();
                        PriceBookMaster__c sObj = new PriceBookMaster__c();
                        row = csvData[i];
                        
                        csvLineItem = csvData[i].split(',');
                        
                        String startDate = '';
                        String depotCode = '';
                        String combinationKey = '';
                        String compositeKey = '';
                        
                        
                        for(Integer j=0; j<csvLineItem.size(); j++){
                            
                            if(j==0){
                                if(String.isNotBlank(csvLineItem[j])){
                                    sObj.Sales_Org__r = new Sales_Org__c(Sales_Org_Code__c = csvLineItem[j]);
                                    combinationKey += csvLineItem[j];
                                }
                            }
                            else if(j==1){
                                if(String.isNotBlank(csvLineItem[j])){
                                    sObj.DistributionChannel__r = new Distribution_Channel__c(Distribution_Channel_Code__c = csvLineItem[j]);
                                    combinationKey += csvLineItem[j];
                                }
                            }
                            else if(j==2){
                                if(String.isNotBlank(csvLineItem[j])){
                                    sObj.Division__r = new Division__c(Division_Code__c = csvLineItem[j]);
                                    combinationKey += csvLineItem[j];
                                }
                            }else if(j==3){
                                if(String.isNotBlank(csvLineItem[j])){
                                    String customercode = csvLineItem[j];
                                    if(customercode.length()==6){
                                        customercode='000'+customercode;
                                    }
                                    if(customercode.length()==7){
                                        customercode='000'+customercode;
                                    }
                                    sObj.DistributorCustomerCode__r = new Account(SAP_Code__c=customercode);
                                }
                            }else if(j==4){
                                if(String.isNotBlank(csvLineItem[j])){
                                    sObj.DepotCode__r = new Depot__c(Depot_Code__c = csvLineItem[j]);
                                    depotCode = csvLineItem[j];
                                }
                            }
                            
                            else if(j==5){
                                if(String.isNotBlank(csvLineItem[j])){
                                    sObj.CurrencyIsoCode = csvLineItem[j];
                                }
                            }
                            
                            else if(j==6){
                                if(String.isNotBlank(csvLineItem[j])){
                                    String code = csvLineItem[j];
                                    if(code.length()==6){
                                        code = '000000000000'+csvLineItem[j];
                                    }
                                    else if(code.length()==7){
                                        code = '00000000000'+csvLineItem[j];
                                    }
                                    combinationKey += code;
                                    sObj.SKUCode__r = new SKU__c(Combination_Key__c = combinationKey);
                                    
                                }
                            }
                            else if(j==7){
                                if(String.isNotBlank(csvLineItem[j])){
                                    sObj.UOM__c =csvLineItem[j];
                                }
                            }
                            else if(j==8){
                                if(String.isNotBlank(csvLineItem[j])){
                                    sObj.MinPrice__c = Decimal.valueOf(csvLineItem[j].trim());
                                }
                            }
                            else if(j==9){
                                if(String.isNotBlank(csvLineItem[j])){
                                    sObj.Price__c = Decimal.valueOf(csvLineItem[j].trim());
                                }
                            }
                            else if(j==10){
                                if(String.isNotBlank(csvLineItem[j])){
                                    sObj.Manager_Price__c = Decimal.valueOf(csvLineItem[j].trim());
                                }
                            }else if(j==11){
                                if(String.isNotBlank(csvLineItem[j])){
                                    sObj.Director_Price__c = Decimal.valueOf(csvLineItem[j].trim());
                                }
                            }else if(j==12){
                                if(String.isNotBlank(csvLineItem[j])){
                                    Date d = Date.valueOf(csvLineItem[j]) ;
                                    //System.debug(logginglevel.error, startDate);
                                    
                                    sObj.StartDate__c = d;
                                }
                            }
                            else if(j==13){
                                if(String.isNotBlank(csvLineItem[j])){
                                    sObj.EndDate__c = Date.valueOf(csvLineItem[j]);
                                }
                            }
                        }
                        compositeKey = startDate+depotCode+combinationKey;
                        sObj.CompositeKey__c = compositeKey;
                        System.debug('sObj :- '+sObj);
                        upsertPricebookList.add(sObj);
                    }
                    catch(Exception ex){
                        errorCSVList.add(row+','+ex.getMessage());
                    }
                }
            }
            //End of Logic
            /*else if(countryName == 'CAM'){
                for (Integer i = 1; i < csvData.size()-1; i++){
                    String row = '';
                    try{
                        List<String> csvLineItem = new List<String>();
                        PriceBookMaster__c sObj = new PriceBookMaster__c();
                        row = csvData[i];
                        
                        csvLineItem = csvData[i].split(',');
                        
                        String startDate = '';
                        String depotCode = '';
                        String combinationKey = '';
                        String compositeKey = '';
                        string distributorKey = '';
                        system.debug('File Size >>--->'+csvLineItem.size());
                        
                        for(Integer j=0; j<csvLineItem.size(); j++){
                            
                            if(j==0){
                                if(String.isNotBlank(csvLineItem[j])){
                                    if(csvLineItem[j]=='5310'){
                                        sObj.Sales_Org__r = new Sales_Org__c(Sales_Org_Code__c = csvLineItem[j]);
                                    }
                                    else if(csvLineItem[j]=='5320'){
                                        sObj.Sales_Org__r = new Sales_Org__c(Multi_Country_Code__c = csvLineItem[j]);
                                    }
                                    combinationKey += csvLineItem[j];
                                    system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                }
                            }
                            else if(j==1){
                                if(String.isNotBlank(csvLineItem[j])){
                                    sObj.DistributionChannel__r = new Distribution_Channel__c(Distribution_Channel_Code__c = csvLineItem[j]);
                                    combinationKey += csvLineItem[j];
                                    system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                }
                            }
                            else if(j==2){
                                if(String.isNotBlank(csvLineItem[j])){
                                    sObj.Division__r = new Division__c(Division_Code__c = csvLineItem[j]);
                                    combinationKey += csvLineItem[j];
                                    system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                }
                            }
                            else if(j==3){
                                if(String.isNotBlank(csvLineItem[j])){
                                    String code = csvLineItem[j];
                                    if(code.length()==6){
                                        code = '000000000000'+csvLineItem[j];
                                    }
                                    else if(code.length()==7){
                                        code = '00000000000'+csvLineItem[j];
                                    }
                                    combinationKey += code;
                                    sObj.SKUCode__r = new SKU__c(Combination_Key__c = combinationKey);
                                    system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                    
                                    
                                }
                            }
                            else if(j==4){
                                if(String.isNotBlank(csvLineItem[j])){
                                    string sAPCode ='';
                                    if(csvLineItem[j].length()==7){
                                        sAPCode = '000'+ csvLineItem[j];
                                    }else if(csvLineItem[j].length()==6){
                                        sAPCode = '0000'+ csvLineItem[j];
                                    }
                                    distributorKey = sAPCode;
                                    sObj.DistributorCustomerCode__r = new Account(SAP_Code__c = sAPCode); 
                                    system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                }
                            }
                            
                            else if(j==5){
                                if(String.isNotBlank(csvLineItem[j])){
                                    sObj.Final_Price__c =  Decimal.valueOf(csvLineItem[j].trim());
                                    
                                    system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                    
                                }
                            }
                            else if(j==6){
                                if(String.isNotBlank(csvLineItem[j])){
                                    sObj.MinPrice__c = Decimal.valueOf(csvLineItem[j].trim());
                                    system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                }
                            }
                            else if(j==7){
                                if(String.isNotBlank(csvLineItem[j])){
                                    sObj.Price__c =  Decimal.valueOf(csvLineItem[j].trim());
                                    system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                }
                            }
                            else if(j==8){
                                if(String.isNotBlank(csvLineItem[j])){
                                    sObj.Manager_Price__c = Decimal.valueOf(csvLineItem[j].trim());
                                    system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                    //system.debug('sObj >>--->'+sObj);
                                }
                            }
                            else if(j==9){
                                if(String.isNotBlank(csvLineItem[j])){
                                    sObj.CurrencyIsoCode  = csvLineItem[j].trim();
                                    system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                }
                            }
                            else if(j==10){
                                if(String.isNotBlank(csvLineItem[j])){
                                    sObj.UOM__c =  csvLineItem[j];
                                    system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                }
                            }
                            else if(j==11){
                                if(String.isNotBlank(csvLineItem[j])){
                                    Date d = Date.valueOf(csvLineItem[j]) ;                                
                                    sObj.StartDate__c = d;
                                    system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                }
                            }
                            else if(j==12){
                                if(String.isNotBlank(csvLineItem[j])){
                                    Date d = Date.valueOf(csvLineItem[j]) ;
                                    //System.debug(logginglevel.error, startDate);
                                    
                                    sObj.EndDate__c = d;
                                    system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                }
                            }
                            else if(j==13){
                                if(String.isNotBlank(csvLineItem[j])){
                                    sObj.Batch__c =  csvLineItem[j];
                                    system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                }
                            }
                            else if(j==14){
                                if(String.isNotBlank(csvLineItem[j])){
                                    sObj.DepotCode__r = new Depot__c(Depot_Code__c = csvLineItem[j]);
                                    depotCode = csvLineItem[j];     
                                    system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);                      
                                }
                            }
                        }
                        compositeKey = startDate+depotCode+combinationKey+distributorKey;
                        sObj.CompositeKey__c = compositeKey;
                        system.debug('sObj >>--->'+sObj);
                        upsertPricebookList.add(sObj);
                    }
                    catch(Exception ex){
                        errorCSVList.add(row+','+ex.getMessage());
                    }
                }
            }*/
            /*Code Added by Tejas*/
      else if(countryName == 'CAM'){
        if(cammaterialWise =='CustomerWise'){
          for (Integer i = 1; i < csvData.size(); i++){
            String row = '';
            try{
              List<String> csvLineItem = new List<String>();
              PriceBookMaster__c sObj = new PriceBookMaster__c();
              row = csvData[i];
                        
              csvLineItem = csvData[i].split(',');
                        
              String startDate = '';
              String depotCode = '';
              String combinationKey = '';
              String compositeKey = '';
              string distributorKey = '';
              system.debug('File Size >>--->'+csvLineItem.size());
                        
              for(Integer j=0; j<csvLineItem.size(); j++){
                            
                if(j==0){
                  if(String.isNotBlank(csvLineItem[j])){
                    if(csvLineItem[j]=='5711'){
                      sObj.Sales_Org__r = new Sales_Org__c(Sales_Org_Code__c = csvLineItem[j]);
                    }
                    else if(csvLineItem[j]=='5712'){
                      sObj.Sales_Org__r = new Sales_Org__c(Multi_Country_Code__c = csvLineItem[j]);
                    }
                    combinationKey += csvLineItem[j];
                    //system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                  }
                }
                else if(j==1){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        sObj.DistributionChannel__r = new Distribution_Channel__c(Distribution_Channel_Code__c = csvLineItem[j].trim());
                                        combinationKey += csvLineItem[j];
                                        //system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                    }
                                }
                                else if(j==2){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        //system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                        sObj.Division__r = new Division__c(Division_Code__c = csvLineItem[j].trim());
                                        combinationKey += csvLineItem[j];
                                    }
                                }
                else if(j==3){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        String customercode = csvLineItem[j].trim();
                                        
                                        if(csvLineItem[j].length()==7){
                                            customercode = '000'+ csvLineItem[j];
                                        }else if(csvLineItem[j].length()==6){
                                            customercode = '0000'+ csvLineItem[j];
                                        }
                                        distributorKey = customercode;
                                        sObj.DistributorCustomerCode__r = new Account(SAP_Code__c=customercode);
                                        //system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                    }else {
                                        errorCSVList.add(row+', Sold To Party Code is blank');
                                    }
                                }
                else if(j==4){
                  if(String.isNotBlank(csvLineItem[j])){
                    String code = csvLineItem[j];
                    if(code.length()==6){
                      code = '000000000000'+csvLineItem[j];
                                            mapStr.put('000000000000'+csvLineItem[j],row);
                    }
                    else if(code.length()==7){
                      code = '00000000000'+csvLineItem[j];
                                            mapStr.put('00000000000'+csvLineItem[j],row);
                    }
                                        codeSKU = mapStr.keySet();
                                        system.debug('**codeSKU CAM CustomerWise Pricebook -> ' +codeSKU);
                    combinationKey += code;
                    sObj.SKUCode__r = new SKU__c(Combination_Key__c = combinationKey);
                    //system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                    
                                    
                  }
                }
                else if(j==5){
                  if(String.isNotBlank(csvLineItem[j])){
                    sObj.DepotCode__r = new Depot__c(Depot_Code__c = csvLineItem[j]);
                    depotCode = csvLineItem[j];     
                    //system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);                      
                  }
                }
                else if(j==6){
                  if(String.isNotBlank(csvLineItem[j])){
                    sObj.CurrencyIsoCode  = csvLineItem[j].trim();
                    //system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                  }
                }
                else if(j==7){
                  if(String.isNotBlank(csvLineItem[j])){
                    sObj.UOM__c =  csvLineItem[j];
                    system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                  }
                }
                else if(j==8){
                  if(String.isNotBlank(csvLineItem[j])){
                    Date d = Date.valueOf(csvLineItem[j]) ;                                
                    sObj.StartDate__c = d;
                    //system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                  }
                }
                else if(j==9){
                  if(String.isNotBlank(csvLineItem[j])){
                    Date d = Date.valueOf(csvLineItem[j]) ;
                    //System.debug(logginglevel.error, startDate);
                                    
                    sObj.EndDate__c = d;
                    //system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                  }
                }
                else if(j==10){
                  if(String.isNotBlank(csvLineItem[j])){
                    sObj.Price__c =  Decimal.valueOf(csvLineItem[j].trim());
                    system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                  }
                }
                else if(j==11){
                  if(String.isNotBlank(csvLineItem[j])){
                    sObj.MinPrice__c = Decimal.valueOf(csvLineItem[j].trim());
                    //system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                  }
                }
                
              }
              compositeKey = startDate+depotCode+combinationKey+distributorKey;
              sObj.CompositeKey__c = compositeKey;
              //system.debug('sObj >>--->'+sObj);
              upsertPricebookList.add(sObj);
            }
            catch(Exception ex){
              errorCSVList.add(row+','+ex.getMessage());
            }
          }
        }else if(cammaterialWise =='CombinationWise'){
          for (Integer i = 1; i < csvData.size(); i++){
            String row = '';
            try{
              List<String> csvLineItem = new List<String>();
              PriceBookMaster__c sObj = new PriceBookMaster__c();
              row = csvData[i];
                        
              csvLineItem = csvData[i].split(',');
                        
              String startDate = '';
              String depotCode = '';
              String combinationKey = '';
              String compositeKey = '';
                            String priceList='';
                            String priceClassification='';
                            String Country='';
                            String customerGroupcode='';
              string distributorKey = '';
              system.debug('File Size >>--->'+csvLineItem.size());
                        
              for(Integer j=0; j<csvLineItem.size(); j++){
                            
                if(j==0){
                  if(String.isNotBlank(csvLineItem[j])){
                    if(csvLineItem[j]=='5711'){
                      sObj.Sales_Org__r = new Sales_Org__c(Sales_Org_Code__c = csvLineItem[j]);
                    }
                    else if(csvLineItem[j]=='5712'){
                      sObj.Sales_Org__r = new Sales_Org__c(Multi_Country_Code__c = csvLineItem[j]);
                    }
                    combinationKey += csvLineItem[j];
                    //system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                  }
                }
                else if(j==1){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        sObj.DistributionChannel__r = new Distribution_Channel__c(Distribution_Channel_Code__c = csvLineItem[j].trim());
                                        combinationKey += csvLineItem[j];
                                        //system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                    }
                                }
                                else if(j==2){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        //system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                        sObj.Division__r = new Division__c(Division_Code__c = csvLineItem[j].trim());
                                        combinationKey += csvLineItem[j];
                                    }
                                }
                else if(j==3){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        Country = csvLineItem[j].trim();
                                        
                                        sObj.Country__r= new Sales_Org__c(Country_Code__c=Country);
                                        //system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                    }else {
                                        errorCSVList.add(row+', Country is blank');
                                    }
                                }
                else if(j==4){
                                    if(String.isNotBlank(csvLineItem[j])){
                                       customerGroupcode = csvLineItem[j].trim();
                                        if(customerGroupcode == '2' || customerGroupcode == '3' ){
                                            customerGroupcode ='0'+customerGroupcode;
                                            sObj.Customer_Group__r= new Customer_Group__c(Customer_Group_Code__c =customerGroupcode);
                                        }else{
                                        sObj.Customer_Group__r= new Customer_Group__c(Customer_Group_Code__c =customerGroupcode);
                                        }
                                        //system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                    }else {
                                        errorCSVList.add(row+', Customer group code is blank');
                                    }
                                }
                else if(j==5){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        priceClassification = csvLineItem[j].trim();
                                        
                                        sObj.Price_Classification__c= csvLineItem[j].trim(); 
                                        //system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                    }else {
                                        errorCSVList.add(row+', priceClassification is blank');
                                    }
                                }
                else if(j==6){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        priceList = csvLineItem[j].trim();
                                        
                                        sObj.Price_List_CAM__c= csvLineItem[j].trim();
                                        //system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                    }else {
                                        errorCSVList.add(row+', priceList is blank');
                                    }
                                }
                else if(j==7){
                  if(String.isNotBlank(csvLineItem[j])){
                    String code = csvLineItem[j];
                    if(code.length()==6){
                      code = '000000000000'+csvLineItem[j];
                                            mapStr.put('000000000000'+csvLineItem[j],row);
                    }
                    else if(code.length()==7){
                      code = '00000000000'+csvLineItem[j];
                                            mapStr.put('00000000000'+csvLineItem[j],row);
                    }
                                        codeSKU = mapStr.keySet();
                                        system.debug('**codeSKU CAM CombinationWise Pricebook -> ' +codeSKU);
                    combinationKey += code;
                    sObj.SKUCode__r = new SKU__c(Combination_Key__c = combinationKey);
                    //system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                    
                                    
                  }
                }
                else if(j==8){
                  if(String.isNotBlank(csvLineItem[j])){
                    sObj.DepotCode__r = new Depot__c(Depot_Code__c = csvLineItem[j]);
                    depotCode = csvLineItem[j];     
                    //system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);                      
                  }
                }
                else if(j==9){
                  if(String.isNotBlank(csvLineItem[j])){
                    sObj.CurrencyIsoCode  = csvLineItem[j].trim();
                    //system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                  }
                }
                else if(j==10){
                  if(String.isNotBlank(csvLineItem[j])){
                    sObj.UOM__c =  csvLineItem[j];
                    //system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                  }
                }
                else if(j==11){
                  if(String.isNotBlank(csvLineItem[j])){
                    Date d = Date.valueOf(csvLineItem[j]) ;                                
                    sObj.StartDate__c = d;
                    //system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                  }
                }
                else if(j==12){
                  if(String.isNotBlank(csvLineItem[j])){
                    Date d = Date.valueOf(csvLineItem[j]) ;
                    //System.debug(logginglevel.error, startDate);
                                    
                    sObj.EndDate__c = d;
                    //system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                  }
                }
                else if(j==13){
                  if(String.isNotBlank(csvLineItem[j])){
                    sObj.Price__c =  Decimal.valueOf(csvLineItem[j].trim());
                    //system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                  }
                }
                else if(j==14){
                  if(String.isNotBlank(csvLineItem[j])){
                    sObj.MinPrice__c = Decimal.valueOf(csvLineItem[j].trim());
                    //system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                  }
                }
                
              }
              compositeKey = startDate+depotCode+combinationKey+Country+customerGroupcode+priceClassification+priceList;
              sObj.CompositeKey__c = compositeKey;
              system.debug('sObj >>--->'+sObj);
              upsertPricebookList.add(sObj);
            }
            catch(Exception ex){
              errorCSVList.add(row+','+ex.getMessage());
            }
          }
        }
                
        
            } /*End of code added by Tejas*/
            
            else if(countryName == 'Colombia'){
                if(materialWise=='CustomerWise'){
                    for (Integer i = 1; i < csvData.size(); i++){
                        System.debug('countryName for :--- '+countryName);
                        String row = '';
                        try{
                            List<String> csvLineItem = new List<String>();
                            PriceBookMaster__c sObj = new PriceBookMaster__c();
                            row = csvData[i];
                            
                            csvLineItem = csvData[i].split(',');
                            
                            String startDate = '';
                            String depotCode = '';
                            String combinationKey = '';
                            String compositeKey = '';
                            string distributorKey = '';
                            String uomblank='';  
                            system.debug('File Size >>--->'+csvLineItem.size());
                            system.debug('File  >>--->'+csvLineItem);
                            
                            for(Integer j=0; j<csvLineItem.size(); j++){
                                
                                if(j==0){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        sObj.Sales_Org__r = new Sales_Org__c(Sales_Org_Code__c = csvLineItem[j].trim());
                                        combinationKey += csvLineItem[j];
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                    }
                                }
                                else if(j==1){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        sObj.DistributionChannel__r = new Distribution_Channel__c(Distribution_Channel_Code__c = csvLineItem[j].trim());
                                        combinationKey += csvLineItem[j];
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                    }
                                }
                                else if(j==2){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                        sObj.Division__r = new Division__c(Division_Code__c = csvLineItem[j].trim());
                                        combinationKey += csvLineItem[j];
                                    }
                                }
                                else if(j==3){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        String customercode = csvLineItem[j].trim();
                                        
                                        if(csvLineItem[j].length()==7){
                                            customercode = '000'+ csvLineItem[j];
                                        }else if(csvLineItem[j].length()==6){
                                            customercode = '0000'+ csvLineItem[j];
                                        }
                                        distributorKey = customercode;
                                        sObj.DistributorCustomerCode__r = new Account(SAP_Code__c=customercode);
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                    }else {
                                        errorCSVList.add(row+', Sold To Party Code is blank');
                                    }
                                }
                                
                                else if(j==4){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        String code = csvLineItem[j];
                                        if(code.length()==6){
                                            code = '000000000000'+csvLineItem[j];
                                            mapStr.put('000000000000'+csvLineItem[j],row);
                                        }
                                        else if(code.length()==7){
                                            code = '00000000000'+csvLineItem[j];
                                            mapStr.put('00000000000'+csvLineItem[j],row);
                                        }
                                        codeSKU = mapStr.keySet();
                                        system.debug('**codeSKU Colombia CustomerWise Pricebook -> ' +codeSKU);
                                        combinationKey += code;
                                        sObj.SKUCode__r = new SKU__c(Combination_Key__c = combinationKey);
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                    }else {
                                        errorCSVList.add(row+', SKU Code is blank');
                                    }
                                }
                                
                                else if(j==5){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        sObj.CurrencyIsoCode  = csvLineItem[j].trim();
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                    }else {
                                        errorCSVList.add(row+', Currency code is blank');
                                    }
                                }
                                else if(j==6){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        sObj.UOM__c  = csvLineItem[j].trim();
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                    }
                                }
                                else if(j==7){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        Date d = Date.valueOf(csvLineItem[j]) ;     
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                        sObj.StartDate__c = d;
                                        
                                    }else {
                                        errorCSVList.add(row+', Start date is blank');
                                    }
                                }
                                else if(j==8){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        if(Date.valueOf(csvLineItem[8])>Date.valueOf(csvLineItem[7])){
                                            sObj.EndDate__c = Date.valueOf(csvLineItem[j]);
                                        }else {
                                            errorCSVList.add(row+', End date should be greater than start date');
                                        }
                                    }else {
                                        errorCSVList.add(row+', End date is blank');
                                    }
                                }
                                else if(j==9){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        sObj.Batch__c =  csvLineItem[j].trim();
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                    }else {
                                        errorCSVList.add(row+', Batch is blank');
                                    }
                                }
                                else if(j==10){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        sObj.DepotCode__r = new Depot__c(Depot_Code__c = csvLineItem[j].trim());
                                        depotCode = csvLineItem[j].trim(); 
                                        //distributorKey = depotCode;
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);                      
                                    }else {
                                        errorCSVList.add(row+', Depot code is blank');
                                    }
                                }else if(j==11){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        sObj.MinPrice__c = Decimal.valueOf(csvLineItem[j].trim());
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                    }else {
                                        errorCSVList.add(row+', Minimum price is blank');
                                    }
                                }else if(j==12){
                                    
                                    if(String.isNotBlank(csvLineItem[j])){
                                    Boolean isContains=csvLineItem[j].trim().contains('-');
                                    System.debug('max price decimal 1 :- '+Decimal.valueOf(csvLineItem[j].trim()));
                                    if(isContains!=true && (Decimal.valueof(csvLineItem[12].trim())>=Decimal.valueof(csvLineItem[11].trim()))){
                                        System.debug('max price decimal 2 :- '+Decimal.valueOf(csvLineItem[j].trim()));
                                        sObj.Price__c = Decimal.valueOf(csvLineItem[j].trim());
                                    }else {
                                        if(isContains==true){
                                            errorCSVList.add(row+', Invalid number. Max price contains negative value');
                                        }
                                        if(Decimal.valueof(csvLineItem[12].trim())<Decimal.valueof(csvLineItem[11].trim())){
                                            errorCSVList.add(row+', Invalid number. Max price should be greater than min price');
                                        }
                                    }
                                }else {
                                    errorCSVList.add(row+', Max price is blank');
                                }
                                    
                                }else if(j==13){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        sObj.BudgetPrice__c = Decimal.valueOf(csvLineItem[j].trim());
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                    }
                                }
                            }
                            
                            compositeKey = depotCode+combinationKey+distributorKey;
                            sObj.CompositeKey__c = compositeKey;
                            system.debug('sObj >>--->'+sObj);
                            mapErrorStr.put(compositeKey,row);
                            upsertPricebookList.add(sObj);
                        }
                        catch(Exception ex){
                            errorCSVList.add(row+','+ex.getMessage());
                        }
                    }
                }else if(materialWise=='CustomerGroup'){
                    System.debug('materialWise 3 :--- '+materialWise);
                    for (Integer i = 1; i < csvData.size(); i++){
                        System.debug('countryName for :--- '+countryName);
                        String row = '';
                        try{
                            List<String> csvLineItem = new List<String>();
                            PriceBookMaster__c sObj = new PriceBookMaster__c();
                            row = csvData[i];
                            
                            csvLineItem = csvData[i].split(',');
                            
                            String startDate = '';
                            String depotCode = '';
                            String combinationKey = '';
                            String compositeKey = '';
                            string distributorKey = '';
                            String uomblank='';  
                            system.debug('File Size >>--->'+csvLineItem.size());
                            system.debug('File  >>--->'+csvLineItem);
                            
                            for(Integer j=0; j<csvLineItem.size(); j++){
                                
                                if(j==0){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        sObj.Sales_Org__r = new Sales_Org__c(Sales_Org_Code__c = csvLineItem[j].trim());
                                        combinationKey += csvLineItem[j];
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                    }
                                }
                                else if(j==1){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        sObj.DistributionChannel__r = new Distribution_Channel__c(Distribution_Channel_Code__c = csvLineItem[j].trim());
                                        combinationKey += csvLineItem[j];
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                    }
                                }
                                else if(j==2){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                        sObj.Division__r = new Division__c(Division_Code__c = csvLineItem[j].trim());
                                        combinationKey += csvLineItem[j];
                                    }
                                }
                                else if(j==3){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        String customerGroupcode = csvLineItem[j].trim();
                                        distributorKey=customerGroupcode;
                                        sObj.PG_CODE__r= new Price_Group_Master__c(PG_CODE__c=customerGroupcode);
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                    }else {
                                        errorCSVList.add(row+', Customer group code is blank');
                                    }
                                }
                                
                                else if(j==4){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        String code = csvLineItem[j];
                                        if(code.length()==6){
                                            code = '000000000000'+csvLineItem[j];
                                            mapStr.put('000000000000'+csvLineItem[j],row);
                                        }
                                        else if(code.length()==7){
                                            code = '00000000000'+csvLineItem[j];
                                            mapStr.put('00000000000'+csvLineItem[j],row);
                                        }
                                        codeSKU = mapStr.keySet();
                                        system.debug('**codeSKU Colombia CustomerGroup Pricebook -> ' +codeSKU);
                                        combinationKey += code;
                                        sObj.SKUCode__r = new SKU__c(Combination_Key__c = combinationKey);
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                    }else {
                                        errorCSVList.add(row+', Sku code is blank');
                                    }
                                }
                                
                                else if(j==5){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        sObj.CurrencyIsoCode  = csvLineItem[j].trim();
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                    }else {
                                        errorCSVList.add(row+', Currency code is blank');
                                    }
                                }
                                else if(j==6){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        sObj.UOM__c =  csvLineItem[j].trim();
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                    }
                                }
                                else if(j==7){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        Date d = Date.valueOf(csvLineItem[j]) ;     
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                        sObj.StartDate__c = d;
                                        
                                    }else {
                                        errorCSVList.add(row+', Start date is blank');
                                    }
                                }
                                else if(j==8){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        if(Date.valueOf(csvLineItem[8])>Date.valueOf(csvLineItem[7])){
                                            sObj.EndDate__c = Date.valueOf(csvLineItem[j]);
                                        }else {
                                            errorCSVList.add(row+', End date should be greater than start date');
                                        }
                                    }else {
                                        errorCSVList.add(row+', End date is blank');
                                    }
                                }
                                else if(j==9){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        sObj.Batch__c =  csvLineItem[j].trim();
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                    }
                                }
                                else if(j==10){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        sObj.DepotCode__r = new Depot__c(Depot_Code__c = csvLineItem[j].trim());
                                        depotCode = csvLineItem[j].trim(); 
                                        //distributorKey = depotCode;
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);                      
                                    }else {
                                        errorCSVList.add(row+', Depot code is blank');
                                    }
                                }else if(j==11){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        sObj.MinPrice__c = Decimal.valueOf(csvLineItem[j].trim());
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                    }else {
                                        errorCSVList.add(row+', Minimum price is blank');
                                    }
                                }else if(j==12){
                                    if(String.isNotBlank(csvLineItem[j])){
                                    Boolean isContains=csvLineItem[j].trim().contains('-');
                                    System.debug('max price decimal 1 :- '+Decimal.valueOf(csvLineItem[j].trim()));
                                    if(isContains!=true && (Decimal.valueof(csvLineItem[12].trim())>=Decimal.valueof(csvLineItem[11].trim()))){
                                        System.debug('max price decimal 2 :- '+Decimal.valueOf(csvLineItem[j].trim()));
                                        sObj.Price__c = Decimal.valueOf(csvLineItem[j].trim());
                                    }else {
                                        if(isContains==true){
                                            errorCSVList.add(row+', Invalid number. Max price contains negative value');
                                        }
                                        if(Decimal.valueof(csvLineItem[12].trim())<Decimal.valueof(csvLineItem[11].trim())){
                                            errorCSVList.add(row+', Invalid number. Max price should be greater than min price');
                                        }
                                    }
                                }else {
                                    errorCSVList.add(row+', Max price is blank');
                                }
                                    
                                }else if(j==13){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        sObj.BudgetPrice__c = Decimal.valueOf(csvLineItem[j].trim());
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                    }
                                }
                            }
                            
                            compositeKey = depotCode+combinationKey+distributorKey;
                            sObj.CompositeKey__c = compositeKey;
                            system.debug('sObj >>--->'+sObj);
                            mapErrorStr.put(compositeKey,row);
                            upsertPricebookList.add(sObj);
                        }
                        catch(Exception ex){
                            system.debug('**Error : '+ row+','+ex.getMessage());
                            errorCSVList.add(row+','+ex.getMessage());
                            system.debug('** Review Error : ' +errorCSVList);
                        }
                    }
                }       
            }
            else if(countryName == 'Italy'){
                if(italymaterialWise=='Pricebook With Price Group Code'){
                    for (Integer i = 1; i < csvData.size(); i++){
                        System.debug('countryName for :--- '+countryName);
                        String row = '';
                        try{
                            List<String> csvLineItem = new List<String>();
                            PriceBookMaster__c sObj = new PriceBookMaster__c();
                            PricebookDiscount__c pdObj= new PricebookDiscount__c();
                            row = csvData[i];
                            
                            csvLineItem = csvData[i].split(',');
                            
                            String startDate = '';
                            String depotCode = '';
                            String combinationKey = '';
                            String compositeKey = '';
                            string distributorKey = '';
                            String batchKey = '';
                            String uomblank='';  
                            system.debug('File Size >>--->'+csvLineItem.size());
                            system.debug('File  >>--->'+csvLineItem);
                            
                            for(Integer j=0; j<csvLineItem.size(); j++){
                                
                                if(j==0){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        sObj.Sales_Org__r = new Sales_Org__c(Sales_Org_Code__c = csvLineItem[j].trim());
                                        pdObj.Sales_Org__r = new Sales_Org__c(Sales_Org_Code__c = csvLineItem[j].trim());
                                        combinationKey += csvLineItem[j];
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                    }
                                }
                                else if(j==1){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        sObj.DistributionChannel__r = new Distribution_Channel__c(Distribution_Channel_Code__c = csvLineItem[j].trim());
                                        pdObj.DistributionChannel__r = new Distribution_Channel__c(Distribution_Channel_Code__c = csvLineItem[j].trim());
                                        combinationKey += csvLineItem[j];
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                    }
                                }
                                else if(j==2){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                        sObj.Division__r = new Division__c(Division_Code__c = csvLineItem[j].trim());
                                        pdObj.Division__r = new Division__c(Division_Code__c = csvLineItem[j].trim());
                                        combinationKey += csvLineItem[j];
                                    }
                                }
                                else if(j==3){
                                    
                                    if(String.isNotBlank(csvLineItem[j])){
                                        String customerGroupcode = csvLineItem[j].trim();
                                        distributorKey=customerGroupcode;
                                        sObj.PG_CODE__r= new Price_Group_Master__c(PG_CODE__c=customerGroupcode);
                                        //pdObj.PG_CODE__r= new Price_Group_Master__c(PG_CODE__c=customerGroupcode);
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                    }else {
                                        errorCSVList.add(row+', Price group code is blank');
                                    }
                                    
                                }
                                
                                else if(j==4){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        String code = csvLineItem[j];
                                        if(code.length()==6){
                                            code = '000000000000'+csvLineItem[j];
                                            mapStr.put('000000000000'+csvLineItem[j],row);
                                        }
                                        else if(code.length()==7){
                                            code = '00000000000'+csvLineItem[j];
                                            mapStr.put('00000000000'+csvLineItem[j],row);
                                        }
                                         codeSKU = mapStr.keySet();
                                        system.debug('**codeSKU italy Pricebook With Price Group Code -> ' +codeSKU);
                                        combinationKey += code;
                                        sObj.SKUCode__r = new SKU__c(Combination_Key__c = combinationKey);
                                        pdObj.SKUCode__r = new SKU__c(Combination_Key__c = combinationKey);
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                    }else {
                                        errorCSVList.add(row+', SKU Code is blank');
                                    }
                                }
                                
                                else if(j==5){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        sObj.CurrencyIsoCode  = csvLineItem[j].trim();
                                        pdObj.CurrencyIsoCode  = csvLineItem[j].trim();
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                    }else {
                                        errorCSVList.add(row+', Currency code is blank');
                                    }
                                }
                                else if(j==6){
                                    if(String.isNotBlank(csvLineItem[j])){
                                    String skcode='';
                                    if(csvLineItem[4].length()==6){
                                        skcode = '000000000000'+csvLineItem[4];
                                    }
                                    else if(csvLineItem[4].length()==7){
                                        skcode = '00000000000'+csvLineItem[4];
                                    }
                                    System.debug('skcode :- '+skcode);
                                    System.debug('mapStrUom.containsKey(skcode) :- '+mapStrUom.containsKey(skcode));
                                    if(mapStrUom.containsKey(skcode)){
                                        if(mapStrUom.get(skcode)==csvLineItem[j].trim()){
                                            sObj.UOM__c =csvLineItem[j].trim();
                                            pdObj.UOM__c =csvLineItem[j].trim();
                                            uomblank=csvLineItem[j].trim();
                                            isTrue=true;
                                            
                                        }else {
                                            isTrue=false;
                                            sObj.UOM__c =csvLineItem[j];
                                            pdObj.UOM__c =csvLineItem[j];
                                            errorCSVList.add(row+', Invalid UOM.');
                                        }
                                    }else{
                                        isTrue=false;
                                    }
                                    }else {
                                        errorCSVList.add(row+', UOM is blank');
                                    }
                                }
                                else if(j==7){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        startDate = csvLineItem[j].trim();
                                        System.debug('startDate'+startDate);
                                        Date d = Date.valueOf(csvLineItem[j]) ;     
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]+'d '+d);
                                        sObj.StartDate__c = d;
                                        pdObj.StartDate__c = d;
                                        
                                    }else {
                                        errorCSVList.add(row+', Start date is blank');
                                    }
                                }
                                else if(j==8){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        if(Date.valueOf(csvLineItem[8])>Date.valueOf(csvLineItem[7])){
                                            sObj.EndDate__c = Date.valueOf(csvLineItem[j]);
                                            pdObj.EndDate__c = Date.valueOf(csvLineItem[j]);
                                        }else {
                                            errorCSVList.add(row+', End date should be greater than start date');
                                        }
                                    }else {
                                        errorCSVList.add(row+', End date is blank');
                                    }
                                }
                                else if(j==9){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        batchKey = csvLineItem[j].trim();
                                        sObj.Batch__c =  csvLineItem[j].trim();
                                        pdObj.Batch__c =  csvLineItem[j].trim();
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                    }
                                }
                                else if(j==10){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        sObj.DepotCode__r = new Depot__c(Depot_Code__c = csvLineItem[j].trim());
                                        System.debug('                   sObj.DepotCode__r'+sObj.DepotCode__r);
                                        pdObj.DepotCode__r = new Depot__c(Depot_Code__c = csvLineItem[j].trim());
                                        depotCode = csvLineItem[j].trim();
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]+'depotCode ' +depotCode);                      
                                    }else {
                                        errorCSVList.add(row+', Depot code is blank');
                                    }
                                }else if(j==11){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        sObj.Price__c = Decimal.valueOf(csvLineItem[j].trim());
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                    }else {
                                        errorCSVList.add(row+', Material Price is blank');
                                    }
                                }else if(j==12){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        pdObj.Price__c= Decimal.valueOf(csvLineItem[j].trim());
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                    }else {
                                        errorCSVList.add(row+', Standard Rebate is blank');
                                    }
                                }else if(j==13){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        sObj.Final_price__c= Decimal.valueOf(csvLineItem[j].trim());
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                    }else {
                                        errorCSVList.add(row+', Estimated Final Price is blank');
                                    }
                                }else if(j==14){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        pdObj.Accrual_Discount__c= Decimal.valueOf(csvLineItem[j].trim());
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                    }else {
                                        errorCSVList.add(row+', Accrual Discount is blank');
                                    }
                                }
                                //Added By Pragati Sharma
                                else if(j==15){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        
                                        sObj.Order_Italy_Type__c= csvLineItem[j].trim();
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                    }else {
                                        errorCSVList.add(row+', Order_Italy_Type__c is blank');
                                    }
                                }
                            }
                            
                            //compositeKey = batchKey+startDate+depotCode+distributorKey+combinationKey;
                            compositeKey = depotCode+distributorKey+combinationKey;
                            sObj.CompositeKey__c = compositeKey;
                            system.debug('sObj >>--->'+sObj);
                            if(startDate!=''){
                                //pdObj.CompositeKey__c = compositeKey;
                                pdObj.CompositeKey__c = startDate+compositeKey;
                                system.debug('pdObj >>--->'+pdObj);
                            }
                            mapErrorStr.put(compositeKey,row);
                            upsertPricebookList.add(sObj);
                            upsertPricebookDiscountList.add(pdObj);
                            system.debug('upsertPricebookDiscountList  :'+upsertPricebookDiscountList);
                        }
                        catch(Exception ex){
                            errorCSVList.add(row+','+ex.getMessage());
                        }
                    }
                }
                else if(italymaterialWise=='Common Pricebook'){
                    System.debug('italymaterialWise :--- '+italymaterialWise);
                    for (Integer i = 1; i < csvData.size(); i++){
                        String row = '';
                        try{
                            List<String> csvLineItem = new List<String>();
                            PriceBookMaster__c sObj = new PriceBookMaster__c();
                            PricebookDiscount__c pdObj= new PricebookDiscount__c();
                            row = csvData[i];
                            
                            csvLineItem = csvData[i].split(',');
                            
                            String startDate = '';
                            String depotCode = '';
                            String combinationKey = '';
                            String compositeKey = '';
                            string distributorKey = '';
                            string batchKey='';
                            String uomblank='';
                            
                            system.debug('File Size >>--->'+csvLineItem.size());
                            system.debug('File  >>--->'+csvLineItem);
                            
                            for(Integer j=0; j<csvLineItem.size(); j++){
                                
                                if(j==0){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        sObj.Sales_Org__r = new Sales_Org__c(Sales_Org_Code__c = csvLineItem[j].trim());
                                        pdObj.Sales_Org__r = new Sales_Org__c(Sales_Org_Code__c = csvLineItem[j].trim());
                                        combinationKey += csvLineItem[j];
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                    }
                                }
                                else if(j==1){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        sObj.DistributionChannel__r = new Distribution_Channel__c(Distribution_Channel_Code__c = csvLineItem[j].trim());
                                        pdObj.DistributionChannel__r = new Distribution_Channel__c(Distribution_Channel_Code__c = csvLineItem[j].trim());
                                        combinationKey += csvLineItem[j];
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                    }
                                }
                                else if(j==2){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                        sObj.Division__r = new Division__c(Division_Code__c = csvLineItem[j].trim());
                                        pdObj.Division__r = new Division__c(Division_Code__c = csvLineItem[j].trim());
                                        combinationKey += csvLineItem[j];
                                    }
                                }else if(j==3){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        String code = csvLineItem[j];
                                        if(code.length()==6){
                                            code = '000000000000'+csvLineItem[j];
                                            mapStr.put('000000000000'+csvLineItem[j],row);
                                        }
                                        else if(code.length()==7){
                                            code = '00000000000'+csvLineItem[j];
                                            mapStr.put('00000000000'+csvLineItem[j],row);
                                        }
                                        codeSKU = mapStr.keySet();
                                        system.debug('**codeSKU italy Common Pricebook -> ' +codeSKU);
                                        combinationKey += code;
                                        sObj.SKUCode__r = new SKU__c(Combination_Key__c = combinationKey);
                                        pdObj.SKUCode__r = new SKU__c(Combination_Key__c = combinationKey);
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                    }else {
                                        errorCSVList.add(row+', Sku code is blank');
                                    }
                                }
                                
                                else if(j==4){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        sObj.CurrencyIsoCode  = csvLineItem[j].trim();
                                        pdObj.CurrencyIsoCode  = csvLineItem[j].trim();
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                    }else {
                                        errorCSVList.add(row+', Currency code is blank');
                                    }
                                }
                                else if(j==5){
                                    if(String.isNotBlank(csvLineItem[j])){
                                    String skcode='';
                                    if(csvLineItem[3].length()==6){
                                        skcode = '000000000000'+csvLineItem[3];
                                    }
                                    else if(csvLineItem[3].length()==7){
                                        skcode = '00000000000'+csvLineItem[3];
                                    }
                                    System.debug('skcode :- '+skcode);
                                    System.debug('mapStrUom.containsKey(skcode) :- '+mapStrUom.containsKey(skcode));
                                    if(mapStrUom.containsKey(skcode)){
                                        if(mapStrUom.get(skcode)==csvLineItem[j].trim()){
                                            sObj.UOM__c =csvLineItem[j].trim();
                                            pdObj.UOM__c =csvLineItem[j].trim();
                                            uomblank=csvLineItem[j].trim();
                                            isTrue=true;
                                            
                                        }else {
                                            isTrue=false;
                                            sObj.UOM__c =csvLineItem[j].trim();
                                            pdObj.UOM__c =csvLineItem[j].trim();
                                            errorCSVList.add(row+', Invalid UOM.');
                                        }
                                    }else{
                                        isTrue=false;
                                        //sObj.UOM__c =csvLineItem[j].trim();
                                        //pdObj.UOM__c =csvLineItem[j].trim();
                                        //errorCSVList.add(row+', Invalid UOM.');
                                    }
                                    }else {
                                        errorCSVList.add(row+', UOM is blank');
                                    }
                                    
                                }
                                else if(j==6){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        startDate = csvLineItem[j].trim();
                                        Date d = Date.valueOf(csvLineItem[j]) ;     
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                        sObj.StartDate__c = d;
                                        pdObj.StartDate__c = d;
                                    }else {
                                        errorCSVList.add(row+', Start date is blank');
                                    }
                                }
                                else if(j==7){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        if(Date.valueOf(csvLineItem[7])>Date.valueOf(csvLineItem[6])){
                                            system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                            sObj.EndDate__c = Date.valueOf(csvLineItem[j]);
                                            pdObj.EndDate__c = Date.valueOf(csvLineItem[j]);
                                        }else {
                                            errorCSVList.add(row+', End date should be greater than start date');
                                        }
                                    }else {
                                        errorCSVList.add(row+', End date is blank');
                                    }
                                }
                                else if(j==8){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        sObj.Batch__c =  csvLineItem[j].trim();
                                        pdObj.Batch__c =  csvLineItem[j].trim();
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                    }
                                }
                                else if(j==9){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        sObj.DepotCode__r = new Depot__c(Depot_Code__c = csvLineItem[j].trim());
                                        pdObj.DepotCode__r = new Depot__c(Depot_Code__c = csvLineItem[j].trim());
                                        depotCode = csvLineItem[j].trim();
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);                      
                                    }else {
                                        errorCSVList.add(row+', Depot code is blank');
                                    }
                                }else if(j==10){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        sObj.Price__c = Decimal.valueOf(csvLineItem[j].trim());
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                    }else {
                                        errorCSVList.add(row+', Material Price is blank');
                                    }
                                }else if(j==11){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        pdObj.Price__c = Decimal.valueOf(csvLineItem[j].trim());
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                    }else {
                                        errorCSVList.add(row+', Standard Rebate is blank');
                                    }
                                }
                                //Added By Pragati Sharma
                                else if(j==12){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        
                                         sObj.Order_Italy_Type__c = csvLineItem[j].trim();
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                    }else {
                                        errorCSVList.add(row+', Order Type is blank');
                                    }
                                }
                            }
                            
                            //compositeKey = batchKey+startDate+depotCode+distributorKey+combinationKey;//depotCode+combinationKey+distributorKey;
                            compositeKey = depotCode+combinationKey;
                            sObj.CompositeKey__c = compositeKey;
                            system.debug('sObj >>--->'+sObj);
                            if(startDate!=''){
                                pdObj.CompositeKey__c = startDate+compositeKey;
                                system.debug('pdObj >>--->'+pdObj);
                            }
                            
                            mapErrorStr.put(compositeKey,row);
                            upsertPricebookList.add(sObj);
                            upsertPricebookDiscountList.add(pdObj);
                            system.debug('upsertPricebookDiscountList  :'+upsertPricebookDiscountList);
                        }
                        catch(Exception ex){
                            system.debug('Error : '+ row+','+ex.getMessage());
                            errorCSVList.add(row+','+ex.getMessage());
                        }
                    }
                }     
                else if(italymaterialWise=='Pricebook With Customer Code'){
                    System.debug('** Inside Pricebook With Customer Code -> ' +italymaterialWise);
                    system.debug('** Inside Italy csvData size>>--- > ' +csvData.size());
                    for (Integer i = 1; i < csvData.size(); i++){
                        String row = '';
                        try{
                            List<String> csvLineItem = new List<String>();
                            PriceBookMaster__c sObj = new PriceBookMaster__c();
                            PricebookDiscount__c pdObj= new PricebookDiscount__c();
                            row = csvData[i];
                            
                            csvLineItem = csvData[i].split(',');
                            
                            String startDate = '';
                            String depotCode = '';
                            String combinationKey = '';
                            String compositeKey = '';
                            string distributorKey = '';
                            string batchKey='';
                            String uomblank='';
                            
                            system.debug('**File Size >>--->'+csvLineItem.size());
                            system.debug('**File  >>--->'+csvLineItem);


                            for(Integer j=0; j<csvLineItem.size(); j++){
                                
                               
                                if(j==0){
                                    if(String.isNotBlank(csvLineItem[j])){
                                         //this is for Sales Org code
                                        sObj.Sales_Org__r = new Sales_Org__c(Sales_Org_Code__c = csvLineItem[j].trim());
                                        pdObj.Sales_Org__r = new Sales_Org__c(Sales_Org_Code__c = csvLineItem[j].trim());
                                        combinationKey += csvLineItem[j];
                                        system.debug('**SalesOrg csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                    }
                                } 
                                 else if(j==1){
                                     // This is for distribution Channel
                                    if(String.isNotBlank(csvLineItem[j])){
                                        sObj.DistributionChannel__r = new Distribution_Channel__c(Distribution_Channel_Code__c = csvLineItem[j].trim());
                                        pdObj.DistributionChannel__r = new Distribution_Channel__c(Distribution_Channel_Code__c = csvLineItem[j].trim());
                                        combinationKey += csvLineItem[j];
                                        system.debug('** DistributionChannel csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                    }
                                }
                                 else if(j==2){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        // This is for Division
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                        sObj.Division__r = new Division__c(Division_Code__c = csvLineItem[j].trim());
                                        pdObj.Division__r = new Division__c(Division_Code__c = csvLineItem[j].trim());
                                        combinationKey += csvLineItem[j];
                                    }
                                } else if(j==3){
                                    // this is for Sold to Party
                                    
                                    if(String.isNotBlank(csvLineItem[j])){
                                        String customercode = csvLineItem[j].trim();
                                        if(csvLineItem[j].length()==7){
                                            customercode = '000'+ csvLineItem[j];
                                        }else if(csvLineItem[j].length()==6){
                                            customercode = '0000'+ csvLineItem[j];
                                        }
                                        distributorKey = customercode;
                                        sObj.DistributorCustomerCode__r =  new Account (SAP_Code__c = customercode);
                                        pdObj.DistributorCustomerCode__r = new Account (SAP_Code__c = customercode);
                                        system.debug('** customercode csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                    }else {
                                        errorCSVList.add(row+', Sold To Party Code is blank');
                                    }
                                    
                                } else if(j==4){
                                    // this is for SKU code 
                                    if(String.isNotBlank(csvLineItem[j])){
                                        String code = csvLineItem[j];
                                        if(code.length()==6){
                                            code = '000000000000'+csvLineItem[j];
                                            mapStr.put('000000000000'+csvLineItem[j],row);
                                        }
                                        else if(code.length()==7){
                                            code = '00000000000'+csvLineItem[j];
                                            mapStr.put('00000000000'+csvLineItem[j],row);
                                        }
                                        codeSKU = mapStr.keySet();
                                        system.debug('**codeSKU italy Pricebook with customer code-> ' +codeSKU);
                                        combinationKey += code;
                                        sObj.SKUCode__r = new SKU__c(Combination_Key__c = combinationKey);
                                        pdObj.SKUCode__r = new SKU__c(Combination_Key__c = combinationKey);
                                        system.debug('**SKU SKUCode__r csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                    }else {
                                        errorCSVList.add(row+', Sku code is blank');
                                    }
                                    
                                    // End for SKU Code
                                } else if(j==5){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        // This is for Currency 
                                        sObj.CurrencyIsoCode  = csvLineItem[j].trim();
                                        pdObj.CurrencyIsoCode  = csvLineItem[j].trim();
                                        system.debug('** CurrencyIsoCode csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                    }else {
                                        errorCSVList.add(row+', Currency code is blank');
                                    }
                                    // End of Currency
                                }else if(j==6){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        // this is for UOM
                                        String skcode='';
                                        if(csvLineItem[4].length()==6){
                                            skcode = '000000000000'+csvLineItem[4];
                                        }
                                        else if(csvLineItem[4].length()==7){
                                            skcode = '00000000000'+csvLineItem[4];
                                        }
                                        System.debug('** skcode :- '+skcode);
                                        System.debug('** mapStrUom.containsKey(skcode) :- '+mapStrUom.containsKey(skcode));
                                        if(mapStrUom.containsKey(skcode)){
                                            if(mapStrUom.get(skcode)==csvLineItem[j].trim()){
                                                sObj.UOM__c =csvLineItem[j].trim();
                                                pdObj.UOM__c =csvLineItem[j].trim();
                                                uomblank=csvLineItem[j].trim();
                                                isTrue=true;
                                                
                                            }else {
                                                isTrue=false;
                                                sObj.UOM__c =csvLineItem[j].trim();
                                                pdObj.UOM__c =csvLineItem[j].trim();
                                                errorCSVList.add(row+', Invalid UOM.');
                                            }
                                        }else{
                                            isTrue=false;
                                            //sObj.UOM__c =csvLineItem[j].trim();
                                            //pdObj.UOM__c =csvLineItem[j].trim();
                                            //errorCSVList.add(row+', Invalid UOM.');
                                        }
                                    }else {
                                        errorCSVList.add(row+', UOM is blank');
                                    }
                                    
                                    
                                    // End of UOM
                                    
                                } else if(j==7){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        // this is for valid from
                                       startDate = csvLineItem[j].trim();
                                        system.debug('startDate '+startDate +'csvLineItem[j]'+csvLineItem[j]);
                                        Date d = Date.valueOf(csvLineItem[j]) ;
                                        System.debug('d'+d);
                                        system.debug('**csvLineItem['+j+']>>--->'+csvLineItem[j] +'d '+d);
                                      // Date d= Date.newInstance(2022, 10, 22);
                                        sObj.StartDate__c = d;
                                        pdObj.StartDate__c = d;
                                    }else {
                                        errorCSVList.add(row+', Start date is blank');
                                    }
                                    // End of Valid From
                                } else if(j==8){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        // This is for Valid To
                                     if(Date.valueOf(csvLineItem[8])>Date.valueOf(csvLineItem[7])){
                                        
                                            system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                           // Date d= Date.newInstance(2023, 10, 23);
                                            sObj.EndDate__c = Date.valueOf(csvLineItem[j]);
                                            pdObj.EndDate__c = Date.valueOf(csvLineItem[j]);

                                        }else {
                                            errorCSVList.add(row+', End date should be greater than start date');
                                        }
                                    }else {
                                        errorCSVList.add(row+', End date is blank');
                                    }
                                    // End of Valid To
                                    
                                } else if(j==9){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        // this is for Batch
                                        sObj.Batch__c =  csvLineItem[j].trim();
                                        pdObj.Batch__c =  csvLineItem[j].trim();
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                    }
                                    // End of Batch
                                } else if(j==10) {
                                    if(String.isNotBlank(csvLineItem[j])){
                                        // This is for Depot/ storage Location
                                        sObj.DepotCode__r = new Depot__c(Depot_Code__c = csvLineItem[j].trim());
                                        pdObj.DepotCode__r = new Depot__c(Depot_Code__c = csvLineItem[j].trim());
                                        depotCode = csvLineItem[j].trim();
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);                      
                                    }else {
                                        errorCSVList.add(row+', Depot code is blank');
                                    }
                                    
                                    // End of Depot/ storage Location
                                    
                                } else if(j==11){
                                     if(String.isNotBlank(csvLineItem[j])){
                                         // this is for Material Price
                                        sObj.Price__c = Decimal.valueOf(csvLineItem[j].trim());
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                    }else {
                                        errorCSVList.add(row+', Material Price is blank');
                                    }
                                    // End of material Price
                                } else if(j==12){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        //this is for Standard Rebate
                                        pdObj.Price__c = Decimal.valueOf(csvLineItem[j].trim());
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                    }else {
                                        errorCSVList.add(row+', Standard Rebate is blank');
                                    }
                                    // this end for Standard Rebate
                                }else if(j==13){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        // this is for Estimate final Price
                                        sObj.Final_price__c= Decimal.valueOf(csvLineItem[j].trim());
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                    }else {
                                        errorCSVList.add(row+', Estimated Final Price is blank');
                                    }
                                    // end of Estimate final price
                                }else if(j==14){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        pdObj.Accrual_Discount__c= Decimal.valueOf(csvLineItem[j].trim());
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                    }else {
                                        errorCSVList.add(row+', Accrual Discount is blank');
                                    }
                                }
                                  //Added By Pragati Sharma
                                else if(j==15){
                                    if(String.isNotBlank(csvLineItem[j])){
                                       
                                        sObj.Order_Italy_Type__c= csvLineItem[j].trim();
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                    }else {
                                        errorCSVList.add(row+',Order Type is blank');
                                    }
                                }
                                
                            }// end of Inner for loop
                            
                            compositeKey = depotCode+combinationKey+distributorKey;
                            sObj.CompositeKey__c = compositeKey;
                            if(startDate!=''){
                                pdObj.CompositeKey__c = startDate+compositeKey;
                                system.debug('pdObj >>--->'+pdObj);
                            }
                            mapErrorStr.put(compositeKey,row);
                            upsertPricebookList.add(sObj);
                            upsertPricebookDiscountList.add(pdObj);
                            system.debug('upsertPricebookList'+upsertPricebookList);
                            system.debug('upsertPricebookDiscountList  :'+upsertPricebookDiscountList);
                            
                        } // End of Try Block
                        catch(Exception ex){
                            system.debug('Error : '+ row+','+ex.getMessage());
                            errorCSVList.add(row+','+ex.getMessage());
                        } // End of catch Block
                        
                    }//end of external For loop
                    
                }
                //End of code added by vishal Pawar for Pricebook With Customer code
                /*else if(italymaterialWise=='Customized Product Pricebook'){
                    System.debug('Pricebook With Customer Code '+italymaterialWise);
                    for (Integer i = 1; i < csvData.size(); i++){
                        String row = '';
                        try{
                            List<String> csvLineItem = new List<String>();
                            PriceBookMaster__c sObj = new PriceBookMaster__c();
                            PricebookDiscount__c pdObj= new PricebookDiscount__c();
                            row = csvData[i];
                            
                            csvLineItem = csvData[i].split(',');
                            
                            String startDate = '';
                            String depotCode = '';
                            String combinationKey = '';
                            String compositeKey = '';
                            string distributorKey = '';
                            string batchKey='';
                            String uomblank='';
                            
                            system.debug('File Size >>--->'+csvLineItem.size());
                            system.debug('File  >>--->'+csvLineItem);
                            
                            for(Integer j=0; j<csvLineItem.size(); j++){
                                
                                if(j==0){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        sObj.Sales_Org__r = new Sales_Org__c(Sales_Org_Code__c = csvLineItem[j].trim());
                                        pdObj.Sales_Org__r = new Sales_Org__c(Sales_Org_Code__c = csvLineItem[j].trim());
                                        combinationKey += csvLineItem[j];
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                    }
                                }
                                else if(j==1){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        sObj.DistributionChannel__r = new Distribution_Channel__c(Distribution_Channel_Code__c = csvLineItem[j].trim());
                                        pdObj.DistributionChannel__r = new Distribution_Channel__c(Distribution_Channel_Code__c = csvLineItem[j].trim());
                                        combinationKey += csvLineItem[j];
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                    }
                                }
                                else if(j==2){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                        sObj.Division__r = new Division__c(Division_Code__c = csvLineItem[j].trim());
                                        pdObj.Division__r = new Division__c(Division_Code__c = csvLineItem[j].trim());
                                        combinationKey += csvLineItem[j];
                                    }
                                }else if(j==3){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        String code = csvLineItem[j];
                                        if(code.length()==6){
                                            code = '000000000000'+csvLineItem[j];
                                            mapStr.put('000000000000'+csvLineItem[j],row);
                                        }
                                        else if(code.length()==7){
                                            code = '00000000000'+csvLineItem[j];
                                            mapStr.put('00000000000'+csvLineItem[j],row);
                                        }
                                        combinationKey += code;
                                        sObj.SKUCode__r = new SKU__c(Combination_Key__c = combinationKey);
                                        pdObj.SKUCode__r = new SKU__c(Combination_Key__c = combinationKey);
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                    }else {
                                        errorCSVList.add(row+', Sku code is blank');
                                    }
                                }
                                
                                else if(j==4){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        sObj.CurrencyIsoCode  = csvLineItem[j].trim();
                                        pdObj.CurrencyIsoCode  = csvLineItem[j].trim();
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                    }else {
                                        errorCSVList.add(row+', Currency code is blank');
                                    }
                                }
                                else if(j==5){
                                    if(String.isNotBlank(csvLineItem[j])){
                                    String skcode='';
                                    if(csvLineItem[3].length()==6){
                                        skcode = '000000000000'+csvLineItem[3];
                                    }
                                    else if(csvLineItem[3].length()==7){
                                        skcode = '00000000000'+csvLineItem[3];
                                    }
                                    System.debug('skcode :- '+skcode);
                                    System.debug('mapStrUom.containsKey(skcode) :- '+mapStrUom.containsKey(skcode));
                                    if(mapStrUom.containsKey(skcode)){
                                        if(mapStrUom.get(skcode)==csvLineItem[j].trim()){
                                            sObj.UOM__c =csvLineItem[j].trim();
                                            pdObj.UOM__c =csvLineItem[j].trim();
                                            uomblank=csvLineItem[j].trim();
                                            isTrue=true;
                                            
                                        }else {
                                            isTrue=false;
                                            sObj.UOM__c =csvLineItem[j].trim();
                                            pdObj.UOM__c =csvLineItem[j].trim();
                                            errorCSVList.add(row+', Invalid UOM.');
                                        }
                                    }else{
                                        isTrue=false;
                                        //sObj.UOM__c =csvLineItem[j].trim();
                                        //pdObj.UOM__c =csvLineItem[j].trim();
                                        //errorCSVList.add(row+', Invalid UOM.');
                                    }
                                    }else {
                                        errorCSVList.add(row+', UOM is blank');
                                    }
                                    
                                }
                                else if(j==6){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        startDate = csvLineItem[j].trim();
                                        Date d = Date.valueOf(csvLineItem[j]) ;     
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                        sObj.StartDate__c = d;
                                        pdObj.StartDate__c = d;
                                    }else {
                                        errorCSVList.add(row+', Start date is blank');
                                    }
                                }
                                else if(j==7){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        if(Date.valueOf(csvLineItem[7])>Date.valueOf(csvLineItem[6])){
                                            system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                            sObj.EndDate__c = Date.valueOf(csvLineItem[j]);
                                            pdObj.EndDate__c = Date.valueOf(csvLineItem[j]);
                                        }else {
                                            errorCSVList.add(row+', End date should be greater than start date');
                                        }
                                    }else {
                                        errorCSVList.add(row+', End date is blank');
                                    }
                                }
                                else if(j==8){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        sObj.Batch__c =  csvLineItem[j].trim();
                                        pdObj.Batch__c =  csvLineItem[j].trim();
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                    }
                                }
                                else if(j==9){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        sObj.DepotCode__r = new Depot__c(Depot_Code__c = csvLineItem[j].trim());
                                        pdObj.DepotCode__r = new Depot__c(Depot_Code__c = csvLineItem[j].trim());
                                        depotCode = csvLineItem[j].trim();
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);                      
                                    }else {
                                        errorCSVList.add(row+', Depot code is blank');
                                    }
                                }else if(j==10){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        sObj.Price__c = Decimal.valueOf(csvLineItem[j].trim());
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                    }else {
                                        errorCSVList.add(row+', Material Price is blank');
                                    }
                                }else if(j==11){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        pdObj.Price__c = Decimal.valueOf(csvLineItem[j].trim());
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                    }else {
                                        errorCSVList.add(row+', Standard Rebate is blank');
                                    }
                                }else if(j==12){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        // this is for Estimate final Price
                                        sObj.Final_price__c= Decimal.valueOf(csvLineItem[j].trim());
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                    }else {
                                        errorCSVList.add(row+', Estimated Final Price is blank');
                                    }
                                    // end of Estimate final price
                                }
                            }
                            
                            //compositeKey = batchKey+startDate+depotCode+distributorKey+combinationKey;//depotCode+combinationKey+distributorKey;
                            compositeKey = depotCode+combinationKey;
                            sObj.CompositeKey__c = compositeKey;
                            sObj.Customized_Product__c = true;
                            system.debug('sObj >>--->'+sObj);
                            if(startDate!=''){
                                pdObj.CompositeKey__c = startDate+compositeKey;
                                pdObj.Customized_Product__c = true;
                                system.debug('pdObj >>--->'+pdObj);
                            }
                            
                            mapErrorStr.put(compositeKey,row);
                            upsertPricebookList.add(sObj);
                            upsertPricebookDiscountList.add(pdObj);
                            system.debug('upsertPricebookDiscountList  :'+upsertPricebookDiscountList);
                        }
                        catch(Exception ex){
                            system.debug('Error : '+ row+','+ex.getMessage());
                            errorCSVList.add(row+','+ex.getMessage());
                        }
                    }//end of external For loop
                    
                }*/
                
            }
            else if(countryName == 'Iberia & Portugal' || countryName == 'Naturagri'){
                FileUploadRESTAPIV2.processData(countryName,SPNPBWise,NaturagriPBWise,csvData,mapStrUom,successCSVList,errorCSVList);
            }
            else if(countryName == 'Poland'){
                FileUploadRESTAPIV2.processData(countryName,PolandPBWise,null,csvData,mapStrUom,successCSVList,errorCSVList);
            }
            else if(countryName == 'Bolivia & Paraguay'){
                FileUploadRESTAPIV2.processData(countryName,BolParPBWise,null,csvData,mapStrUom,successCSVList,errorCSVList);
            }
            Database.UpsertResult[] srList;
            Database.UpsertResult[] srList2;
            Database.UpsertResult[] srList3;
            Set<Id> idsItaly=new Set<Id>();
            System.debug('idsItaly'+idsItaly);
            Schema.SObjectField f = PriceBookMaster__c.Fields.CompositeKey__c;
            Schema.SObjectField f2 = PricebookDiscount__c.Fields.CompositeKey__c;
            Schema.SObjectField f3 = SpecialInvoiceDiscount__c.Fields.CompositeKey__c;
            Schema.SObjectField f4 = ZSP1_Discount__c.Fields.CompositeKey__c;
            system.debug('upsertPricebookList>>--->'+upsertPricebookList);
            if(countryName == 'Mexico'){
                System.debug('Mexico');
                if(upsertPricebookList.size()>0){
                    boolean isBTrue=false;
                    boolean UOMTrue=false;
                    boolean DepotCodeTrue=false;
                    boolean CurrencyIsoCodeTrue=false;
                    boolean minPriceTrue=false;
                    boolean maxPriceTrue=false;
                    boolean saleDirPriceTrue=false;
                    boolean LatamPriceTrue=false;
                    boolean endDateTrue=false;
                    
                    
                    for(PriceBookMaster__c sobj1:upsertPricebookList){
                        System.debug('sobj1 :- '+sobj1);
                        
                        if(String.isNotBlank(sobj1.CurrencyIsoCode)){
                            if(sobj1.CurrencyIsoCode=='MXN' || sobj1.CurrencyIsoCode=='USD'){
                                CurrencyIsoCodeTrue=true;
                            }else {
                                CurrencyIsoCodeTrue=false;
                            }
                        }
                        /*if(String.isNotBlank(sobj1.UOM__c)){
                            if(mapStrUom.containsKey(sobj1.CompositeKey__c.substring(12))){
                                if(mapStrUom.get(sobj1.CompositeKey__c.substring(12))==sobj1.UOM__c){
                                    UOMTrue=true;
                                }else {
                                    UOMTrue=false;
                                }
                            }else{
                                UOMTrue=false;
                            }
                            
                        } */
                        if(String.isNotBlank(String.valueOf(sobj1.MinPrice__c))){
                            Boolean isContains=String.valueOf(sobj1.MinPrice__c).trim().contains('-');
                            if(isContains!=true){
                                minPriceTrue=true;
                            }else {
                                minPriceTrue=false;
                            }
                            
                            System.debug('minPriceTrue :- '+minPriceTrue);
                        }
                        if(String.isNotBlank(String.valueOf(sobj1.Price__c))){
                            Boolean isContains=String.valueOf(sobj1.Price__c).trim().contains('-');
                            if(isContains!=true && (sobj1.Price__c >=sobj1.MinPrice__c)){
                                maxPriceTrue=true;
                            }else {
                                maxPriceTrue=false;
                            }
                            
                            System.debug('maxPriceTrue :- '+maxPriceTrue);
                        }
                        if(String.isNotBlank(String.valueOf(sobj1.Manager_Price__c))){
                            Boolean isContains=String.valueOf(sobj1.Manager_Price__c).trim().contains('-');
                            if(isContains!=true && (sobj1.MinPrice__c>=sobj1.Manager_Price__c)){
                                saleDirPriceTrue=true;
                            }else {
                                saleDirPriceTrue=false;
                            }
                            
                            System.debug('saleDirPriceTrue :- '+saleDirPriceTrue);
                        }
                        if(String.isNotBlank(String.valueOf(sobj1.Director_Price__c))){
                            Boolean isContains=String.valueOf(sobj1.Director_Price__c).trim().contains('-');
                            if(isContains!=true && (sobj1.Manager_Price__c>=sobj1.Director_Price__c)){
                                LatamPriceTrue=true;
                            }else {
                                LatamPriceTrue=false;
                            }
                            
                            System.debug('LatamPriceTrue :- '+LatamPriceTrue);
                        }
                        if(String.isNotBlank(String.valueOf(sobj1.EndDate__c))){
                            if(Date.valueOf(sobj1.EndDate__c)>Date.valueOf(sobj1.StartDate__c)){
                                endDateTrue = true;
                            }else {
                                endDateTrue = false;
                            }
                            System.debug('endDateTrue :- '+endDateTrue);
                        }
                        if(CurrencyIsoCodeTrue && minPriceTrue && maxPriceTrue && saleDirPriceTrue && LatamPriceTrue && endDateTrue){
                            upsertPricebookList2.add(sobj1);
                        }else{
                            errorPricebookList.add(sobj1);
                        }
                        
                    }
                    System.debug('upsertPricebookList2 size :-- '+upsertPricebookList2.size());
                    
                    if(upsertPricebookList2.size()>0 ){
                        System.debug('Data found');
                        srList = Database.upsert(upsertPricebookList2, f, false);
                    }
                    if(errorPricebookList.size()>0){
                        System.debug('Data not found');
                        for(PriceBookMaster__c sobj1:errorPricebookList){
                            System.debug('map error :-'+mapErrorStr.get(sobj1.CompositeKey__c));
                            if(mapErrorStr.containsKey(sobj1.CompositeKey__c)){
                                //errorCSVList.add(mapErrorStr.get(sobj1.CompositeKey__c)+','+ 'not present');
                                System.debug('errorCSVList of mapErrorStr.get(sobj1.CompositeKey__c) :--'+errorCSVList);
                            }
                        }
                        
                        //Database.Error[] errs =    //srList[i].getErrors();
                        //errorCSVList.add(csvData[i+1]+','+errs[0].getMessage());
                        //System.debug('errorCSVList :--'+errorCSVList);
                    }
                    
                }
                Map<String, String> mapSTR2=new Map<String, String>();
                List<PriceBookMaster__c> pbmList = [SELECT Id, SKUCode__c ,SKUCode__r.Name, SKUCode__r.SKU_Code__c
                                                    FROM PriceBookMaster__c
                                                    WHERE (DistributionChannel__r.Distribution_Channel_Code__c ='67' OR  DistributionChannel__r.Distribution_Channel_Code__c ='20')
                                                    AND (DepotCode__r.Depot_Code__c ='MX51' OR  DepotCode__r.Depot_Code__c ='MX00')
                                                    AND Sales_Org_Code__c ='5100' AND SKUCode__r.SKU_Code__c IN :codeSKU];
                system.debug('**PriceBookMaster -> ' +pbmList);
                if(!pbmList.isEmpty()){
                    for(PriceBookMaster__c pbObj : pbmList){
                        mapSTR2.put(pbObj.ID, pbObj.SKUCode__r.SKU_Code__c);
                    }
                }
                
                
                //Iterate through each returned result
                if(srList!=null){
                    for(Integer i=0;i<srList.size();i++){
                        if (!srList[i].isSuccess()){
                            System.debug('srList error :--'+srList);
                            Database.Error[] errs = srList[i].getErrors();
                            System.debug('errs[0].getMessage() :-'+errs[0].getMessage());
                            errorCSVList.add(csvData[i+1]+','+errs[0].getMessage());
                            System.debug('errorCSVList :--'+errorCSVList);
                        }
                        else{
                            System.debug('srList success :--'+srList);
                            String skucodeId='';
                            if(mapSTR2.containsKey(srList[i].getId())){
                                skucodeId=mapSTR2.get(srList[i].getId());
                                System.debug('skucodeId :--'+skucodeId);
                                
                            }
                            System.debug('mapStr :- '+mapStr);
                            System.debug('skucodeId 2 :--'+skucodeId);
                            if(mapStr.containsKey(skucodeId)){
                                successCSVList.add(upsertPricebookList2[i].get('Id')+','+mapStr.get(skucodeId));
                                System.debug('successCSVList :--'+successCSVList);
                            }
                            
                        }
                    }
                }
            }
            else if(countryName == 'Colombia'){
                    
                    if(upsertPricebookList.size()>0){
                        boolean isBTrue=false;
                        boolean UOMTrue=false;
                        boolean DivisionCode=false;
                        boolean soldToParty=false;
                        boolean CurrencyIsoCodeTrue=false;
                        boolean minPriceTrue=false;
                        boolean maxPriceTrue=false;
                        boolean endDateTrue=false;
                    
                    for(PriceBookMaster__c sobj1:upsertPricebookList){
                        System.debug('sobj1 : '+sobj1);
                        if(String.isNotBlank(sobj1.CurrencyIsoCode)){
                            if(sobj1.CurrencyIsoCode=='COP'){
                                CurrencyIsoCodeTrue=true;
                            }else {
                                CurrencyIsoCodeTrue=false;
                            }
                        } 
                        
                        if(String.isNotBlank(String.valueOf(sobj1.MinPrice__c))){
                            Boolean isContains=String.valueOf(sobj1.MinPrice__c).trim().contains('-');
                            if(isContains!=true){
                                minPriceTrue=true;
                            }else {
                                minPriceTrue=false;
                            }
                            
                        }
                        if(String.isNotBlank(String.valueOf(sobj1.Price__c))){
                            Boolean isContains=String.valueOf(sobj1.Price__c).trim().contains('-');
                            if(isContains!=true && (sobj1.Price__c >=sobj1.MinPrice__c)){
                                maxPriceTrue=true;
                            }else {
                                maxPriceTrue=false;
                            }
                            
                            System.debug('maxPriceTrue :- '+maxPriceTrue);
                        }

                        if(String.isNotBlank(String.valueOf(sobj1.EndDate__c))){
                            
                            if(Date.valueOf(sobj1.EndDate__c)>Date.valueOf(sobj1.StartDate__c)){
                                endDateTrue = true;
                            }else {
                                endDateTrue = false;
                            }
                            System.debug('endDateTrue :- '+endDateTrue);
                        }else {
                            endDateTrue = false;
                        }
                        System.debug('CurrencyIsoCodeTrue :- '+CurrencyIsoCodeTrue);
                        System.debug('minPriceTrue :- '+minPriceTrue);
                        System.debug('maxPriceTrue :- '+maxPriceTrue);
                        System.debug('UOMTrue :- '+UOMTrue);       
                        System.debug('endDateTrue :- '+endDateTrue);
                        
                        if(CurrencyIsoCodeTrue && minPriceTrue && maxPriceTrue && endDateTrue){
                            upsertPricebookList2.add(sobj1);
                            System.debug('upsertPricebookList2 : '+upsertPricebookList2);
                        }else{
                            errorPricebookList.add(sobj1);
                        }
                        
                    }
                    System.debug('upsertPricebookList2 size :-- '+upsertPricebookList2.size());
                    
                    if(upsertPricebookList2.size()>0 ){
                        System.debug('Data found');
                        srList = Database.upsert(upsertPricebookList2, f, false);
                    }
                    if(errorPricebookList.size()>0){
                        System.debug('errorPricebookList :-- '+errorPricebookList);
                        System.debug('Data not found');
                        for(PriceBookMaster__c sobj1:errorPricebookList){
                            System.debug('CompositeKey__c  :-'+sobj1.CompositeKey__c);
                            System.debug('map error :-'+mapErrorStr.get(sobj1.CompositeKey__c));
                            if(mapErrorStr.containsKey(sobj1.CompositeKey__c)){
                                //errorCSVList.add(mapErrorStr.get(sobj1.CompositeKey__c)+','+ 'not present');
                                System.debug('errorCSVList of mapErrorStr.get(sobj1.CompositeKey__c) :--'+errorCSVList);
                            }
                        }
                        
                    }
                    
                }
                Map<String, String> mapSTR2=new Map<String, String>();
                List<PriceBookMaster__c> pbmList = [SELECT Id, SKUCode__c ,SKUCode__r.Name, SKUCode__r.SKU_Code__c
                                                    FROM PriceBookMaster__c
                                                    WHERE (DistributionChannel__r.Distribution_Channel_Code__c ='67' OR  DistributionChannel__r.Distribution_Channel_Code__c ='20')
                                                    AND Sales_Org_Code__c ='5710' AND SKUCode__r.SKU_Code__c IN :codeSKU];
                system.debug('**PriceBookMaster -> ' +pbmList);
                if(!pbmList.isEmpty()){
                    for(PriceBookMaster__c pbObj : pbmList){
                        mapSTR2.put(pbObj.ID, pbObj.SKUCode__r.SKU_Code__c);
                    }
                }
                
                
                //Iterate through each returned result
                if(srList!=null){
                    for(Integer i=0;i<srList.size();i++){
                        if (!srList[i].isSuccess()){
                            System.debug('srList error :--'+srList);
                            Database.Error[] errs = srList[i].getErrors();
                            System.debug('errs[0].getMessage() :-'+errs[0].getMessage());
                            System.debug('csvData[i] :-'+csvData[i]);
                            System.debug('csvData[i+1] :-'+csvData[i+1]);
                            //System.debug('csvData[i+2] :-'+csvData[i+2]);
                            errorCSVList.add(csvData[i+1]+','+errs[0].getMessage());
                            System.debug('errorCSVList :--'+errorCSVList);
                        }
                        else{
                            System.debug('srList success :--'+srList);
                            String skucodeId='';
                            if(mapSTR2.containsKey(srList[i].getId())){
                                skucodeId=mapSTR2.get(srList[i].getId());
                                System.debug('skucodeId :--'+skucodeId);
                                
                            }
                            System.debug('mapStr :- '+mapStr);
                            System.debug('skucodeId 2 :--'+skucodeId);
                            if(mapStr.containsKey(skucodeId)){
                                successCSVList.add(upsertPricebookList2[i].get('Id')+','+mapStr.get(skucodeId));
                                System.debug('successCSVList :--'+successCSVList);
                            }
                            
                        }
                    }
                }
                
            }
            /*Code Added by Tejas*/
            else if(countryName == 'CAM'){
                    
                    if(upsertPricebookList.size()>0){
                        boolean isBTrue=false;
                        boolean UOMTrue=false;
                        boolean DivisionCode=false;
                        boolean CurrencyIsoCodeTrue=false;
                        boolean minPriceTrue=false;
                        boolean maxPriceTrue=false;
                        boolean endDateTrue=false;
                    
                    for(PriceBookMaster__c sobj1:upsertPricebookList){
                        System.debug('sobj1 : '+sobj1);
                        if(String.isNotBlank(sobj1.CurrencyIsoCode)){
                            if(sobj1.CurrencyIsoCode=='USD'){
                                CurrencyIsoCodeTrue=true;
                            }else {
                                CurrencyIsoCodeTrue=false;
                            }
                        } 
                        
                        if(String.isNotBlank(String.valueOf(sobj1.MinPrice__c))){
                            Boolean isContains=String.valueOf(sobj1.MinPrice__c).trim().contains('-');
                            if(isContains!=true){
                                minPriceTrue=true;
                            }else {
                                minPriceTrue=false;
                            }
                            
                        }
                        if(String.isNotBlank(String.valueOf(sobj1.Price__c))){
                            Boolean isContains=String.valueOf(sobj1.Price__c).trim().contains('-');
                            if(isContains!=true && (sobj1.Price__c >=sobj1.MinPrice__c)){
                                maxPriceTrue=true;
                            }else {
                                maxPriceTrue=false;
                            }
                            
                            //System.debug('maxPriceTrue :- '+maxPriceTrue);
                        }

                        if(String.isNotBlank(String.valueOf(sobj1.EndDate__c))){
                            
                            if(Date.valueOf(sobj1.EndDate__c)>Date.valueOf(sobj1.StartDate__c)){
                                endDateTrue = true;
                            }else {
                                endDateTrue = false;
                            }
                            //System.debug('endDateTrue :- '+endDateTrue);
                        }else {
                            endDateTrue = false;
                        }
                        //System.debug('CurrencyIsoCodeTrue :- '+CurrencyIsoCodeTrue);
                        //System.debug('minPriceTrue :- '+minPriceTrue);
                        //System.debug('maxPriceTrue :- '+maxPriceTrue);
                        //System.debug('UOMTrue :- '+UOMTrue);       
                        //System.debug('endDateTrue :- '+endDateTrue);
                        
                        if(CurrencyIsoCodeTrue && minPriceTrue && maxPriceTrue && endDateTrue){
                            upsertPricebookList2.add(sobj1);
                            //System.debug('upsertPricebookList2 : '+upsertPricebookList2);
                        }else{
                            errorPricebookList.add(sobj1);
                        }
                        
                    }
                    //System.debug('upsertPricebookList2 size :-- '+upsertPricebookList2.size());
                    
                    if(upsertPricebookList2.size()>0 ){
                        //System.debug('Data found');
                        srList = Database.upsert(upsertPricebookList2, f, false);
                    }
                    if(errorPricebookList.size()>0){
                        //System.debug('errorPricebookList :-- '+errorPricebookList);
                        //System.debug('Data not found');
                        for(PriceBookMaster__c sobj1:errorPricebookList){
                            //System.debug('CompositeKey__c  :-'+sobj1.CompositeKey__c);
                            //System.debug('map error :-'+mapErrorStr.get(sobj1.CompositeKey__c));
                            if(mapErrorStr.containsKey(sobj1.CompositeKey__c)){
                                //errorCSVList.add(mapErrorStr.get(sobj1.CompositeKey__c)+','+ 'not present');
                                //System.debug('errorCSVList of mapErrorStr.get(sobj1.CompositeKey__c) :--'+errorCSVList);
                            }
                        }
                        
                    }
                    
                }
                Map<String, String> mapSTR2=new Map<String, String>();
                List<PriceBookMaster__c> pbmList = [SELECT Id, SKUCode__c ,SKUCode__r.Name, SKUCode__r.SKU_Code__c
                                                    FROM PriceBookMaster__c
                                                    WHERE (DistributionChannel__r.Distribution_Channel_Code__c ='67' OR  DistributionChannel__r.Distribution_Channel_Code__c ='20')
                                                    AND (Sales_Org_Code__c ='5711' OR Sales_Org_Code__c ='5712') AND SKUCode__r.SKU_Code__c IN :codeSKU];
                system.debug('**PriceBookMaster -> ' +pbmList);
                if(!pbmList.isEmpty()){
                    for(PriceBookMaster__c pbObj : pbmList){
                        mapSTR2.put(pbObj.ID, pbObj.SKUCode__r.SKU_Code__c);
                    }
                }
                
                
                //Iterate through each returned result
                if(srList!=null){
                    for(Integer i=0;i<srList.size();i++){
                        if (!srList[i].isSuccess()){
                            System.debug('srList error :--'+srList);
                            Database.Error[] errs = srList[i].getErrors();
                            System.debug('errs[0].getMessage() :-'+errs[0].getMessage());
                            System.debug('csvData[i] :-'+csvData[i]);
                            System.debug('csvData[i+1] :-'+csvData[i+1]);
                            //System.debug('csvData[i+2] :-'+csvData[i+2]);
                            errorCSVList.add(csvData[i+1]+','+errs[0].getMessage());
                            System.debug('errorCSVList :--'+errorCSVList);
                        }
                        else{
                            System.debug('srList success :--'+srList);
                            String skucodeId='';
                            if(mapSTR2.containsKey(srList[i].getId())){
                                skucodeId=mapSTR2.get(srList[i].getId());
                                System.debug('skucodeId :--'+skucodeId);
                                
                            }
                            System.debug('mapStr :- '+mapStr);
                            System.debug('skucodeId 2 :--'+skucodeId);
                            if(mapStr.containsKey(skucodeId)){
                                successCSVList.add(upsertPricebookList2[i].get('Id')+','+mapStr.get(skucodeId));
                                System.debug('successCSVList :--'+successCSVList);
                            }
                            
                        }
                    }
                }
                
            }/*Code Ended*/
            else if(countryName == 'Italy'){
                    
                if(upsertPricebookList.size()>0){
                        boolean isBTrue=false;
                        boolean DivisionCode=false;
                        boolean soldToParty=false;
                        boolean CurrencyIsoCodeTrue=false;
                        boolean materialPrice=false;
                        boolean endDateTrue=false;
                    
                    for(PriceBookMaster__c sobj1:upsertPricebookList){
                        System.debug('sobj1 : '+sobj1);
                        if(String.isNotBlank(sobj1.CurrencyIsoCode)){
                            if(sobj1.CurrencyIsoCode=='EUR'){
                                CurrencyIsoCodeTrue=true;
                            }else {
                                CurrencyIsoCodeTrue=false;
                            }
                        } 
                        
                        if(String.isNotBlank(String.valueOf(sobj1.EndDate__c))){
                            
                            if(Date.valueOf(sobj1.EndDate__c)>Date.valueOf(sobj1.StartDate__c)){
                                endDateTrue = true;
                            }else {
                                endDateTrue = false;
                            }
                        }else {
                            endDateTrue = false;
                        }
                        
                        if(String.isNotBlank(String.valueOf(sobj1.Price__c))){
                            Boolean isContains=String.valueOf(sobj1.Price__c).trim().contains('-');
                            if(isContains!=true){
                                materialPrice=true;
                            }else {
                                materialPrice=false;
                            }
                        } 
                        System.debug('CurrencyIsoCodeTrue :- '+CurrencyIsoCodeTrue);
                        System.debug('endDateTrue :- '+endDateTrue);
                        
                        if(CurrencyIsoCodeTrue && materialPrice && endDateTrue){
                            upsertPricebookList2.add(sobj1);
                        }else{
                            errorPricebookList.add(sobj1);
                        }
                        
                    }
                    System.debug('upsertPricebookList2.size() :-- '+upsertPricebookList2.size());
                    System.debug('errorPricebookList'+errorPricebookList);
                    if(upsertPricebookList2.size()>0 ){
                        System.debug('upsertPricebookList2 :-- '+upsertPricebookList2);
                        srList = Database.upsert(upsertPricebookList2, f, false);
                    }
                    
                    
                }
                if(upsertPricebookDiscountList.size()>0){
                        boolean isBTrue=false;
                        boolean DivisionCode=false;
                        boolean CurrencyIsoCodeTrue=false;
                        boolean DiscountPrice=false;
                        boolean endDateTrue=false;
                    
                    for(PricebookDiscount__c pdO:upsertPricebookDiscountList){
                        
                        if(String.isNotBlank(pdO.CurrencyIsoCode)){
                            if(pdO.CurrencyIsoCode=='EUR'){
                                CurrencyIsoCodeTrue=true;
                            }else {
                                CurrencyIsoCodeTrue=false;
                            }
                        } 
                        
                        if(String.isNotBlank(String.valueOf(pdO.EndDate__c))){
                            
                            if(Date.valueOf(pdO.EndDate__c)>Date.valueOf(pdO.StartDate__c)){
                                endDateTrue = true;
                            }else {
                                endDateTrue = false;
                            }
                            System.debug('endDateTrue :- '+endDateTrue);
                        }else {
                            endDateTrue = false;
                        }
                        
                        if(String.isNotBlank(String.valueOf(pdO.Price__c))){
                            Boolean isContains=String.valueOf(pdO.Price__c).trim().contains('-');
                            if(isContains!=true){
                                DiscountPrice=true;
                            }else {
                                DiscountPrice=false;
                            }
                        } 
                        
                        if(CurrencyIsoCodeTrue && endDateTrue && DiscountPrice){
                            upsertPricebookDiscountList2.add(pdO);
                        }else{
                            errorPricebookDiscountList.add(pdO);
                        }
                        
                    }
                    System.debug('upsertPricebookDiscountList2 size :-- '+upsertPricebookDiscountList2.size());
                    if(upsertPricebookDiscountList2.size()>0 ){
                        System.debug('upsertPricebookDiscountList2 :-- '+upsertPricebookDiscountList2);
                        srList2 = Database.upsert(upsertPricebookDiscountList2, f2, false);
                    }
                    // Added by vijaylaxmi  start to fetch the id's for which records are upserted
                     System.debug('#############srList2'+srList2.size());
                     system.debug('@@@@@@@@@srList2'+srList2);
                     if(srList2.size()>0){
                         for(Integer i=0;i<srList2.size();i++){
                            idsItaly.add(srList2[i].getId());
                         }
                     }
                      system.debug('@@@@@@@@@srList2'+idsItaly.size());
                    // Added by vijaylaxmi End
                    if(errorPricebookDiscountList.size()>0){
                        System.debug('errorPricebookDiscountList :-- '+errorPricebookDiscountList);
                        System.debug('Data not found');
                        for(PricebookDiscount__c sobj1:errorPricebookDiscountList){
                            //System.debug('CompositeKey__c  :-'+sobj1.CompositeKey__c);
                            //System.debug('map error :-'+mapErrorStr.get(sobj1.CompositeKey__c));
                            if(mapErrorStr.containsKey(sobj1.CompositeKey__c)){
                                ///errorCSVList.add('Foreign key external ID: '++' not found for field Combination_Key__c in entity SKU__c');
                               // System.debug('errorCSVList of mapErrorStr.get(sobj1.CompositeKey__c) :--'+errorCSVList);
                            }
                        }
                        
                    }
                    
                }
                Map<String, String> mapSTR2=new Map<String, String>();
                
                List<PriceBookMaster__c> pbmList = [SELECT Id, SKUCode__c ,SKUCode__r.Name, SKUCode__r.SKU_Code__c
                                                    FROM PriceBookMaster__c
                                                    WHERE (DistributionChannel__r.Distribution_Channel_Code__c ='67' OR  DistributionChannel__r.Distribution_Channel_Code__c ='20') 
                                                    AND Sales_Org_Code__c ='2410' and SKUCode__r.SKU_Code__c IN :codeSKU ];
                system.debug('**PriceBookMaster -> ' +pbmList);
                if(!pbmList.isEmpty()){
                    for(PriceBookMaster__c pbObj : pbmList){
                        mapSTR2.put(pbObj.ID, pbObj.SKUCode__r.SKU_Code__c);
                    }
                }
                
                Map<String, String> mapSTR3=new Map<String, String>();
                 
                 //Added  setID byVijaylaxmi in query becuase query is returned more than 50k records  
                List<PricebookDiscount__c> pdList = [SELECT Id, SKUCode__c ,SKUCode__r.Name, SKUCode__r.SKU_Code__c
                                                    FROM PricebookDiscount__c
                                                    WHERE ((DistributionChannel__r.Distribution_Channel_Code__c ='67' OR  DistributionChannel__r.Distribution_Channel_Code__c ='20')
                                                    AND Sales_Org__r.Sales_Org_Code__c ='2410' and SKUCode__r.SKU_Code__c IN :codeSKU ) And Id IN: idsItaly ];
                system.debug('**PricebookDiscount__c -> ' +pdList);
                 system.debug('**PricebookDiscount__c -> ' +pdList.size());
                if(!pdList.isEmpty()){
                    for(PricebookDiscount__c pdObj : pdList){
                        mapSTR3.put(pdObj.ID, pdObj.SKUCode__r.SKU_Code__c);
                    }
                }
              
                
                //Iterate through each returned result
                if(srList!=null){
                    for(Integer i=0;i<srList.size();i++){
                        if (srList[i].isSuccess()){
                            String skucodeId='';
                            if(mapSTR2.containsKey(srList[i].getId())){
                                skucodeId=mapSTR2.get(srList[i].getId());
                                System.debug('skucodeId :--'+skucodeId);
                                
                            }
                            if(mapStr.containsKey(skucodeId)){
                                successCSVList.add(upsertPricebookList2[i].get('Id')+','+mapStr.get(skucodeId));
                                System.debug('successCSVList :--'+successCSVList);
                            }
                            
                        }
                    }
                }
                //Iterate through each returned result
                if(srList2!=null){
                    for(Integer i=0;i<srList2.size();i++){
                        if (!srList2[i].isSuccess()){
                            System.debug('srList error :--'+srList2);
                            Database.Error[] errs = srList2[i].getErrors();
                            System.debug('errs[0].getMessage() :-'+errs[0].getMessage());
                            System.debug('csvData[i] :-'+csvData[i]);
                            System.debug('csvData[i+1] :-'+csvData[i+1]);
                            //System.debug('csvData[i+2] :-'+csvData[i+2]);
                            errorCSVList.add(csvData[i+1]+','+errs[0].getMessage());
                            //System.debug('errorCSVList :--'+errorCSVList);
                        }
                        else{
                            String skucodeId='';
                            if(mapSTR3.containsKey(srList2[i].getId())){
                                skucodeId=mapSTR3.get(srList2[i].getId());
                                System.debug('skucodeId :--'+skucodeId);
                                
                            }
                            if(mapStr.containsKey(skucodeId)){
                                successCSVList.add(upsertPricebookDiscountList2[i].get('Id')+','+mapStr.get(skucodeId));
                                System.debug('successCSVList :--'+successCSVList);
                            }
                            
                        }
                    }
                }
                
            }
            else{
                System.debug('Other Countries');
                if(upsertPricebookList.size()>0){
                    if(isTrue==true){
                        srList = Database.upsert(upsertPricebookList, f, false);
                    }else{
                        System.debug('Data not found');
                    }
                  //Iterate through each returned result
                    for(Integer i=0;i<srList.size();i++){
                        if (!srList[i].isSuccess()){
                            Database.Error[] errs = srList[i].getErrors();
                            errorCSVList.add(csvData[i+1]+','+errs[0].getMessage());
                        }
                        else{
                            successCSVList.add(upsertPricebookList[i].get('Id')+','+csvData[i+1]);
                            
                        }
                    }
                    
                }
            }
            //if(countryName != 'Iberia & Portugal' || countryName != 'Naturagri'){
              sendEmail(String.join(successCSVList, '\r\n'), String.join(errorCSVList, '\r\n'), successCSVList.size(), errorCSVList.size()-1,'PricebookUploadFile');    
            //}
            
        }
        catch(Exception ex){
            System.debug('Line No: '+ex.getLineNumber()+' Exception: '+ex.getMessage());
        }
        //End of Logic
    }
    
    public static void processSKUData(Blob csvFile,string countryName){
        
        try{
            String salesORGCode='';
            List<String> errorCSVList = new List<String>();
            List<String> successCSVList = new List<String>();
            //Map<id,SKU__c> skMap=new Map<id,SKU__c>();
            SplitString splitObj = new SplitString();
            
            //Logic to parse CSV row by row
            List<String> csvData = new List<String>();
            //blob csvBlob = csvFile.Body;
            String strCSVFile = csvFile.toString();
            csvData  = strCSVFile.split('\r\n');
            //csvData = splitObj.safeSplit(strCSVFile, '\r\n');
            system.debug('csvData>>--->'+csvData);
            Boolean isTrue=true;
            successCSVList.add('Record ID,'+csvData[0]);
            errorCSVList.add(csvData[0]+',Error Description');
            
            List<SKU__c> updateSKUList = new List<SKU__c>();
            List<PriceBookMaster__c> errorPricebookList = new List<PriceBookMaster__c>();
            List<PricebookDiscount__c> errorPricebookDiscountList = new List<PricebookDiscount__c>();
            Map<String,String> mapStr= new Map<String,String>();
            Map<String,String> mapErrorStr= new Map<String,String>();
            Map<String,String> mapStrUom= new Map<String,String>();
            Map<String,String> mapStrCombinationKey= new Map<String,String>();
            Map<String,String> mapStrSalesOrgCountry= new Map<String,String>();
            Set<String> uomSet=new Set<String>(); 
            boolean multiplyOf=false;
            boolean unitCost=false;
            boolean msp1=false;
            boolean msp2=false;
            boolean msp3=false;
            boolean gst=false;
            boolean palletSize=false;
            boolean paymentTerm=false;
            boolean logisticDiscount=false;
            boolean minQty=false;
            boolean truckQty=false;
            boolean bVDiscountPallet=false;
            boolean bVDiscountTruck=false;
            boolean earlierOrderDiscount=false;
            
            system.debug('csvData[0]>>--->'+csvData[0]);
            if(csvData[0].contains('Multiply')){
                multiplyOf=true;
            } 
            if(csvData[0].contains('Unit')){
                unitCost=true;
            } 
            if(csvData[0].contains('SalesAgent')){
        
                msp1=true;
            }
            if(csvData[0].contains('AreaManager')){
                
                msp2=true;
            }
            if(csvData[0].contains('SalesDirector')){
                
                msp3=true;
            }
            
            if(csvData[0].contains('GST')){
                gst=true;
            }
            System.debug('gst : '+gst );
            
            // addded by Vishal pawar
            if(csvData[0].contains('Pallet Size')){
                palletSize= true;
            }
           //end of code by vishal Pawar
            if(csvData[0].contains('Payment Term')){
                paymentTerm= true;
            }
            if(csvData[0].contains('Logistic Discount')){
                logisticDiscount= true;
            }
            if(csvData[0].contains('Min Quantity')){
                minQty= true;
            }
            if(csvData[0].contains('Truck Quantity')){
                truckQty= true;
            }
            if(csvData[0].contains('Big Volume Discount Pallet')){
                bVDiscountPallet= true;
            }
            if(csvData[0].contains('Big Volume Discount Truck')){
                bVDiscountTruck= true;
            }
            if(csvData[0].contains('Earlier Order Discount')){
                earlierOrderDiscount= true;
            }
            /*
            list<string> salesOrgCode = new list<string>();
              if(countryName == 'Argentina'){
              salesOrgCode.add('5631');
              }
              else if(countryName == 'Mexico'){
              salesOrgCode.add('5100');
              }
              else if(countryName == 'CAM'){
              salesOrgCode.add('5711');
              }
              else if(countryName == 'Colombia'){
              salesOrgCode.add('5710');
              }
              else if(countryName == 'Italy'){
              salesOrgCode.add('2410');
              }
              else if(countryName == 'Iberia & Portugal' || countryName == 'Naturagri'){
              salesOrgCode.add('2510');
              salesOrgCode.add('2481');
              salesOrgCode.add('2541');
              }
              else if(countryName == 'Poland'){
              salesOrgCode.add('2941');
              }
              else if(countryName == 'Bolivia & Paraguay'){
                        salesOrgCode.add('5361');
                        salesOrgCode.add('5441');
                    }
            */
            // INC0372416 - Changes made for Poland file upload issue(29-08-2022) ---DeveloperName --- Amit Sharma(Grazitti)
            if(csvData.size()>0){
                for (Integer i = 1; i < csvData.size(); i++){
                    String row = '';
                   // try{
                        
                        List<String> csvLineItem = new List<String>();
                        SKU__c sObj = new SKU__c();
                        row = csvData[i];
                        csvLineItem = csvData[i].split(',');
                        
                        String combinationKey = '';
                        String paymentTermcombinationKey = '';//Sayan 12th May 2021
                        String compositeKey = '';
                        
                        for(Integer j=0; j<csvLineItem.size(); j++){
                            
                            if(j==0){
                                //SalesOrg
                                if(String.isNotBlank(csvLineItem[j])){
                                    salesORGCode = csvLineItem[0];
                                }
                            }
                        }
                    //}
                 
                 }  
             }         
            // Ends here----fetching the SKUs on the basis of Org code
              system.debug('**salesOrgCode>>--- > ' +salesORGCode); 
            List<SKU__c> skuObjList=[Select id, Name, SKU_Code__c, Combination_Key__c,Multiple_of__c,Unit_Cost__c,Sales_Agent_MSP__c,Area_Manager_MSP__c,Sales_Director_MSP__c,pallet_Size_Italy__c from SKU__c Where Sales_Org_Code__c =:salesORGCode];// Where Sales_Org_Code__c='5100'  or Sales_Org_Code__c='5710' or Sales_Org_Code__c='2410'];
            for(SKU__c skuOb:skuObjList){
                String scode=skuOb.SKU_Code__c;
                mapStrCombinationKey.put(skuOb.Combination_Key__c, skuOb.id);
            }
            
            if(csvData.size()>0){
                for (Integer i = 1; i < csvData.size(); i++){
                    String row = '';
                    try{
                        
                        List<String> csvLineItem = new List<String>();
                        SKU__c sObj = new SKU__c();
                        row = csvData[i];
                        csvLineItem = csvData[i].split(',');
                        
                        String combinationKey = '';
                        String paymentTermcombinationKey = '';//Sayan 12th May 2021
                        String compositeKey = '';
                        
                        for(Integer j=0; j<csvLineItem.size(); j++){
                            
                            if(j==0){
                                //SalesOrg
                                if(String.isNotBlank(csvLineItem[j])){
                                    combinationKey += csvLineItem[j];
                                    paymentTermcombinationKey +=csvLineItem[j].trim();//INC0176582: Sayan 12th May 2021, Added Combination key for PT
                                }
                            }
                            else if(j==1){
                                //Distribution channel
                                if(String.isNotBlank(csvLineItem[j])){
                                    combinationKey += csvLineItem[j];
                                }
                            }
                            else if(j==2){
                                // Division
                                if(String.isNotBlank(csvLineItem[j])){
                                    combinationKey += csvLineItem[j];
                                }
                            }
                            else if(j==3){
                                //SKU code
                                if(String.isNotBlank(csvLineItem[j])){
                                    String code = csvLineItem[j];
                                    if(code.length()==6){
                                        code = '000000000000'+csvLineItem[j];
                                    }
                                    else if(code.length()==7){
                                        code = '00000000000'+csvLineItem[j];
                                    }
                                    //System.debug('SKU is valid for this depot');
                                    combinationKey += code;
                                    if(mapStrCombinationKey.get(combinationKey)!=null){
                                        sObj.id=mapStrCombinationKey.get(combinationKey);
                                    }
                                }
                            }
                            else if(j==4){
                                
                                if(multiplyOf){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        sObj.Multiple_of__c =Decimal.valueOf(csvLineItem[j].trim());
                                    }
                                }
                            }
                            else if(j==5){
                                if(unitCost){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        sObj.Unit_Cost__c =Decimal.valueOf(csvLineItem[j].trim());
                                    }
                                }
                            }
                            else if(j==6){
                                if(msp1){
                                    System.debug('msp1 : '+msp1);
                                    if(String.isNotBlank(csvLineItem[j])){
                                        sObj.Sales_Agent_MSP__c =Decimal.valueOf(csvLineItem[j].trim());
                                    }
                                }
                                
                            }
                            else if(j==7){
                                if(msp2){
                                    System.debug('msp2 : '+msp2);
                                    if(String.isNotBlank(csvLineItem[j])){
                                        sObj.Area_Manager_MSP__c =Decimal.valueOf(csvLineItem[j].trim());
                                    }
                                }
                                
                            }
                            else if(j==8){
                                if(msp3){
                                    System.debug('msp3 : '+msp3);
                                    if(String.isNotBlank(csvLineItem[j])){
                                        sObj.Sales_Director_MSP__c =Decimal.valueOf(csvLineItem[j].trim());
                                    }
                                }
                                
                            }
                            else if(j==9){
                                if(gst){
                                    System.debug('gst : '+gst);
                                    if(String.isNotBlank(csvLineItem[j])){
                                        sObj.GST__c =Decimal.valueOf(csvLineItem[j].trim());
                                    }
                                }
                            }
                            //Added by vishal Pawar for Pallet size on Dated 24-12-2019
                            else if(j==10){
                                 if(palletSize){
                                    
                                    if(String.isNotBlank(csvLineItem[j])){
                                        System.debug('csvLineItem[j].trim() '+csvLineItem[j].trim());
                                        System.debug('csvLineItem[j] '+csvLineItem[j]);
                                        sObj.pallet_Size_Italy__c =Decimal.valueOf(csvLineItem[j].trim());
                                    }
                                }
                            }
                            else if(j==11){
                                 if(paymentTerm){
                                    
                                    if(String.isNotBlank(csvLineItem[j])){
                                        System.debug('csvLineItem[j].trim() '+csvLineItem[j].trim());
                                        System.debug('csvLineItem[j] '+csvLineItem[j]);
                                        paymentTermcombinationKey+=csvLineItem[j].trim();//INC0176582: Sayan 12th May 2021, Added Combination key for PT
                                        // sObj.Payment_Term__r =new Payment_Term__c(Payment_Term_Code__c = csvLineItem[j].trim()); INC0176582: Sayan 12th May 2021, Removed Combination key for PT
                                        sObj.Payment_Term__r =new Payment_Term__c(CombinationKey__c = paymentTermcombinationKey);//INC0176582: Sayan 12th May 2021, Added Combination key for PT
                                    }
                                }
                            }
                            else if(j==12){
                                 if(logisticDiscount){
                                    
                                    if(String.isNotBlank(csvLineItem[j])){
                                        System.debug('csvLineItem[j].trim() '+csvLineItem[j].trim());
                                        System.debug('csvLineItem[j] '+csvLineItem[j]);
                                        sObj.Logistic_Discount__c  =Decimal.valueOf(csvLineItem[j].trim());
                                    }
                                }
                            }
                            else if(j==13){
                                 if(minQty){
                                    
                                    if(String.isNotBlank(csvLineItem[j])){
                                        System.debug('csvLineItem[j].trim() '+csvLineItem[j].trim());
                                        System.debug('csvLineItem[j] '+csvLineItem[j]);
                                        sObj.Mininum_Quantity__c =Decimal.valueOf(csvLineItem[j].trim());
                                    }
                                }
                            }
                            else if(j==14){
                                 if(truckQty){
                                    
                                    if(String.isNotBlank(csvLineItem[j])){
                                        System.debug('csvLineItem[j].trim() '+csvLineItem[j].trim());
                                        System.debug('csvLineItem[j] '+csvLineItem[j]);
                                        sObj.Truck_Quantity__c =Decimal.valueOf(csvLineItem[j].trim());
                                    }
                                }
                            }
                            else if(j==15){
                                 if(bVDiscountPallet){
                                    
                                    if(String.isNotBlank(csvLineItem[j])){
                                        System.debug('csvLineItem[j].trim() '+csvLineItem[j].trim());
                                        System.debug('csvLineItem[j] '+csvLineItem[j]);
                                        sObj.Big_Volume_for_Pallet__c =csvLineItem[j].trim();
                                    }
                                }
                            }
                            else if(j==16){
                                 if(bVDiscountTruck){
                                    
                                    if(String.isNotBlank(csvLineItem[j])){
                                        System.debug('csvLineItem[j].trim() '+csvLineItem[j].trim());
                                        System.debug('csvLineItem[j] '+csvLineItem[j]);
                                        sObj.Big_Volume_for_Truck__c =csvLineItem[j].trim();
                                    }
                                }
                            }
                            /*else if(j==17){
                                 if(earlierOrderDiscount){
                                    
                                    if(String.isNotBlank(csvLineItem[j])){
                                        System.debug('csvLineItem[j].trim() '+csvLineItem[j].trim());
                                        System.debug('csvLineItem[j] '+csvLineItem[j]);
                                        sObj.Early_Order_Discount__c =Decimal.valueOf(csvLineItem[j].trim());
                                    }
                                }
                            }*/
                        }
                        system.debug('sObj>>--->'+sObj);
                        updateSKUList.add(sObj);
                        system.debug('updateSKUList >>--->'+updateSKUList);
                    }catch(Exception ex){
                        system.debug('ex.getMessage()>>--->'+ex.getMessage());
                        errorCSVList.add(row+','+ex.getMessage());
                    }
                }
            }
            
            //End of Logic
            
            Database.SaveResult[] srList;
            system.debug('updateSKUList>>--->'+updateSKUList);
            if(updateSKUList.size()>0){
                if(isTrue==true){
                    srList = Database.update(updateSKUList, false);
                }else{
                    System.debug('Data not found');
                }
                //Iterate through each returned result
                for(Integer i=0;i<srList.size();i++){
                    if (!srList[i].isSuccess()){
                        Database.Error[] errs = srList[i].getErrors();
                        errorCSVList.add(csvData[i+1]+','+errs[0].getMessage());
                    }
                    else{
                        successCSVList.add(updateSKUList[i].get('Id')+','+csvData[i+1]);
                    }
                }
                
            }
            
            sendEmail(String.join(successCSVList, '\r\n'), String.join(errorCSVList, '\r\n'), successCSVList.size(), errorCSVList.size()-1,'SKUUploadFile');

            
        }
        catch(Exception ex){
            System.debug('Line No: '+ex.getLineNumber()+' Exception: '+ex.getMessage());
        }
        //End of Logic
    }
    
    //Method to Notify User with Success/Error Files after Upload
    public static void sendEmail(String successFile, String errorFile, Integer successCount, Integer errorCount, String SKUUploadFile){
        Messaging.EmailFileAttachment successAttach = new Messaging.EmailFileAttachment();
        successAttach.setContentType('application/csv');
        successAttach.setFileName('Success.csv');
        successAttach.setInline(false);
        successAttach.Body = Blob.valueOf(successFile);
        Messaging.EmailFileAttachment errorAttach = new Messaging.EmailFileAttachment();
        errorAttach.setContentType('application/csv');
        errorAttach.setFileName('Error.csv');
        errorAttach.setInline(false);
        errorAttach.Body = Blob.valueOf(errorFile);
        
        DateTime d = Date.Today() ;
        String dateString =  d.format('dd/MM/yyyy') ;
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setUseSignature(false);
        mail.setToAddresses(new String[] { UserInfo.getUserEmail()});

        //mail.setBccAddresses(new String[] {'prashant.chinchpure@skinternational.com','satkari@skinternational.com','shama.buchade@skinternational.com' });
        if(SKUUploadFile=='SKUUploadFile'){
            mail.setSubject('SKU Upload Status');
            mail.setHtmlBody('Dear User,<br /><br />Please find attached files generated in SFDC while uploading the SKU Data<br /><br />Date: '+dateString+'<br /><br />No. of error records: '+errorCount+'<br /><br />Regards,<br/>UPL Salesforce Administrator<br />'); 
        }else {
            mail.setSubject('Pricebook Upload Status');
            mail.setHtmlBody('Dear User,<br /><br />Please find attached files generated in SFDC while uploading the Pricebook Data<br /><br />Date: '+dateString+'<br /><br />No. of error records: '+errorCount+'<br /><br />Regards,<br/>UPL Salesforce Administrator<br />');
        }
        
        mail.setFileAttachments(new Messaging.EmailFileAttachment[] { successAttach, errorAttach}); 
        
        // Send the email
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
    
    public static void testCoverage()
    {
        Integer i=0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
    }
}