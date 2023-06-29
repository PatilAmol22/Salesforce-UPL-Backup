public without sharing class BudgetUpload_Brazil {
    
    @AuraEnabled
    public static List<File_Attachment__c> getAllRecordId(){
        return[SELECT Id, Name FROM File_Attachment__c  WHERE Name LIKE 'Brazil Budget Upload' Limit 1];
    }
    
    //Download URL's for CSV Templates on Interface
    @AuraEnabled
    Public static List<String> getDownloadURLForTemplates(){
        String InstanceURL = URL.getOrgDomainUrl().toExternalForm();      
        List<Document> ListDocumentId = [SELECT Id, Name, DeveloperName from Document WHERE DeveloperName LIKE 'SampleTemplateBrazilBudgetUpload'];
        List<String> DownloadURLForTemplates = new List<String>();
        DownloadURLForTemplates.add(InstanceURL+'/servlet/servlet.FileDownload?file='+ListDocumentId[0].Id);
        Return DownloadURLForTemplates;
    }
    
    @AuraEnabled
    public static List<String> readCSVFile(Id idContentDocument,String Year){
        System.debug('Year'+Year);
        //System.debug('Month'+Month);
        Integer RcLength;
        String Rc;
        String row='';
        Integer productCodeLength;
        decimal Quan=0.00;
        decimal Pric=0.00;
        Integer c=0;
        list<String> csvRowData=new list<String>();
        
        List<String> errorList=new List<String>();
        List<String> errorList1=new List<String>();
        List<String> successList=new List<String>();
        List<String> eListBudget=new List<String>();
        list<Account_Target__c> lstAccsToUpsert = new list<Account_Target__c>();
        Database.UpsertResult[] strList;
        String idSO;
        List<Sales_Org__c> soList=[SELECT Id, Name, Sales_Org_Code__c FROM Sales_Org__c where Sales_Org_Code__c ='5191' limit 1];
        for(Sales_Org__c so:soList){
            idSO=so.id;
        }
        
        //System.debug('pbIDMap values :  '+pbIDMap.values());
        if(idContentDocument != null) {
            
            // getting File Data based on document id 
            ContentVersion objVersion = [SELECT Id, VersionData FROM ContentVersion WHERE ContentDocumentId =:idContentDocument];
            // split the file data
            list<String> lstCSVLines = objVersion.VersionData.toString().split('\n');
            successList.add('Record ID,'+lstCSVLines[0]);
            errorList.add(lstCSVLines[0]+',Error Description');
            errorList1.add(lstCSVLines[0]+',Error Description');
            
            for(Integer i = 1; i < lstCSVLines.size(); i++){
                Account_Target__c objAT=new Account_Target__c();
                row=lstCSVLines[i];
                
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
                    boolean iserror = false;
                    System.debug('csvRowData0====> '+csvRowData[0]);
                    System.debug('csvRowData1====> '+csvRowData[1]);
                    System.debug('csvRowData2====> '+csvRowData[2]);
                    //System.debug('csvRowData3====> '+csvRowData[3]);
                    //  System.debug('csvRowData4====> '+csvRowData[4]);
                    // System.debug('csvRowData5====> '+csvRowData[5]);
                    
                    if(String.isBlank(csvRowData[0]) || String.isBlank(csvRowData[1]) || String.isBlank(csvRowData[2]) || String.isBlank(csvRowData[3])){
                        errorList1.add(row+','+System.Label.Blank_values_are_not_permitted_incorrect_file_format);
                        sendMail(String.join(errorList1,'\r\n'),String.join(successList,'\r\n'),errorList1.size()-1,successList.size()-1);
                        return errorList1;
                    }
                    
                    RcLength=csvRowData[0].replaceAll(':quotes:', '').replaceAll(':comma:', ';').replace(',', '').trim().length();
                    
                    if(RcLength==3){
                        Rc='BR'+csvRowData[0].replaceAll(':quotes:', '').replaceAll(':comma:', ';').replace(',', '').trim();
                    }else{
                        Rc=csvRowData[0].replaceAll(':quotes:', '').replaceAll(':comma:', ';').replace(',', '').trim();
                    }
                    System.debug('Rcode-->'+Rc);
                    
                    String productCode=csvRowData[1].replaceAll(':quotes:', '').replaceAll(':comma:', ';').replace(',', '').trim();
                    productCodeLength=(18-csvRowData[1].replaceAll(':quotes:', '').replaceAll(':comma:', ';').replace(',', '').trim().length());
                    System.debug('productCodeLength-->'+productCodeLength);
                    
                    for(Integer j=1;j<=productCodeLength;j++){
                        productCode='0'+productCode;
                    }
                    System.debug('productCode--->'+productCode);
                    productCode ='5191'+productCode;
                    System.debug('productCode-->'+productCode);
                    String RCode=csvRowData[0].replaceAll(':quotes:', '').replaceAll(':comma:', ';').replace(',', '').trim();
                    
                    /*if(String.isBlank(csvRowData[3])){
System.debug('null Price');
errorList.add(row+','+System.Label.Invalid_Blank_values_are_not_permitted);
iserror = true;
}else{
Pric=decimal.valueOf(csvRowData[3].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '.').trim());
}*/
                    
                    if(String.isBlank(csvRowData[2])){
                        System.debug('null Quantity');
                        errorList.add(row+','+System.Label.Invalid_Blank_values_are_not_permitted);
                        iserror = true;
                    }else{
                        Quan=decimal.valueOf(csvRowData[2].replaceAll(':quotes:', '').replaceAll(':comma:', ';').replace(',', '.').trim());
                        //Quan=decimal.valueOf(csvRowData[2].trim());
                    }
                    
                    
                    if(Quan<0){
                        errorList.add(row+','+System.Label.Invalid_Negative_values_are_not_permitted);
                        iserror = true;
                    }
                    
                    /*if(Pric<0){
errorList.add(row+','+System.Label.Invalid_Negative_values_are_not_permitted);
iserror = true;
}*/
                    System.debug('iserror'+iserror);
                    if(!iserror){
                        objAT.Product__r=new Product2(Combination_Key__c=productCode);
                        objAT.region__r=new Territory_Distributor__c(TerritoryCode__c=Rc);
                        //objAT.Region__r=new Territory_Distributor__c(TerritoryCode__c=csvRowData[0].replaceAll(':quotes:', '').replaceAll(':comma:', ';').replace(',', '').trim());
                        //objAT.Product__r=new Product2(Product_Code__c=csvRowData[1].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim());
                        // objAT.Region__c=csvRowData[0].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim();
                        // objAT.Product__c=csvRowData[1].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim();
                        objAT.Month__c=csvRowData[3].replaceAll(':quotes:', '').replaceAll(':comma:', ';').replace(',', '').trim();
                        // objAT.Year__c=csvRowData[3].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim();
                        
                        //Added By Vishal Pawar for changing Year to next year when month is Jan(1), Feb(2), March(3)
                        String tmpMonthNumber = csvRowData[3].replaceAll(':quotes:', '').replaceAll(':comma:', ';').replace(',', '').trim();
                        
                        if(tmpMonthNumber=='1' || tmpMonthNumber=='2' || tmpMonthNumber=='3'){
                            objAT.Year__c = string.valueof(Integer.ValueOf(Year)+1);
                            String tmpYear = string.valueof(Integer.ValueOf(Year)+1);
                            objAT.Combination_Key__c=RCode+productCode+csvRowData[3].replaceAll(':quotes:', '').replaceAll(':comma:', ';').replace(',', '').trim()+tmpYear;
                        }else{
                            objAT.Year__c=Year;
                            objAT.Combination_Key__c=RCode+productCode+csvRowData[3].replaceAll(':quotes:', '').replaceAll(':comma:', ';').replace(',', '').trim()+Year;
                        }
                        //End code for Vishal Pawar
                        
                        //objAT.Month__c=Month;
                        //objAT.Quantity__c=decimal.valueOf(csvRowData[2].trim());
                        objAT.Quantity__c=decimal.valueOf(csvRowData[2].replaceAll(':quotes:', '').replaceAll(':comma:', ';').replace(',', '.').trim());
                        //objAT.Price__c=decimal.valueOf(csvRowData[3].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '.').trim());
                        objAT.CurrencyIsoCode='BRL';//'USD';//
                        objAT.Sales_Org__c=idSO;
                        //below line of code is commented by vishal for Year changes if month is jan feb march and rewrite in line number 162
                        //objAT.Combination_Key__c=RCode+productCode+csvRowData[3].replaceAll(':quotes:', '').replaceAll(':comma:', ';').replace(',', '').trim()+Year;
                        
                        System.debug('Comb Key--> '+RCode+productCode+csvRowData[3].replaceAll(':quotes:', '').replaceAll(':comma:', ';').replace(',', '').trim()+Year);
                        System.debug(objAT);
                        lstAccsToUpsert.add(objAT);
                    }    
                    
                }catch(Exception e){
                    System.debug(e.getStackTraceString());
                    System.debug('error msg-->'+e.getMessage());
                    System.debug('error line-->'+e.getLineNumber());
                    errorList.add(row+','+e.getMessage());
                    
                }
            }
            Schema.SObjectField f = Account_Target__c.Fields.Combination_Key__c;
            //System.debug('f====> '+f);  
            if(lstAccsToUpsert.size()>0){
                System.debug('lstAccsToUpsert====> '+lstAccsToUpsert);   
                strList=Database.upsert(lstAccsToUpsert,f,false);
                //System.debug('lstAccsToUpsert size-->'+strList.size());
                System.debug('strList->'+strList);
            }else{
                //System.debug('Data Not Found');
            }
            
            //System.debug('strList====> '+strList);
            for(Integer i=0;i<strList.size();i++){
                c=c+1;
                System.debug('enter for'+c);
                if(!strList[i].isSuccess()){
                    System.debug('enter for if');
                    Database.Error[] errs=strList[i].getErrors();
                    System.debug('errs->'+errs);
                    errorList.add(lstCSVLines[i+1]+','+errs[0].getMessage());
                    system.debug('error List-->'+errorList);
                    eListBudget.add(strList[i].getErrors()[0].getMessage());
                    system.debug('eListBudget List-->'+eListBudget);
                    
                }
                else {
                    successList.add(lstAccsToUpsert[i].get('Id')+','+lstCSVLines[i+1]);
                    //system.debug('SuccessList-->'+successList);
                }
            }   
            
            sendMail(String.join(errorList,'\r\n'),String.join(successList,'\r\n'),errorList.size()-1,successList.size()-1);
            
            
        }
        //system.debug('SuccessList-->'+successList);
        system.debug('error List-->'+errorList);
        return errorList;  
    }
    public static void sendMail(String err,String scc,Integer errCount,Integer sccCount){
        Messaging.EmailFileAttachment successAttach = new Messaging.EmailFileAttachment();
        successAttach.setContentType('application/csv');
        successAttach.setFileName('Success.csv');
        successAttach.setInline(false);
        successAttach.Body = Blob.valueOf(scc);
        
        Messaging.EmailFileAttachment errorAttach = new Messaging.EmailFileAttachment();
        errorAttach.setContentType('application/csv');
        errorAttach.setFileName('Error.csv');
        errorAttach.setInline(false);
        errorAttach.Body = Blob.valueOf(err);
        
        //     scc = 'Sucess File\r\n'+scc;
        //     blob successblob = Blob.valueOf(scc);
        //     successAttach.setBody(successblob);
        //     system.debug('sucess File>>--->'+scc);
        //     system.debug('error File>>--->'+err);
        //     Messaging.EmailFileAttachment errorAttach = new Messaging.EmailFileAttachment();
        //     errorAttach.setContentType('application/csv');
        //     errorAttach.setFileName('Error.csv');
        //     errorAttach.setInline(false);
        //     err = 'Error File\r\n'+err;
        //    blob errblob = Blob.valueOf(err);
        //     errorAttach.setBody(errblob);
        
        Date d = Date.Today() ;
        String dateString =  d.format() ;
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setUseSignature(false);
        //String[] toAddresses = new String[] {'tejaschavhan2@gmail.com'}; 
        //String[] ccAddresses = new String[] {'tejas.chavan@skinternational.com'};
        mail.setToAddresses(new String[] { System.Label.Email_Sent_to_SalesRep_or_SDM });
        //mail.setToAddresses(new String[] { UserInfo.getUserEmail(),'prashant.chinchpure@skinternational.com','tejas.chavan@skinternational.com','nilam.bangar@skinternational.com','shreyashi.ghosh@skinternational.com'});
        //mail.setToAddresses(new String[] { UserInfo.getUserEmail(),'prashant.chinchpure@skinternational.com','tejas.chavan@skinternational.com','nilam.bangar@skinternational.com','shreyashi.ghosh@skinternational.com','rafael.chiavenato@upl-ltd.com'});
        //mail.setToAddresses(new String[] { UserInfo.getUserEmail(),'prashant.chinchpure@skinternational.com','tejas.chavan@skinternational.com','nilam.bangar@skinternational.com','shreyashi.ghosh@skinternational.com','pedro.nery@upl-ltd.com','rafael.chiavenato@upl-ltd.com'});
        //mail.setToAddresses(new String[] { 'tejas.chavan@skinternational.com','prashant.chinchpure@skinternational.com'});
        //mail.setToAddresses(toAddresses);
        //mail.setCcAddresses(ccAddresses);
        //mail.setCcAddresses(new String[] {'tejas.chavan@skinternational.com'});
        
        mail.setCharset('UTF8');
        //mail.setReplyTo('support@acme.com');
        //mail.setSenderDisplayName(System.Label.Salesforce_Support);
        mail.setBccSender(false);
        mail.setUseSignature(false);
        
        
        mail.setSubject(System.Label.Data_Upload_Details_of_Budget);
        mail.setPlainTextBody(System.Label.List_of_success_and_error_records_of_Budget);
        mail.setHtmlBody(System.Label.Dear_User+',<br/><br/>'+System.Label.Please_find_attached_files_generated_in_SFDC_while_uploading_the_Budget_Data+'<br /><br />'+System.Label.Date+': '+dateString+'<br /><br />'+System.Label.No_of_error_records+': '+errCount+'<br /><br />'+System.Label.No_of_Success_records+': '+sccCount+'<br /><br />'+System.Label.Regards+',<br/>'+System.Label.UPL_Salesforce_Administrator+'<br/>');
        
        
        mail.setFileAttachments(new Messaging.EmailFileAttachment[] {errorAttach}); 
        
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
    
    
    @AuraEnabled
    public static String  getCurrentYear(){
        Integer Year = Date.Today().Year();
        String currentYear = String.valueOf(Year);
        System.debug('currentYear-->'+currentYear);
        return currentYear;
    }
    
    
    @AuraEnabled
    public static  List<WrapperFieldLabelYear>  getYearList()
    {
        /*------Dynamic Apex------*/
        Schema.DescribeFieldResult fieldResult = Account_Target__c.Year__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        List<WrapperFieldLabelYear> wrapperlist=new List<WrapperFieldLabelYear>();
        Date dat = System.today();
        String yr =string.valueOf(dat.year()+1);
        System.debug('Year is ' + yr);
        for( Schema.PicklistEntry f : ple){
            WrapperFieldLabelYear wrapperObj=new WrapperFieldLabelYear();
            
            System.debug('f.getLabel() '+f.getLabel());
            String yrs = f.getLabel();
            
            wrapperObj.label=f.getLabel();
            wrapperObj.value=f.getValue();
            if(yrs==yr){
                break;
            }
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
    
    /*@AuraEnabled
public static String  getCurrentMonth(){
Integer Month = Date.Today().Month();
String currentMonth = String.valueOf(Month);
System.debug('currentMonth-->'+currentMonth);
return currentMonth;
}

@AuraEnabled
public static  List<WrapperFieldLabelMonth>  getMonthList()
{
//------Dynamic Apex------
Schema.DescribeFieldResult fieldResult = Account_Target__c.Month__c.getDescribe();
List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();

List<WrapperFieldLabelMonth> wrapperlist=new List<WrapperFieldLabelMonth>();
for( Schema.PicklistEntry f : ple)
{
WrapperFieldLabelMonth wrapperObj=new WrapperFieldLabelMonth();

wrapperObj.label=f.getLabel();
wrapperObj.value=f.getValue();
wrapperlist.add(wrapperObj);

} 
//system.debug('Fiscal Year-->'+wrapperlist);
return wrapperlist;
}

public class WrapperFieldLabelMonth
{
@AuraEnabled
public String label{get;set;}
@AuraEnabled
public String value{get;set;}


public WrapperFieldLabelMonth()
{
label='';
value='';
}
}*/
}