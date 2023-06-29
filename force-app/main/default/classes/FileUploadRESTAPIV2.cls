public without sharing class FileUploadRESTAPIV2 {
    
    public static void processData(String countryName,String SPNPBWise,String NaturagriPBWise,List<String> csvData,Map<String,String> mapStrUom,List<String> successCSVList,List<String> errorCSVList){
        
        try{
            system.debug('countryName >>--->'+countryName);
            Boolean isTrue=true;
            Boolean pIDCheck=false;
            //successCSVList.add('Record ID,'+csvData[0]);
            //errorCSVList.add(csvData[0]+',Error Description');
            String PAK = ''; // added by Nandhini w.r.t CR-2521
            set<string> codeSKU = new set<string>();
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
            List<PriceBook_Indonesia_Discount__c> upsertPricebookIndonesiaDiscountCPList = new List<PriceBook_Indonesia_Discount__c>();
            List<PriceBook_Indonesia_Discount__c> upsertPricebookIndonesiaDiscountList = new List<PriceBook_Indonesia_Discount__c>();
            List<PriceBook_Indonesia_Discount__c> upsertPricebookIndonesiaDiscountList2 = new List<PriceBook_Indonesia_Discount__c>();
            List<PriceBook_Indonesia_Discount__c> errorPricebookIndonesiaDiscountList = new List<PriceBook_Indonesia_Discount__c>();
            
            Map<String,String> mapStr= new Map<String,String>();
            Map<String,String> mapErrorStr= new Map<String,String>();
           
            if(countryName == 'Iberia & Portugal' || countryName == 'Naturagri'){
                if(SPNPBWise=='Common Pricebook' || NaturagriPBWise=='Common Pricebook'){
                    
                    for (Integer i = 1; i < csvData.size(); i++){
                        String row = '';
                        try{
                            List<String> csvLineItem = new List<String>();
                            PriceBookMaster__c sObj = new PriceBookMaster__c();
                            SpecialInvoiceDiscount__c sidObj= new SpecialInvoiceDiscount__c();
                            ZSP1_Discount__c zdObj=new ZSP1_Discount__c();
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
                                        sidObj.Sales_Org__r = new Sales_Org__c(Sales_Org_Code__c = csvLineItem[j].trim());
                                        zdObj.Sales_Org__r = new Sales_Org__c(Sales_Org_Code__c = csvLineItem[j].trim());
                                        combinationKey += csvLineItem[j];
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                    }
                                }
                                else if(j==1){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        sObj.DistributionChannel__r = new Distribution_Channel__c(Distribution_Channel_Code__c = csvLineItem[j].trim());
                                        sidObj.DistributionChannel__r = new Distribution_Channel__c(Distribution_Channel_Code__c = csvLineItem[j].trim());
                                        zdObj.DistributionChannel__r = new Distribution_Channel__c(Distribution_Channel_Code__c = csvLineItem[j].trim());
                                        combinationKey += csvLineItem[j];
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                    }
                                }
                                else if(j==2){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                        sObj.Division__r = new Division__c(Division_Code__c = csvLineItem[j].trim());
                                        sidObj.Division__r = new Division__c(Division_Code__c = csvLineItem[j].trim());
                                        zdObj.Division__r = new Division__c(Division_Code__c = csvLineItem[j].trim());
                                        combinationKey += csvLineItem[j];
                                    }
                                }else if(j==3){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        sObj.DepotCode__r = new Depot__c(Depot_Code__c = csvLineItem[j].trim());
                                        sidObj.DepotCode__r = new Depot__c(Depot_Code__c = csvLineItem[j].trim());
                                        zdObj.DepotCode__r = new Depot__c(Depot_Code__c = csvLineItem[j].trim());
                                        depotCode = csvLineItem[j].trim();
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);                      
                                    }else {
                                        errorCSVList.add(row+', Depot code is blank');
                                    }
                                }else if(j==4){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        sObj.CurrencyIsoCode  = csvLineItem[j].trim();
                                        sidObj.CurrencyIsoCode  = csvLineItem[j].trim();
                                        zdObj.CurrencyIsoCode  = csvLineItem[j].trim();
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                    }else {
                                        errorCSVList.add(row+', Currency code is blank');
                                    }
                                }else if(j==5){
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
                                        system.debug('**codeSKU Iberia & Portugal & Naturagri Common Pricebook -> ' +codeSKU);
                                        
                                        combinationKey += code;
                                        sObj.SKUCode__r = new SKU__c(Combination_Key__c = combinationKey);
                                        sidObj.SKUCode__r = new SKU__c(Combination_Key__c = combinationKey);
                                        zdObj.SKUCode__r = new SKU__c(Combination_Key__c = combinationKey);
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                    }else {
                                        errorCSVList.add(row+', Sku code is blank');
                                    }
                                }else if(j==6){
                                    if(String.isNotBlank(csvLineItem[j])){
                                    String skcode='';
                                    if(csvLineItem[5].length()==6){
                                        skcode = '000000000000'+csvLineItem[5];
                                    }
                                    else if(csvLineItem[5].length()==7){
                                        skcode = '00000000000'+csvLineItem[5];
                                    }
                                    System.debug('skcode :- '+skcode);
                                    System.debug('mapStrUom.containsKey(skcode) :- '+mapStrUom.containsKey(skcode));
                                    if(mapStrUom.containsKey(skcode)){
                                        if(mapStrUom.get(skcode)==csvLineItem[j].trim()){
                                            sObj.UOM__c =csvLineItem[j].trim();
                                            sidObj.UOM__c =csvLineItem[j].trim();
                                            zdObj.UOM__c =csvLineItem[j].trim();
                                            uomblank=csvLineItem[j].trim();
                                            isTrue=true;
                                            
                                        }else {
                                            isTrue=false;
                                            sObj.UOM__c =csvLineItem[j].trim();
                                            sidObj.UOM__c =csvLineItem[j].trim();
                                            zdObj.UOM__c =csvLineItem[j].trim();
                                            //errorCSVList.add(row+', Invalid UOM.');
                                        }
                                    }else{
                                        isTrue=false;
                                    }
                                    }else {
                                        errorCSVList.add(row+', UOM is blank');
                                    }
                                    
                                }else if(j==7){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        sObj.Price__c = Decimal.valueOf(csvLineItem[j].trim());
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                    }else {
                                        errorCSVList.add(row+', Base Price is blank');
                                    }
                                }else if(j==8){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        sidObj.Discount__c = Decimal.valueOf(csvLineItem[j].trim());
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                    }else {
                                        errorCSVList.add(row+', Line Discount is blank');
                                    }
                                }else if(j==9){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        zdObj.Discount__c = Decimal.valueOf(csvLineItem[j].trim());
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                    }else {
                                        errorCSVList.add(row+', Volume Discount is blank');
                                    }
                                }
                                else if(j==10){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        startDate = csvLineItem[j].trim();
                                        Date d = Date.valueOf(csvLineItem[j]) ;     
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                        sObj.StartDate__c = d;
                                        sidObj.StartDate__c = d;
                                        zdObj.StartDate__c = d;
                                    }else {
                                        errorCSVList.add(row+', Start date is blank');
                                    }
                                }
                                else if(j==11){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        if(Date.valueOf(csvLineItem[11])>Date.valueOf(csvLineItem[10])){
                                            system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                            sObj.EndDate__c = Date.valueOf(csvLineItem[j]);
                                            sidObj.EndDate__c = Date.valueOf(csvLineItem[j]);
                                            zdObj.EndDate__c = Date.valueOf(csvLineItem[j]);
                                        }else {
                                            errorCSVList.add(row+', End date should be greater than start date');
                                        }
                                    }else {
                                        errorCSVList.add(row+', End date is blank');
                                    }
                                }
                                
                                else if(j==12){
                                    if(String.isNotBlank(csvLineItem[j])){
                                            system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                            sObj.Country_Tax__c = Decimal.valueOf(csvLineItem[j]);
                                        }
                                    else {
                                        errorCSVList.add(row+', Tax is blank');
                                    }
                                }
                                
                            }
                            
                            //compositeKey = batchKey+startDate+depotCode+distributorKey+combinationKey;//depotCode+combinationKey+distributorKey;
                            compositeKey = depotCode+combinationKey;
                            sObj.CompositeKey__c = compositeKey;
                            system.debug('sObj >>--->'+sObj);
                            if(startDate!=''){
                                sidObj.CompositeKey__c = startDate+compositeKey;
                                system.debug('sidObj >>--->'+sidObj);
                                zdObj.CompositeKey__c = startDate+compositeKey;
                                system.debug('zdObj >>--->'+zdObj);
                            }
                            mapErrorStr.put(compositeKey,row);
                            upsertPricebookList.add(sObj);
                            upsertSpecInvDiscountList.add(sidObj);
                            upsertZSP1DiscountList.add(zdObj);
                            system.debug('upsertSpecInvDiscountList  :'+upsertSpecInvDiscountList);
                            system.debug('upsertZSP1DiscountList  :'+upsertZSP1DiscountList);
                        }
                        catch(Exception ex){
                            system.debug('Error : '+ row+','+ex.getMessage());
                            errorCSVList.add(row+','+ex.getMessage());
                        }
                    }
                } 
                else if(SPNPBWise=='Campaign Pricebook' || NaturagriPBWise=='Campaign Pricebook'){
                    Map<String,String> spCampaignMap=new Map<String,String>();
                    List<Spain_Portugal_Campaign__c> spCampaignList=[Select id, Start_Date__c, End_Date__c, Campaign_Id__c from Spain_Portugal_Campaign__c];
                    for(Spain_Portugal_Campaign__c spCampaignObj:spCampaignList){
                        String startDate=String.valueOf(spCampaignObj.Start_Date__c);
                        spCampaignMap.put(spCampaignObj.Campaign_Id__c,startDate);
                    }
                    
                    for (Integer i = 1; i < csvData.size(); i++){
                        String row = '';
                        try{
                            List<String> csvLineItem = new List<String>();
                            PricebookDiscount__c pdObj= new PricebookDiscount__c();
                            row = csvData[i];
                            
                            csvLineItem = csvData[i].split(',');
                            
                            String startDate = '';
                            String campaignIdCode = '';
                            String combinationKey = '';
                            String compositeKey = '';
                            string distributorKey = '';
                            
                            system.debug('File Size >>--->'+csvLineItem.size());
                            system.debug('File  >>--->'+csvLineItem);
                            
                            for(Integer j=0; j<csvLineItem.size(); j++){
                                
                                if(j==0){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        pdObj.Sales_Org__r = new Sales_Org__c(Sales_Org_Code__c = csvLineItem[j].trim());
                                        combinationKey += csvLineItem[j];
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                    }
                                }
                                else if(j==1){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        pdObj.DistributionChannel__r = new Distribution_Channel__c(Distribution_Channel_Code__c = csvLineItem[j].trim());
                                        combinationKey += csvLineItem[j];
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                    }
                                }
                                else if(j==2){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                        pdObj.Division__r = new Division__c(Division_Code__c = csvLineItem[j].trim());
                                        combinationKey += csvLineItem[j];
                                    }
                                }else if(j==3){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        pdObj.DepotCode__r = new Depot__c(Depot_Code__c = csvLineItem[j].trim());
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);                      
                                    }else {
                                        errorCSVList.add(row+', Depot code is blank');
                                    }
                                }else if(j==4){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        campaignIdCode = csvLineItem[j].trim();
                                        //pdObj.Spain_Portugal_Campaign__c  = csvLineItem[j].trim();
                                        pdObj.Spain_Portugal_Campaign__r  = new Spain_Portugal_Campaign__c(CompositeKey__c = csvLineItem[j].trim());
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                        if(!spCampaignMap.containsKey(campaignIdCode)){
                                            errorCSVList.add(row+', Campaign Id not found');
                                        }
                                    }else {
                                        errorCSVList.add(row+', Campaign Id is blank');
                                    }
                                }else if(j==5){
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
                                        system.debug('**codeSKU Iberia & Portugal & Naturagri Campaign Pricebook -> ' +codeSKU);
                                        combinationKey += code;
                                        pdObj.SKUCode__r = new SKU__c(Combination_Key__c = combinationKey);
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                    }else {
                                        errorCSVList.add(row+', Sku code is blank');
                                    }
                                }else if(j==6){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        pdObj.Distributor_Discount__c = Decimal.valueOf(csvLineItem[j].trim());
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                    }else {
                                        errorCSVList.add(row+', Discount Price is blank');
                                    }
                                }/*else if(j==6){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        startDate = csvLineItem[j].trim();
                                        Date d = Date.valueOf(csvLineItem[j]) ;     
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                        pdObj.StartDate__c = d;
                                    }else {
                                        errorCSVList.add(row+', Start date is blank');
                                    }
                                }
                                else if(j==7){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        if(Date.valueOf(csvLineItem[7])>Date.valueOf(csvLineItem[6])){
                                            system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                            pdObj.EndDate__c = Date.valueOf(csvLineItem[j]);
                                        }else {
                                            errorCSVList.add(row+', End date should be greater than start date');
                                        }
                                    }else {
                                        errorCSVList.add(row+', End date is blank');
                                    }
                                }*/
                                
                            }
                            
                            //compositeKey = batchKey+startDate+depotCode+distributorKey+combinationKey;//depotCode+combinationKey+distributorKey;
                            compositeKey = combinationKey;
                            if(spCampaignMap.containsKey(campaignIdCode)){
                                pdObj.CompositeKey__c = spCampaignMap.get(campaignIdCode)+campaignIdCode+compositeKey;
                            }
                            system.debug('pdObj >>--->'+pdObj);
                            mapErrorStr.put(compositeKey,row);
                            upsertPricebookDiscountList.add(pdObj);
                        }
                        catch(Exception ex){
                            system.debug('Error : '+ row+','+ex.getMessage());
                            errorCSVList.add(row+','+ex.getMessage());
                        }
                    }
                } 
            }
            if(countryName == 'Poland'){
                if(SPNPBWise=='Common Pricebook'){
                    for (Integer i = 1; i < csvData.size(); i++){
                        String row = '';
                        try{
                            List<String> csvLineItem = new List<String>();
                            PriceBookMaster__c sObj = new PriceBookMaster__c();
                            SpecialInvoiceDiscount__c sIDObj=new SpecialInvoiceDiscount__c();
                            ZSP1_Discount__c zSPObj=new ZSP1_Discount__c();
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
                                        sIDObj.Sales_Org__r = new Sales_Org__c(Sales_Org_Code__c = csvLineItem[j].trim());
                                        zSPObj.Sales_Org__r = new Sales_Org__c(Sales_Org_Code__c = csvLineItem[j].trim());
                                        combinationKey += csvLineItem[j];
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                    }
                                }
                                else if(j==1){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        sObj.DistributionChannel__r = new Distribution_Channel__c(Distribution_Channel_Code__c = csvLineItem[j].trim());
                                        sIDObj.DistributionChannel__r = new Distribution_Channel__c(Distribution_Channel_Code__c = csvLineItem[j].trim());
                                        zSPObj.DistributionChannel__r = new Distribution_Channel__c(Distribution_Channel_Code__c = csvLineItem[j].trim());
                                        combinationKey += csvLineItem[j];
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                    }
                                }
                                else if(j==2){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                        sObj.Division__r = new Division__c(Division_Code__c = csvLineItem[j].trim());
                                        sIDObj.Division__r = new Division__c(Division_Code__c = csvLineItem[j].trim());
                                        zSPObj.Division__r = new Division__c(Division_Code__c = csvLineItem[j].trim());
                                        combinationKey += csvLineItem[j];
                                    }
                                }else if(j==3){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        sObj.DepotCode__r = new Depot__c(Depot_Code__c = csvLineItem[j].trim());
                                        sIDObj.DepotCode__r = new Depot__c(Depot_Code__c = csvLineItem[j].trim());
                                        zSPObj.DepotCode__r = new Depot__c(Depot_Code__c = csvLineItem[j].trim());
                                        depotCode = csvLineItem[j].trim();
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);                      
                                    }else {
                                        errorCSVList.add(row+', Depot code is blank');
                                    }
                                }else if(j==4){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        sObj.CurrencyIsoCode  = csvLineItem[j].trim();
                                        sIDObj.CurrencyIsoCode  = csvLineItem[j].trim();
                                        zSPObj.CurrencyIsoCode  = csvLineItem[j].trim();
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                    }else {
                                        errorCSVList.add(row+', Currency code is blank');
                                    }
                                }else if(j==5){
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
                                        system.debug('**codeSKU Poland Common Pricebook -> ' +codeSKU);
                                        combinationKey += code;
                                        sObj.SKUCode__r = new SKU__c(Combination_Key__c = combinationKey);
                                        sIDObj.SKUCode__r = new SKU__c(Combination_Key__c = combinationKey);
                                        zSPObj.SKUCode__r = new SKU__c(Combination_Key__c = combinationKey);
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                    }else {
                                        errorCSVList.add(row+', Sku code is blank');
                                    }
                                }else if(j==6){
                                    if(String.isNotBlank(csvLineItem[j])){
                                    String skcode='';
                                    if(csvLineItem[5].length()==6){
                                        skcode = '000000000000'+csvLineItem[5];
                                    }
                                    else if(csvLineItem[5].length()==7){
                                        skcode = '00000000000'+csvLineItem[5];
                                    }
                                    System.debug('skcode :- '+skcode);
                                    System.debug('mapStrUom.containsKey(skcode) :- '+mapStrUom.containsKey(skcode));
                                    if(mapStrUom.containsKey(skcode)){
                                        if(mapStrUom.get(skcode)==csvLineItem[j].trim()){
                                            sObj.UOM__c =csvLineItem[j].trim();
                                            sIDObj.UOM__c =csvLineItem[j].trim();
                                            zSPObj.UOM__c =csvLineItem[j].trim();
                                            uomblank=csvLineItem[j].trim();
                                            isTrue=true;
                                            
                                        }else {
                                            isTrue=false;
                                            sObj.UOM__c =csvLineItem[j].trim();
                                            sIDObj.UOM__c =csvLineItem[j].trim();
                                            zSPObj.UOM__c =csvLineItem[j].trim();
                                            errorCSVList.add(row+', Invalid UOM.');
                                        }
                                    }else{
                                        isTrue=false;
                                    }
                                    }else {
                                        errorCSVList.add(row+', UOM is blank');
                                    }
                                    
                                }else if(j==7){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        sObj.Price__c = Decimal.valueOf(csvLineItem[j].trim());
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                    }else {
                                        errorCSVList.add(row+', Base Price is blank');
                                    }
                                }else if(j==8){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        zSPObj.Active__c=true;
                                        zSPObj.Discount__c = Decimal.valueOf(csvLineItem[j].trim());
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                    }
                                }else if(j==9){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        zSPObj.Second_Discount__c = Decimal.valueOf(csvLineItem[j].trim());
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                    }
                                }else if(j==10){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        sIDObj.Active__c=true;
                                        sIDObj.Discount__c = Decimal.valueOf(csvLineItem[j].trim());
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                    }
                                }else if(j==10){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        sIDObj.Active__c=true;
                                        sIDObj.Discount__c = Decimal.valueOf(csvLineItem[j].trim());
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                    }
                                }else if(j==11){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        startDate = csvLineItem[j].trim();
                                        Date d = Date.valueOf(csvLineItem[j]) ;     
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                        if(String.isNotBlank(csvLineItem[10])){
                                            sIDObj.StartDate__c = d;
                                        }
                                        
                                    }else {
                                        errorCSVList.add(row+', Start date (Earlier Order Discount) is blank');
                                    }
                                }
                                else if(j==12){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        if(Date.valueOf(csvLineItem[12])>Date.valueOf(csvLineItem[11])){
                                            system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                            if(String.isNotBlank(csvLineItem[10])){
                                                sIDObj.EndDate__c = Date.valueOf(csvLineItem[j]);
                                            }
                                            
                                        }else {
                                            errorCSVList.add(row+', End date (Earlier Order Discount) should be greater than start date');
                                        }
                                    }else {
                                        errorCSVList.add(row+', End date (Earlier Order Discount) is blank');
                                    }
                                }else if(j==13){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        startDate = csvLineItem[j].trim();
                                        Date d = Date.valueOf(csvLineItem[j]) ;     
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                        sObj.StartDate__c = d;
                                        if(String.isNotBlank(csvLineItem[8]) && String.isNotBlank(csvLineItem[9])){
                                            zSPObj.StartDate__c = d; 
                                        }
                                    }else {
                                        errorCSVList.add(row+', Start date is blank');
                                    }
                                }
                                else if(j==14){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        if(Date.valueOf(csvLineItem[14])>Date.valueOf(csvLineItem[13])){
                                            system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                            sObj.EndDate__c = Date.valueOf(csvLineItem[j]);
                                            if(String.isNotBlank(csvLineItem[8]) && String.isNotBlank(csvLineItem[9])){
                                                zSPObj.EndDate__c = Date.valueOf(csvLineItem[j]);
                                            }
                                        }else {
                                            errorCSVList.add(row+', End date should be greater than start date');
                                        }
                                    }else {
                                        errorCSVList.add(row+', End date is blank');
                                    }
                                }//below changes added by Nandhini w.r.t CR-2521
                                else if(j==15){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        sObj.PAK__c = Boolean.valueOf(csvLineItem[j]);
                                        PAK = String.ValueOf(sObj.PAK__c);
                                        mapStr.put('00000000000'+csvLineItem[5]+csvLineItem[j],row);
                                    }else{
                                        mapStr.put('00000000000'+csvLineItem[5]+'FALSE',row);
                                    }
                                }
                                
                            }
                            
                            //compositeKey = batchKey+startDate+depotCode+distributorKey+combinationKey;//depotCode+combinationKey+distributorKey;
                            //below changes added by nandhini w.r.t CR-2521
                            if(sObj.PAK__c){
                                compositeKey = 'PAK'+depotCode+combinationKey;
                            }else{
                                compositeKey = depotCode+combinationKey;
                            }
                            //compositeKey = depotCode+combinationKey;
                            sObj.CompositeKey__c = compositeKey;
                            sIDObj.CompositeKey__c = compositeKey;
                            zSPObj.CompositeKey__c = compositeKey;
                            system.debug('common Poland sObj >>--->'+sObj);
                            mapErrorStr.put(compositeKey,row);
                            upsertPricebookList.add(sObj);
                            if(!sObj.PAK__c){//Added by Nandhini
                                upsertSpecInvDiscountList.add(sIDObj);
                                upsertZSP1DiscountList.add(zSPObj);
                            }
                        }
                        catch(Exception ex){
                            system.debug('**Pollan Error : '+ row+','+ex.getMessage());
                            errorCSVList.add(row+','+ex.getMessage());
                            System.debug('** Polland errorCSVList :- '+errorCSVList);
                        }
                    }
                } 
                else if(SPNPBWise=='CustomerWise Pricebook'){
                    Map<String,String> paymentTermMap=new Map<String,String>();
                    List<Payment_Term__c> pTList=[Select id, Payment_Term_Code__c from Payment_Term__c where SalesOrgCode__c='2941'];
                    for(Payment_Term__c pTerm:pTList){
                        paymentTermMap.put(pTerm.Payment_Term_Code__c,pTerm.Payment_Term_Code__c);
                    }
                    for (Integer i = 1; i < csvData.size(); i++){
                        String row = '';
                        try{
                            List<String> csvLineItem = new List<String>();
                            PriceBookMaster__c sObj = new PriceBookMaster__c();
                            PriceBook_Indonesia_Discount__c pIDObj = new PriceBook_Indonesia_Discount__c();
                            row = csvData[i];
                            
                            csvLineItem = csvData[i].split(',');
                            
                            String startDate = '';
                            String depotCode = '';
                            String combinationKey = '';
                            String compositeKey = '';
                            string distributorKey = '';
                            string batchKey='';
                            String uomblank='';
                            String paymentTermcombinationKey = '';
                            
                            system.debug('File Size >>--->'+csvLineItem.size());
                            system.debug('File  >>--->'+csvLineItem);
                            
                            for(Integer j=0; j<csvLineItem.size(); j++){
                                
                                if(j==0){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        sObj.Sales_Org__r = new Sales_Org__c(Sales_Org_Code__c = csvLineItem[j].trim());
                                        pIDObj.Sales_Org__r = new Sales_Org__c(Sales_Org_Code__c = csvLineItem[j].trim());
                                        combinationKey += csvLineItem[j];
                                        paymentTermcombinationKey +=csvLineItem[j].trim();
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                    }
                                }
                                else if(j==1){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        sObj.DistributionChannel__r = new Distribution_Channel__c(Distribution_Channel_Code__c = csvLineItem[j].trim());
                                        pIDObj.DistributionChannel__r = new Distribution_Channel__c(Distribution_Channel_Code__c = csvLineItem[j].trim());
                                        combinationKey += csvLineItem[j];
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                    }
                                }
                                else if(j==2){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                        sObj.Division__r = new Division__c(Division_Code__c = csvLineItem[j].trim());
                                        pIDObj.Division__r = new Division__c(Division_Code__c = csvLineItem[j].trim());
                                        combinationKey += csvLineItem[j];
                                    }
                                }else if(j==3){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        sObj.DepotCode__r = new Depot__c(Depot_Code__c = csvLineItem[j].trim());
                                        pIDObj.DepotCode__r = new Depot__c(Depot_Code__c = csvLineItem[j].trim());
                                        depotCode = csvLineItem[j].trim();
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);                      
                                    }else {
                                        errorCSVList.add(row+', Depot code is blank');
                                    }
                                }else if(j==4){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        sObj.CurrencyIsoCode  = csvLineItem[j].trim();
                                        pIDObj.CurrencyIsoCode  = csvLineItem[j].trim();
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                    }else {
                                        errorCSVList.add(row+', Currency code is blank');
                                    }
                                }else if(j==5){
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
                                        system.debug('**codeSKU Poland Common Pricebook -> ' +codeSKU);
                                        combinationKey += code;
                                        sObj.SKUCode__r = new SKU__c(Combination_Key__c = combinationKey);
                                        pIDObj.SKUCode__r = new SKU__c(Combination_Key__c = combinationKey);
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                    }else {
                                        errorCSVList.add(row+', Sku code is blank');
                                    }
                                }else if(j==6){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        String customercode = csvLineItem[j].trim();
                                        if(csvLineItem[j].length()==7){
                                            customercode = '000'+ csvLineItem[j];
                                        }else if(csvLineItem[j].length()==6){
                                            customercode = '0000'+ csvLineItem[j];
                                        }
                                        distributorKey = customercode;
                                        sObj.DistributorCustomerCode__r =  new Account (SAP_Code__c = customercode);
                                        pIDObj.DistributorCustomerCode__r =  new Account (SAP_Code__c = customercode);
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                    }else {
                                        errorCSVList.add(row+', SAP Customer Code is blank');
                                    }
                                }else if(j==7){
                                    if(String.isNotBlank(csvLineItem[j])){
                                    String skcode='';
                                    if(csvLineItem[5].length()==6){
                                        skcode = '000000000000'+csvLineItem[5];
                                    }
                                    else if(csvLineItem[5].length()==7){
                                        skcode = '00000000000'+csvLineItem[5];
                                    }
                                    System.debug('skcode :- '+skcode);
                                    System.debug('mapStrUom.containsKey(skcode) :- '+mapStrUom.containsKey(skcode));
                                    if(mapStrUom.containsKey(skcode)){
                                        if(mapStrUom.get(skcode)==csvLineItem[j].trim()){
                                            sObj.UOM__c =csvLineItem[j].trim();
                                            pIDObj.UOM__c =csvLineItem[j].trim();
                                            uomblank=csvLineItem[j].trim();
                                            isTrue=true;
                                            
                                        }else {
                                            isTrue=false;
                                            sObj.UOM__c =csvLineItem[j].trim();
                                            pIDObj.UOM__c =csvLineItem[j].trim();
                                            errorCSVList.add(row+', Invalid UOM.');
                                        }
                                    }else{
                                        isTrue=false;
                                    }
                                    }else {
                                        errorCSVList.add(row+', UOM is blank');
                                    }
                                    
                                }else if(j==8){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        if(paymentTermMap.containsKey(csvLineItem[9].trim())){
                                            sObj.Price__c = Decimal.valueOf(csvLineItem[j].trim());
                                            system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                        }
                                    }else {
                                        errorCSVList.add(row+', Base Price is blank');
                                    }
                                }else if(j==9){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        if(paymentTermMap.containsKey(csvLineItem[j].trim())){
											paymentTermcombinationKey+=csvLineItem[j];
                                            pIDObj.Payment_Term__r =new Payment_Term__c(CombinationKey__c = paymentTermcombinationKey);
                                            system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);   
                                        }else{
                                            errorCSVList.add(row+', Payment Term is incorrect');
                                        }
                                        
                                    }else{
                                        errorCSVList.add(row+', Payment Term is blank');
                                    }
                                }else if(j==10){
                                    if(String.isNotBlank(csvLineItem[9])){
                                        if(String.isNotBlank(csvLineItem[j])){
                                            pIDObj.Manual_Discount__c = Decimal.valueOf(csvLineItem[j].trim());
                                        }else{
                                            pIDObj.Manual_Discount__c = 0; 
                                        }
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                    }
                                }else if(j==11){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        Date d = Date.valueOf(csvLineItem[j]) ;     
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                        sObj.StartDate__c = d;
                                        pIDObj.StartDate__c = d;
                                    }else {
                                        errorCSVList.add(row+', Start date is blank');
                                    }
                                }else if(j==12){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        if(Date.valueOf(csvLineItem[12])>Date.valueOf(csvLineItem[11])){
                                            system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                            sObj.EndDate__c = Date.valueOf(csvLineItem[j]);
                                            pIDObj.EndDate__c = Date.valueOf(csvLineItem[j]);
                                        }else {
                                            errorCSVList.add(row+', End date should be greater than start date');
                                        }
                                    }else {
                                        errorCSVList.add(row+', End date is blank');
                                    }
                                }//below changes added by nandhini w.r.t CR-2521
                                else if(j==13){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        sObj.PAK__c = Boolean.valueOf(csvLineItem[j]);
                                           
                                    }
                                }
                                
                            }
                            
                            //compositeKey = batchKey+startDate+depotCode+distributorKey+combinationKey;//depotCode+combinationKey+distributorKey;
                            compositeKey = depotCode+combinationKey+distributorKey;
                            sObj.CompositeKey__c = compositeKey;
                            pIDObj.CompositeKey__c = compositeKey+paymentTermcombinationKey;
                            system.debug('sObj >>--->'+sObj);
                            mapErrorStr.put(compositeKey,row);
                            upsertPricebookList.add(sObj);
                            upsertPricebookIndonesiaDiscountList.add(pIDObj);
                        }
                        catch(Exception ex){
                            system.debug('Error : '+ row+','+ex.getMessage());
                            errorCSVList.add(row+','+ex.getMessage());
                        }
                    }
                }
            }
            if(countryName == 'Bolivia & Paraguay'){
                if(SPNPBWise=='Common Pricebook'){
                    
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
                            string batchKey='';
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
                                }else if(j==3){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        sObj.DepotCode__r = new Depot__c(Depot_Code__c = csvLineItem[j].trim());
                                        depotCode = csvLineItem[j].trim();
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);                      
                                    }else {
                                        errorCSVList.add(row+', Depot code is blank');
                                    }
                                }else if(j==4){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        sObj.CurrencyIsoCode  = csvLineItem[j].trim();
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                    }else {
                                        errorCSVList.add(row+', Currency code is blank');
                                    }
                                }else if(j==5){
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
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                    }else {
                                        errorCSVList.add(row+', Sku code is blank');
                                    }
                                }else if(j==6){
                                    if(String.isNotBlank(csvLineItem[j])){
                                    String skcode='';
                                    if(csvLineItem[5].length()==6){
                                        skcode = '000000000000'+csvLineItem[5];
                                    }
                                    else if(csvLineItem[5].length()==7){
                                        skcode = '00000000000'+csvLineItem[5];
                                    }
                                    System.debug('skcode :- '+skcode);
                                    System.debug('mapStrUom.containsKey(skcode) :- '+mapStrUom.containsKey(skcode));
                                    if(mapStrUom.containsKey(skcode)){
                                        if(mapStrUom.get(skcode)==csvLineItem[j].trim()){
                                            sObj.UOM__c =csvLineItem[j].trim();
                                            uomblank=csvLineItem[j].trim();
                                            isTrue=true;
                                            
                                        }else {
                                            isTrue=false;
                                            sObj.UOM__c =csvLineItem[j].trim();
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
                                        sObj.MinPrice__c = Decimal.valueOf(csvLineItem[j].trim());
                                    }else {
                                        errorCSVList.add(row+', Minimum Price is blank');
                                    }
                                }
                                else if(j==8){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        sObj.Price__c = Decimal.valueOf(csvLineItem[j].trim());
                                    }else {
                                        errorCSVList.add(row+', Maximum Price is blank');
                                    }
                                }else if(j==9){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        startDate = csvLineItem[j].trim();
                                        Date d = Date.valueOf(csvLineItem[j]) ;     
                                        system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                        sObj.StartDate__c = d;
                                    }else {
                                        errorCSVList.add(row+', Start date is blank');
                                    }
                                }
                                else if(j==10){
                                    if(String.isNotBlank(csvLineItem[j])){
                                        if(Date.valueOf(csvLineItem[10])>Date.valueOf(csvLineItem[9])){
                                            system.debug('csvLineItem['+j+']>>--->'+csvLineItem[j]);
                                            sObj.EndDate__c = Date.valueOf(csvLineItem[j]);
                                        }else {
                                            errorCSVList.add(row+', End date should be greater than start date');
                                        }
                                    }else {
                                        errorCSVList.add(row+', End date is blank');
                                    }
                                }
                                
                            }
                            
                            //compositeKey = batchKey+startDate+depotCode+distributorKey+combinationKey;//depotCode+combinationKey+distributorKey;
                            compositeKey = depotCode+combinationKey;
                            sObj.CompositeKey__c = compositeKey;
                            system.debug('sObj >>--->'+sObj);
                            mapErrorStr.put(compositeKey,row);
                            upsertPricebookList.add(sObj);
                        }
                        catch(Exception ex){
                            system.debug('Error : '+ row+','+ex.getMessage());
                            errorCSVList.add(row+','+ex.getMessage());
                        }
                    }
                } 
                
            }
            Database.UpsertResult[] srList;
            Database.UpsertResult[] srList2;
            Database.UpsertResult[] srList3;
            Database.UpsertResult[] srList4;
            Schema.SObjectField f = PriceBookMaster__c.Fields.CompositeKey__c;
            Schema.SObjectField f2 = PricebookDiscount__c.Fields.CompositeKey__c;
            Schema.SObjectField f3 = SpecialInvoiceDiscount__c.Fields.CompositeKey__c;
            Schema.SObjectField f4 = ZSP1_Discount__c.Fields.CompositeKey__c;
            Schema.SObjectField f5 = PriceBook_Indonesia_Discount__c.Fields.CompositeKey__c;
            system.debug('test upsertPricebookList>>--->'+upsertPricebookList);
            
            if(countryName == 'Iberia & Portugal' || countryName == 'Naturagri'){
                if(SPNPBWise!='Campaign Pricebook'){   
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
                    if(upsertPricebookList2.size()>0 ){
                        System.debug('upsertPricebookList2 :-- '+upsertPricebookList2);
                        srList = Database.upsert(upsertPricebookList2, f, false);
                    }
                    
                    
                }
                if(upsertSpecInvDiscountList.size()>0){
                        boolean isBTrue=false;
                        boolean DivisionCode=false;
                        boolean CurrencyIsoCodeTrue=false;
                        boolean DiscountPrice=false;
                        boolean endDateTrue=false;
                    
                    for(SpecialInvoiceDiscount__c sidO:upsertSpecInvDiscountList){
                        
                        if(String.isNotBlank(sidO.CurrencyIsoCode)){
                            if(sidO.CurrencyIsoCode=='EUR'){
                                CurrencyIsoCodeTrue=true;
                            }else {
                                CurrencyIsoCodeTrue=false;
                            }
                        } 
                        
                        if(String.isNotBlank(String.valueOf(sidO.EndDate__c))){
                            
                            if(Date.valueOf(sidO.EndDate__c)>Date.valueOf(sidO.StartDate__c)){
                                endDateTrue = true;
                            }else {
                                endDateTrue = false;
                            }
                            System.debug('endDateTrue :- '+endDateTrue);
                        }else {
                            endDateTrue = false;
                        }
                        
                        if(String.isNotBlank(String.valueOf(sidO.Discount__c))){
                            Boolean isContains=String.valueOf(sidO.Discount__c).trim().contains('-');
                            if(isContains!=true){
                                DiscountPrice=true;
                            }else {
                                DiscountPrice=false;
                            }
                        } 
                        
                        if(CurrencyIsoCodeTrue && endDateTrue && DiscountPrice){
                            upsertSpecInvDiscountList2.add(sidO);
                        }else{
                            errorSpecInvDiscountList.add(sidO);
                        }
                        
                    }
                    System.debug('upsertSpecInvDiscountList2 size :-- '+upsertSpecInvDiscountList2.size());
                    if(upsertSpecInvDiscountList2.size()>0 ){
                        System.debug('upsertSpecInvDiscountList2 :-- '+upsertSpecInvDiscountList2);
                        srList2 = Database.upsert(upsertSpecInvDiscountList2, f3, false);
                    }
                    
                }
                if(upsertZSP1DiscountList.size()>0){
                        boolean isBTrue=false;
                        boolean DivisionCode=false;
                        boolean CurrencyIsoCodeTrue=false;
                        boolean DiscountPrice=false;
                        boolean endDateTrue=false;
                    
                    for(ZSP1_Discount__c zspO:upsertZSP1DiscountList){
                        
                        if(String.isNotBlank(zspO.CurrencyIsoCode)){
                            if(zspO.CurrencyIsoCode=='EUR'){
                                CurrencyIsoCodeTrue=true;
                            }else {
                                CurrencyIsoCodeTrue=false;
                            }
                        } 
                        
                        if(String.isNotBlank(String.valueOf(zspO.EndDate__c))){
                            
                            if(Date.valueOf(zspO.EndDate__c)>Date.valueOf(zspO.StartDate__c)){
                                endDateTrue = true;
                            }else {
                                endDateTrue = false;
                            }
                            System.debug('endDateTrue :- '+endDateTrue);
                        }else {
                            endDateTrue = false;
                        }
                        
                        if(String.isNotBlank(String.valueOf(zspO.Discount__c))){
                            Boolean isContains=String.valueOf(zspO.Discount__c).trim().contains('-');
                            if(isContains!=true){
                                DiscountPrice=true;
                            }else {
                                DiscountPrice=false;
                            }
                        } 
                        
                        if(CurrencyIsoCodeTrue && endDateTrue && DiscountPrice){
                            upsertZSP1DiscountList2.add(zspO);
                        }else{
                            errorZSP1DiscountList.add(zspO);
                        }
                        
                    }
                    System.debug('upsertZSP1DiscountList2 size :-- '+upsertZSP1DiscountList2.size());
                    if(upsertZSP1DiscountList2.size()>0 ){
                        System.debug('upsertZSP1DiscountList2 :-- '+upsertZSP1DiscountList2);
                        srList3 = Database.upsert(upsertZSP1DiscountList2, f4, false);
                    }
                    
                }
                Map<String, String> mapSTR2=new Map<String, String>();
                List<PriceBookMaster__c> pbmList = [SELECT Id, SKUCode__c ,SKUCode__r.Name, SKUCode__r.SKU_Code__c
                                                    FROM PriceBookMaster__c
                                                    WHERE (DistributionChannel__r.Distribution_Channel_Code__c ='67' OR  DistributionChannel__r.Distribution_Channel_Code__c ='70' OR  DistributionChannel__r.Distribution_Channel_Code__c ='20') 
                                                    AND (Sales_Org_Code__c ='2510' OR Sales_Org_Code__c ='2481' OR Sales_Org_Code__c ='2541')
                                                    AND SKUCode__r.SKU_Code__c IN :codeSKU];
                
                if(!pbmList.isEmpty()){
                    for(PriceBookMaster__c pbObj : pbmList){
                        mapSTR2.put(pbObj.ID, pbObj.SKUCode__r.SKU_Code__c);
                    }
                }
                
                Map<String, String> mapSTR3=new Map<String, String>();
                List<SpecialInvoiceDiscount__c> sidList = [SELECT Id, SKUCode__c ,SKUCode__r.Name, SKUCode__r.SKU_Code__c
                                                    FROM SpecialInvoiceDiscount__c
                                                    WHERE (DistributionChannel__r.Distribution_Channel_Code__c ='67' OR  DistributionChannel__r.Distribution_Channel_Code__c ='70' OR  DistributionChannel__r.Distribution_Channel_Code__c ='20') 
                                                    AND (Sales_Org_Code__c ='2510' OR Sales_Org_Code__c ='2481' OR Sales_Org_Code__c ='2541')
                                                          AND SKUCode__r.SKU_Code__c IN :codeSKU];
                
                if(!sidList.isEmpty()){
                    for(SpecialInvoiceDiscount__c sidObj : sidList){
                        mapSTR3.put(sidObj.ID, sidObj.SKUCode__r.SKU_Code__c);
                    }
                }
                
                Map<String, String> mapSTR4=new Map<String, String>();
                List<ZSP1_Discount__c> zspDList = [SELECT Id, SKUCode__c ,SKUCode__r.Name, SKUCode__r.SKU_Code__c
                                                    FROM ZSP1_Discount__c
                                                    WHERE (DistributionChannel__r.Distribution_Channel_Code__c ='67' OR  DistributionChannel__r.Distribution_Channel_Code__c ='70' OR  DistributionChannel__r.Distribution_Channel_Code__c ='20') 
                                                    AND (Sales_Org__r.Sales_Org_Code__c ='2510' OR Sales_Org__r.Sales_Org_Code__c ='2481' OR Sales_Org__r.Sales_Org_Code__c ='2541')
                                                    AND SKUCode__r.SKU_Code__c IN :codeSKU];
                
                if(!zspDList.isEmpty()){
                    for(ZSP1_Discount__c zspObj : zspDList){
                        mapSTR4.put(zspObj.ID, zspObj.SKUCode__r.SKU_Code__c);
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
                                successCSVList.add(upsertSpecInvDiscountList2[i].get('Id')+','+mapStr.get(skucodeId));
                                System.debug('successCSVList :--'+successCSVList);
                            }
                            
                        }
                    }
                }
                if(srList3!=null){
                    for(Integer i=0;i<srList3.size();i++){
                        if (!srList3[i].isSuccess()){
                            System.debug('srList3 error :--'+srList3);
                            Database.Error[] errs = srList3[i].getErrors();
                            System.debug('errs[0].getMessage() :-'+errs[0].getMessage());
                            System.debug('csvData[i] :-'+csvData[i]);
                            System.debug('csvData[i+1] :-'+csvData[i+1]);
                            //System.debug('csvData[i+2] :-'+csvData[i+2]);
                            errorCSVList.add(csvData[i+1]+','+errs[0].getMessage());
                            //System.debug('errorCSVList :--'+errorCSVList);
                        }
                        else{
                            String skucodeId='';
                            if(mapSTR4.containsKey(srList3[i].getId())){
                                skucodeId=mapSTR4.get(srList3[i].getId());
                                System.debug('skucodeId :--'+skucodeId);
                                
                            }
                            if(mapStr.containsKey(skucodeId)){
                                successCSVList.add(upsertZSP1DiscountList2[i].get('Id')+','+mapStr.get(skucodeId));
                                System.debug('successCSVList :--'+successCSVList);
                            }
                            
                        }
                    }
                }
                }else{
                    if(upsertPricebookDiscountList.size()>0){
                        boolean DiscountPrice=false;
                        boolean endDateTrue=false;
                        boolean campaignIdTrue=false;
                    
                    for(PricebookDiscount__c pdO:upsertPricebookDiscountList){
                        
                        if(String.isNotBlank(String.valueOf(pdO.CompositeKey__c))){
                            if(String.valueOf(pdO.CompositeKey__c).length()>30){
                                campaignIdTrue =true;
                            }else{
                                campaignIdTrue =false;
                            }
                            
                        }else {
                            campaignIdTrue = false;
                        }
                        
                        /*if(String.isNotBlank(String.valueOf(pdO.EndDate__c))){
                            
                            if(Date.valueOf(pdO.EndDate__c)>Date.valueOf(pdO.StartDate__c)){
                                endDateTrue = true;
                            }else {
                                endDateTrue = false;
                            }
                            System.debug('endDateTrue :- '+endDateTrue);
                        }else {
                            endDateTrue = false;
                        }*/
                        
                        if(String.isNotBlank(String.valueOf(pdO.Distributor_Discount__c))){
                            Boolean isContains=String.valueOf(pdO.Distributor_Discount__c).trim().contains('-');
                            if(isContains!=true){
                                DiscountPrice=true;
                            }else {
                                DiscountPrice=false;
                            }
                        } 
                        System.debug('pdO : '+pdO);
                        System.debug('campaignIdTrue : '+campaignIdTrue);
                        //System.debug('endDateTrue : '+endDateTrue);
                        System.debug('DiscountPrice : '+DiscountPrice);
                        if(campaignIdTrue && DiscountPrice){
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
                    
                }
                    Map<String, String> mapSTR3=new Map<String, String>();
                List<PricebookDiscount__c> pdList = [SELECT Id, SKUCode__c ,SKUCode__r.Name, SKUCode__r.SKU_Code__c
                                                    FROM PricebookDiscount__c
                                                    WHERE (DistributionChannel__r.Distribution_Channel_Code__c ='67' OR  DistributionChannel__r.Distribution_Channel_Code__c ='70' OR  DistributionChannel__r.Distribution_Channel_Code__c ='20') 
                                                    AND (Sales_Org__r.Sales_Org_Code__c ='2510' OR Sales_Org__r.Sales_Org_Code__c ='2481' OR Sales_Org__r.Sales_Org_Code__c ='2541')
                                                    AND SKUCode__r.SKU_Code__c IN :codeSKU];
                
                if(!pdList.isEmpty()){
                    for(PricebookDiscount__c pdObj : pdList){
                        mapSTR3.put(pdObj.ID, pdObj.SKUCode__r.SKU_Code__c);
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
            }
            if(countryName == 'Poland'){
                if(upsertPricebookList.size()>0){
                    boolean isBTrue=false;
                    boolean DivisionCode=false;
                    boolean CurrencyIsoCodeTrue=false;
                    boolean materialPrice=false;
                    boolean endDateTrue=false;
                    
                    for(PriceBookMaster__c sobj1:upsertPricebookList){
                        System.debug('sobj1 : '+sobj1);
                        if(String.isNotBlank(sobj1.CurrencyIsoCode)){
                            if(sobj1.CurrencyIsoCode=='PLN'){
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
                        }else{
                            materialPrice=false;
                        } 
                        System.debug('CurrencyIsoCodeTrue :- '+CurrencyIsoCodeTrue);
                        System.debug('endDateTrue :- '+endDateTrue);
                        System.debug('materialPrice :- '+materialPrice);
                        
                        if(CurrencyIsoCodeTrue && materialPrice && endDateTrue){
                            upsertPricebookList2.add(sobj1);
                        }else{
                            errorPricebookList.add(sobj1);
                        }
                        
                    }
                    System.debug('upsertPricebookList2.size() :-- '+upsertPricebookList2.size());
                    if(upsertPricebookList2.size()>0 ){
                        System.debug('upsertPricebookList2 :-- '+upsertPricebookList2);
                        srList = Database.upsert(upsertPricebookList2, f, false);
                    }
                    
                    
                }
                
                if(upsertPricebookIndonesiaDiscountList.size()>0){
                        
                        boolean isPaymentTermCode=false;  
                        
                        for(PriceBook_Indonesia_Discount__c sobj1:upsertPricebookIndonesiaDiscountList){
                            System.debug('sobj1 : '+sobj1);
                            if(String.isNotBlank(sobj1.CompositeKey__c)){
                               System.debug('paymentTermCodeStr :'+sobj1.CompositeKey__c);
                                if(sobj1.CompositeKey__c.contains('UK')){
                                    isPaymentTermCode=true;
                                }else {
                                    isPaymentTermCode=false;
                                }
                            } 
                            
                            System.debug('isPaymentTermCode :- '+isPaymentTermCode);
                            
                            if(isPaymentTermCode){
                                upsertPricebookIndonesiaDiscountList2.add(sobj1);
                            }else{
                                errorPricebookIndonesiaDiscountList.add(sobj1);
                            }
                            
                        }
                        System.debug('upsertPricebookIndonesiaDiscountList2.size() :-- '+upsertPricebookIndonesiaDiscountList2.size());
                        if(upsertPricebookIndonesiaDiscountList2.size()>0 ){
                            System.debug('upsertPricebookIndonesiaDiscountList2 :-- '+upsertPricebookIndonesiaDiscountList2);
                            srList2 = Database.upsert(upsertPricebookIndonesiaDiscountList2, f5, false);
                        }
                        
                        
                    }
                if(upsertSpecInvDiscountList.size()>0){
                    
                    boolean discountTrue=false;
                    boolean endDateTrue=false;
                    
                    for(SpecialInvoiceDiscount__c sobj1:upsertSpecInvDiscountList){
                        System.debug('sobj1 : '+sobj1);
                        
                        if(sobj1.Discount__c>=0){
                            discountTrue=true;
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
                        
                        if(discountTrue && endDateTrue){
                            upsertSpecInvDiscountList2.add(sobj1);
                        }else{
                            errorSpecInvDiscountList.add(sobj1);
                        }
                        
                    }
                    System.debug('upsertSpecInvDiscountList2.size() :-- '+upsertSpecInvDiscountList2.size());
                    if(upsertSpecInvDiscountList2.size()>0 ){
                        System.debug('upsertSpecInvDiscountList2 :-- '+upsertSpecInvDiscountList2);
                        srList3 = Database.upsert(upsertSpecInvDiscountList2, f3, false);
                    }
                }
                
                if(upsertZSP1DiscountList.size()>0){
                    
                    System.debug('upsertZSP1DiscountList.size() :-- '+upsertZSP1DiscountList.size());
                    if(upsertZSP1DiscountList.size()>0 ){
                        System.debug('upsertZSP1DiscountList :-- '+upsertZSP1DiscountList);
                        boolean discountTrue=false;
                        boolean secDiscountTrue=false;
                        boolean endDateTrue=false;
                        for(ZSP1_Discount__c zsp1Obj:upsertZSP1DiscountList){
                            if(zsp1Obj.Discount__c>=0){
                                discountTrue=true;
                            }
                            if(zsp1Obj.Second_Discount__c>=0){
                                secDiscountTrue=true;
                            }
                            if(String.isNotBlank(String.valueOf(zsp1Obj.EndDate__c))){
                                
                                if(Date.valueOf(zsp1Obj.EndDate__c)>Date.valueOf(zsp1Obj.StartDate__c)){
                                    endDateTrue = true;
                                }else {
                                    endDateTrue = false;
                                }
                            }else {
                                endDateTrue = false;
                            }
                            
                            if(discountTrue && endDateTrue){
                                upsertZSP1DiscountList2.add(zsp1Obj);
                            }else{
                                errorZSP1DiscountList.add(zsp1Obj);
                            }
                        }
                        srList4 = Database.upsert(upsertZSP1DiscountList2, f4, false);
                    }
                    
                    
                }
                
                Map<String, String> mapSTR2=new Map<String, String>();
                Map<String,List<string>> pbVsPAKVal = new Map<String,List<string>>(); //added by nandhini
                List<PriceBookMaster__c> pbmList = [SELECT Id, SKUCode__c ,SKUCode__r.Name,PAK__c, SKUCode__r.SKU_Code__c
                                                    FROM PriceBookMaster__c
                                                    WHERE DistributionChannel__r.Distribution_Channel_Code__c ='20' 
                                                    AND Sales_Org_Code__c ='2941'
                                                    AND SKUCode__r.SKU_Code__c IN :codeSKU];
                
                System.debug('Inside poland PriceBookMaster__c :-- '+pbmList);
                
                if(!pbmList.isEmpty()){
                    for(PriceBookMaster__c pbObj : pbmList){
                        mapSTR2.put(pbObj.ID, pbObj.SKUCode__r.SKU_Code__c);
                        //nandhini
                        if(pbVsPAKVal.containsKey(pbObj.SKUCode__r.SKU_Code__c)){
                            pbVsPAKVal.get(pbObj.SKUCode__r.SKU_Code__c).add(String.valueOf(pbObj.PAK__c).toUpperCase());
                        }else{
                            pbVsPAKVal.put(pbObj.SKUCode__r.SKU_Code__c,new List<String>{String.valueOf(pbObj.PAK__c).toUpperCase()});
                        }
                    }
                }
                //Iterate through each returned result
                if(srList!=null){
                    for(Integer i=0;i<srList.size();i++){
                        if (srList[i].isSuccess()){
                            System.debug('**Inside isSuccess poland');
                            String skucodeId='';
                            if(mapSTR2.containsKey(srList[i].getId())){
                                skucodeId=mapSTR2.get(srList[i].getId());
                                System.debug('skucodeId :--'+skucodeId);
                                
                            }
                            /*if(mapStr.containsKey(skucodeId)){
                                successCSVList.add(upsertPricebookList2[i].get('Id')+','+mapStr.get(skucodeId));
                                System.debug('successCSVList :--'+successCSVList);
                            } */ 
                            //nandhini
                            map<String,boolean> csvAdded = new map<string,boolean>();
                            for(String s: pbVsPAKVal.get(skucodeId)){
                                String mapkey = skucodeId+s;
                                if(mapStr.containsKey(mapkey) && !csvAdded.containsKey(mapKey)){
                                    csvAdded.put(mapkey,true);
                                    successCSVList.add(upsertPricebookList2[i].get('Id')+','+mapStr.get(mapkey));
                                    System.debug('successCSVList PAK:--'+successCSVList);
                                }
                            }  
                        }else{
                            System.debug('**Inside isError poland');
                            Database.Error[] errs = srList[i].getErrors();
                            errorCSVList.add(csvData[i+1]+','+errs[0].getMessage());
                        }
                    }
                }
                //Pricebook Indonesia Discount success and error file logic starts here
                Map<String, String> mapSTR3=new Map<String, String>();
                List<PriceBook_Indonesia_Discount__c> pIDList = [SELECT Id, SKUCode__c ,SKUCode__r.Name, SKUCode__r.SKU_Code__c
                                                                 FROM PriceBook_Indonesia_Discount__c
                                                                 WHERE DistributionChannel__r.Distribution_Channel_Code__c ='20' 
                                                                 AND Sales_Org_Code__c ='2941'];
                
                if(!pIDList.isEmpty()){
                    for(PriceBook_Indonesia_Discount__c pbObj : pIDList){
                        mapSTR3.put(pbObj.ID, pbObj.SKUCode__r.SKU_Code__c);
                    }
                }
                if(srList2!=null){
                    for(Integer i=0;i<srList2.size();i++){
                        if (srList2[i].isSuccess()){
                            String skucodeId='';
                            if(mapSTR3.containsKey(srList2[i].getId())){
                                skucodeId=mapSTR3.get(srList2[i].getId());
                                System.debug('skucodeId :--'+skucodeId);
                                
                            }
                            System.debug('mapStr :--'+mapStr);
                            if(mapStr.containsKey(skucodeId)){
                                successCSVList.add(upsertPricebookIndonesiaDiscountList2[i].get('Id')+','+mapStr.get(skucodeId));
                                System.debug('successCSVList :--'+successCSVList);
                            }
                        }else{
                            Database.Error[] errs = srList[i].getErrors();
                            errorCSVList.add(csvData[i+1]+','+errs[0].getMessage());
                        }
                    }
                }
                //Special Invoice Discount success and error file logic starts here 
                Map<String, String> mapSTR4=new Map<String, String>();
                List<SpecialInvoiceDiscount__c> sIDList = [SELECT Id, SKUCode__c ,SKUCode__r.Name, SKUCode__r.SKU_Code__c
                                                                 FROM SpecialInvoiceDiscount__c
                                                                 WHERE DistributionChannel__r.Distribution_Channel_Code__c ='20' 
                                                                 AND Sales_Org_Code__c ='2941'];
                
                if(!sIDList.isEmpty()){
                    for(SpecialInvoiceDiscount__c sIDObj : sIDList){
                        mapSTR4.put(sIDObj.ID, sIDObj.SKUCode__r.SKU_Code__c);
                    }
                }
                if(srList3!=null){
                    for(Integer i=0;i<srList3.size();i++){
                        if (srList3[i].isSuccess()){
                            String skucodeId='';
                            if(mapSTR4.containsKey(srList3[i].getId())){
                                skucodeId=mapSTR4.get(srList3[i].getId());
                                System.debug('skucodeId :--'+skucodeId);
                                
                            }
                            System.debug('mapSTR4 :--'+mapSTR4);
                            if(mapStr.containsKey(skucodeId)){
                                successCSVList.add(upsertSpecInvDiscountList2[i].get('Id')+','+mapStr.get(skucodeId));
                                System.debug('successCSVList :--'+successCSVList);
                            }
                        }else{
                            Database.Error[] errs = srList[i].getErrors();
                            errorCSVList.add(csvData[i+1]+','+errs[0].getMessage());
                        }
                    }
                }
                //ZSP1Discount success and error file logic starts here 
                Map<String, String> mapSTR5=new Map<String, String>();
                List<ZSP1_Discount__c> zSPList = [SELECT Id, SKUCode__c ,SKUCode__r.Name, SKUCode__r.SKU_Code__c
                                                                 FROM ZSP1_Discount__c
                                                                 WHERE DistributionChannel__r.Distribution_Channel_Code__c ='20' 
                                                                 AND Sales_Org__r.Sales_Org_Code__c ='2941'];
                
                if(!zSPList.isEmpty()){
                    for(ZSP1_Discount__c zSpObj : zSPList){
                        mapSTR5.put(zSpObj.ID, zSpObj.SKUCode__r.SKU_Code__c);
                    }
                }    
                
                if(srList4!=null){
                    for(Integer i=0;i<srList4.size();i++){
                        if (srList4[i].isSuccess()){
                            String skucodeId='';
                            if(mapSTR5.containsKey(srList4[i].getId())){
                                skucodeId=mapSTR5.get(srList4[i].getId());
                                System.debug('skucodeId :--'+skucodeId);
                                
                            }
                            System.debug('mapStr :--'+mapStr);
                            if(mapStr.containsKey(skucodeId)){
                                successCSVList.add(upsertZSP1DiscountList[i].get('Id')+','+mapStr.get(skucodeId));
                                System.debug('successCSVList :--'+successCSVList);
                            }
                        }else{
                            Database.Error[] errs = srList[i].getErrors();
                            errorCSVList.add(csvData[i+1]+','+errs[0].getMessage());
                        }
                    }
                }
                //
            }
            if(countryName == 'Bolivia & Paraguay'){
                if(upsertPricebookList.size()>0){
                        boolean isBTrue=false;
                        boolean DivisionCode=false;
                        boolean CurrencyIsoCodeTrue=false;
                        boolean minPrice=false;
                    	boolean maxPrice=false;
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
                            
                            if(String.isNotBlank(String.valueOf(sobj1.EndDate__c))){
                                
                                if(Date.valueOf(sobj1.EndDate__c)>Date.valueOf(sobj1.StartDate__c)){
                                    endDateTrue = true;
                                }else {
                                    endDateTrue = false;
                                }
                            }else {
                                endDateTrue = false;
                            }
                            
                            if(String.isNotBlank(String.valueOf(sobj1.MinPrice__c))){
                                Boolean isContains=String.valueOf(sobj1.MinPrice__c).trim().contains('-');
                                if(isContains!=true){
                                    minPrice=true;
                                }else {
                                    minPrice=false;
                                }
                            } 
                            
                            if(String.isNotBlank(String.valueOf(sobj1.Price__c))){
                                Boolean isContains=String.valueOf(sobj1.Price__c).trim().contains('-');
                                if(isContains!=true){
                                    maxPrice=true;
                                }else {
                                    maxPrice=false;
                                }
                            } 
                            System.debug('CurrencyIsoCodeTrue :- '+CurrencyIsoCodeTrue);
                            System.debug('endDateTrue :- '+endDateTrue);
                            
                            if(CurrencyIsoCodeTrue && minPrice && maxPrice && endDateTrue){
                                upsertPricebookList2.add(sobj1);
                            }else{
                                errorPricebookList.add(sobj1);
                            }
                            
                        }
                        System.debug('upsertPricebookList2.size() :-- '+upsertPricebookList2.size());
                        if(upsertPricebookList2.size()>0 ){
                            System.debug('upsertPricebookList2 :-- '+upsertPricebookList2);
                            srList = Database.upsert(upsertPricebookList2, f, false);
                        }
                        
                        
                    }
                    Map<String, String> mapSTR2=new Map<String, String>();
                    List<PriceBookMaster__c> pbmList = [SELECT Id, SKUCode__c ,SKUCode__r.Name, SKUCode__r.SKU_Code__c
                                                        FROM PriceBookMaster__c
                                                        WHERE DistributionChannel__r.Distribution_Channel_Code__c ='20' 
                                                        AND (Sales_Org_Code__c ='5361' OR Sales_Org_Code__c ='5441')];
                    
                    if(!pbmList.isEmpty()){
                        for(PriceBookMaster__c pbObj : pbmList){
                            mapSTR2.put(pbObj.ID, pbObj.SKUCode__r.SKU_Code__c);
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
                            }else{
                                Database.Error[] errs = srList[i].getErrors();
                                errorCSVList.add(csvData[i+1]+','+errs[0].getMessage());
                            }
                    }
                }
            }
            //sendEmail(String.join(successCSVList, '\r\n'), String.join(errorCSVList, '\r\n'), successCSVList.size(), errorCSVList.size()-1);
        }
        catch(Exception ex){
            System.debug('Line No: '+ex.getLineNumber()+' Exception: '+ex.getMessage());
        }
    }
}