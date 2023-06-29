Global class BatchToAssignPermissionSet implements Database.Batchable<SObject>{
	
    String PROFILE_NAMES=System.Label.Profiles_to_add_pre_sales_permission_set;
    String PERMISSIONSET=System.Label.Pre_Sales_Permission_Set;
    Boolean ENABLEMARKETINGUSER= Boolean.valueOf(System.Label.EnableMarkettingUser);
    List<String> profiles=new List<String>();
    
    Global Database.QueryLocator start(Database.BatchableContext bc){
        profiles.addAll(PROFILE_NAMES.split(';'));
        system.debug('profiles-->'+profiles);
        String query = 'SELECT Email,Profile.Name,isActive,userPermissionsMarketingUser FROM User where Profile.Name IN: profiles and isActive=True';
        return Database.getQueryLocator(query);
    }
    Global void execute(Database.BatchableContext bc, List<User> userList){
        system.debug('userList->'+userList.size());
        List<User> userListToUpdate=new List<User>();
        PermissionSet permissionst= [SELECT Id, Name FROM PermissionSet WHERE Name =:PERMISSIONSET];
        List<PermissionSetAssignment> permissionSetList = new List<PermissionSetAssignment>();
        for (User u : userList){ 
            PermissionSetAssignment psa = new PermissionSetAssignment (PermissionSetId = permissionst.Id, AssigneeId = u.Id);
            permissionSetList.add(psa);
            system.debug('ENABLEMARKETINGUSER-->'+ENABLEMARKETINGUSER);
            if(!u.UserPermissionsMarketingUser && ENABLEMARKETINGUSER){
                u.userPermissionsMarketingUser=true;
                userListToUpdate.add(u);
            }
        }
        system.debug('permissionSetList-->'+permissionSetList.size());
        system.debug('userListToUpdate-->'+userListToUpdate.size());
        Database.insert(permissionSetList,false);
        ByPassUtils.ByPass('Grz_UserTriggerForSms');
        Database.update(userListToUpdate,false);
        ByPassUtils.UndoByPass('Grz_UserTriggerForSms');
        
    }
    Global void finish(Database.BatchableContext bc){
        
    }
}