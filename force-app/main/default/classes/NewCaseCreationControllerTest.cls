@isTest
public without sharing class NewCaseCreationControllerTest {
    
    
    @isTest
    public static void testMethod1()
    {
        Id farmerRecordType  =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('PreRegistered Farmer').getRecordTypeId();
        Id akcRecordType  =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('AKC Retailer').getRecordTypeId();
        Id ConsumerRecordType=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Un-Register Consumer').getRecordTypeId();
        
        State__c st = new State__c(Name = 'Assam');
        insert st;
        Pin_code__c pin=new Pin_code__c();
        pin.name='335098';
        insert pin;
        District__c ds = new District__c(Name = 'Cacher', State__c= st.Id);
        insert ds;
        
        Tehsil__c ts = new Tehsil__c(Name = 'Cacher', District__c= ds.Id);
        insert ts;
        Village__c vill = new Village__c(Name = 'DidarKush', Tehsil__c= ts.Id, Postal_Code__c ='788099'); 
        insert vill;
        Account acc = new Account(LastName = 'TestAcc', VillageName__c = 'DidarKush',
                                  District__c = 'Cacher', StateName__c ='Assam',Preferred_Language__pc='English',Using_Smart_Phone__c='Yes',
                                  Using_Watsapp__c='Yes',Village__pc=vill.id,PersonMobilePhone = '9998887776' ,recordTypeId = farmerRecordType);
        insert acc;
        //Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenesysCallid());
        Test.startTest();
        Id akcRetailerRecordType  =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('AKC Retailer').getRecordTypeId();
        Id nurtureRecordType  =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('nurture.farm care').getRecordTypeId();
        Id consumerCaseRecordType=Schema.SObjectType.Case.getRecordTypeInfosByName().get('UPL consumer product').getRecordTypeId();
        NewCaseCreationController.getAccRecordTypes();
        
        NewCaseCreationController.getCaseRecTypeName(akcRetailerRecordType);
        NewCaseCreationController.insertAcc(farmerRecordType,'8889990001','English',null,'TestAcc','Yes','Yes',null,'');
         NewCaseCreationController.insertAccforUPLConsumer(ConsumerRecordType,'8889990003','English',null,null,pin.id,'TestAcca','Yes','Yes',null,'');
                NewCaseCreationController.getPrefLangOptions();
        NewCaseCreationController.getExistAccDetails(acc.id,'Account');
        //String accId1=(String)acc.id;
        //RITM0466996-Added by nandhini-This will cover changes related to New field introduction on Case create Page
        Map<Object, Object> caseinfosMap = new Map<Object, Object>();
        caseinfosMap.put('description', 'Test');
        caseinfosMap.put('customerRelated', 'Test');
        
        NewCaseCreationController.insertCase1('Account Holder','Outbound call','','',nurtureRecordType,acc.id,'.Farm','Weather',
                                              'Weather Forcast','Cyclone info','Query','Closed',true,'','','','',true,'','','',
                                              '','','','',caseinfosMap,'','','','','vijay@nurture.farm - Gujarat','');
        NewCaseCreationController.insertCase2('Account Holder','Outbound call','','',nurtureRecordType,acc.id,'.Farm','Weather',
                                              'Weather Forcast','Cyclone info','Query','Closed',true,'','','','',true,'','','',
                                              '','','','',caseinfosMap,'','','','','vijay@nurture.farm - Gujarat','');
       
        
        NewCaseCreationController.updateAcc(acc.id,'9998887776','English',vill.id,'Testacc','Yes','Yes',true);
         // NewCaseCreationController.updateAccforUPLComsumer(acc.id,'9998887776','English',vill.id,'Testacc','Yes','Yes',true,'Rajasthan',pin.id);

        
        //NewCaseCreationController.updateAcc(newAccId,'9998887776','English',vill.id,'Testacc','Yes','Yes',true);
        Test.stopTest();
    }
    
    @isTest
    public static void testMethod2()
    {
        Id farmerRecordType  =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('PreRegistered Farmer').getRecordTypeId();
        State__c st = new State__c(Name = 'Assam');
        insert st;
        
        District__c ds = new District__c(Name = 'Cacher', State__c= st.Id);
        insert ds;
        
        Tehsil__c ts = new Tehsil__c(Name = 'Cacher', District__c= ds.Id);
        insert ts;
        Village__c vill = new Village__c(Name = 'DidarKush', Tehsil__c= ts.Id, Postal_Code__c ='788099'); 
        insert vill;
        Account acc = new Account(LastName = 'TestAcc', VillageName__c = 'DidarKush',
                                  District__c = 'Cacher', StateName__c ='Assam',Preferred_Language__pc='English',Using_Smart_Phone__c='Yes',
                                  Using_Watsapp__c='Yes',Village__pc=vill.id,PersonMobilePhone = '9998887776' ,recordTypeId = farmerRecordType);
        insert acc;
      
        Test.startTest();
        String accId1=(String)acc.id;
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenesysCallid());
        NewCaseCreationController.getCallId('9998887776','test',accId1,'9997776665');
        NewCaseCreationController.updateCaseRecs(accId1,'xastdfxcuv');
        Test.stopTest();
    }
    
    @isTest
    public static void testMethod3()
    {
        State__c st = new State__c(Name = 'Assam');
        insert st;
        
        District__c ds = new District__c(Name = 'Cacher', State__c= st.Id);
        insert ds;
        
        Tehsil__c ts = new Tehsil__c(Name = 'Cacher', District__c= ds.Id);
        insert ts;
        Village__c vill = new Village__c(Name = 'DidarKush', Tehsil__c= ts.Id, Postal_Code__c ='788099'); 
        insert vill;
        Id unRegRecordType  =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('UnRegistered Farmer/Retailer').getRecordTypeId();
        Test.startTest();
        Id newAccId=NewCaseCreationController.insertAcc(unRegRecordType,'8889990001','English',null,'TestAcc','Yes','Yes',null,'');
          Id newAccId1=NewCaseCreationController.insertAccforUPLConsumer(unRegRecordType,'8889990001','English',null,null,null,'TestAcc','Yes','Yes',null,'');
        NewCaseCreationController.updateAcc(newAccId,'9998887776','English',vill.id,'Testacc','Yes','Yes',true);
         NewCaseCreationController.updateAccforUPLComsumer(newAccId,'9998887776','English',vill.id,'Testacc','Yes','Yes',true,null,null);

        Test.stopTest();
    } 
    /*Added by Ishu Mittal for CR-APPS4721 */

     @isTest
    public static void testMethod4()
    { Id farmerRecordType  =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('PreRegistered Farmer').getRecordTypeId();
        Id akcRecordType  =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('AKC Retailer').getRecordTypeId();
        Id ConsumerRecordType=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Un-Register Consumer').getRecordTypeId();
        
        State__c st = new State__c(Name = 'Assam');
        insert st;
        Pin_code__c pin=new Pin_code__c();
        pin.name='335098';
        insert pin;
        District__c ds = new District__c(Name = 'Cacher', State__c= st.Id);
        insert ds;
        
        Tehsil__c ts = new Tehsil__c(Name = 'Cacher', District__c= ds.Id);
        insert ts;
        Village__c vill = new Village__c(Name = 'DidarKush', Tehsil__c= ts.Id, Postal_Code__c ='788099'); 
        insert vill;
        Account acc = new Account(LastName = 'TestAcc', VillageName__c = 'DidarKush',
                                  District__c = 'Cacher', StateName__c ='Assam',Preferred_Language__pc='English',Using_Smart_Phone__c='Yes',
                                  Using_Watsapp__c='Yes',Village__pc=vill.id,PersonMobilePhone = '9998887776' ,recordTypeId = farmerRecordType);
        insert acc;
      Id consumerCaseRecordType=Schema.SObjectType.Case.getRecordTypeInfosByName().get('UPL consumer product').getRecordTypeId();
     NewCaseCreationController.CaseSection cs=new NewCaseCreationController.CaseSection(); 
  Map<Object, Object> inputMap = new Map<Object, Object>();
        inputMap.put('Description', 'xyz');
     inputMap.put('customerRelated', 'BitteR Lizard');
     cs.caseinfos=inputMap;
     cs.recordtypeId=consumerCaseRecordType;
     cs.status='Closed';
     cs.productFlag=true;
     cs.complaintFlag=true;
     test.startTest();
     NewCaseCreationController.insertPrimaryCaseForUPLConsumer(cs);
    // NewCaseCreationController.insertCase2forUPLConsumer(cs);
        NewCaseCreationController.getIssueTypeFromMetaData();
         NewCaseCreationController.getAccRecordTypesforUplConsumerProduct();
      //  NewCaseCreationController.updateAccforUPLComsumer(acc.id,'9998887776','English',vill.id,'Testacc','Yes','Yes',true,st.id,pin.id);
test.stopTest();
    }
    
  
}