/**************************************************************************************************
* Name               : Grz_AccountLedgerInternal                                                      
* Description        : Controller class for grz_AccountLedgerInternal LWC Component
* Created Date       : 23/05/2022                                                                 
* Created By         : Nikhil Verma (Grazitti)                                                                       
**************************************************************************************************/                                            
public with sharing class Grz_AccountLedgerInternal {

    public static Grz_Customer360Wrapper.CustomerInfo customerInfo          {get;set;}
    public static List<Grz_Customer360Wrapper.ItemInfo> ItemInfo            {get;set;}
    public static String totalCredit                                        {get;set;}
    public static String totalDebit                                         {get;set;}
    public static String openingPositiveBalance                             {get;set;}
    public static String openingNegativeBalance                             {get;set;}
    public static String closingPositiveBalance                             {get;set;}
    public static String closingNegativeBalance                             {get;set;}
    public static String vfYear                                             {get;set;}
    public static String vfMonth                                            {get;set;}
    public Grz_Customer360Wrapper.LabelsWrapper labels                      {get;set;}
    
    /******************************************************************************************************
    * @Description        : This method will return selected account data 
    * Date                : 23/05/2022 
    * Author              : Nikhil Verma (Grazitti)                                                                  
    * @Return             : Grz_Customer360Wrapper.Wrapper
    * @Params             : recordId      
    * @LastModified       : Grz(Nikhil Verma) 31-08-2022 removed custom label setting and switched to metadata settings for better access control
                            also created new metadata to store doc type info for different country                                                                     
    *******************************************************************************************************/
    @AuraEnabled(cacheable = true)
    public static Grz_Customer360Wrapper.Wrapper getData(String recordId){
        Grz_Customer360Wrapper.Wrapper response = new Grz_Customer360Wrapper.Wrapper();
        try{
            List<Account> accList = [SELECT Id, Sap_UserId__c, Company_Code__c,Sales_Org_Code__c, SAP_Customer_Code__c, Sales_Org_Country__c FROM Account WHERE Id =: recordId AND RecordType.Name = 'Distributor'];
            Map<String, Grz_Customer360Settings__mdt> settingsMap = new Map<String, Grz_Customer360Settings__mdt>();
            for(Grz_Customer360Settings__mdt data: Grz_Customer360Settings__mdt.getAll().values()){
                settingsMap.put(data.Sales_Org_Code__c, data);
            }
            if(!accList.isEmpty()){
                if(settingsMap != null && settingsMap.containsKey(accList[0].Sales_Org_Code__c) && settingsMap.get(accList[0].Sales_Org_Code__c).Ledger_Statement_Access__c){
                    if(accList[0].Company_Code__c != null && accList[0].SAP_Customer_Code__c != null){
                        response.data = accList;
                    }else{
                        response.success = false;
                        response.message = 'Required_Data_Missing';
                    }
                }else{
                    response.success = false;
                    response.message = 'no_access';
                }
            }else{
                response.success = false;
                response.message = 'wrong_acc';
            }
        }catch(Exception ex) {
            response.success = false;
            response.message = ex.getMessage();
        }
        return response;
    }

    /******************************************************************************************************
    * @Description        : This method will return account ledger data 
    * Date                : 23/05/2022 
    * Author              : Nikhil Verma (Grazitti)                                                                  
    * @Return             : Wrapper
    * @LastModified       : Grz(Nikhil Verma) 31-08-2022 removed custom label setting and switched to metadata settings for better access control
                            also created new metadata to store doc type info for different country  
    *******************************************************************************************************/
    @AuraEnabled
    public static Grz_Customer360Wrapper.Wrapper getLedgerData(String customerCode, String companyCode, String fiscalYear, String fiscalYearFrom, String fiscalYearTo, String sapUserId, String salesOrgCode){
        Grz_Customer360Wrapper.Wrapper response = new Grz_Customer360Wrapper.Wrapper();
        try{
            String sapData;
            //Code Updated by Grz(Sumit Kumar) 17-02-2023 for Customer 360 New Integration Changes (Ticket No. APPS-5366)
            String fiscalYearCheck = System.Label.Grz_HanaFiscalYear;
            Map<String, Grz_Customer360IntegrationMappings__mdt> integrationSettingsMap = Grz_SapCommonIntegration.getIntegrationMappings();
            if(integrationSettingsMap != null && integrationSettingsMap.containsKey(salesOrgCode) && integrationSettingsMap.get(salesOrgCode).Country__c == 'India'){
                if(integrationSettingsMap.get(salesOrgCode).EndPointURL__c != null && Integer.ValueOf(fiscalYear) >= Integer.ValueOf(fiscalYearCheck)){  //Code Updated by Grz(Sumit Kumar) 22-05-2023 for Customer 360 New CR Changes
                    system.debug('fiscalYear : '+fiscalYear);
                    String endPointName = integrationSettingsMap.get(salesOrgCode).EndPointURL__c;
                	sapData = Grz_SapCommonIntegration.customerLedgerMarketingIND(customerCode, companyCode, fiscalYear, fiscalYearFrom, fiscalYearTo, sapUserId,endPointName);
                }else{
                    system.debug('fiscalYear in else : '+fiscalYear);
                	sapData = Grz_SapCommonIntegration.customerLedgerIND(customerCode, companyCode, fiscalYear, fiscalYearFrom, fiscalYearTo, sapUserId);
                }
            }else{
                sapData = Grz_SapCommonIntegration.customerLedger(customerCode, companyCode, fiscalYear, fiscalYearFrom, fiscalYearTo, sapUserId);
            }
            /*if(salesOrgCode == '1000' || salesOrgCode == '1510' || salesOrgCode == '1210' || salesOrgCode == '1410'){ // Added 1410 for New India SalesOrg APPS-1315 GRZ(Nikhil Verma) 27-09-2022
                sapData = Grz_SapCommonIntegration.customerLedgerIND(customerCode, companyCode, fiscalYear, fiscalYearFrom, fiscalYearTo, sapUserId);
            }else{
                sapData = Grz_SapCommonIntegration.customerLedger(customerCode, companyCode, fiscalYear, fiscalYearFrom, fiscalYearTo, sapUserId);
            }*/
            if(sapData == null || sapData == 'Error_In_Sap'){
                response.success = false;
                response.message = 'Error_In_SAP';
            }else{
                Decimal totalCredit = 0.0;
                Decimal totalDebit = 0.0;
                List<Grz_Customer360Wrapper.ItemInfo> filterInfo = new List<Grz_Customer360Wrapper.ItemInfo>();
                Grz_Customer360Wrapper.Grz_LedgerWrapper data = (Grz_Customer360Wrapper.Grz_LedgerWrapper) JSON.deserialize(sapData, Grz_Customer360Wrapper.Grz_LedgerWrapper.class);
                Map<String,Grz_Customer360_Doc_Type__mdt> docMap = new Map<String,Grz_Customer360_Doc_Type__mdt>();
                for(Grz_Customer360_Doc_Type__mdt doc: Grz_Customer360_Doc_Type__mdt.getAll().values()){
                    docMap.put(doc.Short_Form__c, doc);
                }
                String userLang = 'en_US__c'; 
                String currentLang = UserInfo.getLanguage().toLowerCase() + '__c';
                Schema.DescribeSObjectResult r = Grz_Customer360_Doc_Type__mdt.sObjectType.getDescribe();
                for(string apiName : r.fields.getMap().keySet()){
                    if(apiName == currentLang){
                        userLang = apiName;
                        break;
                    }
                }
                for(Grz_Customer360Wrapper.ItemInfo ifo : data.ItemInfo){
                    if(ifo.PostDate !='0000-00-00'){
                        if(docMap != null && docMap.get(ifo.DocType) != null && docMap.get(ifo.DocType).get(userLang) != null){
                            ifo.docDes = String.valueOf(docMap.get(ifo.DocType).get(userLang));
                        }else{
                            ifo.docDes = '-';
                        }
                        filterinfo.add(ifo);
                    }
                    totalCredit = totalCredit + Decimal.valueOf(ifo.Credit).setScale(2);
                    totalDebit = totalDebit + Decimal.valueOf(ifo.Debit).setScale(2);
                }
                data.ItemInfo = filterinfo;

                if(data.CustomerInfo.OpeningBalance.contains('-') && data.CustomerInfo.ClosingBalance.contains('-')){
                    response.totalCredit = String.valueOf(totalCredit - Decimal.valueOf(data.CustomerInfo.OpeningBalance));
                    response.totalDebit = String.valueOf(totalDebit - Decimal.valueOf(data.CustomerInfo.ClosingBalance));
                }else{
                    response.totalCredit = String.valueOf(totalCredit + Decimal.valueOf(data.CustomerInfo.ClosingBalance));
                    response.totalDebit = String.valueOf(totalDebit + Decimal.valueOf(data.CustomerInfo.OpeningBalance));
                }
                if(data.CustomerInfo.OpeningBalance.contains('-') && !data.CustomerInfo.ClosingBalance.contains('-')){
                    response.totalCredit = String.valueOf(totalCredit + Decimal.valueOf(data.CustomerInfo.ClosingBalance) - Decimal.valueOf(data.CustomerInfo.OpeningBalance));
                    response.totalDebit = String.valueOf(totalDebit);
                }else if(!data.CustomerInfo.OpeningBalance.contains('-') && data.CustomerInfo.ClosingBalance.contains('-')){
                    response.totalDebit = String.valueOf(totalDebit + Decimal.valueOf(data.CustomerInfo.OpeningBalance) - Decimal.valueOf(data.CustomerInfo.ClosingBalance));
                    response.totalCredit = String.valueOf(totalCredit);
                }
                response.data = data;
                response.CustomerInfo = data.CustomerInfo;
                response.ItemInfo = data.ItemInfo;
                
            }
        }catch(Exception ex) {
            response.success = false;
            response.message = ex.getMessage();
        }
        return response;
    }

    /******************************************************************************************************
    * @Description        : This method is VF action for XLS and PDF visual force page
    * Date                : 25/05/2022 
    * Author              : Nikhil Verma (Grazitti)                                                                  
    *******************************************************************************************************/
    public void getDataForVF() {
        Grz_Customer360Wrapper.LabelsWrapper wrappper = (Grz_Customer360Wrapper.LabelsWrapper) JSON.deserialize(System.Label.Grz_AccountLedgerTranslation, Grz_Customer360Wrapper.LabelsWrapper.class);        
        String customerCode = ApexPages.currentPage().getParameters().get('customerCode');
        String companyCode = ApexPages.currentPage().getParameters().get('companyCode');
        String sapUserId = ApexPages.currentPage().getParameters().get('sapUserId');
        String fiscalYear = ApexPages.currentPage().getParameters().get('fiscalYear');
        String fiscalYearFrom = ApexPages.currentPage().getParameters().get('fiscalYearFrom');
        String fiscalYearTo = ApexPages.currentPage().getParameters().get('fiscalYearTo');
        String salesOrgCode = ApexPages.currentPage().getParameters().get('salesOrgCode');
        vfYear = ApexPages.currentPage().getParameters().get('vfYear');
        vfMonth = ApexPages.currentPage().getParameters().get('vfMonth');
        Apexpages.currentPage().getHeaders().put('content-disposition', 'attachment; filename=' + ApexPages.currentPage().getParameters().get('fileName'));

        Grz_Customer360Wrapper.Wrapper wrapData = getLedgerData(customerCode, companyCode, fiscalYear, fiscalYearFrom, fiscalYearTo, sapUserId, salesOrgCode);          
        if (wrapData.customerInfo.ClosingBalance.contains('-') && wrapData.customerInfo.OpeningBalance.contains('-')) {
          openingNegativeBalance = wrapData.customerInfo.OpeningBalance.replace('-','');
          openingPositiveBalance = '';
          closingNegativeBalance = wrapData.customerInfo.ClosingBalance.replace('-','');
          closingPositiveBalance = '';
        } else {
          openingNegativeBalance = '';
          openingPositiveBalance = wrapData.customerInfo.OpeningBalance;
          closingNegativeBalance = '';
          closingPositiveBalance = wrapData.customerInfo.ClosingBalance;
        }
        if (wrapData.customerInfo.OpeningBalance.contains('-') && !wrapData.customerInfo.ClosingBalance.contains('-')) {
          openingNegativeBalance = wrapData.customerInfo.OpeningBalance.replace('-','');
          openingPositiveBalance = '';
          closingNegativeBalance = '';
          closingPositiveBalance = wrapData.customerInfo.ClosingBalance;
        } else if (!wrapData.customerInfo.OpeningBalance.contains('-') && wrapData.customerInfo.ClosingBalance.contains('-')) {
          openingNegativeBalance = '';
          openingPositiveBalance = wrapData.customerInfo.OpeningBalance;
          closingNegativeBalance = wrapData.customerInfo.ClosingBalance.replace('-','');
          closingPositiveBalance = '';
        }
        customerInfo = wrapData.customerInfo;
        totalCredit = wrapData.totalCredit;
        totalDebit = wrapData.totalDebit;
        ItemInfo = wrapData.ItemInfo;
        labels = wrappper;
    }
}