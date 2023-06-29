@isTest
public class ZoneTerrFarmerRegistrationExtensionsTest{
   /* static testmethod void casetest(){
        Sales_Org__c sorg =new Sales_Org__c();
        sorg.Name='1000';
        sorg.Description__c='India';
        sorg.Sales_Org_Code__c='1000';
        insert sorg;
        
        Auto_Number__c autObj = new Auto_Number__c();
        autObj.Name = 'FarmerCode';
        autObj.Sequence__c = '0';
        insert autObj;
        
        Trigger_Settings__c tsObj = new Trigger_Settings__c();
        tsObj.Name = 'CaseTrigger';
        tsObj.isActive__c = True;
        insert tsObj;
        
        Price_Group_Master__c pg = new Price_Group_Master__c ();
        pg.PG_Code__c='03';
        insert Pg;
        
        Product2 pro = new Product2();
        pro.ProductCode = '66700';
        pro.Product_Code__c='66700';
        pro.Name='DOST';
        pro.popular__c = true;
        pro.Combination_Key__c='RM0065100';
        insert Pro;
        
        Crop__c cropObj = new Crop__c();
        cropObj.Name = 'Onion';                     
        cropObj.Crop_Type__c = 'Fruits & Vegetables'; 
        cropObj.Crop_Code__c = 'CR042';                
        // cropObj.Active__c = true;     
        insert cropObj;
        
        State__c stateObj = new State__c(); 
        
        stateObj.Country__c='India';
        // stateObj.Country_Code__c=13;
        stateObj.Language__c='Marathi';
        // stateObj.Active__c=true;
        stateObj.Name='Maharashtra';
        insert stateObj;
        
        District__c disObj = new District__c();
        disObj.Name='Thane';
        disObj.District_Code__c='517';
        //disObj.Active__c=true;
        disObj.State__c=stateObj.Id;
        // disObj.State_Code__c=stateObj.State_Code__c;
        insert disObj;
        
        Tehsil__c tashilObj = new Tehsil__c();
        tashilObj.Name='Vasai';
        tashilObj.District__c=disObj.Id;
        // tashilObj.District_Code__c = disObj.State_Code__c;
        //  tashilObj.Active__c=true;
        insert tashilObj;
        
        Village__c villObj = new Village__c();
        villObj.Name='vakad';
        villObj.Tehsil__c=tashilObj.Id;
        villObj.Zone__c = 'pune';
        villObj.Territory__c = 'pune zone';
        insert villObj;
        
        Village__c villObj1 = new Village__c();
        villObj1.Name='vakad1';
        villObj1.Tehsil__c=tashilObj.Id;
        insert villObj1;
        
        Employee__c emp = new Employee__c();
        emp.Name='test';
        emp.Email__c='test@gmail.com';
        emp.Employee_Id__c='emp1';
        emp.Mobile__c='9878485745';
        emp.Active__c=true;
        insert emp;
        
        Employee_Village_Mapping__c empvillObj = new Employee_Village_Mapping__c();
        empvillObj.Employee__c = emp.Id;
        empvillObj.Village__c=villObj.Id;
        empvillObj.Active__c=true;
        empvillObj.From__c=system.today();
        empvillObj.To__c=system.today();
        insert empvillObj;
        
        Employee_Village_Mapping__c empvillObj1 = new Employee_Village_Mapping__c();
        empvillObj1.Employee__c = emp.Id;
        empvillObj1.Village__c=villObj1.Id;
        empvillObj1.Active__c=true;
        empvillObj1.From__c=system.today();
        empvillObj1.To__c=system.today();
        insert empvillObj1;
        
        User userobj = new User();
        userobj.ProfileID = [Select Id From Profile Where Name='UPL AKC Call Expert'].id;
        userobj.EmailEncodingKey = 'ISO-8859-1';
        userobj.LanguageLocaleKey = 'en_US';
        userobj.TimeZoneSidKey = 'America/New_York';
        userobj.LocaleSidKey = 'en_US';
        userobj.FirstName = 'first';
        userobj.LastName = 'last';
        userobj.Username = 'test@yoohoo.com';   
        userobj.CommunityNickname = 'testUser23';
        userobj.Alias = 't21';
        userobj.Email = 'no@email.com';
        userobj.IsActive = true;
        //userobj.AccountId = ba.Id;
        insert userobj;
        User userobj2 = [Select Id,Name from User Where id =: userobj.Id];
        
        Account acc = new account();
        Account acc1 = new account();
        System.runas(userobj2){
            
            acc.RecordTypeId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Farmer').getRecordTypeId();
            acc.Mobile__c='9869457515';
            acc.PersonMobilePhone='9878485741';
            acc.Email__c='test@gmail.com';
            acc.Phone='1010101004';
            acc.BillingStreet='test';
            acc.Sales_Org__c=sorg.Id;
            acc.BillingCity='test';
            acc.BillingState='test';
            acc.BillingPostalCode='test';
            acc.BillingCountry='test';
            acc.PriceGroupCode__c=Pg.Id;
            acc.Last_Name__c='test';
            acc.First_Name__c='test';
            acc.FirstName='test';
            acc.LastName='tets';
            acc.Village__pc=villObj.Id;
            acc.Age__pc = 27;
            acc.Decision_Maker__pc = 'Yes';
            acc.Crops_Cultivated__pc = 'Fruit/Vegetables';
            acc.Fruit_Vegetable_Acerage__pc = '1 or Above';
            acc.SMS_Voice_Msg_Call_Consent__pc = 'Yes';
            acc.Owned_Land_in_Acer__pc = 2;
            acc.Crop_Codes__pc = '0003';
            acc.Middle_Name__c='tets';
            // acc.Salutation__c='Mr.';
            insert acc;
            
            
            acc1.RecordTypeId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Farmer').getRecordTypeId();
            acc1.Mobile__c='9869457516';
            acc1.PersonMobilePhone='9878485742';
            acc1.Email__c='test@gmail.com';
            acc1.Phone='1010101004';
            acc1.BillingStreet='test';
            acc1.BillingCity='test';
            acc1.BillingState='test';
            acc1.BillingPostalCode='test';
            acc1.BillingCountry='test';
            acc1.PriceGroupCode__c=Pg.Id;
            acc1.Last_Name__c='test';
            acc1.First_Name__c='test';
            acc1.FirstName='test';
            acc1.LastName='tets';
            acc1.Sales_Org__c=sorg.Id;
            acc1.Village__pc=villObj1.Id;
            acc1.Age__pc = 27;
            acc1.Decision_Maker__pc = 'Yes';
            acc1.Crops_Cultivated__pc = 'Fruit/Vegetables';
            acc1.Fruit_Vegetable_Acerage__pc = '1 or Above';
            acc1.SMS_Voice_Msg_Call_Consent__pc = 'Yes';
            acc1.Owned_Land_in_Acer__pc = 2;
            acc1.Crop_Codes__pc = '0003';
            acc1.Middle_Name__c='tets';
            // acc.Salutation__c='Mr.';
            insert acc1;
        }
        
        Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('UPL General Case').getRecordTypeId();
        Case caseObj = new Case();
        caseObj.RecordTypeId = caseRecordTypeId;
        caseObj.SuppliedName = 'Test Test';
        caseObj.SuppliedEmail = 'test@test.com';
        caseObj.SuppliedPhone = '9920772228';
        caseObj.Type='Account Related';
        caseObj.AccountId=acc.id;
        caseObj.Crop__c=cropObj.Id;
        caseObj.Crop_pick__c='Onion';
        caseObj.SMS_Sent__c=true;
        caseObj.Neebal_Integration_Status__c='Ready for Creation';
        caseObj.Products_Recommended__c = 'PHOSKILL';
        Test.startTest();
        insert caseObj;
        
        ZoneTerrFarmerRegistrationExtensions zntr = new ZoneTerrFarmerRegistrationExtensions();
        Test.stopTest();
    }
    
    static testmethod void casetest1(){
        
        Sales_Org__c sorg =new Sales_Org__c();
        sorg.Name='1000';
        sorg.Description__c='India';
        sorg.Sales_Org_Code__c='1000';
        insert sorg;
        
        Auto_Number__c autObj = new Auto_Number__c();
        autObj.Name = 'FarmerCode';
        autObj.Sequence__c = '0';
        insert autObj;
        
        Trigger_Settings__c tsObj = new Trigger_Settings__c();
        tsObj.Name = 'CaseTrigger';
        tsObj.isActive__c = True;
        insert tsObj;
        
        Price_Group_Master__c pg = new Price_Group_Master__c ();
        pg.PG_Code__c='03';
        insert Pg;
        
        Product2 pro = new Product2();
        pro.ProductCode = '66700';
        pro.Product_Code__c='66700';
        pro.Name='DOST';
        pro.popular__c = true;
        pro.Combination_Key__c='RM0065100';
        insert Pro;
        
        Crop__c cropObj = new Crop__c();
        cropObj.Name = 'Onion';                     
        cropObj.Crop_Type__c = 'Fruits & Vegetables'; 
        cropObj.Crop_Code__c = 'CR042';                
        // cropObj.Active__c = true;     
        insert cropObj;
        
        State__c stateObj = new State__c(); 
        
        stateObj.Country__c='India';
        // stateObj.Country_Code__c=13;
        stateObj.Language__c='Marathi';
        // stateObj.Active__c=true;
        stateObj.Name='Maharashtra';
        insert stateObj;
        
        District__c disObj = new District__c();
        disObj.Name='Thane';
        disObj.District_Code__c='517';
        //disObj.Active__c=true;
        disObj.State__c=stateObj.Id;
        // disObj.State_Code__c=stateObj.State_Code__c;
        insert disObj;
        
        Tehsil__c tashilObj = new Tehsil__c();
        tashilObj.Name='Vasai';
        tashilObj.District__c=disObj.Id;
        // tashilObj.District_Code__c = disObj.State_Code__c;
        //  tashilObj.Active__c=true;
        insert tashilObj;
        
        Village__c villObj = new Village__c();
        villObj.Name='vakad';
        villObj.Tehsil__c=tashilObj.Id;
        villObj.Zone__c = 'pune';
        villObj.Territory__c = 'pune zone';
        insert villObj;
        
        Depot__c dp =new Depot__c ();
        dp.Name='Pune';
        dp.Country__c='India';
        dp.Location__c='Pune';
        dp.Depot_Code__c='PUN1';
        insert dp;
        
        Village__c villObj1 = new Village__c();
        villObj1.Name='vakad1';
        villObj1.Tehsil__c=tashilObj.Id;
        insert villObj1;
        
        
        Employee__c emp = new Employee__c();
        emp.Name='test';
        emp.Email__c='test@gmail.com';
        emp.Employee_Id__c='emp1';
        emp.Mobile__c='9878485745';
        emp.Active__c=true;
        insert emp;
        
        Employee_Village_Mapping__c empvillObj = new Employee_Village_Mapping__c();
        empvillObj.Employee__c = emp.Id;
        empvillObj.Village__c=villObj.Id;
        empvillObj.Active__c=true;
        empvillObj.From__c=system.today();
        empvillObj.To__c=system.today();
        insert empvillObj;
        
        Employee_Village_Mapping__c empvillObj1 = new Employee_Village_Mapping__c();
        empvillObj1.Employee__c = emp.Id;
        empvillObj1.Village__c=villObj1.Id;
        empvillObj1.Active__c=true;
        empvillObj1.From__c=system.today();
        empvillObj1.To__c=system.today();
        insert empvillObj1;
        
        User userobj = new User();
        userobj.ProfileID = [Select Id From Profile Where Name='UPL AKC Call Expert'].id;
        userobj.EmailEncodingKey = 'ISO-8859-1';
        userobj.LanguageLocaleKey = 'en_US';
        userobj.TimeZoneSidKey = 'America/New_York';
        userobj.LocaleSidKey = 'en_US';
        userobj.FirstName = 'first';
        userobj.LastName = 'last';
        userobj.Username = 'test@yoohoo.com';   
        userobj.CommunityNickname = 'testUser23';
        userobj.Alias = 't21';
        userobj.Email = 'no@email.com';
        userobj.IsActive = true;
        //userobj.AccountId = ba.Id;
        insert userobj;
        User userobj2 = [Select Id,Name from User Where id =: userobj.Id];
        
        Account acc = new account();
        Account acc1 = new account();
        System.runas(userobj2){
            
            acc.RecordTypeId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Farmer').getRecordTypeId();
            acc.Mobile__c='9869457515';
            acc.PersonMobilePhone='9878485741';
            acc.Email__c='test@gmail.com';
            acc.Phone='1010101004';
            //acc.BillingStreet='test';
            acc.Sales_Org__c=sorg.Id;
            //acc.BillingCity='test';
            //acc.BillingState='test';
            //acc.BillingPostalCode='test';
            //acc.BillingCountry='test';
            acc.PriceGroupCode__c=Pg.Id;
            //acc.Last_Name__c='test';
            //acc.First_Name__c='test';
            acc.FirstName='test';
            acc.LastName='tets';
            acc.Village__pc=villObj.Id;
            acc.Age__pc = 27;
            acc.Decision_Maker__pc = 'Yes';
            acc.Crops_Cultivated__pc = 'Fruit/Vegetables';
            acc.Fruit_Vegetable_Acerage__pc = '1 or Above';
            acc.SMS_Voice_Msg_Call_Consent__pc = 'Yes';
            acc.Owned_Land_in_Acer__pc = 2;
            acc.Crop_Codes__pc = '0003';
            acc.Middle_Name__c='tets';
            // acc.Salutation__c='Mr.';
            insert acc;
            
            
            acc1.RecordTypeId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Farmer').getRecordTypeId();
            acc1.Mobile__c='9869457516';
            acc1.PersonMobilePhone='9878485742';
            acc1.Email__c='test@gmail.com';
            acc1.Phone='1010101004';
            acc1.BillingStreet='test';
            acc1.BillingCity='test';
            acc1.BillingState='test';
            acc1.BillingPostalCode='test';
            acc1.BillingCountry='test';
            acc1.PriceGroupCode__c=Pg.Id;
            acc1.Last_Name__c='test';
            acc1.First_Name__c='test';
            acc1.FirstName='test';
            acc1.LastName='tets';
            acc1.Sales_Org__c=sorg.Id;
            acc1.Village__pc=villObj1.Id;
            acc1.Age__pc = 27;
            acc1.Decision_Maker__pc = 'Yes';
            acc1.Crops_Cultivated__pc = 'Fruit/Vegetables';
            acc1.Fruit_Vegetable_Acerage__pc = '1 or Above';
            acc1.SMS_Voice_Msg_Call_Consent__pc = 'Yes';
            acc1.Owned_Land_in_Acer__pc = 2;
            acc1.Crop_Codes__pc = '0003';
            acc1.Middle_Name__c='tets';
            // acc.Salutation__c='Mr.';
            insert acc1;
            
        }
        
        Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('UPL General Case').getRecordTypeId();
        Case caseObj = new Case();
        caseObj.RecordTypeId = caseRecordTypeId;
        caseObj.SuppliedName = 'Test Test';
        caseObj.SuppliedEmail = 'test@test.com';
        caseObj.SuppliedPhone = '9920772228';
        caseObj.Type='Account Related';
        caseObj.AccountId=acc1.id;
        caseObj.Crop__c=cropObj.Id;
        caseObj.Crop_pick__c='Onion';
        caseObj.SMS_Sent__c=true;
        caseObj.Neebal_Integration_Status__c='Ready for Creation';
        caseObj.Products_Recommended__c = 'PHOSKILL';
        Test.startTest();
        insert caseObj;
        
        ZoneTerrFarmerRegistrationExtensions zntr = new ZoneTerrFarmerRegistrationExtensions();
        Test.stopTest();
    }
    
    static testmethod void casetest2(){
        
        Sales_Org__c sorg =new Sales_Org__c();
        sorg.Name='1000';
        sorg.Description__c='India';
        sorg.Sales_Org_Code__c='1000';
        insert sorg;
        
        Auto_Number__c autObj = new Auto_Number__c();
        autObj.Name = 'FarmerCode';
        autObj.Sequence__c = '0';
        insert autObj;
        
        Trigger_Settings__c tsObj = new Trigger_Settings__c();
        tsObj.Name = 'CaseTrigger';
        tsObj.isActive__c = True;
        insert tsObj;
        
        Price_Group_Master__c pg = new Price_Group_Master__c ();
        pg.PG_Code__c='03';
        insert Pg;
        
        Product2 pro = new Product2();
        pro.ProductCode = '66700';
        pro.Product_Code__c='66700';
        pro.Name='DOST';
        pro.popular__c = true;
        pro.Combination_Key__c='RM0065100';
        insert Pro;
        
        Crop__c cropObj = new Crop__c();
        cropObj.Name = 'Onion';                     
        cropObj.Crop_Type__c = 'Fruits & Vegetables'; 
        cropObj.Crop_Code__c = 'CR042';                
        // cropObj.Active__c = true;     
        insert cropObj;
        
        State__c stateObj = new State__c(); 
        
        stateObj.Country__c='India';
        // stateObj.Country_Code__c=13;
        stateObj.Language__c='Marathi';
        // stateObj.Active__c=true;
        stateObj.Name='Maharashtra';
        insert stateObj;
        
        District__c disObj = new District__c();
        disObj.Name='Thane';
        disObj.District_Code__c='517';
        //disObj.Active__c=true;
        disObj.State__c=stateObj.Id;
        // disObj.State_Code__c=stateObj.State_Code__c;
        insert disObj;
        
        Tehsil__c tashilObj = new Tehsil__c();
        tashilObj.Name='Vasai';
        tashilObj.District__c=disObj.Id;
        // tashilObj.District_Code__c = disObj.State_Code__c;
        //  tashilObj.Active__c=true;
        insert tashilObj;
        
        Village__c villObj = new Village__c();
        villObj.Name='vakad';
        villObj.Tehsil__c=tashilObj.Id;
        villObj.Zone__c = 'pune';
        villObj.Territory__c = 'pune zone';
        insert villObj;
        
        Depot__c dp =new Depot__c ();
        dp.Name='Pune';
        dp.Country__c='India';
        dp.Location__c='Pune';
        dp.Depot_Code__c='PUN1';
        insert dp;
        
        Employee__c emp = new Employee__c();
        emp.Name='test';
        emp.Email__c='test@gmail.com';
        emp.Employee_Id__c='emp1';
        emp.Mobile__c='9878485745';
        emp.Active__c=true;
        insert emp;
        
        Employee_Village_Mapping__c empvillObj = new Employee_Village_Mapping__c();
        empvillObj.Employee__c = emp.Id;
        empvillObj.Village__c=villObj.Id;
        empvillObj.Active__c=true;
        empvillObj.From__c=system.today();
        empvillObj.To__c=system.today();
        insert empvillObj;
        
        User userobj = new User();
        userobj.ProfileID = [Select Id From Profile Where Name='UPL AKC Call Expert'].id;
        userobj.EmailEncodingKey = 'ISO-8859-1';
        userobj.LanguageLocaleKey = 'en_US';
        userobj.TimeZoneSidKey = 'America/New_York';
        userobj.LocaleSidKey = 'en_US';
        userobj.FirstName = 'first';
        userobj.LastName = 'last';
        userobj.Username = 'test@yoohoo.com';   
        userobj.CommunityNickname = 'testUser23';
        userobj.Alias = 't21';
        userobj.Email = 'no@email.com';
        userobj.IsActive = true;
        //userobj.AccountId = ba.Id;
        insert userobj;
        User userobj2 = [Select Id,Name from User Where id =: userobj.Id];
        
        Account acc = new account();
        System.runas(userobj2){
            
            acc.RecordTypeId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Farmer').getRecordTypeId();
            acc.Mobile__c='9869457515';
            acc.PersonMobilePhone='9878485741';
            acc.Email__c='test@gmail.com';
            acc.Phone='1010101004';
            //acc.BillingStreet='test';
            acc.Sales_Org__c=sorg.Id;
            //acc.BillingCity='test';
            //acc.BillingState='test';
            //acc.BillingPostalCode='test';
            //acc.BillingCountry='test';
            acc.PriceGroupCode__c=Pg.Id;
            //acc.Last_Name__c='test';
            //acc.First_Name__c='test';
            acc.FirstName='test';
            acc.LastName='tets';
            acc.Village__pc=villObj.Id;
            acc.Age__pc = 27;
            acc.Decision_Maker__pc = 'Yes';
            acc.Crops_Cultivated__pc = 'Fruit/Vegetables';
            acc.Fruit_Vegetable_Acerage__pc = '1 or Above';
            acc.SMS_Voice_Msg_Call_Consent__pc = 'Yes';
            acc.Owned_Land_in_Acer__pc = 2;
            acc.Crop_Codes__pc = '0003';
            acc.Middle_Name__c='tets';
            // acc.Salutation__c='Mr.';
            insert acc;
            
        }
        
        Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('UPL General Case').getRecordTypeId();
        Case caseObj = new Case();
        caseObj.RecordTypeId = caseRecordTypeId;
        caseObj.SuppliedName = 'Test Test';
        caseObj.SuppliedEmail = 'test@test.com';
        caseObj.SuppliedPhone = '9920772228';
        caseObj.Type='Account Related';
        caseObj.AccountId = acc.id;
        caseObj.ContactId = acc.personcontact.id;
        caseObj.Crop__c=cropObj.Id;
        caseObj.Crop_pick__c='Onion';
        caseObj.SMS_Sent__c=true;
        caseObj.Neebal_Integration_Status__c='Ready for Creation';
        caseObj.Products_Recommended__c = 'PHOSKILL';
        insert caseObj;
        
        ZoneTerrFarmerRegistrationExtensions zntr = new ZoneTerrFarmerRegistrationExtensions();
        
        zntr.s1 = 'x';
        zntr.s2 = 'x';
        zntr.s3 = 'x';
        zntr.s4 = 'x';
        zntr.s5 = 'x';
        zntr.s6 = 'x';
        zntr.s7 = 'x';
        zntr.s8 = 'x';
        zntr.s9 = 'x';
        zntr.s10 = 'x';
        zntr.s11 = 'x';
        zntr.s12 = 'x';
        zntr.s13 = 'x';
        zntr.s14 = 'x';
        zntr.s15 = 'x';
        zntr.s16 = 'x';
        zntr.s17 = 'x';
        zntr.s18 = 'x';
        zntr.s19 = 'x';
    }*/
     public static TestMethod void testInsertTrigger(){
        Auto_Number__c auto = new Auto_Number__c();
        auto.Name='FarmerCode';
        auto.Sequence__c='11';
        insert auto;
        Trigger_Settings__c tsObj1 = new Trigger_Settings__c();
        tsObj1.Name = 'CaseTrigger';
        tsObj1.isActive__c = True;
        insert tsObj1;
        State__c s=new State__c(Name='UP');
        insert s;
        District__c d=new District__c(Name='Bareilly',State__c=s.Id);
        insert d;
        Tehsil__c t=new Tehsil__c(Name='abc',District__c=d.Id, Tehsil_Code__c='123456');
        insert t;
        Village__c v=new Village__c(Name='Atak Pardi',Tehsil__c=t.Id,Territory__c='Pune',Zone__c='west');
        insert v;
         Village__c v1=new Village__c(Name='Atak Pardi',Tehsil__c=t.Id);
         insert v1;
        Employee__c e=new Employee__c(Name='Anant', Mobile__c='7065749466',Active__c=true);
        insert e;
        Date fromDate=System.today();
        Date toDate=fromDate.addDays(5);
        
        Employee_Village_Mapping__c evm=new Employee_Village_Mapping__c(Employee__c=e.Id, Village__c=v.Id,Active__c=true, To__c=toDate, From__c=fromDate);
        insert evm;
         
           Employee_Village_Mapping__c evm1=new Employee_Village_Mapping__c(Employee__c=e.Id, Village__c=v1.Id,Active__c=true, To__c=toDate, From__c=fromDate);
        insert evm1;
        RecordType r=new RecordType();
        r=[SELECT Id,Name From RecordType WHERE SObjectType='Account' AND Name='Farmer' limit 1];
   
        Account acc1=new Account(FirstName='Anant', LastName='Agarwal', Village__pc=v.Id, PersonMobilePhone='7065749466', RecordTypeId=r.Id, Crops_Cultivated__pc='Fruit/Vegetables', Decision_Maker__pc='Yes', Fruit_Vegetable_Acerage__pc='1 or Above', SMS_Voice_Msg_Call_Consent__pc='Yes');
        insert acc1;
        Case c=new Case(Products_Recommended__c='PHOSKILL;',accountid = acc1.id,Status='Escalated-L2',Subject='ABC',Type='Disease', Crop_pick__c='Cole', Sub_Query__c='How To Use', Origin='Call Inbound', Neebal_Integration_Status__c='Ready For Creation', SMS_Sent__c=true);
        insert c;
         
    ZoneTerrFarmerRegistrationExtensions zntr = new ZoneTerrFarmerRegistrationExtensions();
        
        zntr.s1 = 'x';
        zntr.s2 = 'x';
        zntr.s3 = 'x';
        zntr.s4 = 'x';
        zntr.s5 = 'x';
        zntr.s6 = 'x';
        zntr.s7 = 'x';
        zntr.s8 = 'x';
        zntr.s9 = 'x';
        zntr.s10 = 'x';
        zntr.s11 = 'x';
        zntr.s12 = 'x';
        zntr.s13 = 'x';
        zntr.s14 = 'x';
        zntr.s15 = 'x';
        zntr.s16 = 'x';
        zntr.s17 = 'x';
        zntr.s18 = 'x';
        zntr.s19 = 'x';


      /*  Account acc2=new Account(FirstName='Anant', LastName='Agarwal', Village__pc=v1.Id, PersonMobilePhone='7065749466', RecordTypeId=r.Id, Crops_Cultivated__pc='Fruit/Vegetables', Decision_Maker__pc='Yes', Fruit_Vegetable_Acerage__pc='1 or Above', SMS_Voice_Msg_Call_Consent__pc='Yes');
        insert acc2;
        Case c1=new Case(Products_Recommended__c='PHOSKILL;',accountid = acc2.id,Status='Escalated-L2',Subject='ABC',Type='Disease', Crop_pick__c='Cole', Sub_Query__c='How To Use', Origin='Call Inbound', Neebal_Integration_Status__c='Ready For Creation', SMS_Sent__c=true);
        insert c1;  
        
        ZoneAndTerritoryReport zntr1 = new ZoneAndTerritoryReport();
        
        zntr1.s1 = 'x';
        zntr1.s2 = 'x';
        zntr1.s3 = 'x';
        zntr1.s4 = 'x';
        zntr1.s5 = 'x';
        zntr1.s6 = 'x';
        zntr1.s7 = 'x';
        zntr1.s8 = 'x';
        zntr1.s9 = 'x';
        zntr1.s10 = 'x';
        zntr1.s11 = 'x';
        zntr1.s12 = 'x';
        zntr1.s13 = 'x';
        zntr1.s14 = 'x';
        zntr1.s15 = 'x';
        zntr1.s16 = 'x';
        zntr1.s17 = 'x';
        zntr1.s18 = 'x';
        zntr1.s19 = 'x';*/


    }
    
       public static TestMethod void testInsertTrigger_1(){
        Auto_Number__c auto = new Auto_Number__c();
        auto.Name='FarmerCode';
        auto.Sequence__c='11';
        insert auto;
        Trigger_Settings__c tsObj1 = new Trigger_Settings__c();
        tsObj1.Name = 'CaseTrigger';
        tsObj1.isActive__c = True;
        insert tsObj1;
        State__c s=new State__c(Name='UP');
        insert s;
        District__c d=new District__c(Name='Bareilly',State__c=s.Id);
        insert d;
        Tehsil__c t=new Tehsil__c(Name='abc',District__c=d.Id, Tehsil_Code__c='123456');
        insert t;
        Village__c v=new Village__c(Name='Atak Pardi',Tehsil__c=t.Id,Territory__c='Pune',Zone__c='west');
        insert v;
         Village__c v1=new Village__c(Name='Atak Pardi',Tehsil__c=t.Id);
         insert v1;
        Employee__c e=new Employee__c(Name='Anant', Mobile__c='7065749466',Active__c=true);
        insert e;
        Date fromDate=System.today();
        Date toDate=fromDate.addDays(5);
        
        Employee_Village_Mapping__c evm=new Employee_Village_Mapping__c(Employee__c=e.Id, Village__c=v.Id,Active__c=true, To__c=toDate, From__c=fromDate);
        insert evm;
         
           Employee_Village_Mapping__c evm1=new Employee_Village_Mapping__c(Employee__c=e.Id, Village__c=v1.Id,Active__c=true, To__c=toDate, From__c=fromDate);
        insert evm1;
        RecordType r=new RecordType();
        r=[SELECT Id,Name From RecordType WHERE SObjectType='Account' AND Name='Farmer' limit 1];

         Account acc2=new Account(FirstName='Anant', LastName='Agarwal', Village__pc=v1.Id, PersonMobilePhone='7065749466', RecordTypeId=r.Id, Crops_Cultivated__pc='Fruit/Vegetables', Decision_Maker__pc='Yes', Fruit_Vegetable_Acerage__pc='1 or Above', SMS_Voice_Msg_Call_Consent__pc='Yes');
        insert acc2;
        Case c1=new Case(Products_Recommended__c='PHOSKILL;',accountid = acc2.id,Status='Escalated-L2',Subject='ABC',Type='Disease', Crop_pick__c='Cole', Sub_Query__c='How To Use', Origin='Call Inbound', Neebal_Integration_Status__c='Ready For Creation', SMS_Sent__c=true);
        insert c1;
             ZoneTerrFarmerRegistrationExtensions zntr1 = new ZoneTerrFarmerRegistrationExtensions();
        
        zntr1.s1 = 'x';
        zntr1.s2 = 'x';
        zntr1.s3 = 'x';
        zntr1.s4 = 'x';
        zntr1.s5 = 'x';
        zntr1.s6 = 'x';
        zntr1.s7 = 'x';
        zntr1.s8 = 'x';
        zntr1.s9 = 'x';
        zntr1.s10 = 'x';
        zntr1.s11 = 'x';
        zntr1.s12 = 'x';
        zntr1.s13 = 'x';
        zntr1.s14 = 'x';
        zntr1.s15 = 'x';
        zntr1.s16 = 'x';
        zntr1.s17 = 'x';
        zntr1.s18 = 'x';
        zntr1.s19 = 'x';

    }
    
    
}