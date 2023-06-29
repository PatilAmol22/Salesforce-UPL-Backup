@isTest
public class Grz_uplPartnerPortalLoginTest {
    @isTest static void testLogin() {
        try{
            // Create user
            String identifierEmail = getUniqueName() + '@test.org';
            createTestUser(identifierEmail);
            Map<String, String> requestAttributes = new Map<String, String>();
            String startUrl = '';
            Grz_uplPartnerPortalLogin myDomainDiscLoginDefaultHandler = new Grz_uplPartnerPortalLogin();
            // Invoke login method from handler with the email of user created
            PageReference  pageReference = myDomainDiscLoginDefaultHandler.login(identifierEmail, startUrl, requestAttributes);
            // Asser page reference is returned
        }catch (Auth.LoginDiscoveryException loginDiscoveryException) {
            // Assert exception message
            System.assert(loginDiscoveryException.getMessage().contains('No Passwordless Login redirect URL returned for verification method'), 'message=' + loginDiscoveryException.getMessage());
        }
        //System.assertNotEquals(null, pageReference, 'Page reference was not returned');
    }
    @isTest static void testLogin1() {
        try{
            // Create user
            String identifierEmail = '4354356365';
            createTestUser1(identifierEmail);
            Map<String, String> requestAttributes = new Map<String, String>();
            String startUrl = '';
            Grz_uplPartnerPortalLogin myDomainDiscLoginDefaultHandler = new Grz_uplPartnerPortalLogin();
            // Invoke login method from handler with the email of user created
            PageReference  pageReference = myDomainDiscLoginDefaultHandler.login(identifierEmail, startUrl, requestAttributes);
            // Asser page reference is returned
        }catch (Auth.LoginDiscoveryException loginDiscoveryException) {
            // Assert exception message
            System.assert(loginDiscoveryException.getMessage().contains('No Passwordless Login redirect URL returned for verification method'), 'message=' + loginDiscoveryException.getMessage());
        }
        //System.assertNotEquals(null, pageReference, 'Page reference was not returned');
    }
    /* Test Discoverable handler login with invalid (non-existing) user.
Expected : Auth.LoginDiscoveryException
*/
    @isTest static void testLoginWithInvalidUser() {
        try {
            Map<String, String> requestAttributes = new Map<String, String>();
            String startUrl = '';
            String uniqueName = getUniqueName();
            String email = uniqueName + '@test.org';
            Grz_uplPartnerPortalLogin myDomainDiscLoginDefaultHandler = new Grz_uplPartnerPortalLogin();
            // Invoke login method from handler with non-existing user
            myDomainDiscLoginDefaultHandler.login(email, startUrl, requestAttributes);
        }catch (Auth.LoginDiscoveryException loginDiscoveryException) {
            // Assert exception message
            System.assert(loginDiscoveryException.getMessage().contains('No unique user found'), 'message=' + loginDiscoveryException.getMessage());
        }
    }
    /*
Generate a random name
*/
    private static String getUniqueName() {
        String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        String uniqueName = orgId + dateString + randomInt;
        return uniqueName;
    }
    /*
Create user with given email.
*/
    private static void createTestUser(String identifierEmail)
    {
        String uniqueName = getUniqueName();
        Profile pf = [SELECT Id FROM Profile WHERE Name='Standard User'];
        String profileID = pf.Id;
        String fName = 'fname';
        String lName = uniqueName + '-lname'; 
        User tuser = new User(  firstname = fName,
                              lastName = lName,
                              email = identifierEmail,
    
                              Username = uniqueName + '@test.org',
                              EmailEncodingKey = 'ISO-8859-1',
                              Alias = uniqueName.substring(18, 23),
                              TimeZoneSidKey = 'America/Los_Angeles',
                              LocaleSidKey = 'en_US',
                              LanguageLocaleKey = 'en_US',
                              ProfileId = profileID);
        insert tuser;
    }
    private static void createTestUser1(String identifierEmail)
    {
        String uniqueName = getUniqueName();
        Profile pf = [SELECT Id FROM Profile WHERE Name='Standard User'];
        String profileID = pf.Id;
        String fName = 'fname';
        String lName = uniqueName + '-lname'; 
        User tuser = new User(  firstname = fName,
                              lastName = lName,
                              email = 't@grazitti.com',
                              MobilePhone = identifierEmail,
                              Username = uniqueName + '@test.org',
                              EmailEncodingKey = 'ISO-8859-1',
                              Alias = uniqueName.substring(18, 23),
                              TimeZoneSidKey = 'America/Los_Angeles',
                              LocaleSidKey = 'en_US',
                              LanguageLocaleKey = 'en_US',
                              ProfileId = profileID);
        insert tuser;
    }
}