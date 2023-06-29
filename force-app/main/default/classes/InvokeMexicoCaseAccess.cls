global without sharing class InvokeMexicoCaseAccess {
    @InvocableMethod
    global static void caseAccessMethod(List<String> CaseID){
        String caseAccessFromMatrix='';
        List<String> caseAccessUsers = new List<String>();
        List<User> listOfUsers = new List<User>();
        List<CaseTeamMember> ctmList = new List<CaseTeamMember>();
        
        CaseTeamRole ctr = [SELECT Name, Id, AccessLevel FROM CaseTeamRole WHERE NAME = 'Access Team' LIMIT 1];
        
        
        System.debug('Id is ' + CaseID);
        //Querying the parent case record
        Case caseObj= new Case(); 
        
        caseObj = [SELECT Id,Type,Status,AccountId FROM Case WHERE Id=:CaseID[0] LIMIT 1];
        String caseType = caseObj.Type;
        
        Account Acc = [SELECT Id,Name,Sales_Org__c,Sales_Org_Code__c FROM Account WHERE Id=:caseObj.AccountId LIMIT 1];
        System.debug('CaseObj==> '+caseObj);
        
        List<Case_Matrix__c>  caseMatrixList = new List<Case_Matrix__c>();
        //Querying the entire argentina Case Matrix
        System.debug('@Sales_Org__c is ' + Acc.Sales_Org__c);
        System.debug('@caseType is ' + caseType);
        
        caseMatrixList = [Select Id,Case_Type_Argentina__c,Case_Owner__c,Case_Access__c,Case_Access_Argentina__c,Sales_Org__c,Sales_Org__r.Sales_Org_Code__c 
                          FROM  Case_Matrix__c
                          WHERE Sales_Org__c=:Acc.Sales_Org__c AND Case_Access_Argentina__c!= null AND Case_Type_Argentina__c =:caseType];
        System.debug('@@caseMatrixList is ' + caseMatrixList);
        System.debug('@@caseMatrixList is ' + caseMatrixList.size());
        if(caseMatrixList.size()>0){
            for(Case_Matrix__c cm : caseMatrixList){
                //If case type matches wih the case type of case matrix
                if(cm.Case_Type_Argentina__c == caseObj.Type && (caseObj.Status =='Approved' || caseObj.Status =='Auto Approved' ) && cm.Sales_Org__c==Acc.Sales_Org__c){
                    // caseAccessUsers.add(cm.Case_Access__c);
                    
                    caseAccessFromMatrix = cm.Case_Access_Argentina__c;
                    System.debug('Inside If ==> '+caseAccessFromMatrix);  
                }
            }
            if(caseAccessFromMatrix.contains(';')){
                caseAccessUsers =   caseAccessFromMatrix.split(';');
                System.debug('@@caseAccessUsers If ==> '+caseAccessUsers);
                listOfUsers = [SELECT ID,Name FROM User WHERE Name in :caseAccessUsers AND IsActive=True];
                System.debug(' List of queried users based on the Case Matrix==> '+listOfUsers);
            }
            
            else{
                listOfUsers = [SELECT ID,Name FROM User WHERE Name =: caseAccessFromMatrix AND IsActive=True];
                System.debug(' List of queried users based on the Case Matrix==> '+listOfUsers);
            }
            for(User u : listOfUsers){
                
                CaseTeamMember ctm  = new CaseTeamMember();
                ctm.ParentId = caseObj.Id;
                ctm.MemberId = u.Id;
                ctm.TeamRoleId = ctr.Id;
                ctmList.add(ctm);
                //caseObj.Description = listOfUsers[0].Id+' '+listOfUsers[1].Id;      //caseAccessUsers[0]+' '+caseAccessUsers[1];
                //  update caseObj;  
            }
            if(ctmList.size()>0){
                    insert ctmList;
                     System.debug('After Insert==> '+ctmList);
            }
            
            
        }            
    }
    
    
}