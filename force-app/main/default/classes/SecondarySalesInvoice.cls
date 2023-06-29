/* Name: SecondarySalesInvoice (batch class)
/Created On: 18 Oct 2022
/Author: Ankita&Krishanu (Ankita&Krishanu@wipro.com)
/Description: Apex Class used for update NAM Campaign Year field in Secondary Sales data using Apex 
/Project: NAM SFDC New Rollout IGNITE
Test class: CampYrCalTest
Updated On: 12-06-2023 by GRZ(Nikhil Verma) RITM0571473 to optimize code and fix system limits.
*/
global class SecondarySalesInvoice implements Database.Batchable < sobject > {
    public NAM_Capaign_Year__mdt CampgnYrNAMCurr = [SELECT StartDate__c,EndDate__c,Label FROM NAM_Capaign_Year__mdt where Label='NAMCurrentCampaignYear'];
    public NAM_Capaign_Year__mdt CampgnYrNAMPrev = [SELECT StartDate__c,EndDate__c,Label FROM NAM_Capaign_Year__mdt where Label='NAMPreviousCampaignYear'];
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getquerylocator([SELECT Id,NAM_Capaign_Year__c,Sales_Date__c,Product_Name__r.Sales_Org_Code__c 
                                         FROM Secondary_Sales_Data__c  WHERE (Product_Name__r.Sales_Org_Code__c='3100' OR Product_Name__r.Sales_Org_Code__c='3710') 
                                         AND Sales_Date__c >=: CampgnYrNAMPrev.StartDate__c AND Sales_Date__c <=: CampgnYrNAMCurr.EndDate__c AND NAM_Capaign_Year__c = null]);
    }
    
    global void execute(Database.BatchableContext bc, List < Secondary_Sales_Data__c > inv){
        for(Secondary_Sales_Data__c res: inv){
            if(res.Sales_Date__c >= CampgnYrNAMCurr.StartDate__c && res.Sales_Date__c <= CampgnYrNAMCurr.EndDate__c){
                res.NAM_Capaign_Year__c = 'CY'+' '+ (CampgnYrNAMCurr.EndDate__c).Year();
            }else if(res.Sales_Date__c >= CampgnYrNAMPrev.StartDate__c && res.Sales_Date__c <= CampgnYrNAMPrev.EndDate__c){
                res.NAM_Capaign_Year__c = 'CY'+' '+ (CampgnYrNAMPrev.EndDate__c).Year();
            }
        }
        update inv;
    }
    
    global void finish(database.BatchableContext bc) {}
    
}