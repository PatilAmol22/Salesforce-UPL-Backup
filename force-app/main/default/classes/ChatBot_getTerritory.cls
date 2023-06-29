public class ChatBot_getTerritory {
public class PrechatOutput{
    	@InvocableVariable
        public List<Territory_Distributor__c> listOfTerritory = new list<Territory_Distributor__c>();
    	@InvocableVariable
    	public boolean isError = false;
    	 
    }
    public class PrechatInput{
        //@InvocableVariable
        //public String sTerritoryName; 
        @InvocableVariable
        public String sUserName;
        @InvocableVariable
        public String sUserRole;
        @InvocableVariable
        public String sUserId;
        @InvocableVariable
        public String sCountryName;
        
    }
    
    @InvocableMethod(label='Get Territories')
    public static List<PrechatOutput> getTerritoryData(List<PrechatInput> inputParameters){
        //String territoryName=inputParameters[0].sTerritoryName;
        String userName=inputParameters[0].sUserName;
        String userRole=inputParameters[0].sUserRole;
        String userId=inputParameters[0].sUserId;
        String CountryName=inputParameters[0].sCountryName;
        system.debug('countryName-->'+CountryName);
        system.debug('user Role-->'+userRole);
        
        List<PrechatOutput> po=new List<PrechatOutput>();
        PrechatOutput prechatobject=new PrechatOutput();
        List<Territory_Distributor__c> territoryList=new List<Territory_Distributor__c>();
        Map<String,Territory_Distributor__c> territoryMap=new Map<String,Territory_Distributor__c>();
        
        if(CountryName.containsIgnoreCase('India')){
            if(userRole=='TM'){
                territoryList=[SELECT Id, Name,TerritoryCode__c,TerritoryManager__c,RegionalManager__c,
                                   ZonalManager__c,Zonal_Manager_Id__c, SBU__c, Zone__c, SBUHead__c
                                   FROM Territory_Distributor__c
                                   WHERE Present_in_KEDE__c = true
                                   AND Neglected__c = false
                                   AND TerritoryCode__c != '#'
                                   AND  TerritoryManager__c=:userId
                                   AND Sales_Org_Code__c='1000'];
                
                for( Territory_Distributor__c td :territoryList){
                  territoryMap.put(td.Name,td);
              }
            }
            if(userRole=='ZM'){
                territoryList=[SELECT Id, Name,TerritoryCode__c,TerritoryManager__c,RegionalManager__c,
                               ZonalManager__c, SBU__c,  Zone__c, SBUHead__c
                               FROM Territory_Distributor__c
                               WHERE Present_in_KEDE__c = true
                               AND Neglected__c = false
                               AND TerritoryCode__c != '#'
                               AND  Zonal_Manager_Id__c= :userId
                               AND Sales_Org_Code__c='1000'];
                
                for( Territory_Distributor__c td :territoryList){
                  territoryMap.put(td.Name,td);
              }
            }
            if(userRole=='SBU'){
                territoryList=[SELECT Id, Name,TerritoryCode__c,TerritoryManager__c,RegionalManager__c,
                               ZonalManager__c,Zonal_Manager_Id__c, SBU__c, Zone__c, SBUHead__c
                               FROM Territory_Distributor__c
                               WHERE Present_in_KEDE__c = true
                               AND Neglected__c = false
                               AND TerritoryCode__c != '#'
                               AND  SBU_Head_Id__c=:userId
                               AND Sales_Org_Code__c='1000'];
                
                for( Territory_Distributor__c td :territoryList){
                  territoryMap.put(td.Name,td);
              }
            }
        }
        if(CountryName.containsIgnoreCase('Swal')){
            if(userRole=='TM'){
                territoryList=[SELECT Id, Name,TerritoryCode__c,TerritoryManager__c,RegionalManager__c,
                                   ZonalManager__c,Zonal_Manager_Id__c, SBU__c, Zone__c, SBUHead__c
                                   FROM Territory_Distributor__c
                                   WHERE Present_in_KEDE__c = true
                                   AND Neglected__c = false
                                   AND TerritoryCode__c != '#'
                                   AND  TerritoryManager__c=:userId
                                   AND Sales_Org_Code__c='1210'];
                
                for( Territory_Distributor__c td :territoryList){
                  territoryMap.put(td.Name,td);
              }
            }
            if(userRole=='ZM'){
                territoryList=[SELECT Id, Name,TerritoryCode__c,TerritoryManager__c,RegionalManager__c,
                               ZonalManager__c, SBU__c,  Zone__c, SBUHead__c
                               FROM Territory_Distributor__c
                               WHERE Present_in_KEDE__c = true
                               AND Neglected__c = false
                               AND TerritoryCode__c != '#'
                               AND  Zonal_Manager_Id__c= :userId
                               AND Sales_Org_Code__c='1210'];
                
                for( Territory_Distributor__c td :territoryList){
                  territoryMap.put(td.Name,td);
              }
            }
            if(userRole=='RM'){
                territoryList=[SELECT Id, Name,TerritoryCode__c,TerritoryManager__c,RegionalManager__c,Region__c,
                               ZonalManager__c, SBU__c,  Zone__c, SBUHead__c
                               FROM Territory_Distributor__c
                               WHERE Present_in_KEDE__c = true
                               AND Neglected__c = false
                               AND TerritoryCode__c != '#'
                               AND  Regional_Manager_Id__c= :userId
                               AND Sales_Org_Code__c='1210'];
                
                for( Territory_Distributor__c td :territoryList){
                  territoryMap.put(td.Name,td);
              }
            }
        }
        prechatobject.listOfTerritory=territoryMap.values();
        po.add(prechatobject);
        return po ;
    }
}