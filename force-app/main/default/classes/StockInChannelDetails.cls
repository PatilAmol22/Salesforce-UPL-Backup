public without sharing class StockInChannelDetails {
    
    @auraenabled
    public static SKUPaginationWrapper getallSKU(string stockInChannel, 
                                                 string currentMonth,
                                                 string previousMonth,
                                                 string previous2Month,
                                                 boolean hideemptystock,
                                                 string customerId
                                                ){
                                                    system.debug(currentMonth);
                                                    system.debug(customerId);
                                                    account a = [select id,SAP_Code__c from account where id = :customerId];
                                                    //calling SAP API
                                                    UPL_Settings__c salesOrgDetailsCC = UPL_Settings__c.getInstance();
                                                    String CompanyCode = salesOrgDetailsCC.Company_Code__c;
                                                    GetStockInChannelRequestWrapper reqSIC= new GetStockInChannelRequestWrapper();
                                                    reqSIC.companyCode=CompanyCode;//company code
                                                    reqSIC.initialCustomerCode=a.SAP_Code__c;// distributor(SAP Code)
                                                    boolean results;
                                                    //results= RebateServiceHelper.GetStockInChannel(reqSIC);
                                                    results= StockInChannelServiceHelper.GetStockInChannel(reqSIC);
                                                    system.debug(results);                                          
                                                    
                                                    //generating Wrapper                                            
                                                    SKUPaginationWrapper WrapperSIC = new SKUPaginationWrapper();
                                                    //if stock in channel is not available
                                                    if(stockInChannel == null)  {
                                                        
                                                        
                                                        //for January
                                                        if(currentMonth == 'January'){
                                                         WrapperSIC.stockInChannel = new Stock_In_Channel__c();
                                                            List<stockInChannelDetailsWrapper> liStockinchannelWrapper = new List<stockInChannelDetailsWrapper>();
                                                            
                                                            integer lastYear = System.Today().year()-1;
                                                            UPL_Settings__c salesOrgDetails = UPL_Settings__c.getInstance();
                                                            String SalesOrg = salesOrgDetails.SalesOrg__c;
                                                            string combinationKey = SalesOrg+string.valueOf(lastYear)+a.SAP_Code__c;
                                                            system.debug('combinationKey'+combinationKey);
                                                            
                                                            list<Stock_In_Channel__c> prevYearSIC = [select  Id,Channel__r.SAP_Code__c,Year__c,January_Description__c, February_Description__c, March_Description__c, April_Description__c, 
                                                                                                     May_Description__c, June_Description__c, July_Description__c, August_Description__c, 
                                                                                                     September_Description__c, October_Description__c, November_Description__c, 
                                                                                                     December_Description__c from Stock_In_Channel__c where Combination_Key__c = :combinationKey];
                                                            string previousYID;
                                                             if(prevYearSIC.size()>0){
                                                                    WrapperSIC.stockInChannel.December_Description__c = prevYearSIC[0].December_Description__c;
                                                                    WrapperSIC.stockInChannel.November_Description__c = prevYearSIC[0].November_Description__c;
                                                                    previousYID = prevYearSIC[0].Id;
                                                                }
                                                                else{
                                                                    WrapperSIC.stockInChannel.December_Description__c = '';
                                                                    WrapperSIC.stockInChannel.November_Description__c = '';    
                                                                }
                                                            
                                                            if(prevYearSIC.size()>0){
                                                                previousYID = prevYearSIC[0].Id;    
                                                            }
                                                            List<Stock_In_Channel_Detail__c> liStockInChannelDetailsLY = new List<Stock_In_Channel_Detail__c>(); 
                                                            map<string, Stock_In_Channel_Detail__c> mapStockInChannelDetailsLY = new map<string, Stock_In_Channel_Detail__c>();
                                                            if(previousYID != ''){
                                                                liStockInChannelDetailsLY = Database.query('select SKU__c,SKU__r.Brand_Name__c,SKU__r.Product_Category__c,SKU__r.UOM__c,SKU__r.SKU_Description__c,  January_Volume__c, January_Volume_Co__c,January_Sales__c, February_Volume__c, February_Volume_Co__c, February_Sales__c, March_Volume__c, March_Volume_Co__c, March_Sales__c, April_Volume__c, April_Volume_Co__c,April_Sales__c, May_Volume__c, May_Volume_Co__c,May_Sales__c, June_Volume__c, June_Volume_Co__c, June_Sales__c, July_Volume__c, July_Volume_Co__c, July_Sales__c, August_Volume__c, August_Volume_Co__c, August_Sales__c, September_Volume__c, September_Volume_Co__c, September_Sales__c, October_Volume__c, October_Volume_Co__c, October_Sales__c, November_Volume__c, November_Volume_Co__c, November_Sales__c, December_Volume__c, December_Volume_Co__c, December_Sales__c, Combination_Key__c FROM Stock_In_Channel_Detail__c where Stock_In_Channel__c = :previousYID');
                                                            }
                                                            for(Stock_In_Channel_Detail__c SICD: liStockInChannelDetailsLY){
                                                                if(!mapStockInChannelDetailsLY.containsKey(SICD.SKU__c)){
                                                                    mapStockInChannelDetailsLY.put(SICD.SKU__c,SICD);
                                                                }
                                                            } 
                                                            system.debug('mapStockInChannelDetailsLY'+mapStockInChannelDetailsLY);
                                                            if(!hideemptystock){
                                                                for (SKU__C s: [select Id,Product_Category__c,Brand_Name__c,SKU_Description__c,UOM__c  from SKU__c where Sales_Org_Code__c='5191' ]){
                                                                    
                                                                    stockInChannelDetailsWrapper wr = new stockInChannelDetailsWrapper(); 
                                                                    wr.brandName = s.Brand_Name__c;
                                                                    wr.productCategory = s.SKU_Description__c;
                                                                    wr.UOM = s.UOM__c;
                                                                    wr.SKUID = s.Id;
                                                                    wr.currentMonthVol = 0;
                                                                  
                                                                    if(mapStockInChannelDetailsLY.containskey(s.Id)){
                                                                        wr.previousMonthVol = (decimal)mapStockInChannelDetailsLY.get(s.Id).december_Volume__c;
                                                                        wr.previous2MonthVol = (decimal)mapStockInChannelDetailsLY.get(s.Id).November_Volume__c;
                                                                        
                                                                         wr.previousMonthVolUPL = (decimal)mapStockInChannelDetailsLY.get(s.Id).December_Volume_Co__c;//, 
                                                                        wr.previous2MonthVolUPL = (decimal)mapStockInChannelDetailsLY.get(s.Id).November_Volume_Co__c;
                                                                        
                                                                        wr.previousSales = (decimal)mapStockInChannelDetailsLY.get(s.Id).December_Sales__c;
                                                                        wr.previous2Sales = (decimal)mapStockInChannelDetailsLY.get(s.Id).November_Sales__c;
                                                                        
                                                                    }
                                                                    else{
                                                                        wr.previousMonthVol = 0;
                                                                        wr.previous2MonthVol = 0;
                                                                        
                                                                    }
                                                                    
                                                                    liStockinchannelWrapper.add(wr);
                                                                    
                                                                }
                                                            }
                                                            WrapperSIC.stockInChanneldetails = liStockinchannelWrapper;           
                                                        }
                                                        else if(currentMonth == 'February'){
                                                            WrapperSIC.stockInChannel = new Stock_In_Channel__c();
                                                            List<stockInChannelDetailsWrapper> liStockinchannelWrapper = new List<stockInChannelDetailsWrapper>();
                                                            
                                                            integer lastYear = System.Today().year()-1;
                                                            UPL_Settings__c salesOrgDetails = UPL_Settings__c.getInstance();
                                                            String SalesOrg = salesOrgDetails.SalesOrg__c;
                                                            string combinationKey = SalesOrg+string.valueOf(lastYear)+a.SAP_Code__c;
                                                            system.debug('combinationKey'+combinationKey);
                                                            
                                                            list<Stock_In_Channel__c> prevYearSIC = [select  Id,Channel__r.SAP_Code__c,Year__c,January_Description__c, February_Description__c, March_Description__c, April_Description__c, 
                                                                                                     May_Description__c, June_Description__c, July_Description__c, August_Description__c, 
                                                                                                     September_Description__c, October_Description__c, November_Description__c, 
                                                                                                     December_Description__c from Stock_In_Channel__c where Combination_Key__c = :combinationKey];
                                                            string previousYID;
                                                            if(prevYearSIC.size()>0){
                                                                    WrapperSIC.stockInChannel.December_Description__c = prevYearSIC[0].December_Description__c;
                                                                    //WrapperSIC.stockInChannel.November_Description__c = prevYearSIC[0].November_Description__c;
                                                                    previousYID = prevYearSIC[0].Id;
                                                                }
                                                                else{
                                                                    WrapperSIC.stockInChannel.December_Description__c = '';
                                                                    //WrapperSIC.stockInChannel.November_Description__c = '';    
                                                                }
                                                            
                                                            if(prevYearSIC.size()>0){
                                                                previousYID = prevYearSIC[0].Id;    
                                                            }
                                                            List<Stock_In_Channel_Detail__c> liStockInChannelDetailsLY = new List<Stock_In_Channel_Detail__c>(); 
                                                            map<string, Stock_In_Channel_Detail__c> mapStockInChannelDetailsLY = new map<string, Stock_In_Channel_Detail__c>();
                                                            if(previousYID != ''){
                                                                liStockInChannelDetailsLY = Database.query('select SKU__c,SKU__r.Brand_Name__c,SKU__r.Product_Category__c,SKU__r.UOM__c,SKU__r.SKU_Description__c,  January_Volume__c, January_Volume_Co__c,January_Sales__c, February_Volume__c, February_Volume_Co__c, February_Sales__c, March_Volume__c, March_Volume_Co__c, March_Sales__c, April_Volume__c, April_Volume_Co__c,April_Sales__c, May_Volume__c, May_Volume_Co__c,May_Sales__c, June_Volume__c, June_Volume_Co__c, June_Sales__c, July_Volume__c, July_Volume_Co__c, July_Sales__c, August_Volume__c, August_Volume_Co__c, August_Sales__c, September_Volume__c, September_Volume_Co__c, September_Sales__c, October_Volume__c, October_Volume_Co__c, October_Sales__c, November_Volume__c, November_Volume_Co__c, November_Sales__c, December_Volume__c, December_Volume_Co__c, December_Sales__c, Combination_Key__c FROM Stock_In_Channel_Detail__c where Stock_In_Channel__c = :previousYID');
                                                            }
                                                            for(Stock_In_Channel_Detail__c SICD: liStockInChannelDetailsLY){
                                                                if(!mapStockInChannelDetailsLY.containsKey(SICD.SKU__c)){
                                                                    mapStockInChannelDetailsLY.put(SICD.SKU__c,SICD);
                                                                }
                                                            } 
                                                            system.debug('mapStockInChannelDetailsLY'+mapStockInChannelDetailsLY);
                                                            if(!hideemptystock){
                                                                for (SKU__C s: [select Id,Product_Category__c,Brand_Name__c,SKU_Description__c,UOM__c  from SKU__c where Sales_Org_Code__c='5191' ]){
                                                                    
                                                                    stockInChannelDetailsWrapper wr = new stockInChannelDetailsWrapper(); 
                                                                    wr.brandName = s.Brand_Name__c;
                                                                    wr.productCategory = s.SKU_Description__c;
                                                                    wr.UOM = s.UOM__c;
                                                                    wr.SKUID = s.Id;
                                                                    wr.currentMonthVol = 0;
                                                                    wr.previousMonthVol = 0;
                                                                    //wr.previous2MonthVol = 0;
                                                                    //
                                                                    if(mapStockInChannelDetailsLY.containskey(s.Id)){
                                                                        
                                                                        wr.previous2MonthVol = (decimal)mapStockInChannelDetailsLY.get(s.Id).december_Volume__c;
                                                                        
                                                                        wr.previous2MonthVolUPL = (decimal)mapStockInChannelDetailsLY.get(s.Id).december_Volume_Co__c;
                                                                        wr.previous2Sales = (decimal)mapStockInChannelDetailsLY.get(s.Id).december_Sales__c;
                                                                    }
                                                                    else{
                                                                        
                                                                        wr.previous2MonthVol = 0;
                                                                        
                                                                    }
                                                                    
                                                                    liStockinchannelWrapper.add(wr);
                                                                    
                                                                }
                                                            }
                                                            WrapperSIC.stockInChanneldetails = liStockinchannelWrapper;
                                                        }
                                                        else{
                                                            WrapperSIC.stockInChannel = new Stock_In_Channel__c();
                                                            List<stockInChannelDetailsWrapper> liStockinchannelWrapper = new List<stockInChannelDetailsWrapper>();
                                                            if(!hideemptystock){
                                                                for (SKU__C s: [select Id,Product_Category__c,Brand_Name__c,SKU_Description__c,UOM__c  from SKU__c where Sales_Org_Code__c='5191' ]){
                                                                    
                                                                    stockInChannelDetailsWrapper wr = new stockInChannelDetailsWrapper(); 
                                                                    wr.brandName = s.Brand_Name__c;
                                                                    wr.productCategory = s.SKU_Description__c;
                                                                    wr.UOM = s.UOM__c;
                                                                    wr.SKUID = s.Id;
                                                                    //wr.currentMonthVol = 0; //Commented by Swapnil
                                                                    //wr.previousMonthVol = 0; //Commented by Swapnil
                                                                    //wr.previous2MonthVol = 0; //Commented by Swapnil
                                                                    
                                                                    liStockinchannelWrapper.add(wr);
                                                                    
                                                                } 
                                                            }
                                                            WrapperSIC.stockInChanneldetails = liStockinchannelWrapper;
                                                        }  
                                                        
                                                    }                                            
                                                    
                                                    else{
                                                        //for January and February
                                                        if(currentMonth == 'January' || currentMonth == 'February'){
                                                            //for January
                                                            if(currentMonth == 'January'){
                                                                //Dynamically Generating field names                                            
                                                                string currentMonthVol= currentMonth+'_Volume__c';
                                                                string previousMonthVol= previousMonth+'_Volume__c';
                                                                string previous2MonthVol= previous2Month+'_Volume__c';
                                                                
                                                                string currentMonthVolUPL= currentMonth+'_Volume_Co__c';
                                                                string previousMonthVolUPL= previousMonth+'_Volume_Co__c';
                                                                string previous2MonthVolUPL= previous2Month+'_Volume_Co__c';
                                                                
                                                                string previousMonthSales = previousMonth+'_Sales__c';
                                                                string previous2MonthSales = previous2Month+'_Sales__c';
                                                                
                                                                WrapperSIC.stockInChannel = [select  Channel__r.SAP_Code__c,Year__c,January_Description__c, February_Description__c, March_Description__c, April_Description__c, 
                                                                                             May_Description__c, June_Description__c, July_Description__c, August_Description__c, 
                                                                                             September_Description__c, October_Description__c, November_Description__c, 
                                                                                             December_Description__c from Stock_In_Channel__c where id = :stockInChannel];
                                                                integer lastYear = System.Today().year()-1;
                                                                UPL_Settings__c salesOrgDetails = UPL_Settings__c.getInstance();
                                                                String SalesOrg = salesOrgDetails.SalesOrg__c;
                                                                string combinationKey = SalesOrg+string.valueOf(lastYear)+WrapperSIC.stockInChannel.Channel__r.SAP_Code__c;
                                                                system.debug('combinationKey'+combinationKey);
                                                                
                                                                list<Stock_In_Channel__c> prevYearSIC = [select  Id,Channel__r.SAP_Code__c,Year__c,January_Description__c, February_Description__c, March_Description__c, April_Description__c, 
                                                                                                         May_Description__c, June_Description__c, July_Description__c, August_Description__c, 
                                                                                                         September_Description__c, October_Description__c, November_Description__c, 
                                                                                                         December_Description__c from Stock_In_Channel__c where Combination_Key__c = :combinationKey];
                                                                string previousYID;
                                                                if(prevYearSIC.size()>0){
                                                                    WrapperSIC.stockInChannel.December_Description__c = prevYearSIC[0].December_Description__c;
                                                                    WrapperSIC.stockInChannel.November_Description__c = prevYearSIC[0].November_Description__c;
                                                                    previousYID = prevYearSIC[0].Id;
                                                                }
                                                                else{
                                                                    WrapperSIC.stockInChannel.December_Description__c = '';
                                                                    WrapperSIC.stockInChannel.November_Description__c = '';    
                                                                }
                                                                
                                                                
                                                                List<Stock_In_Channel_Detail__c> liStockInChannelDetails = new List<Stock_In_Channel_Detail__c>();
                                                                
                                                                List<Stock_In_Channel_Detail__c> liStockInChannelDetailsLY = new List<Stock_In_Channel_Detail__c>(); 
                                                                map<string, Stock_In_Channel_Detail__c> mapStockInChannelDetailsLY = new map<string, Stock_In_Channel_Detail__c>();
                                                                if(previousYID != ''){
                                                                    liStockInChannelDetailsLY = Database.query('select SKU__c,SKU__r.Brand_Name__c,SKU__r.Product_Category__c,SKU__r.UOM__c,SKU__r.SKU_Description__c,  January_Volume__c, January_Volume_Co__c,January_Sales__c, February_Volume__c, February_Volume_Co__c, February_Sales__c, March_Volume__c, March_Volume_Co__c, March_Sales__c, April_Volume__c, April_Volume_Co__c,April_Sales__c, May_Volume__c, May_Volume_Co__c,May_Sales__c, June_Volume__c, June_Volume_Co__c, June_Sales__c, July_Volume__c, July_Volume_Co__c, July_Sales__c, August_Volume__c, August_Volume_Co__c, August_Sales__c, September_Volume__c, September_Volume_Co__c, September_Sales__c, October_Volume__c, October_Volume_Co__c, October_Sales__c, November_Volume__c, November_Volume_Co__c, November_Sales__c, December_Volume__c, December_Volume_Co__c, December_Sales__c, Combination_Key__c FROM Stock_In_Channel_Detail__c where Stock_In_Channel__c = :previousYID');
                                                                }
                                                                liStockInChannelDetails = Database.query('select SKU__r.Brand_Name__c,SKU__r.Product_Category__c,SKU__r.UOM__c,SKU__r.SKU_Description__c,  January_Volume__c, January_Volume_Co__c,January_Sales__c, February_Volume__c, February_Volume_Co__c, February_Sales__c, March_Volume__c, March_Volume_Co__c, March_Sales__c, April_Volume__c, April_Volume_Co__c,April_Sales__c, May_Volume__c, May_Volume_Co__c,May_Sales__c, June_Volume__c, June_Volume_Co__c, June_Sales__c, July_Volume__c, July_Volume_Co__c, July_Sales__c, August_Volume__c, August_Volume_Co__c, August_Sales__c, September_Volume__c, September_Volume_Co__c, September_Sales__c, October_Volume__c, October_Volume_Co__c, October_Sales__c, November_Volume__c, November_Volume_Co__c, November_Sales__c, December_Volume__c, December_Volume_Co__c, December_Sales__c, Combination_Key__c FROM Stock_In_Channel_Detail__c where Stock_In_Channel__c = :stockInChannel');
                                                                
                                                                system.debug('liStockInChannelDetailsLY'+liStockInChannelDetailsLY);
                                                                for(Stock_In_Channel_Detail__c SICD: liStockInChannelDetailsLY){
                                                                    if(!mapStockInChannelDetailsLY.containsKey(SICD.SKU__c)){
                                                                        mapStockInChannelDetailsLY.put(SICD.SKU__c,SICD);
                                                                    }
                                                                } 
                                                                system.debug('Map'+mapStockInChannelDetailsLY);
                                                                
                                                                List<stockInChannelDetailsWrapper> liStockinchannelWrapper = new List<stockInChannelDetailsWrapper>();
                                                                
                                                                for(Stock_In_Channel_Detail__c SICD: liStockInChannelDetails){
                                                                    stockInChannelDetailsWrapper wr = new stockInChannelDetailsWrapper();
                                                                    wr.brandName = SICD.SKU__r.Brand_Name__c;
                                                                    wr.productCategory = SICD.SKU__r.SKU_Description__c;
                                                                    wr.UOM = SICD.SKU__r.UOM__c;
                                                                    wr.SKUID = SICD.SKU__c;
                                                                    wr.currentMonthVol = (decimal)SICD.get(currentMonthVol);
                                                                    wr.currentMonthVolUPL = (decimal)SICD.get(currentMonthVolUPL);
                                                                    
                                                                    if(mapStockInChannelDetailsLY.containskey(SICD.SKU__c)){
                                                                        wr.previousMonthVol = (decimal)mapStockInChannelDetailsLY.get(SICD.SKU__c).December_Volume__c;
                                                                        wr.previous2MonthVol = (decimal)mapStockInChannelDetailsLY.get(SICD.SKU__c).November_Volume__c;
                                                                        
                                                                        
                                                                        wr.previousMonthVolUPL = (decimal)mapStockInChannelDetailsLY.get(SICD.SKU__c).December_Volume_Co__c;//, 
                                                                        wr.previous2MonthVolUPL = (decimal)mapStockInChannelDetailsLY.get(SICD.SKU__c).November_Volume_Co__c;
                                                                        
                                                                        wr.previousSales = (decimal)mapStockInChannelDetailsLY.get(SICD.SKU__c).December_Sales__c;
                                                                        wr.previous2Sales = (decimal)mapStockInChannelDetailsLY.get(SICD.SKU__c).November_Sales__c;
                                                                    }
                                                                    else{
                                                                        //commented by Swapnil
                                                                        //wr.previousMonthVol = '';//0
                                                                        //wr.previous2MonthVol = '';//0
                                                                        
                                                                        //wr.previousMonthVolUPL = '';//0
                                                                        //wr.previous2MonthVolUPL = '';//0
                                                                        
                                                                        //wr.previousSales = '';//0
                                                                        //wr.previous2Sales = ''; //0  
                                                                        //end
                                                                    }
                                                                    
                                                                    if(hideemptystock && wr.currentMonthVol== 0 && wr.previousMonthVol == 0 && wr.previous2MonthVol == 0){
                                                                        
                                                                    }
                                                                    else{
                                                                        liStockinchannelWrapper.add(wr);
                                                                    }
                                                                    
                                                                    // liStockinchannelWrapper.add(wr);
                                                                }
                                                                
                                                                
                                                                set<id> SKUId = new set<id>();
                                                                
                                                                for (Stock_In_Channel_Detail__c SICD: liStockInChannelDetails)
                                                                    SKUId.add(SICD.SKU__c);
                                                                
                                                                //Commented by Varun : INCTASK0443258 12 April 2021
                                                               // map<id,SKU__C> mapSKU = new map<id,SKU__C>([select Id,Brand_Name__c,SKU_Description__c,UOM__c,Product_Category__c  from SKU__c]);
                                                                //Commented by Varun : INCTASK0443258 12 April 2021
                                                                if(!hideemptystock){
                                                                    for (SKU__C s: [select Id,Product_Category__c,Brand_Name__c,SKU_Description__c,UOM__c  from SKU__c where Sales_Org_Code__c='5191' and id not in :SKUId]){
                                                                        
                                                                        stockInChannelDetailsWrapper wr = new stockInChannelDetailsWrapper(); 
                                                                        wr.brandName = s.Brand_Name__c;
                                                                        wr.productCategory = s.SKU_Description__c;
                                                                        wr.UOM = s.UOM__c;
                                                                        wr.SKUID = s.Id;
                                                                        wr.currentMonthVol = 0;
                                                                        
                                                                        if(mapStockInChannelDetailsLY.containskey(s.Id)){
                                                                            wr.previousMonthVol = (decimal)mapStockInChannelDetailsLY.get(s.Id).December_Volume__c;
                                                                            wr.previous2MonthVol = (decimal)mapStockInChannelDetailsLY.get(s.Id).November_Volume__c;
                                                                            wr.previousMonthVolUPL = (decimal)mapStockInChannelDetailsLY.get(s.Id).December_Volume_Co__c;
                                                                            wr.previous2MonthVolUPL = (decimal)mapStockInChannelDetailsLY.get(s.Id).November_Volume_Co__c;
                                                                            wr.previousSales = (decimal)mapStockInChannelDetailsLY.get(s.Id).December_Sales__c;
                                                                            wr.previous2Sales = (decimal)mapStockInChannelDetailsLY.get(s.Id).November_Sales__c;
                                                                        }
                                                                        else{
                                                                            //commented by Swapnil
                                                                            //wr.previousMonthVol = 0;
                                                                            //wr.previous2MonthVol = 0;
                                                                            //end
                                                                        }
                                                                        
                                                                        liStockinchannelWrapper.add(wr);
                                                                        
                                                                    } 
                                                                }
                                                                WrapperSIC.stockInChanneldetails = liStockinchannelWrapper;
                                                            } 
                                                            //January Ends 
                                                            //for February
                                                            if(currentMonth == 'February'){
                                                                //Dynamically Generating field names                                            
                                                                string currentMonthVol= currentMonth+'_Volume__c';
                                                                string previousMonthVol= previousMonth+'_Volume__c';
                                                                string previous2MonthVol= previous2Month+'_Volume__c';
                                                                
                                                                string currentMonthVolUPL= currentMonth+'_Volume_Co__c';
                                                                string previousMonthVolUPL= previousMonth+'_Volume_Co__c';
                                                                string previous2MonthVolUPL= previous2Month+'_Volume_Co__c';
                                                                
                                                                string previousMonthSales = previousMonth+'_Sales__c';
                                                                string previous2MonthSales = previous2Month+'_Sales__c';
                                                                
                                                                WrapperSIC.stockInChannel = [select  Channel__r.SAP_Code__c,Year__c,January_Description__c, February_Description__c, March_Description__c, April_Description__c, 
                                                                                             May_Description__c, June_Description__c, July_Description__c, August_Description__c, 
                                                                                             September_Description__c, October_Description__c, November_Description__c, 
                                                                                             December_Description__c from Stock_In_Channel__c where id = :stockInChannel];
                                                                integer lastYear = System.Today().year()-1;
                                                                UPL_Settings__c salesOrgDetails = UPL_Settings__c.getInstance();
                                                                String SalesOrg = salesOrgDetails.SalesOrg__c;
                                                                string combinationKey = SalesOrg+string.valueOf(lastYear)+WrapperSIC.stockInChannel.Channel__r.SAP_Code__c;
                                                                system.debug('combinationKey'+combinationKey);
                                                                
                                                                list<Stock_In_Channel__c> prevYearSIC = [select  Id,Channel__r.SAP_Code__c,Year__c,January_Description__c, February_Description__c, March_Description__c, April_Description__c, 
                                                                                                         May_Description__c, June_Description__c, July_Description__c, August_Description__c, 
                                                                                                         September_Description__c, October_Description__c, November_Description__c, 
                                                                                                         December_Description__c from Stock_In_Channel__c where Combination_Key__c = :combinationKey];
                                                                string previousYID;
                                                               system.debug('prevYearSIC'+prevYearSIC);
                                                                if(prevYearSIC.size()>0){
                                                                    WrapperSIC.stockInChannel.December_Description__c = prevYearSIC[0].December_Description__c;
                                                                    //WrapperSIC.stockInChannel.November_Description__c = prevYearSIC[0].November_Description__c;
                                                                    previousYID = prevYearSIC[0].Id;
                                                                }
                                                                else{
                                                                    WrapperSIC.stockInChannel.December_Description__c = '';
                                                                    //WrapperSIC.stockInChannel.November_Description__c = '';    
                                                                }
                                                                
                                                                
                                                                List<Stock_In_Channel_Detail__c> liStockInChannelDetails = new List<Stock_In_Channel_Detail__c>();
                                                                
                                                                List<Stock_In_Channel_Detail__c> liStockInChannelDetailsLY = new List<Stock_In_Channel_Detail__c>(); 
                                                                map<string, Stock_In_Channel_Detail__c> mapStockInChannelDetailsLY = new map<string, Stock_In_Channel_Detail__c>();
                                                                if(previousYID != ''){
                                                                    liStockInChannelDetailsLY = Database.query('select SKU__c,SKU__r.Brand_Name__c,SKU__r.Product_Category__c,SKU__r.UOM__c,SKU__r.SKU_Description__c,  January_Volume__c, January_Volume_Co__c,January_Sales__c, February_Volume__c, February_Volume_Co__c, February_Sales__c, March_Volume__c, March_Volume_Co__c, March_Sales__c, April_Volume__c, April_Volume_Co__c,April_Sales__c, May_Volume__c, May_Volume_Co__c,May_Sales__c, June_Volume__c, June_Volume_Co__c, June_Sales__c, July_Volume__c, July_Volume_Co__c, July_Sales__c, August_Volume__c, August_Volume_Co__c, August_Sales__c, September_Volume__c, September_Volume_Co__c, September_Sales__c, October_Volume__c, October_Volume_Co__c, October_Sales__c, November_Volume__c, November_Volume_Co__c, November_Sales__c, December_Volume__c, December_Volume_Co__c, December_Sales__c, Combination_Key__c FROM Stock_In_Channel_Detail__c where Stock_In_Channel__c = :previousYID');
                                                                }
                                                                liStockInChannelDetails = Database.query('select SKU__r.Brand_Name__c,SKU__r.Product_Category__c,SKU__r.UOM__c,SKU__r.SKU_Description__c,  January_Volume__c, January_Volume_Co__c,January_Sales__c, February_Volume__c, February_Volume_Co__c, February_Sales__c, March_Volume__c, March_Volume_Co__c, March_Sales__c, April_Volume__c, April_Volume_Co__c,April_Sales__c, May_Volume__c, May_Volume_Co__c,May_Sales__c, June_Volume__c, June_Volume_Co__c, June_Sales__c, July_Volume__c, July_Volume_Co__c, July_Sales__c, August_Volume__c, August_Volume_Co__c, August_Sales__c, September_Volume__c, September_Volume_Co__c, September_Sales__c, October_Volume__c, October_Volume_Co__c, October_Sales__c, November_Volume__c, November_Volume_Co__c, November_Sales__c, December_Volume__c, December_Volume_Co__c, December_Sales__c, Combination_Key__c FROM Stock_In_Channel_Detail__c where Stock_In_Channel__c = :stockInChannel');
                                                                
                                                                system.debug('liStockInChannelDetailsLY'+liStockInChannelDetailsLY);
                                                                for(Stock_In_Channel_Detail__c SICD: liStockInChannelDetailsLY){
                                                                    if(!mapStockInChannelDetailsLY.containsKey(SICD.SKU__c)){
                                                                        mapStockInChannelDetailsLY.put(SICD.SKU__c,SICD);
                                                                    }
                                                                } 
                                                                system.debug('Map'+mapStockInChannelDetailsLY);
                                                                
                                                                List<stockInChannelDetailsWrapper> liStockinchannelWrapper = new List<stockInChannelDetailsWrapper>();
                                                                
                                                                for(Stock_In_Channel_Detail__c SICD: liStockInChannelDetails){
                                                                    stockInChannelDetailsWrapper wr = new stockInChannelDetailsWrapper();
                                                                    wr.brandName = SICD.SKU__r.Brand_Name__c;
                                                                    wr.productCategory = SICD.SKU__r.SKU_Description__c;
                                                                    wr.UOM = SICD.SKU__r.UOM__c;
                                                                    wr.SKUID = SICD.SKU__c;
                                                                    wr.currentMonthVol = (decimal)SICD.get(currentMonthVol);
                                                                    wr.currentMonthVolUPL = (decimal)SICD.get(currentMonthVolUPL);
                                                                    wr.previousMonthVol = (decimal)SICD.get(previousMonthVol);
                                                                    wr.previousMonthVolUPL = (decimal)SICD.get(previousMonthVolUPL);   
                                                                    wr.previousSales = (decimal)SICD.get(previousMonthSales);
                                                                    
                                                                    if(mapStockInChannelDetailsLY.containskey(SICD.SKU__c)){
                                                                        //wr.previousMonthVol = (decimal)mapStockInChannelDetailsLY.get(SICD.SKU__c).December_Volume__c;
                                                                        wr.previous2MonthVol = (decimal)mapStockInChannelDetailsLY.get(SICD.SKU__c).December_Volume__c;
                                                                        
                                                                        
                                                                        //wr.previousMonthVolUPL = (decimal)mapStockInChannelDetailsLY.get(SICD.SKU__c).December_Volume_Co__c;//, 
                                                                        wr.previous2MonthVolUPL = (decimal)mapStockInChannelDetailsLY.get(SICD.SKU__c).December_Volume_Co__c;
                                                                        
                                                                        //wr.previousSales = (decimal)mapStockInChannelDetailsLY.get(SICD.SKU__c).December_Sales__c;
                                                                        wr.previous2Sales = (decimal)mapStockInChannelDetailsLY.get(SICD.SKU__c).December_Sales__c;
                                                                    }
                                                                    else{
                                                                        //wr.previousMonthVol = 0;
                                                                        wr.previous2MonthVol = 0;
                                                                        
                                                                        //wr.previousMonthVolUPL = 0;//, 
                                                                        wr.previous2MonthVolUPL = 0;
                                                                        
                                                                        //wr.previousSales = 0;
                                                                        wr.previous2Sales = 0;   
                                                                    }
                                                                    
                                                                    if(hideemptystock && wr.currentMonthVol== 0 && wr.previousMonthVol == 0 && wr.previous2MonthVol == 0){
                                                                        
                                                                    }
                                                                    else{
                                                                        liStockinchannelWrapper.add(wr);
                                                                    }
                                                                    
                                                                    // liStockinchannelWrapper.add(wr);
                                                                }
                                                                
                                                                
                                                                set<id> SKUId = new set<id>();
                                                                
                                                                for (Stock_In_Channel_Detail__c SICD: liStockInChannelDetails)
                                                                    SKUId.add(SICD.SKU__c);
                                                                
                                                                //Commented by Varun : INCTASK0443258 12 April 2021
                                                                //map<id,SKU__C> mapSKU = new map<id,SKU__C>([select Id,Brand_Name__c,SKU_Description__c,UOM__c,Product_Category__c  from SKU__c]);
                                                                //Commented by Varun : INCTASK0443258 12 April 2021
                                                                if(!hideemptystock){
                                                                    for (SKU__C s: [select Id,Product_Category__c,Brand_Name__c,SKU_Description__c,UOM__c  from SKU__c where Sales_Org_Code__c='5191' and id not in :SKUId]){
                                                                        
                                                                        stockInChannelDetailsWrapper wr = new stockInChannelDetailsWrapper(); 
                                                                        wr.brandName = s.Brand_Name__c;
                                                                        wr.productCategory = s.SKU_Description__c;
                                                                        wr.UOM = s.UOM__c;
                                                                        wr.SKUID = s.Id;
                                                                        wr.currentMonthVol = 0;
                                                                        wr.previous2MonthVol = 0;
                                                                        if(mapStockInChannelDetailsLY.containskey(s.Id)){
                                                                            wr.previousMonthVol = (decimal)mapStockInChannelDetailsLY.get(s.Id).December_Volume__c;
                                                                            //wr.previous2MonthVol = (decimal)mapStockInChannelDetailsLY.get(s.Id).November_Volume__c;
                                                                            wr.previousMonthVolUPL = (decimal)mapStockInChannelDetailsLY.get(s.Id).December_Volume_Co__c;
                                                                            //wr.previous2MonthVolUPL = (decimal)mapStockInChannelDetailsLY.get(s.Id).November_Volume_Co__c;
                                                                            wr.previousSales = (decimal)mapStockInChannelDetailsLY.get(s.Id).December_Sales__c;
                                                                            //wr.previous2Sales = (decimal)mapStockInChannelDetailsLY.get(s.Id).November_Sales__c;
                                                                        }
                                                                        else{
                                                                            wr.previousMonthVol = 0;
                                                                            wr.previous2MonthVol = 0;
                                                                        }
                                                                        
                                                                        liStockinchannelWrapper.add(wr);
                                                                        
                                                                    } 
                                                                }
                                                                WrapperSIC.stockInChanneldetails = liStockinchannelWrapper;
                                                            }
                                                            //February Ends
                                                        }
                                                        //end january and February
                                                        //for Other Months
                                                        else{
                                                            //Dynamically Generating field names                                            
                                                            string currentMonthVol= currentMonth+'_Volume__c';
                                                            string previousMonthVol= previousMonth+'_Volume__c';
                                                            string previous2MonthVol= previous2Month+'_Volume__c';
                                                            
                                                            string currentMonthVolUPL= currentMonth+'_Volume_Co__c';
                                                            string previousMonthVolUPL= previousMonth+'_Volume_Co__c';
                                                            string previous2MonthVolUPL= previous2Month+'_Volume_Co__c';
                                                            
                                                            string previousMonthSales = previousMonth+'_Sales__c';
                                                            string previous2MonthSales = previous2Month+'_Sales__c';
                                                            
                                                            
                                                            WrapperSIC.stockInChannel = [select  January_Description__c, February_Description__c, March_Description__c, April_Description__c, 
                                                                                         May_Description__c, June_Description__c, July_Description__c, August_Description__c, 
                                                                                         September_Description__c, October_Description__c, November_Description__c, 
                                                                                         December_Description__c from Stock_In_Channel__c where id = :stockInChannel];
                                                            
                                                            List<Stock_In_Channel_Detail__c> liStockInChannelDetails = new List<Stock_In_Channel_Detail__c>(); 
                                                            
                                                            liStockInChannelDetails = Database.query('select SKU__r.Brand_Name__c,SKU__r.Product_Category__c,SKU__r.UOM__c,SKU__r.SKU_Description__c,  January_Volume__c, January_Volume_Co__c,January_Sales__c, February_Volume__c, February_Volume_Co__c, February_Sales__c, March_Volume__c, March_Volume_Co__c, March_Sales__c, April_Volume__c, April_Volume_Co__c,April_Sales__c, May_Volume__c, May_Volume_Co__c,May_Sales__c, June_Volume__c, June_Volume_Co__c, June_Sales__c, July_Volume__c, July_Volume_Co__c, July_Sales__c, August_Volume__c, August_Volume_Co__c, August_Sales__c, September_Volume__c, September_Volume_Co__c, September_Sales__c, October_Volume__c, October_Volume_Co__c, October_Sales__c, November_Volume__c, November_Volume_Co__c, November_Sales__c, December_Volume__c, December_Volume_Co__c, December_Sales__c, Combination_Key__c FROM Stock_In_Channel_Detail__c where Stock_In_Channel__c = :stockInChannel');
                                                            
                                                            
                                                            List<stockInChannelDetailsWrapper> liStockinchannelWrapper = new List<stockInChannelDetailsWrapper>();
                                                            
                                                            for(Stock_In_Channel_Detail__c SICD: liStockInChannelDetails){
                                                                stockInChannelDetailsWrapper wr = new stockInChannelDetailsWrapper();
                                                                wr.brandName = SICD.SKU__r.Brand_Name__c;
                                                                wr.productCategory = SICD.SKU__r.SKU_Description__c;
                                                                wr.UOM = SICD.SKU__r.UOM__c;
                                                                wr.SKUID = SICD.SKU__c;
                                                                wr.currentMonthVol = (decimal)SICD.get(currentMonthVol);                       
                                                                wr.previousMonthVol = (decimal)SICD.get(previousMonthVol);
                                                                wr.previous2MonthVol = (decimal)SICD.get(previous2MonthVol);
                                                                
                                                                wr.currentMonthVolUPL = (decimal)SICD.get(currentMonthVolUPL);
                                                                wr.previousMonthVolUPL = (decimal)SICD.get(previousMonthVolUPL);
                                                                wr.previous2MonthVolUPL = (decimal)SICD.get(previous2MonthVolUPL);
                                                                
                                                                wr.previousSales = (decimal)SICD.get(previousMonthSales);
                                                                wr.previous2Sales = (decimal)SICD.get(previous2MonthSales);
                                                                
                                                                if(hideemptystock && wr.currentMonthVol== 0 && wr.previousMonthVol == 0 && wr.previous2MonthVol == 0){
                                                                    
                                                                }
                                                                else{
                                                                    liStockinchannelWrapper.add(wr);
                                                                }
                                                                
                                                                // liStockinchannelWrapper.add(wr);
                                                            }
                                                            
                                                            
                                                            set<id> SKUId = new set<id>();
                                                            
                                                            for (Stock_In_Channel_Detail__c SICD: liStockInChannelDetails)
                                                                SKUId.add(SICD.SKU__c);
                                                            
                                                            //Commented by Varun : INCTASK0443258 12 April 2021
                                                            //map<id,SKU__C> mapSKU = new map<id,SKU__C>([select Id,Brand_Name__c,SKU_Description__c,UOM__c,Product_Category__c  from SKU__c]);
                                                            //Commented by Varun : INCTASK0443258 12 April 2021
                                                            if(!hideemptystock){
                                                                for (SKU__C s: [select Id,Product_Category__c,Brand_Name__c,SKU_Description__c,UOM__c  from SKU__c where Sales_Org_Code__c='5191' and id not in :SKUId]){
                                                                    
                                                                    stockInChannelDetailsWrapper wr = new stockInChannelDetailsWrapper(); 
                                                                    wr.brandName = s.Brand_Name__c;
                                                                    wr.productCategory = s.SKU_Description__c;
                                                                    wr.UOM = s.UOM__c;
                                                                    wr.SKUID = s.Id;
                                                                    //wr.currentMonthVol = 0; Commented by Swapnil
                                                                    //wr.previousMonthVol = 0; Commented by Swapnil
                                                                    //wr.previous2MonthVol = 0; Commented by Swapnil
                                                                    
                                                                    
                                                                    liStockinchannelWrapper.add(wr);
                                                                    
                                                                } 
                                                            }
                                                            WrapperSIC.stockInChanneldetails = liStockinchannelWrapper;
                                                        } 
                                                    }
                                                    List<string> liBrandName = new List<string>();
                                                    for (SKU__C s: [select Id,Product_Category__c,Brand_Name__c,SKU_Description__c,UOM__c  from SKU__c where Sales_Org_Code__c='5191' order by Brand_Name__c]){
                                                        //identifying unique brand name
                                                        if(!liBrandName.contains(s.Brand_Name__c))
                                                            liBrandName.add(s.Brand_Name__c);
                                                    }
                                                    
                                                    WrapperSIC.ProductGroupList = liBrandName;
                                                    
                                                    //disable input fields if date is more than date mention in custom settings
                                                    UPL_Settings__c enddate = UPL_Settings__c.getInstance();
                                                    WrapperSIC.endDate = integer.valueof(enddate.Visibility_Date__c);
                                                    list<SIC_User_Info__c> liSICException = [select id,Exception__c from SIC_User_Info__c 
                                                                                             where Sales_User__c = :userinfo.getUserId() 
                                                                                             and Year__c = :system.today().year() ];
                                                    if(liSICException.size()>0){
                                                    if(liSICException[0].Exception__c){
                                                        WrapperSIC.SalesRepExceptionProvided = true;
                                                    }
                                                    }
                                                    else{
                                                        WrapperSIC.SalesRepExceptionProvided = false;
                                                    }
                                                    //checking whether user has write access or not
                                                    if(Schema.sObjectType.Stock_In_Channel__c.isCreateable() && 
                                                       Schema.sObjectType.Stock_In_Channel_Detail__c.isCreateable()){
                                                           WrapperSIC.writeAccess = true;
                                                       }
                                                    else{
                                                        WrapperSIC.writeAccess = false;
                                                        
                                                    } 
                                                    
                                                    return WrapperSIC;
                                                }
    
    //Wrapper Class to get SKU with Pagination  
    public class SKUPaginationWrapper {
        
        @AuraEnabled
        public Stock_In_Channel__c stockInChannel {get;set;}
        @AuraEnabled
        public List<stockInChannelDetailsWrapper> stockInChanneldetails {get;set;}
        @AuraEnabled
        public List<string> ProductGroupList {get;set;}
        @AuraEnabled
        public Integer endDate {get;set;}
        @AuraEnabled
        public boolean writeAccess {get;set;}
        //added by swapnil
        @AuraEnabled
        public boolean SalesRepExceptionProvided {get;set;}
        //end
        
    }
    //Wrapper for stockInChannelDetails
    public class stockInChannelDetailsWrapper {
        
        @AuraEnabled
        public string brandName {get;set;}
        
        @AuraEnabled
        public string productCategory {get;set;}
        
        @AuraEnabled
        public string UOM {get;set;}
        @AuraEnabled
        public string SKUID {get;set;}
        @AuraEnabled
        public decimal currentMonthVol {get;set;}
        @AuraEnabled
        public decimal previousMonthVol {get;set;}
        @AuraEnabled
        public decimal previous2MonthVol {get;set;}
        
        @AuraEnabled
        public decimal currentMonthVolUPL {get;set;}
        @AuraEnabled
        public decimal previousMonthVolUPL {get;set;}
        @AuraEnabled
        public decimal previous2MonthVolUPL {get;set;}
        
        @AuraEnabled
        public decimal previousSales {get;set;}
        @AuraEnabled
        public decimal previous2Sales {get;set;}
        
        
        
    }
    
    @auraenabled
    public static string upsertStockInChannelDetails(string SKUId,  
                                                     decimal currentMonth,
                                                     decimal previousMonth,
                                                     decimal previousMonth2,
                                                     string StockInChannelId,
                                                     string customerId,
                                                     string territoryId,
                                                     string currentMonthlabel,
                                                     string previousMonthlabel,
                                                     string previous2Monthlabel
                                                    ){
                                                        system.debug('upsertStockInChannelDetails '+territoryId);
                                                        //fetch Sales org code from Custom settings
                                                        UPL_Settings__c salesOrgDetails = UPL_Settings__c.getInstance();
                                                        String SalesOrg = salesOrgDetails.SalesOrg__c;
                                                        //month is january
                                                        if(currentMonthlabel == 'January'){
                                                            account acc = [select id,SAP_Code__c from account where id = :customerId];
                                                            string LYCombinationKey = SalesOrg+string.valueOf(System.Today().year()-1)+acc.SAP_Code__c;
                                                            system.debug('LYCombinationKey'+LYCombinationKey);
                                                            list<Stock_In_Channel__c> stockInChannelLY = [select id from Stock_In_Channel__c where Combination_Key__c = :LYCombinationKey];
                                                            string stockInChannelLYId;
                                                            if(stockInChannelLY.size()== 0){
                                                                
                                                                Stock_In_Channel__c newSIC = new Stock_In_Channel__c();
                                                                account a = [select id,SAP_Code__c from account where id = :customerId];
                                                                Territory_Distributor__c t = [select id from Territory_Distributor__c where id = :territoryId];
                                                                Sales_Org__c SO = [select id from Sales_Org__c where Sales_Org_Code__c = '5191'];
                                                                newSIC.Channel__c = a.id;
                                                                newSIC.Territory__c = t.id;
                                                                newSIC.Sales_Org__c = SO.id;
                                                                newSIC.Year__c = string.valueOf(System.Today().year()-1);
                                                                newSIC.Combination_Key__c = SalesOrg+string.valueOf(System.Today().year()-1)+a.SAP_Code__c;
                                                                newSIC.Sales_Rep__c = userinfo.getuserid();
                                                                insert newSIC;
                                                                stockInChannelLYId = newSIC.Id;
                                                                
                                                                
                                                            }
                                                            else{
                                                                stockInChannelLYId = stockInChannelLY[0].Id;
                                                            }
                                                            system.debug(stockInChannelLYId);
                                                            List<Stock_In_Channel_Detail__c> SICDLY = [select id from Stock_In_Channel_Detail__c 
                                                                                                       where SKU__C = :SKUId 
                                                                                                       and Stock_In_Channel__c = :stockInChannelLYId];
                                                            
                                                            string currentMonthvol = currentMonthlabel+'_Volume__c'; 
                                                            string previousMonthvol = previousMonthlabel+'_Volume__c';                                             
                                                            string previous2Monthvol = previous2Monthlabel+'_Volume__c';
                                                            if(SICDLY.size()>0){
                                                                
                                                                SICDLY[0].put(previousMonthvol, previousMonth);
                                                                SICDLY[0].put(previous2Monthvol, previousMonth2);
                                                                update SICDLY; 
                                                            }
                                                            else{
                                                                Stock_In_Channel_Detail__c newSICD = new Stock_In_Channel_Detail__c();
                                                                account a = [select id,SAP_Code__c from account where id = :customerId];
                                                                SKU__c SKU = [select id,SKU_Code__c from SKU__c where Sales_Org_Code__c='5191' AND id = :SKUId];
                                                                newSICD.SKU__c = SKUId;
                                                                newSICD.Stock_In_Channel__c = stockInChannelLYId;
                                                                newSICD.Combination_Key__c = SalesOrg+string.valueOf(System.Today().year()-1)+a.SAP_Code__c+SKU.SKU_Code__c;
                                                                //newSICD.put(currentMonthvol, currentMonth);
                                                                newSICD.put(previousMonthvol, previousMonth);
                                                                newSICD.put(previous2Monthvol, previousMonth2);
                                                                
                                                                insert newSICD;  
                                                            }
                                                            
                                                            if(string.isBlank(StockInChannelId)){
                                                                
                                                                Stock_In_Channel__c newSIC = new Stock_In_Channel__c();
                                                                account a = [select id,SAP_Code__c from account where id = :customerId];
                                                                Territory_Distributor__c t = [select id from Territory_Distributor__c where id = :territoryId];
                                                                Sales_Org__c SO = [select id from Sales_Org__c where Sales_Org_Code__c = '5191'];
                                                                newSIC.Channel__c = a.id;
                                                                newSIC.Territory__c = t.id;
                                                                newSIC.Sales_Org__c = SO.id;
                                                                newSIC.Year__c = string.valueOf(System.Today().year());
                                                                newSIC.Combination_Key__c = SalesOrg+string.valueOf(System.Today().year())+a.SAP_Code__c;
                                                                newSIC.Sales_Rep__c = userinfo.getuserid();
                                                                insert newSIC;
                                                                StockInChannelId = newSIC.Id;
                                                                
                                                            }
                                                            
                                                            List<Stock_In_Channel_Detail__c> SICD = [select id from Stock_In_Channel_Detail__c 
                                                                                                     where SKU__C = :SKUId 
                                                                                                     and Stock_In_Channel__c = :StockInChannelId];
                                                            
                                                            
                                                            if(SICD.isEmpty()){
                                                                Stock_In_Channel_Detail__c newSICD = new Stock_In_Channel_Detail__c();
                                                                account a = [select id,SAP_Code__c from account where id = :customerId];
                                                                SKU__c SKU = [select id,SKU_Code__c from SKU__c where Sales_Org_Code__c='5191' AND id = :SKUId];
                                                                newSICD.SKU__c = SKUId;
                                                                newSICD.Stock_In_Channel__c = StockInChannelId;
                                                                newSICD.Combination_Key__c = SalesOrg+string.valueOf(System.Today().year())+a.SAP_Code__c+SKU.SKU_Code__c;
                                                                newSICD.put(currentMonthvol, currentMonth);
                                                                //newSICD.put(previousMonthvol, previousMonth);
                                                                //newSICD.put(previous2Monthvol, previousMonth2);
                                                                
                                                                insert newSICD;
                                                            }
                                                            else{
                                                                
                                                                SICD[0].put(currentMonthvol, currentMonth);
                                                                //SICD[0].put(previousMonthvol, previousMonth);
                                                                //SICD[0].put(previous2Monthvol, previousMonth2);
                                                                
                                                                update SICD;
                                                                
                                                                
                                                            }
                                                            //added by Swapnil - to update status per month per SIC
                                                             string MonthStatus = 'Status_'+Date.Today().Month()+'__c';//added by Swapnil
                                                             Stock_In_Channel__c oldSIC = [select Id,Status_1__c,Status_2__c,Status_3__c,Status_4__c,Status_5__c,
                                                                                          Status_6__c,Status_7__c,Status_8__c,Status_9__c,Status_10__c,
                                                                                          Status_11__c,Status_12__c from Stock_In_Channel__c
                                                                                          where id = :StockInChannelId];
                                                             oldSIC.put(MonthStatus, 'In Progress');
                                                             update oldSIC;
                                                             system.debug(oldSIC.Status_7__c);
                                                             system.debug('MonthStatus '+MonthStatus);
                                                             //end
                                                            return StockInChannelId;
                                                        }
                                                        //end month january
                                                        //Month is February
                                                        
                                                        if(currentMonthlabel == 'February'){
                                                            account acc = [select id,SAP_Code__c from account where id = :customerId];
                                                            string LYCombinationKey = SalesOrg+string.valueOf(System.Today().year()-1)+acc.SAP_Code__c;
                                                            system.debug('LYCombinationKey'+LYCombinationKey);
                                                            list<Stock_In_Channel__c> stockInChannelLY = [select id from Stock_In_Channel__c where Combination_Key__c = :LYCombinationKey];
                                                            string stockInChannelLYId;
                                                            if(stockInChannelLY.size()== 0){
                                                                
                                                                Stock_In_Channel__c newSIC = new Stock_In_Channel__c();
                                                                account a = [select id,SAP_Code__c from account where id = :customerId];
                                                                Territory_Distributor__c t = [select id from Territory_Distributor__c where id = :territoryId];
                                                                Sales_Org__c SO = [select id from Sales_Org__c where Sales_Org_Code__c = '5191'];
                                                                newSIC.Channel__c = a.id;
                                                                newSIC.Territory__c = t.id;
                                                                newSIC.Sales_Org__c = SO.id;
                                                                newSIC.Year__c = string.valueOf(System.Today().year()-1);
                                                                newSIC.Combination_Key__c = SalesOrg+string.valueOf(System.Today().year()-1)+a.SAP_Code__c;
                                                                newSIC.Sales_Rep__c = userinfo.getuserid();
                                                                insert newSIC;
                                                                stockInChannelLYId = newSIC.Id;
                                                                
                                                                
                                                            }
                                                            else{
                                                                stockInChannelLYId = stockInChannelLY[0].Id;
                                                            }
                                                            system.debug(stockInChannelLYId);
                                                            List<Stock_In_Channel_Detail__c> SICDLY = [select id from Stock_In_Channel_Detail__c 
                                                                                                       where SKU__C = :SKUId 
                                                                                                       and Stock_In_Channel__c = :stockInChannelLYId];
                                                            
                                                            string currentMonthvol = currentMonthlabel+'_Volume__c'; 
                                                            string previousMonthvol = previousMonthlabel+'_Volume__c';                                             
                                                            string previous2Monthvol = previous2Monthlabel+'_Volume__c';
                                                            if(SICDLY.size()>0){
                                                                
                                                                //SICDLY[0].put(previousMonthvol, previousMonth);
                                                                SICDLY[0].put(previous2Monthvol, previousMonth2);
                                                                update SICDLY; 
                                                            }
                                                            else{
                                                                Stock_In_Channel_Detail__c newSICD = new Stock_In_Channel_Detail__c();
                                                                account a = [select id,SAP_Code__c from account where id = :customerId];
                                                                SKU__c SKU = [select id,SKU_Code__c from SKU__c where Sales_Org_Code__c='5191' AND id = :SKUId];
                                                                newSICD.SKU__c = SKUId;
                                                                newSICD.Stock_In_Channel__c = stockInChannelLYId;
                                                                newSICD.Combination_Key__c = SalesOrg+string.valueOf(System.Today().year()-1)+a.SAP_Code__c+SKU.SKU_Code__c;
                                                                //newSICD.put(currentMonthvol, currentMonth);
                                                                //newSICD.put(previousMonthvol, previousMonth);
                                                                newSICD.put(previous2Monthvol, previousMonth2);
                                                                
                                                                insert newSICD;  
                                                            }
                                                            
                                                            if(string.isBlank(StockInChannelId)){
                                                                
                                                                Stock_In_Channel__c newSIC = new Stock_In_Channel__c();
                                                                account a = [select id,SAP_Code__c from account where id = :customerId];
                                                                Territory_Distributor__c t = [select id from Territory_Distributor__c where id = :territoryId];
                                                                Sales_Org__c SO = [select id from Sales_Org__c where Sales_Org_Code__c = '5191'];
                                                                newSIC.Channel__c = a.id;
                                                                newSIC.Territory__c = t.id;
                                                                newSIC.Sales_Org__c = SO.id;
                                                                newSIC.Year__c = string.valueOf(System.Today().year());
                                                                newSIC.Combination_Key__c = SalesOrg+string.valueOf(System.Today().year())+a.SAP_Code__c;
                                                                newSIC.Sales_Rep__c = userinfo.getuserid();
                                                                insert newSIC;
                                                                StockInChannelId = newSIC.Id;
                                                                
                                                            }
                                                            
                                                            List<Stock_In_Channel_Detail__c> SICD = [select id from Stock_In_Channel_Detail__c 
                                                                                                     where SKU__C = :SKUId 
                                                                                                     and Stock_In_Channel__c = :StockInChannelId];
                                                            
                                                            
                                                            if(SICD.isEmpty()){
                                                                Stock_In_Channel_Detail__c newSICD = new Stock_In_Channel_Detail__c();
                                                                account a = [select id,SAP_Code__c from account where id = :customerId];
                                                                SKU__c SKU = [select id,SKU_Code__c from SKU__c where Sales_Org_Code__c='5191' AND id = :SKUId];
                                                                newSICD.SKU__c = SKUId;
                                                                newSICD.Stock_In_Channel__c = StockInChannelId;
                                                                newSICD.Combination_Key__c = SalesOrg+string.valueOf(System.Today().year())+a.SAP_Code__c+SKU.SKU_Code__c;
                                                                newSICD.put(currentMonthvol, currentMonth);
                                                                newSICD.put(previousMonthvol, previousMonth);
                                                                //newSICD.put(previous2Monthvol, previousMonth2);
                                                                
                                                                insert newSICD;
                                                            }
                                                            else{
                                                                
                                                                SICD[0].put(currentMonthvol, currentMonth);
                                                                SICD[0].put(previousMonthvol, previousMonth);
                                                                //SICD[0].put(previous2Monthvol, previousMonth2);
                                                                
                                                                update SICD;
                                                                
                                                                
                                                            }
                                                            //added by Swapnil - to update status per month per SIC
                                                             string MonthStatus = 'Status_'+Date.Today().Month()+'__c';//added by Swapnil
                                                             Stock_In_Channel__c oldSIC = [select Id,Status_1__c,Status_2__c,Status_3__c,Status_4__c,Status_5__c,
                                                                                          Status_6__c,Status_7__c,Status_8__c,Status_9__c,Status_10__c,
                                                                                          Status_11__c,Status_12__c from Stock_In_Channel__c
                                                                                          where id = :StockInChannelId];
                                                             oldSIC.put(MonthStatus, 'In Progress');
                                                             update oldSIC;
                                                             system.debug(oldSIC.Status_7__c);
                                                             system.debug('MonthStatus '+MonthStatus);
                                                             //end
                                                            return StockInChannelId;
                                                        }
                                                        //end month january
                                                        //end month February
                                                        else{
                                                            if(string.isBlank(StockInChannelId)){
                                                                
                                                                Stock_In_Channel__c newSIC = new Stock_In_Channel__c();
                                                                account a = [select id,SAP_Code__c from account where id = :customerId];
                                                                Territory_Distributor__c t = [select id from Territory_Distributor__c where id = :territoryId];
                                                                Sales_Org__c SO = [select id from Sales_Org__c where Sales_Org_Code__c = '5191'];
                                                                newSIC.Channel__c = a.id;
                                                                newSIC.Territory__c = t.id;
                                                                newSIC.Sales_Org__c = SO.id;
                                                                newSIC.Year__c = string.valueOf(System.Today().year());
                                                                newSIC.Combination_Key__c = SalesOrg+string.valueOf(System.Today().year())+a.SAP_Code__c;
                                                                newSIC.Sales_Rep__c = userinfo.getuserid();
                                                                //newSIC.Status_6__c = 'In Progress';//added by Swapnil
                                                                string MonthStatus = 'Status_'+Date.Today().Month()+'__c';
                                                                newSIC.put(MonthStatus, 'In Progress');
                                                                //end
                                                                insert newSIC;
                                                                StockInChannelId = newSIC.Id;
                                                                
                                                            }
                                                            
                                                            List<Stock_In_Channel_Detail__c> SICD = [select id from Stock_In_Channel_Detail__c 
                                                                                                     where SKU__C = :SKUId 
                                                                                                     and Stock_In_Channel__c = :StockInChannelId];
                                                            string currentMonthvol = currentMonthlabel+'_Volume__c'; 
                                                            string previousMonthvol = previousMonthlabel+'_Volume__c';                                             
                                                            string previous2Monthvol = previous2Monthlabel+'_Volume__c'; 
                                                            
                                                            if(SICD.isEmpty()){
                                                                Stock_In_Channel_Detail__c newSICD = new Stock_In_Channel_Detail__c();
                                                                account a = [select id,SAP_Code__c from account where id = :customerId];
                                                                SKU__c SKU = [select id,SKU_Code__c from SKU__c where Sales_Org_Code__c='5191' AND id = :SKUId];
                                                                newSICD.SKU__c = SKUId;
                                                                newSICD.Stock_In_Channel__c = StockInChannelId;
                                                                newSICD.Combination_Key__c = SalesOrg+string.valueOf(System.Today().year())+a.SAP_Code__c+SKU.SKU_Code__c;
                                                                newSICD.put(currentMonthvol, currentMonth);
                                                                newSICD.put(previousMonthvol, previousMonth);
                                                                newSICD.put(previous2Monthvol, previousMonth2);
                                                                
                                                                insert newSICD;
                                                            }
                                                            else{
                                                                
                                                                SICD[0].put(currentMonthvol, currentMonth);
                                                                SICD[0].put(previousMonthvol, previousMonth);
                                                                SICD[0].put(previous2Monthvol, previousMonth2);
                                                                
                                                                update SICD;
                                                                
                                                                
                                                            }
                                                            
                                                            //added by Swapnil - to update status per month per SIC
                                                             string MonthStatus = 'Status_'+Date.Today().Month()+'__c';//added by Swapnil
                                                             Stock_In_Channel__c oldSIC = [select Id,Status_1__c,Status_2__c,Status_3__c,Status_4__c,Status_5__c,
                                                                                          Status_6__c,Status_7__c,Status_8__c,Status_9__c,Status_10__c,
                                                                                          Status_11__c,Status_12__c from Stock_In_Channel__c
                                                                                          where id = :StockInChannelId];
                                                             oldSIC.put(MonthStatus, 'In Progress');
                                                             update oldSIC;
                                                             system.debug(oldSIC.Status_7__c);
                                                             system.debug('MonthStatus '+MonthStatus);
                                                             //end
                                                            return StockInChannelId;
                                                        }  
                                                    }
    
    @auraenabled
    public static string UnsertStockInChannelDetails(string description,
                                                     string Olddescription,
                                                     string Old2description,  
                                                     string stockInChannelId,
                                                     string customerId,
                                                     string territoryId,
                                                     string currentMonth,
                                                     string previousMonth,
                                                     string previous2Month){
                                                         
                                                         //fetch Sales org code from Custom settings
                                                         UPL_Settings__c salesOrgDetails = UPL_Settings__c.getInstance();
                                                         String SalesOrg = salesOrgDetails.SalesOrg__c;	
                                                         //current month is january
                                                         if(currentMonth == 'January'){
                                                             account acc = [select id,SAP_Code__c from account where id = :customerId];
                                                             string LYCombinationKey = SalesOrg+string.valueOf(System.Today().year()-1)+acc.SAP_Code__c;
                                                             system.debug('LYCombinationKey'+LYCombinationKey);
                                                             list<Stock_In_Channel__c> stockInChannelLY = [select id from Stock_In_Channel__c where Combination_Key__c = :LYCombinationKey];
                                                             system.debug('stockInChannelLY'+stockInChannelLY);
                                                             if(stockInChannelLY.size()>0){
                                                                 Stock_In_Channel__c a =  [select id from Stock_In_Channel__c where id = :stockInChannelLY[0].Id];
                                                                 string currentMonthdesc = currentMonth+'_Description__c'; 
                                                                 string previousMonthdesc = previousMonth+'_Description__c';                                             
                                                                 string previous2Monthdesc = previous2Month+'_Description__c';
                                                                 
                                                                 //a.put(currentMonthdesc, description);
                                                                 a.put(previousMonthdesc, Olddescription);
                                                                 a.put(previous2Monthdesc, Old2description);
                                                                 a.Sales_Rep__c = userinfo.getuserid();
                                                                 update a;
                                                                 //return a.Id;
                                                             }
                                                             else{
                                                                 Stock_In_Channel__c newSIC = new Stock_In_Channel__c();
                                                                 account a = [select id,SAP_Code__c from account where id = :customerId];
                                                                 Territory_Distributor__c t = [select id from Territory_Distributor__c where id = :territoryId];
                                                                 Sales_Org__c SO = [select id from Sales_Org__c where Sales_Org_Code__c = '5191'];
                                                                 newSIC.Channel__c = a.id;
                                                                 newSIC.Sales_Rep__c = userinfo.getuserid();
                                                                 newSIC.Territory__c = t.id;
                                                                 newSIC.Sales_Org__c = SO.id;
                                                                 newSIC.Year__c = string.valueOf(System.Today().year()-1);
                                                                 newSIC.Combination_Key__c = SalesOrg+string.valueOf(System.Today().year()-1)+a.SAP_Code__c;
                                                                 string currentMonthdesc = currentMonth+'_Description__c'; 
                                                                 string previousMonthdesc = previousMonth+'_Description__c';                                             
                                                                 string previous2Monthdesc = previous2Month+'_Description__c'; 
                                                                 //newSIC.put(currentMonthdesc, description);
                                                                 newSIC.put(previousMonthdesc, Olddescription);
                                                                 newSIC.put(previous2Monthdesc, Old2description);
                                                                 insert newSIC;
                                                                 //return newSIC.Id;
                                                             }
                                                             
                                                             if(!string.isBlank(stockInChannelId)){
                                                                 Stock_In_Channel__c a =  [select id from Stock_In_Channel__c where id = :stockInChannelId];
                                                                 string currentMonthdesc = currentMonth+'_Description__c'; 
                                                                 string previousMonthdesc = previousMonth+'_Description__c';                                             
                                                                 string previous2Monthdesc = previous2Month+'_Description__c';
                                                                 
                                                                 a.put(currentMonthdesc, description);
                                                                 //a.put(previousMonthdesc, Olddescription);
                                                                 //a.put(previous2Monthdesc, Old2description);
                                                                 a.Sales_Rep__c = userinfo.getuserid();
                                                                 update a;
                                                                 return a.Id;
                                                                 
                                                             }
                                                             else{
                                                                 
                                                                 Stock_In_Channel__c newSIC = new Stock_In_Channel__c();
                                                                 account a = [select id,SAP_Code__c from account where id = :customerId];
                                                                 Territory_Distributor__c t = [select id from Territory_Distributor__c where id = :territoryId];
                                                                 Sales_Org__c SO = [select id from Sales_Org__c where Sales_Org_Code__c = '5191'];
                                                                 newSIC.Channel__c = a.id;
                                                                 newSIC.Sales_Rep__c = userinfo.getuserid();
                                                                 newSIC.Territory__c = t.id;
                                                                 newSIC.Sales_Org__c = SO.id;
                                                                 newSIC.Year__c = string.valueOf(System.Today().year());
                                                                 newSIC.Combination_Key__c = SalesOrg+string.valueOf(System.Today().year())+a.SAP_Code__c;
                                                                 string currentMonthdesc = currentMonth+'_Description__c'; 
                                                                 string previousMonthdesc = previousMonth+'_Description__c';                                             
                                                                 string previous2Monthdesc = previous2Month+'_Description__c'; 
                                                                 newSIC.put(currentMonthdesc, description);
                                                                 //newSIC.put(previousMonthdesc, Olddescription);
                                                                 //newSIC.put(previous2Monthdesc, Old2description);
                                                                 insert newSIC;
                                                                 return newSIC.Id;
                                                             }
                                                         }
                                                         //january ends
                                                         //february
                                                         else if(currentMonth == 'February'){
                                                             
                                                             account acc = [select id,SAP_Code__c from account where id = :customerId];
                                                             string LYCombinationKey = SalesOrg+string.valueOf(System.Today().year()-1)+acc.SAP_Code__c;
                                                             system.debug('LYCombinationKey'+LYCombinationKey);
                                                             list<Stock_In_Channel__c> stockInChannelLY = [select id from Stock_In_Channel__c where Combination_Key__c = :LYCombinationKey];
                                                             system.debug('stockInChannelLY'+stockInChannelLY);
                                                             if(stockInChannelLY.size()>0){
                                                                 Stock_In_Channel__c a =  [select id from Stock_In_Channel__c where id = :stockInChannelLY[0].Id];
                                                                 string currentMonthdesc = currentMonth+'_Description__c'; 
                                                                 string previousMonthdesc = previousMonth+'_Description__c';                                             
                                                                 string previous2Monthdesc = previous2Month+'_Description__c';
                                                                 
                                                                 //a.put(currentMonthdesc, description);
                                                                 //a.put(previousMonthdesc, Olddescription);
                                                                 a.put(previous2Monthdesc, Old2description);
                                                                 a.Sales_Rep__c = userinfo.getuserid();
                                                                 update a;
                                                                 //return a.Id;
                                                             }
                                                             else{
                                                                 Stock_In_Channel__c newSIC = new Stock_In_Channel__c();
                                                                 account a = [select id,SAP_Code__c from account where id = :customerId];
                                                                 Territory_Distributor__c t = [select id from Territory_Distributor__c where id = :territoryId];
                                                                 Sales_Org__c SO = [select id from Sales_Org__c where Sales_Org_Code__c = '5191'];
                                                                 newSIC.Channel__c = a.id;
                                                                 newSIC.Sales_Rep__c = userinfo.getuserid();
                                                                 newSIC.Territory__c = t.id;
                                                                 newSIC.Sales_Org__c = SO.id;
                                                                 newSIC.Year__c = string.valueOf(System.Today().year()-1);
                                                                 newSIC.Combination_Key__c = SalesOrg+string.valueOf(System.Today().year()-1)+a.SAP_Code__c;
                                                                 string currentMonthdesc = currentMonth+'_Description__c'; 
                                                                 string previousMonthdesc = previousMonth+'_Description__c';                                             
                                                                 string previous2Monthdesc = previous2Month+'_Description__c'; 
                                                                 //newSIC.put(currentMonthdesc, description);
                                                                 //newSIC.put(previousMonthdesc, Olddescription);
                                                                 newSIC.put(previous2Monthdesc, Old2description);
                                                                 insert newSIC;
                                                                 //return newSIC.Id;
                                                             }
                                                             
                                                             if(!string.isBlank(stockInChannelId)){
                                                                 Stock_In_Channel__c a =  [select id from Stock_In_Channel__c where id = :stockInChannelId];
                                                                 string currentMonthdesc = currentMonth+'_Description__c'; 
                                                                 string previousMonthdesc = previousMonth+'_Description__c';                                             
                                                                 string previous2Monthdesc = previous2Month+'_Description__c';
                                                                 
                                                                 a.put(currentMonthdesc, description);
                                                                 a.put(previousMonthdesc, Olddescription);
                                                                 //a.put(previous2Monthdesc, Old2description);
                                                                 a.Sales_Rep__c = userinfo.getuserid();
                                                                 update a;
                                                                 return a.Id;
                                                                 
                                                             }
                                                             else{
                                                                 
                                                                 Stock_In_Channel__c newSIC = new Stock_In_Channel__c();
                                                                 account a = [select id,SAP_Code__c from account where id = :customerId];
                                                                 Territory_Distributor__c t = [select id from Territory_Distributor__c where id = :territoryId];
                                                                 Sales_Org__c SO = [select id from Sales_Org__c where Sales_Org_Code__c = '5191'];
                                                                 newSIC.Channel__c = a.id;
                                                                 newSIC.Sales_Rep__c = userinfo.getuserid();
                                                                 newSIC.Territory__c = t.id;
                                                                 newSIC.Sales_Org__c = SO.id;
                                                                 newSIC.Year__c = string.valueOf(System.Today().year());
                                                                 newSIC.Combination_Key__c = SalesOrg+string.valueOf(System.Today().year())+a.SAP_Code__c;
                                                                 string currentMonthdesc = currentMonth+'_Description__c'; 
                                                                 string previousMonthdesc = previousMonth+'_Description__c';                                             
                                                                 string previous2Monthdesc = previous2Month+'_Description__c'; 
                                                                 newSIC.put(currentMonthdesc, description);
                                                                 newSIC.put(previousMonthdesc, Olddescription);
                                                                 //newSIC.put(previous2Monthdesc, Old2description);
                                                                 insert newSIC;
                                                                 return newSIC.Id;
                                                             }                                                           }
                                                         //february ends
                                                         
                                                         else{
                                                             if(!string.isBlank(stockInChannelId)){
                                                                 Stock_In_Channel__c a =  [select id from Stock_In_Channel__c where id = :stockInChannelId];
                                                                 string currentMonthdesc = currentMonth+'_Description__c'; 
                                                                 string previousMonthdesc = previousMonth+'_Description__c';                                             
                                                                 string previous2Monthdesc = previous2Month+'_Description__c';
                                                                 
                                                                 a.put(currentMonthdesc, description);
                                                                 a.put(previousMonthdesc, Olddescription);
                                                                 a.put(previous2Monthdesc, Old2description);
                                                                 a.Sales_Rep__c = userinfo.getuserid();
                                                                 update a;
                                                                 return a.Id;
                                                                 
                                                             }
                                                             else{
                                                                 
                                                                 Stock_In_Channel__c newSIC = new Stock_In_Channel__c();
                                                                 account a = [select id,SAP_Code__c from account where id = :customerId];
                                                                 Territory_Distributor__c t = [select id from Territory_Distributor__c where id = :territoryId];
                                                                 Sales_Org__c SO = [select id from Sales_Org__c where Sales_Org_Code__c = '5191'];
                                                                 newSIC.Channel__c = a.id;
                                                                 newSIC.Sales_Rep__c = userinfo.getuserid();
                                                                 newSIC.Territory__c = t.id;
                                                                 newSIC.Sales_Org__c = SO.id;
                                                                 newSIC.Year__c = string.valueOf(System.Today().year());
                                                                 newSIC.Combination_Key__c = SalesOrg+string.valueOf(System.Today().year())+a.SAP_Code__c;
                                                                 string currentMonthdesc = currentMonth+'_Description__c'; 
                                                                 string previousMonthdesc = previousMonth+'_Description__c';                                             
                                                                 string previous2Monthdesc = previous2Month+'_Description__c'; 
                                                                 newSIC.put(currentMonthdesc, description);
                                                                 newSIC.put(previousMonthdesc, Olddescription);
                                                                 newSIC.put(previous2Monthdesc, Old2description);
                                                                 insert newSIC;
                                                                 return newSIC.Id;
                                                             }
                                                         } 
                                                     }
    
    @auraenabled
    public static void resetStockMethod(List<Id> SKUIds, 
                                        string currentMonth,
                                        string previousMonth,
                                        string previous2Month
                                       ){
                                           string currentMonthVol= currentMonth+'_Volume__c';                                 
                                           
                                           list<Stock_In_Channel_Detail__c> liStockInChannelDetails = Database.query('select id, January_Volume__c, January_Volume_Co__c,January_Sales__c, February_Volume__c, February_Volume_Co__c, February_Sales__c, March_Volume__c, March_Volume_Co__c, March_Sales__c, April_Volume__c, April_Volume_Co__c,April_Sales__c, May_Volume__c, May_Volume_Co__c,May_Sales__c, June_Volume__c, June_Volume_Co__c, June_Sales__c, July_Volume__c, July_Volume_Co__c,July_Sales__c, August_Volume__c, August_Volume_Co__c, August_Sales__c, September_Volume__c, September_Volume_Co__c, September_Sales__c, October_Volume__c, October_Volume_Co__c, October_Sales__c, November_Volume__c, November_Volume_Co__c, November_Sales__c, December_Volume__c, December_Volume_Co__c, December_Sales__c, Combination_Key__c FROM Stock_In_Channel_Detail__c where SKU__c = :SKUIds');                                
                                           system.debug('liStockInChannelDetails'+liStockInChannelDetails);                                                    
                                           for (Stock_In_Channel_Detail__c StockInChannelDetail:liStockInChannelDetails){  
                                               StockInChannelDetail.put(currentMonthVol, null);
                                           }
                                           update liStockInChannelDetails;
                                           
                                       }
    
    
    @auraenabled
    public static void copyStockMethod(List<Id> SKUIds, 
                                       string currentMonth,
                                       string previousMonth,
                                       string previous2Month
                                      ){
                                          string currentMonthVol= currentMonth+'_Volume__c';
                                          string previousMonthVol= previousMonth+'_Volume__c';
                                          decimal PrevMonth;
                                          list<Stock_In_Channel_Detail__c> liStockInChannelDetails = Database.query('select id, January_Volume__c, January_Volume_Co__c,January_Sales__c, February_Volume__c, February_Volume_Co__c, February_Sales__c, March_Volume__c, March_Volume_Co__c, March_Sales__c, April_Volume__c, April_Volume_Co__c,April_Sales__c, May_Volume__c, May_Volume_Co__c,May_Sales__c, June_Volume__c, June_Volume_Co__c, June_Sales__c, July_Volume__c, July_Volume_Co__c,July_Sales__c, August_Volume__c, August_Volume_Co__c, August_Sales__c, September_Volume__c, September_Volume_Co__c, September_Sales__c, October_Volume__c, October_Volume_Co__c, October_Sales__c, November_Volume__c, November_Volume_Co__c, November_Sales__c, December_Volume__c, December_Volume_Co__c, December_Sales__c, Combination_Key__c FROM Stock_In_Channel_Detail__c where SKU__c = :SKUIds');                                
                                          system.debug('liStockInChannelDetails'+liStockInChannelDetails);                                                    
                                          for (Stock_In_Channel_Detail__c StockInChannelDetail:liStockInChannelDetails){  
                                              PrevMonth = (decimal)StockInChannelDetail.get(previousMonthVol);
                                              system.debug('PrevMonth'+PrevMonth);
                                              StockInChannelDetail.put(currentMonthVol, PrevMonth);
                                          }
                                          update liStockInChannelDetails;
                                          
                                      }
    
    @auraenabled
    public static string upsertStockInChannelDetailsMonth(string SKUId,  
                                                          decimal Month,
                                                          string StockInChannelId,
                                                          string customerId,
                                                          string territoryId,
                                                          string monthLable
                                                         ){
                                                              
                                                             
                                                             if(string.isBlank(StockInChannelId)){
                                                                 
                                                                 Stock_In_Channel__c newSIC = new Stock_In_Channel__c();
                                                                 account a = [select id,SAP_Code__c from account where id = :customerId];
                                                                 Territory_Distributor__c t = [select id from Territory_Distributor__c where id = :territoryId];
                                                                 Sales_Org__c SO = [select id from Sales_Org__c where Sales_Org_Code__c = '5191'];
                                                                 newSIC.Channel__c = a.id;
                                                                 newSIC.Territory__c = t.id;
                                                                 newSIC.Sales_Org__c = SO.id;
                                                                 newSIC.Year__c = string.valueOf(System.Today().year());
                                                                 newSIC.Combination_Key__c = string.valueOf(System.Today().year())+a.SAP_Code__c;
                                                                 newSIC.Sales_Rep__c = userinfo.getuserid();
                                                                
                                                                 insert newSIC;
                                                                 StockInChannelId = newSIC.Id;
                                                                 
                                                                                                                                
                                                             }
                                                             
                                                             List<Stock_In_Channel_Detail__c> SICD = [select id from Stock_In_Channel_Detail__c 
                                                                                                      where SKU__C = :SKUId 
                                                                                                      and Stock_In_Channel__c = :StockInChannelId];
                                                             string updatedMonthLable = monthLable+'_Volume__c'; 
                                                             system.debug('updatedMonthLable'+updatedMonthLable); 
                                                             
                                                             if(SICD.isEmpty()){
                                                                 Stock_In_Channel_Detail__c newSICD = new Stock_In_Channel_Detail__c();
                                                                 account a = [select id,SAP_Code__c from account where id = :customerId];
                                                                 SKU__c SKU = [select id,SKU_Code__c from SKU__c where Sales_Org_Code__c='5191' AND id = :SKUId];
                                                                 newSICD.SKU__c = SKUId;
                                                                 newSICD.Stock_In_Channel__c = StockInChannelId;
                                                                 newSICD.Combination_Key__c = string.valueOf(System.Today().year())+a.SAP_Code__c+SKU.SKU_Code__c;
                                                                 newSICD.put(updatedMonthLable, Month);
                                                                 
                                                                 
                                                                 insert newSICD;
                                                                 
                                                                
                                                                 Stock_In_Channel__c oldSIC = [select Sales_Rep__c from Stock_In_Channel__c where id = :StockInChannelId];
                                                                 if(oldSIC.Sales_Rep__c != userinfo.getuserid()){
                                                                     oldSIC.Sales_Rep__c = userinfo.getuserid();
                                                                     update oldSIC;
                                                                 }
                                                             }
                                                             else{
                                                                 
                                                                 SICD[0].put(updatedMonthLable, Month);
                                                                 
                                                                 
                                                                 update SICD;
                                                                 Stock_In_Channel__c oldSIC = [select Sales_Rep__c from Stock_In_Channel__c where id = :StockInChannelId];
                                                                 if(oldSIC.Sales_Rep__c != userinfo.getuserid()){
                                                                     oldSIC.Sales_Rep__c = userinfo.getuserid();
                                                                     update oldSIC;
                                                                 }
                                                                 
                                                             }
                                                             
                                                             return StockInChannelId;
                                                             
                                                         }
    
    //Wrapper for SICException Wrapper
    public class SICExceptionWrapper {
        
        @AuraEnabled
        public boolean isValid {get;set;} 
        @AuraEnabled
        public decimal OldValue {get;set;}
       
               
    }
    
    @auraenabled
    public static SICExceptionWrapper SICSKUExc(string SKUId, 
                                                string customerId){
                                                    SICExceptionWrapper SICEW = new SICExceptionWrapper();
                                                   
                                                    list<SIC_Exception__c> liSICException = [select id from SIC_Exception__c
                                                                                             where SKU__c = :SKUId
                                                                                             and Customer__c = :customerId
                                                                                             and Sales_Rep__c = :userinfo.getuserId()
                                                                                             and Month__c = :string.valueOf(date.today().month()).leftPad(2,'0')
                                                                                             and Year__c = :date.today().year()];
                                                    
                                                    system.debug('liSICException '+liSICException);
                                                    DateTime dt = DateTime.now();
                                                    String monthName = dt.format('MMMMM')+'_Volume__c';
                                                    System.debug('Month Name : ' + monthName);
                                                    
                                                    list<Stock_In_Channel_Detail__c> liSICD = [select January_Volume__c, February_Volume__c,
                                                                                               March_Volume__c, April_Volume__c, May_Volume__c,
                                                                                               June_Volume__c, July_Volume__c, August_Volume__c,
                                                                                               September_Volume__c, October_Volume__c, November_Volume__c,
                                                                                               December_Volume__c 
                                                                                               from Stock_In_Channel_Detail__c
                                                                                               where SKU__c = :SKUId and 
                                                                                               Stock_In_Channel__r.Channel__c = :customerId];
                                                    
                                                    
                                                    if(liSICException.size()>0){
                                                        
                                                        SICEW.isValid = true;
                                                    }
                                                    else{
                                                        
                                                        SICEW.isValid = false;
                                                        if(liSICD.size()>0){
                                                            SICEW.OldValue = (decimal)liSICD[0].get(monthName);
                                                        }
                                                    }
                                                     system.debug('SICEW '+SICEW);
                                                    return SICEW;
                                                }
    
    
    
    
}