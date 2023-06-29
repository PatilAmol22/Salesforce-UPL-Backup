/* Name: GetNAMYOYGrowthEDISales (batch class)
/Created On: 14 Oct 2022
/Author: Ankita&Krishanu (Ankita&Krishanu@wipro.com)
/Description: Apex Class used for YoY growth in Secondary Sales data using Apex 
/Project: NAM SFDC New Rollout IGNITE

*/
global class GetNAMYOYGrowthEDISales implements Database.Batchable < sobject > {
global Database.QueryLocator start(Database.BatchableContext bc) {
       String Query;
       Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Retailer').getRecordTypeId();
       Query = 'select id,SumofInvoiceCurrentFY__c,Sum_of_Previous_Fiscal__c,Total_Revenue_Current_CampaignYr__c,Total_Revenue_Prev_CampaignYr__c,RecordTypeId from Account where (Sales_Org_Code__c=\'3100\' OR Sales_Org_Code__c=\'3710\') AND (RecordTypeId=\''+devRecordTypeId+'\')';
       system.debug('Query '+Query);
       return Database.getquerylocator(Query);

       }

global void execute(Database.BatchableContext bc, List < Account > acc)
{
    Integer orgFiscalMonth = [SELECT FiscalYearStartMonth FROM Organization].FiscalYearStartMonth;
        string fy = [SELECT FiscalYearSettings.Name FROM Period WHERE Type = 'Year' AND StartDate <= TODAY AND EndDate >= TODAY].FiscalYearSettings.Name;
        
        Integer curfy = Integer.valueof(fy);
        Integer prevfy = curfy-1;
        Date currFiscalYear = Date.newinstance((curfy-1), orgFiscalMonth, 1);
        Date prevFiscalYear = Date.newinstance((prevfy-1), orgFiscalMonth, 1);
        NAM_Capaign_Year__mdt CampgnYrNAMCurr = [SELECT StartDate__c,EndDate__c,Label FROM NAM_Capaign_Year__mdt where Label='NAMCurrentCampaignYear'];
        NAM_Capaign_Year__mdt CampgnYrNAMPrev = [SELECT StartDate__c,EndDate__c,Label FROM NAM_Capaign_Year__mdt where Label='NAMPreviousCampaignYear'];
    
        list<id> accid = new List<id>();
        for(Account ac:acc)
        {
          accid.add(ac.Id);
        }
        
        List<sObject> invcfy = [select Customer_Name__c,sum(Sales_Amount_in_USD__c) from Secondary_Sales_Data__c where 
                                Customer_Name__c in :accid 
                                and Sales_Date__c>=:currFiscalYear 
                                and Sales_Date__c<=:Date.today()
                                group by Customer_Name__c];
        
        List<sObject> invpfy = [select Customer_Name__c,sum(Sales_Amount_in_USD__c) from Secondary_Sales_Data__c where 
                                Customer_Name__c in :accid 
                                and Sales_Date__c>=:prevFiscalYear 
                                and Sales_Date__c<=:Date.today().addYears(-1)
                                group by Customer_Name__c];
    for(sObject res: invcfy){
            for(Account ac: acc){
                if(ac.id==res.get('Customer_Name__c')){
                	ac.Sum_of_Previous_Fiscal__c = Integer.valueOf(res.get('expr0'));
            		ac.SumofInvoiceCurrentFY__c = Integer.valueOf(res.get('expr0'));
                }
            }
        }
        for(sObject res: invpfy){
            for(Account ac: acc){
                if(ac.id==res.get('Customer_Name__c')){
                	ac.Sum_of_Previous_Fiscal__c = Integer.valueOf(res.get('expr0'));
                }
            }
        }
     List<sObject> invcfy2 = [select Customer_Name__c,sum(Sales_Amount_in_USD__c) from Secondary_Sales_Data__c where 
                                Customer_Name__c in :accid 
                                and Sales_Date__c>=:currFiscalYear 
                                and Sales_Date__c<=:Date.today()
                                group by Customer_Name__c];
        
        List<sObject> invpfy2 = [select Customer_Name__c,sum(Sales_Amount_in_USD__c) from Secondary_Sales_Data__c where 
                                Customer_Name__c in :accid 
                                and Sales_Date__c>=:prevFiscalYear 
                                and Sales_Date__c<=:Date.today().addYears(-1)
                                group by Customer_Name__c];
    for(sObject res: invcfy2){
            for(Account ac: acc){
                if(ac.id==res.get('Customer_Name__c')){
                	ac.Total_Revenue_Prev_CampaignYr__c = Integer.valueOf(res.get('expr0'));
            		ac.Total_Revenue_Current_CampaignYr__c = Integer.valueOf(res.get('expr0'));
                }
            }
        }
        for(sObject res: invpfy2){
            for(Account ac: acc){
                if(ac.id==res.get('Customer_Name__c')){
                	ac.Total_Revenue_Prev_CampaignYr__c = Integer.valueOf(res.get('expr0'));
                }
            }
        }
        update acc;
    
       }

global void finish(database.BatchableContext bc) {}
   
}