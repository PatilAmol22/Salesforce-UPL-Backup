global class TestCropLiquidationBatch implements Database.Batchable<sObject>,Database.Stateful {
    static final String rtForCropLiquidation = Schema.SObjectType.Crop_Liquidation__c.getRecordTypeInfosByName().get('CropSwalTrade').getRecordTypeId();
    Set<Id> terrList;
    global TestCropLiquidationBatch(){
        terrList= new Set<Id>();
    }
    global Database.QueryLocator start(Database.BatchableContext BC){
        //String query = 'SELECT Id,Name, TerritoryCode__c,SBU_Code__c FROM Territory_Distributor__c WHERE SalesOrg__r.Sales_Org_Code__c = '1000' AND SBU_Code__c IN ('901','902','903','904') AND (NOT(Name LIKE '%-b%' OR Name LIKE '%SAIB%' OR Name LIKE '%Vector%' OR NAME LIKE '%—Provision%' OR Name LIKE '%- b%' OR Name LIKE '%- Provision%' OR Name LIKE '%CIL%'))';
        return Database.getQueryLocator([SELECT Id,Name, TerritoryCode__c,SBU_Code__c FROM Territory_Distributor__c WHERE SalesOrg__r.Sales_Org_Code__c = '1210' AND Present_in_KEDE__c = True AND (NOT(Name LIKE '%-b%' OR Name LIKE '%SAIB%' OR Name LIKE '%Vector%' OR NAME LIKE '%—Provision%' OR Name LIKE '%- b%' OR Name LIKE '%- Provision%' OR Name LIKE '%CIL%')) ]);
    }
    
    global void execute(Database.BatchableContext BC, List<Territory_Distributor__c> scope){
        Id terrId = scope[0].Id;
        Map<String, List<Crop_Liquidation__c>>crpLiqMap = new Map<String, List<Crop_Liquidation__c>>();
		Map<Id,Double> prodLiqIdToYTDMap = new Map<Id,Double>();
        Map<Id, List<Crop_Liquidation__c>>PrdcrpLiqMap = new Map<Id, List<Crop_Liquidation__c>>();
        Double liqYTDValue = 0.0;
		List<Crop_Liquidation__c> crpLiqToBeUpdatedList = new List<Crop_Liquidation__c>();

        try{
        for(Crop_Liquidation__c crp : [SELECT Id, Liquidation__c,  Month__c, Territory_Code__c,  Liquidation__r.Product_Code__c, Product_Name__c, Crop__r.Name, Liquidation_Value__c,Liquidation_YTD_Trade__c,Liquidation__r.Liquidation_YTD_Trade__c,Liquidation__r.Liquidation_YTD_SWAL__c FROM Crop_Liquidation__c WHERE Liquidation__r.Territory__c =:terrId AND RecordTypeId =:rtForCropLiquidation AND Liquidation__r.Financial_Year__c = '2022-2023' ORDER BY Territory_Code__c, Liquidation__r.Product_Code__c,Month__c ASC]){

            String mapKey = crp.Territory_Code__c+crp.Month__c+crp.Liquidation__r.Product_Code__c;

            if(crpLiqMap.containsKey(mapKey)){

                crpLiqMap.get(mapKey).add(crp);

            }else{

                crpLiqMap.put(mapKey, new List<Crop_Liquidation__c>{crp});

            }

        }

        for(String mpKey : crpLiqMap.keySet()){

            Double crpBreakupValue = 0.0;
            for(Crop_Liquidation__c crpObj : crpLiqMap.get(mpKey)){
                crpBreakupValue = crpBreakupValue+crpObj.Liquidation_Value__c;
            }
            for(Crop_Liquidation__c crpObj : crpLiqMap.get(mpKey)){
                if(crpObj.Liquidation__r.Liquidation_YTD_SWAL__c != crpBreakupValue){
                    if(crpObj.Liquidation__r.Liquidation_YTD_SWAL__c > crpBreakupValue){
                        Double diff = crpObj.Liquidation__r.Liquidation_YTD_SWAL__c - crpBreakupValue;
                    	crpObj.Liquidation_YTD_Trade__c = crpObj.Liquidation__r.Liquidation_YTD_SWAL__c;
                        if(crpObj.Crop__r.Name == 'Others'){
                            crpObj.Liquidation_Value__c = crpObj.Liquidation_Value__c + diff;
                        }
                        crpLiqToBeUpdatedList.add(crpObj);
                    }//else if(crpBreakupValue < crpObj.Liquidation_YTD_Trade__c)
                    	else if(crpBreakupValue > crpObj.Liquidation__r.Liquidation_YTD_SWAL__c){
                        Double diff = crpBreakupValue - crpObj.Liquidation__r.Liquidation_YTD_SWAL__c;
                        if(!prodLiqIdToYTDMap.containsKey(crpObj.Liquidation__c)){
                            prodLiqIdToYTDMap.put(crpObj.Liquidation__c,diff);
                        }
                    }
                    
                }
            }
        }
        
        for(Crop_Liquidation__c cp : [SELECT Id,Liquidation__c,Liquidation_Value__c,Liquidation_YTD_Trade__c,Liquidation__r.Liquidation_YTD_SWAL__c FROM Crop_Liquidation__c WHERE Liquidation__c IN :prodLiqIdToYTDMap.keySet() ORDER BY Liquidation_Value__c ASC]){
            if(PrdcrpLiqMap.containsKey(cp.Liquidation__c)){
                PrdcrpLiqMap.get(cp.Liquidation__c).add(cp);
            }else{
                PrdcrpLiqMap.put(cp.Liquidation__c, new List<Crop_Liquidation__c>{cp});
            }
        }
        
        for(Id prdId : prodLiqIdToYTDMap.keySet()){
            Double tempDiff = prodLiqIdToYTDMap.get(prdId);
            for(Crop_Liquidation__c crpLiq : PrdcrpLiqMap.get(prdId)){
                crpLiq.Liquidation_YTD_Trade__c = crpLiq.Liquidation__r.Liquidation_YTD_SWAL__c;
                if(crpLiq.Liquidation_Value__c > 0 && tempDiff > 0){
                    if(tempDiff <= crpLiq.Liquidation_Value__c){
                        crpLiq.Liquidation_Value__c = crpLiq.Liquidation_Value__c - tempDiff;
                        tempDiff = 0;
                    }else if(tempDiff > crpLiq.Liquidation_Value__c){
                        tempDiff = tempDiff - crpLiq.Liquidation_Value__c;
                        crpLiq.Liquidation_Value__c = 0;
                    }
                }
                crpLiqToBeUpdatedList.add(crpLiq);
            }
        }
		
        if(crpLiqToBeUpdatedList.size() > 0 ){
            UPDATE crpLiqToBeUpdatedList;
        }
        }
        catch(exception ex){
            terrList.add(terrId);
            
        }
    }
    
    global void finish(Database.BatchableContext BC){
        /*if(terrList.size()>0){
        Messaging.SingleEmailMessage semail = new Messaging.SingleEmailMessage();
		Messaging.EmailFileAttachment csvAttachment = new Messaging.EmailFileAttachment();
        String generatedCSVFile='';
        for(Id prodID: terrList){
            generatedCSVFile = generatedCSVFile + prodID + '\n';
        }
     	Blob csvBlob = blob.valueOf(generatedCSVFile);
        String csvName = 'company details which doesn.csv';
        csvAttachment.setFileName(csvName);
        csvAttachment.setBody(csvBlob);
        
        String[] sendingTo = new String[]{'bonny.mathews@upl-ltd.com'};

        semail.setToAddresses(sendingTo);

        semail.setSubject('Test');

        semail.setPlainTextBody('company details which doesnt have members CSV');
		semail.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttachment});
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {semail});
        }*/
    }
    

}