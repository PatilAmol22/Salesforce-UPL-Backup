public class ChatBot_getRegion {
    public class PrechatOutput{
    	@InvocableVariable
        public List<Territory_Distributor__c> listOfRegion = new list<Territory_Distributor__c>();
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
    
    @InvocableMethod(label='Get Regions')
    public static List<PrechatOutput> getRegionData(List<PrechatInput> inputParameters){
        String userRole=inputParameters[0].sUserRole;
        String userId=inputParameters[0].sUserId;
        String CountryName=inputParameters[0].sCountryName;
        System.debug('User role '+userRole+' User id '+userId+' CountryName '+CountryName);
        List<PrechatOutput> po=new List<PrechatOutput>();
        PrechatOutput prechatobject=new PrechatOutput();
        List<Territory_Distributor__c> regionList=new List<Territory_Distributor__c>();
        Map<String,Territory_Distributor__c> regionMap=new Map<String,Territory_Distributor__c>();
        
        if(CountryName.containsIgnoreCase('Swal') && userRole=='RM'){
            regionList=[SELECT Id, SBUHead__c,  Name, SBU__c, Zone__c, Region__c, Region__r.Name, Region__r.RegionCode__c,Region_Code__c, SBU_Head_Id__c FROM Territory_Distributor__c
                     where Regional_Manager_Id__c =: userId
                     AND Present_in_KEDE__c = true
                     AND Neglected__c = false
                     AND Sales_Org_Code__c='1210'];
            
            for( Territory_Distributor__c td :regionList){
                  regionMap.put(td.Region__r.Name,td);
              }
        }
        if(CountryName.containsIgnoreCase('Swal') && userRole=='ZM'){
            regionList=[SELECT Id, SBUHead__c,  Name, SBU__c, Zone__c, Region__c, Region__r.Name, Region__r.RegionCode__c, Region_Code__c,SBU_Head_Id__c FROM Territory_Distributor__c
                     where Zonal_Manager_Id__c =: userId
                     AND Present_in_KEDE__c = true
                     AND Neglected__c = false
                     AND Sales_Org_Code__c='1210'];
            
            for( Territory_Distributor__c td :regionList){
                  regionMap.put(td.Region__r.Name,td);
              }
        }
        prechatobject.listOfRegion=regionMap.values();
        po.add(prechatobject);
        return po ;
    }

}