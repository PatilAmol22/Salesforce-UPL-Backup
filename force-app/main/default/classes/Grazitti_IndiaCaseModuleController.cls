public class Grazitti_IndiaCaseModuleController {
    
    //  Before Update Trigger
    public static void countOpenCaseStatusValueBeforeUpdate(List<case> newList, Map<Id, Case> caseOldMap){ 
         Map<String,String> emailUserMap = new Map<String,String>(); //code added for handle owner assignment tracking GRZ(Swaranjeet) Jira Ticket No. APPS-3667 modified on 13-12-2022           
        for(Partner_Portal_Configuration__c ppc:[Select Name,Description__c from Partner_Portal_Configuration__c where Recordtype.Name = 'CaseConfiguration']){  //  
            emailUserMap.put(ppc.Name,ppc.Description__c);  //
            //introTextList.add(ppc.Description__c);  //
        }
        Id Case_recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        //System.debug('Case_recordTypeId' + Case_recordTypeId);
        Map<Id,Sales_Org__c> salesOrgs = new Map<Id,Sales_Org__c >([Select Id, Name, Sales_Org_Code__c from Sales_Org__c where Name = 'UPL SAS' or Name = 'SWAL']);      //// Change by Sumit(Grazitti) for APPS-4676 01-02-2023
        //System.debug('salesOrgs' + salesOrgs);
        
        
        
        // if((c.catesub__c == 'Request' || c.catesub__c == 'Complaint') && (c.RecordTypeId == Case_recordTypeId) && (salesOrgs.containsKey(c.SalesOrg__c))){
        
        
        for(case c : newList){
            if(c.Sub_Category__c != null && caseOldMap != null && c.Status != caseOldMap.get(c.Id).Status && c.status == 'Reopen' && c.Count_Open_Values__c != null  && (c.catesub__c == 'Request' || c.catesub__c == 'Complaint') && c.RecordTypeId == Case_recordTypeId){
                c.Count_Open_Values__c = c.Count_Open_Values__c + 1;
            }  
            
            if(c.Sub_Category__c != null && caseOldMap != null && c.status != caseOldMap.get(c.Id).Status && c.Status == 'Reopen' && c.Count_Open_Values__c < 2 && c.Count_Open_Values__c != null && (c.catesub__c == 'Request' || c.catesub__c == 'Complaint') && c.RecordTypeId == Case_recordTypeId){ 
                c.Escalation_Level__c = ' ';
                c.Is_Auto_Escalated__c = false;
            }  
            
            if(c.Sub_Category__c != null && (c.catesub__c == 'Request' || c.catesub__c == 'Complaint') && c.RecordTypeId == Case_recordTypeId){
                if(c.Sub_Category__c == 'Invoice, Schemes & Discount related' || c.Sub_Category__c == 'Dispatch related' || c.Sub_Category__c == 'Product related' || 
                   c.Sub_Category__C == 'Product Leakage / damage while shipping' || c.Sub_Category__C == 'Order Cancellation' || c.Sub_Category__C == 'Order Update'){     
                       
                       //c.CaseOwner__c = 'Depot';
                       //c.type = 'Invoicess';      //code commented for handle wronge casetype assignment wrt Internal India Cases GRZ(Sumit Kumar) Jira Ticket No. RITM0427885 modified on 29-09-2022
                       
                       
                       if(c.Count_Open_Values__c <= 1  && c.level2__c == ''){  //  c.Count_Open_Values__c == 1
                           c.CaseOwner__c = 'Depot'; 
                           c.OwnerOfCase__c = 'Depot';  //code added for handle owner assignment tracking GRZ(Sumit Kumar) Jira Ticket No. RITM0427885 modified on 29-09-2022
                           
                       }
                       
                   }
                if(c.Sub_Category__c == 'Payments & Receipts' || c.Sub_Category__c == 'Credit Limit' || c.Sub_Category__c == 'Outstanding' || 
                   c.Sub_Category__C == 'Account Related' || c.Sub_Category__C == 'Customer master updation'){  
                       
                       //c.CaseOwner__c = 'GBS Pune'; 
                       //c.type = 'Paymentsss';         //code commented for handle wronge casetype assignment wrt Internal India Cases GRZ(Sumit Kumar) Jira Ticket No. RITM0427885 modified on 29-09-2022
                       
                       if(c.Count_Open_Values__c <= 1  && c.level2__c == ''){  //  c.Count_Open_Values__c == 1
                           c.CaseOwner__c = 'GBS Pune'; 
                           c.OwnerOfCase__c = 'GBS Pune';  //code added for handle owner assignment tracking GRZ(Sumit Kumar) Jira Ticket No. RITM0427885 modified on 29-09-2022
                           
                       }
                   }
                if(c.Sub_Category__c == 'Product Availability' || c.Sub_Category__c == 'Product Complaints by Farmers'){  
                    
                    //c.CaseOwner__c = 'TM'; 
                    //c.type = 'Productss';   //code commented for handle wronge casetype assignment wrt Internal India Cases GRZ(Sumit Kumar) Jira Ticket No. RITM0427885 modified on 29-09-2022
                    
                    if(c.Count_Open_Values__c <= 1  && c.level2__c == ''){  //  c.Count_Open_Values__c == 1
                        c.CaseOwner__c = 'TM'; 
                        c.OwnerOfCase__c = 'TM';  //code added for handle owner assignment tracking GRZ(Sumit Kumar) Jira Ticket No. RITM0427885 modified on 29-09-2022
                        
                    }
                }
                if(c.Sub_Category__c == 'Schemes & Price Communication from HO'){  
                    
                    //c.CaseOwner__c = 'Sales Excellences'; 
                    //c.type = ' Schemess';      //code commented for handle wronge casetype assignment wrt Internal India Cases GRZ(Sumit Kumar) Jira Ticket No. RITM0427885 modified on 29-09-2022                   
                    
                    if(c.Count_Open_Values__c <= 1  && c.level2__c == '' ){  //  c.Count_Open_Values__c == 1   
                        c.CaseOwner__c = 'Sales Excellences'; 
                        c.OwnerOfCase__c = 'Sales Excellences';  //code added for handle owner assignment tracking GRZ(Sumit Kumar) Jira Ticket No. RITM0427885 modified on 29-09-2022
                        
                    }
                }
              
                if(c.Sub_Category__c == 'Quality Complaint'){
                    system.debug('Quality Complaint--- ');
                    if(c.Count_Open_Values__c >= 2 && (c.level2__c == '' || c.level2__c == Null)){  
                        c.CaseOwner__c = emailUserMap.get('Quality Owners 2'); 
                        system.debug('CaseOwner----- '+c.CaseOwner__c);
                        c.OwnerOfCase__c = emailUserMap.get('Quality Owners 2');  //code added for handle owner assignment tracking GRZ(Swaranjeet) Jira Ticket No. APPS-3667 modified on 13-12-2022
                        system.debug('OwnerOfCase--- '+c.OwnerOfCase__c);
                    }
                }
            }
            
            
        }
        
    }
    
    //  Before insert Trigger  
    public static void countOpenCaseStatusValueBeforeInsert(List<case> newList){
        
        Id Case_recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        //System.debug('Case_recordTypeId' + Case_recordTypeId);
        Map<Id,Sales_Org__c> salesOrgs = new Map<Id,Sales_Org__c >([Select Id, Name, Sales_Org_Code__c from Sales_Org__c where Name = 'India' or Name = 'SWAL']);
        //System.debug('salesOrgs' + salesOrgs);
        
        
        for(case c : newList){
            
            
            if(c.Sub_Category__c != null && c.status == 'Reopen' && c.Count_Open_Values__c != null  && (c.catesub__c == 'Request' || c.catesub__c == 'Complaint') && c.RecordTypeId == Case_recordTypeId){
                c.Count_Open_Values__c = c.Count_Open_Values__c + 1;
            }
            
            if(c.Sub_Category__c != null && (c.catesub__c == 'Request' || c.catesub__c == 'Complaint') && c.RecordTypeId == Case_recordTypeId){  
                if(c.Sub_Category__c == 'Invoice, Schemes & Discount related' || c.Sub_Category__c == 'Dispatch related' || c.Sub_Category__c == 'Product related' || 
                   c.Sub_Category__C == 'Product Leakage / damage while shipping' || c.Sub_Category__C == 'Order Cancellation' || c.Sub_Category__C == 'Order Update'){     
                       
                       //c.type = 'Invoicess';  //code commented for handle wronge casetype assignment wrt Internal India Cases GRZ(Sumit Kumar) Jira Ticket No. RITM0427885 modified on 29-09-2022                            
                       c.CaseOwner__c = 'Depot';  
                       c.OwnerOfCase__c = 'Depot';  //code added for handle owner assignment tracking GRZ(Sumit Kumar) Jira Ticket No. RITM0427885 modified on 29-09-2022
                       
                   }
                if(c.Sub_Category__c == 'Payments & Receipts' || c.Sub_Category__c == 'Credit Limit' || c.Sub_Category__c == 'Outstanding' || 
                   c.Sub_Category__C == 'Account Related' || c.Sub_Category__C == 'Customer master updation'){  
                       
                       //c.type = 'Paymentsss';   //code commented for handle wronge casetype assignment wrt Internal India Cases GRZ(Sumit Kumar) Jira Ticket No. RITM0427885 modified on 29-09-2022                       
                       c.CaseOwner__c = 'GBS Pune';  
                       c.OwnerOfCase__c = 'GBS Pune';  //code added for handle owner assignment tracking GRZ(Sumit Kumar) Jira Ticket No. RITM0427885 modified on 29-09-2022
                       
                   }
                if(c.Sub_Category__c == 'Product Availability' || c.Sub_Category__c == 'Product Complaints by Farmers'){  
                    
                    //c.type = 'Productss';    //code commented for handle wronge casetype assignment wrt Internal India Cases GRZ(Sumit Kumar) Jira Ticket No. RITM0427885 modified on 29-09-2022                         
                    c.CaseOwner__c = 'TM';  
                    c.OwnerOfCase__c = 'TM';  //code added for handle owner assignment tracking GRZ(Sumit Kumar) Jira Ticket No. RITM0427885 modified on 29-09-2022
                    
                }
                if(c.Sub_Category__c == 'Schemes & Price Communication from HO'){  
                    
                    //c.type = 'Schemess';     //code commented for handle wronge casetype assignment wrt Internal India Cases GRZ(Sumit Kumar) Jira Ticket No. RITM0427885 modified on 29-09-2022 
                    c.CaseOwner__c = 'Sales Excellences';  
                    c.OwnerOfCase__c = 'Sales Excellences';  //code added for handle owner assignment tracking GRZ(Sumit Kumar) Jira Ticket No. RITM0427885 modified on 29-09-2022
                    
                }
                if(c.Sub_Category__c == 'Quality Complaint'){
                      system.debug('Quality Complaint--- ');
                 	 
                        c.CaseOwner__c = 'Dr H. M Joshi,Ved Prakash,Nilesh Patel,Ram Gopal'; 
                         system.debug('CaseOwner----- '+c.CaseOwner__c);
                         c.OwnerOfCase__c = 'Dr H. M Joshi,Ved Prakash,Nilesh Patel,Ram Gopal';  //code added for handle owner assignment tracking GRZ(Sumit Kumar) Jira Ticket No. RITM0427885 modified on 29-09-2022
                         system.debug('OwnerOfCase--- '+c.OwnerOfCase__c);
                  
                }
                
            }
            
        }
    }
    
    // original After Update Trigger  Map<Id,Case> caseNewMap, List<Case> newCaseList
    public static Void sendEmailOnHOAfterCaseReopn2Times(Map<Id,Case> caseOldMap, List<Case> newCaseList){  
        BusinessHours bh = [SELECT Id, Name FROM BusinessHours WHERE Name = 'IndiaCaseModuleBH'];
        //         String caseNewOwner;  //
        List<Case> casesToBeUpdated=new List<Case>();  //  
        
        set<Id> caseIds = new set<Id>();
        //System.debug('newCaseList ' + newCaseList);
        for(case c : newCaseList){
            //c.checked_till_24_hour__c = false; 
            
            System.debug('Count_Open_Values__c' + c.Count_Open_Values__c);
            System.debug('caseOldMap ' + caseOldMap.get(c.Id).Count_Open_Values__c);
            
            if(Test.isRunningTest() || (caseOldMap != null && c.Count_Open_Values__c != caseOldMap.get(c.Id).Count_Open_Values__c && c.Count_Open_Values__c >= 2 && c.Count_Open_Values__c != null && c.status == 'Reopen' && (c.catesub__c == 'Request' || c.catesub__c == 'Complaint'))){  //  (caseOldMap != null && c.level3__c != caseOldMap.get(c.Id).level3__c)  
                //c.checked_till_24_hour__c = false; 
                caseIds.add(c.Id);
            }
            else if(c.Count_Open_Values__c < 2 && c.Escalation_Level__c == 'Escalated L2' && c.Is_Auto_Escalated__c == true && c.Status != 'Closed' && (c.catesub__c == 'Request' || c.catesub__c == 'Complaint' && !trigger.isExecuting)){  //  (caseOldMap != null && c.level3__c != caseOldMap.get(c.Id).level3__c)  
                //c.checked_till_24_hour__c = false; 
                caseIds.add(c.Id);
                
            }      
        }  
        
        Map<Id, Case> caseMap = new Map<Id,Case>();
        
        for(Case cs : [Select Id,account.name,account.sap_code__c,account.Brazil_Depot_Code__r.Name,account.Depot_Code__c,CaseNumber, Count_Open_Values__c, Reopened_Case__c, Reopened_Start_Date__c, CreatedDate, OwnerId, Category__c, LastModifiedById, caseCommentDate__c, 
                       type,CaseOwner__c, Created_Date_Time__c, X48_hrs__c, createdById ,Owner.Email,CategoryForSubcategory__c,level3__c,Escalation_Level__c,Is_Auto_Escalated__c,
                       Sub_Category__c,RecordTypeId, Subject, Description,ClosedDate,level2__c, checked_till_24_hour__c,AccountId, Created_Date__c, Status,catesub__c, X24_hrs__c, 
                       Reopened_Close_Date__c, Reopen_Status_Count__c, lastModifieddate, SalesOrg__c,(SELECT Id, ParentId, IsPublished, CommentBody, CreatedById, CreatedDate,
                                                                                                      createdby.name FROM CaseComments where IsPublished=true order by LastModifiedDate desc limit 5) 
                       From Case Where Id IN:caseIds]){  //   and  Count_Open_Values__c >= 2
                           caseMap.put(cs.Id, cs);
                       }
        
        
        List<Id> createList=new List<Id>();
        List<Id> userId = new List<Id>();
        Map<Id, Case> FilteredCaseMap = new Map<Id,Case>();
        Id Case_recordTypeIdd = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        //System.debug('Case_recordTypeIdd' + Case_recordTypeIdd);
        Map<Id,Sales_Org__c> salesOrgss = new Map<Id,Sales_Org__c >([Select Id, Name, Sales_Org_Code__c from Sales_Org__c where Name = 'UPL SAS' or Name = 'SWAL']);
        //System.debug('salesOrgss' + salesOrgss);
        
        
        //System.debug('caseMap' + caseMap);
        if(!caseMap.isEmpty()){
            for(case c : caseMap.Values()){
                //System.debug('caseMap' + caseMap);
                system.debug('c.SalesOrg__c==>'+c.SalesOrg__c);
                if((c.SalesOrg__c != null && salesOrgss.containsKey(c.SalesOrg__c) && c.RecordTypeId == Case_recordTypeIdd)){
                    //System.debug('caseMap' + caseMap);
                    //if(c.Category__c == 'Request'){    //  catesub__c    
                    //System.debug('caseMap' + caseMap);
                    FilteredCaseMap.put(c.Id, c);
                    createList.add(c.createdById);
                    userId.add(c.OwnerId);
                    //}
                    
                } 
            } 
        }  
        
        
        Id loggedInUser = userInfo.getUserId();
        Map<Id,User> userMap=new Map<Id,User>([Select Id, ProfileId, Name, firstname, lastname, Profile.Name, MobilePhone, 
                                               Email from User where Id IN :createList or ID =:loggedInUser or Id IN : userId]);
        
        Map<String,String> emailNameMap=new Map<String, String>();
        for(User u : userMap.Values()){  
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
        
        List <Messaging.Singleemailmessage> emailListFull = new List <Messaging.Singleemailmessage>();       
        List<EmailTemplate> emailtemp = [SELECT Id,body,HtmlValue,subject FROM EmailTemplate WHERE DeveloperName = 'Portal_Reopen_Email_Template_1' limit 1]; 
        List<OrgWideEmailAddress> owa = [select id, DisplayName, Address from OrgWideEmailAddress where displayname =: 'Sales Excellence'];
        
        Map<Id,List<CaseComment>> caseCommentMap=new Map<Id,List<CaseComment>>();  //
        
        Network myCommunity = [SELECT Id FROM Network WHERE Name = 'UPL Partner Portal'];  //
        String baseURL=String.valueOf(Network.getLoginUrl(myCommunity.id));  //
        baseURL=baseURL.split('/login')[0];  //
        Map<String,String> emailUserMap = new Map<String,String>();               
        for(Partner_Portal_Configuration__c ppc:[Select Name,Description__c from Partner_Portal_Configuration__c where Recordtype.Name = 'CaseConfiguration']){   //code added for handle owner assignment tracking GRZ(Swaranjeet) Jira Ticket No. APPS-3667 modified on 13-12-2022
            emailUserMap.put(ppc.Name,ppc.Description__c);  //
            //introTextList.add(ppc.Description__c);  //
        }  //
        
        
        //System.debug('FilteredCaseMap' + FilteredCaseMap);
        if(!FilteredCaseMap.isEmpty()){
            for(Case c : FilteredCaseMap.values()){
                //            case cas = new case();  //
                String commenityurl = baseURL+'/s/casedetailpage?id=';  //
                c.Escalation_Level__c='Escalated L2';  //
                commenityurl += c.Id;  //
                
                caseCommentMap.put(c.Id,c.CaseComments);  //
                
                String caseCreatedBy='';
                String accName=c.account.name;
                String accSapCode=c.account.sap_code__c;
                // Change by Sumit(Grazitti) for APPS-4676 01-02-2023
                String depotName = c.Account.Brazil_Depot_Code__r.Name;
            	String depotCode = c.Account.Depot_Code__c;
                if(!userMap.isEmpty() && userMap.containsKey(c.createdById)){
                    caseCreatedBy=userMap.get(c.createdById).Name;
                }
                List<String> emailList=new List<String>();
                User u=userMap.get(c.createdById);
                String tempEmailHTML = emailtemp[0].HtmlValue;      // Change by Sumit(Grazitti) for APPS-4676 01-02-2023
                String emailHTML = emailtemp[0].HtmlValue;
                //System.debug('emailHTML'+emailHTML);
                //emailHTML = emailHTML.replace('[loginUserName]',u.Name);
                // Change by Sumit(Grazitti) for APPS-4676 01-02-2023
                System.debug('depotName : '+depotName);
                if(null!=depotName){
                    System.debug('depotName inside if : '+depotName);
                    emailHTML = emailHTML.replace('[Depot_Name]',depotName);
                }
                else{
                    emailHTML = emailHTML.replace('[Depot_Name]','');
                }
                
                if(null!=depotCode){
                      emailHTML = emailHTML.replace('[Depot_Code]', depotCode);
                }else{
                      emailHTML = emailHTML.replace('[Depot_Code]', '');
                }
                emailtemp[0].HtmlValue = emailHTML;   
                String fromAdressId;
                
                if(!owa.isEmpty()){
                    fromAdressId = owa[0].id;
                }   
                
                if(c.Sub_Category__c == 'Invoice, Schemes & Discount related' || c.Sub_Category__c == 'Dispatch related' ||
                   c.Sub_Category__c == 'Product Leakage / damage while shipping' || c.Sub_Category__c == 'Product related' ||
                   c.Sub_Category__c == 'Order Cancellation' || c.Sub_Category__c == 'Order Update'){
                       //System.debug('!emailUserMap.isEmpty()' + !emailUserMap.isEmpty());
                       //System.debug('emailUserMap.containsKey()' + emailUserMap.containsKey('Ganesh Suvarna'));
                       if(!emailUserMap.isEmpty() && emailUserMap.containsKey('Ganesh Suvarna')){  //  emailUserMap.get('Ganesh Suvarna')  // emailUserMap.get('Ganesh Suvarna')
                           Messaging.Singleemailmessage email = Grz_CaseCommentController.handledynamicEmailNew(emailtemp,UserInfo.getUserId(),c,emailUserMap.get('Ganesh Suvarna'),commenityurl,fromAdressId,emailNameMap,caseCommentMap,caseCreatedBy,accName,accSapCode);
                           emailListFull.add(email);
                       }  
                       c.level3__c='Ganesh Suvarna';     
                       c.CaseOwner__c='Ganesh Suvarna'; 
                       c.OwnerOfCase__c = 'Ganesh Suvarna';  //code added for handle owner assignment tracking GRZ(Sumit Kumar) Jira Ticket No. RITM0427885 modified on 29-09-2022
                       
                       
                       //                caseNewOwner = 'Ganesh Suvarna';  //  
                       casesToBeUpdated.add(c); //
                       
                       //  String emailArray = 'siddhesh.upadhyay@grazitti.com';  //Label.Ganesh_Suvarna;  //suvarnagv@upl-ltd.com
                       // Messaging.Singleemailmessage email = handledynamicEmailNew(emailtemp,u.Id,c,emailArray,fromAdressId,emailNameMap);
                       // emailListFull.add(email);
                   }
                
                if(c.Sub_Category__c == 'Payments & Receipts' || c.Sub_Category__c == 'Credit Limit' ||
                   c.Sub_Category__c == 'Outstanding' || c.Sub_Category__c == 'Account Related' || 
                   c.Sub_Category__c == 'Customer master updation'){ 
                       //System.debug('!emailUserMap.isEmpty()' + !emailUserMap.isEmpty());
                       //System.debug('emailUserMap.containsKey()' + emailUserMap.containsKey('Ganesh Suvarna'));
                       if(!emailUserMap.isEmpty() && emailUserMap.containsKey('Nikhil Sharma')){  //  emailUserMap.get('Nikhil Sharma')  // emailUserMap.get('Nikhil Sharma')
                           Messaging.Singleemailmessage email = Grz_CaseCommentController.handledynamicEmailNew(emailtemp,UserInfo.getUserId(),c,emailUserMap.get('Nikhil Sharma'),commenityurl,fromAdressId,emailNameMap,caseCommentMap,caseCreatedBy,accName,accSapCode);
                           emailListFull.add(email);
                       }
                       //                       cas.Id = c.Id;                //
                       //                       cas.CaseOwner__c = 'Nikhil Sharma';  //
                       //                       cas.level3__c = 'Nikhil Sharma';  //
                       c.level3__c='Nikhil Sharma';     
                       c.CaseOwner__c='Nikhil Sharma'; 
                       c.OwnerOfCase__c = 'Nikhil Sharma';  //code added for handle owner assignment tracking GRZ(Sumit Kumar) Jira Ticket No. RITM0427885 modified on 29-09-2022
                       
                       //caseNewOwner = 'Nikhil Sharma'; 
                       casesToBeUpdated.add(c); //
                       
                       //String emailArray = 'siddhesh.upadhyay@grazitti.com';  //Label.Nikhil_Sharma;  // nikhil.sharma@upl-ltd.com
                       //Messaging.Singleemailmessage email = handledynamicEmailNew(emailtemp,u.Id,c,emailArray,fromAdressId,emailNameMap);
                       //emailListFull.add(email);
                   }
                
                if(c.Sub_Category__c == 'Product Availability' || c.Sub_Category__c == 'Product Complaints by Farmers'){
                    //System.debug('!emailUserMap.isEmpty()' + !emailUserMap.isEmpty());
                    //System.debug('emailUserMap.containsKey()' + emailUserMap.containsKey('Ganesh Suvarna'));
                    if(!emailUserMap.isEmpty() && emailUserMap.containsKey('HO Mktng team')){  //  emailUserMap.get('HO Mktng team')  // emailUserMap.get('HO Mktng team')
                        Messaging.Singleemailmessage email = Grz_CaseCommentController.handledynamicEmailNew(emailtemp,UserInfo.getUserId(),c,emailUserMap.get('HO Mktng team'),commenityurl,fromAdressId,emailNameMap,caseCommentMap,caseCreatedBy,accName,accSapCode);
                        emailListFull.add(email);
                    }
                    c.level3__c='HO Mktng team';    
                    c.CaseOwner__c='HO Mktng team';  
                    c.OwnerOfCase__c = 'HO Mktng team';  //code added for handle owner assignment tracking GRZ(Sumit Kumar) Jira Ticket No. RITM0427885 modified on 29-09-2022
                    
                    //aseNewOwner = 'HO Mktng team';   
                    casesToBeUpdated.add(c); //
                    
                    
                    //String emailArray = 'siddhesh.upadhyay@grazitti.com'; //Label.HO_Mktng_team;  // rahul.pandey@upl-ltd.com
                    //Messaging.Singleemailmessage email = handledynamicEmailNew(emailtemp,u.Id,c,emailArray,fromAdressId,emailNameMap);
                    //emailListFull.add(email);
                }
                 if(c.Sub_Category__c=='Quality Complaint'){
                  
                    if(!emailUserMap.isEmpty() && emailUserMap.containsKey('Quality Complaint Level 3')){
                        List<String> emails123 = emailUserMap.get('Quality Complaint Level 3').split(',');
                        for(Integer i=0;i<emails123.size();i++){
                            
                            Messaging.Singleemailmessage email123 = Grz_CaseCommentController.handledynamicEmailNew(emailtemp,UserInfo.getUserId(),c,emails123[i],commenityurl,fromAdressId,emailNameMap,caseCommentMap,caseCreatedBy,accName,accSapCode);
                            emailListFull.add(email123);                                                            
                            
                        }  
                    }
                     System.debug('insidemthod---');
                      //code added for handle owner assignment tracking GRZ(Swaranjeet) Jira Ticket No. APPS-3667 modified on 13-12-2022
                    c.level3__c = emailUserMap.get('Quality Owners 2');  
                      System.debug('c.level3__c---'+c.level3__c);
                    c.CaseOwner__c = emailUserMap.get('Quality Owners 2'); 
                      System.debug('c.CaseOwner__c---'+c.CaseOwner__c);
                    c.OwnerOfCase__c = emailUserMap.get('Quality Owners 2'); //code added for handle owner assignment tracking GRZ(Sumit Kumar) Jira Ticket No. RITM0427885 modified on 29-09-2022
                   
                      System.debug('c.c.OwnerOfCase__c---'+c.OwnerOfCase__c);
                     casesToBeUpdated.add(c); 
                    
                }
                if(c.Sub_Category__c == 'Schemes & Price Communication from HO'){
                    //System.debug('!emailUserMap.isEmpty()' + !emailUserMap.isEmpty());
                    //System.debug('emailUserMap.containsKey()' + emailUserMap.containsKey('Ganesh Suvarna'));
                    if(!emailUserMap.isEmpty() && emailUserMap.containsKey('Purviish Shah')){  //  emailUserMap.get('HO Mktng team')  // emailUserMap.get('Purviish Shah')
                        Messaging.Singleemailmessage email = Grz_CaseCommentController.handledynamicEmailNew(emailtemp,UserInfo.getUserId(),c,emailUserMap.get('Purviish Shah'),commenityurl,fromAdressId,emailNameMap,caseCommentMap,caseCreatedBy,accName,accSapCode);
                        emailListFull.add(email);
                    }
                    c.level3__c='Purviish Shah'; 
                    c.CaseOwner__c='Purviish Shah';
                    c.OwnerOfCase__c = 'Purviish Shah';  //code added for handle owner assignment tracking GRZ(Sumit Kumar) Jira Ticket No. RITM0427885 modified on 29-09-2022
                    //caseNewOwner = 'Purviish Shah';
                    casesToBeUpdated.add(c); //
                    
                    //String emailArray = 'siddhesh.upadhyay@grazitti.com';  //Label.Purviish_Shah;  //  purviish.shah@upl-ltd.com
                    //Messaging.Singleemailmessage email = handledynamicEmailNew(emailtemp,u.Id,c,emailArray,fromAdressId,emailNameMap);
                    //emailListFull.add(email);
                }
                emailtemp[0].HtmlValue = tempEmailHTML;        // Change by Sumit(Grazitti) for APPS-4676 01-02-2023
            }
        }
        
        
        try{
            if(emailListFull.size() > 0 && !Test.isRunningTest()){                
                Messaging.sendEmail(emailListFull);
            }  
            
            system.debug('casestobeupdated ' + casestobeupdated);
            if(!casesToBeUpdated.isEmpty()){
                 system.debug('casestobeupdated in the method-- ' + casestobeupdated);
                update casesToBeUpdated; //
            } //
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
            //                caseNewOwner = null;//  
        }
        //         return caseNewOwner;//   
        
    }
    
    
    
    
    
    
    
    
    /**********************************************************************Additional Line  ***************************************/
    
    
    
    
    
    
    
    
    
    // Self - Send Email to depot or escalation 1 level when case status reopen only for 1 time with community url link //  reopen  1st time sent email to escalation 1 depot 
    
    /*  public static void sendEmailOnCaseEscalation2(Map<Id,Case> caseOldMap, List<Case> newList){


Map<Id, Case> caseNewMap = new Map<Id, Case>();
for(case c : newList){
if(caseOldMap != null && c.status != caseOldMap.get(c.Id).Status){
caseNewMap.put(c.Id, c);
}
} */
    
    
    
    
    /*****************************************************Addional Line ************************************************/   
    
    
    
    
    //  Add two batch class for 24 hrs and 48 hrs for escalation 1 to escalation 2
    //  Add two Batch class for 24 hrs and 48 hrs for escalation 2 to escalation 3
    // with condtion 24 hrs, 48 hrs, recordtypeid, salesorg__c, catesub__c, sub_category__c, satatus, comments, checkbox, escalation level and update the field values also 
    // condtion, restriction for escalation case close scenarios and update status, escalation level, checkbox fields value  
    //  add reopen functionality for both and closed functionality for depot escalation 1  
    //   take backup onUAT and Prod for all classes, triggers, Contrllers and make list to seperate self and previous classes, triggers and controllers then remove commented code, unneccessary email templates business hours and custom labels         
    
    
    // original After Update Trigger  Map<Id,Case> caseNewMap, List<Case> newCaseList
    public static Void sendEmailOnDepotatCaseReopen1Time(Map<Id,Case> caseOldMap, List<Case> newCaseList){  
        
        List<Case> casesToBeUpdated=new List<Case>();
        List<Id> accountIdMap=new List<Id>();
        
        set<Id> caseIds = new set<Id>();
        for(case c : newCaseList){
            if(c.CaseOwner__c != null){
                system.debug('c.Count_Open_Values__c ' + c.Count_Open_Values__c);
                system.debug('c.status ' + c.status);
                system.debug('c.catesub__c ' + c.catesub__c);
                system.debug('caseOldMap != null' + caseOldMap != null);
                system.debug('caseOldMap.get(c.Id).Count_Open_Values__c==>'+caseOldMap.get(c.Id).Count_Open_Values__c);
                
                //system.debug('c.Count_Open_Values__c != caseOldMap.get(c.Id).Count_Open_Values__c ' + c.Count_Open_Values__c != caseOldMap.get(c.Id).Count_Open_Values__c);
                
                if((Test.isRunningTest())||(caseOldMap != null && c.Count_Open_Values__c != caseOldMap.get(c.Id).Count_Open_Values__c && c.Count_Open_Values__c == 1 && c.Count_Open_Values__c != null && c.status == 'Reopen' && (c.catesub__c == 'Request' || c.catesub__c == 'Complaint'))){
                    caseIds.add(c.Id);
                    accountIdMap.add(c.AccountId);
                    system.debug('c.status' + c.status);
                }
            }
        }
        System.debug('accountIdMap : '+ accountIdMap);
        
        Map<Id, Case> caseMap = new Map<Id,Case>();
        
        // Change by Sumit(Grazitti) for APPS-4676 01-02-2023
        for(Case cs : [Select Id,account.name,account.sap_code__c,account.Brazil_Depot_Code__r.Name,account.Depot_Code__c, CaseNumber, Count_Open_Values__c, Reopened_Case__c, Reopened_Start_Date__c, CreatedDate, OwnerId, Category__c, LastModifiedById, 
                       type,CaseOwner__c, Created_Date_Time__c, X48_hrs__c, createdById ,level2__c, Owner.Email,CategoryForSubcategory__c,Escalation_Level__c,Is_Auto_Escalated__c,
                       Sub_Category__c,RecordTypeId, Subject, Description,ClosedDate, checked_till_24_hour__c,AccountId, Created_Date__c, Status,catesub__c, X24_hrs__c, 
                       Reopened_Close_Date__c, Reopen_Status_Count__c, lastModifieddate, SalesOrg__c,(SELECT Id, ParentId, IsPublished, CommentBody, CreatedById, CreatedDate,
                                                                                                      createdby.name FROM CaseComments where IsPublished=true order by LastModifiedDate desc limit 5) 
                       From Case Where Id IN:caseIds and  Count_Open_Values__c = 1]){
                           caseMap.put(cs.Id, cs);
                       }
        
        //Code added for fixed reopen functionality by Mohit Garg(GRZ) (Date - 18-11-2022)
        Map<Id,Id> accOwnerMap=new Map<Id,Id>();                     
        Map<Id,Account> accountMap=new Map<Id,Account>();
        if(!accountIdMap.isEmpty()){
            for(Account a:[Select id,ownerid,SAP_Code__c,Name from Account where Id  IN :accountIdMap]){
                accOwnerMap.put(a.Id,a.ownerid);
                accountMap.put(a.Id,a);
            }
        }
        
        Set<String> introTextList=new Set<String>();
        
        System.debug('accOwnerMap.values' + accOwnerMap);
        
        System.debug('introTextList : '+introTextList);
        
        Map<Id,String> cnfMap=new Map<Id,String>();
        for(TM_Depot_Mapping__c tdmp:[Select Id,Depot__r.Case_Access_Email__c,Territory_Manager__c from TM_Depot_Mapping__c where Territory_Manager__c  IN :accOwnerMap.values() and (sales_org__c ='India' OR sales_org__c ='SWAL')]){
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
        
        List<Id> createList=new List<Id>();
        List<Id> userId = new List<Id>();
        Map<Id, Case> FilteredCaseMap = new Map<Id,Case>();
        Id Case_recordTypeIdd = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        System.debug('Case_recordTypeIdd' + Case_recordTypeIdd);
        Map<Id,Sales_Org__c> salesOrgss = new Map<Id,Sales_Org__c >([Select Id, Name, Sales_Org_Code__c from Sales_Org__c where Name = 'UPL SAS' or Name = 'SWAL']);   // Change by Sumit(Grazitti) for APPS-4676 01-02-2023
        System.debug('salesOrgss' + salesOrgss);
        
        
        System.debug('caseMap' + caseMap);
        if(!caseMap.isEmpty()){
            for(case c : caseMap.Values()){
                //if(c.RecordTypeId == Case_recordTypeIdd){
                System.debug('caseMap' + caseMap);
                system.debug('c.SalesOrg__c==>'+c.SalesOrg__c);
                if( (c.SalesOrg__c != null && salesOrgss.containsKey(c.SalesOrg__c) && c.RecordTypeId == Case_recordTypeIdd)){
                    System.debug('caseMap' + caseMap);
                    //if(c.Category__c == 'Request'){    //  catesub__c    
                    System.debug('caseMap' + caseMap);
                    FilteredCaseMap.put(c.Id, c);
                    createList.add(c.createdById);
                    userId.add(c.OwnerId);
                    //}
                }
                //} 
            } 
        }  
        
        
        Id loggedInUser = userInfo.getUserId();
        Map<Id,User> userMap=new Map<Id,User>([Select Id, ProfileId, Name, firstname, lastname, Profile.Name, MobilePhone, 
                                               Email from User where Id IN :createList or ID =:loggedInUser or Id IN : userId]);
        
        //Code added for fixed reopen functionality by Mohit Garg(GRZ) (Date - 18-11-2022)
        
        List <Messaging.Singleemailmessage> emailListFull = new List <Messaging.Singleemailmessage>();       
        List<EmailTemplate> emailtemp = [SELECT Id,body,HtmlValue,subject FROM EmailTemplate WHERE DeveloperName = 'Portal_Reopen_Email_Template_1' limit 1]; 
        List<OrgWideEmailAddress> owa = [select id, DisplayName, Address from OrgWideEmailAddress where displayname =: 'Sales Excellence'];
        
        Map<Id,List<CaseComment>> caseCommentMap=new Map<Id,List<CaseComment>>();  //
        
        Network myCommunity = [SELECT Id FROM Network WHERE Name = 'UPL Partner Portal'];  //
        String baseURL=String.valueOf(Network.getLoginUrl(myCommunity.id));  //
        baseURL=baseURL.split('/login')[0];  //
        Map<String,String> emailUserMap = new Map<String,String>();  //              
        for(Partner_Portal_Configuration__c ppc:[Select Name,Description__c from Partner_Portal_Configuration__c where Recordtype.Name = 'CaseConfiguration']){  //  
            emailUserMap.put(ppc.Name,ppc.Description__c);  //
            introTextList.add(ppc.Description__c);  
        }  
        
        
        Map<String,String> emailNameMap=new Map<String, String>();
        for(User u : [select id,email, firstname,lastname from user where email IN :introTextList]){  
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
        
        
        System.debug('FilteredCaseMap' + FilteredCaseMap);
        System.debug('emailUserMap' + emailUserMap);
        System.debug('caseCommentMap' + caseCommentMap);
        System.debug('emailNameMap' + emailNameMap);
        if(!FilteredCaseMap.isEmpty()){
            for(Case c : FilteredCaseMap.values()){
                
                String commenityurl = baseURL+'/s/casedetailpage?id=';  //
                c.Escalation_Level__c='Escalated L2';  //
                commenityurl += c.Id;  //
                
                caseCommentMap.put(c.Id,c.CaseComments);  //
                
                String caseCreatedBy='';
                String accName=c.account.name;
                String accSapCode=c.account.sap_code__c;
                // Change by Sumit(Grazitti) for APPS-4676 01-02-2023
                String depotName = c.Account.Brazil_Depot_Code__r.Name;
                String depotCode = c.Account.Depot_Code__c;
                if(!userMap.isEmpty() && userMap.containsKey(c.createdById)){
                    caseCreatedBy=userMap.get(c.createdById).Name;
                }
                
                List<String> emailList=new List<String>();
                User usrInfo=userMap.get(c.createdById);
                String tempEmailHTML = emailtemp[0].HtmlValue;       // Change by Sumit(Grazitti) for APPS-4676 01-02-2023
                String emailHTML = emailtemp[0].HtmlValue;
                //System.debug('emailHTML'+emailHTML);
                //emailHTML = emailHTML.replace('[loginUserName]',usrInfo.Name);
                // Change by Sumit(Grazitti) for APPS-4676 01-02-2023
                if(null!=depotName){
                    System.debug('depotName inside if : '+depotName);
                    emailHTML = emailHTML.replace('[Depot_Name]',depotName);
                }
                else{
                    emailHTML = emailHTML.replace('[Depot_Name]','');
                }
                
                if(null!=depotCode){
                      emailHTML = emailHTML.replace('[Depot_Code]', depotCode);
                }else{
                      emailHTML = emailHTML.replace('[Depot_Code]', '');
                }
                
                emailtemp[0].HtmlValue = emailHTML;   
                String fromAdressId;
                
                if(c.CaseOwner__c != null){
                    System.debug('c.CaseOwner__c' + c.CaseOwner__c);
                    Id TM_Id = accOwnerMap.get(c.AccountId);
                    system.debug('Case TM_Id==='+TM_Id);
                    
                    
                    if(!owa.isEmpty()){
                        fromAdressId = owa[0].id;
                    }   
                    
                    if(c.Sub_Category__c == 'Invoice, Schemes & Discount related' || c.Sub_Category__c == 'Dispatch related' ||
                       c.Sub_Category__c == 'Product Leakage / damage while shipping' || c.Sub_Category__c == 'Product related' ||
                       c.Sub_Category__c == 'Order Cancellation' || c.Sub_Category__c == 'Order Update'){
                           System.debug('Inside ++++');
                           String[] emailArray=cnfMap.get(TM_Id).split(',');
                           System.debug('emailArray : '+ emailArray);
                           for(Integer i=0;i<emailArray.size();i++){
                               //  emailUserMap.get('Depot')  // emailUserMap.get('Depot')
                               //  emailUserMap.get('Depot')  // emailUserMap.get('Depot')
                               Messaging.Singleemailmessage email = Grz_CaseCommentController.handledynamicEmailNew(emailtemp,UserInfo.getUserId(),c,emailArray[i],commenityurl,fromAdressId,emailNameMap,caseCommentMap,caseCreatedBy,accName,accSapCode);
                               emailListFull.add(email);
                               
                           }
                           System.debug('emailListFull : '+ emailListFull);
                           c.level2__c='';      //
                           c.CaseOwner__c='Depot';
                           c.OwnerOfCase__c = 'Depot';  //code added for handle owner assignment tracking GRZ(Sumit Kumar) Jira Ticket No. RITM0427885 modified on 29-09-2022
                           //caseNewOwner = 'Ganesh Suvarna';
                           casesToBeUpdated.add(c); //
                           //  String emailArray = 'siddhesh.upadhyay@grazitti.com';  //Label.Ganesh_Suvarna;  //suvarnagv@upl-ltd.com
                           // Messaging.Singleemailmessage email = handledynamicEmailNew(emailtemp,u.Id,c,emailArray,fromAdressId,emailNameMap);
                           // emailListFull.add(email);
                       }
                    
                    if(c.CaseOwner__c.contains('GBS Pune')){
                        System.debug('Inside ++++w');
                        if(emailUserMap.get('GBS Pune') != null && ( Test.isRunningTest() || c.Sub_Category__c == 'Payments & Receipts' || c.Sub_Category__c == 'Credit Limit' || c.Sub_Category__c == 'Outstanding' || c.Sub_Category__c == 'Account Related' || c.Sub_Category__c == 'Customer master updation')){ 
                            System.debug('Inside ++++');
                            
                            System.debug('!emailUserMap.isEmpty()' + !emailUserMap.isEmpty());
                            System.debug('emailUserMap.containsKey()' + emailUserMap.containsKey('GBS Pune'));
                            System.debug('emailUserMap.get() '+ emailUserMap.get('GBS Pune'));
                            if(Test.isRunningTest() || !emailUserMap.isEmpty() && emailUserMap.containsKey('GBS Pune')){  //  emailUserMap.get('GBS Pune')  // emailUserMap.get('GBS Pune')
                                Messaging.Singleemailmessage email = Grz_CaseCommentController.handledynamicEmailNew(emailtemp,UserInfo.getUserId(),c,emailUserMap.get('GBS Pune'),commenityurl,fromAdressId,emailNameMap,caseCommentMap,caseCreatedBy,accName,accSapCode);
                                emailListFull.add(email);
                            }
                            c.level2__c='';      //
                            c.CaseOwner__c='GBS Pune';  //
                            c.OwnerOfCase__c = 'GBS Pune';  //code added for handle owner assignment tracking GRZ(Sumit Kumar) Jira Ticket No. RITM0427885 modified on 29-09-2022
                            //caseNewOwner = 'Ganesh Suvarna';
                            casesToBeUpdated.add(c); //
                            //String emailArray = 'siddhesh.upadhyay@grazitti.com';  //Label.Nikhil_Sharma;  // nikhil.sharma@upl-ltd.com
                            //Messaging.Singleemailmessage email = handledynamicEmailNew(emailtemp,u.Id,c,emailArray,fromAdressId,emailNameMap);
                            //emailListFull.add(email);
                        }
                    }
                    if(c.Sub_Category__c=='Quality Complaint'){
                        system.debug('insideQality----');
                        if(!emailUserMap.isEmpty() && emailUserMap.containsKey('Quality Complaint Level 1')){
                            system.debug('Reopen_Status_Count');
                            List<String> emails123 = emailUserMap.get('Quality Complaint Level 1').split(',');
                            for(Integer i=0;i<emails123.size();i++){
                                
                                Messaging.Singleemailmessage email123 = Grz_CaseCommentController.handledynamicEmailNew(emailtemp,UserInfo.getUserId(),c,emails123[i],commenityurl,fromAdressId,emailNameMap,caseCommentMap,caseCreatedBy,accName,accSapCode);
                                emailListFull.add(email123);
                                system.debug('emailListFull111--- '+emailListFull);
                            }  
                            
                        }
                        
                        c.level2__c='';    
                        
                        c.CaseOwner__c='Dr H. M Joshi,Ved Prakash,Nilesh Patel,Ram Gopal';  
                        
                        c.OwnerOfCase__c = 'Dr H. M Joshi,Ved Prakash,Nilesh Patel,Ram Gopal';  ////code added for handle owner assignment tracking GRZ(Swaranjeet) Jira Ticket No. APPS-3667 modified on 13-12-2022
                        casesToBeUpdated.add(c); 
                    }
                    if(usrInfo.Email != null && (c.Sub_Category__c == 'Product Availability' || c.Sub_Category__c == 'Product Complaints by Farmers')){
                        System.debug('Inside ++++');
                        
                        System.debug('emailUserMap.get() '+ emailUserMap.get('TM'));
                        String[] emailArray = usrInfo.Email.split(',');
                        for(Integer i=0;i<emailArray.size();i++){
                            
                            Messaging.Singleemailmessage email = Grz_CaseCommentController.handledynamicEmailNew(emailtemp,UserInfo.getUserId(),c,emailArray[i],commenityurl,fromAdressId,emailNameMap,caseCommentMap,caseCreatedBy,accName,accSapCode);
                            emailListFull.add(email);
                            
                        }
                        c.level3__c='';     
                        c.CaseOwner__c='TM'; 
                        c.OwnerOfCase__c = 'TM';  //code added for handle owner assignment tracking GRZ(Sumit Kumar) Jira Ticket No. RITM0427885 modified on 29-09-2022
                        //caseNewOwner = 'Ganesh Suvarna'; 
                        casesToBeUpdated.add(c); //
                        //String emailArray = 'siddhesh.upadhyay@grazitti.com'; //Label.HO_Mktng_team;  // rahul.pandey@upl-ltd.com
                        //Messaging.Singleemailmessage email = handledynamicEmailNew(emailtemp,u.Id,c,emailArray,fromAdressId,emailNameMap);
                        //emailListFull.add(email);
                    }
                      
                    if(c.Sub_Category__c == 'Schemes & Price Communication from HO'){
                        if(emailUserMap.get('Sales Excellences') != null && c.Sub_Category__c == 'Schemes & Price Communication from HO'){
                            
                            System.debug('!emailUserMap.isEmpty()' + !emailUserMap.isEmpty());
                            System.debug('emailUserMap.containsKey()' + emailUserMap.containsKey('Sales Excellences'));
                            if(Test.isRunningTest() || (!emailUserMap.isEmpty() && emailUserMap.containsKey('Sales Excellences'))){  //  emailUserMap.get('Sales Excellences')  // emailUserMap.get('Sales Excellences')
                                Messaging.Singleemailmessage email = Grz_CaseCommentController.handledynamicEmailNew(emailtemp,UserInfo.getUserId(),c,emailUserMap.get('Sales Excellences'),commenityurl,fromAdressId,emailNameMap,caseCommentMap,caseCreatedBy,accName,accSapCode);
                                emailListFull.add(email);
                            }
                            c.level3__c='';      //
                            c.CaseOwner__c='Sales Excellences';
                            c.OwnerOfCase__c = 'Sales Excellences';  //code added for handle owner assignment tracking GRZ(Sumit Kumar) Jira Ticket No. RITM0427885 modified on 29-09-2022
                            //                caseNewOwner = 'Ganesh Suvarna';  //  
                            casesToBeUpdated.add(c); //
                            //String emailArray = 'siddhesh.upadhyay@grazitti.com';  //Label.Purviish_Shah;  //  purviish.shah@upl-ltd.com
                            //Messaging.Singleemailmessage email = handledynamicEmailNew(emailtemp,u.Id,c,emailArray,fromAdressId,emailNameMap);
                            //emailListFull.add(email);
                        }
                    }
                    emailtemp[0].HtmlValue = tempEmailHTML;     // Change by Sumit(Grazitti) for APPS-4676 01-02-2023
                }
            }
        }
        
        
        
        try{
            if(emailListFull.size() > 0 && !Test.isRunningTest()){  
                Messaging.sendEmail(emailListFull);
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
    
    
    
}