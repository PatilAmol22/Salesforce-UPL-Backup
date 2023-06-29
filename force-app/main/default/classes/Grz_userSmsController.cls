public with sharing class Grz_userSmsController {
    
    public static Map<ID, Profile> proMap= new Map<ID, Profile>(); 
    @AuraEnabled(cacheable=true)
    public static void getRecord(List<User> userList, Map<Id,User> userListOld){
        List<Id> profileIdsList=new List<Id>();
        for(User u:userList){
            profileIdsList.add(u.profileId);
        }
        List<Id> oldProfileIds=new List<Id>();
        if(userListOld!=null){
            for(User u:userListOld.values()){
                oldProfileIds.add(u.profileId);
            }
        }
        proMap = new Map<ID, Profile>([Select Name,UserLicenseId,UserLicense.Name from Profile where Id IN :profileIdsList or Id IN :oldProfileIds]);
    }
    
    public static void sendWelcomeMessage(List<User> userList,Boolean isInsert,Map<Id,User> userListOld) {
        if(isInsert==true){
            methodSendSms(userList,null);
        }
        else if(isInsert==false){
            List<User> changedUserIds=new List<User>();
            for(User u: userList){
                if((u.ProfileId!= userListOld.get(u.Id).ProfileId)||TEST.isRunningTest()){
                    changedUserIds.add(u);
                }
            }
            methodSendSms(changedUserIds,userListOld);
        }
    }
    
    public static void methodSendSms(List<User> userList,Map<Id,User> userListOld){
        system.debug('send sms starting');
        String baseURL='';
        List<Network> myCommunity = [SELECT Id FROM Network WHERE Name = 'UPL Partner Portal'];
        if(!myCommunity.isEmpty()){
            baseURL=String.valueOf(Network.getLoginUrl(myCommunity[0].id));
        }
        
        for(User u:userList){
            if((userListOld==null || proMap.get(userListOld.get(u.Id).profileId).Name=='PartnerCommunity Distributor Profile') && ((proMap.get(u.ProfileId).Name=='India Partner Community Distributor Profile' && proMap.get(u.ProfileId).UserLicense.Name=='Customer Community Plus') || (proMap.get(u.ProfileId).Name=='India Partner Community Distributor Profile New' && proMap.get(u.ProfileId).UserLicense.Name=='Partner Community'))){
                List<SMS_Template__c> smsTemp=[SELECT Id, Name, Name__c, ObjectName__c, Text__c FROM SMS_Template__c where Name='Community_Welcome_Email' and ObjectName__c='User'];
                
                if(!smsTemp.isEmpty()){
                    String encodedcontent = EncodingUtil.urlEncode(smsTemp[0].Text__c.replace('<BASEURL><URL>', baseURL), 'UTF-8');
                    if(u.MobilePhone!='' && u.MobilePhone!=null){
                        String phoneVal = u.MobilePhone.replaceAll('\\D','');
                        String senderId = 'UPL';
                        system.debug('send sms inside1');
                        IntegrationWithKarix.sendSMS(encodedcontent,phoneVal,u.Id,senderId);
                        system.debug('send sms inside2');
                    }  
                }
            }
        }
    }
    
    public static void addUserInGroup(List<User> userList,Map<Id,User> userListOld){
        List<GroupMember> groupList =new List<GroupMember>();
        Set<Id> userIdSet= new Set<Id>(); 
        Set<Id> grpUserId= new Set<Id>(); 
        for(User u:userList){
            if((userListOld==null || proMap.get(userListOld.get(u.Id).profileId).Name=='PartnerCommunity Distributor Profile') && ((proMap.get(u.ProfileId).Name=='India Partner Community Distributor Profile' && proMap.get(u.ProfileId).UserLicense.Name=='Customer Community Plus') || (proMap.get(u.ProfileId).Name=='India Partner Community Distributor Profile New' && proMap.get(u.ProfileId).UserLicense.Name=='Partner Community'))){
                userIdSet.Add(u.id);
            }
        } 
        if(userIdSet.size()>0){
            String grpname= System.Label.Grz_GroupName;
            List<Group> grpList=[select id, name from group where name=:grpname];
            list<GroupMember>  gmList=[SELECT Id, GroupId,UserOrGroupId ,group.name FROM GroupMember where group.name=:grpname];
            if(!grpList.isEmpty()){
                for(GroupMember gm:gmList) {
                    grpUserId.add(gm.UserOrGroupId);
                }
                for(Id usrId : userIdSet){
                    if(!grpUserId.contains(usrId)){
                        GroupMember gm1= new GroupMember();
                        gm1.UserOrGroupId=usrId;
                        gm1.GroupId=grpList[0].Id;
                        groupList.add(gm1);
                    }
                }
            }
            if(groupList.size()>0){
                insert groupList;
            } 
        }
    }
    
    public static void addUserInGroupForBrazil(List<User> userList, Map<Id,User> userListOld) {
        System.debug('UserList: ' + userList + ' userListOld: ' + userListOld);
        List<GroupMember> groupList =new List<GroupMember>();
        Set<Id> userIdSet= new Set<Id>(); 
        Set<Id> grpUserId= new Set<Id>();
        for(User u:userList) {
            if((userListOld==null || proMap.get(userListOld.get(u.Id).profileId).Name=='PartnerCommunity Distributor Profile') && ((proMap.get(u.ProfileId).Name.contains('Brazil Partner Community Distributor Profile') && proMap.get(u.ProfileId).UserLicense.Name=='Customer Community Plus') || (proMap.get(u.ProfileId).Name.contains('Brazil Partner Community Distributor') && proMap.get(u.ProfileId).UserLicense.Name=='Partner Community'))){ // modified logic condition GRZ(Nikhil Verma) : APPS-1394 
                userIdSet.Add(u.id);
            }
        } 
        if(userIdSet.size()>0){
            String grpname= System.Label.Grz_GroupNameBrazil;
            List<Group> grpList=[select id, DeveloperName  from group where name=:grpname];
            list<GroupMember>  gmList=[SELECT Id, GroupId,UserOrGroupId ,group.name FROM GroupMember where group.name=:grpname];
            if(!grpList.isEmpty()){
                for(GroupMember gm:gmList) {
                    grpUserId.add(gm.UserOrGroupId);
                }
                for(Id usrId : userIdSet){
                    if(!grpUserId.contains(usrId)){
                        GroupMember gm1= new GroupMember();
                        gm1.UserOrGroupId=usrId;
                        gm1.GroupId=grpList[0].Id;
                        groupList.add(gm1);
                    }
                }
            }
            if(groupList.size()>0){
                insert groupList;
            } 
        }
    }
    
    public static void addUserInGroupForMexico(List<User> userList, Map<Id,User> userListOld) {
        System.debug('Inside the method');
        System.debug('UserList: ' + userList + ' userListOld: ' + userListOld);
        List<GroupMember> groupList =new List<GroupMember>();
        Set<Id> userIdSet= new Set<Id>(); 
        Set<Id> grpUserId= new Set<Id>();
        for(User u:userList) {
            if((userListOld==null) && (proMap.get(u.ProfileId).Name.contains('Mexico')))
            {    
                System.debug('Inside if');
                userIdSet.Add(u.id);
            }
        } 
        if(userIdSet.size()>0){
            String grpname= System.Label.Grz_GroupNameMexico;
            System.debug('grpname----'+grpname);
            List<Group> grpList=[select id, name from group where name=:grpname];
            System.debug('grpList---'+grpList);
            list<GroupMember>  gmList=[SELECT Id, GroupId,UserOrGroupId ,group.name FROM GroupMember where group.name=:grpname];
            System.debug('gmList---'+gmList);
            if(!grpList.isEmpty()){
                for(GroupMember gm:gmList) {
                    grpUserId.add(gm.UserOrGroupId);
                    System.debug('grpUserId---'+grpUserId);
                }
                for(Id usrId : userIdSet){
                    if(!grpUserId.contains(usrId)){
                        GroupMember gm1= new GroupMember();
                        gm1.UserOrGroupId=usrId;
                        gm1.GroupId=grpList[0].Id;
                        groupList.add(gm1);
                    }
                }
            }
            if(groupList.size()>0){
                insert groupList;
            } 
        }
    }
    
    
    
    /****************************************************************************
    
    * @Description  - This method will add new user in public group for argentina
    * Date - 16/08/2022
    * Author - Mohit garg(Grazitti)
    * Last modified by - Mohit Garg(Grazitti) 17/08/2022 
    *************************************************************************** */

    
    public static void addUserInGroupForArgentina(List<User> userList, Map<Id,User> userListOld) {
        List<GroupMember> groupList =new List<GroupMember>();
        Set<Id> userIdSet= new Set<Id>(); 
        Set<Id> grpUserId= new Set<Id>();
        for(User u:userList) {
            if((userListOld==null) && (proMap.get(u.ProfileId).Name.contains('Argentina Partner Community Distributor') || proMap.get(u.ProfileId).Name.contains('Territory Manager Argentina') || proMap.get(u.ProfileId).Name.contains('Regional/Zonal Managers Argentina') || proMap.get(u.ProfileId).Name.contains('Admin for Argentina')))
            {    
                userIdSet.Add(u.id);
            }
            
            if(userIdSet.size()>0){
                String grpname= System.Label.Grz_GroupNameArg;
                List<Group> grpList=[select id, name from group where name=:grpname];
                list<GroupMember>  gmList=[SELECT Id, GroupId,UserOrGroupId ,group.name FROM GroupMember where group.name=:grpname];
                if(!grpList.isEmpty()){
                    for(GroupMember gm:gmList) {
                        grpUserId.add(gm.UserOrGroupId);
                    }
                    for(Id usrId : userIdSet){
                        if(!grpUserId.contains(usrId)){
                            GroupMember gm1= new GroupMember();
                            gm1.UserOrGroupId=usrId;
                            gm1.GroupId=grpList[0].Id;
                            groupList.add(gm1);
                        }
                    }
                }
                if(groupList.size()>0){
                    insert groupList;
                } 
            }
        }
    }
    
     
    public static void addTMEmailANDPhone(List<User> userList,Map<Id,User> userListOld){
        set<Id> userId= new set<Id>();
        system.debug('User userListNew : '+userList);
        system.debug('User userListOld : '+userListOld);
        Map<String,ID> userTerrMap = new Map<String,ID>();
        List<String> userTerr = new List<String>();
        for(User u:userList){  
            system.debug('u.Territory__c : '+u.Territory__c);
            if((proMap.get(u.ProfileId).UserLicense.Name=='Customer Community Plus' && proMap.get(u.ProfileId).Name=='India Partner Community Distributor Profile')||(proMap.get(u.ProfileId).UserLicense.Name=='Partner Community' && proMap.get(u.ProfileId).Name=='India Partner Community Distributor Profile New')){
                //userId.add(u.id);
                if(userListOld == null || userListOld.get(u.id).Territory__c !=u.Territory__c){
                    system.debug('User Territory in if');
                    if(u.Territory__c != null){
                        userTerr.add(u.Territory__c.toUpperCase());
                    }
                    else{
                        u.Territory_Manager_Name__c = '';
                        u.Territory_Manager_Email__c = '';
                        u.Territory_Manager_Phone__c = '';
                    }
                }
                
            }
        }
        List<String> salesorgcode = System.Label.Grz_IndiaSalesOrgCode.trim().Split(',');
        system.debug('salesorgcode : '+salesorgcode);        
        system.debug('User Territory List : '+userTerr);
        if(userTerr.size()>0){
            List<Territory_Distributor__c> userTerrList  = [SELECT Id, Name, TerritoryManager__c FROM Territory_Distributor__c where Name in : userTerr and Sales_Org_Code__c in : salesorgcode];
            for(Territory_Distributor__c td :userTerrList){
                userTerrMap.put(td.Name.toUpperCase(),td.TerritoryManager__c);
            }
            system.debug('userTerrMap : '+userTerrMap);
            Map<ID,User> tmUserMap = new Map<ID,User>([Select Id,name,Email,MobilePhone from user where id in : userTerrMap.values()]);
            system.debug('tmUserMap : '+tmUserMap);
            if(userTerrMap.size()>0){
                for(User u:userList){
                    if(userTerrMap.containsKey(u.Territory__c.toUpperCase())){
                        User tmuserId = new user(id = userTerrMap.get(u.Territory__c.toUpperCase()));
                        User tmUser = tmUserMap.get(tmuserId.Id);
                        system.debug('tmuser : '+tmuser.Email);
                        u.Territory_Manager_Name__c = tmuser.name;
                        u.Territory_Manager_Email__c = tmuser.Email;
                        u.Territory_Manager_Phone__c = tmuser.MobilePhone;
                    }
                    else{
                        u.Territory_Manager_Name__c = '';
                        u.Territory_Manager_Email__c = '';
                        u.Territory_Manager_Phone__c = '';
                    }
                }
            }
            else{
                for(User u:userList){
                    u.Territory_Manager_Name__c = '';
                    u.Territory_Manager_Email__c = '';
                    u.Territory_Manager_Phone__c = '';
                }
            }
            system.debug('userList : '+userList);
        }
        
    }
    
    public static void updateUserTMMobileANdPhone(List<User> userList,Map<Id,User> userListOld){
        system.debug('User userListNew : '+userList);
        system.debug('User userListOld : '+userListOld);
        Set<Id> tmUserIdset = new Set<Id>();
        Map<Id,User> userTerrMap = new Map<Id,User>();
        List<User> userTMInfo = new List<User>();
        for(User u:userList){  
            system.debug('User : '+u);
            //if(proMap.get(u.ProfileId).Name == 'Territory Manager'){
            if(userListOld.get(u.id).FirstName!= u.FirstName || userListOld.get(u.id).MiddleName != u.MiddleName || userListOld.get(u.id).LastName != u.LastName || userListOld.get(u.id).Email != u.Email || userListOld.get(u.id).MobilePhone != u.MobilePhone){
                system.debug('User Territory in if');
                //if(u.Email != null && u.MobilePhone != null){
                tmUserIdset.add(u.Id);
                userTerrMap.put(u.Id,u);
                //}
            }
            //}
        }
        List<String> salesorgcode = System.Label.Grz_IndiaSalesOrgCode.trim().Split(',');
        system.debug('salesorgcode : '+salesorgcode);
        system.debug('tmUserIdset : '+tmUserIdset);
        system.debug('userTerrMap : '+userTerrMap);
        if(tmUserIdset.size()>0){
            Map<String,ID> getTMID = new  Map<String,ID>();
            List<Territory_Distributor__c> userTerrList  = [SELECT Id, Name, TerritoryManager__c FROM Territory_Distributor__c where TerritoryManager__c in : tmUserIdset and Sales_Org_Code__c in : salesorgcode];
            system.debug('userTerrList : '+userTerrList.size());
            List<String> terrList = new List<String>();
            for(Territory_Distributor__c td : userTerrList){
                if(td.Name != null){
                    String territoryName=td.name.toUpperCase();
                    terrList.add(territoryName);
                    getTMID.put(territoryName,td.TerritoryManager__c);
                }                
            }
            System.debug('List of terr => '+ terrList);
            List<User> TMUser = new List<User>();
            for(User u:[Select Id,name,Email,MobilePhone,Territory__c from user where Territory__c in : terrList]){
                u.Territory__c=u.Territory__c.toUpperCase();
                TMUser.add(u);
            }
            
            List<User> usertoUpdate  = new List<User>();
            System.debug('List of Tm => '+ TMUser.size());
            for(User us : TMUser){
                user tmuser1 = new user(id = getTMID.get(us.Territory__c));
                String nameVal='';
                if(!userTerrMap.isEmpty() && userTerrMap.containsKey(tmuser1.Id)){
                    nameVal=userTerrMap.get(tmuser1.Id).LastName;
                    if(null!=userTerrMap.get(tmuser1.Id).MiddleName){
                        nameVal=userTerrMap.get(tmuser1.Id).MiddleName+' '+nameVal;
                    }
                    if(null!=userTerrMap.get(tmuser1.Id).FirstName){
                        nameVal=userTerrMap.get(tmuser1.Id).FirstName+' '+nameVal;
                    }
                    
                    
                    us.Territory_Manager_Name__c = nameVal;
                    if(null!=userTerrMap.get(tmuser1.Id).Email){
                        us.Territory_Manager_Email__c = userTerrMap.get(tmuser1.Id).Email;
                    }
                    if(null!=userTerrMap.get(tmuser1.Id).MobilePhone){
                        us.Territory_Manager_Phone__c = userTerrMap.get(tmuser1.Id).MobilePhone;
                    }
                    
                    usertoUpdate.add(us);
                }
            }
            System.debug('List of usertoUpdate=> '+ usertoUpdate.size());
            if(usertoUpdate.size()>0){
                update usertoUpdate;
            }
        }
    } 
    
    //for brazil when user'manager change then need to update user Region
    @future
    public static void updateBRUserRegionAndTerritory(String usrStr,String usrmapstr){
        List<User> userList= (List<User>) JSON.deserialize(usrStr, List<User>.class);
        Map<Id,User> userListOld=(Map<Id,User>) JSON.deserialize(usrmapstr,Map<Id,User>.class);    
        Set<Id> tmUserIdset = new Set<Id>();
        Map<Id,User> userTerrMap = new Map<Id,User>();
        List<User> userTMInfo = new List<User>();
        Schema.DescribeSObjectResult drSObj = Schema.sObjectType.Region__c;
        Boolean thisUserMayUpdate = drSObj.isUpdateable();
        for(User u:userList){  
            system.debug('User : '+u);
            if(u.LocaleSidKey=='pt_BR' && thisUserMayUpdate){
                system.debug('User pt_BR in if');
                tmUserIdset.add(u.Id);
                userTerrMap.put(u.Id,u);
            }
        }
        if(userTerrMap.values().size()>0){
            List<Region__c> regiontoUpdate = new List<Region__c>();
            String salesorgcode = System.Label.Grz_BrazilSalesOrgCode.trim();
            if(tmUserIdset.size()>0){
                Map<String,ID> getTMID = new  Map<String,ID>();
                List<Region__c> userRegionrList  = [SELECT Id, Name, Sales_Org_Code__c, BrazilAnalyst__c, Brazil_Analyst_Manager_lukup__c FROM Region__c where BrazilAnalyst__c in : tmUserIdset and Sales_Org_Code__c =: salesorgcode];
                system.debug('userRegionrList : '+userRegionrList);
                for(Region__c r : userRegionrList){
                    user userid = new user(id = r.BrazilAnalyst__c);
                    if(userTerrMap.get(userid.Id).ManagerId != null){
                        r.Brazil_Analyst_Manager_lukup__c = userTerrMap.get(userid.Id).ManagerId; 
                        regiontoUpdate.add(r);
                    }
                }
            }
            System.debug('regiontoUpdate for BR: '+regiontoUpdate);
            if(regiontoUpdate.size()>0){
                update regiontoUpdate;
            }
            
        }
        
    }
}