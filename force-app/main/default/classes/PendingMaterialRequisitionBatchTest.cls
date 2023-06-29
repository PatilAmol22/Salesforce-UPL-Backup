@isTest
public class PendingMaterialRequisitionBatchTest {
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
        
        Profile p2 = [SELECT Id FROM Profile WHERE Name  = 'Marketing HO Swal' LIMIT 1]; 
        
        User HOUser = new User();
        HOUser.Alias = 'ptiwa';                                                                                                                                                                                                                                                                                  
        HOUser.Email = 'satish.tiware@skinternational.com';                                                                                                                                                                                                                                                     
        HOUser.ProfileId = p2.id;                                                                                                                                                                                                                                                                          
        HOUser.Username = '2055@upl-ltd.com.upltest';
        HOUser.LastName='HO Marketing';                                                                                                                                                                                                                                                      
        HOUser.IsActive = true;                                                                                                                                                                                                              
        HOUser.UserPermissionsMarketingUser = false;                                                                                                                                                                                                                                                             
        HOUser.UserPermissionsOfflineUser = false;                                                                                                                                                                                                                                                               
        HOUser.UserPermissionsKnowledgeUser = false;                                                                                                                                                                                                                                                             
        HOUser.UserPermissionsInteractionUser = false;                                                                                                                                                                                                                                                           
        HOUser.UserPermissionsSupportUser = false;                                                                                                                                                                                                                                                               
        HOUser.TimeZoneSidKey = 'Asia/Kolkata';                                                                                                                                                                                                                           
        HOUser.UserPermissionsLiveAgentUser = false;                                                                                                                                                                                                                                                             
        HOUser.LocaleSidKey = 'en_IN';                                    
        HOUser.LanguageLocaleKey = 'en_US';                                             
        HOUser.ForecastEnabled = false;                                                                                                                                                                                                                       
        HOUser.EmailEncodingKey = 'ISO-8859-1';
        insert HOUser;
        
        Zone__c zoneObj=new Zone__c();
        zoneObj.Name='Chandigarh';
        zoneObj.ZoneCode__c='SWZ01';
        insert zoneObj;
        
        Territory_Distributor__c territoryObj = new Territory_Distributor__c();
        territoryObj.Name = 'Fatehabad';                    
        territoryObj.TerritoryCode__c = 'SW060';               
        territoryObj.SalesOrg__c = salesOrg.Id;          
        territoryObj.Present_in_KEDE__c = true;          
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
        fsmObj.X2nd_Approval_Date_Time__c=System.now()-1; 
        fsmObj.RMNotification12HrsChecked__c = false;                                         // RMNotification12HrsChecked
        fsmObj.ZMNotification12HrsChecked__c = true;                                          // ZMNotification12HrsChecked
        fsmObj.ZMNotification18HrsChecked__c = false;                                         // ZMNotification18HrsChecked
        fsmObj.RMNotification18HrsChecked__c = false;                                         // RMNotification18HrsChecked
        fsmObj.Record_Created_By__c = 'Non Office Manager';                                   // Record Created By
        fsmObj.Office_Manager__c = null;                                         // Office Manager
        fsmObj.Status__c = 'Pending';                                                         // Status
        fsmObj.Sub_Status__c = 'Pending for Approval 3';                                      // Sub Status
        fsmObj.Technical_Manager__c=HOUser.Id;
        insert fsmObj;
    }
    static TestMethod void method(){
        Depot__c dep=[Select Id from Depot__c];
        Sales_Org__c salesOrg=[Select Id from Sales_Org__c];
        Test.startTest();
        PendingMaterialRequisitionBatch batchObj=new PendingMaterialRequisitionBatch(new List<String>{'1210'},'Pending Material Requisition', 'For HO Marketing');// Edited by Sandeep Vishwakarma - AF Material requisition
        Database.executeBatch(batchObj,1);
        Test.stopTest();
    }
    static testmethod void schedulerTest() {
        String CRON_EXP = '0 0 * * * ?';
        Test.startTest();
        String jobId = System.schedule('ScheduleApexClassTest',  CRON_EXP, new PendingMaterialRequisitionScheduler());
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        System.assertEquals(CRON_EXP, ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);
        Test.stopTest();
    }    
}