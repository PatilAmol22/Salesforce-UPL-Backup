public without sharing class SideBarController {
    @AuraEnabled(cacheable=true)
    public static List<wrapperList> getSideBarData(){
        System.debug('yesss');
        List<wrapperList> FinalWrap = new List<wrapperList>();
        String profileId = UserInfo.getProfileId();
        String profileName;
        profileName = [Select Name from Profile where Id =: profileId].Name;
        System.debug(profileName);
        String profileBasedTabs = [SELECT Id, Name, Tabs__c FROM profileBasedTab__c where Name =: profileName].Tabs__c;
        System.debug('profileBasedTabs ==>'+profileBasedTabs );
        List<String> tabs = profileBasedTabs.split(';');
        Boolean isChild;
        Boolean IsLoggedIn = SideBar_User.getUserType();
        String query;
        if(IsLoggedIn == true){
            query = 'SELECT Id, Name, Url__c, Order__c, AccessType__c,CategoryId__c,Image__c, Category_Name__c, Description__c, Type__c, Standard_Url__c, (SELECT Id, Name, Child_Url__c, AccessType__c, Order__c, SideBar_Parent__c, CategoryId__c, Description__c, Group_Name__c, Category_Name__c, Label__c, Type__c FROM SideBar_Childs__r) FROM SideBar_Parent__c order by Order__c';
        }else{
            query = 'SELECT Id, Name, Url__c, Order__c, AccessType__c,CategoryId__c,Image__c, Category_Name__c, Description__c, Type__c, Standard_Url__c, (SELECT Id, Name, Child_Url__c, AccessType__c, Order__c, SideBar_Parent__c, CategoryId__c, Description__c, Group_Name__c, Category_Name__c, Label__c, Type__c FROM SideBar_Childs__r) FROM SideBar_Parent__c where AccessType__c = \'Public\' order by Order__c';
        }
        system.debug('Query---->'+query);
        for(SideBar_Parent__c allItems : Database.query(query)){
            System.debug('allItems ==>'+allItems );
            System.debug('allItems?>>>>>>>'+allItems);
            Boolean isRun = false;
            if(profileName == 'System Administratorsss' || profileName == 'GrazittiTestCommunity2 Profile'){
                isRun = true;
                
            } else if(profileBasedTabs.contains(allItems.Name)){
                isRun = true;
                System.debug('check');
            }
            
            if(isRun == true){
                wrapperList wrapList =  new wrapperList();
                wrapList.Label = allItems.Name;
                wrapList.url = allItems.Url__c;
                if(allItems.Standard_Url__c!=null || allItems.Standard_Url__c!=''){// Added By Akhilesh w.r.t Standard portal
                    wrapList.std_url = allItems.Standard_Url__c;
                }
                wrapList.image = allItems.image__c;
                wrapList.Order = (Integer) allItems.Order__c;
                wrapList.CategoryId = allItems.CategoryId__c;
                List<wrapperList> childWrapper = new List<wrapperList>();
                
                for(SideBar_Child__c allChildTabs : allItems.SideBar_Childs__r){
                    Boolean isRunning = false;
                    if(allChildTabs != null){
                        wrapList.isChild = true;
                        if(profileName == 'System Administratorsss' || profileName == 'Apttus Profile'){
                            System.debug('Childif');
                            isRunning = true;
                            
                        } else if(profileBasedTabs.contains(allItems.Name)){
                            isRunning = true;
                            System.debug('check');
                        }
                        if(isRunning == true){
                            System.debug('this'+allChildTabs.Name);
                            wrapperList childWrapList =  new wrapperList();
                            childWrapList.Label = allChildTabs.Name;
                            childWrapList.url = allChildTabs.Child_Url__c;
                            childWrapList.Order = (Integer) allChildTabs.Order__c;
                            childWrapper.add(childWrapList);
                        }
                        
                    }else{
                        wrapList.isChild = false;
                    }
                }
                System.debug('childWrapper'+childWrapper);
                childWrapper.sort();
                
                wrapList.childTabs = childWrapper;
                
                FinalWrap.add(wrapList);
            }
        }
        FinalWrap.sort();
        System.debug(FinalWrap);
        return FinalWrap;
    }
    public Class wrapperList implements comparable{
        @AuraEnabled
        public String Label {get;set;}
        
        @AuraEnabled
        public Integer isGroup {get;set;}
        @AuraEnabled
        public String url {get;set;}
        @AuraEnabled
        public String std_url {get;set;}//Added By Akhilesh
        @AuraEnabled
        public String image {get;set;}
        @AuraEnabled
        public Integer Order {get;set;}
        @AuraEnabled
        public boolean isChild {get;set;}
        @AuraEnabled
        public String CategoryId {get;set;}
        @AuraEnabled
        public List<wrapperList> childTabs {get;set;}
        
        public wrapperList(){}
        public Integer compareTo(Object compareToItem) {
            
            wrapperList wrap =  (wrapperList)compareToItem;
            Integer returnValue = 0;
            If (Order > wrap.Order) {
                return  1;
            } else if (Order < wrap.Order) {
                return  0;
            }
            return 0;
        }
    }
}