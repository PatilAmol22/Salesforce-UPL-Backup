/*
* Name: AccountOnBoardingService
* Created On: 31 March 2018
* Author: Ketan Khatri (ketan.khatri@skinternational.com)
* Description: Helper Class to pass Distributor Onboarding Data to Service using REST API.
* Supporting Class: AccountOnBoardingService_Test (Test Class)
* Last Stable Back up : AccountOnBoardingService V1.4
*/

global class AccountOnBoardingService {
    
    public static HttpResponse OauthResponse;
    public static HttpResponse response;
    public static Account Acnt;
    
    
    @InvocableMethod
    public static void callOnboardingService(List<ID> AccountID){
        
        System.debug('AccountID --> '+AccountID);
        Acnt = new Account();
        List<Account> AccList = [SELECT Id, Name,ApprovalStatus__c,Callout_Set__c,Error_Message__c,lastModifiedBy.LastName,MDO_Code__c  FROM Account
                                 WHERE Id=:AccountID LIMIT 1];
        Acnt = AccList[0];
        // String ProfileName =[select id,Name,ProfileId from User where id=:Acnt.LastModifiedBy.Name].ProfileId;
        // system.debug('ProfileName'+ProfileName);
        System.debug('Acnt.MDO_Code__c in checking '+Acnt.MDO_Code__c);
        
        //Callout true to prevent recursive call of future method & Created_By_vs_Modified_By__c to update only when user manually updates the account
        if(Acnt.MDO_Code__c=='' && Acnt.ApprovalStatus__c =='Open' && Acnt.Callout_Set__c == false && //Acnt.lastModifiedBy.LastName!='Ltd.' &&
           (Acnt.Error_Message__c != 'SUCCESS' || Acnt.Error_Message__c == Null ||  Acnt.Error_Message__c =='') || Test.isRunningTest())
        {   System.debug('Acnt.lastModifiedBy.LastName --> '+Acnt.lastModifiedBy.LastName); 
         pushAccount(Acnt.Id);
         System.debug(' Acnt  --> '+Acnt);
        }
        
    }
    
    @future(callout=true)
    webservice static void pushAccount(String recordId){
        System.debug('Inside PushAccount --> '+recordId);
        String MDO_Code;
        String status;
        String msg;
        String createdBy;
        
        Map<String, String> langCode= new map<String, String>();
        langCode.put('EN','E');
        langCode.put('JA','JA'); 
        langCode.put('ZH','ZH');
        langCode.put('ES','ES'); 
        langCode.put('FR','FR');
        langCode.put('PT','PT'); 
        
        try{
            
            //Querying required fields for mapping    
            Account Acc = [SELECT Id, Name, Last_Name__c, FirstName, RecordTypeId, BillingStreet, BillingCity,TaxNumber1__c,SFDC_Customer_Code__c,
                           TaxNumber2__c,ContactName__c,
                           BillingState, BillingPostalCode, BillingCountry, Phone, Mobile__c, CurrencyIsoCode,Customer_Classification1__c,
                           ApprovalStatus__c, Billing_Street_1__c, Billing_Street_2__c, Billing_Street_3__c,
                           Billing_Street_4__c, Billing_Street_5__c, Cust_Group__c, Distribution_Channel__c,Distribution_Channel__r.Distribution_Channel_Code__c,
                           Division__c,Division__r.Division_Code__c, PreviousMasterRecordNumber__c,Email__c, PAN_Number__c, Payment_Terms__c, PriceGroupCode__c,PriceGroupCode__r.PG_Code__c, Region__c,
                           RegionalManager__c, Region__r.RegionCode__c, Sales_Org_Code__c, Sales_Org__r.Sales_Org_Code__c, Salutation__c, Territory_Code__c,
                           Territory_Distributor__c, ZonalHead__c, Zone_Distributor__c, DealerDistributorShortName__c,
                           Tax_Number_3__c, DealerDistributorShortNamec1__c, Billing_Street_6__c, LanguageKey__c, 
                           CountryKey__c, Addressnotes__c, State_Tax_Structure__c, State_Tax_Structure__r.State_Code__c , Accountassignmentgroup__c,
                           CustomerAccountGroup__c, AuthorizationGroupSalesoffice__c,
                           Groupkey__c, ShippingConditions__c, SalesOffice__c, ReconciliationAccountinGeneralLedger__c, KeyforSorting__c,
                           ActiveCode__c, IndicatorRecordPaymentHistory__c, SalesGroupAFGFCGVSG__c, Customergroup__c, Pricegroup__c,
                           Pricingprocedureassignedtothiscusto__c, CustomerStatisticsGroup__c, DeliveryPriority__c,
                           DunningProcedure__c, IndicatorCustomerIsRebateRelevant__c, RelevantforpricedeterminationID__c, 
                           XYZ__c, Incoterms_Part_1__c, Incoterms_Part_2__c, Creditcontrolarea__c, TM_Code__c, USE_ZAV__c, Tax_classification_for_customer__c,
                           Company_Code__c, Partner_Function__c, Brazil_Depot_Code__c,Brazil_Depot_Code__r.Depot_Code__c,Payment_Term_Code__r.Payment_Term_Code__c,Price_List_Type__r.Price_List_Type__c,
                           Callout_Set__c,CreatedById,CreatedBy.Name,CreatedBy.Email FROM Account WHERE Id=:recordId LIMIT 1];
            
            System.debug('Account details '+acc);
            
            String salesOrgCode='';
            String UserIds = ''; 
            String UserEmail='';
            if(Test.isRunningTest()){
                salesOrgCode = '1000';
            }else{
                salesOrgCode =acc.Sales_Org_Code__c;    
            }
            
            System.debug('salesOrgCode '+salesOrgCode);
            if(salesOrgCode=='1000'){
                UserIds = acc.ZonalHead__c;
            }
            if(salesOrgCode=='1210'){
                UserIds = acc.RegionalManager__c;
            }
            
            User usrObj = new User();
            usrObj =[Select Id,Name, Email from User where Id=:UserIds];
            UserEmail = usrObj.Email;
            
            
            //fetch custom settings from system   
            HANA_Authentication__c credentials = HANA_Authentication__c.getValues('HANA Credentials');
            
            
            String OauthUrl = credentials.Oauth_URL__c;//https://l4097-iflmap.hcisbp.eu1.hana.ondemand.com/http/MDO_SomkeTest
            System.debug('OauthUrl new '+OauthUrl);
            String url = credentials.Endpoint__c;//'https://l4097-iflmap.hcisbp.eu1.hana.ondemand.com/http/CustomerOnBoarding';
            String username = credentials.Username__c;//'S0019198809';//'S0003263313';
            String password = credentials.Password__c;
            System.debug('@@@@@@ User Name New '+username);
            System.debug('@@@@@@ User password  New '+password);
            
            Integer timeOut = 120000;
            System.debug('After Setting timeout');
            //======================== Oauth authorization Start Here =====================================
            
            //Added by vishal pawar
            HttpRequest req = new HttpRequest();
            req.setMethod('POST');
            
            Blob headerValue = Blob.valueOf(username + ':' + password);
            String authorizationHeader = 'BASIC ' +
                EncodingUtil.base64Encode(headerValue);
            
            
            req.setHeader('Authorization', 'Basic ' +
                          EncodingUtil.base64Encode(Blob.valueOf(username + ':' + password)));
            
            req.setEndpoint(OauthUrl);
            req.setBody('grant_type=client_credentials');
            
            Http http = new Http();
            
            wrapOauthResponse wrapOauthResponseObj;
            String oathRes;
            HTTPResponse res;
            String responseAccesToken;
            
            System.debug('Response in res ');
            
            
            if(!Test.isRunningTest()){
                res = http.send(req);
                oathRes = res.getBody();
                wrapOauthResponseObj = (wrapOauthResponse)System.JSON.deserialize(oathRes, AccountOnBoardingService.wrapOauthResponse.class);
                System.debug('wrapOauthResponseObj response '+wrapOauthResponseObj.access_token);
                System.debug('wrapOauthResponseObj response '+wrapOauthResponseObj.token_type);
                System.debug('wrapOauthResponseObj response '+wrapOauthResponseObj.expires_in);
                System.debug('wrapOauthResponseObj response '+wrapOauthResponseObj.scope);
                responseAccesToken = wrapOauthResponseObj.access_token;
            }else{
                String xml = '<CreateCustomerSAPResponse><CustomerCode/><Status>FAIL</Status><Message>PAN Number already exists</Message></CreateCustomerSAPResponse>';
                    res = new HttpResponse();
                    res.setHeader('Content-Type', 'application/xml');
                    res.setBody(xml);
                    res.setStatusCode(200);
            }
            
            
            
            
           
            if(responseAccesToken!='' || responseAccesToken!=null){
                
                
                Http httpNew = new Http();
                HttpRequest request = new HttpRequest(); 
                request.setTimeout(timeOut);
                request.setMethod('POST');
                request.setHeader('Content-Type', 'application/json');
                
                request.setHeader('Authorization', 'Bearer ' +responseAccesToken);
                
                //**Beginning of Creation of Mapping Object of Helper**// 
                
                OnboardingHelper OnboardingMapObj = new OnboardingHelper();
                
                
                OnboardingMapObj.CustAccGroup = Acc.CustomerAccountGroup__c;
                OnboardingMapObj.CompanyCode = Acc.Company_Code__c;
                OnboardingMapObj.SalesOrgCode= Acc.Sales_Org_Code__c;  // Added by Pallavi
                OnboardingMapObj.DistChannel = Acc.Distribution_Channel__r.Distribution_Channel_Code__c;
                OnboardingMapObj.Division = Acc.Division__r.Division_Code__c;
                System.debug('Acc.Salutation__c '+Acc.Salutation__c);
                String mdoSalutation ='';
                if(Acc.Salutation__c=='M/S.'){
                    mdoSalutation = 'Z001';
                }else{
                    mdoSalutation = '';
                }
                
                OnboardingMapObj.Salutation = mdoSalutation; 
                //OnboardingMapObj.Salutation = Acc.Salutation__c; 
                
                OnboardingMapObj.Name = Acc.Name;
                //OnboardingMapObj.DealerSname1 = handleNull(Acc.DealerDistributorShortName__c);
                //OnboardingMapObj.DealerSname2 = handleNull(Acc.DealerDistributorShortNamec1__c);
                OnboardingMapObj.DealerSname1 = Acc.Addressnotes__c;
                OnboardingMapObj.DealerSname2 = Acc.Addressnotes__c;
                
                OnboardingMapObj.BillingStreet2 = Acc.Billing_Street_2__c;//Check the entire section
                OnboardingMapObj.BillingStreet3 = Acc.Billing_Street_3__c;
                OnboardingMapObj.BillingStreet = Acc.BillingStreet;
                OnboardingMapObj.BillingStreet4 = Acc.Billing_Street_4__c;
                OnboardingMapObj.BillingStreet5 = Acc.Billing_Street_5__c;
                OnboardingMapObj.BillingPoCode = Acc.BillingPostalCode;
                OnboardingMapObj.BillingCity = Acc.BillingCity; //Added by Pallavi
                OnboardingMapObj.CountryCode = 'IN';//Acc.CountryKey__c;//Check again:Country code and key are same
                OnboardingMapObj.State = Acc.State_Tax_Structure__r.State_Code__c;//Check Again
                
                String langCodeRe = langCode.get(Acc.LanguageKey__c); 
                OnboardingMapObj.LanguageKey = langCodeRe;
                
                
                OnboardingMapObj.Phone = Acc.Phone;
                OnboardingMapObj.Mobile = Acc.Mobile__c;
                OnboardingMapObj.Email = Acc.Email__c;
                OnboardingMapObj.AddressNote = Acc.Addressnotes__c;
                OnboardingMapObj.AuthorisationGrp = Acc.AuthorizationGroupSalesoffice__c; 
                OnboardingMapObj.GroupKey = Acc.Groupkey__c;
                //OnboardingMapObj.TaxNumber1 = Acc.TaxNumber1__c;  //Added by Pallavi-need to ask sir
                //OnboardingMapObj.TaxNumber2 = Acc.TaxNumber2__c;   //Added by Pallavi-need to ask sir
                OnboardingMapObj.TaxNumber3 = Acc.Tax_Number_3__c;
                OnboardingMapObj.CustomerGroup = Acc.Customergroup__c; 
                OnboardingMapObj.Lastname = Acc.Last_Name__c;
                OnboardingMapObj.ReconAcctGl = Acc.ReconciliationAccountinGeneralLedger__c;
                OnboardingMapObj.KeyForSorting = Acc.KeyforSorting__c;
                OnboardingMapObj.PrevMastRecNum = Acc.PreviousMasterRecordNumber__c;
                OnboardingMapObj.ActiveCode = Acc.ActiveCode__c;
                
                Boolean paymentHis ;
                if(Acc.IndicatorRecordPaymentHistory__c=='X'){
                    paymentHis = TRUE;
                }else{
                    paymentHis = FALSE;
                }
                OnboardingMapObj.PaymentHistory = paymentHis;
                //OnboardingMapObj.PaymentHistory = Acc.IndicatorRecordPaymentHistory__c;//Check Again
                
                
                OnboardingMapObj.DunningProc ='';// Acc.DunningProcedure__c;
                if(Acc.Sales_Org_Code__c!='1000'){
                    OnboardingMapObj.SalesDistrict ='000'+ handleNull(Acc.Region__r.RegionCode__c);//(000338)Check Again --> Region LOOKUP vs REGION CODE
                    OnboardingMapObj.SalesDistrict =  OnboardingMapObj.SalesDistrict.remove('SW');           
                }
                OnboardingMapObj.SalesOffice = Acc.SalesOffice__c;//Check Again
                OnboardingMapObj.SalesGroupAfg = Acc.SalesGroupAFGFCGVSG__c;
                OnboardingMapObj.CustomerGroup2 = Acc.Cust_Group__c;//Check Again
                OnboardingMapObj.CurrencyIsoCode = Acc.CurrencyIsoCode;
                OnboardingMapObj.PriceGroup = Acc.PriceGroupCode__r.PG_Code__c;//This is a lookup vs fill this
                OnboardingMapObj.PriceList = Acc.Price_List_Type__r.Price_List_Type__c;
                OnboardingMapObj.PricingProcedure = Acc.Pricingprocedureassignedtothiscusto__c;
                OnboardingMapObj.CustStaticGroup = Acc.CustomerStatisticsGroup__c;
                OnboardingMapObj.DelieryPriority = Acc.DeliveryPriority__c;
                OnboardingMapObj.ShippingCond = Acc.ShippingConditions__c;
                OnboardingMapObj.DeliveringPlant = Acc.Brazil_Depot_Code__r.Depot_Code__c;
                
                Boolean customerRebate ;
                if(Acc.IndicatorCustomerIsRebateRelevant__c=='X'){
                    customerRebate = TRUE;
                }else{
                    customerRebate = FALSE;
                }
                OnboardingMapObj.CustomerRebate = customerRebate;
                //OnboardingMapObj.CustomerRebate = Acc.IndicatorCustomerIsRebateRelevant__c;
                
                OnboardingMapObj.PriceDetermination = Acc.RelevantforpricedeterminationID__c;
                OnboardingMapObj.IncotermsPart1 = Acc.Incoterms_Part_1__c;
                OnboardingMapObj.IncotermsPart2 = Acc.Incoterms_Part_2__c;
                OnboardingMapObj.PaymentTerms = Acc.Payment_Term_Code__r.Payment_Term_Code__c;
                OnboardingMapObj.CreditControlArea = Acc.Creditcontrolarea__c;
                OnboardingMapObj.AccntAssgnGrp = Acc.Accountassignmentgroup__c;
                OnboardingMapObj.TaxClassification = Acc.Tax_classification_for_customer__c;
                //set partner function only if acc is sold to party
                OnboardingMapObj.PartnerFunction = Acc.Partner_Function__c=='Z1' ? Acc.Partner_Function__c : '' ;
                OnboardingMapObj.TmCode = Acc.TM_Code__c;
                //To remove SW from SWAL Territory Codes
                String tCode = Acc.Territory_Code__c;
                
                if(!Test.isRunningTest()){
                    if(Acc.Sales_Org_Code__c!='1000'){
                        OnboardingMapObj.TerritoryCode = tCode.remove('SW');
                    }
                    else{
                        OnboardingMapObj.TerritoryCode =Acc.Territory_Code__c;    
                    } 
                }
                
                
                OnboardingMapObj.PanNumber = Acc.PAN_Number__c;
                OnboardingMapObj.CustomerClassification= Acc.Customer_Classification1__c; // Added by Pallavi
                OnboardingMapObj.SfdcId = Acc.SFDC_Customer_Code__c;
                OnboardingMapObj.TMusername= Acc.CreatedBy.Name;
                OnboardingMapObj.TMemailId= Acc.CreatedBy.Email;
                OnboardingMapObj.SupervisorEmaiId =UserEmail;
                //newly added on 21 jan 2021
                OnboardingMapObj.ContactName =Acc.ContactName__c;
                
                
                
                System.debug('Just after Helper Class');
                String json = System.JSON.serializePretty(OnboardingMapObj);
                
                System.debug('json creation after '+json);
                
                request.setEndpoint(url); 
                request.setBody(json);
                
                if(!Test.isRunningTest()){
                    response = httpNew.send(request);
                    String resMDO = response.getBody();
                    //system.debug(' HANA username--> '+credentials.Username__c +' Password: --> '+credentials.Password__c);
                    system.debug('User Name '+username + 'password :' + password);
                    system.debug(' while tesing body '+resMDO);
                    
                    wrapResponse wrapResponseObj = (wrapResponse)System.JSON.deserialize(resMDO, AccountOnBoardingService.wrapResponse.class);
                    
                    System.debug('wrapResponseObj response '+wrapResponseObj.CustomerMDOID);
                    
                    MDO_Code=wrapResponseObj.CustomerMDOID;
                    status=wrapResponseObj.Status;
                    
                    msg=wrapResponseObj.Message;
                    
                    System.debug(' while tesing  '+response);
                    String st = response.getStatus();
                    System.debug('Status in response '+st);
                    Integer stCode =response.getStatusCode();
                    System.debug('stCode in response '+stCode);
                    
                }else{
                    // Create a fake response for test class
                    String xml = '<CreateCustomerSAPResponse><CustomerCode/><Status>FAIL</Status><Message>PAN Number already exists</Message></CreateCustomerSAPResponse>';
                    response = new HttpResponse();
                    response.setHeader('Content-Type', 'application/xml');
                    response.setBody(xml);
                    response.setStatusCode(200);
                }
                System.debug('MDO_Code in response '+MDO_Code);
                
                if((MDO_Code!=null || MDO_Code!='') && (status=='Success') || Test.isRunningTest()){
                    //if Sold to party
                    System.debug('Acc.Partner_Function__c '+Acc.Partner_Function__c);
                    if(Acc.Partner_Function__c == 'Z1'){
                        Account accobjTemp = new Account();
                        // accobjTemp.SAP_Code__c  = MDO_Code;
                        accobjTemp.MDO_Code__c  = MDO_Code;
                        accobjTemp.Error_Message__c = msg;
                        accobjTemp.Callout_Set__c = true;
                        accobjTemp.Id = recordId;
                        update accobjTemp; 
                        
                    }
                }else if(status=='Failed'){
                    Account accobjTemp1 = new Account();
                    accobjTemp1.Error_Message__c = status +''+msg;
                    accobjTemp1.Id = recordId;
                    update accobjTemp1;
                }
                
                
                
            }else{
                Account tempAccObj = new Account();
                tempAccObj.Error_Message__c ='Authentication Failed, Please contact Admin.';
                tempAccObj.Id = recordId;
                update tempAccObj;
            }
            
            
            
            
            
            
            //======================== Oauth authorization End Here =====================================
            
        }
        
        catch(Exception ex){
            System.debug('Error Occure Line Number '+ex.getLineNumber());
            System.debug('Error Occure Message '+ex.getMessage());
            
            
            Account accObj = new Account();
            accObj.Error_Message__c = 'Authentication Failed. Please contact to Admin.'; 
            accObj.Id = recordId;
            update accObj;
        }
    }
    
    
    //to check for Null field values
    public static string handleNull(String fieldValue){
        if(String.isBlank(fieldValue))
        {
            return '';
        }
        else{
            return fieldValue;
        }
    }
    
    
    public class wrapResponse{
        public String Status;
        public String CustomerMDOID;
        public String Message;
        
        public wrapResponse(){
            Status='';
            CustomerMDOID='';
            Message='';
        }
    }
    
    
    public class wrapOauthResponse{
        public String access_token;
        public String token_type;
        public String expires_in;
        public String scope;
        
        
        public wrapOauthResponse(){
            access_token='';
            token_type='';
            expires_in='';
            scope='';
        }
    }
    
    
}