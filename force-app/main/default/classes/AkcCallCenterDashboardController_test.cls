@isTest
private class AkcCallCenterDashboardController_test{
     static testMethod void testSucess() {
     //Sales_Org_Code__c - where Sales_Org_Code__c  = '1000' done
     //SBU__c - SalesOrg__c  =:salesOrgId 
     //Zone__c
     //Region__c
     //Territory_Distributor__c
     //Akc_Business_dashboard__c
     
     
       Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        
        
        userrole  usrole = new userrole();
        usrole.Name ='Custom Role';
        
        Profile p = [SELECT Id,name FROM Profile WHERE Name = 'Territory Manager'];
        
        User sobj1 = new User();
        sobj1.Alias = 'zonaa';                                                            
        sobj1.Email = 'himanshua.mehta@skinternational.com';                             
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
     Sales_Org__c sorg =new Sales_Org__c();
        sorg.Name='1000';
        sorg.Description__c='India';
        sorg.Sales_Org_Code__c='1000';
        insert sorg;
        
       // Id, SalesOrg__c, Name FROM SBU__c where SalesOrg__c  =:salesOrgId ]
        SBU__c sbu = new SBU__c();
        //sbu.Name = 'SBU-001';
        sbu.SalesOrg__c =sorg.id;
        sbu.SBUCode__c='SBU2';
        insert sbu;  
       //zone 
      // SBU_Name__c, SalesOrg__c, Name FROM Zone__c where SBU_Name__c IN : ListSBU
       Zone__c zone = new Zone__c();
       zone.Name='Ahmedabad';
       zone.ZoneCode__c = 'Z03';
       zone.SalesOrg__c = sorg.id;
       zone.SBUCode__c=sbu.Id; //toggle for else
       insert zone;
       //Region__c
       Region__c region = new Region__c();
          region.Name =  'Kolkata';
          region.Zone__c =zone.id;
          region.SBU__c =  sbu.Id;
          region.RegionHead__c=sobj1.id;
          insert region;
       
       //Territory_Distributor__c
       Territory_Distributor__c ter = new Territory_Distributor__c();
       ter.Name = 'CUTTACK';
       ter.TerritoryCode__c = '150';
       ter.SalesOrg__c=sorg.id;
       ter.SBU__c=sbu.id;
       ter.Zone__c=zone.id;
       ter.Region__c=region.id;
       insert ter;
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
         vl.Fo_Map__c = true;
         //vl.id = ts.id;
         //insert vl;
         
           

         // Tehsil
         Tehsil__c ts = new Tehsil__c();
         ts.Name = 'Akola';
         ts.District__c = ds.id;
         
         insert ts;
         
         // Tehsil
         Tehsil__c ts1 = new Tehsil__c();
         ts1.Name = 'Sangamner';
         ts1.District__c = ds.id;
         
         insert ts1;
         
         
         // Tehsil
         Tehsil__c ts2 = new Tehsil__c();
         ts2.Name = 'Shrirampur';
         ts2.District__c = ds.id;
         
         insert ts2;
         Akc_Business_dashboard__c akcDash = new Akc_Business_dashboard__c();
         akcDash.Tehsil__c = ts2.id;
         akcDash.Territory__c = ter.id;
               akcDash.Total_Registration_Fo_Present__c= 0;
               akcDash.Total_Registration_Non_Fo_Present__c= 0;
               akcDash.Current_Month_Fo_Present__c= 0;
               akcDash.Current_Year_Fo_Present__c= 0; 
               akcDash.Current_Month_Non_Fo_present__c= 0;
               akcDash.Current_Year_Non_Fo_present__c= 0;
               akcDash.Last1DayFoPresent__c= 0;
                akcDash.Last1DayNonFoPresent__c= 0;
                akcDash.Last2DayFoPresent__c= 0;
                akcDash.Last2DayNonFoPresent__c= 0;
                akcDash.Last3DayFoPresent__c= 0;
                akcDash.Last3DayNonFoPresent__c= 0;
                akcDash.Last4DayFoPresent__c= 0;
                akcDash.Last4DayNonFoPresent__c= 0;
                akcDash.Last5DayFoPresent__c= 0;
                akcDash.Last5DayNonFoPresent__c= 0;
                akcDash.Last6DayFoPresent__c= 0;
                akcDash.Last6DayNonFoPresent__c= 0;
                akcDash.Last7DayFoPresent__c= 0;
                akcDash.Last7DayNonFoPresent__c = 0;
                akcDash.Current_month_Fo_present_village__c= 0;
                akcDash.Current_Month_Non_Fo_present_village__c= 0;    
                akcDash.CmPyMtd_Fo_present__c= 0;
                akcDash.CmPyMtd_Non_Fo_present__c= 0;
                akcDash.Current_Year_Fo_Present_village__c= 0;
                akcDash.Current_Year_Non_Fo_Present_village__c= 0;
                akcDash.PyTd_Fo_present__c= 0;
                akcDash.PyTd_Non_Fo_present__c= 0;
                akcDash.Last1DayFOCallType__c= 'Mandiprice-10,test-20,test2-2';
                akcDash.Last1DayNonFOCallType__c= 'Mandiprice-10,test-20,test2-2';
                akcDash.Last2DayFOCallType__c= 'Mandiprice-10,test-20';
                akcDash.Last2DayNonFOCallType__c= 'Mandiprice-10,test-20';
                akcDash.Last3DayFOCallType__c='Mandiprice-10,test-20';
                akcDash.Last3DayNonFOCallType__c= 'Mandiprice-10,test-20';
                akcDash.Last4DayFOCallType__c= 'Mandiprice-10,test-20';
                akcDash.Last4DayNonFOCallType__c= 'Mandiprice-10,test-20';
                akcDash.Last5DayFOCallType__c= 'Mandiprice-10,test-20';
                akcDash.Last5DayNonFOCallType__c= 'Mandiprice-10,test-20';
                akcDash.Last6DayFOCallType__c= 'Mandiprice-10,test-20';
                akcDash.Last6DayNonFOCallType__c= 'Mandiprice-10,test-20';
                akcDash.Last7DayFOCallType__c= 'Mandiprice-10,test-20';
                akcDash.Last7DayNonFOCallType__c= 'Mandiprice-10,test-20';
                akcDash.Sales_lead_Closed_Fo__c= 140;
                akcDash.Sales_lead_Open__c = 10; 
               akcDash.CreatedDate = Date.today().addDays(-1);

                 insert akcDash;
         
          AkcCallCenterDashboardController akc = new AkcCallCenterDashboardController();
         
         
          akc.SBUFilter='SBU-001';
          akc.getContact();
          akc.ZoneFilter ='Ahmedabad';
          akc.getContact();
          
          akc.RegionFilter='Kolkata';
          akc.getContact();
          akc.TerritoryFilter='Kolkata';
          //akc.getContact();
          akc.TehsilFilter='Sangamner';
          akc.getContact();
          
          akc.StateFilter='Maharashtra';
            akc.getContact();
          
           akc.DistrictFilter ='Sangamner';
            akc.getContact();
           akc.TehsilFilter2 ='Sangamner';
           akc.getContact();
        }
         static testMethod void test2(){
           Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        
        
        userrole  usrole = new userrole();
        usrole.Name ='Custom Role';
        
        Profile p = [SELECT Id,name FROM Profile WHERE Name = 'Territory Manager'];
        
        User sobj1 = new User();
        sobj1.Alias = 'zonaa';                                                            
        sobj1.Email = 'himanshua.mehta@skinternational.com';                             
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
     Sales_Org__c sorg =new Sales_Org__c();
        sorg.Name='1000';
        sorg.Description__c='India';
        sorg.Sales_Org_Code__c='1000';
        insert sorg;
        
       // Id, SalesOrg__c, Name FROM SBU__c where SalesOrg__c  =:salesOrgId ]
        SBU__c sbu = new SBU__c();
        //sbu.Name = 'SBU-001';
        sbu.SalesOrg__c =sorg.id;
        sbu.SBUCode__c='SBU2';
        insert sbu;  
       //zone 
      // SBU_Name__c, SalesOrg__c, Name FROM Zone__c where SBU_Name__c IN : ListSBU
       Zone__c zone = new Zone__c();
       zone.Name='Ahmedabad';
       zone.ZoneCode__c = 'Z03';
       zone.SalesOrg__c = sorg.id;
       zone.SBUCode__c=sbu.Id; //toggle for else
       insert zone;
       //Region__c
       Region__c region = new Region__c();
          region.Name =  'Kolkata';
          region.Zone__c =zone.id;
          region.SBU__c =  sbu.Id;
          region.RegionHead__c=sobj1.id;
          insert region;
       
       //Territory_Distributor__c
       Territory_Distributor__c ter = new Territory_Distributor__c();
       ter.Name = 'CUTTACK';
       ter.TerritoryCode__c = '150';
       ter.SalesOrg__c=sorg.id;
       ter.SBU__c=sbu.id;
       ter.Zone__c=zone.id;
       ter.Region__c=region.id;
       insert ter;
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
         vl.Fo_Map__c = true;
         //vl.id = ts.id;
         //insert vl;
         
           

         // Tehsil
         Tehsil__c ts = new Tehsil__c();
         ts.Name = 'Akola';
         ts.District__c = ds.id;
         
         insert ts;
         
         // Tehsil
         Tehsil__c ts1 = new Tehsil__c();
         ts1.Name = 'Sangamner';
         ts1.District__c = ds.id;
         
         insert ts1;
         
         
         // Tehsil
         Tehsil__c ts2 = new Tehsil__c();
         ts2.Name = 'Shrirampur';
         ts2.District__c = ds.id;
         
         insert ts2;
         Akc_Business_dashboard__c akcDash = new Akc_Business_dashboard__c();
         akcDash.Tehsil__c = ts2.id;
         akcDash.Territory__c = ter.id;
               akcDash.Total_Registration_Fo_Present__c= 0;
               akcDash.Total_Registration_Non_Fo_Present__c= 0;
               akcDash.Current_Month_Fo_Present__c= 0;
               akcDash.Current_Year_Fo_Present__c= 0; 
               akcDash.Current_Month_Non_Fo_present__c= 0;
               akcDash.Current_Year_Non_Fo_present__c= 0;
               akcDash.Last1DayFoPresent__c= 0;
                akcDash.Last1DayNonFoPresent__c= 0;
                akcDash.Last2DayFoPresent__c= 0;
                akcDash.Last2DayNonFoPresent__c= 0;
                akcDash.Last3DayFoPresent__c= 0;
                akcDash.Last3DayNonFoPresent__c= 0;
                akcDash.Last4DayFoPresent__c= 0;
                akcDash.Last4DayNonFoPresent__c= 0;
                akcDash.Last5DayFoPresent__c= 0;
                akcDash.Last5DayNonFoPresent__c= 0;
                akcDash.Last6DayFoPresent__c= 0;
                akcDash.Last6DayNonFoPresent__c= 0;
                akcDash.Last7DayFoPresent__c= 0;
                akcDash.Last7DayNonFoPresent__c = 0;
                akcDash.Current_month_Fo_present_village__c= 0;
                akcDash.Current_Month_Non_Fo_present_village__c= 0;    
                akcDash.CmPyMtd_Fo_present__c= 0;
                akcDash.CmPyMtd_Non_Fo_present__c= 0;
                akcDash.Current_Year_Fo_Present_village__c= 0;
                akcDash.Current_Year_Non_Fo_Present_village__c= 0;
                akcDash.PyTd_Fo_present__c= 0;
                akcDash.PyTd_Non_Fo_present__c= 0;
                akcDash.Last1DayFOCallType__c= 'Mandiprice-10,test-20,test2-2';
                akcDash.Last1DayNonFOCallType__c= 'Mandiprice-10,test-20,test2-2';
                akcDash.Last2DayFOCallType__c= 'Mandiprice-10,test-20';
                akcDash.Last2DayNonFOCallType__c= 'Mandiprice-10,test-20';
                akcDash.Last3DayFOCallType__c='Mandiprice-10,test-20';
                akcDash.Last3DayNonFOCallType__c= 'Mandiprice-10,test-20';
                akcDash.Last4DayFOCallType__c= 'Mandiprice-10,test-20';
                akcDash.Last4DayNonFOCallType__c= 'Mandiprice-10,test-20';
                akcDash.Last5DayFOCallType__c= 'Mandiprice-10,test-20';
                akcDash.Last5DayNonFOCallType__c= 'Mandiprice-10,test-20';
                akcDash.Last6DayFOCallType__c= 'Mandiprice-10,test-20';
                akcDash.Last6DayNonFOCallType__c= 'Mandiprice-10,test-20';
                akcDash.Last7DayFOCallType__c= 'Mandiprice-10,test-20';
                akcDash.Last7DayNonFOCallType__c= 'Mandiprice-10,test-20';
                akcDash.Sales_lead_Closed_Fo__c= 140;
                akcDash.Sales_lead_Open__c = 10; 
               akcDash.CreatedDate = Date.today().addDays(-1);

                 insert akcDash;
         
          AkcCallCenterDashboardController akc = new AkcCallCenterDashboardController();
         
         
          
          akc.StateFilter='Maharashtra';
            //akc.getContact();
          
           akc.DistrictFilter ='Ahmadnagar';
            //akc.getContact();
           akc.TehsilFilter2 ='Shrirampur';
           akc.getContact();
         
         }
        
     static testMethod void testError() {
       Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        
        
        userrole  usrole = new userrole();
        usrole.Name ='Custom Role';
        
        Profile p = [SELECT Id,name FROM Profile WHERE Name = 'Territory Manager'];
        
        User sobj1 = new User();
        sobj1.Alias = 'zonaa';                                                            
        sobj1.Email = 'himanshua.mehta@skinternational.com';                             
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
     Sales_Org__c sorg =new Sales_Org__c();
        sorg.Name='1000';
        sorg.Description__c='India';
        sorg.Sales_Org_Code__c='1000';
        insert sorg;
        
       // Id, SalesOrg__c, Name FROM SBU__c where SalesOrg__c  =:salesOrgId ]
        SBU__c sbu = new SBU__c();
        //sbu.Name = 'SBU-001';
        sbu.SalesOrg__c =sorg.id;
        sbu.SBUCode__c='SBU2';
        insert sbu;  
       //zone 
      // SBU_Name__c, SalesOrg__c, Name FROM Zone__c where SBU_Name__c IN : ListSBU
       Zone__c zone = new Zone__c();
       zone.Name='Ahmedabad';
       zone.ZoneCode__c = 'Z03';
       zone.SalesOrg__c = sorg.id;
       zone.SBUCode__c=sbu.Id; //toggle for else
       insert zone;
       //Region__c
       Region__c region = new Region__c();
          region.Name =  'Kolkata';
          region.Zone__c =zone.id;
          region.SBU__c =  sbu.Id;
          region.RegionHead__c=sobj1.id;
          insert region;
       
       //Territory_Distributor__c
       Territory_Distributor__c ter = new Territory_Distributor__c();
       ter.Name = 'CUTTACK';
       ter.TerritoryCode__c = '150';
       ter.SalesOrg__c=sorg.id;
       ter.SBU__c=sbu.id;
       ter.Zone__c=zone.id;
       ter.Region__c=region.id;
       insert ter;
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
         vl.Fo_Map__c = true;
         //vl.id = ts.id;
         //insert vl;
         
           

         // Tehsil
         Tehsil__c ts = new Tehsil__c();
         ts.Name = 'Akola';
         ts.District__c = ds.id;
         
         insert ts;
         
         // Tehsil
         Tehsil__c ts1 = new Tehsil__c();
         ts1.Name = 'Sangamner';
         ts1.District__c = ds.id;
         
         insert ts1;
         
         
         // Tehsil
         Tehsil__c ts2 = new Tehsil__c();
         ts2.Name = 'Shrirampur';
         ts2.District__c = ds.id;
         
         insert ts2;
         Akc_Business_dashboard__c akcDash = new Akc_Business_dashboard__c();
         akcDash.Tehsil__c = ts2.id;
         akcDash.Territory__c = ter.id;
               akcDash.Total_Registration_Fo_Present__c= 0;
               akcDash.Total_Registration_Non_Fo_Present__c= 0;
               akcDash.Current_Month_Fo_Present__c= 0;
               akcDash.Current_Year_Fo_Present__c= 0; 
               akcDash.Current_Month_Non_Fo_present__c= 0;
               akcDash.Current_Year_Non_Fo_present__c= 0;
               akcDash.Last1DayFoPresent__c= 0;
                akcDash.Last1DayNonFoPresent__c= 0;
                akcDash.Last2DayFoPresent__c= 0;
                akcDash.Last2DayNonFoPresent__c= 0;
                akcDash.Last3DayFoPresent__c= 0;
                akcDash.Last3DayNonFoPresent__c= 0;
                akcDash.Last4DayFoPresent__c= 0;
                akcDash.Last4DayNonFoPresent__c= 0;
                akcDash.Last5DayFoPresent__c= 0;
                akcDash.Last5DayNonFoPresent__c= 0;
                akcDash.Last6DayFoPresent__c= 0;
                akcDash.Last6DayNonFoPresent__c= 0;
                akcDash.Last7DayFoPresent__c= 0;
                akcDash.Last7DayNonFoPresent__c = 0;
                akcDash.Current_month_Fo_present_village__c= 0;
                akcDash.Current_Month_Non_Fo_present_village__c= 0;    
                akcDash.CmPyMtd_Fo_present__c= 0;
                akcDash.CmPyMtd_Non_Fo_present__c= 0;
                akcDash.Current_Year_Fo_Present_village__c= 0;
                akcDash.Current_Year_Non_Fo_Present_village__c= 0;
                akcDash.PyTd_Fo_present__c= 0;
                akcDash.PyTd_Non_Fo_present__c= 0;
              /*  akcDash.Last1DayFOCallType__c= '';
                akcDash.Last1DayNonFOCallType__c= '';
                akcDash.Last2DayFOCallType__c= '';
                akcDash.Last2DayNonFOCallType__c= '';
                akcDash.Last3DayFOCallType__c='';
                akcDash.Last3DayNonFOCallType__c= '';
                akcDash.Last4DayFOCallType__c= '';
                akcDash.Last4DayNonFOCallType__c= '';
                akcDash.Last5DayFOCallType__c= '';
                akcDash.Last5DayNonFOCallType__c= '';
                akcDash.Last6DayFOCallType__c= '';
                akcDash.Last6DayNonFOCallType__c= '';
                akcDash.Last7DayFOCallType__c= '';
                akcDash.Last7DayNonFOCallType__c= '';*/
                akcDash.Sales_lead_Closed_Fo__c= 140;
                akcDash.CreatedDate = Date.today().addDays(-1);

                akcDash.Sales_lead_Open__c = 10; 
                 insert akcDash;
         
          AkcCallCenterDashboardController akc = new AkcCallCenterDashboardController();
         
         
          akc.SBUFilter='';
          akc.getContact();
          akc.ZoneFilter ='';
          akc.getContact();
          
          akc.RegionFilter='';
          akc.getContact();
          akc.TerritoryFilter='';
        //  akc.getContact();
          akc.TehsilFilter='';
          akc.getContact();
    }
    
}