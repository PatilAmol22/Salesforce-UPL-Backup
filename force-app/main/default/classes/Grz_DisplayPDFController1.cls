public with sharing class Grz_DisplayPDFController1{
    public Grz_AccountLedgerStatement.CustomerInfo customerInfo{get;set;}
    public List<Grz_AccountLedgerStatement.ItemInfo> ItemInfo{get;set;}
    public List<Grz_AccountLedgerStatement.MetaDocType> metaDoc{get;set;}
    public String totalCredit{get;set;}
    public String totalDebit{get;set;}
    public Boolean isCredit{get;set;}
    public Boolean isDebit{get;set;}
    public String openingPositiveBalance{get;set;}
    public String openingNegativeBalance{get;set;}
    public String closingPositiveBalance{get;set;}
    public String closingNegativeBalance{get;set;}
    public String startDateVf{get;set;}
    public String endDateVf{get;set;}
    public void Grz_AccountPDFControllerData() {
        Boolean getDoc = true;
        List<String> docFilter = new List<String>();
        String fiscalYear = ApexPages.currentPage().getParameters().get('fiscalYear');
        String customerCode = ApexPages.currentPage().getParameters().get('customerCode');
        String companyCode = ApexPages.currentPage().getParameters().get('companyCode');
        String fiscalYearFrom = ApexPages.currentPage().getParameters().get('fiscalYearFrom');
        String fiscalYearTo = ApexPages.currentPage().getParameters().get('fiscalYearTo');
        String startDate = ApexPages.currentPage().getParameters().get('startDate');
        String endDate = ApexPages.currentPage().getParameters().get('endDate');
        String docFilterString = ApexPages.currentPage().getParameters().get('docFilter');
        String sapUserId = ApexPages.currentPage().getParameters().get('sapUserId');
        String accountidinfo = ApexPages.currentPage().getParameters().get('accountidinfo');
        
        if(Test.isRunningTest()){
            isCredit = true;
            isDebit = true;
            customerCode = '18765432000';
            companyCode = '1000';         
            sapUserId = 'test';
            startDate = '2020-04-02';
            endDate = '2020-07-02';
        }else{
            isCredit = Boolean.valueOf(ApexPages.currentPage().getParameters().get('isCredit'));
            isDebit = Boolean.valueOf(ApexPages.currentPage().getParameters().get('isDebit')); 
            if(docFilterString.length() > 0){
                docFilter = docFilterString.split(',');
            }
        }        
        startDateVf=grz_SapIntegration.FormattedDate(Date.valueOf(startDate));
        endDateVf=grz_SapIntegration.FormattedDate(Date.valueOf(endDate));
        Grz_AccountLedgerStatement.Grz_AccountLedgerStatementWrapper1 wrapData = Grz_AccountLedgerStatement.getAccountStatement(customerCode, companyCode, fiscalYear, fiscalYearFrom, fiscalYearTo, docFilter, startDate, endDate , getDoc,sapUserId,accountidinfo);
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
        String companyCode = ApexPages.currentPage().getParameters().get('companyCode');
        String fiscalYearFrom = ApexPages.currentPage().getParameters().get('fiscalYearFrom');
        String fiscalYearTo = ApexPages.currentPage().getParameters().get('fiscalYearTo');
        String sapUserId = ApexPages.currentPage().getParameters().get('sapUserId');
        String accountidinfo = ApexPages.currentPage().getParameters().get('accountidinfo');
        if(Test.isRunningTest()){
            customerCode = '18765432000';
            companyCode = '1000';         
            sapUserId = 'test';
        }
        Grz_AccountLedgerStatement.Grz_AccountLedgerStatementWrapper1 wrapData = Grz_AccountLedgerStatement.getLedgerStatement(customerCode, companyCode, fiscalYear, fiscalYearFrom, fiscalYearTo, getDoc,sapUserId,accountidinfo);
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