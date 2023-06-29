public class SICSalesRepEntry {
    @AuraEnabled
    public static String getDocument()
    {
        List<document> DocumentList = new List<document>(); 
        String Templatefile = '/servlet/servlet.FileDownload?file=';
        String newTemplatefile;
        DocumentList = [select Name from document where Name = 'SICSalesRepException'];
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
            set<string> SetTMCodes = new set<string>();
            map<string,User> mapTMCodeUser = new map<string,User>();
            List<SIC_Exception__c> liSICException = new List<SIC_Exception__c>(); 
            for (Integer j=1;j<csvFileLines.size();j++){                
                inputvalues = csvFileLines[j].split(';');
                SetTMCodes.add(inputvalues[0]);                
            }            
            for (User U: [select id,TM_Code__c from User where TM_Code__c in :SetTMCodes]){
                mapTMCodeUser.put(u.Id,u);
            }
            list<SIC_User_Info__c> liSIC = new list<SIC_User_Info__c>();
            for (SIC_User_Info__c SICUI: [select id from SIC_User_Info__c 
                                          where Sales_User__c in :mapTMCodeUser.keyset() and Year__c = :system.today().year()]){
                SICUI.Exception__c = true;
                liSIC.add(SICUI);
            } 
           update liSIC;
            
            return 'success';    
        }
        catch(Exception e){
            system.debug('Exception '+ e.getMessage() + e.getLineNumber()) ;
            return 'NoSuccess';
        }
        
    }
    
}