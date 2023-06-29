public with sharing class Grz_GstInformation {
    
    @AuraEnabled(cacheable=true)
    public static List<map<string,string>> getSalesAreaOptions(){
        List<map<string,string>> salesAreaOptions = new  List<map<string,string>>();
        set<string>saleOrgCountered=new set<string>();
        Id usrid = UserInfo.getUserId();
        List<User> user = [SELECT Id, Username,AccountId, ContactId FROM User where Id =: usrid and accountid != null];
       //Change by Aashima(Grazitti) for APPS-4027 28Dec22
        List<DistributorSalesAreaMapping__c> salesAreaList = [SELECT Id, Name, Distributor__c, SalesOrg__c,SalesOrg__r.name,Company_Code__c,Sales_Org_Code__c FROM DistributorSalesAreaMapping__c where Distributor__c =: user[0].accountId and SalesOrg__r.name!='India'];
        for(DistributorSalesAreaMapping__c dsa : salesAreaList){
            if(!saleOrgCountered.contains(dsa.SalesOrg__r.name)){
                map<string,string>salesMap=new map<string,string>{'label'=>dsa.SalesOrg__r.name,'value'=>dsa.Company_Code__c};
                salesAreaOptions.add(salesMap);
                saleOrgCountered.add(dsa.SalesOrg__r.name);
            }
            
        }
        return salesAreaOptions;
    }
    
    @AuraEnabled(cacheable=true)
    public static Grz_GstInformationWrapper getGstInformation(String startDate,String endDate, string companyCode){
        Id usrid;
        if(Test.isRunningTest()){
            Profile pro = [SELECT Id FROM Profile WHERE Name = 'India Partner Community Distributor Profile'];
            User user = [SELECT Id, Username, AccountId, ContactId FROM User WHERE ProfileId =: pro.Id AND lastname = 'Testing' and Email ='test@grazitti.com' LIMIT 1];
            usrid = user.Id;
        }
        else{
            usrid = UserInfo.getUserId();// getting current user info
        }
        List<User> user = [SELECT Id, Username, AccountId, ContactId FROM User where Id =: usrid];
        String accountId = user[0].AccountId;
        system.debug('AccountId : '+accountId);
        Account accData = [SELECT Id, SAP_Customer_Code__c, Company_Code__c, sap_UserId__c FROM Account WHERE Id =:accountId];
        system.debug('accData : '+accData);
        system.debug('startDate : '+startDate);
        system.debug('endDate : '+endDate);
        String datecheck = System.Label.Grz_HanaFiscalDate; //2023-03-31
        Grz_GstInformationWrapper Data = new Grz_GstInformationWrapper();
        //if(accData.SAP_Customer_Code__c==null || accData.Company_Code__c==null || accData.sap_UserId__c==null ){
        if(accData.SAP_Customer_Code__c==null || CompanyCode==null || accData.sap_UserId__c==null ){
            Data.isSuccess=false;
            Data.msg='Customer Code/Company Code/User ID is empty. Please contact administrator';
        }
        else{
            Data.isSuccess=false;
            // Customer 360 CR changes (Ticket No. APPS-5366)
            String res;
            Map<String, Grz_Customer360IntegrationMappings__mdt> integrationSettingsMap = new Map<String, Grz_Customer360IntegrationMappings__mdt>();
            for(Grz_Customer360IntegrationMappings__mdt dd: Grz_Customer360IntegrationMappings__mdt.getAll().values()){
                integrationSettingsMap.put(dd.Company_Code__c, dd);
            }
            if(integrationSettingsMap != null && integrationSettingsMap.containsKey(companyCode) && integrationSettingsMap.get(companyCode).Country__c == 'India'){
                if(integrationSettingsMap.get(companyCode).EndPointURL__c != null && date.valueOf(startDate) >= date.valueOf(datecheck)){ //Code Updated by Grz(Sumit Kumar) 22-05-2023 for Customer 360 New CR Changes (Ticket No. APPS-5366)
                    system.debug('orderDate in if : '+startDate);
                    String endPointName = integrationSettingsMap.get(companyCode).EndPointURL__c;
                    res = Grz_SapCommonIntegration.GSTMarketingIND(accData.SAP_Customer_Code__c,CompanyCode,startDate,endDate, accData.Sap_UserId__c, endPointName);
                }else{
                    system.debug('orderDate in else if : '+startDate);
                    res = grz_SapIntegration.getGstDetails(accData.SAP_Customer_Code__c,CompanyCode,startDate,endDate, accData.Sap_UserId__c);
                }
            }else{
                res = grz_SapIntegration.getGstDetails(accData.SAP_Customer_Code__c,CompanyCode,startDate,endDate, accData.Sap_UserId__c);
            }
            if(res.equals('Error_In_Sap')){
                Data.isSuccess=false;
                Data.msg='Error in SAP';
            }
            else{
                Data = Grz_GstInformationWrapper.parse(res);
                for(GstInfo gi:Data.GstInfo){
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
                Data.isSuccess=true;
                Data.msg='';
                system.debug(Data);
            }
        }
        
        
        return Data;
    }
    
    public static Grz_GstInformationWrapper parse(String json) {
        return (Grz_GstInformationWrapper) System.JSON.deserialize(json, Grz_GstInformationWrapper.class);
    }
    
    public class Grz_GstInformationWrapper {
        @AuraEnabled public List<GstInfo> GstInfo{get;set;}
        @AuraEnabled public Boolean isSuccess{get;set;}
        @AuraEnabled public String msg{get;set;}
        Grz_GstInformationWrapper(){
            GstInfo=new List<GstInfo>();
        }
    }
    
    public class GstInfo {
        @AuraEnabled public String SalesAreaName{get;set;}
        @AuraEnabled public String CompanyCode{get;set;}
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