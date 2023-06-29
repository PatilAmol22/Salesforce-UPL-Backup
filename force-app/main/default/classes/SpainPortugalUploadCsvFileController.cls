public without sharing class SpainPortugalUploadCsvFileController {
    
    @AuraEnabled
    public static string updateCSVData(String selectAccountType,String strfromCSV)
    {
        system.debug('selectAccountType = ' +selectAccountType );
        system.debug('strfromCSV = ' +strfromCSV );
        String returnresponse='';
        
        List<Contact_Sku__c> contactSkuInsertList = new List<Contact_Sku__c>();
        List<SKU__c> skuList=new List<SKU__c>();
        
        
        List<Contact_Crop__c> contactCropInsertList = new List<Contact_Crop__c>();
        List<Crop__c> cropList=new List<Crop__c>();
        
        List<Contact_Competitor_Product__c> ccpInsertList = new List<Contact_Competitor_Product__c>();
        List<Competitor_Product__c> cpList= new List<Competitor_Product__c>();
        
        List<String> errorCSVList = new List<String>();
        List<String> successCSVList = new List<String>();
        List<Account> accountList = new List<Account>();
        List<Contact> contactList = new List<Contact>();
        Set<String> setProductConsumed = new Set<String>();
        Set<String> setOpportunity = new Set<String>();
        List<String> SkuCompositeKey = new List<String>();
        List<String> cropCodeList = new List<String>();
        
        String successsListFirstRow='';
        String errorListFirstRow='';
        String successsListOppFirstRow='';
        String errorListOppFirstRow='';
        String successsListProdConsumFirstRow='';
        String errorListProdConsumFirstRow='';
        
        Map<String,String> mapAccId= new Map<String,String>();
        Map<String,String> mapAccConId= new Map<String,String>();
        Map<String,Id> mapSAPCodeAccId= new Map<String,Id>();
        Map<String,String> mapCombinationKey= new Map<String,String>();
        Map<String,String> cropMapCombinationKey= new Map<String,String>();
        
        Map<String,String> mapOpportunutyAccCombinationKey= new Map<String,String>();
        
        Map<String,String> mapNameEmail= new Map<String,String>();
        
        List<fieldWrapper> datalist = (List<fieldWrapper>) JSON.deserialize(strfromCSV, List<fieldWrapper>.class);
        system.debug('datalist = ' + datalist);
        system.debug('datalistSize = ' + datalist.size());
        //  https://upl--upltest.my.salesforce.com/_ui/common/apex/debug/ApexCSIPage#
        String combinationKey = '';
        // String compositeKey = '';
        String distributionChannelCode = '';
        String divisionCode = '';
        String skuCode='';
        String salesOrgCode='';
        String CropCompositeKey='';
        
        // changes made by vishal UPL-CR131  changes from 2520 to 2481
        List<Account> accSapCodeList=[SELECT ID,Name, Email__c, SAP_Code__c From Account where RecordType.Name='Distributor' AND (Sales_Org__r.Sales_Org_Code__c='2510' OR Sales_Org__r.Sales_Org_Code__c='2481'OR Sales_Org__r.Sales_Org_Code__c='2541')];
        //List<Sales_Org__c> salesOrgList =[SELECT Id, Name, Sales_Org_Code__c, Description__c FROM Sales_Org__c];//  or Sales_Org_Code__c='5710' or Sales_Org_Code__c='2410'];
        for(Account accOb:accSapCodeList){
            mapAccId.put(accOb.SAP_Code__c, accOb.id);
        }
        
        
        //Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect_Iberia').getRecordTypeId();
        //For prospect Account
        if(selectAccountType=='Insert Prospect Account'){
            Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Prospect_Iberia').getRecordTypeId();
            //Account
            successsListFirstRow='SalesOrgCode,DistributionChannel,Division,CurrencyIsoCode,Name,Street,PostalCode,City,Province,Country,Email,Phone,Kind,Priority,Comments';
            errorListFirstRow='SalesOrgCode,DistributionChannel,Division,CurrencyIsoCode,Name,Street,PostalCode,City,Province,Country,Email,Phone,Kind,Priority,Comments';
            successCSVList.add('Record ID,'+successsListFirstRow);
            errorCSVList.add(errorListFirstRow+',Error Description');
            // Contact-SKU
            /*
            successsListOppFirstRow='Opportunity,Account';
            errorListOppFirstRow='Opportunity,Account';
            successCSVList.add('Record ID,'+successsListOppFirstRow);
            errorCSVList.add(errorListOppFirstRow+',Error Description');
            // Contact-Competitor Product
            successsListProdConsumFirstRow='CompetitorProduct,Account';
            errorListProdConsumFirstRow='CompetitorProduct,Account';
            successCSVList.add('Record ID,'+successsListProdConsumFirstRow);
            errorCSVList.add(errorListProdConsumFirstRow+',Error Description');
            */
            if(datalist.size()>0){
                for(Integer j=0; j<datalist.size(); j++){
                    
                    
                    Account accObj =new  Account();
                    String lastFourDigits ='';     //substring containing last 4 characters
                    System.debug('j : '+j);
                    System.debug('@prospect SalesOrgCode : '+datalist[j].SalesOrgCode);
                    
                    System.debug('@prospect SalesOrgCode : '+datalist[j].SalesOrgCode);
                    
                    
                    if(String.isNotBlank(datalist[j].SalesOrgCode)){
                        accObj.Sales_Org__r = new Sales_Org__c(Sales_Org_Code__c = datalist[j].SalesOrgCode);
                        salesOrgCode=datalist[j].SalesOrgCode;
                    }
                    
                    if(String.isNotBlank(datalist[j].DistributionChannel)){
                        
                        accObj.Distribution_Channel__r = new Distribution_Channel__c(Distribution_Channel_Code__c = datalist[j].DistributionChannel);
                        distributionChannelCode=datalist[j].DistributionChannel;
                    }
                    
                    
                    if(String.isNotBlank(datalist[j].Division)){
                        accObj.Division__r = new Division__c(Division_Code__c = datalist[j].Division);
                        //accObj.Division__c =datalist[j].Division;
                        divisionCode=datalist[j].Division;
                    }
                    
                    if(String.isNotBlank(datalist[j].Opportunity)){
                        
                        for(String key:datalist[j].Opportunity.split('\\$')) {
                            
                            //String code = datalist[j].Opportunity;
                            system.debug('@Beforekey>>--->'+key);
                            if(key.length()==6){
                                key = '000000000000'+Key;
                                system.debug('@ifkey6>>--->'+key);
                                
                            }
                            else if(key.length()==7){
                                key = '00000000000'+Key;
                                system.debug('@ifkey7>>--->'+key);
                            }
                            system.debug('@keySKU>>--->'+key);
                            System.debug('@accNameSku : '+datalist[j].Name.toLowercase());
                            System.debug('@accEmailSku : '+datalist[j].Email.toLowercase());
                            System.debug('key : '+key);
                            String accNameSku=datalist[j].Name;
                            String accEmailSku=datalist[j].Email;
                            
                            skuCode=Key;
                            String compositeKey='';
                            compositeKey=salesOrgCode + distributionChannelCode + divisionCode +skuCode ;
                            SkuCompositeKey.add(compositeKey);
                            System.debug('SkuCompositeKey : '+SkuCompositeKey);
                            mapOpportunutyAccCombinationKey.put(compositeKey+accEmailSku.toLowercase(),accEmailSku.toLowercase());
                            
                            system.debug('@mapOpportunutyAccCombinationKey>>--->'+mapOpportunutyAccCombinationKey);
                            
                        }
                        
                        //system.debug('setOpportunity>>--->'+setOpportunity);
                        // accObj.Opportunity__r =new SKU__c(Sku_Code__c = code);
                    }
                    
                    if(String.isNotBlank(datalist[j].CurrencyIsoCode)){
                        accObj.CurrencyIsoCode =datalist[j].CurrencyIsoCode;  
                    }
                    
                    if(String.isNotBlank(datalist[j].Name)){
                        accObj.Name =datalist[j].Name;  
                    }
                    
                    if(String.isNotBlank(datalist[j].Street)){
                        accObj.BillingStreet =datalist[j].Street;  
                    }  
                    if(String.isNotBlank(datalist[j].PostalCode)){
                        accObj.BillingPostalCode =datalist[j].PostalCode;  
                    }
                    
                    if(String.isNotBlank(datalist[j].City)){
                        accObj.BillingCity =datalist[j].City;  
                    }
                    if(String.isNotBlank(datalist[j].Province)){
                        accObj.Province__c =datalist[j].Province;  
                    }
                    if(String.isNotBlank(datalist[j].Country)){
                        accObj.BillingCountry=datalist[j].Country;  
                    }
                    
                    if(String.isNotBlank(datalist[j].Email)){
                        accObj.Email__c =datalist[j].Email;  
                    }
                    
                    
                    if(String.isNotBlank(datalist[j].Phone)){
                        accObj.Phone =datalist[j].Phone;  
                    }
                    
                    if(String.isNotBlank(datalist[j].SAPCode)){
                        accObj.SAP_Code__c =datalist[j].SAPCode;  
                    }
                    if(String.isNotBlank(datalist[j].Kind)){
                        accObj.Kind__c =datalist[j].Kind;  
                    }
                    if(String.isNotBlank(datalist[j].ProductsConsumed)){
                        //accObj.Products_Consumed__r =new Competitor_Product__c(Combination_Key__c = datalist[j].ProductsConsumed);
                        //setProductConsumed.addAll(datalist[j].ProductsConsumed.split('$'));
                        //system.debug('ProductConsumed>>--->'+setProductConsumed);
                        
                        for(String key:datalist[j].ProductsConsumed.split('\\$'))
                        {
                            System.debug('@NAme : '+datalist[j].Name.toLowercase());
                            System.debug('@Email : '+datalist[j].Email.toLowercase());
                            System.debug('key : '+key);
                            String accName=datalist[j].Name;
                            String accEmail=datalist[j].Email;
                            
                            mapCombinationKey.put(key+accEmail.toLowercase(),accEmail.toLowercase());
                            setProductConsumed.add(key);
                            System.debug('@mapCombinationKey : '+mapCombinationKey);
                        }
                        
                    }
                    
                    if(String.isNotBlank(datalist[j].Priority)){
                        accObj.Priority__c =datalist[j].Priority;  
                    }
                    if(String.isNotBlank(datalist[j].Comments)){
                        accObj.Comments__c =datalist[j].Comments;  
                    }
                    
                    
                    
                    accObj.RecordTypeId=accRecordTypeId;
                    system.debug('accObj>>--->'+accObj);
                    accountList.add(accObj);
                    system.debug('accountList >>--->'+accountList);
                }
                cpList=[Select id, Combination_Key__c from Competitor_Product__c Where Combination_Key__c IN:setProductConsumed];
                // changes made by vishal UPL-CR131  changes from 2520 to 2481
                skuList=[Select id, Combination_Key__c,SKU_Code__c,New_Combination_Key_for_SWAL__c from
                         SKU__c Where (Sales_Org_Code__c='2510' OR Sales_Org_Code__c='2481'OR Sales_Org_Code__c='2541') AND New_Combination_Key_for_SWAL__c IN:SkuCompositeKey];
            }
            Database.SaveResult[] srList;
            
            if(accountList.size()>0){
                try {
                    srList = Database.insert(accountList, True);
                    returnresponse = 'SUCCESS';
                    List<Account> accSapCodeList2=[SELECT ID,Name, Email__c, SAP_Code__c From Account where RecordType.Name='Prospect Iberia' AND (Sales_Org_Code__c='2510' OR Sales_Org_Code__c='2541')];
                    //List<Sales_Org__c> salesOrgList =[SELECT Id, Name, Sales_Org_Code__c, Description__c FROM Sales_Org__c];//  or Sales_Org_Code__c='5710' or Sales_Org_Code__c='2410'];
                    String accName='';
                    String accEmail='';
                    
                    for(Account accOb:accSapCodeList2){
                        accName=accOb.Name.toLowercase();
                        
                        if(accOb.Email__c!=null){
                            accEmail=accOb.Email__c.toLowercase();
                        }
                        mapNameEmail.put(accEmail,accOb.Id);
                        System.debug('mapNameEmail : '+mapNameEmail);
                    }
                    //Start of Competitor product
                    
                    /*
for(Competitor_Product__c cpObj:cpList){
Contact_Competitor_Product__c cppObj=new Contact_Competitor_Product__c();
cppObj.Competitor_Product__c=cpObj.id;
System.debug('mapCombinationKey : '+mapCombinationKey.get(cpObj.Combination_Key__c));
String nameEmailStr=mapCombinationKey.get(cpObj.Combination_Key__c);
System.debug('@1nameEmailStr : '+ nameEmailStr);
System.debug('mapNameEmail get : '+mapNameEmail.get(nameEmailStr));
cppObj.Account__c=mapNameEmail.get(nameEmailStr);
ccpInsertList.add(cppObj);
}*/
                    //end of Competitor product
                    //Start of sku
                    List<String> mapNameEmailList=new List<String>(mapNameEmail.keySet());
                    System.debug('mapNameEmailList : '+mapNameEmailList);
                   /* for(String email:mapNameEmailList){
                        
                        //Start of sku for loop
                        for(Integer i=0;i<skuList.size();i++){
                            String TempEmail=mapNameEmailList[i];
                            //start sku
                            SKU__c skuObj=skuList[i];
                            Contact_Sku__c contactSkuObj=new Contact_Sku__c();
                            contactSkuObj.SKU__c=skuObj.id;
                            System.debug('email : '+email);
                            System.debug('mapOpportunutyAccCombinationKey : '+mapOpportunutyAccCombinationKey.get(skuObj.New_Combination_Key_for_SWAL__c+email));
                            String nameEmailStr1=mapOpportunutyAccCombinationKey.get(skuObj.New_Combination_Key_for_SWAL__c+email); //get value of sku
                            System.debug('mapNameEmailSku get : '+mapNameEmail.get(nameEmailStr1));
                            contactSkuObj.Account__c=mapNameEmail.get(nameEmailStr1);// pass nameEmailStr1 value in mapNameEmail
                            if(mapNameEmail.containsKey(nameEmailStr1)){
                                contactSkuInsertList.add(contactSkuObj);
                            }  //end sku
                        }
                        //end of sku for loop
                        //Start of CPP for loop
                        for(Integer i=0;i<cpList.size();i++){
                            String TempEmail=mapNameEmailList[i];
                            //start CPP
                            Competitor_Product__c cpObj=cpList[i];
                            Contact_Competitor_Product__c cppObj=new Contact_Competitor_Product__c();
                            cppObj.Competitor_Product__c=cpObj.id;
                            System.debug('email : '+email);
                            System.debug('mapCombinationKey : '+mapCombinationKey.get(cpObj.Combination_Key__c));
                            String nameEmailStr=mapCombinationKey.get(cpObj.Combination_Key__c+email);
                            System.debug('mapNameEmailSku get : '+mapNameEmail.get(nameEmailStr));
                            cppObj.Account__c=mapNameEmail.get(nameEmailStr);
                            if(mapNameEmail.containsKey(nameEmailStr)){
                                ccpInsertList.add(cppObj);
                            }
                            //start CPP
                        }
                        //end of CPP for loop
                    } */
                    
                    
                    for(Integer i=0;i<cpList.size();i++){
                        Competitor_Product__c cpObj=cpList[i];
                        for(String email:mapNameEmailList){
                            System.debug('Productemail : '+email);
                            if(mapCombinationKey.containsKey(cpObj.Combination_Key__c+email)){
                                String nameEmailStr=mapCombinationKey.get(cpObj.Combination_Key__c+email);
                                 if(mapNameEmail.containsKey(nameEmailStr)){
                                      Contact_Competitor_Product__c cppObj=new Contact_Competitor_Product__c();
                                     cppObj.Competitor_Product__c=cpObj.id;
                                     cppObj.Account__c=mapNameEmail.get(nameEmailStr);
                                     ccpInsertList.add(cppObj);
                                 }
                            } 
                        }
                    }
                    Set<Contact_Competitor_Product__c> setccpInsertList = new Set<Contact_Competitor_Product__c>();
                    setccpInsertList.addAll(ccpInsertList);
                    ccpInsertList=new List<Contact_Competitor_Product__c>(setccpInsertList);
                    insert ccpInsertList;  
                    System.debug('ccpInsertList size : '+ccpInsertList.size());
                    System.debug('ccpInsertList : '+ccpInsertList);
                    
                    for(Integer i=0;i<skuList.size();i++){
                        SKU__c skuObj=skuList[i];
                        for(String email:mapNameEmailList){
                            if(mapOpportunutyAccCombinationKey.containsKey(skuObj.New_Combination_Key_for_SWAL__c+email)){
                                String nameEmailStr1=mapOpportunutyAccCombinationKey.get(skuObj.New_Combination_Key_for_SWAL__c+email); //get value of sku
                                if(mapNameEmail.containsKey(nameEmailStr1)){
                                    Contact_Sku__c contactSkuObj=new Contact_Sku__c();
                                    contactSkuObj.SKU__c=skuObj.id;
                                    contactSkuObj.Account__c=mapNameEmail.get(nameEmailStr1);// pass nameEmailStr1 value in mapNameEmail
                                    contactSkuInsertList.add(contactSkuObj);
                                } 
                            }
                        }
                    }
                   
                    
                    Set<Contact_Sku__c> setcontactSkuInsertList = new Set<Contact_Sku__c>();
                    setcontactSkuInsertList.addAll(contactSkuInsertList);
                    contactSkuInsertList=new List<Contact_Sku__c>(setcontactSkuInsertList);
                    insert contactSkuInsertList;  
                    System.debug('contactSkuInsertList size : '+contactSkuInsertList.size());
                    System.debug('contactSkuInsertList : '+contactSkuInsertList);  
                }
                
                catch(Exception ex)
                {
                    returnresponse = 'ERROR';
                }
                System.debug('@srList : '+srList.size());
                System.debug('@srList : '+srList);

                //Iterate through each returned result
                for(Integer i=0;i<srList.size();i++){
                    if (!srList[i].isSuccess()){
                        Database.Error[] errs = srList[i].getErrors();
                        
                        errorCSVList.add(datalist[i].SalesOrgCode+','+ datalist[i].DistributionChannel+','+ datalist[i].Division+','+ datalist[i].CurrencyIsoCode+','+datalist[i].Name+','+ datalist[i].Street+','+datalist[i].PostalCode+','+datalist[i].City+','+datalist[i].Province+','+datalist[i].Country+','+datalist[i].Email+','+datalist[i].Phone+','+datalist[i].Kind+','+datalist[i].ProductsConsumed+','+datalist[i].Priority+','+datalist[i].Comments+','+datalist[i].Opportunity+','+errs[0].getMessage());
                    }
                    else{
                        successCSVList.add(accountList[i].get('Id')+','+datalist[i].SalesOrgCode+','+ datalist[i].DistributionChannel+','+ datalist[i].Division+','+datalist[i].CurrencyIsoCode+','+datalist[i].Name+','+ datalist[i].Street+','+datalist[i].PostalCode+','+datalist[i].City+','+datalist[i].Province+','+datalist[i].Country+','+datalist[i].Email+','+datalist[i].Phone+','+datalist[i].Kind+','+datalist[i].ProductsConsumed+','+datalist[i].Priority+','+datalist[i].Comments+','+datalist[i].Opportunity);
                    }
                }
            }
            System.debug('errorCSVList : '+errorCSVList);
            System.debug('successCSVList : '+successCSVList);
        }
        
        
        //**********************Update Customer Segmentation*********************************************
        if(selectAccountType=='Update Customer Segmentation'){
            //Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Prospect_Iberia').getRecordTypeId();
            successsListFirstRow='SalesOrgCode,SAPCode,RelationshipProfile,MarketSalesProfile,ClassicalClassification,CropFocus,MarketAccessibility';
            errorListFirstRow='SalesOrgCode,SAPCode,RelationshipProfile,MarketSalesProfile,ClassicalClassification,CropFocus,MarketAccessibility';
            successCSVList.add('Record ID,'+successsListFirstRow);
            errorCSVList.add(errorListFirstRow+',Error Description');
            
            if(datalist.size()>0){
                
                
                for(Integer j=0; j<datalist.size(); j++){
                    Account accObj =new  Account();
                    String lastFourDigits ='';     //substring containing last 4 characters
                    System.debug('j : '+j);
                    System.debug('@Cust segment SalesOrgCode : '+datalist[j].SalesOrgCode);
                    
                    System.debug('@Cust segment SalesOrgCode : '+datalist[j].SalesOrgCode);
                    
                    
                    if(String.isNotBlank(datalist[j].SalesOrgCode)){
                        accObj.Sales_Org__r = new Sales_Org__c(Sales_Org_Code__c = datalist[j].SalesOrgCode);
                        //accObj.Sales_Org__c=mapStrSalesOrgId.get(datalist[j].SalesOrgCode);
                    }
                    
                    if(String.isNotBlank(datalist[j].SAPCode)){
                        String sapCodeStr=datalist[j].SAPCode;
                        if(sapCodeStr.length()==7){
                            sapCodeStr='000'+datalist[j].SAPCode;
                        }
                        if(mapAccId.containsKey(sapCodeStr)){
                        accObj.Id =mapAccId.get(sapCodeStr);
                        }
                        else{
                           System.debug('Error : '+sapCodeStr); 
                        }
                        
                    }
                    
                    if(String.isNotBlank(datalist[j].RelationshipProfile)){
                        accObj.Relationship_profile__c =datalist[j].RelationshipProfile;  
                    }
                    
                    if(String.isNotBlank(datalist[j].MarketSalesProfile)){
                        accObj.Market_sales_profile__c =datalist[j].MarketSalesProfile;  
                    }  
                    if(String.isNotBlank(datalist[j].ClassicalClassification)){
                        accObj.Classical_Classification__c =datalist[j].ClassicalClassification;  
                    }
                    
                    if(String.isNotBlank(datalist[j].CropFocus)){
                        accObj.Crop_focus__c =datalist[j].CropFocus;  
                    } 
                    
                    if(String.isNotBlank(datalist[j].MarketAccessibility)){
                        accObj.Market_accessibility__c =datalist[j].MarketAccessibility;  
                    }
                    
                    //accObj.RecordTypeId=accRecordTypeId;
                    
                    if(String.isNotBlank(datalist[j].SAPCode)){
                        String sapCodeStr=datalist[j].SAPCode;
                        if(sapCodeStr.length()==7){
                            sapCodeStr='000'+datalist[j].SAPCode;
                        }
                        if(mapAccId.containsKey(sapCodeStr)){
                            system.debug('accObj>>--->'+accObj);
                            accountList.add(accObj);
                        }
                    }
                }
                
            }
            Database.SaveResult[] srList;
            system.debug('accountList >>--->'+accountList);
            if(accountList.size()>0){
                try {
                    srList = Database.update(accountList, false);
                    System.debug('@srList : '+srList);
                    returnresponse = 'SUCCESS';
                }
                catch(Exception ex)
                {
                    returnresponse = 'ERROR';
                }
                //Iterate through each returned result
                for(Integer i=0;i<srList.size();i++){
                    if (!srList[i].isSuccess()){
                        Database.Error[] errs = srList[i].getErrors();
                        errorCSVList.add(datalist[i].SalesOrgCode+','+datalist[i].SAPCode+','+datalist[i].RelationshipProfile+','+datalist[i].MarketSalesProfile+','+datalist[i].ClassicalClassification+','+datalist[i].CropFocus+','+datalist[i].MarketAccessibility+','+errs[0].getMessage());
                    }
                    else{
                        successCSVList.add(accountList[i].get('Id')+','+datalist[i].SalesOrgCode+','+datalist[i].SAPCode+','+datalist[i].RelationshipProfile+','+datalist[i].MarketSalesProfile+','+datalist[i].ClassicalClassification+','+datalist[i].CropFocus+','+datalist[i].MarketAccessibility);
                    }
                }
            }
            System.debug('errorCSVList : '+errorCSVList);
            System.debug('successCSVList : '+successCSVList);
        }
        
        //*********************Insert Farmer Account**************************
        if(selectAccountType=='Insert Farmer Account'){
            // Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Farmer').getRecordTypeId();
            Id contactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Farmer').getRecordTypeId();
            successsListFirstRow='salesOrgCode,DistributionChannel,Division,Opportunity,SAPCustomerCode,CurrencyIsoCode,Name,Street,PostalCode,City,Province,Country,Email,Phone,Kind,ProductsConsumed,Priority,Crop,CropHa,Comments';
            errorListFirstRow='salesOrgCode,DistributionChannel,Division,Opportunity,SAPCustomerCode,CurrencyIsoCode,Name,Street,PostalCode,City,Province,Country,Email,Phone,Kind,ProductsConsumed,Priority,Crop,CropHa,Comments';
            successCSVList.add('Record ID,'+successsListFirstRow);
            errorCSVList.add(errorListFirstRow+',Error Description');
            // changes made by vishal UPL-CR131  changes from 2520 to 2481
            List<Account> ConAccSapCodeList=[SELECT ID,Name, Email__c, SAP_Code__c From Account where RecordType.Name='Distributor' AND (Sales_Org__r.Sales_Org_Code__c='2510' OR Sales_Org__r.Sales_Org_Code__c='2481'OR Sales_Org__r.Sales_Org_Code__c='2541' ) ];
            system.debug('@Farmer ConAccSapCodeList = ' + ConAccSapCodeList);
            for(Account accOb:ConAccSapCodeList){
                mapAccConId.put(accOb.SAP_Code__c, accOb.id);
            }
            
            system.debug('@Farmer mapAccConId = ' + mapAccConId);
            if(datalist.size()>0){
                for(Integer j=0; j<datalist.size(); j++){
                    Account accContObj=new Account();
                    //system.debug('farmer accContObj>>--->'+accContObj);
                    Contact conObj =new Contact();
                    //system.debug('farmer conObj>>--->'+ conObj);
                    String lastFourDigits ='';     //substring containing last 4 characters
                    System.debug('j : '+j);
                    System.debug('@farmer SalesOrgCode : '+datalist[j].SalesOrgCode);
                    /*
if(String.isNotBlank(datalist[j].SalesOrgCode)){
accContObj.Sales_Org__r = new Sales_Org__c(Sales_Org_Code__c = datalist[j].SalesOrgCode);

//accObj.Sales_Org__c=mapStrSalesOrgId.get(datalist[j].SalesOrgCode);
}


if(String.isNotBlank(datalist[j].SAPCustomerCode)){
String sapCodeStr=datalist[j].SAPCustomerCode;
if(sapCodeStr.length()==7){
sapCodeStr='000'+datalist[j].SAPCustomerCode;
}
accContObj.Id =mapAccId.get(sapCodeStr);
System.debug('@farmer sapCodeStr : '+sapCodeStr);
// accObj.SAP_Code__c =datalist[j].SAPCustomerCode;  
}
System.debug('@farmer SAPCustomerCode : '+datalist[j].SAPCustomerCode);
*/
                    if(String.isNotBlank(datalist[j].SalesOrgCode)){
                        conObj.Sales_Org__r = new Sales_Org__c(Sales_Org_Code__c = datalist[j].SalesOrgCode);
                        salesOrgCode=datalist[j].SalesOrgCode;
                    }
                    
                    if(String.isNotBlank(datalist[j].DistributionChannel)){
                        // accObj.Distribution_Channel__r = new Distribution_Channel__c(Distribution_Channel_Code__c = datalist[j].DistributionChannel);
                        distributionChannelCode=datalist[j].DistributionChannel;
                    }
                    
                    
                    if(String.isNotBlank(datalist[j].Division)){
                        //accObj.Division__r = new Division__c(Division_Code__c = datalist[j].Division);
                        divisionCode=datalist[j].Division;
                    }
                    
                    if(String.isNotBlank(datalist[j].Opportunity)){
                        
                        for(String key:datalist[j].Opportunity.split('\\$')) {
                            
                            system.debug('@Farmer Beforekey>>--->'+key);
                            if(key.length()==6){
                                key = '000000000000'+Key;
                                system.debug('@Farmer ifkey6>>--->'+key);  
                            }
                            else if(key.length()==7){
                                key = '00000000000'+Key;
                                system.debug('@Farmer ifkey7>>--->'+key);
                            }
                            system.debug('@Farmer keySKU>>--->'+key);
                            System.debug('@Farmer farmerName : '+datalist[j].Name.toLowercase());
                            System.debug('@Farmer farmerEmail : '+datalist[j].Email.toLowercase());
                            
                            String farmerName=datalist[j].Name;
                            String farmerEmail=datalist[j].Email;
                            skuCode=Key;
                            String compositeKey='';
                            compositeKey=salesOrgCode + distributionChannelCode + divisionCode +skuCode ;
                            SkuCompositeKey.add(compositeKey);
                            System.debug('SkuCompositeKey : '+SkuCompositeKey);
                            
                            mapOpportunutyAccCombinationKey.put(compositeKey+farmerEmail.toLowercase(),farmerEmail.toLowercase());
                            system.debug('@Farmer mapOpportunutyAccCombinationKey>>--->'+mapOpportunutyAccCombinationKey);
                            //setOpportunity.add(key);
                        }
                        
                    }
                    
                    if(String.isNotBlank(datalist[j].SAPCustomerCode)){
                        system.debug('datalist[j].SAPCode = ' + datalist[j].SAPCustomerCode);
                        String sapCodeStr=datalist[j].SAPCustomerCode;
                        if(sapCodeStr.length()==7){
                            sapCodeStr='000'+datalist[j].SAPCustomerCode;
                            system.debug('sapCodeStr = ' + sapCodeStr);
                        }
                        conObj.AccountId =mapAccConId.get(sapCodeStr);
                        //system.debug('@Farmer AccountId = ' + conObj.AccountId);
                        system.debug('@Farmer mapAccConId.get(sapCodeStr) = ' + mapAccConId.get(sapCodeStr));
                    }
                    
                    if(String.isNotBlank(datalist[j].CurrencyIsoCode)){
                        conObj.CurrencyIsoCode =datalist[j].CurrencyIsoCode;  
                    }
                    
                    
                    if(String.isNotBlank(datalist[j].Name)){
                        conObj.LastName =datalist[j].Name;  
                    }  
                    if(String.isNotBlank(datalist[j].Street)){
                        conObj.MailingStreet =datalist[j].Street;  
                    }
                    
                    if(String.isNotBlank(datalist[j].PostalCode)){
                        conObj.MailingPostalCode =datalist[j].PostalCode;  
                    }
                    if(String.isNotBlank(datalist[j].City)){
                        conObj.MailingCity =datalist[j].City;  
                    }
                    if(String.isNotBlank(datalist[j].Province)){
                        conObj.Province__c =datalist[j].Province;  
                    }
                    
                    
                    if(String.isNotBlank(datalist[j].Country)){
                        conObj.MailingCountry=datalist[j].Country;  
                    }
                    
                    if(String.isNotBlank(datalist[j].Email)){
                        conObj.Email =datalist[j].Email;  
                    }
                    
                    
                    if(String.isNotBlank(datalist[j].Phone)){
                        conObj.Phone =datalist[j].Phone;  
                    }
                    
                    if(String.isNotBlank(datalist[j].Kind)){
                        conObj.Kind__c =datalist[j].Kind;  
                    }
                    
                    if(String.isNotBlank(datalist[j].ProductsConsumed)){
                        
                        for(String key:datalist[j].ProductsConsumed.split('\\$'))
                        {
                            System.debug('@Farmer NAme : '+datalist[j].Name.toLowercase());
                            System.debug('@Farmer Email : '+datalist[j].Email.toLowercase());
                            System.debug('@Farmer key : '+key);
                            String farmerName=datalist[j].Name;
                            String farmerEmail=datalist[j].Email;
                            
                            mapCombinationKey.put(key+farmerEmail.toLowercase(),farmerEmail.toLowercase());
                            setProductConsumed.add(key);
                            System.debug('@Farmer mapCombinationKey : '+mapCombinationKey);
                        }
                        
                        //conObj.Products_Consumed__r =new Competitor_Product__c(Brand_Code__c = datalist[j].ProductsConsumed);  
                    }
                    
                    if(String.isNotBlank(datalist[j].Priority)){
                        conObj.Priority__c =datalist[j].Priority;  
                    }
                    if(String.isNotBlank(datalist[j].Crop)){
                        //conObj.Crop_Codes__c =datalist[j].Crop;
                        for(String cropCode:datalist[j].Crop.split('\\$'))
                        {
                            System.debug('@Farmer NAme : ' + datalist[j].Name.toLowercase());
                            System.debug('@Farmer Email : ' + datalist[j].Email.toLowercase());
                            
                            String farmerName=datalist[j].Name;
                            String farmerEmail=datalist[j].Email;
                            
                            CropCompositeKey=cropCode+salesOrgCode;
                            System.debug('@CropCompositeKey : ' + CropCompositeKey);
                            cropCodeList.add(cropCode);
                            System.debug('@cropCodeList : ' + cropCodeList);
                            cropMapCombinationKey.put(CropCompositeKey+farmerEmail.toLowercase(),farmerEmail.toLowercase());
                            System.debug('@Farmer cropMapCombinationKey : '+cropMapCombinationKey);
                        }
                        
                    }
                    
                    if(datalist[j].CropHa !=null){
                        conObj.Crop_Ha__c =datalist[j].CropHa;  
                    }
                    if(String.isNotBlank(datalist[j].Comments)){
                        conObj.Comments__c =datalist[j].Comments;  
                    }
                    
                    
                    conObj.RecordTypeId=contactRecordTypeId;
                    system.debug('@FarmerconObj>>--->'+conObj);
                    contactList.add(conObj);
                    system.debug('@farmer contactList >>--->'+contactList);
                }
                cpList=[Select id, Combination_Key__c from Competitor_Product__c Where Combination_Key__c IN:setProductConsumed];
                // changes made by vishal UPL-CR131  changes from 2520 to 2481
                skuList=[Select id, Combination_Key__c,SKU_Code__c,New_Combination_Key_for_SWAL__c from
                         SKU__c Where (Sales_Org_Code__c='2510' OR Sales_Org_Code__c='2481' OR Sales_Org_Code__c='2541') AND New_Combination_Key_for_SWAL__c IN:SkuCompositeKey];
                cropList= [SELECT Id, Name, Crop_Code__c, Sales_Org_Code__c FROM Crop__c Where (Sales_Org_Code__c='2510') AND Crop_Code__c IN:cropCodeList];
            }
            Database.SaveResult[] srList;
            
            if(contactList.size()>0){
                try {
                    srList = Database.insert(contactList, false);
                    returnresponse = 'SUCCESS';
                    List<Contact> conSapCodeList=[SELECT ID,Name,Email From Contact where RecordType.Name='Farmer'];
                    String conName='';
                    String conEmail='';
                    
                    for(Contact conOb:conSapCodeList){
                        conName=conOb.Name.toLowercase();
                        
                        if(conOb.Email!=null){
                            conEmail=conOb.Email.toLowercase();
                        }
                        mapNameEmail.put(conEmail,conOb.Id);
                        System.debug('@Farmer mapNameEmail : '+mapNameEmail);
                    }
                    
                    List<String> mapNameEmailList=new List<String>(mapNameEmail.keySet());
                    System.debug('mapNameEmailList : '+mapNameEmailList);
                    /*for(String email:mapNameEmailList){
                        //Start of sku for loop
                        System.debug('SKUemail : '+email);
                        System.debug('skuList.size : '+skuList.size());
                        System.debug('skuList : '+ skuList);
                        for(Integer i=0;i<skuList.size();i++){
                            
                            String TempEmail=mapNameEmailList[i];
                            //start sku
                            SKU__c skuObj=skuList[i];
                            Contact_Sku__c contactSkuObj=new Contact_Sku__c();
                            contactSkuObj.SKU__c=skuObj.id;
                            
                            System.debug('mapOpportunutyAccCombinationKey : ' + mapOpportunutyAccCombinationKey.get(skuObj.New_Combination_Key_for_SWAL__c+email));
                            String nameEmailStr1=mapOpportunutyAccCombinationKey.get(skuObj.New_Combination_Key_for_SWAL__c+email); //get value of sku
                            System.debug('nameEmailStr1 : '+nameEmailStr1);
                            System.debug('mapNameEmailSku get : '+mapNameEmail.get(nameEmailStr1));
                            contactSkuObj.Contact__c=mapNameEmail.get(nameEmailStr1);// pass nameEmailStr1 value in mapNameEmail
                            if(mapNameEmail.containsKey(nameEmailStr1)){
                                contactSkuInsertList.add(contactSkuObj);
                            }  //end sku
                        }
                        //end of sku for loop
                        //Start of CPP for loop
                        for(Integer i=0;i<cpList.size();i++){
                            String TempEmail=mapNameEmailList[i];
                            //start CPP
                            Competitor_Product__c cpObj=cpList[i];
                            Contact_Competitor_Product__c cppObj=new Contact_Competitor_Product__c();
                            cppObj.Competitor_Product__c=cpObj.id;
                            System.debug('Productemail : '+email);
                            System.debug('mapCombinationKey : '+mapCombinationKey.get(cpObj.Combination_Key__c+email));
                            String nameEmailStr=mapCombinationKey.get(cpObj.Combination_Key__c+email);
                            System.debug('nameEmailStr : '+nameEmailStr);
                            System.debug('mapNameEmailSku get : '+mapNameEmail.get(nameEmailStr));
                            cppObj.Contact__c=mapNameEmail.get(nameEmailStr);
                            if(mapNameEmail.containsKey(nameEmailStr)){
                                ccpInsertList.add(cppObj);
                            }
                            //start CPP
                        }
                        //end of CPP for loop
                        
                        
                        //Start of Crop for loop
                        for(Integer i=0;i<cropList.size();i++){
                            String TempEmail=mapNameEmailList[i];
                            //start Crop
                            Crop__c cropObj=cropList[i];
                            Contact_Crop__c conCropObj=new Contact_Crop__c();
                            conCropObj.Crop__c=cropObj.id;
                            System.debug('Cropemail : '+email);
                            System.debug('cropMapCombinationKey : '+cropMapCombinationKey.get(cropObj.Crop_Code__c+salesOrgCode+email));
                            String nameEmailStr3=cropMapCombinationKey.get(cropObj.Crop_Code__c+salesOrgCode+email);
                            System.debug('nameEmailStr3 : '+nameEmailStr3);
                            System.debug('crop mapNameEmailSku get : '+mapNameEmail.get(nameEmailStr3));
                            conCropObj.Contact__c=mapNameEmail.get(nameEmailStr3);
                            if(mapNameEmail.containsKey(nameEmailStr3)){
                                contactCropInsertList.add(conCropObj);
                            }
                            //start Crop
                        }
                        //end of Crop for loop  
                        
                    }*/
                    
                    System.debug('skuList.size : '+skuList.size());
                    for(Integer i=0;i<skuList.size();i++){
                        SKU__c skuObj=skuList[i];
                        for(String email:mapNameEmailList){
                            if(mapOpportunutyAccCombinationKey.containsKey(skuObj.New_Combination_Key_for_SWAL__c+email)){
                                String nameEmailStr1=mapOpportunutyAccCombinationKey.get(skuObj.New_Combination_Key_for_SWAL__c+email); //get value of sku
                                if(mapNameEmail.containsKey(nameEmailStr1)){
                                    Contact_Sku__c contactSkuObj=new Contact_Sku__c();
                                    contactSkuObj.SKU__c=skuObj.id;
                                    contactSkuObj.Contact__c=mapNameEmail.get(nameEmailStr1);// pass nameEmailStr1 value in mapNameEmail
                                    contactSkuInsertList.add(contactSkuObj);
                                } 
                            }
                        }
                    }
                    System.debug('contactSkuInsertList : '+contactSkuInsertList);
                    Set<Contact_Sku__c> setcontactSkuInsertList = new Set<Contact_Sku__c>();
                    setcontactSkuInsertList.addAll(contactSkuInsertList);
                    contactSkuInsertList=new List<Contact_Sku__c>(setcontactSkuInsertList);
                    insert contactSkuInsertList;  
                    System.debug('contactSkuInsertList size : '+contactSkuInsertList.size());
                    System.debug('contactSkuInsertList : '+contactSkuInsertList);
                    
                    for(Integer i=0;i<cpList.size();i++){
                        Competitor_Product__c cpObj=cpList[i];
                        for(String email:mapNameEmailList){
                            System.debug('Productemail : '+email);
                            if(mapCombinationKey.containsKey(cpObj.Combination_Key__c+email)){
                                String nameEmailStr=mapCombinationKey.get(cpObj.Combination_Key__c+email);
                                if(mapNameEmail.containsKey(nameEmailStr)){
                                    Contact_Competitor_Product__c cppObj=new Contact_Competitor_Product__c();
                                    cppObj.Competitor_Product__c=cpObj.id;
                                    cppObj.Contact__c=mapNameEmail.get(nameEmailStr);
                                    ccpInsertList.add(cppObj);
                                }
                            }
                        }
                    }
                    
                    Set<Contact_Competitor_Product__c> setccpInsertList = new Set<Contact_Competitor_Product__c>();
                    setccpInsertList.addAll(ccpInsertList);
                    ccpInsertList=new List<Contact_Competitor_Product__c>(setccpInsertList);
                    insert ccpInsertList;  
                    System.debug('ccpInsertList size : '+ccpInsertList.size());
                    System.debug('ccpInsertList : '+ccpInsertList);
                    
                    for(Integer i=0;i<cropList.size();i++){
                        Crop__c cropObj=cropList[i];
                        for(String email:mapNameEmailList){
                            if(cropMapCombinationKey.containsKey(cropObj.Crop_Code__c+salesOrgCode+email)){
                                String nameEmailStr3=cropMapCombinationKey.get(cropObj.Crop_Code__c+salesOrgCode+email);
                                if(mapNameEmail.containsKey(nameEmailStr3)){
                                    Contact_Crop__c conCropObj=new Contact_Crop__c();
                                    conCropObj.Crop__c=cropObj.id;
                                    conCropObj.Contact__c=mapNameEmail.get(nameEmailStr3);
                                    contactCropInsertList.add(conCropObj);
                                }
                            }
                        }
                    }
                    Set<Contact_Crop__c> setcontactCropInsertList = new Set<Contact_Crop__c>();
                    setcontactCropInsertList.addAll(contactCropInsertList);
                    contactCropInsertList=new List<Contact_Crop__c>(setcontactCropInsertList);
                    insert contactCropInsertList;  
                    System.debug('contactCropInsertList size : '+contactCropInsertList.size());
                    System.debug('contactCropInsertList : '+contactCropInsertList);
                }
                catch(Exception ex)
                {
                    returnresponse = 'ERROR';
                }
                //Iterate through each returned result
                for(Integer i=0;i<srList.size();i++){
                    if (!srList[i].isSuccess()){
                        Database.Error[] errs = srList[i].getErrors();
                        errorCSVList.add(datalist[i].salesOrgCode+','+datalist[i].DistributionChannel+','+datalist[i].Division+','+datalist[i].Opportunity+','+datalist[i].SAPCustomerCode+','+datalist[i].CurrencyIsoCode+','+datalist[i].Name+','+ datalist[i].Street+','+datalist[i].PostalCode+','+datalist[i].City+','+datalist[i].Province+','+datalist[i].Country+','+datalist[i].Email+','+datalist[i].Phone+','+datalist[i].Kind+','+datalist[i].ProductsConsumed+','+datalist[i].Priority+','+datalist[i].Crop+','+datalist[i].CropHa+','+datalist[i].Comments+','+errs[0].getMessage());
                    }
                    else{
                        successCSVList.add(contactList[i].get('Id')+','+datalist[i].salesOrgCode+','+datalist[i].DistributionChannel+','+datalist[i].Division+','+datalist[i].Opportunity+','+datalist[i].SAPCustomerCode+','+datalist[i].CurrencyIsoCode+','+datalist[i].Name+','+ datalist[i].Street+','+datalist[i].PostalCode+','+datalist[i].City+','+datalist[i].Province+','+datalist[i].Country+','+datalist[i].Email+','+datalist[i].Phone+','+datalist[i].Kind+','+datalist[i].ProductsConsumed+','+datalist[i].Priority+','+datalist[i].Crop+','+datalist[i].CropHa+','+datalist[i].Comments);
                    }
                }
            }
            System.debug('errorCSVList : '+errorCSVList);
            System.debug('successCSVList : '+successCSVList);
        }
        sendEmail(String.join(successCSVList, '\r\n'), String.join(errorCSVList, '\r\n'), successCSVList.size(), errorCSVList.size(),'SKUUploadFile');
        return returnresponse;
    }
    
    
    //Method to Notify User with Success/Error Files after Upload
    public static void sendEmail(String successFile, String errorFile, Integer successCount, Integer errorCount, String SKUUploadFile){
        Messaging.EmailFileAttachment successAttach = new Messaging.EmailFileAttachment();
        successAttach.setContentType('application/csv');
        successAttach.setFileName('Success.csv');
        successAttach.setInline(false);
        successAttach.Body = Blob.valueOf(successFile);
        Messaging.EmailFileAttachment errorAttach = new Messaging.EmailFileAttachment();
        errorAttach.setContentType('application/csv');
        errorAttach.setFileName('Error.csv');
        errorAttach.setInline(false);
        errorAttach.Body = Blob.valueOf(errorFile);
        
        DateTime d = Date.Today() ;
        String dateString =  d.format('dd/MM/yyyy') ;
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setUseSignature(false);
        mail.setToAddresses(new String[] { UserInfo.getUserEmail()});
        
        if(SKUUploadFile=='SKUUploadFile'){
            mail.setSubject('Estado de carga masiva en España y Portugal');
            mail.setHtmlBody('Querido/a usuario/a,<br /><br />Por favor vea adjuntos los ficheros generados en SFDC mientras se cargan los datos.<br /><br />Fecha:: '+dateString+'<br /><br />Número de registros erróneos: '+errorCount+'<br /><br />Saludos,<br/>Administrador UPL de SalesForce<br />');
        }
        
        mail.setFileAttachments(new Messaging.EmailFileAttachment[] { successAttach, errorAttach});
        
        // Send the email
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
    
    public class fieldWrapper {
        @AuraEnabled public String Name{get;set;}
        @AuraEnabled public String Phone{get;set;}
        @AuraEnabled public String Email{get;set;}
        @AuraEnabled public String CurrencyIsoCode{get;set;}
        @AuraEnabled public String Street{get;set;}
        @AuraEnabled public String PostalCode{get;set;}
        @AuraEnabled public String City{get;set;}
        @AuraEnabled public String Province{get;set;}
        @AuraEnabled public String Country{get;set;}
        @AuraEnabled public String salesOrgCode{get;set;}
        @AuraEnabled public String DistributionChannel{get;set;}
        @AuraEnabled public String Division{get;set;}
        
        @AuraEnabled public String SapCode{get;set;}
        @AuraEnabled public String Kind{get;set;}
        @AuraEnabled public String Priority{get;set;}
        @AuraEnabled public String Comments{get;set;}
        @AuraEnabled public String ProductsConsumed{get;set;}
        @AuraEnabled public String Opportunity{get;set;}
        @AuraEnabled public String RelationshipProfile{get;set;}
        @AuraEnabled public String MarketSalesProfile{get;set;}
        @AuraEnabled public String ClassicalClassification{get;set;}
        @AuraEnabled public String CropFocus{get;set;}
        @AuraEnabled public String MarketAccessibility{get;set;}
        @AuraEnabled public String SAPCustomerCode{get;set;}
        @AuraEnabled public String Crop{get;set;}
        @AuraEnabled public Integer CropHa{get;set;}
        
        
    }
    
}