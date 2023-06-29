/*
     Author: Aarzoo Arora/Rasika
     Name: CompetitiontrackingController
     Description : this class is used for CompetitionTrackingLwc component
    */



public with sharing class CompetitiontrackingController {
    @AuraEnabled(cacheable = false)
    public static Company__c createCompanyRecord(Company__c companyObj) {
        try{
            List<User> createdbyuser = [SELECT Id,City, Country FROM User where Id=:UserInfo.getUserId() Limit 1];
            if(createdbyuser[0].Country=='France'){
                companyObj.Company_France__c = true;
            }
            insert companyObj;
            return companyObj; 
        }
        catch(Exception ex){
            throw new AuraHandledException(ex.getMessage());
        }
    }
    
    @AuraEnabled(cacheable=false)
    public static Brand__c createBrandRecord(Brand__c brandObj,String companyId) {
        try{
            brandObj.Company__c = companyId;
            insert brandObj;
            return brandObj; 
        }
        catch(Exception ex){
            throw new AuraHandledException(ex.getMessage());
        }
    }
    
    @AuraEnabled(cacheable=false)
    public static Formulation__c createFormulationRecord(Formulation__c formulationObj,String brandId) {
        try{
            formulationObj.Brand__c = brandId;
            insert formulationObj;

            BrandFormulation__c obj = new BrandFormulation__c();
            obj.Brand__c = brandId;
            obj.Formulation__c = formulationObj.Id;
            insert obj;
            return formulationObj; 
        }
        catch(Exception ex){
            throw new AuraHandledException(ex.getMessage());
        }
    }
    
    @AuraEnabled(cacheable=false)
    public static Pack_Size__c createPackSizeRecord(Pack_Size__c packSizeObj) {
        try{
            insert packSizeObj;
            return packSizeObj; 
        }
        catch(Exception ex){
            throw new AuraHandledException(ex.getMessage());
        }
    }
    
    @AuraEnabled(cacheable=false)
    public static Crop__c createCropRecord(Crop__c cropObj) {
        try{
            insert cropObj;
            return cropObj; 
        }
        catch(Exception ex){
            throw new AuraHandledException(ex.getMessage());
        }
    }
    
    @AuraEnabled(cacheable=false)
    public static Pest__c createPestRecord(Pest__c pestObj) {
        try{
            insert pestObj;
            return pestObj; 
        }
        catch(Exception ex){
            throw new AuraHandledException(ex.getMessage());
        }
    }
    
    @AuraEnabled(cacheable=false)
    public static Active_Ingredient__c createAIRecord(Active_Ingredient__c aIObj) 
    {
        try{
            insert aIObj;
            return aIObj; 
        }
        catch(Exception ex){
            throw new AuraHandledException(ex.getMessage());
        }
    }
    
    @AuraEnabled(cacheable=false)
    public static Family__c createFamilyRecord(Family__c familyObj,String brandId) {
        try{
            familyObj.Brand__c = brandId;
            insert familyObj;

            BrandFamily__c obj = new BrandFamily__c();
            obj.Brand__c = brandId;
            obj.Family__c = familyObj.Id;
            insert obj;
            return familyObj; 
        }
        catch(Exception ex){
            throw new AuraHandledException(ex.getMessage());
        }
    }
    
    @AuraEnabled(cacheable=false)
    public static Market__c createMarketRecord(Market__c marketObj,String brandId) {
        try{
            marketObj.Brand__c = brandId;
            insert marketObj;

            BrandMarket__c obj = new BrandMarket__c();
            obj.Brand__c = brandId;
            obj.Market__c = marketObj.Id;
            insert obj;
            return marketObj; 
        }
        catch(Exception ex){
            throw new AuraHandledException(ex.getMessage());
        }
    }
    
    @AuraEnabled(cacheable = false)
    public static Competitor_Price__c saveCompetitorDataApex(Competitor_Price__c competitorObj) {
        try{
            String brandid = competitorObj.Brand__c;
            String formulationid = competitorObj.Formulation__c;
            List<BrandFormulation__c> lsttoUpdate = new List<BrandFormulation__c>();
            
            List<BrandFormulation__c> lstquery = [Select id,Brand__c,Formulation__c From BrandFormulation__c Where Brand__c=:brandid AND Formulation__c =: formulationid];
            List<BrandFormulation__c> lstquery2 = [Select id,Brand__c,Formulation__c From BrandFormulation__c Where Brand__c=:brandid AND Formulation__c =: ''];
            
            System.debug('query 1 ' + lstquery.size());  
            System.debug('query 2 ' + lstquery2.size()); 
                       
            if(BrandFormulation__c.SObjectType.getDescribe().isAccessible() && BrandFormulation__c.sObjectType.getDescribe().isCreateable() && lstquery.size()==0 && lstquery2.size()==0)
            {
                System.debug('running 1 insert ' + lstquery.size());   
                BrandFormulation__c obj = new BrandFormulation__c();
                obj.Brand__c = competitorObj.Brand__c;
                obj.Formulation__c = competitorObj.Formulation__c;
            	insert obj;
            }
            else if(BrandFormulation__c.SObjectType.getDescribe().isAccessible() && BrandFormulation__c.sObjectType.getDescribe().isCreateable() && lstquery2.size()>0)
            {
                System.debug('running 1 update ' + lstquery2.size() + '  ');
                
                for(BrandFormulation__c ob1:lstquery2)
                {
                    if(ob1.Brand__c==brandid){
                        BrandFormulation__c obj2 = new BrandFormulation__c();
                        obj2.id = ob1.Id;
                        obj2.Brand__c = ob1.Brand__c;
                        obj2.Formulation__c = formulationid;
                        lsttoUpdate.add(obj2);
                    }
                }
                if(lsttoUpdate.size()>0){
                    update lsttoUpdate;
                }
                
            }
            
            insert competitorObj;
            return competitorObj;  
        }catch(Exception ex){
            throw new AuraHandledException(ex.getMessage());
        }
    }
    
    @AuraEnabled(cacheable = false)
    public static List<Price_Scheme_Detail__c> savePriceSchemeDataApex(List<Price_Scheme_Detail__c> priceSchemeDetailList,String competitorId) {
        ContentDocumentLink contentDocu;
        List<ContentDocumentLink> contenDocumentToInsert = new List<ContentDocumentLink>();
        Set<String> allContentDocumentId = new Set<String>();
        Map<String,String> contenDocumentPriceSchemeMap = new Map<String,String>();
        try{
            for(Price_Scheme_Detail__c obj : priceSchemeDetailList){
                obj.Competitor_Price__c = competitorId;
                
            }
            insert priceSchemeDetailList;
            
            for(Price_Scheme_Detail__c obj : priceSchemeDetailList){
                List<String> contenDocumentId = new List<String>(); 
                if(obj.Content_Documents_Id__c  != null){
                    contenDocumentId = obj.Content_Documents_Id__c.split(',');
                    for(String documentId : contenDocumentId){
                        allContentDocumentId.add(documentId);
                        contenDocumentPriceSchemeMap.put(documentId,obj.Id);
                    }
                }
            }
            for(ContentDocumentLink documents: [SELECT Id, LinkedEntityId, ContentDocumentId, Visibility, IsDeleted, ShareType,
                                                ContentDocument.Title, ContentDocument.createdDate, ContentDocument.FileType
                                                FROM ContentDocumentLink 
                                                WHERE ContentDocumentId IN :allContentDocumentId]){
                                                    if(contenDocumentPriceSchemeMap.containsKey(documents.ContentDocumentId)){
                                                        contentDocu = new ContentDocumentLink();
                                                        contentDocu.LinkedEntityId = contenDocumentPriceSchemeMap.get(documents.ContentDocumentId);
                                                        contentDocu.ContentDocumentId = documents.ContentDocumentId;
                                                        contentDocu.shareType = 'V';
                                                        contenDocumentToInsert.add(contentDocu);
                                                    }
                                                }
            insert contenDocumentToInsert;
            return priceSchemeDetailList; 
            
        }catch(Exception ex){
            System.debug(ex.getMessage());
            throw new AuraHandledException(ex.getMessage());
        }
    }
    
    @AuraEnabled(cacheable = false)
    public static List<Update_Label_Claim__c> saveUpdateLabelClaimDataApex(List<Update_Label_Claim__c> updateClaimList,String competitorId) {
        try{
            for(Update_Label_Claim__c obj: updateClaimList){
                obj.Competitor_Price__c = competitorId;
            }
            insert UpdateClaimList;
            return UpdateClaimList; 
        }catch(Exception ex){
            throw new AuraHandledException(ex.getMessage());
        }
    }
}