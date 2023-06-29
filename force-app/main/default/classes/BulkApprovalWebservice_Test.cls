// Tests for BulkApprovalWebservice_Test

@isTest()
Private class BulkApprovalWebservice_Test {
    @isTest
    Static void beforeInsertProductTest(){
        
        
        
        UPL_Settings__c cs = new UPL_Settings__c();
        cs.Name = 'Test Name';
        cs.Grz_France_Case_Recordtypes__c = 'Re-labelling';    
        //insert new CustomSetting__c(Field__c = 'Value');
        
        
        //PageReference  pageRef = Page.mass_cases_update_status;
        
        
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        //Id devContactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('General_Contact').getRecordTypeId();
        //Id devCustomerVisitRecordTypeId = Schema.SObjectType.Customer_Visit__c.getRecordTypeInfosByName().get('FR NeoFog teams').getRecordTypeId();
        Id devCaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Re-labelling').getRecordTypeId();
        Id devCaseRecordTypeId1 = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        //system.debug('devCustomerVisitRecordTypeId ' + devCustomerVisitRecordTypeId);
        
        Sales_Org__c sorg = new Sales_Org__c();
        sorg.Name = 'France';
        sorg.Sales_Org_Code__c = '2710';
        insert sorg;
        
        Division__c div = new Division__c();
        div.Name = 'Decco';
        div.Description__c = 'Decco';
        div.Division_Code__c = 'DC';
        insert div; 
        
        Distribution_Channel__c dChannel =  new Distribution_Channel__c();
        dChannel.Name = '10';
        dChannel.Distribution_Channel_Code__c = '10';
        insert dChannel;
        
        Depot__c dep = new Depot__c(
            Name = 'UPL Do france - Aparecida de Goiania',   // Depot Name
            Country__c = 'france',                           // Country
            Depot_Code__c = 'FR04',                          // Depot Code
            Active__c = true,                                // Active
            SalesOrg__c = sorg.Id                           // Sales Org
        );
        insert dep;
        
        Profile p =  [SELECT Id FROM Profile WHERE Name = 'Customer Service User France' LIMIT 1];
        
        Sales_Org__c sorg1 = new Sales_Org__c();
        sorg1.Name = 'France';
        sorg1.Sales_Org_Code__c = '2710';
        insert sorg1;
        
        userrole  usrole = new userrole();
        usrole.Name ='Customer Service France';
        
        User user = new User();
        user.Alias = 'zonaa';                                                            
        user.Email = 'skim@skinternational123.com';                             
        user.ProfileId  = p.ID;                                                     
        user.Username = 'zonal_aaexe1232@upl122333.com.devbox';                                    
        user.IsActive = true;  
        user.LastName='Terriotory Manager';
        user.CommunityNickname = 'zonalExe1222 Di'; 
        user.TimeZoneSidKey = 'Asia/Kolkata'; 
        user.LocaleSidKey = 'en_IN';                                    
        user.LanguageLocaleKey = 'en_US';                                             
        user.ForecastEnabled = false;                                                     
        user.EmailEncodingKey = 'ISO-8859-1';    
        user.Show_Inventory__c = false;                                                     
        user.Show_Credit_Limit__c = false; 
        user.UserRoleId=usrole.id;
        //user.ContactId=con.Id;
        user.Country = 'France';
        insert user;
        
        User brzlU = new User();
        brzlU.Alias = 'zonaa2';                                                            
        brzlU.Email = 'sk@skinternational.com';                             
        brzlU.ProfileId  = p.ID;                                                     
        brzlU.Username = 'zonal7_aaexe1232@upl122333.com.devbox1';                                    
        brzlU.IsActive = true;  
        brzlU.LastName='TM';
        brzlU.CommunityNickname = 'zonal7Exe1222 Di'; 
        brzlU.TimeZoneSidKey = 'Asia/Kolkata'; 
        brzlU.LocaleSidKey = 'en_IN';                                    
        brzlU.LanguageLocaleKey = 'en_US';                                             
        brzlU.ForecastEnabled = false;                                                     
        brzlU.EmailEncodingKey = 'ISO-8859-1';    
        brzlU.Show_Inventory__c = false;                                                     
        brzlU.Show_Credit_Limit__c = false; 
        brzlU.UserRoleId=usrole.id;
        //brzlU.ContactId=con.Id;
        brzlU.Country = 'France';
        brzlU.ManagerId = user.Id;
        brzlU.Country_Head__c = user.Id;
        
        insert brzlU; 
        
        Account acc = new Account();
        acc.Name = 'LEONARDO PASSINATO';
        acc.Email__c = 'ganesh039@gmail.com';
        acc.Last_Name__c = 'PASSINATO';
        acc.SAP_Code__c = '2028843';
        acc.RecordTypeId = devRecordTypeId;
        acc.Mobile__c = '9967341759';
        acc.Phone = '01234567891';
        acc.Sales_Org__c = sorg.Id;
        acc.Division__c = Div.Id;
        acc.Distribution_Channel__c = dChannel.Id;
        acc.BillingCity = 'MINEIROS';
        acc.SAP_Code__c = '2028843';
        acc.Depot_Code__c = dep.Id;
        acc.Tax_Number_3__c = '114415455';
        acc.Tax_Number_1__c = '114414523';
        acc.Customer_Region__c = 'AC';
        acc.Customer_Group__c = '001';
        acc.Program_Margin_Discount__c = 0.00;
        acc.Active__c = true;
        acc.Search_Terms_1__c = 'LEONARDO PASSINATO';
        acc.Search_Terms_2__c = 'FAZ SEUBAK';
        //acc.key_account_manager__c = userTerMan1.Id;
        acc.Price_Conversion_Group__c = 'A';
        insert acc;
        
        //Account acc = [Select Id, Name From Account Where Name = '110 BOURGOGNE' Limit 1];
        //Contact con = [Select Id, Name From Contact where LastName = 'IgnoreMe' Limit 1];
        
        Contact con = new Contact(
            //RecordTypeId = devContactRecordTypeId,
            AccountId = acc.Id,
            LastName = 'ABC'
            //CurrencyIsoCode = 'INR - Indian Rupee' 
            //Segment_Multiselect__c = 'Dirigeant',
            //MobilePhone = '9123045876'
        );
        insert con;
        
        Case cas = new Case();
        cas.recordtypeId = devCaseRecordTypeId;
        //cas.AccountId = acc.Id;
        //cas.Customer_name__c = acc.Id;
        cas.Customer_service_lookup__c = user.Id;
        Cas.Status = 'Open';  
        cas.Origin = 'Call-Inbound';
        cas.Entity__c = 'UPL France';
        Cas.Date__c = System.Today();
        cas.Productname__c = 'a';
        cas.Packaging__c = '3';
        cas.Batch_no__c = '3';
        cas.Delivered_quantity__c = '3';
        cas.Quantity_incriminated__c = '3';
        cas.Label_quantity_for_can__c = 3;
        cas.Order_number__c = '3';
        cas.Shipping_date__c = System.Today();
        cas.Street__c = 'dsf';
        cas.City__c = 'ek';
        cas.ZIP_Postal__c = '342';
        cas.Detailed_description_of_the_complaint__c = 'ds';
        Insert cas;
        
        test.startTest();
        List<Case> ca = [Select Id,Record_Type__c, Closing_Comment__C, RecordTypeId, Status, RecordType.Name from Case Where id =: cas.id Limit 1];
        ApexPages.StandardSetController sc = new ApexPages.StandardSetController(ca);
        sc.setSelected(ca);
        MassCaseSubmitApprovalExtension extension = new MassCaseSubmitApprovalExtension(sc);
        
        
        System.assertEquals('1', extension.getMySelectedSize());
        //System.assertNotEquals(1, extension.UpdateRecords());
        
        
        //Case c = new Case();
        //c.Id = ca[0].Id;
        ca[0].Status = 'Closed';
        ca[0].Closing_Comment__c ='Closed';
        update ca;
        
        
        //caseClose();
        
        //Test.setCurrentPage(pageRef);
        //pageRef.getParameters().put('id',ca);
        //ApexPages.StandardController sc1 = new ApexPages.StandardController(ca);
        //MassCasesUpdateStatusExtension mcs = new MassCasesUpdateStatusExtension(sc1);
        
        
        //System.assertNotEquals(null, controller.caseClose());
        
        
        extension.submitApprovalRecords();
        
        
        
        
        
        
        /*Case cas1 = new Case();
        cas1.recordtypeId = devCaseRecordTypeId; */
        //cas1.AccountId = acc.Id;
        //cas1.Customer_name__c = acc.Id;
        /*cas1.Customer_service_lookup__c = user.Id;
        Cas1.Status = 'Open';  
        cas1.Origin = 'Call-Inbound';
        cas1.Entity__c = 'UPL France';
        Cas1.Date__c = System.Today();
        cas1.Productname__c = 'a';
        cas1.Packaging__c = '3';
        cas1.Batch_no__c = '3';
        cas1.Delivered_quantity__c = '3';
        cas1.Quantity_incriminated__c = '3';
        cas1.Label_quantity_for_can__c = 3;
        cas1.Order_number__c = '3';
        cas1.Shipping_date__c = System.Today();
        cas1.Street__c = 'dsf';
        cas1.City__c = 'ek';
        cas1.ZIP_Postal__c = '342';
        cas1.Closing_Comment__c = '';
        cas1.Detailed_description_of_the_complaint__c = 'ds';
        Insert cas1;
        
        
        
        List<ProcessInstanceWorkitem> workItems = [SELECT Id, ProcessInstanceId FROM ProcessInstanceWorkitem WHERE ProcessInstance.TargetObjectId =: ca[0].Id];
        Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
        
        List<ProcessInstance> pI = [SELECT Id, TargetObjectid, processDefinition.id, processDefinition.name , Status,(select id,actor.name 
                                    from Workitems),(SELECT Id, StepStatus, Comments,Actor.Name FROM Steps) 
                                    FROM ProcessInstance Where TargetObjectId =: ca[0].Id Limit 1];                                  // where ProcessDefinition.Name='France Case Approval Process'
  
        BulkApprovalWebService.bulkApprove(pI[0].TargetObjectid);  */              //pI[0].TargetObjectid
        BulkApprovalWebService.bulkApprove(ca[0].Id);   //cas1.Id
        test.stopTest();
        
        
    }  
    
}