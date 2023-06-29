@isTest
public class AccountAutoSequenceTriggerTest {

    /*static testMethod void Method(){
        Auto_Number__c auto = new Auto_Number__c();
        auto.Name='FarmerCode';
        auto.Sequence__c='11';
        
        insert auto;
        
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
        
        
    }
    static testMethod void Method1(){
        userrole  usrole = new userrole();
        usrole.Name ='Territory Manager Pune - Pusad';
        //insert usrole;
             
        Profile p = [SELECT Id,name FROM Profile WHERE Name = 'Uni View Profile'];
     
        //User u3 = [SELECT Id FROM User WHERE UserName='newuser@testorg.com'];
             User sobj1 = new User();
            sobj1.Alias = 'zonaa';                                                            
            sobj1.Email = 'himanshua.mehta@skinternational.com';                             
            sobj1.ProfileId  = p.ID;                                                     
            sobj1.Username = 'zonal_aaexe@upl122333.com.devbox';                                    
            sobj1.IsActive = true;  
            sobj1.LastName='Zonal Commercial Executive';
            sobj1.CommunityNickname = 'zonalExe Di'; 
            sobj1.TimeZoneSidKey = 'Asia/Kolkata';             // Time Zone
            sobj1.LocaleSidKey = 'en_IN';                                    
            sobj1.LanguageLocaleKey = 'en_US';                                             // Language
            sobj1.ForecastEnabled = false;                                                      // Allow Forecasting
            sobj1.EmailEncodingKey = 'ISO-8859-1';    // Email Encoding
            sobj1.Show_Inventory__c = false;                                                     // Show Inventory
            sobj1.Show_Credit_Limit__c = false; 
            sobj1.UserRoleId=usrole.id;
            //sobj1.ZonalCommercialExecutive__c = 
            insert sobj1;

            
            User sobj = new User();
            sobj.Alias = 'zona';                                                            
            sobj.Email = 'himanshu.mehta@skinternational.com';                             
            sobj.ProfileId  = p.ID;                                                     
            sobj.Username = 'zonal_exe@upl122333.com.devbox';                                    
            sobj.IsActive = true;  
            sobj.LastName='Zonal Commercial Executive';
            sobj.CommunityNickname = 'zonalExe Diiii'; 
            sobj.TimeZoneSidKey = 'Asia/Kolkata';             // Time Zone
            sobj.LocaleSidKey = 'en_IN';                                    
            sobj.LanguageLocaleKey = 'en_US';                                             // Language
            sobj.ForecastEnabled = false;                                                      // Allow Forecasting
            sobj.EmailEncodingKey = 'ISO-8859-1';    // Email Encoding
            sobj.Show_Inventory__c = false;                                                     // Show Inventory
            sobj.Show_Credit_Limit__c = false; 
            sobj.UserRoleId=usrole.id;
            sobj.ZonalCommercialExecutive__c = sobj1.id;
            sobj.ZonalHead__c= sobj1.id;
            sobj.RegionalManager__c=sobj1.id;
            insert sobj;

        
        System.runas(sobj){
        Auto_Number__c auto = new Auto_Number__c();
        auto.Name='FarmerCode';
        auto.Sequence__c='11';
        insert auto;
        
        Price_Group_Master__c pg = new Price_Group_Master__c ();
        pg.PG_Code__c='03';
        insert Pg;
            
            Depot__c dp =new Depot__c ();
            dp.Name='Pune';
            dp.Country__c='India';
            dp.Location__c='Pune';
            dp.Depot_Code__c='PUN1';
            insert dp;
            
        
   
        
        
        Account acc = new account();
        acc.RecordTypeId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
      
        acc.Mobile__c='9869457515';
        acc.Email__c='test@gmail.com';
        acc.Phone='1010101004';
        acc.BillingStreet='test';
        acc.BillingCity='test';
        acc.BillingState='test';
        acc.BillingPostalCode='test';
        acc.BillingCountry='test';
        acc.PriceGroupCode__c=Pg.Id;
        acc.Last_Name__c='test';
        acc.First_Name__c='test';
        acc.Name='test';
        acc.OwnerId=sobj.Id;
        acc.Middle_Name__c='tets';
        acc.Salutation__c='Mr.';
        insert acc;
       
              Distributor_Depot_Mapping__c dsMap =new Distributor_Depot_Mapping__c();
            dsMap.Distributor__c = acc.id;
            dsMap.Depot__c=dp.Id;
            insert dsMap;
            
            
            
        
        AccountTeamMember ca = new AccountTeamMember();
        ca.AccountId = acc.Id;
        ca.TeamMemberRole = 'ZonalCommercialExecutive';
        ca.UserId =acc.ownerid;
        insert ca;
       // acctMembers.add(ca);
       }

    }*/

}