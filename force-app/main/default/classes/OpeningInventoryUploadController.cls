public without sharing class OpeningInventoryUploadController {
    
    // getting Opening_Inventory_Upload_Template Id
    @AuraEnabled
    public static String getOIDetails(){
        String reportId='';
        try{
            String reportName='Opening_Inventory_Upload_Template';
            reportId = getTemplateToDownload(reportName);               
        }
        catch(Exception ex){
            System.debug('Exception in getOIDetails method...');
            System.debug('Exception is - ' + ex);
            System.debug('Exception Line no. - ' + ex.getLineNumber());
            return reportId;
        }
        
        return reportId;
    }
    
    // Downloading Opening_Inventory_Upload_Template
    @AuraEnabled
    public static String getTemplateToDownload(String fileName){
        String result = '';
        try{
            List<Document> docList = [SELECT Id, Name, DeveloperName, Type, IsPublic, Description FROM Document 
                                      WHERE DeveloperName =: fileName];
            if(docList.size()>0){
                result = docList[0].Id;
            }                          
        }
        catch(Exception ex){
            System.debug('Exception Occure in getTemplateToDownload');
            System.debug('Exception is - ' + ex);
            System.debug('Exception at Line -' + ex.getLineNumber());
            result = '';
            return result;
        }
        
        return result;
    }
    
    // getting Opening Inventory Records to update
    @AuraEnabled
    public static List<Opening_Inventory2__c> getOpeningInvRecords( String combi_key, String year){
        List<Opening_Inventory2__c> oiList = new List<Opening_Inventory2__c>();
        try{
            List<String> combiKeyList = (List<String>)JSON.deserialize(combi_key, List<String>.class) ;  
            System.debug('combiKeyList is - ' + combiKeyList);
            System.debug('year is - ' + year);
            oiList = [SELECT id, Opening_Inventory__c,
                      SKU__r.SKU_Code__c,
                      Multi_Country_Formula_Key__c,Distributor__r.sap_code__c  
                      FROM Opening_Inventory2__c WHERE SKU__r.Active_for_Liquidation__c = true AND Sales_Org_Code__c = '2941' and
                      Multi_Country_Key__c IN: combiKeyList AND 
                      Liquidation_Annual_Plan__r.Fiscal_year__c =: year];         /* ------------Start GRZ(Butesh Singla) : APPS-1395 PO And Delivery Date :11-07-2022 */     
        }
        catch(Exception ex){
            System.debug('Exception in getOpeningInvRecords method...');
            System.debug('Exception is - ' + ex);
            System.debug('Exception Line no. - ' + ex.getLineNumber());
            return oiList;
        }
        System.debug('Opening Inventory Records are - '+ oiList);
        return oiList;
    }
    
    // Update Opening Inventory Records
    @AuraEnabled
    public static String updateOpeningInv(String oiData, String dupList,List<String> Sku_Code,List<String> Dis_Code){
        String result = '';
        List<Opening_Inventory2__c> oiListToUpdate = new List<Opening_Inventory2__c>();
        try{
             /* ------------Start GRZ(Butesh Singla) : APPS-1395 PO And Delivery Date :11-07-2022 */
             User loginUserObj = new User(); 
            loginUserObj = [SELECT Id, Name, Country, IsActive, ProfileId, Profile.Name, Email  
                            FROM User WHERE Id =: UserInfo.getUserId()];
            
            /* -- */
            
            Boolean flag = false;
            String header = 'Year, Distributor Code, SKU Code, Opening Inventory ';	
            
            String successContent = '';
            String errorContent = '';
            errorContent += header;
            successContent += header;
            List<OpeningInvWrapper> csvList = (List<OpeningInvWrapper>)JSON.deserialize(dupList, List<OpeningInvWrapper>.class) ;  /* ------------Start GRZ(Butesh Singla) : APPS-1395 PO And Delivery Date :11-07-2022 */ 
            List<OpeningInvWrapper> oiList = (List<OpeningInvWrapper>)JSON.deserialize(oiData, List<OpeningInvWrapper>.class) ;
            System.debug('oiList is - ' + oiList);
            if(oiList.size()>0){
                for(OpeningInvWrapper oiWrap : oiList){
                    Opening_Inventory2__c oi2 = new Opening_Inventory2__c();
                    oi2.id = oiWrap.id;
                    
                    oi2.Opening_Inventory__c = Decimal.valueOf(oiWrap.openInv);
                    oiListToUpdate.add(oi2);
                }
                
                 /* ------------Start GRZ(Butesh Singla) : APPS-1395 PO And Delivery Date :11-07-2022 */ 
                for(OpeningInvWrapper oiWrap : csvList){
                    if(Sku_Code.contains(oiWrap.skuCode) && Dis_Code.contains(oiWrap.distbtrCode)){
                    String recordString = '';
                    recordString = '\n"'+oiWrap.year+'","'+oiWrap.distbtrCode+'","'+oiWrap.skuCode +'","'+oiWrap.openInv +'"';
                    successContent += recordString;
                    }else{
                     String recordString = '';
                    recordString = '\n"'+oiWrap.year+'","'+oiWrap.distbtrCode+'","'+oiWrap.skuCode +'","'+oiWrap.openInv +'"';
                    errorContent += recordString;
                    }
                }
                /*--*/
                
            }
            
            if(oiListToUpdate.size()>0){
                update oiListToUpdate;
                
                result = 'success';
                
                
            }
            else{
                result = 'data not found';
            }
            
            System.debug('updateLiquidation liqListToUpdate' + oiListToUpdate);
            
            /* ------------Start GRZ(Butesh Singla) : APPS-1395 PO And Delivery Date :11-07-2022 */  
            Messaging.EmailFileAttachment csvAttcError = new Messaging.EmailFileAttachment();
            blob csvBlob = Blob.valueOf(errorContent);
            string csvname= 'error.csv';
            csvAttcError.setFileName(csvname);
            csvAttcError.setBody(csvBlob);
            
            Messaging.EmailFileAttachment csvAttcSuccess = new Messaging.EmailFileAttachment();
            blob csvBlob2 = Blob.valueOf(successContent);
            string csvname2= 'success.csv';
            csvAttcSuccess.setFileName(csvname2);
            csvAttcSuccess.setBody(csvBlob2);
            
            Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();
            String[] toAddresses = new list<string> {loginUserObj.email};
               // String[] toAddresses = new String[]{'butesh.singla@grazitti.com'};
                String subject ='Opening Inventory Upload Reports';
            email.setSubject(subject);
            email.setToAddresses( toAddresses );
            email.setPlainTextBody('Hi, \n Please Find below attachments of Success and Error files for the Opening Inventory you have uploaded.');
            email.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttcError,csvAttcSuccess});  // can pass multiple file comma seperated..
            Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
            
            upload_status__c up = new upload_status__c();
            up.name = 'Opening Inventory ( ' + loginUserObj.country + ' )';
            up.upload_by__c = loginUserObj.id;
            up.country__c = loginUserObj.country;
            insert up;
            
            ContentVersion cv = new ContentVersion();
            cv.Title = 'success';
            cv.PathOnClient = 'success.csv';
            cv.VersionData = Blob.valueOf(successContent);
            Insert cv;
            Id conDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cv.Id].ContentDocumentId;
            ContentDocumentLink cdl = New ContentDocumentLink();
            cdl.LinkedEntityId = up.Id;
            cdl.ContentDocumentId = conDocId;
            cdl.shareType = 'I';
            cdl.Visibility = 'AllUsers';
            Insert cdl;
            
            
            ContentVersion cv1 = new ContentVersion();
            cv1.Title = 'error';
            cv1.PathOnClient = 'error.csv';
            cv1.VersionData = Blob.valueOf(errorContent);
            Insert cv1;
            Id conDocId1 = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cv1.Id].ContentDocumentId;
            ContentDocumentLink cdl1 = New ContentDocumentLink();
            cdl1.LinkedEntityId = up.Id;
            cdl1.ContentDocumentId = conDocId1;
            cdl1.shareType = 'I';
            cdl1.Visibility = 'AllUsers';
            Insert cdl1;
            
            /* -- */ 
            
        }
        catch(Exception ex){
            System.debug('Exception Occure in updateLiquidation');
            System.debug('Exception is - ' + ex);
            System.debug('Exception at Line -' + ex.getLineNumber());
            result = 'fail';
            return result;
        }
        return result;
    }
    
    
    public class OpeningInvWrapper {
        @AuraEnabled public String id ;
        @AuraEnabled public Integer openInv ;
        @AuraEnabled public String year;
        @AuraEnabled public String distbtrCode;
        @AuraEnabled public String skuCode;
        
        public OpeningInvWrapper(){
            this.id= '';
            this.openInv = 0;
            this.year = '';
            this.distbtrCode = '';
            this.skuCode = '';
        }
        
    }
    
    
}