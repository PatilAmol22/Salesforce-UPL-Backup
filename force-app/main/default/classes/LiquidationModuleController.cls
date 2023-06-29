/*
Apex Class : LiquidationModuleController
Created By : Keyuri Pophale(kpophale@in.ibm.com)
*/
public without sharing class LiquidationModuleController {
    
    @AuraEnabled
    public static String passFileAura(String file,String ftype,String distributor,String year,String month,String cdate){
        system.debug('ftype:'+ftype+'distributor:'+distributor+'year:'+year+'month:'+month+'cdate:'+cdate);
        String []filelines;
        //String myFile = EncodingUtil.urlDecode(file, 'UTF-8');
        List<string> inputvalues = new list<string>();
        filelines = file.split('\n');
        system.debug('file'+file);
        Account account = [SELECT id,SAP_Code__c FROM Account where id =: distributor LIMIT 1];
        List<Distributor_SKU_Mapping__c> distSKUMappingList = [SELECT id,Name,CurrencyIsoCode,Sales_Org__c,Sales_Org__r.Sales_Org_Code__c,Valid_from__c, Valid_To__c, Conversion_Quantity__c, SKU__c, SKU_Name__c, SKUCode__c, 
                                                               Distributor_SKU_Code__c,Distributor_SKU_Name__c, DistributorSAPCode__c,Distributor_City__c,Distributor_City_Code__c,Unit_Price__c,Distributor_Sales_Office_Code__c,Distributor_Sales_Office_Name__c,UPL_Sales_Office_Name__c,UPL_Sales_Office_Code__c 
                                                               FROM Distributor_SKU_Mapping__c
                                                               WHERE Sales_Org__r.Sales_Org_Code__c = '5661' AND DistributorSAPCode__c =: account.SAP_Code__c];
        
        system.debug('distSKUMappingList::'+distSKUMappingList);
        //Map of distributor sku code-sales office and related distributorSKU mapping record
        Map<String,List<Distributor_SKU_Mapping__c>> distSKUMappingMap = new Map<String,List<Distributor_SKU_Mapping__c>>();
        if(distSKUMappingList.size() > 0){
            for(Distributor_SKU_Mapping__c distSKU : distSKUMappingList){
                if(distSKUMappingMap.containsKey(distSKU.Distributor_SKU_Code__c+'-'+distSKU.Distributor_Sales_Office_Code__c+'-'+distSKU.Distributor_City_Code__c))
                    distSKUMappingMap.get(distSKU.Distributor_SKU_Code__c+'-'+distSKU.Distributor_Sales_Office_Code__c+'-'+distSKU.Distributor_City_Code__c).add(distSKU);
                else{
                    distSKUMappingMap.put(distSKU.Distributor_SKU_Code__c+'-'+distSKU.Distributor_Sales_Office_Code__c+'-'+distSKU.Distributor_City_Code__c,new List<Distributor_SKU_Mapping__c>{distSKU});
                }
            }
        }
        //Map of distributor sku code and related distributorSKU mapping record
        Map<String,List<Distributor_SKU_Mapping__c>> distSKUMap = new Map<String,List<Distributor_SKU_Mapping__c>>();
        if(distSKUMappingList.size() > 0){
            for(Distributor_SKU_Mapping__c distSKU : distSKUMappingList){
                if(distSKUMap.containsKey(distSKU.Distributor_SKU_Code__c))
                    distSKUMap.get(distSKU.Distributor_SKU_Code__c).add(distSKU);
                else{
                    distSKUMap.put(distSKU.Distributor_SKU_Code__c,new List<Distributor_SKU_Mapping__c>{distSKU});
                }
            }
        }
        //Map of distributor sales office code and related distributorSKU mapping record
        Map<String,List<Distributor_SKU_Mapping__c>> distSalesOfficeMap = new Map<String,List<Distributor_SKU_Mapping__c>>();
        if(distSKUMappingList.size() > 0){
            for(Distributor_SKU_Mapping__c distSKU : distSKUMappingList){
                if(distSalesOfficeMap.containsKey(distSKU.Distributor_Sales_Office_Code__c))
                    distSalesOfficeMap.get(distSKU.Distributor_Sales_Office_Code__c).add(distSKU);
                else{
                    distSalesOfficeMap.put(distSKU.Distributor_Sales_Office_Code__c,new List<Distributor_SKU_Mapping__c>{distSKU});
                }
            }
        }
        //Map of distributor city code and related distributorSKU mapping record
        Map<String,List<Distributor_SKU_Mapping__c>> distCityMap = new Map<String,List<Distributor_SKU_Mapping__c>>();
        if(distSKUMappingList.size() > 0){
            for(Distributor_SKU_Mapping__c distSKU : distSKUMappingList){
                if(distCityMap.containsKey(distSKU.Distributor_City_Code__c))
                    distCityMap.get(distSKU.Distributor_City_Code__c).add(distSKU);
                else{
                    distCityMap.put(distSKU.Distributor_City_Code__c,new List<Distributor_SKU_Mapping__c>{distSKU});
                }
            }
        }
        
        List<ErrorWrapper> errorList = new List<ErrorWrapper>();
        try{
            if(ftype == 'Sales'){
                Map<String,Secondary_Sales_Data__c> productBranchMap = new Map<String,Secondary_Sales_Data__c>();
                for (Integer i=1;i<filelines.size();i++)
                {
                    inputvalues = filelines[i].split(',');
                    Secondary_Sales_Data__c ssData;
                    if(distSKUMappingMap.containsKey(inputvalues[0].trim()+'-'+inputvalues[2].trim()+'-'+inputvalues[5].trim())){
                        List<Distributor_SKU_Mapping__c> distSKUListToUpsert = distSKUMappingMap.get(inputvalues[0].trim()+'-'+inputvalues[2].trim()+'-'+inputvalues[5].trim());
                        //maintain a map for product-branch and respective quanity
                        Boolean validFlag = false;
                        for(Distributor_SKU_Mapping__c distSKU : distSKUListToUpsert){
                            if(((distSKU.Valid_from__c).month() <= Integer.valueOf(month) && Integer.valueOf(month) <= (distSKU.Valid_To__c).month()) && 
                               ((distSKU.Valid_from__c).year() <= Integer.valueOf(year) && Integer.valueOf(year) <= (distSKU.Valid_To__c).year())){
                                   //if no data in product-branch map create ssData with all fields
                                   //else if it is already in map add the quantities
                                   validFlag = true;
                                   if(productBranchMap.containsKey(inputvalues[0].trim()+'-'+inputvalues[2].trim()+'-'+inputvalues[5].trim())){
                                       system.debug('ssDatainbefore::'+productBranchMap);
                                       ssData = productBranchMap.get(inputvalues[0].trim()+'-'+inputvalues[2].trim()+'-'+inputvalues[5].trim());
                                       ssData.Product_Quantity__c = ssData.Product_Quantity__c + (distSKU.Conversion_Quantity__c*Integer.valueOf(inputvalues[6].trim()));
                                       ssData.Sell_Amount_USD__c = ssData.Product_Quantity__c*distSKU.Unit_Price__c;
                                       system.debug('ssDatainupdate::'+ssData);
                                       system.debug('ssDatainupdateafter::'+productBranchMap);
                                   }
                                   else{
                                       ssData = new Secondary_Sales_Data__c();
                                       ssData.Combination_Key__c = distSKU.DistributorSAPCode__c+inputvalues[0].trim()+inputvalues[2].trim()+inputvalues[5].trim()+month+year;
                                       ssData.Sold_To_Party__c = distributor;
                                       ssData.Sales_Org__c = distSKU.Sales_Org__c;
                                       ssData.Product_Name__c = distSKU.SKU__c;
                                       ssData.CurrencyIsoCode = distSKU.CurrencyIsoCode;
                                       ssData.Month__c = month;
                                       ssData.Year__c = year;
                                       ssData.Product_Quantity__c = distSKU.Conversion_Quantity__c*Decimal.valueOf(inputvalues[6].trim());
                                       ssData.Sell_Amount_USD__c = ssData.Product_Quantity__c*distSKU.Unit_Price__c;
                                       ssData.Mapping_Unit_Price__c = distSKU.Unit_Price__c;
                                       ssData.Sales_office__c = distSKU.UPL_Sales_Office_Name__c;
                                       ssData.City__c = distSKU.Distributor_City__c;
                                       ssData.City_Code__c = distSKU.Distributor_City_Code__c;
                                       productBranchMap.put(inputvalues[0].trim()+'-'+inputvalues[2].trim()+'-'+inputvalues[5].trim(),ssData);
                                   }
                               }
                        }
                        if(validFlag == false){
                            ErrorWrapper ewrapper = new ErrorWrapper();
                            ewrapper.productCode = inputvalues[0];
                            ewrapper.productName = inputvalues[1];
                            ewrapper.branchOfficeCode = inputvalues[2];
                            ewrapper.branchOfficeName = inputvalues[3];
                            ewrapper.cityName = inputvalues[4];
                            ewrapper.cityCode = inputvalues[5];
                            ewrapper.Quantity = inputvalues[6];
                            ewrapper.reason = 'Valid Distributor-SKU Mapping object record not found for the selected month/year '+month+'/'+year+'.';
                            errorList.add(ewrapper);
                        }
                    }
                    else{
                        Boolean salesOfficeValidFlag = false;
                        Boolean skuValidFlag = false;
                        Boolean CityValidFlag =false;
                        Boolean allInvalidFlag = false;
                        if(distSalesOfficeMap.containsKey(inputvalues[2].trim())){
                            List<Distributor_SKU_Mapping__c> distSKUList = distSalesOfficeMap.get(inputvalues[2].trim());
                            for(Distributor_SKU_Mapping__c distSKU : distSKUList){
                                if(((distSKU.Valid_from__c).month() <= Integer.valueOf(month) && Integer.valueOf(month) <= (distSKU.Valid_To__c).month()) && 
                                   ((distSKU.Valid_from__c).year() <= Integer.valueOf(year) && Integer.valueOf(year) <= (distSKU.Valid_To__c).year())){
                                       salesOfficeValidFlag = true;
                                   }
                            }
                        }
                        if(distSKUMap.containsKey(inputvalues[0].trim())){
                            List<Distributor_SKU_Mapping__c> distSKUList = distSKUMap.get(inputvalues[0].trim());
                            for(Distributor_SKU_Mapping__c distSKU : distSKUList){
                                if(((distSKU.Valid_from__c).month() <= Integer.valueOf(month) && Integer.valueOf(month) <= (distSKU.Valid_To__c).month()) && 
                                   ((distSKU.Valid_from__c).year() <= Integer.valueOf(year) && Integer.valueOf(year) <= (distSKU.Valid_To__c).year())){
                                       skuValidFlag = true;
                                   }
                            }
                        }
                        if(distCityMap.containsKey(inputvalues[5].trim())){
                            List<Distributor_SKU_Mapping__c> distSKUList = distCityMap.get(inputvalues[5].trim());
                            for(Distributor_SKU_Mapping__c distSKU : distSKUList){
                                if(((distSKU.Valid_from__c).month() <= Integer.valueOf(month) && Integer.valueOf(month) <= (distSKU.Valid_To__c).month()) && 
                                   ((distSKU.Valid_from__c).year() <= Integer.valueOf(year) && Integer.valueOf(year) <= (distSKU.Valid_To__c).year())){
                                       CityValidFlag = true;
                                   }
                            }
                        }
                        if(skuValidFlag == false && salesOfficeValidFlag == false && CityValidFlag == false)
                            allInvalidFlag = true;
                            
                        system.debug('skuValidFlag:'+skuValidFlag);
                         system.debug('salesOfficeValidFlag:'+salesOfficeValidFlag);
                         system.debug('allInvalidFlag:'+allInvalidFlag);
                        ErrorWrapper ewrapper = new ErrorWrapper();
                            ewrapper.productCode = inputvalues[0];
                            ewrapper.productName = inputvalues[1];
                            ewrapper.branchOfficeCode = inputvalues[2];
                            ewrapper.branchOfficeName = inputvalues[3];
                            ewrapper.cityName = inputvalues[4];
                            ewrapper.cityCode = inputvalues[5];
                            ewrapper.Quantity = inputvalues[6];
                        if(allInvalidFlag == true)
                        	ewrapper.reason = 'Product :'+inputvalues[1]+' : '+inputvalues[0]+' and Sales Office : '+inputvalues[3]+' : '+inputvalues[2]+'and City : '+inputvalues[4]+' : '+inputvalues[5]+' not found in the Distributor-SKU Mapping object records.';
                        else if(skuValidFlag == false)
                            	ewrapper.reason = 'Product : '+inputvalues[1]+' : '+inputvalues[0]+' not found in the Distributor-SKU Mapping object records.';
                        else if(salesOfficeValidFlag == false)
                            	ewrapper.reason = 'Sales Office : '+inputvalues[3]+' : '+inputvalues[2]+' not found in the Distributor-SKU Mapping object records.';
                        else if(CityValidFlag == false)
                            	ewrapper.reason = 'City : '+inputvalues[4]+' : '+inputvalues[5]+' not found in the Distributor-SKU Mapping object records.';
                        system.debug('wrapper::'+ewrapper);
                        errorList.add(ewrapper);
                    }
                }
                List<Secondary_Sales_Data__c> ssDataToUpsert = productBranchMap.values();
                Database.UpsertResult[] sDataUpload=  Database.upsert(ssDataToUpsert,Secondary_Sales_Data__c.Combination_Key__c,false);
                for(Integer i=0;i<sDataUpload.size();i++){
                    if (!sDataUpload.get(i).isSuccess()){
                        Database.Error err = sDataUpload.get(i).getErrors().get(0);
                        ErrorWrapper errorw = new ErrorWrapper();
                        errorw.reason='Error - '+err.getMessage() + '\nStatus Code : '+err.getStatusCode()+'\n Fields : '+err.getFields();
                        errorList.add(errorw);
                        System.debug('Error - '+err.getMessage() + '\nStatus Code : '+err.getStatusCode()+'\n Fields : '+err.getFields());
                    }
                }
            }
            else if(ftype == 'Inventory'){
                List<Inventory_POG__c> inventoryList = new List<Inventory_POG__c>();
                for (Integer i=1;i<filelines.size();i++)
                {
                    inputvalues = filelines[i].split(',');
                    Inventory_POG__c  inventoryData;
                    if(distSKUMappingMap.containsKey(inputvalues[0].trim()+'-'+inputvalues[2].trim()+'-'+inputvalues[5].trim())){
                        List<Distributor_SKU_Mapping__c> distSKUListToUpsert = distSKUMappingMap.get(inputvalues[0].trim()+'-'+inputvalues[2].trim()+'-'+inputvalues[5].trim());
                        Boolean validFlag = false;
                        for(Distributor_SKU_Mapping__c distSKU : distSKUListToUpsert){
                            if(distSKU.Valid_from__c <= Date.valueOf(cdate) && Date.valueOf(cdate) <= distSKU.Valid_To__c){
                                validFlag = true;
                                inventoryData = new Inventory_POG__c();
                                inventoryData.Combination_Key__c = distSKU.DistributorSAPCode__c+inputvalues[0].trim()+inputvalues[2].trim()+inputvalues[5].trim()+cdate;
                                inventoryData.Customer_Name__c = distributor;
                                inventoryData.Sales_Org__c = distSKU.Sales_Org__c;
                                inventoryData.SKU_Name__c = distSKU.SKU__c;
                                inventoryData.CurrencyIsoCode = distSKU.CurrencyIsoCode;
                                inventoryData.Stock_Date__c = Date.valueOf(cdate);
                                inventoryData.City__c = distSKU.Distributor_City__c;
                                inventoryData.City_Code__c = distSKU.Distributor_City_Code__c;
                                inventoryData.Stock_Quantity__c = distSKU.Conversion_Quantity__c*Decimal.valueOf(inputvalues[6].trim());
                                inventoryData.Sales_office__c = distSKU.UPL_Sales_Office_Name__c;
                                inventoryList.add(inventoryData); 
                            }
                        }
                        if(validFlag == false){
                            ErrorWrapper ewrapper = new ErrorWrapper();
                            ewrapper.productCode = inputvalues[0];
                            ewrapper.productName = inputvalues[1];
                            ewrapper.branchOfficeCode = inputvalues[2];
                            ewrapper.branchOfficeName = inputvalues[3];
                            ewrapper.cityName = inputvalues[4];
                            ewrapper.cityCode = inputvalues[5];
                            ewrapper.Quantity = inputvalues[6];
                            ewrapper.reason = 'Valid Distributor-SKU Mapping object record not found for the selected date:'+Date.valueOf(cdate)+'.';
                            errorList.add(ewrapper);
                        }
                    }
                     else{
                        Boolean salesOfficeValidFlag = false;
                        Boolean skuValidFlag = false;
                        Boolean CityValidFlag = false;
                        Boolean allInvalidFlag = false;
                        if(distSalesOfficeMap.containsKey(inputvalues[2].trim())){
                            List<Distributor_SKU_Mapping__c> distSKUList = distSalesOfficeMap.get(inputvalues[2].trim());
                            for(Distributor_SKU_Mapping__c distSKU : distSKUList){
                                if(distSKU.Valid_from__c <= Date.valueOf(cdate) && Date.valueOf(cdate) <= distSKU.Valid_To__c){
                                       salesOfficeValidFlag = true;
                                   }
                            }
                        }
                        if(distSKUMap.containsKey(inputvalues[0].trim())){
                            List<Distributor_SKU_Mapping__c> distSKUList = distSKUMap.get(inputvalues[0].trim());
                            for(Distributor_SKU_Mapping__c distSKU : distSKUList){
                                if(distSKU.Valid_from__c <= Date.valueOf(cdate) && Date.valueOf(cdate) <= distSKU.Valid_To__c){
                                       skuValidFlag = true;
                                   }
                            }
                        }
                         if(distCityMap.containsKey(inputvalues[5].trim())){
                            List<Distributor_SKU_Mapping__c> distSKUList = distCityMap.get(inputvalues[5].trim());
                            for(Distributor_SKU_Mapping__c distSKU : distSKUList){
                                if(distSKU.Valid_from__c <= Date.valueOf(cdate) && Date.valueOf(cdate) <= distSKU.Valid_To__c){
                                       CityValidFlag = true;
                                   }
                            }
                        }
                        if(skuValidFlag == false && salesOfficeValidFlag == false && CityValidFlag == false)
                            allInvalidFlag = true;

                            ErrorWrapper ewrapper = new ErrorWrapper();
                            ewrapper.productCode = inputvalues[0];
                            ewrapper.productName = inputvalues[1];
                            ewrapper.branchOfficeCode = inputvalues[2];
                            ewrapper.branchOfficeName = inputvalues[3];
                            ewrapper.cityName = inputvalues[4];
                            ewrapper.cityCode = inputvalues[5];
                            ewrapper.Quantity = inputvalues[6];
                        if(allInvalidFlag == true)
                        	ewrapper.reason = 'Product :'+inputvalues[1]+' : '+inputvalues[0]+' and Sales Office : '+inputvalues[3]+' : '+inputvalues[2]+'and City : '+inputvalues[4]+' : '+inputvalues[5]+' not found in the Distributor-SKU Mapping object records.';
                        else if(skuValidFlag == false)
                            	ewrapper.reason = 'Product : '+inputvalues[1]+' : '+inputvalues[0]+' not found in the Distributor-SKU Mapping object records.';
                        else if(salesOfficeValidFlag == false)
                            	ewrapper.reason = 'Sales Office : '+inputvalues[3]+' : '+inputvalues[2]+' not found in the Distributor-SKU Mapping object records.';
                         else if(CityValidFlag == false)
                            	ewrapper.reason = 'City : '+inputvalues[4]+' : '+inputvalues[5]+' not found in the Distributor-SKU Mapping object records.';
                        errorList.add(ewrapper);
                    }
                }
                
                Database.UpsertResult[] sDataUpload=  Database.upsert(inventoryList,Inventory_POG__c.Combination_Key__c,false);
                for(Integer i=0;i<sDataUpload.size();i++){
                    if (!sDataUpload.get(i).isSuccess()){
                        Database.Error err = sDataUpload.get(i).getErrors().get(0);
                        ErrorWrapper errorw = new ErrorWrapper();
                        errorw.reason='Error - '+err.getMessage() + '\nStatus Code : '+err.getStatusCode()+'\n Fields : '+err.getFields();
                        errorList.add(errorw);
                        System.debug('Error - '+err.getMessage() + '\nStatus Code : '+err.getStatusCode()+'\n Fields : '+err.getFields());
                    }
                }
            }
        }catch(Exception ex){
            System.debug('Line No: '+ex.getLineNumber()+' Message: '+ex.getMessage()+' Cause: '+ex.getCause());
            ErrorWrapper errorw = new ErrorWrapper();
            errorw.productCode = '';
            errorw.productName = '';
            errorw.branchOfficeCode = '';
            errorw.branchOfficeName = '';
            errorw.cityName = '';
            errorw.cityCode = '';
            errorw.Quantity = '';
            errorw.reason='Line No: '+ex.getLineNumber()+' Message: '+ex.getMessage()+' Cause: '+ex.getCause();
            errorList.add(errorw);
        }
        String returnString;
        try{
            if(errorList.size() > 0){
                List<Messaging.Emailfileattachment> efaList = new List<Messaging.Emailfileattachment>();
                string header = 'Product Code,Product Name,Branch Office Code,Branch Office Name,City Name,City Code,Quantity\n';
                string finalstr = header ;
                for(ErrorWrapper err: errorList)
                {
                    string recordString = '"'+err.productCode+'","'+err.productName+'","'+err.branchOfficeCode+'","'+err.branchOfficeName+'","'+err.CityName+'","'+err.CityCode+'","'+err.Quantity+'","'+err.reason+'" \n';
                    finalstr = finalstr +recordString;
                }
                String loggedInUser= UserInfo.getUserEmail();
                Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
                blob csvBlob = Blob.valueOf(finalstr);
                string csvname= 'Liquidation Upload Error File.csv';
                csvAttc.setFileName(csvname);
                csvAttc.setBody(csvBlob);
                efaList.add(csvAttc);
                Messaging.SingleEmailMessage emailsend =new Messaging.SingleEmailMessage();
                String[] toAddresses = new list<string> {loggedInUser};
                    String subject ='Liquidation Upload Error';
                emailsend.setSubject(subject);
                emailsend.setToAddresses( toAddresses );
                emailsend.setPlainTextBody('Attached records could not be updated. Error messages are listed.');
                emailsend.setFileAttachments(efaList);
                Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {emailsend});
                returnString = 'NoSuccess';
            }
            else{
                
                String loggedInUser= UserInfo.getUserEmail();
                Messaging.SingleEmailMessage emailsend =new Messaging.SingleEmailMessage();
                String[] toAddresses = new list<string> {loggedInUser};
                    String subject ='Liquidation Upload Success';
                emailsend.setSubject(subject);
                emailsend.setToAddresses( toAddresses );
                emailsend.setPlainTextBody('All of the records were uploaded succesfully.');
                Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {emailsend});
                returnString = 'success';
            }
        }catch(Exception ex){
            System.debug('Line No: '+ex.getLineNumber()+' Message: '+ex.getMessage()+' Cause: '+ex.getCause());
            returnString = 'Exception Occurred. Please contact system administrator for further details';
        }
        return returnString;
    }
    
    @AuraEnabled
    public static String getDocument()
    {
        List<document> DocumentList = new List<document>(); 
        String Templatefile = '/servlet/servlet.FileDownload?file=';
        String newTemplatefile;
        DocumentList = [select Name from document where Name = 'Liquidation Template'];
        if(DocumentList.size()>0){
            newTemplatefile = Templatefile+DocumentList[0].Id;
        }
        return newTemplatefile;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<SObject> getRecords(String searchString){
        searchString = String.escapeSingleQuotes(searchString);
        
        String name = '%' + searchString + '%';
        return [SELECT id, Name,SAP_Code__c FROM Account
                WHERE Name LIKE :name AND 
                RecordType.name = 'Distributor' AND 
                Sales_Org_Code__c = '5661' AND 
                Account_Type__c = 'Sold To Party' ORDER BY Name];
    }
    
    @AuraEnabled
    public static List <Secondary_Sales_Data__c> fetchSecondaryRecords() {
        return [select Id,Name,CreatedDate,Sales_Org__c,Mapping_Unit_Price__c,Product_Name__r.Name,Product_Name__r.SKU_Code__c,Product_Name__r.SKU_Description__c,City__c,City_Code__c,Sales_Org__r.Sales_Org_Code__c,Sold_To_Party__r.Name, Product_Quantity__c, Sell_Amount_USD__c, Month__c, Year__c,UOM__c  from Secondary_Sales_Data__c where Sales_Org__r.Sales_Org_Code__c = '5661' order by CreatedDate desc];
    }
    @AuraEnabled
    public static List <Inventory_POG__c> fetchInventoryRecords() {
        return [select Id,Name,CreatedDate,Sales_Org__c, Customer_Name__r.Name, Sales_Org__r.Sales_Org_Code__c,Stock_Date__c, SKU_Name__r.Name,SKU_Name__r.SKU_Code__c,City__c,City_Code__c,UoM__c, Stock_Quantity__c from Inventory_POG__c where Sales_Org__r.Sales_Org_Code__c = '5661' order by CreatedDate desc];
    }
    
    @AuraEnabled
    public static String saveSecondaryData(List<Secondary_Sales_Data__c> records){
        String returnString;
        system.debug('recrds::'+records);
        Set<Id> ssDataId = new Set<Id>();
        for(Secondary_Sales_Data__c ssData : records)
            ssDataId.add(ssData.Id);
        
        List<Secondary_Sales_Data__c> ssDataToUpdate = [select Id,Product_Quantity__c, Sell_Amount_USD__c,Mapping_Unit_Price__c  from Secondary_Sales_Data__c
                                                        where Sales_Org__r.Sales_Org_Code__c = '5661' AND Id IN: ssDataId];
        Map<Id,Double> ssDataMap = new Map<Id,Double>();
        for(Secondary_Sales_Data__c ss : ssDataToUpdate){
            ssDataMap.put(ss.Id, ss.Mapping_Unit_Price__c);
        }
        try{
            for(Secondary_Sales_Data__c ssData : records){
                if(ssDataMap.containsKey(ssData.Id))
                    ssData.Sell_Amount_USD__c = ssData.Product_Quantity__c*ssDataMap.get(ssData.Id);
            }
            update records;
            returnString =  'Success';
        }catch(Exception ex){
            System.debug('Line No: '+ex.getLineNumber()+' Message: '+ex.getMessage()+' Cause: '+ex.getCause());
            returnString = 'Exception Occurred. Please contact system administrator for further details';
        }
        return returnString;
    }
    @AuraEnabled
    public static String saveInventoryData(List<Inventory_POG__c> records){
        String returnString;
        try{
            update records;
            returnString =  'Success';
        }catch(Exception ex){
            System.debug('Line No: '+ex.getLineNumber()+' Message: '+ex.getMessage()+' Cause: '+ex.getCause());
            returnString = 'Exception Occurred. Please contact system administrator for further details';
        }
        return returnString;
    }
    public class ErrorWrapper {
        public string productCode;
        public String productName;
        public String branchOfficeCode;
        public String branchOfficeName;
        public String cityName;
        public String cityCode;
        public String Quantity;
        public String reason;
  
    }
    
}