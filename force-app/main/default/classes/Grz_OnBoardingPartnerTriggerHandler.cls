/**************************************************************************************************
* Name             : Grz_OnBoardingPartnerTriggerHandler                                                      
* Description      : Prevent to delete  Particulars of the Business Record if sales area contract is true
* Test Class       : 
* Created Date     : 16-01-2023                                                                        
* Project/JIRA     : APPS-2665                                                                        
* Created By       : Mohit Garg (Grazitti)                                                                        
* Last Modified By : Mohit Garg (Grazitti) 16-01-2023                                                                        
**************************************************************************************************/

public class Grz_OnBoardingPartnerTriggerHandler {
	public static void beforeDeleteErrorOfOnBoardingPartner(List<On_Boarding_Partner__c> oldList){
        List<Id> lstIdd = new List<Id>();
        
        for(On_Boarding_Partner__c objOBP : oldList){
            lstIdd.add(objOBP.Sales_Area__c);
        }
        
        Map<Id,DistributorSalesAreaMapping__c> mapSales= new Map<Id,DistributorSalesAreaMapping__c>([select Id,Contract_Details_Submitted__c from DistributorSalesAreaMapping__c Where Id IN :lstIdd]);
        
        for(On_Boarding_Partner__c objOBP1 : oldList){
            if(mapSales.containsKey(objOBP1.Sales_Area__c) && mapSales.get(objOBP1.Sales_Area__c).Contract_Details_Submitted__c ==true){
               
                objOBP1.addError('Related Sales Area contract details are already submitted');
            }
        } 
    }
}