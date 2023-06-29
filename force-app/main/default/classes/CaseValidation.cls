public class CaseValidation{
    public String  accId {get;set;}      
    Public String db{get;set;}
    public Account abc;
    
    public CaseValidation(){
        System.debug('load this');
        accId = ApexPages.currentPage().getParameters().get('id');
        System.debug('---->'+accId);
    }
    
    public PageReference MyActionMethod(){
        Account acc = new Account();
        acc = [SELECT Name,Registration_Status__pc,PersonBirthdate,What_is_your_highest_education_attained__pc,age__pc,Village_Postal_Code__c,Village_Pin_Code_Manual__pc FROM Account WHERE Id =: accId  ]; 
        String url = '/setup/ui/recordtypeselect.jsp?ent=Case&retURL=/'+acc.Id+ +'&save_new_url=/500/e?retURL=%'+acc.Id+'&def_account_id='+acc.Id;
        if((acc.PersonBirthdate != null || acc.age__pc != NULL ) && (acc.What_is_your_highest_education_attained__pc != null) && (acc.Registration_Status__pc =='Fully Registered'  ) && (acc.Village_Postal_Code__c!=null || acc.Village_Pin_Code_Manual__pc!=null) ){
            System.debug('Inside-------------> If');
            PageReference retURL = new PageReference(url);
            System.debug('Inside--------recordtypeselect-----> If');
            retURL.setRedirect(true);
            return retURL;
        }else{
            if(acc.Registration_Status__pc !='Fully Registered' ){
                PageReference retURL = new PageReference(url);
                retURL.setRedirect(true);
                return retURL;
            } 
        }
        
        return null;
    }
    
    
    
    public PageReference Sync() {
        Account acc = new Account();
        acc = [SELECT Name,PersonBirthdate,What_is_your_highest_education_attained__pc,Registration_Status__pc,Village_Postal_Code__c,Village_Pin_Code_Manual__pc FROM Account WHERE Id =: accId];
        
        System.debug('---->Debug -->'+acc);
        System.debug('---->Debug PersonBirthdate -->'+acc.PersonBirthdate);
        System.debug('---->Debug What_is_your_highest_education_attained__pc -->'+acc.What_is_your_highest_education_attained__pc);
        db = 'no';
        if((acc.PersonBirthdate != null) && (acc.What_is_your_highest_education_attained__pc != null) && ( acc.Registration_Status__pc =='Fully Registered' )&&( acc.Village_Postal_Code__c!=null || acc.Village_Pin_Code_Manual__pc!=null )){
            String url = '/setup/ui/recordtypeselect.jsp?ent=Case&retURL=/'+acc.Id+ +'&save_new_url=/500/e?retURL=%'+acc.Id+'&def_account_id='+acc.Id;
            PageReference pageRef = new PageReference(url);
            pageRef.setRedirect(false);
            return pageRef;
        }else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR , 'Please fill Birthdate, Village Postal Code and What is your highest education attained?  <b><u> <span id="popup"></span><u></b>'));
            db = 'yes';
        }
        
        String url = '/setup/ui/recordtypeselect.jsp?ent=Case&retURL=/'+acc.Id+ +'&save_new_url=/500/e?retURL=%'+acc.Id+'&def_account_id='+acc.Id;
        
        System.debug('------>>>>>>'+abc);
        PageReference pageRef = new PageReference(url);
        pageRef.setRedirect(false);
        return null;
        
    }
    
    public PageReference Sync1() {
        Account acc = new Account();
        
        acc = [SELECT Name,PersonBirthdate,What_is_your_highest_education_attained__pc FROM Account WHERE Id =: accId];  
        
        String url = '/setup/ui/recordtypeselect.jsp?ent=Case&retURL=/'+acc.Id+ +'&save_new_url=/500/e?retURL=%'+acc.Id+'&def_account_id='+acc.Id;
        
        PageReference pageRef = new PageReference(URL);
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    public PageReference cancel() {
        
        PageReference pageRef = new PageReference('/'+accId);
        pageRef.setRedirect(true);
        return pageRef;
    }
    
}