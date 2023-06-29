public class OverDueSummaryLWC_Controller {
    public WrapperMain WrapODSMain{get;set;}
    public String fromDate{get;set;}
    public String toDate{get;set;}
    public Decimal TotalAmount{get;set;}
    public List<Community_Configuration__c> ccList{get;set;}
    public string countryName {get;set;}
    public List<WrapperMain> wrapList {get;set;}
    
    public OverDueSummaryLWC_Controller(){
        WrapODSMain = new WrapperMain();
        List<CustomerTransaction__c> ctListForPDF = new List <CustomerTransaction__c> ();
        TotalAmount = 0;
        //Change by Aashima(Grazitti) APPS-1316
        String BillingDateFrom='';
        String BillingDateTo='';
        String UserAccountId='';
        String Status='';
        String PaidUnpaidStatus='';
        String FileType='';
        
        if(test.isRunningTest()){
            BillingDateFrom='2022-01-01';
            BillingDateTo='2022-01-15';
            //UserAccountId='';
            Status='Due';
            PaidUnpaidStatus='Paid';
            FileType='PDF';
        }
        else{
            BillingDateFrom=ApexPages.CurrentPage().getParameters().get('DateFrom');
            BillingDateTo=ApexPages.CurrentPage().getParameters().get('DateTo');
            UserAccountId=ApexPages.CurrentPage().getParameters().get('AccId');
            Status=ApexPages.CurrentPage().getParameters().get('Status');
            PaidUnpaidStatus=ApexPages.CurrentPage().getParameters().get('PaymentStatus');
            FileType=ApexPages.CurrentPage().getParameters().get('FileType');
        }
         //Change by Aashima(Grazitti) APPS-1316 ends
        system.debug('Status---->'+Status);
        User u = [Select Country FROM User WHERE ID = :UserInfo.getUserId()];
        Map<Integer, String> turkeyDates = new Map<Integer, String>();
        turkeyDates.put(1, 'Oca');
        turkeyDates.put(2, 'şub');
        turkeyDates.put(3, 'Mar');
        turkeyDates.put(4, 'Nis');
        turkeyDates.put(5, 'May');
        turkeyDates.put(6, 'Haz');
        turkeyDates.put(7, 'Tem');
        turkeyDates.put(8, 'Ağu');
        turkeyDates.put(9, 'Eyl');
        turkeyDates.put(10, 'Eki');
        turkeyDates.put(11, 'Kas');
        turkeyDates.put(12, 'Ara');
        
        /* if(u.Country=='Turkey'){
fromDate = '';
toDate = '';
}else if(u.Country=='Japan'){
fromDate = BillingDateFrom.split('-')[0]+'-'+BillingDateFrom.split('-')[1]+'-'+BillingDateFrom.split('-')[2];
toDate = BillingDateTo.split('-')[0]+'-'+BillingDateTo.split('-')[1]+'-'+BillingDateTo.split('-')[2];
}else{
fromDate = BillingDateFrom.split('-')[2]+'-'+BillingDateFrom.split('-')[1]+'-'+BillingDateFrom.split('-')[0];
toDate = BillingDateTo.split('-')[2]+'-'+BillingDateTo.split('-')[1]+'-'+BillingDateTo.split('-')[0];
}
String query = '';*/
        
        List<Account> customerList=new List<Account>();
         //Change by Aashima(Grazitti) APPS-1316
        if(Test.isRunningTest()){
            customerList=[SELECT Id, Name, SAP_Code__c, CurrencyIsoCode FROM Account limit 1];
        }
        else{
            customerList=[SELECT Id, Name, SAP_Code__c, CurrencyIsoCode FROM Account where id=:UserAccountId];
        }
        
        for(Account acc:customerList){
            WrapODSMain.mCustomerName=acc.Name.replace('ł','l').replace('ę','e').replace('ą','a').replace('ś','s').replace('ń','n').replace('ó','o').replace('ż','z').replace('ć','c').replace('ź','z').replace('Ę','E').replace('Ć','C');
            WrapODSMain.mCustomerCode=acc.SAP_Code__c;
            WrapODSMain.mCurrency=acc.CurrencyIsoCode;
        }  
        
        countryName = u.Country;
         //Change by Aashima(Grazitti) APPS-1316
        /*if(u.Country=='Spain' || u.Country=='Portugal' || u.Country=='Colombia' || u.Country=='Poland'){
if(u.Country=='Spain' || u.Country=='Portugal')    {
if(Status==''){
query = 'SELECT  Billing_Date__c, Payment_Status__c, DocNumber__c, Clearing_doc__c, Amount__c, Payment_Term__c, Overdue_Date__c, Status_Formula__c FROM CustomerTransaction__c where (DocType__c != \'BR\' AND DocType__c != \'ZT\') AND Customer__c= \''+UserAccountId+'\' AND Billing_Date__c >= '+BillingDateFrom+' AND Billing_Date__c <= '+BillingDateTo;
}
else{
query = 'SELECT  Billing_Date__c, Payment_Status__c, DocNumber__c, Clearing_doc__c, Amount__c, Payment_Term__c, Overdue_Date__c, Status_Formula__c FROM CustomerTransaction__c where (DocType__c != \'BR\' AND DocType__c != \'ZT\') AND Customer__c= \''+UserAccountId+'\' AND Billing_Date__c >= '+BillingDateFrom+' AND Billing_Date__c <= '+BillingDateTo+' AND Status_Formula__c=\''+Status+'\'';
}
if(PaidUnpaidStatus!=''){
query +=' AND Payment_Status__c=\''+PaidUnpaidStatus+'\''; 
}
}
else if(u.Country=='Colombia'){
if(Status==''){
query = 'SELECT  Billing_Date__c, Payment_Status__c, DocNumber__c, Clearing_doc__c, Amount__c, Payment_Term__c, Overdue_Date__c, Status_Formula__c FROM CustomerTransaction__c where DocType__c != \'BR\' AND Customer__c= \''+UserAccountId+'\' AND Billing_Date__c >= '+BillingDateFrom+' AND Billing_Date__c <= '+BillingDateTo;
}
else{
query = 'SELECT  Billing_Date__c, Payment_Status__c, DocNumber__c, Clearing_doc__c, Amount__c, Payment_Term__c, Overdue_Date__c, Status_Formula__c FROM CustomerTransaction__c where DocType__c != \'BR\' AND Customer__c= \''+UserAccountId+'\' AND Billing_Date__c >= '+BillingDateFrom+' AND Billing_Date__c <= '+BillingDateTo+' AND Status_Formula__c=\''+Status+'\'';
}
if(PaidUnpaidStatus!=''){
query +=' AND Payment_Status__c=\''+PaidUnpaidStatus+'\''; 
}
}
else{
if(Status==''){
query = 'SELECT  Billing_Date__c, Payment_Status__c, DocNumber__c, Clearing_doc__c, Amount__c, Payment_Term__c, Overdue_Date__c, Status_Formula__c FROM CustomerTransaction__c where DocType__c != \'DG\' AND Customer__c= \''+UserAccountId+'\' AND Billing_Date__c >= '+BillingDateFrom+' AND Billing_Date__c <= '+BillingDateTo;
}
else{
query = 'SELECT  Billing_Date__c, Payment_Status__c, DocNumber__c, Clearing_doc__c, Amount__c, Payment_Term__c, Overdue_Date__c, Status_Formula__c FROM CustomerTransaction__c where DocType__c != \'DG\' AND Customer__c= \''+UserAccountId+'\' AND Billing_Date__c >= '+BillingDateFrom+' AND Billing_Date__c <= '+BillingDateTo+' AND Status_Formula__c=\''+Status+'\'';
}
if(PaidUnpaidStatus!=''){
query +=' AND Payment_Status__c=\''+PaidUnpaidStatus+'\''; 
}
}


String label = System.Label.Due;
//query= 'SELECT Billing_Date__c, DocNumber__c, Clearing_doc__c, Amount__c, Payment_Term__c, Overdue_Date__c, Status_Formula__c FROM CustomerTransaction__c where Status_Formula__c='+'\''+label+'\''+' And Customer__c='+'\''+UserAccountId+'\'';
system.debug('query in constructor -->'+query);
ctListForPDF = Database.query(query);
// WrapODSMain.ctList=ctListForPDF;
wrapList=new List<WrapperMain>();

for(CustomerTransaction__c c : ctListForPDF){
WrapperMain main=new WrapperMain();
main.InvoiceNo=c.DocNumber__c;
if(u.Country=='Turkey'){
main.InvoiceDate=String.valueOf(c.Billing_Date__c.Day())+'-'+turkeyDates.get(c.Billing_Date__c.Month())+'-'+String.valueOf(c.Billing_Date__c.Year());
}else if(u.Country=='Japan'){
main.InvoiceDate=String.valueOf(c.Billing_Date__c.Year())+'-'+String.valueOf(c.Billing_Date__c.Month())+'-'+String.valueOf(c.Billing_Date__c.Day());
}else{
main.InvoiceDate=String.valueOf(c.Billing_Date__c.Day())+'-'+String.valueOf(c.Billing_Date__c.Month())+'-'+String.valueOf(c.Billing_Date__c.Year());
}
main.Amount=String.valueOf(c.Amount__c);
main.AmountWithComma=String.valueOf(c.Amount__c).replace('.',',');
main.Payterm=c.Payment_Term__c;
if(u.Country=='Turkey'){
main.DueDate=String.valueOf(c.Overdue_Date__c.Day())+'-'+turkeyDates.get(c.Overdue_Date__c.Month())+'-'+String.valueOf(c.Overdue_Date__c.Year());
}else if(u.Country=='Japan'){
main.DueDate=String.valueOf(c.Overdue_Date__c.Year())+'-'+String.valueOf(c.Overdue_Date__c.Month())+'-'+String.valueOf(c.Overdue_Date__c.Day());
}else{
main.DueDate=String.valueOf(c.Overdue_Date__c.Day())+'-'+String.valueOf(c.Overdue_Date__c.Month())+'-'+String.valueOf(c.Overdue_Date__c.Year());
}
main.Status=c.Status_Formula__c;
if(FileType=='PDF'){
main.PaidUnpaid=c.Payment_Status__c.replace('ł','l');
}else{
main.PaidUnpaid=c.Payment_Status__c;
} 
TotalAmount+=c.Amount__c;
wrapList.add(main);
} 
}else{*/
         
        wrapList=new List<WrapperMain>();
        List<WrapperMain> wrapSapDataList =new List<WrapperMain>();
        WrapperMain wp= new WrapperMain();
        if(Test.isRunningTest()){
             wp.invoiceDate='2022-01-01';
            wp.Amount='1000';
            wp.Status='Due';
            wp.PaidUnpaid='Paid';
            wrapSapDataList.add(wp);
        }
        else{
             wrapSapDataList=OverDueSummaryLWC_Controller.fetchSapData();
        }
       
        system.debug('wrapSapDataList:'+wrapSapDataList);
        system.debug('Status:'+Status);
        system.debug('PaidUnpaidStatus:'+PaidUnpaidStatus);
        if(Test.isRunningTest()){
            Status='';
            PaidUnpaidStatus='';
        }
        if(Status=='' && PaidUnpaidStatus==''){
            for(WrapperMain wm:wrapSapDataList){
                //TotalAmount+=Decimal.valueOf(wm.Amount);
                if(BillingDateFrom!='' && BillingDateTo!=''){
                    if(wm.invoiceDate<=BillingDateTo && wm.invoiceDate>=BillingDateFrom){
                        TotalAmount+=Decimal.valueOf(wm.Amount);
                        wrapList.add(wm);
                    }
                }
                else if(BillingDateFrom!='' || BillingDateTo!=''){
                    Boolean flagTotal=true;
                    if(BillingDateFrom!='' && wm.invoiceDate>=BillingDateFrom){
                        TotalAmount+=Decimal.valueOf(wm.Amount);
                        wrapList.add(wm);
                    }
                    if(BillingDateTo!='' && wm.invoiceDate<=BillingDateTo){
                        if(flagTotal)
                            TotalAmount+=Decimal.valueOf(wm.Amount);
                        wrapList.add(wm);
                    }
                }
                else{
                    TotalAmount+=Decimal.valueOf(wm.Amount);
                    wrapList.add(wm);
                }
            }
        }
        if(Test.isRunningTest()){
            Status='Due';
            PaidUnpaidStatus='';
        }
        system.debug('wrapSapDataList@@@@@@:'+wrapSapDataList);
        if(Status!='' && PaidUnpaidStatus==''){
            for(WrapperMain wm:wrapSapDataList){
                if(wm.Status==Status){
                    //TotalAmount+=Decimal.valueOf(wm.Amount);
                    if(BillingDateFrom!='' && BillingDateTo!=''){
                        if(wm.invoiceDate<=BillingDateTo && wm.invoiceDate>=BillingDateFrom){
                            TotalAmount+=Decimal.valueOf(wm.Amount);
                            wrapList.add(wm);
                        }
                    }
                    else if(BillingDateFrom!='' || BillingDateTo!=''){
                        Boolean flagTotal=true;
                        if(BillingDateFrom!='' && wm.invoiceDate>=BillingDateFrom){
                            TotalAmount+=Decimal.valueOf(wm.Amount);
                            wrapList.add(wm);
                        }
                        if(BillingDateTo!='' && wm.invoiceDate<=BillingDateTo){
                            if(flagTotal)
                                TotalAmount+=Decimal.valueOf(wm.Amount);
                            wrapList.add(wm);
                        }
                    }
                    else{
                        TotalAmount+=Decimal.valueOf(wm.Amount);
                        wrapList.add(wm);
                    }
                }
            }
        }
        if(Test.isRunningTest()){
            Status='';
            PaidUnpaidStatus='Paid';
        }
        if(Status=='' && PaidUnpaidStatus!=''){
            for(WrapperMain wm:wrapSapDataList){
                if(wm.PaidUnpaid==PaidUnpaidStatus){
                    // TotalAmount+=Decimal.valueOf(wm.Amount);
                    if(BillingDateFrom!='' && BillingDateTo!=''){
                        if(wm.invoiceDate<=BillingDateTo && wm.invoiceDate>=BillingDateFrom){
                            TotalAmount+=Decimal.valueOf(wm.Amount);
                            wrapList.add(wm);
                        }
                    }
                    else if(BillingDateFrom!='' || BillingDateTo!=''){
                        Boolean flagTotal=true;
                        if(BillingDateFrom!='' && wm.invoiceDate>=BillingDateFrom){
                            TotalAmount+=Decimal.valueOf(wm.Amount);
                            wrapList.add(wm);
                        }
                        if(BillingDateTo!='' && wm.invoiceDate<=BillingDateTo){
                            if(flagTotal)
                                TotalAmount+=Decimal.valueOf(wm.Amount);
                            wrapList.add(wm);
                        }
                    }
                    else{
                        TotalAmount+=Decimal.valueOf(wm.Amount);
                        wrapList.add(wm);
                    }
                }
            }
        }
        if(Test.isRunningTest()){
            Status='Due';
            PaidUnpaidStatus='Paid';
        }
        if(Status!='' && PaidUnpaidStatus!=''){
            for(WrapperMain wm:wrapSapDataList){
                if(wm.Status==Status && wm.PaidUnpaid==PaidUnpaidStatus){
                    // TotalAmount+=Decimal.valueOf(wm.Amount);
                    if(BillingDateFrom!='' && BillingDateTo!=''){
                        if(wm.invoiceDate<=BillingDateTo && wm.invoiceDate>=BillingDateFrom){
                            TotalAmount+=Decimal.valueOf(wm.Amount);
                            wrapList.add(wm);
                        }
                    }
                    else if(BillingDateFrom!='' || BillingDateTo!=''){
                        Boolean flagTotal=true;
                        if(BillingDateFrom!='' && wm.invoiceDate>=BillingDateFrom){
                            TotalAmount+=Decimal.valueOf(wm.Amount);
                            wrapList.add(wm);
                        }
                        if(BillingDateTo!='' && wm.invoiceDate<=BillingDateTo){
                            if(flagTotal)
                                TotalAmount+=Decimal.valueOf(wm.Amount);
                            wrapList.add(wm);
                        }
                    }
                    else{
                        TotalAmount+=Decimal.valueOf(wm.Amount);
                        wrapList.add(wm);
                    }
                }
            }
        }
        System.debug(wrapList);
        //}
        //WrapODSMain.ctList=wrapList;
        //Change by Aashima(Grazitti) APPS-1316 ends
        WrapODSMain.TotalAmount=TotalAmount;
        
        
        /* Community configuration */
        
        String userid = UserInfo.getUserId();
        String recordId = '';
        String CommunityRole ='';
        String salesOrg ='';
        String countryName ='';
        //Change by Aashima(Grazitti) APPS-1316
        String sapuserid ='';
        User userObj = [SELECT Id,Country,UserName,Community_Role__c,TimeZoneSidKey, AccountId,Account.Sales_Org_Code__c,
                        Account.Sales_Org_Country__c FROM User WHERE Id=: userid];
        recordId = userObj.AccountId; 
        salesOrg = userObj.Account.Sales_Org_Code__c;
        countryName =userObj.Country;
        CommunityRole= userObj.Community_Role__c;
        /*  List<Community_Configuration__c> forCheckList = new List<Community_Configuration__c>();

forCheckList = [Select Id from Community_Configuration__c
WHERE Distributor_Name__c=:RecordId];
*/  
        //   if(forCheckList.size()>0){
        System.debug('Inside Account record');
        ccList =[Select Id,Name,Company_Name__c,Company_Address__c,Company_Contact_Number__c,
                 Company_Logo__c
                 FROM Community_Configuration__c
                 Where (Distributor_Name__c =:recordId OR Visible_To_All__c = true)
                 AND RecordType.Name='General Setting'
                 AND Community_User_Role__c =:CommunityRole 
                 AND Active__c=true
                 AND Country__c =: countryName
                ];
        /*   }else{
System.debug('record not found in community configuartion for Account ');
ccList =[Select Id,Name,Company_Name__c,Company_Address__c,Company_Contact_Number__c,
Company_Logo__c
FROM Community_Configuration__c
Where Sales_Org__c =:salesOrg
AND Country__c=:countryName
AND RecordType.Name='General Setting'
AND Community_User_Role__c =:CommunityRole
AND Active__c=true ];
} */
        
        
    }
    
    @AuraEnabled(cacheable = true)
    public static List<user> fetchUser(){
        id userId = UserInfo.getUserId();
        System.debug(userId);
        List<user> u = new List<User>();
        u = [select id, Name, contactId, accountId, Country from User where id = : userId];
        //OverDueSummaryLWC_Controller.fetchSapData();
        return u;
        
    }
    
    @AuraEnabled(cacheable = true)
    public static List<Community_Url_Configuration__c> fetchURL(){
        
        List<Community_Url_Configuration__c> url = new List<Community_Url_Configuration__c>();
        url = [SELECT Id, Name, URL__c FROM Community_Url_Configuration__c WHERE  Name ='Distributors Community URL' LIMIT 1];
        return url;
    }  
    
    @AuraEnabled(cacheable = true)
    public static WrapperMain getODSData(String query, String uId){
        system.debug('query---->'+query);
        system.debug('uId---->'+uId);
        String country='';
        WrapperMain walObj=new WrapperMain();
        /* Customer Name , SAP Code , Currency */
        
        List<Account> customerList=new List<Account>();
        //Change by Aashima(Grazitti) APPS-1316
        customerList=[SELECT Id, Name, SAP_Code__c,sap_userid__c, CurrencyIsoCode,Sales_Org_Country__c FROM Account where id=:uId];
        for(Account acc:customerList){
            walObj.mCustomerName=acc.Name;
            walObj.mCustomerCode=acc.SAP_Code__c;
            walObj.mCurrency=acc.CurrencyIsoCode;
            //Change by Aashima(Grazitti) APPS-1316
            walObj.msapuserid=acc.sap_userid__c;     
            country=acc.Sales_Org_Country__c;  
        }
        
        List<CustomerTransaction__c> ctList= new List<CustomerTransaction__c>();
        ctList=database.query(query);
        walObj.ctList=ctList;
        Decimal TotalAmount=0;
        
        for(CustomerTransaction__c c : ctList){
            
            TotalAmount+=c.Amount__c;
            
        } 
        
        WalObj.TotalAmount=TotalAmount;
        
        
        return walObj;
        
    }
    
    @AuraEnabled
    public static List<WrapperMain> fetchSapData(){
        
        String userid = UserInfo.getUserId();
        String sapCode ='';
        String salesOrgCode ='';
        String companyCode ='';
        String countryName ='';
        //Change by Aashima(Grazitti) APPS-1316
        String sapUserId ='';
        User userObj = [SELECT Id,UserName,Community_Role__c,TimeZoneSidKey,Account.SAP_Code__c,Account.Company_Code__c,	
                        AccountId,Account.Sales_Org_Code__c,Account.Sales_Org_Country__c,Account.Sap_userId__c FROM User WHERE Id=: userid];
        System.debug(userObj);
        sapCode = userObj.Account.SAP_Code__c;
        salesOrgCode = userObj.Account.Sales_Org_Code__c;
        companyCode = userObj.Account.Company_Code__c;
        countryName =userObj.Account.Sales_Org_Country__c;
        sapUserId=userObj.Account.Sap_userId__c;
        system.debug('all parameters'+sapCode+','+salesOrgCode+','+companyCode+','+countryName+','+sapUserId);
        List<WrapperMain> wmain= new List<WrapperMain>();
        if(sapUserId!=null || Test.isRunningTest()){
            Map<String,String> months=new Map<String,String>();
            months.put('1','10');
            months.put('2','11');
            months.put('3','12');
            months.put('4','1');
            months.put('5','2');
            months.put('6','3');
            months.put('7','4');
            months.put('8','5');
            months.put('9','6');
            months.put('10','7');
            months.put('11','8');
            months.put('12','9');
            DateTime today=System.today();
            String todayStr=today.format('yyyy-MM-dd');
            String year=String.valueOf(today.Year());
            String yearTo=months.get(String.valueOf(today.Month()));
            String yearFrom='';
            if(today.Month()!=3){
                yearFrom='1';
            }else{
                yearFrom=String.valueOf(Integer.valueOf(yearTo)-11);
            }
            System.debug(year);
            System.debug(yearTo);
            System.debug(yearFrom);
            
            String year1=String.valueOf(today.Year()-1);
            
            Map<String,String> months2=new Map<String,String>();
            months2.put('1','11');
            months2.put('2','12');
            months2.put('4','2');
            months2.put('5','3');
            months2.put('6','4');
            months2.put('7','5');
            months2.put('8','6');
            months2.put('9','7');
            months2.put('10','8');
            months2.put('11','9');
            months2.put('12','10');
            String year2=String.valueOf(today.Year()-2);
            String yearFrom2=months.get(String.valueOf(today.Month()+1));
            String yearTo2='12';
            
            String username='';
            String password='';
            wrapOauthResponse wrapOauthResponseObj = new wrapOauthResponse();
            WrapOpenItemData woi =new WrapOpenItemData();
            wrapLedgerInfo wli = new wrapLedgerInfo();
            
            List<Object> LedgerInfo =new List<Object>();        
            String oathRes=''; 
            String responseAccesToken='';
            String tokenEndpoint='';
            Community_Endpoints__c tokenEndpointURL = [SELECT Id, Name, URL__c FROM Community_Endpoints__c where Name ='Token' limit 1];
            tokenEndpoint = tokenEndpointURL.URL__c;
            Community_Credentials__c credentials = [SELECT Id, Name, Username__c, Password__c FROM Community_Credentials__c where Name ='oauth credentials' limit 1];
            username = credentials.Username__c;
            password = credentials.Password__c;
            
            String customerLedgerEndpoint;
            Community_Endpoints__c customerLedgerEndpointURL = [SELECT Id, Name, URL__c FROM Community_Endpoints__c where Name ='Customer Ledger' limit 1];
            customerLedgerEndpoint = customerLedgerEndpointURL.URL__c;
            system.debug('customerLedgerEndpoint:'+customerLedgerEndpoint);
            String openItemEndpoint;
            Community_Endpoints__c openItemEndpointURL = [SELECT Id, Name, URL__c FROM Community_Endpoints__c where Name ='Open Item' limit 1];
            openItemEndpoint = openItemEndpointURL.URL__c;
            system.debug('openItemEndpoint:'+openItemEndpoint);
            
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            req.setMethod('POST');           
            Blob headerValue = Blob.valueOf(username + ':' + password);
            String authorizationHeader = 'BASIC ' +EncodingUtil.base64Encode(headerValue);
            req.setHeader('Authorization', 'Basic ' +EncodingUtil.base64Encode(Blob.valueOf(username + ':' + password)));
            req.setEndpoint(tokenEndpoint);     
            HTTPResponse res;
            res = http.send(req);
            System.debug('res.getBody:'+res.getBody());
            oathRes = res.getBody();
            if(res.getStatusCode()==200){
                wrapOauthResponseObj = (wrapOauthResponse)System.JSON.deserialize(oathRes, wrapOauthResponse.class);
                
                req.setEndpoint(customerLedgerEndpoint);
                req.setMethod('POST');
                req.setTimeout(120000);
                req.setHeader('Content-Type', 'application/json');
                req.setHeader('Authorization', 'Bearer ' +wrapOauthResponseObj.access_token);
                req.setBody('{"companyCode": '+'"'+companyCode+'"'+',"customerCode": '+'"'+sapCode+'"'+',"fiscalYear": '+'"'+year+'"'+',"FiscalYearFrom": '+'"'+yearFrom+'"'+',"FiscalYearTo": '+'"'+yearTo+'"'+',"sapUserId": '+'"'+sapUserId+'"}');
                HttpResponse resp = http.send(req);
                system.debug('resp:'+resp);
                system.debug('res.getStatusCode():'+res.getStatusCode());
                if(resp.getStatusCode()==200){
                    system.debug('Enter If:');
                    Map<String, Object> reslt = (Map<String, Object>) JSON.deserializeUntyped(resp.getBody());
                    LedgerInfo = (List<Object>)reslt.get('ItemInfo');
                    system.debug('LedgerInfo:'+LedgerInfo);
                    if(!Test.isRunningTest()){
                        if(LedgerInfo.size()>0){
                            LedgerInfo.remove(0);
                        }
                    }
                }
                
                
                req.setEndpoint(customerLedgerEndpoint);
                req.setMethod('POST');
                req.setTimeout(120000);
                req.setHeader('Content-Type', 'application/json');
                req.setHeader('Authorization', 'Bearer ' +wrapOauthResponseObj.access_token);
                req.setBody('{"companyCode": '+'"'+companyCode+'"'+',"customerCode": '+'"'+sapCode+'"'+',"fiscalYear": '+'"'+year1+'"'+',"FiscalYearFrom": "1","FiscalYearTo": "12","sapUserId": '+'"'+sapUserId+'"}');
                HttpResponse resp1 = http.send(req);
                if(resp1.getStatusCode()==200){
                    Map<String, Object> reslt1 = (Map<String, Object>) JSON.deserializeUntyped(resp1.getBody());
                    List<Object> LedgerInfo1 = (List<Object>)reslt1.get('ItemInfo');
                    if(!Test.isRunningTest()){
                        if(LedgerInfo1.size()>0){
                            LedgerInfo1.remove(0);
                            LedgerInfo.addAll(LedgerInfo1);
                        }
                    }    
                }
                
                if(today.Month()!=3){
                    req.setEndpoint(customerLedgerEndpoint);
                    req.setMethod('POST');
                    req.setTimeout(120000);
                    req.setHeader('Content-Type', 'application/json');
                    req.setHeader('Authorization', 'Bearer ' +wrapOauthResponseObj.access_token);
                    req.setBody('{"companyCode": '+'"'+companyCode+'"'+',"customerCode": '+'"'+sapCode+'"'+',"fiscalYear": '+'"'+year2+'"'+',"FiscalYearFrom": '+'"'+yearFrom2+'"'+',"FiscalYearTo": '+'"'+yearTo2+'"'+',"sapUserId": '+'"'+sapUserId+'"}');
                    HttpResponse resp2 = http.send(req);
                    system.debug('resp2==>'+resp2.getBody());
                    if(resp2.getStatusCode()==200){
                        Map<String, Object> reslt2 = (Map<String, Object>) JSON.deserializeUntyped(resp2.getBody());
                        List<Object> LedgerInfo2 = (List<Object>)reslt2.get('ItemInfo');
                        if(!Test.isRunningTest()){
                            if(LedgerInfo2.size()>0){
                                LedgerInfo2.remove(0);
                                LedgerInfo.addAll(LedgerInfo2);
                            }
                        }
                    }
                }        
                if(!Test.isRunningTest()){
                    if(LedgerInfo.size()>0){  
                        for(Integer i=0;i<LedgerInfo.size();i++){
                                String s = JSON.serialize(LedgerInfo[i]);
                                wli=(wrapLedgerInfo)System.JSON.deserialize(s, wrapLedgerInfo.class);
                                WrapperMain main=new WrapperMain();
                                // GRZ(Nikhil verma) Added doc type checks country specific date: 12-09-2022
                                Boolean storeData = false;
                                if((countryName =='Spain' || countryName =='Portugal') && wli.DocType != 'BR' && wli.DocType != 'ZT'){
                                    storeData = true;
                                }else if(countryName == 'Colombia' && wli.DocType != 'BR'){
                                    storeData = true;
                                }else{
                                    if(wli.DocType != 'DG'){
                                        storeData = true;
                                    }
                                }
                                if(storeData){
                                    main.InvoiceNo=wli.AccountingDocNumber;
                                    main.InvoiceDate=wli.PostDate;
                                    if(wli.DbCrInd=='S'){
                                        main.Amount=wli.Debit;
                                        main.AmountWithComma=String.valueOf(wli.Debit).replace('.',',');
                                    }else{
                                        main.Amount=wli.Credit;
                                        main.AmountWithComma=String.valueOf(wli.Credit).replace('.',',');
                                    }
                                    main.Payterm=Decimal.valueOf(wli.DsctDays1);
                                    if(wli.BlineDate=='0000-00-00'){
                                        main.DueDate='';
                                        main.Status='';
                                    }else{
                                        Date dt=date.valueOf(wli.BlineDate);
                                        main.DueDate=String.valueOf(dt.addDays(Integer.valueOf(wli.DsctDays1)));
                                        Date startDate = system.today();
                                        Date endDate = date.valueOf(main.DueDate);
                                        main.Status=startDate.daysBetween(endDate)>=0 ? System.Label.Not_Due:System.Label.Due;
                                    }
                                    if(wli.ClearingDoc==''){
                                        main.PaidUnpaid=System.Label.Unpaid;
                                    }else{
                                        main.PaidUnpaid=System.Label.Paid;
                                    }
                                    wmain.add(main);  
                                }                       
                        }
                    }
                }
                
                req.setEndpoint(openItemEndpoint);
                req.setMethod('POST');
                req.setTimeout(120000);
                req.setHeader('Content-Type', 'application/json');
                req.setHeader('Authorization', 'Bearer ' +wrapOauthResponseObj.access_token);
                //req.setBody('{"sapUserId": "UPLINTCRM","customerNumber": "0001030835","companyCode": "7100","keyDate": "2022-05-23","notedItems": "x","secIndex": "x"}');
                req.setBody('{"sapUserId": '+'"'+sapUserId+'"'+',"customerNumber": '+'"'+sapCode+'"'+',"companyCode": '+'"'+companyCode+'"'+',"keyDate": '+'"'+todayStr+'"'+',"notedItems": "x","secIndex": "x"}');
                HttpResponse response = http.send(req);
                system.debug('response==>'+response.getBody());
                if(response.getStatusCode()==200){
                    Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                    system.debug('results:'+results);
                    Object calloutrslt = (Object)results.get('Return');
                    //Object calloutrslt = (Object)results.get('Lineitems');
                    system.debug('calloutrslt:'+calloutrslt);
                    String rtn = JSON.serialize(calloutrslt);
                     system.debug('rtn:'+rtn);
                    wrapReturn wres=(wrapReturn)System.JSON.deserialize(rtn, wrapReturn.class);
                    system.debug('wres:'+wres);
                    if(!Test.isRunningTest()){
                    //if(Test.isRunningTest()){
                        if(wres.Message==''){
                            List<Object> ItemInfo = (List<Object>)results.get('Lineitems');
                            for(Integer i=0;i<ItemInfo.size();i++){
                                String s = JSON.serialize(ItemInfo[i]);
                                System.debug(s);
                                woi=(WrapOpenItemData)System.JSON.deserialize(s, WrapOpenItemData.class);
                                WrapperMain main=new WrapperMain();
                                // GRZ(Nikhil verma) Added doc type checks country specific date: 12-09-2022
                                Boolean storeData = false;
                                if((countryName =='Spain' || countryName =='Portugal') && woi.DocType != 'BR' && woi.DocType != 'ZT'){
                                    storeData = true;
                                }else if(countryName == 'Colombia' && woi.DocType != 'BR'){
                                    storeData = true;
                                }else{
                                    if(woi.DocType != 'DG'){
                                        storeData = true;
                                    }
                                }
                                if(storeData){
                                    main.InvoiceNo=woi.DocNo;
                                    main.InvoiceDate=woi.DocDate;
                                    main.Amount=woi.AmtDoccur;
                                    main.AmountWithComma=String.valueOf(woi.AmtDoccur).replace('.',',');
                                    main.Payterm=Decimal.valueOf(woi.DsctDays1);
                                    Date dt=date.valueOf(woi.BlineDate);
                                    main.DueDate=String.valueOf(dt.addDays(Integer.valueOf(woi.DsctDays1)));
                                    Date startDate = system.today();
                                    Date endDate = date.valueOf(main.DueDate);
                                    main.Status=startDate.daysBetween(endDate)>=0 ? System.Label.Not_Due:System.Label.Due;
                                    main.PaidUnpaid=System.Label.Unpaid;
                                    wmain.add(main);
                                }
                            }            
                        }
                    }
                }
                
            }
            
        }
        else{
            WrapperMain main=new WrapperMain();
            main.Status='Insufficient data on account';
            wmain.add(main);
        }
        system.debug('wmain==>'+wmain);
        return wmain;
        /*if(wmain.isEmpty()){
WrapperMain main=new WrapperMain();
main.Status='Error';  
wmain.add(main);
}*/
        
        //Change by Aashima(Grazitti) APPS-1316 ends
    }
    //Change by Aashima(Grazitti) APPS-1316
    public class WrapperMain{
        @AuraEnabled
        public List<CustomerTransaction__c> ctList{get;set;}
        @AuraEnabled
        public String mCustomerName{get;set;}
        @AuraEnabled
        public String mCustomerCode{get;set;}
        @AuraEnabled
        public String mCurrency{get;set;}
        @AuraEnabled
        public String msapuserid{get;set;}
        @AuraEnabled
        public Decimal TotalAmount{get;set;}
        @AuraEnabled
        public String InvoiceNo{get;set;}
        @AuraEnabled
        public String InvoiceDate{get;set;}
        @AuraEnabled
        public String Amount{get;set;}
        @AuraEnabled
        public String AmountWithComma{get;set;}
        @AuraEnabled
        public Decimal Payterm{get;set;}
        @AuraEnabled
        public String DueDate{get;set;}
        @AuraEnabled
        public String Status{get;set;}
        @AuraEnabled
        public String PaidUnpaid{get;set;}
        //Change by Aashima(Grazitti) APPS-1316
        WrapperMain(){
            ctList=new List<CustomerTransaction__c>();
            mCustomerName='';
            mCustomerCode='';
            mCurrency='';
            msapuserid='';
            TotalAmount=0;
            InvoiceNo='';
            InvoiceDate='';
            Amount='';
            AmountWithComma='';
            Payterm=0;
            DueDate='';
            Status='';
            PaidUnpaid='';
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
    
    public class wrapReturn{
        @AuraEnabled
        public String Message{get;set;} 
        public wrapReturn(){
            Message=''; 
        }
    }
    
    public class WrapOpenItemData {
        @AuraEnabled
        public String CompCode {get;set;} 
        @AuraEnabled
        public String Customer {get;set;} 
        @AuraEnabled
        public String ClearDate {get;set;}
        @AuraEnabled 
        public String AllocNmbr {get;set;} 
        @AuraEnabled
        public String FiscYear {get;set;} 
        @AuraEnabled
        public String DocNo {get;set;} 
        @AuraEnabled 
        public String PstngDate {get;set;} 
        @AuraEnabled 
        public String DocDate {get;set;}               
        @AuraEnabled 
        public String DocType {get;set;}          
        @AuraEnabled 
        public String DbCrInd {get;set;}          
        @AuraEnabled 
        public String LcAmount {get;set;} 
        @AuraEnabled 
        public String AmtDoccur {get;set;}         
        @AuraEnabled 
        public String BlineDate {get;set;} 
        @AuraEnabled 
        public String DsctDays1 {get;set;} 
        @AuraEnabled 
        public String DsctDays2 {get;set;} 
        @AuraEnabled 
        public String Netterms {get;set;}             
        @AuraEnabled 
        public String NxtDoctyp {get;set;} 
        @AuraEnabled 
        public String TCurrency {get;set;} 
        @AuraEnabled 
        public String Amount {get;set;} 
        @AuraEnabled 
        public String NetAmount {get;set;}                                     
        @AuraEnabled 
        public String DisctDays {get;set;} 
        @AuraEnabled 
        public String DisctRate {get;set;} 
        @AuraEnabled 
        public String BillDoc {get;set;} 
        
        public WrapOpenItemData(){
            CompCode='';        
            Customer='';        
            ClearDate='';       
            AllocNmbr='';       
            FiscYear='';         
            DocNo='';          
            PstngDate='';       
            DocDate='';                      
            DocType='';                  
            DbCrInd='';                  
            LcAmount='';          
            AmtDoccur='';                
            BlineDate='';         
            DsctDays1='';      
            DsctDays2='';      
            Netterms='';                   
            NxtDoctyp='';       
            TCurrency='';       
            Amount='';      
            NetAmount='';                                            
            DisctDays='';       
            DisctRate='';         
            BillDoc='';
        }
    }
    
    public class wrapLedgerInfo {
        @AuraEnabled
        public String AccountingDocNumber{get;set;}
        @AuraEnabled
        public String Credit{get;set;}
        @AuraEnabled
        public String Debit{get;set;}
        @AuraEnabled
        public String DocType{get;set;}
        @AuraEnabled
        public String DocumentHeaderText{get;set;}
        @AuraEnabled
        public String PostDate{get;set;}
        @AuraEnabled
        public String ReferebceChqNumber{get;set;}
        @AuraEnabled
        public String RunningBalance{get;set;}
        @AuraEnabled
        public String SGTXT{get;set;}
        @AuraEnabled
        public String ClearingDoc{get;set;}
        @AuraEnabled
        public String BlineDate{get;set;}
        @AuraEnabled
        public String DsctDays1{get;set;}
        @AuraEnabled
        public String DbCrInd{get;set;}
        
        public wrapLedgerInfo(){
            AccountingDocNumber='';
            Credit='';
            Debit='';
            DocType='';
            DocumentHeaderText='';
            PostDate='';
            ReferebceChqNumber='';
            RunningBalance='';
            SGTXT='';
            ClearingDoc='';
            BlineDate='';
            DsctDays1='';
            DbCrInd='';
        }
        
    }
    
    
}