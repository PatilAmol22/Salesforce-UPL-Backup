@isTest
public class TerritoryAccountShareandDeleteBatchTest{
    static testmethod void myTestMethod1() {
        String RecTypeId= [select Id from RecordType where (Name='Person Account') and (SobjectType='Account')].Id;
        Id RecType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Farmer').getRecordTypeId();
       
       userrole  usrole = new userrole();
        usrole.Name ='TerritoryUser';
        
        Profile p = [SELECT Id,name FROM Profile WHERE Name = 'Territory Manager'];
        
        User sobj1 = new User();
        sobj1.Alias = 'zonaa';                                                            
        sobj1.Email = 'testclass@yopmail.com';                             
        sobj1.ProfileId  = p.ID;                                                     
        sobj1.Username = 'zonal_aaexe1232@upl122333.com.devbox';                                    
        sobj1.IsActive = true;  
        sobj1.LastName='Terriotory Manager';
        sobj1.CommunityNickname = 'zonalExe1222 Di'; 
        sobj1.TimeZoneSidKey = 'Asia/Kolkata'; 
      
        sobj1.LocaleSidKey = 'en_IN';                                    
        sobj1.LanguageLocaleKey = 'en_US';                                             
        sobj1.ForecastEnabled = false;                                                     
        sobj1.EmailEncodingKey = 'ISO-8859-1';    
        sobj1.Show_Inventory__c = false;                                                     
        sobj1.Show_Credit_Limit__c = false; 
        sobj1.UserRoleId=usrole.id;
      
        insert sobj1;
       
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
         
      

         // Tehsil
         Tehsil__c ts1 = new Tehsil__c();
         ts1.Name = 'Akola1';
         ts1.District__c = ds.id;
          insert ts1;
          
          Tehsil__c ts2 = new Tehsil__c();
         ts2.Name = 'Akola2';
         ts2.District__c = ds.id;
          insert ts2;
          
          Tehsil__c ts3 = new Tehsil__c();
         ts3.Name = 'Akola3';
         ts3.District__c = ds.id;
          insert ts3;
         
        Territory_Distributor__c     terr1 = new Territory_Distributor__c();
        terr1.TerritoryCode__c ='003';
        terr1.Name = 'TestTerritory1';
        terr1.TerritoryManager__c = sobj1.id;
        insert  terr1;
        
        Territory_Distributor__c     terr2 = new Territory_Distributor__c();
        terr2.TerritoryCode__c ='004';
        terr2.Name = 'TestTerritory2';
        terr2.TerritoryManager__c = sobj1.id;
        insert  terr2;
        
        Territory_Distributor__c     terr3 = new Territory_Distributor__c();
        terr3.TerritoryCode__c ='005';
        terr3.Name = 'TestTerritory2';
        terr3.TerritoryManager__c = sobj1.id;
        insert  terr3;
        
        DistrictTerritoryMapping__c dt1 = new DistrictTerritoryMapping__c();
        dt1.District__c  = ds.id;
        dt1.Territory__c = terr1.id;
        insert dt1;
        
        DistrictTerritoryMapping__c dt2 = new DistrictTerritoryMapping__c();
        dt2.District__c  = ds.id;
        dt2.Territory__c = terr2.id;
        insert dt2;
        
        DistrictTerritoryMapping__c dt3 = new DistrictTerritoryMapping__c();
        dt3.District__c  = ds.id;
        dt3.Territory__c = terr3.id;
        insert dt3;
        
         Village__c vl = new Village__c(); 
         vl.Name = 'Akola - OTHER Village';
         vl.Tehsil__c = ts1.id;
         insert vl;
        
        Account acnt = new account();
        acnt.Recordtypeid = RecTypeId;
        acnt.PersonBirthdate = System.today();
        acnt.LastName  = 'Himanshu';
        acnt.Decision_Maker__pc = 'Yes';
        acnt.Crops_Cultivated__pc = 'Other';
        acnt.Crops_Cultivated__pc   = 'Other';
        acnt.SMS_Voice_Msg_Call_Consent__pc= 'No';
        acnt.Village__pc = vl.id; 
        acnt.Other_Acerage__pc = '3 or Above';
        acnt.Fruit_Vegetable_Acerage__pc = '1 or Above';
        //acnt.Type_of_farm__c = 'Rainfall';
        acnt.PersonMobilePhone = '1234567890';
        acnt.Birthday_Specified__c = 'Yes'; 
     
        
        insert acnt;  
        
       
        TM_District_Tehsil_Mapping__c mapping = new TM_District_Tehsil_Mapping__c();
        mapping.Tehsil__c = ts3.id;
        mapping.District__c = ds.id;
        mapping.Territory__c = terr1.id;
        mapping.RecordShared__c = True;
        mapping.TM_User__c = sobj1.id;
        insert mapping;
        
        TM_District_Tehsil_Mapping__c mapping2 = new TM_District_Tehsil_Mapping__c();
        mapping2.Tehsil__c = ts2.id;
        mapping2.District__c = ds.id;
        mapping2.Territory__c = terr2.id;
        mapping2.DeleteRequested__c = True;
        mapping2.TM_User__c = sobj1.id;
        insert mapping2;
        
        TM_District_Tehsil_Mapping__c mapping3 = new TM_District_Tehsil_Mapping__c();
        mapping3.Tehsil__c = ts1.id;
        mapping3.District__c = ds.id;
        mapping3.Territory__c = terr3.id;
        mapping3.TM_User__c = sobj1.id;
        insert mapping3;
        
        TerritoryTehsilSchedulerClass test1 = new TerritoryTehsilSchedulerClass('Create');
        TerritoryTehsilSchedulerClass test = new TerritoryTehsilSchedulerClass('Delete');
        
        CallTerritoryTehsilMappingCreate_Batch  sch1 = new CallTerritoryTehsilMappingCreate_Batch ();
        String str1 = '0 15 * * * ?';
        system.schedule('Test Create Territory Tehsil Mapping 1', str1, sch1);

        CallTerritoryTehsilMappingDelete_Batch  sch2 = new CallTerritoryTehsilMappingDelete_Batch();
        String str2 = '0 00 * * * ?';
        system.schedule('Test Delete Tehsil Mapping', str2, sch2);
        
    }
   
}