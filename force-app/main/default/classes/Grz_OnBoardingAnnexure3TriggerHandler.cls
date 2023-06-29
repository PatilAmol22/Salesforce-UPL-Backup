/**************************************************************************************************
* Name             : Grz_OnBoardingAnnexure3TriggerHandler                                                      
* Description      : Prevent to delete  Particulars of the Business Record if sales area contract is true
* Test Class       : 
* Created Date     : 16-01-2023                                                                        
* Project/JIRA     : APPS-2665                                                                        
* Created By       : Mohit Garg (Grazitti)                                                                        
* Last Modified By : Mohit Garg (Grazitti) 16-01-2023                                                                        
**************************************************************************************************/

public class Grz_OnBoardingAnnexure3TriggerHandler {
	public static void beforeDeleteErrorOfOnBoarding(List<On_Boarding_Annexure_3__c	> oldList){
        List<Id> lstIdd = new List<Id>();
        
        for(On_Boarding_Annexure_3__c objOBA3 : oldList){
            lstIdd.add(objOBA3.Sales_Area__c);
        }
        
        Map<Id,DistributorSalesAreaMapping__c> mapSales= new Map<Id,DistributorSalesAreaMapping__c>([select Id,Contract_Details_Submitted__c from DistributorSalesAreaMapping__c Where Id IN :lstIdd]);
        
        for(On_Boarding_Annexure_3__c objOBA : oldList){
            if(mapSales.containsKey(objOBA.Sales_Area__c) && mapSales.get(objOBA.Sales_Area__c).Contract_Details_Submitted__c ==true){
               
                objOBA.addError('Related Sales Area contract details are already submitted');
            }
        } 
    }
}