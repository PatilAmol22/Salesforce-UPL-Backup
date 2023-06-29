public with Sharing class Grz_AccountStatDonutChartController {
    @AuraEnabled
    public static Grz_AccountLedgerStatementWrapper1 getAccountStatementData(String monthValue){
        system.debug('monthValue : '+monthValue);
        Grz_AccountLedgerStatementWrapper1 Data = new Grz_AccountLedgerStatementWrapper1();
        
        Id id;
        if(Test.isRunningTest()){
            List<Profile> pro = [SELECT Id FROM Profile WHERE Name = 'Mexico Partner Community Distributor Profile'];
            List<User> user = [SELECT Id, Username, AccountId, ContactId FROM User WHERE ProfileId =: pro[0].Id AND lastname = 'Testing' and Email ='test@grazitti.com' LIMIT 1];
            id = user[0].Id;
        }
        else{
            id = UserInfo.getUserId();
        }
        List<User> user = [SELECT Id,LanguageLocaleKey, Username,account.Company_Code__c,account.SAP_Customer_Code__c,account.sap_UserId__c, AccountId, ContactId FROM User where Id =: id and accountid != null];
        System.debug('User Info : '+user);
        List<Period> fiscalYearList = [Select Type, StartDate, EndDate, Number, FiscalYearSettings.PeriodId From Period Where Type='Year' and startDate <= TODAY and endDate >= TODAY];
        Integer curFiscYear = fiscalYearList[0].StartDate.year();
        String curFiscalYear;
        System.debug('curFiscalYear : '+curFiscalYear);
        Date startfiscaldate = fiscalYearList[0].StartDate; 
        System.debug('startfiscaldate : '+startfiscaldate);
        //Date startDate = Date.today().addDays(-90);
        //Integer fromMonth = startDate.month();
        Date endDate = Date.today();
        Integer toMonth = endDate.month();
        Integer endMonthsBetween;
        Integer checkpreYearMonth = startfiscaldate.monthsBetween(endDate)+1;
        System.debug('monthValue : '+monthValue);
        String fiscalYearFrom;
        String fiscalYearTo;
        if(monthValue == '0'){
            endMonthsBetween = startfiscaldate.monthsBetween(endDate)+1;
            fiscalYearFrom = String.valueOf(endMonthsBetween);
            fiscalYearTo = String.valueOf(endMonthsBetween);
            curFiscalYear = String.valueOf(curFiscYear);
        }else{
            endMonthsBetween = startfiscaldate.monthsBetween(endDate);
            fiscalYearFrom = String.valueOf(endMonthsBetween);
            fiscalYearTo = String.valueOf(endMonthsBetween);
            curFiscalYear = String.valueOf(curFiscYear);
            if(checkpreYearMonth == 1){
                fiscalYearFrom = '12';
                fiscalYearTo = '12';
                curFiscalYear = String.valueOf(curFiscYear-1);
            }
        }
        //Integer startMonthsBetween = startfiscaldate.monthsBetween(startDate);
        
        System.debug('fiscalYearFrom : '+fiscalYearFrom);
        System.debug('fiscalYearTo : '+fiscalYearTo);
        
        if(!user.isEmpty()){
            if(user[0].account.Company_Code__c != null && user[0].account.SAP_Customer_Code__c != null && user[0].account.sap_UserId__c != null){
                String res=' ';
                if(user[0].LanguageLocaleKey=='es_MX')res = grz_SapIntegration.AccountAndLedgerStatementForMexico(user[0].account.SAP_Customer_Code__c,user[0].account.Company_Code__c, curFiscalYear, fiscalYearFrom, fiscalYearTo,user[0].account.sap_UserId__c);
                // the snippet below is introduced to get the relevant chart data for Argentina community,GRZ(Gurubaksh Grewal) : APPS-1757 added on: 16-08-2022
                if(user[0].LanguageLocaleKey=='es_AR' ||test.isRunningTest())res = grz_SapIntegration.AccountAndLedgerStatementForArgentina(user[0].account.SAP_Customer_Code__c,user[0].account.Company_Code__c, curFiscalYear, fiscalYearFrom, fiscalYearTo,user[0].account.sap_UserId__c);
                
                if(res.equals('Error_In_Sap')||res==' '){
                    Data.isSuccess=false;
                    Data.msg='Error en SAP';
                }
                else{
                    Data.isSuccess = true;
  					Data = Grz_AccountLedgerStatementWrapper1.parse(res);
                    Decimal totalCredit = 0.0;
                    Decimal totalDebit = 0.0;
                    system.debug('Data : '+Data);
                    system.debug('Data : '+Data.customerInfo);
                    // the snippet below is introduced to get Total credit of RV DocType for Debit and Total Debit for SB DocType  for Argentina community,GRZ(Mohit Garg) : APPS-1757 added on: 14-11-2022
                    for(ItemInfo ifo : Data.ItemInfo){
                        //Changes by Aashima(Grazitti) for APPS-1757 14Dec22
                        if(ifo.DocType == 'RV' || ifo.DocType == 'DA'){
                        	totalCredit = totalCredit + Decimal.valueOf(ifo.Debit).setScale(2);
                        }
                        if(ifo.DocType == 'SB'){
                        	totalDebit = totalDebit + Decimal.valueOf(ifo.Debit).setScale(2);
                        }
                    }
                    Data.totalCredit = String.valueOf(totalCredit);
                    Data.totalDebit = String.valueOf(totalDebit);
                    system.debug('totalCredit : '+totalCredit);
                    system.debug('totalDebit : '+totalDebit);
                    Data.OpeningBalance = String.valueOf(Decimal.valueOf(Data.CustomerInfo.OpeningBalance));
                    //Changes by Aashima(Grazitti) for APPS-1757 14Dec22
                    Data.ClosingBalance = String.valueOf(Decimal.valueOf(Data.CustomerInfo.OpeningBalance) + totalCredit - totalDebit);
                    system.debug('OpeningBalance : '+Data.OpeningBalance);
                    system.debug('ClosingBalance : '+Data.ClosingBalance);
                    
                }
            }
            else{
                Data.isSuccess = false;
                Data.msg = 'El código de cliente / código de empresa / ID de usuario está vacío. Comuníquese con el administrador';
            }
        }
        else{
            Data.isSuccess = false;
            Data.msg = 'Los usuarios internos no tienen permiso para acceder a este componente.';
        }
        system.debug('Final Data : '+Data);       
        return Data;
    }
    
    public static Grz_AccountLedgerStatementWrapper1 parse(String json) {
        return (Grz_AccountLedgerStatementWrapper1) System.JSON.deserialize(json, Grz_AccountLedgerStatementWrapper1.class);
    }
    
    public class Grz_AccountLedgerStatementWrapper1 {
        @AuraEnabled public CustomerInfo customerInfo{get;set;}
        @AuraEnabled public List<ItemInfo> ItemInfo{get;set;}
        @AuraEnabled public String totalCredit{get;set;}
        @AuraEnabled public String totalDebit{get;set;}
        @AuraEnabled public String OpeningBalance{get;set;}
        @AuraEnabled public String ClosingBalance{get;set;}
        @AuraEnabled public Boolean isSuccess{get;set;}
        @AuraEnabled public String msg{get;set;}
        
    }
    public class CustomerInfo {
        //@AuraEnabled public String CustomerName{get;set;}
        //@AuraEnabled public String CustomerCode{get;set;}
        //@AuraEnabled public String City{get;set;}
        @AuraEnabled public String OpeningBalance{get;set;}
        @AuraEnabled public String ClosingBalance{get;set;}
    }
    
    public class ItemInfo {
        @AuraEnabled public String Credit{get;set;}
        @AuraEnabled public String Debit{get;set;}
        @AuraEnabled public String DocType{get;set;}
    }
}