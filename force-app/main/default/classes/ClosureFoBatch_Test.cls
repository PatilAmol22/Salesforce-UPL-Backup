@isTest
public class ClosureFoBatch_Test{
  
  /*
        FO_NON_FO_Batch Test Class --
        
        Written By - Pravin J.
        Date - 02/11/2017  */
        
         public Static Id CaseRecType ;
     public Static contact  acnt ;
     public Static Village__c vl ;
     public Static Village__c vl1;
     public Static Tehsil__c ts;
    
      public static testMethod void test1(){
          
          String RecTypeId= [select Id from RecordType where (Name='Person Account') and (SobjectType='Account')].Id;
        Id RecType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Farmer').getRecordTypeId();
        Id CaseRecType = Schema.SObjectType.Case.getRecordTypeInfosByName().get('UPL General Case').getRecordTypeId();
       
       
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
        
        insert acc;
       
        
        
        Case cs = new case();
            cs.Recordtypeid  = CaseRecType;
            cs.AccountId= acc.id;
            cs.Status = 'Closed-Fo';
            cs.Type = 'Mandi Price';
            cs.Sub_Query__c = 'Mandi Price';
            cs.CreatedDate = system.today();
            insert cs;
            
            Case cs1 = new case();
            cs1.Recordtypeid  = CaseRecType;
            cs1.AccountId = acc.id;
            cs1.Status = 'Escalated-L2';
            cs1.Type = 'Mandi Price';
            cs1.Sub_Query__c = 'Mandi Price';
            cs1.Products_Recommended__c ='PHOSKILL';
            cs1.CreatedDate = system.today()-1;
            
            insert cs1;
            
            Case cs3 = new case();
            cs3.Recordtypeid  = CaseRecType;
            cs3.AccountId= acc.id;
            cs3.Status = 'Closed-Fo';
            cs3.Type = 'Mandi Price';
            cs3.Sub_Query__c = 'Mandi Price';
            cs3.CreatedDate = system.today()-2;
            insert cs3;
            
            Case cs4 = new case();
            cs4.Recordtypeid  = CaseRecType;
            cs4.AccountId= acc.id;
            cs4.Status = 'Escalated-L2';
            cs4.Type = 'Mandi Price';
            cs4.Sub_Query__c = 'Mandi Price';
            cs4.CreatedDate = system.today()-3;
            insert cs4;
            
            Case cs5 = new case();
            cs5.Recordtypeid  = CaseRecType;
            cs5.AccountId= acc.id;
            cs5.Status = 'Escalated-L2';
            cs5.Type = 'Mandi Price';
            cs5.Sub_Query__c = 'Mandi Price';
            cs5.CreatedDate = system.today()-4;
            insert cs5;
            
            
             test.startTest();
               
                ClosureFoBatch obj = new ClosureFoBatch();
                DataBase.executeBatch(obj);
                
             test.stopTest();
         
        }
}