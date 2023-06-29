@isTest
public class ProductPatternAKC_Controller_Test {
    
    static testMethod void productPatternAkc(){
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
        System.runAs(u){
            
            
            State__c state = new State__c(Name = 'Tamil Nadu');
            insert state;
            
            District__c dist = new District__c(
                Name = 'Krishnagiri',                   // District Name
                District_Code__c = '631',                 // District Code
                State__c = state.Id,             
                Active__c = false,                        // Active
                District_Name_Census__c = 'Krishnagiri',  // District Name Census
                District_Code_Census__c = '631');
            insert dist;
            
            Tehsil__c tehsil = new Tehsil__c(
                Name = '644000', 
                District__c = dist.Id,
                Tehsil_Code__c = '5890');
            insert tehsil;
            
            Village__c village = new Village__c(
                Name = 'Nimbhora  Bk.',                                                  
                Territory__c = 'Narayangaon', 
                Tehsil__c = tehsil.Id,
                Region__c = 'Aurangabad',                                                      
                Zone__c = 'Pune Zone',
                Fo_Map__c = true);
            insert village;
            contact con = new contact(LastName ='kenia',Village__c = village.id);
            insert con;
            system.debug('con territory'+con.Territory__c);
            string caseRecordType  =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('Data Pattern Calling form').getRecordTypeId();
            test.startTest();
            system.debug('test started');
            
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
            //Test.startTest();
            ApexPages.StandardController sc = new ApexPages.StandardController(caseObj);
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
            Test.stopTest();
        }}
    /*  
* Name: MethodOnWeedBrinjal    
* return:void
* Description:  APPS-2074-This method responsible to cover the code when Type is Weed and crop pick is Brinjal
*/     
    @isTest  
    public static void MethodOnWeedBrinjal()
    {
        
        
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
        Sales_Org__c salorg = new Sales_Org__c();
        salorg.name = 'India';
        salorg.Sales_Org_Code__c = '1410';
        insert salorg;
        
        Zone__c zonesobj = new Zone__c(
            Name = 'Pune',                  // Zone Name
            SalesOrg__c =salorg.id,  // Sales Org
            ZoneCode__c = 'SWZ08',
            ZonalHead__c= u2.id            // Zone Code
        );
        insert zonesobj;
        
        Region__c Regionsobj = new Region__c(
            Name = 'PUNE',                  // Region Name
            RegionCode__c = 'SW017',          // Region Code
            SalesOrg__c = salorg.id,
            RegionHead__c = u.id,
            // Sales Org
            Zone__c = zonesobj.id      // Zone
        );
        insert Regionsobj;
        
        
        
        Territory_Distributor__c territory1 = new Territory_Distributor__c();
        territory1.Name = 'Narayangaon1';
        territory1.TerritoryManager__c = u1.id;
        territory1.TerritoryCode__c = '3973';
        territory1.Region__c = Regionsobj.id;
        territory1.SalesOrg__c = salorg.id;
        territory1.Zone__c = zonesobj.id;
        territory1.Present_in_KEDE__c = true;
        territory1.Neglected__c = false;
        insert territory1;
        string caseRecordType1  =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('Data Pattern Calling form').getRecordTypeId();
        State__c state = new State__c(Name = 'Tamil Nadu');
        insert state;
        
        District__c dist = new District__c(
            Name = 'Krishnagiri',                   // District Name
            District_Code__c = '631',                 // District Code
            State__c = state.Id,             
            Active__c = false,                        // Active
            District_Name_Census__c = 'Krishnagiri',  // District Name Census
            District_Code_Census__c = '631');
        insert dist;
        
        Tehsil__c tehsil = new Tehsil__c(
            Name = '644000', 
            District__c = dist.Id,
            Tehsil_Code__c = '5890');
        insert tehsil;
        
        Village__c village = new Village__c(
            Name = 'Nimbhora  Bk.',                                                  
            Territory__c = 'Narayangaon', 
            Tehsil__c = tehsil.Id,
            Region__c = 'Aurangabad',                                                      
            Zone__c = 'Pune Zone',
            Fo_Map__c = true);
        insert village;
        
        contact con = new contact(LastName ='kenia',Village__c = village.id);
        insert con;
        
        system.debug('con territory'+con.Territory__c);
        AKC_Product__c akcPdt = new AKC_Product__c(
            Name = 'Amigo',                // AKC Product Name
            //Product__c = '01t28000003COiH',  // Product
            Doses__c = '150',                // Doses
            Unit__c = 'ml',                  // Unit
            Acre_kg__c = 'Per Acre'         // Acre/kg
        );
        insert akcPdt;
        Test.startTest();
        
        System.runAs(u){
            
            List<case> casenewlist=new List<case>();
            Case caseObj1 = new Case(RecordTypeId = caseRecordType1,Status = 'Open',Data_Pattern_Territory__c = territory1.Id,type='Weed',Crop_pick__c = 'Brinjal',Weed__c ='Post Imergent');
            insert caseObj1;
            Case caseObj3 = new Case(RecordTypeId = caseRecordType1,Status = 'Open',Data_Pattern_Territory__c = territory1.Id,type='Weed',Crop_pick__c = 'Brinjal',Weed__c ='Post Imergent');
            
            casenewlist.add(caseObj3);
            Case caseObj4 = new Case(RecordTypeId = caseRecordType1,Status = 'Open',Data_Pattern_Territory__c = territory1.Id,type='Weed',Crop_pick__c = 'Brinjal',Weed__c ='Post Imergent');
            
            casenewlist.add(caseObj4);
            insert casenewlist;
            List<Case_Crop_Pattern__c> casecrops=new list<Case_Crop_Pattern__c>();
            Case_Crop_Pattern__c cp=new Case_Crop_Pattern__c();
            cp.Pattern__c='Insect';
            cp.Crop_Text__c='Brinjal';
            cp.Start_Date__c=system.today();
            cp.End_Date__c=system.today()+1;
            cp.Case__c=caseObj1.id;
            casecrops.add(cp);
            Case_Crop_Pattern__c cp1=new Case_Crop_Pattern__c();
            cp1.Pattern__c='Weed';
            cp1.Crop_Text__c='Brinjal';
            cp1.Start_Date__c=system.today();
            cp1.End_Date__c=system.today()+1;
            cp1.Case__c=caseObj1.id;
            
            casecrops.add(cp1);
            Case_Crop_Pattern__c cp2=new Case_Crop_Pattern__c();
            cp2.Pattern__c='Disease';
            cp2.Crop_Text__c='Brinjal';
            cp2.Start_Date__c=system.today();
            cp2.End_Date__c=system.today()+1;
            cp2.Case__c=caseObj1.id;
            casecrops.add(cp2);
            insert casecrops;
            string caseRecordType  =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('Data Pattern Calling form').getRecordTypeId();
            
            
            string uplGeneralCase = Schema.SObjectType.Case.getRecordTypeInfosByName().get('AKC General Case').getRecordTypeId();
            
            system.debug('caseObj :'+caseObj1);
            ApexPages.StandardController sc = new ApexPages.StandardController(caseObj1);
            ProductPatternAKC_Controller productPatternContObj  = new ProductPatternAKC_Controller(sc);
            
            productPatternContObj.listCrops = 'Brinjal';
            productPatternContObj.listSelPattern = 'Insect,Weed,PGR';
            productPatternContObj.territoryName = territory1.Name;
            
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
            
         string Distributor = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
          system.assert(caseObj1.type=='Weed','Type should be weed');  
        } Test.stopTest();} 
    /*  
* Name: methodOninsectandBrinjal    
* return:void
* Description:  APPS-2074-This method responsible to cover the code when type is Disease and crop pick is Brinjal
*/
    @isTest  
    public static void methodOninsectandBrinjal()
    {
        
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
        
        Sales_Org__c salorg = new Sales_Org__c();
        salorg.name = 'India';
        salorg.Sales_Org_Code__c = '1000';
        insert salorg;
        
        Zone__c Zonesobj = new Zone__c(
            Name = 'Pune',                  // Zone Name
            SalesOrg__c =salorg.id,  // Sales Org
            ZoneCode__c = 'SWZ08',
            ZonalHead__c= u2.id            // Zone Code
        );
        insert Zonesobj;
        
        Region__c RegionSobj = new Region__c(
            Name = 'PUNE',                  // Region Name
            RegionCode__c = 'SW017',          // Region Code
            SalesOrg__c = salorg.id,
            RegionHead__c = u.id,
            // Sales Org
            Zone__c = Zonesobj.id      // Zone
        );
        insert RegionSobj;
        
        
        
        Territory_Distributor__c territory1 = new Territory_Distributor__c();
        territory1.Name = 'Narayangaon1';
        territory1.TerritoryManager__c = u1.id;
        territory1.TerritoryCode__c = '3973';
        territory1.Region__c = RegionSobj.id;
        territory1.SalesOrg__c = salorg.id;
        territory1.Zone__c = Zonesobj.id;
        territory1.Present_in_KEDE__c = true;
        territory1.Neglected__c = false;
        insert territory1;
        string caseRecordType1  =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('Data Pattern Calling form').getRecordTypeId();
        State__c state = new State__c(Name = 'Tamil Nadu');
        insert state;
        
        District__c dist = new District__c(
            Name = 'Krishnagiri',                   // District Name
            District_Code__c = '631',                 // District Code
            State__c = state.Id,             
            Active__c = false,                        // Active
            District_Name_Census__c = 'Krishnagiri',  // District Name Census
            District_Code_Census__c = '631');
        insert dist;
        
        Tehsil__c tehsil = new Tehsil__c(
            Name = '644000', 
            District__c = dist.Id,
            Tehsil_Code__c = '5890');
        insert tehsil;
        
        Village__c village = new Village__c(
            Name = 'Nimbhora  Bk.',                                                  
            Territory__c = 'Narayangaon', 
            Tehsil__c = tehsil.Id,
            Region__c = 'Aurangabad',                                                      
            Zone__c = 'Pune Zone',
            Fo_Map__c = true);
        insert village;
        
        contact con = new contact(LastName ='kenia',Village__c = village.id);
        insert con;
        
        system.debug('con territory'+con.Territory__c);
        AKC_Product__c akcPdt = new AKC_Product__c(
            Name = 'Amigo',                // AKC Product Name
            //Product__c = '01t28000003COiH',  // Product
            Doses__c = '150',                // Doses
            Unit__c = 'ml',                  // Unit
            Acre_kg__c = 'Per Acre'         // Acre/kg
        );
        insert akcPdt;
        Test.startTest();
        
        System.runAs(u){
            
            List<case> casenewlist=new List<case>();
            
            Case caseObj1 = new Case(RecordTypeId = caseRecordType1,Status = 'Open',Data_Pattern_Territory__c = territory1.Id,type='Disease',Crop_pick__c = 'Brinjal',Disease_General_Case__c ='Mosaic');
            
            insert caseObj1;
            
            Case caseObj2 = new Case(RecordTypeId = caseRecordType1,Status = 'Open',Data_Pattern_Territory__c = territory1.Id,type='Disease',Crop_pick__c = 'Brinjal',Disease_General_Case__c ='Mosaic');
            
            casenewlist.add(caseObj2);
            Case caseObj3 = new Case(RecordTypeId = caseRecordType1,Status = 'Open',Data_Pattern_Territory__c = territory1.Id,type='Disease',Crop_pick__c = 'Brinjal',Disease_General_Case__c ='Mosaic');
            
            casenewlist.add(caseObj3);
            insert casenewlist;
            List<Case_Crop_Pattern__c> casecrops=new list<Case_Crop_Pattern__c>();
            Case_Crop_Pattern__c cp=new Case_Crop_Pattern__c();
            cp.Pattern__c='Insect';
            cp.Crop_Text__c='Brinjal';
            cp.Start_Date__c=system.today();
            cp.End_Date__c=system.today()+1;
            cp.Case__c=caseObj1.id;
            casecrops.add(cp);
            Case_Crop_Pattern__c cp1=new Case_Crop_Pattern__c();
            cp1.Pattern__c='Weed';
            cp1.Crop_Text__c='Brinjal';
            cp1.Start_Date__c=system.today();
            cp1.End_Date__c=system.today()+1;
            cp1.Case__c=caseObj1.id;
            
            casecrops.add(cp1);
            Case_Crop_Pattern__c cp2=new Case_Crop_Pattern__c();
            cp2.Pattern__c='Disease';
            cp2.Crop_Text__c='Brinjal';
            cp2.Start_Date__c=system.today();
            cp2.End_Date__c=system.today()+1;
            cp2.Case__c=caseObj1.id;
            casecrops.add(cp2);
            insert casecrops;
            string caseRecordType  =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('Data Pattern Calling form').getRecordTypeId();
            
            
            string uplGeneralCase = Schema.SObjectType.Case.getRecordTypeInfosByName().get('AKC General Case').getRecordTypeId();
            
            system.debug('caseObj :'+caseObj1);
            ApexPages.StandardController sc = new ApexPages.StandardController(caseObj1);
            ProductPatternAKC_Controller productPatternContObj  = new ProductPatternAKC_Controller(sc);
            
            productPatternContObj.listCrops = 'Brinjal';
            productPatternContObj.listSelPattern = 'Insect,Weed,PGR';
            productPatternContObj.territoryName = territory1.Name;
            
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
            
            string Distributor = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
           system.assert(caseObj1.type=='Disease','Type should be weed'); 
        } Test.stopTest();} 
    /*  
* Name: TypeAsPGRandPickAsBrinjal    
* return:void
* Description:  APPS-2074-This method responsible to cover the code when Type is PGR and crop pick is Brinjal
*/    
    @isTest  
    public static void TypeAsPGRandPickAsBrinjal()
    {
        
        
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
        Sales_Org__c salorg = new Sales_Org__c();
        salorg.name = 'India';
        salorg.Sales_Org_Code__c = '1000';
        insert salorg;
        
        Zone__c Zonesobj = new Zone__c(
            Name = 'Pune',                  // Zone Name
            SalesOrg__c =salorg.id,  // Sales Org
            ZoneCode__c = 'SWZ08',
            ZonalHead__c= u2.id            // Zone Code
        );
        insert Zonesobj;
        
        Region__c Regionsobj = new Region__c(
            Name = 'PUNE',                  // Region Name
            RegionCode__c = 'SW017',          // Region Code
            SalesOrg__c = salorg.id,
            RegionHead__c = u.id,
            // Sales Org
            Zone__c = Zonesobj.id      // Zone
        );
        insert Regionsobj;
        
        
        
        Territory_Distributor__c territory1 = new Territory_Distributor__c();
        territory1.Name = 'Narayangaon1';
        territory1.TerritoryManager__c = u1.id;
        territory1.TerritoryCode__c = '3973';
        territory1.Region__c = Regionsobj.id;
        territory1.SalesOrg__c = salorg.id;
        territory1.Zone__c = Zonesobj.id;
        territory1.Present_in_KEDE__c = true;
        territory1.Neglected__c = false;
        insert territory1;
        string caseRecordType1  =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('Data Pattern Calling form').getRecordTypeId();
        State__c state = new State__c(Name = 'Tamil Nadu');
        insert state;
        
        District__c dist = new District__c(
            Name = 'Krishnagiri',                   // District Name
            District_Code__c = '631',                 // District Code
            State__c = state.Id,             
            Active__c = false,                        // Active
            District_Name_Census__c = 'Krishnagiri',  // District Name Census
            District_Code_Census__c = '631');
        insert dist;
        
        Tehsil__c tehsil = new Tehsil__c(
            Name = '644000', 
            District__c = dist.Id,
            Tehsil_Code__c = '5890');
        insert tehsil;
        
        Village__c village = new Village__c(
            Name = 'Nimbhora  Bk.',                                                  
            Territory__c = 'Narayangaon', 
            Tehsil__c = tehsil.Id,
            Region__c = 'Aurangabad',                                                      
            Zone__c = 'Pune Zone',
            Fo_Map__c = true);
        insert village;
        
        contact con = new contact(LastName ='kenia',Village__c = village.id);
        insert con;
        
        system.debug('con territory'+con.Territory__c);
        AKC_Product__c akcPdt = new AKC_Product__c(
            Name = 'Amigo',                // AKC Product Name
            //Product__c = '01t28000003COiH',  // Product
            Doses__c = '150',                // Doses
            Unit__c = 'ml',                  // Unit
            Acre_kg__c = 'Per Acre'         // Acre/kg
        );
        insert akcPdt;
        Test.startTest();
        
        System.runAs(u){
            
            List<case> casenewlist=new List<case>();
            
            Case caseObj1 = new Case(RecordTypeId = caseRecordType1,Status = 'Open',Data_Pattern_Territory__c = territory1.Id,Type = 'PGR',Crop_pick__c = 'Brinjal',PGR__c ='Growth Promoters');
            
            insert caseObj1;
            
            Case caseObj2 = new Case(RecordTypeId = caseRecordType1,Status = 'Open',Data_Pattern_Territory__c = territory1.Id,Type = 'PGR',Crop_pick__c = 'Brinjal',PGR__c ='Growth Promoters');
            
            casenewlist.add(caseObj2);
            Case caseObj3 = new Case(RecordTypeId = caseRecordType1,Status = 'Open',Data_Pattern_Territory__c = territory1.Id,Type = 'PGR',Crop_pick__c = 'Brinjal',PGR__c ='Growth Promoters');
            
            casenewlist.add(caseObj3);
            insert casenewlist;
            List<Case_Crop_Pattern__c> casecrops=new list<Case_Crop_Pattern__c>();
            Case_Crop_Pattern__c cp=new Case_Crop_Pattern__c();
            cp.Pattern__c='PGR';
            cp.Crop_Text__c='Brinjal';
            cp.Start_Date__c=system.today();
            cp.End_Date__c=system.today()+1;
            cp.Case__c=caseObj1.id;
            casecrops.add(cp);
            Case_Crop_Pattern__c cp1=new Case_Crop_Pattern__c();
            cp1.Pattern__c='Weed';
            cp1.Crop_Text__c='Brinjal';
            cp1.Start_Date__c=system.today();
            cp1.End_Date__c=system.today()+1;
            cp1.Case__c=caseObj1.id;
            
            casecrops.add(cp1);
            Case_Crop_Pattern__c cp2=new Case_Crop_Pattern__c();
            cp2.Pattern__c='Disease';
            cp2.Crop_Text__c='Brinjal';
            cp2.Start_Date__c=system.today();
            cp2.End_Date__c=system.today()+1;
            cp2.Case__c=caseObj1.id;
            casecrops.add(cp2);
            insert casecrops;
            string caseRecordType  =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('Data Pattern Calling form').getRecordTypeId();
            
            
            string uplGeneralCase = Schema.SObjectType.Case.getRecordTypeInfosByName().get('AKC General Case').getRecordTypeId();
            
            system.debug('caseObj :'+caseObj1);
            ApexPages.StandardController sc = new ApexPages.StandardController(caseObj1);
            ProductPatternAKC_Controller productPatternContObj  = new ProductPatternAKC_Controller(sc);
            
            productPatternContObj.listCrops = 'Brinjal';
            productPatternContObj.listSelPattern = 'Insect,Weed,PGR';
            productPatternContObj.territoryName = territory1.Name;
            
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
            
            string Distributor = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
           system.assert(caseObj1.type=='PGR','Type should be weed');   
        } Test.stopTest();} 
    
    /*  
* Name: InsectAndBrinjal    
* return:void
* Description:  APPS-2074-This method responsible to cover the code when Pattern is Insect and crop pick is Brinjal
*/
    @isTest  
    public static void InsectAndBrinjal()
    {
        
        
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
        Sales_Org__c salorg = new Sales_Org__c();
        salorg.name = 'India';
        salorg.Sales_Org_Code__c = '1000';
        insert salorg;
        
        Zone__c Zonesobj = new Zone__c(
            Name = 'Pune',                  // Zone Name
            SalesOrg__c =salorg.id,  // Sales Org
            ZoneCode__c = 'SWZ08',
            ZonalHead__c= u2.id            // Zone Code
        );
        insert Zonesobj;
        
        Region__c Regionsobj = new Region__c(
            Name = 'PUNE',                  // Region Name
            RegionCode__c = 'SW017',          // Region Code
            SalesOrg__c = salorg.id,
            RegionHead__c = u.id,
            // Sales Org
            Zone__c = Zonesobj.id      // Zone
        );
        insert Regionsobj;
        
        
        
        Territory_Distributor__c territory1 = new Territory_Distributor__c();
        territory1.Name = 'Narayangaon1';
        territory1.TerritoryManager__c = u1.id;
        territory1.TerritoryCode__c = '3973';
        territory1.Region__c = Regionsobj.id;
        territory1.SalesOrg__c = salorg.id;
        territory1.Zone__c = Zonesobj.id;
        territory1.Present_in_KEDE__c = true;
        territory1.Neglected__c = false;
        insert territory1;
        string caseRecordType1  =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('Data Pattern Calling form').getRecordTypeId();
        State__c state = new State__c(Name = 'Tamil Nadu');
        insert state;
        
        District__c dist = new District__c(
            Name = 'Krishnagiri',                   // District Name
            District_Code__c = '631',                 // District Code
            State__c = state.Id,             
            Active__c = false,                        // Active
            District_Name_Census__c = 'Krishnagiri',  // District Name Census
            District_Code_Census__c = '631');
        insert dist;
        
        Tehsil__c tehsil = new Tehsil__c(
            Name = '644000', 
            District__c = dist.Id,
            Tehsil_Code__c = '5890');
        insert tehsil;
        
        Village__c village = new Village__c(
            Name = 'Nimbhora  Bk.',                                                  
            Territory__c = 'Narayangaon', 
            Tehsil__c = tehsil.Id,
            Region__c = 'Aurangabad',                                                      
            Zone__c = 'Pune Zone',
            Fo_Map__c = true);
        insert village;
        
        contact con = new contact(LastName ='kenia',Village__c = village.id);
        insert con;
        
        system.debug('con territory'+con.Territory__c);
        AKC_Product__c akcPdt = new AKC_Product__c(
            Name = 'Amigo',                // AKC Product Name
            //Product__c = '01t28000003COiH',  // Product
            Doses__c = '150',                // Doses
            Unit__c = 'ml',                  // Unit
            Acre_kg__c = 'Per Acre'         // Acre/kg
        );
        insert akcPdt;
        Test.startTest();
        
        System.runAs(u){
            
            List<case> casenewlist=new List<case>();
            Case caseObj = new Case(RecordTypeId = caseRecordType1,Status = 'Open',Data_Pattern_Territory__c = territory1.Id,type='Insect',Crop_pick__c = 'Brinjal',Insect_General_Case__c='Aphids');
            insert caseObj;
            
            Case caseObj1 = new Case(RecordTypeId = caseRecordType1,Status = 'Open',Data_Pattern_Territory__c = territory1.Id,type='Insect',Crop_pick__c = 'Brinjal',Insect_General_Case__c='Aphids');
            //insert caseObj;
            casenewlist.add(caseObj1);
            Case caseObj2 = new Case(RecordTypeId = caseRecordType1,Status = 'Open',Data_Pattern_Territory__c = territory1.Id,type='Insect',Crop_pick__c = 'Brinjal',Insect_General_Case__c='Aphids');
            //insert caseObj;
            casenewlist.add(caseObj2);
            insert casenewlist;
            List<Case_Crop_Pattern__c> casecrops=new list<Case_Crop_Pattern__c>();
            Case_Crop_Pattern__c cp=new Case_Crop_Pattern__c();
            cp.Pattern__c='Insect';
            cp.Crop_Text__c='Brinjal';
            cp.Start_Date__c=system.today();
            cp.End_Date__c=system.today()+1;
            cp.Case__c=caseObj.id;
            casecrops.add(cp);
            Case_Crop_Pattern__c cp1=new Case_Crop_Pattern__c();
            cp1.Pattern__c='Weed';
            cp1.Crop_Text__c='Brinjal';
            cp1.Start_Date__c=system.today();
            cp1.End_Date__c=system.today()+1;
            cp1.Case__c=caseObj.id;
            
            casecrops.add(cp1);
            Case_Crop_Pattern__c cp2=new Case_Crop_Pattern__c();
            cp2.Pattern__c='Disease';
            cp2.Crop_Text__c='Brinjal';
            cp2.Start_Date__c=system.today();
            cp2.End_Date__c=system.today()+1;
            cp2.Case__c=caseObj.id;
            casecrops.add(cp2);
            insert casecrops;
            string caseRecordType  =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('Data Pattern Calling form').getRecordTypeId();
            
            
            string uplGeneralCase = Schema.SObjectType.Case.getRecordTypeInfosByName().get('AKC General Case').getRecordTypeId();
            
            
            system.debug('caseObj :'+caseObj);
            ApexPages.StandardController sc = new ApexPages.StandardController(caseObj);
            ProductPatternAKC_Controller productPatternContObj  = new ProductPatternAKC_Controller(sc);
            
            productPatternContObj.listCrops = 'Brinjal';
            productPatternContObj.listSelPattern = 'Insect,Weed,PGR';
            productPatternContObj.territoryName = territory1.Name;
            
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
            
            string Distributor = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
          system.assert(caseObj.type=='Insect','Type should be weed');    
        } Test.stopTest();} 
    
    
    /*  
* Name: TocoverSaveCaseInfo    
* return:void
* Description:  APPS-2074-This method responsible to cover saveCaseInformation Method
*/   
    @isTest  
    public static void TocoverSaveCaseInfo()
    {
        
        
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
        Sales_Org__c salorg = new Sales_Org__c();
        salorg.name = 'India';
        salorg.Sales_Org_Code__c = '1000';
        insert salorg;
        
        Zone__c Zonesobj = new Zone__c(
            Name = 'Pune',                  // Zone Name
            SalesOrg__c =salorg.id,  // Sales Org
            ZoneCode__c = 'SWZ08',
            ZonalHead__c= u2.id            // Zone Code
        );
        insert Zonesobj;
        
        Region__c Regionsobj = new Region__c(
            Name = 'PUNE',                  // Region Name
            RegionCode__c = 'SW017',          // Region Code
            SalesOrg__c = salorg.id,
            RegionHead__c = u.id,
            // Sales Org
            Zone__c = Zonesobj.id      // Zone
        );
        insert Regionsobj;
        
        Territory_Distributor__c territory1 = new Territory_Distributor__c();
        territory1.Name = 'Narayangaon1';
        territory1.TerritoryManager__c = u1.id;
        territory1.TerritoryCode__c = '3973';
        territory1.Region__c = Regionsobj.id;
        territory1.SalesOrg__c = salorg.id;
        territory1.Zone__c = Zonesobj.id;
        territory1.Present_in_KEDE__c = true;
        territory1.Neglected__c = false;
        insert territory1;
        string caseRecordType1  =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('Data Pattern Calling form').getRecordTypeId();
        
        Test.startTest();
        // Case caseObj=[select id,RecordTypeId,Status,type,Data_Pattern_Territory__c,Crop_pick__c from case where type='Insect' limit 1];
        
        System.runAs(u){
            
            string caseRecordType  =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('Data Pattern Calling form').getRecordTypeId();
            string uplGeneralCase = Schema.SObjectType.Case.getRecordTypeInfosByName().get('AKC General Case').getRecordTypeId();
            string Distributor = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
            
            ProductPatternAKC_Controller pkc=new ProductPatternAKC_Controller();
            pkc.JSONData='[{"unit":"","totalCount":3,"recordIndex":0,"patternType":"Weed","listProductPattern":[],"listCasetableDetails":[{"type":"Post Imergent","subject":"Brinjal - Weed -","patternCount":3,"combination":""}],"heading":"Weed Brinjal Information","caseCropPatternobj":{"zMConfirmation":"None","voiceBlastStatus":"None","Script":"None","recordingBy":"None","recId":"","Reason":"None","heading":"","caseId":""},"acreKg":""}]';
            pkc.saveCaseInformation();
        } Test.stopTest();} 
}