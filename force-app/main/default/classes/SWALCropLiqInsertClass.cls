/*
Class Name : SWALCropLiqInsertClass
Description : Apex Class for inserting Crop Liquidation for SWAL
Author : Bonny Mathews
Date : 05/08/2022
*/
public with sharing class SWALCropLiqInsertClass {
    public static void insertCrpLiq(String terrId){
        String finYear = System.Label.Financial_Year;
        String months = System.Label.Months;
        List<String> month = months.split(',');
        String rtForCropLiquidation = Schema.SObjectType.Crop_Liquidation__c.getRecordTypeInfosByName().get('CropSwalTrade').getRecordTypeId();
        String salesOrg;
        Map<String,String> newCrpToIdMap = new Map<String,String>();

        newCrpToIdMap.put('Cotton','a7L0K000000fyJ0UAI');
        newCrpToIdMap.put('Rice','a7L0K000000fyJ1UAI');
        newCrpToIdMap.put('Sugarcane','a7L0K000000fyIzUAI');
        newCrpToIdMap.put('Wheat','a7L0K000000fyJ3UAI');
        newCrpToIdMap.put('Soybean','a7L0K000000fyIuUAI');
        newCrpToIdMap.put('Ground nut','a7L0K000000fyItUAI');
        newCrpToIdMap.put('Chilly and Capsicum','a7L0K000000fyImUAI');
        newCrpToIdMap.put('Others','a7L0K000000fyJ4UAI');
        newCrpToIdMap.put('Black Gram, Green Gram and Lentil','a7L0K000000fyIlUAI');
        newCrpToIdMap.put('Potato','a7L0K000000fyIqUAI');
        newCrpToIdMap.put('Grapes','a7L0K000000fyIyUAI');
        newCrpToIdMap.put('Other Vegetables','a7L0K000000fyIpUAI');
        newCrpToIdMap.put('Onion/Garlic','a7L0K000000fyIoUAI');
        newCrpToIdMap.put('Maize','a7L0K000000fyJ2UAI');
        newCrpToIdMap.put('Tomato','a7L0K000000fyInUAI');
        newCrpToIdMap.put('Apple','a7L0K000000fyIxUAI');
        newCrpToIdMap.put('Bengal Gram','a7L0K000000fyIkUAI');
        newCrpToIdMap.put('Cumin','a7L0K000000fyIrUAI');
        newCrpToIdMap.put('Mango','a7L0K000000fyIwUAI');
        newCrpToIdMap.put('Pomegranate','a7L0K000000fyIvUAI');
        newCrpToIdMap.put('Mustard','a7L0K000000oO1gUAE');
        newCrpToIdMap.put('Ginger','a7L0K000000fyIsUAI');
        newCrpToIdMap.put('Red Gram','a7L0K000000fyIjUAI');
        newCrpToIdMap.put('Others fruits','a7L0K000000oO1bUAE');
        newCrpToIdMap.put('Plantations','Plantations');

        Set<Id> prodLiqIdSet = new Set<Id>();

        Map<String,List<Map<String,Crop_Liquidation__c>>> prodtoCropLiqMap = new Map<String,List<Map<String,Crop_Liquidation__c>>>();
        //Map<Id,Double> prdLiqIdToOldYTDMap = new Map<Id,Double> prdLiqIdToOldYTDMap();
        Map<String,String> cropToCropId = new Map<String,String>();

        Map<Id,List<Map<Id,Sub_Crop_Liquidation__c>>> prodLiqToSubCropMap = new Map<Id,List<Map<Id,Sub_Crop_Liquidation__c>>>();



        for(Liquidation2__c prdLiq : [SELECT Id  FROM Liquidation2__c WHERE Territory__c = :terrId AND Financial_Year__c =:finYear AND Month__c IN:month AND Liquidation_YTD_SWAL__c > 0 AND Sales_Org_Code__c = '1210']){

            prodLiqIdSet.add(prdLiq.Id);

        }
        System.debug('prodLiqIdSet : '+prodLiqIdSet.size());
        
        for(Sub_Crop_Liquidation__c subCrp : [SELECT Id,Sub_Crops__c,Liquidation__c,Crop_Liquidation__r.Liquidation_YTD_Trade__c, Sub_Crop_Liquidation_Value__c from Sub_Crop_Liquidation__c WHERE Liquidation__c IN:prodLiqIdSet AND Crop_Liquidation__r.Crop__r.Name != 'Plantations']){
            Map<Id,Sub_Crop_Liquidation__c> subCropLiqMap = new Map<Id,Sub_Crop_Liquidation__c>();
            subCropLiqMap.put(subCrp.Sub_Crops__c,subCrp);
            //if(!prdLiqIdToOldYTDMap.containsKey(subCrp.Liquidation__c)){
                //prdLiqIdToOldYTDMap.put(subCrp.Liquidation__c, subCrp.Crop_Liquidation__r.Liquidation_YTD_Trade__c);
           
            //}


            if(!prodLiqToSubCropMap.containsKey(subCrp.Liquidation__c)){
                prodLiqToSubCropMap.put(subCrp.Liquidation__c , new List<Map<Id,Sub_Crop_Liquidation__c>>{subCropLiqMap});
            }
            else{
                prodLiqToSubCropMap.get(subCrp.Liquidation__c).add(subCropLiqMap);
            }
            

        }
        System.debug('prodLiqToSubCropMap :'+prodLiqToSubCropMap);

        for(Crop_Liquidation__c crpLiq : [SELECT Id,Total_Sub_Liq_Value__c,Liquidation_YTD_Trade__c,Crop__r.Name,Liquidation__c FROM Crop_Liquidation__c WHERE Liquidation__c IN :prodLiqIdSet and Crop__r.Is_Old_Crop__c = false]){
            Map<String,Crop_Liquidation__c> cropLiqMap = new Map<String,Crop_Liquidation__c>();
            cropLiqMap.put(crpLiq.Crop__r.Name,crpLiq);

            if(!prodtoCropLiqMap.containsKey(crpLiq.Liquidation__c)){
                prodtoCropLiqMap.put(crpLiq.Liquidation__c , new List<Map<String,Crop_Liquidation__c>>{cropLiqMap});
            }
            else{
                prodtoCropLiqMap.get(crpLiq.Liquidation__c).add(cropLiqMap);
            }
        }
        
        for(Crop__c crp:[Select Id,Name,SalesOrg__c  FROM Crop__c WHERE Sales_Org_Code__c ='1210' AND Is_Old_Crop__c =false AND  Active_for_Crop_Liquidation__c = true]){
            cropToCropId.put(crp.Name,crp.Id);
            salesOrg = crp.SalesOrg__c;
        }

        List<Crop_Liquidation__c> cropsToUpsert = new List<Crop_Liquidation__c>();
        for(Id prodId : prodLiqIdSet){

            for(String cropName : newCrpToIdMap.keySet()){
                Crop_Liquidation__c cropLiq = new Crop_Liquidation__c();
                cropLiq.RecordTypeId = rtForCropLiquidation;
                cropLiq.Liquidation__c = prodId;
                cropLiq.is_Crop_Liquidation_Submitted__c = true;
                cropLiq.Crop__c = cropToCropId.get(cropName);
                cropLiq.Sales_Org__c = salesOrg;
                System.debug('Crop Name = '+cropName);
                if(cropName == 'Plantations'){
                    if(prodtoCropLiqMap.containsKey(prodId)){
                    for(Map<String,Crop_Liquidation__c> cropLiqMaps :prodtoCropLiqMap.get(prodId)){
                        if(cropLiqMaps.containsKey(cropName)){
                            cropLiq.Liquidation_Value__c = cropLiqMaps.get(cropName).Total_Sub_Liq_Value__c;
                            cropLiq.Liquidation_YTD_Trade__c = cropLiqMaps.get(cropName).Liquidation_YTD_Trade__c;
                            cropLiq.Id = cropLiqMaps.get(cropName).Id;
                        }
                    }
                    }
                }else{
                    if(prodLiqToSubCropMap.containsKey(prodId)){
                    for(Map<Id,Sub_Crop_Liquidation__c> subCropLiqMaps :prodLiqToSubCropMap.get(prodId)){
                        Id subCrop = newCrpToIdMap.get(cropName);
                        if(subCropLiqMaps.containsKey(subCrop)){
                            System.debug(cropName+'----'+subCrop);
                            cropLiq.Liquidation_Value__c = subCropLiqMaps.get(subCrop).Sub_Crop_Liquidation_Value__c;
                            cropLiq.Liquidation_YTD_Trade__c = subCropLiqMaps.get(subCrop).Crop_Liquidation__r.Liquidation_YTD_Trade__c;
                        }
                    }
                    }
                    

                
                    if(cropName == 'Other Vegetables'){
                        if(prodtoCropLiqMap.containsKey(prodId)){
                        for(Map<String,Crop_Liquidation__c> cropLiqMaps :prodtoCropLiqMap.get(prodId)){
                            //System.debug('cropliq 1 = '+cropLiqMaps.keySet());
                            if(cropLiqMaps.containsKey(cropName)){
                                cropLiq.Id = cropLiqMaps.get(cropName).Id;
                            }
                        }
                        }
                    }
                    else if(cropName == 'Others'){
                        if(prodtoCropLiqMap.containsKey(prodId)){
                        for(Map<String,Crop_Liquidation__c> cropLiqMaps :prodtoCropLiqMap.get(prodId)){
                            System.debug('cropliq 2 = '+cropLiqMaps.keySet());
                            if(cropLiqMaps.containsKey(cropName)){
                                cropLiq.Id = cropLiqMaps.get(cropName).Id;
                            }
                        }
                        }
                    }
                    System.debug('cropLiq = '+cropLiq);
                }
                cropsToUpsert.add(cropLiq);
            }
        }
        System.debug('cropsToUpsert : '+cropsToUpsert.size());
        for(Crop_Liquidation__c c : cropsToUpsert){
            System.debug('Crop liq : '+c);
        }
        upsert cropsToUpsert;


    }
}