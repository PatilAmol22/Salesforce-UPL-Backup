public without sharing class ParentChildSkuMappingController {
    @AuraEnabled
    public static List<ParentChildSKUWrapper> getChildSKUList(String prId) {
        List<ParentChildSKUWrapper> pcSKUList = new List<ParentChildSKUWrapper>();
        try{
                List<Product2> productList = new List<Product2>();
                String query = 'SELECT Id, Name, Description, RecordTypeId, RecordType.Name, '+ 
                             +' Product_Code__c, Sales_Org__c, Sales_Org_Code__c, Parent__c, '+ 
                             +' Parent__r.Name, Parent__r.Product_Code__c, Parent__r.Description, '+ 
                             +' Is_Forecast_Required__c, Active__c, IsActive FROM Product2 '+ 
                             +' WHERE RecordType.Name=\'SKU\' AND Is_Forecast_Required__c = false '+ 
                             +' AND Sales_Org__r.Sales_Org_Code__c = \'5191\' ';
                             
                if(prId.length()>0){
                    query += 'AND Id =:prid';
                }
                //system.debug('query - ' + query);
                productList = Database.query(query);                
                //system.debug('productList.size() - ' + productList.size());
                if(productList.size()>0){
                    for(Product2 prod : productList){
                        ParentChildSKUWrapper skuWrap = new ParentChildSKUWrapper();
                        skuWrap.prodId = prod.Id;
                        skuWrap.prodName = prod.Name;
                        skuWrap.prodCode = prod.Product_Code__c;

                        if(prod.Parent__c != null){
                            skuWrap.prodIdParent = prod.Parent__c;
                            skuWrap.prodNameParent = prod.Parent__r.Name+'-'+prod.Parent__r.Product_Code__c;
                            skuWrap.prodCodeParent = prod.Parent__r.Product_Code__c;
                        }
                        else{
                            skuWrap.prodIdParent = '';
                            skuWrap.prodNameParent = '';
                            skuWrap.prodCodeParent = '';
                        }
                        pcSKUList.add(skuWrap);
                    }
                }                             
                //system.debug('pcSKUList.size() - ' + pcSKUList.size());
                //system.debug('pcSKUList - ' + pcSKUList);
        }
        catch(Exception ex){
            system.debug('Exception in getChildSKUList method ');
            system.debug('Exception is - ' + ex);
            system.debug('Exception at Line no  - ' + ex.getLineNumber());
        }
        return pcSKUList;
    }

    @AuraEnabled
    public static string saveMapping(String skuMapping){
        String result ='';
        List<ParentChildSKUWrapper> skuWrapList = new List<ParentChildSKUWrapper>();
        List<Product2> productsToUpdate = new List<Product2>();
        try{
            skuWrapList = (List<ParentChildSKUWrapper>)JSON.deserialize(skuMapping, List<ParentChildSKUWrapper>.class);
            if(skuWrapList.size()>0){
                //System.debug('skuWrapList - '+ JSON.serializePretty(skuWrapList));
                for(ParentChildSKUWrapper sku : skuWrapList){
                    Product2 prod = new Product2();
                    prod.Id = sku.prodId;
                    if(sku.prodIdParent == ''){
                        prod.Parent__c = null;
                    }
                    else{
                        prod.Parent__c = sku.prodIdParent;
                    }
                    productsToUpdate.add(prod);
                }

                if(productsToUpdate.size()>0){
                    update productsToUpdate;
                    result = 'success';
                }

            }
        }
        catch(Exception ex){
            system.debug('Exception in saveMapping method ');
            system.debug('Exception is - ' + ex);
            system.debug('Exception at Line no  - ' + ex.getLineNumber());
        }
        return result;
    }

    @AuraEnabled
    public static string uploadCSV(String skuData){
        String result ='';
        Map<String,Product2> parentMap = new Map<String,Product2>();
        Map<String,Product2> childMap = new Map<String,Product2>();
        List<ParentChildSKUWrapper> skuMap = new List<ParentChildSKUWrapper>();
        List<Product2> productsToUpdate = new List<Product2>();
        
        try{
            String successContent = '';
            String errorContent = '';
            String header = 'Child SKU, Parent SKU, Error ';
            header += ' \n';
            errorContent += header;
            Boolean flag = false;

            skuMap = (List<ParentChildSKUWrapper>)JSON.deserialize(skuData, List<ParentChildSKUWrapper>.class);
            if(skuMap.size()>0){
                List<Product2> listOfSKU = new List<Product2>();
                listOfSKU = [SELECT Id, Name, Product_Code__c, Is_Forecast_Required__c, Parent__c, 
                            Parent__r.Product_Code__c FROM Product2 
                            WHERE RecordType.Name='SKU' AND Sales_Org__r.Sales_Org_Code__c = '5191'];

                if(listOfSKU.size()>0){
                    for(Product2 pro : listOfSKU){
                        if(pro.Is_Forecast_Required__c == true){
                            if(!parentMap.containsKey(pro.Product_Code__c)){
                                parentMap.put(pro.Product_Code__c,pro);
                            }                            
                        }
                        if(pro.Is_Forecast_Required__c == false){
                            if(!childMap.containsKey(pro.Product_Code__c)){
                                childMap.put(pro.Product_Code__c,pro);
                            }
                        }
                    }
                }
                /* System.debug('Parent map - '+ JSON.serializePretty(parentMap));
                System.debug('childMap  - '+ JSON.serializePretty(childMap));
                System.debug('skuMap map - '+ JSON.serializePretty(skuMap)); */

                for(ParentChildSKUWrapper pcsw : skuMap){
                    Product2 prod = new Product2();
                    String parentStr = '';
                    String childStr = '';
                    if(pcsw.prodCode != null || pcsw.prodCode !=''){
                        childStr = appendZero(pcsw.prodCode.length())+pcsw.prodCode;
                    }

                    if(pcsw.prodCodeParent != null || pcsw.prodCodeParent !=''){
                        parentStr = appendZero(pcsw.prodCodeParent.length())+pcsw.prodCodeParent;
                    }
                    
                    if(childMap.containsKey(childStr)){
                        prod.Id = childMap.get(childStr).Id;
                    }
                    else{
                        flag = true;  // Child_SKU_Code_is_not_valid
                        errorContent += '"'+pcsw.prodCode+'","'+pcsw.prodCodeParent+'","'+Label.Child_SKU_Code_is_not_valid+'" \n';
                    }

                    if(pcsw.prodCodeParent == null || pcsw.prodCodeParent == ''){
                        prod.Parent__c = null;
                    }
                    else{
                        if(parentMap.containsKey(parentStr)){
                            prod.Parent__c = parentMap.get(parentStr).Id;
                        }
                        else{
                            flag = true; //Parent_SKU_Code_is_not_valid
                            errorContent += '"'+pcsw.prodCode+'","'+pcsw.prodCodeParent+'","'+Label.Parent_SKU_Code_is_not_valid+'" \n';
                        }
                    }

                    if(flag == false){
                        productsToUpdate.add(prod);
                    }
                    else{
                        break;
                    }
                }

                if(productsToUpdate.size()>0 && flag == false){
                    update productsToUpdate;
                    result = 'success';
                }
                else{
                    result = 'error';
                    Messaging.EmailFileAttachment csvAttcError = new Messaging.EmailFileAttachment();
                    blob csvBlob = Blob.valueOf(errorContent);
                    string csvname= 'error.csv';
                    csvAttcError.setFileName(csvname);
                    csvAttcError.setBody(csvBlob);

                    Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();
                    String[] toAddresses = new list<string> {Label.Email_Sent_to_SalesRep_or_SDM}; // UserInfo.getUserEmail()
                    String subject = Label.Parent_Child_SKU_Mapping_Failed_to_Upload;
                    email.setSubject(subject);
                    email.setToAddresses( toAddresses );
                    email.setPlainTextBody('Olá, \n.'+Label.Please_Find_below_attachments_of_Error_file_for_the_Parent_Child_SKU_Mapping);
                    email.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttcError});  // can pass multiple file comma seperated..
                    Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
                }
                
            }
        }
        catch(Exception ex){
            result = 'exception';
            system.debug('Exception in uploadCSV method ');
            system.debug('Exception is - ' + ex);
            system.debug('Exception at Line no  - ' + ex.getLineNumber());
        }
        return result;
    }

    public static String appendZero(Integer val){
        String str ='';
        if(val != null){
            Integer tot = 18 - val;
            for(Integer i = 0; i < tot; i++){
                str += '0';
            }
        }
        return str;
    }

    public class ParentChildSKUWrapper{
        @AuraEnabled public String prodId {get;set;}
        @AuraEnabled public String prodName {get;set;}
        @AuraEnabled public String prodCode {get;set;}
        @AuraEnabled public String prodCodeParent {get;set;}
        @AuraEnabled public String prodNameParent {get;set;}
        @AuraEnabled public String prodIdParent {get;set;}
    }
}