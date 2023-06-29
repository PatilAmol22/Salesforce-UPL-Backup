public class DemoObservation {
    
    public string productOrCrop{get;set;}
    public list<Territory_Distributor__c> lstofterritory {get;set;}
    public string terrName{get;set;}
    public list<Campaign_Crop_Mapping__c> lstofCrops{get;set;}
    public list<SelectOption> lstcropoption{get;set;}
    public map<string,string> mapoftargetedWeeds{get;set;}
    public set<Decimal> setofcampaigndays{get;set;} 
    public set<string> setofTreatment{get;set;}
    public list<Tehsil__c> lstoftehsil{get;set;}
    public list<SelectOption> lstofTehsiloptn{get;set;}
    public map<String,Decimal> mapofTreatmentDose{get;set;}
    public date dateofAppln{get;set;}
    public String applndose{get;set;}
    public string timeofappln{get;set;}
    public string methdofappln{get;set;}
    public String watervolume{get;set;}
    public string  observation{get;set;}
    public Demo_Observations__c demoObser;
    public list<Demo_Observations__c> lstdemoObser;
    public list<Campaign> observCampaign;
    public string campaignid;
    public list<string> targetweeds{get;set;}
    public string campdays{get;set;}
    public string strweeds{get;set;}
    public selectOption cropdefault{get;set;}
    public String demoobservId;
    public Demo_Observations__c demoobservation{get;set;} 
    public list<string> lststring{get;set;}
    public map<string,Observation__c> mapObservation {get;set;} 
    public String comptrProd{get;set;}
    public string campaignName{get;set;}
    public Demo_Observations__c demoobserobj{get;set;}
    public string campObjetive{get;set;}
    public ApexPages.StandardController stdController;
    public string selCrop{get;set;}
    public list<string> lstCropName{get;set;}
    public list<Campaign_Crop_Mapping__c> lstCampCropMap {get;set;}
    public string errMsg{get;set;}
    private string userId ;
    public boolean isIndiaUser{get;set;}
    //-------------------------------------------------------- Sandip Atkari Start Here ---------------
    public List<Treatment__c> listTreatment {get;set;}
    public List<Target_Weed__c> listTargetWeed {get;set;}
    public List<Campaign_Day__c> listCampaignDay {get;set;}
    private List<Observation__c> listObservation {get;set;}
    private Map<String,Map<String,Observation__c>> mapCampaginDay = new Map<String,Map<String,Observation__c>>();
    private Map<String,Observation__c> mapTargetWeed = new Map<String,Observation__c>();        
    //-------------------------------------------------------- Sandip Atkari End Here -----------------
    //constructor for new view  And Edit Demo Observation
    public DemoObservation(ApexPages.StandardController stdController) {
    
        try{
           userId = '';
           userId = UserInfo.getUserId();
           User LoginUser = [SELECT Id, Country,Profile.Name FROM User Where Id=:userId];
           isIndiaUser =false;
           if(LoginUser.country == 'india'){
               isIndiaUser = true;
           } 
           system.debug('india user>>--->'+isIndiaUser);
           selCrop = '';
           demoobservId = '';
           errMsg = '';
           lstCampCropMap  = new  list<Campaign_Crop_Mapping__c>();
           lstCropName = new list<string>();
           this.stdController = stdController;
           demoObser = new Demo_Observations__c();
           demoobservId = (string) stdController.getRecord().id;
           system.debug('demoObser>>----->'+demoObser);
           system.debug('demoObser>>----->'+demoobservId);
           //If for new Demo Observation
            if(demoobservId == Null){
                //Demo_Observations__c demoObservation = ApexPages.currentPage().getParameters().get('retURL'); // (Demo_Observations__c)stdController.getRecord();
               
             
               String prefix = Schema.getGlobalDescribe().get('Campaign').getDescribe().getKeyPrefix();
               system.debug('prefix>>--->'+prefix);
                String idVal = null;
                Map<String, String> params = ApexPages.currentPage().getParameters();
               system.debug('params >>--->'+params);
               for (String key : params.keySet()) {
                  if (key.startsWith('CF') && key.endsWith('lkid')) {
                    String val = params.get(key);
                    if (val.startsWith(prefix)) {
                      idVal = val;
                       system.debug('field Id>>--->'+key);
                      campaignid = ApexPages.currentPage().getParameters().get(key);
                      system.debug('field Id>>--->'+idVal);
                      break;
                    }
                  }
                  }
                  //campaignid = ApexPages.currentPage().getParameters().get();
                system.debug('campaign Id>>--->'+campaignid );
                system.debug('return URL>>----->'+ApexPages.currentPage().getUrl());
                campaignid = campaignid.replace('/','');
                system.debug('campaignid>>----->'+campaignid);
            }
            demoobserobj = new  Demo_Observations__c();
            system.debug('campaignid>>----->'+campaignid);
            lststring = new  list<string>();
            campdays = '';
            strweeds ='';
            comptrProd = '';
            campaignName ='';
            campObjetive ='';
            lstofCrops = new list<Campaign_Crop_Mapping__c>();
            lstoftehsil = new list<Tehsil__c>();
            string userId = UserInfo.getUserId();
            mapoftargetedWeeds = new map<string,string>();
            setofcampaigndays = new set<Decimal>();
            setofTreatment = new set<string>();
            mapofTreatmentDose = new map<String,Decimal>();
            lstofTehsiloptn = new list<SelectOption>();
            system.debug('demoobservId=========='+demoobservId);
            //system.debug('record=========='+controller.getRecord());
            system.debug('campaignid======'+campaignid);
            demoobservation = new Demo_Observations__c();
            system.debug('demoobservId>>----->'+demoobservId);
            //If for edit and view Demo Observation
            if(demoobservId != null){
                 demoobserobj = [SELECT Id, name,Address__c,Address__r.Name,Farmer_Name__c,Age_of_crop_in_years_if_plantation__c,Age_of_Crop_Days_after_sowing__c,Crop__c,Crop__r.Name,Date_of_Sowing__c,Contact_Number__c,Campaign_Name__c FROM Demo_Observations__c WHERE id =:demoobservId LIMIT 1];
                 campaignid = demoobserobj.Campaign_Name__c;    
                 selCrop =  demoobserobj.Crop__r.Name;                           
            }
            //current User's Territory
            lstofterritory = [SELECT Name,Id,TerritoryManager__c FROM  Territory_Distributor__c WHERE TerritoryManager__c =: userId  AND Sales_Org_Code__c='1000' LIMIT 1 ]; 
            for(Territory_Distributor__c t : lstofterritory){
                terrName =  t.name;
            }
            //to get all Crop Observations for the campaign        
            lstofCrops  = [SELECT Id, Name, Crop__c,Crop_Name__c,Crop_Name__r.Name, Category__c, Campaign_Day_1__c,Campaign_Day_1__r.Day__c, Campaign_Day_3__c,Campaign_Day_3__r.Day__c, Campaign_Day_2__c,Campaign_Day_2__r.Day__c, Campaign_Day_4__c,Campaign_Day_4__r.Day__c, Campaign_Day_5__c,Campaign_Day_5__r.Day__c, 
                            Target_Weed_1__c,Target_Weed_1__r.Name, Target_Weed_2__c, Target_Weed_2__r.Name , Target_Weed_3__c,Target_Weed_3__r.Name, Target_Weed_4__c,Target_Weed_4__r.Name, Target_Weed_5__c,Target_Weed_5__r.Name, 
                            Treatment_1__c,Treatment_1__r.Name, Treatment_2__c,Treatment_2__r.Name, Treatment_4__c,Treatment_4__r.Name, Treatment_5__c,Treatment_5__r.Name, Treatment_3__c,Treatment_3__r.Name,
                            Treatment_1_Dose_ml_acre__c, Treatment_2_Dose_ml_acre__c, Treatment_3_Dose_ml_acre__c, Treatment_4_Dose_ml_acre__c, Treatment_5_Dose_ml_acre__c, Campaign__c 
                            FROM Campaign_Crop_Mapping__c WHERE Campaign__c =: campaignid];
                                        
            if(!lstofterritory.isEmpty()){  
                // this is used for assign Tehsil to Address field in page   
                lstoftehsil = [SELECT Id, Name, Territory__c, Tehsil_Code__c, District__c FROM Tehsil__c WHERE Territory__c  IN :lstofterritory]; //='a1L28000002FPh5'];        
            }
            system.debug('lstoftehsil======='+lstoftehsil);
            if(lstoftehsil.size()>0){
                for(Tehsil__c  t : lstoftehsil){
                    lstofTehsiloptn.add(new SelectOption(t.id,t.name));
                }
            }   
            if(lstofCrops.size()>0){
                 if(demoobservId!=Null){
                     //crop wise crop Description for perticular Campaign
                     lstofCrops = [SELECT Id, Name, Crop__c,Crop_Name__c,Crop_Name__r.Name, Category__c, Campaign_Day_1__c,Campaign_Day_1__r.Day__c, Campaign_Day_3__c,Campaign_Day_3__r.Day__c, Campaign_Day_2__c,Campaign_Day_2__r.Day__c, Campaign_Day_4__c,Campaign_Day_4__r.Day__c, Campaign_Day_5__c,Campaign_Day_5__r.Day__c, 
                                    Target_Weed_1__c,Target_Weed_1__r.Name, Target_Weed_2__c, Target_Weed_2__r.Name , Target_Weed_3__c,Target_Weed_3__r.Name, Target_Weed_4__c,Target_Weed_4__r.Name, Target_Weed_5__c,Target_Weed_5__r.Name, 
                                    Treatment_1__c,Treatment_1__r.Name, Treatment_2__c,Treatment_2__r.Name, Treatment_4__c,Treatment_4__r.Name, Treatment_5__c,Treatment_5__r.Name, Treatment_3__c,Treatment_3__r.Name,
                                    Treatment_1_Dose_ml_acre__c, Treatment_2_Dose_ml_acre__c, Treatment_3_Dose_ml_acre__c, Treatment_4_Dose_ml_acre__c, Treatment_5_Dose_ml_acre__c, Campaign__c 
                                    FROM Campaign_Crop_Mapping__c WHERE Campaign__c =: campaignid AND Crop_Name__c =: demoobserobj.crop__c limit 1];            
                     loadPage();
                 }   
            }else{
                 errMsg = 'Please add Crop to Campaign-Crop Mapping';
            }  
            if(campaignid != null){
                system.debug('campaignid======'+campaignid);
                //To get product or Crop Information for campaign 
                observCampaign =[SELECT id,Name,Date_of_Application__c,Target_Weed_1__c,Product_Name__c,Product_Name__r.Name,Crop_Name__c,Crop_Name__r.Name,Target_Weed_1__r.Name,Target_Weed_2__c,Target_Weed_2__r.name,Target_Weed_3__c,Target_Weed_3__r.name,Treatment_1_Dose__c,Treatment_2_Dose_ml_acre__c,Treatment_3_Dose_ml_acre__c,Treatment_4_Dose_ml_acre__c,Treatment_5_Dose_ml_acre__c, 
                                        Target_Weed_4__c,Objective__c,Target_Weed_4__r.name,Target_Weed_5__c,Target_Weed_5__r.name, Application_Dose_ml_Acre__c,Time_of_Application__c,Method_of_Application__c,Water_Volume_L_Acre__c, Campaign_Day_1__c,Campaign_Day_1__r.Day__c,Campaign_Day_2__c,Campaign_Day_2__r.Day__c,Campaign_Day_3__c,Campaign_Day_3__r.Day__c, Campaign_Day_4__c,Campaign_Day_4__r.Day__c,Campaign_Day_5__c,Campaign_Day_5__r.Day__c,
                                        Treatment_1__c,Competitor_Products__c,Treatment_1__r.name,Treatment_2__c,Treatment_2__r.name,Treatment_3__c,Treatment_3__r.name,Treatment_4__c, Treatment_4__r.name,Treatment_5__c,Treatment_5__r.name  
                                        FROM  Campaign WHERE id =:campaignid];
                system.debug('campiagn==='+observCampaign);    
                for(Campaign  c :observCampaign){
                    if(c.Date_of_Application__c!=NULL){
                        dateofAppln = c.Date_of_Application__c;
                    }
                    if(c.Product_Name__c != NULL){
                        productOrCrop = c.Product_Name__r.Name;
                    } 
                    if(c.Crop_Name__c != NULL){
                        productOrCrop = c.Crop_Name__r.Name;
                    }       
                    system.debug('mapofTreatmentDose>>--------->'+mapofTreatmentDose);
                    applndose = c.Application_Dose_ml_Acre__c;
                    timeofappln = c.Time_of_Application__c;
                    methdofappln = c.Method_of_Application__c;
                    watervolume = c.Water_Volume_L_Acre__c;
                    comptrProd =  c.Competitor_Products__c;
                    campaignName = c.name;
                    campObjetive = c.Objective__c;
                }   
                if(setofcampaigndays.size()>0){
                    system.debug('setofcampaigndays>>------>'+setofcampaigndays);
                    List<Decimal> sortDays = new List<Decimal>();
                    sortDays.addall(setofcampaigndays); 
                    system.debug('sortDays>>------>'+sortDays);
                    sortDays.sort();
                    for(Decimal d :sortDays){
                        campdays = campdays +','+d;
                    } 
                }
                campdays = campdays.replaceFirst(',',''); 
                for(string str :mapoftargetedWeeds.values()){
                    strweeds = strweeds +','+ str;
                } 
                strweeds = strweeds.replaceFirst(',','');
                lstcropoption = new list<selectOption>();
                lstcropoption.add(new selectOption('','--Select--'));
                for( Campaign_Crop_Mapping__c  c : lstofCrops){
                    lstcropoption.add(new selectOption(c.Crop__c,c.Crop__c)); 
                    //lstCropName.add(c.Crop__c);   
                }
               system.debug('selCrop >>------>'+selCrop );
            }
        }catch(Exception e){
            system.debug('Exception-------------'+e);
            system.debug('Exception-------------'+e.getLineNumber());
        }    
            
    }
    //save the Demo observation And call  saveObservationDetails method to save observations
    public PageReference saveobs(){
        PageReference pageref;
        try{
           //system.debug('demoobserobj>>----->'+demoobserobj);
            Demo_Observations__c demoobserobj1 = new Demo_Observations__c();
            demoobserobj1 = demoobserobj;
            system.debug('demoobserobj>>----->'+demoobserobj);
            system.debug('demoobserobj1>>----->'+demoobserobj1);
            system.debug('campaignid>>----->'+campaignid);
            if(demoobserobj1.Campaign_Name__c == Null ){
                demoobserobj1.Campaign_Name__c = campaignid;
            }
            system.debug('demoobserobj>>----->'+demoobserobj);
            if(demoobserobj1 !=NULL){
                upsert demoobserobj1 ; 
                saveObservationDetails(demoobserobj1.id); 
            }  
            pageref = new PageReference ('/' +campaignid);         
            }catch(Exception e){
                system.debug('Exception====='+e);
                system.debug('Exception====='+e.getLineNumber());
             }
        return pageref;       
    } 
    //method to load observation data in Observation table                
    public void loadPage(){
        mapCampaginDay = new Map<String,Map<String,Observation__c>>();
        mapTargetWeed = new Map<String,Observation__c>();
        mapObservation = new map<string,Observation__c>(); 
        listObservation = new List<Observation__c>(); 
        listCampaignDay = [SELECT Id, Name,Day__c,Campaign_Day_Code__c FROM Campaign_Day__c WHERE Day__c in :setofcampaigndays order by day__c];
        listTreatment = [SELECT Id, Name,Dose__c, treatment_code__c FROM Treatment__c WHERE Name in :setofTreatment ];
        listTargetWeed = [SELECT Id, Name, Target_Weed_Code__c FROM Target_Weed__c WHERE id in :mapoftargetedWeeds.keyset()];   
        if(demoobservId!=Null){
            listObservation = [SELECT id,Target_Weed__c,Target_Weed__r.Name,Treatment__c,Treatment__r.Name,Campaign_Name__c, Campaign_Day__r.Name,Campaign_Day__r.Day__c, Rating__c  FROM Observation__c WHERE Demo_Observations__c=:demoobservId ];//'a2x0k00000090pA'];
            system.debug('listObservation >>----->'+listObservation.size());
        }      
        if(listObservation.size()>0){  
            for(Observation__c o : listObservation){                  
                setofTreatment.add(o.Treatment__r.Name);
                mapoftargetedWeeds.put(o.Target_Weed__c,o.Target_Weed__r.Name);
                setofcampaigndays.add(o.Campaign_Day__r.Day__c);
                mapofTreatmentDose.put(o.Treatment__r.Name,0.0);
            }
            system.debug('lstofCrops >>--->'+lstofCrops);
            for( Campaign_Crop_Mapping__c  c : lstofCrops){
                if(mapofTreatmentDose.containskey(c.Treatment_1__r.Name)){
                    mapofTreatmentDose.put(c.Treatment_1__r.Name,c.Treatment_1_Dose_ml_acre__c); 
                }
                if(mapofTreatmentDose.containskey(c.Treatment_2__r.Name)){
                    mapofTreatmentDose.put(c.Treatment_2__r.Name,c.Treatment_2_Dose_ml_acre__c);
                }
                if(mapofTreatmentDose.containskey(c.Treatment_3__r.Name)){
                    mapofTreatmentDose.put(c.Treatment_3__r.Name,c.Treatment_3_Dose_ml_acre__c);
                }
                if(mapofTreatmentDose.containskey(c.Treatment_4__r.Name)){
                    mapofTreatmentDose.put(c.Treatment_4__r.Name,c.Treatment_4_Dose_ml_acre__c);
                }
                if(mapofTreatmentDose.containskey(c.Treatment_5__r.Name)){
                    mapofTreatmentDose.put(c.Treatment_5__r.Name,c.Treatment_5_Dose_ml_acre__c);
                }
            }      
            listCampaignDay = [SELECT Id, Name,Day__c,Campaign_Day_Code__c FROM Campaign_Day__c WHERE Day__c in :setofcampaigndays order by day__c];
            listTreatment = [SELECT Id, Name,Dose__c, treatment_code__c FROM Treatment__c WHERE Name in :setofTreatment ];
            listTargetWeed = [SELECT Id, Name, Target_Weed_Code__c FROM Target_Weed__c WHERE id in :mapoftargetedWeeds.keyset()];   
            system.debug('setofTreatment>>------>'+setofTreatment.size());
            system.debug('listObservation>>----->'+listObservation.size());
            system.debug('setofTreatment>>----->'+setofTreatment);     
            system.debug('listCampaignDay >>----->'+listCampaignDay);
            system.debug('listTreatment>>----->'+listTreatment);
            system.debug('listTargetWeed >>----->'+listTargetWeed);
            for(Observation__c o : listObservation){                    
                mapObservation.put(o.Treatment__r.Name+'-'+o.Campaign_Day__r.Name+'-'+o.Target_Weed__r.Name,o); 
            }
        }else{
              for(Treatment__c treatment : listTreatment ){
                 for(Campaign_Day__c campaignDay : listCampaignDay){
                     for(Target_Weed__c targetWeed : listTargetWeed){
                         Observation__c obser = new Observation__c();
                         obser.Treatment__c = treatment.id;
                         obser.Campaign_Day__c= campaignDay.id;
                         obser.Target_Weed__c = targetWeed.id;
                         mapObservation.put(treatment.Name+'-'+campaignDay.Name+'-'+targetWeed.Name,obser);    
                     }
                 }
              }
         }  
         system.debug('setofTreatment>>----->'+setofTreatment);         
    }
    
    public void cropfilterObservation(){
        // this.selCrop = Apexpages.currentPage().getParameters().get('cropName');
        system.debug('selCrop>>----->'+selCrop);
        mapoftargetedWeeds = new map<string,string>();
        setofcampaigndays = new set<Decimal>();
        setofTreatment = new set<string>();
        strweeds  = '';
        campdays ='';   
        //To get Crop Wise Treatements, target Weeds And Campaign Days from crop Observation  
        lstCampCropMap  = [SELECT Id, Name, Crop__c,Crop_Name__c,Crop_Name__r.Name, Category__c, Campaign_Day_1__c,Campaign_Day_1__r.Day__c, Campaign_Day_3__c,Campaign_Day_3__r.Day__c, Campaign_Day_2__c,Campaign_Day_2__r.Day__c, Campaign_Day_4__c,Campaign_Day_4__r.Day__c, Campaign_Day_5__c,Campaign_Day_5__r.Day__c, 
                            Target_Weed_1__c,Target_Weed_1__r.Name, Target_Weed_2__c, Target_Weed_2__r.Name , Target_Weed_3__c,Target_Weed_3__r.Name, Target_Weed_4__c,Target_Weed_4__r.Name, Target_Weed_5__c,Target_Weed_5__r.Name, 
                            Treatment_1__c,Treatment_1__r.Name, Treatment_2__c,Treatment_2__r.Name, Treatment_4__c,Treatment_4__r.Name, Treatment_5__c,Treatment_5__r.Name, Treatment_3__c,Treatment_3__r.Name,
                            Treatment_1_Dose_ml_acre__c, Treatment_2_Dose_ml_acre__c, Treatment_3_Dose_ml_acre__c, Treatment_4_Dose_ml_acre__c, Treatment_5_Dose_ml_acre__c, Campaign__c 
                            FROM Campaign_Crop_Mapping__c WHERE Campaign__c =: campaignid AND Crop__c =: selCrop limit 1];   
        Crop__c cropObj = new Crop__c();
        cropObj = [SELECT Id, Name, SalesOrg__c, Sales_Org_Code__c, Crop_Type__c, Active__c FROM Crop__c WHERE Sales_Org_Code__c = '1000' AND Name =: selCrop  limit 1];
        Campaign_Crop_Mapping__c campCropMapObj = new Campaign_Crop_Mapping__c ();
        campCropMapObj = lstCampCropMap[0];
        campCropMapObj.Crop_Name__c = cropObj.id;      
        demoobserobj.crop__c = cropObj.id;               
        if(campCropMapObj != null && cropObj != NULL){
            update campCropMapObj;       
        } 
        for(Campaign_Crop_Mapping__c c : lstCampCropMap){
            if(c.Target_Weed_1__c!=NULL){
                mapoftargetedWeeds.put(c.Target_Weed_1__c,c.Target_Weed_1__r.Name);
            }
            if(c.Target_Weed_2__c!=NULL){
                mapoftargetedWeeds.put(c.Target_Weed_2__c,c.Target_Weed_2__r.Name);
            }
            if(c.Target_Weed_3__c!=NULL){
                mapoftargetedWeeds.put(c.Target_Weed_3__c,c.Target_Weed_3__r.Name);
            }
            if(c.Target_Weed_4__c!=NULL){
                mapoftargetedWeeds.put(c.Target_Weed_4__c,c.Target_Weed_4__r.Name);
            }
            if(c.Target_Weed_5__c!=NULL){
                 mapoftargetedWeeds.put(c.Target_Weed_5__c,c.Target_Weed_5__r.Name);
            }
            if(c.Campaign_Day_1__c!=NULL){
                 system.debug('Day__c>>----->'+c.Campaign_Day_1__r.Day__c);
                 setofcampaigndays.add(c.Campaign_Day_1__r.Day__c);
            }
            if(c.Campaign_Day_2__c!=NULL){
                 system.debug('Day__c>>----->'+c.Campaign_Day_2__r.Day__c);
                 setofcampaigndays.add(c.Campaign_Day_2__r.Day__c);
            }
            if(c.Campaign_Day_3__c!=NULL){
                 system.debug('Day__c>>----->'+c.Campaign_Day_3__r.Day__c);
                 setofcampaigndays.add(c.Campaign_Day_3__r.Day__c);
            }
            if(c.Campaign_Day_4__c!=NULL){
                system.debug('Day__c>>----->'+c.Campaign_Day_4__r.Day__c);
                setofcampaigndays.add(c.Campaign_Day_4__r.Day__c);
            }
            if(c.Campaign_Day_5__c!=NULL){
                setofcampaigndays.add(c.Campaign_Day_5__r.Day__c);
            }
            if(c.Treatment_1__c!=NULL && c.Treatment_1_Dose_ml_acre__c!= NULL ){
                setofTreatment.add(c.Treatment_1__r.Name);
                mapofTreatmentDose.put(c.Treatment_1__r.Name,c.Treatment_1_Dose_ml_acre__c); 
            }
            if(c.Treatment_2__c!=NULL && c.Treatment_2_Dose_ml_acre__c!= NULL  ){
                setofTreatment.add(c.Treatment_2__r.Name);
                mapofTreatmentDose.put(c.Treatment_2__r.Name,c.Treatment_2_Dose_ml_acre__c);
            }
            if(c.Treatment_3__c!=NULL && c.Treatment_3_Dose_ml_acre__c!= NULL){
                setofTreatment.add(c.Treatment_3__r.Name);
                mapofTreatmentDose.put(c.Treatment_3__r.Name,c.Treatment_3_Dose_ml_acre__c);
            }
            if(c.Treatment_4__c!=NULL && c.Treatment_4_Dose_ml_acre__c!= NULL){
                setofTreatment.add(c.Treatment_4__r.Name);
                mapofTreatmentDose.put(c.Treatment_4__r.Name,c.Treatment_4_Dose_ml_acre__c);
            }
            if(c.Treatment_5__c!=NULL && c.Treatment_5_Dose_ml_acre__c != NULL){
                setofTreatment.add(c.Treatment_5__r.Name);
                mapofTreatmentDose.put(c.Treatment_5__r.Name,c.Treatment_5_Dose_ml_acre__c);
            }
            system.debug('observCampaign---------'+c.Treatment_1__c);
        }  
        if(setofcampaigndays.size()>0){
            system.debug('setofcampaigndays>>------>'+setofcampaigndays);
            List<Decimal> sortDays = new List<Decimal>();
            sortDays.addall(setofcampaigndays); 
            system.debug('sortDays>>------>'+sortDays);
            sortDays.sort();
            for(Decimal d :sortDays){
                campdays = campdays +','+d;
            } 
        }
        campdays = campdays.replaceFirst(',','');  
        for(string str :mapoftargetedWeeds.values()){
            strweeds = strweeds +','+ str;
        } 
        strweeds = strweeds.replaceFirst(',','');
        loadPage();  
        system.debug('listTreatment>>----->'+listTreatment.size());
    }
    //Redirect To campaign Page without saving demo observation
    public PageReference cancelDemoObser(){
        system.debug('campaignid>>----->'+campaignid);
        PageReference  pageref = new PageReference ('/'+campaignid);
        return pageref; 
    }
    //called by saveobser() method to save observation Details
    public void saveObservationDetails(String observationId){
        try{
            List<Observation__c> listObservation = new List<Observation__c>();
            listObservation = mapObservation.values();  
            for(Observation__c obs : listObservation){
                 obs.Demo_Observations__c = observationId; 
                 obs.Campaign_Name__c= campaignid ; 
            } 
            if(listObservation.size()>0){            
                upsert listObservation;
            }
        }catch(Exception ex){
            System.Debug('Upsert issue =========== > ' + ex);
        }
    }        

}