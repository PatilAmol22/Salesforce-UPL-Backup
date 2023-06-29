public without sharing class LiquidationMexico {
    public map<String,String> monthIntMap =new map<String,String>();
    public map<String,String> monthStringMap =new map<String,String>();
    public String country_name = ''; 
    public String profile_name = ''; 
    public LiquidationMexico(){
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

        monthStringMap.put('1','Jan');
        monthStringMap.put('2','Feb');
        monthStringMap.put('3','Mar');
        monthStringMap.put('4','Apr');
        monthStringMap.put('5','May');
        monthStringMap.put('6','Jun');
        monthStringMap.put('7','Jul');
        monthStringMap.put('8','Aug');
        monthStringMap.put('9','Sept');
        monthStringMap.put('10','Oct');
        monthStringMap.put('11','Nov');
        monthStringMap.put('12','Dec');

        User u = [Select id,Country from User where Id=:UserInfo.getUserId()];
        profile_name = [Select id,Name from Profile where id=:UserInfo.getProfileId()].Name;
        if(String.isEmpty(u.Country)){
            country_name = '';
        }else{
            country_name = u.Country;
        }
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Shipping_Location__c> getSalesDistrict(){
        // List<DistributorSalesAreaMapping__c> lst_sd = new List<DistributorSalesAreaMapping__c>();
        // List<DistributorSalesAreaMapping__c> lst_sd1 = new List<DistributorSalesAreaMapping__c>();
        // Set<Id> set_sd1 = new Set<Id>();
        // lst_sd = [select id,Name,Distributor__c,Distributor__r.Sales_District__c,Distributor__r.Sales_District__r.Name from DistributorSalesAreaMapping__c where SalesOrg__r.Sales_Org_Code__c='5100' and AccountOwner__c=:UserInfo.getUserId()];
        // for(DistributorSalesAreaMapping__c dsm:lst_sd){
        //     if(set_sd1.add(dsm.Distributor__r.Sales_District__c)==true){
        //         lst_sd1.add(dsm);
        //     }
        // }
        // return lst_sd1;
        LiquidationMexico lm = new LiquidationMexico();
        List<Shipping_Location__c> lst_sd = new List<Shipping_Location__c>();
        if(lm.profile_name.containsIgnoreCase('Territory Manager for Mexico')){
        lst_sd = [select Id,name,Distributor__c,Distributor__r.Sales_District__c from Shipping_Location__c where Distributor__r.Sales_District__c!=null and User__c=:UserInfo.getUserId() and Sales_Org_Code__c='5100'];
        }else if(lm.profile_name.containsIgnoreCase('Regional/Zonal Managers for Mexico')){
            lst_sd = [select Id,name,Distributor__c,Distributor__r.Sales_District__c from Shipping_Location__c where Distributor__r.Sales_District__c!=null and Regional_manager__c=:UserInfo.getUserId() and Sales_Org_Code__c='5100'];
        }else{
            lst_sd = [select Id,name,Distributor__c,Distributor__r.Sales_District__c from Shipping_Location__c where Distributor__r.Sales_District__c!=null and Sales_Org_Code__c='5100'];
        }
        return lst_sd;


    }
    @AuraEnabled(cacheable=true)
    public static List<Shipping_Location__c> getDistributor(){
        // List<DistributorSalesAreaMapping__c> lst_acc = new List<DistributorSalesAreaMapping__c>();
        // lst_acc = [select id,Name,Distributor__c,Distributor__r.Name from DistributorSalesAreaMapping__c where SalesOrg__r.Sales_Org_Code__c='5100' and Distributor__r.RecordType.Name='Distributor' and AccountOwner__c=:UserInfo.getUserId()];
        // return lst_acc;
        LiquidationMexico lm = new LiquidationMexico();
        List<Shipping_Location__c> lst_dis = new List<Shipping_Location__c>();
        if(lm.profile_name.containsIgnoreCase('Territory Manager for Mexico')){
         lst_dis = [select Id,name,Distributor__c from Shipping_Location__c where Distributor__c!=null and User__c=:UserInfo.getUserId() and Sales_Org_Code__c='5100'];
        }else if(lm.profile_name.containsIgnoreCase('Regional/Zonal Managers for Mexico')){
            lst_dis = [select Id,name,Distributor__c from Shipping_Location__c where Distributor__c!=null and Regional_manager__c=:UserInfo.getUserId() and Sales_Org_Code__c='5100'];
        }else{
            lst_dis = [select Id,name,Distributor__c from Shipping_Location__c where Distributor__c!=null and Sales_Org_Code__c='5100'];
        }
        return lst_dis;
    }    
    @AuraEnabled(cacheable=true)
    public static List<Sales_Org__c> getSalesOrg(){
        List<Sales_Org__c> lst_salesorg  = new  List<Sales_Org__c>();
        lst_salesorg = [Select id,Name,Sales_Org_Code__c from Sales_Org__c where Sales_Org_Code__c = '5100'];
        return lst_salesorg;
    }
    @AuraEnabled(cacheable = true)
    public static string getUserCountry(){
        return new LiquidationMexico().country_name;
    }

    @AuraEnabled(cacheable=true)
    public static string getUserProfile(){
        return new LiquidationMexico().profile_name;
    }
    @AuraEnabled(cacheable=true)
    public static string getLogedInUserId(){
        return UserInfo.getUserId();
    }

    @AuraEnabled(cacheable=true)
    public static String getLiquidationEditDates(){
        LiquidationMexico lit = new LiquidationMexico();
        Multi_Country_Liquidation__c mcl = [select id,name,Country__c,Edit_Start_Day__c,Edit_End_Day__c,Type__c from Multi_Country_Liquidation__c where Type__c = 'Liquidation' and Country__c=:lit.country_name limit 1];
        if(System.today().day()>=mcl.Edit_Start_Day__c && System.today().day()<=mcl.Edit_End_Day__c){
            System.debug('start getLiquidationEditDates TRUE');
            return 'true';
        }else{
            System.debug('start getLiquidationEditDates FALSE');
            return 'false';
        }
    }

    @AuraEnabled(cacheable=true)
    public static String getOpeningInventoryEditDates(){
        LiquidationMexico lit = new LiquidationMexico();
        Multi_Country_Liquidation__c mcl = [select id,name,Month__c,Country__c,Edit_Start_Day__c,Edit_End_Day__c,Type__c from Multi_Country_Liquidation__c where Type__c = 'Opening Inventory' and Country__c=: lit.country_name limit 1];// Edit country lit.country_name
        String month_key = String.valueOf(mcl.Month__c).subString(0,3);
        if(month_key=='Sep'){
            month_key = month_key+'t';
        }
        if(String.valueOf(System.today().month())==lit.monthIntMap.get(month_key)){
            if(System.today().day()>=mcl.Edit_Start_Day__c && System.today().day()<=mcl.Edit_End_Day__c){
                System.debug('start getOIEditDates TRUE');
                return 'true';
            }else{
                return 'false';
            }
        }else{
            return 'false';
        }
    }

    @AuraEnabled
    public static List<Liquidation2__c> getAllLiquidation(String sales_org_code,String sales_district,String distributor,String ship_to_party,String year,String month,String searchstr){
        Id rec_type = Schema.SObjectType.Liquidation2__c.getRecordTypeInfosByName().get('Multi Country').getRecordTypeId();
        Date start_date = Date.newInstance(Integer.valueOf(year), 4, 1);
        String userRole = [select Id,Name from UserRole where Id=:UserInfo.getUserRoleId()].Name;
        List<Liquidation2__c> lst_liquidation = new List<Liquidation2__c>();

        if(!userRole.equalsIgnoreCase('New Mexico Region Financial Head')){
            lst_liquidation = [Select Month__c,Opening_Inventory2__c,Opening_Inventory2__r.Opening_Inventory__c,submitted__c,SKU__r.Brand_Name__c,SKU__r.SKU_Code__c,SKU__r.SKU_Description__c,SKU__r.UOM__c,YTD_Sales__c,Liquidation_YTD__c,Total_Available_Stock__c,Distributor__c,Distributors_Inventory__c,Retailers_Inventory__c,Total_Market_Inventory__c,Plan_for_the_month__c,Liquidation_Percent_YTD__c,Plan_for_the_next_month__c,Brand_Name__c,SKU_Code__c,SKU_Description__c,YTD_Sales_formula__c from Liquidation2__c where SKU__r.Active_for_Liquidation__c = true and Month__c =:month and Distributor__c=:distributor and Liquidation_Annual_Plan__r.Fiscal_Start_Date__c=:start_date and Sales_District__c=:sales_district and Ship_To_Party__c=:ship_to_party and Liquidation_Annual_Plan__r.Sales_Org__r.Sales_Org_Code__c=:sales_org_code  and RecordTypeId=:rec_type order by Total_Available_Stock__c DESC];
      System.debug('liquidation'+lst_liquidation);
            return lst_liquidation;
        }else{
        lst_liquidation = [Select Month__c,Opening_Inventory2__c,Opening_Inventory2__r.Opening_Inventory__c,submitted__c,SKU__r.Brand_Name__c,SKU__r.SKU_Code__c,SKU__r.SKU_Description__c,SKU__r.UOM__c,YTD_Sales__c,Liquidation_YTD__c,Total_Available_Stock__c,Distributor__c,Distributors_Inventory__c,Retailers_Inventory__c,Total_Market_Inventory__c,Plan_for_the_month__c,Liquidation_Percent_YTD__c,Plan_for_the_next_month__c,Brand_Name__c,SKU_Code__c,SKU_Description__c,YTD_Sales_formula__c from Liquidation2__c where SKU__r.Active_for_Liquidation__c = true and Mexico_Sub_Region_Head_access__c = false and Month__c =:month and Distributor__c=:distributor and Liquidation_Annual_Plan__r.Fiscal_Start_Date__c=:start_date and Sales_District__c=:sales_district and Ship_To_Party__c=:ship_to_party and Liquidation_Annual_Plan__r.Sales_Org__r.Sales_Org_Code__c=:sales_org_code  and RecordTypeId=:rec_type order by Total_Available_Stock__c DESC];
        System.debug('liquidation'+lst_liquidation);
        return lst_liquidation;
        }

    }
/* ------------Start GRZ(Dheeraj Sharma) : APPS-1395 PO And Delivery Date :19-07-2022 */ 
    @AuraEnabled
    public static List<Liquidation2__c> getAllLiquidationPDF(String sales_org_code,String sales_district,String distributor,String ship_to_party,String year,String month,String searchstr){
        Id rec_type = Schema.SObjectType.Liquidation2__c.getRecordTypeInfosByName().get('Multi Country').getRecordTypeId();
        Date start_date = Date.newInstance(Integer.valueOf(year), 4, 1);
        String userRole = [select Id,Name from UserRole where Id=:UserInfo.getUserRoleId()].Name;
        List<Liquidation2__c> lst_liquidation = new List<Liquidation2__c>();
        system.debug('searchstr'+searchstr);
        String searchValues='%' + searchstr + '%';
        if(!userRole.equalsIgnoreCase('New Mexico Region Financial Head')){
            lst_liquidation = [Select Month__c,Opening_Inventory2__c,Opening_Inventory2__r.Opening_Inventory__c,submitted__c,SKU__r.Brand_Name__c,SKU__r.SKU_Code__c,SKU__r.SKU_Description__c,SKU__r.UOM__c,YTD_Sales__c,Liquidation_YTD__c,Total_Available_Stock__c,Distributor__c,Distributors_Inventory__c,Retailers_Inventory__c,Total_Market_Inventory__c,Plan_for_the_month__c,Liquidation_Percent_YTD__c,Plan_for_the_next_month__c,Brand_Name__c,SKU_Code__c,SKU_Description__c,YTD_Sales_formula__c from Liquidation2__c where SKU__r.Active_for_Liquidation__c = true and Month__c =:month and Distributor__c=:distributor and Liquidation_Annual_Plan__r.Fiscal_Start_Date__c=:start_date and Sales_District__c=:sales_district and Ship_To_Party__c=:ship_to_party and Liquidation_Annual_Plan__r.Sales_Org__r.Sales_Org_Code__c=:sales_org_code  and RecordTypeId=:rec_type   And (SKU__r.Brand_Name__c Like: searchValues Or SKU__r.SKU_Code__c Like: searchValues Or SKU__r.SKU_Description__c Like :searchValues) order by Total_Available_Stock__c DESC];
      System.debug('liquidation'+lst_liquidation);
            // return lst_liquidation;
        }else if(ship_to_party=='' && sales_district=='' &&distributor==''){
            lst_liquidation=new List<Liquidation2__c>();
            System.debug('else');
            // return lst_liquidation;
        }
        else{
        lst_liquidation = [Select Month__c,Opening_Inventory2__c,Opening_Inventory2__r.Opening_Inventory__c,submitted__c,SKU__r.Brand_Name__c,SKU__r.SKU_Code__c,SKU__r.SKU_Description__c,SKU__r.UOM__c,YTD_Sales__c,Liquidation_YTD__c,Total_Available_Stock__c,Distributor__c,Distributors_Inventory__c,Retailers_Inventory__c,Total_Market_Inventory__c,Plan_for_the_month__c,Liquidation_Percent_YTD__c,Plan_for_the_next_month__c,Brand_Name__c,SKU_Code__c,SKU_Description__c,YTD_Sales_formula__c from Liquidation2__c where SKU__r.Active_for_Liquidation__c = true and Mexico_Sub_Region_Head_access__c = false and Month__c =:month and Distributor__c=:distributor and Liquidation_Annual_Plan__r.Fiscal_Start_Date__c=:start_date and Sales_District__c=:sales_district and Ship_To_Party__c=:ship_to_party and Liquidation_Annual_Plan__r.Sales_Org__r.Sales_Org_Code__c=:sales_org_code  and RecordTypeId=:rec_type  And (SKU__r.Brand_Name__c Like: searchValues Or SKU__r.SKU_Code__c Like: searchValues Or SKU__r.SKU_Description__c Like :searchValues) order by Total_Available_Stock__c DESC];
        System.debug('liquidation'+lst_liquidation);
        // return lst_liquidation;
        }

        for(Liquidation2__c liq :lst_liquidation){
            liq.SKU__r.SKU_Code__c = liq.SKU__r.SKU_Code__c.replaceFirst('^0+', '');
        
         }
         if(lst_liquidation.size()>0){
            System.debug('Existing liquidation '+lst_liquidation.size());
            return lst_liquidation;
        }else{
            return new List<Liquidation2__c>();
        }


    }
    
    /* -- */

    @AuraEnabled
    public static Liquidation2__c updatePlanForMonth(Liquidation2__c liq){
        update liq;
        LiquidationMexico obj = new LiquidationMexico();
        Liquidation2__c liq1 = [Select Month__c,Opening_Inventory2__c,Opening_Inventory2__r.Opening_Inventory__c,Liquidation_Annual_Plan__r.Fiscal_Start_Date__c,submitted__c,SKU__c,SKU__r.Brand_Name__c,SKU__r.SKU_Code__c,SKU__r.SKU_Description__c,YTD_Sales__c,Liquidation_YTD__c,Total_Available_Stock__c,Distributor__c,Distributors_Inventory__c,Retailers_Inventory__c,Total_Market_Inventory__c,Plan_for_the_month__c,Liquidation_Percent_YTD__c,Plan_for_the_next_month__c,Brand_Name__c,Ship_To_Party__c,SKU_Code__c,SKU_Description__c,YTD_Sales_formula__c,Sales_District__c,Liquidation_Annual_Plan__r.Sales_Org__r.Sales_Org_Code__c,RecordTypeId from Liquidation2__c where Id=:liq.Id];
        Integer update_mon = Date.today().month()-2;
        if(update_mon==-1){
            update_mon = 11;
        }
        if(update_mon==0){
            update_mon = 12;
        }
        if(update_mon==Integer.valueOf(obj.monthIntMap.get(liq1.Month__c))){
        Integer int_mon =  Integer.valueOf(obj.monthIntMap.get(liq1.Month__c)) + 1;
        if(int_mon==13){
            int_mon = 1;
        }
        String month = obj.monthStringMap.get(String.valueOf(int_mon));
        String distributor = liq1.Distributor__c;
        Date start_date = liq1.Liquidation_Annual_Plan__r.Fiscal_Start_Date__c;
        String sales_district = liq1.Sales_District__c;
        String rec_type = liq1.RecordTypeId;
        String opening_inventory = liq1.Opening_Inventory2__c;
        String sales_org_code = liq1.Liquidation_Annual_Plan__r.Sales_Org__r.Sales_Org_Code__c;
        String sku = liq1.SKU__c;
        String shiptoparty = liq1.Ship_To_Party__c;
        System.debug('month '+month+' distributor '+distributor+' start_date '+start_date+' sales_dist '+sales_district+' rec_type '+rec_type+' opening_inventory '+opening_inventory+' sales_org_code '+sales_org_code+' sku '+sku);
        Liquidation2__c new_liq = [Select Month__c,Opening_Inventory2__c,Opening_Inventory2__r.Opening_Inventory__c,submitted__c,SKU__r.Brand_Name__c,SKU__r.SKU_Code__c,SKU__r.SKU_Description__c,YTD_Sales__c,Liquidation_YTD__c,Total_Available_Stock__c,Distributor__c,Distributors_Inventory__c,Retailers_Inventory__c,Total_Market_Inventory__c,Plan_for_the_month__c,Liquidation_Percent_YTD__c,Plan_for_the_next_month__c,Brand_Name__c,SKU_Code__c,SKU_Description__c,YTD_Sales_formula__c from Liquidation2__c where SKU__r.Active_for_Liquidation__c = true and Month__c =:month and Distributor__c=:distributor and Liquidation_Annual_Plan__r.Fiscal_Start_Date__c=:start_date and Sales_District__c=:sales_district and Ship_To_Party__c=:shiptoparty and Liquidation_Annual_Plan__r.Sales_Org__r.Sales_Org_Code__c=:sales_org_code  and RecordTypeId=:rec_type and SKU__c=:sku limit 1];

        new_liq.Plan_for_the_month__c = liq1.Plan_for_the_next_month__c;
        System.debug('Plan for next month update new liq-->'+new_liq.Plan_for_the_month__c);
        update new_liq;
    }
        return liq;
    }

    @AuraEnabled
    public static String updateOpeningInventory(String oi_id,string value){
        Opening_Inventory2__c op = [Select id,Opening_Inventory__c from Opening_Inventory2__c where Id=:oi_id limit 1];
        op.Opening_Inventory__c = Double.valueOf(value);
        update op;
        return value;
    }
    @AuraEnabled
    public static Liquidation2__c saveLiquidation(Liquidation2__c liq){
       System.debug('Liquidation '+liq);
       update liq;
       return liq;
    }

    @AuraEnabled
    public static Boolean submitLiquidation(String lst_liq){
        System.debug('lst liquidation '+lst_liq);
        List<Id> lst_id = (List<Id>)JSON.deserialize(lst_liq,List<Id>.class);
        List<Liquidation2__c> lst_liqui = [select id,submitted__c from Liquidation2__c where Id IN:lst_id];
        List<Liquidation2__c> lst_submit = new List<Liquidation2__c>();
        for(Liquidation2__c liq:lst_liqui){
            liq.submitted__c = true;
            lst_submit.add(liq);
        }
        update lst_submit;
        return true;
    }

    @AuraEnabled(cacheable=true)
    public static  Shipping_Location__c getSalesDisctrictForShipToParty(String shipt_to_party){
        Shipping_Location__c ship_to_party = new Shipping_Location__c();
        ship_to_party = [select Id,Distributor__c,Distributor__r.Sales_District__c,Distributor__r.Sales_District__r.Name from Shipping_Location__c where Id=:shipt_to_party];
        return ship_to_party;
    }
    @AuraEnabled(cacheable=true)
    public static Shipping_Location__c getDistributorForShipToParty(String shipt_to_party){
        Shipping_Location__c ship_to_party = new Shipping_Location__c();
        ship_to_party = [select Id,Distributor__c,Distributor__r.Name from Shipping_Location__c where Id=:shipt_to_party];
        return ship_to_party;
    }

    @AuraEnabled
    public static Map<String,Liquidation2__c> rollUpLiquidation(String lst_salesDistricts,String lst_distributor,String sales_districts,String start_year,String month,String distributor,String ship_to_party,String sales_org){
        Date start_date;
        string tem_date = '';
        if(!String.isEmpty(start_year)){
            start_date = Date.newInstance(Integer.valueOf(start_year), 4, 1);
            tem_date = String.valueOf(start_date).split(' ')[0]; 
        }
        Id rec_type = Schema.SObjectType.Liquidation2__c.getRecordTypeInfosByName().get('Multi Country').getRecordTypeId();
        System.debug('lst_salesDistricts '+lst_salesDistricts);
       // System.debug('lst_distributor '+lst_distributor);
       // System.debug('sales_districts '+sales_districts+' start_year '+start_year +' month '+month+' Distributor '+distributor+' ship to party '+ship_to_party+' sales_org '+sales_org);
        String query = 'SELECT+SKU__r.SKU_Code__c,SKU__r.Brand_Name__c,SKU__r.SKU_Description__c,SKU__r.UOM__c,+SUM(YTD_Sales_formula__c),+SUM(Liquidation_YTD__c),+SUM(Total_Available_Stock__c),+SUM(Distributors_Inventory__c),+SUM(Retailers_Inventory__c),+SUM(Total_Market_Inventory__c),+SUM(Plan_for_the_month__c),+SUM(Plan_for_the_next_month__c),+SUM(Opening_Inventory2__r.Opening_Inventory__c),+AVG(Liquidation_Percent_YTD__c)+FROM+Liquidation2__c';
        String filter = '';
        LiquidationMexico lm = new LiquidationMexico();
        String str = '';
        if(lm.profile_name.containsIgnoreCase('Territory Manager for Mexico')){
            str = '++AND+Ship_To_Party__r.User__c+=+\''+UserInfo.getUserId()+'\'';
        }
        if(lm.profile_name.containsIgnoreCase('Regional/Zonal Managers for Mexico')){
            str = '++AND+Ship_To_Party__r.Regional_manager__c+=+\''+UserInfo.getUserId()+'\'';
        }
        if(!String.isEmpty(tem_date)&&!String.isEmpty(month)&&!String.isEmpty(rec_type)&&!String.isEmpty(sales_org)){
            if(String.isEmpty(sales_districts)&&String.isEmpty(distributor)&&String.isEmpty(ship_to_party)){
                filter = '++WHERE+SKU__r.Active_for_Liquidation__c+=+true++AND+RecordTypeId+=+\''+rec_type+'\'++AND+Month__c+=+\''+month+'\'++AND+Liquidation_Annual_Plan__r.Fiscal_Start_Date__c+=+'+tem_date+'+AND+Liquidation_Annual_Plan__r.Sales_Org__r.Sales_Org_Code__c+=+\''+sales_org+'\'';
            }
            if(String.isEmpty(sales_districts)&&String.isEmpty(distributor)&&!String.isEmpty(ship_to_party)){
                filter = '++WHERE+SKU__r.Active_for_Liquidation__c+=+true++AND+RecordTypeId+=+\''+rec_type+'\'++AND+Month__c+=+\''+month+'\'++AND+Liquidation_Annual_Plan__r.Fiscal_Start_Date__c+=+'+tem_date+'+AND+Liquidation_Annual_Plan__r.Sales_Org__r.Sales_Org_Code__c+=+\''+sales_org+'\'+AND+Ship_To_Party__c+=+\''+ship_to_party+'\'';
            }            
            if(String.isEmpty(sales_districts)&&!String.isEmpty(distributor)&&String.isEmpty(ship_to_party)){
                filter = '++WHERE+SKU__r.Active_for_Liquidation__c+=+true++AND+RecordTypeId+=+\''+rec_type+'\'++AND+Month__c+=+\''+month+'\'++AND+Liquidation_Annual_Plan__r.Fiscal_Start_Date__c+=+'+tem_date+'+AND+Liquidation_Annual_Plan__r.Sales_Org__r.Sales_Org_Code__c+=+\''+sales_org+'\'+AND+Distributor__c+=+\''+distributor+'\'';
            }
            if(String.isEmpty(sales_districts)&&!String.isEmpty(distributor)&&!String.isEmpty(ship_to_party)){
                filter = '++WHERE+SKU__r.Active_for_Liquidation__c+=+true++AND+RecordTypeId+=+\''+rec_type+'\'++AND+Month__c+=+\''+month+'\'++AND+Liquidation_Annual_Plan__r.Fiscal_Start_Date__c+=+'+tem_date+'+AND+Liquidation_Annual_Plan__r.Sales_Org__r.Sales_Org_Code__c+=+\''+sales_org+'\'+AND+Distributor__c+=+\''+distributor+'\'+AND+Ship_To_Party__c+=+\''+ship_to_party+'\'';
            }
            if(!String.isEmpty(sales_districts)&&String.isEmpty(distributor)&&String.isEmpty(ship_to_party)){
                filter = '++WHERE+SKU__r.Active_for_Liquidation__c+=+true++AND+RecordTypeId+=+\''+rec_type+'\'++AND+Month__c+=+\''+month+'\'++AND+Liquidation_Annual_Plan__r.Fiscal_Start_Date__c+=+'+tem_date+'+AND+Liquidation_Annual_Plan__r.Sales_Org__r.Sales_Org_Code__c+=+\''+sales_org+'\'++AND+Sales_District__c+=+\''+sales_districts+'\'';
            }
            if(!String.isEmpty(sales_districts)&&String.isEmpty(distributor)&&!String.isEmpty(ship_to_party)){
                filter = '++WHERE+SKU__r.Active_for_Liquidation__c+=+true++AND+RecordTypeId+=+\''+rec_type+'\'++AND+Month__c+=+\''+month+'\'++AND+Liquidation_Annual_Plan__r.Fiscal_Start_Date__c+=+'+tem_date+'+AND+Liquidation_Annual_Plan__r.Sales_Org__r.Sales_Org_Code__c+=+\''+sales_org+'\'++AND+Sales_District__c+=+\''+sales_districts+'\'++AND+Ship_To_Party__c+=+\''+ship_to_party+'\'';
            }
            if(!String.isEmpty(sales_districts)&&!String.isEmpty(distributor)&&String.isEmpty(ship_to_party)){
                filter = '++WHERE+SKU__r.Active_for_Liquidation__c+=+true++AND+RecordTypeId+=+\''+rec_type+'\'++AND+Month__c+=+\''+month+'\'++AND+Liquidation_Annual_Plan__r.Fiscal_Start_Date__c+=+'+tem_date+'+AND+Liquidation_Annual_Plan__r.Sales_Org__r.Sales_Org_Code__c+=+\''+sales_org+'\'++AND+Sales_District__c+=+\''+sales_districts+'\'+AND+Distributor__c+=+\''+distributor+'\'';
            }
            if(!String.isBlank(str)){
                filter = filter+str;
            }
            filter = filter+'++Group+By+SKU__r.SKU_Code__c,SKU__r.SKU_Description__c,SKU__r.Brand_Name__c,SKU__r.UOM__c';
            try{
                return RollUpLiquidationDetails.rollUpLiquidation(query+filter);
            }catch(Exception e){
              //  System.debug('Ex -->'+e);
                return new Map<String,Liquidation2__c>();
            }
        }else{
            return new Map<String,Liquidation2__c>();
        }
    }
}