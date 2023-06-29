/*
* Name: Schema Mapping Controller
* Created On: 08 Mar 2017
* Author: Bhavik Devdhar (bhavik.devdhar@skinternational.com)
* Description: Controller Class is used for Mapping Schema with CSV Columns for Dynamic CSV Parsing
*/
public class SchemaMappingController {
    public List<Mapping> mappingList {get;set;}
    public Set<String> fieldNamesSet{get;set;}
    public Set<String> objectSet{get;set;}
    
    public Map<Integer,Mapping> mappingMap {get;set;}
    
    public String header {get;set;}
    public String modalHeader {get;set;}
    public String message {get;set;}
    public String selectedObject {get;set;}
    public String fileName {get;set;}
    
    public boolean showTable{get;set;}
    public boolean showObjectSelection{get;set;}
    
    public Map<String,String> apiMap;
    public Map<String,String> typeMap;
    public Map <String,Schema.SobjectType> schemaMap;
    public Schema_Definition__c sdobj;
    
    public SchemaMappingController() {
        sdobj = new Schema_Definition__c();
        
        mappingList = new List<Mapping>();
        mappingMap = new Map<Integer, Mapping>();
        
        fieldNamesSet = new Set<String>();
        objectSet = new Set<String>();
        apiMap = new Map<String, String>();
        typeMap = new Map<String, String>();
        header = '';
        modalHeader = '';
        message = '';
        selectedObject = '';
        fileName = '';
        
        showTable = false;
        showObjectSelection = false;
        
        getObject();
        
    }
    
    public void getObject(){
        schemaMap=Schema.getGlobalDescribe();
        List<Schema.SobjectType> gd = schemaMap.values();
        
        for(Schema.SobjectType s:ProcessInstance.TargetObjectId.getDescribe().getReferenceTo()){//gd){
            //Excluding custom setting objects
            if(!s.getDescribe().CustomSetting){
                objectSet.add(s.getDescribe().getName());
                System.debug('getLocalName: '+s.getDescribe().getLocalName().toLowerCase());
                System.debug('getLabel: '+s.getDescribe().getLabel());
                //System.debug('getName: '+s.getDescribe().getName());
            }
        }
    }
    
    public void setObject(){
        showTable = true;
        System.debug('selectedObject:'+selectedObject);
        if(selectedObject!='' && selectedObject!=null){
            //Map <String,Schema.SobjectType> schemaMap=Schema.getGlobalDescribe();
            if(schemaMap.containsKey(selectedObject)){
                Schema.Describesobjectresult dsr = schemaMap.get(selectedObject).getDescribe();
                Map<String, Schema.SObjectField> schemaFieldMap = dsr.fields.getMap();
                //Map<String, Schema.SObjectField> schemaFieldMap = Schema.SObjectType.BusinessDashboardData__c.fields.getMap();
                
                for(String fieldName : schemaFieldMap.keySet()){
                    if ((fieldName != 'Name') && (schemaFieldMap.get(fieldName).getDescribe().isAccessible()) && (schemaFieldMap.get(fieldName).getDescribe().isUpdateable())) {
                        //System.debug('fieldName: '+fieldName);
                        fieldNamesSet.add(schemaFieldMap.get(fieldName).getDescribe().getLabel());
                        apiMap.put(schemaFieldMap.get(fieldName).getDescribe().getLabel(), fieldName);
                        typeMap.put(schemaFieldMap.get(fieldName).getDescribe().getLabel(), String.valueOf(schemaFieldMap.get(fieldName).getDescribe().getType()));
                    }
                }
                if(Mapping.deSerialize(selectedObject,fileName)!=null){
                    mappingList = Mapping.deSerialize(selectedObject,fileName);
                    //mappingList.remove(mappingList.size() - 1);
                }
                for(Mapping mapObj:mappingList){
                    mappingMap.put(mapObj.position,mapObj);
                }
            }
        }
    }
    
    public void getApi(){
        for(Mapping obj:mappingList){
            if(apiMap.containsKey(obj.label)){
                obj.api = apiMap.get(obj.label);
                obj.fieldType = typeMap.get(obj.label);
                //fieldNamesSet.remove(obj.label);
            }
        }
    }
    
    //Mehtod for Importing CSV
    public void importCSVFile(){
        mappingList.clear();
        mappingMap.clear();
        
        if(String.isNotBlank(fileName)){
            if(fileName.contains('_'))
                fileName = fileName.substringBefore('_');
            
            //showTable = true;
            
            List<String> csvRecordData=new List<String>();
            csvRecordData = header.normalizeSpace().replaceAll('"', '').split(',');
            System.debug('header: '+header.normalizeSpace());
            System.debug('mappingMap.keyset: '+mappingMap.keyset());

            for(Integer i=0;i<csvRecordData.size();i++){
                Mapping obj;
                if(mappingMap.containsKey(i)){
                    obj = mappingMap.get(i); //= new Mapping();
                    fieldNamesSet.remove(obj.label);
                }
                else{
                    obj = new Mapping();
                    obj.column = csvRecordData[i];
                    obj.position = i;
                }
                
                mappingList.add(obj);
                //mappingMap.put(obj.position, obj);
            }
        }
        /*Mapping obj = new Mapping();
        obj.column = 'Row No';
        obj.api = 'Row_No__c';
        obj.label = 'Row No';
        obj.position = mappingList.size();
        obj.fieldType = 'DOUBLE';
        mappingList.add(obj);
        mappingMap.put(obj.position, obj);*/
    }
    
    public void autoMap(){
        for(Mapping obj:mappingList){
            if(apiMap.containsKey(obj.column)){
                obj.label = obj.column;
                obj.api = apiMap.get(obj.column);
                obj.fieldType = typeMap.get(obj.column);
            }
        }
        modalHeader = 'Info';
        message = 'Auto Map Complete';
    }
    
    public void saveMapping(){
        if(String.isNotBlank(selectedObject) && String.isNotBlank(fileName)){
            
            if(Mapping.getSchemaDefinition(selectedObject,fileName)!=null){
                sdObj.Id = Mapping.getSchemaDefinition(selectedObject,fileName).Id;
            }
            
            sdObj.Name = selectedObject;
            sdObj.Mapping_Definition__c = JSON.serializePretty(mappingList);
            sdObj.File_Name__c = fileName;
            upsert sdObj;
            
            updateSettings();
            
            modalHeader = 'Info';
            message = 'Mapping for ' +selectedObject+ ' saved';
        }
        else{
            modalHeader = 'Error';
            message = 'Select a valid object & file before saving mapping';
        }
    }
    
    //Method to redirect to Record
    public PageReference redirectFunction(){
        PageReference pg;
        
        if(sdObj!=null && String.isNotBlank(sdObj.Id)){
            pg = new PageReference('/'+sdObj.Id);
            System.debug('sdObj.Id: '+sdObj.Id);
        }
        else{
            pg = new PageReference('/apex/SchemaMapping');
        }
        System.debug('pg: '+pg);
        return pg;
    }
    
    public void updateSettings(){
        if(String.isNotBlank(fileName)){
            
            Map<String, SchemaObjectMapping__c  > settingsMap = new Map<String, SchemaObjectMapping__c  >();
            for(SchemaObjectMapping__c   smObj:[Select Name, Filename__c, Object__c FROM SchemaObjectMapping__c  ]){
                settingsMap.put(smObj.Filename__c, smObj);
            }
            SchemaObjectMapping__c smObj;
            if(settingsMap.containsKey(fileName)){
                smObj = settingsMap.get(fileName);
            }
            else{
                smObj = new SchemaObjectMapping__c();
                
                Integer length = filename.length();
                
                if(length > 35 )
                    smObj.Name = filename.substring(0,34);
                else if(length < 35)
                    smObj.Name = filename.substring(0,length);
                
                smObj.Filename__c = fileName;
            }
            smObj.Object__c = selectedObject;
            upsert smObj;
        }
    }
    
    public void deleteMapping(){

        if(Mapping.getSchemaDefinition(selectedObject,fileName)!=null){

            sdObj = Mapping.getSchemaDefinition(selectedObject,fileName);
            delete sdObj;
            
            selectedObject = '';
            header = '';

            mappingList.clear();
            mappingMap.clear();
            
            modalHeader = 'Info';
            message = 'Mapping for '+selectedObject+' is deleted successfully';
        }
        else{
            modalHeader = 'Error';
            message = 'Mapping for '+selectedObject+' does not exist';
        }
    }
}