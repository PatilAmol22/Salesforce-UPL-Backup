public with sharing class Grz_CarousalController {
  
    @AuraEnabled(cacheable=true)
    public static FinalDataWrapper getCarouselData(String language){
        FinalDataWrapper finalObj1 =  new FinalDataWrapper();
        finalObj1.showTerms = false;
        Id id = UserInfo.getUserId(); // getting current user info
        List<User> user = [SELECT Id,ContactId, profile.name, Contact.Terms_Accepted__c FROM User where Id =: id];
        if(!user.isEmpty() && user[0].Profile.Name.contains('Brazil Partner')){
            if(user[0].ContactId != null && !user[0].Contact.Terms_Accepted__c){
                finalObj1.showTerms = true;
                finalObj1.contactId = user[0].ContactId;
            }
        }
        List<Partner_Portal_Configuration__c> uplTileViewList1 = new List<Partner_Portal_Configuration__c>();        
        uplTileViewList1 = [SELECT Id, Name, Label__c, Background_Image__c, Description__c, URL__c, Language__c, Order__c  FROM Partner_Portal_Configuration__c where Language__c =:language and recordtype.name = 'Carousel Image' order by Order__c];
        List<ResultWrapper> wrapperList1 = new List<ResultWrapper>();
        Pattern myPattern = Pattern.compile('src=\"(.*?)\"');
        for(Partner_Portal_Configuration__c item :uplTileViewList1){
            String gethtmlpath = '';
            System.Matcher MyMatcher = myPattern.Matcher(item.Background_Image__c); 
            while(MyMatcher.find()) {
               gethtmlpath = MyMatcher.group(1);
            }
            String updatedUrl = gethtmlpath.replace('&amp;','&');
            ResultWrapper resultwrap = new ResultWrapper();
            resultwrap.Id = item.Id;
            resultwrap.Name = item.Name;
            resultwrap.Label = item.Label__c;
            resultwrap.Description = item.Description__c;
            resultwrap.Image_Icon = updatedUrl;
            wrapperList1.add(resultwrap);
        }
        finalObj1.wrapList = wrapperList1;
        return finalObj1;
    }

    @AuraEnabled
    public static void updateTerms(Id contactId){
        Contact con = new Contact();
        con.Id = contactId;
        con.Terms_Accepted__c = true;
        update con;
    }
    public class ResultWrapper{
       @AuraEnabled
        public String Id{get;set;}
        @AuraEnabled
        public String Name{get;set;}
        @AuraEnabled
        public String Label{get;set;}
        @AuraEnabled
        public String Description{get;set;}
        @AuraEnabled
        public String Image_Icon{get;set;} 
    }
    
    public class FinalDataWrapper {
        @AuraEnabled
        public List<ResultWrapper> wrapList {get;set;}
        @AuraEnabled
        public Boolean showTerms {get;set;}
        @AuraEnabled
        public Id contactId {get;set;}
    } 
}