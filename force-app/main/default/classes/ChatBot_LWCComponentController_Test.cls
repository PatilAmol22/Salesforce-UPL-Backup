@isTest
public class ChatBot_LWCComponentController_Test {
    public static testmethod void chatbot_Lwc_Test(){
        	
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
           Show_Inventory__c = true
            
           //  UserRoleId =  ur.Id
       );  
       insert u;
        User u2 = new User(
           ProfileId = [SELECT Id FROM Profile WHERE Name = 'Regional/Zonal Managers'].Id,
           
           LastName = 'last',
            FirstName ='first',
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
            Show_Inventory__c = true
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
           Country='australia',
           CompanyName = 'TEST',
           Title = 'title',
           Alias = 'alias',
           TimeZoneSidKey = 'America/Los_Angeles',
           EmailEncodingKey = 'UTF-8',
           LanguageLocaleKey = 'en_US',
           LocaleSidKey = 'en_US',
           isActive = true,
           Show_Inventory__c = true
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
           SBUCode__c = SBUObj.Id  // SBU Code
           
       );
       insert zoneObj;
        
       Region__c regionObj = new Region__c(
           Name = 'TRIANGULO',                  // Region Name
           RegionCode__c = 'BR4003',              // Region Code
           SalesOrg__c =salesOrgObj.id,       // Sales Org
           RegionHead__c = u2.id,     // Region Head
           Zone__c = zoneObj.id
       );
       insert regionObj;
        
        Depot__c depo=new Depot__c();
        depo.Name='depo1';
        depo.Depot_Code__c='d0123';
        insert depo;
        
       Sales_Org__c salesOrgObj1 = new Sales_Org__c(
           Name = 'Swal',            // Sales Org Name
           Description__c = 'Swal',    // Description
           Company_Code__c = '1210',    // Company Code
           Sales_Org_Code__c = '1210'  // Sales Org Code
       );
        insert salesOrgObj1;
        
        
        
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
        
        Territory_Distributor__c territoryObj1 = new Territory_Distributor__c();
       territoryObj1.Name = 'Narayangaon1';
       territoryObj1.TerritoryCode__c = '399';
       territoryObj1.SalesOrg__c = salesOrgObj1.id;
       territoryObj1.Region__c = regionObj.id;
       //territoryObj1.TerritoryManager__c = u2.Id;
       territoryObj1.Zone__c = zoneObj.id;
       territoryObj1.SBU__c = SBUObj.Id;
       territoryObj1.Present_in_KEDE__c = true ;
       territoryObj1.Neglected__c = false;
       
       insert territoryObj1;
        
         Zone_Depot_Mapping__c zdm=new Zone_Depot_Mapping__c();
       	zdm.Depot__c=depo.id;
        zdm.SBU__c=SBUObj.Id;
        zdm.Sales_Org__c=salesOrgObj.Id;
        zdm.Name='testZdm';
        zdm.Zone__c=zoneObj.id;
        insert zdm;
       
        
        TM_Depot_Mapping__c tdm=new TM_Depot_Mapping__c(); 
            tdm.Territory_Manager__c=u.id;
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
         Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        
          Account acc = new Account();
        acc.Name='Nikhil';
        acc.Last_Name__c='Dhoke';
        //acc.PriceGroupCode__c=pg.id;
        acc.SAP_Code__c='SAP996734';
        acc.RecordTypeId=devRecordTypeId;
        acc.Mobile__c='8600000000';
        acc.Phone='020200000';
        acc.Sales_Org__c=salesOrgObj.Id;
        //acc.Division__c=Divbj.Id;
        //acc.Distribution_Channel__c=disbj.Id;
        acc.BillingCity='Mumbai';
        //acc.Order_Type__c=ordType.Id;
        acc.Depot_Code__c = 'PUN1';
        //acc.Payment_Term_Code__c=payment_term.id;
        
        //  acc.OwnerId=sobj.Id;
        insert acc;
        
        Sales_Order__c so=new Sales_Order__c();
        	//so.Name='TestName';
        	so.Sales_Org_lk__c= salesOrgObj.id;
            so.Sold_to_Party__c = acc.id;
        	so.Order_Date__c=Date.newInstance(2020, 7, 31);
            so.SAP_Order_Number__c='123456';
            so.Order_Status__c='Partially processed';
            //so.CurrencyIsoCode='INR';
        	//so.Sold_to_Party__c=acnt.Id;
        	so.Total_Amount__c=100.00;
            //so.Final_Total_Amont__c=100.00;
            insert so;
        
        //Test.startTest();
        ChatBot_LWCComponentController.getOrderStatus('123456');
        ChatBot_LWCComponentController.getCustomerOrderDetails('123456');
        ChatBot_LWCComponentController.getInventoryDetails('Brand-Name', 'abcd');
        
        
        //Test.stopTest();
        /*
            insert Live Chat Visitor
        */
        LiveChatVisitor lcv1 = new LiveChatVisitor();
        try{
            insert lcv1;
        }catch(Exception e){}
        /*
            insert Live Chat Transcript
        */
        LiveChatTranscript lct1 = new LiveChatTranscript();
        lct1.LiveChatVisitorid = lcv1.id;
    	lct1.Loggedin_User__c =u2.Id;
        lct1.ChatKey ='abcd';
        try{
            insert lct1;
        }catch(Exception e){}
        system.debug('lct' + lct1);
                /*
            insert Live Chat Transcript Event
        */
        LiveChatTranscriptEvent le1 = new LiveChatTranscriptEvent();
        le1.LiveChatTranscriptId = lct1.id;
        le1.type = 'ChatRequest';
        le1.time = system.now();
        try{
            insert le1;
        }
        catch(Exception e){}
        try{
            delete le1;
        }
        catch(Exception e){}
        
        ChatBot_LWCComponentController.getOrderStatus('123456');
        ChatBot_LWCComponentController.getCustomerOrderDetails('123456');
        ChatBot_LWCComponentController.getInventoryDetails('Brand-Name', 'abcd');
        /*
            insert Live Chat Visitor
        */
        LiveChatVisitor lcv2 = new LiveChatVisitor();
        try{
            insert lcv2;
        }catch(Exception e){}
        /*
            insert Live Chat Transcript
        */
        LiveChatTranscript lct2 = new LiveChatTranscript();
        lct2.LiveChatVisitorid = lcv2.id;
    	lct2.Loggedin_User__c =u3.Id;
        lct2.ChatKey ='abcd';
        try{
            insert lct2;
        }catch(Exception e){}
        system.debug('lct' + lct2);
                /*
            insert Live Chat Transcript Event
        */
        LiveChatTranscriptEvent le2 = new LiveChatTranscriptEvent();
        le2.LiveChatTranscriptId = lct2.id;
        le2.type = 'ChatRequest';
        le2.time = system.now();
        try{
            insert le2;
        }
        catch(Exception e){}
        try{
            delete le2;
        }
        catch(Exception e){}
        
        ChatBot_LWCComponentController.getOrderStatus('123456');
        ChatBot_LWCComponentController.getCustomerOrderDetails('123456');
        ChatBot_LWCComponentController.getInventoryDetails('Brand-Name', 'abcd');
    
		/*
            insert Live Chat Visitor
        */
        LiveChatVisitor lcv3 = new LiveChatVisitor();
        try{
            insert lcv3;
        }catch(Exception e){}
        /*
            insert Live Chat Transcript
        */
        LiveChatTranscript lct3 = new LiveChatTranscript();
        lct3.LiveChatVisitorid = lcv3.id;
    	lct3.Loggedin_User__c =u4.Id;
        lct3.ChatKey ='abcd';
        try{
            insert lct3;
        }catch(Exception e){}
        system.debug('lct' + lct3);
                /*
            insert Live Chat Transcript Event
        */
        LiveChatTranscriptEvent le3 = new LiveChatTranscriptEvent();
        le3.LiveChatTranscriptId = lct3.id;
        le3.type = 'ChatRequest';
        le3.time = system.now();
        try{
            insert le3;
        }
        catch(Exception e){}
        try{
            delete le3;
        }
        catch(Exception e){}
        
        ChatBot_LWCComponentController.getOrderStatus('123456');
        ChatBot_LWCComponentController.getCustomerOrderDetails('123456');
        ChatBot_LWCComponentController.getInventoryDetails('Brand-Name', 'abcd');
    
    }
    public static testmethod void chatbot_PreChatData_Test1(){
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
            Show_Inventory__c = true
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
           Show_Inventory__c = true
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
        ChatBot_LWCComponentController.getOrderStatus('123456');
        ChatBot_LWCComponentController.getCustomerOrderDetails('123456');
        ChatBot_LWCComponentController.getInventoryDetails('Brand-Name', 'abcd');
    
       
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
            Show_Inventory__c = true
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
           Show_Inventory__c = true
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
        Sales_Org__c salesOrgObj2 = new Sales_Org__c(
           Name = 'Australia',            // Sales Org Name
           Description__c = 'Australia',    // Description
           Company_Code__c = '6100',    // Company Code
           Sales_Org_Code__c = '6100'  // Sales Org Code
       );
       insert salesOrgObj2;
        Zone_Depot_Mapping__c zdm1=new Zone_Depot_Mapping__c();
       	zdm1.Depot__c=depo.id;
        zdm1.SBU__c=SBUObj.Id;
        zdm1.Sales_Org__c=salesOrgObj2.Id;
        zdm1.Name='testZdm';
        zdm1.Zone__c=zoneObj.id;
        insert zdm1;
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
    	lct.Loggedin_User__c =u3.Id;
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
        
        //ChatBot_LWCComponentController.BrandDetailWrapper bw = new ChatBot_LWCComponentController.BrandDetailWrapper();
     ChatBot_LWCComponentController.getOrderStatus('123456');
        ChatBot_LWCComponentController.getCustomerOrderDetails('123456');
        ChatBot_LWCComponentController.getInventoryDetails('Brand-Name', 'abcd');
    
    }
    
    public static testmethod void chatbot_PreChatData_Test3(){
       
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
            Show_Inventory__c = true
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
           Show_Inventory__c = true
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
        Sales_Org__c salesOrgObj2 = new Sales_Org__c(
           Name = 'Australia',            // Sales Org Name
           Description__c = 'Australia',    // Description
           Company_Code__c = '6100',    // Company Code
           Sales_Org_Code__c = '6100'  // Sales Org Code
       );
       insert salesOrgObj2;
        Sales_Org__c salesOrgObj3 = new Sales_Org__c(
           Name = 'Indonesia',            // Sales Org Name
           Description__c = 'Indonesia',    // Description
           Company_Code__c = '6410',    // Company Code
           Sales_Org_Code__c = '6410'  // Sales Org Code
       );
       insert salesOrgObj3;
        
        Zone_Depot_Mapping__c zdm1=new Zone_Depot_Mapping__c();
       	zdm1.Depot__c=depo.id;
        zdm1.SBU__c=SBUObj.Id;
        zdm1.Sales_Org__c=salesOrgObj2.Id;
        zdm1.Name='testZdm';
        zdm1.Zone__c=zoneObj.id;
        insert zdm1;
        
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
    	lct.Loggedin_User__c =u3.Id;
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
        
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        
        Account acc = new Account();
        acc.Name='Nikhil';
        acc.Last_Name__c='Dhoke';
        //acc.PriceGroupCode__c=pg.id;
        acc.SAP_Code__c='SAP996734';
        acc.RecordTypeId=devRecordTypeId;
        acc.Mobile__c='8600000000';
        acc.Phone='020200000';
        acc.Sales_Org__c=salesOrgObj.Id;
        //acc.Division__c=Divbj.Id;
        //acc.Distribution_Channel__c=disbj.Id;
        acc.BillingCity='Mumbai';
        //acc.Order_Type__c=ordType.Id;
        acc.Depot_Code__c = 'PUN1';
        //acc.Payment_Term_Code__c=payment_term.id;
        
        //  acc.OwnerId=sobj.Id;
        insert acc;
        
        Sales_Order__c so=new Sales_Order__c();
        	//so.Name='TestName';
        	so.Sales_Org_lk__c= salesOrgObj3.id;
            so.Sold_to_Party__c = acc.id;
        	so.Order_Date__c=Date.newInstance(2020, 7, 31);
            so.SAP_Order_Number__c='123456';
            so.Order_Status__c='Partially processed';
            //so.CurrencyIsoCode='INR';
        	//so.Sold_to_Party__c=acnt.Id;
        	so.Total_Amount__c=100.00;
            //so.Final_Total_Amont__c=100.00;
            insert so;
        //ChatBot_LWCComponentController.BrandDetailWrapper bw = new ChatBot_LWCComponentController.BrandDetailWrapper();
     ChatBot_LWCComponentController.getOrderStatus('123456');
        ChatBot_LWCComponentController.getCustomerOrderDetails('123456');
        ChatBot_LWCComponentController.getInventoryDetails('Brand-ALL', 'abcd');
    
    }
    public static testmethod void chatbot_PreChatData_Test4(){
       
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
            Show_Inventory__c = true
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
           Show_Inventory__c = true
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
        Sales_Org__c salesOrgObj2 = new Sales_Org__c(
           Name = 'Australia',            // Sales Org Name
           Description__c = 'Australia',    // Description
           Company_Code__c = '6100',    // Company Code
           Sales_Org_Code__c = '6100'  // Sales Org Code
       );
       insert salesOrgObj2;
        Sales_Org__c salesOrgObj3 = new Sales_Org__c(
           Name = 'Indonesia',            // Sales Org Name
           Description__c = 'Indonesia',    // Description
           Company_Code__c = '6410',    // Company Code
           Sales_Org_Code__c = '6410'  // Sales Org Code
       );
       insert salesOrgObj3;
        
        Zone_Depot_Mapping__c zdm1=new Zone_Depot_Mapping__c();
       	zdm1.Depot__c=depo.id;
        zdm1.SBU__c=SBUObj.Id;
        zdm1.Sales_Org__c=salesOrgObj3.Id;
        zdm1.Name='testZdm';
        zdm1.Zone__c=zoneObj.id;
        insert zdm1;
        
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
    	lct.Loggedin_User__c =u3.Id;
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
        
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        
        Account acc = new Account();
        acc.Name='Nikhil';
        acc.Last_Name__c='Dhoke';
        //acc.PriceGroupCode__c=pg.id;
        acc.SAP_Code__c='SAP996734';
        acc.RecordTypeId=devRecordTypeId;
        acc.Mobile__c='8600000000';
        acc.Phone='020200000';
        acc.Sales_Org__c=salesOrgObj.Id;
        //acc.Division__c=Divbj.Id;
        //acc.Distribution_Channel__c=disbj.Id;
        acc.BillingCity='Mumbai';
        //acc.Order_Type__c=ordType.Id;
        acc.Depot_Code__c = 'PUN1';
        //acc.Payment_Term_Code__c=payment_term.id;
        
        //  acc.OwnerId=sobj.Id;
        insert acc;
        
        Sales_Order__c so=new Sales_Order__c();
        	//so.Name='TestName';
        	so.Sales_Org_lk__c= salesOrgObj3.id;
            so.Sold_to_Party__c = acc.id;
        	so.Order_Date__c=Date.newInstance(2020, 7, 31);
            so.SAP_Order_Number__c='123456';
            so.Order_Status__c='Partially processed';
            //so.CurrencyIsoCode='INR';
        	//so.Sold_to_Party__c=acnt.Id;
        	so.Total_Amount__c=100.00;
            //so.Final_Total_Amont__c=100.00;
            insert so;
        //ChatBot_LWCComponentController.BrandDetailWrapper bw = new ChatBot_LWCComponentController.BrandDetailWrapper();
     ChatBot_LWCComponentController.getOrderStatus('123456');
        ChatBot_LWCComponentController.getCustomerOrderDetails('123456');
        ChatBot_LWCComponentController.getInventoryDetails('Brand-ALL', 'abcd');
    
    }
    
}