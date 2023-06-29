@isTest
public class lo {
    @testSetup static void setup() {
          InterdictionProcessInstanceSetting__c custInstance =new InterdictionProcessInstanceSetting__c();
      custInstance.Sim__c=0;
     custInstance.Nao__c=0;
        custInstance.Name='test record';
     insert custInstance;
        Interdiction_Process__c ip=new Interdiction_Process__c();
        
        ip.IS_AN_INTERDICTION__c='Sim';
        ip.TERM_NUMBER__c='123';
        ip.DUE_DATE__c=system.today();
        ip.PRIORITY__c='URGENTE';
        ip.REASON__c='EMBALAGEM';
        ip.CNPJ_CPF__c='test';
        ip.INSCRI_O_ESTADUAL__c='test';
        ip.CITY__c='Panchkula';
        ip.STATE__c='Haryana';
        ip.RAZ_O_SOCIAL__c='test';
        ip.Contact__c='1223445666';
        ip.AGENT_EMAIL_Brazil__c='123@gmail.com';
        ip.EMAIL_LOGISTICS_OPERATOR_Brazil__c='testmail@gmail.com';
        //ip.Instance_Number__c='REC00001';
        insert ip;
        System.debug('ip'+ip.id);
        
        
    }
    @isTest
    static void testMethod1() {
        
        List<String> interList=new List<String>();
        InterdictionProcessInstanceSetting__c DataFromInterdictioncustom=[Select id,Sim__c, Nao__c from InterdictionProcessInstanceSetting__c ];
        Interdiction_Process__c ipro=[Select id,Instance_Number__c,IS_AN_INTERDICTION__c,TERM_NUMBER__c,DUE_DATE__c,PRIORITY__c,REASON__c,CNPJ_CPF__c,INSCRI_O_ESTADUAL__c,CITY__c,STATE__c,RAZ_O_SOCIAL__c,Contact__c,AGENT_EMAIL_Brazil__c,Status__c from Interdiction_Process__c limit 1];
        if(ipro!=null){
            ipro.Instance_Number__c='INT00001';
            ipro.EMAIL_LOGISTICS_OPERATOR_Brazil__c='testmail@gmail.com';
            
        }
        update ipro;
        interList.add(ipro.id);
        ContentVersion cv = new ContentVersion(
            Title = 'Some document',
            PathOnClient = 'some document.txt',
            VersionData = Blob.valueOf('Lorem ipsum dolor sit amet...'),
            InterRecordID__c=ipro.Id
        );
        insert cv;
        ContentDocumentLink contentlink=new ContentDocumentLink();
        contentlink.LinkedEntityId=ipro.Id;
        contentlink.contentdocumentid=[select contentdocumentid from contentversion where id =: cv.id].contentdocumentid;
        contentlink.ShareType = 'I';
        contentlink.Visibility = 'AllUsers'; 
        
        insert contentlink;
        if(contentlink!=null){
            List<ContentDocumentLink> cvList =[SELECT id, ShareType, Visibility, ContentDocument.Description,ContentDocument.Title,ContentDocument.LatestPublishedVersion.VersionData,ContentDocument.LatestPublishedVersion.FileType, ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE id=:contentlink.id];
        }
        
        Test.startTest();
        
        if(interList!=null){
            
            MailForInterdictionNo.sendEmailToOperatorswhenNo(interList);
             //MailForInterdictionNo.MethodForFileNameType(contentlink);
            //MailForInterdictionNo.InterdictionProcessUpdateAndInsert();
            //MailForInterdictionNo.InterdictionProcessMethodTOUpdateFields();
        }
        Test.stopTest();
        
    }
    @isTest
    static void testMethod2() {
        InterdictionProcessInstanceSetting__c DataFromInterdictioncustom=[Select id,Sim__c, Nao__c from InterdictionProcessInstanceSetting__c ];
        List<String> interList=new List<String>();
        
        Interdiction_Process__c ip=new Interdiction_Process__c();
        
        ip.IS_AN_INTERDICTION__c='Não';
        
        ip.PRIORITY__c='URGENTE';
        ip.REASON__c='EMBALAGEM';
        ip.CNPJ_CPF__c='test';
        ip.INSCRI_O_ESTADUAL__c='test';
        ip.CITY__c='Panchkula';
        ip.STATE__c='Haryana';
        ip.RAZ_O_SOCIAL__c='test';
        ip.Contact__c='1223445666';
        ip.Status__c='Book Collection';
        ip.EMAIL_LOGISTICS_OPERATOR_Brazil__c='testmail@gmail.com';
        insert ip;
        Interdiction_Process__c ipro=[Select id,Instance_Number__c,IS_AN_INTERDICTION__c,TERM_NUMBER__c,EMAIL_LOGISTICS_OPERATOR_Brazil__c,DUE_DATE__c,PRIORITY__c,REASON__c,CNPJ_CPF__c,INSCRI_O_ESTADUAL__c,CITY__c,STATE__c,RAZ_O_SOCIAL__c,Contact__c,AGENT_EMAIL_Brazil__c from Interdiction_Process__c where id=:ip.id ];
        
        if(ipro!=null){
            ipro.EMAIL_LOGISTICS_OPERATOR_Brazil__c='testmail@gmail.com';
            ipro.Instance_Number__c='REC00001';
        }
        update ipro;
        interList.add(ipro.id);
        ContentVersion cv = new ContentVersion(
            Title = 'Some document',
            PathOnClient = 'some document.txt',
            VersionData = Blob.valueOf('Lorem ipsum dolor sit amet...'),
            InterRecordID__c=ipro.Id
        );
        
        insert cv;
        
        ContentDocumentLink contentlink=new ContentDocumentLink();
        contentlink.LinkedEntityId=ipro.Id;
        contentlink.contentdocumentid=[select contentdocumentid from contentversion where id =: cv.id].contentdocumentid;
        contentlink.ShareType = 'I';
        contentlink.Visibility = 'AllUsers'; 
        
        
        insert contentlink;
        if(contentlink!=null){
            List<ContentDocumentLink> cvList =[SELECT id, ShareType, Visibility, ContentDocument.Description,ContentDocument.Title,ContentDocument.LatestPublishedVersion.VersionData,ContentDocument.LatestPublishedVersion.FileType, ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE id=:contentlink.id];
        }
        Test.startTest();
        
        if(interList!=null){
            
          MailForInterdictionNo.sendEmailToOperatorswhenNo(interList);
             //MailForInterdictionNo.MethodForFileNameType(contentlink);
            //MailForInterdictionNo.InterdictionProcessUpdateAndInsert();
            //MailForInterdictionNo.InterdictionProcessMethodTOUpdateFields();
            
        }
        Test.stopTest();
    }
    @isTest
    static void testMethod3() {
        InterdictionProcessInstanceSetting__c DataFromInterdictioncustom=[Select id,Sim__c, Nao__c from InterdictionProcessInstanceSetting__c ];
        User u=[Select id from User where isActive=true and profile.name='System Administrator' limit 1];
        List<String> interList=new List<String>();
        Interdiction_Process__c ipro=[Select id,Instance_Number__c,IS_AN_INTERDICTION__c,TERM_NUMBER__c,Status__c,DUE_DATE__c,PRIORITY__c,REASON__c,CNPJ_CPF__c,INSCRI_O_ESTADUAL__c,CITY__c,STATE__c,RAZ_O_SOCIAL__c,Contact__c,AGENT_EMAIL_Brazil__c from Interdiction_Process__c limit 1];
        System.debug('3 ipro'+ipro);
        if(ipro!=null){
            ipro.Status__c='Process Interdiction';
            ipro.Instance_Number__c='INT00001';
           // ipro.ENTRY_CLOSED__c=System.today()+1;
        }
        System.runAs(u){  
            update ipro;
        }
        
        interList.add(ipro.id);
        System.debug('interList 3'+ipro);
        System.debug('3 interList'+interList);
        ContentVersion cv = new ContentVersion(
            Title = 'Some document',
            PathOnClient = 'some document.txt',
            VersionData = Blob.valueOf('Lorem ipsum dolor sit amet...'),
            InterRecordID__c=ipro.Id
        );
        insert cv;
        System.debug('cv3 '+cv);
        ContentDocumentLink contentlink=new ContentDocumentLink();
        contentlink.LinkedEntityId=ipro.Id;
        contentlink.contentdocumentid=[select contentdocumentid from contentversion where id =: cv.id].contentdocumentid;
        contentlink.ShareType = 'I';
        contentlink.Visibility = 'AllUsers'; 
        
        insert contentlink;
        if(contentlink!=null){
            List<ContentDocumentLink> cvList =[SELECT id, ShareType, Visibility, ContentDocument.Description,ContentDocument.Title,ContentDocument.LatestPublishedVersion.VersionData,ContentDocument.LatestPublishedVersion.FileType, ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE id=:contentlink.id];
            System.debug('cvList'+cvList);
        }
        
        Test.startTest();
        
        if(interList!=null){
            MailForInterdictionNo.sendEmailToOperatorswhenNo(interList);
             //MailForInterdictionNo.MethodForFileNameType(contentlink);
            //MailForInterdictionNo.InterdictionProcessUpdateAndInsert();
            //MailForInterdictionNo.InterdictionProcessMethodTOUpdateFields();
        }
        Test.stopTest();
        
    }
    @isTest
    static void testMethod4() {
        InterdictionProcessInstanceSetting__c DataFromInterdictioncustom=[Select id,Sim__c, Nao__c from InterdictionProcessInstanceSetting__c ];
        User u=[Select id from User where isActive=true and profile.name='System Administrator' limit 1];
        List<String> interList=new List<String>();
        
        Interdiction_Process__c ipro=[Select id,Instance_Number__c,IS_AN_INTERDICTION__c,Status__c,TERM_NUMBER__c,DUE_DATE__c,PRIORITY__c,REASON__c,CNPJ_CPF__c,INSCRI_O_ESTADUAL__c,CITY__c,STATE__c,RAZ_O_SOCIAL__c,Contact__c,AGENT_EMAIL_Brazil__c from Interdiction_Process__c limit 1];
        
        if(ipro!=null){
            
            ipro.Status__c='Waiting for Collection';
            ipro.Instance_Number__c='INT00001';
            
        }
        
        System.runAs(u){  
            update ipro;
        }
        if(ipro!=null){
            interList.add(ipro.id);
        }
        System.debug('interList 4'+interList);
        ContentVersion cv = new ContentVersion(
            Title = 'Some document4',
            PathOnClient = 'some document.txt',
            VersionData = Blob.valueOf('Lorem ipsum dolor sit amet...'),
            InterRecordID__c=ipro.Id
        );
        insert cv;
        ContentDocumentLink contentlink=new ContentDocumentLink();
        contentlink.LinkedEntityId=ipro.Id;
        contentlink.contentdocumentid=[select contentdocumentid from contentversion where id =: cv.id].contentdocumentid;
        contentlink.ShareType = 'I';
        contentlink.Visibility = 'AllUsers'; 
        
        insert contentlink;
        if(contentlink!=null){
            List<ContentDocumentLink> cvList =[SELECT id, ShareType, Visibility, ContentDocument.Description,ContentDocument.Title,ContentDocument.LatestPublishedVersion.VersionData,ContentDocument.LatestPublishedVersion.FileType, ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE id=:contentlink.id];
            
        }
        Test.startTest();
        if(interList!=null){
            
             MailForInterdictionNo.sendEmailToOperatorswhenNo(interList);
             //MailForInterdictionNo.MethodForFileNameType(contentlink);
            //MailForInterdictionNo.InterdictionProcessUpdateAndInsert();
           // MailForInterdictionNo.InterdictionProcessMethodTOUpdateFields();
        }
        Test.stopTest();
    }
    @isTest
    static void testMethod5() { 
        InterdictionProcessInstanceSetting__c DataFromInterdictioncustom=[Select id,Sim__c, Nao__c from InterdictionProcessInstanceSetting__c ];
        List<String> interList=new List<String>();   
        Interdiction_Process__c ip=new Interdiction_Process__c();    
        ip.IS_AN_INTERDICTION__c='Não';
        
        ip.PRIORITY__c='URGENTE';
        ip.REASON__c='EMBALAGEM';
        ip.CNPJ_CPF__c='test';
        ip.INSCRI_O_ESTADUAL__c='test';
        ip.CITY__c='Panchkula';
        ip.STATE__c='Haryana';
        ip.RAZ_O_SOCIAL__c='test';
        ip.Contact__c='1223445666';
        ip.Status__c='Book Collection';
        ip.EMAIL_LOGISTICS_OPERATOR_Brazil__c='testmail@gmail.com';
        insert ip;
        Interdiction_Process__c ipro=[Select id,Instance_Number__c,IS_AN_INTERDICTION__c,TERM_NUMBER__c,EMAIL_LOGISTICS_OPERATOR_Brazil__c,DUE_DATE__c,PRIORITY__c,REASON__c,CNPJ_CPF__c,INSCRI_O_ESTADUAL__c,CITY__c,STATE__c,RAZ_O_SOCIAL__c,Contact__c,AGENT_EMAIL_Brazil__c from Interdiction_Process__c where id=:ip.id ];
        
        if(ipro!=null){
            ipro.EMAIL_LOGISTICS_OPERATOR_Brazil__c='testmail@gmail.com';
            ipro.Instance_Number__c='REC00001';
        }
        update ipro;
        interList.add(ipro.id);
        ContentVersion cv = new ContentVersion(
            Title = 'Some document',
            PathOnClient = 'someocument.xlsx',
            VersionData = Blob.valueOf('Lorem ipsum dolor sit amet...'),
            InterRecordID__c=ipro.Id
        );
        
        insert cv;
        
        ContentDocumentLink contentlink=new ContentDocumentLink();
        contentlink.LinkedEntityId=ipro.Id;
        contentlink.contentdocumentid=[select contentdocumentid from contentversion where id =: cv.id].contentdocumentid;
        contentlink.ShareType = 'I';
        contentlink.Visibility = 'AllUsers'; 
        
        
        insert contentlink;
        if(contentlink!=null){
            List<ContentDocumentLink> cvList =[SELECT id, ShareType, Visibility, ContentDocument.Description,ContentDocument.Title,ContentDocument.LatestPublishedVersion.VersionData,ContentDocument.LatestPublishedVersion.FileType, ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE id=:contentlink.id];
        }
        Test.startTest();
        if(interList!=null){
            MailForInterdictionNo.sendEmailToOperatorswhenNo(interList);
             //MailForInterdictionNo.MethodForFileNameType(contentlink);
  //          MailForInterdictionNo.InterdictionProcessUpdateAndInsert();
//            MailForInterdictionNo.InterdictionProcessMethodTOUpdateFields();
        }
        Test.stopTest();
    }
    @isTest
    static void testMethod6() { 
        InterdictionProcessInstanceSetting__c DataFromInterdictioncustom=[Select id,Sim__c, Nao__c from InterdictionProcessInstanceSetting__c ];
        List<String> interList=new List<String>();   
        Interdiction_Process__c ip=new Interdiction_Process__c();    
        ip.IS_AN_INTERDICTION__c='Não';
        
        ip.PRIORITY__c='URGENTE';
        ip.REASON__c='EMBALAGEM';
        ip.CNPJ_CPF__c='test';
        ip.INSCRI_O_ESTADUAL__c='test';
        ip.CITY__c='Panchkula';
        ip.STATE__c='Haryana';
        ip.RAZ_O_SOCIAL__c='test';
        ip.Contact__c='1223445666';
        ip.Status__c='Book Collection';
        ip.EMAIL_LOGISTICS_OPERATOR_Brazil__c='testmail@gmail.com';
        insert ip;
        Interdiction_Process__c ipro=[Select id,Instance_Number__c,IS_AN_INTERDICTION__c,TERM_NUMBER__c,EMAIL_LOGISTICS_OPERATOR_Brazil__c,DUE_DATE__c,PRIORITY__c,REASON__c,CNPJ_CPF__c,INSCRI_O_ESTADUAL__c,CITY__c,STATE__c,RAZ_O_SOCIAL__c,Contact__c,AGENT_EMAIL_Brazil__c from Interdiction_Process__c where id=:ip.id ];
        
        if(ipro!=null){
            ipro.EMAIL_LOGISTICS_OPERATOR_Brazil__c='testmail@gmail.com';
            ipro.Instance_Number__c='REC00001';
        }
        update ipro;
        interList.add(ipro.id);
        ContentVersion cv = new ContentVersion(
            Title = 'Some document',
            PathOnClient = 'someocument.pptx',
            VersionData = Blob.valueOf('Lorem ipsum dolor sit amet...'),
            InterRecordID__c=ipro.Id
        );
        
        insert cv;
        
        ContentDocumentLink contentlink=new ContentDocumentLink();
        contentlink.LinkedEntityId=ipro.Id;
        contentlink.contentdocumentid=[select contentdocumentid from contentversion where id =: cv.id].contentdocumentid;
        contentlink.ShareType = 'I';
        contentlink.Visibility = 'AllUsers'; 
        
        insert contentlink;
        if(contentlink!=null){
            List<ContentDocumentLink> cvList =[SELECT id, ShareType, Visibility, ContentDocument.Description,ContentDocument.Title,ContentDocument.LatestPublishedVersion.VersionData,ContentDocument.LatestPublishedVersion.FileType, ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE id=:contentlink.id];
        }
        Test.startTest();
        if(interList!=null){
            
             MailForInterdictionNo.sendEmailToOperatorswhenNo(interList);
            // MailForInterdictionNo.MethodForFileNameType(contentlink);
            //MailForInterdictionNo.InterdictionProcessUpdateAndInsert();
            //MailForInterdictionNo.InterdictionProcessMethodTOUpdateFields();
        }
        Test.stopTest();
    }
    @isTest
    static void testMethod7() { 
        InterdictionProcessInstanceSetting__c DataFromInterdictioncustom=[Select id,Sim__c, Nao__c from InterdictionProcessInstanceSetting__c ];
        List<String> interList=new List<String>();   
        Interdiction_Process__c ip=new Interdiction_Process__c();    
        ip.IS_AN_INTERDICTION__c='Não';
        
        ip.PRIORITY__c='URGENTE';
        ip.REASON__c='EMBALAGEM';
        ip.CNPJ_CPF__c='test';
        ip.INSCRI_O_ESTADUAL__c='test';
        ip.CITY__c='Panchkula';
        ip.STATE__c='Haryana';
        ip.RAZ_O_SOCIAL__c='test';
        ip.Contact__c='1223445666';
        ip.Status__c='Book Collection';
        ip.EMAIL_LOGISTICS_OPERATOR_Brazil__c='testmail@gmail.com';
        insert ip;
        Interdiction_Process__c ipro=[Select id,Instance_Number__c,IS_AN_INTERDICTION__c,TERM_NUMBER__c,EMAIL_LOGISTICS_OPERATOR_Brazil__c,DUE_DATE__c,PRIORITY__c,REASON__c,CNPJ_CPF__c,INSCRI_O_ESTADUAL__c,CITY__c,STATE__c,RAZ_O_SOCIAL__c,Contact__c,AGENT_EMAIL_Brazil__c from Interdiction_Process__c where id=:ip.id ];
        
        if(ipro!=null){
            ipro.EMAIL_LOGISTICS_OPERATOR_Brazil__c='testmail@gmail.com';
            ipro.Instance_Number__c='REC00001';
        }
        update ipro;
        interList.add(ipro.id);
        ContentVersion cv = new ContentVersion(
            Title = 'Some document',
            PathOnClient = 'someocument.docx',
            VersionData = Blob.valueOf('Lorem ipsum dolor sit amet...'),
            InterRecordID__c=ipro.Id
        );
        
        insert cv;
        
        ContentDocumentLink contentlink=new ContentDocumentLink();
        contentlink.LinkedEntityId=ipro.Id;
        contentlink.contentdocumentid=[select contentdocumentid from contentversion where id =: cv.id].contentdocumentid;
        contentlink.ShareType = 'I';
        contentlink.Visibility = 'AllUsers'; 
        
        
        insert contentlink;
        if(contentlink!=null){
            List<ContentDocumentLink> cvList =[SELECT id, ShareType, Visibility, ContentDocument.Description,ContentDocument.Title,ContentDocument.LatestPublishedVersion.VersionData,ContentDocument.LatestPublishedVersion.FileType, ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE id=:contentlink.id];
        }
        Test.startTest();
        if(interList!=null){
            
            MailForInterdictionNo.sendEmailToOperatorswhenNo(interList);
           //  MailForInterdictionNo.MethodForFileNameType(contentlink);
           // MailForInterdictionNo.InterdictionProcessUpdateAndInsert();
            //MailForInterdictionNo.InterdictionProcessMethodTOUpdateFields();            
        }
        Test.stopTest();
    }  
    @isTest
    static void testMethod8() { 
        InterdictionProcessInstanceSetting__c DataFromInterdictioncustom=[Select id,Sim__c, Nao__c from InterdictionProcessInstanceSetting__c ];
        List<String> interList=new List<String>();   
        Interdiction_Process__c ip=new Interdiction_Process__c();    
        ip.IS_AN_INTERDICTION__c='Não';
        
        ip.PRIORITY__c='URGENTE';
        ip.REASON__c='EMBALAGEM';
        ip.CNPJ_CPF__c='test';
        ip.INSCRI_O_ESTADUAL__c='test';
        ip.CITY__c='Panchkula';
        ip.STATE__c='Haryana';
        ip.RAZ_O_SOCIAL__c='test';
        ip.Contact__c='1223445666';
        ip.Status__c='Book Collection';
        ip.EMAIL_LOGISTICS_OPERATOR_Brazil__c='testmail@gmail.com';
        insert ip;
        Interdiction_Process__c ipro=[Select id,Instance_Number__c,IS_AN_INTERDICTION__c,TERM_NUMBER__c,EMAIL_LOGISTICS_OPERATOR_Brazil__c,DUE_DATE__c,PRIORITY__c,REASON__c,CNPJ_CPF__c,INSCRI_O_ESTADUAL__c,CITY__c,STATE__c,RAZ_O_SOCIAL__c,Contact__c,AGENT_EMAIL_Brazil__c from Interdiction_Process__c where id=:ip.id ];
        
        if(ipro!=null){
            ipro.EMAIL_LOGISTICS_OPERATOR_Brazil__c='testmail@gmail.com';
            ipro.Instance_Number__c='REC00001';
        }
        update ipro;
        interList.add(ipro.id);
        ContentVersion cv = new ContentVersion(
            Title = 'Some document',
            PathOnClient = 'someocument.ts',
            VersionData = Blob.valueOf('Lorem ipsum dolor sit amet...'),
            InterRecordID__c=ipro.Id
        );
        
        insert cv;
        
        ContentDocumentLink contentlink=new ContentDocumentLink();
        contentlink.LinkedEntityId=ipro.Id;
        contentlink.contentdocumentid=[select contentdocumentid from contentversion where id =: cv.id].contentdocumentid;
        contentlink.ShareType = 'I';
        contentlink.Visibility = 'AllUsers'; 
        
        insert contentlink;
        if(contentlink!=null){
            List<ContentDocumentLink> cvList =[SELECT id, ShareType, Visibility, ContentDocument.Description,ContentDocument.Title,ContentDocument.LatestPublishedVersion.VersionData,ContentDocument.LatestPublishedVersion.FileType, ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE id=:contentlink.id];
        }
        Test.startTest();
        if(interList!=null){
            
            MailForInterdictionNo.sendEmailToOperatorswhenNo(interList);
            // MailForInterdictionNo.MethodForFileNameType(contentlink);
            //MailForInterdictionNo.InterdictionProcessUpdateAndInsert();
            //MailForInterdictionNo.InterdictionProcessMethodTOUpdateFields();
        }
        Test.stopTest();
    }  
    @isTest
    static void testMethod9() {
        InterdictionProcessInstanceSetting__c DataFromInterdictioncustom=[Select id,Sim__c, Nao__c from InterdictionProcessInstanceSetting__c ];
        List<String> interList=new List<String>();
        
        Interdiction_Process__c ipro=[Select id,Instance_Number__c,IS_AN_INTERDICTION__c,TERM_NUMBER__c,DUE_DATE__c,PRIORITY__c,REASON__c,CNPJ_CPF__c,INSCRI_O_ESTADUAL__c,CITY__c,STATE__c,RAZ_O_SOCIAL__c,Contact__c,AGENT_EMAIL_Brazil__c,Status__c from Interdiction_Process__c limit 1];
        System.debug('ipro'+ipro.Instance_Number__c);    
        if(ipro!=null){
            ipro.Instance_Number__c='INT00001';
            ipro.EMAIL_LOGISTICS_OPERATOR_Brazil__c='testmail@gmail.com';
            
        }
        update ipro;
        System.debug('ipro 11'+ipro);
        interList.add(ipro.id);
        System.debug('interList'+interList);
        
        ContentVersion cv = new ContentVersion(
            Title = 'Some document',
            PathOnClient = 'some document.ts',
            VersionData = Blob.valueOf('Lorem ipsum dolor sit amet...'),
            InterRecordID__c=ipro.Id
        );
        insert cv;
        ContentDocumentLink contentlink=new ContentDocumentLink();
        contentlink.LinkedEntityId=ipro.Id;
        contentlink.contentdocumentid=[select contentdocumentid from contentversion where id =: cv.id].contentdocumentid;
        contentlink.ShareType = 'I';
        contentlink.Visibility = 'AllUsers'; 
        
        
        insert contentlink;
        if(contentlink!=null){
            List<ContentDocumentLink> cvList =[SELECT id, ShareType, Visibility, ContentDocument.Description,ContentDocument.Title,ContentDocument.LatestPublishedVersion.VersionData,ContentDocument.LatestPublishedVersion.FileType, ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE id=:contentlink.id];
        }
        
        Test.startTest();
        if(interList!=null){
            
             MailForInterdictionNo.sendEmailToOperatorswhenNo(interList);
             //MailForInterdictionNo.MethodForFileNameType(contentlink);
            //MailForInterdictionNo.InterdictionProcessUpdateAndInsert();
            //MailForInterdictionNo.InterdictionProcessMethodTOUpdateFields();
            
        }
        Test.stopTest();
        
    }
    @isTest
    static void testMethod10() {
        InterdictionProcessInstanceSetting__c DataFromInterdictioncustom=[Select id,Sim__c, Nao__c from InterdictionProcessInstanceSetting__c ];
        List<String> interList=new List<String>();
        
        Interdiction_Process__c ipro=[Select id,Instance_Number__c,IS_AN_INTERDICTION__c,TERM_NUMBER__c,DUE_DATE__c,PRIORITY__c,REASON__c,CNPJ_CPF__c,INSCRI_O_ESTADUAL__c,CITY__c,STATE__c,RAZ_O_SOCIAL__c,Contact__c,AGENT_EMAIL_Brazil__c,Status__c from Interdiction_Process__c limit 1];
        System.debug('ipro'+ipro.Instance_Number__c);    
        if(ipro!=null){
            ipro.Instance_Number__c='INT00001';
            ipro.EMAIL_LOGISTICS_OPERATOR_Brazil__c='testmail@gmail.com';
            
        }
        update ipro;
        System.debug('ipro 11'+ipro);
        interList.add(ipro.id);
        System.debug('interList'+interList);
        
        ContentVersion cv = new ContentVersion(
            Title = 'Some document',
            PathOnClient = 'some document.xlsx',
            VersionData = Blob.valueOf('Lorem ipsum dolor sit amet...'),
            InterRecordID__c=ipro.Id
        );
        insert cv;
        ContentDocumentLink contentlink=new ContentDocumentLink();
        contentlink.LinkedEntityId=ipro.Id;
        contentlink.contentdocumentid=[select contentdocumentid from contentversion where id =: cv.id].contentdocumentid;
        contentlink.ShareType = 'I';
        contentlink.Visibility = 'AllUsers'; 
        
        
        insert contentlink;
        if(contentlink!=null){
            List<ContentDocumentLink> cvList =[SELECT id, ShareType, Visibility, ContentDocument.Description,ContentDocument.Title,ContentDocument.LatestPublishedVersion.VersionData,ContentDocument.LatestPublishedVersion.FileType, ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE id=:contentlink.id];
        }
        
        Test.startTest();
        if(interList!=null){
            
            MailForInterdictionNo.sendEmailToOperatorswhenNo(interList);
             //MailForInterdictionNo.MethodForFileNameType(contentlink);
            //MailForInterdictionNo.InterdictionProcessUpdateAndInsert();
            //MailForInterdictionNo.InterdictionProcessMethodTOUpdateFields();
            
        }
        Test.stopTest();
        
    }
    @isTest
    static void testMethod11() {
        InterdictionProcessInstanceSetting__c DataFromInterdictioncustom=[Select id,Sim__c, Nao__c from InterdictionProcessInstanceSetting__c ];
        List<String> interList=new List<String>();
        
        Interdiction_Process__c ipro=[Select id,Instance_Number__c,IS_AN_INTERDICTION__c,TERM_NUMBER__c,DUE_DATE__c,PRIORITY__c,REASON__c,CNPJ_CPF__c,INSCRI_O_ESTADUAL__c,CITY__c,STATE__c,RAZ_O_SOCIAL__c,Contact__c,AGENT_EMAIL_Brazil__c,Status__c from Interdiction_Process__c limit 1];
        System.debug('ipro'+ipro.Instance_Number__c);    
        if(ipro!=null){
            ipro.Instance_Number__c='INT00001';
            ipro.EMAIL_LOGISTICS_OPERATOR_Brazil__c='testmail@gmail.com';
            
        }
        update ipro;
        System.debug('ipro 11'+ipro);
        interList.add(ipro.id);
        System.debug('interList'+interList);
        
        ContentVersion cv = new ContentVersion(
            Title = 'Some document',
            PathOnClient = 'some document.docx',
            VersionData = Blob.valueOf('Lorem ipsum dolor sit amet...'),
            InterRecordID__c=ipro.Id
        );
        insert cv;
        ContentDocumentLink contentlink=new ContentDocumentLink();
        contentlink.LinkedEntityId=ipro.Id;
        contentlink.contentdocumentid=[select contentdocumentid from contentversion where id =: cv.id].contentdocumentid;
        contentlink.ShareType = 'I';
        contentlink.Visibility = 'AllUsers'; 
        
        
        insert contentlink;
        if(contentlink!=null){
            List<ContentDocumentLink> cvList =[SELECT id, ShareType, Visibility, ContentDocument.Description,ContentDocument.Title,ContentDocument.LatestPublishedVersion.VersionData,ContentDocument.LatestPublishedVersion.FileType, ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE id=:contentlink.id];
        }
        
        Test.startTest();
        if(interList!=null){
            
            MailForInterdictionNo.sendEmailToOperatorswhenNo(interList);
             //MailForInterdictionNo.MethodForFileNameType(contentlink);
            //MailForInterdictionNo.InterdictionProcessUpdateAndInsert();
            //MailForInterdictionNo.InterdictionProcessMethodTOUpdateFields();
            
        }
        Test.stopTest();
        
    }
    @isTest
    static void testMethod12() {
        InterdictionProcessInstanceSetting__c DataFromInterdictioncustom=[Select id,Sim__c, Nao__c from InterdictionProcessInstanceSetting__c ];
        List<String> interList=new List<String>();
        
        Interdiction_Process__c ipro=[Select id,Instance_Number__c,IS_AN_INTERDICTION__c,TERM_NUMBER__c,DUE_DATE__c,PRIORITY__c,REASON__c,CNPJ_CPF__c,INSCRI_O_ESTADUAL__c,CITY__c,STATE__c,RAZ_O_SOCIAL__c,Contact__c,AGENT_EMAIL_Brazil__c,Status__c from Interdiction_Process__c limit 1];
        System.debug('ipro'+ipro.Instance_Number__c);    
        if(ipro!=null){
            ipro.Instance_Number__c='INT00001';
            ipro.EMAIL_LOGISTICS_OPERATOR_Brazil__c='testmail@gmail.com';
            
        }
        update ipro;
        System.debug('ipro 11'+ipro);
        interList.add(ipro.id);
        System.debug('interList'+interList);
        
        ContentVersion cv = new ContentVersion(
            Title = 'Some document',
            PathOnClient = 'some document.pptx',
            VersionData = Blob.valueOf('Lorem ipsum dolor sit amet...'),
            InterRecordID__c=ipro.Id
        );
        insert cv;
        ContentDocumentLink contentlink=new ContentDocumentLink();
        contentlink.LinkedEntityId=ipro.Id;
        contentlink.contentdocumentid=[select contentdocumentid from contentversion where id =: cv.id].contentdocumentid;
        contentlink.ShareType = 'I';
        contentlink.Visibility = 'AllUsers'; 
        
        
        insert contentlink;
        if(contentlink!=null){
            List<ContentDocumentLink> cvList =[SELECT id, ShareType, Visibility, ContentDocument.Description,ContentDocument.Title,ContentDocument.LatestPublishedVersion.VersionData,ContentDocument.LatestPublishedVersion.FileType, ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE id=:contentlink.id];
        }
        
        Test.startTest();
        if(interList!=null){
            
            
         MailForInterdictionNo.sendEmailToOperatorswhenNo(interList);
             //MailForInterdictionNo.MethodForFileNameType(contentlink);
            //MailForInterdictionNo.InterdictionProcessUpdateAndInsert();
            //MailForInterdictionNo.InterdictionProcessMethodTOUpdateFields();
            
        }
        Test.stopTest();
        
    }
    @isTest
    static void testMethod13() {
InterdictionProcessInstanceSetting__c DataFromInterdictioncustom=[Select id,Sim__c, Nao__c from InterdictionProcessInstanceSetting__c ];        
        List<String> interList=new List<String>();
        
        Interdiction_Process__c ip=new Interdiction_Process__c();
        
        ip.IS_AN_INTERDICTION__c='Não';
        
        ip.PRIORITY__c='URGENTE';
        ip.REASON__c='EMBALAGEM';
        ip.CNPJ_CPF__c='test';
        ip.INSCRI_O_ESTADUAL__c='test';
        ip.CITY__c='Panchkula';
        ip.STATE__c='Haryana';
        ip.RAZ_O_SOCIAL__c='test';
        ip.Contact__c='1223445666';
        ip.Status__c='Book Collection';
        ip.EMAIL_LOGISTICS_OPERATOR_Brazil__c='testmail@gmail.com';
        insert ip;
        Interdiction_Process__c ipro=[Select id,Instance_Number__c,IS_AN_INTERDICTION__c,TERM_NUMBER__c,EMAIL_LOGISTICS_OPERATOR_Brazil__c,DUE_DATE__c,PRIORITY__c,REASON__c,CNPJ_CPF__c,INSCRI_O_ESTADUAL__c,CITY__c,STATE__c,RAZ_O_SOCIAL__c,Contact__c,AGENT_EMAIL_Brazil__c from Interdiction_Process__c where id=:ip.id ];
        System.debug('ipro @@@'+ipro);
        if(ipro!=null){
            ipro.EMAIL_LOGISTICS_OPERATOR_Brazil__c='testmail@gmail.com';
            ipro.Instance_Number__c='REC00001';
        }
        update ipro;
        interList.add(ipro.id);
        ContentVersion cv = new ContentVersion(
            Title = 'Some document',
            PathOnClient = 'some document.ts',
            VersionData = Blob.valueOf('Lorem ipsum dolor sit amet...'),
            InterRecordID__c=ipro.Id
        );
        
        insert cv;
        
        ContentDocumentLink contentlink=new ContentDocumentLink();
        contentlink.LinkedEntityId=ipro.Id;
        contentlink.contentdocumentid=[select contentdocumentid from contentversion where id =: cv.id].contentdocumentid;
        contentlink.ShareType = 'I';
        contentlink.Visibility = 'AllUsers'; 
        
        
        insert contentlink;
        if(contentlink!=null){
            List<ContentDocumentLink> cvList =[SELECT id, ShareType, Visibility, ContentDocument.Description,ContentDocument.Title,ContentDocument.LatestPublishedVersion.VersionData,ContentDocument.LatestPublishedVersion.FileType, ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE id=:contentlink.id];
        }
        Test.startTest();
        if(interList!=null){
            
            MailForInterdictionNo.sendEmailToOperatorswhenNo(interList);
             //MailForInterdictionNo.MethodForFileNameType(contentlink);
            //MailForInterdictionNo.InterdictionProcessUpdateAndInsert();
            //MailForInterdictionNo.InterdictionProcessMethodTOUpdateFields();
            
        }
        Test.stopTest();
    }
    @isTest
    static void testMethod14() {
        InterdictionProcessInstanceSetting__c DataFromInterdictioncustom=[Select id,Sim__c, Nao__c from InterdictionProcessInstanceSetting__c ];
        User u=[Select id from User where isActive=true and profile.name='System Administrator' limit 1];
        List<String> interList=new List<String>();
        
        
        
        Interdiction_Process__c ipro=[Select id,Instance_Number__c,IS_AN_INTERDICTION__c,Status__c,TERM_NUMBER__c,DUE_DATE__c,PRIORITY__c,REASON__c,CNPJ_CPF__c,INSCRI_O_ESTADUAL__c,CITY__c,STATE__c,RAZ_O_SOCIAL__c,Contact__c,AGENT_EMAIL_Brazil__c from Interdiction_Process__c limit 1];
        
        if(ipro!=null){
            
            ipro.Status__c='Waiting for Collection';
            ipro.Instance_Number__c='INT00001';
            
        }
        System.debug('4 ipro'+ipro);
        
        System.runAs(u){  
            update ipro;
        }
        if(ipro!=null){
            interList.add(ipro.id);
        }
        System.debug('interList 4'+interList);
        ContentVersion cv = new ContentVersion(
            Title = 'Some document4',
            PathOnClient = 'some document.ts',
            VersionData = Blob.valueOf('Lorem ipsum dolor sit amet...'),
            InterRecordID__c=ipro.Id
        );
        insert cv;
        ContentDocumentLink contentlink=new ContentDocumentLink();
        contentlink.LinkedEntityId=ipro.Id;
        contentlink.contentdocumentid=[select contentdocumentid from contentversion where id =: cv.id].contentdocumentid;
        contentlink.ShareType = 'I';
        contentlink.Visibility = 'AllUsers'; 
        
        
        insert contentlink;
        if(contentlink!=null){
            List<ContentDocumentLink> cvList =[SELECT id, ShareType, Visibility, ContentDocument.Description,ContentDocument.Title,ContentDocument.LatestPublishedVersion.VersionData,ContentDocument.LatestPublishedVersion.FileType, ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE id=:contentlink.id];
            
        }
        Test.startTest();
        if(interList!=null){
            
            MailForInterdictionNo.sendEmailToOperatorswhenNo(interList);
            // MailForInterdictionNo.MethodForFileNameType(contentlink);
            //MailForInterdictionNo.InterdictionProcessUpdateAndInsert();
            //MailForInterdictionNo.InterdictionProcessMethodTOUpdateFields();
        }
        Test.stopTest();
    }
    @isTest
    static void testMethod15() {
        InterdictionProcessInstanceSetting__c DataFromInterdictioncustom=[Select id,Sim__c, Nao__c from InterdictionProcessInstanceSetting__c ];
        User u=[Select id from User where isActive=true and profile.name='System Administrator' limit 1];
        List<String> interList=new List<String>();
        
        
        
        Interdiction_Process__c ipro=[Select id,Instance_Number__c,IS_AN_INTERDICTION__c,Status__c,TERM_NUMBER__c,DUE_DATE__c,PRIORITY__c,REASON__c,CNPJ_CPF__c,INSCRI_O_ESTADUAL__c,CITY__c,STATE__c,RAZ_O_SOCIAL__c,Contact__c,AGENT_EMAIL_Brazil__c from Interdiction_Process__c limit 1];
        
        if(ipro!=null){
            
            ipro.Status__c='Waiting for Collection';
            ipro.Instance_Number__c='INT00001';
            
        }
        System.debug('4 ipro'+ipro);
        
        System.runAs(u){  
            update ipro;
        }
        if(ipro!=null){
            interList.add(ipro.id);
        }
        System.debug('interList 4'+interList);
        ContentVersion cv = new ContentVersion(
            Title = 'Some document4',
            PathOnClient = 'some document.xlsx',
            VersionData = Blob.valueOf('Lorem ipsum dolor sit amet...'),
            InterRecordID__c=ipro.Id
        );
        insert cv;
        ContentDocumentLink contentlink=new ContentDocumentLink();
        contentlink.LinkedEntityId=ipro.Id;
        contentlink.contentdocumentid=[select contentdocumentid from contentversion where id =: cv.id].contentdocumentid;
        contentlink.ShareType = 'I';
        contentlink.Visibility = 'AllUsers'; 
        
        
        insert contentlink;
        if(contentlink!=null){
            List<ContentDocumentLink> cvList =[SELECT id, ShareType, Visibility, ContentDocument.Description,ContentDocument.Title,ContentDocument.LatestPublishedVersion.VersionData,ContentDocument.LatestPublishedVersion.FileType, ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE id=:contentlink.id];
            
        }
        Test.startTest();
        
        if(interList!=null){
            
            MailForInterdictionNo.sendEmailToOperatorswhenNo(interList);
           //  MailForInterdictionNo.MethodForFileNameType(contentlink);
            //MailForInterdictionNo.InterdictionProcessUpdateAndInsert();
            //MailForInterdictionNo.InterdictionProcessMethodTOUpdateFields();
        }
        Test.stopTest();
    }
    @isTest
    static void testMethod16() {
        InterdictionProcessInstanceSetting__c DataFromInterdictioncustom=[Select id,Sim__c, Nao__c from InterdictionProcessInstanceSetting__c ];
        User u=[Select id from User where isActive=true and profile.name='System Administrator' limit 1];
        List<String> interList=new List<String>();
        
        
        
        Interdiction_Process__c ipro=[Select id,Instance_Number__c,IS_AN_INTERDICTION__c,Status__c,TERM_NUMBER__c,DUE_DATE__c,PRIORITY__c,REASON__c,CNPJ_CPF__c,INSCRI_O_ESTADUAL__c,CITY__c,STATE__c,RAZ_O_SOCIAL__c,Contact__c,AGENT_EMAIL_Brazil__c from Interdiction_Process__c limit 1];
        
        if(ipro!=null){
            
            ipro.Status__c='Waiting for Collection';
            ipro.Instance_Number__c='INT00001';
            
        }
        System.debug('4 ipro'+ipro);
        
        System.runAs(u){  
            update ipro;
        }
        if(ipro!=null){
            interList.add(ipro.id);
        }
        System.debug('interList 4'+interList);
        ContentVersion cv = new ContentVersion(
            Title = 'Some document4',
            PathOnClient = 'some document.pptx',
            VersionData = Blob.valueOf('Lorem ipsum dolor sit amet...'),
            InterRecordID__c=ipro.Id
        );
        insert cv;
        ContentDocumentLink contentlink=new ContentDocumentLink();
        contentlink.LinkedEntityId=ipro.Id;
        contentlink.contentdocumentid=[select contentdocumentid from contentversion where id =: cv.id].contentdocumentid;
        contentlink.ShareType = 'I';
        contentlink.Visibility = 'AllUsers'; 
        
        
        insert contentlink;
        if(contentlink!=null){
            List<ContentDocumentLink> cvList =[SELECT id, ShareType, Visibility, ContentDocument.Description,ContentDocument.Title,ContentDocument.LatestPublishedVersion.VersionData,ContentDocument.LatestPublishedVersion.FileType, ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE id=:contentlink.id];
            
        }
        Test.startTest();
        
        
        
        if(interList!=null){
            
            MailForInterdictionNo.sendEmailToOperatorswhenNo(interList);
            // MailForInterdictionNo.MethodForFileNameType(contentlink);
            //MailForInterdictionNo.InterdictionProcessUpdateAndInsert();
            //MailForInterdictionNo.InterdictionProcessMethodTOUpdateFields();
            
        }
        Test.stopTest();
    }
    @isTest
    static void testMethod17() {
        InterdictionProcessInstanceSetting__c DataFromInterdictioncustom=[Select id,Sim__c, Nao__c from InterdictionProcessInstanceSetting__c ];
        system.debug('console testmethod 3');
        User u=[Select id from User where isActive=true and profile.name='System Administrator' limit 1];
        List<String> interList=new List<String>();
        
        
        Interdiction_Process__c ipro=[Select id,Instance_Number__c,IS_AN_INTERDICTION__c,TERM_NUMBER__c,Status__c,DUE_DATE__c,PRIORITY__c,REASON__c,CNPJ_CPF__c,INSCRI_O_ESTADUAL__c,CITY__c,STATE__c,RAZ_O_SOCIAL__c,Contact__c,AGENT_EMAIL_Brazil__c from Interdiction_Process__c limit 1];
        System.debug('3 ipro'+ipro);
        if(ipro!=null){
            ipro.Status__c='Process Interdiction';
            ipro.Instance_Number__c='INT00001';
            ipro.ENTRY_CLOSED__c=System.today()+1;
        }
        System.runAs(u){  
            update ipro;
        }
        
        interList.add(ipro.id);
        System.debug('interList 3'+ipro);
        System.debug('3 interList'+interList);
        ContentVersion cv = new ContentVersion(
            Title = 'Some document',
            PathOnClient = 'some document.ts',
            VersionData = Blob.valueOf('Lorem ipsum dolor sit amet...'),
            InterRecordID__c=ipro.Id
        );
        insert cv;
        ContentDocumentLink contentlink=new ContentDocumentLink();
        contentlink.LinkedEntityId=ipro.Id;
        contentlink.contentdocumentid=[select contentdocumentid from contentversion where id =: cv.id].contentdocumentid;
        contentlink.ShareType = 'I';
        contentlink.Visibility = 'AllUsers'; 
        
        
        insert contentlink;
        if(contentlink!=null){
            List<ContentDocumentLink> cvList =[SELECT id, ShareType, Visibility, ContentDocument.Description,ContentDocument.Title,ContentDocument.LatestPublishedVersion.VersionData,ContentDocument.LatestPublishedVersion.FileType, ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE id=:contentlink.id];
            System.debug('cvList'+cvList);
        }
        
        
        
        Test.startTest();
        if(interList!=null){
            
            MailForInterdictionNo.sendEmailToOperatorswhenNo(interList);
             //MailForInterdictionNo.MethodForFileNameType(contentlink);
            //MailForInterdictionNo.InterdictionProcessUpdateAndInsert();
           // MailForInterdictionNo.InterdictionProcessMethodTOUpdateFields();
        }
        
        
        Test.stopTest();
        
        
        
        
    }
    @isTest
    static void testMethod18() {
        InterdictionProcessInstanceSetting__c DataFromInterdictioncustom=[Select id,Sim__c, Nao__c from InterdictionProcessInstanceSetting__c ];
        system.debug('console testmethod 3');
        User u=[Select id from User where isActive=true and profile.name='System Administrator' limit 1];
        List<String> interList=new List<String>();
        
        
        Interdiction_Process__c ipro=[Select id,Instance_Number__c,IS_AN_INTERDICTION__c,TERM_NUMBER__c,Status__c,DUE_DATE__c,PRIORITY__c,REASON__c,CNPJ_CPF__c,INSCRI_O_ESTADUAL__c,CITY__c,STATE__c,RAZ_O_SOCIAL__c,Contact__c,AGENT_EMAIL_Brazil__c from Interdiction_Process__c limit 1];
        System.debug('3 ipro'+ipro);
        if(ipro!=null){
            ipro.Status__c='Process Interdiction';
            ipro.Instance_Number__c='INT00001';
            ipro.ENTRY_CLOSED__c=System.today()+1;
        }
        System.runAs(u){  
            update ipro;
        }
        
        interList.add(ipro.id);
        System.debug('interList 3'+ipro);
        System.debug('3 interList'+interList);
        ContentVersion cv = new ContentVersion(
            Title = 'Some document',
            PathOnClient = 'some document.xlsx',
            VersionData = Blob.valueOf('Lorem ipsum dolor sit amet...'),
            InterRecordID__c=ipro.Id
        );
        insert cv;
        ContentDocumentLink contentlink=new ContentDocumentLink();
        contentlink.LinkedEntityId=ipro.Id;
        contentlink.contentdocumentid=[select contentdocumentid from contentversion where id =: cv.id].contentdocumentid;
        contentlink.ShareType = 'I';
        contentlink.Visibility = 'AllUsers'; 
        
        
        insert contentlink;
        if(contentlink!=null){
            List<ContentDocumentLink> cvList =[SELECT id, ShareType, Visibility, ContentDocument.Description,ContentDocument.Title,ContentDocument.LatestPublishedVersion.VersionData,ContentDocument.LatestPublishedVersion.FileType, ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE id=:contentlink.id];
            System.debug('cvList'+cvList);
        }
        
        
        
        Test.startTest();
        if(interList!=null){
            
             MailForInterdictionNo.sendEmailToOperatorswhenNo(interList);
             //MailForInterdictionNo.MethodForFileNameType(contentlink);
  //          MailForInterdictionNo.InterdictionProcessUpdateAndInsert();
//            MailForInterdictionNo.InterdictionProcessMethodTOUpdateFields();
            
        }
        Test.stopTest();
    }
    
    @isTest
    static void testMethod21() {
        InterdictionProcessInstanceSetting__c DataFromInterdictioncustom=[Select id,Sim__c, Nao__c from InterdictionProcessInstanceSetting__c ];
        system.debug('console testmethod 3');
        User u=[Select id from User where isActive=true and profile.name='System Administrator' limit 1];
        List<String> interList=new List<String>();
        
        
        Interdiction_Process__c ipro=[Select id,Instance_Number__c,IS_AN_INTERDICTION__c,TERM_NUMBER__c,Status__c,DUE_DATE__c,PRIORITY__c,REASON__c,CNPJ_CPF__c,INSCRI_O_ESTADUAL__c,CITY__c,STATE__c,RAZ_O_SOCIAL__c,Contact__c,AGENT_EMAIL_Brazil__c from Interdiction_Process__c limit 1];
        System.debug('3 ipro'+ipro);
        if(ipro!=null){
            ipro.Status__c='Process Interdiction';
            ipro.Instance_Number__c='INT00001';
            ipro.ENTRY_CLOSED__c=System.today()+1;
        }
        System.runAs(u){  
            update ipro;
        }
        
        interList.add(ipro.id);
        System.debug('interList 3'+ipro);
        System.debug('3 interList'+interList);
        ContentVersion cv = new ContentVersion(
            Title = 'Some document',
            PathOnClient = 'some document.docx',
            VersionData = Blob.valueOf('Lorem ipsum dolor sit amet...'),
            InterRecordID__c=ipro.Id
        );
        insert cv;
        ContentDocumentLink contentlink=new ContentDocumentLink();
        contentlink.LinkedEntityId=ipro.Id;
        contentlink.contentdocumentid=[select contentdocumentid from contentversion where id =: cv.id].contentdocumentid;
        contentlink.ShareType = 'I';
        contentlink.Visibility = 'AllUsers'; 
        
        
        insert contentlink;
        if(contentlink!=null){
            List<ContentDocumentLink> cvList =[SELECT id, ShareType, Visibility, ContentDocument.Description,ContentDocument.Title,ContentDocument.LatestPublishedVersion.VersionData,ContentDocument.LatestPublishedVersion.FileType, ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE id=:contentlink.id];
            System.debug('cvList'+cvList);
        }
        
        
        
        Test.startTest();
        if(interList!=null){
           MailForInterdictionNo.sendEmailToOperatorswhenNo(interList);
             //MailForInterdictionNo.MethodForFileNameType(contentlink);
            //MailForInterdictionNo.InterdictionProcessUpdateAndInsert();
            //MailForInterdictionNo.InterdictionProcessMethodTOUpdateFields();
        }
        Test.stopTest();
    }
    @isTest
    static void testMethod20() {
        InterdictionProcessInstanceSetting__c DataFromInterdictioncustom=[Select id,Sim__c, Nao__c from InterdictionProcessInstanceSetting__c ];
        system.debug('console testmethod 3');
        User u=[Select id from User where isActive=true and profile.name='System Administrator' limit 1];
        List<String> interList=new List<String>();
        
        
        Interdiction_Process__c ipro=[Select id,Instance_Number__c,IS_AN_INTERDICTION__c,TERM_NUMBER__c,Status__c,DUE_DATE__c,PRIORITY__c,REASON__c,CNPJ_CPF__c,INSCRI_O_ESTADUAL__c,CITY__c,STATE__c,RAZ_O_SOCIAL__c,Contact__c,AGENT_EMAIL_Brazil__c from Interdiction_Process__c limit 1];
        System.debug('3 ipro'+ipro);
        if(ipro!=null){
            ipro.Status__c='Process Interdiction';
            ipro.Instance_Number__c='INT00001';
            ipro.ENTRY_CLOSED__c=System.today()+1;
        }
        System.runAs(u){  
            update ipro;
        }
        
        interList.add(ipro.id);
        System.debug('interList 3'+ipro);
        System.debug('3 interList'+interList);
        ContentVersion cv = new ContentVersion(
            Title = 'Some document',
            PathOnClient = 'some document.docx',
            VersionData = Blob.valueOf('Lorem ipsum dolor sit amet...'),
            InterRecordID__c=ipro.Id
        );
        insert cv;
        ContentDocumentLink contentlink=new ContentDocumentLink();
        contentlink.LinkedEntityId=ipro.Id;
        contentlink.contentdocumentid=[select contentdocumentid from contentversion where id =: cv.id].contentdocumentid;
        contentlink.ShareType = 'I';
        contentlink.Visibility = 'AllUsers'; 
        
        
        insert contentlink;
        if(contentlink!=null){
            List<ContentDocumentLink> cvList =[SELECT id, ShareType, Visibility, ContentDocument.Description,ContentDocument.Title,ContentDocument.LatestPublishedVersion.VersionData,ContentDocument.LatestPublishedVersion.FileType, ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE id=:contentlink.id];
            System.debug('cvList'+cvList);
        }
        
        
        
        Test.startTest();
        
        if(interList!=null){
            
             MailForInterdictionNo.sendEmailToOperatorswhenNo(interList);
//             MailForInterdictionNo.MethodForFileNameType(contentlink);
           // MailForInterdictionNo.InterdictionProcessUpdateAndInsert();
            //MailForInterdictionNo.InterdictionProcessMethodTOUpdateFields();
            
        }
        Test.stopTest();
        
    }
    @isTest
    static void testMethod22() {
        InterdictionProcessInstanceSetting__c DataFromInterdictioncustom=[Select id,Sim__c, Nao__c from InterdictionProcessInstanceSetting__c ];
        User u=[Select id from User where isActive=true and profile.name='System Administrator' limit 1];
        List<String> interList=new List<String>();
        
        
        
        Interdiction_Process__c ipro=[Select id,Instance_Number__c,IS_AN_INTERDICTION__c,Status__c,TERM_NUMBER__c,DUE_DATE__c,PRIORITY__c,REASON__c,CNPJ_CPF__c,INSCRI_O_ESTADUAL__c,CITY__c,STATE__c,RAZ_O_SOCIAL__c,Contact__c,AGENT_EMAIL_Brazil__c from Interdiction_Process__c limit 1];
        
        if(ipro!=null){
            
            ipro.Status__c='Waiting for Collection';
            ipro.Instance_Number__c='INT00001';
            
        }
        System.debug('4 ipro'+ipro);
        
        System.runAs(u){  
            update ipro;
        }
        if(ipro!=null){
            interList.add(ipro.id);
        }
        System.debug('interList 4'+interList);
        ContentVersion cv = new ContentVersion(
            Title = 'Some document4',
            PathOnClient = 'some document.docx',
            VersionData = Blob.valueOf('Lorem ipsum dolor sit amet...'),
            InterRecordID__c=ipro.Id
        );
        insert cv;
        ContentDocumentLink contentlink=new ContentDocumentLink();
        contentlink.LinkedEntityId=ipro.Id;
        contentlink.contentdocumentid=[select contentdocumentid from contentversion where id =: cv.id].contentdocumentid;
        contentlink.ShareType = 'I';
        contentlink.Visibility = 'AllUsers'; 
        
        
        insert contentlink;
        if(contentlink!=null){
            List<ContentDocumentLink> cvList =[SELECT id, ShareType, Visibility, ContentDocument.Description,ContentDocument.Title,ContentDocument.LatestPublishedVersion.VersionData,ContentDocument.LatestPublishedVersion.FileType, ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE id=:contentlink.id];
            
        }
        Test.startTest();
        if(interList!=null){
            
            MailForInterdictionNo.sendEmailToOperatorswhenNo(interList);
             //MailForInterdictionNo.MethodForFileNameType(contentlink);
            //MailForInterdictionNo.InterdictionProcessUpdateAndInsert();
            //MailForInterdictionNo.InterdictionProcessMethodTOUpdateFields();
        }
        Test.stopTest();
    }
    @isTest
    static void testMethod23() {
        InterdictionProcessInstanceSetting__c DataFromInterdictioncustom=[Select id,Sim__c, Nao__c from InterdictionProcessInstanceSetting__c ];
        system.debug('console testmethod 3');
        User u=[Select id from User where isActive=true and profile.name='System Administrator' limit 1];
        List<String> interList=new List<String>();
        
        
        Interdiction_Process__c ipro=[Select id,Instance_Number__c,IS_AN_INTERDICTION__c,TERM_NUMBER__c,Status__c,DUE_DATE__c,PRIORITY__c,REASON__c,CNPJ_CPF__c,INSCRI_O_ESTADUAL__c,CITY__c,STATE__c,RAZ_O_SOCIAL__c,Contact__c,AGENT_EMAIL_Brazil__c from Interdiction_Process__c limit 1];
        System.debug('3 ipro'+ipro);
        if(ipro!=null){
            ipro.Status__c='Process Interdiction';
            ipro.Instance_Number__c='INT00001';
            ipro.ENTRY_CLOSED__c=System.today()+1;
        }
        System.runAs(u){  
            update ipro;
        }
        
        interList.add(ipro.id);
        System.debug('interList 3'+ipro);
        System.debug('3 interList'+interList);
        ContentVersion cv = new ContentVersion(
            Title = 'Some document',
            PathOnClient = 'some document.pptx',
            VersionData = Blob.valueOf('Lorem ipsum dolor sit amet...'),
            InterRecordID__c=ipro.Id
        );
        insert cv;
        ContentDocumentLink contentlink=new ContentDocumentLink();
        contentlink.LinkedEntityId=ipro.Id;
        contentlink.contentdocumentid=[select contentdocumentid from contentversion where id =: cv.id].contentdocumentid;
        contentlink.ShareType = 'I';
        contentlink.Visibility = 'AllUsers'; 
        
        
        insert contentlink;
        if(contentlink!=null){
            List<ContentDocumentLink> cvList =[SELECT id, ShareType, Visibility, ContentDocument.Description,ContentDocument.Title,ContentDocument.LatestPublishedVersion.VersionData,ContentDocument.LatestPublishedVersion.FileType, ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE id=:contentlink.id];
            System.debug('cvList'+cvList);
        }
        
        
        
        Test.startTest();
        
        if(interList!=null){
            
             MailForInterdictionNo.sendEmailToOperatorswhenNo(interList);
             //MailForInterdictionNo.MethodForFileNameType(contentlink);
           // MailForInterdictionNo.InterdictionProcessUpdateAndInsert();
            //MailForInterdictionNo.InterdictionProcessMethodTOUpdateFields();
        }
        Test.stopTest();
        
    }
}