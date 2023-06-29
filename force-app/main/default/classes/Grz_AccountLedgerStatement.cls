public with sharing class Grz_AccountLedgerStatement {
    @AuraEnabled(cacheable=true)
    public static ResultWrapper getAccInfo(){
        List<Period> fiscalYearList = [Select Type, StartDate, EndDate, Number, FiscalYearSettings.PeriodId From Period Where Type='Year' and startDate <= TODAY and endDate >= TODAY];
        Integer curFiscYear = fiscalYearList[0].StartDate.year();
        System.debug('curFiscYear : '+curFiscYear);
        Id id;
        if(Test.isRunningTest()){
            List<Profile> pro = [SELECT Id FROM Profile WHERE Name = 'India Partner Community Distributor Profile'];
            List<User> user = [SELECT Id, Username, AccountId, ContactId FROM User WHERE ProfileId =: pro[0].Id AND lastname = 'Testing' and Email ='test@grazitti.com' LIMIT 1];
            id = user[0].Id;
        }
        else{
            id = UserInfo.getUserId();
        }
        System.debug('User id : '+id);
        List<User> user = [SELECT Id, Username, AccountId, ContactId FROM User where Id =: id];
        String accountId = user[0].AccountId;
        Account accData = [SELECT Id, Name ,Territory_Distributor__r.Name,SAP_Customer_Code__c, Company_Code__c ,Sap_UserId__c FROM Account WHERE Id =:accountId];
        ResultWrapper rap = new ResultWrapper();
        rap.Id=accData.Id;
        rap.customerCode = accData.SAP_Customer_Code__c;
        rap.companyCode = accData.Company_Code__c;
        rap.sapUserId = accData.Sap_UserId__c;
        rap.name = accData.Name;
        rap.city = accData.Territory_Distributor__r.Name;
        rap.currentFiscalYear = curFiscYear;
        rap.docTypeInfo = [SELECT Id, DeveloperName, Language, Label, QualifiedApiName, Short_Form__c, Full_Form__c FROM Account_Doc_Type__mdt order by Short_Form__c ];
        Date dd =fiscalYearList[0].StartDate;
        return rap;
    }
    public class ResultWrapper {
        @AuraEnabled
        public String Id { get; set; }
        @AuraEnabled
        public String customerCode { get; set; }
        @AuraEnabled
        public String sapUserId { get; set; }
        @AuraEnabled
        public String companyCode { get; set; }
        @AuraEnabled
        public String name { get; set; }
        @AuraEnabled
        public String city { get; set; }
        @AuraEnabled
        public Integer currentFiscalYear { get; set; }
        @AuraEnabled
        public List<Account_Doc_Type__mdt> docTypeInfo { get; set; }
        @AuraEnabled
        public CustomerInfo cstInfo { get; set; }
    }

     @AuraEnabled
    public static void SendMail(String Url, String startdate, String enddate){
        System.debug('Url---'+Url);
         System.debug('startdate-----'+startdate);
          System.debug('enddate-----'+enddate);
       PageReference pageRef = new PageReference(Url);
        Blob body;
        if(!test.isRunningTest()){
         body = pageRef.getContent();
        }
        else{
            body = blob.valueOf('Test');
        }
        String name = UserInfo.getName();
        List<String> emailaddress = new List<String>();
        String email = UserInfo.getUserEmail();
        emailaddress.add(email);
        EmailTemplate p =[Select Id,body,HtmlValue,subject from EmailTemplate where developername =: 'Account_Template' limit 1];
        String Html = p.HtmlValue;
        Html = Html.replace('[name]', name);
         Html = Html.replace('[from_date]', grz_SapIntegration.FormattedDate(Date.valueof(startdate)));
         Html = Html.replace('[to_date]', grz_SapIntegration.FormattedDate(Date.valueof(enddate)));
        
        Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
        attach.setContentType('application/pdf');
        attach.setFileName('Account_Statement.pdf');
        attach.setInline(false);
        attach.Body = body;
        
        OrgWideEmailAddress owa = [select id, DisplayName, Address from OrgWideEmailAddress where displayname =: 'Sales Excellence' ];
        String fromAdressId = owa.id;
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setUseSignature(false);
            mail.setOrgWideEmailAddressId(fromAdressId);
            mail.setHtmlBody(Html);
            mail.setToAddresses(emailaddress);
            mail.setSubject('Customer Account Statement');
            mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attach });
            Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {mail};
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages,false);
            
            
    }
    
    
    @AuraEnabled
    public static Grz_AccountLedgerStatementWrapper1 getAccountStatement(String customerCode, String companyCode, String fiscalYear, String fiscalYearFrom, String fiscalYearTo, List<String> docFilter , String startDate , String endDate , Boolean getDoc, String sapUserId, String accountidinfo)
    {
         system.debug('getAccountStatement');
        Grz_AccountLedgerStatementWrapper1 Data = new Grz_AccountLedgerStatementWrapper1();
        if(customerCode==null || companyCode==null || sapUserId==null ){
            Data.isSuccess=false;
            Data.msg='Customer Code/Company Code/User ID is empty. Please contact administrator';
        }else{
            String res;
            //Code Updated by Grz(Sumit Kumar) 17-02-2023 for Customer 360 New Integration Changes (Ticket No. APPS-5366)
            String fiscalYearCheck = System.Label.Grz_HanaFiscalYear;
            Map<String, Grz_Customer360IntegrationMappings__mdt> integrationSettingsMap = Grz_SapCommonIntegration.getIntegrationMappings();
            List<Account> accList = [SELECT Id, Sap_UserId__c, Company_Code__c,Sales_Org_Code__c, SAP_Customer_Code__c, Sales_Org_Country__c FROM Account WHERE SAP_Customer_Code__c =: customerCode];
            String salesOrgCode = accList[0].Sales_Org_Code__c;
            if(integrationSettingsMap != null && integrationSettingsMap.containsKey(salesOrgCode) && integrationSettingsMap.get(salesOrgCode).Country__c == 'India'){
                if(integrationSettingsMap.get(salesOrgCode).EndPointURL__c != null && Integer.ValueOf(fiscalYear) >= Integer.ValueOf(fiscalYearCheck)){   //Code Updated by Grz(Sumit Kumar) 18-05-2023 for Customer 360 New Integration Changes (Ticket No. APPS-5366)
                    system.debug('fiscalYear in if : '+fiscalYear);
                    String endPointName = integrationSettingsMap.get(salesOrgCode).EndPointURL__c;
                	res = Grz_SapCommonIntegration.customerLedgerMarketingIND(customerCode, companyCode, fiscalYear, fiscalYearFrom, fiscalYearTo, sapUserId,endPointName);
                }else{
                    system.debug('fiscalYear in else : '+fiscalYear);
                	res = grz_SapIntegration.AccountAndLedgerStatement(customerCode,companyCode,fiscalYear,fiscalYearFrom,fiscalYearTo,sapUserId);
                }
            }else{
                res = grz_SapIntegration.AccountAndLedgerStatement(customerCode,companyCode,fiscalYear,fiscalYearFrom,fiscalYearTo,sapUserId);
            }

            if(res.equals('Error_In_Sap')){
                Data.isSuccess=false;
                Data.msg='Error in SAP';
            }
            else{
            Data = Grz_AccountLedgerStatementWrapper1.parse(res);
            Decimal totalCredit = 0.0;
            Decimal totalDebit = 0.0;
            List<ItemInfo> filterInfo = new List<ItemInfo>();
            Set<String> avlDoc = new Set<String>();
            for(ItemInfo ifo : Data.ItemInfo){
                if(ifo.PostDate !='0000-00-00'){
                    if(docFilter.isEmpty()){
                        if(date.valueOf(ifo.PostDate) >= date.valueOf(startDate) && date.valueOf(ifo.PostDate) <= date.valueOf(endDate)){
                            filterInfo.add(ifo);
                        }
                    }else{
                        for (String docStr : docFilter) {
                            if(date.valueOf(ifo.PostDate) >= date.valueOf(startDate) && date.valueOf(ifo.PostDate) <= date.valueOf(endDate) && ifo.DocType == docStr){
                                filterInfo.add(ifo);
                            }
                        }
                    } 
                }
            }
            Set<String> AccountDocSet = new Set<String>();
        
            for(ItemInfo ifo :filterInfo){
                totalCredit = totalCredit + Decimal.valueOf(ifo.Credit).setScale(2);
                totalDebit = totalDebit + Decimal.valueOf(ifo.Debit).setScale(2);
                ifo.PostDate = grz_SapIntegration.FormattedDate(Date.valueof(ifo.PostDate));
                avlDoc.add(ifo.DocType);
                System.debug('avlDoc----'+avlDoc);
                //Change by grazitti 1Nov22 as suggested by Ankur(SAP) to change code for credit note from CN to RG
               //Change by Aashima(grazitti) for INCTASK1072342 23Dec22
                if((ifo.DocType.equals('RG') || ifo.DocType.equals('RV')) && ifo.AccountingDocNumber !='' && ifo.AccountingDocNumber != NULL){
                    AccountDocSet.add(ifo.AccountingDocNumber);
                }
                System.debug('AccountDocSet--------'+AccountDocSet);
                ifo.Credit = Grz_AccountLedgerStatement.inrValue(Decimal.valueOf(ifo.Credit));
                ifo.Debit = Grz_AccountLedgerStatement.inrValue(Decimal.valueOf(ifo.Debit));
            }
                Map<String,String> contentDocMap = new Map<String,String>();
                    if(accountidinfo!=null && AccountDocSet!=null){
                        System.debug('accountidinfo--------'+accountidinfo);
                        for(ContentDocumentLink con : [SELECT Id, LinkedEntityId, ContentDocumentId, ContentDocument.Title FROM ContentDocumentLink where LinkedEntityId =:Id.valueOf(accountidinfo)]){
                           
                            String Title = con.ContentDocument.Title;
                            System.debug('Title--------'+Title);
                            if(Title.length()> 10){
                              
                                String title1=Title;
                                if(Title.contains('.')){
                                    title1=Title.split('\\.')[0];
                                      System.debug('title1--------'+title1);
                                    }
                                String lastchar = title1.RIGHT(10);
                                  System.debug('lastchar--------'+lastchar);
                                if(AccountDocSet.contains(lastchar)){
                                    contentDocMap.put(lastchar,con.ContentDocumentId);
                                         }   
                                          System.debug('contentDocMap--------'+contentDocMap);            
                                                    }
                                    }
                 }
                 //Change by grazitti 1Nov22 for credit note functionality
                  for(ItemInfo ifo :filterInfo){
                  for(String accountdoctypeobj : AccountDocSet){
                        if(contentDocMap.containskey(accountdoctypeobj) && ifo.AccountingDocNumber==accountdoctypeobj ){
                            //Change by grazitti 12Dec22 for Invoice Download functionality by Swaranjeet
                            ifo.ContentDocid = contentDocMap.get(accountdoctypeobj);
                            System.debug('Data.ContentDocid--------'+ifo.ContentDocid);
                            ifo.Doctyperecordcheck = true;
                             System.debug('Data.Doctyperecordcheck--------'+ifo.Doctyperecordcheck);
                             break;
                            }
                        else{
                            ifo.Doctyperecordcheck = false;
                             System.debug('Data.Doctyperecordcheck--------'+ifo.Doctyperecordcheck);
                             }
                    }
                 }
            List<MetaDocType> lstMeta = new List<MetaDocType>();
            if(getDoc){
                List<Account_Doc_Type__mdt> abc = [SELECT Short_Form__c, Full_Form__c FROM Account_Doc_Type__mdt WHERE Short_Form__c IN: avlDoc order by Short_Form__c];
                for(Account_Doc_Type__mdt ad : abc){
                    MetaDocType me = new MetaDocType();
                    me.shortForm = ad.Short_Form__c;
                    me.fullForm = ad.Full_Form__c;
                    lstMeta.add(me);
                }
            }
            Data.totalCredit = String.valueOf(totalCredit);
            Data.totalDebit = String.valueOf(totalDebit);
            Data.totalCredit = Grz_AccountLedgerStatement.inrValue(Decimal.valueOf(Data.totalCredit));
            Data.totalDebit = Grz_AccountLedgerStatement.inrValue(Decimal.valueOf(Data.totalDebit));
            Data.ItemInfo = filterInfo;
            Data.isSuccess=true;
            Data.msg='';
            if(getDoc){
                Data.MetaDocType = lstMeta;
            }            
        }
        }
        return Data;
    }
     
    @AuraEnabled
    public static Grz_AccountLedgerStatementWrapper1 getLedgerStatement(String customerCode, String companyCode, String fiscalYear, String fiscalYearFrom, String fiscalYearTo , Boolean getDoc , String sapUserId, String accountidinfo){
        Grz_AccountLedgerStatementWrapper1 Data = new Grz_AccountLedgerStatementWrapper1();
        if(customerCode==null || companyCode==null || sapUserId==null ){
            Data.isSuccess=false;
            Data.msg='Customer Code/Company Code/User ID is empty. Please contact administrator';
        }else{
            String res;
            //Code Updated by Grz(Sumit Kumar) 17-02-2023 for Customer 360 New Integration Changes (Ticket No. APPS-5366)
            String fiscalYearCheck = System.Label.Grz_HanaFiscalYear;
            Map<String, Grz_Customer360IntegrationMappings__mdt> integrationSettingsMap = Grz_SapCommonIntegration.getIntegrationMappings();
            List<Account> accList = [SELECT Id, Sap_UserId__c, Company_Code__c,Sales_Org_Code__c, SAP_Customer_Code__c, Sales_Org_Country__c FROM Account WHERE SAP_Customer_Code__c =: customerCode];
            String salesOrgCode = accList[0].Sales_Org_Code__c;
            if(integrationSettingsMap != null && integrationSettingsMap.containsKey(salesOrgCode) && integrationSettingsMap.get(salesOrgCode).Country__c == 'India'){
                if(integrationSettingsMap.get(salesOrgCode).EndPointURL__c != null && Integer.ValueOf(fiscalYear) >= Integer.ValueOf(fiscalYearCheck)){       //Code Updated by Grz(Sumit Kumar) 18-05-2023 for Customer 360 New Integration Changes (Ticket No. APPS-5366)
                    system.debug('fiscalYear in if '+fiscalYear);
                    String endPointName = integrationSettingsMap.get(salesOrgCode).EndPointURL__c;
                	res = Grz_SapCommonIntegration.customerLedgerMarketingIND(customerCode, companyCode, fiscalYear, fiscalYearFrom, fiscalYearTo, sapUserId,endPointName);
                }else{
                    system.debug('fiscalYear in else '+fiscalYear);
                	res = grz_SapIntegration.AccountAndLedgerStatement(customerCode,companyCode,fiscalYear,fiscalYearFrom,fiscalYearTo,sapUserId);
                }
            }else{
                res = grz_SapIntegration.AccountAndLedgerStatement(customerCode,companyCode,fiscalYear,fiscalYearFrom,fiscalYearTo,sapUserId);
            }
            if(res.equals('Error_In_Sap')){
                Data.isSuccess=false;
                Data.msg='Error in SAP';
            }
            else{
            Data = Grz_AccountLedgerStatementWrapper1.parse(res);
            Decimal totalCredit = 0.0;
            Decimal totalDebit = 0.0;
            Set<String> AccountDocSet = new Set<String>();
            List<ItemInfo> filterInfo = new List<ItemInfo>();
            Set<String> avlDoc = new Set<String>();
            for(ItemInfo ifo : Data.ItemInfo){
                if(ifo.PostDate !='0000-00-00'){
                    filterinfo.add(ifo);
                    avlDoc.add(ifo.DocType);
                    
                }
                
                 //Change by grazitti 1Nov22 as suggested by Ankur(SAP) to change code for credit note from CN to RG
               
               //Change by Aashima(grazitti) for INCTASK1072342 23Dec22
                    if((ifo.DocType.equals('RG') || ifo.DocType.equals('RV')) && ifo.AccountingDocNumber!='' && ifo.AccountingDocNumber!= NULL)
                    {
                         AccountDocSet.add(ifo.AccountingDocNumber);
                       
                    }
                    System.debug('AccountDocSet890--------'+AccountDocSet);
                totalCredit = totalCredit + Decimal.valueOf(ifo.Credit).setScale(2);
                totalDebit = totalDebit + Decimal.valueOf(ifo.Debit).setScale(2);
            }
              Map<String,String> contentDocMap = new Map<String,String>();
                    if(accountidinfo!=null && AccountDocSet!=null){
                        System.debug('accountidinfo--------'+accountidinfo);
                        for(ContentDocumentLink con : [SELECT Id, LinkedEntityId, ContentDocumentId, ContentDocument.Title FROM ContentDocumentLink where LinkedEntityId =:Id.valueOf(accountidinfo)]){
                           
                            String Title = con.ContentDocument.Title;
                            System.debug('Title--------'+Title);
                            if(Title.length()> 10){
                              
                                String title1=Title;
                                if(Title.contains('.')){
                                    title1=Title.split('\\.')[0];
                                      System.debug('title1--------'+title1);
                                    }
                                String lastchar = title1.RIGHT(10);
                                  System.debug('lastchar--------'+lastchar);
                                if(AccountDocSet.contains(lastchar)){
                                    contentDocMap.put(lastchar,con.ContentDocumentId);
                                         }   
                                          System.debug('contentDocMap--------'+contentDocMap);            
                                                    }
                                    }
                 }
                                  //Change by grazitti 1Nov22 for credit note functionality
                 system.debug('filterInfo==>'+filterInfo);
                  for(ItemInfo ifo :filterInfo){
                               system.debug('ifo ==>'+ifo );
                  for(String accountdoctypeobj : AccountDocSet){
                  system.debug('accountdoctypeobj ==>'+accountdoctypeobj );
                        if(contentDocMap.containskey(accountdoctypeobj) && ifo.AccountingDocNumber==accountdoctypeobj ){
                            //Change by grazitti 12Dec22 for Invoice Download functionality by Swaranjeet
                            ifo.ContentDocid = contentDocMap.get(accountdoctypeobj);
                            System.debug('Data.ContentDocid--------'+ifo.ContentDocid);
                            ifo.Doctyperecordcheck = true;
                             System.debug('Data.Doctyperecordcheck--------'+ifo.Doctyperecordcheck);
                             break;
                            }
                        else{
                            ifo.Doctyperecordcheck = false;
                             System.debug('Data.Doctyperecordcheck--------'+ifo.Doctyperecordcheck);
                             }
                             
                             system.debug('ifo after==>'+ifo );
                    }
                 }
            if(Data.CustomerInfo.OpeningBalance.contains('-') && Data.CustomerInfo.ClosingBalance.contains('-')){
                Data.totalCredit = String.valueOf(totalCredit - Decimal.valueOf(Data.CustomerInfo.OpeningBalance));
                Data.totalDebit = String.valueOf(totalDebit - Decimal.valueOf(Data.CustomerInfo.ClosingBalance));
            }else{
                Data.totalCredit = String.valueOf(totalCredit + Decimal.valueOf(Data.CustomerInfo.ClosingBalance));
                Data.totalDebit = String.valueOf(totalDebit + Decimal.valueOf(Data.CustomerInfo.OpeningBalance));
            }
            if(Data.CustomerInfo.OpeningBalance.contains('-') && !Data.CustomerInfo.ClosingBalance.contains('-')){
                Data.totalCredit = String.valueOf(totalCredit + Decimal.valueOf(Data.CustomerInfo.ClosingBalance) - Decimal.valueOf(Data.CustomerInfo.OpeningBalance));
                Data.totalDebit = String.valueOf(totalDebit);
            }else if(!Data.CustomerInfo.OpeningBalance.contains('-') && Data.CustomerInfo.ClosingBalance.contains('-')){
                Data.totalDebit = String.valueOf(totalDebit + Decimal.valueOf(Data.CustomerInfo.OpeningBalance) - Decimal.valueOf(Data.CustomerInfo.ClosingBalance));
                Data.totalCredit = String.valueOf(totalCredit);
            }
            
            List<MetaDocType> lstMeta = new List<MetaDocType>();
            if(getDoc){
                List<Account_Doc_Type__mdt> abc = [SELECT Short_Form__c, Full_Form__c FROM Account_Doc_Type__mdt WHERE Short_Form__c IN: avlDoc order by Short_Form__c];
                for(Account_Doc_Type__mdt ad : abc){
                    MetaDocType me = new MetaDocType();
                    me.shortForm = ad.Short_Form__c;
                    me.fullForm = ad.Full_Form__c;
                    lstMeta.add(me);
                }
            }
            for(ItemInfo ifo : filterInfo){
                ifo.PostDate = grz_SapIntegration.FormattedDate(Date.valueof(ifo.PostDate));
                ifo.Credit = Grz_AccountLedgerStatement.inrValue(Decimal.valueOf(ifo.Credit));
                ifo.Debit = Grz_AccountLedgerStatement.inrValue(Decimal.valueOf(ifo.Debit));
                ifo.RunningBalance = Grz_AccountLedgerStatement.inrValue(Decimal.valueOf(ifo.RunningBalance));
            }
            Data.ItemInfo = filterInfo;
            Data.CustomerInfo.ClosingBalance = Grz_AccountLedgerStatement.inrValue(Decimal.valueOf(Data.CustomerInfo.ClosingBalance));
            Data.CustomerInfo.OpeningBalance = Grz_AccountLedgerStatement.inrValue(Decimal.valueOf(Data.CustomerInfo.OpeningBalance));
            Data.totalCredit = Grz_AccountLedgerStatement.inrValue(Decimal.valueOf(Data.totalCredit));
            Data.totalDebit = Grz_AccountLedgerStatement.inrValue(Decimal.valueOf(Data.totalDebit));
            Data.isSuccess=true;
            Data.msg='';
            if(getDoc){
                Data.MetaDocType = lstMeta;
            }
            }
        }
        
        return Data;
    }
    
    public static String inrValue(Decimal inrValue){
        List<String> args = new String[]{'0','number','#,###.0'};
        String parseVal = String.format(inrValue.format(), args);
        return parseVal;
    }
    public static Grz_AccountLedgerStatementWrapper1 parse(String json) {
        return (Grz_AccountLedgerStatementWrapper1) System.JSON.deserialize(json, Grz_AccountLedgerStatementWrapper1.class);
    }
    
    public class Grz_AccountLedgerStatementWrapper1 {
        @AuraEnabled public CustomerInfo customerInfo{get;set;}
        @AuraEnabled public List<ItemInfo> ItemInfo{get;set;}
        @AuraEnabled public List<MetaDocType> MetaDocType{get;set;}
        @AuraEnabled public String totalCredit{get;set;}
        @AuraEnabled public String totalDebit{get;set;}
        @AuraEnabled public Boolean isSuccess{get;set;}
        @AuraEnabled public String msg{get;set;}
       
        
    }
    public class MetaDocType {
        @AuraEnabled public String shortForm{get;set;}
        @AuraEnabled public String fullForm{get;set;}
    }
    public class ItemInfo {
        @AuraEnabled public String Date1{get;set;}
        @AuraEnabled public String DocNumber{get;set;}
        @AuraEnabled public String DocType{get;set;}
        @AuraEnabled public String Credit{get;set;}
        @AuraEnabled public String Debit{get;set;}
        @AuraEnabled public String PostingDate{get;set;}
        @AuraEnabled public String ReferenceDocumentNumber{get;set;}
        @AuraEnabled public String ReferebceChqNumber{get;set;}
        @AuraEnabled public String RunningBalance{get;set;}
        @AuraEnabled public String DocumentHeaderText{get;set;}
        @AuraEnabled public String AccountingDocNumber{get;set;}
        @AuraEnabled public String PostDate{get;set;}
        @AuraEnabled public String SGTXT{get;set;}
        @AuraEnabled public Boolean Doctyperecordcheck{get;set;}
         @AuraEnabled public String ContentDocid{get;set;}
    }
    
    public class CustomerInfo {
        @AuraEnabled public String CustomerName{get;set;}
        @AuraEnabled public String CustomerCode{get;set;}
        @AuraEnabled public String City{get;set;}
        @AuraEnabled public String SalesOffice{get;set;}
        @AuraEnabled public String GlAccountName{get;set;}
        @AuraEnabled public String GlAccountNumber{get;set;}
        @AuraEnabled public String GlAccountLongText{get;set;}
        @AuraEnabled public String OpeningBalance{get;set;}
        @AuraEnabled public String ClosingBalance{get;set;}
        @AuraEnabled public String Plant{get;set;}
    }
}