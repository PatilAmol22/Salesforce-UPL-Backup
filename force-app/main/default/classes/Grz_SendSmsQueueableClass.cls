public class Grz_SendSmsQueueableClass implements Queueable, Database.AllowsCallouts {

    private List<Case> lstCase;
    
    public Grz_SendSmsQueueableClass(List<Case> lscase){
        this.lstCase = lscase;
    }

    public void execute(QueueableContext context) {
        if(!lstCase.isEmpty()){
            /*for(Account a:lstAccount){
                SendAccountUsingRESTAPI.callcreateAcc(a.Name, a.Id);
            }*/
            List<Id> createList=new List<Id>();
        List<SMS_Template__c> smsTemp=[SELECT Id, Name, Name__c, ObjectName__c, Text__c FROM SMS_Template__c where Name='Community_Case_Escalation' and ObjectName__c='Case'];
        for(Case c:lstCase)
        {
            createList.add(c.createdById);
        }
        system.debug('createList==>'+createList.size());
        Map<Id,User> userMap=new Map<Id,User>([Select Id,MobilePhone from User where Id IN :createList]);
        for(Case c:lstCase){
            User u=userMap.get(c.createdById);
            String encodedcontent;
                if(c.CaseOwner__c != null)
                    encodedcontent = EncodingUtil.urlEncode(smsTemp[0].Text__c.replace('<CASE ID>', c.CaseNumber).replace('<Case Owner>',c.CaseOwner__c), 'UTF-8');
                else
                    encodedcontent = EncodingUtil.urlEncode(smsTemp[0].Text__c.replace('<CASE ID>', c.CaseNumber), 'UTF-8');
                if(u.MobilePhone!='' && u.MobilePhone!=null){
                    String phoneVal = u.MobilePhone.replaceAll('\\D','');
                    String senderId = 'UPL';
                     system.debug('inside send sms==>'+c.casenumber);
                    IntegrationWithKarix.sendSMS(encodedcontent,phoneVal,c.Id,senderId);
                }
        }
        }
        
    }
}