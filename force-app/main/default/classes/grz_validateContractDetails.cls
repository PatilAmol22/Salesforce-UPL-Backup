public with sharing class grz_validateContractDetails {
    
    @AuraEnabled
    public static String createTemplate(Id salesArea,Id Distributer) {
        system.debug('Distributer '+Distributer);
        system.debug('salesArea '+salesArea);
        String GSTValidated = Label.grz_GSTValidated;
        String nonGSTValidated = Label.grz_nonGSTValidated;
        Id gstTemplate;
        String signerPhonenum,signeremail;
        if(Distributer!=null ){
            Account DistributerAccount = [Select id,GST_Validated__c,Non_GST_Customer__c,Email__c,Mobile__c from Account where id=:Distributer];
            system.debug('Account '+DistributerAccount);
            signerPhonenum=DistributerAccount.Mobile__c;
            signeremail=DistributerAccount.Email__c;
            gstTemplate= DistributerAccount.Non_GST_Customer__c ? Id.valueOf(nonGSTValidated) : Id.valueOf(GSTValidated);
            system.debug('gstTemplate '+gstTemplate);
        }
        
        try{
            system.debug('=====<>');
            //Map<String,echosign_dev1.AgreementTemplateVariable> agreementTemplateVariables = new Map<String,echosign_dev1.AgreementTemplateVariable>();
            //agreementTemplateVariables.put('ClientServicesAgreement',new echosign_dev1.AgreementTemplateVariable('ClientServicesAgreement','0682w00000M6VSlAAN'));
            //agreementTemplateVariables.put('myRecipientormyAttachment',new echosign_dev1.AgreementTemplateVariable('myRecipientormyAttachment','0682w00000M6VSvAAN'));
            //agreementTemplateVariables.put('ArystaLogo',new echosign_dev1.AgreementTemplateVariable('ArystaLogo','0682w00000M6VT5AAN'));
            
            Id agreementId;
            if(!Test.isRunningTest()){
                agreementId=echosign_dev1.AgreementTemplateService.load(gstTemplate,salesArea);
                
            }  else{
                agreementId=[select id,echosign_dev1__ErrorMessage__c,echosign_dev1__Status__c from echosign_dev1__SIGN_Agreement__c Limit 1].id;
                
            }
            if(agreementId!=null){
                LIST<echosign_dev1__SIGN_Recipients__c> listToUpdate= new LIST<echosign_dev1__SIGN_Recipients__c>();
                LIST<echosign_dev1__SIGN_Recipients__c> getupdateres=new LIST<echosign_dev1__SIGN_Recipients__c>();
                if(!Test.isRunningTest()){
                 getupdateres=[SELECT id,echosign_dev1__Phone_Verification_Country_Code__c,echosign_dev1__Phone_Verification_Phone_Number__c 
                                                                FROM echosign_dev1__SIGN_Recipients__c 
                                                                WHERE echosign_dev1__Agreement__c=:agreementId and echosign_dev1__Email_Address__c=:signeremail and echosign_dev1__Signer_Verification_Method__c='Phone'];
                                                                }
                                                                else{
                                                                getupdateres=[SELECT id,echosign_dev1__Phone_Verification_Country_Code__c,echosign_dev1__Phone_Verification_Phone_Number__c 
                                                                FROM echosign_dev1__SIGN_Recipients__c limit 1];
                                                                }
                System.debug('agreementId?>?'+getupdateres);
                if(!getupdateres.isEmpty()){
                    for(echosign_dev1__SIGN_Recipients__c record:getupdateres){
                        record.echosign_dev1__Phone_Verification_Country_Code__c='91';
                        record.echosign_dev1__Phone_Verification_Phone_Number__c=signerPhonenum;
                        listToUpdate.add(record);
                    } 
                    if(!listToUpdate.isEmpty()){
                        update listToUpdate;
                        System.debug('agreementId?>?'+listToUpdate);
                    }
                }
               
            }
            //echosign_dev1.EchoSignApiService.SendDocumentResult.sendDocument(agreementId);
            System.debug('agreementId?>?'+agreementId);
            return agreementId;
        } 
        catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
   
    @AuraEnabled
    public static String getTemplateDetails(Id aggrementId) {
        echosign_dev1__SIGN_Agreement__c SignedAgrement= [select id,echosign_dev1__ErrorMessage__c,echosign_dev1__Status__c from echosign_dev1__SIGN_Agreement__c where id =:aggrementId];
        
        String echoErrorMessage=SignedAgrement.echosign_dev1__ErrorMessage__c;
        //echosign_dev1.EchoSignApiService.AgreementViewUrl.getViewAgreementUrl(agreementId);//
        if(String.isEmpty(echoErrorMessage)){
            
            return '';
        }
        else{
            
            throw new AuraHandledException(echoErrorMessage);
        }
    }
}