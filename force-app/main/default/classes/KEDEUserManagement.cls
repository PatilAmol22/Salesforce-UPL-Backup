/*
 @Author: Pranav Dinakaran
 @CLass_Discription: This Class is executed by Schedular it Removes all Inactive Users from  Kede Objects. 
*/
public class KEDEUserManagement{
public List<Territory_Distributor__c> TerrList; // To Hold all Territory object Record
public List<Region__c> RegionList; // To Hold all Region object Record
public List<Zone__c> ZoneList; // To Hold all Zone object Record
public List<SBU__c> SBUList; // To Hold all SBU object Record


    // Constructor to retrieve all KEDE Objects where User set in the lookup field are InActive
    public KEDEUserManagement(){
        TerrList = new List<Territory_Distributor__c >([SELECT Id, Name, TerritoryManagerActive__c, TerritoryManager__c, TerritoryCode__c 
                                                           FROM Territory_Distributor__c where TerritoryManagerActive__c = FALSE]);
        RegionList = new List<Region__c>([SELECT Id, Name, RegionHeadActive__c, RegionHead__c 
                                                           FROM Region__c where RegionHeadActive__c = FALSE ]);
        ZoneList = new List<Zone__c>([SELECT Id, Name, ZonalHeadActive__c, ZonalHead__c 
                                                           FROM Zone__c where ZonalHeadActive__c = FALSE]);
                                                           
        SBUList = new List<SBU__c>([SELECT Id, Name, SBUUser__c, SBUUserActive__c FROM SBU__c where SBUUserActive__c = FALSE ]);
       // Calling Method
        updateKede();
    }
    // Method to Remove all InACtive Users from all Kede Objects fields
    public void updateKede(){
        for(Territory_Distributor__c t : TerrList){
                t.TerritoryManager__c = Null;     // Setting User lookup field to Null    
        }
        update TerrList;
        
        for(Region__c r : RegionList){
                r.RegionHead__c = Null;        // Setting User lookup field to Null
        }
        update RegionList;
        
        for(Zone__c z : ZoneList ){
                z.ZonalHead__c = Null;        // Setting User lookup field to Null
        }
        update ZoneList;
        
        for(SBU__c sb : SBUList ){
                sb.SBUUser__c = Null;        // Setting User lookup field to Null
        }
        update SBUList;
    }
}