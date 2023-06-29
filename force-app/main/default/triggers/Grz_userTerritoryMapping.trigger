trigger Grz_userTerritoryMapping on Territory_Distributor__c (after update, after insert) 
{        
    if(Trigger.isAfter && Trigger.isUpdate)
    {    
        Map<String,string> TerrManagerVsName = new Map<String,string>(); 
        List<String> IndiaSalesOrgCode = new List<String>();
        IndiaSalesOrgCode = System.Label.Grz_IndiaSalesOrgCode.split(',');
        System.debug('IndiaSalesOrgCode'+IndiaSalesOrgCode);
        //Added by Varun Shrivastava : 4 Aug 2021 : 
        Boolean flag=false;
        //Added by Varun Shrivastava : 4 Aug 2021 : 
        
        for(Territory_Distributor__c territory : Trigger.new)
        {
            //Added by Varun Shrivastava : 4 Aug 2021 : 
            IF(IndiaSalesOrgCode.contains(territory.Sales_Org_Code__c)){
                flag=true;   
            }
            //Added by Varun Shrivastava : 4 Aug 2021 : 
        
            Territory_Distributor__c TM1 =Trigger.oldMap.get(Territory.id);
            if(Territory.TerritoryManager__c != TM1.TerritoryManager__c ) 
            {      
                
                if(IndiaSalesOrgCode.contains(Territory.Sales_Org_Code__c)){
                    TerrManagerVsName.put(Territory.Name.toUpperCase(),Territory.TerritoryManager__c);
                }
                
            }                   
        }
        if(flag){
            
        
        map<string,user> UserDetailMap = new map<string,user>();
        List<User> territoryManagerUser = [Select id,name,Email,MobilePhone,Territory__c from user where id in : TerrManagerVsName.values()];
        
        for(user u :  territoryManagerUser){
            UserDetailMap.put(u.id,u);
        }
        
        Map<String,String> UserProfile = new Map<String,String>();
        //List<User> territoryUser = [select id,name,Email,profileid,MobilePhone,Territory_Manager_Phone__c,Territory_Manager_Email__c,Territory__C from user where Territory__C in :TerrManagerVsName.keyset()];
        List<User> territoryUser=new List<User>();
        for(User uu:[select id,name,Email,profileid,MobilePhone,Territory_Manager_Phone__c,Territory_Manager_Email__c,Territory__c from user where Territory__C in :TerrManagerVsName.keyset()]){
        uu.Territory__c=uu.Territory__c.toUpperCase();
        territoryUser.add(uu);
        }
        list<user> updatedUsers = new List<user>();
        String IndiaCommunityProfile = System.Label.Grz_IndiaCommunityProfile;
        string tempInput = '%' + IndiaCommunityProfile + '%';
        List<Profile> profileList = [select id from profile where name like :tempInput];
        List<Id> profileIdList=new List<Id>();
        for(Profile p:profileList){
        profileIdList.add(p.Id);
        }
        if(profileList.size()>0)
        {
            For(User u:territoryUser)
            {
                if(profileIdList.contains(u.profileid))
                {
                    if(!TerrManagerVsName.isEmpty() && TerrManagerVsName.containsKey(u.Territory__c) && !UserDetailMap.isEmpty() && UserDetailMap.containsKey(TerrManagerVsName.get(u.Territory__c))){
                        user u1 = new user();
                        u1.id = u.id;
                        u1.Territory_Manager_Name__c = UserDetailMap.get(TerrManagerVsName.get(u.Territory__c)).Name;
                        u1.Territory_Manager_Email__c = UserDetailMap.get(TerrManagerVsName.get(u.Territory__c)).Email;
                        u1.Territory_Manager_Phone__c = UserDetailMap.get(TerrManagerVsName.get(u.Territory__c)).MobilePhone;
                        updatedUsers.add(u1);
                    }
                }
            }           
        }
        if(!updatedUsers.isEmpty())
        {
            update updatedUsers;
        }
        } 

        //Send Emai when TM is assigned to AF/SWAL Territory (Liquidation Revamp)
        TerritoryTriggerHandler.sendMailOnTmAssignment(Trigger.new, Trigger.oldMap);
        
        List<Territory_Distributor__c> territory = new List<Territory_Distributor__c>();
        for(Territory_Distributor__c terr:Trigger.new){
            if(terr.Present_in_KEDE__c == True && terr.Present_in_KEDE__c != Trigger.oldMap.get(terr.Id).Present_in_KEDE__c && (terr.Sales_Org_Code__c == System.Label.AF_Sales_Org_Code_Label || terr.Sales_Org_Code__c == System.Label.New_AF_Sales_Org_Code_Label || terr.Sales_Org_Code__c == System.Label.SWAL_Sales_Org_Code_Label)){
                territory.add(terr);
            }
        }
        if(territory.size()>0){
            TerritoryTriggerHandler.createLAPOpenInventory(territory);
        }
    }   

    if(Trigger.isAfter && Trigger.isInsert){
        TerritoryTriggerHandler.sendMailOnTmAssignmentOnInsert(Trigger.new);
        List<Territory_Distributor__c> territory = new List<Territory_Distributor__c>();
        for(Territory_Distributor__c terr:Trigger.new){
            if(terr.Present_in_KEDE__c == True && (terr.Sales_Org_Code__c == System.Label.AF_Sales_Org_Code_Label || terr.Sales_Org_Code__c == System.Label.New_AF_Sales_Org_Code_Label || terr.Sales_Org_Code__c == System.Label.SWAL_Sales_Org_Code_Label)){
                territory.add(terr);
            }
        }
        if(territory.size()>0){
        	TerritoryTriggerHandler.createLAPOpenInventory(territory);
        }
         
    }
}