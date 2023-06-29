@isTest(seeAllData=false)
public class Grz_LoyaltyAndRebateBrazilTest {
    static testMethod void CallgetGoals(){  
        Id recordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Sales_Org__c sOrg = Grz_TestDataFactory.createSalesOrg(true, 'Brazil', '5191');
        Account acc = Grz_TestDataFactory.createUserAccount(true, 'Test Account',recordTypeId,sOrg.Id);
        Contact con = Grz_TestDataFactory.createContact(true, 'Test Contact',acc.Id);
        Profile pro = [SELECT Id FROM Profile WHERE Name = 'Brazil Partner Community Distributor Profile'];
        Profile pro1 = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User usr1 = Grz_TestDataFactory.createInternalUser(true,pro1.Id);
        User usr=new User();
        System.runAs(usr1){
            Group gg=Grz_TestDataFactory.creategroup(true);
            usr = Grz_TestDataFactory.createExternalUser(true,pro.Id,con.Id);
            GroupMember gm=Grz_TestDataFactory.createGM(true,gg.Id,usr.id);
        }
        Grz_LoyaltyAndRebateBrazil.rebateContractWrapper rebContWrap = new Grz_LoyaltyAndRebateBrazil.rebateContractWrapper();
        Distribution_Channel__c disObj;
        Zone__c zn;
        Division__c DivObj;
        System.runAs ( usr ){
            rebate_Contract__c liRebateContract = new rebate_Contract__c();
            liRebateContract.Type__c = 'Livre';
            liRebateContract.Workflow_Status__c = 'Cartas de Crédito em processo de emissão';
            liRebateContract.Sales_Org__c = sOrg.Id;
            liRebateContract.Distributor__c = acc.Id;
            liRebateContract.Start_Date__c = Date.newInstance(2021, 04, 04);
            liRebateContract.End_Date__c = Date.newInstance(2021, 08, 08);
            insert liRebateContract;
            
            Rebate_Goal_Brand__c rb = new Rebate_Goal_Brand__c();
            rb.Contract__c =liRebateContract.Id; 
            rb.Product_Category__c = 'Outros';
            rb.Volume__c = 34;
            rb.Value__c = 65.3;
            rb.Actual_Volume__c = 65.3 ;
            rb.Actual_Value__c = 65.3; 
            rb.Returns_Volume__c = 65.3;
            rb.Returns_Value__c = 65.3; 
            insert rb;
            
            Rebate_Goal_Brand__c rb1 = new Rebate_Goal_Brand__c();
            rb1.Contract__c =liRebateContract.Id; 
            rb1.Product_Category__c = 'Biossoluções';
            rb1.Brand_Name__c = 'test';
            rb1.Volume__c = 34;
            rb1.Value__c = 65.3;
            rb1.Actual_Volume__c = 65.3 ;
            rb1.Actual_Value__c = 65.3; 
            rb1.Returns_Volume__c = 65.3;
            rb1.Returns_Value__c = 65.3; 
            rb1.Attainment_Volume__c = 34;
            rb1.Net_Volume__c = 32;
            rb1.Net_Value__c = 32;
            insert rb1;
            
            zn = Grz_TestDataFactory.CreateZoneBr();
            Territory_Distributor__c tr =Grz_TestDataFactory.CreateTerritoryBr(zn,usr,sorg) ;
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
            crmObj.Customer_Name__c = acc.Id;
            crmObj.Sales_Org__c =sorg.Id;   
            crmObj.Division__c = DivObj.Id;
            crmObj.Distribution_Channel__c = disObj.Id;
            crmObj.CustomerRegion__c=sorg.Id;
            crmObj.CustomerRegion__c =tr.Id;
            insert crmObj;
            Grz_LoyaltyAndRebateBrazil.getContractDate();  
            Grz_LoyaltyAndRebateBrazil.getContractData('2021-05-05', '2021-06-06', '', '', '', '', '', 'All', 'All', 'All', 1, null);
            Grz_LoyaltyAndRebateBrazil.getContractDetails(String.valueOf(liRebateContract.Id));
        }
        
        system.runAs(usr1){
            Territory_Distributor__c tr2 = new Territory_Distributor__c();
            tr2.name = 'test';
            tr2.SalesOrg__c =sorg.id;
            tr2.TerritoryManager__c=usr1.Id;
            tr2.Zone__c=zn.Id;
            tr2.TerritoryCode__c='BR1600';//added while create rebate 
            insert tr2;
            
            Customer_and_Region_Mapping__c crmObj2 =  new Customer_and_Region_Mapping__c();
            crmObj2.Customer_Name__c = acc.Id;
            crmObj2.Sales_Org__c =sorg.Id;   
            crmObj2.Division__c = DivObj.Id;
            crmObj2.Distribution_Channel__c = disObj.Id;
            crmObj2.CustomerRegion__c=sorg.Id;
            crmObj2.CustomerRegion__c =tr2.Id;
            insert crmObj2; 
            //rebContWrap= BRRebateModule.getContract(null,null);
            Region__c rg= new Region__c();
            rg.name = 'Region';
            rg.RegionHead__c=usr1.Id;
            rg.RegionCode__c='br1503';
            insert rg; 
            Zone__c zn1 = new Zone__c();
            zn1.Name='BU CERRADO LESTE';
            zn1.ZoneCode__c='BR12';
            zn1.ZonalHead__c=usr1.Id;
            insert zn1;
            
            SBU__c sb =new SBU__c();
            sb.SBUUser__c=usr1.id;
            sb.SBUCode__c='BR123';
            insert sb;
            
            Territory_Distributor__c tr3 = new Territory_Distributor__c();
            tr3.SalesOrg__c =sorg.id;
            tr3.SBU__c=sb.id;
            tr3.TerritoryManager__c=usr1.Id;
            tr3.Zone__c=zn1.Id;
            tr3.Region__c=rg.id;
            tr3.TerritoryCode__c='BR1500';//added while create rebate 
            insert tr3;
            
            Customer_and_Region_Mapping__c crmObj3 =  new Customer_and_Region_Mapping__c();
            crmObj3.Customer_Name__c = acc.Id;
            crmObj3.Sales_Org__c =sorg.Id;   
            crmObj3.Division__c = DivObj.Id;
            crmObj3.Distribution_Channel__c = disObj.Id;
            crmObj3.CustomerRegion__c=sorg.Id;
            crmObj3.CustomerRegion__c =tr3.Id;
            insert crmObj3;      
            
            rebate_Contract__c liRebateContract = new rebate_Contract__c();
            liRebateContract.Type__c = 'Livre';
            liRebateContract.Sales_Org__c = sOrg.Id;
            liRebateContract.Distributor__c = acc.Id;
            liRebateContract.Start_Date__c = Date.newInstance(2021, 04, 04);
            liRebateContract.End_Date__c = Date.newInstance(2021, 08, 08);
            insert liRebateContract;
            
            Grz_LoyaltyAndRebateBrazil.getContractDate();
            Grz_LoyaltyAndRebateBrazil.getContractData('2021-05-05', '2021-06-06', sb.Id, zn1.Id, rg.Id, tr3.Id, acc.Id, 'Up Líder', 'Elite', 'Cartas de Crédito em processo de emissão', 1, 1);
            Grz_LoyaltyAndRebateBrazil.getContractData('2021-05-05', '2021-06-06', '', '', '', '', '', 'All', 'All', 'All', 1, null);
            
        }
    }
}