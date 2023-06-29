public class SICSalesRepSKUEntry {
   @AuraEnabled
    public static String getDocument()
    {
        List<document> DocumentList = new List<document>(); 
        String Templatefile = '/servlet/servlet.FileDownload?file=';
        String newTemplatefile;
        DocumentList = [select Name from document where Name = 'SICSalesRepSKUException'];
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
            Integer paddingsku= integer.valueof(salesOrgDetails.PaddingSKU__c);
            
            //Account Mapping
            set<string> SetAccSAPCodes = new set<string>();
            map<string,Account> mapSAPCodeAcc = new map<string,Account>();
           
            for (Integer j=1;j<csvFileLines.size();j++){                
                inputvalues = csvFileLines[j].split(';');
                SetAccSAPCodes.add(inputvalues[0].leftPad(paddingsapcode,'0'));                
            }            
            for (Account U: [select id,SAP_Code__c from account where SAP_Code__c in :SetAccSAPCodes]){
                mapSAPCodeAcc.put(u.SAP_Code__c,u);
            }
            //User Mapping
            set<string> SetTMCodes = new set<string>();
            map<string,User> mapTMCodeUser = new map<string,User>();
            List<SIC_Exception__c> liSICException = new List<SIC_Exception__c>(); 
            for (Integer j=1;j<csvFileLines.size();j++){                
                inputvalues = csvFileLines[j].split(';');
                SetTMCodes.add(inputvalues[1]);                
            }            
            for (User U: [select id,TM_Code__c from User where TM_Code__c in :SetTMCodes]){
                mapTMCodeUser.put(u.TM_Code__c,u);
            }
            
            //SKU Mapping
             set<string> SetSKUCodes = new set<string>();
            map<string,SKU__c> mapSKUCode = new map<string,SKU__c>();
           
            for (Integer j=1;j<csvFileLines.size();j++){                
                inputvalues = csvFileLines[j].split(';');
                SetSKUCodes.add(inputvalues[2].leftPad(paddingsku,'0'));                
            }            
            for (SKU__c U: [select id,SKU_Code__c from SKU__c where SKU_Code__c in :SetSKUCodes and Sales_Org_Code__c = '5191']){
                mapSKUCode.put(u.SKU_Code__c,u);
            }
            
            for (Integer j=1;j<csvFileLines.size();j++){
                
                inputvalues = csvFileLines[j].split(';');
                
                if(!string.isblank(inputvalues[0]) && 
                   !string.isblank(inputvalues[1]) && 
                   !string.isblank(inputvalues[2]) &&
                  !string.isblank(inputvalues[3]) &&
                  !string.isblank(inputvalues[4])){
                       
                       SIC_Exception__c SICE = new SIC_Exception__c();
                       SICE.Name = 'SKU Exception';
                       SICE.Customer__c = mapSAPCodeAcc.get(inputvalues[0].leftPad(paddingsapcode,'0')).Id;
                       SICE.Sales_Rep__c = mapTMCodeUser.get(inputvalues[1]).Id;
                       SICE.SKU__c = mapSKUCode.get(inputvalues[2].leftPad(paddingsku,'0')).Id;
                       SICE.Month__c = inputvalues[3].leftPad(2,'0');
                       SICE.Year__c = decimal.valueOf(inputvalues[4]);
                       SICE.Combination_Key__c = inputvalues[0].leftPad(paddingsapcode,'0')+inputvalues[1]+inputvalues[2].leftPad(paddingsku,'0')+inputvalues[3].leftPad(2,'0')+inputvalues[4];
                       liSICException.add(SICE); 
                       
                   }
            }     
            upsert liSICException Combination_Key__c;
            
            system.debug('liSICException '+liSICException);
            
            return 'success';    
        }
        catch(Exception e){
            system.debug('Exception '+ e.getMessage() + e.getLineNumber()) ;
            return 'NoSuccess';
        }
        
    }
}