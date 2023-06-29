trigger ProductTrigger on Product2 (After update, After Insert) {
    
    if(Trigger.isAfter && Trigger.isUpdate){
        /*
        List<Liquidation_Annual_Plan__c> anulLiqList = new List<Liquidation_Annual_Plan__c>();
        Map<string,Opening_Inventory2__c> mapOpeningInventory = new Map<string,Opening_Inventory2__c>();  
        List<Opening_Inventory2__c> openingList = new List<Opening_Inventory2__c>();
        RecordType rtSwal = [SELECT Id,Name FROM RecordType WHERE SobjectType='Opening_Inventory2__c' and Name='SWAL TRADE'];
        RecordType rtIndia = [SELECT Id,Name FROM RecordType WHERE SobjectType='Opening_Inventory2__c' and Name='Trade'];
        Period currentFiscalYear = [SELECT FiscalYearSettings.Name , StartDate,EndDate FROM Period WHERE Type = 'Year' AND (StartDate <= TODAY AND EndDate >= TODAY)];
        Date StartDate = currentFiscalYear.StartDate;
        Date endDate = currentFiscalYear.EndDate;
        String fiscalyear = '%'+StartDate.year()+'-'+endDate.year()+'%';
        Map<Id,List<Liquidation_Annual_Plan__c>> orgToLAP = new Map<Id,List<Liquidation_Annual_Plan__c>>();
        //chage fiscal year startDate,endDate to current fiscal year startDate,EndDate. AND change  salesorg according to country
        for(Liquidation_Annual_Plan__c LAP : [SELECT Name,Id,FIscal_Year__c,SentToBatch__c,Sales_Org__c,Territory_Name__c,Fiscal_Start_Date__c,Fiscal_End_Date__c,Sales_Qty_External_Key_Annual_Plan__c FROM Liquidation_Annual_Plan__c WHERE Fiscal_Start_Date__c=:StartDate AND Fiscal_End_Date__c=:endDate]){
            if(orgToLAP.containsKey(LAP.Sales_Org__c)){
                orgToLAP.get(LAP.Sales_Org__c).add(LAP);
            }
            else{
                List<Liquidation_Annual_Plan__c> liqAP = new List<Liquidation_Annual_Plan__c>();
                liqAP.add(LAP);
                orgToLAP.put(LAP.Sales_Org__c,liqAP);
            }
        }
        //system.debug('@@@'+orgToLAP.get('a1F28000001DOXT').size());
        Map<id,List<Opening_Inventory2__c>> productToOpening = new Map<id,List<Opening_Inventory2__c>>();
        system.debug('@@'+fiscalyear);
        system.debug('@@'+Trigger.New);
        for(Opening_Inventory2__c open :[Select id,Product__c from Opening_Inventory2__c where Product__c IN:Trigger.New AND combination_key__c Like :fiscalyear ]){
            if(productToOpening.containsKey(open.Product__c)){
                productToOpening.get(open.Product__c).add(open);
            }
            else{
                List<Opening_Inventory2__c> openIn = new List<Opening_Inventory2__c>();
                openIn.add(open);
                productToOpening.put(open.Product__c,openIn);
            }
        }
        system.debug('@@'+productToOpening);
        for(Product2 product : Trigger.New) {
            system.debug('@@'+ productToOpening.containsKey(product.id));
            system.debug('@@'+ !(productToOpening.containsKey(product.id)));
            if(Trigger.oldMap.get(product.id).Active_For_Liquidation__c == false && Trigger.newMap.get(product.id).Active_For_Liquidation__c == true && Trigger.newMap.get(product.id).IsActive == true && (Trigger.newMap.get(product.id).Sales_Org_Code__c== '1210' ||Trigger.newMap.get(product.id).Sales_Org_Code__c == '1000') && !productToOpening.containsKey(product.id)|| Test.isRunningTest()){
                if(orgToLAP.containsKey(product.Sales_Org__c)){
                    For(Liquidation_Annual_Plan__c  liqAnlPln : orgToLAP.get(product.Sales_Org__c)){ 
                        Opening_Inventory2__c opnInv2=new Opening_Inventory2__c();
                        opnInv2.Product__c = product.id;                   //*** Product ID  ****
                        if( product.Sales_Org_Code__c  == '1000'){
                            opnInv2.RecordTypeId= rtIndia.Id;
                        }else
                            if(product.Sales_Org_Code__c == '1210'){
                                opnInv2.RecordTypeId= rtSwal.Id;
                            }
                        opnInv2.Liquidation_Annual_Plan__c= liqAnlPln.id;
                        opnInv2.Territory__c= liqAnlPln.Territory_Name__c;
                        
                        openingList.add(opnInv2);
                    }
                }
            }
        }
        if(openingList.size()>0){
            insert openingList;
        } */

        //Logic for creation of Opening inventory when product is made active for liquidation
        ProductTriggerHandler.createOpeningInventoryOnUpdate(Trigger.New, Trigger.oldMap);
    
    }
    
    if(Trigger.isAfter && Trigger.isInsert){
        //Calling batch for email notification on addition of new products for AF
        ProductTriggerHandler.sendEmailForNewProducts(Trigger.New);

        //Logic for creation of Opening inventory when new product is added
        ProductTriggerHandler.createOpeningInventoryOnInsert(Trigger.New);
    }  
    
}