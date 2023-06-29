/*******************************************************************************************
* @Name         Non Forecast Accounts Metrics Update
* @Author       Nikhil Dhoke
* @Date         13/09/2022
* @Group        SKI
* @Description  For the Open Order data present in the system during Forecast Generation, the data for all Customers which are not part of
                the Forecasting will be considered and added in the Open Orders and Open Orders Delayed metrics of the Spot Customer
                of the respective Region.
*******************************************************************************************/
global class NonForecastAccountMetricsUpdateBatch implements Database.Batchable<sObject>{

    global String month = '';
    global String year = '';
    global String email = '';

    /*
    * @Description - This batch get called from UpdateMetricsBatchNoOne or UpdateMetricsBatchNoTwo or UpdateMetricsBatchNoThree. Constructor which initialises all the respective input values with the instance variables.
    * @Param String - month, year, email id
    * @return  - N/A.
    */
    public NonForecastAccountMetricsUpdateBatch(String mnth, String yr, String eml) {
        this.month = mnth;
        this.year = yr;
        this.email = eml;

        /*system.debug('NonForecastAccountMetricsUpdateBatch ****');
        system.debug('year>>----->'+ this.year);
        system.debug('month>>----->'+ this.month);
        system.debug('email>>----->'+ this.email);*/
    }

    /*
    * @Description - Standard method of a Batchable interface which get called after constructor.
    * @Param - BatchableContext
    * @return  - query result.
    */
    global Database.QueryLocator start(Database.BatchableContext BC){
        String filter = 'Spot%';
        String query = 'SELECT Id, Name, AccountId, Account.SAP_Code__c, Active_Forecast_Month_Number__c, Active_Forecast_Month__c, '+
                       +' Combination_Key__c, Region__c, Region__r.TerritoryCode__c, Sale_Org_Code__c, Year__c, SA_Status__c '+
                       +' FROM SalesAgreement WHERE Active_Forecast_Month__c=\''+ this.month + '\' AND Year__c = \''+ this.year + '\' '+
                       +' AND Account.SAP_Code__c LIKE \''+ filter + '\'';
        if(Test.isRunningTest()){
            query += ' LIMIT 1';
        }
        return Database.getQueryLocator(query);
    }

    /*
    * @Description - Standard method of a Batchable interface which get called after start method. Open and Open order delay 
    *				 values get sumup against the Spot account of that respective territory.
    * @Param - BatchableContext, List of SalesAgreement
    * @return  - N/A.
    */
    global void execute(Database.BatchableContext BC, List<SalesAgreement> scope){
        try{
            if(scope.size()>0){
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

                Set<String> territoryCodes = new Set<String>();
                Set<String> sapCodes = new Set<String>();
                Set<String> saIds = new Set<String>();
                String monthNum = String.valueOf(getMonthNumber(this.month));
                
                String todate = '01/'+monthNum+'/'+this.year;
                Date forecastDate = Date.parse(todate);
                System.debug('Forecast Date - '+ forecastDate);
                for(SalesAgreement sa : scope){
                    territoryCodes.add(sa.Region__r.TerritoryCode__c);
                    sapCodes.add(sa.Account.SAP_Code__c);
                    saIds.add(sa.Id);
                }
                String spotSAP = new List<String> (sapCodes).get(0);
                /*System.debug('territoryCodes - '+ JSON.serializePretty(territoryCodes));
                System.debug('sapCodes - '+ JSON.serializePretty(sapCodes));
                System.debug('saIds - '+ JSON.serializePretty(saIds));*/

                Set<Id> forecastAccIds = new Set<Id>();
                for(Forecast_Account__c fa : [SELECT Id, Name, Combination_Key__c, Account__c, Dummy_Customer__c, Territory__c, Territory__r.TerritoryCode__c  
                                              FROM Forecast_Account__c WHERE Territory__r.TerritoryCode__c IN : territoryCodes]){

                    forecastAccIds.add(fa.Account__c);
                }
                List<Actual_Order__c> actualOrders = [SELECT Id, Name, Business_Unit__c, Customer__c, Customer__r.SAP_Code__c, Data_de_Faturamento__c, Formated_Net_Sales_ORD__c, 
                                                  Net_Sales_ORD__c, Product__c, Product__r.SKU_Code__c, Qty_ORD__c, Region__c, Regional_Code__c, Sales_Rep__c, Region__r.Sales_Org_Code__c, 
                                                  Region__r.TerritoryCode__c FROM Actual_Order__c WHERE Customer__c NOT IN : forecastAccIds AND
                                                  Region__r.TerritoryCode__c IN : territoryCodes AND Data_de_Faturamento__c <:forecastDate];
              Map<String,Double> delayActualOrderMap = new Map<String,Double>(); 
                Map<String,Double> delayActualRevenuMap=new Map<String,Double>();
                if(actualOrders.size()>0){
                    for(Actual_Order__c aoObj : actualOrders){
                        String monthVal = String.valueOf(forecastDate.month());
                        Integer intMonth = forecastDate.month();
                        if(intMonth<10){
                            monthVal ='0'+monthVal;
                        }
                        String strYear = String.valueOf(forecastDate.year());
                        String monthName = monthPeriodMap.get(intMonth);
                        Integer curYear = Date.Today().Year();

                        String combKey = aoObj.Region__r.Sales_Org_Code__c+''+spotSAP+''+aoObj.Region__r.TerritoryCode__c+''+monthVal+''+curYear+''+aoObj.Product__r.SKU_Code__c+''+monthName+' \''+strYear.right(2); 
                        System.debug('combKey'+combKey);
                        if(delayActualOrderMap.containsKey(combKey)){
                            Double val = delayActualOrderMap.get(combKey);
                            val += aoObj.Qty_ORD__c;
                            delayActualOrderMap.put(combKey,val);
                        }
                        else{
                            delayActualOrderMap.put(combKey,aoObj.Qty_ORD__c);
                        }

                        if(delayActualRevenuMap.containsKey(combKey)){
                            Double val = delayActualRevenuMap.get(combKey);
                            val += aoObj.Net_Sales_ORD__c;
                            delayActualRevenuMap.put(combKey,val);
                        }
                        else{
                            delayActualRevenuMap.put(combKey,aoObj.Net_Sales_ORD__c);
                        }
                    }
                } 

               // System.debug('forecastAccIds - '+ JSON.serializePretty(forecastAccIds));
                List<Open_Order__c> openOrders = [SELECT Id, Name, Business_Unit__c, Customer__c, Customer__r.SAP_Code__c, Data_de_Faturamento__c, Formated_Net_Sales_ORD__c, 
                                                  Net_Sales_ORD__c, Product__c, Product__r.SKU_Code__c, Qty_ORD__c, Region__c, Regional_Code__c, Sales_Rep__c, Region__r.Sales_Org_Code__c, 
                                                  Region__r.TerritoryCode__c FROM Open_Order__c WHERE Customer__c NOT IN : forecastAccIds AND
                                                  Region__r.TerritoryCode__c IN : territoryCodes AND Data_de_Faturamento__c >= :forecastDate];

                Map<String,Double> openOrderMap = new Map<String,Double>();
                Map<String,Double> openRevenuMap=new Map<String,Double>();
                
                if(openOrders.size()>0){
                    for(Open_Order__c oo : openOrders){
                        Date dateOfFacture = oo.Data_de_Faturamento__c;
                        Integer monthVal = dateOfFacture.month();
                        String monthName = monthPeriodMap.get(monthVal);
                        Integer yearVal = dateOfFacture.year();
                        String combKey = oo.Product__r.SKU_Code__c+''+spotSAP+''+oo.Region__r.TerritoryCode__c+''+yearVal+''+monthName;
                        if(openOrderMap.containsKey(combKey)){
                            Double val = openOrderMap.get(combKey);
                            val += oo.Qty_ORD__c;
                            openOrderMap.put(combKey,val);
                        }
                        else{
                            openOrderMap.put(combKey,oo.Qty_ORD__c);
                        }

                        if(openRevenuMap.containsKey(combKey)){
                            Double val = openRevenuMap.get(combKey);
                            val += oo.Net_Sales_ORD__c;
                            openRevenuMap.put(combKey,val);
                        }
                        else{
                            openRevenuMap.put(combKey,oo.Net_Sales_ORD__c);
                        }

                    }
                }  
                //System.debug('Open Order Map - '+ JSON.serializePretty(openOrderMap));
                List<Open_Order__c> delayOrders = [SELECT Id, Name, Business_Unit__c, Customer__c, Customer__r.SAP_Code__c, Data_de_Faturamento__c, Formated_Net_Sales_ORD__c, 
                                                  Net_Sales_ORD__c, Product__c, Product__r.SKU_Code__c, Qty_ORD__c, Region__c, Regional_Code__c, Sales_Rep__c, Region__r.Sales_Org_Code__c, 
                                                  Region__r.TerritoryCode__c FROM Open_Order__c WHERE Customer__c NOT IN : forecastAccIds AND 
                                                  Region__r.TerritoryCode__c IN : territoryCodes AND Data_de_Faturamento__c < :forecastDate];                                     

                Map<String,Double> delayOrderMap = new Map<String,Double>(); 
                Map<String,Double> delayRevenuMap=new Map<String,Double>();
                if(delayOrders.size()>0){
                    for(Open_Order__c ooObj : delayOrders){
                        String monthVal = String.valueOf(forecastDate.month());
                        Integer intMonth = forecastDate.month();
                        if(intMonth<10){
                            monthVal ='0'+monthVal;
                        }
                        String strYear = String.valueOf(forecastDate.year());
                        String monthName = monthPeriodMap.get(intMonth);
                        Integer curYear = Date.Today().Year();

                        String combKey = ooObj.Region__r.Sales_Org_Code__c+''+spotSAP+''+ooObj.Region__r.TerritoryCode__c+''+monthVal+''+curYear+''+ooObj.Product__r.SKU_Code__c+''+monthName+' \''+strYear.right(2); 
                        if(delayOrderMap.containsKey(combKey)){
                            Double val = delayOrderMap.get(combKey);
                            val += ooObj.Qty_ORD__c;
                            delayOrderMap.put(combKey,val);
                        }
                        else{
                            delayOrderMap.put(combKey,ooObj.Qty_ORD__c);
                        }

                        if(delayRevenuMap.containsKey(combKey)){
                            Double val = delayRevenuMap.get(combKey);
                            val += ooObj.Net_Sales_ORD__c;
                            delayRevenuMap.put(combKey,val);
                        }
                        else{
                            delayRevenuMap.put(combKey,ooObj.Net_Sales_ORD__c);
                        }
                    }
                }
                //System.debug('Delay Order Map - '+ JSON.serializePretty(delayOrderMap));
                List<SalesAgreementProductSchedule> sapsList = new List<SalesAgreementProductSchedule>();
                for(SalesAgreementProductSchedule saps : [SELECT Id, Name, SalesAgreementProduct.SalesAgreementId, SalesAgreementProductId, StartDate, 
                                                            EndDate, Month__c, Year__c, PlannedQuantity, Combination_Key__c, 
                                                            SalesAgreementProduct.SalesAgreement.Account.SAP_Code__c, Open_Order_Delayed_QTY__c, 
                                                            SalesAgreementProduct.PricebookEntry.Product2.Product_code__c, 
                                                            SalesAgreementProduct.SalesAgreement.Region__r.TerritoryCode__c, 
                                                            SalesAgreementProduct.SalesAgreement.Year__c, SalesAgreementProduct.SalesAgreement.Sale_Org_Code__c, 
                                                            SalesAgreementProduct.SalesAgreement.Active_Forecast_Month_Number__c, 
                                                            SalesAgreementProduct.SalesAgreement.Active_Forecast_Month__c, 
                                                            SalesAgreementProduct.SalesAgreement.StartDate, Open_Order_Revenue__c, 
                                                            Open_Order_QTY__c, Open_Order_Delayed_Revenue__c
                                                            FROM SalesAgreementProductSchedule 
                                                            WHERE SalesAgreementProduct.SalesAgreement.Id IN: saIds]){

                    String recordName=saps.Name;  
                    String monthShort = recordName.substring(0, 3);  
                    String recordYear = recordName.substring(5);
                    String cyearStr=String.valueOf(Date.Today().Year()).substring(0,2);
                    recordYear = cyearStr+recordYear;           
                    Boolean flag = false;           

                    String openKey = saps.SalesAgreementProduct.PricebookEntry.Product2.Product_code__c+''+saps.SalesAgreementProduct.SalesAgreement.Account.SAP_Code__c+''+saps.SalesAgreementProduct.SalesAgreement.Region__r.TerritoryCode__c+''+recordYear+monthShort; 
                   String actualKey = saps.Combination_Key__c;
                    String delayKey = saps.Combination_Key__c;
                    //System.debug('openKey - '+ openKey);
                    if(openOrderMap.containsKey(openKey)){
                        flag = true;
                        saps.Open_Order_QTY__c = openOrderMap.get(openKey).intValue();
                    }
                   System.debug('delayKey - '+ delayKey);
                    if(delayOrderMap.containsKey(delayKey)){
                        flag = true;
                        saps.Open_Order_Delayed_QTY__c = delayOrderMap.get(delayKey).intValue();
                    }

                    if(openRevenuMap.containsKey(openKey)){
                        flag = true;
                        saps.Open_Order_Revenue__c = openRevenuMap.get(openKey);
                    }

                    if(delayRevenuMap.containsKey(delayKey)){
                        flag = true;
                        saps.Open_Order_Delayed_Revenue__c = delayRevenuMap.get(delayKey);
                    }
                    if(delayActualOrderMap.containsKey(openKey)){
                        flag = true;
                        saps.Actual_Order_QTY__c = delayActualOrderMap.get(actualKey).intValue();
                    }
                    if(delayActualRevenuMap.containsKey(delayKey)){
                        flag = true;
                        saps.Actual_Order_Delayed_Revenue__c = delayActualRevenuMap.get(delayKey);
                    }

                    if(flag == true){
                        sapsList.add(saps);
                    }
                    
                }
                 
                if(sapsList.size()>0){
                    System.debug('SAPS List - '+ JSON.serializePretty(sapsList));
                    update sapsList;
                }
                                             
            }

        }
        catch(Exception ex){
          system.debug('Exception in NonForecastAccountMetricsUpdateBatch execute method ');
          system.debug('Exception is - ' + ex);
          system.debug('Exception at Line no  - ' + ex.getLineNumber());
            RecordType rcdTp = new RecordType();
            rcdTp = [SELECT Id, Name, DeveloperName, Description, SobjectType, IsActive FROM RecordType WHERE 
                          SobjectType = 'Monitor_Log__c' AND DeveloperName = 'Brazil' ORDER BY LastModifiedDate LIMIT 1];
  
            Monitor_Log__c ml=new Monitor_Log__c();
            ml.Line_Number__c=ex.getLineNumber();
            ml.Module__c='NonForecastAccountMetricsUpdateBatch';
            ml.Message__c=ex.getStackTraceString();
            ml.OwnerId = UserInfo.getUserId();
            if(rcdTp != null){
                ml.RecordTypeId = rcdTp.Id;
            }
            insert ml;
        }
    }

    /*
    * @Description - Standard method of a Batchable interface which get called after execute method. This method will send an email.
    * @Param - BatchableContext
    * @return  - N/A.
    */
    global void finish(Database.BatchableContext bc){
        SendMail(this.email,this.month,this.year);
    }

    /*
    * @Description - This method is called in this same batch class from other methods to send mail.
    * @Param - email id, month, year
    * @return  - boolean value.
    */
    public static boolean SendMail(String emailId,String mnth, String yr){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String sub = 'Atualização das Métricas para Forecast: '+getMonthNumber(mnth)+'-'+yr;
        //System.debug('emailId :'+emailId);  
        String[] email = new String[]{emailId,'satkari@skinternational.com'};
        mail.setToAddresses(email);
        mail.setSubject(sub);
        //mail.setPlainTextBody('Total '+lstSalesAgreementProductSchedule.size()+' Metrics Updated Of Sales Agreement Product Schedule');
        mail.setHtmlBody('Prezado Usuário, <br><br> As métricas para o Planejamento de Vendas foram atualizadas com sucesso. <br><br> Atenciosamente,<br> Administração SalesForce UPL');
        Messaging.sendEmail(new Messaging.Singleemailmessage [] {mail});
        return true;
    }

    /*
    * @Description - This method is called in this same batch class from other methods.
    * @Param - month number
    * @return  - month name from map for respective number.
    */
    public static Integer getMonthNumber(String mnth){
        Map<String,Integer> monthMap = new Map<String,Integer>();
            monthMap.put('January',01);
            monthMap.put('February',02);
            monthMap.put('March',03);
            monthMap.put('April',04);
            monthMap.put('May',05);
            monthMap.put('June',06);
            monthMap.put('July',07);
            monthMap.put('August',08);
            monthMap.put('September',09);
            monthMap.put('October',10);
            monthMap.put('November',11);
            monthMap.put('December',12);

        return  monthMap.get(mnth);       
    }

    /*
    * @Description - This method is called in this same batch class from other methods.
    * @Param - month number
    * @return  - month name from map for respective number.
    */
    /* public static String getMonthName(Integer mnth){
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

        return  monthPeriodMap.get(mnth);
    } */

}