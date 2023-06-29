@isTest 
public class NewBrazilPriceBookController_Test {
     
    private Static Division__c div ;
    private Static Price_Book__c priceBookObj;
    private Static Sales_Org__c sorg;
    private Static Region__c region;
    private Static Region__c region1 ;
    private Static SKU__c skuRecord;
    private Static SKU__c skuRec2;
    private Static Payment_Term__c payTerm;
    public static User u ;
    
    static testMethod void testName() {
        
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        //===================== Added by SKI Start Here===========
    //Instantiate the Pricebook2 record with StandardPricebookId
        Pricebook2 standardPricebook = new Pricebook2(
            Id = Test.getStandardPricebookId(),
            IsActive = true
        );
        NewBrazilPriceBookController.getProfileID();
        //Execute an update DML on the Pricebook2 record, to make IsStandard to true
        Update standardPricebook;
    //==+================= Added by SKI End Here===========
        test.startTest();
        u = new User(Alias = 'standt', Email='standarduser@testorg.com',
                     EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                     LocaleSidKey='en_US', ProfileId = p.Id,
                     TimeZoneSidKey='America/Los_Angeles',
                     UserName=uniqueUserName);
        insert u;
        test.stopTest();
        Brazil_priceBook brzObj = new Brazil_priceBook(); 
        System.runAs ( u ) {
        div = new Division__c(
            Name = 'Agro Formulation',
            Division_Code__c = '10'
        );
        insert div;
        
        priceBookObj = new Price_Book__c(
            Name = 'LISTA ABRIL ZARTAN - REGIONAL TRIANGULO - PRAZO AGOSTO 2017',
            Division__c = div.id,                                           
            Currency__c = 'BRL and USD',
            Valid_From__c = system.today(),
            Expiry_Date__c = system.today(),
            Interest_Rate_R__c = 1.1,
            Interest_Rate_U__c = 1.1,
            Interest_Date__c = system.today(),
            isActive__c = true,
            Status__c = 'Draft',
            Use_Campaign__c = true,
            Campaign_Type__c = 'Simple',
            AVEC_Price_Book__c = true,
            Sales_Order_Block_Date__c =system.today()
            
        );
        insert priceBookObj; //String.valueOf(System.today());
        
        sorg = new Sales_Org__c();
        sorg.Name='Brazil';
        sorg.Sales_Org_Code__c='5191';
        insert sorg;

         payTerm = new Payment_Term__c(
           // Name='Test',
            //SalesOrgCode__c='5191',
            Payment_Term_Code__c='PT01',
            Payterms_Desc__c='Test',
            Sales_Org__c=sorg.Id
        );
        insert payTerm;
        
        region = new Region__c();
        region.Name='MATO GROSSO DO SUL';
        region.RegionCode__c= 'BR1010';
        region.SalesOrg__c = sorg.Id;
        
        insert region;
        
        region1 = new Region__c();
        region1.Name='ARROZ';
        region1.RegionCode__c= 'BR2006';
        region1.SalesOrg__c = sorg.Id;
        
        insert region1;
            Culture__c culture1= new Culture__c();
            culture1.Name='Soja';
                culture1.Culture_Code__c='B26';
                culture1.Active__c=true;
            culture1.Sales_Org__c=sorg.Id;
                insert culture1;
        
            Account acc = new Account();
        acc.Name = 'LEONARDO PASSINATO';
        acc.Email__c = 'ganesh039@gmail.com';
        acc.Last_Name__c = 'PASSINATO';
        acc.SAP_Code__c = '2028843';
        acc.Mobile__c = '9967341759';
        acc.Phone = '01234567891';
        acc.Sales_Org__c = sorg.Id;
        acc.BillingCity = 'MINEIROS';
        acc.SAP_Code__c = '2028843';
        acc.Tax_Number_3__c = '114415455';
        acc.Tax_Number_1__c = '114414523';
        acc.Customer_Region__c = 'AC';
        acc.Customer_Group__c = '001';
        acc.Program_Margin_Discount__c = 0.00;
        acc.Active__c = true;
        acc.Search_Terms_1__c = 'LEONARDO PASSINATO';
        acc.Search_Terms_2__c = 'FAZ SEUBAK';
        acc.Price_Conversion_Group__c = 'A';
        insert acc;
            
            
        skuRecord = new SKU__c(
            Name = 'TdsetRevorf',                                // SKU Name
            SKU_Code__c = '000000000005250195',                      // SKU Code
            SKU_Description__c = 'MANZATE 800WP 25KG PAPER BAG_BR',  // SKU Description
            UOM__c = 'KG',
            Division__c = div.Id,                                    // Division
            Sales_Org__c = sorg.Id,                              // Sales Org
            Multiple_of__c = 25.00,                                  // Multiple Of
            Combination_Key__c = '519110000000000005250195',         // Combination Key
            Active__c = true                                         // Active
        );
        
        insert skuRecord;
        
        
        skuRec2= new SKU__c(
            Name = 'ikasd',                     // SKU Name
            SKU_Code__c = '000000000005250198',             // SKU Code
            SKU_Description__c = 'JHGDU5UR',                // SKU Description
            UOM__c = 'KG',                                  // UOM
            Division__c = div.Id,                                    // Division
            Sales_Org__c = sorg.Id,                // Sales Org
            Multiple_of__c = 0.00,                          // Multiple Of
            Combination_Key__c = '5191000000000005250198',  // Combination Key
            Active__c = true                               // Active
        );
        insert skuRec2;

        NewBrazilPriceBookController newPricebook = new NewBrazilPriceBookController();

       Price_Book_Details__c pb_details = new Price_Book_Details__c(
            Price_Book__c = priceBookObj.id,
            Minimum_Price_R__c = 0.0,
            Minimum_Price_U__c = 0.0,
            Unit_Price_R__c = 0.0,
            Unit_Price_U__c = 0.0,
            Future_Sales_Price_R__c = 0.0,
            Future_Sales_Price_U__c = 0.0,
            SKU__c = skuRecord.id,
            Sales_District1__c = region.id 
       );
       insert pb_details;
        
        Campaign_Payment_Terms__c cpt = new Campaign_Payment_Terms__c(
        Price_Book_Brazil__c=priceBookObj.id,
        Payment_Term__c=payTerm.id    
        );
        insert cpt;

     /*  ProcessInstance p_instance = new ProcessInstance(
           Status = 'Approved',
           TargetObjectId = priceBookObj.id,
           LastActorId = u.id
       );
        insert p_instance;

       ProcessInstanceStep stepInst = new ProcessInstanceStep(
           ProcessInstanceId = p_instance.id,
           Comments = 'Test'
       );
       insert stepInst;*/

        NewBrazilPriceBookController.getDefaultDivision();
        NewBrazilPriceBookController.getDivision();
        NewBrazilPriceBookController.getProfileID();
        NewBrazilPriceBookController.getSalesDistrict();
        NewBrazilPriceBookController.getPaymentTerms();
        NewBrazilPriceBookController.getSku(div.Id,false);
        NewBrazilPriceBookController.skuDescriptionMap();
        NewBrazilPriceBookController.setActiveDeactive(priceBookObj.id,'true');

        NewBrazilPriceBookController.PriceBook pBook = new NewBrazilPriceBookController.PriceBook();
            pBook.pb_for_cmpgn=true;
            pBook.cmpgn_tp='Simple';
            pBook.pb_name='Test Campaign';
            pBook.curncy='BRL and USD';
            pBook.frm_dt=String.valueOf(System.today());
            pBook.exp_dt=String.valueOf(System.today());
            pBook.intr_rt_R='0.0';
            pBook.intr_rt_U='0.0';
            pBook.intr_dt=String.valueOf(System.today());
            pBook.division=div.Id;
            pBook.blk_dt=String.valueOf(System.today());
            pBook.division_nm='';
           pBook.usdRate='75.0';
            pBook.isActive=true;
            pBook.status='Draft';
            pBook.las_mon=String.valueOf(System.today());
            pBook.pb_for_avec=true;
            pBook.pb_for_kit = true;
            
            NewBrazilPriceBookController.PriceBook pBook1 = new NewBrazilPriceBookController.PriceBook();
            pBook1.pb_for_cmpgn=true;
            pBook1.cmpgn_tp='Simple';
            pBook1.pb_name='Test Campaign';
            pBook1.curncy='BRL';
            pBook1.frm_dt=String.valueOf(System.today());
            pBook1.exp_dt=String.valueOf(System.today());
            pBook1.intr_rt_R='0.0';
            pBook1.intr_rt_U='0.0';
            pBook1.intr_dt=String.valueOf(System.today());
            pBook1.division=div.Id;
            pBook1.blk_dt=String.valueOf(System.today());
            pBook1.division_nm='';
           pBook1.usdRate='75.0';
            pBook1.isActive=true;
            pBook1.status='Draft';
            pBook1.las_mon=String.valueOf(System.today());
            pBook1.pb_for_avec=true;
            pBook.pb_for_kit = true;
                
            List<NewBrazilPriceBookController.ProductSku> skuList = new List<NewBrazilPriceBookController.ProductSku>();
            NewBrazilPriceBookController.ProductSku pSKU = new NewBrazilPriceBookController.ProductSku();
                pSKU.cn=region.RegionCode__c;
                pSKU.mt_code='';
                pSKU.sku_code=skuRecord.SKU_Code__c;
                pSKU.min_prc='0,0';
                pSKU.min_prc_u='0,0';
                pSKU.unt_prc='0,0';
                pSKU.unt_prc_u='0,0';
                pSKU.fsp='0,0';
                pSKU.fsp_u='0,0';
               // pSKU.pbd_id='';
            skuList.add(pSKU);

            String serlizePriceB = JSON.serialize(pBook); 
            String serlizePriceB1 = JSON.serialize(pBook1); 
            String serlizeSkuList = JSON.serialize(skuList);
            
             list<string> culList= new list<string>();
            Culture__c c= new Culture__c();
            c.name='test culture';
            c.Culture_Code__c='B01';
            insert c;
            culList.add(c.id);

            List<NewBrazilPriceBookController.wrapperForSalesDistrict> lstOfWrapSalesDt = new  List<NewBrazilPriceBookController.wrapperForSalesDistrict>();
            NewBrazilPriceBookController.wrapperForSalesDistrict wrapObjForSalesDist = new NewBrazilPriceBookController.wrapperForSalesDistrict();
            NewBrazilPriceBookController.wrapperForSalesDistrict wrapObjForSalesDist1 = new NewBrazilPriceBookController.wrapperForSalesDistrict();
            wrapObjForSalesDist.Id = region.id;
            wrapObjForSalesDist.sdtId = region.id;
            wrapObjForSalesDist.Name = region.Name;
            wrapObjForSalesDist.SDCode = region.RegionCode__c;
            lstOfWrapSalesDt.add(wrapObjForSalesDist);
            
            wrapObjForSalesDist1.Id = region1.id;
            wrapObjForSalesDist1.sdtId = region1.id;
            wrapObjForSalesDist1.Name = region1.Name;
            wrapObjForSalesDist1.SDCode = region1.RegionCode__c;
            lstOfWrapSalesDt.add(wrapObjForSalesDist);

            String serlizeStr1 = JSON.serialize(lstOfWrapSalesDt);
            
            
            List<NewBrazilPriceBookController.wrapperForCropCul> lstwrapForCropCul = new  List<NewBrazilPriceBookController.wrapperForCropCul>();
            NewBrazilPriceBookController.wrapperForCropCul wrapperForCropCul1 = new NewBrazilPriceBookController.wrapperForCropCul();
            NewBrazilPriceBookController.wrapperForCropCul wrapperForCropCul2 = new NewBrazilPriceBookController.wrapperForCropCul();
            //wrapperForCropCul2.Id = culture1.id;
            //wrapperForCropCul2.Id11 = culture1.id;
            wrapperForCropCul2.sdtId1 = culture1.id;
            wrapperForCropCul2.Name1 = culture1.Name;
            wrapperForCropCul2.SDCode1 =culture1.Culture_Code__c;
            lstwrapForCropCul.add(wrapperForCropCul2);
            String serlizeStr9 = JSON.serialize(lstwrapForCropCul);
            
            List<NewBrazilPriceBookController.wrapperForCustGroup> lstwrapperForCustGroup = new  List<NewBrazilPriceBookController.wrapperForCustGroup>();
            NewBrazilPriceBookController.wrapperForCustGroup wrapperForCustGroup1 = new NewBrazilPriceBookController.wrapperForCustGroup();
            NewBrazilPriceBookController.wrapperForCustGroup wrapperForCustGroup2 = new NewBrazilPriceBookController.wrapperForCustGroup();
            //wrapperForCropCul2.Id = culture1.id;
            //wrapperForCropCul2.Id11 = culture1.id;
            //wrapperForCustGroup1.sdtId2 = acc.id;
            //wrapperForCustGroup1.Name2 = acc.Name;
            wrapperForCustGroup1.SDCode2 ='001';
            lstwrapperForCustGroup.add(wrapperForCustGroup1);
            String serlizeStr8 = JSON.serialize(lstwrapperForCustGroup);
            
            
            List<NewBrazilPriceBookController.wrapperForCustName> lstwrapperForCustName = new  List<NewBrazilPriceBookController.wrapperForCustName>();
            NewBrazilPriceBookController.wrapperForCustName wrapperForCustName1 = new NewBrazilPriceBookController.wrapperForCustName();
            NewBrazilPriceBookController.wrapperForCustName wrapperForCustName2 = new NewBrazilPriceBookController.wrapperForCustName();
            //wrapperForCropCul2.Id = culture1.id;
            //wrapperForCropCul2.Id11 = culture1.id;
            wrapperForCustName1.id = acc.id;
            wrapperForCustName1.Name = acc.Name;
            wrapperForCustName1.PriceConversionGroup = acc.Name;
           // wrapperForCustName1.sapcode =acc.Culture_Code__c;
            lstwrapperForCustName.add(wrapperForCustName1);
            String serlizeStr7 = JSON.serialize(lstwrapperForCustName);
            
        
           List<NewBrazilPriceBookController.PaymentTerms> lstOfPaymentTerms = new  List<NewBrazilPriceBookController.PaymentTerms>();
            NewBrazilPriceBookController.PaymentTerms wrapObjForPayterm = new NewBrazilPriceBookController.PaymentTerms();
            NewBrazilPriceBookController.PaymentTerms wrapObjForPayterm1 = new NewBrazilPriceBookController.PaymentTerms();
        
            wrapObjForPayterm.pt_id=payTerm.Id;
            wrapObjForPayterm.pt_type='day';
            wrapObjForPayterm1.pt_type='';
            wrapObjForPayterm1.pt_name=String.valueOf(System.today());
            lstOfPaymentTerms.add(wrapObjForPayterm);
            lstOfPaymentTerms.add(wrapObjForPayterm1);
        
            String serlizeStr2 = JSON.serialize(lstOfPaymentTerms);
            NewBrazilPriceBookController.getCropCultures();
            NewBrazilPriceBookController.getCustmerGroups();
            NewBrazilPriceBookController.getCustmerNames(serlizeStr8);
            NewBrazilPriceBookController.getCampaigntype(priceBookObj.id);
            NewBrazilPriceBookController.getListViews();
            NewBrazilPriceBookController.loadMapValues();
            NewBrazilPriceBookController.saveNewPriceBook(serlizePriceB, serlizeSkuList,serlizeStr1,serlizeStr9,serlizeStr8,serlizeStr7,serlizeStr2,'',culList);
            NewBrazilPriceBookController.saveAndSendForApprovalNewPriceBook(serlizePriceB, serlizeSkuList,serlizeStr1,serlizeStr9,serlizeStr8,serlizeStr7,serlizeStr2,'',culList);
            NewBrazilPriceBookController.cloneNewPriceBook(serlizePriceB, serlizeSkuList,serlizeStr1,serlizeStr9,serlizeStr8,serlizeStr7,serlizeStr2,culList);
            
            NewBrazilPriceBookController.saveNewPriceBook(serlizePriceB1, serlizeSkuList,serlizeStr1,serlizeStr9,serlizeStr8,serlizeStr7,serlizeStr2,'',culList);
            NewBrazilPriceBookController.saveAndSendForApprovalNewPriceBook(serlizePriceB1, serlizeSkuList,serlizeStr1,serlizeStr9,serlizeStr8,serlizeStr7,serlizeStr2,'',culList);
            NewBrazilPriceBookController.cloneNewPriceBook(serlizePriceB1, serlizeSkuList,serlizeStr1,serlizeStr9,serlizeStr8,serlizeStr7,serlizeStr2,culList);
            
            NewBrazilPriceBookController.editNewPriceBook(priceBookObj.id);
            NewBrazilPriceBookController.submitForApproval(priceBookObj.id);

            NewBrazilPriceBookController.PriceBook pBook2 = new NewBrazilPriceBookController.PriceBook();
            pBook2.pcb_id=priceBookObj.id;
            pBook2.pb_for_cmpgn=true;
            pBook2.cmpgn_tp='Simple';
            pBook2.pb_name='Test Campaign';
            pBook2.curncy='Only BRL';
            pBook2.frm_dt=String.valueOf(System.today());
            pBook2.exp_dt=String.valueOf(System.today());
            pBook2.intr_rt_R='0.0';
            pBook2.intr_rt_U='0.0';
            pBook2.intr_dt=String.valueOf(System.today());
            pBook2.division=div.Id;
            pBook2.blk_dt=String.valueOf(System.today());
            pBook2.las_mon=String.valueOf(System.today());
            pBook2.division_nm='';
           // pBook.pcb_id='';
            pBook2.isActive=true;
            pBook2.status='Draft';
            pBook2.usdRate='75.0';

            List<NewBrazilPriceBookController.ProductSku> skuList2 = new List<NewBrazilPriceBookController.ProductSku>();
            List<NewBrazilPriceBookController.ProductSku> skuList3 = new List<NewBrazilPriceBookController.ProductSku>();
            NewBrazilPriceBookController.ProductSku pSKU2 = new NewBrazilPriceBookController.ProductSku();
                pSKU2.cn=region.RegionCode__c;
                pSKU2.mt_code='';
                pSKU2.sku_code=skuRecord.SKU_Code__c;
                pSKU2.min_prc='0,0';
                pSKU2.min_prc_u='0,0';
                pSKU2.unt_prc='0,0';
                pSKU2.unt_prc_u='0,0';
                pSKU2.fsp='0,0';
                pSKU2.fsp_u='0,0';
               // pSKU.pbd_id='';
            skuList2.add(pSKU2);

            NewBrazilPriceBookController.ProductSku pSKU3 = new NewBrazilPriceBookController.ProductSku();
                pSKU3.pbd_id=pb_details.id;
                pSKU3.cn='';
                pSKU3.mt_code='';
                pSKU3.sku_code='';
                pSKU3.min_prc='0,0';
                pSKU3.min_prc_u='0,0';
                pSKU3.unt_prc='0,0';
                pSKU3.unt_prc_u='0,0';
                pSKU3.fsp='0,0';
                pSKU3.fsp_u='0,0';
               
            skuList3.add(pSKU3);

            String serlizePriceB2 = JSON.serialize(pBook2);  
            String serlizeSkuList2 = JSON.serialize(skuList2);
            String serlizeSkuList3 = JSON.serialize(skuList3);
        
            List<NewBrazilPriceBookController.PaymentTerms> lstOfPaymentTerms2 = new  List<NewBrazilPriceBookController.PaymentTerms>();
            List<NewBrazilPriceBookController.PaymentTerms> lstOfPaymentTerms3 = new  List<NewBrazilPriceBookController.PaymentTerms>();
            NewBrazilPriceBookController.PaymentTerms wrapObjForPayterm2 = new NewBrazilPriceBookController.PaymentTerms();
            NewBrazilPriceBookController.PaymentTerms wrapObjForPayterm3 = new NewBrazilPriceBookController.PaymentTerms();
            wrapObjForPayterm2.Id=cpt.id;
            wrapObjForPayterm2.pt_id=payTerm.Id;
            wrapObjForPayterm2.pt_name=String.valueOf(System.today());
            wrapObjForPayterm2.pt_type='day';
            lstOfPaymentTerms2.add(wrapObjForPayterm2);
            String serlizeStr3 = JSON.serialize(lstOfPaymentTerms2);
        
            wrapObjForPayterm3.Id=cpt.Id;
            lstOfPaymentTerms3.add(wrapObjForPayterm3);
            String serlizeStr4 = JSON.serialize(lstOfPaymentTerms3);
            

           NewBrazilPriceBookController.updateNewPriceBook(serlizePriceB2,serlizeSkuList2,serlizeSkuList3,serlizeStr3,serlizeStr4,serlizeStr1,serlizeStr9,serlizeStr8,serlizeStr7,culList); 
           NewBrazilPriceBookController.getMasterdata();
            NewBrazilPriceBookController.SKUValidation('[{"sku_code":"1132131","mt_code":"","min_prc":"1,00","min_prc_u":"1,00","unt_prc":"1,00","unt_prc_u":"1,00","fsp":"1,00","fsp_u":"1,00","pbd_id":""}]','[{"Id":"","sdtId":"a1B1y00000000fyEAA","sdtNameforSales":"","Name":"ALS","SDCode":"BR9901"}]');
        }
    }
    static testMethod void testNameKit() {
        
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        //===================== Added by SKI Start Here===========
    //Instantiate the Pricebook2 record with StandardPricebookId
        Pricebook2 standardPricebook = new Pricebook2(
            Id = Test.getStandardPricebookId(),
            IsActive = true
        );
        
        //Execute an update DML on the Pricebook2 record, to make IsStandard to true
        Update standardPricebook;
    //==+================= Added by SKI End Here===========
        test.startTest();
        u = new User(Alias = 'standt', Email='standarduser@testorg.com',
                     EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                     LocaleSidKey='en_US', ProfileId = p.Id,
                     TimeZoneSidKey='America/Los_Angeles',
                     UserName=uniqueUserName);
        insert u;
        test.stopTest();
        Brazil_priceBook brzObj = new Brazil_priceBook(); 
        System.runAs ( u ) {
        div = new Division__c(
            Name = 'Agro Formulation',
            Division_Code__c = '10'
        );
        insert div;
        
        priceBookObj = new Price_Book__c(
            Name = 'LISTA ABRIL ZARTAN - REGIONAL TRIANGULO - PRAZO AGOSTO 2017',
            Division__c = div.id,                                           
            Currency__c = 'BRL and USD',
            Valid_From__c = system.today(),
            Expiry_Date__c = system.today(),
            Interest_Rate_R__c = 1.1,
            Interest_Rate_U__c = 1.1,
            Interest_Date__c = system.today(),
            isActive__c = true,
            Status__c = 'Draft',
            Use_Campaign__c = true,
            Campaign_Type__c = 'Simple',
            Sales_Order_Block_Date__c =system.today(),
            Kit_Price_Book__c=true
        );
        insert priceBookObj;    //String.valueOf(System.today());
        
        sorg = new Sales_Org__c();
        sorg.Name='Brazil';
        sorg.Sales_Org_Code__c='5191';
        insert sorg;

         payTerm = new Payment_Term__c(
           // Name='Test',
            //SalesOrgCode__c='5191',
            Payment_Term_Code__c='PT01',
            Payterms_Desc__c='Test',
            Sales_Org__c=sorg.Id
        );
        insert payTerm;
        
        region = new Region__c();
        region.Name='MATO GROSSO DO SUL';
        region.RegionCode__c= 'BR1010';
        region.SalesOrg__c = sorg.Id;
        
        insert region;
        
        region1 = new Region__c();
        region1.Name='ARROZ';
        region1.RegionCode__c= 'BR2006';
        region1.SalesOrg__c = sorg.Id;
        
        insert region1;
        
            
            Culture__c culture1= new Culture__c();
            culture1.Name='Soja';
                culture1.Culture_Code__c='B26';
                culture1.Active__c=true;
            culture1.Sales_Org__c=sorg.Id;
                insert culture1;
        
            Account acc = new Account();
        acc.Name = 'LEONARDO PASSINATOA';
        acc.Email__c = 'ganesh0391@gmail.com';
        acc.Last_Name__c = 'PASSINATOA';
        acc.SAP_Code__c = '2028843';
        acc.Mobile__c = '9967341759';
        acc.Phone = '01234567891';
        acc.Sales_Org__c = sorg.Id;
        acc.BillingCity = 'MINEIROS';
        acc.SAP_Code__c = '2028843';
        acc.Tax_Number_3__c = '114415455';
        acc.Tax_Number_1__c = '114414523';
        acc.Customer_Region__c = 'AC';
        acc.Customer_Group__c = '001';
        acc.Program_Margin_Discount__c = 0.00;
        acc.Active__c = true;
        acc.Search_Terms_1__c = 'LEONARDO PASSINATO';
        acc.Search_Terms_2__c = 'FAZ SEUBAK';
        acc.Price_Conversion_Group__c = 'A';
        insert acc;
            
            
        skuRecord = new SKU__c(
            Name = 'TdsetRevorf',                                // SKU Name
            SKU_Code__c = '000000000005250195',                      // SKU Code
            SKU_Description__c = 'MANZATE 800WP 25KG PAPER BAG_BR',  // SKU Description
            UOM__c = 'KG',
            Division__c = div.Id,                                    // Division
            Sales_Org__c = sorg.Id,                              // Sales Org
            Multiple_of__c = 25.00,                                  // Multiple Of
            Combination_Key__c = '519110000000000005250195',         // Combination Key
            Active__c = true,
            Kit_Product__c  =true                                       // Active
        );
        
        insert skuRecord;
        
        
        skuRec2= new SKU__c(
            Name = 'ikasd',                     // SKU Name
            SKU_Code__c = '000000000005250198',             // SKU Code
            SKU_Description__c = 'JHGDU5UR',                // SKU Description
            UOM__c = 'KG',                                  // UOM
            Division__c = div.Id,                                    // Division
            Sales_Org__c = sorg.Id,                // Sales Org
            Multiple_of__c = 0.00,                          // Multiple Of
            Combination_Key__c = '5191000000000005250198',  // Combination Key
            Active__c = true                               // Active
        );
        insert skuRec2;

        NewBrazilPriceBookController newPricebook = new NewBrazilPriceBookController();

       Price_Book_Details__c pb_details = new Price_Book_Details__c(
            Price_Book__c = priceBookObj.id,
            Minimum_Price_R__c = 0.0,
            Minimum_Price_U__c = 0.0,
            Unit_Price_R__c = 0.0,
            Unit_Price_U__c = 0.0,
            Future_Sales_Price_R__c = 0.0,
            Future_Sales_Price_U__c = 0.0,
            SKU__c = skuRec2.id,
           Kit_SKU__c=skuRecord.Id,
            Sales_District1__c = region.id 
       );
       insert pb_details;
        
        Campaign_Payment_Terms__c cpt = new Campaign_Payment_Terms__c(
        Price_Book_Brazil__c=priceBookObj.id,
        Payment_Term__c=payTerm.id    
        );
        insert cpt;

     /*  ProcessInstance p_instance = new ProcessInstance(
           Status = 'Approved',
           TargetObjectId = priceBookObj.id,
           LastActorId = u.id
       );
        insert p_instance;

       ProcessInstanceStep stepInst = new ProcessInstanceStep(
           ProcessInstanceId = p_instance.id,
           Comments = 'Test'
       );
       insert stepInst;*/
Component__c cmp=new Component__c();
cmp.Component_SKU__c=skuRec2.Id;
cmp.kit_sku__c=skuRecord.Id;
cmp.Component_Item_Category__c='ZPAT5';
            cmp.Sales_Org__c=sorg.Id;
insert cmp;
        NewBrazilPriceBookController.getDefaultDivision();
        NewBrazilPriceBookController.getDivision();
        NewBrazilPriceBookController.getProfileID();
        NewBrazilPriceBookController.getSalesDistrict();
        NewBrazilPriceBookController.getPaymentTerms();
        NewBrazilPriceBookController.getSku(div.Id,false);
        NewBrazilPriceBookController.skuDescriptionMap();
        NewBrazilPriceBookController.setActiveDeactive(priceBookObj.id,'true');
NewBrazilPriceBookController.getComponent('000000000005250198');
        NewBrazilPriceBookController.PriceBook pBook = new NewBrazilPriceBookController.PriceBook();
            pBook.pb_for_Kit=true;
            //pBook.cmpgn_tp='Simple';
            pBook.pb_name='Test Campaign';
            pBook.curncy='BRL and USD';
            pBook.frm_dt=String.valueOf(System.today());
            pBook.exp_dt=String.valueOf(System.today());
            pBook.intr_rt_R='0.0';
            pBook.intr_rt_U='0.0';
            pBook.intr_dt=String.valueOf(System.today());
            pBook.division=div.Id;
            pBook.blk_dt=String.valueOf(System.today());
            pBook.division_nm='';
          pBook.usdRate='75.0';
            pBook.isActive=true;
            pBook.status='Draft';

            List<NewBrazilPriceBookController.ProductSku> skuList = new List<NewBrazilPriceBookController.ProductSku>();
            NewBrazilPriceBookController.ProductSku pSKU = new NewBrazilPriceBookController.ProductSku();
                pSKU.cn=region.RegionCode__c;
                pSKU.mt_code='';
                pSKU.sku_code=skuRecord.SKU_Code__c;
                pSKU.min_prc='0,0';
                pSKU.min_prc_u='0,0';
                pSKU.unt_prc='0,0';
                pSKU.unt_prc_u='0,0';
                pSKU.fsp='0,0';
                pSKU.fsp_u='0,0';
               // pSKU.pbd_id='';
            skuList.add(pSKU);

            String serlizePriceB = JSON.serialize(pBook);  
            String serlizeSkuList = JSON.serialize(skuList);

            List<NewBrazilPriceBookController.wrapperForSalesDistrict> lstOfWrapSalesDt = new  List<NewBrazilPriceBookController.wrapperForSalesDistrict>();
            NewBrazilPriceBookController.wrapperForSalesDistrict wrapObjForSalesDist = new NewBrazilPriceBookController.wrapperForSalesDistrict();
            NewBrazilPriceBookController.wrapperForSalesDistrict wrapObjForSalesDist1 = new NewBrazilPriceBookController.wrapperForSalesDistrict();
            wrapObjForSalesDist.Id = region.id;
            wrapObjForSalesDist.sdtId = region.id;
            wrapObjForSalesDist.Name = region.Name;
            wrapObjForSalesDist.SDCode = region.RegionCode__c;
            lstOfWrapSalesDt.add(wrapObjForSalesDist);
            
            wrapObjForSalesDist1.Id = region1.id;
            wrapObjForSalesDist1.sdtId = region1.id;
            wrapObjForSalesDist1.Name = region1.Name;
            wrapObjForSalesDist1.SDCode = region1.RegionCode__c;
            lstOfWrapSalesDt.add(wrapObjForSalesDist);

            String serlizeStr1 = JSON.serialize(lstOfWrapSalesDt);
        
           List<NewBrazilPriceBookController.PaymentTerms> lstOfPaymentTerms = new  List<NewBrazilPriceBookController.PaymentTerms>();
            NewBrazilPriceBookController.PaymentTerms wrapObjForPayterm = new NewBrazilPriceBookController.PaymentTerms();
            NewBrazilPriceBookController.PaymentTerms wrapObjForPayterm1 = new NewBrazilPriceBookController.PaymentTerms();
        
            wrapObjForPayterm.pt_id=payTerm.Id;
            wrapObjForPayterm.pt_type='day';
            wrapObjForPayterm1.pt_type='';
            wrapObjForPayterm1.pt_name=String.valueOf(System.today());
            lstOfPaymentTerms.add(wrapObjForPayterm);
            lstOfPaymentTerms.add(wrapObjForPayterm1);
        
            String serlizeStr2 = JSON.serialize(lstOfPaymentTerms);
            //NewBrazilPriceBookController.getCampaigntype(pBook.id);       
            NewBrazilPriceBookController.getListViews();
            NewBrazilPriceBookController.loadMapValues();
          //  NewBrazilPriceBookController.saveNewPriceBook(serlizePriceB, serlizeSkuList,serlizeStr1,serlizeStr2,'');
            //NewBrazilPriceBookController.saveAndSendForApprovalNewPriceBook(serlizePriceB, serlizeSkuList,serlizeStr1,serlizeStr2,'');
           // NewBrazilPriceBookController.cloneNewPriceBook(serlizePriceB, serlizeSkuList,serlizeStr1,serlizeStr2);
            NewBrazilPriceBookController.editNewPriceBook(priceBookObj.id);
            NewBrazilPriceBookController.submitForApproval(priceBookObj.id);

            NewBrazilPriceBookController.PriceBook pBook2 = new NewBrazilPriceBookController.PriceBook();
            pBook2.pcb_id=priceBookObj.id;
            pBook2.pb_for_cmpgn=true;
            pBook2.cmpgn_tp='Simple';
            pBook2.pb_name='Test Campaign';
            pBook2.curncy='Only BRL';
            pBook2.frm_dt=String.valueOf(System.today());
            pBook2.exp_dt=String.valueOf(System.today());
            pBook2.intr_rt_R='0.0';
            pBook2.intr_rt_U='0.0';
            pBook2.intr_dt=String.valueOf(System.today());
            pBook2.division=div.Id;
            pBook2.blk_dt=String.valueOf(System.today());
            pBook2.las_mon=String.valueOf(System.today());
            pBook2.division_nm='';
           // pBook.pcb_id='';
            pBook2.isActive=true;
            pBook2.status='Draft';
            pBook2.usdRate='75.0';
            List<NewBrazilPriceBookController.ProductSku> skuList2 = new List<NewBrazilPriceBookController.ProductSku>();
            List<NewBrazilPriceBookController.ProductSku> skuList3 = new List<NewBrazilPriceBookController.ProductSku>();
            NewBrazilPriceBookController.ProductSku pSKU2 = new NewBrazilPriceBookController.ProductSku();
                pSKU2.cn=region.RegionCode__c;
                pSKU2.mt_code='';
                pSKU2.sku_code=skuRecord.SKU_Code__c;
                pSKU2.min_prc='0,0';
                pSKU2.min_prc_u='0,0';
                pSKU2.unt_prc='0,0';
                pSKU2.unt_prc_u='0,0';
                pSKU2.fsp='0,0';
                pSKU2.fsp_u='0,0';
               // pSKU.pbd_id='';
            skuList2.add(pSKU2);

            NewBrazilPriceBookController.ProductSku pSKU3 = new NewBrazilPriceBookController.ProductSku();
                pSKU3.pbd_id=pb_details.id;
                pSKU3.cn='';
                pSKU3.mt_code='';
                pSKU3.sku_code='';
                pSKU3.min_prc='0,0';
                pSKU3.min_prc_u='0,0';
                pSKU3.unt_prc='0,0';
                pSKU3.unt_prc_u='0,0';
                pSKU3.fsp='0,0';
                pSKU3.fsp_u='0,0';
               
            skuList3.add(pSKU3);

            String serlizePriceB2 = JSON.serialize(pBook2);  
            String serlizeSkuList2 = JSON.serialize(skuList2);
            String serlizeSkuList3 = JSON.serialize(skuList3);
        
            List<NewBrazilPriceBookController.PaymentTerms> lstOfPaymentTerms2 = new  List<NewBrazilPriceBookController.PaymentTerms>();
            List<NewBrazilPriceBookController.PaymentTerms> lstOfPaymentTerms3 = new  List<NewBrazilPriceBookController.PaymentTerms>();
            NewBrazilPriceBookController.PaymentTerms wrapObjForPayterm2 = new NewBrazilPriceBookController.PaymentTerms();
            NewBrazilPriceBookController.PaymentTerms wrapObjForPayterm3 = new NewBrazilPriceBookController.PaymentTerms();
            wrapObjForPayterm2.Id=cpt.id;
            wrapObjForPayterm2.pt_id=payTerm.Id;
            wrapObjForPayterm2.pt_name=String.valueOf(System.today());
            wrapObjForPayterm2.pt_type='day';
            lstOfPaymentTerms2.add(wrapObjForPayterm2);
            String serlizeStr3 = JSON.serialize(lstOfPaymentTerms2);
        
            wrapObjForPayterm3.Id=cpt.Id;
            lstOfPaymentTerms3.add(wrapObjForPayterm3);
            String serlizeStr4 = JSON.serialize(lstOfPaymentTerms3);
            List<NewBrazilPriceBookController.wrapperForCropCul> lstwrapForCropCul = new  List<NewBrazilPriceBookController.wrapperForCropCul>();
            NewBrazilPriceBookController.wrapperForCropCul wrapperForCropCul1 = new NewBrazilPriceBookController.wrapperForCropCul();
            NewBrazilPriceBookController.wrapperForCropCul wrapperForCropCul2 = new NewBrazilPriceBookController.wrapperForCropCul();
            //wrapperForCropCul2.Id = culture1.id;
            //wrapperForCropCul2.Id11 = culture1.id;
            wrapperForCropCul2.sdtId1 = culture1.id;
            wrapperForCropCul2.Name1 = culture1.Name;
            wrapperForCropCul2.SDCode1 =culture1.Culture_Code__c;
            lstwrapForCropCul.add(wrapperForCropCul2);
            String serlizeStr9 = JSON.serialize(lstwrapForCropCul);
            
            List<NewBrazilPriceBookController.wrapperForCustGroup> lstwrapperForCustGroup = new  List<NewBrazilPriceBookController.wrapperForCustGroup>();
            NewBrazilPriceBookController.wrapperForCustGroup wrapperForCustGroup1 = new NewBrazilPriceBookController.wrapperForCustGroup();
            NewBrazilPriceBookController.wrapperForCustGroup wrapperForCustGroup2 = new NewBrazilPriceBookController.wrapperForCustGroup();
            //wrapperForCropCul2.Id = culture1.id;
            //wrapperForCropCul2.Id11 = culture1.id;
            //wrapperForCustGroup1.sdtId2 = acc.id;
            //wrapperForCustGroup1.Name2 = acc.Name;
            wrapperForCustGroup1.SDCode2 ='001';
            lstwrapperForCustGroup.add(wrapperForCustGroup1);
            String serlizeStr8 = JSON.serialize(lstwrapperForCustGroup);
            
             list<string> culList= new list<string>();
            Culture__c c= new Culture__c();
            c.name='test culture';
            c.Culture_Code__c='B01';
            insert c;
            culList.add(c.id);
            
            List<NewBrazilPriceBookController.wrapperForCustName> lstwrapperForCustName = new  List<NewBrazilPriceBookController.wrapperForCustName>();
            NewBrazilPriceBookController.wrapperForCustName wrapperForCustName1 = new NewBrazilPriceBookController.wrapperForCustName();
            NewBrazilPriceBookController.wrapperForCustName wrapperForCustName2 = new NewBrazilPriceBookController.wrapperForCustName();
            //wrapperForCropCul2.Id = culture1.id;
            //wrapperForCropCul2.Id11 = culture1.id;
            wrapperForCustName1.id = acc.id;
            wrapperForCustName1.Name = acc.Name;
            wrapperForCustName1.PriceConversionGroup = acc.Name;
           // wrapperForCustName1.sapcode =acc.Culture_Code__c;
            lstwrapperForCustName.add(wrapperForCustName1);
            String serlizeStr7 = JSON.serialize(lstwrapperForCustName);

           NewBrazilPriceBookController.updateNewPriceBook(serlizePriceB2,serlizeSkuList2,serlizeSkuList3,serlizeStr3,serlizeStr4,serlizeStr1,serlizeStr9,serlizeStr8,serlizeStr7,culList); 
           NewBrazilPriceBookController.getMasterdata();
            NewBrazilPriceBookController.SKUValidation('[{"sku_code":"1132131","mt_code":"","min_prc":"1,00","min_prc_u":"1,00","unt_prc":"1,00","unt_prc_u":"1,00","fsp":"1,00","fsp_u":"1,00","pbd_id":""}]','[{"Id":"","sdtId":"a1B1y00000000fyEAA","sdtNameforSales":"","Name":"ALS","SDCode":"BR9901"}]');
        }
    }
    
    
    static testMethod void testNameKitUSD() {
        
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        //===================== Added by SKI Start Here===========
    //Instantiate the Pricebook2 record with StandardPricebookId
        Pricebook2 standardPricebook = new Pricebook2(
            Id = Test.getStandardPricebookId(),
            IsActive = true
        );
        
        //Execute an update DML on the Pricebook2 record, to make IsStandard to true
        Update standardPricebook;
    //==+================= Added by SKI End Here===========
        test.startTest();
        u = new User(Alias = 'standt', Email='standarduser@testorg.com',
                     EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                     LocaleSidKey='en_US', ProfileId = p.Id,
                     TimeZoneSidKey='America/Los_Angeles',
                     UserName=uniqueUserName);
        insert u;
        test.stopTest();
        Brazil_priceBook brzObj = new Brazil_priceBook(); 
        System.runAs ( u ) {
        div = new Division__c(
            Name = 'Agro Formulation',
            Division_Code__c = '10'
        );
        insert div;
        
        priceBookObj = new Price_Book__c(
            Name = 'LISTA ABRIL ZARTAN - REGIONAL TRIANGULO - PRAZO AGOSTO 2017',
            Division__c = div.id,                                           
            Currency__c = 'Only USD',
            Valid_From__c = system.today(),
            Expiry_Date__c = system.today(),
            Interest_Rate_R__c = 1.1,
            Interest_Rate_U__c = 1.1,
            Interest_Date__c = system.today(),
            isActive__c = true,
            Status__c = 'Draft',
            Use_Campaign__c = true,
            Campaign_Type__c = 'Simple',
            Sales_Order_Block_Date__c =system.today(),
            Kit_Price_Book__c=true
        );
        insert priceBookObj;    //String.valueOf(System.today());
        
        sorg = new Sales_Org__c();
        sorg.Name='Brazil';
        sorg.Sales_Org_Code__c='5191';
        insert sorg;

         payTerm = new Payment_Term__c(
           // Name='Test',
            //SalesOrgCode__c='5191',
            Payment_Term_Code__c='PT01',
            Payterms_Desc__c='Test',
            Sales_Org__c=sorg.Id
        );
        insert payTerm;
        
        region = new Region__c();
        region.Name='MATO GROSSO DO SUL';
        region.RegionCode__c= 'BR1010';
        region.SalesOrg__c = sorg.Id;
        
        insert region;
        
        region1 = new Region__c();
        region1.Name='ARROZ';
        region1.RegionCode__c= 'BR2006';
        region1.SalesOrg__c = sorg.Id;
        
        insert region1;
        
            
            Culture__c culture1= new Culture__c();
            culture1.Name='Soja';
                culture1.Culture_Code__c='B26';
                culture1.Active__c=true;
            culture1.Sales_Org__c=sorg.Id;
                insert culture1;
        
            Account acc = new Account();
        acc.Name = 'LEONARDO PASSINATOB';
        acc.Email__c = 'ganesh0392@gmail.com';
        acc.Last_Name__c = 'PASSINATOB';
        acc.SAP_Code__c = '2028843';
        acc.Mobile__c = '9967341759';
        acc.Phone = '01234567891';
        acc.Sales_Org__c = sorg.Id;
        acc.BillingCity = 'MINEIROS';
        acc.SAP_Code__c = '2028843';
        acc.Tax_Number_3__c = '114415455';
        acc.Tax_Number_1__c = '114414523';
        acc.Customer_Region__c = 'AC';
        acc.Customer_Group__c = '001';
        acc.Program_Margin_Discount__c = 0.00;
        acc.Active__c = true;
        acc.Search_Terms_1__c = 'LEONARDO PASSINATO';
        acc.Search_Terms_2__c = 'FAZ SEUBAK';
        acc.Price_Conversion_Group__c = 'A';
        insert acc;
            
            
        skuRecord = new SKU__c(
            Name = 'TdsetRevorf',                                // SKU Name
            SKU_Code__c = '000000000005250195',                      // SKU Code
            SKU_Description__c = 'MANZATE 800WP 25KG PAPER BAG_BR',  // SKU Description
            UOM__c = 'KG',
            Division__c = div.Id,                                    // Division
            Sales_Org__c = sorg.Id,                              // Sales Org
            Multiple_of__c = 25.00,                                  // Multiple Of
            Combination_Key__c = '519110000000000005250195',         // Combination Key
            Active__c = true,
            Kit_Product__c  =true                                       // Active
        );
        
        insert skuRecord;
        
        
        skuRec2= new SKU__c(
            Name = 'ikasd',                     // SKU Name
            SKU_Code__c = '000000000005250198',             // SKU Code
            SKU_Description__c = 'JHGDU5UR',                // SKU Description
            UOM__c = 'KG',                                  // UOM
            Division__c = div.Id,                                    // Division
            Sales_Org__c = sorg.Id,                // Sales Org
            Multiple_of__c = 0.00,                          // Multiple Of
            Combination_Key__c = '5191000000000005250198',  // Combination Key
            Active__c = true  ,
            Kit_Product__c  =true // Active
        );
        insert skuRec2;

        NewBrazilPriceBookController newPricebook = new NewBrazilPriceBookController();

       Price_Book_Details__c pb_details = new Price_Book_Details__c(
            Price_Book__c = priceBookObj.id,
            Minimum_Price_R__c = 0.0,
            Minimum_Price_U__c = 0.0,
            Unit_Price_R__c = 0.0,
            Unit_Price_U__c = 0.0,
            Future_Sales_Price_R__c = 0.0,
            Future_Sales_Price_U__c = 0.0,
            SKU__c = skuRec2.id,
           Kit_SKU__c=skuRecord.Id,
            Sales_District1__c = region.id 
       );
       insert pb_details;
        
        Campaign_Payment_Terms__c cpt = new Campaign_Payment_Terms__c(
        Price_Book_Brazil__c=priceBookObj.id,
        Payment_Term__c=payTerm.id    
        );
        insert cpt;

     /*  ProcessInstance p_instance = new ProcessInstance(
           Status = 'Approved',
           TargetObjectId = priceBookObj.id,
           LastActorId = u.id
       );
        insert p_instance;

       ProcessInstanceStep stepInst = new ProcessInstanceStep(
           ProcessInstanceId = p_instance.id,
           Comments = 'Test'
       );
       insert stepInst;*/
Component__c cmp=new Component__c();
cmp.Component_SKU__c=skuRec2.Id;
cmp.kit_sku__c=skuRecord.Id;
cmp.Component_Item_Category__c='ZPAT5';
            cmp.Sales_Org__c=sorg.Id;
insert cmp;
        NewBrazilPriceBookController.getDefaultDivision();
        NewBrazilPriceBookController.getDivision();
        NewBrazilPriceBookController.getProfileID();
        NewBrazilPriceBookController.getSalesDistrict();
        NewBrazilPriceBookController.getPaymentTerms();
        NewBrazilPriceBookController.getSku(div.Id,true);
        NewBrazilPriceBookController.skuDescriptionMap();
        NewBrazilPriceBookController.setActiveDeactive(priceBookObj.id,'true');
NewBrazilPriceBookController.getComponent('000000000005250198');
        NewBrazilPriceBookController.PriceBook pBook = new NewBrazilPriceBookController.PriceBook();
            pBook.pb_for_Kit=true;
            //pBook.cmpgn_tp='Simple';
            pBook.pb_name='Test Campaign';
            pBook.curncy='Only USD';
            pBook.frm_dt=String.valueOf(System.today());
            pBook.exp_dt=String.valueOf(System.today());
            pBook.intr_rt_R='0.0';
            pBook.intr_rt_U='0.0';
            pBook.intr_dt=String.valueOf(System.today());
            pBook.division=div.Id;
            pBook.blk_dt=String.valueOf(System.today());
            pBook.division_nm='';
           pBook.usdRate='75.0';
            pBook.isActive=true;
            pBook.status='Draft';

            List<NewBrazilPriceBookController.ProductSku> skuList = new List<NewBrazilPriceBookController.ProductSku>();
            NewBrazilPriceBookController.ProductSku pSKU = new NewBrazilPriceBookController.ProductSku();
                pSKU.cn=region.RegionCode__c;
                pSKU.mt_code='';
                pSKU.sku_code=skuRecord.SKU_Code__c;
                pSKU.min_prc='0,0';
                pSKU.min_prc_u='0,0';
                pSKU.unt_prc='0,0';
                pSKU.unt_prc_u='0,0';
                pSKU.fsp='0,0';
                pSKU.fsp_u='0,0';
                pSKU.kit_prod=skuRecord.SKU_Code__c;
            skuList.add(pSKU);

            String serlizePriceB = JSON.serialize(pBook);  
            String serlizeSkuList = JSON.serialize(skuList);

            List<NewBrazilPriceBookController.wrapperForSalesDistrict> lstOfWrapSalesDt = new  List<NewBrazilPriceBookController.wrapperForSalesDistrict>();
            NewBrazilPriceBookController.wrapperForSalesDistrict wrapObjForSalesDist = new NewBrazilPriceBookController.wrapperForSalesDistrict();
            NewBrazilPriceBookController.wrapperForSalesDistrict wrapObjForSalesDist1 = new NewBrazilPriceBookController.wrapperForSalesDistrict();
            wrapObjForSalesDist.Id = region.id;
            wrapObjForSalesDist.sdtId = region.id;
            wrapObjForSalesDist.Name = region.Name;
            wrapObjForSalesDist.SDCode = region.RegionCode__c;
            lstOfWrapSalesDt.add(wrapObjForSalesDist);
            
            wrapObjForSalesDist1.Id = region1.id;
            wrapObjForSalesDist1.sdtId = region1.id;
            wrapObjForSalesDist1.Name = region1.Name;
            wrapObjForSalesDist1.SDCode = region1.RegionCode__c;
            lstOfWrapSalesDt.add(wrapObjForSalesDist);

            String serlizeStr1 = JSON.serialize(lstOfWrapSalesDt);
        
           List<NewBrazilPriceBookController.PaymentTerms> lstOfPaymentTerms = new  List<NewBrazilPriceBookController.PaymentTerms>();
            NewBrazilPriceBookController.PaymentTerms wrapObjForPayterm = new NewBrazilPriceBookController.PaymentTerms();
            NewBrazilPriceBookController.PaymentTerms wrapObjForPayterm1 = new NewBrazilPriceBookController.PaymentTerms();
        
            wrapObjForPayterm.pt_id=payTerm.Id;
            wrapObjForPayterm.pt_type='day';
            wrapObjForPayterm1.pt_type='';
            wrapObjForPayterm1.pt_name=String.valueOf(System.today());
            lstOfPaymentTerms.add(wrapObjForPayterm);
            lstOfPaymentTerms.add(wrapObjForPayterm1);
        
            String serlizeStr2 = JSON.serialize(lstOfPaymentTerms);

            NewBrazilPriceBookController.getListViews();
            NewBrazilPriceBookController.loadMapValues();
           // NewBrazilPriceBookController.saveNewPriceBook(serlizePriceB, serlizeSkuList,serlizeStr1,serlizeStr2,'');
            //NewBrazilPriceBookController.saveAndSendForApprovalNewPriceBook(serlizePriceB, serlizeSkuList,serlizeStr1,serlizeStr2,'');
           // NewBrazilPriceBookController.cloneNewPriceBook(serlizePriceB, serlizeSkuList,serlizeStr1,serlizeStr2);
            NewBrazilPriceBookController.editNewPriceBook(priceBookObj.id);
            NewBrazilPriceBookController.submitForApproval(priceBookObj.id);

            NewBrazilPriceBookController.PriceBook pBook2 = new NewBrazilPriceBookController.PriceBook();
            pBook2.pcb_id=priceBookObj.id;
            pBook2.pb_for_Kit=true;
            pBook2.cmpgn_tp='Simple';
            pBook2.pb_name='Test Campaign';
            pBook2.curncy='Only USD';
            pBook2.frm_dt=String.valueOf(System.today());
            pBook2.exp_dt=String.valueOf(System.today());
            pBook2.intr_rt_R='0.0';
            pBook2.intr_rt_U='0.0';
            pBook2.intr_dt=String.valueOf(System.today());
            pBook2.division=div.Id;
            pBook2.blk_dt=String.valueOf(System.today());
            pBook2.las_mon=String.valueOf(System.today());
            pBook2.division_nm='';
           // pBook.pcb_id='';
            pBook2.isActive=true;
            pBook2.status='Draft';
            pBook2.usdRate='75.0';
            List<NewBrazilPriceBookController.ProductSku> skuList2 = new List<NewBrazilPriceBookController.ProductSku>();
            List<NewBrazilPriceBookController.ProductSku> skuList3 = new List<NewBrazilPriceBookController.ProductSku>();
            NewBrazilPriceBookController.ProductSku pSKU2 = new NewBrazilPriceBookController.ProductSku();
                pSKU2.cn=region.RegionCode__c;
                pSKU2.mt_code='';
                pSKU2.sku_code=skuRecord.SKU_Code__c;
                pSKU2.min_prc='0,0';
                pSKU2.min_prc_u='0,0';
                pSKU2.unt_prc='0,0';
                pSKU2.unt_prc_u='0,0';
                pSKU2.fsp='0,0';
                pSKU2.fsp_u='0,0';
               pSKU2.kit_prod=skuRecord.SKU_Code__c;
            skuList2.add(pSKU2);

            NewBrazilPriceBookController.ProductSku pSKU3 = new NewBrazilPriceBookController.ProductSku();
                pSKU3.pbd_id=pb_details.id;
                pSKU3.cn='';
                pSKU3.mt_code='';
                pSKU3.sku_code='';
                pSKU3.min_prc='0,0';
                pSKU3.min_prc_u='0,0';
                pSKU3.unt_prc='0,0';
                pSKU3.unt_prc_u='0,0';
                pSKU3.fsp='0,0';
                pSKU3.fsp_u='0,0';
                              pSKU3.kit_prod=skuRecord.SKU_Code__c;

            skuList3.add(pSKU3);

            String serlizePriceB2 = JSON.serialize(pBook2);  
            String serlizeSkuList2 = JSON.serialize(skuList2);
            String serlizeSkuList3 = JSON.serialize(skuList3);
        
            List<NewBrazilPriceBookController.PaymentTerms> lstOfPaymentTerms2 = new  List<NewBrazilPriceBookController.PaymentTerms>();
            List<NewBrazilPriceBookController.PaymentTerms> lstOfPaymentTerms3 = new  List<NewBrazilPriceBookController.PaymentTerms>();
            NewBrazilPriceBookController.PaymentTerms wrapObjForPayterm2 = new NewBrazilPriceBookController.PaymentTerms();
            NewBrazilPriceBookController.PaymentTerms wrapObjForPayterm3 = new NewBrazilPriceBookController.PaymentTerms();
            wrapObjForPayterm2.Id=cpt.id;
            wrapObjForPayterm2.pt_id=payTerm.Id;
            wrapObjForPayterm2.pt_name=String.valueOf(System.today());
            wrapObjForPayterm2.pt_type='day';
            lstOfPaymentTerms2.add(wrapObjForPayterm2);
            String serlizeStr3 = JSON.serialize(lstOfPaymentTerms2);
        
            wrapObjForPayterm3.Id=cpt.Id;
            lstOfPaymentTerms3.add(wrapObjForPayterm3);
            String serlizeStr4 = JSON.serialize(lstOfPaymentTerms3);
            List<NewBrazilPriceBookController.wrapperForCropCul> lstwrapForCropCul = new  List<NewBrazilPriceBookController.wrapperForCropCul>();
            NewBrazilPriceBookController.wrapperForCropCul wrapperForCropCul1 = new NewBrazilPriceBookController.wrapperForCropCul();
            NewBrazilPriceBookController.wrapperForCropCul wrapperForCropCul2 = new NewBrazilPriceBookController.wrapperForCropCul();
            //wrapperForCropCul2.Id = culture1.id;
            //wrapperForCropCul2.Id11 = culture1.id;
            wrapperForCropCul2.sdtId1 = culture1.id;
            wrapperForCropCul2.Name1 = culture1.Name;
            wrapperForCropCul2.SDCode1 =culture1.Culture_Code__c;
            lstwrapForCropCul.add(wrapperForCropCul2);
            String serlizeStr9 = JSON.serialize(lstwrapForCropCul);
            
            List<NewBrazilPriceBookController.wrapperForCustGroup> lstwrapperForCustGroup = new  List<NewBrazilPriceBookController.wrapperForCustGroup>();
            NewBrazilPriceBookController.wrapperForCustGroup wrapperForCustGroup1 = new NewBrazilPriceBookController.wrapperForCustGroup();
            NewBrazilPriceBookController.wrapperForCustGroup wrapperForCustGroup2 = new NewBrazilPriceBookController.wrapperForCustGroup();
            //wrapperForCropCul2.Id = culture1.id;
            //wrapperForCropCul2.Id11 = culture1.id;
            //wrapperForCustGroup1.sdtId2 = acc.id;
            //wrapperForCustGroup1.Name2 = acc.Name;
            wrapperForCustGroup1.SDCode2 ='001';
            lstwrapperForCustGroup.add(wrapperForCustGroup1);
            String serlizeStr8 = JSON.serialize(lstwrapperForCustGroup);
             list<string> culList= new list<string>();
            Culture__c c= new Culture__c();
            c.name='test culture';
            c.Culture_Code__c='B01';
            insert c;
            culList.add(c.id);
            
            List<NewBrazilPriceBookController.wrapperForCustName> lstwrapperForCustName = new  List<NewBrazilPriceBookController.wrapperForCustName>();
            NewBrazilPriceBookController.wrapperForCustName wrapperForCustName1 = new NewBrazilPriceBookController.wrapperForCustName();
            NewBrazilPriceBookController.wrapperForCustName wrapperForCustName2 = new NewBrazilPriceBookController.wrapperForCustName();
            //wrapperForCropCul2.Id = culture1.id;
            //wrapperForCropCul2.Id11 = culture1.id;
            wrapperForCustName1.id = acc.id;
            wrapperForCustName1.Name = acc.Name;
            wrapperForCustName1.PriceConversionGroup = acc.Name;
           // wrapperForCustName1.sapcode =acc.Culture_Code__c;
            lstwrapperForCustName.add(wrapperForCustName1);
            String serlizeStr7 = JSON.serialize(lstwrapperForCustName);

           NewBrazilPriceBookController.updateNewPriceBook(serlizePriceB2,serlizeSkuList2,serlizeSkuList3,serlizeStr3,serlizeStr4,serlizeStr1,serlizeStr9,serlizeStr8,serlizeStr7,culList); 
           NewBrazilPriceBookController.getMasterdata();
            NewBrazilPriceBookController.SKUValidation('[{"sku_code":"1132131","mt_code":"","min_prc":"1,00","min_prc_u":"1,00","unt_prc":"1,00","unt_prc_u":"1,00","fsp":"1,00","fsp_u":"1,00","pbd_id":""}]','[{"Id":"","sdtId":"a1B1y00000000fyEAA","sdtNameforSales":"","Name":"ALS","SDCode":"BR9901"}]');
        }
    }
static testMethod void testNameKitBRL() {
        
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
    //===================== Added by SKI Start Here===========
    //Instantiate the Pricebook2 record with StandardPricebookId
        Pricebook2 standardPricebook = new Pricebook2(
            Id = Test.getStandardPricebookId(),
            IsActive = true
        );
        
        //Execute an update DML on the Pricebook2 record, to make IsStandard to true
        Update standardPricebook;
    //==+================= Added by SKI End Here===========
        test.startTest();
        u = new User(Alias = 'standt', Email='standarduser@testorg.com',
                     EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                     LocaleSidKey='en_US', ProfileId = p.Id,
                     TimeZoneSidKey='America/Los_Angeles',
                     UserName=uniqueUserName);
        insert u;
        test.stopTest();
        Brazil_priceBook brzObj = new Brazil_priceBook(); 
        System.runAs ( u ) {
        div = new Division__c(
            Name = 'Agro Formulation',
            Division_Code__c = '10'
        );
        insert div;
        
        priceBookObj = new Price_Book__c(
            Name = 'LISTA ABRIL ZARTAN - REGIONAL TRIANGULO - PRAZO AGOSTO 2017',
            Division__c = div.id,                                           
            Currency__c = 'Only BRL',
            Valid_From__c = system.today(),
            Expiry_Date__c = system.today(),
            Interest_Rate_R__c = 1.1,
            Interest_Rate_U__c = 1.1,
            Interest_Date__c = system.today(),
            isActive__c = true,
            Status__c = 'Draft',
            Use_Campaign__c = true,
            Campaign_Type__c = 'Simple',
            Sales_Order_Block_Date__c =system.today(),
            Kit_Price_Book__c=true
        );
        insert priceBookObj;    //String.valueOf(System.today());
        
        sorg = new Sales_Org__c();
        sorg.Name='Brazil';
        sorg.Sales_Org_Code__c='5191';
        insert sorg;

         payTerm = new Payment_Term__c(
           // Name='Test',
            //SalesOrgCode__c='5191',
            Payment_Term_Code__c='PT01',
            Payterms_Desc__c='Test',
            Sales_Org__c=sorg.Id
             
        );
        insert payTerm;
        
        region = new Region__c();
        region.Name='MATO GROSSO DO SUL';
        region.RegionCode__c= 'BR1010';
        region.SalesOrg__c = sorg.Id;
        
        insert region;
        
        region1 = new Region__c();
        region1.Name='ARROZ';
        region1.RegionCode__c= 'BR2006';
        region1.SalesOrg__c = sorg.Id;
        
        insert region1;
        
            
            Culture__c culture1= new Culture__c();
            culture1.Name='Soja';
                culture1.Culture_Code__c='B26';
                culture1.Active__c=true;
            culture1.Sales_Org__c=sorg.Id;
                insert culture1;
        
            Account acc = new Account();
        acc.Name = 'LEONARDO PASSINATOC';
        acc.Email__c = 'ganesh03983@gmail.com';
        acc.Last_Name__c = 'PASSINATOC';
        acc.SAP_Code__c = '2028843';
        acc.Mobile__c = '9967341759';
        acc.Phone = '01234567891';
        acc.Sales_Org__c = sorg.Id;
        acc.BillingCity = 'MINEIROS';
        acc.SAP_Code__c = '2028843';
        acc.Tax_Number_3__c = '114415455';
        acc.Tax_Number_1__c = '114414523';
        acc.Customer_Region__c = 'AC';
        acc.Customer_Group__c = '001';
        acc.Program_Margin_Discount__c = 0.00;
        acc.Active__c = true;
        acc.Search_Terms_1__c = 'LEONARDO PASSINATO';
        acc.Search_Terms_2__c = 'FAZ SEUBAK';
        acc.Price_Conversion_Group__c = 'A';
        insert acc;
            
            
        skuRecord = new SKU__c(
            Name = 'TdsetRevorf',                                // SKU Name
            SKU_Code__c = '05250195',                      // SKU Code
            SKU_Description__c = 'MANZATE 800WP 25KG PAPER BAG_BR',  // SKU Description
            UOM__c = 'KG',
            Division__c = div.Id,                                    // Division
            Sales_Org__c = sorg.Id,                              // Sales Org
            Multiple_of__c = 25.00,                                  // Multiple Of
            Combination_Key__c = '519110000000000005250195',         // Combination Key
            Active__c = true,
            Kit_Product__c  =true                                       // Active
        );
        
        insert skuRecord;
        
        
        skuRec2= new SKU__c(
            Name = 'ikasd',                     // SKU Name
            SKU_Code__c = '5250198',             // SKU Code
            SKU_Description__c = 'JHGDU5UR',                // SKU Description
            UOM__c = 'KG',                                  // UOM
            Division__c = div.Id,                                    // Division
            Sales_Org__c = sorg.Id,                // Sales Org
            Multiple_of__c = 0.00,                          // Multiple Of
            Combination_Key__c = '5191000000000005250198',  // Combination Key
            Active__c = true                               // Active
        );
        insert skuRec2;

        NewBrazilPriceBookController newPricebook = new NewBrazilPriceBookController();

       Price_Book_Details__c pb_details = new Price_Book_Details__c(
            Price_Book__c = priceBookObj.id,
            Minimum_Price_R__c = 0.0,
            Minimum_Price_U__c = 0.0,
            Unit_Price_R__c = 0.0,
            Unit_Price_U__c = 0.0,
            Future_Sales_Price_R__c = 0.0,
            Future_Sales_Price_U__c = 0.0,
            SKU__c = skuRec2.id,
           Kit_SKU__c=skuRecord.Id,
            Sales_District1__c = region.id 
       );
       insert pb_details;
        date d=system.today();
        Campaign_Payment_Terms__c cpt = new Campaign_Payment_Terms__c(
        Price_Book_Brazil__c=priceBookObj.id,
        Payment_Term__c=payTerm.id    ,
            Payment_Term_in_Date__c=d
        );
        insert cpt;

     /*  ProcessInstance p_instance = new ProcessInstance(
           Status = 'Approved',
           TargetObjectId = priceBookObj.id,
           LastActorId = u.id
       );
        insert p_instance;

       ProcessInstanceStep stepInst = new ProcessInstanceStep(
           ProcessInstanceId = p_instance.id,
           Comments = 'Test'
       );
       insert stepInst;*/
Component__c cmp=new Component__c();
cmp.Component_SKU__c=skuRec2.Id;
cmp.kit_sku__c=skuRecord.Id;
cmp.Component_Item_Category__c='ZPAT5';
            cmp.Sales_Org__c=sorg.Id;
insert cmp;
        NewBrazilPriceBookController.getDefaultDivision();
        NewBrazilPriceBookController.getDivision();
        NewBrazilPriceBookController.getProfileID();
        NewBrazilPriceBookController.getSalesDistrict();
        NewBrazilPriceBookController.getPaymentTerms();
        NewBrazilPriceBookController.getSku(div.Id,false);
        NewBrazilPriceBookController.skuDescriptionMap();
        NewBrazilPriceBookController.setActiveDeactive(priceBookObj.id,'true');
NewBrazilPriceBookController.getComponent('000000000005250198');
        NewBrazilPriceBookController.PriceBook pBook = new NewBrazilPriceBookController.PriceBook();
            pBook.pb_for_Kit=true;
            //pBook.cmpgn_tp='Simple';
            pBook.pb_name='Test Campaign';
            pBook.curncy='Only BRL';
            pBook.frm_dt=String.valueOf(System.today());
            pBook.exp_dt=String.valueOf(System.today());
            pBook.intr_rt_R='0.0';
            pBook.intr_rt_U='0.0';
            pBook.intr_dt=String.valueOf(System.today());
            pBook.division=div.Id;
            pBook.blk_dt=String.valueOf(System.today());
            pBook.division_nm='';
           pBook.usdRate='75.0';
            pBook.isActive=true;
            pBook.status='Draft';

            List<NewBrazilPriceBookController.ProductSku> skuList = new List<NewBrazilPriceBookController.ProductSku>();
            NewBrazilPriceBookController.ProductSku pSKU = new NewBrazilPriceBookController.ProductSku();
                pSKU.cn=region.RegionCode__c;
                pSKU.mt_code='';
                pSKU.sku_code=skuRecord.SKU_Code__c;
                pSKU.min_prc='0,0';
                pSKU.min_prc_u='0,0';
                pSKU.unt_prc='0,0';
                pSKU.unt_prc_u='0,0';
                pSKU.fsp='0,0';
                pSKU.fsp_u='0,0';
               // pSKU.pbd_id='';
            skuList.add(pSKU);

            String serlizePriceB = JSON.serialize(pBook);  
            String serlizeSkuList = JSON.serialize(skuList);

            List<NewBrazilPriceBookController.wrapperForSalesDistrict> lstOfWrapSalesDt = new  List<NewBrazilPriceBookController.wrapperForSalesDistrict>();
            NewBrazilPriceBookController.wrapperForSalesDistrict wrapObjForSalesDist = new NewBrazilPriceBookController.wrapperForSalesDistrict();
            NewBrazilPriceBookController.wrapperForSalesDistrict wrapObjForSalesDist1 = new NewBrazilPriceBookController.wrapperForSalesDistrict();
            wrapObjForSalesDist.Id = region.id;
            wrapObjForSalesDist.sdtId = region.id;
            wrapObjForSalesDist.Name = region.Name;
            wrapObjForSalesDist.SDCode = region.RegionCode__c;
            lstOfWrapSalesDt.add(wrapObjForSalesDist);
            
            wrapObjForSalesDist1.Id = region1.id;
            wrapObjForSalesDist1.sdtId = region1.id;
            wrapObjForSalesDist1.Name = region1.Name;
            wrapObjForSalesDist1.SDCode = region1.RegionCode__c;
            lstOfWrapSalesDt.add(wrapObjForSalesDist);

            String serlizeStr1 = JSON.serialize(lstOfWrapSalesDt);
        
           List<NewBrazilPriceBookController.PaymentTerms> lstOfPaymentTerms = new  List<NewBrazilPriceBookController.PaymentTerms>();
            NewBrazilPriceBookController.PaymentTerms wrapObjForPayterm = new NewBrazilPriceBookController.PaymentTerms();
            NewBrazilPriceBookController.PaymentTerms wrapObjForPayterm1 = new NewBrazilPriceBookController.PaymentTerms();
        
            wrapObjForPayterm.pt_id=payTerm.Id;
            wrapObjForPayterm.pt_type='day';
            wrapObjForPayterm1.pt_type='';
            wrapObjForPayterm1.pt_name=String.valueOf(System.today());
            lstOfPaymentTerms.add(wrapObjForPayterm);
            lstOfPaymentTerms.add(wrapObjForPayterm1);
        
            String serlizeStr2 = JSON.serialize(lstOfPaymentTerms);

            NewBrazilPriceBookController.getListViews();
            NewBrazilPriceBookController.loadMapValues();
           // NewBrazilPriceBookController.saveNewPriceBook(serlizePriceB, serlizeSkuList,serlizeStr1,serlizeStr2,'');
            //NewBrazilPriceBookController.saveAndSendForApprovalNewPriceBook(serlizePriceB, serlizeSkuList,serlizeStr1,serlizeStr2,'');
           // NewBrazilPriceBookController.cloneNewPriceBook(serlizePriceB, serlizeSkuList,serlizeStr1,serlizeStr2);
            NewBrazilPriceBookController.editNewPriceBook(priceBookObj.id);
            NewBrazilPriceBookController.submitForApproval(priceBookObj.id);

            NewBrazilPriceBookController.PriceBook pBook2 = new NewBrazilPriceBookController.PriceBook();
            pBook2.pb_for_Kit=true;
            pBook2.pcb_id=priceBookObj.id;
            pBook2.pb_for_cmpgn=true;
            pBook2.cmpgn_tp='Simple';
            pBook2.pb_name='Test Campaign';
            pBook2.curncy='Only BRL';
            pBook2.frm_dt=String.valueOf(System.today());
            pBook2.exp_dt=String.valueOf(System.today());
            pBook2.intr_rt_R='0.0';
            pBook2.intr_rt_U='0.0';
            pBook2.intr_dt=String.valueOf(System.today());
            pBook2.division=div.Id;
            pBook2.blk_dt=String.valueOf(System.today());
            pBook2.las_mon=String.valueOf(System.today());
            pBook2.division_nm='';
           pBook2.usdRate='75.0';
            pBook2.isActive=true;
            pBook2.status='Draft';

            List<NewBrazilPriceBookController.ProductSku> skuList2 = new List<NewBrazilPriceBookController.ProductSku>();
            List<NewBrazilPriceBookController.ProductSku> skuList3 = new List<NewBrazilPriceBookController.ProductSku>();
            NewBrazilPriceBookController.ProductSku pSKU2 = new NewBrazilPriceBookController.ProductSku();
                pSKU2.cn=region.RegionCode__c;
                pSKU2.mt_code='';
                pSKU2.sku_code=skuRecord.SKU_Code__c;
                pSKU2.min_prc='0,0';
                pSKU2.min_prc_u='0,0';
                pSKU2.unt_prc='0,0';
                pSKU2.unt_prc_u='0,0';
                pSKU2.fsp='0,0';
                pSKU2.fsp_u='0,0';
            pBook2.usdRate='75.0';
               // pSKU.pbd_id='';
            skuList2.add(pSKU2);

            NewBrazilPriceBookController.ProductSku pSKU3 = new NewBrazilPriceBookController.ProductSku();
                pSKU3.pbd_id=pb_details.id;
                pSKU3.cn='';
                pSKU3.mt_code='';
                pSKU3.sku_code='';
                pSKU3.min_prc='0,0';
                pSKU3.min_prc_u='0,0';
                pSKU3.unt_prc='0,0';
                pSKU3.unt_prc_u='0,0';
                pSKU3.fsp='0,0';
                pSKU3.fsp_u='0,0';
               
            skuList3.add(pSKU3);

            String serlizePriceB2 = JSON.serialize(pBook2);  
            String serlizeSkuList2 = JSON.serialize(skuList2);
            String serlizeSkuList3 = JSON.serialize(skuList3);
        
            List<NewBrazilPriceBookController.PaymentTerms> lstOfPaymentTerms2 = new  List<NewBrazilPriceBookController.PaymentTerms>();
            List<NewBrazilPriceBookController.PaymentTerms> lstOfPaymentTerms3 = new  List<NewBrazilPriceBookController.PaymentTerms>();
            NewBrazilPriceBookController.PaymentTerms wrapObjForPayterm2 = new NewBrazilPriceBookController.PaymentTerms();
            NewBrazilPriceBookController.PaymentTerms wrapObjForPayterm3 = new NewBrazilPriceBookController.PaymentTerms();
            wrapObjForPayterm2.Id=cpt.id;
            wrapObjForPayterm2.pt_id=payTerm.Id;
            wrapObjForPayterm2.pt_name=String.valueOf(System.today());
            wrapObjForPayterm2.pt_type='day';
            lstOfPaymentTerms2.add(wrapObjForPayterm2);
            String serlizeStr3 = JSON.serialize(lstOfPaymentTerms2);
        
            wrapObjForPayterm3.Id=cpt.Id;
            lstOfPaymentTerms3.add(wrapObjForPayterm3);
            String serlizeStr4 = JSON.serialize(lstOfPaymentTerms3);
            List<NewBrazilPriceBookController.wrapperForCropCul> lstwrapForCropCul = new  List<NewBrazilPriceBookController.wrapperForCropCul>();
            NewBrazilPriceBookController.wrapperForCropCul wrapperForCropCul1 = new NewBrazilPriceBookController.wrapperForCropCul();
            NewBrazilPriceBookController.wrapperForCropCul wrapperForCropCul2 = new NewBrazilPriceBookController.wrapperForCropCul();
            //wrapperForCropCul2.Id = culture1.id;
            //wrapperForCropCul2.Id11 = culture1.id;
            wrapperForCropCul2.sdtId1 = culture1.id;
            wrapperForCropCul2.Name1 = culture1.Name;
            wrapperForCropCul2.SDCode1 =culture1.Culture_Code__c;
            lstwrapForCropCul.add(wrapperForCropCul2);
            String serlizeStr9 = JSON.serialize(lstwrapForCropCul);
            
            List<NewBrazilPriceBookController.wrapperForCustGroup> lstwrapperForCustGroup = new  List<NewBrazilPriceBookController.wrapperForCustGroup>();
            NewBrazilPriceBookController.wrapperForCustGroup wrapperForCustGroup1 = new NewBrazilPriceBookController.wrapperForCustGroup();
            NewBrazilPriceBookController.wrapperForCustGroup wrapperForCustGroup2 = new NewBrazilPriceBookController.wrapperForCustGroup();
            //wrapperForCropCul2.Id = culture1.id;
            //wrapperForCropCul2.Id11 = culture1.id;
            //wrapperForCustGroup1.sdtId2 = acc.id;
            //wrapperForCustGroup1.Name2 = acc.Name;
            wrapperForCustGroup1.SDCode2 ='001';
            lstwrapperForCustGroup.add(wrapperForCustGroup1);
            String serlizeStr8 = JSON.serialize(lstwrapperForCustGroup);
            
            
            List<NewBrazilPriceBookController.wrapperForCustName> lstwrapperForCustName = new  List<NewBrazilPriceBookController.wrapperForCustName>();
            NewBrazilPriceBookController.wrapperForCustName wrapperForCustName1 = new NewBrazilPriceBookController.wrapperForCustName();
            NewBrazilPriceBookController.wrapperForCustName wrapperForCustName2 = new NewBrazilPriceBookController.wrapperForCustName();
            //wrapperForCropCul2.Id = culture1.id;
            //wrapperForCropCul2.Id11 = culture1.id;
            wrapperForCustName1.id = acc.id;
            wrapperForCustName1.Name = acc.Name;
            wrapperForCustName1.PriceConversionGroup = acc.Name;
           // wrapperForCustName1.sapcode =acc.Culture_Code__c;
            lstwrapperForCustName.add(wrapperForCustName1);
            String serlizeStr7 = JSON.serialize(lstwrapperForCustName);
 list<string> culList= new list<string>();
            Culture__c c= new Culture__c();
            c.name='test culture';
            c.Culture_Code__c='B01';
            insert c;
            culList.add(c.id);
           NewBrazilPriceBookController.updateNewPriceBook(serlizePriceB2,serlizeSkuList2,serlizeSkuList3,serlizeStr3,serlizeStr4,serlizeStr1,serlizeStr9,serlizeStr8,serlizeStr7,cuLlist); 
           NewBrazilPriceBookController.getMasterdata();
            NewBrazilPriceBookController.SKUValidationKIT('[{"sku_code":"1132131","kit_prod":"1132131","mt_code":"","min_prc":"1,00","min_prc_u":"1,00","unt_prc":"1,00","unt_prc_u":"1,00","fsp":"1,00","fsp_u":"1,00","pbd_id":""}]','[{"Id":"","sdtId":"a1B1y00000000fyEAA","sdtNameforSales":"","Name":"ALS","SDCode":"BR9901"}]',true);
        }
    }

}