public class UpdatingMeetingNotesIndiaSwal {

    @InvocableMethod(label='Update Meeting Notes')
    public static void submitForApproval(List<String> EventIdList)
    {
        
        
        system.debug('opp'+ EventIdList);
         List<Event> updateEveList= new List<Event>();
        List<Event> EventMeetingNotesList=[Select id,Meeting_Notes__c from Event where id in:EventIdList];
      Map<Id,Event> MapOfEventAndId=new Map<Id,Event>();
       
        List<Activity_Event__c> RelatedActivityIDList=[Select Related_Event_Id__c,Status__c,Meething_Notes__c,Event_Manger__c from Activity_Event__c where Related_Event_Id__c in:EventIdList];
        System.debug('RelatedIDList'+RelatedActivityIDList);
        List<String> ListofRelatedID=new List<String>();
        List<String> ToAddressEmail=new List<String>();
        List<Activity_Event__c> ListToUpdateOnActivityEvent=new List<Activity_Event__c> ();
         EmailTemplate et = [Select id,Body,HtmlValue,Subject from EmailTemplate where developerName ='Event_Manager_Emailtemplater'];
      
        For(Event e:EventMeetingNotesList){
           MapOfEventAndId.put(e.id,e);
        }
        for(String iid:MapOfEventAndId.keySet()){
        for(Activity_Event__c ae:RelatedActivityIDList){
           if(ae.Related_Event_Id__c == iid)
           {
               ae.Meething_Notes__c=MapOfEventAndId.get(iid).Meeting_Notes__c;
              /* Activity_Event__c instance= new Activity_Event__c();
               instance.id=ae.id;
               instance.Meething_Notes__c=MapOfEventAndId.get(iid).Meeting_Notes__c;
               instance.Event_Manger__c=ManagerID;*/
               
               ListToUpdateOnActivityEvent.add(ae);
               
           }
            
        }
        }
        if(ListToUpdateOnActivityEvent.size()>0 && !ListToUpdateOnActivityEvent.isEmpty()){
        update ListToUpdateOnActivityEvent;
        }
        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
        System.debug('ListToUpdateOnActivityEvent'+ListToUpdateOnActivityEvent);
        For(Activity_Event__c a:ListToUpdateOnActivityEvent){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setTemplateId(et.Id);
         System.debug('Eevent manager'+a.Event_Manger__c);
        mail.setTargetObjectId(a.Event_Manger__c);
        
            String htmlBody = et.HtmlValue;
                String subject=et.Subject;
             
            htmlBody = htmlBody.replace('{!Activity_Event__c.Related_Event_Id__c}',a.Related_Event_Id__c);
            htmlBody = htmlBody.replace('{!Activity_Event__c.Meething_Notes__c}',a.Meething_Notes__c);
             
            htmlBody = htmlBody.replace(']]>','');
            mail.setHtmlBody(htmlBody);
        mail.saveAsActivity=false;
        emailList.add(mail);
        }
         if(!emailList.isEmpty()){
            Messaging.sendEmail(emailList);
        }   
        
        
         

}
}