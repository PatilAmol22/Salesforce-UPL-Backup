/**************************************************************************************************
* Name             : OnBoardingOtherBusinessTriggerHandler                                                      
* Description      : Prevent to delete  Particulars of the Business Record if sales area contract is true
* Test Class       : 
* Created Date     : 16-01-2023                                                                        
* Project/JIRA     : APPS-2665                                                                        
* Created By       : Mohit Garg (Grazitti)                                                                        
* Last Modified By : Mohit Garg (Grazitti) 16-01-2023                                                                        
**************************************************************************************************/

public class OnBoardingOtherBusinessTriggerHandler {
	public static void beforeDeleteErrorOfOnBoardingOtherBusiness(List<On_Boarding_Other_Business__c> oldList){
        List<Id> lstIdd = new List<Id>();
        
        for(On_Boarding_Other_Business__c objOBO : oldList){
            lstIdd.add(objOBO.Sales_Area__c);
        }
        
        Map<Id,DistributorSalesAreaMapping__c> mapSales= new Map<Id,DistributorSalesAreaMapping__c>([select Id,Contract_Details_Submitted__c from DistributorSalesAreaMapping__c Where Id IN :lstIdd]);
        
        for(On_Boarding_Other_Business__c objOBO1 : oldList){
            if(mapSales.containsKey(objOBO1.Sales_Area__c) && mapSales.get(objOBO1.Sales_Area__c).Contract_Details_Submitted__c ==true){
               
                objOBO1.addError('Related Sales Area contract details are already submitted');
            }
        } 
    }
}