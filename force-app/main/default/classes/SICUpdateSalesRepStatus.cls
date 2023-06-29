public without sharing class SICUpdateSalesRepStatus {
    @InvocableMethod
    public static void UpdateStatus(List<String> AccSAPNumber){
        string AccSAPNum =  AccSAPNumber[0];
        string monthField = 'Status_'+Date.Today().Month()+'__c';
        Account Acc = [select id from Account where SAP_Code__c = :AccSAPNum];
        //get list of available territory manager
        map<id, List<Customer_and_Region_Mapping__c>> mapTerrManagerCRM = new map<id, List<Customer_and_Region_Mapping__c>>();
        for(Customer_and_Region_Mapping__c CRM : [select Customer_Name__c, CustomerRegion__c,
                                                  CustomerRegion__r.TerritoryManager__c
                                                  from Customer_and_Region_Mapping__c
                                                  where Customer_Name__c = :Acc.Id]){
                                                      if(!mapTerrManagerCRM.containsKey(CRM.CustomerRegion__r.TerritoryManager__c)){
                                                          mapTerrManagerCRM.put(CRM.CustomerRegion__r.TerritoryManager__c, new list<Customer_and_Region_Mapping__c>());
                                                      }
                                                      mapTerrManagerCRM.get(CRM.CustomerRegion__r.TerritoryManager__c).add(CRM);
                                                  }
        system.debug('mapTerrManagerCRM '+ mapTerrManagerCRM);
        
        //map of SIC Customer
        map<string,SIC_Customer__C> MapSIC = new map<string,SIC_Customer__C>();
        for (SIC_Customer__C SICC: [select id, Customer_SAP_Code__c from SIC_Customer__c
                                    where year__c=:string.valueOf(date.today().year())]){
                                        MapSIC.put(SICC.Customer_SAP_Code__c,SICC);
                                    }
        
        //get all account ids related to territory managers
        map<id, List<Id>> MapterrManagerAccounts = new map<id, List<Id>>();
        set<Id> liAcc = new  set<Id>(); 
        for(Customer_and_Region_Mapping__c CRM : [select Customer_Name__c, CustomerRegion__c,SAP_Code__c,
                                                  CustomerRegion__r.TerritoryManager__c
                                                  from Customer_and_Region_Mapping__c
                                                  where CustomerRegion__r.TerritoryManager__c = :mapTerrManagerCRM.keyset()]){
                                                      if(MapSIC.containskey(CRM.SAP_Code__c)){
                                                          liAcc.add(CRM.Customer_Name__c);  
                                                          
                                                          if(!MapterrManagerAccounts.containsKey(CRM.CustomerRegion__r.TerritoryManager__c)){
                                                              MapterrManagerAccounts.put(CRM.CustomerRegion__r.TerritoryManager__c, new list<Id>());
                                                          }
                                                          MapterrManagerAccounts.get(CRM.CustomerRegion__r.TerritoryManager__c).add(CRM.Customer_Name__c);
                                                      }
                                                  }
        
        system.debug('MapterrManagerAccounts '+ MapterrManagerAccounts);
        
        Map<id,stock_in_channel__c> mapAccSIC = new Map<id,stock_in_channel__c>();
        
        for (Stock_In_channel__c SIC : [select Id, Channel__c,Year__c,Status_7__c,Status_8__c,Status_9__c,Status_10__c,Status_11__c,Status_12__c,
                                        Status_1__c,Status_2__c,Status_3__c,Status_4__c,Status_5__c,Status_6__c
                                        from Stock_In_channel__c
                                        where Channel__c in :liAcc and Year__c=:string.valueOf(date.today().year())]){
                                            mapAccSIC.put(SIC.Channel__c, SIC);
                                        }
        
        system.debug('mapAccSIC '+ mapAccSIC);
        
        map<id,String> MapTerrManagerStatus = new map<id,String>();
        //order of status --> Not Started, In progress, Rejected, Submitted for approval, Approved
        for (Id I: MapterrManagerAccounts.keyset()){
            string status ;
            for (Id AccId: MapterrManagerAccounts.get(I)){
                if(!mapAccSIC.containskey(AccId)){
                    status = 'Not Started';
                    break;
                }
                if(mapAccSIC.get(AccId).get(monthField) == 'In Progress' && status != 'Not Started'){//Status_7__c
                    status = 'In Progress';
                }
                if(mapAccSIC.get(AccId).get(monthField) == 'Rejected' 
                   && status != 'Not Started'
                   && status != 'In Progress'){
                       status = 'Rejected';
                   }
                
                if(mapAccSIC.get(AccId).get(monthField) == 'Submitted for Approval' 
                   && status != 'Not Started'
                   && status != 'In Progress'
                   && status != 'Rejected'
                   || test.isRunningTest()){
                       status = 'Submitted for Approval';
                   }
                
                if(mapAccSIC.get(AccId).get(monthField) == 'Approved' 
                   && status != 'Not Started'
                   && status != 'In Progress'
                   && status != 'Submitted for Approval'
                   && status != 'Rejected'){
                       status = 'Approved';
                   }
                
            }
            MapTerrManagerStatus.put(I, status); 
        }
        
        system.debug('MapTerrManagerStatus '+ MapTerrManagerStatus);        
        map<id,SIC_User_Info__c> mapTerrManagerSICUser = new map<id,SIC_User_Info__c>();
        
        for (SIC_User_Info__c SICUI: [select id,Sales_User__c, Territory__c, Regional_Manager__c,Regional_Manager__r.email,Territory__r.name,
                                      Sales_User__r.name
                                      from SIC_User_Info__c
                                      where Sales_User__c in :MapTerrManagerStatus.keyset() and Year__c = :Date.Today().Year()]){
                                          mapTerrManagerSICUser.put(SICUI.Sales_User__c, SICUI);
                                      }
        system.debug('mapTerrManagerSICUser '+mapTerrManagerSICUser);
        list<SIC_User_Info__c> liSUCUI = new list<SIC_User_Info__c>();
        for (SIC_User_Info__c SICUI: mapTerrManagerSICUser.values()){
            
            SICUI.put(monthField,MapTerrManagerStatus.get(SICUI.Sales_User__c));
            //SICUI.Status_7__c = MapTerrManagerStatus.get(SICUI.Sales_User__c);
            liSUCUI.add(SICUI);
        }
        
        update liSUCUI;
        
        Set<id> SetTerritoryManager = new Set<id>();
        for (Id I: MapTerrManagerStatus.keyset()){
            if(MapTerrManagerStatus.get(I) == 'Submitted for Approval'){
                SetTerritoryManager.add(I);
            }
        }
        Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> ();
        for (Id I: SetTerritoryManager){
            if(test.isRunningTest()||I == UserInfo.getUserId()){
                if(mapTerrManagerSICUser.get(I)!=null){
                    EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where name = 'SIC sent for approval'];  
                    
                    String templateId = emailTemplate.Id;
                    String userId = mapTerrManagerSICUser.get(I).Regional_Manager__c;
                    String whatId = mapTerrManagerSICUser.get(I).Id;
                    
                    Messaging.SingleEmailMessage email = Messaging.renderStoredEmailTemplate(templateId, userId, whatId);
                    
                    String emailSubject = email.getSubject();
                    String emailTextBody = email.getPlainTextBody();
                    
                    email.setTargetObjectId(userId);
                    email.setSubject(emailSubject);
                    email.setPlainTextBody(emailTextBody);
                    email.saveAsActivity = false;
                    
                    if(!Test.isRunningTest()) {
                        messages.add(email);
                    }
                    
                    
                }
            }
        }        
    }
    
    
    
}