@isTest(seeAllData=false)
public class BRRebateModule_Test {
    
    static testMethod void CallgetGoals()
    {
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        system.debug('portalRole is ' + portalRole);
        
        
        Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
        User portalAccountOwner1 = new User(
            UserRoleId = portalRole.Id,
            ProfileId = profile1.Id,
            Username = System.now().millisecond() + 'test2@test.com',
            Alias = 'batman',
            Email='bruce.wayne123@wayneenterprises.com',
            EmailEncodingKey='UTF-8',
            Firstname='Bruce',
            Lastname='Wayne',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            TimeZoneSidKey='America/Chicago'
        );
        Database.insert(portalAccountOwner1);
        
        User portalUser ; 
        Account portalAccount1;
        Distribution_Channel__c disObj;
        Sales_Org__c sorg;
        Zone__c zn;
        Division__c DivObj;
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        
        
        System.runAs ( portalAccountOwner1 ) 
        {
            
            //Create account
            portalAccount1 = new Account(
                Name = 'TestAccount',
                OwnerId = portalAccountOwner1.Id,
                SAP_Code__c='0001034136',
                Mobile__c = '8888888888',
                RecordTypeId = devRecordTypeId
            );
            Database.insert(portalAccount1);
            
            //Create contact
            Contact contact1 = new Contact(
                FirstName = 'Test',
                Lastname = 'McTesty',
                AccountId = portalAccount1.Id,
                Email = System.now().millisecond() + 'test@test.com'
            );
            Database.insert(contact1);
            
            //Create user
            Profile portalProfile = [SELECT Id FROM Profile where name = 'Brazil Partner Community Distributor Profile' Limit 1];
            portalUser = new User(
                Username = System.now().millisecond() + 'test12345@test.com',
                ContactId = contact1.Id,
                ProfileId = portalProfile.Id,
                Alias = 'test123',
                Email = 'test12345@test.com',
                EmailEncodingKey = 'UTF-8',
                LastName = 'McTesty',
                CommunityNickname = 'test12345',
                TimeZoneSidKey = 'America/Los_Angeles',
                LocaleSidKey = 'en_US',
                LanguageLocaleKey = 'en_US'
            );
            Database.insert(portalUser);
        }
        BRRebateModule.rebateContractWrapper rebContWrap = new BRRebateModule.rebateContractWrapper();
        System.runAs ( portalUser ) 
        {
            //User usr = TestDataFactory.CreateUser();
            sorg =TestDataFactory.CreateSalesOrg();
            //Account acc = TestDataFactory.CreateAccount('1034561');
            zn = TestDataFactory.CreateZone();
            
            UPL_Settings__c uplsetting= new UPL_Settings__c(Visibility_Date__c = 10,SalesOrg__c='5191',PaddingSAPCode__c=10,PaddingSKU__c=18,BR_Sales_Org__c='5191',Stock_in_Channel_RFC__c='www.www.com',HCI_User_Name__c='test',HCI_Password__c='test',Rebate_Contract_URL__c='www.www.com');  
            insert uplsetting;
            
            Rebate_Contract__c rebContr = new Rebate_Contract__c();
            rebContr.Combination_Key__c='519010';
            rebContr.CRM_Status__c='New';
            rebContr.Name='10';
            rebContr.Sales_Org__c=sorg.Id;
            insert rebContr;
            
            
            Territory_Distributor__c tr =TestDataFactory.CreateTerritory(zn,portalUser,sorg) ;
            DivObj = new Division__c();
            DivObj.Name = '10';         
            DivObj.Description__c = null;    
            DivObj.Division_Code__c = '10'; 
            insert DivObj;
            
            disObj = new Distribution_Channel__c();
            disObj.Name = '20';                      
            disObj.Distribution_Channel_Code__c = '20';  
            disObj.Description__c='test';
            insert disObj;
            
            Customer_and_Region_Mapping__c crmObj =  new Customer_and_Region_Mapping__c();
            crmObj.Customer_Name__c = portalAccount1.Id;
            crmObj.Sales_Org__c =sorg.Id;   
            crmObj.Division__c = DivObj.Id;
            crmObj.Distribution_Channel__c = disObj.Id;
            crmObj.CustomerRegion__c=sorg.Id;
            crmObj.CustomerRegion__c =tr.Id;
            insert crmObj;
            rebContWrap= BRRebateModule.getContract(null,null);
            BRRebateModule.getlatestContractStatus(rebContr.Name);
            
        }
        
        user u= TestDataFactory.CreateUser();
        system.runAs(u)
        {
            Territory_Distributor__c tr2 = new Territory_Distributor__c();
            tr2.name = 'test';
            tr2.SalesOrg__c =sorg.id;
            tr2.TerritoryManager__c=u.Id;
            tr2.Zone__c=zn.Id;
            tr2.TerritoryCode__c='BR1600';//added while create rebate 
            insert tr2;
            
            Customer_and_Region_Mapping__c crmObj2 =  new Customer_and_Region_Mapping__c();
            crmObj2.Customer_Name__c = portalAccount1.Id;
            crmObj2.Sales_Org__c =sorg.Id;   
            crmObj2.Division__c = DivObj.Id;
            crmObj2.Distribution_Channel__c = disObj.Id;
            crmObj2.CustomerRegion__c=sorg.Id;
            crmObj2.CustomerRegion__c =tr2.Id;
            insert crmObj2; 
            //rebContWrap= BRRebateModule.getContract(null,null);
            Region__c rg= new Region__c();
            rg.name = 'Region';
            rg.RegionHead__c=u.Id;
            rg.RegionCode__c='br1503';
            insert rg; 
            Zone__c zn1 = new Zone__c();
            zn1.Name='BU CERRADO LESTE';
            zn1.ZoneCode__c='BR12';
            zn1.ZonalHead__c=u.Id;
            insert zn1;
            
            SBU__c sb =new SBU__c();
            sb.SBUUser__c=u.id;
            sb.SBUCode__c='BR123';
            insert sb;
            
            Territory_Distributor__c tr3 = new Territory_Distributor__c();
            tr3.SalesOrg__c =sorg.id;
            tr3.SBU__c=sb.id;
            tr3.TerritoryManager__c=u.Id;
            tr3.Zone__c=zn1.Id;
            tr3.Region__c=rg.id;
            tr3.TerritoryCode__c='BR1500';//added while create rebate 
            insert tr3;
            
            Customer_and_Region_Mapping__c crmObj3 =  new Customer_and_Region_Mapping__c();
            crmObj3.Customer_Name__c = portalAccount1.Id;
            crmObj3.Sales_Org__c =sorg.Id;   
            crmObj3.Division__c = DivObj.Id;
            crmObj3.Distribution_Channel__c = disObj.Id;
            crmObj3.CustomerRegion__c=sorg.Id;
            crmObj3.CustomerRegion__c =tr3.Id;
            insert crmObj3;      
            rebContWrap= BRRebateModule.getContract(null,null); 
        }
        
    }
    
    
    static testMethod void CallgetHistoryGoals()
    {
        
        
        list<BRRebateModule.goalHistoryWrapper> lstHistory = new list<BRRebateModule.goalHistoryWrapper>();
        BRRebateModule.rebateContract rc = new BRRebateModule.rebateContract();
        rc.Contract='9';
        
        lstHistory= BRRebateModule.getHistoryGoals(rc);
        BRRebateModule.rebateContract rc2 = new BRRebateModule.rebateContract();
        Sales_Org__c sorg =TestDataFactory.CreateSalesOrg();
        
        Rebate_Contract__c rebContr = new Rebate_Contract__c();
        rebContr.Combination_Key__c='519010';
        rebContr.CRM_Status__c='New';
        rebContr.Name='10';
        rebContr.Total_Other_Value__c=10.11;
        rebContr.Total_Other_Value_LY__c=10.12;
        rebContr.Sales_Org__c=sorg.id;
        rebContr.Last_Sent_Appoval_Step__c=5;
        
        //rebContr.Sales_Org__c=sorg.Id;
        insert rebContr;
        list<string> contractList= new list<string>();
        contractList.add(rebContr.Id);
        
        Rebate_Goal_SKU__c rgsku= new Rebate_Goal_SKU__c();
        rgsku.Value_LY__c=10.11;
        rgsku.Value__c=10.10;
        rgsku.Contract__c=rebContr.id;
        rgsku.Volume__c=10.99;
        rgsku.Price__c=10.90;
        insert rgsku;
        
        Rebate_Contract_Workflow__c rcw= new Rebate_Contract_Workflow__c();
        rcw.Contract__c=rebContr.id;
        insert rcw;
        rc2.ContractId=rebContr.id;
        rc2.Contract='10';
        rc2.TotalValue=10.11;
        rc2.TotalValueLY=10.22;
        rc2.TotalOtherValue=12.22;
        rc2.TotalTypeValue=12.22;
        rc2=BRRebateModule.UpdateDistributorAcceptance(rc2);
        lstHistory=BRRebateModule.getHistoryGoals(rc2);
        
        
        list<BRRebateModule.goalDetailsWrapper> lstGoalsDetailsWrapper = new list <BRRebateModule.goalDetailsWrapper>();
        lstGoalsDetailsWrapper= BRRebateModule.getGoals(rC2);
        
        list<BRRebateModule.goalDetailsWrapper> lstGoalsDetailsWrapper2 = new list <BRRebateModule.goalDetailsWrapper>();
        BRRebateModule.goalDetailsWrapper lstgdw= new BRRebateModule.goalDetailsWrapper();
        lstgdw.Id=rgsku.id;
        lstGoalsDetailsWrapper2.add(lstgdw);
        String updategoal;
        updategoal= BRRebateModule.updateGoals(lstGoalsDetailsWrapper2,rc2);
        
        BRRebateModule.sendGoals(lstGoalsDetailsWrapper2,rc);
        //BRRebateModule.SyncApproval(contractList);
        User usr = TestDataFactory.CreateUser();
        Account acc = TestDataFactory.CreateAccount('SAP996734');
        Zone__c zn = TestDataFactory.CreateZone();
        Territory_Distributor__c tr =TestDataFactory.CreateTerritory(zn,usr,sorg);
        rc2.TerritoryId=tr.id;
        insert new UPL_Settings__c(Rebate_Get_Actuals_URL__c='www.www.com',Visibility_Date__c = 10,SalesOrg__c='5191',PaddingSAPCode__c=10,PaddingSKU__c=18,Company_Code__c='5190',Marketing_Director_Email__c='swapnil.more@in.ibm.com',BR_Sales_Org__c='5191',HCI_User_Name__c='test',HCI_Password__c='test',Rebate_Contract_URL__c='www.asd.com');    
        
        system.runAs(usr)
        {
            updategoal= BRRebateModule.updateAndSubmitGoals(lstGoalsDetailsWrapper2,rc2);
        }   
        
        BRRebateModule.goalvsActualCalculations gvc = new BRRebateModule.goalvsActualCalculations();
        gvc=BRRebateModule.getgoalvsActualCalculations(rc2);
        //For  BRRebateModule1 test coverage- Gurubaksh Grewal(Grazitti) (RITM0523779 )
        BRRebateModule1.getgoalvsActualCalculations(rc2.ContractId);
    } 
    Public  static testmethod void testRebatePercentages(){
        
        Test.setMock(HttpCalloutMock.class, new Grz_SapIntegrationMockTestDataFactory(true)); 
        Grz_RebatePercentagesUploader.upsRebPercentages();
        test.starttest();
        Grz_RebatePercentagesScheduler myClass = new Grz_RebatePercentagesScheduler ();   
        String chron = '0 0 23 * * ?';        
        system.schedule('Test Sched', chron, myClass);
        test.stopTest();
        
    }
    
    
     static testMethod void testPdfAction() {
        // Create test data
        Rebate_Contract__c contract = new Rebate_Contract__c(Name = 'Test Contract');
        insert contract;

        // Set up PageReference mock
        Test.setCurrentPageReference(new PageReference('/apex/PrintRebateForm'));
        ApexPages.currentPage().getParameters().put('contractId', contract.Id);

        // Call the method to test
        Test.startTest();
        String result = BRRebateModule.pdfAction(contract.Id);
        Test.stopTest();

        // Verify the assertions

        // Verify that the return value is 'Success'
        System.assertEquals('Success', result);

        // Verify that a ContentVersion record is inserted
        Integer contentVersionCount = [SELECT COUNT() FROM ContentVersion];
        System.assertEquals(1, contentVersionCount);

        // Verify that a ContentDocumentLink record is inserted for the ContentVersion
       // Integer contentDocumentLinkCount = [SELECT COUNT() FROM ContentDocumentLink WHERE ContentVersionId = :[SELECT Id FROM ContentVersion]];
       // System.assertEquals(1, contentDocumentLinkCount);

        // Verify any other specific conditions or behaviors as needed
    }


    
}