@isTest
public class CallRegistration_Test{
    
      private static testMethod void test1(){
        
        String RecTypeId= [select Id from RecordType where (Name='Person Account') and (SobjectType='Account')].Id;
        Id RecType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Farmer').getRecordTypeId();
        Id CaseRecType = Schema.SObjectType.Case.getRecordTypeInfosByName().get('AKC General Case').getRecordTypeId();
       
        Auto_Number__c auto = new Auto_Number__c();
        auto.Name='FarmerCodetest';
        auto.Sequence__c='67';
        
        insert auto;
        
        Trigger_Settings__c tsObj1 = new Trigger_Settings__c();
        tsObj1.Name = 'CaseTrigger';
        tsObj1.isActive__c = True;
        insert tsObj1;
        
         // State
         State__c st = new State__c();
         st.name = 'state1';
         insert st;
        
         // District
         District__c ds = new District__c();
         ds.Name = 'dist1';
         ds.State__c= st.id;
         insert ds;
         
         // Tehsil
         Tehsil__c ts = new Tehsil__c();
         ts.Name = 'tehsil1';
         ts.District__c = ds.id;
         insert ts;
         
         // Village
         Village__c vl = new Village__c(); 
         vl.Name = 'village1';
         vL.Fo_Map__c = true;
         vl.Tehsil__c = ts.id;
         insert vl;
       

         
         
        
        contact  acnt = new contact();
        
        //acnt.Recordtypeid = RecTypeId;
      //  acnt.PersonBirthdate = System.today();
        acnt.FirstName = 'Himanshu';
        acnt.LastName  = 'Mehta';
        acnt.Decision_Maker__c = 'Yes';
        acnt.Crops_Cultivated__c = 'Other';
        acnt.Crops_Cultivated__c   = 'Other';
        acnt.SMS_Voice_Msg_Call_Consent__c= 'No';
        acnt.Other_Acerage__c = '3 or Above';
        acnt.Fruit_Vegetable_Acerage__c = '1 or Above';
        //acnt.Type_of_farm__c = 'Rainfall';
      //  acnt.PersonMobilePhone = '918149296266';
       // acnt.Birthday_Specified__c = 'Yes'; 
        acnt.Village__c = vl.id;
        
        insert acnt;  
        
        
        Case cs = new case();
        cs.Recordtypeid  = CaseRecType;
        cs.Contactid = acnt.id;
        cs.Status = 'New';
        cs.Type = 'Mandi Price';
        cs.Sub_Query__c = 'Mandi Price';
        //cs.CreatedDate = system.today();
        cs.Crop_pick__c ='Crop';
        insert cs;
        
        
         test.startTest();
           Test.setReadOnlyApplicationMode(true);
           CallRegistration.IncomingCalls();
           Test.setReadOnlyApplicationMode(false);
        test.stopTest();
    
    }
    
      private static testMethod void test2(){
        
        String RecTypeId= [select Id from RecordType where (Name='Person Account') and (SobjectType='Account')].Id;
        Id RecType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Farmer').getRecordTypeId();
        Id CaseRecType = Schema.SObjectType.Case.getRecordTypeInfosByName().get('AKC General Case').getRecordTypeId();
       
        Auto_Number__c auto = new Auto_Number__c();
        auto.Name='FarmerCodetestdata';
        auto.Sequence__c='77';
        
        insert auto;
        
        Trigger_Settings__c tsObj1 = new Trigger_Settings__c();
        tsObj1.Name = 'CaseTrigger';
        tsObj1.isActive__c = True;
        insert tsObj1;
        
        
         // State
         State__c st = new State__c();
         st.name = 'state1';
         insert st;
        
         // District
         District__c ds = new District__c();
         ds.Name = 'dist1';
         ds.State__c= st.id;
         insert ds;
         
         // Tehsil
         Tehsil__c ts = new Tehsil__c();
         ts.Name = 'tehsil1';
         ts.District__c = ds.id;
         insert ts;
         
         // Village
         Village__c vl = new Village__c(); 
         vl.Name = 'village1';
         vL.Fo_Map__c = false;
         vl.Tehsil__c = ts.id;
         insert vl;
       

         
         
        
        contact  acnt = new contact();
        
        //acnt.Recordtypeid = RecTypeId;
      //  acnt.PersonBirthdate = System.today();
        acnt.FirstName = 'Himanshu';
        acnt.LastName  = 'Mehta';
        acnt.Decision_Maker__c = 'Yes';
        acnt.Crops_Cultivated__c = 'Other';
        acnt.Crops_Cultivated__c   = 'Other';
        acnt.SMS_Voice_Msg_Call_Consent__c= 'No';
        acnt.Other_Acerage__c = '3 or Above';
        acnt.Fruit_Vegetable_Acerage__c = '1 or Above';
        //acnt.Type_of_farm__c = 'Rainfall';
      //  acnt.PersonMobilePhone = '918149296266';
       // acnt.Birthday_Specified__c = 'Yes'; 
        acnt.Village__c = vl.id;
        
        insert acnt;  
        
        
        Case cs = new case();
        cs.Recordtypeid  = CaseRecType;
        cs.Contactid = acnt.id;
        cs.Status = 'New';
        cs.Type = 'Mandi Price';
        cs.Sub_Query__c = 'Mandi Price';
        //cs.CreatedDate = system.today();
        cs.Crop_pick__c ='Crop';
        insert cs;
        
        
         test.startTest();
           Test.setReadOnlyApplicationMode(true);
           CallRegistration.IncomingCalls();
           Test.setReadOnlyApplicationMode(false);
        test.stopTest();
    
    }
    
}