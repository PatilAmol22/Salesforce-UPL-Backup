public without sharing class DynamicLookUpController {
    
    @AuraEnabled
    public static List < sObject > fetchLookUpValues(String SearchField , String SearchFieldSecond,String searchKeyWord,string queryFields ,String ObjectName , String filter) {
        system.debug('searchKeyWord-->' + searchKeyWord);
        MAP<String,sObject> mapsObj = new MAP<String,sObject>();
        String salesOrgCode ='';
        String searchKey = '%' + searchKeyWord + '%';
        
        List < sObject > returnList = new List < sObject > ();
        
        // Create a Dynamic SOQL Query For Fetch Record List with LIMIT 5 
        
        String sQuery = '';
        if(SearchFieldSecond ==''){
            sQuery =  'select id, Name,Sales_Org_Code__c'+queryFields+' from ' +ObjectName + ' where ('+SearchField+' LIKE: searchKey ) ' +filter;    
        }else{
            sQuery =  'select id, Name,Sales_Org_Code__c'+queryFields+' from ' +ObjectName + ' where ('+SearchField+' LIKE: searchKey  OR '+ SearchFieldSecond+' LIKE: searchKey) ' +filter;    
        }
        
        
        system.debug('sQuery-->' + sQuery); // nik...
        system.debug('filter-->' + filter); // nik...
        system.debug('queryFields-->' + queryFields); // nik...
        system.debug('ObjectName-->' + ObjectName); // nik...
        
        List < sObject > lstOfRecords = Database.query(sQuery);
        
        
        system.debug('lstOfRecords size -->' + lstOfRecords); // nik...
        //system.debug('lstOfRecords -->' + lstOfRecords); // nik...
        
        for (sObject obj: lstOfRecords) {
            if(ObjectName == 'PriceBookMaster__c'){
                PriceBookMaster__c objNm = (PriceBookMaster__c) obj;
                
                // changes made by vishal UPL-CR131  changes from 2520 to 2481
                if(objNm.Sales_Org_Code__c == '2510' || objNm.Sales_Org_Code__c == '2481' || objNm.Sales_Org_Code__c == '2541'){
                    objNm.SKUCode__r.SKU_Description__c = objNm.SKUCode__r.SKU_Description__c;
                }else{
                    
                    //objNm.SKUCode__r.SKU_Description__c = objNm.SKUCode__r.SKU_Code__c +'-'+objNm.SKUCode__r.SKU_Description__c;
                    objNm.SKUCode__r.SKU_Description__c = objNm.SKUCode__r.SKU_Description__c +'-'+objNm.SKUCode__r.SKU_Code__c;
                }
                obj = (sObject) objNm;
                
            }
            else if(ObjectName == 'SKU__c'){
                SKU__c objNm = (SKU__c) obj;
                
                //objNm.SKU_Description__c = objNm.SKU_Code__c +'-'+objNm.SKU_Description__c;
                objNm.SKU_Description__c = objNm.SKU_Description__c +'-'+objNm.SKU_Code__c;
                obj = (sObject) objNm;
            }else if(ObjectName == 'PriceBook_Indonesia_Discount__c'){
                PriceBook_Indonesia_Discount__c objNm = (PriceBook_Indonesia_Discount__c) obj;
                System.debug('objNm ');
                //objNm.SKUCode__r.SKU_Description__c = objNm.SKUCode__r.SKU_Code__c +'-'+objNm.SKUCode__r.SKU_Description__c;
                objNm.SKUCode__r.SKU_Description__c = objNm.SKUCode__r.SKU_Description__c +'-'+objNm.SKUCode__r.SKU_Code__c;
                obj = (sObject) objNm;
                salesOrgCode = objNm.Sales_Org_Code__c;                
                mapsObj.put(objNm.SKUCode__c,objNm);
            }
            
            if(salesOrgCode=='2941'){
                System.debug('inside poland code');
                returnList = mapsObj.values();
            }else{
                System.debug('Other  code');
                returnList.add(obj); 
            }
            
        }   //end of for Loop
        
        //system.debug('DynamicLookUpController returnList-->' + returnList); // nik...
        System.debug('salesOrgCode  out  '+salesOrgCode); 
        return returnList;
    }
    
}