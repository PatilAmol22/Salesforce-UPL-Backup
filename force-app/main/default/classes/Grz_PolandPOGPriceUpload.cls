public without sharing class Grz_PolandPOGPriceUpload {
    
	// getting SKU Price Upload Id
    @AuraEnabled
    public static String getOIDetails(){
        String reportId='';
        try{
            String reportName='SKUs_Price_Upload_Template_Poland';
            List<Document> docList = [SELECT Id, Name, DeveloperName, Type, IsPublic, Description FROM Document WHERE DeveloperName =: reportName];
            if(docList.size()>0){
                reportId = docList[0].Id;
            }else{
                reportId = '';
            }
                          
        }
        catch(Exception ex){
            System.debug('Exception in getOIDetails method...');
            System.debug('Exception is - ' + ex);
            System.debug('Exception Line no. - ' + ex.getLineNumber());
            return reportId;
        }
        
        return reportId;
    }
        
    // getting Opening Inventory Records to update
    /*@AuraEnabled
    public static List<Opening_Inventory2__c> getOpeningInvRecords(String combi_key, String year){
        List<Opening_Inventory2__c> oiList = new List<Opening_Inventory2__c>();
        try{ 
            system.debug('combi_key : '+combi_key);
            List<String> combiKeyList = (List<String>)JSON.deserialize(combi_key, List<String>.class) ;  
            System.debug('combiKeyList is - ' + combiKeyList);
            System.debug('year - ' + year);
            oiList = [SELECT id, Opening_Inventory__c,
                      SKU__r.SKU_Code__c,SKU__r.SKU_Description__c, Liquidation_Annual_Plan__r.Fiscal_year__c, Distributor__r.Name,
                      Multi_Country_Formula_Key__c,Distributor__r.sap_code__c  
                      FROM Opening_Inventory2__c WHERE SKU__r.Active_for_Liquidation__c = true AND 
                      SKU__r.SKU_Code__c IN: combiKeyList AND 
                      Liquidation_Annual_Plan__r.Fiscal_year__c =: year];           
        }
        catch(Exception ex){
            System.debug('Exception in getOpeningInvRecords method...');
            System.debug('Exception is - ' + ex);
            System.debug('Exception Line no. - ' + ex.getLineNumber());
            return oiList;
        }
        System.debug('Opening Inventory Records are - '+ oiList);
        return oiList;
    }*/
    
    // Update Opening Inventory Records
    @AuraEnabled
    public static String updateOpeningInv(String oiData,String year){
        String result = '';
        List<Opening_Inventory2__c> oiListToUpdate = new List<Opening_Inventory2__c>();
        System.debug('year : '+year);
        Map<String,Decimal> skuPriceMap = new Map<String,Decimal>();
        try{
            Boolean flag = false;
            
            List<OpeningInvWrapper> oiList = (List<OpeningInvWrapper>)JSON.deserialize(oiData, List<OpeningInvWrapper>.class) ;
            System.debug('oiList is - ' + oiList);
            if(oiList.size()>0){
                for(OpeningInvWrapper oiWrap : oiList){
                    Opening_Inventory2__c oi2 = new Opening_Inventory2__c();
                    //oi2.id = oiWrap.id;
                    skuPriceMap.put(oiWrap.combKey,Decimal.valueOf(oiWrap.price));
                    //oi2.Opening_Inventory__c = Decimal.valueOf(oiWrap.price);
                    oi2.SKU_Price_Poland__c = Decimal.valueOf(oiWrap.price);
                    oiListToUpdate.add(oi2);                   
                }
                System.debug('oiList is - ' + skuPriceMap);
            }
            
            if(skuPriceMap.size()>0){
                result = 'success';
                Grz_UploadPolandSKUPriceBatch shn = new Grz_UploadPolandSKUPriceBatch(skuPriceMap,year,oiData); 
        		database.executeBatch(shn,200); 
            }
                       
            if(oiListToUpdate.size()>0){
                //update oiListToUpdate;                
                result = 'success';               
            }
            else{
                result = 'data not found';
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
    
    
    public class OpeningInvWrapper {
        @AuraEnabled public String id ;
        @AuraEnabled public String combKey;
        @AuraEnabled public String price ;
        @AuraEnabled public String year;
        @AuraEnabled public String distbtrCode;
        @AuraEnabled public String skuCode;
        
        public OpeningInvWrapper(){
            this.id= '';
            this.price = '';
            this.year = '';
            this.distbtrCode = '';
            this.skuCode = '';
        }
        
    }
}