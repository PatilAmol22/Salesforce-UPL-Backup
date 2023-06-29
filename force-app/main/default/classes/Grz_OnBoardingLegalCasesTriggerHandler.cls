/**************************************************************************************************
* Name             : Grz_OnBoardingLegalCasesTriggerHandler                                                      
* Description      : Prevent to delete  Particulars of the Business Record if sales area contract is true
* Test Class       : 
* Created Date     : 16-01-2023                                                                        
* Project/JIRA     : APPS-2665                                                                        
* Created By       : Mohit Garg (Grazitti)                                                                        
* Last Modified By : Mohit Garg (Grazitti) 16-01-2023                                                                        
**************************************************************************************************/

public class Grz_OnBoardingLegalCasesTriggerHandler {
	public static void beforeDeleteErrorOfOnBoardingCase(List<On_Boarding_Legal_Cases__c> oldList){
        List<Id> lstIdd = new List<Id>();
        
        for(On_Boarding_Legal_Cases__c objOBL : oldList){
            lstIdd.add(objOBL.Sales_Area__c);
        }
        
        Map<Id,DistributorSalesAreaMapping__c> mapSales= new Map<Id,DistributorSalesAreaMapping__c>([select Id,Contract_Details_Submitted__c from DistributorSalesAreaMapping__c Where Id IN :lstIdd]);
        
        for(On_Boarding_Legal_Cases__c objOBL : oldList){
            if(mapSales.containsKey(objOBL.Sales_Area__c) && mapSales.get(objOBL.Sales_Area__c).Contract_Details_Submitted__c ==true){
               
                objOBL.addError('Related Sales Area contract details are already submitted');
            }
        } 
    }
}