@isTest
public class StructuredCampaign_Test {

    private Static Price_Book__c priceBookObj;
    private Static Price_Book__c priceBookObj1;
    private Static Payment_Term__c payTerm;
    private Static Region__c region;
    private Static Region__c region1 ;
    
    static testMethod void testInsert()
    {
        
        User thisUser = [select Id from User where Id = :UserInfo.getUserId()];
        User userObj;
        
        
        System.runAs ( thisUser ) {
            UserRole ur = new UserRole(Name = 'Business Development Manager');
           // insert ur;
            userObj = new User(
                ProfileId = [SELECT Id FROM Profile WHERE Name = 'Territory Manager'].Id,
                
                LastName = 'last',
                Email = 'puser000@amamama.com',
                Username = 'puser000@amamama.com' + System.currentTimeMillis(),
                Country='India',
                CompanyName = 'TEST',
                Title = 'title',
                Alias = 'alias',
                TimeZoneSidKey = 'America/Los_Angeles',
                EmailEncodingKey = 'UTF-8',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US',
                isActive = true
                //UserRoleId =  ur.Id
            );  
            insert userObj;
            
            //data for sales org
            Sales_Org__c SalesOrgObj = new Sales_Org__c(
                Name = 'Brazil',             // Sales Org Name
                Company_Code__c = '5190',      // Company Code
                Sales_Org_Code__c = '5191',    // Sales Org Code
                Country_Code__c = 'BZ'        // Country Code
            );
            insert SalesOrgObj;
            
            //Data for SBU
            SBU__c SBUObj = new SBU__c(
                SBUUser__c = userObj.Id,      // SBU User
                SBUCode__c = 'BR6',                    // SBU Code
                SalesOrg__c = SalesOrgObj.Id,       // Sales Org
                Brazil_SBU_Name__c = 'Gestão Brasil'  // Brazil SBU Name
               
            );
            insert SBUObj;
            
            //Data For Zone
            Zone__c ZoneObj = new Zone__c(
                Name = 'BU MATO GROSSO',         // Zone Name
                SalesOrg__c = SalesOrgObj.Id,   // Sales Org
                ZoneCode__c = 'BR10',              // Zone Code
               // ZonalHead__c = '0050K000008lKq8',  // Zonal Head
                SBUCode__c = SBUObj.Id    // SBU
            );
            insert ZoneObj;
            
            //Data for Region
            Region__c RegionObj = new Region__c(
                Name = 'MATO GROSSO DO SUL',    // Region Name
                RegionCode__c = 'BR1012',         // Region Code
                SalesOrg__c = SalesOrgObj.Id,  // Sales Org
                SBU__c = SBUObj.Id,       // SBU
                Zone__c = ZoneObj.Id,      // Zone
                Neglected__c = false             // Neglected
            );
            insert RegionObj;
            
            region = new Region__c();
        	region.Name='MATO GROSSO DO SUL';
        	region.RegionCode__c= 'BR1010';
	        region.SalesOrg__c = SalesOrgObj.Id;
        
        	insert region;
        
        	region1 = new Region__c();
       		region1.Name='ARROZ';
        	region1.RegionCode__c= 'BR2006';
        	region1.SalesOrg__c = SalesOrgObj.Id;
        
        	insert region1;
        
            
            //data of Payment Term
            Payment_Term__c PaymentTermObj = new Payment_Term__c(
                Payment_Term_Code__c = '0001',                   // Payment Term Code
                Payterms_Desc__c = 'dentro de 7 dias s/desconto',  // Payterms Desc
                Maturity_Date_Mandatory__c = 'No',                 // Maturity Date Mandatory
                Days_to_calc_interest__c = 0,                    // Days (to calc interest)
                Sales_Org__c = SalesOrgObj.Id,                  // Sales Org
                CombinationKey__c = '51910001',                    // CombinationKey
                Active__c = true                                  // Active
            );
            insert PaymentTermObj;
            
            //data for Division
            Division__c DivisionObj = new Division__c(
                Name = 'Agro Formulation',// Division Name
                Division_Code__c = '10'    // Division Code
            );
            insert DivisionObj;
            
            priceBookObj = new Price_Book__c(
            Name = 'ST-2458',
            Division__c = DivisionObj.id,                                           
            Currency__c = 'BRL and USD',
            Valid_From__c = system.today(),
            Expiry_Date__c = system.today(),
            Interest_Rate_R__c = 1.1,
            Interest_Rate_U__c = 1.1,
            Interest_Date__c = system.today(),
            Product_Discount__c = 1.1,
            Optional_Simulator__c = true,
            isActive__c = true,
            Status__c = 'Draft',
            Use_Campaign__c = true,
            Campaign_Type__c = 'Structured',
            Sales_Order_Block_Date__c =system.today()
            
        	);
        	//insert priceBookObj;
            
            //data for SKU 
            SKU__c skuObj = new SKU__c(
                Name = 'Produto Teste',                       // SKU Name
                SKU_Code__c = '000000000006250199',             // SKU Code
                SKU_Description__c = 'Produto Teste',           // SKU Description
                UOM__c = 'L',                                   // UOM
                Division__c = DivisionObj.Id,                // Division
                Sales_Org__c = SalesOrgObj.Id,               // Sales Org
                Combination_Key__c = '5191000000000006250199',  // Combination Key
                Active__c = true,                               // Active
                Multiple_of__c = 0.00                        // Multiple Of
            );
            insert skuObj;
            
            Test.startTest();
            StructuredCampaign_Controller.getProfileID(); 
            StructuredCampaign_Controller.getSalesDistrict();
            StructuredCampaign_Controller.getPaymentTerm();
            //StructuredCampaign_Controller.getDefaultDivision();
            StructuredCampaign_Controller.getListViews();
            StructuredCampaign_Controller.skuDescriptionMap();
            
            // wrapper data for Price Book
            
            StructuredCampaign_Controller.PriceBook pBook = new StructuredCampaign_Controller.PriceBook();
            pBook.pb_for_cmpgn = true; //1
            pBook.cmpgn_tp='Structured';
            pBook.pb_name='15032019';
            
            pBook.frm_dt=String.valueOf(System.today());
            pBook.exp_dt=String.valueOf(System.today());
            pBook.intr_rt_R='7,6';
            pBook.intr_rt_U='6,7';
            pBook.intr_dt=String.valueOf(System.today());
            pBook.division='';
            pBook.blk_dt=String.valueOf(System.today());
            pBook.mgr_Discount='5,4';
            pBook.simulator_upload=false;
            pBook.division_nm='';
            //pBook.pcb_id=priceBookObj1.id;
            pBook.isActive = true;
            pBook.status='Draft'; //16
            
            String serlizePriceB = JSON.serialize(pBook);  
            
            List<StructuredCampaign_Controller.ProductSku> skuList = new List<StructuredCampaign_Controller.ProductSku>();
            StructuredCampaign_Controller.ProductSku skuWrap = new StructuredCampaign_Controller.ProductSku();
            skuWrap.cn=''; //1
            skuWrap.volume='3000';
            skuWrap.sku_code=skuObj.SKU_Code__c;
            skuWrap.sku_desc=skuObj.SKU_Description__c;
            skuWrap.unt_prc='4,6';
            skuWrap.unt_prc_u='4,3';
            skuWrap.min_prc='4,3';
            skuWrap.min_prc_u='4,3';       
            skuWrap.fsp_prc='4,3';       
            skuWrap.fsp_prc_u='4,3';       
            skuWrap.equivalence='2';
            skuWrap.multiplication_factor='1,2';
            skuWrap.grp='001';
            skuWrap.sub_grp='Orthene';
            skuWrap.anchor='Sim';
            skuWrap.subGrp_required=''; //15 csv
            skuWrap.pbd_id=''; //16
            
            skuList.add(skuWrap);
            String serlizeskuWrap = JSON.serialize(skuList);  
            
            List<StructuredCampaign_Controller.GroupWrapper> lstOfGroups = new  List<StructuredCampaign_Controller.GroupWrapper>();
            StructuredCampaign_Controller.GroupWrapper grpWrapObj = new StructuredCampaign_Controller.GroupWrapper();
            grpWrapObj.grp_name  = '001';
            grpWrapObj.grp_desc = '001'; 
            grpWrapObj.discount = '0'; 
            grpWrapObj.subgrp_required = 'Yes';
            grpWrapObj.subgrp_qty_required = '2';            
            //subgrp_qty = '';
            //grpWrapObj.pb_id=priceBookObj.id;
            grpWrapObj.dicount_given = false;
            grpWrapObj.limited_vol = 'true';
            
            lstOfGroups.add(grpWrapObj);
            String serlizegrpWrap = JSON.serialize(lstOfGroups);  
            
            List<StructuredCampaign_Controller.PaymentTerms> lstOfPaymentTerms = new  List<StructuredCampaign_Controller.PaymentTerms>();
            StructuredCampaign_Controller.PaymentTerms wrapObjForPayterm = new StructuredCampaign_Controller.PaymentTerms();
            StructuredCampaign_Controller.PaymentTerms wrapObjForPayterm1 = new StructuredCampaign_Controller.PaymentTerms();
        
        	wrapObjForPayterm.pt_id=PaymentTermObj.Id;
        	wrapObjForPayterm.pt_type='day';
        	wrapObjForPayterm1.pt_type='';
            wrapObjForPayterm1.pt_name=String.valueOf(System.today());
        	lstOfPaymentTerms.add(wrapObjForPayterm);
            lstOfPaymentTerms.add(wrapObjForPayterm1);
        
        	String serlizePaymentTerms = JSON.serialize(lstOfPaymentTerms);
            
            List<StructuredCampaign_Controller.wrapperForSalesDistrict> lstOfWrapSalesDt = new  List<StructuredCampaign_Controller.wrapperForSalesDistrict>();
            StructuredCampaign_Controller.wrapperForSalesDistrict wrapObjForSalesDist = new StructuredCampaign_Controller.wrapperForSalesDistrict();
            StructuredCampaign_Controller.wrapperForSalesDistrict wrapObjForSalesDist1 = new StructuredCampaign_Controller.wrapperForSalesDistrict();
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

            String serlizeSDWrap = JSON.serialize(lstOfWrapSalesDt);
            
            /*StructuredCampaign_Controller.PaymentTerms ptWrapObj = new StructuredCampaign_Controller.PaymentTerms();
             ptWrapObj.pt_id='';
             ptWrapObj.pt_name='';
             ptWrapObj.pt_date=String.valueOf(System.today());
             ptWrapObj.pBook='';
             ptWrapObj.pt_type='';
			*/
            
            StructuredCampaign_Controller.savePriceBook(serlizePriceB, serlizeskuWrap, serlizegrpWrap, serlizePaymentTerms, serlizeSDWrap);
            System.debug('PriceBook Count --> '+[SELECT Id, Name, Expiry_Date__c, Valid_From__c, isActive__c, Interest_Date__c,
                                                 Interest_Rate_R__c, Interest_Rate_U__c, Sales_Order_Block_Date__c, Use_Campaign__c,
                                                 Campaign_Type__c, Product_Discount__c, Optional_Simulator__c,
                                                 Status__c, Price_Book_Auto_Number__c, Campaign_Number__c
                                                 FROM Price_Book__c]);
            priceBookObj1 = [SELECT Id, Name, Expiry_Date__c, Valid_From__c, isActive__c, Interest_Date__c,
                                                 Interest_Rate_R__c, Interest_Rate_U__c, Sales_Order_Block_Date__c, Use_Campaign__c,
                                                 Campaign_Type__c, Product_Discount__c, Optional_Simulator__c,
                                                 Status__c, Price_Book_Auto_Number__c, Campaign_Number__c
                                                 FROM Price_Book__c LIMIT 1];
            
            pBook.pcb_id=priceBookObj1.id;
            serlizePriceB = JSON.serialize(pBook);
            
            System.debug('grpCount-->'+[SELECT Name,Campaign__c, Group_Description__c, Will_you_have_a_sub_product_group__c,
                       Name_of_the_group__c, Limited_volume__c, Do_not_generate_group_discount__c, Group_Discount__c, 
                       Required_sub_group_Qty__c
                       FROM Campaign_Group__c]);
            
            //system.debug('priceBookObj.id---> '+priceBookObj.id);
            StructuredCampaign_Controller.reloadPriceBook(priceBookObj1.id);
            List<Campaign_Payment_Terms__c> cptList = [SELECT Id,Name,Price_Book_Brazil__c,Payment_Term__c,Payment_Term_in_Date__c 
                                                      FROM Campaign_Payment_Terms__c LIMIT 1];
            
            List<StructuredCampaign_Controller.PaymentTerms> lstOfPaymentTermsDel = new  List<StructuredCampaign_Controller.PaymentTerms>();
            StructuredCampaign_Controller.PaymentTerms wrapObjForPaytermDel = new StructuredCampaign_Controller.PaymentTerms();
           
            wrapObjForPaytermDel.id=cptList[0].Id;
        	wrapObjForPaytermDel.pt_type='day';
            wrapObjForPaytermDel.pt_name=String.valueOf(System.today());
            lstOfPaymentTermsDel.add(wrapObjForPaytermDel);
            
            String serializePaytrmDel = JSON.serialize(lstOfPaymentTermsDel);
            
            StructuredCampaign_Controller.saveAndSubmitPriceBook(serlizePriceB, serlizeskuWrap, serlizegrpWrap, serlizePaymentTerms, serlizeSDWrap);
            StructuredCampaign_Controller.updatePriceBook(serlizePriceB, serlizeskuWrap, serlizegrpWrap, serlizePaymentTerms, serializePaytrmDel);            
            StructuredCampaign_Controller.submitForApproval(priceBookObj1.id);
            StructuredCampaign_Controller.reloadPriceBook(priceBookObj1.id);
            StructuredCampaign_Controller.setActiveDeactive(priceBookObj1.id, 'true');
            
            Test.stopTest();
            
        }
        
    }
}