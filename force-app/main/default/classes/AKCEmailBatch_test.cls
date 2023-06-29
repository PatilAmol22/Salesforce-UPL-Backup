@isTest
public class AKCEmailBatch_test {

    static testmethod void  testschedule(){
        Id RecordTypeIdContact = Schema.SObjectType.Case .getRecordTypeInfosByName().get('Data Pattern Calling form').getRecordTypeId();

        User u2 = new User(
         ProfileId = [select id from profile where name ='Regional Sales Manager'].Id,
         LastName = 'last',
         Email = 'puser000@amamama.com',
         Username = 'puser000@amamama.com' + System.currentTimeMillis(),
         CompanyName = 'TEST',
         Title = 'title',
         Alias = 'alias',
         TimeZoneSidKey = 'America/Los_Angeles',
         EmailEncodingKey = 'UTF-8',
         LanguageLocaleKey = 'en_US',
         LocaleSidKey = 'en_US',
         isActive = true
         );  
         insert u2;

         Sales_Org__c salorg = new Sales_Org__c();
         salorg.name = 'India';
         salorg.Sales_Org_Code__c = '1000';
         insert salorg; 
         
         Zone__c sobj2 = new Zone__c(
            Name = 'Pune',                  // Zone Name
            SalesOrg__c =salorg.id,  // Sales Org
            ZoneCode__c = 'SWZ08',
            ZonalHead__c= u2.id            // Zone Code
        );
        insert sobj2;
         
         Region__c sobj1 = new Region__c(
            Name = 'PUNE',                  // Region Name
            RegionCode__c = 'SW017',          // Region Code
            SalesOrg__c = salorg.id,
            RegionHead__c = u2.id,
                // Sales Org
            Zone__c = sobj2.id      // Zone
        );
        insert sobj1;

         Territory_Distributor__c territory = new Territory_Distributor__c();
         territory.Name = 'Narayangaon';
         territory.TerritoryManager__c = u2.id;
         territory.TerritoryCode__c = '397';
         territory.Region__c = sobj1.id;
         territory.SalesOrg__c = salorg.id;
         territory.Zone__c = sobj2.id;
         territory.Present_in_KEDE__c = true;
         territory.Neglected__c = false;
         insert territory;

        Case sobj = new Case(
        // ContactId = '0032800000ChJSb',                                      // Contact Name
            Sent_to_ZM__c = false,                                                // Sent to ZM
            Status = 'Open',                                                    // Status
            Type = 'Insect',                                                      // Type
            Crop_pick__c = 'Brinjal',                                              // Crop
            Sub_Query__c = 'Insect',                                              // Sub Query
            Data_of_Birth_changed__c = false,                                     // Data of Birth changed?
            Education_changed__c = false,                                         // Education changed?
            Farmer_using_Internet_changed__c = false,                             // Farmer using Internet changed?
            Farmer_using_Whatsapp_changed__c = false,                             // Farmer using Whatsapp changed?
            Theme_of_Month__c = false,                                            // Theme of Month
            No_Recommendation_available__c = false,                               // No Recommendation available
            Origin = 'Call-Inbound',                                              // Case Origin
            Croplist_is_Already_Updated__c = false,                               // Croplist is Already Updated
            Override__c = false,                                                  // Override Season
            Subject = 'Brinjal - Insect - Insect',                                // Subject
            Priority = 'Medium',                                                  // Priority
            PriorPromotion__c = false,
            //CreatedDate = Date.newInstance(2019,26, 06),
            TimeLine_Flag_count__c = '0',
            RecordTypeId = RecordTypeIdContact,
            Data_Pattern_Territory__c = territory.id,
            Zonal_Manager__c = u2.id 
        );

            insert sobj;

        String rcrdTp = 'Data Pattern Calling form';
        String sts = 'Open';
        String cnt = '0';
        String qry ='SELECT Id, AccountId, CaseNumber, RecordTypeId, RecordType.Name, TimeLine_Flag_count__c, Status, CreatedDate, Created_By__c, Zonal_Manager__r.email, Data_Pattern_Territory__r.SBU_Head_Id__c, Data_Pattern_Territory__r.TerritoryManager__c, Data_Pattern_Territory__r.Zonal_Marketing_Manager_1_Id__c FROM Case where  Status=\''+sts+'\' AND RecordType.Name=\''+rcrdTp+'\' AND TimeLine_Flag_count__c=\''+cnt+'\' AND CreatedDate<=LAST_N_DAYS:2 LIMIT 1';
       
        AKCEmailBatch btch = new AKCEmailBatch(qry);
        database.executebatch(btch,1);
    }
}