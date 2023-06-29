/*
* Name: AccountKYCController
* Created On: 06 June 2019
* Author: Vishal Pawar (vishal.pawar@skinternational.com)
* Description: AccountKYCController is used in AccountKYCPage. 
*/




public  class AccountKYCController { 
    
    public boolean displayPopUp {get; set;}  
    public boolean displayForEmail {get; set;}
    public boolean displayForGst {get; set;}  
    public boolean displayForFSSAI {get; set;}  
    public boolean displayForVoterID {get; set;}  
    public boolean displayForBankAccount {get; set;}  
    public boolean displayForDrivingLicense {get; set;}  
    public boolean displayForIFSCCode {get; set;}  
    public boolean displayForPANCard {get; set;}  
    public boolean displayForFDA {get; set;}  
    public boolean displayForOCR {get; set;}  
    public boolean displayForPassport {get; set;}  
    public boolean chkStatusForKYC {get; set;}
    public String ProflieName;
    
    public String disableKycId {get;set;}
    
    
    public String accId ;
    public String kycId {get;set;}  
    public String kycId1 {get;set;}  
    
    public List<KYC__c> lstKyc {get;set;} 
    public List<KYC__c> lstKycDisplay {get;set;} 
    public List<wrapKYCDeatils> lstKycDetails {get;set;}
    public List<wrapKYCDeatils> lstKycDetailsDisplay {get;set;}
    public List <KYC_Configuration__mdt> metaData;
    public KYC__c KycObject {get;set;}
    public wrapKYCDeatils tempObjWraper {get;set;}
    public wrapKYCDeatils tempObjDisplay {get;set;}
    
    
    
    
    public AccountKYCController(ApexPages.StandardController controller) {
        accId = ApexPages.currentPage().getParameters().get('id');
        lstKyc = new List<KYC__c> ();
        lstKycDetails = new List<wrapKYCDeatils>();
        lstKycDisplay = new List<KYC__c> ();
        lstKycDetailsDisplay = new List<wrapKYCDeatils>();
        metaData = new List<KYC_Configuration__mdt>();
        KycObject = new KYC__c();
        displayPopUp = false;
        displayForEmail =false;
        displayForGst = false;
        displayForFSSAI = false;
        displayForVoterID = false;
        displayForBankAccount = false;
        displayForDrivingLicense = false;
        displayForIFSCCode = false;
        displayForPANCard = false;
        displayForFDA = false;
        displayForOCR = false;
        displayForPassport = false;
        chkStatusForKYC =false;
        disableKycId='';
        ProflieName='';
        
        kycId ='';
        kycId1 ='';
        
    }
    
    public void fetchDetails(){
        
        System.debug('accId '+accId);
        List<Profile> PROFILE = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
        ProflieName = PROFILE[0].Name;
       System.debug('ProflieName '+ProflieName);
        
        if(accId!=null){
            displayAll();    
        }
        
        
    }
    
   /* public void spin() {
        long now = datetime.now().gettime();
        while(datetime.now().gettime()-now<7000); // Busy loop for 5000 ms
    }*/
    
    
    public void displayAll(){
        try{
            
            System.debug('Calling from Run KYC');
            lstKyc =[SELECT Id,  IsDeleted, Name, CurrencyIsoCode, RecordTypeId,RecordType.Name, CreatedDate, 
                     CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, Account__c, Kyc_status__c, 
                     Confidence_score__c, Result__c, Input__c, Email_ID__c, KYC_Last_Updated_Date_Time__c, KYC_By__c, 
                     Request_JSON__c, Respone_JSON__c, Consent__c, Request_Id__c, Status_Code__c, Email__c, 
                     email_resp_accept_all__c, email_resp_disposable__c, email_resp_email__c, email_resp_mx_records__c, 
                     email_resp_regexp__c, email_resp_result__c, email_resp_smtp_check__c, email_resp_webmail__c, 
                     PAN_Number__c, pan_resp_name__c, dl_no__c, dl_dob__c, dl_resp_name__c, dl_resp_dob__c, dl_resp_Issue_Date__c,
                     dl_resp_blood_group__c, dl_resp_father_husband_name__c, dl_resp_address__c, dl_resp_cov_issue_date__c, 
                     dl_resp_cov__c, dl_resp_validity_non_transport__c, dl_resp_validity_transport__c, vi_req_epic_no__c, 
                     vi_resp_ps_lat_long__c, vi_resp_rln_name_v1__c, vi_resp_rln_name_v2__c, vi_resp_rln_name_v3__c, 
                     vi_resp_part_no__c, vi_resp_rln_type__c, vi_resp_section_no__c, vi_resp_vid__c, vi_resp_name_v1__c, 
                     vi_resp_rln_name__c, vi_resp_district__c, vi_resp_last_update__c, vi_resp_state__c, vi_resp_ac_no__c, 
                     vi_resp_house_no__c, vi_resp_ps_name__c, vi_resp_pc_name__c, vi_resp_slno_inpart__c, vi_resp_name__c, 
                     vi_resp_part_name__c, vi_resp_st_code__c, vi_resp_gender__c, vi_resp_age__c, vi_resp_ac_name__c, 
                     vi_resp_epic_no__c, vi_resp_name_v3__c, vi_resp_name_v2__c, vi_resp_dob__c, psp_resp_dob__c, psp_resp_doe__c, 
                     psp_resp_gender__c, psp_passport_no__c, psp_resp_type__c, psp_resp_country__c, psp_resp_placeOfIssue__c, 
                     psp_resp_placeOfBirth__c, mob_mobile_no__c, mob_resp_message__c, fssai_reg_no__c, fssai_resp_status__c, 
                     fssai_resp_lic_type__c, fssai_resp_lic_no__c, fssai_resp_firm_name__c, fssai_resp_address__c, ban_ifsc__c, 
                     ban_account_number__c, ban_resp_bankTxnStatus__c, ban_resp_account_number__c, ban_resp_ifsc__c,
                     ban_resp_account_name__c, ban_resp_bank_response__c, ifsc_ifsc_code__c, ifsc_resp_city__c, ifsc_resp_district__c, 
                     ifsc_resp_ifsc__c, ifsc_resp_micr__c, ifsc_resp_state__c, ifsc_resp_contact__c, ifsc_resp_branch__c, 
                     ifsc_resp_address__c, ifsc_resp_bank__c, fda_licence_no__c, fda_state__c, fda_resp_store_name__c, fda_resp_contact_number__c,
                     fda_resp_license_detail__c, fda_resp_name__c, fda_resp_address__c, ma_name1__c, ma_name2__c, psp_resp_given_name__c, 
                     psp_resp_last_name__c, ma_resp_score__c, ma_resp_result__c, gst_gstin__c, API_Count__c, OCR_verified__c, ma_type__c, 
                     ma_preset__c, gst_resp_mbr__c, gst_resp_canFlag__c, gst_resp_pradr__c, gst_resp_tradeNam__c, gst_resp_lstupdt__c,
                     gst_resp_contacted__c, gst_resp_rgdt__c, gst_resp_stjCd__c, gst_resp_stj__c, gst_resp_ctjCd__c, gst_resp_ppr__c, 
                     gst_resp_dty__c, gst_resp_cmpRt__c, gst_resp_cxdt__c, gst_resp_ctb__c, gst_resp_sts__c, gst_resp_gstin__c, gst_resp_lgnm__c, 
                     gst_resp_nba__c, gst_resp_adadr__c, gst_resp_ctj__c, Distributor_Document__c, API_Count_Name__c, res_kyc_int_datetime__c, 
                     req_kyc_int_datetime__c, Territory__c, Total_Api_Count__c, KYC_Integration_Status__c, First_Name__c, Last_Name__c, DOB__c, 
                     API_Count_OCR__c, ocr_pan_resp_father__c, ocr_pan_resp_date__c, ocr_pan_resp_dateofIssue__c, ban_name__c 
                     FROM KYC__c 
                     WHERE Account__c=:accId  ORDER by RecordType.Name ASC];
            
            //SELECT MasterLabel, QualifiedApiName, Red_Range__c,Orange_Range__c,Green_Range__c FROM KYC_Configuration__mdt
            System.debug('lstKyc size is '+lstKyc.size());
            metaData = [SELECT MasterLabel, QualifiedApiName, Red_Range__c,Orange_Range__c,Green_Range__c FROM KYC_Configuration__mdt];
            System.debug('metaData '+metaData);
            
            
            if(lstKyc.size()>0){
                wrapKYCDeatils tempObj ;
                for(KYC__c objKyc:lstKyc){
                    System.debug('kycObj list is '+lstKyc);
                    tempObj  = new wrapKYCDeatils();
                    tempObj.KYC_Id = objKyc.Id;
                    if(objKyc.RecordType.Name=='Gst'){
                        tempObj.KYC_Type ='GSTIN';
                    }else{
                        tempObj.KYC_Type = objKyc.RecordType.Name;
                    }
                    System.debug('@@@@ objKyc.RecordType.Name '+objKyc.RecordType.Name);
                    
                    //If Record Type is Bank Account
                    if(objKyc.RecordType.Name == 'Bank Account'){
                        tempObj.KYC_Details =  String.valueOf(objKyc.ban_account_number__c);
                        if(objKyc.ban_account_number__c!= null || objKyc.ban_account_number__c ==''){
                            System.debug(' @@@ Not Blank ');
                            String original = objKyc.ban_account_number__c;
                            if(original.length()>0){
                                String valueToMask = original.substring(1, 4);
                                String mask = '*'.repeat(valueToMask.length());
                                String masked = original.replaceFirst(valueToMask, mask);
                                tempObj.KYC_Details = masked;  
                            }
                            
                        }else{
                            System.debug('@@@ Blank ');
                            tempObj.KYC_Details = 'NA';
                        }
                        
                        
                        
                    }
                    
                    //If Record Type is Driving License
                    if(objKyc.RecordType.Name == 'Driving License'){
                        // tempObj.KYC_Details = objKyc.dl_no__c;
                        if(objKyc.dl_no__c!= null || objKyc.dl_no__c ==''){
                            System.debug(' @@@ Not Blank ');
                            String original = objKyc.dl_no__c;
                            if(original.length()>0){
                                String valueToMask = original.substring(1, 4);
                                String mask = '*'.repeat(valueToMask.length());
                                String masked = original.replaceFirst(valueToMask, mask);
                                tempObj.KYC_Details = masked;  
                            }
                            
                        }else{
                            System.debug('@@@ Blank ');
                            tempObj.KYC_Details = 'NA';
                        }
                        
                        
                        
                    }
                    
                    //If Record Type is Email
                    if(objKyc.RecordType.Name == 'Email'){
                        // tempObj.KYC_Details = objKyc.Email_ID__c;
                        if(objKyc.Email_ID__c!= null || objKyc.Email_ID__c ==''){
                            System.debug(' @@@ Not Blank ');
                            String original = objKyc.Email_ID__c;
                            if(original.length()>0){
                                String valueToMask = original.substring(1, 4);
                                String mask = '*'.repeat(valueToMask.length());
                                String masked = original.replaceFirst(valueToMask, mask);
                                tempObj.KYC_Details = masked;  
                            }
                            
                        }else{
                            System.debug('@@@ Blank ');
                            tempObj.KYC_Details = 'NA';
                        } 
                        
                        
                    }
                    
                    //If Record Type is FDA
                    if(objKyc.RecordType.Name == 'FDA'){
                        //tempObj.KYC_Details = objKyc.fda_licence_no__c;
                        if(objKyc.fda_licence_no__c!= null || objKyc.fda_licence_no__c ==''){
                            System.debug(' @@@ Not Blank ');
                            String original = objKyc.fda_licence_no__c;
                            if(original.length()>0){
                                String valueToMask = original.substring(1, 4);
                                String mask = '*'.repeat(valueToMask.length());
                                String masked = original.replaceFirst(valueToMask, mask);
                                tempObj.KYC_Details = masked;  
                            }
                            
                        }else{
                            System.debug('@@@ Blank ');
                            tempObj.KYC_Details = 'NA';
                        }
                        
                    }
                    //If Record Type is     FSSAI
                    if(objKyc.RecordType.Name == 'FSSAI'){
                        //tempObj.KYC_Details = objKyc.fssai_reg_no__c;
                        if(objKyc.fssai_reg_no__c!= null || objKyc.fssai_reg_no__c ==''){
                            System.debug(' @@@ Not Blank ');
                            String original = objKyc.fssai_reg_no__c;
                            if(original.length()>0){
                                String valueToMask = original.substring(1, 4);
                                String mask = '*'.repeat(valueToMask.length());
                                String masked = original.replaceFirst(valueToMask, mask);
                                tempObj.KYC_Details = masked;  
                            }
                            
                        }else{
                            System.debug('@@@ Blank ');
                            tempObj.KYC_Details = 'NA';
                        }
                        
                    }
                    
                    //If Record Type is Gst Firm Name
                    if(objKyc.RecordType.Name == 'Gst'){
                        
                        if(objKyc.gst_gstin__c!= null || objKyc.gst_gstin__c ==''){
                            System.debug(' @@@ Not Blank ');
                            String original = objKyc.gst_gstin__c;
                            if(original.length()>0){
                                String valueToMask = original.substring(1, 4);
                                String mask = '*'.repeat(valueToMask.length());
                                String masked = original.replaceFirst(valueToMask, mask);
                                tempObj.KYC_Details = masked;  
                            }
                            
                        }else{
                            System.debug('@@@ Blank ');
                            tempObj.KYC_Details = 'NA';
                        }                        
                        
                        // tempObj.KYC_Details = objKyc.gst_gstin__c;  
                    }
                    
                    
                    
                    //If Record Type is PAN Card    
                    if(objKyc.RecordType.Name == 'PAN Card'){
                        List<ContentDocumentLink> ContentList = [SELECT Id, LinkedEntityId, ContentDocumentId, IsDeleted, SystemModstamp, 
                                                                 ShareType, Visibility 
                                                                 FROM ContentDocumentLink 
                                                                 WHERE LinkedEntityId=:objKyc.Id];
                        
                        if(objKyc.PAN_Number__c!= null || objKyc.PAN_Number__c ==''){
                            System.debug(' @@@ Not Blank ');
                            String original = objKyc.PAN_Number__c;
                            if(original.length()>0){
                                String valueToMask = original.substring(1, 4);
                                String mask = '*'.repeat(valueToMask.length());
                                String masked = original.replaceFirst(valueToMask, mask);
                                tempObj.KYC_Details = masked;  
                                if(ContentList.size()>0){
                                    tempObj.displaymsg = true;
                                    tempObj.imgAvail ='Image Uploaded';
                                }else{
                                    tempObj.displaymsg = false;
                                    tempObj.imgAvail ='NA';
                                }
                            }
                            
                        }else{
                            System.debug('@@@ Blank ');
                            tempObj.KYC_Details = 'NA';
                        }
                        
                        //tempObj.KYC_Details = objKyc.PAN_Number__c;  
                    }
                    
                    
                    //If Record Type is Passport
                    if(objKyc.RecordType.Name == 'Passport'){
                        System.debug('objKyc ID is  '+objKyc.Id);
                        //SELECT Id, LinkedEntityId, ContentDocumentId, IsDeleted, SystemModstamp, ShareType, Visibility FROM ContentDocumentLink WHERE LinkedEntityId='a410k000000WDiOAAW'
                        List<ContentDocumentLink> ContentList = [SELECT Id, LinkedEntityId, ContentDocumentId, IsDeleted, SystemModstamp, 
                                                                 ShareType, Visibility 
                                                                 FROM ContentDocumentLink 
                                                                 WHERE LinkedEntityId=:objKyc.Id];
                        
                        System.debug('@@@ passport ContentList size '+ContentList.size());
                        
                        if(ContentList.size()>0){
                            System.debug('### Inside Passport image Uploaded');
                            tempObj.displaymsg = true;
                            tempObj.imgAvail ='Image Uploaded';
                        }else{
                            tempObj.displaymsg = false;
                            tempObj.imgAvail ='NA';
                        }
                        
                        System.debug('@@@  objKyc.psp_passport_no__c '+objKyc.psp_passport_no__c);
                        if(objKyc.psp_passport_no__c!= null || objKyc.psp_passport_no__c ==''){
                            System.debug(' #### Not Blank ');
                            String original = objKyc.psp_passport_no__c;
                            if(original.length()>0){
                                String valueToMask = original.substring(1, 4);
                                String mask = '*'.repeat(valueToMask.length());
                                String masked = original.replaceFirst(valueToMask, mask);
                                tempObj.KYC_Details = masked;
                            }
                            
                        }else{
                            System.debug('@@@ Blank ');
                            tempObj.KYC_Details = 'NA';
                        }
                        
                        
                        // tempObj.KYC_Details = objKyc.psp_passport_no__c;  
                    }
                    
                    //If Record Type is Voter ID
                    if(objKyc.RecordType.Name == 'Voter ID'){
                        
                        if(objKyc.vi_req_epic_no__c!= null || objKyc.vi_req_epic_no__c ==''){
                            System.debug(' @@@ Not Blank ');
                            String original = objKyc.vi_req_epic_no__c;
                            if(original.length()>0){
                                String valueToMask = original.substring(1, 4);
                                String mask = '*'.repeat(valueToMask.length());
                                String masked = original.replaceFirst(valueToMask, mask);
                                tempObj.KYC_Details = masked;  
                            }
                            
                        }else{
                            System.debug('@@@ Blank ');
                            tempObj.KYC_Details = 'NA';
                        }
                        
                        
                        // tempObj.KYC_Details = objKyc.vi_req_epic_no__c;  
                    }
                    
                    System.debug('objKyc.KYC_Last_Updated_Date_Time__c '+objKyc.KYC_Last_Updated_Date_Time__c);
                    
                    if(objKyc.KYC_Last_Updated_Date_Time__c == null){
                        tempObj.KYC_Last_Updated ='';
                    }else{
                        tempObj.KYC_Last_Updated = (objKyc.KYC_Last_Updated_Date_Time__c).format();    
                    }
                    
                    Integer confidenceScore = Integer.valueOf(objKyc.Confidence_score__c);
                    
                    if(objKyc.RecordType.Name=='PAN Card'){
                        
                        if(objKyc.Confidence_score__c == 0){
                            System.debug('==zero');
                            tempObj.diplayClass = true;
                            tempObj.diplayClass1 = false;
                            tempObj.confidenceScoreStyleClass ='';
                            tempObj.confidence_Score='';
                            
                        }else{
                            System.debug('==Not zero');
                           System.debug('@!!objKyc.RecordType.Name '+objKyc.RecordType.Name);
                        System.debug('@@ Obje kyc status '+objKyc.Kyc_status__c);
                        if(objKyc.Kyc_status__c =='Failed' && objKyc.KYC_Integration_Status__c =='Failed'){
                            tempObj.diplayClass = false;
                            tempObj.diplayClass1 = true;
                            tempObj.confidenceScoreStyleClass ='fa fa-exclamation-circle icon-red';
                        }else{
                            tempObj.diplayClass = true;
                            tempObj.diplayClass1 = false;
                            tempObj.confidence_Score = String.valueOf(objKyc.Confidence_score__c);
                            List<KYC_Configuration__mdt> KYC_ConfigurationLst = new List <KYC_Configuration__mdt>();
                            KYC_ConfigurationLst = [SELECT MasterLabel, QualifiedApiName, Red_Range__c,Orange_Range__c,Green_Range__c 
                                                    FROM KYC_Configuration__mdt 
                                                    WHERE QualifiedApiName ='PAN_Card'];
                            if(KYC_ConfigurationLst.size()>0){
                                String redRange = KYC_ConfigurationLst[0].Red_Range__c;
                                String orangeRange = KYC_ConfigurationLst[0].Orange_Range__c;
                                String greenRange = KYC_ConfigurationLst[0].Green_Range__c;
                                
                                String [] arrayOfRed = new List<String>();
                                String [] arrayOfOrange = new List<String>();
                                String [] arrayOfGreen = new List<String>();
                                
                                arrayOfRed = redRange.split(' - ');
                                arrayOfOrange = orangeRange.split(' - ');
                                arrayOfGreen = greenRange.split(' - ');
                                
                                System.debug('@@@ arrayOfRed '+arrayOfRed[0]);
                                System.debug('@@@ arrayOfRed '+arrayOfRed[1]);
                                
                                System.debug('@@@ arrayOfOrange '+arrayOfOrange[0]);
                                System.debug('@@@ arrayOfOrange '+arrayOfOrange[1]);
                                
                                System.debug('@@@ arrayOfGreen '+arrayOfGreen[0]);
                                System.debug('@@@ arrayOfGreen '+arrayOfGreen[1]);
                                
                                 
                                    if(confidenceScore>=Integer.valueOf(arrayOfRed[0]) && confidenceScore<=Integer.valueOf(arrayOfRed[1])){
                                        System.debug('for Red class');
                                        tempObj.confidenceScoreStyleClass ='numberCircle2';
                                        
                                    }else if(confidenceScore>=Integer.valueOf(arrayOfOrange[0]) && confidenceScore<=Integer.valueOf(arrayOfOrange[1])){
                                        System.debug('for Oranage class');
                                        tempObj.confidenceScoreStyleClass ='numberCircle3';
                                    }else if(confidenceScore>=Integer.valueOf(arrayOfGreen[0]) && confidenceScore<=Integer.valueOf(arrayOfGreen[1])){
                                        System.debug('for Green Class');
                                        tempObj.confidenceScoreStyleClass ='numberCircle1';
                                    }
                            }// end KYC_ConfigurationLst.size()>0
                            
                        } 
                            
                        }
                        
                        
                        
                        
                    } //end of pan card checking                  
                    else if(objKyc.RecordType.Name=='Gst'){
                        if(objKyc.Confidence_score__c == 0){
                            tempObj.diplayClass = true;
                            tempObj.diplayClass1 = false;
                            tempObj.confidenceScoreStyleClass ='';
                            tempObj.confidence_Score='';
                            
                        }else{
                            
                            if(objKyc.Kyc_status__c =='Failed' && objKyc.KYC_Integration_Status__c=='Failed'){
                                tempObj.diplayClass = false;
                                tempObj.diplayClass1 = true;
                                tempObj.confidenceScoreStyleClass ='fa fa-exclamation-circle icon-red';
                            }else{
                            tempObj.diplayClass = true;
                            tempObj.diplayClass1 = false;
                            tempObj.confidence_Score = String.valueOf(objKyc.Confidence_score__c);
                            List<KYC_Configuration__mdt> KYC_ConfigurationLst = new List <KYC_Configuration__mdt>();
                            KYC_ConfigurationLst = [SELECT MasterLabel, QualifiedApiName, Red_Range__c,Orange_Range__c,Green_Range__c 
                                                    FROM KYC_Configuration__mdt 
                                                    WHERE QualifiedApiName ='GST'];
                            if(KYC_ConfigurationLst.size()>0){
                                String redRange = KYC_ConfigurationLst[0].Red_Range__c;
                                String orangeRange = KYC_ConfigurationLst[0].Orange_Range__c;
                                String greenRange = KYC_ConfigurationLst[0].Green_Range__c;
                                
                                String [] arrayOfRed = new List<String>();
                                String [] arrayOfOrange = new List<String>();
                                String [] arrayOfGreen = new List<String>();
                                
                                arrayOfRed = redRange.split(' - ');
                                arrayOfOrange = orangeRange.split(' - ');
                                arrayOfGreen = greenRange.split(' - ');
                                
                                System.debug('@@@ arrayOfRed '+arrayOfRed[0]);
                                System.debug('@@@ arrayOfRed '+arrayOfRed[1]);
                                
                                System.debug('@@@ arrayOfOrange '+arrayOfOrange[0]);
                                System.debug('@@@ arrayOfOrange '+arrayOfOrange[1]);
                                
                                System.debug('@@@ arrayOfGreen '+arrayOfGreen[0]);
                                System.debug('@@@ arrayOfGreen '+arrayOfGreen[1]);
                                
                                if(confidenceScore>=Integer.valueOf(arrayOfRed[0]) && confidenceScore<=Integer.valueOf(arrayOfRed[1])){
                                    System.debug('for Red class');
                                    tempObj.confidenceScoreStyleClass ='numberCircle2';
                                    
                                }else if(confidenceScore>=Integer.valueOf(arrayOfOrange[0]) && confidenceScore<=Integer.valueOf(arrayOfOrange[1])){
                                    System.debug('for Oranage class');
                                    tempObj.confidenceScoreStyleClass ='numberCircle3';
                                }else if(confidenceScore>=Integer.valueOf(arrayOfGreen[0]) && confidenceScore<=Integer.valueOf(arrayOfGreen[1])){
                                    System.debug('for Green Class');
                                    tempObj.confidenceScoreStyleClass ='numberCircle1';
                                }
                                
                                
                                
                            }// end KYC_ConfigurationLst.size()>0  
                        }                            
                        }
                        
                        
                        
                    }else if(objKyc.RecordType.Name=='Passport'){
                        
                        if(objKyc.Confidence_score__c ==0){
                            
                            System.debug('==zero');
                            tempObj.diplayClass = true;
                            tempObj.diplayClass1 = false;
                            tempObj.confidenceScoreStyleClass ='';
                            tempObj.confidence_Score='';

                            
                        }else{
                            if(objKyc.Kyc_status__c=='Failed' && objKyc.KYC_Integration_Status__c=='Failed'){
                            tempObj.diplayClass = false;
                            tempObj.diplayClass1 = true;
                            tempObj.confidenceScoreStyleClass ='fa fa-exclamation-circle icon-red';
                        }else{
                            tempObj.diplayClass = true;
                            tempObj.diplayClass1 = false;
                            tempObj.confidence_Score = String.valueOf(objKyc.Confidence_score__c);
                            List<KYC_Configuration__mdt> KYC_ConfigurationLst = new List <KYC_Configuration__mdt>();
                            KYC_ConfigurationLst = [SELECT MasterLabel, QualifiedApiName, Red_Range__c,Orange_Range__c,Green_Range__c 
                                                    FROM KYC_Configuration__mdt 
                                                    WHERE QualifiedApiName ='Passport'];
                            if(KYC_ConfigurationLst.size()>0){
                                String redRange = KYC_ConfigurationLst[0].Red_Range__c;
                                String orangeRange = KYC_ConfigurationLst[0].Orange_Range__c;
                                String greenRange = KYC_ConfigurationLst[0].Green_Range__c;
                                
                                String [] arrayOfRed = new List<String>();
                                String [] arrayOfOrange = new List<String>();
                                String [] arrayOfGreen = new List<String>();
                                
                                arrayOfRed = redRange.split(' - ');
                                arrayOfOrange = orangeRange.split(' - ');
                                arrayOfGreen = greenRange.split(' - ');
                                
                                System.debug('@@@ arrayOfRed '+arrayOfRed[0]);
                                System.debug('@@@ arrayOfRed '+arrayOfRed[1]);
                                
                                System.debug('@@@ arrayOfOrange '+arrayOfOrange[0]);
                                System.debug('@@@ arrayOfOrange '+arrayOfOrange[1]);
                                
                                System.debug('@@@ arrayOfGreen '+arrayOfGreen[0]);
                                System.debug('@@@ arrayOfGreen '+arrayOfGreen[1]);
                                
                                if(confidenceScore>=Integer.valueOf(arrayOfRed[0]) && confidenceScore<=Integer.valueOf(arrayOfRed[1])){
                                    System.debug('for Red class');
                                    tempObj.confidenceScoreStyleClass ='numberCircle2';
                                    
                                }else if(confidenceScore>=Integer.valueOf(arrayOfOrange[0]) && confidenceScore<=Integer.valueOf(arrayOfOrange[1])){
                                    System.debug('for Oranage class');
                                    tempObj.confidenceScoreStyleClass ='numberCircle3';
                                }else if(confidenceScore>=Integer.valueOf(arrayOfGreen[0]) && confidenceScore<=Integer.valueOf(arrayOfGreen[1])){
                                    System.debug('for Green Class');
                                    tempObj.confidenceScoreStyleClass ='numberCircle1';
                                }
                                
                                
                                
                            }// end KYC_ConfigurationLst.size()>0  
                        }
                            
                            
                        }
                        
                         
                        
                    }else if(objKyc.RecordType.Name=='Bank Account'){
                        if(objKyc.Confidence_score__c== 0){
                          System.debug('==zero');
                            tempObj.diplayClass = true;
                            tempObj.diplayClass1 = false;
                            tempObj.confidenceScoreStyleClass ='';
                            tempObj.confidence_Score='';

                            
                        }else{
                           
                             if(objKyc.Kyc_status__c =='Failed' && objKyc.KYC_Integration_Status__c=='Failed'){
                            tempObj.diplayClass = false;
                            tempObj.diplayClass1 = true;
                            tempObj.confidenceScoreStyleClass ='fa fa-exclamation-circle icon-red';
                        }else{
                            tempObj.diplayClass = true;
                            tempObj.diplayClass1 = false;
                            
                            
                            tempObj.confidence_Score = String.valueOf(objKyc.Confidence_score__c);
                            
                            List<KYC_Configuration__mdt> KYC_ConfigurationLst = new List <KYC_Configuration__mdt>();
                            KYC_ConfigurationLst = [SELECT MasterLabel, QualifiedApiName, Red_Range__c,Orange_Range__c,Green_Range__c 
                                                    FROM KYC_Configuration__mdt 
                                                    WHERE QualifiedApiName ='Account_Number'];
                            if(KYC_ConfigurationLst.size()>0){
                                String redRange = KYC_ConfigurationLst[0].Red_Range__c;
                                String orangeRange = KYC_ConfigurationLst[0].Orange_Range__c;
                                String greenRange = KYC_ConfigurationLst[0].Green_Range__c;
                                
                                String [] arrayOfRed = new List<String>();
                                String [] arrayOfOrange = new List<String>();
                                String [] arrayOfGreen = new List<String>();
                                
                                arrayOfRed = redRange.split(' - ');
                                arrayOfOrange = orangeRange.split(' - ');
                                arrayOfGreen = greenRange.split(' - ');
                                
                                System.debug('@@@ arrayOfRed '+arrayOfRed[0]);
                                System.debug('@@@ arrayOfRed '+arrayOfRed[1]);
                                
                                System.debug('@@@ arrayOfOrange '+arrayOfOrange[0]);
                                System.debug('@@@ arrayOfOrange '+arrayOfOrange[1]);
                                
                                System.debug('@@@ arrayOfGreen '+arrayOfGreen[0]);
                                System.debug('@@@ arrayOfGreen '+arrayOfGreen[1]);
                                
                                if(confidenceScore>=Integer.valueOf(arrayOfRed[0]) && confidenceScore<=Integer.valueOf(arrayOfRed[1])){
                                    System.debug('for Red class');
                                    tempObj.confidenceScoreStyleClass ='numberCircle2';
                                    
                                }else if(confidenceScore>=Integer.valueOf(arrayOfOrange[0]) && confidenceScore<=Integer.valueOf(arrayOfOrange[1])){
                                    System.debug('for Oranage class');
                                    tempObj.confidenceScoreStyleClass ='numberCircle3';
                                }else if(confidenceScore>=Integer.valueOf(arrayOfGreen[0]) && confidenceScore<=Integer.valueOf(arrayOfGreen[1])){
                                    System.debug('for Green Class');
                                    tempObj.confidenceScoreStyleClass ='numberCircle1';
                                }
                                
                            }// end KYC_ConfigurationLst.size()>0  
                        }
                        
                        
                            
                            
                        }
                        
                        
                        
                        
                        
                    }else if(objKyc.RecordType.Name=='Email'){
                        //for Email
                        tempObj.diplayClass = false;
                        tempObj.diplayClass1 = true;
                        if(objKyc.Kyc_status__c =='NA'){
                            tempObj.confidenceScoreStyleClass ='';
                        }else if(objKyc.Kyc_status__c =='Not Done'){
                            tempObj.confidenceScoreStyleClass ='fa fa-exclamation-circle icon-yellow';  
                        }else if(objKyc.Kyc_status__c == 'Valid'){
                            tempObj.confidenceScoreStyleClass ='fa fa-check-circle icon-green';
                        }else if(objKyc.Kyc_status__c=='Not Valid'){
                            tempObj.confidenceScoreStyleClass ='fa fa-times-circle icon-red';  
                        }else if(objKyc.Kyc_status__c=='Failed'){
                            tempObj.confidenceScoreStyleClass ='fa fa-exclamation-circle icon-red';
                        }
                        
                    }else if(objKyc.RecordType.Name=='Voter Id'){
                        //for voter id
                        tempObj.diplayClass = false;
                        tempObj.diplayClass1 = true;
                        if(objKyc.Kyc_status__c =='NA'){
                            tempObj.confidenceScoreStyleClass ='';
                        }else if(objKyc.Kyc_status__c =='Not Done'){
                            tempObj.confidenceScoreStyleClass ='fa fa-exclamation-circle icon-yellow';
                        }else if(objKyc.Kyc_status__c == 'Valid'){
                            tempObj.confidenceScoreStyleClass ='fa fa-check-circle icon-green';
                        }else if(objKyc.Kyc_status__c=='Not Valid'){
                            tempObj.confidenceScoreStyleClass ='fa fa-times-circle icon-red'; 
                        }else if(objKyc.Kyc_status__c=='Failed'){
                            tempObj.confidenceScoreStyleClass ='fa fa-exclamation-circle icon-red'; 
                        } 
                    }else if(objKyc.RecordType.Name=='FSSAI'){
                        //FSSAI
                        tempObj.diplayClass = false;
                        tempObj.diplayClass1 = true;
                        if(objKyc.Kyc_status__c =='NA'){
                            tempObj.confidenceScoreStyleClass ='';
                        }else if(objKyc.Kyc_status__c =='Not Done'){
                            tempObj.confidenceScoreStyleClass ='fa fa-exclamation-circle icon-yellow';
                        }else if(objKyc.Kyc_status__c == 'Valid'){
                            tempObj.confidenceScoreStyleClass ='fa fa-check-circle icon-green';
                        }else if(objKyc.Kyc_status__c=='Not Valid'){
                            tempObj.confidenceScoreStyleClass ='fa fa-times-circle icon-red'; 
                        }else if(objKyc.Kyc_status__c=='Failed'){
                            tempObj.confidenceScoreStyleClass ='fa fa-exclamation-circle icon-red'; 
                        } 
                    }else if(objKyc.RecordType.Name =='Driving License'){
                        //Driving liences 
                        System.debug('@@@@ objKyc.RecordType.Name '+objKyc.RecordType.Name);
                        tempObj.diplayClass = false;
                        tempObj.diplayClass1 = true;
                        if(objKyc.Kyc_status__c =='NA'){
                            tempObj.confidenceScoreStyleClass ='';
                        }else if(objKyc.Kyc_status__c =='Not Done'){
                            tempObj.confidenceScoreStyleClass ='fa fa-exclamation-circle icon-yellow';
                        }else if(objKyc.Kyc_status__c == 'Valid'){
                            tempObj.confidenceScoreStyleClass ='fa fa-check-circle icon-green';
                        }else if(objKyc.Kyc_status__c=='Not Valid'){
                            tempObj.confidenceScoreStyleClass ='fa fa-times-circle icon-red'; 
                        }else if(objKyc.Kyc_status__c=='Failed'){
                            tempObj.confidenceScoreStyleClass ='fa fa-exclamation-circle icon-red'; 
                        } 
                        
                    }else if(objKyc.RecordType.Name=='FDA'){
                        tempObj.diplayClass = false;
                        tempObj.diplayClass1 = true;
                        if(objKyc.Kyc_status__c =='NA'){
                            tempObj.confidenceScoreStyleClass ='';
                        }else if(objKyc.Kyc_status__c =='Not Done'){
                            tempObj.confidenceScoreStyleClass ='fa fa-exclamation-circle icon-yellow';
                        }else if(objKyc.Kyc_status__c == 'Valid'){
                            tempObj.confidenceScoreStyleClass ='fa fa-check-circle icon-green';
                        }else if(objKyc.Kyc_status__c=='Not Valid'){
                            tempObj.confidenceScoreStyleClass ='fa fa-times-circle icon-red'; 
                        }else if(objKyc.Kyc_status__c=='Failed'){
                            tempObj.confidenceScoreStyleClass ='fa fa-exclamation-circle icon-red'; 
                        } 
                    }
                    
                    
                    
                    
                    
                    
                    
                    // tempObj.confidence_Score = String.valueOf(objKyc.Confidence_score__c);
                    /*
if(objKyc.Confidence_score__c>=80 && objKyc.Confidence_score__c<=100){
tempObj.confidenceScoreStyleClass ='numberCircle1';

}else if((objKyc.Confidence_score__c<=79 && objKyc.Confidence_score__c>=41) ){
tempObj.confidenceScoreStyleClass ='numberCircle3';

}else{
tempObj.confidenceScoreStyleClass ='numberCircle2';

}*/
                    
                    
                    
                    if(objKyc.Kyc_status__c =='Valid'){
                        tempObj.Is_KYC_Done = 'fa fa-check-circle icon-green';
                        
                    }else if(objKyc.Kyc_status__c =='Not Valid'){
                        tempObj.Is_KYC_Done = 'fa fa-times-circle icon-red'; 
                        
                    }else if(objKyc.Kyc_status__c=='Failed'){
                        
                        tempObj.Is_KYC_Done = 'fa fa-exclamation-circle icon-red'; 
                        
                    }else if(objKyc.Kyc_status__c=='Not Done'){
                        tempObj.Is_KYC_Done = 'fa fa-exclamation-circle icon-yellow';
                    }else if(objKyc.Kyc_status__c=='NA'){
                        tempObj.Is_KYC_Done = '';
                    }
                    
                    
                    if(objKyc.KYC_Integration_Status__c =='In Progress' || objKyc.KYC_Integration_Status__c =='Submitted for KYC' || objKyc.KYC_Integration_Status__c =='Partially Completed' || objKyc.KYC_Integration_Status__c =='NA' || ProflieName =='India Finance'){                     
                        tempObj.KYC_status = true; 
                        tempObj.showHide = true;
                        tempObj.disableclass ='disabled btn waves-effect waves-dark';
                        System.debug('in true part');
                    }else{
                        System.debug('in false part');
                        tempObj.KYC_status = false; 
                        tempObj.disableclass ='btn waves-effect waves-light';
                        
                        tempObj.showHide = false;
                    }
                    
                    lstKycDetails.add(tempObj); 
                    
                    
                    
                    
                } // End of for Loop
                
                
                
                System.debug('lstKycDetails '+lstKycDetails);
                System.debug('lstKycDetails size '+lstKycDetails.size());
            }
        }
        catch(Exception ex){
            System.debug('Error Message '+ex.getMessage());
            System.debug('Error Line Number '+ex.getLineNumber()); 
        }
        
        
    }
    
    public void showPopup() { 
        System.debug('SHow Popup');       
        System.debug('kycId is  '+kycId);
        displayPopUp = true; 
        
        KycObject =[SELECT Id,  IsDeleted, Name, CurrencyIsoCode, RecordTypeId,RecordType.Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, Account__c, Kyc_status__c, Confidence_score__c, Result__c, Input__c, Email_ID__c, KYC_Last_Updated_Date_Time__c, KYC_By__c, Request_JSON__c, Respone_JSON__c, Consent__c, Request_Id__c, Status_Code__c, Email__c, email_resp_accept_all__c, email_resp_disposable__c, email_resp_email__c, email_resp_mx_records__c, email_resp_regexp__c, email_resp_result__c, email_resp_smtp_check__c, email_resp_webmail__c, PAN_Number__c, pan_resp_name__c, dl_no__c, dl_dob__c, dl_resp_name__c, dl_resp_dob__c, dl_resp_Issue_Date__c, dl_resp_blood_group__c, dl_resp_father_husband_name__c, dl_resp_address__c, dl_resp_cov_issue_date__c, dl_resp_cov__c, dl_resp_validity_non_transport__c, dl_resp_validity_transport__c, vi_req_epic_no__c, vi_resp_ps_lat_long__c, vi_resp_rln_name_v1__c, vi_resp_rln_name_v2__c, vi_resp_rln_name_v3__c, vi_resp_part_no__c, vi_resp_rln_type__c, vi_resp_section_no__c, vi_resp_vid__c, vi_resp_name_v1__c, vi_resp_rln_name__c, vi_resp_district__c, vi_resp_last_update__c, vi_resp_state__c, vi_resp_ac_no__c, vi_resp_house_no__c, vi_resp_ps_name__c, vi_resp_pc_name__c, vi_resp_slno_inpart__c, vi_resp_name__c, vi_resp_part_name__c, vi_resp_st_code__c, vi_resp_gender__c, vi_resp_age__c, vi_resp_ac_name__c, vi_resp_epic_no__c, vi_resp_name_v3__c, vi_resp_name_v2__c, vi_resp_dob__c, psp_resp_dob__c, psp_resp_doe__c, psp_resp_gender__c, psp_passport_no__c, psp_resp_type__c, psp_resp_country__c, psp_resp_placeOfIssue__c, psp_resp_placeOfBirth__c, mob_mobile_no__c, mob_resp_message__c, fssai_reg_no__c, fssai_resp_status__c, fssai_resp_lic_type__c, fssai_resp_lic_no__c, fssai_resp_firm_name__c, fssai_resp_address__c, ban_ifsc__c, ban_account_number__c, ban_resp_bankTxnStatus__c, ban_resp_account_number__c, ban_resp_ifsc__c, ban_resp_account_name__c, ban_resp_bank_response__c, ifsc_ifsc_code__c, ifsc_resp_city__c, ifsc_resp_district__c, ifsc_resp_ifsc__c, ifsc_resp_micr__c, ifsc_resp_state__c, ifsc_resp_contact__c, ifsc_resp_branch__c, ifsc_resp_address__c, ifsc_resp_bank__c, fda_licence_no__c, fda_state__c, fda_resp_store_name__c, fda_resp_contact_number__c, fda_resp_license_detail__c, fda_resp_name__c, fda_resp_address__c, ma_name1__c, ma_name2__c, psp_resp_given_name__c, psp_resp_last_name__c, ma_resp_score__c, ma_resp_result__c, gst_gstin__c, API_Count__c, OCR_verified__c, ma_type__c, ma_preset__c, gst_resp_mbr__c, gst_resp_canFlag__c, gst_resp_pradr__c, gst_resp_tradeNam__c, gst_resp_lstupdt__c, gst_resp_contacted__c, gst_resp_rgdt__c, gst_resp_stjCd__c, gst_resp_stj__c, gst_resp_ctjCd__c, gst_resp_ppr__c, gst_resp_dty__c, gst_resp_cmpRt__c, gst_resp_cxdt__c, gst_resp_ctb__c, gst_resp_sts__c, gst_resp_gstin__c, gst_resp_lgnm__c, gst_resp_nba__c, gst_resp_adadr__c, gst_resp_ctj__c, Distributor_Document__c, API_Count_Name__c, res_kyc_int_datetime__c, req_kyc_int_datetime__c, Territory__c, Total_Api_Count__c, KYC_Integration_Status__c, First_Name__c, Last_Name__c, DOB__c, API_Count_OCR__c, ocr_pan_resp_father__c, ocr_pan_resp_date__c, ocr_pan_resp_dateofIssue__c, ban_name__c FROM KYC__c WHERE Id=:kycId];
        
    }
    
    public void closePopup() {        
        displayPopup = false;     
    }  
    
    
    public void runKYC(){
        try{
            String respns ='';
            System.debug('click run KYC KYC ID '+ kycId);
            disableKycId  = kycId;
            
            // KycRequestHandlerController kycRequestHandlerObj = new KycRequestHandlerController();
            AccountKycRequestHandlerController kycRequestHandlerObj = new AccountKycRequestHandlerController();
            
            KYC__c kyObj1 =new KYC__c();
            
            kyObj1 =[SELECT Id,  IsDeleted, Name, CurrencyIsoCode, RecordTypeId,RecordType.Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, Account__c, Kyc_status__c, Confidence_score__c, Result__c, Input__c, Email_ID__c, KYC_Last_Updated_Date_Time__c, KYC_By__c, Request_JSON__c, Respone_JSON__c, Consent__c, Request_Id__c, Status_Code__c, Email__c, email_resp_accept_all__c, email_resp_disposable__c, email_resp_email__c, email_resp_mx_records__c, email_resp_regexp__c, email_resp_result__c, email_resp_smtp_check__c, email_resp_webmail__c, PAN_Number__c, pan_resp_name__c, dl_no__c, dl_dob__c, dl_resp_name__c, dl_resp_dob__c, dl_resp_Issue_Date__c, dl_resp_blood_group__c, dl_resp_father_husband_name__c, dl_resp_address__c, dl_resp_cov_issue_date__c, dl_resp_cov__c, dl_resp_validity_non_transport__c, dl_resp_validity_transport__c, vi_req_epic_no__c, vi_resp_ps_lat_long__c, vi_resp_rln_name_v1__c, vi_resp_rln_name_v2__c, vi_resp_rln_name_v3__c, vi_resp_part_no__c, vi_resp_rln_type__c, vi_resp_section_no__c, vi_resp_vid__c, vi_resp_name_v1__c, vi_resp_rln_name__c, vi_resp_district__c, vi_resp_last_update__c, vi_resp_state__c, vi_resp_ac_no__c, vi_resp_house_no__c, vi_resp_ps_name__c, vi_resp_pc_name__c, vi_resp_slno_inpart__c, vi_resp_name__c, vi_resp_part_name__c, vi_resp_st_code__c, vi_resp_gender__c, vi_resp_age__c, vi_resp_ac_name__c, vi_resp_epic_no__c, vi_resp_name_v3__c, vi_resp_name_v2__c, vi_resp_dob__c, psp_resp_dob__c, psp_resp_doe__c, psp_resp_gender__c, psp_passport_no__c, psp_resp_type__c, psp_resp_country__c, psp_resp_placeOfIssue__c, psp_resp_placeOfBirth__c, mob_mobile_no__c, mob_resp_message__c, fssai_reg_no__c, fssai_resp_status__c, fssai_resp_lic_type__c, fssai_resp_lic_no__c, fssai_resp_firm_name__c, fssai_resp_address__c, ban_ifsc__c, ban_account_number__c, ban_resp_bankTxnStatus__c, ban_resp_account_number__c, ban_resp_ifsc__c, ban_resp_account_name__c, ban_resp_bank_response__c, ifsc_ifsc_code__c, ifsc_resp_city__c, ifsc_resp_district__c, ifsc_resp_ifsc__c, ifsc_resp_micr__c, ifsc_resp_state__c, ifsc_resp_contact__c, ifsc_resp_branch__c, ifsc_resp_address__c, ifsc_resp_bank__c, fda_licence_no__c, fda_state__c, fda_resp_store_name__c, fda_resp_contact_number__c, fda_resp_license_detail__c, fda_resp_name__c, fda_resp_address__c, ma_name1__c, ma_name2__c, psp_resp_given_name__c, psp_resp_last_name__c, ma_resp_score__c, ma_resp_result__c, gst_gstin__c, API_Count__c, OCR_verified__c, ma_type__c, ma_preset__c, gst_resp_mbr__c, gst_resp_canFlag__c, gst_resp_pradr__c, gst_resp_tradeNam__c, gst_resp_lstupdt__c, gst_resp_contacted__c, gst_resp_rgdt__c, gst_resp_stjCd__c, gst_resp_stj__c, gst_resp_ctjCd__c, gst_resp_ppr__c, gst_resp_dty__c, gst_resp_cmpRt__c, gst_resp_cxdt__c, gst_resp_ctb__c, gst_resp_sts__c, gst_resp_gstin__c, gst_resp_lgnm__c, gst_resp_nba__c, gst_resp_adadr__c, gst_resp_ctj__c, Distributor_Document__c, API_Count_Name__c, res_kyc_int_datetime__c, req_kyc_int_datetime__c, Territory__c, Total_Api_Count__c, KYC_Integration_Status__c, First_Name__c, Last_Name__c, DOB__c, API_Count_OCR__c, ocr_pan_resp_father__c, ocr_pan_resp_date__c, ocr_pan_resp_dateofIssue__c, ban_name__c FROM KYC__c WHERE Id=:kycId];
            
            System.debug('In run KYC kyObj '+kyObj1);
            
            if(kyObj1!=null){
                
                System.debug('Inside Run kyc function');
                respns = kycRequestHandlerObj.putKycRequestHandler(kyObj1.RecordType.Name,kyObj1,'Manual');
                System.debug('Response from Function '+respns);
                //redirect(kycId);
                lstKycDetails = new List<wrapKYCDeatils>();
                displayAll();
                System.debug('After display All');
                
            }
        }
        catch(Exception Ex){
            System.debug('Error Occure : '+Ex.getStackTraceString());
        }
        
        
    }// end of Function
    
    public PageReference redirect(String kId) {
        System.debug('Inside redirect function '+kId);
        
        PageReference pr = new PageReference('http://www.google.com');
        pr.setRedirect(true);
        return pr;
    }
    
    
    
    
    public class wrapKYCDeatils{ 
        
        public String KYC_Id     {get;set;} 
        public String KYC_Type   {get;set;} 
        public String KYC_Details    {get;set;}
        public String KYC_Last_Updated   {get;set;} 
        public String confidence_Score   {get;set;} 
        public String confidenceScoreStyleClass   {get;set;} 
        public String disableclass {get;set;}
        public String Is_KYC_Done    {get;set;} 
        public String indicate   {get;set;} 
        public Boolean KYC_status    {get;set;}
        public Boolean showHide {get;set;}
        public Boolean displaymsg {get;set;}
        public Boolean diplayClass {get;set;}
        public Boolean diplayClass1 {get;set;}
        public String imgAvail {get;set;}
        
        public wrapKYCDeatils(){
            KYC_Id ='';
            KYC_Type='';
            KYC_Details ='';
            confidence_Score='';
            Is_KYC_Done ='';
            indicate ='';
            KYC_status = false;
            showHide = false;
            confidenceScoreStyleClass='';
            disableclass ='';
            imgAvail='';
            displaymsg = false;
            diplayClass = false;
            diplayClass1 = false;
        }
        
        
    }
    
}