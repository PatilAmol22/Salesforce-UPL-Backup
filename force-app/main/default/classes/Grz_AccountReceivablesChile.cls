public with sharing class Grz_AccountReceivablesChile {
    @AuraEnabled
    public static ResultWrapper getCustomerRecord(String customerCode){
        ResultWrapper Data = new ResultWrapper();
        List<String> salesorgcode = System.Label.Grz_ChileSalesOrgCode.trim().Split(',');
        List<Account> accList = [SELECT Id,Sap_UserId__c ,Company_Code__c,SAP_Customer_Code__c,Name,BillingCity FROM Account WHERE ID =: customerCode AND Sales_org_Code__c in:salesorgcode LIMIT 1];
        if(!accList.isEmpty()){
            Data.sapUserId = accList[0].Sap_UserId__c;
            Data.companyCode =accList[0].Company_Code__c;
            Data.customerCode =accList[0].SAP_Customer_Code__c;
            Data.name = accList[0].Name;
            Data.city = accList[0].BillingCity;
            Data.noDistributor = false;
        }else{
            Data.noDistributor = true;
        } 
        return Data;
    }
    @AuraEnabled(cacheable=true)
    public static ResultWrapper getuserInfo(){
        ResultWrapper rapper = new ResultWrapper();
        Id id;
        if(Test.isRunningTest()){
            List<Profile> pro = [SELECT Id FROM Profile WHERE Name = 'Chile Partner Community Distributor Profile'];
            List<User> user = [SELECT Id, Username, AccountId, ContactId FROM User WHERE ProfileId =: pro[0].Id AND lastname = 'Testing' and Email ='test@grazitti.com' LIMIT 1];
            if(user.size()>0){
            id = user[0].Id;
            }
        }
        else{
            id = UserInfo.getUserId();
        }
        List<User> user = [SELECT Id, Username, AccountId, ContactId,Account.Customer_Group__c,Account.SAP_Customer_Code__c,Account.Name,Account.BillingCity,Account.Company_Code__c ,Account.Sap_UserId__c FROM User where Id =: id];
        String accountId = user[0].AccountId;
        if(!String.isEmpty(accountId)){
            rapper.isInternal = false;    
            rapper.customerCode = user[0].Account.SAP_Customer_Code__c;
            rapper.companyCode = user[0].Account.Company_Code__c;
            rapper.sapUserId = user[0].Account.Sap_UserId__c;
            rapper.name = user[0].Account.Name;
            rapper.city = user[0].Account.BillingCity;
        }else{
            rapper.isInternal = true;
        }
        return rapper; 
    }
    @AuraEnabled(cacheable=true)
    public static ResultWrapper getAccountReceivables(String customerCode, String sapUserId, String companyCode,String refSearch,String dueDateStart,String dueDateEnd,String startDate,String endDate,boolean forDownload ){
        ResultWrapper rapper = new ResultWrapper();
        List<Lineitems> pdfInfo = new List<Lineitems>();
        DateTime todaysDate = System.today();
        DateTime today0_30 = todaysDate + 30;
        DateTime today31_60 = today0_30 + 30;
        Date todaysDateStr = todaysDate.dateGMT();
        String res;
        res = grz_SapIntegration.getMexicoChileAR(customerCode,sapUserId,companyCode,String.ValueOf(todaysDateStr),'x','x');
        res = res.replace('Currency','Currenci');
        if(res.equals('Error_In_Sap')){
            rapper.isSuccess = false;
            rapper.Message = 'Error en SAP';
        }
        else{
            rapper.isSuccess = true;
            rapper.ar = (Cl_Account_receivable) JSON.deserialize(res, Cl_Account_receivable.class); 
            List<Lineitems> filterInfo = new List<Lineitems>();
            rapper.totalOverdue = 0;
            rapper.notYetDue = 0;
            rapper.upto_0_30 = 0;
            rapper.upto_31_60 = 0;
            rapper.after_61 = 0;
            rapper.totalOverdueCLP = 0;
            rapper.notYetDueCLP = 0;
            rapper.upto_0_30CLP = 0;
            rapper.upto_31_60CLP = 0;
            rapper.after_61CLP = 0;
            Integer count = 0;
            for(Lineitems ifo : rapper.ar.Lineitems){
                if(ifo.DbCrInd == 'H'){
                    ifo.LcAmount = '-' + ifo.LcAmount;
                    ifo.HardCurrenciAmount = '-' + ifo.HardCurrenciAmount;
                    ifo.AmtDoccur = '-' + ifo.AmtDoccur;
                }
                count = count + 1;
                ifo.unique = count + 1;
                if(date.valueof(ifo.DueDate) < todaysDate){
                    ifo.overDued = true;
                    rapper.totalOverdue =  rapper.totalOverdue+decimal.valueOf(ifo.LcAmount);
                    rapper.totalOverdueCLP =  rapper.totalOverdueCLP + decimal.valueOf(ifo.HardCurrenciAmount);
                }else{
                    rapper.notYetDue =  rapper.notYetDue+decimal.valueOf(ifo.LcAmount);
                    rapper.notYetDueCLP =  rapper.notYetDueCLP+decimal.valueOf(ifo.HardCurrenciAmount);
                    ifo.overDued = false;
                    if(date.valueof(ifo.DueDate) >= todaysDate && date.valueof(ifo.DueDate) < today0_30){
                        rapper.upto_0_30 = rapper.upto_0_30 + decimal.valueOf(ifo.LcAmount);
                        rapper.upto_0_30CLP = rapper.upto_0_30CLP + decimal.valueOf(ifo.HardCurrenciAmount);
                    } else if(date.valueof(ifo.DueDate) >= today0_30 && date.valueof(ifo.DueDate) < today31_60){
                        rapper.upto_31_60 = rapper.upto_31_60 + decimal.valueOf(ifo.LcAmount);
                        rapper.upto_31_60CLP = rapper.upto_31_60CLP + decimal.valueOf(ifo.HardCurrenciAmount);
                    }else{
                        rapper.after_61 = rapper.after_61 + decimal.valueOf(ifo.LcAmount);
                        rapper.after_61CLP = rapper.after_61CLP + decimal.valueOf(ifo.HardCurrenciAmount);
                    }
                }
                if(forDownload){
                    if(startDate == 'null' || startDate == 'undefined'){
                        if(date.valueOf(ifo.DocDate) <= date.valueOf(endDate) && date.valueOf(ifo.DueDate) >= date.valueOf(dueDateStart) &&  date.valueOf(ifo.DueDate) <= date.valueOf(dueDateEnd) && (ifo.BillDoc).contains(refSearch) ){
                            pdfInfo.add(ifo);
                        }
                    }else{
                        if(date.valueof(ifo.DocDate) >= date.valueOf(startDate) && date.valueOf(ifo.DocDate) <= date.valueOf(endDate) && date.valueOf(ifo.DueDate) >= date.valueOf(dueDateStart) &&  date.valueOf(ifo.DueDate) <= date.valueOf(dueDateEnd) && (ifo.BillDoc).contains(refSearch) ){
                            pdfInfo.add(ifo);
                        }
                    }
                }
            }
        }
        if(forDownload){
            rapper.ar.Lineitems = pdfInfo;
        }
        return rapper; 
    }
    public class ResultWrapper {    
        @AuraEnabled public decimal totalOverdue { get; set; }
        @AuraEnabled public decimal notYetDue { get; set; }
        @AuraEnabled public decimal upto_0_30 { get; set; }
        @AuraEnabled public decimal upto_31_60 { get; set; }
        @AuraEnabled public decimal after_61 { get; set; }
        @AuraEnabled public decimal totalOverdueCLP { get; set; }
        @AuraEnabled public decimal notYetDueCLP { get; set; }
        @AuraEnabled public decimal upto_0_30CLP { get; set; }
        @AuraEnabled public decimal upto_31_60CLP { get; set; }
        @AuraEnabled public decimal after_61CLP { get; set; }
        @AuraEnabled public String customerCode { get; set; }
        @AuraEnabled public String sapUserId { get; set; }
        @AuraEnabled public String companyCode { get; set; }
        @AuraEnabled public String name { get; set; }
        @AuraEnabled public String city { get; set; }
        @AuraEnabled public boolean isInternal { get; set; }
        @AuraEnabled public boolean noDistributor { get; set; }
        @AuraEnabled public Cl_Account_receivable ar { get; set; }
        @AuraEnabled public boolean isSuccess{get;set;}
        @AuraEnabled public String Message{get;set;}
    }  
    public class Cl_Account_receivable{
        @AuraEnabled public List<Lineitems> Lineitems {get;set;}
    }
    public class Lineitems {
        @AuraEnabled public String DbCrInd{get;set;}
        @AuraEnabled public String RefDocNo{get;set;}
        @AuraEnabled public String DocDate{get;set;}
        @AuraEnabled public String BillDoc{get;set;}
        @AuraEnabled public String Currenci{get;set;}
        @AuraEnabled public String AmtDoccur{get;set;}
        @AuraEnabled public String LcAmount{get;set;}
        @AuraEnabled public String HardCurrenciAmount{get;set;}
        @AuraEnabled public String DueDate{get;set;}
        @AuraEnabled public boolean overDued{get;set;}
        @AuraEnabled public Integer unique{get;set;}
    }
}