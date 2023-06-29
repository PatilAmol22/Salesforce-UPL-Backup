/**************************************************************************************************
* Name             : Grz_UpdateOnboardingAccountTest
* Description      : To cover the Apex class Grz_UpdateOnboardingAccount
* Created Date     : 24-01-2022
* Project/JIRA     : APPS-2665
* Created By       : Mohit Garg (Grazitti)
* Last Modified By : Mohit Garg (Grazitti) 24-01-2022
**************************************************************************************************/

@isTest
public class Grz_UpdateOnboardingAccountTest {

    @isTest static void testUpdateAccountFromSalesArea(){
        
        
        Sales_Org__c objSalesOrg = Grz_TestDataFactory.createSalesOrg(true, 'India', '1000');
        
        Division__c objDiv = new Division__c();
        objDiv.Name = 'Testing';
        objDiv.Division_Code__c = '20';
        insert objDiv;
        
        Distribution_Channel__c objDivChannel = new Distribution_Channel__c();
        objDivChannel.Name = 'Testt';
        objDivChannel.Distribution_Channel_Code__c = '10';
        insert objDivChannel;
        
        Price_Group_Master__c objPG = new Price_Group_Master__c();
        objPG.CurrencyIsoCode = 'INR';
        objPG.PG_Code__c = '10';
        insert objPG;
        
        PrIce_List_Type_Master__c objPLT = new PrIce_List_Type_Master__c();
        objPLT.Price_List_Type__c = '82';
        objPLT.Sales_Org__c = objSalesOrg.Id;
                objPLT.Zone_Name__c= 'Test Zone';
        insert objPLT;
        
        Territory_Distributor__c objTD = Grz_TestDataFactory.createTeritory(true);
        
        Id stExam = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        
        Account objAcc = Grz_TestDataFactory.createUserAccount(true, 'Test', stExam, objSalesOrg.Id);
        
        DistributorSalesAreaMapping__c objSalesArea = new DistributorSalesAreaMapping__c();
        objSalesArea.Distributor__c = objAcc.Id;
        objSalesArea.PriceGroupMaster__c = objPG.Id;
        objSalesArea.Division__c = objDiv.Id;
        objSalesArea.DistributionChannel__c = objDivChannel.Id;
        objSalesArea.SalesOrg__c = objSalesOrg.Id;
        objSalesArea.PrIceListTypeMaster__c = objPLT.Id;
        objSalesArea.Territory__c = objTD.Id;
        insert objSalesArea;
        
        Test.startTest();
        Grz_UpdateOnboardingAccount.UpdateAccountFromSalesArea(objSalesArea.Id);
        Test.stopTest();
    }
    
    @isTest static void testUpdateAccountFromSalesArea1(){
        
        
        
        Sales_Org__c objSalesOrg1 = Grz_TestDataFactory.createSalesOrg(true, 'UPL SAS', '1000');
        
        Division__c objDiv = new Division__c();
        objDiv.Name = 'Testing';
        objDiv.Division_Code__c = '20';
        insert objDiv;
        
        Distribution_Channel__c objDivChannel = new Distribution_Channel__c();
        objDivChannel.Name = 'Testt';
        objDivChannel.Distribution_Channel_Code__c = '10';
        insert objDivChannel;
        
        Price_Group_Master__c objPG = new Price_Group_Master__c();
        objPG.CurrencyIsoCode = 'INR';
        objPG.PG_Code__c = '10';
        insert objPG;
        
        PrIce_List_Type_Master__c objPLT = new PrIce_List_Type_Master__c();
        objPLT.Price_List_Type__c = '82';
        objPLT.Sales_Org__c = objSalesOrg1.Id;
                objPLT.Zone_Name__c= 'Test Zone';
        insert objPLT;
        
        Territory_Distributor__c objTD = Grz_TestDataFactory.createTeritory(true);
        
        Id stExam = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        
        Account objAcc = Grz_TestDataFactory.createUserAccount(true, 'Test', stExam, objSalesOrg1.Id);
        
        DistributorSalesAreaMapping__c objSalesArea = new DistributorSalesAreaMapping__c();
        objSalesArea.Distributor__c = objAcc.Id;
        objSalesArea.PriceGroupMaster__c = objPG.Id;
        objSalesArea.Division__c = objDiv.Id;
        objSalesArea.DistributionChannel__c = objDivChannel.Id;
        objSalesArea.SalesOrg__c = objSalesOrg1.Id;
        objSalesArea.PrIceListTypeMaster__c = objPLT.Id;
        objSalesArea.Territory__c = objTD.Id;
        insert objSalesArea;
        
        Test.startTest();
        Grz_UpdateOnboardingAccount.UpdateAccountFromSalesArea(objSalesArea.Id);
        Test.stopTest();
    }
    
     @isTest static void testUpdateAccountFromSalesArea2(){
        
        Sales_Org__c objSalesOrg1 = Grz_TestDataFactory.createSalesOrg(true, 'SWAL', '1000');
        
        Division__c objDiv = new Division__c();
        objDiv.Name = 'Testing';
        objDiv.Division_Code__c = '20';
        insert objDiv;
        
        Distribution_Channel__c objDivChannel = new Distribution_Channel__c();
        objDivChannel.Name = 'Testt';
        objDivChannel.Distribution_Channel_Code__c = '10';
        insert objDivChannel;
        
        Price_Group_Master__c objPG = new Price_Group_Master__c();
        objPG.CurrencyIsoCode = 'INR';
        objPG.PG_Code__c = '10';
        insert objPG;
        
        PrIce_List_Type_Master__c objPLT = new PrIce_List_Type_Master__c();
        objPLT.Price_List_Type__c = '82';
        objPLT.Sales_Org__c = objSalesOrg1.Id;
                objPLT.Zone_Name__c= 'Test Zone';
        insert objPLT;
        
        Territory_Distributor__c objTD = Grz_TestDataFactory.createTeritory(true);
        
        Id stExam = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        
        Account objAcc = Grz_TestDataFactory.createUserAccount(true, 'Test', stExam, objSalesOrg1.Id);
        
        DistributorSalesAreaMapping__c objSalesArea = new DistributorSalesAreaMapping__c();
        objSalesArea.Distributor__c = objAcc.Id;
        objSalesArea.PriceGroupMaster__c = objPG.Id;
        objSalesArea.Division__c = objDiv.Id;
        objSalesArea.DistributionChannel__c = objDivChannel.Id;
        objSalesArea.SalesOrg__c = objSalesOrg1.Id;
        objSalesArea.PrIceListTypeMaster__c = objPLT.Id;
        objSalesArea.Territory__c = objTD.Id;
        insert objSalesArea;
        
        Test.startTest();
        Grz_UpdateOnboardingAccount.UpdateAccountFromSalesArea(objSalesArea.Id);
        Test.stopTest();
    }
    
    @isTest static void testUpdateAccountFromSalesArea3(){
        
        Sales_Org__c objSalesOrg1 = Grz_TestDataFactory.createSalesOrg(true, 'ALS India', '1000');
        
        Division__c objDiv = new Division__c();
        objDiv.Name = 'Testing';
        objDiv.Division_Code__c = '20';
        insert objDiv;
        
        Distribution_Channel__c objDivChannel = new Distribution_Channel__c();
        objDivChannel.Name = 'Testt';
        objDivChannel.Distribution_Channel_Code__c = '10';
        insert objDivChannel;
        
        Price_Group_Master__c objPG = new Price_Group_Master__c();
        objPG.CurrencyIsoCode = 'INR';
        objPG.PG_Code__c = '10';
        insert objPG;
        
        PrIce_List_Type_Master__c objPLT = new PrIce_List_Type_Master__c();
        objPLT.Price_List_Type__c = '82';
        objPLT.Sales_Org__c = objSalesOrg1.Id;
        objPLT.Zone_Name__c= 'Test Zone';
        insert objPLT;
        
        Territory_Distributor__c objTD = Grz_TestDataFactory.createTeritory(true);
        
        Id stExam = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        
        Account objAcc = Grz_TestDataFactory.createUserAccount(true, 'Test', stExam, objSalesOrg1.Id);
        
        DistributorSalesAreaMapping__c objSalesArea = new DistributorSalesAreaMapping__c();
        objSalesArea.Distributor__c = objAcc.Id;
        objSalesArea.PriceGroupMaster__c = objPG.Id;
        objSalesArea.Division__c = objDiv.Id;
        objSalesArea.DistributionChannel__c = objDivChannel.Id;
        objSalesArea.SalesOrg__c = objSalesOrg1.Id;
        objSalesArea.PrIceListTypeMaster__c = objPLT.Id;
        objSalesArea.Territory__c = objTD.Id;
        insert objSalesArea;
        
        Test.startTest();
        Grz_UpdateOnboardingAccount.UpdateAccountFromSalesArea(objSalesArea.Id);
        Test.stopTest();
    }
}