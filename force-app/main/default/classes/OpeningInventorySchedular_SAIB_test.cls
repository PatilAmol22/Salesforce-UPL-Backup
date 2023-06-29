@isTest
public class OpeningInventorySchedular_SAIB_test {
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
        
Id RecordTypeIdContact = Schema.SObjectType.Liquidation_Annual_Plan__c .getRecordTypeInfosByName().get('SAIB').getRecordTypeId();
         
         Liquidation_Annual_Plan__c liqannlPln = new Liquidation_Annual_Plan__c(
                  Fiscal_Start_Date__c = Date.newInstance(2018, 04, 01),// Fiscal Start Date
                  FIscal_Year__c = '2018-2019',                     // FIscal Year
                  Fiscal_End_Date__c = Date.newInstance(2019,31, 03),   // Fiscal End Date
                  State__c= state.id, 
                  //Sales_Qty_External_Key_Annual_Plan__c = territory.TerritoryCode__c + string.valueOf(Date.newInstance(2018, 04, 01))+'-'+String.valueOf(Date.newInstance(2019,31, 03)),         // Territory Name
                  SentToBatch__c = false,
                  Sales_Org__c=salorg.id,
                  recordtypeid=RecordTypeIdContact                           // Sent To Batch
                  );
         insert liqannlPln;
         
         Liquidation_Annual_Plan__c liqannlPln1 = new Liquidation_Annual_Plan__c(
                  Fiscal_Start_Date__c = Date.newInstance(2018, 04, 01),// Fiscal Start Date
                  FIscal_Year__c = '2018-2019',                     // FIscal Year
                  Fiscal_End_Date__c = Date.newInstance(2019,31, 03),   // Fiscal End Date
                  State__c= state.id,            // Territory Name
                  SentToBatch__c = false,
                  Sales_Org__c=salorg.id,
                  recordtypeid=RecordTypeIdContact                           // Sent To Batch
                  );
         insert liqannlPln1;
         
         Liquidation_Annual_Plan__c liqannlPln2 = new Liquidation_Annual_Plan__c(
                  Fiscal_Start_Date__c = Date.newInstance(2018, 04, 01),// Fiscal Start Date
                  FIscal_Year__c = '2018-2019',                     // FIscal Year
                  Fiscal_End_Date__c = Date.newInstance(2019,31, 03),   // Fiscal End Date
                  State__c= state.id,           // Territory Name
                  SentToBatch__c = false,
                  Sales_Org__c=salorg.id,
                  recordtypeid=RecordTypeIdContact                           // Sent To Batch
                  );
         insert liqannlPln2;
         
         system.debug('liqannlPln'+liqannlPln.Fiscal_Start_Date__c );
         OpeningInventorySchedular_SAIB sh1 = new OpeningInventorySchedular_SAIB();      
         String sch = '0  00 1 3 * ?';
           system.schedule('Test', sch, sh1);
         
       
     }

}