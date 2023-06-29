@isTest
public class TestGtmProductCompetition {
    
    public static Sales_Org__c salesOrg = createSalesOrg();
    public static Login_Country__c loginCountry = createLoginCountry();
    public static List<Crop__c> crops =  createCrops();
    public static List<Product_Category_Sales_Org_Mapping__c> pcsm =  createProductSalesOrgMapping();
    public static User argentinaUser = createuser();
    public static Login_Country__c createLoginCountry(){
        Login_Country__c loginCountry = new Login_Country__c();
        loginCountry.Name = 'Argentina';
        loginCountry.Sales_Org_Code__c = '5631';
        insert loginCountry;
        System.debug('loginCountry test class '+loginCountry);
        return loginCountry;
    }
    
    public static List<Product_Category_Sales_Org_Mapping__c> createProductSalesOrgMapping(){
        List<Product_Category_Sales_Org_Mapping__c> pscms = new List<Product_Category_Sales_Org_Mapping__c>();
        Product_Category__c productCategory1 = new Product_Category__c();
        productCategory1.Name = 'Product1';
        productCategory1.Status__c = 'Active';
        insert productCategory1;
        
        Product_Category_Sales_Org_Mapping__c pcsm1 = new Product_Category_Sales_Org_Mapping__c();
        pcsm1.Product_Category__c=productCategory1.Id;
        pcsm1.Status__c = 'Active';
        pcsm1.Sales_Org__c = salesOrg.Id;
        pcsm1.Category_Index__c = 1;
        insert pcsm1;
        
        
        Product_Category__c productCategory2 = new Product_Category__c();
        productCategory2.Name = 'Product2';
        productCategory2.Status__c = 'Active';
       
        insert productCategory2;
        
        Product_Category_Sales_Org_Mapping__c pcsm2 = new Product_Category_Sales_Org_Mapping__c();
        pcsm2.Product_Category__c=productCategory2.Id;
        pcsm2.Status__c = 'Active';
        pcsm2.Sales_Org__c = salesOrg.Id;
        pcsm2.Category_Index__c = 2;
        insert pcsm2;
        pscms.add(pcsm1);
        pscms.add(pcsm2);
        return pscms;
    }
    
    public static List<Crop__c> createCrops(){
        List<Crop__c> crops = new List<Crop__c>();
        Crop__c crop1 = new Crop__c();
        crop1.Name = 'crop1';
        crop1.GTM_Status__c = 'Active';
        crop1.Category_Index__c = 1;
        crop1.SalesOrg__c = salesOrg.Id;
        insert crop1;
        Crop__c crop2 = new Crop__c();
        crop2.Name = 'crop2';
        crop2.Category_Index__c = 2;
        crop2.GTM_Status__c = 'Active';
        crop2.SalesOrg__c = salesOrg.Id;
        insert crop2;
        crops.add(crop1);
        crops.add(crop2);
        return crops;
        
    }
    
    public static Sales_Org__c createSalesOrg(){
        Sales_Org__c salesOrg1 = new Sales_Org__c();
        salesOrg1.Name = 'Argentina';
        salesOrg1.Sales_Org_Code__c = '5631';
        insert salesOrg1;
        return salesOrg1;
    }
    
    
    
    static testMethod void validateData() 
    {
        System.runAs(argentinaUser){
            
        
        Product_Category__c Pc = new Product_Category__c ();
        Pc.Name = 'Test';
        Pc.Status__c = 'Inactive';
        insert pc;
        
        Competitor__c Cm = new Competitor__c ();
        Cm.Name = 'Test';
        Cm.Status__c = 'Inactive';
        insert Cm;
        
        
        GTM__c  gtm=new GTM__c();
        //Name='test',
        gtm.Fiscal_Year__c='2022-2023';
        gtm.Email__c='priyanka.nalawade@skinternational.com';
        gtm.GTM_Status__c='Active';  
        
        insert gtm;
        
        
        
        
        List<GtmProductCompetition.GtmProductCompWrapper> gtList = new List<GtmProductCompetition.GtmProductCompWrapper>();
        
        List < Product_Category_Sales_Org_Mapping__c > SalesorgProductCategoryMap = [Select Id, Name, Status__c, CreatedBy.Name, 
                                                                                     LastModifiedDate, CreatedDate, Product_Category__c, 
                                                                                     Sales_Org__r.Name, Product_Category__r.Name 
                                                                                     from Product_Category_Sales_Org_Mapping__c ];
        
        for (Product_Category_Sales_Org_Mapping__c obj: SalesorgProductCategoryMap) {
            GtmProductCompetition.GtmProductCompWrapper objwrap = new GtmProductCompetition.GtmProductCompWrapper();
            
            if (obj.Status__c == 'Inactive') {
                objwrap.status = false;
            }
            if (obj.Status__c == 'Active') {
                objwrap.status = true;
            }
            objwrap.productCategoryName = obj.Product_Category__r.Name;
            objwrap.productCategory = obj.Product_Category__c;
            objwrap.productCategorySalesOrgMappingId = obj.Id;
            objwrap.salesOrgName = obj.Sales_Org__r.Name;
            
            objwrap.createdByName = obj.CreatedBy.Name;
            objwrap.lastModifiedDateName = obj.LastModifiedDate;
            gtList.add(objwrap);
            String jsonStr = JSOn.serialize(gtList);
            GtmProductCompetition.updateProductCategoryMapStatus(jsonStr);
            
        }
        
        List<GtmProductCompetition.GtmProductCompWrapper> gtmList = new List<GtmProductCompetition.GtmProductCompWrapper>();
        Competitior_Sales_Org_Mapping__c comSOMapObj = new Competitior_Sales_Org_Mapping__c(
            Sales_Org__c = salesOrg.Id,// Sales Org
            Display_Name__c = 'ATANOR',        // Display Name
            Status__c = 'Inactive'            // Status
        );
        insert comSOMapObj;
        List < Competitior_Sales_Org_Mapping__c > SalesorgCompetitorMap = [Select Id, Name, Status__c, CreatedBy.Name, 
                                                                           LastModifiedDate, CreatedDate, Competitor__c, 
                                                                           Sales_Org__r.Name,Competitor__r.Name, Display_Name__c
                                                                           from Competitior_Sales_Org_Mapping__c ];
        System.debug('SalesorgCompetitorMap intest class '+SalesorgCompetitorMap);
        String jsonStr1;
        
        for (Competitior_Sales_Org_Mapping__c objcomp: SalesorgCompetitorMap) {
            GtmProductCompetition.GtmProductCompWrapper objwrap = new GtmProductCompetition.GtmProductCompWrapper();
            
           // if (objcomp.Status__c == 'Inactive') {
           //     objwrap.compstatus = false;
            //}
            //if (objcomp.Status__c == 'Active') {
            //    objwrap.compstatus = true;
            //}
            objwrap.competitorName = objcomp.Competitor__r.Name;
            objwrap.competitorCategory = objcomp.Competitor__c;
            objwrap.competitorSalesOrgMappingId = objcomp.Id;
            objwrap.compSalesOrgName = objcomp.Sales_Org__r.Name;
            System.debug(objcomp.Display_Name__c + 'Display Name ++++++Before');
            objwrap.displayName = objcomp.Display_Name__c;
            System.debug(objwrap.displayName + 'Display Name ++++++After');
            objwrap.compcreatedByName = objcomp.CreatedBy.Name;
            objwrap.complastModifiedDateName = objcomp.LastModifiedDate;
            gtmList.add(objwrap);
            jsonStr1 = JSOn.serialize(gtmList); 
            System.debug('jsonStr1 intest class '+jsonStr1);
            GtmProductCompetition.updateCompetitorMapStatus(jsonStr1);
            
        }
        System.debug('out side jsonStr1 intest class '+jsonStr1);
        
        List<GtmProductCompetition.GtmProductCompWrapper> cropList = new List<GtmProductCompetition.GtmProductCompWrapper>();
        
        List < Crop__c > SalesorgCropMapping = [Select Id, Name, GTM_Status__c, LastModifiedBy.name,LastModifiedDate, SalesOrg__r.Name From Crop__c ];
        
        for (Crop__c obj: SalesorgCropMapping) {
            GtmProductCompetition.GtmProductCompWrapper objwrapcrop = new GtmProductCompetition.GtmProductCompWrapper();
            
           //if (obj.GTM_Status__c == 'Inactive') {
             //   objwrapcrop.gtmstatuscrop = false;
            //}
            //if (obj.GTM_Status__c == 'Active') {
             //   objwrapcrop.gtmstatuscrop = true;
           // }
            
            objwrapcrop.cropName = obj.Name;
            objwrapcrop.cropId = obj.Id;
            objwrapcrop.salesOrgNameCrop = obj.SalesOrg__r.Name;
            
            objwrapcrop.lastModByNameCrop= obj.LastModifiedBy.name;
            objwrapcrop.lastModifiedDateNameCrop= obj.LastModifiedDate;
            cropList.add(objwrapcrop);
            String jsonStr = JSOn.serialize(cropList);
            GtmProductCompetition.updateCropStatus(jsonStr);
        }
        
        
        
        GtmProductCompetition.getproductList();
        GtmProductCompetition.getWapperCrop();
        GtmProductCompetition.getCompetitorList();
        Boolean checkStatusCrop = GtmProductCompetition.checkStatusCrop(pc.Id);
        Boolean checkStatus = GtmProductCompetition.checkStatus(pc.Id);
        System.debug('total outsode  intest class '+jsonStr1);
        //Product_Category_Sales_Org_Mapping__c ps = [Select Id, Name, Status__c, Category_Index__c from Product_Category_Sales_Org_Mapping__c limit 1];
        
        GtmProductCompetition.setIndex(JSOn.serialize(pcsm));
        GtmProductCompetition.setcropIndex(JSOn.serialize(crops));
    }
    
   

    } 
     public static User createuser() {
        User argentinaUsr = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Territory Manager Argentina'].Id,
            LastName = 'Santiago',
            Email = 'sandeep.vishwakarma@skinternational.com',
            Username = 'test@test.com' + System.currentTimeMillis(),
            CompanyName = 'SK international',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            Country = 'Argentina'
        );
        insert argentinaUsr;
        return argentinaUsr;
    }
}