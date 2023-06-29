public without sharing class DraftPlanRegionEntryClass { 
    public static string salesOrgCodeNAM = '3100';
    public static string salesOrgCodeCanada = '3710';
    public static string currencyCodeNAM = 'USD';
    public static string currencyCodeCanada = 'CAD';
        @AuraEnabled
    public static Integer getHiearchySettings(){
        return Integer.valueof(UPL_Settings__c.getInstance().Draft_Record_Per_Page__c);
    }
    @AuraEnabled
    public static List<divWrapperReg> getDivsions(){
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
    public static CalculateMarkettingYearHelper.MarketingYearWrapper getMarketingYear(){
        //Marketing_Year__c year;
        User currentUser = [select id, Country,Profile.Name from user where id =: UserInfo.getUserId() ];
         string salesOrg;
        if(Test.isRunningTest()){
salesOrg = salesOrgCodeNAM;}
         if(currentUser.Country == 'USA')
            salesOrg = salesOrgCodeNAM;
        else if(currentUser.Country == 'Canada')
            salesOrg = salesOrgCodeCanada;
        return CalculateMarkettingYearHelper.calculateMarketingYear(salesOrg);
    }
    @auraenabled
    public static List<skuRegionnResultWrapper> createDraftPlanRegion(List<finalDraftRegWrapper> finalList,String mktYear ,String salesOrg,string div){
        List<Draft_Plan_Region__c> dprList=new List<Draft_Plan_Region__c>();
        //year
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
        system.debug(finalList.size());
        for(finalDraftRegWrapper fd:finalList){
            system.debug('&&%'+fd.dfrId);
            if(fd.draft!=null){
            Draft_Plan_Region__c dpr=new Draft_Plan_Region__c();
                if(salesOrg==salesOrgCodeNAM){
                dpr.CurrencyIsoCode=currencyCodeNAM;
        }
            else if(salesOrg==salesOrgCodeCanada){
                 dpr.CurrencyIsoCode=currencyCodeCanada; 
            }
            dpr.Region__c=fd.reg;
            dpr.sku__c=fd.sku;
                dpr.Division__c=div;
            dpr.EDI_Quantity_LY__c=fd.ediLastyear;
            dpr.EDI_Quantity_LLY__c=fd.ediLLy;
            dpr.Invoice_Quantity_LY__c=fd.Invoice;
            dpr.Draft_Quantity__c=fd.draft;
           //dpr.Combination_Key__c=String.valueOf(stDate)+
            dpr.MKT_Year_Start_Date__c=startDate;
            dpr.MKT_Year_End_Date__c=endDate;
                dpr.MKT_Year_Name__c=STring.valueof(myear);
            if(fd.dfrId!=null){
                system.debug('hello in id');
                dpr.id=fd.dfrId;
            }
            dprList.add(dpr);
            }
        }
        system.debug('**insize'+dprList.size());
        if(dprList.size()>0){
            upsert dprList;
        }
        List<skuRegionnResultWrapper> resList= new List<skuRegionnResultWrapper>();
        Map<String,Id> resMap= new Map<String,id>();
        
        List<Id> idList=new List<Id>();
            for(Draft_Plan_Region__c dd:dprList){
                system.debug(dd.id);
                idList.add(dd.id);
            skuRegionnResultWrapper res= new skuRegionnResultWrapper();
            res.dprId=dd.id;
            res.skuReg=dd.SKU__c+' '+dd.Region__c;
            resMap.put(dd.SKU__r.Sku_code__c+' '+dd.Region__r.RegionCode__c,dd.id);
            resList.add(res);
        }
        List<Draft_Plan_Region__c> drList=[select id,Combination_Key__c,Draft_Quantity__c,MKT_Year_End_Date__c,MKT_Year_Start_Date__c,MKT_Year_Name__c,
                                            lastModifiedBy.name,LastModifiedDate,Region__c,Region__r.name,SKU__c,SKU__r.Name,SKU__r.SKU_Code__c,SKU__r.Product_Category__c,SKU__r.SKU_Description__c,
                                            EDI_Quantity_LLY__c,EDI_Quantity_LY__c,Invoice_Quantity_LY__c from Draft_Plan_Region__c where
                                            id in:idList and Division__c=:div  order by LastModifiedDate desc limit 1 ];
        if(drList.size()>0){
        for(skuRegionnResultWrapper res:resList){
            
            DateTime dT =  drList[0].LastModifiedDate;
        
            res.saveddate=dT.format('MM-dd-yyyy hh:mm');
            res.savedname=drList[0].lastModifiedBy.name;
            res.showLastSaved=true;
            res.resMap=resMap;
        }
        }
        return resList;
    }
   /* @AuraEnabled
    public static LastSavedWrapper getLastSavedData(){
        User currentUser = [select id, Country,Profile.Name from user where id =: UserInfo.getUserId() ];
        string salesOrg;
        if(currentUser.Country == 'North America')
            salesOrg = salesOrgCodeNAM;
        else if(currentUser.Country == 'Canada')
            salesOrg = salesOrgCodeCanada;
        List<Marketing_Year__c> marketingYear = [select id,Name, Start_Date__c, End_Date__c from Marketing_Year__c  where Sales_Org__r.Sales_Org_Code__c =:salesOrg order by End_Date__c desc limit 1]; 
        List<Target_Plan__c> targetPlanList = [select id,Combination_Key__c,Draft_Quantity__c,MKT_Year_End_Date__c,MKT_Year_Start_Date__c,
                                            Region__c,Region__r.name,SKU__c,SKU__r.Name,SKU__r.SKU_Code__c,SKU__r.Product_Category__c,
                                            EDI_Quantity_LLY__c,EDI_Quantity_LY__c,Invoice_Quantity_LY__c from Draft_Plan_Region__c where
                                            MKT_Year_Start_Date__c >=:marketingYear.Start_Date__c AND 
                                            MKT_Year_End_Date__c <=:marketingYear.End_Date__c and  order by LastModifiedDate desc ];
        LastSavedWrapper last = new LastSavedWrapper();
        if(targetPlanList.size() > 0){
            last.lastSavedName = targetPlanList[0].LastModifiedBy.Name;
            DateTime dT =  targetPlanList[0].LastModifiedDate;
            last.lastSavedDate = dT.format('MM-dd-yyyy hh:mm');
            last.showLastSaved = true;
        }
        else
            last.showLastSaved = false;  
        return last;
    }*/
@auraenabled
    public static dfRegionWrapper generateWrapper(String mktYear,String div){
        //Division__c divreg=[select id,Division_Code__c,name from Division__c where Division_Code__c=:div];
        dfRegionWrapper dffinalwrap=new dfRegionWrapper();
        String sorg;
        //Marketing_Year__c year;
        
        User currentUser = [select id, Country,Profile.Name,profile.Id from user where id =: UserInfo.getUserId() ];
        if(currentUser.Country == 'USA'){
            //year=CalculateMarkettingYearHelper.calculateYear(salesOrgCodeNAM);
            sorg=salesOrgCodeNAM;
        }
        else if(currentUser.Country == 'Canada'){
             //year=CalculateMarkettingYearHelper.calculateYear(salesOrgCodeCanada);
            sorg=salesOrgCodeCanada;
        }
        if(Test.isRunningTest()){
            sorg=salesOrgCodeNAM;
        }
        CalculateMarkettingYearHelper.MarketingYearWrapper mktYearWrapper = CalculateMarkettingYearHelper.calculateMarketingYear(sorg);
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
        List<Sales_Org__c> sorglst = [Select id, name,Sales_Org_Code__c from Sales_Org__c where Sales_Org_Code__c =:sorg limit 1];

        Integer curYear=Integer.valueof(myear);
        Integer prevYear=endDate.year()-1;
        Integer prevLastYear=endDate.year()-2;
        dffinalwrap.curYear=String.valueOf(curYear);
        dffinalwrap.prevYear=String.valueOf(prevYear);
        dffinalwrap.prevLastYear=String.valueOf(prevLastYear);
        dffinalwrap.curStart=startDate;
        dffinalwrap.curEnd=endDate;
        dffinalwrap.sorg=sorg;
        Date PrevLaststart=startDate.addYears(-2);
        Date Laststart=startDate.addYears(-1);
        Date PrevLastEnd=endDate.addYears(-2);
        Date LastEnd=endDate.addYears(-1);
        
        system.debug('***dates'+PrevLaststart+PrevLastEnd);
        List<Region__c> RegList = [SELECT Id, Name, RegionCode__c, RegionHead__c, SBU__c, Zone__c,
                                   SalesOrg__c, RegionHeadActive__c, Neglected__c, Sales_Org_Code__c
                                   FROM Region__c where Sales_Org_Code__c =:sorg 
                                  ];

        List<SKU__c> skuList=[SELECT Id, Category__c, Material_Group__c, Brand_Name__c, Unit_Cost__c,
                             Division__c, Product_with_SKU__c, Material_type__c, Distribution_Channel__c,
                              Sales_Org_Code__c,Sales_Org__c ,SKU_Code__c,Name,Product_Category__c,SKU_Description__c,UOM__c
                            FROM SKU__c where Sales_Org_Code__c =:sorg and Division__c=:div and isParent__c=true order by Product_Category__c];
        
        Map<Id,List<Id>> skuRegionMap=new Map<Id,List<Id>>();
        List<skuRegionnWrapper> skrWrapperList=new List<skuRegionnWrapper>();
        Map<STring,finalDraftRegWrapper> skrWrapperMap=new map<String,finalDraftRegWrapper>();
        for(SKU__c sk:skuList){
            for(Region__c re:RegList){
                if(skuRegionMap.containsKey(sk.Id))
            {
                skuRegionMap.get(sk.Id).add(re.Id);
                
            }
            else
            {
                skuRegionMap.put(sk.Id,new List<Id>{re.Id});//to check
            }
                skuRegionnWrapper skr=new skuRegionnWrapper();
                skr.sku=sk;
                skr.reg=re;
                skr.skuReg=sk.SKU_Code__c+' '+re.RegionCode__c;
                skrWrapperList.add(skr);
                //skrWrapperMap.put(skr.skuReg,skr);
        }
        }
        
        system.debug('skwrap'+skrWrapperList.size()+' '+skrWrapperList);
                system.debug('sku'+skuList);
        system.debug('reg'+RegList);

                system.debug('div'+div);
                system.debug('mktdate'+startDate+' '+endDate);


        List<Draft_Plan_Region__c> dfrList=[select id,Combination_Key__c,Draft_Quantity__c,MKT_Year_End_Date__c,MKT_Year_Start_Date__c,MKT_Year_Name__c,
                                            Region__c,Region__r.name,Region__r.RegionCode__c,SKU__c,SKU__r.Name,SKU__r.SKU_Code__c,SKU__r.Product_Category__c,SKU__r.SKU_Description__c,sku__r.UOM__c,
                                            EDI_Quantity_LLY__c,EDI_Quantity_LY__c,Invoice_Quantity_LY__c from Draft_Plan_Region__c where
                                            MKT_Year_Start_Date__c >=:startDate AND 
                                            MKT_Year_End_Date__c <=:endDate AND SKU__c in:skuList
                                            AND Region__c in:RegList AND Division__c=:div order by SKU__r.Name];
        system.debug('dfrList'+dfrList.size()+dfrList);
       
        List<finalDraftRegWrapper> finalList=new List<finalDraftRegWrapper>();
        for(Draft_Plan_Region__c dr:dfrList){
            finalDraftRegWrapper fp=new finalDraftRegWrapper();
            String sname = dr.sku__r.SKU_Code__c.replaceFirst('^0+','');
            fp.SkuName= sname +'-'+dr.sku__r.SKU_Description__c;
            fp.RegionName=dr.Region__r.name;
            fp.Category=dr.SKU__r.Product_Category__c;
            fp.skuUOM=dr.sku__r.UOM__c;
            fp.skuUOM=dr.sku__r.UOM__c;
            fp.dfrId=dr.id;
            fp.ediLLy=dr.EDI_Quantity_LLY__c;
            fp.ediLastyear=dr.EDI_Quantity_LY__c;
            fp.Invoice=dr.Invoice_Quantity_LY__c;
            fp.draft=dr.Draft_Quantity__c;
            fp.sku=dr.sku__c;
            fp.reg=dr.Region__c;
            fp.skuReg=dr.sku__r.SKU_Code__c+' '+dr.Region__r.RegionCode__c;
            skrWrapperMap.put(dr.sku__r.SKU_Code__c+' '+dr.Region__r.RegionCode__c,fp);
            finalList.add(fp);
        }
        system.debug('finalList***'+finalList.size()+skrWrapperMap);
        system.debug('skrWrapperList'+skrWrapperMap.size());
        Integer count=0;
        List<skuRegionnWrapper> skrWrapDfrList=new List<skuRegionnWrapper>();
        Set<skuRegionnWrapper> skrWrapDfrSet=new Set<skuRegionnWrapper>();
        Set<Sku__c> skuRemDfSet=new Set<Sku__c>();
        Set<Region__c> regRemDfSet=new Set<Region__c>();
        List<Sku__c> skuRemDfList=new List<Sku__c>();
        List<Region__c> regRemDfList=new List<Region__c>();
        
           system.debug('hhhh'+skrWrapperMap);
                for(skuRegionnWrapper skw:skrWrapperList){
                if(skrWrapperMap.get(skw.skuReg)==null ){
                    //system.debug(skrWrapDfrSet);
                    skrWrapDfrSet.add(skw);
                    skuRemDfSet.add(skw.sku);
                    regRemDfSet.add(skw.reg);
                    
                }
                
            }
        
        system.debug('skrWrapDfrSet'+skrWrapDfrSet);
        skrWrapDfrList.addAll(skrWrapDfrSet);
        skuRemDfList.addAll(skuRemDfSet);
        regRemDfList.addAll(regRemDfSet);
        system.debug('count'+count+skrWrapDfrList.size()+'*'+skuRemDfList.size()+'*'+regRemDfList.size());
        AggregateResult[] aggregateInvPlan = [SELECT SKU__r.sku_parent_Code__c skcode,Invoice__r.Sold_to_Party__r.Region__r.RegionCode__c reg,SUM(Quantity__c) invtotal
                                                FROM Invoice_Line_Item__c where Invoice__r.Sales_Org__r.Sales_Org_Code__c=:sorg
                                                AND Invoice__r.Billing_Date__c>=:startDate and Invoice__r.Billing_Date__c<=:endDate and Invoice__r.Division__c=:div
                                                GROUP BY SKU__r.sku_parent_Code__c,Invoice__r.Sold_to_Party__r.Region__r.RegionCode__c];
        Map<String,Decimal> invTotalMap = new Map<String,Decimal>();
        
       for (AggregateResult ar : aggregateInvPlan)  {
            //system.debug(ar.get('reg'));
            String skureg=String.valueof(ar.get('skcode'))+' '+String.valueof(ar.get('reg'));
            //system.debug('skureg'+skureg);
            invTotalMap.put(skureg,(Decimal)ar.get('invtotal'));
            }
       AggregateResult[] aggregatedraftPlan = [SELECT SKU__r.Sku_code__c skcode,Draft_Plan_Header__r.Distributor__r.Region__r.RegionCode__c reg,SUM(Draft_Quantity__c) drafttotal
                                           FROM Draft_Plan__c where Draft_Plan_Header__r.MKT_Year_Start_Date__c>=:startDate
                                               AND Draft_Plan_Header__r.MKT_Year_End_Date__c<=:endDate
                                             AND Draft_Plan_Header__r.Sales_Org__r.Sales_Org_Code__c =:sorg
                                             AND Draft_Plan_Header__r.Division__c=:div
                                                GROUP BY  SKU__r.Sku_code__c,Draft_Plan_Header__r.Distributor__r.Region__r.RegionCode__c];
        Map<String,Decimal> draftTotalMap = new Map<String,Decimal>(); 
        for (AggregateResult ar : aggregatedraftPlan)  {
            //system.debug(ar.get('reg'));
            //if
            String skureg=String.valueof(ar.get('skcode'))+' '+String.valueof(ar.get('reg'));
            //system.debug('skureg'+skureg);
            draftTotalMap.put(skureg,(Decimal)ar.get('drafttotal'));
            }
        system.debug('***'+draftTotalMap.KeySet());
        Map<String,Decimal> ediTotalMap=getEdiTotal(sorg,Laststart,LastEnd,div);
        Map<String,Decimal> ediTotalprevMap=getEdiTotal(sorg,PrevLaststart,PrevLastEnd,div);
        system.debug('ediTotalMap'+ediTotalMap);
        for(skuRegionnWrapper srem:skrWrapDfrList){
            //if(){
            //system.debug(srem.sku.SKU_Code__c+' '+srem.reg.RegionCode__c+'***'+finalList.size());
            finalDraftRegWrapper fp=new finalDraftRegWrapper();
            fp.SkuName=srem.sku.SKU_Code__c +'-'+srem.sku.SKU_Description__c;
            fp.RegionName=srem.reg.name;
            fp.Category=srem.sku.Product_Category__c;
            fp.skuUOM=srem.sku.uom__c;
            fp.sku=srem.sku.id;
            fp.reg=srem.reg.Id;
            //fp.dfrId=dr.id;
            fp.skuReg=srem.sku.SKU_Code__c+' '+srem.reg.RegionCode__c;
             fp.ediLastyear=ediTotalMap.get(srem.sku.SKU_Code__c+' '+srem.reg.RegionCode__c);
           fp.ediLLy=ediTotalprevMap.get(srem.sku.SKU_Code__c+' '+srem.reg.RegionCode__c);
            //system.debug('inv'+ediTotalMap.get(srem.sku.id+' '+srem.reg.Id));
            fp.Invoice=invTotalMap.get(srem.sku.SKU_Code__c+' '+srem.reg.RegionCode__c);
            //system.debug('inv'+invTotalMap.get(srem.sku.id+' '+srem.reg.Id));
            fp.draft=draftTotalMap.get(srem.sku.SKU_Code__c+' '+srem.reg.RegionCode__c);
            //system.debug('fp'+fp.draft);
            finalList.add(fp);
            //}
        }
        system.debug('finalList'+finalList.size());
        List<finalDraftRegWrapper>ffList=new list<finalDraftRegWrapper>();
        for(finalDraftRegWrapper ff:finalList){
            if(ff.dfrId==null && ff.draft!=null){
                ffList.add(ff);
            }
        }
        List<skuRegionnResultWrapper> createList=createDraftPlanRegion(ffList,mktYear,sorg,div);
        if(createList.size()>0){
        for(finalDraftRegWrapper f:finalList){
            //system.Debug(createList[0].resMap.get(f.skuReg));
            //if(){}
            f.dfrId=createList[0].resMap.get(f.skuReg);
        }
        }
        dffinalwrap.finalWrap=finalList;
        List<Draft_Plan_Region__c> drList=[select id,Combination_Key__c,Draft_Quantity__c,MKT_Year_End_Date__c,MKT_Year_Start_Date__c,
                                            lastModifiedBy.name,LastModifiedDate,Region__c,Region__r.name,SKU__c,SKU__r.Name,SKU__r.SKU_Code__c,SKU__r.Product_Category__c,SKU__r.SKU_Description__c,
                                            EDI_Quantity_LLY__c,EDI_Quantity_LY__c,Invoice_Quantity_LY__c from Draft_Plan_Region__c where
                                            MKT_Year_Start_Date__c >=:startDate AND 
                                            MKT_Year_End_Date__c <=:endDate AND SKU__c in:skuList
                                            AND Region__c in:RegList and Division__c=:div order by LastModifiedDate desc limit 1 ];
       
        if(drList.size()>0){
             DateTime dT =  drList[0].LastModifiedDate;
        dffinalwrap.saveddate=dT.format('MM-dd-yyyy hh:mm');
        dffinalwrap.savedname=drList[0].lastModifiedBy.name;
        dffinalwrap.showLastSaved=true;
        }
        else{
            dffinalwrap.showLastSaved=false;
        }
        id pid=Userinfo.getProfileId();
        List<ObjectPermissions> objectperm = [SELECT Id, SObjectType,PermissionsRead,PermissionsEdit FROM ObjectPermissions WHERE parentid in (select id from permissionset where PermissionSet.Profile.Id=:pid) And SObjectType = 'Draft_Plan_Region__c' LIMIT 1];
        if(objectperm.size() > 0)
            dffinalwrap.editAccess = objectperm[0].PermissionsEdit;
        return dffinalwrap;
    }
    public static Map<String,Decimal> getEdiTotal(String sorg,Date startDate,Date endDate,STring div){
        AggregateResult[] aggregatedraftPlan = [SELECT Product_Name__r.sku_parent_Code__c skcode,Sold_to_Party__r.region__r.RegionCode__c reg,SUM(Product_Quantity__c) ediTotal
                                           FROM Secondary_Sales_Data__c where Sales_Org__r.Sales_Org_Code__c =:sorg
                                           and Sold_to_Party__r.region__c!=null and Sales_Date__c>=:startDate
                                                and Sales_Date__c<=:endDate and Division__c=:div
                                            GROUP BY Product_Name__r.sku_parent_Code__c,Sold_to_Party__r.region__r.RegionCode__c];
        Map<String,Decimal> ediTotalMap = new Map<String,Decimal>();
        for (AggregateResult ar : aggregatedraftPlan)  {
            system.debug(ar.get('skcode'));
            String skureg=String.valueof(ar.get('skcode'))+' '+String.valueof(ar.get('reg'));
            ediTotalMap.put(skureg,(Decimal)ar.get('ediTotal'));
            }
        //system.debug('ediTotalMap'+ediTotalMap);
        return ediTotalMap;
    }
     
    public class dfRegionWrapper {
        
        @AuraEnabled public string curYear{get;set;}
        @AuraEnabled public String prevYear{get;set;}
        @AuraEnabled public String prevLastYear{get;set;}
        @AuraEnabled public List<finalDraftRegWrapper> finalWrap{get;set;}
        @AuraEnabled public date curStart{get;set;}
        @AuraEnabled public date curEnd{get;set;}
        @AuraEnabled public String sorg{get;set;}
        @AuraEnabled
        public Boolean showLastSaved{get;set;}
        @AuraEnabled public string savedname{get;set;}
        @AuraEnabled public String saveddate{get;set;}
        @AuraEnabled public boolean editAccess{get;set;}
           
    }
    public class skuRegionnWrapper {
        
        @AuraEnabled public Sku__c sku{get;set;}
        @AuraEnabled public Region__c  reg{get;set;}
        @Auraenabled public string skuReg{get;set;}
        
        }
    public class finalDraftRegWrapper {
        
        @AuraEnabled public Id sku{get;set;}
        @AuraEnabled public Id  reg{get;set;}
        @AuraEnabled public Decimal ediLLy  {get;set;}
        @AuraEnabled public Decimal ediLastyear  {get;set;}
        @AuraEnabled public Decimal Invoice  {get;set;}
        @AuraEnabled public Decimal draft  {get;set;}
        @AuraEnabled public Id dfrId  {get;set;}
        @AuraEnabled public String SkuName  {get;set;}
        @AuraEnabled public String Category  {get;set;}
        @AuraEnabled public String skuUOM  {get;set;}
        @AuraEnabled public String RegionName  {get;set;}
        @AuraEnabled public String  skuReg{get;set;}
        }
    public class skuRegionnResultWrapper {
        @AuraEnabled public Id dprId{get;set;}
        @AuraEnabled public String  skuReg{get;set;}
        @AuraEnabled public string savedname{get;set;}
        @AuraEnabled public String saveddate{get;set;}
        @AuraEnabled
        public Boolean showLastSaved{get;set;}
        @AuraEnabled
        public Map<String,Id> resMap{get;set;}
        }
    public class divWrapperReg {
        @AuraEnabled public id divId{get;set;}
        @AuraEnabled public string divName{get;set;}
        @AuraEnabled public String divCode{get;set;}
           
    }
}