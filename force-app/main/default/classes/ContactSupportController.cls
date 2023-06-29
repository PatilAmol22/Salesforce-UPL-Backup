public without sharing class ContactSupportController {
    @AuraEnabled
    public static void sendMail(string docid,string subject,string description){
        System.debug('jdskadhkashd docid '+docid);
        System.debug('jdskadhkashd '+subject);
        System.debug('jdskadhkashd '+description);       
        ContactSupportController.sendEmail(docid, subject, description);
    }
    
    public static void sendEmail(string docid,string subject,string description){
        id userId = UserInfo.getUserId();
        System.debug(userId);
        User u=new User();        
        u = [select id, contactId, AccountId, Country from User where id = : userId];
        id AccountId=u.AccountId;
        AccountTeamMember atm =new AccountTeamMember();
        Account a=new Account();
        ContactInfo ci=new ContactInfo();
        if(u.Country=='Colombia'){
            try{
                atm=[SELECT Id, AccountId, User.Name, User.Email, User.MobilePhone FROM AccountTeamMember where AccountId=: AccountId Order By LastModifiedDate Desc limit 1];
                ci.Name=atm.User.Name;
                ci.Email=atm.User.Email;
                ci.MobilePhone=atm.User.MobilePhone;
            }catch(Exception e){
                ci.Email='abcd@test.com';
            }
            
        }else{
            a=[select id, OwnerId, Owner.name, Owner.email, Owner.MobilePhone from Account where id = : AccountId];
            System.debug('OwnerId=='+a.OwnerId);
        	ci.Name=a.Owner.Name;
        	ci.Email=a.Owner.Email;
            System.debug('Email-----'+a.Owner.Email);
        	ci.MobilePhone=a.Owner.MobilePhone;
        }     
        System.debug(ci.Email);
        Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
        if(docid!=null){
            List <ContentVersion> cv=[SELECT Id, Title, ContentDocumentId, FileType, FileExtension, VersionData FROM ContentVersion where ContentDocumentId=:docid];
            
            if(cv[0].FileExtension=='csv'){
                attach.setContentType('text/'+cv[0].FileExtension);
            }
            if(cv[0].FileExtension=='png'){
                attach.setContentType('image/'+cv[0].FileExtension);
            }
            if(cv[0].FileExtension=='jpeg'){
                attach.setContentType('image/'+cv[0].FileExtension);
            }
            if(cv[0].FileExtension=='jpg'){
                attach.setContentType('image/'+cv[0].FileExtension);
            }
            if(cv[0].FileExtension=='pdf'){
                attach.setContentType('application/'+cv[0].FileExtension);
            }
            attach.setFileName(cv[0].Title+'.'+cv[0].FileExtension);
            attach.setInline(false);
            attach.Body = cv[0].VersionData;
        }
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setCharset('UTF8');
        mail.setUseSignature(false);
        mail.setToAddresses(new String[]{ci.Email});//Set To Email Address
        mail.setSubject(subject);//Set Subject
        mail.setHtmlBody(description);//Set HTML Body
        if(docid!=null){
        	mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attach });//Set File Attachment
        }
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });//Send Email
    }
    public class ContactInfo{
        @AuraEnabled public String Name{get;set;}
        @AuraEnabled public String Email{get;set;} 
        @AuraEnabled public String MobilePhone{get;set;} 
        public ContactInfo(){
            Name='';
            Email='';
            MobilePhone='';
        }
    }    
    
    
}