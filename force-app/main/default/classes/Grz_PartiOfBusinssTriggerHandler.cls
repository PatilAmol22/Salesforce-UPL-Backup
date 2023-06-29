/**************************************************************************************************
* Name             : Grz_PartiOfBusinssTriggerHandler                                                      
* Description      : Prevent to delete  Particulars of the Business Record if sales area contract is true
* Test Class       : 
* Created Date     : 16-01-2023                                                                        
* Project/JIRA     : APPS-2665                                                                        
* Created By       : Mohit Garg (Grazitti)                                                                        
* Last Modified By : Mohit Garg (Grazitti) 16-01-2023                                                                        
**************************************************************************************************/

public class Grz_PartiOfBusinssTriggerHandler {
    public static void beforeDeleteError(List<Particulars_of_the_Business__c> oldList){
        List<Id> lstIdd = new List<Id>();
        
        for(Particulars_of_the_Business__c objPOB3 : oldList){
            lstIdd.add(objPOB3.Sales_Area__c);
        }
        
        Map<Id,DistributorSalesAreaMapping__c> mapSales= new Map<Id,DistributorSalesAreaMapping__c>([select Id,Contract_Details_Submitted__c from DistributorSalesAreaMapping__c Where Id IN :lstIdd]);
        
        for(Particulars_of_the_Business__c objPOB2 : oldList){
            if(mapSales.containsKey(objPOB2.Sales_Area__c) && mapSales.get(objPOB2.Sales_Area__c).Contract_Details_Submitted__c ==true){
               
                objPOB2.addError('Related Sales Area contract details are already submitted');
            }
        } 
    }
}