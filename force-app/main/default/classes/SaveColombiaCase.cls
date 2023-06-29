public without sharing class SaveColombiaCase {
     
    @AuraEnabled
    public static List<Account> getAccountEmailandPhone(String accid){
        List<Account> acclst = [select id,Name,Mobile__c,Email__c,Tax_Number_1__c from Account where id=:accid];
        if(acclst.size()>0){
            return acclst;
        }else{
            return new List<Account>();
        }
    }

    @AuraEnabled
    public static CaseProductInformationWrap getCaseInfomation(String case_recid){
        System.debug('Case recID -->'+case_recid);
        CaseProductInformationWrap caseProductinfo = new CaseProductInformationWrap();
        if(!String.isEmpty(case_recid)){
            Case caseinfoRec = [SELECT Id,CaseNumber, Priority, Type, FAQs_Effectiveness__c, AccountID,Account.Name, Farmer_Name__c,Country__c, Email__c, ID_Number__c, Mobile_Number_col__c,Reason_for_Closure__c,Additional_Information__c, status,Zone__c,City__c,Sales_representative__c,Sales_representative__r.Name, RecordTypeId,CreatedById From Case where Id=:case_recid];

            if(caseinfoRec!=null){
                caseProductinfo.caseRec = caseinfoRec;
            }

            List<Case_Product_Information__c> lst_productinfo = [SELECT Id, Case__c, Product__c,Product__r.Name, SKU__c, SKU__r.SKU_Description__c,Quantity__c, Expiration_Date__c, Date_of_Receiving_Product__c, Lot_Number__c,Price__c FROM Case_Product_Information__c where Case__c=:case_recid];

            List<ProductInfo> lstproductinfowrap = new  List<ProductInfo>();

            if(!lst_productinfo.isEmpty()){
                for(Case_Product_Information__c caseinfo: lst_productinfo){
                    ProductInfo product_info = new ProductInfo();
                    product_info.caseId = caseinfo.Case__c;
                    product_info.recId = caseinfo.Id;
                    product_info.product = caseinfo.Product__c;
                    product_info.sku = caseinfo.SKU__c;
                    product_info.quality = String.valueOf(caseinfo.Quantity__c);
                    product_info.lot_number = caseinfo.Lot_Number__c;
                    product_info.expiration_date = String.valueOf(caseinfo.Expiration_Date__c);
                    product_info.date_of_receiving =  String.valueOf(caseinfo.Date_of_Receiving_Product__c);
                    product_info.productname = caseinfo.Product__r.Name;
                    product_info.skuname = caseinfo.SKU__r.SKU_Description__c;
                    product_info.price = String.valueOf(caseinfo.Price__c);

                    lstproductinfowrap.add(product_info);
                }
            caseProductinfo.lstProductinfo = lstproductinfowrap;
            }

        } 
        System.debug('caseProductinfo '+caseProductinfo.lstProductinfo.size());
        System.debug('caseProductinfo '+caseProductinfo);
        return caseProductinfo;
    }

    @AuraEnabled
    public static String SaveCase(Case case_rec){
        try{
            Boolean assignment = false;  
            Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Colombia Case').getRecordTypeId();
            System.debug('Record type '+recordTypeId);
            Case caseRec = case_rec;
            
            caseRec.RecordTypeId = recordTypeId;
            System.debug('Case Obj '+caseRec);
            if(!String.isEmpty(String.valueOf(caseRec.Type)) && caseRec.Id==null){
                // System.debug('add Assignments method call');
                // if(caseRec.Type=='Invoice'){
                //     caseRec = addAssignmentRule(caseRec);
                // }
                assignment = true;
            }
            upsert caseRec; 
            addAttachment(caseRec.Id+'');
            // if(!String.isEmpty(String.valueOf(caseRec.AccountId))){
            addCaseTeamMember(caseRec.AccountId,caseRec.Id,caseRec.Sales_representative__c);
            
            if(caseRec.status=='Closed' || caseRec.status=='Cerrado' ){
                addCaseClosedEmail(caseRec.Id+'',CaseRec.CreatedById+'');
            }
            System.debug('Case created-->'+caseRec.Id);
            return caseRec.Id+' '+assignment;
           //return '5000k00000CmhaNAAR'; 
        }catch(Exception ex){
            System.debug('Exception while insert '+ex);
            return 'failed';
        }
    }

    public static void addCaseClosedEmail(String case_id,String bcc_user){
            System.debug('Bcc user id '+bcc_user);
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 
            // mail.setTargetObjectId('0050k000001hfYKAAY'); 
            mail.setTargetObjectId(bcc_user); 
            //Change with Template ID
            mail.setTemplateId([Select id,Name from EmailTemplate where Name = 'Case Closer Email Template' limit 1].Id); 
            
            //Record ID for which letter will be generated
            mail.setWhatId(case_id); 
            mail.setBccSender(false); 
            mail.setUseSignature(false); 
            mail.setSenderDisplayName('UPL Team'); 
            mail.setSaveAsActivity(false); 
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });

    }

    @AuraEnabled
    public static String addAssignmentRule(String case_id){
        Case c = [Select id,AccountId,Sales_representative__c from Case where id=:case_id]; 
        AssignmentRule AR = new AssignmentRule();
        AR = [select id from AssignmentRule where SobjectType = 'Case' and Active = true limit 1];

        Database.DMLOptions dmlOpts = new Database.DMLOptions();
        dmlOpts.assignmentRuleHeader.assignmentRuleId= AR.id;
        // dmlOpts.EmailHeader.triggerAutoResponseEmail = true;
        dmlOpts.EmailHeader.triggerUserEmail = true; 
        c.setOptions(dmlOpts);
        upsert c;
        if(c.Sales_representative__c!=null){
            addCaseAssignedEmail(c.Id+'',c.Sales_representative__c+'');
             //addCaseTeamMember(c.AccountId+'',c.Id+'',c.Sales_representative__c+'');
        }

        return 'case Assigned';
    }
//Edit
    public static void addCaseAssignedEmail(String case_id,String sales_rep_user){
        System.debug('sales_rep_user '+sales_rep_user);
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 
        // mail.setTargetObjectId('0050k000001hfYKAAY'); 
        mail.setTargetObjectId(sales_rep_user); 
        //Change with Template ID
        mail.setTemplateId([Select id,Name from EmailTemplate where Name = 'Case Assignment Email Template' limit 1].Id); 
        
        //Record ID for which letter will be generated
        mail.setWhatId(case_id); 
        mail.setBccSender(false); 
        mail.setUseSignature(false); 
        mail.setSenderDisplayName('UPL Team'); 
        mail.setSaveAsActivity(false); 
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });

}

    public static void addCaseTeamMember(String acc_id,String case_id,String usr_id){
        List<CaseTeamMember> lst_ctm = new List<CaseTeamMember>();
       String caseteam_role = [SELECT AccessLevel,Id,Name FROM CaseTeamRole where Name='Access Team' limit 1].Id;
        system.debug('acc_id>>--->'+acc_id);
        if(acc_id!=null){
        System.debug('acc_id '+acc_id+'case_id '+case_id);
        List<AccountTeamMember> lst_atm = [select id,AccountId,UserId from AccountTeamMember where AccountId=:acc_id];
        System.debug('lst_atm size '+lst_atm.size());
        
        for(AccountTeamMember atm : lst_atm){
             CaseTeamMember ctm = new CaseTeamMember();
            ctm.ParentId = Id.valueOf(case_id);
            ctm.MemberId = atm.UserId;
            // ctm.TeamRoleId = Id.valueOf('0B70k0000004CHHCA2');
            ctm.TeamRoleId = Id.valueOf(caseteam_role);
            lst_ctm.add(ctm);
           /* CaseShare CaseShareRecord=new CaseShare();
            CaseShareRecord.CaseId=Id.valueOf(case_id);
            CaseShareRecord.UserOrGroupId=atm.UserId;
            CaseShareRecord.CaseAccessLevel='Read';
            CaseShareRecord.RowCause ='manual';
            lst_ctm.add(CaseShareRecord);*/
        }
        try {
            insert lst_ctm;
            System.debug('CaseTeamMember --> '+lst_ctm);
        } catch (Exception ex) {
            System.debug('CaseTeamMember --> '+ex);
        }
    }else{
            /*CaseShare CaseShareRecord=new CaseShare();
            CaseShareRecord.CaseId=Id.valueOf(case_id);
            CaseShareRecord.UserOrGroupId=Id.valueOf(usr_id);
            CaseShareRecord.CaseAccessLevel='Read';
            CaseShareRecord.RowCause ='manual';
            insert CaseShareRecord;*/
        if(!Test.isRunningTest()){
             CaseTeamMember ctm = new CaseTeamMember();
            ctm.ParentId = Id.valueOf(case_id);
            ctm.MemberId = usr_id;
        	ctm.TeamRoleId = Id.valueOf(caseteam_role);
        	system.debug('CaseTeamMember'+ctm);
        	insert ctm;	
        }
        	
    }
    }

    public static void addAttachment(String caseid){
        Id file_attachement = [select Id from File_Attachment__c where Name = 'Colombia Case'].Id;
        Id fromCaseId = file_attachement; // FROM CASE record id 
        Id toCaseId = caseid; // TO CASE record id 
        List<ContentDocumentLink> cdlList = new List<ContentDocumentLink>();
        List<ContentDocumentLink> cdlExt = new List<ContentDocumentLink>();
        for(ContentDocumentLink cdl : [SELECT Id, LinkedEntityId, ContentDocumentId, ShareType FROM ContentDocumentLink WHERE LinkedEntityId = :fromCaseId]) {
				ContentDocumentLink cloned = cdl.clone();
				cloned.LinkedEntityId = toCaseId;
				cloned.ShareType = cdl.ShareType;
			    cdlList.add(cloned);
			    cdlExt.add(cdl);
            }
        System.debug('CDL list '+cdlList);  
        insert cdlList; // new CDL records
        delete cdlExt; // delete old CDL records 
       
    }

    @AuraEnabled
    public static List<Case_Product_Information__c> getProductInformation(String caseid){
        if(!String.isEmpty(caseid)){
        List<Case_Product_Information__c> lst_productInfonation = [SELECT Id, Case__c, Product__c, SKU__c, Quantity__c, Expiration_Date__c, Date_of_Receiving_Product__c, Lot_Number__c FROM Case_Product_Information__c where Case__c=:caseid];

        if(lst_productInfonation.size()>0){
            return lst_productInfonation;
        }else{
            return new List<Case_Product_Information__c>();
        }
        }else{
            return new List<Case_Product_Information__c>();
        }
    }

    @AuraEnabled
    public static Integer makeProductList(string case_id,String productlst){
       
        List<ProductInfo> product_data = (List<ProductInfo>) JSON.deserialize(productlst,List<ProductInfo>.class);
        List<Case_Product_Information__c> caseProductinfolst = new List<Case_Product_Information__c>();
        System.debug('PRODUCT DATA'+product_data);
        for(ProductInfo pinf:product_data ){
            Case_Product_Information__c caseProductinfo = new Case_Product_Information__c();
            if(!String.isEmpty(pinf.recId)){
                caseProductinfo.Id = Id.valueOf(pinf.recId);
            }
            caseProductinfo.Case__c = Id.valueOf(case_id);
            caseProductinfo.Date_of_Receiving_Product__c = date.valueOf(pinf.date_of_receiving);
            caseProductinfo.Expiration_Date__c = date.valueOf(pinf.expiration_date);
            caseProductinfo.Lot_Number__c = pinf.lot_number;
            caseProductinfo.Product__c = Id.valueOf(pinf.product);
            caseProductinfo.Quantity__c = Decimal.valueOf(pinf.quality);
            caseProductinfo.SKU__c = Id.valueOf(pinf.sku); 
            caseProductinfo.Price__c = Decimal.valueOf(pinf.price); 
            caseProductinfolst.add(caseProductinfo);
        }
        try {
            System.debug('insert statement case Product');
            upsert caseProductinfolst;
        } catch (DMLException e) {
            System.debug('DML ex '+e);
        }
        System.debug('List Case_Product_Information__c '+caseProductinfolst);
        return caseProductinfolst.size();
    }

    @AuraEnabled
    public static Integer deleteProductList(List<String> case_id){
        List<Case_Product_Information__c> del_lst = [SELECT Id FROM Case_Product_Information__c where id in:case_id];
        if(del_lst.size()>0){
            try{
                delete del_lst;
            }catch(DmlException ex){
                System.debug('DML exception '+ex);
            }
        }
        return case_id.size();
    }

    @AuraEnabled
    public static List<ContentDocumentLink> getFilesdata(String caseid){
        return [SELECT LinkedEntityId,ContentDocument.title, ContentDocument.FileExtension FROM ContentDocumentLink WHERE LinkedEntityId =:caseid];
    }

    @AuraEnabled
    public static List<ContentDocumentLink> getFilesdataTemp(){
        Id file_attachement = [select Id from File_Attachment__c where Name = 'Colombia Case'].Id;
        return [SELECT LinkedEntityId,ContentDocument.title, ContentDocument.FileExtension FROM ContentDocumentLink WHERE LinkedEntityId =:file_attachement];
    }

    @AuraEnabled(cacheable=true)
    public static string getFileAttachment(){
        Id file_attachement = [select Id from File_Attachment__c where Name = 'Colombia Case'].Id;
        return String.valueOf(file_attachement);
    }

    @AuraEnabled
    public static string deleteFilefromTemp(){
        Id file_attachement = [select Id from File_Attachment__c where Name = 'Colombia Case'].Id;
        List<ContentDocumentLink> cdl = [SELECT ContentDocumentId,ContentDocument.Title,ContentDocument.CreatedDate,LinkedEntityId FROM ContentDocumentLink where LinkedEntityId=:file_attachement];
        system.debug('cdl '+cdl);
        try{
            delete cdl;
            return 'Deleted';
        }catch(DMLException e){
            System.debug('deleting -->'+e);
        }
        return 'false';
    }

    @AuraEnabled
    public static string deleteFiles(String lst_data){
       System.debug('lst_data'+lst_data);
       List<FileWrapper> files_to_delete =  (List<FileWrapper>)JSON.deserialize(lst_data, List<FileWrapper>.class);
       System.debug('File to Delete -->'+files_to_delete);
        List<ContentDocumentLink> lst_cdl_delete = new List<ContentDocumentLink>();
        for(FileWrapper files_del : files_to_delete){
            ContentDocumentLink cdl = [SELECT ContentDocumentId,ContentDocument.Title,ContentDocument.CreatedDate,LinkedEntityId FROM ContentDocumentLink where ContentDocumentId=:files_del.contentdoc_id and LinkedEntityId=:files_del.link_id];
            lst_cdl_delete.add(cdl);
            System.debug('Lst to delete '+lst_cdl_delete);
        }
        delete lst_cdl_delete;
        return String.valueOf(lst_cdl_delete.size());
    }

  

public  class ProductInfo {
        public Integer id;
        @AuraEnabled public string caseId;
        @AuraEnabled public String recId;// case product info Id
        @AuraEnabled public String product;
        @AuraEnabled public String sku;
        @AuraEnabled public String quality;
        @AuraEnabled public String lot_number;
        @AuraEnabled public String expiration_date;
        @AuraEnabled public String date_of_receiving;
        @AuraEnabled public String productname;
        @AuraEnabled public String skuname;
        @AuraEnabled public String price;
        
    
        ProductInfo(){
            id = 0;
            caseId = '';
            recId = '';
            product = '';
            sku = '';
            quality = '';
            lot_number = '';
            expiration_date = '';
            date_of_receiving = '';
            productname = '';
            skuname = '';
            price = '';
        }
}

public class CaseProductInformationWrap{
    @AuraEnabled public case caseRec;
    @AuraEnabled public List<ProductInfo> lstProductinfo;
    

    CaseProductInformationWrap(){
        caseRec  = new Case();
        lstProductinfo = new List<ProductInfo>();
    }
}

public class FileWrapper{
    public String contentdoc_id;
    public String link_id;

    FileWrapper(){
        contentdoc_id = '';
        link_id = '';
    }
}

}