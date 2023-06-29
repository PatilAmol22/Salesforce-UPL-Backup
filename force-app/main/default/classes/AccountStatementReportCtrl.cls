public without sharing class AccountStatementReportCtrl {
    public List<Community_Configuration__c> ccList{get;set;} 
    public Account CompanyInfo {get;set;}
    public String todaysDate {get;set;}
    public String currencySign {get;set;}
    public String currentcountry {get;set;}
    public wrapAccountStatement wrapAS {get;set;}

    public AccountStatementReportCtrl() {
        DateTime todaysDate1 = DateTime.now();
        String todaysDateStr = todaysDate1.format('dd-MM-yyyy');
        todaysDate = todaysDateStr;
        currencySign ='';
        currentcountry = '';
    }

    public void displayAccountStatement(){
        System.debug('in action Reprot');
        String recordId = '';    
        String currentUserid = UserInfo.getUserId();
        String CommunityRole ='';
        String salesOrg ='';
        String country ='';
        User userObject = [SELECT Id,UserName,Community_Role__c,TimeZoneSidKey, AccountId,Account.Sales_Org_Code__c,
                        Account.Sales_Org_Country__c FROM User WHERE Id=: currentUserid];
        recordId = userObject.AccountId;
        salesOrg = userObject.Account.Sales_Org_Code__c;
        country =userObject.Account.Sales_Org_Country__c;
        CommunityRole= userObject.Community_Role__c;
        currentcountry = userObject.Account.Sales_Org_Country__c;
        if(country=='Japan'){
            currencySign ='JPY';
        }
        //Change by Swaranjeet(Grazitti) APPS-1315
        else if(country=='Turkey'){
            currencySign ='TRY';
        }
        else if(country=='Colombia'){
            currencySign = 'COP ';
        }
        else if(country=='Poland'){
            currencySign = 'PLN ';
        }
        else if(country=='Spain'){
            currencySign = 'EUR ';
        }
        else if(country=='Portugal'){
            currencySign = 'EUR ';
        }
       
        List<Community_Configuration__c> forCheckList = new List<Community_Configuration__c>();
        forCheckList = [Select Id from Community_Configuration__c
                        WHERE Distributor_Name__c=:RecordId];
        
        //if(forCheckList.size()>0){
        System.debug('Inside Account record');
        ccList = new List<Community_Configuration__c>();
        ccList =[Select Id,Name,Company_Name__c,Company_Address__c,Company_Contact_Number__c,
                 Company_Logo__c
                 FROM Community_Configuration__c
                 Where (Distributor_Name__c =:recordId OR Visible_to_All__c = TRUE)
                 AND RecordType.Name='General Setting'
                 AND Sales_Org__c =:salesOrg
                 AND Country__c=:country
                 AND Community_User_Role__c =:CommunityRole 
                 AND Active__c=true ];


        CompanyInfo = [SELECT Id, Name, CurrencyIsoCode, SAP_Code__c From Account WHERE Id=:recordId LIMIT 1];
        CompanyInfo.Name=CompanyInfo.Name.replace('ł','l').replace('ę','e').replace('ą','a').replace('ś','s').replace('ń','n').replace('ó','o').replace('ż','z').replace('ć','c').replace('ź','z').replace('Ę','E').replace('Ć','C');

        String userid = UserInfo.getUserId();
            String sapCode ='';
            String salesOrgCode ='';
            String companyCode ='';
            String countryName ='';
        	 String sapUserId='';
            User userObj = [SELECT Id,UserName,Community_Role__c,Account.Sap_userId__c,TimeZoneSidKey,Account.SAP_Code__c,Account.Company_Code__c,	
                            AccountId,Account.Sales_Org_Code__c,Account.Sales_Org_Country__c FROM User WHERE Id=: userid];
            System.debug(userObj);
       
            sapCode = userObj.Account.SAP_Code__c;
            salesOrgCode = userObj.Account.Sales_Org_Code__c;
            companyCode = userObj.Account.Company_Code__c;
            countryName =userObj.Account.Sales_Org_Country__c;
        //Change by Swaranjeet(Grazitti) APPS-1315
       
        if(userObj.Account.Sap_userId__c != null)
			 sapUserId = userObj.Account.Sap_userId__c;
        
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
            res = http.send(req);
            System.debug(res.getBody());
            oathRes = res.getBody();
            wrapOauthResponseObj = (wrapOauthResponse)System.JSON.deserialize(oathRes, wrapOauthResponse.class);

            DateTime today=System.today();
            String todayStr=today.format('yyyy-MM-dd');
            String year1=String.valueOf(today.Year()-1);
            String year2=String.valueOf(today.Year());
            String month=String.valueOf(today.Month());

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
                System.debug(wci.closingBalance);
            }

            req.setEndpoint(customerLedgerEndpoint);
            req.setMethod('POST');
            req.setTimeout(120000);
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('Authorization', 'Bearer ' +wrapOauthResponseObj.access_token);
            req.setBody('{"companyCode": '+'"'+companyCode+'"'+',"customerCode": '+'"'+sapCode+'"'+',"fiscalYear": '+'"'+year2+'"'+',"FiscalYearFrom": "1","FiscalYearTo": '+'"'+month+'"'+',"sapUserId": '+'"'+sapUserId+'"}');
            HttpResponse resp2 = http.send(req);
             wrapAS = new wrapAccountStatement();
            wrapAS.openingBalance = '0.0';
            wrapAS.credit = '0.0';
            wrapAS.debit = '0.0';
            wrapAS.closingBalance = '0.0';
            if(resp.getStatusCode() == 200) {
                Map<String, Object> reslt2 = (Map<String, Object>) JSON.deserializeUntyped(resp2.getBody());
                List<Object> LedgerInfo = (List<Object>)reslt2.get('ItemInfo');
                  System.debug('LedgerInfo--'+LedgerInfo);
                 System.debug('LedgerInfo--'+LedgerInfo.size());
                if(wci.closingBalance!=''){
                    wrapAS.openingBalance=(wci.closingBalance);
                }else{
                    wrapAS.openingBalance='0.0';
                }
                for(Integer i=1;i<LedgerInfo.size();i++){
                    String s = JSON.serialize(LedgerInfo[i]);
                    wrapLedgerInfo wli=(wrapLedgerInfo)System.JSON.deserialize(s, wrapLedgerInfo.class);
                    decimal credit12=decimal.valueOf(wrapAS.credit)+decimal.valueOf(wli.Credit);
                    wrapAS.credit= String.valueOf(credit12);
                    decimal debit12=decimal.valueOf(wrapAS.debit)+decimal.valueOf(wli.Debit);
                    wrapAS.debit = String.valueOf(debit12);
                }
                System.debug('credit--'+wrapAS.credit);
                 System.debug('debit--'+wrapAS.debit);
                decimal closingBalance12 = decimal.valueOf(wrapAS.openingBalance) - (decimal.valueOf(wrapAS.credit) + decimal.valueOf(wrapAS.debit));
                wrapAS.closingBalance =String.valueOf(closingBalance12);
            }
              //Change by Swaranjeet(Grazitti) APPS-1315
            if(country=='Turkey' || country=='Colombia'  || country=='Poland' || country=='Spain'  || country=='Portugal'){
                wrapAS.openingBalance = String.valueOf(wrapAS.openingBalance).replace('.',',');
                wrapAS.credit = String.valueOf(wrapAS.credit).replace('.',',');
                wrapAS.debit = String.valueOf(wrapAS.debit).replace('.',',');
                wrapAS.closingBalance = String.valueOf(wrapAS.closingBalance).replace('.',',');
            }else{
                wrapAS.openingBalance = String.valueOf(wrapAS.openingBalance);
                wrapAS.credit = String.valueOf(wrapAS.credit);
                wrapAS.debit = String.valueOf(wrapAS.debit);
                wrapAS.closingBalance = String.valueOf(wrapAS.closingBalance);
            }
          }
        else{
            System.debug('Data not found');
        }

    }

    public class wrapAccountStatement{
        public String closingBalance {get;set;}
        public String credit {get;set;}
        public String debit {get;set;}
        public String openingBalance {get;set;}

        public wrapAccountStatement(){
            closingBalance = '0.0';
            credit = '0.0';
            debit = '0.0';
            openingBalance = '0.0';
        }
    }


    public class wrapOauthResponse{
        public String access_token{get;set;}
        public String token_type{get;set;}
        public String expires_in{get;set;}
        public String scope{get;set;}        
    }


    public class wrapCustomerInfo {
        public String closingBalance{get;set;}
    }

    public class wrapLedgerInfo {
        public String Credit{get;set;}
        public String Debit{get;set;}
	}


}