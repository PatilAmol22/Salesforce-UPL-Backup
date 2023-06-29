@isTest
public class ReminderMaterialRequisitionRMBatchTest {
@testSetup
    static void allDataForThisClass(){
        
        UserRole usroleObj=new UserRole();
        usroleObj.Name='Sk International';
        
        Sales_Org__c salesOrg= new Sales_Org__c();
        salesorg.Name='SWAL';
        salesorg.Description__c='SWAL';
        salesorg.Sales_Org_Code__c='1210';
        insert salesorg;
        
        Depot__c depObj=new Depot__c();
        depObj.Name='Mumbai';
        depObj.Country__c='SWAL';
        depObj.Location__c='Mumbai';
        depObj.Depot_Code__c='MUM1';
        depObj.Active__c=true;
        depObj.SalesOrg__c=salesorg.Id;
        insert depObj;
        
        Profile p = [SELECT Id FROM Profile WHERE Name  = 'Territory Manager SWAL' LIMIT 1]; 
        
        User userObj = new User();
        userObj.Alias='Austin';
        userObj.Email='steve.austin@mid.org';
        userObj.Username='steve.austin@mid.org';
        System.debug('id :'+p.Id);
        userObj.ProfileId=p.Id;
        userObj.IsActive=true;
        userObj.Show_Inventory__c=false; 
        userObj.Show_Credit_Limit__c=false;
        userObj.LastName='Terriotory Manager';
        userObj.CommunityNickname = 'zonalExe1222 Di'; 
        userObj.TimeZoneSidKey = 'Asia/Kolkata'; 
        userObj.LocaleSidKey = 'en_IN';                                    
        userObj.LanguageLocaleKey = 'en_US';                                             
        userObj.ForecastEnabled = false;                                                     
        userObj.EmailEncodingKey = 'ISO-8859-1';  
        insert userObj;
        
        Profile p2 = [SELECT Id FROM Profile WHERE Name  = 'Regional/Zonal Manager SWAL' LIMIT 1]; 
        
        User rmUser = new User();
        rmUser.Alias = 'UDAIVIR';                                                                                                                                                                                                                                                                                  
        rmUser.Email = 'satish.tiware@skinternational.com';                                                                                                                                                                                                                                                     
        rmUser.ProfileId = p2.id;                                                                                                                                                                                                                                                                          
        rmUser.Username = '205035@upl-ltd.com.upltest';
        rmUser.LastName='REGIONAL MANAGER';                                                                                                                                                                                                                                                      
        rmUser.IsActive = true;                                                                                                                                                                                                              
        rmUser.UserPermissionsMarketingUser = false;                                                                                                                                                                                                                                                             
        rmUser.UserPermissionsOfflineUser = false;                                                                                                                                                                                                                                                               
        rmUser.UserPermissionsKnowledgeUser = false;                                                                                                                                                                                                                                                             
        rmUser.UserPermissionsInteractionUser = false;                                                                                                                                                                                                                                                           
        rmUser.UserPermissionsSupportUser = false;                                                                                                                                                                                                                                                               
        rmUser.TimeZoneSidKey = 'Asia/Kolkata';                                                                                                                                                                                                                           
        rmUser.UserPermissionsLiveAgentUser = false;                                                                                                                                                                                                                                                             
        rmUser.LocaleSidKey = 'en_IN';                                    
        rmUser.LanguageLocaleKey = 'en_US';                                             
        rmUser.ForecastEnabled = false;                                                                                                                                                                                                                       
        rmUser.EmailEncodingKey = 'ISO-8859-1';
        insert rmUser;
        
        Zone__c zoneObj=new Zone__c();
        zoneObj.Name='Chandigarh';
        zoneObj.ZoneCode__c='SWZ01';
        insert zoneObj;
        
        Region__c regionObj = new Region__c();
        regionObj.Region_Name__c = 'HISSAR';        // Region Name
        regionObj.RegionCode__c = 'SW006';            // Region Code
        regionObj.SalesOrg__c = salesOrg.Id;    // Sales Org
        regionObj.RegionHead__c = rmUser.Id;  // Region Head
        regionObj.Zone__c = zoneObj.Id;        // Zone
        insert regionObj;
        
        Territory_Distributor__c territoryObj = new Territory_Distributor__c();
        territoryObj.Name = 'Fatehabad';                    
        territoryObj.TerritoryCode__c = 'SW060';               
        territoryObj.SalesOrg__c = salesOrg.Id;          
        territoryObj.Present_in_KEDE__c = true;                
        territoryObj.Region__c = regionObj.Id;            
        territoryObj.Zone__c = zoneObj.Id;              
        insert territoryObj;
        
        Free_Sample_Management__c fsmObj = new Free_Sample_Management__c();
        fsmObj.Zip_Code__c = '123-4567';                                                      // Zip Code
        fsmObj.SalesOrg__c = salesOrg.Id;                                              // Sales Org
        fsmObj.Territory_Manager__c = userObj.Id;                                      // Territory Manager
        fsmObj.Depot__c = depObj.Id;                                                  // Depot
        fsmObj.Depot_Person_Email_ID__c = 'shama.buchade@skinternational.com';               // Depot Person Email ID
        fsmObj.Territory__c = territoryObj.Id;                                              // Territory
        fsmObj.HO_Commercial_Email_ID__c = 'shama.buchade@skinternational.com';               // HO Commercial Email ID
        fsmObj.Approval_Submission_Date_Time__c=System.now()-1;
        fsmObj.RMNotification12HrsChecked__c = false;                                         // RMNotification12HrsChecked
        fsmObj.ZMNotification12HrsChecked__c = true;                                          // ZMNotification12HrsChecked
        fsmObj.ZMNotification18HrsChecked__c = false;                                         // ZMNotification18HrsChecked
        fsmObj.RMNotification18HrsChecked__c = false;                                         // RMNotification18HrsChecked
        fsmObj.Record_Created_By__c = 'Non Office Manager';                                   // Record Created By
        fsmObj.Office_Manager__c = rmUser.Id;                                         // Office Manager
        fsmObj.Status__c = 'Pending';                                                         // Status
        fsmObj.Sub_Status__c = 'Pending for Approval 1';                                      // Sub Status
        fsmObj.Auto_Approved_1__c=false;
        fsmObj.Auto_Approved_2__c=false;
        fsmObj.X1st_Approval_Date_Time__c=null;
        fsmObj.X2nd_Approval_Date_Time__c=null; 
        fsmObj.X3rd_Approval_Date_Time__c=null;
        insert fsmObj;
    }
    static TestMethod void method(){
        Depot__c dep=[Select Id from Depot__c];
        Sales_Org__c salesOrg=[Select Id from Sales_Org__c];
        Test.startTest();
        ReminderMaterialRequisitionRMBatch batchObj=new ReminderMaterialRequisitionRMBatch(new List<String>{'1210'},'Pending Material Requisition', 'For RM'); // Edited by Sandeep Vishwakarma - AF Material Requisition
        Database.executeBatch(batchObj,1);
        Test.stopTest();
    }
    static testmethod void schedulerTest() {
        String CRON_EXP = '0 0 * * * ?';
        Test.startTest();
            String jobId = System.schedule('ScheduleApexClassTest',  CRON_EXP, new ReminderMaterialRequisitionRMScheduler());
            CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
            System.assertEquals(CRON_EXP, ct.CronExpression);
            System.assertEquals(0, ct.TimesTriggered);
        Test.stopTest();
    }
    // Edited by Sandeep Vishwakarma - SKI 27-01-2023 AF Material Requisition
    static testmethod void schedulerTest1() {
        String CRON_EXP = '0 0 * * * ?';
        Test.startTest();
            String jobId = System.schedule('ScheduleApexClassTest1',  CRON_EXP, new ReminderMaterialRequisitionAFZMScheduler());
            CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
            System.assertEquals(CRON_EXP, ct.CronExpression);
            System.assertEquals(0, ct.TimesTriggered);
        Test.stopTest();
    }
    
    static testmethod void schedulerTest2() {
        String CRON_EXP = '0 0 * * * ?';
        Test.startTest();
            String jobId = System.schedule('ScheduleApexClassTest2',  CRON_EXP, new ReminderMaterialRequisitionSBUScheduler());
            CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
            System.assertEquals(CRON_EXP, ct.CronExpression);
            System.assertEquals(0, ct.TimesTriggered);
        Test.stopTest();
    }
}