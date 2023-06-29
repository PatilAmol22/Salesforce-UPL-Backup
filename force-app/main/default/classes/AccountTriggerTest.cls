@isTest
public class AccountTriggerTest {
    
	static testMethod void method(){
        
        Test.startTest();
        
        Price_Group_Master__c pgObj = new Price_Group_Master__c ();
        pgObj.PG_Code__c='001';
        insert pgObj;

        Sales_Org__c sOrg = new Sales_Org__c(
            Name = 'India',            // Sales Org Name
            Description__c = 'India',    // Description
            Sales_Org_Code__c = '1410'//'1000' //uplsetting.India_SAS_Sales_Org__c  // Sales Org Code
        );
        insert sOrg;
        
        //new insertions:
        Product2 pro = new Product2();
        pro.ProductCode = '66700';
        pro.Product_Code__c='66700';
        pro.Name='DOST';
        pro.popular__c = true;
        pro.Combination_Key__c='RM0065100';
        Insert Pro;
        
        SKU__c sku = new SKU__c();
        sku.Name='P1';
        sku.SKU_Code__c='704002';
        sku.SKU_Pack__c=1.00;
        sku.SKU_UOM__c='L';
        sku.Multiple_Of__c=5;
        sku.Group__c='DOST';
        sku.Special_SKU__c = true;
        sku.Pack_Size__c=10.00;
        sku.Product_Name__c=pro.Id;
        sku.Sales_Org__c = sOrg.Id;
        sku.UOM__c='L';
        sku.Brand_Name__c='My brand Name';
        sku.Active__c=True;
        sku.Combination_Key__c='Cooooooo000011111';
        insert sku;
        
        Payment_Term__c paymenTermObj = new Payment_Term__c(
            Payment_Term__c = 'NET 75 Days',  
            Payment_Term_Code__c = 'UK38',     
            Maturity_Date_Mandatory__c = 'No', 
            Sales_Org__c = sOrg.Id,   // Sales Org
            Payterms_Desc__c = 'NET 75 Days',  
            Active__c = true,                 
            CombinationKey__c = '5100UK38'     
        );
        insert paymenTermObj;
        
        Depot__c dpObj = new Depot__c ();
        dpObj.Name = 'Pune';
        dpObj.Country__c = 'India';
        dpObj.Location__c='Pune';
        dpObj.Depot_Code__c = 'PUN';
        dpObj.RecordTypeId = Schema.SObjectType.Depot__c.getRecordTypeInfosByName().get('Depot').getRecordTypeId();
        dpObj.Active__c = true; //refactored
        dpObj.SalesOrg__c = sOrg.ID; //refactored
        dpObj.Segment_Name__c = 'Sales Team'; //refactored
        insert dpObj;
        
        Order_Type__c ordType =new Order_Type__c();
        ordType.Name = 'ZORD';
        ordType.Description__c = 'India';    
        ordType.Order_Type_Code__c = 'ZORD';
        insert ordType;
        //Stop: new insertions
        
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Territory Manager' LIMIT 1];
        
        User usr1 = new User(
           // UserRole = 'undefined',
            firstname = 'Vikas',                                // Role
            lastName = 'Chavan', 
            Alias = 'vchavn',                                                                   // Alias
            Email = 'shama.buchade@skinternational.com',                                       // Email
            ProfileId = profileId.Id,                                                             // Profile
            Username = 'vc@uniphos.com.upltest',                                         // Username
            IsActive = true,                                                                   // Active
            CommunityNickname = 'vikas.chavannn',  // Nickname
            TimeZoneSidKey = 'Asia/Kolkata',                 // Time Zone
            LocaleSidKey = 'en_US',                                                  // Locale
            LanguageLocaleKey = 'en_US',                                                     // Language
            ForecastEnabled = false,                                                           // Allow Forecasting
            Phone = '7722034447',                                                    // Phone
            EmailEncodingKey = 'ISO-8859-1',        // Email Encoding
           // TM_Code__c = '01205184',                                                           // TM Code
            //SAP_User_Password__c = 'init123',                                                  // SAP User Password
            Zone__c = 'Pune',                                                                  // Zone
            //EnableDepot__c = true,                                                             // Enable Depot
            Show_List_Value__c = false,                                                        // Show List Value (Brazil)
            Show_Credit_Limit__c = true,                                                       // Show Credit Limit
            Show_Inventory__c = true,                                                          // Show Inventory
            Show_Pricing__c = false,                                                           // Show Pricing
            Show_Inventory_Column__c = true,                                                   // Show Inventory Column
            Show_InTransit__c = false,                                                         // Show InTransit
            Show_InTransit_Values__c = false                                                  // Show InTransit Values
        );
        insert usr1;
        
        Division__c divObj = new Division__c();
        divObj.Name = 'Fertilizer Division';
        divObj.Division_Code__c = '10';
        insert divObj;
        
        Pin_Code__c pCode = new Pin_Code__c();
        pCode.Name = '400014';
        pCode.District__c = 'Mumbai';
        insert pCode;
        
        State_Tax_Structure__c sTax = new State_Tax_Structure__c();
        sTax.State_Name__c = 'Maharashtra';
        sTax.State_Code__c = '13';
        sTax.GST_State_Code__c = '27';
        sTax.SalesOrg__c = sOrg.Id;
        insert sTax;
        
        Account acc = new Account();
        acc.Name = 'Test Account Distributer';
        acc.Last_Name__c = 'Distributer';
        acc.SAP_Code__c = 'SAP996734';
        acc.RecordTypeId = UPLConstantClass.distributorRecordTypeId;
        acc.Mobile__c = '9967341759';
        acc.Phone = '020256589';
        acc.Sales_Org__c = sOrg.Id;
        acc.BillingCity = 'Pune';
        acc.Order_Type__c = ordType.Id;
        acc.Depot_Code__c = dpObj.Id;  //'PUN1';
        acc.OwnerId = usr1.id;
        insert acc;
        
        Distributor_Depot_Mapping__c dsMap =new Distributor_Depot_Mapping__c();
        dsMap.Distributor__c = acc.id;
        dsMap.Depot__c=dpObj.Id;
        insert dsMap;
        
        TM_Depot_Mapping__c TMDepoMap = new TM_Depot_Mapping__c();
        TMDepoMap.Depot__c = dpObj.Id;        // Depot
        TMDepoMap.Territory_Manager__c = usr1.id;  // Territory Manager
        insert TMDepoMap;
        
        Test.stopTest();
        
    }
    
    //Added by Kuhinoor
    public static testMethod void unit1(){
        
        Test.startTest();
        Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Farmer').getRecordTypeId();
        Id RecordTypeId2 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('F3/C3/Sales Team').getRecordTypeId();
        State__c st = new State__c(Name = 'Assam');
        insert st;
        
        District__c ds = new District__c(Name = 'Cacher', State__c= st.Id);
        insert ds;
        
        Tehsil__c ts = new Tehsil__c(Name = 'Cacher', District__c= ds.Id);
        insert ts;
        
        Village__c vill = new Village__c(Name = 'DidarKush', Tehsil__c= ts.Id, Postal_Code__c ='788099'); 
        insert vill;
        
        List<Account> accList = new List<Account>();
        Account acc = new Account(LastName = 'TestAcc', VillageName__c = 'DidarKush',
                                  District__c = 'Cacher', StateName__c ='Assam',
                                  PersonMobilePhone = '1234567890' ,recordTypeId = RecordTypeId);
        accList.add(acc);
        Account acc2 = new Account(Name = 'TestAcc',Village__c =vill.Id, recordTypeId = RecordTypeId2,
                                  VillageName__c = 'DidarKush');
        accList.add(acc2);
        insert accList;
        
        system.assertEquals(accList[0].LastName, 'TestAcc');
        
        Test.stopTest();
    }
    
    
    
        //Added by Kuhinoor
/*    public static testMethod void unit2(){
      
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Territory Manager' LIMIT 1];
        
        User usr1 = new User(
           // UserRole = 'undefined',
            firstname = 'Vikas',                                // Role
            lastName = 'Chavan', 
            Alias = 'vchavn',                                                                   // Alias
            Email = 'shama.buchade@skinternational.com',                                       // Email
            ProfileId = profileId.Id,                                                             // Profile
            Username = 'vc@uniphos.com.upltest',                                         // Username
            IsActive = true,                                                                   // Active
            CommunityNickname = 'vikas.chavannn',  // Nickname
            TimeZoneSidKey = 'Asia/Kolkata',                 // Time Zone
            LocaleSidKey = 'en_US',                                                  // Locale
            LanguageLocaleKey = 'en_US',                                                     // Language
            ForecastEnabled = false,                                                           // Allow Forecasting
            Phone = '7722034447',                                                    // Phone
            EmailEncodingKey = 'ISO-8859-1',        // Email Encoding
           // TM_Code__c = '01205184',                                                           // TM Code
            //SAP_User_Password__c = 'init123',                                                  // SAP User Password
            Zone__c = 'Pune',                                                                  // Zone
            //EnableDepot__c = true,                                                             // Enable Depot
            Show_List_Value__c = false,                                                        // Show List Value (Brazil)
            Show_Credit_Limit__c = true,                                                       // Show Credit Limit
            Show_Inventory__c = true,                                                          // Show Inventory
            Show_Pricing__c = false,                                                           // Show Pricing
            Show_Inventory_Column__c = true,                                                   // Show Inventory Column
            Show_InTransit__c = false,                                                         // Show InTransit
            Show_InTransit_Values__c = false                                                  // Show InTransit Values
        );
        insert usr1;
        
        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Quality - Farmer').getRecordTypeId();
        Id recordTypeId2 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('France Farmer').getRecordTypeId();//Europe Farmer Account  //France Farmer
        Id recordTypeId3 = Schema.SObjectType.Sales_District__c.getRecordTypeInfosByName().get('EST').getRecordTypeId();//Europe Farmer Account  //France Farmer
        System.debug('recordTypeId2 ' + recordTypeId2)
        //System.runAs(usr1){
        	
            //Sales_District__c salObj = new Sales_District__c();
        	//salObj.Name = 'Kvp';
        	//salObj.Sales_District_Code__c = '004';
            //salObj.SalesOrg__c = recordTypeId3;
        	//insert salObj;
        
        	Account accObj3 = new Account();
        	accObj3.RecordTypeId = recordTypeId2;
            	accObj3.FirstName = 'KVP';
        		accObj3.LastName = 'KVP Test';
                accObj3.Farm_Name__c = 'test';
                accObj3.Email__c = 'kvp@gmail.com';
                accObj3.Mobile__c = '9999999999';
                //accObj3.Sales_District__c = salObj.id;
                accObj3.Sales_District__c = recordTypeId3;
            	accObj3.BillingPostalCode = '456789';
            	accObj3.Pin_Code__c = '14480';
                accObj3.District__c= 'NeoFog';
                insert accObj3;
            
            Case casObj = new Case();
            casObj.RecordTypeId = recordTypeId;
                casObj.Entity__c='UPL France';
                casObj.Date__c = Date.today();
                casObj.Case_Type__c = 'Quantité [Q]';
                casObj.Status = 'Open';
                casObj.Productname__c = 'Test';
                casObj.Order_number__c = '2';
                casObj.Batch_no__c = '2';
                casObj.Packaging__c = '2';
                casObj.Delivered_quantity__c = '2';
                casObj.Quantity_incriminated__c = '2';
                casObj.Sample_taken__c = 'OUI';
                casObj.Storagewith_the_carrier__c = 'OUI';
                casObj.Compensation_requested__c = 'OUI';
                casObj.Technical_visit_requested__c = 'OUI';
                casObj.Product_exchange_requested__c = 'OUI';
                casObj.Product_return_requested__c = 'OUI';
                casObj.Detailed_description_of_the_complaint__c = 'Test Data';
                casObj.Farmer_Account__c = accObj3.id;
                //casObj.AccountId = accObj3.id;
                insert casObj; 
        
        	accObj3.LastName = 'Kvp';
            update accObj3;

        }
    } */    
    
}