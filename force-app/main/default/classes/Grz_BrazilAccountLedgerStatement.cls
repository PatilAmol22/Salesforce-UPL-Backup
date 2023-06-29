public with sharing class Grz_BrazilAccountLedgerStatement {
    @AuraEnabled(cacheable=true)
    public static ResultWrapper getAccInfo(){
        ResultWrapper rap = new ResultWrapper();
        rap.docTypeInfo = [SELECT Id, DeveloperName, Language, Label, QualifiedApiName, Short_Form__c, Full_Form__c FROM Account_Doc_Type_Brazil__mdt order by Short_Form__c ];
        return rap;
    }
    public class ResultWrapper {
        @AuraEnabled public List<Account_Doc_Type_Brazil__mdt> docTypeInfo { get; set; }
    }
    
    @AuraEnabled
    public static Grz_BrazilAccountLedgerStatementWrapper1 getAccountStatement(String customerCode, String fiscalYear, String fiscalYearFrom, String fiscalYearTo, List<String> docFilter , String startDate , String endDate , Boolean getDoc){
        Grz_BrazilAccountLedgerStatementWrapper1 Data = new Grz_BrazilAccountLedgerStatementWrapper1();
        List<String> salesorgcode = System.Label.Grz_BrazilSalesOrgCode.trim().Split(',');
        List<Account> accList = [SELECT Id,Sap_UserId__c ,Company_Code__c FROM Account WHERE SAP_Code__c =: customerCode AND Sales_org_Code__c in:salesorgcode LIMIT 1];
        if(!accList.isEmpty()){
            String sapUserId = accList[0].Sap_UserId__c;
            String companyCode =accList[0].Company_Code__c;
            Data.noDistributor = false;
            if(String.isEmpty(companyCode) || String.isEmpty(sapUserId) ){
                Data.isSuccess=false;
                Data.msg='Código da empresa / ID do usuário não encontrado. Por favor, contate o administrador';
            }else{
                Data.isSuccess=true;
                String res = grz_SapIntegration.AccountAndLedgerStatementForBrazil(customerCode,companyCode,fiscalYear,fiscalYearFrom,fiscalYearTo,sapUserId);
                if(res.equals('Error_In_Sap')){
                    Data.isSAPSuccess = false;
                }
                else{
                    Data.isSAPSuccess = true;
                    Data = Grz_BrazilAccountLedgerStatementWrapper1.parse(res);
                    Decimal totalCredit = 0.0;
                    Decimal totalDebit = 0.0;
                    List<ItemInfo> filterInfo = new List<ItemInfo>();
                    List<String> avlDoc = new List<String>();
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
                    for(ItemInfo ifo :filterInfo){
                        totalCredit = totalCredit + Decimal.valueOf(ifo.Credit).setScale(2);
                        totalDebit = totalDebit + Decimal.valueOf(ifo.Debit).setScale(2);
                        ifo.PostDate = grz_SapIntegration.FormattedDateBrazil(Date.valueof(ifo.PostDate));
                        avlDoc.add(ifo.DocType);
                        ifo.Credit = String.valueOf(Decimal.valueOf(ifo.Credit));
                        ifo.Debit = String.valueOf(Decimal.valueOf(ifo.Debit));
                    }
                    List<MetaDocType> lstMeta = new List<MetaDocType>();
                    if(getDoc){
                        List<Account_Doc_Type_Brazil__mdt> abc = [SELECT Short_Form__c, Full_Form__c FROM Account_Doc_Type_Brazil__mdt WHERE Short_Form__c IN: avlDoc order by Short_Form__c];
                        for(Account_Doc_Type_Brazil__mdt ad : abc){
                            MetaDocType me = new MetaDocType();
                            me.shortForm = ad.Short_Form__c;
                            me.fullForm = ad.Full_Form__c;
                            lstMeta.add(me);
                        }
                    }
                    Data.totalCredit = String.valueOf(totalCredit);
                    Data.totalDebit = String.valueOf(totalDebit);
                    Data.totalCredit = String.valueOf(Decimal.valueOf(Data.totalCredit));
                    Data.totalDebit = String.valueOf(Decimal.valueOf(Data.totalDebit));
                    Data.ItemInfo = filterInfo;
                    Data.msg='';
                    Data.isSAPSuccess = true;
                    Data.isSuccess = true;
                    if(getDoc){
                        Data.MetaDocType = lstMeta;
                    } 
                }           
            }
        }else{
            Data.noDistributor = true;
        }        
        return Data;
    }
    @AuraEnabled
    public static Grz_BrazilAccountLedgerStatementWrapper1 getLedgerStatement(String customerCode, String fiscalYear, String fiscalYearFrom, String fiscalYearTo , Boolean getDoc){
        Grz_BrazilAccountLedgerStatementWrapper1 Data = new Grz_BrazilAccountLedgerStatementWrapper1();
         List<String> salesorgcode = System.Label.Grz_BrazilSalesOrgCode.trim().Split(',');
        List<Account> accList = [SELECT Id,Sap_UserId__c ,Company_Code__c FROM Account WHERE SAP_Code__c =: customerCode AND Sales_org_Code__c in:salesorgcode LIMIT 1];
        if(!accList.isEmpty()){
            String sapUserId = accList[0].Sap_UserId__c;
            String companyCode =accList[0].Company_Code__c;
            Data.noDistributor = false;
            if(String.isEmpty(companyCode) || String.isEmpty(sapUserId)){
                Data.isSuccess = false;
                Data.msg='Código da empresa / ID do usuário não encontrado. Por favor, contate o administrador';
            }else{
                Data.isSuccess=true;
                String res = grz_SapIntegration.AccountAndLedgerStatementForBrazil(customerCode,companyCode,fiscalYear,fiscalYearFrom,fiscalYearTo, sapUserId);
                if(res.equals('Error_In_Sap')){
                    Data.isSAPSuccess = false;
                }
                else{
                    Data.isSAPSuccess = true;
                    Data = Grz_BrazilAccountLedgerStatementWrapper1.parse(res);
                    Decimal totalCredit = 0.0;
                    Decimal totalDebit = 0.0;
                    
                    List<ItemInfo> filterInfo = new List<ItemInfo>();
                    List<String> avlDoc = new List<String>();
                    for(ItemInfo ifo : Data.ItemInfo){
                        if(ifo.PostDate !='0000-00-00'){
                            filterinfo.add(ifo);
                            avlDoc.add(ifo.DocType);
                        }
                        totalCredit = totalCredit + Decimal.valueOf(ifo.Credit).setScale(2);
                        totalDebit = totalDebit + Decimal.valueOf(ifo.Debit).setScale(2);
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
                        List<Account_Doc_Type_Brazil__mdt> abc = [SELECT Short_Form__c, Full_Form__c FROM Account_Doc_Type_Brazil__mdt WHERE Short_Form__c IN: avlDoc order by Short_Form__c];
                        for(Account_Doc_Type_Brazil__mdt ad : abc){
                            MetaDocType me = new MetaDocType();
                            me.shortForm = ad.Short_Form__c;
                            me.fullForm = ad.Full_Form__c;
                            lstMeta.add(me);
                        }
                    }
                    for(ItemInfo ifo : filterInfo){
                        ifo.PostDate = grz_SapIntegration.FormattedDateBrazil(Date.valueof(ifo.PostDate));
                        ifo.Credit =String.valueOf(Decimal.valueOf(ifo.Credit));
                        ifo.Debit = String.valueOf(Decimal.valueOf(ifo.Debit));
                        ifo.RunningBalance = String.valueOf(Decimal.valueOf(ifo.RunningBalance));
                    }
                    Data.ItemInfo = filterInfo;
                    Data.CustomerInfo.ClosingBalance = String.valueOf(Decimal.valueOf(Data.CustomerInfo.ClosingBalance));
                    Data.CustomerInfo.OpeningBalance = String.valueOf(Decimal.valueOf(Data.CustomerInfo.OpeningBalance));
                    Data.totalCredit = String.valueOf(Decimal.valueOf(Data.totalCredit));
                    Data.totalDebit = String.valueOf(Decimal.valueOf(Data.totalDebit));
                    Data.msg='';
                    Data.isSAPSuccess = true;
                    Data.isSuccess = true;
                    if(getDoc){
                        Data.MetaDocType = lstMeta;
                    }
                }
            }
        }else{
            Data.noDistributor = true;
        } 
        
        return Data;
    }    
    public static Grz_BrazilAccountLedgerStatementWrapper1 parse(String json) {
        return (Grz_BrazilAccountLedgerStatementWrapper1) System.JSON.deserialize(json, Grz_BrazilAccountLedgerStatementWrapper1.class);
    }
    
    public class Grz_BrazilAccountLedgerStatementWrapper1 {
        @AuraEnabled public CustomerInfo customerInfo{get;set;}
        @AuraEnabled public List<ItemInfo> ItemInfo{get;set;}
        @AuraEnabled public List<MetaDocType> MetaDocType{get;set;}
        @AuraEnabled public String totalCredit{get;set;}
        @AuraEnabled public String totalDebit{get;set;}
        @AuraEnabled public Boolean isSuccess{get;set;}
        @AuraEnabled public String msg{get;set;}
        @AuraEnabled public boolean isSAPSuccess{get;set;}
        @AuraEnabled public boolean noDistributor{get;set;}
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