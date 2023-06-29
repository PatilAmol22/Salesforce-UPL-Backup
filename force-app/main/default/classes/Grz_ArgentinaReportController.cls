/**************************************************************************************************
* Name             : Grz_ArgentinaReportController                                                      
* Description      : Controller for the Argentina Reprort datatable component that fetches 
					 data from the API.  
* Test Class       : Grz_ArgentinaReportControllerTest
* Created Date     : 20-09-2022                                                                        
* Project/JIRA     : APPS-1757                                                                        
* Created By       : Mohit Garg (Grazitti)                                                                        
* Last Modified By : Mohit Garg (Grazitti) 28-12-2022                                                                        
**************************************************************************************************/

public with sharing class Grz_ArgentinaReportController {
    @AuraEnabled
    public static Grz_ArgentinaReportWrapper getReportData(String CustomerCode,String fiscalYear,String fiscalMonthS,String fiscalMonthE){
        
        Grz_ArgentinaReportWrapper Data = new Grz_ArgentinaReportWrapper();
        String Company_Code;
        String SAP_Customer_Code;
        String Sap_UserId;
        String accountId;

        Id id;
        if(Test.isRunningTest()){
            List<Profile> pro = [SELECT Id FROM Profile WHERE Name = 'Argentina Partner Community Distributor Profile'];
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
        String fiscalYearFrom = fiscalMonthS;
        String fiscalYearTo = fiscalMonthE;
	
        if(!user.isEmpty()){
            if(Company_Code != null && SAP_Customer_Code != null && Sap_UserId != null && Company_Code != '' && SAP_Customer_Code != '' && Sap_UserId != ''){
                String res = grz_SapIntegration.AccountAndLedgerStatementForArgentina(SAP_Customer_Code,Company_Code, curFiscalYear, fiscalYearFrom, fiscalYearTo,Sap_UserId);
                if(res.equals('Error_In_Sap')){
                    Data.isSuccess=false;
                    Data.msg='Error en SAP';
                }
                else{
                    Data = Grz_ArgentinaReportWrapper.parse(res);
                    List<ItemInfo1> ItemInfolst1 = new List<ItemInfo1>();
                    DateTime todaysDate = System.today();
                    Date todaysDateStr = todaysDate.dateGMT();
                    List<String> arDocType = new List<String>();
                    
                    for(ItemInfo ifo1 : Data.ItemInfo){
                        // the snippet below is introduced to remove DA Custom Metadata Record which added on metadata for Account Ledger for Argentina community,GRZ(Mohit Garg) : APPS-1757 added on: 09-11-2022
                        // the snippet below is introduced to fiter data based on not credit is 0 for Argentina community,GRZ(Mohit Garg) : APPS-1757 added on: 08-12-2022
                        if((ifo1.PostDate != '0000-00-00' && ifo1.AccountingDocNumber != null) && (ifo1.NetDueDate != '' || ifo1.NetDueDate != null) && ifo1.DocType == 'SB' && ifo1.DocType != 'DA' && ifo1.Credit != '0.0'){
                            ItemInfo1 ItemInfo1 = new ItemInfo1();
                            // the snippet below is introduced to map AccountingDocNumber Column with ReferebceChqNumber for Argentina community,GRZ(Mohit Garg) : APPS-1757 added on: 28-11-2022
                            ItemInfo1.AccountingDocNumber = ifo1.ReferebceChqNumber;
                            ItemInfo1.PostDate = ifo1.PostDate;
                            ItemInfo1.DocType = ifo1.DocType;
                            // the snippet below is introduced to assign USD Currency in default for Argentina community,GRZ(Mohit Garg) : APPS-1757 added on: 23-12-2022
                            ItemInfo1.DocCurrency = 'USD';
                            DateTime todayDate = date.valueOf(ifo1.BlineDate);
                            DateTime today1 = todayDate + Integer.valueOf(ifo1.DsctDays1);
                            ItemInfo1.NetDueDate = ifo1.NetDueDate;
                            ItemInfo1.AmountInDocCurrency = ifo1.AmountInDocCurrency;
                            // the snippet below is introduced to change sign negative to positive of exchange rate for Argentina community,GRZ(Mohit Garg) : APPS-1757 added on: 14-11-2022
                            ItemInfo1.ExchangeRate = math.abs(Decimal.valueOf(ifo1.ExchangeRate));
                            ItemInfo1.InvoiceReference = ifo1.InvoiceReference;
			    //Changes done by Ishu for to generate pdf for SB doctype. 
                            ItemInfo1.Assignment = ifo1.AccountingDocNumber; 
                              ItemInfo1.DocTypeShortForm = ItemInfo1.DocType;
                            ItemInfolst1.add(ItemInfo1);
                        }
                    }                    
                    Map<String,String> mxdocMap = new Map<String,String>();
                    // the SOQL Query return the record which record doesnot have SB and DA Developer Name for Argentina community,GRZ(Mohit Garg) : APPS-1757 added on: 09-11-2022
                    for(Argentina_Report__mdt ad : [Select DeveloperName,Short_Form__c, Full_Form__c from Argentina_Report__mdt	 where DeveloperName != 'SB' and DeveloperName != 'DA' order by DeveloperName]){
                        mxdocMap.put(ad.DeveloperName,ad.Short_Form__c);
                    }
                    list<ItemInfo> objItemList=new list<itemInfo>();
                    for(ItemInfo ifo : Data.ItemInfo){
                        if(mxdocMap.containsKey(ifo.DocType) && (ifo.PostDate != '0000-00-00' && ifo.AccountingDocNumber != null) && (ifo.DocType != '' || ifo.DocType != null) && (ifo.NetDueDate != '' || ifo.NetDueDate != null) && ifo.DocType != 'SB'){
                            // the snippet below is introduced to sum bline date and DsctDays1 in NetDueDate for Argentina community,GRZ(Mohit Garg) : APPS-1757 added on: 28-12-2022
                            DateTime todayDate = date.valueOf(ifo.BlineDate);
                            DateTime today1 = todayDate + Integer.valueOf(ifo.DsctDays1);
                            Date todayDateGMT = today1.dateGmt();
                            ifo.NetDueDate = String.valueOf(todayDateGMT);
                            ifo.DocType = mxdocMap.get(ifo.DocType);
                            
                            // the snippet below is introduced to add negetive sign of AmountInDocCurrency for DocType R3,YO,CX,SB for Argentina community,GRZ(Mohit Garg) : APPS-1757 added on: 24-11-2022
                            if(ifo.DocType == 'R3' || ifo.DocType == 'YO' || ifo.DocType == 'CX'){
                                Ifo.AmountInDocCurrency = '-'+ifo.AmountInDocCurrency;
                            }
                            
                            // the snippet below is introduced to assign USD Currency in default for Argentina community,GRZ(Mohit Garg) : APPS-1757 added on: 23-12-2022
                            ifo.DocCurrency = 'USD';
                            // the snippet below is introduced to map AccountingDocNumber Column with ReferebceChqNumber for Argentina community,GRZ(Mohit Garg) : APPS-1757 added on: 28-11-2022
                            ifo.AccountingDocNumber = ifo.ReferebceChqNumber;
                            objItemList.add(ifo);                        
                        }
                        
                    }
                    Data.ItemInfo = objItemList;
                    Data.ItemInfo1 = ItemInfolst1;
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
        return Data;
    }

// Method created for get SAP Customer Code for logged in user : Mohit garg(APPS - 1757) Date : 30 sept 2022
    @AuraEnabled(cacheable=true)
    public static map<string,object> loggedUserData(){
        map<string,object> map2return = new map<string,object>();
            Id userId = UserInfo.getUserId();
            list<User> user = [SELECT Id,account.SAP_Customer_Code__c,account.Depot_Code__c,AccountId FROM User where Id =: userId];
            map2return.put('AccountId',user[0].AccountId);
            map2return.put('Depot',user[0].account.Depot_Code__c);
            map2return.put('CustomerCode',user[0].account.SAP_Customer_Code__c);
        return map2return;
    }

    public static Grz_ArgentinaReportWrapper parse(String json) {
        return (Grz_ArgentinaReportWrapper) System.JSON.deserialize(json, Grz_ArgentinaReportWrapper.class);
    }

    public class Grz_ArgentinaReportWrapper {
        @AuraEnabled public List<ItemInfo> ItemInfo{get;set;}
        @AuraEnabled public List<ItemInfo1> ItemInfo1{get;set;}
        @AuraEnabled public Boolean isSuccess{get;set;}
        @AuraEnabled public String msg{get;set;}        
    }

    public class CustomerInfo {
        @AuraEnabled public String CustomerName{get;set;}
        @AuraEnabled public String CustomerCode{get;set;}
        @AuraEnabled public String City{get;set;}
    }

    public class ItemInfo {
        
        @AuraEnabled public String AccountingDocNumber{get;set;}
        @AuraEnabled public String PostDate{get;set;}
        @AuraEnabled public String DocType{get;set;}
        @AuraEnabled public String DocCurrency{get;set;}
        @AuraEnabled public String NetDueDate{get;set;}
        @AuraEnabled public String AmountInDocCurrency{get;set;}
        @AuraEnabled public String ExchangeRate{get;set;}
        @AuraEnabled public String InvoiceReference{get;set;}
        @AuraEnabled public String ReferebceChqNumber{get;set;}
        @AuraEnabled public String Credit{get;set;}
        @AuraEnabled public String BlineDate{get;set;}
        @AuraEnabled public String DsctDays1{get;set;}
    }

     public class ItemInfo1 {
          @AuraEnabled public String Assignment{get;set;}
         @AuraEnabled public String AccountingDocNumber{get;set;}
         @AuraEnabled public String PostDate{get;set;}
         @AuraEnabled public String DocType{get;set;}
         @AuraEnabled public String DocCurrency{get;set;}
         @AuraEnabled public String NetDueDate{get;set;}
         @AuraEnabled public String AmountInDocCurrency{get;set;}
         @AuraEnabled public Decimal ExchangeRate{get;set;}
         @AuraEnabled public String InvoiceReference{get;set;}
         @AuraEnabled public String ReferebceChqNumber{get;set;}
         @AuraEnabled public String Credit{get;set;}
         @AuraEnabled public String BlineDate{get;set;}
         @AuraEnabled public String DsctDays1{get;set;}
          @AuraEnabled public String DocTypeShortForm{get;set;}
	 }
}