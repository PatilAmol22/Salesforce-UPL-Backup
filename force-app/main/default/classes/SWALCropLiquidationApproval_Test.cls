/*
 * Written by: Sayan Majumder (crmconsultant3@upl-ltd.com) ; 4/4/2021
 * Projected Apex Class: SWALCropLiquidationApprovalController
 * Coverage on 4th April 2021: 98%
*/

@isTest(seeAlldata=false)
public class SWALCropLiquidationApproval_Test {
    @testSetup
    static void allTheDataForThisTestClass(){
        Trigger_Settings__c newtri = new Trigger_Settings__c();
        newtri.Name = 'LiquidationTrigger';
        newtri.isActive__c = false;
        insert newtri;
        
        
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
        
        Id rtforAnnualPlan = Schema.SObjectType.Liquidation_Annual_Plan__c.getRecordTypeInfosByName().get('SWAL TRADE').getRecordTypeId();
        Id rtforOpeningInventory = Schema.SObjectType.Opening_Inventory2__c.getRecordTypeInfosByName().get('SWAL TRADE').getRecordTypeId();
        Id rtforLiquidation = Schema.SObjectType.Liquidation2__c.getRecordTypeInfosByName().get('SWAL TRADE').getRecordTypeId();
        Id rtforProduct = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('US').getRecordTypeId();
        
        Territory_Distributor__c territoryObj = new Territory_Distributor__c();
        territoryObj.Name = 'Khanna';
        territoryObj.TerritoryCode__c = 'SW423';
        territoryObj.SalesOrg__c = salesOrgObj.id;
        territoryObj.TerritoryManager__c = SysAdminUser.Id;
        territoryObj.Present_in_KEDE__c = true ;
        territoryObj.Neglected__c = false;
        insert territoryObj;

        
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
        
        List<String> insertProdList = new List<String>();
        for( Product2 v:prodList ){
            insertProdList.add(v.Id);
        }
        
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
        
        SWALCropLiquidationApprovalController obj = new SWALCropLiquidationApprovalController();
        obj.selectedTeritorry = territoryObj.Id;
        obj.fiscalyear = '2020-2021';
        obj.mth = 'Mar';
        obj.defaultMethod();
        obj.mth = null;
        obj.defaultMethod();
        obj.recordIdTotupdate = subCropLiquidation.Id;
        obj.prodIdTotupdate = prodList[0].id;
        obj.valueToupdate = '1000';
        obj.updateSingleRecordForCropLiquidation();
        obj.updateCropLiquidation();
        obj.updateCropLiquidationSWAL(territoryObj.Id, 'Mar', liqannlPlnObj.Id, rtforLiquidation);
        obj.CreateCropandSubCropforMissingProducts(insertProdList, territoryObj.Id, 'Mar', liqannlPlnObj.Id);
    }
    static testMethod void method2(){ 
    }
}