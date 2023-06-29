public without sharing class ItalyStockVisibilityController {
    
    @AuraEnabled     
    public static PagedResult getActivities(String salesOrgCode, String distributionChannelCode, String divisionCode,Decimal pageNumber ,Integer recordToDisply, String productSearch, String productIdentification) {  
        System.debug('salesOrgCode : '+salesOrgCode);
        Integer pageSize = recordToDisply;  
        Integer offset = ((Integer)pageNumber - 1) * pageSize; 
        Map<String,SKU__c> skuCodeMap=new  Map<String,SKU__c>();
        List<SKU__c> skustockWrapperList=new List<SKU__c>();
        Id profileId=UserInfo.getProfileId();
        String PName=[Select Id, Name from Profile where Id=:profileId].Name;
        System.debug('PName :'+PName);
        PagedResult obj = new PagedResult();  
        obj.profileName=PName;
        obj.pageSize = pageSize;  
        obj.page = (Integer) pageNumber; 
        obj.total = [SELECT count() FROM SKU__c where Active__c=True And  Dynamic_Inventory_Qty_Italy__c!=null And Sales_Org_Code__c=:salesOrgCode And Distribution_Channel__r.Distribution_Channel_Code__c=:distributionChannelCode And Division__r.Division_Code__c=:divisionCode]; 
        System.debug('recordToDisply ::: ' + recordToDisply);
        String query = '';
         System.debug('productIdentification : '+productIdentification);
        List<SKU__c> listSKU=new List<SKU__c>();
        if(String.isNotBlank(productIdentification)){
          	String productLike='%'+productSearch+'%';
            if(productIdentification.equals('productCode')){
                query = 'SELECT Id, OwnerId, IsDeleted, Name, CurrencyIsoCode, RecordTypeId, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, Combination_Key__c, Group__c, Pack_Size_UOM__c, Pack_Size__c, Product_Name__c, SKU_Code__c, SKU_Description__c, SKU_Pack__c, Sales_Org_Code__c, Sales_Org__c, UOM__c, Active__c, Product_with_SKU__c, Distribution_Channel__c, Division__c, Material_type__c, salesorgDistributionDivision__c,Product_Description__c, Multiple_of__c, GST__c, Brand_Name__c, BrandDescription__c, Product_Category__c, Unit_Cost__c, Weight_Italy__c, pallet_Size_Italy__c, Sales_Agent_MSP__c, Area_Manager_MSP__c, Sales_Director_MSP__c,Available_Stock_Italy__c,Inventory_Description_Italy__c,Dynamic_Inventory_Qty_Italy__c,Inventory_Dynamic_Check_Italy__c,Inventory_order_Flag_Color_Italy__c,Inventory_order_Flag__c FROM SKU__c where Active__c=True And Dynamic_Inventory_Qty_Italy__c!=null And Sales_Org_Code__c=\'' +salesOrgCode+'\' And Distribution_Channel__r.Distribution_Channel_Code__c=\''+distributionChannelCode+'\' And Division__r.Division_Code__c=\''+divisionCode+'\' And SKU_Code__c LIKE \'%'+productLike+'%\' LIMIT '+recordToDisply+' OFFSET '+offset;
            }else if(productIdentification.equals('productName')){
                query = 'SELECT Id, OwnerId, IsDeleted, Name, CurrencyIsoCode, RecordTypeId, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, Combination_Key__c, Group__c, Pack_Size_UOM__c, Pack_Size__c, Product_Name__c, SKU_Code__c, SKU_Description__c, SKU_Pack__c, Sales_Org_Code__c, Sales_Org__c, UOM__c, Active__c, Product_with_SKU__c, Distribution_Channel__c, Division__c, Material_type__c, salesorgDistributionDivision__c,Product_Description__c, Multiple_of__c, GST__c, Brand_Name__c, BrandDescription__c, Product_Category__c, Unit_Cost__c, Weight_Italy__c, pallet_Size_Italy__c, Sales_Agent_MSP__c, Area_Manager_MSP__c, Sales_Director_MSP__c,Available_Stock_Italy__c,Inventory_Description_Italy__c,Dynamic_Inventory_Qty_Italy__c,Inventory_Dynamic_Check_Italy__c,Inventory_order_Flag_Color_Italy__c,Inventory_order_Flag__c FROM SKU__c where Active__c=True And Dynamic_Inventory_Qty_Italy__c!=null And Sales_Org_Code__c=\'' +salesOrgCode+'\' And Distribution_Channel__r.Distribution_Channel_Code__c=\''+distributionChannelCode+'\' And Division__r.Division_Code__c=\''+divisionCode+'\' And SKU_Description__c  LIKE  \'%'+productLike+'%\' LIMIT '+recordToDisply+' OFFSET '+offset;
            }
             System.debug('query 1::: ' + query);
        }else{
            
            System.debug('recordToDisply::: ' + recordToDisply);
            System.debug('offset::: ' + offset);
            query = 'SELECT Id, OwnerId, IsDeleted, Name, CurrencyIsoCode, RecordTypeId, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, Combination_Key__c,Group__c, Pack_Size_UOM__c, Pack_Size__c, Product_Name__c, SKU_Code__c, SKU_Description__c, SKU_Pack__c, Sales_Org_Code__c, Sales_Org__c, UOM__c,Active__c, Product_with_SKU__c, Distribution_Channel__c, Division__c, Material_type__c, salesorgDistributionDivision__c,Product_Description__c, Multiple_of__c, GST__c, Brand_Name__c, BrandDescription__c, Product_Category__c, Unit_Cost__c, Weight_Italy__c, pallet_Size_Italy__c, Sales_Agent_MSP__c, Area_Manager_MSP__c, Sales_Director_MSP__c,Available_Stock_Italy__c,Inventory_Description_Italy__c,Dynamic_Inventory_Qty_Italy__c,Inventory_Dynamic_Check_Italy__c,Inventory_order_Flag_Color_Italy__c,Inventory_order_Flag__c FROM SKU__c where Active__c=True And Dynamic_Inventory_Qty_Italy__c!=null And Sales_Org_Code__c=\'' + salesOrgCode + '\' And Distribution_Channel__r.Distribution_Channel_Code__c=\'' + distributionChannelCode+ '\' And Division__r.Division_Code__c=\'' + divisionCode + '\' ORDER BY SKU_Description__c ASC LIMIT ' + recordToDisply +' OFFSET '+offset; 
            System.debug('query 2::: ' + query);
        }
        obj.results = Database.Query(query); 
        System.debug('obj.results ::: ' + obj.results.size());
        return obj;  
    }  
    
    @AuraEnabled
    public static string updateCSVData(String strfromCSV)
    {
        system.debug('strfromCSV = ' + strfromCSV);
        String returnresponse ='';
        List<String> errorCSVList = new List<String>();
        List<String> successCSVList = new List<String>();
        List<SKU__c> skuUpdateList = new List<SKU__c>();
        Map<String,String> mapStrCombinationKey= new Map<String,String>();
        List<fieldWrapper> datalist = (List<fieldWrapper>) JSON.deserialize(strfromCSV, List<fieldWrapper>.class);
        system.debug('datalist = ' + datalist);
        system.debug('datalistSize = ' + datalist.size());
        
        String combinationKey = '';
        
        List<SKU__c> skuObjList=[Select id, Name, SKU_Code__c, Combination_Key__c from SKU__c Where Sales_Org_Code__c='2410'];//,Multiple_of__c,Unit_Cost__c,Sales_Agent_MSP__c,Area_Manager_MSP__c,Sales_Director_MSP__c,pallet_Size_Italy__c   Where Sales_Org_Code__c='5100'  or Sales_Org_Code__c='5710' or Sales_Org_Code__c='2410'];
        for(SKU__c skuOb:skuObjList){
            String scode=skuOb.SKU_Code__c;
            mapStrCombinationKey.put(skuOb.Combination_Key__c, skuOb.id);
        }
        
        
        String successsListFirstRow='SalesOrgCode,DistributionChannel,Division,SKUCode,ReferenceQuantity,RestrictChange,Inventoryflag,InventoryDescription';
        String errorListFirstRow='SalesOrgCode,DistributionChannel,Division,SKUCode,ReferenceQuantity,RestrictChange,Inventoryflag,InventoryDescription';
        
        successCSVList.add('Record ID,'+successsListFirstRow);
        errorCSVList.add(errorListFirstRow+',Error Description');
        
        if(datalist.size()>0){
         for(Integer j=0; j<datalist.size(); j++){
                            SKU__c sObj =new  SKU__c();
                            String lastFourDigits ='';     //substring containing last 4 characters
                            System.debug('j : '+j);
                            System.debug('datalist[j].salesOrgCode : '+datalist[j].salesOrgCode);
                            //SalesOrg
                            if(String.isNotBlank(datalist[j].salesOrgCode)){
                                combinationKey += datalist[j].salesOrgCode;
                            }
                            //Distribution channel
                            if(String.isNotBlank(datalist[j].distributionChannel)){
                                combinationKey += datalist[j].distributionChannel;
                            }
                            // Division
                            if(String.isNotBlank(datalist[j].division)){
                                combinationKey += datalist[j].division;
                            }
                            //SKU code
                            System.debug('datalist[j].skuCode : '+datalist[j].skuCode);
                            if(String.isNotBlank(datalist[j].skuCode)){
                                String code = datalist[j].skuCode;
                                if(code.length()==6){
                                    code = '000000000000'+datalist[j].skuCode;
                                }
                                else if(code.length()==7){
                                    code = '00000000000'+datalist[j].skuCode;
                                }
                                //System.debug('SKU is valid for this depot');
                                combinationKey += code;
                                System.debug('combinationKey : '+combinationKey);
                                if (combinationKey.length() > 26) 
                                {
                                    lastFourDigits = combinationKey.substring(combinationKey.length() - 26);
                                } 
                                else
                                {
                                    lastFourDigits = combinationKey;
                                }
                                System.debug('lastFourDigits : '+lastFourDigits);
                                System.debug('mapStrCombinationKey.get(combinationKey) : '+mapStrCombinationKey.get(lastFourDigits));
                                if(mapStrCombinationKey.get(lastFourDigits)!=null){
                                    sObj.id=mapStrCombinationKey.get(lastFourDigits);
                                    system.debug('sObj.id>>--->'+sObj.id);
                                }
                            }
                            if(datalist[j].referenceQuantity!=0){
                                sObj.Dynamic_Inventory_Qty_Italy__c =datalist[j].referenceQuantity;
                            }
                            if(String.isNotBlank(datalist[j].restrictChange)){
                            	sObj.Inventory_Dynamic_Check_Italy__c =Boolean.valueOf(datalist[j].restrictChange);
                            }
                            if(String.isNotBlank(datalist[j].inventoryFlag)){
                                sObj.Inventory_flag_Italy__c =datalist[j].inventoryFlag;
                            }
                            if(String.isNotBlank(datalist[j].InventoryDescription)){
                                sObj.Inventory_Description_Italy__c =datalist[j].InventoryDescription;
                            }
                            system.debug('sObj>>--->'+sObj);
                            skuUpdateList.add(sObj);
                            system.debug('skuUpdateList >>--->'+skuUpdateList);
						}
                                            
            }
        
        
        
        Database.SaveResult[] srList;
        system.debug('updateSKUList>>--->'+skuUpdateList);
        if(skuUpdateList.size()>0){
            
            try {
                srList = Database.update(skuUpdateList, false);
                returnresponse = 'SUCCESS';
            }
            catch(Exception ex)
            {
                returnresponse = 'ERROR';
            }
            //Iterate through each returned result
            for(Integer i=0;i<srList.size();i++){
                if (!srList[i].isSuccess()){
                    Database.Error[] errs = srList[i].getErrors();
                    errorCSVList.add(datalist[i].salesOrgCode+','+datalist[i].distributionChannel+','+datalist[i].division+','+datalist[i].skuCode+','+datalist[i].referenceQuantity+','+datalist[i].restrictChange+','+datalist[i].inventoryFlag+','+datalist[i].inventoryDescription+','+errs[0].getMessage());
                }
                else{
                    successCSVList.add(skuUpdateList[i].get('Id')+','+datalist[i].salesOrgCode+','+datalist[i].distributionChannel+','+datalist[i].division+','+datalist[i].skuCode+','+datalist[i].referenceQuantity+','+datalist[i].restrictChange+','+datalist[i].inventoryFlag+','+datalist[i].InventoryDescription);
                }
            }
            
        }
        System.debug('errorCSVList : '+errorCSVList);
        System.debug('successCSVList : '+successCSVList);
        
        sendEmail(String.join(successCSVList, '\r\n'), String.join(errorCSVList, '\r\n'), successCSVList.size(), errorCSVList.size(),'SKUUploadFile');
        return returnresponse;
    }
    
    @AuraEnabled
    public static SKU__c updateSKUItem(SKU__c skuListItem)
    {
        system.debug('skuListItem = ' + skuListItem);
        update skuListItem;
        return skuListItem;  
    }

    
    @AuraEnabled
    public static PagedResult getSkuListItem(String sku_id){
        PagedResult pageResultWrap=new PagedResult();
        if(sku_id!=null){
            String query='';
            query = 'SELECT Id, OwnerId, IsDeleted, Name, CurrencyIsoCode, RecordTypeId, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, Combination_Key__c, Group__c, Pack_Size_UOM__c, Pack_Size__c, Product_Name__c, SKU_Code__c, SKU_Description__c, SKU_Pack__c, Sales_Org_Code__c, Sales_Org__c, UOM__c, Active__c, Product_with_SKU__c, Distribution_Channel__c, Division__c, Material_type__c, salesorgDistributionDivision__c,Product_Description__c, Multiple_of__c, GST__c, Brand_Name__c, BrandDescription__c, Product_Category__c, Unit_Cost__c, Weight_Italy__c, pallet_Size_Italy__c, Sales_Agent_MSP__c, Area_Manager_MSP__c, Sales_Director_MSP__c,Dynamic_Inventory_Qty_Italy__c,Inventory_Dynamic_Check_Italy__c,Inventory_Description_Italy__c,Inventory_flag_Italy__c,Available_Stock_Italy__c,Inventory_order_Flag_Color_Italy__c,Inventory_order_Flag__c FROM SKU__c where Id=\'' +sku_id+'\''; 
            pageResultWrap.results=Database.Query(query);
        }
        return pageResultWrap;
    }
    //Method to Notify User with Success/Error Files after Upload
    public static void sendEmail(String successFile, String errorFile, Integer successCount, Integer errorCount, String SKUUploadFile){
        Messaging.EmailFileAttachment successAttach = new Messaging.EmailFileAttachment();
        successAttach.setContentType('application/csv');
        successAttach.setFileName('Success.csv');
        successAttach.setInline(false);
        successAttach.Body = Blob.valueOf(successFile);
        Messaging.EmailFileAttachment errorAttach = new Messaging.EmailFileAttachment();
        errorAttach.setContentType('application/csv');
        errorAttach.setFileName('Error.csv');
        errorAttach.setInline(false);
        errorAttach.Body = Blob.valueOf(errorFile);
        
        DateTime d = Date.Today() ;
        String dateString =  d.format('dd/MM/yyyy') ;
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setUseSignature(false);
        mail.setToAddresses(new String[] { UserInfo.getUserEmail()});
        
        if(SKUUploadFile=='SKUUploadFile'){
            mail.setSubject('SKU Upload Status');
            mail.setHtmlBody('Dear User,<br /><br />Please find attached files generated in SFDC while uploading the SKU Data<br /><br />Date: '+dateString+'<br /><br />No. of error records: '+errorCount+'<br /><br />Regards,<br/>UPL Salesforce Administrator<br />'); 
        }
        
        mail.setFileAttachments(new Messaging.EmailFileAttachment[] { successAttach, errorAttach}); 
        
        // Send the email
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
  
    public class fieldWrapper {
        @AuraEnabled public String salesOrgCode{get;set;}
        @AuraEnabled public String distributionChannel{get;set;}
        @AuraEnabled public String division{get;set;}
        @AuraEnabled public String skuCode{get;set;}
        @AuraEnabled public Decimal referenceQuantity{get;set;}
        @AuraEnabled public String restrictChange{get;set;}
        @AuraEnabled public String inventoryFlag{get;set;}
        @AuraEnabled public String InventoryDescription{get;set;}
        
    } 
    
    public class PagedResult {  
        @AuraEnabled public Integer pageSize {get;set;}  
        @AuraEnabled public Integer page {get;set;}  
        @AuraEnabled public Integer total {get;set;}  
        @AuraEnabled public String profileName {get;set;}  
        @AuraEnabled public List<SKU__c> results {get;set;}
        @AuraEnabled public List<SKUStockReqWrapper> resultWrapper{get;set;}
        @AuraEnabled public List<Stock_Requirement__c> stockRequirementsList{get;set;}  
    }
    
    public class SKUStockReqWrapper{
        @AuraEnabled public String skuName {get;set;}
        @AuraEnabled public String skuCode {get;set;}
        @AuraEnabled public decimal stockAvailability {get;set;}
        @AuraEnabled public boolean inventoryCheck {get;set;}
        @AuraEnabled public String stockVisibilityStatus {get;set;}
        @AuraEnabled public String inventoryDescription {get;set;}
    }
    
    
}