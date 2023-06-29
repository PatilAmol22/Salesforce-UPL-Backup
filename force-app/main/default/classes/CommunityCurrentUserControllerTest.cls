@isTest
public class CommunityCurrentUserControllerTest {
    static testMethod void test(){
        Profile prof2 = [select id from profile where name = 'System Administrator'];
        User communityUser = new User(Alias = 'standt', Email='cu@gmail.com', 
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = prof2.Id, Country='Colombia',
        TimeZoneSidKey='America/Los_Angeles', UserName='cu123@gmail.com');
		//insert communityUser;
        
        //System.runAs(communityUser){
            CommunityCurrentUserController.fetchUser();
        //}
    }
}