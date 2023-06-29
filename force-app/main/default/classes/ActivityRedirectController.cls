public with sharing class ActivityRedirectController {

    public String accountId {get;set;}
    public String country {get;set;}
    public User currentUser{get;set;}

    public ActivityRedirectController(ApexPages.StandardController controller) {
        String recordId = ApexPages.currentPage().getParameters().get('id');
        currentUser = [select id, Country from user where id =: UserInfo.getUserId() ];
        if( String.isNotBlank(recordId)){
            accountId = recordId;
            country = currentUser.Country;
            
        }
    }
}