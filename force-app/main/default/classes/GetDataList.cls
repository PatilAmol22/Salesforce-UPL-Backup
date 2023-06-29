public class GetDataList {
    @AuraEnabled(cacheable=true)
    public static  List<sObject> getlistdata(string objname,string fieldname){
        system.debug('@@@data@@@'+objname+'####'+fieldname);
        String WhereClause;
        String soql;
        if(fieldname=='SKU__r.SKU_Description__c'){
         WhereClause='(Depot__r.Country__c = \'Europe\' And Depot__r.name In (\'UK10\',\'UK12\') And ((Sales_Org__r.Country_Code__c IN (\'IE\')  And SKU__r.Distribution_Channel__r.Distribution_Channel_Code__c IN (\'40\') ) OR (Sales_Org__r.Country_Code__c IN (\'UK\')  And SKU__r.Distribution_Channel__r.Distribution_Channel_Code__c IN (\'20\') )) And SKU__r.Division__r.Division_Code__c IN (\'10\')) ORDER BY SKU__r.SKU_Description__c';   
        }
        else if(fieldname=='Depot_Code__c'){
          WhereClause='(Depot__r.Country__c = \'Europe\' AND RecordType.Name=\'Storage Location\' And Depot__r.name IN (\'UK10\',\'UK12\')) ORDER BY Name';    
        }
         else if(fieldname=='SKU__r.SKU_Code__c'){
            WhereClause='(Depot__r.Country__c = \'Europe\' And Depot__r.name In (\'UK10\',\'UK12\') And ((Sales_Org__r.Country_Code__c IN (\'IE\')  And SKU__r.Distribution_Channel__r.Distribution_Channel_Code__c IN (\'40\') ) OR (Sales_Org__r.Country_Code__c IN (\'UK\')  And SKU__r.Distribution_Channel__r.Distribution_Channel_Code__c IN (\'20\') )) And SKU__r.Division__r.Division_Code__c IN (\'10\')) ORDER BY SKU__r.SKU_Code__c';    
        }
         else if(fieldname=='SKU__r.Brand_Name__c'){
             WhereClause='(Depot__r.Country__c = \'Europe\'And Depot__r.name In (\'UK10\',\'UK12\') And ((Sales_Org__r.Country_Code__c IN (\'IE\')  And SKU__r.Distribution_Channel__r.Distribution_Channel_Code__c IN (\'40\') ) OR (Sales_Org__r.Country_Code__c IN (\'UK\')  And SKU__r.Distribution_Channel__r.Distribution_Channel_Code__c IN (\'20\') )) And SKU__r.Division__r.Division_Code__c IN (\'10\')) ORDER BY SKU__r.SKU_Code__c';   
        }
        
        soql = 'SELECT Name, Id, ' +
            fieldname +
            ' FROM '  + String.escapeSingleQuotes(objname) +
            ' WHERE ' + WhereClause;
        
        System.debug('soql inside AutoComplete--> '+soql);
        return Database.query(soql);
    }
}