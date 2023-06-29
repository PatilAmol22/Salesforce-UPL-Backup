public without sharing class SICCustomerUpload {
    @AuraEnabled
    public static String getDocument()
    {
        List<document> DocumentList = new List<document>(); 
        String Templatefile = '/servlet/servlet.FileDownload?file=';
        String newTemplatefile;
        DocumentList = [select Name from document where Name = 'SICCustomer'];
        if(DocumentList.size()>0){
            newTemplatefile = Templatefile+DocumentList[0].Id;
            system.debug('checktemplate '+newTemplatefile);
        }
        return newTemplatefile;  
        
    }
    
    @AuraEnabled
    public static string passFile(String File){
        try{
            system.debug('Passfile');
            String[] csvFileLines = file.split('\n');
            List<string> inputvalues = new list<string>();
            UPL_Settings__c salesOrgDetails = UPL_Settings__c.getInstance();
            String SalesOrg = salesOrgDetails.SalesOrg__c;
            Integer visibledate = integer.valueof(salesOrgDetails.Visibility_Date__c); 
            Integer paddingsapcode= integer.valueof(salesOrgDetails.PaddingSAPCode__c);
            
            List<SIC_Customer__c> liSICCustomer = new List<SIC_Customer__c>(); 
            
            
            for (Integer j=1;j<csvFileLines.size();j++){
                
                inputvalues = csvFileLines[j].split(';');
                
                if(!string.isblank(inputvalues[0]) && 
                   !string.isblank(inputvalues[1]) && 
                   !string.isblank(inputvalues[2])){
                       SIC_Customer__c SICC = new SIC_Customer__c();
                       system.debug('Input year '+ inputvalues[0].substring(1, inputvalues[0].length()));
                       //SICC.Year__c = inputvalues[0];
                       SICC.Year__c =inputvalues[0].substring(1, inputvalues[0].length());
                       SICC.Customer_SAP_Code__c = inputvalues[1].leftPad(paddingsapcode,'0');
                       system.debug('Input '+inputvalues[2]);
                       if(inputvalues[4].contains('Add')){//== 'Add'
                           SICC.Active__c = true; 
                       }
                       else{
                           SICC.Active__c = false;          
                       }           
                       SICC.Region__c = inputvalues[2];        
                       SICC.Sales_Rep_UGDN__c = inputvalues[3];               
                       SICC.Combination_Key__c = inputvalues[0]+inputvalues[1].leftPad(paddingsapcode,'0');
                       liSICCustomer.add(SICC);
                       //mapSICCustomer.put(inputvalues[1],SICC);
                   }
            }     
            upsert liSICCustomer Combination_Key__c;    
            return 'success';    
        }
        catch(Exception e){
            system.debug('Exception '+ e.getMessage() + e.getLineNumber()) ;
            return 'NoSuccess';
        }
        
    }
    
    
    
    
    
    
}