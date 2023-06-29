@isTest
public class FoCallTypeBatch_Test{
    
     /*
        FO_NON_FO_Batch Test Class --
        
        Written By - Pravin J.
        Date - 30/10/2017  */
        
         public Static Id CaseRecType ;
     public Static contact  acnt ;
     public Static Village__c vl ;
     public Static Village__c vl1;
     public Static Tehsil__c ts;
    
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
        
               Profile pr = new Profile(name = 'UPL Call Expert');
        Profile prof = [select id from profile where name='UPL Call Expert'];
       
        
       User usr = new User(LastName = 'Krishnan',
                           FirstName='Sujin1',
                           Alias = 'Sujin',
                           Email = 'abc@sfdc1.com',
                           Username = 'sujinkrishnnan29081993111231@sfdc.com',
                           ProfileId = prof.id,
                           TimeZoneSidKey = 'GMT',
                           LanguageLocaleKey = 'en_US',
                           EmailEncodingKey = 'UTF-8',
                           LocaleSidKey = 'en_US'
                           ); 
       
       system.runAs(usr){
       
        Sales_Org__c SO = new Sales_Org__c();
        so.name = 'TestFin';
        so.Sales_Org_Code__c = '1000';
        insert SO;
        
        Product2 p = new product2();
       //P.RecordTypeId= Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Non-US').getRecordTypeId();
        p.name = 'testproduct';
        P.Sales_Org__c = SO.ID;
        p.Combination_Key__c = '123';
       // p.Sales_Org_Code__c = 1000;
        
        insert p;
       // Product2 prc=[select id,name,Sales_Org_Code__c,recordtype.name from Product2 where id=:p.id];
        
       // system.assert(false,''+prc);
        
        Promotional_Product__c pp = new Promotional_Product__c();
        pp.Name = 'Testabc';
        pp.Product_Name__c = p.id;
        pp.Current_Month__c = TRUE;
        pp.Month__c = 'Jan';
        pp.Financial_Year__c = '2020';
        insert pp;
        
        Promotional_Product__c pp1 = new Promotional_Product__c();
        pp1.Name = 'Testabc1';
        pp1.Product_Name__c = p.id;
        pp1.Current_Month__c = TRUE;
        pp1.Month__c = 'Jan';
        pp1.Financial_Year__c = '2020';
        insert pp1;
 
        
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
        acc.Village_Pin_Code_Manual__pc = '422009';
        acc.Using_Smart_Phone__c = 'No';
		acc.Promotional_Product__c = pp.id;
        
        insert acc;
       
        
        
        Case cs = new case();
            cs.Recordtypeid  = CaseRecType;
            cs.AccountId= acc.id;
            cs.Status = 'New';
            cs.Type = 'Mandi Price';
            cs.Sub_Query__c = 'Mandi Price';
            cs.CreatedDate = system.today()-1;
           cs.Crop_pick__c = 'Amla';
            
            insert cs;
            
            Case cs1 = new case();
            cs1.Recordtypeid  = CaseRecType;
            cs1.AccountId = acc.id;
            cs1.Status = 'New';
			cs1.Crop_pick__c = 'Amla';
           cs1.Type = 'Mandi Price';
            cs1.Sub_Query__c = 'Mandi Price';
            cs1.Products_Recommended__c ='PHOSKILL';
            cs1.CreatedDate = system.today()-1;
            insert cs1;
            
            Case cs3 = new case();
            cs3.Recordtypeid  = CaseRecType;
            cs3.AccountId= acc.id;
            cs3.Status = 'New';
            cs3.Type = 'Mandi Price';
            cs3.Sub_Query__c = 'Mandi Price';
            cs3.CreatedDate = system.today()-2;
           cs3.Crop_pick__c = 'Amla';
            
            insert cs3;
            
            Case cs4 = new case();
            cs4.Recordtypeid  = CaseRecType;
            cs4.AccountId= acc.id;
            cs4.Status = 'New';
            cs4.Type = 'Mandi Price';
            cs4.Sub_Query__c = 'Mandi Price';
            cs4.CreatedDate = system.today()-3;
            cs4.Crop_pick__c = 'Amla';
            
            insert cs4;
            
            Case cs5 = new case();
            cs5.Recordtypeid  = CaseRecType;
            cs5.AccountId= acc.id;
            cs5.Status = 'New';
            cs5.Type = 'Mandi Price';
            cs5.Sub_Query__c = 'Mandi Price';
            cs5.CreatedDate = system.today()-4;
           cs5.Crop_pick__c = 'Amla';
            
            insert cs5;
            
            Case cs6 = new case();
            cs6.Recordtypeid  = CaseRecType;
            cs6.AccountId= acc.id;
            cs6.Status = 'New';
            cs6.Type = 'Mandi Price';
            cs6.Sub_Query__c = 'Mandi Price';
            cs6.CreatedDate = system.today()-5;
            cs6.Crop_pick__c = 'Amla';
            
            insert cs6;
            
            
            Case cs7 = new case();
            cs7.Recordtypeid  = CaseRecType;
            cs7.AccountId= acc.id;
            cs7.Status = 'New';
            cs7.Type = 'Mandi Price';
            cs7.Sub_Query__c = 'Mandi Price';
            cs7.CreatedDate = system.today()-6;
            cs7.Crop_pick__c = 'Amla';
            
            insert cs7;
            
            
             test.startTest();
               
                FoCallTypeBatch obj = new FoCallTypeBatch();
                DataBase.executeBatch(obj);
                
             test.stopTest();
       }
        }
        
        
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
        villObj.Fo_map__c = false;
        villObj.Tehsil__c=ts.Id;
        villObj.Village_Code__c='650504';
        insert villObj;
        
        
        Price_Group_Master__c pg = new Price_Group_Master__c ();
        pg.PG_Code__c='03';
        insert Pg;
               Profile pr = new Profile(name = 'UPL Call Expert');
        Profile prof = [select id from profile where name='UPL Call Expert'];
       
        
       User usr = new User(LastName = 'Krishnan',
                           FirstName='Sujin1',
                           Alias = 'Sujin',
                           Email = 'abc@sfdc1.com',
                           Username = 'sujinkrishnnan29081993111231@sfdc.com',
                           ProfileId = prof.id,
                           TimeZoneSidKey = 'GMT',
                           LanguageLocaleKey = 'en_US',
                           EmailEncodingKey = 'UTF-8',
                           LocaleSidKey = 'en_US'
                           ); 
       
       system.runAs(usr){
       
        Sales_Org__c SO = new Sales_Org__c();
        so.name = 'TestFin';
        so.Sales_Org_Code__c = '1000';
        insert SO;
        
        Product2 p = new product2();
       //P.RecordTypeId= Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Non-US').getRecordTypeId();
        p.name = 'testproduct';
        P.Sales_Org__c = SO.ID;
        p.Combination_Key__c = '123';
       // p.Sales_Org_Code__c = 1000;
        
        insert p;
       // Product2 prc=[select id,name,Sales_Org_Code__c,recordtype.name from Product2 where id=:p.id];
        
       // system.assert(false,''+prc);
        
        Promotional_Product__c pp = new Promotional_Product__c();
        pp.Name = 'Testabc';
        pp.Product_Name__c = p.id;
        pp.Current_Month__c = TRUE;
        pp.Month__c = 'Jan';
        pp.Financial_Year__c = '2020';
        insert pp;
        
        Promotional_Product__c pp1 = new Promotional_Product__c();
        pp1.Name = 'Testabc1';
        pp1.Product_Name__c = p.id;
        pp1.Current_Month__c = TRUE;
        pp1.Month__c = 'Jan';
        pp1.Financial_Year__c = '2020';
        insert pp1;
 
        
        
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
        acc.Village_Pin_Code_Manual__pc = '422009';
        acc.Using_Smart_Phone__c = 'No';
		acc.Promotional_Product__c = pp.id;
        
        insert acc;
       
        
        
            Case cs = new case();
            cs.Recordtypeid  = CaseRecType;
            cs.AccountId= acc.id;
            cs.Status = 'New';
            cs.Type = 'Mandi Price';
            cs.Sub_Query__c = 'Mandi Price';
            cs.CreatedDate = system.today()-1;
            cs.Crop_pick__c = 'Amla';
            
            insert cs;
            
            Case cs1 = new case();
            cs1.Recordtypeid  = CaseRecType;
            cs1.AccountId = acc.id;
            cs1.Status = 'New';
            cs1.Type = 'Mandi Price';
            cs1.Sub_Query__c = 'Mandi Price';
            cs1.Products_Recommended__c ='PHOSKILL';
            cs1.CreatedDate = system.today()-1;
            cs1.Crop_pick__c = 'Amla';
            
            
            insert cs1;
            
            Case cs3 = new case();
            cs3.Recordtypeid  = CaseRecType;
            cs3.AccountId= acc.id;
            cs3.Status = 'New';
            cs3.Type = 'Mandi Price';
            cs3.Sub_Query__c = 'Mandi Price';
            cs3.CreatedDate = system.today()-2;
            cs3.Crop_pick__c = 'Amla';
            
            insert cs3;
            
            Case cs4 = new case();
            cs4.Recordtypeid  = CaseRecType;
            cs4.AccountId= acc.id;
            cs4.Status = 'New';
            cs4.Type = 'Mandi Price';
            cs4.Sub_Query__c = 'Mandi Price';
            cs4.CreatedDate = system.today()-3;
            cs4.Crop_pick__c = 'Amla';
            
            insert cs4;
            
            Case cs5 = new case();
            cs5.Recordtypeid  = CaseRecType;
            cs5.AccountId= acc.id;
            cs5.Status = 'New';
            cs5.Type = 'Mandi Price';
            cs5.Sub_Query__c = 'Mandi Price';
            cs5.CreatedDate = system.today()-4;
            cs5.Crop_pick__c = 'Amla';
            
            insert cs5;
            
            Case cs6 = new case();
            cs6.Recordtypeid  = CaseRecType;
            cs6.AccountId= acc.id;
            cs6.Status = 'New';
            cs6.Type = 'Mandi Price';
            cs6.Sub_Query__c = 'Mandi Price';
            cs6.CreatedDate = system.today()-5;
            cs6.Crop_pick__c = 'Amla';
            
            insert cs6;
            
            
            Case cs7 = new case();
            cs7.Recordtypeid  = CaseRecType;
            cs7.AccountId= acc.id;
            cs7.Status = 'New';
            cs7.Type = 'Mandi Price';
            cs7.Sub_Query__c = 'Mandi Price';
            cs7.CreatedDate = system.today()-6;
            cs7.Crop_pick__c = 'Amla';
            
            insert cs7;
            
             test.startTest();
               
                FoCallTypeBatch obj = new FoCallTypeBatch();
                DataBase.executeBatch(obj);
                
             test.stopTest();
         
        }
}
        
       
        
}