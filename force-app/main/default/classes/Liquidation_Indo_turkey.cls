public without sharing class Liquidation_Indo_turkey {
    
    public map<String,String> monthIntMap =new map<String,String>();
    public map<String,String> monthStringMap =new map<String,String>();
    public String country_name = ''; 
    public String profile_name = ''; 
    public Liquidation_Indo_turkey(){
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

    @AuraEnabled(cacheable = true)
    public static string getUserCountry(){
        Liquidation_Indo_turkey obj = new Liquidation_Indo_turkey();
        return obj.country_name;
    }

    @AuraEnabled(cacheable=true)
    public static string getUserProfile(){
        return [Select id,Name from Profile where id=:UserInfo.getProfileId()].Name;
    }

    @AuraEnabled(cacheable=true)
    public static string getLogedInUserId(){
        return UserInfo.getUserId();
    }

    @AuraEnabled(cacheable=true)
    public static String getLiquidationEditDates(){
        Liquidation_Indo_turkey lit = new Liquidation_Indo_turkey();
        Multi_Country_Liquidation__c mcl = [select id,name,Country__c,Edit_Start_Day__c,Edit_End_Day__c,Type__c from Multi_Country_Liquidation__c where Type__c = 'Liquidation' and Country__c=:lit.country_name limit 1];// Edit country lit.country_name
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
        Liquidation_Indo_turkey lit = new Liquidation_Indo_turkey();
        Multi_Country_Liquidation__c mcl = [select id,name,Month__c,Country__c,Edit_Start_Day__c,Edit_End_Day__c,Type__c from Multi_Country_Liquidation__c where Type__c = 'Opening Inventory' and Country__c=: lit.country_name limit 1];// Edit country lit.country_name
        String month_key = String.valueOf(mcl.Month__c).subString(0,3);
        if(month_key=='Sep'){
            month_key = month_key+'t';
        }
        if(String.valueOf(System.today().month())==lit.monthIntMap.get(month_key)){
            if(System.today().day()>=mcl.Edit_Start_Day__c && System.today().day()<=mcl.Edit_End_Day__c){
                return 'true';
            }else{
                return 'false';
            }
        }else{
            return 'false';
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<Sales_District__c> getSalesDistrict(){
        Liquidation_Indo_turkey lit = new Liquidation_Indo_turkey();
        List<Sales_District__c> lst_sd = new List<Sales_District__c>();
        if(lit.country_name.containsIgnoreCase('indonesia') || lit.country_name.containsIgnoreCase('turkey')|| lit.country_name.containsIgnoreCase('Vietnam')){
        if(lit.profile_name.containsIgnoreCase('National sales Manager indonesia') || lit.profile_name.containsIgnoreCase('Sales Head Indonesia') || lit.profile_name.containsIgnoreCase('Country Head For Turkey') || lit.profile_name.containsIgnoreCase('Marketing Manager') || lit.profile_name.containsIgnoreCase('Regional tech & technical sales Turkey') || lit.profile_name.containsIgnoreCase('Supply Chain & QM Turkey') || lit.profile_name.containsIgnoreCase('Vietnam Regional Sales Manager(RSM)') || lit.profile_name.containsIgnoreCase('Vietnam Country Head') || lit.profile_name.containsIgnoreCase('Customer Community Plus User - Turkey')){
           lst_sd = [Select id,Name,User__c from Sales_District__c where User__r.Country=:lit.country_name];
        }else{
            lst_sd = [Select id,Name,User__c from Sales_District__c where User__r.Country=:lit.country_name and User__c=:UserInfo.getUserId()];
        }
        }
        return lst_sd;
    }

    @AuraEnabled(cacheable=true)
    public static List<Account> getDistributor(String sales_distric_id){
        List<Account> lst_acc = [Select id,Name,Sales_District__c from Account where Sales_District__c =:sales_distric_id and Account_Type__c='Sold To Party' and RecordType.Name='Distributor'];
        return lst_acc;
    }

    @AuraEnabled
    public static Account getSalesDistrictOnAccount(String acc_id){
        List<Account> lst_acc = new List<Account>();
        lst_acc = [Select id,Name,Sales_District__c,Sales_District__r.Name from Account where id=:acc_id];
        if(lst_acc.size()>0){
            return lst_acc[0];
        }
        return new Account();
    }
    @AuraEnabled(cacheable=true)
    public static List<Sales_Org__c> getSalesOrg(){
        Liquidation_Indo_turkey lit = new Liquidation_Indo_turkey();
        List<Sales_Org__c> lst_salesArea  = new  List<Sales_Org__c>();
        if(lit.country_name.containsIgnoreCase('indonesia')){
            lst_salesArea = [Select id,Name,Sales_Org_Code__c from Sales_Org__c where Sales_Org_Code__c = '6451' OR Sales_Org_Code__c = '6410'];
        }
        if(lit.country_name.containsIgnoreCase('turkey')){
            lst_salesArea = [Select id,Name,Sales_Org_Code__c from Sales_Org__c where Sales_Org_Code__c = '7110' OR Sales_Org_Code__c = '7120'];
        }
        if(lit.country_name.containsIgnoreCase('Vietnam')){
            lst_salesArea = [Select id,Name,Sales_Org_Code__c from Sales_Org__c where Sales_Org_Code__c = '6610' OR Sales_Org_Code__c = '6631'];
        }
        return lst_salesArea;
    }

    @AuraEnabled
    public static List<Liquidation2__c> getAllLiquidation(String sales_district,String distributor,String sales_org_code,String year,String month,String searchstr){
        Id rec_type = Schema.SObjectType.Liquidation2__c.getRecordTypeInfosByName().get('Multi Country').getRecordTypeId();
        String adminProfile = 'System Administrator';
        String liqQuery = 'Select Month__c,Opening_Inventory2__c,Opening_Inventory2__r.LastModifiedBy.Id,Opening_Inventory2__r.LastModifiedBy.profile.name,LastModifiedBy.Id,LastModifiedBy.profile.name,Opening_Inventory2__r.Opening_Inventory__c,submitted__c,SKU__r.Brand_Name__c,SKU__r.SKU_Code__c,SKU__r.SKU_Description__c,YTD_Sales__c,Liquidation_YTD__c,Total_Available_Stock__c,Distributor__c,Distributors_Inventory__c,Retailers_Inventory__c,Total_Market_Inventory__c,Plan_for_the_month__c,Liquidation_Percent_YTD__c,Plan_for_the_next_month__c,Brand_Name__c,SKU_Code__c,SKU_Description__c,YTD_Sales_formula__c from Liquidation2__c';
        System.debug('rec type '+rec_type);
        String str = searchstr+'%';
        System.debug('Search key '+searchstr);
        System.debug('sales_district str '+sales_district);
        System.debug('distributor '+distributor);
        System.debug('sales_org_code '+sales_org_code);
        System.debug('year '+year);
        System.debug('month '+month);
        Date startdate = Date.newInstance(Integer.valueOf(year), 4, 1);
        String start_date = String.valueOf(startdate).split(' ')[0];
        System.debug('sales_district'+sales_district+'distributor'+distributor+'sales_org_code'+sales_org_code+'month'+month+'start_date'+start_date);
        if(String.isEmpty(searchstr)){
            List<Liquidation2__c> lst_liquidation = new List<Liquidation2__c>();
            if(!String.isEmpty(sales_org_code)){
                String templiqQuery = liqQuery+' where SKU__r.Active_for_Liquidation__c = true and Month__c =\''+month+'\' and Distributor__c=\''+distributor+'\' and Liquidation_Annual_Plan__r.Fiscal_Start_Date__c='+start_date+' and Sales_District__c=\''+sales_district+'\' and Liquidation_Annual_Plan__r.Sales_Org__r.Sales_Org_Code__c=\''+sales_org_code+'\' and RecordTypeId=\''+rec_type+'\' order by Total_Available_Stock__c DESC, Brand_Name__c ASC';
                lst_liquidation = Database.query(templiqQuery);
            }else{
                Liquidation_Indo_turkey lit = new Liquidation_Indo_turkey();
                String [] lst_so = new String[]{};
                if(lit.country_name.toLowerCase()=='indonesia'){
                    lst_so = new String[] {'6451','6410'};
                }
                if(lit.country_name.toLowerCase()=='turkey'){
                    lst_so = new String[] {'7110','7120'};
                }
                if(lit.country_name.toLowerCase()=='vietnam'){
                    lst_so = new String[] {'6610', '6631'};
                }
                String templiqQuery = liqQuery+' where SKU__r.Active_for_Liquidation__c = true and Month__c =\''+month+'\' and Distributor__c=\''+distributor+'\' and Liquidation_Annual_Plan__r.Fiscal_Start_Date__c='+start_date+' and Sales_District__c=\''+sales_district+'\' and (Liquidation_Annual_Plan__r.Sales_Org__r.Sales_Org_Code__c=\''+lst_so[0]+'\' OR Liquidation_Annual_Plan__r.Sales_Org__r.Sales_Org_Code__c=\''+lst_so[1]+'\') and RecordTypeId=\''+rec_type+'\' order by Total_Available_Stock__c DESC, Brand_Name__c ASC';
                lst_liquidation = Database.query(templiqQuery);
            }
        if(lst_liquidation.size()>0){
            System.debug('Existing liquidation '+lst_liquidation.size());
            return lst_liquidation;
        }else{
            String profile_name = [Select id,Name from Profile where id=:UserInfo.getProfileId()].Name;
            System.debug('profile_name'+profile_name);
            if(profile_name.containsIgnoreCase('Regional/Zonal Indonesia') || profile_name.containsIgnoreCase('District Manager for Turkey')){
                System.debug('Creating liquidation');
               
                //Liquidation_Indo_turkey.insert_liquidation(sales_district,distributor,sales_org_code,start_date,month);
                if(!String.isEmpty(sales_org_code)){
                    String templiqQuery = liqQuery+' where SKU__r.Active_for_Liquidation__c = true and Month__c =\''+month+'\' and Distributor__c=\''+distributor+'\' and Liquidation_Annual_Plan__r.Fiscal_Start_Date__c='+start_date+' and Sales_District__c=\''+sales_district+'\' and Liquidation_Annual_Plan__r.Sales_Org__r.Sales_Org_Code__c=\''+sales_org_code+'\' and RecordTypeId=\''+rec_type+'\' order by Total_Available_Stock__c DESC, Brand_Name__c ASC';
                    system.debug('templiqQuery'+ templiqQuery);
                    List<Liquidation2__c> lst_liquidation1 = Database.query(templiqQuery);
                    system.debug('lst_liquidation1'+ lst_liquidation1);
                    return lst_liquidation1;
                }else{
                    Liquidation_Indo_turkey lit = new Liquidation_Indo_turkey();
                    String [] lst_so = new String[]{};
                    if(lit.country_name.toLowerCase()=='indonesia'){
                        lst_so = new String[] {'6451','6410'};
                    }
                    if(lit.country_name.toLowerCase()=='turkey'){
                        lst_so = new String[] {'7110','7120'};
                    }
                    if(lit.country_name.toLowerCase()=='vietnam'){
                        lst_so = new String[] {'6610', '6631'};
                    }
                    String templiqQuery = liqQuery+' where SKU__r.Active_for_Liquidation__c = true and Month__c =\''+month+'\' and Distributor__c=\''+distributor+'\' and Liquidation_Annual_Plan__r.Fiscal_Start_Date__c='+start_date+' and Sales_District__c=\''+sales_district+'\' and (Liquidation_Annual_Plan__r.Sales_Org__r.Sales_Org_Code__c=\''+lst_so[0]+'\' OR Liquidation_Annual_Plan__r.Sales_Org__r.Sales_Org_Code__c=\''+lst_so[1]+'\') and RecordTypeId=\''+rec_type+'\'  order by Total_Available_Stock__c DESC, Brand_Name__c ASC';
                    system.debug('templiqQuery'+templiqQuery);
                    List<Liquidation2__c> lst_liquidation1 = Database.query(templiqQuery);
                    system.debug('lstQueryliquidations'+lst_liquidation1);
                    
                    return lst_liquidation1;
                }
            }else{
                return new List<Liquidation2__c>();
            }
        }
    }else{
        List<Liquidation2__c> lst_liquidation = [Select Month__c,Opening_Inventory2__c,Opening_Inventory2__r.Opening_Inventory__c,submitted__c,SKU__r.Brand_Name__c,SKU__r.SKU_Code__c,SKU__r.SKU_Description__c,YTD_Sales__c,Liquidation_YTD__c,Total_Available_Stock__c,Distributor__c,Distributors_Inventory__c,Retailers_Inventory__c,Total_Market_Inventory__c,Plan_for_the_month__c,Liquidation_Percent_YTD__c,Plan_for_the_next_month__c,Brand_Name__c,SKU_Code__c,SKU_Description__c,YTD_Sales_formula__c from Liquidation2__c where SKU__r.Active_for_Liquidation__c = true and Month__c =:month and Distributor__c=:distributor and Liquidation_Annual_Plan__r.Fiscal_Start_Date__c=:startdate and Sales_District__c=:sales_district and  Liquidation_Annual_Plan__r.Sales_Org__r.Sales_Org_Code__c=:sales_org_code and RecordTypeId=:rec_type and SKU__r.SKU_Description__c like:str];
        return lst_liquidation;
    }
    }
   
/* ------------Start GRZ(Butesh Singla) : APPS-1395 PO And Delivery Date :18-07-2022 */
    @AuraEnabled
    public static List<Liquidation2__c> getAllLiquidationPDFXLS(String sales_district,String distributor,String sales_org_code,String year,String month,String searchstr){
        Id rec_type = Schema.SObjectType.Liquidation2__c.getRecordTypeInfosByName().get('Multi Country').getRecordTypeId();
        String adminProfile = 'System Administrator';
        String liqQuery = 'Select Month__c,Opening_Inventory2__c,Opening_Inventory2__r.LastModifiedBy.Id,Opening_Inventory2__r.LastModifiedBy.profile.name,LastModifiedBy.Id,LastModifiedBy.profile.name,Opening_Inventory2__r.Opening_Inventory__c,submitted__c,SKU__r.Brand_Name__c,SKU__r.SKU_Code__c,SKU__r.SKU_Description__c,YTD_Sales__c,Liquidation_YTD__c,SKU__r.UOM__c,Total_Available_Stock__c,Distributor__c,Distributors_Inventory__c,Retailers_Inventory__c,Total_Market_Inventory__c,Plan_for_the_month__c,Liquidation_Percent_YTD__c,Plan_for_the_next_month__c,Brand_Name__c,SKU_Code__c,SKU_Description__c,YTD_Sales_formula__c from Liquidation2__c';
        System.debug('rec type '+rec_type);
      //  String str = searchstr+'%';
        String searchValues='%' + searchstr + '%';
        System.debug('Search key '+searchstr);
        System.debug('sales_district str '+sales_district);
        System.debug('distributor '+distributor);
        System.debug('sales_org_code '+sales_org_code);
        System.debug('year '+year);
        System.debug('month '+month);
        
        Date startdate = Date.newInstance(Integer.valueOf(year), 4, 1);
        String start_date = String.valueOf(startdate).split(' ')[0];
        System.debug('sales_district'+sales_district+'distributor'+distributor+'sales_org_code'+sales_org_code+'month'+month+'start_date'+start_date);
        //if(String.isEmpty(searchstr)){
            List<Liquidation2__c> lst_liquidation = new List<Liquidation2__c>();
            if(!String.isEmpty(sales_org_code)){
                System.debug('1');
                String templiqQuery = liqQuery+' where SKU__r.Active_for_Liquidation__c = true and Month__c =\''+month+'\' and Distributor__c=\''+distributor+'\' and Liquidation_Annual_Plan__r.Fiscal_Start_Date__c='+start_date+' and Sales_District__c=\''+sales_district+'\' and Liquidation_Annual_Plan__r.Sales_Org__r.Sales_Org_Code__c=\''+sales_org_code+'\' and RecordTypeId=\''+rec_type+'\'  And (SKU__r.Brand_Name__c Like: searchValues Or SKU__r.SKU_Code__c Like: searchValues Or SKU__r.SKU_Description__c Like :searchValues)  order by Total_Available_Stock__c DESC, Brand_Name__c ASC';
                lst_liquidation = Database.query(templiqQuery);
            }else{
                Liquidation_Indo_turkey lit = new Liquidation_Indo_turkey();
                String [] lst_so = new String[]{};
                if(lit.country_name.toLowerCase()=='indonesia'){
                    lst_so = new String[] {'6451','6410'};
                }
                if(lit.country_name.toLowerCase()=='turkey'){
                    lst_so = new String[] {'7110','7120'};
                }
                if(lit.country_name.toLowerCase()=='vietnam'){
                    lst_so = new String[] {'6610', '6631'};
                }
                String templiqQuery = liqQuery+' where SKU__r.Active_for_Liquidation__c = true and Month__c =\''+month+'\' and Distributor__c=\''+distributor+'\' and Liquidation_Annual_Plan__r.Fiscal_Start_Date__c='+start_date+' and Sales_District__c=\''+sales_district+'\' and (Liquidation_Annual_Plan__r.Sales_Org__r.Sales_Org_Code__c=\''+lst_so[0]+'\' OR Liquidation_Annual_Plan__r.Sales_Org__r.Sales_Org_Code__c=\''+lst_so[1]+'\') and RecordTypeId=\''+rec_type+'\'  And (SKU__r.Brand_Name__c Like: searchValues Or SKU__r.SKU_Code__c Like: searchValues Or SKU__r.SKU_Description__c Like :searchValues) order by Total_Available_Stock__c DESC, Brand_Name__c ASC';
                lst_liquidation = Database.query(templiqQuery);
            }
        if(lst_liquidation.size()>0){
            System.debug('2');
            System.debug('Existing liquidation '+lst_liquidation.size());
            return lst_liquidation;
        }else{
            System.debug('3');
            String profile_name = [Select id,Name from Profile where id=:UserInfo.getProfileId()].Name;
            system.debug('profile_name'+profile_name);
            if(profile_name.containsIgnoreCase('Regional/Zonal Indonesia') || profile_name.containsIgnoreCase('District Manager for Turkey')){
                System.debug('Creating liquidation');
                System.debug('4');
                //Liquidation_Indo_turkey.insert_liquidation(sales_district,distributor,sales_org_code,start_date,month);
                if(!String.isEmpty(sales_org_code)){
                    String templiqQuery = liqQuery+' where SKU__r.Active_for_Liquidation__c = true and Month__c =\''+month+'\' and Distributor__c=\''+distributor+'\' and Liquidation_Annual_Plan__r.Fiscal_Start_Date__c='+start_date+' and Sales_District__c=\''+sales_district+'\' and Liquidation_Annual_Plan__r.Sales_Org__r.Sales_Org_Code__c=\''+sales_org_code+'\' and RecordTypeId=\''+rec_type+'\'  And (SKU__r.Brand_Name__c Like: searchValues Or SKU__r.SKU_Code__c Like: searchValues Or SKU__r.SKU_Description__c Like :searchValues) order by Total_Available_Stock__c DESC, Brand_Name__c ASC';
                    system.debug('templiqQuery'+ templiqQuery);
                    List<Liquidation2__c> lst_liquidation1 = Database.query(templiqQuery);
                    system.debug('lst_liquidation1'+ lst_liquidation1);
                    return lst_liquidation1;
                }else{
                    System.debug('5');
                    Liquidation_Indo_turkey lit = new Liquidation_Indo_turkey();
                    String [] lst_so = new String[]{};
                    if(lit.country_name.toLowerCase()=='indonesia'){
                        lst_so = new String[] {'6451','6410'};
                    }
                    if(lit.country_name.toLowerCase()=='turkey'){
                        lst_so = new String[] {'7110','7120'};
                    }
                    if(lit.country_name.toLowerCase()=='vietnam'){
                        lst_so = new String[] {'6610', '6631'};
                    }
                    System.debug('month'+month );
                    System.debug('distributor'+distributor);
                    System.debug('sales_district'+sales_district);
                    System.debug('lst_so[0]'+lst_so[0]);
                    System.debug('rec_type'+rec_type);
                    System.debug('searchValues'+searchValues);
                    System.debug('start_date'+start_date);
                    
                    String templiqQuery = liqQuery+' where SKU__r.Active_for_Liquidation__c = true and Month__c =\''+month+'\' and Distributor__c=\''+distributor+'\' and Liquidation_Annual_Plan__r.Fiscal_Start_Date__c='+start_date+' and Sales_District__c=\''+sales_district+'\' and (Liquidation_Annual_Plan__r.Sales_Org__r.Sales_Org_Code__c=\''+lst_so[0]+'\' OR Liquidation_Annual_Plan__r.Sales_Org__r.Sales_Org_Code__c=\''+lst_so[1]+'\') and RecordTypeId=\''+rec_type+'\'  And (SKU__r.Brand_Name__c Like: searchValues Or SKU__r.SKU_Code__c Like: searchValues Or SKU__r.SKU_Description__c Like :searchValues)  order by Total_Available_Stock__c DESC, Brand_Name__c ASC';
                    system.debug('templiqQuery'+templiqQuery);
                    List<Liquidation2__c> lst_liquidation1 = Database.query(templiqQuery);
                    system.debug('lstQueryliquidations'+lst_liquidation1);
                    
                    return lst_liquidation1;
                }
            }else{
                System.debug('6');
                return new List<Liquidation2__c>();
            }
        }
   // }else{
     //   List<Liquidation2__c> lst_liquidation = [Select Month__c,Opening_Inventory2__c,Opening_Inventory2__r.Opening_Inventory__c,submitted__c,SKU__r.Brand_Name__c,SKU__r.SKU_Code__c,SKU__r.SKU_Description__c,YTD_Sales__c,Liquidation_YTD__c,Total_Available_Stock__c,Distributor__c,Distributors_Inventory__c,Retailers_Inventory__c,Total_Market_Inventory__c,Plan_for_the_month__c,Liquidation_Percent_YTD__c,Plan_for_the_next_month__c,Brand_Name__c,SKU_Code__c,SKU_Description__c,YTD_Sales_formula__c from Liquidation2__c where SKU__r.Active_for_Liquidation__c = true and Month__c =:month and Distributor__c=:distributor and Liquidation_Annual_Plan__r.Fiscal_Start_Date__c=:startdate and Sales_District__c=:sales_district and  Liquidation_Annual_Plan__r.Sales_Org__r.Sales_Org_Code__c=:sales_org_code and RecordTypeId=:rec_type and SKU__r.SKU_Code__c like:str];
      //  return lst_liquidation;
 //   }
    }
/* -- */

    @AuraEnabled
    public static Liquidation2__c saveLiquidation(Liquidation2__c liq){
       System.debug('Liquidation '+liq);
       update liq;
       return liq;
    }

    @AuraEnabled
    public static Liquidation2__c updatePlanForMonth(Liquidation2__c liq){
        update liq;
        Liquidation_Indo_turkey obj = new Liquidation_Indo_turkey();
        Liquidation2__c liq1 = [Select Month__c,Opening_Inventory2__c,Opening_Inventory2__r.Opening_Inventory__c,Liquidation_Annual_Plan__r.Fiscal_Start_Date__c,submitted__c,SKU__c,SKU__r.Brand_Name__c,SKU__r.SKU_Code__c,SKU__r.SKU_Description__c,YTD_Sales__c,Liquidation_YTD__c,Total_Available_Stock__c,Distributor__c,Distributors_Inventory__c,Retailers_Inventory__c,Total_Market_Inventory__c,Plan_for_the_month__c,Liquidation_Percent_YTD__c,Plan_for_the_next_month__c,Brand_Name__c,SKU_Code__c,SKU_Description__c,YTD_Sales_formula__c,Sales_District__c,Liquidation_Annual_Plan__r.Sales_Org__r.Sales_Org_Code__c,RecordTypeId from Liquidation2__c where Id=:liq.Id];
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
        System.debug('month '+month+' distributor '+distributor+' start_date '+start_date+' sales_dist '+sales_district+' rec_type '+rec_type+' opening_inventory '+opening_inventory+' sales_org_code '+sales_org_code+' sku '+sku);
        Liquidation2__c new_liq = [Select Month__c,Opening_Inventory2__c,Opening_Inventory2__r.Opening_Inventory__c,submitted__c,SKU__r.Brand_Name__c,SKU__r.SKU_Code__c,SKU__r.SKU_Description__c,YTD_Sales__c,Liquidation_YTD__c,Total_Available_Stock__c,Distributor__c,Distributors_Inventory__c,Retailers_Inventory__c,Total_Market_Inventory__c,Plan_for_the_month__c,Liquidation_Percent_YTD__c,Plan_for_the_next_month__c,Brand_Name__c,SKU_Code__c,SKU_Description__c,YTD_Sales_formula__c from Liquidation2__c where SKU__r.Active_for_Liquidation__c = true and Month__c =:month and Distributor__c=:distributor and Liquidation_Annual_Plan__r.Fiscal_Start_Date__c=:start_date and Sales_District__c=:sales_district and Liquidation_Annual_Plan__r.Sales_Org__r.Sales_Org_Code__c=:sales_org_code  and RecordTypeId=:rec_type and SKU__c=:sku limit 1];

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

    @AuraEnabled
    public static Map<String,Liquidation2__c> rollUpLiquidation(String lst_salesDistricts,String sales_districts,String start_year,String month,String distributor,String sales_org){
        Liquidation_Indo_turkey lit = new Liquidation_Indo_turkey();
        System.debug('lst_salesDistricts '+lst_salesDistricts);
        System.debug('sales_districts '+sales_districts);
        
        Date start_date;
        List<Liquidation2__c> lst_liq = new List<Liquidation2__c>();
        Map<String,Liquidation2__c> map_liq = new Map<String,Liquidation2__c>();
        string tem_date = '';
        if(!String.isEmpty(start_year)){
            start_date = Date.newInstance(Integer.valueOf(start_year), 4, 1);
            tem_date = String.valueOf(start_date).split(' ')[0];
        }
        
        Id rec_type = Schema.SObjectType.Liquidation2__c.getRecordTypeInfosByName().get('Multi Country').getRecordTypeId();
        String [] lst_so = new String[]{};
        if(lit.country_name.toLowerCase()=='indonesia'){
            lst_so = new String[] {'6451','6410'};
        }
        if(lit.country_name.toLowerCase()=='turkey'){
            lst_so = new String[] {'7110','7120'};
        }
        if(lit.country_name.toLowerCase()=='vietnam'){
            lst_so = new String[] {'6610', '6631'};
        }
        
        System.debug('sales_districts '+sales_districts+' start_year '+start_year +' month '+month+' Distributor '+distributor+' sales_org '+sales_org+' lst sales_org '+lst_so);
           
        String query = 'SELECT+SKU__r.SKU_Code__c,SKU__r.Brand_Name__c,SKU__r.SKU_Description__c,+SUM(YTD_Sales_formula__c),+SUM(Liquidation_YTD__c),+SUM(Total_Available_Stock__c),+SUM(Distributors_Inventory__c),+SUM(Retailers_Inventory__c),+SUM(Total_Market_Inventory__c),+SUM(Plan_for_the_month__c),+SUM(Plan_for_the_next_month__c),+SUM(Opening_Inventory2__r.Opening_Inventory__c),+AVG(Liquidation_Percent_YTD__c)+FROM+Liquidation2__c';
        String filter = '';
    

        if(String.isEmpty(sales_org) && String.isEmpty(sales_districts) && String.isEmpty(distributor) &&!String.isEmpty(start_year)&&!String.isEmpty(month)&&!String.isEmpty(rec_type)){
            filter = '++WHERE+SKU__r.Active_for_Liquidation__c+=+true++AND+RecordTypeId+=+\''+rec_type+'\'++AND+Month__c+=+\''+month+'\'++AND+Liquidation_Annual_Plan__r.Fiscal_Start_Date__c+=+'+tem_date+'+AND+(Liquidation_Annual_Plan__r.Sales_Org__r.Sales_Org_Code__c+=+\''+lst_so[0]+'\'+OR+Liquidation_Annual_Plan__r.Sales_Org__r.Sales_Org_Code__c+=+\''+lst_so[1]+'\')++Group+By+SKU__r.SKU_Code__c,SKU__r.SKU_Description__c,SKU__r.Brand_Name__c';  
        }
        if(String.isEmpty(sales_org) && !String.isEmpty(sales_districts) && !String.isEmpty(distributor) &&!String.isEmpty(start_year)&&!String.isEmpty(month)&&!String.isEmpty(rec_type)){
            filter = '++WHERE+SKU__r.Active_for_Liquidation__c+=+true++AND+RecordTypeId+=+\''+rec_type+'\'++AND+Month__c+=+\''+month+'\'++AND+Liquidation_Annual_Plan__r.Fiscal_Start_Date__c+=+'+tem_date+'+AND+(Liquidation_Annual_Plan__r.Sales_Org__r.Sales_Org_Code__c+=+\''+lst_so[0]+'\'+OR+Liquidation_Annual_Plan__r.Sales_Org__r.Sales_Org_Code__c+=+\''+lst_so[1]+'\')++AND+Sales_District__c+=+\''+sales_districts+'\'++AND+Distributor__c+=+\''+distributor+'\'+Group+By+SKU__r.SKU_Code__c,SKU__r.SKU_Description__c,SKU__r.Brand_Name__c';  
        }
        if(String.isEmpty(sales_org) && !String.isEmpty(sales_districts) && String.isEmpty(distributor) &&!String.isEmpty(start_year)&&!String.isEmpty(month)&&!String.isEmpty(rec_type)){
            filter = '++WHERE+SKU__r.Active_for_Liquidation__c+=+true++AND+RecordTypeId+=+\''+rec_type+'\'++AND+Month__c+=+\''+month+'\'++AND+Liquidation_Annual_Plan__r.Fiscal_Start_Date__c+=+'+tem_date+'+AND+(Liquidation_Annual_Plan__r.Sales_Org__r.Sales_Org_Code__c+=+\''+lst_so[0]+'\'+OR+Liquidation_Annual_Plan__r.Sales_Org__r.Sales_Org_Code__c+=+\''+lst_so[1]+'\')++AND+Sales_District__c+=+\''+sales_districts+'\'++Group+By+SKU__r.SKU_Code__c,SKU__r.SKU_Description__c,SKU__r.Brand_Name__c';  
        }
        if(!String.isEmpty(sales_org) && !String.isEmpty(sales_districts) && String.isEmpty(distributor) &&!String.isEmpty(start_year)&&!String.isEmpty(month)&&!String.isEmpty(rec_type)){
            filter = '++WHERE+SKU__r.Active_for_Liquidation__c+=+true++AND+RecordTypeId+=+\''+rec_type+'\'++AND+Month__c+=+\''+month+'\'++AND+Liquidation_Annual_Plan__r.Fiscal_Start_Date__c+=+'+tem_date+'+AND+Liquidation_Annual_Plan__r.Sales_Org__r.Sales_Org_Code__c+=+\''+sales_org+'\'++AND+Sales_District__c+=+\''+sales_districts+'\'+Group+By+SKU__r.SKU_Code__c,SKU__r.SKU_Description__c,SKU__r.Brand_Name__c';  
        }
        if(!String.isEmpty(sales_org) && !String.isEmpty(sales_districts) && !String.isEmpty(distributor) &&!String.isEmpty(start_year)&&!String.isEmpty(month)&&!String.isEmpty(rec_type)){
            filter = '++WHERE+SKU__r.Active_for_Liquidation__c+=+true++AND+RecordTypeId+=+\''+rec_type+'\'++AND+Month__c+=+\''+month+'\'++AND+Liquidation_Annual_Plan__r.Fiscal_Start_Date__c+=+'+tem_date+'+AND+(Liquidation_Annual_Plan__r.Sales_Org__r.Sales_Org_Code__c+=+\''+lst_so[0]+'\'+OR+Liquidation_Annual_Plan__r.Sales_Org__r.Sales_Org_Code__c+=+\''+lst_so[1]+'\')++AND+Sales_District__c+=+\''+sales_districts+'\'+Group+By+SKU__r.SKU_Code__c,SKU__r.SKU_Description__c,SKU__r.Brand_Name__c';  
        }
        if(!String.isEmpty(sales_org) && String.isEmpty(sales_districts) && String.isEmpty(distributor) &&!String.isEmpty(start_year)&&!String.isEmpty(month)&&!String.isEmpty(rec_type)){
            filter = '++WHERE+SKU__r.Active_for_Liquidation__c+=+true++AND+RecordTypeId+=+\''+rec_type+'\'++AND+Month__c+=+\''+month+'\'++AND+Liquidation_Annual_Plan__r.Fiscal_Start_Date__c+=+'+tem_date+'+AND+(Liquidation_Annual_Plan__r.Sales_Org__r.Sales_Org_Code__c+=+\''+lst_so[0]+'\'+OR+Liquidation_Annual_Plan__r.Sales_Org__r.Sales_Org_Code__c+=+\''+lst_so[1]+'\')++Group+By+SKU__r.SKU_Code__c,SKU__r.SKU_Description__c,SKU__r.Brand_Name__c';  
        }
        if(!String.isEmpty(sales_org) && String.isEmpty(sales_districts) && !String.isEmpty(distributor) &&!String.isEmpty(start_year)&&!String.isEmpty(month)&&!String.isEmpty(rec_type)){
            filter = '++WHERE+SKU__r.Active_for_Liquidation__c+=+true++AND+RecordTypeId+=+\''+rec_type+'\'++AND+Month__c+=+\''+month+'\'++AND+Liquidation_Annual_Plan__r.Fiscal_Start_Date__c+=+'+tem_date+'+AND+(Liquidation_Annual_Plan__r.Sales_Org__r.Sales_Org_Code__c+=+\''+lst_so[0]+'\'+OR+Liquidation_Annual_Plan__r.Sales_Org__r.Sales_Org_Code__c+=+\''+lst_so[1]+'\')+Distributor__c+=+\''+distributor+'\'+Group+By+SKU__r.SKU_Code__c,SKU__r.SKU_Description__c,SKU__r.Brand_Name__c';  
        }
        System.debug('Query '+query+filter);
         try{
        	return RollUpLiquidationDetails.rollUpLiquidation(query+filter);
        }catch(Exception e){
            System.debug('Ex -->'+e);
            return new Map<String,Liquidation2__c>();
        }
    }

    /* ------------Start GRZ(Butesh Singla) : APPS-1395 PO And Delivery Date :18-07-2022 */
    @AuraEnabled
    public static Map<String,Liquidation2__c> rollUpLiquidationPDFXLS(String sales_districts,String start_year,String month,String distributor,String sales_org){
        Liquidation_Indo_turkey lit = new Liquidation_Indo_turkey();

        System.debug('sales_districts '+sales_districts);
        
        Date start_date;
        List<Liquidation2__c> lst_liq = new List<Liquidation2__c>();
        Map<String,Liquidation2__c> map_liq = new Map<String,Liquidation2__c>();
        string tem_date = '';
        if(!String.isEmpty(start_year)){
            start_date = Date.newInstance(Integer.valueOf(start_year), 4, 1);
            tem_date = String.valueOf(start_date).split(' ')[0];
        }
        
        Id rec_type = Schema.SObjectType.Liquidation2__c.getRecordTypeInfosByName().get('Multi Country').getRecordTypeId();
        String [] lst_so = new String[]{};
        if(lit.country_name.toLowerCase()=='indonesia'){
            lst_so = new String[] {'6451','6410'};
        }
        if(lit.country_name.toLowerCase()=='turkey'){
            lst_so = new String[] {'7110','7120'};
        }
        if(lit.country_name.toLowerCase()=='vietnam'){
            lst_so = new String[] {'6610', '6631'};
        }
        
        System.debug('sales_districts '+sales_districts+' start_year '+start_year +' month '+month+' Distributor '+distributor+' sales_org '+sales_org+' lst sales_org '+lst_so);
           
        String query = 'SELECT+SKU__r.SKU_Code__c,SKU__r.Brand_Name__c,SKU__r.SKU_Description__c,+SUM(YTD_Sales_formula__c),+SUM(Liquidation_YTD__c),+SUM(Total_Available_Stock__c),+SUM(Distributors_Inventory__c),+SUM(Retailers_Inventory__c),+SUM(Total_Market_Inventory__c),+SUM(Plan_for_the_month__c),+SUM(Plan_for_the_next_month__c),+SUM(Opening_Inventory2__r.Opening_Inventory__c),+AVG(Liquidation_Percent_YTD__c)+FROM+Liquidation2__c';
        String filter = '';
    

        if(String.isEmpty(sales_org) && String.isEmpty(sales_districts) && String.isEmpty(distributor) &&!String.isEmpty(start_year)&&!String.isEmpty(month)&&!String.isEmpty(rec_type)){
            filter = '++WHERE+SKU__r.Active_for_Liquidation__c+=+true++AND+RecordTypeId+=+\''+rec_type+'\'++AND+Month__c+=+\''+month+'\'++AND+Liquidation_Annual_Plan__r.Fiscal_Start_Date__c+=+'+tem_date+'+AND+(Liquidation_Annual_Plan__r.Sales_Org__r.Sales_Org_Code__c+=+\''+lst_so[0]+'\'+OR+Liquidation_Annual_Plan__r.Sales_Org__r.Sales_Org_Code__c+=+\''+lst_so[1]+'\')++Group+By+SKU__r.SKU_Code__c,SKU__r.SKU_Description__c,SKU__r.Brand_Name__c';  
        }
        if(String.isEmpty(sales_org) && !String.isEmpty(sales_districts) && !String.isEmpty(distributor) &&!String.isEmpty(start_year)&&!String.isEmpty(month)&&!String.isEmpty(rec_type)){
            filter = '++WHERE+SKU__r.Active_for_Liquidation__c+=+true++AND+RecordTypeId+=+\''+rec_type+'\'++AND+Month__c+=+\''+month+'\'++AND+Liquidation_Annual_Plan__r.Fiscal_Start_Date__c+=+'+tem_date+'+AND+(Liquidation_Annual_Plan__r.Sales_Org__r.Sales_Org_Code__c+=+\''+lst_so[0]+'\'+OR+Liquidation_Annual_Plan__r.Sales_Org__r.Sales_Org_Code__c+=+\''+lst_so[1]+'\')++AND+Sales_District__c+=+\''+sales_districts+'\'++AND+Distributor__c+=+\''+distributor+'\'+Group+By+SKU__r.SKU_Code__c,SKU__r.SKU_Description__c,SKU__r.Brand_Name__c';  
        }
        if(String.isEmpty(sales_org) && !String.isEmpty(sales_districts) && String.isEmpty(distributor) &&!String.isEmpty(start_year)&&!String.isEmpty(month)&&!String.isEmpty(rec_type)){
            filter = '++WHERE+SKU__r.Active_for_Liquidation__c+=+true++AND+RecordTypeId+=+\''+rec_type+'\'++AND+Month__c+=+\''+month+'\'++AND+Liquidation_Annual_Plan__r.Fiscal_Start_Date__c+=+'+tem_date+'+AND+(Liquidation_Annual_Plan__r.Sales_Org__r.Sales_Org_Code__c+=+\''+lst_so[0]+'\'+OR+Liquidation_Annual_Plan__r.Sales_Org__r.Sales_Org_Code__c+=+\''+lst_so[1]+'\')++AND+Sales_District__c+=+\''+sales_districts+'\'++Group+By+SKU__r.SKU_Code__c,SKU__r.SKU_Description__c,SKU__r.Brand_Name__c';  
        }
        if(!String.isEmpty(sales_org) && !String.isEmpty(sales_districts) && String.isEmpty(distributor) &&!String.isEmpty(start_year)&&!String.isEmpty(month)&&!String.isEmpty(rec_type)){
            filter = '++WHERE+SKU__r.Active_for_Liquidation__c+=+true++AND+RecordTypeId+=+\''+rec_type+'\'++AND+Month__c+=+\''+month+'\'++AND+Liquidation_Annual_Plan__r.Fiscal_Start_Date__c+=+'+tem_date+'+AND+Liquidation_Annual_Plan__r.Sales_Org__r.Sales_Org_Code__c+=+\''+sales_org+'\'++AND+Sales_District__c+=+\''+sales_districts+'\'+Group+By+SKU__r.SKU_Code__c,SKU__r.SKU_Description__c,SKU__r.Brand_Name__c';  
        }
        if(!String.isEmpty(sales_org) && !String.isEmpty(sales_districts) && !String.isEmpty(distributor) &&!String.isEmpty(start_year)&&!String.isEmpty(month)&&!String.isEmpty(rec_type)){
            filter = '++WHERE+SKU__r.Active_for_Liquidation__c+=+true++AND+RecordTypeId+=+\''+rec_type+'\'++AND+Month__c+=+\''+month+'\'++AND+Liquidation_Annual_Plan__r.Fiscal_Start_Date__c+=+'+tem_date+'+AND+(Liquidation_Annual_Plan__r.Sales_Org__r.Sales_Org_Code__c+=+\''+lst_so[0]+'\'+OR+Liquidation_Annual_Plan__r.Sales_Org__r.Sales_Org_Code__c+=+\''+lst_so[1]+'\')++AND+Sales_District__c+=+\''+sales_districts+'\'+Group+By+SKU__r.SKU_Code__c,SKU__r.SKU_Description__c,SKU__r.Brand_Name__c';  
        }
        if(!String.isEmpty(sales_org) && String.isEmpty(sales_districts) && String.isEmpty(distributor) &&!String.isEmpty(start_year)&&!String.isEmpty(month)&&!String.isEmpty(rec_type)){
            filter = '++WHERE+SKU__r.Active_for_Liquidation__c+=+true++AND+RecordTypeId+=+\''+rec_type+'\'++AND+Month__c+=+\''+month+'\'++AND+Liquidation_Annual_Plan__r.Fiscal_Start_Date__c+=+'+tem_date+'+AND+(Liquidation_Annual_Plan__r.Sales_Org__r.Sales_Org_Code__c+=+\''+lst_so[0]+'\'+OR+Liquidation_Annual_Plan__r.Sales_Org__r.Sales_Org_Code__c+=+\''+lst_so[1]+'\')++Group+By+SKU__r.SKU_Code__c,SKU__r.SKU_Description__c,SKU__r.Brand_Name__c';  
        }
        if(!String.isEmpty(sales_org) && String.isEmpty(sales_districts) && !String.isEmpty(distributor) &&!String.isEmpty(start_year)&&!String.isEmpty(month)&&!String.isEmpty(rec_type)){
            filter = '++WHERE+SKU__r.Active_for_Liquidation__c+=+true++AND+RecordTypeId+=+\''+rec_type+'\'++AND+Month__c+=+\''+month+'\'++AND+Liquidation_Annual_Plan__r.Fiscal_Start_Date__c+=+'+tem_date+'+AND+(Liquidation_Annual_Plan__r.Sales_Org__r.Sales_Org_Code__c+=+\''+lst_so[0]+'\'+OR+Liquidation_Annual_Plan__r.Sales_Org__r.Sales_Org_Code__c+=+\''+lst_so[1]+'\')+Distributor__c+=+\''+distributor+'\'+Group+By+SKU__r.SKU_Code__c,SKU__r.SKU_Description__c,SKU__r.Brand_Name__c';  
        }
        System.debug('Query '+query+filter);
         try{
        	return RollUpLiquidationDetails.rollUpLiquidation(query+filter);
        }catch(Exception e){
            System.debug('Ex -->'+e);
            return new Map<String,Liquidation2__c>();
        }
    }
	/* -- */
    
    @AuraEnabled
    public static Boolean isCommunityUser(){
        List<User> communityUser = [Select Id,Name,ContactId,Contact.AccountId,Contact.Account.Name from User where ContactId!=null and Id=:UserInfo.getUserId() and Country='Turkey'];
        System.debug('size '+communityUser.size()+'condition '+(communityUser.size()>0));
        if(communityUser.size()>0){
            return true;
        }else{
            return false;
        }
    }
    @AuraEnabled
    public static Account getCommunityDistributor(){
        List<User> communityUser = [Select Id,Name,ContactId,Contact.AccountId,Contact.Account.Name from User where ContactId!=null and Id=:UserInfo.getUserId() and Country='Turkey'];
        if(communityUser.size()>0){
            Account acc = new Account();
            acc.Id = communityUser[0].Contact.AccountId;
            acc.Name = communityUser[0].Contact.Account.Name;
            return acc;
        }
        return null;
    }

    @AuraEnabled
    public static Boolean isActiveCommunity(String accid){
        List<Account> acc = [Select Id,Name,Is_Community_Active__c from Account where Id=:accid];
        if(acc.size()>0){
            return acc[0].Is_Community_Active__c;
        }
        return false;
    }
}