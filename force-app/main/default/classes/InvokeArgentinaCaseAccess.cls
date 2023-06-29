/*
Created On : 22nd May 2018
Developer: Ketan Khatri
Description: The Class which will be called by Case Assignment final process builder to share the case with users in case access
Last Stable backup : InvokeArgentinnCaseAccess_V2.2
*/
global without sharing class InvokeArgentinaCaseAccess {
    
    
    //Method Invoked by Process builder
    @InvocableMethod
    global static void caseAccessMethod(List<String> CaseID){ 
        try{
            List<CaseTeamMember> ctmList = new List<CaseTeamMember>();
            List<CaseTeamMember> ctmNotifyList = new List<CaseTeamMember>();
            CaseTeamRole ctr = [SELECT Name, Id, AccessLevel FROM CaseTeamRole WHERE NAME = 'Access Team' LIMIT 1];
            System.debug('CaseTeamRole==> '+ctr);
            List<String> caseAccessUsers = new List<String>();
            List<String> caseNotifyUsers = new List<String>();
            List<User> listOfUsers = new List<User>();
            List<User> listOfNotifyUsers = new List<User>();
            String caseAccessFromMatrix='';
            String caseNotifyFromMatrix='';
            List<Case_Matrix__c>  caseMatrixList = new List<Case_Matrix__c>();
            List<Case_Matrix__c>  caseMatrixNotifyList = new List<Case_Matrix__c>();
            Case caseObj= new Case(); 
            
            //Querying the parent case record
            caseObj = [SELECT Id,Type,Status,AccountId FROM Case WHERE Id=:CaseID[0] LIMIT 1];
            
            Account Acc = [SELECT Id,Name,Sales_Org__c,Sales_Org_Code__c FROM Account WHERE Id=:caseObj.AccountId LIMIT 1];
            System.debug('CaseObj==> '+caseObj);
            
            //Querying the entire argentina Case Matrix
            caseMatrixList = [Select Id,Case_Type_Argentina__c,Case_Owner__c,Case_Access__c,Case_Access_Argentina__c,Sales_Org__c,Sales_Org__r.Sales_Org_Code__c 
                              FROM  Case_Matrix__c
                              WHERE Sales_Org__c=:Acc.Sales_Org__c AND Case_Access_Argentina__c!= null ];
            
            if(caseMatrixList.size()>0){
                
                for(Case_Matrix__c cm : caseMatrixList){
                    //If case type matches wih the case type of case matrix
                    if(cm.Case_Type_Argentina__c == caseObj.Type && caseObj.Status =='Approved' && cm.Sales_Org__c==Acc.Sales_Org__c){
                        // caseAccessUsers.add(cm.Case_Access__c);
                        
                        caseAccessFromMatrix = cm.Case_Access_Argentina__c;
                        System.debug('Inside If ==> '+caseAccessFromMatrix);
                    }
                }
                
                if(caseAccessFromMatrix.contains(';')){
                    caseAccessUsers =   caseAccessFromMatrix.split(';');
                    listOfUsers = [SELECT ID,Name FROM User WHERE Name in :caseAccessUsers];
                    System.debug('List of queried users based on the Case Matrix==> '+listOfUsers);
                }
                
                else{
                    listOfUsers = [SELECT ID,Name FROM User WHERE Name =: caseAccessFromMatrix];
                    System.debug('List of queried users based on the Case Matrix==> '+listOfUsers);
                }
                
                for(User u : listOfUsers){
                    CaseTeamMember ctm	= new CaseTeamMember();
                    ctm.ParentId = caseObj.Id;
                    ctm.MemberId = u.Id;
                    ctm.TeamRoleId = ctr.Id;
                    ctmList.add(ctm);
                    //caseObj.Description = listOfUsers[0].Id+' '+listOfUsers[1].Id;			//caseAccessUsers[0]+' '+caseAccessUsers[1];
                    //  update caseObj;
                }
                
                if(ctmList.size()>0){
                    insert ctmList;
                     System.debug('After Insert==> '+ctmList);
                    
                    // Sending email to case team logic
                   Id CId = ctmList[0].ParentId;
                    
                    Case csObj = [SELECT Id,Type,Status,Description,CaseNumber,AccountId FROM Case WHERE Id=:CId LIMIT 1];
                    List<Id> userIdList = new List<Id>();
                    List<User> userList = new List<User>();
                    List<String> userEmailList = new List<String>();
                    
                    for(CaseTeamMember ctm :ctmList){
                        userIdList.add(ctm.MemberId);
                        // CId = ctm.ParentId;
                    }
                    userList = [SELECT Email, Id FROM User WHERE ID in :userIdList];
                    for(user u : userList){
                        userEmailList.add(u.Email);
                    }
                    Id templateId;
                    templateId = [select id, name from EmailTemplate where developername = : 'Argentina_Case_Raise'].Id;
                     System.debug('user iD Step 1 ---- '+userIdList[0]);
                     System.debug('templateId Step 2 ---- '+templateId);
                     System.debug('CId Step 3 ---- '+CId);
                    
                    for(ID uid:userIdList)
                    {
                    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                   // email.setToAddresses(userEmailList);
                //    email.setSubject('Esta es una notificación para informarle acerca de un nuevo caso ingresado y publicado. No necesitas hacer nada.');
                    email.setTemplateId(templateId);
                   System.debug('Step 4 ---- ');
                    email.setTargetObjectId(uid);
                   // email.setTreatTargetObjectAsRecipient(false);
                    email.setWhatId(CId);
                  //  System.debug('csObj.Id==> '+csObj.Id);
                   // email.setHtmlBody('<p>Estimados,</p><p>Esta es una notificación para informarle acerca de un nuevo caso ingresado y publicado. No necesitas hacer nada.</p><br/><b> Numero de caso&nbsp;:&nbsp;'+csObj.CaseNumber+'</b><br/><b>Tipo de caso&nbsp; &nbsp; &nbsp; &nbsp;:&nbsp;'+csObj.Type+'</b><br/><br/><c:CaseTemplateComponent caseid=caseid="\'+5000k000009Tmhq+\'"/> <br><a href="https://upl--upltest.cs57.my.salesforce.com/'+csObj.Id+'">Ve mas detalles</a></br><br/><br/>Gracias!<br/><br/><br/><img src="https://upl--upltest.cs57.my.salesforce.com/servlet/servlet.ImageServer?id=0150k000000E4A7&oid=00D0k000000Cq7D" alt="Company Logo" height="64" width="170" align="left"/><br/><br/><br/><br/>');
                  System.debug('Step 5 ---- ');  
                    email.setSaveAsActivity(false);
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
                     // Sending email to case team logic end
                  System.debug('Step 6 ---- ');
                    }
                }
            }
			      /********* Case Owner Notify Patch ******/
                 caseMatrixNotifyList = [Select Id,Case_Type_Argentina__c,Case_Owner__c,Case_Access__c,Case_Access_Argentina__c,
                              Case_Owner_Notify__c,Sales_Org__c,Sales_Org__r.Sales_Org_Code__c 
                              FROM  Case_Matrix__c
                              WHERE Sales_Org__c=:Acc.Sales_Org__c AND Case_Owner_Notify__c!= null ];
                
				if(caseMatrixNotifyList.size()>0){
					 for(Case_Matrix__c cm : caseMatrixNotifyList){
                    if((caseObj.Type=='Payments' ||caseObj.Type=='Action requested by customer: Technical talk with producers' 
                        ||caseObj.Type=='Action requested by customer: Internal technical training' 
                        ||caseObj.Type=='Action requested by customer: Demo Plot' 
                        ||caseObj.Type=='Action requested by customer: Identification of the distributor'
                        ||caseObj.Type=='Action requested by customer: Joint day' 
                        ||caseObj.Type=='Action requested by customer: Product development incentive')
                       && caseObj.Status =='Approved' && cm.Sales_Org__c==Acc.Sales_Org__c && cm.Case_Type_Argentina__c == caseObj.Type){
                           
                           // caseAccessUsers.add(cm.Case_Access__c);
                           
                           caseNotifyFromMatrix = cm.Case_Owner_Notify__c;
                           System.debug('Inside If ==> '+caseNotifyFromMatrix);
                       }
					 }
                    /********* Case Owner Notify Patch ******/
                
                if(caseNotifyFromMatrix.contains(';')){
                    caseNotifyUsers =   caseNotifyFromMatrix.split(';');
                    listOfNotifyUsers = [SELECT ID,Name FROM User WHERE Name in :caseNotifyUsers];
                    System.debug('List of queried users based on the Case Matrix==> '+listOfNotifyUsers);
                }
                
                else{
                    listOfNotifyUsers = [SELECT ID,Name FROM User WHERE Name =: caseNotifyFromMatrix];
                    System.debug('List of queried users based on the Case Matrix==> '+listOfNotifyUsers);
                }
                
                Id NotifyTemplateId;
                NotifyTemplateId = [select id, name from EmailTemplate where developername = : 'Argentina_Case_Assign'].Id;
                
                for(User u:listOfNotifyUsers)
                {
                    CaseTeamMember ctm	= new CaseTeamMember();
                    ctm.ParentId = caseObj.Id;
                    ctm.MemberId = u.Id;
                    ctm.TeamRoleId = ctr.Id;
                    ctmNotifyList.add(ctm);
                    
                    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                    
                    email.setTemplateId(NotifyTemplateId);
                    System.debug('NotifyTemplateId');
                    email.setTargetObjectId(u.Id);
                     System.debug('u.Id---> '+u.Id);  
                    email.setWhatId(caseObj.Id);
                    System.debug('caseObj.Id ----> '+caseObj.Id);
                   
                    email.setSaveAsActivity(false);
                    
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
                    
                    
                }
                    if(ctmNotifyList.size()>0){
                        insert ctmNotifyList;                        
                    }
                /********* Case Owner Notify Patch ******/
				}
			
        }
        catch(Exception e){
            System.debug('Error Message --> '+e.getMessage());
            System.debug('Error Message --> '+e.getLineNumber());
        }
    }
}