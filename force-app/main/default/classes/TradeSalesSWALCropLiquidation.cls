/*
This is utility class for Crop Liquidation for SWAL

*/
public class TradeSalesSWALCropLiquidation {
    public Id rtForCropLiquidation;
    
    public TradeSalesSWALCropLiquidation(){
        rtForCropLiquidation = Schema.SObjectType.Crop_Liquidation__c.getRecordTypeInfosByName().get('CropSwalTrade').getRecordTypeId();    
    }
    
    
    public Boolean createCropLiquidationSWAL(String teriId, String month, String annualPlan, String recordTypeId){
        List<Liquidation2__c> liqList = new List<Liquidation2__c>();
        liqList = [select id,Name,Liquidation_Annual_Plan__c,Liquidation_Annual_Plan__r.Sales_Org__c,
                   Product__c,Month__c,Liquidation__c,
                   Territory__c,submitted_Trade_SWAL__c,Liquidation_YTD_SWAL__c 
                   FROM Liquidation2__c
                   WHERE Territory__c=: teriId
                   AND Month__c=:month
                   AND Liquidation_Annual_Plan__c=:annualPlan
                   AND RecordTypeId =:recordTypeId
                   AND submitted_Trade_SWAL__c = true
                   AND /*Liquidation_YTD_SWAL__c>0 SCTASK0419590 Replaced with Fixed_YTD_Sales__c*/ Fixed_YTD_Sales__c > 0];
        
        List<String> liquidationId = new List<String>();
        for(Liquidation2__c liqudaobj:liqList){
            liquidationId.add(liqudaobj.Id);    
        }
        //checking if already Crop Liquidation is created or not
        Boolean tempCheckCropLiqui;
        tempCheckCropLiqui = checkingCropLiquidation(liquidationId);
        return tempCheckCropLiqui;
        
        
    }
    
    //This function is checking if Crop liqudiation is already created or not
    public Boolean checkingCropLiquidation(List<String> liquiIds){
        System.debug('liquiIds '+liquiIds);
        List<Crop_Liquidation__c> cropLiqList = new List<Crop_Liquidation__c>(); 
        //cropLiqList = [Select Id,Name,Liquidation__c From Crop_Liquidation__c WHERE Liquidation__c IN:liquiIds];
        // Updated by Varun shrivastava : INCTASK0266628(INC0096506) Sub Crop Liquidation Changes
        cropLiqList = [Select Id,Name,Liquidation__c,Total_Sub_Liq_Value__c From Crop_Liquidation__c WHERE Liquidation__c IN:liquiIds];
        // Updated by Varun shrivastava : INCTASK0266628(INC0096506) Sub Crop Liquidation Changes
        
        if(cropLiqList.size()>0){
            return true;
        }else{
            return false;
        }
        
    }
    
    // Updated by Varun shrivastava : INCTASK0266628(INC0096506) Sub Crop Liquidation Changes Start
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
                       AND /*Liquidation_YTD_SWAL__c>0 SCTASK0419590 Replaced with Fixed_YTD_Sales__c*/ Fixed_YTD_Sales__c > 0];
            
        }else{
            liqList = [select id,Name,Liquidation_Annual_Plan__c,Liquidation_Annual_Plan__r.Sales_Org__c,
                       Product__c,Month__c,Liquidation__c,
                       Territory__c,submitted_Trade_SWAL__c,Liquidation_YTD_SWAL__c 
                       FROM Liquidation2__c
                       WHERE Month__c=:month
                       AND Liquidation_Annual_Plan__c in :annualPlan 
                       AND RecordTypeId =:recordTypeId
                       AND submitted_Trade_SWAL__c = true
                       AND /*Liquidation_YTD_SWAL__c>0 SCTASK0419590 Replaced with Fixed_YTD_Sales__c*/ Fixed_YTD_Sales__c > 0];
            //Add Liq annual plan
        }
        
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
        }else{
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
        }
        
        
        return liquidationToSubCropLiqMap;
    }
    // Updated by Varun shrivastava : INCTASK0266628(INC0096506) Sub Crop Liquidation Changes End
    
    
    
    public void actionCreateCropLiquidationSWAL(String teriId, String month, String annualPlan, String recordTypeId){
        try{
            List<Liquidation2__c> liqList = new List<Liquidation2__c>();
            List<Product2> productListForCropLiqui = new List<Product2>();
            liqList = [select id,Name,Liquidation_Annual_Plan__c,Liquidation_Annual_Plan__r.Sales_Org__c,
                       Product__c,Month__c,Liquidation__c,
                       Territory__c,submitted_Trade_SWAL__c,Liquidation_YTD_SWAL__c 
                       FROM Liquidation2__c
                       WHERE Territory__c=: teriId
                       AND Month__c=:month
                       AND Liquidation_Annual_Plan__c=:annualPlan
                       AND RecordTypeId =:recordTypeId
                       AND submitted_Trade_SWAL__c = true
                       AND /*Liquidation_YTD_SWAL__c>0 SCTASK0419590 Replaced with Fixed_YTD_Sales__c*/ Fixed_YTD_Sales__c > 0];
            
            Map<String,Liquidation2__c> mapliq = new Map<String,Liquidation2__c>();
            for(Liquidation2__c liobj :liqList){
                mapliq.put(liobj.Product__c,liobj);
            }
            
            List<String> prodId = new List<String>();
            if(liqList.size()>0){
                for(Liquidation2__c liobj:liqList){
                    prodId.add(liobj.Product__c);
                }
                
                if(prodId.size()>0){
                    productListForCropLiqui = [SELECT Id,Name, product_code__C,Active_For_Liquidation__c, 
                                               Sales_Org_Code__c,IsActive 
                                               FROM Product2 
                                               WHERE IsActive = true 
                                               AND Sales_Org_Code__c = '1210' 
                                               AND Active_For_Liquidation__c= true
                                               AND Id IN:prodId];
                    
                    List<Crop__c> cropList = new List<Crop__c>();
                    //we need to add sales org for Crop List
                    cropList = [Select Id,Name,Active_for_Crop_Liquidation__c FROM Crop__c 
                                WHERE Active_for_Crop_Liquidation__c = true
                                AND Active__c = true 
                                AND Sales_Org_Code__c ='1210'
                                AND Type__c ='Category'
                                ORDER BY LastModifiedDate ASC];
                    
                    List<Crop_Liquidation__c> crpListCreate = new List<Crop_Liquidation__c>();
                    Crop_Liquidation__c CropLiquidationObj;
                    for(Product2 proObj: productListForCropLiqui){
                        for(Crop__c crpObj: cropList){
                            CropLiquidationObj = new Crop_Liquidation__c();
                            CropLiquidationObj.Crop__c = crpObj.Id;
                            CropLiquidationObj.Liquidation__c = mapliq.get(proObj.Id).Id;
                            CropLiquidationObj.Liquidation_Value__c = 0.00;
                            
                            CropLiquidationObj.Liquidation_YTD_Trade__c = mapliq.get(proObj.Id).Liquidation_YTD_SWAL__c ;
                            CropLiquidationObj.Sales_Org__c = mapliq.get(proObj.Id).Liquidation_Annual_Plan__r.Sales_Org__c;
                            CropLiquidationObj.recordTypeId = rtForCropLiquidation;
                            crpListCreate.add(CropLiquidationObj);
                        }
                        
                    }//End of Outer Product Loop
                    System.debug('### crpListCreate.size() '+crpListCreate.size());
                    System.debug('### crpListCreate '+crpListCreate);
                    if(crpListCreate.size()>0){
                        insert crpListCreate;   
                    }
                    
                }
            }
        }
        catch(Exception ex){
            System.debug('Error Occure Line Number '+ex.getLineNumber());
            System.debug('Error Occure Message '+ex.getMessage());
        }
    }//end of function actionCreateCropLiquidationSWAL
    
    public Map<String,List<Crop_Liquidation__c>> loadAllDataForCropLiquidationSWAL(String teriId, String month, String annualPlan, String recordTypeId){
        List<Liquidation2__c> liqList = new List<Liquidation2__c>();
        Map<String,List<Crop_Liquidation__c>> cropLiquidationMap = new Map<String,List<Crop_Liquidation__c>>();
        
        System.debug('@@@ teriId '+teriId);
        System.debug('@@@ month '+month);
        System.debug('@@@ annualPlan '+annualPlan);
        System.debug('@@@ teriId '+teriId);
        liqList = [select id,Name,Liquidation_Annual_Plan__c,Liquidation_Annual_Plan__r.Sales_Org__c,
                   Product__c,Month__c,Liquidation__c,
                   Territory__c,submitted_Trade_SWAL__c,Liquidation_YTD_SWAL__c 
                   FROM Liquidation2__c
                   WHERE Territory__c=: teriId
                   AND Month__c=:month
                   AND Liquidation_Annual_Plan__c=:annualPlan
                   AND RecordTypeId =:recordTypeId
                   AND submitted_Trade_SWAL__c = true
                   AND /*Liquidation_YTD_SWAL__c>0 SCTASK0419590 Replaced with Fixed_YTD_Sales__c*/ Fixed_YTD_Sales__c > 0];
        
        System.debug('While Creating liqList '+liqList.size());
        System.debug('liqList '+liqList);
        
        List<String> liquidationId = new List<String>();
        for(Liquidation2__c liqudaobj:liqList){
            liquidationId.add(liqudaobj.Id);    
        }
        
        
        
        
        List<Crop_Liquidation__c> cropList = new List<Crop_Liquidation__c>();
        //Updated by Varun shrivastava : INCTASK0266628(INC0096506) Sub Crop Liquidation Changes
        /*cropList = [SELECT Id, Name, Crop__c, Liquidation__r.Product__c,is_Crop_Liquidation_Submitted__c,
Liquidation__r.Liquidation_YTD_SWAL__c,Liquidation__c, Liquidation_Value__c,Liquidation_YTD_Trade__c 
FROM Crop_Liquidation__c 
WHERE Liquidation__c IN:liquidationId];*/
        cropList = [SELECT Id, Name, Crop__c, Liquidation__r.Product__c,is_Crop_Liquidation_Submitted__c,Total_Sub_Liq_Value__c,Sales_Org__c,
                    Liquidation__r.Liquidation_YTD_SWAL__c,Liquidation__c, Liquidation_Value__c,Liquidation_YTD_Trade__c 
                    FROM Crop_Liquidation__c 
                    WHERE Liquidation__c IN:liquidationId];
        
        //Updated by Varun shrivastava : INCTASK0266628(INC0096506) Sub Crop Liquidation Changes
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
                
                System.debug('cropLiquidationMap '+cropLiquidationMap);
                System.debug('cliqObj.is_Crop_Liquidation_Submitted__c '+cliqObj.is_Crop_Liquidation_Submitted__c);
            }
        }
        return cropLiquidationMap;
    }
    
    
    
    public List<Product2> showProductListForCropSWAL(String selectedTeritorry,String mth,String liquiAnnualPlan,String rtforLiquidation){
        
        List<Liquidation2__c> liqList = new List<Liquidation2__c>();
        List<Product2> productList = new List<Product2>();
        liqList = [select id,Name,Liquidation_Annual_Plan__c,Liquidation_Annual_Plan__r.Sales_Org__c,
                   Product__c,Month__c,Liquidation__c,Territory__r.Name,
                   Territory__c
                   FROM Liquidation2__c 
                   WHERE Territory__r.Name=: selectedTeritorry
                   AND Month__c=:mth
                   AND Liquidation_Annual_Plan__c=:liquiAnnualPlan
                   AND RecordTypeId =:rtforLiquidation
                   AND submitted_Trade_SWAL__c = true
                   AND /*Liquidation_YTD_SWAL__c>0 SCTASK0419590 Replaced with Fixed_YTD_Sales__c*/ Fixed_YTD_Sales__c > 0];
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
    
    public void updateSingleRecordForCropLiquidationSWAL(String recordIdTotupdate, String prodIdTotupdate, String valueToupdate){
        try{
            System.debug('@@ recordIdTotupdate in crop Liquidation Update '+recordIdTotupdate);
            System.debug('@@ valueToupdate in crop Liquidation Update '+valueToupdate);
            
            //Updated by Varun shrivastava : INCTASK0266628(INC0096506) Sub Crop Liquidation Changes Start
            List<Sub_Crop_Liquidation__c> subCropRecordList = [Select Id,Name,Sub_Crop_Liquidation_Value__c	 from Sub_Crop_Liquidation__c where Id = :recordIdTotupdate Limit 1];
            if(subCropRecordList.size() > 0){
                subCropRecordList[0].Sub_Crop_Liquidation_Value__c = Decimal.valueOf(valueToupdate);
                update subCropRecordList;
            }
            /*List<Crop_Liquidation__c> clistTemp = new List<Crop_Liquidation__c>();
List<Crop_Liquidation__c> clistTempUpdate = new List<Crop_Liquidation__c>();

clistTemp = [Select Id,Name,Liquidation_Value__c
FROM Crop_Liquidation__c 
WHERE Id=:recordIdTotupdate];
Crop_Liquidation__c cliqObj ;
for(Crop_Liquidation__c tempcLiqObj : clistTemp){
cliqObj = new Crop_Liquidation__c();
cliqObj.Id = tempcLiqObj.Id;
cliqObj.Liquidation_Value__c = Decimal.valueOf(valueToupdate);
clistTempUpdate.add(cliqObj);
}
if(clistTempUpdate.size()>0){
update clistTempUpdate;
System.debug('Update Single value of Crop Liquidation ');
}
*/
        }
        catch(Exception ex){
            System.debug('Error Massage '+ex.getMessage());
            System.debug('Error Line '+ex.getLineNumber());
        }
        //Updated by Varun shrivastava : INCTASK0266628(INC0096506) Sub Crop Liquidation Changes End
        
    }
    //Updated by Varun Shrivastava  :INCTASK0266628(INC0096506) Sub Crop Liquidation Changes
    public Boolean checkingCropLiquidationSubmited(String teriId, String month, List<Liquidation_Annual_Plan__c> annualPlan, String recordTypeId){
        List<Liquidation2__c> liqList = new List<Liquidation2__c>();
        Boolean submitCropLiq;
        liqList = [select id,Name,Liquidation_Annual_Plan__c,Liquidation_Annual_Plan__r.Sales_Org__c,
                   Product__c,Month__c,Liquidation__c,
                   Territory__c,submitted_Trade_SWAL__c,Liquidation_YTD_SWAL__c 
                   FROM Liquidation2__c
                   WHERE Territory__r.Name=: teriId//Territory__c=: teriId 
                   AND Month__c=:month
                   AND Liquidation_Annual_Plan__c in :annualPlan
                   AND RecordTypeId =:recordTypeId
                   AND submitted_Trade_SWAL__c = true
                   AND /*Liquidation_YTD_SWAL__c>0 SCTASK0419590 Replaced with Fixed_YTD_Sales__c*/ Fixed_YTD_Sales__c > 0];
        
        List<String> liquidationId = new List<String>();
        for(Liquidation2__c liqudaobj:liqList){
            liquidationId.add(liqudaobj.Id);    
        }
        
        List<Crop_Liquidation__c> cropList = new List<Crop_Liquidation__c>();
        cropList = [SELECT Id, Name, Crop__c, Liquidation__r.Product__c,is_Crop_Liquidation_Submitted__c,
                    Liquidation__r.Liquidation_YTD_SWAL__c,Liquidation__c, Liquidation_Value__c,Liquidation_YTD_Trade__c 
                    FROM Crop_Liquidation__c 
                    WHERE Liquidation__c IN:liquidationId];
        
        if(cropList.size()>0){
            for(Crop_Liquidation__c cliqObj:cropList){
                if(cliqObj.is_Crop_Liquidation_Submitted__c == true){
                    //Added by Varun shrivastava : INCTASK0266628(INC0096506) Sub Crop Liquidation Changes
                    submitCropLiq = true;
                    break;
                    //Added by Varun shrivastava : INCTASK0266628(INC0096506) Sub Crop Liquidation Changes
                    
                }else{
                    submitCropLiq = false;
                }
                
                
            }
        }
        return submitCropLiq;
    }
    
    public void updateCropLiquidationSWAL(String teriId, String month, String annualPlan, String recordTypeId){
        //System.assert(false,'teriId:'+teriId);
        List<Liquidation2__c> liqList = new List<Liquidation2__c>();
        liqList = [select id,Name,Liquidation_Annual_Plan__c,Liquidation_Annual_Plan__r.Sales_Org__c,
                   Product__c,Month__c,Liquidation__c,
                   Territory__c,submitted_Trade_SWAL__c,Liquidation_YTD_SWAL__c 
                   FROM Liquidation2__c
                   WHERE Territory__r.Name=: teriId//Territory__c=: teriId
                   AND Month__c=:month
                   AND Liquidation_Annual_Plan__c=:annualPlan
                   AND RecordTypeId =:recordTypeId
                   AND submitted_Trade_SWAL__c = true
                   AND /*Liquidation_YTD_SWAL__c>0 SCTASK0419590 Replaced with Fixed_YTD_Sales__c*/ Fixed_YTD_Sales__c > 0];
        
        List<String> liquidationId = new List<String>();
        for(Liquidation2__c liqudaobj:liqList){
            liquidationId.add(liqudaobj.Id);    
        }
        //system.assert(false,'liquidationId : '+liquidationId);
        
        List<Crop_Liquidation__c> tempCropList = new List<Crop_Liquidation__c>();
        List<Crop_Liquidation__c> tempCropListUpdate = new List<Crop_Liquidation__c>();
        
        
        tempCropList = [SELECT Id, Name, Crop__c, Liquidation__r.Product__c,is_Crop_Liquidation_Submitted__c,
                        Liquidation__r.Liquidation_YTD_SWAL__c,Liquidation__c, Liquidation_Value__c,Liquidation_YTD_Trade__c 
                        FROM Crop_Liquidation__c 
                        WHERE Liquidation__c IN:liquidationId];
        
        //Updated by Varun shrivastava : INCTASK0266628(INC0096506) Sub Crop Liquidation Changes strat
        Set<Id> cropLiqRecordIdSet = new Set<Id>();
        //Updated by Varun shrivastava : INCTASK0266628(INC0096506) Sub Crop Liquidation Changes End
        
        Crop_Liquidation__c tempCrpObj;
        for(Crop_Liquidation__c crpObj :tempCropList){
            tempCrpObj = new Crop_Liquidation__c();
            tempCrpObj.Id = crpObj.Id;
            tempCrpObj.is_Crop_Liquidation_Submitted__c = true;
            tempCropListUpdate.add(tempCrpObj);
            //Updated by Varun shrivastava : INCTASK0266628(INC0096506) Sub Crop Liquidation Changes strat
            cropLiqRecordIdSet.add(crpObj.Id);
            //Updated by Varun shrivastava : INCTASK0266628(INC0096506) Sub Crop Liquidation Changes End
            
        }
        if(tempCropListUpdate.size()>0){
            update tempCropListUpdate;
        }
        //Updated by Varun shrivastava : INCTASK0266628(INC0096506) Sub Crop Liquidation Changes strat
        List<Sub_Crop_Liquidation__c> subCropList = [Select Id,Is_Sub_Crop_Liquidation_Submitted__c from Sub_Crop_Liquidation__c where Crop_Liquidation__c In :cropLiqRecordIdSet];
        for(Integer i=0;i< subCropList.size();i++){
            subCropList[i].Is_Sub_Crop_Liquidation_Submitted__c = true;
        }
        if(subCropList.size() > 0){
            update subCropList;
            
            //Added by Sayan Majumder for RITM0180898 : Creating one record in the Approval History object when Crops are submitted
            //that record will make liquidation for that Territory visible in Trade Liquidation Approval vf page
            try{
                Sub_Crop_Liquidation__c SWALApprovalHistoryList = [SELECT Liquidation__r.Territory__r.Name, 
                                                                   Liquidation__r.Territory__r.TerritoryManager__r.Email,
                                                                   Liquidation__r.Territory__r.Region__r.RegionHead__r.Email, 
                                                                   Liquidation__r.Territory__r.Region__r.FMM_User__r.Email, 
                                                                   Liquidation__r.Territory__r.Zone__r.ZonalHead__r.Email, 
                                                                   Liquidation__r.Territory__r.Zone__r.ZMMUser__r.Email,
                                                                   Liquidation__r.Territory__c, 
                                                                   Liquidation__r.Month__c, Liquidation__r.Product__r.Sales_Org__c, Liquidation__r.Financial_Year__c,
                                                                   Liquidation__r.Liquidation_Annual_Plan__c FROM Sub_Crop_Liquidation__c 
                                                                   WHERE Crop_Liquidation__c In :cropLiqRecordIdSet LIMIT 1];
                system.debug('Sayan SWALApprovalHistoryList->'+SWALApprovalHistoryList);
                List<Liquidation_Approval_History__c> previousRecordsOfApprovals = [SELECT Id,Approval_Status__c FROM Liquidation_Approval_History__c WHERE 
                                                                                    Territory__c=:SWALApprovalHistoryList.Liquidation__r.Territory__c 
                                                                                    AND Month__c=:SWALApprovalHistoryList.Liquidation__r.Month__c 
                                                                                    AND SalesOrg__c=:SWALApprovalHistoryList.Liquidation__r.Product__r.Sales_Org__c 
                                                                                    AND LAP__c=:SWALApprovalHistoryList.Liquidation__r.Liquidation_Annual_Plan__c LIMIT 1];
                if(previousRecordsOfApprovals.size() == 1 ){
                    for(Liquidation_Approval_History__c temp:previousRecordsOfApprovals){
                        temp.Approval_Status__c = 'Pending for Approval';
                        temp.Submitted_By__c = userinfo.getUserId();
                        temp.Territory_Manager_Email__c  = SWALApprovalHistoryList.Liquidation__r.Territory__r.TerritoryManager__r.Email;
                        temp.SWAL_Region_Head_Email__c = SWALApprovalHistoryList.Liquidation__r.Territory__r.Region__r.RegionHead__r.Email;
                        temp.SWAL_FMM_User_Email__c = SWALApprovalHistoryList.Liquidation__r.Territory__r.Region__r.FMM_User__r.Email;
                        temp.Zonal_Head_Email__c = SWALApprovalHistoryList.Liquidation__r.Territory__r.Zone__r.ZonalHead__r.Email;
                        temp.ZMM_User_Email__c = SWALApprovalHistoryList.Liquidation__r.Territory__r.Zone__r.ZMMUser__r.Email;
                        temp.Approved_Rejected_By__c = null;
                    }
                    update previousRecordsOfApprovals;
                }else{
                    Liquidation_Approval_History__c newApprovalInstance = new Liquidation_Approval_History__c();
                    newApprovalInstance.Territory__c = SWALApprovalHistoryList.Liquidation__r.Territory__c;
                    newApprovalInstance.Month__c = SWALApprovalHistoryList.Liquidation__r.Month__c;
                    newApprovalInstance.Submitted_By__c = userinfo.getUserId();
                    newApprovalInstance.Approval_Status__c = 'Pending for Approval';
                    newApprovalInstance.SalesOrg__c = SWALApprovalHistoryList.Liquidation__r.Product__r.Sales_Org__c;
                    newApprovalInstance.LAP__c = SWALApprovalHistoryList.Liquidation__r.Liquidation_Annual_Plan__c;
                    newApprovalInstance.Territory_Manager_Email__c  = SWALApprovalHistoryList.Liquidation__r.Territory__r.TerritoryManager__r.Email;
                    newApprovalInstance.SWAL_Region_Head_Email__c = SWALApprovalHistoryList.Liquidation__r.Territory__r.Region__r.RegionHead__r.Email;
                    newApprovalInstance.SWAL_FMM_User_Email__c = SWALApprovalHistoryList.Liquidation__r.Territory__r.Region__r.FMM_User__r.Email;
                    newApprovalInstance.Zonal_Head_Email__c = SWALApprovalHistoryList.Liquidation__r.Territory__r.Zone__r.ZonalHead__r.Email;
                    newApprovalInstance.ZMM_User_Email__c = SWALApprovalHistoryList.Liquidation__r.Territory__r.Zone__r.ZMMUser__r.Email;
                    newApprovalInstance.Approved_Rejected_By__c	= null;
                    newApprovalInstance.Name = SWALApprovalHistoryList.Liquidation__r.Territory__r.Name+SWALApprovalHistoryList.Liquidation__r.Month__c+SWALApprovalHistoryList.Liquidation__r.Financial_Year__c ;
                    insert newApprovalInstance;
                }
            }catch(exception e){
                system.debug('Error occured while Operating on Liquidation_Approval_History__c Object at line-->'+e.getLineNumber()+' with message: '+e.getMessage()+' with cause: '+e.getCause() );
            }
            // end of code for RITM0180898
            
        }
        //Updated by Varun shrivastava : INCTASK0266628(INC0096506) Sub Crop Liquidation Changes End
        
        
    }// end of function updateCropLiquidationSWAL
    
    public Map<String,List<Crop_Liquidation__c>> rollupCropLiquidationSWAL(List<Liquidation_Annual_Plan__c> liquiAnualPlan, String month){
        RollupTradeSalesLiquidation_SWAL rollupObj = new RollupTradeSalesLiquidation_SWAL();
        Map<String,List<Crop_Liquidation__c>> newLiqMapCrops = new Map<String,List<Crop_Liquidation__c>>(); 
        newLiqMapCrops = rollupObj.rollupCropLiquidationDetails(liquiAnualPlan,month);
        System.debug('newLiqMapCrops in utility class '+newLiqMapCrops);
        System.debug('newLiqMapCrops in utility class size  '+newLiqMapCrops.size());
        return newLiqMapCrops;
        
    }
    
    public List<Product2> showProductListForCropForHigher(List<Liquidation_Annual_Plan__c> annualPlan, String month,String recordTypeId){
        
        List<Liquidation2__c> liqList = new List<Liquidation2__c>();
        List<Product2> productListForCropLiqui = new List<product2>();
        
        liqList = [select id,Name,Opening_Inventory2__c,Liquidation_Annual_Plan__c,Liquidation_Annual_Plan__r.Sales_Org__c,
                   Product__c,Type__c,submitted_trade__c,Month__c,Liquidation__c,Plan_for_the_month__c,
                   Inventory_in_Kg_Cooperatives__c,Inventory_in_Kg_Govt__c,Retailers_Inventory__c,
                   Distributors_Inventory__c,Plan_for_the_next_month__c,Territory__c,Liquidation_YTD_Trade__c
                   FROM Liquidation2__c 
                   WHERE  Month__c=:month
                   AND Liquidation_Annual_Plan__c IN :annualPlan
                   AND RecordTypeId =:recordTypeId
                   AND submitted_Trade_SWAL__c = true 
                   AND /*Liquidation_YTD_SWAL__c>0 SCTASK0419590 Replaced with Fixed_YTD_Sales__c*/ Fixed_YTD_Sales__c > 0];
        
        List<Crop_Liquidation__c> crpList = new List<Crop_Liquidation__c>();
        crpList = [Select Id,Name,Liquidation__c,Liquidation__r.Product__c From Crop_Liquidation__c
                   WHERE Liquidation__c IN:liqList];
        List<String> prodId = new List<String>();
        if(crpList.size()>0){
            for(Crop_Liquidation__c crpObj : crpList){
                prodId.add(crpObj.Liquidation__r.Product__c);   
            }
            
        }
        
        if(prodId.size()>0){
            productListForCropLiqui = [SELECT Id,Name, product_code__C,Active_For_Liquidation__c, 
                                       Sales_Org_Code__c,Brand_Type__c ,
                                       Indication_Type__c,Budget_NRV__c, Active__c, IsActive 
                                       FROM Product2 
                                       WHERE IsActive = true 
                                       AND Sales_Org_Code__c = '1210' 
                                       AND Active_For_Liquidation__c= true
                                       AND Id IN:prodId];
            
        }
        return productListForCropLiqui;
        
    }
    
    public Boolean displayCropDataForSingleTeritory(List<Liquidation_Annual_Plan__c> liqAnnulPlan,String teriName, String month){ 
        List<Liquidation2__c> liqLists = new List<Liquidation2__c>();
        
        liqLists = [select id,Name,Opening_Inventory2__c,Liquidation_Annual_Plan__c,Liquidation_Annual_Plan__r.Sales_Org__c,
                    Product__c,Type__c,submitted_trade__c,Month__c,Liquidation__c,Plan_for_the_month__c,
                    Inventory_in_Kg_Cooperatives__c,Inventory_in_Kg_Govt__c,Retailers_Inventory__c,
                    Distributors_Inventory__c,Plan_for_the_next_month__c,Territory__c,Liquidation_YTD_Trade__c
                    FROM Liquidation2__c 
                    WHERE Territory__r.Name=: teriName
                    AND Month__c=:month
                    AND Liquidation_Annual_Plan__c IN: liqAnnulPlan
                    AND submitted_Trade_SWAL__c = true
                    AND /*Liquidation_YTD_SWAL__c>0 SCTASK0419590 Replaced with Fixed_YTD_Sales__c*/ Fixed_YTD_Sales__c > 0];
        
        List<String> liquidationId = new List<String>();
        for(Liquidation2__c liqudaobj:liqLists){
            liquidationId.add(liqudaobj.Id);    
        }
        //checking if already Crop Liquidation is created or not
        Boolean tempCheckCropLiqui;
        tempCheckCropLiqui = checkingCropLiquidation(liquidationId);
        return tempCheckCropLiqui;
    }
    
    public List<Product2> showProductListForCropSWALSelectTeri(String selectedTeritorry,String mth,List<Liquidation_Annual_Plan__c> liquiAnnualPlan,String rtforLiquidation){
        List<Liquidation2__c> liqList = new List<Liquidation2__c>();
        List<Product2> productList = new List<Product2>();
        liqList = [select id,Name,Liquidation_Annual_Plan__c,Liquidation_Annual_Plan__r.Sales_Org__c,
                   Product__c,Month__c,Liquidation__c,Territory__r.Name,
                   Territory__c
                   FROM Liquidation2__c 
                   WHERE Territory__r.Name=: selectedTeritorry
                   AND Month__c=:mth
                   AND Liquidation_Annual_Plan__c IN: liquiAnnualPlan
                   AND RecordTypeId =:rtforLiquidation
                   AND submitted_Trade_SWAL__c = true
                   AND /*Liquidation_YTD_SWAL__c>0 SCTASK0419590 Replaced with Fixed_YTD_Sales__c*/ Fixed_YTD_Sales__c > 0];
        
        
        
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
    
    public Map<String,List<Crop_Liquidation__c>> loadAllDataForCropLiquidationSWALSelectTeri(String selectedTeritorry,String mth,List<Liquidation_Annual_Plan__c> liquiAnnualPlan,String rtforLiquidation){
        List<Liquidation2__c> liqList = new List<Liquidation2__c>();
        Map<String,List<Crop_Liquidation__c>> cropLiquidationMap = new Map<String,List<Crop_Liquidation__c>>();
        
        liqList = [select id,Name,Liquidation_Annual_Plan__c,Liquidation_Annual_Plan__r.Sales_Org__c,
                   Product__c,Month__c,Liquidation__c,
                   Territory__c,submitted_Trade_SWAL__c,Liquidation_YTD_SWAL__c 
                   FROM Liquidation2__c
                   WHERE Territory__r.Name=: selectedTeritorry
                   AND Month__c=:mth
                   AND Liquidation_Annual_Plan__c IN:liquiAnnualPlan
                   AND RecordTypeId =:rtforLiquidation
                   AND submitted_Trade_SWAL__c = true
                   AND /*Liquidation_YTD_SWAL__c>0 SCTASK0419590 Replaced with Fixed_YTD_Sales__c*/ Fixed_YTD_Sales__c > 0];
        
        List<String> liquidationId = new List<String>();
        for(Liquidation2__c liqudaobj:liqList){
            liquidationId.add(liqudaobj.Id);    
        }
        
        
        
        
        List<Crop_Liquidation__c> cropList = new List<Crop_Liquidation__c>();
        //Updated by Varun shrivastava : INCTASK0266628(INC0096506) Sub Crop Liquidation Changes
        
        /* cropList = [SELECT Id, Name, Crop__c, Liquidation__r.Product__c,is_Crop_Liquidation_Submitted__c,
Liquidation__r.Liquidation_YTD_SWAL__c,Liquidation__c, Liquidation_Value__c,Liquidation_YTD_Trade__c 
FROM Crop_Liquidation__c 
WHERE Liquidation__c IN:liquidationId];*/
        cropList = [SELECT Id, Name, Crop__c, Liquidation__r.Product__c,is_Crop_Liquidation_Submitted__c,Total_Sub_Liq_Value__c,Sales_Org__c,
                    Liquidation__r.Liquidation_YTD_SWAL__c,Liquidation__c, Liquidation_Value__c,Liquidation_YTD_Trade__c 
                    FROM Crop_Liquidation__c 
                    WHERE Liquidation__c IN:liquidationId];
        //Updated by Varun shrivastava : INCTASK0266628(INC0096506) Sub Crop Liquidation Changes
        
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
    
    
    public void actionCreateCropLiquidationSWALForHigher(String selectedTeritorry,String month, List<Liquidation_Annual_Plan__c> liqAnnualPlan,String recordTypeName){
        List<Liquidation2__c> liqList = new List<Liquidation2__c>();
        liqList = [select id,Name,Liquidation_Annual_Plan__c,Liquidation_Annual_Plan__r.Sales_Org__c,
                   Product__c,Month__c,Liquidation__c,
                   Territory__c,submitted_Trade_SWAL__c,Liquidation_YTD_SWAL__c 
                   FROM Liquidation2__c
                   WHERE Territory__r.Name=: selectedTeritorry
                   AND Month__c=:month
                   AND Liquidation_Annual_Plan__c IN:liqAnnualPlan
                   AND RecordTypeId =:recordTypeName
                   AND submitted_Trade_SWAL__c = true
                   AND /*Liquidation_YTD_SWAL__c>0 SCTASK0419590 Replaced with Fixed_YTD_Sales__c*/ Fixed_YTD_Sales__c > 0];
        
        Map<String,Liquidation2__c> mapliq = new Map<String,Liquidation2__c>();
        for(Liquidation2__c liobj :liqList){
            mapliq.put(liobj.Product__c,liobj);
        }
        
        List<String> prodId = new List<String>();
        if(liqList.size()>0){
            for(Liquidation2__c liobj:liqList){
                prodId.add(liobj.Product__c);
            }
            List<Product2> productListForCropLiquis = new List<Product2>();
            if(prodId.size()>0){
                productListForCropLiquis = [SELECT Id,Name, product_code__C,Active_For_Liquidation__c, 
                                            Sales_Org_Code__c,Brand_Type__c ,
                                            Indication_Type__c,Budget_NRV__c, Active__c, IsActive 
                                            FROM Product2 
                                            WHERE IsActive = true 
                                            AND Sales_Org_Code__c = '1210' 
                                            AND Active_For_Liquidation__c= true
                                            AND Id IN:prodId];
                
                List<Crop__c> cropList = new List<Crop__c>();
                //we need to add sales org for Crop List
                cropList = [Select Id,Name,Active_for_Crop_Liquidation__c FROM Crop__c 
                            WHERE Active_for_Crop_Liquidation__c = true
                            AND Active__c = true 
                            AND Sales_Org_Code__c ='1210'
                            AND Type__c ='Category'
                            ORDER BY LastModifiedDate ASC];
                List<Crop_Liquidation__c> crpListCreate = new List<Crop_Liquidation__c>();
                Crop_Liquidation__c CropLiquidationObj;
                
                for(Product2 proObj: productListForCropLiquis){
                    for(Crop__c crpObj: cropList){
                        CropLiquidationObj = new Crop_Liquidation__c();
                        CropLiquidationObj.Crop__c = crpObj.Id;
                        CropLiquidationObj.Liquidation__c = mapliq.get(proObj.Id).Id;
                        CropLiquidationObj.Liquidation_Value__c = 0.00;
                        CropLiquidationObj.Liquidation_YTD_Trade__c = mapliq.get(proObj.Id).Liquidation_YTD_SWAL__c;
                        CropLiquidationObj.Sales_Org__c = mapliq.get(proObj.Id).Liquidation_Annual_Plan__r.Sales_Org__c;
                        CropLiquidationObj.recordTypeId = rtForCropLiquidation;
                        crpListCreate.add(CropLiquidationObj);
                    }
                    
                }//End of Outer Product Loop
                System.debug('crpListCreate.size() '+crpListCreate.size());
                System.debug('crpListCreate.size() '+crpListCreate);
                if(crpListCreate.size()>0){
                    insert crpListCreate;   
                }
            }
        }
        
        
    }
    
    
    
    
    
}// End of Class utility