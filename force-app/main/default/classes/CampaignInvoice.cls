/* Name: CampaignInvoice (batch class)
/Created On: 18 Oct 2022
/Author: Ankita&Krishanu (Ankita&Krishanu@wipro.com)
/Description: Apex Class used to update NAM Campaign Year field in Invoice using Apex 
/Project: NAM SFDC New Rollout IGNITE
Test class: CampYrCalTest
Updated On: 12-06-2023 by GRZ(Nikhil Verma) RITM0571473 to optimize code and fix system limits.
*/
global class CampaignInvoice implements Database.Batchable < sobject > {
    public NAM_Capaign_Year__mdt CampgnYrNAMCurr = [SELECT StartDate__c,EndDate__c,Label FROM NAM_Capaign_Year__mdt where Label='NAMCurrentCampaignYear'];
    public NAM_Capaign_Year__mdt CampgnYrNAMPrev = [SELECT StartDate__c,EndDate__c,Label FROM NAM_Capaign_Year__mdt where Label='NAMPreviousCampaignYear'];
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getquerylocator([SELECT Id,Campaign_Year__c,Billing_Date__c,Sales_Org_Code__c FROM Invoice__c 
                                         WHERE (Sales_Org_Code__c = '3100' OR Sales_Org_Code__c = '3710') 
                                         AND Billing_Date__c >=: CampgnYrNAMPrev.StartDate__c AND Billing_Date__c <=: CampgnYrNAMCurr.EndDate__c AND Campaign_Year__c = null]);
    }
    
    global void execute(Database.BatchableContext bc, List < Invoice__c > inv){
        for(Invoice__c res: inv){
            if(res.Billing_Date__c >= CampgnYrNAMCurr.StartDate__c && res.Billing_Date__c <= CampgnYrNAMCurr.EndDate__c){
                res.Campaign_Year__c = 'CY'+' '+ (CampgnYrNAMCurr.EndDate__c).Year();
            }else if(res.Billing_Date__c >= CampgnYrNAMPrev.StartDate__c && res.Billing_Date__c <= CampgnYrNAMPrev.EndDate__c){
                res.Campaign_Year__c = 'CY'+' '+ (CampgnYrNAMPrev.EndDate__c).Year();
            }
        }
        update inv;       
    }
    
    global void finish(database.BatchableContext bc) {}
    
}