public without sharing class customer_Price_List{
 @AuraEnabled
 public static list<sales_org__c> getOrgDetails(){
 //fetch Sales org code from Custom settings
        UPL_Settings__c salesOrgDetails = UPL_Settings__c.getInstance();
        String SalesOrg = salesOrgDetails.SalesOrg__c;
        list<sales_org__c> salesorgId= [SELECT ID  FROM sales_org__c where sales_org_code__c=: SalesOrg];
       return salesorgId;
 }
 @AuraEnabled
 public static Boolean getProfileVisibility(){
     Boolean visibility=false;
  id ProfileId= userinfo.getProfileId();
    Profile profileName=[select Name from profile where id = :ProfileId Limit 1]; 
     if(ProfileName.Name=='System Administrator' || ProfileName.Name=='Brazil System Administrator' || profileName.Name=='Brazil Sales Price Admin' || profileName.Name=='Brazil  Manager' || profileName.Name=='Brazil Barter Manager')// add profile Brazil Barter Manager forRITM0422583 GRZ(Javed Ahmed) modified date-08-09-2022 //Marketing Managers Profile added by Sayan
         visibility=true;
     return visibility;
 }
    @AuraEnabled
     public static list<customerRegion> getSalesDistrict(){
     List<sales_org__c> salesOrgIdLi=getOrgDetails();
         List<Customer_and_Region_Mapping__c> SDLi=new List<Customer_and_Region_Mapping__c>(); 
         List<Territory_Distributor__c> terSDLi=new List<Territory_Distributor__c>();        
         List<customerRegion> retSDLiSBU=new List<customerRegion>();
         List<customerRegion> retSDLiZONE=new List<customerRegion>();
         List<customerRegion> retSDLiTerritory=new List<customerRegion>();
         List<customerRegion> retSDLiRegion=new List<customerRegion>();
         List<customerRegion> retSDLi=new List<customerRegion>();
         map<String,customerRegion > terSDmapSBU=new map<String,customerRegion>();
         map<String,customerRegion > terSDmapZONE=new map<String,customerRegion>();
         map<String,customerRegion > terSDmapRegion=new map<String,customerRegion>();
         map<String,customerRegion > terSDmapTerri=new map<String,customerRegion>();            
         String sbuFlag='False';
         String zoneFlag='False';
         String regFlag='False';
         String terFlag='False';
         
         id userId = userinfo.getUserId();
         id ProfileId= userinfo.getProfileId();
         Profile profileName=[select Name from profile where id = :ProfileId Limit 1];
         system.debug(userId+'--'+profileName.Name);
         if(ProfileName.Name=='System Administrator' || ProfileName.Name == 'Brazil Customer Service Manager' || ProfileName.Name == 'Brazil Customer Service User' || ProfileName.Name=='Brazil System Administrator' || profileName.Name=='Brazil Sales Price Admin' || profileName.Name=='Brazil Marketing Manager' || profileName.Name=='Brazil Barter Manager'){   //  add profile Brazil Barter Manager for RITM0422583 GRZ(Javed Ahmed) modified date-08-09-2022    //Marketing Managers Profile added by Sayan 
          //SDLi = [select CustomerCode__c,Customer_Name__c,CustomerRegion__r.Zone__r.name,CustomerRegion__r.Zone__c,CustomerRegion__r.SBU__r.name,CustomerRegion__r.SBU__r.Brazil_SBU_Name__c,CustomerRegion__r.SBU__c,CustomerRegion__r.region__r.name,CustomerRegion__r.region__c, CustomerName_Formula_Field__c,TerritoryManager__c, CustomerRegion__r.TerritoryManager__r.name,CustomerRegion__r.name,CustomerRegion__r.Sales_Distr__c,CustomerRegion__r.BrazilSalesDistrictCode__c from Territory_Distributor__cwhere Sales_Distr__c !='' AND Sales_Org__c=:salesOrgIdLi[0].Id ];
             terSDLi=[select Id,region__r.Name,BrazilSalesDistrictCode__c from Territory_Distributor__c where Sales_Distr__c !='' AND SalesOrg__c=:salesOrgIdLi[0].Id ORDER BY BrazilSalesDistrictCode__c ];
             map<String,customerRegion > terSDmap=new map<String,customerRegion>();
             for(Territory_Distributor__c crm : terSDLi){
                 customerRegion crmObj=new customerRegion();
                 crmObj.regionId=crm.Id;
                 crmObj.regionName=crm.region__r.Name;                 
                 crmObj.regionCode =crm.BrazilSalesDistrictCode__c;
                 //crmObj.customerName=crm.CustomerName_Formula_Field__c;
                 terSDmap.put(crm.BrazilSalesDistrictCode__c,crmObj);
                 system.debug('crmObj---'+crmObj);
             }
             retSDLi.addAll(terSDmap.values());
         }else{
             
             SDLi = [select Id,CustomerCode__c,Customer_Name__c,CustomerRegion__r.Zone__r.name,
                     CustomerRegion__r.Zone__r.ZonalHead__c,CustomerRegion__r.SBU__r.name,
                     CustomerRegion__r.SBU__r.Brazil_SBU_Name__c,CustomerRegion__r.SBU__r.SBUUser__c,
                     CustomerRegion__r.SBU__c,CustomerRegion__r.region__r.RegionHead__c, 
                     CustomerRegion__r.region__c, CustomerName_Formula_Field__c,
                     CustomerRegion__r.TerritoryManager__c, CustomerRegion__r.TerritoryManager__r.name,
                     CustomerRegion__r.name,CustomerRegion__r.Sales_Distr__c,
                     CustomerRegion__r.BrazilSalesDistrictCode__c,CustomerRegion__r.Region__r.Name ,
                     CustomerRegion__r.Region__r.RegionCode__c 
                     from Customer_and_Region_Mapping__c 
                     where CustomerRegion__r.Sales_Distr__c !='' 
                     //AND Sales_Org__c=:salesOrgIdLi[0].Id 
                     AND (CustomerRegion__r.TerritoryManager__c = : userId 
                          or CustomerRegion__r.SBU__r.SBUUser__c =:userId 
                          or CustomerRegion__r.Zone__r.ZonalHead__c = :userId 
                          or CustomerRegion__r.region__r.RegionHead__c = :userId) 
                     ORDER BY CustomerRegion__r.BrazilSalesDistrictCode__c ];
             system.debug('SDLi.size()-----'+SDLi.size());
             for(Customer_and_Region_Mapping__c crm : SDLi){
                 if(crm.CustomerRegion__r.SBU__r.SBUUser__c== userId){                 
                     customerRegion crmObj=new customerRegion();
                     crmObj.regionId=crm.Id;
                     //crmObj.regionName=crm.CustomerRegion__r.Sales_Distr__c ;
                     //crmObj.regionCode =crm.CustomerRegion__r.BrazilSalesDistrictCode__c;
                     crmObj.regionName=crm.CustomerRegion__r.Region__r.Name ;
                     crmObj.regionCode =crm.CustomerRegion__r.Region__r.RegionCode__c;
                     crmObj.customerName=crm.CustomerName_Formula_Field__c;
                     //retSDLiSBU.add(crmObj);
                     system.debug('crmObj-SBU--'+crmObj);
                     terSDmapSBU.put(crm.CustomerRegion__r.BrazilSalesDistrictCode__c,crmObj);
                     if(sbuFlag=='False'){sbuFlag='True';}
                 }
                 else if(crm.CustomerRegion__r.Zone__r.ZonalHead__c== userId){
                
                     customerRegion crmObj=new customerRegion();
                     crmObj.regionId=crm.Id;
                     //crmObj.regionName=crm.CustomerRegion__r.Sales_Distr__c ;
                     //crmObj.regionCode =crm.CustomerRegion__r.BrazilSalesDistrictCode__c;
                     crmObj.regionName=crm.CustomerRegion__r.Region__r.Name ;
                     crmObj.regionCode =crm.CustomerRegion__r.Region__r.RegionCode__c;
                     crmObj.customerName=crm.CustomerName_Formula_Field__c;
                     //retSDLiZONE.add(crmObj);
                     system.debug('crmObj-Zone--'+crmObj);
                     terSDmapZONE.put(crm.CustomerRegion__r.BrazilSalesDistrictCode__c,crmObj);
                     if(zoneFlag=='False'){zoneFlag='True';}
                 }
                 else if(crm.CustomerRegion__r.region__r.RegionHead__c== userId){
                     customerRegion crmObj=new customerRegion();
                     crmObj.regionId=crm.Id;
                     //crmObj.regionName=crm.CustomerRegion__r.Sales_Distr__c ;                     
                     //crmObj.regionCode =crm.CustomerRegion__r.BrazilSalesDistrictCode__c;
                     crmObj.regionName=crm.CustomerRegion__r.Region__r.Name ;
                     crmObj.regionCode =crm.CustomerRegion__r.Region__r.RegionCode__c;
                     crmObj.customerName=crm.CustomerName_Formula_Field__c;
                    //retSDLiRegion.add(crmObj);
                     system.debug('crmObj-Region--'+crmObj);
                     terSDmapRegion.put(crm.CustomerRegion__r.BrazilSalesDistrictCode__c,crmObj);
                     if(regFlag=='False'){regFlag='True';}
                 }
                 else if(crm.CustomerRegion__r.TerritoryManager__c == userId){
                
                     customerRegion crmObj=new customerRegion();
                     crmObj.regionId=crm.Id;
                     //crmObj.regionName=crm.CustomerRegion__r.Sales_Distr__c ;                     
                     //crmObj.regionCode =crm.CustomerRegion__r.BrazilSalesDistrictCode__c;
                     crmObj.regionName=crm.CustomerRegion__r.Region__r.Name ;
                     crmObj.regionCode =crm.CustomerRegion__r.Region__r.RegionCode__c;
                     crmObj.customerName=crm.CustomerName_Formula_Field__c;
                     //retSDLiTerritory.add(crmObj);
                     system.debug('crmObj-Ter--'+crmObj);
                     terSDmapTerri.put(crm.CustomerRegion__r.BrazilSalesDistrictCode__c,crmObj);
                     if(terFlag=='False'){terFlag='True';}
                 }else {}
                 
             }
                 retSDLiSBU.addAll(terSDmapSBU.values());
                 retSDLiZONE.addAll(terSDmapZONE.values());
                 retSDLiRegion.addAll(terSDmapRegion.values());
                 retSDLiTerritory.addAll(terSDmapTerri.values());
                if(sbuFlag=='True' )
                {return retSDLiSBU;}
                else if(zoneFlag=='True'){return retSDLiZONE; }
                else if(regFlag=='True'){return retSDLiRegion; }
                else if(terFlag=='True'){return retSDLiTerritory;}
         }  
        system.debug('retSDLi--'+retSDLi);
         

     return retSDLi;
     }
     @AuraEnabled
     public static list<Customer_and_Region_Mapping__c > getCustomers(String Id){
         List<sales_org__c> salesOrgIdLi=getOrgDetails();
         List<Customer_and_Region_Mapping__c> retSDLi=new List<Customer_and_Region_Mapping__c>();
         id userId = userinfo.getProfileId();
         Profile profileName=[select Name from profile where id = :userId Limit 1];
         if(ProfileName.Name=='System Administrator' || ProfileName.Name == 'Brazil Customer Service Manager' || ProfileName.Name == 'Brazil Customer Service User' || ProfileName.Name=='Brazil System Administrator' || profileName.Name=='Brazil Sales Price Admin' || profileName.Name=='Brazil Marketing Manager' || profileName.Name=='Brazil Barter Manager'){  //  add profile Brazil Barter Manager forRITM0422583 GRZ(Javed Ahmed) modified date-08-09-2022 //Marketing Managers Profile added by Sayan     
         
            Territory_Distributor__c terLi= [select Id,BrazilSalesDistrictCode__c from Territory_Distributor__c where Id=: Id AND SalesOrg__c=:salesOrgIdLi[0].Id limit 1]; 
            retSDLI = [select Customer_Name__c,Customer_Name__r.Name,
                       CustomerCode__c,Customer_Name__r.SAP_Code__c,
                       Customer_Name__r.BillingCity
                       from Customer_and_Region_Mapping__c  
                       where CustomerRegion__r.BrazilSalesDistrictCode__c =: terLi.BrazilSalesDistrictCode__c
                      Order by Customer_Name__r.Name ASC];
            system.debug('customer list size Admin--'+retSDLi.size());
          }else{ 
         Customer_and_Region_Mapping__c SDLi=[select id,CustomerRegion__r.BrazilSalesDistrictCode__c from Customer_and_Region_Mapping__c  where Id =: Id Limit 1];
         retSDLI = [select Customer_Name__c,Customer_Name__r.Name,
                    CustomerCode__c ,Customer_Name__r.SAP_Code__c,
                    Customer_Name__r.BillingCity
                    from Customer_and_Region_Mapping__c  
                    where CustomerRegion__r.BrazilSalesDistrictCode__c =: SDLi.CustomerRegion__r.BrazilSalesDistrictCode__c
                   Order by Customer_Name__r.Name ASC];
         system.debug('customer list size--'+retSDLi.size());
         } 
         return retSDLi;
         }
    
         @AuraEnabled
         public static List<custPriceBookList> getPriceBookList(String crmId,String custId){
           List<custPriceBookList> custPL=new List<custPriceBookList>();
           List<Price_Book_Sales_District__c > priceBookList= new list<Price_Book_Sales_District__c >();
             List<string> pbObjlist = new List<string>();
           id userId = userinfo.getProfileId();
           Profile profileName=[select Name from profile where id = :userId Limit 1];
           if(ProfileName.Name=='System Administrator' || ProfileName.Name == 'Brazil Customer Service Manager' || ProfileName.Name == 'Brazil Customer Service User' || ProfileName.Name=='Brazil System Administrator' || profileName.Name=='Brazil Sales Price Admin' || profileName.Name=='Brazil Marketing Manager' || profileName.Name=='Brazil Barter Manager'){  //  add profile Brazil Barter Manager forRITM0422583 GRZ(Javed Ahmed) modified date-08-09-2022      //Marketing Managers Profile added by Sayan
               //SDLi = [select CustomerCode__c,Customer_Name__c,CustomerRegion__r.Zone__r.name,CustomerRegion__r.Zone__c,CustomerRegion__r.SBU__r.name,CustomerRegion__r.SBU__r.Brazil_SBU_Name__c,CustomerRegion__r.SBU__c,CustomerRegion__r.region__r.name,CustomerRegion__r.region__c, CustomerName_Formula_Field__c,TerritoryManager__c, CustomerRegion__r.TerritoryManager__r.name,CustomerRegion__r.name,CustomerRegion__r.Sales_Distr__c,CustomerRegion__r.BrazilSalesDistrictCode__c from Territory_Distributor__cwhere Sales_Distr__c !='' AND Sales_Org__c=:salesOrgIdLi[0].Id ];
               Territory_Distributor__c terSDLi=[select Id,Sales_Distr__c,BrazilSalesDistrictCode__c from Territory_Distributor__c where Id=:crmId  ];
               system.debug(terSDLi.BrazilSalesDistrictCode__c );
               priceBookList=[select Price_Book__c,Price_Book__r.Name from Price_Book_Sales_District__c where Sales_District1__r.RegionCode__c=: terSDLi.BrazilSalesDistrictCode__c AND Price_Book__c!= ''];
        
          }else{  
               Customer_and_Region_Mapping__c sdId=[select CustomerRegion__r.BrazilSalesDistrictCode__c from Customer_and_Region_Mapping__c  where id=: crmId limit 1];
               system.debug(sdId.CustomerRegion__r.BrazilSalesDistrictCode__c );
               priceBookList=[select id,Price_Book__c,Price_Book__r.Name from Price_Book_Sales_District__c where Sales_District1__r.RegionCode__c=: sdId.CustomerRegion__r.BrazilSalesDistrictCode__c AND Price_Book__c!= ''];
        }
        
        Set<Id> priceBookIds= new Set<Id>();
        for(Price_Book_Sales_District__c pb: priceBookList){
            Id pbId=pb.price_book__c;
            priceBookIds.add(pbId);
        }
              if(priceBookIds.size() > 0) {
          List<Price_Book__c> lstPriceBook = [Select Id from Price_Book__c where Id IN: priceBookIds AND Id NOT IN (Select Price_Book_Brazil__c FROM Customer__c)];
          if(lstPriceBook.size() > 0) {
            for(Price_Book__c oPB: lstPriceBook){
              pbObjlist.add(oPB.Id);
            }
          }
        } 
             if(custid!=null){
        system.debug(custid);
          
            
            for(Price_Book__c cobj:[Select Id, Name from Price_Book__c where Id in (Select Price_Book_Brazil__c FROM Customer__c where Account__r.Id =: custid)]){
                pbObjlist.add(cobj.Id);
            }                          
                                                    
    } 
        List<Price_book__c> PBList=[SELECT Id, Name, Division__c, Currency__c, Valid_From__c, Expiry_Date__c ,Campaign_Type__c,
                                Optional_Simulator__c, Interest_Date__c FROM Price_Book__c
                                WHERE Id IN: pbObjlist//salesDistrictPriceBookSet
                                AND Valid_From__c <= TODAY
                                AND Expiry_Date__c >= TODAY
                                AND isActive__c = True
                                AND Status__c = 'Approved'
                                AND Base_Price_Book__c = false
                                ORDER BY Name];
                                
        for(Price_book__c pb : PBList){
        custPriceBookList custPB=new custPriceBookList();
        custPB.priceBook=pb.Name;
        //custPL.finalPrice
        custPB.Id=pb.Id;
        custPL.add(custPB);
        }
        system.debug(custPL.size());
      return custPL;
     }
    
   
    //CREATED METHOD getpricebookdetail BY SAGAR&HARSHIT@WIPRO FOR (US PB-006) ---START
    //BELOW SOME LINES CHANGES ADDED BY HARSHITANDANMOL@WIPRO FOR (Phase 2-US SO-005) ---START

    @AuraEnabled
    public static List<pricebookdetaillist> getpricebookdetail(String crmId,String custId){
        Price_Book__c pricebookdetail=[SELECT Valid_From__c,Last_Month_Of_The_Season__c,Interest_Rate_R__c,Interest_Rate_U__c, CurrencyIsoCode,Apply_Increase_Decrease_Percentage__c from Price_Book__c where id=:crmId ]; 
                Decimal CustConversionFactor=1;

        List <Price_Book_Details__c> materials = new List <Price_Book_Details__c>();
        materials= [select SKU__c,sku__r.Brand_Name__c, Sku_Name__c, 
                    sku__r.SKU_Code__c,Price_Book__r.CurrencyIsoCode,
                    Minimum_Price_R__c,Minimum_Price_U__c, Unit_Price_U__c,sku__r.SKU_Description__c,
                    Unit_Price_R__c, Future_Sales_Price_R__c,
                    Future_Sales_Price_U__c, Sales_District1__c 
                    from Price_Book_Details__c 
                    where price_book__c=:crmId];
                     set<string> setBrand = new set<string>();
		map<string, decimal> mapBrandSOFactor = new map<string, decimal>();
		if(materials.size() > 0) {
			for(Price_Book_Details__c oPBD: materials){
				setBrand.add(oPBD.sku__r.Brand_Name__c);
			}
		}
        if(setBrand.size() > 0) {
			List<Sell_Out_Percentage__c> sop = [select Brand__c,Sell_Out_Factor__c from Sell_Out_Percentage__c where Brand__c IN: setBrand];
			if(sop.size() > 0) {
				for(Sell_Out_Percentage__c SellOut: sop) {
					mapBrandSOFactor.put(SellOut.Brand__c, SellOut.Sell_Out_Factor__c);
				}
			}
		}
		
         Map<string,Customer_Conversion_factor__c> MapCCF = new Map<string,Customer_Conversion_factor__c>();
            for (Customer_Conversion_factor__c DM: [select id, Conversion_Factor__c, Customer_Group__c,
                                         Sales_Org__c, Combination_Key__c,Brand_Name__c
                                          from Customer_Conversion_factor__c]){
                                             MapCCF.put(DM.Customer_Group__c+DM.Brand_Name__c, DM);   //Updated by Divya for SCTASK0486924
                                         }
                   String ConversionFactor = [SELECT Id, Price_Conversion_Group__c FROM Account WHERE Id=:custId].Price_Conversion_Group__c;
          
        string sCurrency = pricebookdetail.CurrencyIsoCode;
        boolean sApplyIncDecPerc = pricebookdetail.Apply_Increase_Decrease_Percentage__c;
        DateTime d =date.today();
        Date d2=date.today();
        if(pricebookdetail.Last_Month_Of_The_Season__c != null){
        d =  pricebookdetail.Last_Month_Of_The_Season__c;
        d2=  pricebookdetail.Last_Month_Of_The_Season__c;  
      }
        integer LastMonth = integer.valueOf(d.month());
        system.debug('LastMonth'+LastMonth);
        
        DateTime d1 =  pricebookdetail.Valid_From__c;
        Date d3=pricebookdetail.Valid_From__c;
        Integer monthDiff = d3.monthsBetween(d2);
    system.debug('monthDiff'+monthDiff);
        integer ValidFromMonth = integer.valueOf(d1.month());
        system.debug('ValidFromMonth'+ValidFromMonth);
        system.debug('ValidFromMonth2'+d1.format('MMMM'));
        // d1=d1.addMonths(1);
        //system.debug('ValidFromMonth3'+d1.month());
        //system.debug('ValidFromMonth4'+d1.format('MMMM'));
        integer diff = LastMonth-ValidFromMonth;
        
        System.debug('diff is '+diff);
        
        Decimal  brlint = pricebookdetail.Interest_Rate_R__c;
        Decimal  usdint = pricebookdetail.Interest_Rate_U__c;
        
          List<Increase_Decrease_Percentage__c> idp= [select id,Start_Date__c,End_Date__c,Percentage__c,Status__c,CurrencyIsoCode from Increase_Decrease_Percentage__c where Start_Date__c<=today AND End_Date__c>=today and Status__c='Approved' limit 1];
        decimal percentdec = 0.0;
       if(idp.size() > 0){
            string percent=string.Valueof(idp[0].Percentage__c);
            percentdec=idp[0].Percentage__c;
        system.debug('Test123  '+percentdec);
        } 
        
        
        List<pricebookdetaillist> pblist= new List<pricebookdetaillist>();
        //DateTime d2 =  pricebookdetail.Valid_From__c;
         
        for(Price_Book_Details__c pbdetails:materials){    //3
            //for(integer i=0; i<=diff; i++){
                 //Sell_Out_Percentage__c sop = [select Brand__c,Sell_Out_Factor__c from Sell_Out_Percentage__c where Brand__c=:pbdetails.sku__r.Brand_Name__c];
                
                 //Updated by Divya for SCTASK0486924
        if(MapCCF.containskey(ConversionFactor+pbdetails.sku__r.SKU_Description__c)){
            if(string.isNotBlank(string.valueOf(MapCCF.get(ConversionFactor+pbdetails.sku__r.SKU_Description__c).Conversion_Factor__c))){
            CustConversionFactor = MapCCF.get(ConversionFactor+pbdetails.sku__r.SKU_Description__c).Conversion_Factor__c;//added by Swapnil
             System.debug('CustConversionFactor inside'+CustConversionFactor);   
            }             
         }
         else{
             CustConversionFactor = 1;   
         } 
                pricebookdetaillist pb= new pricebookdetaillist();
                pb.SKUName = pbdetails.Sku_Name__c;
            pb.curr = pricebookdetail.CurrencyIsoCode;
        if(sCurrency == 'USD'){
          pb.futureSalesPriceUS= pbdetails.Future_Sales_Price_U__c ;
        }
        else {
          pb.futureSalesPriceBR= pbdetails.Future_Sales_Price_R__c ;
                }
        system.debug(diff);
               /* if(sCurrency == 'USD'){
                    pb.unitPriceUS = pbdetails.Unit_Price_U__c + (pbdetails.Unit_Price_U__c * percentdec/100);
                    pb.minPriceUS= pbdetails.Minimum_Price_U__c + (pbdetails.Minimum_Price_U__c * percentdec/100);
                 } else {
                    pb.unitPriceBR= pbdetails.Unit_Price_R__c + (pbdetails.Unit_Price_R__c * percentdec/100);
                    pb.minPriceBR= pbdetails.Minimum_Price_R__c + (pbdetails.Minimum_Price_R__c * percentdec/100);
                 }*/
              for(integer i=0; i <= monthDiff; i++){
                    // pbdetails.Unit_Price_U__c = pbdetails.Unit_Price_U__c*CustConversionFactor
                    monthPrice mp = new monthPrice();
                    if(sCurrency == 'USD'){
                    mp.unitPrice = pbdetails.Unit_Price_U__c*CustConversionFactor + (pbdetails.Unit_Price_U__c *CustConversionFactor *  usdint / 100) *i;
                    mp.minPrice = pbdetails.Minimum_Price_U__c*CustConversionFactor + (pbdetails.Minimum_Price_U__c*CustConversionFactor *   usdint /100)*i;
                         if(idp.size() > 0 && idp[0].CurrencyIsoCode == 'USD' && sApplyIncDecPerc==true ){
                           mp.unitPrice = mp.unitPrice*CustConversionFactor + (mp.unitPrice *CustConversionFactor* percentdec/100);
                               mp.minPrice = mp.minPrice*CustConversionFactor + (mp.minPrice*CustConversionFactor * percentdec/100);
                         }
                 } else {
                    mp.unitPrice = pbdetails.Unit_Price_R__c*CustConversionFactor + (pbdetails.Unit_Price_R__c*CustConversionFactor *   brlint / 100) * i;
                    mp.minPrice = pbdetails.Minimum_Price_R__c*CustConversionFactor + (pbdetails.Minimum_Price_R__c*CustConversionFactor *  brlint /100)*i;
                     if(idp.size() > 0 && idp[0].CurrencyIsoCode == 'BRL' && sApplyIncDecPerc==true){
                            mp.unitPrice = mp.unitPrice*CustConversionFactor + (mp.unitPrice*CustConversionFactor * percentdec/100);
                               mp.minPrice = mp.minPrice*CustConversionFactor + (mp.minPrice *CustConversionFactor* percentdec/100);
                         }
                 }
                    
                   decimal doSellOutFactor = 0;
					if(mapBrandSOFactor.containsKey(pbdetails.sku__r.Brand_Name__c)){
						doSellOutFactor = mapBrandSOFactor.get(pbdetails.sku__r.Brand_Name__c);
					}
					if(doSellOutFactor > 0){
						mp.sellOutPrice = mp.unitPrice + (mp.unitPrice*(doSellOutFactor/100)); //Added By Krishanu & Anktia @ Wipro   
					}
                   //mp.sellOutPrice = mp.unitPrice + (mp.unitPrice*(sop.Sell_Out_Factor__c/100)); //Added By Krishanu & Anktia @ Wipro   
                    //d1=d1.addMonths(i);
                   mp.Month = d1.format('MMMM');
                    pb.lstMonthPrice.add(mp);
                    d1=d1.addMonths(1);
        }
        System.debug(pb.Month);
                //pb.Month=d1.format('MMMM');
                //d1=d1.addMonths(1);
        system.debug(pb);
                pblist.add(pb);
                //system.debug('pblistWrapperr***'+pblist);
        d1=pricebookdetail.Valid_From__c;
            
        }
        
       system.debug('pblistWrapperr***'+pblist);
    string pbliststr = JSON.serialize(pblist);
            pbliststr = pbliststr.replaceAll('January', 'Janeiro');
            pbliststr = pbliststr.replaceAll('February', 'Fevereiro');
            pbliststr = pbliststr.replaceAll('March', 'Março');
            pbliststr = pbliststr.replaceAll('April', 'Abril');
            pbliststr = pbliststr.replaceAll('May', 'Maio');
            pbliststr = pbliststr.replaceAll('June', 'Junho');
            pbliststr = pbliststr.replaceAll('July', 'Julho');
            pbliststr = pbliststr.replaceAll('August', 'Agosto');
            pbliststr = pbliststr.replaceAll('September', 'Setembro');
            pbliststr = pbliststr.replaceAll('October', 'Outubro');
            pbliststr = pbliststr.replaceAll('November', 'Novembro');
          pbliststr = pbliststr.replaceAll('December', 'Dezembro');
        List<pricebookdetaillist> pblist1 = (List<pricebookdetaillist>)JSON.deserialize(pbliststr, List<pricebookdetaillist>.class);
        system.debug('pblist1'+pblist1);
        return pblist1;  
    }
    
    //-----END
    
    
    
     
     
     @AuraEnabled
     public static list<custPriceList> getPriceLists(String custId,String crmId,String pbId){         
        system.debug('custId--'+custId+'---Crm Id---'+crmId+'----pbId---'+pbId); 
        List <custPriceList> custPL= new List <custPriceList>();       
        List <Price_Book_Details__c> materials = new List <Price_Book_Details__c>();
        List<pricebookdetaillist> pricelistdetail1= new List<pricebookdetaillist>();
         pricelistdetail1=customer_Price_List.getpricebookdetail(pbId,custId);
         system.debug('pricelistdetail1*'+pricelistdetail1);
        
        Decimal CustConversionFactor=1;
        
        materials= [select SKU__c,sku__r.Brand_Name__c, Sku_Name__c, 
                    sku__r.SKU_Code__c,Price_Book__r.CurrencyIsoCode,
                    Minimum_Price_R__c,Minimum_Price_U__c, Unit_Price_U__c,
                    Unit_Price_R__c, Future_Sales_Price_R__c,sku__r.SKU_Description__c,
                    Future_Sales_Price_U__c, Sales_District1__c 
                    from Price_Book_Details__c 
                    where price_book__c=:pbId]; //Updated by Swapnil- 24-04-2020: Currency Code of Price Book
       system.debug('materials----'+materials);
        Account custGrp=[select Cust_Group__c,Customer_Group__c from account where id=:custId limit 1];
         //Customer_Conversion_factor__c cf= [select Conversion_Factor__c from Customer_Conversion_factor__c where Customer_Group__c=: custGrp.Conversion_Factor__c ];
        //Added by Swapnil
        String ConversionFactor = [SELECT Id, Price_Conversion_Group__c FROM Account WHERE Id=:custId].Price_Conversion_Group__c;
        
         Map<string,Customer_Conversion_factor__c> MapCCF = new Map<string,Customer_Conversion_factor__c>();
            for (Customer_Conversion_factor__c DM: [select id, Conversion_Factor__c, Customer_Group__c,
                                         Sales_Org__c, Combination_Key__c,Brand_Name__c
                                          from Customer_Conversion_factor__c]){
                                             MapCCF.put(DM.Customer_Group__c+DM.Brand_Name__c, DM);   //Updated by Divya for SCTASK0486924
                                         }
           
        /*if(MapCCF.containskey(ConversionFactor)){
            if(string.isNotBlank(string.valueOf(MapCCF.get(ConversionFactor).Conversion_Factor__c))){
            CustConversionFactor = MapCCF.get(ConversionFactor).Conversion_Factor__c;//added by Swapnil
            }             
         }*/
        //end
        for(Price_Book_Details__c pbd :materials){
        custPriceList custPLobj= new custPriceList();
        custPLobj.brand = pbd.sku__r.Brand_Name__c;
        custPLobj.SKUCode=pbd.sku__r.SKU_Code__c;
        custPLobj.SKUName=pbd.Sku_Name__c; 
        custPLobj.currISOCode=pbd.Price_Book__r.CurrencyIsoCode;//Added by Swapnil- 24-04-2020: Currency Code of Price Book
            for(pricebookdetaillist pbl:pricelistdetail1){
                if(custPLobj.SKUName == pbl.SKUName){
                    custPLobj.lstMonthPrice1=pbl.lstMonthPrice;
                }
            }
            
            //Updated by Divya for SCTASK0486924
        if(MapCCF.containskey(ConversionFactor+pbd.sku__r.SKU_Description__c)){
            if(string.isNotBlank(string.valueOf(MapCCF.get(ConversionFactor+pbd.sku__r.SKU_Description__c).Conversion_Factor__c))){
            CustConversionFactor = MapCCF.get(ConversionFactor+pbd.sku__r.SKU_Description__c).Conversion_Factor__c;//added by Swapnil
            }             
         }
         else{
             CustConversionFactor = 1;   
         }
            
        if(CustConversionFactor != null && pbd.Future_Sales_Price_U__c!=null)
        custPLobj.futureSalesPriceUS=(pbd.Future_Sales_Price_U__c * CustConversionFactor).setScale(2);
        if(CustConversionFactor != null && pbd.Future_Sales_Price_R__c!=null)     
        custPLobj.futureSalesPriceBR=(pbd.Future_Sales_Price_R__c * CustConversionFactor).setScale(2);
        if(CustConversionFactor != null && pbd.Minimum_Price_R__c!=null)
        custPLobj.minPriceBR=(pbd.Minimum_Price_R__c * CustConversionFactor).setScale(2);
        if(CustConversionFactor != null && pbd.Minimum_Price_U__c!=null)
        custPLobj.minPriceUS=(pbd.Minimum_Price_U__c * CustConversionFactor).setScale(2);
        system.debug('custPLobj.minPriceBR---------------->'+custPLobj.minPriceBR);
        if(CustConversionFactor != null && pbd.Unit_Price_R__c!=null)            
        custPLobj.unitPriceBR=(pbd.Unit_Price_R__c * CustConversionFactor).setScale(2) ;
         if(CustConversionFactor != null && pbd.Unit_Price_U__c!=null)
        custPLobj.unitPriceUS=(pbd.Unit_Price_U__c * CustConversionFactor).setScale(2) ;
       
        custPL.add(custPLobj);       
        }
        system.debug('custPL---'+custPL.size()); 
         
         System.debug('custPL'+custPL);
        return custPL;
        
     }
     
     public class custPriceList{
         @AuraEnabled
        public string brand{get;set;}
        @AuraEnabled
        public string SKUCode{get;set;}        
        @AuraEnabled
        public string SKUName{get;set;}   
        @AuraEnabled
        public Decimal unitPriceBR{get;set;} 
        @AuraEnabled
        public Decimal unitPriceUS{get;set;}         
        @AuraEnabled
        public Decimal futureSalesPriceBR{get;set;}
        @AuraEnabled
        public Decimal futureSalesPriceUS{get;set;}
        @AuraEnabled
        public Decimal minPriceBR{get;set;}
        @AuraEnabled
        public Decimal minPriceUS{get;set;}
        @AuraEnabled
        public string currISOCode{get;set;}
        @AuraEnabled
        public List<monthPrice> lstMonthPrice1 = new List<monthPrice>();
         
    }
     public class customerRegion{
        @AuraEnabled
        public string regionName {get;set;}        
        @AuraEnabled
        public string regionId {get;set;}   
        @AuraEnabled
        public string regionCode {get;set;}         
       // @AuraEnabled
       // public string customerCode {get;set;}
       //// @AuraEnabled
       // public string customerId {get;set;}
        @AuraEnabled
        public string customerName {get;set;}
        //@AuraEnabled
        // public string priceVisiblity {get;set;} 
    }
    
     
    public class custPriceBookList{
        @AuraEnabled
        public string priceBook{get;set;}
        @AuraEnabled
        public string Id{get;set;}
    }
    
    public class pricebookdetaillist{
        
        @AuraEnabled
        public string SKUName{get;set;}        
        @AuraEnabled
        public string Month{get;set;}   
        @AuraEnabled
        public Decimal unitPriceBR{get;set;} 
        @AuraEnabled
        public Decimal unitPriceUS{get;set;}         
        @AuraEnabled
        public Decimal sellOutPrice{get;set;}   //Added By Krishanu & Anktia @ Wipro   
        @AuraEnabled
        public Decimal futureSalesPriceBR{get;set;}
        @AuraEnabled
        public Decimal futureSalesPriceUS{get;set;}
        @AuraEnabled
        public Decimal minPriceBR{get;set;}
        @AuraEnabled
        public Decimal minPriceUS{get;set;}
        @AuraEnabled
        public List<monthPrice> lstMonthPrice = new List<monthPrice>();
        @AuraEnabled
        public string curr{get;set;}
    }
    
     public class monthPrice{
        
        @AuraEnabled
        public string Month{get;set;}  
        @AuraEnabled
        public Decimal unitPrice{get;set;} 
        @AuraEnabled
        public Decimal minPrice{get;set;}
        @AuraEnabled
        public Decimal sellOutPrice{get;set;}  //Added By Krishanu & Anktia @ Wipro       
    }
     
     
}