@isTest public class CompetitorPriceController_Test{
    
    public static TestMethod void  competitorPriceInsert(){
        
       /* UPL_Settings__c uplsetting = new UPL_Settings__c();
        uplsetting.Name = 'UPLSetting';
        uplsetting.India_SAS_Sales_Org__c = '1410';
        INSERT uplsetting;

        Sales_Org__c salorg = new Sales_Org__c();
        salorg.name = 'india';
        salorg.Sales_Org_Code__c = uplsetting.India_SAS_Sales_Org__c;
        insert salorg; */
        
        Sales_Org__c salorg = new Sales_Org__c();
        salorg.name = 'india';
        salorg.Sales_Org_Code__c = '1000';
        insert salorg;
        
        Sales_Org__c salorg1 = new Sales_Org__c();
        salorg1.name = 'SWAL';
        salorg1.Sales_Org_Code__c = '1210';
        insert salorg1; 
        
        User u = new User(
            ProfileId = [select id from profile where name ='Territory Manager'].Id,
            LastName = 'last1',
            Email = 'puser000@amamama.com',
            Username = 'puser000@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST1',
            MobilePhone ='1234567890',
            Title = 'title1',
            Alias = 'alias1',
            country = 'SWAL',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            isActive = true
        );  
        insert u;  
        
        User u2 = new User(
            ProfileId = [select id from profile where name ='Territory Manager'].Id,
            LastName = 'last',
            Email = 'puser000@amamama.com',
            Username = 'puser000@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            MobilePhone ='1234567890',
            Alias = 'alias',
            country = 'India',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            isActive = true
        );  
        insert u2;
        
        String comPriceID='';
        
       
        
        Brand__c Brand = new Brand__c(
            Name ='ABC', 
            Approved__c = true,
            Brand_Code__c = '1234'
        );
        insert  Brand;
        
        company__c Company = new Company__c(
            Name ='ABC', 
            Approved__c = true,
            Company_Code__c = '1234'
        );
        insert  Company;
        
        Formulation__c Formulation = new Formulation__c(
            Approved__c = true, 
            Formulation_Code__c = '123',
            Company__c = Company.id,
            Brand__c = Brand.id  
        );
        insert  Formulation ;
        
        Crop__c crop = new Crop__c(
            Name ='ABCD',
            SalesOrg__c = salorg.Id    
            //Crop_Name__c ='Abc'
        );
        insert crop;
        
        Pack_Size__c packSize = new Pack_Size__c(
            Name = '30 KG', 
            Approved__c =true,
            Pack_Size_Code__c = '1234'
        ); 
        insert packSize ;
        
        Brand_Category__c category = new Brand_Category__c(
            Name='category');
        insert category;
        
        Product_Detail__c productDetail = new Product_Detail__c( 
            Formulation__c = Formulation.id, 
            Company__c =Company.id,
            Brand__c = Brand.id);
        
        insert productDetail;
        
        Pest__c pest = new Pest__c(name = '1234');
        insert pest ;
        
        Territory_Distributor__c territory = new Territory_Distributor__c();
        territory.Name = 'Narayangaon';
        territory.TerritoryManager__c = u2.id;
        territory.TerritoryCode__c = '397';
        territory.SalesOrg__c = salorg.id; 
        territory.Present_in_KEDE__c = true;
        territory.Neglected__c = false;
        insert territory;
        
        Territory_Distributor__c territory1 = new Territory_Distributor__c();
        territory.Name = 'Narayangaon1';
        territory.TerritoryManager__c = u.id;
        territory.TerritoryCode__c = '394';
        territory.SalesOrg__c = salorg1.id;
        territory.Present_in_KEDE__c = true;
        territory.Neglected__c = false;
        insert territory1;
        
        Competitor_Price__c cp= new Competitor_Price__c (
            Reporting_Type__c ='New Company, New Brand',
            Brand__c = Brand.id,
            Company__c = Company.id ,
            Formulation__c = Formulation .id
        );
        insert cp;
        Competitor_Price__c cp1 = new Competitor_Price__c (
            Reporting_Type__c ='New Company, New Brand',
            Brand__c = Brand.id,
            Company__c = Company.id ,
            Formulation__c = Formulation .id
        );
        insert cp1;
        
        /* String sObjectName = 'Competitor_Price__c';
sObject newComPriceObj= Schema.getGlobalDescribe().get(sObjectName).newSObject() ;
//SObject newComPriceObj= copmPrice.newSObject();
newComPriceObj.Reporting_Type__c='New Company, New Brand';
newComPriceObj.Brand__c=Brand.id;
newComPriceObj.Company__c=Company.id;
newComPriceObj.Formulation__c=Formulation .id;


CompetitorPriceController.UpdateClaim labelObj= new CompetitorPriceController.UpdateClaim();        
labelObj.crp=crop.id;
labelObj.pst=pest.id;
labelObj.dos=10;
labelObj.acr_cst=1234;*/
        
        Update_Label_Claim__c updateLablClaim = new Update_Label_Claim__c(
            Competitor_Price__c = cp.id,
            Crop__c = crop.id,
            Dose__c = 234,
            Per_Acre_Cost__c = 324,
            Pest__c = pest.id);
        
        Price_Scheme_Detail__c priceSchDetail = new Price_Scheme_Detail__c(
            Comment__c = 'comment',
            Competitor_Price__c = cp.id,
            Distributor_Price__c = 344,
            Farmer_Price__c = 235,
            MRP__c =980,
            Retailer_Price__c = 450,
            Scheme__c = 'scheme',
            Status__c = 'Completed'
            
        );
        
        Price_Scheme_Detail__c priceSchDetail1 = new Price_Scheme_Detail__c(
            Comment__c = 'comment',
            Competitor_Price__c = cp.id,
            Distributor_Price__c = 344,
            Farmer_Price__c = 235,
            MRP__c =980,
            Retailer_Price__c = 450,
            Scheme__c = 'scheme',
            Status__c = 'Completed'
            
        );
        insert priceSchDetail1; 
        
        Price_Scheme_Detail__c priceSchDetail2 = new Price_Scheme_Detail__c(
            Comment__c = 'comment',
            Competitor_Price__c = cp.id,
            Distributor_Price__c = 344,
            Farmer_Price__c = 235,
            MRP__c =980,
            Retailer_Price__c = 450,
            Scheme__c = 'scheme',
            Status__c = 'Completed'
            
        );
        insert priceSchDetail2;
        
        Attachment attach = new Attachment(
            name = 'file',
            ParentId = priceSchDetail1.id,
            Body = Blob.valueOf('this is a attachment') );
        insert attach;
        
        string updateLabelClaimStr = '['+JSON.serialize(updateLablClaim)+']';
        //system.debug(custForecastInfo);  
        string priceSchDetailStr = '['+JSON.serialize(priceSchDetail)+']';
        //string DemoProtocol = '['+JSON.serialize(campDemoProtocol)+']';
        //string expenseAct = '['+JSON.serialize(ExpAct)+']';
        
        
        system.runAs(u2){
            
            CompetitorPriceController.getBrandCategorys();
            CompetitorPriceController.getBrandList();
            CompetitorPriceController.getCmpnyList();
            CompetitorPriceController.getPackList('30 KG');
            CompetitorPriceController.formulationDetails(Brand.id ,Company.id);
            CompetitorPriceController.getBrandListOnCmpny(Company.id);
            CompetitorPriceController.getCmpnyListOnBrnd(Brand.id);
            CompetitorPriceController.searchHelperOnBrandKeyPres('searchKeyWordBrand');
            CompetitorPriceController.searchHelperOnCompanyKeyPres('searchKeyWordCompany');
            CompetitorPriceController.fetchFormulationList('searchKeyWordFormulation');
            CompetitorPriceController.searchHelperOnFormulationKeyPres('searchKeyWordFormulation');
            CompetitorPriceController.gettingLoginUserIds();
            
            
            CompetitorPriceController.getformulationList();
            CompetitorPriceController.fetchBrandList(Brand.id);
            CompetitorPriceController.fetchCompanyList('');
            CompetitorPriceController.cropList('ABCD');
            CompetitorPriceController.cropList('');
            CompetitorPriceController.pestList('1234');
            CompetitorPriceController.pestList('');
            CompetitorPriceController.newBrandEntry('PQR',category.id);
            CompetitorPriceController.newFrmltnEntry('aqw',Brand.id ,Company.id);
            CompetitorPriceController.newPacktnEntry('qwe');
            CompetitorPriceController.newCmpnyEntry('dffg','www.sk.com');
            
            CompetitorPriceController.newCompetitorEntry(cp1,updateLabelClaimStr, cp.id);
            CompetitorPriceController.newCompetitorEntry(cp1,updateLabelClaimStr, null);
            CompetitorPriceController.saveCPEntry(cp1, priceSchDetail, cp.id);
            CompetitorPriceController.saveCPEntry(cp1, priceSchDetail, null);
            CompetitorPriceController.saveChunk(priceSchDetail1.id,'image-scheme', 'gtrtyrhyrtertgetgretegr', 'rgrtrftetfrtserte', '',4,'scheme');
            CompetitorPriceController.saveChunk(priceSchDetail1.id,'image-packshot', 'gtrtyrhyrtertgetgretegr', 'rgrtrftetfrtserte', attach.id,3,'packshot');
            CompetitorPriceController.saveChunk(priceSchDetail1.id,'image-scheme', 'gtrtyrhyrtertgetgretegr', 'rgrtrftetfrtserte', '',5,'scheme');
            CompetitorPriceController.saveChunk(priceSchDetail1.id,'image-packshot', 'gtrtyrhyrtertgetgretegr', 'rgrtrftetfrtserte', attach.id,4,'packshot');
            CompetitorPriceController.saveChunk(priceSchDetail1.id,'image-scheme', 'gtrtyrhyrtertgetgretegr', 'rgrtrftetfrtserte', '',4,'label');
            CompetitorPriceController.saveChunk(priceSchDetail1.id,'image-packshot', 'gtrtyrhyrtertgetgretegr', 'rgrtrftetfrtserte', attach.id,4,'label');
            CompetitorPriceController.deletePriceEntry(priceSchDetail1.id);
            CompetitorPriceController.cancelPriceEntry(cp.id);
            CompetitorPriceController.updateClaimList(Brand.id);
            CompetitorPriceController.UpdateClaim updateClaim = new CompetitorPriceController.UpdateClaim();
            CompetitorPriceController.PriceSchemeDetails PriceSchemeDetail = new CompetitorPriceController.PriceSchemeDetails();
            CompetitorPriceController.CompetitorPrice CompetitorPriceObj = new CompetitorPriceController.CompetitorPrice();
            
            
        }
        
        system.runAs(u){
            
            CompetitorPriceController.getBrandCategorys();
            CompetitorPriceController.getBrandList();
            CompetitorPriceController.getCmpnyList();
            CompetitorPriceController.getPackList('30 KG');
            //CompetitorPriceController.formulationDetails(Brand.id ,Company.id);
            //CompetitorPriceController.getBrandListOnCmpny(Company.id);
            //CompetitorPriceController.getCmpnyListOnBrnd(Brand.id);
            //CompetitorPriceController.cropList();
            /*CompetitorPriceController.pestList();
CompetitorPriceController.newBrandEntry('PQR','123',category.id);
CompetitorPriceController.newFrmltnEntry('aqw','123',Brand.id ,Company.id);
CompetitorPriceController.newPacktnEntry('qwe','avc');
CompetitorPriceController.newCmpnyEntry('dffg','234','www.sk.com');

CompetitorPriceController.newCompetitorEntry(cp1,updateLabelClaimStr, cp.id);
CompetitorPriceController.saveCPEntry(cp1, priceSchDetail, cp.id);
//CompetitorPriceController.saveChunk(priceSchDetail2.id,'image-scheme', 'gtrtyrhyrtertgetgretegr', 'rgrtrftetfrtserte', '',2);
CompetitorPriceController.saveChunk(priceSchDetail2.id,'image-packshot', 'gtrtyrhyrtertgetgretegr', 'rgrtrftetfrtserte', attach.id,2);
CompetitorPriceController.deletePriceEntry(priceSchDetail2.id);
CompetitorPriceController.cancelPriceEntry(cp.id);
CompetitorPriceController.updateClaimList(Brand.id);
CompetitorPriceController.UpdateClaim updateClaim = new CompetitorPriceController.UpdateClaim();
CompetitorPriceController.PriceSchemeDetails PriceSchemeDetail = new CompetitorPriceController.PriceSchemeDetails();
CompetitorPriceController.CompetitorPrice CompetitorPriceObj = new CompetitorPriceController.CompetitorPrice();*/
            
            
        }
        
    }
    
    public static TestMethod void  competitorPriceInsert1(){
        
        Sales_Org__c salorg = new Sales_Org__c();
        salorg.name = 'SWAL';
        salorg.Sales_Org_Code__c = '1210';
        insert salorg; 
        
        
        User u2 = new User(
            ProfileId = [select id from profile where name ='Territory Manager'].Id,
            LastName = 'last',
            Email = 'puser000@amamama.com',
            Username = 'puser000@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            MobilePhone ='1234567890',
            Alias = 'alias',
            country = 'SWAL',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            isActive = true
        );  
        insert u2;
        
        String comPriceID='';
        
        
        
        
        Brand__c Brand = new Brand__c(
            Name ='ABC', 
            Approved__c = true,
            Brand_Code__c = '1234'
        );
        insert  Brand;
        
        company__c Company = new Company__c(
            Name ='ABC', 
            Approved__c = true,
            Company_Code__c = '1234'
        );
        insert  Company;
        
        Formulation__c Formulation = new Formulation__c(
            Approved__c = true, 
            Formulation_Code__c = '123',
            Company__c = Company.id,
            Brand__c = Brand.id  
        );
        insert  Formulation ;
        
        Crop__c crop = new Crop__c(
            Name ='ABCD',
            SalesOrg__c = salorg.Id
            //Crop_Name__c ='Abc'
        );
        insert crop;
        
        Pack_Size__c packSize = new Pack_Size__c(
            Name = '30 KG', 
            Approved__c =true,
            Pack_Size_Code__c = '1234'
        ); 
        insert packSize ;
        
        Brand_Category__c category = new Brand_Category__c(
            Name='category');
        insert category;
        
        Product_Detail__c productDetail = new Product_Detail__c( Formulation__c = Formulation.id, 
                                                                Company__c =Company.id,
                                                                Brand__c = Brand.id);
        
        insert productDetail;
        
        Pest__c pest = new Pest__c(name = '1234');
        insert pest ;
        
        Territory_Distributor__c territory = new Territory_Distributor__c();
        territory.Name = 'Narayangaon';
        territory.TerritoryManager__c = u2.id;
        territory.TerritoryCode__c = '397';
        territory.SalesOrg__c = salorg.id; 
        territory.Present_in_KEDE__c = true;
        territory.Neglected__c = false;
        insert territory;
        
        
        
        Competitor_Price__c cp= new Competitor_Price__c (
            Reporting_Type__c ='New Company, New Brand',
            Brand__c = Brand.id,
            Company__c = Company.id ,
            Formulation__c = Formulation .id
        );
        insert cp;
        Competitor_Price__c cp1 = new Competitor_Price__c (
            Reporting_Type__c ='New Company, New Brand',
            Brand__c = Brand.id,
            Company__c = Company.id ,
            Formulation__c = Formulation .id
        );
        insert cp1;
        
        /* String sObjectName = 'Competitor_Price__c';
sObject newComPriceObj= Schema.getGlobalDescribe().get(sObjectName).newSObject() ;
//SObject newComPriceObj= copmPrice.newSObject();
newComPriceObj.Reporting_Type__c='New Company, New Brand';
newComPriceObj.Brand__c=Brand.id;
newComPriceObj.Company__c=Company.id;
newComPriceObj.Formulation__c=Formulation .id;


CompetitorPriceController.UpdateClaim labelObj= new CompetitorPriceController.UpdateClaim();        
labelObj.crp=crop.id;
labelObj.pst=pest.id;
labelObj.dos=10;
labelObj.acr_cst=1234;*/
        
        Update_Label_Claim__c updateLablClaim = new Update_Label_Claim__c(
            Competitor_Price__c = cp.id,
            Crop__c = crop.id,
            Dose__c = 234,
            Per_Acre_Cost__c = 324,
            Pest__c = pest.id);
        
        Price_Scheme_Detail__c priceSchDetail = new Price_Scheme_Detail__c(
            Comment__c = 'comment',
            Competitor_Price__c = cp.id,
            Distributor_Price__c = 344,
            Farmer_Price__c = 235,
            MRP__c =980,
            Retailer_Price__c = 450,
            Scheme__c = 'scheme',
            Status__c = 'Completed'
            
        );
        
        Price_Scheme_Detail__c priceSchDetail1 = new Price_Scheme_Detail__c(
            Comment__c = 'comment',
            Competitor_Price__c = cp.id,
            Distributor_Price__c = 344,
            Farmer_Price__c = 235,
            MRP__c =980,
            Retailer_Price__c = 450,
            Scheme__c = 'scheme',
            Status__c = 'Completed'
            
        );
        insert priceSchDetail1; 
        
        Price_Scheme_Detail__c priceSchDetail2 = new Price_Scheme_Detail__c(
            Comment__c = 'comment',
            Competitor_Price__c = cp.id,
            Distributor_Price__c = 344,
            Farmer_Price__c = 235,
            MRP__c =980,
            Retailer_Price__c = 450,
            Scheme__c = 'scheme',
            Status__c = 'Completed'
            
        );
        insert priceSchDetail2;
        
        Attachment attach = new Attachment(
            name = 'file',
            ParentId = priceSchDetail1.id,
            Body = Blob.valueOf('this is a attachment') );
        insert attach;
        
        string updateLabelClaimStr = '['+JSON.serialize(updateLablClaim)+']';
        //system.debug(custForecastInfo);  
        string priceSchDetailStr = '['+JSON.serialize(priceSchDetail)+']';
        //string DemoProtocol = '['+JSON.serialize(campDemoProtocol)+']';
        //string expenseAct = '['+JSON.serialize(ExpAct)+']';
        
        
        system.runAs(u2){
            
            CompetitorPriceController.getBrandCategorys();
            CompetitorPriceController.getBrandList();
            CompetitorPriceController.getCmpnyList();
            CompetitorPriceController.getPackList('');
            CompetitorPriceController.formulationDetails(Brand.id ,Company.id);
            CompetitorPriceController.getBrandListOnCmpny(Company.id);
            CompetitorPriceController.getCmpnyListOnBrnd(Brand.id);
            CompetitorPriceController.getformulationList();
            CompetitorPriceController.fetchBrandList(Brand.id);
            CompetitorPriceController.fetchCompanyList(Company.id);
            CompetitorPriceController.cropList('ABCD');
            CompetitorPriceController.cropList('');
            CompetitorPriceController.pestList('1234');
            CompetitorPriceController.pestList('');
            CompetitorPriceController.newBrandEntry('PQR',category.id);
            CompetitorPriceController.newFrmltnEntry('aqw',Brand.id ,Company.id);
            CompetitorPriceController.newPacktnEntry('qwe');
            CompetitorPriceController.newCmpnyEntry('dffg','www.sk.com');
            
            CompetitorPriceController.newCompetitorEntry(cp1,updateLabelClaimStr, cp.id);
            CompetitorPriceController.newCompetitorEntry(cp1,updateLabelClaimStr, null);
            
            CompetitorPriceController.saveCPEntry(cp1, priceSchDetail, cp.id);
            CompetitorPriceController.saveCPEntry(cp1, priceSchDetail, null);
            CompetitorPriceController.saveChunk(priceSchDetail1.id,'image-scheme', 'gtrtyrhyrtertgetgretegr', 'rgrtrftetfrtserte', '',2,'scheme');
            CompetitorPriceController.saveChunk(priceSchDetail1.id,'image-packshot', 'gtrtyrhyrtertgetgretegr', 'rgrtrftetfrtserte', attach.id,1,'packshot');
            CompetitorPriceController.saveChunk(priceSchDetail1.id,'image-scheme', 'gtrtyrhyrtertgetgretegr', 'rgrtrftetfrtserte', '',1,'scheme');
            CompetitorPriceController.saveChunk(priceSchDetail1.id,'image-packshot', 'gtrtyrhyrtertgetgretegr', 'rgrtrftetfrtserte', attach.id,2,'packshot');
            CompetitorPriceController.saveChunk(priceSchDetail1.id,'image-scheme', 'gtrtyrhyrtertgetgretegr', 'rgrtrftetfrtserte', '',2,'label');
            CompetitorPriceController.saveChunk(priceSchDetail1.id,'image-packshot', 'gtrtyrhyrtertgetgretegr', 'rgrtrftetfrtserte', attach.id,1,'label');
            CompetitorPriceController.deletePriceEntry(priceSchDetail1.id);
            CompetitorPriceController.cancelPriceEntry(cp.id);
            CompetitorPriceController.updateClaimList(Brand.id);
            CompetitorPriceController.UpdateClaim updateClaim = new CompetitorPriceController.UpdateClaim();
            CompetitorPriceController.PriceSchemeDetails PriceSchemeDetail = new CompetitorPriceController.PriceSchemeDetails();
            CompetitorPriceController.CompetitorPrice CompetitorPriceObj = new CompetitorPriceController.CompetitorPrice();
            
            
        }
        
        
    }
    
}