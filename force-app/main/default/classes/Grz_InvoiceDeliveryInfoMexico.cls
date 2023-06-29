public with sharing class Grz_InvoiceDeliveryInfoMexico {
    
    @AuraEnabled(cacheable=true)
    public static ResultWrapper getInvoiceDelivery(String deliveryNumber){
        
        ResultWrapper rw = new ResultWrapper();
        //String token = 'njteEQnhA7NIs3M+QOqZfSqUyHhmIdPmf3Il5lG2C7Y=';
        String token = System.Label.Grz_InvoiceCargoToken;
        String response = Grz_SapIntegration.getInvoiceDeliveryInfoMexico(token,deliveryNumber);       
        if(response.contains('The remission number does not exist')){
            rw.isSuccess = false;
        	rw.Message = 'El número de remisión no existe';
        }else{
            system.debug('response'+response);
            rw = (ResultWrapper) System.JSON.deserialize(response, ResultWrapper.class);    
            rw.isSuccess = true;
            rw.Message = 'Success';          
        }
        System.debug('rw : '+rw);
        return rw;        
    }
    
    @AuraEnabled(cacheable=true)
    public static ResultWrapper getMexicoInvoicePDF(String billingDocNumber){
        
        ResultWrapper rw = new ResultWrapper();
        String sapUserIdMx = System.Label.Grz_SapUserIdMx;
        String companyCodeMx = System.Label.Grz_CompanyCodeMx;
        String response = Grz_SapIntegration.getMexicoInvoicPDF(sapUserIdMx,companyCodeMx,billingDocNumber,'');
        system.debug('response : '+response);
       // response=response.replace('\"Response\":{','');
       // response = response.removeEnd('}');
        if(response.equals('""')){				//response.contains('""')
            rw.isSuccess = false;
        	rw.Message = 'Informacion no disponible';
        	System.debug('rw : '+rw);
        }else{
            system.debug('response'+response);
            rw = (ResultWrapper) System.JSON.deserialize(response, ResultWrapper.class); 
			system.debug('rwelse : '+rw);
            system.debug('rw base : '+rw.item[0].Base64);
            if(String.isBlank(rw.item[0].Base64)){
                rw.isSuccess = false;
        		rw.Message = 'Informacion no disponible';
            }else{
                rw.isSuccess = true;
            	rw.Message = 'Success'; 
            }                    
        }
        System.debug('rw : '+rw);
        return rw;        
    }
     
    public class InvoiceInfo{
        @AuraEnabled
        public String IdRemission{get;set;}
        @AuraEnabled
        public String Status{get;set;} 
        @AuraEnabled
        public String FileBase64{get;set;}
        @AuraEnabled
        public String Extension{get;set;}
        @AuraEnabled
        public String DateDelivery{get;set;}
        @AuraEnabled
        public Item item {get;set;}
        
    }
    
    public class ResultWrapper{
        @AuraEnabled
        public InvoiceInfo DataRemission{get;set;}
        @AuraEnabled
        public InvoiceInfo Response;
        @AuraEnabled
        public List<Item> item {get;set;}
        @AuraEnabled
        public Boolean isSuccess{get;set;} 
        @AuraEnabled
        public String Message{get;set;}
    }
    
    public class Item {       
        @AuraEnabled public String Bukrs{get;set;}
        @AuraEnabled public String Refdoc{get;set;}
        @AuraEnabled public String Base64{get;set;}
    }
    
}