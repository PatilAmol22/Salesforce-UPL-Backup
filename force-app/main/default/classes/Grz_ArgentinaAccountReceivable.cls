/**************************************************************************************************
* Name             : Grz_ArgentinaAccountReceivable                                                      
* Description      : Controller for the Argentina Account Ledger datatable component that fetches 
data from the API and provides the download as PDF functionality.  
* Test Class       : Grz_ArgentinaAccountReceivableTest
* Created Date     : 21-09-2022                                                                        
* Project/JIRA     : APPS-1757                                                                        
* Created By       : Gurubaksh Grewal (Grazitti)                                                                        
* Last Modified By : Mohit Garg (Grazitti) 28-12-2022                                                                        
**************************************************************************************************/
public with sharing class Grz_ArgentinaAccountReceivable {
    public static List<ItemInfo> ItemInfo{get;set;}
    public static void getAccountLedgerDataArg() {
        String customerCode = ApexPages.currentPage().getParameters().get('customerCode');
        String fiscalYear = ApexPages.currentPage().getParameters().get('fiscalYear');
        String fiscalMonthStart = ApexPages.currentPage().getParameters().get('fiscalMonthStart');
        String fiscalMonthEnd = ApexPages.currentPage().getParameters().get('fiscalMonthEnd');
        
        String sDate = ApexPages.currentPage().getParameters().get('sDate');
        String eDate = ApexPages.currentPage().getParameters().get('eDate');
        
        Grz_AccountLedgerStatementWrapper1 wrapInfo = getArAndLedgerData(customerCode, fiscalYear, fiscalMonthStart,fiscalMonthEnd,sDate,eDate);
        ItemInfo = wrapInfo.ItemInfo;
    }
    @AuraEnabled(cacheable=true)
    public static ResultWrapperArArgentina getArgentinaArData(String executedfrom){
        ResultWrapperArArgentina Data = new ResultWrapperArArgentina();
        String Company_Code;
        String SAP_Customer_Code;
        String Sap_UserId;
        String accountId;
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
        if(executedfrom == 'ArLedgerCmp'){
            user = [SELECT Id, Username,account.Company_Code__c,account.CustomerServiceExecutive__c,account.SAP_Customer_Code__c,account.sap_UserId__c,AccountId,Account.Name,Account.BillingCity,ContactId,Account.Sales_District__r.name FROM User where Id =: id];
            Company_Code = user[0].account.Company_Code__c;
            SAP_Customer_Code = user[0].account.SAP_Customer_Code__c;
            Sap_UserId = user[0].account.sap_UserId__c;
            accountId = user[0].AccountId;
            if(accountId!=null)Data.checkexternaluser=true;
            Data.customerCode = user[0].account.SAP_Customer_Code__c;
            Data.customerName = user[0].Account.Name;
            Data.customerCity = user[0].Account.BillingCity;
            Data.customerZone = user[0].Account.Sales_District__r.name;
            Data.customerServiceExecutive = user[0].Account.CustomerServiceExecutive__c;
            
        }else{
            acclst = [SELECT Id, Name,Company_Code__c,SAP_Customer_Code__c,CustomerServiceExecutive__c,sap_UserId__c, BillingCity,Sales_District__r.name, IsPartner FROM Account where SAP_Customer_Code__c =: executedfrom];
            if(acclst.size()>0){
                Company_Code = acclst[0].Company_Code__c;
                SAP_Customer_Code = acclst[0].SAP_Customer_Code__c;
                Sap_UserId = acclst[0].sap_UserId__c;
                Data.customerCode = acclst[0].SAP_Customer_Code__c;
                Data.customerName = acclst[0].Name;
                Data.customerCity = acclst[0].BillingCity;
                Data.customerZone = acclst[0].Sales_District__r.name;
                Data.customerServiceExecutive = acclst[0].CustomerServiceExecutive__c;
                Data.isDistributorFound = true;
            }else{
                Data.isDistributorFound = false;
            }
            User u = new User(id=UserInfo.getUserId());
            user.add(u);
        }
        
        if(accountId == NULL){
            Data.checkexternaluser = false;
        }
        else{
            Data.checkexternaluser = true;
        }
        
        if(Data.CustomerName==null){
            Data.isSuccess = false;
            Data.Message = 'Los usuarios internos no tienen permiso para acceder a este componente.';
        }else Data.isSuccess = true;
        return Data;
    }
    //Method Updated by Sumit Kumar on 13/03/2023 for Ticket NO. RITM0512279
    @AuraEnabled
    public static Map<string,object> getArgentinaPDFData(String assignment,String CustomerCode,String fiscalYear,String docType){

        string CompanyCode='';
        list<account>acc=[SELECT ID,SAP_Customer_Code__c,Company_Code__c FROM Account WHERE SAP_Customer_Code__c=:CustomerCode];
        if(acc!=null && !acc.isEmpty())CompanyCode=acc[0].Company_Code__c;
        string res;
        //code added by Sumit Kumar on 13/03/2023 for Ticket NO. RITM0512279
        if(docType == 'DA' || docType == 'R5' || docType == 'R3' || docType=='SB'){
            res = Grz_SapIntegration.getArgentinaDocumentPDF(CompanyCode, assignment, fiscalYear);
        }else{
            res = Grz_SapIntegration.getArgentinaInvoicPDF(assignment, CompanyCode);
        }
     
        map<string,object>map2return=new map<string,object>();
        // the snippet below is introduced to get PDF download when BASE64 text exist in SAP Data in Argentina community,GRZ(Mohit Garg) : APPS-1757 added on: 25-10-2022
        if(res.containsIgnoreCase('BASE64')){
            res=res.replaceAll('E_BASE64', 'BASE64');
            map2return.put('isSuccess',true);
            map2return.put('Message','Success');
            
            Map<String, Object> bMap=((Map<String, Object>) JSON.deserializeUntyped(res));
            if(bMap.containsKey('BASE64') && string.valueOf(bMap.get('BASE64'))!='')map2return.put('base64',(bMap.get('BASE64')));
            else{
                map2return.put('isSuccess',false);
                map2return.put('Message','La factura no está contabilizada');
            }
                                                                                                     
                                                                                    
            //if(bMap.containsKey('E_BASE64'))map2return.put('base64',bMap.get('E_BASE64'));
            
        }else{
            map2return.put('isSuccess',false);
            map2return.put('Message','La factura no está contabilizada');
        }
        return map2return;
    }
    
    public class ResultWrapperArArgentina {        
        @AuraEnabled  
        public boolean isSuccess{get;set;}
        @AuraEnabled  
        public boolean isDistributorFound{get;set;}
        @AuraEnabled  
        public String Message{get;set;}
        @AuraEnabled
        public boolean checkexternaluser{get;set;}
        @AuraEnabled 
        public String customerCode {get; set;}
        @AuraEnabled 
        public String customerName {get; set;}
        @AuraEnabled 
        public String customerCity {get; set;}
        @AuraEnabled 
        public String customerZone {get; set;}
        @AuraEnabled
        public String customerServiceExecutive{get; set;}
    }
    
    @AuraEnabled
    public static Grz_AccountLedgerStatementWrapper1 getArAndLedgerData(String CustomerCode,String fiscalYear,String fiscalMonthStart,String fiscalMonthEnd,String startDt,String endDt){
        
        Grz_AccountLedgerStatementWrapper1 Data = new Grz_AccountLedgerStatementWrapper1();
        String Company_Code;
        String SAP_Customer_Code;
        String Sap_UserId;
        String accountId;
        
        
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
            acclst = [SELECT Id, Name,Company_Code__c,SAP_Customer_Code__c,sap_UserId__c, BillingCity,Sales_District__r.name, IsPartner FROM Account where SAP_Customer_Code__c =: CustomerCode]; 
            if(acclst.size()>0){
                Company_Code = acclst[0].Company_Code__c;
                SAP_Customer_Code = acclst[0].SAP_Customer_Code__c;
                Sap_UserId = acclst[0].sap_UserId__c;
            }
            User u = new User(id=UserInfo.getUserId());
            user.add(u);
        }
        
        String curFiscalYear = fiscalYear;
        String fiscalYearFrom = fiscalMonthStart;
        String fiscalYearTo = fiscalMonthEnd;
        
        if(!user.isEmpty()){
            if(Company_Code != null && SAP_Customer_Code != null && Sap_UserId != null){
                String res = grz_SapIntegration.AccountAndLedgerStatementForArgentina(SAP_Customer_Code,Company_Code, curFiscalYear, fiscalYearFrom, fiscalYearTo,Sap_UserId);
                if(res.equals('Error_In_Sap')){
                    Data.isSuccess=false;
                    Data.msg='Error en SAP';
                }
                else{
                    Data = Grz_AccountLedgerStatementWrapper1.parse(res);
                    Decimal totalCredit = 0.0;
                    Decimal totalDebit = 0.0;
                    List<ItemInfo> ItemInfolst = new List<ItemInfo>();
                    DateTime todaysDate = System.today();
                    Date todaysDateStr = todaysDate.dateGMT();
                    List<String> mxDocType = new List<String>();
                    for(ItemInfo ifo : Data.ItemInfo){
                        
                        if(ifo.AccountingDocNumber != '' || ifo.AccountingDocNumber != null && ifo.NetDueDate != '0000-00-00'){
                            System.debug('ifo---->'+ifo);
                            mxDocType.add(ifo.DocType);
                            ItemInfolst.add(ifo);
                        }
                    }
                    Map<String,String> argdocMap = new Map<String,String>();
                    list<string>items2Exclude=new list<string>{'RR','RG','SB'};
                        for(Argentina_Report__mdt ad : [SELECT Full_Form__c,Short_Form__c FROM Argentina_Report__mdt WHERE 
                                                        Short_Form__c NOT in:items2Exclude]){
                                                            argdocMap.put(ad.Short_Form__c,ad.Full_Form__c);
                                                        }
                    list<ItemInfo>iiList0=new list<itemInfo>();
                    for(ItemInfo ifo : Data.ItemInfo){
                        if(argdocMap.containsKey(ifo.DocType)){
                            // the snippet below is introduced to add negetive sign of AmountInDocCurrency for DocType R3,YO,CX,SB for Argentina community,GRZ(Mohit Garg) : APPS-1757 added on: 24-11-2022
                            if(ifo.DocType == 'R3' || ifo.DocType == 'YO' || ifo.DocType == 'CX' || ifo.DocType == 'SB'){
                                ifo.AmountInDocCurrency = '-'+ifo.AmountInDocCurrency;
                            }
                            
                            // Updated by Sumit Kumar on 13/03/2023 for Ticket NO. RITM0512279
                            if(ifo.DocType == 'DA' || ifo.DocType == 'R5' || ifo.DocType == 'R3'){
                                ifo.Assignment = ifo.AccountingDocNumber;
                            }else{
                                ifo.Assignment = ifo.Assignment;
                            }
                            ifo.DocTypeShortForm = ifo.DocType;
                            ifo.DocType = argdocMap.get(ifo.DocType);
                            // the snippet below is introduced to change sign negative to positive of exchange rate for Argentina community,GRZ(Mohit Garg) : APPS-1757 added on: 14-11-2022
                            ifo.ExchangeRate = math.abs(ifo.ExchangeRate);
                            // the snippet below is introduced to map AccountingDocNumber Column with ReferebceChqNumber for Argentina community,GRZ(Mohit Garg) : APPS-1757 added on: 24-11-2022
                            ifo.AccountingDocNumber = ifo.ReferebceChqNumber;
                            // the snippet below is introduced to assign USD Currency in default for Argentina community,GRZ(Mohit Garg) : APPS-1757 added on: 23-12-2022
                            ifo.DocCurrency = 'USD';
                            iiList0.add(ifo);
                        }
                    }//Comment by Ishu Mittal  getting netdueDate from Sap itself.
                  /*  list<ItemInfo>iiList=new list<itemInfo>();
                    for(ItemInfo ifo : iiList0){
                        if(ifo.NetDueDate!=null){
                           date ndd = date.valueOf((ifo.NetDueDate));
                            date sd= date.valueOf(startDt);
                            date ed= date.valueOf(endDt);
                            // the snippet below is introduced to sum bline date and DsctDays1 in NetDueDate for Argentina community,GRZ(Mohit Garg) : APPS-1757 added on: 28-12-2022
                            DateTime todayDate = date.valueOf(ifo.BlineDate);
                            DateTime today1 = todayDate + Integer.valueOf(ifo.DsctDays1);
                            Date todayDateGMT = today1.dateGmt();
                            ifo.NetDueDate = string.valueOf(todayDateGMT);
                            system.debug(sd+'+++++++++'+ndd+'+++++++++'+ed);
                            if(ndd>sd && ndd<ed)
                            {
                                iiList.add(ifo);
                            }   
                            
                            
                            
                        }
                    }*/
                  //  Data.ItemInfo=iiList;//Commented by Ishu Mittal
                  Data.ItemInfo=iiList0;
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
        @AuraEnabled public customerInfo customerInfo{get;set;}
        @AuraEnabled public List<ItemInfo> ItemInfo{get;set;}
        @AuraEnabled public Boolean isSuccess{get;set;}
        @AuraEnabled public String msg{get;set;}        
    }
    public class customerInfo {
        @AuraEnabled public String CustomerName{get;set;}
        @AuraEnabled public String CustomerCode{get;set;}
        @AuraEnabled public String City{get;set;}
        
    }
    
    public class ItemInfo {
        
        @AuraEnabled public String AccountingDocNumber{get;set;}
        @AuraEnabled public String DocType{get;set;}
        @AuraEnabled public String DocTypeShortForm{get;set;}
        @AuraEnabled public String Assignment{get;set;}
        @AuraEnabled public String PostDate{get;set;}
        @AuraEnabled public String NetDueDate{get;set;}
        @AuraEnabled public String DocCurrency{get;set;}
        @AuraEnabled public String LocalCurrency{get;set;}
         @AuraEnabled public String Credit{get;set;}
        @AuraEnabled public String CollectionExecutive{get;set;}
        @AuraEnabled public String Days{get;set;}
        @AuraEnabled public String AmountInDocCurrency{get;set;}
        @AuraEnabled public String AmtInLocalCurrency{get;set;}
        @AuraEnabled public String AmountInDC{get;set;}
        @AuraEnabled public Decimal ExchangeRate{get;set;}
        @AuraEnabled public String DocumentHeaderText{get;set;}
        @AuraEnabled public String ReferebceChqNumber{get;set;}
        @AuraEnabled public String BlineDate{get;set;}
        @AuraEnabled public String DsctDays1{get;set;}
    }
    
}