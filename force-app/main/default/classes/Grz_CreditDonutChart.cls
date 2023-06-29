public with sharing class Grz_CreditDonutChart {
    @AuraEnabled
    public static ParentResultWrapper getDonData(String companyCode) {
        decimal BalLimit = 0;
        decimal UseLimit = 0;
        decimal CredLimit = 0;
        Id id;
       
        System.debug('company Code+++'+ companyCode);
        List<credit> lstObjCred = new List<credit>();
        if(Test.isRunningTest()){
            List<Profile> pro = [SELECT Id FROM Profile WHERE Name = 'India Partner Community Distributor Profile'];
            List<User> user = [SELECT Id, Username, AccountId, ContactId FROM User WHERE ProfileId =: pro[0].Id AND lastname = 'Testing' and Email ='test@grazitti.com' LIMIT 1];
            id = user[0].Id;
        }
        else{
            id = UserInfo.getUserId();
        }
                
        List<User> user = [SELECT Id, Username,account.Company_Code__c,account.SAP_Customer_Code__c,account.sap_UserId__c, AccountId, ContactId FROM User where Id =: id and accountid != null];
        ParentResultWrapper PRW = new ParentResultWrapper();
        system.debug('companyCode ++'+companyCode);
               
        if(!user.isEmpty()){
            if(companyCode != null && user[0].account.SAP_Customer_Code__c != null && user[0].account.sap_UserId__c != null){
                // Customer 360 CR changes (Nikhi Verma)
                String Response;
                Map<String, Grz_Customer360IntegrationMappings__mdt> integrationSettingsMap = new Map<String, Grz_Customer360IntegrationMappings__mdt>();
                for(Grz_Customer360IntegrationMappings__mdt data: Grz_Customer360IntegrationMappings__mdt.getAll().values()){
                    integrationSettingsMap.put(data.Company_Code__c, data);
                }
                if(integrationSettingsMap != null && integrationSettingsMap.containsKey(companyCode) && integrationSettingsMap.get(companyCode).Country__c == 'India'){
                    if(integrationSettingsMap.get(companyCode).EndPointURL__c != null){
                        String endPointName = integrationSettingsMap.get(companyCode).EndPointURL__c;
                        Response = Grz_SapCommonIntegration.creditSummaryMarketingIND(companyCode, user[0].account.SAP_Customer_Code__c, user[0].account.sap_UserId__c, endPointName);
                    }else{
                        Response = grz_SapIntegration.CreditSummary(companyCode,user[0].account.SAP_Customer_Code__c,user[0].account.sap_UserId__c);
                    }
                }else{
                    Response = grz_SapIntegration.CreditSummary(companyCode,user[0].account.SAP_Customer_Code__c,user[0].account.sap_UserId__c);
                }
                response = response.replace('Balance_Limit__c','BalanceLimit').replace('Used_Limit__c','UsedLimit').replace('Credit_limit__c','Creditlimit').replace('Sales_org__c','Salesorg').replace('Credit_control_area','Creditcontrolarea');
                if(response.equals('Error_In_Sap')){
                    PRW.isSuccess = false;
                    PRW.Message = 'Error In SAP';
                }
                else{
                    system.debug('response'+response);
                    Grz_CreditSummaryWrapper Data = new Grz_CreditSummaryWrapper();
                    Data = Grz_CreditSummaryWrapper.parse(response);
                     Map<String,String> indocMap = new Map<String,String>();
                    for(Grz_SalesOrgMapping__mdt ad : [Select Label, DeveloperName, CCAr__c from Grz_SalesOrgMapping__mdt Where Label =: companyCode]){
                        indocMap.put(ad.Label,ad.CCAr__c);
                    }
                    string ccar='';
                    if(indocmap.containsKey(companyCode)){
                        ccar = indocmap.get(companyCode);
                    }
                 
                    system.debug('DDD'+Data.CreditInfo);
                    for(credit s : Data.CreditInfo){
                        if(s.Creditcontrolarea.equals(ccar)){
                            System.debug('s.Creditcontrolarea=== '+s.Creditcontrolarea);
                            if(s.BalanceLimit.equals(null)){
                                BalLimit = 0;
                            }else{
                                BalLimit = decimal.valueOf(s.BalanceLimit);
                            }
                            if(s.UsedLimit.equals(null)){
                                UseLimit = 0;
                            }
                            else{
                                UseLimit = decimal.valueOf(s.UsedLimit);
                            }
                            if(s.Creditlimit.equals(null)){
                                CredLimit = 0; 
                            }
                            else{
                                CredLimit = decimal.valueOf(s.Creditlimit);
                            }
                            system.debug(s.BalanceLimit);
                            system.debug(s.UsedLimit);
                            system.debug(s.Creditlimit);
                        }
                    }
                }
            }   
            else if(companyCode==Null || companyCode==''){                         //Updated for INC0414972 GRZ(Dheeraj Sharma) 18-11-2022
                PRW.isSuccess = false;                                             //Updated for INC0414972 GRZ(Dheeraj Sharma) 18-11-2022
                PRW.errorMessage='False';                                       //Updated for INC0414972 GRZ(Dheeraj Sharma) 18-11-2022
                PRW.Message = 'Customer Code Null .Please contact administrator';
            }
        else if(user[0].account.SAP_Customer_Code__c == null || user[0].account.sap_UserId__c==null){       //Updated for INC0414972 GRZ(Dheeraj Sharma) 18-11-2022
                PRW.isSuccess = false;                                                                   //Updated for INC0414972 GRZ(Dheeraj Sharma) 18-11-2022
                PRW.Message = 'Customer Code/User ID is empty. Please contact administrator';   //Updated for INC0414972 GRZ(Dheeraj Sharma) 18-11-2022 
            }                                                                                      //Updated for INC0414972 GRZ(Dheeraj Sharma) 18-11-2022 
        }                                                                     //Updated for INC0414972 GRZ(Dheeraj Sharma) 18-11-2022 
        else{                                                                                    
            PRW.isSuccess = false;                                                                  
            PRW.Message = 'Internal user not allowed to access this component.';       
        }                                             
        
        List<CredDonutData> CredData = new List<CredDonutData>();
        CredData.add(new CredDonutData(System.Label.Grz_CreditUtilized, UseLimit.setScale(2)));
        CredData.add(new CredDonutData(System.Label.Grz_CreditPending, BalLimit.setScale(2)));
        
        List<ResultWrapper> FinalRes = new List<ResultWrapper>(); 
        //FinalRes.cateListWrap = data1;
        //FinalRes.Total = CredLimit;
        System.debug('lstObjCred'+lstObjCred);
        ResultWrapper rw = new ResultWrapper();
        rw.responseData = lstObjCred;
        rw.cateListWrap = CredData;
        rw.Total = CredLimit.setScale(2);
        FinalRes.add(rw);
        system.debug('rree==>>'+rw);
        system.debug('FinalRes==>>'+FinalRes);
        PRW.Results = FinalRes;        
        return PRW;
    } 

    /**************************************************************************************************
    * @Description       : method created to get data of Sales Area for grz_chats component                                                     
    * Date               : 05-10-2022                                                                      
    * Author             : Mohit Garg
    * Last Modified By   : Mohit Garg (Grazitti) 06-10-2022                                                                        
    **************************************************************************************************/
    

   @AuraEnabled(continuation=true)
    public static List<map<string,string>> getSalesAreaOptions(){
        List<map<string,string>> salesAreaOptions = new  List<map<string,string>>();
        set<string>saleOrgCountered=new set<string>();
        Id usrid = UserInfo.getUserId();
        List<User> user = [SELECT Id, Username,AccountId, ContactId FROM User where Id =: usrid and accountid != null];
   //Change by Aashima(Grazitti) for APPS-4027 28Dec22
        List<DistributorSalesAreaMapping__c> salesAreaList = [SELECT Id, Name, Distributor__c, SalesOrg__c,SalesOrg__r.name,Company_Code__c,Sales_Org_Code__c FROM DistributorSalesAreaMapping__c where Distributor__c =: user[0].accountId];  // Change by Sumit(Grazitti) for APPS-4636 25 Jan,2023
        for(DistributorSalesAreaMapping__c dsa : salesAreaList){
            if(!saleOrgCountered.contains(dsa.SalesOrg__r.name)){
                map<string,string>salesMap=new map<string,string>{'label'=>dsa.SalesOrg__r.name,'value'=>dsa.Company_Code__c};
                salesAreaOptions.add(salesMap);
                saleOrgCountered.add(dsa.SalesOrg__r.name);
            }
        }
        return salesAreaOptions;
    }

    public class GstInfo {
        @AuraEnabled public String SalesAreaName{get;set;}
        @AuraEnabled public String CompanyCode{get;set;}
    }
    
    
    @AuraEnabled
    public static ParentResultWrapper getDonDataBrazil() {
        decimal balCredit = 0;
        decimal balUtilized = 0;
        decimal balPending = 0;
        Id id;
        if(Test.isRunningTest()){
            List<Profile> pro = [SELECT Id FROM Profile WHERE Name = 'India Partner Community Distributor Profile'];
            List<User> user = [SELECT Id, Username, AccountId, ContactId FROM User WHERE ProfileId =: pro[0].Id AND lastname = 'Testing' and Email ='test@grazitti.com' LIMIT 1];
            id = user[0].Id;
        }
        else{
            id = UserInfo.getUserId();
        }
        List<User> user = [SELECT Id, Username,account.Company_Code__c,account.SAP_Customer_Code__c,account.sap_UserId__c, AccountId, ContactId FROM User where Id =: id and accountid != null];
        ParentResultWrapper PRW = new ParentResultWrapper();
        List<CreditDetailWrap> cdwrap = new List<CreditDetailWrap>();
        if(!user.isEmpty()){
            if(user[0].account.Company_Code__c != null && user[0].account.SAP_Customer_Code__c != null && user[0].account.sap_UserId__c != null){
                String Response = grz_SapIntegration.CreditSummaryBrazil(user[0].account.Company_Code__c,user[0].account.SAP_Customer_Code__c,user[0].account.sap_UserId__c);
                response = response.replace('sales_organization','Salesorg').replace('credit_control','Creditcontrolarea');
                if(response.equals('Error_In_Sap')){
                    PRW.isSuccess = false;
                    PRW.Message = 'Erro no SAP';
                }
                else{
                    Grz_CreditSummaryWrapper Data = new Grz_CreditSummaryWrapper();
                    Data = Grz_CreditSummaryWrapper.parse(response);
                    CreditDetailWrap cdData = new CreditDetailWrap();
                    for(credit s : Data.CreditInfo){
                        if(s.Creditcontrolarea.equals('UPBR')){
                            cdData.creditAccount = s.customer_number;
                            if(s.Next_internal_review !='0000-00-00'){
                                cdData.nextInternalReview = grz_SapIntegration.FormattedDateBrazil(Date.valueOf(s.Next_internal_review)); 
                            }else{
                                cdData.nextInternalReview = '-';
                            }                            cdData.cleanLimit = String.valueOf(Decimal.valueOf(s.clean_limit).setScale(0));
                            cdData.lineLimit = String.valueOf(Decimal.valueOf(s.Line_limit).setScale(0));
                            cdData.receivables = String.valueOf(Decimal.valueOf(s.Total_receivables).setScale(0));
                            cdData.specialLiabilities = String.valueOf(Decimal.valueOf(s.Relevant_special_liabilities_for_credit_limit_check).setScale(0));
                            cdData.guaranteeReleased = String.valueOf(Decimal.valueOf(s.ZTOT_LIB_GARANT).setScale(0));
                            Decimal tempSum = Decimal.valueOf(s.clean_limit) + Decimal.valueOf(s.ZTOT_LIB_GARANT);
                            if(tempSum > Decimal.valueOf(s.Line_limit)){
                                cdData.cleanGuarantee = s.Line_limit;
                            }else{
                                cdData.cleanGuarantee = String.valueOf(tempSum);
                            }
                            cdData.creditAvailable = String.valueOf(Decimal.valueOf(cdData.cleanGuarantee) - Decimal.valueOf(s.Credit_exposure));
                            cdData.creditExposure = String.valueOf(Decimal.valueOf(s.Credit_exposure).setScale(0));
                            balPending = Decimal.valueOf(cdData.cleanGuarantee).setScale(2) - Decimal.valueOf(s.Credit_exposure).setScale(2);
                            balUtilized = Decimal.valueOf(s.Credit_exposure).setScale(2);
                            balCredit = Decimal.valueOf(cdData.cleanGuarantee).setScale(2);
                            cdData.cleanGuarantee = String.valueOf(Decimal.valueOf(cdData.cleanGuarantee).setScale(0));
                            cdData.creditAvailable = String.valueOf(Decimal.valueOf(cdData.creditAvailable).setScale(0));
                        }
                        cdwrap.add(cdData);
                    }
                }
            }
            else{
                PRW.isSuccess = false;
                PRW.Message = 'Código do cliente / Código da empresa / ID do usuário está vazio. Por favor, contate o administrador';
            }
        }
        List<CredDonutData> CredData = new List<CredDonutData>();
        CredData.add(new CredDonutData(System.Label.Grz_CreditUtilized, balUtilized.setScale(0)));
        CredData.add(new CredDonutData(System.Label.Grz_CreditPending, balPending.setScale(0)));
        
        List<ResultWrapper> FinalRes = new List<ResultWrapper>(); 
        //FinalRes.cateListWrap = data1;
        //FinalRes.Total = CredLimit;
        
        ResultWrapper rw = new ResultWrapper();
        rw.cateListWrap = CredData;
        rw.Total = balCredit.setScale(0);
        FinalRes.add(rw);
        PRW.Results = FinalRes;  
        PRW.creditDetailData = cdwrap;
        return PRW;
    } 
    @AuraEnabled
    public static ParentResultWrapper getDonDataMexico()
    {
        decimal balCredit = 0;
        decimal balUtilized = 0;
        decimal balPending = 0;
        Id id;
        if(Test.isRunningTest()){
            List<Profile> pro = [SELECT Id FROM Profile WHERE Name = 'Mexico Partner Community Distributor Profile'];
            List<User> user = [SELECT Id, Username, AccountId, ContactId FROM User WHERE ProfileId =: pro[0].Id AND lastname = 'Testing' and Email ='test@grazitti.com' LIMIT 1];
            id = user[0].Id;
        }
        else{
            id = UserInfo.getUserId();
        }
        
        List<User> user = [SELECT Id, Username,account.Company_Code__c,account.SAP_Customer_Code__c,account.sap_UserId__c, AccountId, ContactId FROM User where Id =: id and accountid != null];   
        
        ParentResultWrapper PRW = new ParentResultWrapper();
        List<CreditDetailWrap> cdwrap = new List<CreditDetailWrap>();
        // system.debug('user[0].account.Company_Code__c-->>'+user[0].account.Company_Code__c);
        // system.debug('user[0].account.SAP_Customer_Code__c-->>'+user[0].account.SAP_Customer_Code__c);
        //system.debug('user[0].account.sap_UserId__c-->>'+user[0].account.sap_UserId__c);
        if(!user.isEmpty()){
            if(user[0].account.Company_Code__c != null && user[0].account.SAP_Customer_Code__c != null && user[0].account.sap_UserId__c != null){
                
                
                String Response = grz_SapIntegration.CreditSummaryChileMexico(user[0].account.Company_Code__c,user[0].account.SAP_Customer_Code__c,user[0].account.sap_UserId__c);
                //String Response = grz_SapIntegration.CreditSummaryBrazil('5190','0001033914','UPLINTCRM');
                system.debug('Response>>>'+Response);
                response = response.replace('sales_organization','Salesorg').replace('credit_control','Creditcontrolarea');
                if(response.equals('Error_In_Sap')){
                    PRW.isSuccess = false;
                    PRW.Message = 'Error en SAP';
                }
                else{
                    Grz_CreditSummaryWrapper Data = new Grz_CreditSummaryWrapper();
                    Data = Grz_CreditSummaryWrapper.parse(response);
                    CreditDetailWrap cdData = new CreditDetailWrap();
                    for(credit s : Data.CreditInfo){
                        if(s.Creditcontrolarea.equals('UPMX')){
                            balCredit = Decimal.valueOf(s.CreditLimit);
                            balPending = Decimal.valueOf(s.BalanceLimit);
                            balUtilized = Decimal.valueOf(s.CreditExposure);
                        }
                        cdwrap.add(cdData);
                    }
                }
            }
            else{
                PRW.isSuccess = false;
                PRW.Message = 'El código de cliente / código de empresa / ID de usuario está vacío. Por favor, contacte a su administrador';
            }
        }
        else
        {
            PRW.isSuccess = false;
            System.debug('summary not for internal user');
            PRW.Message = 'Resumen de crédito no accesible para el usuario interno';
        }
        system.debug('aashima==>'+cdwrap);
        List<CredDonutData> CredData = new List<CredDonutData>();
        CredData.add(new CredDonutData(System.Label.Grz_CreditUtilized, balUtilized.setScale(0)));
        CredData.add(new CredDonutData(System.Label.Grz_CreditPending, balPending.setScale(0)));
        
        List<ResultWrapper> FinalRes = new List<ResultWrapper>(); 
        //FinalRes.cateListWrap = data1;
        //FinalRes.Total = CredLimit;
        
        ResultWrapper rw = new ResultWrapper();
        rw.cateListWrap = CredData;
        rw.Total = balCredit.setScale(0);
        FinalRes.add(rw);
        PRW.Results = FinalRes;  
        PRW.creditDetailData = cdwrap;
        return PRW;
    }
    
    
/**************************************************************************************************
* @Description       : method created to get data for argentina credit summaryDonut                                                      
* Date               : 11-08-2022
* Project/JIRA       : APPS-1757                                                                        
* Author             : Gurubaksh Grewal
* @Return            : Grz_CreditDonutChart.ParentResultWrapper
* Last Modified By   : Mohit Garg (Grazitti) 09-11-2022                                                                        
**************************************************************************************************/
    
    @AuraEnabled
    public static ParentResultWrapper getDonDataArgentina()
    {
        decimal balCredit = 0;
        decimal balUtilized = 0;
        decimal balPending = 0;
        Id id;
        if(Test.isRunningTest()){
            List<Profile> pro = [SELECT Id FROM Profile WHERE Name = 'Argentina Partner Community Distributor Profile'];
            List<User> user = [SELECT Id, Username, AccountId, ContactId FROM User WHERE ProfileId =: pro[0].Id AND lastname = 'Testing' and Email ='test@grazitti.com' LIMIT 1];
            id = user[0].Id;
        }
        else{
            id = UserInfo.getUserId();
        }
        
        List<User> user = [SELECT Id, Username,account.Company_Code__c,account.SAP_Customer_Code__c,account.sap_UserId__c, AccountId, ContactId FROM User where Id =: id and accountid != null];   
        
        ParentResultWrapper PRW = new ParentResultWrapper();
        List<CreditDetailWrap> cdwrap = new List<CreditDetailWrap>();
        if(!user.isEmpty()){
            if(user[0].account.Company_Code__c != null && user[0].account.SAP_Customer_Code__c != null && user[0].account.sap_UserId__c != null){
                
                
                String Response = grz_SapIntegration.CreditSummaryChileMexico(user[0].account.Company_Code__c,user[0].account.SAP_Customer_Code__c,user[0].account.sap_UserId__c);
                //String Response = grz_SapIntegration.CreditSummaryChileMexico('5630','0001013516','UPLINTCRM');
                system.debug('Response>>>'+Response);
                response = response.replace('sales_organization','Salesorg').replace('credit_control','Creditcontrolarea');
                if(response.equals('Error_In_Sap')){
                    PRW.isSuccess = false;
                    PRW.Message = 'Error en SAP';
                }
                else{
                    Grz_CreditSummaryWrapper Data = new Grz_CreditSummaryWrapper();
                    Data = Grz_CreditSummaryWrapper.parse(Response);
                    CreditDetailWrap cdData = new CreditDetailWrap();
                    for(credit s : Data.CreditInfo){
                        if(s.Creditcontrolarea.equals('UPIC')){
                            balCredit = Decimal.valueOf(s.CreditLimit);
                           // the snippet below is introduced to get 0 value of BalanceLimit if BalanceLimit is Negative for Argentina community,GRZ(Mohit Garg) : APPS-1757 added on: 09-11-2022
                           if(Decimal.valueOf(s.BalanceLimit) < 0){
                                balPending = 0;
                            }
                            else{
                                balPending = Decimal.valueOf(s.BalanceLimit);
                            }
                            balUtilized = Decimal.valueOf(s.CreditExposure);
                        }
                        cdwrap.add(cdData);
                    }
                }
            }
            else{
                PRW.isSuccess = false;
                PRW.Message = 'El código de cliente / código de empresa / ID de usuario está vacío. Por favor, contacte a su administrador';
            }
        }
        else
        {
            PRW.isSuccess = false;
            System.debug('summary not for internal user');
            PRW.Message = 'Resumen de crédito no accesible para el usuario interno';
        }
        system.debug('aashima==>'+cdwrap);
        List<CredDonutData> CredData = new List<CredDonutData>();
        CredData.add(new CredDonutData(System.Label.Grz_CreditUtilized, balUtilized.setScale(0)));
        CredData.add(new CredDonutData(System.Label.Grz_CreditPending, balPending.setScale(0)));
        
        List<ResultWrapper> FinalRes = new List<ResultWrapper>(); 
        //FinalRes.cateListWrap = data1;
        //FinalRes.Total = CredLimit;
        
        ResultWrapper rw = new ResultWrapper();
        rw.cateListWrap = CredData;
        rw.Total = balCredit.setScale(0);
        FinalRes.add(rw);
        PRW.Results = FinalRes;  
        PRW.creditDetailData = cdwrap;
        return PRW;
    }
    
    
    @AuraEnabled
    public static ParentResultWrapper getDonDataChile(String cusNumber) {
        system.debug('cusNumber-->>'+cusNumber);
        ParentResultWrapper PRW = new ParentResultWrapper();
        PRW.isSuccess = true;
        List<CreditDetailWrap> cdwrap = new List<CreditDetailWrap>();
        decimal balCredit = 0;
        decimal balUtilized = 0;
        decimal balPending = 0;
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
        List<User> user = [SELECT Id, Username,account.Company_Code__c,account.SAP_Customer_Code__c,account.sap_UserId__c, AccountId, ContactId FROM User where Id =: id and accountid != null];
        
        
        if(!user.isEmpty()){
            
            if(user[0].account.Company_Code__c != null && user[0].account.SAP_Customer_Code__c != null && user[0].account.sap_UserId__c != null){
                String Response = grz_SapIntegration.CreditSummaryChileMexico(user[0].account.Company_Code__c,user[0].account.SAP_Customer_Code__c,user[0].account.sap_UserId__c);
                response = response.replace('sales_organization','Salesorg').replace('credit_control','Creditcontrolarea');
                if(response.equals('Error_In_Sap')){
                    PRW.isSuccess = false;
                    PRW.Message = 'Error en SAP';
                }
                else{
                    Grz_CreditSummaryWrapper Data = new Grz_CreditSummaryWrapper();
                    Data = Grz_CreditSummaryWrapper.parse(response);
                    CreditDetailWrap cdData = new CreditDetailWrap();
                    for(credit s : Data.CreditInfo){
                        if(s.Creditcontrolarea.equals('UPCL')){
                            balCredit = Decimal.valueOf(s.CreditLimit);
                            balPending = Decimal.valueOf(s.BalanceLimit);
                            balUtilized = Decimal.valueOf(s.CreditExposure);
                        }
                        cdwrap.add(cdData);
                    }
                }
            }
            else{
                PRW.isSuccess = false;
                PRW.Message = 'El código de cliente / código de empresa / ID de usuario está vacío. Por favor contacte al administrador';
            }
            PRW.isInternal = false;
        }else{
            PRW.isInternal = true;
            if(cusNumber != null && !String.isEmpty(cusNumber) && !String.isBlank(cusNumber)){
                system.debug('cusNumber null');
                List<String> salesorgcode = System.Label.Grz_ChileSalesOrgCode.trim().Split(',');
                if(test.isRunningTest()){
                    salesorgcode.add('5661');
                }
                system.debug('salesorgcode'+salesorgcode);
                system.debug('cusNumber'+cusNumber);
                List<Account> accList = [SELECT Id,Sap_UserId__c ,Company_Code__c,SAP_Customer_Code__c FROM Account WHERE ID =: cusNumber AND Sales_org_Code__c in:salesorgcode LIMIT 1];
                system.debug('accList-->>>>'+accList);
                if(!accList.isEmpty()){
                    system.debug('accList empty');
                    system.debug( PRW.isSuccess);
                    system.debug( PRW.Message);
                    
                    if(accList[0].Company_Code__c != null && accList[0].sap_UserId__c != null){
                        String Response = grz_SapIntegration.CreditSummaryChileMexico(accList[0].Company_Code__c,accList[0].SAP_Customer_Code__c,accList[0].sap_UserId__c);
                        response = response.replace('sales_organization','Salesorg').replace('credit_control','Creditcontrolarea');
                        if(response.equals('Error_In_Sap')){
                            PRW.isSuccess = false;
                            PRW.Message = 'Error en SAP';
                        }
                        else{
                            Grz_CreditSummaryWrapper Data = new Grz_CreditSummaryWrapper();
                            Data = Grz_CreditSummaryWrapper.parse(response);
                            CreditDetailWrap cdData = new CreditDetailWrap();
                            for(credit s : Data.CreditInfo){
                                if(s.Creditcontrolarea.equals('UPCL')){
                                    balCredit = Decimal.valueOf(s.CreditLimit);
                                    balPending = Decimal.valueOf(s.BalanceLimit);
                                    balUtilized = Decimal.valueOf(s.CreditExposure);
                                }
                                cdwrap.add(cdData);
                            }
                        }
                    }
                    else{
                        PRW.isSuccess = false;
                        PRW.Message = 'El código de cliente / código de empresa / ID de usuario está vacío. Por favor contacte al administrador';
                    }
                    
                }else{
                    PRW.isSuccess = false;
                    PRW.Message = 'Distribuidora no encontrada';
                }
            }
            else{
                system.debug('elseeeeeeeeeeeeeee');
                PRW.isSuccess = false;
                PRW.Message = 'Distribuidora no encontrada';
            }
            
        }
        List<CredDonutData> CredData = new List<CredDonutData>();
        CredData.add(new CredDonutData(System.Label.Grz_CreditUtilized, balUtilized.setScale(0)));
        CredData.add(new CredDonutData(System.Label.Grz_CreditPending, balPending.setScale(0)));
        
        List<ResultWrapper> FinalRes = new List<ResultWrapper>(); 
        //FinalRes.cateListWrap = data1;
        //FinalRes.Total = CredLimit;
        
        ResultWrapper rw = new ResultWrapper();
        rw.cateListWrap = CredData;
        rw.Total = balCredit.setScale(0);
        FinalRes.add(rw);
        PRW.Results = FinalRes;  
        PRW.creditDetailData = cdwrap;
        return PRW;
    } 
    
    
    
    public class Grz_CreditSummaryWrapper {
        @AuraEnabled public List<credit> CreditInfo{get;set;}
        @AuraEnabled public List<CredDonutData> CredDonut{get;set;}
        @AuraEnabled public List<ResultWrapper> Result{get;set;}
    }
    public class credit {
        @AuraEnabled public String BalanceLimit{get;set;}
        @AuraEnabled public String UsedLimit{get;set;}
        @AuraEnabled public String Creditlimit{get;set;}
        @AuraEnabled public String Salesorg{get;set;}
        @AuraEnabled public String Creditcontrolarea{get;set;}
        @AuraEnabled public String customer_number;
        @AuraEnabled public String name;
        @AuraEnabled public String Credit_exposure;
        @AuraEnabled public String Next_internal_review;
        @AuraEnabled public String Relevant_special_liabilities_for_credit_limit_check;
        @AuraEnabled public String Total_receivables;
        @AuraEnabled public String Customer_account_number_with_credit_limit_reference;
        @AuraEnabled public String Customer_group;
        @AuraEnabled public String Customer_Credit_Group;
        @AuraEnabled public String Credit_representative_group_for_credit_management;
        @AuraEnabled public String clean_limit;
        @AuraEnabled public String Line_limit;
        @AuraEnabled public String ZTOT_LIB_GARANT;
        @AuraEnabled public String CreditExposure{get;set;}
    }
    public class CredDonutData {
        @AuraEnabled
        public String name {get; set;}
        @AuraEnabled
        public Decimal value {get; set;}
        
        
        public CredDonutData(String name, Decimal value) {
            this.name = name;
            this.value = value;
        }
    }
    public class ResultWrapper{
        @AuraEnabled
        public List<credit> responseData{get;set;}
        /*@AuraEnabled
public List<Sales_Org_Info__mdt> metaSalesOrgList{get;set;}*/
        @AuraEnabled
        public set<String> salesOrgList{get;set;}
        @AuraEnabled
        public Decimal Total{get;set;}
        @AuraEnabled  
        public list<CredDonutData> cateListWrap{get;set;}
        
    }
    public class CreditDetailWrap{
        @AuraEnabled public String creditAccount{get;set;}
        @AuraEnabled public String nextInternalReview{get;set;}
        @AuraEnabled public String creditAvailable{get;set;}
        @AuraEnabled public String cleanGuarantee{get;set;}
        @AuraEnabled public String creditExposure{get;set;}
        
        @AuraEnabled public String cleanLimit{get;set;}
        @AuraEnabled public String lineLimit{get;set;}
        @AuraEnabled public String guaranteeReleased{get;set;}
        @AuraEnabled public String receivables{get;set;}
        @AuraEnabled public String specialLiabilities{get;set;}
    }
    public class ParentResultWrapper{
        @AuraEnabled  
        public List<ResultWrapper> Results{get;set;}
        @AuraEnabled  
        public List<CreditDetailWrap> creditDetailData{get;set;}
        @AuraEnabled  
        public boolean isSuccess{get;set;}
        @AuraEnabled  
        public String Message{get;set;}
        @AuraEnabled  
        public Boolean isInternal{get;set;}
        @AuraEnabled                        //Updated for INC0414972 GRZ(Dheeraj Sharma) 18-11-2022
        public String errorMessage{get;set;}//Updated for INC0414972 GRZ(Dheeraj Sharma) 18-11-2022
        
    }
    
    public static Grz_CreditSummaryWrapper parse(String json) {
        return (Grz_CreditSummaryWrapper) System.JSON.deserialize(json, Grz_CreditSummaryWrapper.class);
    }
}