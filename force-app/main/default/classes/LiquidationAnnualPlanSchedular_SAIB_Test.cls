@isTest
public class LiquidationAnnualPlanSchedular_SAIB_Test{
        static testmethod void  testschedule(){
        
         Sales_Org__c salorg = new Sales_Org__c();
         salorg.name = 'India';
         salorg.Sales_Org_Code__c = '1000';
         
         insert salorg; 
         
         
          Country__c country=new Country__c(Name='India',Country_Id__c='91');
            
         insert country;
        
         
         
         State__c state= new State__c(
  Name = 'Uttar Pradesh',                // State Name
  State_Code__c = '9',                     // State Code
  Country__c = 'India',                    // Country
              // Country
  Active__c = true,                        // Active
  State_Code_Census__c = '9',              // State Code Census
  State_Name_Census__c = 'UTTAR PRADESH',  // State Name Census
 
                    // Country
  Country_Akc__c = country.id,      // Country
  SalesOrg__c= salorg.id
);
insert state;
         
         
         LiquidationAnnualPlanSchedular_SAIB sh1 = new LiquidationAnnualPlanSchedular_SAIB();      
         String sch = '0  00 1 3 * ?';
           system.schedule('Test', sch, sh1);
         
       
     }

}