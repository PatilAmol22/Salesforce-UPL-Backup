/* Name: CampYrCal (schedule Apex class)
/Created On: 18 Oct 2022
/Author: Ankita&Krishanu (Ankita&Krishanu@wipro.com)
/Description: Apex Class used to schedule CampaignInvoice and SecondarySalesInvoice for Campaign Year
/Project: NAM SFDC New Rollout IGNITE
Test class: CampYrCalTest
Updated On: 12-06-2023 by GRZ(Nikhil Verma) RITM0571473 to optimize code and fix system limits.
*/
global class CampYrCal implements Schedulable {
    global void execute(SchedulableContext sc) {
        database.executebatch(new SecondarySalesInvoice());
        database.executebatch(new CampaignInvoice());
    }
    public static void calCamp(){
        String jobIDNew = system.schedule('Batch Scheduled for NAM CampaignInvoice and SecondarySalesInvoice', '0 0 0 * * ?', new CampYrCal());
    }
}