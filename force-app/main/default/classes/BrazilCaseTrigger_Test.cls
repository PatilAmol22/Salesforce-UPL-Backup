/* Developer Name : Ketan Khatri
Purpose: To test the Brazil Case Trigger
*/
@isTest
public class BrazilCaseTrigger_Test { 
    @isTest
    static void test1(){
        Id devRecordTypeIdCase = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Brazil Case Process').getRecordTypeId();
        Id devRecordTypeIdAcc = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId(); 
        
        //Price_Group_Master__c pg = [Select id from price_group_master__c where PG_Code__c='03'];
        Price_Group_Master__c pg = new Price_Group_Master__c ();
        pg.PG_Code__c='03';
        insert Pg;
        
        /*Auto_Number__c auto = new Auto_Number__c();
auto.Name='FarmerCode';
auto.Sequence__c='11';
insert auto;*/
        
        /* Trigger_Settings__c tsObj = new Trigger_Settings__c();
tsObj.Name = 'CaseTrigger';
tsObj.isActive__c = True;
insert tsObj;
*/ 
        Account acc = new Account();
        acc.Name='Bhavik Devdhar';
        acc.Last_Name__c='Devdhar';
        acc.PriceGroupCode__c=pg.id;
        acc.SAP_Code__c='SAP996734';
        acc.RecordTypeId=devRecordTypeIdAcc;
        acc.Mobile__c='9967341759';
        acc.Phone='020256589';
        insert acc;
        
        userrole  usrole = new userrole();
        usrole.Name ='Customer User';
        
        Profile p = [SELECT Id,name FROM Profile WHERE Name = 'Brazil Customer Service User'];
        
        User sobj1 = new User();
        sobj1.Alias = 'zonaa';                                                            
        sobj1.Email = 'himanshua.mehta@skinternational.com';                             
        sobj1.ProfileId  = p.ID;                                                     
        sobj1.Username = 'zonal_aaexe1232@upl122333.com.devbox';                                    
        sobj1.IsActive = true;  
        sobj1.LastName='Terriotory Manager';
        sobj1.CommunityNickname = 'zonalExe1222 Di'; 
        sobj1.TimeZoneSidKey = 'America/Sao_Paulo'; 
        // sobj1.Contact.AccountID = acc.id;// Time Zone
        sobj1.LocaleSidKey = 'en_IN';                                    
        sobj1.LanguageLocaleKey = 'en_US';                                             
        sobj1.ForecastEnabled = false;                                                     
        sobj1.EmailEncodingKey = 'ISO-8859-1';    
        sobj1.Show_Inventory__c = false;                                                     
        sobj1.Show_Credit_Limit__c = false; 
        sobj1.UserRoleId=usrole.id;
        //sobj1.ContactId=con.Id;
        insert sobj1;
        
        User sobj2 = new User();
        sobj2.Alias = 'zonax';                                                            
        sobj2.Email = 'himanshux.mehta@skinternational.com';                             
        sobj2.ProfileId  = p.ID;                                                     
        sobj2.Username = 'zonax_aaexe1232@upl122333.com.devbox';                                    
        sobj2.IsActive = true;  
        sobj2.LastName='Terriotory Manager';
        sobj2.CommunityNickname = 'zonalExe1222 X'; 
        sobj2.TimeZoneSidKey = 'America/Sao_Paulo'; 
        // sobj1.Contact.AccountID = acc.id;// Time Zone
        sobj2.LocaleSidKey = 'en_IN';                                    
        sobj2.LanguageLocaleKey = 'en_US';                                             
        sobj2.ForecastEnabled = false;                                                     
        sobj2.EmailEncodingKey = 'ISO-8859-1';    
        sobj2.Show_Inventory__c = false;                                                     
        sobj2.Show_Credit_Limit__c = false; 
        sobj2.UserRoleId=usrole.id;
        //sobj1.ContactId=con.Id;
        insert sobj2;
        
        Case caseObj =  new Case();
        caseObj.RecordTypeId = devRecordTypeIdCase;
        caseObj.Status = 'Pendente Analista';
        caseObj.AccountId = acc.Id;
        caseObj.Type = 'Delivery Forcast';
        caseObj.Description='test';
        //caseObj.Brazil_Analyst__c = sobj1.id;
        
        insert caseObj;
        system.debug('1st case BA -->'+ caseObj.Brazil_Analyst__c);
        
        Test.startTest();
        caseObj.Brazil_Analyst__c = sobj1.Id;
        update caseObj;
        
        //Test.startTest();
        caseObj.Brazil_Analyst__c = sobj2.Id;
        update caseObj;
        
      //  caseObj.Brazil_Analyst__c = sobj1.Id;
       // update caseObj;
        
        Test.stopTest();
        system.debug('2nd case BA -->'+ caseObj.Brazil_Analyst__c);
        
    }
    
    Public  static testmethod void testsendCaseSmsComm(){
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator1());
        Id recordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Id caserecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Account acc = Grz_TestDataFactory.createAccount(true, 'Test Account', recordTypeId);
        Contact con = Grz_TestDataFactory.createContact(true, 'Test Contact',acc.Id);
        Grz_TestDataFactory.createTemplate(true,'Community_Case_Creation', 'Case');
        Profile pro = [SELECT Id FROM Profile WHERE Name = 'India Partner Community Distributor Profile'];
        Profile pro1 = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User usr1 = Grz_TestDataFactory.createInternalUser(true,pro1.Id);
        User usr=new User();
        System.runAs(usr1){
            Group gg=Grz_TestDataFactory.creategroup(true);
            usr = Grz_TestDataFactory.createExternalUser(true,pro.Id,con.Id);
            GroupMember gm=Grz_TestDataFactory.createGM(true,gg.Id,usr.id);
        }
        System.runAs(usr) {
            // The following code runs as user 'u'
            Grz_TestDataFactory.createCaseRecord(true, 'Test Case 123', 'Open', acc.id, caserecordTypeId);
        }
        test.stopTest();
    }
    // Test Method for India Case Create Flow 
    Public  static testmethod void testDistributorCaseCreate(){
        Grz_TestDataFactory.createTemplate(true,'Community_Case_Closure', 'Case');
        Id accRecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Id recordTypeShowId = Schema.SObjectType.Case.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        List<Partner_Portal_Configuration__c> ppcList = new List<Partner_Portal_Configuration__c>();
        Id recordTypeconfigId = Schema.SObjectType.Partner_Portal_Configuration__c.RecordTypeInfosByName.get('CaseConfiguration').RecordTypeId;         
        Partner_Portal_Configuration__c partnerObj1 = Grz_TestDataFactory.createSummaryTabs(false, 'HO Finance', 'CaseTypePicklist', 1, 'TestTab1Url', 'en-US', recordTypeconfigId);
        partnerObj1.Description__c = 'Test@gmail.com';
        ppcList.add(partnerObj1);
        Partner_Portal_Configuration__c partnerObj2 = Grz_TestDataFactory.createSummaryTabs(false, 'LOGISTICS HO', 'CaseTypePicklist', 1, 'TestTab1Url', 'en-US', recordTypeconfigId);
        partnerObj2.Description__c = 'Test@gmail.com';
        ppcList.add(partnerObj2);
        Partner_Portal_Configuration__c partnerObj3 = Grz_TestDataFactory.createSummaryTabs(false, 'Sales excellence', 'CaseTypePicklist', 1, 'TestTab1Url', 'en-US', recordTypeconfigId);
        partnerObj3.Description__c = 'Test@gmail.com';
        ppcList.add(partnerObj3);
        Partner_Portal_Configuration__c partnerObj4 = Grz_TestDataFactory.createSummaryTabs(false, 'FCE', 'CaseTypePicklist', 1, 'TestTab1Url', 'en-US', recordTypeconfigId);
        partnerObj4.Description__c = 'Test@gmail.com';
        ppcList.add(partnerObj4); 
        Partner_Portal_Configuration__c partnerObj5 = Grz_TestDataFactory.createSummaryTabs(false, 'CROP MANAGER', 'CaseTypePicklist', 1, 'TestTab1Url', 'en-US', recordTypeconfigId);
        partnerObj5.Description__c = 'Test@gmail1.com';
        ppcList.add(partnerObj5); 
        Profile pro1 = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User usr1 = Grz_TestDataFactory.createInternalUser(false,pro1.Id);
        usr1.Email = 'Test@gmail1.com';
        insert usr1;
        Sales_Org__c sorg = Grz_TestDataFactory.createSalesOrg(true, 'india', '1000');
        Zone__c zone = Grz_TestDataFactory.createZone(true,'Test Zone',userinfo.getUserId(),sorg.Id);
        Territory_Distributor__c trt = Grz_TestDataFactory.createTeritory(false);
        trt.Zone__c = zone.Id;
        insert trt;
        Account acc = Grz_TestDataFactory.createUserAccount(false,'Test Account',accRecordTypeId,sorg.Id);
        acc.Territory_Distributor__c = trt.Id;
        acc.Mobile__c = '9129394994';
        insert acc;
        DistributorSalesAreaMapping__c sa = Grz_TestDataFactory.CreateSalesArea(true,acc,sorg.Id,trt.Id);
        
        insert ppcList;
        Depot__c depo = Grz_TestDataFactory.createDepot(true,'Test',sorg.Id);
        TM_Depot_Mapping__c tmMap = Grz_TestDataFactory.createTMDepot(true,depo.Id);
        Case caseObj = Grz_TestDataFactory.createCaseRecord(false, 'Test Case', 'New', acc.Id, recordTypeShowId);
        caseObj.Type = 'Invoice'; 
        caseObj.Description='test';
        caseObj.SalesOrg__c = sorg.Id;
        caseObj.CaseOwner__c = 'C & F;RCM;Sales excellence;ZSM;FCE;LOGISTICS HO;CROP MANAGER;HO Finance';
        Test.startTest(); 
        insert caseObj;
        Test.stopTest();
    }
    
    // Test Method for India Close Case 
    @isTest
    static void testDistributorCaseClose(){
        Grz_TestDataFactory.createTemplate(true,'Community_Case_Closure', 'Case');
        Id accRecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Id recordTypeShowId = Schema.SObjectType.Case.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        List<Partner_Portal_Configuration__c> ppcList = new List<Partner_Portal_Configuration__c>();
        Id recordTypeconfigId = Schema.SObjectType.Partner_Portal_Configuration__c.RecordTypeInfosByName.get('CaseConfiguration').RecordTypeId;         
        Partner_Portal_Configuration__c partnerObj1 = Grz_TestDataFactory.createSummaryTabs(false, 'HO Finance', 'CaseTypePicklist', 1, 'TestTab1Url', 'en-US', recordTypeconfigId);
        partnerObj1.Description__c = 'Test@gmail.com';
        ppcList.add(partnerObj1);
        Partner_Portal_Configuration__c partnerObj2 = Grz_TestDataFactory.createSummaryTabs(false, 'LOGISTICS HO', 'CaseTypePicklist', 1, 'TestTab1Url', 'en-US', recordTypeconfigId);
        partnerObj2.Description__c = 'Test@gmail.com';
        ppcList.add(partnerObj2);
        Partner_Portal_Configuration__c partnerObj3 = Grz_TestDataFactory.createSummaryTabs(false, 'Sales excellence', 'CaseTypePicklist', 1, 'TestTab1Url', 'en-US', recordTypeconfigId);
        partnerObj3.Description__c = 'Test@gmail.com';
        ppcList.add(partnerObj3);
        Partner_Portal_Configuration__c partnerObj4 = Grz_TestDataFactory.createSummaryTabs(false, 'FCE', 'CaseTypePicklist', 1, 'TestTab1Url', 'en-US', recordTypeconfigId);
        partnerObj4.Description__c = 'Test@gmail.com';
        ppcList.add(partnerObj4); 
        Partner_Portal_Configuration__c partnerObj5 = Grz_TestDataFactory.createSummaryTabs(false, 'CROP MANAGER', 'CaseTypePicklist', 1, 'TestTab1Url', 'en-US', recordTypeconfigId);
        partnerObj5.Description__c = 'Test@gmail1.com';
        ppcList.add(partnerObj5); 
        Profile pro1 = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User usr1 = Grz_TestDataFactory.createInternalUser(false,pro1.Id);
        usr1.Email = 'Test@gmail1.com';
        insert usr1;
        Sales_Org__c sorg = Grz_TestDataFactory.createSalesOrg(true, 'india', '1000');
        Zone__c zone = Grz_TestDataFactory.createZone(true,'Test Zone',userinfo.getUserId(),sorg.Id);
        Territory_Distributor__c trt = Grz_TestDataFactory.createTeritory(false);
        trt.Zone__c = zone.Id;
        insert trt;
        Account acc = Grz_TestDataFactory.createUserAccount(false,'Test Account',accRecordTypeId,sorg.Id);
        acc.Territory_Distributor__c = trt.Id;
        acc.Mobile__c = '9129394994';
        insert acc;
        DistributorSalesAreaMapping__c sa = Grz_TestDataFactory.CreateSalesArea(true,acc,sorg.Id,trt.Id);
        system.debug('Test User Account : '+acc);
        // Test.startTest();        
        insert ppcList;
        
        Depot__c depo = Grz_TestDataFactory.createDepot(true,'Test',sorg.Id);
        Depot__c depo1 = Grz_TestDataFactory.createDepot(false,'Test1',sorg.Id);
        depo1.Depot_Code__c = '51234512';
        insert depo1;
        TM_Depot_Mapping__c tmMap = Grz_TestDataFactory.createTMDepot(false,depo.Id);
        TM_Depot_Mapping__c tmMap1 = Grz_TestDataFactory.createTMDepot(false,depo1.Id);
        List<TM_Depot_Mapping__c> tmList=new List<TM_Depot_Mapping__c>();
        tmList.add(tmMap);
        tmList.add(tmMap1);
        insert tmList;
        Case caseObj = Grz_TestDataFactory.createCaseRecord(false, 'Test Case', 'New', acc.Id, recordTypeShowId);
        caseObj.Type = 'Invoice'; 
        caseObj.Description='test';
        caseObj.SalesOrg__c = sorg.Id;
        caseObj.CaseOwner__c = 'C & F;RCM;Sales excellence;ZSM;FCE;LOGISTICS HO;CROP MANAGER;HO Finance';
        Test.startTest(); 
        insert caseObj;
        caseObj.Status = 'Closed';
        caseObj.Reason = 'Issue resolved';
        caseObj.Reason_for_Closure__c = 'Closing Test Case';
        update caseObj;
        Test.stopTest();
    }
    
    
    //added by kuhinoor
    private static testMethod void unit1(){  
        Id AccRecordId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Hannaford Farm').getRecordTypeId();
        Id idRecordId = Schema.SObjectType.case.getRecordTypeInfosByName().get('Hannaford General Query').getRecordTypeId();
        Account acc = new Account(Name = 'Test', Email__c = 'kuhinoor.barbhuiya@ibm.com',
                                  recordTypeId = AccRecordId,
                                  Country__c = 'Other', Tax_classification_for_customer__c= '1');
        insert acc;
        system.assertEquals(acc.name, 'Test');
        case cs = new case(subject = 'Test', recordTypeId = idRecordId, type='Open',
                           SuppliedEmail ='kuhinoor.barbhuiya@ibm.com');
        insert cs;
    }
    
    //Additional Line  
    static testMethod void myTestMethod(){
        
        
        Id devRecordTypeIdCase = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        Id devRecordTypeIdAcc = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId(); 
        
        Account acc = new Account();
        acc.Name='Bhavik Devdhar';
        acc.Last_Name__c='Devdhar';
        acc.SAP_Code__c='SAP996734';
        acc.RecordTypeId=devRecordTypeIdAcc;
        acc.Mobile__c='9967341759';
        acc.Phone='020256589';
        Test.startTest();
        insert acc; 
        
        
        List<Case> casList = new List<Case>();
        List<Case> listTobeUpdatedagain = new List<Case>();
        
        sales_Org__c so = new Sales_Org__c(Name = 'India', Sales_Org_Code__c = '1000');
        insert so;
        case cs1 = new case(subject = 'Test', recordTypeId = devRecordTypeIdCase, CategoryForSubcategory__c = 'Complaint', type = 'Invoicess', sub_category__c ='Payments & Receipts', AccountId = acc.Id, salesOrg__c = so.Id, Status = 'New');
        //insert cs1;
        case cs2 = new case(subject = 'Test', recordTypeId = devRecordTypeIdCase, CategoryForSubcategory__c = 'Request', type = 'Paymentss', Count_Open_Values__c = 3, sub_category__c ='Order Update', AccountId = acc.Id, salesOrg__c = so.Id, Status = 'New');
        //insert cs2;
        case cs3 = new case(subject = 'Test', recordTypeId = devRecordTypeIdCase, CategoryForSubcategory__c = 'Complaint', type = 'Productss', Count_Open_Values__c = 3, sub_category__c ='Product Availability', AccountId = acc.Id, salesOrg__c = so.Id, Status = 'New');
        case cs4 = new case(subject = 'Test', recordTypeId = devRecordTypeIdCase, CategoryForSubcategory__c = 'Request', type = 'Schemess', Count_Open_Values__c = 3, sub_category__c ='Schemes & Price Communication from HO', AccountId = acc.Id, salesOrg__c = so.Id, Status = 'New');
        
        casList.add(cs1);
        casList.add(cs2);
        casList.add(cs3);
        casList.add(cs4);
        insert casList;
        
        //Test.startTest();
        Case cas1 = [Select Id, type, catesub__c, sub_category__c, status, escalation_level__c, level2__C,Count_Open_Values__c, level3__c from case where Id =: cs1.Id];
        //cas1.Count_Open_Values__c = 0;
        cas1.Status = 'Reopen';
        //update cas1;
        Case cas2 = [Select Id, type, catesub__c, sub_category__c, status, escalation_level__c, level2__C,Count_Open_Values__c, level3__c from case where Id =: cs2.Id];
        //cas2.Count_Open_Values__c = 3;
        cas2.Status = 'Reopen';
        //update cas2;
        Case cas5 = [Select Id, type, catesub__c, sub_category__c, status, escalation_level__c, level2__C,Count_Open_Values__c, level3__c from case where Id =: cs3.Id];
        cas5.Status = 'Reopen';
        Case cas6 = [Select Id, type, catesub__c, sub_category__c, status, escalation_level__c, level2__C,Count_Open_Values__c, level3__c from case where Id =: cs4.Id];
        cas6.Status = 'Reopen';
        
        listTobeUpdatedagain.add(cas1);
        listTobeUpdatedagain.add(cas2);
        listTobeUpdatedagain.add(cas5);
        listTobeUpdatedagain.add(cas6);
        update listTobeUpdatedagain; 
        
        Test.StopTest(); 
        
    }
    /*  
* Name: CaseNurture    
* return:void
* Description: RITM0464580-This method responsible to cover InvokeCaseAssignmentForInlineEdit method.
*/     
    static testmethod void CaseNurture(){
        Id nurtureProfile = [SELECT Id, Name FROM Profile WHERE Name = 'Nurture CC Lead'].Id; //change this to Business Center Coordinator
        User userRecord = createSalesforceUser(true, NurtureProfile);
        List<Group> gpList=new List<Group>();
        Group gp= new Group();
        gp.Name= 'QRC Technical Queue';
        gp.DeveloperName= 'QRCTechnicalQueue';
        gp.Type= 'Regular';
        gpList.add(gp);
        Group gp1= new Group();
        gp1.Name= 'QRC Technical Queue L2';
        gp1.DeveloperName= 'QRCTechnicalQueueL2';
        gp1.Type= 'Regular';
        gpList.add(gp1);
        insert gpList;
        List<GroupMember> gmList=new List<GroupMember>();
        GroupMember gm=new GroupMember();
        gm.UserOrGroupId=userRecord.id;
        gm.GroupId=gpList[0].id;
        gmList.add(gm);
        GroupMember gm1=new GroupMember();
        gm1.UserOrGroupId=userRecord.id;
        gm1.GroupId=gpList[1].id;
        gmList.add(gm1);
        
        insert gmList;
        Test.startTest();
        System.runAS(userRecord){
            Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Distributor').RecordTypeId;
            Id nurtureRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('nurture_farm_care').getRecordTypeId();
            Case c=new case();
            c.recordtypeid = nurtureRecordTypeId;
            c.Caller_Type__c='Retailer';
            c.Caller_Name__c='Test New';
            c.Department__c='.Farm';
            c.QRC_Category__c='Nurture Farm App';
            c.QRC_sub_category__c='Cashout';
            c.Subject='Test New record';
            c.status='closed';
            c.Crop_pick__c='Insect';
            insert c;
            
            c.Subject='This is to cover update scenario';
            c.status='Escalated-L1';
            update c;
            
            
        }
        Test.stopTest();
    }
 /*  
* Name: CaseNurtureNew   
* return:void
* Description: RITM0481463-This method responsible to cover InvokeCaseAssignmentForInlineEdit method.
*/     
    static testmethod void CaseNurtureNew(){ 
        Id nurtureProfile = [SELECT Id, Name FROM Profile WHERE Name = 'Nurture CC Lead'].Id; //change this to Business Center Coordinator
        User userRecord = createSalesforceUser(true, NurtureProfile);
        List<Group> gpList=new List<Group>();
        Group gp= new Group();
        gp.Name= 'QRC Technical Queue';
        gp.DeveloperName= 'QRCTechnicalQueue';
        gp.Type= 'Regular';
        gpList.add(gp);
        Group gp1= new Group();
        gp1.Name= 'QRC Technical Queue L2';
        gp1.DeveloperName= 'QRCTechnicalQueueL2';
        gp1.Type= 'Regular';
        gpList.add(gp1);
        insert gpList;
        List<GroupMember> gmList=new List<GroupMember>();
        GroupMember gm=new GroupMember();
        gm.UserOrGroupId=userRecord.id;
        gm.GroupId=gpList[0].id;
        gmList.add(gm);
        GroupMember gm1=new GroupMember();
        gm1.UserOrGroupId=userRecord.id;
        gm1.GroupId=gpList[1].id;
        gmList.add(gm1);
        
        insert gmList;
        Test.startTest();
        System.runAS(userRecord){
            Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Distributor').RecordTypeId;
            Id nurtureRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('nurture_farm_care').getRecordTypeId();
            Case c=new case();
            c.recordtypeid = nurtureRecordTypeId;
            c.Caller_Type__c='Retailer';
            c.Caller_Name__c='Test New';
            c.Department__c='.Farm';
            c.QRC_Category__c='Nurture Farm App';
            c.QRC_sub_category__c='Cashout';
            c.Subject='Test New record';
            c.status='Escalated-L1';
            c.Crop_pick__c='Insect';
            insert c;
            
            c.Subject='This is to cover update scenario';
            c.status='Escalated-L2';
            update c;
            
            
        }
        Test.stopTest();
    }
     /*
    * 
    * 
    */
   static testmethod void  insertSkuUnitCostOnCase(){ 
      
       Id nurtureProfile = [SELECT Id, Name FROM Profile WHERE Name = 'Nurture CC Lead'].Id; //change this to Business Center Coordinator
        User userRecord = createSalesforceUser(true, NurtureProfile);
        
        System.runAS(userRecord){
        Sales_Org__c sorg =new Sales_Org__c();
        sorg.Name='USA';
        sorg.Description__c='USA';
        sorg.Sales_Org_Code__c='3100';
        sorg.Is_Active_Forecast__c = true;
        insert sorg;
      Id SkURecorTypeId = Schema.SObjectType.SKU__c.getRecordTypeInfosByDeveloperName().get('US').getRecordTypeId();
 
      SKU__c skuobj = new SKU__c(
            Name = 'NIMBUS 4X5 L',                        // SKU Name
            SKU_Code__c = '000000000005250380',             // SKU Code
            SKU_Description__c = 'NIMBUS 4X5 L',            // SKU Description
            UOM__c = 'L',                                   // UOM
          //  Division__c = div.Id,                // Division
            Sales_Org__c = sorg.Id,               // Sales Org
            Combination_Key__c = '3100000000000005250380',  // Combination Key
            Active__c = true, 
          RecordTypeId=SkURecorTypeId,// Active
            Multiple_of__c = 0.00                        // Multiple Of
        );
        insert skuobj;
       SKU__c skuobj1 = new SKU__c(
            Name = 'TEST 4X5 L',                        // SKU Name
            SKU_Code__c = '000000000005250382',             // SKU Code
            SKU_Description__c = 'TEST 4X5 L',            // SKU Description
            UOM__c = 'L',                                   // UOM
          //  Division__c = div.Id,                // Division
            Sales_Org__c = sorg.Id,               // Sales Org
            Combination_Key__c = '3100000000000005250382',  // Combination Key
            Active__c = true,                               // Active
            Multiple_of__c = 0.00,
            RecordTypeId=SkURecorTypeId// Multiple Of
        );
       // skuList.add(skuobj);
        insert skuobj1;
       Test.startTest();
            Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Distributor').RecordTypeId;
            Id nurtureRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('nurture_farm_care').getRecordTypeId();
            Case c=new case();
            c.recordtypeid = nurtureRecordTypeId;
            c.Caller_Type__c='Retailer';
            c.Caller_Name__c='Test New';
            c.Department__c='.Farm';
            c.QRC_Category__c='Nurture Farm App';
            c.QRC_sub_category__c='Cashout';
            c.Subject='Test New record';
            c.status='Escalated-L1';
            c.Crop_pick__c='Insect';
            c.SalesOrg__c=sorg.id;
            c.Pack_Size_SKU__c=skuobj.id;
            insert c;
            
           c.Pack_Size_SKU__c=skuobj1.id;
            update c;
            
            
        }
        Test.stopTest();
     
   }   
    
    static testmethod void testcaseInsertOperation(){
        Id colombiaProfile = [SELECT Id, Name FROM Profile WHERE Name = 'Business Center Coordinator Colombia'].Id; //change this to Business Center Coordinator
        User userRecord = createSalesforceUser(true, colombiaProfile);
        User UserforColombiaField = createUserforColombiafield(true, colombiaProfile);
        Test.startTest();
        System.runAS(userRecord){
            Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Distributor').RecordTypeId;
            Id colombiaRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Colombia_Case').getRecordTypeId();
            Sales_Org__c sOrg = Grz_TestDataFactory.createSalesOrg(true, 'Test Org','5710');
            Territory_Distributor__c trt = Grz_TestDataFactory.createTeritory(true);
            
            Account acc = new Account();
            acc.Name = 'Test Account';
            acc.Territory_Distributor__c = trt.Id;
            acc.RecordTypeId = accRecordTypeId;
            acc.SAP_Code__c = '1001801';
            acc.Sales_Org__c = sOrg.Id;
            acc.Sap_UserId__c = 'UPLINTCRM';
            acc.Mobile__c = '9129394994';
            insert acc;
            
            System.debug('acc>>>>>>>>>>>>>>.'+acc);
            //  Id colombiaRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Colombia_Case').getRecordTypeId();
            
            Case caseRecordInvoice =new Case(AccountId = acc.Id,recordtypeid = colombiaRecordTypeId,Status='New', Colombia_user__c = UserforColombiaField.id, Assignee__c = 'Billing Head',Type = 'Invoice');
            Case caseRecordDis =new Case(AccountId = acc.Id,recordtypeid = colombiaRecordTypeId,Status='New', Colombia_user__c = UserforColombiaField.id, Assignee__c = 'Billing Head',Type = 'Dispatch');
            Case caseeRecordOtros =new Case(AccountId = acc.Id,recordtypeid = colombiaRecordTypeId,Status='New', Colombia_user__c = UserforColombiaField.id, Assignee__c = 'Billing Head',Type = 'Other');
            Case caseeRecordOtro =new Case(AccountId = acc.Id,recordtypeid = colombiaRecordTypeId,Status='New', Colombia_user__c = UserforColombiaField.id, Assignee__c = 'Billing Head',Type = 'Other');
            List<Case> lsCase = new List<Case>();
            lsCase.add(caseRecordInvoice);
            lsCase.add(caseRecordDis);
            lsCase.add(caseeRecordOtros);
            lsCase.add(caseeRecordOtro);
            insert lsCase;
            //Contact con = Grz_TestDataFactory.createContact(true,'Test Contact',acc.Id);  
            //Case caseRecord = createCase(acc.Id, colombiaRecordTypeId, userRecord);
            //System.debug('Case >>>>>>>>>>>>>>.'+caseRecord);
            system.debug('List Case------>'+lsCase);
        }
        Test.stopTest();
    }
    /*  
* Name: CaseUpdateOperation    
* return:void
* Description: APPS-2074-This method responsible to cover changes related to Case Update Scenarios.
*/     
    static testmethod void CaseUpdateOperation(){
        Id colombiaProfile = [SELECT Id, Name FROM Profile WHERE Name = 'Business Center Coordinator Colombia'].Id; //change this to Business Center Coordinator
        User userRecord = createSalesforceUser(true, colombiaProfile);
        User UserforColombiaField = createUserforColombiafield(true, colombiaProfile);
        User userForEscalationfield = createUserforEscalationfield(true, colombiaProfile);
        //Test.startTest();
        System.runAS(userRecord){
            Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Distributor').RecordTypeId;
            Id colombiaRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Colombia_Case').getRecordTypeId();
            Sales_Org__c sOrg = Grz_TestDataFactory.createSalesOrg(true, 'Test Org','5710');
            Territory_Distributor__c trt = Grz_TestDataFactory.createTeritory(true);
            
            Account acc = new Account();
            acc.Name = 'Test Account';
            acc.Territory_Distributor__c = trt.Id;
            acc.RecordTypeId = accRecordTypeId;
            acc.SAP_Code__c = '1001801';
            acc.Sales_Org__c = sOrg.Id;
            acc.Sap_UserId__c = 'UPLINTCRM';
            acc.Mobile__c = '9129394994';
            insert acc;
            
            System.debug('acc>>>>>>>>>>>>>>.'+acc);
            //  Id colombiaRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Colombia_Case').getRecordTypeId();
            
            Case caseRecordInvoice =new Case(AccountId = acc.Id,recordtypeid = colombiaRecordTypeId,Status='New', Colombia_user__c = UserforColombiaField.id, Assignee__c = 'Billing Head',Type = 'Invoice');
            Case caseRecordDis =new Case(AccountId = acc.Id,recordtypeid = colombiaRecordTypeId,Status='New', Colombia_user__c = UserforColombiaField.id, Assignee__c = 'Billing Head',Type = 'Dispatch');
            Case caseeRecordOtros =new Case(AccountId = acc.Id,recordtypeid = colombiaRecordTypeId,Status='New', Colombia_user__c = UserforColombiaField.id, Assignee__c = 'Billing Head',Type = 'Other');
            Case caseeRecordOtro =new Case(AccountId = acc.Id,recordtypeid = colombiaRecordTypeId,Status='New', Colombia_user__c = UserforColombiaField.id, Assignee__c = 'Billing Head',Type = 'Other');
            List<Case> lsCase = new List<Case>();
            lsCase.add(caseRecordInvoice);
            lsCase.add(caseRecordDis);
            lsCase.add(caseeRecordOtros);
            lsCase.add(caseeRecordOtro);
            insert lsCase;
            Test.startTest();
            lsCase[0].Type = 'Dispatch';
            lsCase[0].EscalationUser__c=userForEscalationfield.id;
            update lsCase[0];
            system.assert(lsCase[0].Assignee__c =='Billing Head','Assignee field should be Billing Head for Type dipatch');
            system.debug('List Case------>'+lsCase);
            Test.stopTest();
        }
        //Test.stopTest();
        
    }
    
    /*static testmethod void RMCaseTestMethod(){
        Id systemAdministratorProfileId = [SELECT Id, Name FROM Profile WHERE Name = 'System Administrator'].Id;
        User userRecord = createSalesforceUser(true, systemAdministratorProfileId);
        
        System.runAS(userRecord){
            Test.startTest();
            Id recordTypeShowId = Schema.SObjectType.Case.RecordTypeInfosByName.get('RCMCase').RecordTypeId;            
            List<case> caseList=new List<Case>();
            Case caseObj = new Case();	
            caseObj.recordtypeid = recordTypeShowId;	
            caseObj.Status = 'New';
            caseObj.Type ='Method and Payment Terms';
            caseList.add(caseObj);
            
            contact con=new contact();
            con.firstname='Test';
            con.lastname='test2';
            //con.AccountId=acc.id;
            insert con;
            Insert caseList;
            Test.stopTest();
                      
           
        }
    }*/
    
   //Added by Nandhini for spain case management:APPS-5135
    static testmethod void spainCaseModuleTestMethod(){
        Id systemAdministratorProfileId = [SELECT Id, Name FROM Profile WHERE Name = 'System Administrator'].Id;
        User userRecord = createSalesforceUser(true, systemAdministratorProfileId);
        
        System.runAS(userRecord){
            Id iberiaRecordType = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Iberia_Community_Cases').getRecordTypeId();
            
            List<case> caseList=new List<Case>();
            Case caseObj = new Case();	
            caseObj.recordtypeid = iberiaRecordType;	
            caseObj.Status = 'Open';
            caseObj.Type ='Method and Payment Terms';
            caseList.add(caseObj);
            
            contact con=new contact();
            con.firstname='Test';
            con.lastname='test2';
            //con.AccountId=acc.id;
            insert con;
            Insert caseList;
            caseList[0].type='Product Delay';
            caseList[0].Status='Closed';
            caseList[0].Reopened_Count__c =1;
            Update caseList[0];
            caseList[0].Status='Open';
            //caseList[0].Reopened_Count__c =3;
            Update caseList[0];
            Test.startTest();
            SPainPortugalCaseEscalationBatch cb=new SPainPortugalCaseEscalationBatch();
            database.executeBatch(cb,5);            
            Test.stopTest();
        }
    }
    
    
    /*  
* Name: createUserforColombiafield    
* return:void
* Description: APPS-2074-To create one user for Colombia User field
*/ 
    static User createUserforColombiafield(Boolean doInsert, Id systemAdministratorProfileId){
        UserRole testUserRole = new UserRole();
        testUserRole.Name ='Case Escalation Test Assignee User';
        insert testUserRole;
        
        User sobj1 = new User();
        sobj1.Alias = 'zonaa23';                                                            
        sobj1.Email = 'swapnil.more@in.ibm.com11';
        sobj1.ProfileId  = systemAdministratorProfileId;                                                     
        sobj1.Username = 'zonal_aaexe1232@upl122333.com.devboxsdfsd';                                    
        sobj1.IsActive = true;  
        sobj1.LastName='More';
        sobj1.CommunityNickname = 'zonalExe1222 Di23'; 
        sobj1.TimeZoneSidKey = 'America/Sao_Paulo'; 
        sobj1.LocaleSidKey = 'en_IN';                                    
        sobj1.LanguageLocaleKey = 'en_US';                                             
        sobj1.ForecastEnabled = false;                                                     
        sobj1.EmailEncodingKey = 'ISO-8859-1';    
        sobj1.Show_Inventory__c = false;                                                     
        sobj1.Show_Credit_Limit__c = false; 
        //sobj1.UserRoleId = testUserRole.id;
        insert sobj1;
        return sobj1;
    }
     


    /*  
* Name: createUserforColombiafield    
* return:void
* Description: APPS-2074-To create one user for Escalation User field
*/ 
    static User createUserforEscalationfield(Boolean doInsert, Id systemAdministratorProfileId){
        UserRole testUserRole = new UserRole();
        testUserRole.Name ='Case Escalation Test Assignee User';
        insert testUserRole;
        
        User sobj1 = new User();
        sobj1.Alias = 'z45';                                                            
        sobj1.Email = 'swapnil.more@in.ibm.com12';
        sobj1.ProfileId  = systemAdministratorProfileId;                                                     
        sobj1.Username = 'zonal_aaexe1232@upl122333.com.devboxsdfsds3';                                    
        sobj1.IsActive = true;  
        sobj1.LastName='More';
        sobj1.CommunityNickname = 'zonalExe1222 Di2323'; 
        sobj1.TimeZoneSidKey = 'America/Sao_Paulo'; 
        sobj1.LocaleSidKey = 'en_IN';                                    
        sobj1.LanguageLocaleKey = 'en_US';                                             
        sobj1.ForecastEnabled = false;                                                     
        sobj1.EmailEncodingKey = 'ISO-8859-1';    
        sobj1.Show_Inventory__c = false;                                                     
        sobj1.Show_Credit_Limit__c = false; 
        //sobj1.UserRoleId = testUserRole.id;
        insert sobj1;
        return sobj1;
    }
    
    public static User createSalesforceUser(Boolean doInsert, Id colombiaProfile){
        UserRole testUserRole = new UserRole();
        testUserRole.Name ='Case Escalation Test Assignee User';
        insert testUserRole;
        
        User sobj1 = new User();
        sobj1.Alias = 'zonaa';                                                            
        sobj1.Email = 'swapnil.more@in.ibm.com';
        sobj1.ProfileId  = colombiaProfile;                                                     
        sobj1.Username = 'zonal_aaexe1232@upl122333.com.devbox';                                    
        sobj1.IsActive = true;  
        sobj1.LastName='More';
        sobj1.CommunityNickname = 'zonalExe1222 Di'; 
        sobj1.TimeZoneSidKey = 'America/Sao_Paulo'; 
        sobj1.LocaleSidKey = 'en_IN';                                    
        sobj1.LanguageLocaleKey = 'en_US';                                             
        sobj1.ForecastEnabled = false;                                                     
        sobj1.EmailEncodingKey = 'ISO-8859-1';    
        sobj1.Show_Inventory__c = false;                                                     
        sobj1.Show_Credit_Limit__c = false; 
        sobj1.UserRoleId = testUserRole.id;
        insert sobj1;
        return sobj1;
    }
    
    /*public static Case createCase(Id accId, Id caseRecordId, User userRecord){	
Id colombiaRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Colombia_Case').getRecordTypeId();

Case caseRecordInvoice =new Case(AccountId = acc.Id,recordtypeid = colombiaRecordTypeId,Status='New', Colombia_user__c = userRecord.id, Assignee__c = 'Billing Head',Type = 'Invoice');
Case caseRecordDis =new Case(AccountId = acc.Id,recordtypeid = colombiaRecordTypeId,Status='New', Colombia_user__c = userRecord.id, Assignee__c = 'Billing Head',Type = 'Dispatch');
Case caseeRecordOtros =new Case(AccountId = acc.Id,recordtypeid = colombiaRecordTypeId,Status='New', Colombia_user__c = userRecord.id, Assignee__c = 'Billing Head',Type = 'Other');
List<Case> lsCase = new List<Case>();
lsCase.add(caseRecordInvoice);
lsCase.add(caseRecordDis);
lsCase.add(caseeRecordOtros);
insert lsCase;
return caseObj;    	
}*/
   
}