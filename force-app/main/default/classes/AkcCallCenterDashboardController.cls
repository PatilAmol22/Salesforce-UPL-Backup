public with sharing class AkcCallCenterDashboardController{
    public transient Set<String>ListCountry;
    public transient Set<String>ListSBU{get;Set;}
    public transient Set<String>ListState{get;Set;}
    
    public transient Set<String>ListTer;
    public transient Set<String>ListReg;
    public transient Set<String>ListZone;
    public transient Set<String>ListTehsil;
    transient Set<String>ListSBUFilter;
    transient Set<String>ListTerFilter;
    transient Set<String>ListRegFilter;
    transient  Set<String>ListZoneFilter;
    transient Set<String>ListTehsilFilter;
   
    public transient  List<List<Akc_Business_dashboard__c>>nestedTerritoryCountList{get;set;}
    public transient String SBUFilter{get;Set;}
    public transient String ZoneFilter{get;Set;}
    public transient String RegionFilter{get;Set;}
    public transient String TerritoryFilter{get;Set;}
    public transient String TehsilFilter{get;Set;}
    /*State wise filter*/
      public transient String StateFilter{get;Set;}
        public transient String DistrictFilter{get;Set;}
          public transient String TehsilFilter2{get;Set;}
    /**/
    
    public transient Set<String> DistrictList{get;Set;}
    
    public transient List<Akc_Business_dashboard__c>territoryCountList;
    public transient List<Akc_Business_dashboard__c> abdc{get;set;} 
    public transient String  Total_Registration{get;set;}
    private Map<String, set<String>> sbu_zone = new Map<String, set<String>>();
    public transient String sbu_zone_map_str{get;Set;}
    
    transient Map<String, set<String>> zone_region = new Map<String, set<String>>();
    public transient String zone_region_map_str{get;Set;}
    
    transient Map<String, set<String>> region_terirorry = new Map<String, set<String>>();
    public transient String region_terirorry_map_str{get;Set;}
    
    transient Map<String, set<String>> terirorry_tehsil = new Map<String, set<String>>();
    public transient String terirorry_tehsil_map_str{get;Set;}
    
    
    public transient String last7DaysCallTypeFO{get;set;}
    public MAP<String,List<Integer>> last7DaysCallTypeFOMap = new Map<String,List<Integer>>();
    
    public transient String last7DaysCallTypeNONFO{get;set;}
    public MAP<String,List<Integer>> last7DaysCallTypeNONFOMap = new Map<String,List<Integer>>(); 
    
    transient Map<String, set<String>> state_district = new Map<String, set<String>>();
    public transient String state_district_map_str{get;Set;}
    
    transient Map<String, set<String>> district_tehsil = new Map<String, set<String>>();
    public transient String district_tehsil_map_str{get;Set;}
    
    
    transient Integer filteFlag= 0; 
    public transient DateTime lastCreateddate{get;set;}
    public AkcCallCenterDashboardController(){
        territoryCountList = new List<Akc_Business_dashboard__c>();
        
        List<List<Akc_Business_dashboard__c>>nestedTerritoryCountList = new List<List<Akc_Business_dashboard__c>>();
       
        Total_Registration ='';
        StateFilter = '';
        DistrictFilter = '';
        lastCreateddate = System.now();
        sbu_zone_map_str='';
        zone_region_map_str='';
        terirorry_tehsil_map_str='';
        region_terirorry_map_str='';
        TehsilFilter2 = '';
        ListCountry = new Set<String>();
        ListSBU = new Set<String>();
        ListState =new Set<String>(); 
        ListTer = new Set<String>();
        ListReg = new Set<String>();
        ListZone = new Set<String>();
        ListTehsil = new Set<String>();
        DistrictList =new Set<String>(); 
        ListSBUFilter = new Set<String>();
        ListTerFilter = new Set<String>();
        ListRegFilter = new Set<String>();
        ListZoneFilter = new Set<String>();
        ListTehsilFilter = new Set<String>();
        List<Akc_Business_dashboard__c>Akc_Business_dashboardList = new List <Akc_Business_dashboard__c>();
        Akc_Business_dashboardList = [SELECT Id, CreatedDate FROM Akc_Business_dashboard__c ORDER BY CreatedDate DESC LIMIT 1];
       if(Akc_Business_dashboardList.size()>0){
           lastCreateddate = Akc_Business_dashboardList[0].CreatedDate;
       } 
        
        ZoneFilter='';SBUFilter='';state_district_map_str='';
        RegionFilter='';TerritoryFilter='';
        last7DaysCallTypeNONFO = '';
        last7DaysCallTypeFO = '';
       //  Sales_Org__c - Sales_Org_Code__c =1000;
        Id salesOrgId = [SELECT Id, Sales_Org_Code__c FROM Sales_Org__c where Sales_Org_Code__c  = '1000'][0].Id;
        //SBU__c
         
        for(State__c state :[SELECT Id, Name, Country__c, Active__c FROM State__c where Country_Code__c ='91']){
           ListState.add(state.Name);
        }
        
        for(District__c dis:[SELECT Id, Name, State__r.Name, State_Code__c, Active__c, District_Code__c FROM District__c where State__r.name IN: ListState]){
               DistrictList.add(dis.Name);
           if(state_district.containsKey(dis.State__r.Name)){
              state_district.get(dis.State__r.Name).add(dis.Name);  
            }else{
            set<String>srtLst = new set<String>();
                srtLst.add(dis.Name);
                state_district.put(dis.State__r.Name,srtLst);
            }  
        }
       
       for(Tehsil__c dis:[SELECT Id, District__r.Name, Name,State__c FROM Tehsil__c where District__r.Name IN: DistrictList]){
               
           if(district_tehsil.containsKey(dis.District__r.Name)){
              district_tehsil.get(dis.District__r.Name).add(dis.Name);  
            }else{
            set<String>srtLst = new set<String>();
                srtLst.add(dis.Name);
                district_tehsil.put(dis.District__r.Name,srtLst);
            }  
        }
       
        for(SBU__c sbu: [SELECT Id, SalesOrg__c, Name FROM SBU__c where SalesOrg__c  =:salesOrgId ]){
            ListSBU.add(sbu.Name);

        }
        for(Zone__c  zone:[SELECT Id,SBU_Name__c, SalesOrg__c, Name FROM Zone__c where SBU_Name__c IN : ListSBU]){
            ListZone.add(zone.Name);  
           if(sbu_zone.containsKey(zone.SBU_Name__c)){
              sbu_zone.get(zone.SBU_Name__c).add(zone.Name);  
            }else{
            set<String>srtLst = new set<String>();
                srtLst.add(zone.Name);
                sbu_zone.put(zone.SBU_Name__c,srtLst);
            }  
        }
        for( Region__c  reg: [SELECT Sales_Org_Code__c, Zone__r.Name,Id, Name, SBU__c FROM Region__c where SBU__r.name IN : ListSBU AND RegionHeadActive__c =true]){
            ListReg.add(reg.Name);
            if(zone_region.containsKey(reg.Zone__r.Name)){
              zone_region.get(reg.Zone__r.Name).add(reg.Name);  
            }else{
            set<String>srtLst = new set<String>();
                srtLst.add(reg.Name);
                zone_region.put(reg.Zone__r.Name,srtLst);
            }  
        }
        for(Territory_Distributor__c ter : [SELECT Id,Name, SBU__r.Name, Zone__r.Name, TerritoryCode__c, Region__r.Name FROM Territory_Distributor__c where SBU__r.Name IN : ListSBU]){
            ListTer.add(ter.Name);
            //region_terirorry
            if(region_terirorry.containsKey(ter.Region__r.Name)){
              region_terirorry.get(ter.Region__r.Name).add(ter.Name);  
            }else{
            set<String>srtLst = new set<String>();
                srtLst.add(ter.Name);
                region_terirorry.put(ter.Region__r.Name,srtLst);
            }  
        }
        
        for(Akc_Business_dashboard__c ter : [SELECT Id, SBUName__c, Tehsil__r.name,Territory__r.name FROM Akc_Business_dashboard__c where CreatedDate = YESTERDAY AND Tehsil__r.name!='null' AND Territory__r.name !='']){
            //system.debug(ter);
            //region_terirorry
            if(terirorry_tehsil.containsKey(ter.Territory__r.name)){
              terirorry_tehsil.get(ter.Territory__r.name).add(ter.Tehsil__r.name);  
            }else{
            set<String>srtLst = new set<String>();
                srtLst.add(ter.Tehsil__r.name);
                terirorry_tehsil.put(ter.Territory__r.name,srtLst);
            }  
        }
        
        /*
       
        */
         terirorry_tehsil_map_str= JSON.serialize(terirorry_tehsil);
        territoryCountList = [SELECT Tehsil_Code__c,District_Code__c,State__c,State_Code__c,Tehsil__r.name,Tehsil_Count__c,District_Name__c,Number_of_Calls_MTD__c,Number_of_Calls_YTD__c,Number_of_Caller_MTD__c,Number_of_Caller_YTD__c FROM Akc_Business_dashboard__c where CreatedDate = YESTERDAY  ORDER BY Tehsil__r.name];
        /*nested list*/
        
         
        /*nested list end */
        
        getContact();
    }
    public void getContact(){
        // Total Registration
        abdc = new List<Akc_Business_dashboard__c>();
        ListSBUFilter = new Set<String>();
        ListTerFilter = new Set<String>();
        ListRegFilter = new Set<String>();
        ListZoneFilter = new Set<String>();
        ListTehsilFilter = new Set<String>();
     Set<String> ListStateFilter = new Set<String>();
     Set<String> ListDistrictFilter = new Set<String>();
       Set<String>ListTehsil2Filter = new Set<String>();
        system.debug(abdc.size());
        system.debug(SBUFilter);
        system.debug(ZoneFilter);
        system.debug(RegionFilter);
        system.debug(TerritoryFilter);
        system.debug(TehsilFilter);
         last7DaysCallTypeNONFO = '';
        last7DaysCallTypeFO = '';
                   Total_Registration = JSON.serialize( new Total_Registration());
                   
                   
                   
                   
        if(StateFilter.length()>0){

                for(String s : StateFilter.split(',')){
                    ListStateFilter.add(s);
                }
                filteFlag =6;
        
        }
        if(DistrictFilter.length()>0 && StateFilter.length()>0){
            for(String s : DistrictFilter.split(',')){
                    ListDistrictFilter.add(s);
                }
            filteFlag =7;
        }
        if(TehsilFilter2.length()>0 && DistrictFilter.length()>0 && StateFilter.length()>0){
            for(String s : TehsilFilter2.split(',')){
                ListTehsil2Filter.add(s);
            }
      
        filteFlag =8;
        }           
        if(SBUFilter.length()>0){
            for(String s : SBUFilter.split(',')){
                ListSBUFilter.add(s);
            }
                filteFlag =1;
        }
        if(SBUFilter.length()>0 && ZoneFilter.length()>0 ){
             for(String s : ZoneFilter.split(',')){
                ListZoneFilter.add(s);
            }
            filteFlag =2;
        }
        if(SBUFilter.length()>0 && ZoneFilter.length()>0 && RegionFilter.length()>0){
            for(String s : RegionFilter.split(',')){
                ListRegFilter.add(s);
            }
            filteFlag =3;
        }
        if(SBUFilter.length()>0 && ZoneFilter.length()>0 && RegionFilter.length()>0 && TerritoryFilter.length()>0){
            for(String s : TerritoryFilter.split(',')){
                ListTerFilter.add(s);
            }
            filteFlag =4;
        }
        if(SBUFilter.length()>0 && ZoneFilter.length()>0 && RegionFilter.length()>0 && TerritoryFilter.length()>0 && TehsilFilter.length()>0){
            for(String s : TehsilFilter.split(',')){
                ListTehsilFilter.add(s);
            }
            filteFlag =5;
        
        }
        
        system.debug('filteFlag  - '+filteFlag );
        
        

        
        if(filteFlag == 0){
        System.debug('All filter..');
        abdc = new List<Akc_Business_dashboard__c >();
abdc = [SELECT CreatedDate, Id ,Total_Registration_Fo_Present__c,Total_Registration_Non_Fo_Present__c,Current_Month_Fo_Present__c, Current_Year_Fo_Present__c, Current_Month_Non_Fo_present__c, Current_Year_Non_Fo_present__c,Last1DayFoPresent__c,
                Last1DayNonFoPresent__c,
                Last2DayFoPresent__c,
                Last2DayNonFoPresent__c,
                Last3DayFoPresent__c,
                Last3DayNonFoPresent__c,
                Last4DayFoPresent__c,
                Last4DayNonFoPresent__c,
                Last5DayFoPresent__c,
                Last5DayNonFoPresent__c,
                Last6DayFoPresent__c,
                Last6DayNonFoPresent__c,
                Last7DayFoPresent__c,
                Last7DayNonFoPresent__c ,
                Current_month_Fo_present_village__c,
                Current_Month_Non_Fo_present_village__c,    
                CmPyMtd_Fo_present__c,
                CmPyMtd_Non_Fo_present__c,
                Current_Year_Fo_Present_village__c,
                Current_Year_Non_Fo_Present_village__c,
                PyTd_Fo_present__c,
                PyTd_Non_Fo_present__c,
                    Last1DayFOCallType__c,
                    Last1DayNonFOCallType__c,
                    Last2DayFOCallType__c,
                    Last2DayNonFOCallType__c,
                    Last3DayFOCallType__c,
                    Last3DayNonFOCallType__c,
                    Last4DayFOCallType__c,
                    Last4DayNonFOCallType__c,
                    Last5DayFOCallType__c,
                    Last5DayNonFOCallType__c,
                    Last6DayFOCallType__c,
                    Last6DayNonFOCallType__c,
                    Last7DayFOCallType__c,
                    Last7DayNonFOCallType__c,
                    Sales_lead_Closed_Fo__c,
                    Sales_lead_Open__c
                                FROM Akc_Business_dashboard__c where CreatedDate = YESTERDAY AND Tehsil__r.name!='null' AND Territory__r.name !='' order by CreatedDate DESC ];
        
}
if(filteFlag == 1){//SBU
 System.debug('SBU filter..');
 system.debug(ListSBUFilter);
  abdc = new List<Akc_Business_dashboard__c >();
abdc = [SELECT CreatedDate, Id ,Total_Registration_Fo_Present__c,Total_Registration_Non_Fo_Present__c,Current_Month_Fo_Present__c, Current_Year_Fo_Present__c, Current_Month_Non_Fo_present__c, Current_Year_Non_Fo_present__c,Last1DayFoPresent__c,
                Last1DayNonFoPresent__c,
                Last2DayFoPresent__c,
                Last2DayNonFoPresent__c,
                Last3DayFoPresent__c,
                Last3DayNonFoPresent__c,
                Last4DayFoPresent__c,
                Last4DayNonFoPresent__c,
                Last5DayFoPresent__c,
                Last5DayNonFoPresent__c,
                Last6DayFoPresent__c,
                Last6DayNonFoPresent__c,
                Last7DayFoPresent__c,
                Last7DayNonFoPresent__c ,
                Current_month_Fo_present_village__c,
                Current_Month_Non_Fo_present_village__c,    
                CmPyMtd_Fo_present__c,
                CmPyMtd_Non_Fo_present__c,
                Current_Year_Fo_Present_village__c,
                Current_Year_Non_Fo_Present_village__c,
                PyTd_Fo_present__c,
                PyTd_Non_Fo_present__c,
                Last1DayFOCallType__c,
                Last1DayNonFOCallType__c,
                Last2DayFOCallType__c,
                Last2DayNonFOCallType__c,
                Last3DayFOCallType__c,
                Last3DayNonFOCallType__c,
                Last4DayFOCallType__c,
                Last4DayNonFOCallType__c,
                Last5DayFOCallType__c,
                Last5DayNonFOCallType__c,
                Last6DayFOCallType__c,
                Last6DayNonFOCallType__c,
                Last7DayFOCallType__c,
                Last7DayNonFOCallType__c,
                Sales_lead_Closed_Fo__c,
                Sales_lead_Open__c
                FROM Akc_Business_dashboard__c 
                where CreatedDate = YESTERDAY AND (Tehsil__r.name!='null' AND Territory__r.name !='')
                AND(SBUName__c IN :ListSBUFilter)
                                order by CreatedDate DESC ];
       territoryCountList = [SELECT Tehsil_Code__c,District_Code__c,State__c,State_Code__c,Tehsil__r.name,Tehsil_Count__c,District_Name__c,Number_of_Calls_MTD__c,Number_of_Calls_YTD__c,Number_of_Caller_MTD__c,Number_of_Caller_YTD__c FROM Akc_Business_dashboard__c  where CreatedDate = YESTERDAY AND (Tehsil__r.name!='null' AND Territory__r.name !='')
                AND(SBUName__c IN :ListSBUFilter) ORDER BY Tehsil__r.name];
        
}
if(filteFlag == 2){//SBU-Zone
//System.debug('SBU-Zone filter..');
abdc = new List<Akc_Business_dashboard__c >();
abdc = [SELECT CreatedDate, Id ,Total_Registration_Fo_Present__c,Total_Registration_Non_Fo_Present__c,Current_Month_Fo_Present__c, Current_Year_Fo_Present__c, Current_Month_Non_Fo_present__c, Current_Year_Non_Fo_present__c,Last1DayFoPresent__c,
                Last1DayNonFoPresent__c,
                Last2DayFoPresent__c,
                Last2DayNonFoPresent__c,
                Last3DayFoPresent__c,
                Last3DayNonFoPresent__c,
                Last4DayFoPresent__c,
                Last4DayNonFoPresent__c,
                Last5DayFoPresent__c,
                Last5DayNonFoPresent__c,
                Last6DayFoPresent__c,
                Last6DayNonFoPresent__c,
                Last7DayFoPresent__c,
                Last7DayNonFoPresent__c ,
                Current_month_Fo_present_village__c,
                Current_Month_Non_Fo_present_village__c,    
                CmPyMtd_Fo_present__c,
                CmPyMtd_Non_Fo_present__c,
                Current_Year_Fo_Present_village__c,
                Current_Year_Non_Fo_Present_village__c,
                PyTd_Fo_present__c,
                PyTd_Non_Fo_present__c,
                Last1DayFOCallType__c,
                Last1DayNonFOCallType__c,
                Last2DayFOCallType__c,
                Last2DayNonFOCallType__c,
                Last3DayFOCallType__c,
                Last3DayNonFOCallType__c,
                Last4DayFOCallType__c,
                Last4DayNonFOCallType__c,
                Last5DayFOCallType__c,
                Last5DayNonFOCallType__c,
                Last6DayFOCallType__c,
                Last6DayNonFOCallType__c,
                Last7DayFOCallType__c,
                Last7DayNonFOCallType__c,
                Sales_lead_Closed_Fo__c,
                Sales_lead_Open__c
                FROM Akc_Business_dashboard__c 
                where CreatedDate = YESTERDAY AND (Tehsil__r.name!='null' AND Territory__r.name !='')
                AND(SBUName__c IN :ListSBUFilter  AND ZoneName__c IN:ListZoneFilter)
                                order by CreatedDate DESC ];
               territoryCountList = [SELECT Tehsil_Code__c,District_Code__c,State__c,State_Code__c,Tehsil__r.name,Tehsil_Count__c,District_Name__c,Number_of_Calls_MTD__c,Number_of_Calls_YTD__c,Number_of_Caller_MTD__c,Number_of_Caller_YTD__c FROM Akc_Business_dashboard__c  where CreatedDate = YESTERDAY AND 
               (Tehsil__r.name!='null' AND Territory__r.name !='')
                AND(SBUName__c IN :ListSBUFilter  AND ZoneName__c IN:ListZoneFilter)
                 ORDER BY Tehsil__r.name];
}
if(filteFlag == 3){//SBU-Zone-Region
//System.debug('SBU-Zone-Region filter..');
abdc = new List<Akc_Business_dashboard__c >();
abdc = [SELECT CreatedDate, Id ,Total_Registration_Fo_Present__c,Total_Registration_Non_Fo_Present__c,Current_Month_Fo_Present__c, Current_Year_Fo_Present__c, Current_Month_Non_Fo_present__c, Current_Year_Non_Fo_present__c,Last1DayFoPresent__c,
                Last1DayNonFoPresent__c,
                Last2DayFoPresent__c,
                Last2DayNonFoPresent__c,
                Last3DayFoPresent__c,
                Last3DayNonFoPresent__c,
                Last4DayFoPresent__c,
                Last4DayNonFoPresent__c,
                Last5DayFoPresent__c,
                Last5DayNonFoPresent__c,
                Last6DayFoPresent__c,
                Last6DayNonFoPresent__c,
                Last7DayFoPresent__c,
                Last7DayNonFoPresent__c ,
                Current_month_Fo_present_village__c,
                Current_Month_Non_Fo_present_village__c,    
                CmPyMtd_Fo_present__c,
                CmPyMtd_Non_Fo_present__c,
                Current_Year_Fo_Present_village__c,
                Current_Year_Non_Fo_Present_village__c,
                PyTd_Fo_present__c,
                PyTd_Non_Fo_present__c,
                Last1DayFOCallType__c,
                Last1DayNonFOCallType__c,
                Last2DayFOCallType__c,
                Last2DayNonFOCallType__c,
                Last3DayFOCallType__c,
                Last3DayNonFOCallType__c,
                Last4DayFOCallType__c,
                Last4DayNonFOCallType__c,
                Last5DayFOCallType__c,
                Last5DayNonFOCallType__c,
                Last6DayFOCallType__c,
                Last6DayNonFOCallType__c,
                Last7DayFOCallType__c,
                Last7DayNonFOCallType__c,
                Sales_lead_Closed_Fo__c,
                Sales_lead_Open__c
                FROM Akc_Business_dashboard__c 
                where CreatedDate = YESTERDAY AND (Tehsil__r.name!='null' AND Territory__r.name !='')
                AND(SBUName__c IN :ListSBUFilter 
                AND ZoneName__c IN:ListZoneFilter
                AND RegionName__c IN:ListRegFilter
                )order by CreatedDate DESC ];
           territoryCountList = [SELECT Tehsil_Code__c,District_Code__c,State__c,State_Code__c,Tehsil__r.name,Tehsil_Count__c,District_Name__c,Number_of_Calls_MTD__c,Number_of_Calls_YTD__c,Number_of_Caller_MTD__c,Number_of_Caller_YTD__c FROM Akc_Business_dashboard__c  where CreatedDate = YESTERDAY AND
           (Tehsil__r.name!='null' AND Territory__r.name !='')
            AND(SBUName__c IN :ListSBUFilter 
                AND ZoneName__c IN:ListZoneFilter
                AND RegionName__c IN:ListRegFilter
                )
             ORDER BY Tehsil__r.name];
}
if(filteFlag == 4){//SBU-Zone-Region-territory
//System.debug('SBU-Zone-Region-territory filter..');
abdc = new List<Akc_Business_dashboard__c >();
abdc = [SELECT CreatedDate, Id ,Total_Registration_Fo_Present__c,Total_Registration_Non_Fo_Present__c,Current_Month_Fo_Present__c, Current_Year_Fo_Present__c, Current_Month_Non_Fo_present__c, Current_Year_Non_Fo_present__c,Last1DayFoPresent__c,
                Last1DayNonFoPresent__c,
                Last2DayFoPresent__c,
                Last2DayNonFoPresent__c,
                Last3DayFoPresent__c,
                Last3DayNonFoPresent__c,
                Last4DayFoPresent__c,
                Last4DayNonFoPresent__c,
                Last5DayFoPresent__c,
                Last5DayNonFoPresent__c,
                Last6DayFoPresent__c,
                Last6DayNonFoPresent__c,
                Last7DayFoPresent__c,
                Last7DayNonFoPresent__c ,
                Current_month_Fo_present_village__c,
                Current_Month_Non_Fo_present_village__c,    
                CmPyMtd_Fo_present__c,
                CmPyMtd_Non_Fo_present__c,
                Current_Year_Fo_Present_village__c,
                Current_Year_Non_Fo_Present_village__c,
                PyTd_Fo_present__c,
                PyTd_Non_Fo_present__c,
                Last1DayFOCallType__c,
                Last1DayNonFOCallType__c,
                Last2DayFOCallType__c,
                Last2DayNonFOCallType__c,
                Last3DayFOCallType__c,
                Last3DayNonFOCallType__c,
                Last4DayFOCallType__c,
                Last4DayNonFOCallType__c,
                Last5DayFOCallType__c,
                Last5DayNonFOCallType__c,
                Last6DayFOCallType__c,
                Last6DayNonFOCallType__c,
                Last7DayFOCallType__c,
                Last7DayNonFOCallType__c,
                Sales_lead_Closed_Fo__c,
                Sales_lead_Open__c
                FROM Akc_Business_dashboard__c 
                where CreatedDate = YESTERDAY AND (Tehsil__r.name!='null' AND Territory__r.name !='')
                AND(SBUName__c IN :ListSBUFilter 
                AND ZoneName__c IN:ListZoneFilter
                AND RegionName__c IN:ListRegFilter
                AND Territory__r.name IN:ListTerFilter
                )order by CreatedDate DESC ];
               
                territoryCountList = [SELECT Tehsil_Code__c,District_Code__c,State__c,State_Code__c,Tehsil__r.name,Tehsil_Count__c,District_Name__c,Number_of_Calls_MTD__c,Number_of_Calls_YTD__c,Number_of_Caller_MTD__c,Number_of_Caller_YTD__c FROM Akc_Business_dashboard__c  where  CreatedDate = YESTERDAY AND
           (Tehsil__r.name!='null' AND Territory__r.name !='')
            AND(SBUName__c IN :ListSBUFilter 
                AND ZoneName__c IN:ListZoneFilter
                AND RegionName__c IN:ListRegFilter
                AND Territory__r.name IN:ListTerFilter
                )
             ORDER BY Tehsil__r.name];
}
if(filteFlag == 5){//SBU-Zone-Region-territory-tehsil
//System.debug('SBU-Zone-Region-territory-tehsil filter..');
abdc = new List<Akc_Business_dashboard__c >();
abdc = [SELECT CreatedDate, Id ,Total_Registration_Fo_Present__c,Total_Registration_Non_Fo_Present__c,Current_Month_Fo_Present__c, Current_Year_Fo_Present__c, Current_Month_Non_Fo_present__c, Current_Year_Non_Fo_present__c,Last1DayFoPresent__c,
                Last1DayNonFoPresent__c,
                Last2DayFoPresent__c,
                Last2DayNonFoPresent__c,
                Last3DayFoPresent__c,
                Last3DayNonFoPresent__c,
                Last4DayFoPresent__c,
                Last4DayNonFoPresent__c,
                Last5DayFoPresent__c,
                Last5DayNonFoPresent__c,
                Last6DayFoPresent__c,
                Last6DayNonFoPresent__c,
                Last7DayFoPresent__c,
                Last7DayNonFoPresent__c ,
                Current_month_Fo_present_village__c,
                Current_Month_Non_Fo_present_village__c,    
                CmPyMtd_Fo_present__c,
                CmPyMtd_Non_Fo_present__c,
                Current_Year_Fo_Present_village__c,
                Current_Year_Non_Fo_Present_village__c,
                PyTd_Fo_present__c,
                PyTd_Non_Fo_present__c,
                Last1DayFOCallType__c,
                Last1DayNonFOCallType__c,
                Last2DayFOCallType__c,
                Last2DayNonFOCallType__c,
                Last3DayFOCallType__c,
                Last3DayNonFOCallType__c,
                Last4DayFOCallType__c,
                Last4DayNonFOCallType__c,
                Last5DayFOCallType__c,
                Last5DayNonFOCallType__c,
                Last6DayFOCallType__c,
                Last6DayNonFOCallType__c,
                Last7DayFOCallType__c,
                Last7DayNonFOCallType__c,
                Sales_lead_Closed_Fo__c,
                Sales_lead_Open__c
                FROM Akc_Business_dashboard__c 
                where CreatedDate = YESTERDAY AND (Tehsil__r.name!='null' AND Territory__r.name !='')
                AND(SBUName__c IN :ListSBUFilter 
                AND ZoneName__c IN:ListZoneFilter
                AND RegionName__c IN:ListRegFilter
                AND Territory__r.name IN:ListTerFilter
                AND Tehsil__r.name IN : ListTehsilFilter
                )order by CreatedDate DESC ];
              
                territoryCountList = [SELECT Tehsil_Code__c,District_Code__c,State__c,State_Code__c,Tehsil__r.name,Tehsil_Count__c,District_Name__c,Number_of_Calls_MTD__c,Number_of_Calls_YTD__c,Number_of_Caller_MTD__c,Number_of_Caller_YTD__c FROM Akc_Business_dashboard__c  where CreatedDate = YESTERDAY AND
           (Tehsil__r.name!='null' AND Territory__r.name !='')
            AND(SBUName__c IN :ListSBUFilter 
                AND ZoneName__c IN:ListZoneFilter
                AND RegionName__c IN:ListRegFilter
                AND Territory__r.name IN:ListTerFilter
                AND Tehsil__r.name IN : ListTehsilFilter
                )
             ORDER BY Tehsil__r.name];
}
/*------------------------------State wise filter---------------------------------------------------*/
if(filteFlag == 6){//State Filter
//System.debug('SBU-Zone-Region-territory-tehsil filter..');
abdc = new List<Akc_Business_dashboard__c >();
abdc = [SELECT CreatedDate, Id ,Total_Registration_Fo_Present__c,Total_Registration_Non_Fo_Present__c,Current_Month_Fo_Present__c, Current_Year_Fo_Present__c, Current_Month_Non_Fo_present__c, Current_Year_Non_Fo_present__c,Last1DayFoPresent__c,
                Last1DayNonFoPresent__c,
                Last2DayFoPresent__c,
                Last2DayNonFoPresent__c,
                Last3DayFoPresent__c,
                Last3DayNonFoPresent__c,
                Last4DayFoPresent__c,
                Last4DayNonFoPresent__c,
                Last5DayFoPresent__c,
                Last5DayNonFoPresent__c,
                Last6DayFoPresent__c,
                Last6DayNonFoPresent__c,
                Last7DayFoPresent__c,
                Last7DayNonFoPresent__c ,
                Current_month_Fo_present_village__c,
                Current_Month_Non_Fo_present_village__c,    
                CmPyMtd_Fo_present__c,
                CmPyMtd_Non_Fo_present__c,
                Current_Year_Fo_Present_village__c,
                Current_Year_Non_Fo_Present_village__c,
                PyTd_Fo_present__c,
                PyTd_Non_Fo_present__c,
                Last1DayFOCallType__c,
                Last1DayNonFOCallType__c,
                Last2DayFOCallType__c,
                Last2DayNonFOCallType__c,
                Last3DayFOCallType__c,
                Last3DayNonFOCallType__c,
                Last4DayFOCallType__c,
                Last4DayNonFOCallType__c,
                Last5DayFOCallType__c,
                Last5DayNonFOCallType__c,
                Last6DayFOCallType__c,
                Last6DayNonFOCallType__c,
                Last7DayFOCallType__c,
                Last7DayNonFOCallType__c,
                Sales_lead_Closed_Fo__c,
                Sales_lead_Open__c
                FROM Akc_Business_dashboard__c 
                where CreatedDate = YESTERDAY AND (Tehsil__r.name!='null' AND Territory__r.name !='')
                AND(State__c IN :ListStateFilter)order by CreatedDate DESC ];
              
                territoryCountList = [SELECT Tehsil_Code__c,District_Code__c,State__c,State_Code__c,Tehsil__r.name,Tehsil_Count__c,District_Name__c,Number_of_Calls_MTD__c,Number_of_Calls_YTD__c,Number_of_Caller_MTD__c,Number_of_Caller_YTD__c FROM Akc_Business_dashboard__c  where CreatedDate = YESTERDAY AND
           (Tehsil__r.name!='null' AND Territory__r.name !='')
            AND(State__c IN :ListStateFilter)
             ORDER BY Tehsil__r.name];
}
if(filteFlag == 7){//State Filter
//System.debug('SBU-Zone-Region-territory-tehsil filter..');
abdc = new List<Akc_Business_dashboard__c >();
abdc = [SELECT CreatedDate, Id ,Total_Registration_Fo_Present__c,Total_Registration_Non_Fo_Present__c,Current_Month_Fo_Present__c, Current_Year_Fo_Present__c, Current_Month_Non_Fo_present__c, Current_Year_Non_Fo_present__c,Last1DayFoPresent__c,
                Last1DayNonFoPresent__c,
                Last2DayFoPresent__c,
                Last2DayNonFoPresent__c,
                Last3DayFoPresent__c,
                Last3DayNonFoPresent__c,
                Last4DayFoPresent__c,
                Last4DayNonFoPresent__c,
                Last5DayFoPresent__c,
                Last5DayNonFoPresent__c,
                Last6DayFoPresent__c,
                Last6DayNonFoPresent__c,
                Last7DayFoPresent__c,
                Last7DayNonFoPresent__c ,
                Current_month_Fo_present_village__c,
                Current_Month_Non_Fo_present_village__c,    
                CmPyMtd_Fo_present__c,
                CmPyMtd_Non_Fo_present__c,
                Current_Year_Fo_Present_village__c,
                Current_Year_Non_Fo_Present_village__c,
                PyTd_Fo_present__c,
                PyTd_Non_Fo_present__c,
                Last1DayFOCallType__c,
                Last1DayNonFOCallType__c,
                Last2DayFOCallType__c,
                Last2DayNonFOCallType__c,
                Last3DayFOCallType__c,
                Last3DayNonFOCallType__c,
                Last4DayFOCallType__c,
                Last4DayNonFOCallType__c,
                Last5DayFOCallType__c,
                Last5DayNonFOCallType__c,
                Last6DayFOCallType__c,
                Last6DayNonFOCallType__c,
                Last7DayFOCallType__c,
                Last7DayNonFOCallType__c,
                Sales_lead_Closed_Fo__c,
                Sales_lead_Open__c
                FROM Akc_Business_dashboard__c 
                where CreatedDate = YESTERDAY AND (Tehsil__r.name!='null' AND Territory__r.name !='')
                AND(State__c IN :ListStateFilter)
                AND(District_Name__c IN :ListDistrictFilter)
                order by CreatedDate DESC ];
              
                territoryCountList = [SELECT Tehsil_Code__c,District_Code__c,State__c,State_Code__c,Tehsil__r.name,Tehsil_Count__c,District_Name__c,Number_of_Calls_MTD__c,Number_of_Calls_YTD__c,Number_of_Caller_MTD__c,Number_of_Caller_YTD__c FROM Akc_Business_dashboard__c  where CreatedDate = YESTERDAY AND
           (Tehsil__r.name!='null' AND Territory__r.name !='')
            AND(State__c IN :ListStateFilter)
            AND(District_Name__c IN :ListDistrictFilter)
            ORDER BY Tehsil__r.name];
}

if(filteFlag == 8){//State Filter
//System.debug('SBU-Zone-Region-territory-tehsil filter..');
abdc = new List<Akc_Business_dashboard__c >();
abdc = [SELECT CreatedDate, Id ,Total_Registration_Fo_Present__c,Total_Registration_Non_Fo_Present__c,Current_Month_Fo_Present__c, Current_Year_Fo_Present__c, Current_Month_Non_Fo_present__c, Current_Year_Non_Fo_present__c,Last1DayFoPresent__c,
                Last1DayNonFoPresent__c,
                Last2DayFoPresent__c,
                Last2DayNonFoPresent__c,
                Last3DayFoPresent__c,
                Last3DayNonFoPresent__c,
                Last4DayFoPresent__c,
                Last4DayNonFoPresent__c,
                Last5DayFoPresent__c,
                Last5DayNonFoPresent__c,
                Last6DayFoPresent__c,
                Last6DayNonFoPresent__c,
                Last7DayFoPresent__c,
                Last7DayNonFoPresent__c ,
                Current_month_Fo_present_village__c,
                Current_Month_Non_Fo_present_village__c,    
                CmPyMtd_Fo_present__c,
                CmPyMtd_Non_Fo_present__c,
                Current_Year_Fo_Present_village__c,
                Current_Year_Non_Fo_Present_village__c,
                PyTd_Fo_present__c,
                PyTd_Non_Fo_present__c,
                Last1DayFOCallType__c,
                Last1DayNonFOCallType__c,
                Last2DayFOCallType__c,
                Last2DayNonFOCallType__c,
                Last3DayFOCallType__c,
                Last3DayNonFOCallType__c,
                Last4DayFOCallType__c,
                Last4DayNonFOCallType__c,
                Last5DayFOCallType__c,
                Last5DayNonFOCallType__c,
                Last6DayFOCallType__c,
                Last6DayNonFOCallType__c,
                Last7DayFOCallType__c,
                Last7DayNonFOCallType__c,
                Sales_lead_Closed_Fo__c,
                Sales_lead_Open__c
                FROM Akc_Business_dashboard__c 
                where CreatedDate = YESTERDAY AND (Tehsil__r.name!='null' AND Territory__r.name !='')
                AND(State__c IN :ListStateFilter)
                AND(District_Name__c IN :ListDistrictFilter)
                AND(Tehsil__r.name IN :ListTehsil2Filter)
                order by CreatedDate DESC ];
              
                territoryCountList = [SELECT Tehsil_Code__c,District_Code__c,State__c,State_Code__c,Tehsil__r.name,Tehsil_Count__c,District_Name__c,Number_of_Calls_MTD__c,Number_of_Calls_YTD__c,Number_of_Caller_MTD__c,Number_of_Caller_YTD__c FROM Akc_Business_dashboard__c  where CreatedDate = YESTERDAY AND
           (Tehsil__r.name!='null' AND Territory__r.name !='')
            AND(State__c IN :ListStateFilter)
            AND(District_Name__c IN :ListDistrictFilter)
            AND(Tehsil__r.name IN :ListTehsil2Filter)
            ORDER BY Tehsil__r.name];
}
/*------------------------------End of State wise filter---------------------------------------------*/





        if(abdc.size()>0){
      // system.debug('list size - '+abdc.size());
                Total_Registration tr  = new Total_Registration();
                 Total_Registration = JSON.serialize( tr);
                for(Akc_Business_dashboard__c av : abdc){
                   try{
                      tr.Total_Registration_till_date_Total = tr.Total_Registration_till_date_Total+(av.Total_Registration_Fo_Present__c + av.Total_Registration_Non_Fo_Present__c);          
                      tr.Total_Registration_till_date_FO = tr.Total_Registration_till_date_FO + av.Total_Registration_Fo_Present__c;
                      tr.Total_Registration_till_date_NONFO = tr.Total_Registration_till_date_NONFO + av.Total_Registration_Non_Fo_Present__c;
               
                      tr.Current_Month_Total = tr.Current_Month_Total + (av.Current_Month_Fo_Present__c + av.Current_Month_Non_Fo_present__c);
                      tr.Current_Month_FO = tr.Current_Month_FO + av.Current_Month_Fo_Present__c ;
                      tr.Current_Month_NONFO  = tr.Current_Month_NONFO + av.Current_Month_Non_Fo_present__c;
                      
                      tr.Current_Year_Total = tr.Current_Year_Total +  (av.Current_Year_Fo_Present__c + av.Current_Year_Non_Fo_present__c);
                      tr.Current_Year_FO  = tr.Current_Year_FO + av.Current_Year_Fo_Present__c ;
                      tr.Current_Year_NONFO = tr.Current_Year_NONFO +  av.Current_Year_Non_Fo_present__c;
                  
                  //Last 7 days call 
                    tr.Last1DayFoPresent = tr.Last1DayFoPresent + av.Last1DayFoPresent__c;
                    tr.Last1DayNonFoPresent= tr.Last1DayNonFoPresent + av.Last1DayNonFoPresent__c;
                    tr.Last2DayFoPresent   =tr.Last2DayFoPresent + av.Last2DayFoPresent__c;
                    tr.Last2DayNonFoPresent = tr.Last2DayNonFoPresent + av.Last2DayNonFoPresent__c;
                    tr.Last3DayFoPresent   =tr.Last3DayFoPresent + av.Last3DayFoPresent__c;
                    tr.Last3DayNonFoPresent = tr.Last3DayNonFoPresent + av.Last3DayNonFoPresent__c;
                    tr.Last4DayFoPresent   =tr.Last4DayFoPresent + av.Last4DayFoPresent__c;
                    tr.Last4DayNonFoPresent =tr.Last4DayNonFoPresent + av.Last4DayNonFoPresent__c ;
                    tr.Last5DayFoPresent   =tr.Last5DayFoPresent + av.Last5DayFoPresent__c;
                    tr.Last5DayNonFoPresent = tr.Last5DayNonFoPresent + av.Last5DayNonFoPresent__c;
                    tr.Last6DayFoPresent   = tr.Last6DayFoPresent + av.Last6DayFoPresent__c ;
                    tr.Last6DayNonFoPresent = tr.Last6DayNonFoPresent+ av.Last6DayNonFoPresent__c;
                    tr.Last7DayFoPresent   = tr.Last7DayFoPresent+ av.Last7DayFoPresent__c;
                    tr.Last7DayNonFoPresent = tr.Last7DayNonFoPresent + av.Last7DayNonFoPresent__c;
                    
                    // Product Recommendation

                    
                        tr.Current_month_Fo_present_village= tr.Current_month_Fo_present_village + av.Current_month_Fo_present_village__c;
                        tr.Current_Month_Non_Fo_present_village= tr.Current_Month_Non_Fo_present_village + av.Current_Month_Non_Fo_present_village__c;    
                        tr.CmPyMtd_Fo_present= tr.CmPyMtd_Fo_present + av.CmPyMtd_Fo_present__c;
                        tr.CmPyMtd_Non_Fo_present= tr.CmPyMtd_Non_Fo_present + av.CmPyMtd_Non_Fo_present__c; 
                        tr.Current_Year_Fo_Present_village= tr.Current_Year_Fo_Present_village + av.Current_Year_Fo_Present_village__c;
                        tr.Current_Year_Non_Fo_Present_village= tr.Current_Year_Non_Fo_Present_village + av.Current_Year_Non_Fo_Present_village__c;
                        tr.PyTd_Fo_present= tr.PyTd_Fo_present + av.PyTd_Fo_present__c;
                        tr.PyTd_Non_Fo_present=tr.PyTd_Non_Fo_present + av.PyTd_Non_Fo_present__c;
                        
                        //Last 7 day Call Type
                        /*
                            Sales_lead_Closed_Fo__c,
                            Sales_lead_Open__c
                        */
                         tr.Sales_leads_genrated_by_AKC = tr.Sales_leads_genrated_by_AKC + (av.Sales_lead_Closed_Fo__c + av.Sales_lead_Open__c) ;
                         tr.Sales_leads_closed = tr.Sales_leads_closed + av.Sales_lead_Closed_Fo__c;
                         tr.Sales_leads_open = tr.Sales_leads_open + av.Sales_lead_Open__c;
                         }catch(Exception e){
                          //Total_Registration tr  = new Total_Registration();
                        //cmt by abhishek  Total_Registration = JSON.serialize( tr);
                             system.debug('Error On - '+av);
                              System.debug('The following exception has occurred: ' + e.getMessage());
                               System.debug('Cause: ' + e); 
                         }
            }
           if(abdc.size()>0){
               List<String>FisrtFO = new List<String>();//comma seprated
               List<String>FisrtNonFO = new List<String>();//'-'seprated
               last7DaysCallTypeFOMap = new Map<String,List<Integer>>();
               last7DaysCallTypeNONFOMap = new Map<String,List<Integer>>(); 
               for(Akc_Business_dashboard__c av : abdc){
                 try{
                  FisrtFO = new List<String>();
                  //day1FO
                   if(!String.isBlank(av.Last1DayFOCallType__c)){
                    FisrtFO =av.Last1DayFOCallType__c.split(',');
                     for(String type_count :FisrtFO ){
                     if(last7DaysCallTypeFOMap.containsKey(type_count.split('-')[0].trim())){
                       List<Integer> co = last7DaysCallTypeFOMap.get(type_count.split('-')[0].trim());
                         //system.debug(' -  - '+type_count.split('-')[1].trim());
                         co.set(0,co[0] + Integer.valueOf(type_count.split('-')[1].trim()));
                         last7DaysCallTypeFOMap.put(type_count.split('-')[0].trim(),co);
                                                
                     }else{
                       List<Integer> co = new List<Integer>{0,0,0,0,0,0,0};
                       co.set(0,Integer.valueOf(type_count.split('-')[1].trim()));   
                       last7DaysCallTypeFOMap.put(type_count.split('-')[0].trim(),co);
                      
                     }
                     
                     } 
                   }
                   //day2FO
                   if(!String.isBlank(av.Last2DayFOCallType__c)){
                    FisrtFO =av.Last2DayFOCallType__c.split(',');
                     for(String type_count :FisrtFO ){
                     if(last7DaysCallTypeFOMap.containsKey(type_count.split('-')[0].trim())){
                            //Integer.valueOf(type_count.split('-')[1].trim())
                       List<Integer> co = last7DaysCallTypeFOMap.get(type_count.split('-')[0].trim());
                        // system.debug(' -  - '+type_count.split('-')[1].trim());
                         co.set(1,co[1] +Integer.valueOf(type_count.split('-')[1].trim()));
                         last7DaysCallTypeFOMap.put(type_count.split('-')[0].trim(),co);
                                                
                     }else{
                       List<Integer> co = new List<Integer>{0,0,0,0,0,0,0};
                       co.set(1,Integer.valueOf(type_count.split('-')[1].trim()));   
                       last7DaysCallTypeFOMap.put(type_count.split('-')[0].trim(),co);
                      
                     }
                     
                     } 
                   }
                   //day3FO
                   if(!String.isBlank(av.Last3DayFOCallType__c)){
                    FisrtFO =av.Last3DayFOCallType__c.split(',');
                     for(String type_count :FisrtFO ){
                     if(last7DaysCallTypeFOMap.containsKey(type_count.split('-')[0].trim())){
                            //Integer.valueOf(type_count.split('-')[1])
                       List<Integer> co = last7DaysCallTypeFOMap.get(type_count.split('-')[0].trim());
                    // system.debug(' -  - '+type_count.split('-')[1].trim());
                         co.set(2,co[2] + Integer.valueOf(type_count.split('-')[1].trim()));
                         last7DaysCallTypeFOMap.put(type_count.split('-')[0].trim(),co);
                                                
                     }else{
                       List<Integer> co = new List<Integer>{0,0,0,0,0,0,0};
                       co.set(2,Integer.valueOf(type_count.split('-')[1].trim()));   
                       last7DaysCallTypeFOMap.put(type_count.split('-')[0].trim(),co);
                      
                     }
                     
                     } 
                   }
                   //day4FO
                  if(!String.isBlank(av.Last4DayFOCallType__c)){
                    FisrtFO =av.Last4DayFOCallType__c.split(',');
                     for(String type_count :FisrtFO ){
                     if(last7DaysCallTypeFOMap.containsKey(type_count.split('-')[0].trim())){
                            //Integer.valueOf(type_count.split('-')[1])
                       List<Integer> co = last7DaysCallTypeFOMap.get(type_count.split('-')[0].trim());
                         co.set(3,co[3] + Integer.valueOf(type_count.split('-')[1].trim()));
                         last7DaysCallTypeFOMap.put(type_count.split('-')[0].trim(),co);
                                                
                     }else{
                       List<Integer> co = new List<Integer>{0,0,0,0,0,0,0};
                       co.set(3,Integer.valueOf(type_count.split('-')[1].trim()));   
                       last7DaysCallTypeFOMap.put(type_count.split('-')[0].trim(),co);
                      
                     }
                     
                     } 
                   }
                   //day5FO
                    if(!String.isBlank(av.Last5DayFOCallType__c)){
                    FisrtFO =av.Last5DayFOCallType__c.split(',');
                     for(String type_count :FisrtFO ){
                     if(last7DaysCallTypeFOMap.containsKey(type_count.split('-')[0].trim())){
                            //Integer.valueOf(type_count.split('-')[1])
                       List<Integer> co = last7DaysCallTypeFOMap.get(type_count.split('-')[0].trim());
                         co.set(4,co[4] + Integer.valueOf(type_count.split('-')[1].trim()));
                         last7DaysCallTypeFOMap.put(type_count.split('-')[0].trim(),co);
                                                
                     }else{
                       List<Integer> co = new List<Integer>{0,0,0,0,0,0,0};
                       co.set(4,Integer.valueOf(type_count.split('-')[1].trim()));   
                       last7DaysCallTypeFOMap.put(type_count.split('-')[0].trim(),co);
                      
                     }
                     
                     } 
                   }
                   //day 6FO
                    if(!String.isBlank(av.Last6DayFOCallType__c)){
                    FisrtFO =av.Last6DayFOCallType__c.split(',');
                     for(String type_count :FisrtFO ){
                     if(last7DaysCallTypeFOMap.containsKey(type_count.split('-')[0].trim())){
                            //Integer.valueOf(type_count.split('-')[1])
                       List<Integer> co = last7DaysCallTypeFOMap.get(type_count.split('-')[0].trim());
                         co.set(5,co[5] + Integer.valueOf(type_count.split('-')[1].trim()));
                         last7DaysCallTypeFOMap.put(type_count.split('-')[0].trim(),co);
                                                
                     }else{
                       List<Integer> co = new List<Integer>{0,0,0,0,0,0,0};
                       co.set(5,Integer.valueOf(type_count.split('-')[1].trim()));   
                       last7DaysCallTypeFOMap.put(type_count.split('-')[0].trim(),co);
                      
                     }
                     
                     } 
                   }
                   //day7FO
                    if(!String.isBlank(av.Last7DayFOCallType__c)){
                     FisrtFO =av.Last7DayFOCallType__c.split(',');
                     for(String type_count :FisrtFO ){
                     if(last7DaysCallTypeFOMap.containsKey(type_count.split('-')[0].trim())){
                            //Integer.valueOf(type_count.split('-')[1])
                       List<Integer> co = last7DaysCallTypeFOMap.get(type_count.split('-')[0].trim());
                         co.set(6,co[6] + Integer.valueOf(type_count.split('-')[1].trim()));
                         last7DaysCallTypeFOMap.put(type_count.split('-')[0].trim(),co);
                                                
                     }else{
                       List<Integer> co = new List<Integer>{0,0,0,0,0,0,0};
                       co.set(6,Integer.valueOf(type_count.split('-')[1].trim()));   
                       last7DaysCallTypeFOMap.put(type_count.split('-')[0].trim(),co);
                      
                     }
                     
                     } 
                   }
                  /*--------------------------NON-FO last 7days---------------------------------------*/ 
                   //last7DaysCallTypeNONFOMap 
                   if(!String.isBlank(av.Last1DayNonFOCallType__c)){
                     FisrtFO =av.Last1DayNonFOCallType__c.split(',');
                     for(String type_count :FisrtFO ){
                     if(last7DaysCallTypeNONFOMap.containsKey(type_count.split('-')[0].trim())){
                            //Integer.valueOf(type_count.split('-')[1])
                       List<Integer> co = last7DaysCallTypeNONFOMap.get(type_count.split('-')[0].trim());
                         co.set(0,co[0] + Integer.valueOf(type_count.split('-')[1].trim()));
                         last7DaysCallTypeNONFOMap.put(type_count.split('-')[0].trim(),co);
                                                
                     }else{
                       List<Integer> co = new List<Integer>{0,0,0,0,0,0,0};
                       co.set(0,Integer.valueOf(type_count.split('-')[1].trim()));   
                       last7DaysCallTypeNONFOMap.put(type_count.split('-')[0].trim(),co);
                      
                     }
                     
                     } 
                   }
                   //day2NON-FO
                    if(!String.isBlank(av.Last2DayNonFOCallType__c)){
                     FisrtFO =av.Last2DayNonFOCallType__c.split(',');
                     for(String type_count :FisrtFO ){
                     if(last7DaysCallTypeNONFOMap.containsKey(type_count.split('-')[0].trim())){
                            //Integer.valueOf(type_count.split('-')[1])
                       List<Integer> co = last7DaysCallTypeNONFOMap.get(type_count.split('-')[0].trim());
                         co.set(1,co[1] +Integer.valueOf(type_count.split('-')[1].trim()));
                         last7DaysCallTypeNONFOMap.put(type_count.split('-')[0].trim(),co);
                                                
                     }else{
                       List<Integer> co = new List<Integer>{0,0,0,0,0,0,0};
                       co.set(1, Integer.valueOf(type_count.split('-')[1].trim()));   
                       last7DaysCallTypeNONFOMap.put(type_count.split('-')[0].trim(),co);
                      
                     }
                     
                     } 
                   }
                   //day3 NON-FO
                  if(!String.isBlank(av.Last3DayNonFOCallType__c)){
                     FisrtFO =av.Last3DayNonFOCallType__c.split(',');
                     for(String type_count :FisrtFO ){
                     if(last7DaysCallTypeNONFOMap.containsKey(type_count.split('-')[0].trim())){
                            //Integer.valueOf(type_count.split('-')[1])
                       List<Integer> co = last7DaysCallTypeNONFOMap.get(type_count.split('-')[0].trim());
                         co.set(2,co[2] + Integer.valueOf(type_count.split('-')[1].trim()));
                         last7DaysCallTypeNONFOMap.put(type_count.split('-')[0].trim(),co);
                                                
                     }else{
                       List<Integer> co = new List<Integer>{0,0,0,0,0,0,0};
                       co.set(2,Integer.valueOf(type_count.split('-')[1].trim()));   
                       last7DaysCallTypeNONFOMap.put(type_count.split('-')[0].trim(),co);
                      
                     }
                     
                     } 
                   }
                   //day4 non-fo
                  if(!String.isBlank(av.Last4DayNonFOCallType__c)){
                     FisrtFO =av.Last4DayNonFOCallType__c.split(',');
                     for(String type_count :FisrtFO ){
                     if(last7DaysCallTypeNONFOMap.containsKey(type_count.split('-')[0].trim())){
                            //Integer.valueOf(type_count.split('-')[1])
                       List<Integer> co = last7DaysCallTypeNONFOMap.get(type_count.split('-')[0].trim());
                         co.set(3,co[3] + Integer.valueOf(type_count.split('-')[1].trim()));
                         last7DaysCallTypeNONFOMap.put(type_count.split('-')[0].trim(),co);
                                                
                     }else{
                       List<Integer> co = new List<Integer>{0,0,0,0,0,0,0};
                       co.set(3,Integer.valueOf(type_count.split('-')[1].trim()));   
                       last7DaysCallTypeNONFOMap.put(type_count.split('-')[0].trim(),co);
                      
                     }
                     
                     } 
                   }
                   //day 5 -NON-FO
                   if(!String.isBlank(av.Last5DayNonFOCallType__c)){
                     FisrtFO =av.Last5DayNonFOCallType__c.split(',');
                     for(String type_count :FisrtFO ){
                     if(last7DaysCallTypeNONFOMap.containsKey(type_count.split('-')[0].trim())){
                            //Integer.valueOf(type_count.split('-')[1])
                       List<Integer> co = last7DaysCallTypeNONFOMap.get(type_count.split('-')[0].trim());
                         co.set(4,co[4] + Integer.valueOf(type_count.split('-')[1].trim()));
                         last7DaysCallTypeNONFOMap.put(type_count.split('-')[0].trim(),co);
                                                
                     }else{
                       List<Integer> co = new List<Integer>{0,0,0,0,0,0,0};
                       co.set(4,Integer.valueOf(type_count.split('-')[1].trim()));   
                       last7DaysCallTypeNONFOMap.put(type_count.split('-')[0].trim(),co);
                      
                     }
                     
                     } 
                   }
                   //day 6 
                   if(!String.isBlank(av.Last6DayNonFOCallType__c)){
                     FisrtFO =av.Last6DayNonFOCallType__c.split(',');
                     for(String type_count :FisrtFO ){
                     if(last7DaysCallTypeNONFOMap.containsKey(type_count.split('-')[0].trim())){
                            //Integer.valueOf(type_count.split('-')[1])
                       List<Integer> co = last7DaysCallTypeNONFOMap.get(type_count.split('-')[0].trim());
                         co.set(5,co[5] + Integer.valueOf(type_count.split('-')[1].trim()));
                         last7DaysCallTypeNONFOMap.put(type_count.split('-')[0].trim(),co);
                                                
                     }else{
                       List<Integer> co = new List<Integer>{0,0,0,0,0,0,0};
                       co.set(5,Integer.valueOf(type_count.split('-')[1].trim()));   
                       last7DaysCallTypeNONFOMap.put(type_count.split('-')[0].trim(),co);
                      
                     }
                     
                     } 
                   }
                   //day 7 
                 if(!String.isBlank(av.Last7DayNonFOCallType__c)){
                     FisrtFO =av.Last7DayNonFOCallType__c.split(',');
                     for(String type_count :FisrtFO ){
                     if(last7DaysCallTypeNONFOMap.containsKey(type_count.split('-')[0].trim())){
                            //Integer.valueOf(type_count.split('-')[1])
                       List<Integer> co = last7DaysCallTypeNONFOMap.get(type_count.split('-')[0].trim());
                         co.set(6,co[6] + Integer.valueOf(type_count.split('-')[1].trim()));
                         last7DaysCallTypeNONFOMap.put(type_count.split('-')[0].trim(),co);
                                                
                     }else{
                       List<Integer> co = new List<Integer>{0,0,0,0,0,0,0};
                       co.set(6,Integer.valueOf(type_count.split('-')[1].trim()));   
                       last7DaysCallTypeNONFOMap.put(type_count.split('-')[0].trim(),co);
                      
                     }
                     
                     } 
                   }
                 }catch(Exception e){
                    // Total_Registration tr  = new Total_Registration();
                   //cmnt by abhishek  Total_Registration = JSON.serialize( tr);
                   system.debug('Error On - '+av);
                   System.debug('The following exception has occurred: ' + e.getMessage());
                   System.debug('Cause: ' + e.getCause()); 
                 }  
               }
           }else{
           last7DaysCallTypeFOMap = new Map<String,List<Integer>>();
           last7DaysCallTypeNONFOMap = new Map<String,List<Integer>>(); 
           
           }
            last7DaysCallTypeFO = JSON.serialize(last7DaysCallTypeFOMap);
            last7DaysCallTypeNONFO = JSON.serialize(last7DaysCallTypeNONFOMap);
           // system.debug(last7DaysCallTypeFO );
           // system.debug('territoryCountList ');
           // system.debug(territoryCountList  );
            Total_Registration = JSON.serialize(tr);
            sbu_zone_map_str=JSON.serialize(sbu_zone);
            zone_region_map_str=JSON.serialize(zone_region);
            region_terirorry_map_str=JSON.serialize(region_terirorry);
            terirorry_tehsil_map_str= JSON.serialize(terirorry_tehsil);
            state_district_map_str = JSON.serialize(state_district);
            district_tehsil_map_str =JSON.serialize(district_tehsil); 
          //  system.debug(Total_Registration );
       // terirorry_tehsil_map_str='';
        }else{
            last7DaysCallTypeFOMap = new Map<String,List<Integer>>();
            last7DaysCallTypeNONFOMap = new Map<String,List<Integer>>(); 
            last7DaysCallTypeFO = JSON.serialize(last7DaysCallTypeFOMap);
            system.debug('last7DaysCallTypeFO ----->');
            system.debug(last7DaysCallTypeFO);
            
            last7DaysCallTypeNONFO = JSON.serialize(last7DaysCallTypeNONFOMap);
        }
        
         nestedTerritoryCountList = new List<List<Akc_Business_dashboard__c>>();
          Integer count = 0,index=0;
          System.debug('nestedTerritoryCountList');
          List<Akc_Business_dashboard__c>asts = new List<Akc_Business_dashboard__c>();
       //TODO:for live uncomment this
       /*   if(territoryCountList.size()<999){
              nestedTerritoryCountList.add(territoryCountList);
          }
        */  
          for(Akc_Business_dashboard__c acc : territoryCountList){
              count++;
            
              if(count>=999){
                     System.debug('count - '+count);
                   nestedTerritoryCountList.add(asts);  
                   asts= new List<Akc_Business_dashboard__c>();
                   index++;
                  count=0; 
              }
             asts.add(acc);
             
              
          }
          if(asts.size()>0){
               nestedTerritoryCountList.add(asts); 
          }
          System.debug(asts.size());
           System.debug('nestedTerritoryCountList');
           System.debug(nestedTerritoryCountList);
            system.debug('last7DaysCallTypeFO ----->');
            system.debug(last7DaysCallTypeFO);
    }
   
    
   
    
    
    
    
    private class Total_Registration{
       public Decimal Current_Month_Total;
       public Decimal Current_Year_Total;
       public Decimal Total_Registration_till_date_Total;   
       
         
       public Decimal Current_Month_FO;
       public Decimal Current_Year_FO;
       public Decimal Total_Registration_till_date_FO;
     
       public Decimal Current_Month_NONFO;
       public Decimal Current_Year_NONFO;
       public Decimal Total_Registration_till_date_NONFO;    
       public Decimal Last1DayFoPresent  ;  
        
        public Decimal Last1DayNonFoPresent;    
        public Decimal Last2DayFoPresent;   
        public Decimal Last2DayNonFoPresent;    
        public Decimal Last3DayFoPresent   ;
        public Decimal Last3DayNonFoPresent ;   
        public Decimal Last4DayFoPresent   ;
        public Decimal Last4DayNonFoPresent ;   
        public Decimal Last5DayFoPresent   ;
        public Decimal Last5DayNonFoPresent ;   
        public Decimal Last6DayFoPresent   ;
        public Decimal Last6DayNonFoPresent ;   
        public Decimal   Last7DayFoPresent   ;
        public Decimal Last7DayNonFoPresent   ; 
        public Decimal Current_month_Fo_present_village;
        public Decimal Current_Month_Non_Fo_present_village;    
        public Decimal CmPyMtd_Fo_present;
        public Decimal CmPyMtd_Non_Fo_present;
        public Decimal Current_Year_Fo_Present_village;
        public Decimal Current_Year_Non_Fo_Present_village;
        public Decimal PyTd_Fo_present;
        public Decimal PyTd_Non_Fo_present;
        public Decimal Sales_leads_genrated_by_AKC;
        public Decimal Sales_leads_closed;
        public Decimal Sales_leads_open;
        
      
      public  Total_Registration(){
            Last1DayFoPresent =0;
            Last1DayNonFoPresent= 0;
            Last2DayFoPresent   =0;
            Last2DayNonFoPresent = 0;
            Last3DayFoPresent   =0;
            Last3DayNonFoPresent = 0;
            Last4DayFoPresent   =0;
            Last4DayNonFoPresent = 0;
            Last5DayFoPresent   =0;
            Last5DayNonFoPresent = 0;
            Last6DayFoPresent   =0;
            Last6DayNonFoPresent = 0;
            Last7DayFoPresent   = 0;
            Last7DayNonFoPresent = 0;

             Current_Month_Total = 0;
             Current_Year_Total = 0;
             Total_Registration_till_date_Total= 0;   
             Current_Month_FO = 0;
             Current_Year_FO = 0;
             Total_Registration_till_date_FO= 0;
             Current_Month_NONFO = 0;
             Current_Year_NONFO = 0;
             Total_Registration_till_date_NONFO= 0;    
             
            Current_month_Fo_present_village= 0;
            Current_Month_Non_Fo_present_village= 0;    
            CmPyMtd_Fo_present= 0;
            CmPyMtd_Non_Fo_present= 0;
            Current_Year_Fo_Present_village= 0;
            Current_Year_Non_Fo_Present_village= 0;
            PyTd_Fo_present= 0;
            PyTd_Non_Fo_present= 0;
            //Last 7 day Call Type
            
            Sales_leads_genrated_by_AKC = 0;
            Sales_leads_closed = 0;
            Sales_leads_open= 0;
      }  
    }
}