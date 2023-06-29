/*
Class Name : ProductTriggerHandler
Description : Trigger Handler to notify when new Product is inserted
Author : Bonny Mathews
Date : 05/08/2022
*/
public without sharing class ProductTriggerHandler {
    //Constants
    static final String rtForOpeningInventoryAF = Schema.SObjectType.Opening_Inventory2__c.getRecordTypeInfosByName().get('Trade').getRecordTypeId();
    static final String rtForOpeningInventorySwal = Schema.SObjectType.Opening_Inventory2__c.getRecordTypeInfosByName().get('SWAL TRADE').getRecordTypeId();
    static final String salesOrgCodeAF = System.Label.AF_Sales_Org_Code_Label;
    static final String newAFSalesOrgCode = System.Label.New_AF_Sales_Org_Code_Label;
    static final String salesOrgCodeSWAL = System.Label.SWAL_Sales_Org_Code_Label;
    //Trigger mail for new product creation notification
    public static void sendEmailForNewProducts(List<Product2> newProductList){
        for(Product2 pod : newProductList){
            if((pod.Sales_Org_Code__c == System.Label.AF_Sales_Org_Code_Label || pod.Sales_Org_Code__c == System.Label.New_AF_Sales_Org_Code_Label || pod.Sales_Org_Code__c == System.Label.SWAL_Sales_Org_Code_Label) && pod.Active_For_Liquidation__c){
                //Call batch with batch size 20
                Database.executeBatch(new NewProductNotificationMailBatch(pod.Id, pod.Sales_Org_Code__c),20);
            }
        }
    }

    //Logic for creation of Opening inventory when new product is added
    public static void createOpeningInventoryOnInsert(List<Product2> newProductList){
        List<Opening_Inventory2__c> opnInvInsertList = new List<Opening_Inventory2__c>();
        String salesOrgCode;
        String salesOrgId;
        String productId;
        String prodName;
        String prodCode;
        String fiscalYear;
        Boolean isActiveLiq = false;
        Set<Id> liqTerrIdSet = new Set<Id>();
        Map<Id,Id> lapToTerrIdMap = new Map<Id,Id>();
        for(Product2 pod : newProductList){
            salesOrgCode = pod.Sales_Org_Code__c;
            isActiveLiq = pod.Active_For_Liquidation__c;
            productId = pod.Id;
            prodName = pod.Name;
            prodCode = pod.Product_Code__c != null?pod.Product_Code__c:'';
        }
        if(isActiveLiq && (salesOrgCode == System.Label.AF_Sales_Org_Code_Label || salesOrgCode == System.Label.New_AF_Sales_Org_Code_Label || salesOrgCode == System.Label.SWAL_Sales_Org_Code_Label)){
            fiscalYear = LiquidationAFSWALUtility.getFiscalYear();
            for(Territory_Distributor__c terr : [SELECT Id,Name,TerritoryCode__c,SalesOrg__c FROM Territory_Distributor__c WHERE Sales_Org_Code__c = :salesOrgCode AND (NOT (Name LIKE 'CIL%' OR Name LIKE 'SAIB%' OR Name LIKE 'Vector%' OR Name LIKE '%-b' OR Name LIKE '%- b' OR Name LIKE '%Provision')) AND Present_In_KEDE__c = true ORDER BY Name Asc]){
                salesOrgId = terr.SalesOrg__c;
                liqTerrIdSet.add(terr.Id);
            }
            if(liqTerrIdSet.size() > 0){
                for(Liquidation_Annual_Plan__c lap : [SELECT Id,Territory_Name__c FROM Liquidation_Annual_Plan__c WHERE Territory_Name__c IN :liqTerrIdSet AND FIscal_Year__c = :fiscalYear AND Sales_Org__c = :salesOrgId]){
                    if(!lapToTerrIdMap.containsKey(lap.Territory_Name__c)){
                        lapToTerrIdMap.put(lap.Territory_Name__c,lap.Id);
                    }
                }
            }

            for(Id terrId : liqTerrIdSet){
                Opening_Inventory2__c opnInvObj = new Opening_Inventory2__c();
                opnInvObj.Liquidation_Annual_Plan__c = lapToTerrIdMap.get(terrId);
                opnInvObj.Product__c = productId;
                opnInvObj.Territory__c = terrId;
                opnInvObj.Opening_Inventory__c = 0.0;
                if(salesOrgCode == salesOrgCodeAF || salesOrgCode == newAFSalesOrgCode){
                    opnInvObj.RecordTypeId = rtForOpeningInventoryAF;
                }else if(salesOrgCode == salesOrgCodeSWAL){
                    opnInvObj.RecordTypeId = rtForOpeningInventorySwal;
                }
                opnInvObj.CurrencyIsoCode = 'INR';
                opnInvObj.Is_From_Liq_Module__c = true;
                opnInvInsertList.add(opnInvObj);
            }
        }

        if(opnInvInsertList.size() > 0){
            INSERT opnInvInsertList;
            LiquidationAFSWALUtility.sendEmail('Product', prodName+' ('+prodCode+')');
        }
    }

    //Logic for creation of Opening inventory when product is made active for Liquidation
    public static void createOpeningInventoryOnUpdate(List<Product2> newProductList, Map<Id,Product2> oldProductMap){
        List<Opening_Inventory2__c> opnInvInsertList = new List<Opening_Inventory2__c>();
        String salesOrgCode;
        String salesOrgId;
        String productId;
        String prodName;
        String prodCode;
        String fiscalYear;
        Boolean isCreateOpInv = false;
        Set<Id> liqTerrIdSet = new Set<Id>();
        Set<Id> opInvTerrIdSet = new Set<Id>();
        Set<Id> finalTerrIdSet = new Set<Id>();
        Map<Id,Id> lapToTerrIdMap = new Map<Id,Id>();
        for(Product2 pod : newProductList){
            salesOrgCode = pod.Sales_Org_Code__c;
            if((pod.Active_For_Liquidation__c) && (oldProductMap.get(pod.Id).Active_For_Liquidation__c == false)){
                isCreateOpInv = true;
            }
            productId = pod.Id;
            prodName = pod.Name;
            prodCode = pod.Product_Code__c != null?pod.Product_Code__c:'';
        }
        System.debug('isCreateOpInv = '+isCreateOpInv);
        if(isCreateOpInv && (salesOrgCode == System.Label.AF_Sales_Org_Code_Label || salesOrgCode == System.Label.New_AF_Sales_Org_Code_Label || salesOrgCode == System.Label.SWAL_Sales_Org_Code_Label)){
            fiscalYear = LiquidationAFSWALUtility.getFiscalYear();
            for(Territory_Distributor__c terr : [SELECT Id,Name,TerritoryCode__c,SalesOrg__c FROM Territory_Distributor__c WHERE Sales_Org_Code__c = :salesOrgCode AND (NOT (Name LIKE 'CIL%' OR Name LIKE 'SAIB%' OR Name LIKE 'Vector%' OR Name LIKE '%-b' OR Name LIKE '%- b' OR Name LIKE '%Provision')) AND Present_In_KEDE__c = true ORDER BY Name Asc]){
                salesOrgId = terr.SalesOrg__c;
                liqTerrIdSet.add(terr.Id);
            }
            System.debug('liqTerrIdSet size = '+liqTerrIdSet.size());
            List<Opening_Inventory2__c> existingOpInvList = [SELECT Id, Territory__c FROM Opening_Inventory2__c WHERE Product__c = :productId AND Multi_Country_Formula_Key__c = :fiscalYear  AND Sales_Org_Code__c = :salesOrgCode AND Territory__r.Present_in_KEDE__c = true];
            System.debug('existingOpInvList size = '+existingOpInvList.size());
            if(existingOpInvList.size() == 0){
                finalTerrIdSet = liqTerrIdSet;
            }else if(existingOpInvList.size() > 0){
                for(Opening_Inventory2__c opInv : existingOpInvList){
                    opInvTerrIdSet.add(opInv.Territory__c);
                }
                System.debug('opInvTerrIdSet size = '+opInvTerrIdSet.size());
                if(liqTerrIdSet.size() > opInvTerrIdSet.size()){
                    for(Id tId : liqTerrIdSet){
                        if(!opInvTerrIdSet.contains(tId)){
                            finalTerrIdSet.add(tId);
                        }
                    }
                }
            }
            System.debug('finalTerrIdSet size = '+finalTerrIdSet.size());
            System.debug('finalTerrIdSet  = '+finalTerrIdSet);
            if(finalTerrIdSet.size() > 0){
                for(Liquidation_Annual_Plan__c lap : [SELECT Id,Territory_Name__c FROM Liquidation_Annual_Plan__c WHERE Territory_Name__c IN :finalTerrIdSet AND FIscal_Year__c = :fiscalYear AND Sales_Org__c = :salesOrgId]){
                    if(!lapToTerrIdMap.containsKey(lap.Territory_Name__c)){
                        lapToTerrIdMap.put(lap.Territory_Name__c,lap.Id);
                    }
                }
            }

            for(Id terrId : finalTerrIdSet){
                Opening_Inventory2__c opnInvObj = new Opening_Inventory2__c();
                opnInvObj.Liquidation_Annual_Plan__c = lapToTerrIdMap.get(terrId);
                opnInvObj.Product__c = productId;
                opnInvObj.Territory__c = terrId;
                opnInvObj.Opening_Inventory__c = 0.0;
                if(salesOrgCode == salesOrgCodeAF || salesOrgCode == newAFSalesOrgCode){
                    opnInvObj.RecordTypeId = rtForOpeningInventoryAF;
                }else if(salesOrgCode == salesOrgCodeSWAL){
                    opnInvObj.RecordTypeId = rtForOpeningInventorySwal;
                }
                opnInvObj.CurrencyIsoCode = 'INR';
                opnInvObj.Is_From_Liq_Module__c = true;
                opnInvInsertList.add(opnInvObj);
            }

            if(opnInvInsertList.size() > 0){
                INSERT opnInvInsertList;
                LiquidationAFSWALUtility.sendEmail('Product', prodName+' ('+prodCode+')');
            }
        }
    }
}