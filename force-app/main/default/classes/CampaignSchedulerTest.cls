/* Name: CampaignSchedulerTest (test Apex class for CampYrCal)
/Created On: 28 Oct 2022
/Author: Ankita&Krishanu (Ankita&Krishanu@wipro.com)
/Description: test Apex class for CampYrCal.apxc
/Project: NAM SFDC New Rollout IGNITE
*/
@istest
public class CampaignSchedulerTest {
    @istest
    static void  testschedule() {
        Test.StartTest();
        system.schedule('jobName', '0 0 0 * * ?', new CampYrCal());
        CampYrCal.calCamp();
        Test.stopTest();
    }
}