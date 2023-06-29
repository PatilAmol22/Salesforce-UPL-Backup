public without sharing class AccountSummaryReportCtrl {
    public Decimal closingBal{get;set;}
    public Credit_Info__c Credit_InfoObj{get;set;}
    public WrapCreditInfo wci{get;set;}
    public wrapOutstanding data{get;set;}
    public Decimal overdue {get;set;}
    public DateTime accStLastMod {get;set;}
    public String todaysDate {get;set;}
    public List<Community_Configuration__c> ccList{get;set;} 
    public String currencySign {get;set;}
    public Decimal paymentOustadings{get;set;}
    public CreditInfoWrapper CreditInfoWrapperObj {get;set;}
    
    
    public AccountSummaryReportCtrl() {
        System.debug('in Account Summarty controller');
        closingBal = 0.0;
        overdue = 0.0;
        Credit_InfoObj = new Credit_Info__c();
        wci = new WrapCreditInfo();
        data = new wrapOutstanding();
        ccList = new List<Community_Configuration__c>();
        // DateTime todaysDate1 = System.today();
        //Change by Swaranjeet(Grazitti) APPS-1315
        DateTime todaysDate1 = DateTime.now();
        System.debug('pdftodaysDate1---'+todaysDate1);
        String todaysDateStr = todaysDate1.format('dd-MM-yyyy');
        System.debug('pdftodaysDateStr---'+todaysDateStr);
        todaysDate = todaysDateStr;
        System.debug('pdftodaysDate---'+todaysDate);
        currencySign ='';
        // resUrl ='';
        
    }
    
    
    public void displayAccountSummary(){
        System.debug('in action Reprot');
        String recordId = '';    
        String userid = UserInfo.getUserId();
        String CommunityRole ='';
        String salesOrg ='';
        String countryName ='';
        User userObj = [SELECT Id,UserName,Community_Role__c,TimeZoneSidKey, Account.Sap_userId__c,AccountId,Account.Sales_Org_Code__c,
                        Account.Sales_Org_Country__c FROM User WHERE Id=: userid];
        String sapUserId;
        recordId = userObj.AccountId;
        //Change by Swaranjeet(Grazitti) APPS-1315
        if(userObj.Account.Sap_userId__c != null)
            sapUserId=userObj.Account.Sap_userId__c;
        
        
        salesOrg = userObj.Account.Sales_Org_Code__c;
        countryName =userObj.Account.Sales_Org_Country__c;
        CommunityRole= userObj.Community_Role__c;
        if(countryName=='Poland'){
            currencySign ='PLN ';
        }
        if(countryName=='Spain'){
            currencySign ='€';
        }
        if(countryName=='Portugal'){
            currencySign ='€';
        }
        if(countryName=='Colombia'){
            currencySign ='$ ';
        }
        if(countryName=='Naturagri'){
            currencySign ='€';
        }
        if(countryName=='Turkey'){
            currencySign ='TRY';
        }
        
        List<Community_Configuration__c> forCheckList = new List<Community_Configuration__c>();
        
        forCheckList = [Select Id from Community_Configuration__c
                        WHERE Distributor_Name__c=:RecordId];
        
        //if(forCheckList.size()>0){
        System.debug('Inside Account record');
        ccList =[Select Id,Name,Company_Name__c,Company_Address__c,Company_Contact_Number__c,
                 Company_Logo__c
                 FROM Community_Configuration__c
                 Where (Distributor_Name__c =:recordId OR Visible_to_All__c = TRUE)
                 AND RecordType.Name='General Setting'
                 AND Sales_Org__c =:salesOrg
                 AND Country__c=:countryName
                 AND Community_User_Role__c =:CommunityRole 
                 AND Active__c=true ];
        //}
        
        
        
        //Credit_Limit__c
        //Used_Limit__c
        //Balance_Limit__c
        //Percentage_Used__c
        //Sum_Open_Item__c
        //overdue
        
        
        Credit_InfoObj = [SELECT Id,Name,Distributor__c,Distributor__r.Name,Distributor__r.SAP_Code__c,Credit_Limit__c,Used_Limit__c,
                          Percentage_Used__c,Balance_Limit__c,Sum_Open_Item__c,LastModifiedDate,Distributor__r.CurrencyIsoCode 
                          From Credit_Info__c 
                          WHERE Distributor__c=:recordId LIMIT 1];
        Credit_InfoObj.Distributor__r.Name=Credit_InfoObj.Distributor__r.Name.replace('ł','l').replace('ę','e').replace('ą','a').replace('ś','s').replace('ń','n').replace('ó','o').replace('ż','z').replace('ć','c').replace('ź','z').replace('Ę','E').replace('Ć','C');
        
        
        CreditInfoWrapperObj = new CreditInfoWrapper();
         //Change by Swaranjeet(Grazitti) APPS-1315
        /*if(countryName=='Spain'||countryName=='Portugal'||countryName=='Colombia'||countryName=='Poland'){

List<Outstanding_Ageing__c> oagList = [SELECT id, LastModifiedDate,OutstandingTotalGreaterthan90__c, Net_Outstanding__c  
FROM Outstanding_Ageing__c   
WHERE Customer_Code__c =:recordId LIMIT 1];
List<Payments__c> oaList = [SELECT id, Net_Overdue__c  FROM Payments__c     
WHERE Customer_Name__c =:recordId LIMIT 1]; 


Decimal paymentOutstanding;
Decimal overdues;
if(oagList.size()>0){ 
if(countryName=='Colombia'){
paymentOutstanding = (oagList[0].Net_Outstanding__c)*100; 
}else{
paymentOutstanding = (oagList[0].Net_Outstanding__c);
}
accStLastMod = oagList[0].LastModifiedDate;
} 

if(!oaList.isEmpty()){  
overdues = oaList[0].Net_Overdue__c; //oaList[0].OutstandingTotalGreaterthan90__c;  
} 
Account_Statement__c accStaObj = new Account_Statement__c();
if(!Test.isRunningTest()){
accStaObj = [Select Id,Name,Closing_Balance__c,LastModifiedDate from Account_Statement__c WHERE Account__c=:recordId ORDER BY LastModifiedDate DESC LIMIT 1];    
}


paymentOustadings = paymentOutstanding ;
System.debug('overdues in Connect '+overdues);
if(overdues!=null){
overdue = overdues;    
}else{
overdue = 0;
}

//if(accStaObj!=null){
closingBal = paymentOutstanding;
}else{*/
        //Change by Swaranjeet(Grazitti) APPS-1315
        if(sapUserId!=null){
            String turkeyUserId = UserInfo.getUserId();
            String sapCode ='';
            String salesOrgCode ='';
            String companyCode ='';
            String country ='';
            String distributionCode ='';
            String divisionCode ='';
            User userObject = [SELECT Id,UserName,Community_Role__c,TimeZoneSidKey,Account.SAP_Code__c,Account.Company_Code__c,Account.Distribution_Channnel_Code__c,Account.Division_Code__c,	
                               AccountId,Account.Sales_Org_Code__c,Account.Sales_Org_Country__c FROM User WHERE Id=: turkeyUserId];
            System.debug(userObject);                
            sapCode = userObject.Account.SAP_Code__c;
            salesOrgCode = userObject.Account.Sales_Org_Code__c;
            companyCode = userObject.Account.Company_Code__c;
            country =userObject.Account.Sales_Org_Country__c;  
            distributionCode =userObject.Account.Distribution_Channnel_Code__c;
            divisionCode =userObject.Account.Division_Code__c;
            //Change by Swaranjeet(Grazitti) APPS-1315
            if(divisionCode == null){
                divisionCode='';
            }
            //Change by Swaranjeet(Grazitti) APPS-1315
             List<String> creditControlList = System.Label.Grz_CreditControlMapping.split(',');
            Map<String,String> salesOrgToCreditControlMap = new Map<String,String>();
            for(String st : creditControlList){
                salesOrgToCreditControlMap.put(st.substringBefore('-').trim(), st.substringAfter('-').trim());
            }
            String username='';
            String password='';
            String tokenEndpoint='';
            Community_Endpoints__c tokenEndpointURL = [SELECT Id, Name, URL__c FROM Community_Endpoints__c where Name ='Token' limit 1];
            tokenEndpoint = tokenEndpointURL.URL__c;
            Community_Credentials__c credentials = [SELECT Id, Name, Username__c, Password__c FROM Community_Credentials__c where Name ='oauth credentials' limit 1];
            username = credentials.Username__c;
            password = credentials.Password__c;
            wrapOauthResponse wrapOauthResponseObj;
            String oathRes;
            String ciRes;
            String responseAccesToken;
            
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            req.setMethod('POST');           
            Blob headerValue = Blob.valueOf(username + ':' + password);
            String authorizationHeader = 'BASIC ' +EncodingUtil.base64Encode(headerValue);
            req.setHeader('Authorization', 'Basic ' +EncodingUtil.base64Encode(Blob.valueOf(username + ':' + password)));
            req.setEndpoint(tokenEndpoint);     
            HTTPResponse res;
            res = http.send(req);
            oathRes = res.getBody();
            wrapOauthResponseObj = (wrapOauthResponse)System.JSON.deserialize(oathRes, wrapOauthResponse.class);
            
            String creditSummaryEndpoint;
            Community_Endpoints__c creditSummaryEndpointURL = [SELECT Id, Name, URL__c FROM Community_Endpoints__c where Name ='Credit Summary' limit 1];
            creditSummaryEndpoint = creditSummaryEndpointURL.URL__c;
            req.setEndpoint(creditSummaryEndpoint);
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('Authorization', 'Bearer ' +wrapOauthResponseObj.access_token);
            System.debug('companyCode---'+companyCode);
            System.debug('sapCode---'+sapCode);
            
            req.setBody('{"companyCode": '+'"'+companyCode+'"'+',"customerCode": '+'"'+sapCode+'"'+',"sapUserId": '+'"'+sapUserId+'"}');
            HttpResponse response = http.send(req);
            ciRes=response.getBody();
            Map<String, object> results = (Map<String, object>)JSON.deserializeUntyped(ciRes);
            
            String customerOutstandingEndpoint;
            Community_Endpoints__c customerOutstandingEndpointURL = [SELECT Id, Name, URL__c FROM Community_Endpoints__c where Name ='Customer Outstanding' limit 1];
            customerOutstandingEndpoint = customerOutstandingEndpointURL.URL__c;
            req.setEndpoint(customerOutstandingEndpoint);
            req.setMethod('POST');
            req.setTimeout(120000);
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('Authorization', 'Bearer ' +wrapOauthResponseObj.access_token);
            System.debug('salesOrgCode---'+salesOrgCode);
            System.debug('distributionCode---'+distributionCode);
            System.debug('divisionCode---'+divisionCode);
            req.setBody('{"sapUserId": '+ '"'+sapUserId+'"'+',"customerNumber": '+'"'+sapCode+'"'+',"companyCode": '+'"'+companyCode+'"'+',"salesOrg": '+'"'+salesOrgCode+'"'+',"distrChan": '+'"'+distributionCode+'"'+',"division": '+'"'+divisionCode+'"'+'}');
            HttpResponse resp = http.send(req);
            Item outstanding = new Item();
            if(resp.getStatusCode() == 200) {
                System.debug(resp.getBody());
                //Change by Swaranjeet(Grazitti) APPS-1315
                data = (wrapOutstanding)System.JSON.deserialize(resp.getBody(), wrapOutstanding.class);
                outstanding = data.item;
                System.debug(outstanding);
            }
            
            
            List<object> CInfo = (List<object>)results.get('CreditInfo');
             WrapCreditInfo CinfoNew = new WrapCreditInfo();
            system.debug('CInfo:'+CInfo);
             //Change by Swaranjeet(Grazitti) APPS-1315
            if(CInfo != null && CInfo.size()>0){
                  for(object ci : CInfo){
                       String s = JSON.serialize(ci);
                    CinfoNew=(WrapCreditInfo)System.JSON.deserialize(s, WrapCreditInfo.class);
                    if(CinfoNew.credit_control != null && CinfoNew.credit_control != ''){
                         if(salesOrgToCreditControlMap.get(salesOrgCode) != 'null' && CinfoNew.credit_control == salesOrgToCreditControlMap.get(salesOrgCode)){
                           // CinfoNew=(WrapCreditInfo)JSON.deserialize(String.valueOf(ci), WrapCreditInfo.Class);
                            System.debug('CinfoNew--'+CinfoNew);
                           // cinfonew1 = CinfoNew;
                           
                            break;
                        }  
                    }
                  }
                
            }
            if(!Test.isRunningTest()){
                String s = JSON.serialize(CinfoNew);
                wci= (WrapCreditInfo)System.JSON.deserialize(s, WrapCreditInfo.class);
                System.debug(wci);
            }
            
            /*  }


}
gettingOverdue();
if(countryName=='Poland'){

CreditInfoWrapperObj.Credit_Limit_Poland =String.valueOf(Credit_InfoObj.Credit_Limit__c).replace('.',',');     
CreditInfoWrapperObj.Used_Limit_Poland =String.valueOf(Credit_InfoObj.Used_Limit__c).replace('.',',');     
CreditInfoWrapperObj.Balance_Limit_Poland =String.valueOf(Credit_InfoObj.Balance_Limit__c).replace('.',',');   
if(!Test.isRunningTest()){
// CreditInfoWrapperObj.outstanding_Poland =String.valueOf(paymentOustadings).replace('.',',');
}
CreditInfoWrapperObj.used_Poland =String.valueOf(Credit_InfoObj.Percentage_Used__c).replace('.',',');
if(!Test.isRunningTest()){
CreditInfoWrapperObj.closingBal_Poland =String.valueOf(closingBal).replace('.',','); 
}
CreditInfoWrapperObj.crtyName ='Poland';

}*/ 
            try{     
    if(countryName=='Turkey' || countryName=='Poland' || countryName=='Colombia' || country=='Spain'||country=='Portugal'){
   
    CreditInfoWrapperObj.Credit_Limit_Poland =String.valueOf(wci.CreditLimit).replace('.',',');     
    CreditInfoWrapperObj.Used_Limit_Poland =String.valueOf(wci.CreditExposure).replace('.',',');     
    CreditInfoWrapperObj.Balance_Limit_Poland =String.valueOf(wci.BalanceLimit).replace('.',',');
    
        CreditInfoWrapperObj.outstanding_Poland = null != String.valueOf(outstanding.netOutstanding) ? String.valueOf(outstanding.netOutstanding).replace('.',',') : '0.0';     
  
   
    CreditInfoWrapperObj.used_Poland =String.valueOf(wci.Percentage);
    CreditInfoWrapperObj.closingBal_Poland =String.valueOf(outstanding.netOutstanding).replace('.',',');
    CreditInfoWrapperObj.crtyName ='other';
    
}else{
    CreditInfoWrapperObj.Credit_Limit_Poland =String.valueOf(Credit_InfoObj.Credit_Limit__c);     
    CreditInfoWrapperObj.Used_Limit_Poland =String.valueOf(Credit_InfoObj.Used_Limit__c);     
    CreditInfoWrapperObj.Balance_Limit_Poland =String.valueOf(Credit_InfoObj.Balance_Limit__c);
    CreditInfoWrapperObj.outstanding_Poland =String.valueOf(paymentOustadings);     
    CreditInfoWrapperObj.used_Poland =String.valueOf(Credit_InfoObj.Percentage_Used__c);
    CreditInfoWrapperObj.closingBal_Poland =String.valueOf(closingBal);
    CreditInfoWrapperObj.crtyName ='other';
}
}
            catch(Exception e){
                System.debug('Exception---'+e);
            }
            System.debug('CreditInfoWrapperObj '+CreditInfoWrapperObj);
    
        }
        else{
           System.debug('Data not found');
        }
            
            
        }
        
        
        public class CreditInfoWrapper{
            public String Credit_Limit_Poland{get;set;}
            public String Used_Limit_Poland{get;set;}
            public String Balance_Limit_Poland{get;set;}
            public String outstanding_Poland{get;set;}
            public String used_Poland{get;set;}
            public String closingBal_Poland{get;set;}
            public String crtyName{get;set;}
            
            public CreditInfoWrapper(){
                Credit_Limit_Poland='';
                Used_Limit_Poland='';
                Balance_Limit_Poland='';
                outstanding_Poland='';
                used_Poland='';
                closingBal_Poland='';
                crtyName='';
            }
            /* public String Credit_Limit_Poland{get;set;}
public String Used_Limit_Poland{get;set;}
public String Balance_Limit_Poland{get;set;}
public String outstanding_Poland{get;set;}
public String used_Poland{get;set;}*/
        }
        
        public class wrapOauthResponse{
            @AuraEnabled
            public String access_token{get;set;}
            @AuraEnabled
            public String token_type{get;set;}
            @AuraEnabled
            public String expires_in{get;set;}
            @AuraEnabled
            public String scope{get;set;}  
            
            public wrapOauthResponse(){
                access_token='';
                token_type='';
                expires_in='';  
                scope='';    
            }
        }
        
        public class  WrapCreditInfo{
            
            @AuraEnabled
            public String company_code{get;set;}
            @AuraEnabled
            public String credit_control{get;set;}
            @AuraEnabled
            public String sales_organization{get;set;}
            @AuraEnabled
            public String customer_number{get;set;}
            @AuraEnabled
            public String name{get;set;}
            
            @AuraEnabled
            public String Customer_group{get;set;}
            @AuraEnabled
            public String Customer_Credit_Group{get;set;}
            
            @AuraEnabled
            public String clean_limit{get;set;}
            @AuraEnabled
            public String Line_limit{get;set;}
            @AuraEnabled
            public String Total_receivables{get;set;}
            
            @AuraEnabled
            public String Credit_exposure{get;set;}
            
            @AuraEnabled
            public String Next_internal_review{get;set;}
            @AuraEnabled
            public String CreditLimit{get;set;}
            @AuraEnabled
            public String CreditExposure{get;set;}
            @AuraEnabled
            public String Percentage{get;set;}
            @AuraEnabled
            public String BalanceLimit{get;set;}
            
            public WrapCreditInfo(){
                company_code = '';           		
                credit_control = '';
                sales_organization = '';
                customer_number = '';
                name = '';            
                Customer_group = '';
                Customer_Credit_Group = '';            
                clean_limit = '';
                Line_limit = '';
                Total_receivables = '';
                Credit_exposure = '';     
                Next_internal_review = '';
                CreditLimit = '';
                CreditExposure = '';
                Percentage = '';
                BalanceLimit = '';
            }
        }
     public class wrapOutstanding {
            @AuraEnabled
         public Item item{get;set;}
     }
        
        public class Item {
            @AuraEnabled
            public String customerNumber{get;set;}
            @AuraEnabled
            public String custName{get;set;}
            @AuraEnabled
            public String totalOutstanding{get;set;}
            @AuraEnabled
            public String unadjustedReceipts{get;set;}
            @AuraEnabled
            public String unadjustedCredits{get;set;}
            @AuraEnabled
            public String netOutstanding{get;set;}
            @AuraEnabled
            public String currencyKey{get;set;}
            
            public Item(){
                customerNumber = '';
                custName = '';
                totalOutstanding = '';
                unadjustedReceipts = '';
                unadjustedCredits = '';
                netOutstanding = '0.0';
                currencyKey = '';
            }
        }
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        /* public  void gettingOverdue(){
String recordId = '';    
String userid = UserInfo.getUserId();
System.debug('userid '+userid);
User userObj = [SELECT Id,UserName,TimeZoneSidKey, AccountId FROM User WHERE Id=: userid];
recordId = userObj.AccountId;


List<CustomerTransaction__c> customerTransList = new List<CustomerTransaction__c>();
Decimal totalAmount=0;
customerTransList = [SELECT Id, Amount__c
FROM CustomerTransaction__c 
WHERE Customer__c=:recordId AND Clearing_doc__c = '' AND DocType__c  In ('AB','R1','R3','R4','R5','SA','SB','RV')];

if(customerTransList.size()>0){
for(CustomerTransaction__c obj :customerTransList){
totalAmount = totalAmount + obj.Amount__c;
}
System.debug('totalAmount in account Summary '+totalAmount);

}
overdue = totalAmount;


}*/
        
        /*  public class CreditInfoWrapper{

public Decimal Credit_Limit{get;set;}
public Decimal Used_Limit{get;set;}
public Decimal Balance_Limit{get;set;}
public Decimal Sum_Open_Item{get;set;}
public Decimal Percentage_Used{get;set;}
public Decimal overdue{get;set;}
}*/
        
        
        
        
        
    }