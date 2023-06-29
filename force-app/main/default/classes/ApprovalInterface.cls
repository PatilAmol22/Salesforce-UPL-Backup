/*******************************************************************************************
* @Name         Approval Interface 
* @Author       Priyanka Nalawade <priyanka.nalawade@skinternational.com>
* @Date         01/02/2023
* @Group        SKI
* @Description  This class is used for custom Approval Process(Current Objects: Demand Generation and Return Sales Order).
*******************************************************************************************/
/* MODIFICATION LOG
* Version          Developer         Date(MM/DD/YYYY)      Description
*-------------------------------------------------------------------------------------------   
*  1.0              Priyanka            13/02/2023          Initial Creation                                        
*******************************************************************************************/
public with sharing class ApprovalInterface {
   
    @AuraEnabled(cacheable=true)
    public static Map<String,String> getSobjects(){
        // try {
            User users= [select id,Name,profile.name,UGDN_Number__c from User where id=:Userinfo.getUserId() limit 1];
             String profileName = Users.profile.Name;
            System.debug('prfileName '+profileName);
            List<Approval_Interface_Configuration__c> approvalInterfaceConfigurations = [select id,Name,sObject_API_Name__c,UGDN_Number__c,Profile_API_Name__c from Approval_Interface_Configuration__c where Profile_API_Name__c =:profileName and sObject_API_Name__c!=null];
            if(approvalInterfaceConfigurations[0].UGDN_Number__c == users.UGDN_Number__c && approvalInterfaceConfigurations[0].UGDN_Number__c!=null){
                approvalInterfaceConfigurations = [select id,Name,sObject_API_Name__c,UGDN_Number__c from Approval_Interface_Configuration__c where Profile_API_Name__c ='Brazil Sales Person SMM' and sObject_API_Name__c!=null];
            }
            Map<String,String> mapSobjects = new Map<String,String>();
            String SbjectLabel = '';
            for(Approval_Interface_Configuration__c aic:approvalInterfaceConfigurations){
                SbjectLabel = Schema.getGlobalDescribe().get(aic.sObject_API_Name__c).getDescribe().getLabel();
                mapSobjects.put(aic.sObject_API_Name__c,SbjectLabel);
            }
         System.debug('mapSobjects-- '+mapSobjects);
            return mapSobjects;
      
    }

    @AuraEnabled(cacheable=true)
    public static List<string> getStage(String selectedObject){
        try {
            List<String> stages = new List<String>();
            User users= [select id,Name,profile.name,UGDN_Number__c from User where id=:Userinfo.getUserId() limit 1];
            String profileName = Users.profile.Name;
            List<Approval_Interface_Configuration__c> approvalInterfaceConfigurations = [select id,Name,sObject_API_Name__c,Stage__c,UGDN_Number__c,Profile_API_Name__c from Approval_Interface_Configuration__c where sObject_API_Name__c =:selectedObject and Profile_API_Name__c=:profileName limit 1];
            if(approvalInterfaceConfigurations[0].UGDN_Number__c == users.UGDN_Number__c && approvalInterfaceConfigurations[0].UGDN_Number__c!=null){
                approvalInterfaceConfigurations = [select id,Name,sObject_API_Name__c,Stage__c,UGDN_Number__c,Profile_API_Name__c from Approval_Interface_Configuration__c where sObject_API_Name__c =:selectedObject and Profile_API_Name__c='Brazil Sales Person SMM'  limit 1];
            }
            if(approvalInterfaceConfigurations.size()>0){
                stages = approvalInterfaceConfigurations[0].Stage__c!=null?approvalInterfaceConfigurations[0].Stage__c.Split(';'):new List<String>();
            }
            return stages;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static string getDefaultStage(String selectedObject){
        try {
            User users= [select id,Name,profile.name,UGDN_Number__c from User where id=:Userinfo.getUserId() limit 1];
            String profileName = Users.profile.Name;
            List<Approval_Interface_Configuration__c> approvalInterfaceConfigurations = [select id,Name,sObject_API_Name__c,Default_Selected_Statge__c,UGDN_Number__c,Profile_API_Name__c from Approval_Interface_Configuration__c where sObject_API_Name__c =:selectedObject and Profile_API_Name__c=:profileName limit 1];
            System.debug('approvalInterfaceConfigurations condition '+approvalInterfaceConfigurations[0].UGDN_Number__c == users.UGDN_Number__c);
            if(approvalInterfaceConfigurations[0].UGDN_Number__c == users.UGDN_Number__c && approvalInterfaceConfigurations[0].UGDN_Number__c!=null){
                approvalInterfaceConfigurations = [select id,Name,sObject_API_Name__c,Default_Selected_Statge__c,Profile_API_Name__c from Approval_Interface_Configuration__c where sObject_API_Name__c =:selectedObject and Profile_API_Name__c='Brazil Sales Person SMM'  limit 1];
            }
            String stages;
            if(approvalInterfaceConfigurations.size()>0){
                stages = approvalInterfaceConfigurations[0].Default_Selected_Statge__c!=null?approvalInterfaceConfigurations[0].Default_Selected_Statge__c:'';
            }
            return stages;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public static Map<String,String> getSoqlStmt(){
        Map<String,String> mapSoql = new Map<String,String>();
        mapSoql.put('Pending','Pending_SOQL_Statement__c');
        mapSoql.put('Approved','Approved_SOQL_Statement__c');
        mapSoql.put('Rejected','Rejected_SOQL_Statement__c');
        mapSoql.put('Failed_In_Process','Failed_In_Process_SOQL_Statement__c');
        mapSoql.put('Cancelled','Cancelled_SOQL_Statement__c');
        mapSoql.put('Pending_At_Higher_Authority','Pending_At_Higher_Authority_SOQL_State__c');
        mapSoql.put('Open','Open_SOQL_Statement__c');
    return mapSoql;
    }
   
    @AuraEnabled
    public static List<sobject> getStageRecords(String selectedObject, String selectedStage){
        try {
           System.debug('selectedObject '+selectedObject +' selectedStage '+selectedStage);
            list<sobject> records;
             User users= [select id,Name,profile.name,UGDN_Number__c from User where id=:Userinfo.getUserId() limit 1];
             String profileName = Users.profile.Name;
            List<Approval_Interface_Configuration__c> approvalInterfaceConfigurations = [select id,Name,sObject_API_Name__c,Child_Level_1__c,UGDN_Number__c,Stage__c,Approved_SOQL_Statement__c,Open_SOQL_Statement__c,Failed_In_Process_SOQL_Statement__c,Pending_At_Higher_Authority_SOQL_State__c,Rejected_SOQL_Statement__c,Pending_SOQL_Statement__c,Cancelled_SOQL_Statement__c,Profile_API_Name__c from Approval_Interface_Configuration__c where sObject_API_Name__c =:selectedObject and Profile_API_Name__c=:profileName limit 1];
          if(approvalInterfaceConfigurations[0].UGDN_Number__c == users.UGDN_Number__c && approvalInterfaceConfigurations[0].UGDN_Number__c!=null){
             approvalInterfaceConfigurations = [select id,Name,sObject_API_Name__c,Child_Level_1__c,UGDN_Number__c,Stage__c,Approved_SOQL_Statement__c,Open_SOQL_Statement__c,Failed_In_Process_SOQL_Statement__c,Pending_At_Higher_Authority_SOQL_State__c,Rejected_SOQL_Statement__c,Pending_SOQL_Statement__c,Cancelled_SOQL_Statement__c,Profile_API_Name__c from Approval_Interface_Configuration__c where sObject_API_Name__c =:selectedObject and Profile_API_Name__c='Brazil Sales Person SMM' limit 1];
          }
            if(approvalInterfaceConfigurations.size()>0){
                String query =(String)approvalInterfaceConfigurations[0].get(getSoqlStmt().get(selectedStage));
                System.debug('SOQL Stmt records' + query);
                query = query + ' Order by LastModifiedDate DESC';
                records = Database.query(query);
                System.debug('records' + records);
            }
            if(selectedStage=='Pending' && !approvalInterfaceConfigurations[0].Profile_API_Name__c.contains('Brazil System Administrator')){
                List<Sobject> myPendingRecord = getMyPendingRecord(records);
                return myPendingRecord;
            }else{
                return records;
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Approval_Interface_Configuration__c getConfiguration(String selectedObject){
        try {
           
            
            User users= [select id,Name,profile.name,UGDN_Number__c from User where id=:Userinfo.getUserId() limit 1];
            String profileName = Users.profile.Name;
            List<Approval_Interface_Configuration__c> approvalInterfaceConfigurations = [select id,Name,sObject_API_Name__c,Child_Level_1__c,UGDN_Number__c,Stage__c,Approved_SOQL_Statement__c,Failed_In_Process_SOQL_Statement__c,Open_SOQL_Statement__c,Approve_Reject_By_Status__c,Rejected_SOQL_Statement__c,Pending_SOQL_Statement__c,Cancelled_SOQL_Statement__c from Approval_Interface_Configuration__c where sObject_API_Name__c =:selectedObject and Profile_API_Name__c=:profileName limit 1];
            if(approvalInterfaceConfigurations[0].UGDN_Number__c == users.UGDN_Number__c && approvalInterfaceConfigurations[0].UGDN_Number__c!=null){
                approvalInterfaceConfigurations = [select id,Name,sObject_API_Name__c,Child_Level_1__c,UGDN_Number__c,Stage__c,Approved_SOQL_Statement__c,Open_SOQL_Statement__c,Failed_In_Process_SOQL_Statement__c,Pending_At_Higher_Authority_SOQL_State__c,Rejected_SOQL_Statement__c,Pending_SOQL_Statement__c,Cancelled_SOQL_Statement__c,Approve_Reject_By_Status__c from Approval_Interface_Configuration__c where sObject_API_Name__c =:selectedObject and Profile_API_Name__c='Brazil Sales Person SMM' limit 1];
             }
            if(approvalInterfaceConfigurations.size()>0){
                return approvalInterfaceConfigurations[0];
            }
            return new Approval_Interface_Configuration__c();
        }
        catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }


    public static Map<String,String> getColumns(){
        Map<String,String> mapSoql = new Map<String,String>();
        mapSoql.put('Pending','Pending_Header_Column_Name__c');
        mapSoql.put('Approved','Approved_Header_Column_Name__c');
        mapSoql.put('Rejected','Rejected_Header_Column_Name__c');
        mapSoql.put('Failed_In_Process','Failed_In_Process_Header_Column_Name__c');
        mapSoql.put('Cancelled','Cancelled_Header_Column_Name__c');
        mapSoql.put('Pending_At_Higher_Authority','Pending_At_Higher_Authority_Header_Col__c');
        mapSoql.put('Open','Open_Header_Column_Name__c');
    return mapSoql;
    }
   
    @AuraEnabled(cacheable=true)
    public static String getApprovalConfiguration(String selectedObject, String selectedStage){
        try {
           
            String columns;
            User users= [select id,Name,profile.name,UGDN_Number__c from User where id=:Userinfo.getUserId() limit 1];
            String profileName = Users.profile.Name;
            List<Approval_Interface_Configuration__c> approvalInterfaceConfigurations = [select id,Name,sObject_API_Name__c,Stage__c,UGDN_Number__c,Approved_Header_Column_Name__c,Open_Header_Column_Name__c,Pending_At_Higher_Authority_Header_Col__c,Cancelled_Header_Column_Name__c,Failed_In_Process_Header_Column_Name__c,Rejected_Header_Column_Name__c,Pending_Header_Column_Name__c,Profile_API_Name__c  from Approval_Interface_Configuration__c where sObject_API_Name__c =:selectedObject and Profile_API_Name__c=:profileName limit 1];

            if(approvalInterfaceConfigurations[0].UGDN_Number__c == users.UGDN_Number__c && approvalInterfaceConfigurations[0].UGDN_Number__c!=null){
                approvalInterfaceConfigurations = [select id,Name,sObject_API_Name__c,Stage__c,UGDN_Number__c,Approved_Header_Column_Name__c,Open_Header_Column_Name__c,Pending_At_Higher_Authority_Header_Col__c,Cancelled_Header_Column_Name__c,Failed_In_Process_Header_Column_Name__c,Rejected_Header_Column_Name__c,Pending_Header_Column_Name__c,Profile_API_Name__c  from Approval_Interface_Configuration__c where sObject_API_Name__c =:selectedObject and Profile_API_Name__c='Brazil Sales Person SMM' limit 1];
             }
            

           if(approvalInterfaceConfigurations.size()>0){
            columns =(String)approvalInterfaceConfigurations[0].get(getColumns().get(selectedStage));
               System.debug('columns-1-'+columns);
            return columns;
            }
             System.debug('columns-2-'+columns);
            return columns;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }


    @AuraEnabled
    public static String processRecord(String records,String status,String comment) {
        List<String> data = (List<String>)JSON.deserialize(records, List<String>.class);
        System.debug('Data '+data);
        System.debug('Data size'+data.size());
        Map<Id, ProcessInstance> map1 =  new Map<Id, ProcessInstance>([SELECT Id,Status,TargetObjectId FROM ProcessInstance where Status='Pending' and TargetObjectId in :data]);
        Set<Id> pIds = map1.keySet(); // getting ProcessInstance
        
        // Add for RSO Edit
        List<GroupMember> grp = [SELECT Id, GroupId, Group.Name, UserOrGroupId FROM GroupMember WHERE UserOrGroupId=:UserInfo.getuserid()];
        List<String> grpId = new List<String>();
        for(GroupMember g : grp){
            grpId.add(g.GroupId);
        }

        Set<Id> pInstanceWorkitems = (new Map<Id, ProcessInstanceWorkitem>([SELECT Id,ProcessInstanceId FROM ProcessInstanceWorkitem WHERE ProcessInstanceId in :pIds and (OriginalActorId=:UserInfo.getUserId() or OriginalActorId IN:grpId)])).keySet();// getting ProcessInstanceWorkitem

        List<Approval.ProcessWorkitemRequest> allReq = new List<Approval.ProcessWorkitemRequest>(); 

        for (Id pInstanceWorkitemsId:pInstanceWorkitems){
            System.debug('pInstanceWorkitems '+pInstanceWorkitemsId);
            Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
            req2.setWorkitemId(pInstanceWorkitemsId);
            req2.setAction(status);
            req2.setComments(comment);
            allReq.add(req2);
        }
        Approval.ProcessResult[] result1 =  Approval.process(allReq);
        return records;
    }
  
    public static List<SObject> getMyPendingRecord(List<SObject> records){
        Map<String,Sobject> mapSobject = new Map<String,Sobject>(); 
        List<Sobject> myPendingRecords = new List<Sobject>(); 
        for(sobject rec:records){
            mapSobject.put(rec.Id,rec);
        }
        
        List<GroupMember> grp = [SELECT Id, GroupId, Group.Name, UserOrGroupId FROM GroupMember WHERE UserOrGroupId=:UserInfo.getuserid()];
        List<String> grpId = new List<String>();
        for(GroupMember g : grp){
            grpId.add(g.GroupId);
        }
        System.debug('grpId '+grpId);
        System.debug('mapSobject.keySet() '+mapSobject.keySet());
        List<ProcessInstanceWorkitem> piwIds = [SELECT Id, ProcessInstanceId, OriginalActor.Name, Actor.Name, ElapsedTimeInDays, ElapsedTimeInHours, ElapsedTimeInMinutes,IsDeleted,CreatedDate, CreatedById, SystemModstamp,ProcessInstance.targetObjectId FROM ProcessInstanceWorkitem WHERE ProcessInstance.targetObjectId IN:mapSobject.keySet() and (actor.Id =: UserInfo.getuserid() OR actor.Id IN: grpId) order by CreatedDate];
        for(ProcessInstanceWorkitem pwid:piwIds){
            myPendingRecords.add(mapSobject.get(pwid.ProcessInstance.targetObjectId));
        }
         System.debug('myPendingRecords-- '+myPendingRecords);
        return myPendingRecords;
    }

    public class LastModifiedComparable implements Comparable {
        public Datetime lastModifiedDate;
        public LastModifiedComparable(Datetime lastModifiedDate) {
            this.lastModifiedDate = lastModifiedDate;
        }
        
        // Implementation of the compareTo method to sort by LastModifiedDate
        public Integer compareTo(Object compareTo) {
            LastModifiedComparable compareToObj = (LastModifiedComparable)compareTo;
            if (this.LastModifiedDate > compareToObj.LastModifiedDate) {
                return -1;
            } else if (this.LastModifiedDate < compareToObj.LastModifiedDate) {
                return 1;
            } else {
                return 0;
            }
        }
    }
    
}