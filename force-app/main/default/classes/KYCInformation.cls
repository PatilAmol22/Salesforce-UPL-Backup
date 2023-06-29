public class KYCInformation {
    @auraenabled
    //List<KYC__c>
    public static void getKYCList(String accountId ,String SurveyId){ 
        try{
            Map<String,KYC__c> KycMap = new Map<String,KYC__c>();
            Map<String,String> KycRecordTypeMap = new Map<String,String>();
            Map<String,DistributorDocument__c> DistributorDocumentMap = new Map<String,DistributorDocument__c>();
            
            for(RecordType rec : [select Id,Name,SobjectType From recordtype where SobjectType = 'KYC__c']){
                KycRecordTypeMap.put(rec.Name,rec.Id);
            }
            
            for(KYC__c kyc : [SELECT Id,Name,psp_passport_no__c,recordtype.Name,PAN_Number__c,Email_ID__c,gst_gstin__c,
                                ban_account_number__c ,ban_ifsc__c
                                FROM KYC__c WHERE Account__c =: accountId]){
                KycMap.put(kyc.recordtype.Name , kyc);
            }
            
            List<Axedasurvey__c> surveyList = [SELECT Id,Name,Mention_Firm_PAN_no__c,Customer_e_mail_Address__c,Firms_operating_bank_Name_and_city__c
                                               ,Territory_del__c,Passport_number_of_Owner_proprietor__c,Firms_operating_Bank_acc_no__c,
                                               Customer_Fisrt_Name__c,Customer_Last_Name__c,DOB_Of_Firms_Owner__c,If_yes_mention_GST_no__c,Firm_operating_bank_acc_IFSC_code__c
                                               FROM Axedasurvey__c WHERE Id=: SurveyId limit 1];
            List<KYC__c>KycList = new List<KYC__c>();
            List<ContentDocumentLink> ContentDocumentLinkList = new List<ContentDocumentLink>();
            
            
            system.debug('@KycRecordTypeMap==>'+KycRecordTypeMap);
            system.debug('@KycMap ==>'+KycMap);
            system.debug('@surveyList ==>'+surveyList );
            
            /*for(String recDetail : KycRecordTypeMap.keySet()){
                if( !KycMap.containsKey(recDetail)){
                    
                    KYC__c kyc = new KYC__c();
                    kyc.Account__c = accountId;
                    kyc.Kyc_status__c = 'NA';
                    kyc.KYC_Integration_Status__c ='NA';
                    kyc.First_Name__c = surveyList[0].Customer_Fisrt_Name__c;
                    kyc.Last_Name__c = surveyList[0].Customer_Last_Name__c;
                    kyc.DOB__c = surveyList[0].DOB_Of_Firms_Owner__c;
                    kyc.dl_dob__c = surveyList[0].DOB_Of_Firms_Owner__c;
                    kyc.RecordTypeId = KycRecordTypeMap.get(recDetail);
                    kyc.Territory__c = surveyList[0].Territory_del__c;
                    kyc.Name = recDetail;
                    kyc.API_Count_Name__c = 0;
                    kyc.API_Count_OCR__c = 0;
                    kyc.Confidence_score__c = 0;
                    kyc.Request_Type__c = ''; 
                    kyc.res_kyc_int_datetime__c = null; 
                    kyc.Request_JSON__c = ''; 
                    kyc.Respone_JSON__c =''; 
                    kyc.Status_Code__c = ''; 
                    kyc.Request_Id__c = ''; 
                    kyc.KYC_Last_Updated_Date_Time__c = null;
                    
                    if(surveyList != null && surveyList.size() > 0){
                        if(recDetail == 'PAN Card'){
                            kyc.PAN_Number__c = surveyList[0].Mention_Firm_PAN_no__c;
                            kyc.Kyc_status__c = 'Not Done';
                            kyc.KYC_Integration_Status__c ='Not Done';
                            kyc.pan_resp_name__c ='';   
                            kyc.ocr_pan_resp_father__c =''; 
                            kyc.ocr_pan_resp_date__c ='';  
                            kyc.ocr_pan_resp_dateofIssue__c = '';
                        }
                        else if(recDetail == 'Email'){
                            kyc.Email_ID__c = surveyList[0].Customer_e_mail_Address__c;
                            kyc.Kyc_status__c = 'Not Done';
                            kyc.KYC_Integration_Status__c ='Not Done';
                            kyc.email_resp_accept_all__c = false;
                            kyc.email_resp_regexp__c = false;   
                            kyc.email_resp_disposable__c = false;    
                            kyc.email_resp_result__c = false;    
                            kyc.email_resp_email__c = ''; 
                            kyc.email_resp_smtp_check__c = false;    
                            kyc.email_resp_mx_records__c = false;    
                            kyc.email_resp_webmail__c = false;   
                       }
                        else if(recDetail == 'Gst'){
                            kyc.gst_gstin__c = surveyList[0].If_yes_mention_GST_no__c;
                            kyc.Kyc_status__c = 'Not Done';
                            kyc.KYC_Integration_Status__c ='Not Done';
                            kyc.gst_resp_mbr__c = '';
                            kyc.gst_resp_ppr__c = '';
                            kyc.gst_resp_canFlag__c = '';
                            kyc.gst_resp_dty__c = '';
                            kyc.gst_resp_pradr__c  = ''; 
                            kyc.gst_resp_cmpRt__c  = ''; 
                            kyc.gst_resp_tradeNam__c = '';   
                            kyc.gst_resp_cxdt__c = '';   
                            kyc.gst_resp_lstupdt__c = '';
                            kyc.gst_resp_ctb__c = '';
                            kyc.gst_resp_contacted__c = '';  
                            kyc.gst_resp_sts__c = '';
                            kyc.gst_resp_rgdt__c = '';   
                            kyc.gst_resp_gstin__c= '';   
                            kyc.gst_resp_stjCd__c = '';  
                            kyc.gst_resp_lgnm__c = '';  
                            kyc.gst_resp_stj__c = '';
                            kyc.gst_resp_nba__c = '';
                            kyc.gst_resp_ctjCd__c = '';   
                            kyc.gst_resp_adadr__c = ''; 
                        }
                        else if(recDetail == 'Bank Account'){
                            kyc.ban_account_number__c = surveyList[0].Firms_operating_Bank_acc_no__c;
                            kyc.ban_name__c = surveyList[0].Firms_operating_bank_Name_and_city__c;
                            kyc.ban_ifsc__c = surveyList[0].Firm_operating_bank_acc_IFSC_code__c;
                            kyc.Kyc_status__c = 'Not Done';
                            kyc.KYC_Integration_Status__c ='Not Done';
                            kyc.ban_resp_account_name__c = ''; 
                            kyc.ban_resp_account_number__c = ''; 
                            kyc.ban_resp_bank_response__c = '';  
                            kyc.ban_resp_bankTxnStatus__c = '';   
                            kyc.ban_resp_ifsc__c = '';
                        }
                        else if(recDetail == 'Passport'){
                            kyc.psp_passport_no__c = surveyList[0].Passport_number_of_Owner_proprietor__c;
                            kyc.Kyc_status__c = 'Not Done';
                            kyc.KYC_Integration_Status__c ='Not Done';
                            kyc.psp_resp_given_name__c = ''; 
                            kyc.psp_resp_placeOfBirth__c= '';    
                            kyc.psp_resp_last_name__c = '';
                            kyc.psp_resp_doe__c = '';
                            kyc.psp_resp_country__c = '';
                            kyc.psp_resp_gender__c  = '';
                            kyc.psp_resp_dob__c = '';
                            kyc.psp_passport_no__c  = '';
                            kyc.psp_resp_placeOfIssue__c = '';   
                            kyc.psp_resp_type__c= '';
                        }
                        KycList.add(kyc);
                    }
                }else{
                    KYC__c kyc = new KYC__c(Id = KycMap.get(recDetail).Id);
                    kyc.Name = recDetail;
                    kyc.Kyc_status__c = 'NA';
                    kyc.KYC_Integration_Status__c ='Not Done';
                    kyc.First_Name__c = surveyList[0].Customer_Fisrt_Name__c;
                    kyc.Last_Name__c = surveyList[0].Customer_Last_Name__c;
                    kyc.DOB__c = surveyList[0].DOB_Of_Firms_Owner__c;
                    kyc.dl_dob__c = surveyList[0].DOB_Of_Firms_Owner__c;
                    kyc.Territory__c = surveyList[0].Territory_del__c;
                    kyc.API_Count_Name__c = 0;
                    kyc.API_Count_OCR__c = 0;
                    
                    if(recDetail == 'PAN Card' && surveyList[0].Mention_Firm_PAN_no__c != KycMap.get(recDetail).PAN_Number__c){
                            kyc.PAN_Number__c = surveyList[0].Mention_Firm_PAN_no__c;
                            kyc.Kyc_status__c = 'Not Done';
                            kyc.pan_resp_name__c ='';   
                            kyc.ocr_pan_resp_father__c =''; 
                            kyc.ocr_pan_resp_date__c ='';  
                            kyc.ocr_pan_resp_dateofIssue__c = '';
                            
                            //common fields
                            kyc.Confidence_score__c = 0;
                            kyc.Request_Type__c = ''; 
                            kyc.res_kyc_int_datetime__c = null; 
                            kyc.Request_JSON__c = ''; 
                            kyc.Respone_JSON__c =''; 
                            kyc.Status_Code__c = ''; 
                            kyc.Request_Id__c = ''; 
                            kyc.KYC_Last_Updated_Date_Time__c = null;
                            KycList.add(kyc);
                    }
                    else if(recDetail == 'Email' && surveyList[0].Customer_e_mail_Address__c != KycMap.get(recDetail).Email_ID__c){
                            kyc.Email_ID__c = surveyList[0].Customer_e_mail_Address__c;
                            kyc.Kyc_status__c = 'Not Done';
                            kyc.email_resp_accept_all__c = false;
                            kyc.email_resp_regexp__c = false;   
                            kyc.email_resp_disposable__c = false;    
                            kyc.email_resp_result__c = false;    
                            kyc.email_resp_email__c = ''; 
                            kyc.email_resp_smtp_check__c = false;    
                            kyc.email_resp_mx_records__c = false;    
                            kyc.email_resp_webmail__c = false;  
                            //common fields
                            kyc.Confidence_score__c = 0;
                            kyc.Request_Type__c = ''; 
                            kyc.res_kyc_int_datetime__c = null; 
                            kyc.Request_JSON__c = ''; 
                            kyc.Respone_JSON__c =''; 
                            kyc.Status_Code__c = ''; 
                            kyc.Request_Id__c = ''; 
                            kyc.KYC_Last_Updated_Date_Time__c = null; 
                            KycList.add(kyc);
                    }else if(recDetail == 'Gst' && surveyList[0].If_yes_mention_GST_no__c != KycMap.get(recDetail).gst_gstin__c){
                            kyc.gst_gstin__c = surveyList[0].If_yes_mention_GST_no__c;
                            kyc.Kyc_status__c = 'Not Done';
                            kyc.gst_resp_mbr__c = '';
                            kyc.gst_resp_ppr__c = '';
                            kyc.gst_resp_canFlag__c = '';
                            kyc.gst_resp_dty__c = '';
                            kyc.gst_resp_pradr__c  = ''; 
                            kyc.gst_resp_cmpRt__c  = ''; 
                            kyc.gst_resp_tradeNam__c = '';   
                            kyc.gst_resp_cxdt__c = '';   
                            kyc.gst_resp_lstupdt__c = '';
                            kyc.gst_resp_ctb__c = '';
                            kyc.gst_resp_contacted__c = '';  
                            kyc.gst_resp_sts__c = '';
                            kyc.gst_resp_rgdt__c = '';   
                            kyc.gst_resp_gstin__c= '';   
                            kyc.gst_resp_stjCd__c = '';  
                            kyc.gst_resp_lgnm__c = '';  
                            kyc.gst_resp_stj__c = '';
                            kyc.gst_resp_nba__c = '';
                            kyc.gst_resp_ctjCd__c = '';   
                            kyc.gst_resp_adadr__c = '';
                            //common fields
                            kyc.Confidence_score__c = 0;
                            kyc.Request_Type__c = ''; 
                            kyc.res_kyc_int_datetime__c = null; 
                            kyc.Request_JSON__c = ''; 
                            kyc.Respone_JSON__c =''; 
                            kyc.Status_Code__c = ''; 
                            kyc.Request_Id__c = ''; 
                            kyc.KYC_Last_Updated_Date_Time__c = null; 
                            KycList.add(kyc);
                    }
                    else if(recDetail == 'Bank Account' && (surveyList[0].Firms_operating_Bank_acc_no__c != KycMap.get(recDetail).ban_account_number__c || surveyList[0].Firm_operating_bank_acc_IFSC_code__c != KycMap.get(recDetail).ban_ifsc__c) ){
                            kyc.ban_account_number__c = surveyList[0].Firms_operating_Bank_acc_no__c;
                            kyc.ban_name__c = surveyList[0].Firms_operating_bank_Name_and_city__c;
                            kyc.ban_ifsc__c = surveyList[0].Firm_operating_bank_acc_IFSC_code__c;
                            kyc.Kyc_status__c = 'Not Done';
                            kyc.ban_resp_account_name__c = ''; 
                            kyc.ban_resp_account_number__c = ''; 
                            kyc.ban_resp_bank_response__c = '';  
                            kyc.ban_resp_bankTxnStatus__c = '';   
                            kyc.ban_resp_ifsc__c = '';
                            //common fields
                            kyc.Confidence_score__c = 0;
                            kyc.Request_Type__c = ''; 
                            kyc.res_kyc_int_datetime__c = null; 
                            kyc.Request_JSON__c = ''; 
                            kyc.Respone_JSON__c =''; 
                            kyc.Status_Code__c = ''; 
                            kyc.Request_Id__c = ''; 
                            kyc.KYC_Last_Updated_Date_Time__c =null;
                            KycList.add(kyc);
                    }
                    else if(recDetail == 'Passport' && surveyList[0].Passport_number_of_Owner_proprietor__c != KycMap.get(recDetail).psp_passport_no__c ){
                        kyc.psp_passport_no__c = surveyList[0].Passport_number_of_Owner_proprietor__c;
                        kyc.Kyc_status__c = 'Not Done';
                        kyc.psp_resp_given_name__c = ''; 
                        kyc.psp_resp_placeOfBirth__c= '';    
                        kyc.psp_resp_last_name__c = '';
                        kyc.psp_resp_doe__c = '';
                        kyc.psp_resp_country__c = '';
                        kyc.psp_resp_gender__c  = '';
                        kyc.psp_resp_dob__c = '';
                        kyc.psp_passport_no__c  = '';
                        kyc.psp_resp_placeOfIssue__c = '';   
                        kyc.psp_resp_type__c= '';
                        //common fields
                        kyc.Confidence_score__c = 0;
                        kyc.Request_Type__c = ''; 
                        kyc.res_kyc_int_datetime__c = null; 
                        kyc.Request_JSON__c = ''; 
                        kyc.Respone_JSON__c =''; 
                        kyc.Status_Code__c = ''; 
                        kyc.Request_Id__c = ''; 
                        kyc.KYC_Last_Updated_Date_Time__c = null;
                        KycList.add(kyc);
                    }
               }
            }
            system.debug('@KycList ==>'+KycList);
            if(KycList.size() > 0 )
                UPSERT KycList;
            
            */
            for(DistributorDocument__c dd : [SELECT Id,Documents_Type__c,AttachmentId__c FROM DistributorDocument__c WHERE Survey__c =: SurveyId]){
                if(dd.Documents_Type__c.indexOf('PAN Card') == 0 || dd.Documents_Type__c.indexOf('Pan Card') == 0) 
                    DistributorDocumentMap.put('pan card' , dd);
                //else if(dd.Documents_Type__c.indexOf('GST') == 0) 
                    //DistributorDocumentMap.put('gst' , dd);
                //else if(dd.Documents_Type__c.indexOf('Bank') == 0) 
                    //DistributorDocumentMap.put('bank account' , dd);
                else if(dd.Documents_Type__c.indexOf('Passport') == 0) 
                    DistributorDocumentMap.put('passport' , dd);
                //else 
                    //DistributorDocumentMap.put(dd.Documents_Type__c , dd);
                
            }
                
            system.debug('@DistributorDocumentMap==>'+DistributorDocumentMap);    
            for(String kyc : KycMap.keySet()){
                String kycName = kyc.toLowerCase();
                system.debug('@DistributorDocumentMap.contains key==>'+ kycName + ' =====>'+DistributorDocumentMap.containsKey(kycName ));           
                if(DistributorDocumentMap != null && DistributorDocumentMap.containsKey(kycName) ){
                
                    ContentDocumentLink cDe = new ContentDocumentLink();
                    cDe.ContentDocumentId = DistributorDocumentMap.get(kycName).AttachmentId__c;
                    cDe.LinkedEntityId = KycMap.get(kyc).Id; // you can use objectId,GroupId etc
                    cDe.ShareType = 'I'; // Inferred permission, checkout description of ContentDocumentLink object for more details
                    cDe.Visibility = 'InternalUsers';
                    ContentDocumentLinkList.add(cDe);
                }
            }
            system.debug('@ContentDocumentLinkList ==>'+ContentDocumentLinkList );
            //if(ContentDocumentLinkList.size() > 0 )
                //Insert ContentDocumentLinkList ;
        }catch(exception e){
            ApexLog.KYCExceptionHandler(e,accountId );
        }
    }
}