public with sharing class Grz_AccountLedgerMexicoVFController {
    public static List<Grz_MexicoArAndLedgerController.ItemInfo> ItemInfo{get;set;}
    public static void getAccountLedgerDataMx() {
        String customerCode = ApexPages.currentPage().getParameters().get('customerCode');
        String fiscalYear = ApexPages.currentPage().getParameters().get('fiscalYear');
        String fiscalMonth = ApexPages.currentPage().getParameters().get('fiscalMonth');
        System.debug('fiscalYearFrom : '+fiscalMonth);
        
        Grz_MexicoArAndLedgerController.Grz_AccountLedgerStatementWrapper1 wrapInfo = Grz_MexicoArAndLedgerController.getArAndLedgerData(customerCode, fiscalYear, fiscalMonth);
        System.debug('wrapInfo : '+wrapInfo);    
        ItemInfo = wrapInfo.ItemInfo;
        System.debug('ItemInfo : '+ItemInfo);   
    }

}