/* Name: SendMailForInventoryControl
/Author: Wipro
/Description: Reminder mail to salesforcebrazil@upl-ltd.com for inventory control records update 
/Brazil Price2Win Phase 2 
*/
global class SendMailForInventoryControl implements Database.Batchable < sobject > {
global Database.QueryLocator start(Database.BatchableContext bc) {
       String Query;
      // Date dt = date.today()-1;
       Query = 'SELECT Name,Id,CreatedDate From Inventory_Control__c WHERE CreatedDate <today Limit 2';
       system.debug('Query '+Query);
       return Database.getquerylocator(Query);
 
       }

global void execute(Database.BatchableContext bc, List < Inventory_Control__c > InventoryControl) {
       List < Messaging.SingleEmailMessage > emails = new List < Messaging.SingleEmailMessage > ();
    system.debug('test '+InventoryControl.size());
    if(InventoryControl.size()>0)
    {
        
        system.debug('test2 '+InventoryControl.size());
       OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'salesexcellence1@upl-ltd.com'];
        if ( owea.size() > 0 )
        {
       Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
       email.setToAddresses(new String[] {'ankita.20@wipro.com','tripathyankita321@gmail.com','mkrishanu98@gmail.com','dipak.zambare@wipro.com'}); //salesforcebrazil@upl-ltd.com
       
       email.setSubject('Upload Inventory Control Records'); 
       email.setPlainTextBody('Hi Team,\n\nThis is a gentle reminder.Inventory Control Records are not updated for this month,Kindly updload it.\nRegards, \nUPL Team.');
       
       
        email.setOrgWideEmailAddressId(owea.get(0).Id);
       
       emails.add(email);
       }
       Messaging.sendEmail(emails);
    } 
       }

global void finish(database.BatchableContext bc) {}
    /*
    global void execute(SchedulableContext sc) {
        SendMailForInventoryControl b = new SendMailForInventoryControl(); 
        database.executebatch(b);
    }*/

}