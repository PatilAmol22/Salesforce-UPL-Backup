public without sharing class ConnectAccSummaryController {
    
    
    @AuraEnabled    
    public static  list<Community_Configuration__c> showHideDetailsInfo(){
        String recordId = '';    
        String userid = UserInfo.getUserId();
        String CommunityRole ='';
        String salesOrg ='';
        String countryName ='';
        User userObj = [SELECT Id,UserName,Community_Role__c,TimeZoneSidKey,
                        AccountId,Account.Sales_Org_Code__c,Account.Sales_Org_Country__c FROM User WHERE Id=: userid];
        recordId = userObj.AccountId;
        salesOrg = userObj.Account.Sales_Org_Code__c;
        countryName =userObj.Account.Sales_Org_Country__c;
        CommunityRole= userObj.Community_Role__c;
        
        
        list<Community_Configuration__c> cclIst = new List<Community_Configuration__c>();
        list<Community_Configuration__c> forCheckList = new List<Community_Configuration__c>();
        
        
        //forCheckList = [Select Id from Community_Configuration__c WHERE Distributor_Name__c=:RecordId];
        
        System.debug('Statement forCheckList '+forCheckList);
        System.debug('Statement Size  '+forCheckList.size());
        System.debug('Statement CommunityRole '+CommunityRole);
        System.debug('Statement salesOrg '+salesOrg);
        System.debug('Statement countryName '+countryName);
        
        // if(forCheckList.size()>0){
        
        cclIst =[Select Id,Country__c,Name,Credit_Information__c,Account_Statement__c,Outstanding_Ageing__c,Payment_Details__c,Outstandings__c
                 FROM Community_Configuration__c
                 Where (Distributor_Name__c =:recordId OR Visible_To_All__c= true)
                 AND RecordType.Name='Account Summary'
                 AND Sales_Org__c =:salesOrg
                 AND Country__c=:countryName
                 AND Community_User_Role__c =:CommunityRole
                 AND Active__c=true];
        //    }
        /* else{
System.debug('Statement outside Account chekcing');
cclIst =[Select Id,Name,Credit_Information__c,Account_Statement__c,Outstanding_Ageing__c,Payment_Details__c
FROM Community_Configuration__c
Where Sales_Org__c =:salesOrg
AND Country__c=:countryName
AND RecordType.Name='Account Summary'
AND Community_User_Role__c =:CommunityRole
AND Active__c=true];

}*/
        System.debug('cclIst in Account Community '+cclIst);
        
        return cclIst;
    }    
    
    
    
    //Credit_Information
    @AuraEnabled    
    public static  List <Credit_Info__c> getting_Credit_Information(){
        String recordId = '';    
        String userid = UserInfo.getUserId();
        String CommunityRole ='';
        String salesOrg ='';
        String countryName ='';
        User userObj = [SELECT Id,UserName,Community_Role__c,TimeZoneSidKey, 
                        AccountId,Account.Sales_Org_Code__c,Account.Sales_Org_Country__c 
                        FROM User WHERE Id=: userid];
        recordId = userObj.AccountId;
        
        List <Credit_Info__c> crdInfoList = new List<Credit_Info__c>();
        crdInfoList = [Select id,Name,Credit_Limit__c,Distributor__r.CurrencyIsoCode,
                       Used_Limit__c,Balance_Limit__c,
                       LastModifiedById,Sum_Open_Item__c,LastModifiedDate,
                       Percentage_Used__c  
                       FROM Credit_Info__c 
                       WHERE Distributor__c =:recordId];
        
        if(crdInfoList.size()>0){
            return crdInfoList;
        }else{
            return null;
        }
    }
    
    
    @AuraEnabled    
    public static  List <CreditInfoWrapper> getting_Credit_Information1(){
        String recordId = '';    
        String userid = UserInfo.getUserId();
        String CommunityRole ='';
        String salesOrg ='';
        String countryName ='';
        String salesOrgId ='';
        User userObj = [SELECT Id,UserName,Community_Role__c,TimeZoneSidKey, 
                        AccountId,Account.Sales_Org_Code__c,Account.Sales_Org_Country__c,
                        Account.Sales_Org__c 
                        FROM User WHERE Id=: userid];
         System.debug('userObj: '+userObj);
        recordId = userObj.AccountId;
        countryName =userObj.Account.Sales_Org_Country__c;
        salesOrgId = userObj.Account.Sales_Org__c;
        System.debug('countryName in commniyt account summary '+countryName);
        System.debug('salesOrgId in commniyt account summary '+salesOrgId);
        //Change by Swaranjeet(Grazitti) APPS-1315
        if(/*countryName=='Spain'||countryName=='Portugal'||countryName=='Colombia'||countryName=='Poland' ||*/ countryName=='Japan')
        {
            System.debug('countryName----1---'+countryName);
            
            List <Credit_Info__c> crdInfoList = new List<Credit_Info__c>();
            crdInfoList = [Select id,Name,Credit_Limit__c,Distributor__r.CurrencyIsoCode,
                           Used_Limit__c,Balance_Limit__c,
                           LastModifiedById,Sum_Open_Item__c,LastModifiedDate,
                           Percentage_Used__c  
                           FROM Credit_Info__c 
                           WHERE Distributor__c =:recordId
                           AND Sales_Org__c=:salesOrgId ORDER BY LastModifiedDate DESC LIMIT 1];
            
            System.debug('crdInfoList in account summery '+crdInfoList);
            
            List<Outstanding_Ageing__c> oagList = [SELECT id, OutstandingTotalGreaterthan90__c, Net_Outstanding__c  
                                                   FROM Outstanding_Ageing__c   
                                                   WHERE Customer_Code__c =:recordId ORDER BY LastModifiedDate DESC LIMIT 1];
            List<Payments__c> oaList = [SELECT id, Net_Overdue__c  FROM Payments__c     
                                        WHERE Customer_Name__c =:recordId ORDER BY LastModifiedDate DESC LIMIT 1]; 
            
            List<CreditInfoWrapper> CreditInfoWrapperList = new List<CreditInfoWrapper>();
            
            Decimal amount = ConnectAccSummaryController.gettingOverdue();
            Decimal paymentOutstanding;
            Decimal overdues;
            if(!oagList.isEmpty()){ 
                
                if(countryName=='Colombia'){
                    paymentOutstanding = oagList[0].Net_Outstanding__c*100;  
                }else{
                    paymentOutstanding = oagList[0].Net_Outstanding__c;      
                }
                
            } 
            if(!oaList.isEmpty()){  
                overdues = oaList[0].Net_Overdue__c; //oaList[0].OutstandingTotalGreaterthan90__c;  
            } 
            
            if(crdInfoList.size()>0){
                CreditInfoWrapper CreditInfoWrapperObj;
                for(Credit_Info__c tempobj :crdInfoList){
                    CreditInfoWrapperObj = new CreditInfoWrapper();
                    CreditInfoWrapperObj.Credit_Limit =tempobj.Credit_Limit__c;
                    CreditInfoWrapperObj.DistributorCurrencyIsoCode =tempobj.Distributor__r.CurrencyIsoCode;
                    CreditInfoWrapperObj.Used_Limit =tempobj.Used_Limit__c;
                    CreditInfoWrapperObj.Balance_Limit =tempobj.Balance_Limit__c;
                    CreditInfoWrapperObj.LastModifiedBy =tempobj.LastModifiedById;
                    
                    CreditInfoWrapperObj.Sum_Open_Item = paymentOutstanding;
                    
                    CreditInfoWrapperObj.LastModifiedDate = tempobj.LastModifiedDate;
                    CreditInfoWrapperObj.Percentage_Used =tempobj.Percentage_Used__c;
                    CreditInfoWrapperObj.overdue =  overdues;  
                    CreditInfoWrapperList.add(CreditInfoWrapperObj);
                    
                }
                System.debug('CreditInfoWrapperList '+CreditInfoWrapperList);
                System.debug('CreditInfoWrapperList size '+CreditInfoWrapperList.size());
                return CreditInfoWrapperList;
            }else{
                return null;
            }
        }else{
             System.debug('countryName----2---'+countryName);
            List<CreditInfoWrapper> CreditInfoList = ConnectAccSummaryController.getCreditSummary();
            return CreditInfoList;
        }
    }
    
    
    
    
    
    
    @AuraEnabled    
    public static  List <Account_Statement__c> account_Statement_Information(){
        //Change by Swaranjeet(Grazitti) APPS-1315
        /* String recordId = '';
String country = '';
String currentUserid = UserInfo.getUserId();
System.debug('userid '+currentUserid);
User userObject = [SELECT Id,UserName,TimeZoneSidKey, AccountId,Account.Sales_Org_Country__c FROM User WHERE Id=: currentUserid];
recordId = userObject.AccountId;
country = userObject.Account.Sales_Org_Country__c;
System.debug('countryss Name'+country);
List <Account_Statement__c> accStateList = new List<Account_Statement__c>();


if(country=='Spain'||country=='Portugal'||country=='Colombia'||country=='Poland'){

accStateList = [Select Id,Name,Opening_Balance__c,Credit__c,Debit__c,Closing_Balance__c,
Account__r.CurrencyIsoCode ,LastModifiedDate
FROM Account_Statement__c WHERE Account__c=:recordId];
System.debug('accStateList '+accStateList);
System.debug('accStateList size '+accStateList.size());

}
else{*/
        List <Account_Statement__c> accStateList = new List<Account_Statement__c>();
        String userid = UserInfo.getUserId();
        String sapCode ='';
        String salesOrgCode ='';
        String companyCode ='';
        String countryName ='';
        String sapUserId ='';
        User userObj = [SELECT Id,UserName,Community_Role__c,TimeZoneSidKey,Account.Sap_userId__c,Account.SAP_Code__c,Account.Company_Code__c,	
                        AccountId,Account.Sales_Org_Code__c,Account.Sales_Org_Country__c FROM User WHERE Id=: userid];
        System.debug(userObj);
        
        sapCode = userObj.Account.SAP_Code__c;
        
        
        salesOrgCode = userObj.Account.Sales_Org_Code__c;
        companyCode = userObj.Account.Company_Code__c;
        countryName =userObj.Account.Sales_Org_Country__c;
        //Change by Swaranjeet(Grazitti) APPS-1315
        if(userObj.Account.Sap_userId__c != null)
            sapUserId=userObj.Account.Sap_userId__c;
        if(sapUserId!=null){
            String username='';
            String password='';
            wrapOauthResponse wrapOauthResponseObj;
            String oathRes='';
            String responseAccesToken='';
            String tokenEndpoint='';
            Community_Endpoints__c tokenEndpointURL = [SELECT Id, Name, URL__c FROM Community_Endpoints__c where Name ='Token' limit 1];
            tokenEndpoint = tokenEndpointURL.URL__c;
            Community_Credentials__c credentials = [SELECT Id, Name, Username__c, Password__c FROM Community_Credentials__c where Name ='oauth credentials' limit 1];
            username = credentials.Username__c;
            password = credentials.Password__c;
            
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            req.setMethod('POST');           
            Blob headerValue = Blob.valueOf(username + ':' + password);
            String authorizationHeader = 'BASIC ' +EncodingUtil.base64Encode(headerValue);
            req.setHeader('Authorization', 'Basic ' +EncodingUtil.base64Encode(Blob.valueOf(username + ':' + password)));
            req.setEndpoint(tokenEndpoint);     
            HTTPResponse res;
            System.debug('req in test class '+req);
            
            
            res = http.send(req);
            
            System.debug(res.getBody());
            oathRes = res.getBody();
            
            wrapOauthResponseObj = (wrapOauthResponse)System.JSON.deserialize(oathRes, wrapOauthResponse.class);
            
            DateTime today=System.today();
            String todayStr=today.format('yyyy-MM-dd');
            String year1=String.valueOf(today.Year()-1);
            System.debug('year1--'+year1);
            String year2=String.valueOf(today.Year());
            System.debug('year2--'+year2);
            String month=String.valueOf(today.Month());
            System.debug('month--'+month);
            String customerLedgerEndpoint;
            Community_Endpoints__c customerLedgerEndpointURL = [SELECT Id, Name, URL__c FROM Community_Endpoints__c where Name ='Customer Ledger' limit 1];
            customerLedgerEndpoint = customerLedgerEndpointURL.URL__c;
            req.setEndpoint(customerLedgerEndpoint);
            req.setMethod('POST');
            req.setTimeout(120000);
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('Authorization', 'Bearer ' +wrapOauthResponseObj.access_token);
            req.setBody('{"companyCode": '+'"'+companyCode+'"'+',"customerCode": '+'"'+sapCode+'"'+',"fiscalYear": '+'"'+year1+'"'+',"FiscalYearFrom": "1","FiscalYearTo": "12","sapUserId": '+'"'+sapUserId+'"}');
            HttpResponse resp = http.send(req);
            wrapCustomerInfo wci = new wrapCustomerInfo();
            if(resp.getStatusCode() == 200) {
                Map<String, Object> reslt = (Map<String, Object>) JSON.deserializeUntyped(resp.getBody());
                Object customerInfo = (Object)reslt.get('customerInfo');
                String str = JSON.serialize(customerInfo);
                wci = (wrapCustomerInfo)System.JSON.deserialize(str, wrapCustomerInfo.class);
                System.debug('yes--'+wci.closingBalance);
            }
            
            req.setEndpoint(customerLedgerEndpoint);
            req.setMethod('POST');
            req.setTimeout(120000);
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('Authorization', 'Bearer ' +wrapOauthResponseObj.access_token);
            req.setBody('{"companyCode": '+'"'+companyCode+'"'+',"customerCode": '+'"'+sapCode+'"'+',"fiscalYear": '+'"'+year2+'"'+',"FiscalYearFrom": "1","FiscalYearTo": '+'"'+month+'"'+',"sapUserId": '+'"'+sapUserId+'"}');
            HttpResponse resp2 = http.send(req);
            Account_Statement__c accStatement = new Account_Statement__c();
            accStatement.Opening_Balance__c=0.0;
            accStatement.Debit__c=0.0;
            accStatement.Credit__c=0.0;
            accStatement.Closing_Balance__c=0.0;
            if(resp.getStatusCode() == 200) {
                Map<String, Object> reslt2 = (Map<String, Object>) JSON.deserializeUntyped(resp2.getBody());
                List<Object> LedgerInfo = (List<Object>)reslt2.get('ItemInfo');
                 Boolean storeData = false;
                 // GRZ(Swaranjeet) Added doc type checks country specific date: 12-09-2022
                    if((countryName =='Spain' || countryName =='Portugal') && wci.DocType != 'BR' && wci.DocType != 'ZT'){
                        storeData = true;
                    }else if(countryName == 'Colombia' && wci.DocType != 'BR'){
                        storeData = true;
                    }else{
                        if(wci.DocType != 'DG'){
                            storeData = true;
                        }
                    }
                if(storeData){
                if(wci.closingBalance!=''){
                    accStatement.Opening_Balance__c=decimal.valueOf(wci.closingBalance);
                    System.debug('accStatement.Opening_Balance__c--'+ accStatement.Opening_Balance__c);
                }else{
                    accStatement.Opening_Balance__c=0.0;
                }
                for(Integer i=1;i<LedgerInfo.size();i++){
                    String s = JSON.serialize(LedgerInfo[i]);
                    wrapLedgerInfo wli=(wrapLedgerInfo)System.JSON.deserialize(s, wrapLedgerInfo.class);
                    accStatement.Credit__c=accStatement.Credit__c+decimal.valueOf(wli.Credit);
                    accStatement.Debit__c=accStatement.Debit__c+decimal.valueOf(wli.Debit);
                }
                accStatement.Closing_Balance__c=accStatement.Opening_Balance__c - (accStatement.Credit__c + accStatement.Debit__c);
            }
            accStatement.LastModifiedDate=DateTime.now();
            accStatement.Country__c=countryName;
            System.debug('accStatement--'+accStatement);
            accStateList.add(accStatement);
            
           }
        }
        else{
            return null;
        }
        if(accStateList.size()>0){
            System.debug(accStateList);
            return accStateList;
        }else{
            return null;
        }
        
    }
    
    @AuraEnabled  
    //Change by Swaranjeet(Grazitti) APPS-1315
    public static  List <OutstandingAgeingWrapper> outstanding_Ageing_Information(){
        String recordId = '';    
        String userid = UserInfo.getUserId();
        System.debug('userid '+userid);
        User userObj = [SELECT Id,UserName,TimeZoneSidKey, AccountId, Account.Sales_Org_Country__c FROM User WHERE Id=: userid];
        recordId = userObj.AccountId;
        String countryName=userObj.Account.Sales_Org_Country__c;
        //Change by Swaranjeet(Grazitti) APPS-1315
        List<OutstandingAgeingWrapper> wrpList123 = new List<OutstandingAgeingWrapper>();
        List <Outstanding_Ageing__c> outstandingList = new List<Outstanding_Ageing__c>();
        // //Change by Swaranjeet(Grazitti) APPS-1315
        if(countryName=='Japan'){ 
            outstandingList =[Select id,OutstandingTotalGreaterthan90__c,Name,X0_30__c,X31_60__c,X61_75__c,X76_90__c,X211_Above__c,
                              Net_Outstanding__c,Customer_Code__r.CurrencyIsoCode,LastModifiedDate
                              From Outstanding_Ageing__c
                              WHERE Customer_Code__c=:recordId];
            OutstandingAgeingWrapper wrapObj = new OutstandingAgeingWrapper();
            wrapObj.o0_30 = outstandingList[0].X0_30__c;
            wrapObj.o31_60 = outstandingList[0].X31_60__c;
            wrapObj.o61_75 = outstandingList[0].X61_75__c;
            wrapObj.o76_90 = outstandingList[0].X76_90__c;
            
            wrapObj.Above_90=outstandingList[0].X211_Above__c;
            wrapObj.Net_Outstanding=outstandingList[0].Net_Outstanding__c;
            wrapObj.currencyKey123=outstandingList[0].Customer_Code__r.CurrencyIsoCode;
            
            wrapObj.LastModifiedDate = outstandingList[0].LastModifiedDate;
            wrpList123.add(wrapObj);
            
            return wrpList123;
            
        }else{
            List<OutstandingAgeingWrapper> OutstandingInfoList = ConnectAccSummaryController.getCustomerOutstandingSummary();
            System.debug('OutstandingInfoList--'+OutstandingInfoList); 
            
            return OutstandingInfoList; 
        }
        
    }
    
    
    //Payments__c
    @AuraEnabled    
    public static  List <Payments__c> collection_Information(){
        String recordId = '';    
        String userid = UserInfo.getUserId();
        System.debug('userid '+userid);
        User userObj = [SELECT Id,UserName,TimeZoneSidKey, AccountId FROM User WHERE Id=: userid];
        recordId = userObj.AccountId;
        list<Payments__c> PaymentsList = new List<Payments__c>();
        PaymentsList = [Select Id,Name,Bounce__c,X1_15__c,X16_30__c,X31_60__c,X61_90__c,X91_120__c,Total_Collectibles__c,Total_Collection__c,
                        Non_Forecasted_Collection__c,Forecasted_Collection__c,Amount__c,Amount_in_LC__c,Assignment__c,Net_Overdue__c,Posting_Date__c,
                        Status__c,Zone__r.Name,Special_GL_Ind__c,Customer_Name__r.CurrencyIsoCode,LastModifiedDate
                        from Payments__c
                        WHERE Customer_Name__c=:recordId];
        if(PaymentsList.size()>0){
            return PaymentsList;
        }else{
            return null;
        }
        
    }
  //Change by Swaranjeet(Grazitti) APPS-1315  
    /* @AuraEnabled    
public static  List <OutstandingAgeingWrapper> accountStatement(){
String recordId = '';    
String userid = UserInfo.getUserId();
System.debug('userid '+userid);
String countryName='';
User userObj = [SELECT Id,UserName,TimeZoneSidKey, 
AccountId,Account.Sales_Org_Code__c,Account.Sales_Org_Country__c 
FROM User WHERE Id=: userid];
recordId = userObj.AccountId;

countryName=userObj.Account.Sales_Org_Country__c;

List<Credit_Info__c> creInfoList = [Select Id,Name,Sum_Open_Item__c,LastModifiedDate 
From Credit_Info__c 
WHERE Distributor__c=:recordId LIMIT 1];


List<OutstandingAgeingWrapper> wrpList = new List<OutstandingAgeingWrapper>();

if(/*countryName=='Spain'||countryName=='Portugal'||countryName=='Colombia'||countryName=='Poland'||*//*countryName=='Japan'){ 
List<Outstanding_Ageing__c> oagList = [SELECT id, LastModifiedDate,OutstandingTotalGreaterthan90__c, Net_Outstanding__c  
FROM Outstanding_Ageing__c  
WHERE Customer_Code__c =:recordId LIMIT 1];

OutstandingAgeingWrapper wrapObj = new OutstandingAgeingWrapper();
if(countryName=='Colombia'){
wrapObj.Net_Outstanding = (oagList[0].Net_Outstanding__c)*100;

}else{
wrapObj.Net_Outstanding = oagList[0].Net_Outstanding__c;    
}

wrapObj.LastModifiedDate = oagList[0].LastModifiedDate;
wrpList.add(wrapObj);

return wrpList;
}else{
List<CreditInfoWrapper> CreditInfoList = ConnectAccSummaryController.getCreditSummary();
OutstandingAgeingWrapper wrapObj = new OutstandingAgeingWrapper();
if(CreditInfoList.size()>0){
wrapObj.Net_Outstanding=CreditInfoList[0].Sum_Open_Item;
wrapObj.LastModifiedDate=DateTime.now();      
}else{
wrapObj.Net_Outstanding=0.0;
wrapObj.LastModifiedDate=DateTime.now();
}
wrpList.add(wrapObj);
return wrpList; 
}

/* Decimal paymentOutstanding;
if(!oagList.isEmpty()){ 
paymentOutstanding = oagList[0].Net_Outstanding__c;  
} 
/*


list<Account_Statement__c> accounStatList = new List<Account_Statement__c>();
accounStatList =[Select Id,Name,Closing_Balance__c,LastModifiedDate from Account_Statement__c WHERE Account__c=:recordId ORDER BY LastModifiedDate DESC LIMIT 1];
if(accounStatList.size()>0){
return accounStatList;
}else{
return null;    
}*/
    
    // return null;
    
    // }
    
    @AuraEnabled    
    public static Decimal gettingOverdue(){
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
        return totalAmount;
        
    }
    
    
    @AuraEnabled    
    public static String gettingUrlAddress(){
        list<Community_Url_Configuration__c> csList= new List<Community_Url_Configuration__c>();
        String returnUrl='';
        csList=[SELECT Id, Name, URL__c FROM Community_Url_Configuration__c WHERE  Name ='Distributors Community URL' ];
        if(csList.size()>0){
            returnUrl=csList[0].URL__c;
        }
        return returnUrl;
    }
    
    @AuraEnabled 
    public static List<CreditInfoWrapper> getCreditSummary(){
       //Change by Swaranjeet(Grazitti) APPS-1315
          List<CreditInfoWrapper>  CIWrap =new List<CreditInfoWrapper>();
        String userid = UserInfo.getUserId();
        String sapCode ='';
        String salesOrgCode ='';
        String companyCode ='';
        String countryName ='';
        String distributionCode ='';
        String divisionCode ='';
          String sapUserId='';
        User userObj = [SELECT Id,UserName,Community_Role__c,TimeZoneSidKey,Account.SAP_Code__c,Account.Sap_userId__c,Account.Company_Code__c,Account.Distribution_Channnel_Code__c,Account.Division_Code__c,	
                        AccountId,Account.Sales_Org_Code__c,Account.Sales_Org_Country__c FROM User WHERE Id=: userid];
        System.debug(userObj);     
        
        sapCode = userObj.Account.SAP_Code__c;
       
        
        System.debug('sapCode--'+sapCode);
        salesOrgCode = userObj.Account.Sales_Org_Code__c;
        companyCode = userObj.Account.Company_Code__c;
        System.debug('companyCode--'+companyCode);
        countryName =userObj.Account.Sales_Org_Country__c;  
        distributionCode =userObj.Account.Distribution_Channnel_Code__c;
        System.debug('distributionCode--'+distributionCode);
        divisionCode =userObj.Account.Division_Code__c;
        if(divisionCode == null){
            divisionCode ='';
        }
         //Change by Swaranjeet(Grazitti) APPS-1315
        List<String> creditControlList = System.Label.Grz_CreditControlMapping.split(',');
            Map<String,String> salesOrgToCreditControlMap = new Map<String,String>();
            for(String st : creditControlList){
                salesOrgToCreditControlMap.put(st.substringBefore('-').trim(), st.substringAfter('-').trim());
            }
        if(userObj.Account.Sap_userId__c != null)
            sapUserId=userObj.Account.Sap_userId__c;
        if(sapUserId!=null){
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
        req.setTimeout(120000);           
        Blob headerValue = Blob.valueOf(username + ':' + password);
        String authorizationHeader = 'BASIC ' +EncodingUtil.base64Encode(headerValue);
        req.setHeader('Authorization', 'Basic ' +EncodingUtil.base64Encode(Blob.valueOf(username + ':' + password)));
        req.setEndpoint(tokenEndpoint);     
        HTTPResponse res;
        res = http.send(req);
        System.debug(res.getBody());
        oathRes = res.getBody();
        wrapOauthResponseObj = (wrapOauthResponse)System.JSON.deserialize(oathRes, wrapOauthResponse.class);
        
        String creditSummaryEndpoint;
        Community_Endpoints__c creditSummaryEndpointURL = [SELECT Id, Name, URL__c FROM Community_Endpoints__c where Name ='Credit Summary' limit 1];
        creditSummaryEndpoint = creditSummaryEndpointURL.URL__c;
        req.setEndpoint(creditSummaryEndpoint);
        req.setMethod('POST');
        req.setTimeout(120000);
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Authorization', 'Bearer ' +wrapOauthResponseObj.access_token);
        System.debug('para--'+companyCode+'para1'+sapCode+'para2'+sapUserId);
        req.setBody('{"companyCode": '+'"'+companyCode+'"'+',"customerCode": '+'"'+sapCode+'"'+',"sapUserId": '+'"'+sapUserId+'"}');
        HttpResponse response = http.send(req);
        ciRes=response.getBody();
        System.debug('ciRes---'+response);
        System.debug('ciRes---'+ciRes);
        Map<String, object> results = (Map<String, object>)JSON.deserializeUntyped(ciRes);
        System.debug('error---'+results);
        
        String customerOutstandingEndpoint;
        Community_Endpoints__c customerOutstandingEndpointURL = [SELECT Id, Name, URL__c FROM Community_Endpoints__c where Name ='Customer Outstanding' limit 1];
        customerOutstandingEndpoint = customerOutstandingEndpointURL.URL__c;
        req.setEndpoint(customerOutstandingEndpoint);
        req.setMethod('POST');
        req.setTimeout(120000);
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Authorization', 'Bearer ' +wrapOauthResponseObj.access_token);
        System.debug('sapCode'+sapCode);
        req.setBody('{"sapUserId": '+'"'+sapUserId+'","customerNumber": '+'"'+sapCode+'"'+',"companyCode": '+'"'+companyCode+'"'+',"salesOrg": '+'"'+salesOrgCode+'"'+',"distrChan": '+'"'+distributionCode+'"'+',"division": '+'"'+divisionCode+'"'+'}');
        HttpResponse resp = http.send(req);
        System.debug('resp---'+resp.getBody());
            //Change by Swaranjeet(Grazitti) APPS-1315
            outstandingwrapper1 data = new outstandingwrapper1();
        Item outstanding = new Item();
            System.debug('resp---123'+resp.getStatusCode());
        if(resp.getStatusCode() == 200) {
            System.debug(resp.getBody());
            data = (outstandingwrapper1)System.JSON.deserialize(resp.getBody(), outstandingwrapper1.class);
            outstanding = data.item;
            System.debug('outstanding--'+outstanding);
        }
      
        if(!Test.isRunningTest()){
            List<Object> CInfo = (List<Object>)results.get('CreditInfo'); 
             System.debug('CInfo--'+CInfo);
            WrapCreditInfo CinfoNew = new WrapCreditInfo();
            
            CreditInfoWrapper CIObj = new CreditInfoWrapper();
            if(CInfo.size()>0){
                //Change by Swaranjeet(Grazitti) APPS-1315
                  System.debug('CInfo.size--'+CInfo.size());
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
               
                String s = JSON.serialize(CinfoNew);
                WrapCreditInfo wci= (WrapCreditInfo)System.JSON.deserialize(s, WrapCreditInfo.class);
                System.debug('data==='+wci.company_code);
                CIObj.Credit_Limit=decimal.valueOf(wci.CreditLimit);
                CIObj.Used_Limit=decimal.valueOf(wci.CreditExposure);
                CIObj.Balance_Limit=decimal.valueOf(wci.BalanceLimit);
                CIObj.Sum_Open_Item=decimal.valueOf(outstanding.netOutstanding);
                CIObj.Percentage_Used=decimal.valueOf(wci.Percentage);
                CIObj.DistributorCurrencyIsoCode=outstanding.currencyKey;
            }
            CIWrap.add(CIObj);
        }
        }
        else{
            return null;
        }
        //Change by Swaranjeet(Grazitti) APPS-1315
        return CIWrap;
    }
    
    /*Begin New Method*/
    //Change by Swaranjeet(Grazitti) APPS-1315
    @AuraEnabled 
    public static List<OutstandingAgeingWrapper> getCustomerOutstandingSummary(){
          List<OutstandingAgeingWrapper>  CIWrap =new List<OutstandingAgeingWrapper>();
        String userid = UserInfo.getUserId();
        String sapCode ='';
        String salesOrgCode ='';
        String companyCode ='';
        String countryName ='';
        String distributionCode ='';
        String divisionCode ='';
         String sapUserId ='';
        User userObj = [SELECT Id,UserName,Community_Role__c,TimeZoneSidKey,Account.SAP_Code__c,Account.Sap_userId__c,Account.Company_Code__c,Account.Distribution_Channnel_Code__c,Account.Division_Code__c,	
                        AccountId,Account.Sales_Org_Code__c,Account.Sales_Org_Country__c FROM User WHERE Id=: userid];
        System.debug(userObj);  
        
        sapCode = userObj.Account.SAP_Code__c;
        
        
        System.debug('sapCode--'+sapCode);
        salesOrgCode = userObj.Account.Sales_Org_Code__c;
        companyCode = userObj.Account.Company_Code__c;
        System.debug('companyCode--'+companyCode);
        countryName =userObj.Account.Sales_Org_Country__c;  
        distributionCode =userObj.Account.Distribution_Channnel_Code__c;
        System.debug('distributionCode--'+distributionCode);
        divisionCode =userObj.Account.Division_Code__c;
       
        if(divisionCode == null){
            divisionCode ='';
        }
        System.debug('divisionCode--'+divisionCode);
         if(userObj.Account.Sap_userId__c != null)
           sapUserId=userObj.Account.Sap_userId__c;
        if(sapUserId!=null){
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
        req.setTimeout(120000);           
        Blob headerValue = Blob.valueOf(username + ':' + password);
        String authorizationHeader = 'BASIC ' +EncodingUtil.base64Encode(headerValue);
        req.setHeader('Authorization', 'Basic ' +EncodingUtil.base64Encode(Blob.valueOf(username + ':' + password)));
        req.setEndpoint(tokenEndpoint);     
        HTTPResponse res;
        res = http.send(req);
        System.debug(res.getBody());
        oathRes = res.getBody();
        wrapOauthResponseObj = (wrapOauthResponse)System.JSON.deserialize(oathRes, wrapOauthResponse.class);
        String customerOutstandingEndpoint;
        Community_Endpoints__c customerOutstandingEndpointURL = [SELECT Id, Name, URL__c FROM Community_Endpoints__c where Name ='Customer Outstanding' limit 1];
        customerOutstandingEndpoint = customerOutstandingEndpointURL.URL__c;
        req.setEndpoint(customerOutstandingEndpoint);
        req.setMethod('POST');
        req.setTimeout(120000);
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Authorization', 'Bearer ' +wrapOauthResponseObj.access_token);
        System.debug('sapCode'+sapCode);
        req.setBody('{"sapUserId": '+'"'+sapUserId+'","customerNumber": '+'"'+sapCode+'"'+',"companyCode": '+'"'+companyCode+'"'+',"salesOrg": '+'"'+salesOrgCode+'"'+',"distrChan": '+'"'+distributionCode+'"'+',"division": '+'"'+divisionCode+'"'+'}');
        HttpResponse resp = http.send(req);
        System.debug('resp---'+resp.getBody());
        outstandingwrapper1 data = new outstandingwrapper1();
            Item outstanding = new Item();
            
        if(resp.getStatusCode() == 200) {
            System.debug(resp.getBody());
            data = (outstandingwrapper1)System.JSON.deserialize(resp.getBody(), outstandingwrapper1.class);
            outstanding = data.item;
           // System.debug('outstanding--'+outstanding);
            //System.debug('outstanding--currencyKey'+outstanding.currencyKey);
        }
      
        if(!Test.isRunningTest()){
            
            OutstandingAgeingWrapper CIObj = new OutstandingAgeingWrapper();
            CIObj.o0_30=decimal.valueOf(outstanding.bucket1);
            system.debug('CIObj.o0_30---'+CIObj.o0_30);
            CIObj.o31_60=decimal.valueOf(outstanding.bucket2);
            CIObj.o61_75=decimal.valueOf(outstanding.bucket3);
            CIObj.o76_90=decimal.valueOf(outstanding.bucket4);
            CIObj.Above_90=decimal.valueOf(outstanding.bucket5)+ decimal.valueOf(outstanding.bucket6) + decimal.valueOf(outstanding.bucket7) + decimal.valueOf(outstanding.bucket8) + decimal.valueOf(outstanding.bucket9);
           // CIObj.Above_90= decimal.valueOf(outstanding.bucket9);
            CIObj.Net_Outstanding=decimal.valueOf(outstanding.netOutstanding);
            CIObj.currencyKey123=outstanding.currencyKey;
            
            CIWrap.add(CIObj);
        }
        }
        else{
            return null;
        }
        System.debug('CIWrap--'+CIWrap);
        return CIWrap;
    }
    /*End New Method*/
    
    
    
    
    
    
    public class CreditInfoWrapper{
        @AuraEnabled
        public Decimal Credit_Limit{get;set;}
        @AuraEnabled
        public String DistributorCurrencyIsoCode{get;set;}
        @AuraEnabled
        public Decimal Used_Limit{get;set;}
        @AuraEnabled
        public Decimal Balance_Limit{get;set;}
        @AuraEnabled
        public String LastModifiedBy{get;set;}
        @AuraEnabled
        public Decimal Sum_Open_Item{get;set;}
        @AuraEnabled
        public DateTime LastModifiedDate{get;set;}
        @AuraEnabled
        public Decimal Percentage_Used{get;set;}
        @AuraEnabled
        public Decimal overdue{get;set;}
        
        public CreditInfoWrapper(){
            Credit_Limit = 0.0;
            DistributorCurrencyIsoCode='';
            Used_Limit= 0.0;
            Balance_Limit= 0.0;
            LastModifiedBy = '';
            Sum_Open_Item = 0.0;
            LastModifiedDate = DateTime.now();
            Percentage_Used = 0.0;
            overdue = 0.0;
        }
    }
    
    public class OutstandingAgeingWrapper{
        //Change by Swaranjeet(Grazitti) APPS-1315
        @AuraEnabled
        public Decimal o0_30{get;set;}
        @AuraEnabled
        public Decimal o31_60{get;set;}
        @AuraEnabled
        public Decimal o61_75{get;set;}
        @AuraEnabled
        public Decimal o76_90{get;set;}
        @AuraEnabled
        public Decimal Above_90{get;set;}
        @AuraEnabled
        public Decimal Net_Outstanding{get;set;}
        @AuraEnabled
        public Datetime LastModifiedDate{get;set;}
        @AuraEnabled
        public String currencyKey123{get;set;}
        
        public OutstandingAgeingWrapper(){
            //Change by Swaranjeet(Grazitti) APPS-1315
            o0_30=0.0;
            o31_60=0.0;
            o61_75=0.0;
            o76_90=0.0;
            Above_90=0.0;
            currencyKey123 = '';
            Net_Outstanding=0.0;
            LastModifiedDate=DateTime.now();
        }
        
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
        public String CreditLimit{get;set;}
        @AuraEnabled
        public String CreditExposure{get;set;}
        @AuraEnabled
        public String Percentage{get;set;}
        @AuraEnabled
        public String BalanceLimit{get;set;}
        
        public WrapCreditInfo(){
            company_code='';
            credit_control='';
            sales_organization='';
            customer_number='';
            name='';
            Customer_group='';
            Customer_Credit_Group='';
            clean_limit='';
            Line_limit='';
            Total_receivables='';
            Credit_exposure='';
            CreditLimit='';
            CreditExposure='';    
            Percentage='';    
            BalanceLimit='';    
            
        }
        
    }
    //Change by Swaranjeet(Grazitti) APPS-1315
    public class outstandingwrapper1{
         @AuraEnabled
        public Item item{get;set;}
    }
    //Change by Swaranjeet(Grazitti) APPS-1315
    public class Item {
         @AuraEnabled
        public String customerNumber{get;set;}
        @AuraEnabled
        public String custName{get;set;}
        @AuraEnabled
        public String bucket1{get;set;}
        @AuraEnabled
        public String bucket2{get;set;}
        @AuraEnabled
        public String bucket3{get;set;}
        @AuraEnabled
        public String bucket4{get;set;}
        @AuraEnabled
        public String bucket5{get;set;}
        @AuraEnabled
        public String bucket6{get;set;}
        @AuraEnabled
        public String bucket7{get;set;}
        @AuraEnabled
        public String bucket8{get;set;}
        @AuraEnabled
        public String bucket9{get;set;}
        
       
        
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
         //Change by Swaranjeet(Grazitti) APPS-1315
     /*   public wrapOutstanding(){
             customerNumber = '';
             custName = '';
            bucket1='0.0';
            bucket2='0.0';
            bucket3='0.0';
            bucket4='0.0';
            bucket5='0.0';
            bucket6='0.0';
            bucket7='0.0';
            bucket8='0.0';
            bucket9='0.0';
           
           
            totalOutstanding = '';
            unadjustedReceipts = '';
            unadjustedCredits = '';
            netOutstanding = '0.0';
            currencyKey = '';
        }*/
        
        
    }
    
    public class wrapCustomerInfo {
        @AuraEnabled
        public String closingBalance{get;set;}
        @AuraEnabled
        public String DocType{get;set;}
        
        public wrapCustomerInfo(){
            closingBalance='';
             DocType='';
        }
    }
    
    public class wrapLedgerInfo {
        @AuraEnabled
        public String Credit{get;set;}
        @AuraEnabled
        public String Debit{get;set;}
       
        
        public wrapLedgerInfo(){
            Credit='';
            Debit='';
           
        }
    }
    
}