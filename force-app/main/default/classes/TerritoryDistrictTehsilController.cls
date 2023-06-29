/*
@Author: Pranav Dinakaran
@Class_Decription: Controller of VF page TerritoryDistrictTehsil. To Create Mapping Territory with Tehsil
*/
public class TerritoryDistrictTehsilController{
    public List<District__c> DistrictList;
    Public List<String> DistrictListString{get;set;} // District Picklist
    Public String SelectedDistrict{get;set;}
    Public GenerateDataWrapper wrapObject {get;set;} // Wrapper Var to Dispaly Data on District Selection
    public List<DistrictTerritoryMapping__c> DistrictTerritoryMappingList;
    Public Set<ID> DistrictIDSet;
    public Map<String,String> DistrictIDNameMap;
    public Map <Id, Territory_Distributor__c> TerritoryMap; 
    public Map <Id, Tehsil__c> TehsilMap;  
    public Map <String, List<Territory_Distributor__c>> DistrictTerritoryMap;
    public MAP<ID,TM_District_Tehsil_Mapping__c> ExistingMappingMap;
    public String SelectedTerritory {get;set;} // Territory Selection only Single Territory can be Selected
    public List<String> SelectedTehsil {get;set;} // Multiple Tehsil Selected in vf page STored here
    public List<String> PendingTMTehsilMapping {get;set;}
    public List<String> SelectedTMTehsilMapping {get;set;}
    
    // Constructor to Prepare data and also Populate district values that to be displayed in vf page 
    public TerritoryDistrictTehsilController(){
            try{
                SelectedDistrict = '';
                
                DistrictListString = new List<String>();
                DistrictIDNameMap = new Map<String,String>();
                
                TerritoryMap = new Map<Id,Territory_Distributor__c>([select id, name, TerritoryManager__c, TerritoryManagerActive__c,OwnershipofAccount__c,TerritoryCode__c from Territory_Distributor__c]);
                TehsilMap = new Map<Id, Tehsil__c>();
                
                ExistingMappingMap = new Map<Id,TM_District_Tehsil_Mapping__c>();
                
                // Retrieve List of District Territory Mapping
                DistrictTerritoryMappingList = new List<DistrictTerritoryMapping__c>([select id , name , Territory__c,Territory__r.TerritoryManager__c,Territory__r.TerritoryManagerActive__c,  District__c,  District__r.Name from DistrictTerritoryMapping__c ]);
                DistrictTerritoryMap = new Map <String, List<Territory_Distributor__c>>();
                DistrictIDSet = new Set<ID>();
               
               // Iterate Throgh Loop to Prepare DistrictTerritoryMap also Prepare DistrictIDSet
                for(DistrictTerritoryMapping__c dl : DistrictTerritoryMappingList){
                    List<Territory_Distributor__c> TempList = new List<Territory_Distributor__c>();
                    DistrictIDSet.add(dl.District__c);
                    if(DistrictTerritoryMap.containsKey(dl.District__r.Name)){
                       TempList = DistrictTerritoryMap.get(dl.District__r.Name);
                       TempList.add(TerritoryMap.get(dl.Territory__c));
                       DistrictTerritoryMap.put(dl.District__r.Name, TempList);
                    }
                    else{
                        TempList.add(TerritoryMap.get(dl.Territory__c));
                        DistrictTerritoryMap.put(dl.District__r.Name, TempList);
                    }
                 }
                 
                 // Retrieve only those District Records which id is present in DistrictIDSet
                 DistrictList = new List<District__c>();
                 DistrictList = [select id, name from District__c where id IN: DistrictIDSet];
                 
                 
                 // Put District Name in  DistrictListString to Display District Picklist in vf page  
                 for(District__c distObj: DistrictList){
                     DistrictListString.add(distObj.name);
                     String temp =
                     DistrictIDNameMap.put(distObj.name,String.Valueof(distObj.ID));
                 }
                 
             }
             catch(exception e){
                 system.debug(e);
             }
    }
    
    // This Method is used to Dispaly Wrapper data on district Selection 
    // Territory , Tehsil , Territory - Tehsil Mapping Record  and  Territory - Tehsil Mapping Record where Records are shared
    public void GenerateData(){
        SelectedTerritory ='';
        SelectedTehsil = new List<String>();
        PendingTMTehsilMapping = new List<String>();
        SelectedTMTehsilMapping = new List<String>();
        ExistingMappingMap = new Map<Id,TM_District_Tehsil_Mapping__c>();
         TehsilMap = new Map<Id, Tehsil__c>();
        system.debug('SelectedDistrict :: '+SelectedDistrict);
        
        // If selected District is not Null then Retrieve all data annd add it to wrapObject.
        if(SelectedDistrict != ''){
            list<TM_District_Tehsil_Mapping__c>  ExistingMapList = new List<TM_District_Tehsil_Mapping__c>([select id, Name, Territory__c,TM_User__c, DeleteRequested__c, District__c,Tehsil__r.Name, Tehsil__c 
                                                                                                                                                    from TM_District_Tehsil_Mapping__c where District__r.Name =: SelectedDistrict]);
            ExistingMappingMap.putAll(ExistingMapList);
            
            List<Tehsil__c> TempTehsilList= new List<Tehsil__c>([Select id, name, District__c from Tehsil__c where District__r.Name =: SelectedDistrict]);
            TehsilMap.putAll(TempTehsilList);
           
            List<Territory_Distributor__c> TerritoryList = new List<Territory_Distributor__c>();
            List<TM_District_Tehsil_Mapping__c> PendingTMMappingList = new List<TM_District_Tehsil_Mapping__c>([select id, Name, Territory__c,TM_User__c, DeleteRequested__c, District__c, Tehsil__c, Tehsil__r.Name, RecordShared__c  
                                                                                                                                                                                        from TM_District_Tehsil_Mapping__c 
                                                                                                                                                                                         where District__r.Name =: SelectedDistrict AND RecordShared__c = False ]);
                                                                                                                                                                                         
            List<TM_District_Tehsil_Mapping__c> DeleteTMMappingList = new List<TM_District_Tehsil_Mapping__c>([select id, Name, Territory__c,TM_User__c, DeleteRequested__c, District__c, Tehsil__c, Tehsil__r.Name, RecordShared__c  
                                                                                                                                                                                        from TM_District_Tehsil_Mapping__c 
                                                                                                                                                                                         where District__r.Name =: SelectedDistrict AND DeleteRequested__c = True ]);
                                                                                                                                                                                         
                                                                                                                                                                                         
            List<TM_District_Tehsil_Mapping__c> ExistingTMMappingList = new List<TM_District_Tehsil_Mapping__c>([select id, Name, Territory__c,TM_User__c, District__c,DeleteRequested__c, Tehsil__c, Tehsil__r.Name, RecordShared__c 
                                                                                                                                                                                        from TM_District_Tehsil_Mapping__c 
                                                                                                                                                                                        where District__r.Name =: SelectedDistrict AND RecordShared__c = TRUE AND DeleteRequested__c = False]);
            Set<ID> TehsilIDSET = new Set<ID>();
            List<Tehsil__c> TehsilList = new List<Tehsil__c>();
            // Start putting in Wrapper object
            wrapObject = new GenerateDataWrapper();
           
            // Retrieve Selected District all Territory List
            // put it in wrapObject.WrapTMLIST 
            if(DistrictTerritoryMap.containsKey(SelectedDistrict)){
                TerritoryList = DistrictTerritoryMap.get(SelectedDistrict);  
                system.debug('TerritoryList ::'+TerritoryList);
                if(TerritoryList !=  NULL){
                    for(Territory_Distributor__c td : TerritoryList){
                        String temp = td.Name + '-'+ td.TerritoryCode__c;
                       wrapObject.WrapTMLIST.add(new SelectOption(td.id,temp));
                    }
                }
             }
             
            //For Existing Mapping Record  wrapObject.WrapExistingTMMappingList
            // Also add all Tehsil id in TehsilIDSET Set
             if(ExistingTMMappingList.size()>0){
                 for(TM_District_Tehsil_Mapping__c tdm : ExistingTMMappingList){
                     TehsilIDSET.add(tdm.Tehsil__c);
                       wrapObject.WrapExistingTMMappingList .add(new SelectOption(tdm.id,tdm.name));
                 }
                 
              }
            
              //For Existing Mapping Reocrd whose Tehsil Account Share is not done put it in wrapObject.PendingTMMappingList
             // Also add all Tehsil id in TehsilIDSET Set
              if(PendingTMMappingList .size()>0){
                 for(TM_District_Tehsil_Mapping__c tdm : PendingTMMappingList ){
                     TehsilIDSET.add(tdm.Tehsil__c);
                       wrapObject.PendingTMMappingList.add(new SelectOption(tdm.id,tdm.name));
                 }
                 
              }
              
              // Also add all Tehsil id in TehsilIDSET Set
              if(DeleteTMMappingList.size()>0){
                  for(TM_District_Tehsil_Mapping__c tdm : DeleteTMMappingList){
                     TehsilIDSET.add(tdm.Tehsil__c);
                    }
                 
              }
             
             // Retrieve Only those Tehsil where Mapping has not been done
              TehsilList = [select id, name from Tehsil__c where District__r.Name =: SelectedDistrict AND id NOT IN: TehsilIDSET ];
              system.debug('TehsilList :::'+ TehsilList);
             
             // Add those tehsil wrapObject.WrapTehsilList
              if(TehsilList.size()>0){
                   for(Tehsil__c th :TehsilList){
                      wrapObject.WrapTehsilList.add(new SelectOption(th.id,th.name));
                   }
              }           
           system.debug('wrapObject ::' + wrapObject );
        }
        // If Selected District is blank then Reset the Wrapper
        else{
            wrapObject = new GenerateDataWrapper();
        }
        
    
    }
    
    // This Method is Used Create Territory Tehsil Mapping Record
    public void AddMapping(){
        if(SelectedTerritory != '' && SelectedTehsil.size()>0){
            List<TM_District_Tehsil_Mapping__c> InsertMappingList = new List<TM_District_Tehsil_Mapping__c>();
            for(String s : SelectedTehsil){
                if(TerritoryMap.get(SelectedTerritory).OwnershipofAccount__c != 'BLANK'){
                    TM_District_Tehsil_Mapping__c tmap = new TM_District_Tehsil_Mapping__c();
                    tmap.Name = SelectedDistrict+'-'+ TerritoryMap.get(SelectedTerritory).Name +'-'+TehsilMap.get(s).Name;
                    tmap.District__c =  DistrictIDNameMap.get(SelectedDistrict);
                    tmap.TM_User__c =   TerritoryMap.get(SelectedTerritory).OwnershipofAccount__c;                
                    tmap.Territory__c = TerritoryMap.get(SelectedTerritory).id;
                    tmap.Tehsil__c = TehsilMap.get(s).ID;              
                    InsertMappingList.add(tmap);             
                }
            }
            
            insert InsertMappingList;
        }
        // To calling this method We againg Preparing the Wrapper Record so that changes Reflect
        GenerateData();
    }
    
    // This Method is to delete Mapping Record whose Sharing Batch is not got Executed
    public void DeleteMapping(){
        List<TM_District_Tehsil_Mapping__c> DeleteMappingList = new List<TM_District_Tehsil_Mapping__c>();
        system.debug('PendingTMTehsilMapping ::'+ PendingTMTehsilMapping);
       
        if(PendingTMTehsilMapping.size()>0){
            for(String s : PendingTMTehsilMapping){
               
                    DeleteMappingList.add(ExistingMappingMap.get(s));
              
            }
        }
        if(DeleteMappingList.size()>0){
            delete DeleteMappingList;
        }
        
        // To calling this method We againg Preparing the Wrapper Record so that changes Reflect
        GenerateData();
    }
    
    // This Method is to delete The final Mapping where SHaring Batch has been executed 
    // Here we dont actually delete the record we set Delete Requeste Checkbox.
    // To delete Final Mapping Record Batch is Runned every 30 mins. That Batch will Remove all Share Record of Accounts  and delete Mapping Record.
    public void DeleteFinalMapping(){
        List<TM_District_Tehsil_Mapping__c> DeleteMappingList = new List<TM_District_Tehsil_Mapping__c>();
        system.debug('SelectedTMTehsilMapping ::'+ SelectedTMTehsilMapping);
       
        if(SelectedTMTehsilMapping.size()>0){
            for(String s : SelectedTMTehsilMapping){
                   TM_District_Tehsil_Mapping__c  tempobj = ExistingMappingMap.get(s);
                    tempobj.DeleteRequested__c = True;
                 DeleteMappingList.add(tempobj);
                             
            }
        }
        if(DeleteMappingList.size()>0){
        update DeleteMappingList;
        }
        GenerateData();
    }
    
    // Wrapper class to display data in Vf page
    
     Public class GenerateDataWrapper{
        public List<SelectOption> WrapTMLIST {get;set;} // based on selected District we show List of Territory
        public List<SelectOption> WrapTehsilList {get;set;} // based on selected District we show List of Tehsil whose mapping Record is not Created
        public List<SelectOption> PendingTMMappingList {get;set;} // based on selected District we show Mapping Record whose Sharing Batch is not Yet Executed
        Public List<SelectOption> WrapExistingTMMappingList {get;set;} // based on selected District we show List of Territory-Tehsil Mapping Records whose Share Batch is also Executed.
        public GenerateDataWrapper(){
            WrapTMLIST = new List<SelectOption>();
            WrapTehsilList = new List<SelectOption>();
            PendingTMMappingList = new List<SelectOption>();
            WrapExistingTMMappingList = new  List<SelectOption>();
        }
    }

}