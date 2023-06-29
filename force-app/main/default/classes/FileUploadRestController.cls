/*
* Name: FileUploadRestController
* Created On: 1 Mar 2019
* Author: Azhar Shaikh
* Description: Select Country from drop down
*/
public class FileUploadRestController {
    public String profileCountry{get;set;}
    public boolean isAdmin{get;set;}
    public boolean isSKUVisible{get;set;}
    public String forCountry{get;set;}
    
    
    public FileUploadRestController() {
        Id profileId=userinfo.getProfileId();
        isAdmin =false;
        isSKUVisible = false;
        
        List<SKU_User__c> listSKUUserSettings=[SELECT Id, Name FROM SKU_User__c];
        Map<String,boolean> UsernameMap=new Map<String,boolean>(); 
        for(SKU_User__c userSettingsObj:listSKUUserSettings){
            UsernameMap.put(userSettingsObj.Name, true);
        }
        
        Id userId=UserInfo.getUserId();
        User userN=[Select Id, Name from User Where id=:userId];
        if(UsernameMap.get(userN.Name)==true){
            System.debug('userN.Name : '+userN.Name);
            isSKUVisible = true;
        }
        profileCountry=[SELECT Id, Country, ProfileId FROM User Where ProfileId=:profileId Limit 1].Country;
        //String profileCountry = [Select Id,Name from Profile where Id=:profileId].Name;
        System.debug('profileCountry :-'+profileCountry);
        //profileCountry='Country Name';
        if(profileCountry!=null){
            profileCountry=profileCountry.toUpperCase();
            System.debug('profileCountry1 :-'+profileCountry);
            if(!Test.isRunningTest()){
               //forCountry=[SELECT Id, Name, For_Contry__c FROM Login_Country__c where Name =:profileCountry limit 1].For_Contry__c;
                List<Login_Country__c> lcCountry=[SELECT Id, Name, For_Contry__c FROM Login_Country__c];
                for(Login_Country__c lcObj:lcCountry){
                    if(lcObj.Name==profileCountry){
                        forCountry=lcObj.For_Contry__c;
                    }
                }
            }
            System.debug('forCountry :-'+forCountry);
        }
        if(forCountry=='CAM'){
            System.debug('forCountry : '+forCountry);
            profileCountry='CAM';
            getCAMItems();
            isAdmin=true;
        }else{
            if(profileCountry=='Colombia'){
            profileCountry='Colombia';
            getColombiaItems();
            isAdmin=true;
        }
        if(profileCountry=='Mexico'){
            profileCountry='Mexico';
            //profileCountry='Mexico Customerwise';
            //getMexicoItems();
            isAdmin=true;
        }
        if(profileCountry=='Italy'){
            profileCountry='Italy';
            getItalyItems();
            isAdmin=true;
        }
        /* code by Tejas */
        
        
        // Spain, Portugal , Naturagri
        //if(profileCountry=='Iberia & Portugal'){
        if(profileCountry=='Spain' || profileCountry=='Portugal'){    
            System.debug('profileCountry : '+profileCountry);
            profileCountry='Iberia & Portugal';
            getSPNItems();
            isAdmin=true;
        }
    
    if(profileCountry=='Naturagri'){
            System.debug('profileCountry : '+profileCountry);
            profileCountry='Naturagri';
            getSPNItems();
            isAdmin=true;
        }
        if(profileCountry=='Poland'){
            System.debug('profileCountry : '+profileCountry);
            profileCountry='Poland';
            getPolandItems();
            isAdmin=true;
        }
            if(profileCountry=='Bolivia & Paraguay'){
                System.debug('profileCountry : '+profileCountry);
                profileCountry='Bolivia & Paraguay';
                getBolParItems();
                isAdmin=true;
            } 
        }
        
    }
    
    public List<SelectOption> getFileUploadItems() {
        List<SelectOption> options = new List<SelectOption>();
        /*options.add(new SelectOption('None','None'));
        options.add(new SelectOption('SKU File Upload','SKU File Upload'));
        options.add(new SelectOption('Pricebook File Upload','Pricebook File Upload'));*/
        options.add(new SelectOption('None',System.Label.None)); //SCTASK0322376 added the custom label.
        options.add(new SelectOption('SKU File Upload',System.Label.SKU_File_Upload));
        options.add(new SelectOption('Pricebook File Upload',System.Label.PriceBook));
        
        return options;
    }
    
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('None','None'));
        options.add(new SelectOption('Mexico','Mexico'));
        ///options.add(new SelectOption('Mexico Customerwise','Mexico Customerwise'));
        options.add(new SelectOption('Argentina','Argentina'));
        options.add(new SelectOption('CAM','CAM'));
        options.add(new SelectOption('Colombia','Colombia'));
        options.add(new SelectOption('Italy','Italy'));
        options.add(new SelectOption('Iberia & Portugal','Iberia & Portugal'));
    	options.add(new SelectOption('Naturagri','Naturagri'));
        options.add(new SelectOption('Poland','Poland'));
        options.add(new SelectOption('Bolivia & Paraguay','Bolivia & Paraguay'));
        return options;
    }
    public List<SelectOption> getMexicoItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Mexico','Mexico'));
        options.add(new SelectOption('Mexico Customerwise','Mexico Customerwise'));
        return options;
    }
    
    public List<SelectOption> getColombiaItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('None',System.Label.None));
        options.add(new SelectOption('CustomerWise',System.Label.Customer_Wise));
        options.add(new SelectOption('CustomerGroup',System.Label.Customer_Group_Wise));
        return options;
    }
    public List<SelectOption> getItalyItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('None',System.Label.None));
        options.add(new SelectOption('Pricebook With Price Group Code',System.Label.Pricebook_With_Price_Group_Code));
        options.add(new SelectOption('Pricebook With Customer Code',System.Label.Pricebook_With_Customer_Code));
        options.add(new SelectOption('Common Pricebook',System.Label.Common_Pricebook));
        //options.add(new SelectOption('Customized Product Pricebook',System.Label.Customized_Product));
        return options;
    }
    /* code by Tejas */
    public List<SelectOption> getCAMItems(){
        List<SelectOption> options=new List<SelectOption>();
        options.add(new SelectOption('None',System.Label.None));
        options.add(new SelectOption('CustomerWise',System.Label.Customer_Wise));
        options.add(new SelectOption('CombinationWise','Combination Wise'));
        return options;
        //options.add(new SelectOption('CustomerGroup',System.Label.Customer_Group_Wise));
        //options.add(new SelectOption('Common Pricebook',System.Label.Common_Pricebook));
    }
    
    public List<SelectOption> getSPNItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('None',System.Label.None));
        options.add(new SelectOption('Common Pricebook',System.Label.Common_Pricebook));
        options.add(new SelectOption('Campaign Pricebook',System.Label.Campaign_Pricebook));
        return options;
    }
    public List<SelectOption> getPolandItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('None',System.Label.None));
        options.add(new SelectOption('Common Pricebook',System.Label.Common_Pricebook));
        options.add(new SelectOption('CustomerWise Pricebook',System.Label.Customer_Wise));
        return options;
    }
    public List<SelectOption> getBolParItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('None',System.Label.None));
        options.add(new SelectOption('Common Pricebook',System.Label.Common_Pricebook));
        return options;
    }
}