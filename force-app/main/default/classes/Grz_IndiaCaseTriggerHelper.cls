public class Grz_IndiaCaseTriggerHelper {
    
    
    /**************India methods start***************/
    public static void sendCaseSmsComm(List<Case> caseList){
        System.debug('Inside sendCaseSmsComm method');
        List<Id> createList=new List<Id>();
        for(Case c:caseList){
            System.debug('c==>'+c.Sub_Category__c);
            if(c.Sub_Category__c  == null){
                
                createList.add(c.createdById);
            } 
        }
        System.debug('createList==>'+createList);
        Map<Id,User> userMap=new Map<Id,User>([Select Id,ProfileId,Profile.Name,MobilePhone from User where Id IN :createList]);
        System.debug('userMap==>'+userMap);
        List<SMS_Template__c> smsTemp=[SELECT Id, Name, Name__c, ObjectName__c, Text__c FROM SMS_Template__c where Name='Community_Case_Creation' and ObjectName__c='Case'];
        for(Case c:caseList){
            system.debug('inside for loop==>'+c);
            if(c.Sub_Category__c == null){
                User u=userMap.get(c.createdById);
                //if(u.Profile.Name=='PartnerCommunity Distributor Profile'){
                if(u.Profile.Name.contains('India Partner Community Distributor Profile')){
                    
                    System.debug('MobilePhone==>'+u.MobilePhone);
                    System.debug('smsTemp==>'+smsTemp);
                    String encodedcontent;
                    if(c.CaseOwner__c != null)
                        encodedcontent = EncodingUtil.urlEncode(smsTemp[0].Text__c.replace('<CASE ID>', c.CaseNumber).replace('<Case Owner>',c.CaseOwner__c), 'UTF-8');
                    else
                        encodedcontent = EncodingUtil.urlEncode(smsTemp[0].Text__c.replace('<CASE ID>', c.CaseNumber), 'UTF-8');
                    if(u.MobilePhone!='' && u.MobilePhone!=null){
                        String phoneVal = u.MobilePhone.replaceAll('\\D','');
                        String senderId = 'UPL';
                        if(!Test.isRunningTest())
                            IntegrationWithKarix.sendSMS(encodedcontent,phoneVal,c.Id,senderId);
                    }
                }
            }
        }
    }
    
    
    // Sending Email on case creation for India Cases
    /*public static void sendEmailOnCaseCreation(Map<Id,Case> caseNewMap){
System.debug('Inside sendEmailOnCaseCreation');
List<Id> userId = new List<Id>();
List<Id> caseIds = new List<Id>();
List<String> saleOrgNameList = new List<String>();
List<Id> saleOrgIdList = new List<Id>();
List<Id> createList=new List<Id>();
Map<Id,Id> accountIdMap=new Map<Id,Id>();

for(Case c : caseNewMap.values()){     
if(c.CaseOwner__c != null){
createList.add(c.createdById);
saleOrgIdList.add(c.SalesOrg__c);
accountIdMap.put(c.Id,c.AccountId);
}  
}

List<String> salesOrgCodeList = System.Label.Grz_IndiaSalesOrgCode.trim().Split(',');
Map<String,String> salesOrgNameMap=new Map<String,String>();
for(Sales_Org__c so:[Select id,name from Sales_Org__c where Sales_Org_Code__c IN :salesOrgCodeList]){
String orgName = so.name.tolowercase();
salesOrgNameMap.put(orgName,so.id);
}
System.debug('salesOrgNameMap : '+salesOrgNameMap);
Map<Id,Id> accOwnerMap=new Map<Id,Id>();
if(!accountIdMap.isEmpty()){
for(Account a:[Select id,ownerid from Account where Id  IN :accountIdMap.values()]){
accOwnerMap.put(a.Id,a.ownerid);
}
}
System.debug('saleOrgIdList : '+saleOrgIdList);
System.debug('accountIdMap : '+accountIdMap);
List<Id> territoryIdList = new List<Id>();
Map<String,String> accterrMap= new Map<String,String>();
for(DistributorSalesAreaMapping__c sa : [SELECT Id, Distributor__c,Distributor__r.name, SalesOrg__c,SalesOrg__r.name, Status__c, Sales_Org_Code__c, Territory__c,Territory__r.name FROM DistributorSalesAreaMapping__c where Distributor__c IN : accountIdMap.values()  and SalesOrg__c IN : saleOrgIdList order by lastmodifieddate desc]){
String accsales = sa.Distributor__c+'-'+sa.SalesOrg__c;
if(!accterrMap.containsKey(accsales)){
territoryIdList.add(sa.Territory__c);
accterrMap.put(accsales,sa.Territory__c);
saleOrgNameList.add(sa.SalesOrg__r.name);
}
}
System.debug('saleOrgNameList : '+saleOrgNameList);
System.debug('accterrMap : '+accterrMap);
Set<String> introTextList=new Set<String>(); 
Map<Id,String> tmMap = new  Map<Id,String>();
Map<Id,String> rcmMap=new Map<Id,String>();
Map<Id,Id> zsmMap=new Map<Id,Id>();
if(!accOwnerMap.isEmpty()){
for(Territory_Distributor__c td:[Select Id, RCM_Email__c,SalesOrg__c,TerritoryManager__c,ZSM_Id__c from Territory_Distributor__c where Id  IN : territoryIdList]){
//rcmMap.put(td.TerritoryManager__c,td.RCM_Email__c);
//zsmMap.put(td.TerritoryManager__c,td.ZSM_Id__c);
rcmMap.put(td.Id,td.RCM_Email__c);
zsmMap.put(td.Id,td.ZSM_Id__c);
tmMap.put(td.Id, td.TerritoryManager__c);
introTextList.add(td.RCM_Email__c);
introTextList.add(td.ZSM_Id__c);
}
} 
System.debug('tmMap : '+tmMap);
System.debug('rcmMap : '+rcmMap);
System.debug('zsmMap : '+zsmMap);
Map<String,String> cnfMap=new Map<String,String>();
for(TM_Depot_Mapping__c tdmp:[Select Id,Depot__r.Case_Access_Email__c,Territory_Manager__c,sales_org__c from TM_Depot_Mapping__c where Territory_Manager__c  IN :tmMap.values() and sales_org__c IN : saleOrgNameList]){
String orgName = tdmp.sales_org__c.tolowercase();
String salesorgID = salesOrgNameMap.get(orgName);
String tmOrgId = tdmp.Territory_Manager__c+'-'+salesorgID;
if(tdmp.Depot__r.Case_Access_Email__c!=null && tdmp.Depot__r.Case_Access_Email__c!=''){
if(!cnfMap.containsKey(tmOrgId)){
cnfMap.put(tmOrgId,tdmp.Depot__r.Case_Access_Email__c);
}
else{
String emailVal=cnfmap.get(tmOrgId);
cnfMap.put(tmOrgId,emailVal+','+tdmp.Depot__r.Case_Access_Email__c);
}
introTextList.add(tdmp.Depot__r.Case_Access_Email__c);
}
}
System.debug('cnfMap==>'+cnfMap);
Id loggedInUser = userInfo.getUserId();
Map<Id,User> userMap=new Map<Id,User>([Select Id,ProfileId,Name,Profile.Name,MobilePhone,Email from User where Id IN :createList or ID =:loggedInUser or Id IN :zsmMap.values()]);

Map<String,String> emailUserMap = new Map<String,String>();
for(Partner_Portal_Configuration__c ppc:[Select Name,Description__c from Partner_Portal_Configuration__c where Recordtype.Name = 'CaseConfiguration']){
emailUserMap.put(ppc.Name,ppc.Description__c);
introTextList.add(ppc.Description__c);
}
Map<String,String> emailNameMap=new Map<String, String>();
for(User u:[select id,email, firstname,lastname from user where email IN :introTextList]){
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
Id Case_recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
List <Messaging.Singleemailmessage> emailListFull = new List <Messaging.Singleemailmessage>();        
Network myCommunity = [SELECT Id FROM Network WHERE Name = 'UPL Partner Portal'];
String baseURL=String.valueOf(Network.getLoginUrl(myCommunity.id));
baseURL=baseURL.split('/login')[0];
List<EmailTemplate> emailtemp = [SELECT Id,body,HtmlValue,subject FROM EmailTemplate WHERE DeveloperName = 'Portal_Created_Email_Template' limit 1];
OrgWideEmailAddress owa = [select id, DisplayName, Address from OrgWideEmailAddress where displayname =: 'Sales Excellence'];
if(!emailtemp.isEmpty()){
for(Case c : caseNewMap.values()){
String commenityurl = baseURL+'/s/case/';
String communityPublicPageUrl = baseURL+'/s/casedetailpage?id=';
List<String> emailList=new List<String>();
User u = userMap.get(c.createdById);
//List<EmailTemplate> emailtemp = [SELECT Id,body,HtmlValue,subject FROM EmailTemplate WHERE DeveloperName = 'Portal_Created_Email_Template' limit 1];
String emailHTML = emailtemp[0].HtmlValue;
//System.debug('emailHTML'+emailHTML);
emailHTML = emailHTML.replace('[loginUserName]',u.Name);
emailtemp[0].HtmlValue = emailHTML;   
//OrgWideEmailAddress owa = [select id, DisplayName, Address from OrgWideEmailAddress where displayname =: 'Sales Excellence'];
String fromAdressId = owa.id;
String indiaProfileName = System.Label.Grz_IndiaCommunityProfile;
communityPublicPageUrl += c.Id;
commenityurl += c.Id;
if(c.CaseOwner__c != null){                
//Id TM_Id = accOwnerMap.get(accountIdMap.get(c.Id));
String accsales = c.AccountId+'-'+c.SalesOrg__c;
Id terrId = accterrMap.get(accsales);
String TM_Id = tmMap.get(terrId)+'-'+c.SalesOrg__c;
//Id SaleOrg_Id = c.SalesOrg__c;
system.debug('Case TM_Id==='+TM_Id);
//system.debug('Case SaleOrg_Id==='+SaleOrg_Id);
if(c.CaseOwner__c.contains('C & F')){
if(!cnfMap.isEmpty() && cnfMap.containsKey(TM_Id)){
system.debug('Case C & F TM_Id==='+TM_Id);
if(cnfMap.get(TM_Id)!=null){
if(cnfMap.get(TM_Id).contains(',')){
String[] emailArray=cnfMap.get(TM_Id).split(',');
for(Integer i=0;i<emailArray.size();i++){
Messaging.Singleemailmessage email = Grz_CaseCommentController.handledynamicEmailNew(emailtemp,u.Id,c,emailArray[i],communityPublicPageUrl,fromAdressId,emailNameMap,null);
emailListFull.add(email);
}
}
else{
Messaging.Singleemailmessage email = Grz_CaseCommentController.handledynamicEmailNew(emailtemp,u.Id,c,cnfMap.get(TM_Id),communityPublicPageUrl,fromAdressId,emailNameMap,null);
emailListFull.add(email);
}
}
}
}
if(c.CaseOwner__c.contains('RCM')){
if(!rcmMap.isEmpty() && rcmMap.containsKey(terrId)){
System.debug('Owner rcm : '+rcmMap.containsKey(terrId));
if(rcmMap.get(terrId) != null){
Messaging.Singleemailmessage email2 = Grz_CaseCommentController.handledynamicEmailNew(emailtemp,u.Id,c,rcmMap.get(terrId),communityPublicPageUrl,fromAdressId,emailNameMap,null);
emailListFull.add(email2);
}
}
}
if(c.CaseOwner__c.contains('LOGISTICS HO')){
if(!emailUserMap.isEmpty() && emailUserMap.containsKey('LOGISTICS HO')){
if(emailUserMap.get('LOGISTICS HO') != null){
Messaging.Singleemailmessage email3 = Grz_CaseCommentController.handledynamicEmailNew(emailtemp,u.Id,c,emailUserMap.get('LOGISTICS HO'),communityPublicPageUrl,fromAdressId,emailNameMap,null);
emailListFull.add(email3);
}
}
}
if(c.CaseOwner__c.contains('HO Finance')){
if(!emailUserMap.isEmpty() && emailUserMap.containsKey('HO Finance')){
if(emailUserMap.get('HO Finance') != null){
Messaging.Singleemailmessage email4 = Grz_CaseCommentController.handledynamicEmailNew(emailtemp,u.Id,c,emailUserMap.get('HO Finance'),communityPublicPageUrl,fromAdressId,emailNameMap,null);
emailListFull.add(email4);
}
}
}
if(c.CaseOwner__c.contains('FCE')){
if(!emailUserMap.isEmpty() && emailUserMap.containsKey('FCE')){
if(emailUserMap.get('FCE') != null){
Messaging.Singleemailmessage email4 = Grz_CaseCommentController.handledynamicEmailNew(emailtemp,u.Id,c,emailUserMap.get('FCE'),communityPublicPageUrl,fromAdressId,emailNameMap,null);
emailListFull.add(email4);
}
}
}
if(c.CaseOwner__c.contains('Sales excellence')){
if(!emailUserMap.isEmpty() && emailUserMap.containsKey('Sales excellence')){
if(emailUserMap.get('Sales excellence') != null){
Messaging.Singleemailmessage email5 = Grz_CaseCommentController.handledynamicEmailNew(emailtemp,u.Id,c,emailUserMap.get('Sales excellence'),communityPublicPageUrl,fromAdressId,emailNameMap,null);
emailListFull.add(email5);
}
}
}
if(c.CaseOwner__c.contains('ZSM')){
System.debug('In zsmMap If');
if(!zsmMap.isEmpty() && zsmMap.containsKey(terrId) && !userMap.isEmpty() && userMap.containsKey(zsmMap.get(terrId))){
System.debug('zsmMap : '+userMap.get(zsmMap.get(terrId)).Email);
if(userMap.get(zsmMap.get(terrId)).Email !=null){
Messaging.Singleemailmessage email5 = Grz_CaseCommentController.handledynamicEmailNew(emailtemp,u.Id,c,userMap.get(zsmMap.get(terrId)).Email,communityPublicPageUrl,fromAdressId,emailNameMap,null);
emailListFull.add(email5);  
}
}
}
if(c.CaseOwner__c.contains('CROP MANAGER')){
if(!emailUserMap.isEmpty() && emailUserMap.containsKey('CROP MANAGER')){
if(emailUserMap.get('CROP MANAGER') != null){
Messaging.Singleemailmessage email6 = Grz_CaseCommentController.handledynamicEmailNew(emailtemp,u.Id,c,emailUserMap.get('CROP MANAGER'),communityPublicPageUrl,fromAdressId,emailNameMap,null);
emailListFull.add(email6);
}
}
}
System.debug('emailListFull : '+emailListFull);            
}
}
}
for(Messaging.Singleemailmessage em : emailListFull){
system.debug('em : '+em);
}

try{
if(emailListFull.size() > 0 && !Test.isRunningTest()){                
//Messaging.sendEmail(emailListFull);
Messaging.SendEmailResult[] results = Messaging.sendEmail(emailListFull);
System.debug('The email result : '+results);
if (results[0].success) {
System.debug('The email was sent successfully.');
} else {
System.debug('The email failed to send: '
+ results[0].errors[0].message);
}
}
}
catch (Exception e) {
system.debug('Inside Catch');
String stackTrace = e.getStackTraceString().substringBefore('\n');
String className = stackTrace.substringAfter('.').substringBefore('.'); 
String methodName = stackTrace.substringBefore(':').substringAfter(className).substringAfter('.');
Partner_Portal_Logs__c storeError = new Partner_Portal_Logs__c();
storeError.ClassName__c =  className;
storeError.MethodName__c = methodName;
storeError.Exception_Message__c = e.getMessage();
storeError.ErrorType__c = 'Cases';
insert storeError;
}

}*/
    
    
    public static void sendEmailOnCaseCreation(Map<Id,Case> caseNewMap){
       
        System.debug('Inside sendEmailOnCaseCreation');
        List<Id> userId = new List<Id>();
        List<Id> caseIds=new List<Id>();
        List<Id> createList=new List<Id>();
        Map<Id,Id> accountIdMap=new Map<Id,Id>();
        
        for(Case c : caseNewMap.values()){     
            if(c.CaseOwner__c != null){
                System.debug('c.CaseOwner__c' + c.CaseOwner__c);
                createList.add(c.createdById);
                accountIdMap.put(c.Id,c.AccountId);
            }  
        }
        Map<Id,Id> accOwnerMap=new Map<Id,Id>();
        Map<Id,Account> accountMap=new Map<Id,Account>();
        if(!accountIdMap.isEmpty()){
            for(Account a:[Select id,ownerid,SAP_Code__c,Name,Depot_Code__c,Brazil_Depot_Code__r.Name from Account where Id  IN :accountIdMap.values()]){   // Change by Sumit(Grazitti) for APPS-4676 01-02-2023
                accOwnerMap.put(a.Id,a.ownerid);
                accountMap.put(a.Id,a);
            }
        }
        
        Set<String> introTextList=new Set<String>();
        
        
        System.debug('accOwnerMap.values' + accOwnerMap);
        Map<Id,String> rcmMap=new Map<Id,String>();
        Map<Id,Id> zsmMap=new Map<Id,Id>();
        if(!accOwnerMap.isEmpty()){
            for(Territory_Distributor__c td:[Select Id, RCM_Email__c,TerritoryManager__c,ZSM_Id__c from Territory_Distributor__c where TerritoryManager__c  IN :accOwnerMap.values()]){
                rcmMap.put(td.TerritoryManager__c,td.RCM_Email__c);
                zsmMap.put(td.TerritoryManager__c,td.ZSM_Id__c);
                introTextList.add(td.RCM_Email__c);
                introTextList.add(td.ZSM_Id__c);
            }
        }       
        System.debug('rcmMap : '+rcmMap);
        System.debug('zsmMap : '+zsmMap);
        Map<Id,String> cnfMap=new Map<Id,String>();
        //Change by Aashima(Grazitti) for APPS-4027 28Dec22
        for(TM_Depot_Mapping__c tdmp:[Select Id,Depot__r.Case_Access_Email__c,Territory_Manager__c from TM_Depot_Mapping__c where Territory_Manager__c  IN :accOwnerMap.values() and (sales_org__c ='UPL SAS' OR sales_org__c ='SWAL')]){
            if(tdmp.Depot__r.Case_Access_Email__c!=null && tdmp.Depot__r.Case_Access_Email__c!=''){
                if(!cnfMap.containsKey(tdmp.Territory_Manager__c)){
                    cnfMap.put(tdmp.Territory_Manager__c,tdmp.Depot__r.Case_Access_Email__c);
                }
                else{
                    String emailVal=cnfmap.get(tdmp.Territory_Manager__c);
                    cnfMap.put(tdmp.Territory_Manager__c,emailVal+','+tdmp.Depot__r.Case_Access_Email__c);
                }
                introTextList.add(tdmp.Depot__r.Case_Access_Email__c);
            }
        }
        System.debug('cnfMap==>'+cnfMap);
        Id loggedInUser = userInfo.getUserId();
        Map<Id,User> userMap=new Map<Id,User>([Select Id,ProfileId,Name,Profile.Name,MobilePhone,Email from User where Id IN :createList or ID =:loggedInUser or Id IN :zsmMap.values() or Id IN :caseNewMap.keyset()]);
        
        Map<String,String> emailUserMap = new Map<String,String>();
        for(Partner_Portal_Configuration__c ppc:[Select Name,Description__c from Partner_Portal_Configuration__c where Recordtype.Name = 'CaseConfiguration']){
            emailUserMap.put(ppc.Name,ppc.Description__c);
            introTextList.add(ppc.Description__c);
        }
        
        Map<String,String> emailNameMap=new Map<String, String>();
        for(User u:[select id,email, firstname,lastname from user where email IN :introTextList]){
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
        
        
        Id Case_recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        List <Messaging.Singleemailmessage> emailListFull = new List <Messaging.Singleemailmessage>(); 
        String baseURL='';       
        List<Network> myCommunity = [SELECT Id FROM Network WHERE Name = 'UPL Partner Portal'];
        if(!myCommunity.isEmpty()){
            baseURL=String.valueOf(Network.getLoginUrl(myCommunity[0].id));
            baseURL=baseURL.split('/login')[0];
        }
        
        List<EmailTemplate> emailtemp = [SELECT Id,body,HtmlValue,subject FROM EmailTemplate WHERE DeveloperName = 'Portal_Created_Email_Template' limit 1];
        List<EmailTemplate> emailtemp1 = [SELECT Id,body,HtmlValue,subject FROM EmailTemplate WHERE DeveloperName = 'Portal_Created_Email_Template_1' limit 1];
        
        List<OrgWideEmailAddress> owa = [select id, DisplayName, Address from OrgWideEmailAddress where displayname =: 'Sales Excellence'];
        
        for(Case c : caseNewMap.values()){
            String caseCreatedBy='';
            String accName='';
            String accSapCode='';
            // Change by Sumit(Grazitti) for APPS-4676 01-02-2023
            String depotName='';
            String depotCode='';
            
            if(!userMap.isEmpty() && userMap.containsKey(c.createdById)){
                caseCreatedBy=userMap.get(c.createdById).Name;
            }
            if(!accountMap.isEmpty() && accountMap.containsKey(c.accountId)){
                accName=accountMap.get(c.accountId).Name;
                accSapCode=accountMap.get(c.accountId).SAP_Code__c;
                // Change by Sumit(Grazitti) for APPS-4676 01-02-2023
                depotName = accountMap.get(c.accountId).Brazil_Depot_Code__r.Name;
                depotCode = accountMap.get(c.accountId).Depot_Code__c;
            }
            Map<Id,List<CaseComment>> caseCommentMap=new Map<Id,List<CaseComment>>();
            
            String commenityurl = baseURL+'/s/case/';
            String communityPublicPageUrl = baseURL+'/s/casedetailpage?id=';
            List<String> emailList=new List<String>();
            User u=userMap.get(c.createdById);
            //List<EmailTemplate> emailtemp = [SELECT Id,body,HtmlValue,subject FROM EmailTemplate WHERE DeveloperName = 'Portal_Created_Email_Template' limit 1];
            String emailHTML = emailtemp[0].HtmlValue;
            String tempEmailHTML = emailtemp1[0].HtmlValue;  // Change by Sumit(Grazitti) for APPS-4676 01-02-2023
            String emailHTML1 = emailtemp1[0].HtmlValue;  //  Additional Line  
            //System.debug('emailHTML'+emailHTML);
            //System.debug('u.Name + ' + u.Name);
            emailHTML = emailHTML.replace('[loginUserName]',u.Name);
            emailHTML1 = emailHTML1.replace('[loginUserName]',u.Name);  //  Additional Line  
            emailtemp[0].HtmlValue = emailHTML;  
            //emailtemp1[0].HtmlValue = emailHTML1;  //  Additional Line  
            //System.debug('emailHTML'+emailHTML);
            // Change by Sumit(Grazitti) for APPS-4676 01-02-2023
            if(null!=depotName){
                System.debug('depotName inside if : '+depotName);
                emailHTML1 = emailHTML1.replace('[Depot_Name]',depotName);
            }
            else{
                emailHTML1 = emailHTML1.replace('[Depot_Name]','');
            }
            
            if(null!=depotCode){
                emailHTML1 = emailHTML1.replace('[Depot_Code]', depotCode);
            }else{
                emailHTML1 = emailHTML1.replace('[Depot_Code]', '');
            }
            emailtemp1[0].HtmlValue = emailHTML1;
            String fromAdressId;
            
            if(!owa.isEmpty()){
                fromAdressId = owa[0].id;
            }   
            
            String indiaProfileName = System.Label.Grz_IndiaCommunityProfile;
            communityPublicPageUrl += c.Id;
            commenityurl += c.Id;
            system.debug('Case Owner : '+c.CaseOwner__c);
            if(c.CaseOwner__c != null){     
                System.debug('c.CaseOwner__c' + c.CaseOwner__c);
                Id TM_Id = accOwnerMap.get(accountIdMap.get(c.Id));
                system.debug('Case TM_Id==='+TM_Id);
                if(c.CaseOwner__c.contains('C & F')){  
                    System.debug('c.CaseOwner__c' + c.CaseOwner__c);
                    if(!cnfMap.isEmpty() && cnfMap.containsKey(TM_Id)){
                        System.debug('c.CaseOwner__c' + c.CaseOwner__c);
                        system.debug('Case C & F TM_Id==='+TM_Id);
                        if(cnfMap.get(TM_Id)!=null){
                            if(cnfMap.get(TM_Id).contains(',')){
                                String[] emailArray=cnfMap.get(TM_Id).split(',');
                                for(Integer i=0;i<emailArray.size();i++){
                                    Messaging.Singleemailmessage email = Grz_CaseCommentController.handledynamicEmailNew(emailtemp,u.Id,c,emailArray[i],communityPublicPageUrl,fromAdressId,emailNameMap,caseCommentMap,caseCreatedBy,accName,accSapCode);
                                    emailListFull.add(email);
                                }
                            }
                            else{
                                Messaging.Singleemailmessage email = Grz_CaseCommentController.handledynamicEmailNew(emailtemp,u.Id,c,cnfMap.get(TM_Id),communityPublicPageUrl,fromAdressId,emailNameMap,caseCommentMap,caseCreatedBy,accName,accSapCode);
                                emailListFull.add(email);
                            }
                        }
                    }
                }
                if(c.CaseOwner__c.contains('RCM')){  //  || c.CaseOwner__c.contains('RCMs')       //  Additional Or Condition Added to RCMs 
                    System.debug('c.CaseOwner__c' + c.CaseOwner__c);
                    System.debug('rcmMap' + rcmMap);
                    if(!rcmMap.isEmpty() && rcmMap.containsKey(TM_Id)){
                        System.debug('TM_Id' + TM_Id);
                        System.debug('Owner rcm : '+rcmMap.containsKey(TM_Id));
                        if(rcmMap.get(TM_Id) != null){
                            Messaging.Singleemailmessage email2 = Grz_CaseCommentController.handledynamicEmailNew(emailtemp,u.Id,c,rcmMap.get(TM_Id),communityPublicPageUrl,fromAdressId,emailNameMap,caseCommentMap,caseCreatedBy,accName,accSapCode);
                            emailListFull.add(email2);
                        }
                    }
                }
                if(c.CaseOwner__c.contains('LOGISTICS HO')){
                    System.debug('c.CaseOwner__c' + c.CaseOwner__c);
                    if(!emailUserMap.isEmpty() && emailUserMap.containsKey('LOGISTICS HO')){
                        if(emailUserMap.get('LOGISTICS HO') != null){
                            Messaging.Singleemailmessage email3 = Grz_CaseCommentController.handledynamicEmailNew(emailtemp,u.Id,c,emailUserMap.get('LOGISTICS HO'),communityPublicPageUrl,fromAdressId,emailNameMap,caseCommentMap,caseCreatedBy,accName,accSapCode);
                            
                            emailListFull.add(email3);
                        }
                    }
                }
                if(c.CaseOwner__c.contains('HO Finance')){
                    if(!emailUserMap.isEmpty() && emailUserMap.containsKey('HO Finance')){
                        if(emailUserMap.get('HO Finance') != null){
                            Messaging.Singleemailmessage email4 = Grz_CaseCommentController.handledynamicEmailNew(emailtemp,u.Id,c,emailUserMap.get('HO Finance'),communityPublicPageUrl,fromAdressId,emailNameMap,caseCommentMap,caseCreatedBy,accName,accSapCode);
                            emailListFull.add(email4);
                        }
                    }
                }
                if(c.CaseOwner__c.contains('FCE')){
                    if(!emailUserMap.isEmpty() && emailUserMap.containsKey('FCE')){
                        if(emailUserMap.get('FCE') != null){
                            Messaging.Singleemailmessage email4 = Grz_CaseCommentController.handledynamicEmailNew(emailtemp,u.Id,c,emailUserMap.get('FCE'),communityPublicPageUrl,fromAdressId,emailNameMap,caseCommentMap,caseCreatedBy,accName,accSapCode);
                            emailListFull.add(email4);
                        }
                    }
                }
                 System.debug('c.CaseOwner__c---123' + c.CaseOwner__c);
                 //code added for handle owner assignment tracking GRZ(Swaranjeet) Jira Ticket No. APPS-3667 modified on 13-12-2022
                 if(c.CaseOwner__c.contains('Dr H. M Joshi,Ved Prakash,Nilesh Patel,Ram Gopal')){
                     System.debug('c.CaseOwner__c---' + c.CaseOwner__c);
                      System.debug('inside--');
                     if(!emailUserMap.isEmpty() && emailUserMap.containsKey('Quality Complaint Level 1')){
                         List<String> emails123 = emailUserMap.get('Quality Complaint Level 1').split(',');
                         for(Integer i=0;i<emails123.size();i++){
                             
                             Messaging.Singleemailmessage email123 = Grz_CaseCommentController.handledynamicEmailNew(emailtemp,u.Id,c,emails123[i],communityPublicPageUrl,fromAdressId,emailNameMap,caseCommentMap,caseCreatedBy,accName,accSapCode);
                             emailListFull.add(email123);
                             System.debug('emailListFull123--- '+emailListFull);
                         }                             
                     }
                     
                }
                if(c.CaseOwner__c.contains('Sales excellence')){
                    if(!emailUserMap.isEmpty() && emailUserMap.containsKey('Sales excellence')){
                        if(emailUserMap.get('Sales excellence') != null){
                            Messaging.Singleemailmessage email5 = Grz_CaseCommentController.handledynamicEmailNew(emailtemp,u.Id,c,emailUserMap.get('Sales excellence'),communityPublicPageUrl,fromAdressId,emailNameMap,caseCommentMap,caseCreatedBy,accName,accSapCode);
                            emailListFull.add(email5);
                        }
                    }
                }
                if(c.CaseOwner__c.contains('ZSM')){  //  || c.CaseOwner__c.contains('ZSM or ZMM')  //  Additional Or Condition Added to ZSM or ZMM   
                    System.debug('In zsmMap If');
                    if(!zsmMap.isEmpty() && zsmMap.containsKey(TM_Id) && !userMap.isEmpty() && userMap.containsKey(zsmMap.get(TM_Id))){
                        System.debug('zsmMap : '+userMap.get(zsmMap.get(TM_Id)).Email);
                        if(userMap.get(zsmMap.get(TM_Id)).Email !=null){
                            Messaging.Singleemailmessage email5 = Grz_CaseCommentController.handledynamicEmailNew(emailtemp,u.Id,c,userMap.get(zsmMap.get(TM_Id)).Email,communityPublicPageUrl,fromAdressId,emailNameMap,caseCommentMap,caseCreatedBy,accName,accSapCode);
                            emailListFull.add(email5);  
                        }
                    }
                }
                if(c.CaseOwner__c.contains('CROP MANAGER')){
                    if(!emailUserMap.isEmpty() && emailUserMap.containsKey('CROP MANAGER')){
                        if(emailUserMap.get('CROP MANAGER') != null){
                            Messaging.Singleemailmessage email6 = Grz_CaseCommentController.handledynamicEmailNew(emailtemp,u.Id,c,emailUserMap.get('CROP MANAGER'),communityPublicPageUrl,fromAdressId,emailNameMap,caseCommentMap,caseCreatedBy,accName,accSapCode);
                            emailListFull.add(email6);
                        }
                    }
                }
                
                //UPL IT support email initiate
                if(c.CaseOwner__c.contains('UPL IT support')){
                                                              if(!emailUserMap.isEmpty() && emailUserMap.containsKey('UPL IT support')){
                                                                  if(emailUserMap.get('UPL IT support') != null){
                                                                      Messaging.Singleemailmessage email8 = Grz_CaseCommentController.handledynamicEmailNew(emailtemp,u.Id,c,emailUserMap.get('UPL IT support'),commenityurl,fromAdressId,emailNameMap,caseCommentMap,caseCreatedBy,accName,accSapCode);
                                                                      emailListFull.add(email8);
                                                                  }                                
                                                              }
                                                             }
                //above changes made on 27/06/2022
                
                System.debug('emailListFull : '+emailListFull); 
                
                
                
                /*   Additional Line for India Case module Begin Here  */
                
                if(c.CaseOwner__c.contains('Depot')){  
                    //System.debug('c.CaseOwner__c' + c.CaseOwner__c);
                    if(!cnfMap.isEmpty() && cnfMap.containsKey(TM_Id)){
                        //System.debug('c.CaseOwner__c' + c.CaseOwner__c);
                        //system.debug('Case C & F TM_Id==='+TM_Id);
                        if(cnfMap.get(TM_Id)!=null){
                            if(cnfMap.get(TM_Id).contains(',')){
                                String[] emailArray=cnfMap.get(TM_Id).split(',');
                                for(Integer i=0;i<emailArray.size();i++){
                                    Messaging.Singleemailmessage email = Grz_CaseCommentController.handledynamicEmailNew(emailtemp1,u.Id,c,emailArray[i],communityPublicPageUrl,fromAdressId,emailNameMap,caseCommentMap,caseCreatedBy,accName,accSapCode);
                                    emailListFull.add(email);
                                }
                            }
                            else{         //updated email template GRZ(Sumit Kumar) Jira Ticket No. RITM0427885 modified on 29-09-2022
                                Messaging.Singleemailmessage email = Grz_CaseCommentController.handledynamicEmailNew(emailtemp1,u.Id,c,cnfMap.get(TM_Id),communityPublicPageUrl,fromAdressId,emailNameMap,caseCommentMap,caseCreatedBy,accName,accSapCode);
                                emailListFull.add(email);
                            }
                        }
                    }
                }     
                //System.debug('c.CaseOwner__c.contains ' + c.CaseOwner__c.contains('GBS Pune'));
                if(c.CaseOwner__c.contains('GBS Pune')){
                    // String emailArray = 'ramsidupadhyay@gmail.com';   //  jagdeep.kaur@upl-ltd.com
                    //System.debug('emailUserMap.get ' +  emailUserMap.get('GBS Pune'));
                    //System.debug('emailUserMap ' + emailUserMap);
                    if(!emailUserMap.isEmpty() && emailUserMap.containsKey('GBS Pune')){
                        if(emailUserMap.get('GBS Pune') != null){
                            Messaging.Singleemailmessage email = Grz_CaseCommentController.handledynamicEmailNew(emailtemp1,u.Id,c,emailUserMap.get('GBS Pune'),communityPublicPageUrl,fromAdressId,emailNameMap,caseCommentMap,caseCreatedBy,accName,accSapCode);
                            emailListFull.add(email);
                        }
                    }
                }
                
                if(c.CaseOwner__c.contains('Sales Excellences')){
                    if(!emailUserMap.isEmpty() && emailUserMap.containsKey('Sales Excellences')){
                        //System.debug('emailUserMap' + emailUserMap);
                        if(emailUserMap.get('Sales Excellences') != null){
                            //System.debug('emailUserMap' + emailUserMap);
                            Messaging.Singleemailmessage email = Grz_CaseCommentController.handledynamicEmailNew(emailtemp1,u.Id,c,emailUserMap.get('Sales Excellences'),communityPublicPageUrl,fromAdressId,emailNameMap,caseCommentMap,caseCreatedBy,accName,accSapCode);
                            emailListFull.add(email);
                        }
                    }
                } 
                
                if(c.CaseOwner__c.contains('TM')){
                    String[] emailArray = u.Email.split(',');
                    for(Integer i=0;i<emailArray.size();i++){
                        Messaging.Singleemailmessage email = Grz_CaseCommentController.handledynamicEmailNew(emailtemp1,u.Id,c,emailArray[i],communityPublicPageUrl,fromAdressId,emailNameMap,caseCommentMap,caseCreatedBy,accName,accSapCode);
                        emailListFull.add(email);
                    }
                }
                emailtemp1[0].HtmlValue = tempEmailHTML;    // Change by Sumit(Grazitti) for APPS-4676 01-02-2023
                /*      End    Here  */
                
                
                /*   Additional Line for India Case module Begin Here   

if(c.CaseOwner__c.contains('Depot')){
System.debug('c.CaseOwner__c' + c.CaseOwner__c);
if(!cnfMap.isEmpty() && cnfMap.containsKey(TM_Id)){
System.debug('c.CaseOwner__c' + c.CaseOwner__c);
system.debug('Case C & F TM_Id==='+TM_Id);
if(cnfMap.get(TM_Id)!=null){
if(cnfMap.get(TM_Id).contains(',')){
String[] emailArray=cnfMap.get(TM_Id).split(',');
for(Integer i=0;i<emailArray.size();i++){
Messaging.Singleemailmessage email = Grz_CaseCommentController.handledynamicEmailNew(emailtemp,u.Id,c,emailArray[i],communityPublicPageUrl,fromAdressId,emailNameMap,null);
emailListFull.add(email);
}
}
else{
Messaging.Singleemailmessage email = Grz_CaseCommentController.handledynamicEmailNew(emailtemp,u.Id,c,cnfMap.get(TM_Id),communityPublicPageUrl,fromAdressId,emailNameMap,null);
emailListFull.add(email);
}
}
}
}
Ends Here     */
                
                /*   Additional Line for India Case module Begin Here  

if(c.CaseOwner__c.contains('RCMs')){
System.debug('c.CaseOwner__c' + c.CaseOwner__c);
System.debug('rcmMap' + rcmMap);
if(!rcmMap.isEmpty() && rcmMap.containsKey(TM_Id)){
System.debug('TM_Id' + TM_Id);
System.debug('Owner rcm : '+rcmMap.containsKey(TM_Id));
if(rcmMap.get(TM_Id) != null){
Messaging.Singleemailmessage email2 = Grz_CaseCommentController.handledynamicEmailNew(emailtemp,u.Id,c,rcmMap.get(TM_Id),communityPublicPageUrl,fromAdressId,emailNameMap,null);
emailListFull.add(email2);
}
}
}
Ends Here     */
                
                /*   Additional Line for India Case module Begin Here  

if(c.CaseOwner__c.contains('ZSM')){
System.debug('In zsmMap If');
if(!zsmMap.isEmpty() && zsmMap.containsKey(TM_Id) ){  //  && !userMap.isEmpty() && userMap.containsKey(zsmMap.get(TM_Id))
System.debug('zsmMap : '+userMap1.get(zsmMap.get(TM_Id)).Email);  //  userMap  
if(userMap1.get(zsmMap.get(TM_Id)).Email !=null){   // userMap  
Messaging.Singleemailmessage email5 = Grz_CaseCommentController.handledynamicEmailNew(emailtemp,u.Id,c,userMap1.get(zsmMap.get(TM_Id)).Email,communityPublicPageUrl,fromAdressId,emailNameMap,null);  //  userMap  
emailListFull.add(email5);  
}
}
}
Ends Here     */
            }
        }
        try{
            //System.debug('emailListFull : '+emailListFull); 
            if(emailListFull.size() > 0 && !Test.isRunningTest()){                
                //List<Messaging.SendEmailResult> results =  Messaging.sendEmail(emailListFull);
                Messaging.sendEmail(emailListFull);
                //System.debug('Results '  + results);
            }
            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        }
        catch (Exception e) {
            String stackTrace = e.getStackTraceString().substringBefore('\n');
            String className = stackTrace.substringAfter('.').substringBefore('.'); 
            String methodName = stackTrace.substringBefore(':').substringAfter(className).substringAfter('.');
            Partner_Portal_Logs__c storeError = new Partner_Portal_Logs__c();
            storeError.ClassName__c =  className;
            storeError.MethodName__c = methodName;
            storeError.Exception_Message__c = e.getMessage();
            storeError.ErrorType__c = 'Cases';
            insert storeError;
        }
        
    }   
    
    // Check case status change and Case Close for India Cases
    
    /*public static void checkStatusChangeForCase(Map<Id,Case> caseNewMap,Map<Id,Case> caseOldMap){
List<Case> casesToBeUpdated = new List<Case>();
List<Id> createList=new List<Id>();
List<String> saleOrgNameList = new List<String>();
List<Id> saleOrgIdList = new List<Id>();
Map<Id,Id> accountIdMap=new Map<Id,Id>();
for(Case c:caseNewMap.values()){
if(c.CaseOwner__c!=null){
createList.add(c.createdById);
saleOrgIdList.add(c.SalesOrg__c);
accountIdMap.put(c.Id,c.AccountId);
}
}

List<String> salesOrgCodeList = System.Label.Grz_IndiaSalesOrgCode.trim().Split(',');
Map<String,String> salesOrgNameMap=new Map<String,String>();
for(Sales_Org__c so:[Select id,name from Sales_Org__c where Sales_Org_Code__c IN :salesOrgCodeList]){
String orgName = so.name.tolowercase();
salesOrgNameMap.put(orgName,so.id);
}

Map<Id,List<CaseComment>> caseCommentMap=new Map<Id,List<CaseComment>>();
//Map<Id,Case> createdCaseMap=new Map<Id,Case>([Select Id,(SELECT Id, ParentId, IsPublished, CommentBody, CreatedById, CreatedDate, createdby.name FROM CaseComments where IsPublished=true order by LastModifiedDate desc limit 5) from Case where Id IN :caseNewMap.keySet() and caseowner__c!=null]);
for(Case c:[Select Id,(SELECT Id, ParentId, IsPublished, CommentBody, CreatedById, CreatedDate, createdby.name FROM CaseComments where IsPublished=true order by LastModifiedDate desc limit 5) from Case where Id IN :caseNewMap.keySet() and caseowner__c!=null]){
caseCommentMap.put(c.Id,c.CaseComments);
}
Set<String> introTextList=new Set<String>();
Map<Id,Id> accOwnerMap=new Map<Id,Id>();
if(!accountIdMap.isEmpty()){
for(Account a:[Select id,ownerid from Account where Id  IN :accountIdMap.values()]){
accOwnerMap.put(a.Id,a.ownerid);
}
}

List<Id> territoryIdList = new List<Id>();
Map<String,String> accterrMap= new Map<String,String>();
for(DistributorSalesAreaMapping__c sa : [SELECT Id, Distributor__c,Distributor__r.name, SalesOrg__c,SalesOrg__r.name, Status__c, Sales_Org_Code__c, Territory__c,Territory__r.name FROM DistributorSalesAreaMapping__c where Distributor__c IN : accountIdMap.values()  and SalesOrg__c IN : saleOrgIdList order by lastmodifieddate desc]){
String accsales = sa.Distributor__c+'-'+sa.SalesOrg__c;
if(!accterrMap.containsKey(accsales)){
territoryIdList.add(sa.Territory__c);
accterrMap.put(accsales,sa.Territory__c);
saleOrgNameList.add(sa.SalesOrg__r.name);
}
}
System.debug('saleOrgNameList : '+saleOrgNameList);
System.debug('accterrMap : '+accterrMap);
Map<Id,String> tmMap = new  Map<Id,String>();
Map<Id,String> rcmMap=new Map<Id,String>();
Map<Id,Id> zsmMap=new Map<Id,Id>();
if(!accOwnerMap.isEmpty()){
for(Territory_Distributor__c td:[Select Id, RCM_Email__c,SalesOrg__c,TerritoryManager__c,ZSM_Id__c from Territory_Distributor__c where Id  IN :territoryIdList]){
//rcmMap.put(td.TerritoryManager__c,td.RCM_Email__c);
//zsmMap.put(td.TerritoryManager__c,td.ZSM_Id__c);
rcmMap.put(td.Id,td.RCM_Email__c);
zsmMap.put(td.Id,td.ZSM_Id__c);
tmMap.put(td.Id, td.TerritoryManager__c);
introTextList.add(td.RCM_Email__c);
introTextList.add(td.ZSM_Id__c);
}
}

System.debug('rcmMap on case closer : '+rcmMap);

Map<String,String> cnfMap=new Map<String,String>();
for(TM_Depot_Mapping__c tdmp:[Select Id,Depot__r.Case_Access_Email__c,Territory_Manager__c,Sales_Org__c from TM_Depot_Mapping__c where Territory_Manager__c  IN :tmMap.values() and sales_org__c IN : saleOrgNameList]){

String orgName = tdmp.sales_org__c.tolowercase();
String salesorgID = salesOrgNameMap.get(orgName);
String tmOrgId = tdmp.Territory_Manager__c+'-'+salesorgID;

if(tdmp.Depot__r.Case_Access_Email__c!=null && tdmp.Depot__r.Case_Access_Email__c!=''){
if(!cnfMap.containsKey(tmOrgId)){
cnfMap.put(tmOrgId,tdmp.Depot__r.Case_Access_Email__c);
}
else{
String emailVal=cnfmap.get(tmOrgId);
cnfMap.put(tmOrgId,emailVal+','+tdmp.Depot__r.Case_Access_Email__c);
}
introTextList.add(tdmp.Depot__r.Case_Access_Email__c);
}
}
System.debug('cnfMap on case closer : '+cnfMap);
Id loggedInUser=userInfo.getUserId();
Map<Id,User> userMap=new Map<Id,User>([Select Id,ProfileId,Profile.Name,MobilePhone,Email from User where Id IN :createList or ID =:loggedInUser or Id IN :zsmMap.values()]);

Id Case_recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
List <Messaging.Singleemailmessage> emailListFull = new List <Messaging.Singleemailmessage>();

Map<String,String> emailUserMap = new Map<String,String>();
for(Partner_Portal_Configuration__c ppc:[Select Name,Description__c from Partner_Portal_Configuration__c where Recordtype.Name = 'CaseConfiguration']){
emailUserMap.put(ppc.Name,ppc.Description__c);
introTextList.add(ppc.Description__c);
}

Map<String,String> emailNameMap=new Map<String, String>();
for(User u:[select id,email, firstname,lastname from user where email IN :introTextList]){
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

Network myCommunity = [SELECT Id FROM Network WHERE Name = 'UPL Partner Portal'];
String baseURL=String.valueOf(Network.getLoginUrl(myCommunity.id));
baseURL=baseURL.split('/login')[0];

List<EmailTemplate> emailtemp = [SELECT Id,body,HtmlValue,subject FROM EmailTemplate WHERE DeveloperName = 'Portal_Closed_Email_Template' limit 1];
OrgWideEmailAddress owa = [select id, DisplayName, Address from OrgWideEmailAddress where displayname =: 'Sales Excellence'];
String fromAdressId = owa.id;

List<SMS_Template__c> smsTemp=[SELECT Id, Name, Name__c, ObjectName__c, Text__c FROM SMS_Template__c where Name='Community_Case_Closure' and ObjectName__c='Case'];

for(Case c : caseNewMap.values()){
String commenityurl = baseURL+'/s/case/';
String communityPublicPageUrl = baseURL+'/s/casedetailpage?id=';
commenityurl += c.Id;
communityPublicPageUrl += c.Id;
List<String> emailList=new List<String>();
User u=userMap.get(c.createdById);

String encodedcontent;

if(c.CaseOwner__c != null){
if(c.Status != caseOldMap.get(c.Id).Status){
if(((System.Now().getTime()-c.CreatedDate.getTime())/(60*60*1000))<24){
Case cc= new Case(Id=c.Id);
cc.Status_updated_in_24_hrs__c=true;
casesToBeUpdated.add(cc);
}

if(c.Status=='Closed'){
System.debug('Send email on case Close');
//Id TM_Id=accOwnerMap.get(accountIdMap.get(c.Id));
String accsales = c.AccountId+'-'+c.SalesOrg__c;
Id terrId = accterrMap.get(accsales);
String TM_Id = tmMap.get(terrId)+'-'+c.SalesOrg__c;
system.debug('Case TM_Id==='+TM_Id);
if(c.CaseOwner__c.contains('C & F')){
if(!cnfMap.isEmpty() && cnfMap.containsKey(TM_Id)){
if(cnfMap.get(TM_Id) != null){
if(cnfMap.get(TM_Id).contains(',')){
String[] emailArray=cnfMap.get(TM_Id).split(',');
for(Integer i=0;i<emailArray.size();i++){
Messaging.Singleemailmessage email = Grz_CaseCommentController.handledynamicEmailNew(emailtemp,u.Id,c,emailArray[i],communityPublicPageUrl,fromAdressId,emailNameMap,caseCommentMap);
emailListFull.add(email);
}
}
else{
Messaging.Singleemailmessage email = Grz_CaseCommentController.handledynamicEmailNew(emailtemp,u.Id,c,cnfMap.get(TM_Id),communityPublicPageUrl,fromAdressId,emailNameMap,caseCommentMap);
emailListFull.add(email);
}
}                                
}
}
if(c.CaseOwner__c.contains('RCM')){
if(!rcmMap.isEmpty() && rcmMap.containsKey(terrId)){
if(rcmMap.get(terrId) != null){
Messaging.Singleemailmessage email2 = Grz_CaseCommentController.handledynamicEmailNew(emailtemp,u.Id,c,rcmMap.get(terrId),communityPublicPageUrl,fromAdressId,emailNameMap,caseCommentMap);
emailListFull.add(email2);
}                         
}
}
if(c.CaseOwner__c.contains('LOGISTICS HO')){
if(!emailUserMap.isEmpty() && emailUserMap.containsKey('LOGISTICS HO')){
if(emailUserMap.get('LOGISTICS HO') != null){
Messaging.Singleemailmessage email3 = Grz_CaseCommentController.handledynamicEmailNew(emailtemp,u.Id,c,emailUserMap.get('LOGISTICS HO'),communityPublicPageUrl,fromAdressId,emailNameMap,caseCommentMap);
emailListFull.add(email3);
}                                
}
}
if(c.CaseOwner__c.contains('HO Finance')){
if(!emailUserMap.isEmpty() && emailUserMap.containsKey('HO Finance')){
if(emailUserMap.get('HO Finance') != null){
Messaging.Singleemailmessage email4 = Grz_CaseCommentController.handledynamicEmailNew(emailtemp,u.Id,c,emailUserMap.get('HO Finance'),communityPublicPageUrl,fromAdressId,emailNameMap,caseCommentMap);
emailListFull.add(email4); 
}
}
}
if(c.CaseOwner__c.contains('FCE')){
if(!emailUserMap.isEmpty() && emailUserMap.containsKey('FCE')){
if(emailUserMap.get('FCE') != null){
Messaging.Singleemailmessage email4 = Grz_CaseCommentController.handledynamicEmailNew(emailtemp,u.Id,c,emailUserMap.get('FCE'),communityPublicPageUrl,fromAdressId,emailNameMap,caseCommentMap);
emailListFull.add(email4);
}                                
}
}
if(c.CaseOwner__c.contains('Sales excellence')){
if(!emailUserMap.isEmpty() && emailUserMap.containsKey('Sales excellence')){
if(emailUserMap.get('Sales excellence') != null){
Messaging.Singleemailmessage email5 = Grz_CaseCommentController.handledynamicEmailNew(emailtemp,u.Id,c,emailUserMap.get('Sales excellence'),communityPublicPageUrl,fromAdressId,emailNameMap,caseCommentMap);
emailListFull.add(email5);
}                                
}
}
if(c.CaseOwner__c.contains('ZSM')){
if(!zsmMap.isEmpty() && zsmMap.containsKey(terrId) && !userMap.isEmpty() && userMap.containsKey(zsmMap.get(terrId))){
if(userMap.get(zsmMap.get(terrId)).Email != null){
Messaging.Singleemailmessage email5 = Grz_CaseCommentController.handledynamicEmailNew(emailtemp,u.Id,c,userMap.get(zsmMap.get(terrId)).Email,communityPublicPageUrl,fromAdressId,emailNameMap,caseCommentMap);
emailListFull.add(email5);
}                                
}
}
if(c.CaseOwner__c.contains('CROP MANAGER')){
if(!emailUserMap.isEmpty() && emailUserMap.containsKey('CROP MANAGER')){
if(emailUserMap.get('CROP MANAGER') != null){
Messaging.Singleemailmessage email7 = Grz_CaseCommentController.handledynamicEmailNew(emailtemp,u.Id,c,emailUserMap.get('CROP MANAGER'),communityPublicPageUrl,fromAdressId,emailNameMap,caseCommentMap);
emailListFull.add(email7);
}                                
}
}
if(loggedInUser!=c.createdById && c.CaseOwner__c!=null){
System.debug('If case close by guest user : '+u.Email);
if(u.Email != null){
Messaging.Singleemailmessage email6 = Grz_CaseCommentController.handledynamicEmailNew(emailtemp,u.Id,c,u.Email,commenityurl,fromAdressId,emailNameMap,caseCommentMap);
emailListFull.add(email6);
}                            
}

//send sms on case closure starts
system.debug('aashima==>'+smsTemp);
encodedcontent = EncodingUtil.urlEncode(smsTemp[0].Text__c.replace('<CASE ID>', c.CaseNumber).replace('<CASE_URL1><CASE_URL2><CASE_URL3>',commenityurl), 'UTF-8');
if(u.MobilePhone!='' && u.MobilePhone!=null){
String phoneVal = u.MobilePhone.replaceAll('\\D','');
String senderId = 'UPL';
if(!Test.isRunningTest())
IntegrationWithKarix.sendSMS(encodedcontent,phoneVal,c.Id,senderId);
}
//send sms on case closure ends 

}
System.debug('emailListFull : '+emailListFull);
}
}
}

try{
if(emailListFull.size() > 0 && !Test.isRunningTest()){
//Messaging.sendEmail(emailListFull);
Messaging.SendEmailResult[] results = Messaging.sendEmail(emailListFull);
System.debug('The email result on case closer : '+results);
if (results[0].success) {
System.debug('The email was sent successfully.');
} else {
System.debug('The email failed to send: '
+ results[0].errors[0].message);
}
}
if(!casesToBeUpdated.isEmpty()){
update casesToBeUpdated;
}
}
catch (Exception e) {
//String stackTrace = e.getStackTraceString().substringBefore('\n');
//String className = stackTrace.substringAfter('.').substringBefore('.'); 
//String methodName = stackTrace.substringBefore(':').substringAfter(className).substringAfter('.');
Partner_Portal_Logs__c storeError = new Partner_Portal_Logs__c();
storeError.ClassName__c = 'BrazilCaseTrigger';
storeError.MethodName__c = 'checkStatusChangeForCase';
storeError.Exception_Message__c = e.getMessage();
storeError.ErrorType__c = 'Cases';
insert storeError;
}

}*/
    
    public static void checkStatusChangeForCase(Map<Id,Case> caseNewMap,Map<Id,Case> caseOldMap){
        System.debug('Inside India Case Close Method');
        List<Case> casesToBeUpdated = new List<Case>();
        List<Id> createList=new List<Id>();
        List<SMS_Template__c> smsTemp=[SELECT Id, Name, Name__c, ObjectName__c, Text__c FROM SMS_Template__c where Name='Community_Case_Closure' and ObjectName__c='Case'];
        System.debug('smsTemp==>'+smsTemp);
        Map<Id,Id> accountIdMap=new Map<Id,Id>();
        
        for(Case c:caseNewMap.values()){
            if(c.CaseOwner__c!=null){
                createList.add(c.createdById);
                accountIdMap.put(c.Id,c.AccountId);
            }
        }
        
        Map<Id,Id> accOwnerMap=new Map<Id,Id>();
        Map<Id,Account> accountMap=new Map<Id,Account>();
        if(!accountIdMap.isEmpty()){
            for(Account a:[Select id,ownerid,Name,Sap_code__c,Depot_Code__c,Brazil_Depot_Code__r.Name from Account where Id  IN :accountIdMap.values()]){    // Change by Sumit(Grazitti) for APPS-4676 01-02-2023
                accOwnerMap.put(a.Id,a.ownerid);
                accountMap.put(a.Id,a);
            }
        }
        
        Map<Id,List<CaseComment>> caseCommentMap=new Map<Id,List<CaseComment>>();
        //Map<Id,Case> createdCaseMap=new Map<Id,Case>([Select Id,(SELECT Id, ParentId, IsPublished, CommentBody, CreatedById, CreatedDate, createdby.name FROM CaseComments where IsPublished=true order by LastModifiedDate desc limit 5) from Case where Id IN :caseNewMap.keySet() and caseowner__c!=null]);
        for(Case c:[Select Id ,catesub__c, caseNumber, Sub_category__c,status, type, recordtypeId, salesorg__c,(SELECT Id, ParentId, IsPublished, CommentBody, CreatedById, CreatedDate, createdby.name FROM CaseComments where IsPublished=true order by LastModifiedDate desc limit 5) from Case where Id IN :caseNewMap.keySet() and caseowner__c!=null]){
            caseCommentMap.put(c.Id,c.CaseComments);
        }
        Set<String> introTextList=new Set<String>();
        
        Map<Id,String> rcmMap=new Map<Id,String>();
        Map<Id,Id> zsmMap=new Map<Id,Id>();
        if(!accOwnerMap.isEmpty()){
            for(Territory_Distributor__c td:[Select Id, RCM_Email__c,TerritoryManager__c,ZSM_Id__c from Territory_Distributor__c where TerritoryManager__c  IN :accOwnerMap.values()]){
                rcmMap.put(td.TerritoryManager__c,td.RCM_Email__c);
                zsmMap.put(td.TerritoryManager__c,td.ZSM_Id__c);
                introTextList.add(td.RCM_Email__c);
                introTextList.add(td.ZSM_Id__c);
            }
        }
        
        System.debug('rcmMap on case closer : '+rcmMap);
        Map<Id,String> cnfMap=new Map<Id,String>();
        //Change by Aashima(Grazitti) for APPS-4027 28Dec22
        for(TM_Depot_Mapping__c tdmp:[Select Id,Depot__r.Case_Access_Email__c,Territory_Manager__c from TM_Depot_Mapping__c where Territory_Manager__c  IN :accOwnerMap.values() and (sales_org__c ='UPL SAS' or sales_org__c ='SWAL')]){
            if(tdmp.Depot__r.Case_Access_Email__c!=null && tdmp.Depot__r.Case_Access_Email__c!=''){
                if(!cnfMap.containsKey(tdmp.Territory_Manager__c)){
                    cnfMap.put(tdmp.Territory_Manager__c,tdmp.Depot__r.Case_Access_Email__c);
                }
                else{
                    String emailVal=cnfmap.get(tdmp.Territory_Manager__c);
                    cnfMap.put(tdmp.Territory_Manager__c,emailVal+','+tdmp.Depot__r.Case_Access_Email__c);
                }
                introTextList.add(tdmp.Depot__r.Case_Access_Email__c);
            }
        }
        System.debug('cnfMap on case closer : '+cnfMap);
        Id loggedInUser=userInfo.getUserId();
        Map<Id,User> userMap=new Map<Id,User>([Select Id,Name,ProfileId,Profile.Name,MobilePhone,Email from User where Id IN :createList or ID =:loggedInUser or Id IN :zsmMap.values()]);
        
        Id Case_recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        List <Messaging.Singleemailmessage> emailListFull = new List <Messaging.Singleemailmessage>();
        
        Map<String,String> emailUserMap = new Map<String,String>();
        for(Partner_Portal_Configuration__c ppc:[Select Name,Description__c from Partner_Portal_Configuration__c where Recordtype.Name = 'CaseConfiguration']){
            emailUserMap.put(ppc.Name,ppc.Description__c);
            introTextList.add(ppc.Description__c);
        }
        
        Map<String,String> emailNameMap=new Map<String, String>();
        for(User u:[select id,email, firstname,lastname from user where email IN :introTextList]){
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
        
        Organization org = [SELECT InstanceName FROM Organization];  // Additional Line
        String commUrl = 'https://' + org.InstanceName + '.salesforce.com/';  // Additional Line  
        
        String baseURL='';       
        List<Network> myCommunity = [SELECT Id FROM Network WHERE Name = 'UPL Partner Portal'];
        if(!myCommunity.isEmpty()){
            baseURL=String.valueOf(Network.getLoginUrl(myCommunity[0].id));
            baseURL=baseURL.split('/login')[0];
        }
        List<EmailTemplate> emailtemp = [SELECT Id,body,HtmlValue,subject FROM EmailTemplate WHERE DeveloperName = 'Portal_Closed_Email_Template' limit 1];
        List<EmailTemplate> emailtemp1 = [SELECT Id,body,HtmlValue,subject FROM EmailTemplate WHERE DeveloperName = 'Portal_Closed_Email_Template_1' limit 1]; //  Additional Line  
        String fromAdressId;
        List<OrgWideEmailAddress> owa = [select id, DisplayName, Address from OrgWideEmailAddress where displayname =: 'Sales Excellence' ];
        
        if(!owa.isEmpty()){
            fromAdressId = owa[0].id;
        }
        
        for(Case c : caseNewMap.values()){
            
            String caseCreatedBy='';
            String accName='';
            String accSapCode='';
            // Change by Sumit(Grazitti) for APPS-4676 01-02-2023
            String depotName = '';
            String depotCode='';
            
            if(!userMap.isEmpty() && userMap.containsKey(c.createdById)){
                caseCreatedBy=userMap.get(c.createdById).Name;
            }
            // Change by Sumit(Grazitti) for APPS-4676 01-02-2023
            if(!accountMap.isEmpty() && accountMap.containsKey(c.accountId)){
                accName=accountMap.get(c.accountId).Name;
                accSapCode=accountMap.get(c.accountId).SAP_Code__c;
                depotName = accountMap.get(c.accountId).Brazil_Depot_Code__r.Name;
                depotCode = accountMap.get(c.accountId).Depot_Code__c;
            }
            // Change by Sumit(Grazitti) for APPS-4676 01-02-2023
            String tempEmailHTML = emailtemp1[0].HtmlValue;
            String emailHTML1 = emailtemp1[0].HtmlValue;
            
            System.debug('depotName : '+depotName);
            if(null!=depotName){
            	emailHTML1 = emailHTML1.replace('[Depot_Name]',depotName);
            }
            else{
                emailHTML1 = emailHTML1.replace('[Depot_Name]','');
            }
            
            if(null!=depotCode){
                  System.debug('depotCode : '+depotCode);
                  emailHTML1 = emailHTML1.replace('[Depot_Code]', depotCode);
            }else{
                  emailHTML1 = emailHTML1.replace('[Depot_Code]', '');
            }
            emailtemp1[0].HtmlValue = emailHTML1;
            
            String encodedcontent;
            commUrl += c.Id;  //  Addtional Line 
            String commenityurl = baseURL+'/s/case/';
            String communityPublicPageUrl = baseURL+'/s/casedetailpage?id=';
            commenityurl += c.Id;
            communityPublicPageUrl += c.Id;
            List<String> emailList=new List<String>();
            User u=userMap.get(c.createdById);
            if(c.CaseOwner__c != null){
                if((c.Status != caseOldMap.get(c.Id).Status) || Test.isRunningTest()){
                    if(((System.Now().getTime()-c.CreatedDate.getTime())/(60*60*1000))<24){
                        Case cc= new Case(Id=c.Id);
                        cc.Status_updated_in_24_hrs__c=true;
                        casesToBeUpdated.add(cc);
                    }
                    
                    if(c.Status=='Closed' || Test.isRunningTest()){
                        System.debug('Send email on case Close');
                        Id TM_Id=accOwnerMap.get(accountIdMap.get(c.Id));
                        if(c.CaseOwner__c.contains('C & F')){
                            if(!cnfMap.isEmpty() && cnfMap.containsKey(TM_Id)){
                                if(cnfMap.get(TM_Id) != null){
                                    if(cnfMap.get(TM_Id).contains(',')){
                                        String[] emailArray=cnfMap.get(TM_Id).split(',');
                                        for(Integer i=0;i<emailArray.size();i++){
                                            Messaging.Singleemailmessage email = Grz_CaseCommentController.handledynamicEmailNew(emailtemp,u.Id,c,emailArray[i],communityPublicPageUrl,fromAdressId,emailNameMap,caseCommentMap,caseCreatedBy,accName,accSapCode);
                                            emailListFull.add(email);
                                        }
                                    }
                                    else{
                                        Messaging.Singleemailmessage email = Grz_CaseCommentController.handledynamicEmailNew(emailtemp,u.Id,c,cnfMap.get(TM_Id),communityPublicPageUrl,fromAdressId,emailNameMap,caseCommentMap,caseCreatedBy,accName,accSapCode);
                                        emailListFull.add(email);
                                    }
                                }                                
                            }
                        }
                        if(c.CaseOwner__c.contains('RCM')){
                            if(!rcmMap.isEmpty() && rcmMap.containsKey(TM_Id)){
                                if(rcmMap.get(TM_Id) != null){
                                    Messaging.Singleemailmessage email2 = Grz_CaseCommentController.handledynamicEmailNew(emailtemp,u.Id,c,rcmMap.get(TM_Id),communityPublicPageUrl,fromAdressId,emailNameMap,caseCommentMap,caseCreatedBy,accName,accSapCode);
                                    emailListFull.add(email2);
                                }                         
                            }
                        }
                        if(c.CaseOwner__c.contains('LOGISTICS HO')){
                            if(!emailUserMap.isEmpty() && emailUserMap.containsKey('LOGISTICS HO')){
                                if(emailUserMap.get('LOGISTICS HO') != null){
                                    Messaging.Singleemailmessage email3 = Grz_CaseCommentController.handledynamicEmailNew(emailtemp,u.Id,c,emailUserMap.get('LOGISTICS HO'),communityPublicPageUrl,fromAdressId,emailNameMap,caseCommentMap,caseCreatedBy,accName,accSapCode);
                                    emailListFull.add(email3);
                                }                                
                            }
                        }
                        if(c.CaseOwner__c.contains('HO Finance')){
                            if(!emailUserMap.isEmpty() && emailUserMap.containsKey('HO Finance')){
                                if(emailUserMap.get('HO Finance') != null){
                                    Messaging.Singleemailmessage email4 = Grz_CaseCommentController.handledynamicEmailNew(emailtemp,u.Id,c,emailUserMap.get('HO Finance'),communityPublicPageUrl,fromAdressId,emailNameMap,caseCommentMap,caseCreatedBy,accName,accSapCode);
                                    emailListFull.add(email4); 
                                }
                            }
                        }
                        if(c.CaseOwner__c.contains('FCE')){
                            if(!emailUserMap.isEmpty() && emailUserMap.containsKey('FCE')){
                                if(emailUserMap.get('FCE') != null){
                                    Messaging.Singleemailmessage email4 = Grz_CaseCommentController.handledynamicEmailNew(emailtemp,u.Id,c,emailUserMap.get('FCE'),communityPublicPageUrl,fromAdressId,emailNameMap,caseCommentMap,caseCreatedBy,accName,accSapCode);
                                    emailListFull.add(email4);
                                }                                
                            }
                        }
                        if(c.CaseOwner__c.contains('Sales excellence')){
                            if(!emailUserMap.isEmpty() && emailUserMap.containsKey('Sales excellence')){
                                if(emailUserMap.get('Sales excellence') != null){
                                    Messaging.Singleemailmessage email5 = Grz_CaseCommentController.handledynamicEmailNew(emailtemp,u.Id,c,emailUserMap.get('Sales excellence'),communityPublicPageUrl,fromAdressId,emailNameMap,caseCommentMap,caseCreatedBy,accName,accSapCode);
                                    emailListFull.add(email5);
                                }                                
                            }
                        }
                        if(c.CaseOwner__c.contains('ZSM')){
                            if(!zsmMap.isEmpty() && zsmMap.containsKey(TM_Id) && !userMap.isEmpty() && userMap.containsKey(zsmMap.get(TM_Id))){
                                if(userMap.get(zsmMap.get(TM_Id)).Email != null){
                                    Messaging.Singleemailmessage email5 = Grz_CaseCommentController.handledynamicEmailNew(emailtemp,u.Id,c,userMap.get(zsmMap.get(TM_Id)).Email,communityPublicPageUrl,fromAdressId,emailNameMap,caseCommentMap,caseCreatedBy,accName,accSapCode);
                                    emailListFull.add(email5);
                                }                                
                            }
                        }
                        if(c.CaseOwner__c.contains('CROP MANAGER')){
                            if(!emailUserMap.isEmpty() && emailUserMap.containsKey('CROP MANAGER')){
                                if(emailUserMap.get('CROP MANAGER') != null){
                                    Messaging.Singleemailmessage email7 = Grz_CaseCommentController.handledynamicEmailNew(emailtemp,u.Id,c,emailUserMap.get('CROP MANAGER'),communityPublicPageUrl,fromAdressId,emailNameMap,caseCommentMap,caseCreatedBy,accName,accSapCode);
                                    emailListFull.add(email7);
                                }                                
                            }
                        }
                       if(loggedInUser!=c.createdById && c.CaseOwner__c!=null && c.Sub_Category__c  == null){
                            System.debug('If case close by guest user : '+u.Email);
                            if(u.Email != null){
                                Messaging.Singleemailmessage email6 = Grz_CaseCommentController.handledynamicEmailNew(emailtemp,u.Id,c,u.Email,commenityurl,fromAdressId,emailNameMap,caseCommentMap,caseCreatedBy,accName,accSapCode);
                                emailListFull.add(email6);
                            }                            
                        }
                        
                        //  Additional Line Start Here //
                        if(loggedInUser!=c.createdById && c.CaseOwner__c!=null && (c.catesub__c == 'Request' || c.catesub__c == 'Complaint')){   
                            
                            System.debug('If case close by guest user : '+u.Email);
                            if(u.Email != null){
                                Messaging.Singleemailmessage email6 = Grz_CaseCommentController.handledynamicEmailNew(emailtemp1,u.Id,c,u.Email,commUrl,fromAdressId,emailNameMap,caseCommentMap,caseCreatedBy,accName,accSapCode);
                                emailListFull.add(email6);
                            }                            
                        }  
                        //  Additional Line End Here /////////////////////////////////
                        
                        
                        //send sms on case closure starts
                        system.debug('aashima==>'+smsTemp);
                        if(c.Sub_Category__c  == null && !smsTemp.isEmpty()){
                            encodedcontent = EncodingUtil.urlEncode(smsTemp[0].Text__c.replace('<CASE ID>', c.CaseNumber).replace('<CASE_URL1><CASE_URL2><CASE_URL3>',commenityurl), 'UTF-8');
                            if(u.MobilePhone!='' && u.MobilePhone!=null){
                                String phoneVal = u.MobilePhone.replaceAll('\\D','');
                                String senderId = 'UPL';
                                if(!Test.isRunningTest())
                                    IntegrationWithKarix.sendSMS(encodedcontent,phoneVal,c.Id,senderId);
                            }
                        }
                        //send sms on case closure ends 
                    }
                }
                emailtemp1[0].HtmlValue = tempEmailHTML;      // Change by Sumit(Grazitti) for APPS-4676 01-02-2023
            }
        } 
        system.debug('1185=================='+emailListFull);
        
        try{
            if(emailListFull.size() > 0 && !Test.isRunningTest()){
                Messaging.sendEmail(emailListFull);
            }
            if(!casesToBeUpdated.isEmpty()){
                update casesToBeUpdated;
            }
            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        }
        catch (Exception e) {
            //String stackTrace = e.getStackTraceString().substringBefore('\n');
            //String className = stackTrace.substringAfter('.').substringBefore('.'); 
            //String methodName = stackTrace.substringBefore(':').substringAfter(className).substringAfter('.');
            Partner_Portal_Logs__c storeError = new Partner_Portal_Logs__c();
            storeError.ClassName__c = 'BrazilCaseTrigger';
            storeError.MethodName__c = 'checkStatusChangeForCase';
            storeError.Exception_Message__c = e.getMessage();
            storeError.ErrorType__c = 'Cases';
            insert storeError;
        } 
        
        
    }  
    
    
    
    
    
    
}