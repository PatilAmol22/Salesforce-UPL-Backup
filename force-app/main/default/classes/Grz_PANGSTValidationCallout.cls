/**************************************************************************************************
* Name             : Grz_PANGSTValidationCallout                                                     
* Description      : To cover the Apex class Grz_PANGSTValidation
* Created Date     : 28-12-2022                                                                        
* Project/JIRA     : APPS-2662                                                                        
* Created By       : Mohit Garg (Grazitti)                                                                        
* Last Modified By : Mohit Garg (Grazitti) 28-12-2022                                                                        
**************************************************************************************************/
@isTest
global class Grz_PANGSTValidationCallout implements HttpCalloutMock {

    Boolean  isMockResponseSuccessful;  // set by constructor, used to vary the mockresponse
    
    public Grz_PANGSTValidationCallout(Boolean isMockResponseSuccessful) {
        this.isMockResponseSuccessful  = isMockResponseSuccessful;
    }
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        
        //For authorization (Apex test class = Grz_PANGSTValidationTest)
            if(req.getMethod() == 'POST' && req.getEndpoint().contains('callout:PAN_GST_APIs/login')){
                res.setHeader('Content-Type', 'application/json');
                res.setBody('{"id":"HlTga3fXgbv6jxXEri7P2FhfoQp6MbBWGRjQsBdDw2u3QROfPgGVlqni84OhGc7Q","ttl":31556926,"created":"2022-12-28T12:26:44.360Z","userId":"637f71f4a6d6bc0153cd1cc0"}');
                res.setStatusCode(200);
                }
             
          //Test by Param
          if(req.getMethod() == 'POST' && req.getEndpoint().contains('callout:Onboarding_Crown_URL/FileUpload/getDocumentByProspectno')){
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{ "Cheque":"Record"},{ "Annexure":"Test"},{"User_Token":"teswt1234tocken"}');
            res.setStatusCode(200);
        }
          //Test by param             
        //For PAN Verification API
            if(req.getMethod() == 'POST' && req.getEndpoint().contains('panv2')){
                res.setHeader('Content-Type', 'application/json');
                res.setBody('{"essentials":{"number":"BOAPR9377A"},"id":"63808631854ab40103009375","patronId":"637f71f4a6d6bc0153cd1cc0","task":["1"],"result":{"name":"MEENU RANI","number":"BOAPR9377A","typeOfHolder":"Individual or Person","isIndividual":true,"isValid":true,"firstName":"MEENU","middleName":"","lastName":"RANI","title":"Kumari","panStatus":"VALID","panStatusCode":"E","aadhaarSeedingStatus":"Successful","aadhaarSeedingStatusCode":"Y","lastUpdatedOn":"06/12/2020"}}');
                res.setStatusCode(210);
                }
                 
         //GST Verification API
               if(req.getMethod() == 'POST' && req.getEndpoint().contains('gstns') && req.getBody().contains('panSearch')){
                res.setHeader('Content-Type', 'application/json');
                res.setBody('{"task":"panSearch","essentials":{"panNumber":"BOAPR9377A","state":"Bihar"},"id":"63c68e0bd7110f00778321af","patronId":"637f71f4a6d6bc0153cd1cc0","result":{"gstnDetailed":[{"constitutionOfBusiness":"ANY OTHER BODY NOTIFIED BY COMMITTEE","legalNameOfBusiness":"ANDHRA BANK","tradeNameOfBusiness":"ANDHRA BANK","centreJurisdiction":"COMMISSIONERATE - SHILLONG,DIVISION - SHILLONG II DIVISION,RANGE - JOWAI I RANGE (JURISDICTIONAL OFFICE)","stateJurisdiction":"STATE - MEGHALAYA,HEADQUARTER - HEAD QUARTER,CIRCLE - CIRCLE-VIII","registrationDate":"01/10/2018","taxPayerDate":"","taxPayerType":"TAX DEDUCTOR","gstinStatus":"ACTIVE","cancellationDate":"","natureOfBusinessActivities":[],"principalPlaceAddress":"THE ARCADE 1ST FLOOR,SHILLONG,EAST KHASI HILLS,EAST KHASI HILLS,MEGHALAYA,793001","principalPlaceLatitude":"","principalPlaceLongitude":"","principalPlaceBuildingNameFromGST":"THE ARCADE","principalPlaceBuildingNoFromGST":"1ST FLOOR,","principalPlaceFlatNo":"","principalPlaceStreet":"SHILLONG","principalPlaceLocality":"EAST KHASI HILLS","principalPlaceCity":"","principalPlaceDistrict":"EAST KHASI HILLS","principalPlaceState":"MEGHALAYA","principalPlacePincode":"793001","additionalPlaceAddress":"","additionalPlaceLatitude":"","additionalPlaceLongitude":"","additionalPlaceBuildingNameFromGST":"","additionalPlaceBuildingNoFromGST":"","additionalPlaceFlatNo":"","additionalPlaceStreet":"","additionalPlaceLocality":"","additionalPlaceCity":"","additionalPlaceDistrict":"","additionalPlaceState":"","additionalPlacePincode":"","additionalAddressArray":[],"lastUpdatedDate":"","principalPlaceSplitAddress":{"district":["EAST KHASI HILLS"],"state":[["MEGHALAYA","ML"]],"city":["SHILLONG"],"pincode":"793001","country":["IN","IND","INDIA"],"addressLine":"THE ARCADE 1ST FLOOR"},"additionalPlaceSplitAddress":{"district":[],"state":[[]],"city":[],"pincode":"","country":["IN","IND","INDIA"],"addressLine":""}},{"constitutionOfBusiness":"ANY OTHER BODY NOTIFIED BY COMMITTEE","legalNameOfBusiness":"ANDHRA BANK","tradeNameOfBusiness":"ANDHRA BANK","centreJurisdiction":"COMMISSIONERATE - SHILLONG,DIVISION - SHILLONG II DIVISION,RANGE - JOWAI I RANGE (JURISDICTIONAL OFFICE)","stateJurisdiction":"STATE - MEGHALAYA,HEADQUARTER - HEAD QUARTER,CIRCLE - CIRCLE-VIII","registrationDate":"01/10/2018","taxPayerDate":"","taxPayerType":"TAX DEDUCTOR","gstinStatus":"ACTIVE","cancellationDate":"","natureOfBusinessActivities":[],"principalPlaceAddress":"THE ARCADE 1ST FLOOR,SHILLONG,EAST KHASI HILLS,EAST KHASI HILLS,MEGHALAYA,793001","principalPlaceLatitude":"","principalPlaceLongitude":"","principalPlaceBuildingNameFromGST":"THE ARCADE","principalPlaceBuildingNoFromGST":"1ST FLOOR,","principalPlaceFlatNo":"","principalPlaceStreet":"SHILLONG","principalPlaceLocality":"EAST KHASI HILLS","principalPlaceCity":"","principalPlaceDistrict":"EAST KHASI HILLS","principalPlaceState":"MEGHALAYA","principalPlacePincode":"793001","additionalPlaceAddress":"","additionalPlaceLatitude":"","additionalPlaceLongitude":"","additionalPlaceBuildingNameFromGST":"","additionalPlaceBuildingNoFromGST":"","additionalPlaceFlatNo":"","additionalPlaceStreet":"","additionalPlaceLocality":"","additionalPlaceCity":"","additionalPlaceDistrict":"","additionalPlaceState":"","additionalPlacePincode":"","additionalAddressArray":[],"lastUpdatedDate":"","principalPlaceSplitAddress":{"district":["EAST KHASI HILLS"],"state":[["MEGHALAYA","ML"]],"city":["SHILLONG"],"pincode":"793001","country":["IN","IND","INDIA"],"addressLine":"THE ARCADE 1ST FLOOR"},"additionalPlaceSplitAddress":{"district":[],"state":[[]],"city":[],"pincode":"","country":["IN","IND","INDIA"],"addressLine":""}}],"gstnRecords":[{"applicationStatus":"","registrationName":"ANDHRA BANK","mobNum":"","regType":"","emailId":"","tinNumber":"","gstinRefId":"","gstin":"17AABCA7375C1D3"}],"gstin":"17AABCA7375C1D3"}}');
                res.setStatusCode(210);
                } 
        //For PAN To GST API
            if(req.getMethod() == 'POST' && req.getEndpoint().contains('gstns') && req.getBody().contains('panToGstList')){
                res.setHeader('Content-Type', 'application/json');
                res.setBody('{"task":"panSearch","essentials":{"panNumber":"BOAPR9377A","state":"Bihar"},"id":"63c68e0bd7110f00778321af","patronId":"637f71f4a6d6bc0153cd1cc0","result":{"gstnDetailed":[{"constitutionOfBusiness":"ANY OTHER BODY NOTIFIED BY COMMITTEE","legalNameOfBusiness":"ANDHRA BANK","tradeNameOfBusiness":"ANDHRA BANK","centreJurisdiction":"COMMISSIONERATE - SHILLONG,DIVISION - SHILLONG II DIVISION,RANGE - JOWAI I RANGE (JURISDICTIONAL OFFICE)","stateJurisdiction":"STATE - MEGHALAYA,HEADQUARTER - HEAD QUARTER,CIRCLE - CIRCLE-VIII","registrationDate":"01/10/2018","taxPayerDate":"","taxPayerType":"TAX DEDUCTOR","gstinStatus":"ACTIVE","cancellationDate":"","natureOfBusinessActivities":[],"principalPlaceAddress":"THE ARCADE 1ST FLOOR,SHILLONG,EAST KHASI HILLS,EAST KHASI HILLS,MEGHALAYA,793001","principalPlaceLatitude":"","principalPlaceLongitude":"","principalPlaceBuildingNameFromGST":"THE ARCADE","principalPlaceBuildingNoFromGST":"1ST FLOOR,","principalPlaceFlatNo":"","principalPlaceStreet":"SHILLONG","principalPlaceLocality":"EAST KHASI HILLS","principalPlaceCity":"","principalPlaceDistrict":"EAST KHASI HILLS","principalPlaceState":"MEGHALAYA","principalPlacePincode":"793001","additionalPlaceAddress":"","additionalPlaceLatitude":"","additionalPlaceLongitude":"","additionalPlaceBuildingNameFromGST":"","additionalPlaceBuildingNoFromGST":"","additionalPlaceFlatNo":"","additionalPlaceStreet":"","additionalPlaceLocality":"","additionalPlaceCity":"","additionalPlaceDistrict":"","additionalPlaceState":"","additionalPlacePincode":"","additionalAddressArray":[],"lastUpdatedDate":"","principalPlaceSplitAddress":{"district":["EAST KHASI HILLS"],"state":[["MEGHALAYA","ML"]],"city":["SHILLONG"],"pincode":"793001","country":["IN","IND","INDIA"],"addressLine":"THE ARCADE 1ST FLOOR"},"additionalPlaceSplitAddress":{"district":[],"state":[[]],"city":[],"pincode":"","country":["IN","IND","INDIA"],"addressLine":""}}],"gstnRecords":[{"applicationStatus":"","registrationName":"ANDHRA BANK","mobNum":"","regType":"","emailId":"","tinNumber":"","gstinRefId":"","gstin":"17AABCA7375C1D3"}],"gstin":"17AABCA7375C1D3"}}');
                res.setStatusCode(210);
                }
                  
        
        if(req.getMethod() == 'POST' && req.getEndpoint().contains('gstns') && req.getBody().contains('gstinSearch')){
                res.setHeader('Content-Type', 'application/json');
                res.setBody('{"task":"gstinSearch","essentials":{"gstin":"17AABCA7375C1D3"},"id":"63c68e0bd7110f00778321af","patronId":"637f71f4a6d6bc0153cd1cc0","result":{"gstnDetailed":{"constitutionOfBusiness":"ANY OTHER BODY NOTIFIED BY COMMITTEE","legalNameOfBusiness":"ANDHRA BANK","tradeNameOfBusiness":"ANDHRA BANK","centreJurisdiction":"COMMISSIONERATE - SHILLONG,DIVISION - SHILLONG II DIVISION,RANGE - JOWAI I RANGE (JURISDICTIONAL OFFICE)","stateJurisdiction":"STATE - MEGHALAYA,HEADQUARTER - HEAD QUARTER,CIRCLE - CIRCLE-VIII","registrationDate":"01/10/2018","taxPayerDate":"","taxPayerType":"TAX DEDUCTOR","gstinStatus":"ACTIVE","cancellationDate":"","natureOfBusinessActivities":[],"principalPlaceAddress":"THE ARCADE 1ST FLOOR,SHILLONG,EAST KHASI HILLS,EAST KHASI HILLS,MEGHALAYA,793001","principalPlaceLatitude":"","principalPlaceLongitude":"","principalPlaceBuildingNameFromGST":"THE ARCADE","principalPlaceBuildingNoFromGST":"1ST FLOOR,","principalPlaceFlatNo":"","principalPlaceStreet":"SHILLONG","principalPlaceLocality":"EAST KHASI HILLS","principalPlaceCity":"","principalPlaceDistrict":"EAST KHASI HILLS","principalPlaceState":"MEGHALAYA","principalPlacePincode":"793001","additionalPlaceAddress":"","additionalPlaceLatitude":"","additionalPlaceLongitude":"","additionalPlaceBuildingNameFromGST":"","additionalPlaceBuildingNoFromGST":"","additionalPlaceFlatNo":"","additionalPlaceStreet":"","additionalPlaceLocality":"","additionalPlaceCity":"","additionalPlaceDistrict":"","additionalPlaceState":"","additionalPlacePincode":"","additionalAddressArray":[],"lastUpdatedDate":"","principalPlaceSplitAddress":{"district":["EAST KHASI HILLS"],"state":[["MEGHALAYA","ML"]],"city":["SHILLONG"],"pincode":"793001","country":["IN","IND","INDIA"],"addressLine":"THE ARCADE 1ST FLOOR"},"additionalPlaceSplitAddress":{"district":[],"state":[[]],"city":[],"pincode":"","country":["IN","IND","INDIA"],"addressLine":""}},"gstnRecords":[{"applicationStatus":"","registrationName":"ANDHRA BANK","mobNum":"","regType":"","emailId":"","tinNumber":"","gstinRefId":"","gstin":"17AABCA7375C1D3"}],"gstin":"17AABCA7375C1D3"}}');
                res.setStatusCode(200);
                        }
        
                 if(req.getMethod() =='POST' && req.getEndpoint().contains('callout:Onboarding_SAP_Token')){
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"access_token":"2b884cba81b08eb56132608be282ed2","token_type":"Bearer","expires_in":1800,"scope":""}');
            res.setStatusCode(210);
        }           
               if(req.getMethod() == 'GET' && req.getEndpoint().contains('callout:Sap_data/http/CustomerMaster_IND')){
                res.setHeader('Content-Type', 'application/json');
                 res.setBody('{"AcctAssignmentGroup":"04","Authorization":"DT05","City":"Nabha","CompanyCode":"abcd","CorporateGroup":"1000","Country":"IN","DistributionChannel":"20","Distributor":"0001001255","Distributor_Name":"M/S.JANARDAN PARUI - AMTALA","Division":"10","EInvoicecategory":"2","Email":"dsds@fdf.fdf","GSTNumber":"21343124","Mobile":"323232332","PANNumber":"21343124","Pincode":"147201","SalesOrg":"1000","State":"19","Street1":"Ajit Nagar","Street2":"Street number 2","Street3":"24 PARAGANAS ( SOUTH )","Street4":"67867","TransportaionZone":"IN"}');
                res.setStatusCode(210);
                   //res = null;
                }  
        
                        
                        
        return res;
    }
}