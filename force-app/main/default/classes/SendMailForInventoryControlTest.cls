@isTest
    public class SendMailForInventoryControlTest 
    { 
        static testMethod void testSendMailForInventoryControl()
        {
           Product2 pro = new Product2();
            pro.ProductCode = '66700';
            pro.Product_Code__c='66700';
            pro.Name='DOST';
            pro.popular__c = true;
            pro.Combination_Key__c='RM0065100';
            Insert Pro;
           
     List<Inventory_Control__c> lstInv = new List<Inventory_Control__c>();
      for(Integer i=0 ;i <1;i++)
            {
        Inventory_Control__c f1 = new Inventory_Control__c();
            f1.BU__c = 'BR15';
            f1.Product_Name__c = Pro.id;
            f1.Quantity__c = 1000;
            f1.Fiscal_Year__c = '22/23';
                f1.createddate=system.today()-1;
          //   Test.setCreatedDate(f1.Id, DateTime.newInstance(2022,10,10));   
            lstInv.add(f1);
            }
            insert lstInv;

/*Database.BatchableContext bc;
SendMailForInventoryControl obj=new SendMailForInventoryControl();
inv=obj.start(bc);
obj.execute(bc,inv);
obj.finish(bc);*/




 List < Messaging.SingleEmailMessage > emails = new List < Messaging.SingleEmailMessage > ();
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'salesexcellence1@upl-ltd.com'];
             System.assertEquals(1, owea.size());    
        if ( owea.size() > 0 )
        {
       Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
       email.setToAddresses(new String[] {'ankita.20@wipro.com','tripathyankita321@gmail.com','mkrishanu98@gmail.com','dipak.zambare@wipro.com'}); //salesforcebrazil@upl-ltd.com
       
       email.setSubject('Upload Inventory Control Records'); 
       email.setPlainTextBody('Hi Team,\n\nThis is a gentle reminder.Inventory Control Records are not updated for this month,Kindly updload it.\nRegards, \nUPL Team.');
      email.setOrgWideEmailAddressId(owea.get(0).Id);
 emails.add(email);
        }
    Test.startTest();
         
          System.assertEquals(1, owea.size());
    SendMailForInventoryControl obj = new SendMailForInventoryControl();
                DataBase.executeBatch(obj); 
            List<Messaging.SendEmailResult> results = Messaging.sendEmail(emails ,false);
    Test.stopTest();
            if(results.size()>0){
     Boolean emailsSentSuccessfully = results[0].isSuccess();
   System.assert(emailsSentSuccessfully , 'Email failure occurred. Confirm the Organization-Wide-Address is setup and VERIFIED for Specific Org Wide address given');
            }
        }
    }