/*
* Name: AKCAccountFileUploadController
* Created On: 1 Mar 2019
* Author: Azhar Shaikh
* Description: Select Country from drop down
*/
public class AKCAccountFileUploadController {
    public String profileCountry{get;set;}
    public boolean isAdmin{get;set;}
    
    public AKCAccountFileUploadController() {
        Id profileId=userinfo.getProfileId();
        isAdmin =false;
        profileCountry=[SELECT Id, Country, ProfileId FROM User Where ProfileId=:profileId Limit 1].Country;
        //String profileCountry = [Select Id,Name from Profile where Id=:profileId].Name;
        System.debug('profileCountry :-'+profileCountry);
    }
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('None','None'));
        options.add(new SelectOption('PreRegistered_Farmer','PreRegistered Farmer'));
        options.add(new SelectOption('AKC_Retailer','AKC Retailer'));
        options.add(new SelectOption('SWAL_Retailer','SWAL Retailer'));
        options.add(new SelectOption('F3_C3_Sales_Team','F3/C3/Sales Team'));
        return options;
    }
    
}