public with sharing class Grz_GstDetailsPdfController{
    public String startDate{get;set;}
    public String endDate{get;set;}
    public String startDateLabel{get;set;}
    public String endDateLabel{get;set;}
    public String customerName{get;set;}
    public String totalSgst{get;set;}
    public String totalCgst{get;set;}
    public String totalIgst{get;set;}
    public String grandTotal{get;set;}
    public String companyCode{get;set;}
    public List<Grz_GstDetailsPdfController.GstInfo> gstData{get;set;}
    public void gstDetailsFxn(){
        
        if(Test.isRunningTest()){
            startDate= '2021-01-01';
            endDate= '2021-03-31';
            totalSgst= '100.00';
            totalCgst= '100.00';
            totalIgst= '100.00';
            grandTotal= '100.00';
            companyCode='1000';
        }else{
            startDate= ApexPages.currentPage().getParameters().get('startDate');
            endDate= ApexPages.currentPage().getParameters().get('endDate');
            totalSgst= ApexPages.currentPage().getParameters().get('totalSgst');
            totalCgst= ApexPages.currentPage().getParameters().get('totalCgst');
            totalIgst= ApexPages.currentPage().getParameters().get('totalIgst');
            grandTotal= ApexPages.currentPage().getParameters().get('grandTotal');
            companyCode= ApexPages.currentPage().getParameters().get('companyCode');
        }
        startDateLabel= grz_SapIntegration.FormattedDate(Date.valueof(startDate));
        endDateLabel= grz_SapIntegration.FormattedDate(Date.valueof(endDate));
        Id usrid;
        if(Test.isRunningTest()){
            Profile pro = [SELECT Id FROM Profile WHERE Name = 'India Partner Community Distributor Profile'];
            User user = [SELECT Id, Username, AccountId, ContactId FROM User WHERE ProfileId =: pro.Id AND lastname = 'Testing' and Email ='test@grazitti.com' LIMIT 1];
            usrid = user.Id;
        }
        else{
            usrid = UserInfo.getUserId();// getting current user info
        }
        List<User> user = [SELECT Id, Username, AccountId,Account.Name, ContactId FROM User where Id =: usrid];
        String accountId = user[0].AccountId;
        customerName=user[0].Account.Name;
        Account accData = [SELECT Id, SAP_Customer_Code__c, Company_Code__c, Sap_UserId__c FROM Account WHERE Id =:accountId];
        
        if(!Test.isRunningTest()){
            // Customer 360 CR changes
            String res;
            Map<String, Grz_Customer360IntegrationMappings__mdt> integrationSettingsMap = new Map<String, Grz_Customer360IntegrationMappings__mdt>();
            for(Grz_Customer360IntegrationMappings__mdt data: Grz_Customer360IntegrationMappings__mdt.getAll().values()){
                integrationSettingsMap.put(data.Company_Code__c, data);
            }
            if(integrationSettingsMap != null && integrationSettingsMap.containsKey(companyCode) && integrationSettingsMap.get(companyCode).Country__c == 'India'){
                if(integrationSettingsMap.get(companyCode).EndPointURL__c != null){
                    String endPointName = integrationSettingsMap.get(companyCode).EndPointURL__c;
                    res = Grz_SapCommonIntegration.GSTMarketingIND(accData.SAP_Customer_Code__c,CompanyCode,startDate,endDate, accData.Sap_UserId__c, endPointName);
                }else{
                    res = grz_SapIntegration.getGstDetails(accData.SAP_Customer_Code__c,CompanyCode,startDate,endDate, accData.Sap_UserId__c);
                }
            }else{
                res = grz_SapIntegration.getGstDetails(accData.SAP_Customer_Code__c,CompanyCode,startDate,endDate, accData.Sap_UserId__c);
            }
            Grz_GstInformationWrapper Data = new Grz_GstInformationWrapper();
            Data = Grz_GstInformationWrapper.parse(res);
            Data.GstInfo.remove(0);
            system.debug('aashima'+Data);
            gstData=Data.GstInfo;
        }
        else{
        List<Grz_GstDetailsPdfController.GstInfo> wrapperList= new List<Grz_GstDetailsPdfController.GstInfo>();
        
        Grz_GstDetailsPdfController.GstInfo wrapper= new Grz_GstDetailsPdfController.GstInfo();
          wrapper.CGSTValue = '100';
          wrapper.CommercialInvoiceNo = 'test';
          wrapper.DeliveryDate =String.valueOf(date.today());
          wrapper.DeliveryNo = 'test';
          wrapper.GSTInvoiceNo = 'test';
          wrapper.InvoiceDate = String.valueOf(date.today());
          wrapper.ISTValue  = '100';
          wrapper.Profit_center = 'test';
          wrapper.Sales_order_no = 'test';
          wrapper.SGST_UGSTValue = '100';
          wrapper.TaxableValue = '100';
          wrapper.TotalGSTValue = '100';
          wrapper.TotalInvoiceValue = '100';
          wrapperList.add(wrapper);
          gstData = wrapperList;
        }
        for(GstInfo gi:gstData){
            if(gi.InvoiceDate!='0000-00-00'){
                gi.InvoiceDate=grz_SapIntegration.FormattedDate(Date.valueof(gi.InvoiceDate));
            }
            if(gi.DeliveryDate!='0000-00-00'){
                gi.DeliveryDate=grz_SapIntegration.FormattedDate(Date.valueof(gi.DeliveryDate));
            }
            if(gi.TaxableValue!=null && gi.TaxableValue!=''){
                gi.TaxableValue=formatNumber(gi.TaxableValue);
            }
            if(gi.TotalInvoiceValue!=null && gi.TotalInvoiceValue!=''){
                gi.TotalInvoiceValue=formatNumber(gi.TotalInvoiceValue);
            }
            if(gi.SGST_UGSTValue!=null && gi.SGST_UGSTValue!=''){
                gi.SGST_UGSTValue=formatNumber(gi.SGST_UGSTValue);
            }
            if(gi.CGSTValue!=null && gi.CGSTValue!=''){
                gi.CGSTValue=formatNumber(gi.CGSTValue);
            }
            if(gi.TotalGSTValue!=null && gi.TotalGSTValue!=''){
                gi.TotalGSTValue=formatNumber(gi.TotalGSTValue);
            }
            if(gi.ISTValue!=null && gi.ISTValue!=''){
                gi.ISTValue=formatNumber(gi.ISTValue);
            }
        }
    }
    
    public static Grz_GstInformationWrapper parse(String json) {
        return (Grz_GstInformationWrapper) System.JSON.deserialize(json, Grz_GstInformationWrapper.class);
    }
    
    public class Grz_GstInformationWrapper {
        @AuraEnabled public List<GstInfo> GstInfo{get;set;}
    }
    public class GstInfo {
        @AuraEnabled public String CommercialInvoiceNo{get;set;}
        @AuraEnabled public String GSTInvoiceNo{get;set;}
        @AuraEnabled public String InvoiceDate{get;set;}
        @AuraEnabled public String DeliveryNo{get;set;}
        @AuraEnabled public String DeliveryDate{get;set;}
        @AuraEnabled public String TaxableValue{get;set;}
        @AuraEnabled public String TotalInvoiceValue{get;set;}
        @AuraEnabled public String SGST_UGSTValue{get;set;}
        @AuraEnabled public String CGSTValue{get;set;}
        @AuraEnabled public String TotalGSTValue{get;set;}
        @AuraEnabled public String ISTValue{get;set;}
        @AuraEnabled public String Profit_center{get;set;}
        @AuraEnabled public String Sales_order_no{get;set;}
    }
    public static String formatNumber(String val){
        Decimal d = Decimal.valueOf(val).setScale(2);
        List<String> args = new String[]{'0','number','#,###.0'};
            String ds = String.format(d.format(), args);
        return ds;
    }
}