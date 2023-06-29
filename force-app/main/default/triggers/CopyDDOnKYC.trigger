/*
Test class Name :- CopyDDOnKYC_Test
Last Modified by Vishal Only Updated Test class(not Trigger) 
*/

trigger CopyDDOnKYC on DistributorDocument__c (After Insert) {
    Set<Id> AccountIdSet = new Set<Id>();
    Map<String,KYC__c> KYCMap = new Map<String,KYC__c>();
    for(DistributorDocument__c dd : Trigger.New){
        if(dd.Distributor__c != null)
            AccountIdSet.add(dd.Distributor__c);
    }
    system.debug('@AccountIdSet==>'+AccountIdSet);
    if(AccountIdSet.size() > 0){     
        List<KYC__c> kycList  = [SELECT Id,recordtype.Name,Account__c FROM KYC__c WHERE (recordtype.Name ='Passport' or recordtype.Name ='PAN Card') and Account__c IN : AccountIdSet];
        System.debug('kyc Lisyt is '+kycList);
        System.debug('kyc Lisyt is Size '+kycList.size());
        
        for(KYC__c kyc : [SELECT Id,recordtype.Name,Account__c FROM KYC__c WHERE (recordtype.Name ='Passport' or recordtype.Name ='PAN Card') and Account__c IN : AccountIdSet]){
            String recName = kyc.recordtype.Name.toLowercase();
            KYCMap.put(kyc.Account__c +''+ recName , kyc);
        }
    }
    system.debug('@KYCMap==>'+KYCMap);
    List<ContentDocumentLink> ContentDocumentLinkList = new List<ContentDocumentLink>();
    List<KYC__c> KYCUpdatedList = new List<KYC__c>();
    if(KYCMap.size() > 0){
        for(DistributorDocument__c dd : Trigger.New){
            system.debug('@@@@@@ddd====='+dd);
            String DocType = dd.Documents_Type__c != null ? dd.Documents_Type__c.toLowercase() : null;
            System.debug('DocType '+DocType);
            if(KYCMap.containsKey(dd.Distributor__c +''+ DocType )){
                ContentDocumentLink cDe = new ContentDocumentLink();
                cDe.ContentDocumentId = dd.AttachmentId__c;
                cDe.LinkedEntityId = KYCMap.get(dd.Distributor__c +''+ DocType ).Id; // you can use objectId,GroupId etc
                cDe.ShareType = 'I'; // Inferred permission, checkout description of ContentDocumentLink object for more details
                cDe.Visibility = 'InternalUsers';
                ContentDocumentLinkList.add(cDe);
            }
            if(DocType == 'passport' && KYCMap.containsKey(dd.Distributor__c +''+ DocType )){
                KYC__c kyc = new KYC__c(Id = KYCMap.get(dd.Distributor__c +''+ DocType).Id );
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
                //common fields
                kyc.Confidence_score__c = 0;
                kyc.Request_Type__c = ''; 
                kyc.res_kyc_int_datetime__c = null; 
                kyc.Request_JSON__c = ''; 
                kyc.Respone_JSON__c =''; 
                kyc.Status_Code__c = ''; 
                kyc.Request_Id__c = ''; 
                kyc.KYC_Last_Updated_Date_Time__c = null;
                KYCUpdatedList.add(kyc);
            }
        }
        try{
            system.debug('@ContentDocumentLinkList ==>'+ContentDocumentLinkList );
            if(ContentDocumentLinkList.size() > 0 )
                Insert ContentDocumentLinkList ;
                
            if(KYCUpdatedList.size() > 0)
                update KYCUpdatedList;
        }catch(exception e){}
    }
}