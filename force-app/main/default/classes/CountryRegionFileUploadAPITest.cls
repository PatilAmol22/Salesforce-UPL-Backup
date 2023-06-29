@isTest
public class CountryRegionFileUploadAPITest {
	
    public static testMethod void method(){ 
        String body ='Region,Country,Module\r\n';
        body+='AMEANZ,Australia,Account Management(Account 360)\r\n';
        body+='AMEANZ,Australia,Sales order Module\r\n';
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/CountryRegionFileUpload/v1/*';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(body);
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        CountryRegionFileUploadAPI.attachDoc();
        CountryRegionFileUploadAPI.processData(Blob.valueOf(body));
        CountryRegionFileUploadAPI.sendEmail(body, body, 1, 1);
        Test.stopTest();
        
    }
    
}