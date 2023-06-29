@isTest
public class OpeningInventorySchedularSWAL_test {
        static testmethod void  testschedule(){
        
         Sales_Org__c salorg = new Sales_Org__c();
         salorg.name = 'SWAL';
         salorg.Sales_Org_Code__c = '1210';
         insert salorg; 
         
         Id RecordTypeIdContact = Schema.SObjectType.Liquidation_Annual_Plan__c .getRecordTypeInfosByName().get('SWAL TRADE').getRecordTypeId();
         
         Territory_Distributor__c territory = new Territory_Distributor__c();
         territory.Name = 'Narayangaon1';
         territory.TerritoryCode__c = '301';
         territory.SalesOrg__c = salorg.id;
         insert territory;
         
           Territory_Distributor__c territory2 = new Territory_Distributor__c();
         territory2.Name = 'Narayangaon2';
         territory2.TerritoryCode__c = '302';
         territory2.SalesOrg__c = salorg.id;
         insert territory2;
         
           Territory_Distributor__c territory3 = new Territory_Distributor__c();
         territory3.Name = 'Narayangaon3';
         territory3.TerritoryCode__c = '303';
         territory3.SalesOrg__c = salorg.id;
         insert territory3;
         
         
         Liquidation_Annual_Plan__c liqannlPln = new Liquidation_Annual_Plan__c(
                  Fiscal_Start_Date__c = Date.newInstance(2018, 04, 01),// Fiscal Start Date
                  FIscal_Year__c = '2018-2019',                     // FIscal Year
                  Fiscal_End_Date__c = Date.newInstance(2019,31, 03),   // Fiscal End Date
                  Territory_Name__c = territory.id, 
                  Sales_Qty_External_Key_Annual_Plan__c = territory.TerritoryCode__c + string.valueOf(Date.newInstance(2018, 04, 01))+'-'+String.valueOf(Date.newInstance(2019,31, 03)),         // Territory Name
                  SentToBatch__c = false,                           // Sent To Batch
                   Sales_Org__c=salorg.id,
                  RecordTypeId=RecordTypeIdContact 
                  );
         insert liqannlPln;
         
         Liquidation_Annual_Plan__c liqannlPln1 = new Liquidation_Annual_Plan__c(
                  Fiscal_Start_Date__c = Date.newInstance(2018, 04, 01),// Fiscal Start Date
                  FIscal_Year__c = '2018-2019',                     // FIscal Year
                  Fiscal_End_Date__c = Date.newInstance(2019,31, 03),   // Fiscal End Date
                  Territory_Name__c = territory2.id,            // Territory Name
                  SentToBatch__c = false,                           // Sent To Batch
                   Sales_Org__c=salorg.id,
                  RecordTypeId=RecordTypeIdContact
                  );
         insert liqannlPln1;
         
         Liquidation_Annual_Plan__c liqannlPln2 = new Liquidation_Annual_Plan__c(
                  Fiscal_Start_Date__c = Date.newInstance(2018, 04, 01),// Fiscal Start Date
                  FIscal_Year__c = '2018-2019',                     // FIscal Year
                  Fiscal_End_Date__c = Date.newInstance(2019,31, 03),   // Fiscal End Date
                  Territory_Name__c = territory3.id,            // Territory Name
                  SentToBatch__c = false,                           // Sent To Batch
                   Sales_Org__c=salorg.id,
                  RecordTypeId=RecordTypeIdContact
                  );
         insert liqannlPln2;
         system.debug('liqannlPln'+liqannlPln.Fiscal_Start_Date__c );
         OpeningInventorySchedularSWAL sh1 = new OpeningInventorySchedularSWAL();      
         String sch = '0  00 1 3 * ?';
           system.schedule('Test', sch, sh1);
         
       
     }

}