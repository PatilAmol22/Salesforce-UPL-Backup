public class ChatBot_getZone {
    public class PrechatOutput{
    	@InvocableVariable
        public List<Territory_Distributor__c> listOfZone = new list<Territory_Distributor__c>();
    	@InvocableVariable
    	public boolean isError = false;
    	 
    }
    public class PrechatInput{ 
     
        @InvocableVariable
        public String sUserRole;
        @InvocableVariable
        public String sUserId;
        @InvocableVariable
        public String sCountryName;
        
    }
    @InvocableMethod(label='Get Zones')
    public static List<PrechatOutput> getZoneData(List<PrechatInput> inputParameters){
        String userRole=inputParameters[0].sUserRole;
        String userId=inputParameters[0].sUserId;
        String CountryName=inputParameters[0].sCountryName;
        System.debug('User role '+userRole+' User id '+userId+' CountryName '+CountryName);
        List<PrechatOutput> po=new List<PrechatOutput>();
        PrechatOutput prechatobject=new PrechatOutput();
        List<Territory_Distributor__c> zoneList=new List<Territory_Distributor__c>();
        Map<String,Territory_Distributor__c> zoneMap=new Map<String,Territory_Distributor__c>();
        
        if(CountryName.containsIgnoreCase('India') && userRole=='SBU'){
            zoneList=[SELECT Id, SBUHead__c,  Name, SBU__c, Zone__c, Zone__r.Name, Zone__r.ZoneCode__c, Zone_Code__c,SBU_Head_Id__c FROM Territory_Distributor__c
                     where SBU_Head_Id__c =: userId
                     AND Present_in_KEDE__c = true
                     AND Neglected__c = false
                     AND Sales_Org_Code__c='1000'];
            
            for( Territory_Distributor__c td :zoneList){
                  zoneMap.put(td.Zone__r.Name,td);
              }
        }
        
        if(CountryName.containsIgnoreCase('India') && userRole=='ZM'){
            zoneList=[SELECT Id, SBUHead__c,  Name, SBU__c, Zone__c,Zone_Code__c, Zone__r.Name, Zone__r.ZoneCode__c ,SBU_Head_Id__c FROM Territory_Distributor__c
                     where Zonal_Manager_Id__c=: userId
                     AND Present_in_KEDE__c = true
                     AND Neglected__c = false
                     AND Sales_Org_Code__c='1000'];
            
            for( Territory_Distributor__c td :zoneList){
                  zoneMap.put(td.Zone__r.Name,td);
              }
        }
        if(CountryName.containsIgnoreCase('Swal') && userRole=='ZM'){
            zoneList=[SELECT Id, SBUHead__c,  Name, SBU__c, Zone__c,Zone_Code__c, Zone__r.Name, Zone__r.ZoneCode__c , SBU_Head_Id__c FROM Territory_Distributor__c
                     where Zonal_Manager_Id__c =: userId
                     AND Present_in_KEDE__c = true
                     AND Neglected__c = false
                     AND Sales_Org_Code__c='1210'];
            
            for( Territory_Distributor__c td :zoneList){
                  zoneMap.put(td.Zone__r.Name,td);
              }
        }
        prechatobject.listOfZone=zoneMap.values();
        po.add(prechatobject);
        return po ;
    }

}