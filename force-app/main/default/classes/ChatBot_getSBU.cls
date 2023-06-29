public class ChatBot_getSBU {
    public class PrechatOutput{
    	@InvocableVariable
        public List<Territory_Distributor__c> listOfSBU = new list<Territory_Distributor__c>();
    	//@InvocableVariable
    	//public boolean isError = false;
    	 
    }
    public class PrechatInput{ 
     
        @InvocableVariable
        public String sUserRole;
        @InvocableVariable
        public String sUserId;
        @InvocableVariable
        public String sCountryName;
        
    }
    
    @InvocableMethod(label='Get SBUs')
    public static List<PrechatOutput> getSBUData(List<PrechatInput> inputParameters){
        String userRole=inputParameters[0].sUserRole;
        String userId=inputParameters[0].sUserId;
        String CountryName=inputParameters[0].sCountryName;
        System.debug('User role '+userRole+' User id '+userId+' CountryName '+CountryName);
        List<PrechatOutput> po=new List<PrechatOutput>();
        PrechatOutput prechatobject=new PrechatOutput();
        List<Territory_Distributor__c> sbuList=new List<Territory_Distributor__c>();
        Map<String,Territory_Distributor__c> sbuMap=new Map<String,Territory_Distributor__c>();
        
        if(CountryName.containsIgnoreCase('India') && userRole=='SBU'){
            sbuList=[SELECT Id, SBUHead__c,  Name, SBU__c, SBU__r.SBUCode__c , SBU__r.Name , SBU_Code__c, Zone__c, SBU_Head_Id__c FROM Territory_Distributor__c
                     where SBU_Head_Id__c =: userId
                     AND Present_in_KEDE__c = true
                     AND Neglected__c = false
                     AND Sales_Org_Code__c='1000'];
            
            for( Territory_Distributor__c td :sbuList){
                  sbuMap.put(td.SBU__r.Name,td);
              }
        }
        
        prechatobject.listOfSBU=sbuMap.values();
        po.add(prechatobject);
        return po ;
    }

}