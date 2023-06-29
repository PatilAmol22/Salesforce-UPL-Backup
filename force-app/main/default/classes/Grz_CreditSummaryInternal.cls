/**************************************************************************************************
* Name               : Grz_CreditSummaryInternal                                                      
* Description        : Controller class for Grz_CreditSummaryInternal LWC Component
* Created Date       : 23/05/2022                                                                 
* Created By         : Nikhil Verma (Grazitti)                                                                       
**************************************************************************************************/                                            
public with sharing class Grz_CreditSummaryInternal {
    public String CreditLimit                               {get;set;}
    public String CreditExposure                            {get;set;}
    public String BalanceLimit                              {get;set;}
    public String Percentage                                {get;set;}
    public String sapCode                                   {get;set;}
    public String Name                                      {get;set;}
    public Grz_Customer360Wrapper.LabelsWrapper labels      {get;set;}

    /******************************************************************************************************
    * @Description        : This method will return Credit Summary Data received from SAP 
    * Date                : 23/05/2022 
    * Author              : Nikhil Verma (Grazitti)                                                                  
    * @Return             : Grz_Customer360Wrapper.Wrapper
    * @Params             : recordId    
    * @LastModified       : Grz(Dheeraj Sharma) 20-01-2023 Add company code and sales org code for place order page                                                            
    *******************************************************************************************************/
    @AuraEnabled(cacheable = true)
    public static Grz_Customer360Wrapper.Wrapper getData(String recordId,String Comp_Code, String sCode){   		
        Grz_Customer360Wrapper.Wrapper response = new Grz_Customer360Wrapper.Wrapper();
        try{
            List<Account> accList = [SELECT Id,Name, Sap_UserId__c, Company_Code__c, SAP_Customer_Code__c,Sales_Org_Code__c, Sales_Org_Country__c FROM Account WHERE Id =: recordId AND RecordType.Name = 'Distributor'];
            system.debug('accList : '+accList);
            Map<String, Grz_Customer360Settings__mdt> settingsMap = new Map<String, Grz_Customer360Settings__mdt>();
            for(Grz_Customer360Settings__mdt data: Grz_Customer360Settings__mdt.getAll().values()){
                settingsMap.put(data.Sales_Org_Code__c, data);
            }
            Map<String, Grz_Customer360IntegrationMappings__mdt> integrationSettingsMap = Grz_SapCommonIntegration.getIntegrationMappings();
            
            if(!accList.isEmpty()){
                if(Comp_Code == null || Comp_Code == ''){                
                    Comp_Code = accList[0].Company_Code__c;								
                    sCode = accList[0].Sales_Org_Code__c;
                }
                //Code Updated by Grz(Sumit Kumar) 17-02-2023 for Customer 360 New Integration Changes
                if(settingsMap != null && settingsMap.containsKey(sCode) && settingsMap.get(sCode).Credit_Summary_Access__c){
                    if(Comp_Code != null && accList[0].SAP_Customer_Code__c != null){                                  		
                        String sapData;
                        String sapUserId = System.Label.Grz_SapUserId;
                        if(integrationSettingsMap != null && integrationSettingsMap.containsKey(sCode) && integrationSettingsMap.get(sCode).Country__c == 'India'){
                            if(integrationSettingsMap.get(sCode).EndPointURL__c != null){
                                String endPointName = integrationSettingsMap.get(sCode).EndPointURL__c;
                                sapData = Grz_SapCommonIntegration.creditSummaryMarketingIND(Comp_Code, accList[0].SAP_Customer_Code__c, sapUserId,endPointName);
                            }else{
                            	sapData = Grz_SapCommonIntegration.creditSummaryIND(Comp_Code, accList[0].SAP_Customer_Code__c, sapUserId);                         		                                
                            }
                        }else{
                            sapData = Grz_SapCommonIntegration.creditSummary(Comp_Code, accList[0].SAP_Customer_Code__c, sapUserId);                             	 
                        }
                        /*if(accList[0].Sales_Org_Code__c == '1000' || accList[0].Sales_Org_Code__c == '1510' || accList[0].Sales_Org_Code__c == '1210' || accList[0].Sales_Org_Code__c == '1410'){ // Added 1410 for New India SalesOrg APPS-1315 GRZ(Nikhil Verma) 27-09-2022
                            sapData = Grz_SapCommonIntegration.creditSummaryIND(Comp_Code, accList[0].SAP_Customer_Code__c, sapUserId);                         		
                        }else{
                            sapData = Grz_SapCommonIntegration.creditSummary(Comp_Code, accList[0].SAP_Customer_Code__c, sapUserId);                             	 
                        }*/
                        if(sapData == null || sapData == 'Error_In_Sap' || (sapData != null && !sapData.contains('CreditInfo'))){
                            response.success = false;
                            response.message = 'Error_In_SAP';
                        }else{
                            sapData = sapData.replace('Balance_Limit__c','BalanceLimit').replace('Used_Limit__c','CreditExposure').replace('Credit_limit__c','CreditLimit').replace('Credit_control_area','credit_control');
                            Grz_Customer360Wrapper.Grz_CreditSummaryWrapper data = (Grz_Customer360Wrapper.Grz_CreditSummaryWrapper) JSON.deserialize(sapData, Grz_Customer360Wrapper.Grz_CreditSummaryWrapper.class);
                            List<Grz_Customer360Wrapper.Credit> creditList = new List<Grz_Customer360Wrapper.Credit>();
                            List<Grz_Customer360Wrapper.Credit> creditList1 = new List<Grz_Customer360Wrapper.Credit>();
                            for(Grz_Customer360Wrapper.Credit ci : data.CreditInfo){
                                if(ci.Percentage == null && ci.CreditLimit != '0.0'){
                                    ci.Percentage = String.valueOf(((decimal.valueOf(ci.CreditExposure) / decimal.valueOf(ci.CreditLimit) ) * 100).setScale(2));
                                }
                                if(ci.credit_control != null && ci.credit_control != ''){
                                    if(settingsMap.get(sCode).Credit_Control_Area__c != null && ci.credit_control == settingsMap.get(sCode).Credit_Control_Area__c){
                                    
                                        creditList.add(ci);
                                        System.debug('creditList'+creditList);
                                        break;
                                    }
                                }
                            }
                            if(creditList.size() > 0){
                                response.data = creditList; 
                                response.account = accList; 
                            }else{
                                response.success = false;
                                response.message = 'no_mapping';
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
    * Date                : 25/05/2022 
    * Author              : Nikhil Verma (Grazitti)                                                                  
    *******************************************************************************************************/
    public void getDataForVF() {
        CreditLimit = ApexPages.currentPage().getParameters().get('CreditLimit');
        CreditExposure = ApexPages.currentPage().getParameters().get('CreditExposure');
        BalanceLimit = ApexPages.currentPage().getParameters().get('BalanceLimit');
        Percentage = ApexPages.currentPage().getParameters().get('Percentage') + '%';
        Name = ApexPages.currentPage().getParameters().get('Name');
        String fileFormatAndName = ApexPages.currentPage().getParameters().get('fileName');
        Apexpages.currentPage().getHeaders().put('content-disposition', 'attachment; filename=' + fileFormatAndName);
        sapCode = fileFormatAndName.subStringbefore('-');
        Grz_Customer360Wrapper.LabelsWrapper wrappper = (Grz_Customer360Wrapper.LabelsWrapper) JSON.deserialize(System.Label.Grz_CreditSummaryTranslation, Grz_Customer360Wrapper.LabelsWrapper.class);
        labels = wrappper;
    }
}