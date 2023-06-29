@isTest
public class VoiceBlastingTest{
    static testmethod void casetest(){
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
        stateObj.Language__c='Marathi';
        stateObj.Name='Maharashtra';
        insert stateObj;
        
        State__c stateObj1 = new State__c(); 
        stateObj1.Country__c='India';
        stateObj1.Language__c='Gujurati';
        stateObj1.Name='Gujurat';
        insert stateObj1;
        
        State__c stateObj2 = new State__c(); 
        stateObj2.Country__c='India';
        stateObj2.Language__c='Bengali';
        stateObj2.Name='West Bengal';
        insert stateObj2;
        
        District__c disObj = new District__c();
        disObj.Name='Thane';
        disObj.District_Code__c='517';
        disObj.State__c=stateObj.Id;
        insert disObj;
        
        District__c disObj1 = new District__c();
        disObj1.Name='Raigad';
        disObj1.District_Code__c='519';
        disObj1.State__c=stateObj.Id;
        insert disObj1;
        
        District__c disObj2 = new District__c();
        disObj2.Name='Raigadx';
        disObj2.District_Code__c='530';
        disObj2.State__c=stateObj1.Id;
        insert disObj2;
        
        District__c disObj3 = new District__c();
        disObj3.Name='Raiga';
        disObj3.District_Code__c='531';
        disObj3.State__c=stateObj1.Id;
        insert disObj3;
        
        District__c disObj4 = new District__c();
        disObj4.Name='Raipur';
        disObj4.District_Code__c='501';
        disObj4.State__c=stateObj2.Id;
        insert disObj4;
        
        District__c disObj5 = new District__c();
        disObj5.Name='Raichu';
        disObj5.District_Code__c='507';
        disObj5.State__c=stateObj2.Id;
        insert disObj5;
        
        Tehsil__c tashilObj = new Tehsil__c();
        tashilObj.Name='Vasai';
        tashilObj.District__c=disObj.Id;
        insert tashilObj;
        
        Tehsil__c tashilObj1 = new Tehsil__c();
        tashilObj1.Name='Vasai1';
        tashilObj1.District__c=disObj1.Id;
        insert tashilObj1;
        
        Tehsil__c tashilObj2 = new Tehsil__c();
        tashilObj2.Name='Vasa21';
        tashilObj2.District__c=disObj2.Id;
        insert tashilObj2;
        
        Tehsil__c tashilObj3 = new Tehsil__c();
        tashilObj3.Name='Vasa213';
        tashilObj3.District__c=disObj3.Id;
        insert tashilObj3;
        
        Tehsil__c tashilObj4 = new Tehsil__c();
        tashilObj4.Name='Vasa213';
        tashilObj4.District__c=disObj4.Id;
        insert tashilObj4;
        
        Tehsil__c tashilObj5 = new Tehsil__c();
        tashilObj5.Name='Vasa213';
        tashilObj5.District__c=disObj5.Id;
        insert tashilObj5;
        
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
        
        Village__c villObj2 = new Village__c();
        villObj2.Name='vakad2';
        villObj2.Tehsil__c=tashilObj1.Id;
        villObj2.Zone__c = 'pune1';
        villObj2.Territory__c = 'pune1 zone';
        insert villObj2;
        
        Village__c villObj3 = new Village__c();
        villObj3.Name='vakad3';
        villObj3.Tehsil__c=tashilObj2.Id;
        villObj3.Zone__c = 'pune2';
        villObj3.Territory__c = 'pune zone';
        insert villObj3;
        
        Village__c villObj4 = new Village__c();
        villObj4.Name='vakad4';
        villObj4.Tehsil__c=tashilObj3.Id;
        villObj4.Zone__c = 'pune3';
        villObj4.Territory__c = 'pune zone';
        insert villObj4;
        
        Village__c villObj5 = new Village__c();
        villObj5.Name='vakad5';
        villObj5.Tehsil__c=tashilObj4.Id;
        villObj5.Zone__c = 'pune4';
        villObj5.Territory__c = 'pune zone';
        insert villObj5;
        
        Village__c villObj6 = new Village__c();
        villObj6.Name='vakad6';
        villObj6.Tehsil__c=tashilObj5.Id;
        villObj6.Zone__c = 'pune5';
        villObj6.Territory__c = 'pune zone';
        insert villObj6;
        
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
        Account acc2 = new account();
        Account acc3 = new account();
        Account acc4 = new account();
        Account acc5 = new account();
        Account acc6 = new account();
        
        
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
            acc.SMS_Voice_Msg_Call_Consent__pc ='No';
            // acc.Salutation__c='Mr.';
            //insert acc;
            
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
            acc1.SMS_Voice_Msg_Call_Consent__pc ='No';
            //insert acc1;
            
            acc2.RecordTypeId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Farmer').getRecordTypeId();
            acc2.Mobile__c='9869457501';
            acc2.PersonMobilePhone='9878485701';
            acc2.Email__c='test@gmail.com';
            acc2.Phone='1010101004';
            acc2.BillingStreet='test';
            acc2.BillingCity='test';
            acc2.BillingState='test';
            acc2.BillingPostalCode='test';
            acc2.BillingCountry='test';
            acc2.PriceGroupCode__c=Pg.Id;
            acc2.Last_Name__c='test';
            acc2.First_Name__c='test';
            acc2.FirstName='test';
            acc2.LastName='tets';
            acc2.Sales_Org__c=sorg.Id;
            acc2.Village__pc=villObj2.Id;
            acc2.Age__pc = 27;
            acc2.Decision_Maker__pc = 'Yes';
            acc2.Crops_Cultivated__pc = 'Both';
            acc2.Fruit_Vegetable_Acerage__pc = '1 or Above';
            acc2.SMS_Voice_Msg_Call_Consent__pc = 'Yes';
            acc2.Owned_Land_in_Acer__pc = 2;
            acc2.Crop_Codes__pc = '0003';
            acc2.Middle_Name__c='tets';
            acc2.SMS_Voice_Msg_Call_Consent__pc ='No';
            //insert acc2;
            
            acc3.RecordTypeId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Farmer').getRecordTypeId();
            acc3.Mobile__c='9869457502';
            acc3.PersonMobilePhone='9878485702';
            acc3.Email__c='test@gmail.com';
            acc3.Phone='1010101004';
            acc3.BillingStreet='test';
            acc3.BillingCity='test';
            acc3.BillingState='test';
            acc3.BillingPostalCode='test';
            acc3.BillingCountry='test';
            acc3.PriceGroupCode__c=Pg.Id;
            acc3.Last_Name__c='test';
            acc3.First_Name__c='test';
            acc3.FirstName='test';
            acc3.LastName='tets';
            acc3.Sales_Org__c=sorg.Id;
            acc3.Village__pc=villObj3.Id;
            acc3.Age__pc = 27;
            acc3.Decision_Maker__pc = 'Yes';
            acc3.Crops_Cultivated__pc = 'Other';
            acc3.Fruit_Vegetable_Acerage__pc = '1 or Above';
            acc3.SMS_Voice_Msg_Call_Consent__pc = 'Yes';
            acc3.Owned_Land_in_Acer__pc = 2;
            acc3.Crop_Codes__pc = '0003';
            acc3.Middle_Name__c='tets';
            acc3.SMS_Voice_Msg_Call_Consent__pc ='No';
            //insert acc3;
            
            acc4.RecordTypeId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Farmer').getRecordTypeId();
            acc4.Mobile__c='9869457503';
            acc4.PersonMobilePhone='9878485703';
            acc4.Email__c='test@gmail.com';
            acc4.Phone='1010101004';
            acc4.BillingStreet='test';
            acc4.BillingCity='test';
            acc4.BillingState='test';
            acc4.BillingPostalCode='test';
            acc4.BillingCountry='test';
            acc4.PriceGroupCode__c=Pg.Id;
            acc4.Last_Name__c='test';
            acc4.First_Name__c='test';
            acc4.FirstName='test';
            acc4.LastName='tets';
            acc4.Sales_Org__c=sorg.Id;
            acc4.Village__pc=villObj4.Id;
            acc4.Age__pc = 27;
            acc4.Decision_Maker__pc = 'Yes';
            acc4.Crops_Cultivated__pc = 'Other';
            acc4.Fruit_Vegetable_Acerage__pc = '1 or Above';
            acc4.SMS_Voice_Msg_Call_Consent__pc = 'Yes';
            acc4.Owned_Land_in_Acer__pc = 2;
            acc4.Crop_Codes__pc = '0003';
            acc4.Middle_Name__c='tets';
            acc4.SMS_Voice_Msg_Call_Consent__pc ='No';
            //insert acc4;
            
            acc5.RecordTypeId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Farmer').getRecordTypeId();
            acc5.Mobile__c='9869457504';
            acc5.PersonMobilePhone='9878485704';
            acc5.Email__c='test@gmail.com';
            acc5.Phone='1010101004';
            acc5.BillingStreet='test';
            acc5.BillingCity='test';
            acc5.BillingState='test';
            acc5.BillingPostalCode='test';
            acc5.BillingCountry='test';
            acc5.PriceGroupCode__c=Pg.Id;
            acc5.Last_Name__c='test';
            acc5.First_Name__c='test';
            acc5.FirstName='test';
            acc5.LastName='tets';
            acc5.Sales_Org__c=sorg.Id;
            acc5.Village__pc=villObj5.Id;
            acc5.Age__pc = 27;
            acc5.Decision_Maker__pc = 'Yes';
            acc5.Crops_Cultivated__pc = 'Other';
            acc5.Fruit_Vegetable_Acerage__pc = '1 or Above';
            acc5.SMS_Voice_Msg_Call_Consent__pc = 'Yes';
            acc5.Owned_Land_in_Acer__pc = 2;
            acc5.Crop_Codes__pc = '0003';
            acc5.Middle_Name__c='tets';
            acc5.SMS_Voice_Msg_Call_Consent__pc ='No';
            //insert acc5;
            
            acc6.RecordTypeId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Farmer').getRecordTypeId();
            acc6.Mobile__c='9869457504';
            acc6.PersonMobilePhone='9878485704';
            acc6.Email__c='test@gmail.com';
            acc6.Phone='1010101004';
            acc6.BillingStreet='test';
            acc6.BillingCity='test';
            acc6.BillingState='test';
            acc6.BillingPostalCode='test';
            acc6.BillingCountry='test';
            acc6.PriceGroupCode__c=Pg.Id;
            acc6.Last_Name__c='test';
            acc6.First_Name__c='test';
            acc6.FirstName='test';
            acc6.LastName='tets';
            acc6.Sales_Org__c=sorg.Id;
            acc6.Village__pc=villObj6.Id;
            acc6.Age__pc = 27;
            acc6.Decision_Maker__pc = 'Yes';
            acc6.Crops_Cultivated__pc = 'Other';
            acc6.Fruit_Vegetable_Acerage__pc = '1 or Above';
            acc6.SMS_Voice_Msg_Call_Consent__pc = 'Yes';
            acc6.Owned_Land_in_Acer__pc = 2;
            acc6.Crop_Codes__pc = '0003';
            acc6.Middle_Name__c='tets';
            acc6.SMS_Voice_Msg_Call_Consent__pc ='No';
            //insert acc6;
            
            Test.startTest();
            insert acc;
            insert acc1;
            /*insert acc2;
            insert acc3;
            insert acc4;
            insert acc5;
            insert acc6;*/
            Test.stopTest();
        }
        
        voiceblasting vb = new voiceblasting();
        
        vb.selectedState = '[Maharashtra, Gujurat]';
        vb.statecount();
        
       // vb.selectedDistrict = '[Thane, Raigad]';
       // vb.districtcount();
        
        vb.selectedZone = '[pune4, pune]';
        vb.zonecount();
        
        vb.selectedTerritory = '[pune4, pune]';
        vb.territorycount();
        
        vb.selectedCrop = '[both]';
        vb.cropcount();
        
    }
}