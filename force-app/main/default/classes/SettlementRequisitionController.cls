/*
* Name: SettlementRequisitionController
* Created On: 25 March 2018
* Author: Bhavik Devdhar (bhavik.devdhar@skinternational.com)
* Description: Lightning Component Apex Controller used for Marketing Requisition in Delta
* Supporting Classes: Refer ApexLog Class for Exception Handling Method
*/
public with sharing class SettlementRequisitionController {
    
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
    //Modified the query-Added Marketing Requisistion field-By Nandhini- CR:APPS-5426
    @AuraEnabled
    public static RecordData getRecord(String recordId){
        System.debug('recordId: '+recordId);
        
        Activity_Plan__c apObj = [Select Id, Name, Activity_Type__c, Crop__c, Crop__r.Name, Location__c, CreatedBy.Name, Territory__r.Name, Region__r.Name,
                                  Start_Date__c, End_Date__c, No_of_farmer_invited__c, Marketing_Requisition__c, R1Cost__c,
                                  No_of_R1_invited__c, Time__c, Activity_Cost__c, Liquidation_Cost__c,Marketing_Requisition__r.CreatedBy.Name, 
                                  Marketing_Requisition__r.Activity_Cost__c , Marketing_Requisition__r.Liquidation_Cost__c,
                                  Activity_percentage__c, MM_Status__c, RM_Approval_image__c, MM_Approval_Status__c, RM_Approval_Status__c
                                  FROM Activity_Plan__c WHERE Id=:recordId];
        
        Integer index = 0;

        List<Item> itemList = new List<Item>();
        for(Item_and_accomodation__c iaObj : [SELECT Id, Activity_Plan__c, Item__c, Other_Item__c, 
                                              Discription__c, No_of_Unit__c, Cost_Per_Unit__c, Sub_total__c
                                              FROM Item_and_accomodation__c
                                              WHERE Activity_Plan__c=:apObj.Marketing_Requisition__c]){
                             
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
        
        //Start Item Settlement 
        index = 0;
        List<Item> settlementItemList = new List<Item>();
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
                                                  
            settlementItemList.add(itmObj);
        }
        //End Item Settlement 
        
        index = 0;
        List<Liquidation> liquidationList = new List<Liquidation>();
        for(Liquidation__c liObj:[SELECT Id, Activity_Plan__c, Distributor__c, Distributor__r.Name, 
                                  R1__c, R1__r.Name, Product__c, Product__r.Name, Sub_Total__c,
                                  R1_Stock__c, Liquidation_Quantity__c, Price__c
                                  FROM Liquidation__c
                                  WHERE Activity_Plan__c=:apObj.Marketing_Requisition__c]){

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
            liqObj.productGroupId = liObj.Product__c;
            liqObj.productGroupName = liObj.Product__r.Name;
                                      
            liqObj.stock = liObj.R1_Stock__c;
            liqObj.qty = liObj.Liquidation_Quantity__c;
            liqObj.price = liObj.Price__c;
            liqObj.subtotal = liObj.Sub_Total__c;
            liqObj.index = index++;   
            liqObj.id = liObj.Id;
                                      
            liquidationList.add(liqObj);
        }
        
        //Start Liquidation Settlement 
        index = 0;
        List<Liquidation> settlementLiquidationList = new List<Liquidation>();
        for(Liquidation__c liObj:[SELECT Id, Activity_Plan__c, Distributor__c, Distributor__r.Name, 
                                  R1__c, R1__r.Name, Product__c, Product__r.Name, Sub_Total__c,
                                  R1_Stock__c, Liquidation_Quantity__c, Price__c, BALQTY__c,
                                  NewDistributorPrice__c, NEWPOQTY__c, SUBTOTALR1__c
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
            liqObj.productGroupId = liObj.Product__c;
            liqObj.productGroupName = liObj.Product__r.Name;
                                      
            liqObj.stock = liObj.R1_Stock__c;
            liqObj.qty = liObj.Liquidation_Quantity__c;
            liqObj.price = liObj.Price__c;
            liqObj.subtotal = liObj.Sub_Total__c;
                         
            liqObj.balQty = liObj.BALQTY__c;
            liqObj.newPOQty = liObj.NEWPOQTY__c;
            liqObj.newDistPrice = liObj.NewDistributorPrice__c;
            liqObj.subtotalR1 = liObj.SUBTOTALR1__c;    
                                      
            liqObj.index = index++;   
            liqObj.id = liObj.Id;
                                      
            settlementLiquidationList.add(liqObj);
        }
        //End Liquidation Settlement 
        
        RecordData rdObj = new RecordData();
        rdObj.apObj = apObj;
        rdObj.itemList = itemList;
        rdObj.settlementItemList = settlementItemList;
        rdObj.liquidationList = liquidationList;
        rdObj.settlementLiquidationList = settlementLiquidationList;
        
        return rdObj;
    }
    
    @AuraEnabled
    public static Boolean saveRecord(Activity_Plan__c apObj, String settlementItemString, String settlementLiquidationString){
        System.debug('apObj: '+apObj);
        System.debug('settlementItemString: '+settlementItemString);
        System.debug('settlementLiquidationString: '+settlementLiquidationString);
        
        apObj.CurrencyIsoCode = 'IDR';
        update apObj;
        
        //Id recordTypeId = Schema.SObjectType.Activity_Plan__c.getRecordTypeInfosByName().get('Settlement').getRecordTypeId();    
        //apObj.RecordTypeId = recordTypeId;
        //upsert apObj;
        
        List<Item> settlementItemList = (List<Item>)JSON.deserialize(settlementItemString, List<Item>.class);
        for(Item itmObj:settlementItemList){
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
        
        List<Liquidation> settlementLiquidationList = (List<Liquidation>)JSON.deserialize(settlementLiquidationString, List<Liquidation>.class);
        for(Liquidation liqObj:settlementLiquidationList){
            Liquidation__c liObj = new Liquidation__c();
            liObj.Activity_Plan__c = apObj.Id;
            if(String.isNotBlank(liqObj.distributorId)){
                liObj.Distributor__c = liqObj.distributorId;
            }
            if(String.isNotBlank(liqObj.retailerId)){
                liObj.R1__c = liqObj.retailerId;
            }
            liObj.Product__c = liqObj.productGroupId;
            liObj.R1_Stock__c = liqObj.stock;
            liObj.Liquidation_Quantity__c = liqObj.qty;
            liObj.Price__c = liqObj.price;
            
            liObj.BALQTY__c = liqObj.balQty;
            liObj.NEWPOQTY__c = liqObj.newPOQty;
            liObj.NewDistributorPrice__c = liqObj.newDistPrice;
            //liObj.SUBTOTALR1__c = liqObj.subtotalR1;    
            
            liObj.CurrencyIsoCode = 'IDR';
            //liObj.Sub_Total__c = liqObj.subtotal;
            if(String.isNotBlank(liqObj.Id)){
                liObj.Id = liqObj.Id;
            }            
            upsert liObj;
        }
        
        apObj.Settlement_Flag__c = true;
        update apObj; 
        
        return true;
    }
    
    @AuraEnabled
    public static RequisitionForm getFormFields(){
        RequisitionForm ffObj = new RequisitionForm();
        ffObj.activityTypeList = getActivityType();
        ffObj.itemList = getItems();
        //ffObj.timeList = getTime();
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
        
        Id recordTypeId = Schema.SObjectType.Activity_Plan__c.getRecordTypeInfosByName().get('Settlement').getRecordTypeId(); 
        
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
        Id recordTypeId = Schema.SObjectType.Activity_Plan__c.getRecordTypeInfosByName().get('Settlement').getRecordTypeId(); 
        
        Integer pageSize = recordToDisply;  
        Integer offset = ((Integer)pageNumber - 1) * pageSize; 
        
        PagedResult obj = new PagedResult();  
        obj.pageSize = pageSize;  
        obj.page = (Integer) pageNumber;  
        
        obj.total = [SELECT count() FROM Activity_Plan__c WHERE RecordTypeId=:recordTypeId]; 
        String query = '';
        //Modified the query-Added Marketing Requisistion and MH_Settlement_Status__c field-By Nandhini-CR:APPS-5426
        if(String.isBlank(whereClause)){
            //query = 'SELECT Id, Name, Activity_Type__c, Crop__c, Location__c, Start_Date__c, End_Date__c, No_of_farmer_invited__c, No_of_R1_invited__c, Time__c, Activity_Cost__c, Liquidation_Cost__c, Activity_percentage__c, MM_Status__c, RM_Approval_image__c, MM_Approval_Status__c, RM_Approval_Status__c FROM Activity_Plan__c ORDER BY '+sortField+ (isAsc?' ASC':' DESC')+' LIMIT '+recordToDisply+' OFFSET '+offset;  
            query = 'SELECT Id, Name,Settlement_Disable__c,Marketing_Requisition__c,MH_Settlement_Status__c,MH_Settlement_Staus_icon__c,Marketing_Requisition__r.Name, RM_Settlement_Status__c, MM_Settlement_Status__c, Settlement_Number__c, MM_Settlement_Status_icon__c, RM_Settlement_Staus_icon__c, Description__c, Activity_Type__c, Activity_Cost__c, Liquidation_Cost__c FROM Activity_Plan__c WHERE RecordTypeId=:recordTypeId ORDER BY '+sortField+ (isAsc?' ASC':' DESC')+' LIMIT '+recordToDisply+' OFFSET '+offset;  
        }
        else{
            //query = 'SELECT Id, Name, Activity_Type__c, Crop__c, Location__c, Start_Date__c, End_Date__c, No_of_farmer_invited__c, No_of_R1_invited__c, Time__c, Activity_Cost__c, Liquidation_Cost__c, Activity_percentage__c, MM_Status__c, RM_Approval_image__c, MM_Approval_Status__c, RM_Approval_Status__c FROM Activity_Plan__c '+whereClause+' ORDER BY '+sortField+ (isAsc?' ASC':' DESC')+' LIMIT '+recordToDisply+' OFFSET '+offset;  
            query = 'SELECT Id, Name,Settlement_Disable__c,Marketing_Requisition__c,MH_Settlement_Status__c,MH_Settlement_Staus_icon__c,Marketing_Requisition__r.Name, RM_Settlement_Status__c, MM_Settlement_Status__c, Settlement_Number__c, MM_Settlement_Status_icon__c, RM_Settlement_Staus_icon__c, Description__c, Activity_Type__c, Activity_Cost__c, Liquidation_Cost__c FROM Activity_Plan__c '+whereClause+' AND (RecordTypeId=:recordTypeId) ORDER BY '+sortField+ (isAsc?' ASC':' DESC')+' LIMIT '+recordToDisply+' OFFSET '+offset;  
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
        
        public RequisitionForm(){
            activityTypeList = new List<String>();
            itemList = new List<String>();
            mtdList = new List<String>();
        }
    }
    
    public class RecordData {
        @AuraEnabled public Activity_Plan__c apObj;
        @AuraEnabled public List<Item> itemList;
        @AuraEnabled public List<Liquidation> liquidationList;
        @AuraEnabled public List<Item> settlementItemList;
        @AuraEnabled public List<Liquidation> settlementLiquidationList;
        
        public RecordData(){
            apObj = new Activity_Plan__c();
            itemList = new List<Item>();
            settlementItemList = new List<Item>();
            liquidationList = new List<Liquidation>();
            settlementLiquidationList = new List<Liquidation>();
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
        @AuraEnabled public Decimal balQty;
        @AuraEnabled public Decimal newPOQty;
        @AuraEnabled public Decimal newDistPrice;
        @AuraEnabled public Decimal subtotalR1;
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
            balQty = 0;
            newPOQty = 0;
            newDistPrice = 0;
            subtotalR1 = 0;            
            index = 0;
            id = '';
        }
    }
}