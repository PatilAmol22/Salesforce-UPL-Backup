@isTest 
public class ThisMonthTotalRegistrationBatch_Test{

      public static testMethod void test1(){
      
        //String RecTypeId= [select Id from RecordType where (Name='Person Account') and (SobjectType='Account')].Id;
        Id RecType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Farmer').getRecordTypeId();
       
        Auto_Number__c auto = new Auto_Number__c();
        auto.Name='FarmerCode';
        auto.Sequence__c='19';
        
        insert auto;
        
         // State
         State__c st = new State__c();
         st.name = 'Maharashtra';
         insert st;
        
         // District
         District__c ds = new District__c();
         ds.Name = 'Ahmadnagar';
         ds.State__c= st.id;
         insert ds;
         
         // Village
         Village__c vl = new Village__c(); 
         vl.Name = 'Akola - OTHER Village';
         //vl.id = ts.id;
         //insert vl;
       

         // Tehsil
         Tehsil__c ts = new Tehsil__c();
         ts.Name = 'Akola';
         ts.District__c = ds.id;
         
         insert ts;
         
        
        Account acnt = new account();
        
        acnt.Recordtypeid = RecType;
        acnt.PersonBirthdate = System.today();
        acnt.LastName  = 'Himanshu';
        acnt.Decision_Maker__pc = 'Yes';
        acnt.Crops_Cultivated__pc = 'Other';
        acnt.Crops_Cultivated__pc   = 'Other';
        acnt.SMS_Voice_Msg_Call_Consent__pc= 'No';
         
        acnt.Other_Acerage__pc = '3 or Above';
        acnt.Fruit_Vegetable_Acerage__pc = '1 or Above';
        //acnt.Type_of_farm__c = 'Rainfall';
        acnt.PersonMobilePhone = '1234567890';
        acnt.Birthday_Specified__c = 'Yes'; 
        acnt.Village__pc = vl.id;
        
        insert acnt;  
        
        
        Test.startTest();

            ThisMonthTotalRegistrationBatch obj = new ThisMonthTotalRegistrationBatch ();
            DataBase.executeBatch(obj); 
            
        Test.stopTest();
    }
    
    
    public static testMethod void test2(){
      
        //String RecTypeId= [select Id from RecordType where (Name='Person Account') and (SobjectType='Account')].Id;
        Id RecType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Farmer').getRecordTypeId();
       
        Auto_Number__c auto = new Auto_Number__c();
        auto.Name='FarmerCode';
        auto.Sequence__c='25';
        
        insert auto;
        
         // State
         State__c st = new State__c();
         st.name = 'Andhra Pradesh';
         insert st;
        
         // District
         District__c ds = new District__c();
         ds.Name = 'Guntur';
         ds.State__c= st.id;
         insert ds;
         
         // Village
         Village__c vl = new Village__c(); 
         vl.Name = 'Guntur - OTHER Village';
         //vl.id = ts.id;
         //insert vl;
       

         // Tehsil
         Tehsil__c ts = new Tehsil__c();
         ts.Name = 'Guntur';
         ts.District__c = ds.id;
         
         insert ts;
         
        
        Account acnt = new account();
        
        acnt.Recordtypeid = RecType;
        acnt.PersonBirthdate = System.today();
        acnt.LastName  = 'Himanshu';
        acnt.Decision_Maker__pc = 'Yes';
        acnt.Crops_Cultivated__pc = 'Other';
        acnt.Crops_Cultivated__pc   = 'Other';
        acnt.SMS_Voice_Msg_Call_Consent__pc= 'No';
         
        acnt.Other_Acerage__pc = '3 or Above';
        acnt.Fruit_Vegetable_Acerage__pc = '1 or Above';
        //acnt.Type_of_farm__c = 'Rainfall';
        acnt.PersonMobilePhone = '1234567890';
        acnt.Birthday_Specified__c = 'Yes'; 
        acnt.Village__pc = vl.id;
        
        insert acnt;  
        
        
        Test.startTest();

            ThisMonthTotalRegistrationBatch obj = new ThisMonthTotalRegistrationBatch();
            DataBase.executeBatch(obj); 
            
        Test.stopTest();
    }
}