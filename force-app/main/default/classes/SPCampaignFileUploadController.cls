/*
* Name: SPCampaignFileUploadController
* Created On: 1 Mar 2019
* Author: Azhar Shaikh
* Description: Select Country from drop down
*/
public class SPCampaignFileUploadController {
    public String profileCountry{get;set;}
    public boolean isAdmin{get;set;}
    
    public SPCampaignFileUploadController(ApexPages.StandardController controller) {
        Id profileId=userinfo.getProfileId();
        isAdmin =false;
        profileCountry=[SELECT Id, Country, ProfileId FROM User Where ProfileId=:profileId Limit 1].Country;
        //String profileCountry = [Select Id,Name from Profile where Id=:profileId].Name;
        System.debug('profileCountry :-'+profileCountry);
    }
    /*public SPCampaignFileUploadController() {
        Id profileId=userinfo.getProfileId();
        isAdmin =false;
        profileCountry=[SELECT Id, Country, ProfileId FROM User Where ProfileId=:profileId Limit 1].Country;
        //String profileCountry = [Select Id,Name from Profile where Id=:profileId].Name;
        System.debug('profileCountry :-'+profileCountry);
    }*/
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('None','None'));
        options.add(new SelectOption('Campaign Pricebook',System.Label.Campaign_Pricebook));
        return options;
    }
    
}