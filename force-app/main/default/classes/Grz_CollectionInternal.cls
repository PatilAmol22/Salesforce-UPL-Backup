/**************************************************************************************************
* Name               : Grz_CollectionInternal                                                      
* Description        : Controller class for grz_CollectionInternal LWC Component
* Created Date       : 16/06/2022                                                                 
* Created By         : Nikhil Verma (Grazitti)                                                                       
**************************************************************************************************/                                            
public with sharing class Grz_CollectionInternal {

    public static Grz_Customer360Wrapper.Item collection    {get;set;}
    public Grz_Customer360Wrapper.LabelsWrapper labels      {get;set;}
    public String Name                                      {get;set;}
    public String sapCode                                   {get;set;}
    public static String vfYear                             {get;set;}
    public static String vfMonth                            {get;set;}
    
    /******************************************************************************************************
    * @Description        : This method will return selected account data 
    * Date                : 16/06/2022 
    * Author              : Nikhil Verma (Grazitti)                                                                  
    * @Return             : Grz_Customer360Wrapper.Wrapper
    * @Params             : recordId  
    * @LastModified       : Grz(Nikhil Verma) 31-08-2022 removed custom label setting and switched to metadata settings for better access control
    *******************************************************************************************************/
    @AuraEnabled(cacheable = true)
    public static Grz_Customer360Wrapper.Wrapper getData(String recordId){
        Grz_Customer360Wrapper.Wrapper response = new Grz_Customer360Wrapper.Wrapper();
        try{
            List<Account> accList = [SELECT Id,Name, Sap_UserId__c, Company_Code__c,Sales_Org_Code__c, SAP_Customer_Code__c, Sales_Org_Country__c FROM Account WHERE Id =: recordId AND RecordType.Name = 'Distributor'];
            Map<String, Grz_Customer360Settings__mdt> settingsMap = new Map<String, Grz_Customer360Settings__mdt>();
            for(Grz_Customer360Settings__mdt data: Grz_Customer360Settings__mdt.getAll().values()){
                settingsMap.put(data.Sales_Org_Code__c, data);
            }
            if(!accList.isEmpty()){
                if(settingsMap != null && settingsMap.containsKey(accList[0].Sales_Org_Code__c) && settingsMap.get(accList[0].Sales_Org_Code__c).Collection_Access__c){
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
    * @Description        : This method will return collection data 
    * Date                : 16/06/2022
    * Author              : Nikhil Verma (Grazitti)                                                                  
    * @Return             : Grz_Customer360Wrapper.Wrapper
    * @LastModified       : Grz(Nikhil Verma) 31-08-2022 removed custom label setting and switched to metadata settings for better access control
    *******************************************************************************************************/
    @AuraEnabled
    public static Grz_Customer360Wrapper.Wrapper getCollectionData(String customerCode, String companyCode, String fiscalYear, String fiscalPeriod, String sapUserId, String salesOrgCode){
        Grz_Customer360Wrapper.Wrapper response = new Grz_Customer360Wrapper.Wrapper();
        Map<String, Grz_Customer360Settings__mdt> settingsMap = new Map<String, Grz_Customer360Settings__mdt>();
        for(Grz_Customer360Settings__mdt data: Grz_Customer360Settings__mdt.getAll().values()){
            settingsMap.put(data.Sales_Org_Code__c, data);
        }
        try{
            String sapData;
            //Code Updated by Grz(Sumit Kumar) 17-02-2023 for Customer 360 New Integration Changes (Ticket No. APPS-5366)
            String fiscalYearCheck = System.Label.Grz_HanaFiscalYear;
            Map<String, Grz_Customer360IntegrationMappings__mdt> integrationSettingsMap = Grz_SapCommonIntegration.getIntegrationMappings();
            if(integrationSettingsMap != null && integrationSettingsMap.containsKey(salesOrgCode) && integrationSettingsMap.get(salesOrgCode).Country__c == 'India'){
                if(integrationSettingsMap.get(salesOrgCode).EndPointURL__c != null && Integer.ValueOf(fiscalYear) >= Integer.ValueOf(fiscalYearCheck)){  //Code Updated by Grz(Sumit Kumar) 18-05-2023 for Customer 360 New Integration Changes (Ticket No. APPS-5366)
                    system.debug('fiscalYear : '+fiscalYear);
                    String endPointName = integrationSettingsMap.get(salesOrgCode).EndPointURL__c;
                	sapData = Grz_SapCommonIntegration.collectionMarketingIND(customerCode, companyCode, fiscalYear, fiscalPeriod, sapUserId,endPointName);
                }else{
                    system.debug('fiscalYear else : '+fiscalYear);
                	sapData = Grz_SapCommonIntegration.collectionIND(customerCode, companyCode, fiscalYear, fiscalPeriod, sapUserId);
                }
            }else{
                sapData = Grz_SapCommonIntegration.collection(customerCode, companyCode, fiscalYear, fiscalPeriod, sapUserId);
            }
            
            /*if(salesOrgCode == '1000' || salesOrgCode == '1510' || salesOrgCode == '1210' || salesOrgCode == '1410'){ // Added 1410 for New India SalesOrg APPS-1315 GRZ(Nikhil Verma) 27-09-2022
                sapData = Grz_SapCommonIntegration.collectionIND(customerCode, companyCode, fiscalYear, fiscalPeriod, sapUserId);
            }else{
                sapData = Grz_SapCommonIntegration.collection(customerCode, companyCode, fiscalYear, fiscalPeriod, sapUserId);
            }*/
            
            if(sapData == null || sapData == 'Error_In_Sap'){
                response.success = false;
                response.message = 'Error_In_SAP';
            }else{
                sapData = sapData.replace('"desc":', '"desc_z":').replace('"Return"', '"ReturnData"');
                Grz_Customer360Wrapper.Grz_CollectionWrapper data = (Grz_Customer360Wrapper.Grz_CollectionWrapper) JSON.deserialize(sapData, Grz_Customer360Wrapper.Grz_CollectionWrapper.class);
                if(sapData.contains('"item":')){
                    for(Grz_Customer360Wrapper.Item itm : data.item){
                        if(itm.currencyKey != null && itm.currencyKey != ''){
                            if(settingsMap.get(salesOrgCode).Collection_Currency__c != null && itm.currencyKey == settingsMap.get(salesOrgCode).Collection_Currency__c){
                                response.collection = itm;
                                break;
                            }else if(itm.currencyKey == 'USD'){
                                response.collection = itm;
                            }
                        }
                    }
                }else if(data.ReturnData.Message != '' || data.ReturnData.Message != null){
                    response.success = false;
                    response.message = data.ReturnData.Message;
                }else{
                    response.success = false;
                    response.message = 'Something went wrong.';
                }
            }
        }catch(Exception ex) {
            response.success = false;
            response.message = ex.getMessage();
        }
        return response;
    }

    /******************************************************************************************************
    * @Description        : This method is VF action for XLS and PDF visual force page
    * Date                : 16/06/2022
    * Author              : Nikhil Verma (Grazitti)                                                                  
    *******************************************************************************************************/
    public void getDataForVF() {
        Grz_Customer360Wrapper.LabelsWrapper wrappper = (Grz_Customer360Wrapper.LabelsWrapper) JSON.deserialize(System.Label.Grz_CollectionTranslation, Grz_Customer360Wrapper.LabelsWrapper.class);        
        String customerCode = ApexPages.currentPage().getParameters().get('customerCode');
        String companyCode = ApexPages.currentPage().getParameters().get('companyCode');
        String sapUserId = ApexPages.currentPage().getParameters().get('sapUserId');
        Name = ApexPages.currentPage().getParameters().get('name');
        String fiscalYear = ApexPages.currentPage().getParameters().get('fiscalYear');
        String fiscalPeriod = ApexPages.currentPage().getParameters().get('fiscalPeriod');
        String salesOrgCode = ApexPages.currentPage().getParameters().get('salesOrgCode');
        vfYear = ApexPages.currentPage().getParameters().get('vfYear');
        vfMonth = ApexPages.currentPage().getParameters().get('vfMonth');
        Apexpages.currentPage().getHeaders().put('content-disposition', 'attachment; filename=' + ApexPages.currentPage().getParameters().get('fileName'));

        Grz_Customer360Wrapper.Wrapper wrapData = getCollectionData(customerCode, companyCode, fiscalYear, fiscalPeriod, sapUserId, salesOrgCode);       
        collection = wrapData.collection;
        labels = wrappper;
        sapCode = customerCode;
    }
}