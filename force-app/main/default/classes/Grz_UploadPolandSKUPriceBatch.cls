public class Grz_UploadPolandSKUPriceBatch implements Database.Batchable<sObject>,Database.AllowsCallouts,Database.Stateful {
	
    private Map<String,Decimal> skuPriceMap;
    private Map<String,List<Opening_Inventory2__c>> skuUpdatedPriceMap = new Map<String,List<Opening_Inventory2__c>>();
    Private Set<String> skuList;
    Private Set<String> skuSet = new Set<String>();
    private String fiscalyear;
    private List<Grz_PolandPOGPriceUpload.OpeningInvWrapper> ItemInfo{get;set;}
        
    public Grz_UploadPolandSKUPriceBatch(Map<String,Decimal> skuPriceMapdata, String year, String csvdata) {
        skuPriceMap = skuPriceMapdata;
        skuList = skuPriceMapdata.keySet();
        fiscalyear = year;
        ItemInfo = (List<Grz_PolandPOGPriceUpload.OpeningInvWrapper>)JSON.deserialize(csvdata, List<Grz_PolandPOGPriceUpload.OpeningInvWrapper>.class);
        System.debug('skuList : '+skuList);
        System.debug('fiscalyear : '+fiscalyear);
        System.debug('ItemInfo : '+ItemInfo);
        
    }
    
    public Database.QueryLocator start(Database.BatchableContext BC){
        //String query = 'SELECT id, Opening_Inventory__c,SKU__r.SKU_Code__c, Liquidation_Annual_Plan__r.Fiscal_year__c FROM Opening_Inventory2__c WHERE SKU__r.Active_for_Liquidation__c = true AND SKU__r.SKU_Code__c IN: combiKeyList AND Liquidation_Annual_Plan__r.Fiscal_year__c =: year';
        System.debug('skuList : '+skuList);
        String salesOrgCode = System.Label.Grz_PolandSalesOrgCode;
        return Database.getQueryLocator('SELECT id, Opening_Inventory__c,SKU__r.SKU_Code__c,SKU_Price_Poland__c,Liquidation_Annual_Plan__r.Fiscal_year__c FROM Opening_Inventory2__c WHERE SKU__r.Active_for_Liquidation__c = true AND Liquidation_Annual_Plan__r.Sales_Org__r.Sales_Org_Code__c =: salesOrgCode AND SKU__r.SKU_Code__c IN: skuList AND Liquidation_Annual_Plan__r.Fiscal_year__c =: fiscalyear');
    }
    
    public void execute(Database.BatchableContext BC, List<Opening_Inventory2__c> scope){
        System.debug('scope : '+scope);
        List<Opening_Inventory2__c> lst_submit = new List<Opening_Inventory2__c>();
        for(Opening_Inventory2__c oi:scope){
            skuSet.add(oi.SKU__r.SKU_Code__c);
            
            if ( !skuUpdatedPriceMap.containsKey(oi.SKU__r.SKU_Code__c) ) {
                skuUpdatedPriceMap.put(oi.SKU__r.SKU_Code__c , new List<Opening_Inventory2__c>{oi});
            } else {
                List<Opening_Inventory2__c> tempJb = skuUpdatedPriceMap.get(oi.SKU__r.SKU_Code__c);
                tempJb.add(oi);
                skuUpdatedPriceMap.put(oi.SKU__r.SKU_Code__c,tempJb );
           }
            System.debug('skuUpdatedPriceMap : '+skuUpdatedPriceMap.size());
            oi.SKU_Price_Poland__c = skuPriceMap.get(oi.SKU__r.SKU_Code__c);
            lst_submit.add(oi);
        }
        if(lst_submit.size()!=0){
            update lst_submit;
        }       
    }
    
    public void finish(Database.BatchableContext BC){
        
        String header = 'Year, SKU Code, Price PLN \n';	
        String headerError = 'Year, SKU Code, Price PLN, Error \n';	
        System.debug('skuPriceMap : '+skuPriceMap);
        
        String successContent = '';
        String errorContent = '';
        errorContent += headerError;
        successContent += header;
        
        if(skuPriceMap != null){
            for(Grz_PolandPOGPriceUpload.OpeningInvWrapper oiWrap : ItemInfo){
                String recordString = '';
                String recordErrorString = '';
                if(skuSet.contains(oiWrap.combKey)){
                    if(oiWrap.price == '0' || oiWrap.price == '0.00'){
                         String errormsg = 'Price not available for this SKU Code';
                    	 recordErrorString = '"'+oiWrap.year+'","'+oiWrap.combKey+'","'+oiWrap.price +'","'+errormsg +'" \n';
                         errorContent += recordErrorString;
                    }else{
                       recordString = '"'+oiWrap.year+'","'+oiWrap.combKey+'","'+oiWrap.price +'" \n';
                       successContent += recordString;  
                    }                  
                }else{
                    String errormsg = 'SKU Not Found';
                    recordErrorString = '"'+oiWrap.year+'","'+oiWrap.combKey+'","'+oiWrap.price +'","'+errormsg +'" \n';
                    errorContent += recordErrorString;
                }                  
            }     
            System.debug('successContent : '+successContent);
            System.debug('errorContent : '+errorContent);
        }
        try{
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
            String[] toAddresses = new list<string> {UserInfo.getUserEmail()};
            //String[] toAddresses = new list<string> {'sumit.kumar@grazitti.com'};
            String subject ='SKUs Price Upload Reports';
            email.setSubject(subject);
            email.setToAddresses( toAddresses );
            email.setPlainTextBody('Hi, \n Please Find below attachments of Success and Error files for the SKUs Prices you have uploaded.');
            email.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttcError,csvAttcSuccess});  // can pass multiple file comma seperated..
            Messaging.SendEmailResult [] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
            
            System.debug('Email results : ' + results);
        }
        catch(Exception ex){
            System.debug('Exception is - ' + ex);
        }
    }
}