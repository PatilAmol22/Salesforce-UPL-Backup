public with sharing class Grz_MexicoArAndLedgerController {
    
    @AuraEnabled
    public static Grz_AccountLedgerStatementWrapper1 getArAndLedgerData(String CustomerCode,String fiscalYear,String fiscalMonth){
        
        Grz_AccountLedgerStatementWrapper1 Data = new Grz_AccountLedgerStatementWrapper1();
        String Company_Code;
        String SAP_Customer_Code;
        String Sap_UserId;
        String accountId;
        
        /*Grz_MexicoAccountReceivable.ResultWrapperArMexico arData = Grz_MexicoAccountReceivable.getMexicoArData('ExecutedFromClass');
        System.debug('arData : '+arData);
        Data.notYetDue = arData.notYetDue;
        Data.totalOverdue = arData.totalOverdue;
        Data.upto_0_30 = arData.upto_0_30;
        Data.upto_31_60 = arData.upto_31_60;
        Data.upto_61_75 = arData.upto_61_75;
        Data.upto_76_90 = arData.upto_76_90;
        Data.upto_91_120 = arData.upto_91_120;
        Data.upto_121_150 = arData.upto_121_150;
        Data.upto_151_180 = arData.upto_151_180;
        Data.upto_181_210 = arData.upto_181_210;
        Data.after_211 = arData.after_211;*/
        
        Id id;
        if(Test.isRunningTest()){
            List<Profile> pro = [SELECT Id FROM Profile WHERE Name = 'Mexico Partner Community Distributor Profile'];
            List<User> user = [SELECT Id, Username, AccountId, ContactId FROM User WHERE ProfileId =: pro[0].Id AND lastname = 'Testing' and Email ='test@grazitti.com' LIMIT 1];
            id = user[0].Id;
        }
        else{
            id = UserInfo.getUserId();
        }
        List<User> user = new List<User>();
        List<Account> acclst = new List<Account>();
        if(CustomerCode == 'Customer'){
            user = [SELECT Id, Username,account.Company_Code__c,account.SAP_Customer_Code__c,account.sap_UserId__c, AccountId, ContactId FROM User where Id =: id and accountid != null];
        	Company_Code = user[0].account.Company_Code__c;
            SAP_Customer_Code = user[0].account.SAP_Customer_Code__c;
            Sap_UserId = user[0].account.sap_UserId__c;
        }
        else{
             //user = [SELECT Id, Username,account.Company_Code__c,account.SAP_Customer_Code__c,account.sap_UserId__c,AccountId,Account.Name,Account.BillingCity,ContactId,Account.Sales_District__r.name FROM User where account.SAP_Customer_Code__c =: CustomerCode];
        	acclst = [SELECT Id, Name,Company_Code__c,SAP_Customer_Code__c,sap_UserId__c, BillingCity,Sales_District__r.name, IsPartner FROM Account where SAP_Customer_Code__c =: CustomerCode]; 
            if(acclst.size()>0){
                Company_Code = acclst[0].Company_Code__c;
            	SAP_Customer_Code = acclst[0].SAP_Customer_Code__c;
            	Sap_UserId = acclst[0].sap_UserId__c;
            }
            User u = new User(id=UserInfo.getUserId());
            user.add(u);
        }
        System.debug('User Info : '+user);

        String curFiscalYear = fiscalYear;
        String fiscalYearFrom = fiscalMonth;
        String fiscalYearTo = fiscalMonth;
        System.debug('fiscalYear : '+fiscalYear);
        System.debug('fiscalYearFrom : '+fiscalYearFrom);
        System.debug('fiscalYearTo : '+fiscalYearTo);
        
        if(!user.isEmpty()){
            if(Company_Code != null && SAP_Customer_Code != null && Sap_UserId != null){
                String res = grz_SapIntegration.AccountAndLedgerStatementForMexico(SAP_Customer_Code,Company_Code, curFiscalYear, fiscalYearFrom, fiscalYearTo,Sap_UserId);
                if(res.equals('Error_In_Sap')){
                    Data.isSuccess=false;
                    Data.msg='Error en SAP';
                }
                else{
                    Data = Grz_AccountLedgerStatementWrapper1.parse(res);
                    Decimal totalCredit = 0.0;
                    Decimal totalDebit = 0.0;
                    system.debug('Data : '+Data);
                    system.debug('Data : '+Data.customerInfo);
                    List<ItemInfo> ItemInfolst = new List<ItemInfo>();
                    DateTime todaysDate = System.today();
                    Date todaysDateStr = todaysDate.dateGMT();
                    List<String> mxDocType = new List<String>();
                    for(ItemInfo ifo : Data.ItemInfo){
                        if(ifo.AccountingDocNumber != '' || ifo.AccountingDocNumber != null && ifo.NetDueDate != '0000-00-00'){
                            mxDocType.add(ifo.DocType);
                            Date NetDueDate = Date.valueOf(ifo.NetDueDate);
                            Datetime dt = Date.valueOf(ifo.NetDueDate);
                            ifo.NetDueDate = grz_SapIntegration.FormattedDateMexico(dt); 
                            Datetime dt2 = Date.valueOf(ifo.PostDate);
                            ifo.PostDate = grz_SapIntegration.FormattedDateMexico(dt2); 
                            Integer numberDaysDue = todaysDateStr.daysBetween(NetDueDate);
                            ifo.Days = String.ValueOf(numberDaysDue);
                            //ifo.DocCurrency = ifo.LocalCurrency;
                            ifo.AmtInDocCurrency = ifo.AmountInDC;
                            ItemInfolst.add(ifo);
                        }
                    }
                    //List<Account_Doc_Type_Mexico__mdt> abc = [Select DeveloperName,Short_Form__c, Full_Form__c from Account_Doc_Type_Mexico__mdt where DeveloperName in : mxDocType order by DeveloperName];
                    Map<String,String> mxdocMap = new Map<String,String>();
                    for(Account_Doc_Type_Mexico__mdt ad : [Select DeveloperName,Short_Form__c, Full_Form__c from Account_Doc_Type_Mexico__mdt where DeveloperName in : mxDocType order by DeveloperName]){
  						mxdocMap.put(ad.DeveloperName,ad.Full_Form__c);
                    }
                    
                    for(ItemInfo ifo : Data.ItemInfo){
                        ifo.DocType = mxdocMap.get(ifo.DocType);
                    }
                    
                    Data.ItemInfo = ItemInfolst;
                    Data.isSuccess = true;
                    Data.msg = 'Success';
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
        @AuraEnabled public Boolean isSuccess{get;set;}
        @AuraEnabled public String msg{get;set;}        
    }
    public class CustomerInfo {
        @AuraEnabled public String CustomerName{get;set;}
        @AuraEnabled public String CustomerCode{get;set;}
        @AuraEnabled public String City{get;set;}
        //@AuraEnabled public String OpeningBalance{get;set;}
        //@AuraEnabled public String ClosingBalance{get;set;}
    }
    
    public class ItemInfo {
        
        @AuraEnabled public String AccountingDocNumber{get;set;}
        @AuraEnabled public String DocType{get;set;}
        @AuraEnabled public String Assignment{get;set;}
        @AuraEnabled public String PostDate{get;set;}
        @AuraEnabled public String NetDueDate{get;set;}
        @AuraEnabled public String DocCurrency{get;set;}
        @AuraEnabled public String LocalCurrency{get;set;}
        @AuraEnabled public String CollectionExecutive{get;set;}
        @AuraEnabled public String Days{get;set;}
        @AuraEnabled public String AmtInDocCurrency{get;set;}
        @AuraEnabled public String AmtInLocalCurrency{get;set;}
        @AuraEnabled public String AmountInDC{get;set;}
    }
        
}