/*******************************************************************************************
* @Name         PBUpload_Brazil
* @Author       Paresh Sondigara <paresh.sondigara@skinternational.com>
* @Date         12/8/2021
* @Group        SKI
* @Description  This class contains all service methods related to Price Book Upload).
*******************************************************************************************/
public without sharing class PBUpload_Brazil {
    /*
    * @Description  Method used to get active sales forecast month.
    * @Param        NA
    * @return       Returns month name in string.
    */      
    @AuraEnabled
    public static String activeMonthSalesForecast(){
        String monthSF;
        List<Sales_Forecast_Setting__c> sfList=[SELECT Active_Forecast_Month__c, Id FROM Sales_Forecast_Setting__c WHERE Sales_Org__r.Sales_Org_Code__c='5191' limit 1];
        for(Sales_Forecast_Setting__c sfs:sfList){
            monthSF=sfs.Active_Forecast_Month__c;
        }
        return monthSF;
    }
    
    /*
    * @Description  Method Used to get record id to store uploaded files.
    * @Param        NA
    * @return       Returns list of file attachment. 
    */       
    @AuraEnabled
    public static List<File_Attachment__c> getAllRecordId(){
        return[SELECT Id, Name FROM File_Attachment__c  WHERE Name LIKE 'Brazil File Upload' Limit 1]; 
    }

    /*
    * @Description  Method used to download price book template.
    * @Param        NA
    * @return       Returns URL to download price book template.
    */     
    @AuraEnabled
    Public static List<String> getDownloadURLForTemplates(){
        String InstanceURL = URL.getOrgDomainUrl().toExternalForm(); 
        List<Document> ListDocumentId =new List<Document>();
        if(Test.isRunningTest()){
            ListDocumentId = [SELECT Id, Name, DeveloperName from Document WHERE DeveloperName LIKE 'samplw123'];
        }else{
            ListDocumentId = [SELECT Id, Name, DeveloperName from Document WHERE DeveloperName LIKE 'Brazil_Sample_PriceBook_Template'];
        }
        
        List<String> DownloadURLForTemplates = new List<String>();
        DownloadURLForTemplates.add(InstanceURL+'/servlet/servlet.FileDownload?file='+ListDocumentId[0].Id);
        Return DownloadURLForTemplates;
    }
    
    /*
    * @Description  Method used to get report id.
    * @Param        NA
    * @return       Returns list of report ids.
    */     
    @AuraEnabled
    public static List<String> getReportId(){
        String downloadReport;
        String skuReport;
        List<String> rList=new List<String>();
        List<Report> rDownload=[SELECT Id,Name ,DeveloperName FROM Report where DeveloperName like 'Price_Book_And_Price_Book_Entry' Limit 1];
        for(Report rd:rDownload){
            downloadReport=rd.id;
        }
        List<Report> rSKU=[SELECT Id, Name,DeveloperName FROM Report where DeveloperName like 'Missing_SKU_in_Pricebook' Limit 1];
        for(Report rd:rSKU){
            skuReport=rd.id;
        }

        rList.add(downloadReport);
        rList.add(skuReport);
        return rList;

    }

    /*
    * @Description  Method used to read uploaded csv file & insert/update price book & price book entry.
    * @Param        Id idContentDocument - represents id of uploaded file
    * 				String Month - represents month name in string
    * 				String Year - represents year in string
    * @return       Returns list of errors.
    */      
    @AuraEnabled
    public static List<String> readCSVFile(Id idContentDocument,String Month,String Year){
        List<String> errorList=new List<String>();
        List<BatchJob> batchJobs = [SELECT Id, Name, status, BatchJobDefinitionName, ProcessGroup, ErrorDescription FROM BatchJob where status='InProgress' OR status='Submitted'];
        List<AsyncApexJob> asyncApexJob = [SELECT Id, JobType, ApexClassId, Status, ParentJobId FROM AsyncApexJob where ApexClass.Name IN('SalesForeCastBatch', 'UpdateMetricsBatchNoOne', 'UpdateMetricsBatchNoTwo', 'UpdateMetricsBatchNoThree') AND JobType='BatchApex' AND Status!='Completed' AND Status!='Aborted'];
        System.debug('batchJobs----'+batchJobs);
        System.debug('asyncApexJob----'+asyncApexJob); 
        System.debug('batchJobs size----'+batchJobs.size());
        System.debug('asyncApexJob size----'+asyncApexJob.size()); 
        if((batchJobs.size()>0 || asyncApexJob.size()>0) && (System.Label.Brazil_Sales_Agreement_Pricebook_upload_check == 'True')){ // RITM0540743 Start Custom label check to pricebook 23/05/2023
            errorList.add('Upload In Progress');
        }
        
            Database.SaveResult[]  strListinsert;
            Database.SaveResult[]  strListupdate;
            string sString = Month;
            string[] splitted = sString.split('\\-');
            system.debug('part1-->'+ splitted[0]);   //Output: theblogreaders
            String MonthText=splitted[0];
            system.debug('part2-->'+ splitted[1]);   //Output: salesforce
            String MonthNo=splitted[1];

            Integer MntN=Integer.valueOf(MonthNo);
            Integer YrN=Integer.valueOf(Year);

            String row='';
            decimal uPrice=0.00;
            decimal bPrice=0.00;
            Integer productCodeLength;
            list<String> csvRowData=new list<String>();
            List<String> successList=new List<String>();
            List<String> eListPricebook=new List<String>();
            List<PricebookEntry> listPbeInsert=new List<PricebookEntry>();
            List<PricebookEntry> listPbeUpdate=new List<PricebookEntry>();
            map<string,PricebookEntry> mapPbeUpdate=new map<String,PricebookEntry>();
            List<PricebookEntry> listDBPriceBookentery = new List<PricebookEntry>();
            Set<String> productCombinationKeySet = new Set<String>();
            List<SKU__c> updateSKU = new List<SKU__c>();
            String monthYeaykey = MonthText+Year+'%';
            listDBPriceBookentery = [SELECT Id, Name, Pricebook2Id,UnitPrice, Budget_Price__c, Combination_Key__c FROM PricebookEntry WHERE Pricebook2.name like: monthYeaykey];
            list<Product2> listProduct = new list<Product2>();
            //added By vishal Is_Forecast_Required__c filed and filter is added Is_Forecast_Required__c = true according to Sandip sir 11 Jan 2022
            listProduct =[SELECT Id, Name, Combination_Key__c, Sales_Org__c, Product_Code__c,Is_Forecast_Required__c 
                        FROM Product2 
                        WHERE Sales_Org__r.Sales_org_code__c ='5191'
                        AND Parent__c=''
                        //  AND Is_Forecast_Required__c =true
                        ];
            map<string,Product2> mapProduct = new map<string,Product2>();
            for(Product2 pdt:listProduct){
                mapProduct.put(pdt.Combination_Key__c,pdt);
            }
            list<Region__c> listregion= new list<Region__c>();
            listregion = [SELECT Id, Name, RegionCode__c, SalesOrg__c FROM Region__c WHERE SalesOrg__r.Sales_org_code__c = '5191'];
            map<string,Region__c> mapSD = new map<string,Region__c>();
            for(Region__c sd:listregion){
                mapSD.put(sd.RegionCode__c,sd);
            }
            Map<String,PricebookEntry> mapDBPriceBookentry = new Map<String,PricebookEntry>();
            for(PricebookEntry pbe : listDBPriceBookentery){
                mapDBPriceBookentry.put(pbe.Combination_Key__c,pbe);
            }
            System.debug('Month-->'+MonthText);
            Map<String, list<PricebookEntry>> mapSalesDistrict = new Map<String, list<PricebookEntry>>();
            Map<String, Pricebook2> mapPB = new Map<String, Pricebook2>();
            
            String sales_org_id;
            List<Sales_Org__c>soList=[SELECT id,Name,Sales_Org_Code__c From Sales_Org__c where Sales_Org_Code__c='5191' Limit 1];
            for(Sales_Org__c so:soList){
                sales_org_id=so.id;
            }

            if(idContentDocument != null) {
                
                // getting File Data based on document id 
                ContentVersion objVersion = [SELECT Id, VersionData FROM ContentVersion WHERE ContentDocumentId =:idContentDocument];
                // split the file data
                list<String> lstCSVLines = objVersion.VersionData.toString().split('\n');
                //Pricebook2 standardPB = [select id from Pricebook2 where isStandard=true];
                
                for(Integer i = 1; i < lstCSVLines.size(); i++){
                    row=lstCSVLines[i];
                    //csvRowData = lstCSVLines[i].split(',');
    /*
    csvRowData[0]->SKU Code
    csvRowData[1]->Price 
    csvRowData[2]->Budget Price
    csvRowData[3]->Sales District Code
    /-----------------------------------/
    csvRowData[0]->Sales District Code
    csvRowData[1]->SKU Code
    csvRowData[2]->Price 
    csvRowData[3]->Budget Price
    */

            

            date firstDate = date.newInstance(YrN,MntN,01);
            String firstDateString = firstDate.format();
            
            Integer numberOfDays = Date.daysInMonth(YrN, MntN);
            Date lastDayOfMonth = Date.newInstance(YrN, MntN, numberOfDays);

            date lastDate = date.newInstance(lastDayOfMonth.year(),lastDayOfMonth.month(),lastDayOfMonth.day());
            String lastDateString = lastDate.format();

            String csvLine = String.valueOf(lstCSVLines[i]);
                    String prevLine = csvLine;
                    Integer startIndex;
                    Integer endIndex;

            while(csvLine.indexOf('"') > -1){
            
                if(startIndex == null){
                    startIndex = csvLine.indexOf('"');
                    csvLine = csvLine.substring(0, startIndex) + ':quotes:' + csvLine.substring(startIndex+1, csvLine.length());
                }else{
                    if(endIndex == null){
                        endIndex = csvLine.indexOf('"');
                        csvLine = csvLine.substring(0, endIndex) + ':quotes:' + csvLine.substring(endIndex+1, csvLine.length());
                    }
                }
                
                if(startIndex != null && endIndex != null){
                    String sub = csvLine.substring(startIndex, endIndex);
                    sub = sub.replaceAll(';', ':comma:');
                    csvLine = csvLine.substring(0, startIndex) + sub + csvLine.substring(endIndex, csvLine.length());
                    startIndex = null;
                    endIndex = null;
                }
            }



                    csvRowData = csvLine.split(';');
                    try{
                        //System.debug('List Price isblank--->'+String.isBlank(csvRowData[2].replaceAll(':quotes:', '').replaceAll(':comma:', ';').replace(',', '.').trim()));
                        //System.debug('List Price isempty--->'+String.isEmpty(csvRowData[2].replaceAll(':quotes:', '').replaceAll(':comma:', ';').replace(',', '.').trim()));
                        boolean iserror = false;
                        
                        //System.debug('bPrice--->'+bPrice);                       
                        
                        String productCode=csvRowData[1].replaceAll(':quotes:', '').replaceAll(':comma:', ';').replace(',', '').trim();
                        productCodeLength=(18-csvRowData[1].replaceAll(':quotes:', '').replaceAll(':comma:', ';').replace(',', '').trim().length());
                        System.debug('productCodeLength-->'+productCodeLength);
                            for(Integer j=1;j<=productCodeLength;j++){
                                productCode='0'+productCode;
                            }
                        System.debug('productCode--->'+productCode);

                        /*if(csvRowData[1].trim().length()==6){
                                productCode='000000000000'+csvRowData[1].trim();
                            }else{
                                productCode='00000000000'+csvRowData[1].trim();
                            }*/
                            productCode ='5191'+productCode;
                            System.debug('productCode-->'+productCode);
                        if(!mapSD.containskey(csvRowData[0].replaceAll(':quotes:', '').replaceAll(':comma:', ';').replace(',', '').trim())){
                            errorList.add(row+','+System.Label.Sales_District_code_not_present_in_database);
                            iserror = true;
                        }
                        if(!mapProduct.containskey(productCode) && !iserror){
                            errorList.add(row+','+System.Label.Product_code_not_present_in_database);
                            iserror = true;
                        }else{
                            Product2 p=mapProduct.get(productCode);
                            if(p.Is_Forecast_Required__c==false){
                                productCombinationKeySet.add(p.Combination_Key__c);
                            }
                        }                    
                        /*System.debug('iserror 165'+iserror);
                        if(String.isBlank(csvRowData[2].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '.').trim())){
                            errorList.add(row+','+'Invalid: Blank values are not permitted. ');
                            iserror = true;
                        }
                        if(String.isBlank(csvRowData[3].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '.').trim())){
                            errorList.add(row+','+'Invalid: Blank values are not permitted ');
                            iserror = true;
                        }*/
                        uPrice=decimal.valueOf(csvRowData[2].replaceAll(':quotes:', '').replaceAll(':comma:', ';').replace(',', '.').trim());
                        bPrice=decimal.valueOf(csvRowData[3].replaceAll(':quotes:', '').replaceAll(':comma:', ';').replace(',', '.').trim());
                        if(uPrice<0){
                            errorList.add(row+','+System.Label.Invalid_Negative_values_are_not_permitted);
                            iserror = true;
                        }
                        if(bPrice<0){
                            errorList.add(row+','+System.Label.Invalid_Negative_values_are_not_permitted);
                            iserror = true;
                        }
                        System.debug('iserror'+iserror);
                        //productCode ='5191'+productCode;
                        if(!iserror){
                            System.debug('Entered');
                        mapPB.put(csvRowData[0].replaceAll(':quotes:', '').replaceAll(':comma:', ';').replace(',', '').trim() , 
                            new Pricebook2(Name=MonthText+Year+csvRowData[0].replaceAll(':quotes:', '').replaceAll(':comma:', ';').replace(',', '').trim(),
                                Sales_District__r=new region__c(RegionCode__c=csvRowData[0].replaceAll(':quotes:', '').replaceAll(':comma:', ';').replace(',', '').trim()),
                                Is_Used_for_Forecast__c =true,
                                Combination_Key__c=MonthText+Year+csvRowData[0].replaceAll(':quotes:', '').replaceAll(':comma:', ';').replace(',', '').trim(),
                                IsActive = true,
                                Month__c=MonthNo,
                                Price_Book_Category__c='Forecast',
                                Type__c='Monthly',
                                Year__c=Year,
                                Sales_Org__c=sales_org_id,
                                Start_Date__c=firstDate,
                                End_Date__c=lastDate ));
                    
                        if(mapSalesDistrict.containsKey(csvRowData[0].replaceAll(':quotes:', '').replaceAll(':comma:', ';').replace(',', '').trim())){
                            System.debug('***3 '+csvRowData[0]);
                            List<PricebookEntry> listPBEntry=mapSalesDistrict.get(csvRowData[0].replaceAll(':quotes:', '').replaceAll(':comma:', ';').replace(',', '').trim());
                        
                        
                            PricebookEntry objPBEntry=new PricebookEntry();
                            objPBEntry.Product2 =new Product2(Combination_Key__c=productCode);
                            System.debug('***'+objPBEntry.Product2);
                            objPBEntry.IsActive=true;
                            objPBEntry.UseStandardPrice=false;
                            objPBEntry.CurrencyIsoCode ='USD';
                            objPBEntry.UnitPrice=decimal.valueOf(csvRowData[2].replaceAll(':quotes:', '').replaceAll(':comma:', ';').replace(',', '.').trim());
                            objPBEntry.Budget_Price__c=decimal.valueOf(csvRowData[3].replaceAll(':quotes:', '').replaceAll(':comma:', ';').replace(',', '.').trim());                       
                            objPBEntry.Combination_Key__c=MonthText+Year+csvRowData[0].replaceAll(':quotes:', '').replaceAll(':comma:', ';').replace(',', '').trim()+productCode;
                            System.debug('objPBEntry-->'+objPBEntry);
                            listPBEntry.add(objPBEntry);
                            mapSalesDistrict.put(csvRowData[0].replaceAll(':quotes:', '').replaceAll(':comma:', ';').replace(',', '').trim(),listPBEntry);
                        }else{
                            List<PricebookEntry> listPBEntry=new List<PricebookEntry>();
                            PricebookEntry objPBEntry=new PricebookEntry();
                            objPBEntry.Product2 =new Product2(Combination_Key__c=productCode);
                            System.debug('***'+objPBEntry.Product2);
                            objPBEntry.IsActive=true;
                            objPBEntry.UseStandardPrice=false;
                            objPBEntry.CurrencyIsoCode ='USD';
                            objPBEntry.UnitPrice=decimal.valueOf(csvRowData[2].replaceAll(':quotes:', '').replaceAll(':comma:', ';').replace(',', '.').trim());
                            objPBEntry.Budget_Price__c=decimal.valueOf(csvRowData[3].replaceAll(':quotes:', '').replaceAll(':comma:', ';').replace(',', '.').trim());
                            objPBEntry.Combination_Key__c=MonthText+Year+csvRowData[0].replaceAll(':quotes:', '').replaceAll(':comma:', ';').replace(',', '').trim()+productCode;
                            System.debug('objPBEntry-->'+objPBEntry);
                            listPBEntry.add(objPBEntry);
                            mapSalesDistrict.put(csvRowData[0].replaceAll(':quotes:', '').replaceAll(':comma:', ';').replace(',', '').trim(),listPBEntry);
                        }
                            successList.add(row);
                        }
                    }catch(Exception e){
                        System.debug('error msg-->'+e.getMessage());
                        System.debug('error msg-->'+e.getCause());
                        System.debug('error line-->'+e.getLineNumber());
                        errorList.add(row+','+e.getMessage());
                        //errorList.add(row+','+e.getMessage());
                    }
                    
                }
                System.debug('listPBEntry--->'+mapSalesDistrict.values());
                Schema.SObjectField f = Pricebook2.Fields.Combination_Key__c;
                Schema.SObjectField f1 = PricebookEntry.Fields.Combination_Key__c;
                System.debug('map values-->'+mapPB.values());
                System.debug('map values-->'+mapPB.keyset());
                if(mapPB.values().size() > 0){
                    Database.upsert(mapPB.values(),f,true);
                }
            
                System.debug('map values-->'+mapPB.values());

                updateSKU = [Select Id, Name, Is_Forecast_Required__c FROM SKU__c WHERE Combination_Key__c IN :productCombinationKeySet];
                for(SKU__c s : updateSKU){
                    s.Is_Forecast_Required__c=true;
                }
                System.debug('updateSKU size-->'+updateSKU.size());
                System.debug('updateSKU----'+updateSKU);
                Database.SaveResult[] skuUpdateList;
                if(updateSKU.size()>0){
                    skuUpdateList = Database.update(updateSKU,false);
                }     
                System.debug('updateSKUList----'+skuUpdateList);

                
                for(String s : mapSalesDistrict.keySet()){
                    System.debug('for loop enter line 87'+s);
                    System.debug('for loop enter line 88'+mapSalesDistrict.get(s));
                    for(PricebookEntry pbe:mapSalesDistrict.get(s)){
                        System.debug('for loop enter line 90'+pbe);
                        
                        if(mapDBPriceBookentry.containskey(pbe.Combination_Key__c)){
                            PricebookEntry pbentery = mapDBPriceBookentry.get(pbe.Combination_Key__c);
                            if(pbentery.Budget_Price__c != pbe.Budget_Price__c || pbentery.UnitPrice != pbe.UnitPrice){
                                if(pbentery.Budget_Price__c != pbe.Budget_Price__c){
                                    pbentery.Update_SKU__c = true;  
                                } 
                                if(pbentery.UnitPrice != pbe.UnitPrice){
                                    pbentery.Update_SKU__c = true; 
                                }
                                pbentery.Budget_Price__c = pbe.Budget_Price__c;
                                pbentery.UnitPrice = pbe.UnitPrice;                                                                                                                                            
                                //listPbeUpdate.add(pbentery);
                                mapPbeUpdate.put(pbentery.id,pbentery);
                            }                        
                        }else{
                        //pbe.Pricebook2Id=mapPB.get(s).Id; //new Pricebook2(Combination_Key__c=Month+Year+s);
                            pbe.Pricebook2=new Pricebook2(Combination_Key__c=MonthText+Year+s);
                            pbe.New_SKU__c = true;
                            listPbeInsert.add(pbe);    
                        } 
                    
                    }
                }
                System.debug('listPbeInsert--->'+listPbeInsert.size());
                System.debug('mapPbeUpdate--->'+mapPbeUpdate.values().size());
                
                //Condition added by Paresh Sondigara : CR#162
                if(listPbeInsert.size() > 0 || mapPbeUpdate.values().size() > 0){
                    AssignPermissionSetToBDP.assignPermissionSet();
                }
				                
                if(listPbeInsert.size() > 0){
                    strListinsert=Database.insert(listPbeInsert,false);
                    Map<String, Object> params = new Map<String, Object>();
                    Flow.Interview.Insert_SAP flow1 = new Flow.Interview.Insert_SAP(params);
                    flow1.start();
                }
                if(mapPbeUpdate.values().size() > 0){
                    strListupdate = Database.update(mapPbeUpdate.values());
                    Map<String, Object> params = new Map<String, Object>();
                    Flow.Interview.Update_SAP flow2 = new Flow.Interview.Update_SAP(params);
                    flow2.start();
                }
                sendMail(String.join(errorList,'\r\n'),String.join(successList,'\r\n'),errorList.size(),successList.size(),'PriceBook');
            }
        
                
        return errorList;
        // List<String> a=new List<String>();
        // return a;
    }
    
    /*
    * @Description  Method used to send success/error mail to brazil demand planner.
    * @Param        String err - represents error list in string
    * 				String scc - represents success list in string
    * 				Integer errCount - represents error record count
    * 				Integer sccCount - represents success record count
    * 				String mailUnit - represents price book unit
    * @return       void
    */   
    public static void sendMail(String err,String scc,Integer errCount,Integer sccCount,String mailUnit){
        Messaging.EmailFileAttachment successAttach = new Messaging.EmailFileAttachment();
        successAttach.setContentType('application/csv');
        successAttach.setFileName('Success.csv');
        successAttach.setInline(false);
        scc = 'Sucess File\r\n'+scc;
        blob successblob = Blob.valueOf(scc);
        successAttach.setBody(successblob);
        system.debug('sucess File>>--->'+scc);
        system.debug('error File>>--->'+err);
        Messaging.EmailFileAttachment errorAttach = new Messaging.EmailFileAttachment();
        errorAttach.setContentType('application/csv');
        errorAttach.setFileName('Error.csv');
        errorAttach.setInline(false);
        err = 'Error File\r\n'+err;
        blob errblob = Blob.valueOf(err);
        errorAttach.setBody(errblob);
        
        Date d = Date.Today();
        String dateString =  d.format();

        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setUseSignature(false);
        //String[] toAddresses = new String[] {'tejaschavhan2@gmail.com'}; 
        //String[] ccAddresses = new String[] {'tejas.chavan@skinternational.com'};
        mail.setToAddresses(new String[] { System.Label.Email_Sent_to_SalesRep_or_SDM });
        //mail.setToAddresses(new String[] { UserInfo.getUserEmail(),'prashant.chinchpure@skinternational.com','tejas.chavan@skinternational.com','nilam.bangar@skinternational.com'});
        //mail.setToAddresses(new String[] { 'tejas.chavan@skinternational.com','prashant.chinchpure@skinternational.com'});
        //mail.setToAddresses(toAddresses);
        //mail.setCcAddresses(ccAddresses);
        //mail.setCcAddresses(new String[] {'tejas.chavan@skinternational.com'});
        
        mail.setCharset('UTF8');
        //mail.setReplyTo('support@acme.com');
        //mail.setSenderDisplayName(System.Label.Salesforce_Support);
        mail.setBccSender(false);
        mail.setUseSignature(false);
        
        
        mail.setSubject(System.Label.Data_Upload_Details_of_PriceBook);
        mail.setPlainTextBody(System.Label.List_of_success_and_error_records_of_PriceBook);
        mail.setHtmlBody(System.Label.Dear_User+',<br/><br/>'+System.Label.Please_find_attached_files_generated_in_SFDC_while_uploading_the_Pricebook_Data+'<br /><br />'+System.Label.Date+': '+dateString+'<br /><br />'+System.Label.No_of_error_records+': '+errCount+'<br /><br />'+System.Label.No_of_Success_records+': '+sccCount+'<br /><br />'+System.Label.Regards+',<br/>'+System.Label.UPL_Salesforce_Administrator+'<br/>');
        
        
        mail.setFileAttachments(new Messaging.EmailFileAttachment[] {errorAttach}); 
        
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }

    /*
    * @Description  method used to get current year.
    * @Param        NA
    * @return       Returns current year in string
    */     
    @AuraEnabled
    public static String  getCurrentYear(){
        Integer Year = Date.Today().Year();
        String currentYear = String.valueOf(Year);
        System.debug('currentYear-->'+currentYear);
        return currentYear;
    }

    /*@AuraEnabled(cacheable=true)
    public static String  getSetYear(){
        Integer Year = Date.Today().Year();
        String setYear = String.valueOf(Year);
        System.debug('setYear-->'+setYear);
        return setYear;
    }*/
    
    /*
    * @Description  method used to get year picklist values from pricebook.
    * @Param        NA
    * @return       Returns list of WrapperFieldLabelYear class.
    */     
    @AuraEnabled
    public static  List<WrapperFieldLabelYear>  getYearList()
    {
            /*------Dynamic Apex------*/
        Schema.DescribeFieldResult fieldResult = Pricebook2.Year__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();

        List<WrapperFieldLabelYear> wrapperlist=new List<WrapperFieldLabelYear>();
        for( Schema.PicklistEntry f : ple)
        {
            WrapperFieldLabelYear wrapperObj=new WrapperFieldLabelYear();
                
                wrapperObj.label=f.getLabel();
                wrapperObj.value=f.getValue();
                wrapperlist.add(wrapperObj);
            
        } 
            //system.debug('Fiscal Year-->'+wrapperlist);
            return wrapperlist;
    }

    public class WrapperFieldLabelYear
    {
        @AuraEnabled
        public String label{get;set;}
        @AuraEnabled
        public String value{get;set;}
        

        public WrapperFieldLabelYear()
        {
            label='';
            value='';
        }
    }
    
    
}