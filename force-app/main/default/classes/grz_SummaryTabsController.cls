public with sharing class grz_SummaryTabsController {

    @AuraEnabled(cacheable=true)
    public static FinalSummaryTabsWrapper getSummaryTabsList(String language) {

        FinalSummaryTabsWrapper obj = new FinalSummaryTabsWrapper();
        List<MenuItemWrapper> summaryTabList = new List<MenuItemWrapper>(); 
        Id recordTypeShowId = Schema.SObjectType.Partner_Portal_Configuration__c.RecordTypeInfosByName.get('Summary Tabs').RecordTypeId;
            
        for(Partner_Portal_Configuration__c eachRecord:[Select Id,Name,Label__c,Order__c,URL__c from  Partner_Portal_Configuration__c where Language__c =:language and recordtypeId =: recordTypeShowId order by Order__c]){
            MenuItemWrapper summaryTab = new MenuItemWrapper();
            summaryTab.Id = eachRecord.Id;
            summaryTab.Name = eachRecord.Name;           
            summaryTab.Label = eachRecord.Label__c;
            summaryTab.Order = eachRecord.Order__c;
            summaryTab.URL = eachRecord.URL__c;
            summaryTabList.add(summaryTab); 
        }
        obj.CustomLabel = System.Label.Grz_ViewAll;
        obj.summaryTabsList = summaryTabList;
        System.debug('SummaryTabsList----'+obj);

        return obj;
    }
    @AuraEnabled(cacheable=true)
    public static List<noticeWrapper> getNotice(String language) {
        string UserId = UserInfo.getUserId().substring(0,15);
        string LoggedInUserProfile;
        if(language=='en-US'){
            user  u = [select Contact.accountId,IsPortalEnabled, profile.Name from user where id = :UserId][0];
       		LoggedInUserProfile = u.profile.Name;
        } 
		String IndiaProfilename= System.Label.Grz_IndiaCommunityProfile;
        List<noticeWrapper> obj = new List<noticeWrapper>();
        if((language=='en-US' && LoggedInUserProfile.contains(IndiaProfilename)) || language=='pt-BR'){
             Id recordTypeShowId = Schema.SObjectType.Partner_Portal_Configuration__c.RecordTypeInfosByName.get('Notification').RecordTypeId; 
        for(Partner_Portal_Configuration__c eachRecord:[Select Id,Name,Label__c,Order__c,URL__c,Description__c,CreatedDate from  Partner_Portal_Configuration__c where Language__c =:language and recordtypeId =: recordTypeShowId order by CreatedDate LIMIT 5]){
            noticeWrapper notice = new noticeWrapper();
            notice.Id = eachRecord.Id;
            notice.URL = eachRecord.URL__c; 
            notice.Description = eachRecord.Description__c;
            if(language=='en-US')
                notice.CreatedDate = grz_SapIntegration.FormattedDate(eachRecord.CreatedDate);
            else
            notice.CreatedDate = grz_SapIntegration.FormattedDateBrazil(eachRecord.CreatedDate);
            obj.add(notice); 
        }
       
        }
        return obj;
    }
    public class noticeWrapper {
        @AuraEnabled public String Id {get;set;}
        @AuraEnabled public String URL {get;set;}
        @AuraEnabled public String Description {get;set;}
        @AuraEnabled public String CreatedDate {get;set;}
    }
    public class MenuItemWrapper {
        @AuraEnabled
        public String Id {get;set;}
        @AuraEnabled
        public String Name {get;set;}
        @AuraEnabled
        public String Label {get;set;}
        @AuraEnabled
        public String URL {get;set;}
        @AuraEnabled
        public Decimal Order {get;set;}

    }
    public class FinalSummaryTabsWrapper {
        @AuraEnabled
        public String CustomLabel {get;set;}
        @AuraEnabled
        public List<MenuItemWrapper> summaryTabsList {get;set;}
	}
}