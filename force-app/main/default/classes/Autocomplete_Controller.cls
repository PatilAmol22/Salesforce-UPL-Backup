public class Autocomplete_Controller {

    public Autocomplete_Controller(){
        
    }


    @AuraEnabled
    public static returnStateData getStateData(){
        returnStateData rSD = new returnStateData();

        string userId = userinfo.getUserId();
        try {
            User LoginUser = [SELECT Id,Name ,Country,Profile.Name FROM User Where Id=:userId];
    
            if(LoginUser.Profile.Name == 'System Administrator' ||LoginUser.Profile.Name == 'Finese System Admin' ){
                
                rSD.isAdmin = true;
            }else{
                rSD.isAdmin = false;
            }
        } catch (Exception e) {
            rSD.isAdmin = false;
        }

        return rSD;
    }


    @AuraEnabled
    public static List<sObject> getSuggestions(String sObjectType, String fields,String WhereClause) {//, String term, Integer limitSize
        String soql;
        // could add in logic to remove possible duplicate fields // String fieldsToGet,
        //String fields = fieldsToGet.length() > 0 ? ',' + fieldsToGet : ''; 
       /* System.debug('sObjectType --> '+sObjectType);
        System.debug('term --> '+term);
        System.debug('limitSize --> '+limitSize);
        System.debug('fields --> '+fields);
        System.debug('WhereClause -->'+WhereClause);
		*/
        //if(sObjectType=='Stock_Requirement__c'){
    	 soql = ' SELECT Name, Id, ' + 							//String.escapeSingleQuotes(fields) +
              fields +
            ' FROM '  + String.escapeSingleQuotes(sObjectType) +
            ' WHERE ' + WhereClause;
        	/*+ 
            ' AND '+ fields + ' Like \'' + '%' + String.escapeSingleQuotes(term) + '%\'' +
            ' LIMIT ' + limitSize; 
            */
            /*soql = 
            ' SELECT Name, Id, ' + 							//String.escapeSingleQuotes(fields) +
              product_description +
            ' FROM '   + String.escapeSingleQuotes(sObjectType) +
            ' WHERE '+product_description+ ' Like \'' + String.escapeSingleQuotes(term) + '%\'' +
            ' LIMIT ' + limitSize + ' AND (Depot__r.SalesOrg__r.Sales_Org_Code__c = \'7110\' OR Depot__r.SalesOrg__r.Sales_Org_Code__c = \'6100\') order by SKU__r.SKU_Description__c'; */
        //System.debug('soql---> '+soql);
    //}
        System.debug('soql inside AutoComplete--> '+soql);
        return Database.query(soql);
    }

    public class returnStateData{
        @AuraEnabled
        public string userId;
        @AuraEnabled
        public boolean isAdmin;
    }

}