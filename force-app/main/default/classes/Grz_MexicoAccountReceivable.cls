public with sharing class Grz_MexicoAccountReceivable {
    
    @AuraEnabled(cacheable=true)
    public static ResultWrapperArMexico getMexicoArData(String executedfrom){
        system.debug('executedfrom : '+executedfrom);
        ResultWrapperArMexico Data = new ResultWrapperArMexico();
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
        if(executedfrom == 'HomePageArGraph' || executedfrom == 'ArLedgerCmp'){
            user = [SELECT Id, Username,account.Company_Code__c,account.CustomerServiceExecutive__c,account.SAP_Customer_Code__c,account.sap_UserId__c,AccountId,Account.Name,Account.BillingCity,ContactId,Account.Sales_District__r.name FROM User where Id =: id];
            Company_Code = user[0].account.Company_Code__c;
            SAP_Customer_Code = user[0].account.SAP_Customer_Code__c;
            Sap_UserId = user[0].account.sap_UserId__c;
            accountId = user[0].AccountId;
            
            Data.customerCode = user[0].account.SAP_Customer_Code__c;
            Data.customerName = user[0].Account.Name;
            Data.customerCity = user[0].Account.BillingCity;
            Data.customerZone = user[0].Account.Sales_District__r.name;
            Data.customerServiceExecutive = user[0].Account.CustomerServiceExecutive__c;
            
        }else{
            //user = [SELECT Id, Username,account.Company_Code__c,account.SAP_Customer_Code__c,account.sap_UserId__c,AccountId,Account.Name,Account.BillingCity,ContactId,Account.Sales_District__r.name FROM User where account.SAP_Customer_Code__c =: executedfrom];
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
        System.debug('User Info : '+user);
       
        DateTime todaysDate = System.today();
        //DateTime today0_30 = todaysDate + 30;
      	//DateTime today31_60 = today0_30 + 30;
        //DateTime today61_75 = today0_30 + 15;
        //DateTime today76_90 = today0_30 + 15;
        //DateTime today91_120 = today0_30 + 30;
        //DateTime today121_150 = today0_30 + 30;
        //DateTime today151_180 = today0_30 + 30;
        //DateTime today181_210 = today0_30 + 30;
        
        DateTime today0_15 = todaysDate + 15;
      	DateTime today16_30 = today0_15 + 15;
        DateTime today31_60 = today16_30 + 30;
        DateTime today61_90 = today31_60 + 30;
        DateTime today91_180 = today61_90 + 90;
        DateTime today181_270 = today91_180 + 90;
        
        Date todaysDateStr = todaysDate.dateGMT();
        Date todaysDateStr1 = today0_15.dateGMT();
      	Date todaysDateStr2 = today16_30.dateGMT();
        Date todaysDateStr3 = today31_60.dateGMT();
        Date todaysDateStr4 = today61_90.dateGMT();
        Date todaysDateStr5 = today91_180.dateGMT();
        Date todaysDateStr6 = today181_270.dateGMT();
        //Date todaysDateStr7 = today151_180.dateGMT();
        //Date todaysDateStr8 = today181_210.dateGMT();
        
        system.debug('todayDatestr==>'+todaysDateStr);
        
        //List<Account> accList = new List<Account>();
            
		if(accountId == NULL){
            Data.checkexternaluser = false;
            /*accList = [select id,name,SAP_Customer_Code__c from account where SAP_Customer_Code__c != Null and Sales_Org_Code__c =: System.Label.Grz_MexicoSalesOrgCode];
            List<Mx_Account_receivable> accwrapList = new List<Mx_Account_receivable>();
            for(Account acc : accList){
                Mx_Account_receivable accObj = new Mx_Account_receivable();
                accObj.Id = acc.Id;
                accObj.Name = acc.Name;
                accObj.SAPCustomerCode = acc.SAP_Customer_Code__c;
                accwrapList.add(accObj);
            }
             Data.relatedAccounts = accwrapList;*/
        }
        else{
            Data.checkexternaluser = true;
        }
        
        if(!user.isEmpty()){        
            if(Company_Code != null && SAP_Customer_Code != null && Sap_UserId != null){
                String res = grz_SapIntegration.getMexicoChileAR(SAP_Customer_Code,Sap_UserId,Company_Code,String.ValueOf(todaysDateStr),'x','y');
                //String res = grz_SapIntegration.getMexicoChileAR('0001006761','UPLINTCRM','5000','2021-12-10','x','y');
        		system.debug('res==>'+res);
                if(res.equals('Error_In_Sap')){
                    Data.isSuccess=false;
                    Data.Message='Error en SAP';
                }
                else{
                    Data.isSuccess = true;
                    List<ARWrapper> filterInfo = new List<ARWrapper>();
                    Data.ar = (Mx_Account_receivable) JSON.deserialize(res,Mx_Account_receivable.class);
                    Data.totalOverdue = 0;
                    Data.notYetDue = 0;
                    Data.upto_0_15 = 0;Data.upto_16_30 = 0;Data.upto_31_60 = 0;Data.upto_61_90 = 0;
                    Data.upto_91_180 = 0;Data.upto_181_270 = 0;
                    Data.after_271 = 0;
                    for(ARWrapper wr : Data.ar.Lineitems){
                        Date billingDate = Date.valueOf(wr.BlineDate);
                        billingDate = billingDate.addDays(Integer.valueOf(wr.DsctDays1));
                        if(executedfrom == 'HomePageArGraph'){
                            if(billingDate < date.valueOf(todaysDateStr)){
                            	Data.totalOverdue += decimal.valueOf(wr.LcAmount);
                        	}
                        	else if(billingDate >= date.valueOf(todaysDateStr)){
                        		Data.notYetDue += decimal.valueOf(wr.LcAmount);
                      		}
                        }else {
                            if(billingDate < date.valueOf(todaysDateStr)){
                                Data.totalOverdue += decimal.valueOf(wr.LcAmount);
                            }
                            else if(billingDate >= date.valueOf(todaysDateStr)){
                                Data.notYetDue += decimal.valueOf(wr.LcAmount);
                            }
                            
                            if(billingDate >= date.valueOf(todaysDateStr) && billingDate < date.valueOf(todaysDateStr1)){
                                Data.upto_0_15 += decimal.valueOf(wr.LcAmount);
                            }
                            else if(billingDate >= date.valueOf(todaysDateStr1) && billingDate < date.valueOf(todaysDateStr2)){
                                Data.upto_16_30 += decimal.valueOf(wr.LcAmount);
                            }
                            else if(billingDate >= date.valueOf(todaysDateStr2) && billingDate < date.valueOf(todaysDateStr3)){
                                Data.upto_31_60 += decimal.valueOf(wr.LcAmount);
                            }
                            else if(billingDate >= date.valueOf(todaysDateStr3) && billingDate < date.valueOf(todaysDateStr4)){
                                Data.upto_61_90 += decimal.valueOf(wr.LcAmount);
                            }
                            else if(billingDate >= date.valueOf(todaysDateStr4) && billingDate < date.valueOf(todaysDateStr5)){
                                Data.upto_91_180 += decimal.valueOf(wr.LcAmount);
                            }
                            else if(billingDate >= date.valueOf(todaysDateStr5) && billingDate < date.valueOf(todaysDateStr6)){
                                Data.upto_181_270 += decimal.valueOf(wr.LcAmount);
                            }
                            else if(billingDate >= date.valueOf(todaysDateStr6)){
                                Data.after_271 += decimal.valueOf(wr.LcAmount);
                            }
                        }
                    }
                    Data.ar = null;
                    system.debug('Data : '+Data.ar);                   
                }       		
            }
            else{
                Data.isSuccess = false;
                Data.Message = 'El código de cliente / código de empresa / ID de usuario está vacío. Comuníquese con el administrador';
            }
        }
        else{
            Data.isSuccess = false;
            Data.Message = 'Los usuarios internos no tienen permiso para acceder a este componente.';
        }
        system.debug('Final Data : '+Data);       
        return Data;
    }
    
    
    public class ResultWrapperArMexico {        
        @AuraEnabled 
        public decimal totalOverdue {get; set;}
        @AuraEnabled 
        public decimal notYetDue { get; set; }
        @AuraEnabled public decimal upto_0_15 { get; set; }
        @AuraEnabled public decimal upto_16_30 { get; set; }
        @AuraEnabled public decimal upto_31_60 { get; set; }
        @AuraEnabled public decimal upto_61_90 { get; set; }
        @AuraEnabled public decimal upto_91_180 { get; set; }
        @AuraEnabled public decimal upto_181_270 { get; set; }
        //@AuraEnabled public decimal upto_151_180 { get; set; }
        //@AuraEnabled public decimal upto_181_210 { get; set; }
        @AuraEnabled public decimal after_271 { get; set; }
        @AuraEnabled
        public Mx_Account_receivable ar { get; set; }
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
        @AuraEnabled 
        public List<Mx_Account_receivable> relatedAccounts {get; set;}
    }
    
    public class Mx_Account_receivable{
        @AuraEnabled 
        public List<ARWrapper> Lineitems {get;set;}
        @AuraEnabled
        public String Id{get;set;}
        @AuraEnabled
        public String Name{get;set;}
        @AuraEnabled
        public String SAPCustomerCode{get;set;}
    }
    public class ARWrapper {
        @AuraEnabled public String BlineDate{get;set;}
        @AuraEnabled public String DsctDays1{get;set;}
        @AuraEnabled public String LcAmount{get;set;}
    }
}