@isTest
public class ChatBot_GetInventoryData_Test {
    public static testmethod void chatbot_InventoryData_Test(){
        ZUDL_ZUIC_C03_Q001__x externalObj=new ZUDL_ZUIC_C03_Q001__x();
        externalObj.BRAND__c='testBrand';
        externalObj.COMP_CODE__c='100';
        externalObj.PLANT_CODE__c='pc01';
        externalObj.COMP_DESC__c='testCompDesc';
        externalObj.QTY__c=10;
        externalObj.UOM__c='kg';
        externalObj.PLANT_DESC__c='testPlantDesc';
        //insert externalObj;
        
        Sales_Org__c salesOrgObj = new Sales_Org__c(
           Name = 'Australia',            // Sales Org Name
           Description__c = 'Australia',    // Description
           Company_Code__c = '6100',    // Company Code
           Sales_Org_Code__c = '6100'  // Sales Org Code
       );
        insert salesOrgObj;
        
           Sales_Org__c salesOrgObj1 = new Sales_Org__c(
           Name = 'New Zealand',            // Sales Org Name
           Description__c = 'New Zealand',    // Description
           Company_Code__c = '6061',    // Company Code
           Sales_Org_Code__c = '6060'  // Sales Org Code
       );
        insert salesOrgObj1;
        
        User u = new User(
           ProfileId = [SELECT Id FROM Profile WHERE Name = 'Territory Manager'].Id,
           
           LastName = 'last',
           Email = 'puser000@amamama.com',
           Username = 'puser000@amamama.com' + System.currentTimeMillis(),
           Country='Australia',
           CompanyName = 'TEST',
           Title = 'title',
           Alias = 'alias',
           TimeZoneSidKey = 'America/Los_Angeles',
           EmailEncodingKey = 'UTF-8',
           LanguageLocaleKey = 'en_US',
           LocaleSidKey = 'en_US',
           isActive = true,
           Show_Inventory__c = true
            
           //  UserRoleId =  ur.Id
       );  
       insert u;
        
       User u1 = new User(
           ProfileId = [SELECT Id FROM Profile WHERE Name = 'Territory Manager'].Id,
           
           LastName = 'last',
           Email = 'puser000@amamama.com',
           Username = 'puser000@amamama.com' + System.currentTimeMillis(),
           Country='New Zealand',
           CompanyName = 'TEST',
           Title = 'title',
           Alias = 'alias',
           TimeZoneSidKey = 'America/Los_Angeles',
           EmailEncodingKey = 'UTF-8',
           LanguageLocaleKey = 'en_US',
           LocaleSidKey = 'en_US',
           isActive = true,
           Show_Inventory__c = true
            
           //  UserRoleId =  ur.Id
       );  
       insert u1;
        
        User u2 = new User(
           ProfileId = [SELECT Id FROM Profile WHERE Name = 'Regional/Zonal Managers'].Id,
           
           LastName = 'last',
           Email = 'puser0002@amamama.com',
           Username = 'puser0002@amamama.com' + System.currentTimeMillis(),
           Country='Swal',
           CompanyName = 'TEST',
           Title = 'title',
           Alias = 'alias',
           TimeZoneSidKey = 'America/Los_Angeles',
           EmailEncodingKey = 'UTF-8',
           LanguageLocaleKey = 'en_US',
           LocaleSidKey = 'en_US',
           isActive = true,
            Show_Inventory__c = true,
            MobilePhone = '8888888888'
           //  UserRoleId =  ur2.Id
       );  
       insert u2;
       // UserRole ur3 = new UserRole(Name = 'SBU Head India 1');
       // insert ur3;
       User u3 = new User(
           ProfileId = [SELECT Id FROM Profile WHERE Name = 'Sales Head Pune' OR Name = 'SBU Profile'].Id,
           LastName = 'last',
           Email = 'puser003@amamama.com',
           Username = 'puser0003@amamama.com' + System.currentTimeMillis(),
           Country='India',
           CompanyName = 'TEST',
           Title = 'title',
           Alias = 'alias',
           TimeZoneSidKey = 'America/Los_Angeles',
           EmailEncodingKey = 'UTF-8',
           LanguageLocaleKey = 'en_US',
           LocaleSidKey = 'en_US',
           isActive = true,
           Show_Inventory__c = true,
           MobilePhone = '8888888888'
           // UserRoleId =  ur3.Id
       );  
       insert u3;
       
       // UserRole ur4 = new UserRole(Name = 'Zonal Commercial Executive Pune');
       // insert ur4;
       User u4 = new User(
           ProfileId = [SELECT Id FROM Profile WHERE Name = 'Zonal Marketing Manager' OR Name = 'SBU Profile'].Id,
           LastName = 'last',
           Email = 'puser004@amamama.com',
           Username = 'puser0004@amamama.com' + System.currentTimeMillis(),
           Country='India',
           CompanyName = 'TEST',
           Title = 'title',
           Alias = 'alias',
           TimeZoneSidKey = 'America/Los_Angeles',
           EmailEncodingKey = 'UTF-8',
           LanguageLocaleKey = 'en_US',
           LocaleSidKey = 'en_US',
           isActive = true,
           Show_Inventory__c = true,
           MobilePhone = '8888888888'
           //UserRoleId =  ur4.Id
       );  
       insert u4;
        
        Depot__c depo=new Depot__c();
        depo.Name='depo1';
        depo.Depot_Code__c='pc01';
        insert depo;
        
        
        
        SBU__c SBUObj = new SBU__c(
           SBUUser__c = u3.Id, // SBU User
           SBUCode__c = 'SBU2',              // SBU Code
           SalesOrg__c = salesOrgObj.id  // Sales Org
       );
       insert SBUObj;
       
           SBU__c SBUObj1 = new SBU__c(
           SBUUser__c = u3.Id, // SBU User
           SBUCode__c = 'SBU21',              // SBU Code
           SalesOrg__c = salesOrgObj1.id  // Sales Org
       );
       insert SBUObj1;
        
         Zone__c zoneObj = new Zone__c(
           Name = 'Indore',                 // Zone Name
           SalesOrg__c = salesOrgObj.Id,   // Sales Org
           ZoneCode__c = 'Z16',               // Zone Code
           ZonalHead__c = u1.Id,  // Zonal Head
           ZMMUser__c = u4.Id,
           SBUCode__c = SBUObj.Id    // SBU Code
       );
       insert zoneObj;
        
         Zone__c zoneObj1 = new Zone__c(
           Name = 'Indore1',                 // Zone Name
           SalesOrg__c = salesOrgObj1.Id,   // Sales Org
           ZoneCode__c = 'Z161',               // Zone Code
           ZonalHead__c = u1.Id,  // Zonal Head
           ZMMUser__c = u4.Id,
           SBUCode__c = SBUObj1.Id    // SBU Code
       );
       insert zoneObj1;
        
        Zone_Depot_Mapping__c zdm=new Zone_Depot_Mapping__c();
       	zdm.Depot__c=depo.id;
        zdm.SBU__c=SBUObj.Id;
        zdm.Sales_Org__c=salesOrgObj.Id;
        zdm.Name='testZdm';
        zdm.Zone__c=zoneObj.id;
        insert zdm;
        
        Zone_Depot_Mapping__c zdm1=new Zone_Depot_Mapping__c();
       	zdm1.Depot__c=depo.id;
        zdm1.SBU__c=SBUObj1.Id;
        zdm1.Sales_Org__c=salesOrgObj1.Id;
        zdm1.Name='testZdm';
        zdm1.Zone__c=zoneObj1.id;
        insert zdm1;
        
        TM_Depot_Mapping__c tdm=new TM_Depot_Mapping__c();
        tdm.Depot__c=depo.Id;
        insert tdm;
        
        
        /*
            insert Live Chat Visitor
        */
        LiveChatVisitor lcv = new LiveChatVisitor();
        try{
            insert lcv;
        }catch(Exception e){}
        /*
            insert Live Chat Transcript
        */
        LiveChatTranscript lct = new LiveChatTranscript();
        lct.LiveChatVisitorid = lcv.id;
    	lct.Loggedin_User__c =u.Id;
        lct.ChatKey ='abcd';
        try{
            insert lct;
        }catch(Exception e){}
        
        LiveChatTranscript lct1 = new LiveChatTranscript();
        lct1.LiveChatVisitorid = lcv.id;
    	lct1.Loggedin_User__c =u1.Id;
        lct1.ChatKey ='abcde';
        try{
            insert lct1;
        }catch(Exception e){}
        system.debug('lct' + lct);
                /*
            insert Live Chat Transcript Event
        */
        LiveChatTranscriptEvent le = new LiveChatTranscriptEvent();
        le.LiveChatTranscriptId = lct.id;
        le.type = 'ChatRequest';
        le.time = system.now();
        try{
            insert le;
        }
        catch(Exception e){}
        try{
            delete le;
        }
        catch(Exception e){}
        
        Bot_GetSnapInsPreChatData.DepotInformation tmDepoMapRec1=new Bot_GetSnapInsPreChatData.DepotInformation();
        tmDepoMapRec1.depotName ='Test';
        tmDepoMapRec1.depotCode ='pc01';
        
        ChatBot_GetInventoryData.PrechatInput inputParam=new ChatBot_GetInventoryData.PrechatInput();
        List<ChatBot_GetInventoryData.PrechatInput> inputParams=new List<ChatBot_GetInventoryData.PrechatInput>();
        inputParam.sBrandName='testBrand';
        inputParam.tmDepoMapRec=tmDepoMapRec1;
        inputParam.chatkey='abcd';
        inputParams.add(inputParam);
        
        ChatBot_GetInventoryData.PrechatInput inputParam1=new ChatBot_GetInventoryData.PrechatInput();
        List<ChatBot_GetInventoryData.PrechatInput> inputParams1=new List<ChatBot_GetInventoryData.PrechatInput>();
        inputParam1.sBrandName='testBrand';
        inputParam1.tmDepoMapRec=tmDepoMapRec1;
        inputParam1.chatkey='abcde';
        inputParams1.add(inputParam1);
        
        
        ChatBot_GetInventoryData.getBrandData(inputParams);
        ChatBot_GetInventoryData.getBrandData(inputParams1);
    }
    
    public static testmethod void chatbot_InventoryData_Test1(){
        ZUDL_ZUIC_C03_Q001__x externalObj=new ZUDL_ZUIC_C03_Q001__x();
        externalObj.BRAND__c='testBrand';
        externalObj.COMP_CODE__c='100';
        externalObj.PLANT_CODE__c='pc01';
        externalObj.COMP_DESC__c='testCompDesc';
        externalObj.QTY__c=10;
        externalObj.UOM__c='kg';
        externalObj.PLANT_DESC__c='testPlantDesc';
        //insert externalObj; 
        
       Sales_Org__c salesOrgObj = new Sales_Org__c(
           Name = 'Indonesia',            // Sales Org Name
           Description__c = 'Indonesia',    // Description
           Company_Code__c = '6410',    // Company Code
           Sales_Org_Code__c = '6410'  // Sales Org Code
       );
        insert salesOrgObj;
        
       User u = new User(
           ProfileId = [SELECT Id FROM Profile WHERE Name = 'Territory Manager'].Id,
           
           LastName = 'last',
           Email = 'puser000@amamama.com',
           Username = 'puser000@amamama.com' + System.currentTimeMillis(),
           Country='Indonesia',
           CompanyName = 'TEST',
           Title = 'title',
           Alias = 'alias',
           TimeZoneSidKey = 'America/Los_Angeles',
           EmailEncodingKey = 'UTF-8',
           LanguageLocaleKey = 'en_US',
           LocaleSidKey = 'en_US',
           isActive = true,
           Show_Inventory__c = true
            
           //  UserRoleId =  ur.Id
       );  
       insert u;
        
        User u2 = new User(
           ProfileId = [SELECT Id FROM Profile WHERE Name = 'Regional/Zonal Managers'].Id,
           
           LastName = 'last',
           Email = 'puser0002@amamama.com',
           Username = 'puser0002@amamama.com' + System.currentTimeMillis(),
           Country='Swal',
           CompanyName = 'TEST',
           Title = 'title',
           Alias = 'alias',
           TimeZoneSidKey = 'America/Los_Angeles',
           EmailEncodingKey = 'UTF-8',
           LanguageLocaleKey = 'en_US',
           LocaleSidKey = 'en_US',
           isActive = true,
            Show_Inventory__c = true,
            MobilePhone = '8888888888'
           //  UserRoleId =  ur2.Id
       );  
       insert u2;
       // UserRole ur3 = new UserRole(Name = 'SBU Head India 1');
       // insert ur3;
       User u3 = new User(
           ProfileId = [SELECT Id FROM Profile WHERE Name = 'Sales Head Pune' OR Name = 'SBU Profile'].Id,
           LastName = 'last',
           Email = 'puser003@amamama.com',
           Username = 'puser0003@amamama.com' + System.currentTimeMillis(),
           Country='India',
           CompanyName = 'TEST',
           Title = 'title',
           Alias = 'alias',
           TimeZoneSidKey = 'America/Los_Angeles',
           EmailEncodingKey = 'UTF-8',
           LanguageLocaleKey = 'en_US',
           LocaleSidKey = 'en_US',
           isActive = true,
           Show_Inventory__c = true,
           MobilePhone = '8888888888'
           // UserRoleId =  ur3.Id
       );  
       insert u3;
       
       // UserRole ur4 = new UserRole(Name = 'Zonal Commercial Executive Pune');
       // insert ur4;
       User u4 = new User(
           ProfileId = [SELECT Id FROM Profile WHERE Name = 'Zonal Marketing Manager' OR Name = 'SBU Profile'].Id,
           LastName = 'last',
           Email = 'puser004@amamama.com',
           Username = 'puser0004@amamama.com' + System.currentTimeMillis(),
           Country='India',
           CompanyName = 'TEST',
           Title = 'title',
           Alias = 'alias',
           TimeZoneSidKey = 'America/Los_Angeles',
           EmailEncodingKey = 'UTF-8',
           LanguageLocaleKey = 'en_US',
           LocaleSidKey = 'en_US',
           isActive = true,
           Show_Inventory__c = true,
           MobilePhone = '8888888888'
           //UserRoleId =  ur4.Id
       );  
       insert u4;
        
        Depot__c depo=new Depot__c();
        depo.Name='depo1';
        depo.Depot_Code__c='d0123';
        insert depo;
        
        
        
        SBU__c SBUObj = new SBU__c(
           SBUUser__c = u3.Id, // SBU User
           SBUCode__c = 'SBU2',              // SBU Code
           SalesOrg__c = salesOrgObj.id  // Sales Org
       );
       insert SBUObj;
        
         Zone__c zoneObj = new Zone__c(
           Name = 'Indore',                 // Zone Name
           SalesOrg__c = salesOrgObj.Id,   // Sales Org
           ZoneCode__c = 'Z16',               // Zone Code
           ZonalHead__c = u2.Id,  // Zonal Head
           ZMMUser__c = u4.Id,
           SBUCode__c = SBUObj.Id    // SBU Code
       );
       insert zoneObj;
        
        Zone_Depot_Mapping__c zdm=new Zone_Depot_Mapping__c();
       	zdm.Depot__c=depo.id;
        zdm.SBU__c=SBUObj.Id;
        zdm.Sales_Org__c=salesOrgObj.Id;
        zdm.Name='testZdm';
        zdm.Zone__c=zoneObj.id;
        insert zdm;
        
        TM_Depot_Mapping__c tdm=new TM_Depot_Mapping__c();
        tdm.Depot__c=depo.Id;
        insert tdm;
        
        
        /*
            insert Live Chat Visitor
        */
        LiveChatVisitor lcv = new LiveChatVisitor();
        try{
            insert lcv;
        }catch(Exception e){}
        /*
            insert Live Chat Transcript
        */
        LiveChatTranscript lct = new LiveChatTranscript();
        lct.LiveChatVisitorid = lcv.id;
    	lct.Loggedin_User__c =u.Id;
        lct.ChatKey ='abcd';
        try{
            insert lct;
        }catch(Exception e){}
        system.debug('lct' + lct);
                /*
            insert Live Chat Transcript Event
        */
        LiveChatTranscriptEvent le = new LiveChatTranscriptEvent();
        le.LiveChatTranscriptId = lct.id;
        le.type = 'ChatRequest';
        le.time = system.now();
        try{
            insert le;
        }
        catch(Exception e){}
        try{
            delete le;
        }
        catch(Exception e){}
        
       Bot_GetSnapInsPreChatData.DepotInformation tmDepoMapRec1=new Bot_GetSnapInsPreChatData.DepotInformation();
        tmDepoMapRec1.depotName ='ALL';
        tmDepoMapRec1.depotCode ='ALL';
        
        ChatBot_GetInventoryData.PrechatInput inputParam=new ChatBot_GetInventoryData.PrechatInput();
        List<ChatBot_GetInventoryData.PrechatInput> inputParams=new List<ChatBot_GetInventoryData.PrechatInput>();
        inputParam.sBrandName='testBrand';
        inputParam.tmDepoMapRec=tmDepoMapRec1;
        inputParam.chatkey='abcd';
        inputParams.add(inputParam);
        
        ChatBot_GetInventoryData.getBrandData(inputParams);
    }

    public static testmethod void chatbot_PreChatData_Test2(){
       Sales_Org__c salesOrgObj = new Sales_Org__c(
           Name = 'India',            // Sales Org Name
           Description__c = 'India',    // Description
           Company_Code__c = '1000',    // Company Code
           Sales_Org_Code__c = '1000'  // Sales Org Code
       );
       insert salesOrgObj;
        User u = new User(
           ProfileId = [SELECT Id FROM Profile WHERE Name = 'Territory Manager'].Id,
           
           LastName = 'last',
           Email = 'puser000@amamama.com',
           Username = 'puser000@amamama.com' + System.currentTimeMillis(),
           Country='India',
           CompanyName = 'TEST',
           Title = 'title',
           Alias = 'alias',
           TimeZoneSidKey = 'America/Los_Angeles',
           EmailEncodingKey = 'UTF-8',
           LanguageLocaleKey = 'en_US',
           LocaleSidKey = 'en_US',
           isActive = true,
           Show_Inventory__c = true,
           MobilePhone = '8888888888'
            
           //  UserRoleId =  ur.Id
       );  
       insert u;
        User u2 = new User(
           ProfileId = [SELECT Id FROM Profile WHERE Name = 'Regional/Zonal Managers'].Id,
           
           LastName = 'last',
           Email = 'puser0002@amamama.com',
           Username = 'puser0002@amamama.com' + System.currentTimeMillis(),
           Country='Swal',
           CompanyName = 'TEST',
           Title = 'title',
           Alias = 'alias',
           TimeZoneSidKey = 'America/Los_Angeles',
           EmailEncodingKey = 'UTF-8',
           LanguageLocaleKey = 'en_US',
           LocaleSidKey = 'en_US',
           isActive = true,
            Show_Inventory__c = true,
            MobilePhone = '8888888888'
           //  UserRoleId =  ur2.Id
       );  
       insert u2;
       
       
       
       // UserRole ur3 = new UserRole(Name = 'SBU Head India 1');
       // insert ur3;
       User u3 = new User(
           ProfileId = [SELECT Id FROM Profile WHERE Name = 'Sales Head Pune' OR Name = 'SBU Profile'].Id,
           LastName = 'last',
           Email = 'puser003@amamama.com',
           Username = 'puser0003@amamama.com' + System.currentTimeMillis(),
           Country='Indonesia',
           CompanyName = 'TEST',
           Title = 'title',
           Alias = 'alias',
           TimeZoneSidKey = 'America/Los_Angeles',
           EmailEncodingKey = 'UTF-8',
           LanguageLocaleKey = 'en_US',
           LocaleSidKey = 'en_US',
           isActive = true,
           Show_Inventory__c = true
           // UserRoleId =  ur3.Id
       );  
       insert u3;
       
       // UserRole ur4 = new UserRole(Name = 'Zonal Commercial Executive Pune');
       // insert ur4;
       User u4 = new User(
           ProfileId = [SELECT Id FROM Profile WHERE Name = 'Zonal Marketing Manager' OR Name = 'SBU Profile'].Id,
           LastName = 'last',
           Email = 'puser004@amamama.com',
           Username = 'puser0004@amamama.com' + System.currentTimeMillis(),
           Country='India',
           CompanyName = 'TEST',
           Title = 'title',
           Alias = 'alias',
           TimeZoneSidKey = 'America/Los_Angeles',
           EmailEncodingKey = 'UTF-8',
           LanguageLocaleKey = 'en_US',
           LocaleSidKey = 'en_US',
           isActive = true,
           Show_Inventory__c = true,
           MobilePhone = '8888888888'
           //UserRoleId =  ur4.Id
       );  
       insert u4;
        
        
		
        
       Country__c countryObj = new Country__c(
           Name = 'India',      // Country Name
           Country_Id__c = '91'  // Country Id
       );
       insert countryObj;
       
       State__c stateObj = new State__c(
           Name = 'Uttar Pradesh',                // State Name
           State_Code__c = '9',                     // State Code
           Country__c = 'India',                    // Country
           Active__c = true,                        // Active
           State_Code_Census__c = '9',              // State Code Census
           State_Name_Census__c = 'UTTAR PRADESH',  // State Name Census
           Country_Akc__c = countryObj.id      // Country
       );
       insert stateObj;
       
       SBU__c SBUObj = new SBU__c(
           SBUUser__c = u3.Id, // SBU User
           SBUCode__c = 'SBU2',              // SBU Code
           SalesOrg__c = salesOrgObj.id  // Sales Org
       );
       insert SBUObj;
       
       Zone__c zoneObj = new Zone__c(
           Name = 'Indore',                 // Zone Name
           SalesOrg__c = salesOrgObj.Id,   // Sales Org
           ZoneCode__c = 'Z16',               // Zone Code
           ZonalHead__c = u2.Id,  // Zonal Head
           ZMMUser__c = u4.Id,
           SBUCode__c = SBUObj.Id    // SBU Code
       );
       insert zoneObj;
       
       Region__c regionObj = new Region__c(
           Name = 'TRIANGULO',                  // Region Name
           RegionCode__c = 'BR4003',              // Region Code
           SalesOrg__c =salesOrgObj.id,       // Sales Org
           // RegionHead__c = u1.id,     // Region Head
           Zone__c = zoneObj.id
           
       );
       insert regionObj;
        
        Depot__c depo=new Depot__c();
        depo.Name='depo1';
        depo.Depot_Code__c='d0123';
        insert depo;
       
       Territory_Distributor__c territoryObj = new Territory_Distributor__c();
       territoryObj.Name = 'Narayangaon';
       territoryObj.TerritoryCode__c = '398';
       territoryObj.SalesOrg__c = salesOrgObj.id;
       territoryObj.Region__c = regionObj.id;
       territoryObj.TerritoryManager__c = u.Id;
       territoryObj.Zone__c = zoneObj.id;
       territoryObj.SBU__c = SBUObj.Id;
       territoryObj.SalesOrg__c = salesOrgObj.id;
       territoryObj.Present_in_KEDE__c = true ;
       territoryObj.Neglected__c = false;
       
       insert territoryObj;
        
         Zone_Depot_Mapping__c zdm=new Zone_Depot_Mapping__c();
       	zdm.Depot__c=depo.id;
        zdm.SBU__c=SBUObj.Id;
        zdm.Sales_Org__c=salesOrgObj.Id;
        zdm.Name='testZdm';
        //zdm.Depot__r.Depot_Code__c=depo.Depot_Code__c;
        //zdm.Depot__r.Name=depo.Name;
        //zdm.Depot_Name__c=depo.Name;
        //zdm.Depot_Code__c=depo.Depot_Code__c;
        insert zdm;
        
        TM_Depot_Mapping__c tdm=new TM_Depot_Mapping__c(); 
        
            tdm.Territory_Manager__c=u.id;
            //tdm.Depot_Name__c=depo.Name;
            //tdm.Depot_Code__c=depo.Depot_Code__c;
            tdm.Depot__c=depo.id;
        insert tdm;
         
    	/*
            insert Live Chat Visitor
        */
        LiveChatVisitor lcv = new LiveChatVisitor();
        try{
            insert lcv;
        }catch(Exception e){}
        /*
            insert Live Chat Transcript
        */
        LiveChatTranscript lct = new LiveChatTranscript();
        lct.LiveChatVisitorid = lcv.id;
    	lct.Loggedin_User__c =u.Id;
        lct.ChatKey ='abcd';
        try{
            insert lct;
        }catch(Exception e){}
        system.debug('lct' + lct);
                /*
            insert Live Chat Transcript Event
        */
        LiveChatTranscriptEvent le = new LiveChatTranscriptEvent();
        le.LiveChatTranscriptId = lct.id;
        le.type = 'ChatRequest';
        le.time = system.now();
        try{
            insert le;
        }
        catch(Exception e){}
        try{
            delete le;
        }
        catch(Exception e){}
        
        Bot_GetSnapInsPreChatData.DepotInformation tmDepoMapRec1=new Bot_GetSnapInsPreChatData.DepotInformation();
        tmDepoMapRec1.depotName ='Test';
        tmDepoMapRec1.depotCode ='Test';
        ChatBot_GetInventoryData.PrechatInput inputParam=new ChatBot_GetInventoryData.PrechatInput();
        List<ChatBot_GetInventoryData.PrechatInput> inputParams=new List<ChatBot_GetInventoryData.PrechatInput>();
        inputParam.sBrandName='testBrand';
        inputParam.tmDepoMapRec=tmDepoMapRec1;
        inputParam.chatkey='abcd';
        inputParams.add(inputParam);
        
        ChatBot_GetInventoryData.getBrandData(inputParams);
        
        
    }
    
    public static testmethod void chatbot_PreChatData_Test3(){
       Sales_Org__c salesOrgObj = new Sales_Org__c(
           Name = 'Swal',            // Sales Org Name
           Description__c = 'Swal',    // Description
           Company_Code__c = '1210',    // Company Code
           Sales_Org_Code__c = '1210'  // Sales Org Code
       );
       insert salesOrgObj;
        User u = new User(
           ProfileId = [SELECT Id FROM Profile WHERE Name = 'Territory Manager'].Id,
           
           LastName = 'last',
           Email = 'puser000@amamama.com',
           Username = 'puser000@amamama.com' + System.currentTimeMillis(),
           Country='India',
           CompanyName = 'TEST',
           Title = 'title',
           Alias = 'alias',
           TimeZoneSidKey = 'America/Los_Angeles',
           EmailEncodingKey = 'UTF-8',
           LanguageLocaleKey = 'en_US',
           LocaleSidKey = 'en_US',
           isActive = true,
           Show_Inventory__c = true,
            MobilePhone = '8888888888'
            
           //  UserRoleId =  ur.Id
       );  
       insert u;
        User u2 = new User(
           ProfileId = [SELECT Id FROM Profile WHERE Name = 'Regional/Zonal Managers'].Id,
           
           LastName = 'last',
           Email = 'puser0002@amamama.com',
           Username = 'puser0002@amamama.com' + System.currentTimeMillis(),
           Country='Swal',
           CompanyName = 'TEST',
           Title = 'title',
           Alias = 'alias',
           TimeZoneSidKey = 'America/Los_Angeles',
           EmailEncodingKey = 'UTF-8',
           LanguageLocaleKey = 'en_US',
           LocaleSidKey = 'en_US',
           isActive = true,
            Show_Inventory__c = true,
            MobilePhone = '8888888888'
           //  UserRoleId =  ur2.Id
       );  
       insert u2;
       
       
       
       // UserRole ur3 = new UserRole(Name = 'SBU Head India 1');
       // insert ur3;
       User u3 = new User(
           ProfileId = [SELECT Id FROM Profile WHERE Name = 'Sales Head Pune' OR Name = 'SBU Profile'].Id,
           LastName = 'last',
           Email = 'puser003@amamama.com',
           Username = 'puser0003@amamama.com' + System.currentTimeMillis(),
           Country='Indonesia',
           CompanyName = 'TEST',
           Title = 'title',
           Alias = 'alias',
           TimeZoneSidKey = 'America/Los_Angeles',
           EmailEncodingKey = 'UTF-8',
           LanguageLocaleKey = 'en_US',
           LocaleSidKey = 'en_US',
           isActive = true,
           Show_Inventory__c = true
           // UserRoleId =  ur3.Id
       );  
       insert u3;
       
       // UserRole ur4 = new UserRole(Name = 'Zonal Commercial Executive Pune');
       // insert ur4;
       User u4 = new User(
           ProfileId = [SELECT Id FROM Profile WHERE Name = 'Zonal Marketing Manager' OR Name = 'SBU Profile'].Id,
           LastName = 'last',
           Email = 'puser004@amamama.com',
           Username = 'puser0004@amamama.com' + System.currentTimeMillis(),
           Country='India',
           CompanyName = 'TEST',
           Title = 'title',
           Alias = 'alias',
           TimeZoneSidKey = 'America/Los_Angeles',
           EmailEncodingKey = 'UTF-8',
           LanguageLocaleKey = 'en_US',
           LocaleSidKey = 'en_US',
           isActive = true,
           Show_Inventory__c = true,
           MobilePhone = '8888888888'
           //UserRoleId =  ur4.Id
       );  
       insert u4;
        
        
		
        
       Country__c countryObj = new Country__c(
           Name = 'India',      // Country Name
           Country_Id__c = '91'  // Country Id
       );
       insert countryObj;
       
       State__c stateObj = new State__c(
           Name = 'Uttar Pradesh',                // State Name
           State_Code__c = '9',                     // State Code
           Country__c = 'India',                    // Country
           Active__c = true,                        // Active
           State_Code_Census__c = '9',              // State Code Census
           State_Name_Census__c = 'UTTAR PRADESH',  // State Name Census
           Country_Akc__c = countryObj.id      // Country
       );
       insert stateObj;
       
       SBU__c SBUObj = new SBU__c(
           SBUUser__c = u3.Id, // SBU User
           SBUCode__c = 'SBU2',              // SBU Code
           SalesOrg__c = salesOrgObj.id  // Sales Org
       );
       insert SBUObj;
       
       Zone__c zoneObj = new Zone__c(
           Name = 'Indore',                 // Zone Name
           SalesOrg__c = salesOrgObj.Id,   // Sales Org
           ZoneCode__c = 'Z16',               // Zone Code
           ZonalHead__c = u2.Id,  // Zonal Head
           ZMMUser__c = u4.Id,
           SBUCode__c = SBUObj.Id    // SBU Code
       );
       insert zoneObj;
       
       Region__c regionObj = new Region__c(
           Name = 'TRIANGULO',                  // Region Name
           RegionCode__c = 'BR4003',              // Region Code
           SalesOrg__c =salesOrgObj.id,       // Sales Org
           // RegionHead__c = u1.id,     // Region Head
           Zone__c = zoneObj.id
           
       );
       insert regionObj;
        
        Depot__c depo=new Depot__c();
        depo.Name='depo1';
        depo.Depot_Code__c='d0123';
        insert depo;
       
       Territory_Distributor__c territoryObj = new Territory_Distributor__c();
       territoryObj.Name = 'Narayangaon';
       territoryObj.TerritoryCode__c = '398';
       territoryObj.SalesOrg__c = salesOrgObj.id;
       territoryObj.Region__c = regionObj.id;
       territoryObj.TerritoryManager__c = u2.Id;
       territoryObj.Zone__c = zoneObj.id;
       territoryObj.SBU__c = SBUObj.Id;
       territoryObj.SalesOrg__c = salesOrgObj.id;
       territoryObj.Present_in_KEDE__c = true ;
       territoryObj.Neglected__c = false;
       
       insert territoryObj;
        
         Zone_Depot_Mapping__c zdm=new Zone_Depot_Mapping__c();
       	zdm.Depot__c=depo.id;
        zdm.SBU__c=SBUObj.Id;
        zdm.Sales_Org__c=salesOrgObj.Id;
        zdm.Name='testZdm';
        //zdm.Depot__r.Depot_Code__c=depo.Depot_Code__c;
        //zdm.Depot__r.Name=depo.Name;
        //zdm.Depot_Name__c=depo.Name;
        //zdm.Depot_Code__c=depo.Depot_Code__c;
        insert zdm;
        
        TM_Depot_Mapping__c tdm=new TM_Depot_Mapping__c(); 
        
            tdm.Territory_Manager__c=u2.id;
            //tdm.Depot_Name__c=depo.Name;
            //tdm.Depot_Code__c=depo.Depot_Code__c;
            tdm.Depot__c=depo.id;
        insert tdm;
         
    	/*
            insert Live Chat Visitor
        */
        LiveChatVisitor lcv = new LiveChatVisitor();
        try{
            insert lcv;
        }catch(Exception e){}
        /*
            insert Live Chat Transcript
        */
        LiveChatTranscript lct = new LiveChatTranscript();
        lct.LiveChatVisitorid = lcv.id;
    	lct.Loggedin_User__c =u2.Id;
        lct.ChatKey ='abcd';
        try{
            insert lct;
        }catch(Exception e){}
        system.debug('lct' + lct);
                /*
            insert Live Chat Transcript Event
        */
        LiveChatTranscriptEvent le = new LiveChatTranscriptEvent();
        le.LiveChatTranscriptId = lct.id;
        le.type = 'ChatRequest';
        le.time = system.now();
        try{
            insert le;
        }
        catch(Exception e){}
        try{
            delete le;
        }
        catch(Exception e){}
        
        Bot_GetSnapInsPreChatData.DepotInformation tmDepoMapRec1=new Bot_GetSnapInsPreChatData.DepotInformation();
        tmDepoMapRec1.depotName ='Test';
        tmDepoMapRec1.depotCode ='Test';
        ChatBot_GetInventoryData.PrechatInput inputParam=new ChatBot_GetInventoryData.PrechatInput();
        List<ChatBot_GetInventoryData.PrechatInput> inputParams=new List<ChatBot_GetInventoryData.PrechatInput>();
        inputParam.sBrandName='testBrand';
        inputParam.tmDepoMapRec=tmDepoMapRec1;
        inputParam.chatkey='abcd';
        inputParams.add(inputParam);
        
        ChatBot_GetInventoryData.getBrandData(inputParams);
        
        
    }
    
    public static testmethod void chatbot_InventoryData_Test4(){
        ZUDL_ZUIC_C03_Q001__x externalObj=new ZUDL_ZUIC_C03_Q001__x();
        externalObj.BRAND__c='testBrand';
        externalObj.COMP_CODE__c='100';
        externalObj.PLANT_CODE__c='pc01';
        externalObj.COMP_DESC__c='testCompDesc';
        externalObj.QTY__c=10;
        externalObj.UOM__c='kg';
        externalObj.PLANT_DESC__c='testPlantDesc';
        //insert externalObj;
        
        Sales_Org__c salesOrgObj = new Sales_Org__c(
           Name = 'Belgium',            // Sales Org Name
           Description__c = 'Belgium',    // Description
           Company_Code__c = '2120',    // Company Code
           Sales_Org_Code__c = '2120'  // Sales Org Code
       );
        insert salesOrgObj;
        
        User u = new User(
           ProfileId = [SELECT Id FROM Profile WHERE Name = 'Territory Manager'].Id,
           
           LastName = 'last',
           Email = 'puser000@amamama.com',
           Username = 'puser000@amamama.com' + System.currentTimeMillis(),
           Country='Belgium',
           CompanyName = 'TEST',
           Title = 'title',
           Alias = 'alias',
           TimeZoneSidKey = 'America/Los_Angeles',
           EmailEncodingKey = 'UTF-8',
           LanguageLocaleKey = 'en_US',
           LocaleSidKey = 'en_US',
           isActive = true,
           Show_Inventory__c = true
            
           //  UserRoleId =  ur.Id
       );  
       insert u;
        
        User u2 = new User(
           ProfileId = [SELECT Id FROM Profile WHERE Name = 'Regional/Zonal Managers'].Id,
           
           LastName = 'last',
           Email = 'puser0002@amamama.com',
           Username = 'puser0002@amamama.com' + System.currentTimeMillis(),
           Country='Swal',
           CompanyName = 'TEST',
           Title = 'title',
           Alias = 'alias',
           TimeZoneSidKey = 'America/Los_Angeles',
           EmailEncodingKey = 'UTF-8',
           LanguageLocaleKey = 'en_US',
           LocaleSidKey = 'en_US',
           isActive = true,
            Show_Inventory__c = true,
            MobilePhone = '8888888888'
           //  UserRoleId =  ur2.Id
       );  
       insert u2;
       // UserRole ur3 = new UserRole(Name = 'SBU Head India 1');
       // insert ur3;
       User u3 = new User(
           ProfileId = [SELECT Id FROM Profile WHERE Name = 'Sales Head Pune' OR Name = 'SBU Profile'].Id,
           LastName = 'last',
           Email = 'puser003@amamama.com',
           Username = 'puser0003@amamama.com' + System.currentTimeMillis(),
           Country='India',
           CompanyName = 'TEST',
           Title = 'title',
           Alias = 'alias',
           TimeZoneSidKey = 'America/Los_Angeles',
           EmailEncodingKey = 'UTF-8',
           LanguageLocaleKey = 'en_US',
           LocaleSidKey = 'en_US',
           isActive = true,
           Show_Inventory__c = true,
           MobilePhone = '8888888888'
           // UserRoleId =  ur3.Id
       );  
       insert u3;
       
       // UserRole ur4 = new UserRole(Name = 'Zonal Commercial Executive Pune');
       // insert ur4;
       User u4 = new User(
           ProfileId = [SELECT Id FROM Profile WHERE Name = 'Zonal Marketing Manager' OR Name = 'SBU Profile'].Id,
           LastName = 'last',
           Email = 'puser004@amamama.com',
           Username = 'puser0004@amamama.com' + System.currentTimeMillis(),
           Country='India',
           CompanyName = 'TEST',
           Title = 'title',
           Alias = 'alias',
           TimeZoneSidKey = 'America/Los_Angeles',
           EmailEncodingKey = 'UTF-8',
           LanguageLocaleKey = 'en_US',
           LocaleSidKey = 'en_US',
           isActive = true,
           Show_Inventory__c = true,
           MobilePhone = '8888888888'
           //UserRoleId =  ur4.Id
       );  
       insert u4;
        
        Depot__c depo=new Depot__c();
        depo.Name='depo1';
        depo.Depot_Code__c='pc01';
        insert depo;
        
        
        
        SBU__c SBUObj = new SBU__c(
           SBUUser__c = u3.Id, // SBU User
           SBUCode__c = 'SBU2',              // SBU Code
           SalesOrg__c = salesOrgObj.id  // Sales Org
       );
       insert SBUObj;
        
         Zone__c zoneObj = new Zone__c(
           Name = 'Indore',                 // Zone Name
           SalesOrg__c = salesOrgObj.Id,   // Sales Org
           ZoneCode__c = 'Z16',               // Zone Code
           ZonalHead__c = u2.Id,  // Zonal Head
           ZMMUser__c = u4.Id,
           SBUCode__c = SBUObj.Id    // SBU Code
       );
       insert zoneObj;
        
        Zone_Depot_Mapping__c zdm=new Zone_Depot_Mapping__c();
       	zdm.Depot__c=depo.id;
        zdm.SBU__c=SBUObj.Id;
        zdm.Sales_Org__c=salesOrgObj.Id;
        zdm.Name='testZdm';
        zdm.Zone__c=zoneObj.id;
        insert zdm;
        
        TM_Depot_Mapping__c tdm=new TM_Depot_Mapping__c();
        tdm.Depot__c=depo.Id;
        insert tdm;
        
        
        /*
            insert Live Chat Visitor
        */
        LiveChatVisitor lcv = new LiveChatVisitor();
        try{
            insert lcv;
        }catch(Exception e){}
        /*
            insert Live Chat Transcript
        */
        LiveChatTranscript lct = new LiveChatTranscript();
        lct.LiveChatVisitorid = lcv.id;
    	lct.Loggedin_User__c =u.Id;
        lct.ChatKey ='abcd';
        try{
            insert lct;
        }catch(Exception e){}
        system.debug('lct' + lct);
                /*
            insert Live Chat Transcript Event
        */
        LiveChatTranscriptEvent le = new LiveChatTranscriptEvent();
        le.LiveChatTranscriptId = lct.id;
        le.type = 'ChatRequest';
        le.time = system.now();
        try{
            insert le;
        }
        catch(Exception e){}
        try{
            delete le;
        }
        catch(Exception e){}
        
        Bot_GetSnapInsPreChatData.DepotInformation tmDepoMapRec1=new Bot_GetSnapInsPreChatData.DepotInformation();
        tmDepoMapRec1.depotName ='Test';
        tmDepoMapRec1.depotCode ='pc01';
        
        ChatBot_GetInventoryData.PrechatInput inputParam=new ChatBot_GetInventoryData.PrechatInput();
        List<ChatBot_GetInventoryData.PrechatInput> inputParams=new List<ChatBot_GetInventoryData.PrechatInput>();
        inputParam.sBrandName='testBrand';
        inputParam.tmDepoMapRec=tmDepoMapRec1;
        inputParam.chatkey='abcd';
        inputParams.add(inputParam);
        
        
        ChatBot_GetInventoryData.getBrandData(inputParams);
    }
    
    public static testmethod void chatbot_InventoryData_Test5(){
        ZUDL_ZUIC_C03_Q001__x externalObj=new ZUDL_ZUIC_C03_Q001__x();
        externalObj.BRAND__c='testBrand';
        externalObj.COMP_CODE__c='100';
        externalObj.PLANT_CODE__c='pc01';
        externalObj.COMP_DESC__c='testCompDesc';
        externalObj.QTY__c=10;
        externalObj.UOM__c='kg';
        externalObj.PLANT_DESC__c='testPlantDesc';
        //insert externalObj;
        
        Sales_Org__c salesOrgObj = new Sales_Org__c(
           Name = 'UK',            // Sales Org Name
           Description__c = 'UK',    // Description
           Company_Code__c = '2031',    // Company Code
           Sales_Org_Code__c = '2031'  // Sales Org Code
       );
        insert salesOrgObj;
        
        User u = new User(
           ProfileId = [SELECT Id FROM Profile WHERE Name = 'Territory Manager'].Id,
           
           LastName = 'last',
           Email = 'puser000@amamama.com',
           Username = 'puser000@amamama.com' + System.currentTimeMillis(),
           Country='UK',
           CompanyName = 'TEST',
           Title = 'title',
           Alias = 'alias',
           TimeZoneSidKey = 'America/Los_Angeles',
           EmailEncodingKey = 'UTF-8',
           LanguageLocaleKey = 'en_US',
           LocaleSidKey = 'en_US',
           isActive = true,
           Show_Inventory__c = true
            
           //  UserRoleId =  ur.Id
       );  
       insert u;
        
        User u2 = new User(
           ProfileId = [SELECT Id FROM Profile WHERE Name = 'Regional/Zonal Managers'].Id,
           
           LastName = 'last',
           Email = 'puser0002@amamama.com',
           Username = 'puser0002@amamama.com' + System.currentTimeMillis(),
           Country='Swal',
           CompanyName = 'TEST',
           Title = 'title',
           Alias = 'alias',
           TimeZoneSidKey = 'America/Los_Angeles',
           EmailEncodingKey = 'UTF-8',
           LanguageLocaleKey = 'en_US',
           LocaleSidKey = 'en_US',
           isActive = true,
            Show_Inventory__c = true,
            MobilePhone = '8888888888'
           //  UserRoleId =  ur2.Id
       );  
       insert u2;
       // UserRole ur3 = new UserRole(Name = 'SBU Head India 1');
       // insert ur3;
       User u3 = new User(
           ProfileId = [SELECT Id FROM Profile WHERE Name = 'Sales Head Pune' OR Name = 'SBU Profile'].Id,
           LastName = 'last',
           Email = 'puser003@amamama.com',
           Username = 'puser0003@amamama.com' + System.currentTimeMillis(),
           Country='India',
           CompanyName = 'TEST',
           Title = 'title',
           Alias = 'alias',
           TimeZoneSidKey = 'America/Los_Angeles',
           EmailEncodingKey = 'UTF-8',
           LanguageLocaleKey = 'en_US',
           LocaleSidKey = 'en_US',
           isActive = true,
           Show_Inventory__c = true,
           MobilePhone = '8888888888'
           // UserRoleId =  ur3.Id
       );  
       insert u3;
       
       // UserRole ur4 = new UserRole(Name = 'Zonal Commercial Executive Pune');
       // insert ur4;
       User u4 = new User(
           ProfileId = [SELECT Id FROM Profile WHERE Name = 'Zonal Marketing Manager' OR Name = 'SBU Profile'].Id,
           LastName = 'last',
           Email = 'puser004@amamama.com',
           Username = 'puser0004@amamama.com' + System.currentTimeMillis(),
           Country='India',
           CompanyName = 'TEST',
           Title = 'title',
           Alias = 'alias',
           TimeZoneSidKey = 'America/Los_Angeles',
           EmailEncodingKey = 'UTF-8',
           LanguageLocaleKey = 'en_US',
           LocaleSidKey = 'en_US',
           isActive = true,
           Show_Inventory__c = true,
           MobilePhone = '8888888888'
           //UserRoleId =  ur4.Id
       );  
       insert u4;
        
        Depot__c depo=new Depot__c();
        depo.Name='depo1';
        depo.Depot_Code__c='pc01';
        insert depo;
        
        
        
        SBU__c SBUObj = new SBU__c(
           SBUUser__c = u3.Id, // SBU User
           SBUCode__c = 'SBU2',              // SBU Code
           SalesOrg__c = salesOrgObj.id  // Sales Org
       );
       insert SBUObj;
        
         Zone__c zoneObj = new Zone__c(
           Name = 'Indore',                 // Zone Name
           SalesOrg__c = salesOrgObj.Id,   // Sales Org
           ZoneCode__c = 'Z16',               // Zone Code
           ZonalHead__c = u2.Id,  // Zonal Head
           ZMMUser__c = u4.Id,
           SBUCode__c = SBUObj.Id    // SBU Code
       );
       insert zoneObj;
        
        Zone_Depot_Mapping__c zdm=new Zone_Depot_Mapping__c();
       	zdm.Depot__c=depo.id;
        zdm.SBU__c=SBUObj.Id;
        zdm.Sales_Org__c=salesOrgObj.Id;
        zdm.Name='testZdm';
        zdm.Zone__c=zoneObj.id;
        insert zdm;
        
        TM_Depot_Mapping__c tdm=new TM_Depot_Mapping__c();
        tdm.Depot__c=depo.Id;
        insert tdm;
        
        
        /*
            insert Live Chat Visitor
        */
        LiveChatVisitor lcv = new LiveChatVisitor();
        try{
            insert lcv;
        }catch(Exception e){}
        /*
            insert Live Chat Transcript
        */
        LiveChatTranscript lct = new LiveChatTranscript();
        lct.LiveChatVisitorid = lcv.id;
    	lct.Loggedin_User__c =u.Id;
        lct.ChatKey ='abcd';
        try{
            insert lct;
        }catch(Exception e){}
        system.debug('lct' + lct);
                /*
            insert Live Chat Transcript Event
        */
        LiveChatTranscriptEvent le = new LiveChatTranscriptEvent();
        le.LiveChatTranscriptId = lct.id;
        le.type = 'ChatRequest';
        le.time = system.now();
        try{
            insert le;
        }
        catch(Exception e){}
        try{
            delete le;
        }
        catch(Exception e){}
        
        Bot_GetSnapInsPreChatData.DepotInformation tmDepoMapRec1=new Bot_GetSnapInsPreChatData.DepotInformation();
        tmDepoMapRec1.depotName ='Test';
        tmDepoMapRec1.depotCode ='pc01';
        
        ChatBot_GetInventoryData.PrechatInput inputParam=new ChatBot_GetInventoryData.PrechatInput();
        List<ChatBot_GetInventoryData.PrechatInput> inputParams=new List<ChatBot_GetInventoryData.PrechatInput>();
        inputParam.sBrandName='testBrand';
        inputParam.tmDepoMapRec=tmDepoMapRec1;
        inputParam.chatkey='abcd';
        inputParams.add(inputParam);
        
        
        ChatBot_GetInventoryData.getBrandData(inputParams);
    }
}