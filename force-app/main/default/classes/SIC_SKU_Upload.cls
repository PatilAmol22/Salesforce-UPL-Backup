public without sharing class SIC_SKU_Upload {
    @AuraEnabled
    public static String getDocument()
    {
        List<document> DocumentList = new List<document>(); 
        String Templatefile = '/servlet/servlet.FileDownload?file=';
        String newTemplatefile;
        List<String> newstr;
        DocumentList = [select Id,Name from document where Name = 'SIC SKU Upload Template'];
        if(DocumentList.size()>0){
            newTemplatefile = Templatefile+DocumentList[0].Id;
            /*List<SKU__c> towritefromSKUtoDOC = [SELECT SKU_Code__c,Available_For_SIC__c from SKU__c 
                                                WHERE Sales_Org_Code__c = '5191' 
                                                AND Available_For_SIC__c = true LIMIT 5];
            for(Document temp:DocumentList){
               /newstr = temp.Body.toString().split('\n');
            }*/
        }
        /*for(String temp:newstr){
            system.debug('-->'+temp);
        }*/
        return newTemplatefile;  
        
    }
    
    @AuraEnabled
    public static string passFile(String File){
        try{
            String[] csvFileLines = file.split('\n');
            List<string> inputvalues = new list<string>();
            UPL_Settings__c salesOrgDetails = UPL_Settings__c.getInstance();
            String SalesOrg = salesOrgDetails.SalesOrg__c;
            Integer paddingsku= integer.valueof(salesOrgDetails.PaddingSKU__c);
            map<string,string> SetSKUCodes = new map<string,string>();
            map<string,SKU__c> mapSKUCode = new map<string,SKU__c>();
            map<string,SKU__c> skuUpdate = new map<string,SKU__c>();
            for (Integer j=1;j<csvFileLines.size();j++){                
                inputvalues = csvFileLines[j].split(',');
                system.debug('inputvalues=='+inputvalues);
                system.debug('inputvalues=='+inputvalues[0]);
                system.debug('inputvalues=='+inputvalues[1]);
                SetSKUCodes.put(inputvalues[0].leftPad(paddingsku,'0'),inputvalues[1]);
            }          
            system.debug('SetSKUCodes=='+SetSKUCodes);
            system.debug('SetSKUCodes=='+SetSKUCodes.keySet());
            for (SKU__c U: [select id,SKU_Code__c,Available_For_SIC__c from SKU__c where SKU_Code__c in :SetSKUCodes.keySet() and Sales_Org_Code__c = '5191']){
                mapSKUCode.put(u.SKU_Code__c,u);
            }
            //system.debug('mapSKUCode->'+mapSKUCode);

                

            for (Integer j=1;j<csvFileLines.size();j++){
                inputvalues = csvFileLines[j].split(',');
                if( !string.isblank(inputvalues[0]) && !string.isblank(inputvalues[1]) ){
                    system.debug('inputvalues[0]=='+inputvalues[0]);
                    system.debug('inputvalues[1]=='+inputvalues[1]);
                    if( mapSKUCode.containsKey( inputvalues[0].leftPad(paddingsku,'0') ) ){
                        if(mapSKUCode.get(inputvalues[0].leftPad(paddingsku,'0')).Available_For_SIC__c != inputvalues[1].containsIgnoreCase('true') ){
                            SKU__c obj = new SKU__C();
                            obj.Id = mapSKUCode.get( inputvalues[0].leftPad(paddingsku,'0') ).Id;
                            obj.Available_For_SIC__c = inputvalues[1].containsIgnoreCase('true');
                            skuUpdate.put( inputvalues[0],obj );
                        }
                    }
                }
            }

            if( skuUpdate.size()>0 )
                UPDATE skuUpdate.values();
            
            return 'success';    
        }
        catch(Exception e){
            system.debug('Exception '+ e.getMessage() + e.getLineNumber()) ;
            return 'NoSuccess';
        }
        
    }
    
}