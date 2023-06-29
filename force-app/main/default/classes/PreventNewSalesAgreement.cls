public class PreventNewSalesAgreement {

    @AuraEnabled
    public static boolean isNotCreatable(){
     User usr = [select Id,Name,ProfileId,Profile.Name from User where id=:UserInfo.getUserId()];
        
        String CountryName = System.Label.Target_Planning_Sales_Agreement_Countries_Name;
        
        List<String> Countries = CountryName.split(',');
        
        for(string obj : Countries){
           if(usr.Profile.Name.contains(obj)){
                return false;
            }
         }
        
        // if(usr.Profile.Name=='System Administrator' || (usr.Profile.Name!=null && usr.Profile.Name.contains('Australia') || (usr.Profile.Name!=null && usr.Profile.Name.contains('Indonesia')))){
        // return false;
          
        return true;
    }
}