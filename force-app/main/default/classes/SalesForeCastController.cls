public without sharing class SalesForeCastController {

    @AuraEnabled
    public static List<String> getYearOptions() {
        List<String> yrList = new List<String>();
        try{
            Schema.DescribeFieldResult fieldResult3 = SalesAgreement.Year__c.getDescribe();
            List<Schema.PicklistEntry> ple3 = fieldResult3.getPicklistValues();
            
            for(Schema.PicklistEntry f3 : ple3){
                yrList.add(f3.getValue());
            } 

        }
        catch(Exception ex){
            system.debug('Exception in getYearOptions method ');
            system.debug('Exception is - ' + ex);
            system.debug('Exception at Line no  - ' + ex.getLineNumber());
        }
        return yrList;
    }

    @AuraEnabled
    public static String getReportID() {
        String str = '';
        try{
            Report rpt = new Report();
            rpt = [SELECT Id, FolderName, Name, DeveloperName FROM Report WHERE DeveloperName='Sales_Agreement_Forecast' 
                    AND FolderName='Brazil Reports' LIMIT 1];
                   
            if(rpt != null){
                str = rpt.Id;
            }        

        }
        catch(Exception ex){
            system.debug('Exception in getReportID method ');
            system.debug('Exception is - ' + ex);
            system.debug('Exception at Line no  - ' + ex.getLineNumber());
        }
        return str;
    }

    @AuraEnabled
    public static String getActiveMonth(){
        String mnthName = '';
        String country ='';
        String salesOrg_Code = '';
        //system.debug('getActiveMonth - ');
        try{
            User user = [SELECT Id, Name, Country, State, Division, IsActive, UserType, 
                        ManagerId FROM User where Id =: UserInfo.getUserId()];

                        //system.debug('UserInfo.getUserId() ****' + UserInfo.getUserId());
        
            Login_Country__c logCntry = [SELECT Id, Name, For_Contry__c FROM Login_Country__c where Name =:user.Country limit 1];

            if(logCntry != null){
                country = logCntry.For_Contry__c;
            }

            if(country == 'Brazil'){
                salesOrg_Code = '5191';
            }
            if(Test.isRunningTest()){
                //system.debug('Test.isRunningTest() **** -' + Test.isRunningTest());
                salesOrg_Code = '5191';
            }

            if(salesOrg_Code != ''){
               List <Sales_Forecast_Setting__c> sfs = new List <Sales_Forecast_Setting__c>();
                sfs = [SELECT Id, Name, CurrencyIsoCode, Sales_Org__c, Sales_Agreement_Schedule_Frequency_Allow__c, 
                        Active_Forecast_Month__c, Schedule_Frequency_Allowed__c, Currency_Allowed__c, 
                        Start_Day_Of_Approval__c, End_Day_Of_Approval__c, Configuration_on_Sales_Forecast_Metric__c, 
                        Clone_the_existing_Forecast_Previous_mon__c, Create_a_forecast_based_on_the__c, 
                        Admin_Profile_Name__c, Start_Day_of_Submission__c, End_Day_of_Submission__c, 
                        Sales_Org__r.Sales_Org_code__c  
                        FROM Sales_Forecast_Setting__c WHERE Sales_Org__r.Sales_Org_code__c =: salesOrg_Code 
                        ORDER BY LastModifiedDate DESC LIMIT 1];

                if(sfs.size() > 0){
                    mnthName = sfs[0].Active_Forecast_Month__c;
                }
            }
            
        }
        catch(Exception ex){
            system.debug('Exception in getActiveMonth method ');
            system.debug('Exception is - ' + ex);
            system.debug('Exception at Line no  - ' + ex.getLineNumber());
        }
        //system.debug('getActiveMonth - ' + mnthName);
        return mnthName;
    }

    @AuraEnabled
    public static String callForecastBatch(String month, String year) {
       // system.debug('SalesForeCastController ****');

        String country ='';
        String salesOrg_Code = '';
        String recordType = '';
        String accountType = '';
        Boolean forecastReq = false;
        String email = '';
        String str = '';

        try{
            List<String> classNames= new List<String>();
            classNames.add('SalesForeCastBatch');
            classNames.add('UpdateMetricsBatchNoOne');
            classNames.add('UpdateMetricsBatchNoTwo');
            classNames.add('UpdateMetricsBatchNoThree');
            
            List<AsyncApexJob> aaj = new List<AsyncApexJob>();
            aaj = [SELECT JobType, Status, ApexClass.Name, Id FROM AsyncApexJob WHERE ApexClass.Name IN: classNames 
                   AND Status = 'Processing' ORDER BY CreatedDate DESC LIMIT 1];

            if(aaj.size()>0){
                str = 'Underprocess';
            }
            else{
                str = 'Initiated';     

                User user = [SELECT Id, Name, Country, State, Division, IsActive, UserType, Email,  
                                ManagerId FROM User where Id =: UserInfo.getUserId()];
                                
                    /* if(user.Email != null){
                        email = user.Email;
                    } */
                    email = Label.Email_Sent_to_SalesRep_or_SDM;
                    //system.debug('UserInfo.getUserId() ****' + UserInfo.getUserId());
                
                Login_Country__c logCntry = [SELECT Id, Name, For_Contry__c FROM Login_Country__c where Name =:user.Country limit 1];

                if(logCntry != null){
                    country = logCntry.For_Contry__c;
                }

                if(country == 'Brazil'){
                    salesOrg_Code = '5191';
                    recordType = 'Distributor';
                    accountType = 'Sold To Party';
                    forecastReq = true;
                }
                if(Test.isRunningTest()){
                    //system.debug('Test.isRunningTest() **** -' + Test.isRunningTest());
                    salesOrg_Code = '5191';
                }

                if(salesOrg_Code != ''){
                    List <Sales_Forecast_Setting__c>  sfs = new List <Sales_Forecast_Setting__c> ();
                    sfs = getForecastSetting(salesOrg_Code);

                    if(sfs.size()>0){
                        String batch1 = 'Batch 1';
                        String batch2 = 'Batch 2';
                        String batch3 = 'Batch 3';
                    
                        String query1 = 'SELECT Id, Name, Account__c, Territory__c, Territory__r.Region__c, '+
                                    +' Account__r.SAP_Code__c, Territory__r.TerritoryCode__c, Territory__r.TerritoryManager__c, '+
                                    +' Territory__r.Region__r.RegionHead__c, Territory__r.Zone__r.ZonalHead__c '+
                                    +' FROM Forecast_Account__c WHERE Account__r.RecordType.Name = \''+ recordType + '\' '+
                                    +' AND Account__r.Account_Type__c = \''+ accountType + '\' AND '+
                                    +' Account__r.Sales_Org__r.Sales_Org_Code__c = \''+ salesOrg_Code + '\' AND '+
                                    +' Territory__r.Region__r.Batch_Number__c = \''+ batch1 + '\' '+(Test.isRunningTest()?' LIMIT 1':'');

                        String query2 = 'SELECT Id, Name, Account__c, Territory__c, Territory__r.Region__c, '+
                                    +' Account__r.SAP_Code__c, Territory__r.TerritoryCode__c, Territory__r.TerritoryManager__c, '+
                                    +' Territory__r.Region__r.RegionHead__c, Territory__r.Zone__r.ZonalHead__c '+
                                    +' FROM Forecast_Account__c WHERE Account__r.RecordType.Name = \''+ recordType + '\' '+
                                    +' AND Account__r.Account_Type__c = \''+ accountType + '\' AND '+
                                    +' Account__r.Sales_Org__r.Sales_Org_Code__c = \''+ salesOrg_Code + '\' AND '+
                                    +' Territory__r.Region__r.Batch_Number__c = \''+ batch2 + '\' '+(Test.isRunningTest()?' LIMIT 1':'');

                        String query3 = 'SELECT Id, Name, Account__c, Territory__c, Territory__r.Region__c, '+
                                    +' Account__r.SAP_Code__c, Territory__r.TerritoryCode__c, Territory__r.TerritoryManager__c, '+
                                    +' Territory__r.Region__r.RegionHead__c, Territory__r.Zone__r.ZonalHead__c '+
                                    +' FROM Forecast_Account__c WHERE Account__r.RecordType.Name = \''+ recordType + '\' '+
                                    +' AND Account__r.Account_Type__c = \''+ accountType + '\' AND '+
                                    +' Account__r.Sales_Org__r.Sales_Org_Code__c = \''+ salesOrg_Code + '\' AND '+
                                    +' Territory__r.Region__r.Batch_Number__c = \''+ batch3 + '\' '+(Test.isRunningTest()?' LIMIT 1':'');
                        
                        SalesForeCastBatch bcn = new SalesForeCastBatch(month,year,sfs[0],query1,'AutoProgram',email,salesOrg_Code);
                        ID batchProcessId = Database.executeBatch(bcn,1);
                        SalesForeCastBatch bcn2 = new SalesForeCastBatch(month,year,sfs[0],query2,'AutoProgram',email,salesOrg_Code);
                        ID batchProcessId2 = Database.executeBatch(bcn2,1);
                        SalesForeCastBatch bcn3 = new SalesForeCastBatch(month,year,sfs[0],query3,'AutoProgram',email,salesOrg_Code);
                        ID batchProcessId3 = Database.executeBatch(bcn3,1);

                        System.FlexQueue.moveJobToFront(batchProcessId);
                        System.FlexQueue.moveAfterJob(batchProcessId, batchProcessId2);
                        System.FlexQueue.moveAfterJob(batchProcessId2, batchProcessId3);

                        List<Salesforecast_Batch_Process__c> sfbpList = new List<Salesforecast_Batch_Process__c>();
                        sfbpList = [SELECT Id, Name, Job_Id__c FROM Salesforecast_Batch_Process__c WHERE 
                                    Name IN ('SA Batch 1','SA Batch 2','SA Batch 3')];

                        for(Salesforecast_Batch_Process__c sfbp : sfbpList){
                            if(sfbp.Name == 'SA Batch 1'){
                                sfbp.Job_Id__c = batchProcessId;
                            }
                            else if(sfbp.Name == 'SA Batch 2'){
                                sfbp.Job_Id__c = batchProcessId2;
                            }
                            else if(sfbp.Name == 'SA Batch 3'){
                                sfbp.Job_Id__c = batchProcessId3;
                            }
                        }
                        
                        if(sfbpList.size()>0){
                            update sfbpList;
                        }                      

                    }        
                }
            }
        }
        catch(Exception ex){
            system.debug('Exception in callForecastBatch method ');
            system.debug('Exception is - ' + ex);
            system.debug('Exception at Line no  - ' + ex.getLineNumber());
        }
        
        return str;
    }

    @AuraEnabled
    public static void createSalesForeCast(String accId, String salesDist, String custmCode, String rgnCode,String rgnId,String owner_Id, String month, String year, Sales_Forecast_Setting__c sfs, String type, String rgnHead){
        /* system.debug('**** createSalesForeCast ****');
        system.debug('accId ****' + accId);
        system.debug('salesDist ****' + salesDist);
        system.debug('custmCode ****' + custmCode);
        system.debug('rgnCode ****' + rgnCode);
        system.debug('month ****' + month);
        system.debug('year ****' + year);
        system.debug('sfs ****' + sfs);
        system.debug('type ****' + type);
        system.debug('rgnHead ****' + rgnHead); */

        Monitor_Log__c ml = new Monitor_Log__c();
        RecordType rcdTp = new RecordType();
        String mnth2 = '';
        String salesOrgCode = '';
        
        try{
                rcdTp = [SELECT Id, Name, DeveloperName, Description, SobjectType, IsActive FROM RecordType WHERE 
                        SobjectType = 'Monitor_Log__c' AND DeveloperName = 'Brazil' ORDER BY LastModifiedDate LIMIT 1];

                Integer mnthVal = 0;
                Integer yrVal = 0;
                Boolean flag = false;

                Map<String,PriceBookEntry> priceEntryMap = new Map<String,PriceBookEntry>();
                Map<String,SalesAgreementProduct> sapMap = new Map<String,SalesAgreementProduct>();

                mnthVal = Integer.ValueOf(month);
                yrVal  = Integer.ValueOf(year);
            	
            	String todate = '01/'+month+'/'+year;
				Date forecastDate = Date.parse(todate);

                mnth2 = getMonthName(mnthVal);

                if(mnthVal == 1 || mnthVal == 01){
                    mnthVal = 12;
                    yrVal = yrVal - 1;
                }
                else{
                    mnthVal = mnthVal - 1;
                    yrVal = yrVal;
                }

               /*  system.debug('mnthVal ****' + mnthVal);
                system.debug('yrVal ****' + yrVal); */

                String mnth = getMonthName(mnthVal);
                //system.debug('mnth **** ' + mnth);

                List<SalesAgreement> saList = new List<SalesAgreement>();
                saList = [SELECT Id, Name, Active_Forecast_Month__c, Year__c, AccountId FROM SalesAgreement 
                           WHERE  Active_Forecast_Month__c =:mnth2 AND Year__c =:year AND AccountId =: accId 
                           AND Region__c =: rgnId];
                
                if(saList.size() == 0){
                    List<SalesAgreementProduct> sapList = new List<SalesAgreementProduct>();       
                    List<PriceBookEntry> priceEntryList = new List<PriceBookEntry>();

                    //system.debug('salesOrgCode before **** -' + sfs.Sales_Org__r.Sales_Org_code__c);

                    if(Test.isRunningTest()){
                        //system.debug('Test.isRunningTest() **** -' + Test.isRunningTest());
                        salesOrgCode = '5191';
                    }

                    if(!Test.isRunningTest()){
                        salesOrgCode = sfs.Sales_Org__r.Sales_Org_code__c;
                    }
                                       
                   // system.debug('salesOrgCode after **** -' + salesOrgCode);

                    priceEntryList = [SELECT Id, Name, Combination_Key__c, UnitPrice, Budget_Price__c, Pricebook2Id, 
                                    Pricebook2.Is_Used_for_Forecast__c, Pricebook2.Sales_Org__c, 
                                    Pricebook2.Sales_Org__r.Sales_Org_Code__c, Pricebook2.Type__c, Pricebook2.Month__c, 
                                    Pricebook2.Year__c, Pricebook2.Start_Date__c, Pricebook2.End_Date__c, 
                                    Pricebook2.Sales_District__c, Pricebook2.Price_Book_Category__c, Pricebook2.IsActive, 
                                    Product2Id, Product2.IsActive, Product2.Is_Forecast_Required__c, Product2.Name, 
                                    Product2.Default_Quantity_For_Sales_Agreement__c, Product2.Product_Code__c,
                                    Product2.Sales_Org__c, Product2.Sales_Org__r.Sales_Org_Code__c FROM PriceBookEntry 
                                    WHERE Pricebook2.Sales_District__c =:salesDist AND  
                                    Pricebook2.Sales_Org__r.Sales_Org_Code__c =: salesOrgCode AND 
                                    Pricebook2.Month__c =: month AND Pricebook2.Year__c=: year AND  
                                    Pricebook2.Type__c =: sfs.Sales_Agreement_Schedule_Frequency_Allow__c AND 
                                    Product2.Sales_Org__r.Sales_Org_Code__c =: salesOrgCode AND 
                                    Forecast_Check__c = true ORDER BY Id, Pricebook2Id, Product2Id, LastModifiedDate DESC ];
                
                                    system.debug('salesDist - ' + salesDist);
                                    system.debug('salesOrgCode - ' + salesOrgCode);
                                    system.debug('month - ' + month);
                                    system.debug('year - ' + year);
                                    system.debug('sfs.Sales_Agreement_Schedule_Frequency_Allow__c - ' + sfs.Sales_Agreement_Schedule_Frequency_Allow__c);

                    //Pricebook2.Start_Date__c <= TODAY 
                    // AND Pricebook2.End_Date__c >= TODAY AND
                   // system.debug('priceEntryList.size() **** -' + priceEntryList.size());

                    if(priceEntryList.size()>0){
                        
                        for(PriceBookEntry pbe : priceEntryList){
                            if(!priceEntryMap.containsKey(pbe.Product2Id)){
                                priceEntryMap.put(pbe.Product2Id,pbe);
                            }
                        }
                       // system.debug('priceEntryMap size - ' + priceEntryMap.size());
                       // system.debug('priceEntryMap ****' + priceEntryMap);

                        

                        if(sfs.Clone_the_existing_Forecast_Previous_mon__c == true){
                           // system.debug('sfs.Sales_Agreement_Schedule_Frequency_Allow__c **** -' + sfs.Sales_Agreement_Schedule_Frequency_Allow__c);
                            sapList = [SELECT Id, Name, CurrencyIsoCode, SalesAgreementId, PricebookEntryId, ProductId, 
                                        ListPrice, SalesPrice, Combination_Key__c, Last_Consensus__c, Budget_Price__c, 
                                        Earlier_Planned_Quantity__c, InitialPlannedQuantity FROM SalesAgreementProduct 
                                        WHERE SalesAgreement.AccountId =: accId AND SalesAgreement.Active_Forecast_Month__c =: mnth 
                                        AND SalesAgreement.Year__c =: String.ValueOf(yrVal) AND SalesAgreement.Region__c =: rgnId AND 
                                        SalesAgreement.Sales_Agreement_Schedule_Frequency_Allow__c =: sfs.Sales_Agreement_Schedule_Frequency_Allow__c];
                            
                            if(sapList.size()>0){
                                flag = true;   // old code was here
                            }
                            else{
                                flag = false; // create fresh (new) agrrement if agreement schedule frequency not match...
                            }           
                        }
                        else{
                            flag = false;// create fresh (new) agrrement if clone from existing flag is false...
                        }

                        if(flag == true){                              //***** ---- Clone record ....
                            for(SalesAgreementProduct sap : sapList){
                                if(!sapMap.containsKey(sap.ProductId)){
                                    sapMap.put(sap.ProductId,sap);
                                }
                            }
                           /*  system.debug('sapMap size - ' + sapMap.size());
                            system.debug('sapMap ****' + sapMap); */

                            SalesAgreement sa = new SalesAgreement();
                            sa.Name = 'SA'+rgnCode+month+year;
                            sa.Combination_Key__c = salesOrgCode+custmCode+rgnCode+month+year; 
                            sa.Sales_Agreement_Creation__c = type; 
                            sa.Active_Forecast_Month__c = mnth2; 
                            sa.Sales_Agreement_Schedule_Frequency_Allow__c = sfs.Sales_Agreement_Schedule_Frequency_Allow__c; 
                            sa.Currency__c = sfs.Currency_Allowed__c; 
                            sa.CurrencyIsoCode = sfs.Currency_Allowed__c;
                            sa.Schedule_Frequency_Allowed__c = sfs.Schedule_Frequency_Allowed__c; 
                            sa.Start_Day_of_Submission__c = String.ValueOf(sfs.Start_Day_of_Submission__c); 
                            sa.End_Day_of_Submission__c = String.ValueOf(sfs.End_Day_of_Submission__c); 
                            sa.Clone_the_existing_Forecast__c = sfs.Clone_the_existing_Forecast_Previous_mon__c; 
                            sa.Create_a_forecast_based_on_the_PPBAU__c = sfs.Create_a_forecast_based_on_the__c; 
                            sa.PricebookId = priceEntryList[0].Pricebook2Id; 
                            sa.AccountId = accId;
                            sa.Region__c = rgnId;
                            sa.Year__c = year;
                            sa.Cloned_from_Sales_Agreement__c = sapList[0].SalesAgreementId;
                            sa.OwnerId = owner_Id;
                            sa.Is_SA_to_be_used_in_account_forecast__c = true;
                            //sa.StartDate = system.TODAY();
                            sa.StartDate = forecastDate;
                            sa.ScheduleCount = Integer.valueOf(sfs.Schedule_Frequency_Allowed__c);
                            sa.Active_Forecast_Month_Number__c = month;
                            sa.SA_Status__c = 'Draft';
                            sa.Status = 'Draft';
                            if(rgnHead != null){
                                sa.Sales_District_Manager__c = rgnHead;
                            }
                            sa.Sales_Agreement_Setting__c = sfs.id;
                            sa.ScheduleFrequency = sfs.Sales_Agreement_Schedule_Frequency_Allow__c; // new added on 20-09-2022...by Nik(SKI)..
                            insert sa;

                            List<SalesAgreementProduct> sapListToInsert = new List<SalesAgreementProduct>();

                            for(String pId : priceEntryMap.keySet()){
                                SalesAgreementProduct sap2 = new SalesAgreementProduct();
                                sap2.Name = priceEntryMap.get(pId).Product2.Name+'-'+priceEntryMap.get(pId).Product2.Product_Code__c;
                                sap2.SalesAgreementId = sa.Id; 
                                sap2.PricebookEntryId = priceEntryMap.get(pId).Id; 
                                sap2.CurrencyIsoCode = sfs.Currency_Allowed__c;
                               //** sap2.ProductId = pId; 
                               //** sap2.ListPrice = priceEntryMap.get(pId).UnitPrice; 
                                //sap2.SalesPrice = priceEntryMap.get(pId).Budget_Price__c; 
                                sap2.Combination_Key__c = salesOrgCode+custmCode+rgnCode+month+year+priceEntryMap.get(pId).Product2.Product_Code__c; 
                                sap2.Budget_Price__c = priceEntryMap.get(pId).Budget_Price__c; 

                                if(sapMap.containsKey(pId)){
                                    sap2.Earlier_Planned_Quantity__c = sapMap.get(pId).InitialPlannedQuantity; 
                                    sap2.InitialPlannedQuantity = sapMap.get(pId).InitialPlannedQuantity;
                                    sap2.Last_Consensus__c = sapMap.get(pId).InitialPlannedQuantity;
                                }
                                else{
                                    //sap2.Earlier_Planned_Quantity__c = priceEntryMap.get(pId).Product2.Default_Quantity_For_Sales_Agreement__c; 
                                    //sap2.InitialPlannedQuantity = priceEntryMap.get(pId).Product2.Default_Quantity_For_Sales_Agreement__c.intValue();
                                    sap2.Earlier_Planned_Quantity__c = 0;               // both field changes made on 25-11-2021 as discussed with Sandip sir.
                                    sap2.InitialPlannedQuantity = 1; 
                                    //sap2.Last_Consensus__c = priceEntryMap.get(pId).;
                                }

                                sapListToInsert.add(sap2);
                            }

                            if(sapListToInsert.size()>0){ 
                                insert sapListToInsert;
                            }
                        }
                        else{                                          /// ***** New Record.....
                            SalesAgreement sa2 = new SalesAgreement();
                            sa2.Name = 'SA'+rgnCode+month+year;
                            sa2.Combination_Key__c = salesOrgCode+custmCode+rgnCode+month+year; 
                            sa2.Sales_Agreement_Creation__c = type; 
                            sa2.Active_Forecast_Month__c = mnth2; 
                            sa2.Sales_Agreement_Schedule_Frequency_Allow__c = sfs.Sales_Agreement_Schedule_Frequency_Allow__c; 
                            sa2.Currency__c = sfs.Currency_Allowed__c; 
                            sa2.CurrencyIsoCode = sfs.Currency_Allowed__c;
                            sa2.Schedule_Frequency_Allowed__c = sfs.Schedule_Frequency_Allowed__c; 
                            sa2.ScheduleCount = Integer.valueOf(sfs.Schedule_Frequency_Allowed__c);
                            sa2.Start_Day_of_Submission__c = String.ValueOf(sfs.Start_Day_of_Submission__c); 
                            sa2.End_Day_of_Submission__c = String.ValueOf(sfs.End_Day_of_Submission__c); 
                            sa2.Clone_the_existing_Forecast__c = sfs.Clone_the_existing_Forecast_Previous_mon__c; 
                            sa2.Create_a_forecast_based_on_the_PPBAU__c = sfs.Create_a_forecast_based_on_the__c; 
                            sa2.PricebookId = priceEntryList[0].Pricebook2Id; 
                            sa2.AccountId = accId;
                            sa2.Region__c = rgnId;
                            sa2.Year__c = year;
                            //sa2.Cloned_from_Sales_Agreement__c = sapList[0].SalesAgreementId;
                            sa2.OwnerId = owner_Id;
                            sa2.Is_SA_to_be_used_in_account_forecast__c = true;
                            //sa2.StartDate = system.TODAY();
                            sa2.StartDate = forecastDate;
                            sa2.Active_Forecast_Month_Number__c = month;
                            sa2.SA_Status__c = 'Draft';
                            sa2.Status = 'Draft';
                            if(rgnHead != null){
                                sa2.Sales_District_Manager__c = rgnHead;
                            }
                            sa2.Sales_Agreement_Setting__c = sfs.id; // new added...on 240222
                            sa2.ScheduleFrequency = sfs.Sales_Agreement_Schedule_Frequency_Allow__c; // new added on 20-09-2022...by Nik(SKI)..
                            insert sa2;

                            List<SalesAgreementProduct> sapListToInsert2 = new List<SalesAgreementProduct>();

                            for(String pId : priceEntryMap.keySet()){
                                SalesAgreementProduct sap3 = new SalesAgreementProduct();
                                sap3.Name = priceEntryMap.get(pId).Product2.Name+'-'+priceEntryMap.get(pId).Product2.Product_Code__c;
                                sap3.SalesAgreementId = sa2.Id; 
                                sap3.PricebookEntryId = priceEntryMap.get(pId).Id; 
                                sap3.CurrencyIsoCode = sfs.Currency_Allowed__c;
                                //** sap3.ProductId = pId; 
                                //** sap3.ListPrice = priceEntryMap.get(pId).UnitPrice; 
                                //sap3.SalesPrice = priceEntryMap.get(pId).Budget_Price__c; 
                                sap3.Combination_Key__c = salesOrgCode+custmCode+rgnCode+month+year+priceEntryMap.get(pId).Product2.Product_Code__c; 
                                sap3.Budget_Price__c = priceEntryMap.get(pId).Budget_Price__c; 
                                //sap3.Earlier_Planned_Quantity__c = priceEntryMap.get(pId).Product2.Default_Quantity_For_Sales_Agreement__c; 
                                //sap3.InitialPlannedQuantity = priceEntryMap.get(pId).Product2.Default_Quantity_For_Sales_Agreement__c.intValue();
                                sap3.Earlier_Planned_Quantity__c = 0;               // both field changes made on 25-11-2021 as discussed with Sandip sir.
                                sap3.InitialPlannedQuantity = 1;   
                                //sap3.Last_Consensus__c = priceEntryMap.get(pId).;

                                sapListToInsert2.add(sap3);
                            }
                            //system.debug('sapListToInsert2 size - ' + sapListToInsert2.size());
                            if(sapListToInsert2.size()>0){
                                insert sapListToInsert2;
                            }
                        }
                    }
                    else{
                        ml = new Monitor_Log__c();
                        ml.Distributor__c = accId;
                        ml.Message__c = 'Sales Agreement Creation Failed For The Month of - '+ mnth2+'-'+year +' As Pricebook is Not Found. Where Mode of Operation is -'+ type + ' And Region Code is - '+ rgnCode + ' And Sales Org Code is 5191.';
                        ml.Module__c = 'Sales Forecast Generation';
                        ml.OwnerId = UserInfo.getUserId();
                        if(rcdTp != null){
                            ml.RecordTypeId = rcdTp.Id;
                        }
    
                        insert ml;
                    } 
                }
                else{
                    ml = new Monitor_Log__c();
                    ml.Distributor__c = accId;
                    ml.Sales_Agreement__c = saList[0].Id;
                    ml.Message__c = 'Sales Agreement Records For The Month of - '+ mnth2+'-'+year +' Are Already Exists. Where Mode of Operation is -'+ type + ' And Region Code is - '+ rgnCode +' And Sales Org Code is 5191.';
                    ml.Module__c = 'Sales Forecast Generation';
                    ml.OwnerId = UserInfo.getUserId();
                    if(rcdTp != null){
                        ml.RecordTypeId = rcdTp.Id;
                    }

                    insert ml;
                    
                }                  
        }
        catch(Exception ex){
            system.debug('Exception in createSalesForeCast method ');
            system.debug('Exception is - ' + ex);
            system.debug('Exception at Line no  - ' + ex.getLineNumber());
            
            ml = new Monitor_Log__c();
            ml.Distributor__c = accId;
            ml.Message__c = 'Sales Agreement Creation Failed For The Month of - '+ mnth2+'-'+year +' Where Mode of Operation is -'+ type +' And Region Code is - '+ rgnCode +' And Sales Org Code is 5191. Exception is -'+ ex + ' Line No is -'+ ex.getLineNumber();
            ml.Module__c = 'Sales Forecast Generation';
            ml.OwnerId = UserInfo.getUserId();
            if(rcdTp != null){
                ml.RecordTypeId = rcdTp.Id;
            }

            insert ml;
        }
    }

    @AuraEnabled
    public static String callForecastDeleteBatch(String month, String year) {
        //system.debug('callForecastDeleteBatch ****');

        String country ='';
        String salesOrgCode = '';
        String status = '';
        String email = '';
        String str = '';
        
        try{
            
            List<String> classNames= new List<String>();
            /*classNames.add('SalesForeCastBatch');
            classNames.add('UpdateMetricsBatchNoOne');
            classNames.add('UpdateMetricsBatchNoTwo');
            classNames.add('UpdateMetricsBatchNoThree');*/
            classNames.add('SalesForeCastDeleteBatch');
            
            List<AsyncApexJob> aaj = new List<AsyncApexJob>();
            aaj = [SELECT JobType, Status, ApexClass.Name, Id FROM AsyncApexJob WHERE ApexClass.Name IN: classNames 
                   AND Status = 'Processing' ORDER BY CreatedDate DESC LIMIT 1];

            if(aaj.size()>0){
                str = 'Underprocess';
            }
            else{
                str = 'Initiated';     

                User user = [SELECT Id, Name, Country, State, Division, IsActive, UserType, Email,  
                                ManagerId FROM User where Id =: UserInfo.getUserId()];
                                
                    /* if(user.Email != null){
                        email = user.Email;
                    } */
                    email = Label.Email_Sent_to_SalesRep_or_SDM;
                    
                
                Login_Country__c logCntry = [SELECT Id, Name, For_Contry__c FROM Login_Country__c where Name =:user.Country limit 1];

                if(logCntry != null){
                    country = logCntry.For_Contry__c;
                }

                if(country == 'Brazil'){
                    salesOrgCode = '5191';
                    status = 'Approved';
                }
                
                if(Test.isRunningTest()){
                    //system.debug('Test.isRunningTest() **** -' + Test.isRunningTest());
                    salesOrgCode = '5191';
                }

                if(salesOrgCode != ''){
                   
                    String query1 = 'SELECT Id, Name, AccountId FROM SalesAgreement '+
                                +' WHERE SA_Status__c = \''+ status + '\' AND '+
                                +' Sale_Org_Code__c = \''+ salesOrgCode + '\' '+(Test.isRunningTest()?' LIMIT 1':'');                    
                    
                    SalesForeCastDeleteBatch bcn = new SalesForeCastDeleteBatch(getMonthName(Integer.ValueOf(month)),year,query1,salesOrgCode,email);
                    ID batchProcessId = Database.executeBatch(bcn,1);
                    
                    System.FlexQueue.moveJobToFront(batchProcessId);
                }
            }
        }
        catch(Exception ex){
            system.debug('Exception in callForecastDeleteBatch method ');
            system.debug('Exception is - ' + ex);
            system.debug('Exception at Line no  - ' + ex.getLineNumber());
        }
        
        return str;
    }

    @AuraEnabled
    public static void deleteSalesForeCast(String saId, String month, String year, String salesOrgCode){
        /* system.debug('*****deleteSalesForeCast******');
        system.debug('month>>----->'+ month);
        system.debug('year>>----->'+ year);
        system.debug('saId>>----->'+ saId); */

        Set<String> productToDeleteSet = new Set<String>();
        Set<String> productNotToDeleteSet = new Set<String>();
        //Map<String,List<String>> scheduleToDeleteMap = new Map<String,List<String>>();
        try{
            if((month == null || month == '') && (salesOrgCode != null || salesOrgCode != '')){
                List<Sales_Forecast_Setting__c> sfs = new List<Sales_Forecast_Setting__c>();
                sfs = getForecastSetting(salesOrgCode);
                if(sfs.size()>0){
                    month = sfs[0].Active_Forecast_Month__c;
                }
            }

            List<SalesAgreementProductSchedule> scheduleList = new List<SalesAgreementProductSchedule>();
            scheduleList = [SELECT Id, Name, SalesAgreementProduct.SalesAgreementId, Month__c, Year__c, 
                            SalesAgreementProduct.SalesAgreement.SA_Status__c , SalesAgreementProductId, 
                            SalesAgreementProduct.SalesAgreement.Sale_Org_Code__c, PlannedQuantity 
                            From SalesAgreementProductSchedule WHERE 
                            Month__c =: month AND year__c =: year AND 
                            SalesAgreementProduct.SalesAgreement.Sale_Org_Code__c =: salesOrgCode 
                            AND SalesAgreementProduct.SalesAgreementId =: saId];
            
            //System.debug('in deletion part scheduleList '+scheduleList);

            if(scheduleList.size()>0){
                for(SalesAgreementProductSchedule saps : scheduleList){
                   // System.debug('in deletion part saps.PlannedQuantity '+saps.PlannedQuantity);
                    if(saps.PlannedQuantity == 0){
                        
                        if(!productToDeleteSet.contains(saps.SalesAgreementProductId)){
                            productToDeleteSet.add(saps.SalesAgreementProductId);
                        }

                    }
                    if(saps.PlannedQuantity > 0){

                        if(!productNotToDeleteSet.contains(saps.SalesAgreementProductId)){
                            productNotToDeleteSet.add(saps.SalesAgreementProductId);
                        }                        
                    }
                }
               // System.System.debug('productNotToDeleteSet size-' + productNotToDeleteSet.size());
                
                if(productNotToDeleteSet.size()>0){
                    productToDeleteSet.removeAll(productNotToDeleteSet);
                }
               /*  System.System.debug('productToDeleteSet size-' + productToDeleteSet.size());
                System.System.debug('productToDeleteSet -' + JSON.serializePretty(productToDeleteSet)); */

                if(productToDeleteSet.size() > 0){
                   
                    DELETE [SELECT Id, Name FROM SalesAgreementProduct WHERE Id IN: productToDeleteSet];
                    
                }
            }                
        }
        catch(Exception ex){
            system.debug('Exception in deleteSalesForeCast method ');
            system.debug('Exception is - ' + ex);
            system.debug('Exception at Line no  - ' + ex.getLineNumber());
        }
    }

    public static List<Sales_Forecast_Setting__c> getForecastSetting(String salesOrgCode){
        return [SELECT Id, Name, CurrencyIsoCode, Sales_Org__c, Sales_Agreement_Schedule_Frequency_Allow__c, 
                Active_Forecast_Month__c, Schedule_Frequency_Allowed__c, Currency_Allowed__c, 
                Start_Day_Of_Approval__c, End_Day_Of_Approval__c, Configuration_on_Sales_Forecast_Metric__c, 
                Clone_the_existing_Forecast_Previous_mon__c, Create_a_forecast_based_on_the__c, 
                Admin_Profile_Name__c, Start_Day_of_Submission__c, End_Day_of_Submission__c, 
                Sales_Org__r.Sales_Org_code__c  
                FROM Sales_Forecast_Setting__c WHERE Sales_Org__r.Sales_Org_code__c =: salesOrgCode 
                ORDER BY LastModifiedDate LIMIT 1];
    }

    public static String getMonthName(Integer num){
        Map<Integer,String> monthMap = new Map<Integer,String>();
                monthMap.put(01,'January');
                monthMap.put(02,'February');
                monthMap.put(03,'March');
                monthMap.put(04,'April');
                monthMap.put(05,'May');
                monthMap.put(06,'June');
                monthMap.put(07,'July');
                monthMap.put(08,'August');
                monthMap.put(09,'September');
                monthMap.put(10,'October');
                monthMap.put(11,'November');
                monthMap.put(12,'December');

        return  monthMap.get(num);       
    }

    
}