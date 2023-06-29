public class LiquidationTestDataFactory {
    //Create Sales Org
    public static Sales_Org__c createSalesOrg( String orgName, String orgCode){
        Sales_Org__c sorg =new Sales_Org__c();
        sorg.Name=orgName;
        sorg.Description__c=orgName;
        sorg.Sales_Org_Code__c=orgCode;
        INSERT sorg;
        return sorg;
   }
    
    // Create Liquidation Users
    public static User createUser(String profileId, String usrName, String country){
        User usr = new User();
        usr.ProfileId = profileId;
        usr.LastName = 'Test';
        usr.Email = usrName+'@test.com';
        usr.Username = usrName+'@test.com'+System.currentTimeMillis();
        usr.TimeZoneSidKey = 'America/Los_Angeles';
        usr.EmailEncodingKey = 'UTF-8';
        usr.LanguageLocaleKey = 'en_US';
        usr.LocaleSidKey = 'en_US';
        usr.Country = country;
        usr.Title = 'title';
        usr.Alias = 'alias';
        INSERT usr;
        
        return usr;
    }
    
    //Create SBU
    public static SBU__c createSBU(String sbuHId, String sbumId, String salesOrgId){
        SBU__c sbuObj = new SBU__c(
        	SBUUser__c = sbuHId, 
            SBUMarketingheads__c = sbumId,
            SBUCode__c = 'TestSBU',              
            SalesOrg__c = salesOrgId  
        );
        
        INSERT sbuObj;
        return sbuObj;
    }
    
    // Create Zone
    public static Zone__c createZone(String zoneName, String salesOrgId, String zoneCode, String sbuId, String zmUsrId, String zmmUsrId){
        Zone__c zoneObj = new Zone__c();
        zoneObj.Name = zoneName;
        zoneObj.ZoneCode__c = zoneCode;
        zoneObj.SalesOrg__c = salesOrgId;
        if(!String.isBlank(sbuId)){
            zoneObj.SBUCode__c = sbuId;
        }
        zoneObj.ZonalHead__c = zmUsrId;
        zoneObj.ZMMUser__c = zmmUsrId;
        
        INSERT zoneObj;
        return zoneObj;
    }
    
    //Create Region
    public static Region__c createRegion(String regionName, String regionCode, String salesOrgId, String rmUsrId, String fmmUsrId, String zoneId){
        Region__c regionObj = new Region__c(
        	Name = regionName,                  
            RegionCode__c = regionCode,              
            SalesOrg__c =salesOrgId,       
            RegionHead__c = rmUsrId, 
            FMM_User__c = fmmUsrId,
            Zone__c = zoneId
        );
        INSERT regionObj;
        return regionObj;
    }
    
    //Create Territory
    public static Territory_Distributor__c createTerritory(String terrName, String terrCode, String salesOrgId, String zoneId, String regionId, String sbuId, String tmUsrId){
        Territory_Distributor__c terrObj = new Territory_Distributor__c();
        terrObj.Name = terrName;
        terrObj.TerritoryCode__c = terrCode;
        terrObj.SalesOrg__c = salesOrgId;
        terrObj.Zone__c = zoneId;
        if(sbuId != ''){
            terrObj.SBU__c = sbuId;
        }else{
            terrObj.Region__c = regionId;
        }
        if(tmUsrId != ''){
        	terrObj.TerritoryManager__c = tmUsrId; 
        }
        terrObj.Present_in_KEDE__c = true;
        
        INSERT terrObj;
        
        return terrObj;
    }
    
    //Create Product
    public static List<Product2> createProductList(Integer count, String salesOrgId,String orgCOde){
        List<Product2> prodListToBeInsert = new List<Product2>();
        for(Integer i = 0; i < count; i++){
            Product2 prodObj = new Product2();
            prodObj.Name = 'Prodduct-'+orgCOde+i;
            prodObj.ProductCode = 'PROD'+orgCOde+i;
            prodObj.Product_Code__c = 'PROD'+orgCOde+i;
            prodObj.Active__c = true;
            prodObj.IsActive = true;
            prodObj.Sales_Org__c = salesOrgId;
            prodObj.Active_For_Liquidation__c = true;
            prodObj.Combination_Key__c = orgCOde+'0002010'+i;
            prodObj.Brand_Name__c = 'Power Brand';
            prodObj.Budget_NRV__c = 50.00;
            prodListToBeInsert.add(prodObj);
        }
        
        INSERT prodListToBeInsert;
        return prodListToBeInsert;
    }
    
    //Create Crop
    public static List<Crop__c> createCropList(Integer count, String salesOrgId, String orgCode){
        List<Crop__c> cropListToBeInserted =  new List<Crop__c>();
        for(Integer i = 0; i < count; i++){
            Crop__c cropObj = new Crop__c();
            cropObj.Name = 'Crop'+orgCode+i;
            cropObj.Crop_Code__c = 'CROP'+orgCode+i;
            cropObj.Active__c = true;
            cropObj.Active_for_Crop_Liquidation__c = true;
            cropObj.Crop_Order__c = i+1;
            cropObj.SalesOrg__c = salesOrgId;
            cropObj.Type__c = 'Category';
            cropListToBeInserted.add(cropObj);
        }
        INSERT cropListToBeInserted;
        return cropListToBeInserted;
    }
    
    //Create Liquidation Approval History Record
    public static Liquidation_Approval_History__c createAppHistory(String status, String lapId, String salesOrgId, String territoryId, Boolean isProdSub, Boolean isCropSub){
        Liquidation_Approval_History__c liqApp = new Liquidation_Approval_History__c(
        	Approval_Status__c = status,
            Is_Product_Liquidation_Submitted__c = isProdSub,
            Is_Crop_Liquidation_Submitted__c = isCropSub,
            LAP__c = lapId,
            SalesOrg__c = salesOrgId,
            Territory__c = territoryId,
            Submitted_By__c = UserInfo.getUserId(),
            Month__c = 'Aug'
        );
       INSERT liqApp;
       return liqApp;
    }
    
    //Create Liquidation Annual Plan 
    public static Liquidation_Annual_Plan__c createLAP(String recTypeId, String salesOrgId, String territoryId){
        Liquidation_Annual_Plan__c lap =  new Liquidation_Annual_Plan__c(
        	Fiscal_Start_Date__c = Date.newInstance(2022, 04, 01),
            Fiscal_End_Date__c = Date.newInstance(2023,03, 31),
            FIscal_Year__c = '2022-2023',
            RecordTypeId = recTypeId,
            Sales_Org__c = salesOrgId,
            Territory_Name__c = territoryId
        );
        INSERT lap;
        return lap;
    }
}