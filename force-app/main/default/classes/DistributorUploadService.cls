global class DistributorUploadService {
    webservice static ServiceResponse uploadAccounts(List<DistributorDetails> distributorList) {
        
        ServiceResponse sponse = new ServiceResponse();
        String exceptionString = '';
        Exception ex;
        
        try{

            Id distributorRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
             
            List<Account> upsertDistributorList = new List<Account>();
            
            for(DistributorDetails ddObj:distributorList){
                
                Account accObj = new Account();

                if(String.isNotBlank(ddObj.lastName)){
                    accObj.LastName = ddObj.lastName;
                }
                if(String.isNotBlank(ddObj.billingStreet)){
                    accObj.BillingStreet = ddObj.billingStreet;
                }
                if(String.isNotBlank(ddObj.billingCity)){
                    accObj.BillingCity = ddObj.billingCity;
                }
                if(String.isNotBlank(ddObj.billingState)){
                    accObj.BillingState = ddObj.billingState;
                }
                if(String.isNotBlank(ddObj.billingPostalCode)){
                    accObj.BillingPostalCode = ddObj.billingPostalCode;
                }
                if(String.isNotBlank(ddObj.billingCountry)){
                    accObj.BillingCountry = ddObj.billingCountry;
                }
                if(String.isNotBlank(ddObj.email)){
                    accObj.PersonEmail = ddObj.email;
                }
                if(String.isNotBlank(ddObj.mobile)){
                    accObj.PersonMobilePhone = ddObj.mobile;
                }
                if(String.isNotBlank(ddObj.phone)){
                    accObj.Phone = ddObj.phone;
                }
                if(String.isNotBlank(ddObj.salesOffice)){
                    accObj.Sales_Office__c = ddObj.salesOffice;
                }
                if(String.isNotBlank(ddObj.plant)){
                    accObj.Plant__c = ddObj.plant;
                }
                if(String.isNotBlank(ddObj.distributorCode)){
                    accObj.SAP_Code__c = ddObj.distributorCode;
                }
                if(String.isNotBlank(ddObj.accountRecordType)){
                    accObj.RecordTypeId = ddObj.accountRecordType; 
                }
                
                if(accObj!=null){
                    upsertDistributorList.add(accObj);
                }
                
            }
            
            Schema.SObjectField sapCode = Account.Fields.SAP_Code__c;
            Database.UpsertResult[] results;
            if(upsertDistributorList.size() > 0){
                results = Database.upsert(upsertDistributorList, sapCode, false);
            }
            System.debug('upsertDistributorList: '+upsertDistributorList);
            System.debug('results: '+results);
            
            sponse.returnDistributorList = new List<DistributorDetails>();
            
            if (results != null){
                Integer count = 0;
                for (Database.UpsertResult result : results) {
                    DistributorDetails ddObj = distributorList[count];
                    if (!result.isSuccess()) {
                        Database.Error[] errs = result.getErrors();
                        ddObj.status = 'Error';
                        ddObj.errorMessage = String.valueOf(errs);
                        
                        for(Database.Error err : errs){
                            System.debug(err.getStatusCode() + ' - ' + err.getMessage());
                        }
                    }
                    else{
                        ddObj.sfdcId = result.getId();
                        ddObj.status = 'Success';
                    }
                    sponse.returnDistributorList.add(ddObj);
                    count++;
                }
            }
        }        
        catch(Exception e){
            exceptionString += 'Line No: '+e.getLineNumber()+' Exception: '+e.getMessage()+' Cause: '+e.getCause();
            ex = e;
            System.debug(exceptionString);
            sponse.status = 'Failed';
            sponse.messageDetails = exceptionString;
        }
        sponse.status = 'Success';
        return sponse;
    }
    
    global class DistributorDetails{
        webservice String sfdcId {get;set;}
        webservice String status {get;set;}
        webservice String errorMessage {get;set;}
        webservice String lastName {get;set;}
        webservice String billingStreet {get;set;}
        webservice String billingCity {get;set;}
        webservice String billingState {get;set;}
        webservice String billingPostalCode {get;set;}
        webservice String billingCountry {get;set;}
        webservice String email {get;set;}
        webservice String mobile {get;set;}
        webservice String phone {get;set;}
        webservice String salesOffice {get;set;}
        webservice String plant {get;set;}
        webservice String distributorCode {get;set;}	
        webservice String accountRecordType {get;set;}					
    }
    
    global class ServiceResponse{
        webservice String status {get;set;} 
        webservice String messageDetails {get;set;}
        webservice List<DistributorDetails> returnDistributorList{get;set;}
    }
}