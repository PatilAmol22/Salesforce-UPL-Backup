/**************************************************************************************************
* Name             : Grz_SAPSyncSalesAreaTest                                                     
* Description      : To cover the Apex class Grz_SAPSyncSalesArea                    
* Created Date     : 26-01-2023                                                                       
* Project/JIRA     : UPL                                                                 
* Created By       : Rahul Mehta  (Grazitti)                                                                        
* Last Modified By : Gurubaksh Grewal (Grazitti) 01-02-2023                                                                     
**************************************************************************************************/

@isTest
public class Grz_SAPSyncSalesAreaTest {
    
    @testSetup static void setup() {
        
        Customer_Group__c ctg=new Customer_Group__c();
        ctg.Name='TestCustomer';
        ctg.Customer_Group_Code__c='76';
        ctg.Customer_Group_Desc__c='B2C';
        insert ctg;
        Sales_Org__c SalesO=Grz_TestDataFactory.createSalesOrg(false,'SWAL','1410');
        Sales_District__c SalesD= new Sales_District__c();
        SalesD.Name='ER – EMILIA ROMAGNA';
        SalesD.Sales_District_Code__c='IT0001';
        insert SalesO;
        User us=[select id,email,TM_Code__c from User where id=:userinfo.getUserId()];
        us.email='grazittitest@test.com';
        us.TM_Code__c=' 41208327';
        update us;
        
        Territory_Distributor__c terriD=new Territory_Distributor__c();
        terriD.Name = 'test';
        terriD.TerritoryCode__c = 'IND1234';
        terriD.RCM_Email__c = 'TestUser@gmail.com';
        terriD.TerritoryManager__c = us.Id;
        insert terriD;
        
        Depot__c dp = new Depot__c();
        dp.Name = 'NewDepot';
        dp.Depot_Code__c = dp.Name+'ind1001';
        dp.Case_Access_Email__c = 'Test123@gmail.com';
        dp.Active__c = true;
        dp.SalesOrg__c = SalesO.Id;
        insert dp;
        Sales_District__c salesDi= new Sales_District__c();
        salesDi.Name='000002';
        salesDi.Sales_District_Code__c='000002';
        salesDi.SalesOrg__c=SalesO.Id;
        insert salesDi;
        
        Price_Group_Master__c pgm= new Price_Group_Master__c();
        pgm.PG_Code__c='4';
        pgm.Description_Colombia__c='Dealer';
        insert pgm;
        
        SBU__c sbu =new SBU__c();
        sbu.SBUCode__c='902';
        sbu.SalesOrg__c=SalesO.Id;
        insert sbu;
        
        Zone__c zone = Grz_TestDataFactory.createZone(True, 'Jammu', us.Id, SalesO.id);
        
        
        PrIce_List_Type_Master__c plm=new PrIce_List_Type_Master__c();
        plm.Price_List_Type__c='82';
        plm.SBU__c=sbu.Id;
        plm.Zone__c=zone.Id;
        plm.Zone_Name__c=zone.name;
        
        insert plm;
        
        Division__c objDiv = new Division__c();
        objDiv.Name = 'Testing';
        objDiv.Division_Code__c = '10';
        insert objDiv;
        
        Distribution_Channel__c objDivChannel = new Distribution_Channel__c();
        objDivChannel.Name = 'Testt';
        objDivChannel.Distribution_Channel_Code__c = '10';  
        insert objDivChannel;
        System.debug('objDivChannel'+objDivChannel);
        Payment_Term__c pt= new Payment_Term__c();
        pt.Active__c=True;
        pt.Payment_Term_Code__c='0004';
        pt.Payterms_Desc__c='A Vista';
        pt.Sales_Org__c=SalesO.Id;
        pt.Days_to_calc_interest__c=0;
        pt.CombinationKey__c='51910004';
        pt.Maturity_Date_Mandatory__c='No';
        insert pt;
        
        //String userId=userinfo.getUserId();
        Id stExam = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        Account acc=Grz_TestDataFactory.createAccount(False, 'Test', stExam);
        acc.Sales_Org__c=SalesO.Id;
        acc.Email__c='testAcc@test.com';
        acc.GST_Validated__c=True;
        acc.Billing_Street_2__c='FINALE EMILIAs3d4d54f5etgss45tvthfvdryfthgjhuytretsdrftgyhugtfrdtsy';
        acc.BillingStreet='FINALE EMILIAscrecregtrgbtgtrytfrdtesdrftgyhuyutrdedtryftugyhuygtfgyhugytfgyhu';
        acc.BillingCity='Calfornia';
        acc.BillingPostalCode='41034';
        acc.BillingCountry='Italy';
        acc.Mobile__c='7389716233';
        acc.Email__c='testG@test.com';
        acc.Tax_Number_3__c='67855';
        acc.Non_Gst_Customer__c=True;
        acc.Status__c='Active';
        acc.Cust_Group__c='02';
        // acc.Currency_Onboarding__c='';
        acc.Incoterms_Part_1__c='ZFU';
        acc.Incoterms_Part_2__c='FREIGHT PAID BY UPL';
        acc.PAN_Number__c='AAACY2068D';
        acc.Account_Type__c='Sold To Party';
        acc.First_Name__c='Test';
        acc.Last_Name__c='Grazitti';
        acc.State_Union_Territory__c='Arunachal Pradesh';
        acc.PriceGroupCode__c=pgm.Id;
        acc.Price_List_Type__c=plm.Id;  
        acc.OwnerId=us.Id;
        acc.Territory_Distributor__c=terriD.Id;
        acc.Distribution_Channel__c=objDivChannel.Id;
        acc.Customer_Grp__c=ctg.Id;
        
        insert acc;
        
        acc.Territory_Distributor__c=terriD.Id;
        acc.Distribution_Channel__c=objDivChannel.Id;
        acc.Customer_Grp__c=ctg.Id;
        
        update acc;
        DistributorSalesAreaMapping__c DSAM= new DistributorSalesAreaMapping__c();
        DSAM.Distributor__c  =acc.id;
        DSAM.AccountOwner__c = acc.OwnerId;
        DSAM.SalesOrg__c = SalesO.Id;
        DSAM.Territory__c = terriD.Id;
        DSAM.DistributionChannel__c=objDivChannel.Id;
        //DSAM.Customer_Group_1__c=ctg.Id;
        DSAM.Depot__c=dp.Id;
        DSAM.Distributor__c=acc.Id;
        DSAM.Sales_District__c=salesDi.Id;
        DSAM.Payment_Term__c=pt.Id;
        DSAM.Territory__c=terriD.Id;
        DSAM.Stage__c='Final GBS Approval';
        DSAM.Substage__c='Approved';
        DSAM.Status__c='';    
        insert DSAM;
        DSAM.Territory__c = terriD.Id;
        DSAM.DistributionChannel__c=objDivChannel.Id;
        update DSAM;
        System.debug('DSAM'+JSON.serializePretty(DSAM));
        
        
    }
    
    
    @istest static void checkPreConditions1(){
        list<DistributorSalesAreaMapping__c>dsam=[select id,Distributor_SAP_Code__c from DistributorSalesAreaMapping__c];
        test.startTest();
        if(dsam!=null&&!dsam.isEmpty()){
            On_Boarding_Annexure_3__c onbA= new On_Boarding_Annexure_3__c();
            onbA.Age__c=33;
            onbA.Name='test';
            onbA.Relationship__c='SON';
            onbA.Specimen_Signature__c  ='test'; 
            onbA.Sales_Area__c=DSAM[0].id;
            insert onbA;
        }
        PAN_GST_API_Creds__c pan1 = new PAN_GST_API_Creds__c();
        pan1.Name='Crown_API_Creds';
        pan1.Password__c='Admin';
        pan1.Username__c='CaseAdminuser@1234';
        
        insert pan1;
        test.stopTest();
        
        
        Test.setMock(HttpCalloutMock.class, new Grz_SapIntegrationMockTestDataFactory(true));
        
        if(dsam!=null&&!dsam.isEmpty())Grz_SAPSyncSalesArea.checkPreConditions(DSAM[0].Id);
    }
    @istest static void checkPreConditions2(){
        list<DistributorSalesAreaMapping__c>dsam=[select id,Distributor_SAP_Code__c from DistributorSalesAreaMapping__c];
        test.startTest();
        if(dsam!=null&&!dsam.isEmpty()){
            On_Boarding_Annexure_3__c onbA= new On_Boarding_Annexure_3__c();
            onbA.Age__c=33;
            onbA.Name='test';
            onbA.Relationship__c='SON';
            onbA.Specimen_Signature__c  ='test'; 
            onbA.Sales_Area__c=DSAM[0].id;
            insert onbA;
        }
        
        test.stopTest();
        Test.setMock(HttpCalloutMock.class, new Grz_SapIntegrationMockTestDataFactory(false));
        if(dsam!=null&&!dsam.isEmpty())Grz_SAPSyncSalesArea.checkPreConditions(DSAM[0].Id);
    }
    
    @istest static void checkPreConditions3(){
        list<DistributorSalesAreaMapping__c>dsam=[select id,Distributor_SAP_Code__c,distributor__c from DistributorSalesAreaMapping__c];
        list<account>acc=[select id from Account where id=: dsam[0].Distributor__c];
        acc[0].sap_code__c='1234';
        
        test.startTest();
        if(dsam!=null&&!dsam.isEmpty()){
            update acc;
            On_Boarding_Annexure_3__c onbA= new On_Boarding_Annexure_3__c();
            onbA.Age__c=33;
            onbA.Name='test';
            onbA.Relationship__c='SON';
            onbA.Specimen_Signature__c  ='test'; 
            onbA.Sales_Area__c=DSAM[0].id;
            insert onbA;
        }
        
        test.stopTest();
        Test.setMock(HttpCalloutMock.class, new Grz_SapIntegrationMockTestDataFactory(true));
        if(dsam!=null&&!dsam.isEmpty())Grz_SAPSyncSalesArea.checkPreConditions(DSAM[0].Id);
    }
    
    @istest static void checkPreCondition(){
        list<DistributorSalesAreaMapping__c>dsam=[select id,Distributor__c from DistributorSalesAreaMapping__c];
        list<Account> acc=[Select id,name from Account where id = :dsam[0].Distributor__c];
        test.startTest();
        if(acc!=null&&!acc.isEmpty()){
            acc[0].BillingStreet='null';
            acc[0].Billing_Street_1__c='null';
            acc[0].Billing_Street_2__c='null';
            acc[0].Billing_Street_3__c='null';
            acc[0].Billing_Street_4__c='null';
                    update acc;

        }
        if(dsam!=null&&!dsam.isEmpty()){
            On_Boarding_Annexure_3__c onbA= new On_Boarding_Annexure_3__c();
            onbA.Age__c=33;
            onbA.Name='test';
            onbA.Relationship__c='SON';
            onbA.Specimen_Signature__c  ='test'; 
            onbA.Sales_Area__c=DSAM[0].id;
            insert onbA;
        }
        PAN_GST_API_Creds__c pan1 = new PAN_GST_API_Creds__c();
        pan1.Name='Crown_API_Creds';
        pan1.Password__c='Admin';
        pan1.Username__c='CaseAdminuser@1234';
        
        insert pan1;
        test.stopTest();
        Test.setMock(HttpCalloutMock.class, new Grz_SapIntegrationMockTestDataFactory(true));
        if(dsam!=null&&!dsam.isEmpty())Grz_SAPSyncSalesArea.checkPreConditions(DSAM[0].Id);
    }
    
    
    @istest static void checkPreCondition1(){
        list<DistributorSalesAreaMapping__c>dsam=[select id,Distributor__c from DistributorSalesAreaMapping__c];
        list<Account> acc=[Select id,name from Account where id = :dsam[0].Distributor__c];
        test.startTest();
        if(acc!=null&&!acc.isEmpty()){
            acc[0].BillingStreet='Test 1';
            acc[0].Billing_Street_1__c='Test 1';
            acc[0].Billing_Street_2__c='Test 1';
            acc[0].Billing_Street_3__c='Test 1';
            acc[0].Billing_Street_4__c='Test 1';
                    update acc;

        }
        if(dsam!=null&&!dsam.isEmpty()){
            On_Boarding_Annexure_3__c onbA= new On_Boarding_Annexure_3__c();
            onbA.Age__c=33;
            onbA.Name='test';
            onbA.Relationship__c='SON';
            onbA.Specimen_Signature__c  ='test'; 
            onbA.Sales_Area__c=DSAM[0].id;
            insert onbA;
        }
        PAN_GST_API_Creds__c pan1 = new PAN_GST_API_Creds__c();
        pan1.Name='Crown_API_Creds';
        pan1.Password__c='Admin';
        pan1.Username__c='CaseAdminuser@1234';
        
        insert pan1;
        test.stopTest();
        Test.setMock(HttpCalloutMock.class, new Grz_SapIntegrationMockTestDataFactory(true));
        if(dsam!=null&&!dsam.isEmpty())Grz_SAPSyncSalesArea.checkPreConditions(DSAM[0].Id);
    }

    
    @istest static void checkPreCondition2(){
    Test.startTest();
         PAN_GST_API_Creds__c pan1 = new PAN_GST_API_Creds__c();
        pan1.Name='Crown_API_Creds';
        pan1.Password__c='Admin';
        pan1.Username__c='CaseAdminuser@1234';
        
        insert pan1;
        list<DistributorSalesAreaMapping__c>dsam=[select id,Distributor__c from DistributorSalesAreaMapping__c];
        Test.stopTest();
        Test.setMock(HttpCalloutMock.class, new Grz_SapIntegrationMockTestDataFactory(true));
        Grz_SAPSyncSalesArea.checkPreConditions(DSAM[0].Id);
    }
}