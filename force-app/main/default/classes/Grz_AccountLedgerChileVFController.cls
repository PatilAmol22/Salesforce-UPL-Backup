public with sharing class Grz_AccountLedgerChileVFController{
    public static grz_AccountLedgerChileController.CustomerInfo customerInfo{get;set;}
    public static List<grz_AccountLedgerChileController.ItemInfo> ItemInfo{get;set;}
    public static List<grz_AccountLedgerChileController.MetaDocType> metaDoc{get;set;}
    public static String totalCredit{get;set;}
    public static String totalDebit{get;set;}
    public static Boolean isCredit{get;set;}
    public static Boolean isDebit{get;set;}
    public static String openingPositiveBalance{get;set;}
    public static String openingNegativeBalance{get;set;}
    public static String closingPositiveBalance{get;set;}
    public static String closingNegativeBalance{get;set;}
    public static String imgUrl {get;set;} //added by Akhilesh w.r.t Uconnect Mobile App
    public static void Grz_AccountPDFControllerData() {
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
        //below URL code added by Akhilesh w.r.t Uconnect Mobile app.
       String sfdcBaseURL = ApexPages.currentPage().getHeaders().get('Referer');
       System.debug('sfdcBaseURL URL: ' + sfdcBaseURL); 
       String baseUrl = sfdcBaseURL?.split('/s/')[0];
       
       if(String.isNotBlank(baseUrl) && baseUrl.containsIgnoreCase('uplpartnerportalstd')){
            imgUrl = '/uplpartnerportalstd/resource/1617949256000/Grz_Resourse/Grz_Resourse/Images/UPL_LOGO.png';
       }else {
            imgUrl = '/uplpartnerportal/resource/1617949256000/Grz_Resourse/Grz_Resourse/Images/UPL_LOGO.png';
       }
        if(Test.isRunningTest()){
            isCredit = true;
            isDebit = true;
            customerCode = '0001085868';
            companyCode = '5660';         
            sapUserId = 'UPLINTCRM';
            startDate = '2020-04-02';
            endDate = '2020-07-02';
            fiscalYearTo = '4';
            fiscalYearFrom = '7';
            fiscalYear = '2020';
           docFilter.add('RV');
            getDoc = true;
            
            
        }else{ 
            isCredit = Boolean.valueOf(ApexPages.currentPage().getParameters().get('isCredit'));
            system.debug('iscredit'+isCredit);
            isDebit = Boolean.valueOf(ApexPages.currentPage().getParameters().get('isDebit')); 
             system.debug('isDebit'+isDebit);
            if(docFilterString.length() > 0){
                docFilter = docFilterString.split(',');
            }
        }        
        
        grz_AccountLedgerChileController.Grz_AccountLedgerStatementWrapper1 wrapData = grz_AccountLedgerChileController.getAccountStatement(customerCode, companyCode, fiscalYear, fiscalYearFrom, fiscalYearTo, docFilter, startDate, endDate , getDoc,sapUserId);
        Double s = Math.floor(wrapData.MetaDocType.size() / 3);
        customerInfo = wrapData.customerInfo;
        totalCredit = wrapData.totalCredit;
        totalDebit = wrapData.totalDebit;
        ItemInfo = wrapData.ItemInfo;
        metaDoc = wrapData.MetaDocType;
        
    }
    public static void Grz_LedgerPDFControllerData() {
        Boolean getDoc = true;
        String fiscalYear = ApexPages.currentPage().getParameters().get('fiscalYear');
        String customerCode = ApexPages.currentPage().getParameters().get('customerCode');
        String companyCode = ApexPages.currentPage().getParameters().get('companyCode');
        String fiscalYearFrom = ApexPages.currentPage().getParameters().get('fiscalYearFrom');
        String fiscalYearTo = ApexPages.currentPage().getParameters().get('fiscalYearTo');
        String sapUserId = ApexPages.currentPage().getParameters().get('sapUserId');
        //below URL code added by Akhilesh w.r.t Uconnect Mobile app.
       String sfdcBaseURL = ApexPages.currentPage().getHeaders().get('Referer');
       System.debug('sfdcBaseURL URL: ' + sfdcBaseURL); 
       String baseUrl = sfdcBaseURL?.split('/s/')[0];
       
       if(String.isNotBlank(baseUrl) && baseUrl.containsIgnoreCase('uplpartnerportalstd')){
            imgUrl = '/uplpartnerportalstd/resource/1617949256000/Grz_Resourse/Grz_Resourse/Images/UPL_LOGO.png';
       }else {
            imgUrl = '/uplpartnerportal/resource/1617949256000/Grz_Resourse/Grz_Resourse/Images/UPL_LOGO.png';
       }
        if(Test.isRunningTest()){
            customerCode = '0001085868';
            companyCode = '5660';         
            sapUserId = 'UPLINTCRM';
              fiscalYearTo = '4';
            fiscalYearFrom = '7';
            fiscalYear = '2020';
        }
        grz_AccountLedgerChileController.Grz_AccountLedgerStatementWrapper1 wrapData = grz_AccountLedgerChileController.getLedgerStatement(customerCode, companyCode, fiscalYear, fiscalYearFrom, fiscalYearTo, getDoc,sapUserId);
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