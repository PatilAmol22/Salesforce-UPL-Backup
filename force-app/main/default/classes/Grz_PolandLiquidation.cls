public class Grz_PolandLiquidation {
    public String country_name = 'Poland';
    public map<String,String> monthIntMap =new map<String,String>();
    public Map<String,Integer> QuarterMap =new map<String,Integer>();
    public Grz_PolandLiquidation(){
        
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
        
        QuarterMap.put('Quarter 1',1);
        QuarterMap.put('Quarter 2',2);
        QuarterMap.put('Quarter 3',3);
        QuarterMap.put('Quarter 4',4);
        
        List<User> u = [Select id,Country from User where Id=:UserInfo.getUserId()];
        if(!u.isEmpty()){
            if(String.isEmpty(u[0].Country)){
                country_name = 'Poland';
            }else{
                country_name = u[0].Country;
            }
        }
        
        if(Test.isRunningTest()){
            country_name = 'Poland';
        }
    }
    
    // getting Current login user's Country
    @AuraEnabled(cacheable = true)
    public static string getUserCountry(){
        Grz_PolandLiquidation obj = new Grz_PolandLiquidation();
        System.debug('obj.country_name : '+obj.country_name);
        return obj.country_name;
    }
    
    // for checking Liquidation Edit Dates window on POG Screen
    @AuraEnabled(cacheable=true)
    public static Boolean getLiquidationEditDates(){
        Grz_PolandLiquidation lit = new Grz_PolandLiquidation();
        System.debug('Country Name==>'+lit.country_name);
        Boolean isLiquidationTrue = false;
        List<Multi_Country_Liquidation__c> mcl = [select id,name,Country__c,Edit_Start_Day__c,Edit_End_Day__c,Type__c,Quarter__c from Multi_Country_Liquidation__c where Type__c = 'Liquidation' and Country__c=:lit.country_name limit 1];// Edit country lit.country_name
        if(!mcl.isEmpty()){
            if((System.today().Month()==4 && mcl[0].Quarter__c=='Quarter 4') || (System.today().Month()==7 && mcl[0].Quarter__c=='Quarter 1') || (System.today().Month()==10 && mcl[0].Quarter__c=='Quarter 2') || (System.today().Month()==1 && mcl[0].Quarter__c=='Quarter 3')){
                if(System.today().day()>=mcl[0].Edit_Start_Day__c && System.today().day()<=mcl[0].Edit_End_Day__c){
                    System.debug('start getLiquidationEditDates TRUE');
                    isLiquidationTrue = true;
                }else{
                    System.debug('start getLiquidationEditDates FALSE');
                    isLiquidationTrue = false;
                }
            }
            else{
                isLiquidationTrue = false;
            }
        }
        return isLiquidationTrue;
    }
    
    // for checking OpeningInventory Edit Dates window on POG Screen
    @AuraEnabled(cacheable=true)
    public static Boolean getOpeningInventoryEditDates(){
        Grz_PolandLiquidation lit = new Grz_PolandLiquidation();
        System.debug('Country Name==>'+lit.country_name);
        Boolean isOpeningInventory = false;
        List<Multi_Country_Liquidation__c> mcl = [select id,name,Month__c,Country__c,Edit_Start_Day__c,Edit_End_Day__c,Type__c from Multi_Country_Liquidation__c where Type__c = 'Opening Inventory' and Country__c=:lit.country_name limit 1];// Edit country lit.country_name
        String month_key = String.valueOf(mcl[0].Month__c).subString(0,3);
        if(month_key=='Sep'){
            month_key = month_key+'t';
        }
        if(!mcl.isEmpty()){
            if(String.valueOf(System.today().month())==lit.monthIntMap.get(month_key)){    
                if(System.today().day()>=mcl[0].Edit_Start_Day__c && System.today().day()<=mcl[0].Edit_End_Day__c){
                    isOpeningInventory = true;
                }else{
                    isOpeningInventory = false;
                }  
            }else{
                isOpeningInventory = false;
            }
        }
        
        return isOpeningInventory;
    }
    
    // Checking Liquidation data submission Status
    @AuraEnabled
    public static Boolean checkIsSubmitTrueLiquidation(String year,String quarter){
        
        system.debug('year : '+year);
        system.debug('quarter : '+quarter);
        Boolean isSubmit = false;
        Date start_date = Date.newInstance(Integer.valueOf(year), 4, 1); 
        system.debug('start_date : '+start_date);
        String salesOrgCode=System.Label.Grz_PolandSalesOrgCode;
        Id rec_type = Schema.SObjectType.Liquidation2__c.getRecordTypeInfosByName().get('Multi Country').getRecordTypeId();
        List<Liquidation2__c> liqList = new List<Liquidation2__c>();
        liqList = [Select submitted__c,Quarter__c from Liquidation2__c where submitted__c = true and SKU__r.Active_for_Liquidation__c = true and Quarter__c =:quarter and Liquidation_Annual_Plan__r.Fiscal_Start_Date__c=:start_date and Liquidation_Annual_Plan__r.Sales_Org__r.Sales_Org_Code__c =: salesOrgCode  and RecordTypeId=:rec_type limit 1];        
        if(liqList.size()>0){
            isSubmit = true;
        }
        System.debug('isSubmit : '+isSubmit);
        return isSubmit;
    }
    
    // getting Liquidation Data for presewnting on POG and POG Report Screen
    @AuraEnabled
    public static List<Liquidation2__c> getLiquidationData(String distributor,String distributorName,String year,String quarter ){
        Id rec_type = Schema.SObjectType.Liquidation2__c.getRecordTypeInfosByName().get('Multi Country').getRecordTypeId();
        System.debug('rec type '+rec_type);
        // System.debug('distributor '+distributor);
        System.debug('distributorName'+distributorName);
        Date start_date = Date.newInstance(Integer.valueOf(year), 4, 1); 
        System.debug('distributor'+distributor+'quarter'+quarter+'start_date'+start_date);
        List<Liquidation2__c> lst_liquidation = new List<Liquidation2__c>();
        String salesOrgCode=System.Label.Grz_PolandSalesOrgCode;
        String allLabel=System.Label.All;
        
        if(distributorName==allLabel){
            lst_liquidation = [Select Id, submitted__c,Quarter__c,Opening_Inventory2__c,Opening_Inventory2__r.Opening_Inventory__c,SKU__r.Brand_Name__c,SKU__r.SKU_Code__c,SKU__r.SKU_Description__c,YTD_Sales__c,Liquidation_YTD__c,Total_Available_Stock__c,Distributor__c,Distributors_Inventory__c,Plan_for_the_quarter__c,Liquidation_Percent_YTD__c,Plan_for_the_next_quarter__c,Brand_Name__c,SKU_Code__c,SKU_Description__c,YTD_Sales_formula__c,YTD_Sales_Poland__c from Liquidation2__c where SKU__r.Active_for_Liquidation__c = true and Quarter__c =:quarter and Liquidation_Annual_Plan__r.Fiscal_Start_Date__c=:start_date and Liquidation_Annual_Plan__r.Sales_Org__r.Sales_Org_Code__c=:salesOrgCode  and RecordTypeId=:rec_type order by Total_Available_Stock__c DESC, Brand_Name__c ASC ];
        }
        else{
            lst_liquidation = [Select Id, submitted__c,Quarter__c,Opening_Inventory2__c,Opening_Inventory2__r.Opening_Inventory__c,SKU__r.Brand_Name__c,SKU__r.SKU_Code__c,SKU__r.SKU_Description__c,YTD_Sales__c,Liquidation_YTD__c,Total_Available_Stock__c,Distributor__c,Distributors_Inventory__c,Plan_for_the_quarter__c,Liquidation_Percent_YTD__c,Plan_for_the_next_quarter__c,Brand_Name__c,SKU_Code__c,SKU_Description__c,YTD_Sales_formula__c,YTD_Sales_Poland__c from Liquidation2__c where SKU__r.Active_for_Liquidation__c = true and Quarter__c =:quarter  and Distributor__c=:distributor and Liquidation_Annual_Plan__r.Fiscal_Start_Date__c=:start_date and Liquidation_Annual_Plan__r.Sales_Org__r.Sales_Org_Code__c=:salesOrgCode  and RecordTypeId=:rec_type order by  Total_Available_Stock__c DESC, Brand_Name__c ASC ];
        }
        
        
        if(lst_liquidation.size()>0){
            System.debug('Existing liquidation '+lst_liquidation.size());
            return lst_liquidation;
        }else{
            return new List<Liquidation2__c>();
        }

       
        

        
    }

    /* ------------Start GRZ(Dheeraj Sharma) : APPS-1395 PO And Delivery Date :06-07-2022 */ 
    @AuraEnabled
    public static list<POGDataWrapperData> getLiquidationPolandDataPDF(String distributor,String distributorName,String year , String quarter , String inputValue){
        Id rec_type = Schema.SObjectType.Liquidation2__c.getRecordTypeInfosByName().get('Multi Country').getRecordTypeId();
        System.debug('rec type '+rec_type);
        Date start_date = Date.newInstance(Integer.valueOf(year), 4, 1); 

        System.debug('distributor'+distributor+'quarter'+quarter+'distributorName'+distributorName + 'inputValue' +inputValue);
        List<Liquidation2__c> lst_liquidation = new List<Liquidation2__c>();
        String salesOrgCode=System.Label.Grz_PolandSalesOrgCode;
        String allLabel=System.Label.All;
       
        string searchValues = '%' + inputValue + '%';        
     if(distributorName==allLabel){
      
        lst_liquidation = [Select  submitted__c,Quarter__c,Opening_Inventory2__c,Opening_Inventory2__r.Opening_Inventory__c,SKU__r.Brand_Name__c,SKU__r.SKU_Code__c,SKU__r.SKU_Description__c,YTD_Sales__c,Liquidation_YTD__c,Total_Available_Stock__c,Distributor__c,Distributors_Inventory__c,Plan_for_the_quarter__c,Liquidation_Percent_YTD__c,Plan_for_the_next_quarter__c,Brand_Name__c,SKU_Code__c,SKU_Description__c,YTD_Sales_formula__c,YTD_Sales_Poland__c from Liquidation2__c where SKU__r.Active_for_Liquidation__c = true and  Quarter__c =:quarter and Liquidation_Annual_Plan__r.Fiscal_Start_Date__c=:start_date and Liquidation_Annual_Plan__r.Sales_Org__r.Sales_Org_Code__c=:salesOrgCode  and RecordTypeId=:rec_type And (SKU__r.Brand_Name__c Like: searchValues Or SKU__r.SKU_Code__c Like: searchValues Or SKU__r.SKU_Description__c Like :searchValues)   order by  Total_Available_Stock__c DESC, Brand_Name__c ASC];
  
    } 
    else if(distributorName=='' && distributor==''){
        lst_liquidation=new List<Liquidation2__c>();
        System.debug('else');
    }
    else {
        lst_liquidation = [Select submitted__c,Quarter__c,Opening_Inventory2__c,Opening_Inventory2__r.Opening_Inventory__c,SKU__r.Brand_Name__c,SKU__r.SKU_Code__c,SKU__r.SKU_Description__c,YTD_Sales__c,Liquidation_YTD__c,Total_Available_Stock__c,Distributor__c,Distributors_Inventory__c,Plan_for_the_quarter__c,Liquidation_Percent_YTD__c,Plan_for_the_next_quarter__c,Brand_Name__c,SKU_Code__c,SKU_Description__c,YTD_Sales_formula__c,YTD_Sales_Poland__c from Liquidation2__c where SKU__r.Active_for_Liquidation__c = true and Quarter__c =:quarter  and Distributor__c=:distributor and Liquidation_Annual_Plan__r.Fiscal_Start_Date__c=:start_date and Liquidation_Annual_Plan__r.Sales_Org__r.Sales_Org_Code__c=:salesOrgCode  and RecordTypeId=:rec_type and (SKU__r.Brand_Name__c Like: searchValues Or SKU__r.SKU_Code__c Like: searchValues Or SKU__r.SKU_Description__c Like :searchValues)  order by  Total_Available_Stock__c DESC, Brand_Name__c ASC];
 System.debug('lst_liquidation'+lst_liquidation);   
    }
    POGDataWrapperData data = new POGDataWrapperData();
    list<POGDataWrapperData> dataList = new list<POGDataWrapperData>();
    
    
    for(Liquidation2__c liq :lst_liquidation){
        data = new POGDataWrapperData();
       // liq.SKU__r.SKU_Code__c = liq.SKU__r.SKU_Code__c.replaceFirst('^0+', '');
       // liq.Opening_Inventory2__r.Opening_Inventory__c =  string.valueOf(liq.Opening_Inventory2__r.Opening_Inventory__c).setScale(1).format();
       data.Brand = liq.SKU__r.Brand_Name__c;
       data.SKU_Code = liq.SKU__r.SKU_Code__c.replaceFirst('^0+', '');
       data.SKU_Description = liq.SKU__r.SKU_Description__c;
       data.Opening_inventory = liq.Opening_Inventory2__r.Opening_Inventory__c.setScale(1).format();
       data.YTD_sales = liq.YTD_Sales_Poland__c.setScale(1).format();
       data.Total_Available_Stock = liq.Total_Available_Stock__c.setScale(1).format();
       data.Distributor_Inventory = liq.Distributors_Inventory__c.setScale(1).format();
       data.Plan_for_the_Quarter = liq.Plan_for_the_Quarter__c.setScale(1).format();
       data.Liquidation_YTD = liq.Liquidation_YTD__c.setScale(1).format();
        if(liq.Liquidation_Percent_YTD__c != null){
            data.Liquidation_Percent_YTD = String.valueof(liq.Liquidation_Percent_YTD__c) + ' %';
        }else{
             data.Liquidation_Percent_YTD = '0 %';
        }
        
        data.Plan_for_the_Next_Quarter = liq.Plan_for_the_Next_Quarter__c.setScale(1).format();
       datalist.add(data);
       
     }
        
    System.debug('Opening_Inventory2__r.Opening_Inventory__c '+Opening_Inventory2__c.Opening_Inventory__c);
    //if(datalist.size()>0){
        System.debug('Existing liquidation '+datalist.size());
        return datalist;
    //}else{
    //    return new List<Liquidation2__c>();
   // }

        
    }
	/* -- */
    
    // updating Openning Inventory
    @AuraEnabled
    public static String updateOpeningInventory(String oi_id,string value){
        Opening_Inventory2__c op = [Select id,Opening_Inventory__c from Opening_Inventory2__c where Id=:oi_id limit 1];
        op.Opening_Inventory__c = Double.valueOf(value);
        update op;
        return value;
    }
	
    // updating Distributor Inventory
    @AuraEnabled
    public static Liquidation2__c saveLiquidation(Liquidation2__c liq){
       System.debug('Liquidation '+liq);
       update liq;
       return liq;
    }
    
    // updating plan for next quarter
    @AuraEnabled
    public static Liquidation2__c updatePlanForQuarter(Liquidation2__c liq){
        update liq;
        Grz_PolandLiquidation obj = new Grz_PolandLiquidation();
        Liquidation2__c liq1 = [Select quarter__c,Opening_Inventory2__c,Opening_Inventory2__r.Opening_Inventory__c,Liquidation_Annual_Plan__r.Fiscal_Start_Date__c,submitted__c,SKU__c,SKU__r.Brand_Name__c,SKU__r.SKU_Code__c,SKU__r.SKU_Description__c,YTD_Sales__c,Liquidation_YTD__c,Total_Available_Stock__c,Distributor__c,Distributors_Inventory__c,Retailers_Inventory__c,Total_Market_Inventory__c,Plan_for_the_quarter__c,Liquidation_Percent_YTD__c,Plan_for_the_Next_Quarter__c,Brand_Name__c,SKU_Code__c,SKU_Description__c,YTD_Sales_formula__c,Sales_District__c,Liquidation_Annual_Plan__r.Sales_Org__r.Sales_Org_Code__c,RecordTypeId from Liquidation2__c where Id=:liq.Id];
        Integer update_qua = obj.QuarterMap.get(liq1.Quarter__c)+1;
        Date start_date = liq1.Liquidation_Annual_Plan__r.Fiscal_Start_Date__c;
        if(update_qua==5){
            update_qua=1;
            start_date=liq1.Liquidation_Annual_Plan__r.Fiscal_Start_Date__c.addYears(1);
        }
        String quarter = 'Quarter '+String.valueOf(update_qua);
        String distributor = liq1.Distributor__c;
        String rec_type = liq1.RecordTypeId;
        String opening_inventory = liq1.Opening_Inventory2__c;
        String sales_org_code = liq1.Liquidation_Annual_Plan__r.Sales_Org__r.Sales_Org_Code__c;
        String sku = liq1.SKU__c;
        List<Liquidation2__c> new_liq = [Select Quarter__c,Opening_Inventory2__c,Opening_Inventory2__r.Opening_Inventory__c,submitted__c,SKU__r.Brand_Name__c,SKU__r.SKU_Code__c,SKU__r.SKU_Description__c,YTD_Sales__c,Liquidation_YTD__c,Total_Available_Stock__c,Distributor__c,Distributors_Inventory__c,Retailers_Inventory__c,Total_Market_Inventory__c,Plan_for_the_quarter__c,Liquidation_Percent_YTD__c,Plan_for_the_Next_Quarter__c,Brand_Name__c,SKU_Code__c,SKU_Description__c,YTD_Sales_formula__c from Liquidation2__c where SKU__r.Active_for_Liquidation__c = true and quarter__c =:quarter and Distributor__c=:distributor and Liquidation_Annual_Plan__r.Fiscal_Start_Date__c=:start_date and Liquidation_Annual_Plan__r.Sales_Org__r.Sales_Org_Code__c=:sales_org_code  and RecordTypeId=:rec_type and SKU__c=:sku limit 1];
        if(new_liq.size()!=0){
            new_liq[0].Plan_for_the_quarter__c = liq1.Plan_for_the_next_quarter__c;
            System.debug('Plan for next quarter update new liq-->'+new_liq[0].Plan_for_the_quarter__c);
            update new_liq;
        }
        return liq;
    }
    
    // Submit all Liquidation data present on POG Screen
    @AuraEnabled
    public static Boolean submitLiquidation(String lst_liq){
        System.debug('lst liquidation '+lst_liq);
        List<Id> lst_id = (List<Id>)JSON.deserialize(lst_liq,List<Id>.class);
       /* List<Liquidation2__c> lst_liqui = [select id,submitted__c from Liquidation2__c where Id IN:lst_id];
        List<Liquidation2__c> lst_submit = new List<Liquidation2__c>();
        for(Liquidation2__c liq:lst_liqui){
            liq.submitted__c = true;
            lst_submit.add(liq);
        }
        if(lst_submit.size()!=0){
            update lst_submit;
        }        
        return true;*/
        Grz_SubmitLiquidation shn = new Grz_SubmitLiquidation(lst_id); 
        database.executeBatch(shn,200 ); 
        return true;
    }
    
    // getting Current login user's Role
    @AuraEnabled(cacheable=true)
    public static string getUserRole(){
        User u=[Select id,name,userrole.name from user where id=:UserInfo.getUserId()];
        return u.UserRole.Name;
    }
    
    /* ------------Start GRZ(Dheeraj Sharma) : APPS-1395 PO And Delivery Date :06-07-2022 */ 
      public class POGDataWrapperData {
       // @AuraEnabled
       // public String Id { get; set; }
        @AuraEnabled
        public String Brand { get; set; }
        @AuraEnabled
        public String SKU_Code { get; set; }
        @AuraEnabled
        public String SKU_Description { get; set; }
        @AuraEnabled
        public String Opening_inventory { get; set; }
       // @AuraEnabled
        //public String Opening_inventory_PLN { get; set; }
        @AuraEnabled
        public String YTD_sales { get; set; }
        //@AuraEnabled
        //public String YTD_sales_PLN { get; set; }
        @AuraEnabled
        public String Total_Available_Stock { get; set; }
       // @AuraEnabled
        //public String Total_Available_Stock_PLN { get; set; }
        @AuraEnabled
        public String Distributor_Inventory { get; set; }
        @AuraEnabled
        public String Plan_for_the_Quarter { get; set; }
        @AuraEnabled
        public String Liquidation_YTD { get; set; }
        @AuraEnabled
        public String Liquidation_Percent_YTD { get; set; }
        @AuraEnabled
        public String Plan_for_the_Next_Quarter { get; set; }
    }
	/* -- */
   
}