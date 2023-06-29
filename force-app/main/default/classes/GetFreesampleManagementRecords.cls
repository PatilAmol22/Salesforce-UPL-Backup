public with sharing class GetFreesampleManagementRecords {
    @AuraEnabled
    public static string getTotalRecordcount(String d_name,String d_code){
        // HttpRequest req = new HttpRequest(); 
        // req.setEndpoint('https://'+URL.getSalesforceBaseUrl().getHost()+'/services/data/v20.0/query/?q=SELECT+Id+from+Free_Sample_Management__c'); 
        // req.setMethod('GET'); 
        // string autho = 'Bearer '+ userInfo.getsessionId(); 
        // System.debug('session ID'+autho);
        // req.setHeader('Authorization', autho); 
        // Http http = new Http(); 
        // HTTPResponse res = http.send(req); 
        // string response = res.getBody(); 
        // string total = response.substring(response.indexOf('totalSize":') + 11, response.indexOf(',')); 
        // system.debug('Total: '+ total);
        Integer total = 0;
        if(!String.isEmpty(d_name)){
             total = [SELECT Count() from Free_Sample_Management__c where Product_provided_for_trial__r.Name like :d_name];
        }else if(!String.isEmpty(d_code)){
             total = [SELECT Count() from Free_Sample_Management__c where Product_provided_for_trial__r.Product_Code__c like :d_code];
        }else{
             total = [SELECT Count() from Free_Sample_Management__c];
        }

        return String.valueOf(total);
    }

    @AuraEnabled
    public static List<Free_Sample_Management__c> onfilter(String d_name,String d_code,String str_limit,String last_record,String op){
        Integer limit_num = Integer.valueOf(str_limit);
        String order = 'ASC';
        if(op=='<'){
            order = 'DESC';
        }
//         Assessment_of_effect__c
// Comparison_to_control__c
// Comparison_To_Standard__c
// Control_Plot__c
// Crop__c
// Cultivating_Season__c
// Farmers_Impression__c
// Nets_for_greenhouse__c
// Next_action_planned__c
// Possibility_of_market_penetration__c
// Priority__c
// Product_Category__c
// Report_accepted__c
// Report_Stored_In_Folder__c
// Sticky_plate__c
// Trial_History__c
// UOM__c
        String fs_query = 'SELECT Id,Name, toLabel(Report_Stored_In_Folder__c), toLabel(Report_accepted__c), toLabel(Control_Plot__c), toLabel(Comparison_to_control__c), toLabel(Possibility_of_market_penetration__c), Other_Comments__c, Application_date_for_trial__c, Sales_Office__r.Name, Area__r.Name, JA_Name__c, toLabel(Crop__c), toLabel(Priority__c), Market_Acrage_ha__c, MPV_M__c, Farmers_Name__c, Acrage_for_Trial_are__c, Target_Pest__c, toLabel(Product_Category__c), SKU__c, Volume__c, toLabel(UOM__c), Delivery_date_requested__c, Shipping_address__c, Phone_number__c, Place_to_receive_sample__c, Representative_to_receive_sample__c, Responsible_person_for_trial__c, toLabel(Nets_for_greenhouse__c), toLabel(Sticky_plate__c), Others__c, toLabel(Trial_History__c), toLabel(Next_action_planned__c), toLabel(Cultivating_Season__c), Transplanting_Date__c, Standard_product_used_for_comparison__c, Planned_finished_timing__c, Sales_value__c, Product_provided_for_trial__r.Name, toLabel(Farmers_Impression__c),Pagination_Formula__c,Need_AM_arrival__c,Arrangement_confirmed__c,Arrangement_Date__c,toLabel(Assessment_of_effect__c),Case_Conversion__c,Cost__c,Delivery_Date__c,Information_about_cultivation__c,Planned_Timing__c,Process_Timing__c,Requested_Delivery_Time__c,Sample_code__c FROM Free_Sample_Management__c';
        List<Free_Sample_Management__c> fs;
        
        if(!String.isEmpty(d_name)){
            String qry = fs_query+' where Pagination_Formula__c '+op+' '+last_record+' and Product_provided_for_trial__r.Name like \''+d_name+'\'  Order By Pagination_Formula__c '+order+' limit '+limit_num+'';
            fs = Database.query(qry);
            System.debug('qry-->'+qry);
            return fs;
        }
        if(!String.isEmpty(d_code)){
            String qry = fs_query+' where Pagination_Formula__c '+op+' '+last_record+' and Product_provided_for_trial__r.Product_Code__c like \''+d_code+'\'  Order By Pagination_Formula__c '+order+' limit '+limit_num+'';
            fs = Database.query(qry);
            System.debug('qry-->'+qry);
            return fs;
        }
            String qry = fs_query+' where Pagination_Formula__c '+op+' '+last_record+' Order By Pagination_Formula__c '+order+' limit '+limit_num+'';
            System.debug('qry-->'+qry);
            fs = Database.query(qry);
        return fs;
    }

    @AuraEnabled
    public static string getLastRecord(){
      return String.valueOf([select id,CreatedDate,Pagination_Formula__c from Free_Sample_Management__c order by CreatedDate desc limit 1].Pagination_Formula__c); 
    }
}