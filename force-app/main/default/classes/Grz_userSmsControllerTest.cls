@isTest(SeeAllData=false)
public class Grz_userSmsControllerTest {
    Public  static testmethod void testUserSmsController(){
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator1());
        Id recordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Sales_Org__c sOrg = Grz_TestDataFactory.createSalesOrg(true, 'Test Org','1000');
        Account acc = Grz_TestDataFactory.createUserAccount(true, 'Test Account',recordTypeId,sOrg.Id);
        Contact con = Grz_TestDataFactory.createContact(true, 'Test Contact',acc.Id);
        Contact con1 = Grz_TestDataFactory.createContact(true, 'Test Contact1',acc.Id);
        Grz_TestDataFactory.createTemplate(true,'Community_Welcome_Email', 'User');
        Profile pro = [SELECT Id FROM Profile WHERE Name = 'India Partner Community Distributor Profile'];
        Profile pro1 = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        Profile pro2 = [SELECT Id FROM Profile WHERE Name = 'Territory Manager'];
        User usr1 = Grz_TestDataFactory.createInternalUser(true,pro1.Id);
        User usr5 = Grz_TestDataFactory.createInternalUser(true,pro1.Id);
        System.debug('usr1 id:'+usr1.id);
        User usr=new User();
        User usr4=new User();
        User usr2 = Grz_TestDataFactory.createInternalUser(true,pro2.Id);
        Sales_Org__c Sc = Grz_TestDataFactory.createSalesOrg(true,'india','1000');
        Territory_Distributor__c trt=new Territory_Distributor__c();
        System.debug('usr2 id:'+usr2.id);
System.runAs(usr2){
trt = Grz_TestDataFactory.createTeritory(false);
        trt.SalesOrg__c = Sc.id;
        insert trt;
}
        System.runAs(usr1){
        
        Group gg1=Grz_TestDataFactory.creategroup(true);
        usr4 = Grz_TestDataFactory.createExternalUser(false,pro.Id,con1.Id);
        usr4.territory__c=trt.name;
        insert usr4;
        GroupMember gm=Grz_TestDataFactory.createGM(true,gg1.Id,usr4.id);
        /*}
        System.runAs(usr2){
            
        
        System.debug('territory trt manager:'+trt.TerritoryManager__c);
        system.debug('user2:'+UserInfo.getUserId());
        
        User u=[Select Id,Email from user where Id=:UserInfo.getUserId()];
            System.debug('fUser >>>>>'+u);*/
        usr2.Email='test123@gmail.com';
        
        update usr2;
        
        // System.debug('fUser >>>>>'+u);   
        }
        System.runAs(usr1){
        Group gg=Grz_TestDataFactory.creategroup(true);
        usr = Grz_TestDataFactory.createExternalUser(false,pro.Id,con.Id);
        usr.territory__c=trt.name;
        insert usr;
        usr.territory__c='testTerritory';
             

        update usr;
        GroupMember gm=Grz_TestDataFactory.createGM(true,gg.Id,usr.id);
        }
         System.runAs(usr5){
          Grz_TestDataFactory.updateExternalUser(true,usr.Id);    
        }
        test.stopTest();
    }
    
     @isTest
    Public  static void UserAddINGroup(){
        Test.startTest();       
        Id recordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        account userAccount=new account(
            name='userAccount',
            recordtypeId=recordTypeId
        );
        insert userAccount;
        
        contact userContact=new contact(
            lastname='userName',
            AccountId=userAccount.id
        );
        insert userContact;
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        system.runAs(thisUser){
            UserRole portalRole = [Select Id From UserRole Where Name like '%Customer User%' limit 1];
              
            
            Id p = [select id from profile where name='India Partner Community Distributor Profile'].id;
            User user2 = new User(
                contactid=userContact.id,
                //UserRoleId = portalRole.Id,
                ProfileId = p,
                Username = 'TestUserCheckOut@gmail.com',
                Alias = 'batman',
                Email='bruce.wayne@wayneenterprises.com',
                EmailEncodingKey='UTF-8',
                Firstname='Bruce',
                Lastname='Wayne',
                LanguageLocaleKey='en_US',
                LocaleSidKey='en_US',
                TimeZoneSidKey='America/Chicago'
            );
            insert user2; 
             //Grz_userSmsControllerTest.myFutureMethod(user2.Id);
           
            test.stopTest(); 
        }
    }
    
@isTest
    Public  static void UserAddINGroup1(){
        Test.startTest();       
        Id recordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        account userAccount=new account(
            name='userAccount',
            recordtypeId=recordTypeId
        );
        insert userAccount;
        
        contact userContact=new contact(
            lastname='userName',
            AccountId=userAccount.id
        );
        insert userContact;
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        system.runAs(thisUser){
            UserRole portalRole = [Select Id From UserRole Where Name like '%Customer User%' limit 1];
              
            
            Id p = [select id from profile where name='Brazil Partner Community Distributor Profile'].id;
            User user2 = new User(
                contactid=userContact.id,
                //UserRoleId = portalRole.Id,
                ProfileId = p,
                Username = 'TestUserCheckOut1@gmail.com',
                Alias = 'batman',
                Email='bruce.wayne1@wayneenterprises.com',
                EmailEncodingKey='UTF-8',
                Firstname='Bruce',
                Lastname='Wayne',
                LanguageLocaleKey='en_US',
                LocaleSidKey='en_US',
                TimeZoneSidKey='America/Chicago'
            );
            insert user2; 
             //Grz_userSmsControllerTest.myFutureMethod(user2.Id);
           
            test.stopTest(); 
        }
    }
    
    
     Public  static testmethod void testupdateBRUserRegionAndTerritory(){
        Test.startTest();
        Id recordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Sales_Org__c sOrg = Grz_TestDataFactory.createSalesOrg(true, 'Test Org','5191');
        Account acc = Grz_TestDataFactory.createUserAccount(true, 'Test Account',recordTypeId,sOrg.Id);
        Contact con = Grz_TestDataFactory.createContact(true, 'Test Contact',acc.Id);
        Profile pro1 = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        Profile pro2 = [SELECT Id FROM Profile WHERE Name = 'Territory Manager'];
        User usr1 = Grz_TestDataFactory.createInternalUser(true,pro1.Id);
        System.debug('usr1 id:'+usr1.id);
        User usr=new User();
        User usr4=new User();
        User usr2 = Grz_TestDataFactory.createInternalUser(true,pro2.Id);
        
        test.stopTest();
    }

    

      /****************************************************************************
    
    * @Description  - This test class method will add new user in public group for argentina
    * Date - 18/08/2022
    * Author - Mohit garg(Grazitti)
    * Project - APPS-1757
    * Last modified by - Mohit Garg(Grazitti) 18/08/2022 
    *************************************************************************** */

    
    @isTest
    Public  static void UserAddINGroup3(){
        Test.startTest();       
        Id recordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Account userAccount = Grz_TestDataFactory.createAccount(true,'UserAccount',recordTypeId);
        
        Contact userContact = Grz_TestDataFactory.createContact(true, 'Test Contact',userAccount.Id);

        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        system.runAs(thisUser){
            UserRole portalRole = [Select Id From UserRole Where Name like '%Customer User%' limit 1];
              
            
            Id p = [select id from profile where name='Argentina Partner Community Distributor Profile'].id;
            User user2 = new User(
                contactid=userContact.id,
                //UserRoleId = portalRole.Id,
                ProfileId = p,
                Username = 'TestUserCheckOut12369@gmail.com',
                Alias = 'superman',
                Email='clerk.kent2@wayneenterprises.com',
                EmailEncodingKey='UTF-8',
                Firstname='clerk',
                Lastname='kent ',
                LanguageLocaleKey='es_AR',
                LocaleSidKey='es_AR',
                TimeZoneSidKey='America/Argentina/Buenos_Aires'
            );
            insert user2; 
           
            test.stopTest(); 
        }
    }
}