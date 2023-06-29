public without sharing class Grz_LiquidationClassNew {
     public map<String,String> monthIntMap =new map<String,String>();
   
      public Grz_LiquidationClassNew(){
        
        monthIntMap.put('Jan','1');
        monthIntMap.put('Feb','2');
        monthIntMap.put('Mar','3');
        monthIntMap.put('Apr','4');
        monthIntMap.put('May','5');
        monthIntMap.put('Jun','6');
        monthIntMap.put('Jul','7');
        monthIntMap.put('Aug','8');
        monthIntMap.put('Sept','9');
        monthIntMap.put('Oct','10');
        monthIntMap.put('Nov','11');
        monthIntMap.put('Dec','12');
      }
    
    
    @AuraEnabled(cacheable=true)
    public static monthWrapper getMonths(boolean firstRun) {
        system.debug('yipeee--firstRun--');
        monthWrapper monthWrap = new monthWrapper();
        Map<String,String> monthMap = new Map<String,String>();
       system.debug('firstRun--'+firstRun);
        if(firstRun){
            DateTime todaysDate = System.today();
            system.debug('todaysDate--'+todaysDate);
        Date myDate = todaysDate.dateGMT();
            system.debug('Integer.valueOf(myDate.Month())--'+myDate.Month());
        for(Integer i = 4; i < Integer.valueOf(myDate.Month())+12 ; i++){
            
           // Integer month = i%12;
             Integer month = math.mod(i,12);
            system.debug('before month--'+month);
            if(month == 0){
                month = 12;
            }
            system.debug('after month--'+month);
            String dateString = DateTime.valueOf('2020-'+month+'-01 00:00:00').format('MMMM dd, yyyy');
            system.debug('dateString--'+dateString);
            String sMonth = dateString.split(' ')[0];
             system.debug('sMonth--'+sMonth);
            system.debug(sMonth);
            if(i == 9){
                monthMap.put(sMonth,sMonth.substring(0,4));
                
            }
            else{
                monthMap.put(sMonth,sMonth.substring(0,3));
            }
        }
        system.debug('monthMap--'+monthMap);

        monthWrap.monthMapFinal = monthMap;
        monthWrap.mapSize = monthMap.size();
        Integer monthValue = Integer.valueOf(myDate.Month()-1);
        String dateString = DateTime.valueOf('2020-'+monthValue+'-01 00:00:00').format('MMMM dd, yyyy');
        String sMonth = dateString.split(' ')[0];
        if(monthValue == 9){
            monthWrap.currentMonth = sMonth.substring(0,4); 
        }
        else{
            monthWrap.currentMonth = sMonth.substring(0,3); 
        }
        }
        
        
        return monthWrap;
    }
    @AuraEnabled(cacheable=true)
    public static FinalLiquidationDataWrapper getLiquidationRecord(Integer count ,String searchKey, String yearfilter, String monthfilter) {
        system.debug('yearfilter---'+yearfilter);
        system.debug('monthfilter----'+monthfilter);
          system.debug('searchKey----'+searchKey);
        boolean openinv;
        boolean liquid;
         Id rec_type = Schema.SObjectType.Liquidation2__c.getRecordTypeInfosByName().get('Multi Country').getRecordTypeId();
        System.debug('rec type '+rec_type);
          FinalLiquidationDataWrapper objDT =  new FinalLiquidationDataWrapper();
         List<String> popYearList = new List<String>();
        Id id = UserInfo.getUserId(); // getting current user info
        System.debug('id'+id);
        String territory;
        List<User> user = [SELECT Id, Username, AccountId, ContactId, profile.name FROM User where Id =: id];
        String accountId = user[0].AccountId;
        system.debug('accountId'+accountId);
        List<String> salesorgcode = System.Label.Grz_IndiaSalesOrgCodeNew.Split(',');
        system.debug('salesorgcode : '+salesorgcode);
        
        
        SET <String> popuYear = NEW SET <String>();
       
         string rtForAnnualPlan = Schema.SObjectType.Liquidation_Annual_Plan__c.getRecordTypeInfosByName().get('Multi Country').getRecordTypeId();
     System.debug('rtForAnnualPlan--'+rtForAnnualPlan);
        List <Liquidation_Annual_Plan__c> populateYearList = [SELECT Id, Name, Fiscal_Year__c, Distributor__c, Territory_Name__c,Territory_Name__r.Name, Fiscal_Start_Date__c, Fiscal_End_Date__c
                                                              FROM Liquidation_Annual_Plan__c 
                                                              WHERE Sales_Org__r.Sales_Org_Code__c in:salesorgcode
                                                              AND RecordTypeId =:rtforAnnualPlan AND Distributor__c =:accountId];
        
        for(Liquidation_Annual_Plan__c laPObj :populateYearList){
            popuYear.add(laPObj.Fiscal_Year__c);
            
          
        }
        
        popYearList =new List<String>(popuYear);
        popYearList.sort();
        system.debug('popYearList-->>'+popYearList);    
         Date start_date;
        List<String> yeardatalist;
        List<Liquidation2__c> lst_liquidation = new List<Liquidation2__c>();
      
       String query = 'Select id,Total_Market_Inventory__c,Retailers_Inventory__c,submitted__c,Plan_for_the_month__c,Plan_for_the_next_month__c,Opening_Inventory2__c,Opening_Inventory2__r.Opening_Inventory__c,SKU__r.Brand_Name__c,SKU__r.SKU_Code__c,SKU__r.SKU_Description__c,YTD_Sales__c,Liquidation_YTD__c,Total_Available_Stock__c,Distributor__c,Distributors_Inventory__c,Month__c,Liquidation_Percent_YTD__c,Brand_Name__c,SKU_Code__c,SKU_Description__c,YTD_Sales_formula__c from Liquidation2__c';
       
        String filter = '  where SKU__r.Active_for_Liquidation__c = true and Liquidation_Annual_Plan__r.Sales_Org__r.Sales_Org_Code__c in:salesorgcode and RecordTypeId=:rec_type';
           if (!string.IsBlank(accountId)) {
            system.debug('accountId====='+accountId);
            filter += filter.contains('where') ? ' and' : ' where';
           
            filter +=  ' Distributor__c =: accountId';
        }
        
        if (!string.IsBlank(searchKey)) {
            system.debug('search====='+searchKey);
            filter += filter.contains('where') ? ' and' : ' where';
            filter += ' (SKU__r.Brand_Name__c like \'%' +searchKey+ '%\' or SKU__r.SKU_Code__c like \'%' +searchKey+ '%\' or SKU__r.SKU_Description__c like \'%' +searchKey+ '%\')' ;
        }
         if (!string.IsBlank(yearfilter)) {
            system.debug('yearfilter====='+yearfilter);
              // yeardatalist = yearfilter.split('-');
           // start_date = Date.newInstance(Integer.valueOf(yeardatalist[0]), 4, 1); 
            filter += filter.contains('where') ? ' and' : ' where';
          
               filter +=  '  Liquidation_Annual_Plan__r.Fiscal_Year__c =: yearfilter';   
            
        }
         if (!string.IsBlank(monthfilter)) {
            system.debug('monthfilter====='+monthfilter);
            filter += filter.contains('where') ? ' and' : ' where';
            
              filter +=  ' Month__c =: monthfilter';
        }
         
        
        query += filter;
        query +=' order by Brand_Name__c ASC';
        System.debug('query-----' +query);
        
        lst_liquidation = Database.query(query);  
        System.debug('lst_liquidation-----' +lst_liquidation.size());
          List<ResultWrapper> tmpList  = new List<ResultWrapper>();
        decimal total=0;
        
         Grz_LiquidationClassNew lit = new Grz_LiquidationClassNew();
        List<Multi_Country_Liquidation__c> mcl = [select id,name,Country__c,Month__c,Edit_Start_Day__c,Edit_End_Day__c,Type__c from Multi_Country_Liquidation__c where Type__c = 'Liquidation' and Country__c= 'India' limit 1];// Edit country lit.country_name
         if(mcl.size()>0){
             String month_key = String.valueOf(mcl[0].Month__c).subString(0,3);
            System.debug('month_key...'+month_key);
        if(month_key=='Sep'){
            month_key = month_key+'t';
        }
        
        if(String.valueOf(System.today().month())==lit.monthIntMap.get(month_key)){ 
           // if(System.today().day()>=mcl[0].Edit_Start_Day__c && System.today().day()<=mcl[0].Edit_End_Day__c){
                System.debug('start getLiquidationEditDates TRUE');
                liquid = false;
            }else{
                System.debug('start getLiquidationEditDates FALSE');
                liquid = true;
            }
        }
        
            
        List<Multi_Country_Liquidation__c> multicountrylist = [SELECT Id, Name, Edit_End_Day__c, Edit_Start_Day__c, Month__c, Country__c, Type__c  FROM Multi_Country_Liquidation__c where Type__c = 'Opening Inventory' and Country__c='India' limit 1];
        DateTime dt = System.today();
        Date dt1 = dt.dateGmt();
        Integer year = Integer.valueOf(dt1.year());
        Integer month = Integer.valueOf(dt1.month());
         String msg;
        if(multicountrylist.size()>0){
             String month_key = String.valueOf(multicountrylist[0].Month__c).subString(0,3);
            System.debug('month_key...'+month_key);
        if(month_key=='Sep'){
            month_key = month_key+'t';
        }
            if((multicountrylist[0].Edit_End_Day__c!=null) || (multicountrylist[0].Edit_Start_Day__c!=null) || (multicountrylist[0].Month__c!=null && multicountrylist[0].Month__c!='')){
                if(String.valueOf(System.today().month())==lit.monthIntMap.get(month_key))
        { 
            System.debug('multicountrylist[0].Edit_Start_Day__c'+multicountrylist[0].Edit_Start_Day__c);
              System.debug('multicountrylist[0].Edit_Start_Day__c'+multicountrylist[0].Edit_End_Day__c);
            if(multicountrylist[0].Edit_Start_Day__c== null || multicountrylist[0].Edit_End_Day__c== null){
                 msg = 'Opening Inventory Dates Not Entered Properly';
            }
            else{
            if(System.today().day()>=multicountrylist[0].Edit_Start_Day__c && System.today().day()<=multicountrylist[0].Edit_End_Day__c)
            {
                System.debug('start getLiquidationEditDates TRUE');
                openinv = false;
            }else{
                System.debug('start getLiquidationEditDates FALSE');
                openinv = true;
                
            }
        }
            }
                else{
                    openinv = true;
                }
        }else{
            openinv = true;
             msg = 'Opening Inventory Dates Not Entered Properly';
        }
         System.debug('openinv--'+openinv);   
        }
         
      
        for(Liquidation2__c liqui : lst_liquidation)
        {
             ResultWrapper obj = new ResultWrapper();
            obj.OpeninvEdit = openinv;
          
            obj.openingId = liqui.Opening_Inventory2__c;
            obj.LiquidationEdit = liquid;
            obj.Id=liqui.Id;
            obj.submitVar=liqui.submitted__c;
            obj.SKU_Code = liqui.SKU__r.SKU_Code__c ;
            obj.SKU_Description = liqui.SKU__r.SKU_Description__c ;
            obj.BrandName = liqui.SKU__r.Brand_Name__c ;
           obj.OpeningInventory=liqui.Opening_Inventory2__r.Opening_Inventory__c;
            obj.YTDSales=liqui.YTD_Sales_formula__c;
            obj.TotalAvailablestock=liqui.Total_Available_Stock__c;
        //obj.TotalAvailablestock= obj.OpeningInventory + obj.YTDSales;
            obj.DistributorsInventory=liqui.Distributors_Inventory__c;
            obj.RetailersInventory=liqui.Retailers_Inventory__c;
            obj.TotalMarketInventory=liqui.Total_Market_Inventory__c;
            obj.PlanYTDmonth=liqui.Plan_for_the_month__c;
            obj.PlanNextMonth = liqui.Plan_for_the_next_month__c;
            //obj.ProductBudget
            obj.LiquidationYTDmonth=liqui.Liquidation_YTD__c;
            
            obj.LiquidationYTDmonthpercentage=liqui.Liquidation_Percent_YTD__c;
            tmpList.add(obj);
        } 
        
        //test the code
          system.debug('----test the code----');
        if(tmpList.size() > 0){
            ResultWrapper tmp_obj = tmpList[0];
                  system.debug('----tmp_obj----'+tmp_obj);
             system.debug('----tmp_obj.submitVar----'+tmp_obj.submitVar);
            if (tmp_obj.submitVar == True)
            {
                 system.debug('----test the code----');
              
                    tmp_obj.OpeninvEdit = true;
        
                    tmp_obj.LiquidationEdit = true;
                objDT.productWrapList = tmpList;       
                objDT.yeardata = popYearList;
               
                system.debug('----objDT----'+objDT);
               
                return objDT;
            }
        }               
            
     
      
       
       
      
        objDT.productWrapList = tmpList;
       // objDT.prodListSize = finalproductlist.size();
     
          objDT.Errormsg = msg;
        objDT.yeardata = popYearList;
       
        system.debug('----objDT----'+objDT);
       
        return objDT;
    } 
    
      @AuraEnabled
    public static String updateOpeningInventory(String oi_id,string value){
        
        try{
             system.debug('oi_id--'+oi_id);
        system.debug('value--'+value);
        Opening_Inventory2__c op = [Select id,Opening_Inventory__c from Opening_Inventory2__c where Id=:oi_id limit 1];
        op.Opening_Inventory__c = Double.valueOf(value);
        update op;
            
        }
        catch(Exception e){
              System.debug('The following exception has occurred in opening inv: ' + e.getMessage());
           
             
        }
       
       return value;
    }
     @AuraEnabled
    public static String updateDistributorInventory(String liq_id, string value){
         system.debug('liq_id--'+liq_id);
      system.debug('value--'+value);
        Liquidation2__c Li = [Select id,Distributors_Inventory__c from Liquidation2__c where Id=:liq_id limit 1];
        Li.Distributors_Inventory__c = Double.valueOf(value) ;
        update Li;
         return value;
    }
     @AuraEnabled
    public static String updateRetailerInventory(String liq_id,string value){
        try{
              system.debug('liq_id--'+liq_id);
      system.debug('value--'+value);
        Liquidation2__c Li = [Select id,Retailers_Inventory__c from Liquidation2__c where Id=:liq_id limit 1];
        Li.Retailers_Inventory__c = Double.valueOf(value);
        update Li;
        
        }
       catch(Exception e) {
    System.debug('The following exception has occurred: ' + e.getMessage());
}
         return value; 
    }
    @AuraEnabled
    public static void updateSubmit(List<ResultWrapper> tmpList){
        System.debug('tmpList--'+tmpList);
        List<Liquidation2__c> lst_submit =  new List<Liquidation2__c>();
        Set<String> updateids = new Set<String>();
        for(ResultWrapper tmpListobj:tmpList ){
            tmpListobj.OpeninvEdit = true;
              tmpListobj.LiquidationEdit = true;
           updateids.add(tmpListobj.Id);
        }
         system.debug('updateids...'+updateids);
        List<Liquidation2__c> lst_liqui = [Select id,submitted__c from Liquidation2__c where Id in:updateids];
         for(Liquidation2__c liq:lst_liqui){
            liq.submitted__c = true;
            lst_submit.add(liq);
        }
        system.debug('lst_submit...'+lst_submit);
        update lst_submit;
   }
    
     
 public class ResultWrapper {
        @AuraEnabled
        public String Id{get;set;}
      @AuraEnabled
        public String openingId{get;set;}
     @AuraEnabled
        public Boolean submitVar{get;set;}
        @AuraEnabled
        public String BrandName{get;set;}
         @AuraEnabled
        public String SKU_Code{get;set;}
         @AuraEnabled
        public String SKU_Description{get;set;}
        @AuraEnabled
        public Decimal OpeningInventory{get;set;}
         @AuraEnabled
        public Decimal PlanNextMonth{get;set;}
        @AuraEnabled
        public Decimal YTDSales{get;set;}
        @AuraEnabled
        public Decimal TotalAvailablestock{get;set;}
        @AuraEnabled
        public Decimal DistributorsInventory{get;set;}
        @AuraEnabled
        public Decimal RetailersInventory{get;set;}
        @AuraEnabled
        public Decimal TotalMarketInventory{get;set;}
        @AuraEnabled
        public Decimal PlanYTDmonth{get;set;}
        @AuraEnabled
        public Decimal ProductBudget{get;set;}
        @AuraEnabled
        public Decimal LiquidationYTDmonth{get;set;}
        @AuraEnabled
        public Decimal LiquidationYTDmonthpercentage{get;set;}
        @AuraEnabled
        public List<String> yeardata{get;set;}
        @AuraEnabled
        public boolean OpeninvEdit{get;set;}
         @AuraEnabled
        public boolean LiquidationEdit{get;set;}
     
     
    }
    
    
    public class FinalLiquidationDataWrapper {
        
        @AuraEnabled
        public List<ResultWrapper> productWrapList {get;set;}
        @AuraEnabled
        public String Errormsg{get;set;}
       
        @AuraEnabled
        public List<String> yeardata{get;set;}
        
    }
    public class monthWrapper{
        @AuraEnabled
        public Map<String,String> monthMapFinal {get;set;}
        @AuraEnabled
        public String currentMonth {get;set;}
        @AuraEnabled
        public Integer mapSize {get;set;}
    }
}