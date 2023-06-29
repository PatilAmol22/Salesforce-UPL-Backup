/*
* Name: MarketingRequisitionController
* Created On: 16 March 2018
* Author: Bhavik Devdhar (bhavik.devdhar@skinternational.com)
* Description: Lightning Component Apex Controller used for Marketing Requisition in Delta
* Supporting Classes: Refer ApexLog Class for Exception Handling Method
*/
public with sharing class MarketingRequisitionController {
    
    //Method to delete a particular Sales Order record.
    @AuraEnabled
    public static Boolean deleteActivityRecord (String recordId) {
        Boolean flag = false;
        
        //Id recordTypeId = Schema.SObjectType.Sales_Order__c.getRecordTypeInfosByName().get('Simulation').getRecordTypeId();        
        
        List<Activity_Plan__c> apList = [SELECT Id FROM Activity_Plan__c 
                                         WHERE Id=:recordId  LIMIT 1];
        
        if(!apList.isEmpty()){
            try{
                delete apList;
                flag = true;
            }
            catch(Exception ex){
                System.debug('ex: '+ex.getLineNumber());
                System.debug('ex: '+ex.getMessage());
                System.debug('Delete denied. Please contact System Administrator.');
            }
        }
        
        return flag;
    }
    
    @AuraEnabled
    public static RecordData getRecord(String recordId){
        System.debug('recordId: '+recordId);
        Activity_Plan__c apObj = [Select Id, Name, Activity_Type__c, Crop_txt__c ,Crop__c, Crop__r.Name, Location__c, 
                                  Start_Date__c, End_Date__c, No_of_farmer_invited__c, 
                                  No_of_R1_invited__c, Time__c, Activity_Cost__c, Liquidation_Cost__c, 
                                  Activity_percentage__c, MM_Status__c, RM_Approval_image__c, MM_Approval_Status__c, RM_Approval_Status__c
                                  FROM Activity_Plan__c WHERE Id=:recordId];
        
        List<Allocation> allocationList = new List<Allocation>();
        Integer index = 0;
        for(Allocation__c allocObj:[SELECT Id, Activity_Plan__c, All_Percentage__c, 
                                    ProductGroup__c, ProductGroup__r.Name,
                                    Product_Group__c, Product_Group__r.Name
                                    FROM Allocation__c
                                    WHERE Activity_Plan__c=:apObj.Id]){

			Allocation allObj = new Allocation();
            allObj.allocationPercent = allocObj.All_Percentage__c;
            allObj.productGroupId = allocObj.ProductGroup__c; //allocObj.Product_Group__c;
			allObj.productGroupName = allocObj.ProductGroup__r.Name; //allocObj.Product_Group__r.Name;
			allObj.index = index++;
			allObj.id = allocObj.Id;  
                                        
			allocationList.add(allObj);
        }
        
        index = 0;
        List<Item> itemList = new List<Item>();
        for(Item_and_accomodation__c iaObj : [SELECT Id, Activity_Plan__c, Item__c, Other_Item__c, 
                                              Discription__c, No_of_Unit__c, Cost_Per_Unit__c, Sub_total__c
                                              FROM Item_and_accomodation__c
                                              WHERE Activity_Plan__c=:apObj.Id]){
                             
            Item itmObj = new Item();
            itmObj.item = iaObj.Item__c;
            itmObj.otherItem = iaObj.Other_Item__c;
            itmObj.description = iaObj.Discription__c;
            itmObj.nou = iaObj.No_of_Unit__c;
            itmObj.cpu = iaObj.Cost_Per_Unit__c;
            itmObj.subtotal = iaObj.Sub_total__c;
			itmObj.index = index++; 
			itmObj.id = iaObj.Id;   
                                                  
            itemList.add(itmObj);
        }
        
        index = 0;
        List<Liquidation> liquidationList = new List<Liquidation>();
        for(Liquidation__c liObj:[SELECT Id, Activity_Plan__c, Distributor__c, Distributor__r.Name, 
                                  R1__c, R1__r.Name, Product_SKU__c, Product_SKU__r.Name, Sub_Total__c,
                                  R1_Stock__c, Liquidation_Quantity__c, Price__c
                                  FROM Liquidation__c
                                  WHERE Activity_Plan__c=:apObj.Id]){

			Liquidation liqObj = new Liquidation();
            liObj.Activity_Plan__c = apObj.Id;
            if(String.isNotBlank(liObj.Distributor__c)){
                liqObj.distributorId = liObj.Distributor__c;
                liqObj.distributorName = liObj.Distributor__r.Name;
            }
            if(String.isNotBlank(liObj.R1__c)){
                liqObj.retailerId = liObj.R1__c;
                liqObj.retailerName = liObj.R1__r.Name;
            }
            liqObj.productGroupId = liObj.Product_SKU__c;
			liqObj.productGroupName = liObj.Product_SKU__r.Name;
                                      
            liqObj.stock = liObj.R1_Stock__c;
            liqObj.qty = liObj.Liquidation_Quantity__c;
            liqObj.price = liObj.Price__c;
            liqObj.subtotal = liObj.Sub_Total__c;
			liqObj.index = index++;   
			liqObj.id = liObj.Id;
                                      
            liquidationList.add(liqObj);
        }
        
        RecordData rdObj = new RecordData();
        rdObj.apObj = apObj;
        rdObj.allocationList = allocationList;
        rdObj.itemList = itemList;
        rdObj.liquidationList = liquidationList;
        
        return rdObj;
    }
    
    @AuraEnabled
    public static Boolean saveRecord(Activity_Plan__c apObj, String allocationString, String itemString, String liquidationString){
        System.debug('apObj: '+apObj);
        System.debug('allocationString: '+allocationString);
        System.debug('itemString: '+itemString);
        System.debug('liquidationString: '+liquidationString);
        
        Id recordTypeId = Schema.SObjectType.Activity_Plan__c.getRecordTypeInfosByName().get('Marketing Requisiton').getRecordTypeId();    
        apObj.RecordTypeId = recordTypeId;
        upsert apObj;
        
        List<Allocation> allocationList = (List<Allocation>)JSON.deserialize(allocationString, List<Allocation>.class);
        for(Allocation allObj:allocationList){
            Allocation__c allocObj = new Allocation__c();
            allocObj.Activity_Plan__c = apObj.Id;
            allocObj.All_Percentage__c = allObj.allocationPercent;
            //allocObj.Product_Group__c = allObj.productGroupId;
            allocObj.ProductGroup__c = allObj.productGroupId;
            allocObj.CurrencyIsoCode = 'IDR';
            if(String.isNotBlank(allObj.Id)){
                allocObj.Id = allObj.Id;
            }
            upsert allocObj;
        }
        
        List<Item> itemList = (List<Item>)JSON.deserialize(itemString, List<Item>.class);
        for(Item itmObj:itemList){
			Item_and_accomodation__c iaObj = new Item_and_accomodation__c();
            iaObj.Activity_Plan__c = apObj.Id;
            iaObj.Item__c = itmObj.item;
            iaObj.Other_Item__c = itmObj.otherItem;
            iaObj.Discription__c = itmObj.description;
            iaObj.No_of_Unit__c = itmObj.nou;
            iaObj.Cost_Per_Unit__c = itmObj.cpu;
            iaObj.CurrencyIsoCode = 'IDR';
            //iaObj.Sub_total__c = itmObj.subtotal;
            if(String.isNotBlank(itmObj.Id)){
                iaObj.Id = itmObj.Id;
            }
			upsert iaObj;
        }
                
        List<Liquidation> liquidationList = (List<Liquidation>)JSON.deserialize(liquidationString, List<Liquidation>.class);
        for(Liquidation liqObj:liquidationList){
			Liquidation__c liObj = new Liquidation__c();
            liObj.Activity_Plan__c = apObj.Id;
            if(String.isNotBlank(liqObj.distributorId)){
                liObj.Distributor__c = liqObj.distributorId;
            }
            if(String.isNotBlank(liqObj.retailerId)){
                liObj.R1__c = liqObj.retailerId;
            }
            liObj.Product_SKU__c = liqObj.productGroupId;
            liObj.R1_Stock__c = liqObj.stock;
            liObj.Liquidation_Quantity__c = liqObj.qty;
            liObj.Price__c = liqObj.price;
            liObj.CurrencyIsoCode = 'IDR';
            //liObj.Sub_Total__c = liqObj.subtotal;
            if(String.isNotBlank(liqObj.Id)){
                liObj.Id = liqObj.Id;
            }            
			upsert liObj;
        }
        
        apObj.Marketing_flag__c= true;
        apObj.CurrencyIsoCode = 'IDR';
        update apObj;
        
        return true;
    }
    
    @AuraEnabled
    public static RequisitionForm getFormFields(){
        RequisitionForm ffObj = new RequisitionForm();
        ffObj.activityTypeList = getActivityType();
        ffObj.itemList = getItems();
        ffObj.timeList = getTime();
        ffObj.mtdList = getMTD();
        return ffObj;
    }
    
    /*
    * Non Aura Methods
    * Used in Above Method
    */
    
    //Method to get all the Acitivity Types from Schema of Market Requisition custom object.
    public static List<String> getActivityType(){
        List<String> options = new List<String>();
        Schema.DescribeFieldResult fieldResult = Activity_Plan__c.Activity_Type__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry f: ple) {
            options.add(f.getLabel());
        }
        return options;
    } 
    
    public static List<String> getMTD(){
        List<String> options = new List<String>();
		Map<Integer, String> monthNameMap = new Map<Integer, String>();
        monthNameMap.put(1, 'JAN');
        monthNameMap.put(2, 'FEB');
        monthNameMap.put(3, 'MAR');
        monthNameMap.put(4, 'APR');
        monthNameMap.put(5, 'MAY');
        monthNameMap.put(6, 'JUN');
        monthNameMap.put(7, 'JUL');
        monthNameMap.put(8, 'AUG');
        monthNameMap.put(9, 'SEP');
        monthNameMap.put(10, 'OCT');
        monthNameMap.put(11, 'NOV');
        monthNameMap.put(12, 'DEC');
        System.debug('monthNameMap: '+monthNameMap);
        
        Id recordTypeId = Schema.SObjectType.Activity_Plan__c.getRecordTypeInfosByName().get('Marketing Requisiton').getRecordTypeId(); 
        
        List<AggregateResult> groupedResults = [SELECT calendar_year(CreatedDate) cy, calendar_month(CreatedDate) cm
                                                FROM Activity_Plan__c WHERE RecordTypeId=:recordTypeId
                                                GROUP BY calendar_year(CreatedDate), calendar_month(CreatedDate), Id
                                                ORDER BY Id];
        
        for(AggregateResult ar : groupedResults){
            Integer year = Integer.valueOf(ar.get('cy'));
            Integer month = Integer.valueOf(ar.get('cm'));
            
            
            String label = monthNameMap.get(month)+' '+year;
            String value = month+' '+year;
            if(!options.contains(label+'*'+value)){
                options.add(label+'*'+value);
            }
            //options.sort();
        }
        return options;
    }
    
    public static List<String> getTime(){
        List<String> options = new List<String>();
        Schema.DescribeFieldResult fieldResult = Activity_Plan__c.Time__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry f: ple) {
            options.add(f.getLabel());
        }
        return options;
    }
    
    //Method to get all the Items from Schema of Item and Accomodation custom object.
    public static List<String> getItems(){
        List<String> options = new List<String>();
        Schema.DescribeFieldResult fieldResult = Item_and_accomodation__c.Item__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry f: ple) {
            options.add(f.getLabel());
        }
        return options;
    }
    
    @AuraEnabled     
    public static PagedResult getActivities(Decimal pageNumber ,Integer recordToDisply, String sortField, boolean isAsc, String whereClause) {  
        Id recordTypeId = Schema.SObjectType.Activity_Plan__c.getRecordTypeInfosByName().get('Marketing Requisiton').getRecordTypeId(); 
        
        Integer pageSize = recordToDisply;  
        Integer offset = ((Integer)pageNumber - 1) * pageSize; 
        
        PagedResult obj = new PagedResult();  
        obj.pageSize = pageSize;  
        obj.page = (Integer) pageNumber;  
        
        obj.total = [SELECT count() FROM Activity_Plan__c WHERE RecordTypeId=:recordTypeId]; 
        String query = '';
        //Added MH_Approval_image__c to the query-by Nandhini-CR:APPS-5426
        if(String.isBlank(whereClause)){
            //query = 'SELECT Id, Name, Activity_Type__c, Crop__c, Location__c, Start_Date__c, End_Date__c, No_of_farmer_invited__c, No_of_R1_invited__c, Time__c, Activity_Cost__c, Liquidation_Cost__c, Activity_percentage__c, MM_Status__c, RM_Approval_image__c, MM_Approval_Status__c, RM_Approval_Status__c FROM Activity_Plan__c ORDER BY '+sortField+ (isAsc?' ASC':' DESC')+' LIMIT '+recordToDisply+' OFFSET '+offset;  
            query = 'SELECT Id, Name, Activity_Type__c,MH_Approval_Status__c,MH_Approval_image__c,Marketing_Activity_Status__c, Crop_txt__c, Crop__c, Location__c, Start_Date__c, End_Date__c, No_of_farmer_invited__c, No_of_R1_invited__c, Time__c, Activity_Cost__c, Liquidation_Cost__c, Activity_percentage__c, MM_Status__c, RM_Approval_image__c, MM_Approval_Status__c, RM_Approval_Status__c FROM Activity_Plan__c WHERE RecordTypeId=:recordTypeId ORDER BY '+sortField+ (isAsc?' ASC':' DESC')+' LIMIT '+recordToDisply+' OFFSET '+offset;  
        }
        else{
            //query = 'SELECT Id, Name, Activity_Type__c, Crop__c, Location__c, Start_Date__c, End_Date__c, No_of_farmer_invited__c, No_of_R1_invited__c, Time__c, Activity_Cost__c, Liquidation_Cost__c, Activity_percentage__c, MM_Status__c, RM_Approval_image__c, MM_Approval_Status__c, RM_Approval_Status__c FROM Activity_Plan__c '+whereClause+' ORDER BY '+sortField+ (isAsc?' ASC':' DESC')+' LIMIT '+recordToDisply+' OFFSET '+offset;  
            query = 'SELECT Id, Name, Activity_Type__c,MH_Approval_Status__c,Marketing_Activity_Status__c,MH_Approval_image__c, Crop_txt__c, Crop__c, Location__c, Start_Date__c, End_Date__c, No_of_farmer_invited__c, No_of_R1_invited__c, Time__c, Activity_Cost__c, Liquidation_Cost__c, Activity_percentage__c, MM_Status__c, RM_Approval_image__c, MM_Approval_Status__c, RM_Approval_Status__c FROM Activity_Plan__c '+whereClause+' AND (RecordTypeId=:recordTypeId) ORDER BY '+sortField+ (isAsc?' ASC':' DESC')+' LIMIT '+recordToDisply+' OFFSET '+offset;  
        }
        System.debug('query ::: ' + query);
        
        obj.results = Database.Query(query); 
        
        if(String.isNotBlank(whereClause)){
            obj.total = obj.results.size();
        }
        
        return obj;  
    }  
    
    public class PagedResult {  
        @AuraEnabled public Integer pageSize {get;set;}  
        @AuraEnabled public Integer page {get;set;}  
        @AuraEnabled public Integer total {get;set;}  
        @AuraEnabled public List<Activity_Plan__c> results {get;set;}  
    }  
    
    public class RequisitionForm {
        @AuraEnabled public List<String> activityTypeList;
        @AuraEnabled public List<String> mtdList;
        @AuraEnabled public List<String> itemList;
        @AuraEnabled public List<String> timeList;
        
        public RequisitionForm(){
            activityTypeList = new List<String>();
            itemList = new List<String>();
            timeList = new List<String>();
        }
    }
    
    public class RecordData {
        @AuraEnabled public Activity_Plan__c apObj;
        @AuraEnabled public List<Allocation> allocationList;
        @AuraEnabled public List<Item> itemList;
        @AuraEnabled public List<Liquidation> liquidationList;
        
        public RecordData(){
            apObj = new Activity_Plan__c();
            allocationList = new List<Allocation>();
            itemList = new List<Item>();
            liquidationList = new List<Liquidation>();
        }
    }
    
    public class Allocation {
        @AuraEnabled public String productGroupId;
        @AuraEnabled public String productGroupName;
        @AuraEnabled public Decimal allocationPercent;
        @AuraEnabled public Integer index;
        @AuraEnabled public String id;
        
        public Allocation(){
			productGroupId = '';
            productGroupName = '';
            allocationPercent = 0;
            index = 0;
            id = '';
        }
    }
    
    public class Item {
        @AuraEnabled public String item;
        @AuraEnabled public String otherItem;
        @AuraEnabled public String description;
        @AuraEnabled public Decimal nou;
        @AuraEnabled public Decimal cpu;
        @AuraEnabled public Decimal subtotal;
        @AuraEnabled public Decimal index;
        @AuraEnabled public String id;
        
        public Item(){
            item = '';
            otherItem = '';
            description = '';
            nou = 0;
            cpu = 0;
            subtotal = 0;
            index = 0;
            id = '';
        }
    }
    
    public class Liquidation {
        @AuraEnabled public String distributorId;
        @AuraEnabled public String distributorName;
        @AuraEnabled public String retailerId;
        @AuraEnabled public String retailerName;
        @AuraEnabled public String productGroupId;
        @AuraEnabled public String productGroupName;
        @AuraEnabled public Decimal stock;
        @AuraEnabled public Decimal qty;
        @AuraEnabled public Decimal price;
        @AuraEnabled public Decimal subtotal;
        @AuraEnabled public Decimal index;
        @AuraEnabled public String id;
        
        public Liquidation(){
            distributorId = '';
            distributorName = '';
            retailerId = '';
            retailerName = '';
            productGroupId = '';
            productGroupName = '';
            stock = 0;
            qty = 0;
            price = 0;
            subtotal = 0;
            index = 0;
            id = '';
        }
    }
}