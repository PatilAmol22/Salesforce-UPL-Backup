global class SendEmailDistributorsBatch implements Database.Batchable<sObject>, Database.Stateful
{
    public String salesorgCode = '';
    String DistributorRecordTypeId ='';
    List<String> acntlist{get;set;}
    List<String> acntNamelist{get;set;}
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        salesorgCode = '2941';
        DistributorRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        System.debug('DistributorRecordTypeId :- '+DistributorRecordTypeId);
        String query = 'SELECT Id, Name, Email__c FROM Account WHERE Email__c!=null And Sales_org_code__c=\''+salesorgCode+'\'';//+'\' And RecordTypeId=\''+DistributorRecordTypeId+'\'';
        System.debug('query :- '+query);
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Account> scope)
    {       
        acntlist = new List<String>();
        acntNamelist= new List<String>();
        EmailTemplate emailTemplateObj = [select Id, HtmlValue, Body from EmailTemplate where DeveloperName = 'Christmas_Easter_template' limit 1];
        for(Account acnt : scope){
        	acntlist.clear();
            acntlist.add(acnt.Email__c);
            acntNamelist.add(acnt.Name);
        }
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(acntlist);
        email.setSaveAsActivity(false);
        //email.setTemplateId(emailTemplate.Id);
        for(String name:acntNamelist){
            email.setHtmlBody('Hello '+ name +',<br /><br />'+emailTemplateObj.HtmlValue);
        }
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
    }  
    global void finish(Database.BatchableContext BC)
    {
    }
}