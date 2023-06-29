/**************************************************************************************************
* Name             : Grz_CaseCommentRCMController                                                      
* Test Class       : Grz_CaseCommentRCMControllerTest
* Created Date     : 13-02-2023                                                                        
* Project/JIRA     : APPS-4742                                                                       
* Created By       : Mohit Garg (Grazitti)                                                                        
* Last Modified By : Mohit Garg (Grazitti) 20-02-2023                                                                       
**************************************************************************************************/

public class Grz_CaseCommentRCMController {
    public static void sendEmailOnCaseComment(List<CaseComment> caseCommNewMap){
        List<Id> caseCreateduserId = new List<Id>();
        List<Id> caseIds=new List<Id>();
        for(CaseComment cc:caseCommNewMap){
            if(cc.IsPublished == True){                
                if(String.valueof(cc.ParentId).startsWith('500')){
                    caseIds.add(cc.ParentId);
                }           
            }             
        }
        Map<Id,Case> createdCaseMap=new Map<Id,Case>([Select Id,Record_Type__c, CaseOwnerName__c,CaseNumber, catesub__c, sub_category__c, CreatedDate,AccountId,SalesOrg__c,CreatedById,CaseOwner__c,Owner.Email,recordTypeId,Type,Status,Subject,Description,Closeddate,(SELECT Id, ParentId, IsPublished, CommentBody, CreatedById, CreatedDate, createdby.name FROM CaseComments where IsPublished=true order by LastModifiedDate desc limit 5) from Case where Id IN :caseIds]);
        Map<Id,List<CaseComment>> caseCommentMap=new Map<Id,List<CaseComment>>();        
        
        
        for(Case c:createdCaseMap.values()){ 
            caseCreateduserId.add(c.CreatedById); 
            caseCommentMap.put(c.Id,c.CaseComments);
        }
        List<String> lstEmail = new List<String>();
        String objPPCEmail;
        String strCCEmail;
        List<Partner_Portal_Configuration__c> lstPPC1 = [Select Id,Name,Description__c, Label__c from Partner_Portal_Configuration__c where Label__c = 'CaseConfigRCM'];
        for(Partner_Portal_Configuration__c ppc:lstPPC1){
            if(ppc.Name == 'RCM Emails'){
                objPPCEmail = ppc.Description__c;
            }
            if(ppc.Name == 'RCM CC Email')
                strCCEmail = ppc.Description__c;
        }
        List <Messaging.Singleemailmessage> emailListFull = new List <Messaging.Singleemailmessage>();
        List<EmailTemplate> emailtemp = [SELECT Id,body,HtmlValue,subject FROM EmailTemplate WHERE DeveloperName = 'CaseCommentRCMEmailTemplate' Limit 1];    
        String StrOrg = System.Label.Grz_OrgWideAddressName;
        OrgWideEmailAddress owa = [select id, DisplayName, Address from OrgWideEmailAddress where displayname =: StrOrg];
        String fromAdressId = owa.id;
        String baseURL='';       
        List<Network> myCommunity = [SELECT Id FROM Network WHERE Name = 'UPL Partner Portal'];
        if(!myCommunity.isEmpty()){
            baseURL=String.valueOf(Network.getLoginUrl(myCommunity[0].id));
            baseURL=baseURL.split('/login')[0];
        }
        Map<Id,User> userMap=new Map<Id,User>();
        Map<String,String> emailNameMap=new Map<String, String>();
        for(User u:[select id,email, firstname,lastname from user where id IN :caseCreateduserId]){
            userMap.put(u.id, u);
            lstEmail.add(u.Email);
            if(!emailNameMap.containsKey(u.email)){
                if(null!=u.firstname){
                    emailNameMap.put(u.email,u.firstname+' '+u.lastname);
                }
                else{
                    emailNameMap.put(u.email,u.lastname);
                }
            }
            else{
                emailNameMap.put(u.email,u.email);
            }
        }
        
        for(CaseComment cc:caseCommNewMap){
            List<String> lstCCStr = new List<String>();
            String CCAddressId;
            String caseCreatedBy='';
            string commUrl = URL.getSalesforceBaseUrl().toExternalForm();  
            String communityPublicPageUrl = baseURL+'/s/rcmcasedetail?id=';
            User u=new User();
            if((!userMap.isEmpty()) && userMap.containsKey(cc.CreatedById) ){
                u = userMap.get(cc.CreatedById);  
            }            
            Case c1=new Case();
            if((!createdCaseMap.isEmpty()) && createdCaseMap.containsKey(cc.ParentId) ){
                c1 = createdCaseMap.get(cc.ParentId);
                commUrl += '/'+c1.Id;                       //  Additional Line  
                communityPublicPageUrl += c1.Id;  
            }
            if(c1.Record_Type__c == 'RCMCase'){
                lstCCStr = strCCEmail.split(',');
                String[] emailArray = objPPCEmail.split(',');
                emailArray.addAll(lstEmail);
                Messaging.Singleemailmessage email = handledynamicRCMEmail.handledynamicRCMEmailNew(emailtemp,u.Id,c1,emailArray,communityPublicPageUrl,fromAdressId,emailNameMap,caseCommentMap,caseCreatedBy,lstCCStr);
                emailListFull.add(email);
            }
        }  
        
        
        try{
            if(emailListFull.size() > 0 && !Test.isRunningTest()){
                Messaging.sendEmail(emailListFull);
            }
        }
        catch (Exception e) {
            String stackTrace = e.getStackTraceString().substringBefore('\n');
            String className = stackTrace.substringAfter('.').substringBefore('.'); 
            String methodName = stackTrace.substringBefore(':').substringAfter(className).substringAfter('.');
            Partner_Portal_Logs__c storeError = new Partner_Portal_Logs__c();
            storeError.ClassName__c = className;
            storeError.MethodName__c = methodName;
            storeError.Exception_Message__c = e.getMessage();
            storeError.ErrorType__c = 'Cases';
            insert storeError;
        }  
        
    } 
}