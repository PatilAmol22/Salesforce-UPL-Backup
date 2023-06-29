public without sharing class GetProcessInstanceData {
    private static Map<String, Map<String, Schema.SObjectField>> OBJECT_NAME_TO_DESCRIBE;
   private static Map<String, String> OBJECT_NAME_TO_NAME_FIELD;
   private static Map<String, List<Schema.DescribeFieldResult>> REQUIRED_FIELDS_DESCRIBES;
   private static Set<String> FIELD_NAMES = new Set<String>{
           'Id'
   };

   //@AuraEnabled(cacheable=true)
   public static List<FSPWrapper> getViewDetails(String Id,List<Free_Sampling_Crop_Pest__c> fscpList,List<Free_Sampling_Product__c> fspList){
       System.debug('Id :'+Id);
       Map<Id,Map<Id,List<String>>> targetCropIdMap=new Map<Id,Map<Id,List<String>>>();
       Map<Id,List<String>> targetCropMap=new Map<Id,List<String>>();
       
       Map<Id,Map<Id,List<String>>> targetPestIdMap=new Map<Id,Map<Id,List<String>>>();
       Map<Id,List<String>> targetPestMap=new Map<Id,List<String>>();
       
       //List<Free_Sampling_Crop_Pest__c> fscpList=[SELECT Id,Product__c,Target_Crop__r.Name,Target_Pest__r.Name From Free_Sampling_Crop_Pest__c where Free_Sampling__c=:Id];
       for(Free_Sampling_Crop_Pest__c fscp:fscpList){
           List<String> targetCopList=new List<String>();
           if(fscp.Target_Crop__r.Name!=null){
               if(!targetCropMap.containsKey(fscp.Product__c)){
                   targetCopList.add(fscp.Target_Crop__r.Name);
                   targetCropMap.put(fscp.Product__c,targetCopList);
               }else{
                   targetCropMap.get(fscp.Product__c).add(fscp.Target_Crop__r.Name);
               }
           }

           List<String> targetPestList=new List<String>();
           if(fscp.Target_Pest__r.Name!=null){
               System.debug('fscp.Target_Pest__r.Name :'+fscp.Target_Pest__r.Name);
               if(!targetPestMap.containsKey(fscp.Product__c)){
                   targetPestList.add(fscp.Target_Pest__r.Name);
                   targetPestMap.put(fscp.Product__c,targetPestList);
               }else{
                   targetPestMap.get(fscp.Product__c).add(fscp.Target_Pest__r.Name);
               }
           }
           
       }
       System.debug('targetCropMap :'+targetCropMap);
       if(targetCropMap!=null || !targetCropMap.isEmpty()){
           targetCropIdMap.put(Id,targetCropMap);  
       }
       if(targetPestMap!=null || !targetPestMap.isEmpty()){ 
           targetPestIdMap.put(Id,targetPestMap);  
       }

       Map<Id,List<String>> getCropMapList=new Map<Id,List<String>>();
       Map<Id,List<String>> getPestMapList=new Map<Id,List<String>>();
       List<FSPWrapper> wrapList=new List<FSPWrapper>();
       //List<Free_Sampling_Product__c> fspList=[SELECT Id,Free_Sampling__c,Product__c,Product__r.Name,Demo_Size_Acer__c,Dose_Acre_GM_ML_L_Per_Acre__c,Number_of_Demo__c From Free_Sampling_Product__c where Free_Sampling__c=:Id];
           for(Free_Sampling_Product__c fsp:fspList){
               System.debug('fsp :'+fsp);
               FSPWrapper wrap=new FSPWrapper();
               wrap.productName=fsp.Product__r.Name;
               wrap.size=fsp.Demo_Size_Acer__c;
               wrap.acre=fsp.Dose_Acre_GM_ML_L_Per_Acre__c;
               wrap.demo=fsp.Number_of_Demo__c;
               wrap.demoQtyGMML=fsp.Demo_Sample_Qty_GM_ML__c;
               wrap.demoMaterialValue=fsp.Demo_material_value__c;
               if(targetCropIdMap.containsKey(fsp.Free_Sampling__c)){
                   getCropMapList=targetCropIdMap.get(fsp.Free_Sampling__c);
                   wrap.targetCopList=getCropMapList.get(fsp.Product__c);
               }
               if(targetPestIdMap.containsKey(fsp.Free_Sampling__c)){
                   getPestMapList=targetPestIdMap.get(fsp.Free_Sampling__c);
                   wrap.targetPestList=getPestMapList.get(fsp.Product__c);
               }

               wrapList.add(wrap);
           } 
       System.debug('wrapList :'+wrapList);
       return wrapList;
   }

   @AuraEnabled
   public static String getProcessItemData(String actorId, String fieldNames, String objectName, String mode,String recordName,String depotName,String territoryName,String From_Date,String To_Date) {
       System.debug('fieldNames:::' + fieldNames);
       System.debug('objectName:::' + objectName);
       System.debug('mode:::' + mode);
       System.debug('depotName:::' + depotName);
       System.debug('To_Date:::' + To_Date);

       return JSON.serialize(getRowData(actorId, fieldNames, objectName, mode,recordName,depotName,territoryName,From_Date,To_Date));
   }

   private static Set<Id> getRelatedActors(Id actorId) {
       Set<Id> actors = new Set<Id>{
               actorId
       };
       List<User> users = [SELECT Id,DelegatedApproverId FROM User WHERE DelegatedApproverId = :actorId];

       for (User curUser : users) {
           actors.add(curUser.Id);
       }

       List<GroupMember> relatedGroupMembers = [SELECT Id,GroupId FROM GroupMember WHERE UserOrGroupId = :actorId AND Group.Type = 'Queue'];
       if (!relatedGroupMembers.isEmpty()) {
           for (GroupMember curGm : relatedGroupMembers) {
               actors.add(curGm.GroupId);
           }
       }
       System.debug('actors:::' + actors);
       return actors;
   }

   public static Map<String, SObject> getSObjectMap(List<SObject> sObjects, String keyFieldName) {
       Map<String, SObject> results = new Map<String, SObject>();
       for (SObject so : sObjects) {
           results.put((String) so.get(keyFieldName), so);
       }
       return results;
   }

   public static Set<String> getSObjectSet(List<SObject> sObjects, String keyFieldName) {
       System.debug('sObjects : '+sObjects);
       System.debug('keyFieldName : '+keyFieldName);
       Set<String> results = new Set<String>();
       for (SObject so : sObjects) {
           results.add((String) so.get(keyFieldName));
       }
       return results;
   }

   public static void setFieldNames(String fieldNames, Set<String> objectTypes) {

       System.debug('fieldNames:::' + fieldNames);
       for (String objectType : objectTypes) {
           String nameField = OBJECT_NAME_TO_NAME_FIELD.get(objectType);
           if (nameField != null) {
               if (fieldNames == null || !fieldNames.toLowerCase().contains(nameField.toLowerCase())) {
                   FIELD_NAMES.add(nameField);
               }
           }
       }

       if (fieldNames != null) {
           FIELD_NAMES.addAll(fieldNames.replaceAll('\\s+', '').split(','));
           System.debug('FIELD_NAMES:::' + FIELD_NAMES);
       }
   }
    
   public static Map<String, FSMWrapper> getRecordData(Set<String> targetObjectIds, Set<String> objectTypes, String objectTypeName,String recordName,String depotName,String territoryName,String From_Date,String To_Date) {
       Map<String, FSMWrapper> allRecords = new Map<String, FSMWrapper>();
       Map<String, String> fsmIdMap = new Map<String, String>();
       List<FSMWrapper> fsmWrapList=new List<FSMWrapper>();
       String subStatus='';
       String userRoleName='';
       Id userId = userinfo.getUserId();
       User userDetails =[SELECT Id, Name, Email, Profile.Name, UserRole.Name FROM User where Id=:userId ];
    System.debug('userDetails.UserRole.Name :'+userDetails.UserRole.Name);
       if(!Test.isRunningTest()){
           if(userDetails.UserRole.Name.contains('FMM')){// || userDetails.UserRole.Name.contains('Zonal'))){// Edited by Sandeep Vishwakarma 2-2-2023 AF Material Requisition
               subStatus='Pending for Approval 1';
               userRoleName='FMM';
           }else if(userDetails.UserRole.Name.contains('Regional Manager')){
               subStatus='Pending for Approval 1';
               userRoleName='Regional Manager';
           }else if(userDetails.UserRole.Name.contains('Zonal Head') || userDetails.UserRole.Name.contains('ZMM') || userDetails.UserRole.Name.contains('Channel Deployment Manager') || userDetails.UserRole.Name.contains('FMM') || userDetails.UserRole.Name.contains('Zonal Commercial Head') || userDetails.UserRole.Name.contains('SBU')){
               subStatus='Pending for Approval 2';
           }else if(userDetails.UserRole.Name.contains('Marketing HO') || userDetails.UserRole.Name.contains('Strategic Marketing & Business development head')){
               subStatus='Pending for Approval 3';
           }else if(userDetails.UserRole.Name.contains('Zonal')){// Edited by Sandeep Vishwakarma 2-2-2023 AF Material Requisition
               subStatus='Pending for Approval 1';
               userRoleName='FMM';
           }
       }else{
           subStatus='Pending for Approval 3';
       }
       Map<Id,List<Free_Sampling_Crop_Pest__c>> fscpListMap=new Map<Id,List<Free_Sampling_Crop_Pest__c>>(); 
       List<Free_Sampling_Crop_Pest__c> fscpList2=[SELECT Id,Product__c,Target_Crop__r.Name,Target_Pest__r.Name,Free_Sampling__c From Free_Sampling_Crop_Pest__c where Free_Sampling__r.Sub_Status__c=:subStatus];
       for(Free_Sampling_Crop_Pest__c fscp:fscpList2){
           
           List<Free_Sampling_Crop_Pest__c> fscpList=new List<Free_Sampling_Crop_Pest__c>();
           if(!fscpListMap.containsKey(fscp.Free_Sampling__c)){
               fscpList.add(fscp);
               fscpListMap.put(fscp.Free_Sampling__c,fscpList);
           }else{
               fscpListMap.get(fscp.Free_Sampling__c).add(fscp);
           }
           
       }
       Map<Id,List<Free_Sampling_Product__c>> fspListMap=new Map<Id,List<Free_Sampling_Product__c>>(); 
       List<Free_Sampling_Product__c> fspList2=[SELECT Id,Free_Sampling__c,Product__c,Product__r.Name,Demo_Size_Acer__c,Dose_Acre_GM_ML_L_Per_Acre__c,Number_of_Demo__c,Demo_Sample_Qty_GM_ML__c,Demo_material_value__c From Free_Sampling_Product__c where Free_Sampling__r.Sub_Status__c=:subStatus];
       for(Free_Sampling_Product__c fsp:fspList2){
           List<Free_Sampling_Product__c> fspList=new List<Free_Sampling_Product__c>();
           if(!fspListMap.containsKey(fsp.Free_Sampling__c)){
               fspList.add(fsp);
               fspListMap.put(fsp.Free_Sampling__c,fspList);
           }else{
               fspListMap.get(fsp.Free_Sampling__c).add(fsp);
           }
       }
       System.debug('objectTypes >>>>>>'+objectTypes);
       System.debug('objectTypeName >>>>>>'+objectTypeName);
       
       for (String curObjectType : objectTypes) {
           if (objectTypeName == null || objectTypeName == curObjectType) {
               String myQuery ='';
               List<Free_Sample_Management__c> fsmList=new List<Free_Sample_Management__c>();
               System.debug('recordName:::' + recordName);
               String status='Pending';
               // Edited by Sandeep Vishwakarma - SKI 27-01-2023 AF Material Requisition
            //    String labelSalesOrgs = System.Label.ActiveSalesOrgForMaterialRequisition;
               List<String> saleorgs =getSalesOrgByProfile();
               System.debug('From_Date:::' + From_Date);  
               String fromDateStr='',toDateStr='';
               DateTime fromDateTime ,toDateTime ;
               if(String.isNotBlank(From_Date)){
                   Date date1=Date.valueOf(From_Date);
                   System.debug('date1 : '+date1);
                   Integer d = date1.day();
                   Integer mo = date1.month();
                   Integer yr = date1.year();
                   fromDateTime = DateTime.newInstance(yr, mo, d);
                   //fromDateStr=fromDateTime.format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
               }
              
               if(String.isNotBlank(To_Date)){
                   Date date2=Date.valueOf(To_Date);
                   System.debug('date2 : '+date2);
                   Integer d2 = date2.day();
                   Integer mo2 = date2.month();
                   Integer yr2 = date2.year();
                   toDateTime = DateTime.newInstance(yr2, mo2, d2);
                   //toDateStr=toDateTime.format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
               }
               
              System.debug('fromDateTime : '+fromDateTime);
              System.debug('toDateStr : '+toDateTime);
                         
               if(String.isNotBlank(recordName)){
                   if(fromDateTime!=null && toDateTime!=null){
                       String rName='%'+recordName+'%';
                       // Edited by Sandeep Vishwakarma - SKI 27-01-2023 AF Material Requisition
                       fsmList=InvokeGetProcessMetaData.getMethod1(targetObjectIds,saleorgs,status,subStatus,fromDateTime,toDateTime,rName);//[SELECT Id, Name,Depot__r.Name,Territory_Manager__r.Name,Territory__r.Name,Approval_Submission_Date_Time__c  FROM Free_Sample_Management__c WHERE Id IN :targetObjectIds And Name Like : rName AND Approval_Submission_Date_Time__c >=: fromDateTime AND Approval_Submission_Date_Time__c <=: toDateTime AND SalesOrg__r.Sales_Org_Code__c=:saleorgs AND Status__c=:status AND Sub_Status__c=:subStatus];
                   }else{
                       String rName='%'+recordName+'%';
                       // Edited by Sandeep Vishwakarma - SKI 27-01-2023 AF Material Requisition
                       fsmList=InvokeGetProcessMetaData.getMethod2(targetObjectIds,saleorgs,status,subStatus,rName);//[SELECT Id, Name,Depot__r.Name,Territory_Manager__r.Name,Territory__r.Name,Approval_Submission_Date_Time__c  FROM Free_Sample_Management__c WHERE Id IN :targetObjectIds AND Name Like : rName AND SalesOrg__r.Sales_Org_Code__c=:saleorgs AND Status__c=:status AND Sub_Status__c=:subStatus];
                   }
               }else if(String.isNotBlank(depotName)){
                   if(fromDateTime!=null && toDateTime!=null){
                       String dName='%'+depotName+'%';
                       // Edited by Sandeep Vishwakarma - SKI 27-01-2023 AF Material Requisition
                       fsmList=InvokeGetProcessMetaData.getMethod3(targetObjectIds,saleorgs,status,subStatus,fromDateTime,toDateTime,dName);//[SELECT Id, Name,Depot__r.Name,Territory_Manager__r.Name,Territory__r.Name,Approval_Submission_Date_Time__c  FROM Free_Sample_Management__c WHERE Id IN :targetObjectIds And Depot__r.Name Like : dName AND Approval_Submission_Date_Time__c >= :fromDateTime AND Approval_Submission_Date_Time__c <= :toDateTime AND SalesOrg__r.Sales_Org_Code__c=:saleorgs AND Status__c=:status AND Sub_Status__c=:subStatus];
                   }else{
                       String dName='%'+depotName+'%';
                       // Edited by Sandeep Vishwakarma - SKI 27-01-2023 AF Material Requisition
                       fsmList=InvokeGetProcessMetaData.getMethod4(targetObjectIds,saleorgs,status,subStatus,dName);//[SELECT Id, Name,Depot__r.Name,Territory_Manager__r.Name,Territory__r.Name,Approval_Submission_Date_Time__c  FROM Free_Sample_Management__c WHERE Id IN :targetObjectIds And Depot__r.Name Like : dName AND SalesOrg__r.Sales_Org_Code__c=:saleorgs AND Status__c=:status AND Sub_Status__c=:subStatus];
                   }
               }else if(String.isNotBlank(territoryName)){
                   if(fromDateTime!=null && toDateTime!=null){
                       String tName='%'+territoryName+'%';
                   // Edited by Sandeep Vishwakarma - SKI 27-01-2023 AF Material Requisition
                       fsmList=InvokeGetProcessMetaData.getMethod5(targetObjectIds,saleorgs,status,subStatus,fromDateTime,toDateTime,tName);//[SELECT Id, Name,Depot__r.Name,Territory_Manager__r.Name,Territory__r.Name,Approval_Submission_Date_Time__c  FROM Free_Sample_Management__c WHERE Id IN :targetObjectIds AND Territory__r.Name Like : tName AND Approval_Submission_Date_Time__c >=:fromDateTime AND Approval_Submission_Date_Time__c <=: toDateTime AND SalesOrg__r.Sales_Org_Code__c=:saleorgs AND Status__c=:status AND Sub_Status__c=:subStatus];
                   }else{
                       String tName='%'+territoryName+'%';
                       // Edited by Sandeep Vishwakarma - SKI 27-01-2023 AF Material Requisition
                       fsmList=InvokeGetProcessMetaData.getMethod6(targetObjectIds,saleorgs,status,subStatus,tName);//[SELECT Id, Name,Depot__r.Name,Territory_Manager__r.Name,Territory__r.Name,Approval_Submission_Date_Time__c  FROM Free_Sample_Management__c WHERE Id IN :targetObjectIds AND Territory__r.Name Like : tName AND SalesOrg__r.Sales_Org_Code__c=:saleorgs AND Status__c=:status AND Sub_Status__c=:subStatus];
                   }
                   
               }else if(fromDateTime!=null && toDateTime!=null){
                // Edited by Sandeep Vishwakarma - SKI 27-01-2023 AF Material Requisition
                fsmList=InvokeGetProcessMetaData.getMethod7(targetObjectIds,saleorgs,status,subStatus,fromDateTime,toDateTime);//[SELECT Id, Name,Depot__r.Name,Territory_Manager__r.Name,Territory__r.Name,Approval_Submission_Date_Time__c  FROM Free_Sample_Management__c WHERE Id IN :targetObjectIds AND Approval_Submission_Date_Time__c >=:fromDateTime AND Approval_Submission_Date_Time__c <=: toDateTime AND SalesOrg__r.Sales_Org_Code__c=:saleorgs AND Status__c=:status AND Sub_Status__c=:subStatus];
            
               }else{
                // Edited by Sandeep Vishwakarma - SKI 27-01-2023 AF Material Requisition
                   fsmList=InvokeGetProcessMetaData.getMethod8(targetObjectIds,saleorgs,status,subStatus);//[SELECT Id, Name,Depot__r.Name,Territory_Manager__r.Name,Territory__r.Name,Approval_Submission_Date_Time__c FROM Free_Sample_Management__c WHERE Id IN :targetObjectIds AND SalesOrg__r.Sales_Org_Code__c=:salesOrgCode AND Status__c=:status AND Sub_Status__c=:subStatus ORDER BY LastModifiedDate ASC];
               }
               for (Free_Sample_Management__c fsm : fsmList) {
                   FSMWrapper fsmwrap=new FSMWrapper();
                   fsmwrap.reqId=fsm.Id;
                   fsmwrap.reqName=fsm.Name;
                   fsmwrap.depot=fsm.Depot__r.Name;
                   fsmwrap.territory=fsm.Territory__r.Name;
                   fsmwrap.tmName=fsm.Territory_Manager__r.Name;
                   fsmwrap.submittedDate=fsm.Approval_Submission_Date_Time__c.format('d MMMM,  yyyy');
                   if(fscpListMap.containsKey(fsm.Id) && fspListMap.containsKey(fsm.Id)){
                       System.debug('fsm.Id : '+fsm.Id);
                       fsmwrap.fspWrapList= getViewDetails(fsm.Id,fscpListMap.get(fsm.Id),fspListMap.get(fsm.Id));
                   }
                   allRecords.put(fsm.Id,fsmwrap);
               }
              
           }
       }
       return allRecords;
   }

   private static String getObjectAvailableFieldsString(String objectName) {
       Set<String> availableFieldsSet = new Set<String>();

       Map<String, Schema.SObjectField> curObjectFieldDescribes = OBJECT_NAME_TO_DESCRIBE.get(objectName);
       for (String curField : FIELD_NAMES) {
           if (curObjectFieldDescribes.containsKey(curField)) {
               availableFieldsSet.add(curField);
           }
       }

       return String.join(new List<String>(availableFieldsSet), ', ');
   }

   public static ProcessData getRowData(String actorId, String fieldNames, String objectTypeName, String mode,String recordName,String depotName,String territoryName,String From_Date,String To_Date) {
       List<ProcessInstanceData> results = new List<ProcessInstanceData>();
       Set<Id> actors = getRelatedActors(actorId);
       List<ProcessInstanceWorkitem> curWorkItems = [SELECT Id, ActorId, ProcessInstanceId, OriginalActorId, CreatedById FROM ProcessInstanceWorkitem WHERE ActorId IN :actors ORDER BY CreatedDate DESC];
       Map<String, SObject> workItemsToProcessInstanceMap = getSObjectMap(curWorkItems, 'ProcessInstanceId');
       Map<Id, ProcessInstance> processInstanceMap = new Map<Id, ProcessInstance>([SELECT Id, ProcessDefinitionId, TargetObjectId, LastActorId, CreatedById, CreatedDate FROM ProcessInstance WHERE Id IN :workItemsToProcessInstanceMap.keySet() ORDER BY CreatedDate DESC]);
       Set<String> targetObjectIds = getSObjectSet(processInstanceMap.values(), 'TargetObjectId');
       Set<String> processDefinitionIds = getSObjectSet(processInstanceMap.values(), 'ProcessDefinitionId');
       Set<String> createdByIds = getSObjectSet(processInstanceMap.values(), 'CreatedById');
       createdByIds.addAll(getSObjectSet(processInstanceMap.values(), 'LastActorId'));
       createdByIds.addAll(getSObjectSet(curWorkItems, 'CreatedById'));
       Map<Id, ProcessDefinition> processDefinitionMap = new Map<Id, ProcessDefinition>([SELECT Id, TableEnumOrId FROM ProcessDefinition WHERE Id IN:processDefinitionIds]);
       Set<String> objectTypes = getSObjectSet(processDefinitionMap.values(), 'TableEnumOrId');
       setObjectDescribes(objectTypes);
       setSObjectNameFields(objectTypes);
       setFieldNames(fieldNames, objectTypes);
       getRequiredFieldDescribes(objectTypes);
       Map<Id, User> userMap = new Map<Id, User>([SELECT Id,Name,Username FROM User WHERE Id IN:createdByIds]);
       Map<String, FSMWrapper> recordData = getRecordData(targetObjectIds, objectTypes, objectTypeName,recordName,depotName,territoryName,From_Date,To_Date);

       if (recordData != null && !recordData.isEmpty()) {
           for (ProcessInstanceWorkitem curWorkItem : curWorkItems) {
               ProcessInstance curProcessInstance = processInstanceMap.get(curWorkItem.ProcessInstanceId);
               ProcessDefinition curProcessDefinition = processDefinitionMap.get(curProcessInstance.ProcessDefinitionId);
               User createdByUser = userMap.get(curProcessInstance.CreatedById);
               User lastActorUser = userMap.get(curWorkItem.CreatedById);
               FSMWrapper curSObject = recordData.get(curProcessInstance.TargetObjectId);

               if (curProcessInstance != null && curSObject != null) {
                   results.add(new ProcessInstanceData(curSObject, curWorkItem, curProcessInstance, curProcessDefinition, createdByUser, lastActorUser));
               }
           }
       }

       return (new ProcessData(results));
   }

   @AuraEnabled
   public static void process(String reassignActorId, String action, List<String> workItemIds, String comment) {

       Map<Id, ProcessInstanceWorkitem> pisMap = new Map<Id, ProcessInstanceWorkitem>([SELECT Id, ActorId,ProcessInstance.TargetObjectId FROM ProcessInstanceWorkitem WHERE Id IN :workItemIds]);

       List<ProcessInstanceWorkitem> pisToReassign = new List<ProcessInstanceWorkitem>();
       for (String curWorkItemId : workItemIds) {
           if (action == 'Reassign') {
               ProcessInstanceWorkitem pi = pisMap.get(curWorkItemId);
               pi.ActorId = reassignActorId;
               pisToReassign.add(pi);
           } else {
               Approval.ProcessWorkitemRequest pwr = new Approval.ProcessWorkitemRequest();
               if (!String.isBlank(comment)) {
                   pwr.setComments(comment);
               }
               //TODO: manage multistep approval processes, where we need to assign next approver manually
//                pwr.setNextApproverIds(new List<Id>{
//                        reassignActorId
//                });




              // System.debug(' Id :'+ProcessInstanceWorkitem.ProcessInstanceId);
               pwr.setWorkitemId(curWorkItemId);
               pwr.setAction(action);
               Approval.ProcessResult pr = Approval.process(pwr);
                   
               /*if(action=='Approve'){
                   List<Free_Sample_Management__c> fsmList=updateApprovalStatus(pisMap.get(curWorkItemId).ProcessInstanceId);
                   update fsmList;
                   System.debug('fsmList 2:'+fsmList);
               }*/
               

           }
       }
       if (!pisToReassign.isEmpty()) {
           update pisToReassign;
       }
   }

   /*public static List<Free_Sample_Management__c> updateApprovalStatus(String processInstanceId){
       System.debug('processInstanceId :'+processInstanceId);
       List<Free_Sample_Management__c> fsmList=new List<Free_Sample_Management__c>();
       List<ProcessInstance> pIList=[SELECT id,TargetObjectId from ProcessInstance where Id=:processInstanceId];
       System.debug('pIList :'+pIList);
       String status='';
       Id userId = userinfo.getUserId();
       User userDetails =[SELECT Id, Name, Email, Profile.Name, UserRole.Name FROM User where Id=:userId ];
       System.debug('userDetails.UserRole.Name :'+userDetails.UserRole.Name);
       if(userDetails.UserRole.Name.contains('FMM')){
           status='Pending';
       }else if(userDetails.UserRole.Name.contains('Regional Manager')){
           status='Pending';
       }else if(userDetails.UserRole.Name.contains('Zonal Head') || userDetails.UserRole.Name.contains('ZMM') || userDetails.UserRole.Name.contains('Channel Deployment Manager') || userDetails.UserRole.Name.contains('Zonal Commercial Head')){
           status='Pending';
       }else if(userDetails.UserRole.Name.contains('Marketing HO')){
           status='Pending from Depot';
       }
       for(ProcessInstance piObj:pIList){
           Free_Sample_Management__c fsm=new Free_Sample_Management__c();
           fsm.Id=piObj.TargetObjectId;
           fsm.Status__c=status;
           fsmList.add(fsm);
       }
       System.debug('fsmList 1 :'+fsmList);
       return fsmList;
   }*/
   private static void setObjectDescribes(Set<String> objectNames) {
       Map<String, Map<String, Schema.SObjectField>> result = new Map<String, Map<String, Schema.SObjectField>>();
       //loop is faster then Schema.describeSObjects(types) and Schema.getGlobalDescribe()
       for (String objectName : objectNames) {
           SObjectType r = ((SObject) (Type.forName('Schema.' + objectName).newInstance())).getSObjectType();
           result.put(objectName, r.getDescribe().fields.getMap());
       }
       OBJECT_NAME_TO_DESCRIBE = result;
   }

   //Fields to be examined as Name fields
   private static void setSObjectNameFields(Set<String> objectTypes) {
       Map<String, String> results = new Map<String, String>();
       List<String> fieldsToExamine = new List<String>{
               'Name', 'Id'
       };
       /*for (String sObjectName : objectTypes) {
           if (OBJECT_NAME_TO_DESCRIBE.containsKey(sObjectName)) {
               for (String curField : fieldsToExamine) {
                   if (!results.containsKey(sObjectName) && OBJECT_NAME_TO_DESCRIBE.get(sObjectName).containsKey(curField)) {
                       results.put(sObjectName, curField);
                       //results.put('Free_Sample_Management__c','Name');
       
                   }
               }
           }
       }*/
       results.put('Free_Sample_Management__c','Name');
       OBJECT_NAME_TO_NAME_FIELD = results;
       System.debug('OBJECT_NAME_TO_NAME_FIELD:::' + OBJECT_NAME_TO_NAME_FIELD);
   }

   private static void getRequiredFieldDescribes(Set<String> objectTypes) {
   Map<String, List<Schema.DescribeFieldResult>> results = new Map<String, List<Schema.DescribeFieldResult>>();

       for (String sObjectName : objectTypes) {
           if (!results.containsKey(sObjectName)) {
               results.put(sObjectName, new List<Schema.DescribeFieldResult>());
           }
           if (OBJECT_NAME_TO_DESCRIBE.containsKey(sObjectName)) {
               Map<String, Schema.SObjectField> curObjectFieldDescribes = OBJECT_NAME_TO_DESCRIBE.get(sObjectName);
               for (String curField : FIELD_NAMES) {
                   if (curObjectFieldDescribes.containsKey(curField)) {
                       results.get(sObjectName).add(curObjectFieldDescribes.get(curField).getDescribe());
                   }
               }
           }
       }
       REQUIRED_FIELDS_DESCRIBES = results;
   }

   public class ProcessData {
       List<ProcessInstanceData> processInstanceData;
       Map<String, List<Schema.DescribeFieldResult>> fieldDescribes;
       public ProcessData(List<ProcessInstanceData> processInstanceData) {
           this.processInstanceData = processInstanceData;
           this.fieldDescribes = REQUIRED_FIELDS_DESCRIBES;
       }
   }

   public class ProcessInstanceData {
       FSMWrapper sObj;
       ProcessInstanceWorkitem workItem;
       ProcessInstance processInstance;
       ProcessDefinition processDefinition;
       User createdByUser;
       User lastActorUser;
       String nameField;

       public ProcessInstanceData(FSMWrapper sObj, ProcessInstanceWorkitem workItem, ProcessInstance processInstance, ProcessDefinition processDefinition, User createdByUser, User lastActorUser) {
           this.sObj = sObj;
           this.workItem = workItem;
           this.processInstance = processInstance;
           this.processDefinition = processDefinition;
           this.createdByUser = createdByUser;
           this.lastActorUser = lastActorUser;
           this.nameField = OBJECT_NAME_TO_NAME_FIELD.get(processDefinition.TableEnumOrId);
       }
   }

   public static List<String> getSalesOrgByProfile(){
    String profileName = [Select id,Name,Profile.Name from User where id=:Userinfo.getUserId()].Profile.Name;
    if(profileName=='Marketing HO Swal' || profileName.equalsIgnoreCase('Regional/Zonal Manager SWAL') || profileName.equalsIgnoreCase('FMM USER SWAL')  || Test.isRunningTest()){//INC0473277 - SFDC - Material Requisition:FSP-04198 - Added "Regional/Zonal Manager SWAL" and added - FMM USER SWAL
        return new List<String>{'1210'};
    }else{
        return new List<String>{'1410'};
    }
   }

   public class FSMWrapper{
       @AuraEnabled  public String reqId;
       @AuraEnabled  public String reqName;
       @AuraEnabled  public String depot;
       @AuraEnabled  public String territory;
       @AuraEnabled  public String tmName;
       @AuraEnabled  public String submittedDate;
       @AuraEnabled  public List<FSPWrapper> fspWrapList;

       FSMWrapper(){
           reqId='';
           reqName='';
           depot='';
           territory='';
           submittedDate='';
           fspWrapList=new List<FSPWrapper>();
       }
   }
   public class FSPWrapper{
       @AuraEnabled  public String productName;
       @AuraEnabled  public Double acre;
       @AuraEnabled  public Double size;
       @AuraEnabled  public Double demo;
       @AuraEnabled  public Double demoQtyGMML;
       @AuraEnabled  public Double demoMaterialValue;
       @AuraEnabled  public List<String> targetCopList;
       @AuraEnabled  public List<String> targetPestList;

       FSPWrapper(){
           productName='';
           acre=0;
           size=0;
           demo=0;
           demoQtyGMML=0;
           demoMaterialValue=0;
           targetCopList=new List<String>();
           targetPestList=new List<String>();
       }

   }
}