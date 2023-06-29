/**************************************************************************************************
* Name               : Grz_CreditNotesIndiaController                                                      
* Description        : Controller class for grz_CreditNotes LWC Component
* Test Calss         : Grz_CreditNotesIndiaControllerTest
* Created Date       : 21/06/2023                                                                 
* Created By         : Nikhil Verma (Grazitti) RITM0575970                                                                      
**************************************************************************************************/ 
public with sharing class Grz_CreditNotesIndiaController {
    @AuraEnabled(cacheable=true)
    public static ResultWrapper getAccInfo(){
        List<Period> fiscalYearList = [Select Type, StartDate, EndDate, Number, FiscalYearSettings.PeriodId From Period Where Type='Year' and startDate <= TODAY and endDate >= TODAY];
        Integer curFiscYear = fiscalYearList[0].StartDate.year();
        Id id;
        if(Test.isRunningTest()){
            List<Profile> pro = [SELECT Id FROM Profile WHERE Name = 'India Partner Community Distributor Profile'];
            List<User> user = [SELECT Id, Username, AccountId, ContactId FROM User WHERE ProfileId =: pro[0].Id AND lastname = 'Testing' and Email ='test@grazitti.com' LIMIT 1];
            id = user[0].Id;
        }
        else{
            id = UserInfo.getUserId();
        }
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
        public CustomerInfo cstInfo { get; set; }
    }  

    @AuraEnabled
    public static Grz_AccountLedgerStatementWrapper1 getLedgerStatement(String customerCode, String companyCode, String fiscalYear, String fiscalYearFrom, String fiscalYearTo , Boolean getDoc , String sapUserId, String accountidinfo){
        Grz_AccountLedgerStatementWrapper1 Data = new Grz_AccountLedgerStatementWrapper1();
        if(customerCode==null || companyCode==null || sapUserId==null ){
            Data.isSuccess=false;
            Data.msg='Customer Code/Company Code/User ID is empty. Please contact administrator';
        }else{
            String res;
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
                Set<String> AccountDocSet = new Set<String>();
                List<ItemInfo> filterInfo = new List<ItemInfo>();
                for(ItemInfo ifo : Data.ItemInfo){
                    if(ifo.PostDate !='0000-00-00' && (ifo.DocType.equals('RG') || ifo.DocType.equals('RV')) && ifo.AccountingDocNumber!='' && ifo.AccountingDocNumber!= NULL){
                        filterInfo.add(ifo);
                        AccountDocSet.add(ifo.AccountingDocNumber);
                    }
                }
                Map<String,String> contentDocMap = new Map<String,String>();
                    if(accountidinfo != null && AccountDocSet!= null){
                        for(ContentDocumentLink con : [SELECT Id, LinkedEntityId, ContentDocumentId, ContentDocument.Title FROM ContentDocumentLink where LinkedEntityId =:Id.valueOf(accountidinfo)]){
                            String Title = con.ContentDocument.Title;
                            if(Title.length()> 10){
                                String title1=Title;
                                if(Title.contains('.')){
                                    title1=Title.split('\\.')[0];
                                }
                                String lastchar = title1.RIGHT(10);
                                if(AccountDocSet.contains(lastchar)){
                                    contentDocMap.put(lastchar,con.ContentDocumentId);
                                }   
                            }
                        }
                    }
                    for(ItemInfo ifo :filterInfo){
                    for(String accountdoctypeobj : AccountDocSet){
                            if(contentDocMap.containskey(accountdoctypeobj) && ifo.AccountingDocNumber==accountdoctypeobj ){
                                ifo.ContentDocid = contentDocMap.get(accountdoctypeobj);
                                ifo.Doctyperecordcheck = true;
                                break;
                            }else{
                                ifo.Doctyperecordcheck = false;
                            }
                        }
                    }
            
                for(ItemInfo ifo : filterInfo){
                    ifo.PostDate = grz_SapIntegration.FormattedDate(Date.valueof(ifo.PostDate));
                    ifo.Credit = Grz_AccountLedgerStatement.inrValue(Decimal.valueOf(ifo.Credit));
                    ifo.Debit = Grz_AccountLedgerStatement.inrValue(Decimal.valueOf(ifo.Debit));
                    ifo.RunningBalance = Grz_AccountLedgerStatement.inrValue(Decimal.valueOf(ifo.RunningBalance));
                }
                Data.ItemInfo = filterInfo;
                Data.isSuccess=true;
                Data.msg='';
            }
        }
        return Data;
    }
    
    public static Grz_AccountLedgerStatementWrapper1 parse(String json) {
        return (Grz_AccountLedgerStatementWrapper1) System.JSON.deserialize(json, Grz_AccountLedgerStatementWrapper1.class);
    }
    
    public class Grz_AccountLedgerStatementWrapper1 {
        @AuraEnabled public CustomerInfo customerInfo{get;set;}
        @AuraEnabled public List<ItemInfo> ItemInfo{get;set;}
        @AuraEnabled public Boolean isSuccess{get;set;}
        @AuraEnabled public String msg{get;set;}
       
        
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
        @AuraEnabled public String Plant{get;set;}
    }
}