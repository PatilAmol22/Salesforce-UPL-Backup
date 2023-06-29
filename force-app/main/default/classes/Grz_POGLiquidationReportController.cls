public class Grz_POGLiquidationReportController {
    
    @AuraEnabled(cacheable = true)
    public static List<POGDataWrapperData> getPOGSkusList(String fieldName){
        List<POGDataWrapperData> skuWrapDataList = new List<POGDataWrapperData>();
        String salesOrgCode = System.Label.Grz_PolandSalesOrgCode;
        List<SKU__c> skuList = [SELECT Id, sku_code__c,SKU_Description__c FROM SKU__c where Sales_Org_Code__c =: salesOrgCode and Active_for_Liquidation__c = true];
        
        for(SKU__c sku : skuList){
            POGDataWrapperData obj = new POGDataWrapperData();
            obj.Id = sku.Id;
            if(fieldName == 'sku_code'){
                //obj.SKU_Code = sku.sku_code__c;
                String skuStr = sku.sku_code__c;
                obj.SKU_Code = skuStr.replaceFirst('^0+','');
            }else if(fieldName == 'SKU_Description'){
                if(null !=sku.SKU_Description__c && sku.SKU_Description__c != ''){
                     obj.SKU_Code = sku.SKU_Description__c;
                }
            }
            
            skuWrapDataList.add(obj);
        }
        
        System.debug('skuWrapDataList : '+skuWrapDataList);
        return skuWrapDataList;
        
    }
	@AuraEnabled(cacheable = true)
    public static List<AggregateResult> getPOGBrandList(){
        String salesOrgCode = System.Label.Grz_PolandSalesOrgCode;
        List<AggregateResult> skuList = [SELECT Brand_Name__c FROM SKU__c where Sales_Org_Code__c = :salesOrgCode and Active_for_Liquidation__c = true group by Brand_Name__c];
       
        return skuList;
        
    }
    @AuraEnabled
    public static List<POGDataWrapperData> getPOGLiquidationReportData(List<String> distributor,String year, String quarter, List<String> skuList,Boolean excludeDisInventory){
        POGResultWrapper rwObj = new  POGResultWrapper();
        String salesOrgCode = System.Label.Grz_PolandSalesOrgCode;
        System.debug('distributor : '+distributor);
        //System.debug('distributorName : '+distributorName);
        System.debug('year : '+year);
        System.debug('skuList : '+skuList);
        Date start_date = Date.newInstance(Integer.valueOf(year), 4, 1); 
        System.debug('start_date : '+start_date);
        System.debug('quarter : '+quarter);
        Id rec_type = Schema.SObjectType.Liquidation2__c.getRecordTypeInfosByName().get('Multi Country').getRecordTypeId();
        System.debug('rec type '+rec_type);
        String query = 'SELECT SKU__r.Brand_Name__c,SKU__r.SKU_Code__c,SKU__r.SKU_Description__c,Sum(Opening_Inventory2__r.Opening_Inventory__c),Sum(Opening_Inventory2__r.Opening_Inventory_PLN__c),Sum(YTD_Sales_Poland__c),Sum(YTD_Sales_Poland_PLN__c),Sum(Total_Available_Stock__c),Sum(Total_Available_Stock_PLN__c),Sum(Distributors_Inventory__c),Sum(Distributors_Inventory_PLN__c),Sum(Liquidation_YTD__c),Sum(Liquidation_PLN__c),Sum(Liquidation_Percent_YTD__c) FROM Liquidation2__c where ';
       system.debug('distributor'+distributor);
        
    
        
        if(null != distributor && !distributor.isEmpty()){
           query +=  'Distributor__c in : distributor and ';
        }
        
        if(null != skuList && !skuList.isEmpty()){
            query += 'SKU__c in : skuList and ';
        }
        
        System.debug('query : '+query);
                         
        query += 'Liquidation_Annual_Plan__r.Fiscal_Start_Date__c =: start_date and Quarter__c =: quarter and SKU__r.Active_for_Liquidation__c = true and Liquidation_Annual_Plan__r.Sales_Org__r.Sales_Org_Code__c =: salesOrgCode and RecordTypeId=:rec_type group by SKU__r.SKU_Description__c,SKU__r.SKU_Code__c,SKU__r.Brand_Name__c ';
        
        if(excludeDisInventory){
            query += 'HAVING Sum(Distributors_Inventory__c) != 0 ';
        }
		
		query += 'Order by SKU__r.SKU_Code__c';
        
        System.debug('query : '+query);

        List<POGDataWrapperData> POGWrapDataList = new List<POGDataWrapperData>();
        System.debug('Database.query(query)'+Database.query(query));
        for (AggregateResult result : Database.query(query)){
            
            POGDataWrapperData obj = new POGDataWrapperData();
            obj.Brand = String.valueOf(result.get('Brand_Name__c'));
            String skuStr = String.valueOf(result.get('SKU_Code__c'));
            obj.SKU_Code = skuStr.replaceFirst('^0+','');
            //obj.SKU_Code = String.valueOf(result.get('SKU_Code__c'));
            obj.SKU_Description = String.valueOf(result.get('SKU_Description__c'));
              /* ------------Start GRZ(Butesh Singla) : APPS-1395 PO And Delivery Date :05-06-2022 */  
            obj.Opening_inventory =  String.valueOf(((Decimal)(result.get('expr0'))).setScale(0).format());
            obj.Opening_inventory_PLN =  String.valueOf(((Decimal)(result.get('expr1'))).setScale(0).format());
            obj.YTD_sales =  String.valueOf(((Decimal)(result.get('expr2'))).setScale(0).format());
            obj.YTD_sales_PLN =  String.valueOf(((Decimal)(result.get('expr3'))).setScale(0).format());
            obj.Total_Available_Stock =  String.valueOf(((Decimal)(result.get('expr4'))).setScale(0).format());
            obj.Total_Available_Stock_PLN = String.valueOf(((Decimal)(result.get('expr5'))).setScale(0).format());
            obj.Distributor_Inventory = String.valueOf(((Decimal)(result.get('expr6'))).setScale(0).format());
            obj.Distributor_Inventory_PLN = String.valueOf(((Decimal)(result.get('expr7'))).setScale(0).format());
            obj.Liquidation_YTD = String.valueOf(((Decimal)(result.get('expr8'))).setScale(0).format());
            obj.Liquidation_PLN = String.valueOf(((Decimal)(result.get('expr9'))).setScale(0).format());
            //obj.Liquidation_YTD_per_plan_YTD = String.valueOf(result.get('expr10'));
            String tas = String.valueOf(result.get('expr5'));
            String liq = String.valueOf(result.get('expr9'));
            if(decimal.valueof(tas) != 0){
                System.debug('tas : '+ decimal.valueof(tas));
                System.debug('liq '+ decimal.valueof(liq));
                Decimal percentage = decimal.valueof(liq)/decimal.valueof(tas) * 100;
            	obj.Liquidation_YTD_per_plan_YTD = String.valueOf(percentage.setScale(0));
            }else{
                obj.Liquidation_YTD_per_plan_YTD = '0';
            }
            /* -- */
            POGWrapDataList.add(obj);
            System.debug('result==>'+result);
            //System.debug('result==>'+result.get('SKU_Code__c'));                   
        }       
        System.debug('POGWrapDataList : '+POGWrapDataList);
        rwObj.POGWrapDataList = POGWrapDataList;
        System.debug('rwObj : '+rwObj);
        return POGWrapDataList;
    }

    /* ------------Start GRZ(Butesh Singla) : APPS-1395 PO And Delivery Date :05-06-2022 */  
    @AuraEnabled
    public static VFData getPOGLiquidationReportDataForVf(List<String> distributor,String year, String quarter, List<String> skuList,Boolean excludeDisInventory, String search){
        
        String salesOrgCode = System.Label.Grz_PolandSalesOrgCode;
        System.debug('distributor : '+distributor);
        //System.debug('distributorName : '+distributorName);
        System.debug('year : '+year);
        System.debug('skuList : '+skuList);
        Date start_date = Date.newInstance(Integer.valueOf(year), 4, 1); 
        System.debug('start_date : '+start_date);
        System.debug('quarter : '+quarter);
        Id rec_type = Schema.SObjectType.Liquidation2__c.getRecordTypeInfosByName().get('Multi Country').getRecordTypeId();
        System.debug('rec type '+rec_type);
        String query = 'SELECT SKU__r.Brand_Name__c,SKU__r.SKU_Code__c,SKU__r.SKU_Description__c,Sum(Opening_Inventory2__r.Opening_Inventory__c),Sum(Opening_Inventory2__r.Opening_Inventory_PLN__c),Sum(YTD_Sales_Poland__c),Sum(YTD_Sales_Poland_PLN__c),Sum(Total_Available_Stock__c),Sum(Total_Available_Stock_PLN__c),Sum(Distributors_Inventory__c),Sum(Distributors_Inventory_PLN__c),Sum(Liquidation_YTD__c),Sum(Liquidation_PLN__c),Sum(Liquidation_Percent_YTD__c) FROM Liquidation2__c where ';
       
        if(null != distributor && !distributor.isEmpty()){
           query +=  'Distributor__c in : distributor and ';
        }
        
        if(null != skuList && !skuList.isEmpty()){
            query += 'SKU__c in : skuList and ';
        }
        
        if(search != null && search != ''){
            query += '(SKU__r.SKU_Code__c like \'%'+search+'%\' OR SKU__r.Brand_Name__c like \'%'+search+'%\' OR SKU__r.SKU_Description__c like \'%'+search+'%\') and ' ;
        }
        
        System.debug('query : '+query);
                       
        query += 'Liquidation_Annual_Plan__r.Fiscal_Start_Date__c =: start_date and Quarter__c =: quarter and SKU__r.Active_for_Liquidation__c = true and Liquidation_Annual_Plan__r.Sales_Org__r.Sales_Org_Code__c =: salesOrgCode and RecordTypeId=:rec_type group by SKU__r.SKU_Description__c,SKU__r.SKU_Code__c,SKU__r.Brand_Name__c ';
        
        if(excludeDisInventory){
            query += 'HAVING Sum(Distributors_Inventory__c) != 0 ';
        }
		
		query += 'Order by SKU__r.SKU_Code__c';
        
        System.debug('query : '+query);
        List<POGDataWrapperData> POGWrapDataList = new List<POGDataWrapperData>();
        
         map<String,list<String>> mapping = new map<String,list<String>>();
    
        list<String> list_Brand = new list<String>();
        list<String> list_SKU_Code = new list<String>();
        list<String> list_SKU_Description = new list<String>();
        list<String> list_Opening_inventory = new list<String>();
        list<String> list_Opening_inventory_PLN = new list<String>();
        list<String> list_YTD_sales = new list<String>();
        list<String> list_YTD_sales_PLN = new list<String>();
        list<String> list_Total_Available_Stock = new list<String>();
        list<String> list_Total_Available_Stock_PLN = new list<String>();
        list<String> list_Distributor_Inventory = new list<String>();
        list<String> list_Distributor_Inventory_PLN = new list<String>();
        list<String> list_Liquidation_YTD = new list<String>();
        list<String> list_Liquidation_PLN = new list<String>();
        list<String> list_Liquidation_YTD_per_plan_YTD = new list<String>();
        
        for (AggregateResult result : Database.query(query)){
            
            POGDataWrapperData obj = new POGDataWrapperData();
            obj.Brand = String.valueOf(result.get('Brand_Name__c'));
            String skuStr = String.valueOf(result.get('SKU_Code__c'));
            obj.SKU_Code = skuStr.replaceFirst('^0+','');
            //obj.SKU_Code = String.valueOf(result.get('SKU_Code__c'));
            obj.SKU_Description = String.valueOf(result.get('SKU_Description__c'));
            obj.Opening_inventory =  String.valueOf(((Decimal)(result.get('expr0'))).setScale(0).format());
            obj.Opening_inventory_PLN =  String.valueOf(((Decimal)(result.get('expr1'))).setScale(0).format());
            obj.YTD_sales =  String.valueOf(((Decimal)(result.get('expr2'))).setScale(0).format());
            obj.YTD_sales_PLN =  String.valueOf(((Decimal)(result.get('expr3'))).setScale(0).format());
            obj.Total_Available_Stock =  String.valueOf(((Decimal)(result.get('expr4'))).setScale(0).format());
            obj.Total_Available_Stock_PLN = String.valueOf(((Decimal)(result.get('expr5'))).setScale(0).format());
            obj.Distributor_Inventory = String.valueOf(((Decimal)(result.get('expr6'))).setScale(0).format());
            obj.Distributor_Inventory_PLN = String.valueOf(((Decimal)(result.get('expr7'))).setScale(0).format());
            obj.Liquidation_YTD = String.valueOf(((Decimal)(result.get('expr8'))).setScale(0).format());
            obj.Liquidation_PLN = String.valueOf(((Decimal)(result.get('expr9'))).setScale(0).format());
            //obj.Liquidation_YTD_per_plan_YTD = String.valueOf(result.get('expr10'));
            String tas = String.valueOf(result.get('expr5'));
            String liq = String.valueOf(result.get('expr9'));
            if(decimal.valueof(tas) != 0){
                System.debug('tas : '+ decimal.valueof(tas));
                System.debug('liq '+ decimal.valueof(liq));
                Decimal percentage = decimal.valueof(liq)/decimal.valueof(tas) * 100;
            	obj.Liquidation_YTD_per_plan_YTD = String.valueOf(percentage.setScale(0));
            }else{
                obj.Liquidation_YTD_per_plan_YTD = '0';
            }
            POGWrapDataList.add(obj);
            
            list_Brand.add(obj.Brand);
            list_SKU_Code.add(obj.SKU_Code);
            if(obj.SKU_Description != null && obj.SKU_Description != ''){
                list_SKU_Description.add(obj.SKU_Description);
            }else{
                list_SKU_Description.add('');
            }
            list_Opening_inventory.add(obj.Opening_inventory);
            list_Opening_inventory_PLN.add(obj.Opening_inventory_PLN);
            list_YTD_sales.add(obj.YTD_sales);
            list_YTD_sales_PLN.add(obj.YTD_sales_PLN);
            list_Total_Available_Stock.add(obj.Total_Available_Stock);
            list_Total_Available_Stock_PLN.add(obj.Total_Available_Stock_PLN);
            list_Distributor_Inventory.add(obj.Distributor_Inventory);
            list_Distributor_Inventory_PLN.add(obj.Distributor_Inventory_PLN);
            list_Liquidation_YTD.add(obj.Liquidation_YTD);
            list_Liquidation_PLN.add(obj.Liquidation_PLN);
            list_Liquidation_YTD_per_plan_YTD.add(obj.Liquidation_YTD_per_plan_YTD);
            System.debug('result==>'+result);
            //System.debug('result==>'+result.get('SKU_Code__c'));                   
        }     
        
        VFData data = new VFData();
        
        mapping.put(System.Label.Brand,list_Brand);
        mapping.put(System.Label.SKU_Code,list_SKU_Code);
        mapping.put(System.Label.SKU_Description,list_SKU_Description);
        mapping.put(System.Label.Opening_Inventory,list_Opening_inventory);
        mapping.put(System.Label.Grz_OpeningInventoryPLN,list_Opening_inventory_PLN);
        mapping.put(System.Label.YTD_sales,list_YTD_sales);
        mapping.put(System.Label.Grz_YTD_Sales,list_YTD_sales_PLN);
        mapping.put(System.Label.Total_Available_Stock,list_Total_Available_Stock);
        mapping.put(System.Label.Grz_TotalAvailableStockPLN,list_Total_Available_Stock_PLN);
        mapping.put(System.Label.Distributor_Inventory,list_Distributor_Inventory);
        mapping.put(System.Label.Grz_DistributorInventoryPLN,list_Distributor_Inventory_PLN);
        mapping.put(System.Label.Liquidation_YTD_Selected_Quarter,list_Liquidation_YTD);
        mapping.put(System.Label.Grz_Liquidation_YTDSelectedQuarterPLN,list_Liquidation_PLN);
        mapping.put(System.Label.Liquidation_YTD_Selected_Quarter_Percent,list_Liquidation_YTD_per_plan_YTD);
        
        data.mapping = mapping;
        return data;
    }
    
    /* -- */
    
    @AuraEnabled
    public static List<POGDataWrapperData> getPOGLiquidationReportDataBrand(List<String> distributor,String year, String quarter, List<String> brandList,Boolean excludeDisInventory){
        POGResultWrapper rwObj = new  POGResultWrapper();
        String salesOrgCode = System.Label.Grz_PolandSalesOrgCode;
        System.debug('distributor : '+distributor);
        //System.debug('distributorName : '+distributorName);
        System.debug('year : '+year);
        System.debug('brandList : '+brandList);
        Date start_date = Date.newInstance(Integer.valueOf(year), 4, 1); 
        System.debug('start_date : '+start_date);
        System.debug('quarter : '+quarter);
        Id rec_type = Schema.SObjectType.Liquidation2__c.getRecordTypeInfosByName().get('Multi Country').getRecordTypeId();
        System.debug('rec type '+rec_type);
        String query = 'SELECT SKU__r.Brand_Name__c,Sum(Opening_Inventory2__r.Opening_Inventory__c),Sum(Opening_Inventory2__r.Opening_Inventory_PLN__c),Sum(YTD_Sales_Poland__c),Sum(YTD_Sales_Poland_PLN__c),Sum(Total_Available_Stock__c),Sum(Total_Available_Stock_PLN__c),Sum(Distributors_Inventory__c),Sum(Distributors_Inventory_PLN__c),Sum(Liquidation_YTD__c),Sum(Liquidation_PLN__c),Avg(Liquidation_Percent_YTD__c) FROM Liquidation2__c where ';
        
        
        if(null != distributor && !distributor.isEmpty()){
           query +=  'Distributor__c in : distributor and ';
        }
        
        if(null != brandList && !brandList.isEmpty()){
            query += 'SKU__r.Brand_Name__c in : brandList and ';
        }
        
        System.debug('query : '+query);
                 
        query += 'Liquidation_Annual_Plan__r.Fiscal_Start_Date__c =: start_date and Quarter__c =: quarter and SKU__r.Active_for_Liquidation__c = true and Liquidation_Annual_Plan__r.Sales_Org__r.Sales_Org_Code__c =: salesOrgCode and RecordTypeId=:rec_type group by SKU__r.Brand_Name__c';
        
        if(excludeDisInventory){
            query += ' HAVING Sum(Distributors_Inventory__c) != 0';
        }
        
        System.debug('query : '+query);
        List<POGDataWrapperData> POGWrapDataList = new List<POGDataWrapperData>();
        
        for (AggregateResult result : Database.query(query)){
            //system.debug('result.get(\'expr0\')==>'+result.get('expr0'));
            //system.debug('(Decimal)(result.get(\'expr0\'))==>'+(Decimal)(result.get('expr0')));
            //system.debug('((Decimal)(result.get(\'expr0\'))).format()==>'+((Decimal)(result.get('expr0'))).format());
            POGDataWrapperData obj = new POGDataWrapperData();
            obj.Brand = String.valueOf(result.get('Brand_Name__c'));
              /* ------------Start GRZ(Butesh Singla) : APPS-1395 PO And Delivery Date :05-06-2022 */  
            obj.Opening_inventory = String.valueOf(((Decimal)(result.get('expr0'))).setScale(0).format());
            obj.Opening_inventory_PLN = String.valueOf(((Decimal)(result.get('expr1'))).setScale(0).format());
            obj.YTD_sales = String.valueOf(((Decimal)(result.get('expr2'))).setScale(0).format());
            obj.YTD_sales_PLN = String.valueOf(((Decimal)(result.get('expr3'))).setScale(0).format());
            obj.Total_Available_Stock = String.valueOf(((Decimal)(result.get('expr4'))).setScale(0).format());
            obj.Total_Available_Stock_PLN = String.valueOf(((Decimal)(result.get('expr5'))).setScale(0).format());
            obj.Distributor_Inventory = String.valueOf(((Decimal)(result.get('expr6'))).setScale(0).format());
            obj.Distributor_Inventory_PLN = String.valueOf(((Decimal)(result.get('expr7'))).setScale(0).format());
            obj.Liquidation_YTD = String.valueOf(((Decimal)(result.get('expr8'))).setScale(0).format());
            obj.Liquidation_PLN = String.valueOf(((Decimal)(result.get('expr9'))).setScale(0).format());
            //obj.Liquidation_YTD_per_plan_YTD = String.valueOf(result.get('expr10'));
            String tas = String.valueOf(result.get('expr5'));
            String liq = String.valueOf(result.get('expr9'));
            if(decimal.valueof(tas) != 0){
                System.debug('tas : '+ decimal.valueof(tas));
                System.debug('liq '+ decimal.valueof(liq));
                Decimal percentage = decimal.valueof(liq)/decimal.valueof(tas) * 100;
            	obj.Liquidation_YTD_per_plan_YTD = String.valueOf(percentage.setScale(0));
            }else{
                obj.Liquidation_YTD_per_plan_YTD = '0';
            }  
            /* -- */
            POGWrapDataList.add(obj);
            System.debug('result==>'+result);
            //System.debug('result==>'+result.get('SKU_Code__c'));                   
        }       
        System.debug('POGWrapDataList : '+POGWrapDataList);
        rwObj.POGWrapDataList = POGWrapDataList;
        System.debug('rwObj : '+rwObj);
        return POGWrapDataList;
    }
    
    /* ------------Start GRZ(Dheeraj Sharma) : APPS-1395 PO And Delivery Date :05-06-2022 */  
        @AuraEnabled
    public static VFData getPOGLiquidationReportDataBrandForVF(List<String> distributor,String year, String quarter, List<String> brandList,Boolean excludeDisInventory,string search){
        POGResultWrapper rwObj = new  POGResultWrapper();
        String salesOrgCode = System.Label.Grz_PolandSalesOrgCode;
        System.debug('distributor : '+distributor);
        //System.debug('distributorName : '+distributorName);
        System.debug('year : '+year);
        System.debug('brandList : '+brandList);
        Date start_date = Date.newInstance(Integer.valueOf(year), 4, 1); 
        System.debug('start_date : '+start_date);
        System.debug('quarter : '+quarter);
        Id rec_type = Schema.SObjectType.Liquidation2__c.getRecordTypeInfosByName().get('Multi Country').getRecordTypeId();
        System.debug('rec type '+rec_type);
        String query = 'SELECT SKU__r.Brand_Name__c,Sum(Opening_Inventory2__r.Opening_Inventory__c),Sum(Opening_Inventory2__r.Opening_Inventory_PLN__c),Sum(YTD_Sales_Poland__c),Sum(YTD_Sales_Poland_PLN__c),Sum(Total_Available_Stock__c),Sum(Total_Available_Stock_PLN__c),Sum(Distributors_Inventory__c),Sum(Distributors_Inventory_PLN__c),Sum(Liquidation_YTD__c),Sum(Liquidation_PLN__c),Avg(Liquidation_Percent_YTD__c) FROM Liquidation2__c where ';
        
        
        if(null != distributor && !distributor.isEmpty()){
           query +=  'Distributor__c in : distributor and ';
        }
        
        if(null != brandList && !brandList.isEmpty()){
            query += 'SKU__r.Brand_Name__c in : brandList and ';
        }
        
        if(search != null && search != ''){
            query += '(SKU__r.Brand_Name__c like \'%'+search+'%\') and ' ;
        }
        
        System.debug('query : '+query);
                 
        query += 'Liquidation_Annual_Plan__r.Fiscal_Start_Date__c =: start_date and Quarter__c =: quarter and SKU__r.Active_for_Liquidation__c = true and Liquidation_Annual_Plan__r.Sales_Org__r.Sales_Org_Code__c =: salesOrgCode and RecordTypeId=:rec_type group by SKU__r.Brand_Name__c';
        
        if(excludeDisInventory){
            query += ' HAVING Sum(Distributors_Inventory__c) != 0';
        }
       
        System.debug('query : '+query);
       
        List<POGDataWrapperData> POGWrapDataList = new List<POGDataWrapperData>();
        
          map<String,list<String>> mapping = new map<String,list<String>>();
    
        list<String> list_Brand = new list<String>();
        //list<String> list_SKU_Code = new list<String>();
       // list<String> list_SKU_Description = new list<String>();
        list<String> list_Opening_inventory = new list<String>();
        list<String> list_Opening_inventory_PLN = new list<String>();
        list<String> list_YTD_sales = new list<String>();
        list<String> list_YTD_sales_PLN = new list<String>();
        list<String> list_Total_Available_Stock = new list<String>();
        list<String> list_Total_Available_Stock_PLN = new list<String>();
        list<String> list_Distributor_Inventory = new list<String>();
        list<String> list_Distributor_Inventory_PLN = new list<String>();
        list<String> list_Liquidation_YTD = new list<String>();
        list<String> list_Liquidation_PLN = new list<String>();
        list<String> list_Liquidation_YTD_per_plan_YTD = new list<String>();
        
        
        for (AggregateResult result : Database.query(query)){
            //system.debug('result.get(\'expr0\')==>'+result.get('expr0'));
            //system.debug('(Decimal)(result.get(\'expr0\'))==>'+(Decimal)(result.get('expr0')));
            //system.debug('((Decimal)(result.get(\'expr0\'))).format()==>'+((Decimal)(result.get('expr0'))).format());
            POGDataWrapperData obj = new POGDataWrapperData();
            obj.Brand = String.valueOf(result.get('Brand_Name__c'));
            obj.Opening_inventory = String.valueOf(((Decimal)(result.get('expr0'))).setScale(0).format());
            obj.Opening_inventory_PLN = String.valueOf(((Decimal)(result.get('expr1'))).setScale(0).format());
            obj.YTD_sales = String.valueOf(((Decimal)(result.get('expr2'))).setScale(0).format());
            obj.YTD_sales_PLN = String.valueOf(((Decimal)(result.get('expr3'))).setScale(0).format());
            obj.Total_Available_Stock = String.valueOf(((Decimal)(result.get('expr4'))).setScale(0).format());
            obj.Total_Available_Stock_PLN = String.valueOf(((Decimal)(result.get('expr5'))).setScale(0).format());
            obj.Distributor_Inventory = String.valueOf(((Decimal)(result.get('expr6'))).setScale(0).format());
            obj.Distributor_Inventory_PLN = String.valueOf(((Decimal)(result.get('expr7'))).setScale(0).format());
            obj.Liquidation_YTD = String.valueOf(((Decimal)(result.get('expr8'))).setScale(0).format());
            obj.Liquidation_PLN = String.valueOf(((Decimal)(result.get('expr9'))).setScale(0).format());
            //obj.Liquidation_YTD_per_plan_YTD = String.valueOf(result.get('expr10'));
            String tas = String.valueOf(result.get('expr5'));
            String liq = String.valueOf(result.get('expr9'));
            if(decimal.valueof(tas) != 0){
                System.debug('tas : '+ decimal.valueof(tas));
                System.debug('liq '+ decimal.valueof(liq));
                Decimal percentage = decimal.valueof(liq)/decimal.valueof(tas) * 100;
            	obj.Liquidation_YTD_per_plan_YTD = String.valueOf(percentage.setScale(0));
            }else{
                obj.Liquidation_YTD_per_plan_YTD = '0';
            }            
            POGWrapDataList.add(obj);
            
             list_Brand.add(obj.Brand);
            //list_SKU_Code.add(obj.SKU_Code);
            //list_SKU_Description.add(obj.SKU_Description);
            list_Opening_inventory.add(obj.Opening_inventory);
            list_Opening_inventory_PLN.add(obj.Opening_inventory_PLN);
            list_YTD_sales.add(obj.YTD_sales);
            list_YTD_sales_PLN.add(obj.YTD_sales_PLN);
            list_Total_Available_Stock.add(obj.Total_Available_Stock);
            list_Total_Available_Stock_PLN.add(obj.Total_Available_Stock_PLN);
            list_Distributor_Inventory.add(obj.Distributor_Inventory);
            list_Distributor_Inventory_PLN.add(obj.Distributor_Inventory_PLN);
            list_Liquidation_YTD.add(obj.Liquidation_YTD);
            list_Liquidation_PLN.add(obj.Liquidation_PLN);
            list_Liquidation_YTD_per_plan_YTD.add(obj.Liquidation_YTD_per_plan_YTD);
            System.debug('result==>'+result);
            
            System.debug('result==>'+result);
            //System.debug('result==>'+result.get('SKU_Code__c'));                   
        }       
         VFData data = new VFData();
        
        mapping.put(System.Label.Brand,list_Brand);
        //mapping.put(System.Label.SKU_Code,list_SKU_Code);
        //mapping.put(System.Label.SKU_Description,list_SKU_Description);
        mapping.put(System.Label.Opening_Inventory,list_Opening_inventory);
        mapping.put(System.Label.Grz_OpeningInventoryPLN,list_Opening_inventory_PLN);
        mapping.put(System.Label.YTD_sales,list_YTD_sales);
        mapping.put(System.Label.Grz_YTD_Sales,list_YTD_sales_PLN);
        mapping.put(System.Label.Total_Available_Stock,list_Total_Available_Stock);
        mapping.put(System.Label.Grz_TotalAvailableStockPLN,list_Total_Available_Stock_PLN);
        mapping.put(System.Label.Distributor_Inventory,list_Distributor_Inventory);
        mapping.put(System.Label.Grz_DistributorInventoryPLN,list_Distributor_Inventory_PLN);
        mapping.put(System.Label.Liquidation_YTD_Selected_Quarter,list_Liquidation_YTD);
        mapping.put(System.Label.Grz_Liquidation_YTDSelectedQuarterPLN,list_Liquidation_PLN);
        mapping.put(System.Label.Liquidation_YTD_Selected_Quarter_Percent,list_Liquidation_YTD_per_plan_YTD);
        
        data.mapping = mapping;
        return data;
    }

    /* -- */
    
    public static List<POGDataWrapperData> getDependentSKUDec(List<String> brandList){
        List<POGDataWrapperData> dependentSKUDeclist = new List<POGDataWrapperData>();
        String salesOrgCode = System.Label.Grz_PolandSalesOrgCode;
		if(null != brandList && !brandList.isEmpty()){
            List<SKU__c> skuList = [SELECT Id, sku_code__c,SKU_Description__c FROM SKU__c where Brand_Name__c in : brandList and Sales_Org_Code__c =: salesOrgCode and Active_for_Liquidation__c = true];
            for(SKU__c sku : skuList){
                POGDataWrapperData obj = new POGDataWrapperData();
                obj.id = sku.Id;
                obj.SKU_Description = sku.SKU_Description__c;
                dependentSKUDeclist.add(obj);
            }
        }	        
        return dependentSKUDeclist;
    }
    
    @AuraEnabled(cacheable = true)
    public static Boolean checkPriceloaded(String year){
        Boolean isPriceLoaded = false;
        Date start_date = Date.newInstance(Integer.valueOf(year), 4, 1); 
        String salesOrgCode=System.Label.Grz_PolandSalesOrgCode;
        Id rec_type = Schema.SObjectType.Opening_Inventory2__c.getRecordTypeInfosByName().get('Multi Country').getRecordTypeId();
        List<Opening_Inventory2__c> oiList = new List<Opening_Inventory2__c >();
        oiList = [Select Id,SKU__r.SKU_Code__c,SKU_Price_Poland__c from Opening_Inventory2__c where SKU_Price_Poland__c > 0 and SKU__r.Active_for_Liquidation__c = true and Liquidation_Annual_Plan__r.Fiscal_Start_Date__c=:start_date and Liquidation_Annual_Plan__r.Sales_Org__r.Sales_Org_Code__c =: salesOrgCode  and RecordTypeId=:rec_type limit 1];        
        if(oiList.size()>0){
            isPriceLoaded = true;
        }
        System.debug('isPriceLoaded : '+isPriceLoaded);
        return isPriceLoaded;
 
        
    }
    
    
    @AuraEnabled
    public static POGResultWrapper getPOGLiquidationReportDataCustomer(List<String> distributor,String year, String quarter, List<String> skuList,List<String> brandList,Boolean excludeDisInventory){
        POGResultWrapper rwObj = new  POGResultWrapper();
        String salesOrgCode = System.Label.Grz_PolandSalesOrgCode;
        System.debug('distributor : '+distributor);
        //System.debug('distributorName : '+distributorName);
        System.debug('year : '+year);
        System.debug('skuList : '+skuList);
        System.debug('brandList : '+brandList);
        Date start_date = Date.newInstance(Integer.valueOf(year), 4, 1); 
        System.debug('start_date : '+start_date);
        System.debug('quarter : '+quarter);
        Id rec_type = Schema.SObjectType.Liquidation2__c.getRecordTypeInfosByName().get('Multi Country').getRecordTypeId();
        System.debug('rec type '+rec_type);
        String query = 'SELECT Distributor__c,Distributor__r.name,Sum(Opening_Inventory2__r.Opening_Inventory__c),Sum(Opening_Inventory2__r.Opening_Inventory_PLN__c),Sum(YTD_Sales_Poland__c),Sum(YTD_Sales_Poland_PLN__c),Sum(Total_Available_Stock__c),Sum(Total_Available_Stock_PLN__c),Sum(Distributors_Inventory__c),Sum(Distributors_Inventory_PLN__c),Sum(Liquidation_YTD__c),Sum(Liquidation_PLN__c),Sum(Liquidation_Percent_YTD__c) FROM Liquidation2__c where ';
        
        /*if(excludeDisInventory){
            query += 'Distributors_Inventory__c != null and Distributors_Inventory__c != 0 and ';
        }*/
        
        if(null != distributor && !distributor.isEmpty()){
           query +=  'Distributor__c in : distributor and ';
        }
        
        if(null != brandList && !brandList.isEmpty()){
            query += 'SKU__r.Brand_Name__c in : brandList and ';
        }
        
        if(null != skuList && !skuList.isEmpty()){
            query += 'SKU__c in : skuList and ';
        }
        
        System.debug('query : '+query);
                 
        query += 'Liquidation_Annual_Plan__r.Fiscal_Start_Date__c =: start_date and Quarter__c =: quarter and SKU__r.Active_for_Liquidation__c = true and Liquidation_Annual_Plan__r.Sales_Org__r.Sales_Org_Code__c =: salesOrgCode and RecordTypeId=:rec_type group by Distributor__c,Distributor__r.name';
        
        if(excludeDisInventory){
            query += ' HAVING Sum(Distributors_Inventory__c) != 0';
        }
        
        System.debug('query : '+query);
        List<POGDataWrapperData> POGWrapDataList = new List<POGDataWrapperData>();
        
       
        
        
        for (AggregateResult result : Database.query(query)){
            
            POGDataWrapperData obj = new POGDataWrapperData();
            obj.Id = String.valueOf(result.get('Distributor__c'));
            obj.Brand = String.valueOf(result.get('name'));
              /* ------------Start GRZ(Butesh Singla) : APPS-1395 PO And Delivery Date :05-06-2022 */  
            obj.Opening_inventory = String.valueOf(((Decimal)(result.get('expr0'))).setScale(0).format());
            obj.Opening_inventory_PLN = String.valueOf(((Decimal)(result.get('expr1'))).setScale(0).format());
            obj.YTD_sales = String.valueOf(((Decimal)(result.get('expr2'))).setScale(0).format());
            obj.YTD_sales_PLN = String.valueOf(((Decimal)(result.get('expr3'))).setScale(0).format());
            obj.Total_Available_Stock = String.valueOf(((Decimal)(result.get('expr4'))).setScale(0).format());
            obj.Total_Available_Stock_PLN = String.valueOf(((Decimal)(result.get('expr5'))).setScale(0).format());
            obj.Distributor_Inventory =String.valueOf(((Decimal)(result.get('expr6'))).setScale(0).format());
            obj.Distributor_Inventory_PLN = String.valueOf(((Decimal)(result.get('expr7'))).setScale(0).format());
            obj.Liquidation_YTD = String.valueOf(((Decimal)(result.get('expr8'))).setScale(0).format());
            obj.Liquidation_PLN = String.valueOf(((Decimal)(result.get('expr9'))).setScale(0).format());
            //obj.Liquidation_YTD_per_plan_YTD = String.valueOf(result.get('expr10'));
            String tas = String.valueOf(result.get('expr5'));
            String liq = String.valueOf(result.get('expr9'));
            if(decimal.valueof(tas) != 0){
                System.debug('tas : '+ decimal.valueof(tas));
                System.debug('liq '+ decimal.valueof(liq));
                Decimal percentage = decimal.valueof(liq)/decimal.valueof(tas) * 100;
            	obj.Liquidation_YTD_per_plan_YTD = String.valueOf(percentage.setScale(0));
            }else{
                obj.Liquidation_YTD_per_plan_YTD = '0';
            }
            /* -- */
            POGWrapDataList.add(obj);
            
            System.debug('result==>'+result);
        }
        
       
        
        System.debug('POGWrapDataList : '+POGWrapDataList);
        rwObj.POGWrapDataList = POGWrapDataList;
        rwObj.POGSkuDepnedentList = Grz_POGLiquidationReportController.getDependentSKUDec(brandList);
        System.debug('rwObj : '+rwObj);
        return rwObj;
    }
    
    /* ------------Start GRZ(Butesh Singla) : APPS-1395 PO And Delivery Date :05-06-2022 */  
    @AuraEnabled
    public static VFData getPOGLiquidationReportDataCustomerforVF(List<String> distributor,String year, String quarter, List<String> skuList,List<String> brandList,Boolean excludeDisInventory,string search){
        POGResultWrapper rwObj = new  POGResultWrapper();
        String salesOrgCode = System.Label.Grz_PolandSalesOrgCode;
        System.debug('distributor : '+distributor);
        //System.debug('distributorName : '+distributorName);
        System.debug('year : '+year);
        System.debug('skuList : '+skuList);
        System.debug('brandList : '+brandList);
        Date start_date = Date.newInstance(Integer.valueOf(year), 4, 1); 
        System.debug('start_date : '+start_date);
        System.debug('quarter : '+quarter);
        Id rec_type = Schema.SObjectType.Liquidation2__c.getRecordTypeInfosByName().get('Multi Country').getRecordTypeId();
        System.debug('rec type '+rec_type);
        String query = 'SELECT Distributor__c,Distributor__r.name,Sum(Opening_Inventory2__r.Opening_Inventory__c),Sum(Opening_Inventory2__r.Opening_Inventory_PLN__c),Sum(YTD_Sales_Poland__c),Sum(YTD_Sales_Poland_PLN__c),Sum(Total_Available_Stock__c),Sum(Total_Available_Stock_PLN__c),Sum(Distributors_Inventory__c),Sum(Distributors_Inventory_PLN__c),Sum(Liquidation_YTD__c),Sum(Liquidation_PLN__c),Sum(Liquidation_Percent_YTD__c) FROM Liquidation2__c where ';
        
        /*if(excludeDisInventory){
            query += 'Distributors_Inventory__c != null and Distributors_Inventory__c != 0 and ';
        }*/
        
        if(null != distributor && !distributor.isEmpty()){
           query +=  'Distributor__c in : distributor and ';
        }
        
        if(null != brandList && !brandList.isEmpty()){
            query += 'SKU__r.Brand_Name__c in : brandList and ';
        }
        if(search != null && search != ''){
            query += 'Distributor__r.name like \'%'+search+'%\' and ' ;
        }
        
        if(null != skuList && !skuList.isEmpty()){
            query += 'SKU__c in : skuList and ';
        }
        
        System.debug('query : '+query);
                 
        query += 'Liquidation_Annual_Plan__r.Fiscal_Start_Date__c =: start_date and Quarter__c =: quarter and SKU__r.Active_for_Liquidation__c = true and Liquidation_Annual_Plan__r.Sales_Org__r.Sales_Org_Code__c =: salesOrgCode and RecordTypeId=:rec_type group by Distributor__c,Distributor__r.name';
        
        if(excludeDisInventory){
            query += ' HAVING Sum(Distributors_Inventory__c) != 0';
        }
        
        System.debug('query : '+query);
        List<POGDataWrapperData> POGWrapDataList = new List<POGDataWrapperData>();
        
         map<String,list<String>> mapping = new map<String,list<String>>();
    
        list<String> list_Brand = new list<String>();
        //list<String> list_SKU_Code = new list<String>();
        //list<String> list_SKU_Description = new list<String>();
        list<String> list_Opening_inventory = new list<String>();
        list<String> list_Opening_inventory_PLN = new list<String>();
        list<String> list_YTD_sales = new list<String>();
        list<String> list_YTD_sales_PLN = new list<String>();
        list<String> list_Total_Available_Stock = new list<String>();
        list<String> list_Total_Available_Stock_PLN = new list<String>();
        list<String> list_Distributor_Inventory = new list<String>();
        list<String> list_Distributor_Inventory_PLN = new list<String>();
        list<String> list_Liquidation_YTD = new list<String>();
        list<String> list_Liquidation_PLN = new list<String>();
        list<String> list_Liquidation_YTD_per_plan_YTD = new list<String>();
        
        
        for (AggregateResult result : Database.query(query)){
            
            POGDataWrapperData obj = new POGDataWrapperData();
            obj.Id = String.valueOf(result.get('Distributor__c'));
            obj.Brand = String.valueOf(result.get('name'));
            obj.Opening_inventory = String.valueOf(((Decimal)(result.get('expr0'))).setScale(0).format());
            obj.Opening_inventory_PLN = String.valueOf(((Decimal)(result.get('expr1'))).setScale(0).format());
            obj.YTD_sales = String.valueOf(((Decimal)(result.get('expr2'))).setScale(0).format());
            obj.YTD_sales_PLN = String.valueOf(((Decimal)(result.get('expr3'))).setScale(0).format());
            obj.Total_Available_Stock = String.valueOf(((Decimal)(result.get('expr4'))).setScale(0).format());
            obj.Total_Available_Stock_PLN = String.valueOf(((Decimal)(result.get('expr5'))).setScale(0).format());
            obj.Distributor_Inventory =String.valueOf(((Decimal)(result.get('expr6'))).setScale(0).format());
            obj.Distributor_Inventory_PLN = String.valueOf(((Decimal)(result.get('expr7'))).setScale(0).format());
            obj.Liquidation_YTD = String.valueOf(((Decimal)(result.get('expr8'))).setScale(0).format());
            obj.Liquidation_PLN = String.valueOf(((Decimal)(result.get('expr9'))).setScale(0).format());
            //obj.Liquidation_YTD_per_plan_YTD = String.valueOf(result.get('expr10'));
            String tas = String.valueOf(result.get('expr5'));
            String liq = String.valueOf(result.get('expr9'));
            if(decimal.valueof(tas) != 0){
                System.debug('tas : '+ decimal.valueof(tas));
                System.debug('liq '+ decimal.valueof(liq));
                Decimal percentage = decimal.valueof(liq)/decimal.valueof(tas) * 100;
            	obj.Liquidation_YTD_per_plan_YTD = String.valueOf(percentage.setScale(0));
            }else{
                obj.Liquidation_YTD_per_plan_YTD = '0';
            }
            POGWrapDataList.add(obj);
            
            list_Brand.add(obj.Brand);
            //list_SKU_Code.add(obj.SKU_Code);
            //list_SKU_Description.add(obj.SKU_Description);
            list_Opening_inventory.add(obj.Opening_inventory);
            list_Opening_inventory_PLN.add(obj.Opening_inventory_PLN);
            list_YTD_sales.add(obj.YTD_sales);
            list_YTD_sales_PLN.add(obj.YTD_sales_PLN);
            list_Total_Available_Stock.add(obj.Total_Available_Stock);
            list_Total_Available_Stock_PLN.add(obj.Total_Available_Stock_PLN);
            list_Distributor_Inventory.add(obj.Distributor_Inventory);
            list_Distributor_Inventory_PLN.add(obj.Distributor_Inventory_PLN);
            list_Liquidation_YTD.add(obj.Liquidation_YTD);
            list_Liquidation_PLN.add(obj.Liquidation_PLN);
            list_Liquidation_YTD_per_plan_YTD.add(obj.Liquidation_YTD_per_plan_YTD);
            
            System.debug('result==>'+result);
        }
        
       
        
         VFData data = new VFData();
        
        mapping.put(System.Label.Distributor,list_Brand);
        //mapping.put(System.Label.SKU_Code,list_SKU_Code);
        //mapping.put(System.Label.SKU_Description,list_SKU_Description);
        mapping.put(System.Label.Opening_Inventory,list_Opening_inventory);
        mapping.put(System.Label.Grz_OpeningInventoryPLN,list_Opening_inventory_PLN);
        mapping.put(System.Label.YTD_sales,list_YTD_sales);
        mapping.put(System.Label.Grz_YTD_Sales,list_YTD_sales_PLN);
        mapping.put(System.Label.Total_Available_Stock,list_Total_Available_Stock);
        mapping.put(System.Label.Grz_TotalAvailableStockPLN,list_Total_Available_Stock_PLN);
        mapping.put(System.Label.Distributor_Inventory,list_Distributor_Inventory);
        mapping.put(System.Label.Grz_DistributorInventoryPLN,list_Distributor_Inventory_PLN);
        mapping.put(System.Label.Liquidation_YTD_Selected_Quarter,list_Liquidation_YTD);
        mapping.put(System.Label.Grz_Liquidation_YTDSelectedQuarterPLN,list_Liquidation_PLN);
        mapping.put(System.Label.Liquidation_YTD_Selected_Quarter_Percent,list_Liquidation_YTD_per_plan_YTD);
        
        data.mapping = mapping;
        return data;
    }
    
    /* -- */
    
    public class POGDataWrapperData {
        @AuraEnabled
        public String Id { get; set; }
        @AuraEnabled
        public String Brand { get; set; }
        @AuraEnabled
        public String SKU_Code { get; set; }
        @AuraEnabled
        public String SKU_Description { get; set; }
        @AuraEnabled
        public String Opening_inventory { get; set; }
        @AuraEnabled
        public String Opening_inventory_PLN { get; set; }
        @AuraEnabled
        public String YTD_sales { get; set; }
        @AuraEnabled
        public String YTD_sales_PLN { get; set; }
        @AuraEnabled
        public String Total_Available_Stock { get; set; }
        @AuraEnabled
        public String Total_Available_Stock_PLN { get; set; }
        @AuraEnabled
        public String Distributor_Inventory { get; set; }
        @AuraEnabled
        public String Distributor_Inventory_PLN { get; set; }
        @AuraEnabled
        public String Liquidation_YTD { get; set; }
        @AuraEnabled
        public String Liquidation_PLN { get; set; }
        @AuraEnabled
        public String Liquidation_YTD_per_plan_YTD { get; set; }
    }
    
    public class POGResultWrapper {
        @AuraEnabled
        public List<POGDataWrapperData> POGWrapDataList {get; set;}
        @AuraEnabled
        public List<POGDataWrapperData> POGSkuDepnedentList {get; set;}
    }
    
      /* ------------Start GRZ(Butesh Singla) : APPS-1395 PO And Delivery Date :05-06-2022 */  
    public class VFData {
        @AuraEnabled
        public map<String,list<String>> mapping { get; set; }
       // @AuraEnabled
       // public map<String,list<String>> map_Brand { get; set; }
       // @AuraEnabled
      //  public map<String,list<String>> map_SKU_Code { get; set; }
      //  @AuraEnabled
      //  public map<String,list<String>> map_SKU_Description { get; set; }
      //  @AuraEnabled
       // public map<String,list<String>> map_Opening_inventory { get; set; }
      //  @AuraEnabled
      //  public map<String,list<String>> map_Opening_inventory_PLN { get; set; }
     //   @AuraEnabled
      //  public map<String,list<String>> map_YTD_sales { get; set; }
      //  @AuraEnabled
     //   public map<String,list<String>> map_YTD_sales_PLN { get; set; }
     //   @AuraEnabled
    //    public map<String,list<String>> map_Total_Available_Stock { get; set; }
      //  @AuraEnabled
     //   public map<String,list<String>> map_Total_Available_Stock_PLN { get; set; }
     //   @AuraEnabled
      //  public map<String,list<String>> map_Distributor_Inventory { get; set; }
     //   @AuraEnabled
     //   public map<String,list<String>> map_Distributor_Inventory_PLN { get; set; }
      //  @AuraEnabled
      //  public map<String,list<String>> map_Liquidation_YTD { get; set; }
     //   @AuraEnabled
     //   public map<String,list<String>> map_Liquidation_PLN { get; set; }
     //   @AuraEnabled
     //   public map<String,list<String>> map_Liquidation_YTD_per_plan_YTD { get; set; }
    }
    /* -- */
}