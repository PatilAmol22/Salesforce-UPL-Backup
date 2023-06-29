public class AustraliaAutocomplete_Controller {

    public AustraliaAutocomplete_Controller(){
        
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
    public static List<sObject> getSuggestions(String sObjectType, String fields,String WhereClause) {
        String soql;
        soql = ' SELECT Name, Id, ' + 					
              fields +
            ' FROM '  + String.escapeSingleQuotes(sObjectType) +
            ' WHERE ' + WhereClause;
        	
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