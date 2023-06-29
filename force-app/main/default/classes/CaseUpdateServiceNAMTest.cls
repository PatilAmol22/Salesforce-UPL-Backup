@isTest
public class CaseUpdateServiceNAMTest {
    static testMethod void methodinvalid(){
        // setup controller object
        UPL_Settings__c monthSetting = UPL_Settings__c.getInstance();
        monthSetting.MKT_YR_USA__c=10;
        monthSetting.MKT_YR_CAN__c=30;
        monthSetting.MKT_YR_Visibility__c=30;
        monthSetting.Visibility_Date__c=30;
        monthSetting.Target_Plan_Visibility__c=5;
        monthSetting.Draft_Record_Per_Page__c=10;
		monthSetting.Division__c='None,None,10,60,75,76,77,78,79';        
        insert monthSetting;
        
        Sales_Org__c sorg =new Sales_Org__c();
        sorg.Name='US';
        sorg.Description__c='US';
        sorg.Sales_Org_Code__c='3100';
        insert sorg;
        Account acc = TestDataFactory.CreateAccount('0001033509');
        acc.Combination_Key__c='00010335080001033508';
        acc.Sales_Org__c=sorg.id;
        update acc;
        Id RecordTypeIdCase = Schema.SObjectType.Case.getRecordTypeInfosByName().get('CSR').getRecordTypeId();
        Case ctest = TestDataFactory.CreateCase(acc);
        ctest.RecordTypeId=RecordTypeIdCase;
            
        update ctest;
        Division__C div=new division__c();
        div.name='75';
        div.division_code__c='75';
        insert div;
        CalculateMarkettingYearHelper.MarketingYearWrapper mktYearWrapperNAM = CalculateMarkettingYearHelper.calculateYearWithoutVisibility('3100');
SKU__c sku=TestDataFactory.CreateSKU('Test123',sorg,'comb' );
    	sku.Product_Category__c='Herbicides';
    	sku.Name='Test1';
        sku.Division__c=div.id;
        sku.Market_Manager__c=Userinfo.getUserId();
                sku.IsParent__c=true;

    	update sku;
        PriceBookMaster__c pbm=new PriceBookMaster__c();
        pbm.Sales_Org__c=sorg.id;
        pbm.StartDate__c=mktYearWrapperNAM.firstMarketingYearStartDate;
        pbm.EndDate__c=mktYearWrapperNAM.firstMarketingYearEndDate;
        pbm.CompositeKey__c='test';
        pbm.SKUCode__c=sku.id;
        pbm.Division__c=div.id;
        pbm.DistributorCustomerCode__c=acc.id;
        pbm.Net_Price_Distribution__c=100;
        insert pbm;
        
        case_product__c cp=new case_product__c();
        cp.Case__c=ctest.id;
        cp.Brand_Pack_Size__c=sku.id;
        cp.Effective_Start_Date__c=system.today();
        cp.Effective_End_Date__c=system.today();
        cp.Division__c=div.id;
        insert cp;
        
        system.debug('caseno::'+ctest.casenumber);
        CaseUpdateServiceNAM objconfirm = new CaseUpdateServiceNAM();
        System.debug('Debug Email Service');
        
        // Create a new email, envelope object and Attachment
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
        objconfirm.handleInboundEmail(email, envelope);
        
        email.subject = 'NAM sales data';
        email.plainTextBody = 'This is a test mail.';
        email.fromAddress='kpophale@in.ibm.com';
        envelope.fromAddress = 'upl@uniphos.com';
        Case cc=[select id,CaseNumber from case where id=:ctest.Id];
        Messaging.InboundEmail.BinaryAttachment binaryAttachment = new Messaging.InboundEmail.BinaryAttachment();
        binaryAttachment.Filename = 'caseupdate data.csv';
        String csvAttachment = 'Case Number,SAP doc no\r\n'+ctest.CaseNumber+',6250321\r\n';
        system.debug('csvAttachment::'+csvAttachment);
        binaryAttachment.body = Blob.valueOf(csvAttachment);
        //binaryattachment.mimeTypeSubType = 'text/plain';
        email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] { binaryattachment };
            objconfirm.handleInboundEmail(email, envelope);
        
        Messaging.InboundEmailResult result = objconfirm.handleInboundEmail(email, envelope);


    }
    static testMethod void methodUS(){
        // setup controller object
        UPL_Settings__c monthSetting = UPL_Settings__c.getInstance();
        monthSetting.MKT_YR_USA__c=10;
        monthSetting.MKT_YR_CAN__c=30;
        monthSetting.MKT_YR_Visibility__c=30;
        monthSetting.Visibility_Date__c=30;
        monthSetting.Target_Plan_Visibility__c=5;
        monthSetting.Draft_Record_Per_Page__c=10;
		monthSetting.Division__c='None,None,10,60,75,76,77,78,79';        
        insert monthSetting;
        
        Sales_Org__c sorg =new Sales_Org__c();
        sorg.Name='US';
        sorg.Description__c='US';
        sorg.Sales_Org_Code__c='3100';
        insert sorg;
        Account acc = TestDataFactory.CreateAccount('0001033509');
        acc.Combination_Key__c='00010335080001033508';
        acc.Sales_Org__c=sorg.id;
        update acc;
        Id RecordTypeIdCase = Schema.SObjectType.Case.getRecordTypeInfosByName().get('CSR').getRecordTypeId();
        Case ctest = TestDataFactory.CreateCase(acc);
        ctest.RecordTypeId=RecordTypeIdCase;
            
        update ctest;
        Division__C div=new division__c();
        div.name='75';
        div.division_code__c='75';
        insert div;
        CalculateMarkettingYearHelper.MarketingYearWrapper mktYearWrapperNAM = CalculateMarkettingYearHelper.calculateYearWithoutVisibility('3100');
SKU__c sku=TestDataFactory.CreateSKU('Test123',sorg,'comb' );
    	sku.Product_Category__c='Herbicides';
    	sku.Name='Test1';
        sku.Division__c=div.id;
        sku.Market_Manager__c=Userinfo.getUserId();
                sku.IsParent__c=true;

    	update sku;
        PriceBookMaster__c pbm=new PriceBookMaster__c();
        pbm.Sales_Org__c=sorg.id;
        pbm.StartDate__c=mktYearWrapperNAM.firstMarketingYearStartDate;
        pbm.EndDate__c=mktYearWrapperNAM.firstMarketingYearEndDate;
        pbm.CompositeKey__c='test';
        pbm.SKUCode__c=sku.id;
        pbm.Division__c=div.id;
        pbm.DistributorCustomerCode__c=acc.id;
        pbm.Net_Price_Distribution__c=100;
        insert pbm;
        
        case_product__c cp=new case_product__c();
        cp.Case__c=ctest.id;
        cp.Brand_Pack_Size__c=sku.id;
        cp.Effective_Start_Date__c=system.today();
        cp.Effective_End_Date__c=system.today();
        cp.Division__c=div.id;
        insert cp;
        
        system.debug('caseno::'+ctest.casenumber);
        CaseUpdateServiceNAM objconfirm = new CaseUpdateServiceNAM();
        System.debug('Debug Email Service');
        
        // Create a new email, envelope object and Attachment
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
        objconfirm.handleInboundEmail(email, envelope);
        
        email.subject = 'NAM sales data';
        email.plainTextBody = 'This is a test mail.';
        email.fromAddress='kpophale@in.ibm.com';
        envelope.fromAddress = 'upl@uniphos.com';
        Case cc=[select id,CaseNumber from case where id=:ctest.Id];
        Messaging.InboundEmail.BinaryAttachment binaryAttachment = new Messaging.InboundEmail.BinaryAttachment();
        binaryAttachment.Filename = 'caseupdate data.csv';
        String csvAttachment = 'Case Number,SAP doc no\r\n'+cc.CaseNumber+',6250321\r\n';
        system.debug('csvAttachment::'+csvAttachment);
        binaryAttachment.body = Blob.valueOf(csvAttachment);
        //binaryattachment.mimeTypeSubType = 'text/plain';
        email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] { binaryattachment };
            objconfirm.handleInboundEmail(email, envelope);
        
        Messaging.InboundEmailResult result = objconfirm.handleInboundEmail(email, envelope);


    }
    static testMethod void methodUSs2(){
        // setup controller object
        UPL_Settings__c monthSetting = UPL_Settings__c.getInstance();
        monthSetting.MKT_YR_USA__c=10;
        monthSetting.MKT_YR_CAN__c=30;
        monthSetting.MKT_YR_Visibility__c=30;
        monthSetting.Visibility_Date__c=30;
        monthSetting.Target_Plan_Visibility__c=5;
        monthSetting.Draft_Record_Per_Page__c=10;
		monthSetting.Division__c='None,None,10,60,75,76,77,78,79';        
        insert monthSetting;
        
        Sales_Org__c sorg =new Sales_Org__c();
        sorg.Name='US';
        sorg.Description__c='US';
        sorg.Sales_Org_Code__c='3100';
        insert sorg;
        Account acc = TestDataFactory.CreateAccount('0001033509');
        acc.Combination_Key__c='00010335080001033508';
        acc.Sales_Org__c=sorg.id;
        update acc;
        Id RecordTypeIdCase = Schema.SObjectType.Case.getRecordTypeInfosByName().get('CSR').getRecordTypeId();
        Case ctest = TestDataFactory.CreateCase(acc);
        ctest.RecordTypeId=RecordTypeIdCase;
            
        update ctest;
        Division__C div=new division__c();
        div.name='75';
        div.division_code__c='75';
        insert div;
        CalculateMarkettingYearHelper.MarketingYearWrapper mktYearWrapperNAM = CalculateMarkettingYearHelper.calculateYearWithoutVisibility('3100');
SKU__c sku=TestDataFactory.CreateSKU('Test123',sorg,'comb' );
    	sku.Product_Category__c='Herbicides';
    	sku.Name='Test1';
        sku.Division__c=div.id;
        sku.Market_Manager__c=Userinfo.getUserId();
                sku.IsParent__c=true;

    	update sku;
        PriceBookMaster__c pbm=new PriceBookMaster__c();
        pbm.Sales_Org__c=sorg.id;
        pbm.StartDate__c=system.today().addmonths(-1);
        pbm.EndDate__c=system.today().addyears(1);
        pbm.CompositeKey__c='test';
        pbm.SKUCode__c=sku.id;
        pbm.Division__c=div.id;
        pbm.DistributorCustomerCode__c=acc.id;
        pbm.Net_Price_Distribution__c=100;
        insert pbm;
        
        case_product__c cp=new case_product__c();
        cp.Case__c=ctest.id;
        cp.Brand_Pack_Size__c=sku.id;
        cp.Effective_Start_Date__c=system.today().addmonths(-1);
        cp.Effective_End_Date__c=system.today();
        cp.Division__c=div.id;
        insert cp;
        
        system.debug('caseno::'+ctest.casenumber);
        CaseUpdateServiceNAM objconfirm = new CaseUpdateServiceNAM();
        System.debug('Debug Email Service');
        
        // Create a new email, envelope object and Attachment
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
        objconfirm.handleInboundEmail(email, envelope);
        
        email.subject = 'NAM sales data';
        email.plainTextBody = 'This is a test mail.';
        email.fromAddress='kpophale@in.ibm.com';
        envelope.fromAddress = 'upl@uniphos.com';
        Case cc=[select id,CaseNumber from case where id=:ctest.Id];
        Messaging.InboundEmail.BinaryAttachment binaryAttachment = new Messaging.InboundEmail.BinaryAttachment();
        binaryAttachment.Filename = 'caseupdate data.csv';
        String csvAttachment = 'Case Number,SAP doc no\r\n'+cc.CaseNumber+',6250321\r\n';
        system.debug('csvAttachment::'+csvAttachment);
        binaryAttachment.body = Blob.valueOf(csvAttachment);
        //binaryattachment.mimeTypeSubType = 'text/plain';
        email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] { binaryattachment };
            objconfirm.handleInboundEmail(email, envelope);
        
        Messaging.InboundEmailResult result = objconfirm.handleInboundEmail(email, envelope);


    }
    static testMethod void methodUSs3(){
        // setup controller object
        UPL_Settings__c monthSetting = UPL_Settings__c.getInstance();
        monthSetting.MKT_YR_USA__c=10;
        monthSetting.MKT_YR_CAN__c=30;
        monthSetting.MKT_YR_Visibility__c=30;
        monthSetting.Visibility_Date__c=30;
        monthSetting.Target_Plan_Visibility__c=5;
        monthSetting.Draft_Record_Per_Page__c=10;
		monthSetting.Division__c='None,None,10,60,75,76,77,78,79';        
        insert monthSetting;
        
        Sales_Org__c sorg =new Sales_Org__c();
        sorg.Name='US';
        sorg.Description__c='US';
        sorg.Sales_Org_Code__c='3100';
        insert sorg;
        Account acc = TestDataFactory.CreateAccount('0001033509');
        acc.Combination_Key__c='00010335080001033508';
        acc.Sales_Org__c=sorg.id;
        update acc;
        Id RecordTypeIdCase = Schema.SObjectType.Case.getRecordTypeInfosByName().get('CSR').getRecordTypeId();
        Case ctest = TestDataFactory.CreateCase(acc);
        ctest.RecordTypeId=RecordTypeIdCase;
            
        update ctest;
        Division__C div=new division__c();
        div.name='75';
        div.division_code__c='75';
        insert div;
        CalculateMarkettingYearHelper.MarketingYearWrapper mktYearWrapperNAM = CalculateMarkettingYearHelper.calculateYearWithoutVisibility('3100');
SKU__c sku=TestDataFactory.CreateSKU('Test123',sorg,'comb' );
    	sku.Product_Category__c='Herbicides';
    	sku.Name='Test1';
        sku.Division__c=div.id;
        sku.Market_Manager__c=Userinfo.getUserId();
                sku.IsParent__c=true;

    	update sku;
        
        
        case_product__c cp=new case_product__c();
        cp.Case__c=ctest.id;
        cp.Brand_Pack_Size__c=sku.id;
        cp.Effective_Start_Date__c=system.today().addmonths(-2);
        cp.Effective_End_Date__c=system.today().addyears(1);
        cp.Division__c=div.id;
        insert cp;
        
        system.debug('caseno::'+ctest.casenumber);
        CaseUpdateServiceNAM objconfirm = new CaseUpdateServiceNAM();
        System.debug('Debug Email Service');
        
        // Create a new email, envelope object and Attachment
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
        objconfirm.handleInboundEmail(email, envelope);
        
        email.subject = 'NAM sales data';
        email.plainTextBody = 'This is a test mail.';
        email.fromAddress='kpophale@in.ibm.com';
        envelope.fromAddress = 'upl@uniphos.com';
        Case cc=[select id,CaseNumber from case where id=:ctest.Id];
        Messaging.InboundEmail.BinaryAttachment binaryAttachment = new Messaging.InboundEmail.BinaryAttachment();
        binaryAttachment.Filename = 'caseupdate data.csv';
        String csvAttachment = 'Case Number,SAP doc no\r\n'+cc.CaseNumber+',6250321\r\n';
        system.debug('csvAttachment::'+csvAttachment);
        binaryAttachment.body = Blob.valueOf(csvAttachment);
        //binaryattachment.mimeTypeSubType = 'text/plain';
        email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] { binaryattachment };
            objconfirm.handleInboundEmail(email, envelope);
        
        Messaging.InboundEmailResult result = objconfirm.handleInboundEmail(email, envelope);


    }
    static testMethod void methodUSs4(){
        // setup controller object
        UPL_Settings__c monthSetting = UPL_Settings__c.getInstance();
        monthSetting.MKT_YR_USA__c=10;
        monthSetting.MKT_YR_CAN__c=30;
        monthSetting.MKT_YR_Visibility__c=30;
        monthSetting.Visibility_Date__c=30;
        monthSetting.Target_Plan_Visibility__c=5;
        monthSetting.Draft_Record_Per_Page__c=10;
		monthSetting.Division__c='None,None,10,60,75,76,77,78,79';        
        insert monthSetting;
        
        Sales_Org__c sorg =new Sales_Org__c();
        sorg.Name='US';
        sorg.Description__c='US';
        sorg.Sales_Org_Code__c='3100';
        insert sorg;
        Account acc = TestDataFactory.CreateAccount('0001033509');
        acc.Combination_Key__c='00010335080001033508';
        acc.Sales_Org__c=sorg.id;
        update acc;
        Id RecordTypeIdCase = Schema.SObjectType.Case.getRecordTypeInfosByName().get('CSR').getRecordTypeId();
        Case ctest = TestDataFactory.CreateCase(acc);
        ctest.RecordTypeId=RecordTypeIdCase;
            
        update ctest;
        Division__C div=new division__c();
        div.name='75';
        div.division_code__c='75';
        insert div;
        CalculateMarkettingYearHelper.MarketingYearWrapper mktYearWrapperNAM = CalculateMarkettingYearHelper.calculateYearWithoutVisibility('3100');
SKU__c sku=TestDataFactory.CreateSKU('Test123',sorg,'comb' );
    	sku.Product_Category__c='Herbicides';
    	sku.Name='Test1';
        sku.Division__c=div.id;
        sku.Market_Manager__c=Userinfo.getUserId();
        sku.isparent__c=true;
    	update sku;
        
        
        case_product__c cp=new case_product__c();
        cp.Case__c=ctest.id;
        cp.Brand_Pack_Size__c=sku.id;
        cp.Effective_Start_Date__c=system.today().addmonths(-2);
        cp.Effective_End_Date__c=system.today().addyears(1);
        cp.Division__c=div.id;
        insert cp;
        
        system.debug('caseno::'+ctest.casenumber);
        CaseUpdateServiceNAM objconfirm = new CaseUpdateServiceNAM();
        System.debug('Debug Email Service');
        
        // Create a new email, envelope object and Attachment
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
        objconfirm.handleInboundEmail(email, envelope);
        
        email.subject = 'NAM sales data';
        email.plainTextBody = 'This is a test mail.';
        email.fromAddress='kpophale@in.ibm.com';
        envelope.fromAddress = 'upl@uniphos.com';
        Case cc=[select id,CaseNumber from case where id=:ctest.Id];
        Messaging.InboundEmail.BinaryAttachment binaryAttachment = new Messaging.InboundEmail.BinaryAttachment();
        binaryAttachment.Filename = 'caseupdate data.csv';
        String csvAttachment = 'Case Number,SAP doc no\r\n'+cc.CaseNumber+',6250321\r\n';
        system.debug('csvAttachment::'+csvAttachment);
        binaryAttachment.body = Blob.valueOf(csvAttachment);
        //binaryattachment.mimeTypeSubType = 'text/plain';
        email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] { binaryattachment };
            objconfirm.handleInboundEmail(email, envelope);
        
        Messaging.InboundEmailResult result = objconfirm.handleInboundEmail(email, envelope);


    }
    static testMethod void methodUSs5(){
        // setup controller object
        UPL_Settings__c monthSetting = UPL_Settings__c.getInstance();
        monthSetting.MKT_YR_USA__c=10;
        monthSetting.MKT_YR_CAN__c=30;
        monthSetting.MKT_YR_Visibility__c=30;
        monthSetting.Visibility_Date__c=30;
        monthSetting.Target_Plan_Visibility__c=5;
        monthSetting.Draft_Record_Per_Page__c=10;
		monthSetting.Division__c='None,None,10,60,75,76,77,78,79';        
        insert monthSetting;
        
        Sales_Org__c sorg =new Sales_Org__c();
        sorg.Name='US';
        sorg.Description__c='US';
        sorg.Sales_Org_Code__c='3100';
        insert sorg;
        Account acc = TestDataFactory.CreateAccount('0001033509');
        acc.Combination_Key__c='00010335080001033508';
        acc.Sales_Org__c=sorg.id;
        update acc;
        Id RecordTypeIdCase = Schema.SObjectType.Case.getRecordTypeInfosByName().get('CSR').getRecordTypeId();
        Case ctest = TestDataFactory.CreateCase(acc);
        ctest.RecordTypeId=RecordTypeIdCase;
            
        update ctest;
        Division__C div=new division__c();
        div.name='75';
        div.division_code__c='75';
        insert div;
        CalculateMarkettingYearHelper.MarketingYearWrapper mktYearWrapperNAM = CalculateMarkettingYearHelper.calculateYearWithoutVisibility('3100');
SKU__c sku=TestDataFactory.CreateSKU('Test123',sorg,'comb' );
    	sku.Product_Category__c='Herbicides';
    	sku.Name='Test1';
        sku.Division__c=div.id;
        sku.Market_Manager__c=Userinfo.getUserId();
                sku.IsParent__c=true;

    	update sku;
        PriceBookMaster__c pbm=new PriceBookMaster__c();
        pbm.Sales_Org__c=sorg.id;
        pbm.StartDate__c=system.today().addmonths(-1);
        pbm.EndDate__c=system.today().addmonths(1);
        pbm.CompositeKey__c='test';
        pbm.SKUCode__c=sku.id;
        pbm.Division__c=div.id;
        pbm.DistributorCustomerCode__c=acc.id;
        pbm.Net_Price_Distribution__c=100;
        insert pbm;
        
        case_product__c cp=new case_product__c();
        cp.Case__c=ctest.id;
        cp.Brand_Pack_Size__c=sku.id;
        cp.Effective_Start_Date__c=system.today().addmonths(2);
        cp.Effective_End_Date__c=system.today().addmonths(3);
        cp.Division__c=div.id;
        insert cp;
        
        system.debug('caseno::'+ctest.casenumber);
        CaseUpdateServiceNAM objconfirm = new CaseUpdateServiceNAM();
        System.debug('Debug Email Service');
        
        // Create a new email, envelope object and Attachment
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
        objconfirm.handleInboundEmail(email, envelope);
        
        email.subject = 'NAM sales data';
        email.plainTextBody = 'This is a test mail.';
        email.fromAddress='kpophale@in.ibm.com';
        envelope.fromAddress = 'upl@uniphos.com';
        Case cc=[select id,CaseNumber from case where id=:ctest.Id];
        Messaging.InboundEmail.BinaryAttachment binaryAttachment = new Messaging.InboundEmail.BinaryAttachment();
        binaryAttachment.Filename = 'caseupdate data.csv';
        String csvAttachment = 'Case Number,SAP doc no\r\n'+cc.CaseNumber+',6250321\r\n';
        system.debug('csvAttachment::'+csvAttachment);
        binaryAttachment.body = Blob.valueOf(csvAttachment);
        //binaryattachment.mimeTypeSubType = 'text/plain';
        email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] { binaryattachment };
            objconfirm.handleInboundEmail(email, envelope);
        
        Messaging.InboundEmailResult result = objconfirm.handleInboundEmail(email, envelope);


    }
    static testMethod void methodCad(){
        // setup controller object
        UPL_Settings__c monthSetting = UPL_Settings__c.getInstance();
        monthSetting.MKT_YR_USA__c=10;
        monthSetting.MKT_YR_CAN__c=10;
        monthSetting.MKT_YR_Visibility__c=30;
        monthSetting.Visibility_Date__c=30;
        monthSetting.Target_Plan_Visibility__c=5;
        monthSetting.Draft_Record_Per_Page__c=10;
		monthSetting.Division__c='None,None,10,60,75,76,77,78,79';        
        insert monthSetting;
        
        Sales_Org__c sorg =new Sales_Org__c();
        sorg.Name='Canada';
        sorg.Description__c='Canada';
        sorg.Sales_Org_Code__c='3710';
        insert sorg;
        Account acc = TestDataFactory.CreateAccount('0001033509');
        acc.Combination_Key__c='00010335080001033508';
        acc.Sales_Org__c=sorg.id;
        update acc;
        Id RecordTypeIdCase = Schema.SObjectType.Case.getRecordTypeInfosByName().get('CSR').getRecordTypeId();
        Case ctest = TestDataFactory.CreateCase(acc);
        ctest.RecordTypeId=RecordTypeIdCase;
        
        update ctest;
        Division__C div=new division__c();
        div.name='75';
        div.division_code__c='75';
        insert div;
        CalculateMarkettingYearHelper.MarketingYearWrapper mktYearWrapperCAD = CalculateMarkettingYearHelper.calculateYearWithoutVisibility('3710');
SKU__c sku=TestDataFactory.CreateSKU('Test123',sorg,'comb' );
    	sku.Product_Category__c='Herbicides';
    	sku.Name='Test1';
        sku.Division__c=div.id;
        sku.Market_Manager__c=Userinfo.getUserId();
        sku.IsParent__c=true;
    	update sku;
        system.debug('fdate'+mktYearWrapperCAD.firstMarketingYearStartDate);
        system.debug('edate'+mktYearWrapperCAD.firstMarketingYearEndDate);
        PriceBookMaster__c pbm=new PriceBookMaster__c();
        pbm.Sales_Org__c=sorg.id;
        pbm.StartDate__c=mktYearWrapperCAD.firstMarketingYearStartDate;
        pbm.EndDate__c=mktYearWrapperCAD.firstMarketingYearEndDate;
        pbm.CompositeKey__c='test';
        pbm.SKUCode__c=sku.id;
        pbm.Division__c=div.id;
        pbm.DistributorCustomerCode__c=acc.id;
        insert pbm;
        
        case_product__c cp=new case_product__c();
        cp.Case__c=ctest.id;
        cp.Brand_Pack_Size__c=sku.id;
        cp.Effective_Start_Date__c=system.today();
        cp.Effective_End_Date__c=system.today();
        cp.Division__c=div.id;
        insert cp;
        
        system.debug('caseno::'+ctest.casenumber);
        CaseUpdateServiceNAM objconfirm = new CaseUpdateServiceNAM();
        System.debug('Debug Email Service');
        
        // Create a new email, envelope object and Attachment
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
        objconfirm.handleInboundEmail(email, envelope);
        
        email.subject = 'NAM sales data';
        email.plainTextBody = 'This is a test mail.';
        email.fromAddress='kpophale@in.ibm.com';
        envelope.fromAddress = 'upl@uniphos.com';
        Case cc=[select id,CaseNumber from case where id=:ctest.Id];
        Messaging.InboundEmail.BinaryAttachment binaryAttachment = new Messaging.InboundEmail.BinaryAttachment();
        binaryAttachment.Filename = 'caseupdate data.csv';
        String csvAttachment = 'Case Number,SAP doc no\r\n'+cc.CaseNumber+',6250321\r\n';
        system.debug('csvAttachment::'+csvAttachment);
        binaryAttachment.body = Blob.valueOf(csvAttachment);
        //binaryattachment.mimeTypeSubType = 'text/plain';
        email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] { binaryattachment };
            objconfirm.handleInboundEmail(email, envelope);
        
        Messaging.InboundEmailResult result = objconfirm.handleInboundEmail(email, envelope);
    }
    static testMethod void methodCads2(){
        // setup controller object
        UPL_Settings__c monthSetting = UPL_Settings__c.getInstance();
        monthSetting.MKT_YR_USA__c=10;
        monthSetting.MKT_YR_CAN__c=30;
        monthSetting.MKT_YR_Visibility__c=30;
        monthSetting.Visibility_Date__c=30;
        monthSetting.Target_Plan_Visibility__c=5;
        monthSetting.Draft_Record_Per_Page__c=10;
		monthSetting.Division__c='None,None,10,60,75,76,77,78,79';        
        insert monthSetting;
        
        Sales_Org__c sorg =new Sales_Org__c();
        sorg.Name='Canada';
        sorg.Description__c='Canada';
        sorg.Sales_Org_Code__c='3710';
        insert sorg;
        Account acc = TestDataFactory.CreateAccount('0001033509');
        acc.Combination_Key__c='00010335080001033508';
        acc.Sales_Org__c=sorg.id;
        update acc;
        Id RecordTypeIdCase = Schema.SObjectType.Case.getRecordTypeInfosByName().get('CSR').getRecordTypeId();
        Case ctest = TestDataFactory.CreateCase(acc);
        ctest.RecordTypeId=RecordTypeIdCase;
        
        update ctest;
        Division__C div=new division__c();
        div.name='75';
        div.division_code__c='75';
        insert div;
        CalculateMarkettingYearHelper.MarketingYearWrapper mktYearWrapperCAD = CalculateMarkettingYearHelper.calculateYearWithoutVisibility('3710');
SKU__c sku=TestDataFactory.CreateSKU('Test123',sorg,'comb' );
    	sku.Product_Category__c='Herbicides';
    	sku.Name='Test1';
        sku.Division__c=div.id;
        sku.Market_Manager__c=Userinfo.getUserId();
                sku.IsParent__c=true;

    	update sku;
        PriceBookMaster__c pbm=new PriceBookMaster__c();
        pbm.Sales_Org__c=sorg.id;
        pbm.StartDate__c=system.today().addmonths(-1);
        pbm.EndDate__c=system.today().addyears(1);
        pbm.CompositeKey__c='test';
        pbm.SKUCode__c=sku.id;
        pbm.Division__c=div.id;
        pbm.DistributorCustomerCode__c=acc.id;
        insert pbm;
        
        case_product__c cp=new case_product__c();
        cp.Case__c=ctest.id;
        cp.Brand_Pack_Size__c=sku.id;
        cp.Effective_Start_Date__c=system.today().addmonths(3);
        cp.Effective_End_Date__c=system.today().addmonths(5);
        cp.Division__c=div.id;
        insert cp;
        
        system.debug('caseno::'+ctest.casenumber);
        CaseUpdateServiceNAM objconfirm = new CaseUpdateServiceNAM();
        System.debug('Debug Email Service');
        
        // Create a new email, envelope object and Attachment
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
        objconfirm.handleInboundEmail(email, envelope);
        
        email.subject = 'NAM sales data';
        email.plainTextBody = 'This is a test mail.';
        email.fromAddress='kpophale@in.ibm.com';
        envelope.fromAddress = 'upl@uniphos.com';
        Case cc=[select id,CaseNumber from case where id=:ctest.Id];
        Messaging.InboundEmail.BinaryAttachment binaryAttachment = new Messaging.InboundEmail.BinaryAttachment();
        binaryAttachment.Filename = 'caseupdate data.csv';
        String csvAttachment = 'Case Number,SAP doc no\r\n'+cc.CaseNumber+',6250321\r\n';
        system.debug('csvAttachment::'+csvAttachment);
        binaryAttachment.body = Blob.valueOf(csvAttachment);
        //binaryattachment.mimeTypeSubType = 'text/plain';
        email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] { binaryattachment };
            objconfirm.handleInboundEmail(email, envelope);
        
        Messaging.InboundEmailResult result = objconfirm.handleInboundEmail(email, envelope);
    }
    static testMethod void methodCads3(){
        // setup controller object
        UPL_Settings__c monthSetting = UPL_Settings__c.getInstance();
        monthSetting.MKT_YR_USA__c=10;
        monthSetting.MKT_YR_CAN__c=30;
        monthSetting.MKT_YR_Visibility__c=30;
        monthSetting.Visibility_Date__c=30;
        monthSetting.Target_Plan_Visibility__c=5;
        monthSetting.Draft_Record_Per_Page__c=10;
		monthSetting.Division__c='None,None,10,60,75,76,77,78,79';        
        insert monthSetting;
        
        Sales_Org__c sorg =new Sales_Org__c();
        sorg.Name='Canada';
        sorg.Description__c='Canada';
        sorg.Sales_Org_Code__c='3710';
        insert sorg;
        Account acc = TestDataFactory.CreateAccount('0001033509');
        acc.Combination_Key__c='00010335080001033508';
        acc.Sales_Org__c=sorg.id;
        update acc;
        Id RecordTypeIdCase = Schema.SObjectType.Case.getRecordTypeInfosByName().get('CSR').getRecordTypeId();
        Case ctest = TestDataFactory.CreateCase(acc);
        ctest.RecordTypeId=RecordTypeIdCase;
        
        update ctest;
        Division__C div=new division__c();
        div.name='75';
        div.division_code__c='75';
        insert div;
        
        CalculateMarkettingYearHelper.MarketingYearWrapper mktYearWrapperCAD = CalculateMarkettingYearHelper.calculateYearWithoutVisibility('3710');

        SKU__c sku=TestDataFactory.CreateSKU('Test123',sorg,'comb' );
    	sku.Product_Category__c='Herbicides';
    	sku.Name='Test1';
        sku.Division__c=div.id;
        sku.Market_Manager__c=Userinfo.getUserId();
        sku.isparent__c=true;
    	update sku;
         PriceBookMaster__c pbm=new PriceBookMaster__c();
        pbm.Sales_Org__c=sorg.id;
        pbm.StartDate__c=system.today().addmonths(-1);
        pbm.EndDate__c=system.today().addyears(1);
        pbm.CompositeKey__c='test';
        pbm.SKUCode__c=sku.id;
        pbm.Division__c=div.id;
        pbm.DistributorCustomerCode__c=acc.id;
        insert pbm;       
        case_product__c cp=new case_product__c();
        cp.Case__c=ctest.id;
        cp.Brand_Pack_Size__c=sku.id;
        cp.Effective_Start_Date__c=system.today().addyears(2);
        cp.Effective_End_Date__c=system.today().addyears(3);
        insert cp;
        
        system.debug('caseno::'+ctest.casenumber);
        CaseUpdateServiceNAM objconfirm = new CaseUpdateServiceNAM();
        System.debug('Debug Email Service');
        
        // Create a new email, envelope object and Attachment
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
        objconfirm.handleInboundEmail(email, envelope);
        
        email.subject = 'NAM sales data';
        email.plainTextBody = 'This is a test mail.';
        email.fromAddress='kpophale@in.ibm.com';
        envelope.fromAddress = 'upl@uniphos.com';
        Case cc=[select id,CaseNumber from case where id=:ctest.Id];
        Messaging.InboundEmail.BinaryAttachment binaryAttachment = new Messaging.InboundEmail.BinaryAttachment();
        binaryAttachment.Filename = 'caseupdate data.csv';
        String csvAttachment = 'Case Number,SAP doc no\r\n'+cc.CaseNumber+',6250321\r\n';
        system.debug('csvAttachment::'+csvAttachment);
        binaryAttachment.body = Blob.valueOf(csvAttachment);
        //binaryattachment.mimeTypeSubType = 'text/plain';
        email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] { binaryattachment };
            objconfirm.handleInboundEmail(email, envelope);
        
        Messaging.InboundEmailResult result = objconfirm.handleInboundEmail(email, envelope);
    }
    
}