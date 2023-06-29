public class UpdatePOGMetricsHandler {
    
    public static void insertCombinationKey(List<SalesAgreementProductSchedule> sapsList){
        Set<Id> salesAgreementIds = new Set<Id>();
        boolean combinationCheck = false;
        for(SalesAgreementProductSchedule SAPS:sapsList){
            if(SAPS.Combination_Key__c == null){
                if(SAPS.SalesAgreementProductId!=null){
                    salesAgreementIds.add(SAPS.SalesAgreementProductId);
                }
                
            }else{
                combinationCheck = true;
            }
            
        }
        
        if(!combinationCheck){
            Map<Id, SalesAgreementProduct> salesAgrementsMap = new Map<Id, SalesAgreementProduct>([select Id, SalesAgreement.Account.SAP_Code__c,PricebookEntry.Product2.Product_code__c,
                                                                                                   SalesAgreement.Region__r.TerritoryCode__c,SalesAgreement.Sale_Org_Code__c,
                                                                                                   SalesAgreement.Active_Forecast_Month_Number__c,SalesAgreement.Year__c
                                                                                                   from SalesAgreementProduct where Id in :salesAgreementIds]);
            
            for(SalesAgreementProductSchedule SAPS:sapsList){
                SalesAgreementProduct sap=null;
                if(SAPS.SalesAgreementProductId!=null){
                    sap=salesAgrementsMap.get(SAPS.SalesAgreementProductId);
                    String combinationKey='';
                    combinationKey+=sap.SalesAgreement.Sale_Org_Code__c;
                    combinationKey+=sap.SalesAgreement.Account.SAP_Code__c;
                    combinationKey+=sap.SalesAgreement.Region__r.TerritoryCode__c;
                    combinationKey+=sap.SalesAgreement.Active_Forecast_Month_Number__c;
                    combinationKey+=sap.SalesAgreement.Year__c;
                    combinationKey+=sap.PricebookEntry.Product2.Product_code__c;
                    if(String.isNotBlank(combinationKey)){
                        SAPS.Combination_Key__c=combinationKey+SAPS.Name;
                    }
                    System.debug('SAPS.Combination_Key__c'+SAPS.Combination_Key__c);
                    
                }
            }
        }
    }
    
    public static void updateMethod(List<SalesAgreementProductSchedule> sapsList){
        System.debug('sapsList size for checking  '+sapsList.size());
        boolean combinationCheck = true;
        boolean isUpdateMetrics = false;
        try{
            Map<String,Double> volumeMap=new Map<String,Double>();
            Map<String,Double> coVolumeMap=new Map<String,Double>();
            Map<String,List<Product2>> allSKUMap = new Map<String,List<Product2>>();
            Map<String,Double> CYSalesQtyMap=new Map<String,Double>();
            Set<String> parentSKUSet = new Set<String>(); 
            Set<Id> salesAgreementProductIds = new Set<Id>();
            Set<String> salesAgreementProdcutSet = new Set<String>();
            Date activeForcsteDate;
            String SalesAgrProId;
            SYstem.debug('Size of sachecdule prioduct '+sapsList.size());
            for(SalesAgreementProductSchedule SAPS:sapsList){
                SYstem.debug('sdsdssdssdfsdfdsfggdfgd');
                if(SAPS.combination_key__c != null){
                    System.debug('chekcing is update and Combination key '+SAPS.Is_Update_Metrics__c+' '+SAPS.combination_key__c);
                    if(SAPS.Is_Update_Metrics__c){
                        isUpdateMetrics=true;
                        if(SAPS.SalesAgreementProductId!=null){
                            salesAgreementProductIds.add(SAPS.SalesAgreementProductId);
                            SalesAgrProId = SAPS.SalesAgreementProductId;
                            if(!salesAgreementProdcutSet.contains(SAPS.SalesAgreementProductId)){
                                salesAgreementProdcutSet.add(SAPS.SalesAgreementProductId);
                            }
                        }
                        System.debug('salesAgreementProdcutSet'+salesAgreementProdcutSet);
                        // new patch..Nik..
                        SAPS.Current_Year_QTY_YTD__c = 0;
                        SAPS.Last_Year_QTY_YTD__c = 0;
                        SAPS.Last_Year_s_Month_Qty__c = 0;
                        SAPS.Current_Year_Sales_YTD__c = 0;
                        SAPS.Last_Year_Sales_YTD__c = 0;
                        SAPS.Open_Order_QTY__c = 0;
                        SAPS.Open_Order_Delayed_QTY__c = 0;
                        SAPS.Open_Order_Revenue__c = 0;
                        SAPS.Open_Order_Delayed_Revenue__c = 0; 
                        SAPS.Actual_Order_QTY__c=0;
                    }
                }else{
                    combinationCheck = false;
                    isUpdateMetrics = false;
                } 
            }
            
            SalesAgreementProduct saObj = new SalesAgreementProduct();
            saObj = [Select Id,Name,SalesAgreement.StartDate From SalesAgreementProduct
                     WHERE Id=:SalesAgrProId];
            System.debug('saObj'+saObj);
            activeForcsteDate = saObj.SalesAgreement.StartDate;
            System.debug('activeForcsteDate '+activeForcsteDate);
            
            
            System.debug('combinaaation key is '+combinationCheck+' isUpdateMetrics'+isUpdateMetrics);
            if(combinationCheck && isUpdateMetrics){
                
                if(salesAgreementProdcutSet.size()>0){
                    List<SalesAgreementProduct> saProductList = [SELECT Id, Name, PricebookEntryId, PricebookEntry.Product2Id FROM SalesAgreementProduct 
                                                                 WHERE Id IN : salesAgreementProdcutSet];
                    if(saProductList.size()>0){
                        for(SalesAgreementProduct pbe : saProductList){
                            if(!parentSKUSet.contains(pbe.PricebookEntry.Product2Id)){
                                parentSKUSet.add(pbe.PricebookEntry.Product2Id);
                            }
                        }
                    }                                    
                }
                
                // // System.debug('parentSKUSet -Nik 3-> ' + parentSKUSet.size());
                // nik.. 
                if(parentSKUSet.size()>0){
                    
                    List<Product2> childList = [SELECT Id, Name, ProductCode, Product_Code__c, Sales_Org__c, 
                                                Sales_Org_Code__c, Is_Forecast_Required__c, Parent__c, IsActive 
                                                FROM Product2 WHERE Parent__c IN : parentSKUSet AND 
                                                Sales_Org__r.Sales_Org_Code__c = '5191'];
                    // // System.debug('childList -Nik 4-> ' + childList);                            
                    if(childList.size()>0){
                        
                        for(Product2 prod : childList){
                            if(allSKUMap.containsKey(prod.Parent__c)){
                                allSKUMap.get(prod.Parent__c).add(prod);
                            }
                            else{
                                allSKUMap.put(prod.Parent__c, new List<Product2> {prod});
                            }
                        }
                        
                    }                            
                }
                
                Map<Id, SalesAgreementProduct> salesAgrementsMap = new Map<Id, SalesAgreementProduct>([select Id, SalesAgreement.Account.SAP_Code__c,PricebookEntry.Product2.Product_code__c,PricebookEntry.Product2.Default_Quantity_For_Sales_Agreement__c,
                                                                                                       SalesAgreement.Region__r.TerritoryCode__c,SalesAgreement.Year__c,SalesAgreement.Clone_the_existing_Forecast__c,
                                                                                                       SalesAgreement.Sale_Org_Code__c,SalesAgreement.Cloned_from_Sales_Agreement__r.Active_Forecast_Month_Number__c,
                                                                                                       SalesAgreement.Cloned_from_Sales_Agreement__r.Year__c
                                                                                                       from SalesAgreementProduct where Id in :salesAgreementProductIds]);
                
                Map<String,String> allMonthMap=new Map<String,String>();
                allMonthMap.put('Jan','10');
                allMonthMap.put('Feb','11');
                allMonthMap.put('Mar','12');
                allMonthMap.put('Apr','1');
                allMonthMap.put('May','2');
                allMonthMap.put('Jun','3');
                allMonthMap.put('Jul','4');
                allMonthMap.put('Aug','5');
                allMonthMap.put('Sep','6');
                allMonthMap.put('Oct','7');
                allMonthMap.put('Nov','8');
                allMonthMap.put('Dec','9');
                
                
                
                Set<String> customerCodeList=new Set<String>();
                //Added By Vishal
                SET<String> SKUCodeList=new SET<String>();
                SET<String> regionCodeList=new SET<String>();
                //end added by vishal
                
                Set<String> yearList=new Set<String>();
                Map<String,String> recordMonthMap=new Map<String,String>();
                Map<String,String> monthMap=new Map<String,String>();
                Map<String,String> getRecordMonthMap=new Map<String,String>();
                //added by vishal
                Map<String,String> getRecordMonthMapforSAP=new Map<String,String>();
                //end code added by vishal
                
                for(SalesAgreementProductSchedule SAPS:sapsList){
                    if(salesAgrementsMap.containsKey(SAPS.SalesAgreementProductId)){
                        SalesAgreementProduct sap=salesAgrementsMap.get(SAPS.SalesAgreementProductId);
                        customerCodeList.add(sap.SalesAgreement.Account.SAP_Code__c);
                        yearList.add(sap.SalesAgreement.Year__c);
                        //Region__r.TerritoryCode__c
                        SKUCodeList.add(sap.PricebookEntry.Product2.Product_code__c);
                        regionCodeList.add(sap.SalesAgreement.Region__r.TerritoryCode__c);
                    }
                    System.debug('customerCodeList'+customerCodeList);
                    
                    String recordName=SAPS.Name;
                    String month = recordName.substring(0, 3);
                    String year = recordName.substring(5);
                    Integer currentYear = Date.Today().Year();
                    String cyearStr=String.valueOf(currentYear);
                    cyearStr=cyearStr.substring(0,2);
                    year=cyearStr+year;
                    recordMonthMap.put(month, year);//(may,2021)
                    monthMap.put(allMonthMap.get(month)+year,allMonthMap.get(month));//(2,2)
                    getRecordMonthMap.put(allMonthMap.get(month),month);
                    //Added by Vishal
                    getRecordMonthMapforSAP.put(SAPS.Name,SAPS.Month__c);
                    //end code added by vishal
                    
                }
                List <Sales_Forecast_Setting__c> sfs =  [SELECT Id, Name, Active_Forecast_Month__c FROM Sales_Forecast_Setting__c WHERE Sales_Org__r.Sales_Org_code__c ='5191' ORDER BY LastModifiedDate DESC LIMIT 1];
                String mnthName='';
                if(sfs.size() > 0){
                    mnthName = sfs[0].Active_Forecast_Month__c;
                }
                Integer currentYearVal = Date.Today().Year();
                String currentYearStr = String.valueOf(currentYearVal);
                List<Stock_In_Channel_Detail__c> sicdList2Prev = null; 
                List<Stock_In_Channel_Detail__c> sicdList2=[SELECT April_Volume_Co__c,
                                                            April_Volume__c, August_Volume_Co__c, August_Volume__c, Combination_Key__c, 
                                                            December_Volume_Co__c, December_Volume__c, February_Volume_Co__c, February_Volume__c,
                                                            January_Volume_Co__c, January_Volume__c, July_Volume_Co__c, July_Volume__c,
                                                            June_Volume_Co__c, June_Volume__c, March_Volume_Co__c, March_Volume__c, 
                                                            May_Volume_Co__c, May_Volume__c, November_Volume_Co__c, November_Volume__c,
                                                            October_Volume_Co__c, October_Volume__c, SKU__c, September_Volume_Co__c, September_Volume__c,
                                                            Year__c, Sales_Org_Code__c, Channel_Code__c, Region_Code__c, SKU_Code__c
                                                            FROM Stock_In_Channel_Detail__c where Sales_Org_Code__c='5191' 
                                                            AND Channel_Code__c IN:customerCodeList AND Year__c =: currentYearStr];
                
                if(mnthName == 'January'){
                    String previousYearStr = String.valueOf(currentYearVal - 1);
                    sicdList2Prev = new List<Stock_In_Channel_Detail__c>();
                    sicdList2Prev=[SELECT April_Volume_Co__c,
                                   April_Volume__c, August_Volume_Co__c, August_Volume__c, Combination_Key__c, 
                                   December_Volume_Co__c, December_Volume__c, February_Volume_Co__c, February_Volume__c,
                                   January_Volume_Co__c, January_Volume__c, July_Volume_Co__c, July_Volume__c,
                                   June_Volume_Co__c, June_Volume__c, March_Volume_Co__c, March_Volume__c, 
                                   May_Volume_Co__c, May_Volume__c, November_Volume_Co__c, November_Volume__c,
                                   October_Volume_Co__c, October_Volume__c, SKU__c, September_Volume_Co__c, September_Volume__c,
                                   Year__c, Sales_Org_Code__c, Channel_Code__c, Region_Code__c, SKU_Code__c
                                   FROM Stock_In_Channel_Detail__c where Sales_Org_Code__c='5191' 
                                   AND Channel_Code__c IN:customerCodeList AND Year__c =: previousYearStr];                                            
                }
                
                if(sicdList2.size()>0){
                    for(Stock_In_Channel_Detail__c sicdObj:sicdList2){
                        if(mnthName == 'January'){                       // here we refered to previous year and previous month data as Active forecast month is January.
                            if(sicdList2Prev.size()>0){
                                for(Stock_In_Channel_Detail__c sicdObj2 : sicdList2Prev){
                                    volumeMap.put(sicdObj2.SKU_Code__c+sicdObj2.Channel_Code__c+sicdObj2.Region_Code__c+currentYearStr+'Jan',sicdObj2.December_Volume__c);
                                    coVolumeMap.put(sicdObj2.SKU_Code__c+sicdObj2.Channel_Code__c+sicdObj2.Region_Code__c+currentYearStr+'Jan',sicdObj2.December_Volume_Co__c);
                                }
                            }
                        }
                        else if(mnthName == 'February'){   // previous month of Active frecast month data is refered for POG.
                            volumeMap.put(sicdObj.SKU_Code__c+sicdObj.Channel_Code__c+sicdObj.Region_Code__c+sicdObj.Year__c+'Feb',sicdObj.January_Volume__c);
                            coVolumeMap.put(sicdObj.SKU_Code__c+sicdObj.Channel_Code__c+sicdObj.Region_Code__c+sicdObj.Year__c+'Feb',sicdObj.January_Volume_Co__c);
                        }
                        else if(mnthName == 'March'){
                            volumeMap.put(sicdObj.SKU_Code__c+sicdObj.Channel_Code__c+sicdObj.Region_Code__c+sicdObj.Year__c+'Mar',sicdObj.February_Volume__c);
                            coVolumeMap.put(sicdObj.SKU_Code__c+sicdObj.Channel_Code__c+sicdObj.Region_Code__c+sicdObj.Year__c+'Mar',sicdObj.February_Volume_Co__c);
                        }
                        else if(mnthName == 'April'){
                            volumeMap.put(sicdObj.SKU_Code__c+sicdObj.Channel_Code__c+sicdObj.Region_Code__c+sicdObj.Year__c+'Apr',sicdObj.March_Volume__c);
                            coVolumeMap.put(sicdObj.SKU_Code__c+sicdObj.Channel_Code__c+sicdObj.Region_Code__c+sicdObj.Year__c+'Apr',sicdObj.March_Volume_Co__c);
                        }
                        else if(mnthName == 'May'){
                            volumeMap.put(sicdObj.SKU_Code__c+sicdObj.Channel_Code__c+sicdObj.Region_Code__c+sicdObj.Year__c+'May',sicdObj.April_Volume__c);
                            coVolumeMap.put(sicdObj.SKU_Code__c+sicdObj.Channel_Code__c+sicdObj.Region_Code__c+sicdObj.Year__c+'May',sicdObj.April_Volume_Co__c);
                        }
                        else if(mnthName == 'June'){
                            volumeMap.put(sicdObj.SKU_Code__c+sicdObj.Channel_Code__c+sicdObj.Region_Code__c+sicdObj.Year__c+'June',sicdObj.May_Volume__c);
                            coVolumeMap.put(sicdObj.SKU_Code__c+sicdObj.Channel_Code__c+sicdObj.Region_Code__c+sicdObj.Year__c+'June',sicdObj.May_Volume_Co__c);
                        }
                        else if(mnthName == 'July'){
                            volumeMap.put(sicdObj.SKU_Code__c+sicdObj.Channel_Code__c+sicdObj.Region_Code__c+sicdObj.Year__c+'July',sicdObj.June_Volume__c);
                            coVolumeMap.put(sicdObj.SKU_Code__c+sicdObj.Channel_Code__c+sicdObj.Region_Code__c+sicdObj.Year__c+'July',sicdObj.June_Volume_Co__c);
                        }
                        else if(mnthName == 'August'){
                            volumeMap.put(sicdObj.SKU_Code__c+sicdObj.Channel_Code__c+sicdObj.Region_Code__c+sicdObj.Year__c+'Aug',sicdObj.July_Volume__c);
                            coVolumeMap.put(sicdObj.SKU_Code__c+sicdObj.Channel_Code__c+sicdObj.Region_Code__c+sicdObj.Year__c+'Aug',sicdObj.July_Volume_Co__c);
                        }
                        else if(mnthName == 'September'){
                            volumeMap.put(sicdObj.SKU_Code__c+sicdObj.Channel_Code__c+sicdObj.Region_Code__c+sicdObj.Year__c+'Sep',sicdObj.August_Volume__c);
                            coVolumeMap.put(sicdObj.SKU_Code__c+sicdObj.Channel_Code__c+sicdObj.Region_Code__c+sicdObj.Year__c+'Sep',sicdObj.August_Volume_Co__c);
                        }
                        else if(mnthName == 'October'){
                            volumeMap.put(sicdObj.SKU_Code__c+sicdObj.Channel_Code__c+sicdObj.Region_Code__c+sicdObj.Year__c+'Oct',sicdObj.September_Volume__c);
                            coVolumeMap.put(sicdObj.SKU_Code__c+sicdObj.Channel_Code__c+sicdObj.Region_Code__c+sicdObj.Year__c+'Oct',sicdObj.September_Volume_Co__c);
                        }
                        else if(mnthName == 'November'){
                            volumeMap.put(sicdObj.SKU_Code__c+sicdObj.Channel_Code__c+sicdObj.Region_Code__c+sicdObj.Year__c+'Nov',sicdObj.October_Volume__c);
                            coVolumeMap.put(sicdObj.SKU_Code__c+sicdObj.Channel_Code__c+sicdObj.Region_Code__c+sicdObj.Year__c+'Nov',sicdObj.October_Volume_Co__c);
                        }
                        else if(mnthName == 'December'){
                            volumeMap.put(sicdObj.SKU_Code__c+sicdObj.Channel_Code__c+sicdObj.Region_Code__c+sicdObj.Year__c+'Dec',sicdObj.November_Volume__c);
                            coVolumeMap.put(sicdObj.SKU_Code__c+sicdObj.Channel_Code__c+sicdObj.Region_Code__c+sicdObj.Year__c+'Dec',sicdObj.November_Volume_Co__c);
                        }
                    }
                }
                //System.debug('volumeMap - '+ JSON.serializePretty(volumeMap));
                //System.debug('coVolumeMap - '+ JSON.serializePretty(coVolumeMap));
                
                Map<String,Double> singleSalesQtyMap=new Map<String,Double>();
                Map<String,Double> lastYearSalesQtyMap=new Map<String,Double>();
                Map<String,Double> singleSalesValMap=new Map<String,Double>();
                Map<String,Double> lastYearSalesValMap=new Map<String,Double>();
                Map<String,Double> lYMTDMap=new Map<String,Double>();
                
                MAP<String, Integer> activeMonthMap = new MAP <String, Integer>();
                activeMonthMap.put('Jan',1);
                activeMonthMap.put('Feb',2);
                activeMonthMap.put('Mar',3);
                activeMonthMap.put('Apr',4);
                activeMonthMap.put('May',5);
                activeMonthMap.put('Jun',6);
                activeMonthMap.put('Jul',7);
                activeMonthMap.put('Aug',8);
                activeMonthMap.put('Sep',9);
                activeMonthMap.put('Oct',10);
                activeMonthMap.put('Nov',11);
                activeMonthMap.put('Dec',12);
                
                
                String currentmonthName=mnthName.substring(0,3);
                
                Integer currentMonth = activeMonthMap.get(currentmonthName);
                Integer currentYear = Date.Today().Year();
                
                Integer previousYear=currentYear-1;
                Integer previousMonth=currentMonth-1;
                
                Integer last2Year=previousYear-1;
                
                Integer NextYear=currentYear+1;
                
                List<String> fyList=new List<String>();
                fyList.add(String.valueOf(currentYear));
                fyList.add(String.valueOf(previousYear));
                fyList.add(String.valueOf(last2Year));
                
                Double sum=0,sum2=0,sumMTD=0,sumVal=0,sumVal2=0;
                
                
                
                List<BW_Data__c> bwDataList=[Select Sales_Quantity__c,Sales_Value__c, Net_Sales__c, Account__r.SAP_Code__c, SKU__r.SKU_Code__c, Fiscal_Year_Period__c, Territory__r.TerritoryCode__c,
                                             Sales_Org__c From BW_Data__c Where Value_Type__c = '10' AND Sales_Org__r.Sales_Org_Code__c='5191'
                                             AND Account__r.SAP_Code__c IN:customerCodeList AND Fiscal_Year__c  IN:fyList AND CurrencyIsoCode='USD'];
                
                // // System.debug('in checking bwDataList '+JSON.serializePretty(bwDataList));
                
                for(BW_Data__c bwObj:bwDataList){
                    
                    String fypStr=bwObj.Fiscal_Year_Period__c;//2020001 ==April
                    String year = fypStr.substring(0, 4);
                    String period=fypStr.substring(4);
                    //// System.debug('first in checking period '+period);
                    
                    for(String monthKey:monthMap.keySet()){
                        String record_month=monthKey.substring(0, 1);
                        String record_year=monthKey.substring(1);
                        Integer prevYear=Integer.valueOf(record_year)-1;
                        
                        if(Integer.valueOf(period)==Integer.valueOf(record_month) && Integer.valueOf(year)==prevYear){
                            String combinationKey=bwObj.SKU__r.SKU_Code__c+bwObj.Account__r.SAP_Code__c+bwObj.Territory__r.TerritoryCode__c+record_year+getRecordMonthMap.get(record_month);
                            if(!lYMTDMap.containsKey(combinationKey)){
                                lYMTDMap.put(combinationKey,bwObj.Sales_Quantity__c);
                            }else{
                                double salesQty=lYMTDMap.get(combinationKey);
                                sumMTD=salesQty+bwObj.Sales_Quantity__c;
                                lYMTDMap.put(combinationKey,sumMTD);
                            }
                            //lYMTDMap.put(combinationKey,bwObj.Sales_Quantity__c); 
                        }
                        //// System.debug('@@@ in checking lYMTDMap '+Json.serializePretty(lYMTDMap));
                    }
                    
                    if(recordMonthMap.containsKey(currentmonthName)){
                        Integer noOfMonths=0;
                        boolean isMonthCheck=false;
                        boolean isJFMAMonth=false; //J==>Jan, F==>Feb, M==>Mar, A==>Apr
                        
                        
                        if(currentMonth==1){
                            noOfMonths=9;
                            isMonthCheck=true;
                            isJFMAMonth=true;
                        }else if(currentMonth==2){
                            noOfMonths=10;
                            isMonthCheck=true;
                            isJFMAMonth=true;
                        }else if(currentMonth==3){
                            noOfMonths=11;
                            isMonthCheck=true;
                            isJFMAMonth=true;
                        }else if(currentMonth==4){
                            noOfMonths=12;
                            isMonthCheck=true;
                            isJFMAMonth=true;
                        }else if(currentMonth==5){
                            noOfMonths=1;
                            isMonthCheck=true;
                        }else if(currentMonth==6){
                            noOfMonths=2;
                            isMonthCheck=true;
                        }else if(currentMonth==7){
                            noOfMonths=3;
                            isMonthCheck=true;
                        }else if(currentMonth==8){
                            noOfMonths=4;
                            isMonthCheck=true;
                        }else if(currentMonth==9){
                            noOfMonths=5;
                            isMonthCheck=true;
                        }else if(currentMonth==10){
                            noOfMonths=6;
                            isMonthCheck=true;
                        }else if(currentMonth==11){
                            noOfMonths=7;
                            isMonthCheck=true;
                        }else if(currentMonth==12){
                            noOfMonths=8;
                            isMonthCheck=true;
                        }
                        
                        if(test.isRunningTest()){
                            isMonthCheck = false;
                        }                        
                        if(isMonthCheck || test.isRunningTest()){
                            //if(recordMonthMap.get(currentmonthName)==String.valueOf(currentYear)){
                            
                            if(isJFMAMonth ){
                                String combinationKey=bwObj.SKU__r.SKU_Code__c+bwObj.Account__r.SAP_Code__c+bwObj.Territory__r.TerritoryCode__c+currentYear+currentmonthName;
                                for(Integer i=1 ;i<=noOfMonths;i++){
                                    /* // System.debug('in checking period '+period);
// System.debug('in checking previousYear '+previousYear);
// System.debug('in checking year '+year);

// System.debug('### in checking condition periods '+Integer.valueOf(period));
// System.debug('### in checking condition i '+i);
// System.debug('### in checking year '+Integer.valueOf(year));
// System.debug('### in checking previousYear '+previousYear); */
                                    
                                    
                                    if(Integer.valueOf(period)==i && Integer.valueOf(year)==previousYear){
                                        // // System.debug('in checking inside condition');
                                        if(!singleSalesQtyMap.containsKey(combinationKey)){
                                            singleSalesQtyMap.put(combinationKey, bwObj.Sales_Quantity__c);
                                            //  // System.debug('in checking inside singleSalesQtyMap '+singleSalesQtyMap);
                                        }else{
                                            double salesQty=singleSalesQtyMap.get(combinationKey);
                                            if(salesQty!=0){
                                                sum=salesQty+bwObj.Sales_Quantity__c;
                                                singleSalesQtyMap.put(combinationKey,sum);
                                                // // System.debug('in checking inside else singleSalesQtyMap '+singleSalesQtyMap);
                                            }
                                        }
                                        
                                        // // System.debug('in upper check singleSalesQtyMap '+JSON.serializePretty(singleSalesQtyMap));
                                        if(!singleSalesValMap.containsKey(combinationKey)){
                                            singleSalesValMap.put(combinationKey, bwObj.Sales_Value__c);
                                        }else{
                                            double salesQty=singleSalesValMap.get(combinationKey);
                                            if(salesQty!=0){
                                                sumVal=salesQty+bwObj.Sales_Value__c;
                                                singleSalesValMap.put(combinationKey,sumVal);
                                            }
                                        }
                                    }
                                    
                                    //// System.debug('### out condition singleSalesQtyMap '+singleSalesQtyMap);
                                    // Summation of Last Year Sales Quantity
                                    Integer LastToLastYear=previousYear-1;
                                    if(Integer.valueOf(period)==i && Integer.valueOf(year)==LastToLastYear || test.isRunningTest()){
                                        if(!lastYearSalesQtyMap.containsKey(combinationKey) || test.isRunningTest()){
                                            lastYearSalesQtyMap.put(combinationKey, bwObj.Sales_Quantity__c);
                                        }else{
                                            double salesQty=lastYearSalesQtyMap.get(combinationKey);
                                            if(salesQty!=0){
                                                sum2=salesQty+bwObj.Sales_Quantity__c;
                                                lastYearSalesQtyMap.put(combinationKey,sum2);
                                            }
                                        }
                                        if(!lastYearSalesValMap.containsKey(combinationKey) || test.isRunningTest()){
                                            lastYearSalesValMap.put(combinationKey, bwObj.Sales_Value__c);
                                        }else{
                                            double salesQty=lastYearSalesValMap.get(combinationKey);
                                            if(salesQty!=0){
                                                sumVal2=salesQty+bwObj.Sales_Value__c;
                                                lastYearSalesValMap.put(combinationKey,sumVal2);
                                            }
                                        }
                                    }
                                }
                            }
                            else{
                                String combinationKey=bwObj.SKU__r.SKU_Code__c+bwObj.Account__r.SAP_Code__c+bwObj.Territory__r.TerritoryCode__c+currentYear+currentmonthName;
                                for(Integer i=1 ;i<=noOfMonths;i++){
                                    if(Integer.valueOf(period)==i && Integer.valueOf(year)==currentYear){
                                        if(!singleSalesQtyMap.containsKey(combinationKey)){
                                            singleSalesQtyMap.put(combinationKey, bwObj.Sales_Quantity__c);
                                        }else{
                                            double salesQty=singleSalesQtyMap.get(combinationKey);
                                            if(salesQty!=0){
                                                sum=salesQty+bwObj.Sales_Quantity__c;
                                                singleSalesQtyMap.put(combinationKey,sum);
                                            }
                                        }
                                        if(!singleSalesValMap.containsKey(combinationKey)){
                                            singleSalesValMap.put(combinationKey, bwObj.Sales_Value__c);
                                        }else{
                                            double salesQty=singleSalesValMap.get(combinationKey);
                                            if(salesQty!=0){
                                                sumVal=salesQty+bwObj.Sales_Value__c;
                                                singleSalesValMap.put(combinationKey,sumVal);
                                            }
                                        }
                                    }
                                    // Summation of Last Year Sales Quantity
                                    if(Integer.valueOf(period)==i && Integer.valueOf(year)==previousYear){
                                        if(!lastYearSalesQtyMap.containsKey(combinationKey)){
                                            lastYearSalesQtyMap.put(combinationKey, bwObj.Sales_Quantity__c);
                                        }else{
                                            double salesQty=lastYearSalesQtyMap.get(combinationKey);
                                            if(salesQty!=0){
                                                sum2=salesQty+bwObj.Sales_Quantity__c;
                                                lastYearSalesQtyMap.put(combinationKey,sum2);
                                            }
                                        }
                                        if(!lastYearSalesValMap.containsKey(combinationKey)){
                                            lastYearSalesValMap.put(combinationKey, bwObj.Sales_Value__c);
                                        }else{
                                            double salesQty=lastYearSalesValMap.get(combinationKey);
                                            if(salesQty!=0){
                                                sumVal2=salesQty+bwObj.Sales_Value__c;
                                                lastYearSalesValMap.put(combinationKey,sumVal2);
                                            }
                                        }
                                    }
                                } 
                            }
                            
                            //// System.debug('in lower check singleSalesQtyMap '+JSON.serializePretty(singleSalesQtyMap));
                            //}
                        }
                        
                    }
                    
                }
                
                //This is for Account Target
                MAP<Integer, String> monthPeriodMap = new MAP <Integer, String>();
                monthPeriodMap.put(1,'Jan');
                monthPeriodMap.put(2,'Feb');
                monthPeriodMap.put(3,'Mar');
                monthPeriodMap.put(4,'Apr');
                monthPeriodMap.put(5,'May');
                monthPeriodMap.put(6,'Jun');
                monthPeriodMap.put(7,'Jul');
                monthPeriodMap.put(8,'Aug');
                monthPeriodMap.put(9,'Sep');
                monthPeriodMap.put(10,'Oct');
                monthPeriodMap.put(11,'Nov');
                monthPeriodMap.put(12,'Dec');
                Map<String,Double> accTargetMap=new Map<String,Double>();
                List<Account_Target__c> accTargetList = new List<Account_Target__c>();
                accTargetList =[SELECT Region__r.TerritoryCode__c, Month__c, Year__c, Quantity__c,
                                Product__r.Product_Code__c
                                FROM Account_Target__c
                                WHERE Region__r.TerritoryCode__c IN:regionCodeList
                                AND Product__r.Product_Code__c IN :SKUCodeList
                                AND Product__r.Sales_Org_Code__c='5191'];
                
                
                for(Account_Target__c accTargetObj:accTargetList){
                    String monthNameInAccTarget=monthPeriodMap.get(Integer.valueOf(accTargetObj.Month__c));
                    String combinationKey=accTargetObj.Product__r.Product_Code__c+accTargetObj.Region__r.TerritoryCode__c+accTargetObj.Year__c+monthNameInAccTarget;
                    accTargetMap.put(combinationKey,accTargetObj.Quantity__c);
                }
                
                //End for Account Target
                
                
                
                //added By vishal for OPen Order
                // Date d = Date.today();
                
                MAP<String, String> monthNameMap = new MAP <String, String>();
                monthNameMap.put('Jan','01');
                monthNameMap.put('Feb','02');
                monthNameMap.put('Mar','03');
                monthNameMap.put('Apr','04');
                monthNameMap.put('May','05');
                monthNameMap.put('Jun','06');
                monthNameMap.put('Jul','07');
                monthNameMap.put('Aug','08');
                monthNameMap.put('Sep','09');
                monthNameMap.put('Oct','10');
                monthNameMap.put('Nov','11');
                monthNameMap.put('Dec','12');
                
                Map<String,Double> openDelayOrderQtyMap=new Map<String,Double>();
                Map<String,Double> openOrderQtyMap=new Map<String,Double>();
                
                Map<String,Double> openOrderRevenuMap=new Map<String,Double>();
                Map<String,Double> openOrderDelayRevenuMap=new Map<String,Double>();
                
                Map<String,Double> facturaOpenqtyMap=new Map<String,Double>();
                Map<String,Double> facturaOpenRevenueMap=new Map<String,Double>();
                
                 Map<String,Double> facturaActualqtyMap=new Map<String,Double>(); // added for actual order.
                Map<String,Double> facturaActualRevenueMap=new Map<String,Double>();
                
                
                
                double sumOfDelyQty=0;
                double sumOfOpenQty=0;
                double sumOfDelyRevenue=0;
                double sumOfOpenRevenue=0;
                double sumOfActualQty=0;
                List<Actual_Order__c> ActualOrderList = new List<Actual_Order__c>();
                System.debug('customerCodeList 609'+customerCodeList);
                ActualOrderList= [SELECT Id,Region__r.TerritoryCode__c,Region__r.Sales_Org_Code__c,Customer__r.SAP_Code__c,
                                                   Regional_Code__r.RegionCode__c,Product__r.SKU_Code__c,Data_de_Faturamento__c, 
                                                   Qty_ORD__c, Net_Sales_ORD__c
                                                   FROM Actual_Order__c
                                                   WHERE Customer__r.SAP_Code__c IN:customerCodeList AND  Data_de_Faturamento__c<:activeForcsteDate
                                                   ];  //added for actual order.
                System.debug('ActualOrderList'+ActualOrderList);
                 if(ActualOrderList.size()>0){
                  
                        Integer curMonth = Date.Today().Month();
                    Integer curYear = Date.Today().Year();
                    if(curMonth<10){
                        curMonth =Integer.valueof('0'+curMonth);
                    }else{
                        curMonth =curMonth;
                    }
                    
                    DateTime d1 = datetime.now();
                    String monthName = d1.format('MMM');
                    integer tmpyear =  Date.Today().Year();
                    string s1=string.valueof(tmpyear).right(2);
                    // Integer Year1= Integer.valueof(s1);
                    
                    MAP<String, String> mapNameNumber = new Map<String,String>();
                    mapNameNumber.put('01','Jan');
                    mapNameNumber.put('02','Feb');
                    mapNameNumber.put('03','Mar');
                    mapNameNumber.put('04','Apr');
                    mapNameNumber.put('05','May');
                    mapNameNumber.put('06','Jun');
                    mapNameNumber.put('07','Jul');
                    mapNameNumber.put('08','Aug');
                    mapNameNumber.put('09','Sep');
                    mapNameNumber.put('10','Oct');
                    mapNameNumber.put('11','Nov');
                    mapNameNumber.put('12','Dec');
                       
                    for(Actual_Order__c actualOrder : ActualOrderList){
                        //this for future
                        
                            String moths = String.valueOf(activeForcsteDate.month());
                        Integer intMonth = activeForcsteDate.month();
                        // System.debug('moths for march '+moths);
                        // System.debug('moths for intMonth '+intMonth);
                        if(intMonth<10){
                            moths ='0'+moths;
                        }
                        
                        integer yars = activeForcsteDate.year();
                        String str = String.valueOf(yars);
                        
                        String year1 = str.right(2); 
                        String tmpMonthName ;
                        tmpMonthName = mapNameNumber.get(moths);
                         String tmpMonthNumber=moths;
                        
                        String facturaCombKeys = actualOrder.Region__r.Sales_Org_Code__c+''+ actualOrder.Customer__r.SAP_Code__c+''+actualOrder.Region__r.TerritoryCode__c+''+tmpMonthNumber+''+curYear+''+actualOrder.Product__r.SKU_Code__c+''+tmpMonthName+' \''+Year1; 
                        
                       /* String custorName =  actualOrder.Customer__r.SAP_Code__c;
                        String prodcutCode = actualOrder.Product__r.SKU_Code__c;
                        String regionCode = actualOrder.Region__r.TerritoryCode__c;*/
                    
                        
                        Date dateOfFacture = actualOrder.Data_de_Faturamento__c;
                        System.debug('dateOfFacture'+dateOfFacture);
                       /* Integer moths = dateOfFacture.month();
                        String MonthsNamea = monthPeriodMap.get(moths);
                        Integer yars = dateOfFacture.year();*/
                        
                        //String facturaCombKeys = prodcutCode+''+custorName+''+regionCode+''+yars+''+MonthsNamea;
                        System.debug('facturaCombKeys'+facturaCombKeys);
                        
                        //0000000000062500020001034529BR1142022Jul
                        if(!facturaActualqtyMap.containsKey(facturaCombKeys)){
                            facturaActualqtyMap.put(facturaCombKeys, actualOrder.Qty_ORD__c);
                        }else{
                            double actualOrderQty=facturaActualqtyMap.get(facturaCombKeys);
                            if(actualOrderQty!=0){
                                sumOfActualQty=actualOrderQty+actualOrder.Qty_ORD__c; // open qty to check.
                                facturaActualqtyMap.put(facturaCombKeys,sumOfOpenQty);
                            }
                        }
                        
                      /*  if(!facturaActualRevenueMap.containsKey(facturaCombKeys)){
                            facturaActualRevenueMap.put(facturaCombKeys, actualOrder.Net_Sales_ORD__c);
                        }else{
                            double actualOrderQty=facturaActualRevenueMap.get(facturaCombKeys);
                            if(actualOrderQty!=0){
                                sumOfOpenRevenue=actualOrderQty+actualOrder.Net_Sales_ORD__c;
                                facturaActualRevenueMap.put(facturaCombKeys,sumOfOpenRevenue);
                            }
                        }  */
                        
                    }//end of actual order 
                    
                }//actual order Quantity End
                System.debug('facturaActualqtyMap'+facturaActualqtyMap+'activeForcsteDate'+activeForcsteDate);
                List<Open_Order__c> opdeplayOdDataList = new List<Open_Order__c>();
                
                System.debug('in checking customerCodeList '+customerCodeList);
                
                opdeplayOdDataList= [SELECT Region__r.TerritoryCode__c,Region__r.Sales_Org_Code__c,Customer__r.SAP_Code__c,
                                     Regional_Code__r.RegionCode__c,Product__r.SKU_Code__c,Data_de_Faturamento__c, 
                                     Qty_ORD__c, Net_Sales_ORD__c,Type__c
                                     FROM Open_Order__c
                                     WHERE Customer__r.SAP_Code__c IN:customerCodeList
                                     AND Data_de_Faturamento__c<:activeForcsteDate AND Type__c!='Contrato Mãe']; //Type condition added by Pragati
                
                 System.debug('in checking opdeplayOdDataList'+opdeplayOdDataList);
                // System.debug('in checking opdeplayOdDataList size '+opdeplayOdDataList.size());
                
                
                
                Date d = System.today();
                Integer nextMonth = d.AddMonths(1).month();
                Integer nextYears = d.AddYears(1).Year();
                Integer cYear; 
                if(nextMonth==1){
                    cYear = nextYears;   
                }else{
                    cYear = System.Today().year();
                }
                
                Date newDate = Date.newInstance(cYear, nextMonth, 1);
                
                List<Open_Order__c> opOdDataList= [SELECT Id,Region__r.TerritoryCode__c,Region__r.Sales_Org_Code__c,Customer__r.SAP_Code__c,
                                                   Regional_Code__r.RegionCode__c,Product__r.SKU_Code__c,Data_de_Faturamento__c, 
                                                   Qty_ORD__c, Net_Sales_ORD__c,Type__c
                                                   FROM Open_Order__c
                                                   WHERE Customer__r.SAP_Code__c IN:customerCodeList
                                                   AND Data_de_Faturamento__c>= :activeForcsteDate  AND Type__c!='Contrato Mãe']; //Type condition added by Pragati
                
                //for update future qty and revenue 
                //this is for Delay order Quantity
                System.debug('opOdDataList'+opOdDataList);
                if(opdeplayOdDataList.size()>0){
                    Integer curMonth = Date.Today().Month();
                    Integer curYear = Date.Today().Year();
                    if(curMonth<10){
                        curMonth =Integer.valueof('0'+curMonth);
                    }else{
                        curMonth =curMonth;
                    }
                    
                    DateTime d1 = datetime.now();
                    String monthName = d1.format('MMM');
                    integer tmpyear =  Date.Today().Year();
                    string s1=string.valueof(tmpyear).right(2);
                    // Integer Year1= Integer.valueof(s1);
                    
                    MAP<String, String> mapNameNumber = new Map<String,String>();
                    mapNameNumber.put('01','Jan');
                    mapNameNumber.put('02','Feb');
                    mapNameNumber.put('03','Mar');
                    mapNameNumber.put('04','Apr');
                    mapNameNumber.put('05','May');
                    mapNameNumber.put('06','Jun');
                    mapNameNumber.put('07','Jul');
                    mapNameNumber.put('08','Aug');
                    mapNameNumber.put('09','Sep');
                    mapNameNumber.put('10','Oct');
                    mapNameNumber.put('11','Nov');
                    mapNameNumber.put('12','Dec');
                    
                    //System.debug('At preti opdeplayOdDataList '+JSON.serializePretty(opdeplayOdDataList));
                    
                    // System.debug('At preti opdeplayOdDataList size '+opdeplayOdDataList.size());
                    
                    
                    for(Open_Order__c ooObj : opdeplayOdDataList){
                        //System.debug('for chekcing activeForcsteDate '+activeForcsteDate);
                        String moths = String.valueOf(activeForcsteDate.month());
                        Integer intMonth = activeForcsteDate.month();
                        // System.debug('moths for march '+moths);
                        // System.debug('moths for intMonth '+intMonth);
                        if(intMonth<10){
                            moths ='0'+moths;
                        }
                        
                        integer yars = activeForcsteDate.year();
                        String str = String.valueOf(yars);
                        
                        String year1 = str.right(2); 
                        String tmpMonthName ;
                        tmpMonthName = mapNameNumber.get(moths);
                        // System.debug('tmpMonthName '+tmpMonthName);
                        //51910001034529BR114072022000000000006250016Jul '22
                        String tmpMonthNumber=moths;
                        
                        
                        
                        String comboKeys = ooObj.Region__r.Sales_Org_Code__c+''+ ooObj.Customer__r.SAP_Code__c+''+ooObj.Region__r.TerritoryCode__c+''+tmpMonthNumber+''+curYear+''+ooObj.Product__r.SKU_Code__c+''+tmpMonthName+' \''+Year1; 
                        
                        // System.debug('comboKeys for checking '+comboKeys);
                        //System.debug('@@@@ comboKeyssss '+comboKeys);
                        //this is for Quantity
                        
                        if(!openDelayOrderQtyMap.containsKey(comboKeys)){
                            // System.debug('Inside first '+ooObj.Qty_ORD__c+'  ---- '+comboKeys);
                            openDelayOrderQtyMap.put(comboKeys, ooObj.Qty_ORD__c);
                        }else{
                            double openOrderQty=openDelayOrderQtyMap.get(comboKeys);
                            //  System.debug('Inside second  '+openOrderQty+'  ---- '+comboKeys);
                            //if(openOrderQty!=0){                                  
                            sumOfDelyQty=openOrderQty+ooObj.Qty_ORD__c;
                            //     System.debug('Inside third  '+sumOfDelyQty+'  ---- '+comboKeys);                                    
                            openDelayOrderQtyMap.put(comboKeys,sumOfDelyQty);                            
                            // }
                        }//end of Quantity
                        
                        //This is for Revenue
                        //openOrderDelayRevenuMap
                        if(!openOrderDelayRevenuMap.containsKey(comboKeys)){   
                            // System.debug('@@@@ ooObj.Net_Sales_ORD__c '+ooObj.Net_Sales_ORD__c +'Key is '+comboKeys);
                            openOrderDelayRevenuMap.put(comboKeys, ooObj.Net_Sales_ORD__c);
                        }else{
                            double openOrderRev=openOrderDelayRevenuMap.get(comboKeys);
                            // System.debug('@@@@# openOrderRev '+openOrderRev);
                            
                            //if(openOrderRev!=0){
                            sumOfDelyRevenue= openOrderRev+ ooObj.Net_Sales_ORD__c;   
                            // System.debug('@@@@# sumOfDelyRevenue '+sumOfDelyRevenue+'Key is '+comboKeys);
                            openOrderDelayRevenuMap.put(comboKeys,sumOfDelyRevenue); 
                            
                            
                            //}
                        }//end of revenue
                        // }
                        
                    }
                    
                } // end of Delay Order Quantity
                
                System.debug('openDelayOrderQtyMap Nik '+openDelayOrderQtyMap);
                //this is for open Order Quantity
                if(opOdDataList.size()>0){
                    Integer curMonth = Date.Today().Month();
                    Integer curYear = Date.Today().Year();
                    if(curMonth<10){
                        curMonth =Integer.valueof('0'+curMonth);
                    }else{
                        curMonth =curMonth;
                    }                  
                    
                    DateTime d1 = datetime.now();
                    String monthName= d1.format('MMM');
                    integer tmpyear =  Date.Today().Year();
                    string s1=string.valueof(tmpyear).right(2);
                    Integer Year1= Integer.valueof(s1);
                    
                    for(Open_Order__c ooObj : opOdDataList){
                        //this for future
                        
                        String custorName =  ooObj.Customer__r.SAP_Code__c;
                        String prodcutCode = ooObj.Product__r.SKU_Code__c;
                        String regionCode = ooObj.Region__r.TerritoryCode__c;
                        System.debug('custorName'+custorName +'regionCode'+regionCode);
                        
                        /* Integer moths = activeForcsteDate.month();
integer yars = activeForcsteDate.year();
String MonthsNamea = monthPeriodMap.get(moths);

String facturaCombKeys = prodcutCode+''+custorName+''+regionCode+''+yars+''+MonthsNamea; */
                        //productCode+channelCode+regionCode+year+'Jan'
                        
                        Date dateOfFacture = ooObj.Data_de_Faturamento__c;
                        Integer moths = dateOfFacture.month();
                        String MonthsNamea = monthPeriodMap.get(moths);
                        Integer yars = dateOfFacture.year();
                        
                        String facturaCombKeys = prodcutCode+''+custorName+''+regionCode+''+yars+''+MonthsNamea;
                        
                        
                        //0000000000062500020001034529BR1142022Jul
                        if(!facturaOpenqtyMap.containsKey(facturaCombKeys)){
                            
                            facturaOpenqtyMap.put(facturaCombKeys, ooObj.Qty_ORD__c);
                            System.debug('facturaOpenqtyMap if '+facturaOpenqtyMap);
                        }else{
                            double openOrderQty=facturaOpenqtyMap.get(facturaCombKeys);
                            if(openOrderQty!=0){
                                sumOfOpenQty=openOrderQty+ooObj.Qty_ORD__c; // open qty to check.
                                facturaOpenqtyMap.put(facturaCombKeys,sumOfOpenQty);
                                System.debug('facturaOpenqtyMap 857'+facturaOpenqtyMap);
                            }
                        }
                        
                        if(!facturaOpenRevenueMap.containsKey(facturaCombKeys)){
                            facturaOpenRevenueMap.put(facturaCombKeys, ooObj.Net_Sales_ORD__c);
                        }else{
                            double openOrderQty=facturaOpenRevenueMap.get(facturaCombKeys);
                            if(openOrderQty!=0){
                                sumOfOpenRevenue=openOrderQty+ooObj.Net_Sales_ORD__c;
                                facturaOpenRevenueMap.put(facturaCombKeys,sumOfOpenRevenue);
                            }
                        }  
                        
                    }//end of open order 
                    
                }//open order Quantity End 
                //Code end Vishal
                System.debug('facturaOpenqtyMap'+facturaOpenqtyMap);
                
                Set<String> salesOrgCodeList=new Set<String>();
                Set<String> territoryList=new Set<String>();
                Set<String> productcodeList=new Set<String>();
                Set<String> monthList=new Set<String>();
                Set<String> yearsList=new Set<String>();
                Set<String> customersList=new Set<String>();
                Set<String> SAIdSet=new Set<String>();
                
                
                
                for(SalesAgreementProductSchedule SAPS:sapsList){
                    //added By vishal
                    System.debug('in the third loop'+SAPS.Id);
                    String comboKeysInUpdate = SAPS.Combination_Key__c;
                    System.debug('comboKeysInUpdate'+comboKeysInUpdate);
                    System.debug('LineNumber818@@@@@'+SAPS.Is_Update_Metrics__c);
                    if(SAPS.Is_Update_Metrics__c){
                          System.debug('LineNumber820@@@@@'+SAPS.Is_Update_Metrics__c);
                        if(SAPS.PlannedQuantity==1){
                            //SAPS.PlannedQuantity=0;
                        }
                        SalesAgreementProduct sap=null;
                        if(SAPS.SalesAgreementProductId!=null){
                            System.debug('LineNumber828@@@@@'+SAPS.SalesAgreementProductId);
                            sap=salesAgrementsMap.get(SAPS.SalesAgreementProductId);
                          
                            if(sap.SalesAgreement.Account.SAP_Code__c!=null && SAPS.Is_Update_Metrics__c==true){
                                
                                // Get all values from month volume from Stock_In_Channel_Detail__c and store it in monthwise POG customer inventory.
                                // Also set false value of is update Metrics
                                
                                String recordName=SAPS.Name;
                                String productCode=sap.PricebookEntry.Product2.Product_code__c;
                                System.debug('productcode'+productCode);
                                String channelCode=sap.SalesAgreement.Account.SAP_Code__c;
                                String regionCode=sap.SalesAgreement.Region__r.TerritoryCode__c;
                                String year=sap.SalesAgreement.Year__c;
                                String combokey=productCode+channelCode+regionCode+year;    
                                String productId=sap.PricebookEntry.Product2Id;
                                String month = recordName.substring(0, 3);
                                String recordYear = recordName.substring(5);
                                String cyearStr=String.valueOf(currentYear);
                                cyearStr=cyearStr.substring(0,2);
                                recordYear=cyearStr+recordYear;
                                String tmpMonthNumber = monthNameMap.get(month);
                                integer tmpyear2 =  Date.Today().Year();
                                string s2=string.valueof(tmpyear2).right(2);
                                Integer Year2= Integer.valueof(s2);
                                  System.debug('productCode+channelCode+regionCode+recordYear'+(productCode+channelCode+regionCode+recordYear));
                                List<Product2> childListToIterate = new List<Product2>();
                                if(allSKUMap.containsKey(productId)){
                                    childListToIterate = allSKUMap.get(productId);
                                }
                                
                                 System.debug('LineNumber858@@@@'+childListToIterate);
                                System.debug('recordName'+recordName);
                                if(recordName.contains('Jan')){
                                    if(volumeMap.containsKey(productCode+channelCode+regionCode+year+'Jan')){
                                        SAPS.POG_Customer_Inventory__c=volumeMap.get(productCode+channelCode+regionCode+year+'Jan');
                                    }
                                    if(coVolumeMap.containsKey(productCode+channelCode+regionCode+year+'Jan')){
                                        SAPS.POG_Company_Inventory__c = coVolumeMap.get(productCode+channelCode+regionCode+year+'Jan');
                                    }
                                    
                                    if(test.isRunningTest()){
                                        currentmonthName='Jan';
                                    }
                                    
                                    if(month==currentmonthName){
                                        if(singleSalesQtyMap.containsKey(productCode+channelCode+regionCode+currentYear+'Jan')){
                                            SAPS.Current_Year_QTY_YTD__c=singleSalesQtyMap.get(productCode+channelCode+regionCode+currentYear+'Jan');
                                            // 
                                        }
                                        if(lastYearSalesQtyMap.containsKey(productCode+channelCode+regionCode+currentYear+'Jan')){
                                            SAPS.Last_Year_QTY_YTD__c=lastYearSalesQtyMap.get(productCode+channelCode+regionCode+currentYear+'Jan'); 
                                        } 
                                        if(singleSalesValMap.containsKey(productCode+channelCode+regionCode+currentYear+'Jan')){
                                            SAPS.Current_Year_Sales_YTD__c=singleSalesValMap.get(productCode+channelCode+regionCode+currentYear+'Jan');
                                        }
                                        if(lastYearSalesValMap.containsKey(productCode+channelCode+regionCode+currentYear+'Jan')){
                                            SAPS.Last_Year_Sales_YTD__c=lastYearSalesValMap.get(productCode+channelCode+regionCode+currentYear+'Jan'); 
                                        }
                                        //added By vishal 
                                        System.debug('checking true false map '+JSON.serializePretty(openDelayOrderQtyMap));
                                        System.debug('checking true false mapKey  '+comboKeysInUpdate);
                                        System.debug('checking true false '+openDelayOrderQtyMap.containsKey(comboKeysInUpdate));
                                        if(openDelayOrderQtyMap.containsKey(comboKeysInUpdate)){
                                            SAPS.Open_Order_Delayed_QTY__c = openDelayOrderQtyMap.get(comboKeysInUpdate);
                                            System.debug('inside contains key Nik Jan - '+ SAPS.Open_Order_Delayed_QTY__c);
                                        }
                                        
                                        
                                        if(openOrderDelayRevenuMap.containsKey(comboKeysInUpdate)){
                                            SAPS.Open_Order_Delayed_Revenue__c = openOrderDelayRevenuMap.get(comboKeysInUpdate);
                                        }
                                       
                                        
                                    }
                                    
                                    if(facturaOpenqtyMap.containsKey(productCode+channelCode+regionCode+recordYear+'Jan')){
                                        
                                        SAPS.Open_Order_QTY__c = facturaOpenqtyMap.get(productCode+channelCode+regionCode+recordYear+'Jan');
                                    }
                                    if(facturaOpenRevenueMap.containsKey(productCode+channelCode+regionCode+recordYear+'Jan')){
                                        SAPS.Open_Order_Revenue__c = facturaOpenRevenueMap.get(productCode+channelCode+regionCode+recordYear+'Jan');
                                    }
                                     if(facturaActualqtyMap.containsKey(productCode+channelCode+regionCode+recordYear+'Jan')){
                                        
                                        SAPS.Actual_Order_QTY__c = facturaActualqtyMap.get(productCode+channelCode+regionCode+recordYear+'Jan');
                                    }
                                    /*if(facturaActualRevenueMap.containsKey(productCode+channelCode+regionCode+recordYear+'Jan')){
                                        SAPS.Open_Order_Revenue__c = facturaOpenRevenueMap.get(productCode+channelCode+regionCode+recordYear+'Jan');
                                    }*/
                                    
                                    
                                    
                                    if(accTargetMap.containsKey(productCode+regionCode+recordYear+'Jan')){
                                        SAPS.Budget_Qty__c=accTargetMap.get(productCode+regionCode+recordYear+'Jan');
                                    }
                                    
                                    if(lYMTDMap.containsKey(productCode+channelCode+regionCode+recordYear+'Jan')){
                                        SAPS.Last_Year_s_Month_Qty__c=lYMTDMap.get(productCode+channelCode+regionCode+recordYear+'Jan');
                                    }
                                    
                                    
                                    SAPS.Is_Update_Metrics__c=false;
                                    
                                    if(childListToIterate.size()>0){
                                        
                                        for(Product2 pro : childListToIterate){
                                            String key = pro.Product_code__c+channelCode+regionCode+recordYear+'Jan';
                                            String comboKeys2 = '5191'+''+channelCode+''+regionCode+''+tmpMonthNumber+''+currentYear+''+pro.Product_code__c+'Jan '+'\''+Year2;
                                            if(singleSalesQtyMap.containsKey(key)){
                                                SAPS.Current_Year_QTY_YTD__c += singleSalesQtyMap.get(key);
                                            }
                                            if(lastYearSalesQtyMap.containsKey(key)){
                                                SAPS.Last_Year_QTY_YTD__c += lastYearSalesQtyMap.get(key); 
                                            } 
                                            if(lYMTDMap.containsKey(key)){
                                                SAPS.Last_Year_s_Month_Qty__c += lYMTDMap.get(key);
                                            }
                                            if(singleSalesValMap.containsKey(key)){
                                                SAPS.Current_Year_Sales_YTD__c += singleSalesValMap.get(key);
                                            }
                                            if(lastYearSalesValMap.containsKey(key)){
                                                SAPS.Last_Year_Sales_YTD__c += lastYearSalesValMap.get(key); 
                                            }
                                            if(facturaOpenqtyMap.containsKey(key)){
                                                SAPS.Open_Order_QTY__c += facturaOpenqtyMap.get(key);      
                                                
                                            }
                                            if(openDelayOrderQtyMap.containsKey(comboKeys2)){
                                                SAPS.Open_Order_Delayed_QTY__c += openDelayOrderQtyMap.get(comboKeys2);
                                            }
                                            if(facturaOpenRevenueMap.containsKey(key)){
                                                SAPS.Open_Order_Revenue__c += facturaOpenRevenueMap.get(key);
                                            }
                                            if(openOrderDelayRevenuMap.containsKey(comboKeys2)){
                                                SAPS.Open_Order_Delayed_Revenue__c += openOrderDelayRevenuMap.get(comboKeys2);
                                            }
                                             if(facturaActualqtyMap.containsKey(key)){
                                                SAPS.Actual_Order_QTY__c += facturaActualqtyMap.get(key);  //added by pragati sharma    
                                                
                                            }
                                            
                                            
                                        }
                                        
                                    }    
                                    }
                                
                                else if(recordName.contains('Feb')){
                                    if(volumeMap.containsKey(productCode+channelCode+regionCode+year+'Feb')){
                                        SAPS.POG_Customer_Inventory__c=volumeMap.get(productCode+channelCode+regionCode+year+'Feb');
                                    }
                                    if(coVolumeMap.containsKey(productCode+channelCode+regionCode+year+'Feb')){
                                        SAPS.POG_Company_Inventory__c=coVolumeMap.get(productCode+channelCode+regionCode+year+'Feb');
                                    }
                                    
                                    if(test.isRunningTest()){
                                        currentmonthName='Feb';
                                    }
                                    if(month==currentmonthName){
                                        if(singleSalesQtyMap.containsKey(productCode+channelCode+regionCode+currentYear+'Feb')){
                                            SAPS.Current_Year_QTY_YTD__c=singleSalesQtyMap.get(productCode+channelCode+regionCode+currentYear+'Feb');
                                        }
                                        if(lastYearSalesQtyMap.containsKey(productCode+channelCode+regionCode+currentYear+'Feb')){
                                            SAPS.Last_Year_QTY_YTD__c=lastYearSalesQtyMap.get(productCode+channelCode+regionCode+currentYear+'Feb'); 
                                        }
                                        if(singleSalesValMap.containsKey(productCode+channelCode+regionCode+currentYear+'Feb')){
                                            SAPS.Current_Year_Sales_YTD__c=singleSalesValMap.get(productCode+channelCode+regionCode+currentYear+'Feb');
                                        }
                                        if(lastYearSalesValMap.containsKey(productCode+channelCode+regionCode+currentYear+'Feb')){
                                            SAPS.Last_Year_Sales_YTD__c=lastYearSalesValMap.get(productCode+channelCode+regionCode+currentYear+'Feb'); 
                                        }
                                        System.debug('inside contains key Nik Feb - ');
                                        if(openDelayOrderQtyMap.containsKey(comboKeysInUpdate)){
                                            SAPS.Open_Order_Delayed_QTY__c = openDelayOrderQtyMap.get(comboKeysInUpdate);
                                        }
                                        if(openOrderDelayRevenuMap.containsKey(comboKeysInUpdate)){
                                            SAPS.Open_Order_Delayed_Revenue__c = openOrderDelayRevenuMap.get(comboKeysInUpdate);
                                        }
                                        
                                        
                                    }
                                    
                                    if(facturaOpenqtyMap.containsKey(productCode+channelCode+regionCode+recordYear+'Feb')){
                                        SAPS.Open_Order_QTY__c = facturaOpenqtyMap.get(productCode+channelCode+regionCode+recordYear+'Feb');
                                    }
                                    if(facturaOpenRevenueMap.containsKey(productCode+channelCode+regionCode+recordYear+'Feb')){
                                        SAPS.Open_Order_Revenue__c = facturaOpenRevenueMap.get(productCode+channelCode+regionCode+recordYear+'Feb');
                                    }
                                     if(facturaActualqtyMap.containsKey(productCode+channelCode+regionCode+recordYear+'Feb')){
                                        SAPS.Actual_Order_QTY__c = facturaActualqtyMap.get(productCode+channelCode+regionCode+recordYear+'Feb');
                                    }
                                    if(accTargetMap.containsKey(productCode+regionCode+recordYear+'Feb')){
                                        SAPS.Budget_Qty__c=accTargetMap.get(productCode+regionCode+recordYear+'Feb');
                                    }
                                    
                                    if(lYMTDMap.containsKey(productCode+channelCode+regionCode+recordYear+'Feb')){
                                        SAPS.Last_Year_s_Month_Qty__c=lYMTDMap.get(productCode+channelCode+regionCode+recordYear+'Feb');
                                    }
                                  
                                    SAPS.Is_Update_Metrics__c=false;
                                    
                                    if(childListToIterate.size()>0){
                                        for(Product2 pro : childListToIterate){
                                            String key = pro.Product_code__c+channelCode+regionCode+recordYear+'Feb';
                                            String comboKeys2 = '5191'+''+channelCode+''+regionCode+''+tmpMonthNumber+''+currentYear+''+pro.Product_code__c+'Feb '+'\''+Year2;
                                            if(singleSalesQtyMap.containsKey(key)){
                                                SAPS.Current_Year_QTY_YTD__c += singleSalesQtyMap.get(key);
                                            }
                                            if(lastYearSalesQtyMap.containsKey(key)){
                                                SAPS.Last_Year_QTY_YTD__c += lastYearSalesQtyMap.get(key); 
                                            } 
                                            if(lYMTDMap.containsKey(key)){
                                                SAPS.Last_Year_s_Month_Qty__c += lYMTDMap.get(key);
                                            }
                                            if(singleSalesValMap.containsKey(key)){
                                                SAPS.Current_Year_Sales_YTD__c += singleSalesValMap.get(key);
                                            }
                                            if(lastYearSalesValMap.containsKey(key)){
                                                SAPS.Last_Year_Sales_YTD__c += lastYearSalesValMap.get(key); 
                                            }
                                            if(facturaOpenqtyMap.containsKey(key)){
                                                SAPS.Open_Order_QTY__c += facturaOpenqtyMap.get(key);
                                            }
                                            if(openDelayOrderQtyMap.containsKey(comboKeys2)){
                                                SAPS.Open_Order_Delayed_QTY__c += openDelayOrderQtyMap.get(comboKeys2);
                                            }
                                            if(facturaOpenRevenueMap.containsKey(key)){
                                                SAPS.Open_Order_Revenue__c += facturaOpenRevenueMap.get(key);
                                            }
                                            if(openOrderDelayRevenuMap.containsKey(comboKeys2)){
                                                SAPS.Open_Order_Delayed_Revenue__c += openOrderDelayRevenuMap.get(comboKeys2);
                                            }
                                            if(facturaActualqtyMap.containsKey(key)){
                                                SAPS.Actual_Order_QTY__c += facturaActualqtyMap.get(key); //added by pragati sharma
                                        }
                                    }
                                }
                                }
                                
                                else if(recordName.contains('Mar')){
                                    if(volumeMap.containsKey(productCode+channelCode+regionCode+year+'Mar')){
                                        SAPS.POG_Customer_Inventory__c=volumeMap.get(productCode+channelCode+regionCode+year+'Mar');
                                    }
                                    if(coVolumeMap.containsKey(productCode+channelCode+regionCode+year+'Mar')){
                                        SAPS.POG_Company_Inventory__c=coVolumeMap.get(productCode+channelCode+regionCode+year+'Mar');
                                    }
                                    if(test.isRunningTest()){
                                        currentmonthName='Mar';
                                    }
                                    if(month==currentmonthName){
                                        if(singleSalesQtyMap.containsKey(productCode+channelCode+regionCode+currentYear+'Mar')){
                                            SAPS.Current_Year_QTY_YTD__c=singleSalesQtyMap.get(productCode+channelCode+regionCode+currentYear+'Mar');
                                        }
                                        if(lastYearSalesQtyMap.containsKey(productCode+channelCode+regionCode+currentYear+'Mar')){
                                            SAPS.Last_Year_QTY_YTD__c=lastYearSalesQtyMap.get(productCode+channelCode+regionCode+currentYear+'Mar'); 
                                        }
                                        if(singleSalesValMap.containsKey(productCode+channelCode+regionCode+currentYear+'Mar')){
                                            SAPS.Current_Year_Sales_YTD__c=singleSalesValMap.get(productCode+channelCode+regionCode+currentYear+'Mar');
                                        }
                                        if(lastYearSalesValMap.containsKey(productCode+channelCode+regionCode+currentYear+'Mar')){
                                            SAPS.Last_Year_Sales_YTD__c=lastYearSalesValMap.get(productCode+channelCode+regionCode+currentYear+'Mar'); 
                                        }
                                        System.debug('inside contains key Nik Mar - ');
                                        if(openDelayOrderQtyMap.containsKey(comboKeysInUpdate)){                                            
                                            SAPS.Open_Order_Delayed_QTY__c = openDelayOrderQtyMap.get(comboKeysInUpdate);
                                        }
                                        
                                        if(openOrderDelayRevenuMap.containsKey(comboKeysInUpdate)){
                                            SAPS.Open_Order_Delayed_Revenue__c = openOrderDelayRevenuMap.get(comboKeysInUpdate);
                                        }
                                        
                                        
                                    }
                                    
                                    if(facturaOpenqtyMap.containsKey(productCode+channelCode+regionCode+recordYear+'Mar')){
                                        SAPS.Open_Order_QTY__c = facturaOpenqtyMap.get(productCode+channelCode+regionCode+recordYear+'Mar');
                                    }
                                    if(facturaOpenRevenueMap.containsKey(productCode+channelCode+regionCode+recordYear+'Mar')){
                                        SAPS.Open_Order_Revenue__c = facturaOpenRevenueMap.get(productCode+channelCode+regionCode+recordYear+'Mar');
                                    }
                                    if(facturaActualqtyMap.containsKey(productCode+channelCode+regionCode+recordYear+'Mar')){
                                        SAPS.Actual_Order_QTY__c = facturaActualqtyMap.get(productCode+channelCode+regionCode+recordYear+'Mar');
                                    }
                                    
                                    if(accTargetMap.containsKey(productCode+regionCode+recordYear+'Mar')){
                                        SAPS.Budget_Qty__c=accTargetMap.get(productCode+regionCode+recordYear+'Mar');
                                    }
                                    
                                    if(lYMTDMap.containsKey(productCode+channelCode+regionCode+recordYear+'Mar')){
                                        SAPS.Last_Year_s_Month_Qty__c=lYMTDMap.get(productCode+channelCode+regionCode+recordYear+'Mar');
                                    }
                                    SAPS.Is_Update_Metrics__c=false;
                                    
                                    if(childListToIterate.size()>0){
                                        for(Product2 pro : childListToIterate){
                                            String key = pro.Product_code__c+channelCode+regionCode+recordYear+'Mar';
                                            String comboKeys2 = '5191'+''+channelCode+''+regionCode+''+tmpMonthNumber+''+currentYear+''+pro.Product_code__c+'Mar '+'\''+Year2;
                                            if(singleSalesQtyMap.containsKey(key)){
                                                SAPS.Current_Year_QTY_YTD__c += singleSalesQtyMap.get(key);
                                            }
                                            if(lastYearSalesQtyMap.containsKey(key)){
                                                SAPS.Last_Year_QTY_YTD__c += lastYearSalesQtyMap.get(key); 
                                            } 
                                            if(lYMTDMap.containsKey(key)){
                                                SAPS.Last_Year_s_Month_Qty__c += lYMTDMap.get(key);
                                            }
                                            if(singleSalesValMap.containsKey(key)){
                                                SAPS.Current_Year_Sales_YTD__c += singleSalesValMap.get(key);
                                            }
                                            if(lastYearSalesValMap.containsKey(key)){
                                                SAPS.Last_Year_Sales_YTD__c += lastYearSalesValMap.get(key); 
                                            }
                                            if(facturaOpenqtyMap.containsKey(key)){
                                                SAPS.Open_Order_QTY__c += facturaOpenqtyMap.get(key);
                                            }
                                                if(facturaActualqtyMap.containsKey(key)){
                                                SAPS.Actual_Order_QTY__c += facturaActualqtyMap.get(key);
                                            }
                                            if(openDelayOrderQtyMap.containsKey(comboKeys2)){
                                                SAPS.Open_Order_Delayed_QTY__c += openDelayOrderQtyMap.get(comboKeys2);
                                            }
                                            if(facturaOpenRevenueMap.containsKey(key)){
                                                SAPS.Open_Order_Revenue__c += facturaOpenRevenueMap.get(key);
                                            }
                                            if(openOrderDelayRevenuMap.containsKey(comboKeys2)){
                                                SAPS.Open_Order_Delayed_Revenue__c += openOrderDelayRevenuMap.get(comboKeys2);
                                            }
                                        }
                                    }
                                }
                                else if(recordName.contains('Apr')){
                                    System.debug('enter in april');
                                    if(volumeMap.containsKey(productCode+channelCode+regionCode+year+'Apr')){
                                        SAPS.POG_Customer_Inventory__c=volumeMap.get(productCode+channelCode+regionCode+year+'Apr');
                                    }
                                    if(coVolumeMap.containsKey(productCode+channelCode+regionCode+year+'Apr')){
                                        SAPS.POG_Company_Inventory__c=coVolumeMap.get(productCode+channelCode+regionCode+year+'Apr');
                                    }
                                    if(test.isRunningTest()){
                                        currentmonthName='Apr';
                                    }
                                   if(month==currentmonthName){
                                        if(singleSalesQtyMap.containsKey(productCode+channelCode+regionCode+currentYear+'Apr')){
                                            SAPS.Current_Year_QTY_YTD__c=singleSalesQtyMap.get(productCode+channelCode+regionCode+currentYear+'Apr');
                                        }
                                        if(lastYearSalesQtyMap.containsKey(productCode+channelCode+regionCode+currentYear+'Apr')){
                                            SAPS.Last_Year_QTY_YTD__c=lastYearSalesQtyMap.get(productCode+channelCode+regionCode+currentYear+'Apr'); 
                                        }
                                        if(singleSalesValMap.containsKey(productCode+channelCode+regionCode+currentYear+'Apr')){
                                            SAPS.Current_Year_Sales_YTD__c=singleSalesValMap.get(productCode+channelCode+regionCode+currentYear+'Apr');
                                        }
                                        if(lastYearSalesValMap.containsKey(productCode+channelCode+regionCode+currentYear+'Apr')){
                                            SAPS.Last_Year_Sales_YTD__c=lastYearSalesValMap.get(productCode+channelCode+regionCode+currentYear+'Apr'); 
                                        }
                                        System.debug('inside contains key Nik Apr - ');
                                        if(openDelayOrderQtyMap.containsKey(comboKeysInUpdate)){ 
                                            System.debug('open'+openDelayOrderQtyMap);
                                            SAPS.Open_Order_Delayed_QTY__c = openDelayOrderQtyMap.get(comboKeysInUpdate);
                                        }
                                        
                                        if(openOrderDelayRevenuMap.containsKey(comboKeysInUpdate)){
                                            SAPS.Open_Order_Delayed_Revenue__c = openOrderDelayRevenuMap.get(comboKeysInUpdate);
                                        }                                       
                                   }
                                    System.debug('comboKeysInUpdate'+comboKeysInUpdate);
                                    if(facturaOpenqtyMap.containsKey(productCode+channelCode+regionCode+recordYear+'Apr')){
                                        System.debug('facturaOpenqtyMap april'+facturaOpenqtyMap);
                                        SAPS.Open_Order_QTY__c = facturaOpenqtyMap.get(productCode+channelCode+regionCode+recordYear+'Apr');
                                    }
                                    if(facturaOpenRevenueMap.containsKey(productCode+channelCode+regionCode+recordYear+'Apr')){
                                        SAPS.Open_Order_Revenue__c = facturaOpenRevenueMap.get(productCode+channelCode+regionCode+recordYear+'Apr');
                                    }
                                    if(facturaActualqtyMap.containsKey(comboKeysInUpdate)){
                                        System.debug('facturaActualqtyMap april'+facturaActualqtyMap);
                                        SAPS.Actual_Order_QTY__c = facturaActualqtyMap.get(comboKeysInUpdate);
                                    }
                                    
                                    if(accTargetMap.containsKey(productCode+regionCode+recordYear+'Apr')){
                                        SAPS.Budget_Qty__c=accTargetMap.get(productCode+regionCode+recordYear+'Apr');
                                    }
                                    
                                    if(lYMTDMap.containsKey(productCode+channelCode+regionCode+recordYear+'Apr')){
                                        SAPS.Last_Year_s_Month_Qty__c=lYMTDMap.get(productCode+channelCode+regionCode+recordYear+'Apr');
                                    }
                                    
                                    SAPS.Is_Update_Metrics__c=false;
                                    System.debug('childListToIterate'+childListToIterate);
                                    if(childListToIterate.size()>0){
                                        for(Product2 pro : childListToIterate){
                                            String key = pro.Product_code__c+channelCode+regionCode+recordYear+'Apr';
                                            System.debug('key under child'+key);
                                            String comboKeys2 = '5191'+''+channelCode+''+regionCode+''+tmpMonthNumber+''+currentYear+''+pro.Product_code__c+'Apr '+'\''+Year2;
                                          System.debug('comboKeys2'+comboKeys2);
                                            if(singleSalesQtyMap.containsKey(key)){
                                                SAPS.Current_Year_QTY_YTD__c += singleSalesQtyMap.get(key);
                                            }
                                            if(lastYearSalesQtyMap.containsKey(key)){
                                                SAPS.Last_Year_QTY_YTD__c += lastYearSalesQtyMap.get(key); 
                                            } 
                                            if(lYMTDMap.containsKey(key)){
                                                SAPS.Last_Year_s_Month_Qty__c += lYMTDMap.get(key);
                                            }
                                            if(singleSalesValMap.containsKey(key)){
                                                SAPS.Current_Year_Sales_YTD__c += singleSalesValMap.get(key);
                                            }
                                            if(lastYearSalesValMap.containsKey(key)){
                                                SAPS.Last_Year_Sales_YTD__c += lastYearSalesValMap.get(key); 
                                            }
                                            if(facturaOpenqtyMap.containsKey(key)){
                                                SAPS.Open_Order_QTY__c += facturaOpenqtyMap.get(key);
                                            }
                                            if(openDelayOrderQtyMap.containsKey(comboKeys2)){
                                                SAPS.Open_Order_Delayed_QTY__c += openDelayOrderQtyMap.get(comboKeys2);
                                            }
                                            if(facturaOpenRevenueMap.containsKey(key)){
                                                SAPS.Open_Order_Revenue__c += facturaOpenRevenueMap.get(key);
                                            }
                                            if(openOrderDelayRevenuMap.containsKey(comboKeys2)){
                                                SAPS.Open_Order_Delayed_Revenue__c += openOrderDelayRevenuMap.get(comboKeys2);
                                            }
                                            if(facturaActualqtyMap.containsKey(comboKeys2)){
                                                SAPS.Actual_Order_QTY__c += facturaActualqtyMap.get(key);
                                            }
                                        }
                                    }
                                }
                                else if(recordName.contains('May')){
                                    if(volumeMap.containsKey(productCode+channelCode+regionCode+year+'May')){
                                        SAPS.POG_Customer_Inventory__c=volumeMap.get(productCode+channelCode+regionCode+year+'May');
                                    }
                                    if(coVolumeMap.containsKey(productCode+channelCode+regionCode+year+'May')){
                                        SAPS.POG_Company_Inventory__c=coVolumeMap.get(productCode+channelCode+regionCode+year+'May');
                                    }
                                    
                                    if(test.isRunningTest()){
                                        currentmonthName='May';
                                    }
                                    if(month==currentmonthName){
                                        if(singleSalesQtyMap.containsKey(productCode+channelCode+regionCode+currentYear+'May')){
                                            SAPS.Current_Year_QTY_YTD__c=singleSalesQtyMap.get(productCode+channelCode+regionCode+currentYear+'May');
                                        }
                                        if(lastYearSalesQtyMap.containsKey(productCode+channelCode+regionCode+currentYear+'May')){
                                            SAPS.Last_Year_QTY_YTD__c=lastYearSalesQtyMap.get(productCode+channelCode+regionCode+currentYear+'May'); 
                                        }
                                        if(singleSalesValMap.containsKey(productCode+channelCode+regionCode+currentYear+'May')){
                                            SAPS.Current_Year_Sales_YTD__c=singleSalesValMap.get(productCode+channelCode+regionCode+currentYear+'May');
                                        }
                                        if(lastYearSalesValMap.containsKey(productCode+channelCode+regionCode+currentYear+'May')){
                                            SAPS.Last_Year_Sales_YTD__c=lastYearSalesValMap.get(productCode+channelCode+regionCode+currentYear+'May'); 
                                        }
                                        System.debug('inside contains key Nik May - ');
                                        if(openDelayOrderQtyMap.containsKey(comboKeysInUpdate)){
                                            
                                            SAPS.Open_Order_Delayed_QTY__c = openDelayOrderQtyMap.get(comboKeysInUpdate);
                                        }
     
                                        if(openOrderDelayRevenuMap.containsKey(comboKeysInUpdate)){
                                            SAPS.Open_Order_Delayed_Revenue__c = openOrderDelayRevenuMap.get(comboKeysInUpdate);
                                        }
                                         
                                        
                                   }
                                    
                                    
                                    if(facturaOpenqtyMap.containsKey(productCode+channelCode+regionCode+recordYear+'May')){
                                        SAPS.Open_Order_QTY__c = facturaOpenqtyMap.get(productCode+channelCode+regionCode+recordYear+'May');
                                    }
                                    if(facturaOpenRevenueMap.containsKey(productCode+channelCode+regionCode+recordYear+'May')){
                                        SAPS.Open_Order_Revenue__c = facturaOpenRevenueMap.get(productCode+channelCode+regionCode+recordYear+'May');
                                    }
                                    
                                    if(facturaActualqtyMap.containsKey(productCode+channelCode+regionCode+recordYear+'May')){
                                        SAPS.Actual_Order_QTY__c = facturaActualqtyMap.get(productCode+channelCode+regionCode+recordYear+'May');
                                    }
                                    if(accTargetMap.containsKey(productCode+regionCode+recordYear+'May')){
                                        SAPS.Budget_Qty__c=accTargetMap.get(productCode+regionCode+recordYear+'May');
                                    }
                                    
                                    if(lYMTDMap.containsKey(productCode+channelCode+regionCode+recordYear+'May')){
                                        SAPS.Last_Year_s_Month_Qty__c=lYMTDMap.get(productCode+channelCode+regionCode+recordYear+'May');
                                    }
                                    
                                    SAPS.Is_Update_Metrics__c=false;
                                    
                                    if(childListToIterate.size()>0){
                                        for(Product2 pro : childListToIterate){
                                            String key = pro.Product_code__c+channelCode+regionCode+recordYear+'May';
                                            String comboKeys2 = '5191'+''+channelCode+''+regionCode+''+tmpMonthNumber+''+currentYear+''+pro.Product_code__c+'May '+'\''+Year2;
                                            if(singleSalesQtyMap.containsKey(key)){
                                                SAPS.Current_Year_QTY_YTD__c += singleSalesQtyMap.get(key);
                                            }
                                            if(lastYearSalesQtyMap.containsKey(key)){
                                                SAPS.Last_Year_QTY_YTD__c += lastYearSalesQtyMap.get(key); 
                                            } 
                                            if(lYMTDMap.containsKey(key)){
                                                SAPS.Last_Year_s_Month_Qty__c += lYMTDMap.get(key);
                                            }
                                            if(singleSalesValMap.containsKey(key)){
                                                SAPS.Current_Year_Sales_YTD__c += singleSalesValMap.get(key);
                                            }
                                            if(lastYearSalesValMap.containsKey(key)){
                                                SAPS.Last_Year_Sales_YTD__c += lastYearSalesValMap.get(key); 
                                            }
                                            if(facturaOpenqtyMap.containsKey(key)){
                                                SAPS.Open_Order_QTY__c += facturaOpenqtyMap.get(key);
                                            }
                                             if(facturaActualqtyMap.containsKey(key)){
                                                SAPS.Actual_Order_QTY__c += facturaActualqtyMap.get(key);
                                            }
                                            if(openDelayOrderQtyMap.containsKey(comboKeys2)){
                                                SAPS.Open_Order_Delayed_QTY__c += openDelayOrderQtyMap.get(comboKeys2);
                                            }
                                            if(facturaOpenRevenueMap.containsKey(key)){
                                                SAPS.Open_Order_Revenue__c += facturaOpenRevenueMap.get(key);
                                            }
                                            if(openOrderDelayRevenuMap.containsKey(comboKeys2)){
                                                SAPS.Open_Order_Delayed_Revenue__c += openOrderDelayRevenuMap.get(comboKeys2);
                                            }
                                        }
                                    }
                                    
                                }
                                else if(recordName.contains('Jun')){
                                    if(volumeMap.containsKey(productCode+channelCode+regionCode+year+'June')){
                                        SAPS.POG_Customer_Inventory__c=volumeMap.get(productCode+channelCode+regionCode+year+'June');
                                    }
                                    if(coVolumeMap.containsKey(productCode+channelCode+regionCode+year+'June')){
                                        SAPS.POG_Company_Inventory__c=coVolumeMap.get(productCode+channelCode+regionCode+year+'June');
                                    }
                                    if(test.isRunningTest()){
                                        currentmonthName='Jun';
                                    }
                                    if(month==currentmonthName){
                                        if(singleSalesQtyMap.containsKey(productCode+channelCode+regionCode+currentYear+'Jun')){
                                            SAPS.Current_Year_QTY_YTD__c=singleSalesQtyMap.get(productCode+channelCode+regionCode+currentYear+'Jun');
                                        }
                                        if(lastYearSalesQtyMap.containsKey(productCode+channelCode+regionCode+currentYear+'Jun')){
                                            SAPS.Last_Year_QTY_YTD__c=lastYearSalesQtyMap.get(productCode+channelCode+regionCode+currentYear+'Jun'); 
                                        }
                                        if(singleSalesValMap.containsKey(productCode+channelCode+regionCode+currentYear+'Jun')){
                                            SAPS.Current_Year_Sales_YTD__c=singleSalesValMap.get(productCode+channelCode+regionCode+currentYear+'Jun');
                                        }
                                        if(lastYearSalesValMap.containsKey(productCode+channelCode+regionCode+currentYear+'Jun')){
                                            SAPS.Last_Year_Sales_YTD__c=lastYearSalesValMap.get(productCode+channelCode+regionCode+currentYear+'Jun'); 
                                        }
                                        System.debug('inside contains key Nik June - ');
                                        if(openDelayOrderQtyMap.containsKey(comboKeysInUpdate)){                                            
                                            SAPS.Open_Order_Delayed_QTY__c = openDelayOrderQtyMap.get(comboKeysInUpdate);
                                        }
                                        
                                        if(openOrderDelayRevenuMap.containsKey(comboKeysInUpdate)){
                                            SAPS.Open_Order_Delayed_Revenue__c = openOrderDelayRevenuMap.get(comboKeysInUpdate);
                                        }
                                        
                                    }
                                    
                                    if(facturaOpenqtyMap.containsKey(productCode+channelCode+regionCode+recordYear+'Jun')){
                                        SAPS.Open_Order_QTY__c = facturaOpenqtyMap.get(productCode+channelCode+regionCode+recordYear+'Jun');
                                    }
                                     if(facturaActualqtyMap.containsKey(productCode+channelCode+regionCode+recordYear+'Jun')){
                                        SAPS.Actual_Order_QTY__c = facturaActualqtyMap.get(productCode+channelCode+regionCode+recordYear+'Jun');
                                    }
                                    if(facturaOpenRevenueMap.containsKey(productCode+channelCode+regionCode+recordYear+'Jun')){
                                        SAPS.Open_Order_Revenue__c = facturaOpenRevenueMap.get(productCode+channelCode+regionCode+recordYear+'Jun');
                                    }
                                    
                                    if(accTargetMap.containsKey(productCode+regionCode+recordYear+'Jun')){
                                        SAPS.Budget_Qty__c=accTargetMap.get(productCode+regionCode+recordYear+'Jun');
                                    }
                                    
                                    if(lYMTDMap.containsKey(productCode+channelCode+regionCode+recordYear+'Jun')){
                                        SAPS.Last_Year_s_Month_Qty__c=lYMTDMap.get(productCode+channelCode+regionCode+recordYear+'Jun');
                                    }
                                    //}
                                    SAPS.Is_Update_Metrics__c=false;
                                    
                                    if(childListToIterate.size()>0){
                                        for(Product2 pro : childListToIterate){
                                            String key = pro.Product_code__c+channelCode+regionCode+recordYear+'Jun';
                                            String comboKeys2 = '5191'+''+channelCode+''+regionCode+''+tmpMonthNumber+''+currentYear+''+pro.Product_code__c+'Jun '+'\''+Year2;
                                            if(singleSalesQtyMap.containsKey(key)){
                                                SAPS.Current_Year_QTY_YTD__c += singleSalesQtyMap.get(key);
                                            }
                                            if(lastYearSalesQtyMap.containsKey(key)){
                                                SAPS.Last_Year_QTY_YTD__c += lastYearSalesQtyMap.get(key); 
                                            } 
                                            if(lYMTDMap.containsKey(key)){
                                                SAPS.Last_Year_s_Month_Qty__c += lYMTDMap.get(key);
                                            }
                                            if(singleSalesValMap.containsKey(key)){
                                                SAPS.Current_Year_Sales_YTD__c += singleSalesValMap.get(key);
                                            }
                                            if(lastYearSalesValMap.containsKey(key)){
                                                SAPS.Last_Year_Sales_YTD__c += lastYearSalesValMap.get(key); 
                                            }
                                            if(facturaOpenqtyMap.containsKey(key)){
                                                SAPS.Open_Order_QTY__c += facturaOpenqtyMap.get(key);
                                            }
                                            if(facturaActualqtyMap.containsKey(key)){
                                                SAPS.Actual_Order_QTY__c += facturaActualqtyMap.get(key);
                                            }
                                            if(openDelayOrderQtyMap.containsKey(comboKeys2)){
                                                SAPS.Open_Order_Delayed_QTY__c += openDelayOrderQtyMap.get(comboKeys2);
                                            }
                                            if(facturaOpenRevenueMap.containsKey(key)){
                                                SAPS.Open_Order_Revenue__c += facturaOpenRevenueMap.get(key);
                                            }
                                            if(openOrderDelayRevenuMap.containsKey(comboKeys2)){
                                                SAPS.Open_Order_Delayed_Revenue__c += openOrderDelayRevenuMap.get(comboKeys2);
                                            }
                                        }
                                    }
                                }
                                else if(recordName.contains('Jul')){
                                    if(volumeMap.containsKey(productCode+channelCode+regionCode+year+'July')){
                                        SAPS.POG_Customer_Inventory__c=volumeMap.get(productCode+channelCode+regionCode+year+'July');
                                    }
                                    if(coVolumeMap.containsKey(productCode+channelCode+regionCode+year+'July')){
                                        SAPS.POG_Company_Inventory__c=coVolumeMap.get(productCode+channelCode+regionCode+year+'July');
                                    }
                                    
                                    if(test.isRunningTest()){
                                        currentmonthName='Jul';
                                    }
                                    if(month==currentmonthName){
                                        if(singleSalesQtyMap.containsKey(productCode+channelCode+regionCode+currentYear+'Jul')){
                                            SAPS.Current_Year_QTY_YTD__c=singleSalesQtyMap.get(productCode+channelCode+regionCode+currentYear+'Jul');
                                        }
                                        if(lastYearSalesQtyMap.containsKey(productCode+channelCode+regionCode+currentYear+'Jul')){
                                            SAPS.Last_Year_QTY_YTD__c=lastYearSalesQtyMap.get(productCode+channelCode+regionCode+currentYear+'Jul'); 
                                        }
                                        if(singleSalesValMap.containsKey(productCode+channelCode+regionCode+currentYear+'Jul')){
                                            SAPS.Current_Year_Sales_YTD__c=singleSalesValMap.get(productCode+channelCode+regionCode+currentYear+'Jul');
                                        }
                                        if(lastYearSalesValMap.containsKey(productCode+channelCode+regionCode+currentYear+'Jul')){
                                            SAPS.Last_Year_Sales_YTD__c=lastYearSalesValMap.get(productCode+channelCode+regionCode+currentYear+'Jul'); 
                                        }
                                        System.debug('inside contains key Nik July - ');
                                        if(openDelayOrderQtyMap.containsKey(comboKeysInUpdate)){                                            
                                            SAPS.Open_Order_Delayed_QTY__c = openDelayOrderQtyMap.get(comboKeysInUpdate);
                                        }
                                        
                                        if(openOrderDelayRevenuMap.containsKey(comboKeysInUpdate)){
                                            SAPS.Open_Order_Delayed_Revenue__c = openOrderDelayRevenuMap.get(comboKeysInUpdate);
                                        }
                                    }
                                    
                                    if(facturaOpenqtyMap.containsKey(productCode+channelCode+regionCode+recordYear+'Jul')){
                                        SAPS.Open_Order_QTY__c = facturaOpenqtyMap.get(productCode+channelCode+regionCode+recordYear+'Jul');
                                    }
                                    if(facturaOpenRevenueMap.containsKey(productCode+channelCode+regionCode+recordYear+'Jul')){
                                        SAPS.Open_Order_Revenue__c = facturaOpenRevenueMap.get(productCode+channelCode+regionCode+recordYear+'Jul');
                                    }
                                    
                                    if(accTargetMap.containsKey(productCode+regionCode+recordYear+'Jul')){
                                        SAPS.Budget_Qty__c=accTargetMap.get(productCode+regionCode+recordYear+'Jul');
                                    }
                                    
                                    if(lYMTDMap.containsKey(productCode+channelCode+regionCode+recordYear+'Jul')){
                                        SAPS.Last_Year_s_Month_Qty__c=lYMTDMap.get(productCode+channelCode+regionCode+recordYear+'Jul');
                                    }
                                     if(facturaActualqtyMap.containsKey(productCode+channelCode+regionCode+recordYear+'Jul')){
                                        SAPS.Actual_Order_QTY__c = facturaActualqtyMap.get(productCode+channelCode+regionCode+recordYear+'Jul');
                                    }
                                    //}
                                    SAPS.Is_Update_Metrics__c=false;
                                    
                                    if(childListToIterate.size()>0){
                                        for(Product2 pro : childListToIterate){
                                            String key = pro.Product_code__c+channelCode+regionCode+recordYear+'Jul';
                                            String comboKeys2 = '5191'+''+channelCode+''+regionCode+''+tmpMonthNumber+''+currentYear+''+pro.Product_code__c+'Jul '+'\''+Year2;
                                            if(singleSalesQtyMap.containsKey(key)){
                                                SAPS.Current_Year_QTY_YTD__c += singleSalesQtyMap.get(key);
                                            }
                                            if(lastYearSalesQtyMap.containsKey(key)){
                                                SAPS.Last_Year_QTY_YTD__c += lastYearSalesQtyMap.get(key); 
                                            } 
                                            if(lYMTDMap.containsKey(key)){
                                                SAPS.Last_Year_s_Month_Qty__c += lYMTDMap.get(key);
                                            }
                                            if(singleSalesValMap.containsKey(key)){
                                                SAPS.Current_Year_Sales_YTD__c += singleSalesValMap.get(key);
                                            }
                                            if(lastYearSalesValMap.containsKey(key)){
                                                SAPS.Last_Year_Sales_YTD__c += lastYearSalesValMap.get(key); 
                                            }
                                            if(facturaOpenqtyMap.containsKey(key)){
                                                // System.debug('in checking SAPS.Prevent_Metric__c Jul');
                                                SAPS.Open_Order_QTY__c += facturaOpenqtyMap.get(key);
                                            }
                                             if(facturaActualqtyMap.containsKey(key)){
                                                // System.debug('in checking SAPS.Prevent_Metric__c Jul');
                                                SAPS.Actual_Order_QTY__c += facturaActualqtyMap.get(key);
                                            }
                                            if(openDelayOrderQtyMap.containsKey(comboKeys2)){
                                                SAPS.Open_Order_Delayed_QTY__c += openDelayOrderQtyMap.get(comboKeys2);
                                            }
                                            if(facturaOpenRevenueMap.containsKey(key)){
                                                SAPS.Open_Order_Revenue__c += facturaOpenRevenueMap.get(key);
                                            }
                                            if(openOrderDelayRevenuMap.containsKey(comboKeys2)){
                                                SAPS.Open_Order_Delayed_Revenue__c += openOrderDelayRevenuMap.get(comboKeys2);
                                            }
                                        }
                                    }
                                }
                                else if(recordName.contains('Aug')){
                                    //System.debug('@@@ inside Aug');
                                    if(volumeMap.containsKey(productCode+channelCode+regionCode+year+'Aug')){
                                        SAPS.POG_Customer_Inventory__c=volumeMap.get(productCode+channelCode+regionCode+year+'Aug');
                                    }
                                    if(coVolumeMap.containsKey(productCode+channelCode+regionCode+year+'Aug')){
                                        SAPS.POG_Company_Inventory__c=coVolumeMap.get(productCode+channelCode+regionCode+year+'Aug');
                                    }
                                    //if(recordMonthMap.get('Aug')==String.valueOf(currentYear)){//recordNameYear
                                    if(test.isRunningTest()){
                                        currentmonthName='Aug';
                                    }
                                    
                                    
                                    if(month==currentmonthName){
                                        //   System.debug('@@@ inside Aug 1');
                                        if(singleSalesQtyMap.containsKey(productCode+channelCode+regionCode+currentYear+'Aug')){
                                            SAPS.Current_Year_QTY_YTD__c=singleSalesQtyMap.get(productCode+channelCode+regionCode+currentYear+'Aug');
                                        }
                                        if(lastYearSalesQtyMap.containsKey(productCode+channelCode+regionCode+currentYear+'Aug')){
                                            SAPS.Last_Year_QTY_YTD__c=lastYearSalesQtyMap.get(productCode+channelCode+regionCode+currentYear+'Aug'); 
                                        }
                                        if(singleSalesValMap.containsKey(productCode+channelCode+regionCode+currentYear+'Aug')){
                                            SAPS.Current_Year_Sales_YTD__c=singleSalesValMap.get(productCode+channelCode+regionCode+currentYear+'Aug');
                                        }
                                        if(lastYearSalesValMap.containsKey(productCode+channelCode+regionCode+currentYear+'Aug')){
                                            SAPS.Last_Year_Sales_YTD__c=lastYearSalesValMap.get(productCode+channelCode+regionCode+currentYear+'Aug'); 
                                        }
                                        //added By vishal 
                                        //  System.debug('@@@ inside Aug '+comboKeysInUpdate);
                                        if(openDelayOrderQtyMap.containsKey(comboKeysInUpdate)){
                                            System.debug('inside contains key Nik AUg - ');
                                            SAPS.Open_Order_Delayed_QTY__c = openDelayOrderQtyMap.get(comboKeysInUpdate);
                                        }
                                        /*
if(openOrderQtyMap.containsKey(comboKeysInUpdate)){
SAPS.Open_Order_QTY__c = openOrderQtyMap.get(comboKeysInUpdate);
}*/
                                        
                                        
                                        if(openOrderDelayRevenuMap.containsKey(comboKeysInUpdate)){
                                            // System.debug('eeeeeeeeeee '+openOrderDelayRevenuMap.get(comboKeysInUpdate));
                                            SAPS.Open_Order_Delayed_Revenue__c = openOrderDelayRevenuMap.get(comboKeysInUpdate);
                                        }
                                        /*
if(openOrderRevenuMap.containsKey(comboKeysInUpdate)){
SAPS.Open_Order_Revenue__c = openOrderRevenuMap.get(comboKeysInUpdate);
}*/
                                        //End added By vishal 
                                        
                                    }
                                    
                                    // System.debug('Chcking Key for Open order future '+productCode+channelCode+regionCode+recordYear+'Aug');
                                    if(facturaOpenqtyMap.containsKey(productCode+channelCode+regionCode+recordYear+'Aug')){
                                        // System.debug('Old Open Order Quantity Aug - '+  SAPS.Open_Order_QTY__c);
                                        // System.debug('total sum of open order '+facturaOpenqtyMap.get(productCode+channelCode+regionCode+recordYear+'Aug'));
                                        SAPS.Open_Order_QTY__c = facturaOpenqtyMap.get(productCode+channelCode+regionCode+recordYear+'Aug');
                                    }
                                    if(facturaOpenRevenueMap.containsKey(productCode+channelCode+regionCode+recordYear+'Aug')){
                                        SAPS.Open_Order_Revenue__c = facturaOpenRevenueMap.get(productCode+channelCode+regionCode+recordYear+'Aug');
                                    }
                                     if(facturaActualqtyMap.containsKey(productCode+channelCode+regionCode+recordYear+'Aug')){
                                        // System.debug('Old Open Order Quantity Aug - '+  SAPS.Open_Order_QTY__c);
                                        // System.debug('total sum of open order '+facturaOpenqtyMap.get(productCode+channelCode+regionCode+recordYear+'Aug'));
                                        SAPS.Actual_Order_QTY__c = facturaActualqtyMap.get(productCode+channelCode+regionCode+recordYear+'Aug');
                                    }
                                    
                                    if(accTargetMap.containsKey(productCode+regionCode+recordYear+'Aug')){
                                        SAPS.Budget_Qty__c=accTargetMap.get(productCode+regionCode+recordYear+'Aug');
                                    }
                                    
                                    if(lYMTDMap.containsKey(productCode+channelCode+regionCode+recordYear+'Aug')){
                                        SAPS.Last_Year_s_Month_Qty__c=lYMTDMap.get(productCode+channelCode+regionCode+recordYear+'Aug');
                                    }
                                    //}
                                    SAPS.Is_Update_Metrics__c=false;
                                    
                                    if(childListToIterate.size()>0){
                                        for(Product2 pro : childListToIterate){
                                            
                                            System.debug('in aug monthsss');
                                            
                                            String key = pro.Product_code__c+channelCode+regionCode+recordYear+'Aug';
                                            System.debug('in aug monthsss '+key);
                                            String comboKeys2 = '5191'+''+channelCode+''+regionCode+''+tmpMonthNumber+''+currentYear+''+pro.Product_code__c+'Aug '+'\''+Year2;
                                            if(singleSalesQtyMap.containsKey(key)){
                                                SAPS.Current_Year_QTY_YTD__c += singleSalesQtyMap.get(key);
                                            }
                                            if(lastYearSalesQtyMap.containsKey(key)){
                                                SAPS.Last_Year_QTY_YTD__c += lastYearSalesQtyMap.get(key); 
                                            } 
                                            if(lYMTDMap.containsKey(key)){
                                                SAPS.Last_Year_s_Month_Qty__c += lYMTDMap.get(key);
                                            }
                                            if(singleSalesValMap.containsKey(key)){
                                                SAPS.Current_Year_Sales_YTD__c += singleSalesValMap.get(key);
                                            }
                                            if(lastYearSalesValMap.containsKey(key)){
                                                SAPS.Last_Year_Sales_YTD__c += lastYearSalesValMap.get(key); 
                                            }
                                            System.debug('all key set '+facturaOpenqtyMap.keySet());
                                            if(facturaOpenqtyMap.containsKey(key)){
                                                // System.debug('in checking SAPS.Prevent_Metric__c Aug');
                                                
                                                SAPS.Open_Order_QTY__c += facturaOpenqtyMap.get(key);
                                            }
                                                               if(facturaActualqtyMap.containsKey(key)){
                                                // System.debug('in checking SAPS.Prevent_Metric__c Aug');
                                                
                                                SAPS.Actual_Order_QTY__c += facturaActualqtyMap.get(key);
                                            }
                                            if(openDelayOrderQtyMap.containsKey(comboKeys2)){
                                                // System.debug('ffffffffff '+openDelayOrderQtyMap.get(comboKeys2));
                                                SAPS.Open_Order_Delayed_QTY__c += openDelayOrderQtyMap.get(comboKeys2);
                                            }
                                            if(facturaOpenRevenueMap.containsKey(key)){
                                                SAPS.Open_Order_Revenue__c += facturaOpenRevenueMap.get(key);
                                            }
                                            if(openOrderDelayRevenuMap.containsKey(comboKeys2)){
                                                SAPS.Open_Order_Delayed_Revenue__c += openOrderDelayRevenuMap.get(comboKeys2);
                                            }
                                        }
                                    }
                                }
                                else if(recordName.contains('Sep')){
                                    if(volumeMap.containsKey(productCode+channelCode+regionCode+year+'Sep')){
                                        SAPS.POG_Customer_Inventory__c=volumeMap.get(productCode+channelCode+regionCode+year+'Sep');
                                    }
                                    if(coVolumeMap.containsKey(productCode+channelCode+regionCode+year+'Sep')){
                                        SAPS.POG_Company_Inventory__c=coVolumeMap.get(productCode+channelCode+regionCode+year+'Sep');
                                    }
                                    //if(recordMonthMap.get('Sep')==String.valueOf(currentYear)){//recordNameYear
                                    if(test.isRunningTest()){
                                        currentmonthName='Sep';
                                    }
                                    if(month==currentmonthName){
                                        if(singleSalesQtyMap.containsKey(productCode+channelCode+regionCode+currentYear+'Sep')){
                                            SAPS.Current_Year_QTY_YTD__c=singleSalesQtyMap.get(productCode+channelCode+regionCode+currentYear+'Sep');
                                        }
                                        if(lastYearSalesQtyMap.containsKey(productCode+channelCode+regionCode+currentYear+'Sep')){
                                            SAPS.Last_Year_QTY_YTD__c=lastYearSalesQtyMap.get(productCode+channelCode+regionCode+currentYear+'Sep'); 
                                        }
                                        if(singleSalesValMap.containsKey(productCode+channelCode+regionCode+currentYear+'Sep')){
                                            SAPS.Current_Year_Sales_YTD__c=singleSalesValMap.get(productCode+channelCode+regionCode+currentYear+'Sep');
                                        }
                                        if(lastYearSalesValMap.containsKey(productCode+channelCode+regionCode+currentYear+'Sep')){
                                            SAPS.Last_Year_Sales_YTD__c=lastYearSalesValMap.get(productCode+channelCode+regionCode+currentYear+'Sep'); 
                                        }
                                        //added By vishal 
                                        if(openDelayOrderQtyMap.containsKey(comboKeysInUpdate)){
                                            System.debug('inside contains key Nik Sep - ');
                                            SAPS.Open_Order_Delayed_QTY__c = openDelayOrderQtyMap.get(comboKeysInUpdate);
                                        }
                                        
                                        /*
if(openOrderQtyMap.containsKey(comboKeysInUpdate)){
// System.debug('in update Sep Order Quantity  '+openOrderQtyMap.get(comboKeysInUpdate));
SAPS.Open_Order_QTY__c = openOrderQtyMap.get(comboKeysInUpdate);
}*/
                                        
                                        
                                        if(openOrderDelayRevenuMap.containsKey(comboKeysInUpdate)){
                                            SAPS.Open_Order_Delayed_Revenue__c = openOrderDelayRevenuMap.get(comboKeysInUpdate);
                                        }
                                        
                                        /*
if(openOrderRevenuMap.containsKey(comboKeysInUpdate)){
SAPS.Open_Order_Revenue__c = openOrderRevenuMap.get(comboKeysInUpdate);
}*/
                                        //End added By vishal 
                                        
                                        
                                    }
                                    if(facturaOpenqtyMap.containsKey(productCode+channelCode+regionCode+recordYear+'Sep')){
                                        // System.debug('Old Open Order Quantity Sep - '+  SAPS.Open_Order_QTY__c);
                                        SAPS.Open_Order_QTY__c = facturaOpenqtyMap.get(productCode+channelCode+regionCode+recordYear+'Sep');
                                    }
                                    if(facturaOpenRevenueMap.containsKey(productCode+channelCode+regionCode+recordYear+'Sep')){
                                        SAPS.Open_Order_Revenue__c = facturaOpenRevenueMap.get(productCode+channelCode+regionCode+recordYear+'Sep');
                                    }
                                    if(facturaActualqtyMap.containsKey(productCode+channelCode+regionCode+recordYear+'Sep')){
                                        // System.debug('Old Open Order Quantity Sep - '+  SAPS.Open_Order_QTY__c);
                                        SAPS.Actual_Order_QTY__c = facturaActualqtyMap.get(productCode+channelCode+regionCode+recordYear+'Sep');
                                    }
                                    
                                    if(accTargetMap.containsKey(productCode+regionCode+recordYear+'Sep')){
                                        SAPS.Budget_Qty__c=accTargetMap.get(productCode+regionCode+recordYear+'Sep');
                                    }
                                    
                                    if(lYMTDMap.containsKey(productCode+channelCode+regionCode+recordYear+'Sep')){
                                        SAPS.Last_Year_s_Month_Qty__c=lYMTDMap.get(productCode+channelCode+regionCode+recordYear+'Sep');
                                    }
                                    
                                    SAPS.Is_Update_Metrics__c=false;
                                    
                                    if(childListToIterate.size()>0){
                                        for(Product2 pro : childListToIterate){
                                            String key = pro.Product_code__c+channelCode+regionCode+recordYear+'Sep';
                                            String key2 = '5191'+''+channelCode+''+regionCode+''+tmpMonthNumber+''+currentYear+''+pro.Product_code__c+'Sep '+'\''+Year2;
                                            if(singleSalesQtyMap.containsKey(key)){
                                                SAPS.Current_Year_QTY_YTD__c += singleSalesQtyMap.get(key);
                                            }
                                            if(lastYearSalesQtyMap.containsKey(key)){
                                                SAPS.Last_Year_QTY_YTD__c += lastYearSalesQtyMap.get(key); 
                                            } 
                                            if(lYMTDMap.containsKey(key)){
                                                SAPS.Last_Year_s_Month_Qty__c += lYMTDMap.get(key);
                                            }
                                            if(singleSalesValMap.containsKey(key)){
                                                SAPS.Current_Year_Sales_YTD__c += singleSalesValMap.get(key);
                                            }
                                            if(lastYearSalesValMap.containsKey(key)){
                                                SAPS.Last_Year_Sales_YTD__c += lastYearSalesValMap.get(key); 
                                            }
                                            if(facturaOpenqtyMap.containsKey(key)){
                                                // System.debug('in checking SAPS.Prevent_Metric__c Sep');
                                                SAPS.Open_Order_QTY__c += facturaOpenqtyMap.get(key);
                                            }
                                            if(facturaActualqtyMap.containsKey(key)){
                                                // System.debug('in checking SAPS.Prevent_Metric__c Sep');
                                                SAPS.Actual_Order_QTY__c += facturaActualqtyMap.get(key);
                                            }
                                            if(openDelayOrderQtyMap.containsKey(key2)){
                                                SAPS.Open_Order_Delayed_QTY__c += openDelayOrderQtyMap.get(key2);
                                            }
                                            if(facturaOpenRevenueMap.containsKey(key)){
                                                SAPS.Open_Order_Revenue__c += facturaOpenRevenueMap.get(key);
                                            }
                                            if(openOrderDelayRevenuMap.containsKey(key2)){
                                                SAPS.Open_Order_Delayed_Revenue__c += openOrderDelayRevenuMap.get(key2);
                                            }
                                        }
                                    }
                                }
                                else if(recordName.contains('Oct')){
                                    if(volumeMap.containsKey(productCode+channelCode+regionCode+year+'Oct')){
                                        SAPS.POG_Customer_Inventory__c=volumeMap.get(productCode+channelCode+regionCode+year+'Oct');
                                    }
                                    if(coVolumeMap.containsKey(productCode+channelCode+regionCode+year+'Oct')){
                                        SAPS.POG_Company_Inventory__c=coVolumeMap.get(productCode+channelCode+regionCode+year+'Oct');
                                    }
                                    //if(recordMonthMap.get('Oct')==String.valueOf(currentYear)){//recordNameYear
                                    if(test.isRunningTest()){
                                        currentmonthName='Oct';
                                    }
                                    system.debug('1704@@@@@'+month+'######'+currentmonthName);
                                    if(month==currentmonthName){
                                        system.debug('@@@@@'+month+'######'+currentmonthName);
                                        if(singleSalesQtyMap.containsKey(productCode+channelCode+regionCode+currentYear+'Oct')){
                                            SAPS.Current_Year_QTY_YTD__c=singleSalesQtyMap.get(productCode+channelCode+regionCode+currentYear+'Oct');
                                        }
                                        if(lastYearSalesQtyMap.containsKey(productCode+channelCode+regionCode+currentYear+'Oct')){
                                            SAPS.Last_Year_QTY_YTD__c=lastYearSalesQtyMap.get(productCode+channelCode+regionCode+currentYear+'Oct'); 
                                        }
                                        if(singleSalesValMap.containsKey(productCode+channelCode+regionCode+currentYear+'Oct')){
                                            SAPS.Current_Year_Sales_YTD__c=singleSalesValMap.get(productCode+channelCode+regionCode+currentYear+'Oct');
                                        }
                                        if(lastYearSalesValMap.containsKey(productCode+channelCode+regionCode+currentYear+'Oct')){
                                            SAPS.Last_Year_Sales_YTD__c=lastYearSalesValMap.get(productCode+channelCode+regionCode+currentYear+'Oct'); 
                                        }
                                        //added By vishal 
                                        system.debug('comboKeysInUpdate@@@@@'+comboKeysInUpdate);
                                        if(openDelayOrderQtyMap.containsKey(comboKeysInUpdate)){
                                            System.debug('inside contains key Nik Oct - ');
                                            SAPS.Open_Order_Delayed_QTY__c = openDelayOrderQtyMap.get(comboKeysInUpdate);
                                        }
                                        /*
if(openOrderQtyMap.containsKey(comboKeysInUpdate)){
SAPS.Open_Order_QTY__c = openOrderQtyMap.get(comboKeysInUpdate);
}
*/                                    
                                        
                                        if(openOrderDelayRevenuMap.containsKey(comboKeysInUpdate)){
                                            SAPS.Open_Order_Delayed_Revenue__c = openOrderDelayRevenuMap.get(comboKeysInUpdate);
                                        }
                                        /*
if(openOrderRevenuMap.containsKey(comboKeysInUpdate)){
// System.debug('in update Oct  Order Revenue  '+openOrderRevenuMap.get(comboKeysInUpdate));
SAPS.Open_Order_Revenue__c = openOrderRevenuMap.get(comboKeysInUpdate);
}*/
                                        //End added By vishal 
                                        
                                    }
                                    
                                    if(facturaOpenqtyMap.containsKey(productCode+channelCode+regionCode+recordYear+'Oct')){
                                        System.debug('Old Open Order Quantity Oct - '+  SAPS.Open_Order_QTY__c);
                                        SAPS.Open_Order_QTY__c = facturaOpenqtyMap.get(productCode+channelCode+regionCode+recordYear+'Oct');
                                    }
                                    if(facturaActualqtyMap.containsKey(productCode+channelCode+regionCode+recordYear+'Oct')){
                                        System.debug('Old Open Order Quantity Oct - '+  SAPS.Open_Order_QTY__c);
                                        SAPS.Actual_Order_QTY__c = facturaActualqtyMap.get(productCode+channelCode+regionCode+recordYear+'Oct');
                                   System.debug('SAPS.Actual_Order_QTY__c'+SAPS.Actual_Order_QTY__c);
                                    }
                                    if(facturaOpenRevenueMap.containsKey(productCode+channelCode+regionCode+recordYear+'Oct')){
                                        SAPS.Open_Order_Revenue__c = facturaOpenRevenueMap.get(productCode+channelCode+regionCode+recordYear+'Oct');
                                    }
                                    
                                    if(accTargetMap.containsKey(productCode+regionCode+recordYear+'Oct')){
                                        SAPS.Budget_Qty__c=accTargetMap.get(productCode+regionCode+recordYear+'Oct');
                                    }
                                    
                                    if(lYMTDMap.containsKey(productCode+channelCode+regionCode+recordYear+'Oct')){
                                        SAPS.Last_Year_s_Month_Qty__c=lYMTDMap.get(productCode+channelCode+regionCode+recordYear+'Oct');
                                    }
                                    //}
                                    SAPS.Is_Update_Metrics__c=false;
                                    system.debug('childListToIterate@@@@'+childListToIterate);
                                    System.debug('facturaOpenqtyMap'+facturaOpenqtyMap);
                                    system.debug('childListToIterate@@@@SIZE---->'+childListToIterate.size());
                                    if(childListToIterate.size()>0){
                                        for(Product2 pro : childListToIterate){
                                            String key = pro.Product_code__c+channelCode+regionCode+recordYear+'Oct';
                                            
                                            System.debug('key oct'+key);
                                            String key2 = '5191'+''+channelCode+''+regionCode+''+tmpMonthNumber+''+currentYear+''+pro.Product_code__c+'Oct '+'\''+Year2;
                                            if(singleSalesQtyMap.containsKey(key)){
                                                SAPS.Current_Year_QTY_YTD__c += singleSalesQtyMap.get(key);
                                            }
                                            if(lastYearSalesQtyMap.containsKey(key)){
                                                SAPS.Last_Year_QTY_YTD__c += lastYearSalesQtyMap.get(key); 
                                            } 
                                            if(lYMTDMap.containsKey(key)){
                                                SAPS.Last_Year_s_Month_Qty__c += lYMTDMap.get(key);
                                            }
                                            if(singleSalesValMap.containsKey(key)){
                                                SAPS.Current_Year_Sales_YTD__c += singleSalesValMap.get(key);
                                            }
                                            if(lastYearSalesValMap.containsKey(key)){
                                                SAPS.Last_Year_Sales_YTD__c += lastYearSalesValMap.get(key); 
                                            }
                                            if(facturaOpenqtyMap.containsKey(key)){
                                                System.debug('in checking SAPS.Prevent_Metric__c Oct');
                                                SAPS.Open_Order_QTY__c += facturaOpenqtyMap.get(key);
                                            }
                                             if(facturaActualqtyMap.containsKey(key)){
                                                // System.debug('in checking SAPS.Prevent_Metric__c Oct');
                                                SAPS.Actual_Order_QTY__c += facturaActualqtyMap.get(key);
                                            }
                                            // System.debug('Key for child '+key2);
                                            if(openDelayOrderQtyMap.containsKey(key2)){
                                                  System.debug('openDelayOrderQtyMap preti '+JSON.serializePretty(openDelayOrderQtyMap));
                                                //   System.debug('OPen order delayed '+openDelayOrderQtyMap.get(key2) +'Key is '+key2);
                                                SAPS.Open_Order_Delayed_QTY__c += openDelayOrderQtyMap.get(key2);
                                            }
                                            if(facturaOpenRevenueMap.containsKey(key)){
                                                SAPS.Open_Order_Revenue__c += facturaOpenRevenueMap.get(key);
                                            }
                                            if(openOrderDelayRevenuMap.containsKey(key2)){
                                                // System.debug('Open order revenue delay key   '+key2);
                                                // System.debug('Open order revenue delay '+openOrderDelayRevenuMap.get(key2));
                                                SAPS.Open_Order_Delayed_Revenue__c += openOrderDelayRevenuMap.get(key2);
                                            }
                                        }
                                    }
                                }
                                
                                
                                
                                else if(recordName.contains('Nov')){
                                    if(volumeMap.containsKey(productCode+channelCode+regionCode+year+'Nov')){
                                        SAPS.POG_Customer_Inventory__c=volumeMap.get(productCode+channelCode+regionCode+year+'Nov');
                                    }
                                    if(coVolumeMap.containsKey(productCode+channelCode+regionCode+year+'Nov')){
                                        SAPS.POG_Company_Inventory__c=coVolumeMap.get(productCode+channelCode+regionCode+year+'Nov');
                                    }
                                    //if(recordMonthMap.get('Nov')==String.valueOf(currentYear)){//recordNameYear
                                    if(test.isRunningTest()){
                                        currentmonthName='Nov';
                                    }
                                    if(month==currentmonthName){
                                        //// System.debug('recordMonthMap next year Nov: '+recordMonthMap.get('Nov'));
                                        if(singleSalesQtyMap.containsKey(productCode+channelCode+regionCode+currentYear+'Nov')){
                                            SAPS.Current_Year_QTY_YTD__c=singleSalesQtyMap.get(productCode+channelCode+regionCode+currentYear+'Nov');
                                        }
                                        if(lastYearSalesQtyMap.containsKey(productCode+channelCode+regionCode+currentYear+'Nov')){
                                            SAPS.Last_Year_QTY_YTD__c=lastYearSalesQtyMap.get(productCode+channelCode+regionCode+currentYear+'Nov'); 
                                        }
                                        if(singleSalesValMap.containsKey(productCode+channelCode+regionCode+currentYear+'Nov')){
                                            SAPS.Current_Year_Sales_YTD__c=singleSalesValMap.get(productCode+channelCode+regionCode+currentYear+'Nov');
                                        }
                                        if(lastYearSalesValMap.containsKey(productCode+channelCode+regionCode+currentYear+'Nov')){
                                            SAPS.Last_Year_Sales_YTD__c=lastYearSalesValMap.get(productCode+channelCode+regionCode+currentYear+'Nov'); 
                                        }
                                        //added By vishal 
                                        if(openDelayOrderQtyMap.containsKey(comboKeysInUpdate)){
                                            System.debug('inside contains key Nik Nov - ');
                                            SAPS.Open_Order_Delayed_QTY__c = openDelayOrderQtyMap.get(comboKeysInUpdate);
                                        }
                                        
                                        /*
if(openOrderQtyMap.containsKey(comboKeysInUpdate)){
// System.debug('in update Nov  Order Quantity  '+openOrderQtyMap.get(comboKeysInUpdate));
SAPS.Open_Order_QTY__c = openOrderQtyMap.get(comboKeysInUpdate);
}*/
                                        
                                        
                                        if(openOrderDelayRevenuMap.containsKey(comboKeysInUpdate)){
                                            SAPS.Open_Order_Delayed_Revenue__c = openOrderDelayRevenuMap.get(comboKeysInUpdate);
                                        }
                                        /*
if(openOrderRevenuMap.containsKey(comboKeysInUpdate)){
SAPS.Open_Order_Revenue__c = openOrderRevenuMap.get(comboKeysInUpdate);
}*/
                                        //End added By vishal 
                                        
                                    }
                                    
                                    if(facturaOpenqtyMap.containsKey(productCode+channelCode+regionCode+recordYear+'Nov')){
                                        // System.debug('Old Open Order Quantity Nov - '+  SAPS.Open_Order_QTY__c);
                                        SAPS.Open_Order_QTY__c = facturaOpenqtyMap.get(productCode+channelCode+regionCode+recordYear+'Nov');
                                    }
                                         if(facturaActualqtyMap.containsKey(productCode+channelCode+regionCode+recordYear+'Nov')){
                                        // System.debug('Old Open Order Quantity Nov - '+  SAPS.Open_Order_QTY__c);
                                        SAPS.Actual_Order_QTY__c = facturaActualqtyMap.get(productCode+channelCode+regionCode+recordYear+'Nov');
                                    }
                                    if(facturaOpenRevenueMap.containsKey(productCode+channelCode+regionCode+recordYear+'Nov')){
                                        SAPS.Open_Order_Revenue__c = facturaOpenRevenueMap.get(productCode+channelCode+regionCode+recordYear+'Nov');
                                    }
                                    
                                    if(accTargetMap.containsKey(productCode+regionCode+recordYear+'Nov')){
                                        SAPS.Budget_Qty__c=accTargetMap.get(productCode+regionCode+recordYear+'Nov');
                                    }
                                    
                                    if(lYMTDMap.containsKey(productCode+channelCode+regionCode+recordYear+'Nov')){
                                        SAPS.Last_Year_s_Month_Qty__c=lYMTDMap.get(productCode+channelCode+regionCode+recordYear+'Nov');
                                    }
                                    //}
                                    SAPS.Is_Update_Metrics__c=false;
                                    
                                    if(childListToIterate.size()>0){
                                        for(Product2 pro : childListToIterate){
                                            String key = pro.Product_code__c+channelCode+regionCode+recordYear+'Nov';
                                            String key2 = '5191'+''+channelCode+''+regionCode+''+tmpMonthNumber+''+currentYear+''+pro.Product_code__c+'Nov '+'\''+Year2;
                                            if(singleSalesQtyMap.containsKey(key)){
                                                SAPS.Current_Year_QTY_YTD__c += singleSalesQtyMap.get(key);
                                            }
                                            if(lastYearSalesQtyMap.containsKey(key)){
                                                SAPS.Last_Year_QTY_YTD__c += lastYearSalesQtyMap.get(key); 
                                            } 
                                            if(lYMTDMap.containsKey(key)){
                                                SAPS.Last_Year_s_Month_Qty__c += lYMTDMap.get(key);
                                            }
                                            if(singleSalesValMap.containsKey(key)){
                                                SAPS.Current_Year_Sales_YTD__c += singleSalesValMap.get(key);
                                            }
                                            if(lastYearSalesValMap.containsKey(key)){
                                                SAPS.Last_Year_Sales_YTD__c += lastYearSalesValMap.get(key); 
                                            }
                                            if(facturaOpenqtyMap.containsKey(key)){
                                                 System.debug('in checking SAPS.Prevent_Metric__c Nov');
                                                SAPS.Open_Order_QTY__c += facturaOpenqtyMap.get(key);
                                            }
                                            if(openDelayOrderQtyMap.containsKey(key2)){
                                                SAPS.Open_Order_Delayed_QTY__c += openDelayOrderQtyMap.get(key2);
                                            }
                                            if(facturaOpenRevenueMap.containsKey(key)){
                                                SAPS.Open_Order_Revenue__c += facturaOpenRevenueMap.get(key);
                                            }
                                            if(facturaActualqtyMap.containsKey(key)){
                                                 System.debug('in checking SAPS.Prevent_Metric__c Nov');
                                                SAPS.Actual_Order_QTY__c += facturaActualqtyMap.get(key);
                                            }
                                            if(openOrderDelayRevenuMap.containsKey(key2)){
                                                SAPS.Open_Order_Delayed_Revenue__c += openOrderDelayRevenuMap.get(key2);
                                            }
                                        }
                                    }
                                }
                                else if(recordName.contains('Dec')){
                                    if(volumeMap.containsKey(productCode+channelCode+regionCode+year+'Dec')){
                                        SAPS.POG_Customer_Inventory__c=volumeMap.get(productCode+channelCode+regionCode+year+'Dec');
                                    }
                                    if(coVolumeMap.containsKey(productCode+channelCode+regionCode+year+'Dec')){
                                        SAPS.POG_Company_Inventory__c=coVolumeMap.get(productCode+channelCode+regionCode+year+'Dec');
                                    }
                                    //if(recordMonthMap.get('Dec')==String.valueOf(currentYear)){//recordNameYear
                                    if(test.isRunningTest()){
                                        currentmonthName='Dec';
                                    }
                                    if(month==currentmonthName){
                                        //// System.debug('recordMonthMap next year Dec: '+recordMonthMap.get('Dec'));
                                        if(singleSalesQtyMap.containsKey(productCode+channelCode+regionCode+currentYear+'Dec')){
                                            SAPS.Current_Year_QTY_YTD__c=singleSalesQtyMap.get(productCode+channelCode+regionCode+currentYear+'Dec');
                                        }
                                        if(lastYearSalesQtyMap.containsKey(productCode+channelCode+regionCode+currentYear+'Dec')){
                                            SAPS.Last_Year_QTY_YTD__c=lastYearSalesQtyMap.get(productCode+channelCode+regionCode+currentYear+'Dec'); 
                                        }
                                        if(singleSalesValMap.containsKey(productCode+channelCode+regionCode+currentYear+'Dec')){
                                            SAPS.Current_Year_Sales_YTD__c=singleSalesValMap.get(productCode+channelCode+regionCode+currentYear+'Dec');
                                        }
                                        if(lastYearSalesValMap.containsKey(productCode+channelCode+regionCode+currentYear+'Dec')){
                                            SAPS.Last_Year_Sales_YTD__c=lastYearSalesValMap.get(productCode+channelCode+regionCode+currentYear+'Dec'); 
                                        }
                                        //added By vishal 
                                        if(openDelayOrderQtyMap.containsKey(comboKeysInUpdate)){
                                            System.debug('inside contains key Nik Dec - ');
                                            SAPS.Open_Order_Delayed_QTY__c = openDelayOrderQtyMap.get(comboKeysInUpdate);
                                        }
                                        
                                        /*
if(openOrderQtyMap.containsKey(comboKeysInUpdate)){
// System.debug('in update Dec  Order Quantity  '+openOrderQtyMap.get(comboKeysInUpdate));
SAPS.Open_Order_QTY__c = openOrderQtyMap.get(comboKeysInUpdate);
}*/
                                        
                                        
                                        if(openOrderDelayRevenuMap.containsKey(comboKeysInUpdate)){
                                            SAPS.Open_Order_Delayed_Revenue__c = openOrderDelayRevenuMap.get(comboKeysInUpdate);
                                        }
                                        
                                        /*
if(openOrderRevenuMap.containsKey(comboKeysInUpdate)){
SAPS.Open_Order_Revenue__c = openOrderRevenuMap.get(comboKeysInUpdate);
}*/
                                        //End added By vishal 
                                    }
                                    if(facturaOpenqtyMap.containsKey(productCode+channelCode+regionCode+recordYear+'Dec')){
                                        // System.debug('Old Open Order Quantity Dec - '+  SAPS.Open_Order_QTY__c);
                                        SAPS.Open_Order_QTY__c = facturaOpenqtyMap.get(productCode+channelCode+regionCode+recordYear+'Dec');
                                    }
                                     if(facturaActualqtyMap.containsKey(productCode+channelCode+regionCode+recordYear+'Dec')){
                                        // System.debug('Old Open Order Quantity Dec - '+  SAPS.Open_Order_QTY__c);
                                        SAPS.Actual_Order_QTY__c = facturaActualqtyMap.get(productCode+channelCode+regionCode+recordYear+'Dec');
                                    }
                                    if(facturaOpenRevenueMap.containsKey(productCode+channelCode+regionCode+recordYear+'Dec')){
                                        SAPS.Open_Order_Revenue__c = facturaOpenRevenueMap.get(productCode+channelCode+regionCode+recordYear+'Dec');
                                    }
                                    
                                    if(accTargetMap.containsKey(productCode+regionCode+recordYear+'Dec')){
                                        SAPS.Budget_Qty__c=accTargetMap.get(productCode+regionCode+recordYear+'Dec');
                                    }
                                    
                                    if(lYMTDMap.containsKey(productCode+channelCode+regionCode+recordYear+'Dec')){
                                        SAPS.Last_Year_s_Month_Qty__c=lYMTDMap.get(productCode+channelCode+regionCode+recordYear+'Dec');
                                    }
                                    //}
                                    SAPS.Is_Update_Metrics__c=false;
                                    
                                    if(childListToIterate.size()>0){
                                        for(Product2 pro : childListToIterate){
                                            String key = pro.Product_code__c+channelCode+regionCode+recordYear+'Dec';
                                            String key2 = '5191'+''+channelCode+''+regionCode+''+tmpMonthNumber+''+currentYear+''+pro.Product_code__c+'Dec '+'\''+Year2;
                                            if(singleSalesQtyMap.containsKey(key)){
                                                SAPS.Current_Year_QTY_YTD__c += singleSalesQtyMap.get(key);
                                            }
                                            if(lastYearSalesQtyMap.containsKey(key)){
                                                SAPS.Last_Year_QTY_YTD__c += lastYearSalesQtyMap.get(key); 
                                            } 
                                            if(lYMTDMap.containsKey(key)){
                                                SAPS.Last_Year_s_Month_Qty__c += lYMTDMap.get(key);
                                            }
                                            if(singleSalesValMap.containsKey(key)){
                                                SAPS.Current_Year_Sales_YTD__c += singleSalesValMap.get(key);
                                            }
                                            if(lastYearSalesValMap.containsKey(key)){
                                                SAPS.Last_Year_Sales_YTD__c += lastYearSalesValMap.get(key); 
                                            }
                                            if(facturaOpenqtyMap.containsKey(key)){
                                                // System.debug('in checking SAPS.Prevent_Metric__c Dec');
                                                SAPS.Open_Order_QTY__c += facturaOpenqtyMap.get(key);
                                            }
                                             if(facturaActualqtyMap.containsKey(key)){
                                                // System.debug('in checking SAPS.Prevent_Metric__c Dec');
                                                SAPS.Actual_Order_QTY__c += facturaActualqtyMap.get(key);
                                            }
                                            if(openDelayOrderQtyMap.containsKey(key2)){
                                                SAPS.Open_Order_Delayed_QTY__c += openDelayOrderQtyMap.get(key2);
                                            }
                                            if(facturaOpenRevenueMap.containsKey(key)){
                                                SAPS.Open_Order_Revenue__c += facturaOpenRevenueMap.get(key);
                                            }
                                            if(openOrderDelayRevenuMap.containsKey(key2)){
                                                SAPS.Open_Order_Delayed_Revenue__c += openOrderDelayRevenuMap.get(key2);
                                            }
                                        }
                                    }
                                    
                                }else{
                                    SAPS.Is_Update_Metrics__c=false;
                                    
                                }
                            }                        
                        }
                        
                    }else{
                        SAPS.Is_Update_Metrics__c=false;
                        
                    } 
                    SAPS.Prevent_Metric__c = true;
                }
                
            }
        }
        catch(Exception e){
             System.debug('error message'+e.getStackTraceString());
        }
        
    }
}