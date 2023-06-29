/*
 * Written by: Sayan Majumder (crmconsultant3@upl-ltd.com) ; 4/4/2021
 * Projected Apex Class: SwalLiquidationApprovalController
 * Coverage on 4th April 2021: 83%
*/

@isTest
public class SwalLiquidationApprovalController_Test {
    @TestSetup
    static void makeData(){
        Multi_Country_Liquidation__c liquiRecord = new Multi_Country_Liquidation__c();
        liquiRecord.Name = 'Liquidation AF';
        liquiRecord.Enable_Liq_Validation__c = false;
        liquiRecord.Hide_Current_Month_Option__c = false;
        insert liquiRecord;
        
        Trigger_Settings__c record = new Trigger_Settings__c();
        record.Name = 'LiquidationTrigger';
        record.IsActive__c	= true;
        insert record;
        
        Trigger_Settings__c record1 = new Trigger_Settings__c();
        record1.Name = 'LiquidationApprovalTrigger';
        record1.IsActive__c	= true;
        insert record1;
    }
    
    
    
    @isTest
    static void allTheDataForThisTestClass(){
        
        Sales_Org__c salesOrgObj = new Sales_Org__c();
        salesOrgObj.Name = 'SWAL';
        salesOrgObj.Description__c = 'SWAL';
        salesOrgObj.Company_Code__c = '1210';
        salesOrgObj.Sales_Org_Code__c = '1210';
        insert salesOrgObj;
        
        userrole  usrole = new userrole();
        usrole.Name ='Test Role';
        
        Profile sysAdminProfile = [SELECT Id,name FROM Profile WHERE Name = 'System Administrator'];
        User SysAdminUser = new User();
        SysAdminUser.Alias = 'smaju';                                                            
        SysAdminUser.Email = 'crmconsultant3@upl-ltd.com';                             
        SysAdminUser.ProfileId  = sysAdminProfile.ID;
        SysAdminUser.UserRoleId=usrole.id;
        SysAdminUser.Username = '3001191@upl-ltd.com';                                    
        SysAdminUser.IsActive = true;  
        SysAdminUser.FirstName='Sayan';
        SysAdminUser.LastName='Majumder';
        SysAdminUser.CommunityNickname = 'sayamaj1'; 
        SysAdminUser.TimeZoneSidKey = 'Asia/Kolkata'; 
        SysAdminUser.LocaleSidKey = 'en_IN';                                    
        SysAdminUser.LanguageLocaleKey = 'en_US';                                             
        SysAdminUser.ForecastEnabled = false;                                                     
        SysAdminUser.EmailEncodingKey = 'ISO-8859-1';    
        SysAdminUser.Show_Inventory__c = false;                                                     
        SysAdminUser.Show_Credit_Limit__c = false; 
        SysAdminUser.Country = 'India';
        SysAdminUser.MobilePhone = '9748694980';
        insert SysAdminUser;
        
        Profile tmProfile = [SELECT Id,name FROM Profile WHERE Name = 'Territory Manager SWAL'];
        User tmUser = new User();
        tmUser.Alias = 'kml';                                                            
        tmUser.Email = 'kamaljit.singh@swal.in';                             
        tmUser.ProfileId  = tmProfile.ID;
        tmUser.UserRoleId=usrole.id;
        tmUser.Username = '2000858299@swal.in.uat';                                    
        tmUser.IsActive = true;
        tmUser.FirstName='kamaljit';
        tmUser.LastName='singh';
        tmUser.CommunityNickname = 'kamal'; 
        tmUser.TimeZoneSidKey = 'Asia/Kolkata'; 
        tmUser.LocaleSidKey = 'en_IN';                                    
        tmUser.LanguageLocaleKey = 'en_US';                                             
        tmUser.ForecastEnabled = false;                                                     
        tmUser.EmailEncodingKey = 'ISO-8859-1';    
        tmUser.Show_Inventory__c = false;                                                     
        tmUser.Show_Credit_Limit__c = false; 
        tmUser.Country = 'India';
        tmUser.MobilePhone = '9748694981';
        insert tmUser;
        
        Profile zmmProfile = [SELECT Id,name FROM Profile WHERE Name = 'Regional/Zonal Manager SWAL'];
        User zmmUser = new User();
        zmmUser.Alias = 'SATENDRA';                                                            
        zmmUser.Email = 'shama.buchade@skinternational.com';                             
        zmmUser.ProfileId  = zmmProfile.ID;
        zmmUser.UserRoleId=usrole.id;
        zmmUser.Username = '2000331699@swal.in.uat';                                    
        zmmUser.IsActive = true;
        zmmUser.FirstName='SATENDRA';
        zmmUser.LastName='SINGH';
        zmmUser.CommunityNickname = 'saten'; 
        zmmUser.TimeZoneSidKey = 'Asia/Kolkata'; 
        zmmUser.LocaleSidKey = 'en_IN';                                    
        zmmUser.LanguageLocaleKey = 'en_US';                                             
        zmmUser.ForecastEnabled = false;                                                     
        zmmUser.EmailEncodingKey = 'ISO-8859-1';    
        zmmUser.Show_Inventory__c = false;                                                     
        zmmUser.Show_Credit_Limit__c = false; 
        zmmUser.Country = 'India';
        zmmUser.MobilePhone = '9748694982';
        insert zmmUser;
        
        Profile rmProfile = [SELECT Id,name FROM Profile WHERE Name = 'Regional/Zonal Manager SWAL'];
        User rmUser = new User();
        rmUser.Alias = 'NEERAJ S';                                                            
        rmUser.Email = 'neeraj.sharma@swal.in';                             
        rmUser.ProfileId  = rmProfile.ID;
        rmUser.UserRoleId=usrole.id;
        rmUser.Username = '2000330499@swal.in.uat';                                    
        rmUser.IsActive = true;
        rmUser.FirstName='Neeraj';
        rmUser.LastName='Sharma';
        rmUser.CommunityNickname = 'neeraj'; 
        rmUser.TimeZoneSidKey = 'Asia/Kolkata'; 
        rmUser.LocaleSidKey = 'en_IN';                                    
        rmUser.LanguageLocaleKey = 'en_US';                                             
        rmUser.ForecastEnabled = false;                                                     
        rmUser.EmailEncodingKey = 'ISO-8859-1';    
        rmUser.Show_Inventory__c = false;                                                     
        rmUser.Show_Credit_Limit__c = false; 
        rmUser.Country = 'India';
        rmUser.MobilePhone = '9748694983';
        insert rmUser;
        
        
        Profile normalProfile = [SELECT Id,name FROM Profile WHERE Name = 'Brazil Sales Price Admin'];
        User normalUser = new User();
        normalUser.Alias = 'Pedro';                                                            
        normalUser.Email = 'Pedro.Nery@upl.in';                             
        normalUser.ProfileId  = normalProfile.ID;
        normalUser.UserRoleId=usrole.id;
        normalUser.Username = 'fake@swal.in.uat';                                    
        normalUser.IsActive = true;
        normalUser.FirstName='Pedro';
        normalUser.LastName='Nery';
        normalUser.CommunityNickname = 'pedro'; 
        normalUser.TimeZoneSidKey = 'Asia/Kolkata'; 
        normalUser.LocaleSidKey = 'en_IN';                                    
        normalUser.LanguageLocaleKey = 'en_US';                                             
        normalUser.ForecastEnabled = false;                                                     
        normalUser.EmailEncodingKey = 'ISO-8859-1';    
        normalUser.Show_Inventory__c = false;                                                     
        normalUser.Show_Credit_Limit__c = false; 
        normalUser.Country = 'India';
        normalUser.MobilePhone = '9748694984';
        insert normalUser;
        
        Id rtforAnnualPlan = Schema.SObjectType.Liquidation_Annual_Plan__c.getRecordTypeInfosByName().get('SWAL TRADE').getRecordTypeId();
        Id rtforOpeningInventory = Schema.SObjectType.Opening_Inventory2__c.getRecordTypeInfosByName().get('SWAL TRADE').getRecordTypeId();
        Id rtforLiquidation = Schema.SObjectType.Liquidation2__c.getRecordTypeInfosByName().get('SWAL TRADE').getRecordTypeId();
        Id rtforProduct = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('US').getRecordTypeId();
        
        
        Zone__c zoneObj = new Zone__c();
        zoneObj.Name='Chandigarh';
        zoneObj.SalesOrg__c=salesOrgObj.Id;
        zoneObj.ZoneCode__c='SWZ01';
        zoneObj.ZonalHead__c=zmmUser.Id;
        insert zoneObj;
        
        Region__c regionObj = new Region__c();
        regionObj.Name='LUDHIANA';
        regionObj.RegionCode__c='SW007';
        regionObj.SalesOrg__c =salesOrgObj.Id;
        regionObj.RegionHead__c=rmUser.Id;
        insert regionObj;
        
        Territory_Distributor__c territoryObj = new Territory_Distributor__c();
        territoryObj.Name = 'Khanna';
        territoryObj.TerritoryCode__c = 'SW423';
        territoryObj.SalesOrg__c = salesOrgObj.id;
        territoryObj.Region__c = regionObj.id;
        territoryObj.TerritoryManager__c = tmUser.Id;
        territoryObj.Zone__c = zoneObj.id;
        territoryObj.Present_in_KEDE__c = true ;
        territoryObj.Neglected__c = false;
        insert territoryObj;
        
        Territory_Distributor__c territoryObj2 = new Territory_Distributor__c();
        territoryObj2.Name = 'Chittaurgarh';
        territoryObj2.TerritoryCode__c = 'SW424';
        territoryObj2.SalesOrg__c = salesOrgObj.id;
        //territoryObj2.Region__c = regionObj.id;
        territoryObj2.TerritoryManager__c = tmUser.Id;
        territoryObj2.Zone__c = zoneObj.id;
        territoryObj2.Present_in_KEDE__c = true ;
        territoryObj2.Neglected__c = false;
        insert territoryObj2;
        
        
        Liquidation_Annual_Plan__c liqannlPlnObj = new Liquidation_Annual_Plan__c();
        liqannlPlnObj.Fiscal_Start_Date__c = Date.newInstance(2020, 04, 01);
        liqannlPlnObj.FIscal_Year__c = '2020-2021';
        liqannlPlnObj.Fiscal_End_Date__c = Date.newInstance(2021,03, 31);
        liqannlPlnObj.SentToBatch__c = false;
        liqannlPlnObj.Territory_Name__c = territoryObj.Id;
        liqannlPlnObj.RecordTypeId = rtforAnnualPlan;
        liqannlPlnObj.Sales_Org__c = salesOrgObj.id;
        insert liqannlPlnObj;
        
        List<Product2> prodList = new List<Product2>();
        for( integer i=0;i<=3;i++ ){
            Product2 ProductObj = new Product2();
            ProductObj.Name = 'Product'+i;
            ProductObj.ProductCode = '71450'+i;
            ProductObj.Product_Code__c = '71450'+i;
            ProductObj.IsActive = true;
            ProductObj.Active__c = true;
            ProductObj.Sales_Org__c = salesOrgObj.Id;
            ProductObj.Combination_Key__c = '7145010002010'+i;
            ProductObj.Popular__c = false;
            ProductObj.Active_For_Liquidation__c = true;
            ProductObj.Indication_Type__c = 'Insecticide';
            ProductObj.Budget_NRV__c = 50.00;
            //ProductObj.RecordTypeId = rtforProduct;
            prodList.add(ProductObj);
        }
        /*prodList[0].Brand_Type__c='Platinum';
prodList[1].Brand_Type__c='Gold';
prodList[2].Brand_Type__c='Silver';
prodList[3].Brand_Type__c='Others';*/
        
        insert prodList;
        
        List<Opening_Inventory2__c> openinvList = new List<Opening_Inventory2__c>();
        Integer i = 0;
        for( Product2 v:prodList ){
            Opening_Inventory2__c openInveObj = new Opening_Inventory2__c();
            openInveObj.Product__c = v.Id;
            openInveObj.Opening_Inventory__c = i+56;
            openInveObj.Liquidation_Annual_Plan__c = liqannlPlnObj.id;
            openInveObj.X15_days_lock__c = false;
            openInveObj.Territory__c = territoryObj.Id;
            openInveObj.YTD_Sales__c = i;
            openInveObj.YTD_Sales_Jan__c = i+10;
            openInveObj.YTD_Sales_Feb__c = i+10;
            openInveObj.YTD_Sales_Mar__c = i;
            openInveObj.YTD_Sales_Apr__c = i+10;
            openInveObj.YTD_Sales_May__c = i+10;
            openInveObj.YTD_Sales_Jun__c = i+10;
            openInveObj.YTD_Sales_Jul__c = i+10;
            openInveObj.YTD_Sales_Aug__c = i+10;
            openInveObj.YTD_Sales_Sept__c = i+10;
            openInveObj.YTD_Sales_Oct__c = i+10;
            openInveObj.YTD_Sales_Nov__c = i+10;
            openInveObj.YTD_Sales_Dec__c = i+10;
            openInveObj.RecordTypeId = rtforOpeningInventory;
            i+=10;
            openinvList.add(openInveObj);
        }
        insert openinvList;
        
        
        List<Liquidation2__c> LiqList = new List<Liquidation2__c>();
        Integer j=0;
        for( Opening_Inventory2__c v:openinvList ){
            Liquidation2__c liq = new Liquidation2__c();
            liq.Opening_Inventory2__c = v.id;
            liq.Liquidation_Annual_Plan__c = liqannlPlnObj.Id;
            liq.Product__c = v.Product__c;
            liq.Type__c = 'Trade';
            liq.Month__c = 'Mar';
            liq.Liquidation__c = j;
            liq.Plan_for_the_month__c = j;
            liq.Retailers_Inventory__c = j+3;
            liq.Distributors_Inventory__c = j+2;
            liq.Plan_for_the_next_month__c = j;
            liq.Territory__c = territoryObj.Id;
            liq.RecordTypeId = rtforLiquidation;
            liq.submitted_Trade_SWAL__c =true;
            j+=10;
            LiqList.add(liq);
        }
        insert LiqList;
        
        List<Crop__c> CropList = new List<Crop__c>();
        Crop__c crpObj = new Crop__c();
        crpObj.Name = 'Cereals';
        crpObj.Crop_Code__c = 'CL001';            
        crpObj.Active__c = true;
        crpObj.SalesOrg__c = salesOrgObj.Id;
        crpObj.Type__c = 'Category';
        crpObj.Active_for_Crop_Liquidation__c = true;
        CropList.add(crpObj);
        
        Crop__c crpObj2 = new Crop__c();
        crpObj2.Name = 'Oilseeds';
        crpObj2.Crop_Code__c = 'OL003';            
        crpObj2.Active__c = true;
        crpObj2.SalesOrg__c = salesOrgObj.Id;
        crpObj2.Type__c = 'Category';
        crpObj2.Active_for_Crop_Liquidation__c = true;
        CropList.add(crpObj2);
        
        insert CropList;
        
        List<Liquidation2__c> insertedLiq = new List<Liquidation2__c>();
        insertedLiq = [ SELECT Id,Liquidation_YTD_SWAL__c FROM Liquidation2__c WHERE Id IN:LiqList LIMIT 2];
        for( Liquidation2__c vg:insertedLiq ){
            system.debug('Sayan-->'+vg.Id+'---'+vg.Liquidation_YTD_SWAL__c);
        }
        List<Crop_Liquidation__c> CropLiqList = new List<Crop_Liquidation__c>();
        for( Liquidation2__c k:insertedLiq ){
            for( Crop__c c:CropList ){
                Crop_Liquidation__c crpLiqObj = new Crop_Liquidation__c();
                crpLiqObj.Crop__c = c.Id;
                crpLiqObj.Liquidation__c = k.Id;
                crpLiqObj.Sales_Org__c = salesOrgObj.Id;
                crpLiqObj.Liquidation_Value__c = 0.0;
                crpLiqObj.is_Crop_Liquidation_Submitted__c = true;
                crpLiqObj.Liquidation_YTD_Trade__c = k.Liquidation_YTD_SWAL__c;
                CropLiqList.add(crpLiqObj);
            }
        }
        insert CropLiqList;
        
        
        Sub_Crops__c subCrop1  = new Sub_Crops__c();
        subCrop1.Name = 'Maize';
        subCrop1.Crop__c = crpObj.ID;
        subCrop1.Sales_Org__c = salesOrgObj.Id;
        insert subCrop1;
        
        Sub_Crops__c subCrop2  = new Sub_Crops__c();
        subCrop2.Name = 'Groundnut';
        subCrop2.Crop__c = crpObj2.ID;
        subCrop2.Sales_Org__c = salesOrgObj.Id;
        insert subCrop2;
        
        Sub_Crop_Liquidation__c	subCropLiquidation = new Sub_Crop_Liquidation__c();
        subCropLiquidation.Crop_Liquidation__c = CropLiqList[0].Id;
        subCropLiquidation.Is_Sub_Crop_Liquidation_Submitted__c=false;
        subCropLiquidation.Sales_Org__c= salesOrgObj.Id;
        subCropLiquidation.Sub_Crop_Liquidation_Value__c=0;	
        subCropLiquidation.Sub_Crops__c=subCrop1.ID;
        subCropLiquidation.Liquidation__c=CropLiqList[0].Liquidation__c;
        insert subCropLiquidation;
        
        Sub_Crop_Liquidation__c	subCropLiquidation2 = new Sub_Crop_Liquidation__c();
        subCropLiquidation2.Crop_Liquidation__c = CropLiqList[1].Id;
        subCropLiquidation2.Is_Sub_Crop_Liquidation_Submitted__c=false;
        subCropLiquidation2.Sales_Org__c= salesOrgObj.Id;
        subCropLiquidation2.Sub_Crop_Liquidation_Value__c=0;	
        subCropLiquidation2.Sub_Crops__c=subCrop2.ID;
        subCropLiquidation2.Liquidation__c=CropLiqList[0].Liquidation__c;
        insert subCropLiquidation2;
        
        Liquidation_Approval_History__c newApprovalInstance1 = new Liquidation_Approval_History__c();
        newApprovalInstance1.Name = 'One';
        newApprovalInstance1.Territory__c = territoryObj.Id;
        newApprovalInstance1.Month__c = 'Mar';
        //newApprovalInstance1.Submitted_By__c = userinfo.getUserId();
        newApprovalInstance1.Territory_Manager_Email__c = 'sayamaj1@in.ibm.com';
        newApprovalInstance1.Approval_Status__c = 'Pending for Approval';
        newApprovalInstance1.SalesOrg__c = salesOrgObj.Id;
        newApprovalInstance1.LAP__c = liqannlPlnObj.Id;
        insert newApprovalInstance1;
        Liquidation_Approval_History__c newApprovalInstance2 = new Liquidation_Approval_History__c();
        newApprovalInstance2.Name = 'Two';
        newApprovalInstance2.Territory__c = territoryObj.Id;
        newApprovalInstance2.Month__c = 'Apr';
        //newApprovalInstance2.Submitted_By__c = userinfo.getUserId();
        newApprovalInstance2.Territory_Manager_Email__c = 'sayamaj1@in.ibm.com';
        newApprovalInstance2.Approval_Status__c = 'Approved';
        newApprovalInstance2.SalesOrg__c = salesOrgObj.Id;
        newApprovalInstance2.LAP__c = liqannlPlnObj.Id;
        insert newApprovalInstance2;
        Liquidation_Approval_History__c newApprovalInstance3 = new Liquidation_Approval_History__c();
        newApprovalInstance3.Name = 'Three';
        newApprovalInstance3.Territory__c = territoryObj.Id;
        newApprovalInstance3.Month__c = 'May';
        //newApprovalInstance3.Submitted_By__c = userinfo.getUserId();
        newApprovalInstance3.Territory_Manager_Email__c = 'sayamaj2@in.ibm.com';
        newApprovalInstance3.Approval_Status__c = 'Rejected';
        newApprovalInstance3.SalesOrg__c = salesOrgObj.Id;
        newApprovalInstance3.LAP__c = liqannlPlnObj.Id;
        insert newApprovalInstance3;
        Liquidation_Approval_History__c newApprovalInstance4 = new Liquidation_Approval_History__c();
        newApprovalInstance4.Name = 'Four';
        newApprovalInstance4.Territory__c = territoryObj.Id;
        newApprovalInstance4.Month__c = 'Jun';
        //newApprovalInstance4.Submitted_By__c = userinfo.getUserId();
        newApprovalInstance4.Territory_Manager_Email__c = 'sayamaj3@in.ibm.com';
        newApprovalInstance4.Approval_Status__c = 'Pending for Approval';
        newApprovalInstance4.SalesOrg__c = salesOrgObj.Id;
        newApprovalInstance4.LAP__c = liqannlPlnObj.Id;
        insert newApprovalInstance4;
        
        
        Opening_Inventory2__c openInveObj = new Opening_Inventory2__c();
        openInveObj.Product__c = prodList[0].Id;
        openInveObj.Opening_Inventory__c = 600;
        openInveObj.Liquidation_Annual_Plan__c = liqannlPlnObj.id;
        openInveObj.X15_days_lock__c = false;
        openInveObj.Territory__c = territoryObj.Id;
        openInveObj.YTD_Sales__c = 50;
        openInveObj.YTD_Sales_Jan__c = 100;
        openInveObj.YTD_Sales_Feb__c = 100;
        openInveObj.YTD_Sales_Mar__c = 100;
        openInveObj.YTD_Sales_Apr__c = 100;
        openInveObj.YTD_Sales_May__c = 100;
        openInveObj.YTD_Sales_Jun__c = 100;
        openInveObj.YTD_Sales_Jul__c = 100;
        openInveObj.YTD_Sales_Aug__c = 100;
        openInveObj.YTD_Sales_Sept__c = 100;
        openInveObj.YTD_Sales_Oct__c = 100;
        openInveObj.YTD_Sales_Nov__c = 100;
        openInveObj.YTD_Sales_Dec__c = 100;
        openInveObj.RecordTypeId = rtforOpeningInventory;
        insert openInveObj;
        
        List<Liquidation2__c> newLiq = new List<Liquidation2__c>();
        Liquidation2__c liq = new Liquidation2__c();
        liq.Opening_Inventory2__c = openInveObj.id;
        liq.Liquidation_Annual_Plan__c = liqannlPlnObj.Id;
        liq.Product__c = prodList[0].id;
        liq.Type__c = 'Trade';
        liq.Month__c = 'Mar';
        liq.Liquidation__c = 10;
        liq.Plan_for_the_month__c = 10;
        liq.Retailers_Inventory__c = 3;
        liq.Distributors_Inventory__c = 2;
        liq.Plan_for_the_next_month__c = 10;
        liq.Territory__c = territoryObj.Id;
        liq.RecordTypeId = rtforLiquidation;
        liq.submitted_Trade_SWAL__c =true;
        insert liq;
        
        Liquidation2__c liq2 = new Liquidation2__c();
        liq2.Opening_Inventory2__c = openInveObj.id;
        liq2.Liquidation_Annual_Plan__c = liqannlPlnObj.Id;
        liq2.Product__c = prodList[0].id;
        liq2.Type__c = 'Trade';
        liq2.Month__c = 'May';
        liq2.Liquidation__c = 10;
        liq2.Plan_for_the_month__c = 10;
        liq2.Retailers_Inventory__c = 3;
        liq2.Distributors_Inventory__c = 2;
        liq2.Plan_for_the_next_month__c = 10;
        liq2.Territory__c = territoryObj.Id;
        liq2.RecordTypeId = rtforLiquidation;
        liq2.submitted_Trade_SWAL__c =true;
        insert liq2;
        
        Liquidation2__c liq3 = new Liquidation2__c();
        liq3.Opening_Inventory2__c = openInveObj.id;
        liq3.Liquidation_Annual_Plan__c = liqannlPlnObj.Id;
        liq3.Product__c = prodList[0].id;
        liq3.Type__c = 'Trade';
        liq3.Month__c = 'Jun';
        liq3.Liquidation__c = 10;
        liq3.Plan_for_the_month__c = 10;
        liq3.Retailers_Inventory__c = 3;
        liq3.Distributors_Inventory__c = 2;
        liq3.Plan_for_the_next_month__c = 10;
        liq3.Territory__c = territoryObj.Id;
        liq3.RecordTypeId = rtforLiquidation;
        liq3.submitted_Trade_SWAL__c =true;
        insert liq3;
        
        newLiq.add(liq);
        
        
        system.runAs( SysAdminUser ){
            Test.startTest();
            SwalLiquidationApprovalController.getsTerritories();
            SwalLiquidationApprovalController.getFiscal_Year();
            SwalLiquidationApprovalController.getMonths();
            SwalLiquidationApprovalController.getsliquidationData(territoryObj.Id, '2020-2021', 'Mar');
            SwalLiquidationApprovalController.getCropLiquidationHeaders(territoryObj.Id, '2020-2021', 'Mar');
            SwalLiquidationApprovalController.getCropData(territoryObj.Id, '2020-2021', 'Mar');
            SwalLiquidationApprovalController.getPageURL();
            SwalLiquidationApprovalController.liquiUpdate(LiqList,territoryObj.Id, '2020-2021', 'Mar',true);
            SwalLiquidationApprovalController.liquiUpdate(LiqList,territoryObj.Id, '2020-2021', 'Mar',false);
            SwalLiquidationApprovalController.Validation( territoryObj.Id, '2020-2021', 'Mar',insertedLiq[0].Id,'Distributors_Inventory__c',500 );
            SwalLiquidationApprovalController.Validation( territoryObj.Id, '2020-2021', 'Mar',insertedLiq[0].Id,'Distributors_Inventory__c',2 );
            SwalLiquidationApprovalController.Validation( territoryObj.Id, '2020-2021', 'Mar',insertedLiq[0].Id,'Retailers_Inventory__c',500 );
            SwalLiquidationApprovalController.Validation( territoryObj.Id, '2020-2021', 'Mar',insertedLiq[0].Id,'Retailers_Inventory__c',2 );
            Test.stopTest();
            SwalLiquidationApprovalController.normalUpdate(LiqList[0].Id, 10, territoryObj.Id, '2020-2021', 'Mar');
            SwalLiquidationApprovalController.UpdateNullValueAsZero(territoryObj.Id, '2020-2021', 'Mar', 'Distributors_Inventory__c', LiqList[0].Id);
            SwalLiquidationApprovalController.UpdateNullValueAsZero(territoryObj.Id, '2020-2021', 'Mar', 'Retailers_Inventory__c', LiqList[0].Id);
            SwalLiquidationApprovalController.UpdateNullValueAsZero(territoryObj.Id, '2020-2021', 'Mar', 'Plan_for_the_next_month__c', LiqList[0].Id);
            SwalLiquidationApprovalController.CheckIfLiquidationIsSubmittedApex(territoryObj.Id, '2020-2021', 'Mar');
            SwalLiquidationApprovalController.CheckIfLiquidationIsSubmittedApex(territoryObj.Id, '2020-2021', 'Apr');
            SwalLiquidationApprovalController.CheckIfLiquidationIsSubmittedApex(territoryObj.Id, '2020-2021', 'May');
            SwalLiquidationApprovalController.CheckIfLiquidationIsSubmittedApex(territoryObj.Id, '2020-2021', 'Jun');
            
            SwalLiquidationApprovalController.ApproveAllData(territoryObj.Id, '2020-2021', 'Mar', 'Approved');
            SwalLiquidationApprovalController.RejectAllData(territoryObj.Id, '2020-2021', 'Jun', 'Rejected');
            SwalLiquidationApprovalController.getTerritoryName(territoryObj.Id);
            SwalLiquidationApprovalController.UpdateCropRecords(newLiq,territoryObj.Id, '2020-2021', 'Mar');
            
        }
        system.runAs( tmUser ){
            SwalLiquidationApprovalController.getsTerritories();
        }
        system.runAs( rmUser ){
            SwalLiquidationApprovalController.getsTerritories();
        }
        system.runAs( zmmUser ){
            SwalLiquidationApprovalController.getsTerritories();
        }
        system.runAs( normalUser ){
            SwalLiquidationApprovalController.getsTerritories();
        }
    }
    static testMethod void method2(){ 
    }
}