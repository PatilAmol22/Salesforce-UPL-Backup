public class StockInChannelServiceHelper {
    
    
    
    public static boolean GetStockInChannel(GetStockInChannelRequestWrapper sic)
    {
        
        try{
            DateTime startDate = System.Date.today().toStartOfMonth(); 
            //DateTime startDate=date.valueOf('2020-03-04').toStartOfMonth();
            DateTime endDate = startDate.addMonths(0).addDays(-1);
            String lastDate = endDate.format('yyyy-MM-dd'); 
            DateTime dt= startDate.addMonths(-3);
            String start=dt.format('yyyy-MM-dd'); 
            System.debug('Debug 1: '+dt);
            system.debug('value is last date '+ lastdate + 'start date'+start );
           sic.initialDate=start;
           sic.finalDate=lastDate;
            //sic.initialDate= '2018/01/01'   ;//start;
            //sic.finalDate='2018/05/01';//lastDate;
             map <String,String> mapheader = new map<String,String>();
             map <String,id> mapdetails = new map<String,id>();
             list<Stock_In_Channel__c> lststockinchannel = new list<Stock_In_Channel__c>();    
             list<Stock_In_Channel_Detail__c> lststockinchanneldetails = new list<Stock_In_Channel_Detail__c>();   
       map<String,String> numericMonth= new Map<String,String>();
       numericMonth.put('01','January');
       numericMonth.put('02','February');
       numericMonth.put('03','March');
       numericMonth.put('04','April');
       numericMonth.put('05','May');
       numericMonth.put('06','June');
       numericMonth.put('07','July');
       numericMonth.put('08','August');
       numericMonth.put('09','September');
       numericMonth.put('10','October');
       numericMonth.put('11','November');
       numericMonth.put('12','December');   
           GetStockInChannelResponseWrapper resSIC;
              String username = UPL_Settings__c.getOrgDefaults().HCI_User_Name__c;
           String password = UPL_Settings__c.getOrgDefaults().HCI_Password__c;  
           String url = UPL_Settings__c.getOrgDefaults().Stock_in_Channel_RFC__c;
           String sales_Org = UPL_Settings__c.getOrgDefaults().BR_Sales_Org__c; 
           Integer timeOut = 120000;     
           Http http = new Http();
           HttpRequest request = new HttpRequest(); 
           request.setTimeout(timeOut);
           request.setMethod('POST');
           request.setHeader('Content-Type', 'application/json');
           String json = System.JSON.serializePretty(sic);
           system.debug('json is '+json);
           request.setBody(json);
           request.setEndpoint(url);        
           Blob headerValue = Blob.valueOf(username + ':' + password);
           String authorizationHeader = 'BASIC ' +
           EncodingUtil.base64Encode(headerValue);
           request.setHeader('Authorization', authorizationHeader);
           HttpResponse response;
           if(!Test.isRunningTest()){
               response = http.send(request);
           }
           else{
               // Create a fake response
               response = new HttpResponse();
               response.setHeader('Content-Type', 'application/json');
               response.setBody('{"status":"S","sumByCustomer":[{"skuCode":"000000000006250016","customerCode":"0001033257","yearMonth":"201908","Volume":"200.000","netSales":"17531.92"},{"skuCode":"000000000006250016","customerCode":"0001033257","yearMonth":"201909","Volume":"40.000","netSales":"12522.80"}]}');
               response.setStatusCode(200);
           }
            System.debug('i reached before conversion'+ response.getBody());
            resSIC=(GetStockInChannelResponseWrapper) System.JSON.deserialize(response.getBody(), GetStockInChannelResponseWrapper.class);
            System.debug('i reached After after  conversion'+ resSIC);
            
            if(resSIC.status=='S')
            {
                For(GetStockInChannelResponseWrapper.SumByCustomer salesVol: resSIC.SumByCustomer)
                {
                    String breakYear = salesVol.yearMonth;
                    String year  = breakYear.mid(0, 4);
                    String month = breakYear.mid(4,2);
                    if(mapheader.get(sales_Org+year+salesVol.customerCode) == null)
                    { 
                        mapheader.put(sales_Org+year+salesVol.customerCode,sales_Org+year+salesVol.customerCode);
                        Stock_In_Channel__c st = new Stock_In_Channel__c();
                        st.Year__c= year;
                        st.Combination_Key__c= sales_Org+year+salesVol.customerCode;
                        Account acc = new Account(SAP_Code__c=salesVol.customerCode);
                        st.Channel__r =acc;           
                        lststockinchannel.add(st);
                    }
                }//end of loop
                upsert lststockinchannel Combination_Key__c;
                
                system.debug('values inserted header');
                for(Stock_In_Channel__c st :lststockinchannel)
                {
                    if(mapheader.containskey(st.Combination_Key__c))
                    {
                        mapheader.put(st.Combination_Key__c,st.Id);
                    }
                    system.debug('value is '+ st.Combination_Key__c);
                    system.debug('value is '+ st.Id);
                }
                
                
              map<String ,Stock_In_Channel_Detail__c> combinemap= new map <String ,Stock_In_Channel_Detail__c>(); 
                For(GetStockInChannelResponseWrapper.SumByCustomer salesVol: resSIC.SumByCustomer)
               {
                    String lastmonth= salesVol.Volume.trim();
                       if (lastmonth ==''|| lastmonth == null|| lastmonth ==' ')
                       {
                           lastmonth='0';
                       }
                   
                    String breakYear = salesVol.yearMonth;
                    String year  = breakYear.mid(0, 4);
                    String month = breakYear.mid(4,2);
                       
                    String monthEng;
                       if(numericMonth.containsKey(month))
                       {
                       monthEng= numericMonth.get(month);
                       }
                       if(mapdetails.get(sales_Org+year+salesVol.customerCode+salesVol.skuCode) == null && mapheader.containskey(sales_Org+year+salesVol.customerCode))
                       {
                               mapdetails.put(sales_Org+year+salesVol.customerCode+salesVol.skuCode,id.valueOf(mapheader.get(sales_Org+year+salesVol.customerCode)));     
                       }
                       
                       if(combinemap.get(sales_Org+year+salesVol.customerCode+salesVol.skuCode) == null && mapheader.containskey(sales_Org+year+salesVol.customerCode))
                       {
                           Stock_In_Channel_Detail__c de = new Stock_In_Channel_Detail__c();
                           
                           de.put(monthEng+'_Sales__c',decimal.valueOf(salesVol.Volume).setScale(2));
                        //    SKU__c sk = new SKU__c(SKU_Code__c=salesVol.skuCode);
                        //    de.SKU__r= sk;
                        // Since in some places we have multiple SKU So We need to consider Only 5191 sales org code
                        List<SKU__c> skuList = [SELECT Id FROM SKU__c 
                                                WHERE SKU_Code__c =: salesVol.skuCode 
                                                AND Sales_org_Code__c ='5191' LIMIT 1];
                        // Check null condition
                        System.debug('The Map Values in ifselse3 Entry'+skuList);
                        if(!skuList.isEmpty()){
                            System.debug('SKU Entry'+skuList[0].Id);
                            de.SKU__c = skuList[0].Id;
                        }
                           de.Combination_Key__c= sales_Org+year+salesVol.customerCode+salesVol.skuCode; 
                           de.Stock_In_Channel__c= mapdetails.get(sales_Org+year+salesVol.customerCode+salesVol.skuCode); 
                           combinemap.put(sales_Org+year+salesVol.customerCode+salesVol.skuCode,de);  
                           system.debug('i reached '+ de);
                       }
                       else
                       {
                           if(mapheader.containskey(sales_Org+year+salesVol.customerCode))
                           {
                            System.debug('The Map Values in ifselse3 Entry'+combinemap.values());
                               Stock_In_Channel_Detail__c change =combinemap.get(sales_Org+year+salesVol.customerCode+salesVol.skuCode); 
                               change.put(monthEng+'_Sales__c',decimal.valueOf(salesVol.Volume).setScale(2));
                               combinemap.put(sales_Org+year+salesVol.customerCode+salesVol.skuCode,change); 
                               System.debug('The Map Values in ifselse3'+combinemap.values());
                           }
                       }
                   }
                   System.debug('The Map Values'+combinemap.values());
                upsert combinemap.values() Combination_Key__c;
                System.debug('values inserted success details');
                return true;
                }
                
               return false; 
            }
           
        
      catch(Exception ex)
      {
          System.debug('ex No: '+ex.getLineNumber()+' ex Msg: '+ex.getMessage()); 
          String service ='GetStockInChannel';
          //TransactionLogHandler.addTransactionEntryRebate(ex,service);
          return false;    
      }
    }
       
}