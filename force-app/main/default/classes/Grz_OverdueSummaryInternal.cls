/**************************************************************************************************
* Name               : Grz_OverdueSummaryInternal                                                      
* Description        : Controller class for grz_OverdueSummaryInternal LWC Component
* Created Date       : 26/05/2022                                                                 
* Created By         : Nikhil Verma (Grazitti)                                                                       
**************************************************************************************************/                                            
public with sharing class Grz_OverdueSummaryInternal {

    public static List<Grz_Customer360Wrapper.Lineitems> lineItems          {get;set;}
    public String cstName                                                   {get;set;}
    public String customerNumber                                            {get;set;}
    public Decimal totalOutstanding                                         {get;set;}
    public Grz_Customer360Wrapper.LabelsWrapper labels                      {get;set;}
    
    /******************************************************************************************************
    * @Description        : This method will return selected account data 
    * Date                : 26/05/2022 
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
            List<Account> accList = [SELECT Id,Name, Sap_UserId__c, Company_Code__c, SAP_Customer_Code__c,Sales_Org_Code__c, Sales_Org_Country__c FROM Account WHERE Id =: recordId AND RecordType.Name = 'Distributor'];
            Map<String, Grz_Customer360Settings__mdt> settingsMap = new Map<String, Grz_Customer360Settings__mdt>();
            for(Grz_Customer360Settings__mdt data: Grz_Customer360Settings__mdt.getAll().values()){
                settingsMap.put(data.Sales_Org_Code__c, data);
            }
            if(!accList.isEmpty()){
                if(settingsMap != null && settingsMap.containsKey(accList[0].Sales_Org_Code__c) && settingsMap.get(accList[0].Sales_Org_Code__c).Overdue_Summary_Access__c){
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
    * @Description        : This method will return overdue data 
    * Date                : 26/05/2022 
    * Author              : Nikhil Verma (Grazitti)                                                                  
    * @Return             : Grz_Customer360Wrapper.Wrapper
    * @LastModified       : Grz(Nikhil Verma) 31-08-2022 removed custom label setting and switched to metadata settings for better access control
                            also created new metadata to store doc type info for different country  
    *******************************************************************************************************/
    @AuraEnabled
    public static Grz_Customer360Wrapper.Wrapper getOverdueData(String customerNumber, String sapUserId,String companyCode, String startDate, String endDate, String salesOrgCode){
        Grz_Customer360Wrapper.Wrapper response = new Grz_Customer360Wrapper.Wrapper();
        try{
            DateTime todaysDate = System.today();
            Date keyDate = todaysDate.dateGMT();
            String sapData;
            
            Map<String, Grz_Customer360IntegrationMappings__mdt> integrationSettingsMap = Grz_SapCommonIntegration.getIntegrationMappings();
            if(integrationSettingsMap != null && integrationSettingsMap.containsKey(salesOrgCode) && integrationSettingsMap.get(salesOrgCode).Country__c == 'India'){
                if(integrationSettingsMap.get(salesOrgCode).EndPointURL__c != null){
                    String endPointName = integrationSettingsMap.get(salesOrgCode).EndPointURL__c;
                	sapData = Grz_SapCommonIntegration.overdueSummaryMarketingIND(customerNumber, sapUserId, companyCode, String.ValueOf(keyDate), 'x', 'x',endPointName);
                }else{
                	sapData = Grz_SapCommonIntegration.overdueSummaryIND(customerNumber, sapUserId, companyCode, String.ValueOf(keyDate), 'x', 'x');
                }
            }else{
                sapData = Grz_SapCommonIntegration.overdueSummary(customerNumber, sapUserId, companyCode, String.ValueOf(keyDate), 'x', 'x');
            }
            
            /*if(salesOrgCode == '1000' || salesOrgCode == '1510' || salesOrgCode == '1210' || salesOrgCode == '1410'){ // Added 1410 for New India SalesOrg APPS-1315 GRZ(Nikhil Verma) 27-09-2022
                sapData = Grz_SapCommonIntegration.overdueSummaryIND(customerNumber, sapUserId, companyCode, String.ValueOf(keyDate), 'x', 'x');
            }else{
                sapData = Grz_SapCommonIntegration.overdueSummary(customerNumber, sapUserId, companyCode, String.ValueOf(keyDate), 'x', 'x');
            }*/
            if(sapData == null || sapData == 'Error_In_Sap'){
                response.success = false;
                response.message = 'Error_In_SAP';
            }else{
                sapData = sapData.replace('"Return"', '"ReturnData"');
                List<Grz_Customer360Wrapper.Lineitems> lineItem = new List<Grz_Customer360Wrapper.Lineitems>();
                Grz_Customer360Wrapper.Grz_OverdueWrapper data = (Grz_Customer360Wrapper.Grz_OverdueWrapper) JSON.deserialize(sapData, Grz_Customer360Wrapper.Grz_OverdueWrapper.class);
                Decimal totalAmount = 0;
                Set<String> docNumberSet = new Set<String>();
                if(data.Lineitems != null){
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
                    for(Grz_Customer360Wrapper.Lineitems ifo : data.Lineitems){
                        if(ifo.DbCrInd != null && ifo.DbCrInd != '' && ifo.DbCrInd == 'H'){
                            ifo.AmtDoccur = '-' + ifo.AmtDoccur;
                        }
                        if(docMap != null && docMap.get(ifo.DocType) != null && docMap.get(ifo.DocType).get(userLang) != null){
                            ifo.docDes = String.valueOf(docMap.get(ifo.DocType).get(userLang));
                        }else{
                            ifo.docDes = '-';
                        }
                        if(startDate == null || startDate == 'null' || startDate == 'undefined'){
                            if(date.valueOf(ifo.DocDate) <= date.valueOf(endDate)){
                                docNumberSet.add(ifo.DocNo);
                                Date dt = date.valueOf(ifo.BlineDate);
                                ifo.DueDate = String.valueOf(dt.addDays(Integer.valueOf(ifo.DsctDays1)));
                                Date todayDate = system.today();
                                Date dueDate = date.valueOf(ifo.DueDate);
                                ifo.overDued = todayDate.daysBetween(dueDate) >= 0 ? false : true;
                                totalAmount = totalAmount + Decimal.valueOf(ifo.AmtDoccur);
                                lineItem.add(ifo);
                            }
                        }else{
                            if(date.valueof(ifo.DocDate) >= date.valueOf(startDate) && date.valueOf(ifo.DocDate) <= date.valueOf(endDate)){
                                docNumberSet.add(ifo.DocNo);
                                Date dt = date.valueOf(ifo.BlineDate);
                                ifo.DueDate = String.valueOf(dt.addDays(Integer.valueOf(ifo.DsctDays1)));
                                Date todayDate = system.today();
                                Date dueDate = date.valueOf(ifo.DueDate);
                                ifo.overDued = todayDate.daysBetween(dueDate) >= 0 ? false : true;
                                totalAmount = totalAmount + Decimal.valueOf(ifo.AmtDoccur);
                                lineItem.add(ifo);
                            }
                        }
                    }
                }
                if(sapData.contains('"Lineitems":')){
                    if(!lineItem.isEmpty()){

                        //Added for Poland User RITM0431761 GRZ(Nikhil Verma) 27-09-2022
                        if(salesOrgCode == '2941' && docNumberSet != null && !docNumberSet.isEmpty()){
                            Map<String,Invoice__c> docNoToInvoiceMap = new Map<String,Invoice__c>();
                            for(Invoice__c inv : [SELECT Id, Billing_Doc_Number__c, Sales_Order__c, Sales_Order__r.Name FROM Invoice__c WHERE Billing_Doc_Number__c IN:docNumberSet AND Sales_Org_Code__c =: salesOrgCode ]){
                                docNoToInvoiceMap.put(inv.Billing_Doc_Number__c, inv);
                            }
                            for(Grz_Customer360Wrapper.Lineitems ifo : lineItem){
                                if(docNoToInvoiceMap.containsKey(ifo.DocNo) && docNoToInvoiceMap.get(ifo.DocNo) != null){
                                    ifo.salesOrder = docNoToInvoiceMap.get(ifo.DocNo).Sales_Order__r.Name;
                                    ifo.salesOrderLink = '/' + docNoToInvoiceMap.get(ifo.DocNo).Sales_Order__c;
                                }
                            }
                        }
                        //----------End ----- RITM0431761 GRZ(Nikhil Verma) 27-09-2022
                        response.lineitems = lineItem;
                        response.totalOutstanding = totalAmount;
                    }else{
                        response.success = false;
                        response.message = 'no_data';
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
    * Date                : 26/05/2022 
    * Author              : Nikhil Verma (Grazitti)                                                                  
    *******************************************************************************************************/
    public void getDataForVF() {
        Grz_Customer360Wrapper.LabelsWrapper wrappper = (Grz_Customer360Wrapper.LabelsWrapper) JSON.deserialize(System.Label.Grz_OverdueSummaryTranslation, Grz_Customer360Wrapper.LabelsWrapper.class);        
        customerNumber = ApexPages.currentPage().getParameters().get('customerNumber');
        String sapUserId = ApexPages.currentPage().getParameters().get('sapUserId');
        String companyCode = ApexPages.currentPage().getParameters().get('companyCode');
        String startDate = ApexPages.currentPage().getParameters().get('startDate');
        String endDate = ApexPages.currentPage().getParameters().get('endDate');
        String salesOrgCode = ApexPages.currentPage().getParameters().get('salesOrgCode');
        cstName = ApexPages.currentPage().getParameters().get('cstName');
        Apexpages.currentPage().getHeaders().put('content-disposition', 'attachment; filename=' + ApexPages.currentPage().getParameters().get('fileName'));

        Grz_Customer360Wrapper.Wrapper wrapData = getOverdueData(customerNumber, sapUserId, companyCode, startDate, endDate, salesOrgCode);  
        labels = wrappper;   
        lineItems = wrapData.lineitems;
        totalOutstanding = wrapData.totalOutstanding;
    }
}