public class MultiSelectLookupController {
@AuraEnabled
    public static List <sObject> fetchLookUpValues(String searchKeyWord, String ObjectName, List<sObject> ExcludeitemsList,string queryFields,string filter) { 
        String searchKey = '%' + searchKeyWord + '%';
        string code ;
         if(ObjectName=='Brand__c'){
            Code = 'Brand_Code__c';
        }
        if(ObjectName=='Company__c'){
            Code = 'Company_Code__c';
        }
        if(ObjectName=='Formulation__c'){
            Code = 'Formulation_Code__c';
        }
        if(searchKeyWord.isNumeric()){
            
        }else{
            
        }
        List < sObject > returnList = new List < sObject > ();
        List<string> lstExcludeitems = new List<string>();
        for(sObject item : ExcludeitemsList ){
            lstExcludeitems.add(item.id);
        }
        // Create a Dynamic SOQL Query For Fetch Record List with LIMIT 5 and exclude already selected records  
        String sQuery = '';  
        if(searchKeyWord.isNumeric()){
        	sQuery =  'select Id, Name,'+queryFields+' from ' +ObjectName + ' where '+Code+' LIKE: searchKey AND Id NOT IN : lstExcludeitems '+filter;    
        }else{
        	sQuery =  'select Id, Name,'+queryFields+' from ' +ObjectName + ' where Name LIKE: searchKey AND Id NOT IN : lstExcludeitems '+filter;
        }
        List < sObject > lstOfRecords = Database.query(sQuery);
        
        for (sObject obj: lstOfRecords) {
            returnList.add(obj);
        }
        system.debug('returnList>>--->'+returnList);
        return returnList;
    }

}