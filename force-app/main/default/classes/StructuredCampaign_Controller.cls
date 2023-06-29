/*
* Name: StructuredCampaign_Controller
* Created On: 18 Feb 2019
* Author: Ketan Khatri (ketan.khatri@skinternational.com)
* Description: Controller Class for StructuredCampaign Lightning Component.
* Supporting Class: StructuredCampaign_Test (Test Class)
* Last Stable Back up : StructuredCampaign_Controller_V5.0  
* Comments : UAT Tested OK
*/

public  without sharing class StructuredCampaign_Controller {
    
    public static Map<String,String> skuMap;
    public static Map<String,String> districtMap;
    
    //Constructor
    public StructuredCampaign_Controller(){}
    
    @AuraEnabled
    public static String getProfileID(){
       
        List<Profile> PROFILE = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1]; 
        String MyProflieName = PROFILE[0].Name;
        return MyProflieName;
    }
   
    @AuraEnabled
    public static List<Region__c> getSalesDistrict() {
        
      return [SELECT Id, Name, RegionCode__c, 
              SalesOrg__c,Sales_Org_Code__c,
                Zone__c, RegionHead__c, 
                RegionHeadActive__c,CreatedDate 
                FROM Region__c
                where SalesOrg__r.Sales_Org_Code__c ='5191'
                ORDER BY createdDate ASC]; 
        
    }    

    @AuraEnabled
    public static List<Payment_Term__c> getPaymentTerm() {
        System.debug('getPaymentTerms call---------->');
        return [SELECT Id, SalesOrgCode__c, Active__c, Payterms_Desc__c FROM Payment_Term__c where 
               SalesOrgCode__c='5191' AND Active__c=true ORDER BY Payterms_Desc__c ASC];
    }
   
      
  /*  @AuraEnabled
    public static List<Division__c> getDivision() {
        System.debug('received Division call---------->');
        return [SELECT Id, Name ,Division_Code__c
                FROM Division__c 
                ORDER BY createdDate ASC];
    }

    @AuraEnabled
    public static List<Division__c> getDefaultDivision(){
      PriceBookWrapper pb_wrapper = new PriceBookWrapper();
       return  [SELECT Id, Name ,Division_Code__c
                FROM Division__c 
                where Name LIKE '%Agro Formulation%'
                ORDER BY createdDate ASC
                LIMIT 1];
    }    
	*/
    @AuraEnabled
    public static List<ListView> getListViews(){
        List<ListView> lstview = [SELECT Id, Name 
                                    FROM ListView 
                                    where (Name Like '%All%'
                                 	AND SobjectType = 'Price_Book__c')];
        // Perform isAccessible() check here
        return lstview;
    }
    
    @AuraEnabled
    public Static Map<String,String> skuDescriptionMap(){
        System.debug('skuDescriptionMap called---------->');
        List<SKU__c> skuList = new List<SKU__c>();
        Map<String,String> skuDesc = new Map<String,String>();
        skuList=[SELECT Id, SKU_Description__c, Combination_Key__c, Sales_Org_Code__c 
                 FROM SKU__c 
                 WHERE Sales_Org_Code__c='5191' AND Active__c=true];
        if(skuList.size()>0){
            for(SKU__c sk : skuList){
                skuDesc.put(sk.Combination_Key__c,sk.SKU_Description__c);
            }
        }
      System.debug('skuDescriptionMap ----------> '+skuDesc);
        return skuDesc;
    }

    @AuraEnabled
    public static String savePriceBook(String price_book, String sku_file, String groupList, String paymentTerms, String salesDistrictList) {
        System.debug('savePriceBook called Ketan---------->');
        System.debug('sku_file===> '+sku_file);
           
        System.debug('sku map ----------> '+ skuMap);        
        System.debug('price_book ----------> '+ price_book);
        System.debug('groupList ----------> '+ groupList);
        System.debug('paymentTerms ----------> '+ paymentTerms);
        System.debug('salesDistrictList ----------> '+ salesDistrictList);
        
        loadMapValues();

        System.debug('sku map after ----------> '+ skuMap);
        

       // PriceBook pb = new PriceBook();
        Price_Book__c priceBook =new Price_Book__c();
        Price_Book_Details__c pbd = new Price_Book_Details__c();
        List<Price_Book_Details__c> detailsList= new List<Price_Book_Details__c>();
        List<Price_Book_Sales_District__c> salesDistList = new List<Price_Book_Sales_District__c>();
        List<Campaign_Payment_Terms__c> paymentTermList = new List<Campaign_Payment_Terms__c>();
        List<Campaign_Group__c> campaignGrpList = new List<Campaign_Group__c>();
        
        String pb_id='';
        String preffix='ST-';
        String result='';
        Boolean flag=true;
        String[] skuArray; 

        try{

        if(price_book != null){
           // pb = (Price_Book__c) price_book;
           PriceBook pb= (PriceBook)JSON.deserialize(price_book, PriceBook.class);
            
            
            system.debug('@@@@@'+pb);
            system.debug('pb_for_cmpgn g =='+pb.pb_for_cmpgn);
          /*  if(pb.curncy == 'Only BRL'){
                preffix='BRL - ';
            }
            else if(pb.curncy == 'Only USD'){
                preffix='USD - ';
            }
            else{
                preffix='BOTH - ';
            }*/
           
            if(pb.pb_for_cmpgn == true){
               
                priceBook.Use_Campaign__c = true;
                priceBook.Campaign_Type__c = pb.cmpgn_tp;
                priceBook.Sales_Order_Block_Date__c = Date.valueof(pb.blk_dt);
                priceBook.Interest_Date__c = Date.valueof(pb.intr_dt);   
            } 
            else{
                priceBook.Use_Campaign__c = false;                
            }
            
            pb.intr_rt_R = pb.intr_rt_R.replace(',','.');
            pb.intr_rt_U = pb.intr_rt_U.replace(',','.');
            pb.mgr_discount = pb.mgr_discount.replace(',','.');
            
            priceBook.Name = preffix+pb.pb_name;
            //priceBook.Currency__c = pb.curncy;
            priceBook.Valid_From__c = Date.valueof(pb.frm_dt);
            priceBook.Expiry_Date__c = Date.valueof(pb.exp_dt);
            priceBook.Interest_Rate_R__c = Decimal.valueOf(pb.intr_rt_R);
            priceBook.Interest_Rate_U__c = Decimal.valueOf(pb.intr_rt_U);
            System.debug('Inside simulator_upload ->'+pb.simulator_upload);
            if(pb.simulator_upload==true){
             System.debug('Inside simulator_upload if ->'+pb.simulator_upload);
             priceBook.Optional_Simulator__c = true;   
            }
            else{
             priceBook.Optional_Simulator__c = false;    
            }
            system.debug('pb.mgr_discount-->'+pb.mgr_discount);
            if(pb.mgr_discount!=null && pb.mgr_discount!='' && string.isBlank(pb.mgr_discount)!=true){
                system.debug('inside pb.mgr_discount-->'+pb.mgr_discount);
            priceBook.Product_Discount__c = Decimal.valueOf(pb.mgr_discount);
            }
            //priceBook.Division__c = pb.division;
            priceBook.isActive__c = true;
            priceBook.Status__c = 'Draft';
            priceBook.CurrencyIsoCode='BRL';

            insert priceBook; 
            pb_id=priceBook.id;
            result='true';
            System.debug('Price book ID ----> ' +pb_id);
            System.debug('Price book ----> ' +priceBook);
        }
        System.debug('pb_id.length() ----> ' +pb_id.length());


        if(pb_id.length() != 0 || pb_id !='' || pb_id != null){

            if(sku_file != null){
                List<ProductSku> skuList = (List<ProductSku>)JSON.deserialize(sku_file, List<ProductSku>.class) ;
                 skuArray = new String[]{};
                if(skuList.size()>0){
                    for(ProductSku sku : skuList){
                        flag=true;
                        Price_Book_Details__c p_detail = new Price_Book_Details__c();
                        p_detail.Price_Book__c = pb_id;
						
                        sku.min_prc=sku.min_prc.replace(',','.');
                        sku.min_prc_u=sku.min_prc_u.replace(',','.');
                        sku.unt_prc=sku.unt_prc.replace(',','.');
                        sku.unt_prc_u=sku.unt_prc_u.replace(',','.');
                        sku.fsp_prc=sku.fsp_prc.replace(',','.');
                        sku.fsp_prc_u=sku.fsp_prc_u.replace(',','.');
                        sku.volume = sku.volume.replace(',','.');
                        sku.multiplication_factor = sku.multiplication_factor.replace(',','.');
                        sku.equivalence = sku.equivalence.replace(',','.');
                        //sku.fsp=sku.fsp.replace(',','.');
                        //sku.fsp_u=sku.fsp_u.replace(',','.');
                        
						//p_detail.Sales_District1__r = new Region__c(RegionCode__c = sku.cn);
                        p_detail.Minimum_Price_R__c = Decimal.valueOf(sku.min_prc);
                        p_detail.Minimum_Price_U__c = Decimal.valueOf(sku.min_prc_u);
                        p_detail.Unit_Price_R__c = Decimal.valueOf(sku.unt_prc);
                        p_detail.Unit_Price_U__c = Decimal.valueOf(sku.unt_prc_u);
                        p_detail.Future_Sales_Price_R__c = Decimal.valueOf(sku.fsp_prc);
                        p_detail.Future_Sales_Price_U__c = Decimal.valueOf(sku.fsp_prc_u);
                        
                        p_detail.Volume__c = Decimal.valueOf(sku.volume);
                        p_detail.Equivalence__c = Decimal.valueOf(sku.equivalence);
            			p_detail.Multiplication_Factor__c = Decimal.valueOf(sku.multiplication_factor);
            			p_detail.Group__c = sku.grp;
                        p_detail.Sub_Group__c = sku.sub_grp;
                        p_detail.Anchor__c = sku.anchor.toUpperCase();
            			p_detail.Sub_Group_Required__c = sku.subGrp_required.toUpperCase();
            
                        String combKey='';
                        //System.debug('sku code ----> ' +sku.sku_code);
                       //System.debug('sku length ----> ' +sku.sku_code.trim().length());
                            if(sku.sku_code.trim().length() == 6){
                                combKey='5191000000000000'+sku.sku_code;   // if length is 6 then added 12 zeros. 
                            }
                            else if(sku.sku_code.trim().length() == 7){
                                combKey='519100000000000'+sku.sku_code;    // if length is 7 then added 11 zeros.       
                            }
                            else {
                                combKey='5191'+sku.sku_code;    // if length is 18 then added sales org code only.       
                            }
                            //System.debug('SKU id---- '+ skuMap.get(combKey));

                        if(skuMap.containsKey(combKey)){
                            
                            //System.debug('SKU code---- '+ sku.sku_code);
                            
                            p_detail.SKU__c = skuMap.get(combKey);
                        }
                        else{
                            flag=false;
                        }
                        
                      /*  if(districtMap.containsKey(sku.cn)){
                            
                            p_detail.Sales_District1__c = districtMap.get(sku.cn);
                        }
                        else{
                            flag=false;
                        }*/

                        if(flag){
                         detailsList.add(p_detail);
                        }
                        else{
                            skuArray.add(sku.sku_code);
                        }
                    }
                }
            }

            
              if(salesDistrictList != null){
                List<wrapperForSalesDistrict> salesList = (List<wrapperForSalesDistrict>)JSON.deserialize(salesDistrictList, List<wrapperForSalesDistrict>.class);
                if(salesList.size()>0){
                            
                            System.debug('salesList-->'+salesList);
                            for(wrapperForSalesDistrict slds : salesList){
                                Price_Book_Sales_District__c obj = new Price_Book_Sales_District__c();
                                obj.Price_Book__c = pb_id;
                                obj.Sales_District1__c = slds.sdtId;
                                
                                salesDistList.add(obj);
                            }
                        }
            }
            
            if(paymentTerms != null){
                List<PaymentTerms> payList = (List<PaymentTerms>)JSON.deserialize(paymentTerms, List<PaymentTerms>.class);
                if(payList.size()>0){
                            
                            System.debug('payList-->'+payList);
                            for(PaymentTerms payTm : payList){
                                Campaign_Payment_Terms__c obj = new Campaign_Payment_Terms__c();
                                obj.Price_Book_Brazil__c = pb_id;
                                
                                if(payTm.pt_type=='day'){
                                    obj.Payment_Term__c = payTm.pt_id;
                                }
                                else{
                                    obj.Payment_Term_in_Date__c = Date.valueof(payTm.pt_name);
                                }
                                paymentTermList.add(obj);
                            }
                        }
            }
            System.debug('groupList-->'+groupList);
            if(groupList != null){
               List<GroupWrapper> grpWrapList = (List<GroupWrapper>)JSON.deserialize(groupList, List<GroupWrapper>.class);
                
                if(grpWrapList.size() > 0){
                    for(GroupWrapper grpWrapObj : grpWrapList){
                        System.debug('Step 1');
                        Campaign_Group__c cmpn_grp = new Campaign_Group__c();
                        System.debug('Step 2');
                        cmpn_grp.Campaign__c = pb_id;
                        System.debug('Step 4');
                        cmpn_grp.Name_of_the_group__c = grpWrapObj.grp_name;
                        System.debug('Step 5');
                        cmpn_grp.Group_Description__c =  grpWrapObj.grp_desc;
                        System.debug('Step 6');
                        //cmpn_grp.Group_Discount__c = decimal.valueOf(grpWrapObj.discount);
                        System.debug('Step 7');
                        //system.debug('Will_you_have_a_sub_product_group__c--> '+grpWrapObj.subgrp_required);
                        cmpn_grp.Will_you_have_a_sub_product_group__c = grpWrapObj.subgrp_required; 
                        System.debug('Step 8');
                        if(grpWrapObj.subgrp_required== 'Yes' && (decimal.valueOf(grpWrapObj.subgrp_qty_required)!=0 || decimal.valueOf(grpWrapObj.subgrp_qty_required)!=null) )
                        {
                            cmpn_grp.Required_sub_group_Qty__c = decimal.valueOf(grpWrapObj.subgrp_qty_required);
                        }
                        System.debug('Step 9');
                        
                        if(grpWrapObj.dicount_given == true){
                            cmpn_grp.Do_not_generate_group_discount__c = true;
                            
                        }
                        else{
                            cmpn_grp.Do_not_generate_group_discount__c = false;
                            if(grpWrapObj.discount!=null){     
                                grpWrapObj.discount=grpWrapObj.discount.replace(',','.');
                                cmpn_grp.Group_Discount__c = decimal.valueOf(grpWrapObj.discount);
                            }
                        }
                        
             			system.debug('grpWrapObj.limited_vol--> '+grpWrapObj.limited_vol);
                        if(grpWrapObj.limited_vol == 'Yes'){
                            cmpn_grp.Limited_volume__c = true;
                        }
                        else{ 
                            cmpn_grp.Limited_volume__c = false;
                        }                     
            
                        campaignGrpList.add(cmpn_grp);
                    }
                }
                
            }

                
        }
            
        if(salesDistList.size()>0){
           insert salesDistList;                
        }    
            
        if(campaignGrpList.size()>0){
            insert campaignGrpList;
        }    
            
        System.debug('SKU details List size---- '+ detailsList.size());
        System.debug('SKU details List ---- '+ detailsList);

        if(detailsList.size()>0){
            insert detailsList;
        }
     
        System.debug('paymentTermList  size---- '+ paymentTermList.size());
        System.debug('paymentTermList ---- '+ paymentTermList);

        if(paymentTermList.size()>0){
            insert paymentTermList;
        }    
        if(skuArray.size()>0){
            result = JSON.serialize(skuArray);
        } 
            
        } catch (Exception e) {
            System.debug('Exception while Adding Price Book'+ e +'at line number '+e.getLineNumber()+' Cause is '+ e.getCause());
            System.debug('@@@ Error message '+e.getMessage());
             System.debug('@@@ Error message '+e.getLineNumber());
            result='false';
            return result;
        }
        return result;
    
    }
    
     //to save and submit price book for approval
    @AuraEnabled
    public static String saveAndSubmitPriceBook(String price_book, String sku_file, String groupList, String paymentTerms, String salesDistrictList) {
        System.debug('saveAndSubmitPriceBook called ---------->');
        System.debug('sku_file===> '+sku_file);
           
        System.debug('sku map ----------> '+ skuMap);        
        System.debug('price_book ----------> '+ price_book);
        System.debug('groupList ----------> '+ groupList);
        System.debug('paymentTerms ----------> '+ paymentTerms);
        System.debug('salesDistrictList ----------> '+ salesDistrictList);
        
        loadMapValues();

        System.debug('sku map after ----------> '+ skuMap);
        

       // PriceBook pb = new PriceBook();
        Price_Book__c priceBook =new Price_Book__c();
        Price_Book_Details__c pbd = new Price_Book_Details__c();
        List<Price_Book_Details__c> detailsList= new List<Price_Book_Details__c>();
        List<Price_Book_Sales_District__c> salesDistList = new List<Price_Book_Sales_District__c>();
        List<Campaign_Payment_Terms__c> paymentTermList = new List<Campaign_Payment_Terms__c>();
        List<Campaign_Group__c> campaignGrpList = new List<Campaign_Group__c>();
        
        String pb_id='';
        String preffix='ST-';
        String result='';
        Boolean flag=true;
        String[] skuArray; 

        try{

        if(price_book != null){
           // pb = (Price_Book__c) price_book;
           PriceBook pb= (PriceBook)JSON.deserialize(price_book, PriceBook.class);
            
            
            system.debug('@@@@@'+pb);
            system.debug('pb_for_cmpgn g =='+pb.pb_for_cmpgn);
          /*  if(pb.curncy == 'Only BRL'){
                preffix='BRL - ';
            }
            else if(pb.curncy == 'Only USD'){
                preffix='USD - ';
            }
            else{
                preffix='BOTH - ';
            }*/
           
            if(pb.pb_for_cmpgn == true){
               
                priceBook.Use_Campaign__c = true;
                priceBook.Campaign_Type__c = pb.cmpgn_tp;
                priceBook.Sales_Order_Block_Date__c = Date.valueof(pb.blk_dt);
                priceBook.Interest_Date__c = Date.valueof(pb.intr_dt);   
            } 
            else{
                priceBook.Use_Campaign__c = false;                
            }
            
            pb.intr_rt_R = pb.intr_rt_R.replace(',','.');
            pb.intr_rt_U = pb.intr_rt_U.replace(',','.');
            pb.mgr_discount = pb.mgr_discount.replace(',','.');
            
            priceBook.Name = preffix+pb.pb_name;
            //priceBook.Currency__c = pb.curncy;
            priceBook.Valid_From__c = Date.valueof(pb.frm_dt);
            priceBook.Expiry_Date__c = Date.valueof(pb.exp_dt);
            priceBook.Interest_Rate_R__c = Decimal.valueOf(pb.intr_rt_R);
            priceBook.Interest_Rate_U__c = Decimal.valueOf(pb.intr_rt_U);
            System.debug('Inside simulator_upload ->'+pb.simulator_upload);
            if(pb.simulator_upload==true){
             System.debug('Inside simulator_upload if ->'+pb.simulator_upload);
             priceBook.Optional_Simulator__c = true;   
            }
            else{
             priceBook.Optional_Simulator__c = false;    
            }
            system.debug('pb.mgr_discount-->'+pb.mgr_discount);
            if(pb.mgr_discount!=null && pb.mgr_discount!='' && string.isBlank(pb.mgr_discount)!=true){
                system.debug('inside pb.mgr_discount-->'+pb.mgr_discount);
            priceBook.Product_Discount__c = Decimal.valueOf(pb.mgr_discount);
            }
            //priceBook.Division__c = pb.division;
            priceBook.isActive__c = true;
            priceBook.Status__c = 'Waiting Approval';
            priceBook.CurrencyIsoCode='BRL';

            insert priceBook; 
            pb_id=priceBook.id;
            result='true';
            System.debug('Price book ID ----> ' +pb_id);
            System.debug('Price book ----> ' +priceBook);
        }
        System.debug('pb_id.length() ----> ' +pb_id.length());


        if(pb_id.length() != 0 || pb_id !='' || pb_id != null){

            if(sku_file != null){
                List<ProductSku> skuList = (List<ProductSku>)JSON.deserialize(sku_file, List<ProductSku>.class) ;
                 skuArray = new String[]{};
                if(skuList.size()>0){
                    for(ProductSku sku : skuList){
                        flag=true;
                        Price_Book_Details__c p_detail = new Price_Book_Details__c();
                        p_detail.Price_Book__c = pb_id;
						
                        sku.min_prc=sku.min_prc.replace(',','.');
                        sku.min_prc_u=sku.min_prc_u.replace(',','.');
                        sku.unt_prc=sku.unt_prc.replace(',','.');
                        sku.unt_prc_u=sku.unt_prc_u.replace(',','.');
                        sku.fsp_prc=sku.fsp_prc.replace(',','.');
                        sku.fsp_prc_u=sku.fsp_prc_u.replace(',','.');
                        sku.volume = sku.volume.replace(',','.');
                        sku.multiplication_factor = sku.multiplication_factor.replace(',','.');
                        sku.equivalence = sku.equivalence.replace(',','.');
                        //sku.fsp=sku.fsp.replace(',','.');
                        //sku.fsp_u=sku.fsp_u.replace(',','.');
                        
						//p_detail.Sales_District1__r = new Region__c(RegionCode__c = sku.cn);
                        p_detail.Minimum_Price_R__c = Decimal.valueOf(sku.min_prc);
                        p_detail.Minimum_Price_U__c = Decimal.valueOf(sku.min_prc_u);
                        p_detail.Unit_Price_R__c = Decimal.valueOf(sku.unt_prc);
                        p_detail.Unit_Price_U__c = Decimal.valueOf(sku.unt_prc_u);
                        p_detail.Future_Sales_Price_R__c = Decimal.valueOf(sku.fsp_prc);
                        p_detail.Future_Sales_Price_U__c = Decimal.valueOf(sku.fsp_prc_u);
                        
                        p_detail.Volume__c = Decimal.valueOf(sku.volume);
                        p_detail.Equivalence__c = Decimal.valueOf(sku.equivalence);
            			p_detail.Multiplication_Factor__c = Decimal.valueOf(sku.multiplication_factor);
            			p_detail.Group__c = sku.grp;
                        p_detail.Sub_Group__c = sku.sub_grp;
                        p_detail.Anchor__c = sku.anchor.toUpperCase();
            			p_detail.Sub_Group_Required__c = sku.subGrp_required.toUpperCase();
            
                        String combKey='';
                        //System.debug('sku code ----> ' +sku.sku_code);
                       //System.debug('sku length ----> ' +sku.sku_code.trim().length());
                            if(sku.sku_code.trim().length() == 6){
                                combKey='5191000000000000'+sku.sku_code;   // if length is 6 then added 12 zeros. 
                            }
                            else if(sku.sku_code.trim().length() == 7){
                                combKey='519100000000000'+sku.sku_code;    // if length is 7 then added 11 zeros.       
                            }
                            else {
                                combKey='5191'+sku.sku_code;    // if length is 18 then added sales org code only.       
                            }
                            //System.debug('SKU id---- '+ skuMap.get(combKey));

                        if(skuMap.containsKey(combKey)){
                            
                            //System.debug('SKU code---- '+ sku.sku_code);
                            
                            p_detail.SKU__c = skuMap.get(combKey);
                        }
                        else{
                            flag=false;
                        }
                        
                      /*  if(districtMap.containsKey(sku.cn)){
                            
                            p_detail.Sales_District1__c = districtMap.get(sku.cn);
                        }
                        else{
                            flag=false;
                        }*/

                        if(flag){
                         detailsList.add(p_detail);
                        }
                        else{
                            skuArray.add(sku.sku_code);
                        }
                    }
                }
            }

            
              if(salesDistrictList != null){
                List<wrapperForSalesDistrict> salesList = (List<wrapperForSalesDistrict>)JSON.deserialize(salesDistrictList, List<wrapperForSalesDistrict>.class);
                if(salesList.size()>0){
                            
                            System.debug('salesList-->'+salesList);
                            for(wrapperForSalesDistrict slds : salesList){
                                Price_Book_Sales_District__c obj = new Price_Book_Sales_District__c();
                                obj.Price_Book__c = pb_id;
                                obj.Sales_District1__c = slds.sdtId;
                                
                                salesDistList.add(obj);
                            }
                        }
            }
            
            if(paymentTerms != null){
                List<PaymentTerms> payList = (List<PaymentTerms>)JSON.deserialize(paymentTerms, List<PaymentTerms>.class);
                if(payList.size()>0){
                            
                            System.debug('payList-->'+payList);
                            for(PaymentTerms payTm : payList){
                                Campaign_Payment_Terms__c obj = new Campaign_Payment_Terms__c();
                                obj.Price_Book_Brazil__c = pb_id;
                                
                                if(payTm.pt_type=='day'){
                                    obj.Payment_Term__c = payTm.pt_id;
                                }
                                else{
                                    obj.Payment_Term_in_Date__c = Date.valueof(payTm.pt_name);
                                }
                                paymentTermList.add(obj);
                            }
                        }
            }
            System.debug('groupList-->'+groupList);
            if(groupList != null){
               List<GroupWrapper> grpWrapList = (List<GroupWrapper>)JSON.deserialize(groupList, List<GroupWrapper>.class);
                
                if(grpWrapList.size() > 0){
                    for(GroupWrapper grpWrapObj : grpWrapList){
                        System.debug('Step 1');
                        Campaign_Group__c cmpn_grp = new Campaign_Group__c();
                        System.debug('Step 2');
                        cmpn_grp.Campaign__c = pb_id;
                        System.debug('Step 4');
                        cmpn_grp.Name_of_the_group__c = grpWrapObj.grp_name;
                        System.debug('Step 5');
                        cmpn_grp.Group_Description__c =  grpWrapObj.grp_desc;
                        System.debug('Step 6');
                        //cmpn_grp.Group_Discount__c = decimal.valueOf(grpWrapObj.discount);
                        System.debug('Step 7');
                        //system.debug('Will_you_have_a_sub_product_group__c--> '+grpWrapObj.subgrp_required);
                        cmpn_grp.Will_you_have_a_sub_product_group__c = grpWrapObj.subgrp_required; 
                        System.debug('Step 8');
                        if(grpWrapObj.subgrp_required== 'Yes' && (decimal.valueOf(grpWrapObj.subgrp_qty_required)!=0 || decimal.valueOf(grpWrapObj.subgrp_qty_required)!=null) )
                        {
                            cmpn_grp.Required_sub_group_Qty__c = decimal.valueOf(grpWrapObj.subgrp_qty_required);
                        }
                        System.debug('Step 9');
                        
                        if(grpWrapObj.dicount_given == true){
                            cmpn_grp.Do_not_generate_group_discount__c = true;
                            
                        }
                        else{
                            cmpn_grp.Do_not_generate_group_discount__c = false;
                            if(grpWrapObj.discount!=null){     
                                grpWrapObj.discount=grpWrapObj.discount.replace(',','.');
                                cmpn_grp.Group_Discount__c = decimal.valueOf(grpWrapObj.discount);
                            }
                        }
                        
             			system.debug('grpWrapObj.limited_vol--> '+grpWrapObj.limited_vol);
                        if(grpWrapObj.limited_vol == 'Yes'){
                            cmpn_grp.Limited_volume__c = true;
                        }
                        else{ 
                            cmpn_grp.Limited_volume__c = false;
                        }                     
            
                        campaignGrpList.add(cmpn_grp);
                    }
                }
                
            }

                
        }
            
        if(salesDistList.size()>0){
           insert salesDistList;                
        }    
            
        if(campaignGrpList.size()>0){
            insert campaignGrpList;
        }    
            
        System.debug('SKU details List size---- '+ detailsList.size());
        System.debug('SKU details List ---- '+ detailsList);

        if(detailsList.size()>0){
            insert detailsList;
        }
     
        System.debug('paymentTermList  size---- '+ paymentTermList.size());
        System.debug('paymentTermList ---- '+ paymentTermList);

        if(paymentTermList.size()>0){
            insert paymentTermList;
        }     
        if(skuArray.size()>0){
            result = JSON.serialize(skuArray);
        } 
        
        if(pb_id.length() != 0 || pb_id !='' || pb_id != null) {
            
            Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
            req1.setObjectId(pb_id);

            Approval.ProcessResult approvalResult = Approval.process(req1);
     
        }   
            
        } catch (Exception e) {
            System.debug('Exception while Adding Price Book'+ e +'at line number '+e.getLineNumber()+' Cause is '+ e.getCause());
            System.debug('@@@ Error message '+e.getMessage());
             System.debug('@@@ Error message '+e.getLineNumber());
            result='false';
            return result;
        }
        return result;
    
    }
    
    
    @AuraEnabled
    public static String submitForApproval(String priceBookId) { 
        System.debug('submitForApproval calle...');
        System.debug('price_book id ... '+priceBookId);
        try{
            Price_Book__c priceBook =new Price_Book__c();
            priceBook.Id=priceBookId;
            priceBook.Status__c = 'Waiting Approval';

            update priceBook;

            Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
            req1.setObjectId(priceBook.Id);

            Approval.ProcessResult result = Approval.process(req1);

        }
        catch(DmlException e){
          System.debug('Exception occured ... '+e);  
            return 'Error';
        }
        return 'Success';
        
    }
    
   @AuraEnabled
    public static PriceBookWrapper reloadPriceBook(String price_bookId) {
        System.debug('editNewPriceBook called---------->');
        System.debug('price_bookId ----------> '+ price_bookId);
       
        PriceBookWrapper pb_wrapper = new PriceBookWrapper();
        try {
        if(price_bookId.length()>0){
            Price_Book__c pb = new Price_Book__c();
            pb =[SELECT Id, Name, Currency__c, Division__c,Division__r.Name, Expiry_Date__c, Valid_From__c, isActive__c, 
                                 Interest_Date__c, Interest_Rate_R__c, Interest_Rate_U__c, Sales_Order_Block_Date__c, Use_Campaign__c, 
                                 Status__c, Campaign_Type__c,Product_Discount__c,Optional_Simulator__c
                 FROM Price_Book__c 
                 WHERE id=:price_bookId];
            
               // Date conversion....to string
                DateTime val_dt = pb.Valid_From__c;
            	DateTime exp_dt = pb.Expiry_Date__c;
                
            
            	pb_wrapper.pc_book.pcb_id = pb.Id;
                pb_wrapper.pc_book.pb_for_cmpgn = pb.Use_Campaign__c;
                pb_wrapper.pc_book.cmpgn_tp = pb.Campaign_Type__c;
                pb_wrapper.pc_book.pb_name = (pb.Name).replace('ST-','');
            	//pb_wrapper.pc_book.curncy = pb.Currency__c;
                pb_wrapper.pc_book.frm_dt = String.valueOf(pb.Valid_From__c);//val_dt.format('dd MMM, yyyy');
                pb_wrapper.pc_book.exp_dt = String.valueOf(pb.Expiry_Date__c);//exp_dt.format('dd MMM, yyyy');
                pb_wrapper.pc_book.intr_rt_R = String.valueOf(pb.Interest_Rate_R__c).replace('.',',');
                pb_wrapper.pc_book.intr_rt_U = String.valueOf(pb.Interest_Rate_U__c).replace('.',',');
            if(pb.Product_Discount__c != null){
                           	pb_wrapper.pc_book.mgr_Discount = String.valueOf(pb.Product_Discount__c).replace('.',','); 
            }
            	//pb_wrapper.pc_book.mgr_Discount = String.valueOf(pb.Product_Discount__c).replace('.',',');
                pb_wrapper.pc_book.simulator_upload = pb.Optional_Simulator__c;
                //pb_wrapper.pc_book.division = pb.Division__c;
                //pb_wrapper.pc_book.division_nm = pb.Division__r.Name;
            	pb_wrapper.pc_book.isActive = pb.isActive__c;
                pb_wrapper.pc_book.status = pb.Status__c;
            
                if(pb.Sales_Order_Block_Date__c !=null){
                    DateTime blk_dt = pb.Sales_Order_Block_Date__c;
                	pb_wrapper.pc_book.blk_dt = blk_dt.format('dd MMM, yyyy');
                }

                if(pb.Interest_Date__c != null){
                    DateTime inr_dt = pb.Interest_Date__c;
                    pb_wrapper.pc_book.intr_dt = inr_dt.format('dd MMM, yyyy');
                }
            
               System.debug('price book ----------> '+ pb_wrapper.pc_book);
            /******* Populate Campaign Group Start **********/
            List<Campaign_Group__c> cmpnGrpList = new List<Campaign_Group__c>();
            cmpnGrpList = [SELECT Id,Name,Campaign__c, Group_Description__c, Will_you_have_a_sub_product_group__c,
                       Name_of_the_group__c, Limited_volume__c, Do_not_generate_group_discount__c, Group_Discount__c, 
                       Required_sub_group_Qty__c
                       FROM Campaign_Group__c
                       WHERE Campaign__c=:price_bookId ];
            
            if(cmpnGrpList.size()>0){
                for(Campaign_Group__c cmpnGrp : cmpnGrpList){
                    GroupWrapper grpWrapObj = new GroupWrapper();
                    
                   grpWrapObj.pb_id = cmpnGrp.Campaign__c ;
                   grpWrapObj.grp_id = cmpnGrp.Id ;
                   grpWrapObj.grp_name = cmpnGrp.Name_of_the_group__c ;
                   grpWrapObj.grp_desc = cmpnGrp.Group_Description__c ;
                   grpWrapObj.discount = String.valueOf(cmpnGrp.Group_Discount__c) ;
                   grpWrapObj.subgrp_qty_required = String.valueOf(cmpnGrp.Required_sub_group_Qty__c) ;
                   grpWrapObj.subgrp_required = String.valueOf(cmpnGrp.Will_you_have_a_sub_product_group__c);        
                   //grpWrapObj.limited_vol = String.valueOf(cmpnGrp.Limited_volume__c);
                    if(cmpnGrp.Limited_volume__c==true){
                        grpWrapObj.limited_vol = 'Yes';
                    }
                    else{
                        grpWrapObj.limited_vol = 'No';
                    }
                       
                   grpWrapObj.dicount_given = cmpnGrp.Do_not_generate_group_discount__c ;
                    
                   pb_wrapper.groupList.add(grpWrapObj);
                }
            }
            
            /******* Populate Campaign Group End **********/	
            
            	List<Price_Book_Details__c> pbList = new List<Price_Book_Details__c>();
            	pbList=[SELECT Id, Name, Price_Book__c, SKU__c, SKU__r.SKU_Code__c, Sku__r.SKU_Description__c,Volume__c,  
                       Minimum_Price_R__c, Minimum_Price_U__c, Unit_Price_R__c, Unit_Price_U__c,Equivalence__c ,
                       Multiplication_Factor__c,Group__c,Sub_Group__c,Anchor__c,Sub_Group_Required__c,
                        Sales_District1__c, Sales_District1__r.RegionCode__c, Future_Sales_Price_R__c,
                        Future_Sales_Price_U__c
                        FROM Price_Book_Details__c
                        WHERE Price_Book__c=:price_bookId];   //Sales_District1__c, Sales_District1__r.RegionCode__c,
            
                if(pbList.size()>0){
                    for(Price_Book_Details__c pbd : pbList){
                        ProductSku sku= new ProductSku();
                        sku.pbd_id=pbd.Id;
                     //   sku.cn = pbd.Sales_District1__r.RegionCode__c;
                     //   sku.mt_code = pbd.SKU__r.Name.replace(',','').replace('\'','');
                       // sku.cn = pbd.Sales_District1__r.RegionCode__c;
                        sku.sku_code = pbd.SKU__r.SKU_Code__c;
                        sku.sku_desc = pbd.Sku__r.SKU_Description__c;
                        sku.volume = String.valueOf(pbd.Volume__c).replace('.',',');                        
                        sku.min_prc = String.valueOf(pbd.Minimum_Price_R__c).replace('.',',');
                        sku.min_prc_u = String.valueOf(pbd.Minimum_Price_U__c).replace('.',',');
                        sku.unt_prc = String.valueOf(pbd.Unit_Price_R__c).replace('.',',');
                        sku.unt_prc_u = String.valueOf(pbd.Unit_Price_U__c).replace('.',',');
                        sku.fsp_prc = String.valueOf(pbd.Future_Sales_Price_R__c).replace('.',',');
                        sku.fsp_prc_u = String.valueOf(pbd.Future_Sales_Price_U__c).replace('.',',');
                        sku.equivalence = String.valueOf(pbd.Equivalence__c).replace('.',',');
                        sku.multiplication_factor = String.valueOf(pbd.Multiplication_Factor__c).replace('.',',');
                        sku.grp = pbd.Group__c;
                        sku.sub_grp = pbd.Sub_Group__c;
                        sku.anchor = pbd.Anchor__c;
                        sku.subGrp_required = pbd.Sub_Group_Required__c;
                        //sku.fsp= String.valueOf(pbd.Future_Sales_Price_R__c).replace('.',',');
                        //sku.fsp_u= String.valueOf(pbd.Future_Sales_Price_U__c).replace('.',',');
                        
                        pb_wrapper.materialList.add(sku);
                    }
                }

                List<Price_Book_Sales_District__c> salesList = new List<Price_Book_Sales_District__c>();
                salesList=[SELECT id,Name,Price_Book__c,Sales_District1__c,Sales_District1__r.Name,Sales_District_Name1__c,
                           Sales_District_Code__c FROM Price_Book_Sales_District__c where Price_Book__c=:price_bookId ];
                if(salesList.size()>0){
                  for(Price_Book_Sales_District__c pbsd : salesList){
                    wrapperForSalesDistrict wsd = new wrapperForSalesDistrict();
                    wsd.Id=pbsd.Id;
                    wsd.sdtId=pbsd.Sales_District1__c;
                    wsd.Name=pbsd.Sales_District_Name1__c;
                    wsd.SDCode=pbsd.Sales_District_Code__c;

                    pb_wrapper.salesDistricts.add(wsd);
                  }
                }
                
                List<ProcessInstanceStep> pisList =new List<ProcessInstanceStep>();
                pisList=[SELECT Id, ProcessInstanceId, StepStatus, OriginalActorId, ActorId,Actor.Name, Actor.email, 
                        Comments, ProcessInstance.LastModifiedDate, SystemModstamp FROM ProcessInstanceStep 
                        where ProcessInstance.TargetObjectId=:price_bookId order by SystemModstamp  desc];

                if(!pisList.isEmpty()){
                    for(ProcessInstanceStep pis : pisList){
                        ApprovalHistory ah = new ApprovalHistory();
                        DateTime ap_dt = pis.SystemModstamp;

                        ah.date_tm = ap_dt.format('dd MMM, yyyy');
                        ah.user = pis.Actor.email;
                        ah.name=pis.Actor.Name;
                        if(pis.StepStatus == 'Started'){
                           ah.cur_status = 'Submitted'; 
                        }
                        else{
                          ah.cur_status = pis.StepStatus;
                        }
                        ah.prev_status = '';
                        ah.comment = pis.Comments;

                        pb_wrapper.approvarList.add(ah);
                    }
                } 
            
                List<Campaign_Payment_Terms__c> payTermList = new List<Campaign_Payment_Terms__c>();
                payTermList=[SELECT id, Price_Book_Brazil__c, Payment_Term__c,Payment_Term__r.Payterms_Desc__c, 
                         Payment_Term_in_Date__c 
                         FROM Campaign_Payment_Terms__c
                         WHERE Price_Book_Brazil__c=:price_bookId];
            
            
               if(payTermList.size()>0){
                   for(Campaign_Payment_Terms__c payTm : payTermList){
                       PaymentTerms pt = new PaymentTerms();
                         pt.id=payTm.id;
                         pt.pBook=payTm.Price_Book_Brazil__c;
                       
                           if(payTm.Payment_Term__c != null){
                             pt.pt_id=payTm.Payment_Term__c;
                             pt.pt_name=payTm.Payment_Term__r.Payterms_Desc__c;
                             pt.pt_type='day';
                           }
                           else{
                            // DateTime ap_dt = payTm.Payment_Term_in_Date__c;
                            // pt.pt_name = ap_dt.format('dd MMM, yyyy');  
                             pt.pt_name = String.valueof(payTm.Payment_Term_in_Date__c);
                             pt.pt_type ='date';  
                           }
                         
                       pb_wrapper.paymentTerms.add(pt); 
                   }
               }
            
           
                
        }
        else{
                pb_wrapper.materialList=null;
            	pb_wrapper.pc_book=null;
                pb_wrapper.approvarList=null;
                pb_wrapper.salesDistricts=null;
           		pb_wrapper.paymentTerms=null;
        }
    } catch (Exception e) {
           System.debug('Exception while retrieving Price Book (edit Method) '+ e +' at line number '+e.getLineNumber());
                pb_wrapper.materialList=null;
            	pb_wrapper.pc_book=null;
                pb_wrapper.approvarList=null;
                pb_wrapper.salesDistricts=null;
        		pb_wrapper.paymentTerms=null;
           return pb_wrapper;
    }
        
        return pb_wrapper;
    }
    
    
    @AuraEnabled
    public static String updatePriceBook(String price_book, String sku_file, String groupList, String paymentTerms, String payObjsDelete) {
        System.debug('updateNewPriceBook called---------->');
        System.debug('sku map ----------> '+ skuMap);
        System.debug('paymentTerms ----------> '+ paymentTerms);
        System.debug('payObjsDelete ----------> '+ payObjsDelete);
        System.debug('price_book ----------> '+ price_book);
        
        loadMapValues();

        //System.debug('sku map after ----------> '+ skuMap);
        //System.debug('Dist map after ----------> '+ districtMap);

        Price_Book__c priceBook =new Price_Book__c();
        Price_Book_Details__c pbd = new Price_Book_Details__c();
        List<Price_Book__c> priceBookList = new List<Price_Book__c>();
        List<Price_Book_Details__c> detailsList= new List<Price_Book_Details__c>();
        //List<Price_Book_Sales_District__c> salesDistList = new List<Price_Book_Sales_District__c>();
        List<Campaign_Payment_Terms__c> paymentTermListDelete = new List<Campaign_Payment_Terms__c>();
        List<Campaign_Payment_Terms__c> paymentTermList = new List<Campaign_Payment_Terms__c>();
        List<Campaign_Group__c> campaignGrpList = new List<Campaign_Group__c>();
        
        String pb_id='';
        String preffix='ST-';
        String result='';
        Boolean flag=true;

     try {
           
        if(price_book != null){
            System.debug('price_book size '+price_book);
            
           // pb = (Price_Book__c) price_book;
           PriceBook pb= (PriceBook)JSON.deserialize(price_book, PriceBook.class);
            
           /* if(pb.curncy == 'Only BRL'){
                preffix='BRL - ';
            }
            else if(pb.curncy == 'Only USD'){
                preffix='USD - ';
            }
            else{
                preffix='BOTH - ';
            }*/

            if(pb.pb_for_cmpgn == true){
                priceBook.Use_Campaign__c = true;
                priceBook.Campaign_Type__c = pb.cmpgn_tp;
                priceBook.Sales_Order_Block_Date__c = Date.valueof(pb.blk_dt);
                priceBook.Interest_Date__c = Date.valueof(pb.intr_dt);   
            } 
            else{
                priceBook.Use_Campaign__c = false;
            }
            
            pb.intr_rt_R = pb.intr_rt_R.replace(',','.');
            pb.intr_rt_U = pb.intr_rt_U.replace(',','.');
            pb.mgr_discount = pb.mgr_discount.replace(',','.');
                        
            priceBook.Id=pb.pcb_id;
            priceBook.Name = 'ST-'+pb.pb_name;
            //priceBook.Currency__c = pb.curncy;
            priceBook.Valid_From__c = Date.valueof(pb.frm_dt);
            priceBook.Expiry_Date__c = Date.valueof(pb.exp_dt);
            priceBook.Interest_Rate_R__c = decimal.valueOf(pb.intr_rt_R);
            priceBook.Interest_Rate_U__c = decimal.valueOf(pb.intr_rt_U);
            //priceBook.Division__c = pb.division;
            priceBook.Status__c = 'Draft';
            if(pb.simulator_upload==true){
             System.debug('Inside simulator_upload if ->'+pb.simulator_upload);
             priceBook.Optional_Simulator__c = true;   
            }
            else if(pb.simulator_upload==false){
             System.debug('Inside simulator_upload else ->'+pb.simulator_upload);
             priceBook.Optional_Simulator__c = false;    
            }
            //priceBook.Product_Discount__c = Decimal.valueOf(pb.mgr_discount);
            system.debug('pb.mgr_discount-->'+pb.mgr_discount);
            if(pb.mgr_discount!=null && pb.mgr_discount!='' && string.isBlank(pb.mgr_discount)!=true){
                system.debug('inside pb.mgr_discount-->'+pb.mgr_discount);
            priceBook.Product_Discount__c = Decimal.valueOf(pb.mgr_discount);
            }
          //priceBook.isActive__c = pb.isActive;

            update priceBook; 
            pb_id=priceBook.id;
            result='true';
            System.debug('Price book ID ----> ' +pb_id);
            System.debug('Price book ----> ' +priceBook);
        }
        System.debug('pb_id.length() ----> ' +pb_id.length());
        System.debug('sku_file ----> ' +sku_file);
        System.debug('sku_file size----> ' +sku_file);

        if(sku_file.length() == 4){
            sku_file = null;
        }

       /* if(sku_fileToDelete.length() == 4){
            sku_fileToDelete = null;
        }*/

        if(pb_id.length() != 0 || pb_id !='' || pb_id != null){

            if(sku_file != null){
                List<ProductSku> skuList = (List<ProductSku>)JSON.deserialize(sku_file, List<ProductSku>.class) ;
                if(skuList.size()>0){
                    for(ProductSku sku : skuList){
                        flag=true;
                        Price_Book_Details__c p_detail = new Price_Book_Details__c();
                       // p_detail.Id = sku.pbd_id; 
                        p_detail.Price_Book__c = pb_id;

                        sku.min_prc=sku.min_prc.replace(',','.');
                        sku.min_prc_u=sku.min_prc_u.replace(',','.');
                        sku.unt_prc=sku.unt_prc.replace(',','.');
                        sku.unt_prc_u=sku.unt_prc_u.replace(',','.');
                        sku.fsp_prc=sku.fsp_prc.replace(',','.');
                        sku.fsp_prc_u=sku.fsp_prc_u.replace(',','.');
                        sku.volume = sku.volume.replace(',','.');
                        sku.multiplication_factor = sku.multiplication_factor.replace(',','.');
                        sku.equivalence = sku.equivalence.replace(',','.');
                        //sku.fsp=sku.fsp.replace(',','.');
                        //sku.fsp_u=sku.fsp_u.replace(',','.');

                        p_detail.Sales_District1__r = new Region__c(RegionCode__c = sku.cn);
                        p_detail.Minimum_Price_R__c = Decimal.valueOf(sku.min_prc);
                        p_detail.Minimum_Price_U__c = Decimal.valueOf(sku.min_prc_u);
                        p_detail.Unit_Price_R__c = Decimal.valueOf(sku.unt_prc);
                        p_detail.Unit_Price_U__c = Decimal.valueOf(sku.unt_prc_u);
                        p_detail.Future_Sales_Price_R__c = Decimal.valueOf(sku.fsp_prc);
                        p_detail.Future_Sales_Price_U__c = Decimal.valueOf(sku.fsp_prc_u);
                        
                        p_detail.Volume__c = Decimal.valueOf(sku.volume);
                        p_detail.Equivalence__c = Decimal.valueOf(sku.equivalence);
            			p_detail.Multiplication_Factor__c = Decimal.valueOf(sku.multiplication_factor);
            			p_detail.Group__c = sku.grp;
                        p_detail.Sub_Group__c = sku.sub_grp;
                        p_detail.Anchor__c = sku.anchor;
            			p_detail.Sub_Group_Required__c = sku.subGrp_required;

                        String combKey='';
                        //System.debug('sku code ----> ' +sku.sku_code);
                        //System.debug('sku length ----> ' +sku.sku_code.trim().length());
                        
                          if(sku.sku_code.trim().length() == 6){
                                combKey='5191000000000000'+sku.sku_code;   // if length is 6 then added 12 zeros. 
                            }
                            else if(sku.sku_code.trim().length() == 7){
                                combKey='519100000000000'+sku.sku_code;    // if length is 7 then added 11 zeros.       
                            }
                            else {
                                combKey='5191'+sku.sku_code;    // if length is 18 then added sales org code only.       
                            }
                            //System.debug('SKU id---- '+ skuMap.get(combKey));
                        if(skuMap.containsKey(combKey)){
                            
                            //System.debug('SKU code---- '+ sku.sku_code);
                            
                            p_detail.SKU__c = skuMap.get(combKey);
                        }
                        else{
                            flag=false;
                        }
                        
                       /* if(districtMap.containsKey(sku.cn)){
                            System.debug('Dist code---- '+ sku.cn);
                            System.debug('Dist id---- '+ districtMap.get(sku.cn));
                            p_detail.Sales_District1__c = districtMap.get(sku.cn);
                        }
                        else{
                            flag=false;
                        }*/

                        if(flag){
                         detailsList.add(p_detail);
                        }
                    }
                }
            }
            
            if(payObjsDelete != null){
                List<PaymentTerms> payListDelete = (List<PaymentTerms>)JSON.deserialize(payObjsDelete, List<PaymentTerms>.class) ;
                System.debug('payListDelete size-->'+payListDelete.size());
                if(payListDelete.size()>0){
                    for(PaymentTerms pay : payListDelete){
                        Campaign_Payment_Terms__c payD = new Campaign_Payment_Terms__c();
                        payD.Id = pay.id;  

                        paymentTermListDelete.add(payD);
                    }
                }
            }
            
            
                System.debug('priceBookList.size()-->'+priceBookList.size());
             if(paymentTerms != null){
                List<PaymentTerms> payList = (List<PaymentTerms>)JSON.deserialize(paymentTerms, List<PaymentTerms>.class);
                 
                  if(payList.size()>0){
                            System.debug('payList-->'+payList);
                            for(PaymentTerms payTm : payList){
                                Campaign_Payment_Terms__c obj = new Campaign_Payment_Terms__c();
                                obj.Price_Book_Brazil__c = pb_id;
                                if(payTm.id != null && payTm.id != ''){
                                 obj.Id = payTm.id;
                                }                               
                                
                                if(payTm.pt_type=='day'){
                                    obj.Payment_Term__c = payTm.pt_id;
                                }
                                else{
                                    obj.Payment_Term_in_Date__c = Date.valueof(payTm.pt_name);
                                }
                                paymentTermList.add(obj);
                            }
                    }
               
              }
        }
        System.debug('SKU details List size---- '+ detailsList.size());
        System.debug('SKU details List ---- '+ detailsList);

        if(paymentTermList.size()>0){
            upsert paymentTermList;
            system.debug('paymentTermList after upsert-->'+paymentTermList);
        }
         
         if(paymentTermListDelete.size()>0){
            delete paymentTermListDelete;
        }

        /*System.debug('detailsListDelete List size---- '+ detailsListDelete.size());
        System.debug('detailsListDelete List ---- '+ detailsListDelete);

        if(detailsListDelete.size()>0){
            delete detailsListDelete;
        }
		         */
     } 
        catch (DMLException e) {
           System.debug('Exception while updating Price Book'+ e.getLineNumber());
           result='false';
           return result;
    }
        return pb_id;
    }
    
     @AuraEnabled
    public static String setActiveDeactive(String priceBookId,String value) {
        System.debug('setActiveDeactive calle...');
        System.debug('price_book id ... '+priceBookId);
        System.debug('value  ... '+value);
        try{
           if(value == 'false'){
            if(Approval.isLocked(priceBookId)){
              System.debug('Recall called....>> ');
              ProcessInstanceWorkitem[] workItems = [
             	SELECT Id FROM ProcessInstanceWorkitem  WHERE ProcessInstance.TargetObjectId = :priceBookId
                AND ProcessInstance.Status = 'Pending'];
                if(workItems.size()>0){
                Approval.ProcessWorkitemRequest pwr = new Approval.ProcessWorkitemRequest();
                pwr.setAction('Removed');
                pwr.setWorkItemId(workItems[0].id);
                Approval.ProcessResult result = Approval.process(pwr);
                }
             }
            }
            Price_Book__c priceBook =new Price_Book__c();
            priceBook.Id=priceBookId;
            if(value == 'true'){
                priceBook.isActive__c = true;
            }
            else{
                System.debug('Inside Recall');
               
				priceBook.Status__c = 'Canceled';
                priceBook.isActive__c = false;
            }
            

            update priceBook;
        }
        catch(DmlException e){
          System.debug('Exception occured ... '+e);  
        }
        return null;
        
    }

    

    public Static void loadMapValues(){
        List<SKU__c> skuList = new List<SKU__c>();
        List<Region__c> distList = new List<Region__c>();

        skuMap = new Map<String,String>();
        skuList=[SELECT Id, SKU_Code__c, Combination_Key__c, Sales_Org_Code__c FROM SKU__c where Sales_Org_Code__c='5191'];
        if(skuList.size()>0){
            for(SKU__c sk : skuList){
                skuMap.put(sk.Combination_Key__c,sk.Id);
            }
        }

      /*  districtMap = new Map<String,String>();
        distList=[SELECT Id, RegionCode__c,SalesOrg__c,Sales_Org_Code__c,Zone__c FROM Region__c where SalesOrg__r.Sales_Org_Code__c ='5191']; 
        if(distList.size()>0){
           for(Region__c rgn : distList){
               districtMap.put(rgn.RegionCode__c,rgn.Id); 
           }
        }*/
    }

    
  
    public class wrapperForSalesDistrict{
        
        @AuraEnabled
        public String Id;
        @AuraEnabled
        public String Id1;
        @AuraEnabled
        public string sdtId;
        @AuraEnabled
        public String Name;
        @AuraEnabled
        public String SDCode;
      
    }  
    
    
    //Main Pricebook_Brazil record wrapper
    public class PriceBook {
        @AuraEnabled public Boolean pb_for_cmpgn; //1
        @AuraEnabled public String cmpgn_tp;
        @AuraEnabled public String pb_name;
       // @AuraEnabled public String curncy;
        @AuraEnabled public String frm_dt;
        @AuraEnabled public String exp_dt;
        @AuraEnabled public String intr_rt_R;
        @AuraEnabled public String intr_rt_U;
        @AuraEnabled public String intr_dt;
        @AuraEnabled public String division;
        @AuraEnabled public String blk_dt;
        @AuraEnabled public String mgr_Discount{get;set;}
        @AuraEnabled public boolean simulator_upload;
        @AuraEnabled public String division_nm;
        @AuraEnabled public String pcb_id;
        @AuraEnabled public Boolean isActive;
        @AuraEnabled public String status; //16

        public PriceBook(){
            pb_for_cmpgn=false;
            cmpgn_tp='';
            pb_name='';
            //curncy='';
            frm_dt='';
            exp_dt='';
            intr_rt_R='';
            intr_rt_U='';
            intr_dt='';
            division='';
            blk_dt='';
            mgr_Discount='';
            division_nm='';
			simulator_upload=false;
            pcb_id='';
            isActive=true;
            status='';
        }
    }

    public class ProductSku {
        @AuraEnabled public String cn; //1
        @AuraEnabled public String volume;
        @AuraEnabled public String sku_code;
        @AuraEnabled public String sku_desc;
        @AuraEnabled public String unt_prc;
        @AuraEnabled public String unt_prc_u;
        @AuraEnabled public String min_prc;
        @AuraEnabled public String min_prc_u;       
        @AuraEnabled public String fsp_prc;       
        @AuraEnabled public String fsp_prc_u;       
        @AuraEnabled public String equivalence;
        @AuraEnabled public String multiplication_factor;
        @AuraEnabled public String grp;
        @AuraEnabled public String sub_grp;
        @AuraEnabled public String anchor;
        @AuraEnabled public String subGrp_required; //15 csv
        @AuraEnabled public String pbd_id; //16

        public ProductSku(){
            cn = '';
            volume = '';
            sku_code = '';
            sku_desc = '';
            min_prc = '';
            min_prc_u = '';
            unt_prc='';
            unt_prc_u = '';
            fsp_prc = '';
            fsp_prc_u = '';
            equivalence = '';
            multiplication_factor = '';
            grp = '';
            sub_grp = '';
            anchor = '';
            subGrp_required = '';
            pbd_id = '';
        }

    }

    public class ApprovalHistory {

        @AuraEnabled public String date_tm;
        @AuraEnabled public String user;
        @AuraEnabled public String name;
        @AuraEnabled public String cur_status;
        @AuraEnabled public String prev_status;
        @AuraEnabled public String comment;

        public ApprovalHistory(){
            date_tm='';
            user='';
            name='';
            cur_status='';
            prev_status='';
            comment='';
        }


    }

    public class PaymentTerms {

         @AuraEnabled public String id;
         @AuraEnabled public String pt_id;
         @AuraEnabled public String pt_name;
         @AuraEnabled public String pt_date;
         @AuraEnabled public String pBook;
         @AuraEnabled public String pt_type;

         public PaymentTerms(){
             id='';
             pt_id='';
             pt_name='';
             pt_date='';
             pBook='';
             pt_type='';

         }
    }
    
    public class GroupWrapper{
        @AuraEnabled public String pb_id;//1
        @AuraEnabled public String grp_id;
        @AuraEnabled public String grp_name;
        @AuraEnabled public String grp_desc;
        @AuraEnabled public String discount;
        //@AuraEnabled public String subgrp_qty;
		@AuraEnabled public String subgrp_required;        
        @AuraEnabled public Boolean dicount_given;        
        @AuraEnabled public String limited_vol;        
        @AuraEnabled public String subgrp_qty_required;//10
       
        public GroupWrapper(){
            pb_id = ''; 
            grp_id = ''; 
            grp_name = '';
            grp_desc = ''; 
            discount = '0'; 
            subgrp_required = 'No';
            subgrp_qty_required = '';            
            //subgrp_qty = ''; 
            dicount_given = false;
            limited_vol = '';
        }
    }
    
    public class PriceBookWrapper {
        @AuraEnabled public PriceBook pc_book {get;set;}
        @AuraEnabled public List<ProductSku> materialList {get;set;}
        @AuraEnabled public List<ApprovalHistory> approvarList {get;set;}
        @AuraEnabled public List<wrapperForSalesDistrict> salesDistricts {get;set;}
        @AuraEnabled public List<GroupWrapper> groupList {get;set;}
        @AuraEnabled public List<PaymentTerms> paymentTerms {get;set;}
        
        public PriceBookWrapper(){
            this.pc_book= new PriceBook(); 
            this.materialList = new List<ProductSku>();
            this.approvarList = new List<ApprovalHistory>();
            this.salesDistricts = new List<wrapperForSalesDistrict>();
            this.groupList =new List<GroupWrapper>();
            this.paymentTerms =new List<PaymentTerms>();
        }
        
    }

}