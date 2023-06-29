global class FarmerUploadService {
    webservice static ServiceResponse uploadAccounts(List<FarmerDetails> farmerList) {
        
        Map<String, ID> VillageMap = new Map<String, ID>();
        for(Village__c villObj : [SELECT Id, Territory__c, Village_Code__c FROM Village__c]){
            if(villObj.Village_Code__c !=  null){
                VillageMap.put(villObj.Village_Code__c, villObj.Id);
            }
        } 
        
        ServiceResponse sponse = new ServiceResponse();
        String exceptionString = '';
        Exception ex;
        
        try{
            //Id distributorRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
            List<Account> upsertFarmerList = new List<Account>();
            
            for(FarmerDetails fmObj:farmerList){
                
                Account accObj = new Account();
                if(String.isNotBlank(fmObj.firstName)){
                    accObj.FirstName = fmObj.firstName;
                }
                if(String.isNotBlank(fmObj.lastName)){
                    accObj.LastName = fmObj.lastName;
                }
                if(String.isNotBlank(fmObj.billingStreet)){
                    accObj.BillingStreet = fmObj.billingStreet;
                }
                if(String.isNotBlank(fmObj.billingCity)){
                    accObj.BillingCity = fmObj.billingCity;
                }
                if(String.isNotBlank(fmObj.billingState)){
                    accObj.BillingState = fmObj.billingState;
                }
                if(String.isNotBlank(fmObj.billingPostalCode)){
                    accObj.BillingPostalCode = fmObj.billingPostalCode;
                }
                if(String.isNotBlank(fmObj.billingCountry)){
                    accObj.BillingCountry = fmObj.billingCountry;
                }
                if(String.isNotBlank(fmObj.email)){
                    accObj.PersonEmail = fmObj.email;
                }
                if(String.isNotBlank(fmObj.mobile)){
                    accObj.PersonMobilePhone = fmObj.mobile;
                }
                if(String.isNotBlank(fmObj.phone)){
                    accObj.Phone = fmObj.phone;
                }
                if(String.isNotBlank(fmObj.accountRecordType)){
                    accObj.RecordTypeId = fmObj.accountRecordType; 
                }
                if(VillageMap.containsKey(fmObj.villageCode)){
                    accObj.Village__pc = VillageMap.get(fmObj.villageCode);
                }
                /*if(String.isNotBlank(fmObj.farmerCode)){
                accObj.Farmer_Code__pc = fmObj.farmerCode;
                }*/
                if(String.isNotBlank(fmObj.wrmsCode)){
                    accObj.WRMS_Code__c = fmObj.wrmsCode;
                }
                if(accObj!=null){
                    upsertFarmerList.add(accObj);
                }
            }
            
            //Schema.SObjectField wrmsCode = Account.Fields.WRMS_Code__c;
            Database.UpsertResult[] results;
            if(upsertFarmerList.size() > 0){
                results = Database.upsert(upsertFarmerList, false);
            }
            System.debug('upsertFarmerList: '+upsertFarmerList);
            System.debug('results: '+results);
            List<FarmerDetails> farmerTempList = new List<FarmerDetails>();
            sponse.returnFarmerList = new List<FarmerDetails>();
            
            if (results != null){
                Integer count = 0;
                for (Database.UpsertResult result : results) {
                    FarmerDetails fmObj = farmerList[count];
                    if (!result.isSuccess()) {
                        Database.Error[] errs = result.getErrors();
                        fmObj.status = 'Error';
                        fmObj.errorMessage = String.valueOf(errs);
                        
                        for(Database.Error err : errs){
                            System.debug(err.getStatusCode() + ' - ' + err.getMessage());
                        }
                    }
                    else{
                        fmObj.sfdcId = result.getId();
                        fmObj.status = 'Success';
                    }
                    //sponse.returnFarmerList.add(fmObj);
                    farmerTempList.add(fmObj);
                    count++;
                }
            }
            List<Account> accList = [Select Id,SAP_Code__c, Farmer_Code__pc From Account WHERE ID IN:upsertFarmerList];
            Map<Id, String> farmerCodeMap = new Map<id, String>();
            for(Account accObj:accList){
                farmerCodeMap.put(accObj.Id,accObj.Farmer_Code__pc);
            }
            for(FarmerDetails fmObj:farmerTempList){
                if(farmerCodeMap.containsKey(fmObj.sfdcid)){
                    fmObj.farmerCode = farmerCodeMap.get(fmObj.sfdcid);
                }
                sponse.returnFarmerList.add(fmObj);
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
    
    global class FarmerDetails{
        webservice String sfdcId {get;set;}
        webservice String status {get;set;}
        webservice String errorMessage {get;set;}
        webservice String firstName {get;set;}
        webservice String lastName {get;set;}
        webservice String billingStreet {get;set;}
        webservice String billingCity {get;set;}
        webservice String billingState {get;set;}
        webservice String billingPostalCode {get;set;}
        webservice String billingCountry {get;set;}
        webservice String email {get;set;}
        webservice String mobile {get;set;}
        webservice String phone {get;set;}
        webservice String villageCode {get;set;}
        webservice String farmerCode {get;set;}
        webservice String wrmsCode {get;set;}
        webservice String accountRecordType {get;set;}                  
    }
    
    global class ServiceResponse{
        webservice String status {get;set;} 
        webservice String messageDetails {get;set;}
        webservice List<FarmerDetails> returnFarmerList{get;set;}
    }
}