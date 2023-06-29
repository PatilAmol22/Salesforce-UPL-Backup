public class CaseTriggerHandler {
    public Id distributorRecordTypeId;
    public Id indodisRecordTypeId;
    public Id caseRecordTypeId;
    public Set<String> emailSet;
    public Set<String> productNameSet;
    public Map<String,Id> emailAccountMap;
    public Map<String,ID> productNameMap;
    public List<Case_Line_Item__c> insertCaseItemList;
    public Map<String,Account> AccountMap;
    public Map<String,Sales_Org__c> SalesOrgMap;
    public List<Account> accountList{get;set;}
    public List<Sales_Org__c> salesOrgList{get;set;}
    public List<case> updatecaseList;
    public set<String> accountIdset{set;get;} 
    public set<String> salesorgIdset{set;get;} 
    public string distributorId {get;set;}
    public List<CaseTeamMember> ctmList;
    public String EmailForCaseCreate;
    
    
    public CaseTriggerHandler(){
        ctmList= new List<CaseTeamMember>();
        EmailForCaseCreate='';
        distributorId='';
        //distributorRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        //caseRecordTypeId = Schema.SObjectType.case.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        List<RecordType> recordTypeList = [Select Id From RecordType where SobjectType = 'Case' and DeveloperName = 'Distributor'];
        if(!recordTypeList.isEmpty()){
            caseRecordTypeId = recordTypeList[0].Id;
        }
        //indodisRecordTypeId = Schema.SObjectType.case.getRecordTypeInfosByName().get('Indonesia Distributor').getRecordTypeId();
        emailSet = new Set<String>();
        productNameSet = new Set<String>();
        emailAccountMap = new Map<String,Id>();
        productNameMap = new Map<String,ID>();
        AccountMap=new Map<String,Account>();
        SalesOrgMap =new Map<String,Sales_Org__c>();
        insertCaseItemList = new List<Case_Line_Item__c>();
        accountList = new List<Account>();
        accountIdset = new set<String>();
        salesorgIdset = new set<String>();      
        salesOrgList = new List<Sales_Org__c>();
        updatecaseList = new List<case>();
    }
    
    //Logic to create new Account on the basis of Email ID, if no Account with the Supplied Email exists on SFDC
    public void createAccountfromTask(List<Case> caseList){
        for(Case caseObj:caseList){
            if(caseObj.RecordTypeId != caseRecordTypeId || caseObj.RecordTypeId != indodisRecordTypeId ){
                //Add Emails to emailSet if Not Blank
                if(String.isNotBlank(caseObj.SuppliedEmail)){
                    emailSet.add(caseObj.SuppliedEmail);
                }
            }
        }
        //Query accounts with Matching email AND RecordType = 'Distributor'
        for(Account accObj:[Select Id, Email__c From Account Where Email__c IN: emailSet AND RecordTypeId=:distributorRecordTypeId]){
            emailAccountMap.put(accObj.Email__c, accObj.Id);
        }
        for(Case caseObj:caseList){
            if(caseObj.RecordTypeId != caseRecordTypeId || caseObj.RecordTypeId != indodisRecordTypeId ){
                if(String.isNotBlank(caseObj.SuppliedEmail)){   
                    if(!emailAccountMap.containsKey(caseObj.SuppliedEmail)){
                        Account newAccount = new Account();
                        String fullName = caseObj.SuppliedName;
                        newAccount.Name = fullName;
                        newAccount.First_Name__c = fullName.substring(0,fullName.indexOf(' '));
                        newAccount.Last_Name__c = fullName.substring(fullName.indexOf(' ')).trim();
                        newAccount.Email__c = caseObj.SuppliedEmail;
                        newAccount.RecordTypeId = distributorRecordTypeId; 
                        insert newAccount;
                        System.debug('newAccount: '+newAccount);
                        
                        caseObj.AccountId = newAccount.id;
                    }
                }
            }
        }
    }
    
    public void addCaseLineItem(List<Case> caseList){
        
        System.debug('-----Method Called----'+caseList);
        Set<Id> caseIdSet = new Set<Id>();
        List<Product2> ProductList =[Select ID, Name FROM Product2] ;       
        for(Product2 obj:ProductList){
            productNameMap.put(obj.Name, obj.Id);
        }
        
        for(Case caseObj:caseList){
            if(caseObj.RecordTypeId != caseRecordTypeId || caseObj.RecordTypeId != indodisRecordTypeId ){
                caseIdSet.add(caseObj.id);
            }
        }
        System.debug('------method-----'+caseIdSet);
        
        if(caseIdSet.size()>0){
            delete [Select id from Case_Line_Item__c where Case__c IN:caseIdSet];
        }
        
        for(Case caseObj:caseList){
            if(caseObj.RecordTypeId != caseRecordTypeId || caseObj.RecordTypeId != indodisRecordTypeId ){// other than distributor record type
                if(String.isNotBlank(caseObj.Products_Recommended__c)){
                    String[] tmpString = caseObj.Products_Recommended__c.split(';');
                    for(String strObj:tmpString){
                        
                        if(productNameMap.containsKey(strObj)){
                            Case_Line_Item__c cliObj = new Case_Line_Item__c();
                            cliObj.Case__c = caseObj.id;
                            cliObj.Product__c = productNameMap.get(strObj);
                            insertCaseItemList.add(cliObj);
                        }
                    }
                }
            }
        }
        if(insertCaseItemList.size()>0){
            insert insertCaseItemList;
        }
    }
    
    public void addCropCode(List<Case> caseList){
        System.debug('addCropCode - Called');
        Map<String,ID> cropNameMap = new Map<String,ID>();
        
        for(Crop__c obj:[Select ID, Name FROM Crop__c ]){
            cropNameMap.put(obj.Name, obj.Id);
        }
        System.debug('cropNameMap: '+cropNameMap);
        for(Case caseObj:caseList){
            if(caseObj.RecordTypeId != caseRecordTypeId || caseObj.RecordTypeId != indodisRecordTypeId ){
                if(cropNameMap.containsKey(caseObj.Crop_pick__c)){
                    caseObj.Crop__c = cropNameMap.get(caseObj.Crop_pick__c);
                }
            }
        }
    }

}