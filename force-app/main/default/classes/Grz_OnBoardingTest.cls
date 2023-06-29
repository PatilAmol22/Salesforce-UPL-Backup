/**************************************************************************************************
* Name             : Grz_OnBoardingTest                                                     
* Description      : To cover the Apex class Grz_PartiOfBusinssTriggerHandler,Grz_OnBoardingAnnexure3TriggerHandler,
					 Grz_OnBoardingLegalCasesTriggerHandler,OnBoardingOtherBusinessTriggerHandler,Grz_OnBoardingPartnerTriggerHandler
* Created Date     : 17-01-2022                                                                        
* Project/JIRA     : APPS-2665                                                                        
* Created By       : Mohit Garg (Grazitti)                                                                        
* Last Modified By : Mohit Garg (Grazitti) 17-01-2022                                                                      
**************************************************************************************************/

@isTest
public class Grz_OnBoardingTest {
    @istest static void testOnBoarding(){
        
        Sales_Org__c objSalesOrg = new Sales_Org__c();
        objSalesOrg.Name = 'test1';
        objSalesOrg.Sales_Org_Code__c = '3710';
        insert objSalesOrg;
        
        
        Id stExam = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        
        Account objAcc = new Account();
        objAcc.RecordTypeId = stExam;
        objAcc.Name = 'Test';
        objAcc.Sales_Org__c = objSalesOrg.Id;
        //objAcc.PersonMobilePhone = '919898989898';
        insert objAcc;
        
        Division__c objDiv = new Division__c();
        objDiv.Name = 'Testing';
        objDiv.Division_Code__c = '20';
        insert objDiv;
        
        Distribution_Channel__c objDivChannel = new Distribution_Channel__c();
        objDivChannel.Name = 'Testt';
        objDivChannel.Distribution_Channel_Code__c = '10';
        insert objDivChannel;
        
        
        
        DistributorSalesAreaMapping__c objSalesArea = new DistributorSalesAreaMapping__c();
        objSalesArea.AccountType__c = 'Bill To Party';
        objSalesArea.Distributor__c = objAcc.Id;
        objSalesArea.Division__c = objDiv.Id;
        objSalesArea.DistributionChannel__c = objDivChannel.Id;
        objSalesArea.SalesOrg__c = objSalesOrg.Id;
        objSalesArea.Contract_Details_Submitted__c = false;
        insert objSalesArea;
        
        List<Particulars_of_the_Business__c> lstPOB = new List<Particulars_of_the_Business__c>();
        Particulars_of_the_Business__c objPOB = new Particulars_of_the_Business__c();
        objPOB.Name = 'Testing1';
        objPOB.Sales_Area__c = objSalesArea.Id;
        objPOB.CurrencyIsoCode = 'INR';
        lstPOB.add(objPOB);
        Database.SaveResult[] result = Database.insert(lstPOB, false);
        
        List<On_Boarding_Annexure_3__c> lstOBA = new List<On_Boarding_Annexure_3__c>();
        On_Boarding_Annexure_3__c objOBA = new On_Boarding_Annexure_3__c();
        objOBA.Name = 'test';
        objOBA.Sales_Area__c = objSalesArea.Id;
        objOBA.CurrencyIsoCode = 'INR';
        lstOBA.add(objOBA);
        Database.SaveResult[] result1 = Database.insert(lstOBA, false);
        
        On_Boarding_Legal_Cases__c objOBL = New On_Boarding_Legal_Cases__c();
        objOBL.Name = 'test';
        objOBL.Sales_Area__c = objSalesArea.Id;
        objOBL.CurrencyIsoCode = 'INR';
        Database.SaveResult saveOnBoLeCase = Database.insert(objOBL, false);
        
        On_Boarding_Other_Business__c objOBO = new On_Boarding_Other_Business__c();
        objOBO.Name = 'test';
        objOBO.Sales_Area__c = objSalesArea.Id;
        objOBO.CurrencyIsoCode = 'INR';
        Database.SaveResult saveOnBoOtBuness = Database.insert(objOBO, false);
        
        On_Boarding_Partner__c objOBP = new On_Boarding_Partner__c();
        objOBP.Name = 'test';
        objOBP.Sales_Area__c = objSalesArea.Id;
        objOBP.CurrencyIsoCode = 'INR';
        Database.SaveResult saveOnBoPart = Database.insert(objOBP, false);
        
        objSalesArea.Contract_Details_Submitted__c = true;
        update objSalesArea;
        
        Test.startTest();
        Database.DeleteResult result2 = Database.delete(objPOB, false);
        Database.DeleteResult result3 = Database.delete(objOBA, false);
        Database.DeleteResult deleteOnBoLeCase = Database.delete(objOBL, false);
        Database.DeleteResult deleteOnBoOtBuness = Database.delete(objOBO, false);
        Database.DeleteResult deleteOnBoPar = Database.delete(objOBP, false);
        Test.stopTest();
        
        
        
    }
}