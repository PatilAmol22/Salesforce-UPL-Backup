global class SprayEventUploadService {
    webservice static ServiceResponse uploadSprayEvent(List<SprayEventDetails> sprayEventList) {
        
        ServiceResponse sponse = new ServiceResponse();
        String exceptionString = '';
        Exception ex;
        
        try{
            Set<String> farmerCodeSet = new Set<String>();
            Set<String> productCodeSet = new Set<String>();
            Set<String> caseNumberSet = new Set<String>();
            Set<String> machineCodeSet = new Set<String>();
            Set<String> machineCodeOperatorSet = new Set<String>();
            Set<String> cropCodeSet = new Set<String>();
            for(SprayEventDetails sedObj:sprayEventList){
                if(String.isNotBlank(sedObj.farmerCode)){
                    farmerCodeSet.add(sedObj.farmerCode);
                }
                if(String.isNotBlank(sedObj.cropCode)){
                    cropCodeSet.add(sedObj.cropCode);
                }
                
                if(String.isNotBlank(sedObj.product1)){
                    productCodeSet.add(sedObj.product1);
                }
                if(String.isNotBlank(sedObj.product2)){
                    productCodeSet.add(sedObj.product2);
                }
                if(String.isNotBlank(sedObj.product3)){
                    productCodeSet.add(sedObj.product3);
                }
                if(String.isNotBlank(sedObj.product4)){
                    productCodeSet.add(sedObj.product4);
                }               
                if(String.isNotBlank(sedObj.machineCode)){
                    machineCodeOperatorSet.add(sedObj.machineOperatorCode);
                }
                if(String.isNotBlank(sedObj.machineOperatorCode)){
                    machineCodeOperatorSet.add(sedObj.machineOperatorCode);
                }
                if(String.isNotBlank(sedObj.caseNumber) ){
                    caseNumberSet.add(sedObj.caseNumber);
                }
            }
            Map<String,ID> productCodeMap = new Map<String,ID>();
            for(Product2 obj:[Select ID, ProductCode FROM Product2 WHERE ProductCode IN:productCodeSet]){
                productCodeMap.put(obj.ProductCode, obj.Id);
            }
            
            Map<String,ID> cropCodeMap = new Map<String,ID>();
            for(Crop__c obj:[Select ID, Crop_Code__c FROM Crop__c WHERE Crop_Code__c IN:cropCodeSet]){
                cropCodeMap.put(obj.Crop_Code__c, obj.Id);
            }
            
            Map<String,ID> machineCodeMap = new Map<String,ID>();
            for(Machine__c obj:[Select ID, Machine_Code__c FROM Machine__c WHERE Machine_Code__c IN:machineCodeSet]){
                cropCodeMap.put(obj.Machine_Code__c, obj.Id);
            }
            
            Map<String,ID> machineOperatorCodeMap = new Map<String,ID>();
            for(Machine_Operator__c obj:[Select ID, Machine_Operator_Code__c FROM Machine_Operator__c WHERE Machine_Operator_Code__c IN:machineCodeOperatorSet]){
                cropCodeMap.put(obj.Machine_Operator_Code__c, obj.Id);
            }
            
            Map<String,ID> caseNumberMap = new Map<String,ID>();
            for(Case obj:[Select ID, CaseNumber FROM Case WHERE caseNumber IN: caseNumberSet]){
                caseNumberMap.put(obj.CaseNumber, obj.Id);
            }
            
            Map<String, Id> farmerCodeMap = new Map<String, Id>();
            for(Account accObj:[Select Id,SAP_Code__c, Farmer_Code__pc From Account WHERE Farmer_Code__pc IN: farmerCodeSet]){
                farmerCodeMap.put(accObj.Farmer_Code__pc,accObj.Id);
            }
            
            List<Spray_Event__c> upsertSprayEventList = new List<Spray_Event__c>();
            
            for(SprayEventDetails sedObj:sprayEventList){
                
                Spray_Event__c seObj = new Spray_Event__c();

                if(String.isNotBlank(sedObj.farmerCode) && farmerCodeMap.containsKey(sedObj.farmerCode)){
                    seObj.Famrer_Code__c = farmerCodeMap.get(sedObj.farmerCode);
                }
                if(String.isNotBlank(sedObj.cropCode) && cropCodeMap.containsKey(sedObj.cropCode)){
                    seObj.Crop_Code__c = cropCodeMap.get(sedObj.cropCode);
                }
                if(String.isNotBlank(sedObj.acerage)){
                    seObj.Acerage__c = Decimal.valueOf(sedObj.acerage);
                }
                if(String.isNotBlank(sedObj.product1) && productCodeMap.containsKey(sedObj.product1)){
                    seObj.Product_1__c = productCodeMap.get(sedObj.product1);
                }
                if(String.isNotBlank(sedObj.product1Quantity)){
                    seObj.Product_1_Quantity__c = Decimal.valueOf(sedObj.product1Quantity);
                }
                if(String.isNotBlank(sedObj.machineCode) && machineCodeMap.containsKey(sedObj.machineCode)){
                    seObj.Machine_Code__c = machineCodeMap.get(sedObj.machineCode);
                }
                if(String.isNotBlank(sedObj.machineOperatorCode) && machineOperatorCodeMap.containsKey(sedObj.machineOperatorCode)){
                    seObj.Machine_Operator_Code__c = machineOperatorCodeMap.get(sedObj.machineOperatorCode);
                }
                if(String.isNotBlank(sedObj.amountCollected)){
                    seObj.Amount_Collected__c = Decimal.valueOf(sedObj.amountCollected);
                }
                if(String.isNotBlank(sedObj.geolocation_Longitude)){
                    seObj.Geolocation__Longitude__s = Decimal.valueOf(sedObj.geolocation_Longitude);
                }
                if(String.isNotBlank(sedObj.geolocation_Latitude)){
                    seObj.Geolocation__Latitude__s = Decimal.valueOf(sedObj.geolocation_Latitude);
                }
                if(String.isNotBlank(sedObj.caseNumber) && caseNumberMap.containsKey(sedObj.caseNumber)){
                    seObj.Case_Number__c = caseNumberMap.get(sedObj.caseNumber);
                }
                if(String.isNotBlank(sedObj.product2) && productCodeMap.containsKey(sedObj.product2)){
                    seObj.Product_2__c = productCodeMap.get(sedObj.product2);
                }
                if(String.isNotBlank(sedObj.product2Quantity)){
                    seObj.Product_2_Quantity__c = Decimal.valueOf(sedObj.product2Quantity);
                }
                if(String.isNotBlank(sedObj.product3) && productCodeMap.containsKey(sedObj.product3)){
                    seObj.Product_3__c = productCodeMap.get(sedObj.product3);
                }
                if(String.isNotBlank(sedObj.product3Quantity)){
                    seObj.Product_3_Quantity__c = Decimal.valueOf(sedObj.product3Quantity);
                }
                if(String.isNotBlank(sedObj.product4) && productCodeMap.containsKey(sedObj.product4)){
                    seObj.Product_4__c = productCodeMap.get(sedObj.product4);
                }
                if(String.isNotBlank(sedObj.product4Quantity)){
                    seObj.Product_4_Quantity__c = Decimal.valueOf(sedObj.product4Quantity);
                }
                if(String.isNotBlank(sedObj.eventPhoto)){
                    seObj.Event_Photo__c = sedObj.eventPhoto;
                }
                if(String.isNotBlank(sedObj.eventVideo)){
                    seObj.Event_Video__c = sedObj.eventVideo;
                }
                if(String.isNotBlank(sedObj.wrmsFarmerCode)){
                    seObj.WRMS_Farmer_Code__c = sedObj.wrmsFarmerCode; 
                }
                if(String.isNotBlank(sedObj.wrmsId)){
                    seObj.WRMS_Id__c = sedObj.wrmsId; 
                }
                if(seObj!=null){
                    upsertSprayEventList.add(seObj);
                }
                
            }
            
            Schema.SObjectField wrmsId = Spray_Event__c.Fields.WRMS_Id__c;
            Database.UpsertResult[] results;
            if(upsertSprayEventList.size() > 0){
                results = Database.upsert(upsertSprayEventList, wrmsId, false);
            }
            System.debug('upsertSprayEventList: '+upsertSprayEventList);
            System.debug('results: '+results);
            
            sponse.returnSprayEventList = new List<SprayEventDetails>();
            
            if (results != null){
                Integer count = 0;
                for (Database.UpsertResult result : results) {
                    SprayEventDetails sedObj = sprayEventList[count];
                    if (!result.isSuccess()) {
                        Database.Error[] errs = result.getErrors();
                        sedObj.status = 'Error';
                        sedObj.errorMessage = String.valueOf(errs);
                        
                        for(Database.Error err : errs){
                            System.debug(err.getStatusCode() + ' - ' + err.getMessage());
                        }
                    }
                    else{
                        sedObj.sfdcId = result.getId();
                        sedObj.status = 'Success';
                    }
                    sponse.returnSprayEventList.add(sedObj);
                    count++;
                }
            }
            sponse.status = 'Success';
        }        
        catch(Exception e){
            exceptionString += 'Line No: '+e.getLineNumber()+' Exception: '+e.getMessage()+' Cause: '+e.getCause();
            ex = e;
            System.debug(exceptionString);
            sponse.status = 'Failed';
            sponse.messageDetails = exceptionString;
        }
        
        return sponse;
    }
    
    global class SprayEventDetails{
        webservice String sfdcId {get;set;}
        webservice String status {get;set;}
        webservice String errorMessage {get;set;}
        webservice String farmerCode {get;set;}
        webservice String cropCode {get;set;}
        webservice String acerage {get;set;}
        webservice String product1 {get;set;}
        webservice String product1Quantity {get;set;}
        webservice String machineCode {get;set;}
        webservice String machineOperatorCode {get;set;}
        webservice String amountCollected {get;set;}
        webservice String geolocation_Latitude {get;set;}
        webservice String geolocation_Longitude {get;set;}
        webservice String caseNumber {get;set;}
        webservice String product2 {get;set;}
        webservice String product2Quantity {get;set;}
        webservice String product3 {get;set;}
        webservice String product3Quantity {get;set;}
        webservice String product4 {get;set;}
        webservice String product4Quantity {get;set;}
        webservice String eventPhoto {get;set;}
        webservice String eventVideo {get;set;}
        webservice String wrmsFarmerCode {get;set;}         
        webservice String wrmsId {get;set;} 
    }
    
    global class ServiceResponse{
        webservice String status {get;set;} 
        webservice String messageDetails {get;set;}
        webservice List<SprayEventDetails> returnSprayEventList{get;set;}
    }
}