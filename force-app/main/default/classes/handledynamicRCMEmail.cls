/**************************************************************************************************
* Name             : handledynamicRCMEmail                                                      
* Test Class       : Grz_CaseCommentRCMControllerTest
* Created Date     : 10-02-2023                                                                        
* Project/JIRA     : APPS-4742                                                                   
* Created By       : Mohit Garg (Grazitti)                                                                        
* Last Modified By : Mohit Garg (Grazitti) 13-02-2023                                                                       
**************************************************************************************************/

public class handledynamicRCMEmail {
    public static Messaging.Singleemailmessage handledynamicRCMEmailNew(List<EmailTemplate> template,String userid, Case c,List<String> useremail,String commenityurl,String fromAdressId,Map<String,String> emailNameMap,Map<Id,List<CaseComment>> caseCommentMap,String caseCreatedBy, List<String> lstCCMails){
        Messaging.Singleemailmessage email = Messaging.renderStoredEmailTemplate(template[0].Id, userid, c.Id);
        List<String> emailadd = useremail;
        String StrEmailss ;
        for(Integer i= 0; i<emailadd.size(); i++){
            if(!emailNameMap.isEmpty() && emailNameMap.containsKey(useremail[i])){
                StrEmailss = emailNameMap.get(useremail[i]);
            }
        }
        String emailHTML = template[0].HtmlValue;
        String emailSub = template[0].subject;
        emailSub = emailSub.replace('[CaseNumber]', c.CaseNumber);
        emailHTML = emailHTML.replace('[OwnerEmail]', c.CaseOwnerName__c).replace('[CaseDetailPageLink]',commenityurl);
        emailHTML = emailHTML.replace('[CaseNumber]',c.CaseNumber);
        emailHTML = emailHTML.replace('[Date_of_creation]',Grz_SapIntegration.FormattedDate(c.CreatedDate));
        if(null!=c.Sub_Category__c){
            emailHTML = emailHTML.replace('[Type_]',c.Sub_Category__c);
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
        
        if(caseCreatedBy != null){  
            emailHTML = emailHTML.replace('[TM_Code]',caseCreatedBy);    
        }
        else{  
            emailHTML = emailHTML.replace('[TM_Code]','');      
        }
        
        if(c.ClosedDate!=null){
            emailHTML = emailHTML.replace('[Closed_Date]',Grz_SapIntegration.FormattedDate(c.ClosedDate));
        }
        if(emailHTML.contains('[Case_Comment_Table]')){
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
        email.setToaddresses(useremail);
        email.setCcAddresses(lstCCMails);
        email.setTreatTargetObjectAsRecipient(false); 
        email.setSaveAsActivity(false);
        return email;
    }
}