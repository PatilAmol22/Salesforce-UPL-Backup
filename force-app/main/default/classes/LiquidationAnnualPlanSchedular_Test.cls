@isTest
public class LiquidationAnnualPlanSchedular_Test{
        static testmethod void  testschedule(){
        
         Sales_Org__c salorg = new Sales_Org__c();
         salorg.name = 'India';
         salorg.Sales_Org_Code__c = '1000';
         
         insert salorg; 
         
         
         Territory_Distributor__c territory = new Territory_Distributor__c();
         territory.Name = 'Narayangaon';
         territory.Neglected__c = false;
         territory.Present_in_KEDE__c = true;
         territory.TerritoryCode__c = '397';
         
         territory.SalesOrg__c = salorg.id;
         insert territory;
         
         
         LiquidationAnnualPlanSchedular sh1 = new LiquidationAnnualPlanSchedular();      
         String sch = '0  00 1 3 * ?';
           system.schedule('Test', sch, sh1);
         
       
     }

}