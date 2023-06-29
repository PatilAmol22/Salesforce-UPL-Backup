/*Apex class to show customize Item to Apptoval for Brazil
Created on 30 Jan 2023
Created by Shubham Grazitti
Used in itemtoApprovalTable LWC
*/
public class GetProcessInstanceeData {
    private static Map<String, Map<String, Schema.SObjectField>> OBJECT_NAME_TO_DESCRIBE;
    private static Map<String, String> OBJECT_NAME_TO_NAME_FIELD;
    private static Map<String, List<Schema.DescribeFieldResult>> REQUIRED_FIELDS_DESCRIBES;
    private static Set<String> FIELD_NAMES = new Set<String>{
        'Id'
            }; 
                
                @AuraEnabled
                public static string getContactIds (id Recordids) {
                    string sobjectname;
                    If(Recordids != null){
                        sobjectname = Recordids.getSObjectType().getDescribe().getName();
                    }
                    system.debug('dasd'+sobjectname);
                    
                    return sobjectname;        
                } 
    
    @AuraEnabled
    public static string getCaseList (String objectTypeName ) {
        system.debug('objectTypeName'+objectTypeName);
        string allstring;
        if(objectTypeName != null ){
            String fieldSetName;
            List<string> allFieldsName =new List<string>();  
            Map<String, Schema.SObjectType> GlobalDescribeMap = Schema.getGlobalDescribe(); 
            Schema.SObjectType SObjectTypeObj = GlobalDescribeMap.get(objectTypeName);
            Schema.DescribeSObjectResult DescribeSObjectResultObj = SObjectTypeObj.getDescribe();
            Map<String, Schema.FieldSet> canMap = DescribeSObjectResultObj.FieldSets.getMap();
            If(canMap.containsKey('GetFieldsForItemsToApprove')){
                fieldSetName = 'GetFieldsForItemsToApprove';
            }
            Schema.SObjectType sObj = Schema.getGlobalDescribe().get(objectTypeName);
            if(fieldSetName != null){
                for(Schema.FieldSetMember fieldMember : sObj.getDescribe().fieldSets.getMap().get(fieldSetName).getFields()){
                    allFieldsName.add(String.valueOf(fieldMember.getSObjectField()));
                }
            }
            allstring = string.join(allFieldsName,',');
        }
        system.debug('allstring'+allstring);
        return allstring;  
        
    }  
    
    @AuraEnabled
    public static String getProcessItemData(String actorId, String recordId, String fieldNames, String objectName, String mode) {
        system.debug('111actorId'+actorId);
        system.debug('111recordId'+recordId);
        system.debug('111fieldNames'+fieldNames);
        system.debug('111objectName'+objectName);
        system.debug('111mode'+mode);
        return JSON.serialize(getRowData(actorId,recordId, fieldNames, objectName, mode));
    }
    
    public static Map<String, SObject> getSObjectMap(List<SObject> sObjects, String keyFieldName) {
        Map<String, SObject> results = new Map<String, SObject>();
        for (SObject so : sObjects) {
            system.debug('@@@Test The Object');
            results.put((String) so.get(keyFieldName), so);
        }
        return results;
    }
    
    public static Set<String> getSObjectSet(List<SObject> sObjects, String keyFieldName) {
        Set<String> results = new Set<String>();
        for (SObject so : sObjects) {
            system.debug('@@@@@@74'+(String) so.get(keyFieldName)); 
            results.add((String) so.get(keyFieldName));
        }
        return results;
    }
    
    public static void setFieldNames(String fieldNames, Set<String> objectTypes) {
        
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
        }
    }
    
    public static Map<String, SObject> getRecordData(Set<String> targetObjectIds, Set<String> objectTypes, String objectTypeName) {
        Map<String, SObject> allRecords = new Map<String, SObject>();
        for (String curObjectType : objectTypes) {
            system.debug('curObjectType@@@@@@@@@@@@@'+curObjectType);
            if (objectTypeName == null || objectTypeName == curObjectType) {
                String myQuery = 'SELECT ' + getObjectAvailableFieldsString(curObjectType) + ' FROM ' + curObjectType + ' WHERE Id IN :targetObjectIds';
                System.debug('myQuery:::' + myQuery);
                allRecords.putAll(new Map<String, SObject>(Database.query(myQuery)));  
                
            }
            
        }
        system.debug('ll'+allRecords);
        return allRecords;
    }
    
    public static String getObjectAvailableFieldsString(String objectName) {
        Set<String> availableFieldsSet = new Set<String>();
        
        Map<String, Schema.SObjectField> curObjectFieldDescribes = OBJECT_NAME_TO_DESCRIBE.get(objectName);
        for (String curField : FIELD_NAMES) {
            if (curObjectFieldDescribes.containsKey(curField)) {
                availableFieldsSet.add(curField);
            }
        }
        if(objectName=='Sales_Order__c'){
            availableFieldsSet.add('Approval_Reason__c');
        }
        
        return String.join(new List<String>(availableFieldsSet), ', ');
    }
    
    public static ProcessData getRowData(String actorId, String recordId, String fieldNames, String objectTypeName, String mode) {
        List<ProcessInstanceData> results = new List<ProcessInstanceData>();
        Set<Id> actors = new Set<id>(); // Check for deligate Thing
        actors.add(actorId);
        system.debug('actors'+actors);
        List<ProcessInstanceWorkitem> curWorkItems = [SELECT Id, ActorId, ProcessInstanceId, OriginalActorId, CreatedById FROM ProcessInstanceWorkitem WHERE ActorId IN :actors];
        Map<String, SObject> workItemsToProcessInstanceMap = getSObjectMap(curWorkItems, 'ProcessInstanceId');
        System.debug('curWorkItems:::' + workItemsToProcessInstanceMap);
        Map<Id, ProcessInstance> processInstanceMap;
        
        system.debug('vvvvvvv'+recordId);
        if(recordId!=null && recordId!=''){
            
            processInstanceMap = new Map<Id, ProcessInstance>([SELECT Id, ProcessDefinitionId, TargetObjectId, LastActorId, CreatedById, CreatedDate FROM ProcessInstance WHERE Id IN :workItemsToProcessInstanceMap.keySet() and TargetObjectId=:recordId]);
            system.debug('vvvvvvv'+processInstanceMap);
        }
        else{
            system.debug('@@@@@@144'+workItemsToProcessInstanceMap.keySet());
             system.debug('@@@@@@145'+workItemsToProcessInstanceMap.size());
            processInstanceMap = new Map<Id, ProcessInstance>([SELECT Id, ProcessDefinitionId, TargetObjectId, LastActorId, CreatedById, CreatedDate FROM ProcessInstance WHERE Id IN :workItemsToProcessInstanceMap.keySet()]);
        }
        System.debug('curWorkItems:::' + processInstanceMap.size());
        Set<String> targetObjectIds = getSObjectSet(processInstanceMap.values(), 'TargetObjectId');
        Set<String> processDefinitionIds = getSObjectSet(processInstanceMap.values(), 'ProcessDefinitionId');
        Set<String> createdByIds = getSObjectSet(processInstanceMap.values(), 'CreatedById');
        createdByIds.addAll(getSObjectSet(processInstanceMap.values(), 'LastActorId'));
        createdByIds.addAll(getSObjectSet(curWorkItems, 'CreatedById'));
        createdByIds.addAll(getSObjectSet(curWorkItems, 'ActorId'));
        Map<Id, ProcessDefinition> processDefinitionMap = new Map<Id, ProcessDefinition>([SELECT Id, TableEnumOrId FROM ProcessDefinition WHERE Id IN:processDefinitionIds]);
      system.debug('@@@@@processDefinitionMap.1567--->'+processDefinitionMap);
        system.debug('@@@@@processDefinitionMap.1566--->'+processDefinitionIds);
        system.debug('@@@@@processDefinitionMap.values--->'+processDefinitionIds.size());
        Set<String> objectTypes = getSObjectSet(processDefinitionMap.values(), 'TableEnumOrId');
        system.debug('@@@@@objectTypes.values160--->'+objectTypes);
        system.debug('@@@@@objectTypes.values--->'+objectTypes.size());
        setObjectDescribes(objectTypes);
        setSObjectNameFields(objectTypes);
        setFieldNames(fieldNames, objectTypes);
        getRequiredFieldDescribes(objectTypes);
        Map<Id, User> userMap = new Map<Id, User>([SELECT Id,Name,Username FROM User WHERE Id IN:createdByIds]);
        Map<String, SObject> recordData = getRecordData(targetObjectIds, objectTypes, objectTypeName);
        system.debug('@@@@recordData===='+recordData);
        system.debug('@@@@curWorkItems===='+curWorkItems.size());
        if (recordData != null && !recordData.isEmpty()) {
            for (ProcessInstanceWorkitem curWorkItem : curWorkItems) {
                ProcessInstance curProcessInstance = processInstanceMap.get(curWorkItem.ProcessInstanceId);
                if(curProcessInstance!=null){
                    ProcessDefinition curProcessDefinition = processDefinitionMap.get(curProcessInstance.ProcessDefinitionId);
                    User createdByUser = userMap.get(curProcessInstance.CreatedById);
                    User lastActorUser = userMap.get(curWorkItem.ActorId);
                    SObject curSObject = recordData.get(curProcessInstance.TargetObjectId);
                    
                    if (curProcessInstance != null && curSObject != null) {
                        system.debug('curSObject@@@@'+curSObject);
                        Id objID=curProcessInstance.TargetObjectId;
                        system.debug('objID@@@@'+objID);
                        results.add(new ProcessInstanceData(curSObject, curWorkItem, curProcessInstance, curProcessDefinition, createdByUser, lastActorUser,objID.getSObjectType().getDescribe().getName()));
                    }  
                }
            }
        }
        system.debug('@@@@@@+++++'+(new ProcessData(results)));
        return (new ProcessData(results));
    }
    
    @AuraEnabled
    public static void process(String reassignActorId, String action, List<String> workItemIds, String comment) {
        system.debug('!!!!!!!action'+action);
        if(action=='Aprovar'){
            action='Approve';
        }
        else if(action=='Rejeitar'){
            action='Reject';
        }
        else if(action=='Reatribuir'){
            action='Reassign';
        }
        Map<Id, ProcessInstanceWorkitem> pisMap = new Map<Id, ProcessInstanceWorkitem>([SELECT Id, ActorId FROM ProcessInstanceWorkitem WHERE Id IN :workItemIds]);
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
                pwr.setWorkitemId(curWorkItemId);
                pwr.setAction(action);
                Approval.ProcessResult pr = Approval.process(pwr);
            }
        }
        if (!pisToReassign.isEmpty()) {
            update pisToReassign;
        }
    }
    
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
            'Name', 'CaseNumber', 'Subject', 'Id'
                };
                    for (String sObjectName : objectTypes) {
                        if (OBJECT_NAME_TO_DESCRIBE.containsKey(sObjectName)) {
                            for (String curField : fieldsToExamine) {
                                if (!results.containsKey(sObjectName) && OBJECT_NAME_TO_DESCRIBE.get(sObjectName).containsKey(curField)) {
                                    results.put(sObjectName, curField);
                                }
                            }
                        }
                    }
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
        SObject sObj;
        ProcessInstanceWorkitem workItem;
        ProcessInstance processInstance;
        ProcessDefinition processDefinition;
        User createdByUser;
        User lastActorUser;
        String nameField;
        String mainField;
        public ProcessInstanceData(SObject sObj, ProcessInstanceWorkitem workItem, ProcessInstance processInstance, ProcessDefinition processDefinition, User createdByUser, User lastActorUser,String ObjectApi) {
            this.sObj = sObj;
            this.workItem = workItem;
            this.processInstance = processInstance;
            this.processDefinition = processDefinition;
            this.createdByUser = createdByUser;
            this.lastActorUser = lastActorUser;
            this.nameField = (String)Schema.getGlobalDescribe().get(ObjectApi).getDescribe().getLabel();
            this.mainField = OBJECT_NAME_TO_NAME_FIELD.get(processDefinition.TableEnumOrId);
            system.debug('@@@'+this.nameField);
        }
    }
}