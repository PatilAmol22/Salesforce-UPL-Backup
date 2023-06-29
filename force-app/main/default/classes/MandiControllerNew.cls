public without sharing class MandiControllerNew {
    list<MandiWrapper> mandiListResult;
    list<MandiWrapper> mandiListOriginal;
    public Id recordId;
    public integer totalRecs{get;set;}       
    public integer index{get;set;}  
    public integer blockSize{get;set;}
    public integer pageNo{get;set;}
    private integer pageSize = 5;
    private String districtName;
    
    /* This is a constructor */
    public MandiControllerNew(ApexPages.StandardController sc){
        recordId = ApexPages.CurrentPage().getparameters().get('id');
        String AccId = sc.getId();
        Account acc = getAccountDetails(AccId);
        districtName = acc.District__pc != null ? acc.District__pc : acc.District__c;
        index = 0; 
        blockSize = 5;
        pageNo = 1;
        totalRecs=1;
    }
    
    /*
     Name: getAccountDetails
	 Param : accountId
	 Description : this method collect account id as a param and return account related information
	*/
    @AuraEnabled
    public static Account getAccountDetails(Id accountId){
        List<Account> accList = [ SELECT Id, StateName__c, District__pc, District__c FROM account WHERE Id = : accountId];
        return accList != null && accList.size()> 0 ? accList[0] : new Account(); 
    }
   
    
    /*
    Name : beginning
    Description : This method process data for 1st page
    */
    public void beginning() {  
        index = 0;  
        blockSize = pageSize;
    }  
   
    /*
    Name : previous
    Description : This method process data for previous page
    */
    public void previous() { 
        pageNo--;
        index = (pageNo-1) * pageSize; 
        blockSize = pageNo *pageSize;
    }  
    
    /*
    Name : next
    Description : This method process data for next page
    */
    public void next() {    
        pageNo++;
        index = (pageNo-1) * pageSize; 
        blockSize = pageNo *pageSize;
        if(blockSize > totalrecs){
            blockSize = totalrecs;
        }
    }  
  
    /*
    Name : next
    Description : This method process data for Last page
    */
    public void end() { 
        pageNo = (Integer)math.ceil(totalRecs/pageSize)+1;
        Integer endIndex = math.mod(totalRecs,pageSize);
        index = totalrecs - (endIndex > 0 ? endIndex : pageSize); 
        blockSize = totalrecs;
    }          
    
    /*
    Name : getprev
    Description : This method return boolean value to hide/show previous button.
    */
    public boolean getprev() {  
        if(index == 0)  
            return true;  
        else  
            return false;  
  
    }    
    
    /*
    Name : getnxt
    Description : This method return boolean value to hide/show next button.
    */
    public boolean getnxt() {  
        if((index + 5) >= totalRecs)  
        return true;  
        else  
        return false;  
  
    }   

    @AuraEnabled
    public static List<LabelWithValue> getStates()
    {
       
        List<IdWithName> lstOfStates=new List<IdWithName>();
        List<LabelWithValue> lstOfStatesForUI=new List<LabelWithValue>();
        MandiDataAPI__mdt stateApiDetails=MandiDataAPI__mdt.getInstance('StateAPI');
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(stateApiDetails.EndPoint__c);
        request.setMethod('GET');
        request.setHeader('clientId', stateApiDetails.ClientId__c);
        request.setHeader('clientSecret', stateApiDetails.ClientSecret__c);
        HttpResponse response = http.send(request);
        
        if (response.getStatusCode() == 200) {
            lstOfStates = (List<IdWithName>)JSON.deserialize(response.getBody(), List<IdWithName>.class);
            for(IdWithName eachItem:lstOfStates)
            {
                LabelWithValue eachState=new LabelWithValue();
                eachState.label=eachItem.name;
                eachState.value=eachItem.id;
                lstOfStatesForUI.add(eachState);
            }
            return lstOfStatesForUI;
        }
        return null;
    }

    @AuraEnabled
    public static List<LabelWithValue> getDistricts(String stateId)
    {
        List<IdWithName> lstOfDistricts=new List<IdWithName>();
        List<LabelWithValue> lstOfDistrictsForUI=new List<LabelWithValue>();
        MandiDataAPI__mdt districtApiDetails=MandiDataAPI__mdt.getInstance('DistrictAPI');
        String endPoint=districtApiDetails.EndPoint__c+stateId+'/districts';
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endPoint);
        request.setMethod('GET');
        request.setHeader('clientId', districtApiDetails.ClientId__c);
        request.setHeader('clientSecret', districtApiDetails.ClientSecret__c);
        HttpResponse response = http.send(request);
        if (response.getStatusCode() == 200) {
            lstOfDistricts = (List<IdWithName>)JSON.deserialize(response.getBody(), List<IdWithName>.class);
            for(IdWithName eachItem:lstOfDistricts)
            {
                LabelWithValue eachDistrict=new LabelWithValue();
                eachDistrict.label=eachItem.name;
                eachDistrict.value=eachItem.name;
                lstOfDistrictsForUI.add(eachDistrict);
            }
            return lstOfDistrictsForUI;
        }
        return null;
    }

    @AuraEnabled
    public static List<LabelWithValue> getCrops()
    {
        List<IdWithName> lstOfCrops=new List<IdWithName>();
        List<LabelWithValue> lstOfCropsForUI=new List<LabelWithValue>();
        MandiDataAPI__mdt cropsApiDetails=MandiDataAPI__mdt.getInstance('CropsAPI');
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(cropsApiDetails.EndPoint__c);
        request.setMethod('GET');
        request.setHeader('clientId', cropsApiDetails.ClientId__c);
        request.setHeader('clientSecret', cropsApiDetails.ClientSecret__c);
        HttpResponse response = http.send(request);
        if (response.getStatusCode() == 200) {
            lstOfCrops = (List<IdWithName>)JSON.deserialize(response.getBody(), List<IdWithName>.class);
            for(IdWithName eachItem:lstOfCrops)
            {
                LabelWithValue eachCrop=new LabelWithValue();
                eachCrop.label=eachItem.name;
                eachCrop.value=eachItem.name;
                lstOfCropsForUI.add(eachCrop);
            }
            return lstOfCropsForUI;
        }
        return null;
    }

    @AuraEnabled
    public static List<MandiWrapper> getMandiPriceDetails(String state)
    {
        List<MandiWrapper> lstOfMandiValues=new List<MandiWrapper>();
        MandiDataAPI__mdt mandiApiDetails=MandiDataAPI__mdt.getInstance('MandiAPI');
        //RITM0465177-Added by Nandhini to introduce Limit Param to the Endpoint
        String endPoint=mandiApiDetails.EndPoint__c+state+'&limit='+mandiApiDetails.Limit__c;
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endPoint);
        request.setMethod('GET');
        request.setHeader('clientId', mandiApiDetails.ClientId__c);
        request.setHeader('clientSecret', mandiApiDetails.ClientSecret__c);
        HttpResponse response = http.send(request);
        if (response.getStatusCode() == 200) {
            lstOfMandiValues = (List<MandiWrapper>)JSON.deserialize(response.getBody(), List<MandiWrapper>.class);
            return lstOfMandiValues;
        }
        return null;
    }
    
    /*
    Class Name : MandiWrapper
    Description : This is a wrapper class, this class use as a list to process the MndiPrice data.
    */
    public class MandiWrapper{
        @AuraEnabled
        public Integer Id;
        @AuraEnabled
        public String product{get;set;}
        @AuraEnabled
        public String variety{get;set;}
        @AuraEnabled
        public String market{get;set;}
        // @AuraEnabled
        //public String arrival_date{get;set;}
        @AuraEnabled
        public String district{get;set;}
        @AuraEnabled
        public String state{get;set;}
        @AuraEnabled
        public String modalPrice{get;set;}
        @AuraEnabled
        public String maxPrice{get;set;}
        @AuraEnabled
        public String minPrice{get;set;}
    }

    public class IdWithName{
        
        @AuraEnabled
        public String id{get;set;}
        @AuraEnabled
        public String name{get;set;}
    }

    public class LabelWithValue{
        
        @AuraEnabled
        public String label{get;set;}
        @AuraEnabled
        public String value{get;set;}
    }
}