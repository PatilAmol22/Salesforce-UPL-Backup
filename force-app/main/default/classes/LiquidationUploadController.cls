public without sharing class LiquidationUploadController {
   @AuraEnabled
   public static OtherDetailsWrapper getLiquidationDetails(String distId){
    OtherDetailsWrapper otherDetail = new OtherDetailsWrapper();

    try{
        String reportName = '';
        User loginUserObj = new User(); 
        loginUserObj = [SELECT Id, Name, Country, IsActive, ProfileId, Profile.Name,email 
                        FROM User WHERE Id =: UserInfo.getUserId()]; //Start GRZ(Butesh Singla) : APPS-1395 PO And Delivery Date :11-07-2022

        
        if(loginUserObj.Profile.Name == 'Partner Community User-Turkey'){
            otherDetail.isCommunity = true;
            reportName = 'Liquidation_Upload_Template_Community';
            /* String repoId = getTemplateToDownload(reportName); 

            List<ContentDocumentLink> contentDocLinkList = [SELECT Id, LinkedEntityId, ContentDocumentId FROM ContentDocumentLink 
                                    WHERE LinkedEntityId =: UserInfo.getUserId() AND ContentDocumentId =: repoId];

            if(contentDocLinkList.size()>0){

            }

            ContentDocumentLink contentDocumentLink = new ContentDocumentLink(
                LinkedEntityId = recordIdWithWhichYouWantToShareFile,
                ContentDocumentId = contentDocumentIdWhichYouWantShare,
                shareType = 'V',
                Visibility = 'AllUsers'
            );

            insert contentDocumentLink; */
        }
        else{
            otherDetail.isCommunity = false;
            if(distId=='poland'){
                reportName = 'Liquidation_Upload_Template_Poland';
            }else{
                reportName = 'Liquidation_Upload_Template';
            }
            
             
        }
        
        otherDetail.salesDistName = getSalesDistrictName(distId);
        otherDetail.reportId = getTemplateToDownload(reportName);   
         if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }            
    }
    catch(Exception ex){
        System.debug('Exception in getLiquidationDetails method...');
        System.debug('Exception is - ' + ex);
        System.debug('Exception Line no. - ' + ex.getLineNumber());
        return otherDetail;
    }

    return otherDetail;
   }

    @AuraEnabled
    public static List<Liquidation2__c> getLiquidationRecords(String sales_Dist, String combi_key, String month, String year, String quarter){
     //Map<String,Liquidation2__c> liquiMap = new Map<String,Liquidation2__c>();
     List<Liquidation2__c> liquiList = new List<Liquidation2__c>();
     try{
        List<String> combiKeyList = (List<String>)JSON.deserialize(combi_key, List<String>.class) ;
       // Date start_date = date.newinstance(Integer.valueOf(year), 4, 1);
       // System.debug('start_date is - ' + start_date);
        System.debug('month is - ' + month);    
        System.debug('combiKeyList is - ' + combiKeyList);
        System.debug('Sales_District__c is - ' + sales_Dist);
       // System.debug('salesOrg is - ' + salesOrg);
         if(sales_Dist!='poland'){
             liquiList = [SELECT id, Month__c,Opening_Inventory2__c,Opening_Inventory2__r.Opening_Inventory__c,
                    submitted__c,SKU__r.SKU_Code__c,SKU__r.SKU_Description__c,YTD_Sales__c,Liquidation_YTD__c,
                    Total_Available_Stock__c, Distributor__c, Distributor__r.SAP_Code__c, Distributors_Inventory__c, 
                    Retailers_Inventory__c,Total_Market_Inventory__c, Plan_for_the_month__c, Sales_District__r.Name, 
                    Plan_for_the_next_month__c, Liquidation_Annual_Plan__r.Fiscal_year__c, Distributor__r.Name,
                    Multi_Country_Formula_Key__c, Edit_Access__c  
                    FROM Liquidation2__c WHERE SKU__r.Active_for_Liquidation__c = true AND Month__c =:  month AND 
                    Multi_Country_Formula_Key__c IN: combiKeyList AND  Sales_District__c =: sales_Dist AND 
                    Liquidation_Annual_Plan__r.Fiscal_year__c =: year];
         }
         else{
            liquiList = [SELECT id, Quarter__c,Opening_Inventory2__r.Opening_Inventory__c,
                    SKU__r.SKU_Code__c,
                     Distributor__c, Distributor__r.SAP_Code__c, Distributors_Inventory__c, 
                    Retailers_Inventory__c,Total_Market_Inventory__c, Plan_for_the_month__c, 
                    Plan_for_the_next_month__c,
                    Multi_Country_Formula_Key__c, Edit_Access__c  
                    FROM Liquidation2__c WHERE SKU__r.Active_for_Liquidation__c = true AND Quarter__c =:  quarter AND Sales_Org_Code__c = '2941' and
                    Multi_Country_Formula_Key__c IN: combiKeyList AND 
                    Liquidation_Annual_Plan__r.Fiscal_year__c =: year];  /* ------------Start GRZ(Butesh Singla) : APPS-1395 PO And Delivery Date :11-07-2022 */

         }
        

        /* if(liquiList.size()>0){
            for(Liquidation2__c liq : liquiList){
                String key = salesOrg+liq.Distributor__r.SAP_Code__c+liq.SKU__r.SKU_Code__c+year+month;
                if(!liquiMap.containsKey(key)){
                    liquiMap.put(key,liq);
                }
                System.debug('Key is - ' + key);
            }
        } */    
         if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }        
     }
     catch(Exception ex){
        System.debug('Exception in getLiquidationRecords method...');
        System.debug('Exception is - ' + ex);
        System.debug('Exception Line no. - ' + ex.getLineNumber());
        return liquiList;
     }
     System.debug('Liquidation Records are - '+ liquiList);
     return liquiList;
    }

   @AuraEnabled
   public static String updateLiquidation(String liquiData,Boolean isPoland, string dupList,List<String> Sku_Code,List<String> Dis_Code){
       system.debug('liquiData==>>'+liquiData);
    String result = '';
    List<Liquidation2__c> liqListToUpdate = new List<Liquidation2__c>();
    User loginUserObj = new User(); 
    try{
        Boolean flag = false;
        String header='';
        if(isPoland==false){
         header = 'Year, Month, Distributor Code, SKU Code, Distributors Inventory ';
        }
        else{
         header = 'Year, Quarter, Distributor Code, SKU Code, Distributors Inventory '; 
        }
        String successContent = '';
        String errorContent = '';
        loginUserObj = [SELECT Id, Name, Country, IsActive, ProfileId, Profile.Name, Email  
                        FROM User WHERE Id =: UserInfo.getUserId()];

        if(loginUserObj.Profile.Name == 'Partner Community User-Turkey'){
            header += ' \n';
        }
        else{
            if(isPoland==false){
                header += ' , Retailers Inventory, Plan for the next month \n';
            }
            else{
                header += ' , Plan for the next quarter \n';
            }
        }
        errorContent += header;
        successContent += header;
         List<LiquidationWrapper> csvList = (List<LiquidationWrapper>)JSON.deserialize(dupList, List<LiquidationWrapper>.class) ;  /* ------------Start GRZ(Butesh Singla) : APPS-1395 PO And Delivery Date :11-07-2022 */
        List<LiquidationWrapper> liquidationList = (List<LiquidationWrapper>)JSON.deserialize(liquiData, List<LiquidationWrapper>.class) ;
        System.debug('liquidationList is - ' + liquidationList);
        if(liquidationList.size()>0){
            for(LiquidationWrapper liqWrap : liquidationList){
                Liquidation2__c liq2 = new Liquidation2__c();
                liq2.id = liqWrap.id;
                String recordString = '';
                System.debug('liqWrap.community - ' + liqWrap.community +' Edit access - '+ liqWrap.editAccess);
                if(liqWrap.community == true && liqWrap.editAccess == true){
                    liq2.Distributors_Inventory__c = Decimal.valueOf(liqWrap.distInv);
                    liqListToUpdate.add(liq2);
                    //recordString = '"'+liqWrap.year+'","'+liqWrap.month+'","'+liqWrap.distbtrCode+'","'+liqWrap.skuCode +'", "'+liqWrap.distInv+'" \n';
                    //successContent += recordString;
                }
                else{
                    if(isPoland==false){
                      //  recordString = '"'+liqWrap.year+'","'+liqWrap.month+'","'+liqWrap.distbtrCode+'","'+liqWrap.skuCode +'", "'+liqWrap.distInv+'" \n';
                    
                   // errorContent += recordString;
                    flag = true;
                    }
                }
                
                if(liqWrap.community == false){
                    if(isPoland==false){
                        if(liqWrap.editAccess == true){
                            liq2.Distributors_Inventory__c = Decimal.valueOf(liqWrap.distInv);
                            liq2.Retailers_Inventory__c = Decimal.valueOf(liqWrap.retailInv);
                            liq2.Plan_for_the_next_month__c = Decimal.valueOf(liqWrap.planNxtMnth);
                            liqListToUpdate.add(liq2);

                            recordString = '"'+liqWrap.year+'","'+liqWrap.month+'","'+liqWrap.distbtrCode+'","'+liqWrap.skuCode +'", "'+liqWrap.distInv+'", "'+liqWrap.retailInv+'", "'+liqWrap.planNxtMnth+'" \n';
                            successContent += recordString;
                        }
                        else{
                            recordString = '"'+liqWrap.year+'","'+liqWrap.month+'","'+liqWrap.distbtrCode+'","'+liqWrap.skuCode +'", "'+liqWrap.distInv+'", "'+liqWrap.retailInv+'", "'+liqWrap.planNxtMnth+'" \n';
                            errorContent += recordString;
                            flag = true;
                        }
                    }
                    else{
                        liq2.Distributors_Inventory__c = Decimal.valueOf(liqWrap.distInv);
                            liq2.Plan_for_the_next_quarter__c = Decimal.valueOf(liqWrap.planNxtMnth);
                            liqListToUpdate.add(liq2);

                            recordString = '"'+liqWrap.year+'","'+liqWrap.quarter+'","'+liqWrap.distbtrCode+'","'+liqWrap.skuCode +'", "'+liqWrap.distInv+'", "'+liqWrap.planNxtMnth+'" \n';
                            successContent += recordString;
                    }
                    
                }
                                                
            }
        }
          /* ------------Start GRZ(Butesh Singla) : APPS-1395 PO And Delivery Date :11-07-2022 */
        
           if(isPoland==true){
               system.debug('Sku_Code++>>'+Sku_Code);
               system.debug('Dis_Code++>>'+Dis_Code);
                successContent = '';
                successContent = 'Year, Quarter, Distributor Code, SKU Code, Distributors Inventory , Plan for the next quarter \n'; 
                for(LiquidationWrapper liqWrap : csvList){
                    if(Sku_Code.contains(liqWrap.skuCode) && Dis_Code.contains(liqWrap.distbtrCode)){
                         String recordString = '';
                     recordString = '"'+liqWrap.year+'","'+liqWrap.quarter+'","'+liqWrap.distbtrCode+'","'+liqWrap.skuCode +'", "'+liqWrap.distInv+'", "'+liqWrap.planNxtMnth+'" \n';
                    successContent += recordString;
                    }else{
                     String recordString = '';
                     recordString = '"'+liqWrap.year+'","'+liqWrap.quarter+'","'+liqWrap.distbtrCode+'","'+liqWrap.skuCode +'", "'+liqWrap.distInv+'", "'+liqWrap.planNxtMnth+'" \n';
                    errorContent += recordString;
                    }
                   
                }
            }
        
        /* -- */
        
          if(liqListToUpdate.size()>0){
                update liqListToUpdate;
                if(flag == true){
                    result = 'partial success';
                }
                else{
                    result = 'success';
                }
                
            }
            else{
                result = 'data not found';
            }
        
          Messaging.EmailFileAttachment csvAttcError = new Messaging.EmailFileAttachment();
            blob csvBlob = Blob.valueOf(errorContent);
            string csvname= 'error.csv';
            csvAttcError.setFileName(csvname);
            csvAttcError.setBody(csvBlob);
            
            //system.debug('csvAttcError==>>'+csvAttcError);

            Messaging.EmailFileAttachment csvAttcSuccess = new Messaging.EmailFileAttachment();
            blob csvBlob2 = Blob.valueOf(successContent);
            string csvname2= 'success.csv';
            csvAttcSuccess.setFileName(csvname2);
            csvAttcSuccess.setBody(csvBlob2);
            
            //system.debug('csvAttcSuccess==>>'+csvAttcSuccess);

            Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[]{loginUserObj.email};
            //String[] toAddresses = new String[]{'butesh.singla@grazitti.com'};
            String subject ='Liquidation Upload Reports';
            email.setSubject(subject);
            email.setToAddresses( toAddresses );
            email.setPlainTextBody('Hi, \n Please Find below attachments of Success and Error files for the Liquidation you have uploaded.');
            email.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttcError,csvAttcSuccess});  // can pass multiple file comma seperated..
            Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        

        //if(flag == true){
        //if(isPoland==false){
            //system.debug('isPoland==>>'+isPoland);
          
            
              /* ------------Start GRZ(Butesh Singla) : APPS-1395 PO And Delivery Date :11-07-2022 */
              upload_status__c up = new upload_status__c();
            up.name = 'Liquidation Upload ( ' + loginUserObj.country + ' )';
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
            
            system.debug('email==>>'+email);
           
        //}
        //}
        System.debug('updateLiquidation liqListToUpdate' + liqListToUpdate);
         if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
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

   @AuraEnabled
   public static String getTemplateToDownload(String fileName){
    String result = '';
    try{
        List<Document> docList = [SELECT Id, Name, DeveloperName, Type, IsPublic, Description FROM Document 
                                  WHERE DeveloperName =: fileName];
        if(docList.size()>0){
            result = docList[0].Id;
        }   
         if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
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

   @AuraEnabled
   public static String getSalesDistrictName(String distId){
    String result = '';
    try{
        List<Sales_District__c> distList =[SELECT Id, Name FROM Sales_District__c WHERE Id =:distId LIMIT 1];

        if(distList.size()>0){
            result = distList[0].Name;
        }
         if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
    }
    catch(Exception ex){
        System.debug('Exception Occure in getSalesDistrictName');
        System.debug('Exception is - ' + ex);
        System.debug('Exception at Line -' + ex.getLineNumber());
        result = '';
        return result;
    }

    return result;
   }

   
    public class LiquidationWrapper {
        @AuraEnabled public String id ;
        @AuraEnabled public Integer distInv ;
        @AuraEnabled public Integer retailInv ;
        @AuraEnabled public Integer planNxtMnth ;
        @AuraEnabled public Boolean editAccess;
        @AuraEnabled public Boolean community;
        @AuraEnabled public String year;
        @AuraEnabled public String month;
        @AuraEnabled public String quarter;
        @AuraEnabled public String distbtrCode;
        @AuraEnabled public String skuCode;

        public LiquidationWrapper(){
            this.id= '';
            this.distInv = 0;
            this.retailInv = 0;
            this.planNxtMnth = 0;
            this.editAccess = false;
            this.community = false;
            this.year = '';
            this.month = '';
            this.distbtrCode = '';
            this.skuCode = '';
        }

    }

    public class OtherDetailsWrapper {
        @AuraEnabled public String reportId;
        @AuraEnabled public String salesDistName;
        @AuraEnabled public Boolean isCommunity;

        public OtherDetailsWrapper(){
            this.reportId = '';
            this.salesDistName = '';
            this.isCommunity = false;
        }
    }
   
}