/*
* Written by: Sayan Majumder (crmconsultant3@upl-ltd.com) ; 29/3/2021 12:41 pm
* Purpose: Showing Crop Wise data in SWAL Liquidation Approval Page
* Related component: VF page--> SWALCropLiquidationApproval
* Included in: CropLiquidationSWAL aura component iFrame
* Test class name: SWALCropLiquidationApproval_Test
* Visible to SWAl RM and ZMMs only
*/

public class SWALCropLiquidationApprovalController {
    public List<Crop__c> cropNameListvf {get;set;}
    public String monthForVF {get;set;}
    public Map<Id,Integer> cropToSubCropSizeMap{get;set;}
    public Map<Id,List<Sub_Crops__c>> cropTosubCropMap {get;set;}
    public List<Product2>productListForCropLiqui {get;set;}
    public String selectedTeritorry {get;set;}
    public String fiscalyear {get;set;}
    public String mth {get;set;}
    public  List<Liquidation_Annual_Plan__c> liquiAnualPlan{get;set;}
    public  Id rtforAnnualPlan;
    public  Id rtForOpeningInventory;
    public  Id rtforLiquidation;
    public Map<String,List<Crop_Liquidation__c>> cropLiquidationMap_vf {get;set;}
    public Map<Id,List<Sub_Crop_Liquidation__c>> liquidationToSubCropLiqMap{get;set;}
    public String recordIdTotupdate{get;set;}
    public String prodIdTotupdate {get;set;}
    public String valueToupdate {get;set;}
    
    public SWALCropLiquidationApprovalController(){
        cropNameListvf = new List<Crop__c>();
        selectedTeritorry=ApexPages.CurrentPage().getParameters().get('tId');
        system.debug('Sayan TerritoryId : ' +selectedTeritorry);
        fiscalyear=ApexPages.CurrentPage().getParameters().get('fy');
        system.debug('Sayan fiscalyear : ' +fiscalyear);
        mth=ApexPages.CurrentPage().getParameters().get('m');
        system.debug('Sayan Month : ' +mth);
        monthForVF = 'Feb';
        cropToSubCropSizeMap = new Map<Id,Integer>();
        cropTosubCropMap = new Map<Id,List<Sub_Crops__c>>();
        productListForCropLiqui = new List<Product2>();
        liquiAnualPlan = new List<Liquidation_Annual_Plan__c>();
        rtForAnnualPlan = Schema.SObjectType.Liquidation_Annual_Plan__c.getRecordTypeInfosByName().get('SWAL TRADE').getRecordTypeId();
        rtForOpeningInventory = Schema.SObjectType.Opening_Inventory2__c.getRecordTypeInfosByName().get('SWAL TRADE').getRecordTypeId();
        rtforLiquidation = Schema.SObjectType.Liquidation2__c.getRecordTypeInfosByName().get('SWAL TRADE').getRecordTypeId();
        cropLiquidationMap_vf= new Map<String, List<Crop_Liquidation__c>>();
        liquidationToSubCropLiqMap = new Map<Id,List<Sub_Crop_Liquidation__c>>();
    }
    
    public void defaultMethod(){
        
        cropNameListvf = [Select Id,Name,Active_for_Crop_Liquidation__c FROM Crop__c 
                          WHERE Active_for_Crop_Liquidation__c = true
                          AND Active__c = true 
                          AND Sales_Org_Code__c ='1210'
                          AND Type__c ='Category'
                          ORDER BY LastModifiedDate ASC];
        List<Sub_Crops__c> subCropRecordList = [Select Id,Name,Crop__c from Sub_Crops__c where Crop__c in : cropNameListvf order by Crop__c, Name];
        for(Sub_Crops__c subCropRecord : subCropRecordList){
            if(cropTosubCropMap.containsKey(subCropRecord.Crop__c)){
                cropTosubCropMap.get(subCropRecord.Crop__c).add(subCropRecord);
                Integer value = cropToSubCropSizeMap.get(subCropRecord.Crop__c);
                value++;
                cropToSubCropSizeMap.put(subCropRecord.Crop__c, value);
            }else
            {
                List<Sub_Crops__c> subCropList = new List<Sub_Crops__c>();
                subCropList.add(subCropRecord);
                cropTosubCropMap.put(subCropRecord.Crop__c, subCropList); 
                cropToSubCropSizeMap.put(subCropRecord.Crop__c, 1);
            }
            
        }
        liquiAnualPlan  = [SELECT Id,Name, Fiscal_Year__c, Territory_Name__c, 
                           Fiscal_Start_Date__c, Fiscal_End_Date__c 
                           FROM Liquidation_Annual_Plan__c
                           WHERE Fiscal_Year__c =:fiscalyear
                           AND Territory_Name__c =:selectedTeritorry
                           AND RecordTypeId =:rtforAnnualPlan
                           AND Sales_Org__r.Sales_Org_Code__c='1210'];
        productListForCropLiqui = showProductListForCropSWAL(selectedTeritorry,mth,liquiAnualPlan[0].id,rtforLiquidation);
        system.debug('Sayan productListForCropLiqui: '+productListForCropLiqui);
        cropLiquidationMap_vf = loadAllDataForCropLiquidationSWAL(selectedTeritorry, mth, liquiAnualPlan, rtforLiquidation);
        liquidationToSubCropLiqMap = fetchSubCropLiqRecord(selectedTeritorry, mth, liquiAnualPlan, rtforLiquidation, cropTosubCropMap);
    }
    
    public List<Product2> showProductListForCropSWAL(String selectedTeritorry,String mth,String liquiAnnualPlan,String rtforLiquidation){
        
        List<Liquidation2__c> liqList = new List<Liquidation2__c>();
        List<Product2> productList = new List<Product2>();
        liqList = [select id,Name,Liquidation_Annual_Plan__c,Liquidation_Annual_Plan__r.Sales_Org__c,
                   Product__c,Month__c,Liquidation__c,Territory__r.Name,
                   Territory__c
                   FROM Liquidation2__c 
                   WHERE Territory__c=: selectedTeritorry
                   AND Month__c=:mth
                   AND Liquidation_Annual_Plan__c=:liquiAnnualPlan
                   AND RecordTypeId =:rtforLiquidation
                   AND submitted_Trade_SWAL__c = true
                   //AND Liquidation_YTD_SWAL__c>0 
                   AND Fixed_YTD_Sales__c>0];
        System.debug('Liqui List in Show Proc List for SWAL '+liqList);
        System.debug('Liqui List in Show Proc List for SWAL Size '+liqList.size());
        
        List<String> prodId = new List<String>();
        if(liqList.size()>0){
            for(Liquidation2__c liobj:liqList){
                prodId.add(liobj.Product__c);
            }
            
            
            if(prodId.size()>0){
                productList = [SELECT Id,Name, product_code__C,Active_For_Liquidation__c, 
                               Sales_Org_Code__c,
                               IsActive 
                               FROM Product2 
                               WHERE IsActive = true 
                               AND Sales_Org_Code__c = '1210' 
                               AND Active_For_Liquidation__c= true
                               AND Id IN:prodId];
                System.debug('productList '+productList);
                System.debug('productList size '+productList.size());
                
            }
            
        }
        return productList;
    }
    
    public Map<String,List<Crop_Liquidation__c>> loadAllDataForCropLiquidationSWAL(String selectedTeritorry,String mth,List<Liquidation_Annual_Plan__c> liquiAnnualPlan,String rtforLiquidation){
        List<Liquidation2__c> liqList = new List<Liquidation2__c>();
        Map<String,List<Crop_Liquidation__c>> cropLiquidationMap = new Map<String,List<Crop_Liquidation__c>>();
        
        liqList = [select id,Name,Liquidation_Annual_Plan__c,Liquidation_Annual_Plan__r.Sales_Org__c,
                   Product__c,Month__c,Liquidation__c,
                   Territory__c,submitted_Trade_SWAL__c,Liquidation_YTD_SWAL__c 
                   FROM Liquidation2__c
                   WHERE Territory__c=: selectedTeritorry
                   AND Month__c=:mth
                   AND Liquidation_Annual_Plan__c IN:liquiAnnualPlan
                   AND RecordTypeId =:rtforLiquidation
                   AND submitted_Trade_SWAL__c = true
                   //AND Liquidation_YTD_SWAL__c>0 
                   AND Fixed_YTD_Sales__c>0];
        
        List<String> liquidationId = new List<String>();
        for(Liquidation2__c liqudaobj:liqList){
            liquidationId.add(liqudaobj.Id);    
        }
        
        
        
        
        List<Crop_Liquidation__c> cropList = new List<Crop_Liquidation__c>();
        cropList = [SELECT Id, Name, Crop__c, Liquidation__r.Product__c,is_Crop_Liquidation_Submitted__c,Total_Sub_Liq_Value__c,Sales_Org__c,
                    Liquidation__r.Liquidation_YTD_SWAL__c,Liquidation__c, Liquidation_Value__c,Liquidation_YTD_Trade__c 
                    FROM Crop_Liquidation__c 
                    WHERE Liquidation__c IN:liquidationId];
        
        if(cropList.size()>0){
            for(Crop_Liquidation__c cliqObj:cropList){
                
                
                if(cropLiquidationMap.containsKey(cliqObj.Liquidation__r.Product__c)){
                    List<Crop_Liquidation__c> cList = cropLiquidationMap.get(cliqObj.Liquidation__r.Product__c);
                    cList.add(cliqObj);
                    cropLiquidationMap.put(cliqObj.Liquidation__r.Product__c, cList);
                    
                }else{
                    List<Crop_Liquidation__c> CroList = New List<Crop_Liquidation__c>();
                    CroList.add(cliqObj);
                    cropLiquidationMap.put(cliqObj.Liquidation__r.Product__c, CroList);
                }
                
                System.debug('Selected teri cropLiquidationMap '+cropLiquidationMap);
                System.debug('Selected teri cropLiquidationMap size  '+cropLiquidationMap.size()); 
                
            }
        }
        return cropLiquidationMap;
    }
    
    public Map<Id,List<Sub_Crop_Liquidation__c>> fetchSubCropLiqRecord(String teriId, String month, List<Liquidation_Annual_Plan__c> annualPlan, String recordTypeId,Map<Id,List<Sub_Crops__c>> cropTosubCropMap){
        Map<Id,List<Sub_Crop_Liquidation__c>> liquidationToSubCropLiqMap =new Map<Id,List<Sub_Crop_Liquidation__c>>();
        List<Liquidation2__c> liqList = new List<Liquidation2__c>();
        Set<Id> liquidationIdSet = new Set<Id>();
        Set<Id> cropLiquidationIdSet = new Set<Id>();
        if(teriId != null){
            liqList = [select id,Name,Liquidation_Annual_Plan__c,Liquidation_Annual_Plan__r.Sales_Org__c,
                       Product__c,Month__c,Liquidation__c,
                       Territory__c,submitted_Trade_SWAL__c,Liquidation_YTD_SWAL__c 
                       FROM Liquidation2__c
                       WHERE Territory__c=: teriId
                       AND Month__c=:month
                       AND Liquidation_Annual_Plan__c in :annualPlan
                       AND RecordTypeId =:recordTypeId
                       AND submitted_Trade_SWAL__c = true
                       //AND Liquidation_YTD_SWAL__c>0 
                       AND Fixed_YTD_Sales__c>0];
            
        }/*else{
liqList = [select id,Name,Liquidation_Annual_Plan__c,Liquidation_Annual_Plan__r.Sales_Org__c,
Product__c,Month__c,Liquidation__c,
Territory__c,submitted_Trade_SWAL__c,Liquidation_YTD_SWAL__c 
FROM Liquidation2__c
WHERE Month__c=:month
AND Liquidation_Annual_Plan__c in :annualPlan 
AND RecordTypeId =:recordTypeId
AND submitted_Trade_SWAL__c = true
AND Fixed_YTD_Sales__c>0];
//Add Liq annual plan
}*/
        
        for(Liquidation2__c liqudaobj:liqList){
            liquidationIdSet.add(liqudaobj.Id);    
        }
        //System.assert(false,'liquidationIdSet : '+liquidationIdSet);
        
        List<Crop_Liquidation__c> cropLiqList = [Select Id,Name,Liquidation__c,Total_Sub_Liq_Value__c From Crop_Liquidation__c WHERE Liquidation__c IN:liquidationIdSet];
        //System.assert(false,'cropLiqList : '+cropLiqList);
        
        
        for(Crop_Liquidation__c cropLiquidationRecord:cropLiqList){
            cropLiquidationIdSet.add(cropLiquidationRecord.Id);
        }
        List<Sub_Crop_Liquidation__c> subCropLiqList = [Select Id,Crop_Liquidation__c,Crop_Liquidation__r.Liquidation__r.Product_Code__c,Sub_Crop_Liquidation_Value__c,
                                                        Crop_Liquidation__r.Product_Name__c,Crop_Liquidation__r.Crop__r.Name,Sub_Crops__c,Sub_Crops__r.Name,Is_Sub_Crop_Liquidation_Submitted__c,Liquidation__c,
                                                        Sales_Org__c 
                                                        from Sub_Crop_Liquidation__c where Crop_Liquidation__c in :cropLiquidationIdSet 
                                                        order by Crop_Liquidation__r.Product_Name__c,Crop_Liquidation__r.Crop__r.LastModifiedDate  ,Sub_Crops__r.Name	 
                                                       ];
        if(teriId != null){
            for(Sub_Crop_Liquidation__c subCropLiq : subCropLiqList){
                if(liquidationToSubCropLiqMap.containsKey(subCropLiq.Crop_Liquidation__c)){
                    liquidationToSubCropLiqMap.get(subCropLiq.Crop_Liquidation__c).add(subCropLiq);
                }else
                {
                    List<Sub_Crop_Liquidation__c> tempsubCropLiqList = new List<Sub_Crop_Liquidation__c>();
                    tempsubCropLiqList.add(subCropLiq);
                    liquidationToSubCropLiqMap.put(subCropLiq.Crop_Liquidation__c, tempsubCropLiqList);        
                }
            }
        }/*else{
String assertString='';
Map<String,Set<ID>> productIDToCropLiqSetMap = new Map<String,Set<Id>>();
Map<String,List<Sub_Crop_Liquidation__c>> productSubCropToSubCropLiqRecordMap = new Map<String,List<Sub_Crop_Liquidation__c>>();
Map<String,Sub_Crop_Liquidation__c> combinationKeyToSubCropLiqRecordMap = new Map<String,Sub_Crop_Liquidation__c>();

String combinationKey='';
for(Sub_Crop_Liquidation__c subCropLiq : subCropLiqList){
combinationKey= String.valueOf(subCropLiq.Crop_Liquidation__r.Liquidation__r.Product_Code__c)+String.valueOf(subCropLiq.Sub_Crops__c);
if(productIDToCropLiqSetMap.containsKey(combinationKey)){
productIDToCropLiqSetMap.get(combinationKey).add(subCropLiq.Crop_Liquidation__c);
}else{
Set<Id> tempIdSet = new Set<Id>();
tempIdSet.add(subCropLiq.Crop_Liquidation__c);
productIDToCropLiqSetMap.put(combinationKey,tempIdSet);

}
if(productSubCropToSubCropLiqRecordMap.containsKey(combinationKey)){
productSubCropToSubCropLiqRecordMap.get(combinationKey).add(subCropLiq);
}else{
List<Sub_Crop_Liquidation__c> tempList = new List<Sub_Crop_Liquidation__c>();
tempList.add(subCropLiq);
productSubCropToSubCropLiqRecordMap.put(combinationKey,tempList);
}
}

for(Sub_Crop_Liquidation__c subCropLiq : subCropLiqList){
combinationKey= String.valueOf(subCropLiq.Crop_Liquidation__r.Liquidation__r.Product_Code__c)+String.valueOf(subCropLiq.Sub_Crops__c);

Integer cropLiquidationSizeForProduct = productIDToCropLiqSetMap.get(combinationKey).size();
if(cropLiquidationSizeForProduct <= 1){
if(liquidationToSubCropLiqMap.containsKey(subCropLiq.Crop_Liquidation__c)){
liquidationToSubCropLiqMap.get(subCropLiq.Crop_Liquidation__c).add(subCropLiq);
}else
{
List<Sub_Crop_Liquidation__c> tempsubCropLiqList = new List<Sub_Crop_Liquidation__c>();
tempsubCropLiqList.add(subCropLiq);
liquidationToSubCropLiqMap.put(subCropLiq.Crop_Liquidation__c, tempsubCropLiqList);        
}   
}
else{
Decimal subCropSum=0;
Sub_Crop_Liquidation__c previoussubCrop;
combinationKey= String.valueOf(subCropLiq.Crop_Liquidation__r.Liquidation__r.Product_Code__c)+String.valueOf(subCropLiq.Sub_Crops__c);
List<Sub_Crop_Liquidation__c> addtionalRecordList = productSubCropToSubCropLiqRecordMap.get(combinationKey);
List<Sub_Crop_Liquidation__c> clonedList = new List<Sub_Crop_Liquidation__c>();
for(Integer i=0;i< addtionalRecordList.size();i++){
Sub_Crop_Liquidation__c currentRecord = new Sub_Crop_Liquidation__c();
currentRecord.Crop_Liquidation__c = addtionalRecordList[i].Crop_Liquidation__c;
currentRecord.Sub_Crop_Liquidation_Value__c = addtionalRecordList[i].Sub_Crop_Liquidation_Value__c;
currentRecord.Sub_Crops__c = addtionalRecordList[i].Sub_Crops__c;
currentRecord.Is_Sub_Crop_Liquidation_Submitted__c = addtionalRecordList[i].Is_Sub_Crop_Liquidation_Submitted__c;
currentRecord.Sales_Org__c = addtionalRecordList[i].Sales_Org__c;
currentRecord.Liquidation__c = addtionalRecordList[i].Liquidation__c;
clonedList.add(currentRecord);
}
for(Sub_Crop_Liquidation__c subCropLiqRecord : addtionalRecordList){
subCropSum = subCropSum + subCropLiqRecord.Sub_Crop_Liquidation_Value__c;
}
subCropLiq.Sub_Crop_Liquidation_Value__c = subCropSum;

if(liquidationToSubCropLiqMap.containsKey(subCropLiq.Crop_Liquidation__c)){
liquidationToSubCropLiqMap.get(subCropLiq.Crop_Liquidation__c).add(subCropLiq);
}else
{
List<Sub_Crop_Liquidation__c> tempsubCropLiqList = new List<Sub_Crop_Liquidation__c>();
tempsubCropLiqList.add(subCropLiq);
liquidationToSubCropLiqMap.put(subCropLiq.Crop_Liquidation__c, tempsubCropLiqList);        
}
productSubCropToSubCropLiqRecordMap.get(combinationKey).clear();
productSubCropToSubCropLiqRecordMap.put(combinationKey,clonedList);

}
}
}*/
        
        
        return liquidationToSubCropLiqMap;
    }
    
    public void updateSingleRecordForCropLiquidation(){
        updateSingleRecordForCropLiquidationSWAL(recordIdTotupdate, prodIdTotupdate, valueToupdate);
    }
    public void updateSingleRecordForCropLiquidationSWAL(String recordIdTotupdate, String prodIdTotupdate, String valueToupdate){
        try{
            System.debug('@@ recordIdTotupdate in crop Liquidation Update '+recordIdTotupdate);
            System.debug('@@ valueToupdate in crop Liquidation Update '+valueToupdate);
            
            List<Sub_Crop_Liquidation__c> subCropRecordList = [Select Id,Name,Sub_Crop_Liquidation_Value__c	 from Sub_Crop_Liquidation__c where Id = :recordIdTotupdate Limit 1];
            if(subCropRecordList.size() > 0){
                subCropRecordList[0].Sub_Crop_Liquidation_Value__c = Decimal.valueOf(valueToupdate);
                update subCropRecordList;
                
            }
        }
        catch(Exception ex){
            System.debug('Error Massage '+ex.getMessage());
            System.debug('Error Line '+ex.getLineNumber());
        }
    }
    
    public void updateCropLiquidation(){
        updateCropLiquidationSWAL(selectedTeritorry, mth, liquiAnualPlan[0].id, rtforLiquidation);
    }
    
    public void updateCropLiquidationSWAL(String teriId, String month, String annualPlan, String recordTypeId){
        List<Liquidation2__c> liqList = new List<Liquidation2__c>();
        system.debug('Sayan teriId-->'+teriId);
        system.debug('Sayan month-->'+month);
        system.debug('Sayan annualPlan-->'+annualPlan);
        system.debug('Sayan recordTypeId-->'+recordTypeId);
        
        liqList = [select id,Name,Liquidation_Annual_Plan__c,Liquidation_Annual_Plan__r.Sales_Org__c,
                   Product__c,Month__c,Liquidation__c,
                   Territory__c,submitted_Trade_SWAL__c,Liquidation_YTD_SWAL__c 
                   FROM Liquidation2__c
                   WHERE Territory__c=: teriId
                   AND Month__c=:month
                   AND Liquidation_Annual_Plan__c=:annualPlan
                   AND RecordTypeId =:recordTypeId
                   AND submitted_Trade_SWAL__c = true
                   //AND Liquidation_YTD_SWAL__c>0 
                   AND Fixed_YTD_Sales__c>0];
        system.debug('Sayan liqList-->'+liqList);
        List<String> liquidationId = new List<String>();
        for(Liquidation2__c liqudaobj:liqList){
            liquidationId.add(liqudaobj.id);    
        }
        system.debug('Sayan liquidationId-->'+liquidationId);
        List<Crop_Liquidation__c> tempCropList = new List<Crop_Liquidation__c>();
        List<Crop_Liquidation__c> tempCropListUpdate = new List<Crop_Liquidation__c>();
        
        
        tempCropList = [SELECT Id, Name, Crop__c, Liquidation__r.Product__c,is_Crop_Liquidation_Submitted__c,
                        Liquidation__r.Liquidation_YTD_SWAL__c,Liquidation__c, Liquidation_Value__c,Liquidation_YTD_Trade__c 
                        FROM Crop_Liquidation__c 
                        WHERE Liquidation__c IN:liquidationId];
        system.debug('Sayan tempCropList-->'+tempCropList);
        Set<Id> cropLiqRecordIdSet = new Set<Id>();
        
        Crop_Liquidation__c tempCrpObj;
        for(Crop_Liquidation__c crpObj :tempCropList){
            tempCrpObj = new Crop_Liquidation__c();
            tempCrpObj.Id = crpObj.Id;
            tempCrpObj.is_Crop_Liquidation_Submitted__c = true;
            tempCropListUpdate.add(tempCrpObj);
            cropLiqRecordIdSet.add(crpObj.Id);
        }
        if(tempCropListUpdate.size()>0){
            update tempCropListUpdate;
        }
        List<Sub_Crop_Liquidation__c> subCropList = [Select Id,Is_Sub_Crop_Liquidation_Submitted__c from Sub_Crop_Liquidation__c where Crop_Liquidation__c In :cropLiqRecordIdSet];
        system.debug('Sayan subCropList-->'+subCropList);
        for(Integer i=0;i< subCropList.size();i++){
            subCropList[i].Is_Sub_Crop_Liquidation_Submitted__c = true;
        }
        if(subCropList.size() > 0){
            system.debug('Sayan subCropList-->'+subCropList);
            update subCropList;
        }
    }// end of function updateCropLiquidationSWAL
    
    public void CreateCropandSubCropforMissingProducts(List<String> ProductIdsToCreateRecords,String teriIdhere,String monthhere,String annualPlanhere){
        Map<Id,List<Sub_Crops__c>> CropSubCropMapHere = new Map<Id,List<Sub_Crops__c>>();
        Map<String,Liquidation2__c> mapliqhere = new Map<String,Liquidation2__c>();
        Id rtForCropLiquidation = Schema.SObjectType.Crop_Liquidation__c.getRecordTypeInfosByName().get('CropSwalTrade').getRecordTypeId();
        List<Crop_Liquidation__c> crpListCreateHere = new List<Crop_Liquidation__c>();
        List<Liquidation2__c> liqListhere = new List<Liquidation2__c>();
        liqListhere = [select id,Name,Liquidation_Annual_Plan__c,Liquidation_Annual_Plan__r.Sales_Org__c,
                       Product__c,Month__c,Liquidation__c,
                       Territory__c,submitted_Trade_SWAL__c,Liquidation_YTD_SWAL__c 
                       FROM Liquidation2__c
                       WHERE Territory__c=: teriIdhere
                       AND Month__c=:monthhere
                       AND Liquidation_Annual_Plan__c=:annualPlanhere
                       AND submitted_Trade_SWAL__c = true
                       //AND Liquidation_YTD_SWAL__c>0 
                       AND Fixed_YTD_Sales__c>0
                       AND Product__c IN:ProductIdsToCreateRecords];
        
        
        for(Liquidation2__c liobj :liqListhere){
            mapliqhere.put(liobj.Product__c,liobj);
        }
        if(ProductIdsToCreateRecords.size()>0){
            List<Crop__c> cropListhere = new List<Crop__c>();
            //we need to add sales org for Crop List
            cropListhere = [Select Id,Name,Active_for_Crop_Liquidation__c FROM Crop__c 
                            WHERE Active_for_Crop_Liquidation__c = true
                            AND Active__c = true 
                            AND Sales_Org_Code__c ='1210'
                            AND Type__c ='Category'
                            ORDER BY LastModifiedDate ASC];
            
            
            Crop_Liquidation__c CropLiquidationObjhere;
            for(String proObj: ProductIdsToCreateRecords){
                for(Crop__c crpObj: cropListhere){
                    CropLiquidationObjhere = new Crop_Liquidation__c();
                    CropLiquidationObjhere.Crop__c = crpObj.Id;
                    CropLiquidationObjhere.Liquidation__c = mapliqhere.get(proObj).Id;
                    CropLiquidationObjhere.Liquidation_Value__c = 0.00;
                    
                    CropLiquidationObjhere.Liquidation_YTD_Trade__c = mapliqhere.get(proObj).Liquidation_YTD_SWAL__c ;
                    CropLiquidationObjhere.Sales_Org__c = mapliqhere.get(proObj).Liquidation_Annual_Plan__r.Sales_Org__c;
                    CropLiquidationObjhere.recordTypeId = rtForCropLiquidation;
                    crpListCreateHere.add(CropLiquidationObjhere);
                }
                
            }//End of Outer Product Loop
            System.debug('### crpListCreateHere.size() '+crpListCreateHere.size());
            System.debug('### crpListCreateHere '+crpListCreateHere);
            if(crpListCreateHere.size()>0){
                insert crpListCreateHere;   
            }
            
        }
        Map<String,List<Crop_Liquidation__c>> CropLiqProductIdMap = new Map<String,List<Crop_Liquidation__c>>();
        for(Crop_Liquidation__c var:crpListCreateHere){
            if(CropLiqProductIdMap.containsKey(var.Liquidation__r.Product__c)){
                List<Crop_Liquidation__c> cListHere = CropLiqProductIdMap.get(var.Liquidation__r.Product__c);
                cListHere.add(var);
                CropLiqProductIdMap.put(var.Liquidation__r.Product__c, cListHere);
                
            }else{
                List<Crop_Liquidation__c> CroListHere = New List<Crop_Liquidation__c>();
                CroListHere.add(var);
                CropLiqProductIdMap.put(var.Liquidation__r.Product__c, CroListHere);
            }
        }
        List<Sub_Crops__c> subCropRecordListHere = [Select Id,Name,Crop__c from Sub_Crops__c where Crop__c in : cropNameListvf order by Crop__c, Name];
        
        for(Sub_Crops__c subCropRecord : subCropRecordListHere){
            if(CropSubCropMapHere.containsKey(subCropRecord.Crop__c)){
                CropSubCropMapHere.get(subCropRecord.Crop__c).add(subCropRecord);
            }else{
                List<Sub_Crops__c> subCropListHere = new List<Sub_Crops__c>();
                subCropListHere.add(subCropRecord);
                CropSubCropMapHere.put(subCropRecord.Crop__c, subCropListHere); 
            }
            
        }
        List<Sub_Crop_Liquidation__c> subCropLiqInsertListHere = new List<Sub_Crop_Liquidation__c>();
        if(CropLiqProductIdMap.size() > 0){
            for(String pr : CropLiqProductIdMap.keySet()){
                for(Crop_Liquidation__c cropLiqRecord : CropLiqProductIdMap.get(pr)){
                    for(Sub_Crops__c subCropRecord : CropSubCropMapHere.get(cropLiqRecord.Crop__c)){
                        Sub_Crop_Liquidation__c subCropLiq = new Sub_Crop_Liquidation__c();
                        subCropLiq.Crop_Liquidation__c = cropLiqRecord.ID;
                        subCropLiq.Sub_Crop_Liquidation_Value__c = 0;
                        subCropLiq.Sub_Crops__c = subCropRecord.Id;
                        subCropLiq.Is_Sub_Crop_Liquidation_Submitted__c = false;
                        subCropLiq.Liquidation__c = cropLiqRecord.Liquidation__c;
                        subCropLiq.Sales_Org__c = cropLiqRecord.Sales_Org__c;
                        subCropLiqInsertListHere.add(subCropLiq);
                    }
                }
            }    
            if(subCropLiqInsertListHere.size() > 0)
                insert subCropLiqInsertListHere;
        }
    }
}