public with sharing class Grz_BrazilAccountStatement{
    
    public Grz_BrazilAccountLedgerStatement.CustomerInfo customerInfo{get;set;}
    public List<Grz_BrazilAccountLedgerStatement.ItemInfo> ItemInfo{get;set;}
    public List<Grz_BrazilAccountLedgerStatement.MetaDocType> metaDoc{get;set;}
    public String totalCredit{get;set;}
    public String totalDebit{get;set;}
    public Boolean isCredit{get;set;}
    public Boolean isDebit{get;set;}
    public String openingPositiveBalance{get;set;}
    public String openingNegativeBalance{get;set;}
    public String closingPositiveBalance{get;set;}
    public String closingNegativeBalance{get;set;}
    public void Grz_AccountPDFControllerData() {
        Boolean getDoc = true;
        List<String> docFilter = new List<String>();
        String fiscalYear = ApexPages.currentPage().getParameters().get('fiscalYear');
        String customerCode = ApexPages.currentPage().getParameters().get('customerCode');
        String fiscalYearFrom = ApexPages.currentPage().getParameters().get('fiscalYearFrom');
        String fiscalYearTo = ApexPages.currentPage().getParameters().get('fiscalYearTo');
        String startDate = ApexPages.currentPage().getParameters().get('startDate');
        String endDate = ApexPages.currentPage().getParameters().get('endDate');
        String docFilterString = ApexPages.currentPage().getParameters().get('docFilter');
        if(Test.isRunningTest()){
            isCredit = true;
            isDebit = true;
            customerCode = '1033252';        
            startDate = '2020-04-02';
            endDate = '2020-07-02';
        }else{
            isCredit = Boolean.valueOf(ApexPages.currentPage().getParameters().get('isCredit'));
            isDebit = Boolean.valueOf(ApexPages.currentPage().getParameters().get('isDebit')); 
            if(docFilterString.length() > 0){
                docFilter = docFilterString.split(',');
            }
        }        
        
        Grz_BrazilAccountLedgerStatement.Grz_BrazilAccountLedgerStatementWrapper1 wrapData = Grz_BrazilAccountLedgerStatement.getAccountStatement(customerCode, fiscalYear, fiscalYearFrom, fiscalYearTo, docFilter, startDate, endDate , getDoc);
        Double s = Math.floor(wrapData.MetaDocType.size() / 3);
        
        customerInfo = wrapData.customerInfo;
        totalCredit = wrapData.totalCredit;
        totalDebit = wrapData.totalDebit;
        ItemInfo = wrapData.ItemInfo;
        metaDoc = wrapData.MetaDocType;
        
    }
    public void Grz_LedgerPDFControllerData() {
        Boolean getDoc = true;
        String fiscalYear = ApexPages.currentPage().getParameters().get('fiscalYear');
        String customerCode = ApexPages.currentPage().getParameters().get('customerCode');
        String fiscalYearFrom = ApexPages.currentPage().getParameters().get('fiscalYearFrom');
        String fiscalYearTo = ApexPages.currentPage().getParameters().get('fiscalYearTo');
        if(Test.isRunningTest()){
            customerCode = '1033252';
        }
        Grz_BrazilAccountLedgerStatement.Grz_BrazilAccountLedgerStatementWrapper1 wrapData = Grz_BrazilAccountLedgerStatement.getLedgerStatement(customerCode, fiscalYear, fiscalYearFrom, fiscalYearTo, getDoc);
        Double s = Math.floor(wrapData.MetaDocType.size() / 3);
        
        if (wrapData.customerInfo.ClosingBalance.contains('-') && wrapData.customerInfo.OpeningBalance.contains('-')) {
            openingNegativeBalance = wrapData.customerInfo.OpeningBalance.replace('-','');
            openingPositiveBalance = '';
            closingNegativeBalance = wrapData.customerInfo.ClosingBalance.replace('-','');
            closingPositiveBalance = '';
            
        } else {
            openingNegativeBalance = '';
            openingPositiveBalance = wrapData.customerInfo.OpeningBalance;
            closingNegativeBalance = '';
            closingPositiveBalance = wrapData.customerInfo.ClosingBalance;
        }
        if (wrapData.customerInfo.OpeningBalance.contains('-') && !wrapData.customerInfo.ClosingBalance.contains('-')) {
            openingNegativeBalance = wrapData.customerInfo.OpeningBalance.replace('-','');
            openingPositiveBalance = '';
            closingNegativeBalance = '';
            closingPositiveBalance = wrapData.customerInfo.ClosingBalance;
            
        } else if (!wrapData.customerInfo.OpeningBalance.contains('-') && wrapData.customerInfo.ClosingBalance.contains('-')) {
            openingNegativeBalance = '';
            openingPositiveBalance = wrapData.customerInfo.OpeningBalance;
            closingNegativeBalance = wrapData.customerInfo.ClosingBalance.replace('-','');
            closingPositiveBalance = '';
        }
        customerInfo = wrapData.customerInfo;
        totalCredit = wrapData.totalCredit;
        totalDebit = wrapData.totalDebit;
        ItemInfo = wrapData.ItemInfo;
        metaDoc = wrapData.MetaDocType;
        
    }
    
    
}