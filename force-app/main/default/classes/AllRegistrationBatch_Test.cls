@isTest 
public class AllRegistrationBatch_Test{

        //TotalRegistrationBatch 
      public static testMethod void test1(){
        
        String RecTypeId= [select Id from RecordType where (Name='Person Account') and (SobjectType='Account')].Id;
        Id RecType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Farmer').getRecordTypeId();
        Id CaseRecType = Schema.SObjectType.Case.getRecordTypeInfosByName().get('AKC General Case').getRecordTypeId();
       
       
        Auto_Number__c auto = new Auto_Number__c();
        auto.Name='FarmerCode';
        auto.Sequence__c='11';
        
        insert auto;
        
         Trigger_Settings__c tsObj1 = new Trigger_Settings__c();
        tsObj1.Name = 'CaseTrigger';
        tsObj1.isActive__c = True;
        insert tsObj1;
        
        State__c st = new State__c();
        st.Name='test';
        st.Language__c='Gujarati';
        st.Country__c='India';
        insert st;
        
        District__c dis = new District__c();
        dis.Name='test';
        dis.State__c=st.Id;
        //dis.Active__c=True;
        insert dis;
        
        Tehsil__c ts = new Tehsil__c();
        ts.Name='vasai';
        //ts.Active__c=true;
        ts.District__c=dis.Id;
        insert ts;
        
        Village__c villObj = new Village__c();
        villObj.Name='vasai';
        villObj.Tehsil__c=ts.Id;
        villObj.Fo_map__c = true;
        villObj.Village_Code__c='650504';
        insert villObj;
        
        Price_Group_Master__c pg = new Price_Group_Master__c ();
        pg.PG_Code__c='03';
        insert Pg;
        
        Utility_Test.UserCreatetest();
        ID pp =[Select id,name from Promotional_Product__c where Name=:'Testabc1'].id;
                                
        Account acc = new account();
        acc.RecordTypeId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('PreRegistered Farmer').getRecordTypeId();
        acc.FirstName='test';
        acc.LastName='Test';
        acc.Last_Name__c='test';
        acc.PersonMobilePhone='9869457812';
        acc.Village__pc=villObj.Id;
        acc.Farmer_Code__pc = 'fm0'+String.valueOf(auto.Sequence__c);
        acc.PersonEmail='test@gmail.com';
        acc.Phone='1010101004';
        acc.WRMS_Code__c='1222';
        acc.BillingStreet='test';
        acc.BillingCity='test';
        acc.BillingState='test';
        acc.BillingPostalCode='test';
        acc.BillingCountry='test';
        acc.PriceGroupCode__c=Pg.Id;
        //acc.Registered_DateTime__pc = System.today()-25;
        acc.Fully_Registered_Date__pc = System.today()-25;
        acc.Village_Pin_Code_Manual__pc = '422009';
        acc.Promotional_Product__c = pp;
        
        insert acc;
        
        account acc1 = new account();
        acc1.RecordTypeId= Schema.SObjectType.account.getRecordTypeInfosByName().get('PreRegistered Farmer').getRecordTypeId();
        acc1.FirstName='tesrt';
        acc1.LastName='Testtr';
        acc1.Last_Name__c='testrt';
        acc1.PersonMobilePhone='9869667812';
        acc1.Village__pc=villObj.Id;
        acc1.Farmer_Code__pc = 'fm0'+String.valueOf(auto.Sequence__c);
        acc1.PersonEmail='test1@gmail.com';
        acc1.Phone='1010101099';
        acc1.WRMS_Code__c='1225';
        acc1.BillingStreet='test1';
        acc1.BillingCity='test1';
        acc1.BillingState='test1';
        acc1.BillingPostalCode='test1';
        acc1.BillingCountry='tes1t';
        acc1.PriceGroupCode__c=Pg.Id;
        //acc1.Registered_DateTime__pc = System.today()-20;
        acc1.Fully_Registered_Date__pc = System.today()-20;
        acc1.Village_Pin_Code_Manual__pc ='346345';
        acc1.Promotional_Product__c = pp;
        
        insert acc1;
       
        Test.startTest();

            TotalRegistrationBatch obj = new TotalRegistrationBatch();
            DataBase.executeBatch(obj); 
            
        Test.stopTest();
        
       
    }
    
    //TotalRegistrationBatch 
    public static testMethod void test2(){
      
          
        
          String RecTypeId= [select Id from RecordType where (Name='Person Account') and (SobjectType='Account')].Id;
        Id RecType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Farmer').getRecordTypeId();
        Id CaseRecType = Schema.SObjectType.Case.getRecordTypeInfosByName().get('AKC General Case').getRecordTypeId();
       
       
        Auto_Number__c auto = new Auto_Number__c();
        auto.Name='FarmerCode';
        auto.Sequence__c='11';
        
        insert auto;
        
         Trigger_Settings__c tsObj1 = new Trigger_Settings__c();
        tsObj1.Name = 'CaseTrigger';
        tsObj1.isActive__c = True;
        insert tsObj1;
        
        State__c st = new State__c();
        st.Name='test';
        st.Language__c='Gujarati';
        st.Country__c='India';
        insert st;
        
        District__c dis = new District__c();
        dis.Name='test';
        dis.State__c=st.Id;
        //dis.Active__c=True;
        insert dis;
        
        Tehsil__c ts = new Tehsil__c();
        ts.Name='vasai';
        //ts.Active__c=true;
        ts.District__c=dis.Id;
        insert ts;
        
        Village__c villObj = new Village__c();
        villObj.Name='vasai';
        villObj.Tehsil__c=ts.Id;
        villObj.Fo_map__c = false;
        villObj.Village_Code__c='650504';
        insert villObj;
        
        
        Price_Group_Master__c pg = new Price_Group_Master__c ();
        pg.PG_Code__c='03';
        insert Pg;
        
        Utility_Test.UserCreatetest();
        ID pp =[Select id,name from Promotional_Product__c where Name=:'Testabc1'].id;
                       
        Account acc = new account();
        acc.RecordTypeId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('PreRegistered Farmer').getRecordTypeId();
        acc.FirstName='test';
        acc.LastName='Test';
        acc.Last_Name__c='test';
        acc.PersonMobilePhone='9869457812';
        acc.Village__pc=villObj.Id;
        acc.Farmer_Code__pc = 'fm0'+String.valueOf(auto.Sequence__c);
        acc.PersonEmail='test@gmail.com';
        acc.Phone='1010101004';
        acc.WRMS_Code__c='1222';
        acc.BillingStreet='test';
        acc.BillingCity='test';
        acc.BillingState='test';
        acc.BillingPostalCode='test';
        acc.BillingCountry='test';
        acc.PriceGroupCode__c=Pg.Id;
        //acc.Registered_DateTime__pc = System.today()-25;
        acc.Fully_Registered_Date__pc = System.today()-25;
        acc.Village_Pin_Code_Manual__pc ='346345';
        acc.Promotional_Product__c = pp;
        insert acc;
        
        
        account acc1 = new account();
        acc1.RecordTypeId= Schema.SObjectType.account.getRecordTypeInfosByName().get('PreRegistered Farmer').getRecordTypeId();
        acc1.FirstName='testuu';
        acc1.LastName='Testoo';
        acc1.Last_Name__c='testii';
        acc1.PersonMobilePhone='9869458812';
        acc1.Village__pc=villObj.Id;
        acc1.Farmer_Code__pc = 'fm0'+String.valueOf(auto.Sequence__c);
        acc1.PersonEmail='test22@gmail.com';
        acc1.Phone='1010101224';
        acc1.WRMS_Code__c='1888';
        acc1.BillingStreet='test3';
        acc1.BillingCity='test3';
        acc1.BillingState='test4';
        acc1.BillingPostalCode='test4';
        acc1.BillingCountry='test4';
        acc1.PriceGroupCode__c=Pg.Id;
        //acc1.Registered_DateTime__pc = System.today()-25;
        acc1.Fully_Registered_Date__pc = System.today()-25;
        acc1.Village_Pin_Code_Manual__pc ='346345';
        acc1.Promotional_Product__c = pp;
        insert acc1;
       
        Test.startTest();

            TotalRegistrationBatch obj = new TotalRegistrationBatch();
            DataBase.executeBatch(obj); 
            
        Test.stopTest();
       
     }
     
       // ThisYearTotalRegistrationBatch 
      public static testMethod void test3(){
      
          
        
          String RecTypeId= [select Id from RecordType where (Name='Person Account') and (SobjectType='Account')].Id;
        Id RecType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Farmer').getRecordTypeId();
        Id CaseRecType = Schema.SObjectType.Case.getRecordTypeInfosByName().get('AKC General Case').getRecordTypeId();
       
       
        Auto_Number__c auto = new Auto_Number__c();
        auto.Name='FarmerCode';
        auto.Sequence__c='11';
        
        insert auto;
        
         Trigger_Settings__c tsObj1 = new Trigger_Settings__c();
        tsObj1.Name = 'CaseTrigger';
        tsObj1.isActive__c = True;
        insert tsObj1;
        
        State__c st = new State__c();
        st.Name='test';
        st.Language__c='Gujarati';
        st.Country__c='India';
        insert st;
        
        District__c dis = new District__c();
        dis.Name='test';
        dis.State__c=st.Id;
        //dis.Active__c=True;
        insert dis;
        
        Tehsil__c ts = new Tehsil__c();
        ts.Name='vasai';
        //ts.Active__c=true;
        ts.District__c=dis.Id;
        insert ts;
        
        Village__c villObj = new Village__c();
        villObj.Name='vasai';
        villObj.Tehsil__c=ts.Id;
        villObj.Fo_map__c = false;
        villObj.Village_Code__c='650504';
        insert villObj;
        
        
        Price_Group_Master__c pg = new Price_Group_Master__c ();
        pg.PG_Code__c='03';
        insert Pg;
                        
        Utility_Test.UserCreatetest();
        ID pp =[Select id,name from Promotional_Product__c where Name=:'Testabc1'].id;
        
        Account acc = new account();
        acc.RecordTypeId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('PreRegistered Farmer').getRecordTypeId();
        acc.FirstName='test';
        acc.LastName='Test';
        acc.Last_Name__c='test';
        acc.PersonMobilePhone='9869457812';
        acc.Village__pc=villObj.Id;
        acc.Farmer_Code__pc = 'fm0'+String.valueOf(auto.Sequence__c);
        acc.PersonEmail='test@gmail.com';
        acc.Phone='1010101004';
        acc.WRMS_Code__c='1222';
        acc.BillingStreet='test';
        acc.BillingCity='test';
        acc.BillingState='test';
        acc.BillingPostalCode='test';
        acc.BillingCountry='test';
        acc.PriceGroupCode__c=Pg.Id;
        //acc.Registered_DateTime__pc = System.today()-25;
        acc.Fully_Registered_Date__pc = System.today()-25;
        acc.Village_Pin_Code_Manual__pc ='346345';
        acc.Promotional_Product__c = pp;
        insert acc;
        
        
        account acc1 = new account();
        acc1.RecordTypeId= Schema.SObjectType.account.getRecordTypeInfosByName().get('PreRegistered Farmer').getRecordTypeId();
        acc1.FirstName='testtt';
        acc1.LastName='Testuu';
        acc1.Last_Name__c='testyy';
        acc1.PersonMobilePhone='9869458812';
        acc1.Village__pc=villObj.Id;
        acc1.Farmer_Code__pc = 'fm0'+String.valueOf(auto.Sequence__c);
        acc1.PersonEmail='test22@gmail.com';
        acc1.Phone='1010101224';
        acc1.WRMS_Code__c='1888';
        acc1.BillingStreet='test3';
        acc1.BillingCity='test3';
        acc1.BillingState='test4';
        acc1.BillingPostalCode='test4';
        acc1.BillingCountry='test4';
        acc1.PriceGroupCode__c=Pg.Id;
        //acc1.Registered_DateTime__pc = System.today()-25;
        acc1.Fully_Registered_Date__pc = System.today()-25;
        acc1.Village_Pin_Code_Manual__pc ='346345';
        acc1.Promotional_Product__c = pp;
        insert acc1;
        
        Test.startTest();

            ThisYearTotalRegistrationBatch obj = new ThisYearTotalRegistrationBatch();
            DataBase.executeBatch(obj); 
            
        Test.stopTest();
       }
     
     
     //  ThisMonthTotalRegistrationBatch 
      public static testMethod void test4(){
      
          
        
          String RecTypeId= [select Id from RecordType where (Name='Person Account') and (SobjectType='Account')].Id;
        Id RecType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Farmer').getRecordTypeId();
        Id CaseRecType = Schema.SObjectType.Case.getRecordTypeInfosByName().get('AKC General Case').getRecordTypeId();
       
       
        Auto_Number__c auto = new Auto_Number__c();
        auto.Name='FarmerCode';
        auto.Sequence__c='11';
        
        insert auto;
        
         Trigger_Settings__c tsObj1 = new Trigger_Settings__c();
        tsObj1.Name = 'CaseTrigger';
        tsObj1.isActive__c = True;
        insert tsObj1;
        
        State__c st = new State__c();
        st.Name='test';
        st.Language__c='Gujarati';
        st.Country__c='India';
        insert st;
        
        District__c dis = new District__c();
        dis.Name='test';
        dis.State__c=st.Id;
        //dis.Active__c=True;
        insert dis;
        
        Tehsil__c ts = new Tehsil__c();
        ts.Name='vasai';
        //ts.Active__c=true;
        ts.District__c=dis.Id;
        insert ts;
        
        Village__c villObj = new Village__c();
        villObj.Name='vasai';
        villObj.Tehsil__c=ts.Id;
        villObj.Fo_map__c = false;
        villObj.Village_Code__c='650504';
        insert villObj;
        
        
        Price_Group_Master__c pg = new Price_Group_Master__c ();
        pg.PG_Code__c='03';
        insert Pg;
        
        Utility_Test.UserCreatetest();
        ID pp =[Select id,name from Promotional_Product__c where Name=:'Testabc1'].id;
        
        Account acc = new account();
        acc.RecordTypeId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('PreRegistered Farmer').getRecordTypeId();
        acc.FirstName='test';
        acc.LastName='Testt';
        acc.Last_Name__c='test';
        acc.PersonMobilePhone='9869457812';
        acc.Village__pc=villObj.Id;
        acc.Farmer_Code__pc = 'fm0'+String.valueOf(auto.Sequence__c);
        acc.PersonEmail='test@gmail.com';
        acc.Phone='1010101004';
        acc.WRMS_Code__c='1222';
        acc.BillingStreet='test';
        acc.BillingCity='test';
        acc.BillingState='test';
        acc.BillingPostalCode='test';
        acc.BillingCountry='test';
        acc.PriceGroupCode__c=Pg.Id;
        //acc.Registered_DateTime__pc = System.today();
        acc.Fully_Registered_Date__pc = System.today();
        acc.Village_Pin_Code_Manual__pc ='346345';
        acc.Promotional_Product__c = pp;
        insert acc;
        
        
        account acc1 = new account();
        acc1.RecordTypeId= Schema.SObjectType.account.getRecordTypeInfosByName().get('PreRegistered Farmer').getRecordTypeId();
        acc1.FirstName='tester';
        acc1.LastName='Testrt';
        acc1.Last_Name__c='testyy';
        acc1.PersonMobilePhone='9869458812';
        acc1.Village__pc=villObj.Id;
        acc1.Farmer_Code__pc = 'fm0'+String.valueOf(auto.Sequence__c);
        acc1.PersonEmail='test22@gmail.com';
        acc1.Phone='1010101224';
        acc1.WRMS_Code__c='1888';
        acc1.BillingStreet='test3';
        acc1.BillingCity='test3';
        acc1.BillingState='test4';
        acc1.BillingPostalCode='test4';
        acc1.BillingCountry='test4';
        acc1.PriceGroupCode__c=Pg.Id;
        //acc1.Registered_DateTime__pc = System.today();
        acc1.Fully_Registered_Date__pc = System.today();
        acc1.Village_Pin_Code_Manual__pc ='346345';
        acc1.Promotional_Product__c = pp;
        System.today();
        
        insert acc1;
       
        Test.startTest();

            ThisMonthTotalRegistrationBatch obj = new ThisMonthTotalRegistrationBatch();
            DataBase.executeBatch(obj); 
            
        Test.stopTest();
     
      }
     
}