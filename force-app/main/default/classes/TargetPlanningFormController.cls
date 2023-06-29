public without sharing class TargetPlanningFormController {
    
    public static string salesOrgCodeNAM = System.Label.NAM_SalesOrg;
    public static string salesOrgCodeCanada = System.Label.Canada_SalesOrg;
    public static string currencyCodeNAM = 'USD';
    public static string currencyCodeCanada = 'CAD';
    
    @AuraEnabled
    public static CalculateMarkettingYearHelper.MarketingYearWrapper getMarketingYear(){
        User currentUser = [select id, Country,Profile.Name from user where id =: UserInfo.getUserId() ];
         string salesOrg;
         if(currentUser.Country == 'USA')
            salesOrg = salesOrgCodeNAM;
        else if(currentUser.Country == 'Canada')
            salesOrg = salesOrgCodeCanada;
        return CalculateMarkettingYearHelper.calculateMarketingYear(salesOrg);
    }
    
    @AuraEnabled
    public static Integer getPageSize(){
        return Integer.valueof(UPL_Settings__c.getInstance().Draft_Record_Per_Page__c);
    }
    
    @AuraEnabled
    public static LastSavedWrapper getLastSavedData(String mktYear){
        User currentUser = [select id, Country,Profile.Name,Profile.Id from user where id =: UserInfo.getUserId() ];
        string salesOrg;
        if(currentUser.Country == 'USA')
            salesOrg = salesOrgCodeNAM;
        else if(currentUser.Country == 'Canada')
            salesOrg = salesOrgCodeCanada;
        //List<Marketing_Year__c> marketingYear = [select id,Name, Start_Date__c, End_Date__c from Marketing_Year__c  where Sales_Org__r.Sales_Org_Code__c =:salesOrg order by End_Date__c desc limit 1]; 
        CalculateMarkettingYearHelper.MarketingYearWrapper mktYearWrapper = CalculateMarkettingYearHelper.calculateMarketingYear(salesOrg);
        Integer myear;Date startDate; Date endDate;
        if(mktYear == 'first'){
            myear = mktYearWrapper.firstMarketingYear;
            startDate = mktYearWrapper.firstMarketingYearStartDate;
            endDate = mktYearWrapper.firstMarketingYearEndDate;
        }
        else if(mktYear == 'second'){
            myear = mktYearWrapper.secondMarketingYear;
            startDate = mktYearWrapper.secondMarketingYearStartDate;
            endDate = mktYearWrapper.secondMarketingYearEndDate;
        } 
        List<Target_Plan__c> targetPlanList = [SELECT id,Name,Sales_Org__r.Sales_Org_Code__c, SKU__r.name,SKU__c,SKU__r.UOM__c,SKU__r.Material_type__c,EDI_Quantity_LY__c,Invoice_Quantity_LY__c,Draft_Quantity__c,Target_Quantity__c,
                                               LastModifiedBy.Name,LastModifiedDate
                                               FROM Target_Plan__c
                                               WHERE MKT_Year_Start_Date__c >=:startDate AND MKT_Year_End_Date__c <=:endDate  AND Sales_Org__r.Sales_Org_Code__c =:salesOrg order by LastModifiedDate desc ];
        LastSavedWrapper last = new LastSavedWrapper();
        if(targetPlanList.size() > 0){
            last.lastSavedName = targetPlanList[0].LastModifiedBy.Name;
            DateTime dT =  targetPlanList[0].LastModifiedDate;
            last.lastSavedDate = dT.format('MM-dd-yyyy hh:mm');
            last.showLastSaved = true;
        }
        else
            last.showLastSaved = false;  
        List<ObjectPermissions> objectperm = [SELECT Id, SObjectType,PermissionsRead,PermissionsEdit FROM ObjectPermissions WHERE parentid in (select id from permissionset where PermissionSet.Profile.Id=:currentUser.Profile.Id) And SObjectType = 'Target_Plan__c' LIMIT 1];
        if(objectperm.size() > 0)
            last.editAccess = objectperm[0].PermissionsEdit;
        
        Integer visibility = Integer.valueof(UPL_Settings__c.getInstance().Target_Plan_Visibility__c);
        system.debug('visibility:'+visibility);
        system.debug('startDate:'+startDate);
        system.debug('total:'+startDate+visibility);
        if(system.today() >= startDate.addDays(visibility))
        	last.targetAccess = true;
        else
            last.targetAccess = false;
        return last;
    }
    @AuraEnabled
    public static List<divWrapperReg> getDivisions(){
        List<String> DivList=UPL_Settings__c.getInstance().Division__c.split(',');
        system.debug(DivList);
        List<divWrapperReg> dWrap=new List<divWrapperReg>();
        divWrapperReg dW1=new divWrapperReg();
                	dW1.divId=null;
                	//dW1.divLength=1;
                	dW1.divName='--None--';
                	dW1.divCode='';
					dWrap.add(dW1);  
        List<Division__c> divreg=[select id,Division_Code__c,name from Division__c where Division_Code__c in:DivList];
        system.debug(divreg);
        for(Division__c dd:divreg){
                    divWrapperReg dW=new divWrapperReg();
                	dW.divId=dd.id;
                	//dW.divLength=distArea.size();
                	dW.divName=dd.name;
                	dW.divCode=dd.Division_Code__c;
					dWrap.add(dW);
        
    }
        return dWrap;
    }
    @AuraEnabled
    public static  List<SKUWrapper> getSKUWrapper(String mktYear,String div){
        system.debug('mktYear::'+mktYear);
        User currentUser = [select id, Country,Profile.Name from user where id =: UserInfo.getUserId() ];
        string salesOrg;
        string currencyCode;
        if(currentUser.Country == 'USA'){
            salesOrg = salesOrgCodeNAM;
            currencyCode = currencyCodeNAM;
        }
        else if(currentUser.Country == 'Canada'){
            salesOrg = salesOrgCodeCanada;
            currencyCode = currencyCodeCanada;
        }
        Division__c division = [Select id,Division_Code__c from Division__c where id=:div];
        CalculateMarkettingYearHelper.MarketingYearWrapper mktYearWrapper = CalculateMarkettingYearHelper.calculateMarketingYear(salesOrg);
        Integer myear;Date startDate; Date endDate;
        if(mktYear == 'first'){
            myear = mktYearWrapper.firstMarketingYear;
            startDate = mktYearWrapper.firstMarketingYearStartDate;
            endDate = mktYearWrapper.firstMarketingYearEndDate;
        }
        else if(mktYear == 'second'){
            myear = mktYearWrapper.secondMarketingYear;
            startDate = mktYearWrapper.secondMarketingYearStartDate;
            endDate = mktYearWrapper.secondMarketingYearEndDate;
        } 
        system.debug('year:'+myear);
        system.debug('startDate:'+startDate);
        system.debug('endDate:'+endDate);
        //fetch current marketing year
        //List<Marketing_Year__c> marketingYear = [select id,Name, Start_Date__c, End_Date__c from Marketing_Year__c  where Sales_Org__r.Sales_Org_Code__c =:salesOrg order by End_Date__c desc limit 1]; 
        //SKU-draftplan map
        List<Draft_Plan__c> draftPlanList = [SELECT id, Draft_Plan_Header__r.id,Draft_Plan_Header__r.Division__c,Draft_Plan_Header__r.Distributor__c, Draft_Plan_Header__r.Sales_Org__r.Sales_Org_Code__c, 
                                              Draft_Plan_Header__r.Status__c, Draft_Plan_Header__r.MKT_Year_Start_Date__c, Draft_Plan_Header__r.MKT_Year_End_Date__c, 
                                             SKU__c,SKU__r.Id,SKU__r.Name,SKU__r.SKU_Description__c,SKU__r.SKU_Code__c, SKU__r.Material_type__c, SKU__r.UOM__c, Product_Price__c,Draft_Quantity__c, EDI_Quantity_LY__c, Invoice_Quantity_LY__c
                                             FROM Draft_Plan__c 
                                             where Draft_Plan_Header__r.MKT_Year_Start_Date__c >=:startDate AND Draft_Plan_Header__r.MKT_Year_End_Date__c <=:endDate 
                                              AND Draft_Plan_Header__r.Division__c=:div AND Draft_Plan_Header__r.Sales_Org__r.Sales_Org_Code__c =:salesOrg order by SKU__r.Material_type__c DESC ];
        system.debug('draftplansize::'+draftPlanList.size());
        List<Draft_Plan__c> noTargetList = new List<Draft_Plan__c>();
        List<Target_Plan__c> targetPlanList = [SELECT id,Division__c,Name,Sales_Org__r.Sales_Org_Code__c,SKU__r.Id, SKU__r.SKU_Code__c,SKU__r.SKU_Description__c,SKU__r.name,SKU__c,SKU__r.UOM__c,SKU__r.Material_type__c,EDI_Quantity_LY__c,Invoice_Quantity_LY__c,Draft_Quantity__c,Target_Quantity__c,Product_Price__c
                                               FROM Target_Plan__c
                                               WHERE MKT_Year_Start_Date__c >=:startDate AND MKT_Year_End_Date__c <=:endDate AND Division__c=:div AND Sales_Org__r.Sales_Org_Code__c =:salesOrg ];
         system.debug('targetPlansize::'+targetPlanList.size());
        Map<Id,List<Draft_Plan__c>> skuDraftPlanMap = new  Map<Id,List<Draft_Plan__c>>();
        Map<Id,List<Draft_Plan_Payout__c>> skuPayoutMap = new  Map<Id,List<Draft_Plan_Payout__c>>();
        for(Draft_Plan__c draftPlan : draftPlanList){
            if(skuDraftPlanMap.containsKey(draftPlan.SKU__c))
                skuDraftPlanMap.get(draftPlan.SKU__c).add(draftPlan);
            else{
                skuDraftPlanMap.put(draftPlan.SKU__c,new List<Draft_Plan__c>{draftPlan});
            }
        }
        
        Set<Id> skuIdSet = skuDraftPlanMap.keySet();
        List<Draft_Plan__c> draftPlanNotApprovedList = [SELECT id, Draft_Plan_Header__r.id,Draft_Plan_Header__r.Division__c,Draft_Plan_Header__r.Distributor__c, Draft_Plan_Header__r.Sales_Org__r.Sales_Org_Code__c, 
                                              Draft_Plan_Header__r.Status__c, Draft_Plan_Header__r.MKT_Year_Start_Date__c, Draft_Plan_Header__r.MKT_Year_End_Date__c, 
                                             SKU__c,SKU__r.Id,SKU__r.Name,SKU__r.SKU_Description__c,SKU__r.SKU_Code__c, SKU__r.Material_type__c, SKU__r.UOM__c, Product_Price__c,Draft_Quantity__c, EDI_Quantity_LY__c, Invoice_Quantity_LY__c,Target_Updated__c
                                             FROM Draft_Plan__c 
                                             where SKU__r.Id IN: skuIdSet 
                                             AND Draft_Plan_Header__r.MKT_Year_Start_Date__c >=:startDate AND Draft_Plan_Header__r.MKT_Year_End_Date__c <=:endDate 
                                             AND Draft_Plan_Header__r.Sales_Org__r.Sales_Org_Code__c =:salesOrg AND Draft_Plan_Header__r.Division__c=:div
                                             AND Draft_Plan_Header__r.Status__c != 'Approved'];
        Set<Id> skuNonEditSet = new  Set<Id>();
        for(Draft_Plan__c draftPlan : draftPlanNotApprovedList){
            skuNonEditSet.add(draftPlan.SKU__c);
        }
        
        Map<Id,Target_Plan__c> skuTargetPlanMap = new  Map<Id,Target_Plan__c>();
        for(Target_Plan__c targetPlan : targetPlanList){
            skuTargetPlanMap.put(targetPlan.SKU__c,targetPlan);
        }
        
        system.debug('map::'+skuDraftPlanMap);
        AggregateResult[] aggregatedraftPlan = [SELECT SKU__c,SUM(Draft_Quantity__c) drafttotal,SUM(Invoice_Quantity_LY__c) invoicetotal,SUM(EDI_Quantity_LY__c) editotal
                                                FROM Draft_Plan__c where Draft_Plan_Header__r.MKT_Year_Start_Date__c >=:startDate AND Draft_Plan_Header__r.MKT_Year_End_Date__c <=:endDate 
                                                AND Draft_Plan_Header__r.Division__c=:div AND Draft_Plan_Header__r.Sales_Org__r.Sales_Org_Code__c =:salesOrg
                                                GROUP BY SKU__c];
        Map<Id,Decimal> EDITotalMap = new Map<Id,Decimal>();
        Map<Id,Decimal> invoiceTotalMap = new Map<Id,Decimal>();
        Map<Id,Decimal> draftTotalMap = new Map<Id,Decimal>();
        for (AggregateResult ar : aggregatedraftPlan)  {
            EDITotalMap.put((Id)ar.get('SKU__c'),(Decimal)ar.get('editotal'));
            invoiceTotalMap.put((Id)ar.get('SKU__c'),(Decimal)ar.get('invoicetotal'));
            draftTotalMap.put((Id)ar.get('SKU__c'),(Decimal)ar.get('drafttotal'));
        }
        List<Target_Plan__c> tptoupsert = new List<Target_Plan__c>();
        Map<Id,Target_Plan__c> targetMapInserted = new Map<Id,Target_Plan__c>();
        Map<Id,Target_Plan__c> targetMapUpdated = new Map<Id,Target_Plan__c>();
        
        //updating aggregated values for all skus 
        for(Draft_Plan__c df : draftPlanList){
            if(skuTargetPlanMap.containsKey(df.SKU__c)){
                Target_Plan__c newtp =  skuTargetPlanMap.get(df.SKU__c);
                newtp.Product_Price__c = df.Product_Price__c;
                if(draftTotalMap.containsKey(df.SKU__c))
                    newtp.Draft_Quantity__c = draftTotalMap.get(df.SKU__c);
                if(EDITotalMap.containsKey(df.SKU__c))
                    newtp.EDI_Quantity_LY__c = EDITotalMap.get(df.SKU__c);
                if(invoiceTotalMap.containsKey(df.SKU__c))
                    newtp.Invoice_Quantity_LY__c = invoiceTotalMap.get(df.SKU__c);
                if(!targetMapUpdated.containsKey(newtp.SKU__c)){
                    targetMapUpdated.put(newtp.SKU__c,newtp);
                    tptoupsert.add(newtp);
                }
            }            
        }
        
        //preparing list of sku whose target plan does not exist
        for(Draft_Plan__c draftPlan : draftPlanList){
            if(!skuTargetPlanMap.containsKey(draftPlan.SKU__c))
                noTargetList.add(draftPlan);
        }
        system.debug('notargetpresent::'+noTargetList);
        for(Draft_Plan__c df : noTargetList){
            Target_Plan__c newtp =  new Target_Plan__c();
            newtp.SKU__c = df.SKU__c;
            newtp.Product_Price__c = df.Product_Price__c;
            if(draftTotalMap.containsKey(df.SKU__c))
                newtp.Draft_Quantity__c = draftTotalMap.get(df.SKU__c);
            if(EDITotalMap.containsKey(df.SKU__c))
                newtp.EDI_Quantity_LY__c = EDITotalMap.get(df.SKU__c);
            if(invoiceTotalMap.containsKey(df.SKU__c))
                newtp.Invoice_Quantity_LY__c = invoiceTotalMap.get(df.SKU__c);
            newtp.MKT_Year_Start_Date__c = startDate;
            newtp.MKT_Year_End_Date__c = endDate;
            newtp.Sales_Org__c = df.Draft_Plan_Header__r.Sales_Org__c;
            newtp.CurrencyIsoCode = currencyCode;
            newtp.Division__c = df.Draft_Plan_Header__r.Division__c;
            newtp.Combination_Key__c = myear+'+'+df.SKU__r.SKU_Code__c+division.Division_Code__c;
            if(!targetMapInserted.containsKey(newtp.SKU__c)){
                targetMapInserted.put(newtp.SKU__c,newtp);
                tptoupsert.add(newtp);
            }
            
        }
        system.debug('tpto upsert::'+tptoupsert);
        upsert tptoupsert;
        
        List<Target_Plan__c> targetPlanFinalList = [SELECT id,Name,Sales_Org__r.Sales_Org_Code__c,SKU__r.Id,Division__c, SKU__r.SKU_Code__c,SKU__r.SKU_Description__c,SKU__r.name,SKU__c,SKU__r.UOM__c,SKU__r.Material_type__c,EDI_Quantity_LY__c,Invoice_Quantity_LY__c,Draft_Quantity__c,Target_Quantity__c
                                                    FROM Target_Plan__c
                                                    WHERE MKT_Year_Start_Date__c >=:startDate AND MKT_Year_End_Date__c <=:endDate AND Division__c=:div AND Sales_Org__r.Sales_Org_Code__c =:salesOrg ];
        system.debug('targetsize::'+targetPlanFinalList.size());
        
        //creating skuwrapper map
        Map<String,SKUWrapper> skuWrapperMap = new Map<String,SKUWrapper>();
        List<SKUWrapper> skuWrapperList = new List<SKUWrapper>();
        for(Target_Plan__c targetPlan : targetPlanFinalList){
            SKUWrapper skuWrapper = new SKUWrapper();
            skuWrapper.SKUId = targetPlan.SKU__c;
            skuWrapper.SKUName = targetPlan.SKU__r.SKU_Code__c+'-'+targetPlan.SKU__r.SKU_Description__c;
            skuWrapper.UOM = targetPlan.SKU__r.UOM__c;
            skuWrapper.SKUMaterial = targetPlan.SKU__r.Material_type__c;
            skuWrapper.EDITotal = targetPlan.EDI_Quantity_LY__c;
            skuWrapper.invoiceTotal = targetPlan.Invoice_Quantity_LY__c;
            skuWrapper.draftTotal = targetPlan.Draft_Quantity__c;
            skuWrapper.targetTotal = targetPlan.Target_Quantity__c;
            if(skuNonEditSet.contains(targetPlan.SKU__c))
            	skuWrapper.editAccess = false;
            else
                skuWrapper.editAccess = true;
            skuWrapper.fromTargetPlan = true;
            if(!skuWrapperMap.containsKey(targetPlan.SKU__c)){
                skuWrapperMap.put(targetPlan.SKU__c,skuWrapper);
                skuWrapperList.add(skuWrapper);
            }
        }
        system.debug('skuWrapperMap::'+skuWrapperMap);
        system.debug('skuWrapperList::'+skuWrapperList);
        return skuWrapperList;
    }
    
    @AuraEnabled
    public static List<Id> saveTargetData(List<SKUWrapper> paginationList,String mktYear,String div){
        User currentUser = [select id, Country,Profile.Name from user where id =: UserInfo.getUserId() ];
        string salesOrg;
        if(currentUser.Country == 'USA')
            salesOrg = salesOrgCodeNAM;
        else if(currentUser.Country == 'Canada')
            salesOrg = salesOrgCodeCanada;
        system.debug('paginationList::'+paginationList);
        
        CalculateMarkettingYearHelper.MarketingYearWrapper mktYearWrapper = CalculateMarkettingYearHelper.calculateMarketingYear(salesOrg);
        Integer myear;Date startDate; Date endDate;
        if(mktYear == 'first'){
            myear = mktYearWrapper.firstMarketingYear;
            startDate = mktYearWrapper.firstMarketingYearStartDate;
            endDate = mktYearWrapper.firstMarketingYearEndDate;
        }
        else if(mktYear == 'second'){
            myear = mktYearWrapper.secondMarketingYear;
            startDate = mktYearWrapper.secondMarketingYearStartDate;
            endDate = mktYearWrapper.secondMarketingYearEndDate;
        } 
        //fetch current marketing year
        //List<Marketing_Year__c> marketingYear = [select id,Name, Start_Date__c, End_Date__c,Sales_Org__c from Marketing_Year__c  where Sales_Org__r.Sales_Org_Code__c =:salesOrg order by End_Date__c desc limit 1]; 
        //SKU-draftplanV1 map
        List<Draft_Plan__c> draftPlanList = [SELECT id, Draft_Plan_Header__r.id,Draft_Plan_Header__r.Division__c,Draft_Plan_Header__r.Distributor__r.Name,Draft_Plan_Header__r.Distributor__c,Draft_Plan_Header__r.Distributor__r.SAP_Code_US__c, Draft_Plan_Header__r.Sales_Org__r.Sales_Org_Code__c, 
                                              Draft_Plan_Header__r.Status__c, Draft_Plan_Header__r.MKT_Year_Start_Date__c, Draft_Plan_Header__r.MKT_Year_End_Date__c, 
                                             SKU__c,SKU__r.Id,SKU__r.Name,SKU__r.SKU_Description__c, SKU__r.Material_type__c, SKU__r.UOM__c,SKU__r.SKU_Code__c, Draft_Quantity__c, EDI_Quantity_LY__c, Invoice_Quantity_LY__c,EDI_Amount_LY__c,Invoice_Amount_LY__c,Product_Price__c,
                                             Pct_Of_Prev_Yr__c, Value_At_Draft__c, Status__c,Pct_Of_Prev_Yr_Target__c,Target_Amount__c,Target_Quantity__c,Target_Updated__c,Value_At_Target__c
                                             FROM Draft_Plan__c 
                                             where Draft_Plan_Header__r.MKT_Year_Start_Date__c >=:startDate AND Draft_Plan_Header__r.MKT_Year_End_Date__c <=:endDate 
                                             AND Draft_Plan_Header__r.Sales_Org__r.Sales_Org_Code__c =:salesOrg AND Draft_Plan_Header__r.Division__c=:div
                                             AND Draft_Plan_Header__r.Status__c = 'Approved' order by SKU__r.Material_type__c  ];
        
        Map<Id,List<Draft_Plan__c>> skuDraftPlanMap = new  Map<Id,List<Draft_Plan__c>>();
        for(Draft_Plan__c draftPlan : draftPlanList){
            if(skuDraftPlanMap.containsKey(draftPlan.SKU__c))
                skuDraftPlanMap.get(draftPlan.SKU__c).add(draftPlan);
            else{
                skuDraftPlanMap.put(draftPlan.SKU__c,new List<Draft_Plan__c>{draftPlan});
            }
        }
        
        List<Target_Plan__c> targetPlanList = [SELECT id,Name,SKU__r.Id,Division__c, SKU__r.name,SKU__c,SKU__r.SKU_Code__c,Target_Quantity__c,Sales_Org__r.Sales_Org_Code__c
                                               FROM Target_Plan__c
                                               WHERE MKT_Year_Start_Date__c >=:startDate AND MKT_Year_End_Date__c <=:endDate AND Division__c=:div AND Sales_Org__r.Sales_Org_Code__c =:salesOrg];
        Map<Id,Target_Plan__c> skuTargetPlanMap = new  Map<Id,Target_Plan__c>();
        for(Target_Plan__c targetPlan : targetPlanList){
            skuTargetPlanMap.put(targetPlan.SKU__c,targetPlan);
        }
        //check if from target plan exists then update else create
        //add dfp check if it exists
        List<Draft_Plan__c> dftoupsert = new List<Draft_Plan__c>();
        //List<Draft_Plan_Header__c> headerupdate = new List<Draft_Plan_Header__c>();
        List<Target_Plan__c> tptoupsert = new List<Target_Plan__c>();
        List<Id> updatedIds = new List<Id>();
        for(SKUWrapper sku : paginationList){
            if(sku.targetTotal != null){
                List<Draft_Plan__c> dfList = skuDraftPlanMap.get(sku.SKUId);
                system.debug('dflist::'+dfList);
                for(Draft_Plan__c df : dfList){
                    if(df.Draft_Quantity__c == null) 
                        df.Draft_Quantity__c = 0;
                    df.Target_Updated__c = true;
                    df.Value_At_Target__c = df.Value_At_Draft__c;
                    df.Pct_Of_Prev_Yr_Target__c = df.Pct_Of_Prev_Yr__c;
                    Decimal drafttoUpdate = (df.Draft_Quantity__c/sku.draftTotal)*sku.targetTotal;
                    if(df.Target_Quantity__c != Math.round(drafttoUpdate)){
                        df.Target_Quantity__c = Math.round(drafttoUpdate);
                        if(df.Product_Price__c != null)
                            df.Target_Amount__c = df.Target_Quantity__c*df.Product_Price__c;
                        dftoupsert.add(df);
                    }
                }
                Target_Plan__c newtp = skuTargetPlanMap.get(sku.SKUId);
                newtp.Target_Quantity__c = sku.targetTotal;
                tptoupsert.add(newtp);
            }
        }
        system.debug('dftoupsert::'+dftoupsert);
        system.debug('tptoupsert::'+tptoupsert);
        upsert dftoupsert;
        upsert tptoupsert;
        return updatedIds;
    }
    
    public class SKUWrapper {
        @AuraEnabled public Boolean fromTargetPlan {get;set;}
        @AuraEnabled public string SKUId {get;set;}
        @AuraEnabled public string SKUName {get;set;}
        @AuraEnabled public string UOM {get;set;}
        @AuraEnabled public string SKUMaterial {get;set;}
        @AuraEnabled public Decimal EDITotal {get;set;}
        @AuraEnabled public Decimal invoiceTotal {get;set;}
        @AuraEnabled public Decimal draftTotal {get;set;}
        @AuraEnabled public Decimal targetTotal {get;set;}
        @AuraEnabled public Boolean editAccess {get;set;}
    }
    
    public class LastSavedWrapper {
        @AuraEnabled public String lastSavedName{get;set;}
        @AuraEnabled public String lastSavedDate{get;set;}
        @AuraEnabled public Boolean showLastSaved{get;set;}
        @AuraEnabled public Boolean editAccess{get;set;}
        @AuraEnabled public Boolean targetAccess{get;set;}
    }
    
     public class divWrapperReg {
        @AuraEnabled public id divId{get;set;}
        @AuraEnabled public string divName{get;set;}
        @AuraEnabled public String divCode{get;set;}
           
    }
}