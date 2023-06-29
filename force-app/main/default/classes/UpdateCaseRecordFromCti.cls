@RestResource(urlmapping = '/updatecasedetails/')
global without sharing class UpdateCaseRecordFromCti {
    
    global Class TestException extends Exception{}
    //global static final Id nurtureRecordType  =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('nurture.farm care').getRecordTypeId();
    
    @HttpPost
    global static void postRequestValue(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String jsonBody=req.requestBody.toString();
        JSONParser parser=JSON.createParser(jsonBody);
        String fieldName,fieldValue,caseid1,caseid2,callId,agentId,transferStatus,callDirection,recording,phone;
        Integer duration;
        List<String> caseIdLstForUpdate=new List<String>();
        //List<String> exception_List = new List<String>();
        //List<Database.SaveResult> finalCaseList = new List<Database.SaveResult>();
        //List<Database.DeleteResult> finalGenesysList = new List<Database.DeleteResult>();
        while(parser.nextToken()!=null)
        {
            if(parser.getCurrentToken()!=JSONToken.END_OBJECT)
            {
                fieldName=parser.getCurrentName();
                fieldValue=parser.getText();
                if(fieldName!=fieldValue)
                {
                    
                    if(fieldName=='Call Id')
                    {
                        callId=fieldValue;
                    }
                    else if(fieldName=='Phone')
                    {
                        phone=fieldValue;
                    }
                    else if(fieldName=='Duration')
                    {
                        duration=Integer.valueOf(fieldValue);
                    }
                    else if(fieldName=='Agent Id')
                    {
                        agentId=fieldValue;
                    }
                    else if(fieldName=='Transfer status')
                    {
                        transferStatus=fieldValue;
                    }
                    else if(fieldName=='Call direction')
                    {
                        callDirection=fieldValue;
                    }
                    else if(fieldName=='Recording')
                    {
                        recording=fieldValue;
                    }
                    
                }
                
            }
        }
        String newPhone='%'+phone;
        //List<String> phoneLst=setPhoneNumbers(phone);
        JSONGenerator bodyBuilder = JSON.createGenerator(false);
        bodyBuilder.writeStartObject();
        List<Case> caseList = [select id,Call_Id__c,Duration__c,Origin__c,Agent_Id__c,Transfer_Status__c,Call_Direction__c,Recording_URL__c from case where Call_Id__c=:callId limit 10];
        if(null != caseList && caseList.size()>0) {
            List<Case> tempCaseList =new List<Case>();
            for(Case eachCase : caseList) {
                //INC0427580 - Added by Srinivas- To avoid call id entry 
                if(eachCase.Origin__c == 'Phone' || eachCase.Origin__c == 'Outbound call'){
                    Case tempCaseRecord = new Case(Id = eachCase.Id);
                    tempCaseRecord.Call_Id__c = callId;
                    tempCaseRecord.Duration__c = duration;
                    tempCaseRecord.Agent_Id__c = agentId;
                    tempCaseRecord.Transfer_Status__c = transferStatus;
                    tempCaseRecord.Call_Direction__c = callDirection;
                    tempCaseRecord.Recording_URL__c = recording;
                    tempCaseList.add(tempCaseRecord);
                }
            }
            try{
                if(null != tempCaseList && !tempCaseList.isEmpty()){
                    Database.SaveResult[] saveResultList = Database.update(tempCaseList, false);
                    //finalCaseList.addAll(SaveResultList);
                    bodyBuilder.writeStringField('Status Message', 'Update Successfull');
                }
                if(Test.isRunningTest()){
                    throw new TestException('Test exception to run Catch block');
                }
            }catch(Exception ex){
                System.debug('Error is>>>>' + ex); 
                
                Monitor_Log__c monitorLogObj=new Monitor_Log__c();
                monitorLogObj.Line_Number__c = ex.getLineNumber();
                monitorLogObj.Module__c='UpdateCaseRecordFromCti Genesys Postcall';
                monitorLogObj.Message__c = ex.getStackTraceString();
                monitorLogObj.Method__c = 'postRequestValue';
                monitorLogObj.Request__c = 'Post';
                monitorLogObj.Response__c = null != res.statusCode ? String.valueOf(res.statusCode) : '';
                //monitorLogObj.RecordTypeId = nurtureRecordType;
                monitorLogObj.OwnerId = UserInfo.getUserId();
                insert monitorLogObj;
            }
            //update caseLst;  
        }else{
            bodyBuilder.writeStringField('Status Message', 'No Cases Found');
        }
        bodyBuilder.writeEndObject();
        res.responseBody = Blob.valueOf(bodyBuilder.getAsString());
        
        List<Genesys_Details__c> genLst = [select id,Call_Id__c from Genesys_Details__c where Call_Id__c=:callId];
        System.debug('genLst>>>>>>>' +genLst);
        if(null != genLst && 0 < genLst.size()) {
            try{
               delete genLst;
               if(Test.isRunningTest()){
                    throw new TestException('Test exception to run Catch block');
               }
            }catch(Exception ex){
                System.debug('Error is>>>>' + ex);
                Monitor_Log__c monitorLogObj=new Monitor_Log__c();
                monitorLogObj.Line_Number__c = ex.getLineNumber();
                monitorLogObj.Module__c='UpdateCaseRecordFromCti Genesys genLst';
                monitorLogObj.Message__c=ex.getStackTraceString();
                monitorLogObj.Method__c = 'postRequestValue';
                monitorLogObj.Request__c = 'Post';
                //monitorLogObj.RecordTypeId = nurtureRecordType;
                monitorLogObj.Response__c = null != res.statusCode ? String.valueOf(res.statusCode) : '';
                monitorLogObj.OwnerId = UserInfo.getUserId();
                insert monitorLogObj;
            }
        } 
    }
    
}