/*
* Name: KYCBatch
* Created On: 06 June 2019
* Author: Vishal Pawar (vishal.pawar@skinternational.com)
* Description: This batch class is used for only Passporrt, gst, Bank Account and Pan Card
*/





global  class KYCBatch implements Database.Batchable<sObject>,Database.AllowsCallouts, Database.Stateful{
    
    
    public List<KYC__c> lstKyc = new List<KYC__c>();
    public String devRecordTypeId = Schema.SObjectType.KYC__c.getRecordTypeInfosByName().get('PAN Card').getRecordTypeId();
    public MonitorLogGenerationController MonitorLogGenerationObj;
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
       
       
       String query1='SELECT Id, IsDeleted, Name, CurrencyIsoCode, RecordTypeId,RecordType.Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, Account__c, Kyc_status__c, Confidence_score__c, Result__c, Input__c, Email_ID__c, KYC_Last_Updated_Date_Time__c, KYC_By__c, Request_JSON__c, Respone_JSON__c, Consent__c, Request_Id__c, Status_Code__c, Email__c, email_resp_accept_all__c, email_resp_disposable__c, email_resp_email__c, email_resp_mx_records__c, email_resp_regexp__c, email_resp_result__c, email_resp_smtp_check__c, email_resp_webmail__c, PAN_Number__c, pan_resp_name__c, dl_no__c, dl_dob__c, dl_resp_name__c, dl_resp_dob__c, dl_resp_Issue_Date__c, dl_resp_blood_group__c, dl_resp_father_husband_name__c, dl_resp_address__c, dl_resp_cov_issue_date__c, dl_resp_cov__c, dl_resp_validity_non_transport__c, dl_resp_validity_transport__c, vi_req_epic_no__c, vi_resp_ps_lat_long__c, vi_resp_rln_name_v1__c, vi_resp_rln_name_v2__c, vi_resp_rln_name_v3__c, vi_resp_part_no__c, vi_resp_rln_type__c, vi_resp_section_no__c, vi_resp_vid__c, vi_resp_name_v1__c, vi_resp_rln_name__c, vi_resp_district__c, vi_resp_last_update__c, vi_resp_state__c, vi_resp_ac_no__c, vi_resp_house_no__c, vi_resp_ps_name__c, vi_resp_pc_name__c, vi_resp_slno_inpart__c, vi_resp_name__c, vi_resp_part_name__c, vi_resp_st_code__c, vi_resp_gender__c, vi_resp_age__c, vi_resp_ac_name__c, vi_resp_epic_no__c, vi_resp_name_v3__c, vi_resp_name_v2__c, vi_resp_dob__c, psp_resp_dob__c, psp_resp_doe__c, psp_resp_gender__c, psp_passport_no__c, psp_resp_type__c, psp_resp_country__c, psp_resp_placeOfIssue__c, psp_resp_placeOfBirth__c, mob_mobile_no__c, mob_resp_message__c, fssai_reg_no__c, fssai_resp_status__c, fssai_resp_lic_type__c, fssai_resp_lic_no__c, fssai_resp_firm_name__c, fssai_resp_address__c, ban_ifsc__c, ban_account_number__c, ban_resp_bankTxnStatus__c, ban_resp_account_number__c, ban_resp_ifsc__c, ban_resp_account_name__c, ban_resp_bank_response__c, ifsc_ifsc_code__c, ifsc_resp_city__c, ifsc_resp_district__c, ifsc_resp_ifsc__c, ifsc_resp_micr__c, ifsc_resp_state__c, ifsc_resp_contact__c, ifsc_resp_branch__c, ifsc_resp_address__c, ifsc_resp_bank__c, fda_licence_no__c, fda_state__c, fda_resp_store_name__c, fda_resp_contact_number__c, fda_resp_license_detail__c, fda_resp_name__c, fda_resp_address__c, ma_name1__c, ma_name2__c, psp_resp_given_name__c, psp_resp_last_name__c, ma_resp_score__c, ma_resp_result__c, gst_gstin__c, API_Count__c, OCR_verified__c, ma_type__c, ma_preset__c, gst_resp_mbr__c, gst_resp_canFlag__c, gst_resp_pradr__c, gst_resp_tradeNam__c, gst_resp_lstupdt__c, gst_resp_contacted__c, gst_resp_rgdt__c, gst_resp_stjCd__c, gst_resp_stj__c, gst_resp_ctjCd__c, gst_resp_ppr__c, gst_resp_dty__c, gst_resp_cmpRt__c, gst_resp_cxdt__c, gst_resp_ctb__c, gst_resp_sts__c, gst_resp_gstin__c, gst_resp_lgnm__c, gst_resp_nba__c, gst_resp_adadr__c, gst_resp_ctj__c, Distributor_Document__c, API_Count_Name__c, res_kyc_int_datetime__c, req_kyc_int_datetime__c, Territory__c, Total_Api_Count__c, KYC_Integration_Status__c, First_Name__c, Last_Name__c, DOB__c, API_Count_OCR__c, ocr_pan_resp_father__c, ocr_pan_resp_date__c, ocr_pan_resp_dateofIssue__c, ban_name__c FROM KYC__c WHERE KYC_Integration_Status__c =\'Partially Completed\' OR KYC_Integration_Status__c =\'Submitted for KYC\'';
        return Database.getQueryLocator(query1); 
        
    }
    
    global void execute(Database.BatchableContext BC, List<KYC__c> kycList) {
        System.debug('kycList size '+kycList.size());
        System.debug('kycList  '+kycList);
        
        updateKYC(kycList);
    }   
    
    public void updateKYC(List<KYC__c> lstKyc){
        System.debug('In schedular');
        System.debug('Size of KYC '+lstKyc.size());
       // KycRequestHandlerController KycRequestHandlerObj = new KycRequestHandlerController();
        MonitorLogGenerationObj = new MonitorLogGenerationController();
        DateTime currentTime = Datetime.now();
        
        if(lstKyc.size()>0){
            for(KYC__c kycObj :lstKyc){
                if(kycObj.RecordType.Name=='PAN Card' && kycObj.KYC_Integration_Status__c =='Partially Completed'){ 
                    System.debug('@@@ ma_type__c '+kycObj.ma_type__c);
                    System.debug('@@@ ma_preset__c '+kycObj.ma_preset__c);
                    System.debug('@@@ First_Name__c '+kycObj.First_Name__c);
                    System.debug('@@@ Last_Name__c '+kycObj.Last_Name__c);
                    
                    Boolean flagResName = true;
                    Boolean flagType = true;
                    Boolean flagPreSet = true;
                    Boolean flagFName = true;
                    Boolean flagLName = true;
                    
                    if(kycObj.pan_resp_name__c == null ){
                        flagResName = false;
                        String errorMessage = 'ErrorLog PAN MATCH NAME: pan response name is invalid';
                        MonitorLogGenerationObj.setMonitorLog('Scheduler', currentTime, '', '', errorMessage, 'PAN MATCH NAME', '', kycObj.Id);
                    }        
                    if(kycObj.ma_type__c == null ){
                        flagType = false;
                        String errorMessage = 'ErrorLog PAN MATCH NAME: Match Type is empty';
                        MonitorLogGenerationObj.setMonitorLog('Scheduler', currentTime, '', '', errorMessage, 'PAN MATCH NAME', '', kycObj.Id);
                    }
                    
                    if(kycObj.ma_preset__c == null){
                        flagPreSet = false;
                        String errorMessage = 'ErrorLog PAN MATCH NAME: Match Preset is empty';
                        MonitorLogGenerationObj.setMonitorLog('Scheduler', currentTime, '', '', errorMessage, 'PAN MATCH NAME', '', kycObj.Id);
                    }
                    
                    if(kycObj.First_Name__c == null){
                        flagFName = false;
                        String errorMessage = 'ErrorLog PAN MATCH NAME: First Name is empty';
                        MonitorLogGenerationObj.setMonitorLog('Scheduler', currentTime, '', '', errorMessage, 'PAN MATCH NAME', '', kycObj.Id);
                    }
                    
                    if(kycObj.Last_Name__c == null){
                        flagLName = false;
                        String errorMessage = 'ErrorLog PAN MATCH NAME: Last Name is empty';
                        MonitorLogGenerationObj.setMonitorLog('Scheduler', currentTime, '', '', errorMessage, 'PAN MATCH NAME', '', kycObj.Id);
                    }
                    
                    if(flagResName && flagType && flagPreSet && flagFName && flagLName){
                        System.debug('All condition are True in Pan Card');
                        KYCApiIntegrationController.validateMatchName(kycObj.Id, 'Scheduler', kycObj.pan_resp_name__c, kycObj.RecordTypeId, kycObj.RecordType.Name); 
                    }
                    
                    
                }// end of PaN card
                
                
                
                //start of Bank account Validate Match Name
                if(kycObj.RecordType.Name=='Bank Account' && kycObj.KYC_Integration_Status__c =='Partially Completed'){
                    Boolean flagResName = true;
                    Boolean flagType = true;
                    Boolean flagPreSet = true;
                    Boolean flagFName = true;
                    Boolean flagLName = true;
                    
                    
                    if(kycObj.ban_resp_account_name__c == null ){
                        flagResName = false;
                        String errorMessage = 'ErrorLog Bank Account MATCH NAME: Account name is invalid';
                        MonitorLogGenerationObj.setMonitorLog('Scheduler', currentTime, '', '', errorMessage, 'Bank Account MATCH NAME', '', kycObj.Id);
                    }        
                    if(kycObj.ma_type__c == null){ 
                        flagType = false;
                        String errorMessage = 'ErrorLog Bank Account MATCH NAME: Match Type is empty';
                        MonitorLogGenerationObj.setMonitorLog('Scheduler', currentTime, '', '', errorMessage, 'Bank Account MATCH NAME', '', kycObj.Id);
                    }
                    
                    if(kycObj.ma_preset__c == null){
                        flagPreSet = false;
                        String errorMessage = 'ErrorLog Bank Account MATCH NAME: Match Preset is empty';
                        MonitorLogGenerationObj.setMonitorLog('Scheduler', currentTime, '', '', errorMessage, 'Bank Account MATCH NAME', '', kycObj.Id);
                    }
                    
                    if(kycObj.First_Name__c == null){
                        flagFName = false;
                        String errorMessage = 'ErrorLog Bank Account MATCH NAME: First Name is empty';
                        MonitorLogGenerationObj.setMonitorLog('Scheduler', currentTime, '', '', errorMessage, 'Bank Account MATCH NAME', '', kycObj.Id);
                    }
                    
                     if(kycObj.Last_Name__c == null){
                        flagLName = false;
                        String errorMessage = 'ErrorLog Bank Account MATCH NAME: Last Name is empty';
                        MonitorLogGenerationObj.setMonitorLog('Scheduler', currentTime, '', '', errorMessage, 'Bank Account MATCH NAME', '', kycObj.Id);
                    }
                    
                    if(flagResName && flagType && flagPreSet && flagFName && flagLName){
                        System.debug('All condition are True in Bank Account');
                        KYCApiIntegrationController.validateMatchName(kycObj.Id, 'Scheduler', kycObj.ban_resp_account_name__c, kycObj.RecordTypeId, kycObj.RecordType.Name);    
                    }
                    
                }// end of Bank Account
                
                
                //Start of GST Validate Match Name 
                if(kycObj.RecordType.Name=='Gst' && kycObj.KYC_Integration_Status__c =='Partially Completed'){
                    
                    Boolean flagResName = true;
                    Boolean flagType = true;
                    Boolean flagPreSet = true;
                    Boolean flagFName = true;
                    Boolean flagLName = true;
                    
                    
                    if(kycObj.gst_resp_tradeNam__c == null ){
                        flagResName = false;
                        String errorMessage = 'ErrorLog GST MATCH NAME: GST response name is invalid';
                        MonitorLogGenerationObj.setMonitorLog('Scheduler', currentTime, '', '', errorMessage, 'GST MATCH NAME', '', kycObj.Id);
                    }        
                    if(kycObj.ma_type__c == null){
                        flagType = false;
                        String errorMessage = 'ErrorLog GST MATCH NAME: Match Type is empty';
                        MonitorLogGenerationObj.setMonitorLog('Scheduler', currentTime, '', '', errorMessage, 'GST MATCH NAME', '', kycObj.Id);
                    }
                    
                    if(kycObj.ma_preset__c == null){
                        flagPreSet = false;
                        String errorMessage = 'ErrorLog GST MATCH NAME: Match Preset is empty';
                        MonitorLogGenerationObj.setMonitorLog('Scheduler', currentTime, '', '', errorMessage, 'GST MATCH NAME', '', kycObj.Id);
                    }
                    
                     if(kycObj.First_Name__c == null){
                        flagFName = false;
                        String errorMessage = 'ErrorLog GST MATCH NAME: First Name is empty';
                        MonitorLogGenerationObj.setMonitorLog('Scheduler', currentTime, '', '', errorMessage, 'GST MATCH NAME', '', kycObj.Id);
                    }
                    
                     if(kycObj.Last_Name__c == null){
                        flagLName = false;
                        String errorMessage = 'ErrorLog GST MATCH NAME: Last Name is empty';
                        MonitorLogGenerationObj.setMonitorLog('Scheduler', currentTime, '', '', errorMessage, 'GST MATCH NAME', '', kycObj.Id);
                    }
                    
                    if(flagResName && flagType && flagPreSet && flagFName && flagLName){
                        System.debug('All condition are True in GST');
                        KYCApiIntegrationController.validateMatchName(kycObj.Id, 'Scheduler', kycObj.gst_resp_tradeNam__c, kycObj.RecordTypeId, kycObj.RecordType.Name);
                    }
                    
                }// end of GST
                
                
                
                
                // Start of Passport Validate MAtch Name
                if(kycObj.RecordType.Name=='Passport' && kycObj.KYC_Integration_Status__c =='Partially Completed'){
                    Boolean flagResName = true;
                    Boolean flagType = true;
                    Boolean flagPreSet = true;
                    Boolean flagFName = true;
                    Boolean flagLName = true;
                    
                    
                    if(kycObj.psp_resp_given_name__c == null ){
                        flagResName = false;
                        String errorMessage = 'ErrorLog Passport MATCH NAME: Passport response name is invalid';
                        MonitorLogGenerationObj.setMonitorLog('Scheduler', currentTime, '', '', errorMessage, 'Passport MATCH NAME', '', kycObj.Id);
                    }        
                    if(kycObj.ma_type__c == null){
                        flagType = false;
                        String errorMessage = 'ErrorLog Passport MATCH NAME: Match Type is empty';
                        MonitorLogGenerationObj.setMonitorLog('Scheduler', currentTime, '', '', errorMessage, 'Passport MATCH NAME', '', kycObj.Id);
                    }
                    
                    if(kycObj.ma_preset__c == null){
                        flagPreSet = false;
                        String errorMessage = 'ErrorLog Passport MATCH NAME: Match Preset is empty';
                        MonitorLogGenerationObj.setMonitorLog('Scheduler', currentTime, '', '', errorMessage, 'Passport MATCH NAME', '', kycObj.Id);
                    }
                    
                    if(kycObj.First_Name__c == null){
                        flagFName = false;
                        String errorMessage = 'ErrorLog Passport MATCH NAME: First Name is empty';
                        MonitorLogGenerationObj.setMonitorLog('Scheduler', currentTime, '', '', errorMessage, 'Passport MATCH NAME', '', kycObj.Id);
                    }
                    
                    if(kycObj.Last_Name__c == null){
                        flagLName = false;
                        String errorMessage = 'ErrorLog Passport MATCH NAME: Last Name is empty';
                        MonitorLogGenerationObj.setMonitorLog('Scheduler', currentTime, '', '', errorMessage, 'Passport MATCH NAME', '', kycObj.Id);
                    }
                    
                    if(flagResName && flagType && flagPreSet && flagFName && flagLName){
                        System.debug('All condition are True in Passport');
                        KYCApiIntegrationController.validateMatchName(kycObj.Id, 'Scheduler', kycObj.psp_resp_given_name__c, kycObj.RecordTypeId, kycObj.RecordType.Name);
                    }
                    
                }// end of Passport
                
                
            }
        }
    }
    
    global void finish(Database.BatchableContext BC) {
        
        System.debug('In finish method');
        
    }  

    
}