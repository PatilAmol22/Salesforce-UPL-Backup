@isTest
public with sharing class GetProcessInstanceDataTest {

   // Edited by Sandeep Vishwakarma - SKI 27-01-2023 - AF Material Requiistion
   @testsetup
    static  void setup() {
        
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
        
        Zone__c zoneObj=new Zone__c();
        zoneObj.Name='Chandigarh';
        zoneObj.ZoneCode__c='SWZ01';
        insert zoneObj;
        
        Region__c regionObj = new Region__c();
        regionObj.Region_Name__c = 'HISSAR';        // Region Name
        regionObj.RegionCode__c = 'SW006';            // Region Code
        regionObj.SalesOrg__c = salesOrg.Id;    // Sales Org
        regionObj.Zone__c = zoneObj.Id;        // Zone
        insert regionObj;
        
        Territory_Distributor__c territoryObj = new Territory_Distributor__c();
        territoryObj.Name = 'Fatehabad';                     // Territory Name
        territoryObj.TerritoryCode__c = 'SW060';               // Code
        territoryObj.SalesOrg__c = salesOrg.Id;          // Sales Org
        territoryObj.Present_in_KEDE__c = true;                // Present in KEDE
        territoryObj.Region__c = regionObj.Id;            // Sales District
        territoryObj.Zone__c = zoneObj.Id;              // Sales Office
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
        userObj.EmailEncodingKey = 'ISO-8859-1';  
        insert userObj;
        
         Profile p3 = [SELECT Id FROM Profile WHERE Name  = 'Regional/Zonal Manager SWAL' LIMIT 1]; 
        
        User rmUser = new User();
        rmUser.Alias = 'UDAIVIR';                                                                                                                                                                                                                                                                                  
        rmUser.Email = 'satish.tiware@skinternational.com';                                                                                                                                                                                                                                                     
        rmUser.ProfileId = p3.id;                                                                                                                                                                                                                                                                          
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
        
        Profile p2 = [SELECT Id FROM Profile WHERE Name  = 'Marketing HO Swal' LIMIT 1]; 
        
        UserRole usroleObj=new UserRole();
        usroleObj.Name='Marketing HO';
        
        User HOUser = new User();
        HOUser.Alias = 'ptiwa';                                                                                                                                                                                                                                                                                  
        HOUser.Email = 'satish.tiware@skinternational.com';                                                                                                                                                                                                                                                     
        HOUser.ProfileId = p2.id;                                                                                                                                                                                                                                                                          
        HOUser.Username = '2055@upl-ltd.com.upltest';
        HOUser.LastName='HO Marketing';  
        HOUser.UserRoleId=usroleObj.Id;
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
        
        List<RecordType> rtype=[SELECT Id, Name, IsActive FROM RecordType where Name='Post Free Sample Management' limit 1];
        
        Free_Sample_Management__c fsmObj = new Free_Sample_Management__c();
        fsmObj.RecordTypeId=rtype[0].Id;
        fsmObj.Zip_Code__c = '123-4567';                                                      // Zip Code
        fsmObj.SalesOrg__c = salesOrg.Id;                                              // Sales Org
        fsmObj.Territory_Manager__c = userObj.Id;                                      // Territory Manager
        fsmObj.Depot__c = depObj.Id;                                                  // Depot
        fsmObj.Depot_Person_Email_ID__c = 'shama.buchade@skinternational.com';               // Depot Person Email ID
        fsmObj.Territory__c = territoryObj.Id;                                              // Territory
        fsmObj.HO_Commercial_Email_ID__c = 'shama.buchade@skinternational.com';
        fsmObj.Record_Created_By__c = 'Non Office Manager';                                   // Record Created By
        fsmObj.Status__c = 'Draft';      // Edited by Sandeep Vishwakarma - SKI 27-01-2023 AF Material Requisition
        fsmObj.Sub_Status__c = 'Draft'; 
        fsmObj.Office_Manager__c = rmUser.Id;   
        fsmObj.Technical_Manager__c=HOUser.Id;
        fsmObj.Raised_By__c  = 'TM';// Edited by Sandeep Vishwakarma - SKI 27-01-2023 AF Material Requisition
        insert fsmObj;
// Edited by Sandeep Vishwakarma - SKI 27-01-2023 AF Material Requisition
        //submitRecord(fsmObj);
        
        

    }

 
    @isTest
    public static void submitRecord() {
        Free_Sample_Management__c fsmObj = [select SalesOrg__r.Sales_Org_Code__c,RecordType.Name,Raised_By__c,Depot__c,Status__c  from Free_Sample_Management__c where status__c='Draft' limit 1];
        User HOUser  = [select Id,lastName from User Where LastName='HO Marketing' limit 1];
		Sales_Org__c salesOrg = [Select Id,Name from Sales_Org__c limit  1];
        System.debug('fsmObj :'+fsmObj);
        Approval.ProcessSubmitRequest app = new Approval.ProcessSubmitRequest();
    	app.setObjectId(fsmObj.id);
        Approval.ProcessResult result = Approval.process(app);
        System.debug('result : '+result.isSuccess());
        System.assert(result.isSuccess());
        
        // Verify the result
        System.assert(result.isSuccess());// Edited by Sandeep Vishwakarma - SKI 27-01-2023 AF Material Requisition
        
        Free_Sample_Management__c fsmObj2 = new Free_Sample_Management__c();
        fsmObj2.Id=fsmObj.Id;
        fsmObj2.Status__c = 'Pending';                                                         // Status
        fsmObj2.Sub_Status__c = 'Pending for Approval 3';                                      // Sub Status
        fsmObj2.Approval_Submission_Date_Time__c=System.today();
        update fsmObj2;
        
        Product2 pro = new Product2();
        pro.ProductCode = '66700';
        pro.Product_Code__c='66700';
        pro.Name='SAATHI';
        pro.Sales_Org__c=salesOrg.Id;
        pro.popular__c = true;
        pro.Combination_Key__c='RM0065100';
        insert pro;
        
        Free_Sampling_Product__c fsp=new Free_Sampling_Product__c();
        fsp.Free_Sampling__c=fsmObj.Id;
        fsp.Product__c=pro.Id;
        fsp.Dose_Acre_GM_ML_L_Per_Acre__c=12;
        fsp.Demo_Size_Acer__c=12;
        fsp.Number_of_Demo__c=12;
        insert fsp;
        
        Crop__c crop=new Crop__c();
        crop.Name='Cereals';
        crop.Crop_Code__c='SCL001';
        crop.SalesOrg__c=salesOrg.Id;
        crop.Active__c=true;
        
        Free_Sampling_Crop_Pest__c fscpObj=new Free_Sampling_Crop_Pest__c();
        fscpObj.Product__c=pro.Id;
    	fscpObj.Free_Sampling__c=fsmObj.Id;
        fscpObj.Target_Crop__c=crop.Id;
        insert fscpObj;
       
        GetProcessInstanceData gpidController=new GetProcessInstanceData();
        //GetProcessInstanceData.getViewDetails(fsmObj.Id);
        GetProcessInstanceData.getProcessItemData(null,null,'Free_Sample_Management__c',null,null,null,null,null,null);
        //create an approval process
       
        UserLookupController.search('Austin', new String[]{HOUser.Id});
        List<ProcessInstanceWorkitem> piwList=[SELECT Id, ActorId,ProcessInstance.TargetObjectId FROM ProcessInstanceWorkitem limit 1];
        
        GetProcessInstanceData.process(null, 'Approve',new String[]{piwList[0].Id}, 'Manual Approve');
    }// Edited by Sandeep Vishwakarma - SKI 27-01-2023 AF Material Requisition
}