public  class CalculateMarkettingYearHelper {
    public static MarketingYearWrapper calculateYearWithoutVisibility(string salesOrg){
        Integer currentYear = system.today().year();
        Integer lastYear = system.today().year() -1;
        Integer nextYear = system.today().year() +1;
        
        Integer month;
        UPL_Settings__c monthSetting = UPL_Settings__c.getInstance();
        if(salesOrg == System.Label.NAM_SalesOrg)
            month = Integer.valueOf(monthSetting.MKT_YR_USA__c);
        else if(salesOrg == System.Label.Canada_SalesOrg)
            month = Integer.valueOf(monthSetting.MKT_YR_CAN__c);
        
        MarketingYearWrapper mktYearWrapper = new MarketingYearWrapper();
        
        if(system.today() < date.newInstance(currentYear, month, 1)){
            mktYearWrapper.firstMarketingYear = currentYear;
             mktYearWrapper.firstMarketingYearStartDate = date.newInstance(lastYear, month, 1);
            mktYearWrapper.firstMarketingYearEndDate = date.newInstance(currentYear, month, 1) - 1;
        }
        else{
            mktYearWrapper.firstMarketingYear = nextYear;
             mktYearWrapper.firstMarketingYearStartDate = date.newInstance(currentYear, month, 1);
            mktYearWrapper.firstMarketingYearEndDate = date.newInstance(nextYear, month, 1) - 1;
        }
        return mktYearWrapper;
    }
    public static MarketingYearWrapper calculateMarketingYear(string salesOrg){
        Integer currentYear = system.today().year();
        Integer lastYear = system.today().year() -1;
        Integer nextYear = system.today().year() +1;
        
        Integer month;
        UPL_Settings__c monthSetting = UPL_Settings__c.getInstance();
        if(salesOrg == System.Label.NAM_SalesOrg)
            month = Integer.valueOf(monthSetting.MKT_YR_USA__c);
        else if(salesOrg == System.Label.Canada_SalesOrg)
            month = Integer.valueOf(monthSetting.MKT_YR_CAN__c);
        Integer visibility = Integer.valueOf(monthSetting.MKT_YR_Visibility__c);
        
        Integer marketingYear;
        Date marketingYearStartDate;
        Date marketingYearEndDate;
        if(system.today() < date.newInstance(currentYear, month, 1)){
            marketingYear = currentYear;
            marketingYearStartDate = date.newInstance(lastYear, month, 1);
            marketingYearEndDate = date.newInstance(currentYear, month, 1) - 1;
        }
        else{
            marketingYear = nextYear;
            marketingYearStartDate = date.newInstance(currentYear, month, 1);
            marketingYearEndDate = date.newInstance(nextYear, month, 1) - 1;
        }
        
        Integer prevMarketingYear = marketingYear -1;
        Integer nextMarketingYear = marketingYear +1;
        Date prevMarketingYearStartDate = date.newInstance(marketingYearStartDate.year()-1, marketingYearStartDate.month(), marketingYearStartDate.day());
        Date prevMarketingYearEndDate = date.newInstance(marketingYearEndDate.year()-1, marketingYearEndDate.month(), marketingYearEndDate.day());
        Date nextMarketingYearStartDate = date.newInstance(marketingYearStartDate.year()+1, marketingYearStartDate.month(), marketingYearStartDate.day());
        Date nextMarketingYearEndDate = date.newInstance(marketingYearEndDate.year()+1, marketingYearEndDate.month(), marketingYearEndDate.day());
        
        MarketingYearWrapper mktYearWrapper = new MarketingYearWrapper();
        
        if((system.today().addDays(visibility)) >= nextMarketingYearStartDate){
            mktYearWrapper.firstMarketingYear = nextMarketingYear;
            mktYearWrapper.firstMarketingYearStartDate = nextMarketingYearStartDate;
            mktYearWrapper.firstMarketingYearEndDate = nextMarketingYearEndDate;
            mktYearWrapper.secondMarketingYear = marketingYear;
            mktYearWrapper.secondMarketingYearStartDate = marketingYearStartDate;
            mktYearWrapper.secondMarketingYearEndDate = marketingYearEndDate;
        }
        else{
            mktYearWrapper.firstMarketingYear = marketingYear;
            mktYearWrapper.firstMarketingYearStartDate = marketingYearStartDate;
            mktYearWrapper.firstMarketingYearEndDate = marketingYearEndDate;
            mktYearWrapper.secondMarketingYear = prevMarketingYear;
            mktYearWrapper.secondMarketingYearStartDate = prevMarketingYearStartDate;
            mktYearWrapper.secondMarketingYearEndDate = prevMarketingYearEndDate;
        }
        system.debug('hello'+mktYearWrapper);
        return mktYearWrapper;
        
    }
    
    public class MarketingYearWrapper {
        @AuraEnabled public Integer firstMarketingYear {get;set;}
        @AuraEnabled public Date firstMarketingYearStartDate {get;set;}
        @AuraEnabled public Date firstMarketingYearEndDate {get;set;}
        @AuraEnabled public Integer secondMarketingYear {get;set;}
        @AuraEnabled public Date secondMarketingYearStartDate {get;set;}
        @AuraEnabled public Date secondMarketingYearEndDate {get;set;}
    }
}