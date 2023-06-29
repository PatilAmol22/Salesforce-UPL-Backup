@isTest
public class KAMDataEntryClass_Test {
    static testMethod void ApproveTest(){
        Test.startTest();
        Sales_Org__c sorg=TestDataFactory.CreateSalesOrgCode();
        system.debug(sorg.Sales_Org_Code__c);
        Sales_Org__c sorg1 = [Select id, name,Sales_Org_Code__c from Sales_Org__c where id =:sorg.Id limit 1];
        UPL_Settings__c monthSetting = UPL_Settings__c.getInstance();
        monthSetting.MKT_YR_USA__c=10;
        monthSetting.MKT_YR_CAN__c=30;
        monthSetting.MKT_YR_Visibility__c=30;
        monthSetting.Visibility_Date__c=30;
        insert monthSetting;
        
        Division__C div=new division__c();
        div.name='75';
        div.division_code__c='75';
        insert div;
        //Marketing_Year__c mkt= TestDataFactory.CreateMarkettingYear(sorg);
        CalculateMarkettingYearHelper.MarketingYearWrapper mktYearWrapper = CalculateMarkettingYearHelper.calculateMarketingYear(sorg1.Sales_Org_Code__c);
        
        Account acc = TestDataFactory.CreateAccount('spCode');
        acc.Name='ABC';
        acc.Mobile__c='9090909090';
        acc.Email__c='abc@mail.com';
        acc.Sales_Org__c=sorg.Id;
        acc.Division__c=div.Id;
        update acc;
        DistributorSalesAreaMapping__c  dsm=new DistributorSalesAreaMapping__c();
        dsm.Distributor__c=acc.id;
        dsm.Division__c=div.id;
        insert dsm;
        Draft_Plan_Header__c dh=TestDataFactory.CreatedfHeader(sorg,acc,mktYearWrapper);
        dh.Status__c='Approved';
        dh.Division__c=div.id;
        
        update dh;
        SKU__c sku=TestDataFactory.CreateSKU('Test123',sorg,'comb' );
        sku.Product_Category__c='Herbicides';
        sku.Name='Test1';
        sku.Division__c=div.id;
        sku.isparent__c=true;
        sku.sku_parent_code__c='123';
        update sku;
        
        Draft_Plan__c df=TestDataFactory.CreatedfPlan(sorg,acc,dh,sku,'test123g');
        Draft_Plan_Payout__c dpp =TestDataFactory.CreatedfPay(df);
        KAMDataEntryClass.getDivision(acc.Id);
        KAMDataEntryClass.checkSubmitApproval(acc.Id,'first',div.id);
        KAMDataEntryClass.checkSubmitApproval(acc.Id,'second',div.id);
        KAMDataEntryClass.getHiearchySettings();
        KAMDataEntryClass.getMarketingYear(acc.Id);
        KAMDataEntryClass.generateWrapper(acc.Id,'first',div.id,true);
        KAMDataEntryClass.generateWrapper(acc.Id,'second',div.id,false);
        
        KAMDataEntryClass.submitApproval(dh.id);
    }
    static testMethod void DraftTest(){
        Test.startTest();
        Sales_Org__c sorg=TestDataFactory.CreateSalesOrgCode();
        UPL_Settings__c monthSetting = UPL_Settings__c.getInstance();
        monthSetting.MKT_YR_USA__c=10;
        monthSetting.MKT_YR_CAN__c=30;
        monthSetting.MKT_YR_Visibility__c=30;
        monthSetting.Visibility_Date__c=30;
        insert monthSetting;
        Division__C div=new division__c();
        div.name='75';
        div.division_code__c='75';
        insert div;
        //Marketing_Year__c mkt= TestDataFactory.CreateMarkettingYear(sorg);
        CalculateMarkettingYearHelper.MarketingYearWrapper mktYearWrapper = CalculateMarkettingYearHelper.calculateMarketingYear(sorg.Sales_Org_Code__c);
        
        Account acc = TestDataFactory.CreateAccount('spCode');
        acc.Name='ABC';
        acc.Mobile__c='9090909090';
        acc.Email__c='abc@mail.com';
        acc.Sales_Org__c=sorg.Id;
        acc.Division__c=div.Id;
        acc.Screen_Flow_Value__c = 'Individual Product Offer';
        update acc;
        //CalculateMarkettingYearHelper.MarketingYearWrapper mktYearWrapper = CalculateMarkettingYearHelper.calculateMarketingYear(sorg.Sales_Org_Code__c);
        
        userrole  usrole = new userrole();
        usrole.Name ='Regional/Zonal Managers for Spain';
        Profile p = [SELECT Id,name FROM Profile WHERE Name = 'Standard User'];        
        User sobj1 = new User();
        sobj1.Alias = 'zonaa';                                                            
        sobj1.Email = 'skim@skinternational123.com';                             
        sobj1.ProfileId  = p.ID;
        sobj1.UserRoleId=usrole.id;
        sobj1.Username = 'zonal_aaexe1232@upl122333.com.devbox';                                    
        sobj1.IsActive = true; 
        sobj1.Country ='Argentina'; 
        sobj1.LastName='Terriotory Manager';
        sobj1.CommunityNickname = 'zonalExe1222 Di'; 
        sobj1.TimeZoneSidKey = 'Asia/Kolkata'; 
        sobj1.LocaleSidKey = 'en_IN';                                    
        sobj1.LanguageLocaleKey = 'en_US';                                             
        sobj1.ForecastEnabled = false;                                                     
        sobj1.EmailEncodingKey = 'ISO-8859-1';    
        sobj1.Show_Inventory__c = false;                                                     
        sobj1.Show_Credit_Limit__c = false; 
        insert sobj1;
        Draft_Plan_Header__c dh=TestDataFactory.CreatedfHeader(sorg,acc,mktYearWrapper);
        dh.Approving_Manager__c = sobj1.Id;
        dh.Division__c=div.id;
        update dh;
        SKU__c sku=TestDataFactory.CreateSKU('Test123',sorg,'comb' );
        sku.Product_Category__c='Herbicides';
        sku.Name='Test1';
        sku.Division__c=div.id;
        sku.isparent__c=true;
        sku.sku_parent_code__c='123';
        update sku;
        PriceBookMaster__c pbm = TestDataFactory.CreatePbm(sku,acc,sorg,mktYearWrapper);
        Secondary_Sales_Data__c sec=TestDataFactory.CreateSec(sku,acc,sorg,mktYearWrapper);
        Invoice__c inv=TestDataFactory.CreateInv(acc,sorg,mktYearWrapper);
        Invoice_Line_Item__c invLine=TestDataFactory.CreateInvLine(sku,inv);
        Draft_Plan__c df=TestDataFactory.CreatedfPlan(sorg,acc,dh,sku,'test567g');
        Draft_Plan_Payout__c dpp = TestDataFactory.CreatedfPay(df);
        Draft_Plan_Payout__c dpp1 = TestDataFactory.CreatedfPay(df);
        List<id> delPayList=new List<id>();
        delPayList.add(dpp1.Id);
        KAMDataEntryClass.getDivision(acc.Id);
        KAMDataEntryClass.KAMDataEntryWrapper kam= KAMDataEntryClass.generateWrapper(acc.Id,'first',div.id,false);
        Approval.ProcessSubmitRequest app = new Approval.ProcessSubmitRequest();
        app.setObjectId(dh.id);
        Approval.ProcessResult result = Approval.process(app);
        KAMDataEntryClass.checkSubmitApproval(acc.Id,'first',div.id);
        List<KAMDataEntryClass.KAMDataEntryLineWrapper> kamLine=kam.KAMTotalDataline;
        system.debug('***'+kamLine);
        //KAMDataEntryClass.createDraftPlan(kamLine,acc.id,dh.id,mkt.Id,sorg.Id,String MktYear,String DSapCode,List<Id> delPayList)
        KAMDataEntryClass.createDraftPlan(kamLine, acc.id, dh.id,sorg.Id,'first', acc.SAP_Code__c, delPayList,div.id,acc.Screen_Flow_Value__c);
        KAMDataEntryClass.createDraftPlan(kamLine, acc.id, dh.id,sorg.Id,'second', acc.SAP_Code__c, delPayList,div.id,acc.Screen_Flow_Value__c);
        KAMDataEntryClass.sendEmailMsg('test','test','test');
        KAMDataEntryClass.fetchExistingDraftPlan(acc.id,'first');
        KAMDataEntryClass.createCloneDraftPlan(acc.id, dh.id);
    }
    static testMethod void NODraftheaderTest(){
        Test.startTest();
        Sales_Org__c sorg=TestDataFactory.CreateSalesOrgCode();
        UPL_Settings__c monthSetting = UPL_Settings__c.getInstance();
        monthSetting.MKT_YR_USA__c=10;
        monthSetting.MKT_YR_CAN__c=30;
        monthSetting.MKT_YR_Visibility__c=30;
        monthSetting.Visibility_Date__c=30;
        insert monthSetting;
        Division__C div=new division__c();
        div.name='75';
        div.division_code__c='75';
        insert div;
        //Marketing_Year__c mkt= TestDataFactory.CreateMarkettingYear(sorg);
        CalculateMarkettingYearHelper.MarketingYearWrapper mktYearWrapper = CalculateMarkettingYearHelper.calculateMarketingYear(sorg.Sales_Org_Code__c);
        
        Account acc = TestDataFactory.CreateAccount('spCode');
        acc.Name='ABC';
        acc.Mobile__c='9090909090';
        acc.Email__c='abc@mail.com';
        acc.Sales_Org__c=sorg.Id;
        
        update acc;

        SKU__c sku=TestDataFactory.CreateSKU('Test123',sorg,'comb' );
        sku.Product_Category__c='Herbicides';
        sku.Name='Test1';
        sku.Division__c=div.id;
        sku.isparent__c=true;
        sku.sku_parent_code__c='123';
        update sku;
        PriceBookMaster__c pbm = TestDataFactory.CreatePbm(sku,acc,sorg,mktYearWrapper);
        pbm.division__c=div.id;
        update pbm;
        Secondary_Sales_Data__c sec=TestDataFactory.CreateSec(sku,acc,sorg,mktYearWrapper);
        sec.division__c=div.id;
        update sec;
        Invoice__c inv=TestDataFactory.CreateInv(acc,sorg,mktYearWrapper);
        inv.division__c=div.id;
        update inv;
        Invoice_Line_Item__c invLine=TestDataFactory.CreateInvLine(sku,inv);
        //Draft_Plan__c df=TestDataFactory.CreatedfPlan(sorg,acc,dh,sku,'test567g');
        //Draft_Plan_Payout__c dpp = TestDataFactory.CreatedfPay(df);
        //Draft_Plan_Payout__c dpp1 = TestDataFactory.CreatedfPay(df);
        List<id> delPayList=new List<id>();
        //delPayList.add(dpp1.Id);
        KAMDataEntryClass.getDivision(acc.Id);
        KAMDataEntryClass.KAMDataEntryWrapper kam= KAMDataEntryClass.generateWrapper(acc.Id,'first',div.id,false);
        
        
        KAMDataEntryClass.checkSubmitApproval(acc.Id,'first',div.id);
        List<KAMDataEntryClass.KAMDataEntryLineWrapper> kamLine=kam.KAMTotalDataline;
        system.debug('***'+kamLine);
        //KAMDataEntryClass.createDraftPlan(kamLine,acc.id,dh.id,mkt.Id,sorg.Id,String MktYear,String DSapCode,List<Id> delPayList)
        KAMDataEntryClass.createDraftPlan(kamLine, acc.id, null,sorg.Id,'first', acc.SAP_Code__c, delPayList,div.id,acc.Screen_Flow_Value__c);
        KAMDataEntryClass.createDraftPlan(kamLine, acc.id, null,sorg.Id,'second', acc.SAP_Code__c, delPayList,div.id,acc.Screen_Flow_Value__c);
        KAMDataEntryClass.ApprovalList al = new KAMDataEntryClass.ApprovalList();
        al.actorName = 'test';
        al.comments = 'test';
        al.originalActorName = 'test';
        al.stepStatus = 'test';
    }
}