/**************************************************************************************************
* Name               : Grz_PANGSTValidation                                                      
* Description        : Used for Customer Onboarding PAN and GST Validations
* Created Date       : 26/12/2022                                                                 
* Created By         : Aashima Puri (Grazitti)                                                                       
**************************************************************************************************/ 
public with sharing class Grz_PANGSTValidation {
    
    //Method to get PAN Information Aashima(Grazitti)
    @AuraEnabled
    public static String getPANData(String recordId){
        String returnString='';
        try{
            List<Account> acc=[Select id,PAN_Number__c,State_Union_Territory__c,First_Name__c,Middle_Name__c,Last_Name__c,PAN_API_Response__c,PAN_Validated__c,Type_of_PAN_Holder__c,PAN_Status__c from account where Id=:recordId];
            
            if(!acc.isEmpty()){
                if(acc[0].Pan_Validated__c==true){
                    returnString='PAN details are already validated';
                }
                else if(acc[0].PAN_Number__c==null){
                    returnString='Kindly enter PAN Number before validating';
                }
                else{
                    HTTPresponse authTokenResponse=generateAuthToken();
                    System.debug('authTokenResponse==>'+authTokenResponse);
                    if(authTokenResponse.getStatusCode()==200){
                        Map<String, Object> response= ( Map<String, Object>)JSON.deserializeUntyped(authTokenResponse.getBody());
                        Object token = (Object)response.get('id');
                        System.debug('token==>'+token);
                        
                        Object userId = (Object)response.get('userId');
                        System.debug('userId==>'+userId);
                        if(token!=null && userId!=null){
                            HTTPresponse panresponse=validatePAN(token.toString(),userId.toString(),acc[0].PAN_Number__c);
                            if(panresponse.getStatusCode()==200){
                                Map<String, Object> responseapiPan= ( Map<String, Object>)JSON.deserializeUntyped(panresponse.getBody());
                                Map<String, Object> a = (Map<String, Object>)responseapiPan.get('result');
                                System.debug('responseapiPan==>'+a.get('firstName').toString());
                                acc[0].PAN_API_Response__c=panresponse.getBody();
                                acc[0].First_Name__c = a.get('firstName').toString();
                                acc[0].Middle_Name__c=a.get('middleName').toString();
                                acc[0].Last_Name__c=a.get('lastName').toString();
                                acc[0].PAN_Validated__c=true;
                                acc[0].Type_of_PAN_Holder__c=a.get('typeOfHolder').toString();
                                acc[0].PAN_Status__c=a.get('panStatus').toString();
                                update acc[0];
                                returnString='PAN validated successfully';
                            }
                            else{
                                String s=panresponse.getBody().stripHTMLTags().split('status:')[0];
                                String statusCode=String.valueOf(panresponse.getStatusCode());
                                List<String> resList=s.split(statusCode);
                                if(!resList.isEmpty() && resList.size()>1){
                                    returnString=s.split(statusCode)[1].trim();
                                }
                                else{
                                    returnString='Error in PAN validation';
                                }
                            }
                        }
                        else{
                            returnString='Token generation was not successful';
                        }
                    }
                    else{
                        returnString='Token generation was not successful';
                    }
                    System.debug('returnString==>'+returnString);
                }
            }
        }catch(Exception ex) {
            returnString = ex.getMessage();
        }
        return returnString;
    }
    
    //Method to get GST Information Aashima(Grazitti)
    @AuraEnabled
    public static String getGSTData(String recordId){
        String returnString='';
        try{
            List<Account> acc=[Select id,PAN_Number__c,State_Union_Territory__c,PAN_Validated__c,Name,Tax_Number_3__c,GST_Status__c,Constitution_of_Business__c,GST_Validated__c,Billing_Street_2__c,BillingStreet,BillingCity,BillingPostalCode,BillingCountry,BillingState,Non_Gst_Customer__c from account where Id=:recordId];
            
            if(!acc.isEmpty()){
                if(acc[0].GST_Validated__c==true){
                    returnString='GST details are already validated';
                }
                else if(acc[0].PAN_Number__c==null || acc[0].State_Union_Territory__c==null){
                    returnString='Kindly enter PAN Number and State/Union Territory before validating';
                }
                else if(acc[0].PAN_Validated__c==false){
                    returnString='Kindly validate PAN before getting GST details';
                }
                else{
                    HTTPresponse authTokenResponse=generateAuthToken();
                    System.debug('authTokenResponse==>'+authTokenResponse);
                    if(authTokenResponse.getStatusCode()==200){
                        Map<String, Object> response= ( Map<String, Object>)JSON.deserializeUntyped(authTokenResponse.getBody());
                        Object token = (Object)response.get('id');
                        System.debug('token==>'+token);
                        
                        Object userId = (Object)response.get('userId');
                        System.debug('userId==>'+userId);
                        if(token!=null && userId!=null){
                            String stateName=acc[0].State_Union_Territory__c;
                            if(stateName=='Chhattisgarh'){
                                stateName='Chattisgarh';
                            }
                            else if(stateName=='Andhra Pradesh'){
                                stateName='Andhra Pradesh (New)';
                            }
                            HTTPresponse gstresponse=validateGST(token.toString(),userId.toString(),acc[0].PAN_Number__c,stateName);
                            if(gstresponse.getStatusCode()==200){
                                Map<String, Object> responseapiGST= ( Map<String, Object>)JSON.deserializeUntyped(gstresponse.getBody());
                                Map<String, Object> result = (Map<String, Object>)responseapiGST.get('result');
                                System.debug('result==>'+result);
                                List<Object> gstnDetailed = (List<Object>)result.get('gstnDetailed');
                                //Getting first active GST or first entry if active GST is not available in response
                                if(!gstnDetailed.isEmpty()){
                                    Map<String, Object> gstConsider=(Map<String, Object>)gstnDetailed[0];
                                    for(Object oo:gstnDetailed){
                                        System.debug('oo==>'+oo);
                                        Map<String, Object> gstdetails=(Map<String, Object>)oo;
                                        if('ACTIVE'==gstdetails.get('gstinStatus').toString().toUpperCase()){
                                            gstConsider=gstdetails;
                                            break;
                                        }
                                    }
                                    if(gstConsider.size()>0){
                                        System.debug('gstConsider==>'+gstConsider);
                                        acc[0].GST_API_response__c=gstresponse.getBody();
                                        acc[0].GST_Validated__c=true;
                                        acc[0].Tax_Number_3__c = gstConsider.get('gstin').toString();
                                        acc[0].Name = gstConsider.get('tradeNameOfBusiness').toString();
                                        acc[0].GST_Status__c = gstConsider.get('gstinStatus').toString();
                                        acc[0].Constitution_of_Business__c = gstConsider.get('constitutionOfBusiness').toString();
                                        acc[0].Non_Gst_Customer__c=false;
                                        acc[0].BillingPostalCode=gstConsider.get('principalPlacePincode').toString();
                                        String city=gstConsider.get('principalPlaceCity').toString();
                                        if(city=='' || city==null){
                                            acc[0].BillingCity=gstConsider.get('principalPlaceDistrict').toString();
                                        }
                                        else{
                                            acc[0].BillingCity=city;
                                        }
                                        String street=gstConsider.get('principalPlaceStreet').toString();
                                        acc[0].BillingStreet=street;
                                        acc[0].Billing_Street_2__c=gstConsider.get('principalPlaceAddress').toString().split(street)[0];
                                        
                                        acc[0].BillingState=gstConsider.get('principalPlaceState').toString();
                                        
                                        Map<String, Object> resultCountry = (Map<String, Object>)gstConsider.get('principalPlaceSplitAddress');
                                        List<Object> countryList = (List<Object>)resultCountry.get('country');
                                        if(!countryList.isEmpty())
                                            acc[0].BillingCountry=countryList[0].toString();
                                        
                                        update acc[0];
                                        List<String> gstStatusList=System.Label.Grz_GSTStatus.split(',');
                                        if(gstStatusList.contains(gstConsider.get('gstinStatus').toString())){
                                            returnString='Non GST Status';
                                        }
                                        else{
                                            returnString='GST validated successfully';
                                        }
                                    }
                                }
                                else{
                                    returnString='No valid GST found';
                                }
                            }
                            else{
                                String s=gstresponse.getBody().stripHTMLTags().split('status:')[0];
                                String statusCode=String.valueOf(gstresponse.getStatusCode());
                                List<String> resList=s.split(statusCode);
                                if(!resList.isEmpty() && resList.size()>1){
                                    returnString=s.split(statusCode)[1].trim();
                                }
                                else{
                                    returnString='Error in GST validation';
                                }
                            }
                        }
                        else{
                            returnString='Token generation was not successful';
                        }
                    }
                    else{
                        returnString='Token Generation was not successful';
                    }
                    
                }
            }
        }catch(Exception ex) {
            returnString = ex.getMessage();
            System.debug('Exception==>'+ex.getStackTraceString());
        }
        return returnString;
    }
    
    //Method to get PAN GST APIs Auth Token Aashima(Grazitti)
    public static HTTPresponse generateAuthToken(){
        Http http = new Http(); 
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:PAN_GST_APIs/login');
        request.setTimeout(120000);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        Map<String, PAN_GST_API_Creds__c> mcs = PAN_GST_API_Creds__c.getAll();
        PAN_GST_API_Creds__c settingDetails=PAN_GST_API_Creds__c.getValues('PAN GST Auth Creds');
        String username=settingDetails.username__c;
        String password=settingDetails.password__c;
        String body = '{ \"username\": \"'+username+'\",  \"password\": \"'+password+'\" }';
        request.setBody(body);
        system.debug('request==>'+request.getEndpoint());
        HTTPresponse res = http.send( request );
        System.debug('response==>'+res);
        return res;
    }
    
    //Method to hit PAN API Aashima(Grazitti)
    public static HTTPresponse validatePAN(String token,String userId,String panNumber){
        Http http = new Http(); 
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:PAN_GST_APIs/'+userId+'/panv2');
        request.setTimeout(120000);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Authorization', token);
        String body = '{ \"task\": [\"1\"],  \"essentials\": {\"number\": \"'+panNumber+'\"}}';
        request.setBody(body);
        system.debug('request==>'+request.getEndpoint());
        HTTPresponse res = http.send( request );
        System.debug('res.getBody()==>'+res.getBody());
        System.debug('res.getStatus()==>'+res.getStatus());
        System.debug('res.toString()==>'+res.toString());
        
        return res;
    }
    public static HTTPresponse validateGST(String token,String userId,String panNumber,String stateVal){
        Http http = new Http(); 
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:PAN_GST_APIs/'+userId+'/gstns');
        request.setTimeout(120000);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Authorization', token);
        String body = '{ \"task\": \"panSearch\",  \"essentials\": {\"panNumber\": \"'+panNumber+'\" , \"state\": \"'+stateVal+'\"}}';
        request.setBody(body);
        system.debug('request==>'+request.getEndpoint());
        HTTPresponse res = http.send( request );
        System.debug('res.getBody()==>'+res.getBody().stripHTMLTags());
        System.debug('res.getStatus()==>'+res.getStatus());
        System.debug('res.toString()==>'+res.toString());
        
        return res;
    }
    public static HTTPresponse validateGST2(String token,String userId,String gstIn){
        //BOAPR9377A======***********=======Punjab
        //gstIn='03AAECI6388L1Z6';
        //stateVal='Haryana';
        Http http = new Http(); 
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:PAN_GST_APIs/'+userId+'/gstns');
        request.setTimeout(120000);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Authorization', token);
        String body = '{ \"task\": \"gstinSearch\",  \"essentials\": {\"gstin\": \"'+gstin+'\"}}';
        request.setBody(body);
        system.debug('request==>'+request.getEndpoint());
        HTTPresponse res = http.send( request );
        System.debug('res.getBody()==>'+res.getBody().stripHTMLTags());
        System.debug('res.getStatus()==>'+res.getStatus());
        //System.debug('res.toString()==>'+res.toString());
        //System.debug('********gstw22222**********==>'+JSON.serializePretty(JSON.deserializeUntyped(res.getBody())));
        
        return res;
    }
    @AuraEnabled
    public static String updateNonGST(String recordId){
        String returnString='';
        try{
            List<Account> acc=[Select id,Non_GST_Customer__c from account where Id=:recordId];
            if(!acc.isEmpty()){
                acc[0].Non_GST_Customer__c=true;
                update acc[0];
                returnString='Customer Updated successfully';
            }
        }
        catch(Exception ex) {
            returnString = ex.getMessage();
        }
        return returnString;
        
    }
    
    //Method to get GST Information Aashima(Grazitti)
    @AuraEnabled
    public static String getGSTDataAgain(String recordId,String gstNumber){
        String returnString='';
        try{
            HTTPresponse authTokenResponse=generateAuthToken();
            System.debug('authTokenResponse==>'+authTokenResponse);
            if(authTokenResponse.getStatusCode()==200){
                Map<String, Object> response= ( Map<String, Object>)JSON.deserializeUntyped(authTokenResponse.getBody());
                Object token = (Object)response.get('id');
                System.debug('token==>'+token);
                
                Object userId = (Object)response.get('userId');
                System.debug('userId==>'+userId);
                if(token!=null && userId!=null){
                    HTTPresponse gstresponse=validateGST2(token.toString(),userId.toString(),gstNumber);
                    System.debug('gstresponse==>'+gstresponse);
                    if(gstresponse.getStatusCode()==200){
                        Map<String, Object> responseapiGST= ( Map<String, Object>)JSON.deserializeUntyped(gstresponse.getBody());
                        Map<String, Object> result = (Map<String, Object>)responseapiGST.get('result');
                        System.debug('result==>'+result);
                        Map<String, Object> gstConsider=(Map<String, Object>)result.get('gstnDetailed');
                        
                        if(gstConsider.size()>0){
                            //Account acc=new Account(id=recordId);
                            List<Account> acc=[Select id,PAN_Number__c,State_Union_Territory__c,PAN_Validated__c,Name,Tax_Number_3__c,GST_Status__c,Constitution_of_Business__c,GST_Validated__c,Billing_Street_2__c,BillingStreet,BillingCity,BillingPostalCode,BillingCountry,BillingState,Non_Gst_Customer__c from account where Id=:recordId];
                            System.debug('gstConsider==>'+gstConsider);
                            if(!acc.isEmpty()){
                                if(acc[0].State_Union_Territory__c.toUpperCase()==gstConsider.get('principalPlaceState').toString().toUpperCase()){
                                    acc[0].GST_API_response__c=gstresponse.getBody();
                                    acc[0].GST_Validated__c=true;
                                    acc[0].Tax_Number_3__c = result.get('gstin').toString();
                                    acc[0].Name = gstConsider.get('tradeNameOfBusiness').toString();
                                    acc[0].GST_Status__c = gstConsider.get('gstinStatus').toString();
                                    acc[0].Constitution_of_Business__c = gstConsider.get('constitutionOfBusiness').toString();
                                    acc[0].Non_Gst_Customer__c=false;
                                    acc[0].BillingPostalCode=gstConsider.get('principalPlacePincode').toString();
                                    String city=gstConsider.get('principalPlaceCity').toString();
                                    if(city=='' || city==null){
                                        acc[0].BillingCity=gstConsider.get('principalPlaceDistrict').toString();
                                    }
                                    else{
                                        acc[0].BillingCity=city;
                                    }
                                    String street=gstConsider.get('principalPlaceStreet').toString();
                                    acc[0].BillingStreet=street;
                                    acc[0].Billing_Street_2__c=gstConsider.get('principalPlaceAddress').toString().split(street)[0];
                                    
                                    acc[0].BillingState=gstConsider.get('principalPlaceState').toString();
                                    
                                    Map<String, Object> resultCountry = (Map<String, Object>)gstConsider.get('principalPlaceSplitAddress');
                                    List<Object> countryList = (List<Object>)resultCountry.get('country');
                                    if(!countryList.isEmpty())
                                        acc[0].BillingCountry=countryList[0].toString();
                                    
                                    
                                    List<String> gstStatusList=System.Label.Grz_GSTStatus.split(',');
                                    if(gstStatusList.contains(gstConsider.get('gstinStatus').toString())){
                                        acc[0].Non_Gst_Customer__c=true;
                                    }
                                    
                                    returnString='GST validated successfully';
                                    
                                    update acc[0];
                                }
                                else{
                                    returnString='Entered GST is not under the State/Union Territory on account';
                                }
                                
                                
                            }
                            else{
                                returnString='No valid account found';
                            }
                        }
                        else{
                            returnString='No valid GST found';
                        }
                    }
                    else{
                        String s=gstresponse.getBody().stripHTMLTags().split('status:')[0];
                        String statusCode=String.valueOf(gstresponse.getStatusCode());
                        System.debug('gstresponse s==>'+s);
                        List<String> resList=s.split(statusCode);
                        System.debug('resList==>'+resList);
                        if(!resList.isEmpty() && resList.size()>1){
                            returnString=s.split(statusCode)[1].trim();
                        }
                        else{
                            returnString='Error in GST validation';
                        }
                    }
                }
                else{
                    returnString='Token generation was not successful';
                }
            }
            else{
                returnString='Token Generation was not successful';
            }
            
        }
        catch(Exception ex) {
            returnString = ex.getMessage();
            System.debug('Exception==>'+ex.getStackTraceString());
        }
        return returnString;
    }
}