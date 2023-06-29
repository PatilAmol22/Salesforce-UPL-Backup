//Class for customer onboarding crown integration
//Developer-Aashima(Grazitti)
//Test-Class:-Grz_OnboardingCrownIntegration_Test
global class calloutBatchClass implements Database.Batchable<String>,   Database.AllowsCallouts {
    private String strParameter;
    private String salesAreaRecordId;
    private String crownDocumentRecordId;
    public calloutBatchClass(String strParam,String saID,String cdId) {
        strParameter = strParam;
        salesAreaRecordId=saID;
        crownDocumentRecordId=cdId;
    }
    
    public class responseClass{
        @AuraEnabled public String Barcode      {get;set;}
        @AuraEnabled public String MSg      {get;set;}
    }
    public class responseClass2{
        @AuraEnabled public String Cheque      {get;set;}
    }
    public class responseClass3{
        @AuraEnabled public String DPN      {get;set;}
    }
    public class responseClass4{
        @AuraEnabled public String Annexure      {get;set;}
    }
    public static responseClass parse(String json){
        return (responseClass) System.JSON.deserialize(json, responseClass.class);
    }
    public static responseClass2 parse2(String json){
        return (responseClass2) System.JSON.deserialize(json, responseClass2.class);
    }
    public static responseClass3 parse3(String json){
        return (responseClass3) System.JSON.deserialize(json, responseClass3.class);
    }
    public static responseClass4 parse4(String json){
        return (responseClass4) System.JSON.deserialize(json, responseClass4.class);
    }
    
    
    global List<String> start(Database.BatchableContext BC) {
        List<String> s=new List<String>{'1','2','3','4'};
            return s;
    }
    
    global void execute(Database.BatchableContext BC, List<String> scope) {         
        String endpoint;        
        System.debug('strParameter==>'+strParameter);
        System.debug('salesAreaRecordId==>'+salesAreaRecordId);
        System.debug('crownDocumentRecordId==>'+crownDocumentRecordId);
        System.debug('scope==>'+scope);
        System.debug('scope size==>'+scope.size());
        
        for(String s:scope){
            try {    
                Http http = new Http(); 
                HttpRequest req = new HttpRequest();
                req.setEndpoint('callout:Onboarding_Crown_URL/FileUpload/getDocumentByProspectno');
                req.setTimeout(120000);
                req.setHeader('Content-Type', 'application/json');
                req.setMethod('POST');
                String body = strParameter;
                req.setBody(body);
                system.debug(body);
                string sapResponse;
                
                HTTPresponse res= http.send(req);
                system.debug(res.getStatusCode());
                if(res.getStatusCode() == 200){
                    
                    sapResponse = res.getBody();
                    system.debug('response@@@@+++>'+sapResponse);
                }
                else{
                    system.debug('response@@@@+++>'+sapResponse);
                    sapResponse = 'Error_In_Crown';
                }
                
                if(sapResponse=='Error_In_Crown'){
                    List<DistributorSalesAreaMapping__c> salesAreaRecord=[Select id,Stage__c,subStage__c,Crown_File_Number__c,Crown_Response_Message__c from DistributorSalesAreaMapping__c where id = :salesAreaRecordId];
                    if(!salesAreaRecord.isEmpty()){
                        salesAreaRecord[0].Crown_File_Number__c='';
                        salesAreaRecord[0].Crown_Response_Message__c='';
                        salesAreaRecord[0].Stage__c='Crown data';
                        salesAreaRecord[0].Substage__c='Error';
                    }
                }
                else{
                    List<String> nullList=new List<String>();
                    nullList.add('');
                    nullList.add(null);
                    
                    if(s=='1'){
                        responseClass2 responseData=responseClass2.parse2(sapResponse);
                        if(!nullList.contains(responseData.Cheque)){
                            Grz_OnboardingCrownIntegration.generatePdf(responseData.Cheque,crownDocumentRecordId,'Cheque'); 
                        }
                    }
                    else if(s=='2'){
                        responseClass3 responseData=responseClass3.parse3(sapResponse);
                        if(!nullList.contains(responseData.DPN)){
                            Grz_OnboardingCrownIntegration.generatePdf(responseData.DPN,crownDocumentRecordId,'DPN');  
                        }
                    }
                    else if(s=='3'){
                        
                        responseClass4 responseData=responseClass4.parse4(sapResponse);
                        if(!nullList.contains(responseData.Annexure)){
                            Grz_OnboardingCrownIntegration.generatePdf(responseData.Annexure,crownDocumentRecordId,'Annexure');  
                        }
                    }
                    else if(s=='4'){
                        responseClass responseData=responseClass.parse(sapResponse);
                        List<DistributorSalesAreaMapping__c> salesAreaRecord=[Select id,Stage__c,subStage__c,Crown_File_Number__c,Crown_Response_Message__c from DistributorSalesAreaMapping__c where id = :salesAreaRecordId];
                        System.debug('salesAreaRecord 1==>'+salesAreaRecord);
                        if(!salesAreaRecord.isEmpty()){
                            if(!nullList.contains(responseData.MSg)){
                                System.debug('responseData.MSg==>'+responseData.MSg);
                                salesAreaRecord[0].Crown_Response_Message__c=responseData.MSg;
                                if(responseData.MSg=='Record found.'){
                                    salesAreaRecord[0].Stage__c='Crown data';
                                    salesAreaRecord[0].Substage__c='Created';
                                    if(!Approval.isLocked(salesAreaRecord[0].id)){
                                        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                                        req1.setObjectId(salesAreaRecord[0].id);
                                        req1.setSubmitterId(userinfo.getUserId()); 
                                        if(!test.isRunningTest()) req1.setProcessDefinitionNameOrId('Onboarding_Final_GBS_Approval');
                                        Approval.ProcessResult result = Approval.process(req1);
                                    }
                                    
                                }
                                else{
                                    salesAreaRecord[0].Stage__c='Crown data';
                                    salesAreaRecord[0].Substage__c='Pending';
                                }
                            }
                            if(!nullList.contains(responseData.Barcode)){
                                salesAreaRecord[0].Crown_File_Number__c=responseData.Barcode;
                            }
                            update salesAreaRecord[0];
                        }
                    }
                }
                
                
            }
            catch (Exception e) {         
                System.debug('Error:' + e.getMessage() + 'Line no:' + e.getLineNumber() );    
                String stackTrace = e.getStackTraceString().substringBefore('\n');
                String className = stackTrace.substringAfter('.').substringBefore('.');
                String methodName = stackTrace.substringBefore(':').substringAfter(className).substringAfter('.');
                User cUserInfo= grz_SapIntegration.GetUserInfo();
                Partner_Portal_Logs__c storeError = new Partner_Portal_Logs__c();
                storeError.ClassName__c = className;
                storeError.MethodName__c = methodName;
                storeError.Exception_Message__c = e.getMessage();
                storeError.Account__c = cUserInfo.accountId;
                insert storeError;
            }
        }
    }   
    
    global void finish(Database.BatchableContext BC){}
    
    
}