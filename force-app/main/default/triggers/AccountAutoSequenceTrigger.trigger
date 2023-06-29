trigger AccountAutoSequenceTrigger on Account (before insert, before update, after Insert,after Update) {
/*     List<AccountTeamMember> acctMembers = new List<AccountTeamMember>();
        List<AccountShare> acctSharingRules = new List<AccountShare>();
        Set<string> AccountownerIdSet = new Set<String>();
        Set<string> AccountIdSet = new Set<String>();
        Map<id,Account> AccountMap = new Map<Id,Account>();
        Map<id,Account> AccountInsertMap = new Map<Id,Account>();
        
        List<Account> accountList = new List<Account>(); 
        List<Contact> contactList = new List<Contact>(); 
        List<Contact> UpdatecontactList = new List<Contact>();
    
    
    
    
    List <Zone__c> ZoneList =[select id, name,ZoneCode__c from Zone__c];
    List<Territory_Distributor__c> TerritoryList = [select id, name,TerritoryCode__c from Territory_Distributor__c];
    /*Map<String, String> ZoneMap = new Map<String,String>();
    for(Zone__c z : ZoneList ){
    ZoneMap.put(z.ZoneCode__c,z.id);
    }
    Map<String, String> TerritoryMap = new Map<String,String>();
    
    for(Territory_Distributor__c t : TerritoryList ){
    TerritoryMap.put(t.TerritoryCode__c , t.id);
    }* /
    
    Id recordTypeIddis = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
    Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('PreRegistered Farmer').getRecordTypeId();
    System.debug('recordTypeIddis'+recordTypeIddis);
    
    if(Trigger.isBefore){
        /*
        if(Trigger.isInsert){
            Map<string,Auto_Number__c> mapCodes = Auto_Number__c.getAll();  
            Integer sequenceNo = Integer.valueOf(mapCodes.get('FarmerCode').Sequence__c);
                     for(Account accObj:Trigger.New){
                if(accObj.RecordTypeId==recordTypeId){
                    sequenceNo++;
                    accObj.Farmer_Code__pc = 'FM0'+String.valueOf(sequenceNo);
                }
                /*if(accObj.RecordTypeId == recordTypeIddis){
                if(accObj.Zone_Code__c != ''){
                if(ZoneMap.containsKey(accObj.Zone_Code__c))
                accObj.Zone_Distributor__c = ZoneMap.get(accObj.Zone_Code__c);
                }
                if(accObj.Territory_Code__c != ''){
                if(TerritoryMap.containsKey(accObj.Territory_Code__c))
                accObj.Territory_Distributor__c = TerritoryMap.get(accObj.Territory_Code__c);
                }
                }
                * /   
            }
              Auto_Number__c autObj = mapCodes.get('FarmerCode');
              autObj.Sequence__c = String.valueof(sequenceNo);
              update autObj ;
        }
       * / 
        if(Trigger.isUpdate){
                        //Logic to Map Depot with Distributor in Distributor-Depot Mapping Object
            
            Map<String, Id> depotMap = new Map<String, Id>();
            for(Depot__c depotObj:[SELECT Id, Depot_Code__c FROM Depot__c]){
                depotMap.put(depotObj.Depot_Code__c, depotObj.Id);
            }
            System.debug('depotMap: '+depotMap);
            
            Set<Id> distributorIdSet = new Set<Id>();
            for(Account accObj:Trigger.New){
                if(accObj.RecordTypeId == recordTypeIddis){
                    distributorIdSet.add(accObj.Id);
                }
            }
            /*List<Distributor_Depot_Mapping__c> ddmList = [Select id, Distributor__c, Depot__c 
                                                          FROM Distributor_Depot_Mapping__c 
                                                          WHERE Distributor__c IN:distributorIdSet];* /
            Map<Id, Distributor_Depot_Mapping__c> ddmMap = new Map<Id, Distributor_Depot_Mapping__c>();
            for(Distributor_Depot_Mapping__c ddmObj:[Select id, Distributor__c, Depot__c 
                                                          FROM Distributor_Depot_Mapping__c 
                                                          WHERE Distributor__c IN:distributorIdSet]){
                     ddmMap.put(ddmObj.Distributor__c, ddmObj);
                
            }
            System.debug('ddmMap: '+ddmMap);
            List<Distributor_Depot_Mapping__c> upsertddmList = new List<Distributor_Depot_Mapping__c>();
            for(Account accObj:Trigger.New){
                if(accObj.RecordTypeId == recordTypeIddis){
                    if(ddmMap.containsKey(accObj.id)){
                        Distributor_Depot_Mapping__c ddmObj = ddmMap.get(accObj.Id);
                        ddmObj.Depot__c = depotMap.get(accObj.Depot_Code__c);
                        ddmObj.Distributor__c = accObj.Id;
                        upsertddmList.add(ddmObj);
                    }
                    else{
                        Distributor_Depot_Mapping__c ddmObj = new Distributor_Depot_Mapping__c();
                        ddmObj.Depot__c = depotMap.get(accObj.Depot_Code__c);
                        ddmObj.Distributor__c = accObj.Id;
                        upsertddmList.add(ddmObj);
                    }
                }
            }
            
            System.debug('Before upsertddmList: '+upsertddmList);
            if(!upsertddmList.isEmpty()){
                upsert upsertddmList;
            }
            System.debug('After upsertddmList: '+upsertddmList);
            //End of Logic
        for(Account ac : trigger.new){
                AccountownerIdSet.add(ac.ownerId);
                AccountInsertMap.put(ac.id,ac); 
            }
            System.debug('AccountownerIdSet'+AccountownerIdSet);
           // List<User> UserList=[SELECT Id, RegionalManager__c, ZonalCommercialExecutive__c, ZonalHead__c FROM User where id  IN :AccountownerIdSet];
            Map<String, User> UserMap= new Map<String, User>([SELECT Id, RegionalManager__c, ZonalCommercialExecutive__c, ZonalHead__c FROM User where id IN:AccountownerIdSet]);   
           // System.debug('UserList before Update'+UserList);
            System.debug('UserMap'+UserMap);
            for(Account acc  : trigger.new){
                try{
                    if(acc.RecordTypeId==recordTypeIddis){
                     
                        system.debug('ZonalCommercialExecutive__c'+UserMap.get(acc.ownerId).ZonalCommercialExecutive__c);
                        acc.ZonalCommercialExecutive__c=UserMap.get(acc.ownerId).ZonalCommercialExecutive__c;
                        acc.ZonalHead__c = UserMap.get(acc.ownerId).ZonalHead__c;
                        acc.RegionalManager__c = UserMap.get(acc.ownerId).RegionalManager__c;
                        accountList.add(acc);
                        
                    }
                }
                catch(Exception ex){
                    system.debug('Exception'+ex.getMessage()+'LineNumber:'+ex.getLineNumber());
                }
            }
           

    }
    
    /*   if(Trigger.isUpdate && Trigger.isBefore){
        for(Account accObj:Trigger.New){
        if(accObj.RecordTypeId == recordTypeIddis){
        if(accObj.Zone_Code__c != ''){
        if(ZoneMap.containsKey(accObj.Zone_Code__c))
        accObj.Zone_Distributor__c = ZoneMap.get(accObj.Zone_Code__c);
        }
        if(accObj.Territory_Code__c != ''){
        if(TerritoryMap.containsKey(accObj.Territory_Code__c))
        accObj.Territory_Distributor__c = TerritoryMap.get(accObj.Territory_Code__c);
        }
        }
        }
        
        }* /
    }
    if(Trigger.isAfter){
       
        System.debug('After Insert');
        
        System.debug('recordTypeIddis--->'+recordTypeIddis);
        
        System.debug('isAfter===>');
        if(Trigger.isInsert) {
            
            for(Account ac : trigger.new){
                AccountownerIdSet.add(ac.ownerId);
                AccountInsertMap.put(ac.id,ac); 
            }
            System.debug('AccountownerIdSet'+AccountownerIdSet);
            List<User> UserList=[SELECT Id, RegionalManager__c, ZonalCommercialExecutive__c, ZonalHead__c FROM User where id  IN :AccountownerIdSet];
            Map<String, User> UserMap= new Map<String, User>([SELECT Id, RegionalManager__c, ZonalCommercialExecutive__c, ZonalHead__c FROM User where id  IN :AccountownerIdSet]);   
            System.debug('UserList'+UserList);
            
            for(Account acc  : trigger.new){
                try{
                    if(acc.RecordTypeId==recordTypeIddis){
                        Account accObj = new Account();
                        //  for( User userObj:UserList){
                        accObj.id=acc.Id;
                        system.debug('ZonalCommercialExecutive__c'+UserMap.get(acc.ownerId).ZonalCommercialExecutive__c);
                        accObj.ZonalCommercialExecutive__c=UserMap.get(acc.ownerId).ZonalCommercialExecutive__c;
                        accObj.ZonalHead__c = UserMap.get(acc.ownerId).ZonalHead__c;
                        accObj.RegionalManager__c = UserMap.get(acc.ownerId).RegionalManager__c;
                        accountList.add(accObj);
                        
                        if(UserMap.get(acc.ownerId).ZonalCommercialExecutive__c!=null){
                            System.debug('inSide The for===>'+acc.ZonalCommercialExecutive__c);
                            
                            AccountTeamMember ca = new AccountTeamMember();
                            ca.AccountId = acc.Id;
                            ca.TeamMemberRole = 'ZonalCommercialExecutive';
                            ca.UserId = UserMap.get(acc.ownerId).ZonalCommercialExecutive__c;
                            acctMembers.add(ca);
                            System.debug('inSide The for===>'+acctMembers);
                            
                            
                            AccountShare caSharingRule = new AccountShare();
                            caSharingRule.AccountId = acc.Id;
                            caSharingRule.OpportunityAccessLevel = 'Edit';
                            caSharingRule.CaseAccessLevel = 'Edit';
                            caSharingRule.AccountAccessLevel = 'Edit';
                            caSharingRule.UserOrGroupId =  UserMap.get(acc.ownerId).ZonalCommercialExecutive__c;
                            acctSharingRules.add(caSharingRule);
                            System.debug('acctSharingRules'+acctSharingRules);
                            
                        }
                        
                        
                        if(UserMap.get(acc.ownerId).ZonalHead__c!=null){
                            AccountTeamMember ca1 = new AccountTeamMember();
                            ca1 .AccountId = acc.Id;
                            ca1 .TeamMemberRole = 'ZonalHead';
                            ca1 .UserId =UserMap.get(acc.ownerId).ZonalHead__c;
                            acctMembers.add(ca1 );
                            
                            AccountShare caSharingRule1 = new AccountShare();
                            caSharingRule1.AccountId = acc.Id;
                            caSharingRule1.OpportunityAccessLevel = 'Edit';
                            caSharingRule1.CaseAccessLevel = 'Edit';
                            caSharingRule1.AccountAccessLevel = 'Edit';
                            caSharingRule1.UserOrGroupId = UserMap.get(acc.ownerId).ZonalHead__c;
                            acctSharingRules.add(caSharingRule1);
                        }
                        if(UserMap.get(acc.ownerId).RegionalManager__c!=null){
                            AccountTeamMember ca2 = new AccountTeamMember();
                            ca2.AccountId = acc.Id;
                            ca2.TeamMemberRole = 'RegionalManager';
                            ca2.UserId = UserMap.get(acc.ownerId).RegionalManager__c;
                            acctMembers.add(ca2);
                            
                            AccountShare caSharingRule2 = new AccountShare();
                            caSharingRule2.AccountId = acc.Id;
                            caSharingRule2.OpportunityAccessLevel = 'Edit';
                            caSharingRule2.CaseAccessLevel = 'Edit';
                            caSharingRule2.AccountAccessLevel = 'Edit';
                            caSharingRule2.UserOrGroupId = UserMap.get(acc.ownerId).RegionalManager__c;
                            acctSharingRules.add(caSharingRule2);
                            
                        }
                        
                        
                        // } 
                        Contact conObj = new Contact();
                        conObj.accountId=acc.id;
                        conObj.LastName = acc.Last_Name__c;
                        if(String.isNotBlank(acc.First_Name__c)){
                            conObj.FirstName = acc.First_Name__c; 
                        }
                        if(String.isNotBlank(acc.Middle_Name__c)){
                            conObj.MiddleName= acc.Middle_Name__c; 
                        }  
                        if(String.isNotBlank(acc.Salutation__c)){
                            conObj.Salutation= acc.Salutation__c; 
                        }
                        if(String.isNotBlank(acc.Mobile__c)){
                            conObj.MobilePhone= acc.Mobile__c; 
                        }  
                        if(String.isNotBlank(acc.Phone)){
                            conObj.Phone= acc.Phone; 
                        }  
                        if(String.isNotBlank(acc.Email__c)){
                            conObj.Email= acc.Email__c; 
                        } 
                        conObj.Primary__c=true;   
                        
                        contactList.add(conObj);
                        
                    } 
                }
                catch(Exception ex){
                    system.debug('Exception'+ex.getMessage()+'LineNumber:'+ex.getLineNumber());
                }
            }
            System.debug('accountList'+accountList);
            System.debug('acctMembers'+acctMembers);
            System.debug('acctSharingRules'+acctSharingRules);
            
            if(contactList.size() > 0){
                insert contactList;
            }
            if(accountList.size() > 0){
                update accountList;
            }
            if(acctMembers.size() > 0){
                insert acctMembers;
            }
            
            if(acctSharingRules.size() > 0){
                insert acctSharingRules;
            }
            
            //Logic to Map Depot with Distributor in Distributor-Depot Mapping Object
            
            Map<String, Id> depotMap = new Map<String, Id>();
            for(Depot__c depotObj:[SELECT Id, Depot_Code__c FROM Depot__c]){
                depotMap.put(depotObj.Depot_Code__c, depotObj.Id);
            }
            System.debug('depotMap: '+depotMap);
            
            List<Distributor_Depot_Mapping__c> ddmList = new List<Distributor_Depot_Mapping__c>();
            for(Account accObj:Trigger.New){
                if(accObj.RecordTypeId == recordTypeIddis){
                    if(depotMap.containsKey(accObj.Depot_Code__c)){
                        Distributor_Depot_Mapping__c ddmObj = new Distributor_Depot_Mapping__c();
                        ddmObj.Depot__c = depotMap.get(accObj.Depot_Code__c);
                        ddmObj.Distributor__c = accObj.Id;
                        ddmList.add(ddmObj);
                    }
                }
            }
            System.debug('Before ddmList: '+ddmList);
            if(!ddmList.isEmpty()){
                insert ddmList;
            }
            System.debug('After ddmList: '+ddmList);
            //End of Logic
            
        }
        if(Trigger.isUpdate) {
            System.debug('IsUpdate Account');
            for(Account ac : Trigger.new){
                if(ac.RecordTypeId==recordTypeIddis){
                    AccountIdSet.add(ac.id);
                    AccountMap.put(ac.id,ac);
                }
            }
            List<Contact> conList=[select id,Firstname,LastName,Phone,Email,mobilePhone,Salutation,Primary__c,MiddleName,AccountID from Contact where AccountID IN:AccountIdSet AND PRimary__c= :true];
            System.debug('AccountMap'+AccountMap);
            System.debug('conList'+conList);
            System.debug('conList'+conList.size());
            
            
            For(Contact con :conList){
                Contact ConObj =new Contact();
                System.debug('IF:'+AccountMap.get(con.accountId).id);
                if(AccountMap.get(con.accountId).RecordTypeId==recordTypeIddis){
                    
                    if(AccountMap.containsKey(con.accountId)){
                        ConObj.Id = con.id;
                        ConObj.accountId=AccountMap.get(con.accountId).id;
                        ConObj.LastName = AccountMap.get(con.accountId).Last_Name__c;
                        if(String.isNotBlank(AccountMap.get(con.accountId).First_Name__c)){
                            ConObj.FirstName = AccountMap.get(con.accountId).First_Name__c; 
                        }
                        if(String.isNotBlank(AccountMap.get(con.accountId).Middle_Name__c)){
                            ConObj.MiddleName= AccountMap.get(con.accountId).Middle_Name__c; 
                        }  
                        if(String.isNotBlank(AccountMap.get(con.accountId).Salutation__c)){
                            ConObj.Salutation= AccountMap.get(con.accountId).Salutation__c; 
                        }
                        if(String.isNotBlank(AccountMap.get(con.accountId).Mobile__c)){
                            ConObj.MobilePhone= AccountMap.get(con.accountId).Mobile__c; 
                        }  
                        if(String.isNotBlank(AccountMap.get(con.accountId).Phone)){
                            ConObj.Phone= AccountMap.get(con.accountId).Phone; 
                        }  
                        if(String.isNotBlank(AccountMap.get(con.accountId).Email__c)){
                            ConObj.Email=AccountMap.get(con.accountId).Email__c; 
                        }
                    } 
                }
                UpdatecontactList.add(ConObj);
            }

            
            System.debug('UpdatecontactList:'+UpdatecontactList);
            System.debug('UpdatecontactList:'+UpdatecontactList.size());
            if(UpdatecontactList.size()>0){
                Update UpdatecontactList;
            }
        }
        
    }*/
}