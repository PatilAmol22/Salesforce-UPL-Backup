@isTest
public class Activity_Plan_view_controller_test{
     
     static testMethod void testMethod1(){
     User u2 = new User(
     ProfileId = [SELECT Id FROM Profile WHERE Name = 'Marketing Manager Indonesia'].Id,
     LastName = 'last',
     Email = 'puser000@amamama.com',
     Username = 'puser000@amamama.com' + System.currentTimeMillis(),
     CompanyName = 'TEST',
     Title = 'title',
     Alias = 'alias',
     TimeZoneSidKey = 'America/Los_Angeles',
     EmailEncodingKey = 'UTF-8',
     LanguageLocaleKey = 'en_US',
     LocaleSidKey = 'en_US'
);  
    insert u2;
    
    
    User u1 = new User(
     ProfileId = [SELECT Id FROM Profile WHERE Name = 'Regional/Zonal Indonesia'].Id,
     LastName = 'last',
     Email = 'puser000@amamama.com',
     Username = 'puser000@amamama.com' + System.currentTimeMillis(),
     CompanyName = 'TEST',
     Title = 'title',
     Alias = 'alias',
     TimeZoneSidKey = 'America/Los_Angeles',
     EmailEncodingKey = 'UTF-8',
     LanguageLocaleKey = 'en_US',
     LocaleSidKey = 'en_US'
     
);  
    insert u1;
      
            User u = new User(
     ProfileId = [SELECT Id FROM Profile WHERE Name = 'Territory Manager Indonesia'].Id,
     LastName = 'last',
     Email = 'puser000@amamama.com',
     Username = 'puser000@amamama.com' + System.currentTimeMillis(),
     CompanyName = 'TEST',
     Title = 'title',
     Alias = 'alias',
     TimeZoneSidKey = 'America/Los_Angeles',
     EmailEncodingKey = 'UTF-8',
     LanguageLocaleKey = 'en_US',
     LocaleSidKey = 'en_US',
     Marketing_Manager__c = u2.id,
        RegionalManager__c = u1.id
     );  
    insert u;
    
          system.runAs(u){
             Id RecordTypeIdContact = Schema.SObjectType.Activity_Plan__c.getRecordTypeInfosByName().get('Marketing Requisiton').getRecordTypeId();
  	system.debug('RecordTypeIdContact : '+RecordTypeIdContact);
      list<Activity_Plan__c> Actvylst =  new list<Activity_Plan__c>();
      Activity_Plan__c actvyplan = new Activity_Plan__c();
      actvyplan.recordtypeid = RecordTypeIdContact;
      actvyplan.Activity_Type__c = 'Campaign'; 
     actvyplan.No_of_farmer_invited__c = 10;
     actvyplan.No_of_R1_invited__c = 20;
          actvyplan.Start_Date__c = system.today();
          actvyplan.End_Date__c = system.today() +1;
      Actvylst.add(actvyplan);
          
      Activity_Plan__c actvyplan1 = new  Activity_Plan__c();
      actvyplan1.Activity_Type__c = 'In-house Meeting'; 
      actvyplan1.recordtypeid = RecordTypeIdContact;
       actvyplan1.No_of_farmer_invited__c = 10;
     actvyplan1.No_of_R1_invited__c = 20;
          actvyplan1.Start_Date__c = system.today();
          actvyplan1.End_Date__c = system.today() +1;
          
      Actvylst.add(actvyplan1);

      insert Actvylst;
          
      Activity_Plan__c actvyplan2 = new  Activity_Plan__c();
      actvyplan2.Activity_Type__c = 'In-house Meeting'; 
       actvyplan2.Activity_Type__c = 'In-house Meeting'; 
       actvyplan2.recordtypeid = RecordTypeIdContact;
       actvyplan2.No_of_farmer_invited__c = 10;
     actvyplan2.No_of_R1_invited__c = 20;
          actvyplan2.Start_Date__c = system.today();
          actvyplan2.End_Date__c = system.today() +1;
      insert actvyplan2;
      
    

       Test.setCurrentPage(Page.ActivityPlanView);
       System.currentPageReference().getParameters().put('id', actvyplan.id);
       ApexPages.StandardController stdSetController = new ApexPages.StandardController(actvyplan);
      // stdSetController.setSelected(Actvylst);
       ActivityPlanViewController actvyPlnObj = new ActivityPlanViewController(stdSetController);
       //actvyPlnObj.actvyId = Actvylst[0].id;
       actvyPlnObj.actPlan = Actvylst;  
       ActivityPlanViewController.actvtywrap actvyWrapObj = new ActivityPlanViewController.actvtywrap();
       
     list<Activity_Plan__c> Actvylst1 =  new list<Activity_Plan__c>();
     Activity_Plan__c actvyplan3 = new Activity_Plan__c();
     actvyplan3.Activity_Type__c = 'Campaign'; 
     actvyplan3.No_of_farmer_invited__c = 10;
     actvyplan3.No_of_R1_invited__c = 20;
     actvyplan3.Start_Date__c = system.today();
     actvyplan3.End_Date__c = system.today() +1;
     Actvylst1.add(actvyplan);
             
       Test.setCurrentPage(Page.ActivityPlanView);
       System.currentPageReference().getParameters().put('id', actvyplan.id);
       ApexPages.StandardController stdSetController1 = new ApexPages.StandardController(actvyplan);
       //stdSetController1.setSelected(Actvylst1);
       ActivityPlanViewController actvyPlnObj1 = new ActivityPlanViewController(stdSetController1);
       //actvyPlnObj1.actvyId = Actvylst1[0].id;
       //actvyPlnObj1.actPlan = Actvylst1;  
       ActivityPlanViewController.actvtywrap actvyWrapObj1 = new ActivityPlanViewController.actvtywrap();
       }
      }
}