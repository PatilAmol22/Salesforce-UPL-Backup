/* Name : TST_AccountUpdateController
 * Covergae Class : AccountUpdateController
 * Created By: Varun Shrivastava
*/
@isTest(seeAllData=False)
private  class TST_AccountUpdateController {

    @Testsetup
    static void setupTestData(){
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        
        Sales_Org__c salesorg = new Sales_Org__c();
        salesorg.Name = 'Swal';          
        salesorg.Description__c = 'Swal';   
        salesorg.Company_Code__c = '1210';    
        salesorg.Sales_Org_Code__c = '1200';
        insert salesorg;
        
        Region__c regObj= new Region__c();
        regObj.Name='Mumbai';
        regObj.RegionCode__c='045';
        insert regObj;
        
        SBU__c SBUObj = new SBU__c();
        SBUObj.SBUUser__c = UserInfo.getUserId();
        SBUObj.SBUCode__c = 'SBU2';
        SBUObj.SalesOrg__c = salesorg.id;
        insert SBUObj;
        
        Zone__c zoneObj = new Zone__c();
        zoneObj.Name = 'Maharashtra';             
        zoneObj.SalesOrg__c = salesorg.Id;   
        zoneObj.ZoneCode__c = 'Z16';               
        zoneObj.ZonalHead__c = UserInfo.getUserId();  
        zoneObj.SBUCode__c = SBUObj.Id;    
        insert zoneObj;
        
        Territory_Distributor__c territoryObj = new Territory_Distributor__c();
        territoryObj.Name = 'Dhule';
        territoryObj.TerritoryCode__c = '398';
        territoryObj.SalesOrg__c = salesorg.id;
        territoryObj.Region__c = regObj.id;
        territoryObj.TerritoryManager__c = UserInfo.getUserId();
        territoryObj.Zone__c = zoneObj.id;
        territoryObj.SBU__c = SBUObj.Id;
        territoryObj.Present_in_KEDE__c = true;
        territoryObj.Neglected__c = false;
        insert territoryObj;
        //Added by Nandhini to increase a code coverage
        Territory_Distributor__c territoryObj1 = new Territory_Distributor__c();
        territoryObj1.Name = 'Dhule1';
        territoryObj1.TerritoryCode__c = '3984';
        territoryObj1.SalesOrg__c = salesorg.id;
        /*territoryObj1.Region__c = regObj.id;
        //territoryObj.TerritoryManager__c = UserInfo.getUserId();
        territoryObj1.Zone__c = zoneObj.id;
        territoryObj1.SBU__c = SBUObj.Id;*/
        territoryObj1.Present_in_KEDE__c = true;
        territoryObj1.Neglected__c = false;
        insert territoryObj1;
        
        State_Tax_Structure__c statetax = new State_Tax_Structure__c();
        statetax.State_Name__c = 'Maharashtra';
        statetax.Country__c = 'India';          
        statetax.Tax__c = 10;           
        statetax.State_Code__c = '13';
        statetax.AdditionalTax__c = 30;
        statetax.SalesOrg__c = salesOrg.Id;
        insert statetax;
        
        Depot__c depObj=new Depot__c();
        depObj.Name='Pune';
        depObj.Country__c='India';
        depObj.Location__c='Pune';
        depObj.Depot_Code__c='PUN1';
        depObj.Active__c=true;
        depObj.SalesOrg__c=salesorg.Id;
        depObj.Region__c=statetax.Id;
        insert depObj;
        
        Distribution_Channel__c discObj=new Distribution_Channel__c();
        discObj.Name='10';
        discObj.Description__c='xyz';
        discObj.Distribution_Channel_Code__c='2012';
        insert discObj;
        
        Division__c divObj= new Division__c();
        divObj.Name='Abc';
        divObj.Description__c = 'xyz';
        divObj.Division_Code__c= '10';
        insert divObj;
        
            
        Account acnt= new Account();
        acnt.Name = 'Test Account';
        acnt.Email__c='varshriv@ulp-ltd.com';
        acnt.BillingCity ='Pune';
        acnt.BillingCountry='India';
        acnt.Territory_Distributor__c = territoryObj.ID;
        acnt.RecordTypeId=devRecordTypeId;
        acnt.Mobile__c='9867341712';
        acnt.Phone='020256580';
        acnt.Sales_Org__c=salesOrg.Id;
        acnt.SAP_Code__c='SAP123456';
        acnt.Depot_Code__c=depObj.Id;
        acnt.Distribution_Channel__c=discObj.Id;
        acnt.Division__c=divObj.Id;
        acnt.State_Tax_Structure__c=statetax.Id;
        insert acnt;
        //Added by Nandhini to increase a code coverage
        Account acnt1= new Account();
        acnt1.Name = 'Test Account1';
        acnt1.Email__c='varshriv1@ulp-ltd.com';
        acnt1.BillingCity ='Pune';
        acnt1.BillingCountry='India';
        acnt1.Territory_Distributor__c = territoryObj1.ID;
        acnt1.RecordTypeId=devRecordTypeId;
        acnt1.Mobile__c='98673417121';
        acnt1.Phone='0202565801';
        acnt1.Sales_Org__c=salesOrg.Id;
        acnt1.SAP_Code__c='SAP1234561';
        acnt1.Depot_Code__c=depObj.Id;
        acnt1.Distribution_Channel__c=discObj.Id;
        acnt1.Division__c=divObj.Id;
        acnt1.State_Tax_Structure__c=statetax.Id;
        insert acnt1;
        
    }
    
    static testMethod void accountUpdateCovergae(){
        Test.startTest();
        List<Territory_Distributor__c> territory = [Select Id from Territory_Distributor__c where Name = 'Dhule'];
        List<Id> territoryIdList= new List<Id>();
        territoryIdList.add(territory[0].ID);
        AccountUpdateController.getAccountNames(territoryIdList);
        AccountUpdateRegionOrZonalChange.TerritoryInfo TmInfo=new AccountUpdateRegionOrZonalChange.TerritoryInfo();
        TmInfo.territoryList=territoryIdList;
        List<AccountUpdateRegionOrZonalChange.TerritoryInfo> TMInfoList=new List<AccountUpdateRegionOrZonalChange.TerritoryInfo>();
        TMInfoList.add(TmInfo);
        AccountUpdateRegionOrZonalChange.getAccountNames(TMInfoList);
        Test.stopTest();
    }
/*  
* Name: accountUpdateCovergaeElsePart    
* return:void
* Description: This method responsible to cover AccountUpdateBatch code when OwnershipofAccount__c is Blank .
*/       
     static testMethod void accountUpdateCovergaeElsePart(){
        Test.startTest();
        List<Territory_Distributor__c> territory = [Select Id,OwnershipofAccount__c from Territory_Distributor__c where Name = 'Dhule1'];
         system.debug('territory blank :'+territory);
        List<Id> territoryIdList= new List<Id>();
        territoryIdList.add(territory[0].ID);
        AccountUpdateController.getAccountNames(territoryIdList);
        Test.stopTest();
    }
    
    static testMethod void accountUpdateFailureCovergae(){
        Test.startTest();
        List<Territory_Distributor__c> territory = [Select Id from Territory_Distributor__c where Name = 'Dhule'];
        List<Id> territoryIdList= new List<Id>();
        territoryIdList.add(territory[0].ID);
        AccountUpdateController.getAccountNames(territoryIdList);
        Test.stopTest();
    }
}