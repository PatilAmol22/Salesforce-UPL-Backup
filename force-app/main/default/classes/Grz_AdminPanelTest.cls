@isTest
public class Grz_AdminPanelTest {
    Public  static testmethod void testPriceDiscount(){
        
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        system.runAs(thisUser){
            EmailTemplate Em = new EmailTemplate ();
            Em.isActive = true;
            Em.Name= 'Admin Panel Footer Details';
            Em.developername = 'Admin_Panel_Footer_Details';
            Em.TemplateType= 'Custom';
            Em.body = '[FiscalYear] and [SignatureId]';
            Em.HtmlValue = '[FiscalYear] and [SignatureId]';
            Em.FolderId = thisUser.Id;
            Insert Em;
        }
        
        
        Document d = new Document();
        d.DeveloperName  = 'Admin_Panel_PDF_Signature' ;
        d.name = 'Admin Panel PDF Signature';
        d.FolderId = userInfo.getUserId();
        insert d;
        
        Product2 pro = new Product2();
        pro.Name = 'Test Product';
        pro.ProductCode = '121312';
        pro.Combination_Key__c = '86433';
        pro.Portfolio__c = 'Test';
        pro.Technical_Name__c = 'Test';
        insert pro;
        
        Sales_Org__c soc = new Sales_Org__c();
        soc.Name = 'United Kingdom';
        soc.Description__c = 'United Kingdom';
        soc.Sales_Org_Code__c = '1000';                  
        soc.Continent__c = 'Europe';
        soc.Company_Code__c = '1000';
        soc.Country_Code__c = 'UK';
        insert soc;
        
        Payment_Term__c paymentTermObj = new Payment_Term__c(
            Payment_Term__c = 'Net 7 days',   // Payment Term
            Payment_Term_Code__c = 'UK01',      // Payment Term Code
            Payterms_Desc__c = 'Net 7 days',    // Payterms Desc
            Sales_Org__c = soc.Id,   // Sales Org
            Days_to_calc_interest__c = 0,     // Days (to calc interest)
            Active__c = true,                   // Active
            CombinationKey__c = '5710UK01'     // CombinationKey
        );
        insert paymentTermObj; 
        
        Distribution_Channel__c DistributionChannelObj = new Distribution_Channel__c(
            Name = '20',                        // Distribution Channel Name
            Distribution_Channel_Code__c = '20',  // Distribution Channel Code
            Description__c='test'
        );
        insert DistributionChannelObj;
        
        Zone__c zoneObj = new Zone__c(
            Name = 'Punjab',                // Zone Name
            SalesOrg__c = soc.Id,   // Sales Org
            ZoneCode__c = 'SWZ02'            // Zone Code
        );
        insert zoneObj;
        
        SKU__c sku = new SKU__c();
        sku.Brand_Name__c = 'Brand';
        sku.Pack_Size__c =0.00;
        sku.Unit_Cost__c =200;
        sku.Area_Manager_MSP__c =150;
        sku.Sales_Agent_MSP__c = 500;
        sku.Sales_Director_MSP__c = 50;
        sku.Sales_Org__c = soc.Id;
        sku.Pack_Size_Description__c = 'test';
        sku.Material_type__c = 'Fert';       
        sku.Product_Name__c = pro.Id;
        sku.UOM__c = 'L';
        sku.Brand_Name__c = 'Test';
        sku.Active__c = true;
        sku.PriceList_Active__c = true;
        sku.Distribution_Channel__c = DistributionChannelObj.Id;
        sku.SKU_Code__c = '2031';
        sku.Combination_Key__c = '27654';
        insert sku;
        
        SBU__c sbu = new SBU__c(
            SBUCode__c = 'BR1',                // SBU Code
            SalesOrg__c = soc.id     // Sales Org
            
        );
        insert sbu;
        sbu = [select id,name,SBUCode__c,SalesOrg__c from sbu__c where id =: sbu.id];
        
        system.debug('sbu==>>'+sbu);
        system.debug('sbuName==>>'+sbu.name);
        PrIce_List_Type_Master__c pltmaster= new PrIce_List_Type_Master__c();
        pltmaster.Price_List_Type__c='03';
        pltmaster.Zone__c=zoneObj.Id;
        pltmaster.SBU__c=sbu.Id;
        insert pltmaster;
        
        Price_Group_Master__c pB = new Price_Group_Master__c();
        pB.PG_Code__c = '49';
        insert pB;
        pB = [select id,name,PG_Code__c from Price_Group_Master__c where id =: pB.id];
        
         Id accRecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        
        account acc1 = new account();
        acc1.Price_List_Type__c = pltmaster.id;
        acc1.PriceGroupCode__c = pB.Id;
        //acc1.Email__c = 'abc@gmail.com';
        acc1.Name = 'Test345999';
        acc1.Mobile__c= '4487656687';
        acc1.Depot_Code__c = 'vghdfg';
        acc1.SAP_Code__c = '12567345';
        acc1.recordtypeid=accRecordTypeId;
        //acc1.RecordTypeId = devRecordAcc;
        acc1.Business_Type__c ='B to C';
        acc1.Incoterms_Part_2__c = 'FREIGHT PAID BY UPL';
        acc1.Payment_Term_Code__c = paymentTermObj.Id;                          // Payment Term Code
        acc1.Payment_Terms__c = 'UK07';         
        acc1.Distribution_Channel__c = DistributionChannelObj.Id;
        acc1.AuthorizationGroupSalesoffice__c='';
        acc1.Tax_classification_for_customer__c ='1';
        acc1.Account_Type__c = 'Sold_to_Party__c';
        acc1.Distributor_Name__c = 'UK';
        acc1.Billing_Street_1__c = 'KM. 1.5 AUTOPISTA MEDELLIN COSTA';         // Billing Street 1
        acc1.Billing_Street_2__c = 'KM. 1.5 AUTOPISTA MEDELLIN COSTADO NORTE';  // Billing Street 2
        acc1.Billing_Street_3__c = 'BODEGA NoCENTRO EMPRESARIAL SAN BERNARDO'; 
        acc1.Sales_Org__c = soc.id;
        acc1.Zone_Distributor__c = zoneObj.Id;
        insert acc1 ;
        
        
        Depot__c depot = new Depot__c();
        depot.Name = 'UK12';
        depot.Location__c ='UK12';
        depot.Depot_Code__c = 'UK12';
        depot.SalesOrg__c = soc.Id;
        insert depot;
        
        
        
        PriceBookMaster__c pbm = new PriceBookMaster__c();
        pbm.Price_List_Type__c = pltmaster.id;
        pbm.DepotCode__c =depot.Id;
        pbm.SKUCode__c = sku.Id;
        pbm.UOM__c= 'L';
        pbm.PG_CODE__c =pB.id;
        pbm.price__c = 400;
        pbm.DistributorCustomerCode__c = acc1.Id;
        pbm.CompositeKey__c ='werty456787';
        pbm.Active__c = true;
        pbm.StartDate__c =  date.today();
        pbm.EndDate__c = date.today();
        pbm.Active__c = true;
        insert pbm;
        
        
        
        Admin_Panel__c ap=new Admin_Panel__c(Name='test admin panel',Circular_Detail__c='Test Circular detail',Fetched_Date__c=date.today(),Send_Date__c=date.today(),Email_Sent__c=false);
        insert ap;
        ContentVersion contentVersion = new ContentVersion(
            Title = 'Penguins',
            PathOnClient = 'Penguins.jpg',
            VersionData = Blob.valueOf('Test Content'),
            IsMajorVersion = true
        );
        insert contentVersion;    
        List<ContentDocument> documents = [
            SELECT Id, Title, LatestPublishedVersionId 
            FROM ContentDocument
        ];
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = ap.id;
        cdl.ContentDocumentId = documents[0].Id;
        cdl.shareType = 'V';
        insert cdl;
        Test.startTest();
        List<String> a=new List<String>();
        a.add(soc.Company_Code__c);
        Grz_AdminPanel.AdminPaneInfo(1,5);
        Grz_AdminPanel.GetSbu(a);
        Grz_AdminPanel.GetPriceBook(zoneObj.Name,String.valueOf(date.today()),String.valueOf(date.today()),'','',false,pB.Pg_code__c,sbu.Name);
        Grz_AdminPanel.GetPriceBook(zoneObj.Name,'','',String.valueOf(Date.Today().Month()),String.valueOf(Date.Today().Year()),false,pB.Pg_code__c,sbu.Name);
        Grz_AdminPanel.GetPriceBook(zoneObj.Name,String.valueOf(date.today()),String.valueOf(date.today()),'','',true,pB.Pg_code__c,sbu.Name);
        Grz_AdminPanel.GetPriceBook(zoneObj.Name,'','',String.valueOf(Date.Today().Month()),String.valueOf(Date.Today().Year()),true,pB.Pg_code__c,sbu.Name);
        Grz_AdminPanel.HeaderDet('SBU-Test',zoneObj.Name,String.valueOf(date.today()),String.valueOf(date.today()),pltmaster.Price_List_Type__c);
        
        Grz_AdminPanelVfController ga= new Grz_AdminPanelVfController();
        ga.Grz_AdminPanelData();
        Map<String,String> Mails = new  Map<String,String>();
        Mails.put(acc1.Id,'test@mail.com');
        Map<String,String> Mails1 = new  Map<String,String>();
        Mails1.put(acc1.Id,null);
        Mails1.put(acc1.Id,'');
        Grz_AdminPanelVfController.SendMail('test',zoneObj.Name,String.valueOf(date.today()),String.valueOf(date.today()),'SBU-Test','test','test','test',Mails1);
        Grz_AdminPanelVfController.SendMail('test',zoneObj.Name,String.valueOf(date.today()),String.valueOf(date.today()),'SBU-Test','test','test','test',Mails);
        Grz_AdminPanelVfController.SendMail('test',zoneObj.Name,String.valueOf(date.today()),String.valueOf(date.today()),'SBU-Test','test','test','test',null);
        Test.stopTest();
    }
    
}