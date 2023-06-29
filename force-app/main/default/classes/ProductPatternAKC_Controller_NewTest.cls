@isTest
public class ProductPatternAKC_Controller_NewTest {
    
    @testSetup
    static void setupData()
    {
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
        
        User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Regional/Zonal Managers'].Id,
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
        insert u;
        
        
        User u1 = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Territory Manager'].Id,
            LastName = 'last',
            Email = 'puser000@amamama.com',
            Username = 'puser000@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
        );  
        insert u1;
        System.runAs(u){
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
                RegionHead__c = u.id,
                // Sales Org
                Zone__c = sobj2.id      // Zone
            );
            insert sobj1;
            
            Territory_Distributor__c territory = new Territory_Distributor__c();
            territory.Name = 'Narayangaon';
            territory.TerritoryManager__c = u1.id;
            territory.TerritoryCode__c = '397';
            territory.Region__c = sobj1.id;
            territory.SalesOrg__c = salorg.id;
            territory.Zone__c = sobj2.id;
            territory.Present_in_KEDE__c = true;
            territory.Neglected__c = false;
            insert territory;
            
        }   
        
        
    }
    
    static testMethod void productPatternAkc(){
        
        Territory_Distributor__c territory = [select id,Name from Territory_Distributor__c where Name='Narayangaon'];
        
        string caseRecordType  =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('Data Pattern Calling form').getRecordTypeId();
        
        
        AKC_Product__c akcPdt = new AKC_Product__c(
            Name = 'Amigo',                // AKC Product Name
            //Product__c = '01t28000003COiH',  // Product
            Doses__c = '150',                // Doses
            Unit__c = 'ml',                  // Unit
            Acre_kg__c = 'Per Acre'         // Acre/kg
        );
        insert akcPdt;
        string uplGeneralCase = Schema.SObjectType.Case.getRecordTypeInfosByName().get('AKC General Case').getRecordTypeId();
        Case caseObj = new Case(RecordTypeId = caseRecordType,Status = 'Open',Data_Pattern_Territory__c = territory.Id);
        insert caseObj;
        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(caseObj);
        ProductPatternAKC_Controller productPatternContObjTemp  = new ProductPatternAKC_Controller();
        ProductPatternAKC_Controller productPatternContObj  = new ProductPatternAKC_Controller(sc);
        productPatternContObj.ClearSearchFilter();
        productPatternContObj.getTerritoryInfo();
        productPatternContObj.listCrops = 'Brinjal';
        productPatternContObj.listSelPattern = 'Insect,Weed,PGR';
        productPatternContObj.territoryName = territory.Name;
        productPatternContObj.searchCasePattern();
        ApexPages.currentPage().getParameters().put('idx','0');
        ApexPages.currentPage().getParameters().put('pdtName','Amigo');
        ApexPages.currentPage().getParameters().put('doseidx','0');
        ApexPages.currentPage().getParameters().put('productName','Amigo');
        ApexPages.currentPage().getParameters().put('dose','150');
        ApexPages.currentPage().getParameters().put('recIndex','0');
        ApexPages.currentPage().getParameters().put('product','Amigo');
        ApexPages.currentPage().getParameters().put('pdtdose','150');
        ApexPages.currentPage().getParameters().put('remCount','0');
        ApexPages.currentPage().getParameters().put('remIndex','0');
        productPatternContObj.getProductDose();
        productPatternContObj.getAkcProductDetails();
        productPatternContObj.addProductList();
        productPatternContObj.removeProduct();
        productPatternContObj.addProductList();
        productPatternContObj.addProductList();
        productPatternContObj.saveCaseInformation();
        string Distributor = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        ProductPatternAKC_Controller.getReordInformation('',caseRecordType,'');
        ProductPatternAKC_Controller.getReordInformation('',uplGeneralCase,'');
        ProductPatternAKC_Controller.getReordInformation('',Distributor,'');
        productPatternContObj.checkRecordType();
        productPatternContObj.removeallPdtentries();
        boolean istrue = ProductPatternAKC_Controller.getFarmerPromoProduct('');
        ProductPatternAKC_Controller.fetchUser();
        Test.stopTest();
    }
    
    static testMethod void methodTest1(){
        
        ProductPatternAKC_Controller.CasePatternDetail objOfClassCasePatternDetail =new ProductPatternAKC_Controller.CasePatternDetail();
        
        Territory_Distributor__c territory = [select id,Name from Territory_Distributor__c where Name='Narayangaon'];
        
        string caseRecordType  =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('Data Pattern Calling form').getRecordTypeId();
        
        
        AKC_Product__c akcPdt = new AKC_Product__c(
            Name = 'Amigo',                // AKC Product Name
            //Product__c = '01t28000003COiH',  // Product
            Doses__c = '150',                // Doses
            Unit__c = 'ml',                  // Unit
            Acre_kg__c = 'Per Acre'         // Acre/kg
        );
        insert akcPdt;
        string uplGeneralCase = Schema.SObjectType.Case.getRecordTypeInfosByName().get('AKC General Case').getRecordTypeId();
        Case caseObj = new Case(
            RecordTypeId =    caseRecordType,
            
            Sent_to_ZM__c = false,                                                // Sent to ZM
            Status = 'Closed',                                                    // Status
            Type = 'Insect',                                                      // Type
            Crop_pick__c = 'Brinjal',                                              // Crop
            Sub_Query__c = 'Insect',                                              // Sub Query
            //DAS__c = '60',                                                        // DAS
            Origin = 'Call-Inbound',                                              // Case Origin
            Croplist_is_Already_Updated__c = false,                               // Croplist is Already Updated
            Override__c = false,                                                  // Override Season
            Subject = 'Brinjal - Insect - Insect',                                // Subject
            Description = 'Buldhana\tSales Officer (Sandeep Raut - 7720091449)',  // Description
            Issue_Enquiry__c = '\n',                                              // Issue Enquiry
            // ClosedDate = Datetime.valueOf('20-1-2016 3:05 PM:00'),                // Date/Time Closed
            Priority = 'Medium',                                                  // Priority
            PriorPromotion__c = false,
            Insect_General_Case__c ='Aphids',
            Data_Pattern_Territory__c = territory.Id          
        );
        insert caseObj;
        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(caseObj);
        ProductPatternAKC_Controller productPatternContObjTemp  = new ProductPatternAKC_Controller();
        ProductPatternAKC_Controller productPatternContObj  = new ProductPatternAKC_Controller(sc);
        productPatternContObj.ClearSearchFilter();
        productPatternContObj.getTerritoryInfo();
        productPatternContObj.listCrops = 'Brinjal';
        productPatternContObj.listSelPattern = 'Insect,Weed,PGR';
        productPatternContObj.territoryName = territory.Name;
        productPatternContObj.searchCasePattern();
        ApexPages.currentPage().getParameters().put('idx','0');
        ApexPages.currentPage().getParameters().put('pdtName','Amigo');
        ApexPages.currentPage().getParameters().put('doseidx','0');
        ApexPages.currentPage().getParameters().put('productName','Amigo');
        ApexPages.currentPage().getParameters().put('dose','150');
        ApexPages.currentPage().getParameters().put('recIndex','0');
        ApexPages.currentPage().getParameters().put('product','Amigo');
        ApexPages.currentPage().getParameters().put('pdtdose','150');
        ApexPages.currentPage().getParameters().put('remCount','0');
        ApexPages.currentPage().getParameters().put('remIndex','0');
        productPatternContObj.getProductDose();
        productPatternContObj.getAkcProductDetails();
        productPatternContObj.addProductList();
        productPatternContObj.removeProduct();
        productPatternContObj.addProductList();
        productPatternContObj.addProductList();
        productPatternContObj.saveCaseInformation();
        string Distributor = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        ProductPatternAKC_Controller.getReordInformation('',caseRecordType,'');
        ProductPatternAKC_Controller.getReordInformation('',uplGeneralCase,'');
        ProductPatternAKC_Controller.getReordInformation('',Distributor,'');
        productPatternContObj.checkRecordType();
        boolean istrue = ProductPatternAKC_Controller.getFarmerPromoProduct('');
        ProductPatternAKC_Controller.casetableDetails casetblobj = new ProductPatternAKC_Controller.casetableDetails();
        ProductPatternAKC_Controller.ProductPattern pdtpttnobj = new ProductPatternAKC_Controller.ProductPattern();
        ProductPatternAKC_Controller.caseCropPattern casecrpobj = new ProductPatternAKC_Controller.caseCropPattern();
        //ProductPatternAKC_Controller.saveMetaRecord(akcPdt.id);
        ProductPatternAKC_Controller pkc=new ProductPatternAKC_Controller();
        pkc.removeallPdtentries();
        ProductPatternAKC_Controller.fetchUser();
        Test.stopTest();
    }
    
    static testMethod void methodTest2(){
        
        Territory_Distributor__c territory = [select id,Name from Territory_Distributor__c where Name='Narayangaon'];
        
        string caseRecordType  =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('Data Pattern Calling form').getRecordTypeId();
        
        
        AKC_Product__c akcPdt = new AKC_Product__c(
            Name = 'Amigo',                // AKC Product Name
            //Product__c = '01t28000003COiH',  // Product
            Doses__c = '150',                // Doses
            Unit__c = 'ml',                  // Unit
            Acre_kg__c = 'Per Acre'         // Acre/kg
        );
        insert akcPdt;
        string uplGeneralCase = Schema.SObjectType.Case.getRecordTypeInfosByName().get('AKC General Case').getRecordTypeId();
        Case caseObj = new Case(
            RecordTypeId =    caseRecordType,
            Sent_to_ZM__c = false,                                                // Sent to ZM
            Status = 'Closed',                                                    // Status
            Type = 'Weed',                                                      // Type
            Crop_pick__c = 'Brinjal',                                              // Crop
            Sub_Query__c = 'Insect',                                              // Sub Query
            //DAS__c = '60',                                                        // DAS
            Origin = 'Call-Inbound',                                              // Case Origin
            Croplist_is_Already_Updated__c = false,                               // Croplist is Already Updated
            Override__c = false,                                                  // Override Season
            Subject = 'Brinjal - Insect - Insect',                                // Subject
            Description = 'Buldhana\tSales Officer (Sandeep Raut - 7720091449)',  // Description
            Issue_Enquiry__c = '\n',                                              // Issue Enquiry
            // ClosedDate = Datetime.valueOf('20-1-2016 3:05 PM:00'),                // Date/Time Closed
            Priority = 'Medium',                                                  // Priority
            PriorPromotion__c = false,
            Weed__c ='Post Imergent',
            Data_Pattern_Territory__c = territory.Id          
        );
        insert caseObj;
        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(caseObj);
        ProductPatternAKC_Controller productPatternContObjTemp  = new ProductPatternAKC_Controller();
        ProductPatternAKC_Controller productPatternContObj  = new ProductPatternAKC_Controller(sc);
        productPatternContObj.ClearSearchFilter();
        productPatternContObj.getTerritoryInfo();
        productPatternContObj.listCrops = 'Brinjal';
        productPatternContObj.listSelPattern = 'Insect,Weed,PGR';
        productPatternContObj.territoryName = territory.Name;
        productPatternContObj.searchCasePattern();
        ApexPages.currentPage().getParameters().put('idx','0');
        ApexPages.currentPage().getParameters().put('pdtName','Amigo');
        ApexPages.currentPage().getParameters().put('doseidx','0');
        ApexPages.currentPage().getParameters().put('productName','Amigo');
        ApexPages.currentPage().getParameters().put('dose','150');
        ApexPages.currentPage().getParameters().put('recIndex','0');
        ApexPages.currentPage().getParameters().put('product','Amigo');
        ApexPages.currentPage().getParameters().put('pdtdose','150');
        ApexPages.currentPage().getParameters().put('remCount','0');
        ApexPages.currentPage().getParameters().put('remIndex','0');
        productPatternContObj.getProductDose();
        productPatternContObj.getAkcProductDetails();
        productPatternContObj.addProductList();
        productPatternContObj.removeProduct();
        productPatternContObj.addProductList();
        productPatternContObj.addProductList();
        productPatternContObj.saveCaseInformation();
        string Distributor = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        ProductPatternAKC_Controller.getReordInformation('',caseRecordType,'');
        ProductPatternAKC_Controller.getReordInformation('',uplGeneralCase,'');
        ProductPatternAKC_Controller.getReordInformation('',Distributor,'');
        productPatternContObj.checkRecordType();
        boolean istrue = ProductPatternAKC_Controller.getFarmerPromoProduct('');
        ProductPatternAKC_Controller.casetableDetails casetblobj = new ProductPatternAKC_Controller.casetableDetails();
        ProductPatternAKC_Controller.ProductPattern pdtpttnobj = new ProductPatternAKC_Controller.ProductPattern();
        ProductPatternAKC_Controller.caseCropPattern casecrpobj = new ProductPatternAKC_Controller.caseCropPattern();
        //ProductPatternAKC_Controller.saveMetaRecord(akcPdt.id);
        ProductPatternAKC_Controller pkc=new ProductPatternAKC_Controller();
        pkc.removeallPdtentries();
        ProductPatternAKC_Controller.fetchUser();
        Test.stopTest();
    }
    
    static testMethod void methodTest3(){
        
        Territory_Distributor__c territory = [select id,Name from Territory_Distributor__c where Name='Narayangaon'];
        
        string caseRecordType  =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('Data Pattern Calling form').getRecordTypeId();
        
        
        AKC_Product__c akcPdt = new AKC_Product__c(
            Name = 'Amigo',                // AKC Product Name
            //Product__c = '01t28000003COiH',  // Product
            Doses__c = '150',                // Doses
            Unit__c = 'ml',                  // Unit
            Acre_kg__c = 'Per Acre'         // Acre/kg
        );
        insert akcPdt;
        string uplGeneralCase = Schema.SObjectType.Case.getRecordTypeInfosByName().get('AKC General Case').getRecordTypeId();
        Case caseObj = new Case(
            RecordTypeId =    caseRecordType,  
            Sent_to_ZM__c = false,                                                // Sent to ZM
            Status = 'Closed',                                                    // Status
            Type = 'PGR',                                                      // Type
            Crop_pick__c = 'Brinjal',                                              // Crop
            Sub_Query__c = 'Insect',                                              // Sub Query
            //DAS__c = '60',                                                        // DAS                                                 // Override Season
            Subject = 'Brinjal - Insect - Insect',                                // Subject
            Description = 'Buldhana\tSales Officer (Sandeep Raut - 7720091449)',  // Description
            Issue_Enquiry__c = '\n',                                              // Issue Enquiry
            // ClosedDate = Datetime.valueOf('20-1-2016 3:05 PM:00'),                // Date/Time Closed
            Priority = 'Medium',                                                  // Priority
            PriorPromotion__c = false,
            PGR__c ='Growth Promoters',
            Data_Pattern_Territory__c = territory.Id          
        );
        insert caseObj;   
        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(caseObj);
        ProductPatternAKC_Controller productPatternContObjTemp  = new ProductPatternAKC_Controller();
        ProductPatternAKC_Controller productPatternContObj  = new ProductPatternAKC_Controller(sc);
        productPatternContObj.ClearSearchFilter();
        productPatternContObj.getTerritoryInfo();
        productPatternContObj.listCrops = 'Brinjal';
        productPatternContObj.listSelPattern = 'Insect,Weed,PGR';
        productPatternContObj.territoryName = territory.Name;
        productPatternContObj.searchCasePattern();
        ApexPages.currentPage().getParameters().put('idx','0');
        ApexPages.currentPage().getParameters().put('pdtName','Amigo');
        ApexPages.currentPage().getParameters().put('doseidx','0');
        ApexPages.currentPage().getParameters().put('productName','Amigo');
        ApexPages.currentPage().getParameters().put('dose','150');
        ApexPages.currentPage().getParameters().put('recIndex','0');
        ApexPages.currentPage().getParameters().put('product','Amigo');
        ApexPages.currentPage().getParameters().put('pdtdose','150');
        ApexPages.currentPage().getParameters().put('remCount','0');
        ApexPages.currentPage().getParameters().put('remIndex','5');
        productPatternContObj.getProductDose();
        productPatternContObj.getAkcProductDetails();
        productPatternContObj.addProductList();
        productPatternContObj.removeProduct();
        productPatternContObj.addProductList();
        productPatternContObj.addProductList();
        productPatternContObj.saveCaseInformation();
        string Distributor = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        ProductPatternAKC_Controller.getReordInformation('',caseRecordType,'');
        ProductPatternAKC_Controller.getReordInformation('',uplGeneralCase,'');
        ProductPatternAKC_Controller.getReordInformation('',Distributor,'');
        productPatternContObj.checkRecordType();
        boolean istrue = ProductPatternAKC_Controller.getFarmerPromoProduct('');
        ProductPatternAKC_Controller.casetableDetails casetblobj = new ProductPatternAKC_Controller.casetableDetails();
        ProductPatternAKC_Controller.ProductPattern pdtpttnobj = new ProductPatternAKC_Controller.ProductPattern();
        ProductPatternAKC_Controller.caseCropPattern casecrpobj = new ProductPatternAKC_Controller.caseCropPattern();
        //ProductPatternAKC_Controller.saveMetaRecord(akcPdt.id);
        ProductPatternAKC_Controller pkc=new ProductPatternAKC_Controller();
        pkc.removeallPdtentries();
        ProductPatternAKC_Controller.fetchUser();
        Test.stopTest();
    }
    
    static testMethod void methodTest4(){
        
        Territory_Distributor__c territory = [select id,Name from Territory_Distributor__c where Name='Narayangaon'];
        
        string caseRecordType  =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('Data Pattern Calling form').getRecordTypeId();
        
        
        AKC_Product__c akcPdt = new AKC_Product__c(
            Name = 'Amigo',                // AKC Product Name
            //Product__c = '01t28000003COiH',  // Product
            Doses__c = '150',                // Doses
            Unit__c = 'ml',                  // Unit
            Acre_kg__c = 'Per Acre'         // Acre/kg
        );
        insert akcPdt;
        string uplGeneralCase = Schema.SObjectType.Case.getRecordTypeInfosByName().get('AKC General Case').getRecordTypeId();
        Case caseObj = new Case(
            RecordTypeId =    caseRecordType, 
            Sent_to_ZM__c = false,                                                // Sent to ZM
            Status = 'Closed',                                                    // Status
            Type = 'Disease',                                                      // Type
            Crop_pick__c = 'Brinjal',                                              // Crop
            Sub_Query__c = 'Disease',                                              // Sub Query
            //DAS__c = '60',                                                        // DAS                                                 // Override Season
            Subject = 'Brinjal - Insect - Insect',                                // Subject
            Description = 'Buldhana\tSales Officer (Sandeep Raut - 7720091449)',  // Description
            Issue_Enquiry__c = '\n',                                              // Issue Enquiry
            // ClosedDate = Datetime.valueOf('20-1-2016 3:05 PM:00'),                // Date/Time Closed
            Priority = 'Medium',                                                  // Priority
            PriorPromotion__c = false,
            PGR__c ='Growth Promoters',
            Disease_General_Case__c ='Mosaic',
            Data_Pattern_Territory__c = territory.Id          
        );
        insert caseObj;  
        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(caseObj);
        ProductPatternAKC_Controller productPatternContObjTemp  = new ProductPatternAKC_Controller();
        ProductPatternAKC_Controller productPatternContObj  = new ProductPatternAKC_Controller(sc);
        productPatternContObj.ClearSearchFilter();
        productPatternContObj.getTerritoryInfo();
        productPatternContObj.listCrops = 'Brinjal';
        productPatternContObj.listSelPattern = 'Insect,Weed,PGR';
        productPatternContObj.territoryName = territory.Name;
        productPatternContObj.searchCasePattern();
        ApexPages.currentPage().getParameters().put('idx','0');
        ApexPages.currentPage().getParameters().put('pdtName','Amigo');
        ApexPages.currentPage().getParameters().put('doseidx','0');
        ApexPages.currentPage().getParameters().put('productName','Amigo');
        ApexPages.currentPage().getParameters().put('dose','150');
        ApexPages.currentPage().getParameters().put('recIndex','0');
        ApexPages.currentPage().getParameters().put('product','Amigo');
        ApexPages.currentPage().getParameters().put('pdtdose','150');
        ApexPages.currentPage().getParameters().put('remCount','5');
        ApexPages.currentPage().getParameters().put('remIndex','0');
        productPatternContObj.getProductDose();
        productPatternContObj.getAkcProductDetails();
        productPatternContObj.addProductList();
        productPatternContObj.removeProduct();
        productPatternContObj.addProductList();
        productPatternContObj.addProductList();
        productPatternContObj.saveCaseInformation();
        string Distributor = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        ProductPatternAKC_Controller.getReordInformation('',caseRecordType,'');
        ProductPatternAKC_Controller.getReordInformation('',uplGeneralCase,'');
        ProductPatternAKC_Controller.getReordInformation('',Distributor,'');
        productPatternContObj.checkRecordType();
        boolean istrue = ProductPatternAKC_Controller.getFarmerPromoProduct('');
        ProductPatternAKC_Controller.casetableDetails casetblobj = new ProductPatternAKC_Controller.casetableDetails();
        ProductPatternAKC_Controller.ProductPattern pdtpttnobj = new ProductPatternAKC_Controller.ProductPattern();
        ProductPatternAKC_Controller.caseCropPattern casecrpobj = new ProductPatternAKC_Controller.caseCropPattern();
        //ProductPatternAKC_Controller.saveMetaRecord(akcPdt.id);
        ProductPatternAKC_Controller pkc=new ProductPatternAKC_Controller();
        pkc.removeallPdtentries();
        ProductPatternAKC_Controller.fetchUser();
        Test.stopTest();
    }
    
    static testMethod void methodTest5(){
        
       User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Business Center Coordinator Colombia'].Id,
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
        insert u;
        Id nurtureRecordType  =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('nurture.farm care').getRecordTypeId();
        
        Test.startTest();
        
        ProductPatternAKC_Controller.getReordInformation('',nurtureRecordType,'');
        System.runAs(u)
        {
            ProductPatternAKC_Controller.getReordInformation('',null,'');
        }
        Case sample=new Case();
        sample.recordtypeid=nurtureRecordType;
        insert sample;
        ApexPages.StandardController sc = new ApexPages.StandardController(sample);
        ProductPatternAKC_Controller productPatternContObj  = new ProductPatternAKC_Controller(sc);
		productPatternContObj.checkRecordType();       
        Test.stopTest();
    }
    
}