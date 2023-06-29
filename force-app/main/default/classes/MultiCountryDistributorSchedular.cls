global class MultiCountryDistributorSchedular implements Schedulable{
    global void execute(SchedulableContext  sc){
        createAnnualPlan();
    }
    
    public static void createAnnualPlan(){
        MultiCountry_Liquidation__c multiCountry = [select Id,Name from MultiCountry_Liquidation__c where Active__c=true limit 1];
		Id rec_type_LAP = Schema.SObjectType.Liquidation_Annual_Plan__c.getRecordTypeInfosByName().get('Multi Country').getRecordTypeId();
		Liquidation_Batch_Filters__c batchFilter = [select Id,Name,Account_Type_Filter__c,Active__c,Distributor_Filter__c,Sales_District_Filter__c,Sales_Org_Filter__c,Ship_To_Party_Filter__c from Liquidation_Batch_Filters__c where Name=:multiCountry.Name and Active__c=true];
		Period PeriodYear = [SELECT FiscalYearSettings.Name , StartDate,EndDate, type FROM Period WHERE Type = 'Year' AND StartDate <= TODAY AND EndDate >= TODAY];
		String fiscalyear = PeriodYear.StartDate.year()+'-'+PeriodYear.EndDate.year();
        System.debug('recordTypeId=:'+rec_type_LAP +'and Sales_Org_Code__c=:'+batchFilter.Sales_Org_Filter__c+' and FIscal_Year__c=:'+fiscalyear);
        String annualQuery = 'select Id,Name,Ship_To_Party__c,Ship_To_Party__r.Combination_Key__c,Distributor__c,Sales_Org_Code__c,Sales_Org__c,Distributor__r.SAP_Code__c from Liquidation_Annual_Plan__c where recordTypeId=\''+rec_type_LAP+'\' and ('+batchFilter.Sales_Org_Filter__c+') and FIscal_Year__c=\''+fiscalyear+'\'';
        String shippingLocationQuery = 'select Id,Name,Combination_Key__c,Sales_Org__c,Sales_Org_Code__c,Distributor__c,Distributor__r.SAP_Code__c from Shipping_Location__c where ('+batchFilter.Sales_Org_Filter__c+') and Active_for_Liquidation__c=true and Distributor__r.Active_For_Liquidation__c=true';
		System.debug('AnnualQuery '+annualQuery);
        //List<Liquidation_Annual_Plan__c> annualPlans = [select Id,Name,Ship_To_Party__c,Ship_To_Party__r.Combination_Key__c,Distributor__c,Sales_Org_Code__c,Sales_Org__c,Distributor__r.SAP_Code__c from Liquidation_Annual_Plan__c where recordTypeId=:rec_type_LAP and Sales_Org_Code__c=:batchFilter.Sales_Org_Filter__c and FIscal_Year__c=:fiscalyear];
		//List<Shipping_Location__c> shippingLocations = [select Id,Name,Combination_Key__c,Sales_Org__c,Sales_Org_Code__c,Distributor__c,Distributor__r.SAP_Code__c from Shipping_Location__c where Sales_Org_Code__c=:batchFilter.Sales_Org_Filter__c and Active_for_Liquidation__c=true and Distributor__r.Active_For_Liquidation__c=true];
		List<Liquidation_Annual_Plan__c> annualPlans = Database.query(annualQuery);
        List<Shipping_Location__c> shippingLocations = Database.query(shippingLocationQuery);
        Map<String,Liquidation_Annual_Plan__c> mapAnnualPlans = new Map<String,Liquidation_Annual_Plan__c>();
		List<Liquidation_Annual_Plan__c> newLAPs = new List<Liquidation_Annual_Plan__c>();
		if(multiCountry.Name.equalsIgnoreCase('Mexico')){
			Map<String,Shipping_Location__c> mapShippingLocations = new Map<String,Shipping_Location__c>();
			for(Liquidation_Annual_Plan__c annualPlan:annualPlans){
				mapAnnualPlans.put(annualPlan.Ship_To_Party__r.Combination_Key__c+annualPlan.Sales_Org_Code__c,annualPlan);
			}
            
			for(Shipping_Location__c shippinglocation: shippingLocations){
				mapShippingLocations.put(shippinglocation.Combination_Key__c+shippinglocation.Sales_Org_Code__c,shippinglocation);
			}

			for(String key:mapShippingLocations.keySet()){
				if(!mapAnnualPlans.containskey(key)){
					Liquidation_Annual_Plan__c liqAnnlPln = new Liquidation_Annual_Plan__c(); 
					liqAnnlPln.RecordTypeId= rec_type_LAP;
                    liqAnnlPln.Fiscal_Start_Date__c = PeriodYear.StartDate;
                    liqAnnlPln.Fiscal_End_Date__c = PeriodYear.EndDate;
                    liqAnnlPln.FIscal_Year__c = fiscalyear;
                    liqAnnlPln.Ship_To_Party__c = mapShippingLocations.get(key).Id;
                    liqAnnlPln.Distributor__c = mapShippingLocations.get(key).Distributor__c;
                    liqAnnlPln.Sales_Org__c= mapShippingLocations.get(key).Sales_Org__c; 
                    liqAnnlPln.Multi_Country_Key__c = mapShippingLocations.get(key).Distributor__r.SAP_Code__c+fiscalyear+mapShippingLocations.get(key).Sales_Org_Code__c;
                    newLAPs.add(liqAnnlPln);
				}
			}
        }else{
            system.debug('inside else');
            Id DistributorRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
			String query = 'SELECT count(Id), Distributor__c, Distributor__r.SAP_Code__c, SalesOrg__c FROM DistributorSalesAreaMapping__c WHERE ('+batchFilter.Sales_Org_Filter__c+') AND ('+batchFilter.Account_Type_Filter__c+') AND Distributor__r.RecordTypeId=\''+DistributorRecordTypeId+'\' AND Distributor__r.Active_For_Liquidation__c=true group by Distributor__c ,Distributor__r.Name, Distributor__r.SAP_code__c,SalesOrg__c';
			system.debug('query==>'+query);
            List<DistributorSalesAreaMapping__c> ReferenceSalesAreaList = new List<DistributorSalesAreaMapping__c>();
			String refquery = 'SELECT Distributor__c, Distributor_SAP_Code__c,Distributor__r.SAP_Code__c, SalesOrg__c, SalesOrg__r.Sales_Org_Code__c,Sales_Org_Code__c FROM DistributorSalesAreaMapping__c WHERE ('+batchFilter.Sales_Org_Filter__c+') AND ('+batchFilter.Account_Type_Filter__c+') AND Distributor__r.RecordTypeId=\''+DistributorRecordTypeId+'\' AND Distributor__r.Active_For_Liquidation__c=true ';
			ReferenceSalesAreaList = Database.query(refquery);
            List<AggregateResult> listOfDistributorSalesAreaMapping = database.query(query);
			string sDate = string.valueOfGmt(PeriodYear.StartDate);
            String eDate = string.valueOfGmt(PeriodYear.EndDate);
            Map<String,AggregateResult> Mapaggregate = new Map<String,AggregateResult>();
            Map<String,DistributorSalesAreaMapping__c> MapRefrencesalesArea = new Map<String,DistributorSalesAreaMapping__c>();
            for(DistributorSalesAreaMapping__c sa:ReferenceSalesAreaList){
                MapRefrencesalesArea.put(sa.Distributor__c+''+sa.SalesOrg__c,sa);
            }
            system.debug('MapRefrencesalesArea==>'+MapRefrencesalesArea);
            for(AggregateResult res:listOfDistributorSalesAreaMapping){
                //Mapaggregate.put(res.Distributor__c+''+res.SalesOrg__r.Sales_Org_Code__c,res);
                Mapaggregate.put(res.get('Distributor__c')+''+(Id)res.get('SalesOrg__c'),res);
            }
            system.debug('Mapaggregate==>'+Mapaggregate);
            for(Liquidation_Annual_Plan__c annualPlan:annualPlans){
				mapAnnualPlans.put(annualPlan.Distributor__c+''+annualPlan.Sales_Org__c,annualPlan);
			}
            system.debug('mapAnnualPlans==>'+mapAnnualPlans);
            for(String key:Mapaggregate.keySet()){
                if(!mapAnnualPlans.containskey(key)){
                    Liquidation_Annual_Plan__c liqAnnlPln = new Liquidation_Annual_Plan__c(); 
					liqAnnlPln.RecordTypeId= rec_type_LAP;
                    liqAnnlPln.Fiscal_Start_Date__c = PeriodYear.StartDate;
                    liqAnnlPln.Fiscal_End_Date__c = PeriodYear.EndDate;
                    liqAnnlPln.FIscal_Year__c = fiscalyear;
                    liqAnnlPln.Distributor__c = (Id)Mapaggregate.get(key).get('Distributor__c');
                    liqAnnlPln.Sales_Org__c= (Id)Mapaggregate.get(key).get('SalesOrg__c');
                    liqAnnlPln.Multi_Country_Key__c = MapRefrencesalesArea.get(key).Distributor_SAP_Code__c+fiscalyear+MapRefrencesalesArea.get(key).Sales_Org_Code__c;
                    newLAPs.add(liqAnnlPln);
                }
            }
        }
        System.debug('New LAP '+newLaps);
    	insert newLAPs;
        String str = '(';
        for(Liquidation_Annual_Plan__c lap:newLAPs){
            str = str+'\''+lap.Id+'\',';
        }
        str = str+')';
        str = str.replace(',)',')');
        string query = 'SELECT Name,Id,Sales_Org__c,Sales_Org__r.sales_org_code__c,Ship_To_Party__c,SentToBatch__c,FIscal_Year__c,Distributor__c,Fiscal_Start_Date__c,Fiscal_End_Date__c,Multi_Country_Key__c FROM Liquidation_Annual_Plan__c WHERE Id IN '+str; 
        System.debug('Query '+query);
        MultiCountryDistributorLiquidation  batchObj = new MultiCountryDistributorLiquidation(query,batchFilter);
        DataBase.executeBatch(batchObj,1);
    }
}