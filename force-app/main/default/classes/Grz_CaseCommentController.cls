public class Grz_CaseCommentController {
     
    public void checkCommentAddedOnCase(List<CaseComment> caseCommNewMap){
        List<Id> caseIds=new List<Id>();
        
        for(CaseComment cc:caseCommNewMap){
            system.debug('parentid : '+cc.ParentId);
            if(String.valueof(cc.ParentId).startsWith('500'))
                caseIds.add(cc.ParentId);
        }
        
        Map<Id,Case> createdCaseMap=new Map<Id,Case>([Select Id, CreatedDate,CreatedById,recordTypeId, catesub__c, sub_category__c from Case where Id IN :caseIds]);
        List<Case> casesToBeUpdated=new List<Case>();
        Id Case_recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        for(Case c : createdCaseMap.values()){
            //User u=userMap.get(c.CreatedById);
            //if(u.Profile.Name=='India Partner Community Distributor Profile'){
            if(c.recordTypeId==Case_recordTypeId && c.Sub_Category__c == null){
                if(((System.Now().getTime()-c.CreatedDate.getTime())/(60*60*1000))<24){
                    Case cc= new Case(Id=c.Id);
                    cc.Comment_updated_in_24_hrs__c=true;
                    casesToBeUpdated.add(cc);
                }
            }
            //}
            
        }
        if(!casesToBeUpdated.isEmpty()){
            update casesToBeUpdated;
        }
        
    }
    
    /*public static Messaging.Singleemailmessage handledynamicEmail(List<EmailTemplate> template,String userid, Case c,String useremail,String commenityurl,String fromAdressId){
        Messaging.Singleemailmessage email = Messaging.renderStoredEmailTemplate(template[0].Id, userid, c.Id);
        String emailadd = useremail;
        system.debug('emailadd : '+emailadd);
        list<user> ulist=[select id, firstname,lastname,name from user where email=:emailadd];
        
        if(ulist.size()==1){
            if(null!=ulist[0].firstname){
                emailadd=ulist[0].firstname+' '+ulist[0].lastname;
            }
            else{
                emailadd=ulist[0].lastname;
            }
        }
        System.debug('emailList : '+emailadd);
        String emailHTML = template[0].HtmlValue;
        String emailSub = template[0].subject;
        System.debug('CaseNumber : '+c.CaseNumber);
        emailSub = emailSub.replace('[CaseNumber]', c.CaseNumber);
        emailHTML = emailHTML.replace('[OwnerEmail]', emailadd).replace('[CaseDetailPageLink]',commenityurl);
        emailHTML = emailHTML.replace('[CaseNumber]',c.CaseNumber);
        emailHTML = emailHTML.replace('[Date_of_creation]',Grz_SapIntegration.FormattedDate(c.CreatedDate));
        emailHTML = emailHTML.replace('[Type_]',c.Type);
        emailHTML = emailHTML.replace('[Subject_]',c.Subject);
        if(null!=c.Description){
            emailHTML = emailHTML.replace('[Description_]',c.Description);
        }
        else{
            emailHTML = emailHTML.replace('[Description_]','');
        }
        emailHTML = emailHTML.replace('[Status_]',c.Status);
        if(c.ClosedDate!=null){
            emailHTML = emailHTML.replace('[Closed_Date]',string.valueof(c.ClosedDate));
        }
        if(emailHTML.contains('[Case_Comment_Table]')){
            List<CaseComment> CCList=[SELECT Id, ParentId, IsPublished, CommentBody, CreatedById, CreatedDate, createdby.name FROM CaseComment where ParentId=:c.id and IsPublished=true order by LastModifiedDate desc limit 5];
            
            if(CCList.isEmpty()){
                emailHTML = emailHTML.replace('[Case_Comment_Table]',''); 
            }
            else{
                emailHTML = emailHTML.replace('[Case_Comment_Table]','<span style="font-weight:bold;">Case Comments</span></br><table style="width:700px"><tr ><th style="width:20%">Posted On</th><th style="width:20%">Posted By</th><th style="width:60%">Comment</th></tr>[Case_Comment_Table]'); 
                String tableRows='';
                for(CaseComment cx:CCList){
                    String postedBy=cx.createdby.name;
                    String postedOn=Grz_SapIntegration.FormattedDate(cx.CreatedDate);
                    String CommentBody=cx.CommentBody;
                    tableRows=tableRows+'<tr><td>'+postedOn+'</td><td>'+postedBy+'</td><td>'+CommentBody+'</td></tr>';
                }
                tableRows=tableRows+'</table>';
                emailHTML = emailHTML.replace('[Case_Comment_Table]',tableRows);
            }
        }
        
        email.setHtmlBody(emailHTML);
        email.setSubject(emailSub);
        email.setOrgWideEmailAddressId(fromAdressId);
        email.toaddresses = (new String[] {useremail});
        email.setTreatTargetObjectAsRecipient(false); 
        email.setSaveAsActivity(false);
        return email;
    }*/
    
    public static Messaging.Singleemailmessage handledynamicEmailNew(List<EmailTemplate> template,String userid, Case c,String useremail,String commenityurl,String fromAdressId,Map<String,String> emailNameMap,Map<Id,List<CaseComment>> caseCommentMap,String caseCreatedBy,String accName,String accSapCode){
        Messaging.Singleemailmessage email = Messaging.renderStoredEmailTemplate(template[0].Id, userid, c.Id);
        String emailadd = useremail;
        if(!emailNameMap.isEmpty() && emailNameMap.containsKey(useremail)){
            emailadd = emailNameMap.get(useremail);
        }
         
        System.debug('emailList : '+emailadd);
        String emailHTML = template[0].HtmlValue;
        String emailSub = template[0].subject;
        System.debug('CaseNumber : '+c.CaseNumber);
        emailSub = emailSub.replace('[CaseNumber]', c.CaseNumber);
        emailHTML = emailHTML.replace('[OwnerEmail]', emailadd).replace('[CaseDetailPageLink]',commenityurl);
        emailHTML = emailHTML.replace('[CaseNumber]',c.CaseNumber);
        emailHTML = emailHTML.replace('[Date_of_creation]',Grz_SapIntegration.FormattedDate(c.CreatedDate));
        if(null!=c.Sub_Category__c){
            emailHTML = emailHTML.replace('[Type_]',c.Sub_Category__c);
            //emailHTML = emailHTML.replace('[loginUserName]',caseCreatedBy); 
        }
        else if (null!=c.type){
            emailHTML = emailHTML.replace('[Type_]',c.Type);  
        }
        else{
            emailHTML = emailHTML.replace('[Type_]','');
        }        
        if(null!=c.Subject){
            emailHTML = emailHTML.replace('[Subject_]',c.Subject);
        }
        else{
            emailHTML = emailHTML.replace('[Subject_]','');
        }
        
        if(null!=c.Description){
            emailHTML = emailHTML.replace('[Description_]',c.Description);
        }
        else{
            emailHTML = emailHTML.replace('[Description_]','');
        }
        if(null!=c.Status){
        emailHTML = emailHTML.replace('[Status_]',c.Status);
        }
        else{
        emailHTML = emailHTML.replace('[Status_]','');
        }
        
        /*-----FOr case Module--------*/
         System.debug('userid@@@@' + userid);
       // User userValue = [Select Id, Name, firstname, lastname, Email,TM_Code__c from User  where Id =: c.CreatedById];  //  Profile.Name,  ProfileId,  MobilePhone
        //  User userValue = [Select Id, Name, firstname, lastname, Email,TM_Code__c from User where Id=:userid];  //  Profile.Name,  ProfileId,  MobilePhone 
        
       // Account acc = [Select Id, Name, SAP_Code__c from Account where Id =: c.AccountId];
        if(accName != null)
        {
            emailHTML = emailHTML.replace('[Customer_Name__]',accName);
        }
        else{
            emailHTML = emailHTML.replace('[Customer_Name__]','');
        }
        if(accSapCode != null){
            emailHTML = emailHTML.replace('[SAP_Customer_Code]',accSapCode);
        }
        else{
            emailHTML = emailHTML.replace('[SAP_Customer_Code]','');
        }

        if(caseCreatedBy != null){  
            emailHTML = emailHTML.replace('[TM_Code]',caseCreatedBy);    
        }
        else{  
            emailHTML = emailHTML.replace('[TM_Code]','');      
        }
        
        /*-----Ends here!!!--------*/
        
        /*-----FOr case Module--------*/
        
       /* User uId = [Select Id,TM_Code__c from User where Id=:userid];
        if(c.AccountId != null)
        {
            emailHTML = emailHTML.replace('[Customer_Name__]',c.Account.Name);
            emailHTML = emailHTML.replace('[SAP_Customer_Code]',c.SAP_Code__c);
            if(uId.TM_Code__c != null){
                emailHTML = emailHTML.replace('[TM_Code]',uId.TM_Code__c);    
            }
        }  */
        
        /*-----Ends here!!!--------*/
        
        if(c.ClosedDate!=null){
            emailHTML = emailHTML.replace('[Closed_Date]',Grz_SapIntegration.FormattedDate(c.ClosedDate));
        }
        if(emailHTML.contains('[Case_Comment_Table]')){
            //List<CaseComment> CCList=[SELECT Id, ParentId, IsPublished, CommentBody, CreatedById, CreatedDate, createdby.name FROM CaseComment where ParentId=:c.id and IsPublished=true order by LastModifiedDate desc limit 5];
            List<CaseComment> ccList=new List<CaseComment>();
            if(!caseCommentMap.isEmpty() && caseCommentMap.containsKey(c.Id)){
                ccList=caseCommentMap.get(c.Id);
            }
            if(ccList.isEmpty()){
                emailHTML = emailHTML.replace('[Case_Comment_Table]',''); 
            }
            else{
                emailHTML = emailHTML.replace('[Case_Comment_Table]','<span style="font-weight:bold;">Case Comments</span></br><table style="width:700px"><tr ><th style="width:20%">Posted On</th><th style="width:20%">Posted By</th><th style="width:60%">Comment</th></tr>[Case_Comment_Table]'); 
                String tableRows='';
                for(CaseComment cx:ccList){
                    String postedBy=cx.createdby.name;
                    String postedOn=Grz_SapIntegration.FormattedDate(cx.CreatedDate);
                    String CommentBody=cx.CommentBody;
                    tableRows=tableRows+'<tr><td>'+postedOn+'</td><td>'+postedBy+'</td><td>'+CommentBody+'</td></tr>';
                }
                tableRows=tableRows+'</table>';
                emailHTML = emailHTML.replace('[Case_Comment_Table]',tableRows);
            }
        }
        
        email.setHtmlBody(emailHTML);
        email.setSubject(emailSub);
        email.setOrgWideEmailAddressId(fromAdressId);
        email.toaddresses = (new String[] {useremail});
        email.setTreatTargetObjectAsRecipient(false); 
        email.setSaveAsActivity(false);
        return email;
    }
    
    /*public void sendEmailOnCaseComment(List<CaseComment> caseCommNewMap){
        List<Id> caseCreateduserId = new List<Id>();
        List<Id> caseIds=new List<Id>();
        for(CaseComment cc:caseCommNewMap){
            if(cc.IsPublished == True){                
                if(String.valueof(cc.ParentId).startsWith('500')){
                    caseCreateduserId.add(cc.CreatedById); 
                    caseIds.add(cc.ParentId);
                }           
            }             
        }
        
        Map<Id,Case> createdCaseMap=new Map<Id,Case>([Select Id,CaseNumber,CreatedDate,AccountId,SalesOrg__c,CreatedById,CaseOwner__c,Owner.Email,recordTypeId,Type,Status,Subject,Description,Closeddate,(SELECT Id, ParentId, IsPublished, CommentBody, CreatedById, CreatedDate, createdby.name FROM CaseComments where IsPublished=true order by LastModifiedDate desc limit 5) from Case where Id IN :caseIds and caseowner__c!=null]);
        Map<Id,List<CaseComment>> caseCommentMap=new Map<Id,List<CaseComment>>();
        Map<Id,Id> casecreateIdMap=new Map<Id,Id>();
        Map<Id,Id> accountIdMap=new Map<Id,Id>();
        List<String> saleOrgNameList = new List<String>();
        List<Id> saleOrgIdList = new List<Id>();
        for(Case c:createdCaseMap.values()){ 
            if(c.caseowner__c!=null){
                caseCreateduserId.add(c.CreatedById); 
                casecreateIdMap.put(c.Id,c.createdById);
                accountIdMap.put(c.Id,c.AccountId);
                caseCommentMap.put(c.Id,c.CaseComments);
                saleOrgIdList.add(c.SalesOrg__c);
            }
        }
        system.debug('caseCommentMap==>'+caseCommentMap);
        
        List<String> salesOrgCodeList = System.Label.Grz_IndiaSalesOrgCode.trim().Split(',');
        Map<String,String> salesOrgNameMap=new Map<String,String>();
        for(Sales_Org__c so:[Select id,name from Sales_Org__c where Sales_Org_Code__c IN :salesOrgCodeList]){
            String orgName = so.name.tolowercase();
            salesOrgNameMap.put(orgName,so.id);
        }
        
        Set<String> introTextList=new Set<String>();
        Map<String,String> emailUserMap = new Map<String,String>();
        for(Partner_Portal_Configuration__c ppc:[Select Name,Description__c from Partner_Portal_Configuration__c where Recordtype.Name = 'CaseConfiguration']){
            emailUserMap.put(ppc.Name,ppc.Description__c);
            introTextList.add(ppc.Description__c);
        }
        
        Map<Id,Id> accOwnerMap=new Map<Id,Id>();
        if(!accountIdMap.isEmpty()){
            for(Account a:[Select id,ownerid from Account where Id  IN :accountIdMap.values()]){
                accOwnerMap.put(a.Id,a.ownerid);
            }
        }
        System.debug('accOwnerMap : '+accOwnerMap);
        
        Map<String,String> accterrMap= new Map<String,String>();
        for(DistributorSalesAreaMapping__c sa : [SELECT Id, Distributor__c,Distributor__r.name, SalesOrg__c,SalesOrg__r.name, Status__c, Sales_Org_Code__c, Territory__c,Territory__r.name FROM DistributorSalesAreaMapping__c where Distributor__c IN : accountIdMap.values()  and SalesOrg__c IN : saleOrgIdList]){
            String accsales = sa.Distributor__c+'-'+sa.SalesOrg__c;
            if(!accterrMap.containsKey(accsales)){
                accterrMap.put(accsales,sa.Territory__c);
                saleOrgNameList.add(sa.SalesOrg__r.name);
            }
        }
        System.debug('saleOrgNameList : '+saleOrgNameList);
        System.debug('accterrMap : '+accterrMap);

        Map<Id,String> rcmMap=new Map<Id,String>();
        Map<Id,Id> zsmMap=new Map<Id,Id>();
        Map<Id,String> tmMap = new  Map<Id,String>();
        for(Territory_Distributor__c td:[Select Id, RCM_Email__c,TerritoryManager__c,ZSM_Id__c from Territory_Distributor__c where Id  IN :accterrMap.values()]){
            //rcmMap.put(td.TerritoryManager__c,td.RCM_Email__c);
            //zsmMap.put(td.TerritoryManager__c,td.ZSM_Id__c);
            rcmMap.put(td.Id,td.RCM_Email__c);
            zsmMap.put(td.Id,td.ZSM_Id__c);
            tmMap.put(td.Id, td.TerritoryManager__c);
            introTextList.add(td.RCM_Email__c);
            introTextList.add(td.ZSM_Id__c);
        }
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
        System.debug('cnfMap : '+cnfMap);
        Id loggedInUser=userInfo.getUserId();
        Map<Id,User> userMap=new Map<Id,User>([Select Id,ProfileId,Profile.Name,MobilePhone,Email from User where Id IN :caseCreateduserId or ID =:loggedInUser or Id IN :zsmMap.values()]);
        System.debug('userMap : '+userMap);
        Id Case_recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        
        List <Messaging.Singleemailmessage> emailListFull = new List <Messaging.Singleemailmessage>();
        List<EmailTemplate> emailtemp = [SELECT Id,body,HtmlValue,subject FROM EmailTemplate WHERE DeveloperName = 'CaseCommentEmailTemplate' Limit 1];    
        OrgWideEmailAddress owa = [select id, DisplayName, Address from OrgWideEmailAddress where displayname =: 'Sales Excellence'];
        String fromAdressId = owa.id;
        
        String baseURL='';       
        List<Network> myCommunity = [SELECT Id FROM Network WHERE Name = 'UPL Partner Portal'];
        if(!myCommunity.isEmpty()){
            baseURL=String.valueOf(Network.getLoginUrl(myCommunity[0].id));
            baseURL=baseURL.split('/login')[0];
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
        
        for(CaseComment cc:caseCommNewMap){   
            
            String commenityurl = baseURL+'/s/case/';
            String communityPublicPageUrl = baseURL+'/s/casedetailpage?id=';
            User u=new User();
            if((!userMap.isEmpty()) && userMap.containsKey(cc.CreatedById) ){
                u = userMap.get(cc.CreatedById);  
            }            
            Case c1=new Case();
            
            if((!createdCaseMap.isEmpty()) && createdCaseMap.containsKey(cc.ParentId) ){
                c1 = createdCaseMap.get(cc.ParentId);
                commenityurl += c1.Id;
                communityPublicPageUrl += c1.Id;  
            }
           // Case c1 = createdCaseMap.get(cc.ParentId);
            //user caseuser = userMap.get(c1.CreatedById);
            //System.debug('caseuser ID : '+caseuser.Id);
            //System.debug('commentuser ID : '+u.Id);
           // System.debug('c1.id : '+c1.id);
                      
            
            if(c1.recordTypeId==Case_recordTypeId){
                //Id TM_Id=accOwnerMap.get(accountIdMap.get(c1.Id));
                String accsales = c1.AccountId+'-'+c1.SalesOrg__c;
                Id terrId = accterrMap.get(accsales);
                String TM_Id = tmMap.get(terrId)+'-'+c1.SalesOrg__c;
                system.debug('Case TM_Id==='+TM_Id);
                if(c1.CaseOwner__c.contains('C & F')){
                    //System.debug('cnfMap.get(TM_Id) : '+cnfMap.get(TM_Id));
                    if(!cnfMap.isEmpty() && cnfMap.containsKey(TM_Id)){
                        if(cnfMap.get(TM_Id) !=  null){
                            if(cnfMap.get(TM_Id).contains(',')){
                                String[] emailArray=cnfMap.get(TM_Id).split(',');
                                for(Integer i=0;i<emailArray.size();i++){
                                    Messaging.Singleemailmessage email = Grz_CaseCommentController.handledynamicEmailNew(emailtemp,u.Id,c1,emailArray[i],communityPublicPageUrl,fromAdressId,emailNameMap,caseCommentMap);
                                    emailListFull.add(email);
                                }
                            }
                            else{
                                Messaging.Singleemailmessage email = Grz_CaseCommentController.handledynamicEmailNew(emailtemp,u.Id,c1,cnfMap.get(TM_Id),communityPublicPageUrl,fromAdressId,emailNameMap,caseCommentMap);
                                emailListFull.add(email);
                            }
                        }    
                    }
                }
                if(c1.CaseOwner__c.contains('RCM')){
                    //System.debug('rcmMap.get(TM_Id) : '+rcmMap.get(TM_Id));
                    if(!rcmMap.isEmpty() && rcmMap.containsKey(terrId)){
                        if(rcmMap.get(terrId) !=  null){
                            Messaging.Singleemailmessage email2 = handledynamicEmailNew(emailtemp,u.Id,c1,rcmMap.get(terrId),communityPublicPageUrl,fromAdressId,emailNameMap,caseCommentMap);
                            emailListFull.add(email2);
                        }   
                    }
                }
                if(c1.CaseOwner__c.contains('LOGISTICS HO')){
                    if(!emailUserMap.isEmpty() && emailUserMap.containsKey('LOGISTICS HO')){
                        if(emailUserMap.get('LOGISTICS HO') != null){
                            Messaging.Singleemailmessage email3 = handledynamicEmailNew(emailtemp,u.Id,c1,emailUserMap.get('LOGISTICS HO'),communityPublicPageUrl,fromAdressId,emailNameMap,caseCommentMap);
                            emailListFull.add(email3); 
                        }                          
                    }
                }
                if(c1.CaseOwner__c.contains('HO Finance')){
                    if(!emailUserMap.isEmpty() && emailUserMap.containsKey('HO Finance')){
                        if(emailUserMap.get('HO Finance') != null){
                            Messaging.Singleemailmessage email4 = handledynamicEmailNew(emailtemp,u.Id,c1,emailUserMap.get('HO Finance'),communityPublicPageUrl,fromAdressId,emailNameMap,caseCommentMap);
                            emailListFull.add(email4);
                        }                            
                    }
                }
                if(c1.CaseOwner__c.contains('FCE')){
                    if(!emailUserMap.isEmpty() && emailUserMap.containsKey('FCE')){
                        if(emailUserMap.get('FCE') != null){
                            Messaging.Singleemailmessage email4 = handledynamicEmailNew(emailtemp,u.Id,c1,emailUserMap.get('FCE'),communityPublicPageUrl,fromAdressId,emailNameMap,caseCommentMap);
                            emailListFull.add(email4);
                        }                            
                    }
                }
                if(c1.CaseOwner__c.contains('Sales excellence')){
                    if(!emailUserMap.isEmpty() && emailUserMap.containsKey('Sales excellence')){
                        if(emailUserMap.get('Sales excellence') != null){
                            Messaging.Singleemailmessage email5 = handledynamicEmailNew(emailtemp,u.Id,c1,emailUserMap.get('Sales excellence'),communityPublicPageUrl,fromAdressId,emailNameMap,caseCommentMap);
                            emailListFull.add(email5);
                        }                            
                    }
                }
                if(c1.CaseOwner__c.contains('CROP MANAGER')){
                    if(!emailUserMap.isEmpty() && emailUserMap.containsKey('CROP MANAGER')){
                        if(emailUserMap.get('CROP MANAGER') != null){
                            Messaging.Singleemailmessage email5 = handledynamicEmailNew(emailtemp,u.Id,c1,emailUserMap.get('CROP MANAGER'),communityPublicPageUrl,fromAdressId,emailNameMap,caseCommentMap);
                            emailListFull.add(email5);
                        }                            
                    }
                }
                if(c1.CaseOwner__c.contains('ZSM')){
                    System.debug('In zsmMap If');
                    if(!zsmMap.isEmpty() && zsmMap.containsKey(terrId) && !userMap.isEmpty() && userMap.containsKey(zsmMap.get(terrId))){
                        System.debug('zsmMap : '+userMap.get(zsmMap.get(terrId)).Email); 
                        if(userMap.get(zsmMap.get(terrId)).Email != null){
                            Messaging.Singleemailmessage email6 = Grz_CaseCommentController.handledynamicEmailNew(emailtemp,u.Id,c1,userMap.get(zsmMap.get(terrId)).Email,communityPublicPageUrl,fromAdressId,emailNameMap,caseCommentMap);
                            emailListFull.add(email6);
                        }                            
                    }
                }
                
                
                if(c1.CreatedById != UserInfo.getUserId() && c1.CaseOwner__c!=null){
                    System.debug('If Comment Created User is not Case Owner : '+c1.Owner.Email);
                    
                    if(c1.Owner.Email != null){
                        Messaging.Singleemailmessage email7 = handledynamicEmailNew(emailtemp,u.Id,c1,c1.Owner.Email,commenityurl,fromAdressId,emailNameMap,caseCommentMap);
                        emailListFull.add(email7);
                    }                    
                }
            }  
            
        } 
        try{
            System.debug('emailListFull : '+emailListFull);
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
        
    }*/  
    
    
    public void sendEmailOnCaseComment(List<CaseComment> caseCommNewMap){
        List<Id> caseCreateduserId = new List<Id>();
        List<Id> caseIds=new List<Id>();
        
         for(CaseComment cc:caseCommNewMap){
            //System.debug('cc.Parent.Status : ' + cc.Parent.Status );
          
               if(cc.IsPublished == True){                
                if(String.valueof(cc.ParentId).startsWith('500')){
                    caseCreateduserId.add(cc.CreatedById); 
                 
                   caseIds.add(cc.ParentId);
            
              }           
            }             
        }
        
        Map<Id,Case> createdCaseMap=new Map<Id,Case>([Select Id,CaseNumber, catesub__c, sub_category__c, CreatedDate,AccountId,SalesOrg__c,CreatedById,CaseOwner__c,Owner.Email,recordTypeId,Type,Status,Subject,Description,Closeddate,(SELECT Id, ParentId, IsPublished, CommentBody, CreatedById, CreatedDate, createdby.name FROM CaseComments where IsPublished=true order by LastModifiedDate desc limit 5) from Case where Id IN :caseIds and caseowner__c!=null]);
        Map<Id,List<CaseComment>> caseCommentMap=new Map<Id,List<CaseComment>>();        
        
        Map<Id,Id> casecreateIdMap=new Map<Id,Id>();
        Map<Id,Id> accountIdMap=new Map<Id,Id>();
        for(Case c:createdCaseMap.values()){ 
            if(c.caseowner__c!=null){
                caseCreateduserId.add(c.CreatedById); 
                casecreateIdMap.put(c.Id,c.createdById);
                accountIdMap.put(c.Id,c.AccountId);
                caseCommentMap.put(c.Id,c.CaseComments);
            }
        }
        
        Set<String> introTextList=new Set<String>();
        
        Map<String,String> emailUserMap = new Map<String,String>();
        for(Partner_Portal_Configuration__c ppc:[Select Name,Description__c from Partner_Portal_Configuration__c where Recordtype.Name = 'CaseConfiguration']){
            emailUserMap.put(ppc.Name,ppc.Description__c);
            introTextList.add(ppc.Description__c);
        }
        
        Map<Id,Id> accOwnerMap=new Map<Id,Id>();
        Map<Id,Account> accountMap=new Map<Id,Account>();
        for(Account a:[Select id,ownerid,SAP_Code__c,Name from Account where Id  IN :accountIdMap.values()]){
            accOwnerMap.put(a.Id,a.ownerid);
             accountMap.put(a.Id,a);
        }
        System.debug('accOwnerMap : '+accOwnerMap);
        
        Map<Id,String> rcmMap=new Map<Id,String>();
        Map<Id,Id> zsmMap=new Map<Id,Id>();
        for(Territory_Distributor__c td:[Select Id, RCM_Email__c,TerritoryManager__c,ZSM_Id__c from Territory_Distributor__c where TerritoryManager__c  IN :accOwnerMap.values()]){
            rcmMap.put(td.TerritoryManager__c,td.RCM_Email__c);
            zsmMap.put(td.TerritoryManager__c,td.ZSM_Id__c);
            introTextList.add(td.RCM_Email__c);
            introTextList.add(td.ZSM_Id__c);
        }
        System.debug('rcmMap : '+rcmMap);
        System.debug('zsmMap : '+zsmMap);
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
        System.debug('cnfMap : '+cnfMap);
        Id loggedInUser=userInfo.getUserId();
        Map<Id,User> userMap=new Map<Id,User>([Select Id,Name,ProfileId,Profile.Name,MobilePhone,Email from User where Id IN :caseCreateduserId or ID =:loggedInUser or Id IN :zsmMap.values()]);
        System.debug('userMap : '+userMap);
        Id Case_recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        
        List <Messaging.Singleemailmessage> emailListFull = new List <Messaging.Singleemailmessage>();
        List<EmailTemplate> emailtemp = [SELECT Id,body,HtmlValue,subject FROM EmailTemplate WHERE DeveloperName = 'CaseCommentEmailTemplate' Limit 1];    
        
        List<EmailTemplate> emailtemp1 = [SELECT Id,body,HtmlValue,subject FROM EmailTemplate WHERE DeveloperName = 'CaseCommentEmailTemplate1' Limit 1];  //  Additional Line      
       
        OrgWideEmailAddress owa = [select id, DisplayName, Address from OrgWideEmailAddress where displayname =: 'Sales Excellence'];
        String fromAdressId = owa.id;
        
        String baseURL='';       
        List<Network> myCommunity = [SELECT Id FROM Network WHERE Name = 'UPL Partner Portal'];
        if(!myCommunity.isEmpty()){
            baseURL=String.valueOf(Network.getLoginUrl(myCommunity[0].id));
            baseURL=baseURL.split('/login')[0];
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
        
        
        for(CaseComment cc:caseCommNewMap){   
            
             String caseCreatedBy='';
            String accName='';
            String accSapCode='';
            if(!userMap.isEmpty() && userMap.containsKey(loggedInUser)){
                 caseCreatedBy=userMap.get(loggedInUser).Name;
            }
            if( !accountIdMap.isEmpty() && accountIdMap.containsKey(cc.parentId)){
                Id accId=accountIdMap.get(cc.parentId);
                if(!accountMap.isEmpty() && accountMap.containsKey(accId)){
                     accName=accountMap.get(accId).Name;
                        accSapCode=accountMap.get(accId).SAP_Code__c;
                }
            
            }
            
            //String commUrl = URL.getSalesforceBaseUrl().toExternalForm()+ '/';
             // String commUrl = [SELECT InstanceName FROM Organization LIMIT 1].InstanceName + '/';         // 'https://' + 'upl--uat.lightning.force.com/'; // https://upl--uat.lightning.force.com/lightning/r/Case/5001m000006qBQuAAM/view 
            
            Organization org = [SELECT InstanceName FROM Organization];                        //  Additinal Line
            String commUrl = 'https://' + org.InstanceName + '.salesforce.com/';               //  Additional Line  
            
            String commenityurl = baseURL+'/s/case/';
            String communityPublicPageUrl = baseURL+'/s/casedetailpage?id=';
            User u=new User();
            if((!userMap.isEmpty()) && userMap.containsKey(cc.CreatedById) ){
                u = userMap.get(cc.CreatedById);  
            }            
            Case c1=new Case();
            if((!createdCaseMap.isEmpty()) && createdCaseMap.containsKey(cc.ParentId) ){
                c1 = createdCaseMap.get(cc.ParentId);
                commUrl += c1.Id;                       //  Additional Line  
                commenityurl += c1.Id;
                 communityPublicPageUrl += c1.Id;  
            }
           // Case c1 = createdCaseMap.get(cc.ParentId);
            //user caseuser = userMap.get(c1.CreatedById);
            //System.debug('caseuser ID : '+caseuser.Id);
            //System.debug('commentuser ID : '+u.Id);
           // System.debug('c1.id : '+c1.id);
                      
            
            if(c1.recordTypeId==Case_recordTypeId){
                Id TM_Id=accOwnerMap.get(accountIdMap.get(c1.Id));
                if(c1.CaseOwner__c.contains('C & F')){
                    System.debug('cnfMap.get(TM_Id) : '+cnfMap.get(TM_Id));
                    if(!cnfMap.isEmpty() && cnfMap.containsKey(TM_Id)){
                        if(cnfMap.get(TM_Id) !=  null){
                            if(cnfMap.get(TM_Id).contains(',')){
                                String[] emailArray=cnfMap.get(TM_Id).split(',');
                                for(Integer i=0;i<emailArray.size();i++){
                                    Messaging.Singleemailmessage email = handledynamicEmailNew(emailtemp,u.Id,c1,emailArray[i],communityPublicPageUrl,fromAdressId,emailNameMap,caseCommentMap,caseCreatedBy,accName,accSapCode);
                                    emailListFull.add(email);
                                }
                            }
                            else{
                                Messaging.Singleemailmessage email = handledynamicEmailNew(emailtemp,u.Id,c1,cnfMap.get(TM_Id),communityPublicPageUrl,fromAdressId,emailNameMap,caseCommentMap,caseCreatedBy,accName,accSapCode);
                                emailListFull.add(email);
                            }
                        }    
                    }
                }
                if(c1.CaseOwner__c.contains('RCM')){
                    System.debug('rcmMap.get(TM_Id) : '+rcmMap.get(TM_Id));
                    if(!rcmMap.isEmpty() && rcmMap.containsKey(TM_Id)){
                        if(rcmMap.get(TM_Id) !=  null){
                            Messaging.Singleemailmessage email2 = handledynamicEmailNew(emailtemp,u.Id,c1,rcmMap.get(TM_Id),communityPublicPageUrl,fromAdressId,emailNameMap,caseCommentMap,caseCreatedBy,accName,accSapCode);
                            emailListFull.add(email2);
                        }   
                    }
                }
                if(c1.CaseOwner__c.contains('LOGISTICS HO')){
                    if(!emailUserMap.isEmpty() && emailUserMap.containsKey('LOGISTICS HO')){
                        if(emailUserMap.get('LOGISTICS HO') != null){
                            Messaging.Singleemailmessage email3 = handledynamicEmailNew(emailtemp,u.Id,c1,emailUserMap.get('LOGISTICS HO'),communityPublicPageUrl,fromAdressId,emailNameMap,caseCommentMap,caseCreatedBy,accName,accSapCode);
                            emailListFull.add(email3); 
                        }                          
                    }
                }
                if(c1.CaseOwner__c.contains('HO Finance')){
                    if(!emailUserMap.isEmpty() && emailUserMap.containsKey('HO Finance')){
                        if(emailUserMap.get('HO Finance') != null){
                            Messaging.Singleemailmessage email4 = handledynamicEmailNew(emailtemp,u.Id,c1,emailUserMap.get('HO Finance'),communityPublicPageUrl,fromAdressId,emailNameMap,caseCommentMap,caseCreatedBy,accName,accSapCode);
                            emailListFull.add(email4);
                        }                            
                    }
                }
                //code added for handle owner assignment tracking GRZ(Swaranjeet) Jira Ticket No. APPS-3667 modified on 13-12-2022
                 if(c1.CaseOwner__c.contains('Dr H. M Joshi,Ved Prakash,Nilesh Patel,Ram Gopal')){
                   system.debug('grazitti---');
                     if(!emailUserMap.isEmpty() && emailUserMap.containsKey('Quality Complaint Level 1')){
                         List<String> emails123 = emailUserMap.get('Quality Complaint Level 1').split(',');
                         for(Integer i=0;i<emails123.size();i++){
                             
                             Messaging.Singleemailmessage email123 = Grz_CaseCommentController.handledynamicEmailNew(emailtemp,u.Id,c1,emails123[i],communityPublicPageUrl,fromAdressId,emailNameMap,caseCommentMap,caseCreatedBy,accName,accSapCode);
                             emailListFull.add(email123);
                             system.debug('emailListFull--- '+emailListFull);
                         }                             
                    }
                }
                if(c1.CaseOwner__c.contains('FCE')){
                    if(!emailUserMap.isEmpty() && emailUserMap.containsKey('FCE')){
                        if(emailUserMap.get('FCE') != null){
                            Messaging.Singleemailmessage email5 = handledynamicEmailNew(emailtemp,u.Id,c1,emailUserMap.get('FCE'),communityPublicPageUrl,fromAdressId,emailNameMap,caseCommentMap,caseCreatedBy,accName,accSapCode);
                            emailListFull.add(email5);
                        }                            
                    }
                }
                if(c1.CaseOwner__c.contains('Sales excellence')){
                    if(!emailUserMap.isEmpty() && emailUserMap.containsKey('Sales excellence')){
                        if(emailUserMap.get('Sales excellence') != null){
                            Messaging.Singleemailmessage email6 = handledynamicEmailNew(emailtemp,u.Id,c1,emailUserMap.get('Sales excellence'),communityPublicPageUrl,fromAdressId,emailNameMap,caseCommentMap,caseCreatedBy,accName,accSapCode);
                            emailListFull.add(email6);
                        }                            
                    }
                }
                if(c1.CaseOwner__c.contains('CROP MANAGER')){
                    if(!emailUserMap.isEmpty() && emailUserMap.containsKey('CROP MANAGER')){
                        if(emailUserMap.get('CROP MANAGER') != null){
                            Messaging.Singleemailmessage email7 = handledynamicEmailNew(emailtemp,u.Id,c1,emailUserMap.get('CROP MANAGER'),communityPublicPageUrl,fromAdressId,emailNameMap,caseCommentMap,caseCreatedBy,accName,accSapCode);
                            emailListFull.add(email7);
                        }                            
                    }
                }
                if(c1.CaseOwner__c.contains('ZSM')){
                    System.debug('In zsmMap If');
                    if(!zsmMap.isEmpty() && zsmMap.containsKey(TM_Id) && !userMap.isEmpty() && userMap.containsKey(zsmMap.get(TM_Id))){
                        System.debug('zsmMap : '+userMap.get(zsmMap.get(TM_Id)).Email); 
                        if(userMap.get(zsmMap.get(TM_Id)).Email != null){
                            Messaging.Singleemailmessage email8 = Grz_CaseCommentController.handledynamicEmailNew(emailtemp,u.Id,c1,userMap.get(zsmMap.get(TM_Id)).Email,communityPublicPageUrl,fromAdressId,emailNameMap,caseCommentMap,caseCreatedBy,accName,accSapCode);
                            emailListFull.add(email8);
                        }                            
                    }
                }
                //changes made for sending mails from  UPL IT Support to case creator
                if(c1.CaseOwner__c.contains('UPL IT support')){
                    if(!emailUserMap.isEmpty() && emailUserMap.containsKey('UPL IT support')){
                        if(emailUserMap.get('UPL IT support') != null){
                            Messaging.Singleemailmessage email7 = handledynamicEmailNew(emailtemp,u.Id,c1,emailUserMap.get('UPL IT support'),commenityurl,fromAdressId,emailNameMap,caseCommentMap,caseCreatedBy,accName,accSapCode);
                            emailListFull.add(email7);
                        }                            
                    }
                }
                
                if(c1.CreatedById != UserInfo.getUserId() && c1.CaseOwner__c!=null && c1.Sub_Category__c == null){ //  && c1.catesub__c == null && c1.Sub_Category__c == null
                    System.debug('If Comment Created User is not Case Owner : '+c1.Owner.Email);
                    
                    if(c1.Owner.Email != null){
                        Messaging.Singleemailmessage email9 = handledynamicEmailNew(emailtemp,u.Id,c1,c1.Owner.Email,commenityurl,fromAdressId,emailNameMap,caseCommentMap,caseCreatedBy,accName,accSapCode);
                        emailListFull.add(email9);
                    }                    
                } 
                
                
                //  Additional Line Begins Here  //
                
                if(c1.CreatedById != UserInfo.getUserId() && c1.CaseOwner__c!=null && (c1.catesub__c == 'Complaint' || c1.catesub__c == 'Request')){  //  && (c1.catesub__c == 'Complaint' || c1.catesub__c == 'Request')
                    System.debug('If Comment Created User is not Case Owner : '+c1.Owner.Email);
                    
                    if(c1.Owner.Email != null){ 
                        Messaging.Singleemailmessage email9 = handledynamicEmailNew(emailtemp1,u.Id,c1,c1.Owner.Email,commUrl,fromAdressId,emailNameMap,caseCommentMap,caseCreatedBy,accName,accSapCode);
                        emailListFull.add(email9);
                    }                    
                }  
                
               //  Additional Line End Here  //////////////////////// 
            }  
            
        } 
        try{
            System.debug('emailListFull : '+emailListFull);
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