public with sharing class grz_AccountLedgerChileController {
    @AuraEnabled(cacheable=true)
    public static ResultWrapper getAccInfo(){
        ResultWrapper rap = new ResultWrapper();
        Id id;
        if(Test.isRunningTest()){
            List<Profile> pro = [SELECT Id FROM Profile WHERE Name = 'Chile Partner Community Distributor Profile'];
            List<User> user = [SELECT Id, Username, AccountId, ContactId FROM User WHERE ProfileId =: pro[0].Id AND lastname = 'Testing' and Email ='test@grazitti.com' LIMIT 1];
            id = user[0].Id;
        }
        else{
            id = UserInfo.getUserId();
        }
        List<User> user = [SELECT Id, Username, AccountId, ContactId FROM User where Id =: id];
        String accountId = user[0].AccountId;
        if(!String.isEmpty(accountId)){
            rap.isInternalUser = false;
            Account accData = [SELECT Id, Name ,BillingCity,SAP_Customer_Code__c, Company_Code__c ,Sap_UserId__c FROM Account WHERE Id =:accountId];
            rap.customerCode = accData.SAP_Customer_Code__c;
            rap.companyCode = accData.Company_Code__c;
            rap.sapUserId = accData.Sap_UserId__c;
            rap.name = accData.Name;
            rap.city = accData.BillingCity;
        }else{
            rap.isInternalUser = true;
        }
        rap.docTypeInfo = [SELECT Id, DeveloperName, Language, Label, QualifiedApiName, Short_Form__c, Full_Form__c FROM Account_Doc_Type_Chile__mdt order by Short_Form__c ];
        return rap;
    }   
    @AuraEnabled
    public static Grz_AccountLedgerStatementWrapper1 getAccountStatement(String customerCode, String companyCode, String fiscalYear, String fiscalYearFrom, String fiscalYearTo, List<String> docFilter , String startDate , String endDate , Boolean getDoc, String sapUserId){
        Grz_AccountLedgerStatementWrapper1 Data = new Grz_AccountLedgerStatementWrapper1();
        Grz_AccountLedgerStatementWrapper1 tempData = new Grz_AccountLedgerStatementWrapper1();
        Grz_AccountLedgerStatementWrapper1 tempData1 = new Grz_AccountLedgerStatementWrapper1();
        List<ItemInfo> filterInfo = new List<ItemInfo>();
        List<MetaDocType> lstMeta = new List<MetaDocType>();
        if(customerCode==null || companyCode==null || sapUserId==null ){
            Data.isSuccess=false;
            Data.msg='El código de cliente / código de empresa / ID de usuario está vacío. Comuníquese con el administrador';
        }else{
            if(fiscalYear.contains(',')){
                for(Integer i=0 ; i<2 ; i++){
                    if(i == 0){
                        tempData = helperAccountStatement(customerCode,companyCode,fiscalYear.SubStringBefore(','),fiscalYearFrom.SubStringBefore(','),fiscalYearTo.SubStringBefore(','),docFilter,startDate,endDate,getDoc,sapUserId);
                        for(ItemInfo ifo : tempData.ItemInfo){
                            filterInfo.add(ifo);
                        }
                        for(MetaDocType ad : tempData.MetaDocType){
                            lstMeta.add(ad);
                        }
                    }
                    else{
                        tempData1 = helperAccountStatement(customerCode,companyCode,fiscalYear.SubStringAfter(','),fiscalYearFrom.SubStringAfter(','),fiscalYearTo.SubStringAfter(','),docFilter,startDate,endDate,getDoc,sapUserId);
                        for(ItemInfo ifo : tempData1.ItemInfo){
                            filterInfo.add(ifo);
                        }
                        for(MetaDocType ad : tempData1.MetaDocType){
                            lstMeta.add(ad);
                        }
                    }
                }
                //Data.totalCredit = Grz_AccountLedgerStatement.inrValue(Decimal.valueOf(tempData.totalCredit) + Decimal.valueOf(tempData1.totalCredit));
                //Data.totalDebit = Grz_AccountLedgerStatement.inrValue(Decimal.valueOf(tempData.totalDebit) + Decimal.valueOf(tempData1.totalDebit));
                Data.totalCreditTemp = tempData.totalCreditTemp + tempData1.totalCreditTemp;
                Data.totalDebitTemp = tempData.totalDebitTemp + tempData1.totalDebitTemp;
                Data.totalCredit = Grz_AccountLedgerStatement.inrValue(Data.totalCreditTemp);
                Data.totalDebit = Grz_AccountLedgerStatement.inrValue(Data.totalDebitTemp);
                Data.ItemInfo = filterInfo;
                Data.customerInfo = tempData1.customerInfo;
                Data.isSuccess=true;
                Data.msg='';
                Data.MetaDocType = lstMeta;
            }
            else{
                Data = helperAccountStatement(customerCode,companyCode,fiscalYear,fiscalYearFrom,fiscalYearTo,docFilter,startDate,endDate,getDoc,sapUserId);
            }
        }            
        return Data;
    }
    public static Grz_AccountLedgerStatementWrapper1 helperAccountStatement(String customerCode, String companyCode, String fiscalYear, String fiscalYearFrom, String fiscalYearTo, List<String> docFilter , String startDate , String endDate , Boolean getDoc, String sapUserId){
        Grz_AccountLedgerStatementWrapper1 Data = new Grz_AccountLedgerStatementWrapper1();
        String res;
        res = grz_SapIntegration.AccountAndLedgerStatementForMexico(customerCode,companyCode,fiscalYear,fiscalYearFrom,fiscalYearTo,sapUserId);
        if(res.equals('Error_In_Sap')){
            Data.isSuccess=false;
            Data.msg='Error en SAP';
        }
        else{
            Data = Grz_AccountLedgerStatementWrapper1.parse(res);
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
                ifo.PostDate = grz_SapIntegration.FormattedDateChile(Date.valueof(ifo.PostDate));
                ifo.NetDueDate = grz_SapIntegration.FormattedDateChile(Date.valueof(ifo.NetDueDate));
                avlDoc.add(ifo.DocType);
                ifo.Credit = Grz_AccountLedgerStatement.inrValue(Decimal.valueOf(ifo.Credit));
                ifo.Debit = Grz_AccountLedgerStatement.inrValue(Decimal.valueOf(ifo.Debit));
            }
            List<MetaDocType> lstMeta = new List<MetaDocType>();
            if(getDoc){
                List<Account_Doc_Type_Chile__mdt> abc = [SELECT Short_Form__c, Full_Form__c FROM Account_Doc_Type_Chile__mdt WHERE Short_Form__c IN: avlDoc order by Short_Form__c];
                for(Account_Doc_Type_Chile__mdt ad : abc){
                    MetaDocType me = new MetaDocType();
                    me.shortForm = ad.Short_Form__c;
                    me.fullForm = ad.Full_Form__c;
                    lstMeta.add(me);
                }
            }
            Data.totalCreditTemp = totalCredit;
            Data.totalDebitTemp = totalDebit;
            Data.totalCredit = Grz_AccountLedgerStatement.inrValue(totalCredit);
            Data.totalDebit = Grz_AccountLedgerStatement.inrValue(totalDebit);
            Data.ItemInfo = filterInfo;
            Data.isSuccess=true;
            Data.msg='';
            if(getDoc){
                Data.MetaDocType = lstMeta;
            }            
        }
        return Data;
    }

    @AuraEnabled
    public static Grz_AccountLedgerStatementWrapper1 getLedgerStatement(String customerCode, String companyCode, String fiscalYear, String fiscalYearFrom, String fiscalYearTo , Boolean getDoc , String sapUserId){
        Grz_AccountLedgerStatementWrapper1 Data = new Grz_AccountLedgerStatementWrapper1();
        if(customerCode==null || companyCode==null || sapUserId==null ){
            Data.isSuccess=false;
            Data.msg='El código de cliente / código de empresa / ID de usuario está vacío. Comuníquese con el administrador';
        }else{
            String res = grz_SapIntegration.AccountAndLedgerStatementForMexico(customerCode,companyCode,fiscalYear,fiscalYearFrom,fiscalYearTo, sapUserId);
            if(res != null && res.equals('Error_In_Sap')){
              	Data.isSuccess=false;
            	Data.msg='Error en SAP';
            }
            else{
            Data = Grz_AccountLedgerStatementWrapper1.parse(res);
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
                List<Account_Doc_Type_Chile__mdt> abc = [SELECT Short_Form__c, Full_Form__c FROM Account_Doc_Type_Chile__mdt WHERE Short_Form__c IN: avlDoc order by Short_Form__c];
                for(Account_Doc_Type_Chile__mdt ad : abc){
                    MetaDocType me = new MetaDocType();
                    me.shortForm = ad.Short_Form__c;
                    me.fullForm = ad.Full_Form__c;
                    lstMeta.add(me);
                }
            }
            for(ItemInfo ifo : filterInfo){
                ifo.PostDate = grz_SapIntegration.FormattedDateChile(Date.valueof(ifo.PostDate));
                ifo.NetDueDate = grz_SapIntegration.FormattedDateChile(Date.valueof(ifo.NetDueDate));
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
    
    @AuraEnabled
    public static ResultWrapper getCustomerRecord(String customerCode){
        ResultWrapper Data = new ResultWrapper();
         List<String> salesorgcode = System.Label.Grz_ChileSalesOrgCode.trim().Split(',');
        List<Account> accList = [SELECT Id,Sap_UserId__c ,Company_Code__c,SAP_Customer_Code__c FROM Account WHERE Id =: customerCode AND Sales_org_Code__c in:salesorgcode LIMIT 1];
        if(!accList.isEmpty()){
            Data.sapUserId = accList[0].Sap_UserId__c;
            Data.customerCode = accList[0].SAP_Customer_Code__c;
            Data.companyCode =accList[0].Company_Code__c;
            Data.noDistributor = false;
        }else{
            Data.noDistributor = true;
        } 
        return Data;
    }  

    public class ResultWrapper {
        @AuraEnabled public String customerCode { get; set; }
        @AuraEnabled public String sapUserId { get; set; }
        @AuraEnabled public String companyCode { get; set; }
        @AuraEnabled public String name { get; set; }
        @AuraEnabled public String city { get; set; }
        @AuraEnabled public Boolean isInternalUser { get; set; }
        @AuraEnabled public Boolean noDistributor { get; set; }
        @AuraEnabled public List<Account_Doc_Type_Chile__mdt> docTypeInfo { get; set; }
        @AuraEnabled public CustomerInfo cstInfo { get; set; }
    } 
    public class Grz_AccountLedgerStatementWrapper1 {
        @AuraEnabled public CustomerInfo customerInfo{get;set;}
        @AuraEnabled public List<ItemInfo> ItemInfo{get;set;}
        @AuraEnabled public List<MetaDocType> MetaDocType{get;set;}
        @AuraEnabled public String totalCredit{get;set;}
        @AuraEnabled public String totalDebit{get;set;}
        @AuraEnabled public Decimal totalCreditTemp{get;set;}
        @AuraEnabled public Decimal totalDebitTemp{get;set;}
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
        @AuraEnabled public String NetDueDate{get;set;}
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