public class SingleSelectLookupController {
    
      @AuraEnabled
    public static List < sObject > fetchLookUpValues(String SearchField ,String searchKeyWord,string queryFields ,String ObjectName , String filter) {
        system.debug('ObjectName-->' + ObjectName);
        string Code = '';
        if(ObjectName=='Brand__c'){
            Code = 'Brand_Code__c';
        }
        if(ObjectName=='Company__c'){
            Code = 'Company_Code__c';
        }
        if(ObjectName=='Formulation__c'){
            Code = 'Formulation_Code__c';
        }
        String searchKey = searchKeyWord + '%';
        
        List < sObject > returnList = new List < sObject > ();
      
        // Create a Dynamic SOQL Query For Fetch Record List with LIMIT 5   
        string sQuery = '';
       if(searchKeyWord.isNumeric()){
        	sQuery =  'select Id, Name,'+queryFields+' from ' +ObjectName + ' where '+Code+' LIKE: searchKey '+ filter;    
        }else{
        	sQuery =  'select Id, Name,'+queryFields+' from ' +ObjectName + ' where Name LIKE: searchKey '+ filter;
        }
        List < sObject > lstOfRecords = Database.query(sQuery);
        
        for (sObject obj: lstOfRecords) {
            returnList.add(obj);
        }
        return returnList;
    }


}