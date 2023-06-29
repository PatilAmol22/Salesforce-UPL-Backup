/**************************************************************************************************
* Name               : Grz_DistributorPathfinderApex                                                      
* Description        : Controller class for Grz_DistributorPathfinderDetails LWC Component
* Test Class         : GTMOutlookTest
* Created By         : Swaranjeet(Grazitti)   
* Ticket Number      : RITM0504049/APPS-4788
**************************************************************************************************/
public with sharing class Grz_DistributorPathfinderApex {
          
        @AuraEnabled
        public static List<GTM_Details__c> getCompetitionDetails(String year,String recordId){
            sales_org__c salesorg;
              try{
                	 salesorg= GTMPathFinder.getSalesOrg();
            	}
            catch(Exception e){
                system.debug('e=='+e);
                return null;
            }
       
            Id userId = userInfo.getUserId();
            Id competitorRecordType = Schema.SObjectType.GTM_Details__c.getRecordTypeInfosByName().get('Competitor').getRecordTypeId();
            List<GTM_Details__c> gtmDetails = new List<GTM_Details__c>();
            system.debug('competitorRecordType==>'+competitorRecordType);
            system.debug('recordId==>'+recordId);
            system.debug('year==>'+year);
            system.debug('salesorg==>'+salesorg);
            gtmDetails = [select Id,GTM_Customer__c, GTM_Customer__r.Name,GTM_Customer__r.Lead_Customer__c,Competitor_Name_1__c,Competitor_Name_1__r.Name,Indicate_share_wallet_of_competitor_1__c,Competitor_Name_2__c,Indicate_share_wallet_of_competitor_2__c,Competitor_Name_3__c,Indicate_share_wallet_of_competitor_3__c,Competitor_Name_4__c,Indicate_share_wallet_of_competitor_4__c,Competitor_Name_5__c,Indicate_share_wallet_of_competitor_5__c,Competitor_Name_6__c,Indicate_share_wallet_of_competitor_6__c,Competitor_Name_7__c,Indicate_share_wallet_of_competitor_7__c,Competitor_Name_8__c,Indicate_share_wallet_of_competitor_8__c,UPL_Position__c,UPLs_share_of_wallet__c,Competitor_Name_2__r.Name,Competitor_Name_3__r.Name,Competitor_Name_4__r.Name,Competitor_Name_5__r.Name,Competitor_Name_6__r.Name,Competitor_Name_7__r.Name,Competitor_Name_8__r.Name,GTM_Customer__r.Path_Finder__c,isSubmitted__c,GTM_Customer__r.recordTypeId,Is_Duplicate_GTM_Record__c from GTM_Details__c where recordTypeId=:competitorRecordType and Sales_Org__r.Sales_Org_Code__c=:salesorg.Sales_Org_Code__c AND GTM__r.Fiscal_Year__c=:year and Is_Duplicate_GTM_Record__c= false and GTM_Customer__c=:recordId  order by  GTM_Customer__r.Name ASC];
            
            return gtmDetails;
        }

      @AuraEnabled
      public static List<GTM_Details__c> getGTMOutlook(String year,String recordId){
      Id gtmOutlookRecordType = Schema.SObjectType.GTM_Details__c.getRecordTypeInfosByName().get('Outlook').getRecordTypeId();
       //List<Account> accList = GTMPathFinder.getGTMCustomers();
        sales_org__c salesorg;
              try{
                	 salesorg= GTMPathFinder.getSalesOrg();
            	}
            catch(Exception e){
                system.debug('e=='+e);
                return null;
            }
       String fiscalYear = year;
      
       List<GTM_Details__c> gtmDetailsList = new List<GTM_Details__c>();
       //GTMPathFinderHelper.createOutlookDetails(gtm,gtmOutlookRecordType,accList);
        gtmDetailsList = [Select Id, GTM_Customer__r.Name, GTM_Customer__c,GTM_Details__r.Total_Purchase_of_Crop_Protection_PY__c,GTM_Customer__r.Lead_Customer__c,Estimated_Growth_NY_to_2NY__c, Estimated_Growth_PY_to_CY__c, Estimated_Growth_PY_to_NY__c, Sales_Org__c,GTM_Customer__r.Path_Finder__c,isSubmitted__c,GTM_Customer__r.recordTypeId,is_Duplicate_Gtm_Record__c from GTM_Details__c WHERE GTM__r.Fiscal_Year__c=:fiscalYear AND recordTypeId=:gtmOutlookRecordType AND Sales_Org__r.Sales_Org_Code__c=:salesorg.Sales_Org_Code__c and is_Duplicate_Gtm_Record__c = false and GTM_Customer__c=:recordId order by  GTM_Customer__r.Name ASC];
         return gtmDetailsList;
    }
    }