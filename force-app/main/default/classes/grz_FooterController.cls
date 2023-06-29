public with sharing class grz_FooterController {
    @AuraEnabled(cacheable=true)
    public static SurveyWrapper getSurveyData(String language) {
        System.debug('language-------'+language);
        SurveyWrapper surv = new SurveyWrapper();
        if(language == 'pt-BR'){
            string UserId = UserInfo.getUserId().substring(0,15);
            string LoggedInUserProfile;
            user  u = [select Contact.accountId,IsPortalEnabled, profile.Name from user where id = :UserId][0];
            LoggedInUserProfile = u.profile.Name;
            
            if(LoggedInUserProfile.contains('Brazil Partner Community Distributor')){
                surv.isBrExternal = true;
            }else{
                surv.isBrExternal = false;
            }
            surv.btnEnable = false;
            Id recordTypeShowId = Schema.SObjectType.Partner_Portal_Configuration__c.RecordTypeInfosByName.get('CommunicationSurvey').RecordTypeId;
            for(Partner_Portal_Configuration__c eachRecord : [Select Id,Name,Label__c,URL__c,Enable_Survey__c from Partner_Portal_Configuration__c where Language__c =:language and recordtypeId =: recordTypeShowId LIMIT 1]){
                surv.btnEnable = eachRecord.Enable_Survey__c;
                surv.surveyURL = eachRecord.URL__c;
            }
        }else if(language == 'en-US'){
            string UserId = UserInfo.getUserId().substring(0,15);
            string LoggedInUserProfile;
            user  u = [select Contact.accountId,IsPortalEnabled, profile.Name from user where id = :UserId][0];
            LoggedInUserProfile = u.profile.Name;
			String IndiaProfilename= System.Label.Grz_IndiaCommunityProfile;
             if(LoggedInUserProfile.contains(IndiaProfilename)){
                surv.isInExternal = true;
            }else{
                surv.isInExternal = false;
            }
            surv.btnEnableIn = false;
            Id recordTypeShowId = Schema.SObjectType.Partner_Portal_Configuration__c.RecordTypeInfosByName.get('CommunicationSurvey').RecordTypeId;
            for(Partner_Portal_Configuration__c eachRecord : [Select Id,LastModifiedDate,Name,Label__c,URL__c,Enable_Survey__c,Highlight_Survey__c from Partner_Portal_Configuration__c where Language__c =:language and recordtypeId =: recordTypeShowId LIMIT 1]){
                surv.btnEnableIn = eachRecord.Enable_Survey__c;
                surv.surveyURLIn = eachRecord.URL__c;
                surv.highligthSurveyIn = eachRecord.Highlight_Survey__c;
                surv.LastModifiedDateIn = eachRecord.LastModifiedDate;
            }
        }

        else if(language == 'es-MX'){
           
            string UserId = UserInfo.getUserId().substring(0,15);
            string LoggedInUserProfile;
            user  u = [select Contact.accountId,IsPortalEnabled, profile.Name from user where id = :UserId][0];
            LoggedInUserProfile = u.profile.Name;
            
            if(LoggedInUserProfile.contains('Mexico Partner Community Distributor')){
                surv.isMxExternal = true;
            }else{
                surv.isMxExternal = false;
            }
              System.debug('isMxExternal-------'+surv.isMxExternal);
            surv.btnEnableMx = false;
            Id recordTypeShowId = Schema.SObjectType.Partner_Portal_Configuration__c.RecordTypeInfosByName.get('CommunicationSurvey').RecordTypeId;
            for(Partner_Portal_Configuration__c eachRecord : [Select Id,Name,Label__c,URL__c,Enable_Survey__c from Partner_Portal_Configuration__c where Language__c =:language and recordtypeId =: recordTypeShowId LIMIT 1]){
                surv.btnEnableMx = eachRecord.Enable_Survey__c;
                surv.surveyURLMx = eachRecord.URL__c;
                 System.debug('surv.btnEnableMx-------'+surv.btnEnableMx);
                  System.debug(' surv.surveyURLMx-------'+ surv.surveyURLMx);
            }
        }


        else if(language == 'es'){
            string UserId = UserInfo.getUserId().substring(0,15);
            string LoggedInUserProfile;
            user  u = [select Contact.accountId,IsPortalEnabled, profile.Name from user where id = :UserId][0];
            LoggedInUserProfile = u.profile.Name;
            
            if(LoggedInUserProfile.contains('Chile Partner Community Distributor')){
                surv.isClExternal = true;
            }else{
                surv.isClExternal = false;
            }
            surv.btnEnableCl = false;
            Id recordTypeShowId = Schema.SObjectType.Partner_Portal_Configuration__c.RecordTypeInfosByName.get('CommunicationSurvey').RecordTypeId;
            for(Partner_Portal_Configuration__c eachRecord : [Select Id,Name,Label__c,URL__c,Enable_Survey__c from Partner_Portal_Configuration__c where Language__c =:language and recordtypeId =: recordTypeShowId LIMIT 1]){
                surv.btnEnableCl = eachRecord.Enable_Survey__c;
                surv.surveyURL = eachRecord.URL__c;
            }
        }
        else{
            return null;
        }
        return surv;
    }
    @AuraEnabled(cacheable=true)
    public static List<MenuItemWrapper> getUPLFooterList(String language) {
        List<MenuItemWrapper> navlist=new List<MenuItemWrapper>(); 
         
        Id recordTypeShowId = Schema.SObjectType.Partner_Portal_Configuration__c.RecordTypeInfosByName.get('UPL Footer').RecordTypeId;
        for(Partner_Portal_Configuration__c eachRecord:[Select Id,Name,Label__c,Order__c,URL__c,(select id,name,Label__c,URL__c,Order__c from Partner_Portal_Configurations__r order by Order__c) from Partner_Portal_Configuration__c where Language__c =:language and ParentMenu__r.Name = null and recordtypeId =: recordTypeShowId order by Order__c]){
            MenuItemWrapper Parent = new MenuItemWrapper();
            List<MenuItemWrapper> childlist   = new List<MenuItemWrapper>();
            if(eachRecord.URL__c == null){
                Parent.urlCss = 'noUrlCss';
            }else{
                Parent.urlCss = 'urlCss';
            }
            if(eachRecord.Partner_Portal_Configurations__r.isEmpty()){
                Parent.showArrow = false;
            }else{
                Parent.showArrow = true;
            }
            Parent.Id = eachRecord.Id;
            Parent.Name = eachRecord.Name;           
            Parent.Label = eachRecord.Label__c;
            Parent.URL = eachRecord.URL__c;
            Parent.Order = eachRecord.Order__c;
            Parent.Border= false;
            
            system.debug('Parent.Order'+Parent.Order);
            

            
            
                system.debug('true>>>');
                 for(Partner_Portal_Configuration__c  child : eachRecord.Partner_Portal_Configurations__r){
                MenuItemWrapper childitem = new MenuItemWrapper();
                     
                if(child.URL__c == null){
                    childitem.urlCss = 'noUrlCss';
                }else{
                    childitem.urlCss = 'urlCss';
                }
                    
                childitem.Id = child.id;
                childitem.Name = child.Name;
                childitem.Label = child.Label__c;
                childitem.URL = child.URL__c;                
                childitem.Order =  child.Order__c; 
                if(childitem.Order==6 && Parent.Order==5 && language=='es-MX')
                {
                   childitem.Border = true; 
                   
                }
                      System.debug('childitem.Border>>>'+childitem.Border);
                childlist.add(childitem);
            }
            
           
            
            Parent.children = childlist;
            navlist.add(Parent); 
        }
         return navlist;
     }
    public class MenuItemWrapper {
        @AuraEnabled
        public String Id {get;set;}
        @AuraEnabled
        public String Name {get;set;}
        @AuraEnabled
        public String Label {get;set;}
        @AuraEnabled
        public String urlCss {get;set;}
        @AuraEnabled
        public Boolean showArrow {get;set;}
        @AuraEnabled
        public String URL {get;set;}
        @AuraEnabled
        public Decimal Order {get;set;}
        @AuraEnabled
        public List<MenuItemWrapper> children {get;set;}
        @AuraEnabled
        public Boolean Border {get;set;}
        
        
    }
    public class SurveyWrapper {
        @AuraEnabled public Boolean isBrExternal {get;set;}
        @AuraEnabled public Boolean isClExternal {get;set;}
        @AuraEnabled public Boolean btnEnable {get;set;}
        @AuraEnabled public Boolean btnEnableCl {get;set;}
        @AuraEnabled public String surveyURL {get;set;}
          @AuraEnabled public Boolean btnEnableMx {get;set;}
          @AuraEnabled public Boolean btnEnableAr {get;set;}
        @AuraEnabled public String surveyURLMx {get;set;}
        @AuraEnabled public String surveyURLAr {get;set;}
        @AuraEnabled public Boolean isMxExternal {get;set;}
        @AuraEnabled public Boolean isArExternal {get;set;}
         @AuraEnabled public Boolean isInExternal {get;set;}
         @AuraEnabled public Boolean btnEnableIn {get;set;}
         @AuraEnabled public Boolean highligthSurveyIn {get;set;}
         @AuraEnabled public String surveyURLIn {get;set;}
         @AuraEnabled public Datetime LastModifiedDateIn {get;set;}
        
    }

}