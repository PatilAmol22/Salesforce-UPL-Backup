@isTest(SeeAllData = True)
public class tempuriOrg_AuthTest{
    
    /*public static  testmethod void testGetFormattedDate() {
        schemasMicrosoftCom200310Serializat_Auth testSchema = new schemasMicrosoftCom200310Serializat_Auth();
        tempuriOrg_Auth t = new tempuriOrg_Auth();
        tempuriOrg_Auth.GenerateTokenResponse_element objElement = new tempuriOrg_Auth.GenerateTokenResponse_element();
        objElement.GenerateTokenResult ='Test';
        objElement.GenerateTokenResult_type_info.add('test');
        objElement.apex_schema_type_info.add('Test');
        objElement.field_order_type_info.add('Test');
        tempuriOrg_Auth.soap1 obj = new tempuriOrg_Auth.soap1();
        obj.clientCertName_x ='testCert';
        obj.clientCert_x ='Test Certificate';
        obj.clientCertPasswd_x = 'Test Password';
        obj.timeout_x =1;
        obj.GenerateToken('test','test@123');
        
    }*/
    
    public static testMethod void mockTest(){
        Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        schemasMicrosoftCom200310Serializat_Auth testSchema = new schemasMicrosoftCom200310Serializat_Auth();
        tempuriOrg_Auth t = new tempuriOrg_Auth();
        tempuriOrg_Auth.GenerateTokenResponse_element objElement = new tempuriOrg_Auth.GenerateTokenResponse_element();
        objElement.GenerateTokenResult ='Test';
        objElement.GenerateTokenResult_type_info.add('test');
        objElement.apex_schema_type_info.add('Test');
        objElement.field_order_type_info.add('Test');
        tempuriOrg_Auth.soap1 obj = new tempuriOrg_Auth.soap1();
        obj.clientCertName_x ='testCert';
        obj.clientCert_x ='Test Certificate';
        obj.clientCertPasswd_x = 'Test Password';
        obj.timeout_x =1;
        obj.GenerateToken('test','test@123');
    }
    
    private class WebServiceMockImpl implements WebServiceMock
    {
        public void doInvoke(
            Object stub, Object request, Map<String, Object> response,
            String endpoint, String soapAction, String requestName,
            String responseNS, String responseName, String responseType)
        	{
                tempuriOrg_Auth.GenerateTokenResponse_element response_x = new tempuriOrg_Auth.GenerateTokenResponse_element();
                response_x.GenerateTokenResult = 'Successfull';
            	response.put('response_x', response_x);
            	return;
        	}
    }
}