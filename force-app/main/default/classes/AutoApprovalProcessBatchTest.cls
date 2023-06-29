@isTest
public class AutoApprovalProcessBatchTest {
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
        
        Territory_Distributor__c territoryObj = new Territory_Distributor__c();
        territoryObj.Name = 'Fatehabad';                     // Territory Name
        territoryObj.TerritoryCode__c = 'SW060';               // Code
        territoryObj.SalesOrg__c = salesorg.Id;          // Sales Org
        territoryObj.Present_in_KEDE__c = true;                // Present in KEDE
        insert territoryObj;
        
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
        userObj.Territory__c=territoryObj.Id;
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
        
        Region__c regionObj = new Region__c();
        regionObj.Region_Name__c = 'HISSAR';        // Region Name
        regionObj.RegionCode__c = 'SW006';            // Region Code
        regionObj.SalesOrg__c = salesOrg.Id;    // Sales Org
        regionObj.RegionHead__c = rmUser.Id;  // Region Head
        insert regionObj;
        
        User zmUser = new User();
        zmUser.Alias = 'SATENDRA';                                                                                                                                                                                                                                                                                  
        zmUser.Email = 'satish.tiware@skinternational.com';                                                                                                                                                                                                                                                     
        zmUser.ProfileId = p2.id;                                                                                                                                                                                                                                                                          
        zmUser.Username = '205012@upl-ltd.com.upltest';
        zmUser.LastName='Zonal Head';                                                                                                                                                                                                                                                      
        zmUser.IsActive = true;                                                                                                                                                                                                              
        zmUser.UserPermissionsMarketingUser = false;                                                                                                                                                                                                                                                             
        zmUser.UserPermissionsOfflineUser = false;                                                                                                                                                                                                                                                               
        zmUser.UserPermissionsKnowledgeUser = false;                                                                                                                                                                                                                                                             
        zmUser.UserPermissionsInteractionUser = false;                                                                                                                                                                                                                                                           
        zmUser.UserPermissionsSupportUser = false;                                                                                                                                                                                                                                                               
        zmUser.TimeZoneSidKey = 'Asia/Kolkata';                                                                                                                                                                                                                           
        zmUser.UserPermissionsLiveAgentUser = false;                                                                                                                                                                                                                                                             
        zmUser.LocaleSidKey = 'en_IN';                                    
        zmUser.LanguageLocaleKey = 'en_US';                                             
        zmUser.ForecastEnabled = false;                                                                                                                                                                                                                       
        zmUser.EmailEncodingKey = 'ISO-8859-1';
        insert zmUser;
        
        Zone__c zoneObj = new Zone__c();
        zoneObj.Name = 'Chandigarh';
        zoneObj.ZoneCode__c = 'SWZ01';
        zoneObj.ZonalHead__c = zmUser.Id;
        zoneObj.SalesOrg__c = salesOrg.Id;
        insert zoneObj;
        
        List<RecordType> rtype=[SELECT Id, Name, IsActive FROM RecordType where Name='Post Free Sample Management' limit 1];
        
        Free_Sample_Management__c fsmObj = new Free_Sample_Management__c();
        fsmObj.RecordTypeId=rtype[0].Id;
        fsmObj.Zip_Code__c = '123-4567';                                                      // Zip Code
        fsmObj.SalesOrg__c = salesOrg.Id;                                              // Sales Org
        fsmObj.Territory_Manager__c = userObj.Id;                                      // Territory Manager
        fsmObj.Depot__c = depObj.Id;                                                  // Depot
        fsmObj.Depot_Person_Email_ID__c = 'shama.buchade@skinternational.com';               // Depot Person Email ID
        fsmObj.Territory__c = territoryObj.Id;                                              // Territory
        fsmObj.HO_Commercial_Email_ID__c = 'shama.buchade@skinternational.com';               // HO Commercial Email ID
        fsmObj.Record_Created_By__c = 'Non Office Manager';                                   
        fsmObj.Office_Manager__c = rmUser.Id;                                         
        fsmObj.Status__c = 'Draft'; 
        fsmObj.Sales_Assistant__c=zmUser.Id;
        fsmObj.Raised_By__c='TM';
        insert fsmObj;
        
        Approval.ProcessSubmitRequest app = new Approval.ProcessSubmitRequest();
        app.setObjectId(fsmObj.id);
        Approval.ProcessResult result = Approval.process(app);
        //System.assert(result.isSuccess());
        
        
        Free_Sample_Management__c fsmObj2 = new Free_Sample_Management__c();
        fsmObj2.Id = fsmObj.Id; 
        fsmObj2.Approval_Submission_Date_Time__c=System.now()-3;
        fsmObj2.RMNotification12HrsChecked__c = true;                                        
        fsmObj2.ZMNotification12HrsChecked__c = false;                                         
        fsmObj2.ZMNotification18HrsChecked__c = false;                                         
        fsmObj2.RMNotification18HrsChecked__c = true;                                
        fsmObj2.Office_Manager__c = rmUser.Id;                                         
        fsmObj2.Status__c = 'Pending';                                                         
        fsmObj2.Sub_Status__c = 'Pending for Approval 1';                                      
        fsmObj2.Auto_Approved_1__c=false; 
        fsmObj2.Auto_Approved_2__c=false;
        fsmObj2.X1st_Approval_Date_Time__c=System.now()-3;
        fsmObj2.X2nd_Approval_Date_Time__c=null; 
        fsmObj2.X3rd_Approval_Date_Time__c=null;
        fsmObj2.Need_Marketing_HO_Approval__c=false;
        fsmObj2.Sales_Assistant__c=zmUser.Id; 
        update fsmObj2;
        
        Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
        req.setComments('Auto Approved');
        req.setAction('Approve');
        System.debug('fsmObj.id : '+fsmObj2.id);
        req.setNextApproverIds(new Id[] {AutoApprovalProcessBatch.getApproverId(fsmObj2.id)});
        
        Test.startTest();
        AutoApprovalProcessBatch batchObj=new AutoApprovalProcessBatch(new List<String>{'1210'});// Edited by Sandeep vishwakarma AF Material requisition
        Database.executeBatch(batchObj,1);
        
        Test.stopTest();
        
        Free_Sample_Management__c fsmObj3 = new Free_Sample_Management__c();
        fsmObj3.Id = fsmObj.Id; 
        fsmObj3.Zip_Code__c = '123-4567';                                                      // Zip Code
        fsmObj3.SalesOrg__c = salesOrg.Id;                                              // Sales Org
        fsmObj3.Territory_Manager__c = userObj.Id;                                      // Territory Manager
        fsmObj3.Depot__c = depObj.Id;                                                  // Depot
        fsmObj3.Depot_Person_Email_ID__c = 'shama.buchade@skinternational.com';               // Depot Person Email ID
        fsmObj3.Territory__c = territoryObj.Id;                                              // Territory
        fsmObj3.HO_Commercial_Email_ID__c = 'shama.buchade@skinternational.com';               // HO Commercial Email ID
        fsmObj3.Approval_Submission_Date_Time__c=System.now()-3;
        fsmObj3.RMNotification12HrsChecked__c = true;                                         // RMNotification12HrsChecked
        fsmObj3.ZMNotification12HrsChecked__c = false;                                          // ZMNotification12HrsChecked
        fsmObj3.ZMNotification18HrsChecked__c = false;                                         // ZMNotification18HrsChecked
        fsmObj3.RMNotification18HrsChecked__c = true;                                         // RMNotification18HrsChecked
        fsmObj3.Record_Created_By__c = 'Non Office Manager';                                   // Record Created By
        fsmObj3.Office_Manager__c = null;                                         // Office Manager
        fsmObj3.Status__c = 'Pending';                                                         // Status
        fsmObj3.Sub_Status__c = 'Pending for Approval 2';                                      // Sub Status
        fsmObj3.Auto_Approved_2__c=true;
        fsmObj3.Need_Marketing_HO_Approval__c=false;
        fsmObj3.X1st_Approval_Date_Time__c=System.now()-3;
        fsmObj3.X2nd_Approval_Date_Time__c=null; 
        fsmObj3.X3rd_Approval_Date_Time__c=null;
        fsmObj3.Sales_Assistant__c=zmUser.Id;
        update fsmObj3;

        
    }
    
    /*static TestMethod void methodFor2NDCondition(){
        
        UserRole usroleObj=new UserRole();
        usroleObj.Name='Sk International';
        
        Sales_Org__c salesOrg= new Sales_Org__c();
        salesorg.Name='SWAL';
        salesorg.Description__c='SWAL';
        salesorg.Sales_Org_Code__c='1210';
        insert salesorg;
        
        Depot__c depObj=new Depot__c();
        depObj.Name='Mumbai1';
        depObj.Country__c='SWAL';
        depObj.Location__c='Mumbai';
        depObj.Depot_Code__c='MUM2';
        depObj.Active__c=true;
        depObj.SalesOrg__c=salesorg.Id;
        insert depObj;
        
        Territory_Distributor__c territoryObj = new Territory_Distributor__c();
        territoryObj.Name = 'Fatehabad1';                     // Territory Name
        territoryObj.TerritoryCode__c = 'SW061';               // Code
        territoryObj.SalesOrg__c = salesorg.Id;          // Sales Org
        territoryObj.Present_in_KEDE__c = true;                // Present in KEDE
        insert territoryObj;
        
        Profile p = [SELECT Id FROM Profile WHERE Name  = 'Territory Manager SWAL' LIMIT 1]; 
        
        User userObj = new User();
        userObj.Alias='Austin1';
        userObj.Email='steve.austn@mid.org';
        userObj.Username='steve.austn@mid.org';
        System.debug('id :'+p.Id);
        userObj.ProfileId=p.Id;
        userObj.IsActive=true;
        userObj.Show_Inventory__c=false;
        userObj.Show_Credit_Limit__c=false;
        userObj.LastName='Terriotory Manager1';
        userObj.CommunityNickname = 'zonalExe1222'; 
        userObj.TimeZoneSidKey = 'Asia/Kolkata'; 
        userObj.LocaleSidKey = 'en_IN';                                    
        userObj.LanguageLocaleKey = 'en_US';                                             
        userObj.ForecastEnabled = false;                                                     
        userObj.EmailEncodingKey = 'ISO-8859-1';  
        insert userObj;
        
        Profile p2 = [SELECT Id FROM Profile WHERE Name  = 'Regional/Zonal Manager SWAL' LIMIT 1]; 
        
        User rmUser = new User();
        rmUser.Alias = 'UDAIVIR1';                                                                                                                                                                                                                                                                                  
        rmUser.Email = 'satish.tiware@skinternational.com';                                                                                                                                                                                                                                                     
        rmUser.ProfileId = p2.id;                                                                                                                                                                                                                                                                          
        rmUser.Username = '20035@upl-ltd.com.upltest';
        rmUser.LastName='REGIONAL MANAGER1';                                                                                                                                                                                                                                                      
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
        
        Region__c regionObj = new Region__c();
        regionObj.Region_Name__c = 'HISSAR1';        // Region Name
        regionObj.RegionCode__c = 'SW007';            // Region Code
        regionObj.SalesOrg__c = salesOrg.Id;    // Sales Org
        regionObj.RegionHead__c = rmUser.Id;  // Region Head
        insert regionObj;
        
        User zmUser = new User();
        zmUser.Alias = 'SATEND';                                                                                                                                                                                                                                                                                  
        zmUser.Email = 'satish.tiware@skinternational.com';                                                                                                                                                                                                                                                     
        zmUser.ProfileId = p2.id;                                                                                                                                                                                                                                                                          
        zmUser.Username = '20502@upl-ltd.com.upltest';
        zmUser.LastName='Zonal Head1';                                                                                                                                                                                                                                                      
        zmUser.IsActive = true;                                                                                                                                                                                                              
        zmUser.UserPermissionsMarketingUser = false;                                                                                                                                                                                                                                                             
        zmUser.UserPermissionsOfflineUser = false;                                                                                                                                                                                                                                                               
        zmUser.UserPermissionsKnowledgeUser = false;                                                                                                                                                                                                                                                             
        zmUser.UserPermissionsInteractionUser = false;                                                                                                                                                                                                                                                           
        zmUser.UserPermissionsSupportUser = false;                                                                                                                                                                                                                                                               
        zmUser.TimeZoneSidKey = 'Asia/Kolkata';                                                                                                                                                                                                                           
        zmUser.UserPermissionsLiveAgentUser = false;                                                                                                                                                                                                                                                             
        zmUser.LocaleSidKey = 'en_IN';                                    
        zmUser.LanguageLocaleKey = 'en_US';                                             
        zmUser.ForecastEnabled = false;                                                                                                                                                                                                                       
        zmUser.EmailEncodingKey = 'ISO-8859-1';
        insert zmUser;
        
        Zone__c zoneObj = new Zone__c();
        zoneObj.Name = 'Chandigarh1';
        zoneObj.ZoneCode__c = 'SWZ02';
        zoneObj.ZonalHead__c = zmUser.Id;
        zoneObj.SalesOrg__c = salesOrg.Id;
        insert zoneObj;
        List<RecordType> rtype=[SELECT Id, Name, IsActive FROM RecordType where Name='Post Free Sample Management' limit 1];
        
        Free_Sample_Management__c fsmObj = new Free_Sample_Management__c();
        fsmObj.RecordTypeId=rtype[0].Id;
        fsmObj.Zip_Code__c = '123-4567';                                                      // Zip Code
        fsmObj.SalesOrg__c = salesOrg.Id;                                              // Sales Org
        fsmObj.Territory_Manager__c = userObj.Id;                                      // Territory Manager
        fsmObj.Depot__c = depObj.Id;                                                  // Depot
        fsmObj.Depot_Person_Email_ID__c = 'shama.buchade@skinternational.com';               // Depot Person Email ID
        fsmObj.Territory__c = territoryObj.Id;                                              // Territory
        fsmObj.HO_Commercial_Email_ID__c = 'shama.buchade@skinternational.com';               // HO Commercial Email ID
        //fsmObj.Approval_Submission_Date_Time__c=System.now()-3;
        fsmObj.RMNotification12HrsChecked__c = false;                                        
        fsmObj.ZMNotification12HrsChecked__c = false;                                         
        fsmObj.ZMNotification18HrsChecked__c = false;                                         
        fsmObj.RMNotification18HrsChecked__c = false;                                         
        fsmObj.Record_Created_By__c = 'Non Office Manager';                                   
        fsmObj.Office_Manager__c = rmUser.Id;                                         
        fsmObj.Status__c = 'Draft';                                   
        fsmObj.Auto_Approved_1__c=false;
        fsmObj.Auto_Approved_2__c=false;
        fsmObj.X1st_Approval_Date_Time__c=null;
        fsmObj.X2nd_Approval_Date_Time__c=null; 
        fsmObj.X3rd_Approval_Date_Time__c=null;
        fsmObj.Sales_Assistant__c=zmUser.Id;
        insert fsmObj;
        
        Approval.ProcessSubmitRequest app = new Approval.ProcessSubmitRequest();
        app.setObjectId(fsmObj.id);
        
        Free_Sample_Management__c fsmObj4 = new Free_Sample_Management__c();
        fsmObj4.Id = fsmObj.Id; 
        fsmObj4.Zip_Code__c = '123-4567';                                                      // Zip Code
        fsmObj4.SalesOrg__c = salesOrg.Id;                                              // Sales Org
        fsmObj4.Territory_Manager__c = userObj.Id;                                      // Territory Manager
        fsmObj4.Depot__c = depObj.Id;                                                  // Depot
        fsmObj4.Depot_Person_Email_ID__c = 'shama.buchade@skinternational.com';               // Depot Person Email ID
        fsmObj4.Territory__c = territoryObj.Id;                                              // Territory
        fsmObj4.HO_Commercial_Email_ID__c = 'shama.buchade@skinternational.com';               // HO Commercial Email ID
        fsmObj4.Approval_Submission_Date_Time__c=System.now()-3;
        fsmObj4.Record_Created_By__c = 'Non Office Manager';                                   // Record Created By
        fsmObj4.Office_Manager__c = rmUser.Id;                                         // Office Manager
        fsmObj4.Status__c = 'Pending';                                                         // Status
        fsmObj4.Sub_Status__c = 'Pending for Approval 2';                                      // Sub Status
        fsmObj4.Auto_Approved_1__c=true;
        fsmObj4.Auto_Approved_2__c=false;
        fsmObj4.Need_Marketing_HO_Approval__c=false;
        fsmObj4.X1st_Approval_Date_Time__c=System.now()-3;
        fsmObj4.X2nd_Approval_Date_Time__c=null; 
        fsmObj4.X3rd_Approval_Date_Time__c=null;
        fsmObj4.Sales_Assistant__c=zmUser.Id;
        update fsmObj4;

        
        Test.startTest();
        AutoApprovalProcessBatch batchObj=new AutoApprovalProcessBatch('1210');
        //Database.executeBatch(batchObj,1);
        Test.stopTest();
        
    }*/
    static testmethod void schedulerTest() {
        String CRON_EXP = '0 0 * * * ?';
        Test.startTest();
            String jobId = System.schedule('ScheduleApexClassTest',  CRON_EXP, new AutoApprovalProcessScheduler());
            CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
            System.assertEquals(CRON_EXP, ct.CronExpression);
            System.assertEquals(0, ct.TimesTriggered);
        Test.stopTest();
    }
    
}