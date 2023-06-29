/*
* Name: Mapping
* Created On: 08 Mar 2017
* Author: Bhavik Devdhar (bhavik.devdhar@skinternational.com)
* Description: Utility class for methods to Serialize/Deserialize Schema Definition used by Schema Mapping
*/
public class Mapping{
    public Integer position {get;set;}
    public String fieldType {get;set;}
    public String label {get;set;}
    public String api {get;set;}
    public String column {get;set;}
    
    public Mapping(){
        position = 0;
        fieldType = '';
        label = '';
        api = '';
        column = '';
    }
    
    public static Schema_Definition__c getSchemaDefinition(String schemaName, String fileName){
        /*String theQuery = 'SELECT ' + joinList(getAccessibleFields(), ', ') + 
            ' FROM ' + getObjectType() + 
            ' WHERE Id = :qid';
        return(Database.query(theQuery));  */
        
        String theQuery = 'SELECT Id, Mapping_Definition__c FROM Schema_Definition__c WHERE Name = :schemaName AND File_Name__c =:fileName';
        
        List<Schema_Definition__c> mappingList = (Database.query(theQuery));

        if(!mappingList.isEmpty()){
            return mappingList[0];
        }
        else{
            return null;
        }
    }
    
    public static List<Mapping> deSerialize(String schemaName, String fileName){
        if(getSchemaDefinition(schemaName,fileName)!=null){
            String definition = getSchemaDefinition(schemaName,fileName).Mapping_Definition__c;
            return (List<Mapping>)System.JSON.deserialize(definition, List<Mapping>.class);
        }
        else{
            return null;
        }
    }
    
    public static Map<Integer,Mapping> deSerializedMap(String schemaName, String fileName){
        Map<Integer,Mapping> posApiMap = new Map<Integer,Mapping>();
        
        if(deSerialize(schemaName,fileName)!=null){
            List<Mapping> mapList = deSerialize(schemaName,fileName);

            for(Mapping mapObj:mapList){
                posApiMap.put(mapObj.position,mapObj);
            }
        }
        return posApiMap;
    }
}