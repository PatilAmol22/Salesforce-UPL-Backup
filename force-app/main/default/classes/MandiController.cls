/*
Name : MandiController
Description : This class get response from mandiprice API and process the data.
Author : Kuhinoor
*/
public class MandiController {
    list<MandiWrapper> mandiListResult;
    list<MandiWrapper> mandiListOriginal;
    public Id recordId;
    public integer totalRecs{get;set;}       
    public integer index{get;set;}  
    public integer blockSize{get;set;}  
    public String searchStr{get;set;}
    public integer pageNo{get;set;}
    private integer pageSize = 5;
    private String districtName;
    
    /* This is a constructor */
    public MandiController(ApexPages.StandardController sc){
        recordId = ApexPages.CurrentPage().getparameters().get('id');
        String AccId = sc.getId();
        Account acc = getAccountDetails(AccId);
        districtName = acc.District__pc != null ? acc.District__pc : acc.District__c;
        init();
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
     Name: fetchMandiPrice
	 Description : this method call getMandiPrice method and retun the data to aura comp.
	*/
    @AuraEnabled
    public static List<MandiWrapper> fetchMandiPrice(){
        return getMandiPrice();
    }
    
    /*
     Name: getMandiPrice
	 Description : This mentod call Mandi API, collect the response and retun data as a list.
	*/
    public static List<MandiWrapper> getMandiPrice(){
        List<MandiWrapper> mandiDetails = new List<MandiWrapper>();
        MandiPrice__c mpObj = MandiPrice__c.getOrgDefaults();
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        String endPointStr; 
        if(mpObj != null && String.isNotBlank(mpObj.EndPoint__c) && String.isNotBlank(mpObj.ApiKey__c)){   
            endPointStr = mpObj.EndPoint__c+'?api-key='+mpObj.ApiKey__c+'&format=json&offset=0&limit='+mpObj.Limit__c.intValue();
            request.setEndpoint(endPointStr);
            request.setMethod('GET');
        }
        HttpResponse response = http.send(request);
        if (response.getStatusCode() == 200) {
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            String myMapObjects = JSON.serialize((List<Object>)results.get('records')) ;
            //system.debug('body-->>'+myMapObjects);
            mandiDetails = (List<MandiWrapper>)JSON.deserialize(myMapObjects, List<MandiWrapper>.class);
            return mandiDetails;
        }
        return null;
    }
    
    /*
     Name: init
	 Description : This mentod initialize variable and list with initial value.
	*/
    public void init(){
        index = 0; 
        blockSize = 5;
        pageNo = 1;
        mandiListResult = new List<MandiWrapper>(); 
        List<MandiWrapper> tempResult = getMandiPrice(); 
        mandiListOriginal = sortByLoction(tempResult, districtName);
        mandiListResult = mandiListOriginal;
        totalRecs= mandiListResult.size();
    }
    
    /*
     Name: getMandiPriceData
	 Description : This is method process mandiprice data as a list to display in VF page.
	*/
    public list<MandiWrapper> getMandiPriceData(){
        list<MandiWrapper> mandiList = new list<MandiWrapper>();
        if(mandiListResult.size() > 0){
            if(mandiListResult.size() < blockSize){
                blockSize = mandiListResult.size();
            }
            for(Integer i=index; i<blockSize; i++){
                mandiList.add(mandiListResult[i]);
            }
        }
        return mandiList;
    }
    
    /*
    Name : search
    Description : This method use to search the crop 
    */
    public void search(){
        index = 0;  
        blockSize = pageSize;
        mandiListResult = new List<MandiWrapper>();
        for(MandiWrapper md :  mandiListOriginal){
            if(md.commodity.containsIgnoreCase(searchStr)){
                mandiListResult.add(md);
            }
        }
        totalRecs= mandiListResult.size();
        if(totalRecs < pageSize){
            blockSize = totalRecs;
        }
        //system.debug('mandiListResult-->'+mandiListResult); 
    }
    
    /*
    Name : sortByLoction
    Description : This method use to sort the list by district name
    */
    public list<MandiWrapper> sortByLoction(list<MandiWrapper> mandiList, String districtStr){
        list<MandiWrapper> mandiListSorted = new list<MandiWrapper>();
        list<MandiWrapper> tempList1 = new list<MandiWrapper>();
        for(MandiWrapper md : mandiList){
            if(md.district == districtStr){
                mandiListSorted.add(md);
            }else{
                tempList1.add(md);
            }
        }
        mandiListSorted.addAll(tempList1);
        return mandiListSorted;
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
    
    /*
    Class Name : MandiWrapper
    Description : This is a wrapper class, this class use as a list to process the MndiPrice data.
    */
    public class MandiWrapper{
        @AuraEnabled
        public Integer Id;
        @AuraEnabled
        public String commodity{get;set;}
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
        public String modal_price{get;set;}
        @AuraEnabled
        public String max_price{get;set;}
        @AuraEnabled
        public String min_price{get;set;}
    }
}