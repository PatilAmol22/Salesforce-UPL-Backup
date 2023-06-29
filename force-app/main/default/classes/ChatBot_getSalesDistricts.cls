public class ChatBot_getSalesDistricts {
    public class PrechatOutput{
    	@InvocableVariable
        public List<Sales_District__c> listOfSalesDistricts = new list<Sales_District__c>();
    	@InvocableVariable
    	public boolean isError = false;
    	 
    }
    public class PrechatInput{
        @InvocableVariable
        public String sUserName;
        @InvocableVariable
        public String sUserId;
        @InvocableVariable
        public String sCountryName;
        
    }
    
    @InvocableMethod(label='Get SAles Districts')
    public static List<PrechatOutput> getSalesDistrictData(List<PrechatInput> inputParameters){
        String userName=inputParameters[0].sUserName;
        String userId=inputParameters[0].sUserId;
        String CountryName=inputParameters[0].sCountryName;
        system.debug('countryName-->'+CountryName);
        System.debug('userId-->'+inputParameters[0].sUserId);
        System.debug('userId-->'+userId);
        List<PrechatOutput> po=new List<PrechatOutput>();
        PrechatOutput prechatobject=new PrechatOutput();
        List<Sales_District__c> salesDistrictList=new List<Sales_District__c>();
        Map<String,Sales_District__c> salesDistrictMap=new Map<String,Sales_District__c>();
        List<User> userIdsList=[Select id, profile.Name from User Where id=: userId limit 1];
        string q='Select id from User Where id=: userId limit 1';
        system.debug('ids'+userIdsList);
        
        if(CountryName.containsIgnoreCase('Indonesia')){
          
                salesDistrictList=[SELECT Id, Name, User__c, Sales_District_Code__c FROM Sales_District__c where User__c=: userId AND (SalesOrg__r.Sales_Org_Code__c='6410' or SalesOrg__r.Sales_Org_Code__c='6451')];
                system.debug('salesDistrictList'+salesDistrictList);
                for( Sales_District__c sd :salesDistrictList){
                  salesDistrictMap.put(sd.Name,sd);
                }
            if(salesDistrictList.size()==0){
                if(userIdsList[0].profile.Name =='National sales Manager indonesia/SEA' || userIdsList[0].profile.Name =='Sales Head Indonesia' || userIdsList[0].profile.Name =='National sales Manager indonesia'){
                     salesDistrictList=[SELECT Id, Name, User__c, Sales_District_Code__c FROM Sales_District__c Where SalesOrg__r.Sales_Org_Code__c='6410' or SalesOrg__r.Sales_Org_Code__c='6451'];
            	system.debug('salesDistrictList'+salesDistrictList);
                for( Sales_District__c sd :salesDistrictList){
                  salesDistrictMap.put(sd.Name,sd);
                }
                }
                
            }
               
            
        }
        
        if(CountryName.containsIgnoreCase('Australia')){
            if(userIdsList.size()>0){
                salesDistrictList=[SELECT Id, Name, User__c, Sales_District_Code__c FROM Sales_District__c where User__c=: userId AND SalesOrg__r.Sales_Org_Code__c='6100'];
                system.debug('salesDistrictList'+salesDistrictList);
                for( Sales_District__c sd :salesDistrictList){
                  salesDistrictMap.put(sd.Name,sd);
              }
            }else{
                salesDistrictList=[SELECT Id, Name, User__c, Sales_District_Code__c FROM Sales_District__c Where SalesOrg__r.Sales_Org_Code__c='6100'];
            	system.debug('salesDistrictList'+salesDistrictList);
                for( Sales_District__c sd :salesDistrictList){
                  salesDistrictMap.put(sd.Name,sd);
              }
            }
        }
        
        prechatobject.listOfSalesDistricts=salesDistrictMap.values();
        po.add(prechatobject);
        return po ;
    }

}