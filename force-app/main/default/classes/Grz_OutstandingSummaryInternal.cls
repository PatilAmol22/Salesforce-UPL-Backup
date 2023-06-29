/**************************************************************************************************
* Name               : Grz_OutstandingSummaryInternal                                                      
* Description        : Controller class for grz_OutstandingSummaryInternal LWC Component
* Created Date       : 27/05/2022                                                                 
* Created By         : Nikhil Verma (Grazitti)                                                                       
**************************************************************************************************/                                            
public with sharing class Grz_OutstandingSummaryInternal {
    public Grz_Customer360Wrapper.LabelsWrapper labels                     {get;set;}
    public Grz_Customer360Wrapper.Grz_OutstandingWrapper finalData         {get;set;}

    /******************************************************************************************************
    * @Description        : This method will return Outstanding Summary Data received from SAP 
    * Date                : 27/05/2022 
    * Author              : Nikhil Verma (Grazitti)                                                                  
    * @Return             : Grz_Customer360Wrapper.Wrapper
    * @Params             : recordId                                                                         
    * @LastModified       : Grz(Nikhil Verma) 31-08-2022 removed custom label setting and switched to metadata settings for better access control                                                                          
    *******************************************************************************************************/
    @AuraEnabled(cacheable = true)
    public static Grz_Customer360Wrapper.Wrapper getData(String recordId,String companyCode){
        Grz_Customer360Wrapper.Wrapper response = new Grz_Customer360Wrapper.Wrapper();
        try{
            List<Account> accList = [SELECT Id,Name,Distribution_Channnel_Code__c,Division_Code__c,Sales_Org_Code__c, Sap_UserId__c, Company_Code__c, SAP_Customer_Code__c, Sales_Org_Country__c FROM Account WHERE Id =: recordId AND RecordType.Name = 'Distributor'];
            Map<String, Grz_Customer360Settings__mdt> settingsMap = new Map<String, Grz_Customer360Settings__mdt>();
            for(Grz_Customer360Settings__mdt data: Grz_Customer360Settings__mdt.getAll().values()){
                settingsMap.put(data.Sales_Org_Code__c, data);
            }
            
            Map<String, Grz_Customer360IntegrationMappings__mdt> integrationSettingsMap = Grz_SapCommonIntegration.getIntegrationMappings();
            
            if(!accList.isEmpty()){
                //Changes by Grazitti team for India SWOT requirements 11Oct22
                if(companyCode!='' || (settingsMap != null && settingsMap.containsKey(accList[0].Sales_Org_Code__c) && settingsMap.get(accList[0].Sales_Org_Code__c).Outstanding_Summary_Access__c)){
                   List<Sales_Org__c> soList=new List<Sales_Org__c>();
                    if(companyCode!=''){
                        List<String> salesOrgCodeList = System.Label.Grz_IndiaSalesOrgCode.trim().Split(',');
                         soList=[Select Sales_Org_Code__c from Sales_Org__c where Company_Code__c=:companyCode and  Sales_Org_Code__c IN :salesOrgCodeList limit 1];
                    }
                    system.debug('soList-->'+soList);
                    String distributionCode = '';
                    String  divisionCode = '';
                    if(accList[0].Company_Code__c != null && accList[0].SAP_Customer_Code__c != null){
                        if(accList[0].Distribution_Channnel_Code__c != null){
                            distributionCode = accList[0].Distribution_Channnel_Code__c;
                        }
                        if(accList[0].Division_Code__c != null){
                            divisionCode = accList[0].Division_Code__c;
                        }
                        String sapData;
                        String sapUserId = System.Label.Grz_SapUserId;
                        
                        String companyCodeFinal;
                        String salesOrgCodeFinal;
                        if(companyCode==''){
                            companyCodeFinal = accList[0].Company_Code__c;
                            salesOrgCodeFinal = accList[0].Sales_Org_Code__c;
                        }else if(companyCode!='' && !soList.isEmpty()){
                            companyCodeFinal = companyCode;
                            salesOrgCodeFinal = soList[0].Sales_Org_Code__c;
                        }
                        //Code Updated by Grz(Sumit Kumar) 17-02-2023 for Customer 360 New Integration Changes
                        if(integrationSettingsMap != null && integrationSettingsMap.containsKey(accList[0].Sales_Org_Code__c) && integrationSettingsMap.get(accList[0].Sales_Org_Code__c).Country__c == 'India'){
                            if(integrationSettingsMap.get(accList[0].Sales_Org_Code__c).EndPointURL__c != null){
                                String endPointName = integrationSettingsMap.get(accList[0].Sales_Org_Code__c).EndPointURL__c;
                                sapData = Grz_SapCommonIntegration.customerOutstandingMarketingIND(accList[0].SAP_Customer_Code__c, companyCodeFinal, salesOrgCodeFinal, distributionCode, divisionCode, sapUserId, endPointName);                         		                                  
                            }else{
                            	sapData = Grz_SapCommonIntegration.customerOutstandingIND(accList[0].SAP_Customer_Code__c, companyCodeFinal, salesOrgCodeFinal, distributionCode, divisionCode, sapUserId );
                            }
                        }else{
                            sapData = Grz_SapCommonIntegration.customerOutstanding(accList[0].SAP_Customer_Code__c, accList[0].Company_Code__c, accList[0].Sales_Org_Code__c, distributionCode, divisionCode, sapUserId );
                        }
                        
                        /*if(accList[0].Sales_Org_Code__c == '1000' || accList[0].Sales_Org_Code__c == '1510' || accList[0].Sales_Org_Code__c == '1210' || accList[0].Sales_Org_Code__c == '1410'){ // Added 1410 for New India SalesOrg APPS-1315 GRZ(Nikhil Verma) 27-09-2022
                            //Changes by Grazitti team for India SWOT requirements 11Oct22
                            if(companyCode=='')
                            sapData = Grz_SapCommonIntegration.customerOutstandingIND(accList[0].SAP_Customer_Code__c, accList[0].Company_Code__c, accList[0].Sales_Org_Code__c, distributionCode, divisionCode, sapUserId );
                            else if(companyCode!='' && !soList.isEmpty())
                            sapData = Grz_SapCommonIntegration.customerOutstandingIND(accList[0].SAP_Customer_Code__c, companyCode, soList[0].Sales_Org_Code__c, distributionCode, divisionCode, sapUserId );
                        }else{
                            sapData = Grz_SapCommonIntegration.customerOutstanding(accList[0].SAP_Customer_Code__c, accList[0].Company_Code__c, accList[0].Sales_Org_Code__c, distributionCode, divisionCode, sapUserId );
                        }*/
                        system.debug('sapData-->'+JSON.serializePretty(sapData));
                        if(sapData == null || sapData == 'Error_In_Sap'){
                            response.success = false;
                            response.message = 'Error_In_SAP';
                        }else{
                            sapData = sapData.replace('"Return"', '"ReturnData"');
                            Grz_Customer360Wrapper.Grz_OutstandingWrapper data = (Grz_Customer360Wrapper.Grz_OutstandingWrapper) JSON.deserialize(sapData, Grz_Customer360Wrapper.Grz_OutstandingWrapper.class);
                            if(sapData.contains('"item":')){
                                data.item.greater90 = String.valueOf(decimal.valueOf(data.item.bucket5) + decimal.valueOf(data.item.bucket6) + decimal.valueOf(data.item.bucket7) + decimal.valueOf(data.item.bucket8) + decimal.valueOf(data.item.bucket9));
                                response.data = data.item;
                                response.items = data.item;
                                response.account = accList;
                                //Changes by Grazitti team for India SWOT requirements 11Oct22
                                response.success=true;
                            }else if(data.ReturnData.Message != '' || data.ReturnData.Message != null){
                                response.success = false;
                                response.message = data.ReturnData.Message;
                            }else{
                                response.success = false;
                                response.message = 'Something went wrong.';
                            } 
                        }
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
    * @Description        : This method is VF action for XLS and PDF visual force page
    * Date                : 27/05/2022 
    * Author              : Nikhil Verma (Grazitti)                                                                  
    *******************************************************************************************************/
    public void getDataForVF() {
        String outstandingData = ApexPages.currentPage().getParameters().get('OutstandingData');
        Apexpages.currentPage().getHeaders().put('content-disposition', 'attachment; filename=' + ApexPages.currentPage().getParameters().get('fileName'));
        Grz_Customer360Wrapper.LabelsWrapper wrappper = (Grz_Customer360Wrapper.LabelsWrapper) JSON.deserialize(System.Label.Grz_OutstandingSummaryTranslation, Grz_Customer360Wrapper.LabelsWrapper.class);
        labels = wrappper;
        Grz_Customer360Wrapper.Grz_OutstandingWrapper data = (Grz_Customer360Wrapper.Grz_OutstandingWrapper) JSON.deserialize(outstandingData, Grz_Customer360Wrapper.Grz_OutstandingWrapper.class);
        finalData = data;
    }
    
    //Changes by Grazitti team for India SWOT requirements 11Oct22
    ////Change by Aashima(Grazitti) for APPS-4027 28Dec22
    @AuraEnabled(cacheable = true)
    public static List<DistributorSalesAreaMapping__c> getSalesAreaValues(String recordId) {
        Map<String,DistributorSalesAreaMapping__c> dsaMap=new Map<String,DistributorSalesAreaMapping__c>();
        for(DistributorSalesAreaMapping__c dsa:[Select Id,SalesOrg__r.name,Sales_Org_Code__c,Company_Code__c from DistributorSalesAreaMapping__c where Distributor__c=:recordId]){  // Change by Sumit(Grazitti) for APPS-4636 25 Jan,2023
            dsaMap.put(dsa.SalesOrg__r.name,dsa);
        }
        return dsaMap.values();
    }

    /******************************************************************************************************
    * @Description        : This method will return Outstanding Summary Data received from SAP 
    * Date                : 26/06/2023 
    * Author              : Nikhil Verma (Grazitti) RITM0579566                                                                 
    *******************************************************************************************************/
    @AuraEnabled(cacheable = true)
    public static Grz_Customer360Wrapper.Wrapper getOutstanding360Data(String recordId,String Comp_Code, String sCode){
        Grz_Customer360Wrapper.Wrapper response = new Grz_Customer360Wrapper.Wrapper();
        try{
            List<Account> accList = [SELECT Id,Name,Distribution_Channnel_Code__c,Division_Code__c,Sales_Org_Code__c, Sap_UserId__c, Company_Code__c, SAP_Customer_Code__c, Sales_Org_Country__c FROM Account WHERE Id =: recordId AND RecordType.Name = 'Distributor'];
            Map<String, Grz_Customer360Settings__mdt> settingsMap = new Map<String, Grz_Customer360Settings__mdt>();
            for(Grz_Customer360Settings__mdt data: Grz_Customer360Settings__mdt.getAll().values()){
                settingsMap.put(data.Sales_Org_Code__c, data);
            }
            String companyCodeFinal;
            String salesOrgCodeFinal;
            if(Comp_Code == null || Comp_Code == ''){
                companyCodeFinal = accList[0].Company_Code__c;
                salesOrgCodeFinal = accList[0].Sales_Org_Code__c;
            }else{
                companyCodeFinal = Comp_Code;
                salesOrgCodeFinal = sCode;
            }
            Map<String, Grz_Customer360IntegrationMappings__mdt> integrationSettingsMap = Grz_SapCommonIntegration.getIntegrationMappings();
            if(!accList.isEmpty()){
                if(settingsMap != null && settingsMap.containsKey(accList[0].Sales_Org_Code__c) && settingsMap.get(accList[0].Sales_Org_Code__c).Outstanding_Summary_Access__c){
                    String distributionCode = '';
                    String  divisionCode = '';
                    if(accList[0].Company_Code__c != null && accList[0].SAP_Customer_Code__c != null){
                        if(accList[0].Distribution_Channnel_Code__c != null){
                            distributionCode = accList[0].Distribution_Channnel_Code__c;
                        }
                        if(accList[0].Division_Code__c != null){
                            divisionCode = accList[0].Division_Code__c;
                        }
                        String sapData;
                        String sapUserId = System.Label.Grz_SapUserId;
                        //Code Updated by Grz(Sumit Kumar) 17-02-2023 for Customer 360 New Integration Changes
                        if(integrationSettingsMap != null && integrationSettingsMap.containsKey(salesOrgCodeFinal) && integrationSettingsMap.get(salesOrgCodeFinal).Country__c == 'India'){
                            if(integrationSettingsMap.get(salesOrgCodeFinal).EndPointURL__c != null){
                                String endPointName = integrationSettingsMap.get(salesOrgCodeFinal).EndPointURL__c;
                                sapData = Grz_SapCommonIntegration.customerOutstandingMarketingIND(accList[0].SAP_Customer_Code__c, companyCodeFinal, salesOrgCodeFinal, distributionCode, divisionCode, sapUserId, endPointName);                         		                                  
                            }else{
                            	sapData = Grz_SapCommonIntegration.customerOutstandingIND(accList[0].SAP_Customer_Code__c, companyCodeFinal, salesOrgCodeFinal, distributionCode, divisionCode, sapUserId );
                            }
                        }else{
                            sapData = Grz_SapCommonIntegration.customerOutstanding(accList[0].SAP_Customer_Code__c, companyCodeFinal, salesOrgCodeFinal, distributionCode, divisionCode, sapUserId );
                        }
                        system.debug('sapData-->'+JSON.serializePretty(sapData));
                        if(sapData == null || sapData == 'Error_In_Sap'){
                            response.success = false;
                            response.message = 'Error_In_SAP';
                        }else{
                            sapData = sapData.replace('"Return"', '"ReturnData"');
                            Grz_Customer360Wrapper.Grz_OutstandingWrapper data = (Grz_Customer360Wrapper.Grz_OutstandingWrapper) JSON.deserialize(sapData, Grz_Customer360Wrapper.Grz_OutstandingWrapper.class);
                            if(sapData.contains('"item":')){
                                data.item.greater90 = String.valueOf(decimal.valueOf(data.item.bucket5) + decimal.valueOf(data.item.bucket6) + decimal.valueOf(data.item.bucket7) + decimal.valueOf(data.item.bucket8) + decimal.valueOf(data.item.bucket9));
                                response.data = data.item;
                                response.items = data.item;
                                response.account = accList;
                                response.success=true;
                            }else if(data.ReturnData.Message != '' || data.ReturnData.Message != null){
                                response.success = false;
                                response.message = data.ReturnData.Message;
                            }else{
                                response.success = false;
                                response.message = 'Something went wrong.';
                            } 
                        }
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
}