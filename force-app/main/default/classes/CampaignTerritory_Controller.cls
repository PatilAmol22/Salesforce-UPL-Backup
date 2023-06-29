public class CampaignTerritory_Controller{
    public SelectOption[] selectedTerritories { get; set; }
    public SelectOption[] allTerritories { get; set; }
    public String redirectUrl {public get; private set;}
    public Boolean shouldRedirect {public get; private set;}
    public List<Territory_Distributor__c > territories;
    public map<id,Territory_Distributor__c> mapterritories;
    public List<Campaign_user_Mapping__c> terrtyMans;
    public Id campaignId;
    public list<Campaign_user_Mapping__c> asignTerrMan;
    public map<id,Campaign_user_Mapping__c> mapofAssignTerrMan;
    public set<Campaign_user_Mapping__c> setofAsignTerrMan;  
    public Map<Id,Territory_Distributor__c> assignTerties;
    public list<Id> assignTerrManIds;
    public map<Id,Territory_Distributor__c > assignTerrIds;
    public  Id userId;
    public Id profileId;
    public string proflName;
    public list<Id> selTerrIds;
    public map<id,Campaign_user_Mapping__c> deleteCamUserMap;
    public map<id,Campaign_user_Mapping__c> mapcurrcampusersmap;
    public map<id,Campaign_user_Mapping__c>  mapcampusermap;
    public list<Territory_Distributor__c> listTerritories;
    public ApexPages.StandardController stdController;
    public boolean isZMM;
    
    
    public CampaignTerritory_Controller(ApexPages.StandardController stdController){
        campaignId = null;
        this.stdController = stdController;
        shouldRedirect = false;  
        campaignId = stdController.getRecord().id;
        userId =  UserInfo.getUserId();
        system.debug('userId>>----->'+userId);
        profileId = UserInfo.getProfileId();
        listTerritories = new list<Territory_Distributor__c>();
        proflName  = [select Name from profile where id = :profileId].Name ;
        system.debug('profile====='+proflName);
        system.debug('campaignId-----'+campaignId);
        terrtyMans = new List<Campaign_user_Mapping__c>();
        selectedTerritories = new List<SelectOption>();
        assignTerrManIds = new list<Id>();
        assignTerrIds = new map<Id,Territory_Distributor__c >();
        mapofAssignTerrMan = new map<id,Campaign_user_Mapping__c>();
        setofAsignTerrMan = new set<Campaign_user_Mapping__c>();
        deleteCamUserMap = new map<id,Campaign_user_Mapping__c>();
        territories = new List<Territory_Distributor__c >();
        terrtyMans = new List<Campaign_user_Mapping__c>();
        asignTerrMan = new list<Campaign_user_Mapping__c>();
        mapofAssignTerrMan = new map<id,Campaign_user_Mapping__c>();
        mapcampusermap = new map<id,Campaign_user_Mapping__c>();
        setofAsignTerrMan = new set<Campaign_user_Mapping__c>();
        mapcurrcampusersmap = new map<id,Campaign_user_Mapping__c>();
        mapterritories = new map<id,Territory_Distributor__c>();
        
        listTerritories =[SELECT Name,Id,TerritoryManager__c FROM  Territory_Distributor__c where TerritoryManager__c != Null AND Neglected__c = false AND Present_in_KEDE__c = true AND Zone__r.ZMMUser__c =: userId  AND Sales_Org_Code__c='1000' ORDER BY Name];
        if(!listTerritories.isEmpty()){
            isZMM = true;    
        }
        onLoadController();
        
    }
    
    public void save1() {
        selTerrIds = new list<Id>();
        map<id,id> mapselterr = new map<id,id>();
        
        if(selectedTerritories.size() != 0){
            for(SelectOption so : selectedTerritories){
                mapselterr.put(so.getValue(),so.getValue());  
            }
        }
        
        if(selectedTerritories.size()==0){
            for(Id i :assignTerrIds.keySet()){
                    selTerrIds.add(i);
            }
        }
        if(selectedTerritories.size()!=0){    
            
            for(id tid : assignTerrIds.keySet()){
                if(!mapselterr.containskey(tid)){
                    selTerrIds.add(tid);    
                }
            }
            
        }
        system.debug('selTerrIds>>----->'+selTerrIds);
        Map<id,Territory_Distributor__c> mapofSelTerr = new Map<id,Territory_Distributor__c>();
        for(Territory_Distributor__c t :[SELECT Name,Id,TerritoryManager__c,Region__r.RegionHead__c,RegionalManager__c FROM  Territory_Distributor__c where Id IN: selTerrIds]){
            mapofSelTerr.put(t.TerritoryManager__c,t);
            if(!mapofSelTerr.containskey(t.Region__r.RegionHead__c)){
                mapofSelTerr.put(t.Region__r.RegionHead__c,t);
            }
        }
        
            system.debug('mapofSelTerr'+mapofSelTerr.size());
            for(Territory_Distributor__c  td :mapofSelTerr.values()){
                system.debug('record>>----->'+td);
            }
    
        for(Campaign_user_Mapping__c cumapp : asignTerrMan){    
                if(mapofSelTerr.containsKey(cumapp.User__c)){
                        deleteCamUserMap.put(cumapp.id,cumapp);                
                }
        }  
        if(deleteCamUserMap.size()>0){
            delete deleteCamUserMap.values();
        }
        system.debug('mapterritories>>----->'+mapterritories);
        for(SelectOption so : selectedTerritories){
                if(mapterritories.containsKey(so.getValue())){
                    if(!assignTerrIds.containskey(so.getValue())){
                        Territory_Distributor__c t = new Territory_Distributor__c();
                        t = mapterritories.get(so.getValue());
                        Campaign_user_Mapping__c camUserMapObj = new Campaign_user_Mapping__c();          
                        camUserMapObj.Campaign__c = campaignId;
                        camUserMapObj.User__c = t.TerritoryManager__c;
                        camUserMapObj.Checked_Zonal_User__c = false;
                        system.debug('camUserMapObj------'+camUserMapObj);
                        
                    
                        //system.debug('territory Manager----'+t.TerritoryManager__c);
                        if(!mapcurrcampusersmap.containsKey(t.TerritoryManager__c)){
                            terrtyMans.add(camUserMapObj);         
                        }
                   }
            }
        }
        shouldRedirect = true;
        redirectUrl = stdController.view().getUrl();
        system.debug('terrtyMans==='+terrtyMans);
        if(terrtyMans.size()>0){
            upsert terrtyMans;
        }        
    }
    
    public void onLoadController(){
        try{
                selTerrIds = new list<Id>();
                mapcampusermap = new map<id,Campaign_user_Mapping__c>([SELECT id,Campaign__c,User__c 
                                                                       FROM Campaign_user_Mapping__c 
                                                                       WHERE Campaign__c =:campaignId]);
                for(Campaign_user_Mapping__c camp : mapcampusermap.values()){
                    mapcurrcampusersmap.put(camp.User__c,camp);
                }
                asignTerrMan = [SELECT Name,User__c,id,Campaign__c FROM Campaign_user_Mapping__c WHERE Campaign__c =:campaignId];
                system.debug('asignTerrMan==='+asignTerrMan);
            
                if(asignTerrMan.size()>0){
                    system.debug('mapofAssignTerrMan---------------'+mapofAssignTerrMan.size());
                    setofAsignTerrMan.addAll(asignTerrMan);
                    system.debug('setofAsignTerrMan====='+setofAsignTerrMan);
                    
                    for(Campaign_user_Mapping__c cumap :asignTerrMan ){
                        system.debug('cumap.User__c'+cumap.User__c);
                        Id userids = cumap.User__c;
                        assignTerrManIds.add(userids);
                    }
                    
                    system.debug('assignTerrManIds>>----->'+assignTerrManIds);
                    assignTerties = new Map<Id,Territory_Distributor__c>();
                    if( isZMM  || proflName == 'System Administrator'){
                        assignTerties = new Map<Id,Territory_Distributor__c>([SELECT Name,Id,TerritoryManager__c,Region__r.RegionHead__c 
                                                                              FROM  Territory_Distributor__c 
                                                                              WHERE  TerritoryManager__c != Null AND Neglected__c = false
                                                                              AND Present_in_KEDE__c = true AND Zone__r.ZMMUser__c =: userId   
                                                                              AND TerritoryManager__c IN: assignTerrManIds]);//: userId 
                    }else{
                           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'No Territory Assign to this user'));
                         }
                    system.debug('assignTerties ==='+assignTerties);
                    if(assignTerties.isEmpty() || assignTerties == NULL){   
                        selectedTerritories  = new   List<SelectOption>();           
                    }else{
                        for(Territory_Distributor__c  t : assignTerties.values()) {
                            selectedTerritories.add(new SelectOption(t.Id, t.Name));
                            assignTerrIds.put(t.id,t);
                        }
                    }
                    
                    system.debug('mapterritories>>----->'+mapterritories);
                            if(isZMM || proflName == 'System Administrator'){
                        territories = [SELECT Name,Id,TerritoryManager__c,Region__r.RegionHead__c 
                                       FROM  Territory_Distributor__c 
                                       WHERE TerritoryManager__c != Null AND Neglected__c = false AND Present_in_KEDE__c = true AND Zone__r.ZMMUser__c =: userId  AND Sales_Org_Code__c='1000' ORDER BY Name];    
                                
                    }else{
                           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'No Territory Assign to this user'));
                         }
                    system.debug('territories>>----->'+territories);
              
                    allTerritories  = new List<SelectOption>();            
                    if(!territories.isEmpty()){
                    
                        for(Territory_Distributor__c  t : territories){  
                            mapterritories.put(t.id,t);
                            if(assignTerties.isEmpty() || assignTerties == NULL){
                              allTerritories.add(new SelectOption(t.Id, t.Name));
                            }
                            else 
                            if(!assignTerties.containsKey(t.id)){
                                allTerritories.add(new SelectOption(t.Id, t.Name));
                                //mapterritories.put(t.id,t);
                            }        
                        }
                    }else{
                           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'No Territory Assign to this user'));
                         }
                }else{
                      ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please assign Zonal Manager'));
                     }
                system.debug('mapterritories size >>------>'+mapterritories.size());  
          }catch(Exception e){
              system.debug('Exception');
              system.debug('Linenumber---'+e.getLineNumber());
              system.debug('StackTraceString---'+e.getStackTraceString());     
          }
    }
}